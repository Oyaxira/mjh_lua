-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum PlayerInfoType
-- enum TBoolean
require("common");


local PlayerInfoDefault = {UnlockID=1,NameID=0,ResourceID=0,StartUnlock=TBoolean.BOOL_YES,WriterNameID=0,TextID=0,PicPath="",ShowPath="",PicType=0,IconPath="",ModelPath="",ModelAnimation=0,ActiveTime=0,TopLimit=0,OnlySelf=TBoolean.BOOL_NO,IsChatbox=TBoolean.BOOL_NO,IsBarrage=TBoolean.BOOL_NO,BottomPicPath="",Value=0,}
local PlayerInfo= {
  [10010001]={BaseID=10010001,Type=PlayerInfoType.PIT_CG,ResourceID=1,},
  [10020007]={BaseID=10020007,UnlockID=7,Type=PlayerInfoType.PIT_BGM,ResourceID=3002,},
  [10030002]={BaseID=10030002,UnlockID=2,Type=PlayerInfoType.PIT_POERTY,},
  [10040025]={BaseID=10040025,UnlockID=25,Type=PlayerInfoType.PIT_PAINT,ResourceID=218,},
  [10050021]={BaseID=10050021,UnlockID=21,Type=PlayerInfoType.PIT_MODEL,ResourceID=215,},
  [10060001]={BaseID=10060001,Type=PlayerInfoType.PIT_PEDESTAL,PicPath="Platform/list_nml",ShowPath="Platform/img_nml",},
  [10070001]={BaseID=10070001,Type=PlayerInfoType.PIT_LOGINWORD,IconPath="LoginWord/Icon/loginword_icon_3",ActiveTime=5000,TopLimit=5000,OnlySelf=TBoolean.BOOL_YES,IsChatbox=TBoolean.BOOL_YES,IsBarrage=TBoolean.BOOL_YES,BottomPicPath="LoginWord/Bottom/loginword_bottom_1",},
  [10080011]={BaseID=10080011,UnlockID=11,Type=PlayerInfoType.PIT_HEADBOX,},
  [10090001]={BaseID=10090001,Type=PlayerInfoType.PIT_LANDLADY,IconPath="CharacterCG/major/major_laobanniang_jiuguan",ModelPath="role_laobanniang",},
  [10110001]={BaseID=10110001,Type=PlayerInfoType.PIT_TEAPOT,IconPath="PlayerDecoration/img_001",ModelPath="Effect/Ui_eff/jiuguan_animation/jiuguan_hu",ModelAnimation=1869577849,},
}
for k,v in pairs(PlayerInfo) do
    setmetatable(v, {['__index'] = PlayerInfoDefault})
end

-- export table: PlayerInfo
return PlayerInfo
