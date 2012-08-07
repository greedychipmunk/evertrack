module(..., package.seeall)

--====================================================================--
-- SCENE: HOME
--====================================================================--

--[[

 - Version: [1.0]
 - Made by: Dawson Blackhouse
 - Website: [url]
 - Mail: [mail]

******************
 - INFORMATION
******************

  - [Your info here]

--]]

new = function ()
	
	------------------
	-- Imports
	------------------
	
	local sql = require ( "sqlite3" )
	local ui = require ( "ui" )
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	local path = system.pathForFile( "trackData.db", system.DocumentsDirectory )
	_G.db = sqlite3.open( path )
	
	local function onSystemEvent( event )
		if( event.type == "applicationExit" ) then              
			db:close()
		end
	end
	
	Runtime:addEventListener( "system", onSystemEvent )
	
	local background = display.newImage( "track-bg.png" )
	local title = display.newRetinaText( "What to Track?", 0, 0, native.systemFontBold, 34 )
	local searchTextField = native.newTextField( 0, 0, 585, 63 )
	--DNFL calculate height
	local buttonBackground = display.newRoundedRect( 30, 370, 580, 485, 15 )
	buttonBackground:setFillColor( 51, 51, 51 )
	buttonBackground:setStrokeColor( 136, 136, 136 )
	buttonBackground.strokeWidth = 2
	
	local cattablesetup = [[CREATE TABLE IF NOT EXISTS trackcats (id INTEGER PRIMARY KEY autoincrement, title, position);]]
	local catCode = _G.db:exec( cattablesetup )
	local eventtablesetup = [[CREATE TABLE IF NOT EXISTS trackevents (id INTEGER PRIMARY KEY autoincrement, catID, title, position, isFav);]]
	local eventCode = _G.db:exec( eventtablesetup )
	local itemtablesetup = [[CREATE TABLE IF NOT EXISTS trackitem (id INTEGER PRIMARY KEY autoincrement, catID TEXT, eventID TEXT, count INTEGER, date_created TEXT, time_created TEXT);]]
	local itemCode = _G.db:exec( itemtablesetup )

	------------------
	-- Functions
	------------------
	
	local newCatHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "new_cat", "moveFromRight" )
		end
	end
	
	local catButtonHandler = function ( event )
		if event.phase == "release" then
			_G.cat = { id = event.id } -- While named event.id this is the categoryID
			director:changeScene( "events", "moveFromRight" )
		end
	end
	
	local showCats = function ( cats )
		local startY = 340
		for i = 1, #cats do
			cat = cats[i]
			local b = ui.newButton {
				defaultSrc = "button-bg.png", defaultX = 575, defaultY = 90,
				overSrc = "button-bg.png", overX = 575, overY = 90,
				onEvent = catButtonHandler, text = cat.title, 
				size = 36, font = "Arial", id = cat.id
			}
			b.x = 320
			b.y = startY + ( i * 90 )
		end
	end
	
	------------------
	-- UI Objects
	------------------
	
	local newCatButton = ui.newButton{
					defaultSrc = "button-new-category.png", defaultX = 585, defaultY = 75,
					overSrc = "button-new-category.png", overX = 585, overY = 75,
					onEvent = newCatHandler,
					id = "newCatButton"
	}
	
	initVars = function()
	
		localGroup:insert( background )
		localGroup:insert( buttonBackground )
		localGroup:insert( title )
		localGroup:insert( searchTextField )
		localGroup:insert( newCatButton )
		
		title.x = 320
		title.y = 90
		
		searchTextField.x = 320
		searchTextField.y = 205
		searchTextField.hasBackground = false
		
		newCatButton.x = 320
		newCatButton.y = 300
		
		local trackCats = {}
		
		for row in db:nrows("SELECT * FROM trackcats") do
			-- create table at next available array index
			trackCats[#trackCats+1] =
			{
				id = row.id,
				title = row.title,
				position = row.position
			}
		end
		
		if #trackCats > 0 then
			showCats( trackCats )
		else
			director:changeScene( 'new_cat', 'moveFromRight' )
		end
		
	end
	
	initVars()
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end
