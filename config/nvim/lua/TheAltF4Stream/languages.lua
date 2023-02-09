local cmp = require 'cmp'
local cmp_compare = require 'cmp.config.compare'
local cmp_compare_tabnine = require('cmp_tabnine.compare')
local lsp = require 'lsp-zero'
local lspkind = require 'lspkind'
local tabnine = require 'cmp_tabnine.config'

local function autocmd(args)
    local event = args[1]
    local group = args[2]
    local callback = args[3]

    vim.api.nvim_create_autocmd(event, {
        group = group,
        buffer = args[4],
        callback = function()
            callback()
        end,
        once = args.once,
    })
end

local function init()
    local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
    local autocmd_clear = vim.api.nvim_clear_autocmds

    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
    })
    local cmp_sources = {
        { name = 'cmp_tabnine' },
        { name = 'nvim_lsp' },
        { name = 'treesitter' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'nvim_lua' }
    }
    local cmp_sources_mapping = {
        cmp_tabnine = "[TN]",
        nvim_lsp = "[LSP]",
        treesitter = "[TS]",
        luasnip = "[Snippet]",
        path = "[Path]",
        buffer = "[Buffer]",
        nvim_lua = "[Lua]",
    }

    lsp.preset('recommended')

    lsp.nvim_workspace()

    lsp.setup_servers({
        'bashls',
        'cssls',
        'dockerls',
        'gopls',
        'graphql',
        'hls',
        'html',
        'jsonls',
        'jsonnet_ls',
        'nil_ls',
        'prismals',
        'pyright',
        'rust_analyzer',
        'terraformls',
        'tsserver',
        'yamlls'
    })

    lsp.configure('sumneko_lua', {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    })

    lsp.setup_nvim_cmp({
        formatting = {
            format = function(entry, vim_item)
                vim_item.kind = lspkind.symbolic(vim_item.kind, { mode = "symbol" })
                vim_item.menu = cmp_sources_mapping[entry.source.name]

                if entry.source.name == "cmp_tabnine" then
                    local detail = (entry.completion_item.data or {}).detail

                    vim_item.kind = ""

                    if detail and detail:find('.*%%.*') then
                        vim_item.kind = vim_item.kind .. ' ' .. detail
                    end

                    if (entry.completion_item.data or {}).multiline then
                        vim_item.kind = vim_item.kind .. ' ' .. '[ML]'
                    end
                end

                local maxwidth = 80

                vim_item.abbr = string.sub(vim_item.abbr, 1, maxwidth)

                return vim_item
            end,
        },
        mapping = cmp_mappings,
        sorting = {
            priority_weight = 2,
            comparators = {
                cmp_compare_tabnine,
                cmp_compare.offset,
                cmp_compare.exact,
                cmp_compare.score,
                cmp_compare.recently_used,
                cmp_compare.kind,
                cmp_compare.sort_text,
                cmp_compare.length,
                cmp_compare.order,
            },
        },
        sources = cmp_sources,
    })

    lsp.set_preferences({
        sign_icons = {
            error = 'E',
            warn = 'W',
            hint = 'H',
            info = 'I'
        },
        suggest_lsp_servers = false,
    })

    lsp.on_attach(function(client, bufnr)
        local bufopts = { buffer = bufnr, remap = false }

        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)

        if client.server_capabilities.documentHighlightProvider then
            autocmd_clear { group = augroup_highlight, buffer = bufnr }
            autocmd { "CursorHold", augroup_highlight, vim.lsp.buf.document_highlight, bufnr }
            autocmd { "CursorMoved", augroup_highlight, vim.lsp.buf.clear_references, bufnr }
        end
    end)

    lsp.setup()

    tabnine:setup({
        max_lines = 1000;
        max_num_results = 20;
        sort = true;
        run_on_every_keystroke = true;
        snippet_placeholder = '..';
    })

    vim.diagnostic.config({
        virtual_text = true
    })
end

return {
    init = init,
}
