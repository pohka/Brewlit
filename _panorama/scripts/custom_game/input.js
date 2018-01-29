//current state of the custom input
var USE_DIRECTIONAL_INPUT = false;
var USE_CURSOR_INPUT = false;

/*
	stores values for input
	direction values are always -1, 0 or 1
*/
var inputBuffer = {
	up : 0,
	down : 0,
	left : 0,
	right : 0
};

var lastTableSent = {}

//callback functions for keybinds which update the input buffer
function UpPressed(){ inputBuffer["up"] = 1; }
function UpReleased(){ inputBuffer["up"] = 0; }
function DownPressed(){ inputBuffer["down"] = 1; }
function DownReleased(){ inputBuffer["down"] = 0; }
function LeftPressed(){ inputBuffer["left"] = 1; }
function LeftReleased(){ inputBuffer["left"] = 0; }
function RightPressed(){ inputBuffer["right"] = 1; }
function RightReleased(){ inputBuffer["right"] = 0; }

//convert cursor position into a float value form -1 to 1, with 0 being the center of the axis
function getMousePos()
{
	var pos = {};
	var cursorPos = GameUI.GetCursorPosition();
	var halfScreenW = Game.GetScreenWidth() * 0.5;
	var halfScreenH = Game.GetScreenHeight() * 0.5;
	pos.x = (cursorPos[0] - halfScreenW) / halfScreenW;
	pos.y = -(cursorPos[1] - halfScreenH) / halfScreenH;
	return pos;
}

//sends input to server each frame
function SendInput()
{
	var playerID = Players.GetLocalPlayer()
	
	//input table for this player
	var table = {
		playerid : playerID
	};
	
	
	if(USE_DIRECTIONAL_INPUT){
		table["move_x"] = inputBuffer["right"] - inputBuffer["left"];
		table["move_y"] = inputBuffer["up"] - inputBuffer["down"];
	}
	
	
	if(USE_CURSOR_INPUT){
		var pos = getMousePos();
		table["cursor_x"] = pos.x;
		table["cursor_y"] = pos.y;
	}
	
	//only send updates to server if the input table has changed
	if((USE_DIRECTIONAL_INPUT || USE_CURSOR_INPUT) && inputTableHasChanged(table)){
		GameEvents.SendCustomGameEventToServer("input", table);
		lastTableSent = table
	}
	$.Schedule(0.03, SendInput);
}

//returns true if the given table doesn't match the last sent table
function inputTableHasChanged(table)
{
	var tableKeys = Object.keys(table)
	var lastTableKeys = Object.keys(lastTableSent)
	if(tableKeys.length !== lastTableKeys.length){
		return true;
	}
	
	for(var i in table){
		if(lastTableSent[i] === undefined || table[i] !== lastTableSent[i]){
			return true;
		}
	}
	return false;
}

//creates and event listener for each key command
function registerDirectionalInputKeys()
{
	Game.AddCommand( "+UpKey", UpPressed, "", 0 );
	Game.AddCommand( "-UpKey", UpReleased, "", 0 );
	Game.AddCommand( "+DownKey", DownPressed, "", 0 );
	Game.AddCommand( "-DownKey", DownReleased, "", 0 );
	Game.AddCommand( "+LeftKey", LeftPressed, "", 0 );
	Game.AddCommand( "-LeftKey", LeftReleased, "", 0 );
	Game.AddCommand( "+RightKey", RightPressed, "", 0 );
	Game.AddCommand( "-RightKey", RightReleased, "", 0 );
}

//updates the keybinds to listen to
function updateInputSettings(table, key, data)
{
	if(key === "directional"){
		USE_DIRECTIONAL_INPUT = data.enabled;
	}
	else if(key === "cursor"){
		USE_CURSOR_INPUT = data.enabled;
	}
}

(function()
{
	registerDirectionalInputKeys();
	
	CustomNetTables.SubscribeNetTableListener("input", updateInputSettings);
	
	SendInput()
})();