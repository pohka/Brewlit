var quests = {
	"quest_1" : {title : "Quest 1", description: "description 1", curIndex : "1",
		stages: {	
			"10": { "text": "objective 1", active: 1, completed: 0 },
			"20": { "text": "objective 2", active: 1, completed: 0 },
		}
	},
	"quest_2" : {title : "Quest 2", description: "description 2", curIndex : "1",
		stages: {	
			"10": { "text": "objective 3", active: 1, completed: 0 },
			"20": { "text": "objective 4", active: 1, completed: 0 },
		}
	},
	"quest_3" : {title: "Quest 4", description: "description 3", curIndex : "1000",
		stages: {	
			"10": { "text": "objective 5", active: 1, completed: 0 },
			"20": { "text": "objective 6", active: 1, completed: 1 },
		}
	}
};

//updates the quest list column
function updateQuestList()
{	
	$("#quest-con").RemoveAndDeleteChildren();
	questListSection("Active", String.fromCharCode(9671), true);
	questListSection("Completed", String.fromCharCode(9670), false);
}

//generates a section in the quest list column
function questListSection(title, icon, useActiveList)
{	
	var heading = $.CreatePanel("Label", $("#quest-con"), "");
	heading.AddClass("quest-section");
	heading.text = title;
	
	for(var i in quests){
		if(	(useActiveList && quests[i].curIndex > 0 && quests[i].curIndex < 1000) ||
			(!useActiveList && quests[i].curIndex >= 1000))
		{
			var label = $.CreatePanel("Label", $("#quest-con"), "");
			label.AddClass("quest");
			label.text = icon + " " + quests[i].title;
			label.SetPanelEvent("onactivate", "updateQuestInfo('"+i+"')");
		}
	}
}

//updates the quest info container
function updateQuestInfo(id)
{
	$("#quest-info-title-text").text = quests[id].title;
	$("#quest-info-desc-text").text = quests[id].description;
	
	$("#quest-stage-con").RemoveAndDeleteChildren();
	$.Msg(id);
	$.Msg(quests[id]);
	stageListSection("Active", String.fromCharCode(9671), quests[id].stages, true);
	stageListSection("Completed", String.fromCharCode(9670), quests[id].stages, false);
}

//generates stage section
function stageListSection(title, icon, stageList, useActiveList)
{
	var heading = $.CreatePanel("Label", $("#quest-stage-con"), "");
	heading.AddClass("quest-stage-section");
	heading.text = title;
	
	for(var i in stageList){
		//$.Msg(stageList);
		if(	(useActiveList && stageList[i].active == 1 && stageList[i].completed == 0) ||
			(!useActiveList && stageList[i].completed == 1))
		{
			var label = $.CreatePanel("Label", $("#quest-stage-con"), "");
			label.AddClass("quest-stage"); 
			label.text = icon + " " + stageList[i].text;
			label.SetPanelEvent("onactivate", "updateQuestInfo('"+i+"')");
		}
	}
}

(function(){
	updateQuestList();
})();