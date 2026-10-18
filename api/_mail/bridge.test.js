// Run: pnpm test
// Integration tests need a local GreenMail (see docs) and
// MAIL_BRIDGE_IT=1 MAIL_BRIDGE_ALLOW_PRIVATE=1; they are skipped otherwise.
const test = require('node:test');
const assert = require('node:assert/strict');
const handler = require('../mail');
const { isPrivateAddress, parseHeaderBlock, checkEndpoint, runOp } = require('./bridge');

test('private and loopback addresses are refused', () => {
  for (const ip of ['127.0.0.1', '10.1.2.3', '192.168.0.4', '172.20.1.1', '169.254.169.254', '::1', 'fd00::1', '::ffff:10.0.0.1']) {
    assert.equal(isPrivateAddress(ip), true, ip);
  }
  for (const ip of ['142.250.4.108', '40.99.10.2', '2607:f8b0::1']) {
    assert.equal(isPrivateAddress(ip), false, ip);
  }
});

test('only mail ports on public hosts', { skip: process.env.MAIL_BRIDGE_ALLOW_PRIVATE === '1' }, async () => {
  await assert.rejects(checkEndpoint('imap.gmail.com', 22, new Set([993])), /Cổng 22/);
  await assert.rejects(checkEndpoint('127.0.0.1', 993, new Set([993])), /công khai/);
  await assert.rejects(checkEndpoint('bad host!', 993, new Set([993])), /không hợp lệ/);
});

test('header blocks are unfolded and lower-cased', () => {
  const h = parseHeaderBlock(Buffer.from('List-Id: <news.x.com>\r\nList-Unsubscribe: <https://x/u>,\r\n <mailto:u@x>\r\n'));
  assert.equal(h['list-id'], '<news.x.com>');
  assert.equal(h['list-unsubscribe'], '<https://x/u>, <mailto:u@x>');
});

test('handler rejects cross-origin calls and maps errors', async () => {
  const call = (req) =>
    new Promise((resolve) => {
      const res = {
        setHeader() {},
        status(code) {
          this.code = code;
          return this;
        },
        json(body) {
          resolve({ code: this.code, body });
        },
      };
      handler({ method: 'POST', headers: { host: 'app.test' }, ...req }, res);
    });
  let r = await call({ headers: { host: 'app.test', origin: 'https://evil.test' }, body: {} });
  assert.equal(r.code, 403);
  r = await call({ body: { op: 'nope' } });
  assert.equal(r.code, 400);
  assert.equal(r.body.error.kind, 'invalid');
});

const it = process.env.MAIL_BRIDGE_IT === '1';
const account = { host: '127.0.0.1', port: 3993, secure: true, user: 'tester@localhost', password: 'pw123' };
const smtp = { host: '127.0.0.1', port: 3465, secure: true };

test('IMAP/SMTP round trip against GreenMail', { skip: !it }, async () => {
  // GreenMail's admin API: start from an empty mailbox (users survive).
  await fetch('http://127.0.0.1:8080/api/mail/purge', { method: 'POST' });
  await runOp({ op: 'verify', account });
  await assert.rejects(runOp({ op: 'verify', account: { ...account, password: 'wrong' } }), (e) => e.kind === 'authentication');

  for (let i = 1; i <= 3; i++) {
    await runOp({
      op: 'send',
      account,
      smtp,
      message: { to: ['tester@localhost'], subject: `Hello ${i}`, text: `Body ${i} ✓`, inReplyTo: i === 3 ? '<orig@x>' : undefined },
    });
  }

  const { folders } = await runOp({ op: 'folders', account });
  const inbox = folders.find((f) => f.role === 'inbox');
  assert.ok(inbox, 'inbox listed');
  assert.equal(inbox.totalCount, 3);
  assert.equal(inbox.unreadCount, 3);

  const first = await runOp({ op: 'headers', account, path: 'INBOX', limit: 2 });
  assert.deepEqual(first.headers.map((h) => h.subject), ['Hello 3', 'Hello 2']);
  assert.equal(first.headers[0].fromEmail, 'tester@localhost');
  assert.equal(first.headers[0].isSeen, false);
  const rest = await runOp({ op: 'headers', account, path: 'INBOX', limit: 2, beforeUid: first.nextBeforeUid });
  assert.deepEqual(rest.headers.map((h) => h.subject), ['Hello 1']);
  assert.equal(rest.nextBeforeUid, null);

  const newest = first.headers[0].uid;
  const incremental = await runOp({ op: 'headers', account, path: 'INBOX', afterUid: newest });
  assert.equal(incremental.headers.length, 0);

  const { text } = await runOp({ op: 'body', account, path: 'INBOX', uid: newest });
  assert.equal(text, 'Body 3 ✓');
  // Body fetch is BODY.PEEK: still unread.
  const again = await runOp({ op: 'headers', account, path: 'INBOX', limit: 1 });
  assert.equal(again.headers[0].isSeen, false);

  await runOp({ op: 'seen', account, path: 'INBOX', uids: [newest], seen: true });
  const seen = await runOp({ op: 'headers', account, path: 'INBOX', limit: 1 });
  assert.equal(seen.headers[0].isSeen, true);

  // Move into a fresh folder and get the new uid back.
  const { ImapFlow } = require('imapflow');
  const c = new ImapFlow({ host: '127.0.0.1', port: 3993, secure: true, auth: { user: account.user, pass: account.password }, logger: false, tls: { rejectUnauthorized: false } });
  await c.connect();
  await c.mailboxCreate('Archive').catch(() => {});
  await c.logout();
  const moved = await runOp({ op: 'move', account, from: 'INBOX', to: 'Archive', uids: [newest] });
  assert.equal(Object.keys(moved.uidMap).length, 1);
  const after = await runOp({ op: 'folders', account });
  assert.equal(after.folders.find((f) => f.role === 'inbox').totalCount, 2);

  await runOp({ op: 'quota', account }); // optional, must not throw
});
