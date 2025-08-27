#!/usr/bin/env bash
set -euo pipefail

# Build script for the oracular wallpapers .deb
# - Creates a clean staging copy (so we never sudo/chown your repo)
# - Normalizes permissions (755 dirs, 644 files)
# - Builds the .deb with root ownership recorded in the archive
# - Optionally runs lintian
#
# Usage:
#   ./build.sh [--pkg-dir PATH] [--out-dir PATH] [--lintian]
#
# Defaults:
#   --pkg-dir   ./oracular-wallpapers-custom
#   --out-dir   ./dist
#
# Notes:
# - Requires: dpkg-deb, rsync
# - Optional: lintian, fakeroot (if dpkg-deb lacks --root-owner-group)

PKG_DIR="./src"
OUT_DIR="./dist"
RUN_LINTIAN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --pkg-dir)   PKG_DIR="$2"; shift 2;;
    --out-dir)   OUT_DIR="$2"; shift 2;;
    --lintian)   RUN_LINTIAN=1; shift;;
    -h|--help)
      sed -n '1,60p' "$0"
      exit 0;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1;;
  esac
done

if [[ ! -d "$PKG_DIR/DEBIAN" ]]; then
  echo "ERROR: '$PKG_DIR' does not look like a Debian package directory (missing DEBIAN/)" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
STAGE="$(mktemp -d)"
cleanup() { rm -rf "$STAGE"; }
trap cleanup EXIT

echo "→ Staging from '$PKG_DIR' ..."
rsync -a --delete --exclude='.git' --exclude='.gitignore' --exclude='.github' "$PKG_DIR/" "$STAGE/"

# Ensure control file has Version and Package
CTRL="$STAGE/DEBIAN/control"
if ! grep -qE '^Package:\s*.+$' "$CTRL"; then
  echo "ERROR: DEBIAN/control missing Package field" >&2
  exit 1
fi
if ! grep -qE '^Version:\s*.+$' "$CTRL"; then
  echo "ERROR: DEBIAN/control missing Version field" >&2
  exit 1
fi

PKG_NAME="$(grep -m1 '^Package:' "$CTRL" | awk '{print $2}')"
VERSION="$(grep -m1 '^Version:' "$CTRL" | awk '{print $2}')"
OUTPUT="${OUT_DIR}/${PKG_NAME}_${VERSION}.deb"

echo "→ Normalizing permissions ..."
# Directories 755, files 644; DEBIAN/* must be 644 (or 755 for maintainer scripts)
find "$STAGE" -type d -exec chmod 755 {} \;
find "$STAGE" -type f -exec chmod 644 {} \;

# Maintainer scripts (if any) must be executable
for script in preinst postinst prerm postrm; do
  if [[ -f "$STAGE/DEBIAN/$script" ]]; then
    chmod 755 "$STAGE/DEBIAN/$script"
  fi
done

echo "→ Building package ${PKG_NAME} ${VERSION} ..."
if dpkg-deb --version 2>/dev/null | grep -q -- '--root-owner-group'; then
  dpkg-deb --build --root-owner-group "$STAGE" "$OUTPUT"
else
  echo "  (dpkg-deb lacks --root-owner-group, using fakeroot)"
  if ! command -v fakeroot >/dev/null 2>&1; then
    echo "ERROR: fakeroot not found and --root-owner-group unsupported by dpkg-deb" >&2
    exit 1
  fi
  fakeroot dpkg-deb --build "$STAGE" "$OUTPUT"
fi

echo "→ Built: $OUTPUT"
echo
echo "Package info:"
dpkg-deb -I "$OUTPUT" | sed 's/^/  /'
echo
echo "Contents:"
dpkg-deb -c "$OUTPUT" | sed 's/^/  /'

if [[ "$RUN_LINTIAN" -eq 1 ]]; then
  if command -v lintian >/dev/null 2>&1; then
    echo
    echo "→ Running lintian ..."
    lintian "$OUTPUT" || true
  else
    echo "lintian not installed; skipping."
  fi
fi

echo
echo "Done."
