--[[
==================================================================================
 All of the built-in engine events that are currently working
==================================================================================

Note: passing a parameter for tbl will override the table returned to the callback function
]]

--------------------------------------
-- Player events
--------------------------------------

--[[
When a player uses buyback
Table:
 * entindex (int) : index of the entity which bought back
 * player_id (int) : the id of the player of the server
]]
function Event:OnBuyback(func, t)
	if t == nil then
		ListenToGameEvent("dota_buyback", 
		function(event)
			local tbl = {
				hero = EntIndexToHScript(event.entindex),
				player =  PlayerResource:GetPlayer(event.player_id)
			}
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_buyback", func(t), t)
	end
end

--[[
When a player begins to cast an ability (also listens to items Note: the player can cancel the ability before it's used)
Raw table:
 * abilityname (string) : name of the ability e.g. pudge_rot
 * PlayerID (short) : the id of the player
 
returns:
 * ability : CDOTABaseAbility - either an item or ability
 * player : CDOTAPlayer
]]
function Event:OnPlayerAbilityCast(func, t)
	if t == nil then
		ListenToGameEvent("dota_player_begin_cast", 
		function(event)
			local player = PlayerResource:GetPlayer(event.PlayerID)
			local tbl = {
				ability = PlayerHelper:GetAbilityByName(event.PlayerID, event.abilityname),
				player =  player,
				hero = player:GetAssignedHero()
			}
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_player_begin_cast", func(t), t)
	end
end

--[[
When a player uses an ability (also listens to items)
Table:
 * caster_entindex (short) : entity index of the caster
 * abilityname (string) : name of the ability used e.g. pudge_rot
 * PlayerID (short) : the id of the player who owns the caster
]]
function Event:OnPlayerAbilityUsed(func, t)
	if t == nil then
		ListenToGameEvent("dota_player_used_ability", 
		function(event)
			local player = PlayerResource:GetPlayer(event.PlayerID)
			local tbl = {
				caster = EntIndexToHScript(event.caster_entindex),
				ability = PlayerHelper:GetAbilityByName(event.PlayerID, event.abilityname),
				player =  player,
				hero = player:GetAssignedHero()
			}
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_player_used_ability", func(t), t)
	end
end

--[[
When a player learns an ability (also listens to talents)
Table:
 * PlayerID	(short) : id of the player
 * player (short) : index of the player on the server
 * abilityname (string) : name of the ability e.g. pudge_rot
]]
function Event:OnPlayerAbilityLearned(func, t)
	if t == nil then
		ListenToGameEvent("dota_player_learned_ability", 
		function(event)
			local player = PlayerResource:GetPlayer(event.PlayerID)
			local tbl = {
				playerIndex = event.player,
				ability = PlayerHelper:GetAbilityByName(event.PlayerID, event.abilityname),
				player =  player,
				hero = player:GetAssignedHero()
			}
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_player_learned_ability", func(t), t)
	end
end

--[[
When a player levels up
Table:
 * player (short) : index of the player on the server
 * level (short) : The level of the player after they leveled up
]]
function Event:OnPlayerLevelUp(func, t)
	if t == nil then
		ListenToGameEvent("dota_player_gained_level", 
		function(event)
			local tbl = {
				playerIndex = event.player,
				level = event.level
			}
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_player_gained_level", func(t), t)
	end
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
function Event:OnPlayerChangeTeam(func, t)
	if t == nil then
		ListenToGameEvent("player_team", 
		function(event)
			local tbl = {
				playerIndex = event.userid,
				team = event.team,
				teamName = GetTeamName(event.team),
				oldTeam = event.oldteam,
				oldTeamName = GetTeamName(event.oldteam),
				causedByDisconnect = event.disconnect,
				autoAssignedToTeam = event.autoteam,
				silent = event.silent,
				isBot = event.isbot
			}
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("player_team", func(t), t)
	end
end

--[[
When a player is killed
Table:
 * TowerKill (bool) : returns 1 if killed by a tower
 * HeroKill	(bool) : returns 1 if killed by a hero
 * PlayerID	(short) : id of the player killed
]]
function Event:OnPlayerKilled(func, tbl)
	if t == nil then
		ListenToGameEvent("dota_player_killed", 
		function(event)
			player = PlayerResource:GetPlayer(event.PlayerID)
			local tbl = {
				killedByTower = event.TowerKill,
				killedByHero = event.HeroKill,
				player = player,
				hero = player:GetAssignedHero()
			}
			CustomNetTables:SetTableValue( "debug", "log", { logType = "event", msg = "EVENT: Player Killed", t = GameTime:SinceStart() } )
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_player_killed", func(t), t)
	end
end

--[[
A player reconnected to the game (not sure if this works)
Table:	 
 * event (local) : the data include the realitive infomation
]]
function Event:OnPlayerReconnected(func, t)
	ListenToGameEvent("player_reconnected", func(t), t)
end

--[[
Player spawned in game (to listen to respawning use Event:OnSpawned)
Table:
 * userid (short) : user ID on server
 * entindex (long) : entity index of the player
]]
function Event:OnPlayerSpawned(func, t)
	if t == nil then
		ListenToGameEvent("player_spawn", 
		function(event)
			local tbl = {
				entity = EntIndexToHScript(event.entindex),
				playerIndex =  event.userid
			}
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("player_spawn", func(t), t)
	end
end



--------------------------------------
-- Unit events
--------------------------------------
--[[
When a unit is damaged by an ability
Table:
 * entindex_killed (long) : entity index of the killed
 * entindex_attacker (long) : entity index of the killer
 * entindex_inflictor (long) : entity index of the ability used, will be void if not killed by an ability
 * damagebits (long) : flag for the damage look at DOTADamageFlag_t, it will be zero most of the time
]]
function Event:OnUnitDamaged(func, t)
	if t == nil then
		ListenToGameEvent("entity_hurt", 
		function(event)
			local tbl = {
				unit = EntIndexToHScript(event.entindex_killed),
				attacker = EntIndexToHScript(event.entindex_attacker),
				damageFlag = event.damagebits
			}
			
			if event.entindex_inflictor then
				tbl["ability"] = EntIndexToHScript(event.entindex_inflictor)
			end
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("entity_hurt", func(t), t)
	end
end


--[[
When a unit is killed
Table:
 * entindex_killed(long) : entity index of the killer
 * entindex_attacker (long) : entity index of the killer
 * entindex_inflictor (long) : entity index of the ability used, will be void if not killed by an ability
 * damagebits (long) : flag for the damage look at DOTADamageFlag_t, it will be zero most of the time
]]
function Event:OnUnitKilled(func, t)
	if t == nil then
		ListenToGameEvent("entity_killed", 
		function(event)
			local tbl = {
				unit = EntIndexToHScript(event.entindex_killed),
				attacker = EntIndexToHScript(event.entindex_attacker),
				damageFlag = event.damagebits
			}
			
			if event.entindex_inflictor then
				tbl["ability"] = EntIndexToHScript(event.entindex_inflictor)
			end
			func(tbl)
		end, nil)
	else
		ListenToGameEvent("entity_killed", func(t), t)
	end
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
function Event:OnLastHit(func, tbl)
	ListenToGameEvent("last_hit", func, tbl)
end

--[[
When a unit is spawned
Table:
  * entindex (long): entity index of the unit spawned
]]
function Event:OnUnitSpawned(func, t)
	if t == nil then
		ListenToGameEvent("npc_spawned", 
		function(event)
			local tbl = {
				unit = EntIndexToHScript(event.entindex)
			}

			func(tbl)
		end, nil)
	else
		ListenToGameEvent("npc_spawned", func(t), t)
	end
end

--[[
When a tower is killed
Table:
 * killer_userid (short) : the user id of the killer
 * teamnumber (short) : the team number of the tower owners
 * gold (short) : amount of gold rewarded for the tower
]]
function Event:OnTowerKilled(func, t)
	if t == nil then
		ListenToGameEvent("dota_tower_kill", 
		function(event)
			local tbl = {
				playerIndex = event.killer_userid,
				team = event.teamnumber,
				teamName = GetTeamName(event.teamnumber),
				gold = event.gold
			}

			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_tower_kill", func(t), t)
	end
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
function Event:OnItemCombined(func, t)
	if t == nil then
		ListenToGameEvent("dota_item_combined", 
		function(event)
			local player = PlayerResource:GetPlayer(event.PlayerID)
			local tbl = {
				itemCost = event.itemcost,
				itemName = event.itemname,
				player = player,
				hero = player:GetAssignedHero()
			}

			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_item_combined", func(t), t)
	end
end

--[[
When an item is purchased
Table:
 * itemcost (long) : cost of the item 
 * itemname (short) : name of the item e.g. item_bottle
 * PlayerID (short) : id of the player who bought the item
]]
function Event:OnItemPurchased(func, t)
	if t == nil then
		ListenToGameEvent("dota_item_purchased", 
		function(event)
			local player = PlayerResource:GetPlayer(event.PlayerID)
			local tbl = {
				itemCost = event.itemcost,
				itemName = event.itemname,
				player = player,
				hero = player:GetAssignedHero()
			}

			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_item_purchased", func(t), t)
	end
end

--[[
When an item is picked up of the ground
Table:
 * itemname	(string) : name of the item e.g. item_gem
 * PlayerID	(short) : id of the player who picked up the item
 * ItemEntityIndex	(short)	 : entity index of the item picked up
 * HeroEntityIndex	(short) : enity index of the hero

]]
function Event:OnItemPickedUp(func, t)
	if t == nil then
		ListenToGameEvent("dota_item_picked_up", 
		function(event)
			local player = PlayerResource:GetPlayer(event.PlayerID)
			local tbl = {
				item = EntIndexToHScript(event.ItemEntityIndex),
				hero = EntIndexToHScript(event.HeroEntityIndex),
				player = player,
				hero = player:GetAssignedHero()
			}

			func(tbl)
		end, nil)
	else
		ListenToGameEvent("dota_item_picked_up", func(t), t)
	end
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
function Event:OnChat(func, t)
	if t == nil then
		ListenToGameEvent("player_chat", 
		function(event)
		local player = PlayerResource:GetPlayer(event.playerid)
			local tbl = {
				isTeamChat = event.teamonly,
				playerIndex = event.userid,
				text = event.text,
				player = player,
				hero = player:GetAssignedHero()
			}

			func(tbl)
		end, nil)
	else
		ListenToGameEvent("player_chat", func(t), t)
	end
end


--[[
When a unit finished channelling an ability (also listens to items like meteor hammer)
Table:
 * abilityname (string) : name of the ability e.g. pudge_rot
 * interrupted (bool) : returns 1 if the channeling was interrupted
]]
function Event:OnChannelFinished(func, t)
	ListenToGameEvent("dota_ability_channel_finished", func(t), t)
end

--[[
When a non player unit started casting an ability
Table:
 * abilityname (string) : name of the ability e.g. pudge_rot
]]
function Event:OnNonPlayerBeginCast(func, t)
	ListenToGameEvent("dota_non_player_begin_cast", func, t)
end

--[[
When a tree is cut down
Table:
 * tree_x (float) : x coordinates
 * tree_y (float) : y coordinates
]]
function Event:OnTreeCut(func, t)
	if t == nil then
		ListenToGameEvent("tree_cut", 
		function(event)
			local tbl = {
				treeX = event.tree_x,
				treeY = event.tree_y,
			}

			func(tbl)
		end, nil)
	else
		ListenToGameEvent("tree_cut", func(t), t)
	end
end
