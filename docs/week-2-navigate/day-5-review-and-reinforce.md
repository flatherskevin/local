# Week 2, Day 5: Review and Reinforce

## Goal

Combine everything from this week into a single sustained practice session that exercises tmux, LSP, and file finding together.

## New Concepts

No new concepts today. This is about wiring together what you already know.

## Exercises

### Part 1: Set Up Your Workspace

1. Open two projects using `dev`. Pick two real projects you work on. After this step you should have two tmux sessions running.

2. In the first project session, verify your layout. You should have Neovim in one pane and a shell in another. If not, create the layout: `Ctrl-a |` to split, open `nvim` in one pane.

3. In the second project session, do the same. Use `Ctrl-a s` to switch between sessions and confirm both are ready.

### Part 2: LSP Navigation Drill

4. In project one, use `F6` to open a file that contains a function call to another module.

5. Place your cursor on the function call. Press `gd` to jump to its definition.

6. At the definition, press `K` to read the hover docs. Note the parameter types or docstring.

7. Press `gr` to find all references. Pick one from a different file and jump to it.

8. Press `Ctrl-o` repeatedly until you are back at the original file. Count the jumps. You should have at least 3.

### Part 3: Cross-Session File Finding

9. Switch to project two using `Ctrl-a s`.

10. Use `F5` to grep for a keyword relevant to that project -- an API endpoint, a class name, a configuration key. Jump to a result.

11. Use `/` to search within that file for a specific variable. Navigate with `n` and `N`.

12. Use `F7` to switch to a different open buffer. If none are open, use `F6` to open two more files first, then use `F7` to switch between them.

13. Switch back to project one using `Ctrl-a s`. Confirm your Neovim state is exactly as you left it -- same file, same cursor position.

### Part 4: Layout Management

14. In project one, create an additional pane. Press `Ctrl-a -` to split your Neovim pane vertically. Use the bottom pane to run a command like `git log --oneline -10`.

15. Resize the bottom pane smaller. Press `Ctrl-a K` (Shift-k) a few times to make it shorter. You want just enough space to see the git log.

16. Zoom into the Neovim pane with `Ctrl-a z`. Do some editing or navigation. Unzoom with `Ctrl-a z` when done.

17. Try `Ctrl-a =` to reset to even layout. Then adjust again to your preference.

### Part 5: Full Cycle

18. Without any instructions, do the following from memory:
    - Switch to project two.
    - Find a specific file by name.
    - Go to a function definition.
    - Check its references.
    - Jump back.
    - Grep for a string across the project.
    - Switch back to project one.

    If you had to look up a key binding, note which one. That is what to practice tomorrow.

### Reflection

Answer these honestly:

- Which key binding do I still hesitate on?
- Am I reaching for the mouse at any point? When?
- Do I default to `F6`/`F5` for finding things, or do I still scroll the file tree?
- Can I switch tmux sessions without thinking?
- What is my weakest area: tmux management, LSP navigation, or file finding?

Write your answers down. Your weak area is your focus for next week's warm-ups.

## Success Check

- [ ] I had two project sessions running and switched between them.
- [ ] I used `gd`, `gr`, `K`, and `Ctrl-o` in a real project without looking up the keys.
- [ ] I used `F5`, `F6`, and `F7` to find files and content.
- [ ] I resized panes and used zoom.
- [ ] I completed Part 5 from memory.
- [ ] I identified my weakest area and wrote it down.
