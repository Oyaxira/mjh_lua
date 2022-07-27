SKILL_EFFECT_DEPTH = {
    ON_CURROLE_UP = 1,
    ON_CURROLE_DOWN = 2,
    ON_ALLROLE_UP=3,
    ON_ALLROLE_DOWN=4,
    ON_CURROLE_LINE=5,
}
SKILL_EFFECT_MOUNT_NAME = {
    SCREEN_CENTER=1,
    SKILL_CAST_POS=2,
    ANQI_CASE_POS=3,
}


SPINE_BONE_NAME_DEFALUT = "ref_waist_dec02"
SPINE_BONE_NAME_DEFALUT_BUFF = "root"
SPINE_DEFAULT_ANIMATION = "prepare"

ItemTypeMap = {
    [ItemTypeDetail.ItemType_Fan] = 's',
    [ItemTypeDetail.ItemType_Knife] = 's',
    [ItemTypeDetail.ItemType_Sword] = 's',
    [ItemTypeDetail.ItemType_Fist] = 'f',
    [ItemTypeDetail.ItemType_Rod] = 'r',
}

ItemTypeToPrepareMap = {
    [ItemTypeDetail.ItemType_Fan] = 'prepare_s',
    [ItemTypeDetail.ItemType_Knife] = 'prepare_s',
    [ItemTypeDetail.ItemType_Sword] = 'prepare_s',
    [ItemTypeDetail.ItemType_Fist] = 'prepare_f',
    [ItemTypeDetail.ItemType_Rod] = 'prepare_r',
}

SPINE_ATTACK_TYPE = {
    's',--刀 1
    's',--剑 2
    'f',--拳 3
    'r',--棍 4
    'l',--腿 5
}
SPINE_ATTACK_TYPE_INDEX_Revert = {
    ['s'] = 1,
    ['s'] = 2,
    ['f'] = 3,
    ['r'] = 4,
    ['l'] = 5,
}

SPINE_ATTACK_TYPE_Revert = {
    ['刀']='s',
    ['剑']='s',
    ['拳']='f',
    ['棍']='r',
    ['腿']='l',
}

SPINE_ANIM_DEFAULT_ITEM = {
    [1] = 413102,
    [2] = 412102,
    [4] = 415102
}


SPINE_DEFAULT_ATTACK_TYPE = 'g'
SPINE_BONE_NAME_ANQI = "ref_chest"


SPEED_TYPE = {
    BATTLE=1,
    SKILL=2,
    ROUND=3,
    NORMAL=4,
}

GRID_DEFAULT = {['x']=1,['y']=1}

NO_VAILD_GRID_XY = 100


