function GetEnumValue(sEnum, key)
    if not (type(sEnum) == 'string' and key ~= nil) then
        return nil
    end
    if type(_G[sEnum]) == 'table' then
        return _G[sEnum][key]
    end
    return nil
end

function GetEnumValueByRevertData(sEnum, sRevertKey)
    if not (type(sEnum) == 'string' and type(sRevertKey) == 'string') then
        return nil
    end
    local enumTableName = sEnum .. '_Revert'
    return GetEnumValue(enumTableName, sRevertKey)
end

function GetEnumValueLanguageID(sEnum, key)
    if not (type(sEnum) == 'string' and key ~= nil) then
        return nil
    end
    local enumTableName = sEnum .. '_Lang'
    return GetEnumValue(enumTableName, key)
end

function GetEnumText(sEnum, key)
    local langID = GetEnumValueLanguageID(sEnum, key)
    if (langID) then
        local text = GetLanguageByID(langID)
        return text
    end
    return nil
end

DEFAULT_IP = "192.168.0.23"
DEFAULT_PORT = 3628
DEFAULT_SERVERINDEX = 1
DEFAULT_SERVERNAME = "main"

TOPTITLE_TYPE = {
    TT_NULL = 0,
    TT_MAP = 1,
    TT_BIGMAP = 2,
    TT_MAZE = 3,
    TT_FINALBATTLE = 4,
}

PICKITEM_TYPE = {
    PI_NULL = 0,
    PI_NORMAL = 1,          -- 常规
    PI_INFO = 2,       -- 任务 info
    PI_ICON = 3,       -- 任务 icon
}

SPINE_ANIMATION =
{
    ['MOVE'] = "move" ,
    ['BATTLE_IDEL'] = "prepare",
    ['BOX_OPEN'] = "open",
    ['BOX_DISAPPEAR'] = "disappear"
}

COLOR_ENUM =
{
    ["Green"] = 1,
    ["Red"] = 2,
    ["Yellow"] = 3,
    ["White"] = 4,
    ["Gray"] = 5,
    ["Blue"] = 6,
    ["Purple"] = 7,
    ["Pink"] = 8,
    ["Douzi_brown"] = 20,
    ["WhiteGray"] = 25,
    ["Black"] = 26,
}

OPT_STATE =
{
    CHOOSE_POS = 1, --选择位置中
    CHOOSE_SKILL = 2, --选择技能中
    CHOOSE_END = 0, --选择结束
}

ROLE_TYPE =
{
    ["BASE_ROLE"] = 0,
    ["INST_ROLE"] = 1,
    ["NPC_ROLE"] = 2,
    ["BATTLE_ROLE"] = 3,
    ["HOUSE_ROLE"] = 4,
}

BACKPACKUI_TYPE =
{
    ["GIVE_GIFT"] = 1,
}

GeneralBoxType =
{
    ["SYSTEM_TIP"] = 1,         -- 系统提示
    ["BATTLE_GIVEUP"] = 2,      -- 战斗认输确认
    ["COMMON_TIP"] = 3,
    ["Pay_TIP"] = 4,
    ["COSTITEM_TIP"] = 5,
    ["COMMON_TIP_WITH_BTN"] = 6,
    ["SYSTEM_TIP_NEXT"] = 7,
    ["SYSTEM_RESTART"] = 8,
    ["SYSTEM_Reconnect"] = 9,
    ["HTTP_LOGIN_NET_ERROR"] = 10,
    ['BATTLE_DEFEATED'] = 11,             -- 认输
    ['ARENA_TIP'] = 12,             --
    ['DELETE_SCRIPT'] = 13,         -- 删档
    ["BATTLE_AI_TIP"] = 14,
    ["EMERGENCY_RESET"] = 15,  -- 紧急结束周目
    ["CHALLENGEORDER_TIP"] = 16,  -- 购买完整版
    ["CREDIT_SCENELIMIT"] = 17,  -- 腾讯信用分
    ["STORY_WEEK_TAKEOUT_LIMIT"] = 19,
}

StorageOutItemType = {
    SOIT_LEFT = 1,
    SOIT_RIGHT = 2,
}

ShooseRoleUIType = {
    SRUIT_ChooseNPCMaster = 1,
    SRUIT_ChooseRoleChallenge = 2,
}

DisplayActionType = {
    -- 通用
    COMMON_CHANGE_SCENE = 2,        -- 切换场景
    -- 界面行为
    WIN_OPEN = 101,   -- 打开界面 OpenWindow
    WIN_REMOVE = 102,   -- 关闭界面 RemoveWindow
    WIN_UNLOAD = 103,  -- 关闭所有界面
    -- 动画行为
    -- 剧情类型
    PLOT_DIALOGUE = 201, -- 对话
    PLOT_CHOOSE = 202, -- 选择选项
    PLOT_SHOW_CHOOSE_TEXT = 203, -- 显示文字
    PLOT_SHOW_CHOOSE_TEXT_STR = 249, -- 显示文字
    PLOT_CUSTOM_CHOICE= 244, -- 自定义选项
    PLOT_OPEN_OBSERVE_WINDOW = 204, -- 打开观察界面
    PLOT_OPEN_ZANGJINGGE = 205, -- 打开藏经阁学武
    PLOT_MAZE_PLAY_CLICK_ROLE_ANIM = 206, -- 迷宫_播放点击角色动画
    PLOT_SHOW_BLACK_BACKGROUND = 207, -- 淡出画面
    PLOT_HIDE_BLACK_BACKGROUND = 208, -- 淡入画面
    PLOT_CATOON = 209,              -- 动画
    PLOT_BIGMAPLINEANIM = 211,          -- 大地图连线动画
    PLOT_SHOW_ROLE_INTERACT_UI = 212, -- 显示交互界面
    PLOT_WAIT = 213, -- 等待
    PLOT_SHOW_IMG = 214, -- 剧情_显示图片
    PLOT_MOVE_IMG = 215, -- 剧情_移动图片
    PLOT_REMOVE_IMG = 216, -- 剧情_删除图片
    PLOT_WAIT_CLICK = 217, -- 剧情_等待点击屏幕
    PLOT_CLOSE_STORE = 218, -- 剧情_关闭商店
    PLOT_OPEN_WINDOW = 219, -- 打开界面
    -- PLOT_SHOW_CLAN_DETAIL = 220, -- 显示门派详情-- 使用OpenWindow
    PLOT_LINSHI_JUESE_DUIHUA = 221, -- 临时对话角色
    PLOT_ENTER_CITY = 222, -- 进入城市
    PLOT_TASK_COMPLETE = 223, -- 任务完成界面
    PLOT_MONTH_EVOLUTION = 224, -- 月度演化界面
    PLOT_CUSTEM_PLOT = 225, -- 自定义plot
    PLOT_SHOW_FOREGROUND = 226, -- 显示前景
    PLOT_OB_ROLE = 227, -- 观察角色
    PLOT_MAZE_MOVE = 228, -- 迷宫移动
    PLOT_DIALOGUE_STR = 229, -- 自定义对话
    PLOT_LEVELUP = 230,  -- 等级提升
    PLOT_OPEN_SELECT_CLAN = 231,  -- 打开选择门派界面
    PLOT_MAZE_GRID_UNLOCK_ANIM = 232,  -- 迷宫格解锁动画
    PLOT_SHOW_DANMU = 233,          -- 显示弹幕
    PLOT_SHOW_BATTLEBUBBLE = 234,    -- 显示气泡
    PLOT_MAZE_TRIGGER_ADV_GIFT = 235,    -- 迷宫冒险天赋触发
    PLOT_TOAST = 236,    -- 弹出 toast
    PLOT_SHOW_CLAN_INFO = 237,    -- 显示门派信息界面
    PLOT_MAP_MOVE = 238,    -- 地图移动
    PLOT_SHOW_FORGEMAKE = 239,  -- 打开制造界面
    PLOT_SHOW_GOLD_ANIM = 240,  -- 获得金币动画
    PLOT_TASK_BROADCAST_TIPS = 241,  -- 任务广播下行提示
    PLOT_ROLE_LVUP = 242,  -- 角色等级提升
    PLOT_MARTIAL_LVUP = 243,  -- 武学等级提升
    PLOT_SHOW_PLOTFOREGROUND = 245,  -- 剧情显示前景
    PLOT_REMOVE_PLOTFOREGROUND = 246,  -- 剧情移除前景
    PLOT_OPEN_MARRY_CONSULT = 247, -- 誓约骗婚请教武学
    PLOT_OPEN_CLANMARTIAL = 248, -- 打开门派学武界面
    PLOT_BATTLE_INSERT_ROUND_INFO = 250,-- 战斗界面_回合数提示插入信息
    PLOT_OPEN_INTERACT_LEARN = 251, --打开交互学习界面
    PLOT_OPEN_OBSBABY = 252, -- 打开徒弟观察界面
    PLOT_OPEN_GETBABY = 253, -- 打开获得徒弟
    PLOT_OPEN_FINALBATTLE_EMBATTLE = 254, -- 大决战布阵界面
    PLOT_START_GUIDE = 255, -- 开启引导

    PLOT_SHOWDATA_END_RECORD_DEQUEUE = 256, -- 显示数据记录出队
    PLOT_PLAY_SOUND = 257, -- 播放音效
    PLOT_BIGMAPMOVE_ENTERCITY = 258, -- 地图移动动画，结束后继续剧情
    PLOT_MAZE_SHOW_BUBBLE = 259, -- 迷宫显示成员气泡
    PLOT_HIDE_MENU_LAYER = 260, -- 隐藏菜单界面
    PLOT_RECOVER_MENU_LAYER = 261, -- 恢复菜单界面
    PLOT_SHOW_CHOICE_WINDOW = 262, -- 显示选项界面
    UPDATE_MAZE_UI = 263, -- 更新迷宫界面
    MAZE_ENEMY_ESCAPE = 264, -- 迷宫敌人逃跑逻辑
    RECOVER_INTERACT_STATE = 265, -- 还原交互界面
    PLOT_CHANGE_SCRIPT = 266,  -- 跳转剧本
    UPDATE_MAZE_GRID_UI = 267, -- 更新迷宫格
    PLOT_NETMSG_TOAST = 268, -- Toast下发消息
    PLOT_SET_TEMP_BACKGROUND = 269, -- 设置临时背景
    PLOT_REMOVE_TEMP_BACKGROUND = 270, -- 移除临时背景
    PLAY_AUDIO = 271, -- 播放音乐
    PLOT_HIGHTOWER_REGIMENT_EMBATTLE = 272, -- 千层塔进入混战布阵界面
    PLOT_HIGHTOWER_STAGE_REWARD = 273, -- 千层塔显示奖励界面
    PLOT_MAP_ROLE_ESCAPE = 274, -- 地图角色逃跑逻辑
    PLOT_SUBMIT_ITEM = 275,     -- 提交物品

    PLOT_OPEN_RANDOM_ROLL = 276,     -- 打开交互随机界面
    PLOT_OPEN_HUASHAN_RANK = 277,     -- 华山排行榜
    PLOT_PLAY_MAP_ROLE_ANIM = 278,     -- 播放地图角色动画
    PLOT_UPDATE_MAP_EFFECT = 279,     -- 更新地图效果

    PLOT_REMOVE_GIVEGIFTUI = 280,      -- 移除送礼界面
    PLOT_RECOVE_GIVEGIFTUI = 281,      -- 恢复送礼界面
    PLOT_EXECUTE_PLOT = 282,      -- 执行剧情
    PLOT_ANIM_OPENEYE = 283,        -- 睁眼动画
    PLOT_OPEN_SCRIPT_ARENA = 284,      -- 打开剧本擂台
    PLOT_CLOSE_FORGEMAKE = 285,       -- 关闭生产界面
    PLOT_OPEN_DISCOUNTUI = 286,       -- 开启折扣分享界面
    PLOT_OPEN_ROLE_CHALLENGE = 287,       -- 武神殿选择角色

    PLOT_OPEN_COLLECT_ACTIVITY = 288,       -- 打开收集活动
    PLOT_OPEN_MULTDROP_ACTIVITY = 289,      -- 打开多倍奖励

    PLOT_NPC_CITY_MOVE = 290,      -- 大地图NPC移动

    PLOT_ROLE_CHOICE= 291, -- 角色自定义选项

    PLOT_OPENLIMITSHOP= 292, -- 打开限时商店
    PLOT_PLAY_VOCAL= 293, -- 播放语音
    PLOT_DIALOGUE_LIMITSHOP= 294, -- 限时商店对话

    PLOT_OPEN_LEVEL_UP = 295,  -- 打开升级界面
    PLOT_CAMERA_ANIM = 296,  -- 大地图相机动画
}

