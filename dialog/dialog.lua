local dialog = {}
dialog.__index = dialog

package.path = package.path..";./utils/?.lua"..";./3rd/?.lua"
package.path = package.path..";../utils/?.lua"..";../3rd/?.lua"

local utils = require "utils"
local json = require "json"

local log_func = print

local function log_verbose (s)
  utils.log_verbose(s,log_func)
end

local function fill_dialog (self,j)
  for i, v in pairs(j) do 
    if i == "starts" then
      for ii, vv in pairs(v) do 
        if type(vv) == "table" and vv["id"] ~= nil then
          local item = {}
          item["id"] = vv["id"]
          item["condition"] = vv["condition"]
          self.starts[vv["id"]] = item
        end
      end
    elseif i == "nodes" then
        for ii, vv in pairs(v) do 
          if type(vv) == "table" and vv["id"] ~= nil then
            local item = {}
            item["id"] = vv["id"]
            item["text"] = vv["text"]
            item["answers"] = {}
            for iii, vvv in pairs(vv["answers"]) do 
              item["answers"][iii] = vvv
            end
            item["effect"] = vv["effect"]
            self.nodes[vv["id"]] = item
          end
        end
    elseif i == "answers" then
        for ii, vv in pairs(v) do 
          if type(vv) == "table" and vv["id"] ~= nil then
            local item = {}
            item["id"] = vv["id"]
            item["text"] = vv["text"]
            item["react"] = vv["react"]
            item["effect"] = vv["effect"]
            item["condition"] = vv["condition"]
            self.answers[vv["id"]] = item
          end
        end
    end
    --if type(v) == "table" then
    --  if v["id"] ~= nil then
    --    local item = {}
    --    for ii, vv in pairs(v) do 
    --      item[ii] = vv
    --    end
    --    self.db[v["id"]] = item
    --  end
    --  fill_dialog(self,v)
    --end
  end  
end

-- API
-- set outer log function for embedding
function dialog:set_log_func (f)
  log_func = f
end

function dialog:create ()
  local ret = {}
  ret.id = nil
  ret.current_node = nil
  ret.starts = {}
  -- id
  -- condition
  ret.nodes = {}
  -- id
  -- text
  -- answers
  -- effect
  ret.answers = {}
  -- id
  -- text
  -- react
  -- condition
  -- effect

  setmetatable(ret,dialog)
  
  return ret
end

function dialog:load (file)
  local iofile = assert(io.open(file,"r"))
  local iocontent = iofile:read "*all"
  iofile:close()
  local json_parsed = json.decode(iocontent)
  fill_dialog(self,json_parsed)
  self.id = file
  --print(self.answers[112].text)
end

function dialog:start ()
  local start_id = nil
  for i, v in pairs(self.starts) do 
    if utils.Eval(v.condition) then
      start_id = i
      break
    end
  end
  if start_id == nil then
    log_verbose("cannot find start id for dialog: "..self.id)
    return nil
  end
  self.current_node = self:get_node(start_id)
  return self.current_node
end

function dialog:get_node (id)
  local node = self.nodes[id]
  if node == nil then
    log_verbose("cannot find node with id: "..id.." for dialog: "..self.id)
  end
  return node
end

function dialog:get_answer (id)
  if self.current_node == nil then
    log_verbose("curent node is null")
    return nil
  end
  if self.answers[id] == nil then
    log_verbose("cannot find answer with id: "..id)
    return nil
  end
  return self.answers[id]
end

function dialog:give_answer (id)
  local ans = self:get_answer(id)
  utils.Do(ans.effect)
  if ans.react == 0 then
    self:fin()
    return
  end
  self.current_node = self:get_node(ans.react)
  return self.current_node
end

function dialog:fin (id)
  self.current_node = 0
end

return dialog