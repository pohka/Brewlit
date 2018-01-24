--time within the game
--also manages day and night cycles easier than the default api
if GameTime == nil then
	GameTime = class ({})
end

--the time since the game mode has entered the pregame (doesn't count paused time)
function GameTime:SinceStart()
	return GameRules:GetGameTime()
end

--time since the clock hit zero (doesn't count paused time)
function GameTime:SinceMatchStart()
	return GameRules:GetDOTATime(false, false)
end

function GameTime:IsPaused()
	return GameRules:IsGamePaused()
end

--returns true if day time
function GameTime:IsDayTime()
	return GameRules:IsDaytime()
end

--[[
returns table of info on the time of day
Table:
 * isDayTime (bool) : true if is day time
 * timePercent (float) : 0-1 value with the percentage of the day or night, 0.75 means 3/4 of the way through the day/night 
]]
function GameTime:GetDayCycle()
	local isDay = GameTime:IsDayTime()
	local t = GameTime:OfDay()
	
	if isDay then
		t = (t-0.25) * 2
	else
		if t > 0.5 then
			t = (t-0.5)
		end
		t = t * 2
	end
	
	local info = {
		isDayTime = isDay,
		timePercent = t
	}
end


--[[
sets the day and night cycle to night
t is the percent at night time (0-1 value) and is optional
GameTime:SetNightTime(0.5) -- sets to half ways into the night
	
]]
function GameTime:SetNightTime(t)
	if t == nil or t <= 0 then
		t = 0.01
	end
	
	t = t/2 + 0.75
	if t >= 1 then
		t = t-1
	end
	
	GameRules:SetTimeOfDay(t)
end


--[[
sets the day and night cycle to day
t is the percent at day time (0-1 value) and is optional
GameTime:SetDayTime(0.5) -- sets to half ways into the night
]]
function GameTime:SetDayTime(t)
	if t == nil or t <= 0 then
		t = 0.01
	end
	
	t = t/2 + 0.25
	if t >= 1 then
		t = t-1
	end
	
	GameRules:SetTimeOfDay(t)
end


	