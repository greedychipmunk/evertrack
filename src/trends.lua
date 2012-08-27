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
	local widget = require( "widget" )
	widget.setTheme( "theme_ios" )
	
	------------------
	-- Groups
	------------------
	
	local localGroup = display.newGroup()
	
	------------------
	-- CODE
	------------------
	
	local background = display.newImage( "track-bg.png" )
	local title = display.newRetinaText( "Trends", 0, 0, native.systemFontBold, 34 )
	local buttonBackground = display.newRoundedRect( 30, 370, 580, 485, 15 )
	buttonBackground:setFillColor( 51, 51, 51 )
	buttonBackground:setStrokeColor( 136, 136, 136 )
	buttonBackground.strokeWidth = 2
	
	------------------
	-- DYNAMIC LABELS
	------------------
	
	local fromDate  = display.newRetinaText( "From:", 50, 180, native.systemFontBold, 34 )
	local toDate    = display.newRetinaText( "To:", 50, 260, native.systemFontBold, 34 )
	
	local needDates = display.newRetinaText( "Please select a date range", 50, 390, native.systemFont, 30 )
	local noDataForDateRange = display.newRetinaText( "There is nothing tracked!!!", 50, 390, native.systemFont, 30 )
	noDataForDateRange.isVisible = false
	
	local totalEventDisplayLabel = display.newRetinaText( "Total:", 50, 390, native.systemFont, 30 )
	totalEventDisplayLabel.isVisible = false
	local totalEventDisplayText = display.newRetinaText ( "", 550, 390, native.systemFont, 30 )
	totalEventDisplayText.isVisible = false
	
	local dayRangeDisplayLabel = display.newRetinaText( "# of days:", 50, 440, native.systemFont, 30 )
	dayRangeDisplayLabel.isVisible = false
	local dayRangeDisplayText = display.newRetinaText( "", 550, 440, native.systemFont, 30 )
	dayRangeDisplayText.isVisible = false
	
	local avgPerDayDisplayLabel = display.newRetinaText( "Average Per Day:", 50, 490, native.systemFont, 30 )
	avgPerDayDisplayLabel.isVisible = false
	local avgPerDayDisplayText = display.newRetinaText( "", 550, 490, native.systemFont, 30 )
	avgPerDayDisplayText.isVisible = false
	
	local avgPerWeekDisplayLabel = display.newRetinaText( "Average Per Week:", 50, 540, native.systemFont, 30 )
	avgPerWeekDisplayLabel.isVisible = false
	local avgPerWeekDisplayText = display.newRetinaText( "", 550, 540, native.systemFont, 30 )
	avgPerWeekDisplayText.isVisible = false
	
	local avgPerMonthDisplayLabel = display.newRetinaText( "Average Per Month:", 50, 590, native.systemFont, 30 )
	avgPerMonthDisplayLabel.isVisible = false
	local avgPerMonthDisplayText = display.newRetinaText( "", 550, 590, native.systemFont, 30 )
	avgPerMonthDisplayText.isVisible = false
	
	local avgPerYearDisplayLabel = display.newRetinaText( "Average Per Year:", 50, 640, native.systemFont, 30 )
	avgPerYearDisplayLabel.isVisible = false
	local avgPerYearDisplayText = display.newRetinaText( "", 550, 640, native.systemFont, 30 )
	avgPerYearDisplayText.isVisible = false
	
	-----------------------
	-- CALCULATED VARIABLES
	-----------------------
	
	local itemCount   = 0
	local secondRange = 0	
	local daysRange = 0
	
	local qRows = {}
	
	local toDateObject = {}
	local fromDateObject = {}
	local populateOnce = true

	local avgItemPerDay   = 0
	local avgItemPerWeek  = 0
	local avgItemPerMonth = 0
	local avgItemPerYear  = 0
	
	------------------------
	-- STATIC VARIABLES
	------------------------
	
	local pinWheelData = {}
	pinWheelData[1] = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" }
	pinWheelData[1].width = 135
	pinWheelData[1].alignment = "center"
	
	pinWheelData[2] = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31" }
	pinWheelData[2].alignment = "center"
	
	local d = os.date( "*t" )
	local currentYear = d.year
	local i = 1
	pinWheelData[3] = {}
	pinWheelData[3].alignment = "center"
	pinWheelData[3].width = 130
	startYear = 2000
	for startYear = 2000, currentYear do
		pinWheelData[3][i] = startYear
		i = i + 1
	end
	
	local fromDateText = display.newRetinaText( "", 490, 175, native.systemFontBold, 34 )
	fromDateText:setTextColor( 0, 0, 0 )
	local toDateText = display.newRetinaText( "", 490, 265, native.systemFontBold, 34 )
	toDateText:setTextColor( 0, 0, 0 )
	
	local fromPickerGroup = display.newGroup()
	local fromPicker = widget.newPickerWheel{
		id="fromPicker",
		--font="Helvetica-Bold",
		fontSize=40,
		glassWidth=500,
		width=200,
		columns=pinWheelData
	}
	
	local toPickerGroup = display.newGroup()
	local toPicker = widget.newPickerWheel{
		id="toPicker",
		--font="Helvetica-Bold",
		fontSize=40,
		glassWidth=500,
		width=200,
		columns=pinWheelData
	}
	
	local fromPickerBar = display.newImage( "picker-button-bar.png" )
	fromPickerGroup:insert( fromPicker.view )
	fromPickerGroup:insert( fromPickerBar )
	fromPickerGroup.isVisible = false
	
	local toPickerBar = display.newImage( "picker-button-bar.png" )
	toPickerGroup:insert( toPicker.view )
	toPickerGroup:insert( toPickerBar )
	toPickerGroup.isVisible = false
	
	------------------
	-- Functions
	------------------
	local backBtnHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "item", "moveFromLeft" )
		end
	end
	
	local homeBtnHandler = function ( event )
		if event.phase == "release" then
			director:changeScene( "home", "moveFromLeft" )
		end
	end
	
	local fromDateHandler = function ( event )
		fromPickerGroup.isVisible = true
	end
	
	local toDateHandler = function ( event )
		toPickerGroup.isVisible = true
	end
	
	local validDates = function ()
		local dateRangeValid = false
		if #toDateText.text > 0 and #fromDateText.text > 0 then
			osFromDate = os.time( fromDateObject )
			osToDate = os.time( toDateObject )
			local timeDiff = os.difftime( osFromDate, osToDate )
			if timeDiff < 0 then
				dateRangeValid = true
			end
		end
		return dateRangeValid
	end
	
	local showData = function() 
		local showQuery = [[SELECT * FROM trackitem WHERE eventID=']] .. _G.event.id .. [[']]
		
	end
	
	-----------------------
	-- UTILITY FUNCTIONS
	-----------------------
	
	-- from sam_lie
	-- Compatible with Lua 5.0 and 5.1.
	-- Disclaimer : use at own risk especially for hedge fund reports :-)
	
	---============================================================
	-- add comma to separate thousands
	-- 
	function comma_value(amount)
	  local formatted = amount
	  while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
		  break
		end
	  end
	  return formatted
	end
	
	---============================================================
	-- rounds a number to the nearest decimal places
	--
	function round(val, decimal)
	  if (decimal) then
		return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
	  else
		return math.floor(val+0.5)
	  end
	end
	
	--===================================================================
	-- given a numeric value formats output with comma to separate thousands
	-- and rounded to given decimal places
	--
	--

	function format_num(amount, decimal, prefix, neg_prefix)
		local str_amount,  formatted, famount, remain
		
		decimal = decimal or 2  -- default 2 decimal places
		neg_prefix = neg_prefix or "-" -- default negative sign
		
		famount = math.abs(round(amount,decimal))
		famount = math.floor(famount)
		
		remain = round(math.abs(amount) - famount, decimal)
		
			-- comma to separate the thousands
		formatted = comma_value(famount)
		
			-- attach the decimal portion
		if (decimal > 0) then
			remain = string.sub(tostring(remain),3)
			formatted = formatted .. "." .. remain .. string.rep("0", decimal - string.len(remain))
		end
		
		-- attach prefix string e.g '$' 
		formatted = (prefix or "") .. formatted 
		
		-- if value is negative then format accordingly
		if (amount<0) then
			if (neg_prefix=="()") then
				formatted = "("..formatted ..")"
			else
				formatted = neg_prefix .. formatted 
			end
		end
		
		return formatted
	end
	
	function explode(div,str)
		if (div=='') then return false end
		local pos,arr = 0,{}
		-- for each divider found
		for st,sp in function() return string.find(str,div,pos,true) end do
			-- Attach chars left of current divider
			table.insert(arr,string.sub(str,pos,st-1)) 
			pos = sp + 1 -- Jump past current divider
	  	end
	  	-- Attach chars right of last divider
	  	table.insert(arr,string.sub(str,pos)) 
	  	return arr
	end
	
	-----------------------
	-- METRIC CALCULATORS
	-----------------------
	
	local calcMetrics = function()
		print( "secondRange: " .. secondRange )
		needDates.isVisible = false
		
		print( "itemCount: " .. itemCount )
		totalEventDisplayText.text = itemCount
		totalEventDisplayText.isVisible = true
		totalEventDisplayLabel.isVisible = true
		
		daysRange = math.floor( ( ( secondRange / 60 ) / 60 ) / 24 )
		print( "daysRange: " .. daysRange )
		dayRangeDisplayText.text  = daysRange
		dayRangeDisplayText.isVisible = true
		dayRangeDisplayLabel.isVisible = true
		
		avgItemPerDay = itemCount / daysRange
		print( "avgItemPerDay: " .. avgItemPerDay )
		avgPerDayDisplayText.text = format_num( avgItemPerDay, 2 )
		avgPerDayDisplayText.isVisible = true
		avgPerDayDisplayLabel.isVisible = true
		
		avgItemPerWeek = itemCount / ( math.floor( daysRange / 7 ) )
		print( "avgItemPerWeek: " .. avgItemPerWeek )
		avgPerWeekDisplayText.text = format_num( avgItemPerWeek, 2 )
		avgPerWeekDisplayText.isVisible = true
		avgPerWeekDisplayLabel.isVisible = true
		
		if daysRange > 30 then
			avgItemPerMonth = itemCount / ( math.floor( daysRange / 30 ) )
			print( "avgItemPerMonth: " .. avgItemPerMonth )
			avgPerMonthDisplayText.text = format_num( avgItemPerMonth, 2 )
			avgPerMonthDisplayText.isVisible = true
			avgPerMonthDisplayLabel.isVisible = true
			
			
			if daysRange > 365 then
				avgItemPerYear = itemCount / ( math.floor( daysRange / 365.25 ) )
				print( "avgItemPerYear: " .. avgItemPerYear )
				avgPerYearDisplayText.text = format_num( avgItemPerYear, 2 )
				avgPerYearDisplayText.isVisible = true
				avgPerYearDisplayLabel.isVisible = true
			end
			
		end
	end
	
	
	local populateData = function()
		print( "**********POPULATE DATA**********" )
		itemCount = 0
		qRows = {}
		if populateOnce then
			populateOnce = false
			--local query = [[SELECT * FROM trackitem WHERE date_created BETWEEN date( ']] .. fromDateObject.year .. '-' .. fromDateObject.month .. '-' .. fromDateObject.day .. [[' ) AND date( ']] .. toDateObject.year .. '-' .. toDateObject.month .. '-' .. toDateObject.day .. [[' ) ]]
			local query = [[SELECT * FROM trackitem WHERE eventID=']] .. _G.event.id .. [[']]
			for q in _G.db:nrows( query ) do
				local qDateObject = explode( "-", q.date_created )
				qDateObj = { year = qDateObject[1], month = qDateObject[2], day = qDateObject[3] }
				qDateObject = os.time( qDateObj )
				print( fromDateObject.year .. "-" .. fromDateObject.month .. "-" .. fromDateObject.day .. "....." .. qDateObj.year .. "-" ..qDateObj.month .. "-" .. qDateObj.day .. "....." .. toDateObject.year .. "-" .. toDateObject.month .. "-" .. toDateObject.day )
				print( osFromDate .. "....." .. qDateObject .. "....." .. osToDate )
				if ( qDateObject - osFromDate ) > 0 and ( osToDate - qDateObject ) > 0 then
					qRows[ #qRows + 1 ] = q
				end
			end
			print( "#qRows: " .. #qRows )
			if #qRows > 0 then
				secondRange = osToDate - osFromDate
				for i=1, #qRows do
					print( "qRows[ " .. i .. " ].count: " .. qRows[i].count )
					itemCount = itemCount + qRows[i].count
					print( "itemCount: " .. itemCount )
				end
				
				noDataForDateRange.isVisible = false
				calcMetrics()
			else
				needDates.isVisible = false
				noDataForDateRange.isVisible = true
			end
		end
	end
	
	local toPickerDoneHandler = function( event )
		populateOnce = true
		local selectedRows = toPicker:getValues()
		for i=1,#selectedRows do
       		print( "[" .. selectedRows[i].index .. "]: " .. selectedRows[i].value )
        end
        toDateObject = { 
        	day = selectedRows[2].value,
        	year = selectedRows[3].value,
        	month = selectedRows[1].index
        }
        toDateText.text = toDateObject.month .. "/" .. toDateObject.day .. "/" .. toDateObject.year
		toPickerGroup.isVisible = false
        if validDates() then
        	populateData()
        end
	end
	
	local fromPickerDoneHandler = function( event )
		populateOnce = true
		local selectedRows = fromPicker:getValues()
		for i=1,#selectedRows do
       		print( "[" .. selectedRows[i].index .. "]: " .. selectedRows[i].value )
        end
        fromDateObject = { 
        	day = selectedRows[2].value,
        	year = selectedRows[3].value,
        	month = selectedRows[1].index
        }
        fromDateText.text = fromDateObject.month .. "/" .. fromDateObject.day .. "/" .. fromDateObject.year
		fromPickerGroup.isVisible = false
		if validDates() then
			populateData()
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
	
	local homeButton = ui.newButton{
					defaultSrc = "button-home.png", defaultX = 116, defaultY = 62,
					overSrc = "button-home.png", overX = 116, overY = 62,
					onEvent = homeBtnHandler,
					id = "homeButton"
	}
	
	local fromDateButton = ui.newButton{
					defaultSrc = "bg-date.png", defaultX = 295, defaultY = 63,
					overSrc = "bg-date.png", overX = 295, overY = 63,
					onEvent = fromDateHandler,
					id = "fromDateButton"
	}
	
	local toDateButton = ui.newButton{
					defaultSrc = "bg-date.png", defaultX = 295, defaultY = 63,
					overSrc = "bg-date.png", overX = 295, overY = 63,
					onEvent = toDateHandler,
					id = "toDateButton"
	}
	
	local toPickerDone = ui.newButton {
					defaultSrc = "button-ios-done.png", defaultX = 120, defaultY = 59,
					overSrc = "button-ios-done.png", overX = 120, overY = 59,
					onEvent = toPickerDoneHandler,
					id = "toPickerDoneButton"
	}
	
	local fromPickerDone = ui.newButton {
					defaultSrc = "button-ios-done.png", defaultX = 120, defaultY = 59,
					overSrc = "button-ios-done.png", overX = 120, overY = 59,
					onEvent = fromPickerDoneHandler,
					id = "fromPickerDoneButton"
	}
	
	toPickerGroup:insert( toPickerDone )
	fromPickerGroup:insert( fromPickerDone )
	
	initVars = function ()
		localGroup:insert( background )
		localGroup:insert( title )
		localGroup:insert( backButton )
		localGroup:insert( homeButton )
		localGroup:insert( buttonBackground )
		localGroup:insert( toPickerGroup )
		localGroup:insert( fromPickerGroup )
		
		title.x = 320
		title.y = 90
		
		backButton.x = 65
		backButton.y = 90
		
		homeButton.x = 575
		homeButton.y = 90
		
		fromDateButton.x = 445
		fromDateButton.y = 200
		
		toDateButton.x = 445
		toDateButton.y = 290
		
		toPickerGroup.x = 0
		toPickerGroup.y = 740
		
		fromPickerGroup.x = 0
		fromPickerGroup.y = 740
		
		toPickerBar.y = -40
		fromPickerBar.y = -40
		
		toPickerDone.x = 550
		toPickerDone.y = -40
		
		fromPickerDone.x = 550
		fromPickerDone.y = -40
		
	end
	
	initVars()
	
	------------------
	-- MUST return a display.newGroup()
	------------------
	
	return localGroup
	
end