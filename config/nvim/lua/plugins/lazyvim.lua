return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
      news = {
        lazyvim = false,
        neovim = false,
      },
    },
  },

  { import = "lazyvim.plugins.extras.editor.neo-tree" },
  { import = "lazyvim.plugins.extras.editor.snacks_picker" },
  { import = "lazyvim.plugins.extras.util.lazygit" },

  { import = "lazyvim.plugins.extras.lang.go" },
  { import = "lazyvim.plugins.extras.lang.json" },
  { import = "lazyvim.plugins.extras.lang.markdown" },
  { import = "lazyvim.plugins.extras.lang.python" },
  { import = "lazyvim.plugins.extras.lang.terraform" },
  { import = "lazyvim.plugins.extras.lang.toml" },
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "lazyvim.plugins.extras.lang.yaml" },
}

