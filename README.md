# homebrew-tap

The [Homebrew](https://brew.sh) tap for [Zorvok](https://github.com/zorvok-dev/zorvok-ios), a CocoaPods-compatible iOS dependency manager.

```bash
brew tap zorvok-dev/tap
brew install zorvok
```

## Status

`zorvok-ios`'s `v0.1.0` tag is pushed and live (commit `7e5dbdf3de69e52199ebfeaf10d9d7591c08aa6c` — the post-security-review HEAD, not the earlier commit this formula was first drafted against, which predated 28 commits of fixes including the Ruby source-injection fix and the account-takeover auth fix). The formula's `sha256` is the real checksum of that tag's actual GitHub-generated release tarball (`curl -sL .../v0.1.0.tar.gz | shasum -a 256`) — not a locally-computed `git archive` guess, which doesn't always byte-match GitHub's own archive generation.

Verified against the live release, end to end:

- `brew install --build-from-source` — succeeds, builds correctly via `go build` with the version baked in via `-ldflags`.
- `brew test` — passes (`zorvok --version`, `--help`, `doctor` all run cleanly).
- `brew style` — no offenses.

The only thing not yet done is pushing *this* repository to GitHub — see below.

## To actually publish

This repo has no `origin` configured yet. Push it to `github.com/zorvok-dev/homebrew-tap` (the `homebrew-` prefix is required by Homebrew's tap naming convention — this repo must be named exactly that on GitHub for `brew tap zorvok-dev/tap` to work):
```bash
git remote add origin https://github.com/zorvok-dev/homebrew-tap.git
git push -u origin main
```
Then, from a clean machine: `brew tap zorvok-dev/tap && brew install zorvok` should work end to end.

## Updating the formula for a new release

```bash
cd zorvok-ios && git tag vX.Y.Z && git push origin vX.Y.Z
curl -sL https://github.com/zorvok-dev/zorvok-ios/archive/refs/tags/vX.Y.Z.tar.gz | shasum -a 256
# update Formula/zorvok.rb: url -> vX.Y.Z, sha256 -> the value above
brew install --build-from-source zorvok-dev/tap/zorvok  # verify locally before pushing
brew test zorvok-dev/tap/zorvok
brew audit --strict zorvok-dev/tap/zorvok
git commit -am "zorvok vX.Y.Z" && git push
```
