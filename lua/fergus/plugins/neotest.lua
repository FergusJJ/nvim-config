return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
  },

  config = function()
    local neotest = require("neotest")
    neotest.setup({
      --want support for java but cba to figure out
      --
    })

    --run nearest test
    vim.keymap.set("n", "<leader>tc", function()
      neotest.run.run()
    end)

    --run tests in current file
    vim.keymap.set("n", "<leader>trf", function()
      neotest.run.run(vim.fn.expand("%"))
    end)

    --stop test
    vim.keymap.set("n", "<leader>ts", function()
      neotest.run.stop()
    end)
  end

}
