package.path = package.path..";./ecs/?.lua"

local function log (s)
  print(s)
end

local entity1 = {
  name = "barrel",
  hp = 200
}

local entity2 = {
  name = "enemy",
  hp = 200,
  pos = 1
}

local function pos_req_func (e)
  return e.pos ~= nil
end

local function damage_req_func (e)
  return e.hp ~= nil
end

local function update_pos_func (e)
  print("update_pos_func")
end

local function update_damage_func (e)
  print("update_damage_func")
end

local ecs_world_class = require "ecs_world"
--local ec_system_class = require "ec_system"

local gameworld = ecs_world_class:create_world()

local damageOverTime_system = ecs_world_class:create_system()
damageOverTime_system:add_func(update_damage_func)
damageOverTime_system:set_req(damage_req_func)
local walk_system = ecs_world_class:create_system()
walk_system:add_func(update_pos_func)
walk_system:set_req(pos_req_func)

gameworld:add_system(damageOverTime_system)
gameworld:add_system(walk_system)

gameworld:add_entity(entity1)
gameworld:add_entity(entity2)

gameworld:update()