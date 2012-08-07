module(..., package.seeall)

--====================================================================--
-- SCENE: ITEM
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
	local d = os.date( "*t" )
	local datestamp = d.year .. "-" .. d.month .. "-" .. d.day
	local timestamp = d.hour .. ":" .. d.min .. ":" .. d.sec
	local eventObject = {}
	itemObject = {}
	local itemExist = false
	
	for e in _G.db:nrows( "SELECT * FROM trackevents WHERE id=" .. _G.event.id ) do
		eventObject = e
	end
	
	local refreshItems = function()
		for i in _G.db:nrows( [[SELECT * FROM trackitem WHERE eventID=']] .. eventObject.id .. [[']] ) do
			if datestamp == i.date_created then
				itemExist = true
				itemObject = i
			end
		end
	end
	
	refreshItems()
	
	--Test Function DNFL: Delete this
	local printItems = function()
		for p in _G.db:nrows( "SELECT * FROM trackitem" ) do
			print( "printitems::trackitem.id:", p.id )
		end
	end
	
	local background = display.newImage( "track-bg.png" )
	local title = display.newRetinaText( eventObject.title, 0, 0, native.systemFontBold, 34 )
	local labelBg = display.newImage( "label-bg.png" )
	--local trendButton = display.newImage( "button-trend.png" )
	local monthTable = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
	local month = monthTable[ d.month ]
	local fullDate = month .. " " .. d.day .. ", " .. d.year
	local dateText = display.newRetinaText( fullDate, 0, 0, "Arial", 36 )
	local countBg = display.newImage( "count-bg.png" )
	
	--Set Count
	local cText = 0
	if itemObject.count ~= nil then
		cText = itemObject.count
	end
	countText = display.newRetinaText( cText, 0, 0, "Arial", 156 )
	countText:setTextColor( 0, 0, 0 )
	
	------------------
	-- Functions
	------------------
	
	local updateCount = function()
		local dbInput = ""
		if itemExist then
			dbInput = [[UPDATE trackitem SET count=]] .. countText.text .. [[ WHERE id=']] .. itemObject.id .. [[']]
		else
			dbInput = [[INSERT INTO trackitem VALUES (NULL,']] .. _G.cat.id .. [[',']] .. _G.event.id .. [[',']] .. countText.text .. [[',']] .. datestamp .. [[',']] .. timestamp .. [['); ]]
		end
		local insertUpdateCode = _G.db:exec( dbInput )
		refreshItems()
	end
	
	local backBtnHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "events", "moveFromLeft" )
		end
	end
	
	local trendButtonHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "trends", "moveFromRight" )
		end
	end
	
	local subBtnHandler = function ( event )
		if event.phase == "release" then
			if cText > 0 then
				cText = cText - 1
				countText.text = cText
				updateCount()
			end
		end
	end
	
	local addBtnHandler = function ( event )
		if event.phase == "release" then
			cText = cText + 1
			countText.text = cText
			updateCount()
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
	
	local trendButton = ui.newButton {
					defaultSrc = "button-trend.png", defaultX = 115, defaultY = 62,
					overSrc = "button-trend.png", overX = 115, overY = 62,
					onEvent = trendButtonHandler,
					id = "trendButton"
	}
	
	local subButton = ui.newButton {
					defaultSrc = "button-subtract.png", defaultX = 177, defaultY = 164,
					overSrc = "button-subtract.png", overX = 177, overY = 164,
					onEvent = subBtnHandler,
					id = "subButton"
	}
	
	local additionButton = ui.newButton {
					defaultSrc = "button-addition.png", defaultX = 177, defaultY = 164,
					overSrc = "button-addition.png", overX = 177, overY = 164,
					onEvent = addBtnHandler,
					id = "subButton"
	}
	
	initVars = function() 
		localGroup:insert( background )
		localGroup:insert( title )
		localGroup:insert( labelBg )
		localGroup:insert( dateText )
		localGroup:insert( countBg )
		localGroup:insert( countText )
		
		title.x = 320
		title.y = 90
		
		backButton.x = 65
		backButton.y = 90
		
		trendButton.x = 575
		trendButton.y = 90
		
		labelBg.x = 320
		labelBg.y = 220
		
		dateText.x = 320
		dateText.y = 220
		
		countBg.x = 320
		countBg.y = 450
		
		countText.x = 320
		countText.y = 450
		
		subButton.x = 160
		subButton.y = 720
		
		additionButton.x = 460
		additionButton.y = 720
		
	end
	
	initVars()
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end