# Week 3, Day 3: Kitty and Multi-Repo

## Goal

Use Kitty tabs to manage multiple repositories and switch between them without losing context.

## New Concepts

- `kitty_mod+t` - **new tab**: opens a new Kitty tab. Each tab gets its own shell and can host its own tmux session.
- `kitty_mod+Right` - **next tab**: switches to the tab on the right.
- `kitty_mod+Left` - **previous tab**: switches to the tab on the left.
- `kitty_mod+d` - **vertical split**: splits the current Kitty window vertically (side by side).
- `kitty_mod+Shift+d` - **horizontal split**: splits the current Kitty window horizontally (top and bottom).
- `kitty_mod+]` - **next window**: moves focus to the next Kitty split within the current tab.
- `kitty_mod+[` - **previous window**: moves focus to the previous Kitty split within the current tab.
- **Multi-repo pattern** - one Kitty tab per workstream, one tmux session per repo, Neovim + shell inside each tmux session. This is how you work on multiple projects without losing your place.

## Exercises

### 1. Open a Kitty tab and launch a project

1. Open Kitty. You should have one visible tab, and the tab bar stays visible so the active tmux session name is always on screen
2. Type `dev` and select a project. You now have a tmux session with Neovim and a shell pane
3. This is your first workstream. Leave it running

### 2. Open a second tab for a second repo

1. Press `kitty_mod+t` to open a new Kitty tab
2. You are now in a fresh shell in the new tab. Notice the tab bar at the top of the Kitty window showing two tabs
3. Type `dev` and select a different project
4. You now have two Kitty tabs, each with its own tmux session, each with its own repo open in Neovim

### 3. Switch between tabs

1. Press `kitty_mod+Left` to go to the first tab. You should see your first project exactly as you left it
2. Press `kitty_mod+Right` to go back to the second tab. Second project is still there
3. Do this five times. Left, right, left, right. Get used to the feel
4. This is instant context switching. No windows to find. No alt-tab guessing. Each tab is a workspace

### 4. Understand the layers

1. In your current Kitty tab, you are inside a tmux session. Press `Ctrl-a s` to open the tmux session tree
2. You should see your current session highlighted. Press `q` to close the tree
3. Press `kitty_mod+Left` to switch to the other tab
4. Press `Ctrl-a s` again. You see the session for this tab
5. Notice: Kitty tabs are separate from tmux sessions. Kitty manages the tabs at the OS level. tmux manages the sessions inside each tab. They are independent layers

### 5. Try Kitty splits within a tab

1. In your current tab, press `kitty_mod+d` to create a vertical split inside Kitty
2. You now have two side-by-side shells in the same Kitty tab. The left still shows your tmux session. The right is a fresh shell
3. Press `kitty_mod+]` to move focus to the new split
4. Press `kitty_mod+[` to move back
5. Close the extra split by typing `exit` in the new shell or pressing `Ctrl-d`
6. Kitty splits are useful for quick one-off commands. For sustained work, stick with tmux panes inside the session

### 6. When to use what

1. Think about your current workflow. Consider these guidelines:
   - **Kitty tabs**: one per workstream or repo. Use them to separate unrelated work
   - **tmux sessions**: one per project inside a tab. Use `dev` to create them. They persist if Kitty closes
   - **tmux panes**: editor + shell side by side within a single project
   - **Kitty splits**: quick throwaway terminals. Close them when done
2. Switch to the first tab with `kitty_mod+Left`
3. Switch back with `kitty_mod+Right`
4. Open the tmux session tree with `Ctrl-a s` and confirm you can identify which session belongs to which repo

## Success Check

- [ ] I can open a new Kitty tab with `kitty_mod+t`
- [ ] I can switch between Kitty tabs with `kitty_mod+Left` and `kitty_mod+Right`
- [ ] I have two repos open, one per Kitty tab, each with its own tmux session
- [ ] I can create a Kitty split with `kitty_mod+d` and move between splits with `kitty_mod+]`/`kitty_mod+[`
- [ ] I understand the difference between Kitty tabs, tmux sessions, and tmux panes
- [ ] I can switch repos instantly without searching for windows
