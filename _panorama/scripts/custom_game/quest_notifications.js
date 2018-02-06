var quests = {}

//creates a new notification
function newNotification(text)
{
	var panel = $.CreatePanel("Panel", $.GetContextPanel(), "");
	var label = $.CreatePanel("Label", panel, "");
	label.text = text;
}

//decides what notifications should be created
function checkChanges(data)
{
	for(var i in data){
		if(data[i].curStage > 0 && (quests[i] === undefined || quests[i].curStage == 0)){
			newNotification("New Quest: " + data[i].title);
		}
		if(data[i].curStage >= 1000 && (quests[i] === undefined || quests[i].curStage < 1000)){
			newNotification("Quest Completed: " + data[i].title);
		}
		
		for(var q in data[i]["stages"]){
			if(data[i]["stages"][q].state > -1 && (quests[i] === undefined || data[i]["stages"][q].state  > quests[i]["stages"][q].state)){
				
				if(data[i]["stages"][q].state == 0){
					newNotification("New Objective: " + data[i]["stages"][q].text);
				}
				else if(data[i]["stages"][q].state == 1){
					newNotification("Objective Completed: " + data[i]["stages"][q].text);
				}
			}
		}
	}
}

//callback function, when the quest nettable changes
function onQuestChange(table, key, data)
{
	if(key == "questList"){
		checkChanges(data);
		quests = data;
	}
}	


(function(){
	CustomNetTables.SubscribeNetTableListener("quest", onQuestChange);
})();