BattleName = {
    ["默认"] = 1,
    ["标准"] = 2,
    ["拳师"] = 3,
    ["刀客"] = 4,
    ["腿师"] = 5,
    ["剑客"] = 6,
    ["内功大师"] = 7,
    ["医生"] = 8,
    ["棍师"] = 9,
    ["镖客"] = 10,
    ["简单怪物"] = 11,
    ["简单怪物+血"] = 12,
    ["简单怪物+攻"] = 13,
    ["普通怪物"] = 14,
    ["普通怪物+血"] = 15,
    ["普通怪物+攻"] = 16,
    ["困难怪物"] = 17,
    ["困难怪物+血"] = 18,
    ["困难怪物+攻"] = 19,
    ["小BOSS怪物"] = 20,
    ["小BOSS怪物+血"] = 21,
    ["小BOSS怪物+攻"] = 22,
    ["大BOSS怪物"] = 23,
    ["大BOSS怪物+血"] = 24,
    ["大BOSS怪物+攻"] = 25,
    ["天命之人"] = 26,
    ["任侠之人"] = 27,
    ["玲珑之人"] = 28,
    ["不羁之客"] = 29,
    ["狂进之士"] = 30,
  
    --参数2
    ['？？？'] = 100,
    ['龙神圣女'] = 101,
    ['随机生成一个名字'] = 102,
    ['赤刀门护法'] = 103,
    ['赤刀门地痞'] = 104,
    ['禁军教头'] = 105,
    ['禁军将领'] = 106,
    ['神志不清的人'] = 107,
    ['盗墓贼首领'] = 108,
    ['禁军将领'] = 109,
    ['白衣教高手'] = 110,
    ['白衣教密探'] = 111,
    ['白衣刺客'] = 112,
    ['狂·拜月弟子'] = 113,
    ['狂·恒山弟子'] = 114,
    ['狂·峨嵋弟子'] = 115,
    ['焦荣大师'] = 116,
    ['游戏玩法逻辑_通用_随机姓名'] = 117,
    ['段正明'] = 118,
    ['打手'] = 119,
    ['恶霸'] = 120,
    ['山贼头领'] = 121,
    ['山贼'] = 122,
    ['小boos怪物'] = 123,
    ['小boss怪物'] = 124,
    ['大boss怪物'] = 125,
    ['地痞'] = 126,
    ['丐帮弟子'] = 127,
    ['白衣教弟子'] = 128,
    ['官兵'] = 129,
  }
  
  BattleName_Revert = {
  [11] = "简单怪物",
  [128] = "白衣教弟子",
  [112] = "白衣刺客",
  [21] = "小BOSS怪物+血",
  [120] = "恶霸",
  [26] = "天命之人",
  [103] = "赤刀门护法",
  [15] = "普通怪物+血",
  [118] = "段正明",
  [7] = "内功大师",
  [117] = "游戏玩法逻辑_通用_随机姓名",
  [20] = "小BOSS怪物",
  [17] = "困难怪物",
  [124] = "小boss怪物",
  [107] = "神志不清的人",
  [1] = "默认",
  [129] = "官兵",
  [19] = "困难怪物+攻",
  [127] = "丐帮弟子",
  [28] = "玲珑之人",
  [25] = "大BOSS怪物+攻",
  [8] = "医生",
  [101] = "龙神圣女",
  [126] = "地痞",
  [125] = "大boss怪物",
  [110] = "白衣教高手",
  [119] = "打手",
  [2] = "标准",
  [16] = "普通怪物+攻",
  [14] = "普通怪物",
  [5] = "腿师",
  [122] = "山贼",
  [123] = "小boos怪物",
  [104] = "赤刀门地痞",
  [4] = "刀客",
  [114] = "狂·恒山弟子",
  [13] = "简单怪物+攻",
  [113] = "狂·拜月弟子",
  [111] = "白衣教密探",
  [9] = "棍师",
  [22] = "小BOSS怪物+攻",
  [121] = "山贼头领",
  [27] = "任侠之人",
  [109] = "禁军将领",
  [108] = "盗墓贼首领",
  [100] = "？？？",
  [116] = "焦荣大师",
  [102] = "随机生成一个名字",
  [105] = "禁军教头",
  [3] = "拳师",
  [6] = "剑客",
  [18] = "困难怪物+血",
  [29] = "不羁之客",
  [24] = "大BOSS怪物+血",
  [23] = "大BOSS怪物",
  [12] = "简单怪物+血",
  [30] = "狂进之士",
  [10] = "镖客",
  [115] = "狂·峨嵋弟子",
  }


  SKILL_CAST_REASON = {
    [BSET_Null] =           270020,
    [BSET_ZhuDong] =        270021,
    [BSET_JueZhao] =        270022,
    [BSET_HeJiQiDong] =     270023,
    [BSET_Combo] =          270024,
    [BSET_LianJi] =         270025,
    [BSET_FightBack] =      270026,
    [BSET_BeiDong] =        270027,
    [BSET_LianZhao] =       270028,
    [BSET_ZhuiJia] =        270029,
    [BSET_TouGuZhuiJia] =   270030,
  }

RoundSpeedInfo = {
    {5,0.5},    --第几轮开始 回合速度变成 几 ；>= 开始变
    {10,1},
    {17,1}
}

MutilAnqiTag = 
{
	MT_NULL = 0,
	MT_START = 1,
	MT_END = 2,
    MT_CHILD = 3,
    MT_FRIENDADDTIMES=4,--队友增加次数
    MT_SHOWINLOG = 5,--标记需要显示在日志中
}

easings = {
    [0]=DRCSRef.Ease.Linear,
    DRCSRef.Ease.InSine,
    DRCSRef.Ease.OutSine,
    DRCSRef.Ease.InOutSine,
    DRCSRef.Ease.InCubic,
    DRCSRef.Ease.OutCubic,
}


WEAPON_NODE = {
    -- 护腿
    [ItemTypeDetail.ItemType_Cane] = 
    {
        ["Count"] = 2,
        ["Node"] = {
            "ref_foot_right",
            "ref_foot_left",
        }
    },
    -- 拳头
    [ItemTypeDetail.ItemType_Fist] = 
    {
        ["Count"] = 2,
        ["Node"] = {
            "ref_hand_right",
            "ref_hand_left",
        }
    },
    -- 暗器
    [ItemTypeDetail.ItemType_HiddenWeapon] = 
    {
        ["Count"] = 1,
        ["Node"] = "ref_weapon_right",
    },
}

DEFAULT_SPINE_WEAPON_BONE = "ref_weapon_right"
IDEL_SPINE_WEAPON_BONE = "ref_weapon_idle"


HEADICON_SPEED_RATIO = 0.8
HEADICON_SPEED_PAUSE = 100
SCALE_BATTLE_FIELD = 1.0
POSITION_BATTLE_FIELD = DRCSRef.Vec3(0.5,0,0)
SCALE_BATTLE_UNIT = 0.43

GRID_COLOR_INDEX = {
    ['Blue'] = 0,
    ['Green'] = 1,
    ['Red'] = 2,
    ['Gray'] = 3,
    ['Skill'] = 4,
    ['Yellow'] = 5,
}

SPEND_TIME_CANYING = 200
SPEND_TIME_CANYING_F = 0.2


BATTLE_POS_X_LEFT = -10
BATTLE_POS_X_RIGHT = 10


TEST_BOSS_LIST = false


ANQI_IS_CURE_MARTIAL = {
    [10301] = 25,
    [10322] = 25,
    [10323] = 10,
    [10319] = 15,
    [10321] = 30,
    [10320] = 25,
}

SWITCH_LOG_OTHER = true