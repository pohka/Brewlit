
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
end

--called once every second
function Brewlit:Update()
	--local heroes = Query:GetTrees()
	--Helper:PrintTable(heroes)
end

--you can listen to particular state changes using listener functions called from GameStateManager
function Brewlit:OnInProgress()
	print("game started")
end

--[[
function newCls()
	
	--rules for picking and respawning of heroes
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:ResetToHeroSelection() --	Restart the game at hero selection
	GameRules:IsHeroRespawnEnabled()
	GameRules:SetHeroRespawnEnabled()
	
	
	--passive rules
	GameRules:SetStartingGold()
	GameRules:SetGoldPerTick()
	GameRules:SetGoldTickTime()
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
	
	
	GameRules:SetUseBaseGoldBountyOnHeroes()
	GameRules:SetUseCustomHeroXPValues()
	GameRules:SetUseUniversalShopMode()
	GameRules:State_Get()
	
	
end
]]

