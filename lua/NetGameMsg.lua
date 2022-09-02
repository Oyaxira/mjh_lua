reloadModule("Net/Auto/SePtlCommDefine")
reloadModule("Net/Auto/CGA_Encode")
reloadModule("Net/Auto/CGA_Decode")
reloadModule("Net/Auto/GAC_Encode")
reloadModule("Net/Auto/GAC_Decode")
reloadModule("Net/Auto/GC_Encode")
reloadModule("Net/Auto/GC_Decode")

reloadModule("Net/NetGameMsgGenCmd")
reloadModule("Net/NetGameMsgProcCmd")

-- function pool to process the game msg
local NetGameMsgProcFuncPool = {}
local GameLogicShowFuncPool = {}
local NetGameMsgRecord = {}
-- to InitGameMsg
function InitGameMsg()
    
    -- to register the encode and decode cmd function
    registerGASToCLCommand()
    registerCLToGASCommand()
    registerGCSToGCSCommand()
    
    -- to register Game Msg Proc function
    registerGameCommand(CMD_GAC_PLAYERVALIDATERET, OnRecv_GAC_PlayerValidRet)
    registerGameCommand(CMD_GAC_KICKPLAYER, OnRecv_CMD_GAC_KickPlayer)

    registerGameCommand(CMD_GAC_INITPLAYERINFO, OnRecv_CMD_GAC_InitPlayerInfo)
    registerGameCommand(CMD_GAC_PLATPLAYERSIMPLEINFOS, OnRecv_CMD_GAC_PlatPlayerSimpleInfos)
    registerGameCommand(CMD_GAC_PLAYERINSAMESCRIPTINFO, OnRecv_CMD_GAC_PlayerInSameScriptInfo)
    registerGameCommand(CMD_GAC_PLAYERAPPEARANCEINFODATARET, OnRecv_CMD_GAC_PlayerAppearanceInfoDataRet)

    registerGameCommand(CMD_GAC_UPDATESYSTEMMODULEENABLESTATE, OnRecv_CMD_GAC_UpdateSystemModuleEnableState)
    
    registerGameCommand(CMD_GAC_SCRIPTOPRRET, OnRecv_CMD_GAC_ScriptOprRet)
    registerGameCommand(CMD_GAC_ALLPLATITEMRET, OnRecv_CMD_GAC_AllPlatItemRet)

    -- TOKEN
    registerGameCommand(CMD_GAC_JWTTOKENRET, OnRecv_CMD_GAC_JWTTokenRet);

    -- System Model Switch
    registerGameCommand(CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFY, OnRecv_CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFY)
    registerGameCommand(CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFYALL, OnRecv_CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFYALL)

    -- Unlock
    registerGameCommand(CMD_GAC_UNLOCKINFORET, OnRecv_CMD_GAC_UNLOCKINFORET)
    
    -- Achieve
    registerGameCommand(CMD_GAC_UPDATEACHIEVESAVEDATA, OnRec_CMD_GAC_UPDATEACHIEVESAVEDATA)
    registerGameCommand(CMD_GAC_UPDATEACHIEVERECORDDATA, OnRec_CMD_GAC_UPDATEACHIEVERECORDDATA)
    --registerGameCommand(CMD_GAC_UNLOCKACHIEVEMENT, OnRecv_CMD_GAC_AchieveUpdate)
    registerGameCommand(CMD_GAC_UPDATEDIFFDROPDATA, OnRecv_CMD_GAC_UpdateDiffDropData)
    registerGameCommand(CMD_GAC_CHOOSESCRIPTACHIEVERET, OnRecv_CMD_GAC_CHOOSESCRIPTACHIEVERET)
    
    -- Mail/Friend
    registerGameCommand(CMD_GAC_MAILOPRRET, OnRecv_CMD_GAC_MailOprRet)
    registerGameCommand(CMD_GAC_FRIENDINFOOPRRET, OnRecv_CMD_GAC_FriendInfoOprRet)

    -- publicChat
    registerGameCommand(CMD_GAC_PUBLICCHATRET, OnRecv_CMD_GAC_PublicChatRet)

    -- Arena
    registerGameCommand(CMD_GAC_QUERYPLATTEAMINFORET, OnRecv_CMD_GAC_QueryPlatTeamInfoRet)
    registerGameCommand(CMD_GAC_COPYTEAMINFORET, OnRecv_CMD_GAC_CopyTeamInfoRet)
    registerGameCommand(CMD_GAC_PLATEMBATTLERET, OnRecv_CMD_GAC_PlatEmbattleRet)
    registerGameCommand(CMD_GAC_PLATTEAM_ROLECOMMON, OnRecv_CMD_GAC_PlatTeam_RoleCommon)
    registerGameCommand(CMD_GAC_PLATTEAM_ROLEATTRS, OnRecv_CMD_GAC_PlatTeam_RoleAttrs)
    registerGameCommand(CMD_GAC_PLATTEAM_ROLEITEMS, OnRecv_CMD_GAC_PlatTeam_RoleItems)
    registerGameCommand(CMD_GAC_PLATTEAM_ROLEMARTIALS, OnRecv_CMD_GAC_PlatTeam_RoleMartials)
    registerGameCommand(CMD_GAC_PLATTEAM_ROLEGIFT, OnRecv_CMD_GAC_PlatTeam_RoleGift)
    registerGameCommand(CMD_GAC_PLATTEAM_ROLEWISHTASKS, OnRecv_CMD_GAC_PlatTeam_RoleWishTasks)
    registerGameCommand(CMD_GAC_PLATTEAM_ITEMINFO, OnRecv_CMD_GAC_PlatTeam_ItemInfo)
    registerGameCommand(CMD_GAC_PLATTEAM_MARTIALINFO, OnRecv_CMD_GAC_PlatTeam_MartialInfo)
    registerGameCommand(CMD_GAC_PLATTEAM_WISHTASKINFO, OnRecv_CMD_GAC_PlatTeam_WishTaskInfo)
    registerGameCommand(CMD_GAC_PLATTEAM_GIFTINFO, OnRecv_CMD_GAC_PlatTeam_GiftInfo)
    registerGameCommand(CMD_GAC_PLATTEAM_EMBATTLEINFO, OnRecv_CMD_GAC_PlatTeam_EmbattleInfo)
    registerGameCommand(CMD_GAC_SETMAINROLERET, OnRecv_CMD_GAC_SetMainRole)
    
    registerGameCommand(CMD_GAC_UPDATEARENAMATCHDATA, OnRecv_CMD_GAC_UPDATEARENAMATCHDATA)
    registerGameCommand(CMD_GAC_UPDATEARENABATTLEDATA, OnRecv_CMD_GAC_UPDATEARENABATTLEDATA)
    registerGameCommand(CMD_GAC_UPDATESIGNUPNAME, OnRecv_CMD_GAC_UPDATESIGNUPNAME)
    registerGameCommand(CMD_GAC_ARENABATTLERECORDDATA, OnRecv_CMD_GAC_ARENABATTLERECORDDATA)
    registerGameCommand(CMD_GAC_UPDATEARENABETRANKDATA, OnRecv_CMD_GAC_UPDATEARENABETRANKDATA)
    registerGameCommand(CMD_GAC_UPDATEARENAMATCHHISTORYDATA, OnRecv_CMD_GAC_UPDATEARENAMATCHHISTORYDATA)
    registerGameCommand(CMD_GAC_NOTIFYARENANOTICE, OnRecv_CMD_GAC_NOTIFYARENANOTICE)
    registerGameCommand(CMD_GAC_UPDATEARENAMATCHJOKEBATTLEDATA, OnRecv_CMD_GAC_UPDATEARENAMATCHJOKEBATTLEDATA)
    registerGameCommand(CMD_GAC_UPDATEARENAMATCHCHAMPIONTIMES, OnRecv_CMD_GAC_UPDATEARENAMATCHCHAMPIONTIMES)
    registerGameCommand(CMD_GAC_UPDATEARENAHUASHAN, OnRecv_CMD_GAC_UPDATEARENAHUASHAN)
    
    --
    registerGameCommand(CMD_GAC_OBSERVEPLATROLERET, OnRecv_CMD_GAC_OBSERVEPLATROLERET)

    registerGameCommand(CMD_GAC_RETROLEPETCARDOPERATE, OnRecv_CMD_GAC_RETROLEPETCARDOPERATE)

    -- -- 捏脸
    -- registerGameCommand(CMD_GAC_ROLEFACEOPRRET, OnRecv_CMD_GAC_ROLEFACEOPRRET)
    registerGameCommand(CMD_GAC_ALLROLEFACERET, OnRecv_CMD_GAC_ALLROLEFACERET)

    registerGameCommand(CMD_GAC_QUERYSAVEFILERET, OnRecv_CMD_GAC_SAVE_FILE)
    
    -- shop
    registerGameCommand(CMD_GAC_PLATSHOPMALLREWARDRET, OnRecv_CMD_GAC_PlatShopMallRewardRet)
    registerGameCommand(CMD_GAC_PLATSHOPMALLQUERYITEMRET, OnRecv_CMD_GAC_PlatShopMallQueryItemRet)
    registerGameCommand(CMD_GAC_PLATSHOPMALLBUYRET, OnRecv_CMD_GAC_PlatShopMallBuyRet)


    -- Meridians
    registerGameCommand(CMD_GAC_MERIDIANSOPRRET, OnRecv_CMD_GAC_MeridiansOprRet)
    registerGameCommand(CMD_GAC_PLAYERCOMMONINFORET, OnRecv_CMD_GAC_PlayerCommonInfoRet)

    -- recycle
    registerGameCommand(CMD_GAC_PLATITEMOPRRET, OnRecv_CMD_GAC_PlatItemOprRet)

    -- PlayerSet
    registerGameCommand(CMD_GAC_MODIFYPLAYERAPPEARANCERET, OnRecv_CMD_GAC_ModifyPlayerAppearanceRet)

    -- PlayerInfo
    registerGameCommand(CMD_GAC_MONEYUPDATE, OnRecv_CMD_GAC_MoneyUpdate)
    registerGameCommand(CMD_GAC_WORDFILTERRET, OnRecv_CMD_GAC_WordFilterTips)
    registerGameCommand(CMD_GAC_PLATPLAYERDETAILINFO, OnRecv_CMD_GAC_PLATPLAYERDETAILINFO)
    registerGameCommand(CMD_GAC_PLAYERFUNCTIONINFODATARET, OnRecv_CMD_GAC_PLAYERFUNCTIONINFODATARET)
    registerGameCommand(CMD_GAC_BASEINFOUPDATE, OnRecv_CMD_GAC_BaseInfoUpdate)

    registerGameCommand(CMD_GAC_SETCHARPICTUREURLRET, OnRecv_CMD_GAC_SETCHARPICTUREURLRET)
    registerGameCommand(CMD_GAC_PLAYERCOMMONINFODATARET, OnRecv_CMD_GAC_PLAYERCOMMONINFODATARET)

    -- ClanInfo
    registerGameCommand(CMD_GAC_QUERYCLANCOLLECTIONINFORET, OnRecv_CMD_GAC_QueryClanCollectionInfoRet)

    -- TreasureBook Info
    registerGameCommand(CMD_GAC_QUERYTREASUREBOOKBASEINFORET, OnRecv_CMD_GAC_QUERYTREASUREBOOKBASEINFORET)
    registerGameCommand(CMD_GAC_QUERYTREASUREBOOKTASKINFORET, OnRecv_CMD_GAC_QUERYTREASUREBOOKTASKINFORET)
    registerGameCommand(CMD_GAC_QUERYTREASUREBOOKMALLINFORET, OnRecv_CMD_GAC_QUERYTREASUREBOOKMALLINFORET)
    registerGameCommand(CMD_GAC_QUERYTREASUREBOOKALLREWARDPROGRESSRET, OnRecv_CMD_GAC_QUERYTREASUREBOOKALLREWARDPROGRESSRET)
    registerGameCommand(CMD_GAC_QUERYTREASUREBOOKGETREWARDRET, OnRecv_CMD_GAC_QUERYTREASUREBOOKGETPROGRESSREWARDRET)

    -- Hoodle
    registerGameCommand(CMD_GAC_QUERYHOODLELOTTERYBASEINFORET, OnRecv_CMD_GAC_QUERYHOODLELOTTERYBASEINFORET)
    registerGameCommand(CMD_GAC_QUERYHOODLELOTTERYRESULTRET, OnRecv_CMD_GAC_QUERYHOODLELOTTERYRESULTRET)
    registerGameCommand(CMD_GAC_QUERYHOODLELOTTERYOPENINFORET, OnRecv_CMD_GAC_QUERYHOODLELOTTERYOPENINFORET)
    registerGameCommand(CMD_GAC_HOODLENUMRET, OnRecv_CMD_GAC_HOODLENUMRET)
    registerGameCommand(CMD_GAC_HOODLEPUBLICINFORET, OnRecv_CMD_GAC_HOODLEPUBLICINFORET)
    registerGameCommand(CMD_GAC_HOODLEPUBLICRECORDRET, OnRecv_CMD_GAC_HOODLEPUBLICRECORDRET)
    registerGameCommand(CMD_GAC_HOODLEPUBLICASSISTREWARD, OnRecv_CMD_GAC_HOODLEPUBLICASSISTREWARD)
    registerGameCommand(CMD_GAC_QUERYHOODLEPRIVACYRESULTRET, OnRecv_CMD_GAC_QUERYHOODLEPRIVACYRESULTRET)
    
    -- Day 3 Sign in
    registerGameCommand(CMD_GAC_DAY3SINGINRET, OnRecv_CMD_GAC_DAY3SINGINRET)

    -- Prajna 防沉迷
    registerGameCommand(CMD_GAC_CHECKTENCENTANTIADDICTIONRET, OnRecv_CMD_GAC_CHECKTENCENTANTIADDICTIONRET)

    -- Show Notice
    registerGameCommand(CMD_GAC_SHOWNOTICE, OnRecv_CMD_GAC_SHOWNOTICE)

    -- gold exchange
    registerGameCommand(CMD_GAC_EXCHANGEGOLDTOSILVERRET, OnRecv_CMD_GAC_EXCHANGEGOLDTOSILVERRET)
    
    -- Toast
    registerGameCommand(CMD_GAC_PLATDISPLAYNEWTOAST, OnRecv_CMD_GAC_PLATDISPLAYNEWTOAST)
    registerGameCommand(CMD_GAC_SYNCTSSDATASENDTOCLIENT, OnRecv_CMD_GAC_SYNCTSSDATASENDTOCLIENT)

    registerGameCommand(CMD_GAC_GETREDPACKETRET, OnRecv_CMD_GAC_GETREDPACKETRET)

    --下行禁用信息
    registerGameCommand(CMD_GAC_QUERYFORBIDINFORET, OnRecv_CMD_GAC_QUERYFORBIDINFORET)
    
    --请求腾讯信用分
    registerGameCommand(CMD_GAC_REQUESTTENCENTCREDITSCORERET, OnRecv_CMD_GAC_QueryTencentCreditScoreRet)
    registerGameCommand(CMD_GAC_REQUESTPRIVATECHATSCENELIMITRET, OnRecv_CMD_GAC_RequestPrivateChatSceneLimitRet)
    registerGameCommand(CMD_GAC_LIMITSHOPRET,OnRecv_CMD_GAC_LimitShopRet)

    registerGameCommand(CMD_GAC_GIFTBAGRESULTRET, OnRecv_CMD_GAC_GIFTBAGRESULTRET)

    registerGameCommand(CMD_GAC_REQUESTCOLLECTIONPOINTRET, OnRecv_CMD_GAC_REQUESTCOLLECTIONPOINTRET)

    -- 限时商店
    registerGameCommand(CMD_GAC_LIMITSHOPGETYAZHUINFORET, OnRecv_CMD_GAC_LIMITSHOPGETYAZHUINFORET)

    -- 切磋奖励
    registerGameCommand(CMD_GAC_PLATCHALLENGEREWARD, OnRecv_CMD_GAC_PLATCHALLENGEREWARD)

    -- 引导完成标记位组
    registerGameCommand(CMD_GAC_UPDATENOVICEGUIDEFLAGRET, OnRecv_CMD_GAC_UPDATENOVICEGUIDEFLAGRET)

    registerGameCommand(CMD_GAC_SYNCPLATCOMMONFUNCTIONVALUE, OnRecv_CMD_GAC_SyncPlatCommonFunctionInfo)
    registerGameCommand(CMD_GAC_HEARTBEAT,OnRecv_CMD_GAC_HeartBeat)

    -- 掌门对决
    registerGameCommand(CMD_GAC_UPDATEZMROOMINFO, OnRecv_CMD_GAC_UPDATEZMROOMINFO)
    registerGameCommand(CMD_GAC_UPDATEZMROOMINFOEXT, OnRecv_CMD_GAC_UPDATEZMROOMINFOEXT)
    registerGameCommand(CMD_GAC_UPDATEZMPLAYERINFO, OnRecv_CMD_GAC_UPDATEZMPLAYERINFO)
    registerGameCommand(CMD_GAC_UPDATEZMPLAYERINFOEXT, OnRecv_CMD_GAC_UPDATEZMPLAYERINFOEXT)
    registerGameCommand(CMD_GAC_ZMBATTLERECORDDATA, OnRecv_CMD_GAC_ZMBATTLERECORDDATA)
    registerGameCommand(CMD_GAC_UPDATEZMBATTLEDATA, OnRecv_CMD_GAC_UPDATEZMBATTLEDATA)
    registerGameCommand(CMD_GAC_RESPONSEZMOPERATE, OnRecv_CMD_GAC_RESPONSEZMOPERATE)
    registerGameCommand(CMD_GAC_UPDATEZMSHOP, OnRecv_CMD_GAC_UPDATEZMSHOP)
    registerGameCommand(CMD_GAC_UPDATEZMOTHERPLAYERINFO, OnRecv_CMD_GAC_UPDATEZMOTHERPLAYERINFO)
    registerGameCommand(CMD_GAC_ZMNOTICE, OnRecv_CMD_GAC_ZMNOTICE)

    --活动查询 回调
    registerGameCommand(CMD_GAC_QUERYACTIVITYRET, OnRecv_CMD_GAC_QUERYACTIVITYRET)
    -- 剧本周限制
    registerGameCommand(CMD_GAC_QUERYSTORYWEEKLIMITRET, OnRecv_CMD_GAC_QUERYSTORYWEEKLIMITRET)

    --to register Game Show function
    --SSD_XXX 对应  CMD_XXX
    registerGameShow(SGC_DISPLAY_BEGIN, CMD_GC_DISPLAY_BEGIN, DisplayBegin)

    -- 周目结算下行
    registerGameShow(SGC_DISPLAY_WEEK_ROUND_END, CMD_GC_WEEKROUNDEND, DisplayWeekRoundEnd)
    -- 周目数据统计下行
    registerGameShow(SGC_DISPLAY_UPDATE_WEEK_ROUND_DATA, CMD_GC_UPDATEWEEKROUNDDATA, DisplayUpdateWeekRoundData)

    -- 剧本擂台下行
    registerGameShow(SGC_DISPLAY_START_SCRIPT_ARENA, CMD_GC_STARTSCRIPTARENA, DisplayStartScriptArena)
    registerGameShow(SGC_DISPLAY_SCRIPT_ARENA_BATTLE_END, CMD_GC_SCRIPTARENABATTLEEND, DisplayScriptArenaBattleEnd)

    registerGameShow(SGC_DISPLAY_GAMEDATA,CMD_GC_DISPLAY_GAMEDATA,DisplayGameData)
    registerGameShow(SGC_DISPLAY_DIALOG,CMD_GC_DISPLAY_DIALOG,DisplayDialog)
    registerGameShow(SGC_DISPLAY_CREATEMAINROLE,CMD_GC_DISPLAY_CREATEMAINROLE,DisplayCreateMainRole)
    registerGameShow(SGC_DISPLAY_CREATEBABYROLE,CMD_GC_DISPLAY_CREATEBABYROLE,DisplayCreateBabyRole)
    registerGameShow(SGC_DISPLAY_MAINROLEINFO,CMD_GC_DISPLAY_MAINROLEINFO,DisplayMainRoleInfo)
    registerGameShow(SGC_DISPLAY_TEAM_INFO,CMD_GC_DISPLAY_TEAMINFO,DisplayTeamInfo)
    registerGameShow(SGC_DISPLAY_MAIN_ROLE_NAME,CMD_GC_DISPLAY_MAINROLENAME,DisplayMainRoleName)
    registerGameShow(SGC_DISPLAY_MAINROLENICKINFO,CMD_GC_DISPLAY_MAINROLENICKINFO,DisplayMainRoleNickName)
    registerGameShow(SGC_DISPLAY_MAINROLEPETINFO,CMD_GC_DISPLAY_MAINROLEPETINFO,DisplayMainRolePetInfo)
    registerGameShow(SGC_DISPLAY_NPC_UPDATE,CMD_GC_DISPLAY_NPCUPDATE,DisplayNpcUpdate)
    registerGameShow(SGC_DISPLAY_NPC_DELETE,CMD_GC_DISPLAY_NPCDELETE,DisplayNpcDelete)

    registerGameShow(SGC_DISPLAY_ROLECREATE,CMD_GC_DISPLAY_ROLECREATE,DisplayRoleCreate)
    registerGameShow(SGC_DISPLAY_ROLEDELETE,CMD_GC_DISPLAY_ROLEDELETE,DisplayRoleDelete)
    registerGameShow(SGC_DISPLAY_ROLECOMMON,CMD_GC_DISPLAY_ROLECOMMON,DisplayRoleCommon)
    registerGameShow(SGC_DISPLAY_ROLE_FAVOR,CMD_GC_DISPLAY_ROLEFAVOR,DisplayRoleFavor)
    registerGameShow(SGC_DISPLAY_ROLE_BRO,CMD_GC_DISPLAY_ROLEBRO,DisplayRoleBro)
    registerGameShow(SGC_DISPLAY_ROLEATTRS,CMD_GC_DISPLAY_ROLEATTRS,DisplayRoleAttrs)
    registerGameShow(SGC_DISPLAY_ROLEITEMS,CMD_GC_DISPLAY_ROLEITEMS,DisplayRoleItems)
    registerGameShow(SGC_DISPLAY_ROLEMARTIALS,CMD_GC_DISPLAY_ROLEMARTIALS,DisplayRoleMartials)
    registerGameShow(SGC_DISPLAY_ITEMDELETE,CMD_GC_DISPLAY_ITEMDELETE,DisplayItemDelete)
    registerGameShow(SGC_DISPLAY_ITEMUPDATE,CMD_GC_DISPLAY_ITEMUPDATE,DisplayUpdateItem)
    registerGameShow(SGC_DISPLAY_MARTIALDELETE,CMD_GC_DISPLAY_MARTIALDELETE,DisplayMartialDelete)
    registerGameShow(SGC_DISPLAY_MARTIALUPDATE,CMD_GC_DISPLAY_MARTIALUPDATE,DisplayMartialUpdate)
    registerGameShow(SGC_DISPLAY_ITEM_REFORGE_RESULT,CMD_GC_DISPLAY_ITEM_REFORGE_RESULT,DisplayItemReforge)
    registerGameShow(SGC_DISPLAY_SUBMITITEM_SELECT,CMD_GC_DISPLAY_SUBMITITEM_SELECT,DisplaySubmitItem)
    registerGameShow(SGC_DISPLAY_INCOMPLETE_BOOK_UPDATE, CMD_GC_DISPLAY_INCOMPLETEBOOKBOX, DisplayIncompleteBox)
    registerGameShow(SGC_DISPLAY_EMBATTLE_MARTIAL_UPDATE, CMD_GC_DISPLAY_EMBATTLEMARTIALUPDATE, DisplayEmbattleMartialUpdate)

    registerGameShow(SGC_DISPLAY_ROLEGIFTS,CMD_GC_DISPLAY_ROLEGIFT,DisplayRoleGift)
    registerGameShow(SGC_DISPLAY_GIFTUPDATE,CMD_GC_DISPLAY_GIFTUPDATE,DisplayGiftUpdate)
    registerGameShow(SGC_DISPLAY_GIFTDELETE,CMD_GC_DISPLAY_GIFTDELETE,DisplayGiftDelete)


    registerGameShow(SGC_DISPLAY_EVOLUTION_UPDATE ,CMD_GC_DISPLAY_EVOLUTIONUPDATE, DisplayEvolutionUpdate)
    registerGameShow(SGC_DISPLAY_EVOLUTION_DELETE ,CMD_GC_DISPLAY_EVOLUTIONDELETE, DisplayEvolutionDelete)

    registerGameShow(SGC_DISPLAY_EVOLUTION_RECORDUPDATE ,CMD_GC_DISPLAY_EVOLUTIONRECORDUPDATE, DisplayEvolutionRecordUpdate)
    registerGameShow(SGC_DISPLAY_MONTHEVOLUTION ,CMD_GC_DISPLAY_MONTHEVOLUTION, DisplayMonthEvolution)

    registerGameShow(SGC_DISPLAY_TASKADD,CMD_GC_DISPLAY_TASKUPDATE,DisplayAddTask)
    registerGameShow(SGC_DISPLAY_TASKUPDATE,CMD_GC_DISPLAY_TASKUPDATE,DisplayUpdateTask)
    registerGameShow(SGC_DISPLAY_TASK_COMPLETE, CMD_GC_DISPLAY_TASKCOMPLETE, DisplayTaskComplete)
    registerGameShow(SGC_DISPLAY_TASK_REMOVE, CMD_GC_DISPLAY_TASKREMOVE, DisplayTaskRemove)
    registerGameShow(SGC_DISPLAY_ROLE_RANDOM_GIFT,CMD_GC_DISPLAY_RANDOMGIFT,DisplayGiftRandom)
    
    registerGameShow(SGC_DISPLAY_MAPMOVE,CMD_GC_DISPLAY_MAPMOVE,DisplayMapMove)
    registerGameShow(SGC_DISPLAY_MAP_UPDATE,CMD_GC_DISPLAY_MAPUPDATE,DisplayMapUpdate)
    registerGameShow(SGC_DISPLAY_MAP_ADVLOOT,CMD_GC_DISPLAYMAPADVLOOTS,DisplaAdvLootUpdate)
    --registerGameShow(SGC_DISPLAY_MAP_ADVLOOT,CMD_GC_CLICKPICKUPADVLOOPICK,DisplaAdvLootUpdate)


    registerGameShow(SGC_DISPLAY_CITY_MOVE,CMD_GC_DISPLAYCITYMOVE,DisplayCityMove)
    registerGameShow(SGC_DISPLAY_CITYDATA,CMD_GC_DISPLAYCITYDATA, DisplayCityData)
    

    registerGameShow(SGC_DISPLAY_LOGICDEBUGINFO, CMD_GC_DISPLAY_LOGICDEBUGINFO, DisplayLogicDebugInfo)
    
    registerGameShow(SGC_DISPLAY_SHOP_UPDATE,CMD_GC_DISPLAY_SHOPITEM,DisplayShopItemUpdate)
    
    registerGameShow(SGC_DISPLAY_BATTLE_SHOW_EMBATTLE,CMD_GC_DISPLAY_BATTLE_SHOWEMBATTLEUI,DisplayBattle_ShowEmbattleUI)
    registerGameShow(SGC_DISPLAY_BATTLE_START,CMD_GC_DISPLAY_BATTLE_START,DisplayBattleStart)
    registerGameShow(SGC_DISPLAY_BATTLE_CREATEUNIT,CMD_GC_DISPLAY_BATTLE_CREATEUNIT,DisplayBattleCreateUnit)
    registerGameShow(SGC_DISPLAY_BATTLE_OBSERVEUNIT,CMD_GC_DISPLAY_BATTLE_OBSERVEUNIT,DisplayBattleObserveUnit)
    registerGameShow(SGC_DISPLAY_BATTLE_UPDATEUNIT,CMD_GC_DISPLAY_BATTLE_UPDATEUNIT,DisplayBattleUpdateUnit)
    registerGameShow(SGC_DISPLAY_BATTLE_UPDATEOPTUNIT,CMD_GC_DISPLAY_BATTLE_UPDATEOPTUNIT,DisplayBattleUpdateOptUnit)
    registerGameShow(SGC_DISPLAY_BATTLE_UPDATECOMBO,CMD_GC_DISPLAY_BATTLE_UPDATECOMBO,DisplayBattleUpdateCombo)
    registerGameShow(SGC_DISPLAY_BATTLE_END,CMD_GC_DISPLAY_BATTLE_GAMEEND,DisplayBattleGameEnd)
    registerGameShow(SGC_DISPLAY_BATTLE_AUTO,CMD_GC_DISPLAY_BATTLE_AUTOBATTLE,DisplayBattleAutoBattle)
    registerGameShow(SGC_DISPLAY_BATTLE_CHECK,CMD_GC_DISPLAY_BATTLE_CHECK,DisplayBattleCheck)
    
    registerGameShow(SGC_DISPLAY_BATTLE_LOG,CMD_GC_DISPLAY_BATTLE_LOG,DisplayBattleLog)

    registerGameShow(SGC_DISPLAY_NPC_INTERACT_RANDOM_ITEMS,CMD_GC_DISPLAY_NPC_INTERACT_RANDOM_ITEMS,DisplayNPCInteractRandomItems)
    registerGameShow(SGC_DISPLAY_NPC_INTERACT_GIVE_GIFT,CMD_GC_DISPLAY_NPC_INTERACT_GIVE_GIFT,DisplayNPCInteractGiveGift)
    
    registerGameShow(SGC_DISPLAY_EXECUTE_PLOT,CMD_GC_DISPLAY_EXECUTEPLOT,DisplayExecutePlot)
    registerGameShow(SGC_DISPLAY_EXECUTE_CUSTOM_PLOT,CMD_GC_DISPLAY_EXECUTECUSTOMPLOT,DisplayExecuteCustomPlot)

    registerGameShow(SGC_DISPLAY_INIT_EMBATTLE_ROLES,CMD_GC_DISPLAY_INITROLEEMBATTLE,DisplayInitBattleRole)
    registerGameShow(SGC_DISPLAY_UPDATE_EMBATTLE_ROLES_RET,CMD_GC_DISPLAY_UPDATEROLEEMBATTLERET,DisplayUpdateEmbattleRolesRet)

    registerGameShow(SGC_DISPLAY_SYSTEMINFO, CMD_GC_DISPLAY_SYSTEMINFO, DisplaySystemInfo)
    registerGameShow(SGC_DISPLAY_ROLE_RANDOM_WISHREWARDS, CMD_GC_DISPLAY_RANDOMWISHREWARDPOOL,DisplayWishRewardsRandom)
    registerGameShow(SGC_DISPLAY_ROLE_WISHREWRAD, CMD_GC_DISPLAY_CHOOSEWISHREWARDS,DisplayRoleChooseWishReward)
    
    registerGameShow(SGC_DISPLAY_ROLEWISHTASKS, CMD_GC_DISPLAY_ROLEWISHTASKS, DisplayRoleWishTasks)
    registerGameShow(SGC_DISPLAY_WISHTASKUPDATE,CMD_GC_DISPLAY_WISHTASKUPDATE,DisplayWishTaskUpdate)
    registerGameShow(SGC_DISPLAY_WISHTASKDELETE,CMD_GC_DISPLAY_WISHTASKDELETE,DisplayWishTaskDelete)

    registerGameShow(SGC_DISPLAY_DISPOSITION, CMD_GC_DISPLAY_DISPOSITION, DisplayDisposition)
    registerGameShow(SGC_DISPLAY_INTERACT_REFRESHTIMES_UPDATE, CMD_GC_DISPLAY_INTERACT_REFRESHTIMES_UPDATE, DisplayRefreshTimes)
    
    registerGameShow(SGC_DISPLAY_TAGUPDATE, CMD_GC_DISPLAY_TAGUPDATE, DisplayTaskTagUpdate)
    registerGameShow(SGC_DISPLAY_TAGDELETE, CMD_GC_DISPLAY_TAGDELETE, DisplayTaskTagDelete)

    registerGameShow(SGC_DISPLAY_WEEKROUNDITEMOUT, CMD_GC_DISPLAY_WEEKROUNDITEMOUT, DisplayWeekRoundItemOut)

    registerGameShow(SGC_DISPLAY_MAZE_UPDATE, CMD_GC_DISPLAY_MAZEUPDATE, DisplayMazeUpdate)
    registerGameShow(SGC_DISPLAY_MAZE_CARD_UPDATE, CMD_GC_DISPLAY_MAZECARDUPDATE, DisplayMazeCardUpdate)
    registerGameShow(SGC_DISPLAY_MAZE_AREA_UPDATE, CMD_GC_DISPLAY_MAZEAREAUPDATE, DisplayMazeAreaUpdate)
    registerGameShow(SGC_DISPLAY_MAZE_GRID_UPDATE, CMD_GC_DISPLAY_MAZEGRIDUPDATE, DisplayMazeGridUpdate)
    registerGameShow(SGC_DISPLAY_MAZE_UNLOCK_GRID_CHOICE, CMD_GC_DISPLAY_MAZEUNLOCKGRIDCHOICE, DisplayMazeUnlockGridChoice)
    registerGameShow(SGC_DISPLAY_MAZE_UNLOCK_GRID_SUCCESS, CMD_GC_DISPLAY_MAZEUNLOCKGRIDSUCCESS, DisplayMazeUnlockGridSuccess)
    registerGameShow(SGC_DISPLAY_MAZE_MOVE, CMD_GC_DISPLAY_MAZEMOVE, DisplayMazeMove)
    registerGameShow(SGC_DISPLAY_MAZE_MOVE_TO_NEW_AREA, CMD_GC_DISPLAY_MAZEMOVETONEWAREA, DisplayMazeMoveToNewArea)
    registerGameShow(SGC_DISPLAY_DYNAMIC_ADV_LOOT_UPDATE, CMD_GC_DISPLAY_DYNAMICADVLOOTUPDATE, DisplayDynamicAdvLootUpdate)
    
    registerGameShow(SGC_DISPLAY_CLAN_INFO_UPDATE, CMD_GC_DISPLAY_CLAN_INFO_UPDATE, DisplayClanInfoUpdate)
    registerGameShow(SGC_DISPLAY_INTERACT_DATE_UPDATE, CMD_GC_DISPLAY_INTERACT_DATE_UPDATE, DisplayInteractDateUpdate)
    registerGameShow(SGC_DISPLAY_CLAN_BRANCH_INFO, CMD_GC_DISPLAY_CLAN_BRANCH_INFO_UPDATE, DisplayClanBranchInfo)
    registerGameShow(SGC_DISPLAY_CLAN_BRANCH_RESULT, CMD_GC_DISPLAY_CLAN_BRANCH_RESULT, DisplayClanBranchResult)

    registerGameShow(SGC_DISPLAY_ADD_INTERACT_OPTION, CMD_GC_DISPLAY_ADD_INTERACT_OPTION, DisplayAddInteractChoice)
    registerGameShow(SGC_DISPLAY_REMOVE_INTERACT_OPTION, CMD_GC_DISPLAY_REMOVE_INTERACT_OPTION, DisplayRemoveInteractChoice)

    registerGameShow(SGC_DISPLAY_ADD_ROLE_SELECT_EVENT, CMD_GC_DISPLAY_UPDATE_ROLE_SELECT_EVENT, DisplayAddRoleSelectEvent)
    registerGameShow(SGC_DISPLAY_REMOVE_ROLE_SELECT_EVENT, CMD_GC_DISPLAY_UPDATE_ROLE_SELECT_EVENT, DisplayRemoveRoleSelectEvent)

    registerGameShow(SGC_DISPLAY_END, CMD_GC_DISPLAY_END, DisplayEnd)
    registerGameShow(SGC_DISPLAY_UPDATE_TREASURE_BOX,CMD_GC_DISPLAY_BATTLE_UPDATETREASUREBOX,DisplayBattleUpdateTreasureBox)
    registerGameShow(SGC_DISPLAY_BATTLE_HURT_INFO,CMD_GC_DISPLAY_HURTINFO,DisplayBattleUpdateHurtInfo)
    registerGameShow(SGC_DISPLAY_BATTLE_BUFFDESC,CMD_GC_DISPLAY_BATTLE_BUFFDESC,DisplayBattleUpdateBuffDesc)
    registerGameShow(SGC_DISPLAY_BATTLE_UPDATEROUND,CMD_GC_DISPLAY_BATTLE_UPDATEROUND,DisplayBattleUpdateRound)

    registerGameShow(SGC_DISPLAY_ENTER_CITY, CMD_GC_DISPLAY_ENTERCITY, DisplayEnterCity)

    registerGameShow(SGC_DISPLAY_SHOW_FOREGROUND, CMD_GC_DISPLAY_SHOWFOREGROUND, DisplayShowForeground)

    registerGameShow(SGC_DISPLAY_TEMPBAG_LIST, CMD_GC_DISPLAY_TEMPBAG_UPDATE, DisplayTempBag)

    registerGameShow(SGC_DISPLAY_DRTIMER_UPDATE,CMD_GC_DISPLAY_DRTIMER_UPDATE,DisplayTimerUpdate)

    registerGameShow(SGC_DISPLAY_UNLOCK_ROLE, CMD_GC_CLICKUNLOCKROLE, DisplayUnlockRole)
    registerGameShow(SGC_DISPLAY_UNLOCK_SKIN, CMD_GC_CLICKUNLOCKSKIN, DisplayUnlockSkin)

    registerGameShow(SGC_DISPLAY_INVITEABLE_UPDATE, CMD_GC_DISPLAY_INVITEABLE_UPDATE, DisplayInviteUpdate)

    registerGameShow(SGC_DISPLAY_CLEAR_INTERACT_STATE, CMD_GC_DISPLAY_CLEARINTERACTSTATE, DisplayClearInteractState)
    registerGameShow(SGC_DISPLAY_TRIGGER_ADV_GIFT, CMD_GC_DISPLAY_TRIGGERADVGIFT, DisplayTriggerAdvGift)
    registerGameShow(SGC_DISPLAY_NEW_TOAST, CMD_GC_DISPLAYNEWTOAST, DisplayNewToast)
    registerGameShow(SGC_DISPLAY_DISPLAY_CUSTOM_PLOT, CMD_GC_DISPLAY_CUSTOM_PLOT, DisplayCustomPlotDialog)
    registerGameShow(SGC_DISPLAY_DYNAMICS_TOAST, CMD_GC_DISPLAY_DYNAMICS_TOAST, DisplayDynamicToast)
    registerGameShow(SGC_DISPLAY_SCRIPT_ROLE_TITLE, CMD_GC_DISPLAY_UPDATE_TITLEID, DisplayScriptRoleTitle)
    
    registerGameShow(SGC_DISPLAY_REDKNIFE_UPDATE, CMD_GC_DISPLAY_REDKNIFE_UPDATE, DisplayRedKnifeUpdate)
    registerGameShow(SGC_DISPLAY_REDKNIFE_DELETE, CMD_GC_DISPLAY_REDKNIFE_DELETE, DisplayRedKnifeDelete)

    registerGameShow(SGC_DISPLAY_BABYSTATE_UPDATE, CMD_GC_DISPALYBABYSTATE, DisplayBabyUpdate)
    
    registerGameShow(SGC_DISPLAY_UPDATE_UNLOCK_DISGUISE, CMD_GC_DISPLAY_UPDATEUNLOCKDISGUISE, DisplayUpdateUnlockDisguise)

    registerGameShow(SGC_DISPLAY_HIGHTOWER_BASE_INFO, CMD_GC_DISPLAY_HIGHTOWERBASEINFO, DisplayHighTowerBaseInfo)
    registerGameShow(SGC_DISPLAY_HIGHTOWER_REST_ROLES, CMD_GC_DISPLAY_HIGHTOWERRESTROLE, DisplayHighTowerRestRoles)

    registerGameShow(SGC_DISPLAY_FINALBATTLE_UPDATEINFO, CMD_GC_DISPLAY_FINALBATTLEUPDATEINFO, DisplayFinalBattleUpdateInfo)
    registerGameShow(SGC_DISPLAY_FINALBATTLE_UPDATECITY, CMD_GC_DISPLAY_FINALBATTLEUPDATECITY, DisplayFinalBattleUpdateCity)
    registerGameShow(SGC_DISPLAY_SHOWDATA_END_RECORD, CMD_GC_DISPLAY_SHOWDATAENDRECORD, DisplayShowDataEndRecord)
    registerGameShow(SGC_DISPLAY_UPDATE_DELEGATION_STATE, CMD_GC_DISPLAY_UPDATE_DELEGATION_STATE, DisplayUpdateDelegationTaskState)
    registerGameShow(SGC_DISPLAY_START_GUIDE, CMD_GC_DISPLAY_START_GUIDE, DisplayStartGuide)
    registerGameShow(SGC_DISPLAY_UNLEAVEABLE_UPDATE, CMD_GC_DISPLAY_UNLEAVEABLE_UPDATE, DisplayUnLeaveableUpdate)
    registerGameShow(SGC_DISPLAY_BATTLE_CALL_HELP, CMD_GC_DISPLAY_CALLHELPBACKINFO, DisplayCallHelpResult)
    registerGameShow(SGC_DISPLAY_UPDATE_CHOCIE_INFO, CMD_GC_DISPLAY_UPDATECHOICEINFO, DisplayUpdateChoiceInfo)
    registerGameShow(SGC_DISPLAY_CLEAR_CHOCIE_INFO, CMD_GC_DISPLAY_CLEARCHOICEINFO, DisplayClearChoiceInfo)
    registerGameShow(SGC_DISPLAY_PLAY_MAZE_ROLE_ANIM, CMD_GC_DISPLAY_PLAYMAZEROLEANIM, DisplayPlayMazeRoleAnim)
    registerGameShow(SGC_DISPLAY_SHOW_MAZE_ROLE_BUBBLE, CMD_GC_DISPLAY_SHOWMAZEROLEBUBBLE, DisplayShowMazeRoleBubble)
    registerGameShow(SGC_DISPLAY_MAZE_ENEMY_ESCAPE, CMD_GC_DISPLAY_MAZEENEMYESCAPE, DisplayMazeEnemyEscape)
    registerGameShow(SGC_DISPLAY_CLOSE_GIVE_GIFT, CMD_GC_DISPLAY_CLOSEGIVEGIFT, DisplayCloseGiveGift)
    registerGameShow(SGC_DISPLAY_INTERACT_DUEL_ROLES, CMD_GC_DISPLAY_DUELROLE, DisplayDuelRole)
    registerGameShow(SGC_DISPLAY_SHOW_CHOICE_WINDOW, CMD_GC_DISPLAY_SHOWCHOICEWINDOW, DisplayShowChoiceWindow)
    registerGameShow(SGC_DISPLAY_SHOW_CHOOSEROLE, CMD_GC_SHOWCHOOSEROLE, DisplayShowChooseRole)
    registerGameShow(SGC_DISPLAY_STARTSHARELIMITSHOP, CMD_GC_STARTSHARELIMITSHOP, DisplayStartShareLimitShop)

    registerGameShow(SGC_DISPLAY_AIINFO,CMD_GC_DISPLAY_AIINFO,DisplayAIInfo)
    registerGameShow(SGC_DISPLAY_MARTIALSTRONG,CMD_GC_DISPLAY_MARTIALSTRONG,DisplayMartialStrongResult)
    registerGameShow(SGC_DISPLAY_MAKEMARTIALSECRET,CMD_GC_DISPLAY_MAKEMARTIALSECRET,DisplayMakeMartialSecret)
    registerGameShow(SGC_DISPLAY_DIFFDROPINFO,CMD_GC_DISPLAY_DIFFDROPUPDATE,DisplayDiffDropInfo)

    registerGameShow(SGC_DISPLAY_RESDROP_ACTIVITY,CMD_GC_DISPLAY_RESDROPACTIVITY,DisplayResDropActivity)
    registerGameShow(SGC_DISPLAY_COLLECT_ACTIVITY_EXCHANGE_RES,CMD_GC_DISPLAY_COLLECTACTIVITYEXCHANGERES,DisplayCollectActivityExchangeRes)
    registerGameShow(SGC_DISPLAY_UPDATE_SAME_THREAD_PLAYER,CMD_GC_DISPLAY_UPDATESAMETHREADPLAYERINFO,DisplayUpdateSameThreadPlayer)
    registerGameShow(SGC_DISPLAY_NOTICE_CLIENT_FIGHT_PLAYER,CMD_GC_DISPLAY_NOTICECLIENTFIGHTPLAYER,DisplayNoticeClientFightPlayer)
    registerGameShow(SGC_DISPLAY_NOTICE_CLIENT_ADD_FRIEND,CMD_GC_DISPLAY_NOTICECLIENTADDFRIEND,DisplayNoticeClientAddPlayerFriend)

    registerGameShow(SGC_DISPLAY_LEVELUP,CMD_GC_DISPLAY_LEVELUP,DisplayLevelUP)
    registerGameShow(SGC_DISPLAY_CLEAR_ALL_CHOICE_INFO,CMD_GC_DISPLAY_CLEARALLCHOICEINFO,DisplayClearAllChoiceInfo)

    registerGameShow(SGC_DISPLAY_SHOW_COMMON_EMBATTLE,CMD_GC_DISPLAY_SHOWCOMMONEMBATTLE,DisplayShowCommonEmbattle)

    registerGameShow(SGC_DISPLAY_CUSTOM_ADV_LOOT_UPDATE, CMD_GC_DISPLAYUPDATECUSTOMADVLOOT, DisplayUpdateCustomAdvLoot)

    registerGameShow(SGC_DISPLAY_AUTO_BATTLE_TEST_REPLAY, CMD_GC_DISPLAYAUTOBATTLETESTREPLAY, OnRecv_CMD_GAC_ARENABATTLERECORDDATA)
    registerGameShow(SGC_SHOW_DIALOG, CMD_GC_SHOWDIALOG, ShowDialog)

    registerGameShow(SGC_DISPLAY_ROLE_FACE_QUERY, CMD_GC_DISPLAY_ROLEFACEQUERY, OnRecv_CMD_GC_DISPLAY_ROLEFACEQUERY)
    registerGameShow(SGC_DISPLAY_ROLE_FACE_RESULT, CMD_GC_DISPLAY_ROLEFACERESULT, OnRecv_CMD_GC_DISPLAY_ROLEFACERESULT)
    registerGameShow(SGC_DISPLAY_DISGUISE, CMD_GC_DISPLAY_DISGUISE, OnRecv_CMD_GC_DISPLAY_DISGUISE)
