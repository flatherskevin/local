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
- `dev more [--session NAME]`
- `dev --count N`
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

For more terminal room in a workstream, `dev more` opens another Kitty tab of equally
sized terminals backed by a companion session named `<session>+<n>`. Companions persist
when their tab is closed and can be resumed from the `dev more` picker; killing the
parent session with `dev session kill` also removes its companions.

`dev --count N` is a shortcut for `dev more --new --count N`. Where `dev more` may
resume a detached companion from its picker, `dev --count N` always opens a fresh
companion session with exactly N terminal panes. It opens the session in a new Kitty
tab when remote control is available; otherwise, it prints the `tmux attach-session`
command for the ready companion.

## AI Tooling

AI CLIs are optional, not required for a healthy install.

When enabled during bootstrap, the current intended install paths are:

- Claude Code via Anthropic's installer
- Codex via Homebrew cask on macOS

The repo's intended usage pattern is AI beside the editor, not AI instead of
repo inspection. Search the repo, inspect files, and review diffs yourself.

The `omp` agent has a tracked config layer of its own. Install links the
managed half into place and overwrites it on every run:

- `config/omp/core.yml` links to `~/.config/omp/core.yml`
- `config/omp/extensions/session-header.ts` links to
  `~/.omp/agent/extensions/session-header.ts`

The extension draws three rows above the built-in status bar: the full session
name, clickable links to the pull requests and tickets the session actually
acted on, and the working directory with its branch, worktree aware. `core.yml`
leaves the `path` and `git` status-line segments off because that row is now
the extension's job, so treat the two files as a pair.

Each link is glyphed by what the session did to it, so the row is scannable
rather than uniform: the branch's own pull request and any ticket the branch is
named after read as active, a call that changed something reads as editing, a
diff or review reads as reviewing, and a plain lookup reads as a muted
reference. A link only moves up that order, so reading something later never
demotes work already done.

Where the thing's own state is known it takes the glyph instead, because a
merged pull request is merged whoever touched it: a pull request reads as
merged or as building while its checks run, and a ticket reads as done or in
review. Ticket state rides along on tracker replies the session already made,
so it costs nothing extra; pull-request state is a `gh` call, so it is limited
to the work in hand and refreshed on a slow interval.

Anything machine-specific stays untracked and is never committed:

- `~/.config/omp/local.yml` for settings that override `core.yml`
- `~/.omp/agent/mcp.json` for MCP servers, including credential-bearing ones
- `~/.omp/agent/skills/` for machine-local skills
- `~/.omp/agent/AGENTS.md` for machine-local agent instructions

Install seeds `local.yml` and `mcp.json` from `config/omp/local.example.yml`
and `config/omp/mcp.example.json` only when the real file is absent, so your
edits survive updates. Keep per-machine environment variables in `~/.localrc`.
Set `OMP_ISSUE_TRACKER` there to a key from the extension's tracker registry
(`linear` or `jira` today) and `OMP_ISSUE_SITE` to the workspace slug or host
that tracker uses, and the header turns bare ticket identifiers into links.
Leave either unset to skip that part of the row; pull requests still resolve.
Supporting a different tracker is one more entry in the registry.

For the human-facing AI workflow lesson, see
[`../week-4-master/day-1-ai-terminal-workflow.md`](../week-4-master/day-1-ai-terminal-workflow.md).

## Related Canonical Docs

- [`ARCHITECTURE.md`](ARCHITECTURE.md)
- [`DEVELOPMENT.md`](DEVELOPMENT.md)
- [`LEARNINGS.md`](LEARNINGS.md)
