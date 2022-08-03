-- auto make by Tool ProtocolMaker don't modify anything!!!  this file define enum value

--to C++ enum [SeShareDef] Define BEGIN
SSD_MSANGO_MAGIC = 1297303375           --登录标记
SSD_MAX_SEND_SIZE = 7 * 1024            --单次发送最大网络包大小
SSD_SEND_SIZE = 64 * 1024               --用来网络发送使用(构造不定长数据包)
SSD_PRASER_SIZE = 1024 * 1024           --用于网络解包的缓冲
SSD_ENDSTR_LEN = 4                      --字符结束
SSD_EN_KEY_LEN = 4                      --加密钥匙长度
SSD_IP_LEN = 16                         --IP地址长度
SSD_STATE_NAME_LEN = 64                 --州名长度
SDD_MSG_LEN = 128                       --消息长度
SSD_ORDER_LEN = 24                      --充值订单长度
SDD_SHOW_NOTICE_LEN = 1024              --通用提示信息
SSD_PATH_LEN = 256                      --日志文件路径长度
SSD_GAME_DUMP_INDEX_NUM = 32            --崩溃线程记录最大数
SSD_MAX_PLAYER_INFO_COUNT = 100         --最大角色信息数量
SSD_TIME_STRING_LEN = 19                --时间字符串长度
SSD_MAX_SMALL_INT_NUM = 60000           --16位整型最大的范围
SSD_MAX_INT_NUM = 2000000000            --INT数值最大的范围
SSD_INSERT_MAX_STRING_LEN = 4 * 1024    --服务器插入字符串的最大长度
SSD_LOGICTOCLIENT_MAXSIZE = 1 * 1024    --客户端上行的消息最大长度
SSD_LOGIN_CHECK_LEN = 32                --版本号最大长度
SSD_MAX_PUBLIC_LOGIN_TOKEN_LEN = 512    --公共登录服token最大长
SSD_MAX_PUBLIC_LOGIN_URL_LEN = 256      --公共登录服URL最大长
SSD_MAX_PUBLIC_APPID_LEN = 64           --公共登录服appid最大长
SSD_MAX_IMG_STR_LEN = 128               --图片属性字符串最大长度
SSD_MAX_SERVER_ALIAS_STR_LEN = 32       --服务器别名最大长度
SSD_MAX_JWT_TOKEN_STR_LEN = 512         --JWTToken最大长度
SSD_MAX_COMMON_LOG_NAME_STR_LEN = 128   --日志名最大长度
SSD_MAX_COMMON_LOG_CONTENT_STR_LEN = 8 * 1024--单条日志内容最大长度
SSD_MAX_DISPLAY_LOG_CONTENT_STR_LEN = 2048--剧本单条日志内容最大长度
SSD_MAX_DEBUG_FUNCCALL_NAME = 64        --单个函数最大名称长度
SSD_MAX_DEBUG_FUNCCALL_NUMS = 30        --下行最影响效率的30个函数
SSD_ONE_MONTH_TOTAL_SEC_NUMS = 31 * 24 * 60 * 60--一月31天秒数
SSD_RESYNC_ONLINE_NUMS = 500            --重启服务时每次同步在线玩家数
SSD_MAX_ITEM_ARRAY_NUMS = 200           --项目数组最大数量
SSD_EXCHAGE_GOLD_TO_SILVER = 10         --金锭兑换银锭比例
SSD_MAX_BIG_CMD_BATCH_SIZE = 10240      --大包拆包大小
SSD_MAX_CLIENT_RECONTENT_INTERVAL = 5   --客户端重连间隔(秒)
SSD_MAX_CHATCONTENT_SIZE = 512          --全服聊天内容长度
SSD_MAX_REDPACKETUIDSTR_SIZE = 128      --红包UID长度
SSD_MAX_REDPACKETWORD_SIZE = 128        --红包口令长度
SSD_MAX_REDPACKETLIST_SIZE = 4096       --红包列表长度
SSD_MAX_REDPACKETLIMIT_SIZE = 10        --红包数
SSD_MAX_GETREDPACKETTIMES = 5           --玩家每天可领取红包数
SSD_MAX_USER_SUGGESTION_ERRORINFO_LEN = 256--玩家崩溃等原因上报长度
SSD_MAX_SYSTEMSWITCH_SIZE = 20          --系统开关数量
SSD_MAX_MAINTAIN_IP_WHITELIST_NUM = 100 --维护期间单次同步IP白名单的数量
SSD_MAX_FORBIDREASON_SIZE = 256         --封禁原因长度
SSD_MAX_HOODLESHOWPLAYER_LEN = 5        --全服小侠客显示人数
SSD_MAX_REQHOODLERECORD_LEN = 6         --全服小侠客记录一页请求数量
SSD_HOODLEPOOLBASEVALUE = 10000         --小侠客奖池基础id值
SSD_MAX_HOODLEPROCESSSHOWPLAYER_LEN = 3 --全服小侠客进度推进显示人数
SSD_MAX_HOODLERECORD_MAXLEN = 400       --全服小侠客查看历史记录
SSD_MAX_HOODLEITEMTYPE_MAXLEN = 9       --全服小侠客物品种类上限
SSD_MAX_HOODLESHOWITEM_MAXLEN = 5       --全服小侠客展示物品上限
SSD_MAX_HOODLEEXCHANGE_MAXLEN = 5       --全服小侠客物品兑换上限
SSD_MAX_CHANNELNOLEN = 32               --渠道号长度
SSD_LIMITSHOP_BIG_GOLD_WORTH = 180      --限时商店包子币价值
SSD_LIMITSHOP_FIRST_FREE_SHARE_TIMES = 2--限时商店首次分享免费次数
SSD_LIMITSHOP_FIRST_FREE_SHARE_GOLD_WORTH = 10--限时商店首次分享消耗金锭数
SSD_LIMITSHOP_GAMETYPE = 1              --限时商店猜包子币类型
SSD_MAX_GOLDOPR_PARAMLEN = 2048         --金锭操作字符串参数最大长度
SSD_MAX_LIMITSHOPDATA_SIZE = 4096       --限时商店数据长度
SSD_MAX_LIMITSHOPCONDITION_SIZE = 1024  --限时商店刷新条件字符串长度
SSD_MAX_SYSTEM_MODULE_COUNT = 64        --系统模块枚举数量上限
SSD_MAX_REQ_ACTIVITY_COUNT = 64         --最大请求活动信息数量
SSD_MAX_PUBLIC_COMMON_JSON_STR_LEN = 1024--公共服配置同步json
SSD_MAX_CLIENT_VERSION_LEN = 64         --客户端版本
SSD_MAX_CLIENT_SYSTEM_SOFTWARE_LEN = 64 --移动终端操作系统版本
SSD_MAX_CLIENT_SYSTEM_HARDWARE_LEN = 64 --移动终端机型
SSD_MAX_CLIENT_TELECOMOPER_LEN = 64     --运营商
SSD_MAX_CLIENT_DENSITY_LEN = 64         --像素密度
SSD_MAX_CLIENT_NET_WORK_LEN = 64        --3G/WIFI/2G/4G/5G
SSD_MAX_CLIENT_CPU_HARDWARE_LEN = 64    --cpu类型|频率|核数
SSD_MAX_CLIENT_GL_RENDER_LEN = 64       --opengl render信息
SSD_MAX_CLIENT_GL_VERSION_LEN = 64      --opengl版本信息
SSD_MAX_CLIENT_DEVICEID_LEN = 256       --设备ID
SSD_MAX_PLAT_AREA = 4                   --平台分线个数
SSD_MAX_PLAYER_COUNT_PER_PLAT_AREA = 30 --每个分线最大的玩家数
SSD_MAX_PLAYER_COUNT_FOR_REQ_PER_PAGE = 5--酒馆所有玩家分页请求的最大数量
SSD_MAX_PLAYER_COUNT_FOR_REQ_FROM_GS = 200--GAS从GS同步玩家信息的最大数量
SSD_BECOME_RMBPLAYER_NEED_GOLD_NUM = 380--成为壕侠玩家需要的金锭数
SSD_MAX_UPDATE_TREASURE_BOOK_TASK_NUM = 50--每次更新百宝书任务的最大数量
SSD_MAX_UPDATE_TREASURE_BOOK_MALL_NUM = 50--每次更新百宝书商店信息的最大数量
SSD_MAX_GIVE_FRIEND_ADVANCE_NUM = 20    --每月可赠送好友预约的最大数量
SSD_MAX_TREASURE_TO_MERIDIANSEXP_RATIO = 100--月末剩余百宝书残页转化为经脉经验的比率1:100
SSD_TREASUREBOOK_DIALY_SILVER_BASE_NUM = 50--百宝书每日银锭基础值
SSD_TREASUREBOOK_DIALY_SILVER_RISE_NUM = 10--百宝书每日银锭上升值
SSD_TREASUREBOOK_DIALY_SILVER_MAX_NUM = 200--百宝书每日银锭最大值
SSD_MAX_TLOG_NAME_STR_LEN = 128         --TLog表项名最大长度
SSD_MAX_TLOG_CONTENT_STR_LEN = 4096     --TLog单条记录的最大长度
SSD_MAX_TSS_SDK_PARAM_STR_LEN = 256     --屏蔽字检测参数json最大长度
SSD_MAX_TSS_SDK_CONTENT_STR_LEN = 1024  --屏蔽字最大长度
SSD_MAX_GAME_APP_PARAM_STR_LEN = 64     --游戏APP参数
SSD_MAX_CLIENT_CONTENT_STR_LEN = 4096   --上报字符串的最大长度
SSD_MAX_ANTIADDICTION_RET_INSTRUCTION_JSON_LEN = 1024--防沉迷返回Json解析最大长度
SSD_MAX_SEC_TSS_REPORT_DATA_LEN = 128   --安全日志TSSSDK上报信息最大长度
SSD_MAX_SEC_TSS_SYNC_CLIENT_DATA_LEN = 33000--安全SDK同步客户端最大长度长
SSD_MAX_SEC_TSS_SYNC_CLIENT_EXT_DATA_LEN = 1024--安全SDK同步客户端额外数据长度长
SSD_MAX_SEC_REPORT_CHEAT_TYPE_LEN = 32  --举报组合类型最大长
SSD_MAX_SEC_REPORT_CHEAT_CONTENT_LEN = 200--举报内容
SSD_MAX_TSS_SDK_CREDIT_SCORE_PARAM_STR_LEN = 2048--腾讯信用分查询参数json最大长度
SSD_MAX_SEC_REPORT_CHEAT_DESC_LEN = 25  --用户填写的举报说明
SSD_MAX_SEC_REPORT_CHEAT_PIC_URL_LEN = 256--用户填写的举报头像
SSD_MAX_HEART_PACKAGE_TIME = 10000      --登录标记
SSD_MAX_WS2DB_HEART_PACKAGE_TIME = 20*1000--心跳包时间
SSD_MAX_DISCONNECT_WITH_NO_CLIENT_REPLAY = 60*1000--玩家无响应多少秒断开连接
SSD_MAX_CLIENT_REBUILD_CONNECT_TIME = 180--客户端重连恢复最大时间(秒)
SSD_MAX_MAIL_APPID_LEN = 64             --邮件APPID最大长度
SSD_MAX_MAIL_USERID_LEN = 64            --邮件USERID最大长度
SSD_MAX_MAIL_REEIVER_LEN = 64           --接收用户最大长度
SSD_MAX_MAIL_TITLE_LEN = 128            --标题最大长度
SSD_MAX_MAIL_CONTENT_LEN = 1024         --邮件内容最大长度
SSD_MAX_MAIL_ATTACH_LEN = 512           --附件最大长度
SSD_MAX_MAIL_ATTACH_NUM = 10            --附件最大数量
SSD_MAX_GM_MAIL_SEND_NUM = 1000         --在指定的情况下，GM可同时发送邮件的最大玩家数
SSD_MAX_MAIL_FILTER_NUM_LEN = 32        --邮件过滤器中属性字符串的长度
SSD_MAX_GM_MAIL_FILTER_LEN = 256        --邮件过滤器总字符长
SSD_MAX_OPR_MAIL_NUM = 30               --客户端操作邮件的最大数量
SSD_MAX_RECEIVE_MAILID_JSON_LEN = 512   --领取附件的邮件ID个数JSON最大长度
SSD_MAX_RECEIVERET_MAIL_JSON_LEN = 8192 --返回领取邮件的总JSON最大长度
SSD_MIN_ACCOUNT = 4                     --帐号名最小长度
SSD_MAX_ACCOUNT = 56                    --帐号名最长长度
SSD_MIN_PASSWORD = 6                    --密码最小长度
SSD_MAX_PASSWORD = 36                   --密码最大长度
SSD_MAX_LOGINTYPE = 36                  --登陆类型最大长度
SSD_MAX_TOKEN = 36                      --登陆token最大长度
SSD_MAX_MOBILEINFO = 36                 --手机标识最大长度
SSD_MAX_DEVICEINDEFY = 64               --设备唯一标识最大长度
SSD_MAX_GUEST_ID = 32                   --游客账号最大长度
SSD_MAX_ACCOUNT_ID = 32                 --账号ID最大长度
SSD_MAX_OPEN_ID = 64                    --OpenID最大长度
SSD_MAX_SYSTEMINFO_LEN = 1024           --机型信息最大长度
SSD_MAX_OPEN_KEY = 256                  --OpenKey最大长度
SSD_MAX_PF_KEY = 128                    --pfKey最大长度
SSD_MAX_BILLNO_LEN = 64                 --BillNO最大长度
SSD_MIN_CHAR_NAME = 2                   --角色名最小长度
SSD_MAX_CHAR_NAME = 32                  --角色名最大长度
SSD_MAX_SHOW_CHAR_NAME = 16             --角色名最大显示长度
SSD_MAX_RECON_TIME_RACE = 3 * 60 * 1000 --单局断线重连保存时间
SSD_MAX_ROLE_TITLE = 32                 --角色称号最大程度
SSD_MAX_ROLE_ITEM_CAP_NUMS = 2000       --玩家背包最大数量
SSD_MAX_ROLE_ITEM_NUMS = 100            --玩家背包最大数量
SSD_MAX_ROLE_TEAMMATES_NUMS = 200       --玩家队友最大数量
SSD_MAX_INVITE_TEAMMATES_NUMS = 100     --玩家邀请队友最大数量
SSD_MAX_ITEM_ATTR_NUMS = 20             --物品额外属性最大数量
SSD_MAX_CREATEROLE_ATTR_NUMS = 30       --创角属性数量
SSD_MAX_CREATEROLE_NUMS = 50            --可创角最大数量
SSD_MAX_DISPOSITIONS_NUMS = 50          --单条发送的好感度最大数量
SSD_MAX_ROLE_GIFT_NUMS = 100            --角色天赋最大数量
SSD_MAX_TAG_NUMS = 1000                 --标记最大数量
SSD_MAX_ROLE_WISHTASKS_NUMS = 20        --角色星愿最大数量
SSD_MAX_ROLE_MARTIAL_NUMS = 50          --角色武学最大数量
SSD_MAX_ROLE_DISPLAYATTR_NUMS = 100     --角色显示属性最大数量
SSD_MAX_ROLE_GUANCA_NUMS = 400          --角色观察界面显示属性最大数量
SSD_MAX_NPC_ITEM_NUMS = 36              --NPC背包最大数量
SSD_MAX_APPEARANCE_LEN = 36             --修改形象参数最大长
SSD_RENAME_COST_GOLD_NUM = 100          --改名扣除的金锭数
SSD_RENAME_COST_SILVER_NUM = 1000       --改名扣除的金锭数
SSD_MAX_ROLE_FAVOR_NUM = 5              --角色喜好最大数量
SSD_MAX_ROLE_BROANDSIS_NUM = 100        --角色结义数量
SSD_MAX_ROLE_INTERACT_USED_NUM_LEN = 128--切磋等角色交互使用次数字符存储最大长
SSD_MAX_ROLE_COMMON_INFO_LEN = 64       --通用信息查询最大长
SSD_MAX_ROLE_PETS_NUM = 20              --玩家宠物上限
SSD_MAX_UNLOCKDISGUISE_NUMS = 100       --解锁易容最大数量
SSD_MAX_CANNOTLEAVE_NUMS = 10           --不可离队最大数量
SSD_MAX_CANNOTLEAVE_LENGTH = 128        --不可离队字段最大长度
SSD_RANDOMGIFT_COUNT = 3                --随机天赋数量
SSD_RANDOMWISHTTASKREWARD_COUNT = 3     --随机心愿数量
SSD_MAX_ROLE_SKIN = 20                  --每个创角角色最大皮肤数
SSD_CREATGIFT_COUNT = 3                 --创角天赋数量
SSD_MAX_ROLE_CONTACT_ROW_NUM = 3        --单行角色最大好感度行数
SSD_MAX_ROLE_CONTACT_COLUMN_NUM = 3     --单个角色最大好感度列数
SSD_MAX_ROLE_CONTACT_ITEM_NUM = 9       --单个角色最大好感度数(最大行*最大列)
SSD_BASE_ATTR_STR_LEN = 256             --角色基础属性字符串长度
SSD_MAX_USER_ACCOUNT_TAG_JSON_STR_LEN = 256--角色登录标签Json字符串长度
SSD_MAX_CHAR_KV = 1024                  --kv数据
SSD_MAX_USER_PICTURE_URL_LEN = 256      --角色微信或QQ头像链接字符串长度
SSD_MAX_ROLE_GIFT = 20                  --创角最大天赋数量
SSD_MAX_QUERY_FRIEND_INFO_NUM = 100     --最大请求好友信息的好友数
SSD_MAX_UPDATE_FRIEND_ATTR_KEY_LEN = 32 --好友属性服务中额外业务信息key最大长
SSD_MAX_UPDATE_FRIEND_ATTR_VALUE_LEN = 1024--好友属性服务中额外业务信息value最大长
SSD_MAX_QUERY_FRIEND_SHAREDATA_KEY_LEN = 64--查询好友数据
SSD_MAX_ADD_FRIEND_NUM = 200            --可添加好友的最大数量
SSD_MAX_MERIDIANS_ACUPOINT_NUM = 80     --经脉穴位最大数量
SSD_MAX_ROLE_EMBATTLE_MARTIAL_LEN = 64  --角色出阵武学记录最大长度
SSD_MAX_ROLE_EMBATTLE_MARTIAL_NUM = 50  --可出战的武学最大数量
SSD_MAX_ROLE_COMBO_NUM = 5              --combo最大数量
SSD_MAX_MARTIAL_EXTARUNLOCK_CLAUSE_LEN = 64--每个武学额外解锁的武学条目最大长度
SSD_MAX_MARTIAL_EXTARUNLOCK_CLAUSE_NUM = 8--每个武学额外解锁的武学条目最大数量
SSD_MAX_INCOMPLETE_BOOK_UPLVL_NUM = 10  --通过残章可提升的最大武学等级上限(提升区间为11-20)
SSD_MAX_MARTIAL_ATTR_NUM = 20           --每个武学最大的属性数量
SSD_MAX_MARTIAL_UNLOCKITEM_NUM = 20     --每个武学最大的解锁条目数量
SSD_MAX_MARTIAL_NUM = 64                --武学最大数量
SSD_DEFAULT_MARTIAL_NUM = 10            --默认武学数量
SSD_INCOMPLETEBOOK_RECORD_NUM = 100     --残章匣每次下发更新的最大数量
SSD_AI_LIST_NUM = 15                    --AI策略最大长度
SSD_AI_CUSTOM_INDEX = 101               --自定义AI策略索引
SSD_SCRIPT_BITS = 32                    --剧本ID所占位数
SSD_MAX_SCRIPT_NUM = 10                 --剧本最大数
SSD_MAX_SCRIPT_PLAT_NUM = 50            --剧本最大带入带出物品数
SSD_WEEKLYDEFAULT_LUCKYVALUE = 100      --每周重置的幸运值
SSD_MAX_LUCKYVALUE = 990                --玩家最大幸运值
SSD_ENTER_SCRIPT_CARRY_SPECIAL_DATA_NUM = 100--进剧本时带入特殊数据的个数
SSD_BUY_UNLOCK_NEXT_DIFF_SILVER_NUM = 1000--剧本购买难度消耗的银锭数量
SSD_MAX_SEND_SCRIPT_PLAYER_ARRAY_NUMS = 100--剧本内发送在线信息数组最大数量
SSD_MAX_SILVER_UNLOCK_SCRIPT_DIFF = 10  --通过银锭可购买的最大难度
SSD_MAX_STORY_WEEK_LIMIT_INFO_NUM = 20  --剧本周限制信息最大数量
SSD_MAX_SPECIAL_ITEM_UNLOCK_SCRIPT_DIFF = 21--通过解锁道具解锁的最大难度
SSD_MAX_EVOLUTION_RECORD_NUM = 100      --演化保存总记录条数
SSD_MAX_EVOLUTION_EACH_RECORD_LEN = 32  --演化每条记录最大长度
SSD_MAX_EVOLUTION_DOWNLOAD_NUM = 200    --每次下行最多的演化数量
SSD_MAX_EVOLUTIONRECORD_NUM = 100       --下行最多的演化记录数量
SSD_BATTLE_GRID_WIDTH = 8               --战斗地图宽度
SSD_BATTLE_GRID_HEIGHT = 5              --战斗地图高度
SSD_BATTLE_ROUND_TIME = 2               --战斗轮次时间
SSD_MAX_EMBATTLE_NUMS = 50              --布阵最大数量
SSD_MAX_INIT_EACH_EMBATTLE_NPC_NUMS = 5 --初始单场布阵人数
SSD_MAX_BATTLE_ROUND = 20               --战斗最大回合数
SSD_MAX_BATTLE_LOG = 20                 --单次最大log数量
SSD_MIN_POWER_THROUGH = 1000            --暗器弹射和穿透威力衰减的最小值 /10000
SSD_POWER_THROUGH_INIT = 2000           --暗器弹射和穿透威力递减初始值 /10000
SSD_BATTLE_INIT_MOVE = 3                --初始移动格子
SSD_MAX_BATTLE_END_AWARD_NUMS = 200     --最大结算奖励数量
SSD_MAX_REBUILD_BATTLE_MAX_BUFF_LEN = 64--战斗恢复数据中敌人buff字符串最大长度
SSD_MAX_REBUILD_BATTLE_MAX_TREASURE_BOX_LEN = 64--战斗回复数据中宝箱字符串最大长度
SSD_MAX_REBUILD_BATTLE_NEXT_ENEMY_GIFT_LEN = 76--战斗恢复数据中敌人天赋字符串最大长度
SSD_MAX_REBUILD_BATTLE_NEXT_FRIEND_GIFT_LEN = 76--战斗恢复数据中友方天赋字符串最大长度
SSD_MAX_REBUILD_BATTLE_WHELL_ROUND_LEN = 28--战斗恢复数据中车轮战战斗ID字符串最大长度
SSD_MAX_REBUILD_BATTLE_PREUNIT_LEN = 32 --战斗恢复数据中下一轮上阵单位字符串最大长度
SSD_MAX_REBUILD_BATTLE_EXTASK_MONITOR_LEN = 32--战斗恢复数据中额外任务监听字符串最大长度
SSD_MAX_REBUILD_BATTLE_ACC_MARTIAL_EXP_LEN = 256--战斗恢复数据中角色武学经验累积字符串最大长度
SSD_MAX_YUANHU_LEN = 5                  --战斗回复数据中援护字符串最大长度
SSD_MAX_UNIT_LEN = 64                   --战斗回复数据中单位最大长度
SSD_MAX_TARGET_LEN_SELECT = 20          --战斗计算数据中单位最大长度
SSD_MAX_TARGET_LEN = 30                 --战斗回复数据中单位最大长度
SSD_MAX_BATTLEINFO_LEN = 1024           --战斗回复数据中单次信息最大长度
SSD_MAX_ROLEEMBATTLE_LEN = 100          --战斗外布阵成员信息数量
SSD_MAX_ASSIST_LEN = 10                 --助战成员数量
SSD_MAX_EQU_LEN = 10                    --助战成员数量
SSD_MAX_PLOT_LEN = 20                   --plot数量
SSD_MAX_HEJI_LEN = 20                   --合击数量
SSD_MAX_BUFF_LEN = 200                  --buff数量
SSD_MAX_TREASURE_BOX_LEN = 20           --宝箱数量
SSD_MAX_TREASURE_BOX_AWARD_LEN = 20     --宝箱掉落数量
SSD_MAX_MAP_NPC_NUMS = 32               --单个地图包含的最大人物数
SSD_MAX_MAP_STR_LEN = 256               --单个地图占位ID存储最大长度
SSD_MAX_CITYEVENTS_NUMS = 16            --最大城市间事件数量
SSD_MAX_CITYDATA_NUMS = 100             --最大下行城市数量
SSD_MAP_ADV_LOOT_BINARY_MAX_LEN = 1024  --地图垃圾二进制数据长度最大值
SSD_MAP_MAP_FOREGROUND_MAX_LEN = 32     --地图前景长度最大值
SSD_MAP_MAP_REFCOUNT_MAX_LEN = 64       --地图引用计数长度最大值
SSD_MAX_RANDOM_CITY_MOVE_NPC_COUNT = 8  --地图随机移动NPC数量最大值
SSD_MAX_SELECT_NUMS = 20                --选项最大数量
SSD_MAX_PLOT_NUMS = 128                 --单次数据最大数量
SSD_MAX_SHOWFOREGROUND_NUMS = 16        --显示前景最大数量
SSD_MAX_MAZE_BUFF_NUMS = 8              --迷宫Buff最大数量
SSD_MAX_MAZE_BUFF_LEN = 8 * 8           --迷宫Buff最大字符串最大长度
SSD_MAX_MAZE_AREA_NUMS = 8              --迷宫区域最大数量
SSD_MAX_MAZE_AREA_LEN = 8 * 5           --迷宫区域字符串最大长度
SSD_MAX_MAZE_GRID_NUMS = 8              --迷宫区域网格最大数量
SSD_MAX_MAZE_GRID_LEN = 8 * 5           --迷宫区域网格字符串最大长度
SSD_MAX_MAZE_AREA_GRID_NUMS = 400       --迷宫区域地形格最大数量
SSD_MAX_MAZE_AREA_GRID_STATE_SIZE = ((SSD_MAX_MAZE_AREA_GRID_NUMS * 2) / 32)--迷宫区域地形格位组数组长度
SSD_MAX_MAZE_AREA_GRID_BITS_LEN = 276   --迷宫区域格位组字符串最大长度
SSD_MAX_MAZE_CARD_ADV_LOOT_NUMS = 32    --迷宫卡片掉落最大数量
SSD_MAX_MAZE_CARD_DYNAMIC_ADV_LOOT_NUMS = 32--迷宫卡片动态掉落最大数量
SSD_MAX_DYNAMIC_ADV_LOOT_NUM = 200      --动态掉落最大数量
SSD_MAX_MAZE_CARD_ADV_LOOT_LEN = 32 * 5 --迷宫卡片掉落最大长度
SSD_MAX_ADV_LOOT_BINARY_STR_LEN = 1024  --迷宫中垃圾二进制转成字符串的最大长度
SSD_MAX_UPDATE_MAZE_COUNT = 512         --单次更新迷宫最大数量
SSD_MAX_UPDATE_MAZE_AREA_COUNT = 16     --单次更新迷宫区域最大数量
SSD_MAX_UPDATE_MAZE_GRID_COUNT = 512    --单次更新迷宫格最大数量
SSD_MAX_UPDATE_MAZE_CARD_COUNT = 256    --单次更新迷宫卡片最大数量
SSD_MAX_OPR_PLAT_ITEM_NUM = 100         --一次性操作平台物品的的最大数量
SSD_MAX_SELECT_SUBMIT_ITEM_NUM = 20     --一次性提交物品的的最大数量
SSD_MAX_SHOP_ITEM_NUMS = 100            --商店最大下行物品数量
SSD_MAX_ADVLOOT_ITEM_NUMS = 1000        --最大冒险掉落下行数量
SSD_MAX_PLAT_ITEM_CHOOSEGIFT_NUM = 5    --平台物品最大选择礼包数量
SSD_ITEM_USE_LEVEL_UP_LIMIT = 4         --物品使用等??l件?_始提升的??化等?初值
SSD_ITEM_PROTECT_ENHANCE_GRADE = 5      --物品资产保护的强化等级
SSD_MAX_HOODLE_LOTTERY_SLOTINFO_LEN = 64--弹珠池中弹珠槽信息最大长度
SSD_MAX_HOODLE_PROGRESS_BOXINFO_LEN = 64--弹珠池中进度槽信息最大长度
SSD_MAX_HOODLE_SLOT_NUM = 7             --弹珠槽最大数量
SSD_MAX_HOODLE_PROGRESS_BOX_NUM = 4     --进度槽最大数量
SSD_HOODLE_SILVER_EXCHANGE_NUM = 248    --兑换小侠客所需银锭数
SSD_HOODLE_SILVER_EXCHANGE_TO_MERIDIANS_NUM = 10--银锭兑换小侠客赠送的经脉经验
SSD_MAX_DAILY_FREE_LITTLE_WARRIOR_NUM = 3--每日赠送免费小侠客数量
SSD_MIN_OPEN_TEN_SHOOT_HOODLE_NUM = 300 --开启单抽十颗功能需要累计的使用小侠客最低有效数量
SSD_ONCE_REPEAT_HOODLE_BALL_NUM = 10    --十连(多抽)弹珠数量
SSD_MAX_CHILD_MARTIAL_LEN = 128         --孩子可带出的武学最大长度
SSD_MAX_CHILD_GIFT_LEN = 128            --孩子可带出的天赋最大长度
SSD_MAX_CHILD_ATTR_LEN = 128            --孩子可带出的基础属性最大长度
SSD_MAX_CHILD_TASK_LEN = 128            --孩子可带出的任务最大长度
SSD_MAX_TAKEOUT_BABY_NUM = 10           --可带出创角的孩子最大数量
SSD_MAX_TAKEOUT_BABYS_LEN = 128         --可带出创角的孩子最大长度
SSD_MAX_ACHIEVE_NUMS = 100              --平台成就的的最大数量
SSD_MAX_CARRY_ACHIEVE_REWARD_NUMS = 50  --开局带入成就条目的最大数量
SSD_MAX_ACHIEVE_BINARY_STR_LEN = 4096   --平台成就二进制存储最大值
SSD_MAX_ACHIEVE_RECORD_MAX_NUM = 100    --单类成就记录数据最大条数
SSD_MAX_ACHIEVE_SEND_MAX_NUM = 100      --成就发送最大条数
SSD_MAX_DIFFDROP_SEND_MAX_NUM = 100     --全局难度掉落控制发送最大条数
SSD_MAX_CLAN_NUMS = 100                 --门派最大数量
SSD_MAX_CLAN_ELIMINATED_LEN = 64        --门派灭门统计字符串
SSD_MAX_BUILDING_NAME_LEN = 32          --门派建筑名最大长度限制
SSD_MAX_MATERIAL_CLASS = 16             --门派建筑产出材料种类
SSD_MAX_DISCIPLENUM_PER_BUILDING = 2    --每个建筑最多容纳弟子数
SSD_MAX_BUILDING_NUM_PER_FLOOR = 4      --每层最多建筑数量
SSD_MAX_CITY_EVENT_NUMS = 4             --城市事件最大数量
SSD_MAX_CITY_EVENT_LEN = 16 * 10        --城市事件最大长度
SSD_MAX_CITY_TIMER_COUNT = 16           --城市计时器最大数量
SSD_MAX_CITY_TIMER_LEN = 16 * 10        --城市计时器最大长度
SSD_MAX_CITY_TASK_NUMS = 12             --城市任务最大数量
SSD_MAX_SEND_UNLOCK_NUMS = 100          --某类解锁一次性下发解锁信息最大数量
SSD_MAX_ONCE_TALK_STR_LEN = 720         --玩家一次聊天内容的最大长度
SSD_MAX_PUBLIC_CHANNEL_CHAT_COST_GOLD_NUM = 1--频道聊天消耗的元宝数
SSD_MAX_PUBLIC_CHANNEL_CHAT_COST_SILVER_NUM = 1--频道聊天消耗的银锭数
SSD_MAX_PUBLIC_CHANNEL_CHAT_EACH_TALK_SEC = 3--频道聊天每次间隔秒数
SSD_MAX_PUBLIC_CHANNEL_CHAT_ONE_MINUTES_MAX_NUM = 10--频道聊天一分钟最多讲话次数
SSD_MAX_PUBLIC_CHANNEL_CHAT_TEN_MINUTES_MAX_NUM = 30--频道聊天十分钟最多讲话次数
SSD_MAX_PRIVATE_SESSION_ID_LEN = 128    --私聊的SessionID
SSD_MAX_WORLD_FREE_TALK_MERIDIANS_LVL = 0--世界免费聊天需要的经脉等级
SSD_MAX_TASK_PARAM_LEN = 256            --任务存储最大长度
SSD_MAX_TASK_DESC_NUMS = 20             --单个任务描述数量最大值
SSD_MAX_TASK_NOT_REPEATED_EDGE_NUMS = 64--单个任务不可重复边数量最大值
SSD_MAX_TASK_EDGE_NUMS = 256            --单个任务边数量最大值
SSD_MAX_CUSTOM_PARAMS_NUMS = 20         --自定义参数个数
SSD_MAX_TASK_DYNAMIC_DATA_NUMS = 48     --动态数据个数最大值
SSD_MAX_TASK_CUSTOM_KEY_DYNAMIC_DATA_NUMS = 96--自定义键的动态数据个数最大值
SSD_MAX_TASK_NORMAL_REWARD_NUMS = 8     --任务动态通用奖励最大数量
SSD_MAX_TASK_NORMAL_REWARD_STR_LEN = 100--任务动态通用奖励序列化字符串最大长度
SSD_MAX_TASK_REWARD_NUMS = 8            --任务动态奖励最大数量
SSD_MAX_TASK_DISPO_REWARD_FINAL_DELTA_NUMS = 8--任务实际好感度变化最大数量
SSD_MAX_TASK_REWARD_STR_LEN = 100       --任务动态奖励序列化字符串最大长度
SSD_MAX_TASK_ROLE_DISPOSITION_REWARD_LENS = 44--角色好感奖励列表存储字符串长
SSD_MAX_TASK_CLAN_DISPOSITION_REWARD_LENS = 44--门派好感奖励列表存储字符串长
SSD_MAX_TASK_CITY_DISPOSITION_REWARD_LENS = 44--城市好感奖励列表存储字符串长
SSD_MAX_RANKID_LEN = 32                 --排行榜ID最大长度
SSD_MAX_RANK_SCORE_LEN = 64             --排行榜分数最大长度
SSD_MAX_SNAP_LEN = 8                    --排行榜快照最大长度
SSD_MAX_UPDATE_NUMS = 20                --排行榜最大更新条数
SSD_MAX_MEMBER_LEN = 128                --member最大长度
SSD_MAX_RANK_NUMS = 30                  --排行榜最大条目数
SSD_MAX_TITLE_RANK_NUMS = 150           --称号榜最大条目数
SSD_ROLE_DISPOSITION_100 = 100
SSD_ROLE_DISPOSITION_RATE = 2000        --角色好感衰减系数
SSD_ROLE_DISPOSITION_NUM = 5000         --角色好感衰减系数
SSD_ROLE_DISPOSITION_DEFAULT = 10       --默认npc对主角好感度
SSD_ROLE_DISPOSITION_LOW_STATE_1 = -1   --低好感度-1
SSD_ROLE_DISPOSITION_LOW_STATE_51 = -51 --低好感度-51
SSD_ROLE_DISPOSITION_LOW_STATE_100 = -100--低好感度-100
SSD_MAX_RANDOM_EVOLUTION_ROLE = 250     --参与随机演化人物数量
SSD_EVOLUTION_CHAIN_LIMIT_NUM = 15      --个人关系链演化
SSD_MAX_EVOLUTIONRECORD_SAVE_NUM = 500  --最大演化记录保存上限
SSD_MAX_TREASUREMAZE_MAILRECV_SEC = 60 * 60--宝藏分享好友邮件领取时间限制1个小时
SSD_MAX_TREASUREMAZE_SHARE_FRIENDNUMS = 100--宝藏分享好友最高人数
SSD_MAX_ARENA_MATCH_NUMS = 20           --比赛最大数量
SSD_MAX_ARENA_BATTLE_NUMS = 32          --战斗最大数量
SSD_MAX_ARENA_SIGNUP_MEMBER_NUMS = 32   --入围玩家最大数量
SSD_MAX_ARENA_BET_RANK_NUMS = 100       --比赛最大榜单玩家数量
SSD_MAX_ARENA_TEAM_DATA_MAX_SIZE = 3072 --阵容数据最大值
SSD_MAX_ARENA_PK_DATA_MAX_SIZE = 40960  --PK数据最大值
SSD_MAX_ARENA_PK_DATA_MAX_COUNT = 2     --PK数据最大类型值
SSD_MAX_ARENA_RECORD_DATA_MAX_SIZE = 65536--录像数据最大值
SSD_MAX_ARENA_RECORD_DATA_ALL_MAX_SIZE = 1048576--录像数据最大值
SSD_MAX_ARENA_ROLE_SIZE = 5             --擂台赛最大上阵角色数量
SSD_MAX_REQUEST_ARENA_CMD_SIZE = 64     --客户端请求擂台操作最大数量
SSD_MAX_FINALBATTLE_TEAM_NUMS = 16      --大决战队伍最大数量
SSD_MAX_REST_TEAMMATES_NUMS = 32        --已休息队友最大数量
SSD_MAX_REST_TEAMMATES_LEN = 352        --已休息队友最大长度
SSD_MAX_FINALBATTLE_ALIVEFRIEND_LEN = 36--大决战城市存活队友ID字符串长
SSD_MAX_FINALBATTLE_DEADFRIEND_LEN = 36 --大决战城市死亡队友ID字符串长
SSD_MAX_FINALBATTLE_ALIVEENEMY_LEN = 36 --大决战城市存活敌方ID字符串长
SSD_MAX_FINALBATTLE_DEADENEMY_LEN = 36  --大决战城市死亡敌方ID字符串长
SSD_MAX_HIGHTOWER_REST_TEAMMATES_NUMS = 60--千层塔已休息队友最大数量
SSD_MAX_QUERYRACK_ITEM_NUMS = 32        --每次查询商城物品最大数量
SSD_MAX_ADD_PLAT_ITEM_NUM = 10          --一次性操作添加物品的的最大数量
SSD_MAX_BUY_PLAT_ITEM_NUM = 10          --每次购买最大的数量
SSD_MAX_PLAT_ITEM_USEMAX_NUM = 99       --单次平台使用物品最大数量
SSD_MAX_PLATTEAM_MAX_SIZE = 20*1024     --平台阵容数据最大值
SSD_MAX_INSTROLE_MAX_SIZE = 30*1024     --平台阵容实例角色数据最大值
SSD_MAX_COMMON_MAX_SIZE = 1024          --平台布阵通用数据最大值
SSD_MAX_EMBATTLE_MAX_SIZE = 1024        --平台布阵数据最大值
SSD_MAX_QUERYRACK_RACK_NUMS = 10        --每次查询商城货架最大数量
SSD_MAX_RANK_MEMBER_MAX_SIZE = 128      --排行榜member最大长度
SSD_CHALLENGEORDER_MID_LOGIN_DAYS = 30  --免费升中级挑战令登录天数
SSD_CHALLENGEORDER_MID_PRICE = 18       --中级挑战令价格
SSD_CHALLENGEORDER_HIGH_PRICE = 68      --高级挑战令价格
SSD_MAX_INQUIRY_GOODEVIL_PLUS = 30      --仁义值低于30不可盘查
SSD_MAX_INQUIRY_GOODEVIL_MINUS = -30    --仁义值高于-30不可盘查
SSD_DOUBT_PERVERSITY_GIFTID = 1781      --盘查用天赋可疑的戾气id
SSD_DOUBT_BLOOD_GIFTID = 1782           --盘查用天赋可疑的血迹id
SSD_DOUBT_MARTIAL_GIFTID = 1783         --盘查用天赋可疑的招数id
SSD_DOUBT_BAG_GIFTID = 1784             --盘查用天赋可疑的包裹id
SSD_ZHUWEITIPSNEEDMONEY = 10000         --助威全服提示额度
SSD_COLLECTIONPOINT_MAX_SIZE = 20       --收藏点数最大长度
SSD_MAX_MATCH2ROLEVEC_SIZE = 256        --比赛角色组合串最大长度
SSD_MAX_MATCH2RANDROLEVEC_SIZE = 256    --随机角色组合串最大长度
SSD_MAX_MATCH2STATE_SIZE = 256          --比赛状态组合串最大长度
SSD_CREDIT_SCORE_QUERY_TIMEOUT = 5      --信用分接口请求超时时间 5秒
SSD_CREDIT_SCORE_EXPIRES_TIME = 4*3600  --信用分过期时间
SSD_CREDIT_SCORE_SCENE_LIMIT_EXPIRES_TIME = 5*60--场景限制过期时间
SSD_LIMIT_SHOP_MAX_YAZHU_INFO_LEN = 2048--押注信息最大长度
SSD_PALT_CHALLENGE_REWARD_ITEM_MAX = 5  --平台切磋物品奖励每日最大次数
SSD_PALT_CHALLENGE_REWARD_GIFTPACK_MAX = 2--平台切磋礼包奖励每日最大次数
SSD_MAX_ZM_BATTLE_CARD_SIZE = 7         --最大上阵卡牌数量
SSD_MAX_ZM_SELECT_CARD_SIZE = 4         --最大选择卡牌数量
SSD_MAX_ZM_SELECT_CLAN_SIZE = 3         --最大选择掌门数量
SSD_MAX_ZM_SELECT_EQUIP_SIZE = 4        --最大选择装备数量
SSD_MAX_ZM_CARD_POOL_SIZE = 32          --卡池数量
SSD_MAX_ZM_CARD_SIZE = 120              --最大卡牌数量
SSD_MAX_ZM_EQUIP_SIZE = 32              --最大装备数量
SSD_MAX_ZM_BATTLE_NUMS = 64             --战斗最大数量
SSD_MAX_ZM_PLAYER_NUMS = 32             --玩家最大数量
SSD_MAX_ZM_NOTICE_PAIRS_NUMS = 32       --最大通知数量
SSD_MAX_ZM_FREEZE_CARD_SIZE = 16        --最大拌掉卡牌
SSD_MAX_ZM_ROLE_CARD = 400              --最大平台卡片
SSD_GRAB_TITLE_MAX_PLAYER_NUM = 50      --前100玩家
SSD_MAX_RESDROP_ACTIVITY_NUM = 100      --最大开启活动数
SSD_MAX_COLLECT_ACTIVITY_TASK_NUM = 20  --最大收集任务数
SSD_MAX_COLLECT_ACTIVITY_EXCHANGE_BASE_ID = 150001--收集活动兑换次数标记开始的id, 在TaskTag表中定义划分范围
SSD_OPENTREASURE_GIVEFRIENDDROPID = 10029--开启藏宝图好友获取奖励掉落id
SSD_MAX_KVSTORE_KEY_LEN = 1024          --key最大长度
SSD_MAX_KVSTORE_VALUE_LEN = 4096        --value最大长度
SSD_DEFAULT_LANDLADY_ID = 10090001      --默认老板娘id
SSD_MAX_PLAT_ITEM_TO_SCRIPT_NUMS = 99*99--仓库带入剧本物品单次最大数量限制
SSD_MAX_GUIDE_FLAG_ARRAY_SIZE = 10      --引导信息最大数组长度
SSD_MAX_DAILYDELSCRIPT_NUMS = 5         --剧本每日最高删档次数限制
SSD_DEFAULT_TEAPOT_ID = 10110001        --默认摆件id
SSD_MAX_UNKNOWNSIZE_512 = 512           --未知大小512
SSD_MAX_UNKNOWNSIZE_1024 = 1024         --未知大小1024
SSD_MAX_UNKNOWNSIZE_65536 = 65536       --未知大小65536
SSD_MAX_ROLEFACE_LEN = 256              --捏脸数据字符串储存长度
SSD_MAX_MAINROLE_NICKNAME = 8400        --主角昵称数据储存长度
--to C++ enum [SeShareDef] Define END

