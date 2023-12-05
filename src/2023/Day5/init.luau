local inputs = require(script.inputs)

local _testinput = [[seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4]]

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

return true
