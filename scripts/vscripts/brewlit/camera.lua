--[[
	Known problems with this camera
	-----------------------------------
	* Does not work with height on the map
	* The camera transform is limited near the top section of map
	* The camera dips lower the futher you move away from the spawn point
]]

LinkLuaModifier("dummy_modifier", "ability/dummy_modifier.lua", LUA_MODIFIER_MOTION_NONE)

if Camera == nil then
	Camera = class ({})
end

--table of all the current camera targets
currentTargets = {}

cameraDummies = {}
local globalCameraDummy

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

--sets the same camera type for all players
function Camera:SetCameraTypeAllPlayers(camType)
	local players = Helper:GetAllPlayerIDs()
	for _,playerID in pairs(players) do
		Camera:SetCameraType(playerID, camType)
	end
end

--[[
set the camera to one of the presets

presets:
 -top				top down view
 -front				front view
 -third_person      3rd person
 -third_person_alt  alternative version to 3rd person which is higher
 -default			default dota camera
 -inverted			rotate the camera around 180 degrees
 -right				view from the right side
 -left				view from the left side
]]
function Camera:SetCameraType(playerID, camType)
	CustomNetTables:SetTableValue("camera_type", ""..playerID, { camType = camType })
end

--[[
sets the values for the camera, if a value is nil this function won't change the value on the camera

--yaw is the rotation of the camera around the world up axis
--zoom is the distance of the camera from focus point
--height is the offset height of the camera
--pitch is the rotation of the camera along the y-axis
]]
function Camera:UpdateSettings(playerID, yaw, zoom, height, pitch)
	CustomNetTables:SetTableValue("camera", ""..playerID, { yaw = yaw, zoom = zoom, height = height, pitch = pitch })
end


--returns a table of all the current camera target positions for each player
--the keys to the table is the players id
--if the target is nil then the camera is not locked to any entity
--not the z-axis of the target is not the same as the camera height
function Camera:GetCurrentTargets()
	local tbl = {}
	for playerID,target in pairs(currentTargets) do
		tbl[playerID] = target:GetOrigin()
	end
	return tbl
end


--sets the camera to focus a point
--it does this by moving and locking the camera to the dummy unti and then releasing the camera lock 0.1s later
function Camera:FocusPoint(playerID, point)
	createDummyIfNotExisting(playerID)
	local player = PlayerResource:GetPlayer(playerID)
	
	if player ~= nil and cameraDummies[playerID] ~= nil then
		cameraDummies[playerID]:SetOrigin(point)
		PlayerResource:SetCameraTarget(playerID, cameraDummies[playerID])
		currentTargets[playerID] = cameraDummies[playerID]
		
		--delay unlock camera
		Task:Delay(function(tbl) 
			Camera:UnlockPlayerCamera(tbl.playerID)
		end, 0.1, {playerID = playerID})
	end
end


--creates camera dummy for player if it doesn't exist
function createDummyIfNotExisting(playerID)
	if playerID == 65 then
		local dummy = CreateUnitByName("camera_dummy", Vector(0,0,0), false, nil, nil, 2)
		dummy:AddNewModifier(dummy, nil, "dummy_modifier", {})
		cameraDummies["global"] = dummy
	else
		local player = PlayerResource:GetPlayer(playerID)
		if player~=nil and cameraDummies[playerID] == nil then
			local dummy = CreateUnitByName("camera_dummy", Vector(0,0,0), false, nil, nil, player:GetTeamNumber())
			dummy:AddNewModifier(dummy, nil, "dummy_modifier", {})
			cameraDummies[playerID] = dummy
		end
	end
end


--locks the camera onto the dummy unit for this player
function Camera:Lock(playerID)
	createDummyIfNotExisting(playerID)
	PlayerResource:SetCameraTarget(playerID, cameraDummies[playerID])
	currentTargets[playerID] = cameraDummies[playerID]
end

--[[
locks all players to the global camera dummy

if all players have the same camera angle using the global dummy has much better performance than using an individual dummy for each player
]]
function Camera:GlobalLock()
	if globalCameraDummy == nil then
		globalCameraDummy = CreateUnitByName("camera_dummy", Vector(0,0,0), false, nil, nil, 2)
		globalCameraDummy:AddNewModifier(dummy, nil, "dummy_modifier", {})
	end
	
	local playerIDs = Helper:GetAllPlayerIDs()
	for _,playerID in pairs(playerIDs) do
		PlayerResource:SetCameraTarget(playerID, globalCameraDummy)
		currentTargets[playerID] = globalCameraDummy
	end
