# Week 1, Day 2: Files and Search

## Goal

Find any file by name, search for any text across the project, and browse the file tree without leaving Neovim.

## New Concepts

- `F6` - Find files by name (fuzzy finder, type partial names to filter)
- `F5` - Search in project (grep across all files, type a string to find every occurrence)
- `F8` - Toggle the file explorer sidebar on the left
- Inside any fuzzy picker: `Enter` to open, `Esc` to cancel, arrow keys or `Ctrl-j`/`Ctrl-k` to move up/down

## Exercises

### 1. Open a project

1. Type `dev` and select a project you are familiar with. One where you know some file names and function names
2. Your cursor should be in the Neovim pane

### 2. Find a file by name with F6

1. Press `F6`. A fuzzy finder popup appears
2. Start typing the name of a file you know exists (for example `README` or `index` or `main`)
3. As you type, the list filters down. You do not need the full name. Partial matches work
4. Use arrow keys to highlight the file you want
5. Press `Enter` to open it. The file appears in the editor
6. Press `F6` again. This time type a different file name and open it
7. Press `Esc` to close the picker without opening anything. This is your escape hatch

### 3. Search for text across the project with F5

1. Press `F5`. A search prompt appears
2. Type the name of a function, variable, or string you know exists in the project (for example `TODO` or `import` or a specific function name)
3. Results appear as you type, showing the file path, line number, and matching text
4. Use arrow keys to select a result and press `Enter` to jump directly to that line in that file
5. Press `F5` again. Search for a different term. Notice how fast it searches the entire project
6. Press `Esc` to close the search without jumping anywhere

### 4. Browse the file tree with F8

1. Press `F8`. A file explorer panel appears on the left side of the editor
2. Use `j` and `k` to move down and up in the tree
3. Press `Enter` on a folder to expand or collapse it
4. Press `Enter` on a file to open it
5. Press `F8` again to close the explorer panel
6. Press `F8` one more time to reopen it. Get used to toggling it on and off

### 5. Combine them

1. Close the explorer with `F8` if it is open
2. Press `F5` and search for a specific string. Jump to a result
3. Now press `F6` and open a different file
4. Now press `F8` and browse to a third file
5. You just navigated to three different files three different ways. Each method is useful for different situations:
   - **F6** when you know the file name
   - **F5** when you know the text but not the file
   - **F8** when you want to browse the structure

## Success Check

- [ ] I can open the fuzzy file finder with F6 and find a file by typing part of its name
- [ ] I can search the entire project for a text string with F5
- [ ] I can jump directly to a search result from the F5 picker
- [ ] I can toggle the file explorer with F8 and navigate it with j/k/Enter
- [ ] I can close any picker with Esc without opening anything
- [ ] I know when to use F5 vs F6 vs F8
