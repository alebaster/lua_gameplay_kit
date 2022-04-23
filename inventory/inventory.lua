local inventory = {}
inventory.__index = inventory

package.path = package.path..";./utils/?.lua"..";./3rd/?.lua"
package.path = package.path..";../utils/?.lua"..";../3rd/?.lua"

local utils = require "utils"
local json = require "json"

local log_func = print

local function log_verbose (s)
  utils.log_verbose(s,log_func)
end

local function fill_db (self,j)
  for i, v in pairs(j) do 
    if type(v) == "table" then
      if v["id"] ~= nil then
        local item = {}
        for ii, vv in pairs(v) do 
          item[ii] = vv
        end
        self.db[v["id"]] = item
      end
      fill_db(self,v)
    end
  end  
end

-- API
-- set outer log function for embedding
function inventory:set_log_func (f)
  log_func = f
end

function inventory:print ()
  utils.print_table(self.current)
end

function inventory:create ()
  local ret = {}
  ret.db = {}
  ret.current = {}
  
  setmetatable(ret,inventory)
  
  return ret
end

-- append list of items from json to db
function inventory:add_db (file)
  local iofile = assert(io.open(file,"r"))
  local iocontent = iofile:read "*all"
  iofile:close()
  local json_parsed = json.decode(iocontent)
  fill_db(self,json_parsed)
end

-- add item to character inventory
function inventory:add_item (id_or_item)
  if type(id_or_item) == "table" then -- item from user
    if id_or_item["id"] ~= nil then
      if self.current[id_or_item.id] ~= nil then
        self.current[id_or_item.id].count = self.current[id_or_item.id].count + 1
        return
      end
      self.current[id_or_item.id] = utils.deep_copy(id_or_item)
      self.current[id_or_item.id].count = 1
    else
      log_verbose("item field \"id\" is nil")
    end
  else  -- item from db
    if (self.db[id_or_item] ~= nil) then
      if self.current[id_or_item] ~= nil then
        self.current[id_or_item].count = self.current[id_or_item].count + 1
        return
      end
      self.current[id_or_item] = utils.deep_copy(self.db[id_or_item])
      self.current[id_or_item].count = 1
    else
      log_verbose("no such id: \""..id_or_item.. "\" in db")
    end
  end
end


function inventory:has_item (id)
  return self.current[id] ~= nil
end

function inventory:get_item (id)
  return self.current[id]
end

function inventory:remove_item (id)
  if self.current[id] ~= nil then
    self.current[id].count = self.current[id].count - 1
  end
  if self.current[id].count < 1 then
    self.current[id] = nil
  end
end

function inventory:get_item_field (id,field)
  if self.current[id] == nil then 
    log_verbose("no such id: \""..id.. "\" in db")
    return nil
  end
  return self.current[id][field]
end

function inventory:get_items_by_field (field,value)
  local ret = {}
  local i = 1
  for k, v in pairs(self.current) do 
    for kk, vv in pairs(v) do 
      if kk == field and vv == value then
        ret[i] = k
        i = i + 1
      end
    end
  end
  return ret
end

return inventory