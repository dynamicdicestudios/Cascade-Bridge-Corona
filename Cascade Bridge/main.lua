local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )

-- Seed the random number generator
math.randomseed( os.time() )

-- Require the SQLite library
local sqlite3 = require( "sqlite3" )

local function continue()
	-- Create a file path for the database file "data.db"
	local path = system.pathForFile( "extras.db", system.DocumentsDirectory )
	-- Open the database for access
	local db = sqlite3.open( path )
	
	local p = {}
	local ch = {}
	local c = {}
		 
	-- Loop through database table rows via a SELECT query
	for row in db:nrows( "SELECT * FROM planks" ) do
		 
		-- Create sub-table at next available index of "people" table
		p[#p+1] =
		{
			Name = row.Name,
			Own = row.Own,
			Equipped = row.Equipped 
		}
	end

	for row in db:nrows( "SELECT * FROM characters" ) do
		-- Create sub-table at next available index of "people" table
		ch[#ch+1] =
		{
			Name = row.Name,
			Weapon = row.Weapon,
			Own = row.Own,
			Equipped = row.Equipped,
			Lives = row.Lives
		}
	end

	for row in db:nrows( "SELECT * FROM coins" ) do

		c[#c+1] =
		{
			Num = row.Num
		}
	end

	local character = ""
	local weapon = ""
	local plank = ""
	local lives = 0

	for i = #p, 1, -1 do
		if p[i].Equipped == 1 then
			plank = p[i].Name
			break
		end
	end

	for i = #ch, 1, -1 do
		if ch[i].Equipped == 1 then
			character = ch[i].Name
			weapon = ch[i].Weapon
			lives = ch[i].Lives
			break
		end
	end

	local info = {0, c[1].Num, character, weapon, plank, lives}

	composer.setVariable( "info", info )
	composer.gotoScene( "menu")
end

local function firstTime()
 
	-- Create a file path for the database file "data.db"
	local path = system.pathForFile( "extras.db", system.DocumentsDirectory )

	-- Open the database for access
	local db = sqlite3.open( path )

	local planks = {
		{
			Name = "wood_plank.png",
			Own = 1,
			Equipped = 1,
		},
		{
			Name = "iron_plank.png",
			Own = 0,
			Equipped = 0,
		},
		{
			Name = "marshmellow_plank.png",
			Own = 0,
			Equipped = 0,
		},
	}

	local characters = {
	
		{
			Name = "monkey.png",
			Weapon = "coconut.png",
			Own = 1,
			Equipped = 1,
			Lives = 1
		},
		{
			Name = "ninja.png",
			Weapon = "star.png",
			Own = 0,
			Equipped = 0,
			Lives = 2
		},
		{
			Name = "wizard.png",
			Weapon = "fire.png",
			Own = 0,
			Equipped = 0,
			Lives = 2
		},
		{
			Name = "bplayer.png",
			Weapon = "ball.png",
			Own = 0,
			Equipped = 0,
			Lives = 3
		},
		{
			Name = "gplayer.png",
			Weapon = "stick.png",
			Own = 0,
			Equipped = 0,
			Lives = 3
		}
		
	}
	
	local coins = { {Num = 0} }
	
	local tableSetup = [[CREATE TABLE IF NOT EXISTS planks ( PLANKID INTEGER PRIMARY KEY autoincrement, Name, Own INTEGER, Equipped INTEGER);]]
	db:exec( tableSetup )

	tableSetup = [[CREATE TABLE IF NOT EXISTS characters ( CHARID INTEGER PRIMARY KEY autoincrement, Name, Weapon, Own INTEGER, Equipped INTEGER, Lives INTEGER);]]
	db:exec( tableSetup )

	tableSetup = [[CREATE TABLE IF NOT EXISTS coins ( COINID INTEGER PRIMARY KEY autoincrement, Num INTEGER);]]
	db:exec( tableSetup )

	for i = 1,#planks do
		local a = [[INSERT INTO planks VALUES ( NULL, "]] .. planks[i].Name .. [[","]] .. planks[i].Own .. [[","]] .. planks[i].Equipped .. [[" );]]
		db:exec( a )
	end

	for i = 1,#characters do
		local b = [[INSERT INTO characters VALUES ( NULL, "]] .. characters[i].Name .. [[","]] .. characters[i].Weapon .. [[","]] .. characters[i].Own .. [[","]] .. characters[i].Equipped .. [[","]] .. characters[i].Lives .. [[" );]]
		db:exec( b )
	end

	for i = 1,#coins do
		local e = [[INSERT INTO coins VALUES ( NULL, "]] .. coins[i].Num .. [[" );]]
		db:exec( e )
	end

	local p = {}
	local ch = {}
	local c = {}
		 
	-- Loop through database table rows via a SELECT query
	for row in db:nrows( "SELECT * FROM planks" ) do
		 
		-- Create sub-table at next available index of "people" table
		p[#p+1] =
		{
			Name = row.Name,
			Own = row.Own,
			Equipped = row.Equipped 
		}
	end

	for row in db:nrows( "SELECT * FROM characters" ) do
		-- Create sub-table at next available index of "people" table
		ch[#ch+1] =
		{
			Name = row.Name,
			Weapon = row.Weapon,
			Own = row.Own,
			Equipped = row.Equipped,
			Lives = row.Lives
		}
	end

	for row in db:nrows( "SELECT * FROM coins" ) do

		c[#c+1] =
		{
			Num = row.Num
		}
	end

	local character = ""
	local weapon = ""
	local plank = ""
	local lives = 0

	for i = #p, 1, -1 do
		if p[i].Equipped == 1 then
			plank = p[i].Name
			break
		end
	end

	for i = #ch, 1, -1 do
		if ch[i].Equipped == 1 then
			character = ch[i].Name
			weapon = ch[i].Weapon
			lives = ch[i].Lives
			break
		end
	end

	local info = {0, c[1].Num, character, weapon, plank, lives}

	composer.setVariable( "info", info )
	composer.gotoScene( "menu")
end

xpcall(continue, firstTime)
