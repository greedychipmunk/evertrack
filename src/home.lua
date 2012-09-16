module(..., package.seeall)

--====================================================================--
-- SCENE: HOME
--====================================================================--

--[[

 - Version: 1.0
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
			_G.db:close()
		end
	end
	
	Runtime:addEventListener( "system", onSystemEvent )
	
	local background = display.newImage( "track-bg.png" )
	local title = display.newRetinaText( "What to Track?", 0, 0, native.systemFontBold, 34 )
	
	local btnDisableCatPrev = display.newImage( "button-prev-disabled.png" )
	btnDisableCatPrev.isVisible = true
	local btnDisableCatNext = display.newImage( "button-next-disabled.png" )
	btnDisableCatNext.isVisible = false
	
	local nextCatGroupButton = {}
	local prevCatGroupButton = {}
	
	local cattablesetup = [[CREATE TABLE IF NOT EXISTS trackcats (id INTEGER PRIMARY KEY autoincrement, title, position);]]
	local catCode = _G.db:exec( cattablesetup )
	local eventtablesetup = [[CREATE TABLE IF NOT EXISTS trackevents (id INTEGER PRIMARY KEY autoincrement, catID, title, position, isFav);]]
	local eventCode = _G.db:exec( eventtablesetup )
	local itemtablesetup = [[CREATE TABLE IF NOT EXISTS trackitem (id INTEGER PRIMARY KEY autoincrement, catID TEXT, eventID TEXT, count INTEGER, date_created TEXT, time_created TEXT);]]
	local itemCode = _G.db:exec( itemtablesetup )

	local catScrollContainer = display.newGroup()
	local catScrollGroup = display.newGroup()
	local catPage = 1
	local catPageTotal = 1
	local catsPerPage = 5
	
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
	
	local nextCatGroupHandler = function ( event )
		catScrollContainer.x = catScrollContainer.x - 320
		catPage = catPage + 1
		prevCatGroupButton.isVisible = true
		if catPage >= catPageTotal then
			catPage = catPageTotal
			nextCatGroupButton.isVisible = false
			btnDisableCatNext.isVisible = true
			btnDisableCatPrev.isVisible = false
		end
	end
	
	local prevCatGroupHandler = function ( event )
		catScrollContainer.x = catScrollContainer.x + 320
		catPage = catPage - 1
		if catPage <= 0 then
			catPage = catPageTotal
			btnDisableCatNext.isVisible = false
			btnDisableCatPrev.isVisible  = true
			prevCatGroupButton.isVisible = false
			nextCatGroupButton.isVisible = true
		end
	end
		
	local showCats = function ( cats )
		local startY = 255
		local padding = 300
		local j = 2
		local k = 1
		catScrollGroup.x = 320
		catPage = 0
		catScrollContainer:insert( catScrollGroup )
		catPageTotal = math.ceil( #cats / catsPerPage )
		for i = 1, #cats do
			if i % 6 == 0 then
				j = j + 1
				k = 1
				catScrollGroup = display.newGroup()
				catScrollGroup.x = ( 320 * j )
				catScrollContainer:insert( catScrollGroup )
			end
			
			cat = cats[i]
			local b = ui.newButton {
				defaultSrc = "button-bg.png", defaultX = 575, defaultY = 90,
				overSrc = "button-bg.png", overX = 575, overY = 90,
				onEvent = catButtonHandler, text = cat.title, 
				size = 36, font = "Arial", id = cat.id
			}
			--b.x = 320
			b.y = startY + ( k * 100 )
			catScrollGroup:insert( b )
			k = k + 1
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
	
	nextCatGroupButton = ui.newButton{
					defaultSrc = "button-next-enabled.png", defaultX = 116, defaultY = 62,
					overSrc = "button-next-disabled.png", overX = 116, overY = 62,
					onEvent = nextCatGroupHandler,
					id = "nextCatGroupButton"
	}
	
	prevCatGroupButton = ui.newButton{
					defaultSrc = "button-prev-enabled.png", defaultX = 116, defaultY = 62,
					overSrc = "button-prev-disabled.png", overX = 116, overY = 62,
					onEvent = prevCatGroupHandler,
					id = "prevCatGroupButton"
	}
	
	initVars = function()
	
		localGroup:insert( background )
		localGroup:insert( title )
		localGroup:insert( newCatButton )
		localGroup:insert( catScrollContainer )
		localGroup:insert( nextCatGroupButton )
		localGroup:insert( prevCatGroupButton )
		
		title.x = 320
		title.y = 90
		
		--searchTextField.x = 320
		--searchTextField.y = 205
		--searchTextField.hasBackground = false
		
		newCatButton.x = 320
		newCatButton.y = 230
		
		nextCatGroupButton.x = 550
		nextCatGroupButton.y = 870
		
		btnDisableCatNext.x = 550
		btnDisableCatNext.y = 870
		
		prevCatGroupButton.x = 90
		prevCatGroupButton.y = 870
		prevCatGroupButton.isVisible = false
		btnDisableCatPrev.x = 90
		btnDisableCatPrev.y = 870
		
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
