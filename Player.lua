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
	lvalue = value

	if value == true then
		lvalue = 1
	end

	if value == false then
		lvalue = 0
	end

  text = "param=" .. name .. "|param=" .. lvalue
  SimpleSendCommand("SetSignalCmdRequest", text)
end

function SimpleSchedule(time)
    text = "param=" .. time
    SimpleSendCommand("ScheduleCmdRequest", text)
end

---------------------------------------------------------------------------------------------------

function Example.new(player)
   local self = Player.new(player)
   file = io.open("c:\\temp\\streetfighter.txt", "a")
   self.i = 0
   setmetatable(self, Example_mt)

   self.fktTable = {
     {name="Judo Throw",            isMagic=false, maximalDistance=1, air=false,   close=true,  call=self.JudoThrow},
     {name="Dragon Suplex",         isMagic=false, maximalDistance=1, air=false,   close=true,  call=self.DragonSuplex},
     {name="Flying Mare",           isMagic=false, maximalDistance=1, air=true,    close=true,  call=self.FlyingMare},
     {name="Flying Buster Drop",    isMagic=false, maximalDistance=1, air=true,    close=true,  call=self.FlyingBusterDrop},
     {name="Knee Bazooka",          isMagic=false, maximalDistance=1, air=false,   close=false, call=self.KneeBazooka},
     {name="Reverse Spin Kick",     isMagic=false, maximalDistance=1, air=false,   close=true,  call=self.ReverseSpinKick},
     {name="Spinning Back Knuckle", isMagic=false, maximalDistance=1, air=false,   close=false, call=self.SpinningBackKnuckle},
     {name="Sonic Boom",            isMagic=false, maximalDistance=1, air=false,   close=false, call=self.SonicBoom},
     {name="Somersault Kick",       isMagic=false, maximalDistance=1, air=false,   close=false, call=self.SomersaultKick},

     {name="Lower Punch",           isMagic=false, maximalDistance=1, air=false,   close=false, call=self.LowerPunch},
     {name="Middle Punch",          isMagic=false, maximalDistance=1, air=false,   close=false, call=self.MiddlePunch},
     {name="High Punch",            isMagic=false, maximalDistance=1, air=false,   close=false, call=self.HighPunch},
     {name="Lower Kick",            isMagic=false, maximalDistance=1, air=false,   close=false, call=self.LowerKick},
     {name="Middle Kick",           isMagic=false, maximalDistance=1, air=false,   close=false, call=self.MiddleKick},
     {name="High Kick",             isMagic=false, maximalDistance=1, air=false,   close=false, call=self.HighKick}
   }


   return self
end

function Example:startRound()
end

function Example:log()
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
end

function Example:advance(me, enemy)
  self.log()

  -- called every frame
  if me["distanceToOpponent"] > 0 then
      return self:moveForward(me)
  end

  return me
end

function Example:fighter()
	return "Guile"
end

function Example:name()
	return "Kimbo"
end

function Example:goToDistance()

end

-- DISTANCE --

function Example:distance(me, enemy)
    if me["facingRight"] then
        return  me["x"] - enemy["remoteAttackPos"]
    else
        return enemy["remoteAttackPos"] - me["x"]
    end
end

-- MOVE --

function Example:forward(me)
    if me["facingRight"] then
        return "Right"
    end
    return "Left"
end

function Example:backward(me)
    if me["facingRight"] then
        return "Left"
    end
    return "Right"
end

function Example:moveBackward(me)
    local result = {}
    result[self:backward(me)] = true
    return result
end

function Example:moveForward(me)
    local result = {}
    result[self:forward(me)] = true
    return result
end


-- NORMAL ATTACKS --

function Example:LowerPunch(me)
    local result = {}
    if self.i < 2 then
        result["X"] = true
    end
    self.i = self.i + 1
    return result
end

function Example:MiddlePunch(me)
    local result = {}
    if self.i < 2 then
        result["Y"] = true
    end
    self.i = self.i + 1
    return result
end

function Example:HighPunch(me)
    local result = {}
    if self.i < 2 then
        result["Z"] = true
    end
    self.i = self.i + 1
    return result
end

function Example:LowerKick(me)
    local result = {}
    if self.i < 2 then
        result["A"] = true
    end
    self.i = self.i + 1
    return result
end

function Example:MiddleKick(me)
    local result = {}
    if self.i < 2 then
        result["B"] = true
    end
    self.i = self.i + 1
    return result
end

function Example:HighKick(me)
    local result = {}
    if self.i < 2 then
        result["C"] = true
    end
    self.i = self.i + 1
    return result
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
function Example:flyingBusterDrop(me)
  local result = {}
  result["Down"] = true
  result["B"] = true
  return result
end

function Example:kneeBazooka(me)
  local result = {}
  result["Left"] = true --or Right
  result["B"] = true
  return result
end

-- consition: "close"
function Example:reverseSpinKick(me)
  local result = {}
  result["Left"] = true --or Right
  result["C"] = true
  return result
end

function Example:CloseFile()
	file:close()
end

return Example
