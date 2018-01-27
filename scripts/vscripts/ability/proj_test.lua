proj_test = class ({})

function proj_test:OnSpellStart()
	local info = Ability:GetCastingInfo(self)
	
	
	local projectileSpeed = 1000
	local particle = "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf"
	
	--[[
	--single projectile example
	Ability:ProjectileFire(self, {
		particle = particle, 
		direction = info.direction, 
		speed = projectileSpeed, 
		distance = 2000, 
		size = 64, 
		lifeSpan = 6, 
		visionRadius = 100,
		deleteOnHit = true
	})
	]]
	
	local angle = 30
	Ability:ProjectileSplitFire(self, angle, {
		particle = particle, 
		direction = info.direction, 
		speed = projectileSpeed, 
		distance = 2000, 
		size = 64, 
		lifeSpan = 6, 
		visionRadius = 100,
		deleteOnHit = true
	})
end



