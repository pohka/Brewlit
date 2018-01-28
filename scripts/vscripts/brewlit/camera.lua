--[[
	Known problems with this camera
	-----------------------------------
	* Does not work with height on the map
	* The camera transform is limited near the top section of map
	* The camera dips lower the futher you move away from the spawn point
]]

if Camera == nil then
	Camera = class ({})
end

--table of all the current camera targets
currentTargets = {}

--locks the camera for each player to follow their hero
function Camera:LockAllCamerasToHero()
	local players = Helper:GetAllPlayers()
	for i,player in pairs(players) do
		local target = player:GetAssignedHero()
		local playerID = player:GetPlayerID()
		if target ~= nil then
			PlayerResource:SetCameraTarget(playerID, target)
			currentTargets[playerID] = target
		end
	end
end

--unlocks the camera from following an entity
function Camera:UnlockAllCameras()
	local players = Helper:GetAllPlayers()
	for i,player in pairs(players) do
		local playerID = player:GetPlayerID()
		PlayerResource:SetCameraTarget(playerID, nil)
		currentTargets[playerID] = nil
	end
end

--returns true if every player has a camera target
function Camera:AllPlayersHaveTarget()
	local playerIDs = Helper:GetAllPlayerIDs()
	for i,playerID in pairs(playerIDs) do
		if currentTargets[playerID] == nil then
			return false
		end
	end
	return true
end

--focuses the players camera onto their hero when they respawn
function Camera:FocusHeroOnRespawn()
	Event:OnUnitSpawned(
		function(event) 
			if  event.unit:IsHero() then
				local playerID = event.unit:GetPlayerOwnerID()
				Camera:LockPlayerCameraToHero(playerID)
				
				--delay unlock camera
				Task:Delay(function(tbl) 
					Camera:UnlockPlayerCamera(tbl.playerID)
				end, 0.1, {playerID = playerID})
			end
		end)
end


--locks a player camera to their hero
function Camera:LockPlayerCameraToHero(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	if hero ~= nil then
		PlayerResource:SetCameraTarget(playerID, hero)
		currentTargets[playerID] = hero
	end
end


--unlocks a players camera from following an entity
function Camera:UnlockPlayerCamera(playerID)
	if playerID ~= nil then
		PlayerResource:SetCameraTarget(playerID, nil)
		currentTargets[playerID] = nil
	end
end

function Camera:SetRotation()
	local keyName = "test"
	local yaw = 20
	CustomNetTables:SetTableValue("camera", keyName, { yaw = yaw })
end


--returns a table of all the current camera targets for each player
--the keys to the table is the players id
--if the target is nil then the camera is not following any entity
function Camera:GetCurrentTargets()
	return currentTargets
end
