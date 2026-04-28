local shebang_map = {
  bash = "bash",
  sh = "sh",
  zsh = "zsh",
  dash = "sh",
  ksh = "ksh",
  csh = "csh",
  tcsh = "tcsh",
  fish = "fish",
  python = "python",
  ruby = "ruby",
  perl = "perl",
  node = "javascript",
  lua = "lua",
}

vim.filetype.add({
  pattern = {
    [".*"] = {
      priority = -math.huge,
      function(_, bufnr)
        local first = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""
        if not first:match("^#!") then
          return
        end
        local interpreter = first:match("^#!%s*%S+/env%s+(%S+)") or first:match("^#!%s*/[^%s]*/([^/%s]+)")
        if not interpreter then
          return
        end
        local base = interpreter:match("^(%a+)")
        return shebang_map[base]
      end,
    },
  },
})
