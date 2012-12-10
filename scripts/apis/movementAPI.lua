-- Movement API which allows manipulation of a Turtle's face/direction, movement, and position.

local face
local pos = {}


------------------------------------------
-- 		Face Functions		--
------------------------------------------
function faceNorth()
  if currDir == 2 then turtle.turnRight() 
  elseif currDir == 3 then turtle.turnLeft()
  elseif currDir == 4 then turtle.turnLeft() turtle.turnLeft() end
  
  currDir = 1
end

function faceWest()
  if currDir == 1 then turtle.turnLeft() 
  elseif currDir == 3 then turtle.turnLeft() turtle.turnLeft()
  elseif currDir == 4 then turtle.turnRight() end
  
  currDir = 2
end

function faceEast()
  if currDir == 1 then turtle.turnRight() 
  elseif currDir == 2 then turtle.turnRight() turtle.turnRight()
  elseif currDir == 4 then turtle.turnLeft() end
  
  currDir = 3
end

function faceSouth()
  if currDir == 1 then turtle.turnRight() turtle.turnRight() 
  elseif currDir == 2 then turtle.turnLeft()
  elseif currDir == 3 then turtle.turnRight() end
  
  currDir = 4
end

------------------------------------------
-- 		Move Functions		--
------------------------------------------

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

function name(dir)
  if dir == 0 then return "UP"
  elseif dir == 1 then return "NORTH"
  elseif dir == 2 then return "WEST"
  elseif dir == 3 then return "EAST"
  elseif dir == 4 then return "SOUTH"
  else return "N/A"
  end
end

function getPosition()
  return myPos[0], myPos[1], myPos[2]
end

function getPosition()
  return myPos
end

function setPosition(x,y,z)
  myPos[0] = x
  myPos[1] = y
  myPos[2] = z
end

