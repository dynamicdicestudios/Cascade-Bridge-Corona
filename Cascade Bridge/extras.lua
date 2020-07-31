
local composer = require( "composer" )

local scene = composer.newScene()

local info = composer.getVariable( "info" )

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoSkins()
	composer.gotoScene( "skins", { time=800, effect="slideUp" } )
end

local function gotoPlanks()
	composer.setVariable( "info", info )
	composer.gotoScene( "planks", { time=800, effect="slideUp" } )
end

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

	local title = display.newImageRect( sceneGroup, "maybe.png", 500, 100 )
	title.x = display.contentCenterX
	title.y = 200

	local skinsButton = display.newText( sceneGroup, "Skins", display.contentCenterX, 600, native.systemFont, 44 )
	skinsButton:setFillColor( 0.82, 0.86, 1 )
	
	local planksButton = display.newText( sceneGroup, "Planks", display.contentCenterX, 700, native.systemFont, 44 )
	planksButton:setFillColor( 0.82, 0.86, 1 )
	
	local menuButton = display.newText( sceneGroup, "Menu", display.contentCenterX, 800, native.systemFont, 44 )
	menuButton:setFillColor( 0.82, 0.86, 1 )

	skinsButton:addEventListener( "tap", gotoSkins )
	planksButton:addEventListener( "tap", gotoPlanks )
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
		composer.removeScene( "store" )
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
