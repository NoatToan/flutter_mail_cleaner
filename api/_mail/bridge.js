// IMAP/SMTP bridge for the web build. Browsers can't open IMAP or SMTP
// sockets, so the Flutter web app sends each mailbox operation here and this
// module runs it over a real IMAP (imapflow) or SMTP (nodemailer) connection.
//
// Stateless: every call opens one connection, does one operation and logs
// out. Credentials (app password or OAuth access token) arrive with each
// request, are used for that connection only and are never stored or logged.
// Reads use BODY.PEEK (imapflow's default), so \Seen is never set by a fetch.
const net = require('node:net');
const dns = require('node:dns/promises');
const { ImapFlow } = require('imapflow');
const nodemailer = require('nodemailer');
const { simpleParser } = require('mailparser');

const IMAP_PORTS = new Set([993, 143]);
const SMTP_PORTS = new Set([465, 587]);
const MAX_BODY_BYTES = 4 * 1024 * 1024;
const MAX_SEND_CHARS = 1024 * 1024;
const HEADER_FIELDS = [
  'list-id',
  'list-unsubscribe',
  'list-unsubscribe-post',
  'precedence',
  'auto-submitted',
  'authentication-results',
  'content-type',
];

/** Error with a kind the app maps onto its MailFailure union. */
class BridgeError extends Error {
  constructor(kind, message, status = 400) {
    super(message);
    this.kind = kind; // authentication | network | server | unsupported | invalid
    this.status = status;
  }
}

// ---------------------------------------------------------------- guards

function isPrivateAddress(ip) {
  if (net.isIPv4(ip)) {
    const [a, b] = ip.split('.').map(Number);
    return (
      a === 0 ||
      a === 10 ||
      a === 127 ||
      (a === 100 && b >= 64 && b <= 127) ||
      (a === 169 && b === 254) ||
      (a === 172 && b >= 16 && b <= 31) ||
      (a === 192 && b === 168) ||
      a >= 224
    );
  }
  const v6 = ip.toLowerCase();
  if (v6.startsWith('::ffff:')) return isPrivateAddress(v6.slice(7));
  return (
    v6 === '::' ||
    v6 === '::1' ||
    v6.startsWith('fc') ||
    v6.startsWith('fd') ||
    v6.startsWith('fe80')
  );
}

/**
 * Only public mail servers on mail ports — the bridge must not become a way
 * to reach this platform's internal network. MAIL_BRIDGE_ALLOW_PRIVATE=1
 * (local testing only) lifts the address and port checks and allows an
 * explicit `secure` flag and self-signed certificates.
 */
async function checkEndpoint(host, port, allowedPorts) {
  if (typeof host !== 'string' || !/^[a-z0-9.-]{1,253}$/i.test(host)) {
    throw new BridgeError('invalid', 'Tên máy chủ không hợp lệ.');
  }
  const testMode = process.env.MAIL_BRIDGE_ALLOW_PRIVATE === '1';
  if (!Number.isInteger(port) || (!testMode && !allowedPorts.has(port))) {
    throw new BridgeError(
      'invalid',
      `Cổng ${port} không được hỗ trợ (chỉ ${[...allowedPorts].join(', ')}).`,
    );
  }
  if (testMode) return;
  let addresses;
  try {
    addresses = net.isIP(host)
      ? [{ address: host }]
      : await dns.lookup(host, { all: true });
  } catch {
    throw new BridgeError('network', `Không tìm thấy máy chủ ${host}.`);
  }
  if (addresses.some((a) => isPrivateAddress(a.address))) {
    throw new BridgeError('invalid', 'Máy chủ mail phải là địa chỉ công khai.');
  }
}

/** Implicit TLS on the standard port; [endpoint.secure] only in test mode. */
function implicitTls(endpoint, tlsPort) {
  if (process.env.MAIL_BRIDGE_ALLOW_PRIVATE === '1' && typeof endpoint.secure === 'boolean') {
    return endpoint.secure;
  }
  return Number(endpoint.port) === tlsPort;
}

