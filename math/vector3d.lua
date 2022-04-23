local vector3d = {}
vector3d.__index = vector3d

-- left-hand

-- API
function vector3d.distance (v1,v2)
  return math.sqrt((v2.x - v1.x)^2+(v2.y - v1.y)^2+(v2.z - v1.z)^2)
end

function vector3d.dot (v1,v2)
  return v1.x*v2.x + v1.y*v2.y + v1.z*v2.z
end

function vector3d.cross (v1,v2)
  local ret = vector3d:create()
  ret.x = v1.y*v2.z - v1.z*v2.y
  ret.y = v1.z*v2.x - v1.x*v2.z
  ret.z = v1.x*v2.y - v1.y*v2.x
  return ret
end

function vector3d.angle (v1,v2)
  if v1:isZero() and v2:isZero() then
    return 0
  end
  return math.deg(math.acos(vector3d.dot(v1,v2)/(v1:length()*v2:length())))
end

--
function vector3d:create (x, y, z)
  local ret = {}
  
  ret.x = x or 0
  ret.y = y or 0
  ret.z = z or 0
  
  setmetatable(ret,vector3d)
  
  return ret
end

function vector3d:copy (v)
  local ret = {}
  
  ret.x = v.x or 0
  ret.y = v.y or 0
  ret.z = v.z or 0
  
  setmetatable(ret,vector3d)
  
  return ret
end

function vector3d:vector_to (v)
  local ret = vector3d:copy(v)
  ret:minus(self)
  return ret
end

function vector3d:distance_to (v)
  return vector3d.distance(self,v)
end

function vector3d:dot_to (v)
  return vector3d.dot(self,v)
end

function vector3d:angle_to (v)
  return vector3d.angle(self,v)
end

function vector3d:cross_to (v)
  return vector3d.cross(self,v)
end

function vector3d:length ()
  return math.sqrt((self.x)^2+(self.y)^2+(self.z)^2)
end

function vector3d:normal ()
  if self:isZero() then
    return 0
  end
  
  local ret = vector3d:copy(self)
  ret:scalar_divide(ret:length())
  return ret
end

function vector3d:scalar_mult (scalar)
  self.x = scalar*self.x
  self.y = scalar*self.y
  self.z = scalar*self.z
  return self
end

function vector3d:scalar_divide (scalar)
  self:scalar_mult(1/scalar)
  return self
end

function vector3d:plus (v)
  self.x = self.x + v.x
  self.y = self.y + v.y
  self.z = self.z + v.z
  return self
end

function vector3d:minus (v)
  self.x = self.x - v.x
  self.y = self.y - v.y
  self.z = self.z - v.z
  return self
end

function vector3d:neglect (v)
  self.x = -self.x
  self.y = -self.y
  self.z = -self.z
  return self
end

function vector3d:isZero ()
  return self.x==0 and self.y==0 and self.z==0
end

function vector3d:x ()
  return self.x
end

function vector3d:y ()
  return self.y
end

function vector3d:z ()
  return self.z
end

function vector3d:print (p_func)
  local p = p_func or print
  p("x="..self.x.." y="..self.y.." z="..self.z)
end

return vector3d