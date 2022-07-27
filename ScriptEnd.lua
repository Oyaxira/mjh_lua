-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum WeekEndEnum
-- enum TBoolean
require("common");


local ScriptEndDefault = {CanReward=0,CanUnlockDiff=0,IsSendMail=TBoolean.BOOL_NO,MailTitle="",MailContent="",}
local ScriptEnd= {
  [1]={BaseID=1,ShowIndex=1,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Pu1Tong2Jie3Ju,Name="风起云涌",AchieveID=98,CG=15,Description="你战胜了白衣教，江湖中最大的祸患被你解除，但那些已经因此离开的人们，再也回不来了。",Complete="与白衣教对抗，并取得决战胜利",CanUnlockDiff=1,},
  [2]={BaseID=2,ShowIndex=2,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Wan1Mei2Jie3Ju,Name="少年江湖梦",AchieveID=100,CG=13,Description="你不但战胜了白衣教，还阻止了任何一座城市的沦陷，整个江湖都会记得你的功绩！",Complete="在与白衣教的决战中，不损失任何一座城市",CanUnlockDiff=1,},
  [3]={BaseID=3,ShowIndex=3,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_XieXianWanMei,Name="白衣之王",AchieveID=99,CG=7,Description="没有人敢说出你的名字，没有人不知道你的名字。一个又一个的轮回，终成天下主宰！",Complete="加入白衣教，攻占所有城市并战胜白衣魔君",CanUnlockDiff=1,},
  [4]={BaseID=4,ShowIndex=4,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Yu1Shi2Wu1Zheng,Name="与世无争",AchieveID=56,CG=21,Description="也许在哪个世界，另一个我早就完成了自己的使命呢？",Complete="在月牙村保护田老六存活",},
  [5]={BaseID=5,ShowIndex=5,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Gao1Sen,Name="高僧",AchieveID=70,CG=32,Description="活得比他们久，又何尝不是一种胜利呢？",Complete="拒绝从少林寺出师，度过七十年",},
  [6]={BaseID=6,ShowIndex=6,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Wu1Xia2Xiao3Shuo4Kan1Duo2Le,Name="武侠小说看多了",AchieveID=72,CG=30,Description="几只山鸮惊起，飞上枝头。而这也是你在江湖留下的最后的一抹痕迹了……",Complete="在雾天时，来到华山或恒山绝顶，一坠而下",},
  [7]={BaseID=7,ShowIndex=7,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Hai1Wai2Shen3Xian,Name="海外神仙",AchieveID=73,CG=23,Description="东南有一孤岛，居民数万，面容相似。此中黄发垂髫，怡然自乐，真乃神仙之居所也！",Complete="携带十名密友，在无名岛过上神仙生活",},
  [8]={BaseID=8,ShowIndex=8,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Shen1Zhou2Ba3Zhu,Name="神州霸主",AchieveID=53,CG=10,Description="正所谓，功过论争千秋去，无字碑上遍诗文，一代神侠绝古今！",Complete="将六扇门灭门，亲自坐上那宝座",},
  [9]={BaseID=9,ShowIndex=9,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Zhen1Qi2Fa3Zuo,Name="真气发作",AchieveID=350,CG=33,Description="江湖传闻：是年是月，某人悄无声息地退隐江湖，后再无一人得见。",Complete="因为神秘真气发作而退隐江湖",},
  [10]={BaseID=10,ShowIndex=10,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_Jiang1Hu2Bu3Zai,Name="江湖不再",AchieveID=349,CG=28,Description="折戟消兵歌牧野，沉河洗甲看流星。",Complete="将40个门派征服，屹立武林之巅！",},
  [11]={BaseID=11,ShowIndex=11,ScriptOwner={2,4,},WeekEndEnum=WeekEndEnum.WEE_BingJiaChangShi,Name="兵家常事",AchieveID=71,CG=30,Description="胜败乃兵家常事，大侠请重新来过！",Complete="在战斗中认输，放弃本次江湖冒险之旅",},
  [12]={BaseID=12,ShowIndex=16,ScriptOwner={1,},WeekEndEnum=WeekEndEnum.WEE_YuWenZhuang,Name="宇文庄奇案",AchieveID=351,CG=1,Description="二十年前，那是一切的开始……",Complete="完成宇文庄奇案的回忆，败给秦中居士一行",},
  [13]={BaseID=13,ShowIndex=17,ScriptOwner={1,},WeekEndEnum=WeekEndEnum.WEE_YuWenZhuang2,Name="反抗到底",AchieveID=285,CG=28,Description="二十年前，那是一切的开始。即使战胜对手，也是于事无补……",Complete="完成宇文庄奇案的回忆，战胜秦中居士一行",},
  [15]={BaseID=15,ShowIndex=12,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_LaoDiZuoChuan,Name="牢底坐穿",AchieveID=457,CG=33,Description="江湖之大，切莫四处惹事，打赢绝交，打输坐牢……",Complete="在监狱中真气爆发，结束江湖生涯",},
  [16]={BaseID=16,ShowIndex=13,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_XingBianSiHai,Name="行遍四海",AchieveID=458,CG=19,Description="你的足迹遍布江湖，成为了世人皆知的冒险家。",Complete="走遍世界每一个角落，找凡云庄的易龙归隐",},
  [17]={BaseID=17,ShowIndex=14,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_CunBa,Name="村霸",AchieveID=459,CG=22,Description="还未进入江湖的你，就已经成了月牙村一霸，传扬出去，也是一桩奇闻。",Complete="首次离开月牙村前，强迫所有村民退隐江湖",},
  [18]={BaseID=18,ShowIndex=15,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_LiDiChengFo,Name="立地成佛",AchieveID=460,CG=32,Description="恶人只要放下屠刀，就能立地成佛；而好人却要经历磨难，怪哉！",Complete="决斗或惩恶使人退隐100次后，到寺庙上香",},
  [19]={BaseID=19,ShowIndex=19,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_QiGai,Name="一无所有",AchieveID=645,CG=28,Description="你未能坚持下去，最终落得个一无所有的下场……",Complete="败给白衣魔君后，最终向白衣魔君低头认输",CanUnlockDiff=1,},
  [20]={BaseID=20,ShowIndex=20,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_XieXianPuTong,Name="逆天改命",AchieveID=646,CG=28,Description="你统治了白衣教，但那些已经因此离开的人们，再也回不来了。",Complete="加入白衣教，并战胜白衣魔君",CanUnlockDiff=1,},
  [21]={BaseID=21,ShowIndex=21,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_XiaoYaoGongZi,Name="逍遥公子",AchieveID=768,CG=27,Description="不问江湖世事，你携密友隐居断情谷内，每日歌舞升平好不逍遥！",Complete="男性主角将66个女性角色好感度培养到100后到断情谷公孙无情处退隐",},
  [22]={BaseID=22,ShowIndex=22,ScriptOwner={2,},WeekEndEnum=WeekEndEnum.WEE_ShiFuShaMu,Name="灭亲",AchieveID=769,CG=9,Description="亦正亦邪与我何干，既然你们要阻止我的霸业，那么休怪我没有手下留情！",Complete="加入白衣教，击败邪剑侣",},
}
for k,v in pairs(ScriptEnd) do
    setmetatable(v, {['__index'] = ScriptEndDefault})
end

-- export table: ScriptEnd
return ScriptEnd
