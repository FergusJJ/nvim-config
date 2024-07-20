return {
    {
        "christoomey/vim-tmux-navigator",
        lazy = false,
    },
    {
      "windwp/nvim-autopairs",
      config = function()
        require("nvim-autopairs").setup({})
      end,
    },
}
