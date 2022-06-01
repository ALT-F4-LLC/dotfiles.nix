local function setup_languages()
  local lspconfig_servers = {
    "cssls",
    "elixirls",
    "jsonnet_ls",
    "sqlls",
  }

  local lspcontainer_servers = {
    "bashls",
    "dockerls",
    "graphql",
    "gopls",
    "html",
    "jsonls",
    "prismals",
    "pylsp",
    "rust_analyzer",
    "sumneko_lua",
    "terraformls",
    "tsserver",
    "yamlls"
  }

  local lua_settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { 'vim' },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  }

  local function on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    -- Mappings
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
      vim.api.nvim_exec([[
        augroup lsp_document_highlight
          autocmd! * <buffer>
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]], false)
    end
  end

  -- config that activates keymaps and enables snippet support
  local function make_config()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    return {
      -- enable snippet support
      capabilities = capabilities,
      -- map buffer local keybindings when the language server attaches
      on_attach = on_attach
    }
  end

  local function setup_lspcontainer(config, server)
    local lspcontainers = require'lspcontainers'
    local util = require 'lspconfig/util'

    if server == "bashls" then
      config.before_init = function(params)
        params.processId = vim.NIL
      end

      config.cmd = lspcontainers.command(server)
      config.root_dir = util.root_pattern(".git", vim.fn.getcwd())
    end

    if server == "dockerls" then
      config.before_init = function(params)
        params.processId = vim.NIL
      end

      config.cmd = lspcontainers.command(server)
      config.root_dir = util.root_pattern(".git", vim.fn.getcwd())
    end

    if server == "gopls" then
      config.cmd = lspcontainers.command(server)
    end

    if server == "graphql" then
      config.cmd = lspcontainers.command(server)
    end

    if server == "html" then
      config.cmd = lspcontainers.command(server)
    end

    if server == "jsonls" then
      config.before_init = function(params)
        params.processId = vim.NIL
      end

      config.cmd = lspcontainers.command(server)
      config.root_dir = util.root_pattern(".git", vim.fn.getcwd())
    end

    if server == "prismals" then
      config.before_init = function(params)
        params.processId = vim.NIL
      end

      config.cmd = lspcontainers.command(server)
      config.root_dir = util.root_pattern(".git", vim.fn.getcwd())
    end

    if server == "pylsp" then
      config.cmd = lspcontainers.command(server)
    end

    if server == "rust_analyzer" then
      config.cmd = lspcontainers.command(server)
      config.root_dir = util.root_pattern(".git", vim.fn.getcwd())

      vim.api.nvim_exec([[
        autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"TypeHint", "ChainingHint", "ParameterHint" } }
      ]], false)
    end

    if server == "sumneko_lua" then
      config.cmd = lspcontainers.command(server)
      config.settings = lua_settings
    end

    if server == "terraformls" then
      config.cmd = lspcontainers.command(server)
      config.filetypes = { "hcl", "tf", "terraform", "tfvars" }
    end

    if server == "tsserver" then
      config.before_init = function(params)
        params.processId = vim.NIL
      end

      config.cmd = lspcontainers.command(server)
      config.root_dir = util.root_pattern(".git", vim.fn.getcwd())
    end

    if server == "yamlls" then
      config.before_init = function(params)
        params.processId = vim.NIL
      end

      config.cmd = lspcontainers.command(server)
      config.root_dir = util.root_pattern(".git", vim.fn.getcwd())
    end
  end

  require'lspcontainers'.setup({
    ensure_installed = {
      "bashls",
      "dockerls",
      "gopls",
      "html",
      "pylsp",
      "rust_analyzer",
      "sumneko_lua",
      "terraformls",
      "tsserver",
      "yamlls"
    }
  })

  for _, server in pairs(lspconfig_servers) do
    local config = make_config()

    require'lspconfig'[server].setup(config)
  end

  for _, server in pairs(lspcontainer_servers) do
    local config = make_config()

    setup_lspcontainer(config, server)

    require'lspconfig'[server].setup(config)
  end
end

setup_languages()