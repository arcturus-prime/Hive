--!strict

local types = require(script.Parent.Parent.types)


local function reserve(cb: types.ConservativeBuffer)
	local id: number = cb[1]
	cb[1] = cb[id] or #cb + 1

	return id
end

local function pop(cb: types.ConservativeBuffer, id: number)
	local result = cb[id]
	cb[id] = cb[1]
	cb[1] = id

	return result
end

local function push(cb: types.ConservativeBuffer, item: any)
	local id = reserve(cb)
	cb[id] = item
	
	return id
end


return {
	reserve = reserve,
	collect = collect,
	insert = insert
}