local Thread = require(script.Parent.Thread)
local CommandHandler = require(script.Parent.Parent.utility.CommandHandler)
local CoreRuntime = script.Parent.CoreRuntime


export type Core = {
	actor: Actor,
	comm: CommandHandler.CommandHandler
}


local module = {}
 
function module.create(parent: Instance)
	local actor = Instance.new("Actor")
	local event = Instance.new("BindableEvent")
	local runtime = CoreRuntime:Clone()

	actor.Parent = parent
	event.Parent = actor
	runtime.Parent = actor

	local ch = CommandHandler.create(event, true)

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