end

function registerGameCommand(iCmd, ProcFunc)
    NetGameMsgProcFuncPool[iCmd] = ProcFunc
end

-- 单机 SSD_XXX itype对应的 CMD_XXX 
function registerGameShow(iType,iCMD,func)
    if  GameLogicShowFuncPool[iType] ~= nil then
        derror("Type "..iType.." Not Alone")
    end
    GameLogicShowFuncPool[iType] = {}
    GameLogicShowFuncPool[iType].func = func
    GameLogicShowFuncPool[iType].iCMD = iCMD
end

function removeGameCommand(iCmd)
    NetGameMsgProcFuncPool[iCmd] = nil
end

function OnNetGameMsg(iCmd, netStreamValue)
    dprint("[NetGameMSg]->OnNetGameMsg Townserver iCmd:" .. iCmd .. "-----")
    local fDecodeFunc = GetGASToCLDecodeFuncByCmd(iCmd)
    if fDecodeFunc ~= nil then
        local kRetData = fDecodeFunc(netStreamValue)
        if NetGameMsgProcFuncPool[iCmd] ~= nil then
            NetGameMsgProcFuncPool[iCmd](kRetData)
        end
    end
end

function OnGameNetConnected(bReconnect)
    dprint("[NetGameMSg]->OnGameNetConnected")

    ShowServerAndUID();
    
    -- 网络连接成功后立刻连接
    local session = 0
    local playerid = GetConfig("index")
    local bReconnect = false
    -- if DEBUG_MODE then 
        --playerid = 280680332
    -- end
    local msangoMagic = SERVER_MAGIC_VALUE
    local gameservertoken = G_UID and tostring(G_UID) or ""
    local openid = "pc"

    local deviceName = "pc"
    local deviceID = "id"
    local loginRet = 1
    local platid = 99

    local ThirdOpenId = ""         -- vopenid
    local loginChannel = "0"
    local OpenKey = "Guest"
    local channel = "pc"

    local iTencentPrivate = 0

    local isguest = 1

    local iClientLoginMethod = 0

    local systemProtoTableInfo = {
        ['acClientVersion'] = "Error VersionCode",          -- 客户端版本号
        ['acSystemSoftware'] = '',
        ['acSystemHardware'] = '',
        ['acTelecomOper'] = '',
        ['iScreenWidth'] = 0,
        ['iScreenHight'] = 0,
        ['acNetwork'] = '',
        ['acDensity'] = '',
        ['iRegChannel'] = tonumber(loginChannel),        -- 注册渠道
        ['acCpuHardware'] = '',
        ['iMemory'] = 0,
        ['acGLRender'] = '',
        ['acGLVersion'] = '',
        ['acDeviceId'] = tostring((deviceID or 'Error Device')),                  -- 设备ID
        ['acAndroidId'] = '',
        ['acRealIMEI'] = '',
        ['acIdfv'] = '',
        ['dwPlatID'] = platid,
        ['iTssSDKLen'] = 0,
        ['acSecTssSDK'] = '',
        ['acVOpenID'] = tostring(ThirdOpenId),
        ['acGOpenId'] = "ErrorOpenID",        -- 这个错误码 ErrorOpenID 千万不要改,colourstar
        ['iClientLoginMethod'] = iClientLoginMethod,
        ['iTencentPrivate'] = iTencentPrivate,
        ['acPF'] =  "",
        ['acPFKey'] =  "",
        ['acOpenKey'] = OpenKey,
        ['isGuest'] = isguest,
        ['iLoginChannel'] = channel,
        ['dwOS'] = 0,
    }

    local binData, iCmd =  EncodeSendSeCGA_PlayerValidate(msangoMagic,playerid,session,1,gameservertoken, systemProtoTableInfo, bReconnect or 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);

    -- TODO
    --SendQueryPublicJWT();
    --CheckToken();
    --RefreshCommonData();
