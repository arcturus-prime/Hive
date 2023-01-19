local function reserve(cb)
	local id = cb[1]
	cb[1] = cb[id] or #cb + 1

	return id
end

local function pop(cb, id: number)
	local result = cb[id]
	cb[id] = cb[1]
	cb[1] = id

	return result
end

local function push(cb, item)
	local id = reserve(cb)
	cb[id] = item
	
	return id
end

return {
	reserve = reserve,
	pop = pop,
	push = push
}