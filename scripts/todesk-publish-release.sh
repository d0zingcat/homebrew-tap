#!/usr/bin/env bash
set -euo pipefail

REPO="${GITHUB_REPOSITORY:-d0zingcat/homebrew-tap}"
VERSION="4.9.6.0"
TAG="todesk-${VERSION}"
SHA256="0e04ad706ef3bae0ec1addb7f0b352cad875b5638504ba5183e6bdfb16959ff5"
FILENAME="ToDesk_${VERSION}.pkg"
CASK_FILE="Casks/todesk.rb"

PKG="${1:-${HOME}/Downloads/${FILENAME}}"

if [[ ! -f "${PKG}" ]]; then
  echo "error: pkg not found: ${PKG}" >&2
  exit 1
fi

ACTUAL_SHA256=$(shasum -a 256 "${PKG}" | awk '{print $1}')
if [[ "${ACTUAL_SHA256}" != "${SHA256}" ]]; then
  echo "error: SHA-256 mismatch (expected ${SHA256}, got ${ACTUAL_SHA256})" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI is required" >&2
  exit 1
fi

gh release view "${TAG}" -R "${REPO}" >/dev/null 2>&1 && \
  gh release delete "${TAG}" -R "${REPO}" --yes --cleanup-tag

gh release create "${TAG}" "${PKG}" \
  -R "${REPO}" \
  --title "ToDesk ${VERSION}" \
  --notes "Mirror of ToDesk ${VERSION} macOS pkg for Homebrew cask (official CDN uses CAPTCHA)."

MIRROR_URL="https://github.com/${REPO}/releases/download/${TAG}/${FILENAME}"
echo
echo "Published: ${MIRROR_URL}"
echo
echo "Update ${CASK_FILE} url to:"
echo "  url \"${MIRROR_URL}\","
echo "      verified: \"github.com/${REPO%%/*}/\""
