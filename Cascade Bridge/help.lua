
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local info = composer.getVariable( "info" )

-- Require the SQLite library
local sqlite3 = require( "sqlite3" )
 
-- Create a file path for the database file "data.db"
local path = system.pathForFile( "extras.db", system.DocumentsDirectory )
-- Open the database for access
local db = sqlite3.open( path )

local function gotoMenu()
	composer.gotoScene( "menu", { time=800, effect="slideDown" } )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
    local background = display.newImageRect( sceneGroup, "waterfall.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    --local highScoresHeader = display.newText( sceneGroup, "Planks", display.contentCenterX, 100, native.systemFont, 44 )
	
	local monkeyHeader = display.newText( sceneGroup, "New Life\nIncreases lives by 1", display.contentCenterX-27, 210, native.systemFont, 30 )
	local ninjaHeader = display.newText( sceneGroup, "Times Three Multiplier\nFor the next three shots,\nthree projectiles shoot out", display.contentCenterX+11, 360, native.systemFont, 30 )
	local ninjaHeader = display.newText( sceneGroup, "TNT\nDestroys random plank", display.contentCenterX-5, 500, native.systemFont, 30 )
	local basketHeader = display.newText( sceneGroup, "Coin\nUsed as currency\nHave to be personally collected", display.contentCenterX+50, 650, native.systemFont, 30 )
	
	local helpHeader = display.newText( sceneGroup, "Help", display.contentCenterX, 100, native.systemFont, 44 )
	
	local movement = display.newText( sceneGroup, "Slide your character to move", display.contentCenterX, 790, native.systemFont, 28 )
	local shoot = display.newText( sceneGroup, "Tap the character to shoot projectiles", display.contentCenterX, 830, native.systemFont, 28 )
    
	local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 950, native.systemFont, 44 )
	menuButton:setFillColor( 0.82, 0.86, 1 )
	
	local newLife = display.newImageRect( sceneGroup, info[3], 200, 200 )
	newLife.x = display.contentCenterX - 250
	newLife.y = 210
	
    local times3 = display.newImageRect( sceneGroup, "x3.png", 153, 85 )
	times3.x = display.contentCenterX - 250
	times3.y = 360
	
	local tnt = display.newImageRect( sceneGroup, "tnt.png", 153, 85 )
	tnt.x = display.contentCenterX - 250
	tnt.y = 510
	
	local coin = display.newImageRect( sceneGroup, "coin.png", 153, 85 )
	coin.x = display.contentCenterX - 250
	coin.y = 660
		
    menuButton:addEventListener( "tap", gotoMenu )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
		composer.removeScene( "skins" )
	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
