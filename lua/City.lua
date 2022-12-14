-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum CityStage
require("common");


local CityDefault = {ShowStage=CityStage.CS_NORMAL,CityInfoIcon="ChainCity/city_1",NameUIOffsetX=-4,NameUIOffsetY=-22,InitDispo=20,StaticWeatherID=0,}
local City= {
  [1]={BaseID=1,NameID=1410007,CityIconImage="icon_city_heng2shan1",BigmapPosX=-16,BigmapPosY=42,NameUIOffsetY=-30,EnterMapID=220,NearbyCityIDList={27,21,},DefaultChatIDList={1420016,1420017,},TileID=1,TileImage="city/ev28",},
  [2]={BaseID=2,NameID=1410003,CityIconImage="icon_city_yue4ya2cun1",BigmapPosX=-1,BigmapPosY=-1,NameUIOffsetY=-30,EnterMapID=60,NearbyCityIDList={21,},DefaultChatIDList={1420006,},TileID=2,TileImage="city/ev43",},
  [4]={BaseID=4,NameID=1410000,CityIconImage="icon_city_hei1yue4ya2",BigmapPosX=24,BigmapPosY=52,NameUIOffsetY=-26,EnterMapID=447,NearbyCityIDList={27,9,},DefaultChatIDList={1420000,1420001,},TileID=4,TileImage="city/ev27",},
  [5]={BaseID=5,NameID=1410025,CityIconImage="icon_city_tao2hua1dao3",BigmapPosX=64,BigmapPosY=-18,NameUIOffsetY=-26,EnterMapID=332,NearbyCityIDList={33,37,},DefaultChatIDList={1420051,},TileID=5,TileImage="city/ev37",},
  [7]={BaseID=7,NameID=1410009,CityIconImage="icon_city_wu3dang1shan1",BigmapPosX=-17,BigmapPosY=-19,NameUIOffsetY=-12,EnterMapID=294,NearbyCityIDList={18,11,25,},DefaultChatIDList={1420021,1420022,},TileID=7,TileImage="city/ev40",},
  [9]={BaseID=9,NameID=1410001,CityIconImage="icon_city_tai4shan1",BigmapPosX=18,BigmapPosY=30,NameUIOffsetX=3,NameUIOffsetY=-19,EnterMapID=289,NearbyCityIDList={4,34,21,},DefaultChatIDList={1420002,1420003,},TileID=9,TileImage="city/ev36",},
  [10]={BaseID=10,NameID=1410023,CityIconImage="icon_city_zhong1nan2shan1",BigmapPosX=-72,BigmapPosY=8,EnterMapID=79,NearbyCityIDList={35,31,15,},DefaultChatIDList={1420049,},TileID=10,TileImage="city/ev19",},
  [11]={BaseID=11,NameID=1410010,CityIconImage="icon_city_heng2shan11",BigmapPosX=-34,BigmapPosY=-34,EnterMapID=264,NearbyCityIDList={7,26,},DefaultChatIDList={1420023,1420024,},TileID=11,TileImage="city/ev29",},
  [13]={BaseID=13,NameID=1410002,CityIconImage="icon_city_gu3lou2feng1",BigmapPosX=-94,BigmapPosY=46,NameUIOffsetY=-23,EnterMapID=307,NearbyCityIDList={36,41,},DefaultChatIDList={1420004,1420005,},TileID=13,TileImage="city/ev24",},
  [15]={BaseID=15,NameID=1410018,CityIconImage="icon_city_hua2shan1",BigmapPosX=-48,BigmapPosY=22,NameUIOffsetX=-1,NameUIOffsetY=-26,EnterMapID=93,NearbyCityIDList={36,19,10,17,},DefaultChatIDList={1420039,1420040,},TileID=15,TileImage="city/ev15",},
  [17]={BaseID=17,NameID=1410019,CityIconImage="icon_city_ming2sha1shan1",BigmapPosX=-52,BigmapPosY=-16,EnterMapID=468,NearbyCityIDList={15,18,31,},DefaultChatIDList={1420041,1420042,},TileID=17,TileImage="city/ev34",},
  [18]={BaseID=18,NameID=1410013,CityIconImage="icon_city_e2mei2shan1",BigmapPosX=-36,BigmapPosY=-2,NameUIOffsetX=-2,EnterMapID=284,NearbyCityIDList={19,21,7,17,},DefaultChatIDList={1420029,1420030,},TileID=18,TileImage="city/ev23",},
  [19]={BaseID=19,NameID=1410012,CityIconImage="icon_city_song1shan1",BigmapPosX=-52,BigmapPosY=48,NameUIOffsetX=2,NameUIOffsetY=-12,EnterMapID=300,NearbyCityIDList={15,18,30,},DefaultChatIDList={1420027,1420028,},TileID=19,TileImage="city/ev16",},
  [21]={BaseID=21,NameID=1410008,CityIconImage="icon_city_kai1feng1",BigmapPosX=-17,BigmapPosY=16,NameUIOffsetX=-2,EnterMapID=1334,NearbyCityIDList={9,1,18,2,},DefaultChatIDList={1420018,1420019,1420020,},TileID=21,TileImage="city/ev32",},
  [25]={BaseID=25,NameID=1410004,CityIconImage="icon_city_hang2zhou1",CityInfoIcon="ChainCity/city_5",BigmapPosX=10,BigmapPosY=-22,NameUIOffsetX=-10,NameUIOffsetY=-1,EnterMapID=995,NearbyCityIDList={7,33,},DefaultChatIDList={1420007,1420008,1420009,},TileID=25,TileImage="city/ev26",},
  [26]={BaseID=26,NameID=1410005,CityIconImage="icon_city_guang3zhou1",CityInfoIcon="ChainCity/city_3",BigmapPosX=-13,BigmapPosY=-50,EnterMapID=209,NearbyCityIDList={11,32,40,},DefaultChatIDList={1420010,1420011,1420012,},TileID=26,TileImage="city/ev25",},
  [27]={BaseID=27,NameID=1410006,CityIconImage="icon_city_jing1cheng2",CityInfoIcon="ChainCity/city_2",BigmapPosX=-7,BigmapPosY=64,NameUIOffsetX=11,NameUIOffsetY=-20,EnterMapID=169,NearbyCityIDList={30,1,4,},DefaultChatIDList={1420013,1420014,1420015,},TileID=27,TileImage="city/ev31",},
  [28]={BaseID=28,NameID=1410021,CityIconImage="icon_city_da4li3",CityInfoIcon="ChainCity/city_4",BigmapPosX=-69,BigmapPosY=-56,NameUIOffsetX=6,NameUIOffsetY=-20,EnterMapID=1096,NearbyCityIDList={31,32,43,},ScriptID={2,3,6,7,10,21,22,23,24,25,26,27,},DefaultChatIDList={1420045,1420046,1420047,},TileID=28,TileImage="city/ev21",},
  [30]={BaseID=30,NameID=1410011,CityIconImage="icon_city_wu3tai2shan1",BigmapPosX=-44,BigmapPosY=65,NameUIOffsetX=5,NameUIOffsetY=-7,EnterMapID=458,NearbyCityIDList={27,36,19,41,},DefaultChatIDList={1420025,1420026,},TileID=30,TileImage="city/ev18",},
  [31]={BaseID=31,NameID=1410020,CityIconImage="icon_city_xue3shan1",BigmapPosX=-71,BigmapPosY=-28,NameUIOffsetY=-15,EnterMapID=344,NearbyCityIDList={10,17,39,28,42,},DefaultChatIDList={1420043,1420044,},TileID=31,TileImage="city/ev42",},
  [32]={BaseID=32,NameID=1410014,CityIconImage="icon_city_wu2liang4shan1",BigmapPosX=-42,BigmapPosY=-60,NameUIOffsetY=0,EnterMapID=1124,NearbyCityIDList={28,42,26,},DefaultChatIDList={1420031,1420032,},TileID=32,TileImage="city/ev38",},
  [33]={BaseID=33,NameID=1410015,CityIconImage="icon_city_tai4hu2",BigmapPosX=35,BigmapPosY=-16,NameUIOffsetX=4,EnterMapID=317,NearbyCityIDList={5,25,38,},DefaultChatIDList={1420033,1420034,},TileID=33,TileImage="city/ev35",},
  [34]={BaseID=34,NameID=1410016,CityIconImage="icon_city_bing1huo3dao3",BigmapPosX=48,BigmapPosY=28,NameUIOffsetY=-14,EnterMapID=260,NearbyCityIDList={9,38,},DefaultChatIDList={1420035,1420036,},TileID=34,TileImage="city/ev20",},
  [35]={BaseID=35,NameID=1410022,CityIconImage="icon_city_kun1lun2shan1",BigmapPosX=-92,BigmapPosY=-2,NameUIOffsetY=-24,EnterMapID=271,NearbyCityIDList={36,10,},DefaultChatIDList={1420048,},TileID=35,TileImage="city/ev33",},
  [36]={BaseID=36,NameID=1410017,CityIconImage="icon_city_tian1shan1",BigmapPosX=-78,BigmapPosY=28,EnterMapID=312,NearbyCityIDList={13,35,15,30,41,},DefaultChatIDList={1420037,1420038,},TileID=36,TileImage="city/ev17",},
  [37]={BaseID=37,NameID=1410026,CityIconImage="icon_city_xia2yi4dao3",BigmapPosX=52,BigmapPosY=-36,NameUIOffsetY=-24,EnterMapID=115,NearbyCityIDList={5,40,},DefaultChatIDList={1420052,},TileID=37,TileImage="city/ev41",},
  [38]={BaseID=38,NameID=1410024,CityIconImage="icon_city_jian4zhong3",BigmapPosX=46,BigmapPosY=5,NameUIOffsetY=-30,EnterMapID=462,NearbyCityIDList={34,33,},DefaultChatIDList={1420050,},TileID=38,TileImage="city/ev30",},
  [39]={BaseID=39,NameID=1410027,CityIconImage="icon_city_duan4qing2gu3",BigmapPosX=-94,BigmapPosY=-42,EnterMapID=103,NearbyCityIDList={31,},DefaultChatIDList={1420053,},TileID=39,TileImage="city/ev22",},
  [40]={BaseID=40,NameID=1410028,CityIconImage="icon_city_wu2ming2dao3",BigmapPosX=26,BigmapPosY=-46,NameUIOffsetY=-28,EnterMapID=485,NearbyCityIDList={37,26,},DefaultChatIDList={1420054,},TileID=40,TileImage="city/ev39",},
  [41]={BaseID=41,NameID=1410029,CityIconImage="icon_city_wu2jian1mi4jing4",BigmapPosX=-1,BigmapPosY=-1,NameUIOffsetX=2,NameUIOffsetY=-8,EnterMapID=11,NearbyCityIDList={13,30,36,},ScriptID={7,10,},DefaultChatIDList={1420055,},TileID=41,TileImage="city/ev43",},
  [42]={BaseID=42,NameID=1410021,CityIconImage="icon_city_da4li3",BigmapPosX=-69,BigmapPosY=-56,NameUIOffsetX=25,NameUIOffsetY=-6,EnterMapID=102,NearbyCityIDList={31,32,},ScriptID={1,},DefaultChatIDList={1420045,1420046,1420047,},TileID=28,TileImage="city/ev21",},
  [43]={BaseID=43,NameID=1410030,CityIconImage="icon_city_yu3wen2zhuang1",BigmapPosX=-1,BigmapPosY=-1,NameUIOffsetX=-5,EnterMapID=1987,NearbyCityIDList={28,},ScriptID={10,},TileID=43,TileImage="city/ev43",},
}
for k,v in pairs(City) do
    setmetatable(v, {['__index'] = CityDefault})
end

-- export table: City
return City
