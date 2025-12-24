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

    -- 3. Initialize the plugin
    metals_config.init_options.statusBarProvider = "on"

    -- 4. ATTACH: What happens when Scala attaches
    metals_config.on_attach = function(client, bufnr)
      require("metals").setup_dap()

      -- Keymaps specifically for Scala files
      local map = vim.keymap.set

      -- LSP Navigation
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to definition" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover documentation" })
      vim.keymap.set("n", "vrr", vim.lsp.buf.references, { buffer = bufnr, desc = "Go to references" })
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = bufnr, desc = "Go to implementation" })

      -- Metals Specifics
      map("n", "<leader>mws", function() require("metals").hover_worksheet() end,
        { buffer = bufnr, desc = "Hover Worksheet" })
      map("n", "<leader>mi", function() require("metals").toggle_setting("showImplicitArguments") end,
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