end

local RECONNECT_MAX_COUNT = 2
local RECONNECT_TIME = SSD_MAX_CLIENT_RECONTENT_INTERVAL or 10
local iReconnectHandle = 0
local iCurConnectCount = 0

local ResetReconnectData = function()
    globalTimer:RemoveTimer(iReconnectHandle)
    iReconnectHandle = 0
    iCurConnectCount = 0
    globalDataPool:setData("GameReconnect",0,true)
end

function OnReconnectSuccess(bSuccess)
    ResetReconnectData()
    if  bSuccess then
        RemoveWindowImmediately("LoadingUI")
        GuideDataManager:GetInstance():ContinueGuide()
        LogicMain:GetInstance():ProcessReconnect()

        LuaEventDispatcher:dispatchEvent('GAME_RECONNECT')
        g_hasReconnected = true
	-- 迷宫同步数据下来后, 强刷界面
        MazeDataManager:GetInstance():RefreshMazeLayerWhenSyncData()
        g_lastHeartBeatCheckTime = nil
    else
        RemoveWindowImmediately("LoadingUI")
        -- ReturnToLogin(function() SystemUICall:GetInstance():Toast("重连失败",false) end) 
        DRCSRef.NetMgr:Disconnect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER)
        local generalBoxUI = GetUIWindow('GeneralBoxUI')
        if generalBoxUI then 
            -- 重连窗口弹出前清空队列避免重连窗口无法显示
            generalBoxUI:ClearMsgQueue()
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.SYSTEM_Reconnect})
        g_hasReconnected = false
    end
end

local OnReConnectNet = function()
    iCurConnectCount = iCurConnectCount + 1
    if iCurConnectCount >= RECONNECT_MAX_COUNT then
        --重连几次 没成功踢回登陆 
        OnReconnectSuccess(false)   
    else
        local host = globalDataPool:getData("GameServerHost")
        local port = globalDataPool:getData("GameServerPort")   
        if host and port then
            DRCSRef.NetMgr:Disconnect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER)
            DRCSRef.NetMgr:Connect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER,host,port) 
            globalDataPool:setData("GameReconnect",1,true)
        else
            OnReconnectSuccess(false)
        end
    end
end

StartReconnect = function()
    globalDataPool:setData("LOGIN_SUCCESS",0,true)
    OpenWindowImmediately("LoadingUI", {bUnload = false})
    iReconnectHandle = globalTimer:AddTimer(RECONNECT_TIME * 1000,OnReConnectNet,RECONNECT_MAX_COUNT - 1)
    globalTimer:AddTimer(100,OnReConnectNet)
end

function OnGameNetDisConnected(bRecordLoginFail)
    -- 收到服务器下行, 关闭登录等待界面
    local winLogin = GetUIWindow("LoginUI")
    if winLogin then
        winLogin:SetWaitingAnimState(false)
    end
    local bLoginSuccess = globalDataPool:getData("LOGIN_SUCCESS")
    dprint("[NetGameMSg]->OnGameNetDisConnected")
    if bRecordLoginFail == false then --服务器主动踢的 直接到登陆界面
        iReconnectHandle = 0
        MSDKHelper:StopTssReport()
        GuideDataManager:GetInstance():StopGuide()
        ReturnToLogin(function() SystemUICall:GetInstance():Toast("游戏遇到异常",false) end)
        UPSMgr:ReportDisconnect(1,1000)
        globalTimer:RemoveTimerNextFrame(g_RequestServerTimeTimer)
    else
        if iReconnectHandle == 0 and bLoginSuccess == 1 then
            UPSMgr:ReportDisconnect(0,1)
            GuideDataManager:GetInstance():StopGuide()
            StartReconnect()
        end
    end
end

function OnGameNetTimeOut()
    dprint("[NetGameMSg]->OnGameNetTimeOut")
    if HttpHelper:GetUseBackupEndPointLoginFlag() then
        UPSMgr:ReportConnectSeverfail(3)
    else
        UPSMgr:ReportConnectSeverfail(2)
    end
    UPSMgr:ReportDisconnect(2,1)
    local bKeepLoading = false
    local iGameReconnect = globalDataPool:getData("GameReconnect")
    if iGameReconnect ~= 1 then
        bKeepLoading = DealLoginTimeOut()
    end
    -- 收到服务器下行, 关闭登录等待界面
    if bKeepLoading then
        return
    end
    local winLogin = GetUIWindow("LoginUI")
    if winLogin then
        winLogin:SetWaitingAnimState(false)
    end
end

-- 处理登录超时
function DealLoginTimeOut()
    -- 登录超时的时候, 尝试获取备用节点再次连接
    local kBackupEndPoint, uiTryConnectTimes = HttpHelper:PopGameServerEndPoints()
    if kBackupEndPoint 
    and kBackupEndPoint.host and (kBackupEndPoint.host ~= "")
    and kBackupEndPoint.port then
        if uiTryConnectTimes and (uiTryConnectTimes > 1) then
            SystemUICall:GetInstance():Toast(string.format("正在进入游戏...(%d)", uiTryConnectTimes), false)
        else
            SystemUICall:GetInstance():Toast('正在进入游戏...', false)
        end
        globalDataPool:setData("GameServerHost", kBackupEndPoint.host, true)
        globalDataPool:setData("GameServerPort", kBackupEndPoint.port, true)  
        HttpHelper:SetUseBackupEndPointLoginFlag(true)
        DRCSRef.NetMgr:Disconnect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER)
        DRCSRef.NetMgr:Connect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, kBackupEndPoint.host, kBackupEndPoint.port)
        return true
    end
    -- 若没有可用的备用节点, 则提示连接超时
    local strDetail = GetLoginFailExtraInfo() or ""
    local strMsg = string.format("<size=26>无法进入游戏，请重启后再试一次</size><size=20>\n\n错误信息：%s\n如多次重启仍无法进入游戏, 请将此信息截图反馈</size>", strDetail)
    SystemUICall:GetInstance():WarningBox(strMsg)
    -- PlayerSetDataManager:GetInstance():RecordLoginFail()  -- 超时暂时不计算为登录失败
    return false
end

function ProcessLogicShowCmd(iCmdType,kRetData,iSize)
    if g_processDelStory then 
        -- 删档处理时的逻辑下行不做处理
        return
    end
    GameLogicShowFuncPool[iCmdType].func(kRetData)
    if DEBUG_CHEAT then 
        UpdateDownloadNetMsgStat(iSize)
    end
end

function OnArenaReplayData(ArenaBattleRecordData)
    if ARENA_PLAYBACK_DATA and ArenaBattleRecordData.winPlayerID ~= 0 then
        ARENA_PLAYBACK_DATA.defPlyWinner = ArenaBattleRecordData.winPlayerID;
    end
    ArenaDataManager:GetInstance():ReceiveReplayerData(ArenaBattleRecordData)
end

local CMD_PROCESS_DATA = {
    [SGC_DISPLAY_BEGIN] = true,
    [SGC_DISPLAY_END] = true,
    [SGC_DISPLAY_TASKUPDATE] = true,
    [SGC_DISPLAY_TASKADD] = true,
    [SGC_DISPLAY_TASK_REMOVE] = true,
    [SGC_DISPLAY_SHOW_CHOICE_WINDOW] = true,
    [SGC_DISPLAY_UPDATE_CHOCIE_INFO] = true,
    [SGC_DISPLAY_CLEAR_CHOCIE_INFO] = true,
}
-- 逻辑指令命令前端进行显示函数
function OnGameLogicShowCmd(iPlayerID, netStreamValue, iSize)
    -- 收到消息就重置心跳检查
    g_lastHeartBeatCheckTime = nil
    local iCmdType = netStreamValue:ReadInt()
    local iDataSize = netStreamValue:ReadInt()
    if DEBUG_MODE then
        dprint(string.format("OnGameLogicShowCmd,iPlayerID : %d, iCmdType : %d, iSize : %d, iDataSize : %d",iPlayerID,iCmdType,iSize,iDataSize))
    end
    if GameLogicShowFuncPool[iCmdType] ~= nil then
        local start_t = 0
        if DEBUG_MODE then
            start_t = os.clock()
        end
        local fDecodeFunc = GetGCSToGCSDecodeFuncByCmd(GameLogicShowFuncPool[iCmdType].iCMD)
        if fDecodeFunc ~= nil then
            local kRetData = fDecodeFunc(netStreamValue)
            if DEBUG_MODE then
                dprint("OnGameLogicShowCmd decode spend:",iCmdType,os.clock() - start_t)
            end
            OnNetMessageRecordInsert(iCmdType, iDataSize)
            if IsLoadingSceneAsync() then 
                -- 加载场景时缓存下行
                CacheGameLogicShowCmd(iCmdType, kRetData, iSize)
            else
                -- if CMD_PROCESS_DATA[iCmdType] ~= true and LogicMain:GetInstance():HasBattleMsg() then
                --     LogicMain:GetInstance():SaveOtherMsg(iCmdType,kRetData,iSize)
                -- else
                    ProcessLogicShowCmd(iCmdType,kRetData,iSize)
                -- end
            end
        end
        return
    end
    if DEBUG_MODE then 
        SystemTipManager:GetInstance():AddPopupTip("疑似双端版本不一致\n收到逻辑指令返回消息,消息类型为空: " .. tostring(iCmdType))
    end
end

function CacheGameLogicShowCmd(iCmdType, kRetData, iSize)
    g_gameLogicCmdCacheList = g_gameLogicCmdCacheList or {}
    table.insert(g_gameLogicCmdCacheList, {
        iCmdType = iCmdType,
        kRetData = kRetData,
        iSize = iSize
    })
end

function ProcessGameLogicShowCmdCache()
    if g_gameLogicCmdCacheList == nil then 
        return
    end
    if IsLoadingSceneAsync() then 
        return
    end
    for _, cmdInfo in ipairs(g_gameLogicCmdCacheList) do 
        ProcessLogicShowCmd(cmdInfo.iCmdType, cmdInfo.kRetData, cmdInfo.iSize)
    end
    g_gameLogicCmdCacheList = nil
end

function ReplayBattleCmd(iCmdType,kNetStream)
    local kRetData
    if GameLogicShowFuncPool[iCmdType] ~= nil then
        local fDecodeFunc = GetGCSToGCSDecodeFuncByCmd(GameLogicShowFuncPool[iCmdType].iCMD)
        if fDecodeFunc then 
            kRetData = fDecodeFunc(kNetStream)
        end
    end
    if iCmdType ~= SGC_DISPLAY_BEGIN and iCmdType ~= SGC_DISPLAY_END then 
        if kRetData ~= nil then
            GameLogicShowFuncPool[iCmdType].func(kRetData)
        end
    end
end


----------------- 系统功能开关

-- 弹珠系统开关
function UpdateSmeltSpecialSwitch()
    -- 如果存在导航栏, 那么禁止导航栏上按钮的点击
    local win = GetUIWindow("ForgeUI")
    if win then
        win:UpdateSmeltSpecialSwitch()
    end
end

-- 百宝书赠送开关
function TreasureBookSendSwitch(bOpen)
    TreasureBookDataManager:GetInstance():SetTreasureBookSendSwitch(bOpen)
end

--- 收到开关变化后的处理函数
local registerCmd = {
    [SGLST_HOODLELOTTERY] = function(bOpen)
        HoodleSystemSWitch(bOpen)
    end,
    [SGLST_SMELT_SPECIAL] = UpdateSmeltSpecialSwitch,
    [SGLST_GIVEFRIEND_TREASUREBOOK] = function(bOpen)
        TreasureBookSendSwitch(bOpen)
    end
}
local _RecordSwitchInfo = {}
function OnRecv_CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFY(kRetData)
    local bOpen = (kRetData.bOpen == 1)
    local eSystem = kRetData.eSwitch
    _RecordSwitchInfo[eSystem] = bOpen
    if registerCmd[eSystem] then
        registerCmd[eSystem](bOpen)
    end
end

function OnRecv_CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFYALL(kRetData)
    for i=0,kRetData.iNum-1 do
        OnRecv_CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFY(kRetData.akChooseAchieveRewardID[i])
    end
end

function QuerySystemIsOpen(GameLogicSwitchType)
    if _RecordSwitchInfo[GameLogicSwitchType] == nil then 
        return false
    end
    return _RecordSwitchInfo[GameLogicSwitchType]
end

-- 弹珠系统开关
function HoodleSystemSWitch(bOpen)
    -- 如果存在导航栏, 那么禁止导航栏上按钮的点击
    local win = GetUIWindow("NavigationUI")
    if win and win.btnBtnPinball then
        win.btnBtnPinball.interactable = bOpen
    end
    -- 如果弹珠界面为打开状态, 那么禁止弹珠发射按钮的点击
    win = GetUIWindow("PinballGameUI")
    if win and win.btnShoot then
        win.btnShoot.interactable = bOpen
    end
end


-- 获取登录错误额外信息
function GetLoginFailExtraInfo(eErroeCode)
    local strZoneID = GetConfig("LoginZone") or "X"
    local strReqHost = globalDataPool:getData("GameServerHost") or "X"
    local strReqPort = globalDataPool:getData("GameServerPort") or "X"
    local strDetail = string.format("Z%sH%sP%s", tostring(strZoneID), tostring(strReqHost), tostring(strReqPort))
    if eErroeCode then
        strDetail = strDetail .. string.format("C%s", tostring(eErroeCode))
    end
    return strDetail
end

function OnRecv_GAC_PlayerValidRet(kRetData)
    dprint("[NetGameMSg]->OnRecv_GAC_PlayerValidRet")
    g_hasReconnected = false
    -- 这里做一个版本号提示
    local serverVersionCode = kRetData.acVersionCode
    SetConfig("ServerVersionCode", serverVersionCode or "")
    globalDataPool:setData("GameMode","ServerMode")
    local iGameReconnect =  globalDataPool:getData("GameReconnect")
    local eErroeCode = kRetData.eValidateType
    if (eErroeCode == SVT_VALIDATE_OK) or (eErroeCode == SVT_CHAR_NOT_EXIST) then
        -- 把进入酒馆延迟到了 初始化玩家信息 完成后
        -- OpenWindowImmediately("LoadingUI")
        -- ChangeScenceImmediately("House","LoadingUI",function()
        --     OpenWindowImmediately("HouseUI")
        -- end)
        OnReconnectSuccess(true)
        if IsBattleOpen() then --重连 需要把战斗状态清除了
            LogicMain:GetInstance():Clear()
        end
        globalDataPool:setData("GameData",nil,true)
        globalDataPool:setData("LOGIN_SUCCESS",1,true)
    elseif eErroeCode == SVT_REBUILD_CONNECT then
        globalDataPool:setData("LOGIN_SUCCESS",1,true)
        OnReconnectSuccess(true)
    elseif (eErroeCode == SVT_JWT_CHEAT_TIME or eErroeCode == SVT_INVALID_LOGIN_TRY_TIME) and iGameReconnect == 1 then --token失效的重连 踢回到登陆界面
        globalDataPool:setData("LOGIN_SUCCESS",1,true)
        ResetReconnectData()
        ReturnToLogin(function()  
            SystemUICall:GetInstance():Toast("token失效,请重新登录")
        end) 
    elseif (eErroeCode == SVT_GAME_SCRIPT_DUMP) then
        local strDetail = GetLoginFailExtraInfo(eErroeCode) or ""
        OpenWindowImmediately("SystemCrashUI",strDetail)
    else
        globalDataPool:setData("LOGIN_SUCCESS",0,true)
        -- 读表获取错误码
        local kErrorCodeInfo = TableDataManager:GetInstance():GetTableData('ErrorCode', eErroeCode)
        if not kErrorCodeInfo then
            kErrorCodeInfo = TableDataManager:GetInstance():GetTableData('ErrorCode', -1)
        end
        local strErrorMsg = nil
        if kErrorCodeInfo then
            strErrorMsg = kErrorCodeInfo.Ch_Text or ""
        end
        if (not strErrorMsg) or (strErrorMsg == "") then
            strErrorMsg = "登录验证结果返回错误"
        end
        -- 错误详细数据
        local strDetail = GetLoginFailExtraInfo(eErroeCode) or ""
        local strTips = string.format("<size=26>%s</size><size=20>\n\n错误信息：%s\n如多次重启仍无法进入游戏, 请将此信息截图反馈</size>", strErrorMsg, strDetail)
        -- Debug模式下, 附上实际错误
        local strDebugInfo = nil
        if kErrorCodeInfo then
            strDebugInfo = kErrorCodeInfo.Debug_Text or ""
        end
        if DEBUG_MODE and strDebugInfo and (strDebugInfo ~= "") then
            strTips = strTips .. "\n<size=20><color=#913E2B>调试信息: " .. strDebugInfo .. "</color></size>"
        end
        SystemUICall:GetInstance():WarningBox(strTips)

        PlayerSetDataManager:GetInstance():RecordLoginFail()
        if iGameReconnect == 1 then
            OnReconnectSuccess(false)
        end
    end
    globalDataPool:setData("GameReconnect",0,true)
    -- 收到服务器下行, 关闭登录等待界面
    local winLogin = GetUIWindow("LoginUI")
    if winLogin then
        winLogin:SetWaitingAnimState(false)
    end
    --DRCSRef.InitGameModules()
end

-- 服务器踢人
function OnRecv_CMD_GAC_KickPlayer(kRetData)
    dprint("[NetGameMSg]->OnRecv_CMD_GAC_KickPlayer")
    OnGameNetDisConnected(false)
end

-- 更新系统模块开启状态
function OnRecv_CMD_GAC_UpdateSystemModuleEnableState(kRetData)
    local size = kRetData.iNum
    local systemModuleState = {}
    for i = 0, size - 1 do 
        systemModuleState[i] = (kRetData.abSystemModuleEnableState[i] == 1)
    end
    UpdateSystemModuleEnableState(systemModuleState)
end

-- 初始化玩家信息
function OnRecv_CMD_GAC_InitPlayerInfo(kRetData)
    local function VersionCompareJudge()
        local serverVersionCode = GetConfig("ServerVersionCode")
        -- if (VersionCodeCompare(serverVersionCode, CLIENT_VERSION) > 0) then
        --     local strMsg = string.format("您的客户端版本号(%s)小于服务器版本号(%s)，请退出更新游戏或联系官方人员", CLIENT_VERSION, serverVersionCode )
        --     if (MSDK_OS ~= 2) then
        --         OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strMsg, function()
        --           if (MSDK_MODE ~= 0) then
        --             QuitGame()
        --           end
        --         end ,{cancel = false, close = false, confirm = true}})
        --     end
        -- end
    end

    local function RequestServerTime()
        -- 请求服务器时间
        if g_RequestServerTimeTimer then
            globalTimer:RemoveTimer(g_RequestServerTimeTimer)
            g_RequestServerTimeTimer = nil
        end
        local requestServertDelay = 1 * 60 * 1000
        g_RequestServerTimeTimer = globalTimer:AddTimer(requestServertDelay, function()
            if g_lastHeartBeatCheckTime ~= nil then
                OnGameNetDisConnected(false)
                derror("GAC心跳超时")
            else    
                SendQuestServerTime()
            end
        end, -1)
    end

    local function InitSendQQData()
        -- TODO QQ 数据上报由 msdk 的登录修改为我们服务器数据下行之后
        MSDKHelper:InitQQAchievementData();
        MSDKHelper:InitOnlineTime()
        if globalTimer then
            dprint("globalTimer:AddTimer(300000")
            globalTimer:AddTimer(1000 * 60 * 5,function()
                MSDKHelper:UpdateOnlineData()
            end)
        end
        MSDKHelper:SendAchievementsData('login')
    end

    -- 开启自动登录
    g_IS_AUTOLOGIN = true

    ResetGame()
    
    --MSDKHelper:StartTssReport()
    IS_RECONNECT = false
    dprint("[NetGameMSg]->OnRecv_CMD_GAC_InitPlayerInfo")
    globalDataPool:setData("PlayerInfo",kRetData,true)
    PlayerSetDataManager:GetInstance():InitPlayerInfo(kRetData)
    --InitSendQQData();

    -- 初始化玩家信息后登陆讨论区
    if DiscussDataManager:GetInstance():DiscussAreaOpen() then
        DiscussDataManager:GetInstance():Login()
    end

    -- 成功登录, 清空服务器登录失败记录
    PlayerSetDataManager:GetInstance():ClearForbidLoginData()
    
    --非首次登录查询一次玩家禁用信息
    local lastLogoutTime = PlayerSetDataManager:GetInstance():GetLastLogoutTime();
    if lastLogoutTime ~= 0 then
        SendQueryForBidInfo()
    end

    -- 请求同步服务器时间
    SendQuestServerTime()
    RequestServerTime()

    --登陆成功查询一次金锭数据
    SendQueryPlayerGold(false)

    SendQueryTreasureBookInfo(STBQT_TASK,0,STBTT_ACTIVITY_BACKFLOW)
    
    SendMeridiansOpr(SMOT_REFRESH_ALL, 0)
    
    -- 如果解锁了酒馆, 那么进入酒馆场景, 否则, 不加载酒馆场景
    -- OpenWindowImmediately("LoadingUI")
    TableDataManager:GetInstance():LoadInitTable()
    -- local kCommonInfo = kRetData.kCommInfo
    -- if (not kCommonInfo) then
    --     ChangeScenceImmediately("Town", "LoadingUI", function()
    --         PlayerSetDataManager:GetInstance():SetGuideModeFlag(true)
    --         VersionCompareJudge()
    --     end)
    --     return
    -- else
    --     ChangeScenceImmediately("Town", "LoadingUI", function()
    --         local kStoryUI = OpenWindowImmediately("StoryUI")
    --         if kStoryUI then
    --             kStoryUI:StartAnimaition()
    --         end
    --     end)
    -- end

    -- 如果当前未解锁酒馆,那么发送进入剧本消息
    -- if (kCommonInfo.bUnlockHouse == 0) then
    --     derror("--------------------2")
    --     if kCommonInfo.dwPlayerLastScriptID == 0 then 
    --         kCommonInfo.dwPlayerLastScriptID = 2
    --     end
    --     local enterScriptID = kCommonInfo.dwPlayerLastScriptID
    --     PlayerSetDataManager:GetInstance():SetGuideModeFlag(true)
    --     VersionCompareJudge()
    --     EnterStory(enterScriptID, false, true)
    --     -- ChangeScenceImmediately("Town", "LoadingUI", function()
    --     -- end)
    --     return
    -- end

    -- 如果玩家没有给自己起过名字, 那么进入酒馆后开启酒馆引导
    -- local kStoryUI = OpenWindowImmediately("StoryUI")
    -- if kStoryUI then
    --     kStoryUI:StartAnimaition()
    -- end
    do return end

    local bIsNewBee = (not kRetData.dwReNameNum) or (kRetData.dwReNameNum == 0)
    ChangeScenceImmediately("House", "LoadingUI", function()
        if bIsNewBee then
            local iRenameGuideID = 21
            GuideDataManager:GetInstance():ClearGuide(iRenameGuideID)
            GuideDataManager:GetInstance():StartGuideByID(iRenameGuideID)
        end
        OpenWindowImmediately("HouseUI")
        VersionCompareJudge()
    end)

    SendActivityOper(SAOT_EVENT,0, SATET_FESTIVAL_ASSET_CLEAN_CHECK, 0 ,0)
