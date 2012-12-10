-- The goal of this script is to blink a light (via redstone) either by timer 
-- or when there is rednet activity.

-- version 0.1 - print blink() on a timer

local bControl = true
local timeInterval = 1
local side = "right"


repeat
  
  local blinkTimer = os.startTimer( timeInterval )
  local event, id, message = os.pullEvent("timer")
  print("pulled something from os, id = " .. id)
  
  if blinkTimer == id then
	  if redstone.getInput(side) == true then
	    redstone.setOutput(side, false)
	  else
	    redstone.setOutput(side, true)
	  end
  end
  
  --blinkTimer = os.startTimer( timeInterval )

until bControl

