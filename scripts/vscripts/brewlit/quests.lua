
if Quests == nil then
	Quests = class({})
end

local questList 				--table of all the quests
local MAX_STAGE_INDEX = 1000	--max stage index for a quest
local QUEST_STAGE_STATE_NOT_ACTIVE = -1
local QUEST_STAGE_STATE_ACTIVE = 0
local QUEST_STAGE_STATE_COMPLETED = 1


--loads the kv files
function Quests:Load()
	local folder = "scripts/kv/"
	questList = LoadKeyValues(folder .. "quests.txt")
	for questid,quest in pairs(questList) do
		quest.curStage = 0		-- curStage == 0 : not discovered, curStage >= 1000 : completed
		for _,stage in pairs(quest.stages) do
			stage.state = QUEST_STAGE_STATE_NOT_ACTIVE
		end
	end
	
	CustomNetTables:SetTableValue("quest", "questList", {})
	--Task:Delay(function() CustomNetTables:SetTableValue("quest", "questList", questList) end, 1)
end


--SETTERS

--active quest and set it to the first stage
function Quests:StartQuest(questID)
	if Quests:IsQuestStarted(questID) then
		print("WARNING: Quest has already started - questID:" .. questID)
		return
	end
	
	--find the stage with the lowest index
	local firstStageIndex
	for index,stage in pairs(questList[questID].stages) do
		if firstStageIndex == nil or index < firstStageIndex then
			firstStageIndex = index
		end
	end
	
	--set the current stage of the quest
	questList[questID].curStage = firstStageIndex
	
	--set the stage active
	questList[questID]["stages"][firstStageIndex].state= QUEST_STAGE_STATE_ACTIVE
	
	CustomNetTables:SetTableValue("quest", "questList", questList)
end


--sets a stage to completed
function Quests:SetQuestStageCompleted(questID, stageIndex)
	questList[questID]["stages"][stageIndex].state = QUEST_STAGE_STATE_COMPLETED
	CustomNetTables:SetTableValue("quest", "questList", questList)
end


--sets the current stage index of a quest
function Quests:SetStageActive(questID, stageIndex)
	questList[questID].curStage = stageIndex
	local stage = questList[questID]["stages"][stageIndex]
	if stage ~= nil and stage.state == QUEST_STAGE_STATE_NOT_ACTIVE then
		questList[questID]["stages"][stageIndex].state = QUEST_STAGE_STATE_ACTIVE
		CustomNetTables:SetTableValue("quest", "questList", questList)
	elseif stage == nil then
		print("WARNING: Quest stage index not found - stageIndex : " .. stageIndex)
	elseif stage.state ~= QUEST_STAGE_STATE_NOT_ACTIVE then
		print("WARNING: Quest stage is already active or completed - stageIndex : " .. stageIndex .. ", state : " .. stage.state)
	end
end


--completes the quest by setting the current stage index to 1000
function Quests:CompleteQuest(questID)
	if Quests:IsQuestCompleted(questID) then
		print("WARNING: Quest is already completed - questID : " .. questID)
		return
	end
	Quests:SetQuestCurrentStage(questID, MAX_STAGE_INDEX)
	CustomNetTables:SetTableValue("quest", "questList", questList)
end






--GETTERS

--returns true if the quest is active or completed
function Quests:IsQuestStarted(questID)
	return tonumber(questList[questID].curStage) > 0
end


--returns true is the quest is completed
function Quests:IsQuestCompleted(questID)
	return tonumber(questList[questID].curStage) >= MAX_STAGE_INDEX
end


--returns true if the quest is active
function Quests:IsQuestActive(questID)
	return tonumber(questList[questID].curStage) > 0 and tonumber(questList[questID].curStage) < MAX_STAGE_INDEX
end


--returns a table of active quests
function Quests:GetActiveQuests()
	local activeQuests = {}
	for questID,quest in pairs(questList) do
		if Quests:IsQuestActive(questID) then
			table.insert(activeQuests, quest)
		end
	end
	return activeQuests
end


--returns a table of the completed quests
function Quests:GetCompletedQuests()
	local completedQuests = {};
	for questID,quest in pairs(questList) do
		if Quests:IsQuestCompleted(questID) then
			table.insert(completedQuests, quest)
		end
	end
	return completedQuests
end



