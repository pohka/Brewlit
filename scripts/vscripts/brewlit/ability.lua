
if Ability == nil then
	Ability = class ({})
end

--returns a table of useful variables to use with OnSpellStart
--table: caster, target, point, direction
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
		direction = direction
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
	local caster = ability:GetCaster()
	local pInfo = 
	{
		Ability = info.ability,
		EffectName = info.particle,
		vSpawnOrigin = caster:GetAbsOrigin(),
		fDistance = info.distance,
		fStartRadius = info.size,
		fEndRadius = info.size,
		Source = caster,
		bHasFrontalCone = false,
		bReplaceExisting = false,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
        fExpireTime = GameRules:GetGameTime() + info.lifeSpan,
		bDeleteOnHit = info.deleteOnHit,
		vVelocity = info.direction * info.speed,
		bProvidesVision = true,
		iVisionRadius = info.visionRadius,
		iVisionTeamNumber = caster:GetTeamNumber()
	}
	return ProjectileManager:CreateLinearProjectile(pInfo)
end