local function setup_extras()
  require("gitsigns").setup()

  require("lsp-colors").setup()

  require("lsp_lines").setup()

  require("lualine").setup({
    options = {
      extensions = { "fzf", "quickfix" },
      theme = "catppuccin"
    }
  })

  vim.diagnostic.config({
    virtual_text = false,
  })
end

local function init()
  setup_extras()
end

return {
  init = init,
}
