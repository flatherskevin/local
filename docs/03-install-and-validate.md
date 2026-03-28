# Chapter 3: Install And Validate

## Install

```bash
git clone https://github.com/flatherskevin/local.git ~/codebase/local
cd ~/codebase/local
chmod +x bootstrap/macos.sh scripts/*.sh scripts/dev
./bootstrap/macos.sh
```

## What The Bootstrap Does

- installs Homebrew if missing
- installs packages from `Brewfile`
- symlinks config files into `~/.config`
- wires the workflow shell additions into `.zshrc`
- installs Neovim plugins and language tooling
- runs validation checks

## Validate

```bash
source ~/.zshrc
./scripts/validate-setup.sh
nvim
```

Inside Neovim, run:

- `:checkhealth`
- `:Lazy`
- `:Mason`

Open a real project file in Python, Go, TypeScript, Terraform, YAML, and
Markdown so you can confirm LSP and formatting behavior with real code.

