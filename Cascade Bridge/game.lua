
local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local physics = require( "physics" )
physics.start()

local info = composer.getVariable( "info" )

local path = system.pathForFile( "extras.db", system.DocumentsDirectory )
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
		currency = { 0 }
	end
end


local function saveCurrency()

	local file = io.open( filePath, "w" )

	if file then
		file:write( json.encode( currency[1] ) )
		io.close( file )
	end
end

-- Configure image sheet
local sheetOptions =
{
    frames =
    {
        {   -- 1) asteroid 1
            x = 0,
            y = 0,
            width = 102,
            height = 85
        },
        {   -- 2) asteroid 2
            x = 0,
            y = 85,
            width = 90,
            height = 83
        },
        {   -- 3) asteroid 3
            x = 0,
            y = 168,
            width = 100,
            height = 97
        },
        {   -- 4) ship
            x = 0,
            y = 265,
            width = 98,
            height = 79
        },
        {   -- 5) laser
            x = 98,
            y = 265,
            width = 14,
            height = 40
        },
    },
}
local objectSheet = graphics.newImageSheet( "gameObjects.png", sheetOptions )

-- Initialize variables
local lives = info[6]
local score = 0
local coins = 0
local died = false

local multiplier = 0

local asteroidsTable = {}
local planksTable = {}

local ship
local gameLoopTimer
local livesText
local scoreText
local coinsText


local backGroup
local mainGroup
local uiGroup


local function updateText()
	livesText.text = "Lives: " .. lives
	coinsText.text = "Coins: " .. coins
	scoreText.text = "Score: " .. score
end

local function createAsteroid()
	local size = math.random( 2 )
	
	if (size == 1) then
		local newAsteroid = display.newImageRect( mainGroup, objectSheet, 2, 102, 85 )
		table.insert( asteroidsTable, newAsteroid )
		if ( info[5] ~= "marshmellow_plank.png") then
			physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.6 } )
		else
			physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=1.2 } )
		end
		newAsteroid.gravityScale = 2
		newAsteroid.myName = "asteroid"
			
		local whereFrom = math.random( 6 )

		if ( whereFrom == 1 ) then
			newAsteroid.hits = 0
			-- From the left
			newAsteroid.x = -60
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( 40,120 ), math.random( 20,60 ) )
		elseif ( whereFrom == 2 ) then
			newAsteroid.hits = 0
			-- From the top
			newAsteroid.x = 300
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( -40,40 ), math.random( 40,120 ) )
		elseif ( whereFrom == 3 ) then
			newAsteroid.hits = 0
			-- From the right
			newAsteroid.x = 700
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 4 ) then
			newAsteroid.hits = 0
			-- From the right
			newAsteroid.x = 120
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( 40,100 ), math.random( 20,60 ) )
		elseif ( whereFrom == 5 ) then
			newAsteroid.hits = 0
			-- From the right
			newAsteroid.x = 450
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 6 ) then
			newAsteroid.hits = 0
			-- From the right
			newAsteroid.x = 450
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( 40, 120 ), math.random( 20,60 ) )
		end

		newAsteroid:applyTorque( math.random( -6,6 ) )
	else
		local newAsteroid = display.newImageRect( mainGroup, objectSheet, 1, 34, 28 )
		table.insert( asteroidsTable, newAsteroid )
		if ( info[5] ~= "marshmellow_plank.png" ) then
			physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=0.8 } )
		else
			physics.addBody( newAsteroid, "dynamic", { radius=40, bounce=1.6 } )
		end		
		newAsteroid.myName = "asteroid"			

		local whereFrom = math.random( 6 )

		if ( whereFrom == 1 ) then
			-- From the left
			newAsteroid.x = -60
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( 40,150 ), math.random( 20,60 ) )
		elseif ( whereFrom == 2 ) then
			-- From the top
			newAsteroid.x = 250
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( -100,-20 ), math.random( 40,120 ) )
		elseif ( whereFrom == 3 ) then
			-- From the right
			newAsteroid.x = 700
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 4 ) then
			-- From the right
			newAsteroid.x = 120
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( 40,100 ), math.random( 20,60 ) )
		elseif ( whereFrom == 5 ) then
			-- From the right
			newAsteroid.x = 450
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 6 ) then
			-- From the right
			newAsteroid.x = 450
			newAsteroid.y = -60
			newAsteroid:setLinearVelocity( math.random( 40, 120 ), math.random( 20,60 ) )
		end

		newAsteroid:applyTorque( math.random( -6,6 ) )
	end
