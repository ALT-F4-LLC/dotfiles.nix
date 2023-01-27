local function set_vim_g()
    vim.g.mapleader = " "
end

local function set_vim_o()
    local settings = {
        clipboard = 'unnamedplus',
        colorcolumn = 80,
        expandtab = true,
        scrolloff = 3,
        shiftwidth = 4,
        shortmess = vim.o.shortmess .. 'c',
        splitright = true,
        tabstop = 4,
        termguicolors = true,
        updatetime = 300,
    }

    for k, v in pairs(settings) do
        vim.o[k] = v
    end

    -- Not supported
    vim.cmd("set colorcolumn=80")
end

local function set_vim_wo()
    local settings = {
        number = true,
        relativenumber = true,
        wrap = false,
    }

    for k, v in pairs(settings) do
        vim.wo[k] = v
    end
end

local function set_vim_opt()
    vim.opt.list = true
    vim.opt.listchars:append "eol:↴"
end

local function set_vim_keymaps()
    local map = vim.api.nvim_set_keymap
    local options = { noremap = false }

    map('n', '<leader>h', '<CMD>wincmd h<CR>', options)
    map('n', '<leader>j', '<CMD>wincmd j<CR>', options)
    map('n', '<leader>k', '<CMD>wincmd k<CR>', options)
    map('n', '<leader>l', '<CMD>wincmd l<CR>', options)
end

local function init()
    set_vim_g()
    set_vim_o()
    set_vim_wo()
    set_vim_opt()
    set_vim_keymaps()
end

return {
    init = init,
}
