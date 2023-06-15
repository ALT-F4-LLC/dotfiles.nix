local colorizer = require 'colorizer'
local gitsigns = require 'gitsigns'
local lualine = require 'lualine'
local treesitter_context = require 'treesitter-context'

local function init()
    colorizer.setup()

    gitsigns.setup()

    lualine.setup({
        options = {
            icons_enabled = false,
            extensions = { "fzf", "quickfix" },
            theme = "catppuccin"
        }
    })

    treesitter_context.setup()
end

return {
    init = init,
}