--to C++ enum [SeChangeType] Define BEGIN
SCT_NULL = 0
SCT_UPDATE = 1
SCT_INSERT = 2
SCT_DELETE = 3
SCT_NUM = 4
--to C++ enum [SeChangeType] Define END

--to C++ enum [SeConnectState] Define BEGIN
SCS_UNKOWN = 0                          --未知状态
SCS_VALID_FAILED = 1                    --失败
SCS_VALID_OK = 100                      --成功
--to C++ enum [SeConnectState] Define END

--to C++ enum [SeRedPacketType] Define BEGIN
SRPT_NULL = 0
SRPT_MONEY = 1
SRPT_ITEM = 2
--to C++ enum [SeRedPacketType] Define END

--to C++ enum [SeOpenTreasureType] Define BEGIN
SOTT_NULL = 0
SOTT_SELF = 1
SOTT_FRIEND = 2
--to C++ enum [SeOpenTreasureType] Define END

--to C++ enum [SeBroadChatType] Define BEGIN
SBCT_NULL = 0
SBCT_PAOMA = 1                          --跑马
SBCT_DANMU = 2                          --弹幕
SBCT_DENGLUCI = 3                       --登录词
SBCT_DANMUJILU = 4                      --弹幕并聊天框
SBCT_CLEARONEPLAYERCHAT = 5             --清空聊天
SBCT_SendRedTip = 6                     --红包提示
SBCT_SysTips = 7                        --系统聊天框
SBCT_PINBALLREWARD = 8                  --侠客行获奖
--to C++ enum [SeBroadChatType] Define END

--to C++ enum [SeChangeBaseOptType] Define BEGIN
SCBOT_NULL = 0
SCBOT_GOLD = 1
SCBOT_SILVER = 2
SCBOT_JINGMAIEXP = 3
--to C++ enum [SeChangeBaseOptType] Define END

--to C++ enum [SeDBRelatedSwitch] Define BEGIN
SDBRS_NONE = -1
SDBRS_SHOP_BUY = 1
SDBRS_EXCHANGE = 2
SDBRS_TASK = 3
SDBRS_ACTIVITY = 4
SDBRS_CORP = 5
SDBRS_AUCTION = 6
SDBRS_BUGLE = 7
SDBRS_TALK = 8
SDBRS_SIGN = 9
SDBRS_COMPOSE = 10
SDBRS_SPLIT = 11
SDBRS_STRENGTHEN = 12
SDBRS_ACHELPER = 13
SDBRS_AUCTION_NORMAL = 14
SDBRS_COMMON = 15                       --通用功能关闭(应对服务器关闭某功能却没在枚举里)
SDBRS_TOTAL = 16
--to C++ enum [SeDBRelatedSwitch] Define END

--to C++ enum [SeGameLogicSwitchType] Define BEGIN
SGLST_NONE = 0
SGLST_TREASUREBOOK = 1                  --百宝书整体功能
SGLST_HOODLELOTTERY = 2                 --弹珠
SGLST_PLAT_SHOP = 3                     --平台商城购买
SGLST_SMELT_SPECIAL = 4                 --熔炼返还花费的精铁和完美粉
SGLST_RELATION_BOND = 5                 --羁绊系统
SGLST_GIVEFRIEND_TREASUREBOOK = 6       --赠送好友百宝书
SGLST_TOTAL = 7
--to C++ enum [SeGameLogicSwitchType] Define END

--to C++ enum [SeGameLogicHotUpdateType] Define BEGIN
SGLUT_NONE = 0
SGLUT_SETUP = 1                         --配置
SGLUT_KICKCACHE = 2                     --踢人清缓存
SGLUT_RESET_ONLINE = 3                  --(DB宕机拉起时)重置在线状态
SGLUT_FINIALIZE = 4                     --线程Finialize
SGLUT_RELOAD_TABLE = 5                  --重新加载数据表
SGLUT_TOTAL = 6
--to C++ enum [SeGameLogicHotUpdateType] Define END

--to C++ enum [SeTencentAntiAddictionHeartBeatType] Define BEGIN
STAAHBT_NONE = 0
STAAHBT_BEGIN = 11                      --开始
STAAHBT_KEEP = 12                       --持续
STAAHBT_STOP = 13                       --结束
--to C++ enum [SeTencentAntiAddictionHeartBeatType] Define END

--to C++ enum [SeTencentReportCheatType] Define BEGIN
STRCT_CURSE = 1                         --恶意辱骂
STRCT_ADVERTISING = 2                   --垃圾广告
STRCT_ILLEGAL_NAME = 4                  --恶意昵称
STRCT_CHEAT = 8                         --使用外挂
STRCT_ILLEGAL_WORK = 16                 --工作室行为
STRCT_OTHER = 32                        --其他
--to C++ enum [SeTencentReportCheatType] Define END

--to C++ enum [SeTencentAntiAddictionInstructionType] Define BEGIN
STAAIT_NONE = 0
STAAIT_TIPS = 1                         --弹提示
STAAIT_LOGOUT = 2                       --强制下线
STAAIT_OPENURL = 3                      --打开网页
STAAIT_USER_DEFINED = 4                 --用户自定义
STAAIT_INCOME = 5                       --收益，不弹窗
STAAIT_INCOME_TIPS = 6                  --收益且弹窗
STAAIT_STOP = 7                         --停止操作
--to C++ enum [SeTencentAntiAddictionInstructionType] Define END

--to C++ enum [SeTLogNPCActType] Define BEGIN
STLNAT_NONE = 0
STLNAT_WATCH = 1                        --观察
STLNAT_INVITATION = 2                   --邀请
STLNAT_GIVEGIFT = 3                     --送礼
STLNAT_COMPARE_BATTLE = 4               --切磋战斗
STLNAT_COMPARE_GET_ITEM = 5             --切磋获得物品
STLNAT_COMPARE_GET_TITLE = 6            --切磋获得称号
STLNAT_DUEL = 7                         --决斗
STLNAT_SWORN = 8                        --结义
STLNAT_MARRIED = 9                      --誓约
STLNAT_CONSULT = 10                     --请教
STLNAT_STEAL = 11                       --偷学
STLNAT_TEAMMATE = 12                    --入队
STLNAT_LEAVE = 13                       --离队
STLNAT_BEG = 14                         --乞讨
STLNAT_PUNISH = 15                      --惩恶
STLNAT_CALLUP = 16                      --号召
STLNAT_INQUIRY = 17                     --盘查
STLNAT_EXILE = 18                       --驱逐
STLNAT_DUELALL = 19                     --灭门
STLNAT_ALLY = 20                        --结盟
STLNAT_ABSORB = 21                      --吸能
--to C++ enum [SeTLogNPCActType] Define END

--to C++ enum [SeTLogShareOtherType] Define BEGIN
STLSOT_NONE = 0
STLSOT_INVITATION = 1                   --邀请入队
STLSOT_APPRENTICE_ATTR = 2              --徒弟属性
STLSOT_JOIN_CLAN = 3                    --门派加入
STLSOT_SCRIPT_END = 4                   --通关结局
STLSOT_CHALLENGE_SUC = 5                --切磋获胜
STLSOT_SCREENSHOTS = 6                  --手动截屏
--to C++ enum [SeTLogShareOtherType] Define END

--to C++ enum [SeTLogShareToType] Define BEGIN
STLSTT_NONE = 0
STLSTT_QQ = 1                           --QQ
STLSTT_WX = 2                           --WX
STLSTT_QQ_ZONE = 3                      --QQ空间
STLSTT_WX_PYQ = 4                       --WX朋友圈
--to C++ enum [SeTLogShareToType] Define END

--to C++ enum [SeTLogEnterScriptStageType] Define BEGIN
STESST_NONE = 0
STESST_FINISH_FAQ = 1                   --完成江湖问答
STESST_CREATE_ROLE = 2                  --点击创建角色
STESST_CLICK_START = 3                  --开始游戏
STESST_ENTER_SCRIPT = 4                 --进入游戏
--to C++ enum [SeTLogEnterScriptStageType] Define END

--to C++ enum [SeTLogEquipBackUpTimingType] Define BEGIN
STEBUTT_NONE = 0
STEBUTT_RECYLE = 1                      --回收
STEBUTT_ENTER_SCRIPT = 2                --带入剧本
STEBUTT_END_SCRIPT = 3                  --带出剧本
STEBUTT_SELL = 4                        --商城售卖
STEBUTT_DECOMPOSE = 5                   --分解
STEBUTT_GET = 6                         --获得
STEBUTT_GIVE = 7                        --赠送
STEBUTT_COMPENSATION = 8                --(邮件)补偿
STEBUTT_REMAKE = 9                      --重铸
STEBUTT_ENHANCE = 10                    --强化
--to C++ enum [SeTLogEquipBackUpTimingType] Define END

--to C++ enum [SeTLogUserDefineActivityIDType] Define BEGIN
STUDAIT_NONE = 0
STUDAIT_3DAY = 1000001                  --三日签到
STUDAIT_7DAY = 1000002                  --七日签到
STUDAIT_WAITERREWARD = 1000003          --老板娘每日赠礼领取
STUDAIT_COLLECTION = 1000004            --集字活动
STUDAIT_TREASURE = 1000005              --壕侠满赠
--to C++ enum [SeTLogUserDefineActivityIDType] Define END

--to C++ enum [SeTencentPrivateInfo] Define BEGIN
STPT_QQ = 0
STPT_WECHAT = 1
--to C++ enum [SeTencentPrivateInfo] Define END

--to C++ enum [BillNoState] Define BEGIN
BNST_NULL = 0                           --无效
BNST_NEW = 1                            --创建
BNST_MFAIL = 2                          --订单米大师侧失败
BNST_MSUCESS = 3                        --订单米大师侧成功
BNST_GFAIL = 4                          --订单游戏侧fail
BNST_RFAIL = 5                          --米大师回滚失败
BNST_GDONE = 6                          --订单游戏侧success
--to C++ enum [BillNoState] Define END

--to C++ enum [SeTLogNameType] Define BEGIN
STLNT_Null = 0
STLNT_GameSvrState = 1
STLNT_PlayerRegister = 2
STLNT_PlayerLogin = 3
STLNT_PlayerLogout = 4
STLNT_MoneyFlow = 5
STLNT_ItemFlow = 6
STLNT_PlayerExpFlow = 7
STLNT_SnsFlow = 8
STLNT_RoundFlow = 9
STLNT_GuideFlow = 10
STLNT_VipLevelFlow = 11
STLNT_ActivityFlow = 12
STLNT_TaskFlow = 13
STLNT_LotteryFlow = 14
STLNT_GuildFlow = 15
STLNT_PlayerCoreAttributesFlow = 16
STLNT_PlayerEquipmentReMakeFlow = 17
STLNT_PlayerCanZhangFlow = 18
STLNT_PlayerCanWenFlow = 19
STLNT_PlayerActNPCFlow = 20
STLNT_PlayerIntoSceneFlow = 21
STLNT_PlayerMazeFlow = 22
STLNT_PlayerUnlock = 23
STLNT_PlayerTreasureBook = 24
STLNT_PlayerActPlayerFlow = 25
STLNT_PlayerPetFlow = 26
STLNT_PlayerTalkFlow = 27
STLNT_PlayerPlatShop = 28
STLNT_ScriptClanFlow = 29
STLNT_InCompleteFlow = 30
STLNT_Achievement = 31
STLNT_ScriptRegister = 32
STLNT_ScriptCompleted = 33
STLNT_CardDevelop = 34
STLNT_EquipBackUp = 35
STLNT_SceneShare = 36
STLNT_WatchADSFlow = 37
STLNT_PropertyFlow = 38
STLNT_EquipRemake = 39
STLNT_PvPFlow = 40
STLNT_LimitShopFlow = 41
STLNT_PlayerEnterCityFlow = 42
STLNT_MakeMartialSecretFlow = 43
STLNT_RoleFace = 44
STLNT_End = 45
--to C++ enum [SeTLogNameType] Define END

--to C++ enum [SePlayerCommonInfoRetType] Define BEGIN
FLAT_COMMONINFO_NULL = 0                --无效
FLAT_COMMONINFO_MERIDIANS_EXP = 1       --经脉当前总经验
FLAT_COMMONINFO_WEEK_MERIDIANS_EXP = 2  --经脉周获得经验
FLAT_COMMONINFO_WEEK_MERIDIANS_OPENLIMIT = 3--经脉周开上限次数
FLAT_COMMONINFO_RENAME_TIMES = 4        --改名次数
FLAT_COMMONINFO_BRMB = 5                --开通壕侠
FLAT_COMMONINFO_LUCKEYVALUE = 6         --幸运值
FLAT_COMMONINFO_ADVANCEPURCHASE = 7     --预约办卡
FLAT_COMMONINFO_MERIDIANS_BREAK_ITEM_NUM = 8--经脉当前剩余冲灵丹数量
FLAT_COMMONINFO_WEEK_RECYCLE_LVL = 9    --经脉周回收等级
FLAT_COMMONINFO_SAVEDB_DIRTY_STATE = 10 --玩家脏标状态
--to C++ enum [SePlayerCommonInfoRetType] Define END

--to C++ enum [SeForBidType] Define BEGIN
SFBT_NULL = 0                           --无效
SEOT_FORBIDALLCHAT = 1                  --全区全服禁言
SEOT_FORBIDCHAT = 2                     --全服禁言
SEOT_SILENTCHAT = 3                     --全服静默
SEOT_FORBIDEDITTEXT = 4                 --禁止修改文本
SEOT_FORBIDADDFRIEND = 5                --禁止加好友
SEOT_FORBIDRANK = 6                     --禁止排行榜
--to C++ enum [SeForBidType] Define END

--to C++ enum [SeScriptOprType] Define BEGIN
SEOT_NULL = 0                           --无效
SEOT_ENTER = 1                          --进入剧本
SEOT_QUIT = 2                           --退出剧本
SEOT_DEL = 3                            --删除剧本
SEOT_QUERY = 4                          --剧本信息请求
SEOT_BUYDIFF = 5                        --购买难度
SEOT_FORCEEND = 6                       --强制结束剧本周目
SEOT_QUITGAME = 7                       --退出游戏
--to C++ enum [SeScriptOprType] Define END

--to C++ enum [SePlatItemOprType] Define BEGIN
SPIO_NULL = 0                           --无效
SPIO_QUERY = 1                          --查询
SPIO_INTO_SCRIPT = 2                    --带入剧本
SPIO_OUT_SCRIPT = 3                     --带出剧本
SPIO_DEL = 4                            --删除物品
SPIO_RECYCLE = 5                        --回收物品
SPIO_USEITEM = 6                        --使用物品
--to C++ enum [SePlatItemOprType] Define END

--to C++ enum [SeScriptLuckyType] Define BEGIN
SSLT_NOLUCKY = 0                        --无幸运值
SSLT_NEWPLAYER = 1                      --新玩家默认幸运值
SSLT_NORMAL = 2                         --正常带入幸运值
--to C++ enum [SeScriptLuckyType] Define END

--to C++ enum [SeAchievementNoticeType] Define BEGIN
SANT_NULL = 0                           --无效
SANT_REFRESH = 1                        --查询类刷新
SANT_ADD = 2                            --增量更新
--to C++ enum [SeAchievementNoticeType] Define END

--to C++ enum [SeMeridiansOprType] Define BEGIN
SMOT_NULL = 0                           --无效
SMOT_REFRESH_ALL = 1                    --刷新全部数据
SMOT_REFRESH_ONE = 2                    --刷新单穴数据
SMOT_LEVEL_UP = 3                       --穴位升级
SMOT_BUY_LIMITNUM = 4                   --购买开上限
SMOT_BREAK_LIMIT = 5                    --经脉突破
--to C++ enum [SeMeridiansOprType] Define END

--to C++ enum [SeMailOprType] Define BEGIN
SMAOT_NULL = 0                          --无效
SMAOT_SEND = 1                          --发送邮件
SMAOT_SYSTEM_SEND = 2                   --发送邮件
SMAOT_GET = 3                           --获取邮件内容
SMAOT_DEL = 4                           --删除邮件
--to C++ enum [SeMailOprType] Define END

--to C++ enum [SeFriendBroadcast] Define BEGIN
SFBC_NULL = 0                           --无效
SFBC_OPENTREASURE = 1                   --给好友发送开启宝藏图消息
--to C++ enum [SeFriendBroadcast] Define END

--to C++ enum [SeClanCollectionQueryType] Define BEGIN
SCCQT_NULL = 0                          --无效
SCCQT_HEAT = 1                          --门派热度
--to C++ enum [SeClanCollectionQueryType] Define END

--to C++ enum [SeAdvancePurchaseType] Define BEGIN
SAPT_NULL = 0                           --无效
SAPT_BY_OTHER = 1                       --由别人赠送
SAPT_GIVE = 2                           --赠送别人
SAPT_GIVE_FAIL = 3                      --赠送别人失败
SAPT_GIVE_SUC_1 = 4                     --赠送别人本月百宝书成功
SAPT_GIVE_SUC_2 = 5                     --赠送别人次月百宝书成功
SAPT_QUERY_ONLINE = 6                   --查询在线
--to C++ enum [SeAdvancePurchaseType] Define END

--to C++ enum [SeTreasureBookEnableType] Define BEGIN
STBET_NULL = 0                          --无效
STBET_SELF = 1                          --自己激活
STBET_BY_OTHER = 2                      --他人赠送
STBET_System = 3                        --系统给予
STBET_GIVE = 4                          --赠送他人
--to C++ enum [SeTreasureBookEnableType] Define END

--to C++ enum [SeTreasureBookTaskType] Define BEGIN
STBTT_NULL = 0                          --无效
STBTT_NORMAL = 1                        --正常任务
STBTT_ACTIVITY = 2                      --活动类型
STBTT_ACTIVITY_BACKFLOW = 3             --活动类型-回流
STBTT_ACTIVITY_FESTIVAL_DIALY = 4       --活动类型-节日活动日常任务
--to C++ enum [SeTreasureBookTaskType] Define END

--to C++ enum [SeTreasureBookQueryType] Define BEGIN
STBQT_NULL = 0                          --无效
STBQT_BRMB = 1                          --开通壕侠
STBQT_BASE = 2                          --基础信息
STBQT_TASK = 3                          --任务信息
STBQT_MALL = 4                          --商城信息
STBQT_EXCHANGE = 5                      --兑换物品
STBQT_FREE_REWARD = 6                   --领取每日/周奖励
STBQT_LVL_REWARD = 7                    --领取等级奖励
STBQT_RECHARGE_PROGRESS = 8             --请求全服充值进度
STBQT_PROGRESS_REWARD = 9               --领取全服充值进度奖励
STBQT_ADVANCE_PURCHASE = 10             --月末预购
STBQT_BUY_EXP = 11                      --购买百宝书经验
STBQT_LVL_CAN_REWARD = 12               --领取可领的等级奖励
STBQT_CLICK_REQUEST = 13                --点击刷新
STBQT_NUM = 14
--to C++ enum [SeTreasureBookQueryType] Define END

--to C++ enum [SeHoodleLotteryPoolType] Define BEGIN
SHLPLT_NULL = 0                         --无效
SHLPLT_NORMAL = 1                       --普通池信息
SHLPLT_HOLIDAY = 2                      --节日池信息
SHLPLT_ROTATION = 3                     --轮换池信息
SHLPLT_WELFARE1 = 4                     --新手福利池1信息,非显示类池
SHLPLT_WELFARE2 = 5                     --新手福利池2信息,非显示类池
SHLPLT_WELFARE3 = 6                     --新手福利池3信息,非显示类池
SHLPLT_PRIVACY = 7                      --个人奖池
SHLPLT_NUM = 8
--to C++ enum [SeHoodleLotteryPoolType] Define END

--to C++ enum [SeHoodleLotteryQueryType] Define BEGIN
SHLQT_NULL = 0                          --无效
SHLQT_BASE = 1                          --基础信息
SHLQT_START_LOTTERY = 2                 --开始弹下
SHLQT_OPEN_INFO = 3                     --奖池开放情况
SHLQT_TEN_LOTTERY = 4                   --一次弹十个
SHLQT_PRIVACY_INFO = 5                  --个人奖池信息
SHLQT_NUM = 6
--to C++ enum [SeHoodleLotteryQueryType] Define END

--to C++ enum [SeHoodleBoxProgressType] Define BEGIN
SHBPT_NULL = 0                          --无效
SHBPT_LEFT = 1                          --左1柱
SHBPT_RIGHT = 2                         --右1柱
SHBPT_MID = 3                           --中1柱
SHBPT_NUM = 4
--to C++ enum [SeHoodleBoxProgressType] Define END

--to C++ enum [SeHoodleBallType] Define BEGIN
SHBT_NULL = 0                           --无效
SHBT_NORMAL = 1                         --普通球
SHBT_SPECIAL = 2                        --阿月池特殊十连球
SHBT_DAILYFREE = 3                      --阿月池每日免费球
SHBT_FORTENSHOOT = 4                    --累计十连球
SHBT_NUM = 5
--to C++ enum [SeHoodleBallType] Define END

--to C++ enum [SeHoodlePrivacyChivalrousType] Define BEGIN
SHPCT_NULL = 0                          --无效
SHPCT_NORMAL = 1                        --白衣池:白衣精英
SHPCT_CHIVALROUS_1 = 2
SHPCT_CHIVALROUS_2 = 3
SHPCT_CHIVALROUS_3 = 4
SHPCT_CHIVALROUS_4 = 5
SHPCT_CHIVALROUS_5 = 6
SHPCT_CHIVALROUS_6 = 7
SHPCT_NUM = 8
--to C++ enum [SeHoodlePrivacyChivalrousType] Define END

--to C++ enum [SeManagerType] Define BEGIN
SMT_INSTROLE = 0
SMT_NPCROLE = 1
SMT_ITEM = 2
SMT_MARTIAL = 3
SMT_SHOP = 4
SMT_TASK = 5
SMT_MAP = 6
SMT_GIFT = 7
SMT_CITY = 8
SMT_PLOT = 9
--to C++ enum [SeManagerType] Define END

--to C++ enum [SeRegisterRet] Define BEGIN
SRR_SUCCESS = 0
SRR_REPEAT = 1
SRR_VERSION = 2
SRR_FAILED = 3
--to C++ enum [SeRegisterRet] Define END

