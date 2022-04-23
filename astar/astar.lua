local astar = {}
astar.__index = astar

package.path = package.path..";./utils/?.lua"..";./math/?.lua"
package.path = package.path..";../utils/?.lua"..";../math/?.lua"

local vector_class = require "vector2d"
local priority_queue_class = require "priority_queue"

local function get_node(self,node_id)
  if node_id <= 0 or node_id > self.map_rows*self.map_cols then
    return nil
  end

  local i = math.ceil(node_id/self.map_cols)
  local j = node_id - (i-1)*self.map_cols
  --return astar.nodes[math.ceil(node_id/map_cols)][math.fmod(node_id,map_cols)]
  return self.nodes[i][j]
end

local function calc_cost(self,node,parent)
  local ret = node.cost
  if parent ~= 0 then
    local p = get_node(self,parent)
    --print("parent id:", node.parent)
    --print("parent g:", p.g)
    ret = ret + p.g
  end
  --print(ret)
  return ret
end

-- start_node не нужен?
local function add_neighbor_node(self, nn, node, start_node, end_node)
  if self.closed_list[nn.id] ~= nil then
    return
  end
  
  if nn.blocked == true then
    return
  end
  
  local parent = node.id
  local g = calc_cost(self,nn,parent)
  --local g = astar.heuristic(nn.pos,start_node.pos)
  local h = self:heuristic(nn.pos,end_node.pos)
  local f = g + h
  --io.write("id:",nn.id," g:",g," h:",h," f:",f," nn.g:",nn.g," \n")
  
  if (nn.g > g) then
    nn.g = g
    nn.h = h
    nn.f = f
    nn.parent = parent
    --print("add "..nn.id..": f="..nn.f.." h="..nn.h..": g="..nn.g)
    self.open_list:push(nn.id, nn.f)
  end
end

local function get_neighbors(self, node, start_node, end_node)
  local i = math.ceil(node.id/self.map_cols)
  local j =  node.id - (i-1)*self.map_cols
  --print("\nget_neighbors for ", node.id)
  
  if i >= 2 then
    add_neighbor_node(self, self.nodes[i-1][j], node, start_node, end_node)
  end
  if j >= 2 then
    add_neighbor_node(self, self.nodes[i][j-1], node, start_node, end_node)
  end
  if i >= 2 and j >= 2 then
    add_neighbor_node(self, self.nodes[i-1][j-1], node, start_node, end_node)
  end
  if i < self.map_rows then
    add_neighbor_node(self, self.nodes[i+1][j], node, start_node, end_node)
  end
  if j < self.map_cols then
    add_neighbor_node(self, self.nodes[i][j+1], node, start_node, end_node)
  end
  if i < self.map_rows and j < self.map_cols then
    add_neighbor_node(self, self.nodes[i+1][j+1], node, start_node, end_node)
  end
  if i >= 2 and j < self.map_cols then
    add_neighbor_node(self, self.nodes[i-1][j+1], node, start_node, end_node)
  end
  if i < self.map_rows and j >= 2 then
    add_neighbor_node(self, self.nodes[i+1][j-1], node, start_node, end_node)
  end
end

local function get_path (self, node_id)
  local ret = {}
  local i = 1
  local n = get_node(self,node_id)
  while n ~= nil do
    table.insert(ret,1,n.id)
    --ret[i] = n.id
    n = get_node(self,n.parent)
    i = i + 1
  end
  
  return ret
end

-- API
function astar:create (rows, cols)
  local ret = {}
  
  ret.open_list = priority_queue_class:create("min")
  ret.closed_list = {}
  ret.nodes = {}
  ret.map_rows = rows
  ret.map_cols = cols
  
  local num = 1
  for r = 1, rows do
    ret.nodes[r] = {}
    for c = 1, cols do
      ret.nodes[r][c] = {}
      ret.nodes[r][c].id = num
      ret.nodes[r][c].pos = vector_class:create(r,c)
      ret.nodes[r][c].parent = 0
      ret.nodes[r][c].blocked = false
      ret.nodes[r][c].cost = 1
      ret.nodes[r][c].g = 0xffff -- ??
      ret.nodes[r][c].h = 0
      ret.nodes[r][c].f = 0
      num = num + 1
    end
  end
  
  setmetatable(ret,astar)
  
  return ret
end

function astar:get_nodes ()
  return self.nodes
end

function astar:heuristic (pos, goal)
  -- cheb
  return math.max(math.abs(pos.x - goal.x),math.abs(pos.y - goal.y))
end

function astar:path (start_node, end_node)
  start_node.g = 0
  self.open_list:push(start_node.id,0)
  
  while self.open_list.size ~= 0 do
    local node_id = self.open_list:pop().id
    
    if node_id == end_node.id then
      return get_path(self,node_id)
    end    
    
    self.closed_list[node_id] = true
    
    local node = get_node(self,node_id)
    get_neighbors(self,node,start_node,end_node)
    --print("-----")
    --self.open_list:print()
  end
  
end

return astar