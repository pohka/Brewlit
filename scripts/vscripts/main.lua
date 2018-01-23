
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
	--Event:PlayerSpawned(test)
	Event:ItemPickedUp(test)
	Event:Chat(test)
	--Event:Buyback(test)
	--GameRules:SetGameWinner(2)
	--GameRules:SetHeroSelectionTime(5)
end

function test(event)
	print("Event:")
	if event ~=nil then
		printTable(event)
	end
end

function test2(event)
	table.foreach(event, print)
end

--prints the key and the type of each variable in the table
function printTable(tbl)
	table.foreach(tbl, 
	function(k,v)
		local vType
		
		if type(v) == "table" then
			vType = v:GetClassname()
		else
			vType = type(v)
		end
		
		print(k .. ": " .. vType)
	end)
end