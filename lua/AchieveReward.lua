-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum RankType
-- enum AchieveRewardNavType
-- enum AchieveRewardType
-- enum TBoolean
require("common");


local AchieveRewardDefault = {AchievePointCost=50,Rank=RankType.RT_Green,RewardNavType=AchieveRewardNavType.ARNT_ProwerLimit,RewardType=AchieveRewardType.ARD_SetTag,RewardValueA="",RewardValueB=1,RewardValueC=0,Unlock=TBoolean.BOOL_YES,AutoEffective=TBoolean.BOOL_YES,Condition=0,ConditionDescID=0,NeedVIP=TBoolean.BOOL_NO,}
local AchieveReward= {
  [1]={BaseID=1,NameID=2610001,AchievePointCost=10,DescID=2620001,Rank=RankType.RT_White,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_RoleExp,RewardValueB=0,RewardValueC=5000,Sequence=1,},
  [2]={BaseID=2,NameID=2610002,AchievePointCost=25,DescID=2620002,Rank=RankType.RT_White,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_RoleExp,RewardValueB=0,RewardValueC=5000,Condition=1,Sequence=2,},
  [3]={BaseID=3,NameID=2610003,DescID=2620003,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_RoleExp,RewardValueB=0,RewardValueC=5000,Condition=2,Sequence=3,},
  [4]={BaseID=4,NameID=2610005,AchievePointCost=10,DescID=2620005,Rank=RankType.RT_White,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_MartialExp,RewardValueB=0,RewardValueC=10000,Sequence=5,},
  [5]={BaseID=5,NameID=2610006,AchievePointCost=25,DescID=2620006,Rank=RankType.RT_White,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_MartialExp,RewardValueB=0,RewardValueC=10000,Condition=4,Sequence=6,},
  [6]={BaseID=6,NameID=2610007,DescID=2620007,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_MartialExp,RewardValueB=0,RewardValueC=10000,Condition=5,Sequence=7,},
  [11]={BaseID=11,NameID=2610026,AchievePointCost=100,DescID=2620026,RewardType=AchieveRewardType.ARD_MartialLevelLimit,Sequence=26,},
  [12]={BaseID=12,NameID=2610027,AchievePointCost=200,DescID=2620027,Rank=RankType.RT_Blue,RewardType=AchieveRewardType.ARD_MartialLevelLimit,Condition=11,Sequence=27,},
  [13]={BaseID=13,NameID=2610028,AchievePointCost=400,DescID=2620028,Rank=RankType.RT_Blue,RewardType=AchieveRewardType.ARD_MartialLevelLimit,Condition=12,Sequence=28,},
  [14]={BaseID=14,NameID=2610029,AchievePointCost=800,DescID=2620029,Rank=RankType.RT_Purple,RewardType=AchieveRewardType.ARD_MartialLevelLimit,Condition=13,Sequence=29,},
  [15]={BaseID=15,NameID=2610022,AchievePointCost=100,DescID=2620022,RewardType=AchieveRewardType.ARD_MartialNum,Sequence=22,},
  [16]={BaseID=16,NameID=2610036,AchievePointCost=25,DescID=2620036,Rank=RankType.RT_White,RewardType=AchieveRewardType.ARD_BagNum,RewardValueA="周目奖励",RewardValueB=100,Sequence=36,},
  [18]={BaseID=18,NameID=2610023,AchievePointCost=200,DescID=2620023,Rank=RankType.RT_Blue,RewardType=AchieveRewardType.ARD_MartialNum,Condition=15,Sequence=23,},
  [19]={BaseID=19,NameID=2610024,AchievePointCost=400,DescID=2620024,Rank=RankType.RT_Blue,RewardType=AchieveRewardType.ARD_MartialNum,Condition=18,Sequence=24,},
  [20]={BaseID=20,NameID=2610025,AchievePointCost=800,DescID=2620025,Rank=RankType.RT_Purple,RewardType=AchieveRewardType.ARD_MartialNum,Condition=19,Sequence=25,},
  [21]={BaseID=21,NameID=2610030,DescID=2620030,RewardType=AchieveRewardType.ARD_RoleLevelLimit,RewardValueB=2,Sequence=30,},
  [22]={BaseID=22,NameID=2610031,AchievePointCost=100,DescID=2620031,Rank=RankType.RT_Blue,RewardType=AchieveRewardType.ARD_RoleLevelLimit,RewardValueB=2,Condition=21,Sequence=31,},
  [23]={BaseID=23,NameID=2610032,AchievePointCost=200,DescID=2620032,Rank=RankType.RT_Blue,RewardType=AchieveRewardType.ARD_RoleLevelLimit,RewardValueB=2,Condition=22,Sequence=32,},
  [24]={BaseID=24,NameID=2610033,AchievePointCost=600,DescID=2620033,Rank=RankType.RT_Purple,RewardType=AchieveRewardType.ARD_RoleLevelLimit,RewardValueB=2,Condition=23,Sequence=33,},
  [25]={BaseID=25,NameID=2610034,AchievePointCost=800,DescID=2620034,Rank=RankType.RT_Orange,RewardType=AchieveRewardType.ARD_RoleLevelLimit,RewardValueB=2,Condition=24,Sequence=34,},
  [26]={BaseID=26,NameID=2610035,AchievePointCost=800,DescID=2620035,Rank=RankType.RT_Golden,RewardType=AchieveRewardType.ARD_RoleLevelLimit,Condition=25,Sequence=35,},
  [33]={BaseID=33,NameID=2610013,AchievePointCost=25,DescID=2620013,Rank=RankType.RT_White,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_GetCopper,RewardValueB=10000,AutoEffective=TBoolean.BOOL_NO,Sequence=13,},
  [34]={BaseID=34,NameID=2610014,AchievePointCost=25,DescID=2620014,Rank=RankType.RT_White,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_GetCopper,RewardValueB=10000,AutoEffective=TBoolean.BOOL_NO,Condition=33,Sequence=14,},
  [35]={BaseID=35,NameID=2610011,AchievePointCost=25,DescID=2620011,Rank=RankType.RT_White,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_SellPrice,RewardValueB=0,RewardValueC=1000,Sequence=11,},
  [36]={BaseID=36,NameID=2610012,DescID=2620012,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_SellPrice,RewardValueB=0,RewardValueC=1000,Condition=35,Sequence=12,},
  [37]={BaseID=37,NameID=2610039,DescID=2620039,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_StartDisposition,RewardValueB=10,Sequence=39,},
  [38]={BaseID=38,NameID=2610009,DescID=2620009,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_DispositionAdd,RewardValueB=0,RewardValueC=1000,Sequence=9,},
  [39]={BaseID=39,NameID=2610010,AchievePointCost=200,DescID=2620010,Rank=RankType.RT_Blue,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_DispositionAdd,RewardValueB=0,RewardValueC=2500,Condition=38,Sequence=10,},
  [43]={BaseID=43,NameID=2610040,AchievePointCost=25,DescID=2620040,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_AllCityFavor,RewardValueB=40,AutoEffective=TBoolean.BOOL_NO,Sequence=40,},
  [44]={BaseID=44,NameID=2610044,AchievePointCost=100,DescID=2620044,Rank=RankType.RT_Blue,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_AllClanFavor,RewardValueB=20,AutoEffective=TBoolean.BOOL_NO,Condition=47,Sequence=44,},
  [45]={BaseID=45,NameID=2610041,AchievePointCost=100,DescID=2620041,Rank=RankType.RT_Blue,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_AllCityFavor,RewardValueB=40,AutoEffective=TBoolean.BOOL_NO,Condition=43,Sequence=41,},
  [46]={BaseID=46,NameID=2610042,DescID=2620042,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_OwnClanFavor,RewardValueB=60,AutoEffective=TBoolean.BOOL_NO,Sequence=42,},
  [47]={BaseID=47,NameID=2610043,AchievePointCost=25,DescID=2620043,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_AllClanFavor,RewardValueB=20,AutoEffective=TBoolean.BOOL_NO,Sequence=43,},
  [48]={BaseID=48,NameID=2610004,AchievePointCost=100,DescID=2620004,Rank=RankType.RT_Blue,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_RoleExp,RewardValueB=0,RewardValueC=5000,Condition=3,Sequence=4,},
  [49]={BaseID=49,NameID=2610008,AchievePointCost=100,DescID=2620008,Rank=RankType.RT_Blue,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardType=AchieveRewardType.ARD_MartialExp,RewardValueB=0,RewardValueC=10000,Condition=5,Sequence=8,},
  [50]={BaseID=50,NameID=2610017,AchievePointCost=5,DescID=2620017,Rank=RankType.RT_White,RewardValueA="130045",RewardValueB=9000,RewardValueC=1,AutoEffective=TBoolean.BOOL_NO,Sequence=17,},
  [51]={BaseID=51,NameID=2610018,DescID=2620018,RewardValueA="130045",RewardValueB=18000,RewardValueC=2,AutoEffective=TBoolean.BOOL_NO,Condition=50,Sequence=18,},
  [52]={BaseID=52,NameID=2610019,AchievePointCost=100,DescID=2620019,Rank=RankType.RT_Blue,RewardValueA="130045",RewardValueB=27000,RewardValueC=3,AutoEffective=TBoolean.BOOL_NO,Condition=51,Sequence=19,},
  [53]={BaseID=53,NameID=2610020,AchievePointCost=200,DescID=2620020,Rank=RankType.RT_Purple,RewardValueA="130045",RewardValueB=36000,RewardValueC=4,AutoEffective=TBoolean.BOOL_NO,Condition=52,Sequence=20,},
  [54]={BaseID=54,NameID=2610021,AchievePointCost=400,DescID=2620021,Rank=RankType.RT_Orange,RewardValueA="130045",RewardValueB=45000,RewardValueC=5,AutoEffective=TBoolean.BOOL_NO,Condition=53,Sequence=21,},
  [55]={BaseID=55,NameID=2610045,AchievePointCost=1000,DescID=2620045,Rank=RankType.RT_Orange,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardValueA="267",AutoEffective=TBoolean.BOOL_NO,Sequence=45,},
  [56]={BaseID=56,NameID=2610046,AchievePointCost=1500,DescID=2620046,Rank=RankType.RT_Orange,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardValueA="263",AutoEffective=TBoolean.BOOL_NO,Sequence=46,},
  [57]={BaseID=57,NameID=2610047,AchievePointCost=1000,DescID=2620047,Rank=RankType.RT_Orange,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardValueA="120001",AutoEffective=TBoolean.BOOL_NO,Sequence=47,},
  [58]={BaseID=58,NameID=2610048,AchievePointCost=500,DescID=2620048,Rank=RankType.RT_Orange,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardValueA="130050",AutoEffective=TBoolean.BOOL_NO,Sequence=48,},
  [59]={BaseID=59,NameID=2610015,DescID=2620015,Rank=RankType.RT_Purple,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardValueA="130046",AutoEffective=TBoolean.BOOL_NO,Sequence=15,},
  [60]={BaseID=60,NameID=2610016,DescID=2620016,Rank=RankType.RT_Purple,RewardNavType=AchieveRewardNavType.ARNT_GrowSpeed,RewardValueA="130047",AutoEffective=TBoolean.BOOL_NO,Sequence=16,},
  [61]={BaseID=61,NameID=2610037,AchievePointCost=1500,DescID=2620037,Rank=RankType.RT_Orange,RewardValueA="130048",RewardValueC=1,AutoEffective=TBoolean.BOOL_NO,Sequence=37,},
  [62]={BaseID=62,NameID=2610038,AchievePointCost=1500,DescID=2620038,Rank=RankType.RT_Golden,RewardValueA="130048",RewardValueB=2,RewardValueC=2,AutoEffective=TBoolean.BOOL_NO,Condition=61,Sequence=38,},
  [63]={BaseID=63,NameID=2610049,AchievePointCost=100,DescID=2620049,Rank=RankType.RT_Purple,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_StartDisposition,RewardValueB=10,Condition=37,Sequence=63,},
  [64]={BaseID=64,NameID=2610050,AchievePointCost=500,DescID=2620050,Rank=RankType.RT_Orange,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardType=AchieveRewardType.ARD_StartDisposition,RewardValueB=20,Condition=63,Sequence=64,},
  [65]={BaseID=65,NameID=2610051,AchievePointCost=500,DescID=2620051,Rank=RankType.RT_Orange,RewardNavType=AchieveRewardNavType.ARNT_OriPrower,RewardValueA="130049",AutoEffective=TBoolean.BOOL_NO,Sequence=65,},
}
for k,v in pairs(AchieveReward) do
    setmetatable(v, {['__index'] = AchieveRewardDefault})
end

-- export table: AchieveReward
return AchieveReward
