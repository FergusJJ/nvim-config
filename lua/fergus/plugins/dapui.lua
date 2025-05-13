-- ~/.config/nvim/lua/fergus/plugins/dapui.lua
return {
  "rcarriga/nvim-dap-ui",
  -- Specify nvim-dap as a dependency, ensures it loads first
  -- nvim-nio is also recommended by dap-ui for performance
  dependencies = {
    "mfussenegger/nvim-dap",
    "nvim-neotest/nvim-nio"
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    dapui.setup({})

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({}) -- Pass empty table, or specific overrides { layout = "my_layout" }
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end

    vim.keymap.set("n", "<leader>du", function() dapui.toggle({}) end, { desc = "DAP UI: Toggle" })
    vim.keymap.set("n", "<leader>do", function() dapui.open({}) end, { desc = "DAP UI: Open" })
    vim.keymap.set("n", "<leader>dc", function() dapui.close({}) end, { desc = "DAP UI: Close" })
    vim.keymap.set({ "n", "v" }, "<leader>de", function() dapui.eval() end, { desc = "DAP UI: Evaluate" })
  end,
}
