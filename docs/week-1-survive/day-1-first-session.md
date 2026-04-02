# Week 1, Day 1: First Session

## Goal

Open a project with `dev` and get comfortable switching between the editor and the shell.

## New Concepts

- `dev` - fzf-powered project picker that creates a tmux session with Neovim on the left and a shell on the right
- `Ctrl-a h` - move to the left pane (Neovim)
- `Ctrl-a l` - move to the right pane (shell)
- `Ctrl-a z` - zoom the current pane to full screen (press again to unzoom)
- `:q` - quit Neovim (type this inside Neovim in normal mode)
- `ta` - alias for `tmux attach` (reattach to a session)
- `tl` - alias for `tmux ls` (list active sessions)

## Exercises

### 1. Launch your first session

1. Open Kitty terminal
2. Type `dev` and press Enter
3. You will see an fzf list of your projects. Use the arrow keys or type to filter, then press Enter to select one
4. You should now see a split screen: Neovim on the left, a shell prompt on the right

### 2. Switch between panes

1. Your cursor should be in the Neovim pane (left). If not, press `Ctrl-a h`
2. Press `Ctrl-a l` to move to the shell pane on the right
3. You should see your normal shell prompt. The cursor is now in the shell
4. Press `Ctrl-a h` to move back to Neovim
5. Repeat this five times. Get the feel of it. `Ctrl-a l` for shell. `Ctrl-a h` for editor

### 3. Run a command in the shell pane

1. Press `Ctrl-a l` to move to the shell pane
2. Type `ls` and press Enter. You should see the project files listed
3. Type `pwd` and press Enter. Confirm you are in the project directory
4. Type `git status` and press Enter. You should see the repo status

### 4. Come back to Neovim

1. Press `Ctrl-a h` to move back to the Neovim pane
2. You should see Neovim exactly as you left it. Nothing was lost

### 5. Zoom a pane

1. Press `Ctrl-a z` to zoom the Neovim pane to full screen. The shell pane disappears temporarily
2. Press `Ctrl-a z` again to unzoom. Both panes are back
3. Press `Ctrl-a l` to go to the shell pane
4. Press `Ctrl-a z` to zoom the shell to full screen. Now you have a full-size terminal
5. Press `Ctrl-a z` to unzoom

### 6. Detach and reattach

1. Press `Ctrl-a d` to detach from the tmux session. You are back at your bare Kitty prompt
2. Type `tl` and press Enter. You should see your session listed
3. Type `ta` and press Enter. You are back in your session exactly where you left off

## Success Check

- [ ] I can run `dev` and select a project from the fzf picker
- [ ] I can switch from Neovim to the shell pane with `Ctrl-a l`
- [ ] I can switch from the shell back to Neovim with `Ctrl-a h`
- [ ] I can zoom a pane with `Ctrl-a z` and unzoom it again
- [ ] I can run shell commands (ls, git status) in the right pane
- [ ] I can detach with `Ctrl-a d` and reattach with `ta`
