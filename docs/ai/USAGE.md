# Usage

This document is the canonical operational guide for using this repo and the
environment it installs.

For the human learning path, start at [`../README.md`](../README.md).

## Install Paths

There are two normal install flows:

- remote managed install:
  `curl -fsSL https://raw.githubusercontent.com/flatherskevin/local/main/install.sh | bash`
- local-clone managed install:
  `./scripts/dev install --local`

Use the local-clone path when working on this repo itself and you want your real
setup updated from the current checkout instead of GitHub.

`./bootstrap/macos.sh` is still useful for direct manual setup from a clone, but
it bypasses the managed release lifecycle that `install.sh` provides.

## Validation

After install or when debugging drift:

```bash
source ~/.zshrc
~/.flatherskevin/local/scripts/validate-setup.sh
```

Validation distinguishes between:

- required tools that fail the run when missing
- optional extras such as `claude`, `codex`, `colima`, and `docker`

## Day-To-Day Commands

Primary workflow commands:

- `dev`
- `dev /path/to/project`
- `dev session list [--filter TEXT]`
- `dev session kill -s NAME...`
- `dev --refresh`
- `dev --restart`
- `dev --resume`
- `dev --workspace FILE`
- `cheat`
- `leaders`

Supporting aliases and helpers come from the managed zsh config:

- `v` / `vim` for Neovim
- `lg` for LazyGit
- `tl` for `tmux ls`
- `ta <session>` for tmux attach
- `reload` for re-sourcing shell config

## Session Model

The expected working model is:

- open a project with `dev`
- let `dev` create or attach the tmux session for that project
- keep Neovim in the main pane and shell, tests, git, or AI tools in the others
- use Kitty tabs for multiple top-level sessions or repos

Session naming is deterministic and derived from the project path, so similarly
named repos do not collide.

Kitty tab titles are expected to surface the active tmux session name. tmux
status remains off.

## AI Tooling

AI CLIs are optional, not required for a healthy install.

When enabled during bootstrap, the current intended install paths are:

- Claude Code via Anthropic's installer
- Codex via Homebrew cask on macOS

The repo's intended usage pattern is AI beside the editor, not AI instead of
repo inspection. Search the repo, inspect files, and review diffs yourself.

For the human-facing AI workflow lesson, see
[`../week-4-master/day-1-ai-terminal-workflow.md`](../week-4-master/day-1-ai-terminal-workflow.md).

## Related Canonical Docs

- [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [`DEVELOPMENT.md`](DEVELOPMENT.md)
- [`LEARNINGS.md`](LEARNINGS.md)
