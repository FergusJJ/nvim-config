local dap = require("dap")

dap.set_log_level('DEBUG')

vim.keymap.set('n', '<leader>db', '<Cmd>lua require("dap").toggle_breakpoint()<CR>', { silent = true, noremap = true })

vim.keymap.set('n', '<leader>dr', '<Cmd>lua require("dap").continue()<CR>', { silent = true, noremap = true })
