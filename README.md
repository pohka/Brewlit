 # Brewlit #
 
 Dota 2 custom games library
 
 Current Features
------------------
* Setup - GameRules and GameMode setup
* GameStateManager - 
* GameTime - game mode time and night/day cycles
* Find - query units in the world
* Event - listen to the working game events
* Animation - apply and remove gestures with a priority queue
* Camera - preset camera angle and updating camera for each player
* Ability - spell casting info and different linear projectile presets 
* Helper - useful miscellaneous functions
* ItemManager - manage dropped items
* Input - custom input for sending cursor and directional input to the server
* PlayerHelper - helper functions for player entities
* Task - delay function calls or call functions at intervals
* Debugger UI - logging to a custom debugging UI in the HUD (not finished)
* HUD - server communicate with the HUD (not finished)
 
 Road Map
--------
* Debuger UI
  * API
  * option to start opened
  * fix bug with logging multiple msgs at once
  * input commands
* Find
  * units with modifier
* Quest System
* Simplify filters 
  * xp
  * gold
  * runes
  * unit
  * damage
  * projectile
  * execute order
  * inventory 
  * modifer gained
* GameMode mangement
  * custom states
  * rounds
  * custom clock
* Ability
  * charges
  * tracking projectiles
  * changing projectiles direction
  * spiral/arc projectiles
* AI
  * state
  *  state transitions
  * events
  * queue commands (such as path finding)
* Camera
  * set yaw and pitch with delay
  * more camera presets
    * forward follow
	* smooth forward follow
	* Disable all players for cutscenes
* Helper
  * move GetAllPlayers and GetAllPlayerIDs to PlayerHelper
* UI library
  * drop downs
  * checkboxes
  * dragging and dropping
* UI
  * Custom chat
  * overlays for minimap
  * overlay for new round
  * help/info
* Cosmetics
* Physics