end

function OnRecv_CMD_GAC_PlayerAppearanceInfoDataRet(kRetData)
    -- 目前只刷新当前老板娘
    PlayerSetDataManager:GetInstance():SetLandLadyID(kRetData["kAppearanceInfo"]["dwLandLadyID"])
end


-- 下发其他玩家酒馆站位信息
function OnRecv_CMD_GAC_PlatPlayerSimpleInfos(kRetData)
    dprint("[NetGameMSg]->OnRecv_CMD_GAC_PlatPlayerSimpleInfos")
    local eOptType = kRetData.eOptType
    if eOptType == PSIOT_AREA then
        if not IsWindowOpen("HouseUI") then
            return
        end
        local win = GetUIWindow("HouseUI")
        if win.OnReceiveAreaPlayersData then
            win:OnReceiveAreaPlayersData(kRetData)
        end
    elseif eOptType == PSIOT_LIST then
        if not IsWindowOpen("TownPlayerListUI") then
            return
        end
        local win = GetUIWindow("TownPlayerListUI")
        win:OnRecivePlayerListData(kRetData)
    end
end

-- 请求酒馆玩家详细信息
function OnRecv_CMD_GAC_PLATPLAYERDETAILINFO(kRetData)
    dprint("[NetGameMSg]->OnRecv_CMD_GAC_PLATPLAYERDETAILINFO")
    if not kRetData then
        return
    end
    OpenWindowImmediately("PlayerMsgMiniUI", kRetData)

    local window = GetUIWindow('SelectUI')
    if window and window:IsOpen() then 
        window:Exit()
    end 
end

-- 玩家功能数据
function OnRecv_CMD_GAC_PLAYERFUNCTIONINFODATARET(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PLAYERFUNCTIONINFODATARET=====>')
    if kRetData.kFuncInfo and next(kRetData.kFuncInfo) then
        local playerSetDataManager = PlayerSetDataManager:GetInstance();
        playerSetDataManager:SetLowInCompleteTextNum(kRetData.kFuncInfo.dwLowInCompleteTextNum);
        playerSetDataManager:SetMidInCompleteTextNum(kRetData.kFuncInfo.dwMidInCompleteTextNum);
        playerSetDataManager:SetHighInCompleteTextNum(kRetData.kFuncInfo.dwHighInCompleteTextNum);
        playerSetDataManager:SetMeridianTotalLvl(kRetData.kFuncInfo.dwMeridianTotalLvl);

        local win = GetUIWindow('CollectionUI');
        if win and win:IsOpen() and win.collectionMartialUI then
            win.collectionMartialUI:RefreshUI();
        end
    end
end

function OnRecv_CMD_GAC_PLAYERCOMMONINFODATARET(kRetData)
    if kRetData.kCommInfo and next(kRetData.kCommInfo) then
        local playerSetDataManager = PlayerSetDataManager:GetInstance();
        playerSetDataManager:SetWeekRoundTotalNum(kRetData.kCommInfo.dwWeekRoundTotalNum);
        
        local win = GetUIWindow('PlayerSetUI');
        if win and win:IsOpen() then
            win:RefreshUI();
        end
    end
end

function OnRecv_CMD_GAC_SETCHARPICTUREURLRET(kRetData)
    --头像URL 提示信息
    PlayerSetDataManager:GetInstance():SetCharPictureUrl(kRetData["charPicUrl"])
    --SystemUICall:GetInstance():Toast("头像url上传设置成功")
    --TODO设置UI勾选显示
    --SystemUICall:GetInstance():Toast("getcharpicture"..PlayerSetDataManager:GetInstance():GetCharPictureUrl())
    
end

--玩家基础信息变化
function OnRecv_CMD_GAC_BaseInfoUpdate(kRetData)
    local eChangeType = kRetData["eChangeType"]
    local curNum = kRetData["dwCurNum"]
    if eChangeType == SCBOT_SILVER then
        PlayerSetDataManager:GetInstance():SetPlayerSliver(curNum)
    elseif eChangeType == SCBOT_JINGMAIEXP then
        MeridiansDataManager:GetInstance():SetCurTotalExp(curNum)
    end

    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then 
        windowBarUI:UpdateWindow()
    end
end

-- 玩家操作剧本
function OnRecv_CMD_GAC_ScriptOprRet(kRetData)
    if not kRetData then
        return
    end
    -- 存入最新的难度数据
    if (kRetData.bOpr == SORT_SUCCESS) and kRetData.kUnlockScriptInfo then
        local playerinfo = globalDataPool:getData("PlayerInfo")
        if playerinfo then
            local iMaxDiff = nil
            local bHasUpdate = false
            iMaxDiff = 1 --kRetData.kUnlockScriptInfo.dwUnlockMaxDiff or 0
            if iMaxDiff > 0 then
                for i = 0, playerinfo.iSize - 1 do
                    if playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == kRetData.dwScriptID then
                        playerinfo.kUnlockScriptInfos[i] = kRetData.kUnlockScriptInfo
                        bHasUpdate = true
                    end
                end
                -- 如果上面没有找对应的剧本解锁数据, 直接将服务器下发的数据插入到数组中
                if not bHasUpdate then
                    playerinfo.kUnlockScriptInfos[playerinfo.iSize] = kRetData.kUnlockScriptInfo
                    playerinfo.iSize = playerinfo.iSize + 1
                end
            end
            globalDataPool:setData("PlayerInfo", playerinfo)
        end
    end
    if (kRetData.eOprType == SEOT_ENTER) then               -- 进入剧本返回
        if g_processDelStory then 
            -- 删档处理时的进入剧本不做处理
            return
        end
        local loadingUI = GetUIWindow('LoadingUI')
        if loadingUI then 
            loadingUI:ResetTimer()
            RemoveWindowImmediately('LoadingUI')
        end
        -- 为了防止排队提示残留, 清除一下弹窗
        local generalBoxUI = GetUIWindow('GeneralBoxUI')
        if generalBoxUI then 
            generalBoxUI:ClearMsgQueue()
        end
        RemoveWindowImmediately('GeneralBoxUI')
        if kRetData.bOpr == SORT_SUCCESS then
            SetCurScriptID(kRetData.dwScriptID)
            globalDataPool:setData("CurScriptTime",kRetData.kUnlockScriptInfo.dwScriptTime,true)
            OpenWindowImmediately('LoadingUI')
            -- 进入剧本
            ChangeScenceImmediately('Town', 'LoadingUI')
        elseif kRetData.bOpr == SORT_UNAVALIABLE then
            -- 剧本维护中
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
                text = GetLanguageByID(FORBID_STORY_ENTER_TIP_CONTENT),
                title = GetLanguageByID(FORBID_STORY_ENTER_TIP_TITLE)
            }, nil, {cancel = false, close = false, confirm = true}})
        else
            -- TODO: 显示剧本繁忙
        end
        SendQueryPlayerGold(false);
    elseif (kRetData.eOprType == SEOT_QUIT) then           -- 退出剧本返回
        TileDataManager:GetInstance():ClearEvents()
        if g_processDelStory then 
            -- 删档处理时的退出剧本不做处理
            g_processDelStory = false
            LuaEventDispatcher:dispatchEvent("DELETE_STORY_RET",kRetData.dwScriptID)
            local showToast = STORYID_SETTINGS[kRetData.dwScriptID]
            if showToast~=nil and showToast then
                SystemUICall:GetInstance():Toast('剧本中橙色品质以上或强化等级+5以上物品已进入仓库', true)
            end
            return
        end
        if g_forceQuit then 
            g_forceQuit = false
            return
        end
        dprint("[NetGameMSg]->OnRecv_CMD_GAC_ScriptOprRet Quit Script")
        if kRetData.bOpr == SORT_SUCCESS then
            if PKManager:GetInstance():IsRunning() then
                -- 掌门对决重连会跳到这个，不做处理，有监听GameReconect
            else
                LuaEventDispatcher:dispatchEvent("QUIT_STORY_RET",kRetData.dwScriptID)
                -- 退出剧本
                QuitStory()
            end
        elseif kRetData.bOpr == SORT_UNAVALIABLE then
            -- 剧本维护返回酒馆提示
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
                text = GetLanguageByID(FORBID_STORY_RETURN_HOUSE_TIP_CONTENT),
                title = GetLanguageByID(FORBID_STORY_ENTER_TIP_TITLE),
                rightBtnText = GetLanguageByID(FORBID_STORY_RETURN_HOUSE_BUTTON_TEXT)
            }, QuitStory, {cancel = false, close = false, confirm = true}})
        else
            dprint("[NetGameMSg]->OnRecv_CMD_GAC_ScriptOprRet Quit Script Failed!")
        end
    elseif (kRetData.eOprType == SEOT_DEL) then            -- 删除剧本返回
        dprint("[NetGameMSg]->OnRecv_CMD_GAC_ScriptOprRet Del Script")
        if (kRetData.bOpr == SORT_SUCCESS) then
            LuaEventDispatcher:dispatchEvent("DELETE_STORY_RET",kRetData.dwScriptID)
            PlotDataManager:GetInstance():ClearPlotLog(kRetData.dwScriptID)
        elseif kRetData.bOpr == SORT_UNAVALIABLE then
            -- 因为服务器繁忙删除剧本失败
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
                text = GetLanguageByID(FORBID_STORY_DELETE_TIP_CONTENT),
                title = GetLanguageByID(FORBID_STORY_ENTER_TIP_TITLE)
            }, nil, {cancel = false, close = false, confirm = true}})
        elseif kRetData.bOpr == SORT_DELSCRIPTLIMIT then
            SystemUICall:GetInstance():Toast("您的每日删档次数达到了5次，今天无法继续删档");            
        end
    elseif (kRetData.eOprType == SEOT_QUERY) then            -- 查询剧本信息
        dprint("[NetGameMSg]->OnRecv_CMD_GAC_ScriptOprRet Query Script")
        if (kRetData.bOpr == SORT_SUCCESS) then
            LuaEventDispatcher:dispatchEvent("QUERY_STORY_RET",kRetData.dwScriptID)
        else
            dprint("[NetGameMSg]->OnRecv_CMD_GAC_ScriptOprRet Query Script Failed!")
        end
    elseif kRetData.eOprType == SEOT_BUYDIFF then  -- 购买剧本难度
        dprint("[NetGameMSg]->OnRecv_CMD_GAC_ScriptOprRet Buy Diff")
        local win = GetUIWindow("DifficultyUI")
        if not win then
            return
        end
        if kRetData.bOpr ~= SORT_SUCCESS then
            return
        end
        win:RefreshUI()
    elseif kRetData.eOprType == SEOT_FORCEEND then
        dprint("[NetGameMSg]->OnRecv_CMD_GAC_ScriptOprRet Del Script")
        if (kRetData.bOpr == SORT_SUCCESS) then
            LuaEventDispatcher:dispatchEvent("DELETE_STORY_RET",kRetData.dwScriptID)
            PlotDataManager:GetInstance():ClearPlotLog(kRetData.dwScriptID)
        elseif kRetData.bOpr == SORT_UNAVALIABLE then
            -- 因为服务器繁忙删除剧本失败
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
                text = GetLanguageByID(FORBID_STORY_DELETE_TIP_CONTENT),
                title = GetLanguageByID(FORBID_STORY_ENTER_TIP_TITLE)
            }, nil, {cancel = false, close = false, confirm = true}})
        elseif kRetData.bOpr == SORT_DELSCRIPTLIMIT then
            SystemUICall:GetInstance():Toast("您的每日删档次数达到了5次，今天无法继续删档");
        end
    elseif kRetData.eOprType == SEOT_QUITGAME then
        QuitGame()
    end
end

-- 玩家申请仓库返回
function OnRecv_CMD_GAC_AllPlatItemRet(kRetData)
    if not kRetData then
        return
    end
    local bIsFirstPush = (kRetData.iFlag == 1)
    StorageDataManager:GetInstance():UpdateStorageItemsByArr(kRetData.akPlatItem, kRetData.iNum, bIsFirstPush)
end

local UnlockInfoRet = {}
-- 解锁数据更新
function OnRecv_CMD_GAC_UNLOCKINFORET(kRetData)
    --如果数据过长,则需进行拼接后操作

    table.insert(UnlockInfoRet, kRetData);
    if kRetData.bOver == 1 then
        UnlockDataManager:GetInstance():UpdateUnlockData(UnlockInfoRet);
        UnlockDataManager:GetInstance():DispatchUpdateEvent(kRetData);
        UnlockInfoRet = {};
    end

end

function UpdateDownloadNetMsgStat(iSize)
    local iTotalDownloadMsgSize = globalDataPool:getData("TotalDownloadMsgSize") or 0
    local iTotalLastDownloadMsgSize = globalDataPool:getData("TotalLastDownloadMsgSize") or 0

    iTotalDownloadMsgSize = iTotalDownloadMsgSize + iSize
    iTotalLastDownloadMsgSize = iTotalLastDownloadMsgSize + iSize
    globalDataPool:setData("TotalDownloadMsgSize", iTotalDownloadMsgSize, true)    
    globalDataPool:setData("TotalLastDownloadMsgSize", iTotalLastDownloadMsgSize, true)    
end

function ResetDownloadNetMsgStat()
    globalDataPool:setData("TotalLastDownloadMsgSize", 0, true)    
end

function QuitStory()
    ResetGame()
    -- 界面切换
    RemoveWindowImmediately("StoryUI")
    OpenWindowImmediately("LoadingUI")
    -- 如果当前是在切换剧本, 那么不要打开酒馆, 而是切换到下一个剧本
    if PlotDataManager:GetInstance():IsChangingScript() == true then
        PlotDataManager:GetInstance():ChangeCueScript_In()
    else
        ChangeScenceImmediately("Town","LoadingUI", function()
            local LoginUI = OpenWindowImmediately("LoginUI")
        end)
    end
end

--
function OnRecv_CMD_GAC_JWTTokenRet(kRetData)
    SetToken(kRetData);
end

-- 获取邮件奖励
function OnRecv_CMD_GAC_MailOprRet(kRetData)
    -- 修改邮件状态
    local ids = {};
    for k, v in pairs(kRetData.akResult) do
        table.insert(ids, v.dwlMailID);
    end

    SocialDataManager:GetInstance():SetMailDataState(ids, MailState.ReadReceived);
    LuaEventDispatcher:dispatchEvent('ONEVENT_ADDAWARD', kRetData);
    LuaEventDispatcher:dispatchEvent('UPDATE_MAIL_DATA', kRetData);
end

-- 查询好友信息
function OnRecv_CMD_GAC_FriendInfoOprRet(kRetData)

end

-- 查询经脉信息
function OnRecv_CMD_GAC_MeridiansOprRet(kRetData)

    if kRetData.eOprType == SMOT_NULL then

    elseif kRetData.eOprType == SMOT_REFRESH_ALL then
        MeridiansDataManager:GetInstance():AddData(kRetData);

    elseif kRetData.eOprType == SMOT_REFRESH_ONE then

    elseif kRetData.eOprType == SMOT_LEVEL_UP then
        MeridiansDataManager:GetInstance():AddData(kRetData);

    elseif kRetData.eOprType == SMOT_BUY_LIMITNUM then

    elseif kRetData.eOprType == SMOT_BREAK_LIMIT then
        MeridiansDataManager:GetInstance():AddData(kRetData);

    end

end

function OnRecv_CMD_GAC_PlayerCommonInfoRet(kRetData)
    if not kRetData then
        return
    end

    if kRetData.eCommonRetType == FLAT_COMMONINFO_MERIDIANS_EXP then
        MeridiansDataManager:GetInstance():SetCurTotalExp(kRetData.dwlParam);

    elseif kRetData.eCommonRetType == FLAT_COMMONINFO_WEEK_MERIDIANS_EXP then
        MeridiansDataManager:GetInstance():SetWeekRecycleExp(kRetData.dwlParam);
        LuaEventDispatcher:dispatchEvent('UPDATE_MERIDIANS_EXP', kRetData);

    elseif kRetData.eCommonRetType == FLAT_COMMONINFO_WEEK_MERIDIANS_OPENLIMIT then
        MeridiansDataManager:GetInstance():SetWeekLimitNum(kRetData.dwlParam)
        LuaEventDispatcher:dispatchEvent('UPDATE_MERIDIANS_OPENLIMIT', kRetData);
    elseif kRetData.eCommonRetType == FLAT_COMMONINFO_WEEK_RECYCLE_LVL then
        MeridiansDataManager:GetInstance():SetWeekLimitLevel(kRetData.dwlParam)
    
    elseif kRetData.eCommonRetType == FLAT_COMMONINFO_RENAME_TIMES then
        -- 判断是否起名超时
        if (kRetData.acContent == "PLAT_RENAME_TIME_OUT")
        and IsWindowOpen("RenameBoxUI") then
            local win = GetUIWindow("RenameBoxUI")
            if win then
                win:SetWaitForClickRenameOK(true)
            end
            local strMsg = GetLanguageByID(558) or ""
            local funcCall = function()
                local win = GetUIWindow("RenameBoxUI")
                if not win then
                    return
                end
                win:SetWaitForClickRenameOK(false)
                win:RenameOK()
            end
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, funcCall, {close = false, cancel = false, confirm = true}})
        end
        local kPlayerSetMgr = PlayerSetDataManager:GetInstance()
        kPlayerSetMgr:SetReNameNum(kRetData.dwlParam)
        kPlayerSetMgr:SetPlayerName(kPlayerSetMgr:GetPlayerName(true))
        LuaEventDispatcher:dispatchEvent('Modify_Player_ReNameNum')

    elseif kRetData.eCommonRetType == FLAT_COMMONINFO_LUCKEYVALUE then
        PlayerSetDataManager:GetInstance():SetLuckyValue(kRetData.dwlParam)

    elseif kRetData.eCommonRetType == FLAT_COMMONINFO_MERIDIANS_BREAK_ITEM_NUM then
        -- TODO
        local totalBreak = MeridiansDataManager:GetInstance():GetCurTotalBreak();
        if totalBreak ~= -1 then
            if kRetData.dwlParam - totalBreak > 0 then
                SystemUICall:GetInstance():Toast('冲灵丹 +' .. (kRetData.dwlParam - totalBreak));
            end
        end

        MeridiansDataManager:GetInstance():SetCurTotalBreak(kRetData.dwlParam);

    end
end

function OnRecv_CMD_GAC_ModifyPlayerAppearanceRet(kRetData)
    local result = kRetData["eResultType"]
    if result == SNC_APPEAR_MODIFY_SUC then
        PlayerSetDataManager:GetInstance():ModifyPlayerAppearance(kRetData)
        LuaEventDispatcher:dispatchEvent('Modify_Player_Appearance', kRetData)
    else
        SystemUICall:GetInstance():Toast(ModifyAppearanceError[result])
    end
end

-- 货币更新回调
function OnRecv_CMD_GAC_MoneyUpdate(kRetData)
    local nowGoldNum = PlayerSetDataManager:GetInstance():GetPlayerGold();

    PlayerSetDataManager:GetInstance():UpdateCurrency(kRetData)

    if kRetData["eMoneyType"] == STLMT_TREASURE then
        local mgr = TreasureBookDataManager:GetInstance()
        local info = mgr:GetTreasureBookBaseInfo() or {}
        info.iMoney = kRetData["dwCurNum"] or 0
        mgr:SetTreasureBookBaseInfo(info, false)
    elseif kRetData["eMoneyType"] == STLMT_GOLD then
        --金锭更新回调
        dprint("金锭更新回调")
        local newGoldNum = kRetData["dwCurNum"]
        --金锭数目确实有变化，再将midas充值回调等待刷新状态重置
        if (newGoldNum ~= nowGoldNum) then
            WAITQUERYGOLDCALLBACK = false
        end

        -- 表示充值
        local tempGold = kRetData["dwAmtGold"];
        if tempGold > 0 and AMT_GOLD ~= tempGold then
            local addGold = tempGold - AMT_GOLD;
            AMT_GOLD = tempGold;
            
            -- TODO 上报充值数据
            MSDKHelper:SetQQAchievementData('rechargecount', addGold)
            MSDKHelper:SetQQAchievementData('totalrechargecount', AMT_GOLD)
            MSDKHelper:SetQQAchievementData('rechargetime', GetCurServerTimeStamp())
            MSDKHelper:SendAchievementsData('recharge')
        end

        -- 金锭消费结束
        OnGoldSpendRequestEnd()
    end

    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then 
        windowBarUI:UpdateWindow()
    end
end

-- 获取时间字符串
function GetForbidTimeString(lStamp)
    if not lStamp then
        return ""
    end
    local strMsg = ""
    local lMinOffset = 60
    local lHourOffset = lMinOffset * 60
    local lDayOffset = lHourOffset * 24

    if lStamp > lDayOffset then
        local iDay = math.floor(lStamp / lDayOffset)
        strMsg = strMsg .. string.format("%d天", iDay)
        lStamp = lStamp - iDay * lDayOffset
    end

    if lStamp > lHourOffset then
        local iHour = math.floor(lStamp / lHourOffset)
        strMsg = strMsg .. string.format("%d时", iHour)
        lStamp = lStamp - iHour * lHourOffset
    end

    if lStamp > lMinOffset then
        local iMin = math.floor(lStamp / lMinOffset)
        strMsg = strMsg .. string.format("%d分", iMin)
        lStamp = lStamp - iMin * lMinOffset
    end

    if lStamp > 0 then
        strMsg = strMsg .. string.format("%d秒", lStamp)
    end

    return strMsg
end

function HandleCommonFreezing(forbidType)
    local strMsg = nil
    local forbidInfo = PlayerSetDataManager:GetInstance():GetForbidByType(forbidType);
    if not forbidInfo then
        return;
    end

    local beginTime = forbidInfo.dwBegineTime
    local iTime = forbidInfo.iTime
    local reason = forbidInfo.acReason

    --同步的服务器时间是1分钟同步一次，可能会存在一点误差
    local serverTime = GetCurServerTimeStamp();

    if iTime == -1 then
        if forbidType == SEOT_FORBIDALLCHAT or forbidType == SEOT_FORBIDCHAT then
            strMsg = "您已被永久禁言"
        elseif forbidType == SEOT_FORBIDADDFRIEND then
            strMsg = "您已被永久禁止加好友"
        elseif forbidType == SEOT_FORBIDRANK then
            strMsg = "您已被永久禁止参与排行榜"
        elseif forbidType == SEOT_FORBIDEDITTEXT then
            strMsg = "您被永久禁止修改文本"
        end
    else
        local lDelta = (beginTime + iTime) - serverTime;
        if lDelta <= 0 then
            return;
        end

        local subText = "";
        if forbidType == SEOT_FORBIDALLCHAT or forbidType == SEOT_FORBIDCHAT then
            subText = "您已被禁言"
        elseif forbidType == SEOT_FORBIDADDFRIEND then
            subText = "您已被禁止加好友"
        elseif forbidType == SEOT_FORBIDRANK then
            subText = "您已被禁止参与排行榜"
        elseif forbidType == SEOT_FORBIDEDITTEXT then
            subText = "您被禁止修改文本"
        end
        strMsg = string.format(subText..", %s后自动解除", GetForbidTimeString(lDelta))
    end

    if reason and (reason ~= "") then
        strMsg = (strMsg or "") .. "\n封禁原因: " .. reason
    end

    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP_WITH_BTN, strMsg, nil, {confirm = true}})
