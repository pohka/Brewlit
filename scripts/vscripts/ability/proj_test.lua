proj_test = class ({})

function proj_test:OnSpellStart()
	local info = Ability:GetCastingInfo(self)
	
	
	local projectileSpeed = 1000
	local particle = "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf"
	local particleTrack = "particles/base_attacks/generic_projectile.vpcf"
	
	Ability:TrackingProjectileFire(self, {
		target = info.target,
		particle = particleTrack,
		speed = 400,
		lifeSpan = 10
	});
	
	--single projectile example
	--[[
	Ability:ProjectileFire(self, {
		particle = particle, 
		direction = info.direction, 
		speed = projectileSpeed, 
		distance = 2000
	})
	
	
	Animation:Set(info.caster, ACT_DOTA_FLAIL, 3, 1)
	Animation:Set(info.caster, ACT_DOTA_CAST_ABILITY_2, 0.5, 1, 2)
	]]
	--[[
	--split fire example
	local angle = 30
	Ability:ProjectileSplitFire(self, angle, {
		particle = particle, 
		direction = info.direction, 
		speed = projectileSpeed, 
		distance = 2000
	})
	]]
	
	
	
	--clock example
	--[[
	local ids = Ability:ProjectileClockFire(self, 12, {
		particle = particle, 
		direction = info.direction, 
		speed = projectileSpeed, 
		distance = 2000
	})
	]]
end

--returning true destorys the projectile
function proj_test:OnProjectileHit(hTarget, vLocation)
	local destroyOnHit = true;
	
	if hTarget ~= nil then
		--projectile hit a target
		
		return destroyOnHit
	else
		--projectile reached its max distance
		
		return true
	end
end



