return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.5",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')
    local actions = require('telescope.actions')

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            -- SCROLLING IN PREVIEW
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
          },
          n = {
            ["<C-k>"] = actions.preview_scrolling_up,
            ["<C-j>"] = actions.preview_scrolling_down,
          }
        }
      }
    })

    -- We wrap the builtin call in a function so it doesn't run on startup
    vim.keymap.set('n', '<leader>pf', function()
      builtin.find_files(require('telescope.themes').get_dropdown({
        previewer = false,
      }))
    end, {})

    vim.keymap.set('n', '<leader>ps', function()
      builtin.live_grep(require('telescope.themes').get_ivy({
      }))
    end, {})

    vim.keymap.set('n', '<C-p>', builtin.git_files, {})
    vim.keymap.set('n', '<leader>pF', builtin.treesitter, {})

    -- Grep word under cursor
    vim.keymap.set('n', '<leader>pws', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)

    -- Grep WORD (including punctuation) under cursor
    vim.keymap.set('n', '<leader>pWs', function()
      local word = vim.fn.expand("<cWORD>")
      builtin.grep_string({ search = word })
    end)

    vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
  end
}
