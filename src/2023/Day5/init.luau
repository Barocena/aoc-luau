local inputs = require(script.inputs)

--#region Part 1

--#region Parse the Data

local data = inputs:split("\n")

local seeds = data[1]:split(": ")[2]:split(" ")
local maps = {}

table.remove(data, 1)

local currentMap = 0
for _, line in data do
	if line == "" then
		currentMap += 1
		maps[currentMap] = {}
	else
		local range = line:split(": ")[1]
		if not range:match("map") then
			table.insert(maps[currentMap], range:split(" "))
		end
	end
end

--#endregion

--#region Calculate the Result

function calculateRange(value, rangeData)
	local dest, src, len = tonumber(rangeData[1]), tonumber(rangeData[2]), tonumber(rangeData[3])
	local result = (value - src)
	result += dest
	if result >= dest and result <= dest + len then
		return result
	end
	return false
end

local locations = {}
for _, seed in seeds do
	local number = tonumber(seed)
	for _, map in maps do
		for _, range in map do
			local calculation = calculateRange(number, range)
			if calculation then
				number = calculation
				break
			end
		end
	end
	table.insert(locations, number)
end

table.sort(locations, function(a, b)
	return a < b
end)

print("Day 5 | Part 1:", locations[1])

--#endregion

--#endregion

--#region Part 2

local partTwoSeeds = {}
for i = 2, #seeds, 2 do
	table.insert(partTwoSeeds, { seeds[i - 1], seeds[i] })
end

local minlocation = math.huge

for _, seed in partTwoSeeds do
	--[[ 	My initial solution (too slow)

	for i = 1, seed[2] do
		local number = tonumber(seed[1] + i)
		for _, map in maps do
			for _, range in map do
				local calculation = calculateRange(number, range)
				if calculation then
					number = calculation
					break
				end
			end
		end
		location = math.min(location, number)
	end 
	]]

	local number = tonumber(seed[1])
	local ending = tonumber(seed[1] + seed[2])
	while number <= ending do
		local nextNumber = math.huge
		local location = number

		for _, map in maps do
			for _, range in map do
				local rangeEnd = tonumber(range[2]) + tonumber(range[3]) :: any

				if location < rangeEnd and location >= tonumber(range[2]) then
					nextNumber = math.min(nextNumber, rangeEnd - location)
					location = (location - tonumber(range[2])) + tonumber(range[1])
					break
				end
			end
		end
		minlocation = math.min(minlocation, location)
		number += nextNumber
	end
end

print("Day 5 | Part 2:", minlocation)

--#endregion

return true
