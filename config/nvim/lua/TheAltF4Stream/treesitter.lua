local function init()
    require 'nvim-treesitter.configs'.setup {
        highlight = { enable = true },
        indent = { enable = true },
        rainbow = { enable = true },
    }
end

return {
    init = init,
}
