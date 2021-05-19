
local composer = require( "composer" )

local scene = composer.newScene()

local info = composer.getVariable( "info" )
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoGame()
	composer.gotoScene( "game", { time=200, effect="crossFade" } )
	composer.setVariable( "info", info )
end

local function gotoExtras()
	composer.gotoScene( "extras", { time=500, effect="slideUp" } )
	composer.setVariable( "info", info )
end

local function gotoHighScores()
	composer.gotoScene( "highscores", { time=500, effect="slideUp" } )
	composer.setVariable( "info", info )
end

local function gotoHelp()
	composer.gotoScene( "help", { time=500, effect="slideUp" } )
	composer.setVariable( "info", info )
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

	local title = display.newImageRect( sceneGroup, "maybe.png", 400, 90 )
	title.x = display.contentCenterX
	title.y = 200

	local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 600, native.systemFont, 44 )
	playButton:setFillColor( 0.82, 0.86, 1 )
	
	local extrasButton = display.newText( sceneGroup, "Extras", display.contentCenterX, 700, native.systemFont, 44 )
	extrasButton:setFillColor( 0.82, 0.86, 1 )
	
	local highScoreButton = display.newText( sceneGroup, "Highscore", display.contentCenterX, 800, native.systemFont, 44 )
	highScoreButton:setFillColor( 0.82, 0.86, 1 )
	
	local helpButton = display.newText( sceneGroup, "Help", display.contentCenterX, 900, native.systemFont, 44 )
	helpButton:setFillColor( 0.82, 0.86, 1 )

	playButton:addEventListener( "tap", gotoGame )
	extrasButton:addEventListener( "tap", gotoExtras )
	highScoreButton:addEventListener( "tap", gotoHighScores )
	helpButton:addEventListener("tap", gotoHelp)

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
