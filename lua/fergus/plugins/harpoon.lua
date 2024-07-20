return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function ()
        local harpoon = require("harpoon")
        harpoon:setup()
        local conf = require("telescope.config").values
        local function toggle_telescope(harpoon_files)
            local file_paths = {}
            for _, item in ipairs(harpoon_files.items) do
                table.insert(file_paths, item.value)
            end
            require("telescope.pickers").new({}, {
                prompt_title = "Harpoon",
                finder = require("telescope.finders").new_table({
                    results = file_paths,
                }),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
            })
        end
        vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
        vim.keymap.set("n", "<C-q>", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<C-a>", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<C-z>", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<C-\\>", function() harpoon:list():select(4) end)

    end
}
--[[
local harpoon = require("harpoon")

-- pretty much the same way as is setup in README

harpoon:setup()

local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end


]]
