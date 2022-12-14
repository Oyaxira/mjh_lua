-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum SystemType
require("common");


local SystemOpenDefault = {SystemType=SystemType.SYST_RoleCard,Param1=1,Param2=30,OpenTime=1,}
local SystemOpen= {
  [1]={BaseID=1,SystemType=SystemType.SYST_ARENA,Param1=-1,Param2=0,},
  [2]={BaseID=2,SystemType=SystemType.SYST_ARENA,Param2=0,},
  [3]={BaseID=3,SystemType=SystemType.SYST_ARENA,Param1=2,Param2=0,},
  [4]={BaseID=4,SystemType=SystemType.SYST_ARENA,Param1=3,Param2=0,OpenTime=8,},
  [5]={BaseID=5,SystemType=SystemType.SYST_ARENA,Param1=4,Param2=0,OpenTime=15,},
  [6]={BaseID=6,SystemType=SystemType.SYST_ARENA,Param1=5,Param2=0,OpenTime=15,},
  [7]={BaseID=7,SystemType=SystemType.SYST_IncompleteText,Param1=-1,Param2=0,},
  [8]={BaseID=8,SystemType=SystemType.SYST_IncompleteText,},
  [9]={BaseID=9,SystemType=SystemType.SYST_IncompleteText,Param1=2,},
  [10]={BaseID=10,SystemType=SystemType.SYST_IncompleteText,Param1=3,},
  [11]={BaseID=11,SystemType=SystemType.SYST_IncompleteText,Param1=4,},
  [12]={BaseID=12,SystemType=SystemType.SYST_IncompleteText,Param1=5,},
  [13]={BaseID=13,SystemType=SystemType.SYST_IncompleteText,Param1=6,},
  [14]={BaseID=14,SystemType=SystemType.SYST_IncompleteText,Param1=7,},
  [15]={BaseID=15,SystemType=SystemType.SYST_IncompleteText,OpenTime=16,},
  [16]={BaseID=16,SystemType=SystemType.SYST_IncompleteText,Param1=2,OpenTime=16,},
  [17]={BaseID=17,SystemType=SystemType.SYST_IncompleteText,Param1=3,OpenTime=16,},
  [18]={BaseID=18,SystemType=SystemType.SYST_IncompleteText,Param1=4,OpenTime=16,},
  [19]={BaseID=19,SystemType=SystemType.SYST_IncompleteText,Param1=5,OpenTime=16,},
  [20]={BaseID=20,SystemType=SystemType.SYST_IncompleteText,Param1=6,OpenTime=16,},
  [21]={BaseID=21,SystemType=SystemType.SYST_IncompleteText,Param1=7,OpenTime=16,},
  [22]={BaseID=22,SystemType=SystemType.SYST_IncompleteText,OpenTime=31,},
  [23]={BaseID=23,SystemType=SystemType.SYST_IncompleteText,Param1=2,OpenTime=31,},
  [24]={BaseID=24,SystemType=SystemType.SYST_IncompleteText,Param1=3,OpenTime=31,},
  [25]={BaseID=25,SystemType=SystemType.SYST_IncompleteText,Param1=4,OpenTime=31,},
  [26]={BaseID=26,SystemType=SystemType.SYST_IncompleteText,Param1=5,OpenTime=31,},
  [27]={BaseID=27,SystemType=SystemType.SYST_IncompleteText,Param1=6,OpenTime=31,},
  [28]={BaseID=28,SystemType=SystemType.SYST_IncompleteText,Param1=7,OpenTime=31,},
  [29]={BaseID=29,Param2=5,},
  [30]={BaseID=30,Param1=2,Param2=5,},
  [31]={BaseID=31,Param1=3,Param2=5,},
  [32]={BaseID=32,Param1=4,Param2=5,},
  [33]={BaseID=33,Param1=5,Param2=5,},
  [34]={BaseID=34,Param1=6,Param2=5,},
  [35]={BaseID=35,Param1=7,Param2=5,},
  [36]={BaseID=36,Param1=8,Param2=5,},
  [37]={BaseID=37,Param1=9,Param2=5,},
  [38]={BaseID=38,Param2=8,OpenTime=16,},
  [39]={BaseID=39,Param1=2,Param2=8,OpenTime=16,},
  [40]={BaseID=40,Param1=3,Param2=8,OpenTime=16,},
  [41]={BaseID=41,Param1=4,Param2=8,OpenTime=16,},
  [42]={BaseID=42,Param1=5,Param2=8,OpenTime=16,},
  [43]={BaseID=43,Param1=6,Param2=8,OpenTime=16,},
  [44]={BaseID=44,Param1=7,Param2=8,OpenTime=16,},
  [45]={BaseID=45,Param1=8,Param2=8,OpenTime=16,},
  [46]={BaseID=46,Param1=9,Param2=8,OpenTime=16,},
  [47]={BaseID=47,Param2=10,OpenTime=31,},
  [48]={BaseID=48,Param1=2,Param2=10,OpenTime=31,},
  [49]={BaseID=49,Param1=3,Param2=10,OpenTime=31,},
  [50]={BaseID=50,Param1=4,Param2=10,OpenTime=31,},
  [51]={BaseID=51,Param1=5,Param2=10,OpenTime=31,},
  [52]={BaseID=52,Param1=6,Param2=10,OpenTime=31,},
  [53]={BaseID=53,Param1=7,Param2=10,OpenTime=31,},
  [54]={BaseID=54,Param1=8,Param2=10,OpenTime=31,},
  [55]={BaseID=55,Param1=9,Param2=10,OpenTime=31,},
  [56]={BaseID=56,SystemType=SystemType.SYST_PetCard,Param2=5,},
  [57]={BaseID=57,SystemType=SystemType.SYST_PetCard,Param1=2,Param2=5,},
  [58]={BaseID=58,SystemType=SystemType.SYST_PetCard,Param1=3,Param2=5,},
  [59]={BaseID=59,SystemType=SystemType.SYST_PetCard,Param1=4,Param2=5,},
  [60]={BaseID=60,SystemType=SystemType.SYST_PetCard,Param1=5,Param2=5,},
  [61]={BaseID=61,SystemType=SystemType.SYST_PetCard,Param1=6,Param2=5,},
  [62]={BaseID=62,SystemType=SystemType.SYST_PetCard,Param1=7,Param2=5,},
  [63]={BaseID=63,SystemType=SystemType.SYST_PetCard,Param1=8,Param2=5,},
  [64]={BaseID=64,SystemType=SystemType.SYST_PetCard,Param1=9,Param2=5,},
  [65]={BaseID=65,SystemType=SystemType.SYST_PetCard,Param2=8,OpenTime=16,},
  [66]={BaseID=66,SystemType=SystemType.SYST_PetCard,Param1=2,Param2=8,OpenTime=16,},
  [67]={BaseID=67,SystemType=SystemType.SYST_PetCard,Param1=3,Param2=8,OpenTime=16,},
  [68]={BaseID=68,SystemType=SystemType.SYST_PetCard,Param1=4,Param2=8,OpenTime=16,},
  [69]={BaseID=69,SystemType=SystemType.SYST_PetCard,Param1=5,Param2=8,OpenTime=16,},
  [70]={BaseID=70,SystemType=SystemType.SYST_PetCard,Param1=6,Param2=8,OpenTime=16,},
  [71]={BaseID=71,SystemType=SystemType.SYST_PetCard,Param1=7,Param2=8,OpenTime=16,},
  [72]={BaseID=72,SystemType=SystemType.SYST_PetCard,Param1=8,Param2=8,OpenTime=16,},
  [73]={BaseID=73,SystemType=SystemType.SYST_PetCard,Param1=9,Param2=8,OpenTime=16,},
  [74]={BaseID=74,SystemType=SystemType.SYST_PetCard,Param2=10,OpenTime=31,},
  [75]={BaseID=75,SystemType=SystemType.SYST_PetCard,Param1=2,Param2=10,OpenTime=31,},
  [76]={BaseID=76,SystemType=SystemType.SYST_PetCard,Param1=3,Param2=10,OpenTime=31,},
  [77]={BaseID=77,SystemType=SystemType.SYST_PetCard,Param1=4,Param2=10,OpenTime=31,},
  [78]={BaseID=78,SystemType=SystemType.SYST_PetCard,Param1=5,Param2=10,OpenTime=31,},
  [79]={BaseID=79,SystemType=SystemType.SYST_PetCard,Param1=6,Param2=10,OpenTime=31,},
  [80]={BaseID=80,SystemType=SystemType.SYST_PetCard,Param1=7,Param2=10,OpenTime=31,},
  [81]={BaseID=81,SystemType=SystemType.SYST_PetCard,Param1=8,Param2=10,OpenTime=31,},
  [82]={BaseID=82,SystemType=SystemType.SYST_PetCard,Param1=9,Param2=10,OpenTime=31,},
  [83]={BaseID=83,SystemType=SystemType.SYST_EquipEnhance,Param1=10,Param2=0,},
  [84]={BaseID=84,SystemType=SystemType.SYST_EquipEnhance,Param1=15,Param2=0,OpenTime=16,},
  [85]={BaseID=85,SystemType=SystemType.SYST_EquipEnhance,Param1=20,Param2=0,OpenTime=31,},
}
for k,v in pairs(SystemOpen) do
    setmetatable(v, {['__index'] = SystemOpenDefault})
end

-- export table: SystemOpen
return SystemOpen
