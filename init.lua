local RunService = game:GetService("RunService")

local Internal = script.Parent


export type Worker = { actor: Actor, [number]: any }


--[=[
	@interface Hive
	.reserve
	.create
	.collect
]=]
local module = {}

local function reserve(worker: Worker): number
	local id = worker[1]

	if not worker[id] then
		worker[1] = worker[2]
		worker[2] += 1
	else
		worker[1] = worker[id]
	end

	return id
end

--[=[
	@function create
	@within Hive
	@param parent Instance
	@param routine ModuleScript
	@return Worker

	Takes in the [Instance] to parent the [Actor] (along with its signals, etc.) to and the [ModuleScript] containing the task table.
]=]
function module.create(parent: Instance, routine: ModuleScript): Worker
	local actor = Instance.new("Actor")
	local send = Instance.new("BindableEvent")
	local receive = Instance.new("BindableEvent")
	local routineValue = Instance.new("ObjectValue")
	local runtime = Internal:Clone()

	runtime.Enabled = true
	runtime.RunContext = if RunService.IsServer then Enum.RunContext.Server else Enum.RunContext.Client

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

	local worker: Worker = {
		actor = actor,
		[1] = 3,
		[2] = 3
	}

	receive.Event:Connect(function (id, ...)
		worker[id] = table.pack(...)
	end)

	return worker
end


--[=[
	@function thread
	@within Hive
	@param worker Worker
	@param command any
	@param args ...
	@return number

	Uses a [Worker] record to spawn a new thread with specified arguments using a task from that [Worker]'s task table.
	Returns an id corresponding to an index in the worker's results table for use in [Hive.collect]

]=]
function module.thread(worker: Worker, command: any, ...): number
	local id: number = reserve(worker)

	worker.actor.send:Fire(id, command, ...)

	return id
end

--[=[
	@function collect
	@within Hive
	@param worker Worker
	@param id number
	@return ...any

	Collects and returns the results of a task. If the task is not finished, it yields the caller until the task has completed.
]=]
function module.collect(worker: Worker, id: number): ...any
	while worker[id] == nil do task.wait() end

	local result: { any } = worker[id]
	worker[id] = worker[1]
	worker[1] = id

	return table.unpack(result)
end

return module