DisplayActionType_Revert =
{
    [1] = "执行自定义函数",
    [2] = "切换场景",
    [101] = "打开界面",
    [102] = "关闭界面",
    [103] = "关闭所有界面",
    [201] = "对话",
    [202] = "选择选项",
    [203] = "显示文字",
    [204] = "打开观察界面",
    [205] = "打开藏经阁学武",
    [206] = "迷宫_播放点击角色动画",
    [207] = "淡出画面",
    [208] = "淡入画面",
    [209] = "动画",
    [210] = "进入地图",
    [211] = "大地图连线动画",
    [212] = "显示交互界面",
    [213] = "等待",
    [214] = "剧情_显示图片",
    [215] = "剧情_移动图片",
    [216] = "剧情_删除图片",
    [217] = "剧情_等待点击屏幕",
    [218] = "剧情_关闭商店",
    [219] = "打开界面",
    [221] = "临时对话角色",
    [222] = "进入城市",
    [223] = "任务完成界面",
    [224] = "月度演化界面",
    [225] = "自定义plot",
    [226] = "显示前景",
    [227] = "观察角色",
    [228] = "迷宫移动",
    [229] = "自定义对话",
    [230] = "等级提升",
    [231] = "打开选择门派界面",
    [232] = "迷宫格解锁动画",
    [233] = "显示弹幕",
    [234] = "显示气泡",
    [235] = "迷宫冒险天赋触发",
    [236] = "弹出 toast",
    [237] = "显示门派信息界面",
    [238] = "地图移动",
    [239] = "打开制造界面",
    [240] = "获得金币动画",
    [241] = "任务广播下行提示",
    [242] = "角色等级提升",
    [243] = "武学等级提升",
    [244] = "自定义选项",
    [245] = "剧情显示前景",
    [246] = "剧情移除前景",
    [262] = "显示选项界面",
    [263] = "更新迷宫界面",
    [264] = "迷宫敌人逃跑逻辑",
    [265] = "还原交互界面",
    [267] = "更新迷宫格",
    [271] = "播放音乐",
    [275] = "提交物品",
    [DisplayActionType.PLOT_PLAY_MAP_ROLE_ANIM] = '播放地图角色动画',
    [DisplayActionType.PLOT_EXECUTE_PLOT] = '执行剧情',
}

DropTypeDef = {
    DropType_Item = 0,          --默认物品
    DropType_RoleAttr = 1,      --角色属性
    DropType_Exp = 10,          --经验值
    DropType_Coin = 11,         --铜币
    DropType_Silver = 12,       --银锭
}

UIWindowState = {
    UNCREATE = 1,
    SHOW = 2,
    HIDE = 3
}

TaskNav = {
    ZhuXian = 1,        -- 主线
    LiLian = 2,         -- 历练
    JueSe = 3,          -- 角色
    ChuanWen = 4,       -- 传闻
    WeiTuo = 5,         -- 委托
    YiWanCheng = 6,     -- 已完成
    QiTa = 7            -- 其他
}

MAP_BUILDING_TYPE_FRAME = {
    [MapBuildingType.BT_BUILDING]= 'sc_frame_building',
    [MapBuildingType.BT_MAZE]= 'sc_frame_maze',
    [MapBuildingType.BT_CLAN]= 'sc_frame_building',
    [MapBuildingType.BT_HIGHCLAN]= 'sc_frame_highclan'
}

MAP_BUILDING_TYPE_ICON = {
    [MapBuildingType.BT_DOOR]= 'building_icon_door',
    [MapBuildingType.BT_BUILDING]= 'building_icon_build',
    [MapBuildingType.BT_MAZE]= 'building_icon_maze',
    [MapBuildingType.BT_CLAN]= 'building_icon_build',
    [MapBuildingType.BT_HIGHCLAN]= 'building_icon_build',
}

EQUIPMENT_ITEM_POS_ICON = {
    [REI_WEAPON] = '0003',          --武器
    [REI_CLOTH] = '0004',           --衣服
    [REI_JEWELRY] = '0007',         --饰品
    [REI_WING] = '0008',            --翅膀（改成披风了）
    [REI_THRONE] = '000a',           --神器
    [REI_SHOE] = '0005',            --鞋子
    [REI_RAREBOOK] = '0006',        --秘籍
    [REI_HORSE] = '0009',           --坐骑（楼下版本是神器2）
    [REI_ANQI] = '0001',            --暗器
    [REI_MEDICAL] = '000b',          --医术
}

-- 按照这个装备排序渲染表现
EQUIPMENT_ITEM_POS = {
    REI_WEAPON, REI_JEWELRY, REI_CLOTH, REI_SHOE, REI_THRONE, REI_HORSE,
    REI_RAREBOOK, REI_WING, REI_ANQI, REI_MEDICAL
}

--模型scale = BATTLE_ACTOR_SCALE * (BATTLE_ACTOR_SCALE_A ^ (iGridY - 1))
MODEL_DEFAULT_MODELID = 2
MODEL_DEFAULT_SPINE = 'role_black_man'
MODEL_DEFAULT_TEXTURE = 'Actor/role_black_man/role_black_man'
BATTLE_ACTOR_SCALE = 0.82 * 0.666
BATTLE_ACTOR_SCALE_A = 0.90
SKILL_SHOW_NUM_RATE = 100
BATTLE_ACTOR_Z = 0.2
BATTLE_MOVE_ICON_OFFSET_Y = 60

----begin 值在第一次进战斗的时候 初始化---
GRID_POS = nil
----end----

-- 收集宝物的动画
GOLD_ANIM = {
    ['GOLD'] = 1,
    ['SLIVER'] = 2,
    ['COIN'] = 3,
}

-- 弹出提示的类型
TOAST_TYPE = {
    ['NORMAL'] = 1,
    ['TASK'] = 2,
    ['SYSTEM'] = 3,
}

SCALE_CITY_BUILDING =
{
    ['wide']   = DRCSRef.Vec3(0.86,0.86,0.86),		-- 宽广布局
    ['wide_s'] = DRCSRef.Vec3(0.81,0.81,0.81),      -- 宽广布局【缩小】
    ['wide_c'] = DRCSRef.Vec3(0.89,0.89,0.89),      -- 宽广布局【点击】

    ['normal']   = DRCSRef.Vec3(0.9,0.9,0.9),	    -- 普通布局
    ['normal_s'] = DRCSRef.Vec3(0.85,0.85,0.85),    -- 普通布局【缩小】
    ['normal_c'] = DRCSRef.Vec3(0.93,0.93,0.93),    -- 普通布局【点击】

    ['EnterMapAnimDeltaTime'] = 9000,               -- 进入场景的时候建筑变大动画的时长
    ['time_show'] = 500,                            -- 展示动画时间
    ['width']   = 260,
}

COLOR_VALUE = {
    [COLOR_ENUM.Green] = DRCSRef.Color(0,1,0,1),
    [COLOR_ENUM.Red] = DRCSRef.Color(1,0,0,1),
    [COLOR_ENUM.Yellow] = DRCSRef.Color(1,1,0,1),
    [COLOR_ENUM.White] = DRCSRef.Color(1,1,1,1),
    [COLOR_ENUM.Gray] = DRCSRef.Color(0.5,0.5,0.5,1),
    [COLOR_ENUM.Blue] = DRCSRef.Color(9/255,241/255,241/255,1),
    [COLOR_ENUM.Purple] = DRCSRef.Color(0.7607843, 0.41568628, 0.9607843, 1),
    [COLOR_ENUM.Pink] = DRCSRef.Color(250/255, 122/255, 232/255, 1),
    [COLOR_ENUM.Douzi_brown] = DRCSRef.Color(0.7137255, 0.454902, 0.04705883,1),
    [COLOR_ENUM.WhiteGray] = DRCSRef.Color(0.8,0.8,0.8,1),
    [COLOR_ENUM.Black] = DRCSRef.Color(0,0,0,1),
}

RANK_COLOR = {
    [RankType.RT_White] = DRCSRef.Color(1, 1, 1, 1),
    [RankType.RT_Green] = DRCSRef.Color(0.42352942, 0.83137256, 0.34509805, 1),
    [RankType.RT_Blue] = DRCSRef.Color(0.5019608, 0.77254903, 1, 1),
    [RankType.RT_Purple] = DRCSRef.Color(0.7607843, 0.41568628, 0.9607843, 1),
    [RankType.RT_Orange] = DRCSRef.Color(1, 0.6313726, 0.14901961, 1),
    [RankType.RT_Golden] = DRCSRef.Color(0.972549, 0.8745098, 0.3764706, 1),
    [RankType.RT_DarkGolden] = DRCSRef.Color(0.74509805, 0.6862745, 0.47058824, 1),
    [RankType.RT_MultiColor] = DRCSRef.Color(0.74509805, 0.6862745, 0.47058824, 1),
    [RankType.RT_ThirdGearDarkGolden] = DRCSRef.Color(0.74509805, 0.6862745, 0.47058824, 1),
}

