local function on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local opts = { noremap = true, silent = true }

    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

    if client.server_capabilities.documentFormattingProvider then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", opts)
    end

    if client.server_capabilities.documentRangeFormattingProvider then
        buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
        })
    end
end

local function make_config()
    local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }

    return {
        capabilities = capabilities,
        on_attach = on_attach
    }
end

local function setup_languages()
    local lspconfig_servers = {
        "bashls",
        "cssls",
        "dockerls",
        "gopls",
        "graphql",
        "hls",
        "html",
        "jsonls",
        "nil_ls",
        "prismals",
        "pyright",
        "rust_analyzer",
        "sumneko_lua",
        "terraformls",
        "tsserver",
        "yamlls"
    }

    for _, server in pairs(lspconfig_servers) do
        local config = make_config()

        if server == "sumneko_lua" then
            config.settings = {
                Lua = {
                    diagnostics = { globals = { 'vim' } },
                    runtime = { version = 'LuaJIT' },
                    telemetry = { enable = false },
                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                }
            }
        end

        require 'lspconfig'[server].setup(config)
    end
end

local function init()
    setup_languages()
end

return {
    init = init,
}
