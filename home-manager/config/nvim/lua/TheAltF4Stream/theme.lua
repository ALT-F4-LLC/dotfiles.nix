local function setup_theme()
  -- Theme settings
  vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

  -- Load colorscheme
  require("catppuccin").setup({
    transparent_background = true,
  })

  vim.cmd[[colorscheme catppuccin]]
end

local function init()
  setup_theme()
end

return {
  init = init,
}
