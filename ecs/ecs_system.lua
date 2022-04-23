local ecs_system = {}
ecs_system.__index = ecs_system

package.path = package.path..";./utils/?.lua"
package.path = package.path..";../utils/?.lua"

local utils = require "utils"

local log_func = print

local function log_verbose (s)
  utils.log_verbose(s,log_func)
end

-- API
-- set outer log function for embedding
function ecs_system:set_log_func (f)
  self.log_func = f
end

function ecs_system:create_system ()
  local ret = {}
  ret.active = true
  ret.funcs = {}
  ret.req = nil
  setmetatable(ret,ecs_system)
  return ret
end

function ecs_system:add_func (f)
  self.funcs[#self.funcs+1] = f
end

function ecs_system:set_req (f)
  self.req = f
end

function ecs_system:update (e)
  if self.req(e) then
    for i=1, #self.funcs do
      print (e.name..": ")
      self.funcs[i](e)
    end
  end
end

return ecs_system