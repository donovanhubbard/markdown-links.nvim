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

T['follow_link'] = MiniTest.new_set()

T['follow_link']['should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {2, 16})
  child.lua([[M.follow_link()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/one.md")
end

T['follow_link']['with subdir should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {3, 6})
  child.lua([[M.follow_link()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/sub/two.md")
end

T['follow_link']['without a link does nothing'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {1, 1})
  child.lua([[M.follow_link()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['back_link'] = MiniTest.new_set()

T['back_link']['should not fail with no links in stack'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.lua([[M.back_link()]])
end

T['back_link']['should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {2, 16})
  child.lua([[M.follow_link()]])
  child.lua([[M.back_link()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['back_link']['with subdir should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {3, 6})
  child.lua([[M.follow_link()]])
  child.lua([[M.back_link()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['back_link']['without a anything in the links_stack does nothing'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {3, 6})
  child.lua([[M.back_link()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

T['back_link']['with two links should work'] = function()
  child.cmd("e tests/fixtures/index.md")
  child.api.nvim_win_set_cursor(0, {2, 16})
  child.lua([[M.follow_link()]])
  child.api.nvim_win_set_cursor(0, {5, 12})
  child.lua([[M.follow_link()]])
  child.lua([[M.back_link()]])
  child.lua([[M.back_link()]])
  local current_file = child.fn.expand("%")
  MiniTest.expect.equality(current_file,"tests/fixtures/index.md")
end

return T
