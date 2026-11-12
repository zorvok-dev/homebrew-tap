# homebrew-tap

The [Homebrew](https://brew.sh) tap for [Zorvok](https://github.com/zorvok-dev/zorvok-ios), a CocoaPods-compatible iOS dependency manager.

```bash
brew install zorvok-dev/tap/zorvok
```

One command. Since Homebrew 6.0.0, any formula outside `homebrew-core` needs explicit trust before Homebrew will evaluate its Ruby — third-party taps can contain arbitrary code, so this isn't optional and isn't specific to this tap (see [Homebrew's own Tap-Trust docs](https://docs.brew.sh/Tap-Trust)). Installing by this *fully-qualified* name (`user/repo/formula`) satisfies that automatically: Homebrew taps the repo and trusts only this one formula — not a blanket "trust everything in this tap" — in the same command, with no separate step and no `brew trust` to type yourself.

(`brew tap zorvok-dev/tap` followed by plain `brew install zorvok` also works, but trusts the whole tap rather than just this formula — only worth it if you plan to install other formulae from here too.)

To update an existing install: `brew upgrade zorvok`.

## How releases are verified

The formula builds from the tagged source tarball GitHub generates for each `zorvok-ios` release (`url` in `Formula/zorvok.rb` names the current one). Its `sha256` is always computed from that real download, never from a local `git archive`, which doesn't byte-match GitHub's own archive generation. Before a release is published here, it's installed through a real Homebrew tap from that tarball and run through `brew test` (`zorvok --version`, `--help`, `doctor`) and `brew style`.

## Updating the formula for a new release

```bash
scripts/release.sh vX.Y.Z /path/to/zorvok-ios
```
Tags `zorvok-ios`, pushes it, waits for GitHub's release tarball, computes its real checksum, updates `Formula/zorvok.rb`, lints it, and installs + tests it through a real local tap to verify — then tells you to commit and push this repo. See the script's own header comment for what it needs (push access to both repos) and exactly what it does.
