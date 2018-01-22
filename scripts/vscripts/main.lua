
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
	Event:OnPlayerSpawn(test)
	--GameRules:SetHeroSelectionTime(5)
end

function test(val)
	print("EVENT: OnTeamScore")
	if val ~=nil then
		--print(val["key1"])
		print("table:")
		table.foreach(val, print)
	end
end