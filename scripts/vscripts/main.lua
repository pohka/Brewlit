
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
end

function Brewlit:Update()
	--local heroes = Helper:GetAllHeroes()
	--Helper:PrintTable(heroes)
	Helper:ForEachHero(
		function(hero, tbl) 
			print("hero: " .. hero:GetName() .. " - " .. tbl) 
		end, GameTime:SinceStart())
end
	--print("time:" .. GameRules:GetTimeOfDay())
	--print("time:" .. Time:OfDay())
	--GameTime:SetDayTime(0.5)
	--print("Items Dropped:")
	--[[
	local items = ItemManager:GetDroppedItems()
	table.foreach(items, function(k,v)
		print(v:GetContainedItem():GetOwner())
	end)
	
	
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
		unit
	end
	
	]]


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

