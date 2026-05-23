local T = MiniTest.new_set()
local links = require("markdown-links")


T['no match'] = function()
  local result = links._get_link("There is no link here", 1)
  MiniTest.expect.equality(result, nil)
end

T['one match, cursor before match'] = function()
  local result = links._get_link("There is [[one.md]] link here", 1)
  MiniTest.expect.equality(result, nil)
end

T['one match, cursor after match'] = function()
  local result = links._get_link("There is [[one.md]] link here", 20)
  MiniTest.expect.equality(result, nil)
end

T['one match, cursor on first brace'] = function()
  local result = links._get_link("There is [[one.md]] link here", 10)
  MiniTest.expect.equality(result, "one.md")
end

T['one match, cursor on last brace'] = function()
  local result = links._get_link("There is [[one.md]] link here", 19)
  MiniTest.expect.equality(result, "one.md")
end

T['one match, cursor in middle'] = function()
  local result = links._get_link("There is [[one.md]] link here", 14)
  MiniTest.expect.equality(result, "one.md")
end

T['two matches, cursor on first brace'] = function()
  local result = links._get_link("There is [[one.md]] link here and [[two.md]] here", 35)
  MiniTest.expect.equality(result, "two.md")
end

T['two matches, cursor on last brace'] = function()
  local result = links._get_link("There is [[one.md]] link here and [[two.md]] here", 44)
  MiniTest.expect.equality(result, "two.md")
end

T['two matches, cursor in middle'] = function()
  local result = links._get_link("There is [[one.md]] link here and [[two.md]] here", 38)
  MiniTest.expect.equality(result, "two.md")
end

return T