--to C++ enum [SeNoticeCode] Define BEGIN
SNC_UNKNOW = 0                          --未知
SNC_CHAR_NAME_INVALID = 1               --角色名字含有非法字符
SNC_SKIN_UNLOCK_SUC = 2                 --皮肤解锁成功
SNC_RENAME_FAIL = 3                     --改名失败
SNC_ACCOUNT_WILL_LOGIN = 4              --帐号在即将被登录
SNC_ACTION_SWITCH_OFF = 5               --需要数据库的功能开关被关了, 对应参数枚举值SeDBRelatedSwitch
SNC_CHANGE_NATIONALITY_FAIL = 6         --改变国籍失败
SNC_USE_BAG_ITEM_SUCCESS = 7            --背包道具使用成功
SNC_USE_BAG_ITEM_FAILED = 8             --背包道具使用失败
SNC_SELL_BAG_ITEM_SUCCESS = 9           --背包道具出售成功
SNC_SELL_BAG_ITEM_FAILED = 10           --背包道具出售失败
SNC_BAG_ITEM_NEED_LEVEL = 11            --道具需要等级才能使用
SNC_SERVER_ERROR = 12                   --机房出现故障
SNC_GAMEFUC_OFF = 13                    --功能屏蔽
SNC_QUERY_OFFLINE_PLAYER = 14           --离线玩家无法查询
SNC_QUERY_TOO_FREQUENTLY = 15           --查询过于频繁
SNC_USE_ITEM_MANUAL_FULL = 16           --使用道具失败体力满了
SNC_CHAR_CHARGED_MONEY = 17             --玩家累计充值
SNC_CHAR_NAME_OVER_LEN = 18             --名字超出允许长度
SNC_PLAT_PLAYER_OFFLINE = 19            --该玩家已经下线
SNC_RENAME_USE_SPECIAL_SYMBOL = 20      --起名使用了特殊字符
SNC_RENAME_USE_GOLDOPRFREQUENT = 21     --操作太频繁
SNC_PITOSDILATATION = 22                --扩容成功
SNC_PITOSDILATATION_LIMIT = 23          --可扩容的格子已达上限
SNC_SHOPREWARDEXCEPT = 24               --商店打赏失败
SNC_SHOPGOLDREWARDSUCCESS = 25          --商店金锭打赏成功
SNC_SHOPADREWARDSUCCESS = 26            --商店广告打赏成功
SNC_OPENTREASURE_FRIENDGIFT = 30        --分享藏宝图开启给好友奖励
SNC_LIMITBUY_BAG_NOT_ENOUGH = 31        --背包格子不足
SNC_COMMON = 100                        --通用通知（直接读取字符串参数）
SNC_COMMON_SUC = 101                    --成功提示
SNC_NOT_ENOUGH_GOLD = 102               --金锭不足
SNC_NOT_ENOUGH_SILVER = 103             --银锭不足
SNC_NOT_ENOUGH_HOODLESCORE = 104        --头巾不足
SNC_HOODLEBUY_SUCCESS = 105             --头巾兑换物品成功
SNC_HOODLEBUY_NOMATCH = 106             --头巾兑换物品不匹配
SNC_SUC_SEND_REDPACKET = 110            --红包发送成功
SNC_NOT_SEND_REDPACKET = 111            --红包发送失败
SNC_SUC_GETREDPACKET = 112              --红包领取成功
SNC_NOT_EXIST_REDPACKET = 113           --红包不存在
SNC_HADGET_REDPACKET = 114              --红包已领取
SNC_NOT_ENOUGH_REDPACKET = 115          --红包已被领取完
SNC_OVERTIME_REDPACKET = 116            --红包已过期
SNC_NODATA_REDPACKET = 117              --红包数据错误
SNC_FORBIDTEXT_REDPACKET = 118          --口令包含非法字符
SNC_NOITEM_REDPACKET = 119              --红包道具不足
SNC_GETTIMESMAX_REDPACKET = 120         --当天红包领取数已达上限
SNC_LIMITSHOP_FINFIRSTSHARE = 130       --首次分享完成
SNC_LIMITSHOP_ADDFIRSTSHARE = 131       --添加分享成功
SNC_LIMITSHOP_ADDDISCOUNT = 132         --优惠券添加成功
SNC_LIMITSHOP_NOENOUGHBIGCOIN = 133     --包子币不足
SNC_LIMITSHOP_NOENOUGHYAZHUTIMES = 134  --押注次数已用完
SNC_LIMITSHOP_BUYBIGCOINSUCCESS = 135   --购买包子币成功
SNC_LIMITSHOP_YAZHUSUCCESS = 136        --押注成功
SNC_LIMITSHOP_ADDDISCOUNTLIMIT = 137    --优惠券数量已达上限
SNC_LIMITSHOP_GETYAZHUINROFIRST = 138   --请首先获取押注信息
SNC_LIMITSHOP_YAZHUGAMEOVER = 139       --押注已完成
SNC_LIMITSHOP_BUYSECCESS = 140          --购买成功
SNC_LIMITSHOP_COUPONNOTFOUND = 141      --优惠券不存在
SNC_LIMITSHOP_COUPONEXPIRED = 142       --优惠券已过期
SNC_LIMITSHOP_GIFTSOLD = 143            --礼包售完了
SNC_TASK_COMPLETE = 350                 -- 任务达成 参数表示对应的任务ID
SNC_TASK_RESET_FAIL = 351               -- 重置任务失败
SNC_TASK_AWARD_GET = 352                -- 已经领取任务奖励
SNC_TASK_TIME_UP = 357                  --任务超时了
SNC_DEL_TASK_EXCHANGE = 358             --删除兑换任务
SNC_FAILED_TASK_EXCHANGE = 359          --道具兑换失败
SNC_MAPTASK_AWARD_GET = 360             -- 已经领取地图任务奖励
SNC_RACE_WEEK_GOLD_LIMIT = 361          -- 结算金币达到周上限
SNC_ONLINEBOX_UNLOCK_FAIL = 365         --在线宝箱解锁失败
SNC_ONLINEBOX_OPEN_FAIL = 366           --在线宝箱开启失败
SNC_NEW_FOLLOWER_NOTIFY = 380           --有新的粉丝
SNC_FRIEND_UNFOLLOW = 381               --被粉丝取消关注
SNC_FRIEND_ADD_FAIL_MAXIMUM = 382       --添加好友失败-达到最大上限
SNC_FRIEND_ADD_OFFLINE = 383            --添加好友失败-离线且最近未上线过的玩家
SNC_IN_DIFF_TOWN = 384                  --不在同城镇
SNC_FIND_PLAYER_OFFLINE = 385           --查找玩家离线
SNC_START_DUEL_FAIL_RET = 386           --开始比武失败返回值，param表示理由：1被挑战玩家排名比自己低2：自己非空闲，3敌人非空闲,4被挑战玩家不再榜上5挑战功能冷却中，稍后再试6排名变化
SNC_DUEL_CLOSE = 387                    --比武关闭通知，一旦比武出问题可以及时关掉
SNC_FORBIDADDFRIEND = 388               --被禁止添加好友
SNC_SHOP_SUCCESS = 500                  --交易成功
SNC_SHOP_UNKNOWN_ERROR = 501            --未知错误
SNC_SHOP_ITEM_NOT_EXIST = 502           --商品不存在
SNC_SHOP_NOT_ENOUGH_MONEY = 503         --钱不够
SNC_SHOP_MAX_BUY_NUM = 504              --超过最大数
SNC_SHOP_NOT_ENOUGH_FAVORABILITY = 505  --善恶度不够
SNC_SHOP_SELL_NOT_ENOUGH_NUM = 506      --卖出没有足够的数量
SNC_SHOP_RESERVE = 599                  --保留
SNC_ARENA_NOT_IN_SIGNUP_TIME = 600      --不在报名时间
SNC_ARENA_UPDATE_PKDATA_SUCCESS = 601   --更新PK数据成功
SNC_ARENA_HAS_BET = 602                 --重复押注
SNC_ARENA_BET_FAILED = 603              --押注失败
SNC_ARENA_SIGNUP_FAILED = 604           --报名失败
SNC_ARENA_NEED_CHAMPION_TIEMS_1 = 605   --报名失败,需要冠军次数
SNC_ARENA_NEED_CHAMPION_TIEMS_2 = 606   --报名失败,需要冠军次数
SNC_APPEAR_MODIFY_SUC = 700             --修改成功
SNC_APPEAR_MODIFY_PARAM_FAIL = 701      --参数错误
SNC_APPEAR_MODIFY_NOT_HAVE = 702        --未拥有
SNC_APPEAR_MODIFY_SAME_NAME = 703       --重名
SNC_APPEAR_MODIFY_NAME_FREQUENTLY = 704 --平台起名过于频繁
SNC_TSS_NOT_VALID = 800                 --存在屏蔽字
SNC_PUBLIC_CHAT_FREQUENCY_TOO_HIGH = 900--聊天频率太高
SNC_PUBLIC_CHAT_CHANNEL_INVALID = 901   --聊天频道不对
SNC_FORBIDDEN_CHAT = 902                --您已被禁言
SNC_FORBIDDEN_SILENTCHAT = 903          --您已被静默
SNC_BECOME_RMB_PLAYER = 950             --开通百宝书
SNC_TREASURE_ADVANCE_PURCHASE_SUC = 951 --续约月卡成功
SNC_TREASURE_ADVANCE_PURCHASE_FAIL = 952--续约月卡失败
SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_SUC = 953--好友续约月卡成功
SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_FAIL = 954--好友已被续约月卡
SNC_TREASURE_BUT_EXP_SUC = 955          --购买经验成功
SNC_TREASURE_DAILY_SILVER_SUC = 956     --每日银锭领取成功
SNC_TREASURE_DAILY_SILVER_FAIL = 957    --每日银锭领取失败
SNC_TREASURE_WEEK_SILVER_SUC = 958      --每周银锭领取成功
SNC_TREASURE_WEEK_SILVER_FAIL = 959     --每周银锭领取失败
SNC_TREASURE_TASK_PROGRESS_UPDATE = 960 --任务进度更新
SNC_BECOME_RMB_PLAYER_FAIL = 961        --开通百宝书失败
SNC_UNLOCK_NEW_EXTRA_HERO_TASK = 962    --解锁了新的英雄任务槽
SNC_UNLOCK_NEW_EXTRA_RMB_TASK = 963     --解锁了新的壕侠任务槽
SNC_UNLOCK_NEW_REPEAT_TASK = 964        --解锁了新的重复任务
SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_LIMIT = 965--超过了本月可续约月卡的好友数量
SNC_TREASURE_CUR_EXP = 966              --同步当前百宝书经验
SNC_TREASURE_EXTRA_GETREWARD_LVL = 967  --当前百宝书额外领取到的等级
SNC_TREASURE_FRIEND_RMB_NUM = 968       --好友中壕侠数量
SNC_HOODLE_NUM_NOT_ENOUGH = 970         --弹珠数量不足
SNC_HOODLE_PUBLIC_NOT_READY = 971       --全服侠客行功能故障
SNC_HOODLE_PRIVACY_NOT_OPEN = 972       --侠客行个人奖池未开放
SNC_HOODLE_MOJUN_SURVIVAL_NOT_RESET = 973--魔君尚在，侠客行个人奖池重置失败
SNC_HOODLE_NOT_SAME_POOL_ID = 974       --奖池ID不一致，奖池信息同步出错
SNC_MERIDIANS_EXP_CHANGE = 990          --经脉经验改变
SNC_MERIDIANS_BREAK_ITEM_NOT_ENOUGH = 991--冲灵丹不足
SNC_MAX_DAILY_MERIDIANS_EXP = 992       --今日已达到最大可获得经脉经验上限
SNC_CHALLENGE_ORDER_UNLOCK = 1000       --挑战令解锁成功
SNC_DAY3SIGNIN_BUY_HORSE = 1003         --买马成功
SNC_DAY3SIGNIN_JOIN_TEAM = 1004         --入队成功
SNC_UNLOCK_INFO = 1050                  --解锁通知
SNC_UNLOCK_ADD_INCOMPLETETEXT = 1051    --解锁武学增加残文值
SNC_UNLOCK_STORY = 1052                 --解锁剧本通知
SNC_SHOW_PET = 1060                     --成功设置展示宠物
SNC_UNLOCK_PET = 1061                   --成功解锁宠物
SNC_CLEAR_ROLE_CARD = 1062              --多余角色卡已转换成资源值
SNC_CLEAR_PET_CARD = 1063               --多余宠物卡已转换成资源值
SNC_GOLD_OP_EXCEPT = 1100               --操作异常,稍后重试
SNC_PLAT_EMBATTLE_NO_EFFECT = 1110      --平台布阵无效
SNC_TENCENT_CREDIT_SCORE_SCENE_LIMIT = 1120--信用分不足
SNC_OperatorSignInFlagRet = 1130        --7日签到操作返回 根据参数类型解析
SNC_PlatChallengeCD = 1131              --平台切磋cd冷却中
SNC_PlatChallengeTargetOffline = 1132   --平台切磋被切磋玩家已离线
SNC_OTHER_BUILDING_UPGRADE = 1200       --其他建筑正在升级中
SNC_BUILDING_MAX_LEVEL = 1201           --已经升到最高级了
SNC_NOT_ENOUGH_MATERIAL = 1202          --升级材料不足
SNC_BUILDING_PUT_INVALID = 1203         --放置建筑非法
SNC_NOT_ENOUGH_HALL_LEVEL = 1204        --大厅等级不够
SNC_NO_MATERIAL_GET = 1205              --当前没有材料可以收取
SNC_DISCIPLE_NOT_IN_ROOM = 1206         --该弟子不在弟子房
SNC_DISCIPLE_IN_OTHER_BUILDING = 1207   --该弟子在其他建筑上
SNC_DISCIPLE_ROOM_INVALID = 1208        --弟子房未解锁或者未上阵
SNC_DISCIPLE_ROOM_FULL = 1209           --弟子房该床铺已满
SNC_DISCIPLE_LIMIT = 1210               --弟子数已达上限
SNC_BUILDING_NAME_INVALID = 1211        --名称有屏蔽字
SNC_BUILDING_NAME_OVER_LIMIT = 1212     --名称长度超限
SNC_ACTIVITY_RECEIVE_FAILED = 1300      --活动领取失败
SNC_ACTIVITY_FUND_SUCCESS = 1301        --活动基金开通成功
SNC_ACTIVITY_FUND_FAIL = 1302           --活动基金开通失败
SNC_ACTIVITY_FUND_GETFAIL = 1303        --领取失败,条件不足
SNC_ACTIVITY_FESTIVAL_SIGN_IN_RES = 1304--节日活动活跃度奖励领取结果
SNC_ACTIVITY_FESTIVAL_LIVENESS_ACHIEVE_RES = 1305--节日活动活跃度奖励领取结果
SNC_ACTIVITY_FESTIVAL_EXCHANGE_RES = 1306--节日活动兑换结果
SNC_ACTIVITY_FESTIVAL_EXCHANGE_ASSET_CLEAN_RES = 1307--节日活动资产值清空结果
SNC_ACTIVITY_FESTIVAL_BUYMALL_RES = 1308--节日活动商品购买结果
SNC_TREASURE_EXCHANGE_REFREASH = 1310   --秘宝刷新成功
SNC_TREASURE_EXCHANGE_REFREASH_FAILED = 1311--秘宝刷新失败
SNC_TREASURE_EXCHANGE_BUY_FAILED = 1312 --秘宝兑换失败
SNC_TREASURE_EXCHANGE_BUY = 1313        --秘宝兑换成功
SNC_SCRIPT_ENTER_LIMIT = 1500           --剧本进度等待限制
SNC_FREE_CHALLENGE_UNLOCK_FAILD = 1501  --免费完整版解锁失败
SNC_ILLEGAL_ENTER_STORY_DIFFICULT = 1502--进入剧本难度异常，需要自动剧本结算
SNC_SYS_RED_PACKET_HUASHAN = 1600       --华山论剑第一系统红包
SNC_SYSTEM_MODULE_DISABLE = 1700        --系统模块维护中提示
SNC_ANTI_ADDITION = 1800                --防沉迷
SNC_WEGAME_EXIT = 1801                  --wegame退出
--to C++ enum [SeNoticeCode] Define END

--to C++ enum [SeLoginReason] Define BEGIN
LFR_SUCCESS = 0                         --登陆成功
LFR_UNKONW_REASON = 1                   --未解析错误
LFR_DB_ERROR = 2                        --查询数据库错误
LFR_ACCOUNT_ERROR = 3                   --帐号或者密码错误
LFR_ACCOUNT_VERITYFY = 4                --客户端验证错误
LFR_SERVER_DISCONNECT = 5               --服务器未连接
LFR_SERVER_BUSY = 6                     --服务器繁忙
LFR_SESSION_ERROR = 7                   --会话ID错误
LFR_OTHER_LOGGED = 8                    --已在其它地方登录(测试用)
LFR_INVALID_PLAT = 9                    --非法的登录平台标识
LFR_WS_DB_ERROR = 10                    --WorldServer存在数据库错误
LFR_VERSION_ERROR = 11                  --客户端版本号错误
LFR_HAS_LOCKED = 12                     --账号已被封 ,此错误时：第一个参数返回封号原因，第二个参数返回剩余封禁时间：xx秒
LFR_SERVER_MAINTAIN = 13                --服务器维护中
LFR_SERVER_FULL = 14                    --服务器在线量达到上限
LFR_TOKEN_ERROR = 15                    --登陆token错误
LFR_COUNTRY_ERROR = 16                  --国家错误
LFR_SLAVE_SERVER_CANNOT_FIND_DATA = 17  --从服务器无法验证数据
--to C++ enum [SeLoginReason] Define END

--to C++ enum [SeLoginPlatType] Define BEGIN
SLPT_None = 0                           --未登陆
SLPT_Weixin = 1                         --微信登陆
SLPT_QQ = 2                             --QQ登陆
SLPT_WTLogin = 3                        --WT登陆
SLPT_QQHall = 4                         --手Q大厅登陆
SLPT_Guest = 5                          --游客登陆
SLPT_Auto = 6                           --上次登陆
SLPT_PC = 7                             --PC登陆
--to C++ enum [SeLoginPlatType] Define END

--to C++ enum [SePublicLoginChannelType] Define BEGIN
SPLCT_None = 0                          --未知
SPLCT_UserPwd = 1                       --用户密码
SPLCT_WX = 2                            --微信
SPLCT_QQ = 3                            --QQ登陆
SPLCT_TENCENT = 4                       --腾讯登录，新版统一渠道
SPLCT_Max = 4                           --最大ID登录
--to C++ enum [SePublicLoginChannelType] Define END

--to C++ enum [SePublicLoginResult] Define BEGIN
SPLR_OK = 0                             --登录成功
SPLR_Unavailable = 1001                 --服务不可用
SPLR_NotExists = 1002                   --账户不存在
SPLR_TokenWrong = 1003                  --口令错误
SPLR_QueueRequire = 1004                --需要排队
SPLR_Freezing = 1005                    --账户被冻结
SPLR_WhiteListOnly = 1006               --仅允许白名单登录
SPLR_Forbidden = 1007                   --拒绝登陆(渠道关闭)
SPLR_ShutDown = 1008                    --停机维护
SPLR_Blocked = 1009                     --策略阻止(IP,时间段等限制)
SPLR_ZoneLimit = 1010                   --大区登录错误
SPLR_FirstServerLimit = 1011            --服务器限制创角
--to C++ enum [SePublicLoginResult] Define END

--to C++ enum [SeTencentWordFilterType] Define BEGIN
STWFT_NULL = 0                          --无效位
STWFT_TALK = 1                          --聊天
STWFT_PLAT_RENAME = 2                   --平台改名
STWFT_SCRIPT_RENAME = 3                 --剧本改名
STWFT_REDPACKET_WORD = 4                --红包口令
STWFT_SECT_BUILDING_RENAME = 5          --门派建筑改名
STWFT_END = 6
--to C++ enum [SeTencentWordFilterType] Define END

--to C++ enum [SePublicChatChannelType] Define BEGIN
SPCCT_NULL = 0                          --无效位
SPCCT_WORLD = 1                         --世界
SPCCT_SCRIPT = 2                        --剧本
SPCCT_HOUSE = 3                         --酒馆
SPCCT_PRIVATE = 4                       --私聊
--to C++ enum [SePublicChatChannelType] Define END

--to C++ enum [SeTLogMoneyType] Define BEGIN
STLMT_INVALID = 0                       --无效位
STLMT_COIN = 1                          --铜币
STLMT_SILVER = 2                        --银锭
STLMT_GOLD = 3                          --金锭
STLMT_TREASURE = 4                      --百宝书残页
STLMT_DRINK = 5                         --酒券
STLMT_PLATFORMSCORE = 6                 --平台积分
STLMT_ACTIVEFORMSCORE = 7               --活动积分
STLMT_SECONDGOLD = 8                    --大金锭
STLMT_HOODLESCORE = 9                   --夺宝积分
STLMT_ZMGOLD = 10                       --掌门币
--to C++ enum [SeTLogMoneyType] Define END

--to C++ enum [SeTLogProperType] Define BEGIN
STLPT_INVALID = 0                       --无效位
STLPT_FORGET = 1                        --忘忧草
STLPT_IRON = 2                          --精铁
STLPT_PERFECT = 3                       --完美粉
STLPT_MERIDIANS_BREAK = 4               --冲灵丹
STLPT_MERIDIANS_EXP = 5                 --经脉经验
STLPT_LUCKY_BALL = 6                    --幸运珠
STLPT_HOODLE_BALL = 7                   --小侠客
STLPT_FESTIVAL_VALUE1 = 8               --节日活动资产值1(节日活动通用资产值, 在冬雪节中, 表示雪球)
STLPT_FESTIVAL_VALUE2 = 9               --节日活动资产值2(节日活动通用资产值, 在冬雪节中, 表示冬雪好感度)
STLPT_HEAVEN_HAMMER = 10                --天工锤
STLPT_TONGLINGYU = 11                   --通灵玉
--to C++ enum [SeTLogProperType] Define END

--to C++ enum [RecordLogFlowReason] Define BEGIN
RLFR_NULL = 0
RLFR_System = 1
RLFR_System_GM = 2
RLFR_System_Mail = 3
RLFR_Recharge = 100                     --充值
RLFR_Recharge_Midas = 101               --米大师
RLFR_FinishScript = 200                 --完成周目
RLFR_FinishScript_Reward = 201          --剧本奖励
RLFR_FinishScript_Item = 202            --周目获得物品
RLFR_Talk = 300
RLFR_Talk_Small = 301                   --闲聊
RLFR_Talk_World = 302                   --世界聊天
RLFR_Talk_World_Back = 303              --付费聊天场景中因屏蔽字原因等异步扣款退回
RLFR_Drop = 400                         --掉落
RLFR_Drop_Treasure = 401                --宝箱
RLFR_Drop_Little_Monster = 402          --小怪
RLFR_Drop_Elite_Monster = 403
RLFR_Drop_Boss_Monster = 404            --BOSS
RLFR_Drop_Maze = 405                    --迷宫掉落,捡垃圾
RLFR_Drop_City = 406                    --城市掉落,捡垃圾
RLFR_Drop_Adventure = 407               --冒险收集
RLFR_Drop_HoodleLottery = 408           --弹珠获得
RLFR_Drop_Map = 409                     --地图获得
RLFR_Drop_Role = 410                    --角色身上物品
RLFR_Task = 500                         --任务
RLFR_Task_Entrust = 501                 --委托
RLFR_Task_Award = 502                   --奖励
RLFR_Shop = 600                         --商店
RLFR_Shop_Normal = 601                  --普通商店
RLFR_Shop_Mystery = 602                 --神秘商店
RLFR_Shop_Plat = 603                    --平台商城
RLFR_Shop_Limit = 604                   --限时商店
RLFR_Shop_LimitRecharge = 605           --限时商店充值
RLFR_Shop_YaZhu = 606                   --赌博
RLFR_Shop_Reward = 607                  --商城打赏
RLFR_Shop_Zm = 608                      --掌门商店
RLFR_Shop_RepeatFormula = 609           --重复配方获得
RLFR_Refresh = 800                      --刷新
RLFR_Refresh_Wish = 801                 --刷新心愿
RLFR_Refresh_Talent = 802               --刷新天赋
RLFR_Refresh_Begging = 803              --刷新乞讨
RLFR_Refresh_Challenge = 804            --刷新切磋
RLFR_Refresh_Consult = 805              --刷新请教
RLFR_Refresh_CallUp = 806               --刷新号召
RLFR_Refresh_Punish = 807               --刷新惩恶
RLFR_Refresh_Inquiry = 808              --刷新盘查
RLFR_Refresh_Duel = 809                 --刷新决斗
RLFR_Refresh_Steal = 810                --刷新偷学
RLFR_Refresh_ReCast = 811               --刷新重铸
RLFR_Refresh_Strengthen = 812           --刷新强化
RLFR_Refresh_Smelt = 813                --刷新熔炼
RLFR_NPCAct = 1000                      --NPC互动
RLFR_NPCAct_Begging = 1001              --乞讨
RLFR_NPCAct_Challenge = 1002            --切磋
RLFR_NPCAct_Duel = 1003                 --决斗
RLFR_NPCAct_Gift = 1004                 --送礼
RLFR_NPCAct_EnterClan = 1005            --进入门派
RLFR_NPCAct_Punish = 1006               --惩恶
RLFR_Meridians = 1100                   --经脉
RLFR_Meridians_ExpLimit = 1101          --周经脉经验上限重置
RLFR_Meridians_ExpBuyItem = 1102        --周增加购买经验丹次数
RLFR_Meridians_Break = 1103             --冲灵丹消耗
RLFR_Meridians_Cheat = 1104             --作弊指令
RLFR_Meridians_RedPacket = 1105         --红包
RLFR_Meridians_Item = 1106              --使用道具
RLFR_Meridians_Hoodle = 1107            --弹珠赠送
RLFR_Meridians_ScriptOver = 1108        --周目结束
RLFR_Meridians_LvlUp = 1109             --经脉升级
RLFR_Meridians_ActivityResExchange = 1110--活动资源转换
RLFR_Unlock = 1200                      --解锁
RLFR_Unlock_Role = 1201                 --解锁角色
RLFR_Unlock_Difficulty = 1202           --解锁难度
RLFR_Unlock_Skin = 1203                 --解锁皮肤
RLFR_Unlock_Story = 1204                --解锁剧本
RLFR_Unlock_LoginWord = 1205            --解锁登录词
RLFR_Unlock_Repeat = 1206               --重复解锁
RLFR_Unlock_RoleFace = 1207             --解锁捏脸部位
RLFR_Unlock_RoleFaceModel = 1208        --解锁捏脸模型
RLFR_Equipment = 1300                   --装备
RLFR_Equipment_Make = 1301              --装备制造
RLFR_Equipment_Remake = 1302            --重铸
RLFR_Equipment_LvlUp = 1303             --升级
RLFR_Equipment_Smelting = 1304          --熔炼
RLFR_Equipment_Repair_Crack = 1305      --修复裂痕
RLFR_Lottery = 1400                     --小侠客
RLFR_Lottery_Once = 1401
RLFR_Lottery_Ten = 1402
RLFR_Lottery_PublicReward = 1403        --全服小侠客奖励
RLFR_Lottery_KillScore = 1404           --小侠客击杀恶霸积分
RLFR_Lottery_BuyItem = 1405             --恶霸积分兑换物品
RLFR_Lottery_Daily = 1406               --每日侠客
RLFR_Lottery_BuyTen = 1407              --抽奖界面银锭购买十连
RLFR_Lottery_BuyOnce = 1408             --抽奖界面银锭购买单抽
RLFR_UseItem = 1600                     --使用物品
RLFR_UseItem_RunShop = 1601
RLFR_UseItem_Sell = 1602
RLFR_UseItem_PiecesOFSilver = 1603      --使用银锭
RLFR_UseItem_AUTO = 1604                --自动使用物品
RLFR_UseItem_CHOOSEGIFT = 1605          --礼包
RLFR_UseItem_PlatUse = 1606             --酒馆仓库中使用
RLFR_UseItem_ForgetMartial = 1607       --忘忧草
RLFR_UseItem_MakeSecretCostSilver = 1608--武学空白书
RLFR_UseItem_AddIncompleteBook = 1609   --增加残章
RLFR_UseItem_AddGift = 1610             --使用天书
RLFR_UseItem_EatFood = 1611             --使用菜肴
RLFR_UseItem_OpenTask = 1612            --开启任务
RLFR_UseItem_Drop = 1613                --执行掉落方案
RLFR_UseItem_GameProperties = 1614      --增加属性
RLFR_UseItem_MazeRestore = 1615         --迷宫(生命)恢复
RLFR_UseItem_AddBuff = 1616             --迷宫添加Buff
RLFR_UseItem_UnlockRecipe = 1617        --解锁配方
RLFR_UseItem_TreasureMap = 1618         --藏宝图
RLFR_UseItem_Behavior = 1619            --执行行为
RLFR_UseItem_Disguise = 1620            --易容面具
RLFR_UseItem_BoboTicket = 1621          --波波运票
RLFR_UseItem_DanYao = 1622              --丹药
RLFR_UseItem_Lottery = 1623             --彩票抽奖
RLFR_UseItem_GetBaby = 1624             --使用收徒令
RLFR_UseItem_RoleCard = 1625            --角色卡
RLFR_UseItem_PetCard = 1626             --宠物卡
RLFR_UseItem_BingHuoCanShi = 1627       --冰火蚕尸毒
RLFR_UseItem_CallHelper = 1628          --帮手效果
RLFR_UseItem_Equip = 1629               --装备消耗
RLFR_UseItem_RenameCard = 1630          --赠送改名卡
RLFR_UseItem_CuiLian = 1631             --(赤刀)淬炼
RLFR_UseItem_ADVGIFT = 1632             --冒险天赋
RLFR_UseItem_CarryIn = 1633             --带入剧本
RLFR_UseItem_MoveSerectBook = 1634      --转移秘籍(给队友等)
RLFR_UseItem_NPCRandomItem = 1635       --随机NPC物品
RLFR_UseItem_SubmitItem = 1636          --提交物品给NPC
RLFR_UseItem_NormalHighTower = 1637     --正常千层塔获得
RLFR_UseItem_BloodHighTower = 1638      --血斗千层塔获得
RLFR_UseItem_RegimentHighTower = 1639   --混战千层塔获得
RLFR_UseItem_AddClanDisposition = 1640  --修改门派好感
RLFR_UseItem_Click = 1641               --主动点击使用
RLFR_UseItem_AbsorbDrop = 1642          --吸能掉落物
RLFR_Evolution = 1700                   --演化
RLFR_Recycling = 1800                   --回收
RLFR_Recycling_RoleCard = 1801          --角色卡回收
RLFR_Recycling_PetCard = 1802           --宠物卡回收
RLFR_Recycling_PlatItem = 1803          --平台物品回收
RLFR_Plot = 1900                        --剧情
RLFR_Exchange = 2000                    --兑换
RLFR_Exchange_Silver = 2001             --兑换银锭
RLFR_Exchange_Add_BagCapacity = 2002    --扩充背包容量
RLFR_Exchange_LuckyValue = 2003         --幸运值兑换
RLFR_Exchange_Dilatation = 2004         --仓库带入剧本扩容
RLFR_TreasureBook = 2100                --百宝书
RLFR_TreasureBook_FreeDay = 2101        --每日领取
RLFR_TreasureBook_FreeDWeek = 2102      --每周领取
RLFR_TreasureBook_LvlReward = 2103      --等级奖励
RLFR_TreasureBook_BRMB = 2104           --开通壕侠
RLFR_TreasureBook_AdvancePurchase = 2105--预购月卡
RLFR_TreasureBook_BuyExp = 2106         --购买经验
RLFR_TreasureBook_Mall = 2107           --商城兑换
RLFR_TreasureBook_GlobalReward = 2108   --全服奖励
RLFR_TreasureBook_ClearCoupon = 2109    --月末清除优惠券
RLFR_TreasureBook_GiveOther = 2110      --赠送壕侠
RLFR_Mail = 2200                        --邮件
RLFR_Mail_AddGold = 2201                --增加金锭(邮件领取)
RLFR_Mail_Item = 2202                   --邮件物品
RLFR_Mail_FriendTreasureBook = 2203     --好友月卡
RLFR_Achieve = 2300                     --成就
RLFR_Achieve_Receive = 2301             --领取成就奖励
RLFR_Temple = 2400                      --寺庙
RLFR_Temple_Pray = 2401                 --上香
RLFR_Temple_Forgive = 2402              --解怨
RLFR_Arean = 2500                       --擂台赛
RLFR_Arean_Bet = 2501                   --擂台赛押注
RLFR_Zm = 2550                          --掌门对决
RLFR_Zm_Match = 2551                    --掌门对决门票
RLFR_Discount = 2600                    --优惠
RLFR_Discount_Coupon = 2601             --折扣券
RLFR_Appearance = 2700                  --形象
RLFR_Appearance_ReName = 2701           --改名
RLFR_ChallengeOrder = 2800              --挑战令
RLFR_ChallengeOrder_Mid = 2801          --挑战令中级
RLFR_ChallengeOrder_High = 2802         --挑战令高级
RLFR_LearnSkill = 3000                  --学习技能
RLFR_LearnSkill_Begging = 3001          --学习乞讨
RLFR_LearnSkill_Duel = 3002             --学习决斗
RLFR_LearnSkill_Recast = 3003           --学习重铸
RLFR_LearnSkill_Strengthen = 3004       --学习强化
RLFR_LearnSkill_Smelt = 3005            --学习精炼
RLFR_LearnSkill_QingJiao = 3006         --学习请教
RLFR_LearnSkill_TouXue = 3007           --学习偷学
RLFR_LearnSkill_QieCuo = 3008           --学习切磋
RLFR_LearnSkill_CallUp = 3009           --学习号召
RLFR_LearnSkill_Punish = 3010           --学习惩戒
RLFR_LearnSkill_Inquiry = 3011          --学习盘查
RLFR_LearnSkill_GiftRefresh = 3012      --天赋刷新
RLFR_LearnSkill_WishTaskRewardRefresh = 3013--心愿刷新
RLFR_NewPlayer = 3200                   --新建账号
RLFR_NewPlayer_LoginReward = 3201       --新手登录奖励
RLFR_IDIP = 3500                        --IDIP
RLFR_IDIP_AddGold = 3501                --idip增加金锭
RLFR_IDIP_DescGold = 3502               --idip扣除金锭
RLFR_RedPacket = 3700                   --红包
RLFR_RedPacket_DescSilver = 3701        --红包扣除银锭
RLFR_RedPacket_GetItem = 3702           --领取红包
RLFR_RedPacket_SendFailBackItem = 3703  --红包发送失败退回道具
RLFR_RedPacket_SendFailBackSilver = 3704--红包发送失败退回银锭
RLFR_RedPacket_UseItem = 3705           --红包发送成功消耗道具
RLFR_Battle = 4100                      --战斗
RLFR_Battle_Pet = 4101                  --战斗宠物加成
RLFR_Battle_PlatChallenge = 4102        --平台切磋
RLFR_Battle_CallMaster = 4103           --呼叫高手
RLFR_Daily = 4200                       --每日
RLFR_Daily_Free = 4201                  --每日免费奖励
RLFR_Daily_Day3SignIn = 4202            --3天签到
RLFR_Daily_Day7SignIn = 4203            --7日签到奖励
RLFR_Daily_Challenge = 4204             --每日完整版奖励
RLFR_Activity = 4300                    --活动
RLFR_Activity_Wechat_ShareFriend = 4301 --每日微信分享好友奖励
RLFR_Activity_TreasureExchange_Refresh = 4302--秘宝活动-刷新兑换组
RLFR_Activity_TreasureExchange_Reward = 4303--秘宝活动-兑换奖励
RLFR_Activity_PreExprience_Reward = 4304--抢先体验活动-兑换积分奖励
RLFR_Activity_BackFlowPoint_Reward = 4305--回流活动-兑换积分奖励
RLFR_Activity_BackFlow_Reward = 4306    --回流活动-兑换奖励
RLFR_Activity_Fund_Reward = 4307        --基金活动奖励
RLFR_Activity_Fund_Open = 4308          --基金活动开通
RLFR_Activity_Festival_SignIn = 4309    --节日签到活动奖励
RLFR_Activity_Festival_DialyTask_Achieve = 4310--节日活动每日任务奖励
RLFR_Activity_Festival_Liveness_Achieve = 4311--节日活动活跃度奖励
RLFR_Activity_Festival_Exchange = 4312  --节日活动兑换
RLFR_Activity_Festival_BuyMall = 4313   --节日活动商店
RLFR_Card = 4400                        --卡片
RLFR_Card_LvlUp = 4401                  --等级提升
RLFR_Card_BondUp = 4402                 --羁绊提升
RLFR_Card_Find = 4403                   --找到卡片(如宠物摸头)
--to C++ enum [RecordLogFlowReason] Define END

