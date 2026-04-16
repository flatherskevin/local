# Week 2, Day 4: Panes, Windows, and Sessions

## Goal

Learn to manage your terminal layout precisely and work across multiple projects using tmux sessions.

## New Concepts

- **`Ctrl-a H/J/K/L`** -- resize the current pane in the given direction (left/down/up/right). Capital letters mean hold Shift. Repeat to keep resizing.
- **`Ctrl-a =`** -- apply the even-horizontal layout. All panes get equal width, arranged side by side.
- **`Ctrl-a +`** -- apply the even-vertical layout. All panes get equal height, stacked top to bottom.
- **`Ctrl-a z`** -- zoom the current pane to fill the whole window. Press again to unzoom. Useful when you need full-screen focus on one pane.
- **`Ctrl-a s`** -- open the session tree. Shows all sessions, windows, and panes. Use `j`/`k` to navigate, `Enter` to switch, arrow keys to expand/collapse.
- **`dev` command** -- creates a tmux session for the project using a readable name plus a short stable suffix. One session per project is the standard pattern.

## Exercises

1. Create a practice session with three panes. Start a new tmux session and create a layout with three panes:
   ```
   tmux new -s layout-practice
   ```
   Press `Ctrl-a |` to split horizontally. Press `Ctrl-a |` again in the new pane. You have three vertical columns.

2. Resize panes. Move to the middle pane (`Ctrl-a h` or `Ctrl-a l` as needed). Press `Ctrl-a H` (Shift-h) to shrink it leftward. Press `Ctrl-a L` (Shift-l) to grow it rightward. Make the middle pane wider than the others.

3. Try even-horizontal layout. Press `Ctrl-a =`. All three panes snap to equal width. This resets your manual resizing.

4. Try even-vertical layout. Press `Ctrl-a +`. The panes rearrange into stacked rows of equal height. Press `Ctrl-a =` to go back to side-by-side.

5. Zoom a pane. Move to any pane and press `Ctrl-a z`. That pane fills the whole window. You can work here as if it were the only pane. Press `Ctrl-a z` again to restore the layout.

6. Detach from the practice session. Press `Ctrl-a d`.

7. Open your first project. Use `dev` to open a real project:
   ```
   dev
   ```
   Pick a project from the fzf list. It creates a tmux session for that project with Neovim and a shell pane.

8. Open a second project. Open a new Kitty window or tab. Run `dev` again and pick a different project. You now have two tmux sessions, one per project.

9. View the session tree. In either session, press `Ctrl-a s`. You should see at least three sessions listed: `layout-practice` and your two project sessions. Use `j`/`k` to move between them. Press the right arrow to expand a session and see its windows and panes.

10. Switch sessions. In the session tree, highlight a different session and press `Enter`. You are now in that session. Everything in the other sessions continues running.

11. Switch back. Press `Ctrl-a s` again, select the session you came from, and press `Enter`. Practice switching between your two project sessions three times.

12. List sessions from outside tmux. Detach with `Ctrl-a d`. Run:
    ```
    dev session list
    ```
    All sessions are listed. Reattach to any one:
    ```
    ta <session-name>
    ```

13. Clean up. Kill the practice session:
    ```
    tmux kill-session -t layout-practice
    ```
    Keep your project sessions running if you want. They will persist until you kill them or reboot.

## Success Check

- [ ] I can resize panes using `Ctrl-a H/J/K/L`.
- [ ] I can apply even-horizontal (`=`) and even-vertical (`+`) layouts.
- [ ] I can zoom a single pane with `Ctrl-a z` and unzoom it.
- [ ] I have two project sessions running simultaneously via `dev`.
- [ ] I can switch between sessions using `Ctrl-a s` and the session tree.
- [ ] I understand the pattern: one tmux session per project.
