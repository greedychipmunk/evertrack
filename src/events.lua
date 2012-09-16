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
	
	local btnDisableEventPrev = display.newImage( "button-prev-disabled.png" )
	btnDisableEventPrev.isVisible = true
	local btnDisableEventNext = display.newImage( "button-next-disabled.png" )
	btnDisableEventNext.isVisible = false
	
	local nextEventGroupButton = {}
	local prevEventGroupButton = {}
	
	local eventScrollContainer = display.newGroup()
	local eventScrollGroup = display.newGroup()
	local eventPage = 1
	local eventPageTotal = 1
	local eventsPerPage = 5
	
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
	
	local nextEventGroupHandler = function ( event )
		eventScrollContainer.x = eventScrollContainer.x - 320
		eventPage = eventPage + 1
		prevEventGroupButton.isVisible = true
		if eventPage >= eventPageTotal then
			eventPage = eventPageTotal
			nextEventGroupButton.isVisible = false
			btnDisableEventNext.isVisible = true
			btnDisableEventPrev.isVisible = false
		end
	end
	
	local prevEventGroupHandler = function ( event )
		eventScrollContainer.x = eventScrollContainer.x + 320
		eventPage = eventPage - 1
		if eventPage <= 0 then
			eventPage = eventPageTotal
			btnDisableEventNext.isVisible = false
			btnDisableEventPrev.isVisible  = true
			prevEventGroupButton.isVisible = false
			nextEventGroupButton.isVisible = true
		end
	end
	
	local showEvents = function ( events )
		local startY = 255
		local padding = 300
		local j = 2
		local k = 1
		eventScrollGroup.x = 320
		eventPage = 0
		eventScrollContainer:insert( eventScrollGroup )
		eventPageTotal = math.ceil( #events / eventsPerPage )
		for i = 1, #events do
			if i % 6 == 0 then
				j = j + 1
				k = 1
				eventScrollGroup = display.newGroup()
				eventScrollGroup.x = ( 320 * j )
				eventScrollContainer:insert( eventScrollGroup )
			end
			
			event = events[i]
			local b = ui.newButton {
				defaultSrc = "button-bg.png", defaultX = 575, defaultY = 90,
				overSrc = "button-bg.png", overX = 575, overY = 90,
				onEvent = eventButtonHandler, text = event.title, 
				size = 36, font = "Arial", id = event.id
			}
			--b.x = 320
			b.y = startY + ( k * 100 )
			eventScrollGroup:insert( b )
			k = k + 1
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
	
	
	nextEventGroupButton = ui.newButton{
					defaultSrc = "button-next-enabled.png", defaultX = 116, defaultY = 62,
					overSrc = "button-next-disabled.png", overX = 116, overY = 62,
					onEvent = nextEventGroupHandler,
					id = "nextEventGroupButton"
	}
	
	prevEventGroupButton = ui.newButton{
					defaultSrc = "button-prev-enabled.png", defaultX = 116, defaultY = 62,
					overSrc = "button-prev-disabled.png", overX = 116, overY = 62,
					onEvent = prevEventGroupHandler,
					id = "prevEventGroupButton"
	}
	
	
	local initVars = function()
		localGroup:insert( background )
		localGroup:insert( title )
		localGroup:insert( newEventButton )
		localGroup:insert( eventScrollContainer )
		localGroup:insert( nextEventGroupButton )
		localGroup:insert( prevEventGroupButton )
		
		title.x = 320
		title.y = 90
		
		backButton.x = 65
		backButton.y = 90
		
		newEventButton.x = 320
		newEventButton.y = 230
		
		nextEventGroupButton.x = 550
		nextEventGroupButton.y = 870
		
		btnDisableEventNext.x = 550
		btnDisableEventNext.y = 870
		
		prevEventGroupButton.x = 90
		prevEventGroupButton.y = 870
		prevEventGroupButton.isVisible = false
		btnDisableEventPrev.x = 90
		btnDisableEventPrev.y = 870
		
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