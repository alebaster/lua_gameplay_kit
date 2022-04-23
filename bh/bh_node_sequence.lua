local bh_node = require "bh_node"

local bh_node_sequence = {}
bh_node_sequence.__index = bh_node_sequence
setmetatable(bh_node_sequence, {__index = bh_node})

-- API
function bh_node_sequence:create (id)
  local ret = bh_node:create(id)
  setmetatable(ret, bh_node_sequence)
  return ret
end

-- override
function bh_node_sequence:exec ()
  print("exec sequence "..self.id)
  -- fail if any child fail
  for i=1, #self.childs, 1 do
    local res = self.childs[i]:exec()
    if res ~= bh_node.result.succeess then
      return bh_node.result.fail
    end
  end
  return bh_node.result.success
end

return bh_node_sequence