end

local function createPowerup()
	local produce = math.random( 8 )
	local lucky = math.random( 32 )
	local newPowerup
	
	if ( lucky == 15 ) then
		local newPowerup = display.newImageRect( mainGroup, info[3], 200, 200 )
		physics.addBody( newPowerup, "dynamic", { radius=20, bounce=0.3 } )
		
		local whereFrom = math.random( 4 )
				
		if ( whereFrom == 1 ) then
			-- From the left
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,150 ), math.random( 20,60 ) )
		elseif ( whereFrom == 2 ) then
			-- From the top
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -100,-20 ), math.random( 40,120 ) )
		elseif ( whereFrom == 3 ) then
			-- From the right
			newPowerup.x = 700
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 4 ) then
			-- From the right
			newPowerup.x = 120
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,100 ), math.random( 20,60 ) )
		end
		
		newPowerup.myName = "life"
	elseif ( produce == 1 ) then
		local newPowerup = display.newImageRect( mainGroup, "tnt.png", 153, 85 )
		physics.addBody( newPowerup, "dynamic", { radius=30, bounce=0.3 } )
		
		local whereFrom = math.random( 4 )
				
		if ( whereFrom == 1 ) then
			-- From the left
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,150 ), math.random( 20,60 ) )
		elseif ( whereFrom == 2 ) then
			-- From the top
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -100,-20 ), math.random( 40,120 ) )
		elseif ( whereFrom == 3 ) then
			-- From the right
			newPowerup.x = 700
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 4 ) then
			-- From the right
			newPowerup.x = 120
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,100 ), math.random( 20,60 ) )
		end
		
		newPowerup.myName = "TNT"
	elseif ( produce == 2 ) then
		local newPowerup = display.newImageRect( mainGroup, "x3.png", 153, 85 )
		physics.addBody( newPowerup, "dynamic", { radius=30, bounce=0.8 } )
		newPowerup.myName = "multiply"
		local whereFrom = math.random( 4 )
				
		if ( whereFrom == 1 ) then
			-- From the left
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,150 ), math.random( 20,60 ) )
		elseif ( whereFrom == 2 ) then
			-- From the top
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -100,-20 ), math.random( 40,120 ) )
		elseif ( whereFrom == 3 ) then
			-- From the right
			newPowerup.x = 700
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 4 ) then
			-- From the right
			newPowerup.x = 120
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,100 ), math.random( 20,60 ) )
		end
	elseif ( produce == 3 ) then
		local newPowerup = display.newImageRect( mainGroup, "coin.png", 153, 85 )
		physics.addBody( newPowerup, "dynamic", { radius=30, bounce=0.8} )
		newPowerup.myName = "coin"
		newPowerup.isBullet = true

		local whereFrom = math.random( 4 )
				
		if ( whereFrom == 1 ) then
			-- From the left
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,150 ), math.random( 20,60 ) )
		elseif ( whereFrom == 2 ) then
			-- From the top
			newPowerup.x = 250
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -100,-20 ), math.random( 40,120 ) )
		elseif ( whereFrom == 3 ) then
			-- From the right
			newPowerup.x = 700
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( -120,-40 ), math.random( 20,60 ) )
		elseif ( whereFrom == 4 ) then
			-- From the right
			newPowerup.x = 120
			newPowerup.y = -60
			newPowerup:setLinearVelocity( math.random( 40,100 ), math.random( 20,60 ) )
		end
	end
end

