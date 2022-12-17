local function setup_treesitter()
    local parser_install_dir = vim.fn.stdpath('data') .. "/site";

    require 'nvim-treesitter.configs'.setup {
        ensure_installed = {
            'bash',
            'css',
            'dockerfile',
            'go',
            'gomod',
            'graphql',
            'html',
            'javascript',
            'jsdoc',
            'json',
            'lua',
            'make',
            'nix',
            'python',
            'rust',
            'svelte',
            'tsx',
            'typescript',
            'yaml',
        },
        highlight = {
            enable = true
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "gnn",
                node_incremental = "grn",
                scope_incremental = "grc",
                node_decremental = "grm",
            },
        },
        indent = {
            enable = true
        },
        parser_install_dir = parser_install_dir,
    }

    vim.opt.runtimepath:append(parser_install_dir)
end

local function init()
    setup_treesitter()
end

return {
    init = init,
}
