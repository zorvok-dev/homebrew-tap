# homebrew-tap

The [Homebrew](https://brew.sh) tap for [Zorvok](https://github.com/zorvok-dev/zorvok-ios), a CocoaPods-compatible iOS dependency manager.

```bash
brew tap zorvok-dev/tap
brew install zorvok
```

## Status

The formula (`Formula/zorvok.rb`) is **built and verified** end to end with `brew install`/`brew test` (not just `go build` by hand) against a tarball built the same way GitHub's own release archives are generated (`git archive`), but not yet publishable: `zorvok-ios` has had its full security/correctness review pass land since the version this was first verified against, so the release needed retargeting at the new HEAD before going out — see below.

- `brew install --build-from-source` — succeeds, builds correctly via `go build` with the version baked in via `-ldflags`.
- `brew test` — passes (`zorvok --version`, `--help`, `doctor` all run cleanly).
- `brew style` — no offenses.

## To actually publish

1. The `v0.1.0` tag already exists locally on `zorvok-ios`, on the current `main` HEAD (commit `7e5dbdf3de69e52199ebfeaf10d9d7591c08aa6c`) — not the earlier commit this formula was first drafted against, which predates 28 commits of fixes including the Ruby source-injection fix and the account-takeover auth fix. Push it:
   ```bash
   cd zorvok-ios
   git push origin v0.1.0
   ```
2. Once the tag is live, verify the formula's `sha256` against the *real* GitHub-generated tarball rather than trusting the locally-computed one in the formula right now — GitHub's archive generation doesn't always byte-match plain `git archive`:
   ```bash
   curl -sL https://github.com/zorvok-dev/zorvok-ios/archive/refs/tags/v0.1.0.tar.gz | shasum -a 256
   ```
   If it differs from the value currently in `Formula/zorvok.rb`, update the formula with the real one before publishing this tap.
3. Push this tap repo to `github.com/zorvok-dev/homebrew-tap` (the `homebrew-` prefix is required by Homebrew's tap naming convention — this repo must be named exactly that on GitHub for `brew tap zorvok-dev/tap` to work). It has no `origin` configured yet:
   ```bash
   git remote add origin https://github.com/zorvok-dev/homebrew-tap.git
   git push -u origin main
   ```
4. From a clean machine: `brew tap zorvok-dev/tap && brew install zorvok` should work end to end.

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
