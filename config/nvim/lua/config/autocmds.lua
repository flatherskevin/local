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
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    vim.opt_local.linebreak = true
  end,
})

