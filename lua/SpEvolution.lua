-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum BehaviorType
require("common");


local SpEvolutionDefault = {CondID=0,Year=2,Month=2,BehaviorType=BehaviorType.BET_SPEVO_SIDAJIAZU,Param=0,}
local SpEvolution= {
  [1]={BaseID=1,Month=1,BehaviorType=BehaviorType.BET_SPEVO_WUCANYI,},
  [2]={BaseID=2,Year=1,Month=7,BehaviorType=BehaviorType.BET_SPEVO_YITIANJIAN,Param=1,},
  [3]={BaseID=3,Year=1,Month=8,BehaviorType=BehaviorType.BET_SPEVO_YITIANJIAN,Param=1,},
  [4]={BaseID=4,Year=1,Month=4,BehaviorType=BehaviorType.BET_SPEVO_TULONGDAO,Param=1,},
  [5]={BaseID=5,Year=1,Month=8,BehaviorType=BehaviorType.BET_SPEVO_TULONGDAO,Param=2,},
  [6]={BaseID=6,Month=1,BehaviorType=BehaviorType.BET_SPEVO_YIJINGJING,Param=1,},
  [7]={BaseID=7,BehaviorType=BehaviorType.BET_SPEVO_YIJINGJING,Param=2,},
  [8]={BaseID=8,Month=4,BehaviorType=BehaviorType.BET_SPEVO_YIJINGJING,Param=3,},
  [9]={BaseID=9,Month=6,BehaviorType=BehaviorType.BET_SPEVO_YIJINGJING,Param=4,},
  [10]={BaseID=10,Year=3,Month=1,BehaviorType=BehaviorType.BET_SPEVO_YIJINGJING,Param=5,},
  [11]={BaseID=11,BehaviorType=BehaviorType.BET_SPEVO_LIAOZHI,Param=1,},
  [12]={BaseID=12,Year=3,Month=4,BehaviorType=BehaviorType.BET_SPEVO_LIAOZHI,Param=2,},
  [13]={BaseID=13,Year=1,Month=10,BehaviorType=BehaviorType.BET_SPEVO_XIAOLANLI,Param=1,},
  [14]={BaseID=14,Month=5,BehaviorType=BehaviorType.BET_SPEVO_XIAOLANLI,Param=2,},
  [15]={BaseID=15,Year=1,},
  [16]={BaseID=16,},
  [17]={BaseID=17,Year=3,},
  [18]={BaseID=18,Year=4,},
  [19]={BaseID=19,Year=5,},
  [20]={BaseID=20,Year=6,},
  [21]={BaseID=21,Year=7,},
  [22]={BaseID=22,Year=8,},
}
for k,v in pairs(SpEvolution) do
    setmetatable(v, {['__index'] = SpEvolutionDefault})
end

-- export table: SpEvolution
return SpEvolution
