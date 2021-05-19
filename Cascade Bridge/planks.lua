
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

local function selectWood()
	if info[5] == "wood_plank.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM planks" ) do
			if row.Name == "wood_plank.png" then
				for row in db:nrows( "SELECT * FROM planks" ) do
					if row.Equipped == 1 then
						local a = [[UPDATE planks SET Equipped=0 WHERE PLANKID=id;]]
						db:exec( a )
						break
					end
					id = id + 1
				end
						
				local b = [[UPDATE planks SET Equipped=1 WHERE PLANKID=1;]]
				db:exec( b )
				
				info[5] = "wood_plank.png"
				composer.setVariable( "info", info )
				gotoMenu()
				break
			end	
		end
	end
end

local function selectIron()
	if info[5] == "iron_plank.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM planks" ) do
			if row.Name == "iron_plank.png" then
				if row.Own == 1 then
					for row in db:nrows( "SELECT * FROM planks" ) do
						if row.Equipped == 1 then
							local a = [[UPDATE planks SET Equipped=0 WHERE PLANKID=id;]]
							db:exec( a )
							break
						end
						id = id + 1
					end
						
					local b = [[UPDATE planks SET Equipped=1 WHERE PLANKID=2;]]
					db:exec( b )
					
					info[5] = "iron_plank.png"
					composer.setVariable( "info", info )
					gotoMenu()
					break
				else
					if  info[2] - 10 >= 0 or currency[1] - 10 >= 0 then
						for row in db:nrows( "SELECT * FROM planks" ) do
							if row.Equipped == 1 then
								local c = [[UPDATE planks SET Equipped=0 WHERE PLANKID=id;]]
								db:exec( c )
								break
							end
							id = id + 1
						end
						
						local q = [[UPDATE planks SET Equipped=1 WHERE PLANKID=2;]]
						db:exec( q )
						q = [[UPDATE planks SET Own=1 WHERE PLANKID=2;]]
						db:exec( q )
						
						q = [[UPDATE coins SET Num=(info[2] - 10) WHERE COINID=1;]]
						db:exec( q )
						
						info[5] = "iron_plank.png"
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

local function selectMarshmellow()
	if info[5] == "marshmellow_plank.png" then
	else
		local id = 1 
	-- Loop through database table rows via a SELECT query
		for row in db:nrows( "SELECT * FROM planks" ) do
			if row.Name == "marshmellow_plank.png" then
				if row.Own == 1 then
					for row in db:nrows( "SELECT * FROM planks" ) do
						if row.Equipped == 1 then
							local a = [[UPDATE planks SET Equipped=0 WHERE PLANKID=id;]]
							db:exec( a )
							break
						end
						id = id + 1
					end
						
					local b = [[UPDATE planks SET Equipped=1 WHERE PLANKID=3;]]
					db:exec( b )
					
					info[5] = "marshmellow_plank.png"
					composer.setVariable( "info", info )
					gotoMenu()
					break
				else
					if info[2] - 25 >= 0 or currency[1] - 25 >= 0 then
						for row in db:nrows( "SELECT * FROM planks" ) do
							if row.Equipped == 1 then
								local c = [[UPDATE planks SET Equipped=0 WHERE PLANKID=id;]]
								db:exec( c )
								break
							end
							id = id + 1
						end
						
						local q = [[UPDATE planks SET Equipped=1 WHERE PLANKID=3;]]
						db:exec( q )
						q = [[UPDATE planks SET Own=1 WHERE PLANKID=3;]]
						db:exec( q )
						
						q = [[UPDATE coins SET Num=(info[2] - 25) WHERE COINID=1;]]
						db:exec( q )
						
						info[5] = "marshmellow_plank.png"
						info[2] = info[2] - 25
						
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
	
	local woodHeader = display.newText( sceneGroup, "Wooden Planks:\n1 collision", display.contentCenterX-50, 200, native.systemFont, 30 )
    local ironHeader = display.newText( sceneGroup, "Iron Planks:\n5 collisions\n10 coins", display.contentCenterX-75, 450, native.systemFont, 30 )
    local marshmellowScoresHeader = display.newText( sceneGroup, "Marshmellow Planks:\nIncreases recoil\n25 coins", display.contentCenterX-15, 700, native.systemFont, 30 )

	local extrasButton = display.newText( sceneGroup, "Extras", display.contentCenterX, 850, native.systemFont, 44 )
	extrasButton:setFillColor( 0.82, 0.86, 1 )
	
	local selW = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selW.x = display.contentCenterX + 190
	selW.y = 200
	local selI = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selI.x = display.contentCenterX + 190
	selI.y = 450
	local selM = display.newImageRect( sceneGroup, "select.png", 200, 100 )
	selM.x = display.contentCenterX + 190
	selM.y = 715
	
    local wood = display.newImageRect( sceneGroup, "wood_plank.png", 77, 150 )
	wood.x = display.contentCenterX - 250
	wood.y = 200
	
	local iron = display.newImageRect( sceneGroup, "iron_plank.png", 77, 150 )
	iron.x = display.contentCenterX - 250
	iron.y = 450
	
	local marshmellow = display.newImageRect( sceneGroup, "marshmellow_plank.png", 77, 150 )
	marshmellow.x = display.contentCenterX - 250
	marshmellow.y = 700
	if (type(currency[1]) == 'number') then
		local coinsText = display.newText( sceneGroup, "Coins: " .. currency[1], 375, 80, native.systemFont, 36 )
	else
		local coinsText = display.newText( sceneGroup, "Coins: " .. info[2], 375, 80, native.systemFont, 36 )
	end
	
    extrasButton:addEventListener( "tap", gotoExtras )
	selW:addEventListener( "tap", selectWood )
	selI:addEventListener( "tap", selectIron )
	selM:addEventListener( "tap", selectMarshmellow )

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
		composer.removeScene( "planks" )
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
