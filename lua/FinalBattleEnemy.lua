-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum TBoolean
require("common");


local FinalBattleEnemyDefault = {NameID=3720065,Role=1000026053,IsCaptain=TBoolean.BOOL_NO,JoinCondition=0,Battle=0,MazeAreaIndex=1,EvilHiddenRole=0,}
local FinalBattleEnemy= {
  [101]={BaseID=101,NameID=3720030,Role=1000026029,Battle=1183,},
  [102]={BaseID=102,NameID=3720031,Role=1000026028,Battle=1184,MazeAreaIndex=2,},
  [103]={BaseID=103,NameID=3720032,Role=1000026027,Battle=1185,MazeAreaIndex=3,},
  [104]={BaseID=104,NameID=3720033,Role=1000012021,IsCaptain=TBoolean.BOOL_YES,MazeAreaIndex=4,},
  [111]={BaseID=111,NameID=3720050,Role=1100301001,Battle=350,},
  [112]={BaseID=112,NameID=3720051,Role=1270301001,Battle=326,MazeAreaIndex=2,},
  [113]={BaseID=113,NameID=3720052,Role=1210314002,IsCaptain=TBoolean.BOOL_YES,Battle=341,MazeAreaIndex=3,},
  [114]={BaseID=114,MazeAreaIndex=4,EvilHiddenRole=1000012021,},
  [201]={BaseID=201,NameID=3720034,Role=1000026050,Battle=1193,},
  [202]={BaseID=202,NameID=3720035,Role=1000026049,Battle=1192,MazeAreaIndex=2,},
  [203]={BaseID=203,NameID=3720036,Role=1000026048,Battle=1187,MazeAreaIndex=3,},
  [204]={BaseID=204,NameID=3720037,Role=1000012018,IsCaptain=TBoolean.BOOL_YES,MazeAreaIndex=4,},
  [211]={BaseID=211,NameID=3720053,Role=1080314001,Battle=356,},
  [212]={BaseID=212,NameID=3720055,Role=1030101017,Battle=323,MazeAreaIndex=2,},
  [213]={BaseID=213,NameID=3720054,Role=1150301016,IsCaptain=TBoolean.BOOL_YES,Battle=332,MazeAreaIndex=3,},
  [214]={BaseID=214,MazeAreaIndex=4,EvilHiddenRole=1000012018,},
  [301]={BaseID=301,NameID=3720038,Role=1000026023,Battle=1198,},
  [302]={BaseID=302,NameID=3720039,Role=1000026022,Battle=1197,MazeAreaIndex=2,},
  [303]={BaseID=303,NameID=3720040,Role=1000026021,Battle=1195,MazeAreaIndex=3,},
  [304]={BaseID=304,NameID=3720041,Role=1000012014,IsCaptain=TBoolean.BOOL_YES,MazeAreaIndex=4,},
  [311]={BaseID=311,NameID=3720056,Role=1250301002,Battle=344,},
  [312]={BaseID=312,NameID=3720057,Role=1150301022,Battle=83,MazeAreaIndex=2,},
  [313]={BaseID=313,NameID=3720058,Role=1140314003,IsCaptain=TBoolean.BOOL_YES,Battle=329,MazeAreaIndex=3,},
  [314]={BaseID=314,MazeAreaIndex=4,EvilHiddenRole=1000012014,},
  [401]={BaseID=401,NameID=3720042,Role=1000026003,Battle=1205,},
  [402]={BaseID=402,NameID=3720043,Role=1000026002,Battle=1207,MazeAreaIndex=2,},
  [403]={BaseID=403,NameID=3720044,Role=1000026001,Battle=1208,MazeAreaIndex=3,},
  [404]={BaseID=404,NameID=3720045,Role=1000012019,IsCaptain=TBoolean.BOOL_YES,MazeAreaIndex=4,},
  [411]={BaseID=411,NameID=3720059,Role=1160301004,Battle=359,},
  [412]={BaseID=412,NameID=3720060,Role=1290301002,Battle=1694,MazeAreaIndex=2,},
  [413]={BaseID=413,NameID=3720061,Role=1230301003,IsCaptain=TBoolean.BOOL_YES,Battle=353,MazeAreaIndex=3,},
  [414]={BaseID=414,MazeAreaIndex=4,EvilHiddenRole=1000012019,},
  [501]={BaseID=501,NameID=3720046,Role=1000026017,Battle=1217,},
  [502]={BaseID=502,NameID=3720047,Role=1000026016,Battle=1218,MazeAreaIndex=2,},
  [503]={BaseID=503,NameID=3720048,Role=1000026015,Battle=1222,MazeAreaIndex=3,},
  [504]={BaseID=504,NameID=3720049,Role=1140201002,IsCaptain=TBoolean.BOOL_YES,MazeAreaIndex=4,},
  [511]={BaseID=511,NameID=3720063,Role=1170301005,Battle=338,},
  [512]={BaseID=512,NameID=3720064,Role=1090325010,Battle=79,MazeAreaIndex=2,},
  [513]={BaseID=513,NameID=3720062,Role=1120301004,IsCaptain=TBoolean.BOOL_YES,Battle=335,MazeAreaIndex=3,},
  [514]={BaseID=514,MazeAreaIndex=4,EvilHiddenRole=1140201002,},
}
for k,v in pairs(FinalBattleEnemy) do
    setmetatable(v, {['__index'] = FinalBattleEnemyDefault})
end

-- export table: FinalBattleEnemy
return FinalBattleEnemy