end

function Camera:MoveGlobalTo(point, changeHeight, delay)
	if delay == nil or delay < 0.03 then
		globalCameraDummy:SetOrigin(point)
		if changeHeight ~= nil and changeHeight == true then
			Camera:UpdateSettings("global", nil, nil, point.z, nil)
		end
	else
		local interval = 0.03
		local intervalCount = delay/interval
		local now = GameTime:SinceStart()
		
		local startPt = globalCameraDummy:GetOrigin()
		local endPt = point
		local diff = endPt - startPt
		local direction = diff:Normalized()
		local magnitude
		
		if changeHeight ~= nil and changeHeight == true then
			magnitude = diff:Length()
		else
			magnitude = diff:Length2D()
		end
		
		Task:IntervalLimited(
			basicLinearInterpolation, 
			interval, 
			{ 
				startPt = startPt, 
				startTime = now,
				totalTime = delay,
				direction = direction,
				magnitude = magnitude,
				changeHeight = changeHeight
			}, 
			intervalCount)
	end
end


--[[
moves the camera to point for this player

the camera must be locked to the dummy for this function to work (use Camera:Lock())

if change height is true then it will change the camera on the z-axis
changeHeight with a delay will use up alot of resources and might have sharp movements
as it requires use of nettables. It is recommended to set changeHeight to false or nil when using a delay

if the delay is not nil then the camera will transition from one point to the next using linear interpolation
]]
function Camera:MoveTo(playerID, point, changeHeight, delay)
	createDummyIfNotExisting(playerID)
	
	if cameraDummies[playerID] ~= nil then
		
		if delay == nil or delay < 0.03 then
			cameraDummies[playerID]:SetOrigin(point)
			if changeHeight ~= nil and changeHeight == true then
				Camera:UpdateSettings(playerID, nil, nil, point.z, nil)
			end
		else
			local interval = 0.03
			local intervalCount = delay/interval
			local now = GameTime:SinceStart()
			
			local startPt = cameraDummies[playerID]:GetOrigin()
			local endPt = point
			local diff = endPt - startPt
			local direction = diff:Normalized()
			local magnitude
			
			if changeHeight ~= nil and changeHeight == true then
				magnitude = diff:Length()
			else
				magnitude = diff:Length2D()
			end
			
			Task:IntervalLimited(
				basicLinearInterpolation, 
				interval, 
				{ 
					playerID = playerID, 
					startPt = startPt, 
					startTime = now,
					totalTime = delay,
					direction = direction,
					magnitude = magnitude,
					changeHeight = changeHeight
				}, 
				intervalCount)
		end
	end
end

--moves camera dummy from starting starting point to new point with basic linear interpolation
function basicLinearInterpolation(info)
	local now = GameTime:SinceStart()
	
	--0-1 value of the current progression of the translation
	local percent = (now - info.startTime) / info.totalTime 
	if percent > 1 then 
		percent = 1
	end
	
	local curMagnitude = info.magnitude * percent
	local newPos = info.startPt + (info.direction * curMagnitude)
	
	if playerID ~= nil then
		cameraDummies[info.playerID]:SetOrigin(newPos)
		if info.changeHeight ~= nil and info.changeHeight == true then
			Camera:UpdateSettings(info.playerID, nil, nil, newPos.z, nil)
		end
		
	elseif playerID == nil then
		globalCameraDummy:SetOrigin(newPos)
		if info.changeHeight ~= nil and info.changeHeight == true then
			Camera:UpdateSettings("global", nil, nil, newPos.z, nil)
		end
	end
end

--[[
shakes the camera for all units in area of the circle
if you are locking a camera to a unit like a dummy then the camera will only shake if the unit is in range, and not the hero

amplitude is the power of the vibration
frequency is the rate at which the vibrations occur, higher value is more vibrations
duration is the length of the shaking
]]
function Camera:Shake(center, radius, duration, amplitude, frequency)
	ScreenShake(center, amplitude, frequency, duration, radius, 0, true)
end

--small camera shake preset
function Camera:ShakeSmall(center, radius, duration)
	Camera:Shake(center, radius, 50, 1, duration)
end

--medium camera shake preset
function Camera:ShakeMedium(center, radius, duration)
	Camera:Shake(center, radius, 550, 5, duration)
end

--large camera shake preset
function Camera:ShakeLarge(center, radius, duration)
	Camera:Shake(center, radius, 5000, 100, duration)
end


