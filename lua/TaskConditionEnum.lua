-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum ConditionType
require("common");


local TaskConditionEnumDefault = {CondFlag="",CondArg1Type="RoleTemplate",CondArg1Name="",CondArg2Type="",CondArg2Name="",CondArg3Type="",CondArg3Name="",CondArg4Type="",CondArg4Name="",CondArg5Type="",CondArg5Name="",CondArg6Type="",CondArg6Name="",CondArg7Type="",CondArg7Name="",CondArg8Type="",CondArg8Name="",}
local TaskConditionEnum= {
  [1]={BaseID=1,CondName=ConditionType.CT_AND,CondArg1Type="",},
  [2]={BaseID=2,CondName=ConditionType.CT_TAG_CMP,CondArg1Type="TaskTag",CondArg1Name="0标记",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",},
  [3]={BaseID=3,CondName=ConditionType.CT_ITEM_COUNT_CMP,CondArg1Type="Item",CondArg1Name="0物品",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",CondArg4Type="TBoolean",CondArg4Name="3包含装备",CondArg5Type="string",CondArg5Name="4物品类别数组枚举",CondArg6Type="string",CondArg6Name="5礼物类型数组枚举",CondArg7Type="RankType",CondArg7Name="6最低品质",CondArg8Type="RankType",CondArg8Name="7最高品质",},
  [4]={BaseID=4,CondName=ConditionType.CT_JUE_SE_HAO_GAN_DU_BI_JIAO,CondArg1Name="3填MAINROLE",CondArg2Type="RoleTemplate",CondArg2Name="0角色",CondArg3Type="CompareSignType",CondArg3Name="1比较方式",CondArg4Type="int32",CondArg4Name="2比较值",},
  [5]={BaseID=5,CondName=ConditionType.CT_ROLR_ATTR_CMP,CondArg1Type="AttrType",CondArg1Name="0属性",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",CondArg4Type="RoleTemplate",CondArg4Name="3角色",},
  [6]={BaseID=6,CondName=ConditionType.CT_NOT,CondArg1Type="",},
  [7]={BaseID=7,CondName=ConditionType.CT_HAS_TEAMMATE,CondArg1Name="0角色",},
  [8]={BaseID=8,CondName=ConditionType.CT_OR,CondArg1Type="",},
  [9]={BaseID=9,CondName=ConditionType.CT_ROLE_CLAN_CMP,CondArg1Name="0角色",CondArg2Type="Clan",CondArg2Name="1门派",CondArg3Type="ClanType",CondArg3Name="2门派分类",},
  [10]={BaseID=10,CondName=ConditionType.CT_HAS_KUNGFU,CondArg1Name="0角色",CondArg2Type="Martial",CondArg2Name="1武学",CondArg3Type="int32",CondArg3Name="2等级",},
  [11]={BaseID=11,CondName=ConditionType.CT_SHI_CHANG_XIANG_ZHU_JUE,CondArg1Name="0角色",},
  [12]={BaseID=12,CondName=ConditionType.CT_MEN_PAI_HAO_GAN_DU_BI_JIAO,CondArg1Type="Clan",CondArg1Name="0门派",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",},
  [13]={BaseID=13,CondName=ConditionType.CT_SHI_FOU_BEI_TU_SHA,CondArg1Name="0角色",},
  [14]={BaseID=14,CondName=ConditionType.CT_BATTLE_RESULT_CMP,CondArg1Type="string",CondArg1Name="comp",CondArg2Type="BattleResult",CondArg2Name="战斗结果状态枚举",},
  [15]={BaseID=15,CondName=ConditionType.CT_DA_JUE_ZHAN_JU_DIAN_ZHUANG_TAI_PAN_DUAN,CondArg1Type="FinalBattleCity",CondArg1Name="1据点ID",CondArg2Type="FinalBattleCityState",CondArg2Name="2大决战结果状态枚举",},
  [16]={BaseID=16,CondName=ConditionType.CT_WEATHER_CMP,CondArg1Type="City",CondArg1Name="0据点ID",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="Weather",CondArg3Name="2天气ID",},
  [17]={BaseID=17,CondName=ConditionType.CT_IS_IN_MAZE,CondArg1Type="Maze",CondArg1Name="0迷宫ID",},
  [18]={BaseID=18,CondName=ConditionType.CT_FALSE,CondArg1Type="",},
  [19]={BaseID=19,CondName=ConditionType.CT_JIANG_HU_SHI_JIAN_BI_JIAO,CondArg1Type="CompareSignType",CondArg1Name="comp",CondArg2Type="int32",CondArg2Name="年",CondArg3Type="int32",CondArg3Name="月",CondArg4Type="int32",CondArg4Name="日",CondArg5Type="int32",CondArg5Name="刻",},
  [20]={BaseID=20,CondName=ConditionType.CT_ROLE_POSITION_CMP,CondArg1Name="角色ID",CondArg2Type="Map",CondArg2Name="地图ID",},
  [21]={BaseID=21,CondName=ConditionType.CT_TRUE,CondArg1Type="",},
  [22]={BaseID=22,CondName=ConditionType.CT_SHI_FOU_WEI_CHANG_XIANG_MO_SHI,CondArg1Type="",},
  [23]={BaseID=23,CondName=ConditionType.CT_ROLE_DATA_CMP,CondArg1Name="0角色ID",CondArg2Type="GameData",CondArg2Name="1属性类型枚举",CondArg3Type="CompareSignType",CondArg3Name="2比较方式",CondArg4Type="int32",CondArg4Name="3数值",},
  [24]={BaseID=24,CondName=ConditionType.CT_PLAYER_DATA_CMP,CondArg1Type="MainRoleTemplateData",CondArg1Name="属性类型枚举",CondArg2Type="CompareSignType",CondArg2Name="比较方式",CondArg3Type="int32",CondArg3Name="数值",},
  [25]={BaseID=25,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_jiao3se4shi4fou3man3zu2hai2zi3bai4shi1tiao2jian4,CondArg1Name="角色ID",},
  [26]={BaseID=26,CondName=ConditionType.CT_BASEID_COMP,CondArg1Type="type_Equal",CondArg2Type="any",CondArg2Name="数据A",CondArg3Type="any",CondArg3Name="数据B",},
  [27]={BaseID=27,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_shu4zhi2bi3jiao4,CondArg1Type="int",CondArg1Name="0数值1",CondArg2Type="string",CondArg2Name="1比较方式",CondArg3Type="int",CondArg3Name="2数值2",},
  [28]={BaseID=28,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_sui2ji1gai4lv4,CondArg1Type="int",CondArg1Name="0概率",},
  [29]={BaseID=29,CondName=ConditionType.CT_auto_luo2ji2yun4suan4_shu4zhi2bi3jiao4,CondArg1Type="estrcmop",CondArg1Name="比较符号",CondArg2Type="int",CondArg2Name="数值1",CondArg3Type="int",CondArg3Name="数值2",},
  [30]={BaseID=30,CondName=ConditionType.CT_auto_dao4ju4_zhu3jiao3yong1you3dao4ju4,CondArg1Type="Item",CondArg1Name="物品ID",CondArg2Type="TBoolean",CondArg2Name="包括装备道具",},
  [31]={BaseID=31,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_dui4wu3zhong1shi4fou3yong1you3wu3xue2,CondArg1Type="Martial",CondArg1Name="武学ID",CondArg2Type="int",CondArg2Name="武学等级",},
  [32]={BaseID=32,CondName=ConditionType.CT_auto_wu4pin3pan4duan4_yu3,CondArg1Type="Item",CondArg1Name="待判断物品ID",CondArg2Type="fargboolean",CondArg2Name="条件列表",},
  [33]={BaseID=33,CondName=ConditionType.CT_auto_tong1yong4ren4wu4pan4duan4_jie2ju2_tiao4zhuai3dao4jie2ju2,CondArg1Type="int",CondArg1Name="目标结局序号",},
  [34]={BaseID=34,CondName=ConditionType.CT_auto_luo2ji2yun4suan4_deng3yu2,CondArg1Type="type_Equal",CondArg2Type="any",CondArg2Name="条目1",CondArg3Type="any",CondArg3Name="条目2",},
  [35]={BaseID=35,CondName=ConditionType.CT_auto_ren4wu4shu4ju4xiu1gai3_gai4bang1_lu3chang2lao3de0kao3yan4_kao3yan4zhuangtai4,CondArg1Type="int",CondArg1Name="考验内容",},
  [36]={BaseID=36,CondName=ConditionType.CT_auto_wei4yun4suan4_yu3,CondArg1Type="int",CondArg1Name="数值1",CondArg2Type="int",CondArg2Name="数值2",},
  [37]={BaseID=37,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_te4ding4men2pai4dui4you3,CondArg1Type="Clan",CondArg1Name="门派ID",CondArg2Type="TBoolean",CondArg2Name="包含主角",CondArg3Type="ClanType",CondArg3Name="门派阵营",},
  [38]={BaseID=38,CondName=ConditionType.CT_auto_you2xi4wan2fa3luo2ji2_kai1feng1_lu4yao2bai3bao3xiang1_tiao2jian4,CondArg1Type="string",CondArg1Name="param",},
  [39]={BaseID=39,CondName=ConditionType.CT_auto_wu4pin3pan4duan4_te4ding4wu4pin3,CondArg1Type="Item",CondArg1Name="待判断物品ID",CondArg2Type="Item[]",CondArg2Name="物品列表ID",},
  [40]={BaseID=40,CondName=ConditionType.CT_auto_wu4pin3pan4duan4_te4ding4li3wu4lei4xing2,CondArg1Type="Item",CondArg1Name="待判断物品ID",CondArg2Type="estr_gift_type[]",CondArg2Name="类型列表",},
  [41]={BaseID=41,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_ren4wu4shi4fou3kai1qi3,CondArg1Type="Task",CondArg1Name="任务ID",},
  [42]={BaseID=42,CondName=ConditionType.CT_auto_pan4duan4_jiao3se4shi4fou3zai4dui4wu3zhong1da2kai1jiao1hu4jie4mian4,CondArg1Type="",},
  [43]={BaseID=43,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_da4jue2zhan4jie2guo3pan4duan4,CondArg1Type="int",CondArg1Name="1普通/2全胜/3失败",},
  [44]={BaseID=44,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_shi4fou3cun2zai4shi4yue1jie2yi4guan1xi4,CondArg1Type="estr_marry_type",CondArg1Name="类型",CondArg2Type="RoleTemplate",CondArg2Name="A角色ID",CondArg3Type="RoleTemplate",CondArg3Name="B角色ID",},
  [45]={BaseID=45,CondName=ConditionType.CT_auto_condition_si4miao4wan2fa3_huo4qu3si4miao4jiao1hu4tiao2jian4,CondArg1Type="int",CondArg1Name="index",},
  [46]={BaseID=46,CondName=ConditionType.CT_auto_yi4rong2mian4ju4_zhong3lei4pan4duan4,CondArg1Name="角色ID",CondArg2Type="disguise",CondArg2Name="种类",},
  [47]={BaseID=47,CondName=ConditionType.CT_auto_shi4jie4_cheng2shi4shi4fou3jie3suo3,CondArg1Type="City",CondArg1Name="城市ID",},
  [48]={BaseID=48,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_shi4fou3zheng1fu2guo4men2pai4,CondArg1Type="Clan",CondArg1Name="门派ID",},
  [49]={BaseID=49,CondName=ConditionType.CT_auto_shang1dian4_pan4duan4shang1dian4shi4fou3shou4qing4,CondArg1Type="Businessman",CondArg1Name="商店ID",CondArg2Type="TBoolean",CondArg2Name="包括补货",},
  [50]={BaseID=50,CondName=ConditionType.CT_auto_xin1yuan4ren4wu4xun2wu4tan4bao3_zhu3jiao3shi4fou3yong1you3dao4ju4pan4duan4,CondArg1Type="",},
  [51]={BaseID=51,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_shi4fou3shi4hai2zi3,CondArg1Name="角色ID",},
  [52]={BaseID=52,CondName=ConditionType.CT_auto_zhang4hao4_pan4duan4zhang4hao4shou3ci4jin4hang2hang2wei2,CondArg1Type="string",CondArg1Name="行为",},
  [53]={BaseID=53,CondName=ConditionType.CT_auto_luo2ji2yun4suan4_bu4wei2kong1,CondArg1Type="farg",CondArg1Name="数据",},
  [54]={BaseID=54,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_ju4ben3pan4duan4,CondArg1Type="Story",CondArg1Name="0剧本",},
  [55]={BaseID=55,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_jiao3se4wu3xue2de0pin3zhi4xi4bie2pan4duan4,CondArg1Name="0角色ID",CondArg2Type="RankType",CondArg2Name="1品质",CondArg3Type="DepartEnumType",CondArg3Name="2系别",CondArg4Type="int",CondArg4Name="3数量",},
  [56]={BaseID=56,CondName=ConditionType.CT_auto_ju4ben3_ju4ben3wan2cheng2zhi4shao3yi1ci4,CondArg1Type="Story",CondArg1Name="剧本ID",},
  [57]={BaseID=57,CondName=ConditionType.CT_auto_xin1yuan4ren4wu4_xin1mo2tiao1zhan4fen1zhi1,CondArg1Type="Task",CondArg1Name="任务ID",},
  [58]={BaseID=58,CondName=ConditionType.CT_auto_cheng2jiu4_shi4fou3wan2cheng2,CondArg1Type="Achieve",CondArg1Name="成就ID",},
  [59]={BaseID=59,CondName=ConditionType.CT_auto_wu4pin3pan4duan4_te4ding4lei4xing2,CondArg1Type="Item",CondArg1Name="待判断物品ID",CondArg2Type="ItemType[]",CondArg2Name="类型列表",},
  [60]={BaseID=60,CondName=ConditionType.CT_auto_jiao3se4_shi4fou3wan2cheng2suo3you3ke3ji4cheng2xin1yuan4ren4wu4,CondArg1Name="角色ID",},
  [61]={BaseID=61,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_shi4fou3cun2zai4shi4yue1jie2yi4dui4xiang4,CondArg1Type="estr_marry_type",CondArg1Name="类型",CondArg2Type="RoleTemplate",CondArg2Name="主角色ID",CondArg3Type="RoleTemplate",CondArg3Name="结义对象ID",},
  [62]={BaseID=62,CondName=ConditionType.CT_auto_condition_hao3gan3tu1po4_ju4qing2tiao2jian4_men2pai4hao3gan3du4bi3jiao4,CondArg1Type="estrcmop",CondArg1Name="比较方式",CondArg2Type="int",CondArg2Name="数值",},
  [63]={BaseID=63,CondName=ConditionType.CT_auto_shi4jie4_cheng2shi4shi4fou3you3dian3ji1ju4qing2,CondArg1Type="City",CondArg1Name="城市ID",},
  [64]={BaseID=64,CondName=ConditionType.CT_auto_shi4jie4_cheng2shi4shi4fou3you3jie3suo3ju4qing2,CondArg1Type="City",CondArg1Name="城市ID",},
  [65]={BaseID=65,CondName=ConditionType.CT_auto_ren4wu4shu4ju4xiu1gai3_gai4bang1_xue2yi4deng3dai1yi1ge4yue4_dang1qian2shi4fou3zai4gai4bang1,CondArg1Type="",},
  [66]={BaseID=66,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_jiao3se4neng2fou3geng4huan4ti4bu3,CondArg1Type="Task",CondArg1Name="任务ID",CondArg2Type="RoleTemplate",CondArg2Name="角色ID",},
  [67]={BaseID=67,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_jiao3se4men2pai4shi4fou3wei2shao3lin2si4,CondArg1Name="角色ID",},
  [68]={BaseID=68,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_mao4xian3tian1fu4pan4duan4,CondArg1Type="estr_adv_gift",CondArg1Name="天赋类型",CondArg2Type="int",CondArg2Name="等级",},
  [69]={BaseID=69,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_jiao3se4shi4fou3yong1you3tian1fu4,CondArg1Name="角色ID",CondArg2Type="Skill",CondArg2Name="天赋ID",},
  [70]={BaseID=70,CondName=ConditionType.CT_auto_xin1yuan4ren4wu4_tiao2jian4_zhu3jiao3yong1you3fu2he2dao4ju4shu4liang4,CondArg1Type="Task",CondArg1Name="任务ID",CondArg2Type="estrclass_rank[]",CondArg2Name="品质列表",CondArg3Type="int",CondArg3Name="数值",},
  [71]={BaseID=71,CondName=ConditionType.CT_auto_ri4xian4ding4cao1zuo4cha2xun2,CondArg1Type="DailyLimitActType",CondArg1Name="日限定操作类型",},
  [72]={BaseID=72,CondName=ConditionType.CT_auto_yi4rong2mian4ju4_men2pai4pan4duan4,CondArg1Name="角色ID",CondArg2Type="Clan",CondArg2Name="门派ID",},
  [73]={BaseID=73,CondName=ConditionType.CT_auto_wu4pin3pan4duan4_te4ding4pin3zhi4,CondArg1Type="Item",CondArg1Name="待判断物品ID",CondArg2Type="estrclass_rank[]",CondArg2Name="品质列表",},
  [74]={BaseID=74,CondName=ConditionType.CT_auto_jiao3se4_yong1you3wu3xue2,CondArg1Name="角色ID",CondArg2Type="Martial",CondArg2Name="武学ID",},
  [75]={BaseID=75,CondName=ConditionType.CT_auto_jiao3se4_shi4fou3shi4zhi3ding4shen1fen4,CondArg1Name="0角色ID",CondArg2Type="StatusType",CondArg2Name="1身份",},
  [76]={BaseID=76,CondName=ConditionType.CT_auto_jiao3se4_shi4fou3shi4fu4zi3guan1xi4,CondArg1Name="A角色ID",CondArg2Type="RoleTemplate",CondArg2Name="B角色ID",},
  [77]={BaseID=77,CondName=ConditionType.CT_auto_jiao3se4_wu3xue2shu4liang4shi4fou3da2dao4shang4xian4,CondArg1Name="0角色ID",},
  [78]={BaseID=78,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_fu1qi1shi4fou3cun2zai4dai1chu1sheng1hai2zi3,CondArg1Name="A角色ID",CondArg2Type="RoleTemplate",CondArg2Name="B角色ID",},
  [79]={BaseID=79,CondName=ConditionType.CT_auto_zhang4hao4_zhou1mu4jiang3li4tiao2mu4shi4fou3jie3suo3,CondArg1Type="AchieveReward",CondArg1Name="周目奖励ID",},
  [80]={BaseID=80,CondName=ConditionType.CT_auto_luo2ji2ren4wu4_huo4qu3cun2chu3xin4xi1_bu4er3zhi2,CondArg1Type="Task",CondArg1Name="任务ID",CondArg2Type="string",CondArg2Name="key",},
  [81]={BaseID=81,CondName=ConditionType.CT_auto_luo2ji2yun4suan4_zi4fu2chuan4deng3yu2,CondArg1Type="type_Equal",CondArg2Type="string",CondArg2Name="条目1",CondArg3Type="string",CondArg3Name="条目2",},
  [82]={BaseID=82,CondName=ConditionType.CT_auto_dao4ju4_pan4duan4jiao3se4shi4fou3chuan1dai4,CondArg1Name="角色ID",CondArg2Type="string",CondArg2Name="部位",CondArg3Type="Rank",CondArg3Name="品质ID",},
  [83]={BaseID=83,CondName=ConditionType.CT_auto_dao4ju4_yong1you3dao4ju4,CondArg1Name="角色ID",CondArg2Type="Item",CondArg2Name="道具ID",CondArg3Type="TBoolean",CondArg3Name="包括装备道具",CondArg4Type="TBoolean",CondArg4Name="判断模板",},
  [84]={BaseID=84,CondName=ConditionType.CT_auto_jiu3guan3_chu1shi3yin3dao3shi4fou3wan2cheng2,CondArg1Type="",},
  [85]={BaseID=85,CondName=ConditionType.CT_auto_condition_zhu3cheng2guan1fu3_deng3dai1xuan2shang3wan2cheng2_wu2dong4tai4ren4wu4jin4hang2zhong1,CondArg1Type="",},
  [86]={BaseID=86,CondName=ConditionType.CT_auto_condition_hao3gan3tu1po4_ju4qing2tiao2jian4_jiao3se4hao3gan3du4bi3jiao4,CondArg1Type="estrcmop",CondArg1Name="比较方式",CondArg2Type="int",CondArg2Name="数值",},
  [87]={BaseID=87,CondName=ConditionType.CT_auto_condition_si4miao4wan2fa3_cun2zai4jie3yuan4dui4xiang4,CondArg1Type="",},
  [88]={BaseID=88,CondName=ConditionType.CT_auto_condition_xin1yuan4ren4wu4_qing1bao2zhi1tu2_dang1qian2chang2jing3you3nv3di4zi3,CondArg1Type="Clan",CondArg1Name="门派ID",CondArg2Type="Map",CondArg2Name="地图ID",},
  [89]={BaseID=89,CondName=ConditionType.CT_auto_condition_xian3shi4deng3ji2ti2sheng1jie4mian4,CondArg1Type="",},
  [90]={BaseID=90,CondName=ConditionType.CT_auto_condition_deng3ji2ti2sheng1kai1guan1,CondArg1Type="",},
  [91]={BaseID=91,CondName=ConditionType.CT_auto_condition_zu3tuan2qi3tao3_qi3tao3shou1yi4pan4duan4,CondArg1Type="",},
  [92]={BaseID=92,CondName=ConditionType.CT_auto_condition_men2pai4tiao1zhan4_shi4fou3you3CD,CondArg1Type="",},
  [93]={BaseID=93,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_jiao1qian2_xuan3ze2gei3qian2_condition,CondArg1Type="",},
  [94]={BaseID=94,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_song4xin4_dong4tai4jiao1hu4shi4fou3kai1qi3,CondArg1Type="",},
  [95]={BaseID=95,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_song4xin4_dang1qian2ren4wu4shi4fou3wan2cheng2,CondArg1Type="",},
  [96]={BaseID=96,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_song4xin4_jiao3se4shi4fou3ke3jiao1xin4,CondArg1Name="角色ID",CondArg2Type="Task",CondArg2Name="任务ID",},
  [97]={BaseID=97,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_pei4fang1_jiao1hu4_deng3dai1ti2jiao1_condition,CondArg1Type="",},
  [98]={BaseID=98,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_pei4fang1_jie2shu4_cheng2pin3_condition,CondArg1Type="",},
  [99]={BaseID=99,CondName=ConditionType.CT_auto_ren4wu4_tong1yong4sui2ji1ren4wu4_pei4fang1_jie2shu4_cai2liao4_condition,CondArg1Type="",},
  [100]={BaseID=100,CondName=ConditionType.CT_auto_ren4wu4_guo1peng2ju3_tao2hua1dao3feng1bo1tiao2jian4pan4duan4,CondArg1Type="",},
  [101]={BaseID=101,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_shi4yue1_shi4fou3shi4chu1ci4hao3gan3tu1po4,CondArg1Type="",},
  [102]={BaseID=102,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_shi4yue1_shi4fou3shi4chu1ci4jie2yi4,CondArg1Type="",},
  [103]={BaseID=103,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_shi4yue1_shi4fou3ceng2jing1pian4hun1gai1jiao3se4,CondArg1Name="角色ID",},
  [104]={BaseID=104,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_shi4yue1_pian4hun1shi4fou3cheng2gong1,CondArg1Name="角色ID",},
  [105]={BaseID=105,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_shi4yue1_pian4hun1qing3jiao1shi4fou3bei4shi2po4,CondArg1Name="角色ID",},
  [106]={BaseID=106,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_shi4yue1jie2yi4_dang1qian2shi4fou3you3hai2zi3pei2yang3ren4wu4,CondArg1Name="A夫妻ID",CondArg2Type="RoleTemplate",CondArg2Name="B夫妻ID",},
  [107]={BaseID=107,CondName=ConditionType.CT_auto_ren4wu4tiao2jian4_shi4yue1jie2yi4_neng2fou3xian3shi4hao3gan3tu1po4xuan3xiang4,CondArg1Name="角色ID",},
  [108]={BaseID=108,CondName=ConditionType.CT_auto_ren4wu4tong1yong4_shang1dian4zai4shang1dian4zu3zhong1,CondArg1Type="Shop",CondArg1Name="商店ID",CondArg2Type="Shop[]",CondArg2Name="商店组ID",},
  [109]={BaseID=109,CondName=ConditionType.CT_auto_ren4wu4tong1yong4_dang1qian2jiao1hu4jiao3se4men2pai4pan4duan4,CondArg1Type="Clan",CondArg1Name="门派ID",},
  [110]={BaseID=110,CondName=ConditionType.CT_auto_ren4wu4tong1yong4pan4duan4_men2pai4fu4chou2_shi4fou3xu1yao4bei4men2pai4fu4chou2,CondArg1Type="",},
  [111]={BaseID=111,CondName=ConditionType.CT_auto_qie1cuo1_pan4duan4shi4fou3you3tou2xian2,CondArg1Type="",},
  [112]={BaseID=112,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_hui4te4ding4men2pai4wu3xue2de0te4ding4men2pai4dui4you3,CondArg1Type="Clan",CondArg1Name="指定门派ID",CondArg2Type="Clan",CondArg2Name="武学门派ID",CondArg3Type="TBoolean",CondArg3Name="包含主角",},
  [113]={BaseID=113,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_de0tu2shu3yu2dui4ying1men2pai4,CondArg1Type="Clan",CondArg1Name="门派ID",CondArg2Type="Map",CondArg2Name="地图ID",},
  [114]={BaseID=114,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_shi4fou3tiao1xin4cheng2gong1guo4men2pai4,CondArg1Type="Clan",CondArg1Name="门派ID",},
  [115]={BaseID=115,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_jiao3se4pin3zhi4bi3jiao4,CondArg1Type="Rank",CondArg1Name="品质ID",CondArg2Type="RoleTemplate",CondArg2Name="角色ID",},
  [116]={BaseID=116,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_jiao3se4shi4fou3shang4zhen4,CondArg1Name="角色ID",},
  [117]={BaseID=117,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4pan4duan4_cheng2zhen4ji1sha1ren4wu4_dao4ju4shi4fou3shou1ji2wan2cheng2,CondArg1Type="",},
  [118]={BaseID=118,CondName=ConditionType.CT_auto_hua2shan1_song1shan1song4xin4_shen1fen4fan3kui4,CondArg1Type="",},
  [119]={BaseID=119,CondName=ConditionType.CT_auto_da4jue2zhan4xi4tong3_pan4duan4hai2you3hui2he2shu4,CondArg1Type="",},
  [120]={BaseID=120,CondName=ConditionType.CT_auto_xue2wu3jie4mian4_shi4fou3shao3lin2si4ju4qing2,CondArg1Type="",},
  [121]={BaseID=121,CondName=ConditionType.CT_auto_dang1qian2jiao1hu4jiao3se4shi4fou3wei2qi2ta1wan2jia1,CondArg1Type="",},
  [122]={BaseID=122,CondName=ConditionType.CT_auto_xin1yuan4_men2pai4nie4tu2_huo4qu3shu4ju4,CondArg1Type="",},
  [123]={BaseID=123,CondName=ConditionType.CT_auto_xin1yuan4ren4wu4_wei2guo2wei2min2_zhao3chu1nei4jian1tiao2jian4,CondArg1Type="",},
  [124]={BaseID=124,CondName=ConditionType.CT_auto_xin1yuan4ren4wu4_zhen1ai4wu2di2_san1liu2gao1shou3tiao2jian4,CondArg1Type="",},
  [125]={BaseID=125,CondName=ConditionType.CT_auto_shu4zu3_shi4fou3bao1han2yuan2su4,CondArg1Type="any[]",CondArg1Name="数组",CondArg2Type="any",CondArg2Name="元素",},
  [126]={BaseID=126,CondName=ConditionType.CT_auto_xin1mi2gong1_dang1qian2jiao1hu4jiao3se4shi4fou3wei2ka3pian4jiao3se4,CondArg1Type="",},
  [127]={BaseID=127,CondName=ConditionType.CT_auto_xin1mi2gong1_dang1qian2xian3shi4ka3pian4shi4fou3you3zhi3ding4ka3pian4,CondArg1Type="MazeCard",CondArg1Name="迷宫卡片ID",},
  [128]={BaseID=128,CondName=ConditionType.CT_auto_xin1mi2gong1_shi4fou3shi4ren4wu4shi4jian4de0tu2ge2,CondArg1Type="o_new_maze_terrain_block",CondArg1Name="地图格ID",},
  [129]={BaseID=129,CondName=ConditionType.CT_auto_xin1mi2gong1_dian3ji1wei4zhi4shi4fou3yi3jie3suo3,CondArg1Type="",},
  [130]={BaseID=130,CondName=ConditionType.CT_auto_za2xiang4_dang1qian2chang2jing3neng2fou3bei4dian3ji1,CondArg1Type="Map",CondArg1Name="点击位置ID",},
  [131]={BaseID=131,CondName=ConditionType.CT_auto_you2xi4chu1shi3yin3dao3_shi4fou3wan2cheng2,CondArg1Type="",},
  [132]={BaseID=132,CondName=ConditionType.CT_auto_you2xi4wan2fa3luo2ji2_jiang1hu2gao1shou3ren4wu4_jin4du4shi4fou3da2dao4,CondArg1Type="int",CondArg1Name="进度",},
  [133]={BaseID=133,CondName=ConditionType.CT_auto_you2xi4wan2fa3luo2ji2_mi2gong1_shua1guai4mi2gong1_lou2ti1_tiao2jian40,CondArg1Type="",},
  [134]={BaseID=134,CondName=ConditionType.CT_auto_you2xi4wan2fa3luo2ji2_tong1yong4_dang1qian2de0tu2pan4duan4,CondArg1Type="Map[]",CondArg1Name="地图列表ID",},
  [135]={BaseID=135,CondName=ConditionType.CT_auto_lao2fang2wan2fa3_fa2kuan3shi4fou3zu2gou4,CondArg1Type="",},
  [136]={BaseID=136,CondName=ConditionType.CT_auto_bai3bao3shu1_shi4fou3yi3kai1tong1hao2xia2ban3,CondArg1Type="",},
  [137]={BaseID=137,CondName=ConditionType.CT_auto_xi4tong3ren4wu4_da4de0tu2xi4tong3_chan2xian4lu4nei4shi4fou3hai2you3hou4xu4shi4jian4,CondArg1Type="",},
  [138]={BaseID=138,CondName=ConditionType.CT_auto_xi4tong3ren4wu4_da4de0tu2xi4tong3_shi4fou3cun2zai4hou4xu4lu4xian4,CondArg1Type="",},
  [139]={BaseID=139,CondName=ConditionType.CT_auto_xi4tong3ren4wu4_dang1qian2dao4ju4ju4qing2dui4lie4bu4wei2kong1,CondArg1Type="",},
  [140]={BaseID=140,CondName=ConditionType.CT_auto_zi4you2mo2shi4_shi4fou3zuo4wan2ji4yi4sui4pian4ren4wu4,CondArg1Type="",},
  [141]={BaseID=141,CondName=ConditionType.CT_auto_jiao3se4_shi4fou3yun3xu3tu2sha1,CondArg1Name="角色ID",},
  [142]={BaseID=142,CondName=ConditionType.CT_auto_jiao3se4_shi4fou3shi4xiong1di4guan1xi4,CondArg1Name="A角色ID",CondArg2Type="RoleTemplate",CondArg2Name="B角色ID",},
  [143]={BaseID=143,CondName=ConditionType.CT_auto_jiao3se4_huo4qu3yong1you3zhi3ding4ren4yi4wu3xue2de0jiao3se4,CondArg1Type="Martial",CondArg1Name="武学ID",},
  [144]={BaseID=144,CondName=ConditionType.CT_auto_jiao3se4jiao1hu4_jiao3se4neng2fou3qing3jiao1,CondArg1Name="角色ID",},
  [145]={BaseID=145,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_hai2zi3bai4shi1leng3que4shi4fou3jie2shu4,CondArg1Name="孩子ID",},
  [146]={BaseID=146,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_hai2zi3shi4fou3man3zu2chu1sheng1tiao2jian4,CondArg1Name="孩子ID",},
  [147]={BaseID=147,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_hai2zi3shi4fou3man3zu2bai4shi1tiao2jian4,CondArg1Name="孩子ID",},
  [148]={BaseID=148,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_shi1fu4shou4wu3_wu3xue2neng2fou3chuan2shou4,CondArg1Type="Martial",CondArg1Name="武学ID",},
  [149]={BaseID=149,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_xing4bie2shi4fou3xiang4tong2,CondArg1Name="A角色ID",CondArg2Type="RoleTemplate",CondArg2Name="B角色ID",},
  [150]={BaseID=150,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_shi4fou3man3zu2shi4yue1tiao2jian4,CondArg1Name="A角色ID",CondArg2Type="RoleTemplate",CondArg2Name="B角色ID",},
  [151]={BaseID=151,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_fu4mu3shi4fou3shi4zhu3jiao3,CondArg1Name="孩子ID",},
  [152]={BaseID=152,CondName=ConditionType.CT_auto_shi4yue1jie2yi4_dui4wu3cheng2yuan2shi4fou3man3zu2bai4shi1tiao2jian4,CondArg1Type="",},
  [153]={BaseID=153,CondName=ConditionType.CT_auto_condition_men2pai4fu4chou2_you3mi4ji2,CondArg1Type="Clan",CondArg1Name="门派ID",},
  [154]={BaseID=154,CondName=ConditionType.CT_auto_condition_men2pai4fu4chou2_you3wu3qi4,CondArg1Type="",},
  [155]={BaseID=155,CondName=ConditionType.CT_auto_condition_si4miao4wan2fa3_juan1qian2tiao2jian4,CondArg1Type="",},
  [156]={BaseID=156,CondName=ConditionType.CT_auto_condition_si4miao4wan2fa3_jie3yuan4tiao2jian4,CondArg1Type="",},
  [157]={BaseID=157,CondName=ConditionType.CT_auto_xin1mi2gong1_dian3ji1wei4zhi4shi4fou3man3zu2jie3suo3tiao2jian4,CondArg1Type="",},
  [158]={BaseID=158,CondName=ConditionType.CT_IsUnitActSpecialUint,CondArg1Name="角色ID",},
  [159]={BaseID=159,CondName=ConditionType.CT_IsDamageEndSpecialUint,CondArg1Name="角色ID",},
  [160]={BaseID=160,CondName=ConditionType.CT_HalfHpAndNotDead,CondArg1Name="角色ID",},
  [161]={BaseID=161,CondName=ConditionType.CT_NotSpecialUnitFail,CondArg1Name="A角色ID",CondArg2Type="RoleTemplate",CondArg2Name="B角色ID",},
  [162]={BaseID=162,CondName=ConditionType.CT_IsUnitNumZero,CondArg1Type="",},
  [163]={BaseID=163,CondName=ConditionType.CT_IsSpellZhiDingSkill,CondArg1Type="Martial",CondArg1Name="武学ID",},
  [164]={BaseID=164,CondName=ConditionType.CT_IsBattleRoleDead,CondArg1Name="0角色ID",},
  [165]={BaseID=165,CondName=ConditionType.CT_BattleEnemyNumCmp,CondArg1Type="int",CondArg1Name="人数",},
  [166]={BaseID=166,CondName=ConditionType.CT_ConBattleUnitHpCmp,CondArg1Name="角色ID",CondArg2Type="CompareSignType",CondArg2Name="比较类型",CondArg3Type="int",CondArg3Name="比较百分比值(0-100)",},
  [167]={BaseID=167,CondName=ConditionType.CT_SELECT_ITEM_COMMON,CondArg1Type="ItemTypeDetail",CondArg1Name="0物品类型1",CondArg2Type="ItemTypeDetail",CondArg2Name="1物品类型2",CondArg3Type="ItemTypeDetail",CondArg3Name="2物品类型3",CondArg4Type="FavorType",CondArg4Name="3礼物类型1",CondArg5Type="FavorType",CondArg5Name="4礼物类型2",CondArg6Type="FavorType",CondArg6Name="5礼物类型3",CondArg7Type="RankType",CondArg7Name="6最低品质",CondArg8Type="RankType",CondArg8Name="7最高品质",},
  [168]={BaseID=168,CondName=ConditionType.CT_INT_VALUE_COMPARE,CondArg1Type="int",CondArg1Name="0数值1",CondArg2Type="CompareSignType",CondArg2Name="1比较类型",CondArg3Type="int",CondArg3Name="2数值2",},
  [169]={BaseID=169,CondName=ConditionType.CT_auto_yi4rong2mian4ju4_zhong3lei4pan4duan4,CondArg1Name="角色ID",CondArg2Type="DisguiseType",CondArg2Name="类型",},
  [170]={BaseID=170,CondName=ConditionType.CT_auto_yi4rong2mian4ju4_men2pai4pan4duan4,CondArg1Name="角色ID",CondArg2Type="DisguiseClanJudge",CondArg2Name="门派易容",},
  [171]={BaseID=171,CondName=ConditionType.CT_TASKDISGUISE_JUDGE,CondArg1Type="int",CondArg1Name="0接口弃用",},
  [172]={BaseID=172,CondName=ConditionType.CT_CanMarry,CondArg1Name="A角色ID",CondArg2Type="RoleTemplate",CondArg2Name="B角色ID",},
  [173]={BaseID=173,CondName=ConditionType.CT_HAS_TYPE_KUNGFU,CondArg1Type="DepartEnumType",CondArg1Name="武学品类",CondArg2Type="Rank",CondArg2Name="品质ID",CondArg3Type="int",CondArg3Name="等级",CondArg4Type="TBoolean",CondArg4Name="是否包含队友",CondArg5Type="Clan",CondArg5Name="门派",},
  [174]={BaseID=174,CondName=ConditionType.CT_COMPARE_GOODEVIL,CondArg1Name="角色ID",CondArg2Type="CompareSignType",CondArg2Name="比较方式",CondArg3Type="int",CondArg3Name="数值",},
  [175]={BaseID=175,CondName=ConditionType.CT_IS_CITY_LOCKED,CondArg1Type="City",CondArg1Name="城市ID",},
  [176]={BaseID=176,CondName=ConditionType.CT_SPEVO_FANHAOSE,CondArg1Type="int",CondArg1Name="0阶段标识",CondArg2Type="int",CondArg2Name="1概率",},
  [177]={BaseID=177,CondName=ConditionType.CT_HAS_BUFF,CondArg1Name="角色ID",CondArg2Type="Buff",CondArg2Name="buffTypeID",},
  [178]={BaseID=178,CondName=ConditionType.CT_COIN_COMPARE,CondArg1Type="CompareSignType",CondArg1Name="0比较方式",CondArg2Type="int32",CondArg2Name="1比较值",},
  [218]={BaseID=218,CondName=ConditionType.CT_BATTLE_MARTIAL_IS_TYPE,CondArg1Type="DepartEnumType",CondArg1Name="系别",CondArg2Type="Clan",CondArg2Name="门派ID",CondArg3Type="TBoolean",CondArg3Name="有毒",CondArg4Type="TBoolean",CondArg4Name="多段",CondArg5Type="Martial",CondArg5Name="指定武学",},
  [219]={BaseID=219,CondName=ConditionType.CT_ROLE_RANK_COMPARE,CondArg1Name="0角色",CondArg2Type="CompareSignType",CondArg2Name="1比较类型",CondArg3Type="string",CondArg3Name="2比较品质",CondArg4Type="RankType",CondArg4Name="3辅助品质(方便查看中文枚举)",},
  [220]={BaseID=220,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_mao4xian3tian1fu4pan4duan4,CondArg1Type="",CondArg2Type="AdventureType",CondArg2Name="1冒险天赋类型",CondArg3Type="int",CondArg3Name="2等级",},
  [221]={BaseID=221,CondName=ConditionType.CT_ROLE_EQUIP_COMPARE,CondArg1Name="0角色",CondArg2Type="Item",CondArg2Name="1装备物品",},
  [222]={BaseID=222,CondName=ConditionType.CT_ROLE_DISGUISE_COMPARE,CondArg1Name="0角色",CondArg2Type="DisguiseItem",CondArg2Name="1易容ID",},
  [223]={BaseID=223,CondName=ConditionType.CT_IS_TASK_START,CondArg1Type="int",CondArg1Name="0任务实例ID",CondArg2Type="Task",CondArg2Name="1任务表ID",},
  [224]={BaseID=224,CondName=ConditionType.CT_ROLE_FAVOR_COMPARE,CondArg1Name="0角色",CondArg2Type="string",CondArg2Name="1喜好",CondArg3Type="FavorType",CondArg3Name="2喜好枚举(辅助使用方便查找中文)",},
  [225]={BaseID=225,CondName=ConditionType.CT_SELECT_ITEM_ENHANCEGRADE,CondArg1Type="Item",CondArg1Name="0物品ID",CondArg2Type="int",CondArg2Name="1强化等级",},
  [226]={BaseID=226,CondName=ConditionType.CT_SELECT_ITEM_SPECIFIC,CondArg1Type="Item",CondArg1Name="0特定物品1",CondArg2Type="Item",CondArg2Name="1特定物品2",CondArg3Type="Item",CondArg3Name="2特定物品3",CondArg4Type="Item",CondArg4Name="3特定物品4",CondArg5Type="Item",CondArg5Name="4特定物品5",CondArg6Type="Item",CondArg6Name="5特定物品6",CondArg7Type="Item",CondArg7Name="6特定物品7",CondArg8Type="Item",CondArg8Name="7特定物品8",},
  [227]={BaseID=227,CondName=ConditionType.CT_auto_jiao3se4_jiao3se4yong1you3tian1fu4,CondArg1Name="角色ID",CondArg2Type="Gift",CondArg2Name="天赋ID",CondArg3Type="TBoolean",CondArg3Name="包含队友",},
  [228]={BaseID=228,CondName=ConditionType.CT_WEEKROUND_COMPARE,CondArg1Type="CompareSignType",CondArg1Name="比较方式",CondArg2Type="int",CondArg2Name="对比值",},
  [229]={BaseID=229,CondName=ConditionType.CT_IS_BATTLE_CUR_ROUND,CondArg1Type="int",CondArg1Name="回合数",},
  [230]={BaseID=230,CondName=ConditionType.CT_IS_CLAN_KEEPER,CondArg1Name="0角色",CondArg2Type="Clan",CondArg2Name="1门派",},
  [231]={BaseID=231,CondName=ConditionType.CT_IS_MAIN_ROLE,CondArg1Name="0角色",},
  [232]={BaseID=232,CondName=ConditionType.CT_FINALBATTLE_EVENTCITY,CondArg1Type="FinalBattleCity",CondArg1Name="据点ID",},
  [233]={BaseID=233,CondName=ConditionType.CT_auto_ju4qing2tiao2jian4_ju4ben3pan4duan4,CondArg1Type="Story",CondArg1Name="剧本ID",},
  [234]={BaseID=234,CondName=ConditionType.CT_CHECK_CUR_DRTIME,CondArg1Type="CompareSignType",CondArg1Name="比较方式",CondArg2Type="int",CondArg2Name="时间刻",},
  [235]={BaseID=235,CondName=ConditionType.CT_SPECIAL_BATTLE,CondArg1Type="Battle",CondArg1Name="战斗ID",CondArg2Type="int",CondArg2Name="战斗类型",},
  [236]={BaseID=236,CondName=ConditionType.CT_IS_UNLOCK,CondArg1Type="PlayerBehaviorType",CondArg1Name="0交互类型",CondArg2Type="Boolean",CondArg2Name="1判断剧本内解锁",},
  [237]={BaseID=237,CondName=ConditionType.CT_TAG_BATTLECMP,CondArg1Type="int",CondArg1Name="0标记",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",},
  [238]={BaseID=238,CondName=ConditionType.CT_TEAMMATES_COUNT_COMPARE,CondArg1Type="CompareSignType",CondArg1Name="0比较类型",CondArg2Type="int",CondArg2Name="1数量",CondArg3Type="Boolean",CondArg3Name="2是否包括主角",},
  [239]={BaseID=239,CondName=ConditionType.CT_IS_ROLE_WISHTASK_FINISH,CondArg1Name="角色ID",CondArg2Type="int",CondArg2Name="心愿ID",},
  [246]={BaseID=246,CondName=ConditionType.CT_CHECK_CLAN_STATE,CondArg1Type="Clan",CondArg1Name="0门派",CondArg2Type="ClanEliminateType",CondArg2Name="1门派征服类型",},
  [247]={BaseID=247,CondName=ConditionType.CT_USER_HAD_RENAME_ONCE,CondArg1Type="",},
  [250]={BaseID=250,CondName=ConditionType.CT_COND_BE_MARRIED,CondArg1Name="0角色",CondArg2Type="RoleTemplate",CondArg2Name="1誓约对象",},
  [251]={BaseID=251,CondName=ConditionType.CT_HIGHTOWER_TASK_STAGE,CondArg1Type="HighTowerType",CondArg1Name="0千层塔类型",CondArg2Type="int",CondArg2Name="1阶段",CondArg3Type="int",CondArg3Name="2值一",CondArg4Type="int",CondArg4Name="3值二",CondArg8Type="string",CondArg8Name="7描述",},
  [252]={BaseID=252,CondName=ConditionType.CT_ROLE_MARTIAL_NUM_COMPARE,CondArg1Name="0角色",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int",CondArg3Name="2数量",},
  [253]={BaseID=253,CondName=ConditionType.CT_IS_HIGHTOWER_UNLOCK,CondArg1Type="HighTowerType",CondArg1Name="0千层塔类型",},
  [254]={BaseID=254,CondName=ConditionType.CT_WOMAN_TEAMMATE_NUM,CondArg1Type="CompareSignType",CondArg1Name="1比较方式",CondArg2Type="int",CondArg2Name="2比较值",},
  [255]={BaseID=255,CondName=ConditionType.CT_WISH_TASK_REWARD_GET,CondArg1Name="0角色",CondArg2Type="RoleTemplateWishQuest",CondArg2Name="1心愿任务",},
  [256]={BaseID=256,CondName=ConditionType.CT_ROLE_ADVGIFT_COMPARE,CondArg1Name="0角色",CondArg2Type="AdventureType",CondArg2Name="1冒险天赋类型",CondArg3Type="CompareSignType",CondArg3Name="2比较类型",CondArg4Type="int",CondArg4Name="3等级",},
  [257]={BaseID=257,CondName=ConditionType.CT_CALLUP_ROLE_COMPARE,CondArg1Name="0角色",CondArg2Type="Rank",CondArg2Name="1品质",CondArg3Type="Clan",CondArg3Name="2门派",},
  [258]={BaseID=258,CondName=ConditionType.CT_INQUIRY_SAFE,CondArg1Name="0角色",},
  [259]={BaseID=259,CondName=ConditionType.CT_INQUIRY_DOUBT,CondArg1Name="0角色",},
  [260]={BaseID=260,CondName=ConditionType.CT_INQUIRY_GUILT,CondArg1Name="0角色",},
  [261]={BaseID=261,CondName=ConditionType.CT_TREASURELVL_CMP,CondArg1Type="int",CondArg1Name="大于等于该等级",},
  [262]={BaseID=262,CondName=ConditionType.CT_BATTLE_USE_SKILL_REASON,CondArg1Type="int",CondArg1Name="原因(1是主动)",},
  [263]={BaseID=263,CondName=ConditionType.CT_COMPARE_ACCOUNT_TAG,CondArg1Type="TaskTag",CondArg1Name="0标记",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",},
  [264]={BaseID=264,CondName=ConditionType.CT_ROLE_BROTHERS_NUM_COMPARE,CondArg1Name="0角色",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",},
  [265]={BaseID=265,CondName=ConditionType.CT_CARRY_FLAG,CondArg1Type="int",CondArg1Name="0类型",},
  [266]={BaseID=266,CondName=ConditionType.CT_CLANTYPE_COMPARE,CondArg1Type="Clan",CondArg1Name="0门派",CondArg2Type="ClanType",CondArg2Name="1类型",CondArg3Type="TBoolean",CondArg3Name="2是否小门派",},
  [267]={BaseID=267,CondName=ConditionType.CT_IFCANGET_SALARY,CondArg1Type="Clan",CondArg1Name="0门派",CondArg2Type="ClanEliminateType",CondArg2Name="1门派征服类型",CondArg3Type="City",CondArg3Name="2城市",},
  [268]={BaseID=268,CondName=ConditionType.CT_TEAMMATE_ATTR_COMPARE,CondArg1Type="AttrType",CondArg1Name="0属性",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",CondArg4Type="TBoolean",CondArg4Name="3是否比较队伍总值",},
  [269]={BaseID=269,CondName=ConditionType.CT_COMPARE_CLAN_ELIMINATE_NUM,CondArg1Type="int",CondArg1Name="0数值",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",},
  [270]={BaseID=270,CondName=ConditionType.CT_CHENG_SHI_HAO_GAN_DU_BI_JIAO,CondArg1Type="City",CondArg1Name="0城市",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",},
  [271]={BaseID=271,CondName=ConditionType.CT_IS_ROLE_POSITION_AVALIABLE,CondArg1Name="0角色",CondArg2Type="Map",CondArg2Name="1位置",CondArg3Type="TBoolean",CondArg3Name="2不包括屠杀",},
  [272]={BaseID=272,CondName=ConditionType.CT_MAINROLE_CREATEROLE_COMPARE,CondArg1Name="0创角原角色",},
  [273]={BaseID=273,CondName=ConditionType.CT_IS_ROLE_IN_SCENE,CondArg1Type="Map",CondArg1Name="0场景",CondArg2Type="RoleTemplate",CondArg2Name="1角色",CondArg3Type="Map",CondArg3Name="2排除建筑",},
  [274]={BaseID=274,CondName=ConditionType.CT_ROLE_SEX_COMPARE,CondArg1Name="0角色",CondArg2Type="SexType",CondArg2Name="1性别",},
  [275]={BaseID=275,CondName=ConditionType.CT_ROLE_TYPEID_COMPARE,CondArg1Type="int",CondArg1Name="0角色ID",CondArg2Type="RoleTemplate",CondArg2Name="1角色",},
  [276]={BaseID=276,CondName=ConditionType.CT_ROLE_BROANDSIS_COMPARE,CondArg1Name="0角色",CondArg2Type="RoleTemplate",CondArg2Name="1结义对象",},
  [277]={BaseID=277,CondName=ConditionType.CT_FINALBATTLE_VICTORYNUM_COMPARE,CondArg1Type="FinalBattleCity",CondArg1Name="0据点ID",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int",CondArg3Name="2记录",},
  [278]={BaseID=278,CondName=ConditionType.CT_COMPARE_2020_QIXI_TASK_VALUE,CondArg1Type="int",CondArg1Name="0计数",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",},
  [279]={BaseID=279,CondName=ConditionType.CT_REAL_TIME_COMPARE,CondArg1Type="CompareSignType",CondArg1Name="0比较方式",CondArg2Type="int",CondArg2Name="1年",CondArg3Type="int",CondArg3Name="2月",CondArg4Type="int",CondArg4Name="3日",CondArg5Type="int",CondArg5Name="4时",CondArg6Type="int",CondArg6Name="5分",},
  [280]={BaseID=280,CondName=ConditionType.CT_CHECK_NOVICE_GUIDE_FINISH_FLAG,CondArg1Type="NoviceGuideFinishFlag",CondArg1Name="0类型",},
  [281]={BaseID=281,CondName=ConditionType.CT_WEEKROUND_DIFF_COMPARE,CondArg1Type="int",CondArg1Name="0难度",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",},
  [282]={BaseID=282,CondName=ConditionType.CT_COMPARE_OVERLAYLEVEL,CondArg1Name="0角色",CondArg2Type="int",CondArg2Name="0修行等级",},
  [283]={BaseID=283,CondName=ConditionType.CT_BATTLE_IS_SKIP,CondArg1Type="Battle",CondArg1Name="0战斗ID",},
  [285]={BaseID=285,CondName=ConditionType.CT_CMP_BONDLEVEL,CondArg1Type="CompareSignType",CondArg1Name="0比较方式",CondArg2Type="int32",CondArg2Name="1羁绊id",CondArg3Type="int32",CondArg3Name="2比较值",},
  [287]={BaseID=287,CondName=ConditionType.CT_IS_CLANMASTER,CondArg1Name="0角色",},
  [288]={BaseID=288,CondName=ConditionType.CT_DLC_OWN,CondArg1Type="DLC",CondArg1Name="0DLC_ID",},
  [289]={BaseID=289,CondName=ConditionType.CT_IS_CRACK,CondArg1Type="",},
  [290]={BaseID=290,CondName=ConditionType.CT_COMPARE_GODSCORE,CondArg1Type="MODType",CondArg1Name="0捏脸评分类型",CondArg2Type="CompareSignType",CondArg2Name="1比较方式",CondArg3Type="int32",CondArg3Name="2比较值",},
}
for k,v in pairs(TaskConditionEnum) do
    setmetatable(v, {['__index'] = TaskConditionEnumDefault})
end

-- export table: TaskConditionEnum
return TaskConditionEnum
