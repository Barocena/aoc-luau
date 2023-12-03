print("🎄─Advent─of─Code─🎄")

for day = 1, #script.Parent["2023"]:GetChildren() do
	require(script.Parent["2023"]["Day" .. day])
	print("🎄 ────────────── 🎄")
end
