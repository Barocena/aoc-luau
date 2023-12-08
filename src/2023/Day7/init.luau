local inputs = require(script.inputs)

local _testinput = [[32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483]]

local data = inputs:split("\n")

--#region Part 1

local cardRanks = {
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["T"] = 10,
	["J"] = 11,
	["Q"] = 12,
	["K"] = 13,
	["A"] = 14,
}

--[[ 
Type Ranks
Five of a kind : 7
Four of a kind : 6
Full house : 5
Three of a kind : 4
Two pair : 3
One pair : 2
High Card : 1
 ]]

local _handTypes = {
	function(h) -- Five of a kind
		return if #h == 1 then 7 else false
	end,
	function(h) -- Four of a kind
		return if #h == 2 and (h[1] == 4 or h[1] == 1) then 6 else false
	end,
	function(h) -- Full house
		return if #h == 2 then 5 else false
	end,
	function(h) -- Three of a kind
		if #h == 3 then
			for _, s in h do
				if s == 3 then
					return 4
				end
			end
		end
		return false
	end,
	function(h) -- Two pair
		return if #h == 3 then 3 else false -- 3of checks for edge case already
	end,
	function(h) -- One pair
		return if #h == 4 then 2 else false
	end,
	function(h) -- High Card
		return if #h == 5 then 1 else false
	end,
}

local Hands = {}

for _, card in data do
	local hand, bet = card:match("(.*%s)(%d.*)")
	local h = {}
	local jCount = 0
	for symbol, _ in cardRanks do
		local _, n = hand:gsub(symbol, "")
		if n ~= 0 then
			if symbol == "J" then
				jCount = n
			end
			h[#h + 1] = n
		end
	end

	for _, handType in _handTypes do
		local result = handType(h)
		if result then
			table.insert(Hands, { hand, result, bet, jCount }) -- jCount for part 2
			break
		end
	end

	h = {}
end

function compareHands(a: string, b: string)
	for i = 1, 5 do
		if cardRanks[a:sub(i, i)] == cardRanks[b:sub(i, i)] then
			continue
		else
			return cardRanks[a:sub(i, i)] < cardRanks[b:sub(i, i)]
		end
	end
	return "Tie" -- impossible, there is no identical cards
end

table.sort(Hands, function(a, b)
	if a[1] == b[1] then
		return
	end
	return if a[2] == b[2] then compareHands(a[1], b[1]) else a[2] < b[2]
end)

local PartOneSum = 0
for i, _ in Hands do
	PartOneSum += Hands[i][3] * i
end

print(`Day 7 | Part 1: {PartOneSum}`)

--#endregion

--#region Part 2

cardRanks["J"] = 1

for _, hand in Hands do
	local rank = hand[2]
	local jAmount = hand[4]
	local newRule = {
		["R6"] = 7,
		["R5"] = 7,
		["R4"] = 6,
		["R2"] = 4,
		["R1"] = 2,
	}
	if rank ~= 7 then
		if jAmount ~= 0 then
			local newRank = newRule["R" .. rank]
			if newRank then
				hand[2] = newRank
			else
				hand[2] += jAmount + 1
			end
		end
	end
end

table.sort(Hands, function(a, b)
	if a[1] == b[1] then
		return
	end
	return if a[2] == b[2] then compareHands(a[1], b[1]) else a[2] < b[2]
end)

local PartTwoSum = 0
for i, _ in Hands do
	PartTwoSum += Hands[i][3] * i
end

print(`Day 7 | Part 2: {PartTwoSum}`)

--#endregion

return true
