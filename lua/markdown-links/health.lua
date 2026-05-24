local M = {}

M.check = function()
  vim.health.start("Checking commands")
  if vim.fn.exists(":FollowLink") == 2 then
    vim.health.ok("Has :FollowLink command")
  else
    vim.health.error("Missing :FollowLink command")
  end
  if vim.fn.exists(":BackLink") == 2 then
    vim.health.ok("Has :BackLink command")
  else
    vim.health.error("Missing :BackLink command")
  end

  local function hl_exists(name)
    return pcall(vim.api.nvim_get_hl, 0, { name = name })
  end

  vim.health.start("Checking formatting")
  if hl_exists("MarkdownLink") then
    vim.health.ok("Highlight group exists")
  else
    vim.health.error("Highlight group is missing")
  end


end

return M
