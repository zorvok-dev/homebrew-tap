# homebrew-tap

The [Homebrew](https://brew.sh) tap for [Zorvok](https://github.com/zorvok-dev/zorvok-ios), a CocoaPods-compatible iOS dependency manager.

```bash
brew tap zorvok-dev/tap
brew install zorvok
```

## Status

The formula (`Formula/zorvok.rb`) is **built and verified**, but not yet publishable: it points at a GitHub release (`v0.1.0`) that doesn't exist yet, since nothing has been pushed to GitHub. Verified locally instead, against a tarball built the same way GitHub's own release archives are generated (`git archive`):

- `brew install` — succeeds, builds correctly via `go build` with the version baked in via `-ldflags`.
- `brew test` — passes (`zorvok --version`, `--help`, `doctor` all run cleanly).
- `brew audit --strict` — no issues.
- `brew style` — no offenses.

## To actually publish

1. Push `zorvok-dev/zorvok-ios` to GitHub (see that repo's own README).
2. Tag commit `c00512617f09315f26d94d6bb0aeab29208fd3ae` (the exact commit the formula's `sha256` was computed from — the one adding `LICENSE`) as `v0.1.0`, and push the tag:
   ```bash
   cd zorvok-ios
   git tag v0.1.0 c00512617f09315f26d94d6bb0aeab29208fd3ae
   git push origin v0.1.0
   ```
   If you tag a *different* commit, `brew install` will fail with a checksum mismatch — recompute `sha256` from the actual release tarball instead (`curl -sL <url> | shasum -a 256`) and update the formula.
3. Push this tap repo to `github.com/zorvok-dev/homebrew-tap` (the `homebrew-` prefix is required by Homebrew's tap naming convention — this repo must be named exactly that on GitHub for `brew tap zorvok-dev/tap` to work).
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
