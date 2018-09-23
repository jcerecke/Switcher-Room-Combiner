-- Room Combine Switcher
-- By Joshua Cerecke
-- Ceretech Audiovisual Solutions
-- joshua@ceretech.co.nz
-- +64 27 2373 253
-- September 2018

-- TO DO: Output on a pin per room, the group number
-- TO DO: Output on multiple pins per group, the rooms T/F if they're part of that group

PluginInfo =
{
	Name = "Tools~Room Combine Switcher",
	Version = "0.9",
	Id = "d2702557-f548-48bb-858d-d7c43f0ce5ee",
	Description = "Multi-room switcher that can be used for auxiliary switching in room combine installations",
	ShowDebug = true,
}

LEDColours = {
"Red",
"LimeGreen",
"Cyan",
"DarkViolet",
"Orchid",
"SteelBlue",
"Khaki",
"LightSalmon",
"Aquamarine",
"Tomato",
"Purple",
"MidnightBlue",
"SlateBlue",
"Teal",
"Thistle",
"GreenYellow",
"Blue",
"MediumBlue",
"DeepPink",
"DeepSkyBlue",
"Tan",
"DarkBlue",
"Plum",
"Chocolate",
"HotPink",
"LightPink",
"DarkSalmon",
"SandyBrown",
"PaleTurquoise",
"Maroon",
"DodgerBlue",
"LightCoral",
"MediumPurple",
"Pink",
"BurlyWood",
"SpringGreen",
"Aqua",
"RoyalBlue",
"SaddleBrown",
"CadetBlue",
"PowderBlue",
"Gold",
"DarkKhaki",
"DarkRed",
"MediumSeaGreen",
"DarkGreen",
"MediumVioletRed",
"GoldenRod",
"MediumOrchid",
"Lime",
"Olive",
"Brown",
"Green",
"MediumSpringGreen",
"DarkSlateBlue",
"LightSteelBlue",
"Orange",
"DarkOrange",
"LightSkyBlue",
"Fuchsia",
"Peru",
"Yellow",
"DarkOliveGreen",
"BlueViolet",
"PaleVioletRed",
"DarkMagenta",
"Sienna",
"RosyBrown",
"LightGreen",
"ForestGreen",
"DarkSeaGreen",
"LightBlue",
"Indigo",
"Chartreuse",
"MediumSlateBlue",
"Navy",
"FireBrick",
"OrangeRed",
"IndianRed",
"MediumAquaMarine",
"Crimson",
"Salmon",
"SeaGreen",
"CornflowerBlue",
"DarkTurquoise",
"MediumTurquoise",
"Coral",
"DarkOrchid",
"Turquoise",
"OliveDrab",
"SkyBlue",
"Violet",
"PaleGreen",
"DarkGoldenRod",
"LawnGreen",
"DarkCyan",
"YellowGreen",
"RebeccaPurple",
"LightSeaGreen",
"Magenta",
}

function GetPrettyName(props)
	return "Room Combine Switcher~v"..PluginInfo.Version.."~Joshua Cerecke"
end

function GetColor(props)
	return { 191, 226, 249 } --Same colour as Room Combiner component
end

function GetProperties()
	props = {
		{
			Name = "Rooms",
			Type = "integer",
			Min = 2,
			Max = 256,
			Value = 2,
		},
		{
			Name = "Walls",
			Type = "integer",
			Min = 1,
			Max = 256,
			Value = 1,
		},
		{
			Name = "Inputs",
			Type = "integer",
			Min = 2,
			Max = 128,
			Value = 2,
		},
		{
			Name = "Input Restriction",
		    Type = "boolean",
		    Value = false,
		},
	}
	return props
end

