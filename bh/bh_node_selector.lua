local bh_node = require "bh_node"

local bh_node_selector = {}
bh_node_selector.__index = bh_node_selector
setmetatable(bh_node_selector, {__index = bh_node})

-- API
function bh_node_selector:create (id)
  local ret = bh_node:create(id)
  setmetatable(ret, bh_node_selector)
  return ret
end

-- override
function bh_node_selector:exec ()
  print("exec selector "..self.id)
  -- fail if every child fail
  for i=1, #self.childs, 1 do
    local res = self.childs[i]:exec()
    if res == bh_node.result.succeess then
      return bh_node.result.succeess
    end
  end
  return bh_node.result.fail
end

return bh_node_selector