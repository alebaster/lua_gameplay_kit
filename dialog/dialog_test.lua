local function log (s)
  print(s)
end

package.path = package.path..";./utils/?.lua"..";./dialog/?.lua"..";./dialog/?.json"
package.path = package.path..";../utils/?.lua"

local utils = require "utils"

local dialog_class = require "dialog"

G = {}
G.Mercurio_Friend = 1
G.Story_State = 5

local answer_id = nil

local function print_ans (dialog, node)
  if node == nil then
    return
  end
  print(node.text)
  for i, v in pairs(node.answers) do 
    local ans = dialog:get_answer(v)
    if utils.Eval(ans.condition) then
      print(ans.text)
      answer_id = ans.id
    end
  end
end

local dialog = dialog_class:create()
dialog:set_log_func(log)
dialog:load("./dialog/mercurio.json")
local node = dialog:start()
print_ans(dialog,node)
node = dialog:give_answer(answer_id)
print_ans(dialog,node)
dialog:fin()
