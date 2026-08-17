#!/usr/bin/env bash
# Builds android/app/libs/ZenshieldBox.aar from its public source repo, since
# it is not committed to this repo (see .gitignore) — the compiled artifact
# was ~97MB, too close to GitHub's 100MB single-file push limit to commit
# directly, and not worth a Git LFS bandwidth budget either.
#
# Requirements: Go 1.24+, Android SDK + NDK (ANDROID_HOME / ANDROID_NDK_HOME
# set), and gomobile:
#   go install golang.org/x/mobile/cmd/gomobile@latest
#   go install golang.org/x/mobile/cmd/gobind@latest
#   gomobile init
#
# Usage: android/fetch_native.sh [<tag-or-commit>]
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

echo "==> Building ZenshieldBox.aar with gomobile bind (this takes a while)"
(
  cd "$WORK_DIR/zenshield-singbox-geonode-sdk-patch"
  gomobile bind -v -androidapi=21 \
    -javapkg=com.vpnapp.zenshield.libbox \
    -libname=ZenshieldBox \
    -tags "with_gvisor with_quic with_wireguard with_utls with_clash_api with_grpc with_dhcp with_low_memory with_conntrack" \
    -trimpath \
    -target=android \
    -o "$WORK_DIR/ZenshieldBox.aar" \
    ./experimental/libbox
)

mkdir -p "$ROOT_DIR/android/app/libs"
mv "$WORK_DIR/ZenshieldBox.aar" "$ROOT_DIR/android/app/libs/ZenshieldBox.aar"
if [ -f "$WORK_DIR/ZenshieldBox-sources.jar" ]; then
  mv "$WORK_DIR/ZenshieldBox-sources.jar" "$ROOT_DIR/android/app/libs/ZenshieldBox-sources.jar"
fi

echo "==> Done. Built: $ROOT_DIR/android/app/libs/ZenshieldBox.aar"
