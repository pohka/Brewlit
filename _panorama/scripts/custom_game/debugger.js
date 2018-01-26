

function clearLogs()
{
	$("#debugger-msgs").RemoveAndDeleteChildren()
}

function Log(msg, filter, isError)
{
	var panel = $.CreatePanel("Panel", $("#debugger-msgs"), "");
	panel.AddClass("debugger-msg");
	if(isError !== undefined && isError){
		panel.AddClass("debug-error");
	}
	var label = $.CreatePanel("Label", panel, "");
    label.text = msg;

}

function showAPI()
{
	$.Msg("todo");
}

var filterTypes = {
	"all" : 0,
	"default" : 1,
	"error" : 2,
	"events" : 3
};
function filterBy()
{	 
	var type = filterTypes["default"];
	var logs = $("#debugger-msgs").Children();
	$.Each(logs, function(log){
		log.RemoveClass("filtered-out");
		if(type === filterTypes["error"] && !log.BHasClass("debug-error")){
			log.AddClass("filtered-out");
		}
		else if(type == filterTypes["default"] && !log.BHasClass("debug-default")){
			log.AddClass("filtered-out");
		}
	});
}

function test( table_name, key, data )
{
	$.Msg( "here"); 
}

(function()
{
	CustomNetTables.SubscribeNetTableListener( "game", test );
})();

