-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum PlayerBehaviorType
require("common");


local InteractUnLockDefault = {UnlockOnceCost=1000,UnlockForever=9800,}
local InteractUnLock= {
  [1]={BaseID=1,PlayerBehavior=PlayerBehaviorType.PBT_QiTao,UnlockOnceTag=267,},
  [2]={BaseID=2,PlayerBehavior=PlayerBehaviorType.PBT_JueDou,UnlockOnceTag=263,},
  [3]={BaseID=3,PlayerBehavior=PlayerBehaviorType.PBT_CallUp,UnlockOnceTag=120001,},
  [4]={BaseID=4,PlayerBehavior=PlayerBehaviorType.PBT_Punish,UnlockOnceTag=120002,},
  [5]={BaseID=5,PlayerBehavior=PlayerBehaviorType.PBT_INQUIRY,UnlockOnceTag=120013,},
  [6]={BaseID=6,PlayerBehavior=PlayerBehaviorType.PBT_Absorb,UnlockOnceTag=120015,},
}
for k,v in pairs(InteractUnLock) do
    setmetatable(v, {['__index'] = InteractUnLockDefault})
end

-- export table: InteractUnLock
return InteractUnLock