local combo = require("Combo")
local zhaoshi = require("Martial")
local aoyi = require("AoYi")

local wenben = require("Language161")

function tableMerge(t1, t2)
    for k,v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                tableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end


tableMerge(wenben, require("Language121"))


print("秘奥义")
for key,value in pairs(aoyi) do
  name = wenben[zhaoshi[value.AoYiID].NameID]
  name2 = ""
  for k,v in ipairs(value.MartialList) do
    tmp = wenben[zhaoshi[v].NameID] .. " "
    name2 = name2 .. tmp
  end
  for k,v in ipairs(value.LVList) do
    tmp = " 等级:" .. v
    name2 = name2 .. tmp
  end

  print(name,"组成", name2)
end

print("组合技")
for key,value in pairs(combo) do
  name2 = ""
  for k,v in ipairs(value.MartialList) do
    tmp = wenben[zhaoshi[v].NameID] .. " "
    name2 = name2 .. tmp
  end
  print("combo: ", name2)
end
