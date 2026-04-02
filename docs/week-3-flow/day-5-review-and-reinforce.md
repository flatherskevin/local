# Week 3, Day 5: Review and Reinforce

## Goal

Combine everything from this week into a single realistic editing session and identify what still feels slow.

## New Concepts

No new concepts today. This is practice. You are combining:

- **Vim motions**: ciw, di(, di", %, *, w/b, gg/G
- **Formatting**: format on save, F3, F4, ]d/[d
- **Multi-repo**: Kitty tabs, one tmux session per repo, switching between them
- **Splits and buffers**: :vs, :sp, Ctrl-h/j/k/l, F7

## Exercises

### 1. Set up a multi-repo workspace

1. Open Kitty
2. Type `dev` and select your first project
3. Press `kitty_mod+t` to open a second tab
4. Type `dev` and select a second project
5. You now have two repos, each in its own Kitty tab with its own tmux session

### 2. Refactor in the first repo

1. Press `kitty_mod+Left` to switch to the first tab
2. Press F6 and open a file that has a variable or function you want to rename
3. Use `*` to find all occurrences of the word under your cursor. Count them with `n`
4. Go back to the first occurrence with `gg` then `n`
5. Use `ciw` to change the name. Type the new name, press `Esc`
6. Press `n` to jump to the next occurrence. Use `.` to repeat the last change (this replaces the word with the same new name)
7. Repeat until all occurrences are renamed
8. Save with `:w`. Watch the formatter clean up any spacing issues

### 3. Fix diagnostics

1. After saving, check the diagnostic gutter. If there are errors from the rename, press `]d` to jump to the first one
2. Read the error message. If it is a missing import or reference, press `F4` for code actions
3. Select the appropriate fix
4. Press `]d` again to check for more diagnostics. Fix each one
5. Save again with `:w`. The file should be clean

### 4. Work with related files side by side

1. Type `:vs` to create a vertical split
2. In the right split, press F6 and open a test file or a file that imports from the file you just edited
3. Use `Ctrl-l` to move to the right split
4. If the rename broke something here, use `*` to find the old name
5. Use `ciw` to update it. Save with `:w`
6. Use `Ctrl-h` to go back to the left split and confirm your changes are consistent
7. Close the right split with `Ctrl-l` then `:q`

### 5. Switch repos and repeat

1. Press `kitty_mod+Right` to switch to the second Kitty tab
2. You are in a completely different project. Your tmux session is right where you left it
3. Open a file with F6. Use `di(` to clear some function arguments
4. Type new arguments. Press `Esc`. Save with `:w`
5. Use `]d` to check for any diagnostics. Fix them
6. Press `kitty_mod+Left` to switch back to the first repo. Everything is still there

### 6. Buffer management practice

1. In either repo, open three files using F6 (opening each one closes the previous view, but the buffer stays open)
2. Press F7. You should see all three files in the buffer list
3. Type `:vs` to split. Use F7 in the right split to pick a different buffer
4. Press `Ctrl-h` to go left. Press F7 to switch this split to the third buffer
5. You now have two files visible and a third ready in the buffer list
6. Close the split with `Ctrl-l` then `:q`. Press F7 to confirm all three buffers are still available

### 7. Reflect

1. Switch to the shell pane with `Ctrl-a l`
2. Think about these questions:
   - Which vim motion do I still hesitate on? Practice it for two more minutes
   - Do I instinctively save with `:w` or do I still think about it? It should be automatic
   - Can I switch between repos without pausing to remember the key? If not, practice `kitty_mod+Left`/`kitty_mod+Right` five more times
   - When I see a diagnostic, do I jump to it with `]d` or do I scroll looking for it?
3. Pick the one thing that felt slowest today. Spend five minutes drilling just that motion or action. Repetition is the only path to flow

## Success Check

- [ ] I set up a multi-repo workspace with two Kitty tabs and two tmux sessions
- [ ] I renamed a variable across a file using `*`, `ciw`, and `.`
- [ ] I fixed diagnostics using `]d` and `F4`
- [ ] I viewed two related files side by side with `:vs` and navigated between them
- [ ] I switched between repos using Kitty tabs without losing my place
- [ ] I managed multiple buffers with F7 and understand the difference between buffers and splits
- [ ] I identified what still feels slow and practiced it
