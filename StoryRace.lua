-- Auto generated by TableTool, Copyright ElectronicSoul@2017


local StoryRaceDefault = {BattleRoleCount=8,BattleType=3,}
local StoryRace= {
  [3]={BaseID=3,Name="开封新手村擂台",RandomList={1072,1073,1074,1075,1076,1077,1078,1079,1080,},EMBattle={10001,10002,10003,0,},SaveTag=130028,},
  [4]={BaseID=4,Name="杭州擂台",RandomList={1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,1020,1021,1022,1023,1024,1025,1026,1027,1028,1029,1030,1031,1032,1033,1034,},EMBattle={11003,11002,11001,0,},SaveTag=130034,},
  [5]={BaseID=5,Name="开封出师擂台-丐帮",RandomList={12003,12004,12005,12006,12007,12008,12102,12103,12104,},EMBattle={12001,12002,12101,0,},SaveTag=130038,},
  [6]={BaseID=6,Name="开封出师擂台-峨嵋",RandomList={12002,12004,12005,12006,12007,12008,12101,12103,12104,},EMBattle={12001,12003,12102,0,},SaveTag=130038,},
  [7]={BaseID=7,Name="开封出师擂台-武当",RandomList={12001,12003,12005,12006,12007,12008,12101,12102,12104,},EMBattle={12002,12004,12103,0,},SaveTag=130038,},
  [8]={BaseID=8,Name="开封出师擂台-华山",RandomList={12001,12002,12005,12006,12007,12008,12101,12102,12103,},EMBattle={12003,12004,12104,0,},SaveTag=130038,},
  [9]={BaseID=9,Name="宇文珂大决战-开封",RandomList={12204,12205,12206,12207,12208,12209,12210,12211,},EMBattle={12201,12202,12203,0,},SaveTag=130042,},
  [10]={BaseID=10,Name="宇文珂大决战-大理",RandomList={12304,12305,12306,12307,12308,12309,12310,12311,},EMBattle={12301,12302,12303,0,},SaveTag=130043,},
  [11]={BaseID=11,Name="宇文珂大决战-京城",RandomList={12404,12405,12406,12407,12408,12409,12410,12411,},EMBattle={12401,12402,12403,0,},SaveTag=130044,},
}
for k,v in pairs(StoryRace) do
    setmetatable(v, {['__index'] = StoryRaceDefault})
end

-- export table: StoryRace
return StoryRace