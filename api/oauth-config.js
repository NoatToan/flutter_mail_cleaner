// GET /api/oauth-config — public OAuth client ids for the web build.
// Set in Vercel → Project → Settings → Environment Variables (see
// mail_cleaner/docs/OAUTH_WEB.md). A provider without a client id is reported
// as null and its sign-in button stays disabled.
const { config } = require('./_oauth');

module.exports = (req, res) => {
  const { google, microsoft } = config();
  res.setHeader('Cache-Control', 'no-store');
  res.status(200).json({
    google: google ? { clientId: google.clientId } : null,
    microsoft: microsoft
      ? { clientId: microsoft.clientId, tenant: microsoft.tenant }
      : null,
  });
};