--to C++ enum [SeTLogBattleType] Define BEGIN
STLBT_PVE = 0                           --铜币
STLBT_PVP = 1                           --银锭
STLBT_OTHER = 2                         --金锭
--to C++ enum [SeTLogBattleType] Define END

--to C++ enum [SeTLogTaskType] Define BEGIN
STLTT_INVALID = 0
STLTT_ENTRUST = 1                       --委托
STLTT_MAIN = 2                          --主线
STLTT_EXPERIENCE = 3                    --历练
STLTT_ROLE = 4                          --角色
STLTT_RUMORS = 5                        --传闻
STLTT_TREASURE = 6                      --百宝箱
--to C++ enum [SeTLogTaskType] Define END

--to C++ enum [SeTLogReMakeType] Define BEGIN
STLRMT_INVALID = 0
STLRMT_IRON = 1                         --精铁重铸
STLRMT_COIN = 2                         --铜币重铸
STLRMT_PERFECT = 3                      --完美重铸
STLRMT_BLUE = 4                         --蓝字重铸
STLRMT_ENHANCE = 5                      --强化
--to C++ enum [SeTLogReMakeType] Define END

--to C++ enum [SeTLogPetActType] Define BEGIN
STLPAT_INVALID = 0
STLPAT_GET_PET = 1                      --获得宠物
STLPAT_ASSISTANT = 2                    --助战
STLPAT_CANCEL_ASSIS = 3                 --取消助战
STLPAT_PLAT_ADD_DEBRIS = 4              --平台增加宠物碎片
STLPAT_SCRIPT_ADD_DEBRIS = 5            --剧本增加宠物碎片
--to C++ enum [SeTLogPetActType] Define END

--to C++ enum [SeTLogPlayerActType] Define BEGIN
STLPLAT_INVALID = 0
STLPLAT_ADD_FRIEND = 1                  --添加好友
STLPLAT_DEL_FRIEND = 2                  --删除好友
STLPLAT_CHALLENGE = 3                   --切磋
STLPLAT_WATCH = 4                       --观察
STLPLAT_RING_SIGN = 5                   --擂台报名
STLPLAT_RING_CHEER = 6                  --擂台助威
--to C++ enum [SeTLogPlayerActType] Define END

--to C++ enum [SeTLogUnlockType] Define BEGIN
STLULT_INVALID = 0
STLULT_CG = 1                           --解锁图鉴
STLULT_FORMULA = 2                      --配方
STLULT_TREASURE = 3                     --传家宝
STLULT_ROLE = 4                         --人物
STLULT_SKIN = 5                         --皮肤
--to C++ enum [SeTLogUnlockType] Define END

--to C++ enum [SeValidateType] Define BEGIN
SVT_INVALID = -1                        --无效位
SVT_SESSION_ID_ERROR = 0                --会话ID错误
SVT_REPEAT_IN_TOWN = 1                  --已经在城镇中了
SVT_NOT_LOAD_FINISH = 2                 --外:尚未加载完毕,内:数据库无返回
SVT_CANOT_SEND_VALID = 3                --外:数据服务失联，内:DB繁忙或者崩溃
SVT_LOAD_DATA_ERROR = 4                 --外:数据读取错误，内:登录数据加载中发生错误
SVT_LOAD_DATA_TOO_LONG = 5              --外:请求无数据，内:数据库响应太慢
SVT_CANOT_IN_HOUSE = 6                  --外:酒馆崩溃，内:对应线程崩溃
SVT_ERROR_LOGIN_TOKEN = 7               --外:登录校验错误，内:登录token错误
SVT_ERROR_PROTO_SANGOMAGIC = 8          --外:登录版本错误，内:伪造协议
SVT_ERROR_DB_CONNECT = 9                --外:连接状态异常，内:重复设置连接状态
SVT_SAME_REPLACEACCOUNT_ERROR = 10      --外:异地登录异常，内:同服顶号找不到连接
SVT_CONNECT_NUM_ERROR = 11              --外:异常的加载连接，内:数据库连接中断
SVT_CREATE_ROLE_SIZE_INSERT_ERROR = 12  --外:创角数据连接异常，内:创角数据传输大小不一致
SVT_CREATE_ROLE_REPEAT_NAME = 13        --外:创角异常请重试，内:创角重名
SVT_CREATE_ROLE_DBRET_ERROR = 14        --外:创角异常请重试，内:创角数据返回失败
SVT_LOADING_ERROR_CANOT_COMPLETE = 15   --外:无法找到加载数据项，内:找不到加载玩家
SVT_LOADING_ERROR_CANOT_INDEX = 16      --外:无法找到加载数据配置，内:找不到加载表项索引
SVT_LOADING_ERROR_CANOT_TYPE = 17       --外:无法找到加载数据类型，内:找不到加载表项类型
SVT_CREATE_TABLE_CONFIG_ERROR = 18      --外:数据加载表异常，内:随机名字等出错
SVT_CREATE_NAME_CONFIG_ERROR = 19       --外:名称异常，内:取名非法
SVT_LOADING_SELRET_ERROR = 20           --外:登录加载数据内容异常，内:BGA量太大
SVT_LOAD_ROLE_SIZE_SELECT_ERROR = 21    --外:载入数据连接异常，内:载入数据传输大小不一致
SVT_CREATE_ROLE_STREAM_ERROR = 22       --外:创角数据附加异常，内:创角数据传输大小不一致
SVT_DBS_LOAD_FULL = 23                  --DBS过载禁止登陆
SVT_DBS_STRUCT_ERROR = 24               --数据库字段有删改
SVT_GAME_SCRIPT_DUMP = 25               --剧本崩溃
SVT_ENTER_SCRIPT_LIMIT = 26             --剧本进入限制(崩溃次数太多，单人限制)
SVT_OVER_SCRIPT_PAYLOAD = 27            --剧本已达承载上限，请稍后再试
SVT_CANOT_SCRIPT_ENTER_REPEAT = 28      --不可同时进入两处剧本
SVT_INIT_SCRIPT_FAIL = 29               --剧本初始化失败
SVT_CANOT_ENTER_DEL_SCRIPT = 30         --所要进入的剧本不存在
SVT_JWT_CHEAT_PLAYERID = 31             --非法登入他人账号
SVT_JWT_CHEAT_SERVERNAME = 32           --选择登入的服务器与指定服务器不符
SVT_JWT_CHEAT_AREA = 33                 --选择登入的服务器与指定地区不符
SVT_JWT_CHEAT_TIME = 34                 --登录验证时间异常
SVT_INVALID_TCPUSER_STATE = 35          --登录验证连接状态异常
SVT_INVALID_LOGIN_PLAYER = 36           --未检测到玩家的唯一标识
SVT_INVALID_TOKEN_EMPTY = 37            --登录验证信息为空
SVT_INVALID_MAGIC_NUM = 38              --伪造登录验证协议约定
SVT_INVALID_LOGIN_TRY_TIME = 39         --登录频次过快，请稍后尝试
SVT_INVALID_REPLACE_OVER_TIME = 40      --加载频次过快，请稍后尝试
SVT_DBS_SQL_BUSY = 41                   --DBServer SQL 语句太多，处理不过来
SVT_SERVER_MAINTAIN = 44                --服务器处于维护状态
SVT_GAME_DB_ERROR = 500                 --游戏数据库查询出错
SVT_CHAR_NOT_EXIST = 800                --游戏角色还没创建
SVT_VALIDATE_OK = 1000                  --验证成功
SVT_REBUILD_CONNECT = 1001              --连接恢复
--to C++ enum [SeValidateType] Define END

--to C++ enum [SeReconResult] Define BEGIN
SRCR_SUCCESS = 0                        --验证成功
SRCR_COMMON_ERROR = 1                   --通用错误
SRCR_PLAYER_NOT_EXIST = 2               --玩家不存在
SRCR_SESSION_ERROR = 3                  --会话错误
SRCR_PLAYER_ONLINE = 4                  --玩家正常在线
SRCR_CACHE_PACK_DROP = 5                --缓存包有丢失
--to C++ enum [SeReconResult] Define END

--to C++ enum [SeCreateCharRet] Define BEGIN
CCR_CREATE_CHAR_OK = 0
CCR_NAME_EXIST = 1
CCR_HEROCARD_ERROR = 2
CCR_DB_ERROR = 3
--to C++ enum [SeCreateCharRet] Define END

--to C++ enum [SeValidEndRetType] Define BEGIN
SVERT_OK = 0
SVERT_TCPRELOAD = 1
SVERT_CREATE = 2
SVERT_RECONNECT = 3
SVERT_RELOGIN = 4
--to C++ enum [SeValidEndRetType] Define END

--to C++ enum [SeRaceLoadType] Define BEGIN
SRLT_DEFAULT = 0                        --默认比赛加载
--to C++ enum [SeRaceLoadType] Define END

--to C++ enum [SeTownValidType] Define BEGIN
STVT_TOWN = 0
STVT_RECON = 1
--to C++ enum [SeTownValidType] Define END

--to C++ enum [SeRaceValidType] Define BEGIN
SRVT_RACE = 0
SRVT_RECON = 1
SRVT_VIEW = 2
SRVT_NONE = 3
--to C++ enum [SeRaceValidType] Define END

--to C++ enum [SePlayerInfoQueryType] Define BEGIN
SPQT_NULL = 0
SPQT_FRIEND_INFO = 1                    --查询好友信息
SPQT_FRIEND_RMB_FLAG = 2                --查询好友充值信息
SPQT_END = 3
--to C++ enum [SePlayerInfoQueryType] Define END

--to C++ enum [SePublicValueOprType] Define BEGIN
SPVOT_ASSIGN = 0                        --赋值
SPVOT_INC = 1                           --加法
SPVOT_UNSET = 2                         --删除字段
--to C++ enum [SePublicValueOprType] Define END

--to C++ enum [SeFriendDataTargetOprType] Define BEGIN
SFDTOT_PRIVATE = 0                      --自己的私有数据
SFDTOT_SHARED = 1                       --与好友共享的数据
SFDTOT_FRIENDPRIVATE = 2                --好友的私有数据
--to C++ enum [SeFriendDataTargetOprType] Define END

--to C++ enum [SeMailType] Define BEGIN
SMAT_NULL = 0
SMAT_GM = 1                             --GM邮件
SMAT_SYSTEM = 2                         --系统邮件
SMAT_TREASUREMAZE = 3                   --宝藏图开启邮件
SMAT_GIVE_ADVANCEPURCHASE = 4           --赠送预约月卡邮件
SMAT_COMMIT_TREASUREEXP = 5             --上供百宝书经验
SMAT_ARENA_BET = 6                      --擂台赛押注奖励
SMAT_ARENA_BET_RANK = 7                 --擂台赛押注排行奖励
SMAT_ARENA_BATTLE_WIN = 8               --擂台赛战斗排名奖励
SMAT_DAY3SIGNIN_REWARD = 9              --三天签到奖励
SMAT_SWITCHTREASUREMONEY_ENDMONTH = 10  --月末残页回赠经脉经验奖励
SMAT_RANKLIST_REWARD = 11               --排行榜奖励
SMAT_HOODLECONTRRANKLIST_REWARD = 12    --全服小侠客排行奖励
SMAT_GRAB_TITLE_REWARD = 13             --抢称号奖励
SMAT_SHOPREWARDFAIL = 14                --打赏失败返还
SMAT_QQ_PRIVALIGEGIFT = 15              --QQ特权
SMAT_WX_PRIVALIGEGIFT = 16              --微信特权
SMAT_ZM_REWARD = 17                     --掌门对决结算奖励
SMAT_UNLOCK_CHALLENGE_ORDER_ORIGINAL_PRICE = 18--原价开通完整版
SMAT_WEEKEND_REWARD = 19                --某些结局奖励
SMAT_EQUIP = 30                         --装备附件
SMAT_LIMITSHOPBUY = 31                  --限时商店购买
SMAT_GIVEFRIEND_TREASUREBOOK = 32       --赠送好友百宝书
SMAT_ZM_CHAMPION_REWARD = 33            --掌门对决夺冠勋章
SMAT_END = 34
--to C++ enum [SeMailType] Define END

--to C++ enum [SeMailFilterType] Define BEGIN
SMFT_CREATE_TIME = 0                    --按创建时间过滤
SMFT_LEVEL = 1                          --按等级
SMFT_ZONE = 2                           --按大区
SMFT_SERVER = 3                         --按区服
SMFT_END = 4
--to C++ enum [SeMailFilterType] Define END

--to C++ enum [SeMailStateType] Define BEGIN
SMST_ANY = -1                           --任意
SMST_NEW = 0                            --未读未收
SMST_READ = 1                           --已读未收
SMST_RECEIVED = 2                       --未读已收
SMST_READRECEIVED = 3                   --已读已收
--to C++ enum [SeMailStateType] Define END

--to C++ enum [SeMailReceiveReasonType] Define BEGIN
SMRRT_SUC = 0                           --成功
SMRRT_TABLE_CANT_FIND = 1               --表中未填写
SMRRT_READ_FAIL = 2                     --读取错误
SMRRT_SCRIPT_FAIL = 3                   --不能在剧本内领取
--to C++ enum [SeMailReceiveReasonType] Define END

--to C++ enum [SeBabyState] Define BEGIN
SBS_NULL = 0                            --没有
SBS_CHECK = 1                           --需要判断能否出生
SBS_WILL = 2                            --下个月必定出生
SBS_PREBORN = 3                         --出生前历练
SBS_BORNED = 4                          --已出生
--to C++ enum [SeBabyState] Define END

--to C++ enum [SeBabyTaskState] Define BEGIN
SBTS_UnStart = 0                        --未开启
SBTS_End = 1                            --完成
--to C++ enum [SeBabyTaskState] Define END

--to C++ enum [SeModifyPlayerAppearanceType] Define BEGIN
SMPAT_NULL = 0
SMPAT_TITLE = 1                         --称号
SMPAT_PAINTING = 2                      --立绘
SMPAT_MODEL = 3                         --模型
SMPAT_BACKGROUND = 4                    --背景图
SMPAT_BGM = 5                           --BGM
SMPAT_POETRY = 6                        --诗词
SMPAT_NAME = 7                          --名字
SMPAT_PEDESTAL = 8                      --地台
SMPAT_SHOWROLE = 9                      --平台展示角色ID
SMPAT_LOGINWORD = 10                    --登陆词
SMPAT_HEADBOX = 11                      --头像框
SMPAT_CHATBOX = 12                      --聊天框
SMPAT_LANDLADY = 13                     --老板娘
SMPAT_END = 14                          --截止符
--to C++ enum [SeModifyPlayerAppearanceType] Define END

--to C++ enum [SeSpeicalDataType] Define BEGIN
SSDT_NULL = 0
SSDT_LUCKYVALUE = 1
SSDT_DAILY_LIMIT_ACT_FLAG = 2           --日限定标志
SSDT_MONEY = 3                          --货币
SSDT_RENAME_NUM = 4                     --命名次数
SSDT_OPEN_HOUSE = 5                     --开启酒馆
SSDT_SCRIPT_TRANS_FLAG = 6              --剧本挑战标记
SSDT_CREATE_SCRIPT_TIME = 7             --创建剧本时间
SSDT_DAILY_RESET = 8                    --剧本日重置标记
SSDT_FINFIRSTSHARE = 9                  --是否完成首次分享标记
SSDT_MAXID_SYNC = 10                    --MAXID
SSDT_SERVER_OPEN_TIME = 11              --开服时间
SSDT_ITEM = 12                          --物品
SSDT_LIMITGIFTOVERTIME = 13             --限时商店结束时间
SSDT_PLATBUFF = 14                      --平台BUFF
SSDT_ACTIVITYSTATE = 15                 --活动状态
--to C++ enum [SeSpeicalDataType] Define END

--to C++ enum [SeGameCmdType] Define BEGIN
SGC_NULL = 0
SGC_CREATE_SCRIPT = 1                   --创建剧本
SGC_LOAD_SCRIPT = 2                     --加载剧本
SGC_LOAD_MAXID = 3                      --加载各个Manager的最大ID
SGC_CARRY_PLAT_ITEM_INFO = 4            --带入平台物品数据
SGC_CARRY_PLAT_SHOP_INFO = 5            --带入平台商店数据
SGC_CARRY_PLAT_DYNAMIC_INFO = 6         --带入平台动态数据
SGC_CARRY_SCRIPT_DIFF_INFO = 7          --带入选择剧本难度数据
SGC_CARRY_ACHIEVE_REWARD_INFO = 8       --带入选择成就数据
SGC_CARRY_MERIDIANS_INFO = 9            --带入奇经八脉数据
SGC_CARRY_UNLOCK_INFO = 10              --带入解锁数据
SGC_CARRY_TREASUREBOOK_INFO = 11        --带入百宝书数据
SGC_CARRY_DIFFDROPDATA_INFO = 12        --带入全局幸运值掉落控制数据
SGC_CARRY_SPECIALDATA_INFO = 13         --带入特殊修改枚举数据
SGC_CARRY_BABY_INFO = 14                --带入孩子数据
SGC_CARRY_CREATE_ROLE_BABY_INFO = 15    --带入创角用的孩子数据
SGC_CARRY_WISH_INFO = 16                --带入心愿数据
SGC_CARRY_SCRIPT_SHOP_INFO = 17         --带入剧本商店限制数据
SGC_CARRY_GRAB_TITLE_INFO = 18          --带入剧本抢称号数据
SGC_CARRY_SAME_SCRIPT_PLAYER_INFO = 19  --带入同剧本玩家数据
SGC_CARRY_FINISH = 30                   --带入数据完毕
SGC_CHANGE_CONFIG = 31                  --动态配置
SGC_LOAD_ROLE_INFOS = 32                --加载角色数据
SGC_LOAD_MARTIALS = 33                  --加载武学数据
SGC_LOAD_ITEM_INFO = 34                 --加载物品
SGC_LOAD_SHOP_INFO = 35                 --加载商店
SGC_LOAD_DYNAMICATTR_INFO = 36          --加载动态属性
SGC_LOAD_CITY_INFO = 37                 --加载城市
SGC_LOAD_MAP_INFO = 38                  --加载地图
SGC_LOAD_TASK_INFO = 39                 --加载任务
SGC_LOAD_COMMON_INFO = 40               --加载主角通用数据
SGC_LOAD_GIFT_INFO = 41                 --加载天赋数据
SGC_LOAD_EVOLUTION_INFO = 42            --加载演化数据
SGC_LOAD_DROPCTRL_INFO = 43             --加载掉落控制数据
SGC_LOAD_WISH_INFO = 44                 --加载心愿数据
SGC_LOAD_MAZE_INFO = 45                 --加载迷宫数据
SGC_LOAD_CLAN_INFO = 46                 --加载门派数据
SGC_LOAD_DRTIMER_INFO = 47              --加载定时器数据
SGC_LOAD_ADVLOOT_INFO = 48              --加载地图捡垃圾数据
SGC_LOAD_ACHIEVE_INFO = 49              --加载成就数据
SGC_LOAD_FUNCTIONKVDATA_INFO = 50       --加载数据
SGC_LOAD_TAG_INFO = 51                  --加载标记数据
SGC_LOAD_BATTLE_INFO = 52               --加载标记数据
SGC_LOAD_SYSTEM = 53                    --动态任务
SGC_LOAD_FINALBATTLE = 54               --大决战
SGC_LOAD_NPCCONTACT_INFO = 55           --角色好感
SGC_LOAD_SCRIPTARENA_INFO = 56          --剧本擂台
SGC_LOAD_FINISH = 80                    --剧本数据加载完毕
SGC_SAVE_CHARINFO = 81                  --角色角色属性变动
SGC_SAVE_ROLEINFO = 82                  --角色信息变动
SGC_SAVE_MAPINFO = 83                   --地图信息变动
SGC_SAVE_ITEMINFO = 84                  --物品变动
SGC_SAVE_SHOPINFO = 85                  --商店变动
SGC_SAVE_MARTIALINFO = 86               --武学变动
SGC_SAVE_CITYINFO = 87                  --据点信息变动
SGC_SAVE_TASKINFO = 88                  --任务信息变动
SGC_SAVE_GIFTINFO = 89                  --天赋信息变动
SGC_SAVE_DYNAMICATTRINFO = 90           --动态属性变动
SGC_SAVE_WISHTASKINFO = 91              --星愿信息变动
SGC_SAVE_EVOLUTIONINFO = 92             --NPC演化信息变动
SGC_SAVE_CLANINFO = 93                  --门派信息变动
SGC_SAVE_TAGINFO = 94                   --标记变动
SGC_SAVE_DROPCTRLINFO = 95              --掉落产出控制
SGC_SAVE_DRTIMERINFO = 96               --定时器变动
SGC_SAVE_ADVLOOTINFO = 97               --地图捡垃圾变动
SGC_SAVE_ACHIEVINFO = 98                --成就信息变动
SGC_SAVE_FUNCTIONKVDATAINFO = 99        --信息变动
SGC_SAVE_MAZEINFO = 100                 --迷宫信息变动
SGC_SAVE_UNLOCKINFO = 101               --解锁变动
SGC_SAVE_OVERREPORT = 102               --周目结算数据
SGC_SAVE_BATTLE = 103                   --战斗数据
SGC_SAVE_SYSTEM = 104                   --动态任务
SGC_SAVE_REDKNIEF = 105                 --赤刀淬炼信息
SGC_SAVE_TREASUREBOOK = 106             --百宝书信息
SGC_SAVE_BABY = 107                     --新人出生信息
SGC_SAVE_FINALBATTLEINFO = 108          --大决战信息
SGC_SAVE_PLATFORM = 109                 --平台通知信息
SGC_SAVE_FINALBATTLE = 110              --大决战
SGC_SAVE_NPCCONTACT_INFO = 111          --角色关系
SGC_SAVE_TLOG = 112                     --TLOG
SGC_SAVE_SCRIPTARENA_INFO = 113         --剧本擂台
SGC_SAVE_FINISH = 150                   --保存完毕
SGC_CLIENT_CLICKMSG_BEGIN = 151         --用户上报指令开始,注意此指令分两类,剧本内的和剧本外的,剧本内的要在SGC_CLIENT_SCRIPT_END之前！！！
SGC_CLICK_MAP = 152                     --点击地图操作
SGC_CLICK_NPC = 153                     --NPC操作
SGC_CLICK_NPC_INTERACT = 154            --点击NPC选项中的选择,即兼容原来的角色交互
SGC_CLICK_MAZE = 155                    --点击迷宫操作
SGC_CLICK_ROLE_ADDATTRPOINT = 156       --角色加点
SGC_CLICK_ROLE_CHOOSE_WISHREWARD = 157  --角色选择心愿奖励
SGC_CLICK_ROLE_MARTIAL_FORGET = 158     --角色遗忘武学
SGC_CLICK_EXCHANGE_SILVER = 159         --兑换银锭
SGC_CLICK_ROLE_SHOP_OP = 160            --角色商店操作
SGC_CLICK_ITEM_OP = 161                 --角色物品操作
SGC_CLICK_ROLE_INSECT_GET = 162         --角色抓蛊
SGC_CLICK_ROLE_INSECT_SWALLOW = 163     --角色蛊虫吞噬
SGC_CLICK_ROLE_INSECT_ATTACHPOISION = 164--角色蛊虫附毒
SGC_CLICK_ROLE_JOIN_CLAN = 165          --角色加入门派
SGC_CLICK_AIINFO = 166                  --获取角色AI策略
SGC_CLICK_UPLOAD_AIINFO = 167           --上行角色AI策略
SGC_CLICK_BATTLE_WHEEL_WAR_RESULT = 168 --车轮战结果返回
SGC_CLICK_BATTLE_OPERATE_UNIT = 169     --战斗操作单位
SGC_CLICK_BATTLE_AUTO = 170             --当前单位自动战斗
SGC_CLICK_BATTLE_OBSERVE = 171          --观察单位
SGC_CLICK_BATTLE_GAME_END = 172         --战斗直接结束
SGC_CLICK_BATTLE_CALL_HELP = 173        -- 呼叫高手
SGC_CLICK_BATTLE_RETURN_PREBATTLE = 174 --返回战斗前
SGC_CLICK_BATTLE_WIN = 175              --战斗胜利
SGC_CLICK_BATTLE_AGAIN = 176            --再次挑战
SGC_CLICK_BATTLE_CHECK = 177            --战斗检查
SGC_CLICK_BATTLE_GIVEUP = 178           --认输战斗,从而结束周目
SGC_CLICK_DESICIBATTLE_IN = 179         --大决战参战
SGC_CLICK_RANDOM_ATTR = 180             --创角随机点数
SGC_CLICK_CREATE_ROLE = 181             --点击确定创角
SGC_CLICK_CREATE_BABY = 182             --点击确定创角
SGC_CLICK_CHEAT = 183                   --作弊指令
SGC_CLICK_ROLE_RANDOM_GIFT = 184        --获取随机天赋
SGC_CLICK_ROLE_ADD_GIFT = 185           --角色添加天赋
SGC_CLICK_ROLE_DEL_GIFT = 186           --角色删除天赋
SGC_CLICK_ROLE_RANDOM_WISHREWARDS = 187 --获取随机心愿奖励
SGC_CLICK_UPDATE_EMBATTLE_ROLES = 188   --更新上阵信息
SGC_CLICK_NPC_INTERACT_OPER = 189       --NPC交互操作
SGC_CLICK_TRY_INTERACT_WITH_NPC = 190   --尝试与NPC交互
SGC_CLICK_ACHIEVEPOINT = 191            --获取成就点
SGC_CLICK_DIALOG = 192                  --对话框返回
SGC_CLICK_CHOICE = 193                  --选择选项
SGC_CLICK_WEEKROUND_DIFF = 194          --周目难度选择
SGC_CLICK_CLAN_ENTER = 195              --选择进入门派
SGC_CLICK_CLAN_MARTIAL_LEARN = 196      --门派学武
SGC_CLICK_CLAN_MISSION_START = 197      --门派好感任务
SGC_CLICK_SELECT_SUBMIT_ITEM = 198      --提交物品
SGC_CLICK_PICKUP_ADVLOOT = 199          --捡垃圾
SGC_CLICK_INCOMPLETE_BOOK_BOX = 200     --点击残章匣
SGC_CLICK_CHANGE_EMBATTLE_MARTIAL = 201 --布阵武学更换
SGC_CLICK_UNLOCK_ROLE = 202             --解锁角色
SGC_CLICK_UNLOCK_SKIN = 203             --解锁皮肤
SGC_CLICK_BAGCAPACITY_BUY = 204         --购买背包容量
SGC_CLICK_TEMPBAG_MOVEBACK = 205        --临时背包物品移回
SGC_CLICK_SET_TITLE = 206               --设置称号
SGC_CLICK_SET_SUBROLE = 207             --设置替补
SGC_CLICK_BREAK_DISP_LIMIT = 208        --好感突破
SGC_CLICK_WEEKROUND_GAME_OVER = 209     --确认游戏结束
SGC_CLICK_CONSULT_CLOSE = 210           --请教界面关闭
SGC_CLICK_ROLE_DISGUISE = 211           --点击角色易容
SGC_CLICK_FINALBATTLE_ENTERCITY = 212   --大决战进入据点
SGC_CLICK_FINALBATTLE_QUITCITY = 213    --大决战退出据点
SGC_CLICK_FINALBATTLE_OPENBOX = 214     --大决战打开据点宝箱
SGC_CLICK_BABY_LEARN = 215              --点击拜师
SGC_CLICK_ADD_CLAN_DELEGATION_TASK = 216--增加门派委托任务
SGC_CLICK_ADD_CITY_DELEGATION_TASK = 217--增加城市委托任务
SGC_CLICK_LEAVETEAM = 218               --离开队伍
SGC_CLICK_SELECT_ZHUAZHOU = 219         --选择抓周结果
SGC_CLICK_START_CLAN_ELIMINATE = 220    --开始踢馆流程
SGC_CLICK_CHOOSE_TIGUAN = 221           --选择踢馆
SGC_CLICK_SET_EMBBATTLE_SUBROLE = 222   --设置战斗成员替补
SGC_CLICK_HIGHTOWER_EMBATTLE_OVER = 223 --千层塔混战布阵结束
SGC_CLICK_CLEAR_INTERACT_INFO = 224     --清空交互信息
SGC_CLICK_INQUIRY_CHOICE = 225          --盘查选择
SGC_CLICK_FINALBATTLE_ANTIJAMMA = 226   --大决战防卡死直接跳入
SGC_CLICK_CHOOSE_NPCMASTER = 227        --踢馆选择队友当掌门
SGC_CLICK_GETBABY_CLOSE = 228           --关闭收徒入队界面
SGC_CLICK_SCRIPT_ARENA_BATTLE_START = 229--开始剧本擂台
SGC_CLICK_CLOSE_SCRIPT_ARENA = 230      --关闭剧本擂台
SGC_CLICK_LIMITSHOP_ACTION = 231        --限时商店行为
SGC_CLICK_ROLE_LEARN_SECRET_BOOK_MARTIAL = 232--角色学习秘籍武学
SGC_CLICK_FORCE_WEEK_END = 233          --强制周目结束
SGC_CLICK_ROLECHALLENGE_SELECTROLE = 234--武神殿选择角色
SGC_CLICK_MARTIAL_STRONG = 235          --点击武学研读
SGC_CLICK_MAKEMARTIALSECRET = 236       --点击生成武学秘籍
SGC_CLICK_QUERY_RES_DROP_ACTIVITY_INFO = 237--点击查询资源掉落活动信息
SGC_CLICK_EXCHANGE_COLLECT_ACTIVITY = 238--点击兑换收集活动奖励
SGC_CLICK_COMMON_EMBATTLE_RESULT = 239  --点击发送布阵结果
SGC_CLICK_ROLE_FACE_OPERATE = 240       --剧本捏脸操作
SGC_CLICK_PICK_CUSTOM_ADV_LOOT = 241    --拾取自定义冒险掉落
SGC_CLICK_MAZE_ENTRY = 242              --点击迷宫进入确认
SGC_SAVE_NICKNAME = 243                 --保存主角昵称
SGC_SET_CLANBRANCHSTATE = 244           --更新小门派状态
SGC_KILL_CLANBRANCH = 245               --直接解散小门派
SGC_CLIENT_CLICKMSG_END = 700           --用户上报指令结束,click指令不可放此之后
SGC_SERVER_MSG_BEGIN = 701              --服务器主动通知的协议begin
SGC_SERVER_FRIENDOPENTREASURE = 702     --好友开宝箱
SGC_SERVER_MSG_END = 750                --服务器主动通知的协议结束
SGC_DISPLAY_CMD = 751                   --执行表现ID
SGC_DISPLAY_BEGIN = 752                 --所有下行消息开始下行
SGC_DISPLAY_GAMEDATA = 753              --下发游戏通用数据
SGC_DISPLAY_MAINROLEINFO = 754          --主角信息更新
SGC_DISPLAY_TEAM_INFO = 755             --队伍信息更新
SGC_DISPLAY_MAIN_ROLE_NAME = 756        --主角名称更新
SGC_DISPLAY_ROLECREATE = 757            --实例角色创建数据
SGC_DISPLAY_ROLEDELETE = 758            --实例角色删除数据
SGC_DISPLAY_ROLECOMMON = 759            --实例角色通用数据
SGC_DISPLAY_ROLE_FAVOR = 760            --实例角色喜好数据
SGC_DISPLAY_ROLE_BRO = 761              --实例角色结义数据
SGC_DISPLAY_ROLEATTRS = 762             --实例角色属性数据
SGC_DISPLAY_ROLEITEMS = 763             --实例角色物品数据
SGC_DISPLAY_ROLEMARTIALS = 764          --实例角色武学数据
SGC_DISPLAY_ROLEGIFTS = 765             --实例角色天赋数据
SGC_DISPLAY_ROLEWISHTASKS = 766         --实例角色星愿数据
SGC_DISPLAY_NPC_UPDATE = 767            --NPC角色更新数据
SGC_DISPLAY_NPC_DELETE = 768            --NPC角色删除数据
SGC_DISPLAY_EVOLUTION_DELETE = 769      --演化删除数据
SGC_DISPLAY_EVOLUTION_UPDATE = 770      --演化更新数据
SGC_DISPLAY_EVOLUTION_RECORDUPDATE = 771--演化记录更新
SGC_DISPLAY_EVOLUTION_RECORDDELETE = 772--演化记录删除
SGC_DISPLAY_MONTHEVOLUTION = 773        --月度演化结束
SGC_DISPLAY_CREATEMAINROLE = 774        --创角信息
SGC_DISPLAY_CREATEBABYROLE = 775        --创角信息
SGC_DISPLAY_DISPOSITION = 776           --更新好感度信息
SGC_DISPLAY_ITEMCREATE = 777            --物品创建数据
SGC_DISPLAY_ITEMDELETE = 778            --物品删除数据
SGC_DISPLAY_ITEMUPDATE = 779            --物品更新数据
SGC_DISPLAY_UNLOCKUPDATE = 780          --解锁更新数据
SGC_DISPLAY_SUBMITITEM_SELECT = 781     --选择提交物品
SGC_DISPLAY_MAP_ADVLOOT = 782           --捡垃圾
SGC_DISPLAY_DRTIMER_UPDATE = 783        --计时器更新数据
SGC_DISPLAY_ITEM_REFORGE_RESULT = 784   --重铸物品属性结果
SGC_DISPLAY_MARTIALDELETE = 785         --武学删除数据
SGC_DISPLAY_MARTIALUPDATE = 786         --武学更新数据
SGC_DISPLAY_SYSTEMINFO = 787            --游戏系统信息
SGC_DISPLAY_DIALOG = 788                --测试阶段使用,对话指令
SGC_DISPLAY_SELECT = 789                --测试阶段使用,选择指令
SGC_DISPLAY_CITY_MOVE = 790             --大地图移动到指定城市指令
SGC_DISPLAY_CITYDATA = 791              --城市信息更新下发
SGC_DISPLAY_MAPMOVE = 792               --测试阶段使用,地图移动指令
SGC_DISPLAY_MAP_UPDATE = 793            --地图数据更新
SGC_DISPLAY_ROLE_RANDOM_GIFT = 794      --获取随机天赋
SGC_DISPLAY_GIFTUPDATE = 795            --天赋更新
SGC_DISPLAY_GIFTDELETE = 796            --天赋删除
SGC_DISPLAY_ROLE_RANDOM_WISHREWARDS = 797--获取随机心愿奖励
SGC_DISPLAY_ROLE_WISHREWRAD = 798       --心愿奖励
SGC_DISPLAY_WISHTASKUPDATE = 799        --心愿更新
SGC_DISPLAY_WISHTASKDELETE = 800        --心愿删除
SGC_DISPLAY_TAGUPDATE = 801             --标记更新
SGC_DISPLAY_TAGDELETE = 802             --标记删除
SGC_DISPLAY_ACHIEVEUPDATE = 803         --成就更新
SGC_DISPLAY_ACHIEVEDELETE = 804         --成就删除
SGC_DISPLAY_TASKADD = 805               --增加一个任务实例
SGC_DISPLAY_TASKUPDATE = 806            --更新任务实例信息
SGC_DISPLAY_TASK_COMPLETE = 807         --显示任务结算界面
SGC_DISPLAY_TASK_REMOVE = 808           --删除任务实例
SGC_DISPLAY_BUYITEM = 809               --显示已经购买测试信息
SGC_DISPLAY_SELLITEM = 810              --显示已经卖出测试信息
SGC_DISPLAY_SHOP_UPDATE = 811           --商品信息更新
SGC_DISPLAY_SHOP_DELETE = 812           --商品信息清空
SGC_DISPLAY_BATTLE_SHOW_EMBATTLE = 813  --车轮战 显示布阵界面
SGC_DISPLAY_BATTLE_START = 814          --战斗开始
SGC_DISPLAY_BATTLE_CREATEUNIT = 815     --创建单位信息
SGC_DISPLAY_BATTLE_UPDATECOMBO = 816    --更新combo信息
SGC_DISPLAY_BATTLE_OBSERVEUNIT = 817    --观察单位信息
SGC_DISPLAY_BATTLE_UPDATEUNIT = 818     --更新单位信息
SGC_DISPLAY_BATTLE_UPDATEOPTUNIT = 819  --更新当前操作单位
SGC_DISPLAY_BATTLE_LOG = 820            --战斗信息日志
SGC_DISPLAY_UPDATE_TREASURE_BOX = 821   --更新宝箱信息
SGC_DISPLAY_BATTLE_HURT_INFO = 822      --更新伤害信息
SGC_DISPLAY_BATTLE_END = 823            --战斗结束
SGC_DISPLAY_BATTLE_AUTO = 824           --自动战斗
SGC_DISPLAY_BATTLE_BUFFDESC = 825       --更新buff描述信息
SGC_DISPLAY_BATTLE_UPDATEROUND = 826    --更新标准回合
SGC_DISPLAY_LOGICDEBUGINFO = 827        --游戏逻辑调试数据
SGC_DISPLAY_NPC_INTERACT_RANDOM_ITEMS = 828--展示NPC随机道具
SGC_DISPLAY_EXECUTE_PLOT = 829          --执行剧情
SGC_DISPLAY_EXECUTE_CUSTOM_PLOT = 830   --执行自定义剧情
SGC_DISPLAY_UPDATE_EMBATTLE_ROLES_RET = 831--更新上阵信息结果返回
SGC_DISPLAY_INIT_EMBATTLE_ROLES = 832   --初始化上阵信息
SGC_DISPLAY_BATTLE_CHECK = 833          --战斗检查
SGC_DISPLAY_NPC_INTERACT_GIVE_GIFT = 834--送礼结果
SGC_DISPLAY_INVITEABLE_UPDATE = 835     --邀请更新
SGC_DISPLAY_TASKTAG_GET = 836           --获取任务标记结果
SGC_DISPLAY_TASKTAG_SET = 837           --设置任务标记结果
SGC_DISPLAY_MAZE_UPDATE = 838           --更新迷宫数据
SGC_DISPLAY_MAZE_CARD_UPDATE = 839      --更新迷宫卡片数据
SGC_DISPLAY_MAZE_AREA_UPDATE = 840      --更新迷宫区域数据
SGC_DISPLAY_MAZE_GRID_UPDATE = 841      --更新迷宫地形格数据
SGC_DISPLAY_MAZE_UNLOCK_GRID_CHOICE = 842--解锁迷宫格选项界面
SGC_DISPLAY_MAZE_UNLOCK_GRID_SUCCESS = 843--解锁迷宫格成功
SGC_DISPLAY_MAZE_MOVE = 844             --迷宫移动下行
SGC_DISPLAY_MAZE_MOVE_TO_NEW_AREA = 845 --迷宫移动到新区域下行
SGC_DISPLAY_WEEKROUNDITEMOUT = 846      --周目结束带出物品数据显示
SGC_DISPLAY_WEEKROUNDITEMIN = 847       --周目带入物品
SGC_DISPLAY_DYNAMIC_ADV_LOOT_UPDATE = 848--动态冒险掉落更新
SGC_DISPLAY_CLAN_INFO_UPDATE = 849      --门派信息更新
SGC_DISPLAY_CLAN_MISSION_LETTER_INFO_UPDATE = 850--门派送信任务信息更新
SGC_DISPLAY_ACHIEVEPOINT = 851          --下行成就点
SGC_DISPLAY_INTERACT_DATE_UPDATE = 852  --交互时间更新
SGC_DISPLAY_INTERACT_REFRESHTIMES_UPDATE = 853--刷新次数更新
SGC_DISPLAY_ADD_INTERACT_OPTION = 854   --新增交互选项
SGC_DISPLAY_REMOVE_INTERACT_OPTION = 855--移除交互选项
SGC_DISPLAY_ADD_ROLE_SELECT_EVENT = 856 --新增选择角色事件
SGC_DISPLAY_REMOVE_ROLE_SELECT_EVENT = 857--移除选择角色事件
SGC_DISPLAY_INCOMPLETE_BOOK_UPDATE = 858--更新残章匣内容
SGC_DISPLAY_EMBATTLE_MARTIAL_UPDATE = 859--布阵武学更新
SGC_DISPLAY_TEMPBAG_LIST = 860          --临时物品列表更新
SGC_DISPLAY_ENTER_CITY = 861            --下行进入城市通知
SGC_DISPLAY_SHOW_FOREGROUND = 862       --显示前景通知
SGC_DISPLAY_UNLOCK_ROLE = 863           --解锁角色
SGC_DISPLAY_UNLOCK_SKIN = 864           --解锁皮肤
SGC_DISPLAY_NEW_TOAST = 865             --解锁皮肤
SGC_DISPLAY_WEEK_ROUND_END = 866        --周目结算下行
SGC_DISPLAY_CLEAR_INTERACT_STATE = 867  --通知客户端清空角色交互状态
SGC_DISPLAY_TRIGGER_ADV_GIFT = 868      --搜刮天赋触发
SGC_DISPLAY_ROLE_TITLEID = 869          --称号相关
SGC_DISPLAY_DISPLAY_CUSTOM_PLOT = 870   --自定义对话
SGC_DISPLAY_DYNAMICS_TOAST = 871        --Toast
SGC_DISPLAY_SCRIPT_ROLE_TITLE = 872     --剧本内称号
SGC_DISPLAY_BABYSTATE_UPDATE = 873      --徒儿信息更新
SGC_UPDATE_RANKLIST = 874               --更新排行榜
SGC_DISPLAY_REDKNIFE_UPDATE = 875       --淬炼信息创建
SGC_DISPLAY_REDKNIFE_DELETE = 876       --淬炼信息删除
SGC_DISPLAY_UPDATE_UNLOCK_DISGUISE = 877--更新已解锁易容
SGC_DISPLAY_FINALBATTLE_UPDATEINFO = 878--更新大决战信息
SGC_DISPLAY_FINALBATTLE_UPDATECITY = 879--更新大决战据点信息
SGC_DISPLAY_UPDATE_DELEGATION_STATE = 880--更新门派委托接受状态
SGC_DISPLAY_ClAN_ELIMINATE_SHOW = 881   --踢馆显示界面
SGC_DISPLAY_SHOWDATA_END_RECORD = 882   --添加展示数据结束记录
SGC_DISPLAY_START_GUIDE = 883           --开启引导
SGC_DISPLAY_UNLEAVEABLE_UPDATE = 884    --不可离队信息改变
SGC_DISPLAY_BATTLE_CALL_HELP = 885      --呼叫高手返回信息
SGC_DISPLAY_UPDATE_CHOCIE_INFO = 886    --更新选项信息
SGC_DISPLAY_CLEAR_CHOCIE_INFO = 887     --清空选项信息
SGC_DISPLAY_PLAY_MAZE_ROLE_ANIM = 888   --播放迷宫角色动画
SGC_DISPLAY_SHOW_MAZE_ROLE_BUBBLE = 889 --显示迷宫角色气泡
SGC_DISPLAY_MAZE_ENEMY_ESCAPE = 890     --迷宫敌人战斗逃跑
SGC_DISPLAY_CLOSE_GIVE_GIFT = 891       --隐藏送礼界面
SGC_DISPLAY_HIGHTOWER_BASE_INFO = 892   --千层塔基本信息
SGC_DISPLAY_HIGHTOWER_REST_ROLES = 893  --千层塔已休息角色
SGC_DISPLAY_INTERACT_DUEL_ROLES = 894   --决斗后消息
SGC_DISPLAY_INTERACT_INQUIRY = 895      --盘查结果
SGC_DISPLAY_MAINROLEPETINFO = 896       --主角宠物信息
SGC_DISPLAY_MAINROLENICKINFO = 897      --主角昵称信息
SGC_DISPLAY_SHOW_CHOICE_WINDOW = 898    --显示选项界面
SGC_DISPLAY_SCRIPT_ARENA_BATTLE_END = 899--剧本擂台战斗结束
SGC_DISPLAY_START_SCRIPT_ARENA = 900    --剧本擂台开始
SGC_DISPLAY_CLOSE_SCRIPT_ARENA = 901    --关闭剧本擂台
SGC_DISPLAY_AIINFO = 902                --AI策略
SGC_DISPLAY_MARTIALSTRONG = 903         --武学研读结果
SGC_DISPLAY_MAKEMARTIALSECRET = 904     --武学空白书使用结果
SGC_DISPLAY_SHOW_CHOOSEROLE = 905       --显示选择角色界面
SGC_DISPLAY_STARTSHARELIMITSHOP = 906   --开始限时商店分享流程
SGC_DISPLAY_DIFFDROPINFO = 907          --幸运值掉落信息
SGC_DISPLAY_RESDROP_ACTIVITY = 908      --显示资源掉落活动
SGC_DISPLAY_COLLECT_ACTIVITY_EXCHANGE_RES = 909--收集活动兑换结果
SGC_DISPLAY_UPDATE_SAME_THREAD_PLAYER = 910--更新同线程玩家数据
SGC_DISPLAY_NOTICE_CLIENT_FIGHT_PLAYER = 911--通知客户端切磋其他玩家
SGC_DISPLAY_NOTICE_CLIENT_ADD_FRIEND = 912--通知客户端添加好友
SGC_DISPLAY_LEVELUP = 913               --升级信息
SGC_DISPLAY_CLEAR_ALL_CHOICE_INFO = 914 --清空所有交互选项和任务选项信息
SGC_DISPLAY_SHOW_COMMON_EMBATTLE = 915  --显示通用布阵界面
SGC_DISPLAY_UPDATE_WEEK_ROUND_DATA = 916--更新周目统计数据
SGC_DISPLAY_CUSTOM_ADV_LOOT_UPDATE = 917--自定义冒险掉落状态更新
SGC_DISPLAY_AUTO_BATTLE_TEST_REPLAY = 918--自动战斗测试录像
SGC_SHOW_DIALOG = 919                   --显示对话框
SGC_DISPLAY_ROLE_FACE_QUERY = 920       --剧本捏脸查询返回
SGC_DISPLAY_ROLE_FACE_RESULT = 921      --剧本捏脸操作返回
SGC_DISPLAY_CLAN_BRANCH_INFO = 922      --更新小门派信息
SGC_DISPLAY_CLAN_BRANCH_RESULT = 923    --返回踢馆小门派结果
SGC_DISPLAY_DISGUISE = 924              --返回捏脸状态
SGC_DISPLAY_END = 925                   --所有下行消息发送完毕
SGC_END = 926                           --游戏指令结束
SGC_CMD_NUM = 927
--to C++ enum [SeGameCmdType] Define END

