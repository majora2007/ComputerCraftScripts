os.loadAPI('Utils')


local bControl = true
local bLight = false
local bLightBlink = false
local master = {}

local lightSides = {}
local modemSides = {}

-- Some commands
local commands = {"mcp_light=ON", "mcp_light=OFF", "mcp_light=BLINK", "mcp_light=REDNET",
		  "mcp_register", "mcp_acknowledged", "mcp_unregister"}


-- Get args for light side and modem sides
local tArgs = { ... }
if #tArgs == 0 then
	print( "Usage: wirelessModem -ls <side> -ms <side0> <side1> <...>" )
	return
end


function update()
  if bLight then 
    for i = 0, #lightSides do
      redstone.setOutput(lightSides[i].."", true) 
    end
  else 
    for i = 0, #lightSides do
      redstone.setOutput(lightSides[i].."", false) 
    end
  end
  
  if bLightBlink then shell.run("blinkLight.lua") else print("Terminating blinkLight.lua")  end
end

function processMessage(msg)
  print("Processing message")

  if msg == "m_light=ON" then bLight = true
  elseif msg == "m_light=OFF" then bLight = false
  elseif msg == "m_light=BLINK" then bLightBlink = true 
  end
  
  update()
end

--------------------------
-- 	START 		--
--------------------------
lightParams = function(tArgs, t, counter) 
  local tCounter = counter

  while tCounter <= #tArgs and string.find(tArgs[tCounter], "-", 1) == nil do 
      if type(tArgs[tCounter])== "string" then string.lower(tArgs[tCounter]) end
      table.insert(t, tArgs[tCounter])
      tCounter = tCounter + 1
  end
  
  return tCounter
end

-- Support for: counter = paramList[i][2](tArgs, lightSides, counter + 1)
--local paramList = {{"-ls", lightParams}, {"-ms", lightParams}}
local paramList = {{"-ls", lightSides}, {"-ms", modemSides}}

function parseParameters(tArgs, paramList)
  local counter = 1
  
  for i = 1, #paramList do
        if paramList[i][1] == tArgs[counter] then
          --print("Param Flag match: "..tArgs[counter]);
          --counter = paramList[i][2](tArgs, lightSides, counter + 1)
          counter = lightParams(tArgs, paramList[i][2], counter + 1)
        end
  end
end

parseParameters(tArgs, paramList)

-- Remember, things start at 1 here...
for i = 1, #modemSides do
  Utils.openModem(modemSides[i])
end

--print("Wireless Modem Label = " .. os.getComputerLabel())
print("Wireless Modem ID = " .. os.getComputerID())

while bControl do

  local event, id, message = os.pullEvent("rednet_message")
  
  if message == "mcp_register" then
    table.insert(master, id)
    print("Added " .. id.." to master list.");
    rednet.send(id, "mcp_acknowledged")
  end
  
  for i = 1, #master do
    if id == master[i] then processMessage(message) break
    else rednet.send(id, message) end
  end
  
  --[[if id == master then
    processMessage(message)
  else 
    rednet.send(id, message)
  end]]--
end



