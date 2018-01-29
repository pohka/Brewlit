
//side view
function useCameraFront()
{
	GameUI.SetCameraPitchMin(0.1)
	GameUI.SetCameraPitchMax(0.1)
	GameUI.SetCameraLookAtPositionHeightOffset(80)
	GameUI.SetCameraDistance(600)
}

//3rd person
function useCameraThirdPerson()
{
	GameUI.SetCameraPitchMin(30)
	GameUI.SetCameraPitchMax(30)
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(750)
	GameUI.SetCameraYaw(0)
}

//alternative 3rd person 
function useCameraThirdPersonAlt()
{
	GameUI.SetCameraPitchMin(45)
	GameUI.SetCameraPitchMax(45)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraLookAtPositionHeightOffset(0)
	GameUI.SetCameraYaw(0)
}

//top down view
function useCameraTop()
{
	GameUI.SetCameraPitchMin(90)
	GameUI.SetCameraPitchMax(90)
	GameUI.SetCameraLookAtPositionHeightOffset(0)
	GameUI.SetCameraDistance(1200)
	GameUI.SetCameraYaw(0)
}

//default dota camera
function useCameraDefault()
{
	GameUI.SetCameraPitchMin(60)
	GameUI.SetCameraPitchMax(60)
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(0)
}

//default dota camera
function useCameraInverted()
{
	GameUI.SetCameraPitchMin(60)
	GameUI.SetCameraPitchMax(60)
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(180)
	GameUI.SetCameraYaw(0)
}

//right view
function useCameraRight()
{
	GameUI.SetCameraPitchMin(60)
	GameUI.SetCameraPitchMax(60)
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(90)
}

//eft view
function useCameraLeft()
{
	GameUI.SetCameraPitchMin(60)
	GameUI.SetCameraPitchMax(60)
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(270)
}

//update the setting for the camera
function UpdateSettings(table_name, key, data)
{
	var playerID = "" + Players.GetLocalPlayer()
	if(key === playerID)
	{
		if(data.yaw !== undefined){
			GameUI.SetCameraYaw(data.yaw)
		}
		
		if(data.zoom !== undefined){
			GameUI.SetCameraDistance(data.zoom)
		}
		
		if(data.height !== undefined){
			GameUI.SetCameraLookAtPositionHeightOffset(data.height)
		}
		
		if(data.pitch !== undefined){
			GameUI.SetCameraPitchMin(data.pitch)
			GameUI.SetCameraPitchMax(data.pitch)
		}
	}
}

//set the camera to one of the presets
function SetCameraType(table_name, key, data)
{
	var playerID = "" + Players.GetLocalPlayer()
	if(key === playerID)
	{
		switch(data.camType){
			case "top" 					: useCameraTop(); 				break;
			case "font" 				: useCameraFront(); 			break;
			case "third_person" 		: useCameraThirdPerson(); 		break;
			case "third_person_alt" 	: useCameraThirdPersonAlt(); 	break;
			case "default" 				: useCameraDefault(); 			break;
			case "inverted" 			: useCameraInverted(); 			break;
			case "right" 				: useCameraRight(); 			break;
			case "left" 				: useCameraLeft(); 				break;
		}
	}
}


(function()
{
	CustomNetTables.SubscribeNetTableListener("camera", UpdateSettings);	
	CustomNetTables.SubscribeNetTableListener("camera_type", SetCameraType);
})();