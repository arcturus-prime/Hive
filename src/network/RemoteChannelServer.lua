--!strict

local ConservativeBuffer = require(script.Parent.Parent.utility.ConservativeBuffer)
local types = require(script.Parent.Parent.types)


local function create(event: RemoteEvent)
	local ch: types.RemoteChannel = {
		cx = event
		handlers = {},
		results = { 2 }
	}

	local function received(player, id, command, ...)
		if (not command and #args == 0) then
			return
		end

		if (not command) then 
			ch.results[id] = args
			return
		end

		ch.cx:FireClient(player, id, nil, ch.handlers[command](...))
	end

	event.OnServerEvent:Connect(received)

	return ch
end

local function fire(ch: types.RemoteChannel, clients: { number }, command: string, ...)
	local ids = {}

	for i,v in ipairs(clients) do
		local id = ConservativeBuffer.reserve(ch.results)

		ch.cx:FireClient(v, id, command, ...)
		ids[#ids + 1] = id
	end

	return ids
end


return {
	create = create,
	fire = fire
}