--to C++ enum [RoleAttrAddType] Define BEGIN
RAAT_BASE = 0                           --基础属性,人物升级成长+加点属性
RAAT_BASEPERCENT = 1                    --基础百分比,作用于基础属性
RAAT_NORMAL = 2                         --普通属性,装备+门派+武学+天赋+学艺+食物+心愿任务+经脉属性等
RAAT_NORMALPERCENT = 3                  --普通属性百分比,一般由周目,BUFF上加成而来
RAAT_CONVERT = 4                        --转换属性
RAAT_NUMS = 5                           --数量
--to C++ enum [RoleAttrAddType] Define END

--to C++ enum [RoleAddAttrPointType] Define BEGIN
RAAPT_LIDAO = 0                         --力道
RAAPT_TIZHI = 1                         --体质
RAAPT_JINGLI = 2                        --精力
RAAPT_NEIJIN = 3                        --内劲
RAAPT_LINGQIAO = 4                      --灵巧
RAAPT_WUXING = 5                        --悟性
RAAPT_NUMS = 6                          --数量
--to C++ enum [RoleAddAttrPointType] Define END

--to C++ enum [GetRoleItemType] Define BEGIN
GRI_NULL = 0                            --无效
GRI_BAG_ITEM = 1                        --背包
GRI_EQUIP_ITEM = 2                      --装备
GRI_ALL_ITEM = 3                        --全部
GRI_NUMS = 4                            --数量
--to C++ enum [GetRoleItemType] Define END

--to C++ enum [ClanEnterState] Define BEGIN
CES_NULL = 0                            --无效
CES_FIGHT = 1                           --闯入
CES_COIN = 2                            --铜币
CES_NUM = 3                             --数量
--to C++ enum [ClanEnterState] Define END

--to C++ enum [NpcEvolutionType] Define BEGIN
NET_TYPE_UNKNOW = 0                     --未知
NET_NAME_ID = 1                         --显示名称ID 参数1:显示名称, 参数2:姓, 参数3:名
NET_ATTR = 2                            --属性 参数1:属性类型,参数2:属性值
NET_LEVEL = 3                           --等级 参数1:等级,参数2:经验
NET_FRAGMENT = 4                        --碎片等级 参数1:碎片数量,参数2:叠加等级
NET_RANK = 5                            --品质 参数1:品质
NET_FAVORTYPE = 6                       --喜好 参数1:喜好
NET_ITEM_DEL = 7                        --(已废弃) 物品 参数1:ID,参数2:数量
NET_EQUIP_DEL = 8                       --(已废弃)装备 参数1:装备TypeID, 参数2:uID, 参数3:0
NET_REMOVE_ITEM_TYPEID_DEL = 9          --(已废弃) 删除背包db物品
NET_ITEM_TYPEID_DEL = 10                --(已废弃) 物品TypeID 参数1:TypeID, 参数2:数量
NET_EQUIP_TYPEID_DEL = 11               --(已废弃) 装备TypeID 参数1:TypeID, 参数2:0 参数3:0
NET_MARTIAL_TYPEID = 12                 --武学TypeID 参数1:TypeID, 参数2:等级, 参数3:经验
NET_GIFT_TYPEID = 13                    --天赋TypeID 参数1:TypeID
NET_CLAN = 14                           --门派 参数1:门派TypeID
NET_WISHTASK = 15                       --心愿任务 参数1:任务UID,参数2:状态ID
NET_INVITE_COND = 16                    --入队条件 参数1 condition ID
NET_SHOP = 17                           --商店 参数1:商店ID,参数2:位置，参数3: 消耗铜币数
NET_DOORKEEPER = 18                     --守门弟子
NET_SUBMASTER = 19                      --副掌门
NET_MAINMASTER = 20                     --正掌门
NET_TEMPMAINMASTER = 21                 --代理正掌门
NET_DUEL_PROTECT = 22                   --不能被决斗
NET_BEEN_DUELED = 23                    --被决斗过
NET_CONSULT_MARTIAL_TIMES = 24          --武学请教 参数1:typeid,参数2:次数
NET_CONSULT_GIFT_TIMES = 25             --天赋请教 参数1:typeid,参数2:次数
NET_STEEL_MARTIAL_TIMES = 26            --偷学武学 参数1:typeid,参数2:次数
NET_STEEL_GIFT_TIMES = 27               --偷学天赋 参数1:typeid,参数2:次数
NET_COMPARE_TIMES = 28                  --切磋次数 参数1: 0 参数2:次数
NET_BEG_TIMES = 29                      --乞讨次数 参数1: 0 参数2:次数
NET_RANDOM_GIFT_TIMES = 30              --随机天赋次数 参数1:0 参数2:次数
NET_EVO_MAZE = 31                       --演化到迷宫的id 参数1:迷宫格子id
NET_DISPOSITION_DES = 32                --关系链描述 参数1:角色typeid 参数2: 描述id
NET_TITLE = 33                          --称号 参数1:称号
NET_BROANDSIS = 34                      --结义 参数1:typeid
NET_MARRY = 35                          --结婚 参数1:typeid 参数2:孩子1typeid 参数3:孩子2typeid
NET_SUBROLE = 36                        --替补 参数1:roletypeid 考虑到儿子女儿的typeid是一样的但是不能替补
NET_SP_BUFF = 37                        --buff 参数1:特殊类型
NET_CHEAT_MARRY = 38                    --被骗婚过的标识 参数1:1
NET_BREAK_LIMIT = 39                    --好感突破标识 参数1:1 表示进行中 2 标识已经完成
NET_ROLEMODEL = 40                      --角色外观 参数1:RoleModel typeid
NET_ROLESEX = 41                        --角色性别 参数1:RoleSex enum
NET_PRISION = 42                        --牢房演化 参数1:BuildID
NET_INQUIRY = 43                        --盘查演化 参数1:盘查状态
NET_BINGHUOCANSHI = 44                  --冰火蚕尸毒演化 参数1:动态计时器ID 参数2:结束时间 参数3:动态任务ID
NET_NEXT_EVOLUTE = 45                   --下次执行演化 参数1:执行行为ID 参数2:执行条件ID
NET_PARENTS = 46                        --父母 参数1:父亲typeid 参数2:母亲typeid
NET_STATUS = 47                         --角色身份 参数1:身份
NET_CANTBATTLE = 48                     --无法上阵 参数1:原因
NET_ABSORBATTR = 49                     --当前角色吸能属性 参数1:吸能层数 参数2:属性类型 参数3:属性值
NET_ABSORBATTR_ITEM = 50                --吸能掉落物属性 参数1:吸取角色TypeID 参数2:属性类型 参数3:属性值
NET_ELIMINATE_MASTER = 51               --踢馆代理掌门 参数1:门派（最新一个，不代表唯一门派）
NET_DISGUISE = 52                       --角色易容行为 参数1:是否演化
NET_DYNAMIC_BUSINESS = 53               --神秘商人是否刷新
NET_NUMS = 54                           --数量
--to C++ enum [NpcEvolutionType] Define END

--to C++ enum [LetterMissionReq] Define BEGIN
REQ_LV = 0                              --等级要求
REQ_GOODEVIL = 1                        --仁义要求
REQ_CLAN = 2                            --门派要求
REQ_RANK = 3                            --品质要求
REQ_FAVOR = 4                           --喜好要求
REQ_NUMS = 5                            --数量
--to C++ enum [LetterMissionReq] Define END

--to C++ enum [ClanMissionState] Define BEGIN
CMS_NOR = 0                             --正常
CMS_REPORT = 1                          --待交付
CMS_END = 2                             --完成
CMS_GIVEUP = 3                          --放弃
CMS_NUMS = 4                            --数量
--to C++ enum [ClanMissionState] Define END

--to C++ enum [MainRoleInfoType] Define BEGIN
MRIT_NULL = 0                           --无效类型
MRIT_NULL1 = 1                          --无效类型1
MRIT_MAINROLEID = 2                     --主角ID
MRIT_CURMAP = 3                         --主角当前所处地图
MRIT_CUR_MAZE = 4                       --当前迷宫
MRIT_CUR_CITY = 5                       --当前城市
MRIT_MAINROLE_MODELID = 6               --模型ID
MRIT_BAG_ITEMNUM = 7                    --背包容量
MRIT_BUYBAG_FLAG = 8                    --购买背包标记
MRIT_ENHANCEGRADE_DAYCOUNT = 9          --每日银锭物品升级次数
MRIT_REFORGE_DAYCOUNT = 10              --每日银锭物品重铸次数
MRIT_CURCOIN = 11                       --主角铜币
MRIT_CUR_TITLE = 12                     --主角剧本当前称号
MRIT_SCRIPT_CARRY_ITEM_NUM = 13         --剧本带入物品数量
MRIT_EXTRA_GOOD = 14                    --额外好感度加成率
MRIT_EXTRA_MARITAL = 15                 --武学加成倍率
MRIT_EXTRA_ROLEEXP = 16                 --角色经验加成倍率
MRIT_EXTRA_ROLESELLITEM = 17            --商店卖货收益率
MRIT_ENMEY_DIFFUP = 18                  --敌人数值上浮
MRIT_EQUIP_ATTRUP = 19                  --装备属性上浮
MRIT_DIFF = 20                          --难度系数
MRIT_MARTIALLVMAX = 21                  --武学等级上限
MRIT_ROLELEVELMAX = 22                  --角色等级上限
MRIT_DEFAULT_GOOD = 23                  --默认好感度
MRIT_BATTLE_TEAMNUMS = 24               --可上阵队友数
MRIT_MARTIAL_NUM_MAX = 25               --武学数量上限
MRIT_GAME_STATE = 26                    --游戏状态,在这之前添加枚举后charscript表中对应枚举也要新增,上线后只许在此之后做插入，不然存档数据会乱掉,SePlayer::OnProcPlayerLoadFinish中rkRoleManager.add_mainroleinfos信息也要添加
MRIT_GOLD = 27                          --主角元宝
MRIT_SILVER = 28                        --主角银锭
MRIT_FORGE_EXP = 29                     --制造熟练度
MRIT_REFORGE_EXP = 30                   --重铸熟练度
MRIT_SAVE_FRAME_NUM = 31                --剧本存储帧数
MRIT_WEEK_TOTALTIME = 32                --周目累计时长
MRIT_MARTIAL_LOW_INCOMPLETETEXT = 33    --武学低级残文
MRIT_MARTIAL_MID_INCOMPLETETEXT = 34    --武学中级残文
MRIT_MARTIAL_HIGH_INCOMPLETETEXT = 35   --武学高级残文
MRIT_IS_RMBPLAYER = 36                  --是否是壕侠
MRIT_HEAVENHAMMER = 37                  --天工锤
MRIT_REFINEDIRON = 38                   --精铁
MRIT_PERFECTPOWDER = 39                 --完美粉
MRIT_MAINROLESEX = 40                   --主角性别
MRIT_LASTMAP = 41                       --主角上个所处地图
MRIT_LUCKEYVALUE = 42                   --幸运值
MRIT_GIFTMAXNUMS = 43                   --天赋最大数量
MRIT_INTERACT_UNLOCK_FLAG = 44          --交互解锁
MRIT_GREEN_EQUIP = 45                   --初始绿装
MRIT_UNLOCK_HOUSE = 46                  --解锁酒馆
MRIT_NPC_MASTER_ENABLE_STATE = 47       --江湖高手功能开启状态
MRIT_USER_RENAME_TIMES = 48             --玩家重命名次数
MRIT_LAST_POS_ROW = 49                  --上一个位置行
MRIT_LAST_POS_COLUMN = 50               --上一个位置列
MRIT_CLICK_ROW = 51                     --点击行
MRIT_CLICK_COLUMN = 52                  --点击列
MRIT_SCRIPT_TRANS_FLAG = 53             --剧本跳转标记
MRIT_CHALLENGE_ORDER_TYPE = 54          --挑战令类型
MRIT_CREATR_ROLE_ID = 55                --创角角色来源ID
MRIT_CREATE_SCRIPT_TIME = 56            --剧本创建时间
MRIT_WANGYOUCAO = 57                    --忘忧草
MRIT_ALL_CITY_FAVOR = 58                --全主城好感度
MRIT_ALL_CLAN_FAVOR = 59                --全门派好感度
MRIT_OWN_CLAN_FAVOR = 60                --本门派好感度
MRIT_REFRESHBALL = 61                   --刷新球
MRIT_MAKESCERETBOKK = 62                --武学空白书
MRIT_RESDROPACTIVITY_VALUE1 = 63        --资源掉落活动资产值1
MRIT_RESDROPACTIVITY_VALUE2 = 64        --资源掉落活动资产值2
MRIT_RESDROPACTIVITY_VALUE3 = 65        --资源掉落活动资产值3
MRIT_RESDROPACTIVITY_VALUE4 = 66        --资源掉落活动资产值4
MRIT_RESDROPACTIVITY_VALUE5 = 67        --资源掉落活动资产值5
MRIT_CUR_RESDROP_COLLECTACTIVITY = 68   --资源掉落收集活动ID
MRIT_TREASUREEXCHANGE_VALUE1 = 69       --秘宝资产值1
MRIT_TREASUREEXCHANGE_VALUE2 = 70       --秘宝资产值2
MRIT_FESTIVAL_VALUE1 = 71               --节日活动资产值1
MRIT_FESTIVAL_VALUE2 = 72               --节日活动资产值2
MRIT_TONGLINGYU = 73                    --通灵玉
MRIT_PLAYEROPENED_TREASUREMAP = 74      --玩家已经开启的藏宝图数量
MRIT_NUMS = 75                          --数量
--to C++ enum [MainRoleInfoType] Define END

--to C++ enum [EnNoTimeOutMessageType] Define BEGIN
ENTMT_WordFilter = 1                    --屏蔽字验证消息
ENTMT_WordFilter_PlatReName = 2         --平台起名屏蔽字验证消息
--to C++ enum [EnNoTimeOutMessageType] Define END

--to C++ enum [SeScriptState] Define BEGIN
SSS_NULL = 0                            --无效位
SSS_ENTER = 1                           --使用状态
SSS_NUMS = 2                            --数量
--to C++ enum [SeScriptState] Define END

--to C++ enum [GameState] Define BEGIN
GS_NULL = 0                             --无效位
GS_WENDA = 1                            --初始问答
GS_CREATEROLE = 2                       --创角状态
GS_BIGMAP = 3                           --大地图状态
GS_NORMALMAP = 4                        --普通地图状态
GS_MAZE = 5                             --迷宫状态
GS_FINAL_BATTLE = 6                     --大决战
GS_WEEK_END = 7                         --结束周目
GS_NUMS = 8                             --数量
--to C++ enum [GameState] Define END

--to C++ enum [UIState] Define BEGIN
US_NULL = 0                             --无效
US_SELECT = 1                           --选项
US_WEEKITEMIN = 2                       --周目物品带入
US_DIFF = 3                             --周目难度选择
US_SELECTITEM = 4                       --选择提交物品
US_SELECTCLAN = 5                       --选择门派界面
US_CLANELIMINATE = 6                    --门派灭门展示
US_REMOVESELECT = 7                     --移除选择界面
US_SCRIPTARENA = 8                      --剧本擂台界面
US_CLANELIMATE = 9                      --踢馆布阵界面
US_CHOOSENPCUI = 10                     --选择队友当掌门界面
US_HIDE_MENU = 11                       --隐藏菜单
US_CLANEBRANCHLIMINATE = 12             --小门派灭门展示
US_NUMS = 13                            --数量
--to C++ enum [UIState] Define END

--to C++ enum [SeMartialState] Define BEGIN
SMS_NULL = 0                            --无效位
SMS_EMBATTLE = 1                        --出战
SMS_NUMS = 2                            --数量
--to C++ enum [SeMartialState] Define END

--to C++ enum [SystemInfoType] Define BEGIN
SIT_NULL = 0                            --无效位
SIT_COMMON = 1                          --普通公告(左下角聊天框内显示的)
SIT_SYSTEM = 2                          --系统公告
SIT_WORLD = 3                           --世界公告
SIT_TV = 4                              --跑马灯电视公告
SIT_BUBBLE = 5                          --气泡提示
SIT_DIALOG = 6                          --弹框提示
NIT_NUMS = 7                            --数量
--to C++ enum [SystemInfoType] Define END

--to C++ enum [InteractUnlockWay] Define BEGIN
IUW_NULL = 0                            --无效位
IUW_ONCE = 1                            --剧本内
IUW_FOREVER = 2                         --永久
IUW_NUMS = 3                            --数量
--to C++ enum [InteractUnlockWay] Define END

--to C++ enum [RoleEquipItemPos] Define BEGIN
REI_NULL = 0                            --无效位
REI_WEAPON = 1                          --武器
REI_CLOTH = 2                           --衣服
REI_JEWELRY = 3                         --饰品
REI_WING = 4                            --翅膀
REI_THRONE = 5                          --神器
REI_SHOE = 6                            --鞋子
REI_RAREBOOK = 7                        --秘籍
REI_HORSE = 8                           --坐骑
REI_ANQI = 9                            --暗器
REI_MEDICAL = 10                        --医术
REI_NUMS = 11                           --数量
--to C++ enum [RoleEquipItemPos] Define END

--to C++ enum [SeItemRecycleType] Define BEGIN
SIRT_NULL = 0                           --无效位
SIRT_PLAT = 1                           --平台
SIRT_SCRIPT = 2                         --剧本
--to C++ enum [SeItemRecycleType] Define END

--to C++ enum [SeAchieveType] Define BEGIN
SAT_NULL = 0                            --无效
SAT_FINISH = 1                          --完成
SAT_UNFINISH = 2                        --未完成
--to C++ enum [SeAchieveType] Define END

--to C++ enum [FinalBattleState] Define BEGIN
FBS_NULL = 0                            --未开启
FBS_RUNNING = 1                         --进行中
FBS_WIN = 2                             --胜利
FBS_LOST = 3                            --失败
FBS_NORMALEND = 4                       --普通结局
--to C++ enum [FinalBattleState] Define END

--to C++ enum [ShowDataRecordType] Define BEGIN
SDRT_NULL = 0                           --无效
SDRT_GAMESTATE = 1                      --游戏状态
SDRT_ROLENAME = 2                       --角色名称
SDRT_ROLEMODEL = 3                      --角色外观
SDRT_UISTATE = 4                        --UI状态
--to C++ enum [ShowDataRecordType] Define END

--to C++ enum [PlayerSimpleInfoOptType] Define BEGIN
PSIOT_NULL = 0                          --无效
PSIOT_AREA = 1                          --下发酒馆玩家
PSIOT_LIST = 2                          --下发列表玩家
--to C++ enum [PlayerSimpleInfoOptType] Define END

--to C++ enum [RoleUpdateType] Define BEGIN
REUT_NULL = 0                           --无效
REUT_CREATE = 1                         --角色创建
REUT_DELETE = 2                         --角色删除
REUT_COMMON = 3                         --通用属性，名称称号等
REUT_ATTR = 4                           --属性数值，一级属性等
REUT_ITEM = 5                           --物品
REUT_GIFT = 6                           --天赋
REUT_MARTIAL = 7                        --武学
REUT_WISHTASK = 8                       --星愿任务
REUT_NUMS = 9                           --数量
--to C++ enum [RoleUpdateType] Define END

--to C++ enum [FriendOprType] Define BEGIN
FROT_NULL = 0                           --无效
FROT_QUERY = 1                          --查询
FROT_NUMS = 2                           --数量
--to C++ enum [FriendOprType] Define END

--to C++ enum [SeQueryFriendAttriType] Define BEGIN
SQFAT_NULL = 0                          --无效
SQFAT_RMBFLAG = 1                       --壕侠查询
--to C++ enum [SeQueryFriendAttriType] Define END

