
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require "physics"
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
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
local speedText
local playerSpeed = 0

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

	playerSpeed = joystick.x - joystickMidX
	speedText.text = "Player speed: " .. playerSpeed
	print(speedText.text)
	
	return true  -- Prevents touch propagation to underlying objects
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
	physics.start()
	physics.pause()

	local backGroup = display.newGroup()  -- Display group for the background image
	--local mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	local uiGroup = display.newGroup()    -- Display group for UI objects like the score

	local background = display.newRect( backGroup, display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 0, 0, 0.5 )

	local joystick_base = display.newImageRect( uiGroup, objectSheet, 1, joystickBaseSize, joystickBaseSize )
	joystick_base.x, joystick_base.y = 0, screenH - joystickBaseSize/2 - 50

	joystick = display.newImageRect( uiGroup, objectSheet, 2, joystickSize, joystickSize )
	joystick.x, joystick.y = joystickMidX, screenH - joystickBaseSize/2 - 50

	speedText = display.newText( uiGroup, "Player speed: " .. playerSpeed, 200, 80, native.systemFont, 36 )
	
	sceneGroup:insert( backGroup )
	sceneGroup:insert( uiGroup )

	joystick:addEventListener( "touch", dragJoystick )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
		physics.start()
	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
		physics.stop()

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
	package.loaded[physics] = nil
	physics = nil

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
