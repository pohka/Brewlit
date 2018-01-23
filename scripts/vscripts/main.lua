
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
	Event:Ontest(test)
	--GameRules:SetGameWinner(2)
	--GameRules:SetHeroSelectionTime(5)
end

function test(val)
	print("EVENT:")
	if val ~=nil then
		--print(val["key1"])
		print("table:")
		table.foreach(val, print)
	end
	--local id = val.entindex_inflictor;
	--hScript = EntIndexToHScript(id)
	--print(hScript:GetName())
end