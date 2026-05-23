if vim.g.loaded_markdown_links == 1 then
  return
end
vim.g.loaded_markdown_links = 1

local M = require('markdown-links')

vim.api.nvim_create_user_command('FollowLink',function()
    M.FollowLink()
  end,
  {desc = "Attempts to follow the link the cursor is on"}
)
vim.api.nvim_create_user_command('BackLink',function()
    M.BackLink()
  end,
  {desc = "Attempts to return to the previous link"}
)

vim.keymap.set("n", "<CR>", ":FollowLink<CR>", {silent=true})
vim.keymap.set("n", "<BS>", ":BackLink<CR>", {silent=true})

