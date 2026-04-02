# Week 1, Day 4: Git and Shell

## Goal

Use LazyGit for version control and the shell pane for running tests and commands alongside your editor.

## New Concepts

- `F3` - format the current file (auto-fix style, indentation, trailing whitespace)
- `F10` - open LazyGit (a full terminal UI for git inside Neovim)
- Inside LazyGit: `j`/`k` to navigate, `Space` to stage/unstage, `Enter` to expand, `c` to commit, `q` to quit
- `Ctrl-a l` - switch to shell pane to run tests, build commands, or any CLI tool
- `Ctrl-a h` - switch back to Neovim

## Exercises

### 1. Open a project and make a change

1. Run `dev` and open a project that has a git repo
2. Press `F6` and open a file you can safely edit (a README or a config file)
3. Press `o` to open a new line, type a comment like `# test change for Day 4`, press `Esc`
4. Type `:w` and press Enter to save

### 2. Format the file with F3

1. With the file still open, press `F3`
2. The file is formatted according to the project's formatter. You may see whitespace fixes, indentation changes, or nothing if the file was already clean
3. Type `:w` to save after formatting

### 3. Open LazyGit with F10

1. Press `F10`. LazyGit opens full-screen inside Neovim
2. You should see panels: files on the left, diff on the right
3. Use `j` and `k` to move through the file list on the left
4. Find the file you just edited. It should show as modified
5. Press `Enter` on the file to see the diff on the right. Your comment line should be highlighted as an addition

### 4. Stage and view the diff

1. With the modified file highlighted, press `Space` to stage it. The file moves from the unstaged section to the staged section
2. Press `Enter` to view the staged diff and confirm your change is there
3. Press `Space` again to unstage it. The file moves back to unstaged
4. Stage it again with `Space`. We will not commit this test change, but now you know the flow

### 5. Quit LazyGit

1. Press `q` to close LazyGit. You are back in Neovim with your file open
2. Press `F10` again to reopen LazyGit. Notice how fast it is
3. Press `q` to close it again

### 6. Run commands in the shell pane

1. Press `Ctrl-a l` to move to the shell pane
2. Type `git status` and press Enter. You should see your modified file listed
3. Type `git diff` and press Enter. You should see the same diff that LazyGit showed
4. If the project has tests, run them now. For example:
   - Python: `pytest` or `python -m pytest`
   - Node: `npm test`
   - Go: `go test ./...`
5. Read the output. The shell pane is where you run anything that needs a full terminal

### 7. Come back and clean up

1. Press `Ctrl-a h` to move back to Neovim
2. Press `u` until your test comment is removed
3. Type `:w` to save the file in its original state
4. Press `Ctrl-a l` to go to the shell. Type `git diff` and confirm the file is clean

## Success Check

- [ ] I can format a file with F3
- [ ] I can open LazyGit with F10 and close it with q
- [ ] I can see modified files and diffs in LazyGit
- [ ] I can stage and unstage files in LazyGit with Space
- [ ] I can switch to the shell pane and run git commands or tests
- [ ] I can switch back to Neovim and continue editing
- [ ] I understand the workflow: edit in Neovim, review in LazyGit, run commands in the shell
