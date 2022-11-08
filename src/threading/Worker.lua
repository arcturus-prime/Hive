--!strict

local Channel = require(script.Parent.Parent.utility.Channel)
local WorkerRuntime = script.Parent.WorkerRuntime

local function create(parent: Instance)
	local actor = Instance.new("Actor")
	local send = Instance.new("BindableEvent")
	local receive = Instance.new("BindableEvent")

	local runtime = WorkerRuntime:Clone()

	actor.Name = "Worker"
	send.Name = "send"
	receive.Name = "receive"

	send.Parent = actor
	receive.Parent = actor
	runtime.Parent = actor

	actor.Parent = parent

	local ch = Channel.create(send, receive)

	local worker: Worker = { actor = actor, comm = ch }

	return worker
end

local function spawn(worker: Worker, routine: ModuleScript)
	Channel.fire(worker.comm, "spawn", routine)
end


return {
	create = create,
	spawn = spawn
}