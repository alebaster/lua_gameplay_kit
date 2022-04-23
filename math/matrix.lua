local matrix = {}
matrix.__index = matrix

-- API

function matrix.mult (m1,m2)
  if m1.cols ~= m2.rows then
    return nil
  end
  ret = matrix:create(m1.rows, m2.cols)
  for r=1,ret.rows do
    for c=1,ret.cols do
      --for rr=1,m1.cols do
      --  for cc=1,m2.rows do
      --    m1.m[rr][cc]*
      --  end
      --end
      for k=1,m1.cols do
      ret.m[r][c] = ret.m[r][c] + m1.m[r][k]*m2.m[k][c]
      end
      --ret.m[r][c] = m1.m[r][c]
    end
  end
  return ret
end

--
function matrix:create (rows, cols)
  local ret = {}
  
  ret.rows = rows
  ret.cols = cols
  ret.m = {}
  for r=1,rows do
    ret.m[r] = {}
    for c=1,cols do
      ret.m[r][c] = 0
    end
  end
  
  setmetatable(ret,matrix)
  
  return ret
end

function matrix:create_ident (size)
  local ret = {}
  
  ret.rows = size
  ret.cols = size
  ret.m = {}
  for r=1,size do
    ret.m[r] = {}
    for c=1,size do
      if r == c then
        ret.m[r][c] = 1
      else
        ret.m[r][c] = 0
      end
    end
  end
  
  setmetatable(ret,matrix)
  
  return ret
end

function matrix:T ()
  local ret = matrix:create(self.cols,self.rows)
  for r=1,ret.rows do
    for c=1,ret.cols do
      ret.m[r][c] = self.m[c][r]
    end
  end
  return ret
end

function matrix:mult_to (m)
  return matrix.mult(self,m)
end

function matrix:scalar_mult (scalar)
  for r=1,self.rows do
    for c=1,self.cols do
      self.m[r][c] = scalar*self.m[r][c]
    end
  end
  return self
end

function matrix:get ()
  return self.m
end

function matrix:print (p_func)
  for r=1,self.rows do
    for c=1,self.cols do
      io.write(self.m[r][c].." ")
    end
    io.write("\n")
  end
end

return matrix