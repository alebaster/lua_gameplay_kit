local vector2d = {}
vector2d.__index = vector2d

function vector2d:create (x, y)
  local ret = {}
  
  ret.x = x or 0
  ret.y = y or 0
  
  setmetatable(ret,vector2d)
  
  return ret
end

return vector2d