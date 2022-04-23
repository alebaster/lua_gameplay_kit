local function log (s)
  print(s)
end

local function walk_to_door ()
end

local function open_door ()
return 1
end

local function unlock_door ()
end

local function break_door ()
end

local function walk_through_door ()
end

local function close_door ()
end

package.path = package.path..";./bh/?.lua"

local bh_class = require "bh"
bh_class.set_log_func(log)

local bh = bh_class:create()
bh:add_node("root",nil,"sequence")
  bh:add_node("walk_to_door","root","action",walk_to_door)
  bh:add_node("door_selector","root","selector")
    bh:add_node("open_door","door_selector","action",open_door)
    bh:add_node("door_sequence","door_selector","sequence")
      bh:add_node("unlock_door","door_sequence","action",unlock_door)
      bh:add_node("open_door","door_sequence","action",open_door)
    bh:add_node("break_door","door_selector","action",break_door)
  bh:add_node("walk_through_door","root","action",walk_through_door)
  bh:add_node("close_door","root","action",close_door)

--print(bh:update())
print(bh:update())