RANK_COLOR_STR = {
    [RankType.RT_White] = '#FFFFFF',
    [RankType.RT_Green] = '#6CD458',
    [RankType.RT_Blue] = '#80C5FF',
    [RankType.RT_Purple] = '#C26AF5',
    [RankType.RT_Orange] = '#FFA126',
    [RankType.RT_Golden] = '#F8DF60',
    [RankType.RT_DarkGolden] = '#BEAF78',
    [RankType.RT_MultiColor] = '#BEAF78',
    [RankType.RT_ThirdGearDarkGolden] = '#BEAF78',
}

GUIDE_COLOR = {
    ['black'] = DRCSRef.Color(0, 0, 0, 0.7),
    ['hide'] = DRCSRef.Color(0, 0, 0, 0),
}

TIPS_COLOR = {
    ['lightblue'] = DRCSRef.Color(0.33333334, 0.93333334, 0.92156863, 1),
    ['green'] = DRCSRef.Color(0.29803923, 0.627451, 0.2, 1),
    ['blue'] = DRCSRef.Color(0.38039216, 0.6509804, 0.8901961, 1),
    ['yellow'] = DRCSRef.Color(0.75686276, 0.68235296, 0.05882353, 1),
    ['gray'] = DRCSRef.Color(0.3254902, 0.3254902, 0.3254902, 1),
    ['grey'] = DRCSRef.Color(0.3254902, 0.3254902, 0.3254902, 1),
}

UI_COLOR = {
    ['black'] = DRCSRef.Color(0.03137255, 0.039215688, 0.047058824, 1),
    ['white'] = DRCSRef.Color(0.93, 0.93, 0.93, 1),
    ['red'] = DRCSRef.Color(0.77254903, 0.22352941, 0.14901961, 1),
    ['red_half'] = DRCSRef.Color(0.77254903, 0.22352941, 0.14901961, 0.5),
    ['green'] = DRCSRef.Color(0.40784314, 0.5411765, 0.1764706, 1),
    ['green_half'] = DRCSRef.Color(0.40784314, 0.5411765, 0.1764706, 0.5),
    ['blue'] = DRCSRef.Color(0.38, 0.65, 0.8901, 1),
    ['lightgray'] = DRCSRef.Color(0.627451, 0.627451, 0.61960787, 1),
    ['lightgrey'] = DRCSRef.Color(0.627451, 0.627451, 0.61960787, 1),
    ['darkgray'] = DRCSRef.Color(0.3254902, 0.3254902, 0.3254902, 1),
    ['darkgrey'] = DRCSRef.Color(0.3254902, 0.3254902, 0.3254902, 1),
    ['wine'] = DRCSRef.Color(0.30588236, 0.22745098, 0.22745098, 1),
    ['yang'] = DRCSRef.Color(0.93333334, 0.38431373, 0.1882353, 1),
    ['Yang'] = DRCSRef.Color(0.93333334, 0.38431373, 0.1882353, 1),
    ['yin'] = DRCSRef.Color(0.4, 0.6039216, 0.7294118, 1),
    ['Yin'] = DRCSRef.Color(0.4, 0.6039216, 0.7294118, 1),
    ['orange'] = DRCSRef.Color(1, 0.6313726, 0.14901961, 1),
}

UI_COLOR_STR = {
    ['black'] = '#080A0C',
    ['white'] = '#CBCBCC',
    ['red'] = '#C53926',
    ['red_half'] = '#C53926',
    ['green'] = '#688A2D',
    ['lightgreen'] = '#92C13F',
    ['green_half'] = '#688A2D',
    ['blue'] = '#61a6e3',
    ['lightgray'] = '#A0A09E',
    ['lightgrey'] = '#A0A09E',
    ['darkgray'] = '#535353',
    ['darkgrey'] = '#535353',
    ['wine'] = '#4E3A3A',
    ['yang'] = '#EE6230',
    ['Yang'] = '#EE6230',
    ['yin'] = '#669ABA',
    ['Yin'] = '#669ABA',
}

ITEM_INFO_SELECT_COLOR = {
    ['on'] = DRCSRef.Color(1, 1, 1, 1),
    ['off'] = DRCSRef.Color(0.3882353, 0.254902, 0.1098039, 1),
}


WINDOW_PRELOAD_COMMON =  --常驻内存的
{
    ["Atlas"] = {["CommonAtlas"] = "UI/UIAtlas/CommonAtlas"},
    ["Perfabs"] = {
        ["UI/UIprefabs/Game/ItemIconUI"] = true,
        ["UI/UIprefabs/TipsUI/TipsPopUI"] = true,
    },
    ["Spine"] = {},
}

WINDOW_PRELOAD_UI = --切换场景时 加载的
{
    ["House"] = {
        ["Perfabs"] =
        {
            "UI/UIPrefabs/TownUI/HouseUI","UI/UIPrefabs/TownUI/ChatBubble","UI/UIPrefabs/TownUI/TreasureBookServerRewardUI","UI/UIPrefabs/TownUI/TreasureBookUI",
            "UI/UIPrefabs/ArenaUI/ArenaUI","UI/UIPrefabs/TownUI/ShoppingMallUI","UI/UIPrefabs/Meridians/MeridiansUI","UI/UIPrefabs/TownUI/StorageUI",
            "UI/UIPrefabs/StoryUI","UI/UIPrefabs/StoryListUI",
        },
        ["Atlas"] =
        {
            "UI/UIAtlas/HouseAtlas","UI/UIAtlas/StoryAtlas","UI/UIAtlas/CreateRoleAtlas"
        }
    },
    ["Town"] = {
        ["Perfabs"] =
        {
            "UI/UIPrefabs/TaskUI/TaskUI","UI/UIPrefabs/Role/CharacterUI","UI/UIPrefabs/ForgeUI/ForgeUI","UI/UIPrefabs/Interactive/ObserveUI",
            "UI/UIPrefabs/Role/BackpackUI","UI/UIPrefabs/Role/TeamListUI","UI/UIPrefabs/Role/MartialUI",'UI/UIPrefabs/Role/BattleAIUI'
        }
    },

}

