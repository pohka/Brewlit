
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
end





--called once every second
function Brewlit:Update()
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
	print("game started")
	HUD:SendChatMsg("hello World")
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




