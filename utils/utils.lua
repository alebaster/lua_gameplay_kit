local utils = {}

function utils.table_length (T)
  local count = 0
  for i, v in pairs(T) do 
    count = count + 1 
  end
  return count
end

function utils.print_table (T,level)
  local level = level or 0
  for i, v in pairs(T) do 
    if type(v) == "table" then
      print(string.rep(" ",level).."table "..i)
      utils.print_table(v,level+1)
    elseif type(v) == "function" then
      print(string.rep(" ",level).."function"..":"..i)
    else
      print(string.rep(" ",level)..i..":"..v)
    end
  end
end

function utils.deep_copy (from)
  if type(from) ~= "table" then
    return from
  end
  local copy = {}
  for k,v in pairs(from) do
    --copy[k] = v
    copy[utils.deep_copy(k)] = utils.deep_copy(v)
  end
  -- metatable?
  return copy
end

function utils.trim(s)
  return s:gsub("%s+%s+","")
end

result = nil
function utils.Eval(expr)
  expr = utils.trim(expr)
  result = nil
  if expr == "" then
    result = true
    return result
  end
  f = load("result = " .. expr)
  if not pcall(f) then
    print("cannot eval string: "..expr)
  end
  return result
end

function utils.Do(expr)
  f = load(expr)
  if not pcall(f) then
    print("cannot do string: "..expr)
  end
end

function utils.log_verbose (s,print_func)
  local file = debug.getinfo(3,'S').source
  local line = debug.getinfo(3,'l').currentline
  local name = debug.getinfo(3,'n').name
  print_func(s.." "..file.." "..line.." "..name)
end

return utils