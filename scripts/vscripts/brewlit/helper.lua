

if Helper == nil then
	Helper = class ({})
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

--returns the key where the value matches a value in the table. returns nil if not found
function Helper:TableIndexOf(tbl, value)
	for k,v in pairs(tbl) do
		if v == value then
			return k
		end
	end
end


--prints the key and the type of each variable in the table
function Helper:PrintTable(tbl)
	if tbl == nil then
		print("table is nil")
		return
	end
	table.foreach(tbl, 
		function(k,v)
			local vType
			
			if type(v) == "table" then
				if v.GetClassname ~= nil then
					vType = v:GetClassname()
				else
					vType = "table"
				end
			else
				vType = type(v) .. " = " .. v
			end
			
			print(k .. ": " .. vType)
		end)
end


--returns an indexed table of the player ids of every player
function Helper:GetAllPlayerIDs()
	local tbl = {}
	for teamNum,teamInfo in pairs(Setup.teamTable) do
		local count = PlayerResource:GetPlayerCountForTeam(teamNum)
		for i=0, count do
			local id = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
			if id ~= nil then
				table.insert(tbl, id)
			end
		end
	end
	return Helper:ConvertTableToStartAtZero(tbl)
end


--returns an index table of all the player
function Helper:GetAllPlayers()
	local tbl = {}
	for teamNum,teamInfo in pairs(Setup.teamTable) do
		local count = PlayerResource:GetPlayerCountForTeam(teamNum)
		for i=0, count do
			local id = PlayerResource:GetNthPlayerIDOnTeam(teamNum, i)
			local player = PlayerResource:GetPlayer(id)
			if player ~= nil then
				table.insert(tbl, player)
			end
		end
	end
	return Helper:ConvertTableToStartAtZero(tbl)
end


--rotates a vector around the world up axis
function Helper:VectorRotate2D(vec, degrees)
	local radians = degrees * (math.pi/180)
	local dCos = math.cos(radians)
	local dSin = math.sin(radians)
	local x = vec.x * dCos - vec.y * dSin;
	local y = vec.x * dSin + vec.y * dCos;
	return Vector(x,y,vec.z)
end