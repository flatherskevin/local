# Week 4, Day 3: Advanced Patterns

## Goal

Use WhichKey menus, text objects, visual mode, and macros to edit code faster than you thought possible.

## New Concepts

- **WhichKey** -- press `Space` in normal mode and wait. A popup shows every leader-key combo available. Navigate by pressing the next key in the sequence.
- **Leader-key combos** -- `Space` is the leader key. Examples: `Space f f` to find files, `Space s g` to search with grep, `Space b d` to delete a buffer.
- **Text objects** -- operators like `d`, `c`, `y` combine with text objects to act on structured chunks of text:
  - `iw` -- inner word (the word under the cursor, no surrounding spaces)
  - `i(` or `ib` -- inner parentheses (everything inside `()`)
  - `i"` -- inner quotes (everything inside `""`)
  - `it` -- inner tag (everything inside an HTML/JSX tag)
  - `a{` or `aB` -- around braces (everything inside `{}` including the braces)
- **Visual mode** -- select text before acting on it:
  - `v` -- character-wise visual mode
  - `V` -- line-wise visual mode (selects whole lines)
  - `Ctrl-v` -- block visual mode (selects a rectangular column)
- **Macros** -- record a sequence of keystrokes and replay them:
  - `q{register}` -- start recording into a register (e.g., `qa` records into register `a`)
  - `q` -- stop recording
  - `@{register}` -- replay the macro (e.g., `@a`)
  - `@@` -- replay the last macro again

## Exercises

### 1. Explore WhichKey menus

1. Open a project with `dev`
2. In Neovim, press `Space` and wait half a second. The WhichKey popup appears
3. Read the top-level categories. You will see groups like `f` (file), `s` (search), `b` (buffer), `g` (git), `c` (code)
4. Press `s` to enter the search group. Read the options. Press `Esc` to back out
5. Press `Space` again, then press `b` to see buffer commands. Press `Esc`
6. Now try three actions from WhichKey:
   - `Space f f` -- find a file (same as F6)
   - `Space s g` -- grep search across the project (same as F5)
   - `Space b d` -- close the current buffer
7. Notice: WhichKey is a discovery tool. When you forget a binding, press `Space` and browse

### 2. Practice text objects

1. Open a file with functions that have parameters. A JavaScript, TypeScript, or Python file works well
2. Place your cursor inside a function's parentheses, on a parameter name
3. Type `ci(` -- this deletes everything inside the parentheses and puts you in insert mode. Type new parameters, then press `Esc`
4. Undo with `u`. Now try `di(` -- this deletes inside the parens without entering insert mode
5. Find a quoted string in the file. Place your cursor inside the quotes
6. Type `ci"` -- this changes the contents of the string. Type a new string, press `Esc`
7. Find a block wrapped in curly braces. Place your cursor inside
8. Type `da{` -- this deletes the entire block including the braces
9. Undo with `u`. Try `di{` -- deletes the contents but keeps the braces
10. Find a word. Place your cursor on it. Type `ciw` -- changes the word. Type a replacement, press `Esc`

### 3. Use visual mode

1. Move to a line in the middle of a file
2. Press `V` to enter line-wise visual mode. The entire line highlights
3. Press `j` three times to extend the selection down by three lines
4. Press `d` to delete the selected lines. Undo with `u`
5. Now try block visual mode. Place your cursor at the start of a line
6. Press `Ctrl-v` to enter block mode. Press `j` four times to extend down, then press `l` a few times to extend right
7. You have a rectangular selection. Press `d` to delete the block. Undo with `u`
8. Try block insert: press `Ctrl-v`, select a column of lines, press `I` (capital I), type `// `, press `Esc`. Every line in the selection gets the prefix

### 4. Record and replay a macro

1. Open a file with repetitive lines that need the same edit. If you do not have one, create a scratch file:
   ```
   :e /tmp/macro-practice.txt
   ```
   Enter insert mode and type five lines like:
   ```
   name: alice
   name: bob
   name: charlie
   name: dave
   name: eve
   ```
   Save with `:w`
2. Move your cursor to the first line. Press `0` to go to the start
3. Press `qa` to start recording into register `a`. The status bar shows `recording @a`
4. Type `0f:lciw"alice"` -- go to start, find `:`, move right, change the word, wrap it in quotes. Press `Esc`
5. Press `j` to move to the next line
6. Press `q` to stop recording
7. Now press `@a` to replay the macro on the current line. The name should get quoted
8. Press `3@a` to replay it on the next three lines at once
9. All lines are formatted. Macros turn a 30-second repetitive task into a 2-second replay

## Success Check

- [ ] I pressed Space and explored at least three WhichKey groups
- [ ] I used `ci(`, `ci"`, and `da{` to edit text objects without selecting manually
- [ ] I used `V` to select and delete multiple lines
- [ ] I used `Ctrl-v` to make a block selection and insert text on multiple lines
- [ ] I recorded a macro with `qa`, replayed it with `@a`, and applied it to multiple lines
