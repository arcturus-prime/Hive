local RunService = game:GetService("RunService")


local Internal

if (RunService.IsServer)
then Internal = script.Parent.InternalServer
else Internal = script.Parent.InternalClient end


local function reserve(worker)
	local id = worker[1]

	if not worker[id] then
		worker[1] = worker[2]
		worker[2] += 1
	else
		worker[1] = worker[id]
	end

	return id
end

local function collect(worker, id: number)
	while worker[id] == nil do task.wait() end

	local result = worker[id]
	worker[id] = worker[1]
	worker[1] = id

	return result
end

local function create(parent: Instance, routine: ModuleScript)
	local actor = Instance.new("Actor")
	local send = Instance.new("BindableEvent")
	local receive = Instance.new("BindableEvent")
	local routineValue = Instance.new("ObjectValue")
	local runtime = Internal:Clone()

	runtime.Enabled = true

	actor.Name = "Worker"
	send.Name = "send"
	receive.Name = "receive"
	routineValue.Name = "routine"

	send.Parent = actor
	receive.Parent = actor
	runtime.Parent = actor
	routineValue.Parent = actor

	routineValue.Value = routine
	
	actor.Parent = parent

	local worker = {
		actor = actor,
		[1] = 3,
		[2] = 3
	}

	receive.Event:Connect(function (id, ...)
		worker[id] = table.pack(...)
	end)

	return worker
end

local function thread(worker, command, ...)
	local id = reserve(worker)

	worker.actor.send:Fire(id, command, ...)

	return id
end

return {
	create = create,
	thread = thread,
	collect = collect
}