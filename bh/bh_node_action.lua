local bh_node = require "bh_node"

local bh_node_action = {}
bh_node_action.__index = bh_node_action
setmetatable(bh_node_action, {__index = bh_node})

-- API
function bh_node_action:create (id)
  local ret = bh_node:create(id)
  ret.func = 0
  setmetatable(ret, bh_node_action)
  return ret
end

-- override
function bh_node:exec ()
  if self.func == nil then
    return bh_node.success
  end
  print("exec action "..self.id)
  return self.func()
end

return bh_node_action