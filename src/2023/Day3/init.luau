local inputs = require(script.inputs)
local canvasSize = 140

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

for i = 1, canvasSize do
	for j = 1, canvasSize do
		local char = engineMatrix[i][j]
		engineMatrix[i][j] = symbolLayer[char]
	end
end

--#endregion

--#region Check the Matrix

local skip = 0

function boundCheck(ii, jj)
	local check = if ii < 1 or ii > canvasSize or jj < 1 or jj > canvasSize then false else true
	return check
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

--#region Part 2

local partTwoSum = 0

local gearSymbolLayer = {
	["."] = false,
	["/"] = false,
	["*"] = true,
	["$"] = false,
	["="] = false,
	["@"] = false,
	["&"] = false,
	["#"] = false,
	["+"] = false,
	["-"] = false,
	["%"] = false,
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

local gearMatrix = {}
local gearrows = inputs:split("\n")
for i, row in gearrows do
	gearMatrix[i] = row:split("")
end

for i = 1, canvasSize do
	for j = 1, canvasSize do
		local char = gearMatrix[i][j]
		gearMatrix[i][j] = gearSymbolLayer[char]
	end
end

local mainCheckedNumbers = {}
local checkedGroupNumbers = {}
local tempGroup = {}

function alreadyChecked(i, j)
	for _, v in tempGroup do
		if v[1] == i and v[2] == j then
			return true
		end
	end
	return false
end

function numberRadiusCheck(i, j)
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
			if tonumber(gearMatrix[newRow][newCol]) then
				if not alreadyChecked(newRow, newCol) then
					return { newRow, newCol }
				end
			end
		end
	end
	return false
end

function gearNumberGroup(i, j)
	local num = gearMatrix[i][j]
	local numberList = { { num, j, true } }
	tempGroup[#tempGroup + 1] = { i, j }
	local function recursiveCheck(ii, jj, dir)
		local nextCell = jj + dir
		if boundCheck(ii, nextCell) then
			local nextNum = gearMatrix[ii][nextCell]
			if tonumber(nextNum) then
				if not alreadyChecked(ii, nextCell) then
					numberList[#numberList + 1] = { nextNum, nextCell }
					tempGroup[#tempGroup + 1] = { ii, nextCell }
					recursiveCheck(ii, nextCell, dir)
				end
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
	checkedGroupNumbers[#checkedGroupNumbers + 1] = tonumber(resultNumber)
end

function checkProcess(i, j)
	local radiusResult = numberRadiusCheck(i, j)
	if radiusResult then
		gearNumberGroup(radiusResult[1], radiusResult[2])
		checkProcess(i, j)
	else
		if #checkedGroupNumbers == 2 then -- if there is exactly 2 number group in the near of gear.
			for _, v in tempGroup do
				mainCheckedNumbers[#mainCheckedNumbers + 1] = { v[1], v[2] }
			end
			partTwoSum += checkedGroupNumbers[1] * checkedGroupNumbers[2]
			checkedGroupNumbers = {}
		else
			checkedGroupNumbers = {}
		end
	end
end

for i = 1, canvasSize do
	for j = 1, canvasSize do
		local char = gearMatrix[i][j]
		if char == true then -- if it is star
			tempGroup = {}
			checkProcess(i, j)
		end
	end
end

print(`Day 3 | Part 2: {partTwoSum}`)

--#endregion

return true
