

if HUD == nil then
	HUD = class ({})
end

--logs a message in the chat for all teams
--str is a html string
function HUD:MessageAll(str)
	for teamNum,teamInfo in pairs(Setup.teamTable) do
		GameRules:SendCustomMessage(str, teamNum, 0)
	end
end

--logs a message in the chat for the team
--str is a html string
function HUD:MessageTeam(str, teamNum)
	GameRules:SendCustomMessage(str, teamNum, 0)
end