--to C++ enum [RoleAddMartialType] Define BEGIN
RAMT_NULL = 0                           --无效
RAMT_LEARN = 1                          --通过学习
RAMT_NOW = 2                            --直接添加
RAMT_NUMS = 3                           --数量
--to C++ enum [RoleAddMartialType] Define END

--to C++ enum [TaskProgressType] Define BEGIN
TPT_INIT = 0                            --开始任务
TPT_SUCCEED = 1                         --已完成
TPT_FAILED = 2                          --已失败
--to C++ enum [TaskProgressType] Define END

--to C++ enum [RoleBitField] Define BEGIN
RBF_TEAMMATES = 0
RBF_DEAD = 1
RBF_CANNOT_LEAVE = 2
RBF_ONCE_INTEAM = 3                     --曾经在队伍里
--to C++ enum [RoleBitField] Define END

--to C++ enum [RoleAddGiftType] Define BEGIN
RAGT_NULL = 0                           --测试
RAGT_LEARN = 1                          --学习
RAGT_STEAL = 2                          --偷学
RAGT_CONSULT = 3                        --请教
RAGT_USEITEM = 4                        --道具
RAGT_EQUIP = 5                          --装备
RAGT_TASK = 6                           --任务
RAGT_EVO = 7                            --演化
RAGT_EQUIP_ADV = 8                      --冒险
RAGT_WISH = 9                           --心愿
RAGT_NUMS = 10                          --数量
--to C++ enum [RoleAddGiftType] Define END

--to C++ enum [AddMartialType] Define BEGIN
AMT_NULL = 0                            --测试
AMT_LEARN = 1                           --学习
AMT_STEAL = 2                           --偷学
AMT_CONSULT = 3                         --请教
AMT_USEITEM = 4                         --道具
AMT_EQUIP = 5                           --装备
AMT_TASK = 6                            --任务
AMT_GIFT = 7                            --天赋
AMT_AOYI = 8                            --奥义
AMT_WISH = 9                            --心愿
AMT_NUMS = 10                           --数量
--to C++ enum [AddMartialType] Define END

--to C++ enum [RoleWishTaskType] Define BEGIN
RWTT_INVALID = 0                        --无效
RWTT_UNFINISH = 1                       --未完成
RWTT_FINISH = 2                         --完成
RWTT_END = 3                            --结束
--to C++ enum [RoleWishTaskType] Define END

--to C++ enum [SeRivakeTimeType] Define BEGIN
SRTT_YEAR = 0                           --年
SRTT_MONTH = 0                          --月
SRTT_DAY = 0                            --日
SRTT_HOUR = 0                           --刻
--to C++ enum [SeRivakeTimeType] Define END

--to C++ enum [WeekDiffLimitType] Define BEGIN
WDLT_STORAGEITEM_MAX = 0                --带入物品数量
WDLT_MARTIAL_NUM_MAX = 1                --武学数量上限
WDLT_ROLE_LV_MAX = 2                    --角色等级上限
WDLT_EXTRA_ROLEEXP = 3                  --角色经验加成率
WDLT_BASE_ATTR_MAX = 4                  --基础属性上限
WDLT_JINGTONG_ATTR_MAX = 5              --精通属性上限
WDLT_DAMAGE_MAX = 6                     --单次伤害上限
WDLT_ENEMY_ATTR_ADD = 7                 --敌人属性上浮
WDLT_EQUIP_LV_MAX = 8                   --装备等级上限
WDLT_EXTRAMARTIAL_MAX = 9               --额外武学数
WDLT_EXTRA_MARITAL = 10                 --武学经验加成率
WDLT_MARTIALLV_MAX = 11                 --武学等级上限
WDLT_HP_MAX = 12                        --最大生命上限
WDLT_DEFENSE_MAX = 13                   --最大防御上限
WDLT_GIFTVALUE_MAX = 14                 --最大天赋上限
WDLT_BATTLE_ROLE_MAX = 15               --最大上阵角色上限
WDLT_DEFAULT_GOOD_MAX = 16              --默认好感度
WDLT_EXTRA_GOOD = 17                    --好感度加成率
WDLT_BAG_MAX = 18                       --背包容量
WDLT_EXTRA_ROLESELLITEM = 19            --商店卖货收益率
WDLT_MP_MAX = 20                        --最大真气上限
WDLT_SPEED_MAX = 21                     --最大速度上限
WDLT_MARTIAL_ATTACK_MAX = 22            --最大武学攻击上限
WDLT_COIN_MAX = 23                      --最大铜币上限
WDLT_NUMS = 24                          --数量
--to C++ enum [WeekDiffLimitType] Define END

--to C++ enum [SeUnitCamp] Define BEGIN
SE_INVALID = 0                          --无效
SE_CAMPA = 1                            --阵营A
SE_CAMPB = 2                            --阵营B
SE_CAMPC = 3                            --阵营C
--to C++ enum [SeUnitCamp] Define END

--to C++ enum [SeBattleEndFlag] Define BEGIN
SE_DEFEAT = 1                           --失败
SE_VICTORY = 2                          --胜利
SE_SPECIALPLOT = 4                      --特殊剧情
SE_HIDEGAMEENDUI = 8                    --不显示战斗结束界面
SE_ARENABATTLE = 16                     --擂台赛战斗
SE_ONLYSHOWGIVEUP = 32                  --只显示认输按钮标记
SE_AUTOBATTLEAGAIN = 64                 --自动再次战斗
SE_ISLOAD = 128                         --由读档过来的
--to C++ enum [SeBattleEndFlag] Define END

--to C++ enum [SeBattleMartialStateFlag] Define BEGIN
BMSF_USEABLE = 0                        --可以使用
BMSF_NO_MP = 1                          --真气不足
BMSF_DIZZY = 2                          --眩晕
BMSF_FENG_YIN = 3                       --武学被封印
BMSF_EMBATTLE = 4                       --武学出阵
--to C++ enum [SeBattleMartialStateFlag] Define END

--to C++ enum [SeBattleEvaluateScoreType] Define BEGIN
SBEST_NO_DEATH = 0                      --无人死亡
SBEST_ONE_ROUND_WIN = 1                 --一回合内获胜
SBEST_ONE_TIME_KILL = 2                 --一击N杀
SBEST_BAO_JI = 3                        --暴击
SBEST_FAN_JI = 4                        --反击
SBEST_SHI_PO = 5                        --识破
SBEST_LIAN_JI = 6                       --连击
SBEST_HE_JI = 7                         --合击
SBEST_LIAN_ZHAO = 8                     --连招
SBEST_AO_YI = 9                         --发动奥义
SBEST_JUE_ZHAO = 10                     --发动绝招
SBEST_X_DEATH = 11                      --X人死亡
SBEST_X_ROUND = 12                      --X回合
SBEST_CALL_HELP = 13                    --呼叫高手
SBEST_NUM = 14                          --总数量
--to C++ enum [SeBattleEvaluateScoreType] Define END

--to C++ enum [SeRoleFaceOprType] Define BEGIN
SRFT_NULL = 0                           --无效位
SRFT_QUERY = 1                          --查询
SRFT_UNLOCK_ROLEFACE = 2                --银锭解锁部位
SRFT_UNLOCK_MODEL = 3                   --银锭解锁模型
SRFT_UPLOAD = 4                         --上传捏脸数据
SRFT_DELETE = 5                         --删除捏脸数据
--to C++ enum [SeRoleFaceOprType] Define END

--to C++ enum [SeRoleFaceOprTypeResult] Define BEGIN
SRFT_SUCCEED = 0                        --成功
SRFT_FAILED = 1                         --失败
SRFT_DISABLED = 2                       --系统关闭
SRFT_ROLE_NOT_EXIST = 3                 --捏脸角色不存在
SRFT_ROLEFACE_NOT_EXIST = 4             --解锁捏脸部位不存在
SRFT_ROLEFACE_NOT_SILVER = 5            --解锁不需要银锭
SRFT_ROLEFACE_UNLOCKED = 6              --捏脸部位已经解锁
SRFT_ROLEFACE_NOT_ENOUGH = 7            --解锁捏脸部位银锭不足
SRFT_ROLEFACE_HIDE = 8                  --捏脸角色部位隐藏
SRFT_ROLEFACE_LOCKED = 9                --捏脸角色部位未解锁
SRFT_ROLEFACE_SEXLIMIT = 10             --捏脸角色部位性别不匹配
SRFT_ROLEFACE_LIMIT = 11                --捏脸角色部位宽高位置超过限制
SRFT_ROLEFACE_POSITION_ERR = 12         --捏脸角色部位不匹配
SRFT_ROLEFACE_MODEL_NOT_EXIST = 13      --捏脸模型不存在
SRFT_ROLEFACE_MODEL_NOT_OPEN = 14       --捏脸模型未开放
SRFT_ROLEFACE_MODEL_NOT_SILVER = 15     --解锁捏脸模型不需要银锭
SRFT_ROLEFACE_MODEL_UNLOCKED = 16       --捏脸模型已经解锁
SRFT_ROLEFACE_MODEL_NOT_ENOUGH = 17     --解锁捏脸模型银锭不足
SRFT_ROLEFACE_MODEL_LOCKED = 18         --捏脸模型未解锁
SRFT_ROLEFACE_SEX_ERROR = 19            --捏脸性别不匹配
--to C++ enum [SeRoleFaceOprTypeResult] Define END

--to C++ enum [BattleDamageExtraFlag] Define BEGIN
BDEF_NULL = 0                           --null
BDEF_CRIT = 1                           --爆击
BDEF_MISS = 2                           --Miss
BDEF_POZHAO = 3                         --破招
BDEF_RECOVER = 4                        --恢复
BDEF_REBOUND = 5                        --反弹伤害
BDEF_CEJI = 6                           --侧击
BDEF_BEIJI = 7                          --背击
BDEF_FIGHT_BACK = 8                     --反击
BDEF_DAMGE_CEILING = 9                  --伤害上限
BDEF_TANSHE = 10                        --弹射
--to C++ enum [BattleDamageExtraFlag] Define END

--to C++ enum [BattleTreasureBoxFlag] Define BEGIN
BTBF_ADD = 0                            --添加
BTBF_DEL = 1                            --删除
BTBF_OPEN = 2                           --获取
--to C++ enum [BattleTreasureBoxFlag] Define END

--to C++ enum [BattleUseSkillExtraFlag] Define BEGIN
BUSEF_NULL = 1                          --null
BUSEF_LIAN_JI = 2                       --连击
BUSEF_HE_JI = 4                         --合击
BUSEF_LIAN_ZHAO = 8                     --连招
BUSEF_JUE_ZHAO = 16                     --绝招
BUSEF_AO_YI = 32                        --奥义
--to C++ enum [BattleUseSkillExtraFlag] Define END

--to C++ enum [SeBattleHurtBuffType] Define BEGIN
SBHBT_NULL = 0                          --空
SBHBT_NEW = 1                           --新增的buff
SBHBT_CHANGE_LAYER = 2                  --改变层数的
SBHBT_DEL = 3                           --删除的
--to C++ enum [SeBattleHurtBuffType] Define END

--to C++ enum [RoleEmbattleType] Define BEGIN
INVALID = 0                             --无效
IN_TEAM = 1                             --上阵
IN_ASSIST = 2                           --助阵
IN_SUB = 3                              --替补
--to C++ enum [RoleEmbattleType] Define END

--to C++ enum [BattleSkillEventType] Define BEGIN
BSET_Null = 0                           --空
BSET_ZhuDong = 1                        --主动
BSET_JueZhao = 2                        --绝招
BSET_HeJiQiDong = 3                     --合击启动
BSET_Combo = 4                          --combo
BSET_LianJi = 5                         --连击
BSET_FightBack = 6                      --反击
BSET_BeiDong = 7                        --被动
BSET_LianZhao = 8                       --连招
BSET_ZhuiJia = 9                        --追加
BSET_TouGuZhuiJia = 10                  --透骨追加
BSET_BeiDong_WUYUE = 11                 --被动_五岳
--to C++ enum [BattleSkillEventType] Define END

--to C++ enum [NPCInteractType] Define BEGIN
NPCIT_UNKNOW = 0                        --未知
NPCIT_GIFT = 1                          --送礼
NPCIT_WATCH = 2                         --观察
NPCIT_INVITE = 3                        --邀请
NPCIT_COMPARE = 4                       --切磋
NPCIT_BEG = 5                           --乞讨
NPCIT_RANDOM_GIFT = 6                   --随机天赋
NPCIT_STEAL_CONSULT = 7                 --偷学请教总类型
NPCIT_STEAL = 8                         --偷学总类型
NPCIT_STEAL_GIFT = 9                    --偷学天赋
NPCIT_STEAL_MARTIAL = 10                --偷学武学
NPCIT_CONSULT = 11                      --请教总类型
NPCIT_CONSULT_GIFT = 12                 --请教天赋
NPCIT_CONSULT_MARTIAL = 13              --请教武学
NPCIT_FIGHT = 14                        --决斗
NPCIT_SWORN = 15                        --结义
NPCIT_MARRY = 16                        --结婚
NPCIT_REFRESH_CONSULT = 17              --刷新请教次数
NPCIT_REFRESH_STEEL = 18                --刷新偷学次数
NPCIT_REFRESH_COMPARE = 19              --刷新切磋次数
NPCIT_REFRESH_BEG = 20                  --刷新乞讨次数
NPCIT_REFRESH_GIFT = 21                 --刷新天赋次数
NPCIT_REFRESH_WISHTASKREWARD = 22       --刷新心愿奖励次数
NPCIT_REFRESH_CALLUP = 23               --刷新号召次数
NPCIT_REFRESH_PUNISH = 24               --刷新惩恶次数
NPCIT_CHANGE_SUB_ROLE = 25              --更换替补
NPCIT_CALLUP = 26                       --号召
NPCIT_PUNISH = 27                       --惩恶
NPCIT_UNLOCK = 28                       --解锁交互
NPCIT_INQUIRY = 29                      --盘查
NPCIT_REFRESH_INQUIRY = 30              --刷新盘查次数
NPCIT_ABSORB = 31                       --吸能
NPCIT_NUMS = 32                         --总数量
--to C++ enum [NPCInteractType] Define END

--to C++ enum [ClanState] Define BEGIN
CLAN_CLOSE = 0                          --未开启
CLAN_WAIT_OPENED = 1                    --等待开启
CLAN_WAIT_OPENED_NONPC = 2              --等待开启不初始化npc
CLAN_OPENED = 3                         --开启
CLAN_DISAPPEAR = 4                      --消失
CLAN_ALIGN = 5                          --结盟
CLAN_DRIVE_OUT = 6                      --驱逐
CLAN_TREASURE_GOT = 7                   --领取传家宝
--to C++ enum [ClanState] Define END

--to C++ enum [SePlatTeamQueryType] Define BEGIN
SPTQT_NULL = 0                          --无效
SPTQT_PLAT = 1                          --平台阵容
SPTQT_SCRIPT = 2                        --剧本阵容
SPTQT_COMMON = 3                        --通用数据
SPTQT_INSTROLE = 4                      --实例角色
SPTQT_EMBATTLE = 5                      --布阵信息
SPTQT_TEAM = 6                          --阵容信息
SPTQT_OBSERVE_OTHER = 7                 --观察他人
SPTQT_OBSERVE_ARENA = 8                 --擂台观察
--to C++ enum [SePlatTeamQueryType] Define END

--to C++ enum [SePlatTeamEmbattleInfo] Define BEGIN
SPTE_NULL = 0                           --无效
SPTE_SINGLE = 1                         --单人
SPTE_TEAM = 2                           --组队
--to C++ enum [SePlatTeamEmbattleInfo] Define END

--to C++ enum [SeArenaRequestType] Define BEGIN
ARENA_REQUEST_NULL = 0                  --无效
ARENA_REQUEST_MATCH = 1                 --请求擂台赛数据
ARENA_REQUEST_BATTLE = 2                --查看战斗数据
ARENA_REQUEST_SIGNUP = 3                --擂台赛报名
ARENA_REQUEST_UPDATE_PK_DATA = 4        --更新擂台赛PK数据
ARENA_REQUEST_VIEW_RECORD = 5           --查看录像
ARENA_REQUEST_SIGNUP_MEMBER_NAME = 6    --查看入围玩家姓名
ARENA_REQUEST_VIEW_BET_RANK = 7         --查看押注胜场榜
ARENA_REQUEST_VIEW_OTHER_MEMBER_PK_DATA = 8--查看其他玩家PK信息
ARENA_REQUEST_HISTORY_MATCH_DATA = 9    --查看历史比赛信息
ARENA_REQUEST_JOKE_MATCH_DATA = 10      --查看本人娱乐赛信息
ARENA_REQUEST_CHAMPION_TIMES_DATA = 11  --查看本人比赛冠军次数信息
ARENA_REQUEST_HUASHANTOPMEMBER = 12     --查看华山论剑入围名单
--to C++ enum [SeArenaRequestType] Define END

--to C++ enum [SeArenaNoticeType] Define BEGIN
ARENA_NOTICE_NULL = 0                   --无效
ARENA_NOTICE_SIGNUP = 1                 --报名
ARENA_NOTICE_BET = 2                    --押注
ARENA_NOTICE_UPDATEPLATFORM = 3         --更新阵容
--to C++ enum [SeArenaNoticeType] Define END

--to C++ enum [SeShopMallType] Define BEGIN
SSMT_NULL = 0                           --无
SSMT_PLATSHOP = 1                       --酒馆商店
SSMT_TREASURESHOP = 2                   --百宝书商城
SSMT_SCRIPTSHOP = 3                     --剧本商店
--to C++ enum [SeShopMallType] Define END

--to C++ enum [PlatShopMallRewardType] Define BEGIN
PSMRT_NULL = 0                          --无
PSMRT_MONEY = 1                         --金锭打赏
PSMRT_AD = 2                            --广告打赏
PSMRT_QUERY = 3                         --查询当前打赏总额
--to C++ enum [PlatShopMallRewardType] Define END

--to C++ enum [PlatShopMallRewardRetType] Define BEGIN
PSMRRT_SUCCESS = 0                      --打赏成功
PSMRRT_FAILED = 1                       --打赏失败
PSMRRT_CURREWARDVALUE = 2               --当前打赏总额
--to C++ enum [PlatShopMallRewardRetType] Define END

--to C++ enum [PlatShopMallBuyRetType] Define BEGIN
PSMBRT_SUCCESS = 0                      --购买成功
PSMBRT_FAILED = 1                       --购买失败
--to C++ enum [PlatShopMallBuyRetType] Define END

--to C++ enum [PlatShopItemState] Define BEGIN
PSIS_NULL = 1                           --null
PSIS_LIMITBUYED = 2                     --已购买
PSIS_UNLOCKCLAN = 4                     --门派未解锁
PSIS_TIMELIMIT = 8                      --限时购买
PSIS_MEDIANSLV = 16                     --经脉等级不足
PSIS_ADDTOTALGOLD = 32                  --总充值金锭不足
--to C++ enum [PlatShopItemState] Define END

--to C++ enum [MoneyOprType] Define BEGIN
MOT_NULL = 0                            --null
MOT_SHOPBUY = 1                         --商城购买
MOT_GOLDEXCHANGE = 2                    --金锭兑换
MOT_TreasureBook_BRMB = 3               --开通壕侠
MOT_PresentGold = 4                     --增加代币
MOT_BUYChallengeOrder = 5               --购买挑战令
MOT_BuyHorse = 6                        --买马
MOT_BuyTreasureExp = 7                  --购买百宝书经验
MOT_TreasureBook_AdvancePurchase = 8    --预购月卡
MOT_TreasureBook_GiveOther = 9          --给好友预购月卡
MOT_TreasureBook_GiveOtherFail = 10     --给好友预购月卡失败
MOT_AddGold = 11                        --使用道具增加金锭
MOT_BuyDiscount_Coupon = 12             --购买优惠券
MOT_OpenMaxMeridiansLimitNum = 13       --经脉经验开上限
MOT_IdipCostGold = 14                   --idip扣除代币
MOT_SHOPLIMIT = 15                      --限时商店
MOT_SHOPLIMITRECHARGE = 16              --限时商店充值
MOT_SHOPGOLDREWARD = 17                 --金锭打赏
MOT_OPENFUND = 18                       --购买基金
MOT_Max = 19                            --操作上限
--to C++ enum [MoneyOprType] Define END

--to C++ enum [Click_Map_Type] Define BEGIN
CMT_NULL = 0                            --null
CMT_BUILDING = 1                        --点击建筑
CMT_CITY = 2                            --点击城市
CMT_BACKRETURN = 3                      --点击返回上一个场景
CMT_TILE = 4                            --点击新地图格
CMT_QUICKCITY = 5                       --点击新大地图城市
--to C++ enum [Click_Map_Type] Define END

--to C++ enum [Click_Maze_Type] Define BEGIN
CMAT_NULL = 0                           --null
CMAT_QUIT = 1                           --退出迷宫
CMAT_CLICKGRID = 2                      --点击迷宫格
CMAT_UNLOCKGRID = 3                     --点击解锁迷宫格
CMAT_GOAWAY = 4                         --点击绕道而行
--to C++ enum [Click_Maze_Type] Define END

--to C++ enum [Click_Shop_Type] Define BEGIN
CST_NULL = 0                            --null
CST_BUY = 1                             --购买
CST_SELL = 2                            --卖出
--to C++ enum [Click_Shop_Type] Define END

--to C++ enum [Click_Item_Type] Define BEGIN
CIT_NULL = 0                            --null
CIT_USE = 1                             --使用物品
CIT_USE_CONFIRM = 2                     --使用物品
CIT_MAKE = 3                            --打造物品
CIT_REFORGE = 4                         --重铸物品
CIT_REFORGESAVE = 5                     --重铸属性保存
CIT_REPAIR = 6                          --修复物品
CIT_SMELT = 7                           --熔炼物品
CIT_UPGRADE = 8                         --升级物品
CIT_EQUIP = 9                           --装备物品
CIT_UNEQUIP = 10                        --卸下物品
--to C++ enum [Click_Item_Type] Define END

--to C++ enum [DBLogServerQueryType] Define BEGIN
DBSQT_NULL = 0                          --null
DBSQT_SHOPREWARD = 1                    --查询打赏数据
--to C++ enum [DBLogServerQueryType] Define END

--to C++ enum [DBLogServerSendType] Define BEGIN
DBSST_NULL = 0                          --null
DBSST_ADD = 1                           --累加
--to C++ enum [DBLogServerSendType] Define END

--to C++ enum [DelegationTaskState] Define BEGIN
DTS_CLOSE = 0                           --未开启
DTS_OPEN = 1                            --开启
--to C++ enum [DelegationTaskState] Define END

--to C++ enum [ChallengeOrderType] Define BEGIN
COT_FREE = 0                            --免费
COT_MID = 1                             --中级
COT_HIGH = 2                            --高级
COT_FIFTY_DISCOUNT = 3                  --50%折扣
COT_TWENTYFIVE_DISCOUNT = 4             --25%折扣
--to C++ enum [ChallengeOrderType] Define END

--to C++ enum [Day3SignInOptType] Define BEGIN
D3SOT_NULL = 0                          --无效
D3SOT_REQUEST = 1                       --请求数据
D3SOT_OPENWINDOW = 2                    --打开界面
D3SOT_BUYHORSE = 3                      --买马
D3SOT_JOINTEAM = 4                      --入队
D3SOT_WALK = 5                          --走回
--to C++ enum [Day3SignInOptType] Define END

--to C++ enum [Day3SignInStateType] Define BEGIN
D3SST_NULL = 0                          --无效
D3SST_FIRST = 1                         --第一天
D3SST_SECOND_NORMAL = 2                 --第二天未氪金
D3SST_SECOND_FREE = 3                   --第二天不氪金
D3SST_THIRD = 4                         --第三天到第N天
D3SST_MAX_DAY_NUM = 9                   --活动最长时间 从开启算
D3SST_END = 10                          --活动结束
--to C++ enum [Day3SignInStateType] Define END

--to C++ enum [InquiryResultType] Define BEGIN
IRT_NULL = 0                            --无效
IRT_SAFE = 1                            --无罪
IRT_DOUBT = 2                           --可疑
IRT_GUILT = 3                           --有罪
--to C++ enum [InquiryResultType] Define END

--to C++ enum [InquiryChoiceType] Define BEGIN
ICT_NULL = 0                            --无效
ICT_FREE = 1                            --网开一面
ICT_CATCH = 2                           --缉拿归案
ICT_NOTHING = 3                         --什么都不做
--to C++ enum [InquiryChoiceType] Define END

--to C++ enum [AttrTypeMax] Define BEGIN
ATM_NULL = 0                            --无效
ATM_HITATKPER = 1                       --命中率
ATM_SHANBILV = 2                        --闪避率
ATM_CRITATKPER = 3                      --暴击率
ATM_BAOJIDIKANGLV = 4                   --暴击抵抗率
ATM_CRITATKTIME = 5                     --暴击伤害倍数
ATM_CONTINUATKPER = 6                   --连击率
ATM_LIANZHAOLV = 7                      --连招率
ATM_HEJILV = 8                          --合击率
ATM_IGNOREDEFPER = 9                    --忽视防御率
ATM_KANGLIANJILV = 10                   --抗连击率
ATM_POZHAOLV = 11                       --破招率
ATM_FANJILV = 12                        --反击率
ATM_SUCKHP = 13                         --吸血率
ATM_FANTANLV = 14                       --反弹率
ATM_FANTANBEISHU = 15                   --反弹倍数
ATM_YUANHULV = 16                       --援护率
ATM_JUEZHAOLV = 17                      --绝招率
--to C++ enum [AttrTypeMax] Define END

--to C++ enum [TencentCreditScoreSceneLimitSystem] Define BEGIN
TCSSLS_NULL = 0                         --无效位
TCSSLS_WORLD_CHAT = 1                   --世界聊天
TCSSLS_PRIVATE_CHAT = 2                 --私聊
TCSSLS_APPLY_FRIENDS = 3                --申请加他人为好友
TCSSLS_CHALLENGE = 4                    --切磋
TCSSLS_ARENA_SIGNUP = 5                 --报名擂台赛
TCSSLS_RANKLIST = 6                     --上排行榜
TCSSLS_NUM = 7                          --数量
--to C++ enum [TencentCreditScoreSceneLimitSystem] Define END

--to C++ enum [SeEnKvType] Define BEGIN
EN_KV_NULL = 0
EN_KV_LIMIT_SHOP = 1
--to C++ enum [SeEnKvType] Define END

--to C++ enum [EnErrLimitShop] Define BEGIN
EErrLShop_NoShopData = 1001             --shop data not found
EErrLShop_NoShopGift = 1002             --shop gift not found
EErrLShop_ShopGiftSold = 1003           --shop gift sold out
EErrLShop_RefreshCoolDown = 1004        --shop refresh in cool down
EErrLShop_AlreadyShared = 1005          --already shared
EErrLShop_NoCoupon = 1006               --coupon not found
EErrLShop_CouponExpired = 1007          --coupon expired
EErrLShop_NeedGetYaZhu = 1008           --please get yazhu first
EErrLShop_YaZhuGameFinished = 1009      --yazhu game finished
EErrLShop_AlreadyFirstShare = 1010      --already finished first share
EErrLShop_ShortageBigGold = 1011        --shortage big-gold
EErrLShop_ShortageGold = 1012           --shortage gold
EErrLShop_CouponTooMany = 1013          --coupon too many
--to C++ enum [EnErrLimitShop] Define END

--to C++ enum [SeLimitShopOprType] Define BEGIN
EN_LIMIT_SHOP_GET = 0                   --获取
EN_LIMIT_SHOP_REFLASH = 1               --刷新
EN_LIMIT_SHOP_REFLASHRET = 2            --刷新返回
EN_LIMIT_SHOP_BUY = 3                   --购买
EN_LIMIT_SHOP_RECHARGE = 4              --充值
EN_LIMIT_SHOP_FIRSTSHARE = 5            --首次分享
EN_LIMIT_SHOP_GETYAZHU = 6              --获取押注
EN_LIMIT_SHOP_YAZHU = 7                 --押注
EN_LIMIT_SHOP_YAZHU_RET = 8             --押注返回
EN_LIMIT_SHOP_SHARE = 9                 --普通分享
EN_LIMIT_SHOP_BUY_RET = 10              --购买返回
EN_LIMIT_SHOP_FIRSTSHAREOPR = 11        --首次分享操作
EN_LIMIT_SHOP_GETFIRSTSHARE = 12        --获取首次分享
EN_LIMIT_SHOP_FINFIRSTSHARE_RET = 13    --完成首次分享返回
--to C++ enum [SeLimitShopOprType] Define END

--to C++ enum [EnLimitType] Define BEGIN
EN_LIMIT_FREE = 0                       --免费
EN_LIMIT_LV = 1                         --冲级
EN_LIMIT_LVUP = 2                       --重铸
EN_LIMIT_WU = 3                         --角色卡
EN_LIMIT_EQUIP = 4                      --暗金残章
--to C++ enum [EnLimitType] Define END

--to C++ enum [NpcStaticItemState] Define BEGIN
NSIS_DEFAULT = 0                        --默认 
NSIS_BAG = 1                            --背包中
NSIS_EQUIP = 2                          --装备中
NSIS_REMOVE = 3                         --被移除
NSIS_NUMS = 4                           --不能再新加枚举了
--to C++ enum [NpcStaticItemState] Define END

--to C++ enum [EnZMRequest] Define BEGIN
EN_ZM_REQUEST_NULL = 0                  --无效
EN_ZM_REQUEST_Match = 1                 --匹配掌门对决
EN_ZM_REQUEST_SelectClan = 2            --选掌门
EN_ZM_REQUEST_SelectCard = 3            --选卡
EN_ZM_REQUEST_SelectEquip = 4           --选装备
EN_ZM_REQUEST_SetBattleCard = 5         --设置上阵卡牌
EN_ZM_REQUEST_EquipCard = 6             --卡牌装备神器
EN_ZM_REQUEST_ReflashClan = 7           --刷新掌门
EN_ZM_REQUEST_ReflashCard = 8           --刷新卡牌
EN_ZM_REQUEST_ReflashEquip = 9          --刷新装备
EN_ZM_REQUEST_ViewRecord = 10           --观看录像
EN_ZM_REQUEST_GetRoom = 11              --获取房间
EN_ZM_REQUEST_MatchEnd = 12             --匹配成功
EN_ZM_REQUEST_MatchCancle = 13          --匹配取消
EN_ZM_REQUEST_Die = 14                  --已被淘汰
EN_ZM_REQUEST_End = 15                  --战斗结束
EN_ZM_REQUEST_BuyShop = 16              --商店购买
EN_ZM_REQUEST_LeaveShop = 17            --退出商店
EN_ZM_REQUEST_WatchOther = 18           --观察其他玩家
EN_ZM_REQUEST_UseClanSkill = 19         --使用掌门技能
--to C++ enum [EnZMRequest] Define END

--to C++ enum [EnZMError] Define BEGIN
EN_ZM_ERROR_None = 0                    --没有错误
EN_ZM_ERROR_InRoom = 1                  --已加入掌门对决,无法加入其他场掌门对决
EN_ZM_ERROR_NoExist = 2                 --掌门对决场次不存在
EN_ZM_ERROR_Playing = 3                 --掌门对决已经开始,无法加入
EN_ZM_ERROR_AlreadyClan = 4             --掌门已选
EN_ZM_ERROR_NoJoin = 5                  --没参加匹配
EN_ZM_ERROR_AlreadyJoin = 6             --在匹配队列
EN_ZM_ERROR_Die = 7                     --已被淘汰无法操作
EN_ZM_ERROR_RoomNoPlayer = 8            --玩家没有参加本场次
EN_ZM_ERROR_AlreadyOpt = 9              --本轮已经选择
EN_ZM_ERROR_Parmas = 10                 --参数错误
EN_ZM_ERROR_NoRoom = 11                 --是否参加掌门对决
EN_ZM_ERROR_NoShop = 12                 --是否掌门对决结算
EN_ZM_ERROR_InShop = 13                 --掌门商店结算不能匹配
EN_ZM_ERROR_NoGold = 14                 --掌门商店金币不够
EN_ZM_ERROR_NoRole = 15                 --掌门商店不存在此角色卡
EN_ZM_ERROR_AlreadyBuyRole = 16         --掌门商店此角色卡已购买
EN_ZM_ERROR_NoTickets = 17              --掌门对决门票不足
EN_ZM_ERROR_NoServer = 18               --即将停服，不能开始新的掌门对决比赛
EN_ZM_ERROR_AlreadyUseClanSkill = 19    --已经使用掌门技能
EN_ZM_ERROR_AlreadyNewFlag = 20         --已参加过锅掌门对决新手引导
EN_ZM_ERROR_NotMatchTime = 21           --当前不在匹配时间内
--to C++ enum [EnZMError] Define END

--to C++ enum [EnZMNotice] Define BEGIN
EN_ZM_NOTICE_NULL = 0                   --无效
EN_ZM_NOTICE_Match = 1                  --匹配
EN_ZM_NOTICE_SelectClan = 2             --选掌门
EN_ZM_NOTICE_SelectCard = 3             --选卡
EN_ZM_NOTICE_SelectEquip = 4            --选装备
EN_ZM_NOTICE_AwardCard = 5              --爆卡
EN_ZM_NOTICE_Pvp = 6                    --pvp
EN_ZM_NOTICE_Pve = 7                    --pve
EN_ZM_NOTICE_CardLvUp = 8               --升级
EN_ZM_NOTICE_PanCha = 9                 --盘查技能
EN_ZM_NOTICE_Beg = 10                   --丐帮乞讨
EN_ZM_NOTICE_DecomposeCard = 11         --卡牌分解
EN_ZM_NOTICE_RoundEnd = 12              --大阶段结束
EN_ZM_NOTICE_RoleNum = 13               --32卡选卡数量
EN_ZM_NOTICE_Gold = 10000               --掌门币
EN_ZM_NOTICE_RefreshTimes = 10001       --刷新次数
--to C++ enum [EnZMNotice] Define END

