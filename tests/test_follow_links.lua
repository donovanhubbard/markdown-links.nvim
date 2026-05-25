local child = MiniTest.new_child_neovim()

local T = MiniTest.new_set({
  hooks = {
    pre_case = function()
      -- Restart child process with custom 'init.lua' script
      child.restart({ '-u', 'scripts/minimal_init.lua' })
      -- Load tested plugin
      child.lua([[M = require('markdown-links')]])
    end,
    -- Stop once all test cases are finished
    post_once = child.stop,
  },
})

T['FollowLink'] = MiniTest.new_set()

T['FollowLink']['should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {2, 16})
  child.lua([[M.FollowLink()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/one.md")
end

T['FollowLink']['with subdir should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {3, 6})
  child.lua([[M.FollowLink()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/sub/two.md")
end

T['FollowLink']['without a link does nothing'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {1, 1})
  child.lua([[M.FollowLink()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['BackLink'] = MiniTest.new_set()

T['BackLink']['should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {2, 16})
  child.lua([[M.FollowLink()]])
  child.lua([[M.BackLink()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['BackLink']['with subdir should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {3, 6})
  child.lua([[M.FollowLink()]])
  child.lua([[M.BackLink()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['BackLink']['without a anything in the links_stack does nothing'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {3, 6})
  child.lua([[M.BackLink()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['BackLink']['with two links should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {2, 16})
  child.lua([[M.FollowLink()]])
  child.api.nvim_win_set_cursor(0, {5, 12})
  child.lua([[M.FollowLink()]])
  child.lua([[M.BackLink()]])
  child.lua([[M.BackLink()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

return T
