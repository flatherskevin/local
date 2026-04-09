local map = vim.keymap.set

local function picker(method, opts)
  return function()
    local ok, snacks = pcall(require, "snacks")
    if ok and snacks.picker and snacks.picker[method] then
      snacks.picker[method](opts or {})
    end
  end
end

map("n", "<F1>", "<cmd>WhichKey<cr>", { desc = "Show keymaps" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename symbol" })
map({ "n", "x" }, "<F3>", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, { desc = "Format buffer" })
map("n", "<F4>", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "<F5>", picker("grep"), { desc = "Search in project" })
map("n", "<F6>", picker("files"), { desc = "Find files" })
map("n", "<F7>", picker("buffers"), { desc = "Switch buffer" })
map("n", "<F8>", "<cmd>Neotree toggle reveal_force_cwd<cr>", { desc = "Toggle explorer" })
map({ "n", "t" }, "<F9>", "<cmd>ToggleTerm direction=vertical size=72<cr>", { desc = "Toggle terminal" })
map("n", "<F10>", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { desc = "LazyGit" })

map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to lower split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to upper split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })

map("n", "<leader>fp", picker("files", { cwd = LazyVim.root() }), { desc = "Find project files" })
map("n", "<leader>fP", picker("grep", { cwd = LazyVim.root() }), { desc = "Search project text" })
map("n", "<leader>fw", "<cmd>set wrap!<cr>", { desc = "Toggle wrap" })
map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

local function close_file_buffers(all)
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.bo[buf].filetype
      local bt = vim.bo[buf].buftype
      if bt == "" and ft ~= "neo-tree" then
        if all or buf == vim.api.nvim_get_current_buf() then
          Snacks.bufdelete({ buf = buf })
        end
      end
    end
  end
end

vim.api.nvim_create_user_command("QuitFile", function() close_file_buffers(false) end, {})
vim.api.nvim_create_user_command("QuitFiles", function() close_file_buffers(true) end, {})
