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
  --local fktTable = self:getFunctions(true, true)
  --fktTabel[0]()
end

function Example:fighter()
	return "Guile"
end

function Example:name()
	return "Conor JcGregor"
end

-- condition: "close" && "air"
function Example:flyingBusterDrop()
  local result = {}
  result["Down"] = true
  result["B"] = true
  return result
end

function Example:kneeBazooka()
  local result = {}
  result["Left"] = true --or Right
  result["B"] = true
  return result
end

-- consition: "close"
function Example:reverseSpinKick()
  local result = {}
  result["Left"] = true --or Right
  result["C"] = true
  return result
end


return Example
