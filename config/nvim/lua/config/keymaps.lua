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

-- VS Code-like shift+arrow selection
map("n", "<S-Left>", "vh")
map("n", "<S-Right>", "vl")
map("n", "<S-Up>", "vk")
map("n", "<S-Down>", "vj")
map("v", "<S-Left>", "h")
map("v", "<S-Right>", "l")
map("v", "<S-Up>", "k")
map("v", "<S-Down>", "j")
map("i", "<S-Left>", "<Esc>vh")
map("i", "<S-Right>", "<Esc>lvl")
map("i", "<S-Up>", "<Esc>vk")
map("i", "<S-Down>", "<Esc>lvj")

-- Shift+Cmd (kitty sends Shift+Home/End) — select to line boundary
map("n", "<S-Home>", "v0")
map("n", "<S-End>", "v$")
map("v", "<S-Home>", "0")
map("v", "<S-End>", "$")
map("i", "<S-Home>", "<Esc>v0")
map("i", "<S-End>", "<Esc>lv$")

-- Shift+Alt — select word
map("n", "<M-S-Left>", "vb")
map("n", "<M-S-Right>", "ve")
map("v", "<M-S-Left>", "b")
map("v", "<M-S-Right>", "e")
map("i", "<M-S-Left>", "<Esc>vb")
map("i", "<M-S-Right>", "<Esc>lve")

-- Shift+Ctrl — select word
map("n", "<C-S-Left>", "vb")
map("n", "<C-S-Right>", "ve")
map("v", "<C-S-Left>", "b")
map("v", "<C-S-Right>", "e")
map("i", "<C-S-Left>", "<Esc>vb")
map("i", "<C-S-Right>", "<Esc>lve")

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
