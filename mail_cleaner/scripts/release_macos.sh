#!/usr/bin/env bash
# Release AI Smart Mail for macOS (Developer ID path).
#
# Mac App Store builds take a different path: run `flutter build macos --release`,
# open macos/Runner.xcworkspace in Xcode, pick the "3rd Party Mac Developer
# Application" / Installer identities, and use Product → Archive → Distribute App.
# This script does NOT automate the MAS path.
#
# Required environment:
#   MACOS_SIGN_IDENTITY   Full "Developer ID Application: Your Name (TEAMID)" string.
#   NOTARY_PROFILE        notarytool keychain profile name (see `xcrun notarytool store-credentials`).
#   GOOGLE_CLIENT_ID      OAuth client id passed via --dart-define.
#   OUTLOOK_CLIENT_ID     OAuth client id passed via --dart-define.
#
# Optional:
#   APP_NAME              Default: "AI Smart Mail".
#   DIST_DIR              Default: dist (relative to repo root).
#   SKIP_NOTARIZATION     Set to 1 to skip notarize + staple (dev-only DMG).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

APP_NAME="${APP_NAME:-AI Smart Mail}"
DIST_DIR="${DIST_DIR:-dist}"
BUILD_DIR="build/macos/Build/Products/Release"
APP_BUNDLE="${BUILD_DIR}/${APP_NAME}.app"
ENTITLEMENTS="macos/Runner/Release.entitlements"

log()  { printf '\033[0;34m[release]\033[0m %s\n' "$*"; }
die()  { printf '\033[0;31m[release] ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

require() {
  local name="$1"
  # shellcheck disable=SC2086
  if [ -z "${!name:-}" ]; then
    die "env var ${name} is required"
  fi
}

require MACOS_SIGN_IDENTITY
require GOOGLE_CLIENT_ID
require OUTLOOK_CLIENT_ID
if [ "${SKIP_NOTARIZATION:-0}" != "1" ]; then
  require NOTARY_PROFILE
fi

[ -f "${ENTITLEMENTS}" ] || die "entitlements not found: ${ENTITLEMENTS}"
command -v codesign    >/dev/null || die "codesign not on PATH"
command -v xcrun       >/dev/null || die "xcrun not on PATH"
command -v hdiutil     >/dev/null || die "hdiutil not on PATH"
command -v shasum      >/dev/null || die "shasum not on PATH"
command -v flutter     >/dev/null || die "flutter not on PATH"

VERSION="$(awk -F'[ :+]' '/^version:/ {print $2; exit}' pubspec.yaml)"
[ -n "${VERSION}" ] || die "could not read version from pubspec.yaml"
log "version ${VERSION}"

log "flutter clean + pub get"
flutter clean >/dev/null
flutter pub get

log "flutter build macos --release"
flutter build macos --release \
  --dart-define="GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}" \
  --dart-define="OUTLOOK_CLIENT_ID=${OUTLOOK_CLIENT_ID}"

[ -d "${APP_BUNDLE}" ] || die "app bundle not found: ${APP_BUNDLE}"

log "codesign (hardened runtime, Release entitlements)"
# Sign nested frameworks/helpers first, then the app itself.
find "${APP_BUNDLE}/Contents/Frameworks" -type d \
     \( -name "*.framework" -o -name "*.dylib" -o -name "*.app" \) -prune 2>/dev/null | while read -r nested; do
  codesign --force --timestamp --options runtime \
    --sign "${MACOS_SIGN_IDENTITY}" "${nested}"
done
codesign --force --timestamp --options runtime \
  --entitlements "${ENTITLEMENTS}" \
  --sign "${MACOS_SIGN_IDENTITY}" "${APP_BUNDLE}"
codesign --verify --deep --strict --verbose=2 "${APP_BUNDLE}"

mkdir -p "${DIST_DIR}"
ZIP_PATH="${DIST_DIR}/${APP_NAME}-${VERSION}.zip"
DMG_PATH="${DIST_DIR}/${APP_NAME}-${VERSION}.dmg"
rm -f "${ZIP_PATH}" "${DMG_PATH}"

if [ "${SKIP_NOTARIZATION:-0}" = "1" ]; then
  log "SKIP_NOTARIZATION=1 — skipping notarytool + stapler"
else
  log "zip for notarization"
  /usr/bin/ditto -c -k --keepParent "${APP_BUNDLE}" "${ZIP_PATH}"

  log "xcrun notarytool submit --wait (profile ${NOTARY_PROFILE})"
  xcrun notarytool submit "${ZIP_PATH}" \
    --keychain-profile "${NOTARY_PROFILE}" \
    --wait

  log "xcrun stapler staple"
  xcrun stapler staple "${APP_BUNDLE}"
  xcrun stapler validate "${APP_BUNDLE}"
fi

log "build DMG"
STAGING="$(mktemp -d)"
trap 'rm -rf "${STAGING}"' EXIT
/usr/bin/ditto "${APP_BUNDLE}" "${STAGING}/${APP_NAME}.app"
ln -s /Applications "${STAGING}/Applications"

hdiutil create \
  -volname "${APP_NAME} ${VERSION}" \
  -srcfolder "${STAGING}" \
  -ov -format UDZO \
  "${DMG_PATH}"

if [ "${SKIP_NOTARIZATION:-0}" != "1" ]; then
  log "codesign + staple DMG"
  codesign --force --timestamp --sign "${MACOS_SIGN_IDENTITY}" "${DMG_PATH}"
  xcrun stapler staple "${DMG_PATH}"
fi

log "checksum"
(cd "${DIST_DIR}" && shasum -a 256 "$(basename "${DMG_PATH}")" > "$(basename "${DMG_PATH}").sha256")

log "done:"
log "  app : ${APP_BUNDLE}"
log "  dmg : ${DMG_PATH}"
log "  sha : ${DMG_PATH}.sha256"
