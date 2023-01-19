local function create(tx: BindableEvent, rx: BindableEvent)
	local ch = {
		handlers = {},
		comm = tx
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