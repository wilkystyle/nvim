local function create_wrapper_mappings(lhs, left, right)
  right = right or left
  vim.keymap.set('n', lhs, ('ciW%s<c-r>"%s<esc>'):format(left, right))
  vim.keymap.set('v', lhs, ('c%s<c-r>"%s<esc>'):format(left, right))
end

-- Keymaps for wrapping word or selection with characters
create_wrapper_mappings('<leader>mb', '**')
create_wrapper_mappings('<leader>mi', '*')
create_wrapper_mappings('<leader>m`', '`')

-- Turn word/selection into a link
vim.keymap.set('n', '<leader>mk', [[ciW[<c-r>"]()<left>]])
vim.keymap.set('v', '<leader>mk', [[c[<c-r>"]()<left>]])

-- Helper function to align markdown tables
local function align_table_lines(lines)
  local parsed = {}
  for _, line in ipairs(lines) do
    local inner = line:match('^%s*|(.+)|%s*$')
    if inner then
      local cells = {}
      for cell in (inner .. '|'):gmatch('([^|]*)|') do
        table.insert(cells, vim.trim(cell))
      end
      table.insert(parsed, cells)
    else
      table.insert(parsed, false)
    end
  end

  local widths = {}
  for _, cells in ipairs(parsed) do
    if cells then
      for i, cell in ipairs(cells) do
        local w = vim.fn.strdisplaywidth(cell)
        if not cell:match('^:?-+:?$') then
          widths[i] = math.max(widths[i] or 0, w)
        end
      end
    end
  end

  local result = {}
  for idx, line in ipairs(lines) do
    local cells = parsed[idx]
    if not cells then
      table.insert(result, line)
    else
      local parts = {}
      local is_separator = false
      for j, cell in ipairs(cells) do
        local w = widths[j] or vim.fn.strdisplaywidth(cell)
        local padded
        if cell:match('^:?-+:?$') then
          is_separator = true
          local lc = cell:sub(1, 1) == ':'
          local rc = cell:sub(-1) == ':'
          if lc and rc then
            padded = ':' .. string.rep('-', w) .. ':'
          elseif lc then
            padded = ':' .. string.rep('-', w + 1)
          elseif rc then
            padded = string.rep('-', w + 1) .. ':'
          else
            padded = string.rep('-', w + 2)
          end
        else
          padded = cell .. string.rep(' ', w - vim.fn.strdisplaywidth(cell))
        end
        table.insert(parts, padded)
      end
      if is_separator then
        table.insert(result, '|' .. table.concat(parts, '|') .. '|')
      else
        table.insert(result, '| ' .. table.concat(parts, ' | ') .. ' |')
      end
    end
  end
  return result
end

local function table_range()
  local row = vim.fn.line('.')
  local all_lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local total = #all_lines
  local first, last = row, row
  while first > 1 and all_lines[first - 1]:match('^%s*|') do
    first = first - 1
  end
  while last < total and all_lines[last + 1]:match('^%s*|') do
    last = last + 1
  end
  return first, last
end

local function format_table(start_row, end_row)
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local aligned = align_table_lines(lines)
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, aligned)
end

-- Expose the above functions as a Neovim command
vim.api.nvim_buf_create_user_command(0, 'MDAlignTable', function(opts) format_table(opts.line1, opts.line2) end,
  { range = true })

-- Keymaps to align markdown tables
vim.keymap.set('n', '<leader>ma', function()
  local s, e = table_range()
  format_table(s, e)
end, { buffer = true, desc = 'Align markdown table' })
vim.keymap.set('v', '<leader>ma', ':MDAlignTable<CR>',
  { buffer = true, silent = true, desc = 'Align markdown table (selection)' })
