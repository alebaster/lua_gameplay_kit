local bh_node = {}
bh_node.__index = bh_node -- ???

bh_node.result = 
{
  success = 0,
  fail = 1
};

--bh_node.types = 
--{
--  action = "action",
--  condition = "condition",
--  selector = "selector",
--  sequence = "sequence"
--};

-- API
function bh_node:create (id)
  local ret = {}
  ret.id = id
  ret.parent = 0
  ret.childs = {}
  setmetatable(ret,bh_node)
  --self.__index = self
  
  return ret
end

function bh_node:add_child (node)
  --print("add "..node.id.." to "..self.id)
  self.childs[#self.childs+1] = node
  --print(self.childs)
  --print(#self.childs+1)
end

function bh_node:exec ()
  print("wrong exec")
end

return bh_node