function credentials(account) {
  if (!account || typeof account.user !== 'string' || !account.user) {
    throw new BridgeError('invalid', 'Thiếu tài khoản.');
  }
  if (account.accessToken) {
    return { user: account.user, accessToken: String(account.accessToken) };
  }
  if (account.password) {
    return { user: account.user, pass: String(account.password) };
  }
  throw new BridgeError('authentication', 'Thiếu mật khẩu hoặc token.');
}

// ------------------------------------------------------------------ IMAP

function toBridgeError(err) {
  if (err instanceof BridgeError) return err;
  if (err && (err.authenticationFailed || /AUTHENTICATIONFAILED|Invalid credentials|LOGIN failed/i.test(`${err.responseText || ''} ${err.message || ''}`))) {
    return new BridgeError(
      'authentication',
      err.responseText || 'Đăng nhập IMAP thất bại.',
      401,
    );
  }
  if (err && /^(ECONNREFUSED|ECONNRESET|ETIMEDOUT|ENOTFOUND|EAI_AGAIN|EHOSTUNREACH|ESOCKET|ETIMEOUT|NoConnection)$/.test(err.code || '')) {
    return new BridgeError('network', err.message || 'Không kết nối được máy chủ mail.', 502);
  }
  return new BridgeError(
    'server',
    (err && (err.responseText || err.response || err.message)) || 'Lỗi máy chủ mail.',
    502,
  );
}

/** Opens an authenticated IMAP session, runs [fn], always logs out. */
async function withImap(account, fn) {
  const port = Number(account && account.port) || 993;
  await checkEndpoint(account && account.host, port, IMAP_PORTS);
  const client = new ImapFlow({
    host: account.host,
    port,
    secure: implicitTls(account, 993),
    doSTARTTLS: port === 143 ? true : undefined,
    auth: credentials(account),
    logger: false,
    disableAutoIdle: true,
    connectionTimeout: 15000,
    greetingTimeout: 15000,
    socketTimeout: 55000,
    tls: { rejectUnauthorized: process.env.MAIL_BRIDGE_ALLOW_PRIVATE !== '1' },
  });
  client.on('error', () => {}); // surfaced through the awaited call instead
  try {
    await client.connect();
    return await fn(client);
  } catch (err) {
    throw toBridgeError(err);
  } finally {
    await client.logout().catch(() => client.close());
  }
}

const ROLE_BY_SPECIAL_USE = {
  '\\Sent': 'sent',
  '\\Trash': 'trash',
  '\\Junk': 'spam',
  '\\Archive': 'archive',
  '\\Drafts': 'drafts',
  '\\All': 'all',
};

function roleOf(box) {
  if (box.path.toUpperCase() === 'INBOX') return 'inbox';
  return ROLE_BY_SPECIAL_USE[box.specialUse] || 'other';
}

async function listFolders(client) {
  const boxes = await client.list({
    statusQuery: { messages: true, unseen: true, uidValidity: true, uidNext: true, highestModseq: true },
  });
  return boxes
    .filter((b) => !b.flags.has('\\Noselect') && !b.flags.has('\\NonExistent'))
    .map((b) => ({
      path: b.path,
      name: b.name,
      role: roleOf(b),
      uidValidity: b.status && b.status.uidValidity != null ? Number(b.status.uidValidity) : null,
      uidNext: (b.status && b.status.uidNext) || null,
      highestModSeq: b.status && b.status.highestModseq != null ? Number(b.status.highestModseq) : null,
      totalCount: (b.status && b.status.messages) || 0,
      unreadCount: (b.status && b.status.unseen) || 0,
    }));
}

/** Unfolds a raw header block into a lower-cased name → value map. */
function parseHeaderBlock(buffer) {
  const out = {};
  if (!buffer) return out;
  const text = buffer.toString('utf8').replace(/\r?\n[ \t]+/g, ' ');
  for (const line of text.split(/\r?\n/)) {
    const i = line.indexOf(':');
    if (i <= 0) continue;
    const name = line.slice(0, i).trim().toLowerCase();
    if (!(name in out)) out[name] = line.slice(i + 1).trim();
  }
  return out;
}

