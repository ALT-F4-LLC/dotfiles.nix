local function setup_extras()
  require('gitsigns').setup()

  require('lualine').setup {
    options = {
      extensions = { 'fzf', 'quickfix' },
      theme = 'tokyonight'
    }
  }

  require"trouble".setup()

  vim.api.nvim_set_keymap("n", "<leader>hh", "<cmd>Trouble<cr>",
    {
      silent = true,
      noremap = true
    }
  )

  require("lsp-colors").setup()

  vim.g.hardtime_default_on = 1
  vim.g.hardtime_showmsg = 1
end

setup_extras()