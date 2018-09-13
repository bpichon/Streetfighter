require("Player")

local Example = {}
setmetatable(Example, {__index = Player})
local Example_mt = {__index = Example}
local file

---------------------------------------------------------------------------------------------------
-- SIMPLE environment
---------------------------------------------------------------------------------------------------
function SimpleSendCommand(command, args)
  text = "cmd=" .. command .. "|" .. args .. "\n"
  --print (text)

	--co = coroutine.create(function ()
		-- appends a word test to the last line of the file
	file:write(text)
	--end)

	--coroutine.resume(co)
end

--
-- send set signal command
--
function SimpleSetSignal(name, value)
    text = "param=" .. name .. "|param=" .. value
    SimpleSendCommand("SetSignalCmdRequest", text)
end

function SimpleSchedule(time)
    text = "param=" .. time
    SimpleSendCommand("ScheduleCmdRequest", text)
end

---------------------------------------------------------------------------------------------------

function Example.new(player)
   local self = Player.new(player)
   setmetatable(self, Example_mt)
   return self
end

function Example:startRound()
end

function Example:advance(me, enemy)
	SimpleSetSignal("self.i", self.i)
	SimpleSetSignal("me.x", me["x"])
	SimpleSetSignal("me.y", me["y"])
	SimpleSetSignal("me.distanceToOpponent", me["distanceToOpponent"])
	SimpleSetSignal("me.crounching", me["crounching"])
	SimpleSetSignal("me.jumping", me["jumping"])
	SimpleSetSignal("me.facingRight", me["facingRight"])
	SimpleSetSignal("me.advancing", me["advancing"])
	SimpleSetSignal("me.goingBack", me["goingBack"])
	SimpleSetSignal("enemy.x", enemy["x"])
	SimpleSetSignal("enemy.y", enemy["y"])
	SimpleSetSignal("enemy.distanceToOpponent", enemy["distanceToOpponent"])
	SimpleSetSignal("enemy.crounching", enemy["crounching"])
	SimpleSetSignal("enemy.jumping", enemy["jumping"])
	SimpleSetSignal("enemy.facingRight", enemy["facingRight"])
	SimpleSetSignal("enemy.advancing", enemy["advancing"])
	SimpleSetSignal("enemy.goingBack", enemy["goingBack"])
	SimpleSchedule(1)

  -- called every frame
    return me
end

function Example:fighter()
	return "Guile"
end

function Example:name()
	return "Kimbo"
end

-- SPECIAL ATTACKS --

function Example:SpinningBackKnuckle(me)
	local result = {}
	local forward = self:forward(me)
	local backward = self:backward(me)

	if self.i < 2 then
		result[forward] = true
	elseif self.i < 4 then
		result["Y"] = true
	end
	self.i = self.i + 1
	return result
end

function Example:SonicBoom(me)
	local result = {}
	local forward = self:forward(me)
	local backward = self:backward(me)

	if self.i < 65 then
		result[backward] = true
	elseif self.i < 67 then
		result[forward] = true
		result["Y"] = true
	end
	self.i = self.i + 1
	return result
end

function Example:SomersaultKick(me)
   local result = {}
   local forward = self:forward(me)
   if self.i < 2 then
      result["Down"] = true
   elseif self.i < 4 then
      result["Up"] = true
	  result["B"] = true
   end
   self.i = self.i + 1
   return result
end

function Example:JudoThrow(me) -- close
    local result = {}
    local forward = self:forward(me)
    local backward = self:backward(me)
    if self.i < 2 then  -- forward/backward + medium punch
        if (me.x < 250) then
            result[backward] = true
        else
            result[forward] = true
        end
        result["Y"] = true
    end
    self.i = self.i + 1
    return result
end

function Example:DragonSuplex(me) -- close
    local result = {}
    local forward = self:forward(me)
    local backward = self:backward(me)
    if self.i < 2 then  -- forward/backward + high punch
        if (me.x < 250) then
            result[backward] = true
        else
            result[forward] = true
        end
        result["Z"] = true
    end
    self.i = self.i + 1
    return result
end

function Example:FlyingMare(me) -- AIR close
    local result = {}
    if self.i < 20 then  -- up
        result["Up"] = true
    elseif self.i > 20 and self.i < 24 then  -- down + medium/high punch
        result["Down"] = true
        -- result["Y"] = true -- medium
        result["Z"] = true -- high
    end
    self.i = self.i + 1
    return result
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

function Example:CloseFile()
	file:close()
end


return Example
