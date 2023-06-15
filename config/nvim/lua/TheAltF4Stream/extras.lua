local colorizer = require 'colorizer'
local gitsigns = require 'gitsigns'
local lualine = require 'lualine'
local treesitter_context = require 'treesitter-context'
local chatgpt = require 'chatgpt'

local function init()
    colorizer.setup()

    chatgpt.setup({
        api_key_cmd = "doppler --config 'nixos' --project 'erikreinert' secrets get OPENAI_API_KEY --plain"
    })

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
