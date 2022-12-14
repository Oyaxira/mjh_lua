-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum RankListAllType
-- enum TBoolean
require("common");


local RankListAllDefault = {NameID=0,RankName=RankListAllType.RLAT_Null,EntryName1="",EntryCount1="",EntryName2="",EntryCount2=0,EntryName3=0,EntryCount3=0,Show=TBoolean.BOOL_NO,nummax=0,Abreast=TBoolean.BOOL_NO,CheatDetect=TBoolean.BOOL_NO,Order=0,FightTitle=0,MinValueLimit=0,}
local RankListAll= {
  [1]={BaseID=1,NameID=530011,RankName=RankListAllType.RLAT_ZuiQiangLiDao,EntryName1="力道",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=11,MinValueLimit=50,},
  [2]={BaseID=2,NameID=530001,RankName=RankListAllType.RLAT_DanZhouMuFenShu,EntryName1="单周目分数",nummax=100,Abreast=TBoolean.BOOL_YES,Order=23,},
  [3]={BaseID=3,NameID=530024,RankName=RankListAllType.RLAT_ZuiQiangLingQiao,EntryName1="灵巧",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=12,MinValueLimit=50,},
  [4]={BaseID=4,NameID=530023,RankName=RankListAllType.RLAT_ZuiQiangNeiJin,EntryName1="内劲",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=13,MinValueLimit=50,},
  [5]={BaseID=5,NameID=530022,RankName=RankListAllType.RLAT_ZuiQiangTiZhi,EntryName1="体质",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=14,MinValueLimit=50,},
  [6]={BaseID=6,NameID=530021,RankName=RankListAllType.RLAT_ZuiQiangJingLi,EntryName1="精力",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=15,MinValueLimit=50,},
  [7]={BaseID=7,NameID=530020,RankName=RankListAllType.RLAT_ZuiQiangWuXing,EntryName1="悟性",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=16,MinValueLimit=50,},
  [8]={BaseID=8,NameID=530026,RankName=RankListAllType.RLAT_YinDingFuHao,EntryName1="累计银锭数",EntryCount1="|2002207",nummax=100,Abreast=TBoolean.BOOL_YES,Order=18,},
  [9]={BaseID=9,NameID=530002,RankName=RankListAllType.RLAT_TongBiFuHao,EntryName1="累计铜币数",EntryCount1="|1001102",nummax=100,Abreast=TBoolean.BOOL_YES,Order=19,MinValueLimit=1000,},
  [10]={BaseID=10,NameID=530010,RankName=RankListAllType.RLAT_ChengJiuDaRen,EntryName1="成就点数",EntryCount1="|2002205",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=2,},
  [13]={BaseID=13,NameID=530019,RankName=RankListAllType.RLAT_JianFaZongShi,EntryName1="剑法精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=3,MinValueLimit=30,},
  [14]={BaseID=14,NameID=530006,RankName=RankListAllType.RLAT_QiJingBaMai,EntryName1="经脉等级",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [15]={BaseID=15,NameID=530018,RankName=RankListAllType.RLAT_DaoFaZongShi,EntryName1="刀法精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=4,MinValueLimit=30,},
  [16]={BaseID=16,NameID=530005,RankName=RankListAllType.RLAT_WuJinTiaoZhan_ZhiYou,EntryName1="最高层数",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=22,},
  [17]={BaseID=17,NameID=530017,RankName=RankListAllType.RLAT_QuanZhangZongShi,EntryName1="拳掌精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=5,MinValueLimit=30,},
  [18]={BaseID=18,NameID=530004,RankName=RankListAllType.RLAT_WuJinTiaoZhan_ZuDui,EntryName1="最高层数",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=21,},
  [19]={BaseID=19,NameID=530003,RankName=RankListAllType.RLAT_WuJinTiaoZhan_ShengMingZhi,EntryName1="最高层数",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=20,},
  [20]={BaseID=20,NameID=530025,RankName=RankListAllType.RLAT_WuJianMiJing,EntryName1="层数",EntryName2="时间",nummax=100,Abreast=TBoolean.BOOL_YES,Order=17,},
  [21]={BaseID=21,NameID=530016,RankName=RankListAllType.RLAT_TuiFaZongShi,EntryName1="腿法精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=6,MinValueLimit=30,},
  [22]={BaseID=22,NameID=530015,RankName=RankListAllType.RLAT_QiMenZongShi,EntryName1="奇门精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=7,MinValueLimit=30,},
  [23]={BaseID=23,NameID=530014,RankName=RankListAllType.RLAT_AnQiZongShi,EntryName1="暗器精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=8,MinValueLimit=30,},
  [24]={BaseID=24,NameID=530013,RankName=RankListAllType.RLAT_YiShuZongShi,EntryName1="医术精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=9,MinValueLimit=30,},
  [25]={BaseID=25,NameID=530012,RankName=RankListAllType.RLAT_NeiGongZongShi,EntryName1="内功精通",Show=TBoolean.BOOL_YES,nummax=100,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=10,MinValueLimit=30,},
  [26]={BaseID=26,NameID=530009,RankName=RankListAllType.RLAT_YouXiShiChang,EntryName1="在线时长",EntryCount1="|2002203",nummax=100,Abreast=TBoolean.BOOL_YES,Order=26,},
  [27]={BaseID=27,NameID=530027,RankName=RankListAllType.RLAT_DaShang,EntryName1="打赏",nummax=100,Abreast=TBoolean.BOOL_YES,Order=27,},
  [101]={BaseID=101,NameID=532101,RankName=RankListAllType.RLAT_GBShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [102]={BaseID=102,NameID=532102,RankName=RankListAllType.RLAT_CSMShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [103]={BaseID=103,NameID=532103,RankName=RankListAllType.RLAT_WDPShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [104]={BaseID=104,NameID=532104,RankName=RankListAllType.RLAT_CDMShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [105]={BaseID=105,NameID=532105,RankName=RankListAllType.RLAT_SLSShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [106]={BaseID=106,NameID=532106,RankName=RankListAllType.RLAT_EMPShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [107]={BaseID=107,NameID=532107,RankName=RankListAllType.RLAT_WYZShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [108]={BaseID=108,NameID=532108,RankName=RankListAllType.RLAT_TYJShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [109]={BaseID=109,NameID=532109,RankName=RankListAllType.RLAT_LSMShengWang,EntryName1="声望",Show=TBoolean.BOOL_YES,nummax=50,Abreast=TBoolean.BOOL_YES,CheatDetect=TBoolean.BOOL_YES,Order=1,},
  [157]={BaseID=157,NameID=530008,RankName=RankListAllType.RLAT_DanRenLeiTaiSai,nummax=100,Abreast=TBoolean.BOOL_YES,Order=25,},
  [158]={BaseID=158,NameID=530007,RankName=RankListAllType.RLAT_DuiWuLeiTaiSai,nummax=100,Abreast=TBoolean.BOOL_YES,Order=24,},
  [1001]={BaseID=1001,},
  [1002]={BaseID=1002,},
  [1003]={BaseID=1003,},
  [1004]={BaseID=1004,},
  [1005]={BaseID=1005,},
  [1006]={BaseID=1006,},
  [1007]={BaseID=1007,},
  [1008]={BaseID=1008,},
  [1009]={BaseID=1009,},
  [1010]={BaseID=1010,},
  [1011]={BaseID=1011,},
  [1012]={BaseID=1012,},
  [1013]={BaseID=1013,},
  [1014]={BaseID=1014,},
  [1015]={BaseID=1015,},
  [1016]={BaseID=1016,},
  [1017]={BaseID=1017,},
  [1018]={BaseID=1018,},
  [1019]={BaseID=1019,},
  [1020]={BaseID=1020,},
  [1021]={BaseID=1021,},
  [1022]={BaseID=1022,},
  [1023]={BaseID=1023,},
  [1024]={BaseID=1024,},
  [1025]={BaseID=1025,},
  [1026]={BaseID=1026,},
  [1027]={BaseID=1027,},
  [1028]={BaseID=1028,},
  [1029]={BaseID=1029,},
  [1030]={BaseID=1030,},
  [1031]={BaseID=1031,},
  [1032]={BaseID=1032,},
  [1033]={BaseID=1033,},
  [1034]={BaseID=1034,},
  [1035]={BaseID=1035,},
  [1036]={BaseID=1036,},
  [1037]={BaseID=1037,},
  [1038]={BaseID=1038,},
  [1039]={BaseID=1039,},
  [1040]={BaseID=1040,},
  [1041]={BaseID=1041,},
  [1042]={BaseID=1042,},
  [1043]={BaseID=1043,},
  [1044]={BaseID=1044,},
  [1045]={BaseID=1045,},
  [1046]={BaseID=1046,},
  [1047]={BaseID=1047,},
  [1048]={BaseID=1048,},
  [1049]={BaseID=1049,},
  [1050]={BaseID=1050,},
  [1051]={BaseID=1051,},
  [1052]={BaseID=1052,},
  [1053]={BaseID=1053,},
  [1054]={BaseID=1054,},
  [1055]={BaseID=1055,},
  [1056]={BaseID=1056,},
  [1057]={BaseID=1057,},
  [1058]={BaseID=1058,},
  [1059]={BaseID=1059,},
  [1060]={BaseID=1060,},
  [1061]={BaseID=1061,},
  [1062]={BaseID=1062,},
  [1063]={BaseID=1063,},
  [1064]={BaseID=1064,},
  [1065]={BaseID=1065,},
  [1066]={BaseID=1066,},
  [1067]={BaseID=1067,},
  [1068]={BaseID=1068,},
  [1069]={BaseID=1069,},
  [1070]={BaseID=1070,},
  [1071]={BaseID=1071,},
  [1072]={BaseID=1072,},
  [1073]={BaseID=1073,},
  [1074]={BaseID=1074,},
  [1075]={BaseID=1075,},
  [1076]={BaseID=1076,},
  [1077]={BaseID=1077,},
  [1078]={BaseID=1078,},
  [1079]={BaseID=1079,},
  [1080]={BaseID=1080,},
  [1081]={BaseID=1081,},
  [1082]={BaseID=1082,},
  [1083]={BaseID=1083,},
  [1084]={BaseID=1084,},
  [1085]={BaseID=1085,},
  [1086]={BaseID=1086,},
  [1087]={BaseID=1087,},
  [1088]={BaseID=1088,},
  [1089]={BaseID=1089,},
  [1090]={BaseID=1090,},
  [1091]={BaseID=1091,},
  [1092]={BaseID=1092,},
  [1093]={BaseID=1093,},
  [1094]={BaseID=1094,},
  [1095]={BaseID=1095,},
  [1096]={BaseID=1096,},
  [1097]={BaseID=1097,},
  [1098]={BaseID=1098,},
  [1099]={BaseID=1099,},
  [1100]={BaseID=1100,},
  [1101]={BaseID=1101,},
  [1102]={BaseID=1102,},
  [1103]={BaseID=1103,},
  [1104]={BaseID=1104,},
  [1105]={BaseID=1105,},
  [1106]={BaseID=1106,},
  [1107]={BaseID=1107,},
  [1108]={BaseID=1108,},
  [1109]={BaseID=1109,},
  [1110]={BaseID=1110,},
  [1111]={BaseID=1111,},
  [1112]={BaseID=1112,},
  [1113]={BaseID=1113,},
  [1114]={BaseID=1114,},
  [1115]={BaseID=1115,},
  [1116]={BaseID=1116,},
  [1117]={BaseID=1117,},
  [1118]={BaseID=1118,},
  [1119]={BaseID=1119,},
  [1120]={BaseID=1120,},
  [1121]={BaseID=1121,},
  [1122]={BaseID=1122,},
  [1123]={BaseID=1123,},
  [1124]={BaseID=1124,},
  [1125]={BaseID=1125,},
  [1126]={BaseID=1126,},
  [1127]={BaseID=1127,},
  [1128]={BaseID=1128,},
  [1129]={BaseID=1129,},
  [1130]={BaseID=1130,},
  [1131]={BaseID=1131,},
  [1132]={BaseID=1132,},
  [1133]={BaseID=1133,},
  [1134]={BaseID=1134,},
  [1135]={BaseID=1135,},
  [1136]={BaseID=1136,},
  [1137]={BaseID=1137,},
  [1138]={BaseID=1138,},
  [1139]={BaseID=1139,},
  [1140]={BaseID=1140,},
  [1141]={BaseID=1141,},
  [1142]={BaseID=1142,},
  [1143]={BaseID=1143,},
  [1144]={BaseID=1144,},
  [1145]={BaseID=1145,},
  [1146]={BaseID=1146,},
  [1147]={BaseID=1147,},
  [1148]={BaseID=1148,},
  [1149]={BaseID=1149,},
  [1150]={BaseID=1150,},
  [1151]={BaseID=1151,},
  [1152]={BaseID=1152,},
  [1153]={BaseID=1153,},
  [1154]={BaseID=1154,},
  [1155]={BaseID=1155,},
  [1156]={BaseID=1156,},
  [1157]={BaseID=1157,},
  [1158]={BaseID=1158,},
  [1159]={BaseID=1159,},
  [1160]={BaseID=1160,},
  [1161]={BaseID=1161,},
  [1162]={BaseID=1162,},
  [1163]={BaseID=1163,},
  [1164]={BaseID=1164,},
  [1165]={BaseID=1165,},
  [1166]={BaseID=1166,},
  [1167]={BaseID=1167,},
  [1168]={BaseID=1168,},
  [1169]={BaseID=1169,},
  [1170]={BaseID=1170,},
  [1171]={BaseID=1171,},
  [1172]={BaseID=1172,},
  [1173]={BaseID=1173,},
  [1174]={BaseID=1174,},
  [1175]={BaseID=1175,},
  [1176]={BaseID=1176,},
  [1177]={BaseID=1177,},
  [1178]={BaseID=1178,},
  [1179]={BaseID=1179,},
  [1180]={BaseID=1180,},
  [1181]={BaseID=1181,},
  [1182]={BaseID=1182,},
  [1183]={BaseID=1183,},
  [1184]={BaseID=1184,},
  [1185]={BaseID=1185,},
  [1186]={BaseID=1186,},
  [1187]={BaseID=1187,},
  [1188]={BaseID=1188,},
  [1189]={BaseID=1189,},
  [1190]={BaseID=1190,},
  [1191]={BaseID=1191,},
  [1192]={BaseID=1192,},
  [1193]={BaseID=1193,},
  [1194]={BaseID=1194,},
  [1195]={BaseID=1195,},
  [1196]={BaseID=1196,},
  [1197]={BaseID=1197,},
}
for k,v in pairs(RankListAll) do
    setmetatable(v, {['__index'] = RankListAllDefault})
end

-- export table: RankListAll
return RankListAll
