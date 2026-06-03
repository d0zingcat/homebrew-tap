#!/usr/bin/env bash
set -euo pipefail

VERSION="4.9.6.0"
SHA256="0e04ad706ef3bae0ec1addb7f0b352cad875b5638504ba5183e6bdfb16959ff5"
URL="https://dl.todesk.com/macos/ToDesk_${VERSION}.pkg"
URL_SHA256="ddbcbcd0a7499ac21a8a00c4dfc11751ec4c0c506dc1ad6e6455a5c8faed8e05"
FILENAME="ToDesk_${VERSION}.pkg"
CACHE_DIR="${HOME}/Library/Caches/Homebrew/downloads"
CACHE_FILE="${CACHE_DIR}/${URL_SHA256}--${FILENAME}"

PKG="${1:-${HOME}/Downloads/${FILENAME}}"

if [[ ! -f "${PKG}" ]]
then
  echo "error: pkg not found: ${PKG}" >&2
  echo "Download ${FILENAME} from ${URL} or https://www.todesk.com/download.html in a browser first." >&2
  exit 1
fi

SIZE=$(stat -f%z "${PKG}" 2>/dev/null || stat -c%s "${PKG}")
if [[ "${SIZE}" -lt 1000000 ]]
then
  echo "error: ${PKG} is only ${SIZE} bytes — likely a CAPTCHA HTML page, not the real installer." >&2
  echo "Open https://www.todesk.com/download.html in Safari/Chrome and download again." >&2
  exit 1
fi

ACTUAL_SHA256=$(shasum -a 256 "${PKG}" | awk '{print $1}')
if [[ "${ACTUAL_SHA256}" != "${SHA256}" ]]
then
  echo "error: SHA-256 mismatch." >&2
  echo "  expected: ${SHA256}" >&2
  echo "  actual:   ${ACTUAL_SHA256}" >&2
  echo "If ToDesk released a new build, update Casks/todesk.rb and this script." >&2
  exit 1
fi

mkdir -p "${CACHE_DIR}"
rm -f "${CACHE_FILE}"
cp "${PKG}" "${CACHE_FILE}"

echo "Installed pkg into Homebrew cache:"
echo "  ${CACHE_FILE}"
echo
echo "Running: brew install --cask d0zingcat/tap/todesk"
exec brew install --cask d0zingcat/tap/todesk
