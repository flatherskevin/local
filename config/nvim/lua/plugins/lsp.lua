return {
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
      ensure_installed = {
        "bashls",
        "gopls",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "ruff",
        "taplo",
        "terraformls",
        "tflint",
        "vtsls",
        "yamlls",
      },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
      ensure_installed = {
        "eslint-lsp",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "json-lsp",
        "markdownlint-cli2",
        "marksman",
        "prettierd",
        "pyright",
        "ruff",
        "shellcheck",
        "shfmt",
        "stylua",
        "taplo",
        "terraform-ls",
        "tflint",
        "typescript-language-server",
        "yaml-language-server",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = false,
        virtual_lines = false,
        signs = true,
        underline = true,
      },
      servers = {
        bashls = {
          filetypes = { "sh", "bash", "zsh", "ksh", "dash", "csh" },
        },
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              gofumpt = true,
              staticcheck = true,
              usePlaceholders = true,
            },
          },
        },
        jsonls = {},
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "LazyVim" },
              },
            },
          },
        },
        marksman = {},
        pyright = {
          root_dir = function(fname)
            return require("lspconfig.util").root_pattern("pyrightconfig.json", ".git")(fname)
              or vim.fn.getcwd()
          end,
          before_init = function(_, config)
            local venv = config.root_dir .. "/.venv/bin/python"
            if vim.fn.filereadable(venv) == 1 then
              config.settings.python.pythonPath = venv
            end
          end,
          settings = {
            pyright = {
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                autoImportCompletions = true,
                diagnosticMode = "workspace",
                typeCheckingMode = "basic",
              },
            },
          },
        },
        ruff = {},
        taplo = {},
        terraformls = {},
        tflint = {},
        vtsls = {
          settings = {
            javascript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
            typescript = {
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals" },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
      },
      setup = {
        ruff = function()
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and client.name == "ruff" then
                client.server_capabilities.hoverProvider = false
              end
            end,
          })
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      format_on_save = {
        lsp_format = "fallback",
        timeout_ms = 500,
      },
      formatters_by_ft = {
        go = { "gofumpt", "goimports" },
        javascript = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        lua = { "stylua" },
        markdown = { "prettierd", "prettier" },
        python = { "ruff_fix", "ruff_format" },
        sh = { "shfmt" },
        terraform = { "terraform_fmt" },
        toml = { "taplo" },
        typescript = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
        zsh = { "shfmt" },
      },
    },
  },
}
