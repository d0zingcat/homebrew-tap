# Repository Guidelines

## Project Structure & Module Organization

This repository is a Homebrew tap. Cask definitions live in `Casks/` and should be named after the cask token, for example `Casks/loon4mac.rb` or `Casks/dbx.rb`. GitHub Actions live in `.github/workflows/`: `tests.yml` runs Homebrew validation, `bump.yml` opens automated cask bump PRs from livecheck results, and `publish.yml` handles `brew pr-pull` when a PR receives the `pr-pull` label. `README.md` documents installation and the current cask list.

## Build, Test, and Development Commands

Run checks from the repository root after tapping locally:

```sh
brew tap d0zingcat/tap .
brew audit --cask d0zingcat/tap/dbx
brew audit --cask d0zingcat/tap/loon4mac
brew livecheck --tap d0zingcat/tap
brew test-bot --only-tap-syntax
```

Use `brew install --cask d0zingcat/tap/<token>` for a manual install smoke test. Use `brew uninstall --cask <token>` and review `zap` paths when validating cleanup behavior.

## Coding Style & Naming Conventions

Use standard Homebrew Ruby cask style: two-space indentation, double-quoted strings, cask token in lowercase, and stanza order close to Homebrew conventions (`version`, `sha256`, `url`, `name`, `desc`, `homepage`, `livecheck`, dependencies, artifacts, `zap`, `caveats`). Keep descriptions short and avoid repeating platform names. Prefer structured `arch`, `livecheck`, and `zap trash:` blocks over ad hoc shell logic.

## Testing Guidelines

There are no separate unit tests; validation is through Homebrew tooling. Every cask change should pass `brew audit --cask <token>` and `brew test-bot --only-tap-syntax`. For version updates, also run `brew livecheck --cask <token>` where applicable and confirm the downloaded artifact checksum matches the updated `sha256`.

## Commit & Pull Request Guidelines

Recent history uses concise conventional-style prefixes such as `feat:`, `fix:`, and `bump:`. Follow that pattern, for example `bump: dbx 0.3.0 -> 0.3.1`. Pull requests should describe the cask changed, list the validation commands run, and link the upstream release when bumping versions. For new casks, include install behavior, supported architectures, signing or quarantine caveats, and any required `zap` cleanup paths.

## Security & Configuration Tips

Do not commit tokens, local Homebrew paths, or private release URLs. Verify upstream downloads use stable release URLs and SHA-256 checksums. When adding caveats for unsigned apps, keep instructions specific to the app bundle path.
