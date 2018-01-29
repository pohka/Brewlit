
--startinting point for scripting
function Brewlit:Start()
	print("Brewlit:Start()")
	Setup:Quick(self)
	GameRules:SetRuneSpawnTime(10)
	--SetPassiveGold(100, 3)
	
	Ability.sameAbilityMode = true
	Ability.abilityList = {"proj_test"}
	
	
	local id = Task:Interval(test2, 1, nil)
	Task:Delay(test, 5, {id})
	--Camera:FocusHeroOnRespawn()
	
	Task:Interval(camTest, 0.03)
	Camera:SetCameraTypeAllPlayers("third_person_alt")
	
	--[[
	Event:OnUnitSpawned(function(event)
		if event.unit:IsHero() then
			local playerID = event.unit:GetPlayerOwnerID()
			Camera:Lock(playerID)
			Camera:MoveTo(playerID, Vector(0, 300,-400))
			Camera:MoveTo(playerID, Vector(0,-600,0), false, 5)
		end
	end)
	]]
end


local yaw = 0
local zoom = 1000
local zoomChange = -10
local pitch = 60
local pitchChange = 4
function camTest()
	yaw = yaw + 5
	if zoom > 800 then
		zoom = 8000
		zoomChange = -zoomChange
	elseif zoom < 600 then
		zoom = 600
		zoomChange = -zoomChange
	end
	
	zoom = zoom - zoomChange
	
	--[[
	if pitch > 170 then
		pitch = 170
		pitchChange = -pitchChange
	elseif pitch < 10 then
		pitch = 10
		pitchChange = -pitchChange
	end
	]]
	
	pitch = pitch + pitchChange
	
	local playerIDs = Helper:GetAllPlayerIDs()
	for _,playerID in pairs(playerIDs) do
		--Camera:UpdateSettings(playerID, yaw, 300, 300, pitch)
	end
end

--local yPos = -100
--called once every second
function Brewlit:Update()
	
	if Camera:AllPlayersHaveTarget() == false then
		--Camera:LockAllCamerasToHero()
	end
	
	-- Camera:Shake(Vector(0,0,0), 3000, 150, 0.45, 1)
	--Camera:Shake(Vector(0,0,0), 3000, 50, 1, 1)
	
	--[[
	local playerIDs = Helper:GetAllPlayerIDs()
	for _,playerID in pairs(playerIDs) do
		--Camera:FocusPoint(playerID, Vector(0,0,0))
		Camera:Lock(playerID)
		Camera:MoveTo(playerID, Vector(0,yPos,0))
	end
	]]
	
	--local heroes = Query:GetTrees()
	--Helper:PrintTable(heroes)
	
	--GameStateManager:SetVictory("DansGame", 2)
	--GameRules:SetGameWinner(2)
	
	local heroes = Find:Heroes()
end

function test(tbl)
	Task:Interupt(tbl[1])
	print("interupted")
end

function test2()
	print("i am interval")
end



--you can listen to particular state changes using listener functions called from GameStateManager
function Event:OnStateInProgress()
	Camera:GlobalLock()
	Camera:MoveGlobalTo(Vector(1000,300,-400))
	Camera:MoveGlobalTo(Vector(0, -600,0), true, 5)
	--local targets = Camera:GetCurrentTargets()
	--print("targets: --------------")
	Helper:PrintTable(targets)
	--Task:Delay(function() Camera:MoveTo(, Vector(0,-600,0), false, 5) end, 4)
end

function MinimapEventTest()
	local heroes = Query:GetHeroes()
	if heroes[0] ~= nil then
		local pos = heroes[0]:GetAbsOrigin()
		MinimapEvent(2, heroes[0], pos.x, pos.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 1) --pings the map
		--MinimapEvent(2, heroes[0], pos.x, pos.y, DOTA_MINIMAP_EVENT_RADAR, 1) -- green radar on minimap
		--MinimapEvent(2, heroes[0], pos.x, pos.y, DOTA_MINIMAP_EVENT_RADAR_TARGET, 1) -- red radar on minimap
	end
end




