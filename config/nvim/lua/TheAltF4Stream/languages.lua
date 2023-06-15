local cmp = require 'cmp'
local cmp_compare = require 'cmp.config.compare'
local copilot = require 'copilot'
local copilot_cmp = require 'copilot_cmp'
local copilot_cmp_comparators = require 'copilot_cmp.comparators'
local copilot_cmp_format = require 'copilot_cmp.format'
local lsp = require 'lsp-zero'
local lspkind = require 'lspkind'
local rust_tools = require 'rust-tools'

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

local has_words_before = function()
    if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
end

local function on_attach(client, bufnr)
    local augroup_highlight = vim.api.nvim_create_augroup("custom-lsp-references", { clear = true })
    local autocmd_clear = vim.api.nvim_clear_autocmds

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
end

local function init()
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_mappings = lsp.defaults.cmp_mappings({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<C-y>'] = cmp.mapping.confirm({ select = true }),
        ['<C-Space>'] = cmp.mapping.complete(),
        ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
                fallback()
            end
        end),
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
    })
    local cmp_sources = {
        { name = "copilot" },
        { name = 'nvim_lsp' },
        { name = 'treesitter' },
        { name = 'luasnip' },
        { name = 'path' },
        { name = 'buffer' },
        { name = 'nvim_lua' }
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
        'terraformls',
        'tsserver',
        'yamlls'
    })

    lsp.configure('diagnosticls', {
        filetypes = { "python" },
        init_options = {
            filetypes = {
                python = "black"
            },
            formatFiletypes = {
                python = { "black" }
            },
            formatters = {
                black = {
                    command = "black",
                    args = { "--quiet", "-" },
                    rootPatterns = { "pyproject.toml" },
                },
            },
        }
    })

    lsp.configure('lua_ls', {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                },
                runtime = {
                    version = 'LuaJIT',
                },
                telemetry = {
                    enable = false,
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
            }
        }
    })

    lsp.configure('pyright', {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true
                },
            },
        },
    })

    lsp.setup_nvim_cmp({
        formatting = {
            format = lspkind.cmp_format({
                ellipsis_char = '...',
                mode = 'text',
                maxwidth = 50,
                symbol_map = { Copilot = "" }
            }),
        },
        mapping = cmp_mappings,
        sorting = {
            priority_weight = 2,
            comparators = {
                copilot_cmp_comparators.prioritize,
                cmp_compare.offset,
                cmp_compare.exact,
                cmp_compare.score,
                cmp_compare.recently_used,
                cmp_compare.locality,
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

    lsp.on_attach(on_attach)

    lsp.setup()

    rust_tools.setup({
        server = {
            on_attach = on_attach,
        },
    })

    copilot.setup({
        filetypes = {
            ["*"] = true
        },
        panel = { enabled = false },
        suggestion = { enabled = false },
    })

    copilot_cmp.setup({
        formatters = {
            insert_text = copilot_cmp_format.remove_existing,
            label = copilot_cmp_format.format_label_text,
            preview = copilot_cmp_format.deindent,
        },
    })

    vim.diagnostic.config({
        virtual_text = true
    })
end

return {
    init = init,
}
