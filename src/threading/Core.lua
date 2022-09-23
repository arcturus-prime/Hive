local Thread = require(script.Parent.Thread)
local Channel = require(script.Parent.Parent.utility.Channel)
local CoreRuntime = script.Parent.CoreRuntime


export type Core = {
	actor: Actor,
	comm: Channel.Channel
}


local module = {}
 
function module.create(parent: Instance)
	local actor = Instance.new("Actor")
	local event = Instance.new("BindableEvent")
	local runtime = CoreRuntime:Clone()

	actor.Parent = parent
	event.Parent = actor
	runtime.Parent = actor

	local ch = Channel.create(event, true)

	local core: Core = { actor = actor, comm = ch }

	setmetatable(core, { __index = module })

	return core
end

function module.spawn(core: Core, routine: ModuleScript)
	core.comm:fire("spawn", routine)
	local thread = core.comm:wait("spawned")

	return thread
end

return module