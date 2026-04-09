return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    cmd = { "ToggleTerm", "TermExec" },
    opts = {
      direction = "vertical",
      size = 72,
      persist_mode = true,
      persist_size = true,
      shade_terminals = false,
      start_in_insert = true,
    },
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = { ".git" },
        },
        follow_current_file = {
          enabled = true,
        },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_current",
      },
      window = {
        width = function()
          return math.floor(vim.o.columns / 5)
        end,
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "javascript",
        "json",
        "lua",
        "make",
        "markdown",
        "markdown_inline",
        "python",
        "terraform",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      })
    end,
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        close_command = function(bufnum)
          Snacks.bufdelete({ buf = bufnum })
        end,
        right_mouse_command = function(bufnum)
          Snacks.bufdelete({ buf = bufnum })
        end,
      },
    },
  },
  {
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    keys = {
      { "<leader>sr", "<cmd>GrugFar<cr>", desc = "Search and Replace (grug-far)" },
    },
    opts = {},
  },
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gvdiffsplit", "Glog", "Gblame" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status (fugitive)" },
      { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git diff split" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
      { "<leader>gl", "<cmd>Gclog<cr>", desc = "Git log" },
    },
  },
}
