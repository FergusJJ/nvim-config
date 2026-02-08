return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-jest",
  },

  config = function()
    local neotest = require("neotest")
    neotest.setup({
      adapters = {
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "jest.config.ts",
          env = { CI = true },
          cwd = function(path)
            -- Find the nearest directory with package.json or jest.config.ts
            -- This ensures we run from the app/package root in a monorepo
            local lspconfig_util = require("lspconfig.util")
            local root = lspconfig_util.root_pattern("jest.config.ts", "jest.config.js", "package.json")(path)
            return root or vim.fn.getcwd()
          end,
          -- Custom test file detection to match your project's naming: *Test.ts
          ---@async
          ---@param file_path string?
          ---@return boolean
          isTestFile = function(file_path)
            if not file_path then
              return false
            end
            -- Match files ending in Test.ts, Test.tsx, test.ts, test.tsx, spec.ts, spec.tsx
            return file_path:match("Test%.tsx?$") ~= nil
                or file_path:match("%.test%.tsx?$") ~= nil
                or file_path:match("%.spec%.tsx?$") ~= nil
          end,
        }),
      }
    })

    -- Run nearest test
    vim.keymap.set("n", "<leader>tc", function()
      neotest.run.run()
    end, { desc = "Run nearest test" })

    -- Run tests in current file
    vim.keymap.set("n", "<leader>trf", function()
      neotest.run.run(vim.fn.expand("%"))
    end, { desc = "Run file tests" })

    -- Debug nearest test (with breakpoints!)
    vim.keymap.set("n", "<leader>td", function()
      neotest.run.run({ strategy = "dap", suite = false })
    end, { desc = "Debug nearest test" })

    -- Stop test
    vim.keymap.set("n", "<leader>ts", function()
      neotest.run.stop()
    end, { desc = "Stop test" })

    -- Toggle test summary
    vim.keymap.set("n", "<leader>to", function()
      neotest.summary.toggle()
    end, { desc = "Toggle test summary" })

    -- Show test output
    vim.keymap.set("n", "<leader>tO", function()
      neotest.output.open({ enter = true })
    end, { desc = "Show test output" })
  end

}
