package.path = package.path..";./utils/?.lua"..";./math/?.lua"
package.path = package.path..";../utils/?.lua"

local v_class = require "vector3d"
local v = v_class:create(1,2,3)
local v2 = v_class:create(3,2,1)
--v:print()

local r

--v:scalar_mult(2)
--v:print()

--v:minus(v)
--v:print()

--local r = v:vector_to(v2)
--r:print()

--local r = v:normal()
--r:print()

--print(v_class.distance(v,v2))
--print(v:distance_to(v2))

--print(v_class.angle(v,v2))

--r = v_class.cross(v,v2)
--r:print()

local m_class = require "matrix"
local m = m_class:create(2,2)
local m1 = m_class:create(2,2)
local i = m_class:create_ident(2)

m.m[1][1] = -3
m.m[1][2] = 0
m.m[2][1] = 5
m.m[2][2] = 0.5
--m:print()

m1.m[1][1] = -7
m1.m[1][2] = 2
m1.m[2][1] = 4
m1.m[2][2] = 6
--m1:print()

--m = m_class:create_ident(5)

--m = m:T()
--m = m:T()
--m:print()

--m = m:mult(i)
--m:print()
