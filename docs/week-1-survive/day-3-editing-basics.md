# Week 1, Day 3: Editing Basics

## Goal

Make edits in Neovim confidently: enter insert mode, type text, save, quit, and undo mistakes.

## New Concepts

- `i` - enter insert mode at the cursor (you can now type text)
- `a` - enter insert mode after the cursor
- `o` - open a new line below and enter insert mode
- `Esc` - return to normal mode (always safe to press, no matter where you are)
- `:w` - save the current file (write)
- `:q` - quit the current buffer
- `:wq` - save and quit
- `yy` - yank (copy) the current line
- `dd` - delete (cut) the current line
- `p` - paste below the cursor
- `u` - undo the last change
- `Ctrl-r` - redo (reverse an undo)

## Exercises

### 1. Open a file to edit

1. Run `dev` and open a project
2. Press `F6` and open a file you are comfortable editing (a README, a config file, or a test file)
3. You are in normal mode. The cursor is a block. You cannot type text yet

### 2. Enter insert mode and type

1. Move the cursor to an empty area or the end of a line using arrow keys
2. Press `i`. The bottom of the screen shows `-- INSERT --`. You are now in insert mode
3. Type a comment: `# This is a test edit`
4. Press `Esc` to return to normal mode. The `-- INSERT --` indicator disappears
5. Press `a` to enter insert mode after the cursor. Type ` - appended text`
6. Press `Esc` to return to normal mode
7. Press `o` to open a new line below and enter insert mode. Type `# Another test line`
8. Press `Esc` to return to normal mode

### 3. Save the file

1. Type `:w` and press Enter. The file is saved. You will see a confirmation at the bottom of the screen
2. The file is written to disk. Your edits are persisted

### 4. Undo and redo

1. Press `u` to undo your last change. The line you added with `o` should disappear
2. Press `u` again. The text you appended with `a` should be gone
3. Press `u` again. The comment you typed with `i` should be gone
4. All three edits are undone. The file is back to its original state
5. Press `Ctrl-r` to redo. Your first edit reappears
6. Press `Ctrl-r` again. The second edit reappears
7. Press `Ctrl-r` once more. All three edits are back
8. Press `u` repeatedly until the file is back to its original state. This is your safety net. You can always undo

### 5. Yank, delete, and paste a line

1. Move the cursor to any line in the file
2. Press `yy` to yank (copy) the entire line. Nothing visible happens, but the line is in the register
3. Press `p` to paste it below the current line. You should see a duplicate line
4. Press `u` to undo the paste
5. Move the cursor to a line you do not need
6. Press `dd` to delete (cut) that line. The line disappears and the lines below shift up
7. Move the cursor to where you want the line to go
8. Press `p` to paste it there. You just moved a line
9. Press `u` twice to undo both the paste and the delete. The line is back where it started

### 6. Save and quit

1. Make sure the file is in its original state by pressing `u` until there are no more changes
2. Type `:w` and press Enter to save
3. Type `:q` and press Enter to close the buffer
4. If you ever want to save and quit in one step, type `:wq` and press Enter

## Success Check

- [ ] I can enter insert mode with `i`, `a`, and `o` and I know the difference between them
- [ ] I can return to normal mode with `Esc` from anywhere
- [ ] I can save a file with `:w`
- [ ] I can quit a buffer with `:q`
- [ ] I can undo changes with `u` and redo them with `Ctrl-r`
- [ ] I can yank a line with `yy` and paste it with `p`
- [ ] I can delete a line with `dd`
- [ ] I am not afraid to make changes because I know `u` will undo them
