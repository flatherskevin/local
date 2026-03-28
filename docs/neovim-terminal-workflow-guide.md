# Neovim Terminal Workflow Guide

This guide is the operating manual for the environment in this repo.

It is written for someone coming from a long-term VS Code or Cursor workflow who
wants to become genuinely comfortable in a terminal-first setup without turning
their first week into a memorization exercise.

The target outcome is not "know every Vim trick." The target outcome is:

- open the right repo quickly
- navigate confidently
- edit with strong language support
- run tests, git, and AI tools beside the editor
- manage multiple repos without losing context
- build skill gradually over 2 to 3 weeks

## What This Setup Is

This environment has three main layers:

### Kitty

`kitty` is the outer terminal application.

Use it for:

- opening OS windows
- opening tabs
- creating quick terminal splits
- launching into tmux work sessions

Do not expect kitty to manage long-lived work context by itself. That is tmux's
job.

### Tmux

`tmux` is the session and workspace layer.

Use it for:

- keeping work alive when terminals close
- keeping one session per repo or workstream
- splitting editing and command execution side by side
- returning to ongoing work instantly

If you think of VS Code windows as "workspace containers," tmux sessions are the
closest analogue here.

### Neovim via LazyVim

Neovim is the editor. `LazyVim` is the base distribution.

Use it for:

- file editing
- fuzzy file finding
- project grep
- code navigation
- LSP and diagnostics
- formatting and code actions

You are not expected to configure Neovim from scratch. The point of using
LazyVim is to stand on a stable community base and keep your custom layer small.

## How The Layers Fit Together

The intended daily stack looks like this:

1. Open kitty
2. Run `dev` or press `F10`
3. Pick a repo
4. Let tmux open or resume the repo session
5. Work in the default two-pane layout

Default mental model:

- left pane: Neovim
- right pane: shell for tests, git, AI, logs, `make`, `uv`, and debugging

This is the core design of the environment. It keeps the editor focused on
editing and the shell focused on execution.

## Before You Start

### What to expect emotionally

The first few days will feel slower than VS Code. That is normal.

The goal is not to match your VS Code speed on day one. The goal is to build a
workflow that becomes calmer, faster, and more composable over time.

Three things usually feel awkward at first:

- modal editing
- split and session management
- not having every command presented as a visible button

This setup deliberately reduces that friction by giving you:

- function-key fallbacks
- `which-key` discovery
- mouse support
- side-by-side panes by default
- a project launcher so you do not have to manually build every session

### What not to do in week one

- Do not try to learn advanced Vim motions immediately.
- Do not customize ten plugins at once.
- Do not judge the setup based on your first 90 minutes.
- Do not force yourself to abandon the mouse instantly.

## Quick Start

### Open a repo session

```bash
dev
```

That does four useful things:

1. lets you pick a repo with `fzf`
2. creates or resumes a tmux session for that repo
3. opens a side-by-side layout
4. starts `nvim` in the left pane

If you already know the repo path:

```bash
dev ~/codebase/my-repo
```

### First commands to learn

Inside Neovim:

- `F1`: show keymap help
- `F5`: search across the project
- `F6`: find files
- `F7`: switch buffers
- `F8`: toggle file explorer
- `F9`: toggle terminal inside Neovim
- `F10`: open LazyGit

Inside tmux:

- `Ctrl-a |`: split side by side
- `Ctrl-a -`: split top and bottom
- `Ctrl-a c`: create a new tmux window
- `Ctrl-a h/j/k/l`: move between panes
- `F5`: show a tmux tree of sessions and windows
- `F6`: create a side-by-side split
- `F7`: create a new tmux window

Inside kitty:

- `F6`: open a new tab
- `F7`: open a vertical split
- `F9`: jump into the `main` tmux session
- `F10`: run the `dev` launcher

## The VS Code Bridge

The biggest adoption mistake is trying to translate the entire editor one
feature at a time. Instead, translate workflows.

### Open a file

VS Code habit:

- `Cmd-P`

New workflow:

- `F6`

### Search a project

VS Code habit:

- `Cmd-Shift-F`

New workflow:

- `F5`

### Rename symbol

VS Code habit:

- `F2`

New workflow:

- `F2`

### Quick fix or code action

VS Code habit:

- `Cmd-.`

New workflow:

- `F4`

### Format the file

VS Code habit:

- format document command

New workflow:

- `F3`

### Toggle file explorer

VS Code habit:

- sidebar explorer

New workflow:

- `F8`

### Open integrated terminal

VS Code habit:

- integrated terminal panel

New workflow:

- use the right tmux pane first
- use `F9` inside Neovim when you want a terminal inside the editor

### Source control

VS Code habit:

- source control sidebar

New workflow:

- `F10` for LazyGit
- or use the right shell pane for raw git commands

