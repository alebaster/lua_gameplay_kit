local pq = {}
pq.__index = pq

package.path = package.path..";./utils/?.lua"
package.path = package.path..";../utils/?.lua"

local utils = require "utils"

local function for_min(a,b)
  return a < b
end
--local compare = for_min

local function for_max(a,b)
  return a > b
end

--local function deep_copy(from)
--  local copy = {}
--  for k,v in pairs(from) do
--    copy[k] = v
--  end
--  return copy
--end

local function swap_fields(a, b)
  local tmp = {}
  for k,v in pairs(a) do
    tmp[k] = v
  end
  for k,v in pairs(b) do
    a[k] = v
  end
  for k,v in pairs(tmp) do
    b[k] = v
  end
end

local function get_good_child (self, parent)
  if 2*parent+1 > self.size then
    return 2*parent
  end
  
  if self.compare(self.pqueue[2*parent].priority, self.pqueue[2*parent+1].priority) then
    return 2*parent
  else
    return 2*parent+1
  end
end

local function new_element(id, priority)
  local element = {}
  element.id = id;
  element.priority = priority;
  
  return element
end

-- API
function pq:create (qtype)
  local ret = {}
  ret.size = 0;
  ret.pqueue = {}
  
  if qtype == "min" then
    ret.compare = for_min
  else
    ret.compare = for_max
  end
  
  setmetatable(ret, pq)
  
  return ret
end

function pq:print ()
  for i = 1, self.size do
    io.write(self.pqueue[i].id, " ")
  end
  print("")
end

function pq:push (id, priority)
  local el = new_element(id, priority)
  self.size = self.size + 1
  local i = self.size
  local parent = math.floor(self.size/2)
  self.pqueue[self.size] = el
  while (parent > 0 and self.compare(self.pqueue[i].priority, self.pqueue[parent].priority)) do
    swap_fields(self.pqueue[i],self.pqueue[parent])
    i = parent
    parent = math.floor(i/2)
  end
end

function pq:pop ()
  if self.size == 0 then
    return nil
  end
  
  local ret = utils.deep_copy(self.pqueue[1])
  swap_fields(self.pqueue[1],self.pqueue[self.size])
  self.pqueue[self.size] = nil
  self.size = self.size - 1
  local parent = 1
  if 2*parent > self.size then
    return ret
  end
  local i = get_good_child(self,parent)
  while self.compare(self.pqueue[i].priority, self.pqueue[parent].priority) do
    swap_fields(self.pqueue[i],self.pqueue[parent])
    parent = i
    if 2*parent > self.size then
      break
    end
    i = get_good_child(self,parent)
  end
  
  return ret
end

function pq:peek ()
  if self.size == 0 then
    return nil
  end
  return utils.deep_copy(self.pqueue[1])
end

return pq