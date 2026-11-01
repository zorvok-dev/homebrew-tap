# homebrew-tap

The [Homebrew](https://brew.sh) tap for [Zorvok](https://github.com/zorvok-dev/zorvok-ios), a CocoaPods-compatible iOS dependency manager.

```bash
brew tap zorvok-dev/tap
brew trust --tap zorvok-dev/tap   # required by current Homebrew for any non-core tap
brew install zorvok
```

Homebrew formulae not in `homebrew-core` aren't installable with a single command — current Homebrew requires an explicit, one-time trust step for any third-party tap before it will load formulae from it (`Refusing to load formula ... from untrusted tap`), on top of the tap step itself. This isn't specific to this tap; it's true of every non-core tap (confirmed against `jesseduffield/lazygit`, a well-established tool's own tap, which hits the same requirement).

## Status

**Live and verified.** `zorvok-ios`'s `v0.1.0` is tagged and pushed (commit `7e5dbdf3de69e52199ebfeaf10d9d7591c08aa6c` — the post-security-review HEAD, not the earlier commit this formula was first drafted against, which predated 28 commits of fixes including the Ruby source-injection fix and the account-takeover auth fix). The formula's `sha256` is the real checksum of that tag's actual GitHub-generated release tarball — not a locally-computed `git archive` guess, which didn't byte-match GitHub's own archive generation here.

Verified against the real, public, live repositories end to end, from a clean `brew untap`/`brew uninstall` state:

- `brew tap zorvok-dev/tap` — clones successfully from the public repo.
- `brew trust --tap zorvok-dev/tap` — required before install; documented above.
- `brew install zorvok` — succeeds, builds correctly via `go build` with the version baked in via `-ldflags`.
- `brew test zorvok-dev/tap/zorvok` — passes (`zorvok --version`, `--help`, `doctor` all run cleanly).
- `brew style` — no offenses.

## Updating the formula for a new release

```bash
scripts/release.sh vX.Y.Z /path/to/zorvok-ios
```
Tags `zorvok-ios`, pushes it, waits for GitHub's release tarball, computes its real checksum, updates `Formula/zorvok.rb`, lints it, and installs + tests it through a real local tap to verify — then tells you to commit and push this repo. See the script's own header comment for what it needs (push access to both repos) and exactly what it does.