WINDOW_ORDER_INFO =
{
    -- Window的次序信息
    -- order        : 界面的次序，在同一Layer下的界面会进行排序
    -- fullscreen   : 是否为全屏界面，若标为全屏则显示的时候会隐藏所有次序更低的界面
    -- reopen       : 若设为true，则隐藏和重新显示此界面的时候使用RemoveWindow和OpenWindow而不是SetActive

    ["HouseUI"] = { order = 50, fullscreen = true },
    ["BigMapUI"] = { order = 90, fullscreen = true },
    ["CityUI"] = { order = 100,  fullscreen = true ,baseshow = true },
    ["MazeUI"] = { order = 100, fullscreen = false },
    ["FinalBattleUI"] = { order = 100, fullscreen = true },

    ["MemoriesUI"] = { order = 109, allshow = true},
    ['LittlePacketUI'] = { order = 109 },
    ["NavigationUI"] = { order = 110, },
    ["ToptitleUI"] = { order = 130, },
    ["TaskTipsUI"] = { order = 110, },
    ['TownPlayerListUI'] = { order = 110 },
    ['ChatBubble'] = { order = 110 },
    ["CityRoleListUI"] = { order = 114, },
    ["ChatBoxUI"] = { order = 115, },
    ["SocialUI"] = { order = 116 , fullscreen = true },
    ["ArenaUI"] = { order = 120 }, -- TODO 酒馆内 fullscreen 不能为 true 否则需要重新打开 houseui 导致 houseui 请求协议发送多次
    ["ModUI"] = { order = 120 },
    ["ArenaPlayerCompareUI"] = { order = 121 },
    ["DifficultyUI"] = { order = 122, fullscreen = true },
    ["AchieveRewardUI"] = { order = 123, fullscreen = true },
    ["CharacterUI"] = { order = 124, fullscreen = false },
    ["RoleEmbattleUI"] = { order = 132, fullscreen = false},
    ["CreateRoleUI"] = { order = 131, fullscreen = true },
    ['StoreUI'] = { order = 241, fullscreen = false },
    ["SystemAnnouncementUI"] = { order = 200 },
    ["BlurBGUI"] = { order = 230, fullscreen = true, topshow = true},
    ["ComicPlotUI"] = { order = 235,fullscreen = true},
    ["SelectUI"] = { order = 240, topshow = true},
    ['LimitShopUI'] = {order = 240,fullscreen = true },

    ['GuessCoinUI'] = {order = 245,},
    ["BlackBackgroundUI"] = { order = 245},

    ["ArenaScriptMatchUI"] = { order = 245, fullscreen = true},

    ['BattleUI'] = { order = 246, fullscreen = true },



    ["DialogChoiceUI"] = { order = 250 , topshow = true},
    ["ChoiceUI"] = { order = 260},
    ["DialogueUI"] = { order = 270},
    ["PlayerSetUI"] = { order = 272, fullscreen = false },--单机没有酒馆,打开时关闭cityUI -- TODO 酒馆内 fullscreen 不能为 true 否则需要重新打开 houseui 导致 houseui 请求协议发送多次
    ['BattleGameEndUI'] = { order = 275, fullscreen = true },
    ['ArenaBattleEndUI'] = { order = 275, fullscreen = true },
    ['BattleStatisticalDataUI'] = { order = 276, fullscreen = true },
    ['ClanEliminateUI'] = { order = 299, fullscreen = false },
    ['ClanBranchEliminateUI'] = { order = 299, fullscreen = false },
    --["PlatformRoleEmbattleUI"] = { order = 299, fullscreen = true},
    ["RoleTeamOutUI"] = { order = 300},
    ["ClanUI"] = { order = 300, fullscreen = false },
    ["ClanCardUI"] = { order = 302 },   --高于DialogControlUI
    ['ShowBackpackUI'] = { order = 300, fullscreen = true},
    ['TaskUI'] = { order = 300, fullscreen = false },
    ['StorageUI'] = { order = 300 , fullscreen = false},
    ['ClanMartialUI'] = { order = 302 },
    ['GiveGiftDialogUI'] = { order = 300 },
    ['NpcConsultUI'] = { order = 302 },
    ['AchievementAchieveUI'] = { order = 300, fullscreen = true },
    ['DisguiseUI'] = { order = 300, fullscreen = false },
    ['FinalBattleCityInfoUI'] = { order = 300, fullscreen = true },
    ['LuckyUI'] = { order = 300, fullscreen = true },
    ['ForgeUI'] = { order = 300},
    ['ItemRecycleUI'] = { order = 330, fullscreen = true },
    ['TreasureBookUI'] = { order = 330, fullscreen = true },
    ['PinballGameUI'] = { order = 330, fullscreen = true },
    ['HighTowerRewardUI'] = { order = 300 },
    ["ResultUI"] = { order = 300},
    ['ChooseRoleUI'] = { order = 300 },
    ['CollectActivityUI'] = {order = 300,fullscreen = true },
    ['DailyRewardUI'] = {order = 300},
    ["PlayerReturnTaskUI"] = { order = 300,fullscreen = true},
    ["TreasureExchangeUI"] = { order = 300,fullscreen = true },
    ["StoryUI"] = { order = 300, fullscreen = true },

    ['DialogControlUI'] = {order = 301},
    ['TakeExtraUI'] = { order = 302 , fullscreen = true},
    ['ObserveUI'] = { order = 670, },
    ["MeridiansU"] = { order = 310 , fullscreen = true},
    ["CollectionUI"] = { order = 320 , fullscreen = false},
    ["Day3SignInUI"] = { order = 320},
    ["ActivitySignUI"] = { order = 320},
    ["FestivalUI"] = { order = 320},
    ["AllRewardWindowUI"] = { order = 321},
    ["ActivitySignMallUI"] = { order = 321},
    ["PetCardsUpgradeUI"] = { order = 330 , fullscreen = true},
    ["RoleCardsUpgradeUI"] = { order = 330 , fullscreen = true},
    ["CollectionFormulaUI"] = { order = 330 , fullscreen = true},
    ["CollectionHeirloomUI"] = { order = 330 , fullscreen = true},
    ["CollectionMartialUI"] = { order = 330 , fullscreen = true},
    ["RankUI"] = { order = 330 },
    ["MeridiansUI"] = { order = 330 },
    ["DreamStoryUI"] = { order = 330 , fullscreen = true},

    ["TaskCompleteUI"] = { order = 400 },
    ["ActivityUI"] = { order = 400,fullscreen = true },
    ["MartialScreenUI"] = { order = 400 },
    ['RandomRollUI'] = { order = 400 },
    ['TeamListUI'] = { order = 400, },
    ["FundUI"] = { order = 401 },
    ["ChallengeOrderUI"] = { order = 420, fullscreen = true},

    ['DialogRecordUI'] = {order = 500},
    ['ForegroundUI'] = { order = 500, },
    ['ItemRewardChooseUI'] = {order = 500, },
    ['TreasureBookEarlyBuyUI'] = {order = 500},

    ['ClickDiscountUI'] = {order = 500,},

    ["EvolutionUI"] = { order = 510},

    ['InteractUnlockUI'] = {order = 580,},--650,},

    ["CreateFaceUI"] = { order = 585, fullscreen = false },

    ["ShoppingMallUI"] = { order = 590 , fullscreen = true },

    ['WindowBarUI'] = { order = 600, },
    ["DiscussUI"] = { order = 610 },
    ["ShowAllChooseGoodsUI"] = { order = 610 },

    ['PickGiftUI'] = {order = 610},
    ['PickWishRewardsUI'] = {order = 610},
    ['BatchChooseUI'] = { order = 610, },
    ['LoginAggrementUI'] = { order = 610, },

    ['RulePopUI'] = { order = 615, },
    ["PlayerMsgMiniUI"] = { order = 620 },
    ["CityAnimUI"] = { order = 620 },

    ['Gold2SilverUI'] = {order = 650,},
    ['Gold2SecondGoldUI'] = {order = 650,},
    ['TreasureExchangePopWindowUI'] = {order = 650,},
    ['LimitShopDiscountPanalUI'] = {order = 650,},
    ['LimitShopActionPanalUI'] = {order = 650,},
    ['GiftBagResultUI'] = {order = 650,},

    ['GeneralBoxUI'] = {order = 700,},
    ['GeneralRefreshBoxUI'] = {order = 701,},
    ['GuideUI'] = {order = 750,},
    ['SystemPowerUI'] = {order = 750,},
    ['PrivateMessageUI'] = {order = 750,},

    ['SystemScreenShotShareTipUI'] = {order = 800,},
    ['ForgetMartialGiftUI'] = {order = 801,},
    ['ChooseLuckyUI'] = {order = 801,},
    ['ToastUI'] = {order = 9000,},
    -- PK
    ["PKUI"] = { order = 100 , fullscreen = true },
    ["PKRoleUI"] = { order = 200 },
    ["PKRankUI"] = { order = 200 , fullscreen = true},
    ["PKMatchUI"] = { order = 201 },
    ["PKShopUI"] = { order = 200 , fullscreen = true},
    ["PKTipUI"] = { order = 600 },
    ["PKSelectUI"] = { order = 1000 },
    -- clan build
    ["BuildUI"] = { order = 100 , fullscreen = true},
    ["BuildEditUI"] = { order = 101 , fullscreen = true},
    ["BuildSettingUI"] = { order = 200},
    -- common
    ["SelectRoleUI"] = { order = 300},
    ["PlayerReturnUI"] = {order = 1000,},
    ['TipsPopUI'] = {order = 8888,},
    ["CheatUI"] = { order = 9999 },

    -- tilemap
    ["TileBigMap"] = { order = 100, baseshow = true },
    ["MiniMapUI"] = { order = 101 },
    ["MapUnfoldUI"] = { order = 140 },

    --marry sworn
    ["MarryUI"] = { order = 140 },
    ["SwornUI"] = { order = 140 },
    ["SetNicknameUI"] = { order = 140 },
    ["MartialSelectUI"] = { order = 140 },
    ["SetNicknameTip"] = { order = 140 },

    -- 迷宫进入提示
    ["MazeEntryUI"] = { order = 140 },

    ["SaveFileUI"] = { order = 140 },

}

CUSTOM_ACTIONEND_UI_NAME =
{
    ['BattleGameEndUI'] = true,
    ['RoleShowUI'] = true,
}

BAT_CON = {
    ['speedDownPanel'] = 0,
    ['speedUpPanel'] = 1,
    ['speedChangeFactor'] = 0.5,
    ['speedMinFactor'] = -4/3,
    ['speedNorm'] = 2,
    ['speedDown'] = 0.4,
    ['speedUp'] = 2,
    ['speed_init'] = 0,
    --（速度值+速度值系数1）/(速度值+速度值系数2)+速度变动*速度变动系数
    -- speed=（速度值+speed_m）/(速度值+speed_n)+速度变动*0.5
    -- speedPanel=（速度值+speed_m）/(速度值+speed_n)这个拥有最小最大值判定；speedDownPanel-0、speedUpPanel-1
    -- speed_m,speed_n取主体等级的数值；speed=speed+速度变动*0.5,speedChangeFactor-0.5
    -- 行动条速度=-4/3*speed+2;   speedMinFactor为-4/3，speedNorm为2
    -- 行动条速度拥有最小值为speedDown-0.4，speedUp-2
    -- 速度变动为BUFF相关的数值改动，可突破speed的上限时，以此达到速度改变可影响的行动回合数
    --  speed_init 额外的速度值   local 速度值 = G.call('角色_获取角色属性',o_role_角色,'速度值') + speed_init
}

Maze_OrderinLayer = {

    ['0'] = 100+5 * 5,
    ['1'] = 100+4 * 5,
    ['2'] = 100+3 * 5,
    ['3'] = 100+2 * 5,
    ['4'] = 100+1 * 5,

    ['DynamicADVLOOT'] = 260
}

Maze_TeammatesOrderinLayer = {
    [0] = 255,
    [1] = 254,
    [2] = 253,
    [3] = 252,
    [4] = 251,
    [5] = 252,
}

TriggerHideMazeGridTypeList = {
    MazeCardFirstType.MCFT_BATTLE,
    MazeCardFirstType.MCFT_BUFF,
    MazeCardFirstType.MCFT_TRAP
}

AnimEnumNameMap = {
    [SpineAnimType.SPT_IDLE] = 'idle',
    [SpineAnimType.SPT_TREASURE_OPEN] = 'open',
    [SpineAnimType.SPT_TREASURE_IDLE] = 'idle',
    [SpineAnimType.SPT_TREASURE_OPEN_IDLE] = 'disappear',
}

ROLE_SPINE_DEFAULT_ANIM = 'idle'
ROLE_DEFAULT_DISPOSITION = 10
ROLE_EXCEL_DISPOSITION = -999

CITY_DISTANCE_REACHABLE = 1
CITY_DISTANCE_DISABLED = 10000
CITY_DISTANCE_SELF = 0
CITY_DEFAULT_NAME_POS = DRCSRef.Vec3(4, -28, 0)

-- 技能品质框 路径
RANK_SKILL_BORDER = {
    [RankType.RT_White] = 'zd_frame_07',
    [RankType.RT_Green] = 'zd_frame_03',
    [RankType.RT_Blue] = 'zd_frame_04',
    [RankType.RT_Purple] = 'zd_frame_05',
    [RankType.RT_Orange] = 'zd_frame_02',
    [RankType.RT_Golden] = 'zd_frame_01',
    [RankType.RT_DarkGolden] = 'zd_frame_06',
    [RankType.RT_MultiColor] = 'zd_frame_06',
    [RankType.RT_ThirdGearDarkGolden] = 'zd_frame_06',
}

MAZR_TEAM_POS = {
    [0] = DRCSRef.Vec3(-374,-374,0),
    [1] = DRCSRef.Vec3(-462,-305,0),
    [2] = DRCSRef.Vec3(-535,-188,0),
    [3] = DRCSRef.Vec3(-418,-174,0),
    [4] = DRCSRef.Vec3(-316,-240,0),
}

ADVLOOT_SITE = {
    ADV_CITY = 0,
    ADV_MAZE = 1,
    ADV_MAZEGRID = 2,
    ADV_CITY_DYNAC = 3,
    ADV_CUSTOM = 4,
}
screen_w = 0
screen_h = 0
design_ui_w = 0
design_ui_h = 0
screen_radio = 0
design_radio = 0
adapt_ui_w = 0
adapt_ui_h = 0

