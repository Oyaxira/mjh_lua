local combo = require("Combo")
local zhaoshi = require("Martial")
local aoyi = require("AoYi")
local item = require("Item")
local gift = require("Gift")
local skill = require("Skill")
local zhaoshiitem = require("MartialItem")
require("common");

local wenben = require("Language161")
local roles = require("Role")

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
tableMerge(wenben, require("Language171"))
tableMerge(roles, require("Role1"))
tableMerge(roles, require("Role2"))
tableMerge(roles, require("Role3"))

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
csv_str = csv_str .. ",组合技招式1,组合技招式2,组合技招式3"
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

csv_str = "技能id;技能名称;描述;稀有度;等级效果"

for key,value in pairs(zhaoshi) do
  if value.NameID == 0 then
    break
  end
  id = value.BaseID
  rank = value.Rank
  rank_wenben = rank and wenben[RankType_Lang[rank]] or ""
  name = wenben[value.NameID]
  desc_wenben = wenben[value.DesID]
  desc = desc_wenben and string.gsub(wenben[value.DesID], "\n", "") or ""
  name2 = "\n" .. id .. ";" .. name .. ";" .. desc .. ";" .. rank_wenben
  level_skill = "\n;技能效果;"
  UnlockLvls = value.UnlockLvls
  numb = 1
  if UnlockLvls then
    for k,v in ipairs(UnlockLvls) do
      zhaoshiitem_id = value.UnlockClauses[k]
      if zhaoshiitem_id == 0 then
      else
        skill_id = zhaoshiitem[zhaoshiitem_id].SkillID1
        if skill_id == 0 then
        else
          skill_wenben_id = skill[skill_id].DescID
          if skill_wenben_id == 0 then
            skill_wenben_id = skill[skill_id].NameID
          end
          wenben_text = wenben[skill_wenben_id] and string.gsub(wenben[skill_wenben_id], "\n", "") or ""
          wenben_text = string.gsub(wenben_text, ";", "、")
          tmp = v .. "级: " .. wenben_text .. "\n"
          if numb == 1 then
            level_skill = level_skill .. tmp
          else
            level_skill = level_skill .. ";;" .. tmp
          end
          numb = numb + 1
        end
      end
    end
  end
  csv_str = csv_str .. name2 .. level_skill
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






csv_str = "技能名称;特效名;特效描述;需求等级;"

for key,value in pairs(zhaoshi) do
  if value.NameID == 0 then
    break
  end
  id = value.BaseID
  rank = value.Rank
  name = wenben[value.NameID]
  result = ""
  UnlockLvls = value.UnlockLvls
  if UnlockLvls then
    for k,v in ipairs(UnlockLvls) do
      zhaoshiitem_id = value.UnlockClauses[k]
      if zhaoshiitem_id == 0 then
      else
        skill_id = zhaoshiitem[zhaoshiitem_id].SkillID1
        if skill_id == 0 then
        else
          skill_wenben_id = skill[skill_id].DescID
          if skill_wenben_id == 0 then
            skill_wenben_id = skill[skill_id].NameID
          end
          skill_name_id = skill[skill_id].NameID
          wenben_text = wenben[skill_wenben_id] and string.gsub(wenben[skill_wenben_id], "\n", "") or ""
          wenben_text = string.gsub(wenben_text, ";", "、")
          name_text = wenben[skill_name_id] and string.gsub(wenben[skill_name_id], "\n", "") or ""
          tmp = "\r\n" .. name .. ";" .. name_text .. ";" .. wenben_text .. ";" .. v .. "级;"
          result = result .. tmp
        end
      end
    end
  end
  csv_str = csv_str .. result
end

file = io.open("../技能筛选.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)




csv_str = "人物名;专属技能名称;专属技能稀有度;特效描述\r\n"

for key,value in pairs(zhaoshi) do
  if value.NameID == 0 then
    break
  end
  id = value.BaseID
  rank = value.Rank
  rank_wenben = rank and wenben[RankType_Lang[rank]] or ""
  name = wenben[value.NameID]
  desc_wenben = wenben[value.DesID]
  desc = desc_wenben and string.gsub(wenben[value.DesID], "\n", "") or ""
  result = ""
  if value.Exclusive then
    renname = ""
    for k,v in pairs(roles) do
      if v.RoleID == value.Exclusive[1] then
        renname = wenben[v.NameID]
      end
    end
    result = result .. renname .. ";" .. name .. ";" .. rank_wenben .. ";" .. desc .. "\r\n"
  end
  csv_str = csv_str .. result
end

file = io.open("../专属技能.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)
mytable = {}
csv_str = "人物id;人物名;Rank\r\n"
for key,value in pairs(roles) do
  if value.RoleID == 0 then
    break
  end
  if value.NameID == 0 then
    break
  end
  id = value.RoleID
  rank = value.Rank
  rank_wenben = rank and wenben[RankType_Lang[rank]] or ""
  name = wenben[value.NameID]
  mytable[value.RoleID] = {Rank= rank_wenben,Name=name,ID=id}
end
table.sort(mytable,function(a,b) return a.ID<b.ID end )
for key,value in pairs(mytable) do
  id = key
  result = ""
  result = result .. id .. ";" .. value.Name .. ";" .. value.Rank .. "\r\n"
  csv_str = csv_str .. result
end
file = io.open("../人物ID.csv", "w")
io.output(file)
io.write(csv_str)
io.close(file)
