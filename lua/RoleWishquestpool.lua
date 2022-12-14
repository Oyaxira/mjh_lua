-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum SexType
-- enum RankType
-- enum TBoolean
require("common");


local RoleWishQuestPoolDefault = {Type="乙级",ShaneMin=-100,ShaneMax=100,LowRank=RankType.RT_Orange,HighRank=RankType.RT_Golden,Enable=TBoolean.BOOL_NO,}
local RoleWishQuestPool= {
  [1]={BaseID=1,EnableSexType={SexType.ST_NonSex,SexType.ST_Male,SexType.ST_Female,SexType.ST_BothSex,SexType.ST_Eunuch,},WishQuestIDs={88,89,90,},},
  [2]={BaseID=2,ShaneMin=20,EnableSexType={SexType.ST_NonSex,SexType.ST_Male,SexType.ST_Female,SexType.ST_BothSex,SexType.ST_Eunuch,},WishQuestIDs={91,92,93,},},
  [3]={BaseID=3,ShaneMin=20,EnableSexType={SexType.ST_Male,SexType.ST_Female,},WishQuestIDs={94,95,96,},},
  [4]={BaseID=4,ShaneMax=-20,EnableSexType={SexType.ST_NonSex,SexType.ST_Male,SexType.ST_Female,SexType.ST_BothSex,SexType.ST_Eunuch,},WishQuestIDs={85,86,87,},},
  [5]={BaseID=5,EnableSexType={SexType.ST_NonSex,SexType.ST_Male,SexType.ST_Female,SexType.ST_BothSex,SexType.ST_Eunuch,},WishQuestIDs={82,83,84,},},
  [6]={BaseID=6,ShaneMax=-20,EnableSexType={SexType.ST_Male,},WishQuestIDs={79,80,81,},},
  [7]={BaseID=7,Type="甲级",EnableSexType={SexType.ST_NonSex,SexType.ST_Male,SexType.ST_Female,SexType.ST_BothSex,SexType.ST_Eunuch,},WishQuestIDs={97,98,99,100,101,102,103,},LowRank=RankType.RT_DarkGolden,HighRank=RankType.RT_DarkGolden,},
  [8]={BaseID=8,Type="丙级",EnableSexType={SexType.ST_NonSex,SexType.ST_Male,SexType.ST_Female,SexType.ST_BothSex,SexType.ST_Eunuch,},WishQuestIDs={132,},LowRank=RankType.RT_Blue,HighRank=RankType.RT_Purple,Enable=TBoolean.BOOL_YES,},
  [9]={BaseID=9,Type="丙级",EnableSexType={SexType.ST_NonSex,SexType.ST_Male,SexType.ST_Female,SexType.ST_BothSex,SexType.ST_Eunuch,},WishQuestIDs={132,},LowRank=RankType.RT_Blue,HighRank=RankType.RT_Purple,},
}
for k,v in pairs(RoleWishQuestPool) do
    setmetatable(v, {['__index'] = RoleWishQuestPoolDefault})
end

-- export table: RoleWishQuestPool
return RoleWishQuestPool
