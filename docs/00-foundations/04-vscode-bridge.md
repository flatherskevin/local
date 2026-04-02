# Chapter 4: VS Code Bridge

Do not try to translate every UI element from VS Code. Translate your daily
actions instead.

## What You Are Really Replacing

You are not replacing "one editor with another editor."

You are replacing one all-in-one application with a small system:

- terminal UI (kitty)
- session manager (tmux)
- editor (Neovim)

That is why the transition feels strange at first. The goal is to learn the new
system as a workflow, not as a list of disconnected keybindings.

## Common Mappings

### Find File

| VS Code         | Here   |
|-----------------|--------|
| `Cmd-P`         | `F6`   |

**Before (VS Code)**: Press Cmd-P, type part of a filename, click the result.

**After (Neovim)**: Press F6, type part of a filename, press Enter on the
match.

```
F6 → type "user_ser" → matches user_service.py → Enter
```

The behavior is nearly identical. The picker is powered by Snacks with fzf
matching, so partial and out-of-order matches work the same way.

### Search Project

| VS Code         | Here   |
|-----------------|--------|
| `Cmd-Shift-F`   | `F5`   |

**Before (VS Code)**: Open the search sidebar, type a query, browse results in
a panel, click to jump.

**After (Neovim)**: Press F5, type your query, results filter live, press Enter
to jump directly to the match in context.

```
F5 → type "TODO" → results update live → Enter on the match
```

Faster than the VS Code panel because there is no sidebar chrome. You are
searching and jumping in one motion.

### Rename Symbol

| VS Code         | Here   |
|-----------------|--------|
| `F2`            | `F2`   |

**Before (VS Code)**: Place cursor on symbol, press F2, type new name, Enter.

**After (Neovim)**: Place cursor on symbol, press F2, type new name, Enter.

```
cursor on "old_name" → F2 → type "new_name" → Enter → all references updated
```

This one is identical. The LSP does the same refactor in both editors.

### Code Action

| VS Code         | Here   |
|-----------------|--------|
| `Cmd-.`         | `F4`   |

**Before (VS Code)**: See a lightbulb or squiggly line, press Cmd-., pick an
action from the dropdown.

**After (Neovim)**: See a diagnostic, press F4, pick an action from the list.

```
cursor on import error → F4 → "Add missing import" → Enter
```

Same LSP actions, different key.

### Format File

| VS Code         | Here   |
|-----------------|--------|
| `Shift-Alt-F`   | `F3`   |

**Before (VS Code)**: Press the format shortcut or save with format-on-save
enabled.

**After (Neovim)**: Press F3. The file is formatted in place using conform.nvim
with language-appropriate formatters (black, goimports, prettier, etc).

```
messy indentation → F3 → file reformatted cleanly
```

### Explorer / Sidebar

| VS Code         | Here   |
|-----------------|--------|
| `Cmd-B` (sidebar) | `F8`   |

**Before (VS Code)**: Toggle the sidebar to browse files in a tree view.

**After (Neovim)**: Press F8 to toggle Neotree. Navigate with j/k, open files
with Enter, close with F8.

```
F8 → tree opens on left → j/k to navigate → Enter to open → F8 to close
```

Tip: Use F6 (find files) more than F8 (explorer). Fuzzy finding is faster than
tree browsing once you trust it. The explorer is best for when you need to see
the shape of a directory.

### Terminal

| VS Code         | Here                  |
|-----------------|-----------------------|
| `` Ctrl-` ``    | right tmux pane       |

**Before (VS Code)**: Toggle the integrated terminal drawer at the bottom of
the editor.

**After (here)**: The terminal is always visible in the right pane. Switch to
it with `Ctrl-a l` (tmux pane navigation) or click it.

```
editing in Neovim → Ctrl-a l → now in shell pane → run tests → Ctrl-a h → back to Neovim
```

There is no toggle because the terminal is not hidden. It is beside the editor
at all times. This is a deliberate design choice: the shell is a first-class
citizen, not a drawer you open when you need it.

### Source Control

| VS Code         | Here   |
|-----------------|--------|
| Source Control view | `F10`  |

**Before (VS Code)**: Open the Source Control panel, review changed files,
stage hunks, write a commit message, push.

**After (Neovim)**: Press F10 to open LazyGit. Full TUI for staging, diffing,
committing, branching, pushing, rebasing.

```
F10 → LazyGit opens → Tab to switch panels → Space to stage → c to commit → q to quit
```

LazyGit is more capable than the VS Code source control panel. It handles
interactive rebase, cherry-pick, stash management, and branch operations in a
single interface.

## Your First 10 Minutes

Here is what a realistic first session looks like after running `dev` and
picking a repo:

```
1. You land in the two-pane layout.
   Left: Neovim (empty).  Right: shell.

2. Press F6. Type part of a filename you know.
   Pick it. The file opens in Neovim.

3. Press F5. Search for a function name.
   Jump to it. Read the code.

4. Press F8. The file tree appears.
   Browse the directory structure. Press Enter on a file. Press F8 to close.

5. Move to the right pane: Ctrl-a l
   Run a command: git status, make test, whatever you need.

6. Move back to Neovim: Ctrl-a h
   Continue editing.

7. Press F10. LazyGit opens.
   Review your changes. Stage them. Write a commit. Press q to close.
```

That is a complete work loop. Everything else in this guide builds on top of
those seven steps.

## First Principle

In VS Code, one application owns almost everything.

Here, the workflow is split on purpose:

- kitty for terminal UI
- tmux for workspace persistence
- Neovim for editing

That looks more complex at first, but it becomes easier to reason about once
each layer has one job.

## What To Practice This Week

Do these instead of trying to learn everything:

1. Use `F6` instead of file-tree clicking
2. Use `F5` instead of global search panels
3. Use the right tmux pane instead of looking for an editor terminal drawer
4. Use `F10` for git review and commits

Do not add more to this list until these four are automatic.
