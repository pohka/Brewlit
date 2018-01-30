var currentCameraSettings =  {
	pitch : 60,
	yaw : 0,
	height : 100,
	distance : 1134
}

//camera angle presets
var presets = {
	front : {
		pitch : 0.1,
		yaw : 0,
		height : 80,
		distance : 1134
	},
	thirdPerson : {
		pitch : 30,
		yaw : 0,
		height : 80,
		distance : 600
	},
	thirdPersonAlt : {
		pitch : 45,
		yaw : 0,
		height : 100,
		distance : 750
	},
	top : {
		pitch : 90,
		yaw : 0,
		height : 0,
		distance : 1200
	},
	"default" : {
		pitch : 60,
		yaw : 0,
		height : 100,
		distance : 1134
	},
	inverted : {
		pitch : 60,
		yaw : 180,
		height : 100,
		distance : 1134
	},
	right : {
		pitch : 60,
		yaw : 90,
		height : 100,
		distance : 1134
	},
	left : {
		pitch : 60,
		yaw : 270,
		height : 100,
		distance : 1134
	},
}

//applies the setting for the camera for this player
function setCamera(settings)
{
	GameUI.SetCameraPitchMin(settings.pitch)
	GameUI.SetCameraPitchMax(settings.pitch)
	GameUI.SetCameraYaw(settings.yaw)
	GameUI.SetCameraLookAtPositionHeightOffset(settings.height)
	GameUI.SetCameraDistance(settings.distance)
	
	currentCameraSettings = settings;
}

//update the setting for the camera
function UpdateSettings(table_name, key, data)
{
	var playerID = "" + Players.GetLocalPlayer()
	if(key === playerID || key === "global")
	{
		if(data.yaw !== undefined){
			GameUI.SetCameraYaw(data.yaw)
			currentCameraSettings.yaw = data.yaw;
		}
		
		if(data.zoom !== undefined){
			GameUI.SetCameraDistance(data.zoom)
			currentCameraSettings.zoom = data.zoom;
		}
		
		if(data.height !== undefined){
			GameUI.SetCameraLookAtPositionHeightOffset(data.height)
			currentCameraSettings.height = data.height;
		}
		
		if(data.pitch !== undefined){
			GameUI.SetCameraPitchMin(data.pitch)
			GameUI.SetCameraPitchMax(data.pitch)
			currentCameraSettings.pitch = data.pitch;
		}
	}
}


//set the camera to one of the presets
function SetCameraType(table_name, key, data)
{
	var playerID = "" + Players.GetLocalPlayer()
	
	if(key === playerID)
	{
		var preset
		switch(data.camType){
			case "top" 					: preset = presets["top"]; 				break;
			case "front" 				: preset = presets["font"]; 			break;
			case "third_person" 		: preset = presets["thirdPerson"]; 		break;
			case "third_person_alt" 	: preset = presets["thirdPersonAlt"]; 	break;
			case "default" 				: preset = presets["default"]; 			break;
			case "inverted" 			: preset = presets["inverted"]; 		break;
			case "right" 				: preset = presets["right"]; 			break;
			case "left" 				: preset = presets["left"]; 			break;
		}
		
		if(preset !== undefined){
			setCamera(settings);
		}
	}
}


(function()
{
	CustomNetTables.SubscribeNetTableListener("camera", UpdateSettings);	
	CustomNetTables.SubscribeNetTableListener("camera_type", SetCameraType);
})();