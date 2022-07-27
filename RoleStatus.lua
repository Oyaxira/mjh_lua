-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum RoleTypeTemplate
require("common");


local RoleStatusDefault = {LingQiao=8000,NeiJin=6000,TiZhi=10000,JingLi=8000,WuXing=13000,MaxHp=10000,MP=10000,MartialATK=10000,Defence=10000,Speed=10000,QuanZhangMaster=10000,DaoFaMaster=10000,TuiFaMaster=10000,JianFaMaster=10000,NeiGongMaster=10000,YiShuMaster=10000,QiMenMaster=10000,AnQiMaster=10000,QuanZhangATK=7000,DaoFaATK=7000,TuiFaATK=7000,JianFaATK=7000,NeiGongATK=7000,YiShuATK=7000,QiMenATK=7000,AnQiATK=7000,RoundHP=10000,Roundmp=10000,MingZhongZhi=10000,ShanBiZhi=10000,BaoJiZhi=10000,BaoJiDiKang=10000,LianJiZhi=10000,LianJiDiKang=10000,FanJiZhi=10000,PoZhaoZhi=10000,BaoShangZhi=10000,Hit=10000,Miss=10000,Crit=10000,defense=10000,CritTimes=10000,ReboundTimes=10000,}
local RoleStatus= {
  [1]={BaseID=1,Name="默认",TypeTemplate=RoleTypeTemplate.RTT_Default,LiDao=10000,LingQiao=10000,NeiJin=10000,JingLi=10000,WuXing=10000,QuanZhangATK=10000,DaoFaATK=10000,TuiFaATK=10000,JianFaATK=10000,NeiGongATK=10000,YiShuATK=10000,QiMenATK=10000,AnQiATK=10000,RoleCardDesc={"无","平均发展",},},
  [2]={BaseID=2,Name="标准",TypeTemplate=RoleTypeTemplate.RTT_Standard,LiDao=10000,LingQiao=10000,NeiJin=10000,JingLi=10000,WuXing=10000,QuanZhangATK=10000,DaoFaATK=10000,TuiFaATK=10000,JianFaATK=10000,NeiGongATK=10000,YiShuATK=10000,QiMenATK=10000,AnQiATK=10000,RoleCardDesc={"无","平均发展",},},
  [3]={BaseID=3,Name="拳师",TypeTemplate=RoleTypeTemplate.RTT_QuanShi,LiDao=17000,LingQiao=7000,TiZhi=11000,JingLi=10000,WuXing=9000,MaxHp=11000,MartialATK=17000,Defence=10300,QuanZhangMaster=30000,QuanZhangATK=24000,RoundHP=11000,MingZhongZhi=7000,BaoJiZhi=6000,BaoJiDiKang=9000,LianJiZhi=17000,LianJiDiKang=9000,RoleCardDesc={"拳掌","力道、体质",},},
  [4]={BaseID=4,Name="刀客",TypeTemplate=RoleTypeTemplate.RTT_DaoKe,LiDao=16000,LingQiao=9000,NeiJin=5000,WuXing=12000,MP=8000,MartialATK=16000,Defence=8600,DaoFaMaster=30000,DaoFaATK=24000,Roundmp=8000,MingZhongZhi=9000,BaoJiZhi=5000,BaoJiDiKang=12000,LianJiZhi=16000,LianJiDiKang=12000,RoleCardDesc={"刀法","力道",},},
  [5]={BaseID=5,Name="腿师",TypeTemplate=RoleTypeTemplate.RTT_TuiShi,LiDao=7000,LingQiao=17000,JingLi=9000,WuXing=11000,MP=9000,MartialATK=17000,Defence=9300,TuiFaMaster=30000,TuiFaATK=24000,Roundmp=9000,MingZhongZhi=17000,BaoJiZhi=6000,BaoJiDiKang=11000,LianJiZhi=7000,LianJiDiKang=11000,RoleCardDesc={"腿法","灵巧",},},
  [6]={BaseID=6,Name="剑客",TypeTemplate=RoleTypeTemplate.RTT_JianKe,LiDao=6000,LingQiao=18000,TiZhi=9000,MaxHp=9000,MP=8000,MartialATK=18000,Defence=8300,JianFaMaster=30000,JianFaATK=24000,RoundHP=9000,Roundmp=8000,MingZhongZhi=18000,BaoJiZhi=6000,BaoJiDiKang=13000,LianJiZhi=6000,LianJiDiKang=13000,RoleCardDesc={"剑法","灵巧、悟性",},},
  [7]={BaseID=7,Name="内功大师",TypeTemplate=RoleTypeTemplate.RTT_NeiGongDaShi,LiDao=6000,NeiJin=16000,JingLi=7000,MP=7000,MartialATK=16000,Defence=7900,NeiGongMaster=30000,NeiGongATK=24000,Roundmp=7000,MingZhongZhi=8000,BaoJiZhi=16000,BaoJiDiKang=13000,LianJiZhi=6000,LianJiDiKang=13000,RoleCardDesc={"内功","内劲、悟性",},},
  [8]={BaseID=8,Name="医生",TypeTemplate=RoleTypeTemplate.RTT_YiSheng,LiDao=5000,NeiJin=17000,TiZhi=8000,JingLi=9000,MP=12000,MartialATK=17000,Defence=11400,YiShuMaster=30000,YiShuATK=24000,Roundmp=12000,MingZhongZhi=8000,BaoJiZhi=17000,BaoJiDiKang=8000,LianJiZhi=5000,LianJiDiKang=8000,RoleCardDesc={"医术","内劲、悟性",},},
  [9]={BaseID=9,Name="棍师",TypeTemplate=RoleTypeTemplate.RTT_GunShi,LiDao=5000,LingQiao=7000,NeiJin=18000,JingLi=12000,WuXing=8000,MP=9000,MartialATK=18000,Defence=9300,QiMenMaster=30000,QiMenATK=24000,Roundmp=9000,MingZhongZhi=7000,BaoJiZhi=18000,BaoJiDiKang=8000,LianJiZhi=8000,LianJiDiKang=8000,RoleCardDesc={"奇门","内劲、精力",},},
  [10]={BaseID=10,Name="镖客",TypeTemplate=RoleTypeTemplate.RTT_BiaoKe,LiDao=5000,LingQiao=5000,NeiJin=20000,TiZhi=7000,JingLi=10000,MaxHp=7500,MP=8500,MartialATK=20000,Defence=8200,AnQiMaster=30000,AnQiATK=24000,RoundHP=7500,Roundmp=8500,MingZhongZhi=6000,BaoJiZhi=20000,BaoJiDiKang=13000,LianJiZhi=5000,LianJiDiKang=13000,RoleCardDesc={"暗器","内劲、暗器",},},
  [11]={BaseID=11,Name="简单怪物",TypeTemplate=RoleTypeTemplate.RTT_SimpleMonster,LiDao=8000,NeiJin=8000,TiZhi=8000,WuXing=8000,MaxHp=6000,MP=6000,MartialATK=6000,Defence=6000,QuanZhangATK=8000,DaoFaATK=8000,TuiFaATK=8000,JianFaATK=8000,NeiGongATK=8000,YiShuATK=8000,QiMenATK=8000,AnQiATK=8000,RoundHP=6000,Roundmp=6000,MingZhongZhi=6000,ShanBiZhi=20000,BaoJiZhi=6000,BaoJiDiKang=6000,LianJiZhi=6000,LianJiDiKang=6000,},
  [12]={BaseID=12,Name="简单怪物+血",TypeTemplate=RoleTypeTemplate.RTT_SimpleMonster_Xue,LiDao=8000,NeiJin=8000,WuXing=8000,MaxHp=8000,MP=6000,MartialATK=6000,Defence=6600,QuanZhangATK=8300,DaoFaATK=8300,TuiFaATK=8300,JianFaATK=8300,NeiGongATK=8300,YiShuATK=8300,QiMenATK=8300,AnQiATK=8300,RoundHP=8000,Roundmp=6000,MingZhongZhi=6000,ShanBiZhi=30000,BaoJiZhi=6000,BaoJiDiKang=6000,LianJiZhi=6000,LianJiDiKang=6000,},
  [13]={BaseID=13,Name="简单怪物+攻",TypeTemplate=RoleTypeTemplate.RTT_SimpleMonster_Gong,LiDao=10000,LingQiao=10000,NeiJin=10000,TiZhi=8000,WuXing=8000,MaxHp=6000,MP=6000,MartialATK=8000,Defence=6000,QuanZhangATK=9000,DaoFaATK=9000,TuiFaATK=9000,JianFaATK=9000,NeiGongATK=9000,YiShuATK=9000,QiMenATK=9000,AnQiATK=9000,RoundHP=6000,Roundmp=6000,MingZhongZhi=8000,ShanBiZhi=40000,BaoJiZhi=8000,BaoJiDiKang=6000,LianJiZhi=8000,LianJiDiKang=6000,},
  [14]={BaseID=14,Name="普通怪物",TypeTemplate=RoleTypeTemplate.RTT_NormalMonsters,LiDao=9000,LingQiao=9000,NeiJin=9000,TiZhi=9000,JingLi=9000,WuXing=9000,MaxHp=7500,MP=7500,MartialATK=7500,Defence=7500,QuanZhangATK=9000,DaoFaATK=9000,TuiFaATK=9000,JianFaATK=9000,NeiGongATK=9000,YiShuATK=9000,QiMenATK=9000,AnQiATK=9000,RoundHP=7500,Roundmp=7500,MingZhongZhi=7500,ShanBiZhi=50000,BaoJiZhi=7500,BaoJiDiKang=7500,LianJiZhi=7500,LianJiDiKang=7500,},
  [15]={BaseID=15,Name="普通怪物+血",TypeTemplate=RoleTypeTemplate.RTT_NormalMonsters_Xue,LiDao=9000,LingQiao=9000,NeiJin=9000,JingLi=9000,WuXing=9000,MaxHp=8500,MP=7500,MartialATK=7500,Defence=7800,QuanZhangATK=9200,DaoFaATK=9200,TuiFaATK=9200,JianFaATK=9200,NeiGongATK=9200,YiShuATK=9200,QiMenATK=9200,AnQiATK=9200,RoundHP=8500,Roundmp=7500,MingZhongZhi=7500,ShanBiZhi=60000,BaoJiZhi=7500,BaoJiDiKang=7500,LianJiZhi=7500,LianJiDiKang=7500,},
  [16]={BaseID=16,Name="普通怪物+攻",TypeTemplate=RoleTypeTemplate.RTT_NormalMonsters_Gong,LiDao=10000,LingQiao=10000,NeiJin=10000,TiZhi=9000,JingLi=9000,WuXing=9000,MaxHp=7500,MP=7500,MartialATK=8500,Defence=7500,QuanZhangATK=9500,DaoFaATK=9500,TuiFaATK=9500,JianFaATK=9500,NeiGongATK=9500,YiShuATK=9500,QiMenATK=9500,AnQiATK=9500,RoundHP=7500,Roundmp=7500,MingZhongZhi=8500,ShanBiZhi=70000,BaoJiZhi=8500,BaoJiDiKang=7500,LianJiZhi=8500,LianJiDiKang=7500,},
  [17]={BaseID=17,Name="困难怪物",TypeTemplate=RoleTypeTemplate.RTT_DifficultMonsters,LiDao=10500,LingQiao=10500,NeiJin=10500,TiZhi=10500,JingLi=10500,WuXing=10500,MaxHp=9000,MP=9000,MartialATK=9000,Defence=9000,QuanZhangATK=10500,DaoFaATK=10500,TuiFaATK=10500,JianFaATK=10500,NeiGongATK=10500,YiShuATK=10500,QiMenATK=10500,AnQiATK=10500,RoundHP=9000,Roundmp=9000,MingZhongZhi=9000,ShanBiZhi=80000,BaoJiZhi=9000,LianJiZhi=9000,},
  [18]={BaseID=18,Name="困难怪物+血",TypeTemplate=RoleTypeTemplate.RTT_DifficultMonsters_Xue,LiDao=10500,LingQiao=10500,NeiJin=10500,TiZhi=12000,JingLi=10500,WuXing=10500,MP=9000,MartialATK=9000,Defence=9300,QuanZhangATK=10800,DaoFaATK=10800,TuiFaATK=10800,JianFaATK=10800,NeiGongATK=10800,YiShuATK=10800,QiMenATK=10800,AnQiATK=10800,Roundmp=9000,MingZhongZhi=9000,ShanBiZhi=90000,BaoJiZhi=9000,LianJiZhi=9000,},
  [19]={BaseID=19,Name="困难怪物+攻",TypeTemplate=RoleTypeTemplate.RTT_DifficultMonsters_Gong,LiDao=12000,LingQiao=12000,NeiJin=12000,TiZhi=10500,JingLi=10500,WuXing=10500,MaxHp=9000,MP=9000,Defence=9000,QuanZhangATK=11299,DaoFaATK=11299,TuiFaATK=11299,JianFaATK=11299,NeiGongATK=11299,YiShuATK=11299,QiMenATK=11299,AnQiATK=11299,RoundHP=9000,Roundmp=9000,ShanBiZhi=100000,},
  [20]={BaseID=20,Name="小BOSS怪物",TypeTemplate=RoleTypeTemplate.RTT_SmallBoos,LiDao=15000,LingQiao=15000,NeiJin=15000,TiZhi=15000,JingLi=15000,WuXing=15000,MaxHp=13000,MP=15000,MartialATK=15000,Defence=14400,QuanZhangATK=15000,DaoFaATK=15000,TuiFaATK=15000,JianFaATK=15000,NeiGongATK=15000,YiShuATK=15000,QiMenATK=15000,AnQiATK=15000,RoundHP=13000,Roundmp=15000,MingZhongZhi=15000,ShanBiZhi=110000,BaoJiZhi=15000,BaoJiDiKang=15000,LianJiZhi=15000,LianJiDiKang=15000,},
  [21]={BaseID=21,Name="小BOSS怪物+血",TypeTemplate=RoleTypeTemplate.RTT_SmallBoos_Xue,LiDao=15000,LingQiao=15000,NeiJin=15000,TiZhi=17000,JingLi=15000,WuXing=15000,MaxHp=16000,MP=15000,MartialATK=15000,Defence=15300,QuanZhangATK=15300,DaoFaATK=15300,TuiFaATK=15300,JianFaATK=15300,NeiGongATK=15300,YiShuATK=15300,QiMenATK=15300,AnQiATK=15300,RoundHP=16000,Roundmp=15000,MingZhongZhi=15000,ShanBiZhi=120000,BaoJiZhi=15000,BaoJiDiKang=15000,LianJiZhi=15000,LianJiDiKang=15000,},
  [22]={BaseID=22,Name="小BOSS怪物+攻",TypeTemplate=RoleTypeTemplate.RTT_SmallBoos_Gong,LiDao=18000,LingQiao=18000,NeiJin=18000,TiZhi=15000,JingLi=15000,WuXing=15000,MaxHp=13000,MP=15000,MartialATK=18000,Defence=14400,QuanZhangATK=16500,DaoFaATK=16500,TuiFaATK=16500,JianFaATK=16500,NeiGongATK=16500,YiShuATK=16500,QiMenATK=16500,AnQiATK=16500,RoundHP=13000,Roundmp=15000,MingZhongZhi=18000,ShanBiZhi=130000,BaoJiZhi=18000,BaoJiDiKang=15000,LianJiZhi=18000,LianJiDiKang=15000,},
  [23]={BaseID=23,Name="大BOSS怪物",TypeTemplate=RoleTypeTemplate.RTT_BigBOSS,LiDao=25000,LingQiao=25000,NeiJin=25000,TiZhi=25000,JingLi=25000,WuXing=25000,MaxHp=22000,MP=25000,MartialATK=25000,Defence=24100,QuanZhangATK=25000,DaoFaATK=25000,TuiFaATK=25000,JianFaATK=25000,NeiGongATK=25000,YiShuATK=25000,QiMenATK=25000,AnQiATK=25000,RoundHP=22000,Roundmp=25000,MingZhongZhi=25000,ShanBiZhi=140000,BaoJiZhi=25000,BaoJiDiKang=25000,LianJiZhi=25000,LianJiDiKang=25000,},
  [24]={BaseID=24,Name="大BOSS怪物+血",TypeTemplate=RoleTypeTemplate.RTT_BigBOSS_Xue,LiDao=25000,LingQiao=25000,NeiJin=25000,TiZhi=28000,JingLi=25000,WuXing=25000,MaxHp=27000,MP=25000,MartialATK=25000,Defence=25600,QuanZhangATK=25500,DaoFaATK=25500,TuiFaATK=25500,JianFaATK=25500,NeiGongATK=25500,YiShuATK=25500,QiMenATK=25500,AnQiATK=25500,RoundHP=27000,Roundmp=25000,MingZhongZhi=25000,ShanBiZhi=150000,BaoJiZhi=25000,BaoJiDiKang=25000,LianJiZhi=25000,LianJiDiKang=25000,},
  [25]={BaseID=25,Name="大BOSS怪物+攻",TypeTemplate=RoleTypeTemplate.RTT_BigBOSS_Gong,LiDao=30000,LingQiao=30000,NeiJin=30000,TiZhi=28000,JingLi=28000,WuXing=28000,MaxHp=22000,MP=28000,MartialATK=30000,Defence=26200,QuanZhangATK=29000,DaoFaATK=29000,TuiFaATK=29000,JianFaATK=29000,NeiGongATK=29000,YiShuATK=29000,QiMenATK=29000,AnQiATK=29000,RoundHP=22000,Roundmp=28000,MingZhongZhi=30000,ShanBiZhi=160000,BaoJiZhi=30000,BaoJiDiKang=28000,LianJiZhi=30000,LianJiDiKang=28000,},
  [26]={BaseID=26,Name="天命之人",TypeTemplate=RoleTypeTemplate.RTT_GodChoosePerson,LiDao=17000,LingQiao=7000,TiZhi=11000,JingLi=10000,WuXing=9000,QuanZhangATK=24000,DaoFaATK=0,TuiFaATK=0,JianFaATK=0,NeiGongATK=0,YiShuATK=0,QiMenATK=0,AnQiATK=0,},
  [27]={BaseID=27,Name="任侠之人",TypeTemplate=RoleTypeTemplate.RTT_KnightErrant,LiDao=16000,LingQiao=9000,NeiJin=5000,WuXing=12000,QuanZhangATK=0,DaoFaATK=24000,TuiFaATK=0,JianFaATK=0,NeiGongATK=0,YiShuATK=0,QiMenATK=0,AnQiATK=0,},
  [28]={BaseID=28,Name="玲珑之人",TypeTemplate=RoleTypeTemplate.RTT_IntelligentPerson,LiDao=7000,LingQiao=17000,JingLi=9000,WuXing=11000,QuanZhangATK=0,DaoFaATK=0,TuiFaATK=24000,JianFaATK=0,NeiGongATK=0,YiShuATK=0,QiMenATK=0,AnQiATK=0,},
  [29]={BaseID=29,Name="不羁之客",TypeTemplate=RoleTypeTemplate.RTT_WildUnruly,LiDao=6000,LingQiao=18000,TiZhi=9000,QuanZhangATK=0,DaoFaATK=0,TuiFaATK=0,JianFaATK=24000,NeiGongATK=0,YiShuATK=0,QiMenATK=0,AnQiATK=0,},
  [30]={BaseID=30,Name="狂进之士",TypeTemplate=RoleTypeTemplate.RTT_Madman,LiDao=6000,NeiJin=16000,JingLi=7000,QuanZhangATK=0,DaoFaATK=0,TuiFaATK=0,JianFaATK=0,NeiGongATK=24000,YiShuATK=0,QiMenATK=0,AnQiATK=0,},
  [31]={BaseID=31,Name="阵法大师",TypeTemplate=RoleTypeTemplate.RTT_ZhenFa,LiDao=8000,NeiJin=8000,TiZhi=13000,JingLi=13000,WuXing=10000,NeiGongATK=24000,RoleCardDesc={"阵法","体质、精力",},},
}
for k,v in pairs(RoleStatus) do
    setmetatable(v, {['__index'] = RoleStatusDefault})
end

-- export table: RoleStatus
return RoleStatus
