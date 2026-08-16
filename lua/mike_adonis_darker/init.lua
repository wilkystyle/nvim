local M = {}

function M.load()
  vim.o.termguicolors = true
  vim.o.background = "dark"

  vim.cmd.highlight("clear")
  if vim.fn.exists("syntax_on") == 1 then
    vim.cmd.syntax("reset")
  end

  vim.g.colors_name = "mike-adonis-darker"

  local palette = require("mike_adonis_darker.palette")
  local highlights = require("mike_adonis_darker.highlights")(palette)

  for group, spec in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  local terminal = {
    palette.bg,
    palette.red,
    palette.green,
    palette.yellow,
    palette.blue,
    palette.violet,
    palette.cyan,
    palette.fg_alt,
    palette.base5,
    palette.magenta,
    palette.green,
    palette.yellow,
    palette.dark_blue,
    palette.violet,
    palette.dark_cyan,
    palette.fg,
  }

  for index, color in ipairs(terminal) do
    vim.g["terminal_color_" .. (index - 1)] = color
  end
end

return M
