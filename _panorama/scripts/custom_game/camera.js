
//side view
function useCameraSideView()
{
	GameUI.SetCameraPitchMin( 0.1 )
	GameUI.SetCameraPitchMax( 0.1 )
	GameUI.SetCameraLookAtPositionHeightOffset(80)
	GameUI.SetCameraDistance(600)
}

//3rd person
function useCameraThirdPerson()
{
	GameUI.SetCameraPitchMin( 30 )
	GameUI.SetCameraPitchMax( 30 )
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(750)
	GameUI.SetCameraYaw(0)
}

//alternative 3rd person 
function useCameraThirdPersonAlt()
{
	GameUI.SetCameraPitchMin( 45 )
	GameUI.SetCameraPitchMax( 45 )
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraLookAtPositionHeightOffset(0)
	GameUI.SetCameraYaw(0)
}

//top down view
function useCameraTop()
{
	GameUI.SetCameraPitchMin( 90 )
	GameUI.SetCameraPitchMax( 90 )
	GameUI.SetCameraLookAtPositionHeightOffset(0)
	GameUI.SetCameraDistance(1200)
	GameUI.SetCameraYaw(0)
}

//default dota camera
function useCameraDefault()
{
	GameUI.SetCameraPitchMin( 60 )
	GameUI.SetCameraPitchMax( 60 )
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(0)
}

//default dota camera
function useCameraInverted()
{
	GameUI.SetCameraPitchMin( 60 )
	GameUI.SetCameraPitchMax( 60 )
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(180)
	GameUI.SetCameraYaw(0)
}

//right view
function useCameraRight()
{
	GameUI.SetCameraPitchMin( 60 )
	GameUI.SetCameraPitchMax( 60 )
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(90)
}

//eft view
function useCameraLeft()
{
	GameUI.SetCameraPitchMin( 60 )
	GameUI.SetCameraPitchMax( 60 )
	GameUI.SetCameraLookAtPositionHeightOffset(100)
	GameUI.SetCameraDistance(1134)
	GameUI.SetCameraYaw(270)
}


(function()
{
	//CustomNetTables.SubscribeNetTableListener("camera", SetYaw);
	
	useCameraThirdPersonAlt()
})();