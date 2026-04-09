local runtime_map = {
  python = {
    label = "Python",
    detect = function(root)
      local venv = os.getenv("VIRTUAL_ENV")
      if venv then
        return "./" .. venv:gsub("^" .. vim.pesc(root) .. "/", "")
      end
      if vim.fn.filereadable(root .. "/.venv/bin/python") == 1 then
        return "./.venv"
      end
    end,
  },
  javascript = { label = "JavaScript", detect = "node_modules" },
  javascriptreact = { label = "JavaScript", detect = "node_modules" },
  typescript = { label = "TypeScript", detect = "node_modules" },
  typescriptreact = { label = "TypeScript", detect = "node_modules" },
  go = { label = "Go", detect = "go.mod" },
  rust = { label = "Rust", detect = "Cargo.toml" },
  ruby = { label = "Ruby", detect = "Gemfile" },
  java = { label = "Java", detect = "pom.xml" },
  kotlin = { label = "Kotlin", detect = "build.gradle.kts" },
  lua = { label = "Lua", detect = "lua" },
  terraform = { label = "Terraform", detect = ".terraform" },
  hcl = { label = "Terraform", detect = ".terraform" },
  c = { label = "C", detect = "Makefile" },
  cpp = { label = "C++", detect = "CMakeLists.txt" },
  zig = { label = "Zig", detect = "build.zig" },
  elixir = { label = "Elixir", detect = "mix.exs" },
  dart = { label = "Dart", detect = "pubspec.yaml" },
  swift = { label = "Swift", detect = "Package.swift" },
  php = { label = "PHP", detect = "composer.json" },
  cs = { label = "C#", detect = { "*.csproj", "*.sln" } },
}

local function runtime_path()
  local ft = vim.bo.filetype
  local entry = runtime_map[ft]
  if not entry then
    return ""
  end
  local root = vim.fn.getcwd()
  local detect = entry.detect
  if type(detect) == "function" then
    local result = detect(root)
    if result then
      return entry.label .. ":" .. result
    end
  elseif type(detect) == "string" then
    if vim.fn.isdirectory(root .. "/" .. detect) == 1 or vim.fn.filereadable(root .. "/" .. detect) == 1 then
      return entry.label .. " - ./" .. detect
    end
  elseif type(detect) == "table" then
    for _, pattern in ipairs(detect) do
      local matches = vim.fn.glob(root .. "/" .. pattern, false, true)
      if #matches > 0 then
        local rel = matches[1]:gsub("^" .. vim.pesc(root) .. "/", "")
        return entry.label .. " - ./" .. rel
      end
    end
  end
  return entry.label
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
