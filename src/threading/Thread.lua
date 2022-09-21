export type Thread = {
	routine: ModuleScript,
	comm: BindableEvent,
	
}


local module = {}

function module.bind(thread: Thread, name: string, func: (any) -> any)
	
end

return module