function toHeader(msg) {
  const env = msg.envelope || {};
  const from = (env.from && env.from[0]) || {};
  const h = parseHeaderBlock(msg.headers);
  const date = env.date || msg.internalDate;
  return {
    uid: msg.uid,
    fromEmail: (from.address || '').toLowerCase(),
    fromName: from.name || '',
    toLine: (env.to || []).map((a) => a.address).filter(Boolean).join(', '),
    subject: env.subject || '',
    date: date ? new Date(date).toISOString() : new Date().toISOString(),
    size: msg.size || 0,
    isSeen: msg.flags ? msg.flags.has('\\Seen') : false,
    isFlagged: msg.flags ? msg.flags.has('\\Flagged') : false,
    hasAttachments: (h['content-type'] || '').toLowerCase().includes('multipart/mixed'),
    messageIdHeader: env.messageId || null,
    threadId: msg.threadId || null,
    listId: h['list-id'] || null,
    listUnsubscribe: h['list-unsubscribe'] || null,
    listUnsubscribePost: /one-click/i.test(h['list-unsubscribe-post'] || ''),
    precedence: h['precedence'] || null,
    autoSubmitted: h['auto-submitted'] || null,
    dkimPass: h['authentication-results'] ? /dkim=pass/i.test(h['authentication-results']) : null,
  };
}

/**
 * One page of headers, newest first. [afterUid] = only uids above it
 * (incremental sync); [beforeUid] = continue below the previous page.
 */
async function fetchHeaders(client, { path, afterUid, beforeUid, limit }) {
  const pageSize = Math.min(Math.max(Number(limit) || 200, 1), 500);
  const lock = await client.getMailboxLock(path, { readOnly: true });
  try {
    const mailbox = client.mailbox;
    const after = Number(afterUid) || 0;
    const query = after > 0 ? { uid: `${after + 1}:*` } : { all: true };
    let uids = (await client.search(query, { uid: true })) || [];
    // `N:*` always matches the last message, even below N.
    uids = uids.filter((u) => u > after);
    if (beforeUid) uids = uids.filter((u) => u < Number(beforeUid));
    uids.sort((a, b) => b - a);
    const page = uids.slice(0, pageSize);
    const headers = [];
    if (page.length) {
      for await (const msg of client.fetch(
        page.join(','),
        { uid: true, flags: true, size: true, envelope: true, internalDate: true, threadId: true, headers: HEADER_FIELDS },
        { uid: true },
      )) {
        headers.push(toHeader(msg));
      }
      headers.sort((a, b) => b.uid - a.uid);
    }
    return {
      uidValidity: mailbox && mailbox.uidValidity != null ? Number(mailbox.uidValidity) : null,
      headers,
      nextBeforeUid: uids.length > pageSize ? page[page.length - 1] : null,
    };
  } finally {
    lock.release();
  }
}

async function fetchBody(client, { path, uid }) {
  const lock = await client.getMailboxLock(path, { readOnly: true });
  try {
    const msg = await client.fetchOne(
      String(uid),
      { source: { maxLength: MAX_BODY_BYTES } },
      { uid: true },
    );
    if (!msg || !msg.source) return { text: null };
    const parsed = await simpleParser(msg.source);
    const text = (parsed.text || '').trim();
    return { text: text || null };
  } finally {
    lock.release();
  }
}

function uidList(uids) {
  const list = (Array.isArray(uids) ? uids : []).map(Number).filter((u) => Number.isInteger(u) && u > 0);
  if (!list.length) throw new BridgeError('invalid', 'Thiếu danh sách mail.');
  return list.join(',');
}

async function moveMessages(client, { from, to, uids }) {
  if (typeof to !== 'string' || !to) throw new BridgeError('invalid', 'Thiếu thư mục đích.');
  const lock = await client.getMailboxLock(from);
  try {
    const result = await client.messageMove(uidList(uids), to, { uid: true });
    const uidMap = {};
    if (result && result.uidMap) {
      for (const [oldUid, newUid] of result.uidMap) uidMap[oldUid] = newUid;
    }
    return { uidMap };
  } finally {
    lock.release();
  }
}

