--!strict

local ConservativeBuffer = require(script.Parent.Parent.utility.ConservativeBuffer)
local types = require(script.Parent.Parent.types)


local function create(event: RemoteEvent)
	local ch: types.RemoteChannel = {
		cx = event
		handlers = {},
		results = { 2 }
	}

	local function received(id, command, ...)
		if (not command and #args == 0) then
			return
		end

		if (not command) then 
			ch.results[id] = args
			return
		end

		ch.cx:FireServer(id, nil, ch.handlers[command](...))
	end

	event.OnClientEvent:Connect(received)

	return ch
end

local function fire(ch: types.RemoteChannel, command: string, ...)
	local id = ConservativeBuffer.reserve(ch.results)

	ch.cx:FireServer(id, command, ...)

	return id
end


return {
	create = create,
	fire = fire
}