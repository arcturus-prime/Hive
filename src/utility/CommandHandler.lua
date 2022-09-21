export type CommandHandler = {
	event: BindableEvent,
	handlers: { [string]: {(...any) -> nil} }
}


local module = {}

function module.create(event: BindableEvent, parallel: boolean)
	local ch: CommandHandler = {}

	ch.event = event
	ch.handlers = {}

	local function handler(phrase, ...)
		if (not ch.handlers[phrase]) then warn(string.format("Handler for phrase \"%s\" not bound!", phrase)) return end

		for i,v in ipairs(ch.handlers[phrase]) do
			v(...)
		end
	end 

	if parallel then event.Event:ConnectParallel(handler)
	else event.Event:Connect(handler) end

	setmetatable(ch, { __index = module })

	return ch
end

function module.bind(ch: CommandHandler, phrase: string, handler: (...any) -> nil)
	if not ch.handlers[phrase] then ch.handlers[phrase] = {} end

	table.insert(ch.handlers[phrase], handler)

	return phrase .. "\x1E" .. #ch.handlers[phrase]
end

function module.unbind(ch: CommandHandler, signature: string)
	local splitSig = string.split(signature, "\x1E")

	table.remove(ch.handlers[splitSig[1]], splitSig[2])
end

function module.fire(ch: CommandHandler, phrase: string, ...any)
	ch.event:Fire(phrase, ...)
end

function module.wait(ch: CommandHandler, phrase: string)
	local args = 0
	repeat
		args = table.pack(ch.event.Event:Wait())
	until (args[1] == phrase)

	return table.unpack(args, 2)
end

return module