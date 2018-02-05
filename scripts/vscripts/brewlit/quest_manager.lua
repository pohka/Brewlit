
if QuestManager == nil then
	QuestManager = class({})
end

local questList 				--table of all the quests
local MAX_STAGE_INDEX = 1000	--max stage index for a quest

--loads the kv files
function QuestManager:Load()
	local folder = "scripts/kv/"
	local questList = LoadKeyValues(folder .. "quests.txt")
	for questid,quest in pairs(questList) do
		quest.curStage = 0		-- curStage == 0 : not discovered, curStage >= 1000 : completed
		for _,stage in pairs(quest.stages) do
			stage.completed = 0
			stage.active = 0
		end
	end
end

--returns a table of active quests
function QuestManager:GetActiveQuests()
	local activeQuests = {}
	for questid,quest in pairs(questList) do
		if quest.curIndex > 0 and quest.curIndex < MAX_STAGE_INDEX then
			table.insert(activeQuests, quest)
		end
	end
	return activeQuests
end

--returns a table of the completed quests
function QuestManager:GetCompletedQuests()
	local completedQuests = {};
	for questid,quest in pairs(questList) do
		if quest.curIndex >= MAX_STAGE_INDEX then
			table.insert(completedQuests, quest)
		end
	end
	return completedQuests
end

--returns a table of the text for the current active stages
function QuestManager:GetQuestActiveStages(questID)
	
end

--sets a stage to completed
function QuestManager:SetQuestStageCompleted(questID, stageIndex)
	questList[questID]["stages"][stageIndex].completed = 1
	
end

--sets the current stage index of a quest
function QuestManager:SetQuestStage(questID, stageIndex)
	questList[questID].curStage = stageIndex
	local stage = questList[questID]["stages"][stageIndex]
	if stage ~= nil then
		questList[questID]["stages"][stageIndex].active = 1
	end
end

--completes the quest by setting the current stage index to 1000
function QuestManager:CompleteQuest(questID)
	QuestManager:SetQuestCurrentStage(questID, MAX_STAGE_INDEX)
end