var quests = {
	"quest_1" : {title : "Quest 1", description: "description 1", curStage : "1",
		stages: {	
			"10": { "text": "objective 1", active: 1, completed: 0 },
			"20": { "text": "objective 2", active: 1, completed: 0 },
		}
	},
	"quest_2" : {title : "Quest 2", description: "description 2", curStage : "1",
		stages: {	
			"10": { "text": "objective 3", active: 1, completed: 0 },
			"20": { "text": "objective 4", active: 1, completed: 0 },
		}
	},
	"quest_3" : {title: "Quest 4", description: "description 3", curStage : "1000",
		stages: {	
			"10": { "text": "objective 5", active: 1, completed: 0 },
			"20": { "text": "objective 6", active: 1, completed: 1 },
		}
	}
};

//different states a quest stage can be in
var QUEST_STAGE_STATE_NOT_ACTIVE = -1; 	//not discovered
var QUEST_STAGE_STATE_ACTIVE = 0;		//active
var QUEST_STAGE_STATE_COMPLETED = 1;	//completed

quests = {
	"zone1_quest1":	{
		"stages":{
			"10":{	
				"state": -1,
				"text":"kill the bad guy",	
			},
			"20":{
				"state": -1,
				"text":"find the building",
				"optional":1
			},
			"30":{
				"state": -1,
				"text":"return to the shop",
			}
		},
		"curStage":1,
		"title":"my quest name",
		"description":"the description of this quest"
	}
};

quests = {};

//updates the quest list column
function updateQuestList()
{	
	$.Msg(quests);
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
		if(	(useActiveList && quests[i].curStage > 0 && quests[i].curStage < 1000) ||
			(!useActiveList && quests[i].curStage >= 1000))
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
	//$.Msg(id);
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
		if(	(useActiveList && stageList[i].state == QUEST_STAGE_STATE_ACTIVE) ||
			(!useActiveList && stageList[i].state == QUEST_STAGE_STATE_COMPLETED))
		{
			var label = $.CreatePanel("Label", $("#quest-stage-con"), "");
			label.AddClass("quest-stage"); 
			label.text = icon + " " + stageList[i].text;
			label.SetPanelEvent("onactivate", "updateQuestInfo('"+i+"')");
		}
	}
}

//callback function, called when the quest nettable changes
function onQuestChange(table, key, data)
{
	if(key === "questList"){
		quests = data;
		updateQuestList();
	}
}

//toggles the menu on and off
function toggleQuestMenu()
{
	var menu = $("#menu_quest");
	if(menu.visible){
		menu.style.visibility = "collapse";
	}
	else{
		menu.style.visibility = "visible";
	}
}

(function(){
	updateQuestList();
	CustomNetTables.SubscribeNetTableListener("quest", onQuestChange);
})();