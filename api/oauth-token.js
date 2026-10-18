// POST /api/oauth-token — OAuth token proxy for the web build.
//
// The browser does the authorization-code + PKCE redirect itself; this
// function only adds the client secret (which must never ship to the
// browser) when redeeming the code or a refresh token. It stores nothing.
//
// Body (JSON): { provider: "google" | "microsoft",
//                grant_type: "authorization_code", code, code_verifier, redirect_uri }
//           or { provider, grant_type: "refresh_token", refresh_token }
// Response: the provider's token JSON ({ access_token, expires_in,
// refresh_token? }) or { error, error_description } with its status code.
const { config, callbackUrl, tokenEndpoint } = require('./_oauth');

module.exports = async (req, res) => {
  res.setHeader('Cache-Control', 'no-store');
  if (req.method !== 'POST') {
    res.setHeader('Allow', 'POST');
    return res.status(405).json({ error: 'method_not_allowed' });
  }
  const body = typeof req.body === 'string' ? safeJson(req.body) : req.body || {};
  const provider =
    body.provider === 'google' || body.provider === 'microsoft'
      ? config()[body.provider]
      : null;
  if (!provider) {
    return res.status(400).json({
      error: 'not_configured',
      error_description: `OAuth for "${body.provider}" is not configured on this deployment.`,
    });
  }

  const form = new URLSearchParams({
    client_id: provider.clientId,
    client_secret: provider.clientSecret,
    grant_type: body.grant_type,
  });
  if (body.grant_type === 'authorization_code') {
    // Only this deployment's own callback, so the proxy can't be used to
    // redeem codes issued for somewhere else.
    if (!body.code || !body.code_verifier || body.redirect_uri !== callbackUrl(req)) {
      return res.status(400).json({ error: 'invalid_request' });
    }
    form.set('code', body.code);
    form.set('code_verifier', body.code_verifier);
    form.set('redirect_uri', body.redirect_uri);
  } else if (body.grant_type === 'refresh_token' && body.refresh_token) {
    form.set('refresh_token', body.refresh_token);
  } else {
    return res.status(400).json({ error: 'unsupported_grant_type' });
  }

  try {
    const upstream = await fetch(tokenEndpoint(body.provider, provider), {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: form,
    });
    const json = safeJson(await upstream.text()) || { error: 'invalid_response' };
    const { access_token, expires_in, refresh_token, id_token, error, error_description } = json;
    if (!upstream.ok || !access_token) {
      return res
        .status(upstream.ok ? 502 : upstream.status)
        .json({ error: error || 'token_error', error_description });
    }
    // Only what the app needs: the mailbox address (IMAP/SMTP log in with
    // it) instead of the whole id_token, and no scope echo.
    return res
      .status(200)
      .json({ access_token, expires_in, refresh_token, email: emailFromIdToken(id_token) });
  } catch (e) {
    return res.status(502).json({ error: 'network_error', error_description: String(e) });
  }
};

/**
 * Mailbox address from the id_token we just received straight from the
 * provider's token endpoint over TLS (so no signature check is needed).
 * Google: `email`; Microsoft personal/work: `email` or `preferred_username`.
 */
function emailFromIdToken(idToken) {
  if (typeof idToken !== 'string') return null;
  const payload = safeJson(Buffer.from(idToken.split('.')[1] || '', 'base64url').toString('utf8'));
  const email = payload && (payload.email || payload.preferred_username);
  return typeof email === 'string' && email.includes('@') ? email.toLowerCase() : null;
}

function safeJson(text) {
  try {
    return JSON.parse(text);
  } catch {
    return null;
  }
}