function GetControls(props)
	ctrl = {}
	table.insert(ctrl,
		{
			Name = "Wall Rooms",
			ControlType = "Text",
			Count = props["Walls"].Value,
			UserPin = true,
			PinStyle = "Both",
		}
	)
	table.insert(ctrl,
		{
			Name = "Wall Opens",
			ControlType = "Button",
			ButtonType = "Toggle",
			Count = props["Walls"].Value,
			UserPin = true,
			PinStyle = "Both",
		}
	)
	table.insert(ctrl,
		{
			Name = "Room Select",
			ControlType = "Text",
			Count = props["Rooms"].Value,
			UserPin = true,
			PinStyle = "Both",
		}
	)
  table.insert(ctrl,
    {
      Name = "Room LED",
      ControlType = "Indicator",
      IndicatorType = "Led",
      Count = props["Rooms"].Value,
      UserPin = false,
    })
	for r = 1, props["Rooms"].Value, 1 do
		table.insert(ctrl,
			{
				Name = "Room "..r.." Input",
				ControlType = "Button",
				ButtonType = "Toggle",
				Count = props["Inputs"].Value,
				UserPin = true,
				PinStyle = "Both",
			}
		)
	end
	--if props["Input Restriction"].Value then
		table.insert(ctrl, {
			Name = "Restrict Mode",
			ControlType = "Text",
			Count = props["Rooms"].Value,
		})
		table.insert(ctrl, {
			Name = "Restrict Inputs",
			ControlType = "Text",
			Count = props["Rooms"].Value,
		})
	--end

	--[[DEBUG USE ONLY
	table.insert(ctrl, {
		Name = "code",
		ControlType = "Text",
		Count = 1,
		UserPin = true,
		PinStyle = "Input",
		})]]

	return ctrl
end

