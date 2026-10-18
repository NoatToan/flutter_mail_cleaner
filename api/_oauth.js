// Shared by the /api/oauth-* functions (files starting with "_" are not
// deployed as routes by Vercel).
const CALLBACK_PATH = '/onboarding/oauth-callback';

/** Providers whose id + secret are both set in the environment. */
function config() {
  const env = process.env;
  const google =
    env.GOOGLE_WEB_CLIENT_ID && env.GOOGLE_WEB_CLIENT_SECRET
      ? { clientId: env.GOOGLE_WEB_CLIENT_ID, clientSecret: env.GOOGLE_WEB_CLIENT_SECRET }
      : null;
  const microsoft =
    env.MICROSOFT_CLIENT_ID && env.MICROSOFT_CLIENT_SECRET
      ? {
          clientId: env.MICROSOFT_CLIENT_ID,
          clientSecret: env.MICROSOFT_CLIENT_SECRET,
          tenant: env.MICROSOFT_TENANT || 'common',
        }
      : null;
  return { google, microsoft };
}

function tokenEndpoint(name, provider) {
  return name === 'google'
    ? 'https://oauth2.googleapis.com/token'
    : `https://login.microsoftonline.com/${encodeURIComponent(provider.tenant)}/oauth2/v2.0/token`;
}

/** https://<this deployment's host>/onboarding/oauth-callback */
function callbackUrl(req) {
  const host = req.headers['x-forwarded-host'] || req.headers.host;
  const proto = req.headers['x-forwarded-proto'] || 'https';
  return `${proto}://${host}${CALLBACK_PATH}`;
}

module.exports = { config, tokenEndpoint, callbackUrl, CALLBACK_PATH };
