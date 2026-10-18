#!/usr/bin/env bash
# Build the Flutter web app (used by Vercel, also works locally).
#
# Vercel's build image has no Flutter, so when `flutter` isn't on PATH this
# clones the pinned SDK into .flutter-sdk/ (gitignored). Generated code
# (*.g.dart, *.freezed.dart) is committed, so no build_runner step is needed.
#
# Optional environment:
#   FLUTTER             Path to a flutter binary to use instead.
#   FLUTTER_VERSION     SDK tag to clone. Default: 3.47.7 (needs Dart >= 3.13.5).
#   DART_DEFINES        Extra args, e.g. "--dart-define=DEMO_SEED=true".
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.7}"
SDK_DIR="$ROOT/.flutter-sdk"

log() { printf '\033[0;34m[build_web]\033[0m %s\n' "$*"; }

if [ -n "${FLUTTER:-}" ]; then
  :
elif command -v flutter >/dev/null 2>&1; then
  FLUTTER="flutter"
else
  if [ ! -x "$SDK_DIR/bin/flutter" ]; then
    log "Cloning Flutter $FLUTTER_VERSION into .flutter-sdk/"
    git clone --depth 1 --branch "$FLUTTER_VERSION" \
      https://github.com/flutter/flutter.git "$SDK_DIR"
  fi
  FLUTTER="$SDK_DIR/bin/flutter"
fi

"$FLUTTER" config --no-analytics >/dev/null 2>&1 || true
"$FLUTTER" --version
"$FLUTTER" pub get
# shellcheck disable=SC2086
"$FLUTTER" build web --release ${DART_DEFINES:-}
log "Output: build/web"
