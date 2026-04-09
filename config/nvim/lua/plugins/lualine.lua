local function runtime_path()
  local buf_ft = vim.bo.filetype
  local root = vim.fn.getcwd()
  if buf_ft == "python" then
    local venv = os.getenv("VIRTUAL_ENV")
    if not venv then
      local candidate = root .. "/.venv/bin/python"
      if vim.fn.filereadable(candidate) == 1 then
        venv = root .. "/.venv"
      end
    end
    if venv then
      return "Python - ./" .. venv:gsub("^" .. vim.pesc(root) .. "/", "")
    end
  elseif vim.tbl_contains({ "javascript", "typescript", "javascriptreact", "typescriptreact" }, buf_ft) then
    if vim.fn.isdirectory(root .. "/node_modules") == 1 then
      return buf_ft:gsub("^%l", string.upper) .. " - ./node_modules"
    end
  end
  return ""
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = {
      options = {
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = {},
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics" },
          { "filename", path = 1, symbols = { modified = " [+]", readonly = " [-]" } },
        },
        lualine_x = { runtime_path },
        lualine_y = { "location" },
        lualine_z = {},
      },
    },
  },
}
