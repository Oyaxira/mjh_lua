-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum OutputTypeType
-- enum RankType
-- enum ItemTypeDetail
-- enum CtrlTypeType
-- enum CtrlTimeType
require("common");


local DropCtrlDefault = {OutputType=OutputTypeType.OTT_ITEM,ItemID=1401,ReplaceItemID=0,ItemRank=RankType.RT_RankTypeNull,ItemType=ItemTypeDetail.ItemType_Null,MaxTimes=50,CtrlType=CtrlTypeType.CTT_GEREN,CtrlTime=CtrlTimeType.CTiT_NULL,CtrlStory=0,}
local DropCtrl= {
  [1]={BaseID=1,ReplaceItemID=1301,MaxCount=111,MaxTimes=5,CtrlTime=CtrlTimeType.CTiT_YONGJIU,},
  [2]={BaseID=2,ReplaceItemID=1301,MaxCount=200,MaxTimes=5,CtrlType=CtrlTypeType.CTT_QUANFU,CtrlTime=CtrlTimeType.CTiT_YONGJIU,},
  [3]={BaseID=3,ReplaceItemID=1302,ItemRank=RankType.RT_Green,ItemType=ItemTypeDetail.ItemType_Equipment,MaxCount=300,MaxTimes=30,},
  [4]={BaseID=4,ReplaceItemID=1302,MaxCount=200,MaxTimes=100,},
  [5]={BaseID=5,ReplaceItemID=1302,MaxCount=300,MaxTimes=30,},
  [6]={BaseID=6,ReplaceItemID=1302,MaxCount=200,MaxTimes=100,},
  [7]={BaseID=7,ItemID=1201,ReplaceItemID=1301,MaxCount=100000,MaxTimes=1000,CtrlTime=CtrlTimeType.CTiT_YONGJIU,},
  [8]={BaseID=8,MaxCount=300,MaxTimes=300,},
  [9]={BaseID=9,MaxCount=200,MaxTimes=1,},
  [10]={BaseID=10,MaxCount=500,MaxTimes=1,},
  [11]={BaseID=11,MaxCount=500,MaxTimes=1,},
  [12]={BaseID=12,ReplaceItemID=1301,MaxCount=10,MaxTimes=2,CtrlTime=CtrlTimeType.CTiT_YONGJIU,CtrlStory=5,},
  [13]={BaseID=13,ReplaceItemID=1301,MaxCount=100,MaxTimes=2,CtrlTime=CtrlTimeType.CTiT_YONGJIU,},
  [14]={BaseID=14,MaxCount=5000,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [15]={BaseID=15,MaxCount=5000,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [16]={BaseID=16,ItemID=1201,MaxCount=50,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [17]={BaseID=17,ItemID=1201,MaxCount=50,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [18]={BaseID=18,ReplaceItemID=1301,MaxCount=1000,MaxTimes=100,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [19]={BaseID=19,ItemID=1201,MaxCount=50,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [20]={BaseID=20,MaxCount=500,MaxTimes=1,},
  [21]={BaseID=21,MaxCount=5000,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [22]={BaseID=22,ReplaceItemID=1301,MaxCount=999999,MaxTimes=9999,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
  [23]={BaseID=23,ReplaceItemID=1301,MaxCount=99999,MaxTimes=9999,CtrlTime=CtrlTimeType.CTiT_ZHOU,},
}
for k,v in pairs(DropCtrl) do
    setmetatable(v, {['__index'] = DropCtrlDefault})
end

-- export table: DropCtrl
return DropCtrl
