-- Follow a path from a start block to and end block

-- 0 means go up a block, 1 means go North, 2 means go West, 3 means go East, and 4 means go South
local path = {}

local endBlock = 16 -- The end block
local pathBlock = 15 -- block which the path is made up of
local startBlock = 15 -- start block
local fuelBlock = 1

local bFarming = false -- Whether at farm or at refueling station
local bAtDest = true -- Whether at farm or refueling station (end block is under feet)
local bHaveFuel = false
local currDir = 1
local bControl = true


function addToPath(stepDirection)
  table.insert(path, stepDirection)
end

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

function followPath()
  for i,v in ipairs(path) do
    if v == 0 then turtle.up() print("Moving up")
    elseif v == 1 then moveNorth() 
    elseif v == 2 then moveWest()
    elseif v == 3 then moveEast()
    elseif v == 4 then moveSouth() end
  end
end

function atDestination()
  local ret = false
  turtle.select( endBlock )
  if turtle.compareDown() then
    ret = true
    print("At destination")
  else
    ret = false
  end
  turtle.select( pathBlock )
  
  return ret
end

function move(dir)
  if dir == 0 then turtle.up() turtle.forward()
  elseif dir == 1 then moveNorth()
  elseif dir == 2 then moveWest()
  elseif dir == 3 then moveEast()
  elseif dir == 4 then moveSouth() end
end

function name(dir)
  if dir == 0 then return "UP"
  elseif dir == 1 then return "NORTH"
  elseif dir == 2 then return "WEST"
  elseif dir == 3 then return "EAST"
  elseif dir == 4 then return "SOUTH"
  else return "N/A"
  end
end

function contains(tbl, val)
  for i=1, #tbl do
    if tbl[i] == val then return true end
  end
  
  return false
end

-- Will try a step and if it works return true. 
local prevStep = 0
function tryStep()
  local openList = {1,2,3,4}
  local possibleList = {}
  local closedList = {}
  local tempDir = currDir
  local stepWorked = false
  
  --if # path > 0 then prevStep = path[# path] end
  
  print("Previous step was " .. name(prevStep))
  
  -- There is no point in attempting to go the previous path?
  for i = 1, #openList do
    if i ~= prevStep then table.insert(possibleList, openList[i])
    else table.insert(closedList, openList[i]) end
  end
  
  for i = 1, #possibleList do -- we also need 0 at some point
    
    --if 5 - i == prevStep then print("skipping "..name(i).." attempt") i = i + 1 end -- Almost works
    
    if contains(closedList, possibleList[i]) then
    	print("Already been here...")
    else
        move(possibleList[i])
    
    
    if turtle.compareDown() then
        addToPath(possibleList[i])
        stepWorked = true
        print(name(possibleList[i]).." worked, breaking")
        prevStep = 5 - possibleList[i]
        return true
        --break;
    else -- Undo what you've done
      bAtDest = atDestination()
      if bAtDest then return true;
      else
        table.insert(closedList, possibleList[i])
        if contains(closedList, 5 - possibleList[i]) then
          print("what do I do?")
        else 
          move(5 - possibleList[i])
        end
      end
    end
  end
  
  end
  
  
  if stepWorked or bAtDest then return true end
  

  --if turtle.detect() and turtle.compare() then
    --addToPath(0)
  --  turtle.up()
  --  turtle.forward()
  --end
  
  
  
end


turtle.select( pathBlock )
local stepCounter = 0
repeat

  print("Step "..stepCounter)
  tryStep()
  stepCounter = stepCounter + 1



  -- Test if we are at endBlock
  --bAtDest = atDestination()

until atDestination()
--end


