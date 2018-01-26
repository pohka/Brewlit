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
	
	Setup:TeamsDefault()
	SetTeams()
	
	GameStateManager:Setup(1 , DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP)
	
	GameRules:SetPostGameTime(5)
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

--boilerplate setup
--[[
function Setup:Custom()
	local GameMode = GameRules:GetGameModeEntity()
	
	--LOBBY OPTIONS AND GAMESTATES DURATION
	GameRules:SetCustomGameSetupAutoLaunchDelay(float seconds) 	--Set the amount of time to wait for auto launch.
	GameRules:SetCustomGameSetupRemainingTime(float seconds) 	--Set the amount of remaining time, in seconds, for custom game setup. 0 = finish immediately, -1 = wait forever
	GameRules:SetCustomGameSetupTimeout(float seconds) 			--Setup (pre-gameplay) phase timeout. 0 = instant, -1 = forever (until FinishCustomGameSetup is called)
	GameRules:SetHeroSelectionTime(float seconds) 				--Sets the amount of time players have to pick their hero.
	GameRules:SetPostGameTime(float seconds) 					--Sets the amount of time players have between the game ending and the server disconnecting them.
	GameRules:SetPreGameTime(float seconds) 					--Sets the amount of time players have between picking their hero and game start.
	GameRules:SetSameHeroSelectionEnabled(bool enabled) 		--When true, players can repeatedly pick the same hero.
	GameRules:SetShowcaseTime(float seconds)					--Set the duration of the 'radiant versus dire' showcase screen.						
	GameRules:SetStrategyTime(float seconds)					--Set the duration of the strategy phase.
	GameRules:SetCustomGameEndDelay(float seconds) 				--Sets the delay time until the game ends (optional)
	
	
	
	--TEAM SETUP
	--set the number of teams and players per team
	Setup:TeamsCustom(int teamCount, int playersPerTeam)
	
	
	--alternativly you can indivdually set the number of players on each team usingthe Setup.teamTable
	local teamNum = DOTA_TEAM_GOODGUYS 
	local numOfPlayers = 5
	Setup.teamTable[teamNum] = {
		players = numOfPlayers
	}
	teamNum = DOTA_TEAM_BADDGUYS 
	numOfPlayers = 3
	Setup.teamTable[teamNum] = {
		players = numOfPlayers
	}
	SetTeams()
	
	
	--GAMEMODE OPTIONS (OPTIONAL)
	GameMode:SetAnnouncerDisabled(bool disabled)				--Are in-game announcers disabled?
	GameMode:SetKillingSpreeAnnouncerDisabled(bool disabled)	--Mutes the in-game killing spree announcer.
	GameMode:SetDaynightCycleDisabled(bool disabled)			--Enable or disable the day/night cycle.
	GameMode:DisableHudFlip(bool disabled)						--Disables the minimap on right option, this is important when making a custom HUD
	GameMode:SetDeathOverlayDisabled(bool disabled)				--Specify whether the full screen death overlay effect plays when the selected hero dies.
	GameMode:SetWeatherEffectsDisabled(bool disabled)			--Set if weather effects are disabled.
	Setup:DisableMusicEvents()									--Disables some music events
	
	
	--MORE (OPTIONAL)
	GameRules:SetUseUniversalShopMode(bool enabled)				--When true, all items from main shop are available at as long as any shop is in range.
	GameMode:SetFixedRespawnTime(int seconds)					--Sets a fixed respawn time
	GameRules:SetStartingGold(int gold)							--Set the starting gold amount.
	GameRules:SetRuneSpawnTime(float seconds)					--Set the time between rune spawn times
	GameRules:SetTreeRegrowTime(float seconds)					--Sets the tree regrow time
	
	
	--OTHER
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:ResetToHeroSelection() --	Restart the game at hero selection
	GameRules:IsHeroRespawnEnabled()
	GameRules:SetHeroRespawnEnabled()
end
]]

--2 teams of 5 players
function Setup:TeamsDefault()
	Setup:TeamsCustom(2, 5)
end

--set the number of teams and the number of players per team
function Setup:TeamsCustom(teamCount, playersPerTeam)
	for i = 2, 1+teamCount do
		Setup.teamTable[i] = {}
		Setup.teamTable[i]["players"] = playersPerTeam
	end
	SetTeams()
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

--sets the passive gold which players get
function Setup:SetPassiveGold(goldPerTick, tickTime)
	GameRules:SetGoldPerTick(goldPerTick)
	GameRules:SetGoldTickTime(tickTime)
end

