module(..., package.seeall)

--====================================================================--
-- SCENE: NEW EVENTS
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
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- Your code here
	------------------
	
	local background = display.newImage( "track-bg.png" )
	local title = display.newRetinaText( "New Event", 0, 0, native.systemFontBold, 34 )
	local eventText = native.newTextField( 0, 0, 585, 75 )
	
	------------------
	-- Functions
	------------------
	
	local newEventHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "new_cat", "moveFromRight" )
		end
	end
	
	local backBtnHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "events", "moveFromLeft" )
		end
	end
	
	local addBtnHandler = function ( event )
		if event.phase == "release" then
			if #eventText.text > 0 then
				local q = [[INSERT INTO trackevents VALUES (NULL, ']] .. _G.cat.id .. [[',']] .. eventText.text .. [[',']] .. 0 .. [[',']] .. 0 .. [['); ]]
    			_G.db:exec( q )
				director:changeScene( "events", "moveFromLeft" )
    		end
		end
	end
	
	print( "NEW EVENT" )
	
	------------------
	-- UI Objects
	------------------
	
	local backButton = ui.newButton{
					defaultSrc = "button-back.png", defaultX = 116, defaultY = 62,
					overSrc = "button-back.png", overX = 116, overY = 62,
					onEvent = backBtnHandler,
					id = "backButton"
	}
	
	local addButton = ui.newButton{
					defaultSrc = "button-add.png", defaultX = 116, defaultY = 62,
					overSrc = "button-add.png", overX = 116, overY = 62,
					onEvent = addBtnHandler,
					id = "addButton"
	}
	
	initVars = function()
		localGroup:insert( background )
		localGroup:insert( title )
		
		title.x = 320
		title.y = 90
		
		backButton.x = 65
		backButton.y = 90
		
		eventText.x = 320
		eventText.y = 300
		
		addButton.x = 320
		addButton.y = 400
	end
	
	initVars()
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end