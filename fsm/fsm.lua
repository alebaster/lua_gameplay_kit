local fsm = {}
fsm.__index = fsm

package.path = package.path..";./utils/?.lua"
package.path = package.path..";../utils/?.lua"

local utils = require "utils"

local log_func = print

local function log_verbose (s)
  utils.log_verbose(s,log_func)
end

local function goto_new_state (self,id)
  if self.state ~= nil then
    self.state.exit()
  end
  if type(id) == "table" then
    self.state = nil
    id:start()
  else
    self.state = self.states[id]
    self.state.enter()
    self:update()
  end
end

-- API
-- set outer log function for embedding
function fsm:set_log_func (f)
  self.log_func = f
end

function fsm:create ()
  local ret = {}
  ret.default = nil
  ret.state = nil -- current state
  ret.states = {} -- all states
  -- state {}:
  --   id
  --   enter func
  --   update func
  --   exit func
  --   transitions {}
  --     to id
  --     rule

  --ret.time_step = 500
  setmetatable(ret,fsm)
  return ret
end

function fsm:add_state (id,enter_func,update_func,exit_func)
  if self.states[id] == nil then
    self.states[id] = {id=id,enter=enter_func,update=update_func,exit=exit_func,transitions={}}
    if self.default == nil then
      self.default = id
    end
  end
end

function fsm:add_transition (from,to,rule)
  if self.states[from] ~= nil then
    self.states[from].transitions[to] = {id=to,rule=rule}
  end
end

function fsm:add_fsm_transition(fsm_to, rule)
  for k, v in pairs(self.states) do
    v.transitions[fsm_to] = {id=fsm_to,rule=rule}
  end
end

function fsm:start (first_state,step)
  --self.time_step = step
  if first_state == nil then
    first_state = self.default
  end
  goto_new_state(self,first_state)
end

function fsm:update ()
  self.state.update()
  for k, v in pairs(self.state.transitions) do
    if v.rule() == true then
      goto_new_state(self,v.id)
      return
    end
  end
end

return fsm