end

function OnRecv_CMD_GAC_WordFilterTips(kRetData)
    local CreateRoleUI = GetUIWindow("CreateRoleUI")
    if (kRetData.eRetType == SNC_APPEAR_MODIFY_SUC) then
        if CreateRoleUI then
            CreateRoleUI:CheckResult(true)
        end
    elseif (kRetData.eRetType == SNC_TSS_NOT_VALID) then
        if kRetData.eFilterType == STWFT_TALK then                  --聊天
            SystemUICall:GetInstance():Toast("消息中含有非法字符")
        elseif kRetData.eFilterType == STWFT_PLAT_RENAME then       --平台改名
            if CreateRoleUI then
                CreateRoleUI:CheckResult(false)
            end
            --SystemUICall:GetInstance():Toast("您的名称中含有非法字符，请换一个名称")
        elseif kRetData.eFilterType == STWFT_SCRIPT_RENAME then     --剧本改名
            SystemUICall:GetInstance():Toast("您的名称中含有非法字符，请换一个名称")
        end
    elseif (kRetData.eRetType == SNC_FORBIDDEN_CHAT) then
        if kRetData.eFilterType == STWFT_TALK then 
            HandleCommonFreezing(kRetData.dwParam);
        end
    elseif (kRetData.eRetType == SNC_FORBIDDEN_SILENTCHAT) then --被静默
        if kRetData.eFilterType == STWFT_TALK then
            local playerID = PlayerSetDataManager:GetInstance():GetPlayerID();
            local data = {
                channel = kRetData.dwParam,
                content = kRetData.acContent,
                id = playerID,
                name = PlayerSetDataManager:GetInstance():GetPlayerName(),
                modelid = PlayerSetDataManager:GetInstance():GetModelID(),
            };
            local chatBoxUI = GetUIWindow("ChatBoxUI")
            if chatBoxUI then
                chatBoxUI:AddNotice(data);
                chatBoxUI:OnRefNormalList(nil);
            end

            if kRetData.dwParam == BroadcastChannelType.BCT_World then
                SystemUICall:GetInstance():BarrageShow(data.content);
            end
       end
    elseif (kRetData.eRetType == SNC_WEGAME_EXIT) then
        derror("SNC_WEGAME_EXIT")
        DRCSRef.Application.Quit()
    elseif (kRetData.eRetType == SNC_ANTI_ADDITION) then
        derror("SNC_ANTI_ADDITION")
        DRCSRef.Application.Quit()
    end
end

function OnNetMessageRecordInsert(iCmdType,iDataSize)
    table.insert(NetGameMsgRecord, {cmdType = iCmdType, dataSize = iDataSize})
end

function OnNetMessageRecordClear()
    NetGameMsgRecord = {}
end

function GetNetMessageRecord()
    return NetGameMsgRecord
end

-- 发送公共聊天消息
function OnRecv_CMD_GAC_PublicChatRet(kRetData)
    LuaEventDispatcher:dispatchEvent('ONEVENT_PUBLICCHAT', kRetData);
end

-- 获取门派信息下发
function OnRecv_CMD_GAC_QueryClanCollectionInfoRet(kRetData)
    ClanDataManager:GetInstance():UpdateClanCollectionInfo(kRetData);
end

function OnRecv_CMD_GAC_PlatItemOprRet(kRetData)
    dprint('<======OnRecv_CMD_GAC_PlatItemOprRet======>')
    -- Dump(kRetData)
    dprint('<=========================================>')

    if kRetData.eOprType == SPIO_NULL then
    elseif kRetData.eOprType == SPIO_QUERY then
    elseif kRetData.eOprType == SPIO_INTO_SCRIPT then
    elseif kRetData.eOprType == SPIO_OUT_SCRIPT then
    elseif kRetData.eOprType == SPIO_DEL then
    elseif kRetData.eOprType == SPIO_RECYCLE then
        LuaEventDispatcher:dispatchEvent('UPDATE_RECYCLE_ITEM', kRetData);
    end
end


local kShowNoticeCode2Proc = {
    [SNC_NOT_ENOUGH_GOLD] = function()
        OnRecv_GoldNotEnough()
    end,
    [SNC_NOT_ENOUGH_SILVER] = function(iCode, kRetData)
        OnRecv_SilverNotEnough(iCode, kRetData)
    end,
    [SNC_BECOME_RMB_PLAYER] = function(iCode, kRetData)
        OnRecv_TreasureBookVIPOpenRes(iCode, kRetData)
    end,
    [SNC_TREASURE_EXTRA_GETREWARD_LVL] = function(iCode, kRetData)
        OnRecv_TreasureBookExtraGetRewardLvl(iCode, kRetData)
    end,
    [SNC_TREASURE_ADVANCE_PURCHASE_SUC] = function(iCode, kRetData)
        OnRecv_TreasureBookEarlyBuyRes(iCode, kRetData)
    end,
    [SNC_TREASURE_ADVANCE_PURCHASE_FAIL] = function(iCode, kRetData)
        OnRecv_TreasureBookEarlyBuyRes(iCode, kRetData)
    end,
    [SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_SUC] = function(iCode, kRetData)
        OnRecv_TreasureBookEarlyBuyRes(iCode, kRetData)
    end,
    [SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_FAIL] = function(iCode, kRetData)
        OnRecv_TreasureBookEarlyBuyRes(iCode, kRetData)
    end,
    [SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_LIMIT] = function (iCode, kRetData)
        OnRecv_TreasureBookEarlyBuyRes(iCode, kRetData)
    end,
    [SNC_TREASURE_BUT_EXP_SUC] = function()
        OnRecv_TreasureBookBuyExpSuccess()
    end,
    [SNC_TREASURE_FRIEND_RMB_NUM] = function(iCode, kRetData)
        OnRecv_TreasureBookFriendRmbNum(iCode, kRetData)
    end,
    [SNC_TREASURE_DAILY_SILVER_SUC] = function()
        OnRecv_GetDialyGiftRes(true)
    end,
    [SNC_TREASURE_DAILY_SILVER_FAIL] = function()
        OnRecv_GetDialyGiftRes(false)
    end,
    [SNC_TREASURE_WEEK_SILVER_SUC] = function()
        OnRecv_GetWeeklyGiftRes(true)
    end,
    [SNC_TREASURE_WEEK_SILVER_FAIL] = function()
        OnRecv_GetWeeklyGiftRes(false)
    end,
    [SNC_TREASURE_TASK_PROGRESS_UPDATE] = function(iCode, kRetData)
        OnRecv_TaskProgressUpdate(iCode, kRetData)
    end,
    [SNC_HOODLE_NUM_NOT_ENOUGH] = function()
        OnRecv_HoodleNumNotEnough()
    end,
    [SNC_MERIDIANS_EXP_CHANGE] = function(iCode, kRetData)
        OnRecv_MeridiansExpChange(iCode, kRetData)
    end,
    [SNC_CHALLENGE_ORDER_UNLOCK] = function(iCode, kRetData)
        OnRecv_ChallengeOrderUnlock(iCode, kRetData)
    end,
    [SNC_SKIN_UNLOCK_SUC] = function(iCode, kRetData)
        OnRecv_SkinUnlock(iCode, kRetData)
    end,
    [SNC_DAY3SIGNIN_BUY_HORSE] = function()
        OnRecv_Day3SignInNotify_BuyHorse()
    end,
    [SNC_DAY3SIGNIN_JOIN_TEAM] = function()
        OnRecv_Day3SignInNotify_JoinTeam()
    end,
    [SNC_UNLOCK_INFO] = function(iCode, kRetData)
        OnRecv_unlock_info(iCode, kRetData)
    end,
    [SNC_UNLOCK_ADD_INCOMPLETETEXT] = function(iCode, kRetData)
        OnRecv_IncompleteText(iCode, kRetData)
    end,
    [SNC_SHOW_PET] = function(iCode, kRetData)
        OnRecv_Show_Pet(iCode, kRetData)
    end,
    [SNC_PLAT_EMBATTLE_NO_EFFECT] = function(iCode,kRetData)
        OnRecv_Plat_EMBattle_No_Effect(iCode, kRetData)
    end,
    [SNC_GOLD_OP_EXCEPT] = function (iCode,kRetData)
        OnRecv_Gold_Op_Except(iCode,kRetData)
    end,
    [SNC_TENCENT_CREDIT_SCORE_SCENE_LIMIT] = function (iCode,kRetData)
        OnRecv_TencentCredit_SceneLimit(iCode,kRetData)
    end,
    [SNC_OperatorSignInFlagRet] = function (iCode,kRetData)
        OnRecv_OperatorSignInFlagRet(iCode, kRetData)
    end,
    [SNC_LIMITSHOP_ADDFIRSTSHARE] = function (iCode,kRetData)
        -- TODO : 添加分享次数成功 期望返回这次分享结束的次数
        OnRecv_LimitShop_Notice_ShareTimes(kRetData)
    end,
    [SNC_LIMITSHOP_BUYBIGCOINSUCCESS] = function (iCode,kRetData)
        -- TODO : 旺旺币购买成功后 返回值代表是否首次分享的购买 
        OnRecv_LimitShop_Notice_ShareBuy(kRetData)
    end,
    [SNC_LIMITSHOP_NOENOUGHBIGCOIN] = function (iCode,kRetData)
        -- TODO : 旺旺币不足返回 
        OnRecv_LimitShop_Notice_SecondGoldNotEnough(kRetData)
    end,
    [SNC_LIMITSHOP_YAZHUSUCCESS] = function (iCode,kRetData)
        -- TODO : 押注后返回 
        OnRecv_LimitShop_Notice_YaZhu(kRetData)
    end,
    [SNC_LIMITSHOP_BUYSECCESS] = function (iCode,kRetData)
        OnRecv_LimitShop_BuySuccess(kRetData)
    end,
    [SNC_LIMITSHOP_COUPONNOTFOUND] = function (iCode,kRetData)
        SystemUICall:GetInstance():Toast("优惠券不存在!")
        LimitShopManager:GetInstance():SetCatchDateBought()
    end,
    [SNC_LIMITSHOP_COUPONEXPIRED] = function (iCode,kRetData)
        SystemUICall:GetInstance():Toast("优惠券已过期!")
        LimitShopManager:GetInstance():SetCatchDateBought()
    end,
    [SNC_LIMITSHOP_GIFTSOLD] = function (iCode,kRetData)
        SystemUICall:GetInstance():Toast("礼包售完了!")
        -- LimitShopManager:GetInstance():SetCatchDateBought()
    end,
    [SNC_PlatChallengeTargetOffline] = function (iCode,kRetData)
        OnRecv_ChallengeTargetOffline(kRetData)
    end,
    [SNC_SHOPGOLDREWARDSUCCESS] = function (iCode,kRetData)
        OnRecv_SHOPGOLDREWARDSUCCESS(kRetData)
    end,
    [SNC_SHOPADREWARDSUCCESS] = function (iCode,kRetData)
        OnRecv_SHOPADREWARDSUCCESS(kRetData)
    end,
    [SNC_OPENTREASURE_FRIENDGIFT] = function (iCode,kRetData)
        OnRecv_OPENTREASURE_FRIENDGIFT(kRetData)
    end,
    [SNC_NOT_ENOUGH_HOODLESCORE] = function (iCode, kRetData)
        OnRecv_HOODLEBUY_RES(iCode, kRetData)
    end,
    [SNC_HOODLEBUY_NOMATCH] = function (iCode, kRetData)
        OnRecv_HOODLEBUY_RES(iCode, kRetData)
    end,
    [SNC_HOODLEBUY_SUCCESS] = function (iCode, kRetData)
        OnRecv_HOODLEBUY_RES(iCode, kRetData)
    end,
    [SNC_ACTIVITY_RECEIVE_FAILED] = function(iCode, kRetData)
        OnRecv_Activity_Failed(iCode, kRetData)
    end,
    [SNC_FORBIDADDFRIEND] = function (iCode,kRetData)
        OnRecv_AddFriendFailRet(kRetData)
    end,
    [SNC_PLAT_PLAYER_OFFLINE] = function (iCode,kRetData)
        OnRecv_PlatPlayerOffline(kRetData)
    end,

    [SNC_GETTIMESMAX_REDPACKET] = function (iCode,kRetData)
        OnRecv_GETREDPACKETMAXTIEMS(kRetData)
    end,

    [SNC_LIMITBUY_BAG_NOT_ENOUGH] = function (iCode,kRetData)
        OnRecv_LIMITBUY_BAG_NOT_ENOUGH(kRetData)
    end,

    [SNC_FREE_CHALLENGE_UNLOCK_FAILD] = function (iCode,kRetData)
        OnRecv_FREE_CHALLENGE_UNLOCK_FAILD(kRetData)
    end,
    -- [SNC_SECT_NOT_OPEN] = function (iCode,kRetData)
    --     LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    -- end,
    [SNC_OTHER_BUILDING_UPGRADE] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_BUILDING_MAX_LEVEL] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_NOT_ENOUGH_MATERIAL] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_BUILDING_PUT_INVALID] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_DISCIPLE_NOT_IN_ROOM] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_DISCIPLE_IN_OTHER_BUILDING] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_DISCIPLE_ROOM_INVALID] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_DISCIPLE_ROOM_FULL] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_DISCIPLE_LIMIT] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_BUILDING_NAME_INVALID] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,
    [SNC_BUILDING_NAME_OVER_LIMIT] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,    
    [SNC_BUILDING_NAME_OVER_LIMIT] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,    
    [SNC_NO_MATERIAL_GET] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,    
    [SNC_NOT_ENOUGH_HALL_LEVEL] = function (iCode,kRetData)
        LuaEventDispatcher:dispatchEvent(BuildManager.NET_EVENT.Error, iCode, kRetData);
    end,    
    [SNC_FIND_PLAYER_OFFLINE] = function(iCode,kRetData)
        LuaEventDispatcher:dispatchEvent("NOTICE_FIND_PLAYER_OFFLINE")
    end,
    [SNC_SYS_RED_PACKET_HUASHAN] = function(iCode,kRetData)
        if kRetData.acMessage then 
            SystemUICall:GetInstance():BarrageRedPacketShow(kRetData.acMessage);
        end
    end,
    [SNC_HOODLE_PUBLIC_NOT_READY] = function(iCode, kRetData)
        LuaEventDispatcher:dispatchEvent("HOODLE_PUBLIC_NOT_READY")
    end,
    [SNC_ACTIVITY_FESTIVAL_SIGN_IN_RES] = function(iCode, kRetData)
        -- 节日活动活跃度奖励领取结果
        OnRecv_SNC_ACTIVITY_FESTIVAL_SIGN_IN_RES(kRetData)
    end,
    [SNC_ACTIVITY_FESTIVAL_LIVENESS_ACHIEVE_RES] = function(iCode, kRetData)
        -- 节日活动活跃度奖励领取结果
        OnRecv_SNC_ACTIVITY_FESTIVAL_LIVENESS_ACHIEVE_RES(kRetData)
    end,
    [SNC_ACTIVITY_FESTIVAL_EXCHANGE_RES] = function(iCode, kRetData)
        -- 节日活动兑换结果
        OnRecv_SNC_ACTIVITY_FESTIVAL_EXCHANGE_RES(kRetData)
    end,
    [SNC_ACTIVITY_FESTIVAL_EXCHANGE_ASSET_CLEAN_RES] = function(iCode, kRetData)
        -- 节日活动资产值清空结果
        OnRecv_SNC_ACTIVITY_FESTIVAL_EXCHANGE_ASSET_CLEAN_RES(kRetData)
    end,
    [SNC_ACTIVITY_FESTIVAL_BUYMALL_RES] = function(iCode, kRetData)
        -- 节日活动商品购买结果
        OnRecv_SNC_ACTIVITY_FESTIVAL_BUYMALL_RES(kRetData)
    end,
    [SNC_HOODLE_NOT_SAME_POOL_ID] = function(iCode, kRetData)
        SystemUICall:GetInstance():Toast("切换池子中，请等待当前小侠客到达目标", false, nil, "PINBALL")
    end,
    [SNC_ILLEGAL_ENTER_STORY_DIFFICULT] = function(iCode, kRetData)
        SystemTipManager:GetInstance():AddPopupTip('抱歉，系统检测到您处于尚未开放的难度中，即将进行强制结算。\n进入剧本消耗的幸运值，将通过邮件补偿。\n如有疑问，请联系客服。')
    end,
    [SNC_SYSTEM_MODULE_DISABLE] = function(iCode, kRetData)
        kRetData = kRetData or {}
        ShowSystemModuleDisableTip(kRetData.dwParam)
    end,
}

function OnRecv_ChallengeTargetOffline(kRetData)
    RemoveWindowImmediately("LoadingUI");
    SystemUICall:GetInstance():Toast('不在同一个频道无法切磋');
end

function OnRecv_SHOPGOLDREWARDSUCCESS(kRetData)
    SystemUICall:GetInstance():Toast('金锭打赏成功');
end

function OnRecv_SHOPADREWARDSUCCESS(kRetData)
    SystemUICall:GetInstance():Toast('打赏成功');
end

function OnRecv_GETREDPACKETMAXTIEMS(kRetData)
    MoneyPacketDataManager:GetInstance():ClearPacketData();
    SystemUICall:GetInstance():Toast('红包领取数已达上限');
end

function OnRecv_LIMITBUY_BAG_NOT_ENOUGH(kRetData)
    SystemUICall:GetInstance():Toast('背包空间不足，请麻烦大侠您空出些许背包来购买道具');
end

function OnRecv_SNC_ACTIVITY_FESTIVAL_SIGN_IN_RES(kRetData)
    if not kRetData then return end 
    if kRetData.dwParam == 1 then 
        SystemUICall:GetInstance():Toast('签到成功')
    end
end
-- 节日活动活跃度奖励领取结果
function OnRecv_SNC_ACTIVITY_FESTIVAL_LIVENESS_ACHIEVE_RES(kRetData)
    if not kRetData then return end 
    if kRetData.dwParam == 1 then 
        -- TODO 兼容后面活动
        SystemUICall:GetInstance():Toast('凛寒值奖励领取成功')
    end
end
-- 节日活动兑换结果
function OnRecv_SNC_ACTIVITY_FESTIVAL_EXCHANGE_RES(kRetData)
    if not kRetData then return end 
    if kRetData.dwParam == 1 then 
        SystemUICall:GetInstance():Toast('兑换成功')
    elseif kRetData.acMessage ~= '' then 
        SystemUICall:GetInstance():Toast(kRetData.acMessage)
    end
end
-- 节日活动资产值清空结果
function OnRecv_SNC_ACTIVITY_FESTIVAL_EXCHANGE_ASSET_CLEAN_RES(kRetData)
    if not kRetData then return end 
    if kRetData.dwParam == 1 and kRetData.dwParam2 > 0 then 
        -- TODO 兼容后面活动
        ActivityHelper:GetInstance():AddFestivalCleanResBox(kRetData.dwParam2)
    end
end
-- 节日活动商品购买结果
function OnRecv_SNC_ACTIVITY_FESTIVAL_BUYMALL_RES(kRetData)
    if not kRetData then return end 
    if kRetData.dwParam == 1 then 
        SystemUICall:GetInstance():Toast('购买成功')
    elseif kRetData.acMessage ~= '' then 
        SystemUICall:GetInstance():Toast(kRetData.acMessage)
    end
end
function OnRecv_OPENTREASURE_FRIENDGIFT(kRetData)
    local acName = kRetData.acMessage;
    local tips = string.format("您的好友%s通过您分享的线索,发现了神秘宝藏,送上一份小礼物作为感谢",acName);
    SystemUICall:GetInstance():Toast(tips);
end

function OnRecv_AddFriendFailRet(kRetData)
    HandleCommonFreezing(SEOT_FORBIDADDFRIEND);
end

function OnRecv_PlatPlayerOffline(kRetData)
    RemoveWindowImmediately("LoadingUI");
    SystemUICall:GetInstance():Toast('该玩家已下线');
end

function OnRecv_CMD_GAC_SHOWNOTICE(kRetData)
    dprint("OnRecv_CMD_GAC_SHOWNOTICE")
    if not (kShowNoticeCode2Proc and kRetData and kRetData.eNoticeCode) then
        return
    end
    if kShowNoticeCode2Proc[kRetData.eNoticeCode] then
        kShowNoticeCode2Proc[kRetData.eNoticeCode](kRetData.eNoticeCode, kRetData)
    else
        OnRecv_ShowSimpleNotice(kRetData.eNoticeCode)
    end
end

function OnRecv_HOODLEBUY_RES(iCode, kRetData)
    local strMsg = {
        [SNC_NOT_ENOUGH_HOODLESCORE] = "头巾不足",
        [SNC_HOODLEBUY_NOMATCH] = "兑换物品不匹配",
        [SNC_HOODLEBUY_SUCCESS] = "兑换成功!",
    }
    SystemUICall:GetInstance():Toast(strMsg[iCode], nil, nil, "PINBALL")
end

function OnRecv_Activity_Failed(iCode, kRetData)
    if (kRetData.dwParam == 1003) then
        SystemUICall:GetInstance():Toast("每日仅可以领取一次好友分享奖励");
    end
end

function OnRecv_unlock_info(iCode, kRetData)
    if kRetData and GetGameState() == -1 then
        local bShowInChatOnly = kRetData.acMessage == "1"
        local function DoToast(text, bShowChat)
            if bShowInChatOnly then
                SystemUICall:GetInstance():AddChat2BCT(text)
                return
            end
            SystemUICall:GetInstance():Toast(text, bShowChat)
        end
        local strText = '';
        if kRetData.dwParam == PlayerInfoType.PIT_INCOMPLETE_BOOK then
            local martialData = TableDataManager:GetInstance():GetTableData('Martial', kRetData.dwParam2);
            local revertData = ItemDataManager:GetInstance():GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_IncompleteBook, martialData.BaseID);
            if martialData and revertData then
                strText = '获得 ' .. (revertData.ItemName or '') .. ' x' .. kRetData.dwParam3;
            end
            DoToast(strText, true);
        elseif kRetData.dwParam == PlayerInfoType.PIT_TITLE then
            local titleData = TableDataManager:GetInstance():GetTableData('RoleTitle', kRetData.dwParam2);
            if titleData then
                strText = '获得 ' .. titleData.Name .. ' 称号';
                DoToast(strText, true);
            end
        else
            local infoData = TableDataManager:GetInstance():GetTableData('PlayerInfo', kRetData.dwParam2);
            if infoData then
                strText = '获得 ' .. GetLanguageByID(infoData.NameID) .. ' x' .. kRetData.dwParam3;
                DoToast(strText, true);
            end
        end
    end
end

function OnRecv_IncompleteText(iCode, kRetData)
    if kRetData then
        local strText = '';
        if kRetData.dwParam == SNC_UNLOCK_ADD_INCOMPLETETEXT then
            local martialConvert = TableDataManager:GetInstance():GetTable("MartialRemainsConvertConfig");
            local martialData = TableDataManager:GetInstance():GetTableData('Martial', kRetData.dwParam2);
            if martialData and martialConvert then
                for k, v in pairs(martialConvert) do
                    if martialData.Rank == v.InCompleteBookRank then
                        if v.RemainsQuality == MartialRemainsRank.MRR_LOW then
                            strText = strText .. '低级残文';
                        elseif v.RemainsQuality == MartialRemainsRank.MRR_MID then
                            strText = strText .. '中级残文';
                        elseif v.RemainsQuality == MartialRemainsRank.MRR_HIGH then
                            strText = strText .. '高级残文';
                        end
                    end
                end
                strText = '获得' .. kRetData.dwParam3 .. strText;
                SystemUICall:GetInstance():Toast(strText, true);
            end
        end
    end
