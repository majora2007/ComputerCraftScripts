os.loadAPI('Utils')


local bControl = true
local event, id, message
local slave = 19

local modemSides = {}
local slaves = {}


local bLight = false

local tArgs = { ... }
local commands = {"mcp_light=ON", "mcp_light=OFF", "mcp_light=BLINK", "mcp_light=REDNET",
		  "mcp_register", "mcp_acknowledged", "mcp_unregister"}
local paramList = {{"-s", slaves}, {"-ms", modemSides}}




getParams = function(tArgs, t, counter) 
  local tCounter = counter
  
    while tCounter <= #tArgs and string.find(tArgs[tCounter], "-", 1) == nil do 
        if type(tArgs[tCounter])== "string" then string.lower(tArgs[tCounter]) end
        table.insert(t, tArgs[tCounter])
        tCounter = tCounter + 1
    end
    
  return tCounter
end


if #tArgs == 0 then
  	print( "Usage: modemControl -s <slave0> <...> -ms <side0> <side1> <...>" )
  	bControl = false
  	return
  end

function parseParameters(tArgs, paramList)
  local counter = 1
  
  for i = 1, #paramList do
    if paramList[i][1] == tArgs[counter] then
      print("Param Flag match: "..tArgs[counter]);
      counter = getParams(tArgs, paramList[i][2], counter + 1)
    end
  end
end

parseParameters(tArgs, paramList)



for i = 1, #modemSides do
  Utils.openModem(modemSides[i])
end






-- Handles user input from keyboard
function handleUserInput(msg)
  local t = ""
  
  if msg == "l0" then print(msg) end

  if msg == "l" then
    if bLight then bLight = false else bLight = true end
    if bLight then t = "m_light=ON" else t = "m_light=OFF" end
    rednet.send(slave, t)
  elseif msg == "b" then
    rednet.send(slave, "m_light=BLINK")
  elseif msg == "s" then
    print("Sending register signal...")
    rednet.broadcast("mcp_register")
  elseif msg == "q" then
    for i = 1, #slaves do
      rednet.send(slaves[i], "mcp_unregister")
    end
    
    for i = 1, #modemSides do
      Utils.closeModem(modemSides[i])
    end
  end
end

print("Modem Controller ID = " .. os.getComputerID())
-- First send my message over broadcast to register slave
rednet.broadcast("mcp_register")

while bControl do
  local event, id, message = os.pullEvent()
  
   if message == "mcp_acknowledged" then
       table.insert(slaves, id)
       print("Added " .. id.." to slave list.");
   end
   
   if event == "char" then
       print(id)
       handleUserInput(id)
   end
  
  --clear()
  --printMenu()
end