function SerializeScreenSize()
    screen_w = CS.UnityEngine.GameObject.Find("UILayerRoot").transform.rect.width
    screen_h = CS.UnityEngine.GameObject.Find("UILayerRoot").transform.rect.height

    design_ui_w = 1280
    design_ui_h = 720
    screen_radio = screen_w / screen_h
    design_radio = design_ui_w / design_ui_h

    --4:3
    if screen_radio < design_radio then
        adapt_ui_w = design_ui_w
        adapt_ui_h = screen_w / design_ui_w * design_ui_h
    else
        adapt_ui_w = (screen_radio < design_radio) and design_ui_w or (design_ui_h * screen_radio)
        adapt_ui_h = (screen_radio > design_radio) and design_ui_h or (design_ui_w / screen_radio)
    end
end

ModifyAppearanceError = {
    [SNC_APPEAR_MODIFY_PARAM_FAIL] = "参数错误",
    [SNC_APPEAR_MODIFY_NOT_HAVE] = "未拥有",
    [SNC_APPEAR_MODIFY_SAME_NAME] = "该名称已存在",
    [SNC_TSS_NOT_VALID] = "存在屏蔽字",
    [SNC_CHAR_NAME_OVER_LEN] = "名字超出允许长度",
}

UIConstStr = {
    ["SelectUI_Left"] = "剩余",
    ["SelectUI_Favor"] = "好感度20",
    ["SelectUI_Favor60"] = "好感度60",
    ["SelectUI_Favor100"] = "好感度100",
    ["SelectUI_NoInvite"] = "不可邀请",
    ["SelectUI_Favor0"] = "好感度>=0",
    ["NpcConsultUI_Consult"] = "当面请教",
    ["NpcConsultUI_Steel"] = "暗中观摩",
    ["NpcConsultUI_NoSteel"] = "无法观摩",
    ["NpcConsultUI_Day"] = "天",
    ["NpcConsultUI_NoConsult"] = "无法请教",
    ["NpcConsultUI_HasLearn"] = "已修炼",
    ["NpcConsultUI_Favor"] = "好感度",
    ["NpcConsultUI_GiftPoint"] = " 天赋点 >= ",
}

-- 选择门派界面, 锁定类型排序权重
ClanLockWeightMap = {
	[ClanLock.CLL_JoinClan] = 4,
	[ClanLock.CLL_FamousClan] = 3,
	[ClanLock.CLL_NeverJoin] = 2,
	[ClanLock.CLL_UnknownClan] = 1,
	[ClanLock.CLL_Null] = 0,
}

MazeMiniMapGridImageDict = {
    [MazeCardFirstType.MCFT_ROAD] = 'NormalGrid',
    [MazeCardFirstType.MCFT_BATTLE] = 'NormalGrid',
    [MazeCardFirstType.MCFT_TREASURE] = 'TreasureGrid',
    [MazeCardFirstType.MCFT_BUFF] = 'NormalGrid',
    [MazeCardFirstType.MCFT_TRAP] = 'NormalGrid',
    [MazeCardFirstType.MCFT_STAIR] = 'ExitGrid',
    [MazeCardFirstType.MCFT_TASK] = 'TaskGrid',
}

MazeOpenedTreasureGridImage = 'UsedTreasureGrid'
MazeCurrentGridImage = 'MainRoleGrid'

MazeGridFrameTypeImgDict = {
    [MazeCardFirstType.MCFT_ROAD] = 'RoadCardFrame',
    [MazeCardFirstType.MCFT_BATTLE] = 'BattleCardFrame',
    [MazeCardFirstType.MCFT_TREASURE] = 'TreasureCardFrame',
    [MazeCardFirstType.MCFT_BUFF] = 'BuffCardFrame',
    [MazeCardFirstType.MCFT_TRAP] = 'TrapCardFrame',
    [MazeCardFirstType.MCFT_STAIR] = 'StairCardFrame',
    [MazeCardFirstType.MCFT_TASK] = 'TaskCardFrame',
}

MAZE_GO_AWAY_CHOICE_LANG_ID = 2590041
LEAVE_CHOICE_LANG_ID = 2590042

--助战布阵位置
ASSISTCOMBATPOS = {
    {
        ['x'] = 4,
        ['y'] = 1
    },
    {
        ['x'] = 3,
        ['y'] = 1
    },
    {
        ['x'] = 2,
        ['y'] = 1
    },
    {
        ['x'] = 4,
        ['y'] = 3
    },
    {
        ['x'] = 3,
        ['y'] = 3
    }
}

-- 迷宫中触发冒险天赋时的气泡显示
MAZE_ADV_GIFT_TRIGGER_FORMAT_STR_ITEM = '因为%s天赋，额外发现了 %s'
MAZE_ADV_GIFT_TRIGGER_FORMAT_STR_COIN = '因为%s天赋，额外发现了 铜币*%s'
MAZE_ADV_GIFT_TRIGGER_BUBBLE_DELTA_TIME = 1

-- 同时显示的 Toast 的最大数量
MAX_TOAST_COUNT = 5
TOAST_FADE_DELTA_TIME = 0.2
TOAST_SHOW_DELTA_TIME = 0.8


---------- BATTLE
COLOR_BATTLE_LIFE = DRCSRef.Color(0.4509804, 0.8235294, 0.3960784, 1)
COLOR_BATTLE_ZHENQI = DRCSRef.Color(0.3921569, 0.7568628, 0.8941177, 1)
BGMID_BATTLE = 2000
BGMID_HOURE = 2002
BGMID_LOGIN = 2023
BGMID_ZM = 2020
BGMID_MAP = 2003
DEFAULT_BGM_MAPID = 1

MAINROLE_TYPE_ID = 1000001260

---------好感度显示黑名单
FAVOR_SHOW_SCRIPT_BLACKLIST={
    [1]=0x103c0002,
    [2]=0x103c0007,
}

FAVOR_SHOW_ROLE_BLACKLIST={
}

TOAST_MONEY_TYPE = {
    [MRIT_CURCOIN] = '铜币',
    [MRIT_GOLD] = '元宝',
    [MRIT_SILVER] = '银锭',
}

CAMERA_POS = DRCSRef.Vec3(0,0,-4)

BATTLE_VICTORY_SCORE = {0, 30, 75, 100}
BATTLE_VICTORY_SCORE_DESC = {"险胜", "胜利","大胜", "完胜"}
BATTLESCENE_BG = "btbg_zhulin"
BATTLESCENE_BG_PATH = "battlebg/btbg_zhulin/btbg_zhulin"

-- 文字打字机效果显示速度
DOTWEEN_DOTEXT_SPEED = 0.5

LOCK_CHOICE_CLICK_TIP_LANGUAGE_ID = 2590043

MazeHorizontalMoveDeltaTime = 0.15
MazeVerticalMoveDeltaTime = 0.2
MazeDynamicAdvLootAnimDeltaTime = 0.5
MazeEnemyEscapeAnimTime = 0.5
MazeEnemyEscapeSpineFadeTime = 0.3
  ForgottenMartialType = {
    FMT_Null = 0,
    FMT_MAINROLE_FREE = 1,
    FMT_MAINROLE_USEITEM = 2,
    FMT_TEAMMATR_USEITEM = 3,
    FMT_NOITEM = 4,
  }


RecastType_FixTVWhite = 0  -- 白字属性,类型和属性值固定一旦生成不再改变,重铸条目达到完美时可以提升一点属性值
RecastType_RandTVGreen = 1 -- 绿字属性,类型和属性值可以重新生成
RecastType_RandVGreen = 2  -- 绿字属性,属性值可以重新生成(必出属性,重铸时只能属性值变化)
RecastType_RandTVBlue = 3  -- 蓝字属性,类型和属性值可以重新生成(重铸条目达到完美时小概率出现,最多只有两条)

-- 擂台赛状态
ARENA_MATCH_STAGE = {
    ARENA_MATCH_STAGE_ID_NONE = 0,
    ARENA_MATCH_STAGE_ID_SIGNUP = 1,                -- 报名
	ARENA_MATCH_STAGE_ID_CALC_BATTLE_RESULT = 2,    -- 计算战斗结果
	ARENA_MATCH_STAGE_ID_START_MATCH = 3,           -- 比赛开始
	ARENA_MATCH_STAGE_ID_BET = 4,                   -- 投注阶段
	ARENA_MATCH_STAGE_ID_WATCH = 5,                 -- 观战阶段
	ARENA_MATCH_STAGE_ID_FINISH = 6,                -- 结束
};
ARENA_PLAYBACK_DATA = nil;

SncType2Msg = {
    [SNC_ARENA_NOT_IN_SIGNUP_TIME] = '不在报名时间!',
    [SNC_ARENA_UPDATE_PKDATA_SUCCESS] = '更新平台阵容成功!',
    [SNC_ARENA_HAS_BET] = '重复押注!',
    [SNC_ARENA_BET_FAILED] = '押注失败!',
    [SNC_ARENA_SIGNUP_FAILED] = '报名失败!',
    [SNC_PLAT_PLAYER_OFFLINE] = '该玩家已下线',
    [SNC_ARENA_NEED_CHAMPION_TIEMS_1] = '新手赛夺冠次数未达标',
    [SNC_ARENA_NEED_CHAMPION_TIEMS_2] = '大众赛夺冠次数未达标',
    [SNC_BECOME_RMB_PLAYER_FAIL] = '百宝书开通失败!',

    [SNC_SUC_SEND_REDPACKET] = "红包发送成功",
    [SNC_NOT_SEND_REDPACKET] = "红包发送失败",
    [SNC_NODATA_REDPACKET] = "红包数据错误",
    [SNC_FORBIDTEXT_REDPACKET] = "口令包含非法字符",
    [SNC_NOITEM_REDPACKET] = "道具不足",
    [SNC_UNLOCK_NEW_EXTRA_HERO_TASK] = "解锁一条新的英雄任务，可在百宝书任务界面查看",
    [SNC_UNLOCK_NEW_EXTRA_RMB_TASK] = "解锁一条新的壕侠专属任务，可在百宝书任务界面查看",
    [SNC_UNLOCK_NEW_REPEAT_TASK] = "解锁一条新的重复任务，可在百宝书任务界面查看",
    [SNC_LIMITSHOP_FINFIRSTSHARE] = '首次分享完成',
    [SNC_LIMITSHOP_ADDFIRSTSHARE] = '添加分享成功',
    [SNC_LIMITSHOP_ADDDISCOUNT] = '砍价刀添加成功',
    [SNC_LIMITSHOP_NOENOUGHBIGCOIN] = '旺旺币不足',
    [SNC_LIMITSHOP_NOENOUGHYAZHUTIMES] = '押注次数已用完',
    [SNC_LIMITSHOP_BUYBIGCOINSUCCESS] = '购买旺旺币成功',
    [SNC_LIMITSHOP_YAZHUSUCCESS] = '押注成功',
    [SNC_LIMITSHOP_ADDDISCOUNTLIMIT] = '优惠券数量已达上限',
    [SNC_LIMITSHOP_GETYAZHUINROFIRST] = '请首先获取押注信息',
    [SNC_LIMITSHOP_YAZHUGAMEOVER] = '押注已完成',
    [SNC_LIMITSHOP_BUYSECCESS] = '购买成功',
    [SNC_LIMITSHOP_COUPONNOTFOUND] = '优惠券不存在',
    [SNC_LIMITSHOP_COUPONEXPIRED] = '优惠券已过期',
    [SNC_LIMITSHOP_GIFTSOLD] = '礼包售完了',
    [SNC_RENAME_USE_GOLDOPRFREQUENT] = "金锭操作太频繁",

	[SNC_TREASURE_EXCHANGE_REFREASH] = '秘宝大会刷新成功,材料已扣除',
	[SNC_TREASURE_EXCHANGE_REFREASH_FAILED] = '秘宝大会刷新失败，材料不足',
	[SNC_TREASURE_EXCHANGE_BUY_FAILED] = '秘宝大会兑换失败，材料不足',
	[SNC_TREASURE_EXCHANGE_BUY] = '秘宝大会兑换成功,材料已扣除',
    [SNC_APPEAR_MODIFY_NAME_FREQUENTLY] = "起名操作过于频繁",
    [SNC_MAX_DAILY_MERIDIANS_EXP] = "今日已达到最大可获得经脉经验上限",
}