async function setSeen(client, { path, uids, seen }) {
  const lock = await client.getMailboxLock(path);
  try {
    const range = uidList(uids);
    if (seen) await client.messageFlagsAdd(range, ['\\Seen'], { uid: true });
    else await client.messageFlagsRemove(range, ['\\Seen'], { uid: true });
    return { ok: true };
  } finally {
    lock.release();
  }
}

async function quota(client) {
  try {
    const q = await client.getQuota('INBOX');
    if (!q || !q.storage || q.storage.limit == null) return { quota: null };
    return { quota: { usedBytes: q.storage.usage || 0, totalBytes: q.storage.limit } };
  } catch {
    return { quota: null }; // QUOTA is optional (and flaky on iCloud).
  }
}

// ------------------------------------------------------------------ SMTP

function addressList(value) {
  const list = (Array.isArray(value) ? value : []).map(String).map((s) => s.trim()).filter(Boolean);
  for (const a of list) {
    if (!/^[^\s@<>]+@[^\s@<>]+$/.test(a)) throw new BridgeError('invalid', `Địa chỉ không hợp lệ: ${a}`);
  }
  return list;
}

async function sendMail(account, smtp, message) {
  const port = Number(smtp && smtp.port) || 465;
  await checkEndpoint(smtp && smtp.host, port, SMTP_PORTS);
  const auth = credentials(account);
  const to = addressList(message && message.to);
  const cc = addressList(message && message.cc);
  if (!to.length) throw new BridgeError('invalid', 'Cần ít nhất một người nhận.');
  const text = String((message && message.text) || '');
  if (text.length > MAX_SEND_CHARS) throw new BridgeError('invalid', 'Nội dung quá dài.');

  const transport = nodemailer.createTransport({
    host: smtp.host,
    port,
    secure: implicitTls(smtp, 465),
    requireTLS: port === 587,
    auth: auth.accessToken
      ? { type: 'OAuth2', user: auth.user, accessToken: auth.accessToken }
      : { user: auth.user, pass: auth.pass },
    connectionTimeout: 15000,
    greetingTimeout: 15000,
    socketTimeout: 45000,
    tls: { rejectUnauthorized: process.env.MAIL_BRIDGE_ALLOW_PRIVATE !== '1' },
  });
  try {
    const info = await transport.sendMail({
      from: message.fromName ? { name: String(message.fromName), address: auth.user } : auth.user,
      to,
      cc: cc.length ? cc : undefined,
      subject: String(message.subject || ''),
      text,
      inReplyTo: message.inReplyTo || undefined,
      references: message.references || message.inReplyTo || undefined,
    });
    return { messageId: info.messageId || null, accepted: info.accepted || [] };
  } catch (err) {
    if (err && (err.code === 'EAUTH' || err.responseCode === 535)) {
      throw new BridgeError('authentication', err.response || 'Đăng nhập SMTP thất bại.', 401);
    }
    if (err && /^(ECONNECTION|ETIMEDOUT|ESOCKET|EDNS)$/.test(err.code || '')) {
      throw new BridgeError('network', err.message, 502);
    }
    throw new BridgeError('server', (err && (err.response || err.message)) || 'Gửi mail thất bại.', 502);
  } finally {
    transport.close();
  }
}

// -------------------------------------------------------------- dispatch

const IMAP_OPS = {
  verify: async () => ({ ok: true }),
  folders: async (client) => ({ folders: await listFolders(client) }),
  headers: fetchHeaders,
  body: fetchBody,
  move: moveMessages,
  seen: setSeen,
  quota,
};

/** Runs one bridge request body: `{op, account, smtp?, ...params}`. */
async function runOp(body) {
  const op = body && body.op;
  if (op === 'send') return sendMail(body.account, body.smtp, body.message);
  const handler = IMAP_OPS[op];
  if (!handler) throw new BridgeError('invalid', `Thao tác không hỗ trợ: ${op}`);
  return withImap(body.account, (client) => handler(client, body));
}

module.exports = { runOp, BridgeError, isPrivateAddress, parseHeaderBlock, checkEndpoint };
