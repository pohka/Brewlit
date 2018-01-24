

if ItemManager == nil then
	ItemManager = class ({})
end

--returns a table of CDOTA_Item_Physical of all the dropped items in the world
function ItemManager:GetDroppedItems()
	local tbl = {};
	for i=0, GameRules:NumDroppedItems() do
		tbl[i] = GameRules:GetDroppedItem(i)
	end
	return tbl
end

--returns a table of CDOTA_Item_Physical for all the dropped items in the world belonging to a hero
function ItemManager:GetDroppedItemsForHero(hero)
	local heroEntIndex = hero:GetEntityIndex()
	local tbl = {};
	local count = 0;
	for i=0, GameRules:NumDroppedItems() do
		local phyItem = GameRules:GetDroppedItem(i)
		if phyItem ~= nil then
			local owner = phyItem:GetContainedItem():GetOwner()
				print("owner:" .. owner:GetClassname())
			local itemOwnerEntIndex = owner:GetEntityIndex()
			if heroEntIndex == itemOwnerEntIndex then
				tbl[count] = phyItem
				count = count + 1
			end
		end
	end
	return tbl
end

--move this to AI
--also useful for creating a cutscene when player input is disabled
--sends a command to pick up a dropped item
function ItemManager:PickUpItem(unit, droppedItem)
	unit:PickupDroppedItem(droppedItem)
end