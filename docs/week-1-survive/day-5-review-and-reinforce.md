# Week 1, Day 5: Review and Reinforce

## Goal

Complete a full workflow from project open to tested change using every skill from this week.

## New Concepts

No new concepts today. This is practice. You are combining everything from Days 1 through 4 into a single continuous workflow.

Quick reference of everything you have learned:

- `dev` - open a project
- `Ctrl-a h/l` - switch panes
- `Ctrl-a z` - zoom pane
- `F5` - search project
- `F6` - find file
- `F8` - file explorer
- `i/a/o` - enter insert mode
- `Esc` - normal mode
- `:w` - save
- `:q` - quit
- `yy/dd/p` - yank, delete, paste
- `u` / `Ctrl-r` - undo / redo
- `F3` - format
- `F10` - LazyGit

## Exercises

### 1. Open a project

1. Type `dev` and pick a project you work on regularly
2. Confirm you see the two-pane layout: Neovim left, shell right

### 2. Find a file to change

1. Press `F5` and search for `TODO`, `FIXME`, or `HACK`. Pick a result and jump to it. If none exist, search for any string you recognize and jump to that file
2. Note the file name and line number. This is the file you will edit

### 3. Explore the file structure

1. Press `F8` to open the file explorer
2. Navigate to the directory that contains the file you just opened. Get a sense of what is around it
3. Press `F8` to close the explorer

### 4. Open a related file

1. Press `F6` and open a file that is related to the one you are editing (a test file, a config, an import). If you are not sure, just open any other file in the same directory
2. Look at it briefly, then press `F6` again and reopen your original file

### 5. Make an edit

1. Move to the line you want to change
2. Press `o` to open a new line. Add a useful comment or fix a small issue
3. Press `Esc` to return to normal mode
4. Type `:w` to save

### 6. Format the file

1. Press `F3` to format the file
2. Type `:w` to save again

### 7. Review your change

1. Press `F10` to open LazyGit
2. Find your modified file in the list
3. Press `Enter` to view the diff. Confirm it looks correct
4. Press `Space` to stage the file
5. Press `q` to close LazyGit

### 8. Run tests in the shell

1. Press `Ctrl-a l` to move to the shell pane
2. Run the project's test command. Watch the output
3. If tests pass, your change is good. If tests fail, press `Ctrl-a h` to go back to Neovim and fix the issue
4. Press `Ctrl-a h` to return to Neovim

### 9. Zoom and focus

1. Press `Ctrl-a z` to zoom the Neovim pane. Review your work in full screen
2. Press `Ctrl-a z` to unzoom
3. Press `Ctrl-a l` then `Ctrl-a z` to zoom the shell pane. Review the test output in full screen
4. Press `Ctrl-a z` to unzoom

### 10. Clean up (optional)

1. If this was a practice edit you do not want to keep, press `Ctrl-a h` to go to Neovim
2. Press `u` until the change is gone, then type `:w`
3. Press `F10` to open LazyGit. The file should no longer appear as modified
4. Press `q` to close LazyGit

## Reflection

After completing the exercises, answer these questions honestly:

1. Can you open a project with `dev` without hesitation?
2. When you need to find a file, do you reach for F6 automatically?
3. When you need to find text, do you reach for F5?
4. Can you make edits without getting stuck in the wrong mode?
5. Do you remember to save with `:w` before switching tasks?
6. Can you move between panes without thinking about the keys?

If you answered "no" to any of these, go back to the relevant day and repeat the exercises. There is no penalty for repetition. There is only cost to moving ahead without the foundation.

## Success Check

- [ ] I completed the full workflow: dev, find, edit, format, review, test
- [ ] I used F5 to search, F6 to find a file, and F8 to browse
- [ ] I made an edit using insert mode, saved with :w, and formatted with F3
- [ ] I reviewed the change in LazyGit with F10
- [ ] I ran tests in the shell pane
- [ ] I can switch between panes and zoom without looking up the keys
- [ ] I feel comfortable enough to use this setup for real work next week