function GetControlLayout(props)
	local boxMargin, elementMargin = { 8, 8, 8, 8 }, { 20, 4, 4, 4 }
	local boxIndent = { 40, 0, 0, 80 }
	local tablePosX, tablePosY, currentPosY = 0, 0, 0
	local top, right, bottom, left = 1, 2, 3, 4

	local buttonSize = { 36, 16 }
	local textboxSize = { 36, 16 }
	local textDisplaySize = { 64, 16 }
  local ledSize = { 16, 16 }
	local x, y = 1, 2

	local inQty = props["Inputs"].Value
	local roomQty = props["Rooms"].Value
	local wallQty = props["Walls"].Value

	local roomsBoxPos = { boxMargin[left] + boxIndent[left], boxMargin[top] }
	local roomsBoxSize = { elementMargin[left] + elementMargin[right] + 
						textboxSize[x] * roomQty,
						elementMargin[top] + ledSize[y] + textboxSize[y] +
						elementMargin[bottom] + elementMargin[top] +
						buttonSize[y] * ( inQty + 1 ) + elementMargin[bottom]}
	local inputsBoxPos = { boxMargin[left], boxMargin[top] + boxIndent[top] }
	local inputsBoxSize = {elementMargin[left] + textDisplaySize[x] + 12 +
						elementMargin[left] + textboxSize[x] * roomQty +
						elementMargin[right],
						elementMargin[top] + ledSize[y] + textDisplaySize[y] *
						( inQty + 1 ) + elementMargin[bottom] }
	local wallsBoxPos = { boxMargin[left], inputsBoxPos[y] + inputsBoxSize[y] +
						boxMargin[top] }
	local wallsBoxSize = {inputsBoxSize[x], elementMargin[top] +
						(( wallQty // roomQty ) +
						( wallQty % roomQty > 0 and 1 or 0 )) * 3 *
						textboxSize[y] + elementMargin[bottom] }
	layout = {}
	graphics = {}

	currentPosY = roomsBoxPos[y] + elementMargin[top]
	tablePosX = roomsBoxPos[x] + elementMargin[left]
	for i = 1, inQty, 1 do
		table.insert(graphics, {
			Type = "Text",
			Text = tostring(i),
			HTextAlign = "Right",
			Position = { inputsBoxPos[x] + elementMargin[left], inputsBoxPos[y] +
						ledSize[y] + elementMargin[top] + textDisplaySize[y] * i + 1 },
			Size = textDisplaySize,
		})
	end
	for r = 1, roomQty, 1 do
		tablePosY = currentPosY

		table.insert(graphics, {
			Type = "Text",
			Text = tostring(r),
			HTextAlign = "Center",
			Size = textboxSize,
			Position = { tablePosX, tablePosY }
		})

		tablePosY = tablePosY + textboxSize[y] + elementMargin[bottom] +
					elementMargin[top]

    layout["Room LED "..r] = {
      Style = "Led",
      Size = ledsize,
      Position = { tablePosX + 10 , tablePosY },
    }
    
    tablePosY = tablePosY + buttonSize[y]

		layout["Room Select "..r] = {
			Style = "Textbox",
			Size = buttonSize,
			Position = { tablePosX, tablePosY },
			HTextAlign = "Center",
			PrettyName = "Room "..r.."~Select",
      Legend = "1",
      Text = "1",
		}

		tablePosY = tablePosY + buttonSize[y]

		for i = 1, inQty, 1 do
			layout["Room "..r.." Input "..i] = {
				Style = "Button",
				ButtonStyle = "Toggle",
				Size = buttonSize,
				Position = { tablePosX, tablePosY },
				PrettyName = "Room "..r.."~Input "..i,
			}
			tablePosY = tablePosY + buttonSize[y]
		end
		
		tablePosX = tablePosX + buttonSize[x]
	end

	currentPosY = wallsBoxPos[y] + elementMargin[top]
	tablePosX = wallsBoxPos[x] + elementMargin[left] + textDisplaySize[x] + 
				12 + elementMargin[left]

	if props["Input Restriction"].Value then
		local restrictBoxSize = { inputsBoxSize[x], elementMargin[top] +
								textboxSize[y] * 2 + elementMargin[bottom] }
		local restrictBoxPos = { wallsBoxPos[x], wallsBoxPos[y] }
		wallsBoxPos[y] = wallsBoxPos[y] + restrictBoxSize[y] + boxMargin[bottom]
		roomsBoxSize[y] = roomsBoxSize[y] + boxMargin[bottom] + restrictBoxSize[y]
		
		table.insert(graphics, {
			Type = "GroupBox",
			Text = "Input Restrict",
			HTextAlign = "Left",
			StrokeWidth = 1,
			CornerRadius = 8,
			Position = restrictBoxPos,
			Size = restrictBoxSize,
			})
		table.insert(graphics, {
			Type = "Text",
			Text = "Mode",
			HTextAlign = "Right",
			Position = { restrictBoxPos[x] + elementMargin[left],
						restrictBoxPos[y] + elementMargin[top] },
			Size = textDisplaySize,
			})
		table.insert(graphics, {
			Type = "Text",
			Text = "Inputs",
			HTextAlign = "Right",
			Position = { restrictBoxPos[x] + elementMargin[left],
						restrictBoxPos[y] + elementMargin[top] + textboxSize[y] },
			Size = textDisplaySize,
			})

		for r = 1, roomQty, 1 do
			tablePosY = currentPosY

			layout["Restrict Mode "..r] = {
				Style = "ComboBox",
				Size = textboxSize,
				Position = { tablePosX, tablePosY }
				}

			tablePosY = tablePosY + textboxSize[y]

			layout["Restrict Inputs "..r] = {
				Style = "Textbox",
				Size = textboxSize,
				Position = { tablePosX, tablePosY }
				}

			tablePosX = tablePosX + textboxSize[x]

		end

		currentPosY = wallsBoxPos[y] + elementMargin[top]
		tablePosX = wallsBoxPos[x] + elementMargin[left] + textDisplaySize[x] + 
				12 + elementMargin[left]
	end


	

	for w = 1, wallQty, 1 do
		tablePosY = currentPosY
		
		table.insert(graphics, {
			Type = "Text",
			Text = tostring(w),
			HTextAlign = "Centre",
			Size = textboxSize,
			Position = { tablePosX, tablePosY }
			})

		tablePosY = tablePosY + textboxSize[y]

		layout[wallQty > 1 and "Wall Opens "..w or "Wall Opens"] = {
			Style = "Button",
			ButtonStyle = "Toggle",
			Size = buttonSize,
			Position = { tablePosX, tablePosY},
			HTextAlign = "Centre",
			PrettyName = "Wall "..w.."~Open",
			}
		
		tablePosY = tablePosY + textboxSize[y]
		
		layout[wallQty > 1 and "Wall Rooms "..w or "Wall Rooms"] = {
			Style = "Textbox",
			Size = textboxSize,
			Position = { tablePosX, tablePosY },
			HTextAlign = "Centre",
			PrettyName = "Wall "..w.."~Rooms",
			}
		
		tablePosX = tablePosX + textboxSize[x]
		
		if w % roomQty == 1 then
			table.insert(graphics, {
				Type = "Text",
				Text = "Open",
				HTextAlign = "Right",
				Size = textDisplaySize,
				Position = { inputsBoxPos[x] + elementMargin[left],
							currentPosY + textboxSize[y] }
				})
			table.insert(graphics, {
				Type = "Text",
				Text = "Rooms",
				HTextAlign = "Right",
				Size = textDisplaySize,
				Position = { inputsBoxPos[x] + elementMargin[left],
							currentPosY + textboxSize[y] * 2 }
				})
		end
		if w % roomQty == 0 then	-- Add another row & wrap around
			currentPosY = tablePosY + buttonSize[y]
			tablePosX = wallsBoxPos[x] + textDisplaySize[x] + 12 +
						elementMargin[left]
		end
		
		tablePosY = currentPosY
	end
	
		table.insert(graphics, {
			Type = "GroupBox",
			Text = "Rooms",
			HTextAlign = "Left",
			StrokeWidth = 1,
			CornerRadius = 8,
			Position = roomsBoxPos,
			Size = roomsBoxSize,
    })
		table.insert(graphics, {
			Type = "GroupBox",
			Text = "Inputs",
			HTextAlign = "Left",
			StrokeWidth = 1,
			CornerRadius = 8,
			Position = inputsBoxPos,
			Size = inputsBoxSize,
    })
    table.insert(graphics, {
      Type = "Text",
      Text = "Combined",
      HTextAlign = "Right",
      Position =  { inputsBoxPos[x] + elementMargin[left], inputsBoxPos[y] +
						 elementMargin[top] },
      Size = textDisplaySize,
    })
		table.insert(graphics, {
			Type = "Text",
			Text = "Select",
			HTextAlign = "Right",
			Position = { inputsBoxPos[x] + elementMargin[left], inputsBoxPos[y] +
						ledSize[y] + elementMargin[top] },
			Size = textDisplaySize,
    })
		table.insert(graphics, {
			Type = "GroupBox",
			Text = "Walls",
			HTextAlign = "Left",
			StrokeWidth = 1,
			CornerRadius = 8,
			Position = wallsBoxPos,
			Size = { wallsBoxSize[x], wallsBoxSize[y] }
			})

		--DEV ONLY REMOVE LATER
		layout["code"] = {
			Style = "Textbox",
			Size = buttonSize,
			Position = { 0, 0 },
		}

	return layout, graphics
end

function GetPins(props)
	return {}
end

function GetComponents(props)
	return {}
end

function GetWiring(props)
  return {}
end

if Controls then
  --Convert all single controls to arrays.  Thanks Callum Brieske.
  for i, v in pairs(Controls) do
    if type(v) == "userdata" then
      local c = v
      Controls[i] = {}
      Controls[i][1] = c
    end
  end
  
  --\/\/  Helper Functions  \/\/--
  
  function printmap() --dev helper function
    local x = ""
    for w = 1, Properties["Walls"].Value do
      for r = 1, Properties["Rooms"].Value do
        x = x..tostring(map[w][r]).."\t"
      end
      print(x)
      x = ""
    end
  end
  
  function printtable(prefix, t)
  	local x = ""
  		for i, v in ipairs(t) do
  			x = x..tostring(v).."\t"
  		end
  	print(prefix, x)
  end
  
  function printwalls()
    for w = 1, Properties["Walls"].Value do
      print (wallsState[w])
    end
  end
    
  function tablefind(t, f) -- find element v of t satisfying f(v)
  	for _, v in ipairs(t) do
  	  if f == v then
  		  return v
  	  end
  	end
  	return nil
  end
  
  function tableconcat(t1, t2) -- t2 gets added onto the end of t1, removes duplicates
    for _, v in ipairs(t2) do
      if not tablefind(t1, v) then table.insert(t1, v) end
    end
  end
  
  --/\/\  Helper Functions  /\/\--
  
  --\/\/  Program Functions  \/\/--
  
  function groupInputSync(group)
    print("function start", "groupInputSync", group)
    local masterRoomInput = rooms[group]["currentInput"]
    local groupValidInputs = groups[group]["validInputs"]
    
    --if the group's masterRoom currentInput is not in group's validInputs
    if not tablefind(groupValidInputs, masterRoomInput) then
      --update the first/only room's currentInput
      masterRoomInput = groupValidInputs[1]
    end
    --trigger a group switch to the validInput
    groupSwitch(masterRoomInput, group, 1)
  end
  
  function updateRoomValidInputs(room)
    print("function start", "updateRoomValidInputs", room)
    local mode = rooms[room]["restrictionMode"]
    print("the restriction mode is "..mode)
    
    local totalInputs = Properties["Inputs"].Value
    local roomRestrictionInputs = rooms[room]["restrictionInputs"]
    
    --start building new validInputs table from scratch
    local roomValidInputs = {}
    
    if mode == bypass then --add all available inputs to allowed list.
      for input = 1, totalInputs do
        table.insert(roomValidInputs, input)
      end
    else --read restricted inputs
      
      if mode == allow then --and add only those in the inputs box to the allowed list.
        for _, input in ipairs(roomRestrictionInputs) do
          if input > 0 and input <= totalInputs then -- if valid input
            table.insert(roomValidInputs, input)
          end
        end
      elseif mode == restrict then --add all inputs except those in the inputs box to the allowed list.
        for input = 1, totalInputs do
          if not tablefind(roomRestrictionInputs, input) then
            table.insert(roomValidInputs, input)
          end
        end
      end
    end
    printtable("function end\tupdateRoomValidInputs", roomValidInputs)
    rooms[room]["validInputs"] = roomValidInputs
    
    --pass this new info onto the group
    updateGroupValidInputs(rooms[room]["group"])
  end    
  
  function updateGroupValidInputs(group)
    print("function start", "updateGroupValidInputs", group)
    --start with a blank table
    local groupValidInputs = {}
    local groupMembers = groups[group]["members"]
    
    --for each room in the group
    for _, room in ipairs(groupMembers) do
      --look at room validInputs and add to group validInputs
      for _, input in ipairs(rooms[room]["validInputs"]) do
        if not tablefind(groupValidInputs, input) then
          table.insert(groupValidInputs, input)
        end
      end
    end
    
    groups[group]["validInputs"] = groupValidInputs
    printtable("function end\tupdateGroupValidInputs", groupValidInputs)
    --now that the valid inputs have been updated, let's check the group's current inputs for validity
    groupInputSync(group)
  end

  function roomSwitch(input, room, state) -- Create radio buttons.  Thanks to Callum Brieske.
    print("function start", "roomSwitch", input, room, state)
    
    input, room = tonumber(input), tonumber(room)
    --for each input button for the room
    for i, v in ipairs(Controls["Room "..room.." Input"]) do
      v.Value = i == input and 1 or 0
    end
    --update global variable and text
    rooms[room]["currentInput"] = input
    Controls["Room Select"][room].String = tostring(input) --tostring captures the nil setting
  end

  function groupSwitch(input, group, state)
    print("function start", "groupSwitch", input, group, state)
    --switch all rooms in this group to the input
    
    for _, room in ipairs(groups[group]["members"]) do
      roomSwitch(input, room, state)
    end
  end
  
  function parseRange(strToParse, max)
    local t = {}
    local s = ""
    if #strToParse > 0 then
      local safety = 0
      
      -- first look for ranges of digits eg 1-4
      local matchRange = "([%d]+)%-([%d]+)"
      -- remove any crap at the start plus the matchRange
      local removeRange = "[^%d]*"..matchRange
      
      while(strToParse:match(matchRange)) do
      
    		local rangeA, rangeB = strToParse:match(matchRange)
        rangeA, rangeB = tonumber(rangeA), tonumber(rangeB)
        
        --build the string to return
        
        --math.min/max used in case someone entered a range with decending digits and to keep range inside 1 to max.
        local rangeMin = math.max(1, math.min(rangeA, rangeB))
        local rangeMax = math.min(max, math.max(rangeA, rangeB))
        --sanitise string output
        s = s == "" and s..tostring(rangeMin).."-"..tostring(rangeMax) or s..", "..tostring(rangeMin).."-"..tostring(rangeMax)
        
        --add each digit to the table
        for digit = rangeMin, rangeMax do
          if digit > 0 then table.insert(t, digit) end
        end
        
        --remove the parsed part of the string
    		strToParse = strToParse:gsub(removeRange, "", 1)
        
        --Loop Safety check
    		safety = safety + 1
    		if safety > 100 then --probably runaway error, I mean who's going to have more than 100 rooms on a wall or inputs being restricted?
          print("parseTextBox() runaway error loop 1 safety count "..safety)
          break
        end
    	end
    end
    return t, s, strToParse
  end
  
  function parseDigits(strToParse, max)
    local t = {}
    local s = ""
    
    if #strToParse > 0 then
      safety = 0
      local matchDigit = "%d+"
      --remove any crap on either side of the digit
      local removeDigit = "[^%d]*"..matchDigit.."[^%d]*" 
      
    	while(strToParse:match(matchDigit)) do
        local digit = tonumber(strToParse:match(matchDigit))
        
        
        
        if digit > 0 and digit <= max then
          --add each digit to the table
          table.insert(t, digit)
          
          --build the string
          s = s == "" and s..strToParse:match(matchDigit) or s..", "..strToParse:match(matchDigit)
        end
        
        --remove the parsed part of the string
    		strToParse = strToParse:gsub(removeDigit, "", 1)
        
        --Loop Safety check
    		safety = safety + 1
      	if safety > 100 then --probably runaway error, I mean who's going to have more than 100 rooms on a wall or inputs being restricted?
          print("parseTextBox() runaway error loop 2 safety count "..safety)
          break
        end
    	end
    end
    return t, s
  end
  
  function parseTextBox(strToParse, max)
    --look for ranges first and then digits
    local t1, t2 = {}, {}
    local s1, s2 = "", ""
    t1, s1, leftoverStr = parseRange(strToParse, max)
    t2, s2 = parseDigits(leftoverStr, max)
    
    tableconcat(t1, t2)
    table.sort(t1)
    
    local separator = ","
    if s1 == "" or s2 == "" then separator = "" end
    local s = s1..separator..s2
    
    return t1, s
  end
  
  function getAdjacentRooms(room)
    print("function start", "getAdjacentRooms", room)
  	--print("function start on room"..room)
  	local t = {}
  	for wall, roomsTable in ipairs(map) do
  		--print("w"..w, "rms"..tostring(rms))
      --print(wallsState[w])
  		if wallsState[wall] and roomsTable[room] then --if the wall is open, and the room & wall are paired
  			--print("rms[room] true")
  			for r, path in ipairs(roomsTable) do
  				--print("r"..r, "valid"..tostring(valid))
  				if path and r ~= room then
  					--print("valid and r isn't room")
  					table.insert(t, r)
  				end
  			end
  		end
  	end
    printtable("function end\tgetAdjacentRooms", t)
  	return t
  end
  
  function getStartingRooms(wall)
    print("function start", "getStartingRooms", wall)
  	local t = {}
    if wall == 0 then -- special wall used on init, get all rooms
      for r = 1, Properties["Rooms"].Value do
        table.insert(t, r)
      end
    else
    	for r, valid in ipairs(map[wall]) do
    		if valid then
    			table.insert(t, r)
    		end
    	end
    end
    printtable("function end\tgetStartingRooms", t)
  	return t
  end
  
  function updateLEDs(group)
    print("function start updateLEDs("..tostring(group)..")")
    local groupMembers = groups[group]["members"]
    --if there's more than 1 room in the group, all rooms must be in a combined state.
    local combinedState = #groupMembers > 1 and true or false
    local color = #groupMembers % #LEDColours
    for _, room in ipairs(groupMembers) do
      Controls["Room LED"][room].Boolean = combinedState
      if combinedState then
        Controls["Room LED"][room].Color = LEDColours[group]
      else
        Controls["Room LED"][room].Color = "#7C0000"
      end
    end
    print("function end updateLEDs")
  end
  
  function findRoomGroups(wall)
    print("function start", "findRoomGroups", wall)
    
    local unvisitedRooms = getStartingRooms(wall)
    
    local safetyA = 0 
    while #unvisitedRooms > 0 do
      local lowestRoom = 0
    	local startingRoom = unvisitedRooms[1]
    	local currentGroup = {}
    	local roomStack = {}      
      local safetyB = 0
    	
      safetyA = safetyA + 1
      table.insert(roomStack, startingRoom)
      
    	while #roomStack > 0 do
    		local currentRoom = table.remove(roomStack)
        
        safetyB = safetyB + 1
    		table.insert(currentGroup, currentRoom)
        
    		for i, v in ipairs(unvisitedRooms) do
    			if v == currentRoom then
    				table.remove(unvisitedRooms, i)
    			end
    		end
    
    		for _, adjacentRoom in ipairs(getAdjacentRooms(currentRoom)) do
    			if not tablefind(currentGroup, adjacentRoom) and not tablefind(roomStack, adjacentRoom) then
    				table.insert(roomStack, adjacentRoom)
    			end
    		end
    		if safetyB > 50 then
    			break end
    	end 
      
      table.sort(currentGroup)
      
      local group = currentGroup[1] --lowest room number denotes the group number
      groups[group]["members"] = currentGroup
      groups[group]["validInputs"] = {}
      
      for _, room in ipairs(groups[group]["members"]) do
        --as well as add members into the groups table, add the groupNo into the rooms[room]["group"] variable
        rooms[room]["group"] = group
      end
      
      updateLEDs(group)
      
      printtable("function end\tfindRoomGroups\t"..tostring(group), currentGroup)
      
      updateGroupValidInputs(group)
      --printtable("group "..currentGroup[1].." contains:", currentGroup)
      
    	if safetyA > 50 then
    		break end
    end
  end
  
  --/\/\  Program Functions  /\/\--  

  
  --\/\/  User Control Functions  \/\/--

  function userSwitch(input, room, state)
    print("function start", "userSwitch", input, room, state)
    --user has requested to switch inputs
    
    local group = rooms[room]["group"]
    local roomCurrentInput = rooms[room]["currentInput"]
    local groupValidInputs = groups[group]["validInputs"]
    
    --if the button is on, and the user is allowed to switch to this input
    if state and tablefind(groupValidInputs, input) then
      --get the group this room belongs to
      local group = rooms[room]["group"]
      
      --switch the group
      groupSwitch(input, group, state)
    else
      --switch this room back to itself
      --in the case of a button state being off, it gets switched on again, same input
      --in the case of a button state being on, but the input not being valid it maintains the currentInput
      roomSwitch(roomCurrentInput, room, 1)
    end
  end
  
  function userRestrictModeChange(room, mode)
    print("function start", "userRestrictModeChange", room, mode)
    
    --local group = rooms[room]["group"]
    
    --update global variable
    rooms[room]["restrictionMode"] = mode
    
    --update room and group valid inputs and then check the group is on valid input.
    updateRoomValidInputs(room)
  end
  
  function userRestrictInputsChange(room, inputsTextBox)
    print("function start", "userRestrictInputsChange", room, inputsTextBox)
    local inputQty = Properties["Inputs"].Value
    
    --parse text
    local inputsTable, sanitisedText = parseTextBox(inputsTextBox, inputQty)
    
    --update global variable
    rooms[room]["restrictionInputs"] = inputsTable
    
    --sanitised string to go back to the user
    Controls["Restrict Inputs"][room].String = sanitisedText
    
    updateRoomValidInputs(room)
  end
  
  function userWallOpenChange(wall, state)
    print("function start", "userWallOpenChange", wall, state)
    
    --update global variable
    wallsState[wall] = state
    
    findRoomGroups(wall)
  end

  function userWallRoomsChange(wall, roomsTextBox)
    print("function start", "userWallRoomsChange", wall, roomsTextBox)
    
    local roomQty = Properties["Rooms"].Value
    
    --parse text
    local roomsTable, sanitisedText = parseTextBox(roomsTextBox, roomQty)
    
    --sanitised string to go back to the user
    Controls["Wall Rooms"][wall].String = sanitisedText
    
    --rebuild this wall in the map, for every room
    for r = 1, Properties["Rooms"].Value do
      map[wall][r] = tablefind(roomsTable, r) and true or false
    end

    --if the wall is open then the room groups will have changed
    if wallsState[wall] then
      findRoomGroups(wall)
    end

  end 

  --/\/\  User Control Functions  /\/\--
  --\/\/  Declare Global Variables  \/\/-- 
  --[[
  all rooms belong to a group even if there's only one room in the group.
  The group's lowest numbered room determines the group number.
  When groups are changed, the individual allowed inputs for each group-room
  member are added to the group.
  Inputs are switched by group, and not by room.
  ]]--
  
  bypass = "Bypass"
  restrict = "Restrict"
  allow = "Allow"  
  
  allInputs = {}
  for i = 1, Properties["Inputs"].Value do
    table.insert(allInputs, i)
  end
  
  rooms = {} --rooms[roomNo]["data"] data = restrictionMode,validInputs,group,input
  allRooms = {} -- just a table of room numbers
  groups = {} --groups[groupNo]["data"] data = validInputs, members
  
  for r = 1, Properties["Rooms"].Value do
    table.insert(allRooms, r)
    rooms[r] = {}
    groups[r] = {}
    
    -- if there's something in the text box, use that, otherwise default to input 1
    rooms[r]["currentInput"] = Controls["Room Select"][r].String ~= "" and tonumber(Controls["Room Select"][r].String) or 1
    Controls["Room Select"][r].String = rooms[r]["currentInput"]
    
    rooms[r]["restrictionMode"] = Controls["Restrict Mode"][r].String == "" and bypass or Controls["Restrict Mode"][r].String
    Controls["Restrict Mode"][r].String = rooms[r]["restrictionMode"]
    print("init restriction mode is "..rooms[r]["restrictionMode"])
    rooms[r]["restrictionInputs"], Controls["Restrict Inputs"][r].String = parseTextBox(Controls["Restrict Inputs"][r].String, Properties["Inputs"].Value)
    rooms[r]["group"] = r
    rooms[r]["validInputs"] = allInputs --initial assign to all rooms, then update to actual rooms below
    
    
    Controls["Restrict Mode"][r].Choices = { bypass, restrict, allow }
    
    groups[r]["members"] = {r}
    
    
    for i = 1, Properties["Inputs"].Value do
      Controls["Room "..r.." Input"][i].Boolean = rooms[r]["currentInput"] == i and true or false
    end
  end
  
  map = {} --map[wallNo][roomNo] = true or false depending on if there is an association or not.
  local walls = {} --only used for init
  wallsState = {} --wallsState[wallNo]
  for w = 1, Properties["Walls"].Value do
    walls[w], Controls["Wall Rooms"][w].String = parseTextBox(Controls["Wall Rooms"][w].String, Properties["Walls"].Value)
    wallsState[w] = Controls["Wall Opens"][w].Boolean
    map[w] = {}
    for r = 1, Properties["Rooms"].Value do
      map[w][r] = tablefind(walls[w], r) and true or false
    end
  end
 
  for w = 1, Properties["Walls"].Value do --can't run this above as map has not been generated yet.
    if wallsState[w] then
      findRoomGroups(w)
    end
  end
  
  for r = 1, Properties["Rooms"].Value do
    updateRoomValidInputs(r)
  end
    
  --/\/\  Declare Global Variables  /\/\--

  --\/\/  Event Handlers  \/\/-- 
  
  for r = 1, Properties["Rooms"].Value, 1 do
    Controls["Room Select"][r].EventHandler = function(ctl) userSwitch(ctl.String, r, 1) end
    for i = 1, Properties["Inputs"].Value, 1 do
      Controls["Room "..r.." Input"][i].EventHandler = function(ctl) userSwitch(i, r, ctl.Boolean) end
    end
    
    if Properties["Input Restriction"].Value then
  	  Controls["Restrict Mode"][r].EventHandler = function(ctl) userRestrictModeChange(r, ctl.String) end
      Controls["Restrict Inputs"][r].EventHandler = function(ctl) userRestrictInputsChange(r, ctl.String) end
    end
  end
  for w = 1, Properties["Walls"].Value, 1 do
    Controls["Wall Opens"][w].EventHandler = function(ctl) userWallOpenChange(w, ctl.Boolean) end
    Controls["Wall Rooms"][w].EventHandler = function(ctl) userWallRoomsChange(w, ctl.String) end
  end 
end

