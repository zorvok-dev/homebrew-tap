# homebrew-tap

The [Homebrew](https://brew.sh) tap for [Zorvok](https://github.com/zorvok-dev/zorvok-ios), a CocoaPods-compatible iOS dependency manager.

```bash
brew install zorvok-dev/tap/zorvok
```

One command. Since Homebrew 6.0.0, any formula outside `homebrew-core` needs explicit trust before Homebrew will evaluate its Ruby — third-party taps can contain arbitrary code, so this isn't optional and isn't specific to this tap (see [Homebrew's own Tap-Trust docs](https://docs.brew.sh/Tap-Trust)). Installing by this *fully-qualified* name (`user/repo/formula`) satisfies that automatically: Homebrew taps the repo and trusts only this one formula — not a blanket "trust everything in this tap" — in the same command, with no separate step and no `brew trust` to type yourself.

(`brew tap zorvok-dev/tap` followed by plain `brew install zorvok` also works, but trusts the whole tap rather than just this formula — only worth it if you plan to install other formulae from here too.)

## Status

**Live and verified.** `zorvok-ios`'s `v0.1.0` is tagged and pushed (commit `7e5dbdf3de69e52199ebfeaf10d9d7591c08aa6c` — the post-security-review HEAD, not the earlier commit this formula was first drafted against, which predated 28 commits of fixes including the Ruby source-injection fix and the account-takeover auth fix). The formula's `sha256` is the real checksum of that tag's actual GitHub-generated release tarball — not a locally-computed `git archive` guess, which didn't byte-match GitHub's own archive generation here.

Verified against the real, public, live repositories end to end, from a clean `brew untap`/`brew uninstall`/`brew untrust` state:

- `brew install zorvok-dev/tap/zorvok` — a single command: taps, trusts only this formula, downloads, and builds via `go build` with the version baked in via `-ldflags`.
- `brew test zorvok-dev/tap/zorvok` — passes (`zorvok --version`, `--help`, `doctor` all run cleanly).
- `brew style` — no offenses.

## Updating the formula for a new release

```bash
scripts/release.sh vX.Y.Z /path/to/zorvok-ios
```
Tags `zorvok-ios`, pushes it, waits for GitHub's release tarball, computes its real checksum, updates `Formula/zorvok.rb`, lints it, and installs + tests it through a real local tap to verify — then tells you to commit and push this repo. See the script's own header comment for what it needs (push access to both repos) and exactly what it does.
