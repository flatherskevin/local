# `dev more` design

Date: 2026-06-30

## Summary

Add a `dev more` subcommand to `scripts/dev` that opens a new kitty tab containing
several equally proportioned terminal panes tied to an existing workstream. The new
tab does not mirror the parent's nvim layout; it is a fresh scratch space backed by
its own tmux "companion" session that is namespaced to the parent.

## Motivation

The current `dev` layout gives one kitty tab per workstream with an nvim pane and two
terminals (`main-vertical`). When working on several things at once, that is not
enough terminal room. We want to spin up extra kitty tabs of terminals that belong to
the same workstream, without disturbing the primary nvim layout and without the tmux
mirroring problem described below.

## Key constraint: tmux client mirroring

Two clients (two kitty tabs) attached to the *same* tmux session always show the same
active window and the same panes, and the window is resized down to the smaller of the
two clients. A naive "attach a second kitty tab to the parent session" therefore shows
a copy of the nvim layout, not fresh terminals. To get independent content per tab we
use a separate tmux session per extra tab (a "companion" session), namespaced to the
parent. This avoids mirroring and resize coupling entirely.

## Command surface

```
dev more [--session <parent-id>] [--count N] [--new]
```

- `--session <id>`: the parent session, for example `repo-56e811`. Optional when run
  from inside the workstream (see "Target resolution").
- `--count N`: number of panes in the new tab. Default 4, laid out as an equal `tiled`
  grid.
- `--new`: skip the picker and force a brand-new companion even when resumable ones
  exist.

## Session and naming model

Companions are real tmux sessions named `<parent>+<n>`, for example `repo-56e811+1`.
The `+` character is tmux-safe; tmux session names only forbid `.` and `:`.

A new companion claims the **lowest free slot**: the smallest integer `n` for which no
session named `<parent>+<n>` exists. Killed slots are reused, so the numbers stay small
and predictable.

The kitty tab title is set to the companion name, matching how the parent tab is
titled today, so the id can be read back off the tab.

## The flow (new vs. resume)

On `dev more`:

1. Resolve the parent (see "Target resolution").
2. List that parent's **detached** companions by filtering `tmux ls` to names matching
   `^<parent>+<n>$`.
3. If none are detached, or `--new` was passed: create the next companion, build the
   panes, and open a kitty tab attached to it.
4. If some exist: open an fzf picker with `New companion (+N)` preselected at the top
   and the detached companions listed below, each with a preview of what is running in
   it (`tmux list-panes` plus a short `capture-pane` peek). Pressing Enter creates a new
   companion; selecting an existing one resumes it in a fresh tab.

## Layout

Build the companion detached, then split and tile:

1. `tmux new-session -d -s "<companion>" -c "<project>"` for the first pane.
2. `--count - 1` calls to `tmux split-window -c "<project>"`.
3. `tmux select-layout -t "<companion>:1" tiled` for an equal grid.
4. `tmux set-hook -t "<companion>" window-resized "select-layout tiled"` so the grid
   stays balanced on resize.

This mirrors the self-healing layout pattern the parent already uses with
`main-vertical`. Companions contain only terminals; there is no nvim pane.

## Target resolution

If `--session` is omitted and we are inside tmux, derive the parent from the current
session name by stripping any trailing `+<n>` suffix. This lets `dev more` work both
from the parent tab and from inside a companion (to spawn a sibling). If `--session` is
given, validate that it names a real session and exit non-zero with a clear message if
not.

## Project directory resolution

Companion panes must open in the parent's project directory, but the session name is a
one-way hash of that path and cannot be reversed. The script already solves this in
`--restart`, which reads a session's working directory with
`tmux display-message -p '#{session_path}'`. Reuse that established pattern: resolve the
parent's project directory with `tmux display-message -p -t "<parent>" '#{session_path}'`.

This needs no change to `create_session`, since the parent session is created with
`-c "<project>"` and `#{session_path}` reports that directory (verified on tmux 3.6a).
If the value is ever empty, fall back to the parent's active `#{pane_current_path}`.

## Lifecycle and cleanup

- Closing a companion tab (cmd+w) leaves its tmux session running detached, so it
  appears in the picker next time. This is the persistent model.
- `dev session kill <parent>` cascades to also kill `<parent>+<n>` companions, so
  ending a workstream takes its scratch terminals with it.
- `dev session list` groups companions under their parent in the listing.
- On reboot, tmux-continuum restores companions as detached sessions. Kitty tabs are
  not reopened automatically because continuum only restores tmux state. The picker
  surfaces the restored companions so any can be brought back. This is consistent with
  the persistent model and is documented so it is not surprising.

## Edge cases and graceful degradation

- Not running under kitty, or kitty remote control unavailable: still build the
  session, then print the `tmux attach-session -t <companion>` command instead of
  opening a tab, with a clear note.
- `--session` names a nonexistent session: error and exit non-zero.
- `--count` less than 1: reject with a message.

## Testing

The repo has no unit-test framework; its only automated check is
`scripts/smoke-test-cli.sh` (runs `--help` on each command), plus `shellcheck` via
`scripts/lint-shell.sh` and a doc-link validator. Tests for this feature follow that
plain-bash style:

- Add a `BASH_SOURCE` guard before the dispatch block in `scripts/dev` so the file can
  be sourced (to load its functions) without running the command.
- Add `scripts/test-dev-more.sh` (same plain-bash assertion style as
  `smoke-test-cli.sh`). It sources `scripts/dev` and unit-tests the pure helpers:
  companion-name formatting, parent-from-companion-name parsing, lowest-free-slot
  allocation (stubbing `list_sessions`), and picker-selection parsing.
- The same script includes a tmux-backed check, guarded by `command -v tmux`, that
  creates a parent plus a companion and asserts the pane count and that the layout is
  `tiled`. It is skipped when tmux is unavailable.

## Files touched

- `scripts/dev`: a `BASH_SOURCE` guard so the file is sourceable for tests; new `more`
  subcommand and helpers; cascade in `session kill`; grouping in `session list`;
  updated `usage()` help text.
- `scripts/test-dev-more.sh`: new test script for the pure helpers plus the tmux-backed
  layout check.
- `scripts/cheat` and `docs/ai/USAGE.md`: document `dev more`, plus
  `docs/appendix/cheatsheet.md` if it lists dev commands.
