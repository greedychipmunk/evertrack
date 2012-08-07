module(..., package.seeall)

--====================================================================--
-- SCENE: EVENTS
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
	
	local background = display.newImage( "track-bg.png" )
	local title = display.newText( "Events", 0, 0, native.systemFontBold, 34 )
	
	------------------
	-- Functions
	------------------
	
	local newEventHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "new_event", "moveFromRight" )
		end
	end
	
	local backBtnHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "home", "moveFromLeft" )
		end
	end
	
	local eventButtonHandler = function ( event )
		if event.phase == "release" then
			_G.event = { id = event.id }
			director:changeScene( "item", "moveFromRight" )
		end
	end
	
	local showEvents = function ( events )
		local startY = 340
		for i = 1, #events do
			event = events[i]
			local b = ui.newButton {
				defaultSrc = "button-bg.png", defaultX = 575, defaultY = 90,
				overSrc = "button-bg.png", overX = 575, overY = 90,
				onEvent = eventButtonHandler, text = event.title, 
				size = 36, font = "Arial", id = event.id
			}
			b.x = 320
			b.y = startY + ( i * 90 )
		end
	end
	
	------------------
	-- UI Objects
	------------------
	
	local newEventButton = ui.newButton{
					defaultSrc = "button-new-event.png", defaultX = 585, defaultY = 75,
					overSrc = "button-new-event.png", overX = 585, overY = 75,
					onEvent = newEventHandler,
					id = "newEventButton"
	}
	
	local backButton = ui.newButton{
					defaultSrc = "button-back.png", defaultX = 116, defaultY = 62,
					overSrc = "button-back.png", overX = 116, overY = 62,
					onEvent = backBtnHandler,
					id = "backButton"
	}
	
	
	
	local initVars = function()
		localGroup:insert( background )
		localGroup:insert( title )
		localGroup:insert( newEventButton )
		
		title.x = 320
		title.y = 90
		
		backButton.x = 65
		backButton.y = 90
		
		newEventButton.x = 320
		newEventButton.y = 320
		
		local trackEvents = {}
		
		for row in _G.db:nrows("SELECT * FROM trackevents WHERE catID = '" .. _G.cat.id .. "';") do
			-- create table at next available array index
			trackEvents[#trackEvents+1] =
			{
				id = row.id,
				catID = row.catID,
				title = row.title,
				position = row.position,
				isFav = row.isFav
			}
		end

		if #trackEvents > 0 then
			showEvents( trackEvents )
		else
			director:changeScene( 'new_event', 'moveFromRight' )
		end
	end
	
	initVars()
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end