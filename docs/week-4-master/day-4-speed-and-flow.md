# Week 4, Day 4: Speed and Flow

## Goal

Measure your speed, identify friction, and build the shortcuts that make your workflow yours.

## New Concepts

- **Timed practice** -- performing a full workflow end-to-end while tracking how long it takes. Repetition compresses time.
- **Friction audit** -- noticing what makes you pause, hesitate, or reach for documentation. Those pauses are where speed hides.
- **Personal shortcuts** -- aliases, keymaps, and habits that remove your specific friction points. No two developers have the same set.

## Exercises

### 1. Timed workflow challenge

You will perform one complete workflow cycle and time it. Use a stopwatch or your phone timer.

The workflow:

1. Start the timer
2. Run `dev` and open a project
3. Find a specific file by name using `F6`
4. Search the project for a function or variable name using `F5`
5. Jump to its definition with `gd`
6. Find all references with `gr` and visit one
7. Make a small edit (change a comment, rename a variable with `ciw`, fix a typo)
8. Format the file with `F3`
9. Open LazyGit with `F10`, review the diff, stage the change, write a commit message, commit
10. Stop the timer

Write down your time: ______

### 2. Do it again

1. Repeat the exact same workflow on the same project. Same file, same search, same edit pattern
2. Write down your time: ______
3. It should be faster. If it is not, identify which step slowed you down

### 3. Do it a third time

1. One more time. Same workflow
2. Write down your time: ______
3. Compare all three times. You should see a clear downward trend. This is muscle memory forming in real time

### 4. Friction audit

Sit back and think about the three rounds. Answer these questions honestly:

1. **Where did I pause?** -- which step made you stop and think about what key to press? Write it down
2. **Where did I reach for documentation?** -- did you check `cheat` or `keys` during the run? What were you looking up?
3. **What felt clumsy?** -- which motion or command did you fumble? Did you mistype a key combo? Get lost in a menu?

Write down your **three biggest friction points**:

1. ______
2. ______
3. ______

### 5. Build one personal shortcut

Pick your biggest friction point and fix it with a shortcut:

- If you keep typing a long command, add an alias to `config/zsh/workflow.zsh`:
  ```
  alias myalias="the-long-command"
  ```
  Then run `source ~/.zshrc` to activate it

- If you keep forgetting a Neovim action, add a keymap to `config/nvim/lua/config/keymaps.lua`:
  ```lua
  vim.keymap.set("n", "<leader>x", "<cmd>SomeCommand<cr>", { desc = "My shortcut" })
  ```
  Then reload with `:source %`

- If a tmux action takes too many keystrokes, add a binding to `config/tmux/tmux.conf`:
  ```
  bind-key X some-tmux-command
  ```
  Then reload with `Ctrl-a r`

### 6. Test your shortcut

1. Use your new shortcut in a real task
2. Run the timed workflow one more time. Write down your time: ______
3. Compare to your first run. Every second you shaved off is permanent

## Success Check

- [ ] I completed the timed workflow at least three times and recorded my times
- [ ] My times decreased across the three runs
- [ ] I identified my three biggest friction points
- [ ] I created at least one personal shortcut (alias, keymap, or tmux binding)
- [ ] I tested the shortcut and confirmed it works
