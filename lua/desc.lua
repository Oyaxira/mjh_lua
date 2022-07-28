local combo = require("Combo")
local zhaoshi = require("Martial")
local aoyi = require("AoYi")
local item = require("Item")
local gift = require("Gift")
local skill = require("Skill")
require("common");

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
tableMerge(wenben, require("Language221"))
tableMerge(wenben, require("Language85"))
tableMerge(wenben, require("Language115"))
tableMerge(wenben, require("Language111"))
tableMerge(wenben, require("Language0"))
tableMerge(wenben, require("Language113"))
tableMerge(wenben, require("Language118"))

local csv_str = "秘奥义"
csv_str = csv_str .. "秘奥义名称,秘奥义需求1,秘奥义需求2,秘奥义需求3"
for key,value in pairs(aoyi) do
  name = wenben[zhaoshi[value.AoYiID].NameID]
  name2 = "\n" .. name
  for k,v in ipairs(value.MartialList) do
    tmp = "," .. wenben[zhaoshi[v].NameID]
    tmp = tmp .. "(" .. aoyi[key].LVList[k] .. ")"
    name2 = name2 .. tmp
  end
  csv_str = csv_str .. name2
end

file = io.open("../秘奥义.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)

csv_str = "组合技"
csv_str = csv_str .. "组合技招式1,组合技招式2,组合技招式3"
for key,value in pairs(combo) do
  name2 = "\n"
  for k,v in ipairs(value.MartialList) do
    tmp = wenben[zhaoshi[v].NameID] .. ","
    name2 = name2 .. tmp
  end
  csv_str = csv_str .. name2
end


file = io.open("../组合技.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)

csv_str = "道具id;道具名称;描述;稀有度"

for key,value in pairs(item) do
  name = value.ItemName
  id = value.BaseID
  rank = value.Rank
  desc = string.gsub(value.ItemDesc, "\n", "")
  name2 = "\n" .. id .. ";" .. name .. ";" .. desc .. ";" .. wenben[RankType_Lang[rank]]
  csv_str = csv_str .. name2
end

file = io.open("../道具列表.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)

csv_str = "技能id;技能名称;描述;稀有度"

for key,value in pairs(skill) do
  if value.NameID == 0 then
    break
  end
  name = wenben[value.NameID]
  id = value.BaseID
  rank = value.Rank
  rank_wenben = rank and wenben[RankType_Lang[rank]] or ""
  desc_wenben = wenben[value.DescID]
  desc = desc_wenben and string.gsub(wenben[value.DescID], "\n", "") or ""
  name2 = "\n" .. id .. ";" .. name .. ";" .. desc .. ";" .. rank_wenben
  csv_str = csv_str .. name2
end

file = io.open("../技能列表.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)

csv_str = "天赋id;天赋名称;描述;稀有度"

for key,value in pairs(gift) do
  if value.NameID == 0 then
    break
  end
  name = wenben[value.NameID]
  id = value.BaseID
  rank = value.Rank
  rank_wenben = rank and wenben[RankType_Lang[rank]] or ""
  desc_wenben = wenben[value.DescID]
  desc = desc_wenben and string.gsub(wenben[value.DescID], "\n", "") or ""
  name2 = "\n" .. id .. ";" .. name .. ";" .. desc .. ";" .. rank_wenben
  csv_str = csv_str .. name2
end

file = io.open("../天赋列表.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)