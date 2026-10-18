// POST /api/mail — IMAP/SMTP bridge for the web build (see api/_mail/bridge.js).
//
// Body (JSON): { op, account: { host, port, user, password | accessToken }, ...params }
//   op = verify | folders | headers | body | move | seen | quota | send
// Response: the op's JSON result, or { error: { kind, message } } where kind
// is authentication | network | server | unsupported | invalid.
const { runOp, BridgeError } = require('./_mail/bridge');

module.exports = async (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).json({ error: { kind: 'invalid', message: 'POST only' } });
  }
  // Same-origin only: the bridge is this app's transport, not a public relay.
  const origin = req.headers.origin;
  const host = req.headers['x-forwarded-host'] || req.headers.host;
  if (origin && host && new URL(origin).host !== host) {
    return res.status(403).json({ error: { kind: 'invalid', message: 'Cross-origin request' } });
  }
  let body = req.body;
  if (typeof body === 'string') {
    try {
      body = JSON.parse(body);
    } catch {
      body = null;
    }
  }
  try {
    return res.status(200).json(await runOp(body || {}));
  } catch (err) {
    const e = err instanceof BridgeError ? err : new BridgeError('server', 'Lỗi không xác định.', 500);
    // Never log the request body: it carries the mailbox credentials.
    return res.status(e.status).json({ error: { kind: e.kind, message: e.message } });
  }
};
