
if Animation == nil then
	Animation = class({})
end

--all the animation info for each entity
unitAnims = {}

--[[
Queues an animation to a unit
each animation is given a weight, a heigher weight gives higher priority in the queue
The unit will always used the animation with the hightest weight.
If the weight is nil then it will be set to 1 by deafult
if the playerbackRate is nil then it will be set to 1
if the duration is nil then the animation will be queued until it is cleared

the animation info table structure:
-anim
-playbackRate
-weight

some animations will loop forever if they are are not cleared such as ACT_DOTA_FLAIL
Where as an animation like ACT_DOTA_CAST_ABILITY_1 will only take a fraction of a seconds 
but it won't be removed from the queue if the duration is nil. Leading to possible problems with animation queuing
as a result it is recommended to always define a duration for spells and only leave duration nil 
if you cant a constant looping animation to fall back to when there is no other animation in the queue for this unit
]]
function Animation:Set(unit, anim, duration, playbackRate, weight)

	if playbackRate == nil then
		playbackRate = 1
	end
	
	if weight == nil then 
		weight = 1 
	end
	
	unit:StartGestureWithPlaybackRate(anim, playbackRate)
	local entIndex = unit:GetEntityIndex()
	
	--create table for this entity
	if unitAnims[entIndex] == nil then
		unitAnims[entIndex] = {}
	end
	
	--add animation info to uniAnims with the activity, playback rate and weight
	table.insert(unitAnims[entIndex], { anim = anim, playbackRate = playbackRate, weight = weight });
	
	--schedule a removal of this animation
	if duration ~= nil and duration > 0 then
		Task:Delay(function(tbl) 
			Animation:RemoveAnimation(tbl.unit, tbl.anim)
		end, duration, { unit = unit, anim = anim })
	end
end

--returns a zero index table with all the currently queued animation for the given unit
--each animation is a table with the keys (anim, playbackRate and weight)
--this will return nil if the an animation has never been set for this unit
function Animation:GetAllAnimations(unit)
	local entIndex = unit:GetEntityIndex()
	return Helper:ConvertTableToStartAtZero(unitAnim[entIndex])
end

--returns the animation info table of the current animation
--return nil if there is no animation queued
function Animation:GetCurrentAnimation(unit)
	local entIndex = unit:GetEntityIndex()
	if unitAnims[entIndex] == nil then
		return nil
	end
	
	local highestWeight
	Helper:PrintTable(unitAnims[entIndex])
	for i,animInfo in pairs(unitAnims[entIndex]) do
		if highestWeight == nil or highestWeight.weight < animInfo.weight then
			highestWeight = animInfo
		end
	end
	
	return highestWeight
end

--returns true if the unit has an animtion queued with a matching activity
function Animation:UnitHasAnimation(unit, anim)
	local entIndex = unit:GetEntityIndex()
	if unitAnims[entIndex] == nil then
		return false
	end
	
	for _,animInfo in pairs(unitAnims[entIndex]) do
		if animInfo.anim == anim then
			return true
		end
	end
	return false
end

--[[
removes the animation gesture from the unit and
and removes it from the unitAnims table.
If the removed animation has the highest weight and there is another animtion in the queue it will then play that animation

]]
function Animation:RemoveAnimation(unit, anim)
	local entIndex = unit:GetEntityIndex()
	local currentAnims = unitAnims[entIndex]
	local found = false
	local highestWeight
	for i,animInfo in pairs(currentAnims) do
		if animInfo.anim == anim and not found then
			table.remove(unitAnims[entIndex], i)
			found = true
		elseif highestWeight == nil or highestWeight.weight < animInfo.weight then
			highestWeight = animInfo
		end
	end
	unit:RemoveGesture(anim)
	
	if highestWeight ~= nil then
		unit:StartGestureWithPlaybackRate(highestWeight.anim, highestWeight.playbackRate)
	end
end

--removes the current animation from the unit and clears any queued animation
function Animation:ClearAnimations(unit)
	local entIndex = unit:GetEntityIndex()
	if unitAnims[entIndex] ~= nil then
		for index, animInfo in pairs(unitAnims[entIndex]) do
			unit:RemoveGesture(animInfo.anim)
		end
	end
	unitAnims[entIndex] = {}
end

--removes the current animation and plays the next animtion in the queue if it exists
function Animation:RemoveCurrentAnimation(unit)
	local currentAnimInfo = Animation:GetCurrentAnimation(unit)
	if currentAnimInfo ~= nil then
		Animation:RemoveAnimation(unit, currentAnimInfo.anim)
	end
end