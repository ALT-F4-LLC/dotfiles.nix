local colorizer = require 'colorizer'
local gitsigns = require 'gitsigns'
local lualine = require 'lualine'

local function init()
    colorizer.setup {}

    gitsigns.setup {}

    lualine.setup {
        options = {
            component_separators = { left = '', right = '' },
            extensions = { "fzf", "quickfix" },
            icons_enabled = false,
            section_separators = { left = '', right = '' },
        },
    }

    vim.opt.background = "dark"
    vim.cmd.colorscheme "oxocarbon"

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    init = init,
}
