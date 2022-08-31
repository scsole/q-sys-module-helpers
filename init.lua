Functions = {}

-- Print contents of `tbl`, with indentation.
-- `indent` sets the initial level of indentation.
function Functions.TablePrint (tbl, indent)
    if not indent then indent = 0 end
    for k, v in pairs(tbl) do
      formatting = string.rep("  ", indent) .. k .. ": "
      if type(v) == "table" then
        print(formatting)
        Functions.TablePrint(v, indent+1)
      elseif type(v) == 'boolean' then
        print(formatting .. tostring(v))      
      else
        print(formatting .. v)
      end
    end
  end

function Functions.MakeExclusive(ArrayOfCtrls)
    for i , v in pairs(ArrayOfCtrls) do
      local oldEH = v.EventHandler or function() end
      v.EventHandler = function()
        for x,y in pairs(ArrayOfCtrls) do
          y.Boolean = x == i
        end
        oldEH()
      end
    end
end

function Functions.GetIndex(t,value)
    for i , v in pairs(t) do
        if v == value then return i end
    end
end

return Functions