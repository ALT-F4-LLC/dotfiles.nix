local function setup_theme()
  -- Theme settings
  vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

  -- Load colorscheme
  require("catppuccin").setup({
    integrations = {
      indent_blankline = {
        enabled = true,
        colored_indent_levels = true,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
    },
    transparent_background = true,
  })

  vim.cmd [[colorscheme catppuccin]]
end

local function init()
  setup_theme()
end

return {
  init = init,
}
