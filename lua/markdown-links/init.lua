-- Prints out the contents of the link stack to the screen.
-- Used for debugging only
local function _print_link_stack()
  if vim.w.link_stack == nil then
    print("link_stack is nil")
  else
    print("link_stack length = ",#vim.w.link_stack)
    for index, value in ipairs(vim.w.link_stack) do
      print(index, value)
    end
  end
end

local function _get_links_position(line)
  local results = {}
  local offset = 0
  local remaining_line = line
  local counter=0 while true do
    counter = counter + 1
    if counter > 50 then
      break
    end
    local first, last = string.find(remaining_line, "%[%[.-%]%]")
    if first == nil then
      break
    else
      local new_first = first + offset
      local new_last = last + offset
      table.insert(results,{first=new_first, last=new_last})
      offset = last + offset
      remaining_line = string.sub(remaining_line,last + 1)
    end
  end
  return results
end

local function _get_link(line, cursor_col)
  local positions = _get_links_position(line)
  for _, pos in ipairs(positions) do
    if cursor_col >= pos.first and cursor_col <= pos.last then
      return string.sub(line,pos.first+2,pos.last-2)
    end
  end
  return nil
end

local function _get_link_at_cursor()
  local line = vim.api.nvim_get_current_line()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  if cursor_pos ~= nil then
    local file_name = _get_link(line,cursor_pos[2]+1)
    return file_name
  else
    print("markdown-links.nvim: Failed to get cursor position")
  end
  return nil
end

-- Opens the file referenced at the cursor. Adds it to the link stack
local function _follow_link()
  local file_name = _get_link_at_cursor()
  if file_name ~= nil then
    local cwd = vim.fn.expand('%:h')
    local current_file_path = vim.fn.expand('%')
    local path = cwd .. "/" .. file_name
    local stack = vim.w.link_stack or {}
    table.insert(stack,current_file_path)
    vim.w.link_stack = stack
    vim.cmd.edit(path)
  end
end

-- Opens the file referenced at the cursor in a new horizontal split window
local function _follow_link_split()
  local file_name = _get_link_at_cursor()
  if file_name ~= nil then
    local cwd = vim.fn.expand('%:h')
    local path = cwd .. "/" .. file_name
    vim.cmd.split(path)
  end
end

-- Opens the file referenced at the cursor in a new vertical split window
local function _follow_link_vsplit()
  local file_name = _get_link_at_cursor()
  if file_name ~= nil then
    local cwd = vim.fn.expand('%:h')
    local path = cwd .. "/" .. file_name
    vim.cmd.vsplit(path)
  end
end

-- Pops the top file off the link stack and opens it
local function _back_link()
  local stack = vim.w.link_stack or {}
  local target_file_path = stack[#stack]
  if target_file_path ~= nil then
    table.remove(stack)
    vim.w.link_stack = stack
    vim.cmd.edit(target_file_path)
  end
end

-- Sets up highlighting for markdown links
local ns = vim.api.nvim_create_namespace("markdown-links")
vim.api.nvim_set_hl(0, "MarkdownLink", { fg = "#6176ff" })
vim.api.nvim_set_decoration_provider(ns, {
  on_buf = function(_, bufnr, _)
    vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  end,
  on_range = function(_, _, bufnr, begin_row, _, end_row, _)
    local lines = vim.api.nvim_buf_get_lines(bufnr, begin_row, end_row + 1, false)
    for i, line in ipairs(lines) do
      local row = begin_row + i - 1
      for _, pos in ipairs(_get_links_position(line)) do
        vim.api.nvim_buf_set_extmark(bufnr, ns, row, pos.first - 1, {
          end_col = pos.last,
          hl_group = "MarkdownLink",
        })
      end
    end
  end,
})

local M = {
  _get_links_position = _get_links_position,
  _get_link = _get_link,
  follow_link = function()
    _follow_link()
  end,
  follow_link_split = function()
    _follow_link_split()
  end,
  follow_link_vsplit = function()
    _follow_link_vsplit()
  end,
  back_link = function()
    _back_link()
  end,
  print_link_stack = function()
    _print_link_stack()
  end,
}

return M
