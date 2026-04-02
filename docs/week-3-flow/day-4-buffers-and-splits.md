# Week 3, Day 4: Buffers and Splits

## Goal

View and edit multiple files at the same time using Neovim splits and buffer switching.

## New Concepts

- `:vs` - **vertical split**: splits the current Neovim window vertically. Both sides show the same file until you open a different one.
- `:sp` - **horizontal split**: splits the current Neovim window horizontally (top and bottom).
- `Ctrl-h` - move focus to the split on the left.
- `Ctrl-j` - move focus to the split below.
- `Ctrl-k` - move focus to the split above.
- `Ctrl-l` - move focus to the split on the right.
- `F7` - **switch buffer**: opens a fuzzy picker of all open buffers. Type to filter, Enter to select.
- `:q` - close the current split. If it is the last split, it closes the buffer.
- **Buffer vs split** - a buffer is a file loaded in memory. A split is a viewport. You can have many buffers open but only show a few in splits. Closing a split does not close the buffer.

## Exercises

### 1. Create a vertical split

1. Run `dev` and open a project
2. Open a file with F6
3. Type `:vs` and press Enter. The screen splits vertically. Both sides show the same file
4. Press `Ctrl-l` to move to the right split
5. Press `Ctrl-h` to move back to the left split
6. You now have two viewports into the same file. Scroll one side and the other stays put

### 2. Open a different file in the second split

1. Move to the right split with `Ctrl-l`
2. Press F6 to open the file finder. Select a different file
3. Now you have two files side by side. Left split shows the first file, right split shows the second
4. Move between them with `Ctrl-h` and `Ctrl-l`. Each split has its own cursor position

### 3. Create a horizontal split

1. Move to the left split with `Ctrl-h`
2. Type `:sp` and press Enter. The left side splits horizontally. You now have three viewports: two on the left stacked vertically, one on the right
3. Press `Ctrl-j` to move to the bottom-left split
4. Press `Ctrl-k` to move to the top-left split
5. Open a third file in one of these splits using F6

### 4. Switch buffers with F7

1. You now have three files open. Press F7
2. A fuzzy picker appears showing all open buffers. You should see at least three entries
3. Type part of a filename to filter the list
4. Press Enter to open that buffer in the current split
5. The split now shows the selected buffer. The previous buffer is still open, just not visible in this split
6. Press F7 again and switch to a different buffer. This is the fastest way to jump between files

### 5. Close splits

1. Move to any split using `Ctrl-h`/`Ctrl-j`/`Ctrl-k`/`Ctrl-l`
2. Type `:q` and press Enter. The split closes. The remaining splits expand to fill the space
3. The buffer that was in the closed split is still open. Press F7 to confirm it is still in the buffer list
4. Close another split with `:q`. You should be back to a single viewport
5. Press F7. All your buffers are still there. Closing a split does not lose your work

### 6. Practice the workflow

1. Open a file with F6
2. Type `:vs` to split vertically
3. In the right split, press F6 and open a related file (a test file, a component, a config)
4. Edit code in the left split. Use `Ctrl-l` to check the related file. Use `Ctrl-h` to go back
5. Use F7 to switch the right split to a different buffer without closing the split
6. When you are done comparing, close the right split with `:q`
7. This is how you work with related files: split, compare, edit, close

## Success Check

- [ ] I can create a vertical split with `:vs` and a horizontal split with `:sp`
- [ ] I can move between splits with `Ctrl-h`/`Ctrl-j`/`Ctrl-k`/`Ctrl-l`
- [ ] I can open different files in different splits using F6
- [ ] I can switch buffers in any split with F7
- [ ] I understand that closing a split does not close the buffer
- [ ] I can set up a two-file side-by-side view for comparing or editing related files
