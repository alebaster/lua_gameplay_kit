package.path = package.path..";./utils/?.lua"..";./fsm/?.lua"
package.path = package.path..";../utils/?.lua"

local function log (s)
  print(s)
end

local tmp = true
local ressurected = false
local iter = 0

local utils = require "utils"
local num = 0

local function idle_enter ()
  print("idle_enter")
end

local function idle_update ()
  print("idle_update")
end

local function idle_exit ()
  print("idle_exit")
end

local function go_enter ()
  print("go_enter")
end

local function go_update ()
  print("go_update")
end

local function go_exit ()
  print("go_exit")
end

local function fire_enter ()
  print("fire_enter")
end

local function fire_update ()
  print("fire_update")
end

local function fire_exit ()
  print("fire_exit")
end

-- second
local function die_enter ()
  print("die_enter")
end

local function die_update ()
  print("die_update")
end

local function die_exit ()
  print("die_exit")
end

local function ressurect_enter ()
  print("ressurect_enter")
  iter = iter + 1
end

local function ressurect_update ()
  print("ressurect_update")
end

local function ressurect_exit ()
  print("ressurect_exit")
end

-- transitions
local function ItoG_rule ()
  print("idle to go check")
  return true
end
local function GtoI_rule ()
  print("go to idle check")
end

local function GtoF_rule ()
  print("go to fire check")
  return true
end
local function FtoG_rule ()
  print("fire to go check")
end

local function FtoI_rule ()
  print("fire to idle check")
end
local function ItoF_rule ()
  print("idle to fire check")
end

local function DtoR_rule ()
  print("die to ressurect check")
  ressurected = true
  return true
end

local function F1toF2_rule ()
  print("fsm to fsm2 check")
  if iter == 1 then
    return false
  end
  tmp = not tmp
  if tmp == true then
    print("true")
    return true
  end
end

local function F2toF1_rule ()
  print("fsm2 to fsm check")
  --return false
  if ressurected == true then
      print("true")
      ressurected = false
    return true
  end
end


local fsm_class = require "fsm"

local fsm = fsm_class:create()
--fsm:set_log_func(log)

fsm:add_state("idle", idle_enter, idle_update, idle_exit)
fsm:add_state("go", go_enter, go_update, go_exit)
fsm:add_state("fire", fire_enter, fire_update, fire_exit)

fsm:add_transition("idle", "go", ItoG_rule)
fsm:add_transition("go", "idle", GtoI_rule)

fsm:add_transition("go", "fire", GtoF_rule)
fsm:add_transition("fire", "go", FtoG_rule)

fsm:add_transition("fire", "idle", FtoI_rule)
fsm:add_transition("idle", "fire", ItoF_rule)

local fsm2 = fsm_class:create()

fsm2:add_state("die", die_enter, die_update, die_exit)
fsm2:add_state("ressurect", ressurect_enter, ressurect_update, ressurect_exit)

fsm2:add_transition("die", "ressurect", DtoR_rule)

fsm:add_fsm_transition(fsm2, F1toF2_rule)
fsm2:add_fsm_transition(fsm, F2toF1_rule)

fsm:start("idle",1000)
