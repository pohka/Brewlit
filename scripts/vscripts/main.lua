
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
	--printTable(Setup)
	--Event:PlayerSpawned(test)
	--Event:ItemPickedUp(test)
	--Event:Chat(test)
	--Event:Buyback(test)
	--GameRules:SetGameWinner(2)
	--GameRules:SetHeroSelectionTime(5)
	--newCls()
	
end

function Brewlit:Update()
	print("time:" .. GameRules:GetTimeOfDay())
	--print("time:" .. Time:OfDay())
	--GameTime:SetDayTime(0.5)
	print("Items Dropped:")
	
	--[[
	local items = ItemManager:GetDroppedItems()
	table.foreach(items, function(k,v)
		print(v:GetContainedItem():GetOwner())
	end)
	]]
	
	local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                              Vector(0, 0, 0),
                              nil,
                              FIND_UNITS_EVERYWHERE,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
 
	-- Make the found units move to (0, 0, 0)
	for _,unit in pairs(units) do
	   local dropped = ItemManager:GetDroppedItemsForHero(unit)
	   printTable(dropped)
	   if dropped[0] ~= nil then
			print("picking up")
			ItemManager:PickUpItem(unit, dropped[0])
	   end
	end
	
	
end

--[[
function newCls()
	
	--rules for picking and respawning of heroes
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:ResetToHeroSelection() --	Restart the game at hero selection
	GameRules:IsHeroRespawnEnabled()
	GameRules:SetHeroRespawnEnabled()
	
	
	--passive rules
	GameRules:SetGoldPerTick()
	GameRules:SetGoldTickTime()
	GameRules:SetRuneSpawnTime()
	GameRules:SetTreeRegrowTime()
	
	
	--items
	GameRules:NumDroppedItems()
	GameRules:GetDroppedItem()
	
	
	--host UI for managing players
	GameRules:PlayerHasCustomGameHostPrivileges(handle) -- Whether a player has custom game host privileges (shuffle teams, etc.)
	
	--overlays for kills
	GameRules:SetFirstBloodActive()
	GameRules:SetHideKillMessageHeaders()
	GameRules:SetOverlayHealthBarUnit()
	
	
	
	--for debugging
	GameRules:Playtesting_UpdateAddOnKeyValues() --	Updates custom hero, unit and ability KeyValues in memory with the latest values from disk
	
	
	--messages
	GameRules:SendCustomMessage()
	GameRules:SendCustomMessageToTeam()
	GameRules:SetCustomVictoryMessage()
	GameRules:SetCustomVictoryMessageDuration()
	

	--music
	GameRules:SetCustomGameAllowHeroPickMusic()
	GameRules:SetCustomGameAllowMusicAtGameStart()
	GameRules:SetCustomGameAllowBattleMusic()
	
	--end condition
	GameRules:SetGameWinner()
	
	--lobby/setup at the start
	GameRules:SetCustomGameEndDelay()
	GameRules:SetCustomGameSetupAutoLaunchDelay()
	GameRules:SetCustomGameSetupRemainingTime()
	GameRules:SetCustomGameSetupTimeout()
	GameRules:SetCustomGameTeamMaxPlayers()
	GameRules:SetHeroSelectionTime()
	GameRules:SetPostGameTime()
	GameRules:SetPreGameTime()
	GameRules:SetSameHeroSelectionEnabled()
	GameRules:SetShowcaseTime()
	GameRules:SetStartingGold()
	GameRules:SetStrategyTime()
	GameRules:SetUseBaseGoldBountyOnHeroes()
	GameRules:SetUseCustomHeroXPValues()
	GameRules:SetUseUniversalShopMode()
	GameRules:State_Get()
	
	
end
]]

function test(event)
	print("Event:")
	if event ~= nil then
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