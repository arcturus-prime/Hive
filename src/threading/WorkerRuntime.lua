--!strict

local Channel = require(script.Parent.Parent.utility.Channel)


local actor = script.Parent

local ch = Channel.create(actor.receive, actor.send)

Channel.bind(ch, "spawn", function (routine: ModuleScript)
	local main = require(routine)
	main(ch)
end)