## Crawl: Week 1

The goal of week one is basic fluency, not mastery.

### Daily routine

Start every work session the same way:

```bash
dev
```

Then stick to this pattern:

- left pane: Neovim
- right pane: tests, AI, git, and build commands

Keep the mental model simple.

### What to practice every day

1. Find files with `F6`
2. Search text with `F5`
3. Toggle the explorer with `F8`
4. Rename with `F2`
5. Format with `F3`
6. Use `Ctrl-h/j/k/l` to move between editor splits
7. Use `Ctrl-a h/j/k/l` to move between tmux panes

### Week 1 editing basics

You only need a small Vim subset at first:

- `i`: insert before cursor
- `a`: insert after cursor
- `o`: open a new line below
- `Esc`: leave insert mode
- `:w`: save
- `:q`: quit
- `:wq`: save and quit
- `/text`: search inside file
- `n`: next search result
- `N`: previous search result
- `dd`: delete line
- `yy`: copy line
- `p`: paste
- `u`: undo
- `Ctrl-r`: redo

That is enough for real work. Ignore the rest for now.

### Week 1 LSP habits

When you open code, start noticing these:

- `K`: hover docs
- `gd`: go to definition
- `gr`: references
- `]d`: next diagnostic
- `[d`: previous diagnostic

These are the first "editor power" features worth making automatic in your
hands.

### Week 1 AI workflow

Keep AI in the terminal, not inside the editor UI.

Recommended pattern:

- editor in the left pane
- AI tool in the right pane

Use the right pane for:

- asking architecture questions
- requesting code changes
- reviewing diffs
- running tests after AI-assisted edits

This keeps the model output close to your work without burying the editor under
chat panels.

## Walk: Week 2

The goal of week two is to stop feeling like you are merely surviving.

### Start using tmux intentionally

By week two, stop thinking of tmux as "the thing under Neovim."

Treat tmux as your workspace manager.

Recommended structure:

- one tmux session per repo
- one tmux window per task area inside that repo

Example:

- window 1: editing + tests
- window 2: server or watcher
- window 3: infra, logs, or notes

That is cleaner than creating a chaotic grid of panes.

### Learn the difference between buffers, windows, panes, and tabs

This is where many VS Code users get confused.

- buffer: an open file in Neovim
- Neovim window: a split inside the editor
- tmux pane: a shell pane in the session
- tmux window: a workspace page inside tmux
- kitty tab: a top-level terminal tab outside tmux

Use each layer on purpose:

- Neovim windows for comparing or editing files
- tmux panes for editor plus shell
- tmux windows for distinct task contexts
- kitty tabs for separate high-level workstreams when useful

### Learn project navigation deeply

Practice this sequence:

1. `F6` to jump to a file by name
2. `F5` to search for a symbol or phrase across the project
3. `gd` to jump to definitions
4. `gr` to inspect references
5. `F7` to move across open buffers

This sequence replaces a lot of sidebar clicking.

### Learn the file explorer's role

Do not try to keep the explorer open all day.

Use it when you need:

- directory orientation
- file creation or renaming
- quick path confirmation

Otherwise, stay in fuzzy finding and search.

### Start using LazyGit daily

Use `F10` and learn this loop:

1. review changed files
2. stage intentionally
3. inspect diffs
4. commit in context
5. return to editing

This is faster and cleaner than living in a side panel.

## Run: Week 3

The goal of week three is to make the environment feel like home.

### Build a stable multi-repo routine

Recommended approach:

- one kitty tab per major workstream
- one tmux session per repo
- one editor pane plus one command pane as the default

Example day:

1. kitty tab 1: backend repo
2. kitty tab 2: frontend repo
3. kitty tab 3: infrastructure repo

Each tab can attach to a different tmux session with `dev`.

This prevents "all projects in one mega-session" fatigue.

### Use terminals with intent

There are now three terminal concepts available:

- kitty windows or tabs
- tmux panes
- terminal buffers inside Neovim

Preferred order:

1. tmux right pane for most commands
2. tmux extra windows for long-running processes
3. Neovim terminal only when tight editor proximity matters

That keeps complexity under control.

### Start learning higher-value motions

Once the basics are comfortable, these are worth learning:

- `ciw`: change inner word
- `di(` or `da(`: delete inside or around parentheses
- `%`: jump between matching pairs
- `*`: search the word under cursor
- `gg`: top of file
- `G`: bottom of file
- `:lnext` and `:lprev`: move through location list items when relevant

These pay off quickly without requiring deep Vim wizardry.

### Use language features as the default, not a bonus

By this point, you should rely on:

- LSP rename instead of manual search-and-replace where appropriate
- definitions and references instead of file-by-file hunting
- formatter-on-save instead of hand-formatting
- diagnostics navigation instead of visually scanning for errors

