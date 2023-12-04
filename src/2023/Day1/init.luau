local inputs = require(script.inputs)
local data = inputs:split("\n")

--#region Part 1

function partOne(input: string): string
	local c
	input = input:gsub("%a", "")
	if #input > 2 then
		c = input:sub(1, 1) .. input:sub(-1)
	elseif #input == 1 then
		c = input:rep(2)
	else
		c = input
	end
	return c
end

local partOneSum = 0
for _, input in data do
	partOneSum += partOne(input)
end

print(`Day 1 | Part 1: {partOneSum}`)

--#endregion

--#region Part 2

local patterns = {
	{ "one", 1 },
	{ "two", 2 },
	{ "three", 3 },
	{ "four", 4 },
	{ "five", 5 },
	{ "six", 6 },
	{ "seven", 7 },
	{ "eight", 8 },
	{ "nine", 9 },
	{ 1, 1 },
	{ 2, 2 },
	{ 3, 3 },
	{ 4, 4 },
	{ 5, 5 },
	{ 6, 6 },
	{ 7, 7 },
	{ 8, 8 },
	{ 9, 9 },
}

function partTwo(input: string)
	local numbers = {}
	local skip = 0
	for ii = 1, #input do
		if ii < skip then
			continue
		end
		for _, pattern in patterns do
			local s, f = string.find(input, pattern[1], ii)
			if f then
				numbers[#numbers + 1] = { pattern[2], s }
				skip = f
			end
		end
	end

	table.sort(numbers, function(a, b)
		return a[2] < b[2]
	end)

	return numbers[1][1] .. numbers[#numbers][1]
end

local partTwoSum = 0
for _, input in data do
	partTwoSum += partTwo(input)
end

print(`Day 1 | Part 2: {partTwoSum}`)

--#endregion

return true