-- 观察对象的全局ID引用
OBSERVE_OTHER_PLAYER_ID = 0;

CityPathNodeDataDict = {
    ['40-26'] = {['PathNodeName'] = '1', ['SrcCityBaseID'] = 40, ['DstCityBaseID'] = 26},
	['26-40'] = {['PathNodeName'] = '1', ['SrcCityBaseID'] = 26, ['DstCityBaseID'] = 40, ['IsReverse'] = true}, -- 反向
    ['26-32'] = {['PathNodeName'] = '2', ['SrcCityBaseID'] = 26, ['DstCityBaseID'] = 32},
	['32-26'] = {['PathNodeName'] = '2', ['SrcCityBaseID'] = 32, ['DstCityBaseID'] = 26, ['IsReverse'] = true}, -- 反向
    ['26-11'] = {['PathNodeName'] = '3', ['SrcCityBaseID'] = 26, ['DstCityBaseID'] = 11},
	['11-26'] = {['PathNodeName'] = '3', ['SrcCityBaseID'] = 11, ['DstCityBaseID'] = 26, ['IsReverse'] = true}, -- 反向
    ['32-28'] = {['PathNodeName'] = '4', ['SrcCityBaseID'] = 32, ['DstCityBaseID'] = 28},
	['28-32'] = {['PathNodeName'] = '4', ['SrcCityBaseID'] = 28, ['DstCityBaseID'] = 32, ['IsReverse'] = true}, -- 反向
    ['28-31'] = {['PathNodeName'] = '5', ['SrcCityBaseID'] = 28, ['DstCityBaseID'] = 31},
	['31-28'] = {['PathNodeName'] = '5', ['SrcCityBaseID'] = 31, ['DstCityBaseID'] = 28, ['IsReverse'] = true}, -- 反向
    ['17-31'] = {['PathNodeName'] = '6', ['SrcCityBaseID'] = 17, ['DstCityBaseID'] = 31},
	['31-17'] = {['PathNodeName'] = '6', ['SrcCityBaseID'] = 31, ['DstCityBaseID'] = 17, ['IsReverse'] = true}, -- 反向
    ['31-39'] = {['PathNodeName'] = '7', ['SrcCityBaseID'] = 31, ['DstCityBaseID'] = 39},
	['39-31'] = {['PathNodeName'] = '7', ['SrcCityBaseID'] = 39, ['DstCityBaseID'] = 31, ['IsReverse'] = true}, -- 反向
    ['36-13'] = {['PathNodeName'] = '8', ['SrcCityBaseID'] = 36, ['DstCityBaseID'] = 13},
	['13-36'] = {['PathNodeName'] = '8', ['SrcCityBaseID'] = 13, ['DstCityBaseID'] = 36, ['IsReverse'] = true}, -- 反向
    ['36-35'] = {['PathNodeName'] = '9', ['SrcCityBaseID'] = 36, ['DstCityBaseID'] = 35},
	['35-36'] = {['PathNodeName'] = '9', ['SrcCityBaseID'] = 35, ['DstCityBaseID'] = 36, ['IsReverse'] = true}, -- 反向
    ['30-36'] = {['PathNodeName'] = '10', ['SrcCityBaseID'] = 30, ['DstCityBaseID'] = 36},
	['36-30'] = {['PathNodeName'] = '10', ['SrcCityBaseID'] = 36, ['DstCityBaseID'] = 30, ['IsReverse'] = true}, -- 反向
    ['19-30'] = {['PathNodeName'] = '11', ['SrcCityBaseID'] = 19, ['DstCityBaseID'] = 30},
	['30-19'] = {['PathNodeName'] = '11', ['SrcCityBaseID'] = 30, ['DstCityBaseID'] = 19, ['IsReverse'] = true}, -- 反向
    ['10-35'] = {['PathNodeName'] = '12', ['SrcCityBaseID'] = 10, ['DstCityBaseID'] = 35},
	['35-10'] = {['PathNodeName'] = '12', ['SrcCityBaseID'] = 35, ['DstCityBaseID'] = 10, ['IsReverse'] = true}, -- 反向
    ['31-10'] = {['PathNodeName'] = '13', ['SrcCityBaseID'] = 31, ['DstCityBaseID'] = 10},
	['10-31'] = {['PathNodeName'] = '13', ['SrcCityBaseID'] = 10, ['DstCityBaseID'] = 31, ['IsReverse'] = true}, -- 反向
    ['27-30'] = {['PathNodeName'] = '14', ['SrcCityBaseID'] = 27, ['DstCityBaseID'] = 30},
	['30-27'] = {['PathNodeName'] = '14', ['SrcCityBaseID'] = 30, ['DstCityBaseID'] = 27, ['IsReverse'] = true}, -- 反向
    ['1-27'] = {['PathNodeName'] = '15', ['SrcCityBaseID'] = 1, ['DstCityBaseID'] = 27},
	['27-1'] = {['PathNodeName'] = '15', ['SrcCityBaseID'] = 27, ['DstCityBaseID'] = 1, ['IsReverse'] = true}, -- 反向
    ['4-27'] = {['PathNodeName'] = '16', ['SrcCityBaseID'] = 4, ['DstCityBaseID'] = 27},
	['27-4'] = {['PathNodeName'] = '16', ['SrcCityBaseID'] = 27, ['DstCityBaseID'] = 4, ['IsReverse'] = true}, -- 反向
    ['9-4'] = {['PathNodeName'] = '17', ['SrcCityBaseID'] = 9, ['DstCityBaseID'] = 4},
	['4-9'] = {['PathNodeName'] = '17', ['SrcCityBaseID'] = 4, ['DstCityBaseID'] = 9, ['IsReverse'] = true}, -- 反向
    ['21-1'] = {['PathNodeName'] = '18', ['SrcCityBaseID'] = 21, ['DstCityBaseID'] = 1},
	['1-21'] = {['PathNodeName'] = '18', ['SrcCityBaseID'] = 1, ['DstCityBaseID'] = 21, ['IsReverse'] = true}, -- 反向
    ['2-21'] = {['PathNodeName'] = '19', ['SrcCityBaseID'] = 2, ['DstCityBaseID'] = 21},
	['21-2'] = {['PathNodeName'] = '19', ['SrcCityBaseID'] = 21, ['DstCityBaseID'] = 2, ['IsReverse'] = true}, -- 反向
    ['9-21'] = {['PathNodeName'] = '20', ['SrcCityBaseID'] = 9, ['DstCityBaseID'] = 21},
	['21-9'] = {['PathNodeName'] = '20', ['SrcCityBaseID'] = 21, ['DstCityBaseID'] = 9, ['IsReverse'] = true}, -- 反向
    ['21-18'] = {['PathNodeName'] = '21', ['SrcCityBaseID'] = 21, ['DstCityBaseID'] = 18},
	['18-21'] = {['PathNodeName'] = '21', ['SrcCityBaseID'] = 18, ['DstCityBaseID'] = 21, ['IsReverse'] = true}, -- 反向
    ['25-7'] = {['PathNodeName'] = '22', ['SrcCityBaseID'] = 25, ['DstCityBaseID'] = 7},
	['7-25'] = {['PathNodeName'] = '22', ['SrcCityBaseID'] = 7, ['DstCityBaseID'] = 25, ['IsReverse'] = true}, -- 反向
    ['7-11'] = {['PathNodeName'] = '23', ['SrcCityBaseID'] = 7, ['DstCityBaseID'] = 11},
	['11-7'] = {['PathNodeName'] = '23', ['SrcCityBaseID'] = 11, ['DstCityBaseID'] = 7, ['IsReverse'] = true}, -- 反向
    ['33-25'] = {['PathNodeName'] = '24', ['SrcCityBaseID'] = 33, ['DstCityBaseID'] = 25},
	['25-33'] = {['PathNodeName'] = '24', ['SrcCityBaseID'] = 25, ['DstCityBaseID'] = 33, ['IsReverse'] = true}, -- 反向
    ['18-19'] = {['PathNodeName'] = '25', ['SrcCityBaseID'] = 18, ['DstCityBaseID'] = 19},
	['19-18'] = {['PathNodeName'] = '25', ['SrcCityBaseID'] = 19, ['DstCityBaseID'] = 18, ['IsReverse'] = true}, -- 反向
    ['7-18'] = {['PathNodeName'] = '26', ['SrcCityBaseID'] = 7, ['DstCityBaseID'] = 18},
	['18-7'] = {['PathNodeName'] = '26', ['SrcCityBaseID'] = 18, ['DstCityBaseID'] = 7, ['IsReverse'] = true}, -- 反向
    ['19-15'] = {['PathNodeName'] = '27', ['SrcCityBaseID'] = 19, ['DstCityBaseID'] = 15},
	['15-19'] = {['PathNodeName'] = '27', ['SrcCityBaseID'] = 15, ['DstCityBaseID'] = 19, ['IsReverse'] = true}, -- 反向
    ['17-15'] = {['PathNodeName'] = '28', ['SrcCityBaseID'] = 17, ['DstCityBaseID'] = 15},
	['15-17'] = {['PathNodeName'] = '28', ['SrcCityBaseID'] = 15, ['DstCityBaseID'] = 17, ['IsReverse'] = true}, -- 反向
    ['15-36'] = {['PathNodeName'] = '29', ['SrcCityBaseID'] = 15, ['DstCityBaseID'] = 36},
	['36-15'] = {['PathNodeName'] = '29', ['SrcCityBaseID'] = 36, ['DstCityBaseID'] = 15, ['IsReverse'] = true}, -- 反向
    ['15-10'] = {['PathNodeName'] = '30', ['SrcCityBaseID'] = 15, ['DstCityBaseID'] = 10},
	['10-15'] = {['PathNodeName'] = '30', ['SrcCityBaseID'] = 10, ['DstCityBaseID'] = 15, ['IsReverse'] = true}, -- 反向
    ['18-17'] = {['PathNodeName'] = '33', ['SrcCityBaseID'] = 18, ['DstCityBaseID'] = 17},
	['17-18'] = {['PathNodeName'] = '33', ['SrcCityBaseID'] = 17, ['DstCityBaseID'] = 18, ['IsReverse'] = true}, -- 反向
    ['34-9'] = {['PathNodeName'] = '34', ['SrcCityBaseID'] = 34, ['DstCityBaseID'] = 9},    -- 泰山 -> 冰火岛
	['9-34'] = {['PathNodeName'] = '34', ['SrcCityBaseID'] = 9, ['DstCityBaseID'] = 34, ['IsReverse'] = true}, -- 反向
    ['38-34'] = {['PathNodeName'] = '35', ['SrcCityBaseID'] = 38, ['DstCityBaseID'] = 34},  -- 冰火岛 -> 剑冢
	['34-38'] = {['PathNodeName'] = '35', ['SrcCityBaseID'] = 34, ['DstCityBaseID'] = 38, ['IsReverse'] = true}, -- 反向
    ['37-40'] = {['PathNodeName'] = '36', ['SrcCityBaseID'] = 37, ['DstCityBaseID'] = 40},  -- 无名岛 -> 侠义岛
	['40-37'] = {['PathNodeName'] = '36', ['SrcCityBaseID'] = 40, ['DstCityBaseID'] = 37, ['IsReverse'] = true}, -- 反向
    ['5-37'] = {['PathNodeName'] = '37', ['SrcCityBaseID'] = 5, ['DstCityBaseID'] = 37},    -- 侠义岛 -> 桃花岛
	['37-5'] = {['PathNodeName'] = '37', ['SrcCityBaseID'] = 37, ['DstCityBaseID'] = 5, ['IsReverse'] = true}, -- 反向
    ['38-33'] = {['PathNodeName'] = '38', ['SrcCityBaseID'] = 38, ['DstCityBaseID'] = 33},  -- 太湖 -> 剑冢
	['33-38'] = {['PathNodeName'] = '38', ['SrcCityBaseID'] = 33, ['DstCityBaseID'] = 38, ['IsReverse'] = true}, -- 反向
    ['5-33'] = {['PathNodeName'] = '39', ['SrcCityBaseID'] = 5, ['DstCityBaseID'] = 33},    -- 太湖 -> 桃花岛
    ['33-5'] = {['PathNodeName'] = '39', ['SrcCityBaseID'] = 33, ['DstCityBaseID'] = 5, ['IsReverse'] = true}, -- 反向
    ['36-41'] = {['PathNodeName'] = '40', ['SrcCityBaseID'] = 36, ['DstCityBaseID'] = 41},
    ['41-36'] = {['PathNodeName'] = '40', ['SrcCityBaseID'] = 41, ['DstCityBaseID'] = 36, ['IsReverse'] = true}, -- 反向
    ['30-41'] = {['PathNodeName'] = '41', ['SrcCityBaseID'] = 30, ['DstCityBaseID'] = 41},
    ['41-30'] = {['PathNodeName'] = '41', ['SrcCityBaseID'] = 41, ['DstCityBaseID'] = 30, ['IsReverse'] = true}, -- 反向
    ['13-41'] = {['PathNodeName'] = '42', ['SrcCityBaseID'] = 13, ['DstCityBaseID'] = 41},
    ['41-13'] = {['PathNodeName'] = '42', ['SrcCityBaseID'] = 41, ['DstCityBaseID'] = 13, ['IsReverse'] = true}, -- 反向
    ['32-42'] = {['PathNodeName'] = '4', ['SrcCityBaseID'] = 32, ['DstCityBaseID'] = 42},
	['42-32'] = {['PathNodeName'] = '4', ['SrcCityBaseID'] = 42, ['DstCityBaseID'] = 32, ['IsReverse'] = true}, -- 反向
    ['42-31'] = {['PathNodeName'] = '5', ['SrcCityBaseID'] = 42, ['DstCityBaseID'] = 31},
	['31-42'] = {['PathNodeName'] = '5', ['SrcCityBaseID'] = 31, ['DstCityBaseID'] = 42, ['IsReverse'] = true}, -- 反向
    ['43-28'] = {['PathNodeName'] = '43', ['SrcCityBaseID'] = 43, ['DstCityBaseID'] = 28},
	['28-43'] = {['PathNodeName'] = '43', ['SrcCityBaseID'] = 28, ['DstCityBaseID'] = 43, ['IsReverse'] = true}, -- 反向
}

