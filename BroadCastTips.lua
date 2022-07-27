-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum BroadCastTipsNameType
-- enum TBoolean
require("common");


local BroadCastTipsDefault = {IsBarrage=TBoolean.BOOL_YES,IsChatbox=TBoolean.BOOL_YES,}
local BroadCastTips= {
  [1]={BaseID=1,TipsName=BroadCastTipsNameType.BCTNT_ZhuWei,TipsText="%s对%s进行舞龙舞狮助威，祝他旗开得胜。",},
  [2]={BaseID=2,TipsName=BroadCastTipsNameType.BCTNT_DaZhongLeiTai,TipsText="%s在大众赛%s中战胜了%s。",},
  [3]={BaseID=3,TipsName=BroadCastTipsNameType.BCTNT_DaShiLeiTai,TipsText="%s在大师赛%s中战胜了%s。",},
  [4]={BaseID=4,TipsName=BroadCastTipsNameType.BCTNT_QieCuoShengLi,IsBarrage=TBoolean.BOOL_NO,TipsText="%s在切磋中战胜了%s。",},
  [5]={BaseID=5,TipsName=BroadCastTipsNameType.BCTNT_WaBaoAnJin,TipsText="%s鸿运当头，在藏宝洞穴中获得了%s。",},
  [6]={BaseID=6,TipsName=BroadCastTipsNameType.BCTNT_MoJunTongGuan,TipsText="%s通关了难度%d魔君乱江湖剧本，达成“%s”结局。",},
  [7]={BaseID=7,TipsName=BroadCastTipsNameType.BCTNT_ZiYouTongGuan,TipsText="%s通关了难度%d自由模式剧本，达成“%s”结局。",},
  [8]={BaseID=8,TipsName=BroadCastTipsNameType.BCTNT_XiaKeXingAnjin,TipsText="%s获得%s，可喜可贺！",},
  [9]={BaseID=9,TipsName=BroadCastTipsNameType.BCTNT_DuoBaoPuTong_KaiQi,TipsText="侠客行中出现了夺宝目标%s",},
  [10]={BaseID=10,TipsName=BroadCastTipsNameType.BCTNT_DuoBaoPuTong_JieShu,TipsText="%s在侠客行夺宝中获得%s",},
  [11]={BaseID=11,TipsName=BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_KaiQi,TipsText="侠客行中出现了稀有夺宝目标%s",},
  [13]={BaseID=13,TipsName=BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_JieShu,TipsText="%s在侠客行夺宝中获得稀有奖励%s",},
  [14]={BaseID=14,TipsName=BroadCastTipsNameType.BCTNT_LeiTaiKaiShi,TipsText="擂台赛将于今晚20点准时开启，围观看大神，助威拿奖励！",},
  [15]={BaseID=15,TipsName=BroadCastTipsNameType.BCTNT_DengLuCiTongYong,TipsText="%s",},
  [16]={BaseID=16,TipsName=BroadCastTipsNameType.BCTNT_DuoBaoPuTong_ZhuGong,TipsText="%s在侠客行夺宝中位居贡献头名，获得%s",},
  [17]={BaseID=17,TipsName=BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_ZhuGong,TipsText="%s在侠客行夺宝中位居贡献头名，获得稀有奖励%s",},
  [18]={BaseID=18,TipsName=BroadCastTipsNameType.BCTNT_JiBan,TipsText="%s将羁绊%s升到了%s级，友情日益坚固！",},
  [19]={BaseID=19,TipsName=BroadCastTipsNameType.BCTNT_WanMeiAnJin,TipsText="%s洪福齐天，获得了满词条的暗金装备%s，即将称霸江湖！",},
}
for k,v in pairs(BroadCastTips) do
    setmetatable(v, {['__index'] = BroadCastTipsDefault})
end

-- export table: BroadCastTips
return BroadCastTips