local function fireLaser()

	local newLaser = display.newImageRect( mainGroup, info[4], 140, 70 )
	
	physics.addBody( newLaser, "dynamic", { isSensor=true } )
	newLaser.isBullet = true
	newLaser.myName = "laser"
	newLaser.x = ship.x
	newLaser.y = ship.y 
	
	if ( multiplier == 0 ) then
		newLaser:toBack()
		transition.to( newLaser, { y=-40, time=500,
			onComplete = function() display.remove( newLaser ) end
		} )
	else
		multiplier = multiplier - 1

		local leftLaser = display.newImageRect( mainGroup, info[4], 140, 70 )
		local rightLaser = display.newImageRect( mainGroup, info[4], 140, 70 )
		
		physics.addBody( leftLaser, "dynamic", { isSensor=true } )
		physics.addBody( rightLaser, "dynamic", { isSensor=true } )
		
		leftLaser.isBullet = true
		rightLaser.isBullet = true
		
		leftLaser.myName = "laser"
		rightLaser.myName = "laser"
		
		leftLaser.x = ship.x
		leftLaser.y = ship.y 
		rightLaser.x = ship.x
		rightLaser.y = ship.y 
	
		leftLaser:setLinearVelocity( -300, 60)
		newLaser:toBack()
		rightLaser:setLinearVelocity( 300, 60)
		
		transition.to( leftLaser, { y=-40, time=500,
			onComplete = function() display.remove( leftLaser ) end
		} )
		transition.to( newLaser, { y=-40, time=500,
			onComplete = function() display.remove( newLaser ) end
		} )
		transition.to( rightLaser, { y=-40, time=500,
			onComplete = function() display.remove( rightLaser ) end
		} )
	end
end


local function dragShip( event )

	local ship = event.target
	local phase = event.phase

	if ( "began" == phase ) then
		-- Set touch focus on the ship
		display.currentStage:setFocus( ship )
		-- Store initial offset position
		ship.touchOffsetX = event.x - ship.x

	elseif ( "moved" == phase ) then
		-- Move the ship to the new touch position
		if ship.touchOffsetX then
			ship.x = event.x - ship.touchOffsetX
		end

	elseif ( "ended" == phase or "cancelled" == phase ) then
		-- Release touch focus on the ship
		display.currentStage:setFocus( nil )
	end

	return true  -- Prevents touch propagation to underlying objects
end

local function endGame()
	info[1] = score
	local amount = currency[1] + coins
	info[2] = amount
	
	local qr = [[UPDATE coins SET Num=info[2] WHERE COINID=1;]]
	db:exec( qr )
	local c = {{coins}}
	
	currency[1] = amount
	
	saveCurrency()
	
	composer.setVariable( "info", info )
	composer.gotoScene( "menu", { time=800, effect="crossFade" } )
end

local function gameLoop()
	updateText()
	local generate = math.random( 3 )
	if ( generate == 1 ) then
		createPowerup()
	else
		createAsteroid()
	end
	if (ship.y == nil) then
		timer.cancel( gameLoopTimer )
		endGame() 
	elseif (ship.y > display.contentHeight) then
		display.remove( ship )
	end	
	-- Remove asteroids which have drifted off screen
	for i = #asteroidsTable, 1, -1 do
		local thisAsteroid = asteroidsTable[i]

		if ( thisAsteroid.x < -100 or
			 thisAsteroid.x > display.contentWidth + 100 or
			 thisAsteroid.y < -100 or
			 thisAsteroid.y > display.contentHeight + 100 )
		then
			display.remove( thisAsteroid )
			table.remove( asteroidsTable, i )
		end
	end
end


local function restoreShip()
	local offsetRectParams = { halfWidth=30, halfHeight=10}
	
	ship.isBodyActive = false
	ship.x = display.contentCenterX + 35
	ship.y = display.contentHeight - 200
	if ship ~= nil then
		physics.removeBody(ship)
	end

	-- Fade in the ship
	transition.to( ship, { alpha=1, time=4000,
		onComplete = function()
			ship.isBodyActive = true
			died = false
			if ship ~= nil then
				physics.addBody( ship, "dynamic", { friction=1.0, box=offsetRectParams })
			end
		end
	} )
end

