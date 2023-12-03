local inputs = require(script.inputs)
local data = inputs:split("\n")

--#region Parsing the data

local games = {}

for gameNumber, input: string in data do
	local sets = input:split(":")[2]:split(";")
	local gameinfo = {}
	for setIndex, set in sets do
		gameinfo[setIndex] = {}
		local items = set:split(",")
		for _, item in items do
			local itemInfo = item:split(" ")
			gameinfo[setIndex][itemInfo[3]] = itemInfo[2]
		end
		games[gameNumber] = gameinfo
	end
end

--#endregion

--#region Part 1
local limits = { ["red"] = 12, ["green"] = 13, ["blue"] = 14 }

local partOneSum = 0

function possibility(gameinfo)
	for _, set in gameinfo do
		for color, amount in set do
			if tonumber(amount) > limits[color] then
				return false
			end
		end
	end
	return true
end

for gamenumber, gameinfo in games do
	local possible = possibility(gameinfo)
	if possible then
		partOneSum += gamenumber
	end
end

print(`Day 2 | Part 1: {partOneSum}`)

--#endregion

--#region Part 2
--[[ 
in each game what are the biggest number for each color
after getting the number for each color do r * g * b
and add that to the sum
]]
local partTwoSum = 0
for _, gameinfo in games do
	local biggest = { ["red"] = 0, ["green"] = 0, ["blue"] = 0 }
	for _, set in gameinfo do
		for color, amount in set do
			if tonumber(amount) > biggest[color] then
				biggest[color] = tonumber(amount)
			end
		end
	end
	local product = biggest["red"] * biggest["green"] * biggest["blue"]
	partTwoSum += product
end

print(`Day 2 | Part 2: {partTwoSum}`)

--#endregion

return true
