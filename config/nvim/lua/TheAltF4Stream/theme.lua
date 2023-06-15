local catppuccin = require 'catppuccin'
local colorizer = require 'colorizer'
local gitsigns = require 'gitsigns'
local lualine = require 'lualine'

local function init()
    catppuccin.setup({
        flavour = "macchiato",
        integrations = {
            cmp = true,
            gitsigns = true,
            --indent_blankline = { enabled = true },
            native_lsp = {
                enabled = true,
            },
            telescope = true,
            treesitter = true,
        },
        term_colors = true,
        transparent_background = true,
    })

    colorizer.setup {}

    gitsigns.setup {}

    lualine.setup {
        options = {
            icons_enabled = false,
            extensions = { "fzf", "quickfix" },
            theme = "catppuccin"
        }
    }

    vim.cmd.colorscheme "catppuccin"
end

return {
    init = init,
}
