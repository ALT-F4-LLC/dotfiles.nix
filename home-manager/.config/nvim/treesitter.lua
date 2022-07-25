local function setup_treesitter()
  require'nvim-treesitter.configs'.setup{
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
    }
  }
end

setup_treesitter()