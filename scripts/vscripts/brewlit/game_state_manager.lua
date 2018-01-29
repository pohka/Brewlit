--managing changes in the game state
if GameStateManager == nil then
	_G.GameStateManager = class ({})
end

settings = {
	updateRate = 1,
	randomAfterState = DOTA_GAMERULES_STATE_HERO_SELECTION
}

function GameStateManager:Init()
	local GameMode = GameRules:GetGameModeEntity()
	GameMode:SetContextThink("Update", function() 
			Brewlit:Update() 
			return settings.updateRate 
		end, settings.updateRate)
end


function GameStateManager:Setup(updateRate, randomAfterState)
	if rate ~= nil then
		Setup["updateRate"] = rate
	end
	
	if randomAfterState ~= nil then
		settings["randomAfterState"] = randomAfterState
	end
end

--called when the game state changes
function GameStateManager:OnChangeState()
	local curState = GameRules:State_Get()
	if curState > settings.randomAfterState then
		Setup:AllRandomHero()
	end
	
	BroadcastStateChange(curState)
end

--[[
calls the listener function for the current state if it exists

Listener functions:
GameState:OnStateCustomGameSetup()
GameState:OnStateHeroSelection()
GameState:OnStateStrategyTime()
GameState:OnStateTeamShowcase()
GameState:OnStatePreGame()
GameState:OnStateInProgress()
GameState:OnStatePostGame()
GameState:OnStateGameDisconnect()
]]
function BroadcastStateChange(curState)

	if curState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP and GameState.OnStateCustomGameSetup ~= nil then
		GameState:OnStateCustomGameSetup()
		
	elseif curState == DOTA_GAMERULES_STATE_PRE_GAME and GameState.OnStateHeroSelection ~= nil then
		GameState:OnStateHeroSelection()
		
	elseif curState == DOTA_GAMERULES_STATE_STRATEGY_TIME and GameState.OnStateStrategyTime ~= nil then
		GameState:OnStateStrategyTime()
		
	elseif curState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE and GameState.OnStateTeamShowcase ~= nil then
		GameState:OnStateTeamShowcase()
		
	elseif curState == DOTA_GAMERULES_STATE_PRE_GAME and GameState.OnStatePreGame ~= nil then
		GameState:OnStatePreGame()
		
	elseif curState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and GameState.OnStateInProgress ~= nil then
		GameState:OnStateInProgress()
		
	elseif curState == DOTA_GAMERULES_STATE_POST_GAME and GameState.OnStatePostGame ~= nil then
		GameState:OnStatePostGame()
		
	elseif curState == DOTA_GAMERULES_STATE_DISCONNECT and GameState.OnStateGameDisconnect ~= nil then
		GameState:OnStateGameDisconnect()
	end
end

--[[
Returns number from 0-9 based on the current state

INIT						0
WAIT_FOR_PLAYERS_TO_LOAD	1
CUSTOM_GAME_SETUP			2
HERO_SELECTION				3
STATE_STRATEGY_TIME			4
TEAM_SHOWCASE				5
PRE_GAME					6
GAME_IN_PROGRESS			7
POST_GAME					8
DISCONNECT					9
]]
function GameStateManager:GetCurrentState()
	return GameRules:State_Get()
end

--sets the team winner and victory message
function GameStateManager:SetVictory(msg, teamNum)
	if GameRules:State_Get() < DOTA_GAMERULES_STATE_POST_GAME then
		GameRules:SetCustomVictoryMessage(msg)
		GameRules:SetGameWinner(2)
	end
end

