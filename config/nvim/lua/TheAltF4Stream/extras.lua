local gitsigns = require 'gitsigns'
local lualine = require 'lualine'
local treesitter_context = require 'treesitter-context'

local function init()
    gitsigns.setup()

    lualine.setup({
        options = {
            extensions = { "fzf", "quickfix" },
            theme = "catppuccin"
        }
    })

    treesitter_context.setup()
end

return {
    init = init,
}
