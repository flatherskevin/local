# Week 2, Day 2: LSP Navigation

## Goal

Use the Language Server Protocol to navigate code by meaning instead of by filename and line number.

## New Concepts

- **`gd`** -- go to definition. Place your cursor on a function call, class name, or variable and press `gd`. Neovim jumps to where it is defined.
- **`gr`** -- find references. Shows every place the symbol under your cursor is used across the project.
- **`K`** -- hover documentation. Shows the type signature, docstring, or documentation for the symbol under your cursor in a floating window.
- **`]d`** -- jump to the next diagnostic (error/warning) in the current file.
- **`[d`** -- jump to the previous diagnostic.
- **`Ctrl-o`** -- jump back. After `gd` takes you somewhere, `Ctrl-o` brings you back to where you were. This is your undo for navigation.
- **`Ctrl-i`** -- jump forward. The opposite of `Ctrl-o`. Moves forward through your jump history.

## Exercises

1. Open a project with LSP support. Use the `dev` command to open a project you have locally. Pick one with Python, TypeScript, or any language where you have a language server installed.

2. Find a function call. Open a file that calls a function defined elsewhere. Place your cursor on the function name.

3. Jump to definition. Press `gd`. Neovim should jump to the file and line where the function is defined. Read the definition. Note the filename in the status bar.

4. Jump back. Press `Ctrl-o`. You are back where you started. Press `Ctrl-i` to go forward to the definition again. Practice this back-and-forth three times. This is your navigation stack.

5. Find all references. Go back to the function call (`Ctrl-o`). Place your cursor on the function name and press `gr`. A list appears showing every file and line that uses this function. Use `j`/`k` to browse the list. Press `Enter` to jump to one.

6. Hover for docs. Navigate to any symbol -- a function, class, or variable. Press `K` (capital K, meaning `Shift-k`). A floating window shows the type signature and documentation. Press `K` again or move the cursor to dismiss it.

7. Navigate diagnostics. If your project has any errors or warnings (yellow/red squiggly lines), press `]d` to jump to the next one. Press `[d` to go to the previous one. Read what each diagnostic says in the floating message.

8. Chain it together. Starting from any file:
   - `gd` on a function call to jump to its definition.
   - Inside that definition, `gd` on another symbol to go deeper.
   - `K` on a type or parameter to read its docs.
   - `Ctrl-o` three times to walk back through every jump.
   - `gr` on the original function to see all its callers.

9. Practice the loop. Pick three different function calls in your project. For each one, do the full cycle: `gd` to definition, `K` for docs, `gr` for references, `Ctrl-o` to return. Repeat until the keys are automatic.

## Success Check

- [ ] I can jump to a function's definition with `gd` and return with `Ctrl-o`.
- [ ] I can find all references to a symbol with `gr`.
- [ ] I can hover on a symbol with `K` and read its type/docs.
- [ ] I can navigate between diagnostics with `]d` and `[d`.
- [ ] I used `Ctrl-o` and `Ctrl-i` to move through my jump history.
- [ ] I navigated at least three levels deep with `gd` and came back with `Ctrl-o`.
