-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum ItemTypeDetail
-- enum TBoolean
require("common");


local ItemTypeDefault = {CanRecast=TBoolean.BOOL_NO,CanIntensify=TBoolean.BOOL_NO,AdvType=24,}
local ItemType= {
  [1]={BaseID=1,BaseType="任务",EnumType=ItemTypeDetail.ItemType_Task,ChildItemType={44,},SimpleName="任务",SortWeight=1000,AdvType=21,},
  [2]={BaseID=2,BaseType="消耗品",EnumType=ItemTypeDetail.ItemType_Consume,ChildItemType={47,46,21,26,42,},SimpleName="消耗",SortWeight=4000,},
  [3]={BaseID=3,BaseType="衣服",EnumType=ItemTypeDetail.ItemType_Clothes,SimpleName="衣服",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5180,AdvType=20,},
  [4]={BaseID=4,BaseType="鞋子",EnumType=ItemTypeDetail.ItemType_Shoe,SimpleName="鞋子",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5170,AdvType=20,},
  [5]={BaseID=5,BaseType="饰品",EnumType=ItemTypeDetail.ItemType_Ornaments,SimpleName="饰品",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5160,AdvType=20,},
  [6]={BaseID=6,BaseType="披风",EnumType=ItemTypeDetail.ItemType_Wing,SimpleName="披风",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5130,AdvType=20,},
  [7]={BaseID=7,BaseType="坐骑",EnumType=ItemTypeDetail.ItemType_Mounts,SimpleName="坐骑",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5140,AdvType=20,},
  [8]={BaseID=8,BaseType="武器",EnumType=ItemTypeDetail.ItemType_Weapon,ChildItemType={9,10,11,12,29,28,27,},SimpleName="武器",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5210,AdvType=18,},
  [9]={BaseID=9,BaseType="刀",EnumType=ItemTypeDetail.ItemType_Knife,SimpleName="刀类",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5290,AdvType=18,},
  [10]={BaseID=10,BaseType="剑",EnumType=ItemTypeDetail.ItemType_Sword,SimpleName="剑类",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5280,AdvType=18,},
  [11]={BaseID=11,BaseType="拳",EnumType=ItemTypeDetail.ItemType_Fist,SimpleName="拳类",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5270,AdvType=18,},
  [12]={BaseID=12,BaseType="棍",EnumType=ItemTypeDetail.ItemType_Rod,SimpleName="棍类",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5260,AdvType=18,},
  [13]={BaseID=13,BaseType="鞭",EnumType=ItemTypeDetail.ItemType_Whip,SimpleName="鞭类",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5250,AdvType=18,},
  [14]={BaseID=14,BaseType="神器",EnumType=ItemTypeDetail.ItemType_Artifact,SimpleName="神器",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5150,AdvType=20,},
  [15]={BaseID=15,BaseType="秘籍",EnumType=ItemTypeDetail.ItemType_SecretBook,SimpleName="秘籍",SortWeight=3300,AdvType=17,},
  [16]={BaseID=16,BaseType="残章",EnumType=ItemTypeDetail.ItemType_IncompleteBook,SimpleName="残章",SortWeight=3100,AdvType=16,},
  [17]={BaseID=17,BaseType="天书",EnumType=ItemTypeDetail.ItemType_HeavenBook,SimpleName="天书",SortWeight=3200,AdvType=17,},
  [18]={BaseID=18,BaseType="暗器",EnumType=ItemTypeDetail.ItemType_HiddenWeapon,SimpleName="暗器",SortWeight=5120,},
  [19]={BaseID=19,BaseType="医术",EnumType=ItemTypeDetail.ItemType_Leechcraft,SimpleName="医术",SortWeight=5110,},
  [20]={BaseID=20,BaseType="材料",EnumType=ItemTypeDetail.ItemType_Material,ChildItemType={64,62,58,59,56,57,60,63,65,66,67,},SimpleName="材料",SortWeight=2000,},
  [21]={BaseID=21,BaseType="菜肴",EnumType=ItemTypeDetail.ItemType_Dish,SimpleName="菜肴",SortWeight=4300,AdvType=4,},
  [22]={BaseID=22,BaseType="装备",EnumType=ItemTypeDetail.ItemType_Equipment,ChildItemType={9,10,11,12,29,28,27,3,4,5,6,14,},SimpleName="装备",SortWeight=5000,AdvType=18,},
  [23]={BaseID=23,BaseType="武学书",EnumType=ItemTypeDetail.ItemType_Book,ChildItemType={15,17,},SimpleName="武学",SortWeight=3000,AdvType=17,},
  [24]={BaseID=24,BaseType="商品",EnumType=ItemTypeDetail.ItemType_Goods,SimpleName="商品",SortWeight=1100,},
  [25]={BaseID=25,BaseType="铜币",EnumType=ItemTypeDetail.ItemType_Copper,SimpleName="铜币",SortWeight=0,AdvType=8,},
  [26]={BaseID=26,BaseType="配方",EnumType=ItemTypeDetail.ItemType_Formula,SimpleName="配方",SortWeight=4400,AdvType=17,},
  [27]={BaseID=27,BaseType="护腿",EnumType=ItemTypeDetail.ItemType_Cane,SimpleName="护腿",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5220,AdvType=18,},
  [28]={BaseID=28,BaseType="针匣",EnumType=ItemTypeDetail.ItemType_NeedleBox,SimpleName="针匣",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5230,AdvType=18,},
  [29]={BaseID=29,BaseType="扇",EnumType=ItemTypeDetail.ItemType_Fan,SimpleName="扇类",CanRecast=TBoolean.BOOL_YES,CanIntensify=TBoolean.BOOL_YES,SortWeight=5240,AdvType=18,},
  [30]={BaseID=30,BaseType="武器装备",EnumType=ItemTypeDetail.ItemType_WeaponEquip,ChildItemType={9,10,11,12,29,28,27,},SimpleName="武器",SortWeight=5200,AdvType=18,},
  [31]={BaseID=31,BaseType="角色卡",EnumType=ItemTypeDetail.ItemType_RolePieces,SimpleName="角色",SortWeight=6700,},
  [32]={BaseID=32,BaseType="防具装备",EnumType=ItemTypeDetail.ItemType_ArmorEquip,ChildItemType={3,4,5,},SimpleName="防具",SortWeight=5100,AdvType=20,},
  [33]={BaseID=33,BaseType="宠物卡",EnumType=ItemTypeDetail.ItemType_PetPieces,SimpleName="宠物",SortWeight=6600,},
  [34]={BaseID=34,BaseType="立绘",EnumType=ItemTypeDetail.ItemType_Lithography,SimpleName="立绘",SortWeight=6500,},
  [35]={BaseID=35,BaseType="模型",EnumType=ItemTypeDetail.ItemType_Model,SimpleName="模型",SortWeight=6400,},
  [36]={BaseID=36,BaseType="诗词",EnumType=ItemTypeDetail.ItemType_Poetry,SimpleName="诗词",SortWeight=6300,},
  [37]={BaseID=37,BaseType="背景音乐",EnumType=ItemTypeDetail.ItemType_BGM,SimpleName="音乐",SortWeight=6200,},
  [38]={BaseID=38,BaseType="背景图",EnumType=ItemTypeDetail.ItemType_BGP,SimpleName="背景",SortWeight=6100,},
  [39]={BaseID=39,BaseType="金锭",EnumType=ItemTypeDetail.ItemType_Gold,SimpleName="金锭",SortWeight=0,},
  [40]={BaseID=40,BaseType="银锭",EnumType=ItemTypeDetail.ItemType_Silve,SimpleName="银锭",SortWeight=0,},
  [41]={BaseID=41,BaseType="货币",EnumType=ItemTypeDetail.ItemType_Money,ChildItemType={25,39,40,},SimpleName="货币",SortWeight=0,AdvType=8,},
  [42]={BaseID=42,BaseType="粮食",EnumType=ItemTypeDetail.ItemType_Food,SimpleName="粮食",SortWeight=5130,AdvType=5,},
  [43]={BaseID=43,BaseType="酒馆",EnumType=ItemTypeDetail.ItemType_Pub,ChildItemType={36,37,48,52,54,55,70,71,},SimpleName="酒馆",SortWeight=6000,},
  [44]={BaseID=44,BaseType="藏宝图",EnumType=ItemTypeDetail.ItemType_TreasureMap,SimpleName="挖宝",SortWeight=6100,AdvType=15,},
  [46]={BaseID=46,BaseType="丹药",EnumType=ItemTypeDetail.ItemType_Pill,SimpleName="丹药",SortWeight=4200,AdvType=1,},
  [47]={BaseID=47,BaseType="可用杂物",EnumType=ItemTypeDetail.ItemType_Item,SimpleName="杂物",SortWeight=4100,},
  [48]={BaseID=48,BaseType="地台",EnumType=ItemTypeDetail.ItemType_Platform,SimpleName="地台",SortWeight=6099,},
  [52]={BaseID=52,BaseType="登录词",EnumType=ItemTypeDetail.ItemType_LoginWord,SimpleName="登录",SortWeight=6800,},
  [53]={BaseID=53,BaseType="宠物造型",EnumType=ItemTypeDetail.ItemType_PetPieces2,SimpleName="造型",SortWeight=6601,},
  [54]={BaseID=54,BaseType="头像框",EnumType=ItemTypeDetail.ItemType_HeadBox,SimpleName="头像",SortWeight=6900,},
  [55]={BaseID=55,BaseType="聊天气泡",EnumType=ItemTypeDetail.ItemType_ChatBubble,SimpleName="气泡",SortWeight=7000,},
  [56]={BaseID=56,BaseType="游戏",EnumType=ItemTypeDetail.ItemType_MaterialGame,SimpleName="游戏",SortWeight=2001,AdvType=11,},
  [57]={BaseID=57,BaseType="书画",EnumType=ItemTypeDetail.ItemType_MaterialPaint,SimpleName="书画",SortWeight=2002,AdvType=12,},
  [58]={BaseID=58,BaseType="酒类",EnumType=ItemTypeDetail.ItemType_MaterialWine,SimpleName="酒类",SortWeight=2003,AdvType=7,},
  [59]={BaseID=59,BaseType="花卉",EnumType=ItemTypeDetail.ItemType_MaterialFlower,SimpleName="花卉",SortWeight=2004,AdvType=2,},
  [60]={BaseID=60,BaseType="生活道具",EnumType=ItemTypeDetail.ItemType_MaterialLivingItem,SimpleName="生活",SortWeight=2005,AdvType=9,},
  [62]={BaseID=62,BaseType="烹饪材料",EnumType=ItemTypeDetail.ItemType_MaterialCooking,SimpleName="烹饪",SortWeight=2007,AdvType=5,},
  [63]={BaseID=63,BaseType="药材",EnumType=ItemTypeDetail.ItemType_MaterialMedicinal,SimpleName="药材",SortWeight=2008,AdvType=1,},
  [64]={BaseID=64,BaseType="矿石",EnumType=ItemTypeDetail.ItemType_MaterialOre,SimpleName="矿石",SortWeight=2009,AdvType=3,},
  [65]={BaseID=65,BaseType="化妆品",EnumType=ItemTypeDetail.ItemType_MaterialMaquillage,SimpleName="化妆",SortWeight=2010,AdvType=6,},
  [66]={BaseID=66,BaseType="音律",EnumType=ItemTypeDetail.ItemType_MaterialMusic,SimpleName="音律",SortWeight=2011,AdvType=10,},
  [67]={BaseID=67,BaseType="杂物",EnumType=ItemTypeDetail.ItemType_MaterialOthers,SimpleName="杂物",SortWeight=2012,},
  [70]={BaseID=70,BaseType="老板娘",EnumType=ItemTypeDetail.ItemType_LandLady,SimpleName="掌柜",SortWeight=7100,},
  [71]={BaseID=71,BaseType="摆件",EnumType=ItemTypeDetail.ItemType_Decoration,SimpleName="摆件",SortWeight=7200,},
}
for k,v in pairs(ItemType) do
    setmetatable(v, {['__index'] = ItemTypeDefault})
end

-- export table: ItemType
return ItemType
