# Week 2, Day 3: File Finding Mastery

## Goal

Replace scrolling and tree-browsing with fast, intentional search so you can reach any file or line in seconds.

## New Concepts

- **`F6` (Find files)** -- opens a fuzzy file finder. Type fragments of a filename and results narrow instantly. You do not need to type the full path.
- **`F5` (Search in project / grep)** -- searches the content of every file in the project. Type a function name, error message, or any string. Results show file, line number, and context.
- **`F7` (Switch buffer)** -- shows all files currently open in Neovim. Pick one to jump to it. Faster than cycling through tabs.
- **`/` (search within file)** -- press `/`, type a pattern, press Enter. The cursor jumps to the first match.
- **`n`** -- jump to the next match after a `/` search.
- **`N`** -- jump to the previous match.

## Exercises

1. Open a project with `dev`. Pick a project with at least 10 files so there is enough to search through.

2. Find a file by partial name. Press `F6`. Type just 2-3 characters from the middle of a filename (not the beginning). For example, if you want `user_service.py`, type `srv`. Watch the list filter down. Press `Enter` to open the match.

3. Find a file by path fragments. Press `F6` again. This time type fragments of the directory and filename separated by spaces. For example: `api user` to find `src/api/user_controller.ts`. The fuzzy finder matches across the full path.

4. Grep for a function name. Press `F5`. Type the name of a function you know exists in the project. The results show every line containing that string with surrounding context. Use `j`/`k` to move through results. Press `Enter` to jump to a match.

5. Grep for a pattern. Press `F5` again. Type something more specific, like an error message, a TODO comment, or a configuration key. Notice how grep searches file contents, not filenames.

6. Switch between open buffers. By now you have a few files open. Press `F7`. You see a list of open buffers. Type a fragment to filter, or use `j`/`k` to select one. Press `Enter` to switch.

7. Search within the current file. Press `/`. Type a variable name or keyword that appears multiple times in the file. Press `Enter`. The cursor jumps to the first match and all matches are highlighted.

8. Navigate matches. Press `n` to jump to the next match. Press `N` to jump to the previous match. Do this until you have cycled through all occurrences. Press `Esc` or type `:noh` and press `Enter` to clear the highlights.

9. Combine the tools. Try this sequence:
   - `F5` to grep for a function name. Jump to a result.
   - `/` to search within that file for a specific variable.
   - `n`/`N` to scan through matches.
   - `F7` to switch back to a previous buffer.
   - `F6` to open a completely different file.

   This is your file-finding stack. Get comfortable switching between these modes.

10. Speed drill. Pick five files in your project that you know exist. Time yourself opening each one using only `F6`. Then pick five strings you know exist in the codebase and find each one using `F5`. The goal is not speed yet -- the goal is zero hesitation about which key to press.

## Success Check

- [ ] I can open any file in the project using `F6` with partial name fragments.
- [ ] I can find any string in the codebase using `F5`.
- [ ] I can switch between open files using `F7` without closing anything.
- [ ] I can search within a file using `/` and navigate matches with `n`/`N`.
- [ ] I did not use the file explorer tree to find a file during these exercises.
