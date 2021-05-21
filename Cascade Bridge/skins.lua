
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

local json = require( "json" )

local currency = {0,}

local filePath = system.pathForFile( "coins.json", system.DocumentsDirectory )


local function loadCurrency()

	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read( "*a" )
		io.close( file )
		currency[1] = json.decode( contents )
	end

	if ( currency == nil or #currency == 0 ) then
		currency[1] =  {0}
	end
end


local function saveCurrency()

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( coins ) )
		io.close( file )
	end
end

local function gotoExtras()
	composer.gotoScene( "extras", { time=800, effect="slideDown" } )
end

local function gotoMenu()
	composer.gotoScene( "menu", { time=800, effect="slideDown" } )
end

local function selectMonkey()
	if info[3] == "monkey.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM characters" ) do
			if row.Name == "monkey.png" then
				for row in db:nrows( "SELECT * FROM characters" ) do
					if row.Equipped == 1 then
						local a = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
						db:exec( a )
						break
					end
					id = id + 1
				end
						
				local b = [[UPDATE characters SET Equipped=1 WHERE CHARID=1;]]
				db:exec( b )
				
				info[3] = "monkey.png"
				info[4] = "coconut.png"
				info[6] = 1
				composer.setVariable( "info", info )
				gotoMenu()
				break
			end	
		end
	end
end

local function selectNinja()
	if info[3] == "ninja.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM characters" ) do
			if row.Name == "ninja.png" then
				if row.Own == 1 then
					for row in db:nrows( "SELECT * FROM characters" ) do
						if row.Equipped == 1 then
							local a = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
							db:exec( a )
							break
						end
						id = id + 1
					end
						
					local b = [[UPDATE characters SET Equipped=1 WHERE CHARID=2;]]
					db:exec( b )
					
					info[3] = "ninja.png"
					info[4] = "star.png"
					info[6] = 2
					composer.setVariable( "info", info )
					gotoMenu()
					break
				else
					if info[2] - 10 >= 0 or currency[1] - 10 >= 0 then
						for row in db:nrows( "SELECT * FROM characters" ) do
							if row.Equipped == 1 then
								local c = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
								db:exec( c )
								break
							end
							id = id + 1
						end
						
						local q = [[UPDATE characters SET Equipped=1 WHERE CHARID=2;]]
						db:exec( q )
						q = [[UPDATE characters SET Own=1 WHERE CHARID=2;]]
						db:exec( q )
						
						q = [[UPDATE coins SET Num=(info[2] - 10) WHERE COINID=1;]]
						db:exec( q )
						
						info[3] = "ninja.png"
						info[4] = "star.png"
						info[6] = 2
						info[2] = info[2] - 10
						currency[1] = info[2]
						saveCurrency()
						composer.setVariable( "info", info )
						gotoMenu()
						break
					end
				end				
			end
		end
	end
end

local function selectWizard()
	if info[3] == "wizard.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM characters" ) do
			if row.Name == "wizard.png" then
				if row.Own == 1 then
					for row in db:nrows( "SELECT * FROM characters" ) do
						if row.Equipped == 1 then
							local a = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
							db:exec( a )
							break
						end
						id = id + 1
					end
						
					local b = [[UPDATE characters SET Equipped=1 WHERE CHARID=3;]]
					db:exec( b )
					
					info[3] = "wizard.png"
					info[4] = "fire.png"
					info[6] = 2
					composer.setVariable( "info", info )
					gotoMenu()
					break
				else
					if info[2] - 20 >= 0 or currency[1] - 20 >= 0 then
						for row in db:nrows( "SELECT * FROM characters" ) do
							if row.Equipped == 1 then
								local c = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
								db:exec( c )
								break
							end
							id = id + 1
						end
						
						local q = [[UPDATE characters SET Equipped=1 WHERE CHARID=3;]]
						db:exec( q )
						q = [[UPDATE characters SET Own=1 WHERE CHARID=3;]]
						db:exec( q )
						
						q = [[UPDATE coins SET Num=(info[2] - 20) WHERE COINID=1;]]
						db:exec( q )
						
						info[3] = "wizard.png"
						info[4] = "fire.png"
						info[6] = 2
						info[2] = info[2] - 20
						currency[1] = info[2]
						saveCurrency()
						composer.setVariable( "info", info )
						gotoMenu()
						break
					end
				end				
			end
		end
	end
end

local function selectBasket()
	if info[3] == "bplayer.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM characters" ) do
			if row.Name == "bplayer.png" then
				if row.Own == 1 then
					for row in db:nrows( "SELECT * FROM characters" ) do
						if row.Equipped == 1 then
							local a = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
							db:exec( a )
							break
						end
						id = id + 1
					end
						
					local b = [[UPDATE characters SET Equipped=1 WHERE CHARID=4;]]
					db:exec( b )
					
					info[3] = "bplayer.png"
					info[4] = "ball.png"
					info[6] = 3
					composer.setVariable( "info", info )
					gotoMenu()
					break
				else
					if info[2] - 35 >= 0 or currency[1] - 35 >= 0 then
						for row in db:nrows( "SELECT * FROM characters" ) do
							if row.Equipped == 1 then
								local c = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
								db:exec( c )
								break
							end
							id = id + 1
						end
						
						local q = [[UPDATE characters SET Equipped=1 WHERE CHARID=4;]]
						db:exec( q )
						q = [[UPDATE characters SET Own=1 WHERE CHARID=4;]]
						db:exec( q )
						
						q = [[UPDATE coins SET Num=(info[2] - 35) WHERE COINID=1;]]
						db:exec( q )
						
						info[3] = "bplayer.png"
						info[4] = "ball.png"
						info[6] = 3
						info[2] = info[2] - 35
						currency[1] = info[2]
						saveCurrency()
						composer.setVariable( "info", info )
						gotoMenu()
						break
					end
				end				
			end
		end
	end
