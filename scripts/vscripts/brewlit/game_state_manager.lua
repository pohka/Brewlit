--managing changes in the game state
if GameStateManager == nil then
	GameStateManager = class ({})
end

--called when the game state changes
function GameStateManager:OnChangeState(ctx)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		GameStateManager:AllRandomHero()
	end
end

--random a hero for every player who hasn't picked
--must be called in the Dhero selection state
function GameStateManager:AllRandomHero()
	local maxTeam = table.getn(Setup.TeamTable) + 1
	for teamNum = 2, maxTeam do
		local maxPlayers = Setup.TeamTable[teamNum-1]["players"]
		for i=1, maxPlayers do
			local playerID = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
			if playerID ~= nil then
				if PlayerResource:HasSelectedHero(playerID) == false then
					local hPlayer = PlayerResource:GetPlayer(playerID)
					if hPlayer ~= nil then
						hPlayer:MakeRandomHeroSelection()
					end
				end
			end
		end
	end
end