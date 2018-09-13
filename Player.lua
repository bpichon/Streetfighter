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
  -- called every frame
end

function Example:fighter()
	return "Guile"
end

function Example:name()
	return "Conor McGregor"
end

return Example
