#!/usr/bin/env bash
# Builds macos/zenshieldBox.xcframework from its public source repo, since
# it is not committed to this repo (see .gitignore) — the compiled artifact
# was ~67MB, raw-committed (not even Git LFS), which is exactly the
# repo-bloat problem the Android .aar had too.
#
# Verified working: produces a single macos-arm64_x86_64 slice with the
# expected Libbox-prefixed Objective-C headers, matching what
# macos/Runner.xcodeproj links against (the upstream Makefile's checked-in
# targets don't cover macos, so these flags were reconstructed by matching
# the previously-committed xcframework's structure — re-verify if this
# gomobile bind command is changed).
#
# Requirements: Go 1.24+, Xcode, gomobile — specifically the sagernet/gomobile
# fork the singbox fork's go.mod is pinned to (v0.1.8), not vanilla
# golang.org/x/mobile (macOS host only — gomobile bind for Apple targets
# cannot cross-compile from Linux/Windows):
#   go install github.com/sagernet/gomobile/cmd/gomobile@v0.1.8
#   go install github.com/sagernet/gomobile/cmd/gobind@v0.1.8
#   gomobile init
#
# Usage: macos/fetch_native.sh [<tag-or-commit>]
# Pin a specific tag/commit (recommended) instead of using the default
# branch, so builds stay reproducible.

set -euo pipefail

REF="${1:-}"
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT_XCFRAMEWORK="$ROOT_DIR/macos/zenshieldBox.xcframework"

if [ -d "$OUT_XCFRAMEWORK" ] && [ "${FORCE:-}" != "1" ]; then
  echo "==> $OUT_XCFRAMEWORK already exists, skipping clone+build (set FORCE=1 to rebuild)."
  exit 0
fi

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

echo "==> Building zenshieldBox.xcframework with gomobile bind (this takes a while)"
(
  cd "$WORK_DIR/zenshield-singbox-geonode-sdk-patch"
  # go.mod's replace still points at a private pre-open-source repo path;
  # repoint it at the local sibling checkout above.
  go mod edit -replace github.com/npvpn/singboxUtils=../zenshield-singbox-utils
  gomobile bind -v \
    -target=macos \
    -tags "with_gvisor with_quic with_wireguard with_utls with_clash_api with_grpc with_dhcp with_low_memory with_conntrack" \
    -trimpath \
    -ldflags="-s -w" \
    -o "$WORK_DIR/zenshieldBox.xcframework" \
    ./experimental/libbox
)

rm -rf "$ROOT_DIR/macos/zenshieldBox.xcframework"
mv "$WORK_DIR/zenshieldBox.xcframework" "$ROOT_DIR/macos/zenshieldBox.xcframework"

echo "==> Done. Built: $ROOT_DIR/macos/zenshieldBox.xcframework"
echo "    Verify this matches the framework Xcode expects (name, slices,"
echo "    exported symbols) before shipping a build."
