local ConservativeBuffer = require(script.Parent.Parent.utility.ConservativeBuffer)

export type Channel = {
	handlers: { [string]: (...any) -> ...any },	
	send: BindableEvent
}

local function create(tx: BindableEvent, rx: BindableEvent)
	local ch: Channel = {
		handlers = {},
		send = tx
	}

	local function received(command, ...)
		ch.handlers[command](...)
	end

	rx:ConnectParallel(received)

	return ch
end

return {
	create = create
}