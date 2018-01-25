--managing changes in the game state
if GameStateManager == nil then
	GameStateManager = class ({})
end

settings = {
	updateRate = 1,
	randomAfterState = DOTA_GAMERULES_STATE_HERO_SELECTION
}

function GameStateManager:Init()
	local GameMode = GameRules:GetGameModeEntity()
	local updateRate = 
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
Brewlit:OnCustomGameSetup()
Brewlit:OnHeroSelection()
Brewlit:OnStrategyTime()
Brewlit:OnTeamShowcase()
Brewlit:OnPreGame()
Brewlit:OnInProgress()
Brewlit:OnPostGame()
Brewlit:OnGameDisconnect()
]]
function BroadcastStateChange(curState)
	if curState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP and Brewlit.OnCustomGameSetup ~= nil then
		Brewlit:OnCustomGameSetup()
		
	elseif curState == DOTA_GAMERULES_STATE_PRE_GAME and Brewlit.OnHeroSelection ~= nil then
		Brewlit:OnHeroSelection()
		
	elseif curState == DOTA_GAMERULES_STATE_STRATEGY_TIME and Brewlit.OnStrategyTime ~= nil then
		Brewlit:OnStrategyTime()
		
	elseif curState == DOTA_GAMERULES_STATE_TEAM_SHOWCASE and Brewlit.OnTeamShowcase ~= nil then
		Brewlit:OnTeamShowcase()
		
	elseif curState == DOTA_GAMERULES_STATE_PRE_GAME and Brewlit.OnPreGame ~= nil then
		Brewlit:OnPreGame()
		
	elseif curState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and Brewlit.OnInProgress ~= nil then
		Brewlit:OnInProgress()
		
	elseif curState == DOTA_GAMERULES_STATE_POST_GAME and Brewlit.OnPostGame ~= nil then
		Brewlit:OnPostGame()
		
	elseif curState == DOTA_GAMERULES_STATE_DISCONNECT and Brewlit.OnGameDisconnect ~= nil then
		Brewlit:OnGameDisconnect()
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

