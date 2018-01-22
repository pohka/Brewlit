-- Generated from template

if BrewlitGameMode == nil then
	_G.BrewlitGameMode = class({})
end


if Brewlit == nil then
	_G.Brewlit = class ({})
end

require('main')
require('brewlit/setup')
require('brewlit/event')
require('brewlit/game_state_manager')


_G.debugging = true

function Precache( context )
	--[[
		Precache things we know we'll use.  Possible file types include (but not limited to):
			PrecacheResource( "model", "*.vmdl", context )
			PrecacheResource( "soundfile", "*.vsndevts", context )
			PrecacheResource( "particle", "*.vpcf", context )
			PrecacheResource( "particle_folder", "particles/folder", context )
	]]
end

-- Create the game mode when we activate
function Activate()
	GameRules.AddonTemplate = BrewlitGameMode()
	GameRules.AddonTemplate:InitGameMode()
end

function BrewlitGameMode:InitGameMode()
	ListenToGameEvent("game_rules_state_change", GameStateManager.OnChangeState, nil)
	Brewlit:Start()
end
