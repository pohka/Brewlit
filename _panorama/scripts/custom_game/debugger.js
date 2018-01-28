var currentFilter = "all"; //current log filter type
var filterOptions = ["all", "default", "error", "event"]; //different log filter options
var logTable = [] //all the logs in a table of json objects
var maxLogs = 30;

//clears the logTable
function clearLogs()
{
	logTable = [];
	$("#debugger-msgs").RemoveAndDeleteChildren()
}

//logs a message
function log(msg, type)
{
	logTable.unshift({"msg" : msg, "type" : type});
	while(logTable.length >= maxLogs){
		logTable.splice(-1,1);
	}
	refreshLogs();
}

//refreshes the logs using logTable
function refreshLogs()
{
	$("#debugger-msgs").RemoveAndDeleteChildren()
	for(var i=0; i<logTable.length; i++){
		if(currentFilter === "all" || currentFilter === logTable[i].type){
			var panel = $.CreatePanel("Panel", $("#debugger-msgs"), "");
			panel.AddClass("debugger-msg");
			panel.AddClass("debug-"+logTable[i].type);
			var label = $.CreatePanel("Label", panel, "");
			label.text = logTable[i].msg;
		}
	}
}

//send pause command to server
function pause()
{
	GameEvents.SendCustomGameEventToServer( "debug", { "command" : "pause" } );
}

//todo: show api tab
function showAPI()
{
	$.Msg("todo");
	log("API tab not finished", "error");
}

//toggles different log filters
function filterToggle()
{
	var index = filterOptions.indexOf(currentFilter) + 1;
	if(index >= filterOptions.length){
		index = 0;
	}
	currentFilter = filterOptions[index];
	
	var type = currentFilter.charAt(0).toUpperCase() + currentFilter.substr(1);
	$("#filter-text").text = "Filter: " + type;
	refreshLogs();
}

//closes the debugger and shows the button
function closeDebugger()
{
	$("#debugger").AddClass("hidden");
	$("#show-debugger-btn").style.height = "100%";
	$.GetContextPanel().style.width = "50px";
	$.GetContextPanel().style.height = "50px";
	$.GetContextPanel().style.marginTop = "200px";
}

//shows the debugger and hides the button
function showDebugger()
{
	$("#debugger").RemoveClass("hidden");
	$("#show-debugger-btn").style.height = "0px";
	$.GetContextPanel().style.width = "600px";
	$.GetContextPanel().style.height = "600px";
	$.GetContextPanel().style.marginTop = "120px";
}

//starting point
//subscribe to the debug nettable and log messages from the changes
(function()
{
	CustomNetTables.SubscribeNetTableListener("debug", function(table, key, data){
		log(data["msg"], data["logType"]);
	});
})();

