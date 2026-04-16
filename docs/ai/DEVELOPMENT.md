# Development

This document is the canonical guide for changing this repo without introducing
behavior drift between config, scripts, and docs.

## Core Development Rules

Preserve the repo's layer boundaries:

- Kitty owns outer UI
- tmux owns persistent sessions and panes
- Neovim owns editing and language tooling
- zsh owns shell behavior and optional personal additions

Do not collapse those responsibilities into one layer just because a change is
possible in multiple places.

Keep reusable core behavior separate from personal extras. If a change is
machine-specific, cloud-specific, or taste-specific, it usually belongs in the
optional layer rather than the managed default path.

## Main Change Surfaces

Most changes fall into one of these categories:

- installer/bootstrap behavior
- shell/runtime config
- Neovim config and plugin behavior
- helper CLI behavior in `scripts/`
- human docs and curriculum
- CI/release automation

When changing one of these surfaces, check whether the others describe or depend
on that behavior. This repo's most common failure mode is drift between the real
behavior and the tutorial/validator/help output.

## Expected Verification

Default verification for repo changes:

```bash
./scripts/lint-shell.sh
./scripts/validate-doc-links.py
./scripts/smoke-test-cli.sh
./scripts/validate-setup.sh
git diff --check
```

Add focused validation when the change touches a specific subsystem:

- installer changes: validate the managed install flow and its docs
- `dev` changes: validate help output, session commands, and all referenced docs/cheatsheets
- Neovim changes: validate headless startup and any affected lesson content
- workflow changes: validate CI/release logic against the documented policy

## Repo-Specific Development Guidance

When changing install behavior:

- keep installs rollback-safe
- avoid destructive replacement of the active managed release
- keep `README.md`, install docs, and any new helper UX aligned

When changing validation requirements:

- update both the script behavior and any expected-output examples
- keep required vs optional distinctions explicit

When changing AI tooling guidance:

- prefer official/native install paths when they exist
- keep AI tools optional unless the repo truly requires them
- keep the docs honest about what is required versus recommended

When changing `dev`:

- treat it as a workflow entrypoint, not a generic subcommand framework
- keep session behavior readable and deterministic
- update `cheat`, tutorial docs, and any usage examples that mention the command

When changing docs:

- preserve the crawl/walk/run nature of the curriculum
- keep tutorial content aligned with the shipped config and commands
- avoid adding a second conflicting source of truth

## Release And CI Expectations

The current expected automation model is:

- CI runs on PRs to `main` and pushes to `main`
- CI targets Apple Silicon macOS runners only
- release automation runs on pushes to `main`
- versioning uses `flatherskevin/semver-action`
- moving major tags such as `v1` point at the latest release in that major line

## Related Canonical Docs

- [`USAGE.md`](USAGE.md)
- [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [`LEARNINGS.md`](LEARNINGS.md)
