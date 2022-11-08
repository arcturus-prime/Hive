--!strict


export type ConservativeBuffer = { any }


local function reserve(cb: ConservativeBuffer)
	local id = cb[1]
	cb[1] = cb[id] or #cb + 1

	return id
end

local function pop(cb: ConservativeBuffer, id: number)
	local result = cb[id]
	cb[id] = cb[1]
	cb[1] = id

	return result
end

local function push(cb: ConservativeBuffer, item: any)
	local id = reserve(cb)
	cb[id] = item
	
	return id
end


return {
	reserve = reserve,
	pop = pop,
	push = push
}