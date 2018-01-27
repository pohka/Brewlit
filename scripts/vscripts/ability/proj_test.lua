proj_test = class ({})

function proj_test:OnSpellStart()
	local info = Ability:GetCastingInfo(self)
	
	
	local projectileSpeed = 1000
	local particle = "particles/econ/items/mirana/mirana_crescent_arrow/mirana_spell_crescent_arrow.vpcf"
	
	
	--single projectile example
	Ability:ProjectileFire(self, {
		particle = particle, 
		direction = info.direction, 
		speed = projectileSpeed, 
		distance = 2000
	})

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
		print("hit")
		
		return destroyOnHit
	else
		print("ended")
		return true
	end
end



