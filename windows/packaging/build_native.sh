#!/usr/bin/env bash
# Builds the two Windows native binaries this app needs from their public
# source repos, since they are not committed to this repo (see .gitignore).
#
# Produces:
#   ./singbox-tunnel.exe          (repo root)
#   ./windows/core/zenshield_core.dll
#
# Requirements: Go 1.24+, and a mingw-w64 cross-compiler for the DLL
# (x86_64-w64-mingw32-gcc) if building from Linux/macOS. On Windows itself,
# set WINDOWS_CC to a suitable gcc/clang target instead.
#
# Usage: windows/packaging/build_native.sh [<tag-or-commit>]
# Pin a specific tag/commit (recommended) instead of using the default
# branch, so builds stay reproducible.

set -euo pipefail

REF="${1:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

WINDOWS_SERVICE_REPO="https://github.com/geonodecom/zenshield-windows-service.git"
SINGBOX_FORK_REPO="https://github.com/geonodecom/zenshield-singbox-geonode-sdk-patch.git"
SINGBOX_UTILS_REPO="https://github.com/geonodecom/zenshield-singbox-utils.git"

clone_ref() {
  local repo="$1" dest="$2"
  if [ -n "$REF" ]; then
    git clone --depth 1 --branch "$REF" "$repo" "$dest"
  else
    git clone --depth 1 "$repo" "$dest"
  fi
}

echo "==> Building singbox-tunnel.exe from zenshield-windows-service"
clone_ref "$WINDOWS_SERVICE_REPO" "$WORK_DIR/tunnel-service"
(
  cd "$WORK_DIR/tunnel-service"
  CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build \
    -tags "with_utls,with_clash_api,with_gvisor" \
    -o "$ROOT_DIR/singbox-tunnel.exe" .
)

echo "==> Building zenshield_core.dll from zenshield-singbox-geonode-sdk-patch"
# go.mod has `replace github.com/npvpn/singboxUtils => ../zenshield-singbox-utils`
# (a local filesystem path, not a fetchable Go module) — that sibling repo
# must sit next to this clone with this exact directory name.
clone_ref "$SINGBOX_FORK_REPO" "$WORK_DIR/zenshield-singbox-geonode-sdk-patch"
clone_ref "$SINGBOX_UTILS_REPO" "$WORK_DIR/zenshield-singbox-utils"
(
  cd "$WORK_DIR/zenshield-singbox-geonode-sdk-patch"
  # go.mod's replace still points at a private pre-open-source repo path;
  # repoint it at the local sibling checkout above.
  go mod edit -replace github.com/npvpn/singboxUtils=../zenshield-singbox-utils
  mkdir -p "$ROOT_DIR/windows/core"
  WINDOWS_CC="${WINDOWS_CC:-x86_64-w64-mingw32-gcc}"
  GOOS=windows GOARCH=amd64 CGO_ENABLED=1 CC="$WINDOWS_CC" go build \
    -trimpath \
    -tags "with_gvisor with_quic with_dhcp with_wireguard with_utls with_acme with_clash_api" \
    -ldflags "-w -s" \
    -buildmode=c-shared \
    -o "$ROOT_DIR/windows/core/zenshield_core.dll" \
    ./experimental/desktop
)

echo "==> Done. Built:"
echo "    $ROOT_DIR/singbox-tunnel.exe"
echo "    $ROOT_DIR/windows/core/zenshield_core.dll"
