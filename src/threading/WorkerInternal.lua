local routine = require(script.Parent.routine.Value)

local receive = script.Parent.receive
local send = script.Parent.send


local handlers = {}

local function sent(id, task, ...)
	receive:Fire(id, handlers[task](...))
end

send.Event:ConnectParallel(sent)


routine(handlers)