--to C++ enum [EnZMBegType] Define BEGIN
EN_ZM_BEG_NONE = 0                      --空
EN_ZM_BEG_SHENQI = 1                    --神器
EN_ZM_BEG_REFRESHTIMES = 2              --刷新次数
EN_ZM_BEG_LETTAIBI = 3                  --擂台币
--to C++ enum [EnZMBegType] Define END

--to C++ enum [MartialStrongErrorCode] Define BEGIN
ENUM_MSEC_ERROR = 0                     --数据错误
ENUM_MSEC_FAILED = 1                    --强化失败
ENUM_MSEC_SUCCESS = 2                   --强化成功
ENUM_MSEC_SUPER_FAILED = 3              --飞升失败
ENUM_MSEC_SUPER_STRONG = 100            --化境
ENUM_MSEC_SUPER_CLEAR = 101             --入魔
ENUM_MSEC_SUPER_CHANGE = 102            --变异
ENUM_MSEC_SUPER_CHANGESTRONG = 103      --变异化境
ENUM_MSEC_NUMS = 104                    --不能再新加枚举了
--to C++ enum [MartialStrongErrorCode] Define END

--to C++ enum [RoleCardType] Define BEGIN
RCT_ROLE = 0                            --角色卡
RCT_BOND = 1                            --羁绊
--to C++ enum [RoleCardType] Define END

--to C++ enum [QueryResDropActivityType] Define BEGIN
EN_QUERY_RESDROP_ACTIVITY_NULL = 0      --空
EN_QUERY_RESDROP_ACTIVITY_COLLECT = 1   --收集活动
EN_QUERY_RESDROP_ACTIVITY_MULTDROP = 2  --多倍奖励
EN_QUERY_RESDROP_ACTIVITY_NUM = 3       --不能再新加枚举了
--to C++ enum [QueryResDropActivityType] Define END

--to C++ enum [DailyRewardState] Define BEGIN
DRS_NULL = 0                            --未领取
DRS_FREE = 1                            --免费版已领取
DRS_ALL = 2                             --所有已领取
--to C++ enum [DailyRewardState] Define END

--to C++ enum [UnlockStoryNoticeType] Define BEGIN
USNT_NULL = 0                           --空
USNT_SUCCESS = 1                        --成功解锁
USNT_UNLOCKED = 2                       --已经解锁了的剧本
--to C++ enum [UnlockStoryNoticeType] Define END

--to C++ enum [SeActivityOprType] Define BEGIN
SAOT_NULL = 0                           --无
SAOT_EVENT = 1                          --触发事件
SAOT_RECEIVE = 2                        --领取奖励
SAOT_REQUEST = 3                        --请求活动状态
--to C++ enum [SeActivityOprType] Define END

--to C++ enum [SeActivityTriEventType] Define BEGIN
SATET_NULL = 0                          --无
SATET_SHAREFRIEND = 1                   --分享好友
SATET_SIGNIN = 2                        --签到
SATET_REFRESH_EXCHANGE = 3              --秘宝活动-刷新兑换组
SATET_TREASURE_EXCHANGE = 4             --秘宝活动-兑换指定组
SATET_PREEXP_RECEIVE = 5                --体验活动-领取积分奖励
SATET_BACKFLOW_RECEIVE = 6              --回流活动-领取回流奖励
SATET_BACKFLOWPOINT_RECEIVE = 7         --回流活动-领取积分奖励
SATET_FUND_OPEN = 8                     --基金开通
SATET_FUND_RECEIVE = 9                  --基金领取奖励
SATET_FESTIVAL_SIGNIN = 10              --节日活动签到
SATET_FESTIVAL_DIALYTASK_ACHIEVE = 11   --节日活动日常任务奖励领取
SATET_FESTIVAL_LIVENESS_ACHIEVE = 12    --节日活动活跃度奖励领取
SATET_FESTIVAL_ASSET_CLEAN_CHECK = 13   --节日兑换活动资产值清理检查
SATET_FESTIVAL_EXCHANGE = 14            --节日活动兑换奖励
SATET_FESTIVAL_BUY_MALL = 15            --节日活动商店购买
--to C++ enum [SeActivityTriEventType] Define END

--to C++ enum [SeMonitorType] Define BEGIN
Monitor_Daily_JinMai = 0                --单日获得经脉异常
Monitor_Daily_Gold = 1                  --单日消费金锭异常
Monitor_Daily_Slave = 2                 --单日消费银锭异常
Monitor_Daily_Slave_Get = 3             --单日获取银锭异常
Monitor_Daily_XiaoXiaKe = 4             --单日消耗小侠客异常
Monitor_Daily_HongBao = 5               --单日红包发送异常
Monitor_Daily_TongGuanZiYou = 6         --单日通关魔君剧本异常
Monitor_Daily_TongGuanMoJun = 7         --单日通关自由模式异常
Monitor_Daily_Chat = 8                  --单日聊天异常
--to C++ enum [SeMonitorType] Define END

--to C++ enum [ScriptOprRetType] Define BEGIN
SORT_FAILED = 0                         --操作失败
SORT_SUCCESS = 1                        --操作成功
SORT_UNAVALIABLE = 2                    --操作剧本维护中
SORT_DELSCRIPTLIMIT = 3                 --每日删除剧本数量限制
--to C++ enum [ScriptOprRetType] Define END

--to C++ enum [PlayerCanOpenTreasureType] Define BEGIN
PCOTT_NULL = 0
PCOTT_YES = 1
PCOTT_NO = 2
--to C++ enum [PlayerCanOpenTreasureType] Define END

--to C++ enum [RolePetCardReqType] Define BEGIN
RPCRT_NULL = 0
RPCRT_ROLE_CARD = 1                     --角色卡
RPCRT_PET_CARD = 2                      --宠物卡
RPCRT_ROLE_BOND = 3                     --角色羁绊
RPCRT_ALL = 4                           --全部
RPCRT_END = 5
--to C++ enum [RolePetCardReqType] Define END

--to C++ enum [RolePetCardOptType] Define BEGIN
RPCOT_NULL = 0
RPCOT_REQ_DATA = 1                      --请求数据
RPCOT_LEVEL_UP_ROLE_CARD = 2            --升级角色卡
RPCOT_LEVEL_UP_PET_CARD = 3             --升级宠物卡
RPCOT_EVOLVE_PET_CARD = 4               --进化宠物卡
RPCOT_SET_USE_PET_CARD = 5              --更新使用中宠物卡
RPCOT_SET_PLAT_SHOW_PET_CARD = 6        --更新平台展示宠物卡
RPCOT_LEVEL_UP_ROLE_BOND = 7            --升级羁绊
RPCOT_END = 8
--to C++ enum [RolePetCardOptType] Define END

--to C++ enum [SystemModule] Define BEGIN
SM_NULL = 0
SM_ROLE_CARD = 1                        --角色卡
SM_PET_CARD = 2                         --宠物卡
SM_ITEM_ENHANCE = 3                     --物品强化
SM_ITEM_SMELT = 4                       --物品熔炼
SM_ITEM_RECAST = 5                      --物品重铸
SM_TREASURE_MAP = 6                     --藏宝图
SM_ROLEFACE = 7                         --捏脸功能
SM_END = 8
--to C++ enum [SystemModule] Define END

--to C++ enum [SeSaveFileReqType] Define BEGIN
SSFRT_NEW_FILE = 0                      --新建存档
SSFRT_SAVE_FILE = 1                     --覆盖存档
SSFRT_LOAD_FILE = 2                     --加载存档
SSFRT_DELETE_FILE = 3                   --删除存档
SSFRT_OPEN_SAVE_FILE = 4                --自动存档开关
--to C++ enum [SeSaveFileReqType] Define END


-- 物品
CommonTable_SeSimpleItem =
{
['uiItemID'] = 0,
['uiItemNum'] = 0,
}

-- 玩家上传的被举报人信息
CommonTable_SePlayerReportOprInfo =
{
['defReportPlayerID'] = 0,
['acReportType'] = 'nil',
['acReportDesc'] = 'nil',
['acReportContent'] = 'nil',
['dwReportScene'] = 0,
['dwReportEntrance'] = 1,
['acPicUrl'] = 'nil',
}

-- 安全日志被举报人信息
CommonTable_SeTssSecReportPlayerInfo =
{
['dwPlatID'] = 0,
['dwAreaID'] = 0,
['dwZoneID'] = 0,
['acGoOpenID'] = 'nil',
['acVOpenID'] = 'nil',
['acIP'] = 'nil',
['dwRegTime'] = 0,
['acReportName'] = 'nil',
}

-- 游戏app参数
CommonTable_SeGameAppParam =
{
['acGameAppID_QQ'] = '1108328494',
['acGameAppID_WX'] = 'wx398d0e3e595d8823',
['acGameAppKey_QQ'] = 'Tu82FBUEZg6nZRzF',
['acGameAppKey_WX'] = '742607a8857a70f5be13e29796f337e1',
}

-- 客户端上传参数
CommonTable_SeClientMobilePhoneInfo =
{
['acClientVersion'] = 'NULL',
['acSystemSoftware'] = 'NULL',
['acSystemHardware'] = 'NULL',
['acTelecomOper'] = 'NULL',
['iScreenWidth'] = 0,
['iScreenHight'] = 0,
['acNetwork'] = 'NULL',
['acDensity'] = '0',
['iRegChannel'] = 0,
['acCpuHardware'] = 'NULL',
['iMemory'] = 0,
['acGLRender'] = 'NULL',
['acGLVersion'] = 'NULL',
['acDeviceId'] = 'NULL',
['acAndroidId'] = 'NULL',
['acRealIMEI'] = 'NULL',
['acIdfv'] = 'NULL',
['dwPlatID'] = 0,
['iTssSDKLen'] = 0,
['acSecTssSDK'] = 'nil',
['acVOpenID'] = 'nil',
['acGOpenId'] = 'nil',
['iClientLoginMethod'] = 0,
['iTencentPrivate'] = 0,
['acPF'] = 'nil',
['acPFKey'] = 'nil',
['acOpenKey'] = 'nil',
['isGuest'] = false,
['dwOS'] = 0,
['iLoginChannel'] = '0',
}

-- 玩家上报信息缓存用
CommonTable_SePlayerOtherInfo =
{
['acPF'] = 'nil',
['acPFKey'] = 'nil',
['acOpenKey'] = 'nil',
['acUserIP'] = 'nil',
['acOpenId'] = 'nil',
['dwPlatID'] = 0,
['acServerAlias'] = 'nil',
['isGuest'] = false,
}

-- 禁用信息
CommonTable_SeForBidInfo =
{
['eSeForBidType'] = SFBT_NULL,
['dwBegineTime'] = 0,
['iTime'] = 0,
['acReason'] = 'nil',
}

-- 开关信息
CommonTable_SeSystemSwitchInfo =
{
['bOpen'] = false,
['eSwitch'] = SGLST_NONE,
}

-- 百宝书基础信息
CommonTable_TreasureBookBaseInfo =
{
['dwExp'] = 0,
['dwLvl'] = 0,
['dwMoney'] = 0,
['bRMBPlayer'] = false,
['bAdvancePurchase'] = false,
['bOpenRepeatTask'] = false,
['dwCurPeriods'] = 1,
['dwCurPeriodsWeek'] = 1,
['dwHeroCanGetExtraRewardTaskNum'] = 0,
['dwRMBCanGetExtraRewardTaskNum'] = 0,
['dwCurMaxGetDailySilverNum'] = 1,
['bOpenDailyGift'] = false,
['bEachDayGift'] = false,
['bEachWeekGift'] = false,
['dwProgressRewardFlag'] = 0,
['dwRMBProgressRewardFlag'] = 0,
['dwLvlRewardFlag1'] = 0,
['dwLvlRewardFlag2'] = 0,
['dwRMBLvlRewardFlag1'] = 0,
['dwRMBLvlRewardFlag2'] = 0,
['dwGivedFriendAdvanceNum'] = 0,
['dwPurchaseBookEndTime'] = 0,
['dwExtraGetRewardLvl'] = 0,
}

-- 百宝书任务信息
CommonTable_SeTreasureBookTaskInfo =
{
['dwTaskTypeID'] = 0,
['dwProgress'] = 0,
['bReward'] = false,
['bCanReward'] = false,
['dwRepeatFinishNum'] = 0,
}

-- 百宝书商城信息
CommonTable_SeTreasureBookMallInfo =
{
['dwItemTypeID'] = 0,
['dwExchangedNum'] = 0,
}

-- 礼包打开结果信息
CommonTable_SeGiftBagResultInfo =
{
['dwItemTypeID'] = 0,
['dwItemUID'] = 0,
['dwNum'] = 0,
}

-- 弹珠槽掉落提示信息
CommonTable_SeHoodleSlotDropTipsInfo =
{
['dwCurCDropBaseID'] = 0,
['dwCurDropItemID'] = 0,
['dwCurDropItemNum'] = 0,
['dwCurRewardItemID'] = 0,
['dwCurRewardItemNum'] = 0,
}

-- 弹珠进度箱基本信息
CommonTable_SeHoodleProgressInfo =
{
['eProgressType'] = SHBPT_NULL,
['dwCurProgress'] = 0,
['kProgressTip'] = nil,
['ePrivacyType'] = SHPCT_NULL,
['dwTotalHPNum'] = 0,
['dwPoolID'] = 0,
['bHide'] = false,
}

-- 弹珠槽基本信息
CommonTable_SeHoodleSlotInfo =
{
['dwSlotIndex'] = 0,
['kSlotTip'] = nil,
}

-- 侠客行抽奖返回信息
CommonTable_SeHoodlePlayerRetInfo =
{
['bSpecialHoodle'] = false,
['dwSpecialSlotProgress'] = 0,
['kHitSlotInfo'] = nil,
['akBoxInfo'] = nil,
}

-- 弹珠奖池基本信息
CommonTable_SeHoodleLotteryBaseInfo =
{
['bOpen'] = false,
['dwSpecialSlotProgress'] = 0,
['dwCurPoolHoodleNum'] = 0,
['dwCurPoolFreeHoodleNum'] = 0,
['dwCurPoolDailyFreeHoodleNum'] = 0,
['dwAccForTenShootNum'] = 0,
['akProgressInfo'] = nil,
['akSlotInfo'] = nil,
}

-- 侠客行个人奖池信息
CommonTable_SeHoodlePrivacyInfo =
{
['dwCurHoodlePrivacyID'] = 0,
['dwBeginTimeStamp'] = 0,
['dwEndTimeStamp'] = 0,
['dwTotalNormalNum'] = 0,
['dwCurResetNum'] = 0,
['bResetReFresh'] = false,
['akChivalrousInfo'] = nil,
}

-- 平台玩家的简易信息
CommonTable_SePlatPlayerSimpleInfo =
{
['defPlyID'] = 0,
['dwModelID'] = 0,
['acPlayerName'] = 'nil',
['bUnlockHouse'] = false,
['bRMBPlayer'] = false,
['charPicUrl'] = 'nil',
['dwTitleID'] = 0,
['dwPetID'] = 0,
['dwHeadBoxID'] = 0,
}

-- 剧本内玩家的在线信息
CommonTable_SePlayerInScriptData =
{
['dwPlayerID'] = 0,
['acPlayerName'] = 'nil',
['dwSex'] = 0,
['dwWeekRoundTotalNum'] = 0,
['dwALiveDays'] = 0,
['bUnlockHouse'] = false,
['dwAchievePoint'] = 0,
['dwMeridiansLvl'] = 0,
['dwCreateTime'] = 0,
['dwLastLogoutTime'] = 0,
['dwChallengeWinTimes'] = 0,
['bRMBPlayer'] = false,
['acOpenID'] = 'nil',
['acVOpenID'] = 'nil',
['acIP'] = 'nil',
['dwHoodleScore'] = 0,
['dwNormalHighTowerMaxNum'] = 0,
['dwBloodHighTowerMaxNum'] = 0,
['dwRegimentHighTowerMaxNum'] = 0,
['dwTitleID'] = 0,
['dwPaintingID'] = 0,
['dwModelID'] = 0,
['charPicUrl'] = 'nil',
['dwBackGroundID'] = 0,
['dwBGMID'] = 0,
['dwPoetryID'] = 0,
['dwPedestalID'] = 0,
['dwShowRoleID'] = 0,
['dwShowPetID'] = 0,
['dwLoginWordID'] = 0,
['dwHeadBoxID'] = 0,
}

-- 门派信息结构
CommonTable_SeClanCollectionInfo =
{
['dwType'] = 0,
['dwNum'] = 0,
}

-- 奇经八脉请求与下发结构
CommonTable_SeMeridiansInfo =
{
['dwMeridianID'] = 0,
['dwAcupointID'] = 0,
['dwLevel'] = 0,
}

-- 金锭操作
CommonTable_SeGoldOprParam =
{
['defPlayerID'] = 0,
['eOprType'] = MOT_NULL,
['dwMoneyValue'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
['iParam4'] = 0,
['acBillNo'] = 'nil',
['acJson'] = 'nil',
['sysInfo'] = nil,
}

-- 金锭操作返回
CommonTable_SeGoldOprRetParam =
{
['defPlayerID'] = 0,
['eOPType'] = MOT_NULL,
['iNowValue'] = 0,
['iCostValue'] = 0,
['iSuccess'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
['iParam4'] = 0,
['acJson'] = 'nil',
['acBillNo'] = 'nil',
['isDebug'] = false,
}

-- 金锭查询返回
CommonTable_SeQueryGoldRetParam =
{
['defPlayerID'] = 0,
['iCurGold'] = 0,
['iAmtGold'] = 0,
['iCostGold'] = 0,
['iPresentGold'] = 0,
['iLeftPresentGold'] = 0,
['isDebug'] = false,
['ret'] = 0,
}

-- 私聊信息
CommonTable_SePrivateTalkInfo =
{
['defPlyID'] = 0,
['acSessionID'] = 'nil',
['acOpenID'] = 'nil',
['acVOpenID'] = 'nil',
}

CommonTable_SePtlNetAddr =
{
['acHost'] = 'nil',
['acIP'] = 'nil',
['iPort'] = 0,
}

-- 版本检查
CommonTable_SeCheckVersion =
{
['byMain'] = 1,
['bySub1'] = 0,
['bySub2'] = 0,
['bySub3'] = 23,
}

CommonTable_SePublicValuePair =
{
['acName'] = 'nil',
['iValue'] = 0,
['eOprType'] = SPVOT_INC,
}

CommonTable_SeFriendShareData =
{
['defFriendID'] = 0,
['iValue'] = 0,
['acName'] = 'nil',
}

-- 邮件领取结果
CommonTable_SeMailReceiveReason =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
['eReason'] = SMRRT_SUC,
}

-- 邮件领取返回
CommonTable_SeMailReceiveResult =
{
['bOpr'] = false,
['dwlMailID'] = 0,
['iNum'] = 0,
['akRetReason'] = nil,
}

-- 邮件过滤
CommonTable_SeMailFilter =
{
['eMailType'] = SMFT_END,
['acMin'] = 'nil',
['acMax'] = 'nil',
}

-- 邮件物品
CommonTable_SeMailItem =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
}

-- 邮件信息
CommonTable_SeSimpleMailInfo =
{
['defFromID'] = 0,
['dwlMailID'] = 0,
['eMailType'] = SMAT_NULL,
['dwlMailTime'] = 0,
['akAttachItem'] = nil,
}

-- 邮件信息
CommonTable_SeMailInfo =
{
['dwlMailID'] = 0,
['dwlMailTime'] = 0,
['acUserID'] = 'nil',
['acReceiver'] = 'nil',
['acTitle'] = 'nil',
['acContent'] = 'nil',
['eMailType'] = SMAT_NULL,
['akAttachItem'] = nil,
}

-- GM邮件信息
CommonTable_SeGMMailInfo =
{
['acArriveTime'] = 'nil',
['kMailInfo'] = nil,
['iFilterNum'] = 0,
['akMailFilter'] = nil,
}

-- 解锁内容
CommonTable_SeUnlockInfo =
{
['dwTypeID'] = 0,
['dwParam'] = 0,
}

-- 残章匣内容
CommonTable_SeInCompleteBookRecord =
{
['dwTypeID'] = 0,
['dwDreamLandTime'] = 0,
['dwArriveMaxLvl'] = 0,
['dwAddInCompleteBookNum'] = 0,
['dwAddInCompleteTextNum'] = 0,
}

-- 布阵武学
CommonTable_SeEmBattleMartialInfo =
{
['dwUID'] = 0,
['dwTypeID'] = 0,
['dwIndex'] = 0,
}

-- 带入特殊数据
CommonTable_SeCarrySpecialData =
{
['eType'] = nil,
['iNum1'] = 0,
['iNum2'] = 0,
['iNum3'] = false,
}

-- 选择选项指令表现使用
CommonTable_SeGameCmd_SelectOption_Content =
{
['acContent'] = 'nil',
}

CommonTable_SePlayerScriptInfo =
{
['dwScriptID'] = 0,
['dwScriptTime'] = 0,
['acMainRoleName'] = 'nil',
['dwDreamLandTime'] = 0,
['eStateType'] = SSS_NULL,
['dwUnlockMaxDiff'] = 0,
['dwWeekRoundNum'] = 0,
['dwScriptLucyValue'] = 0,
['bGotFirstReward'] = false,
}

-- 通知成就数据
CommonTable_NoticeUnlockAchieveInfo =
{
['uiAchieveID'] = 0,
['iCurNum'] = 0,
}

-- 成就记录数据
CommonTable_AchieveSaveData =
{
['uiAchieveID'] = 0,
['iValue'] = 0,
['iFetchReward'] = 0,
}

-- 全局难度掉落控制
CommonTable_DiffDropData =
{
['uiTypeID'] = 0,
['uiAccumulateTime'] = 0,
['uiRoundFinish'] = 0,
}

-- 小侠客参与的玩家
CommonTable_SeHoodlePlayer =
{
['defPlayerId'] = 0,
['acPlayerName'] = 'nil',
['uiPrecessValue'] = 0,
['dwServerID'] = 0,
}

-- 全服小侠客信息
CommonTable_SeHoodLeLottery =
{
['uiOpenId'] = 0,
['uiTurns'] = 0,
['uiTotal'] = 0,
['uiNeedTotal'] = 0,
['uiBeginTime'] = 0,
['bResult'] = false,
['bOpen'] = false,
['bUseUp'] = false,
['uiPlayerNum'] = 0,
['akHoodlePlayer'] = nil,
['uiPersonalNum'] = 0,
['akPersonalProc'] = nil,
}

-- 全服小侠客领取记录
CommonTable_SeHoodLeRecord =
{
['uiRecordTime'] = 0,
['defPlayerId'] = 0,
['uiItemId'] = 0,
['acPlayerName'] = 'nil',
['bMaxCont'] = false,
}

-- 全服小侠客配置
CommonTable_SeHoodLePublicConfig =
{
['uiTotal'] = 0,
['iPlayerWeight'] = 0,
['uiBoundary'] = 0,
['iDayStartAuto'] = 0,
['iDayFinishAuto'] = 0,
['iNightStartAuto'] = 0,
['iNightFinishAuto'] = 0,
['acDaytimeDefine'] = 'nil',
}

-- 全服小侠客当前活动物品信息
CommonTable_SeHoodLePublicItemInfo =
{
['uiItemID'] = 0,
['uiCurNum'] = 0,
['uiTotalNum'] = 0,
['uiShowTotalNum'] = 0,
['bTopReward'] = false,
}

-- 全服小侠客兑换数据
CommonTable_SeHoodLeExChageData =
{
['uiItemId'] = 0,
['uiPrice'] = 0,
}

-- 全服小侠客配置信息
CommonTable_SeHoodLePublicData =
{
['uiBeginTime'] = 0,
['uiEndTime'] = 0,
['acResource'] = 'nil',
['iNum'] = 0,
['akAllItem'] = nil,
['iNum2'] = 0,
['akExchange'] = nil,
['iNum3'] = 0,
['akShowItem'] = nil,
}

-- GS缓存玩家信息配置
CommonTable_SeGsCachePlayerInfoConfig =
{
['bCacheSePlayerInfo'] = 0,
['iCacheSePlayerInfoNum'] = 0,
['iCacheSePlayerInfoTime'] = 0,
}

-- GS返回缓存玩家信息并执行操作时所需要转发的信息
CommonTable_SeRetPlayerInfoOptData =
{
['eOptType'] = PSIOT_NULL,
['iCachePageIndex'] = 0,
['iCachePageStartIndexOffset'] = 0,
['iGetCount'] = 0,
}

-- 打赏记录
CommonTable_SeRewardRecord =
{
['defPlayerId'] = 0,
['acPlayerName'] = 'nil',
['iRewardValue'] = 0,
}

-- 属性
CommonTable_RoleAttrData =
{
['uiAttrUID'] = 0,
['uiType'] = 0,
['iBaseValue'] = 0,
['iExtraValue'] = 0,
['uiRecastType'] = 0,
}

-- 垃圾
CommonTable_SeAdvLoot =
{
['uiID'] = 0,
['uiSiteType'] = 0,
['uiSiteID'] = 0,
['uiAdvLootID'] = 0,
['uiAdvLootType'] = 0,
['uiNum'] = 0,
}

-- 拾取冒险掉落上行数据
CommonTable_PickUpAdvLootData =
{
['uiSite'] = 0,
['uiMID'] = 0,
['uiAreaID'] = 0,
['uiAdvLootID'] = 0,
['uiDynamicAdvLootID'] = 0,
}

-- 角色物品
CommonTable_RoleItem =
{
['iValueChangeFlag'] = 0,
['uiID'] = 0,
['uiTypeID'] = 0,
['uiItemNum'] = 0,
['uiDueTime'] = 0,
['uiEnhanceGrade'] = 0,
['uiCoinRemainRecastTimes'] = 0,
['iAttrNum'] = 0,
['auiAttrData'] = nil,
['uiOwnerID'] = 0,
['bBelongToMainRole'] = 0,
['uiSpendIron'] = 0,
['uiPerfectPower'] = 0,
['uiSpendTongLingYu'] = 0,
}

-- 解锁项目
CommonTable_UnLockItem =
{
['uiUnLockType'] = 0,
['uiUnLockID'] = 0,
['uiUnLockNum'] = 0,
}

-- 角色属性
CommonTable_RoleAttrDef =
{
['uiType'] = 0,
['iValue'] = 0,
['iBaseValue'] = 0,
}

-- 武学属性
CommonTable_MartialAttr =
{
['uiType'] = 0,
['iValue'] = 0,
}

-- 武学影响
CommonTable_MartialInfluence =
{
['uiAttrType'] = 0,
['uiMartialTypeID'] = 0,
['uiMartialValue'] = 0,
['uiMartialInit'] = 0,
}

-- 角色武学
CommonTable_RoleMartial =
{
['iValueChangeFlag'] = 0,
['uiID'] = 0,
['uiRoleUID'] = 0,
['uiTypeID'] = 0,
['uiLevel'] = 0,
['uiExp'] = 0,
['uiExtExpApp'] = 0,
['uiMaxLevel'] = 0,
['iMartialAttrSize'] = 0,
['akMartialAttrs'] = nil,
['iMartialUnlockItemSize'] = 0,
['auiMartialUnlockItems'] = nil,
['iMartialInfluenceSize'] = 0,
['akMartialInfluences'] = nil,
['iMartialUnlockSkillSize'] = 0,
['auiMartialUnlockSkills'] = nil,
['iStrongLevel'] = 0,
['iStrongCount'] = -1,
['uiAttr1'] = 0,
['uiAttr2'] = 0,
['uiAttr3'] = 0,
['uiColdTime'] = 0,
}

-- 角色天赋
CommonTable_RoleGift =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiGiftSourceType'] = 0,
['bIsGrowUp'] = 0,
}

-- 角色星愿
CommonTable_RoleWishTask =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiState'] = 0,
['uiReward'] = 0,
['uiRoleCard'] = 0,
['bFirstGet'] = 0,
}

-- 好感度结构
CommonTable_RoleDisposition =
{
['iNums'] = 0,
['uiFromTypeID'] = 0,
['auiToTypeIDList'] = nil,
['aiValueList'] = nil,
}

-- 创角角色数据
CommonTable_CreateRoleAttrData =
{
['uiAttrType'] = 0,
['iAttrValue'] = 0,
}

-- 创角角色数据
CommonTable_CreateMainRole =
{
['uiTypeID'] = 0,
['uiChild'] = 0,
['uiRank'] = 0,
['uiAttrCount'] = 0,
['akAttrs'] = nil,
['uiGifts'] = 0,
['uiUnlock'] = 0,
}

-- 创角角色数据
CommonTable_CreateBabyRole =
{
['uiTypeID'] = 0,
['uiBabyStateID'] = 0,
['uiChild'] = 0,
['uiAttrCount'] = 0,
['akAttrs'] = nil,
['uiGifts'] = 0,
['uiUnlock'] = 0,
}

-- 随机城市移动NPC信息数据
CommonTable_RandomCityMoveNpcInfo =
{
['uiRoleID'] = 0,
['uiSrcCityID'] = 0,
['uiDstCityID'] = 0,
['uiDstMapID'] = 0,
}

-- 下行角色协议
CommonTable_SeGameCmd_DisplayRoleInfo =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiLevel'] = 0,
['uiStrengthenLv'] = 0,
['uiHP'] = 0,
['uiMP'] = 0,
['uiRemainPoint'] = 0,
['uiFragment'] = 0,
['uiOverlayLevel'] = 0,
['aiAttrs'] = nil,
['iItemNum'] = 0,
['auiRoleItem'] = 0,
['auiEquipItem'] = 0,
}

-- 徒儿信息
CommonTable_BabyStateInfo =
{
['uiStateID'] = 0,
['uiBabyID'] = 0,
['uiFatherID'] = 0,
['uiMotherID'] = 0,
['uiBirthday'] = 0,
['uiState'] = 0,
['uiNextLearnTime'] = 0,
['acPlayerName'] = 'nil',
['uiMasterNum'] = 0,
['auiMasters'] = nil,
}

-- 地图数据
CommonTable_MapData =
{
['iRoleCount'] = 0,
['auiRoleIDs'] = 0,
['uiNameID'] = 0,
['sBuildingImg'] = 'nil',
['uiBuildingType'] = 0,
['bCanShow'] = nil,
['bCanReturn'] = nil,
}

-- 迷宫地形格数据
CommonTable_MazeGridData =
{
['uiID'] = 0,
['uiRow'] = 0,
['uiColumn'] = 0,
['eFirstType'] = 0,
['eSecondType'] = 0,
['uiCardID'] = 0,
['uiBaseCardTypeID'] = 0,
['bCanReplace'] = 0,
['bHasTriggered'] = 0,
['bHasExplored'] = 0,
['bIsUnlock'] = 0,
['uiEventRoleID'] = 0,
}

-- 迷宫区域数据
CommonTable_MazeAreaData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['iMazeGridCount'] = 0,
['auiMazeGridIDs'] = nil,
['uiTemplateTerrainID'] = 0,
}

CommonTable_SeMaze_Buff =
{
['iBuffTypeID'] = 0,
['iLayer'] = 0,
}

-- 迷宫数据
CommonTable_MazeData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiCurAreaIndex'] = 0,
['uiCurPosRow'] = 0,
['uiCurPosColumn'] = 0,
['iBuffCount'] = 0,
['auiBuffIDs'] = nil,
['iAreaCount'] = 0,
['auiAreaIDs'] = nil,
}

-- 迷宫卡片物件数据
CommonTable_MazeCardItemData =
{
['uiNameID'] = 0,
['uiModelID'] = 0,
}

-- 迷宫卡片数据
CommonTable_MazeCardData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiNameID'] = 0,
['uiArtSettingID'] = 0,
['uiNeverAutoMove'] = 0,
['uiNeverAutoTrigger'] = 0,
['uiPlotID'] = 0,
['uiRoleID'] = nil,
['kCardItem'] = nil,
['uiUnlockGiftType'] = nil,
['uiUnlockGiftLevel'] = nil,
['uiClickAudio'] = nil,
['uiCardType'] = nil,
['uiCardSecondType'] = nil,
['uiNeedResetTreasure'] = nil,
['uiTaskID'] = nil,
}

-- 迷宫动态掉落数据
CommonTable_DynamicAdvLoot =
{
['uiID'] = 0,
['uiDataTypeID'] = 0,
['uiAdvLootType'] = 0,
['uiNum'] = 0,
}

