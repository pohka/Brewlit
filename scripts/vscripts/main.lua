
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
	GameRules:SetRuneSpawnTime(10)
	SetPassiveGold(100, 3)
	
end

--called once every second
function Brewlit:Update()
	--local heroes = Query:GetTrees()
	--Helper:PrintTable(heroes)
	HUD:MessageAll("hello World")
	--GameStateManager:SetVictory("DansGame", 2)
	--GameRules:SetGameWinner(2)
end





--you can listen to particular state changes using listener functions called from GameStateManager
function Event:OnStateInProgress()
	print("game started")
end

function MinimapEventTest()
	local heroes = Query:GetHeroes()
	if heroes[0] ~= nil then
		local pos = heroes[0]:GetAbsOrigin()
		MinimapEvent(2, heroes[0], pos.x, pos.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 1) --pings the map
		--MinimapEvent(2, heroes[0], pos.x, pos.y, DOTA_MINIMAP_EVENT_RADAR, 1) -- green radar on minimap
		--MinimapEvent(2, heroes[0], pos.x, pos.y, DOTA_MINIMAP_EVENT_RADAR_TARGET, 1) -- red radar on minimap
	end
end

function SetPassiveGold(goldPerTick, tickTime)
	GameRules:SetGoldPerTick(goldPerTick)
	GameRules:SetGoldTickTime(tickTime)
end

--[[
function newCls()
	
	--rules for picking and respawning of heroes
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:ResetToHeroSelection() --	Restart the game at hero selection
	GameRules:IsHeroRespawnEnabled()
	GameRules:SetHeroRespawnEnabled()
	
	
	--passive rules
	GameRules:SetRuneSpawnTime()
	GameRules:SetTreeRegrowTime()
	
	
	
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
	GameRules:SetStrategyTime()
	GameRules:SetStartingGold()
	
	
	GameRules:SetUseBaseGoldBountyOnHeroes()
	GameRules:SetUseCustomHeroXPValues()
	GameRules:SetUseUniversalShopMode()
	GameRules:State_Get()
	
	
end
]]

