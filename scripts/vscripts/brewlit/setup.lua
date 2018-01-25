--This class is for setting the rules and the game mode
if Setup == nil then
	Setup = class ({})
end

--table for the number of players on each team
Setup.teamTable = {}

--[[
A quick setup of the game mode and sets 2 teams of 5 players
---
This is essential when testing or prototyping

- disables announcer
- disables day/night cycle
- disables

]]
function Setup:Quick(ctx)
	print("Setup:Quick()")
	
	if IsInToolsMode() and debugging then
		GameRules:EnableCustomGameSetupAutoLaunch(true)
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)
		GameRules:SetHeroSelectionTime(0)
		
	else
		GameRules:SetCustomGameSetupAutoLaunchDelay(60)
	end
	
	GameRules:SetStrategyTime(0)
	GameRules:SetSameHeroSelectionEnabled(true)
	GameRules:SetPreGameTime(0)
	
	Setup:DefaultTeams()
	SetTeams()
	
	GameStateManager:Setup(1 , DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP)
	
	GameRules:SetPostGameTime(30)
	GameRules:SetShowcaseTime(0)
	
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetAnnouncerDisabled(true)
	GameMode:SetKillingSpreeAnnouncerDisabled(true)
	GameMode:SetDaynightCycleDisabled(true)
	GameMode:DisableHudFlip(true)
	GameMode:SetDeathOverlayDisabled(true)
	GameMode:SetFixedRespawnTime(5)
	GameMode:SetWeatherEffectsDisabled(true)
	
	Setup:DisableMusicEvents()
end

--2 teams of 5 players
function Setup:DefaultTeams()
	for i = 2, 3 do
		Setup.teamTable[i] = {}
		Setup.teamTable[i]["players"] = 5
	end
end

--sets the teams based off the teamTable
function SetTeams()
	table.foreach(Setup.teamTable, function(teamNum, teamInfo)
		GameRules:SetCustomGameTeamMaxPlayers(teamNum, teamInfo.players)
	end)
end

--[[
Disables some music events:
 * Hero pick music
 * Music at the start of the game
 * Battle music
 
Note: this doesn't disable music
]]
function Setup:DisableMusicEvents()
	GameRules:SetCustomGameAllowHeroPickMusic(false)
	GameRules:SetCustomGameAllowMusicAtGameStart(false)
	GameRules:SetCustomGameAllowBattleMusic(false)
end

--random a hero for every player who hasn't picked
--must be called in the hero selection state or strategy state
function Setup:AllRandomHero()

	--set teams if the have not been set
	if table.getn(Setup.teamTable) == 0 then
		Setup:DefaultTeams()
	end
	
	--loop through each player on every team and random a hero if they haven't picked
	table.foreach(Setup.teamTable, function(teamNum, teamInfo)
		for i=1, teamInfo.players do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
			if playerID ~= nil then
				if not PlayerResource:HasSelectedHero(playerID) then
					local hPlayer = PlayerResource:GetPlayer(playerID)
					if hPlayer ~= nil then
						hPlayer:MakeRandomHeroSelection()
					end
				end
			end
		end
	end)
end

function Setup:GetTeamNumbers()
	local tbl = {}
	
end