return {
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      local function restore_netrw_bindings(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true,
          }
        end

        api.config.mappings.default_on_attach(bufnr)

        -- Custom bindings
        vim.keymap.set("n", "%", api.fs.create, opts("Create File/Dir"))
        vim.keymap.set("n", "R", api.fs.rename, opts("Rename File"))
      end

      require("nvim-tree").setup({
        on_attach = restore_netrw_bindings,
        view = {
          width = 60,
        },
        renderer = {
          group_empty = true,
        },
        -- Optional: explicit sync behavior can sometimes help with buffer errors
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
      })
    end,
    keys = {
      { "<leader>pv", "<cmd>NvimTreeToggle<cr>",   desc = "Toggle NvimTree" },
      { "<leader>pV", "<cmd>NvimTreeFindFile<cr>", desc = "Toggle NvimTree" },
    },
  }
}
