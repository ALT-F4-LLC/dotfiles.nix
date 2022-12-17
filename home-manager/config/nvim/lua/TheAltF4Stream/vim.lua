local function set_vim_g()
    vim.g.mapleader = " "
end

local function set_vim_o()
    local settings = {
        expandtab = true,
        scrolloff = 3,
        shiftwidth = 4,
        tabstop = 4,
        termguicolors = true
    }

    -- Generic vim.o
    for k, v in pairs(settings) do
        vim.o[k] = v
    end

    -- Custom vim.o
    vim.o.clipboard = 'unnamedplus'
    vim.o.shortmess = vim.o.shortmess .. 'c'

    -- Not yet in vim.o
    vim.cmd('set splitright')
end

local function set_vim_wo()
    vim.wo.number = true
    vim.wo.relativenumber = true
    vim.wo.wrap = false
end

local function set_keymaps()
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
    set_keymaps()
end

return {
    init = init,
}
