

if Helper == nil then
	Helper = class ({})
end

--returns an indexed table of all the heroes on the map
function Helper:GetAllHeroes()
	local units = FindUnitsInRadius(
		DOTA_TEAM_GOODGUYS,
        Vector(0, 0, 0),
		nil,
		FIND_UNITS_EVERYWHERE,
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)
	return Helper:ConvertTableToStartAtZero(units)
end

--[[
converts all tables that have indexing starting at 1 to start at zero
As ALL programmers are supposed to start counting from zero REEEEEE
original:
tbl = { 1 = "item 1", 2 = "item 2", .... }
converts to:
tbl  = { 0 = "item 1", 1 = "item 2", .... }

]]
function Helper:ConvertTableToStartAtZero(tbl)
	if tbl[0] == nil then
		local i =1
		while tbl[i] ~= nil do
			tbl[i-1] = tbl[i]
			i = i + 1
		end
		tbl[i-1] = nil
	end
	return tbl
end

--executes a function for each hero on the map
--func(hero, table)
function Helper:ForEachHero(func, tbl)
	local units = Helper:GetAllHeroes()
	for _,unit in pairs(units) do
		func(unit, tbl)
	end
end

--prints the key and the type of each variable in the table
function Helper:PrintTable(tbl)
	table.foreach(tbl, 
		function(k,v)
			local vType
			
			if type(v) == "table" then
				vType = v:GetClassname()
			else
				vType = type(v)
			end
			
			print(k .. ": " .. vType)
		end)
end