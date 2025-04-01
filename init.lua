require("fergus")

local colorscheme_to_load = "rose-pine-moon"
local status_ok, _ = pcall(vim.cmd.colorscheme, colorscheme_to_load)
if not status_ok then
  vim.notify("Colorscheme '" .. colorscheme_to_load .. "' not found! Falling back to default.", vim.log.levels.WARN)
  vim.cmd.colorscheme("rose-pine-moon")
  return
end

