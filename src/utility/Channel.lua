export type Channel = {
	receive: BindableEvent,
	send: BindableEvent,
	handlers: { [string]: (...any) -> ...any }
}


local module = {}

function module.create(receive: BindableEvent, send: BindableEvent, parallel: boolean)
	local ch: Channel = {}

	ch.receive = receive
	ch.send = send
	ch.handlers = {}

	local function receiveHandler(id, phrase, ...)
		if (not ch.handlers[phrase]) then
			warn(string.format("Handler for phrase \"%s\" not bound!", phrase))
			return
		end

		local results = table.pack(ch.handlers[phrase](...))
		ch.send.Event:Fire(id, table.unpack(results))
	end

	if parallel then receive.Event:ConnectParallel(receiveHandler)
	else receive.Event:Connect(receiveHandler) end

	return ch
end

function module.bind(ch: Channel, phrase: string, handler: (...any) -> nil)
	ch.handlers[phrase] = handler
end

function module.unbind(ch: Channel, phrase: string)
	ch.handlers[phrase] = nil
end

return module