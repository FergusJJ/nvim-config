return {
  "scalameta/nvim-metals",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "mfussenegger/nvim-dap",
  },
  ft = { "scala", "sbt", "java" },
  config = function()
    local metals_config = require("metals").bare_config()
    metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- 2. Configuration settings
    metals_config.settings = {
      showImplicitArguments = true,
      excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      testUserInterface = "Test Explorer",
    }

    metals_config.init_options.statusBarProvider = "on"
    metals_config.on_attach = function(client, bufnr)
      require("metals").setup_dap()

      -- Metals Specifics
      vim.keymap.set("n", "<leader>mws", function() require("metals").hover_worksheet() end,
        { buffer = bufnr, desc = "Hover Worksheet" })
      vim.keymap.set("n", "<leader>mi", function() require("metals").toggle_setting("showImplicitArguments") end,
        { buffer = bufnr, desc = "Toggle Implicits" })
    end

    -- 5. Autocmd to trigger Metals
    local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "scala", "sbt", "java" },
      callback = function()
        require("metals").initialize_or_attach(metals_config)
      end,
      group = nvim_metals_group,
    })
  end,
}
