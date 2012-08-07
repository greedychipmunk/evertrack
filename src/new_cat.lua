module(..., package.seeall)

--====================================================================--
-- SCENE: NEW CATEGORY
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
	
	------------------
	-- Your code here
	------------------
	
	local background = display.newImage( "track-bg.png" )
	local title = display.newRetinaText( "New Category", 0, 0, native.systemFontBold, 34 )
	local catText = native.newTextField( 0, 0, 585, 75 )
	
	------------------
	-- Functions
	------------------
	
	local backBtnHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "home", "moveFromLeft" )
		end
	end
	
	local addBtnHandler = function ( event )
		if event.phase == "release" then
			if #catText.text > 0 then
				local q = [[INSERT INTO trackcats VALUES (NULL, ']] .. catText.text .. [[',']] .. 0 .. [['); ]]
				print( "new cat", q )
    			_G.db:exec( q )
				director:changeScene( "home", "moveFromLeft" )
    		end
		end
	end
	
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
		localGroup:insert( backButton )
		localGroup:insert( catText )
		
		title.x = 320
		title.y = 90
		
		backButton.x = 65
		backButton.y = 90
		
		catText.x = 320
		catText.y = 300
		
		addButton.x = 320
		addButton.y = 400
	end
	
	initVars()
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end