SeaCityDict = {
    [34] = true,  -- 冰火岛
    [38] = true,  -- 剑冢
    [5] = true,  -- 桃花岛
    [37] = true,  -- 侠义岛
    [40] = true,  -- 无名岛
    [9] = true,  -- 泰山
    [33] = true,  -- 太湖
}

--多久不用 开始卸载资源 单位s
if DRCSRef.CommonFunction.IsLowLevelIOS() then
    UPDATE_UNLOAD_WINDOWS = 30
    UPDATE_UNLOAD_ASSET = 20
    UPDATE_UNLOAD_CLASS = 30
    UPDATE_UNLOAD_POOL = 30
else
    UPDATE_UNLOAD_WINDOWS = 120
    UPDATE_UNLOAD_ASSET = 90
    UPDATE_UNLOAD_CLASS = 120
    UPDATE_UNLOAD_POOL = 120
end

MOVE_MAZE_MAX_COUNT = 5 -- 进出迷宫5次后 下次进迷宫切场景 当赋值nil时 功能失效
-----------
SERVER_MAGIC_VALUE = 1297303375

ONE_FRAME_MAX_ACTION_COUNT = 10

WAIT_DISPLAY_MSG_MAX_TIME = 2000    -- 等待下行最长事件

REMOVE_WINDOW_MAX_LOADING_DELAY = 5000

MAZE_SPINE_SCALE = 50

BIGMAP_MOVE_SPEED = 0.3

UNLOCK_GRID_IDLE_ANIM_NAME = 'animation01'
UNLOCK_GRID_OPEN_ANIM_NAME = 'animation02'

-- 物品边框特效
ITEM_FRAME_EFFECT = {
    [RankType.RT_Golden] = {
        ['sprite'] = "ItemIcon/effect/tex_xl_jinse",
        ['material'] = "Materials/ItemEffectAdditive",
        ['scale'] = 1,
    },
    [RankType.RT_DarkGolden] = {
        ['sprite'] = "ItemIcon/effect/tex_xl_anjin",
        ['material'] = "Materials/ItemEffectAdditive",
        ['scale'] = 1,
    },
    [RankType.RT_MultiColor] = {
        ['sprite'] = "ItemIcon/effect/tex_xl_anjin",
        ['material'] = "Materials/ItemEffectAdditive",
        ['scale'] = 1,
    },
    [RankType.RT_ThirdGearDarkGolden] = {
        ['sprite'] = "ItemIcon/effect/tex_xl_anjin",
        ['material'] = "Materials/ItemEffectAdditive",
        ['scale'] = 1,
    },
    ['Heirloom'] = {
        ['sprite'] = "ItemIcon/effect/tex_xl_cjb",
        ['material'] = "Materials/ItemEffectAdditive",
        ['scale'] = 1.75
    },
}

-- 账户默认名称
STR_ACCOUNT_DEFAULT_PREFIX = "虾米"
STR_ACCOUNT_DEFAULT_NAME = "江湖小虾米"

-- 服务器状态定义
SERVER_STATE = {
    ['LowLoad'] = 1,  -- 正常
    ['HotLoad'] = 2,  -- 火爆
    ['CrowdLoad'] = 3,  -- 拥挤
    ['Stopped'] = 4,  -- 维护
}

-- 服务器标签定义
SERVER_TAG = {
    ['Normal'] = "0",
    ['NewSvr'] = "1",
    ['HotSvr'] = "2",
}

-- 允许显示项目自带信息(如QQ群号)的渠道
CAN_SHOW_OUR_EXTRA_INFO_CANNEL = {
    [89900003] = true,
    [89900004] = true,
    [89900001] = true,
    [89900002] = true,
    [89900005] = true,
    [89900006] = true,
    [89900007] = true,
    [89900008] = true,
    [89900012] = true,
    [89900041] = true,
    [89900051] = true,
}

StorageCopacity = 5000

-- 角色精通属性
JingTongAttrs =
{
    [AttrType.ATTR_JIANFAJINGTONG] =                 "剑法精通",
    [AttrType.ATTR_DAOFAJINGTONG] =                  "刀法精通",
    [AttrType.ATTR_QUANZHANGJINGTONG] =              "拳掌精通",
    [AttrType.ATTR_TUIFAJINGTONG] =                  "腿法精通",
    [AttrType.ATTR_QIMENJINGTONG] =                  "奇门精通",
    [AttrType.ATTR_ANQIJINGTONG] =                   "暗器精通",
    [AttrType.ATTR_YISHUJINGTONG] =                  "医术精通",
    [AttrType.ATTR_NEIGONGJINGTONG] =                "内功精通",
}

-- 角色精通属性对应武器类型
JingTongWeaponTypeDict =
{
    [AttrType.ATTR_JIANFAJINGTONG] =                 ItemTypeDetail.ItemType_Sword,
    [AttrType.ATTR_DAOFAJINGTONG] =                  ItemTypeDetail.ItemType_Knife,
    [AttrType.ATTR_QUANZHANGJINGTONG] =              ItemTypeDetail.ItemType_Fist,
    [AttrType.ATTR_TUIFAJINGTONG] =                  ItemTypeDetail.ItemType_Cane,
    [AttrType.ATTR_QIMENJINGTONG] =                  ItemTypeDetail.ItemType_Rod,
    [AttrType.ATTR_ANQIJINGTONG] =                   ItemTypeDetail.ItemType_NeedleBox,
    [AttrType.ATTR_YISHUJINGTONG] =                  ItemTypeDetail.ItemType_NeedleBox,
    [AttrType.ATTR_NEIGONGJINGTONG] =                ItemTypeDetail.ItemType_Fan,
}

