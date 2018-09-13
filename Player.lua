require("Player")

local Example = {}
setmetatable(Example, {__index = Player})
local Example_mt = {__index = Example}
local file

local Attacks = {
    JudoThrow=0,
    DragonSuplex=1,
    FlyingMare=2,
    FlyingBusterDrop=3,
    KneeBazooka=4,
    ReverseSpinKick=5,
    SpinningBackKnuckle=6,
    SonicBoom=7,
    SomersaultKick=8,
    LowerPunch=9,
    MiddlePunch=10,
    HighPunch=11,
    LowerKick=12,
    MiddleKick=13,
    HighKick=14
}

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
  --print(name, value)
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
     {name="MoveToOpponent",        isMagic=false, maximalDistance=1, air=false,   close=false,  call=self.MoveToOpponent},
     {name="Judo Throw",            isMagic=false, maximalDistance=1, air=false,   close=true,  call=self.JudoThrow},
     {name="Dragon Suplex",         isMagic=false, maximalDistance=1, air=false,   close=true,  call=self.DragonSuplex},
     {name="Flying Mare",           isMagic=false, maximalDistance=1, air=true,    close=true,  call=self.FlyingMare},
     {name="Flying Buster Drop",    isMagic=false, maximalDistance=1, air=true,    close=true,  call=self.FlyingBusterDrop},
     {name="Knee Bazooka",          isMagic=false, maximalDistance=1, air=false,   close=false, call=self.KneeBazooka},
     {name="Reverse Spin Kick",     isMagic=false, maximalDistance=1, air=false,   close=true,  call=self.ReverseSpinKick},
     {name="Spinning Back Knuckle", isMagic=false, maximalDistance=65, air=false,   close=false, call=self.SpinningBackKnuckle},
     {name="Sonic Boom",            isMagic=false, maximalDistance=300, air=false,   close=false, call=self.SonicBoom},
     {name="Somersault Kick",       isMagic=false, maximalDistance=75, air=false,   close=false, call=self.SomersaultKick},

     {name="Lower Punch",           isMagic=false, maximalDistance=55, air=false,   close=false, call=self.LowerPunch},
     {name="Middle Punch",          isMagic=false, maximalDistance=60, air=false,   close=false, call=self.MiddlePunch},
     {name="High Punch",            isMagic=false, maximalDistance=75, air=false,   close=false, call=self.HighPunch},
     {name="Lower Kick",            isMagic=false, maximalDistance=55, air=false,   close=false, call=self.LowerKick},
     {name="Middle Kick",           isMagic=false, maximalDistance=65, air=false,   close=false, call=self.MiddleKick},
     {name="High Kick",             isMagic=false, maximalDistance=70, air=false,   close=false, call=self.HighKick}
   }

   self.currentStateIndex = 8

   return self
end

function Example:startRound()
end

function Example:log(me, enemy)
  SimpleSetSignal("self.i", self.i)
	SimpleSetSignal("me.x", me["x"])
	SimpleSetSignal("me.y", me["y"])
	SimpleSetSignal("me.distanceToOpponent", me["distanceToOpponent"])
	SimpleSetSignal("me.crounching", me["crounching"])
	SimpleSetSignal("me.jumping", me["jumping"])
	SimpleSetSignal("me.facingRight", me["facingRight"])
	SimpleSetSignal("me.advancing", me["advancing"])
  SimpleSetSignal("me.goingBack", me["goingBack"])
  SimpleSetSignal("me.attacking", me["attacking"])
  SimpleSetSignal("me.magic", me["magic"])
  --SimpleSetSignal("me.attack", me["attak"])
  SimpleSetSignal("me.thrown", me["thrown"])
  SimpleSetSignal("me.blockOrHit", me["blockOrHit"])
  SimpleSetSignal("me.remoteAttack", me["remoteAttack"])
  SimpleSetSignal("me.remoteAttackPos", me["remoteAttackPos"])
  SimpleSetSignal("me.dizzy", me["dizzy"])
	SimpleSetSignal("enemy.x", enemy["x"])
	SimpleSetSignal("enemy.y", enemy["y"])
	SimpleSetSignal("enemy.distanceToOpponent", enemy["distanceToOpponent"])
	SimpleSetSignal("enemy.crounching", enemy["crounching"])
	SimpleSetSignal("enemy.jumping", enemy["jumping"])
	SimpleSetSignal("enemy.facingRight", enemy["facingRight"])
	SimpleSetSignal("enemy.advancing", enemy["advancing"])
	SimpleSetSignal("enemy.goingBack", enemy["goingBack"])
  SimpleSetSignal("enemy.attacking", enemy["attacking"])
  SimpleSetSignal("enemy.magic", enemy["magic"])
  --SimpleSetSignal("enemy.attack", enemy["attak"])
  SimpleSetSignal("enemy.thrown", enemy["thrown"])
  SimpleSetSignal("enemy.blockOrHit", enemy["blockOrHit"])
  SimpleSetSignal("enemy.remoteAttack", enemy["remoteAttack"])
  SimpleSetSignal("enemy.remoteAttackPos", enemy["remoteAttackPos"])
  SimpleSetSignal("enemy.dizzy", enemy["dizzy"])
	SimpleSchedule(1)
end

function Example:advance(me, enemy)
  self:log(me, enemy)

  result = self:performCurrentAction(me)

  self.i = self.i + 1

  return result
end

function Example:performCurrentAction(me)
  local result = {}

  currentState = self.fktTable[self.currentStateIndex]

  -- called every frame
  if currentState ~= nil then
    if self.currentStateIndex == 1 then
      finished, result = self:MoveToOpponent(me)
    elseif self.currentStateIndex == 8 then
      finished, result = currentState.call(me)
    end
    
    if finished then
      self.i = 0
      self.currentStateIndex = 0
    end
  end

  return result
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

function Example:MoveBackward(me)
    local result = {}
    result[self:backward(me)] = true
    return result
end

function Example:MoveForward(me)
    local result = {}
    result[self:forward(me)] = true
    return result
end

function Example:MoveToOpponent(me)
  local result = {}
  result[self:forward(me)] = true
  return true, result
end


-- NORMAL ATTACKS --

function Example:LowerPunch(me)
    local result = {}
    if self.i < 2 then
        result["X"] = true
    end
    return result
end

function Example:MiddlePunch(me)
    local result = {}
    if self.i < 2 then
        result["Y"] = true
    end
    return result
end

function Example:HighPunch(me)
    local result = {}
    if self.i < 2 then
        result["Z"] = true
    end
    return result
end

function Example:LowerKick(me)
    local result = {}
    if self.i < 2 then
        result["A"] = true
    end
    return result
end

function Example:MiddleKick(me)
    local result = {}
    if self.i < 2 then
        result["B"] = true
    end
    return result
end

function Example:HighKick(me)
    local result = {}
    if self.i < 2 then
        result["C"] = true
    end
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
	return result
end

function Example:SonicBoom(me)
	local result = {}
	local forward = self:forward(me)
	local backward = self:backward(me)

	if self.i < 65 then
    result[backward] = true
    return false, result 
	elseif self.i < 67 then
		result[forward] = true
    result["Y"] = true
    return false, result 
	end
  
	return true, {}
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
