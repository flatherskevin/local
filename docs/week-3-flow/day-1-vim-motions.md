# Week 3, Day 1: Vim Motions

## Goal

Edit code using motions that operate on text objects instead of selecting characters one at a time.

## New Concepts

- `ciw` - **change inner word**: deletes the word under the cursor and drops you into insert mode. Use it to rename variables.
- `di(` - **delete inside parens**: deletes everything between the nearest `(` and `)` without deleting the parens themselves. Also works as `di)`.
- `di"` - **delete inside quotes**: deletes everything between the nearest double quotes. Also works with `di'` for single quotes.
- `%` - **matching bracket**: jumps the cursor to the matching bracket, paren, or brace. Press again to jump back.
- `*` - **search word under cursor**: searches forward for the exact word under the cursor. Press `n` for next match, `N` for previous.
- `gg` - **go to top**: jumps to the first line of the file.
- `G` - **go to bottom**: jumps to the last line of the file.
- `w` - **word forward**: moves the cursor to the start of the next word.
- `b` - **word backward**: moves the cursor to the start of the previous word.

## Exercises

### 1. Change a word with ciw

1. Run `dev` and open a project with code files
2. Open a file with F6 and pick one that has variables or function names
3. Move your cursor onto a variable name using `w` and `b` to navigate word by word
4. Press `ciw`. The word disappears and you are in insert mode
5. Type a new name, then press `Esc` to return to normal mode
6. Press `u` to undo. The original name returns
7. Repeat this on three different words. Get comfortable with the rhythm: navigate, `ciw`, type, `Esc`

### 2. Delete inside parens with di(

1. Find a function call with arguments, something like `doSomething(arg1, arg2, arg3)`
2. Move your cursor anywhere between the parentheses
3. Press `di(`. All the arguments disappear but the parens remain: `doSomething()`
4. Press `u` to undo
5. Now try `ci(` instead. Same thing, but you land in insert mode ready to type new arguments
6. Type some replacement text, then press `Esc`
7. Press `u` to undo

### 3. Delete inside quotes with di"

1. Find a string literal in the code, something like `"hello world"`
2. Move your cursor anywhere between the quotes
3. Press `di"`. The string content disappears but the quotes remain: `""`
4. Press `u` to undo
5. Try `ci"` to delete and enter insert mode. Type a new string, press `Esc`
6. Press `u` to undo

### 4. Jump to matching brackets with %

1. Find a function body or block with opening `{`
2. Place your cursor on the `{`
3. Press `%`. Your cursor jumps to the matching `}`
4. Press `%` again. You jump back to `{`
5. Try this with `(` and `)` as well
6. This works anywhere in a file. Find a deeply nested block and use `%` to quickly identify where it ends

### 5. Search word under cursor with *

1. Place your cursor on a variable name that appears multiple times in the file
2. Press `*`. The cursor jumps to the next occurrence. All occurrences are highlighted
3. Press `n` to go to the next match
4. Press `N` to go to the previous match
5. Press `*` on a different word to start a new search
6. This is the fastest way to find all uses of a variable in a file

### 6. Navigate with gg, G, w, and b

1. Press `G` to jump to the bottom of the file. The line number in your status bar should be the last line
2. Press `gg` to jump to the top. You should be on line 1
3. Press `w` five times. Count the words you skip over. Each press lands on the start of the next word
4. Press `b` five times. You move back word by word
5. Try `5w` to jump forward five words in one motion. Try `3b` to go back three words
6. Combine with editing: `3ciw` does not exist, but `c3w` does -- it changes from the cursor through the next three words

## Success Check

- [ ] I can rename a variable with `ciw` without selecting characters
- [ ] I can clear function arguments with `di(` and the parens stay intact
- [ ] I can clear a string with `di"` and the quotes stay intact
- [ ] I can jump between matching brackets with `%`
- [ ] I can search for the word under my cursor with `*` and navigate matches with `n`/`N`
- [ ] I can jump to the top of a file with `gg` and the bottom with `G`
- [ ] I can move word by word with `w` and `b`
