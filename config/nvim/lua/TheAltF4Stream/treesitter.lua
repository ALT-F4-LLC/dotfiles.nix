local function init()
    require 'nvim-treesitter.configs'.setup {
        highlight = {
            enable = true,
        },
    }
end

return {
    init = init,
}
