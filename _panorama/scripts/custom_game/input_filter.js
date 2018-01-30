//setting this to false will allow the player to zoom the camera in and out
var DISBALE_CAMERA_ZOOM = true;

//set to true to enabled the camera to be rotated on the world up axis from the scroll wheel input
var ENABLE_SCROLL_ROTATE = false;


/*
inputType : val description
---------------------------
pressed : mouse button pressed (0 = left, 1 = right, 2 = middle, ..)
doublepressed : mouse button pressed
wheeled : scroll wheel used (1 = scroll up, -1 = scroll down) 

note: using the scroll wheel will trigger both pressed and wheeled inputTypes. For me scroll wheel is key 5 and 6


Click Behaviors
----------------------
0 = no behavior (clicked anywhere in viewport except for the HUD)
1 = clicked in viewport (this could be an move/attack command)
2 = a click (attack key was pressed before the moused click)
3 = cast ability or item (if an ability hotkey was pressed before the click)

returning true will prevent the default functionality of the mouse input
*/
function mouseInputFilter(inputType, val)
{
	var pos = GameUI.GetScreenWorldPosition();
	var behavior = GameUI.GetClickBehaviors();
	
	//add custom targeting here e.g. vector targeting
	
	//scroll functionality
	if(	inputType === "wheeled" || 
		(inputType === "pressed" && (val == 5 || val == 6))){
			
			if(ENABLE_SCROLL_ROTATE == true && inputType === "wheeled"){
				var yawChange = val*5;
				currentCameraSettings.yaw += yawChange;
				GameUI.SetCameraYaw(currentCameraSettings.yaw);
			}
		
		
		return DISBALE_CAMERA_ZOOM;
	}
}

(function()
{
	GameUI.SetMouseCallback(mouseInputFilter);
})();