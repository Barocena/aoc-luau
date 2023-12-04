local inputs = require(script.inputs)

--#region Part 1

--#region Create the Matrix

local symbolLayer = {
	["."] = false,
	["/"] = true,
	["*"] = true,
	["$"] = true,
	["="] = true,
	["@"] = true,
	["&"] = true,
	["#"] = true,
	["+"] = true,
	["-"] = true,
	["%"] = true,
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
}

local engineMatrix = {}
local rows = inputs:split("\n")
for i, row in rows do
	engineMatrix[i] = row:split("")
end

for i = 1, 140 do
	for j = 1, 140 do
		local char = engineMatrix[i][j]
		engineMatrix[i][j] = symbolLayer[char]
	end
end

--#endregion

--#region Check the Matrix

local skip = 0

function boundCheck(ii, jj)
	return if ii < 1 or ii > 140 or jj < 1 or jj > 140 then false else true
end

function symbolRadiusCheck(i, j)
	local directions = {
		{ -1, 0 }, -- Up
		{ 1, 0 }, -- Down
		{ 0, -1 }, -- Left
		{ 0, 1 }, -- Right
		{ -1, -1 }, -- Diagonal Up-Left
		{ -1, 1 }, -- Diagonal Up-Right
		{ 1, -1 }, -- Diagonal Down-Left
		{ 1, 1 }, -- Diagonal Down-Right
	}

	for _, dir in directions do
		local newRow, newCol = i + dir[1], j + dir[2]
		if boundCheck(newRow, newCol) then
			if engineMatrix[newRow][newCol] == true then
				return true
			end
		end
	end
	return false
end

function numberGroup(i, j)
	local num = engineMatrix[i][j]
	local numberList = { { num, j, true } }

	local function recursiveCheck(ii, jj, dir)
		local nextCell = jj + dir
		if boundCheck(ii, nextCell) then
			local nextNum = engineMatrix[ii][nextCell]
			if tonumber(nextNum) then
				numberList[#numberList + 1] = { nextNum, nextCell }
				recursiveCheck(ii, nextCell, dir)
			else
				return
			end
		else
			return
		end
	end

	recursiveCheck(i, j, -1)
	recursiveCheck(i, j, 1)

	table.sort(numberList, function(a, b)
		return a[2] < b[2]
	end)
	
	local resultNumber = ""
	for index, number in numberList do
		resultNumber = resultNumber .. tostring(number[1])
		if number[3] then -- if the number is initial value
			skip = #numberList - index
		end
	end
	return tonumber(resultNumber)
end

local partOneSum = 0

for i = 1, 140 do
	for j = 1, 140 do
		local char = engineMatrix[i][j]
		if tonumber(char) then
			if skip > 0 then
				skip -= 1
				continue
			end
			if symbolRadiusCheck(i, j) then
				partOneSum += numberGroup(i, j)
			end
		end
	end
end

--#endregion

print(`Day 3 | Part 1: {partOneSum}`)

--#endregion

return true
