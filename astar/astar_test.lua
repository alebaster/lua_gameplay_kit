--[[
  0 0 0 0 0 0 0
  0 0 0 w 0 0 0
  0 s 0 w 0 e 0
  0 0 0 w 0 0 0
  0 0 0 0 0 0 0
]]

package.path = package.path..";./astar/?.lua"

local astar_class = require "astar"

local astar = astar_class:create(5,7)
--local nodes = astar:get_nodes()
astar.nodes[2][4].blocked = true
astar.nodes[3][4].blocked = true
astar.nodes[4][4].blocked = true

--astar.nodes[4][3].blocked = true
--astar.nodes[2][3].blocked = true

--node[3][2] node[3][6]

--print(astar.nodes[3][6].pos.x.." "..astar.nodes[3][6].pos.y)

local path = astar:path(astar.nodes[3][2], astar.nodes[3][6])
for i = 1, #path do
    io.write(path[i] .. " ")
end

--local pq = require "priority_queue"
--ppq = pq.new("min")
--ppq.push(10,10)
--ppq.push(9,9)
--ppq.push(11,11)
--ppq.push(3,3)
--ppq.push(2,2)
--ppq.push(8,8)
--ppq.push(6,6)
--ppq.print()
--ppq.pop()
--ppq.print()
--ppq.pop()
--ppq.print()
--ppq.pop()
--ppq.print()
--ppq.pop()
--ppq.print()
--ppq.pop()
--ppq.print()

--local vector = require "vector2d"
--v = vector.new()
--print(v.x.." " ..v.y)