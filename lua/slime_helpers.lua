local M = {}

function M.send_markdown_fence()
  if vim.bo.filetype ~= "markdown" then
    return vim.notify("Sending a code fence requires Markdown", vim.log.levels.ERROR)
  end

  local ok, parser = pcall(vim.treesitter.get_parser, 0, "markdown")
  if not ok or not parser then
    return vim.notify("Markdown fence extraction requires the Markdown parser", vim.log.levels.ERROR)
  end
  parser:parse()

  local node = vim.treesitter.get_node({ lang = "markdown", ignore_injections = true })
  while node and node:type() ~= "fenced_code_block" do
    node = node:parent()
  end
  if not node then
    return vim.notify("Not inside a Markdown code fence", vim.log.levels.ERROR)
  end

  local text = ""
  for child in node:iter_children() do
    if child:type() == "code_fence_content" then
      text = vim.treesitter.get_node_text(child, 0):gsub("%s+$", "")
      break
    end
  end
  if text == "" then
    return vim.notify("The Markdown code fence is empty", vim.log.levels.ERROR)
  end

  vim.fn["slime#send"](text .. "\n")
end

function M.send_visual()
  local start_line, end_line = vim.fn.line("v"), vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end

  local file = vim.fn.expand("%:p")
  local header = start_line == end_line
      and string.format("%s:%d", file, start_line)
      or string.format("%s:%d-%d", file, start_line, end_line)
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
  local text = string.format("\n\n%s\n```\n%s\n```", header, table.concat(lines, "\n"))
  vim.fn["slime#send"](text)

  if vim.env.TMUX then
    vim.fn.system("tmux last-pane")
  end

  vim.cmd("normal! \27")
end

function M.send_paragraph()
  vim.cmd("normal! vip")
  M.send_visual()
end

return M
