```                                        
888    888 d8b                   
888    888 Y8P                   
888    888                       
8888888888 888 888  888  .d88b.  
888    888 888 888  888 d8P  Y8b 
888    888 888 Y88  88P 88888888 
888    888 888  Y8bd8P  Y8b.     
888    888 888   Y88P    "Y8888  
```
---
# A compact threading library for Roblox.

## Example

MyTaskList
```lua
local tasks = {}

function tasks.calculateStuffFunction(a, b)
	return a * b, a / b
end

return tasks
```

MyScript
```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Hive = require(ReplicatedStorage.Packages.Hive)

local worker = Hive.create(ReplicatedStorage.Workers, ReplicatedStorage.Scripts.MyTaskList)

local id = Hive.thread(worker, "calculateStuffFunction", 2, 3)

-- Do some other things in the meantime

local mul, div = Hive.collect(worker, id)

```