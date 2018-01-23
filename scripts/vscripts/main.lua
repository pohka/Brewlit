
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
	--newCls()
end

--[[
function newCls()

	--time
	GameRules:GetGameTime() -- (bool IncludePregameTime, bool IncludeNegativeTime) Returns the actual DOTA in-game clock time.
	GameRules:IsGamePaused()
	GameRules:IsDaytime()
	GameRules:GetTimeOfDay()
	GameRules:SetTimeOfDay()
	GameRules:IsNightstalkerNight()
	
	
	
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