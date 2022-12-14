-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum RankType
require("common");


local ItemAutoGenStrengthDefault = {Diff=1,Rank=RankType.RT_White,MysteShopStrength=15,MysteShopPricePer=50000,}
local ItemAutoGenStrength= {
  [1025]={MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={20,20,20,20,12,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [1026]={Diff=2,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={16,22,22,20,12,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [1027]={Diff=3,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,14,14,13,13,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [1028]={Diff=4,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,12,13,14,14,14,13,7,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [1029]={Diff=5,StrengthWeight={0,0,0,0,0,0,0,14,14,13,13,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [1030]={Diff=6,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [1031]={Diff=7,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [1032]={Diff=8,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [1033]={Diff=9,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [2049]={Rank=RankType.RT_Green,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={20,20,20,20,12,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [2050]={Diff=2,Rank=RankType.RT_Green,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={16,22,22,20,12,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [2051]={Diff=3,Rank=RankType.RT_Green,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,14,14,13,13,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [2052]={Diff=4,Rank=RankType.RT_Green,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,12,13,14,14,14,13,7,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [2053]={Diff=5,Rank=RankType.RT_Green,StrengthWeight={0,0,0,0,0,0,0,14,14,13,13,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [2054]={Diff=6,Rank=RankType.RT_Green,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [2055]={Diff=7,Rank=RankType.RT_Green,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [2056]={Diff=8,Rank=RankType.RT_Green,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [2057]={Diff=9,Rank=RankType.RT_Green,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [3073]={Rank=RankType.RT_Blue,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={20,20,20,20,12,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [3074]={Diff=2,Rank=RankType.RT_Blue,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={16,22,22,20,12,8,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [3075]={Diff=3,Rank=RankType.RT_Blue,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,14,14,13,13,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [3076]={Diff=4,Rank=RankType.RT_Blue,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,12,13,14,14,14,13,7,7,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [3077]={Diff=5,Rank=RankType.RT_Blue,StrengthWeight={0,0,0,0,0,0,0,14,14,13,13,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [3078]={Diff=6,Rank=RankType.RT_Blue,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,13,13,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [3079]={Diff=7,Rank=RankType.RT_Blue,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [3080]={Diff=8,Rank=RankType.RT_Blue,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [3081]={Diff=9,Rank=RankType.RT_Blue,StrengthWeight={0,0,0,0,0,0,0,10,10,10,10,12,12,7,7,6,0,0,0,0,0,0,0,0,0,0,},},
  [4097]={Rank=RankType.RT_Purple,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={21,21,21,21,10,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [4098]={Diff=2,Rank=RankType.RT_Purple,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={17,23,23,21,10,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [4099]={Diff=3,Rank=RankType.RT_Purple,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,14,14,14,14,14,14,6,6,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [4100]={Diff=4,Rank=RankType.RT_Purple,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,10,15,15,15,15,14,6,6,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [4101]={Diff=5,Rank=RankType.RT_Purple,StrengthWeight={0,0,0,0,0,0,0,14,14,14,14,14,14,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [4102]={Diff=6,Rank=RankType.RT_Purple,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [4103]={Diff=7,Rank=RankType.RT_Purple,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [4104]={Diff=8,Rank=RankType.RT_Purple,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [4105]={Diff=9,Rank=RankType.RT_Purple,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [5121]={Rank=RankType.RT_Orange,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={21,21,21,21,10,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [5122]={Diff=2,Rank=RankType.RT_Orange,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={17,23,23,21,10,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [5123]={Diff=3,Rank=RankType.RT_Orange,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,14,14,14,14,14,14,6,6,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [5124]={Diff=4,Rank=RankType.RT_Orange,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,10,15,15,15,15,14,6,6,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [5125]={Diff=5,Rank=RankType.RT_Orange,StrengthWeight={0,0,0,0,0,0,0,14,14,14,14,14,14,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [5126]={Diff=6,Rank=RankType.RT_Orange,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [5127]={Diff=7,Rank=RankType.RT_Orange,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [5128]={Diff=8,Rank=RankType.RT_Orange,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [5129]={Diff=9,Rank=RankType.RT_Orange,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [6145]={Rank=RankType.RT_Golden,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={21,21,21,21,10,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [6146]={Diff=2,Rank=RankType.RT_Golden,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={17,23,23,21,10,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [6147]={Diff=3,Rank=RankType.RT_Golden,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,14,14,14,14,14,14,6,6,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [6148]={Diff=4,Rank=RankType.RT_Golden,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,10,15,15,15,15,14,6,6,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [6149]={Diff=5,Rank=RankType.RT_Golden,StrengthWeight={0,0,0,0,0,0,0,14,14,14,14,14,14,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [6150]={Diff=6,Rank=RankType.RT_Golden,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [6151]={Diff=7,Rank=RankType.RT_Golden,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [6152]={Diff=8,Rank=RankType.RT_Golden,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [6153]={Diff=9,Rank=RankType.RT_Golden,StrengthWeight={0,0,0,0,0,0,0,12,12,12,12,12,12,6,6,4,0,0,0,0,0,0,0,0,0,0,},},
  [7169]={Rank=RankType.RT_DarkGolden,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={23,23,22,22,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [7170]={Diff=2,Rank=RankType.RT_DarkGolden,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={21,23,23,23,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [7171]={Diff=3,Rank=RankType.RT_DarkGolden,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,15,15,15,15,15,15,4,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [7172]={Diff=4,Rank=RankType.RT_DarkGolden,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,11,16,16,16,16,15,4,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [7173]={Diff=5,Rank=RankType.RT_DarkGolden,StrengthWeight={0,0,0,0,0,0,0,15,15,15,15,15,15,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [7174]={Diff=6,Rank=RankType.RT_DarkGolden,StrengthWeight={0,0,0,0,0,0,0,14,14,14,14,14,14,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [7175]={Diff=7,Rank=RankType.RT_DarkGolden,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [7176]={Diff=8,Rank=RankType.RT_DarkGolden,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [7177]={Diff=9,Rank=RankType.RT_DarkGolden,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [8193]={Rank=RankType.RT_MultiColor,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={23,23,22,22,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [8194]={Diff=2,Rank=RankType.RT_MultiColor,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={21,23,23,23,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [8195]={Diff=3,Rank=RankType.RT_MultiColor,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,15,15,15,15,15,15,4,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [8196]={Diff=4,Rank=RankType.RT_MultiColor,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,11,16,16,16,16,15,4,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [8197]={Diff=5,Rank=RankType.RT_MultiColor,StrengthWeight={0,0,0,0,0,0,0,15,15,15,15,15,15,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [8198]={Diff=6,Rank=RankType.RT_MultiColor,StrengthWeight={0,0,0,0,0,0,0,14,14,14,14,14,14,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [8199]={Diff=7,Rank=RankType.RT_MultiColor,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [8200]={Diff=8,Rank=RankType.RT_MultiColor,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [8201]={Diff=9,Rank=RankType.RT_MultiColor,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [9217]={Rank=RankType.RT_ThirdGearDarkGolden,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={23,23,22,22,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [9218]={Diff=2,Rank=RankType.RT_ThirdGearDarkGolden,MysteShopStrength=5,MysteShopPricePer=0,StrengthWeight={21,23,23,23,7,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [9219]={Diff=3,Rank=RankType.RT_ThirdGearDarkGolden,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,15,15,15,15,15,15,4,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [9220]={Diff=4,Rank=RankType.RT_ThirdGearDarkGolden,MysteShopStrength=10,MysteShopPricePer=15000,StrengthWeight={0,0,11,16,16,16,16,15,4,4,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,},},
  [9221]={Diff=5,Rank=RankType.RT_ThirdGearDarkGolden,StrengthWeight={0,0,0,0,0,0,0,15,15,15,15,15,15,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [9222]={Diff=6,Rank=RankType.RT_ThirdGearDarkGolden,StrengthWeight={0,0,0,0,0,0,0,14,14,14,14,14,14,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [9223]={Diff=7,Rank=RankType.RT_ThirdGearDarkGolden,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [9224]={Diff=8,Rank=RankType.RT_ThirdGearDarkGolden,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
  [9225]={Diff=9,Rank=RankType.RT_ThirdGearDarkGolden,StrengthWeight={0,0,0,0,0,0,0,13,13,13,13,13,13,4,4,2,0,0,0,0,0,0,0,0,0,0,},},
}
for k,v in pairs(ItemAutoGenStrength) do
    setmetatable(v, {['__index'] = ItemAutoGenStrengthDefault})
end

-- export table: ItemAutoGenStrength
return ItemAutoGenStrength
