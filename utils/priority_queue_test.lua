local pq_class = require "priority_queue"

local pq1 = pq_class:create()
local pq2 = pq_class:create()

pq1:push(1,1)
pq1:push(2,2)
pq1:push(3,3)

--pq2:push(1,1)
--pq2:push(2,2)

print(pq1:print())
pq1:pop()
print(pq1:print())
--print(pq2.size)