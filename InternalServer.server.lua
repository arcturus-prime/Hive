local routine = require(script.Parent.routine.Value)

local receive = script.Parent.receive
local send = script.Parent.send


local function sent(id, task, ...)
	receive:Fire(id, routine[task](...))
end

send.Event:ConnectParallel(sent)