local function onCollision( event )

	if ( event.phase == "began" ) then

		local obj1 = event.object1
		local obj2 = event.object2

		if ( ( obj1.myName == "laser" and obj2.myName == "asteroid" ) or
			 ( obj1.myName == "asteroid" and obj2.myName == "laser" ) )
		then
			if ( obj1.myName == "asteroid") then
				display.remove( obj2 )
			else
				display.remove( obj1 )
			end 
			
			for i = #asteroidsTable, 1, -1 do
				if ( asteroidsTable[i] == obj1 or asteroidsTable[i] == obj2 ) then
					if ( asteroidsTable[i].hits == nil or asteroidsTable[i].hits > 3 ) then
						display.remove( asteroidsTable[i] )
						table.remove( asteroidsTable, i )
						
						-- Increase score
						score = score + 100
						scoreText.text = "Score: " .. score

						break
					else
						asteroidsTable[i].hits = asteroidsTable[i].hits + 1 
						break
					end
				end
			end
		elseif ( ( obj1.myName == "ship" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "ship" ) )
		then
			if ( died == false ) then
				died = true

				-- Update lives
				lives = lives - 1
				livesText.text = "Lives: " .. lives

				if ( lives == 0 ) then
					display.remove( ship )
					--timer.performWithDelay( 2000, endGame )
				else
					ship.alpha = 0
					timer.performWithDelay( 1000, restoreShip )
				end
			end
		elseif ( ( obj1.myName == "laser" and obj2.myName == "multiply" ) or
				 ( obj1.myName == "multiply" and obj2.myName == "laser" ) )
		then
			display.remove( obj1 )
			display.remove( obj2 )
			
			multiplier = 3
		elseif ( ( obj1.myName == "laser" and obj2.myName == "TNT" ) or
				 ( obj1.myName == "TNT" and obj2.myName == "laser" ) )
		then
			display.remove( obj2 )
			display.remove( obj1 )
			
			if #planksTable > 0 then
				local delete = math.random( #planksTable )
				
				display.remove( planksTable[delete] )
				table.remove( planksTable, delete )
			end
		elseif ( ( obj1.myName == "laser" and obj2.myName == "life" ) or
				 ( obj1.myName == "life" and obj2.myName == "laser" ) )
		then
			display.remove( obj2 )
			display.remove( obj1 )

			lives = lives + 1
		elseif ( ( obj1.myName == "ship" and obj2.myName == "life" ) or
				 ( obj1.myName == "life" and obj2.myName == "ship" ) )
		then
			if ( obj1.myName == "ship") then
				display.remove( obj2 )
			else
				display.remove( obj1 )
			end

			lives = lives + 1
		elseif ( ( obj1.myName == "ship" and obj2.myName == "coin" ) or
				 ( obj1.myName == "coin" and obj2.myName == "ship" ) )
		then
			if ( obj1.myName == "ship") then
				display.remove( obj2 )
			else
				display.remove( obj1 )
			end
			
			coins = coins + 1
		else if ( ( obj1.myName == "plank" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "plank" ) )
		then
			if planksTable[1].hits == nil then
				if ( obj1.myName == "asteroid") then
					display.remove( obj2 )
				else
					display.remove( obj1 )
				end 
				for i = #planksTable, 1, -1 do
					if ( planksTable[i] == obj1 or planksTable[i] == obj2 ) then
						table.remove( planksTable, i )
						break
					end
				end
			else
				for i = #planksTable, 1, -1 do
					if ( planksTable[i] == obj1 or planksTable[i] == obj2 ) then
						planksTable[i].hits = planksTable[i].hits - 1
						if ( planksTable[i].hits == 0 ) then
							display.remove( planksTable[i] )
							table.remove( planksTable, i )
						end
						break
					end
				end
			end
		else if ( ( obj1.myName == "plank" and obj2.myName == "asteroid" ) or
				 ( obj1.myName == "asteroid" and obj2.myName == "plank" ) )
		then
			if planksTable[1].hits == nil then
					display.remove( obj2 )
					display.remove( obj1 )
				for i = #planksTable, 1, -1 do
					if ( planksTable[i] == obj1 or planksTable[i] == obj2 ) then
						table.remove( planksTable, i )
						break
					end
				end
			else
				if ( obj1.myName == "plank") then
					display.remove( obj2 )
				else
					display.remove( obj1 )
				end 
				for i = #planksTable, 1, -1 do
					if ( planksTable[i] == obj1 or planksTable[i] == obj2 ) then
						planksTable[i].hits = planksTable[i].hits - 1
						if ( planksTable[i].hits == 0 ) then
							display.remove( planksTable[i] )
							table.remove( planksTable, i )
						end
						break
					end
				end
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

	physics.pause()  -- Temporarily pause the physics engine
	loadCurrency()
	
	-- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	sceneGroup:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	sceneGroup:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
	sceneGroup:insert( uiGroup )    -- Insert into the scene's view group
	
	-- Load the background
	local offsetRectParams = { halfWidth=30, halfHeight=10}
	
	local background = display.newImageRect( backGroup, "waterfall.png", 800, 1400 )
	background.x = display.contentCenterX
	background.y = display.contentCenterY
	
	local bridge = display.newImageRect( backGroup, "empty.png", 2700, 1000 )
	bridge.x = display.contentCenterX + 145
	bridge.y = display.contentHeight - 230
	
	--local first = display.newImageRect( mainGroup, info[5], 77, 150 )
	--first.x = display.contentCenterX - 320
	--first.y = display.contentHeight - 180
	--physics.addBody( first, "static", { box=offsetRectParams } )
	--first.myName = "plank"
	--table.insert( planksTable, first )
	
	local second = display.newImageRect( mainGroup, info[5], 77, 150 )
	second.x = display.contentCenterX - 230
	second.y = display.contentHeight - 180
	physics.addBody( second, "static", { box=offsetRectParams } )
	second.myName = "plank"
	table.insert( planksTable, second )
	
	local third = display.newImageRect( mainGroup, info[5], 77, 150 )
	third.x = display.contentCenterX - 140
	third.y = display.contentHeight - 180
	physics.addBody( third, "static", { box=offsetRectParams } )
	third.myName = "plank"
	table.insert( planksTable, third )
	
	local fourth = display.newImageRect( mainGroup, info[5], 77, 150 )
	fourth.x = display.contentCenterX - 50
	fourth.y = display.contentHeight - 180
	physics.addBody( fourth, "static", { box=offsetRectParams })
	fourth.myName = "plank"	
	table.insert( planksTable, fourth )
	
	local fifth = display.newImageRect( mainGroup, info[5], 77, 150 )
	fifth.x = display.contentCenterX + 40
	fifth.y = display.contentHeight - 180
	physics.addBody( fifth, "static", { box=offsetRectParams })
	fifth.myName = "plank"
	table.insert( planksTable, fifth )

	local sixth = display.newImageRect( mainGroup, info[5], 77, 150 )
	sixth.x = display.contentCenterX + 130
	sixth.y = display.contentHeight - 180
	physics.addBody( sixth, "static", { box=offsetRectParams })
	sixth.myName = "plank"
	table.insert( planksTable, sixth )

	local seventh = display.newImageRect( mainGroup, info[5], 77, 150 )
	seventh.x = display.contentCenterX + 220
	seventh.y = display.contentHeight - 180
	physics.addBody( seventh, "static", { box=offsetRectParams } )
	seventh.myName = "plank"
	table.insert( planksTable, seventh )
	
	--local eigth = display.newImageRect( mainGroup, info[5], 77, 150 )
	--eigth.x = display.contentCenterX + 310
	--eigth.y = display.contentHeight - 180
	--physics.addBody( eigth, "static", { box=offsetRectParams } )
	--eigth.myName = "plank"
	--table.insert( planksTable, eigth )
	
	if ( info[5] == "iron_plank.png" ) then
		--first.hits = 5
		second.hits = 5
		third.hits = 5
		fourth.hits = 5
		fifth.hits = 5
		sixth.hits = 5
		seventh.hits = 5
		--eigth.hits = 5
	elseif ( info[5] == "marshmellow_plank.png" ) then
		--first.hits = 1e309
		second.hits = 1e309
		third.hits = 1e309
		fourth.hits = 1e309
		fifth.hits = 1e309
		sixth.hits = 1e309
		seventh.hits = 1e309
		--eigth.hits = 1e309
	end

	
	ship = display.newImageRect( mainGroup, info[3], 500, 500 )
	ship.x = display.contentCenterX + 35
	ship.y = display.contentHeight - 200
	physics.addBody( ship, "dynamic", { friction=1.0, box=offsetRectParams })
	ship.isFixedRotation = true
	ship.myName = "ship"

	-- Display lives and score
	livesText = display.newText( uiGroup, "Lives: " .. lives, 200, 80, native.systemFont, 36 )
	coinsText = display.newText( uiGroup, "Coins: " .. coins, 360, 80, native.systemFont, 36 )
	scoreText = display.newText( uiGroup, "Score: " .. score, 540, 80, native.systemFont, 36 )

	ship:addEventListener( "tap", fireLaser )
	ship:addEventListener( "touch", dragShip )
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
		Runtime:addEventListener( "collision", onCollision )
		gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
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
		Runtime:removeEventListener( "collision", onCollision )
		physics.pause()
		--timer.cancel( gameLoopTimer ) 
		composer.removeScene( "game" )
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
