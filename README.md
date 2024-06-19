```                                        
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
