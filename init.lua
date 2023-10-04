local Functions = {}

---@param tbl table A table to print.
---@param indent integer? Optional initial level of indentation.
function Functions.TablePrint(tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    local formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      Functions.TablePrint(v, indent + 1)
    elseif type(v) == 'boolean' then
      print(formatting .. tostring(v))
    else
      print(formatting .. v)
    end
  end
end

--- Make a table of controls exclusive, so when one turns on, the others turn off. This does not overwrite existing
--- event handlers, but adds to them.
--- @param ctrls table A table of controls to make exclusive.
function Functions.MakeExclusive(ctrls)
  for k, v in pairs(ctrls) do
    local oldEH = v.EventHandler or function()
    end
    v.EventHandler = function()
      for x, y in pairs(ctrls) do
        y.Boolean = x == k
      end
      oldEH()
    end
  end
end

--- Exclusively turn on a control contained in a table.
--- @param ctrl table The control to turn on in the table.
--- @param ctrls table The table containing controls which should be exclusively set.
function Functions.ExclusiveSet(ctrl, ctrls)
  for _, v in pairs(ctrls) do
    v.Boolean = ctrl == v
  end
end

--- Pulse a control.
---@param ctrl table The control to pulse.
---@param period number Optional period (s) which the control should remain high for. Defaults to 0.01s.
function Functions.Pulse(ctrl, period)
  period = period or 0.01
  Timer.CallAfter(function()
    ctrl.Boolean = false
  end, period)
end

---Return the index of a given value if found in table tbl.
---@param tbl table The table to search for the control.
---@param value any The value to search for.
---@return any # The index of the value if found.
function Functions.GetIndex(tbl, value)
  for i, v in pairs(tbl) do
    if v == value then return i end
  end
end

function Functions.Write(socket, data, EOL)
  print('TX:', data)
  EOL = EOL or ""
  socket:Write(data .. EOL)
end

-----------functions for finding available NICs on a Core and returning their IP address---------------------------

-- Function to look through the Cores network interfaces - if a Core has a valid IP address then it will return that NIC
-- as an option to be used in a dropdown list
function Functions.GetNicOptions()
  local availablePort = {}
  for subtbl, item in pairs(Network.Interfaces()) do
    if subtbl then                                --checks valid IP of Cores NICs
      table.insert(availablePort, item.Interface) --inserts the interface into the table for using in a dropdown box
    end
  end
  return availablePort
end

-- Returns the IP address of a selected Core interface. Example, if you select "LAN B" in your interface dropdown box -
-- it will return you the IP of that NIC
function Functions.GetIP(s)
  for _, value in pairs(Network.Interfaces()) do
    if value.Interface == s then
      return value.Address
    end
  end
end

-- Provide a string and delimiter and the function will return a table with the split parts of the string.
function Functions.SplitString(str, delimiter)
  local t = {}
  for word in string.gmatch(str, "[^" .. delimiter .. "]+") do
    table.insert(t, word)
  end
  return t
end

--------------------------functions to write a CSV file---------------------
function Functions.AddCsvRow(filePath, data)
  -- Open the CSV file in append mode
  local file = assert(io.open('media/' .. filePath, "a"))

  -- Convert the data table to a string and append it to the file
  file:write(table.concat(data, ",") .. "\n")

  -- Close the file
  file:close()
end

--eg AddCsvRow('Audio/test.csv', {7,8,9,0})

return Functions
