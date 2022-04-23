local bh = {}
bh.__index = bh

package.path = package.path..";./utils/?.lua"..";./bh/?.lua"
package.path = package.path..";../utils/?.lua"

local utils = require "utils"

local bh_node_class = require "bh_node"
local bh_node_action_class = require "bh_node_action"
local bh_node_selector_class = require "bh_node_selector"
local bh_node_sequence_class = require "bh_node_sequence"

local log_func = print

--local bh.nodes = {}

local function log_verbose (s)
  utils.log_verbose(s,log_func)
end

local function new_node(name,parent,type,func)
  local ret
  if type == "selector" then
    ret = bh_node_selector_class:create(name)
  elseif type == "sequence" then
    ret = bh_node_sequence_class:create(name)
  elseif type == "action" then
    ret = bh_node_action_class:create(name)
    ret.func = func
  end
  return ret
end

-- API
-- set outer log function for embedding
bh.set_log_func = function (f)
  log_func = f
end

function bh:create ()
  local ret = {}
  ret.nodes = {}
  
  setmetatable(ret,bh)
  
  return ret
end

function bh:add_node (name,parent,type,func)
  if self.nodes[name] ~= nil then
    self.nodes[parent]:add_child(self.nodes[name])
  end
  local node = new_node(name,parent,type,func)
  if parent == nil then -- root
    self.root = node
  else
    self.nodes[parent]:add_child(node)
  end
  self.nodes[name] = node
end

function bh:update ()
  return self.root:exec()
end

return bh