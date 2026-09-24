# Architecture

This repo is two products in one:

- a managed macOS local-development environment centered on Kitty, tmux, Neovim, and zsh
- a structured documentation course for adopting that workflow

The code and docs need to stay aligned because the tutorial is describing the
actual installed environment, not a separate example setup.

## System Shape

The main subsystems are:

- managed installer: `install.sh` stages versioned releases under `~/.flatherskevin/releases`, bootstraps the new release, then atomically repoints `~/.flatherskevin/local`
- bootstrap flow: `bootstrap/macos.sh` installs Homebrew dependencies, optional AI CLIs, TPM, links configs, installs the Neovim stack, and runs validation
- config layer: `config/` contains managed defaults for Neovim, tmux, Kitty, zsh, and the `omp` agent
- helper CLI layer: `scripts/` contains the workflow entrypoints such as `dev`, `cheat`, `leaders`, install helpers, and validation scripts
- curriculum/docs layer: `docs/` is a 4-week learning path plus appendix/reference material
- automation layer: `.github/workflows/` runs CI on PRs and pushes to `main`, and release automation on pushes to `main`

## Runtime Ownership

The runtime model is deliberately split by responsibility:

- Kitty owns the outer terminal UI: windows, tabs, font, window layout, and visible session identity
- tmux owns persistent sessions, pane layout, and session restore behavior
- Neovim owns editing, LSP, formatting, search/navigation, and editor-local UX
- zsh owns shell aliases, helper functions, PATH setup, and optional personal extras

Important repo convention:

- Kitty is the canonical place for session identity
- tmux status stays off
- `dev` is the workflow entrypoint that connects project paths to tmux sessions and Kitty tabs

## Install And Update Lifecycle

The preferred install path is the managed installer:

1. `install.sh` clones a specific ref into a new release directory
2. the new release runs `bootstrap/macos.sh`
3. bootstrap links the managed config into the user's real home directory
4. validation must pass before the managed `local` symlink is switched
5. old releases are pruned, but the current and previous successful releases are kept

This layout exists to make installs rollback-safe and to avoid destructive
in-place replacement of the managed checkout.

`bootstrap/macos.sh` can also be run directly from a local clone for manual
setup, but the managed installer is the canonical long-term update path.

## Configuration Model

The repo separates managed defaults from optional/personal behavior:

- managed defaults live in `config/*`
- optional personal shell extras live in `config/zsh/personal.zsh`
- free-form user overrides live in `~/.localrc`
- managed `omp` agent defaults live in `config/omp/core.yml`, with the session-header extension under `config/omp/extensions/`
- machine-local `omp` settings live in `~/.config/omp/local.yml`, beside the untracked `~/.omp/agent/mcp.json`, `~/.omp/agent/skills/`, and `~/.omp/agent/AGENTS.md`

This boundary matters. Managed config should stay broadly reusable. Personal or
machine-specific shortcuts should not leak back into the base setup unless they
belong to the shared workflow.

The `omp` layer follows the same split through config overlays.
`config/zsh/zshrc` exports `PI_CONFIG_FILES` as a colon-separated list,
`core.yml` first and `local.yml` second, including each file only when it
exists. Precedence runs schema defaults, then the global
`~/.omp/agent/config.yml`, then project config, then the `PI_CONFIG_FILES`
overlays, and later files in that list win.

Two consequences follow. The repo's `core.yml` outranks whatever the running
agent wrote into its own global config, so a setting pinned in `core.yml`
reverts on restart unless `local.yml` overrides it. An overlay file that exists
but is not a YAML mapping is a hard startup error, which is why the seeded
`local.yml` contains an empty mapping.

## Validation And Automation

Validation is split between local scripts and GitHub Actions:

- `scripts/validate-setup.sh` checks required tools, optional tools, Neovim startup, and tmux config load
- `scripts/lint-shell.sh` checks shell script quality
- `scripts/validate-doc-links.py` checks internal markdown links
- `scripts/smoke-test-cli.sh` exercises the lightweight helper CLIs

CI runs on pull requests to `main` and on pushes to `main` using Apple Silicon
macOS runners only. Release automation uses `flatherskevin/semver-action` to
create semver tags and move the matching major tag such as `v1`.

## Related Canonical Docs

- [`USAGE.md`](USAGE.md)
- [`DEVELOPMENT.md`](DEVELOPMENT.md)
- [`LEARNINGS.md`](LEARNINGS.md)
