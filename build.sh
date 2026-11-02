#!/bin/sh
# ================================================================================
# SHELL SCRIPT - BUILD AgainNAgain.app (+ zip, dmg)
# ================================================================================
# PROJECT: dpx_again-n-again
# ================================================================================
#
# File: build.sh
# Purpose: Compile src/droplet.applescript into a droplet app, bundle
#          src/make-again.sh inside it, and package dist/ .zip and .dmg.
# Usage:   ./build.sh            build into dist/ (git-ignored)
#          ./build.sh --install  also install into ~/Applications
# Dependencies: macOS (osacompile, PlistBuddy, ditto, hdiutil)
#
# CHANGE LOG: see CHANGELOG.md
#
# ================================================================================
set -eu
cd "$(dirname "$0")"

VERSION=$(cat VERSION)
NAME=AgainNAgain
OUT=dist
APP="$OUT/$NAME.app"
PB=/usr/libexec/PlistBuddy

rm -rf "$OUT"; mkdir -p "$OUT"
osacompile -o "$APP" src/droplet.applescript
cp src/make-again.sh "$APP/Contents/Resources/make-again.sh"
chmod +x "$APP/Contents/Resources/make-again.sh"

P="$APP/Contents/Info.plist"
set_plist() { $PB -c "Set :$1 $2" "$P" 2>/dev/null || $PB -c "Add :$1 string $2" "$P"; }
set_plist CFBundleIdentifier tv.dubpixel.againnagain
set_plist CFBundleName "again-n-again"
set_plist CFBundleShortVersionString "$VERSION"
set_plist CFBundleVersion "$VERSION"
plutil -lint "$P" >/dev/null
# Editing the plist / adding a resource invalidated osacompile's ad-hoc signature;
# re-sign (ad-hoc, no developer ID) so Apple Silicon will still run it.
codesign --force --deep -s - "$APP" 2>/dev/null
codesign --verify --deep "$APP"

ditto -c -k --sequesterRsrc --keepParent "$APP" "$OUT/$NAME-v$VERSION.zip"

STAGE="$OUT/dmg"; mkdir -p "$STAGE"
cp -R "$APP" "$STAGE/"; ln -s /Applications "$STAGE/Applications"
hdiutil create -quiet -volname "again-n-again $VERSION" -srcfolder "$STAGE" -ov -format UDZO "$OUT/$NAME-v$VERSION.dmg"
rm -rf "$STAGE"

if [ "${1:-}" = "--install" ]; then
  mkdir -p "$HOME/Applications"; rm -rf "$HOME/Applications/$NAME.app"
  cp -R "$APP" "$HOME/Applications/"
  echo "Installed: $HOME/Applications/$NAME.app"
fi
echo "Built in $OUT/:"; ls -1 "$OUT"
