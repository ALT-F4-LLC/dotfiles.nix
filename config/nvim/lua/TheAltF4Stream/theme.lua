local catppuccin = require 'catppuccin'

local function init()
    catppuccin.setup({
        flavour = "macchiato",
        integrations = {
            cmp = true,
            gitsigns = true,
            --indent_blankline = { enabled = true },
            native_lsp = {
                enabled = true;
            },
            telescope = true,
            treesitter = true,
        },
        term_colors = true,
        transparent_background = true,
    })

    vim.cmd.colorscheme "catppuccin"
end

return {
    init = init,
}
