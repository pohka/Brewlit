
if Ability == nil then
	Ability = class ({})
end

--set to true to enable all heroes with the same ability
Ability.sameAbilityMode = false

--same ability mode only effects heroes
Ability.sameAbilityModeIsHeroOnly = true

--the list of ability names which all heroes will have if same ability mode is enabled
Ability.abilityList = {}

--returns a table of useful variables to use with OnSpellStart
--table: caster, target, point, direction, casterForward
function Ability:GetCastingInfo(ability)
	local caster = ability:GetCaster()
	local target = ability:GetCursorTarget()
	local forward = caster:GetForwardVector()
	local point
	if target == nil then
		point = ability:GetCursorPosition()
	else
		point = target:GetAbsOrigin()
	end
	local direction = (point - caster:GetAbsOrigin()):Normalized()
	
	local direction = (point - caster:GetAbsOrigin()):Normalized()
	return {
		caster = caster,
		target = target,
		point = point,
		direction = direction,
		casterForward = forward
	}
end

--creates a 3 projectiles similar to mirana 3 arrow talent
--returns a table of projectile IDs (middle, left, right)
function Ability:ProjectileSplitFire(ability, angle, info)
	local midDir = info.direction
	local projectileID = {}
	projectileID["middle"] = Ability:ProjectileFire(ability, info)
	
	
	info.direction = Helper:VectorRotate2D(midDir, angle)
	projectileID["left"] = Ability:ProjectileFire(ability, info)
	
	info.direction = Helper:VectorRotate2D(midDir, -angle)
	projectileID["right"] = Ability:ProjectileFire(ability, info)
	return projectileID
end

--fires multiple projectiles in a circle around the caster at evenly spaced angles i.e. 12 projectiles = 30 degrees
function Ability:ProjectileClockFire(ability, numProjectiles, info)
	local midDir = info.direction
	local angleIncrement = 360/numProjectiles
	
	local projectileID = {}
	projectileID[0] = Ability:ProjectileFire(ability, info)
	for i=1, numProjectiles do
		info.direction = Helper:VectorRotate2D(info.direction, angleIncrement)
		projectileID[i] = Ability:ProjectileFire(ability, info)
	end
	return projectileID
end

--creates and projectile and returns the projectile ID
function Ability:ProjectileFire(ability, info)
	local pInfo = Ability:ConvertInfoToProjectileTable(ability, info)
	return ProjectileManager:CreateLinearProjectile(pInfo)
end

