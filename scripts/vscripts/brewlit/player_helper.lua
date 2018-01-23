if PlayerHelper == nil then
	PlayerHelper = class ({})
end

--returns an ability on hero assigned to the player with he same player ID and ability name
--returns nil if not found on the players assigned hero
function PlayerHelper:GetAbilityByName(playerID, abilityName)
	local player = PlayerResource:GetPlayer(playerID)
	local hero = player:GetAssignedHero()
	for i=0, hero:GetAbilityCount() do
		local abil = hero:GetAbilityByIndex(i)
		if abil ~= nil and abilityName == abil:GetAbilityName() then
			return abil
		end
	end
	
	--if not found in hero abilities, check the inventory
	if hero:HasInventory() and hero:HasItemInInventory(abilityName) then
		for i=0, 9 do
			local item = hero:GetItemInSlot(i)
			if item ~= nil and abilityName == item:GetAbilityName() then
				return item
			end
		end
	end
	
	return nil
end