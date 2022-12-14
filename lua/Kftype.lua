-- Auto generated by TableTool, Copyright ElectronicSoul@2017

-- import for enum types:
-- enum AttrType
-- enum TBoolean
require("common");


local KftypeDefault = {Attribute=AttrType.ATTR_NULL,Show=TBoolean.BOOL_YES,WaiGong=TBoolean.BOOL_NO,NeiGong=TBoolean.BOOL_NO,QingGong=TBoolean.BOOL_NO,YiShu=TBoolean.BOOL_NO,}
local Kftype= {
  [1]={BaseID=1,NameID=290006,id=7,uid=106,Attribute=AttrType.ATTR_ANQIJINGTONG,AttackAttribute=AttrType.ATTR_ANQIATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0006",WaiGong=TBoolean.BOOL_YES,},
  [2]={BaseID=2,NameID=290004,id=4,uid=103,Attribute=AttrType.ATTR_DAOFAJINGTONG,AttackAttribute=AttrType.ATTR_DAOFAATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0001",WaiGong=TBoolean.BOOL_YES,},
  [3]={BaseID=3,NameID=290003,id=3,uid=102,Attribute=AttrType.ATTR_JIANFAJINGTONG,AttackAttribute=AttrType.ATTR_JIANFAATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0002",WaiGong=TBoolean.BOOL_YES,},
  [4]={BaseID=4,NameID=290008,id=14,uid=201,Attribute=AttrType.ATTR_NEIGONGJINGTONG,AttackAttribute=AttrType.ATTR_NEIGONGATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0008",NeiGong=TBoolean.BOOL_YES,},
  [5]={BaseID=5,NameID=290007,id=8,uid=107,Attribute=AttrType.ATTR_QIMENJINGTONG,AttackAttribute=AttrType.ATTR_QIMENATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0005",WaiGong=TBoolean.BOOL_YES,},
  [6]={BaseID=6,NameID=290009,id=15,uid=301,AttackAttribute=AttrType.ATTR_QingGongGongJi,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0007",QingGong=TBoolean.BOOL_YES,},
  [7]={BaseID=7,NameID=290002,id=2,uid=101,Attribute=AttrType.ATTR_QUANZHANGJINGTONG,AttackAttribute=AttrType.ATTR_QUANZHANGATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0003",WaiGong=TBoolean.BOOL_YES,},
  [8]={BaseID=8,NameID=290005,id=5,uid=104,Attribute=AttrType.ATTR_TUIFAJINGTONG,AttackAttribute=AttrType.ATTR_TUIFAATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0004",WaiGong=TBoolean.BOOL_YES,},
  [9]={BaseID=9,NameID=290010,id=16,uid=401,Attribute=AttrType.ATTR_YISHUJINGTONG,AttackAttribute=AttrType.ATTR_YISHUATK,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_0009",YiShu=TBoolean.BOOL_YES,},
  [10]={BaseID=10,NameID=290001,id=1,uid=100,AttackAttribute=AttrType.ATTR_NULL,Show=TBoolean.BOOL_NO,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_000a",},
  [11]={BaseID=11,NameID=290013,id=21,uid=100,AttackAttribute=AttrType.ATTR_NULL,Show=TBoolean.BOOL_NO,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_000a",},
  [13]={BaseID=13,NameID=290012,id=20,uid=100,AttackAttribute=AttrType.ATTR_NULL,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_000b",},
  [15]={BaseID=15,NameID=290011,id=19,uid=700,AttackAttribute=AttrType.ATTR_NULL,Show=TBoolean.BOOL_NO,IncompleteBookIcon="ItemIcon/canzhang/icon_eauip_canzhang_000a",},
}
for k,v in pairs(Kftype) do
    setmetatable(v, {['__index'] = KftypeDefault})
end

-- export table: Kftype
return Kftype
