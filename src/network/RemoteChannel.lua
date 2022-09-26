--!strict

local ConservativeBuffer = require(script.Parent.Parent.utility.ConservativeBuffer)
local types = require(script.Parent.Parent.types)


local function bind(ch: types.RemoteChannel, phrase: string, handler: (...any) -> ...any)
	ch.handlers[phrase] = handler
end

local function unbind(ch: types.RemoteChannel, phrase: string)
	ch.handlers[phrase] = nil
end

local function collect(ch: types.RemoteChannel, id: number)
	return ConservativeBuffer.pop(ch.results, id)
end

return {
	bind = bind,
	unbind = unbind,
	collect = collect
}