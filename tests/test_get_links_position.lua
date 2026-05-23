local T = MiniTest.new_set()
local links = require("markdown-links")


T['no match'] = function()
  local result = links._get_links_position("There is no link here")
  MiniTest.expect.equality(result, {})
end

T['one match'] = function()
  local result = links._get_links_position("There is [[one.md]] link here")
  MiniTest.expect.equality(result, {{first=10,last=19}})
end

T['two matches'] = function()
  local result = links._get_links_position("There is [[one.md]] link here and [[two.md]] here")
  MiniTest.expect.equality(result, {{first=10,last=19}, {first=35, last=44}})
end

T['three matches'] = function()
  local result = links._get_links_position("There is [[one.md]] link here and [[two.md]] here and [[three.md]] here")
  MiniTest.expect.equality(result, {{first=10,last=19}, {first=35, last=44}, {first=55, last=66}})
end

T['four matches'] = function()
  local result = links._get_links_position("There is [[one.md]] link here and [[two.md]] here and [[three.md]] here and another one that is really long [[four.md]] see?")
  MiniTest.expect.equality(result, {{first=10,last=19}, {first=35, last=44}, {first=55, last=66},{first=109,last=119}})
end

return T
