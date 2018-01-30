
if Input == nil then
	Input = class({})
end

--[[
called every time input is updated on the client

return table:
input.playerid : playerid of this input
input.move_x : horizontal input (-1, 0 or 1) i.e arrow left and right keys
input.move_y : vertical input (-1, 0 or 1) i.e. arrow up and down keys
input.cursor_raw_x : cursor horizonal position (value from -1 to 1 and 0 is center) 
input.cursor_raw_y : cursor vertical position (value from -1 to 1 and zero is center) 

Note: To remove/change direction input keys change addoninfo.txt. There is a sample for WASD directional input

this calls Brewlit.OnInput() if it exists with the input which is currently been listened to
]]
function Input:Update(input)
	if input.playerid ~= -1 then
		if Brewlit.OnInput ~= nil then
			Brewlit:OnInput(input)
		end
	end
end

--enable/disable listening to direction input
function Input:ListenToDirectionalInput(enabled)
	CustomNetTables:SetTableValue("input", "directional", { enabled = enabled })
end

--enable/disable listening to the cursor position
function Input:ListenToCursorRawInput(enabled)
	CustomNetTables:SetTableValue("input", "cursor_raw", { enabled = enabled })
end