end

function OnRecv_Show_Pet(iCode, kRetData)
    if kRetData then
        -- local strText = '设置展示宠物成功';
        -- SystemUICall:GetInstance():Toast(strText, true);
        if kRetData.dwParam then 
            PlayerSetDataManager:GetInstance():SetShowPetID(kRetData.dwParam)
            local PetCardsUpgradeUI = GetUIWindow("PetCardsUpgradeUI")
            if PetCardsUpgradeUI then
                PetCardsUpgradeUI:SetNeedUpdateData(true)	-- 查表，获取ID
            end
            local HouseUI = GetUIWindow("HouseUI")
            if HouseUI then
                HouseUI:RefreshShowPet()
            end
            local PlayerSetUI = GetUIWindow("PlayerSetUI")
            if PlayerSetUI.AccountInfoCom then
                PlayerSetUI.AccountInfoCom:RefreshPet();

                if PlayerSetUI.AccountInfoCom.AccountSettingCom then
                    PlayerSetUI.AccountInfoCom.AccountSettingCom:OnRefCurPage()
                end
            end
        end 
    end
end

function OnRecv_Plat_EMBattle_No_Effect(iCode, kRetData)
    RemoveWindowImmediately("LoadingUI");
    local roleEmbattleUI = GetUIWindow('RoleEmbattleUI');
    if roleEmbattleUI and roleEmbattleUI:IsOpen() then
    else
        if kRetData then
            if kRetData.dwParam < 1000 then
                local strText = '当前平台阵容失效，无法进行切磋，\n是否去阵容界面配置？';
                if kRetData.dwParam == 1 then
                    strText = '当前平台阵容失效，无法进行切磋，\n是否去阵容界面配置？';
                elseif kRetData.dwParam == 101 then
                    strText = '当前平台阵容失效，无法进行切磋与擂台，\n是否去阵容界面配置？';
                elseif kRetData.dwParam == 102 then
                    strText = '当前平台布阵失效，无法进行切磋与擂台，\n是否去阵容界面配置？';
                elseif kRetData.dwParam == 103 then
                    strText = '当前平台主角失效，无法进行切磋与擂台，\n是否去阵容界面配置？';
                elseif kRetData.dwParam == 104 then
                    strText = '当前平台阵容属性失效，无法进行切磋与擂台，\n是否去阵容界面配置？';
                elseif kRetData.dwParam == 105 then
                    strText = '当前平台布阵角色不在阵容中，无法进行切磋与擂台，\n是否去阵容界面配置？';
                end
                local _callback = function()
                    local townPlayerListUI = GetUIWindow('TownPlayerListUI');
                    if townPlayerListUI and townPlayerListUI:IsOpen() and townPlayerListUI.bIsListOpen then
                        townPlayerListUI:MovePlayerList(true);
                    end

                    local arenaUI = GetUIWindow('ArenaUI');
                    if arenaUI and arenaUI:IsOpen() then
                        RemoveWindowImmediately('ArenaUI');  
                    end

                    local playerSetUI = OpenWindowImmediately('PlayerSetUI');
                    if playerSetUI and playerSetUI:IsOpen() and playerSetUI.AccountInfoCom then
                        playerSetUI.AccountInfoCom:OnClick_TeamButton();
                    end
                end
                OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strText, _callback });
            else
                if kRetData.dwParam == 1010 then
                    SystemUICall:GetInstance():Toast('对方平台阵容失效，无法进行切磋与擂台', true);
                elseif kRetData.dwParam == 1020 then
                    SystemUICall:GetInstance():Toast('对方平台布阵失效，无法进行切磋与擂台', true);
                elseif kRetData.dwParam == 1030 then
                    SystemUICall:GetInstance():Toast('对方平台主角失效，无法进行切磋与擂台', true);
                elseif kRetData.dwParam == 1040 then
                    SystemUICall:GetInstance():Toast('对方平台阵容属性失效，无法进行切磋与擂台', true);
                elseif kRetData.dwParam == 1050 then
                    SystemUICall:GetInstance():Toast('对方平台布阵角色不在阵容中，无法进行切磋与擂台', true);
                end
            end
        else
            SystemUICall:GetInstance():Toast('当前平台阵容失效，无法进行切磋与擂台', true);
        end
    end

    local playerMsgMiniUI = GetUIWindow('PlayerMsgMiniUI');
    if playerMsgMiniUI then
        playerMsgMiniUI:ResetFrghtTime();
    end
end

function OnRecv_Gold_Op_Except(iCode,kRetData)
    if kRetData then
        local errorCode = kRetData.dwParam;
        if errorCode == 1018 then
            -- 特殊处理，CJ展会账号密码登录，无需处理这个
            if (MSDK_MODE == 8 or MSDK_MODE == 10 or MSDK_MODE == 1) then
              return
            end
            local strMsg = "您的登录状态失效，请重新登录游戏"
            SystemUICall:GetInstance():Toast(strMsg)
            if (MSDKHelper:IsLoginWeChat()) then
                MSDKHelper.loginWeChatAutoRun = true
            end
            if (MSDKHelper:IsLoginQQ()) then
                MSDKHelper.loginQQAutoRun = true
            end
            OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strMsg, function()
                ReturnToLogin(true)
            end , {cancel = false, close = false, confirm = true}})
        elseif errorCode == 1001 then
            if (not g_IS_SIMULATORIOS) then
                -- 请求参数错误,直接重新登录 
                local strMsg = "您的登录请求参数错误，请重新登录游戏"
                SystemUICall:GetInstance():Toast(strMsg)
                if (MSDKHelper:IsLoginWeChat()) then
                    MSDKHelper.loginWeChatAutoRun = true
                end
                if (MSDKHelper:IsLoginQQ()) then
                    MSDKHelper.loginQQAutoRun = true
                end
                OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strMsg, function()
                    ReturnToLogin(true)
                end , {cancel = false, close = false, confirm = true}})
            end
        end
    end
end



function OnRecv_TencentCredit_SceneLimit(iCode,kRetData)
    if kRetData then
        local errorCode = kRetData.dwParam;
        local strMsg = "由于您的信用分<350分，存在不良行为，无法"
        local errorcodemap = {
            [TCSSLS_WORLD_CHAT] = '世界聊天',
            [TCSSLS_PRIVATE_CHAT] = '私聊',
            [TCSSLS_APPLY_FRIENDS] = '申请加他人为好友',
            [TCSSLS_CHALLENGE] = '切磋',
            [TCSSLS_ARENA_SIGNUP] = '报名擂台赛',
            [TCSSLS_RANKLIST] = '上排行榜',
        }
        if errorcodemap[errorCode] then
            strMsg = strMsg .. errorcodemap[errorCode]
        end

        --再想想 绿色 右 认输 红色 左
        local showContent = {
            ['title'] = '腾讯信用分提示',
            ['text'] = strMsg,
            ['leftBtnText'] = '了解更多',
            ['rightBtnText'] = '确定',
            ['leftBtnFunc'] = function()
                MSDKHelper:OpenCriditUrl()
            end
        }

        if errorCode == TCSSLS_CHALLENGE then 
            if GetUIWindow("LoadingUI") then 
                RemoveWindowImmediately("LoadingUI");
            end
        end

        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.CREDIT_SCENELIMIT, showContent, nil})

    end
end
function OnRecv_ShowSimpleNotice(eType)
    if eType and SncType2Msg[eType] then
        SystemUICall:GetInstance():Toast(SncType2Msg[eType])
    end
end

-- 百宝书任务进度更新
function OnRecv_TaskProgressUpdate(iCode, kRetData)
    if not kRetData then
        return
    end
    local iTaskID = kRetData.dwParam
    local iTaskProgress = kRetData.dwParam2
    if not (iTaskID and iTaskProgress) then
        return
    end

    ActivityHelper:GetInstance():UpdateTaskProgressData(iTaskID,iTaskProgress)
    TreasureBookDataManager:GetInstance():UpdateSingleTaskData(iTaskID, iTaskProgress)
end

-- 购买经验结果
function OnRecv_TreasureBookBuyExpSuccess()
    SystemUICall:GetInstance():Toast("购买经验成功!")
    TreasureBookDataManager:GetInstance():AddBoughtExp()
end

-- 银锭不足
function OnRecv_SilverNotEnough(iCode, kRetData)
    local silver = kRetData.dwParam
    SystemUICall:GetInstance():Toast("银锭不足!")
end

-- 金锭不足
function OnRecv_GoldNotEnough()
    OnGoldSpendRequestEnd()
    SystemUICall:GetInstance():Toast("金锭不足!")
    if GetUIWindow("TreasureBookEarlyBuyUI") then
        OpenWindowImmediately("TreasureBookUI")
        RemoveWindowImmediately("TreasureBookEarlyBuyUI", false)
    end
    LimitShopManager:GetInstance():SetCatchDateBought()
end

-- 百宝书开通结果
function OnRecv_TreasureBookVIPOpenRes(iCode, kRetData)
    local uiNewStamp = kRetData.dwParam or 0
    -- 更新壕侠到期时间戳
    TreasureBookDataManager:GetInstance():UpdateTreasureBookVIPEndTimeStamp(uiNewStamp)
    -- 更新壕侠状态
    TreasureBookDataManager:GetInstance():UpdateTreasureBookVIPState(true)
    -- 提示
    local win = GetUIWindow("TreasureBookEarlyBuyUI")
    if win then
        win:ShowLoading(false)
    end
    local strTime = os.date("%Y年%m月%d日", uiNewStamp)
    SystemUICall:GetInstance():Toast(string.format("成功续费壕侠版百宝书, 到期时间 %s", strTime))
    -- 刷新百宝书页面
    win = GetUIWindow("TreasureBookUI")
    if win then
        win:RefreshUI()
    end
end

-- 百宝书预购结果
function OnRecv_TreasureBookEarlyBuyRes(iCode, kRetData)
    local code2msg = {
        [SNC_TREASURE_ADVANCE_PURCHASE_SUC] = "预购成功!",
        [SNC_TREASURE_ADVANCE_PURCHASE_FAIL] = "预购失败!",
        [SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_SUC] = "给好友预购成功!",
        [SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_FAIL] = "给好友预购失败!",
        [SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_LIMIT] = "给好友预购次数达到上限: " .. tostring(SSD_MAX_GIVE_FRIEND_ADVANCE_NUM),
    }
    -- 如果给好友开通成功了, 直接本地加1做显示
    local info = TreasureBookDataManager:GetInstance():GetTreasureBookBaseInfo()
    if info then
        if iCode == SNC_TREASURE_FRIEND_ADVANCE_PURCHASE_SUC then
            info.iGivedFriendAdvanceNum = (info.iGivedFriendAdvanceNum or 0) + 1
            -- 重新查询好友的数据, dwParam为传入的好友id
            -- TIPS: 现在每次进入赠送的好友列表时都会请求最新的好友数据, 这里送完之后不需要更新好友数据了
            -- 因为现在送完是直接关界面的, 如果之后需要开着界面刷新, 再启用这段代码
            -- SocialDataManager:GetInstance():UpdatePlayerData({tostring(kRetData.dwParam or 0)}, function()
            --     local win = GetUIWindow("TreasureBookEarlyBuyUI")
            --     if not win then
            --         return
            --     end
            --     local kOriFriendDatas = SocialDataManager:GetInstance():GetFriendData2() or {}
            --     win:SetDirtyFriendData(kOriFriendDatas, false)
            -- end)
        elseif iCode == SNC_TREASURE_ADVANCE_PURCHASE_SUC then
            local uiNewEndStamp = 0
            local bSendCurMonth = false
            local bSendNextMonth = false
            if kRetData then
                uiNewEndStamp = kRetData.dwParam2 or 0
            end
            if uiNewEndStamp > 0 then
                info.iPurchaseBookEndTime = uiNewEndStamp
                info.bAdvancePurchase = true
                info.bRMBPlayer = true
                local kCurDate = os.date("*t", os.time())
                local kNewDate = os.date("*t", uiNewEndStamp)
                bSendCurMonth = (kCurDate.year == kNewDate.year) and (kCurDate.month == kNewDate.month)
                bSendNextMonth = (kCurDate.year == kNewDate.year) and (kCurDate.month < kNewDate.month)
            end
            local uiSenderID = kRetData.dwParam or 0
            local kFriendInfo = SocialDataManager:GetInstance():GetFriendDataByID2(uiSenderID)
            if kFriendInfo and (bSendCurMonth or bSendNextMonth) then
                -- 弹框
                local strName = kFriendInfo.name or ""
                if strName == "" then
                    strName = STR_ACCOUNT_DEFAULT_PREFIX .. tostring(kFriendInfo.uid)
                end
                local strDateDesc = bSendCurMonth and "本月" or "下月"
                local strMsg = string.format("您的好友%s向您赠送了%s的壕侠百宝书。\n您%s任务获得的百宝书经验10%%贡献给他，同时您获得的任务经验也不会减少。", strName, strDateDesc, strDateDesc)
                SystemUICall:GetInstance():WarningBox(strMsg)
            end
        end
    end
    SystemUICall:GetInstance():Toast(code2msg[iCode] or "")
    if GetUIWindow("TreasureBookEarlyBuyUI") then
        OpenWindowImmediately("TreasureBookUI")
        RemoveWindowImmediately("TreasureBookEarlyBuyUI", false)
    end
end

-- 服务器通知每日银锭可领数量
function OnRecv_TreasureBookFriendRmbNum(iCode, kRetData)
    if not (kRetData and kRetData.dwParam) then
        return
    end
    local kBookMgr = TreasureBookDataManager:GetInstance()
    local kInfo = kBookMgr:GetTreasureBookBaseInfo()
    if not kInfo then
        return
    end
    kInfo.iDialyGiftNum = kRetData.dwParam
    kBookMgr:SetTreasureBookBaseInfo(kInfo)
end

-- 每日银锭领取结果
function OnRecv_GetDialyGiftRes(bSuccess)
    if bSuccess ~= true then
        SystemUICall:GetInstance():Toast("银锭领取失败!")
        return
    end
    local bookMgr = TreasureBookDataManager:GetInstance()
    local info = bookMgr:GetTreasureBookBaseInfo()
    if not info then
        return
    end
    info.bDayGiftGot = true
    bookMgr:SetTreasureBookBaseInfo(info)
    SystemUICall:GetInstance():Toast("银锭领取成功!")
end

-- 每周经验领取结果
function OnRecv_GetWeeklyGiftRes(bSuccess)
    if bSuccess ~= true then
        SystemUICall:GetInstance():Toast("经验领取失败!")
        return
    end
    local bookMgr = TreasureBookDataManager:GetInstance()
    local info = bookMgr:GetTreasureBookBaseInfo()
    if not info then
        return
    end
    info.bWeekGiftGot = true
    bookMgr:SetTreasureBookBaseInfo(info)
    SystemUICall:GetInstance():Toast("经验领取成功!")
end

-- 百宝书更新额外奖励领取等级
function OnRecv_TreasureBookExtraGetRewardLvl(iCode, kRetData)
    if not kRetData then
        return
    end
    -- 第一个参数用作新的额外奖励领取等级
    TreasureBookDataManager:GetInstance():UpdateTreasureBookExtraGetRewardLvl(kRetData.dwParam or 0)
end

-- 弹珠不足
function OnRecv_HoodleNumNotEnough()
    SystemUICall:GetInstance():Toast("弹珠数量不足!")
end

--
function OnRecv_MeridiansExpChange(iCode, kRetData)
    if not kRetData then
        return
    end
    if kRetData.dwParam == 0 then
        -- SystemUICall:GetInstance():Toast("经脉经验 -" .. kRetData.dwParam2);
    elseif kRetData.dwParam == 1 then
        SystemUICall:GetInstance():Toast("经脉经验 +" .. kRetData.dwParam2);
    end
    -- 刷新状态栏
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:RefreshMeridians()
    end
end

-- 完整版解锁
function OnRecv_ChallengeOrderUnlock(iCode, kRetData)
    if kRetData then
        SystemUICall:GetInstance():Toast("解锁完整版成功!")
        PlayerSetDataManager:GetInstance():SetChallengeOrderType(true)
        LuaEventDispatcher:dispatchEvent('CHALLENGEORDER_UNLOCK')

        -- 需要更新锁定的剧本信息
        local TB_PlusEditionConfig = TableDataManager:GetInstance():GetTable("PlusEditionConfig")
        for index, storyID in ipairs(TB_PlusEditionConfig[1].LockStorys) do
            SendClickQueryStoryCMD(storyID)
        end

        -- 如果玩家没有壕侠, 并且仓库里有壕侠代金券, 那么提醒用户需不需要用代金券开启壕侠
        if not TreasureBookDataManager:GetInstance():GetTreasureBookVIPState() then
            StorageDataManager:GetInstance().bTellUseTreasureBookTicket = true
        end
    end
end

-- 皮肤解锁
function OnRecv_SkinUnlock(iCode, kRetData)
    if kRetData then
        local TB_CreateRole = TableDataManager:GetInstance():GetTable("CreateRole")
        if TB_CreateRole then
            if TB_CreateRole[kRetData.dwParam] then
                local createRole = TB_CreateRole[kRetData.dwParam]
                local str = string.format("已解锁 %s 角色", GetLanguageByID(createRole.Title))
                SystemUICall:GetInstance():Toast(str)
            end
        end
    end
end



-- 三天签到买马成功
function OnRecv_Day3SignInNotify_BuyHorse()
    local strTarRoleName = Day3SignInDataManager:GetInstance():GetTarRoleName() or ""
    SystemUICall:GetInstance():Toast(string.format("购买成功, %s成功抵达!", strTarRoleName))
    -- 关闭活动入口
    Day3SignInDataManager:GetInstance():CloseActivity()
end

-- 三天签到加入队伍
function OnRecv_Day3SignInNotify_JoinTeam()
    local strTarRoleName = Day3SignInDataManager:GetInstance():GetTarRoleName() or ""
    SystemUICall:GetInstance():Toast(string.format("%s成功抵达!", strTarRoleName))
    -- 关闭活动入口
    Day3SignInDataManager:GetInstance():CloseActivity()
end

-- 新门派签到回调
function OnRecv_OperatorSignInFlagRet(icode, kRetData)
    if not kRetData then
        return
    end

    if kRetData['dwParam2'] ~= 0 then
        dprint("OnRecv_OperatorSignInFlagRet ErrorCode: ".. kRetData['dwParam2'] )
        SystemUICall:GetInstance():Toast("数据信息不一致["..kRetData['dwParam2'].."]，请报bug")
        return
    end
    
    -- 数据更新
    PlayerSetDataManager:GetInstance():SetSignInFlag(kRetData["dwParam"])

    -- UI更新
    local window = GetUIWindow("ActivitySignUI")
    if window and window:IsOpen() then
        window:RefreshUI()
    end
    window = GetUIWindow("HouseUI")
    if window and window:IsOpen() then
        window:RefreshActivitySign()
    end
end

-- 收到百宝书基础信息
function OnRecv_CMD_GAC_QUERYTREASUREBOOKBASEINFORET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYTREASUREBOOKBASEINFORET")
    if not kRetData then
        return
    end
    TreasureBookDataManager:GetInstance():UpdateTreasureBookBaseInfo(kRetData.kBaseInfo)
end

-- 收到百宝书任务信息
function OnRecv_CMD_GAC_QUERYTREASUREBOOKTASKINFORET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYTREASUREBOOKTASKINFORET")
    if kRetData.eTaskType == STBTT_ACTIVITY or kRetData.eTaskType == STBTT_ACTIVITY_BACKFLOW or kRetData.eTaskType == STBTT_ACTIVITY_FESTIVAL_DIALY then
        ActivityHelper:GetInstance():UpdatePreExperienceData(kRetData)
    else
        TreasureBookDataManager:GetInstance():UpdateTaskProgressData(kRetData)
    end
end

-- 收到百宝书兑换商店信息
function OnRecv_CMD_GAC_QUERYTREASUREBOOKMALLINFORET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYTREASUREBOOKMALLINFORET")
    TreasureBookDataManager:GetInstance():UpdateTreasureBookStoreData(kRetData)
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Store) then
        win.TreasureBookStoreUIInst:UpdateCurChooseMallItemDetail()
    end
end

-- 收到百宝书全服等级进度信息
function OnRecv_CMD_GAC_QUERYTREASUREBOOKALLREWARDPROGRESSRET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYTREASUREBOOKALLREWARDPROGRESSRET")
    TreasureBookDataManager:GetInstance():UpdateTreasureBookServerProgressData(kRetData)
end

-- 领取全服等级奖励的下行
function OnRecv_CMD_GAC_QUERYTREASUREBOOKGETPROGRESSREWARDRET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYTREASUREBOOKGETPROGRESSREWARDRET")
    if not kRetData then
        return
    end
    if kRetData.bOpr ~= 1 then
        SystemUICall:GetInstance():Toast("领取失败")
        return
    end
    -- 一般道具进入仓库会有toast提示, 但是自动使用的物品不会进入仓库, 这里对自动使用物品做个提示
    -- 如果是全服奖励, 判断物品自动使用特性, 否则, 查询百宝书自动使用物品表
    local iNum = kRetData.iNum or 0
    local akItem = kRetData.akItem or {}
    local itemTypeID, itemTypeData, itemNum = nil, nil, nil
    local bItemCanAutoUse = function(kItemTypeData)
        if not (kItemTypeData and kItemTypeData.Feature) then
            return false
        end
        for index, eFeature in ipairs(kItemTypeData.Feature) do
            if eFeature == ItemFeature.IF_AutoUse then
                return true
            end
        end
    end
    -- 全服等级奖励以及个人等级奖励都走这个下行, 只不过请求的枚举不一样
    if kRetData.eQueryType == STBQT_PROGRESS_REWARD then
        TreasureBookDataManager:GetInstance():UpdateTreasureBookServerProgressFlag(
            kRetData.dwProgressRewardFlag or 0,
            kRetData.dwRMBProgressRewardFlag or 0)
            -- 物品提示
            for index = 0, iNum - 1 do
                itemTypeID = akItem[index].uiItemID
                -- 残页这里不提示
                if itemTypeID ~= 9660 then
                    itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
                    if bItemCanAutoUse(itemTypeData) then
                        itemNum = akItem[index].uiItemNum or 0
                        SystemUICall:GetInstance():Toast(string.format("获得%sx%d", itemTypeData.ItemName, itemNum))
                    end
                end
            end
    elseif (kRetData.eQueryType == STBQT_LVL_REWARD) or (kRetData.eQueryType == STBQT_LVL_CAN_REWARD) then
        TreasureBookDataManager:GetInstance():UpdateTreasureBookRewardFlag(
            kRetData.dwLvlRewardFlag1,
            kRetData.dwLvlRewardFlag2,
            kRetData.dwRMBLvlRewardFlag1,
            kRetData.dwRMBLvlRewardFlag2)
        -- 物品提示
        local autoUseList = TreasureBookDataManager:GetInstance():GetCurBookAutoUseItemList() or {}
        for index = 0, iNum - 1 do
            itemTypeID = akItem[index].uiItemID
            -- 残页这里不提示
            if itemTypeID ~= 9660 then
                itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
                if (autoUseList[itemTypeID] == true) and (itemTypeData ~= nil) then
                    itemNum = akItem[index].uiItemNum or 0
                    SystemUICall:GetInstance():Toast(string.format("获得%sx%d", itemTypeData.ItemName, itemNum))
                end
            end
        end
    end
end

