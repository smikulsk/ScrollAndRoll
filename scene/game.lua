
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require("physics")
local joystick = require("ui.joystick")

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX
local speedText
local playerSpeed = 0

function joystickMoved(event)		
	playerSpeed = event.xDiff
	speedText.text = "Player speed: " .. playerSpeed
	print(speedText.text)		
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
	local uiGroup = display.newGroup()    -- Display group for UI objects like the score

	local background = display.newRect( backGroup, display.screenOriginX, display.screenOriginY, screenW, screenH )
	background.anchorX = 0 
	background.anchorY = 0
	background:setFillColor( 0, 0, 0.5 )

	joystick.create(uiGroup, screenH)

	speedText = display.newText( uiGroup, "Player speed: " .. playerSpeed, 200, 80, native.systemFont, 36 )

	sceneGroup:insert( backGroup )
	sceneGroup:insert( uiGroup )

	joystick.eventDispatcher:addEventListener("joystickMoved", joystickMoved)
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
