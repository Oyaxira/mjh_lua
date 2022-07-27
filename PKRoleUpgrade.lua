-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum RankType
require("common");


local PKRoleUpgradeDefault = {MixNum=2,Rank=RankType.RT_DarkGolden,Grade=0,WeaponRank=RankType.RT_DarkGolden,WeaponUpgrade=0,KongFuNum=20,Level1=30,Level2=30,Level3=30,RefreshTime=5,}
local PKRoleUpgrade= {
  [1]={BaseID=1,MixLevel=1,MixNum=0,Level=5,Rank=RankType.RT_White,WeaponRank=RankType.RT_White,KongFuNum=3,Level1=5,Level2=5,Level3=5,Level4=5,Level5=5,Level6=5,Level7=5,Weight={400,400,300,300,200,200,100,100,0,},RefreshTime=1,},
  [2]={BaseID=2,MixLevel=2,Level=10,Rank=RankType.RT_Green,WeaponRank=RankType.RT_Green,KongFuNum=6,Level1=10,Level2=10,Level3=10,Level4=10,Level5=10,Level6=10,Level7=10,Weight={400,400,300,300,200,200,100,100,0,},RefreshTime=1,},
  [3]={BaseID=3,MixLevel=3,Level=15,Rank=RankType.RT_Blue,WeaponRank=RankType.RT_Blue,KongFuNum=10,Level1=15,Level2=15,Level3=13,Level4=13,Level5=13,Level6=13,Level7=13,Weight={150,150,250,250,300,300,250,250,300,},RefreshTime=2,},
  [4]={BaseID=4,MixLevel=4,Level=20,Rank=RankType.RT_Purple,WeaponRank=RankType.RT_Purple,KongFuNum=12,Level1=20,Level2=18,Level3=15,Level4=13,Level5=13,Level6=13,Level7=13,Weight={50,50,100,100,150,150,250,250,250,},RefreshTime=2,},
  [5]={BaseID=5,MixLevel=5,Level=25,Rank=RankType.RT_Orange,WeaponRank=RankType.RT_Orange,KongFuNum=14,Level1=25,Level2=23,Level3=20,Level4=20,Level5=20,Level6=20,Level7=20,Weight={0,0,50,50,100,100,150,150,200,},RefreshTime=3,},
  [6]={BaseID=6,MixLevel=6,Level=30,Rank=RankType.RT_Golden,WeaponRank=RankType.RT_Golden,KongFuNum=16,Level1=28,Level2=25,Level3=23,Level4=20,Level5=20,Level6=20,Level7=20,Weight={0,0,0,0,50,50,100,100,150,},RefreshTime=4,},
  [7]={BaseID=7,MixLevel=7,Level=30,Level3=25,Level4=25,Level5=25,Level6=22,Level7=20,Weight={0,0,0,0,0,0,50,50,100,},},
  [8]={BaseID=8,MixLevel=8,Level=33,Grade=1,WeaponUpgrade=2,Level4=28,Level5=28,Level6=25,Level7=24,Weight={0,0,0,0,0,0,0,0,0,},},
  [9]={BaseID=9,MixLevel=9,Level=36,Grade=2,WeaponUpgrade=4,Level4=30,Level5=30,Level6=28,Level7=26,Weight={0,0,0,0,0,0,0,0,0,},},
  [10]={BaseID=10,MixLevel=10,Level=39,Grade=3,WeaponUpgrade=6,Level4=30,Level5=30,Level6=30,Level7=28,Weight={0,0,0,0,0,0,0,0,0,},},
  [11]={BaseID=11,MixLevel=11,Level=42,Grade=4,WeaponUpgrade=8,Level4=30,Level5=30,Level6=30,Level7=30,Weight={0,0,0,0,0,0,0,0,0,},},
  [12]={BaseID=12,MixLevel=12,Level=45,Grade=5,WeaponUpgrade=10,Level4=30,Level5=30,Level6=30,Level7=30,Weight={0,0,0,0,0,0,0,0,0,},},
}
for k,v in pairs(PKRoleUpgrade) do
    setmetatable(v, {['__index'] = PKRoleUpgradeDefault})
end

-- export table: PKRoleUpgrade
return PKRoleUpgrade
