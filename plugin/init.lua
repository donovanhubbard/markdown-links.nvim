if vim.g.loaded_markdown_links == 1 then
  return
end
vim.g.loaded_markdown_links = 1

local M = require('markdown-links')

vim.api.nvim_create_user_command('FollowLink',function()
    M.follow_link()
  end,
  {desc = "Attempts to follow the link the cursor is on"}
)
vim.api.nvim_create_user_command('FollowLinkSplit',function()
    M.follow_link_split()
  end,
  {desc = "Attempts to follow the link the cursor is on in a horiztonal split window"}
)
vim.api.nvim_create_user_command('FollowLinkVSplit',function()
    M.follow_link_vsplit()
  end,
  {desc = "Attempts to follow the link the cursor is on in a vertical split window"}
)
vim.api.nvim_create_user_command('BackLink',function()
    M.back_link()
  end,
  {desc = "Attempts to return to the previous link"}
)
vim.api.nvim_create_user_command('PrintLinkStack',function()
    M.print_link_stack()
  end,
  {desc = "Prints all the links that are in the stack. Used only for debugging."}
)
