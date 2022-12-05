local Channel = require(script.Parent.Channel)

local function channel(routine: Script)
	return Channel.create(routine.Parent.receive, routine.Parent.send)
end

return {
	channel = channel
} 