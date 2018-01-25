
if Find == nil then
	Find = class ({})
end

--returns an indexed table of CDOTA_BaseNPC_Hero
--if the team number is nil then it will return all the heroes on every team
function Find:Heroes(teamNumber)
	return Find:Query(teamNumber, nil, nil, DOTA_UNIT_TARGET_HERO)
end

--returns an indexed table of CDOTA_BaseNPC_Hero
--if the team number is nil then it will return all the heroes on every team
function Find:Creeps(teamNumber)
	return Find:Query(teamNumber, nil, nil, DOTA_UNIT_TARGET_CREEP)
end

--returns an indexed table of CDOTA_BaseNPC_Hero
--if the team number is nil then it will return all the heroes on every team
function Find:Buildings(teamNumber)
	return Find:Query(teamNumber, nil, nil, DOTA_UNIT_TARGET_BUILDING)
end

--returns an indexed table of CDOTA_BaseNPC_Hero
--if the team number is nil then it will return all the heroes on every team
function Find:AllUnits(teamNumber)
	return Find:Query(teamNumber)
end

--returns an indexed table of CDOTA_BaseNPC_Hero
function Find:AllTrees()
	local radius = 420420 --smokeweed
	local trees = GridNav:GetAllTreesAroundPoint(Vector(0,0,0), radius, false)
	return Helper:ConvertTableToStartAtZero(trees)
end



--returns an indexed table of CDOTA_BaseNPC_Hero
--if teamNumber is nil than it will search all teams by default
--if radius is nil thant it will get all the units on the map
--if teamNumber is defined and targetTeam is nil then it will only return units on that team
--default targetFlag : DOTA_UNIT_TARGET_FLAG_NONE
--default order : FIND_ANY_ORDER
function Find:Query(teamNumber, radius, targetTeam, targetUnitType, targetFlag, order)
	if teamNumber == nil then
		teamNumber = 1
		targetTeam = DOTA_UNIT_TARGET_TEAM_BOTH
	elseif targetTeam == nil then
		targetTeam = DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
	
	if radius == nil then
		radius = FIND_UNITS_EVERYWHERE
	end
	
	if targetUnitType == nil then
		targetUnitType = DOTA_UNIT_TARGET_ALL
	end
	
	if targetFlag == nil then
		targetFlag = DOTA_UNIT_TARGET_FLAG_NONE
	end
	
	if order == nil then
		order = FIND_ANY_ORDER
	end
	

	local units = FindUnitsInRadius(
		teamNumber,
		Vector(0,0,0),
		nil,
		radius,
		targetTeam,
		targetUnitType,
		targetFlag,
		order,
		false)
		
	return Helper:ConvertTableToStartAtZero(units)
end

