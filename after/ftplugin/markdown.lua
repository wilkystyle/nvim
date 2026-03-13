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

-- Align markdown tables
local function align_table_lines(lines)
  local rows = {}
  local widths = {}

  -- Pass 1: parse rows and compute column widths
  for i, line in ipairs(lines) do
    local inner = line:match('^%s*|(.+)|%s*$')

    if not inner then
      rows[i] = false
    else
      local cells = {}

      for cell in (inner .. '|'):gmatch('([^|]*)|') do
        cell = vim.trim(cell)
        cells[#cells + 1] = cell

        if not cell:match('^:?-+:?$') then
          local w = vim.fn.strdisplaywidth(cell)
          widths[#cells] = math.max(widths[#cells] or 0, w)
        end
      end

      rows[i] = cells
    end
  end

  -- Pass 2: render aligned rows
  local out = {}

  for i, cells in ipairs(rows) do
    if not cells then
      out[#out + 1] = lines[i]
    else
      local parts = {}
      local is_separator = false

      for j, cell in ipairs(cells) do
        local w = widths[j] or vim.fn.strdisplaywidth(cell)

        if cell:match('^:?-+:?$') then
          is_separator = true

          local lc = cell:sub(1, 1) == ':'
          local rc = cell:sub(-1) == ':'

          if lc and rc then
            parts[j] = ':' .. string.rep('-', w) .. ':'
          elseif lc then
            parts[j] = ':' .. string.rep('-', w + 1)
          elseif rc then
            parts[j] = string.rep('-', w + 1) .. ':'
          else
            parts[j] = string.rep('-', w + 2)
          end
        else
          parts[j] = cell .. string.rep(' ', w - vim.fn.strdisplaywidth(cell))
        end
      end

      if is_separator then
        out[#out + 1] = '|' .. table.concat(parts, '|') .. '|'
      else
        out[#out + 1] = '| ' .. table.concat(parts, ' | ') .. ' |'
      end
    end
  end

  return out
end

-- Find contiguous markdown table around cursor
local function table_range()
  local row = vim.fn.line('.')
  local first, last = row, row
  local last_line = vim.fn.line('$')

  while first > 1 and vim.fn.getline(first - 1):match('^%s*|') do
    first = first - 1
  end

  while last < last_line and vim.fn.getline(last + 1):match('^%s*|') do
    last = last + 1
  end

  return first, last
end

-- Format a table between two lines
local function format_table(start_row, end_row)
  local buf = 0
  local lines = vim.api.nvim_buf_get_lines(buf, start_row - 1, end_row, false)
  local aligned = align_table_lines(lines)
  vim.api.nvim_buf_set_lines(buf, start_row - 1, end_row, false, aligned)
end

-- Expose the above functions as a Neovim command
vim.api.nvim_buf_create_user_command(
  0,
  'MDAlignTable',
  function(opts)
    format_table(opts.line1, opts.line2)
  end,
  { range = true }
)

-- Keymaps to align markdown tables
vim.keymap.set('n', '<leader>ma', function()
  local s, e = table_range()
  format_table(s, e)
end, { buffer = true, desc = 'Align markdown table' })

vim.keymap.set(
  'v',
  '<leader>ma',
  ':MDAlignTable<CR>',
  { buffer = true, silent = true, desc = 'Align markdown table (selection)' }
)
