-- Auto generated by TableTool, Copyright ElectronicSoul@2017


local InnerDemonLevelDefault = {White=15,Green=20,Blue=20,Purple=25,Orange=25,Golden=25,DarkGolden=25,}
local InnerDemonLevel= {
  [0]={BaseID=0,},
  [1]={BaseID=1,},
  [2]={BaseID=2,},
  [3]={BaseID=3,},
  [4]={BaseID=4,},
  [5]={BaseID=5,},
  [6]={BaseID=6,},
  [7]={BaseID=7,},
  [8]={BaseID=8,},
  [9]={BaseID=9,},
  [10]={BaseID=10,},
}
for k,v in pairs(InnerDemonLevel) do
    setmetatable(v, {['__index'] = InnerDemonLevelDefault})
end

-- export table: InnerDemonLevel
return InnerDemonLevel
