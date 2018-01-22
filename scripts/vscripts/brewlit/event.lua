
if Event == nil then
	Event = class ({})
end

--passing a parameter for tbl will override the default table returned to the callback function

--------------------------------------
-- Player events
--------------------------------------

--[[
player spawned in game
Table:
 * userid ( short ): user ID on server
 * entindex : entity ID of the player
]]
function Event:OnPlayerSpawn(func, tbl)
	ListenToGameEvent("player_spawn", func, tbl)
end

--[[
player changes team (in lobby screen or in game)
Table:
 * userid ( short ): user ID on server
 * team ( byte ): team id
 * oldteam( byte ): old team id
 * disconnect( bool ): team change because player disconnects
 * autoteam( bool ): true if the player was auto assigned to the team
 * silent( bool ): if true wont print the team join messages
 * isbot (bool) : 0 if is real player
]]
function Event:OnPlayerChangeTeam(func, tbl)
	ListenToGameEvent("player_team", func, tbl)
end

--[[
a public player chat
Table:
 * teamonly ( bool ): true if team only chat
 * userid( short ): chatting player
 * playerid( playerid ): id of the player
 * text( string ): chat text
]]
function Event:OnChat(func, tbl)
	ListenToGameEvent("player_chat", func, tbl)
end

--[[
the player reconnet to the game
Table:	 
 * event(local):the data include the realitive infomation
]]
function Event:OnPlayerReconnect(func, tbl)
	ListenToGameEvent("player_reconnected", func, tbl)
end













