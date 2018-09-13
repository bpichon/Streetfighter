require("Player")

local Example = {}
setmetatable(Example, {__index = Player})
local Example_mt = {__index = Example}

function Example.new(player)
   local self = Player.new(player)
   setmetatable(self, Example_mt)
   return self
end

function Example:startRound()
end

function Example:advance(me, enemy)
  -- called every frame
end

function Example:fighter()
	return "Guile"
end

function Example:name()
	return "Conor JcGregor"
end

return Example
