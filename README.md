# Homebrew tap for Zorvok

Install [Zorvok](https://github.com/zorvok-dev/zorvok-ios), the CocoaPods-compatible dependency manager for iOS, with one command:

```bash
brew install zorvok-dev/tap/zorvok
```

Then run `zorvok doctor` to check your setup, and `zorvok install` in any project with a Podfile. You need CocoaPods too (`brew install cocoapods` or `gem install cocoapods`).

| To | Run |
|---|---|
| Update Zorvok | `brew upgrade zorvok` |
| See what's installed | `zorvok --version` |
| Uninstall | `brew uninstall zorvok`, then `brew untap zorvok-dev/tap` |

## Why the long name

Since Homebrew 6.0.0, any formula outside `homebrew-core` must be trusted before Homebrew runs it, because a third-party tap can contain arbitrary Ruby (see [Homebrew's Tap-Trust docs](https://docs.brew.sh/Tap-Trust)). Installing by the fully qualified name, `zorvok-dev/tap/zorvok`, handles that in the same command: Homebrew adds this tap and trusts only the `zorvok` formula, not everything in the tap. No separate `brew trust` step is needed.

`brew tap zorvok-dev/tap` followed by plain `brew install zorvok` also works, but trusts the whole tap rather than one formula.

## How releases are verified

The formula builds from the tagged source tarball GitHub generates for each `zorvok-ios` release (`url` in `Formula/zorvok.rb` names the current one). Its `sha256` is always computed from that real download, never from a local `git archive`, which doesn't byte-match GitHub's own. Before a release is published here, it's installed through a real Homebrew tap from that tarball and run through `brew test` (`zorvok --version`, `--help`, `doctor`) and `brew style`.

## Updating the formula for a new release

```bash
scripts/release.sh vX.Y.Z /path/to/zorvok-ios
```

The script tags `zorvok-ios` and pushes the tag, waits for GitHub's release tarball, computes its real checksum, updates `Formula/zorvok.rb`, lints it, and installs and tests it through a real local tap. Then it tells you to commit and push this repository. Its header comment lists what it needs (push access to both repositories) and exactly what it does.
