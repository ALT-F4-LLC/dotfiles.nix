local chatgpt = require 'chatgpt'

local function init()
    chatgpt.setup({
        api_key_cmd = "doppler --config 'nixos' --project 'erikreinert' secrets get OPENAI_API_KEY --plain",
        openai_params = {
            model = "gpt-3.5-turbo-0613"
        },
        openai_edit_params = {
            model = "code-davinci-edit-001"
        }
    })

    local map = vim.api.nvim_set_keymap

    local options = { noremap = true }

    map('n', '<leader>ga', '<CMD>ChatGPTActAs<CR>', options)
    map('n', '<leader>gg', '<CMD>ChatGPT<CR>', options)
    map('v', '<leader>ge', '<CMD>ChatGPTEditWithInstructions<CR>', options)
    map('v', '<leader>go', '<CMD>ChatGPTRun optimize_code<CR>', options)
    map('v', '<leader>gs', '<CMD>ChatGPTRun summarize<CR>', options)
    map('v', '<leader>gt', '<CMD>ChatGPTRun add_tests<CR>', options)
end

return {
    init = init
}
