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
one-way hash of that path and cannot be reversed. To resolve it, record the project
path on the parent session at creation time and read it back when building a companion:

- In the existing `create_session`, add `tmux set-environment -t "$session"
  DEV_PROJECT "$project"`.
- In `dev more`, read it via `tmux show-environment -t "<parent>" DEV_PROJECT`.

This is robust against cd-ing around inside panes. If the variable is missing (for
example a session created before this change), fall back to the parent's first pane
current path.

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

- Factor the pure logic into small, testable functions: companion-name formatting,
  lowest-free-slot allocation, and parent-from-companion-name parsing. Unit-test these
  without tmux or kitty.
- Add a tmux smoke test (tmux runs headless) that creates a parent plus a companion and
  asserts the pane count and that the layout is `tiled`, with `kitty @ launch` stubbed.
- Match whatever test harness the repo already uses, or add `bats` if there is none.

## Files touched

- `scripts/dev`: new `more` subcommand and helpers; one line added to `create_session`
  for `DEV_PROJECT`; cascade in `session kill`; grouping in `session list`.
- Tests (harness confirmed during planning).
- A short README or docs note describing `dev more`.
