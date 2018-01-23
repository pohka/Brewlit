--[[
==================================================================================
 All of the built-in engine events that are currently working
==================================================================================

Note: passing a parameter for tbl will override the default table returned to the callback function
]]

if Event == nil then
	Event = class ({})
end

--------------------------------------
-- Player events
--------------------------------------

--[[
When a player uses buyback
Table:
 * entindex (int) : index of the entity which bough back
 * player_id (int) : the id of the player of the server
]]
function Event:BuyBack(func, tbl)
	ListenToGameEvent("dota_buyback", func, tbl)
end

--[[
When a player begins to cast an ability (Note: the player can cancel the ability before it's used)
Table:
 * abilityname (string) : name of the ability e.g. pudge_rot
 * PlayerID (short) : the id of the player
]]
function Event:PlayerAbilityCast(func, tbl)
	ListenToGameEvent("dota_player_begin_cast", func, tbl)
end

--[[
When a player uses an ability (also listens to items)
Table:
 * caster_entindex (short) : entity index of the caster
 * abilityname (string) : name of the ability used e.g. pudge_rot
 * PlayerID (short) : the id of the player who owns the caster
]]
function Event:PlayerAbilityUsed(func, tbl)
	ListenToGameEvent("dota_player_used_ability", func, tbl)
end

--[[
When a player learns an ability (also listens to talents)
Table:
 * PlayerID	(short) : id of the player
 * player (short) : index of the player
 * abilityname (string) : name of the ability e.g. pudge_rot
]]
function Event:PlayerAbilityLearned(func, tbl)
	ListenToGameEvent("dota_player_learned_ability", func, tbl)
end

--[[
When a player levels up
Table:
 * PlayerID (short) : id of the player who leveled up
 * level (short) : The level of the player after they leveled up
]]
function Event:PlayerLevelUp(func, tbl)
	ListenToGameEvent("dota_player_gained_level", func, tbl)
end

--[[
Player changes team (in lobby screen or in game)
Table:
 * userid (short) : user ID on server
 * team (byte) : team id
 * oldteam (byte) : old team id
 * disconnect (bool): team change because player disconnects
 * autoteam (bool) : true if the player was auto assigned to the team
 * silent (bool) : if true wont print the team join messages
 * isbot (bool) : zero if is real player, 1 is player is a bot
]]
function Event:PlayerChangeTeam(func, tbl)
	ListenToGameEvent("player_team", func, tbl)
end

--[[
When a player is killed
Table:
 * TowerKill (bool) : returns 1 if killed by a tower
 * HeroKill	(bool) : returns 1 if killed by a hero
 * PlayerID	(short) : id of the player killed
]]
function Event:PlayerKilled(func, tbl)
	ListenToGameEvent("dota_player_killed", func, tbl)
end

--[[
A player reconnected to the game
Table:	 
 * event (local) : the data include the realitive infomation
]]
function Event:PlayerReconnected(func, tbl)
	ListenToGameEvent("player_reconnected", func, tbl)
end

--[[
Player spawned in game (to listen to respawning use Event:Spawned)
Table:
 * userid (short) : user ID on server
 * entindex (long) : entity index of the player
]]
function Event:PlayerSpawned(func, tbl)
	ListenToGameEvent("player_spawn", func, tbl)
end



--------------------------------------
-- Unit events
--------------------------------------
--[[
When a unit is damaged
Table:
 * entindex_killed (long) : entity index of the killer
 * entindex_attacker (long) : entity index of the killer
 * entindex_inflictor (long) : entity index of the ability used, will be void if not killed by an ability
 * damagebits (long) : flag for the damage look at DOTADamageFlag_t, it will be zero most of the time
]]
function Event:Damaged(func, tbl)
	ListenToGameEvent("entity_hurt", func, tbl)
end


--[[
When a unit is killed
Table:
 * entindex_killed(long) : entity index of the killer
 * entindex_attacker (long) : entity index of the killer
 * entindex_inflictor (long) : entity index of the ability used, will be void if not killed by an ability
 * damagebits (long) : flag for the damage look at DOTADamageFlag_t, it will be zero most of the time
]]
function Event:Killed(func, tbl)
	ListenToGameEvent("entity_killed", func, tbl)
end

--[[
When a player gets a last hit on a unit
Table:
 * PlayerID	(short) : id of the player who got the last hit
 * EntKilled (short) : entity index of the unit killed
 * FirstBlood (bool) : returns 1 if first blood otherwise it is 0
 * HeroKill	(bool) : returns 1 if the unit killed was a hero
 * TowerKill (bool) : returns 1 if the unit killed was a tower
]]
function Event:LastHit(func, tbl)
	ListenToGameEvent("last_hit", func, tbl)
end

--[[
When a unit is spawned
Table:
  * entindex (long): entity index of the unit spawned
]]
function Event:Spawned(func, tbl)
	ListenToGameEvent("npc_spawned", func, tbl)
end

--[[
When a tower is killed
Table:
 * killer_userid (short) : the user id of the killer
 * teamnumber (short) : the team number of the tower owners
 * gold (short) : amount of gold rewarded for the tower
]]
function Event:TowerKilled(func, tbl)
	ListenToGameEvent("dota_tower_kill", func, tbl)
end




--------------------------------------
-- Item events
--------------------------------------

--[[
When items are combined to make a new item
Table:
 * itemcost (long) : cost of the new item
 * itemname (string) : name of the new item e.g. item_pers
 * PlayerID (short) : id of the player
]]
function Event:ItemCombined(func, tbl)
	ListenToGameEvent("dota_item_combined", func, tbl)
end

--[[
When an item is purchased
Table:
 * itemcost (long) : cost of the item 
 * itemname (short) : name of the item e.g. item_bottle
 * PlayerID (short) : id of the player who bought the item
]]
function Event:ItemPurchased(func, tbl)
	ListenToGameEvent("dota_item_purchased", func, tbl)
end

--[[
When an item is picked up of the ground
Table:
 * itemname	(string) : name of the item e.g. item_gem
 * PlayerID	(short) : id of the player who picked up the item
 * ItemEntityIndex	(short)	 : entity index of the item picked up
 * HeroEntityIndex	(short) : enity index of the hero

]]
function Event:ItemPickedUp(func, tbl)
	ListenToGameEvent("dota_item_picked_up", func, tbl)
end


--------------------------------------
-- Other events
--------------------------------------

--[[
An in-game chat msg was sent
Table:
 * teamonly (bool) : true if team only chat
 * userid (short) : chatting player
 * playerid (short) : id of the player
 * text (string) : chat text
]]
function Event:Chat(func, tbl)
	ListenToGameEvent("player_chat", func, tbl)
end


--[[
When a unit finished channelling an ability (also listens to items like meteor hammer)
Table:
 * abilityname (string) : name of the ability e.g. pudge_rot
 * interrupted (bool) : returns 1 if the channeling was interrupted
]]
function Event:ChannelFinished(func, tbl)
	ListenToGameEvent("dota_ability_channel_finished", func, tbl)
end

--[[
When a non player unit started casting an ability
Table:
 * abilityname (string) : name of the ability e.g. pudge_rot
]]
function Event:NonPlayerBeginCast(func, tbl)
	ListenToGameEvent("dota_non_player_begin_cast", func, tbl)
end

--[[
When a tree is cut down
Table:
 * tree_x (float) : x coordinates
 * tree_y (float) : y coordinates
]]
function Event:TreeCut(func, tbl)
	ListenToGameEvent("tree_cut", func, tbl)
end












