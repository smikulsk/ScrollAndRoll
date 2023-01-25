local Joystick = {}

local joystickMidX, joystickBaseSize, joystickSize = 0, 305, 143;

local sheetOptions =
{
    frames =
    {
        {   -- 1) base
            x = 48,
            y = 36,
            width = 305,
            height = 305
        },
		{   -- 2) stick
            x = 129,
            y = 740,
            width = 143,
            height = 143
        },
	}
}
local objectSheet = graphics.newImageSheet( "JoystickPack.png", sheetOptions )

local joystick

local function dragJoystick( event )
 
    local ship = event.target
    local phase = event.phase

	if ( "began" == phase ) then
        -- Set touch focus on the joystick
        display.currentStage:setFocus( joystick )
		-- Store initial offset position
        ship.touchOffsetX = event.x - joystick.x
    elseif ( "moved" == phase ) then
        -- Move the joystick to the new touch position
        joystick.x = math.max(
			math.min(
				event.x - joystick.touchOffsetX, 
				joystickMidX + (joystickBaseSize - joystickSize)/2
			), 
			joystickMidX - (joystickBaseSize - joystickSize)/2
		)
    elseif ( "ended" == phase or "cancelled" == phase ) then
        -- Release touch focus on the ship
        display.currentStage:setFocus( nil )
		joystick.x = joystickMidX
    end

	Joystick.eventDispatcher:dispatchEvent({ name ="joystickMoved", xDiff = joystick.x - joystickMidX})
	
	return true  -- Prevents touch propagation to underlying objects
end

Joystick.create = function(uiGroup, screenH)
    local joystick_base = display.newImageRect( uiGroup, objectSheet, 1, joystickBaseSize, joystickBaseSize )
	joystick_base.x, joystick_base.y = 0, screenH - joystickBaseSize/2 - 50

	joystick = display.newImageRect( uiGroup, objectSheet, 2, joystickSize, joystickSize )
	joystick.x, joystick.y = joystickMidX, screenH - joystickBaseSize/2 - 50

    joystick:addEventListener( "touch", dragJoystick )    
end

Joystick.eventDispatcher = system.newEventDispatcher()

return Joystick