end

local function selectGolf()
	if info[3] == "gplayer.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM characters" ) do
			if row.Name == "gplayer.png" then
				if row.Own == 1 then
					for row in db:nrows( "SELECT * FROM characters" ) do
						if row.Equipped == 1 then
							local a = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
							db:exec( a )
							break
						end
						id = id + 1
					end
						
					local b = [[UPDATE characters SET Equipped=1 WHERE CHARID=5;]]
					db:exec( b )
					
					info[3] = "gplayer.png"
					info[4] = "stick.png"
					info[6] = 3
					composer.setVariable( "info", info )
					gotoMenu()
					break
				else
					if info[2] - 40 >= 0 or currency[1] - 40 >= 0 then
						for row in db:nrows( "SELECT * FROM characters" ) do
							if row.Equipped == 1 then
								local c = [[UPDATE characters SET Equipped=0 WHERE CHARID=id;]]
								db:exec( c )
								break
							end
							id = id + 1
						end
						
						local q = [[UPDATE characters SET Equipped=1 WHERE CHARID=5;]]
						db:exec( q )
						q = [[UPDATE characters SET Own=1 WHERE CHARID=5;]]
						db:exec( q )
						
						q = [[UPDATE coins SET Num=(info[2] - 40) WHERE COINID=1;]]
						db:exec( q )
						
						info[3] = "gplayer.png"
						info[4] = "stick.png"
						info[6] = 3
						info[2] = info[2] - 40
						currency[1] = info[2]
						saveCurrency()
						composer.setVariable( "info", info )
						gotoMenu()
						break
					end
				end				
			end
		end
	end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen
	
	local q = [[UPDATE coins SET Num=info[2] WHERE COINID=1;]]
	db:exec( q )
	
	loadCurrency()
	
    local background = display.newImageRect( sceneGroup, "waterfall.png", 800, 1400 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    --local highScoresHeader = display.newText( sceneGroup, "Planks", display.contentCenterX, 100, native.systemFont, 44 )
	
	local monkeyHeader = display.newText( sceneGroup, "Cheeky Monkey\n1 life", display.contentCenterX-82, 190, native.systemFont, 30 )
	local ninjaHeader = display.newText( sceneGroup, "Silent Ninja\n10 coins to purchase\n2 lives", display.contentCenterX-50, 340, native.systemFont, 30 )
	local ninjaHeader = display.newText( sceneGroup, "Uncanny Wizard\n20 coins to purchase\n2 lives", display.contentCenterX-50, 480, native.systemFont, 30 )
	local basketHeader = display.newText( sceneGroup, "Gifted Basketball Player\n35 coins to purchase\n3 lives", display.contentCenterX-30, 640, native.systemFont, 30 )
	local golfHeader = display.newText( sceneGroup, "Angry Golf Player\n40 coins to purchase\n3 lives", display.contentCenterX-50, 790, native.systemFont, 30 )
    
	local extrasButton = display.newText( sceneGroup, "Extras", display.contentCenterX, 950, native.systemFont, 44 )
	extrasButton:setFillColor( 0.82, 0.86, 1 )
	
	local selM = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selM.x = display.contentCenterX + 200
	selM.y = 200
	
	local selN = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selN.x = display.contentCenterX + 200
	selN.y = 350
	
	local selW = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selW.x = display.contentCenterX + 200
	selW.y = 500
	
	local selB = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selB.x = display.contentCenterX + 200
	selB.y = 650
	
	local selG = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selG.x = display.contentCenterX + 200
	selG.y = 800
	
	local monkey = display.newImageRect( sceneGroup, "monkey.png", 350, 350 )
	monkey.x = display.contentCenterX - 250
	monkey.y = 190
	
    local ninja = display.newImageRect( sceneGroup, "ninja.png", 350, 350 )
	ninja.x = display.contentCenterX - 250
	ninja.y = 340
	
	local wizard = display.newImageRect( sceneGroup, "wizard.png", 350, 350 )
	wizard.x = display.contentCenterX - 250
	wizard.y = 490
	
	local basket = display.newImageRect( sceneGroup, "bplayer.png", 350, 350 )
	basket.x = display.contentCenterX - 250
	basket.y = 640
	
	local golf = display.newImageRect( sceneGroup, "gplayer.png", 350, 350 )
	golf.x = display.contentCenterX - 250
	golf.y = 790
	
	if (type(currency[1]) == 'number') then 
		local coinsText = display.newText( sceneGroup, "Coins: " .. currency[1], 375, 80, native.systemFont, 36 )
	else
		local coinsText = display.newText( sceneGroup, "Coins: " .. info[2], 375, 80, native.systemFont, 36 )
	end	
	
    extrasButton:addEventListener( "tap", gotoExtras )
	selN:addEventListener( "tap", selectNinja )
	selG:addEventListener( "tap", selectGolf )
	selM:addEventListener( "tap", selectMonkey )
	selB:addEventListener( "tap", selectBasket )
	selW:addEventListener( "tap", selectWizard )
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
