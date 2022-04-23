local function log (s)
  print(s)
end

package.path = package.path..";./utils/?.lua"..";./inventory/?.lua"
package.path = package.path..";../utils/?.lua"

local utils = require "utils"

local inventory_class = require "inventory"

local inventory = inventory_class:create()
inventory:set_log_func(log)
inventory:add_db("inventory/item_db.json")
--inventory.add_item("lockpick")
inventory:add_item("wallet")
inventory:add_item("wallet")
--inventory.add_item("anaconda")

local tt = {}
tt.id = "hell"
tt.something = 1
--inventory.add_item(tt)
--print(inventory.get_item("hell").count)
--local r = inventory.get_items_by_field("type",4)
--utils.print_table(r)

inventory:print()
--inventory.remove_item("wallet")

--inventory.print()
--print(inventory.get_item_field("lockpick1","description"))


