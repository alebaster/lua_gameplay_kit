local ecs_world = {}
ecs_world.__index = ecs_world

package.path = package.path..";./utils/?.lua"
package.path = package.path..";../utils/?.lua"

local utils = require "utils"
local ecs_system_class = require "ecs_system"

local log_func = print

local function log_verbose (s)
  utils.log_verbose(s,log_func)
end

-- API
-- set outer log function for embedding
function ecs_world:set_log_func (f)
  self.log_func = f
end

function ecs_world:create_world ()
  local ret = {}
  ret.systems = {}
  ret.entities = {}
  setmetatable(ret,ecs_world)
  return ret
end

function ecs_world:create_system ()
  local ret = ecs_system_class:create_system()
  return ret
end

function ecs_world:add_system (s)
  self.systems[#self.systems+1] = s
end

function ecs_world:add_entity (e)
  self.entities[#self.entities+1] = e
end

function ecs_world:update ()
  for i=1, #self.systems do
    for j=1, #self.entities do
      self.systems[i].update(self.systems[i],self.entities[j])
    end
  end
end

return ecs_world