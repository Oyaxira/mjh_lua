-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum BattleAITargetClass
-- enum BattleAITargetType
require("common");


local BattleAITargetDefault = {LockLevel=2,ClassType=BattleAITargetClass.BATC_ENEMY_STATE,TargetType=1,Type=BattleAITargetType.BATT_ENEMY_STATE,Param=0,}
local BattleAITarget= {
  [2]={BaseID=2,NameID=410101,SortValue=2,LockLevel=1,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY,Param=2,},
  [3]={BaseID=3,NameID=410102,SortValue=3,LockLevel=5,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY,Param=3,},
  [4]={BaseID=4,NameID=410103,SortValue=4,LockLevel=1,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY,Param=4,},
  [5]={BaseID=5,NameID=410104,SortValue=5,LockLevel=1,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY,Param=5,},
  [6]={BaseID=6,NameID=410105,SortValue=6,LockLevel=1,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,},
  [7]={BaseID=7,NameID=410106,SortValue=7,LockLevel=1,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,Param=100,},
  [8]={BaseID=8,NameID=410109,SortValue=10,LockLevel=5,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,Param=75000,},
  [9]={BaseID=9,NameID=410110,SortValue=11,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,Param=50000,},
  [10]={BaseID=10,NameID=410111,SortValue=12,LockLevel=5,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,Param=25000,},
  [11]={BaseID=11,NameID=410117,SortValue=18,Param=136,},
  [12]={BaseID=12,NameID=410118,SortValue=19,Param=137,},
  [13]={BaseID=13,NameID=410119,SortValue=20,Param=138,},
  [14]={BaseID=14,NameID=410120,SortValue=21,Param=139,},
  [15]={BaseID=15,NameID=410121,SortValue=22,Param=140,},
  [16]={BaseID=16,NameID=410122,SortValue=23,Param=141,},
  [17]={BaseID=17,NameID=410123,SortValue=24,LockLevel=5,Param=126,},
  [18]={BaseID=18,NameID=410124,SortValue=25,LockLevel=5,Param=127,},
  [19]={BaseID=19,NameID=410125,SortValue=26,LockLevel=5,Param=128,},
  [20]={BaseID=20,NameID=410126,SortValue=27,LockLevel=5,Param=129,},
  [21]={BaseID=21,NameID=410127,SortValue=28,LockLevel=5,Param=130,},
  [23]={BaseID=23,NameID=410128,SortValue=29,LockLevel=1,ClassType=BattleAITargetClass.BATC_PARTY,TargetType=2,Type=BattleAITargetType.BATT_FRIEND,Param=2,},
  [24]={BaseID=24,NameID=410129,SortValue=30,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY,TargetType=2,Type=BattleAITargetType.BATT_FRIEND,Param=3,},
  [25]={BaseID=25,NameID=410130,SortValue=31,LockLevel=1,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,},
  [26]={BaseID=26,NameID=410131,SortValue=32,LockLevel=1,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,Param=100,},
  [27]={BaseID=27,NameID=410134,SortValue=35,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,Param=75000,},
  [28]={BaseID=28,NameID=410135,SortValue=36,LockLevel=1,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,Param=50000,},
  [29]={BaseID=29,NameID=410136,SortValue=37,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,Param=25000,},
  [30]={BaseID=30,NameID=410142,SortValue=43,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=136,},
  [31]={BaseID=31,NameID=410143,SortValue=44,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=137,},
  [32]={BaseID=32,NameID=410144,SortValue=45,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=138,},
  [33]={BaseID=33,NameID=410145,SortValue=46,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=139,},
  [34]={BaseID=34,NameID=410146,SortValue=47,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=140,},
  [35]={BaseID=35,NameID=410147,SortValue=48,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=141,},
  [36]={BaseID=36,NameID=410148,SortValue=49,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=126,},
  [37]={BaseID=37,NameID=410149,SortValue=50,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=127,},
  [38]={BaseID=38,NameID=410150,SortValue=51,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=128,},
  [39]={BaseID=39,NameID=410151,SortValue=52,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=129,},
  [40]={BaseID=40,NameID=410152,SortValue=53,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_STATE,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_STATE,Param=130,},
  [41]={BaseID=41,NameID=410153,SortValue=54,LockLevel=1,ClassType=BattleAITargetClass.BATC_PARTY,TargetType=2,Type=BattleAITargetType.BATT_SELF,},
  [42]={BaseID=42,NameID=410112,SortValue=13,LockLevel=5,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,Param=100075,},
  [43]={BaseID=43,NameID=410113,SortValue=14,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,Param=100050,},
  [44]={BaseID=44,NameID=410114,SortValue=15,LockLevel=5,ClassType=BattleAITargetClass.BATC_ENEMY_HP,Type=BattleAITargetType.BATT_ENEMY_HP,Param=100025,},
  [45]={BaseID=45,NameID=410115,SortValue=16,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY_MP,Param=50000,},
  [46]={BaseID=46,NameID=410116,SortValue=17,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY_MP,Param=100050,},
  [47]={BaseID=47,NameID=410137,SortValue=38,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,Param=100075,},
  [48]={BaseID=48,NameID=410138,SortValue=39,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,Param=100050,},
  [49]={BaseID=49,NameID=410139,SortValue=40,LockLevel=5,ClassType=BattleAITargetClass.BATC_PARTY_HP,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_HP,Param=100025,},
  [50]={BaseID=50,NameID=410140,SortValue=41,ClassType=BattleAITargetClass.BATC_PARTY,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_MP,Param=50000,},
  [51]={BaseID=51,NameID=410141,SortValue=42,ClassType=BattleAITargetClass.BATC_PARTY,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_MP,Param=100050,},
  [52]={BaseID=52,NameID=410107,SortValue=8,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY_MP,},
  [53]={BaseID=53,NameID=410108,SortValue=9,LockLevel=1,ClassType=BattleAITargetClass.BATC_ENEMY,Type=BattleAITargetType.BATT_ENEMY_MP,Param=100,},
  [54]={BaseID=54,NameID=410132,SortValue=33,ClassType=BattleAITargetClass.BATC_PARTY,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_MP,},
  [55]={BaseID=55,NameID=410133,SortValue=34,LockLevel=1,ClassType=BattleAITargetClass.BATC_PARTY,TargetType=2,Type=BattleAITargetType.BATT_FRIEND_MP,Param=100,},
}
for k,v in pairs(BattleAITarget) do
    setmetatable(v, {['__index'] = BattleAITargetDefault})
end

-- export table: BattleAITarget
return BattleAITarget
