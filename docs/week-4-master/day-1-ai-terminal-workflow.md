# Week 4, Day 1: AI Terminal Workflow

## Goal

Learn to use Claude Code as an AI-beside-editor tool with practical discipline.

If `claude` is not installed yet, enable the optional AI tools during bootstrap
with `LOCAL_INSTALL_AI_CLI=1 ~/.flatherskevin/local/bootstrap/macos.sh`, or
install `@anthropic-ai/claude-code` yourself before starting this lesson.

## New Concepts

- **AI-beside-editor pattern** -- Neovim on the left pane, Claude Code + shell on the right pane. The AI assists; you decide.
- **`claude`** -- launch Claude Code in the terminal. It reads your codebase and responds to natural language prompts.
- **Good uses for AI** -- code review, debugging help, implementation suggestions, architecture tracing, explaining unfamiliar code, generating boilerplate.
- **Bad uses for AI** -- replacing basic navigation you should learn, accepting large changes without reviewing them, skipping your own understanding of the code.
- **Practical discipline** -- always inspect the code yourself first, search the repo before asking, run tests after changes, review diffs before accepting.

## Exercises

### 1. Set up the AI-beside-editor layout

1. Run `dev` and open a project you are working on
2. Press `Ctrl-a l` to move to the right pane
3. Type `claude` and press Enter. Claude Code starts and loads your project context
4. Press `Ctrl-a h` to go back to Neovim. You now have editor on the left, AI on the right

### 2. Ask Claude Code to explain a function

1. In Neovim, open a file with a function you want to understand. Use `F6` to find the file by name
2. Note the function name and file path
3. Press `Ctrl-a l` to switch to Claude Code
4. Type: `Explain the function <function_name> in <file_path>. What does it do and why?`
5. Read the explanation. Switch back to Neovim with `Ctrl-a h` and verify the explanation matches what you see in the code
6. Notice: the AI gave you a head start, but you confirmed it yourself

### 3. Ask for a refactor suggestion

1. In Claude Code, type: `Suggest a refactor for <function_name> in <file_path>. Explain what you would change and why.`
2. Read the suggestion carefully. Do not accept it yet
3. Switch to Neovim with `Ctrl-a h`. Navigate to the function with `gd` or `F5` search
4. Read the original code. Decide: does the suggestion make sense? Would you make this change?
5. If yes, you can ask Claude Code to implement it. If no, say why and move on. The point is deliberate choice

### 4. Review a diff before accepting

1. If you asked Claude Code to make a change, switch to Neovim
2. Press `F10` to open LazyGit
3. Review the diff. Read every changed line
4. If the change is good, stage and commit it. If not, revert it
5. This is the discipline: AI proposes, you review, you decide

### 5. Practice the inspect-first habit

1. Pick a different part of the codebase you are less familiar with
2. Before asking Claude Code anything, spend 2 minutes navigating it yourself:
   - Use `F5` to search for key terms
   - Use `gd` to jump to definitions
   - Use `gr` to find references
   - Use `K` to read hover docs
3. Now ask Claude Code a specific question about what you found
4. Compare its answer to your own understanding. Notice how much more useful the AI is when you have context first

## Success Check

- [ ] I launched Claude Code in the right pane beside Neovim
- [ ] I asked Claude Code to explain a function and verified the explanation in the code
- [ ] I received a refactor suggestion and made a deliberate decision to accept or reject it
- [ ] I reviewed a diff in LazyGit before committing any AI-suggested change
- [ ] I navigated code myself before asking the AI, and noticed the difference in quality
