local inputs = require(script.inputs)

--#region Part 1
local data = inputs:split("\n")
local Times = data[1]:match("Time:%s+(.+)"):gsub("%s+", " "):split(" ")
local Distances = data[2]:match("Distance:%s+(.+)"):gsub("%s+", " "):split(" ")
local margin = 1

for race = 1, #Times do
	local ways = 0
	local t, d = tonumber(Times[race]), tonumber(Distances[race])

	for i = 1, d do
		if i * (t - i) > d then
			ways += 1
		end
	end
	margin *= ways
	ways = 0
end

print("Day 6 | Part 1:", margin)

--#endregion

--#region Part 2

local t, d = tonumber(table.concat(Times)), tonumber(table.concat(Distances))

print("Day 6 | Part 2:", (math.floor((t + math.sqrt(t ^ 2 - 4 * d)) / 2) - math.floor(t / 2)) * 2 + 1) -- credit to sircfenner

--#endregion

return true