-- NPC演化数据
CommonTable_NpcEvolutionData =
{
['iValueChangeFlag'] = 0,
['uiNpcID'] = 0,
['uiID'] = 0,
['uiType'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
}

-- 演化记录
CommonTable_EvolutionRecord =
{
['iValueChangeFlag'] = 0,
['uiID'] = 0,
['uiBaseID'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iParam3'] = 0,
['iParam4'] = 0,
['uiCityID'] = 0,
['iTime'] = 0,
}

-- 完成剧情数据
CommonTable_StoryItem =
{
['uiEnumType'] = 0,
['uiCompleteNum'] = 0,
}

-- 奖励
CommonTable_AwardItem =
{
['uiRewardType'] = 0,
['uiBaseID'] = 0,
['uiNum'] = 0,
}

-- 奖励
CommonTable_ScriptEndItem =
{
['uiScriptEndType'] = 0,
['uiNum'] = 0,
}

-- NPC角色数据
CommonTable_NpcData =
{
['uiTypeID'] = 0,
['uiIndex'] = 0,
['iGoodEvil'] = 0,
['uiStaticItemsFlag'] = 0,
['uiStaticEquipsFlag'] = 0,
}

-- 玩家基本数据
CommonTable_SePlayerCommonInfo =
{
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwModelID'] = 0,
['dwSex'] = 0,
['dwWeekRoundTotalNum'] = 0,
['dwALiveDays'] = 0,
['bUnlockHouse'] = false,
['dwAchievePoint'] = 0,
['dwMeridiansLvl'] = 0,
['dwCreateTime'] = 0,
['dwLastLogoutTime'] = 0,
['dwChallengeWinTimes'] = 0,
['bRMBPlayer'] = false,
['dwTitleID'] = 0,
['acOpenID'] = 'nil',
['acVOpenID'] = 'nil',
['acIP'] = 'nil',
['dwHoodleScore'] = 0,
['dwNormalHighTowerMaxNum'] = 0,
['dwBloodHighTowerMaxNum'] = 0,
['dwRegimentHighTowerMaxNum'] = 0,
['dwPlayerLastScriptID'] = 0,
['dwNewBirdGuideState'] = 0,
}

-- 玩家功能数据
CommonTable_SePlayerFunctionInfo =
{
['dwLowInCompleteTextNum'] = 0,
['dwMidInCompleteTextNum'] = 0,
['dwHighInCompleteTextNum'] = 0,
['dwMeridianTotalLvl'] = 0,
['dwAchieveTotalNum'] = 0,
['dwLuckyValue'] = 0,
['dwChallengeWinTimes'] = 0,
['dwJingTieNum'] = 0,
['dwTianGongChui'] = 0,
['dwPerfectFenNum'] = 0,
['dwWangYouCaoNum'] = 0,
['dwHoodleBallNum'] = 0,
['dwRefreshBallNum'] = 0,
['dwDilatationNum'] = 0,
['dwLimitShopBigmapAciton'] = 0,
['dwFreeGiveBigCoin'] = 0,
['dwShopGoldRewardTime'] = 0,
['dwShopAdRewardTime'] = 0,
['dwBondPelletNum'] = 0,
['dwDailyRewardState'] = 0,
['dwFundAchieveOpen'] = 0,
['dwRedPacketGetTimes'] = 0,
['dwResDropActivityFuncValue1'] = 0,
['dwResDropActivityFuncValue2'] = 0,
['dwResDropActivityFuncValue3'] = 0,
['dwResDropActivityFuncValue4'] = 0,
['dwResDropActivityFuncValue5'] = 0,
['dwCurResDropCollectActivity'] = 0,
['dwZmFreeTickets'] = 0,
['dwZmTickets'] = 0,
['bZmNewFlag'] = 0,
['dwTreaSureExchangeValue1'] = 0,
['dwTreaSureExchangeValue2'] = 0,
['dwFestivalValue1'] = 0,
['dwFestivalValue2'] = 0,
['dwTongLingYu'] = 0,
}

-- 玩家形象数据
CommonTable_SePlayerAppearanceInfo =
{
['acPlayerName'] = 'nil',
['dwTitleID'] = 0,
['dwPaintingID'] = 0,
['dwModelID'] = 0,
['charPicUrl'] = 'nil',
['dwBackGroundID'] = 0,
['dwBGMID'] = 0,
['dwPoetryID'] = 0,
['dwPedestalID'] = 0,
['dwShowRoleID'] = 0,
['dwShowPetID'] = 0,
['dwLoginWordID'] = 0,
['dwHeadBoxID'] = 0,
['dwChatBoxID'] = 0,
['dwLandLadyID'] = 0,
}

-- 好友壕侠月卡
CommonTable_SeQueryFriendRMBFlagResult =
{
['defPlayerID'] = 0,
['bRMBPlayer'] = false,
['bAdvancePurchase'] = false,
}

-- 好友/好友属性更新
CommonTable_SePlayerAttriUpdate =
{
['acKey'] = 'nil',
['acValue'] = 'nil',
}

-- 好友基本数据
CommonTable_SeFriendCommonInfo =
{
['defFriendID'] = 0,
['acFriendName'] = 'nil',
['charPicUrl'] = 'nil',
['acOpenID'] = 'nil',
['dwSex'] = 0,
['dwTitleID'] = 0,
['dwModelID'] = 0,
['dwAchievePoint'] = 0,
['dwMeridiansLvl'] = 0,
['dwLogoutTime'] = 0,
['bRMBPlayer'] = false,
['bAdvancePurchase'] = false,
['acVOpenID'] = 'nil',
}

-- 任务标识
CommonTable_TaskTagData =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiValue'] = 0,
}

-- 任务描述状态
CommonTable_TaskDescState =
{
['uiDescID'] = 0,
['uiDescState'] = 0,
['auiDescProcess'] = nil,
}

CommonTable_SePlayerCheat =
{
['acParam'] = 'nil',
}

-- 商品交互物品
CommonTable_ShopItem =
{
['uiShopItemID'] = nil,
['uiNum'] = nil,
['uiPrice'] = nil,
}

-- 城市事件
CommonTable_CityEvent =
{
['uiPos'] = nil,
['uiType'] = nil,
['uiTag'] = nil,
['uiEx'] = nil,
['uiTask'] = nil,
}

-- 城市数据
CommonTable_CityData =
{
['uiCityID'] = 0,
['uiWeatherID'] = 0,
['uiState'] = 0,
['iNum'] = 0,
['akCityEvents'] = nil,
['iCityDispo'] = 0,
['uiTimerCount'] = 0,
['auiTimers'] = nil,
}

-- 宠物数据
CommonTable_PetData =
{
['uiBaseID'] = 0,
['uiFragment'] = 0,
}

-- 昵称数据
CommonTable_NickNameData =
{
['uiNpcID'] = 0,
['acName'] = 'nil',
}

CommonTable_SeBattle_GameEndAward =
{
['iValueChangeFlag'] = 0,
['uiItemID'] = 0,
['uiNums'] = 0,
['eType'] = 0,
}

CommonTable_SeBattle_GameEnd =
{
['iValueChangeFlag'] = 0,
['iTypeID'] = 0,
['iEndScore'] = 0,
['eFlag'] = 0,
['iScoreNum'] = 0,
['uiTeamExp'] = 0,
['uiMartialExp'] = 0,
['uiResultAddExp'] = 0,
['uiLevelAddExp'] = 0,
['aiScoreType'] = nil,
['aiScoreCount'] = nil,
['aiScore'] = nil,
['iAwardNum'] = 0,
['asAward'] = nil,
}

CommonTable_SeBattle_BattleMartial =
{
['uiMartialIndex'] = 0,
['uiMartialID'] = 0,
['uiMartialItemID'] = 0,
['uiMartialLevel'] = 0,
['uiRangeLevel'] = 0,
['uiDamageValue'] = 0,
['uiPower'] = 0,
['uiPowerBase'] = 0,
['uiPowerPercent'] = 0,
['uiCostMP'] = 0,
['eStateFalg'] = 0,
['uiSkillEvolution'] = 0,
['eParamInfo'] = 0,
['uiColdTime'] = 0,
['uiRoleUID'] = 0,
}

CommonTable_SeGameCmd_BuffDesc =
{
['iBuffIndex'] = 0,
['iDescLangID'] = 0,
['iParam1'] = 0,
['iParam2'] = 0,
['iDescType'] = 0,
}

CommonTable_SeGameCmd_UpdateRound =
{
['iRoundNum'] = 0,
}

CommonTable_SeBattle_Buff =
{
['iBuffIndex'] = 0,
['iBuffTypeID'] = 0,
['iLayerNum'] = 0,
['iRoundNum'] = 0,
}

CommonTable_SeBattle_UnitNpcEquip =
{
['iInstID'] = 0,
['iTypeID'] = 0,
['iEnhanceGrade'] = 0,
}

CommonTable_SeBattle_ComboRecord =
{
['uiComboID'] = 0,
['iCount'] = 0,
}

-- 捏脸角色
CommonTable_RoleFaceData =
{
['uiHat'] = 0,
['uiBack'] = 0,
['uiHairBack'] = 0,
['uiBody'] = 0,
['uiFace'] = 0,
['uiEyebrow'] = 0,
['uiEye'] = 0,
['uiMouth'] = 0,
['uiNose'] = 0,
['uiForeheadAdornment'] = 0,
['uiFacialAdornment'] = 0,
['uiHairFront'] = 0,
['iEyebrowWidth'] = 0,
['iEyebrowHeight'] = 0,
['iEyebrowLocation'] = 0,
['iEyeWidth'] = 0,
['iEyeHeight'] = 0,
['iEyeLocation'] = 0,
['iNoseWidth'] = 0,
['iNoseHeight'] = 0,
['iNoseLocation'] = 0,
['iMouthWidth'] = 0,
['iMouthHeight'] = 0,
['iMouthLocation'] = 0,
['uiModelID'] = 0,
['uiSex'] = 0,
['uiCGSex'] = 0,
['uiRoleID'] = 0,
}

CommonTable_SeGameCmd_BattleUnitCreate =
{
['iValueChangeFlag'] = 0,
['uiUnitIndex'] = 0,
['iGridX'] = 0,
['iGridY'] = 0,
['iMP'] = 0,
['iHP'] = 0,
['iMAXMP'] = 0,
['iMAXHP'] = 0,
['uiRoleID'] = 0,
['uiTypeID'] = 0,
['uiModleID'] = 0,
['uiNameID'] = 0,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['iAssistFlag'] = 0,
['iFace'] = 1,
['eCamp'] = SE_INVALID,
['iEquipItemNum'] = 0,
['akEquipItem'] = nil,
['iSex'] = 0,
['kRoleFaceData'] = nil,
}

CommonTable_SeGameCmd_BattleUnit =
{
['iValueChangeFlag'] = 0,
['uiUnitIndex'] = 0,
['iGridX'] = 0,
['iGridY'] = 0,
['iMP'] = 0,
['iHP'] = 0,
['iMAXMP'] = 0,
['iMAXHP'] = 0,
['iRoundHP'] = 0,
['iRoundMP'] = 0,
['iShield'] = 0,
['iAssistFlag'] = 0,
['iFace'] = 1,
['eMaxAttackType'] = 0,
['iMaxAttack'] = 0,
['iDefend'] = 0,
['iMoveValue'] = 0,
['iMoveDistance'] = SSD_BATTLE_INIT_MOVE,
['iBuffNum'] = 0,
['akBuffData'] = nil,
['iChuanTouCiShu'] = 0,
}

CommonTable_SeGameCmd_BattleUnitComboInfo =
{
['uiUnitIndex'] = 0,
['iComboNum'] = 0,
['aiComboBaseID'] = nil,
}

CommonTable_SeBattle_UnitTime =
{
['uiUnitIndex'] = 0,
['fMoveTime'] = 0,
['fOptNeedTime'] = 0,
}

CommonTable_SeBattle_UnitMartial =
{
['iSkillNum'] = 0,
['akMartial'] = nil,
}

CommonTable_SeGameCmd_BattleUnitObserve =
{
['iValueChangeFlag'] = 0,
['uiUnitIndex'] = 0,
['iMAXMP'] = 0,
['iMAXHP'] = 0,
['iDefend'] = 0,
['iMoveValue'] = 0,
['iBuffNum'] = 0,
['akBuffData'] = nil,
['aiAttrs'] = nil,
['uiLevel'] = 0,
['iGoodEvil'] = 0,
['iRank'] = 0,
['iClan'] = 0,
['akUnitsMartial'] = nil,
}

CommonTable_SeGameCmd_BattleAssistUnit =
{
['iValueChangeFlag'] = 0,
['uiTypeID'] = 0,
['eCamp'] = SE_INVALID,
['bPet'] = 0,
['uiLevel'] = 0,
['uiMoedlID'] = 0,
}

CommonTable_SeBattle_TreasureBox =
{
['iGridX'] = 0,
['iGridY'] = 0,
['uiDropTypeID'] = 0,
['uiLevel'] = 0,
['iFlag'] = 0,
['iNum'] = 0,
['akReward'] = nil,
}

CommonTable_SeBattle_SkillDamageData =
{
['iValueChangeFlag'] = 0,
['iTargetUnitIndex'] = 0,
['iFinalDamageValue'] = 0,
['iFinalMPDamageValue'] = 0,
['iFinalHPAddValue'] = 0,
['iFinalValueFlag'] = 0,
['iDuoDuanNum'] = 0,
['aiFinalNumberAddValue'] = nil,
['iLeechValue'] = 0,
['iShieldValue'] = 0,
['iReboundDamageValue'] = 0,
['eSkillDataType'] = 1,
['eExtraFlag'] = BDEF_NULL,
['iJituiX'] = 100,
['iJituiY'] = 100,
['iYuanhuX'] = -1,
['iYuanhuY'] = -1,
['iExtraFinalDamageAddValue'] = 0,
['iExtraFinalDamageAddPer'] = 0,
['iExtraFinalHPAddValue'] = 0,
['iExtraFinalHPAddPer'] = 0,
['iBaseDamageValue'] = 0,
['iBaseHPAddValue'] = 0,
['iNumberAddPer'] = 0,
['iNumberAddValue'] = 0,
['iCurNumberAddValue'] = 0,
['eSpecialFlag'] = 0,
['iAddPassTime'] = 0,
['iDodge'] = 0,
}

CommonTable_SeBattle_YuanHuData =
{
['iTargetIndex'] = 0,
['iYuanHuIndex'] = 0,
['iMartialIndex'] = 0,
}

CommonTable_SeBattle_Plot =
{
['eEventType'] = 0,
['iPlotTaskID'] = 0,
['iPlotID'] = 0,
['PlotType'] = 0,
['Param1'] = 0,
['Param2'] = 0,
['Param3'] = 0,
['Param4'] = 0,
['Param5'] = 0,
}

CommonTable_SeBattle_HurtInfoBuff =
{
['iValueChangeFlag'] = 0,
['iOwnUnitIndex'] = 0,
['eEventType'] = 0,
['iBuffIndex'] = 0,
['iBuffTypeID'] = 0,
['iLayerNum'] = 0,
['iRoundNum'] = 0,
['iFlag'] = SBHBT_NULL,
}

CommonTable_SeBattle_HurtInfo =
{
['iValueChangeFlag'] = 0,
['eEvent'] = 0,
['iOwnerUnitIndex'] = 0,
['iOwnerMartialIndex'] = 0,
['iSkillTypeID'] = 0,
['iBuffIndex'] = 0,
['iBuffTypeID'] = 0,
['iBuffDamage'] = 0,
['iSourceUnitIndex'] = 0,
['iSourceMartialIndex'] = 0,
['iCastPosX'] = -1,
['iCastPosY'] = -1,
['iMoveX'] = -1,
['iMoveY'] = -1,
['iSpendMP'] = 0,
['iAddMP'] = 0,
['iAddHP'] = 0,
['iSpendItemID'] = 0,
['iLianJiCount'] = 100,
['eSkillEventType'] = BSET_Null,
['iBuffNum'] = 0,
['akBuffData'] = nil,
['iPlotNum'] = 0,
['akPlotData'] = nil,
['iHeJiTargetNum'] = 0,
['aiHeJiTargetUnit'] = nil,
['iSkillDamageData'] = 0,
['akSkillDamageData'] = nil,
['iMutilTag'] = 0,
['bDeath'] = 0,
['iCallDiscipleIndex'] = 0,
['iPetNum'] = 0,
['aiPetID'] = nil,
}

CommonTable_RoleEmbattle =
{
['uiRoleID'] = 0,
['iID'] = 0,
['iRound'] = 0,
['iGridX'] = 0,
['iGridY'] = 0,
['eFlag'] = INVALID,
['bPet'] = false,
['uiFlag'] = 0,
}

-- 交互时间结构
CommonTable_InteractDate =
{
['uiRoleID'] = 0,
['eInteractType'] = NPCIT_UNKNOW,
['uiTimes'] = 0,
['iChangeType'] = -1,
}

-- 交互选项结构
CommonTable_InteractOption =
{
['uiChoiceLangID'] = 0,
['uiLockLangID'] = 0,
['uiRoleTypeID'] = 0,
['uiMapID'] = 0,
['uiConditionID'] = 0,
['bIsLock'] = 0,
['uiMazeTypeID'] = 0,
['uiAreaIndex'] = 0,
['uiCardID'] = 0,
['uiRow'] = 0,
['uiColumn'] = 0,
['eInteractType'] = 0,
['uiTaskID'] = 0,
}

-- 选择角色事件结构
CommonTable_RoleSelectEvent =
{
['uiRoleTypeID'] = 0,
['uiMapTypeID'] = 0,
['uiMazeTypeID'] = 0,
['uiAreaIndex'] = 0,
['uiCardTypeID'] = 0,
['uiRow'] = 0,
['uiColumn'] = 0,
}

-- 展示_随机获得物品动画
CommonTable_NPCInteractRandomItems =
{
['uiRoleID'] = 0,
['uiItemTypeID'] = 0,
['iNum'] = 0,
['iItemP'] = 0,
['iTreasureP'] = 0,
['iRandomItemNum'] = nil,
['eInteractType'] = NPCIT_UNKNOW,
['auiRoleItem'] = nil,
}

-- 排行榜信息
CommonTable_SeRankInfo =
{
['acUserID'] = 'nil',
['acRankID'] = 'nil',
['acMember'] = 'nil',
['acScore'] = 'nil',
['bIsAdd'] = 1,
['iPage'] = 1,
['iPageNum'] = 10,
['bIsAsc'] = 1,
['acSnap'] = 'nil',
['bIsSnap'] = 0,
['iStart'] = 0,
['iStop'] = -1,
}

-- 排行榜数据
CommonTable_SeRanklistData =
{
['uiRankID'] = 0,
['uiScore'] = 0,
['bIsAdd'] = 0,
}

-- 调试下行所有函数调用时间信息
CommonTable_DebugFuncCallInfo =
{
['acFuncName'] = 'nil',
['uiCallTimes'] = 0,
['uiCallCostTime'] = 0,
}

-- 实例角色数据
CommonTable_SeInstRole =
{
['uiTypeID'] = 0,
['uiNameID'] = nil,
['uiTitleID'] = nil,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['uiLevel'] = nil,
['uiClanID'] = nil,
['uiHP'] = nil,
['uiMP'] = nil,
['uiExp'] = nil,
['uiRemainAttrPoint'] = nil,
['uiFragment'] = nil,
['uiOverlayLevel'] = nil,
['iGoodEvil'] = nil,
['uiRemainGiftPoint'] = nil,
['uiModelID'] = nil,
['uiRank'] = nil,
['uiMartialNum'] = nil,
['uiEatFoodNum'] = nil,
['uiMarry'] = nil,
['uiSubRole'] = nil,
['auiFavor'] = 0,
['uiBroAndSisNum'] = nil,
['auiBroAndSis'] = 0,
['aiAttrs'] = nil,
['iItemNum'] = nil,
['auiRoleItem'] = nil,
['auiEquipItem'] = nil,
['iMartialNum'] = nil,
['auiRoleMartials'] = nil,
['auiEmbattleMartials'] = nil,
['giftNum'] = nil,
['auiRoleGift'] = nil,
['iWishTasksNum'] = nil,
['auiRoleWishTasks'] = nil,
['auiHeritGift'] = nil,
['auiHeritMartial'] = nil,
}

-- 平台角色基本数据
CommonTable_SePlatRoleCommon =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiNameID'] = 0,
['uiTitleID'] = 0,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['uiLevel'] = 0,
['uiClanID'] = 0,
['uiHP'] = 0,
['uiMP'] = 0,
['uiExp'] = 0,
['uiRemainAttrPoint'] = 0,
['uiFragment'] = 0,
['uiOverlayLevel'] = 0,
['iGoodEvil'] = 0,
['uiRemainGiftPoint'] = 0,
['uiModelID'] = 0,
['uiRank'] = 0,
['uiMartialNum'] = 0,
['uiEatFoodNum'] = 0,
['uiEatFoodMaxNum'] = 0,
['uiMarry'] = 0,
['uiSubRole'] = 0,
['uiFavorNum'] = 0,
['auiFavor'] = nil,
['uiBroAndSisNum'] = 0,
['auiBroAndSis'] = nil,
}

-- 玩家基础信息
CommonTable_ArenaMemberData =
{
['defPlayerID'] = 0,
['dwModelID'] = 0,
['dwOnlineTime'] = 0,
['dwMerdianLevel'] = 0,
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwRoleID'] = 0,
}

-- 擂台赛阵容数据数据
CommonTable_SeArenaMatchPkData =
{
['iPkDataFlag'] = 0,
['iDataSize'] = 0,
['akData'] = nil,
}

-- 擂台比赛数据
CommonTable_SeArenaMatchData =
{
['dwMatchType'] = 0,
['dwMatchID'] = 0,
['dwBufferID'] = 0,
['dwSignUpCount'] = 0,
['uiStage'] = 0,
['dwRoundID'] = 0,
['uiSignUpPlace'] = 0,
['dwRank'] = 0,
['dwBetWinTimes'] = 0,
['dwBetWinMoney'] = 0,
['dwBattleTime'] = 0,
}

-- 擂台战斗数据
CommonTable_SeArenaBattleData =
{
['dwBattleID'] = 0,
['dwRoundID'] = 0,
['dwPly1BetRate'] = 0,
['dwPly2BetRate'] = 0,
['defPlyWinner'] = 0,
['defBetPlyID'] = 0,
['dwBetMoney'] = 0,
['kPly1Data'] = nil,
['kPly2Data'] = nil,
}

-- 擂台赛娱乐赛信息
CommonTable_SeArenaJokeBattleData =
{
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwModelID'] = 0,
['dwResult'] = 0,
}

-- 擂台赛玩家姓名
CommonTable_SeArenaMemberName =
{
['acPlayerName'] = 'nil',
}

-- 擂台赛押注胜利榜玩家
CommonTable_SeArenaBetRankMember =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['dwValue'] = 0,
}

-- 擂台华山论名单玩家
CommonTable_SeArenaHuaShanMember =
{
['dwMatchType'] = 0,
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
}

-- 擂台赛历史玩家
CommonTable_SeArenaHistoryMember =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['charPicUrl'] = 'nil',
['dwModelID'] = 0,
['dwPlace'] = 0,
}

-- 擂台赛历史数据
CommonTable_SeArenaMatchHistoryData =
{
['dwMatchType'] = 0,
['dwMatchID'] = 0,
['dwMatchTime'] = 0,
['dwPlace'] = 0,
['dwBetWinTimes'] = 0,
['dwBetWinMoney'] = 0,
['akMemberHistoryData'] = nil,
}

-- 擂台战斗计算
CommonTable_ArenaBattleCalcInfo =
{
['uiMatchType'] = 0,
['uiMatchID'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiBuffTypeID'] = 0,
['uiArenaTypeID'] = 0,
['uiEnemyArenaTypeID'] = 0,
['iPly1PkDataCount'] = 0,
['iPly2PkDataCount'] = 0,
['akPly1PkData'] = nil,
['akPly2PkData'] = nil,
}

-- 擂台战斗计算
CommonTable_ArenaBattleCalcResultInfo =
{
['uiMatchType'] = 0,
['uiMatchID'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['aiClan1'] = 0,
['aiClan2'] = 0,
['uiWinnerID'] = 0,
['iRecordDataSize'] = 0,
['akRecordData'] = nil,
}

-- 切磋战斗计算
CommonTable_ChallengePlatRoleCalcInfo =
{
['uiClientID1'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiModelID2'] = 0,
['uiMeridian2'] = 0,
['acPly1Name'] = 'nil',
['acPly2Name'] = 'nil',
['iPly1PkDataCount'] = 0,
['iPly2PkDataCount'] = 0,
['akPly1PkData'] = nil,
['akPly2PkData'] = nil,
['uiBattleID'] = 0,
['uiMatchType'] = 0,
}

-- 切磋战斗计算
CommonTable_ChallengePlatRoleCalcInfoEx =
{
['uiClientID1'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiModelID2'] = 0,
['uiMeridian2'] = 0,
['acPly1Name'] = 'nil',
['acPly2Name'] = 'nil',
['iPly1PkDataCount'] = 0,
['iPkDataFlag1'] = 0,
['iDataSize1'] = 0,
['akData1'] = nil,
['iPkDataFlag2'] = 0,
['iDataSize2'] = 0,
['akData2'] = nil,
}

-- 切磋战斗计算
CommonTable_ChallengePlatRoleCalcResultInfo =
{
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiWinnerID'] = 0,
['iRecordDataSize'] = 0,
['akRecordData'] = nil,
}

-- 玩家布阵角色基础数据
CommonTable_SePlatBaseRoleInfo =
{
['uiID'] = 0,
['uiTypeID'] = 0,
['uiNameID'] = 0,
['uiTitleID'] = 0,
['uiFamilyNameID'] = 0,
['uiFirstNameID'] = 0,
['uiModelID'] = 0,
['uiRank'] = 0,
}

-- 玩家展示剧本角色数据
CommonTable_SePlatAppearanceRoles =
{
['uiMainRoleID'] = 0,
['acRoleName'] = 'nil',
['iNum'] = 0,
['akBaseRoleInfo'] = nil,
}

-- Map结构
CommonTable_DwKeyDwValue =
{
['uiKey'] = 0,
['uiValue'] = 0,
}

-- 排行榜查询数据结构
CommonTable_SeRankData =
{
['defMember'] = 0,
['uiRank'] = 0,
['uiScore'] = 0,
}

-- 角色宠物卡
CommonTable_RolePetCardData =
{
['uiCardID'] = 0,
['uiLevel'] = 0,
['uiCardNum'] = 0,
['uiUseFlag'] = 0,
}

-- 商城物品
CommonTable_PlatShopItem =
{
['uiShopID'] = 0,
['uiItemID'] = 0,
['uiProperty'] = 0,
['uiMoneyType'] = 0,
['iPrice'] = 0,
['iDiscount'] = 0,
['iFinalPrice'] = 0,
['uiFlag'] = 0,
['iRemainTime'] = 0,
['iCanBuyCount'] = -1,
['iMaxBuyNums'] = -1,
['iNeedUnlockType'] = -1,
['iNeedUnlockID'] = -1,
['iMaxBuyNumsPeriod'] = 0,
['iType'] = 0,
['iSort'] = 0,
}

-- 排行榜批量数据
CommonTable_SeRankUpdateInfo =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['uiRankID'] = 0,
['uiScore'] = 0,
['bIsAdd'] = 0,
}

-- 玩家改名
CommonTable_SePlayerChangeName =
{
['acUserID'] = 'nil',
['acRankID'] = 'nil',
['acMember'] = 'nil',
['acScore'] = 'nil',
['bIsAdd'] = 1,
['iPage'] = 1,
['iPageNum'] = 10,
['bIsAsc'] = 1,
['acSnap'] = 'nil',
['bIsSnap'] = 0,
['iStart'] = 0,
['iStop'] = -1,
}

-- 大数据消息分包结构体
CommonTable_SeBigCmdBatchData =
{
['uiTotalSize'] = 0,
['uiBatchIdx'] = 0,
['uiBatchSize'] = nil,
['akData'] = nil,
}

-- 腾讯信用分
CommonTable_SeTencentCreditScore =
{
['iScore'] = 0,
['iTagBlack'] = 0,
['iMTime'] = nil,
}

-- 更新排行榜返回
CommonTable_SeUpdateRankRet =
{
['dwRankID'] = 'nil',
['acMember'] = 'nil',
['acScore'] = 'nil',
['dwBeforeRank'] = 0,
['dwAfterRank'] = 0,
['bSucessful'] = false,
}

-- 单条主角信息
CommonTable_MainRoleInfo =
{
['uiDataType'] = 0,
['uiValue'] = 0,
}

-- 限时商店
CommonTable_SeLimitShopData =
{
['nDataId'] = 0,
['nTypeId'] = 0,
['nShareTimes'] = 0,
['nBuyBits'] = 0,
}

-- 限时商店
CommonTable_SeLimitShopDiscountData =
{
['nDiscount'] = 0,
['nOverTime'] = 0,
}

-- 限时商店操作
CommonTable_SeLimitShopOpParam =
{
['defPlayerID'] = 0,
['eOprType'] = EN_LIMIT_SHOP_GET,
['iType'] = 0,
['iParams0'] = 0,
['iParams1'] = 0,
['iParams2'] = 0,
['iParams3'] = 0,
['acData'] = 'nil',
}

-- 称号榜单数据
CommonTable_SeTitleRankID2PlayerIDs =
{
['uiRankID'] = 0,
['defPlayerID'] = 0,
['iSendMailCnt'] = 0,
}

-- 抢称号玩法数据
CommonTable_SeGrabTitleData =
{
['uiNpcID'] = 0,
['uiLevel'] = 0,
['uiRank'] = 0,
['uiClan'] = 0,
['iMartialsNum'] = 0,
['iGiftsNum'] = 0,
['iAttrNum'] = 0,
['akMartials'] = nil,
['akGifts'] = nil,
['akAttr'] = nil,
}

-- 神器信息
CommonTable_SeZMEquipInfo =
{
['dwBaseId'] = 0,
['dwLv'] = 0,
['dwId'] = 0,
}

-- 卡牌信息
CommonTable_SeZMCardInfo =
{
['dwBaseId'] = 0,
['dwLv'] = 0,
['dwId'] = 0,
['dwEquipId'] = 0,
['wX'] = 0,
['wY'] = 0,
}

-- 卡牌模板信息
CommonTable_SeZMCardData =
{
['dwBaseId'] = 0,
['dwCardNum'] = 0,
}

-- 选择卡牌信息
CommonTable_SeZMCardSelectInfo =
{
['dwBaseId'] = 0,
['dwLv'] = 0,
}

-- 通知信息
CommonTable_SeZMNoticePair =
{
['dwFirst'] = 0,
['dwSecond'] = 0,
}

-- 玩家信息
CommonTable_SeZMPlayerInfo =
{
['akBattleCardData'] = nil,
['iCardNum'] = 0,
['akCardData'] = nil,
['iEquipNum'] = 0,
['akEquipData'] = nil,
['dwClan'] = 0,
['dwBattleCardNum'] = 0,
}

-- 玩家拓展信息
CommonTable_SeZMPlayerInfoExt =
{
['akSelectCardData'] = nil,
['akSelectClanData'] = nil,
['akSelectEquipData'] = nil,
['dwRound'] = 0,
['dwEventId'] = 0,
['dwReflashTimes'] = 0,
['dwSkillUseTimes'] = 0,
['dwGold'] = 0,
}

-- 其他玩家信息
CommonTable_SeZMOtherPlayerInfo =
{
['defPlayerID'] = 0,
['acPlayerName'] = 'nil',
['akCardData'] = nil,
['akEquipData'] = nil,
['dwClan'] = 0,
['dwBuffID'] = 0,
['dwClanBuffID'] = 0,
['dwClanBuffCount'] = 0,
}

-- 掌门对决战斗计算
CommonTable_ZmBattleCalcInfo =
{
['nRoomId'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiFightID'] = 0,
['kPlayerInfo1'] = nil,
['kPlayerInfo2'] = nil,
['iFreezeCardNum'] = 0,
['akFreezeCardData'] = nil,
}

-- 掌门对决战斗计算
CommonTable_ZmBattleCalcResultInfo =
{
['nRoomId'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['uiPlyID1'] = 0,
['uiPlyID2'] = 0,
['uiWinnerID'] = 0,
['iRecordDataSize'] = 0,
['akRecordData'] = nil,
}

-- 掌门对决战斗数据
CommonTable_SeZmBattleData =
{
['uiBattleID'] = 0,
['uiRoundID'] = 0,
['uiWinnerID'] = 0,
['kPly1Data'] = nil,
['kPly2Data'] = nil,
}

-- 玩家基础信息
CommonTable_ZmMemberData =
{
['kPlyData'] = nil,
['bRobot'] = 0,
}

-- 卡牌上阵
CommonTable_SeZmCardBattle =
{
['dwId'] = 0,
['dwBattleIndex'] = 0,
['wX'] = 0,
['wY'] = 0,
}

-- 角色卡
CommonTable_RoleCardData =
{
['dwRoleID'] = 0,
['dwLevel'] = 0,
}

-- 掌门商店
CommonTable_SeZmShopItem =
{
['dwRoleId'] = 0,
['dwRoleNum'] = 0,
}

-- 门派工坊材料信息
CommonTable_SectWorkshopItemInfo =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
['dwUpdateTime'] = 0,
}

-- 门派建筑信息
CommonTable_SectBuildingInfo =
{
['dwBuildingID'] = 0,
['dwBuildingType'] = 0,
['dwBuildingLevel'] = 0,
['dwBuildingPos'] = 0,
['dwPreBuildingID'] = 0,
['acName'] = 'nil',
['dwBackGroundID'] = 0,
['dwUpgradeEndTime'] = 0,
['iNum'] = 0,
['akWorkshopItemInfo'] = nil,
['akDiscipleInfo'] = nil,
}

-- 建筑位置信息
CommonTable_SectBuildingPos =
{
['dwBuildingID'] = 0,
['dwBuildingPos'] = 0,
['dwPreBuildingID'] = 0,
}

-- 门派仓库材料信息
CommonTable_SectStoreItemInfo =
{
['dwItemID'] = 0,
['dwItemNum'] = 0,
}

-- 门派仓库存储信息
CommonTable_SectStoreInfo =
{
['iNum'] = 0,
['akStoreItemInfo'] = nil,
}

-- 返回活动信息结构
CommonTable_SeActivityRetInfo =
{
['dwActivityID'] = 0,
['iReset_time'] = 0,
['iCycle_count'] = 0,
['iHistory_count'] = 0,
['iState'] = 0,
['iValue1'] = 0,
['iValue2'] = 0,
['iValue3'] = 0,
['bEnabled'] = false,
}

-- 剧本周限制信息
CommonTable_SeStoryWeekLimitInfo =
{
['dwStoryID'] = 0,
['iTakeOutNum'] = 0,
}

-- 客户端请求擂台操作数据
CommonTable_SeRequestArenaMatchOperateCmd =
{
['eRequestType'] = ARENA_REQUEST_NULL,
['uiMatchType'] = 0,
['uiMatchID'] = 0,
['uiRoundID'] = 0,
['uiBattleID'] = 0,
['kPlayerID'] = 0,
['iUploadFlag'] = 0,
}

