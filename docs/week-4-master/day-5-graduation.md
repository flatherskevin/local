# Week 4, Day 5: Graduation

## Goal

Assess everything you have learned across all four weeks, identify what to practice next, and leave with a plan.

## New Concepts

- **Self-assessment** -- honestly evaluating which skills are automatic, which are shaky, and which are still unknown.
- **Deliberate practice** -- choosing your weakest skill and practicing it specifically, not just using whatever comes naturally.
- **Going deeper** -- every tool you use has more to offer. The question is not whether there is more to learn, but which thing to learn next.

## Exercises

### 1. Final assessment checklist

Work through each skill. Do it right now, not from memory. Actually perform each action. Mark it honestly.

**Week 1 -- Survive:**
- [ ] Open a project with `dev` and land in the two-pane layout
- [ ] Switch between Neovim and the shell pane with `Ctrl-a h` / `Ctrl-a l`
- [ ] Find a file by name with `F6`
- [ ] Search across the project with `F5`
- [ ] Open the file explorer with `F8`
- [ ] Enter insert mode, type text, save, and quit (`:wq`)
- [ ] Undo and redo changes with `u` and `Ctrl-r`

**Week 2 -- Navigate:**
- [ ] Create tmux splits with `Ctrl-a |` and `Ctrl-a -`
- [ ] Navigate panes with `Ctrl-a h/j/k/l`
- [ ] Create and switch tmux windows with `Ctrl-a c`, `Ctrl-a n`, `Ctrl-a p`
- [ ] Jump to a definition with `gd`
- [ ] Find references with `gr`
- [ ] Read hover documentation with `K`
- [ ] Navigate diagnostics with `]d` and `[d`
- [ ] Jump back and forth with `Ctrl-o` and `Ctrl-i`
- [ ] Switch buffers with `F7`

**Week 3 -- Flow:**
- [ ] Use word motions: `w`, `b`, `e`
- [ ] Use `ciw` to change a word, `di(` to delete inside parens, `ci"` to change inside quotes
- [ ] Format a file with `F3`
- [ ] Apply a code action with `F4`
- [ ] Work across multiple repos using Kitty tabs
- [ ] Create vertical and horizontal splits in Neovim with `:vs` and `:sp`
- [ ] Move between Neovim splits with `Ctrl-h/j/k/l`

**Week 4 -- Master:**
- [ ] Use Claude Code beside Neovim with discipline (inspect first, review diffs, decide deliberately)
- [ ] Add a shell alias and source it
- [ ] Add a Neovim keymap and reload it
- [ ] Explore WhichKey by pressing `Space` and navigating groups
- [ ] Use `V` for line select and `Ctrl-v` for block select
- [ ] Record a macro with `qa` and replay it with `@a`
- [ ] Open LazyGit with `F10`, stage changes, and commit
- [ ] Complete a full workflow (find, navigate, edit, format, commit) without pausing

### 2. Count your results

Go back through the checklist. Count:

- **Solid** (checked without hesitation): ______
- **Shaky** (checked but had to think): ______
- **Missing** (could not do it): ______

Write down the shaky and missing items. Those are your practice list.

### 3. Reflection

Answer these questions for yourself:

1. What is the single biggest change in how you work compared to four weeks ago?
2. What key combo or workflow has become completely automatic?
3. What still feels uncomfortable?
4. When do you instinctively reach for the mouse, and can you replace that with a keystroke?

### 4. Build your practice plan

Pick your **three weakest skills** from the checklist. For each one:

1. Write the skill
2. Write one specific exercise you will do to practice it
3. Commit to doing that exercise once a day for the next week

Example:
- **Skill:** text objects (`ci(`, `da{`)
- **Exercise:** open any file, find 5 pairs of brackets/braces/quotes, and use `ci` or `da` on each one
- **Frequency:** once a day for 5 days

### 5. Resources for going deeper

You do not need to study these now. Bookmark them for when you are ready:

- **Neovim:** `:help` inside Neovim is the most complete reference. Try `:help text-objects`, `:help registers`, `:help quickfix`.
- **tmux:** `man tmux` covers every option. Focus on the sections about key bindings and session management.
- **LazyVim:** the LazyVim documentation at `lazyvim.org` explains the plugin structure and how to override defaults.
- **Kitty:** `kitty.conf` is self-documenting. Read the comments in the default config for every option.
- **Vim motions practice:** `vimtutor` (run it from the terminal) is still the best drill for basic motions.
- **`cheat` / `keys`** -- your built-in cheatsheet. Use it whenever you forget a binding. The goal is to need it less each week.

## Success Check

- [ ] I completed the full assessment checklist by actually performing each action
- [ ] I counted my solid, shaky, and missing skills honestly
- [ ] I identified my three weakest skills and wrote a practice plan for each
- [ ] I know where to find documentation when I want to go deeper
- [ ] I can open a project, find files, navigate code, make edits, format, and commit without reaching for a mouse
