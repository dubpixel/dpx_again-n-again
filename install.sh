#!/bin/sh
# ================================================================================
# SHELL SCRIPT - LOCAL INSTALLER FOR again-n-again
# ================================================================================
# PROJECT: dpx_again-n-again
# ================================================================================
#
# File: install.sh
# Purpose: Build AgainNAgain.app ON THIS MAC and install it to ~/Applications.
#          Built locally, so no download quarantine / Gatekeeper prompt.
# Usage:   curl -fsSL https://raw.githubusercontent.com/dubpixel/dpx_again-n-again/main/install.sh | sh
#          ./install.sh        (from a checkout)
# Dependencies: macOS (curl, osacompile)
#
# ================================================================================
set -eu
BASE="https://raw.githubusercontent.com/dubpixel/dpx_again-n-again/main"
HERE=$(cd "$(dirname "$0")" 2>/dev/null && pwd || true)

if [ -n "$HERE" ] && [ -f "$HERE/build.sh" ] && [ -f "$HERE/src/droplet.applescript" ]; then
  exec sh "$HERE/build.sh" --install
fi

# Piped from curl: fetch the sources into a temp dir and build there.
TMP=$(mktemp -d); trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/src"
for f in VERSION build.sh src/droplet.applescript src/make-again.sh; do
  curl -fsSL "$BASE/$f" -o "$TMP/$f"
done
sh "$TMP/build.sh" --install
open -R "$HOME/Applications/AgainNAgain.app" 2>/dev/null || true