--============================================================
-- 擂台
function OnRecv_CMD_GAC_QueryPlatTeamInfoRet(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_QueryPlatTeamInfoRet======>')
    if kRetData.bEnd == 0 then
        local info = clone(kRetData);
        if kRetData.eQueryType == SPTQT_SCRIPT then
            local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
            globalDataPool:setData(dataType, info, true);
        elseif kRetData.eQueryType == SPTQT_PLAT then
            globalDataPool:setData('PlatTeamInfo', info, true);
        elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
            --重新整理一下经脉数据
            if info.iMeridiansNum ~= nil then
                local breakData = {}
                local akMeridians = {}
                local TB_Acupoint = TableDataManager:GetInstance():GetTable("Acupoint")
                for i = 0,info.iMeridiansNum -1 do
                    local iAcupointID = info.akMeridians[i].uiKey
                    local iLevel = info.akMeridians[i].uiValue
                    if iLevel % 1000 == 0 then
                        local iOwnerMeridian = TB_Acupoint[iAcupointID % 1000].OwnerMeridia
                        local kData = { dwMeridianID = iOwnerMeridian, dwAcupointID = iAcupointID, dwLevel = iLevel}
                        breakData[iAcupointID] = kData
                    else
                        local iOwnerMeridian = TB_Acupoint[iAcupointID].OwnerMeridian
                        akMeridians[iAcupointID] =  { dwMeridianID = iOwnerMeridian, dwAcupointID = iAcupointID, dwLevel = iLevel}
                    end
                end
                info.akMeridians = akMeridians
                info.breakData = breakData
            end
            globalDataPool:setData('ObserveInfo', info, true);
        elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
            globalDataPool:setData('ObserveArenaInfo', info, true);
        end
    else
        if kRetData.eQueryType == SPTQT_SCRIPT then
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_TEAMOUTUI', kRetData);
        elseif kRetData.eQueryType == SPTQT_PLAT then
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_PLATETEAM', kRetData);
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_PLAYERSPINE', kRetData);
        elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_OBAERVEUI', kRetData);
        elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_SHOW_OBSERVE', kRetData and kRetData.defPlayerID or 0);
        end 
    end
end

function OnRecv_CMD_GAC_CopyTeamInfoRet(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_CopyTeamInfoRet======>')
    if kRetData.bResult == 1 then
        LuaEventDispatcher:dispatchEvent('ONEVENT_COPYTEAM', kRetData);
    else
        LuaEventDispatcher:dispatchEvent('ONEVENT_COPYTEAM', kRetData);
    end
end

function OnRecv_CMD_GAC_PlatEmbattleRet(kRetData)
    dprint('<======OnRecv_CMD_GAC_PlatEmbattleRet======>')

end

function OnRecv_CMD_GAC_PlatTeam_RoleCommon(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_RoleCommon======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    local cloneRole = clone(kRetData.kPlatRoleCommon);
    if not info.RoleInfos[kRetData.kPlatRoleCommon.uiID] then
        if kRetData.eQueryType == SPTQT_PLAT or kRetData.eQueryType == SPTQT_OBSERVE_OTHER 
            or kRetData.eQueryType == SPTQT_OBSERVE_ARENA  then
            local houseRole = HouseRole.new(kRetData.kPlatRoleCommon.uiID,cloneRole);
            houseRole:SetQueryType(kRetData.eQueryType)
            info.RoleInfos[kRetData.kPlatRoleCommon.uiID] = houseRole
        else
            info.RoleInfos[kRetData.kPlatRoleCommon.uiID] = InstRole.new(kRetData.kPlatRoleCommon.uiID,cloneRole);
        end
    end 

    for k, v in pairs(kRetData.kPlatRoleCommon) do
        info.RoleInfos[kRetData.kPlatRoleCommon.uiID][k] = v;
    end

    -- info.RoleInfos[kRetData.kPlatRoleCommon.uiID].roleType = ROLE_TYPE.INST_ROLE;
end

function OnRecv_CMD_GAC_PlatTeam_RoleAttrs(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_RoleAttrs======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    if not info.RoleInfos[kRetData.uiID] then
        info.RoleInfos[kRetData.uiID] = {};
    end

    info.RoleInfos[kRetData.uiID].aiAttrs = clone(kRetData.aiAttrs);
end

function OnRecv_CMD_GAC_PlatTeam_RoleItems(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_RoleItems======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    if not info.RoleInfos[kRetData.uiID] then
        info.RoleInfos[kRetData.uiID] = {};
    end

    info.RoleInfos[kRetData.uiID].auiRoleItem = clone(kRetData.auiRoleItem);
    info.RoleInfos[kRetData.uiID].akEquipItem = clone(kRetData.auiEquipItem);
end

function OnRecv_CMD_GAC_PlatTeam_RoleMartials(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_RoleMartials======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    if not info.RoleInfos[kRetData.uiID] then
        info.RoleInfos[kRetData.uiID] = {};
    end

    info.RoleInfos[kRetData.uiID].auiRoleMartials = clone(kRetData.auiRoleMartials);
    info.RoleInfos[kRetData.uiID].akEmBattleMartialInfo = clone(kRetData.akEmBattleMartialInfo);
end

function OnRecv_CMD_GAC_PlatTeam_RoleGift(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_RoleGift======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    if not info.RoleInfos[kRetData.uiID] then
        info.RoleInfos[kRetData.uiID] = {};
    end

    info.RoleInfos[kRetData.uiID].auiRoleGift = clone(kRetData.auiRoleGift);
    info.RoleInfos[kRetData.uiID].uiGiftNum = kRetData.giftNum;
    info.RoleInfos[kRetData.uiID].uiGiftUsedNum = 0;

end

function OnRecv_CMD_GAC_PlatTeam_RoleWishTasks(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_RoleWishTasks======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    if not info.RoleInfos[kRetData.uiID] then
        info.RoleInfos[kRetData.uiID] = {};
    end

    info.RoleInfos[kRetData.uiID].auiRoleWishTasks = clone(table_c2lua(kRetData.auiRoleWishTasks));
end

function OnRecv_CMD_GAC_PlatTeam_ItemInfo(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_ItemInfo======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.ItemInfos then
        info.ItemInfos = {};
    end

    local luaTable = table_c2lua(kRetData.akRoleItem);
    for i = 1, #(luaTable) do
        info.ItemInfos[luaTable[i].uiID] = luaTable[i];
    end
end

function OnRecv_CMD_GAC_PlatTeam_MartialInfo(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_MartialInfo======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    if not info.WishTaskInfo then
        info.MartialInfo = {};
    end

    local luaTable = table_c2lua(kRetData.akRoleMartial);
    for i = 1, #(luaTable) do
        if not info.RoleInfos[luaTable[i].uiRoleUID] then
            info.RoleInfos[luaTable[i].uiRoleUID] = {};
        end
        if not info.RoleInfos[luaTable[i].uiRoleUID].MartialsTypeIDValue then
            info.RoleInfos[luaTable[i].uiRoleUID].MartialsTypeIDValue = {};
        end

        info.RoleInfos[luaTable[i].uiRoleUID].MartialsTypeIDValue[luaTable[i].uiTypeID] = luaTable[i];
        info.MartialInfo[luaTable[i].uiID] = luaTable[i];
    end
end

function OnRecv_CMD_GAC_PlatTeam_WishTaskInfo(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_WishTaskInfo======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.WishTaskInfo then
        info.WishTaskInfo = {};
    end

    local luaTable = table_c2lua(kRetData.akRoleWishTask);
    for i = 1, #(luaTable) do
        info.WishTaskInfo[luaTable[i].uiID] = luaTable[i];
    end
end

function OnRecv_CMD_GAC_PlatTeam_GiftInfo(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_GiftInfo======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');
    end
    if info == nil then 
        return
    end
    if not info.GiftInfo then
        info.GiftInfo = {};
    end

    local luaTable = table_c2lua(kRetData.akRoleGift);
    for i = 1, #(luaTable) do
        info.GiftInfo[luaTable[i].uiID] = luaTable[i];
    end
end

function OnRecv_CMD_GAC_PlatTeam_EmbattleInfo(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatTeam_EmbattleInfo======>')
    local info = nil;
    if kRetData.eQueryType == SPTQT_SCRIPT then
        local dataType = 'ScriptTeamInfo' .. kRetData.dwScriptID;
        info = globalDataPool:getData(dataType);
    elseif kRetData.eQueryType == SPTQT_PLAT then
        info = globalDataPool:getData('PlatTeamInfo');

        RoleDataManager:GetInstance():InitTownRoleEmbattleData(kRetData.akRoleEmbattle);
        RoleDataManager:GetInstance():InitTownPetEmbattleData(info.akPets);

        if not info.EmbattleInfo then
            info.EmbattleInfo = table_c2lua(kRetData.akRoleEmbattle);
        end
    elseif kRetData.eQueryType == SPTQT_OBSERVE_OTHER then
        info = globalDataPool:getData('ObserveInfo');

        if not info.EmbattleInfo then
            info.EmbattleInfo = table_c2lua(kRetData.akRoleEmbattle);
        end
    elseif kRetData.eQueryType == SPTQT_OBSERVE_ARENA then
        info = globalDataPool:getData('ObserveArenaInfo');

        if not info.EmbattleInfo then
            info.EmbattleInfo = table_c2lua(kRetData.akRoleEmbattle);
        end
    end
end

function OnRecv_CMD_GAC_SetMainRole(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_SetMainRole======>')
    if kRetData.bResult == 1 then
        LuaEventDispatcher:dispatchEvent("ONEVENT_REF_ANI");
    end
end

function OnRecv_CMD_GAC_UPDATEARENAMATCHDATA(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENAMATCHDATA======>')
    ArenaDataManager:GetInstance():SetMatchData(kRetData);
end

function OnRecv_CMD_GAC_UPDATEARENABATTLEDATA(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENABATTLEDATA======>')
    ArenaDataManager:GetInstance():SetBattleData(kRetData);
end

function OnRecv_CMD_GAC_UPDATESIGNUPNAME(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATESIGNUPNAME======>')
    ArenaDataManager:GetInstance():SetFinalJoinNamesData(kRetData);
end

function OnRecv_CMD_GAC_ARENABATTLERECORDDATA(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_ARENABATTLERECORDDATA======>')
    ---------------- SQT
    globalTimer:AddTimer(100, function()
        RemoveWindowImmediately('LoadingUI')
    end, 1);
    OnArenaReplayData(kRetData)
end

function OnRecv_CMD_GAC_UPDATEARENABETRANKDATA(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENABETRANKDATA======>')
    ArenaDataManager:GetInstance():SetRankData(kRetData);
end

function OnRecv_CMD_GAC_OBSERVEPLATROLERET(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENABETRANKDATA======>')
    local info = globalDataPool:getData('ObserveInfo') or {};
    if not info.RoleInfos then
        info.RoleInfos = {};
    end

    if not info.RoleInfos[kRetData.uiRoleID] then
        info.RoleInfos[kRetData.uiRoleID] = InstRole.new(0,{});
    end

    for k, v in pairs(kRetData.kPlatRoleCommon) do
        info.RoleInfos[kRetData.uiRoleID][k] = v;
    end

    info.RoleInfos[kRetData.uiRoleID].roleType = ROLE_TYPE.INST_ROLE;
    info.RoleInfos[kRetData.uiRoleID].aiAttrs = clone(kRetData.aiAttrs);
    info.RoleInfos[kRetData.uiRoleID].auiRoleGift = clone(kRetData.auiRoleGift);
    info.RoleInfos[kRetData.uiRoleID].akEquipItem = clone(kRetData.auiEquipItem);
    local luaTable = table_c2lua(kRetData.akRoleItem);
    for i = 1, #(luaTable) do
        if not info.ItemInfos then
            info.ItemInfos = {};
        end
        info.ItemInfos[luaTable[i].uiID] = luaTable[i];
    end

    for i = 0, getTableSize2(kRetData.auiRoleMartial) - 1 do
        if not info.RoleInfos[kRetData.uiRoleID].auiRoleMartials then
            info.RoleInfos[kRetData.uiRoleID].auiRoleMartials = {};
        end
        info.RoleInfos[kRetData.uiRoleID].auiRoleMartials[i] = kRetData.auiRoleMartial[i].uiKey;
    
        if not info.MartialInfo then
            info.MartialInfo = {};
        end
        local tempT = {};
        tempT.uiLevel = kRetData.auiRoleMartial[i].uiKey;
        tempT.uiTypeID = kRetData.auiRoleMartial[i].uiValue;
        info.MartialInfo[kRetData.auiRoleMartial[i].uiKey] = tempT;
    end

    globalDataPool:setData('ObserveInfo', info, true);
end

function OnRecv_CMD_GAC_UPDATEARENAMATCHHISTORYDATA(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENAMATCHHISTORYDATA======>')
    ArenaDataManager:GetInstance():SetHistoryData(kRetData);
end

function OnRecv_CMD_GAC_NOTIFYARENANOTICE(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_NOTIFYARENANOTICE======>')
    if kRetData.uiNoticeFlag == ARENA_NOTICE_SIGNUP then
        if kRetData.defPlyID1 ~= PlayerSetDataManager:GetInstance():GetPlayerID() then
            local strText = '%s报名了大师赛%s比赛';
            local matchType = kRetData.dwMatchType == 5 and '单人' or '组队';
            strText = string.format(strText, kRetData.acName1, matchType);
            SystemUICall:GetInstance():AddBubble(strText);
        end
    elseif kRetData.uiNoticeFlag == ARENA_NOTICE_BET then
        local strText = '%s对%s进行舞龙舞狮助威，祝他旗开得胜';
        strText = string.format(strText, kRetData.acName1, kRetData.acName2);
        SystemUICall:GetInstance():BarrageShow(strText);
    end
end

function OnRecv_CMD_GAC_UPDATEARENAMATCHJOKEBATTLEDATA(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENAMATCHJOKEBATTLEDATA======>')
    ArenaDataManager:GetInstance():SetJokeData(kRetData);
end

function OnRecv_CMD_GAC_UPDATEARENAMATCHCHAMPIONTIMES(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENAMATCHCHAMPIONTIMES======>')
    ArenaDataManager:GetInstance():SetChampionData(kRetData);
end

function OnRecv_CMD_GAC_UPDATEARENAHUASHAN(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_UPDATEARENAHUASHAN======>')
    ArenaDataManager:GetInstance():SetHuaShanNames(kRetData);
end
--============================================================
function OnRecv_CMD_GAC_RETROLEPETCARDOPERATE(kRetData)
    CardsUpgradeDataManager:GetInstance():SetRolePetInfo(kRetData)
end

-- 弹珠台基础信息下行
function OnRecv_CMD_GAC_QUERYHOODLELOTTERYBASEINFORET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYHOODLELOTTERYBASEINFORET")
    if not PinballDataManager:GetInstance():SetPoolBaseInfoWithType(kRetData) then
        -- 如果下行的奖池数据不是当前正在显示的奖池, 那么不刷新界面
        return
    end
    local win = GetUIWindow("PinballGameUI")
    if win then
        win:OnRecvPollBaseInfo()
    end 
end

-- 弹珠台奖池结果信息下行 执行单条结果
function OnRecv_CMD_GAC_QUERYHOODLELOTTERYRESULTRET_SINGLE(kRetData)
    local kPinballMgr = PinballDataManager:GetInstance()
    if kRetData.bGroupEnd == 0 then
        kPinballMgr:EnqueueHoodleRetData(kRetData)
        return
    end
    local win = GetUIWindow("PinballGameUI")
    if kPinballMgr:IsHoddleRetDataQueueEmpty() then
        if win then
            win:OnRecvShootBallPath(kRetData)
        end 
    else
        kPinballMgr:EnqueueHoodleRetData(kRetData)
        local kQueue = kPinballMgr:GetHoodleRetDataQueue()
        kPinballMgr:ClearHoodleRetDataQueue()
        if win then
            win:OnRecvShootBallPathQueue(kQueue)
        end 
    end
end

-- 弹珠台奖池结果信息下行
function OnRecv_CMD_GAC_QUERYHOODLELOTTERYRESULTRET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYHOODLELOTTERYRESULTRET")
    local strInfosKey = "akRetInfo"
    local akRetInfo = kRetData[strInfosKey]
    if (not akRetInfo) or (not next(akRetInfo)) then
        return
    end
    local uiEndIndex = #akRetInfo
    for uiIndex = 0, uiEndIndex, 1 do
        local kInfo = akRetInfo[uiIndex] or {}
        local kNewSingleInfo = {}
        for strKey, kData in pairs(kRetData) do
            if strKey ~= strInfosKey then
                kNewSingleInfo[strKey] = kData
            end
        end
        local akFliterBoxInfos = {}
        local uiBoxInfoCount = 0
        local akBoxInfos = kInfo.akBoxInfo or {}
        local uiBoxStartIndex = akBoxInfos[0] and 0 or 1
        for uiBoxIndex = uiBoxStartIndex,  #akBoxInfos, 1 do
            local kBoxInfo = akBoxInfos[uiBoxIndex]
            if kBoxInfo.eProgressType and (kBoxInfo.eProgressType > 0) then
                akFliterBoxInfos[uiBoxInfoCount] = kBoxInfo
                uiBoxInfoCount = uiBoxInfoCount + 1
            end
        end
        kNewSingleInfo.akBoxInfo = akFliterBoxInfos
        kNewSingleInfo.dwHitBoxNum = uiBoxInfoCount
        kNewSingleInfo.kHitSlotInfo = kInfo.kHitSlotInfo or {}
        kNewSingleInfo.bSpecialHoodle = kInfo.bSpecialHoodle or 0
        kNewSingleInfo.dwSpecialSlotProgress = kInfo.dwSpecialSlotProgress or 0
        kNewSingleInfo.bGroupEnd = (uiIndex == uiEndIndex) and 1 or 0
        OnRecv_CMD_GAC_QUERYHOODLELOTTERYRESULTRET_SINGLE(kNewSingleInfo)
    end
end

-- 弹珠台奖池开放情况
function OnRecv_CMD_GAC_QUERYHOODLELOTTERYOPENINFORET(kRetData)
    dprint("OnRecv_CMD_GAC_QUERYHOODLELOTTERYOPENINFORET")
    PinballDataManager:GetInstance():SetPoolState(kRetData.acPoolOpenInfo)
    local win = GetUIWindow("PinballGameUI")
    if not win then
        return
    end
    win:OnRecvPinballPoolState()
end

-- 更新弹珠台弹珠数量
function OnRecv_CMD_GAC_HOODLENUMRET(kRetData)
    dprint("OnRecv_CMD_GAC_HOODLENUMRET")
    if not kRetData then
        return
    end
    local ePoolType = kRetData.ePoolType
    -- 如果池类型为 SHLPT_NULL (0), 表示为侠客行全局数据(例如累计弹珠数量)
    if not ePoolType then
        return
    end
    local kPinBallMgr = PinballDataManager:GetInstance()
    local eRetBallType = kRetData.eHoodleBallType
    local dwCurNum = kRetData.dwCurNum or 0
    if eRetBallType == SHBT_FORTENSHOOT then
        kPinBallMgr:SetHoodleAccNum(dwCurNum)
        return
    end
    -- 其余的下行表示更新某个类型奖池的弹珠数量数据
    local kBaseInfo = kPinBallMgr:GetPoolBaseInfoWithType(ePoolType)
    if not kBaseInfo then
        kBaseInfo = {
            ['dwCurPoolHoodleNum'] = 0,
            ['dwCurPoolFreeHoodleNum'] = 0,
            ['dwCurPoolDailyFreeHoodleNum'] = 0,
        }
    end
    if eRetBallType == SHBT_NORMAL then
        kBaseInfo.dwCurPoolHoodleNum = dwCurNum
        
        -- 刷新包裹
        StorageDataManager:GetInstance():DispatchUpdateEvent()
    elseif eRetBallType == SHBT_SPECIAL then
        kBaseInfo.dwCurPoolFreeHoodleNum = dwCurNum
    elseif eRetBallType == SHBT_DAILYFREE then
        kBaseInfo.dwCurPoolDailyFreeHoodleNum = dwCurNum
    end
    kPinBallMgr:SetPoolBaseInfoWithType({
        ['ePoolType'] = ePoolType,
        ['kBaseInfo'] = kBaseInfo,
    })
    local winPinballl = GetUIWindow("PinballGameUI")
    if winPinballl then
        winPinballl:InitShootBtn()
    end
    local winNavBar = GetUIWindow("NavigationUI")
    if winNavBar then
        winNavBar:RefreshPinballRedPoint()
    end
end

-- 侠客行全服玩法
function OnRecv_CMD_GAC_HOODLEPUBLICINFORET(kRetData)
    dprint("OnRecv_CMD_GAC_HOODLEPUBLICINFORET")
    if not (kRetData and kRetData.PublicInfo) then
        return
    end
    -- ui
    local objUI = nil
    local kUI = nil
    local win = GetUIWindow("PinballGameUI")
    if win and win.objServerPlay then
        objUI = win.objServerPlay
        kUI = win.PinballServerPlayInst
    end
    local kPublicInfo = kRetData.PublicInfo

    -- kPublicInfo.uiOpenId = 1
    -- qcprint(string.format("--------------------------\bResult: %s,\nProgress: %d,\nQueueIndex: %d,\n", 
    -- tostring(kPublicInfo.bResult == 1),
    -- kPublicInfo.uiTotal,
    -- kPublicInfo.uiTurns))

    local DoClose = function()
        if kUI then
            kUI:CloseAutoRequestTimer()
            -- 开启较慢的自动请求计时器, 这样在下一期新活动开启的时候, 可以自动请求到新数据
            kUI:OpenAutoRequestTimer(true, false, true)
        end
        if objUI then
            objUI:SetActive(false)
        end
    end

    -- 获取是否开启活动
    if kPublicInfo.bOpen ~= 1 then
        DoClose()
        return
    end

    -- 活动是否已经结束
    if kPublicInfo.bUseUp > 0 then
        DoClose()
        return
    end

    -- local bIsGetReward = (kPublicInfo.bResult == 1)  -- 此次是否是获得了奖励
    local kPinballMgr = PinballDataManager:GetInstance()
    -- 通过活动静态数据初始化活动数据
    local bInitRes = kPinballMgr:SetServerPlayActivityData(kPublicInfo.uiOpenId)
    if not bInitRes then
        DoClose()
        return
    end

    local kBaseDataInfo = kRetData.DataInfo or {}
    -- 缓存奖池数据
    kPinballMgr:CacheRewardPoolData(kBaseDataInfo.akAllItem, kRetData.uiCurItemId)
    kPinballMgr:CacheRewardsQueueData(kBaseDataInfo.akShowItem)
    kPinballMgr:CachePointExchangeReward(kBaseDataInfo.akExchange)
    kPinballMgr:CacheServerPlayActivityTime(kBaseDataInfo.uiBeginTime, kBaseDataInfo.uiEndTime)
    kPinballMgr:CacheServerPlayActivityAdImgPath(kBaseDataInfo.acResource)

    -- 初始夺宝进度
    kPinballMgr:SetServerPlayProgress(kPublicInfo.uiTotal, kPublicInfo.uiNeedTotal)
    -- 初始化进度推进者
    kPinballMgr:SetServerPlayPushers(kPublicInfo.akHoodlePlayer, kPublicInfo.uiPlayerNum)
    -- 设置贡献排名玩家
    kPinballMgr:SetServerPlayDevotedPlayers(kPublicInfo.akPersonalProc, kPublicInfo.uiPersonalNum, kPublicInfo.uiNeedTotal)
    -- 分发事件
    kPinballMgr:DispatchServerPlayUpdateEvent()
    -- if bIsGetReward then
    --     kPinballMgr:DispatchServerPlayGetRewardEvent()
    -- end
    if win then
        -- objUI:SetActive(true)
        win:ShowGlobal()
    end
end

-- 侠客行全服玩法领奖记录
function OnRecv_CMD_GAC_HOODLEPUBLICRECORDRET(kRetData)
    dprint("OnRecv_CMD_GAC_HOODLEPUBLICRECORDRET")
    if not kRetData then
        return
    end
    -- ui
    local win = GetUIWindow("PinballServerPlayRecordUI")
    if not win then
        return
    end
    local bIsEmpty = (kRetData.iSize == 0)
    win:SetRecBoard(kRetData.iCurPage, kRetData.akHoodleRecord, bIsEmpty)
end

-- 侠客行最高贡献获奖推送
function OnRecv_CMD_GAC_HOODLEPUBLICASSISTREWARD(kRetData)
    dprint("OnRecv_CMD_GAC_HOODLEPUBLICASSISTREWARD")
    if (not kRetData)
    or (not kRetData.dwItemId) or (kRetData.dwItemId == 0)
    or (not kRetData.dwItemNum) or (kRetData.dwItemNum == 0) then
        return
    end
    -- 侠客行界面开启的时候, 不用管这个下行, 侠客行自己会在结算轮显示奖励数据
    -- if IsWindowOpen("PinballGameUI") then
    --     return
    -- end
    local kRewardInfo = {[0] = {
        ["dwItemTypeID"] = kRetData.dwItemId,
        ["dwNum"] = kRetData.dwItemNum,
    }}
    OpenWindowImmediately("GiftBagResultUI", kRewardInfo)
end

-- 侠客行个人奖池
function OnRecv_CMD_GAC_QUERYHOODLEPRIVACYRESULTRET(kRetData)
    PinballDataManager:GetInstance():SetPrivacyPool(kRetData)
end

--==========================================================
-- 商城
function OnRecv_CMD_GAC_PlatShopMallRewardRet(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatShopMallRewardRet======>')
    if kRetData.eType == PSMRRT_SUCCESS then

    elseif kRetData.eType == PSMRRT_FAILED then

    elseif kRetData.eType == PSMRRT_CURREWARDVALUE then
        ShoppingDataManager:GetInstance():SetBegValue(kRetData);
    end
end

function OnRecv_CMD_GAC_PlatShopMallQueryItemRet(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatShopMallQueryItemRet======>')
    ShoppingDataManager:GetInstance():SetShopData(kRetData);
end

function OnRecv_CMD_GAC_PlatShopMallBuyRet(kRetData)
    -- dprint('<======OnRecv_CMD_GAC_PlatShopMallBuyRet======>')
    if kRetData.eType == PSMBRT_SUCCESS then
        -- 如果购买成功, 并且在弹珠界面, 说明是在弹珠界面直购了侠客经脉丹, 那么直接发射一颗弹珠出去
        local win = GetUIWindow("PinballGameUI")
        if win and win:IsOpen() then
            win:OnClickShoot()
            return
        end

        local shoppingMallUI = GetUIWindow("ShoppingMallUI");
        if shoppingMallUI and shoppingMallUI:IsOpen() then
            shoppingMallUI:RequestItemInfo();
        end


        LuaEventDispatcher:dispatchEvent('REQUEST_SHOPPINGLIST')

        local activitySignMallUI = GetUIWindow("ActivitySignMallUI");
        if activitySignMallUI and activitySignMallUI:IsOpen() then
            activitySignMallUI:OnBuySuccess();
        end

        local uiActivity = GetUIWindow("ActivityUI")
        if uiActivity and uiActivity:IsOpen() then
            uiActivity:OnBuySuccess()
        end
    else
        SystemUICall:GetInstance():Toast('购买失败!');
    end
end
--==========================================================

--==========================================================
function OnRecv_CMD_GAC_PLATDISPLAYNEWTOAST(kRetData)
    DisplayNetMsgToast(kRetData)
end

function OnRecv_CMD_GAC_SYNCTSSDATASENDTOCLIENT(kRetData)
    RecvTssData(kRetData["acAntiData"])
end
--==========================================================

--金锭兑换银锭
function OnRecv_CMD_GAC_EXCHANGEGOLDTOSILVERRET(kRetData)
    local bSuccess = (kRetData.bResult == 1)
    --处理逻辑
    if bSuccess then
        SystemUICall:GetInstance():Toast("兑换成功!")
        -- 如果存在兑换后回调, 那么执行
        PlayerSetDataManager:GetInstance():DoSilverExchangeCallBack()
    else
        SystemUICall:GetInstance():Toast("兑换失败!")
    end
end

function OnRecv_CMD_GAC_QUERYFORBIDINFORET(kRetData)
    PlayerSetDataManager:GetInstance():SetPlayerForbidInfo(kRetData["bAdd"],kRetData["akRet"],kRetData["iNum"]);
end

--设置腾讯信用分
function OnRecv_CMD_GAC_QueryTencentCreditScoreRet(kRetData)
    PlayerSetDataManager:GetInstance():SetTencentCreditScore(kRetData and kRetData.TencentCreditScore and kRetData.TencentCreditScore.iScore or 0)
end
--设置聊天不可私聊
function OnRecv_CMD_GAC_RequestPrivateChatSceneLimitRet(kRetData)
    PlayerSetDataManager:GetInstance():SetTXCreditSceneLimit(kRetData and kRetData.akTencentSceneLimitState)
end

function OnRecv_CMD_GAC_LimitShopRet(kRetData)
    --数据查询成功
    if kRetData.iResult == 0 then 
        local dkJson = require("Base/Json/dkjson")
        local data = dkJson.decode(kRetData.acShopInfo) or {};
        LimitShopManager:GetInstance():SetRetDataShop(data)
    else
        if kRetData.iResult == 1004 then --刷新冷却中

        else 
            local a = 0
        end
    end

end

function OnRecv_CMD_GAC_GETREDPACKETRET(kRetData)
    local tipMsg = {
        [SNC_SUC_GETREDPACKET] = "红包领取成功",              
        [SNC_NOT_EXIST_REDPACKET] = "红包已被领取完",           
        [SNC_HADGET_REDPACKET] = "红包已领取",              
        [SNC_NOT_ENOUGH_REDPACKET] = "红包已被领取完",          
        [SNC_OVERTIME_REDPACKET] = "红包已过期",     
    }

    if tipMsg[kRetData.ret + SNC_SUC_GETREDPACKET] then
        SystemUICall:GetInstance():Toast(tipMsg[kRetData.ret + SNC_SUC_GETREDPACKET])
        LuaEventDispatcher:dispatchEvent('ONEVENT_REF_GETREDPACKET', kRetData);
        MoneyPacketDataManager:GetInstance():DelPacketData(kRetData)
    end
end

-- 服务器下行三天签到数据
function OnRecv_CMD_GAC_DAY3SINGINRET(kRetData)
    if not kRetData then
        return
    end
    Day3SignInDataManager:GetInstance():OnRecvServerData(kRetData)
end

-- 服务器下行提醒
function OnRecv_CMD_GAC_CHECKTENCENTANTIADDICTIONRET(kRetData)
    local dkJson = require("Base/Json/dkjson")
    local data = dkJson.decode(kRetData.acMessage)
    if data == nil or data.instructions == nil or #data.instructions <= 0 then 
        dwarning('CMD_GAC_CHECKTENCENTANTIADDICTIONRET, Empty msg!')
        return 
    end
    local msgType = data.instructions[1].type
    local title = data.instructions[1].title
    local msg = data.instructions[1].msg
    local info = {
        ["title"] = title,
        ["text"] = msg or '',
        ['leftBtnText'] = '关闭',
    }
    if msgType == STAAIT_LOGOUT then 
        DRCSRef.LuaBehaviour.RemoveQuit()
        ForceQuitGame(10000, title, info.text .. '\n<color=#913E2B>10 秒后自动退出游戏</color>')
    else
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, info, nil, {cancel = true}})
    end
end

-- 剧本的成就带入选择结果
function OnRecv_CMD_GAC_CHOOSESCRIPTACHIEVERET(kRetData)
    if (not kRetData) or (kRetData.bOpr ~= 1) then
        return
    end
    local rewardIDs = kRetData.akChooseAchieveRewardID
    if not rewardIDs then
        return
    end
    AchieveDataManager:GetInstance():RecordChosenAchieveRewards(rewardIDs, kRetData.iNum or 0)
end

-- 收到剧本内站人数据
function OnRecv_CMD_GAC_PlayerInSameScriptInfo(kRetData)
    if not kRetData then
        return
    end
    -- compare the script id
    local iScriptID = kRetData.dwScriptID
    if iScriptID ~= GetCurScriptID() then
        return
    end
    -- c array -> lua array
    local iSize = kRetData.iSize or 0
    if (iSize <= 0) or (not kRetData.kDatas) then
        return
    end
    local akData = kRetData.kDatas
    if akData[0] then
        akData[#akData + 1] = akData[0]
        akData[0] = nil
    end
    -- send array to display logic
    local win = GetUIWindow("CityUI")
    if not win then
        return
    end
    win:DisplayStandPlayers(akData)
end
function OnRecv_CMD_GAC_CHOOSESCRIPTACHIEVERET(kRetData)
    if (not kRetData) or (kRetData.bOpr ~= 1) then
        return
    end
    local rewardIDs = kRetData.akChooseAchieveRewardID
    if not rewardIDs then
        return
    end
    AchieveDataManager:GetInstance():RecordChosenAchieveRewards(rewardIDs, kRetData.iNum or 0)
end

-- 礼包打开结果下行
function OnRecv_CMD_GAC_GIFTBAGRESULTRET(kRetData)
    if not kRetData then
        return
    end
    local akItems = kRetData.akItems
    if not (akItems and next(akItems)) then
		return
    end
    local win = GetUIWindow("GiftBagResultUI")
    if win and IsWindowOpen("GiftBagResultUI") then
        win:AppendItems(akItems)
    else
        OpenWindowImmediately("GiftBagResultUI", akItems)
    end
end

-- 收藏点数 请求
function OnRecv_CMD_GAC_REQUESTCOLLECTIONPOINTRET(kRetData)
    if not kRetData then
        return
    end
    CollectionDataManager:GetInstance():SetPointsDetails(kRetData.aiCollectionPoint) 
end

-- 旺旺币好友分享成功回调
function OnRecv_LimitShop_Notice_ShareTimes(kRetData)
    if not kRetData then
        return
    end
    LuaEventDispatcher:dispatchEvent("CLICKDISCOUNT_SHARE",kRetData)
end

-- 旺旺币分享获得或购买回调
function OnRecv_LimitShop_Notice_ShareBuy(kRetData)
    if not kRetData then
        return
    end
    LuaEventDispatcher:dispatchEvent("CLICKDISCOUNT_BUYORGET",kRetData)
end

-- 猜旺旺币获取押注金锭不足回调 
function OnRecv_LimitShop_Notice_SecondGoldNotEnough(kRetData)
    -- getyazhu  ret 1
    -- yazhu ret 2
    SystemUICall:GetInstance():Toast('旺旺币不足', true);
    LuaEventDispatcher:dispatchEvent("GET_YAZHURETDATA",kRetData)
    LimitShopManager:GetInstance():SetCatchDateBought()
end

-- 押注之后回调 
function OnRecv_LimitShop_Notice_YaZhu(kRetData)
    LuaEventDispatcher:dispatchEvent("YAZHURETDATA",kRetData)

end
-- 购买成功 
function OnRecv_LimitShop_BuySuccess(kRetData)
    SystemUICall:GetInstance():Toast('购买成功', true);
    LimitShopManager:GetInstance():SetShopAfterBuy(kRetData)
    -- "acMessage":"{"giftType":1,"grade":3,"finBuy":true,"isChoice":false,"buyIndex":0,"discount":0,"useBigGold":true,"operator":"665cdfe0-db0a-11ea-bb20-97d8e54d6945"}"
-- 
end

-- 获取押注信息
function OnRecv_CMD_GAC_LIMITSHOPGETYAZHUINFORET(kRetData)
    if not kRetData then 
        return 
    end
    LimitShopManager:GetInstance():SetYaZhuRetData(kRetData)
    -- TODO: 解析 押注信息
end

-- 更新平台数据信息
function OnRecv_CMD_GAC_SyncPlatCommonFunctionInfo(kRetData)
    if (not kRetData) then
        return
    end

    if (kRetData.uiType == 38)then
    -- 精铁
        PlayerSetDataManager:GetInstance():SetPlayerRefinedIron(kRetData.uiValue)
    elseif kRetData.uiType == 37 then --天工锤
        PlayerSetDataManager:GetInstance():SetPlayerHeavenHammer(kRetData.uiValue)
    elseif (kRetData.uiType == 39) then
    -- 完美粉
        PlayerSetDataManager:GetInstance():SetPlayerPerfectPowder(kRetData.uiValue)
    elseif (kRetData.uiType == 40) then
    -- 忘忧草
        PlayerSetDataManager:GetInstance():SetPlayerWangyoucao(kRetData.uiValue)
    elseif (kRetData.uiType == 43) then
    -- 幸运珠
        PlayerSetDataManager:GetInstance():SetPlayerRefreshBall(kRetData.uiValue)
    elseif (kRetData.uiType == 44) then
    -- 仓库带入扩容格子数
        PlayerSetDataManager:GetInstance():SetPlayerDilatationNum(kRetData.uiValue)
    elseif (kRetData.uiType == 45) then
        -- 武学空白书
        PlayerSetDataManager:GetInstance():SetMakeMartialSecretBook(kRetData.uiValue)
    elseif (kRetData.uiType == 46) then
        --商店金锭打赏记录时间
        PlayerSetDataManager:GetInstance():SetShopGoldRewadTime(kRetData.uiValue)
    elseif (kRetData.uiType == 47) then
        --商店广告打赏记录时间
        PlayerSetDataManager:GetInstance():SetShopAdRewadTime(kRetData.uiValue)
    elseif (kRetData.uiType == 48) then
        -- 免费大金币赠送标记
        LimitShopManager:GetInstance():SetFreeGiveBigCoinFlag(kRetData.uiValue)
    elseif (kRetData.uiType == 73) then
        -- 限时商店大地图奇遇
        LimitShopManager:GetInstance():SetBigmapActionFlag(kRetData.uiValue)
    elseif (kRetData.uiType == 90) then
        --设置玩家完整版开通基金标记
        PlayerSetDataManager:GetInstance():SetFundAchieveOpen(kRetData.uiValue)
    elseif (kRetData.uiType == 91) then
        --设置玩家红包领取次数
        PlayerSetDataManager:GetInstance():SetRedPacketGetTimes(kRetData.uiValue,true)
    elseif (kRetData.uiType == 201) then
        -- 羁绊丹
        PlayerSetDataManager:GetInstance():SetBondPellet(kRetData.uiValue)
        LuaEventDispatcher:dispatchEvent("UPDATE_MAIN_ROLE_INFO")
    elseif (kRetData.uiType == 80) then
        -- 掌门对决免费门票
        PlayerSetDataManager:GetInstance():SetZmFreeTicket(kRetData.uiValue)
    elseif (kRetData.uiType == 81) then
        -- 掌门对决门票
        PlayerSetDataManager:GetInstance():SetZmTicket(kRetData.uiValue)
    elseif (kRetData.uiType == 83) then
        -- 掌门对决新手引导
        PlayerSetDataManager:GetInstance():SetZmNewFlag(kRetData.uiValue)
    elseif (kRetData.uiType == 220) then
        -- 每日奖励领取状态
        PlayerSetDataManager:GetInstance():SetDailyRewardState(kRetData.uiValue)
        LuaEventDispatcher:dispatchEvent("UPDATE_DAILY_REWARD_STATE")
    elseif (kRetData.uiType == 214) then
        -- 秘宝资产值1
        PlayerSetDataManager:GetInstance():SetTreasureExchangeValue(1, kRetData.uiValue)
    elseif (kRetData.uiType == 215) then
        -- 秘宝资产值2
        PlayerSetDataManager:GetInstance():SetTreasureExchangeValue(2, kRetData.uiValue)
    elseif (kRetData.uiType == 235) then
        -- 节日活动资产值1
        PlayerSetDataManager:GetInstance():SetFestivalValue(1, kRetData.uiValue)
    elseif (kRetData.uiType == 236) then
        -- 节日活动资产值2
        PlayerSetDataManager:GetInstance():SetFestivalValue(2, kRetData.uiValue)
    elseif (kRetData.uiType == 238) then
        -- 通灵玉
        PlayerSetDataManager:GetInstance():SetTongLingYuValue(kRetData.uiValue)
    end
end

-- 更新时间戳
function OnRecv_CMD_GAC_HeartBeat(kRetData)
    g_lastHeartBeatCheckTime = nil
    if not (kRetData and kRetData.dwNowTimeStamp) then
        return
    end

    -- 跨天判定
    if g_ServerTime and (g_ServerTime > 0) then
        local uiOldStamp = g_ServerTime
        local uiNewStamp = kRetData.dwNowTimeStamp or 0
        local kOldDate = os.date('*t', uiOldStamp)
        local kNewDate = os.date('*t', uiNewStamp)
        if ((kNewDate.year or 0) >= (kOldDate.year or 0))
        and ((kNewDate.month or 0) >= (kOldDate.month or 0))
        and ((kNewDate.day or 0) > (kOldDate.day or 0)) then
            -- 重置所有跨天标记
            ResetAllDiffDayFlag()
            LuaEventDispatcher:dispatchEvent("ONEVENT_DIFF_DAY", uiNewStamp)
        end
    end

    -- 更新时间戳
    g_ServerTime = kRetData.dwNowTimeStamp
    g_ServerTimeRecordTimeStamp = os.time()

    LuaEventDispatcher:dispatchEvent("ONEVENT_REF_SERVERTIME", g_ServerTime)
end

-- 切磋奖励
function OnRecv_CMD_GAC_PLATCHALLENGEREWARD(kRetData)
    if not kRetData then
        return
    end
    
    local uiDropID = kRetData.dwDropID or 0
    local uiTarItemID = kRetData.dwItemID or 0

    -- 与服务器约定: uiDropID == 0 && uiTarItemID == 0 的情况表示达到了切磋奖励上限
    if (uiDropID == 0) and (uiTarItemID == 0) then
        PlayerSetDataManager:GetInstance():SetPlayerCompareResInfo({['bGotLimit'] = true})
        return
    end

    local kDropItems = DropDataManager:GetInstance():GetDropItemsByDropID(uiDropID, true) or {}
    kDropItems[#kDropItems + 1] = uiTarItemID

    local uiTarModelID = kRetData.dwModelID or 0
    local kModelData = TableDataManager:GetInstance():GetTableData("RoleModel", uiTarModelID) or {}
    local strDrawing = kModelData.Drawing or ""

    local strName = kRetData.acPlayerName or ""

    local kNPCInteractRandomItems = {
        ['bGotLimit'] = false,
        ['bIsPlayerFight'] = true,
        ['auiRoleItem'] = kDropItems,
        ['uiItemID'] = uiTarItemID,
        ['strDrawing'] = strDrawing,
        ['strName'] = strName,
    }
    PlayerSetDataManager:GetInstance():SetPlayerCompareResInfo(kNPCInteractRandomItems)
end

-- 引导完成标记位组
function OnRecv_CMD_GAC_UPDATENOVICEGUIDEFLAGRET(kRetData)
    if not kRetData then
        return
    end
    local uiFlag = kRetData.dwFlag or 0
    GuideDataManager:GetInstance():SetGuideFinishFlag(uiFlag)
end

-- 金锭消费结束
function OnGoldSpendRequestEnd()
    -- 关闭消费保护
    PlayerSetDataManager:GetInstance():CloseBanSpendGoldAction()
end

-- 掌门对决
function OnRecv_CMD_GAC_UPDATEZMROOMINFO(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdateRoom, kRetData);
end
function OnRecv_CMD_GAC_UPDATEZMROOMINFOEXT(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdateRoomExt, kRetData);
end
function OnRecv_CMD_GAC_UPDATEZMPLAYERINFO(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdatePlayer, kRetData);
end
function OnRecv_CMD_GAC_UPDATEZMPLAYERINFOEXT(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdatePlayerExt, kRetData);
end
function OnRecv_CMD_GAC_ZMBATTLERECORDDATA(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdateRecord, kRetData);
end
function OnRecv_CMD_GAC_UPDATEZMBATTLEDATA(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdateBattle, kRetData);
end
function OnRecv_CMD_GAC_RESPONSEZMOPERATE(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.Response, kRetData);
end
function OnRecv_CMD_GAC_UPDATEZMSHOP(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdateShop, kRetData);
end
function OnRecv_CMD_GAC_UPDATEZMOTHERPLAYERINFO(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.UpdateOtherPlayer, kRetData);
end
function OnRecv_CMD_GAC_ZMNOTICE(kRetData)
    LuaEventDispatcher:dispatchEvent(PKManager.NET_EVENT.Notice, kRetData);
end

--捏脸
function OnRecv_CMD_GAC_ROLEFACEOPRRET(kRetData)
    -- 解锁、上传回调
    LuaEventDispatcher:dispatchEvent(CreateFaceManager.NET_EVENT.RoleFaceOprRet, kRetData)
end

function OnRecv_CMD_GAC_ALLROLEFACERET(kRetData)
    -- 查询回调
    CreateFaceManager:GetInstance()
    LuaEventDispatcher:dispatchEvent(CreateFaceManager.NET_EVENT.AllRoleFaceRet, kRetData)
end

function OnRecv_CMD_GAC_QUERYACTIVITYRET(kRetData)
    ActivityHelper:GetInstance():UpdateActivityInfo(kRetData)
end

function OnRecv_CMD_GAC_QUERYSTORYWEEKLIMITRET(kRetData)
    if not kRetData then
        return
    end

    for _, kStoryWeekLimitInfo in pairs(kRetData.akWeekLimitInfo) do
        PlayerSetDataManager:GetInstance():SetStoryWeekTakeOutNum(kStoryWeekLimitInfo.dwStoryID, kStoryWeekLimitInfo.iTakeOutNum)
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_STORY_WEEK_LIMIT_INFO")
end

function OnRecv_FREE_CHALLENGE_UNLOCK_FAILD(kRetData)
    if not kRetData or not kRetData.dwParam then
        return
    end

    if kRetData.dwParam == 1 then
        SystemUICall:GetInstance():Toast("完整版已解锁")
    elseif kRetData.dwParam == 2 then
        SystemUICall:GetInstance():Toast("解锁条件未满足")
    elseif kRetData.dwParam == 3 then
        local text = "暂时无法解锁，请联系官方客服了解详情。"
        local data = TableDataManager:GetInstance():GetTableData("PlusEditionConfig", 1)
        if data and data.FreeLockText then
            local dataText = GetLanguageByID(data.FreeLockText)
            if dataText and dataText ~= "" then
                text = dataText
            end
        end
        
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, text, nil, {confirm = true}})
    end
end

function ShowDialog(kRetData)
    local type = kRetData.uiDialogType
    local title = kRetData.uiTitle
    local content = kRetData.uiContent
    local task = kRetData.uiTask
    local ret = kRetData.uiTaskRet
    local ret2 = kRetData.uiTaskRet2
    if type == 1 then --text
        local showContent = {
            ['title'] = GetLanguageByID(title, task),
            ['text'] = GetLanguageByID(content, task),
            ['leftBtnText'] = '取消',
            ['rightBtnText'] = '确定',
            ['leftBtnFunc'] = function()
                SendClickDialogCMD(type, task, ret, 0)
            end
        }

        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, showContent, function()
            SendClickDialogCMD(type, task, ret, 1)
        end
        })

    elseif type == 2 then -- shiyue player
        OpenWindowImmediately("MarryUI",{iType = type, iTask = task, iRet = ret})
    elseif type == 3 then -- 号召时已有帮手
        local info = GetHelperInfo(content)
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, info.showContent, function()
            local selectUI = GetUIWindow("SelectUI")
            if selectUI and selectUI.selectInfo and selectUI.selectInfo.roleID then
                SendNPCInteractOperCMD(NPCIT_CALLUP, selectUI.selectInfo.roleID,1)
                RemoveWindowImmediately("GeneralBoxUI",false)
            end
        end})
    elseif type == 4 then -- 使用帮手道具时已有帮手
        local itemID = title
        local roleTypeID = content
        local info = GetHelperInfo(roleTypeID)
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, info.showContent, function()
            local roleID = RoleDataManager:GetInstance():GetMainRoleID()
			SendClickItemCMD(CIT_USE_CONFIRM, roleID, itemID, 1, 0, 0, 0,0,0,0,0,{})
        end})
    elseif type == 5 then -- 专属武学选择角色
        OpenWindowImmediately("MartialSelectUI",{iType = type, iTask = task, iRet = ret, iRet2 = ret2})
    elseif type == 6 then -- 结义
        OpenWindowImmediately("SwornUI",{iType = type, iTask = task, iRet = ret})
    elseif type == 7 then -- 结义
        OpenWindowImmediately("RoleSelectUI",{ititle = title, icontent = content, iType = type, iTask = task, iRet = ret, iFavor = ret2})
    end
end

function OnRecv_CMD_GAC_SAVE_FILE(kRetData)
    SaveFileDataManager:GetInstance():SetSaveFileRet(kRetData)
end