ADVLOOT_SITE_TYPE =
{
	ADVLOOT_SITE_MAP = 0,
	ADVLOOT_SITE_MAZE = 1,
	ADVLOOT_SITE_GRID = 2,
	ADVLOOT_SITE_DYNAC_MAP = 3,
};

-- 侠客行全服玩法 即将开抢队列显示个数
PINBALL_SERVER_PLAY_NEXT_REWARD_COUNT = 5

-- 玩家举报场景
RLAYER_REPORTON_SCENE = {
    ['WordChat'] = 1,  -- 世界聊天
    ['HouseChat'] = 2,  -- 茶馆聊天
    ['PrivateChat'] = 3,  -- 私聊
    ['UserBoard'] = 4,  -- 用户面板
}

DispositionValueDesc =
{
    ['崇敬'] = {90, 100},
    ['钦佩'] = {70, 89},
    ['欣赏'] = {40, 69},
    ['友善'] = {20, 39},
    ['普通'] = {-19, 19},
    ['厌恶'] = {-39, -20},
    ['敌视'] = {-69, -40},
    ['痛恨'] = {-89, -70},
    ['血仇'] = {-100, -90},
}

--布阵 助战offset
EMBATTLE_OFFSET_X = 1.6
EMBATTLE_OFFSET_Y = 14
EMBATTLE_OFFSET_Z = 2.0

local dispositionDescSearchCache = {}
function GetDispositionDesc(dispositionValue)
    if dispositionDescSearchCache[dispositionValue] then
        return dispositionDescSearchCache[dispositionValue]
    end
    for desc, range in pairs(DispositionValueDesc) do
        local min = range[1]
        local max = range[2]
        if dispositionValue >= min and dispositionValue <= max then
            dispositionDescSearchCache[dispositionValue] = desc
            return desc
        end
    end
    return ""
end

JUMP_AND_OPEN_ARENA = false;

ARENA_TYPE = {
    SHAO_NIAN = 1001,
    DA_ZHONG = 2001,
    DA_SHI = 3001,

    GAI_BANG = 4001,
    SHAO_LIN = 4002,
    WU_DANG = 4003,
    E_MEI = 4004,
    LIU_SHAN = 4005,
    CHANG_SHENG = 4006,
    CHI_DAO = 4007,
    TIAN_YIN = 4008,
    WU_YUE = 4009,

    HUA_SHAN = 5001,
}

ARENA_ENUM = {
    SHAO_NIAN = 1,
    DA_ZHONG = 2,
    DA_SHI = 3,
    MEN_PAI = 4,
    HUA_SHAN = 5,
}

-- 酒馆切磋Roll奖背景
HOUSE_FIGHT_ROLL_REWARD_BAC = "MapBG/sc_bg_ke4zhan4"

-- FIXME: 之后要改成多语言表
ClanStateDesc = {
    [CLAN_DISAPPEAR] = '征服',
    [CLAN_ALIGN] = '结盟',
    [CLAN_DRIVE_OUT] = '俸禄'
}

-- 测试服务器开服时间
SYSTEM_OPEN_DATE = 36

-- 是否改变过酒馆阵容
CHANGE_TEAM_BATTLE = false;

-- 公告状态
NoticeState = {
    ["Normal"] = 1,
    ["Loading"] = 2,
    ["Empty"] = 3,
    ["Pics"] = 4,
}

-- TODO
ChallengeFromType = {
    Chat = 1,
    PlayerList = 2,
}
ChallengeFrom = ChallengeFromType.PlayerList

-- 玩家无操作读档最大值, 超过弹出紧急处理
MAX_NO_PLAYER_CMD_LOAD_COUNT = 3

-- 剧情自动对话等待时间最小值 毫秒
MIN_AUTOCHAT_WAIT_TIME = 500
-- 剧情自动对话等待时间最大值 毫秒
MAX_AUTOCHAT_WAIT_TIME = 3000
-- 剧情对话打字效果最小基数
MIN_DIALOG_TYPE_SPEED_BASE = 5
-- 剧情对话打字效果最大基数
MAX_DIALOG_TYPE_SPEED_BASE = 85
-- 快进对话等待时间 毫秒
FASTCHAT_WAIT_TIME = 100
-- 快进对话漫画等待时间 毫秒
FASTCHAT_COMIC_WAIT_TIME = 300

-- 武学空白书道具ID
ID_ITEM_MakeMartialSceret = 9682

-- 累计充值
AMT_GOLD = 0;

-- 城市限时任务最大进度时间
MAX_CITY_TIMER_TIME = 3000

SQT = 6000

-- 渠道号
CHANNEL = {
    ['OFFICIAL'] = '2017',
    ['WX'] = '10000145',
    ['QQ'] = '10000144',
    ['YYB'] = '2002',
    ['TAPTAP'] = '10025553',
    ['TAPTAP2'] = '10007109',
    ['HYKB'] = '10022592',
    ['G4399'] = '10004231',
    ['HW'] = '10018084',
    ['XM'] = '10003898',
    ['BWEB'] = '10029304',
    ['OPPO'] = '10017385',
    ['VIVO'] = '10003392',
    ['IOS'] = '00000001',
}

-- 分享
SHARE_TYPE = {
    ['QIECUO'] = 1,
    ['MENPAI'] = 2,
    ['YAOQING'] = 3,
    ['TUDI'] = 4,
    ['JIESUAN'] = 5,
    ['WUPING'] = 6,
    ['CG'] = 7,
    ['CHUANGJUE'] = 8,
    ['LEITAI'] = 9,
    ['PINGTAI'] = 10,
}

-- 模拟进入剧本标记
ENTER_SCRIPT_FLAG = {};

PRISON_MAP_ID = 661

QUICK_GET_LOOT_SCRIPT_LEVEL = 1 --快速拾取 剧本难度

-- 不显示对话控制的剧本列表
HIDE_DIALOG_CONTROL_SCRIPT_LIST = {
    [8] = true,
    [9] = true,
}

TEST_STORY_ID = 6

SpecialBigSpine = {
    ["role_langyabang"] = true,
    ["role_jiaozhu"] = true,
    ["role_xiejinmao"] = true,
}

-- 允许带出阵容剧本
OUT_SCRIPT_ID = {
    [1] = 0,
    [2] = 2,
    [3] = 7,
    [4] = 10,
}

HOUSEUI_AREA_INDEX = {
	DEFAULT = 0,
    ACTIVITY = 1,
    STORAGE = 2,
	ARENA = 3,
}

SpecialScaleValue = 0.8

SERVERLIST_ROW_MAX_COUNT = 2  -- 服务器列表一行显示的服务器数量
SERVERLIST_RECOMMEND_SERVER_NUM = 3  -- 服务器列表推荐服务器数量

-- 解锁生产界面要求的经脉总等级
UNLOCK_FORGE_MERIDIANS_LEVEL = 50

-- 最大游戏内好友数量上线, 与公共服保持同步
MAX_GAME_FRIEND_COUNT = 200

-- 跨天标记枚举
DIFF_DAY_FLAG_ENUMS = {
    TREASUREBOOK = 1,
}

-- 禁止进入剧本弹窗标题
FORBID_STORY_ENTER_TIP_TITLE = 575
-- 禁止进入剧本弹窗内容
FORBID_STORY_ENTER_TIP_CONTENT = 576
-- 剧本维护局内玩家提示内容
FORBID_STORY_RETURN_HOUSE_TIP_CONTENT = 577
-- 返回酒馆 按钮文字
FORBID_STORY_RETURN_HOUSE_BUTTON_TEXT = 578
-- 维护剧本删档弹窗提示内容
FORBID_STORY_DELETE_TIP_CONTENT = 579

ITEMBATTLE_NUM = 50

SYSTEM_MODULE_DISABLE_TIP_TITLE = '功能维护中'
SYSTEM_MODULE_DISABLE_TIP_TEXT = '当前功能临时维护中，暂时无法使用，恢复时间请留意游戏内公告。'
SYSTEM_MODULE_DISABLE_TIP_BTN_TEXT = '确定'

-- 擂台玩家观察数据请求cd, ms
ARENA_OBSERVE_CD = 2000

-- 关闭体验版不开放的内容
CLOSE_EXPERIENCE_OPERATION = false

DEFAULT_MAIN_ROLE_BASE_ID = 1000001260


CHARACTER_PART = {
    [0] = "hat",
    [1] = "back",
    [2] = "hair_back",
    [3] = "body",
    [4] = "face",
    [5] = "eyebrow",
    [6] = "eye",
    [7] = "mouth",
    [8] = "nose",
    [9] = "forehead_adornment",
    [10] = "facial_adornment",
    [11] = "hair_front",
    [12] = "eyebrow_width",
    [13] = "eyebrow_height",
    [14] = "eyebrow_location",
    [15] = "eye_width",
    [16] = "eye_height",
    [17] = "eye_location",
    [18] = "nose_width",
    [19] = "nose_height",
    [20] = "nose_location",
    [21] = "mouth_width",
    [22] = "mouth_height",
    [23] = "mouth_location",
}
NEEDSMALLADJUSTPARTLIST = {[5] = true,[6] = true,[7] = true,[8] = true}
NEEDSMALLADJUSTPARTLISTNAME = {[5] = "眉毛",[6] = "眼睛",[7] = "嘴型",[8] = "鼻子"}
NEEDSMALLADJUSTPARTLISTPART = {[5] = {12,13,14},[6] = {15,16,17},[7] = {21,22,23},[8] = {18,19,20}}
NEEDSMALLADJUSTPARTLISTROOT = {[12] = 5,[13] = 5,[14] = 5,[15] = 6,[16] = 6,[17] = 6,[18] = 8,[19] = 8,[20] = 8,[21] = 7,[22] = 7,[23] = 7}

STORE_SORT_BG_HEIGHT = 50

FADEIN_TIME = 2
FADEOUT_TIME = 2

STORYID_SETTINGS = {
	[1] = false,
	[2] = true, 
	[4] = false,
	[6] = true
}

PO_TIAN_NI_MING_SCRIPT_ID = 4

SYSTEM_ANNOUNCEMENT_TYPE = {
    Notice = 1,
    Thank = 2,
}

MOVE_TYPE = {
    Manual = 1,--手动
    Automatic = 2, --自动
}