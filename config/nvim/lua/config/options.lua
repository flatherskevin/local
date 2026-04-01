local opt = vim.opt

opt.clipboard = "unnamedplus"
opt.completeopt = "menu,menuone,noselect"
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.ignorecase = true
opt.inccommand = "split"
opt.laststatus = 3
opt.list = true
opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
}
opt.mouse = "a"
opt.number = true
opt.pumblend = 0
opt.relativenumber = false
opt.scrolloff = 6
opt.shiftwidth = 2
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.tabstop = 2
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 200
opt.wrap = false

