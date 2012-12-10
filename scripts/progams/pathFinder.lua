local bAtDest = false
local srcBlock = 14
local pathBlock = 15
local endBlock = 16

function moveNorth()
  if currDir == 2 then turtle.turnRight() 
  elseif currDir == 3 then turtle.turnLeft()
  elseif currDir == 4 then turtle.turnLeft() turtle.turnLeft() end
  
  --if ~face then turtle.forward() end
  turtle.forward()
  currDir = 1
  --print("Moving North")
end

function moveWest()
  if currDir == 1 then turtle.turnLeft() 
  elseif currDir == 3 then turtle.turnLeft() turtle.turnLeft()
  elseif currDir == 4 then turtle.turnRight() end
  
  turtle.forward() 
  currDir = 2
  --print("Moving West")
end

function moveEast()
  if currDir == 1 then turtle.turnRight() 
  elseif currDir == 2 then turtle.turnRight() turtle.turnRight()
  elseif currDir == 4 then turtle.turnLeft() end
  
  turtle.forward() 
  currDir = 3
  --print("Moving East")
end

function moveSouth()
  if currDir == 1 then turtle.turnRight() turtle.turnRight() 
  elseif currDir == 2 then turtle.turnLeft()
  elseif currDir == 3 then turtle.turnRight() end
  
  turtle.forward() 
  currDir = 4
  --print("Moving South")
end

------------------------------------------
-- 	Shortcut Functions		--
------------------------------------------

function move(dir)
  if dir == 0 then turtle.up() turtle.forward()
  elseif dir == 1 then moveNorth()
  elseif dir == 2 then moveWest()
  elseif dir == 3 then moveEast()
  elseif dir == 4 then moveSouth() end
end

function atDestination()

  turtle.select( endBlock )
  if turtle.compareDown() then
    print("At Destination!")
    turtle.select( pathBlock )
    return true
  end
  turtle.select( pathBlock )
  
  return false
end

function atSource()

  turtle.select( srcBlock )
  if turtle.compareDown() then
    print("At Source!")
    turtle.select( pathBlock )
    return true
  end
  turtle.select( pathBlock )
  
  return false
end

function name(dir)
  if dir == 0 then return "UP"
  elseif dir == 1 then return "FWD"
  elseif dir == 2 then return "LEFT"
  elseif dir == 3 then return "RIGHT"
  elseif dir == 4 then return "BACK"
  else return "N/A"
  end
end

function contains(tbl, val)
  for i=1, #tbl do
    if tbl[i] == val then return true end
  end
  
  return false
end

local prevStep = 0
function tryStep()
  local openList = {1,2,3,4}
  local possibleList = {}
  local closedList = {}
  
  for i = 1, #openList do
  
    --[[if atDestination() and i > 1 then 
      return
    elseif contains(closedList, openList[i]) then 
      print("inc")
    else]]--
    
      if atDestination() and i > 1 then 
      return
    elseif openList[i] ~= prevStep then
      move(openList[i])
      
    
      if turtle.compareDown() then
        print("still on track")
        return -- No need to check other paths, we already made a successful step
      else
        table.insert(closedList, 5 - openList[i])
        prevStep = 5 - openList[i]
        move(5 - openList[i])
      end
    end
    
  end
end

function tryStep2()

  for i=1, 4 do
    
    if atDestination() then return true end
    
    if i > prevStep or i < prevStep then
      print(name(i))
      move(i)
      
      if turtle.compareDown() then
        prevStep = 5 - i
        return true -- Valid step
      else
        if atDestination() then return true end
        
        move(5 - i)
      end
    end
  end
  
  print("No direction worked")
  return false

end


repeat

  tryStep2()
  

until atDestination()
