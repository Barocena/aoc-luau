local input = require(script.input)

local data = input:split("\n")

function getResults(card)
	local winAmount = 0
	local points = 0.5
	local allNumbers = card:split(": ")[2]:split("|")
	local WinningNumbers = allNumbers[1]:split(" ")
	local cardNumbers = allNumbers[2]:split(" ")
	for _, number in WinningNumbers do
		if tonumber(number) and table.find(cardNumbers, number) then
			winAmount += 1
		end
	end

	for _ = 1, winAmount do
		points *= 2
	end
	return { ["winAmount"] = winAmount, ["points"] = math.floor(points) }
end

--#region Part 1

local partOneSum = 0

for _, card in data do
	partOneSum += getResults(card).points
end

print("Day 4 | Part 1:", partOneSum)

--#endregion

--#region Part 2
local partTwoSum = 1
local currentPile = {}
local newPile = {}
local indexedData = {}

for index, card in data do
	table.insert(indexedData, { ["index"] = index, ["card"] = card })
end

function getPileAmount()
	if partTwoSum == 1 and #currentPile == 0 then
		currentPile = indexedData
	end

	for _, cardData in currentPile do
		local cardIndex = cardData.index
		local card = cardData.card

		local winAmount = getResults(card).winAmount
		for i = cardIndex + 1, cardIndex + winAmount do
			table.insert(newPile, { ["index"] = i, ["card"] = data[i] })
		end
		partTwoSum += 1
	end
	currentPile = {}
	currentPile = newPile
	newPile = {}

	if #currentPile > 1 then
		wait()
		getPileAmount()
	else
		print("Day 4 | Part 2:", partTwoSum)
	end
end

getPileAmount()

--#endregion

return true
