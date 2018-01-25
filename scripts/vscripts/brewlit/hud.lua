

if HUD == nil then
	HUD = class ({})
end

--logs a message in the chat for all teams
--msg is a html string
function HUD:SendChatMsg(msg)
	GameRules:SendCustomMessage(msg, 2, 1)
end