This is where Neovim stops feeling "minimal" and starts feeling genuinely
strong.

## Language Support You Can Trust

This setup is intentionally strong in the tools you use most:

- Python: `pyright`, `ruff`, formatting on save
- Go: `gopls`, `gofumpt`, `goimports`
- TypeScript and Node: `vtsls`, `eslint`, `prettierd`
- Terraform: `terraform-ls`, `tflint`, `terraform fmt`
- YAML and JSON: language servers and formatting
- TOML: `taplo`
- Markdown: `marksman` and formatting
- Shell: `bashls`, `shellcheck`, `shfmt`

You should expect these languages to feel first-class, not bolted on.

## How To Use AI Well In This Setup

This environment is intentionally terminal-first for AI work.

### Recommended AI pattern

Keep the AI tool in the right pane beside Neovim.

That lets you:

- ask for implementation help
- request reviews
- inspect git diffs
- run tests
- compare AI suggestions against real code

The important part is separation of concerns:

- Neovim edits
- shell executes
- AI advises or changes code through the terminal workflow

### Good prompts in this environment

Good terminal-first prompts are concrete and repo-aware.

Examples:

- "Review the current diff for correctness and risks."
- "Trace how config loading works in this repo."
- "Implement this change and run the relevant tests."
- "Summarize why this TypeScript error is happening."

### What to avoid

- letting AI become a replacement for navigation
- leaving a growing trail of unreviewed AI changes
- asking AI to operate without clear repo context

Your editor and search tools should still be the primary way you understand the
codebase.

## The Most Important Keymaps

### Neovim

- `F1`: show key help
- `F2`: rename symbol
- `F3`: format buffer
- `F4`: code action
- `F5`: project grep
- `F6`: find files
- `F7`: buffers
- `F8`: explorer
- `F9`: terminal
- `F10`: LazyGit
- `Ctrl-h/j/k/l`: move between editor splits

### Tmux

- `Ctrl-a |`: side-by-side split
- `Ctrl-a -`: stacked split
- `Ctrl-a c`: new window
- `Ctrl-a h/j/k/l`: move panes
- `Ctrl-a H/J/K/L`: resize panes
- `Ctrl-a =`: even horizontal layout
- `Ctrl-a +`: even vertical layout
- `Ctrl-a z`: zoom pane
- `F5`: session and window tree
- `F10`: LazyGit popup

### Kitty

- `kitty_mod+Enter`: new OS window in the same cwd
- `kitty_mod+t`: new tab in the same cwd
- `kitty_mod+d`: vertical split
- `kitty_mod+Shift+d`: horizontal split
- `F6`: new tab
- `F7`: vertical split
- `F9`: attach or create the `main` tmux session
- `F10`: run `dev`

## What To Do When You Feel Lost

This will happen. Use a recovery checklist instead of fighting it.

1. Press `F1` in Neovim to discover available grouped keymaps
2. Press `F5` if you need to find something in the project
3. Press `F6` if you know the file name or part of it
4. Press `F8` if you need directory orientation
5. Use the right tmux pane to run `git status`, `rg`, tests, or AI commands
6. Return to the default layout: editor left, shell right

Resetting to a simple layout is usually better than improvising more panes.

## Suggested 2 To 3 Week Plan

### Days 1 to 3

Focus only on:

- `dev`
- `F5`, `F6`, `F8`
- basic insert, save, quit
- one tmux session per repo
- one shell pane next to the editor

### Days 4 to 7

Add:

- `F2`, `F3`, `F4`
- `gd`, `gr`, `K`
- LazyGit with `F10`
- tmux windows for task separation

### Week 2

Add:

- stronger tmux habits
- multi-repo session discipline
- project search and LSP navigation as your primary movement model
- reduced dependence on the file tree

### Week 3

Add:

- a few text objects and motions
- tighter AI + terminal collaboration habits
- more deliberate use of tmux windows and Neovim splits
- confidence in working mostly from the keyboard while still using the mouse
  when it genuinely helps

## Screenshots

This guide currently does not include screenshots. That is deliberate.

A clear and accurate tutorial is more valuable than rushed screenshots that go
stale or distract from the workflow. If you want, the next iteration can add a
small set of focused images or terminal captures for:

- the default `dev` session layout
- a typical multi-repo kitty plus tmux arrangement
- Neovim file finding, grep, and explorer usage

## Final Advice

You do not need to become a Vim maximalist to get a lot of value from this
setup.

Use the function keys. Use the mouse when it helps. Use search heavily. Keep
your default layout simple. Let tmux hold context. Let Neovim handle code
intelligence. Keep AI in the terminal next to the code, not layered on top of
it.

If you do that consistently for 2 to 3 weeks, this setup should stop feeling
like an experiment and start feeling like your working environment.
