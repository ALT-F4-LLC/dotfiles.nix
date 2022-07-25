local function setup_extras()
  require("gitsigns").setup()

  require("lsp-colors").setup()

  require("lsp_lines").register_lsp_virtual_lines()

  require("lualine").setup({
    options = {
      extensions = { "fzf", "quickfix" },
      theme = "tokyonight"
    }
  })

  vim.diagnostic.config({
    virtual_text = false,
  })
end

setup_extras()
