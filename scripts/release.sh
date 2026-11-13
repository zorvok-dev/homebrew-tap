#!/usr/bin/env bash
# Cuts a new zorvok release and publishes it to this Homebrew tap.
#
# What it does, in order: tags zorvok-ios, pushes the tag, waits for
# GitHub to generate the release tarball, computes its real sha256
# (never a locally-computed git-archive guess — GitHub's own archive
# generation doesn't always byte-match that), updates Formula/zorvok.rb,
# lints it, installs it through a real local Homebrew tap and runs its
# test block, then tells you the two commands left to actually publish.
#
# Requires real push access to zorvok-dev/zorvok-ios (to push the tag)
# and, at the end, to zorvok-dev/homebrew-tap (to push this repo) —
# run it from wherever that access actually works for you.
#
# Usage: scripts/release.sh vX.Y.Z [path-to-zorvok-ios-checkout]
#   vX.Y.Z defaults to nothing — always pass it explicitly.
#   path-to-zorvok-ios-checkout defaults to ../zorvok-ios, next to this tap.

set -euo pipefail

VERSION="${1:?usage: scripts/release.sh vX.Y.Z [zorvok-ios-dir]}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ZORVOK_IOS_DIR="${2:-$SCRIPT_DIR/../../zorvok-ios}"
FORMULA="$SCRIPT_DIR/../Formula/zorvok.rb"

if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "version must look like vX.Y.Z (got: $VERSION)" >&2
  exit 1
fi
if [ ! -d "$ZORVOK_IOS_DIR/.git" ]; then
  echo "not a git checkout: $ZORVOK_IOS_DIR — pass the right path as the 2nd argument" >&2
  exit 1
fi
if [ ! -f "$FORMULA" ]; then
  echo "formula not found at $FORMULA — run this from a homebrew-tap checkout" >&2
  exit 1
fi

# Release exactly what's on GitHub's main: not uncommitted changes, and
# not local commits nobody else can see or review.
( cd "$ZORVOK_IOS_DIR" && git fetch -q origin main )
if [ -n "$(cd "$ZORVOK_IOS_DIR" && git status --porcelain)" ]; then
  echo "$ZORVOK_IOS_DIR has uncommitted changes — commit and push them first" >&2
  exit 1
fi
if [ "$(cd "$ZORVOK_IOS_DIR" && git rev-parse HEAD)" != "$(cd "$ZORVOK_IOS_DIR" && git rev-parse origin/main)" ]; then
  echo "$ZORVOK_IOS_DIR isn't at origin/main — check out main and push or pull until they match" >&2
  exit 1
fi

echo "==> Tagging $VERSION on $(cd "$ZORVOK_IOS_DIR" && git rev-parse HEAD) in $ZORVOK_IOS_DIR"
( cd "$ZORVOK_IOS_DIR" && git tag -a "$VERSION" -m "zorvok $VERSION" )

echo "==> Pushing the tag"
( cd "$ZORVOK_IOS_DIR" && git push origin "$VERSION" )

TARBALL_URL="https://github.com/zorvok-dev/zorvok-ios/archive/refs/tags/${VERSION}.tar.gz"
echo "==> Waiting for $TARBALL_URL to become available"
ready=0
for _ in $(seq 1 10); do
  if curl -fsSL --proto '=https' --proto-redir '=https' -o /dev/null "$TARBALL_URL"; then
    ready=1
    break
  fi
  sleep 2
done
if [ "$ready" -ne 1 ]; then
  echo "tarball never became available — check the tag actually pushed" >&2
  exit 1
fi

# -f, so an error page is never hashed into the formula.
SHA256="$(curl -fsSL --proto '=https' --proto-redir '=https' "$TARBALL_URL" | shasum -a 256 | awk '{print $1}')"
echo "==> Real tarball sha256: $SHA256"

sed -i '' \
  -e "s#url \".*\"#url \"$TARBALL_URL\"#" \
  -e "s#sha256 \".*\"#sha256 \"$SHA256\"#" \
  "$FORMULA"

echo "==> Linting the updated formula"
brew style "$FORMULA"

echo "==> Installing through a real local tap, against the real release, to verify"
brew uninstall zorvok >/dev/null 2>&1 || true
brew untap zorvok-dev/tap >/dev/null 2>&1 || true
brew tap zorvok-dev/tap "$SCRIPT_DIR/.."
brew install --build-from-source zorvok-dev/tap/zorvok
brew test zorvok-dev/tap/zorvok
zorvok --version
brew uninstall zorvok
brew untap zorvok-dev/tap

echo
echo "==> Verified. To publish, commit and push this repo:"
echo "    git -C \"$SCRIPT_DIR/..\" commit -am \"zorvok $VERSION\""
echo "    git -C \"$SCRIPT_DIR/..\" push"
