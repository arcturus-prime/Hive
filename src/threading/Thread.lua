export type Thread = {
	id: number,
	comm: BindableEvent
}


local module = {}

function module.bind(thread: Thread, name: string, func: (any) -> any)
	
end

return module