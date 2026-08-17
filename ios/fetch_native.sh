#!/usr/bin/env bash
# Builds ios/ZenshieldBox.xcframework from its public source repo, since it
# is not committed to this repo (see .gitignore) — the compiled artifact was
# ~102MB, raw-committed (not even Git LFS), the same repo-bloat problem the
# Android .aar and macOS xcframework had too.
#
# The gomobile bind flags below mirror the upstream Makefile's own `ios:`
# target exactly (package experimental/libbox, target ios,iossimulator,
# same feature tags as Android/macOS, ldflags -s -w) — just renamed to
# ZenshieldBox.xcframework to match what ios/Runner.xcodeproj references.
#
# Requirements: Go 1.24+, Xcode, gomobile — specifically the sagernet/gomobile
# fork the singbox fork's go.mod is pinned to (v0.1.8), not vanilla
# golang.org/x/mobile (macOS host only — gomobile bind for Apple targets
# cannot cross-compile from Linux/Windows):
#   go install github.com/sagernet/gomobile/cmd/gomobile@v0.1.8
#   go install github.com/sagernet/gomobile/cmd/gobind@v0.1.8
#   gomobile init
#
# Usage: ios/fetch_native.sh [<tag-or-commit>]
# Pin a specific tag/commit (recommended) instead of using the default
# branch, so builds stay reproducible.

set -euo pipefail

REF="${1:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

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

echo "==> Cloning zenshield-singbox-geonode-sdk-patch and its sibling dependency"
# go.mod has `replace github.com/npvpn/singboxUtils => ../zenshield-singbox-utils`
# (a local filesystem path, not a fetchable Go module) — that sibling repo
# must sit next to this clone with this exact directory name.
clone_ref "$SINGBOX_FORK_REPO" "$WORK_DIR/zenshield-singbox-geonode-sdk-patch"
clone_ref "$SINGBOX_UTILS_REPO" "$WORK_DIR/zenshield-singbox-utils"

echo "==> Building ZenshieldBox.xcframework with gomobile bind (this takes a while)"
(
  cd "$WORK_DIR/zenshield-singbox-geonode-sdk-patch"
  # go.mod's replace still points at a private pre-open-source repo path;
  # repoint it at the local sibling checkout above.
  go mod edit -replace github.com/npvpn/singboxUtils=../zenshield-singbox-utils
  gomobile bind -v \
    -target=ios,iossimulator \
    -tags "with_gvisor with_quic with_wireguard with_utls with_clash_api with_grpc with_dhcp with_low_memory with_conntrack" \
    -trimpath \
    -ldflags="-s -w" \
    -o "$WORK_DIR/ZenshieldBox.xcframework" \
    ./experimental/libbox
)

rm -rf "$ROOT_DIR/ios/ZenshieldBox.xcframework"
mv "$WORK_DIR/ZenshieldBox.xcframework" "$ROOT_DIR/ios/ZenshieldBox.xcframework"

echo "==> Done. Built: $ROOT_DIR/ios/ZenshieldBox.xcframework"
