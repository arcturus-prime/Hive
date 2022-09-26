--!strict

local Worker = require(script.Parent.Worker)


export type Dispatcher = {
	workers: { Worker.Worker }
	folder: Folder
}


local function create(parent: Instance)
	local folder = Instance.new("Folder")

	folder.Name = "Workers"
	folder.Parent = parent

	local dispatcher: Dispatcher = { folder = folder, workers = {} }

	return dispatcher
end

local function 