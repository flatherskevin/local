local augroup = vim.api.nvim_create_augroup("workflow", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight text after yanking",
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  desc = "Keep split sizes balanced after resizing the terminal",
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "markdown", "gitcommit", "text" },
  desc = "Make prose buffers easier to read and edit",
  callback = function(args)
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true

    -- Keep diagnostics out of prose buffers unless explicitly toggled on.
    vim.diagnostic.enable(false, { bufnr = args.buf })

    vim.keymap.set("n", "<leader>md", function()
      local enabled = vim.diagnostic.is_enabled({ bufnr = args.buf })
      vim.diagnostic.enable(not enabled, { bufnr = args.buf })
    end, { buffer = args.buf, desc = "Toggle buffer diagnostics" })
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  group = augroup,
  pattern = { "*.md", "*.mdx", "*.txt" },
  desc = "Show diagnostics in a float for prose buffers",
  callback = function(args)
    if not vim.diagnostic.is_enabled({ bufnr = args.buf }) then
      return
    end
    if vim.api.nvim_get_current_buf() ~= args.buf or vim.fn.mode() ~= "n" then
      return
    end

    local line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diagnostics = vim.diagnostic.get(args.buf, { lnum = line })
    if #diagnostics == 0 then
      return
    end

    vim.diagnostic.open_float(args.buf, {
      scope = "line",
      focusable = false,
      close_events = { "CursorMoved", "CursorMovedI", "BufHidden", "InsertEnter" },
      border = "rounded",
      source = "if_many",
    })
  end,
})
