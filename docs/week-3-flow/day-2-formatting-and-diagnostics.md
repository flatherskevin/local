# Week 3, Day 2: Formatting and Diagnostics

## Goal

Trust the formatter and the linter to catch mistakes so you can focus on logic instead of style.

## New Concepts

- **Format on save** - LazyVim is configured to auto-format your code every time you save with `:w`. You do not need to think about indentation, spacing, or trailing commas.
- `F3` - **format file manually**: triggers the formatter without saving. Useful when you want to see what the formatter will change before committing to it.
- `F4` - **code action**: opens a menu of quick fixes at your cursor position. This includes auto-imports, extract variable, remove unused code, and other LSP-powered suggestions.
- `]d` - **next diagnostic**: jumps the cursor to the next error or warning in the file.
- `[d` - **previous diagnostic**: jumps the cursor to the previous error or warning.
- **Diagnostic gutter** - the column to the left of the line numbers. Icons appear here when a line has an error (red), warning (yellow), or hint (blue). This is your early warning system.

## Exercises

### 1. See format on save in action

1. Run `dev` and open a project
2. Open a file with F6. Pick something with consistent formatting (a `.ts`, `.js`, or `.py` file works well)
3. Intentionally break the formatting: add extra spaces before an `=` sign, remove indentation from a line inside a block, or add a blank line in the middle of a function signature
4. Save the file with `:w`
5. Watch the formatting snap back. The extra spaces disappear. Indentation corrects. The formatter did its job
6. Repeat: break something else, save, watch it fix

### 2. Format manually with F3

1. In the same file, break the formatting again
2. This time, do not save. Instead press `F3`
3. The file formats in place without saving. You can see the changes but the file is still unsaved (look for the modified indicator in the status bar)
4. If you like the result, save with `:w`. If not, undo with `u`

### 3. Introduce a diagnostic error

1. In a file that has LSP support (TypeScript, Python, Go, etc.), introduce an error. Some examples:
   - Reference a variable that does not exist
   - Call a function with the wrong number of arguments
   - Add a type annotation that conflicts with the value
2. Save the file with `:w`
3. Look at the diagnostic gutter on the left. You should see a red icon on the line with the error
4. Your cursor may not be on the error line. That is fine. The gutter tells you something is wrong

### 4. Navigate diagnostics with ]d and [d

1. With the error still in your file, press `]d`
2. Your cursor jumps to the next diagnostic. A floating window may appear showing the error message
3. Press `]d` again. If there are more diagnostics, you jump to the next one. If not, you stay put
4. Press `[d` to jump to the previous diagnostic
5. Add a second error somewhere else in the file. Now use `]d` and `[d` to bounce between both errors
6. Read the error messages. They come from the language server. They tell you exactly what is wrong

### 5. Fix with code actions using F4

1. Place your cursor on a line with a diagnostic error
2. Press `F4`. A menu appears with available code actions
3. Look for a quick fix that resolves the error. This might be "Add missing import", "Remove unused variable", or "Fix all auto-fixable problems"
4. Select it with Enter
5. The error should disappear. Check the gutter -- the red icon is gone
6. If no useful code action appears, that is normal. Not every error has an automatic fix. Fix it manually and move on

### 6. Practice the full loop

1. Open a fresh file in the project
2. Write some code with intentional formatting problems and a missing import
3. Save with `:w`. Formatting fixes itself
4. Press `]d` to jump to the diagnostic about the missing import
5. Press `F4` and select the auto-import action
6. Save again. The file should be clean: well-formatted, no diagnostics
7. This is your editing loop: write, save, check diagnostics, fix, save

## Success Check

- [ ] I can see the formatter fix my code when I save with `:w`
- [ ] I can format manually with `F3` without saving
- [ ] I can spot diagnostic icons in the gutter and understand what they mean
- [ ] I can jump between diagnostics with `]d` and `[d`
- [ ] I can open code actions with `F4` and apply a quick fix
- [ ] I understand the loop: write, save, check diagnostics, fix