--[[
converts a brewlit projectile table to the standard Valve projectile tables
Table:
	Required keys:
		particle,		--particle effect (.vpcf)
		direction,		--direction vector
		speed,			--speed of the projectile
		distance		--max distance of the projectile
		
	Optional keys:
		spawnOrigin	
		size 			--sets both the start and end radius of the hitbox
		startSize		--starting size of the hitbox
		endSize			--ending size of the hitbox
		hasCone			--if true the hitbox will have a cone at the front
		replaceExisting	--replaces existing projectiles (probably doesn't work)
		targetTeam		--the target team (DOTA_UNIT_TARGET_TEAM)
		targetFlags		--the target flags (DOTA_UNIT_TARGET_FLAGS)
		targetType		--the type of units which this projectile can effect (DOTA_UNIT_TARGET_TYPE)
		lifeSpan		--the max life span of the projectile
		givesVision		--if true the projectile will give vision
		visionRadius	--the radius of the vision
		visionTeamNum	--the team which gets the vision
		

	Default values if optional keys are nil or not set:
		distance = 2000,
		spawnOrigin = caster:GetAbsOrigin(),
		size = 64,
		hasCone = false,
		replaceExisting = false,
		targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		targetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		targetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		lifeSpan = 5,
		givesVision = false,
		visionRadius = 0,
		visionTeamNum = caster:GetTeamNumber()
	})
]]
function Ability:ConvertInfoToProjectileTable(ability, info)
	local caster = ability:GetCaster()
	
	--minimum info
	local pInfo = {
		Ability = ability,
		EffectName = info.particle,
		vVelocity = info.direction * info.speed,
		fDistance = info.distance,
		Source = caster
	}
	
	--spawn point of the projectile
	pInfo["vSpawnOrigin"] = ConvertHelp(info.spawnOrigin, caster:GetAbsOrigin())
	
	--size of the hit box
	if info.size ~= nil then
		pInfo["fStartRadius"] = info.size
		pInfo["fEndRadius"] = info.size
	end
	
	--starting size of the hitbox
	if info.startSize ~= nil then
		pInfo["fStartRadius"] = info.startSize
	elseif pInfo["fStartRadius"] == nil then
		pInfo["fStartRadius"] = 64
	end
	
	--ending size of the hitbox
	if info.endSize ~= nil then
		pInfo["fEndRadius"] = info.endSize
	elseif pInfo["fEndRadius"] == nil then
		pInfo["fEndRadius"] = 64
	end
	
	--if the projectile hitbox has a cone at the front
	pInfo["bHasFrontalCone"] = ConvertHelp(info.hasCone, false)
	
	--replaces existing projectiles
	pInfo["bReplaceExisting"] = ConvertHelp(info.replaceExisting, false)
	
	--the team to target
	pInfo["iUnitTargetTeam"] = ConvertHelp(info.targetTeam, DOTA_UNIT_TARGET_TEAM_ENEMY)
	
	--flags for targeting DOTA_UNIT_TARGET_FLAGS
	pInfo["iUnitTargetFlags"] = ConvertHelp(info.targetFlags, DOTA_UNIT_TARGET_FLAG_NONE)
	
	--unit type of the target
	pInfo["iUnitTargetType"] = ConvertHelp(info.targetType, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
	
	--the game time which the projectile should be deleted
	pInfo["fExpireTime"] = ConvertHelp(info.lifeSpan,  5)
	pInfo["fExpireTime"] = pInfo["fExpireTime"] + GameRules:GetGameTime()
	
	--projectile gives vision
	if info.givesVision ~= nil and info.givesVision == true and info.visionRadius > 0 then
		pInfo["bProvidesVision"] = true
	else
		pInfo["bProvidesVision"] = false
	end
	
	--radius of the vision
	if info.visionRadius ~= nil and info.visionRadius > 0 then
		pInfo["iVisionRadius"] = info.visionRadius
	else
		pInfo["iVisionRadius"] = 0
	end
	
	--which team is given the vision
	pInfo["iVisionTeamNumber"] = ConvertHelp(info.visionTeamNum, caster:GetTeamNumber())
	
	return pInfo
end

--returns value if it is not nil, otherwise it returns defaultValue
function ConvertHelp(value, defaultValue)
	if value ~= nil then
		return value
	else
		return defaultValue
	end
end

--sets the units abilties to match the Ability.abilityList table.
--if sameAbilityModeIsHeroOnly is true then this function will only modify abilities on heroes
--default callback function for the gamemode which is called OnUnitSpawned
function Ability:UseSameAbilities(unit)
	if Ability.sameAbilityModeIsHeroOnly and unit:IsHero() then
		if Ability.sameAbilityMode then
			removeIfNotInAbilityList(unit)
			
			--add abilities if they dont exist
			local abilCount = table.getn(Ability.abilityList)
			for _,abilName in pairs(Ability.abilityList) do
					if unit:HasAbility(abilName) == false then
						unit:AddAbility(abilName)
				end
			end
		end
	end
end

--removes all abilities not in the abilityList from the unit
function removeIfNotInAbilityList(unit)
	for i=0, unit:GetAbilityCount()-1 do
		local abil = unit:GetAbilityByIndex(i)
		if abil ~= nil then
			local name = abil:GetAbilityName()
			if Helper:TableIndexOf(Ability.abilityList, name) == nil then
				print("index:" .. Helper:TableIndexOf(Ability.abilityList, name))
				unit:RemoveAbility(name)
			end
		end
	end
end

--gives every hero this ability
function Ability:GiveAllHeroesAbility(name)
	table.foreach(Find:GetHeroes(), 
		function(i,hero)
			hero:AddAbility(name)
		end)
end

--removed all abilities from this unit
function Ability:ClearAbilities(unit)
	for i=0, unit:GetAbilityCount() do
		local abil = unit:GetAbilityByIndex(i)
		if abil ~= nil then
			local name = abil:GetAbilityName()
			unit:RemoveAbility(name)
		end
	end
end



