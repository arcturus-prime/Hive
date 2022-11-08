--!strict

export type Channel = {
	handlers: { [string]: (...any) -> ...any },	
	results: ConservativeBuffer,
	tx: BindableEvent,
	rx: BindableEvent
}


local ConservativeBuffer = require(script.Parent.Parent.utility.ConservativeBuffer)


local function create(send: BindableEvent, receive: BindableEvent)
	local ch: Channel = {
		tx = send,
		rx = receive,
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

		ch.tx:Fire(id, nil, ch.handlers[command](...))
	end

	receive:ConnectParallel(received)

	return ch
end

local function fire(ch: Channel, command: string, ...)
	local id = ConservativeBuffer.reserve(ch.results)

	ch.tx:Fire(id, command, ...)

	return id
end

local function bind(ch: Channel, phrase: string, handler: (...any) -> ...any)
	ch.handlers[phrase] = handler
end

local function unbind(ch: Channel, phrase: string)
	ch.handlers[phrase] = nil
end

local function collect(ch: Channel, id: number)
	return ConservativeBuffer.pop(ch.results, id)
end


return {
	create = create,
	fire = fire,
	bind = bind,
	unbind = unbind,
	collect = collect
}