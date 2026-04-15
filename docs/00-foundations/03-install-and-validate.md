# Chapter 3: Install and Validate

## Install

```bash
git clone --depth 1 --branch main https://github.com/flatherskevin/local.git ~/.flatherskevin/local
cd ~/.flatherskevin/local
chmod +x bootstrap/macos.sh scripts/*.sh scripts/dev
./bootstrap/macos.sh
```

## What The Bootstrap Does

- installs Homebrew if missing
- installs packages from `Brewfile` (kitty, tmux, neovim, lazygit, fzf, fd,
  ripgrep, go, node, uv, terraform, tflint, yq, and others)
- symlinks config files into `~/.config` (nvim, tmux, kitty)
- wires the workflow shell additions into `.zshrc`
- installs Neovim plugins and language tooling via Lazy and Mason
- runs validation checks

## Validate

```bash
source ~/.zshrc
./scripts/validate-setup.sh
```

### Expected Output

A healthy run of `validate-setup.sh` looks like this:

```
[ok] fd
[ok] fzf
[ok] git
[ok] go
[ok] kitty
[ok] lazygit
[ok] nvim
[ok] node
[ok] rg
[ok] terraform
[ok] tflint
[ok] tmux
[ok] uv
[ok] yq
[ok] Neovim starts cleanly
[ok] tmux config loads cleanly
[dotfiles] validation passed
```

Every line should say `[ok]`. If any line says `[missing]`, that tool was not
installed by the bootstrap or is not on your PATH.

## Validate Neovim

Open Neovim:

```bash
nvim
```

### :checkhealth

Run `:checkhealth` inside Neovim. The key sections to look for:

```
nvim: require("nvim.health").check()
- OK Runtime: $VIMRUNTIME

lazy: require("lazy.health").check()
- OK lazy.nvim installed

mason: require("mason.health").check()
- OK mason.nvim installed

nvim-treesitter: require("nvim-treesitter.health").check()
- OK All parsers installed

conform: require("conform.health").check()
- OK Formatters available
```

Warnings about clipboard or Python providers are usually harmless. Errors about
missing plugins, broken treesitter parsers, or failed LSP configs need
attention.

### :Lazy

Run `:Lazy` to open the plugin manager. All plugins should show as installed
and loaded. If any show errors, press `U` to update or `I` to install missing
ones.

### :Mason

Run `:Mason` to see installed language servers, formatters, and linters. You
should see entries for the languages you work with (pyright, gopls,
typescript-language-server, terraform-ls, etc).

## Confirm LSP and Formatting

Open a real project file in each language you use:

- Python -- confirm diagnostics, hover, and F2 rename work
- Go -- confirm goimports runs on F3
- TypeScript -- confirm tsserver attaches and F4 code actions appear
- Terraform -- confirm terraform-ls attaches
- YAML -- confirm yaml-language-server attaches
- Markdown -- confirm formatting works with F3

Do not skip this step. A setup that looks installed but has broken LSP will
frustrate you immediately.

## Common Issues

### Neovim plugins fail to install

**Symptom**: `:Lazy` shows errors or missing plugins.

**Fix**: Run `:Lazy sync` to force a fresh install of all plugins. If that
fails, delete the plugin cache and reopen:

```bash
rm -rf ~/.local/share/nvim/lazy
nvim
```

Lazy will reinstall everything on next launch.

### `brew bundle` fails with `No available formula with the name "terraform"`

**Symptom**: Homebrew fails during bootstrap with an error like:

```text
Error: No available formula with the name "terraform".
```

**Fix**: This repo expects the HashiCorp Homebrew tap to be declared in the
`Brewfile`. Update your checkout to the latest `main` so the `Brewfile`
includes `tap "hashicorp/tap"` and installs `hashicorp/tap/terraform`, then
rerun:

```bash
brew bundle --file Brewfile
```

### tmux prefix does not work

**Symptom**: `Ctrl-a` does nothing or sends a literal character.

**Fix**: Confirm the config is symlinked correctly:

```bash
ls -la ~/.config/tmux/tmux.conf
```

It should point to `~/.flatherskevin/local/config/tmux/tmux.conf`. If not, re-run
the bootstrap or manually symlink:

```bash
ln -sf ~/.flatherskevin/local/config/tmux/tmux.conf ~/.config/tmux/tmux.conf
tmux source-file ~/.config/tmux/tmux.conf
```

### LSP not attaching to files

**Symptom**: No diagnostics, F2 rename does nothing, F4 shows no actions.

**Fix**: Open the file and run `:LspInfo`. If no client is attached, the
language server may not be installed. Open `:Mason` and install the server for
that language. Common ones:

- Python: `pyright`
- Go: `gopls`
- TypeScript: `typescript-language-server`
- Terraform: `terraform-ls`

### `dev` command not found

**Symptom**: Running `dev` returns "command not found."

**Fix**: The `dev` script needs to be on your PATH. Confirm your `.zshrc`
sources the workflow additions:

```bash
source ~/.zshrc
which dev
```

If `which dev` returns nothing, the bootstrap may not have wired the PATH
entry. Check that your `.zshrc` includes the local scripts directory or re-run
the bootstrap.
