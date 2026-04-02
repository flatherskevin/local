# Week 2, Day 1: tmux Fundamentals

## Goal

Learn the core tmux controls so you can split, navigate, and persist terminal sessions without thinking.

## New Concepts

- **Prefix key (`Ctrl-a`)** -- every tmux command starts by pressing `Ctrl-a`, then releasing, then pressing the action key. This is your tmux "shift key."
- **`Ctrl-a |`** -- split the current pane horizontally (side by side).
- **`Ctrl-a -`** -- split the current pane vertically (stacked top/bottom).
- **`Ctrl-a h/j/k/l`** -- move between panes (left/down/up/right). Same directions as Vim.
- **`Ctrl-a c`** -- create a new window (like a new tab).
- **`Ctrl-a n`** -- go to the next window.
- **`Ctrl-a p`** -- go to the previous window.
- **`Ctrl-a ,`** -- rename the current window.
- **`Ctrl-a d`** -- detach from the session. The session keeps running in the background.
- **`tmux attach` / `ta`** -- reattach to a detached session.
- **`tmux ls` / `tl`** -- list all running sessions.

## Exercises

1. Open your terminal (Kitty). Start a new tmux session:
   ```
   tmux new -s practice
   ```
   You should see a green status bar at the bottom.

2. Split the pane horizontally. Press `Ctrl-a`, release, then press `|`. You now have two panes side by side.

3. Move to the right pane. Press `Ctrl-a l`. Move back left with `Ctrl-a h`. Do this three times until it feels natural.

4. Split the right pane vertically. Move to the right pane (`Ctrl-a l`), then press `Ctrl-a -`. You now have three panes: one tall left pane and two stacked right panes.

5. Navigate all three panes. Use `Ctrl-a h/j/k/l` to visit each pane. In each pane, type `echo "pane X"` (replace X with 1, 2, 3) so you can visually confirm which pane you're in.

6. Create a new window. Press `Ctrl-a c`. The status bar at the bottom should show two windows. Type `echo "window 2"` to mark it.

7. Switch between windows. Press `Ctrl-a p` to go back to window 1. Press `Ctrl-a n` to go forward to window 2. Do this five times.

8. Rename window 2. While on window 2, press `Ctrl-a ,`. The status bar will prompt for a name. Type `scratch` and press Enter.

9. Detach from the session. Press `Ctrl-a d`. You are back in plain Kitty. The tmux session is still alive.

10. Verify the session is running. Type:
    ```
    tl
    ```
    You should see `practice` listed with 2 windows.

11. Reattach. Type:
    ```
    ta -t practice
    ```
    Everything is exactly as you left it. Your panes, windows, and shell history are all intact.

12. Clean up. Type `exit` in each pane until the session closes, or run:
    ```
    tmux kill-session -t practice
    ```

## Success Check

- [ ] I can create horizontal and vertical splits without looking up the keys.
- [ ] I can move between panes using h/j/k/l.
- [ ] I can create, name, and switch between windows.
- [ ] I detached from a session and reattached, confirming everything persisted.
- [ ] I understand that `Ctrl-a` is always pressed and released first, then the action key.
