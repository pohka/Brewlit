--This class is for setting the rules and the game mode
if Setup == nil then
	Setup = class ({})
end

--table for the number of players on each team
_G.Setup.TeamTable = {}

--[[
A quick setup of the game mode and sets 2 teams of 5 players
---
This is useful when testing or prototyping

It will use most of the default dota startup when posted on the workshop but for these exceptions:
- disables announcer
- always day time
- disables the showcase screen

]]
function Setup:Quick(ctx)
	print("Setup:Quick()")
	
	if IsInToolsMode() and debugging then
		GameRules:EnableCustomGameSetupAutoLaunch(true)
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)
		GameRules:SetHeroSelectionTime(0)
		GameRules:SetStrategyTime(0)
		
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay(60)
	end
	
	GameRules:SetPreGameTime(0)
	
	for i = 1, 2 do
		Setup.TeamTable[i] = {}
		Setup.TeamTable[i]["players"] = 5
	end
	
	Setup:SetTeams()
	
	GameStateManager:Setup(1 , DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP)
	
	GameRules:SetPostGameTime(30)
	GameRules:SetShowcaseTime(0)
	
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetAnnouncerDisabled(true)
	--GameMode:SetDaynightCycleDisabled(true)
end

--2 teams of 5 players
function Setup:DefaultTeams()
	for i = 1, 2 do
		Setup.TeamTable[i] = {}
		Setup.TeamTable[i]["players"] = 5
	end
end

--sets the teams based off the Setup.TeamTable
function Setup:SetTeams()
	local maxTeam = table.getn(Setup.TeamTable) + 1
	for teamNum = 2, maxTeam do
		local players = Setup.TeamTable[teamNum-1]["players"]
		GameRules:SetCustomGameTeamMaxPlayers(teamNum, players)
	end
end