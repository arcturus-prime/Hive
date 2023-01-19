local Channel = require(script.Parent.Channel)

local function spawn(parent: Instance, routine: Script)
	local actor = Instance.new("Actor")
	local send = Instance.new("BindableEvent")
	local receive = Instance.new("BindableEvent")
	local routineCopy = routine:Clone()

	actor.Name = "Worker"
	send.Name = "send"
	receive.Name = "receive"
	routineCopy.Name = "routine"

	send.Parent = actor
	receive.Parent = actor
	routineCopy.Parent = actor

	actor.Parent = parent

	local ch = Channel.create(send, receive)

	return ch
end



return {
	spawn = spawn
}