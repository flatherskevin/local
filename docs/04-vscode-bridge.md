# Chapter 4: VS Code Bridge

Do not try to translate every UI element from VS Code. Translate your daily
actions instead.

## What You Are Really Replacing

You are not replacing "one editor with another editor."

You are replacing one all-in-one application with a small system:

- terminal UI
- session manager
- editor

That is why the transition feels strange at first. The goal is to learn the new
system as a workflow, not as a list of disconnected keybindings.

## Common Mappings

- Find file: VS Code `Cmd-P` -> here `F6`
- Search project: VS Code `Cmd-Shift-F` -> here `F5`
- Rename symbol: VS Code `F2` -> here `F2`
- Code action: VS Code `Cmd-.` -> here `F4`
- Format file: VS Code format command -> here `F3`
- Explorer: VS Code sidebar -> here `F8`
- Terminal: VS Code integrated terminal -> here the right tmux pane first
- Source control: VS Code source control view -> here `F10` for LazyGit

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

