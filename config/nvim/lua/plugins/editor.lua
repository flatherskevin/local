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
        mappings = {
          ["y"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg("+", path)
            vim.notify("Copied: " .. path)
          end,
          ["Y"] = function(state)
            local node = state.tree:get_node()
            local path = vim.fn.fnamemodify(node:get_id(), ":.")
            vim.fn.setreg("+", path)
            vim.notify("Copied: " .. path)
          end,
          ["yp"] = function(state)
            local node = state.tree:get_node()
            local path = vim.fn.fnamemodify(node:get_id(), ":.")
            vim.fn.setreg("+", path)
            vim.notify("Copied: " .. path)
          end,
        },
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
    build = "cd app && npx --yes yarn install",
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
    "mg979/vim-visual-multi",
    event = "VeryLazy",
    init = function()
      vim.g.VM_maps = {
        ["Add Cursor Down"] = "<M-S-Down>",
        ["Add Cursor Up"] = "<M-S-Up>",
      }
    end,
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
