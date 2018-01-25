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
	if GameRules:State_Get() > settings.randomAfterState then
		Setup:AllRandomHero()
	end
end

