-- Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

local plugins = {
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    -- or                            , branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },
  {
    "folke/trouble.nvim",
    config = function()
      require("trouble").setup {
        icons = false,
      }
    end
  },
    {
    "nvimtools/none-ls.nvim",
  },
  {
    "williamboman/mason.nvim",
    opts = {
    ensure_installed = {
      "black", -- Python formatter

      -- Go tools and language server
      "gopls", -- Go language server
      "gofumpt", -- Go formatter
      "golines", -- Go formatter that shortens long lines
      "staticcheck", -- Go static analysis tool

      -- Haskell tools and language server
      "haskell-language-server", -- Haskell language server
      "stylish-haskell", -- Haskell code formatter

      -- C tools and language server
      "clangd", -- C/C++/Objective-C language server
      "cpplint", -- C/C++ linter
      "sumneko_lua",
    },
    },
  },
  {
    "neovim/nvim-lspconfig",
  },
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  ("nvim-treesitter/playground"),
  ("theprimeagen/harpoon"),
  ("theprimeagen/refactoring.nvim"),
  ("mbbill/undotree"),
  ("tpope/vim-fugitive"),
  ("nvim-treesitter/nvim-treesitter-context"),
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },
  {
    "windwp/nvim-autopairs",
    config = function() require("nvim-autopairs").setup {} end
  },
  ({
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  }),
}

local opts = {}

require("lazy").setup(plugins, opts)
