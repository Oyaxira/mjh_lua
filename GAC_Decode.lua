-- auto make by Tool ProtocolMaker don't modify anything!!!
local CmdGASToCLDecodeTable = {}

--------  the cmd type to iCmd code--------------------------
CMD_GAC_GAMECMDRET = 32809
CMD_GAC_ENCRYPTKEY = 32786
CMD_GAC_SHOWNOTICE = 32825
CMD_GAC_PLAYERVALIDATERET = 32817
CMD_GAC_QUERYNAMERET = 32862
CMD_GAC_CREATECHARRET = 32834
CMD_GAC_PLAYERLEAVERET = 32838
CMD_GAC_KICKPLAYER = 32769
CMD_GAC_SCRIPTOPRRET = 32837
CMD_GAC_INITPLAYERINFO = 32807
CMD_GAC_PLAYERCOMMONINFODATARET = 32785
CMD_GAC_PLAYERFUNCTIONINFODATARET = 32810
CMD_GAC_PLAYERAPPEARANCEINFODATARET = 32780
CMD_GAC_HEARTBEAT = 32857
CMD_GAC_PLATITEMOPRRET = 32822
CMD_GAC_ALLPLATITEMRET = 32833
CMD_GAC_ALLPLATITEMEQUIPRET = 32849
CMD_GAC_SETCHARPICTUREURLRET = 32784
CMD_GAC_UNLOCKACHIEVEMENT = 32831
CMD_GAC_UPDATEACHIEVESAVEDATA = 32839
CMD_GAC_UPDATEACHIEVERECORDDATA = 32854
CMD_GAC_UPDATEDIFFDROPDATA = 32774
CMD_GAC_CHOOSESCRIPTDIFFRET = 32795
CMD_GAC_MERIDIANSOPRRET = 32802
CMD_GAC_UNLOCKINFORET = 32771
CMD_GAC_MAILOPRRET = 32788
CMD_GAC_JWTTOKENRET = 32803
CMD_GAC_FRIENDINFOOPRRET = 32783
CMD_GAC_MODIFYPLAYERAPPEARANCERET = 32812
CMD_GAC_MONEYUPDATE = 32814
CMD_GAC_PUBLICCHATRET = 32801
CMD_GAC_WORDFILTERRET = 32798
CMD_GAC_PLAYERCOMMONINFORET = 32842
CMD_GAC_QUERYCLANCOLLECTIONINFORET = 32856
CMD_GAC_PLATPLAYERSIMPLEINFOS = 32866
CMD_GAC_PLAYERINSAMESCRIPTINFO = 32815
CMD_GAC_BASEINFOUPDATE = 32863
CMD_GAC_PLATPLAYERDETAILINFO = 32868
CMD_GAC_QUERYTREASUREBOOKBASEINFORET = 32851
CMD_GAC_QUERYTREASUREBOOKTASKINFORET = 32819
CMD_GAC_QUERYTREASUREBOOKMALLINFORET = 32800
CMD_GAC_QUERYTREASUREBOOKALLREWARDPROGRESSRET = 32846
CMD_GAC_QUERYTREASUREBOOKGETREWARDRET = 32787
CMD_GAC_QUERYHOODLELOTTERYBASEINFORET = 32820
CMD_GAC_QUERYHOODLELOTTERYOPENINFORET = 32835
CMD_GAC_QUERYHOODLELOTTERYRESULTRET = 32781
CMD_GAC_QUERYPLATTEAMINFORET = 32867
CMD_GAC_COPYTEAMINFORET = 32772
CMD_GAC_PLATEMBATTLERET = 32855
CMD_GAC_PLATTEAM_ROLECOMMON = 32829
CMD_GAC_PLATTEAM_ROLEATTRS = 32791
CMD_GAC_PLATTEAM_ROLEITEMS = 32850
CMD_GAC_PLATTEAM_ROLEMARTIALS = 32782
CMD_GAC_PLATTEAM_ROLEGIFT = 32778
CMD_GAC_PLATTEAM_ROLEWISHTASKS = 32826
CMD_GAC_PLATTEAM_ITEMINFO = 32832
CMD_GAC_PLATTEAM_MARTIALINFO = 32776
CMD_GAC_PLATTEAM_WISHTASKINFO = 32818
CMD_GAC_PLATTEAM_GIFTINFO = 32852
CMD_GAC_PLATTEAM_EMBATTLEINFO = 32848
CMD_GAC_UPDATEARENAMATCHDATA = 32859
CMD_GAC_UPDATEARENABATTLEDATA = 32794
CMD_GAC_UPDATESIGNUPNAME = 32844
CMD_GAC_ARENABATTLERECORDDATA = 32777
CMD_GAC_NOTIFYARENAMEMBERPKDATA = 32847
CMD_GAC_UPDATEARENABETRANKDATA = 32828
CMD_GAC_UPDATEARENAMATCHHISTORYDATA = 32796
CMD_GAC_UPDATEARENAMATCHJOKEBATTLEDATA = 32805
CMD_GAC_UPDATEARENAMATCHCHAMPIONTIMES = 32823
CMD_GAC_NOTIFYARENANOTICE = 32845
CMD_GAC_UPDATEARENAHUASHAN = 32792
CMD_GAC_HOODLEPUBLICINFORET = 32824
CMD_GAC_HOODLEPUBLICRECORDRET = 32865
CMD_GAC_HOODLEPUBLICASSISTREWARD = 32843
CMD_GAC_SETMAINROLERET = 32806
CMD_GAC_OBSERVEPLATROLERET = 32830
CMD_GAC_ARENAMATCHOPERATERETCODE = 32770
CMD_GAC_RETROLEPETCARDOPERATE = 32858
CMD_GAC_PLATSHOPMALLREWARDRET = 32790
CMD_GAC_PLATSHOPMALLQUERYITEMRET = 32853
CMD_GAC_PLATSHOPMALLBUYRET = 32841
CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFY = 32821
CMD_GAC_DAY3SINGINRET = 32799
CMD_GAC_EXCHANGEGOLDTOSILVERRET = 32793
CMD_GAC_CHECKTENCENTANTIADDICTIONRET = 32861
CMD_GAC_CHOOSESCRIPTACHIEVERET = 32779
CMD_GAC_PLATDISPLAYNEWTOAST = 32789
CMD_GAC_SYNCTSSDATASENDTOCLIENT = 32811
CMD_GAC_GETREDPACKETRET = 32864
CMD_GAC_QUERYFORBIDINFORET = 32827
CMD_GAC_REQUESTTENCENTCREDITSCORERET = 32836
CMD_GAC_REQUESTPRIVATECHATSCENELIMITRET = 32808
CMD_GAC_LIMITSHOPRET = 32797
CMD_GAC_HOODLENUMRET = 32775
CMD_GAC_GIFTBAGRESULTRET = 32840
CMD_GAC_REQUESTCOLLECTIONPOINTRET = 32816
CMD_GAC_LIMITSHOPGETYAZHUINFORET = 32773
CMD_GAC_SYNCPLATCOMMONFUNCTIONVALUE = 32860
CMD_GAC_PLATCHALLENGEREWARD = 32813
CMD_GAC_UPDATENOVICEGUIDEFLAGRET = 32804
CMD_GAC_UPDATEZMROOMINFO = 32909
CMD_GAC_UPDATEZMROOMINFOEXT = 32886
CMD_GAC_UPDATEZMPLAYERINFO = 32925
CMD_GAC_UPDATEZMPLAYERINFOEXT = 32917
CMD_GAC_ZMBATTLERECORDDATA = 32962
CMD_GAC_UPDATEZMBATTLEDATA = 32934
CMD_GAC_RESPONSEZMOPERATE = 32938
CMD_GAC_UPDATEZMSHOP = 32869
CMD_GAC_UPDATEZMOTHERPLAYERINFO = 32937
CMD_GAC_ZMNOTICE = 32907
CMD_GAC_QUERYSECTINFORET = 32885
CMD_GAC_SECTBUILDINGSAVERET = 32910
CMD_GAC_SECTBUILDINGUPGRADERET = 32880
CMD_GAC_SECTMATERIALGETRET = 32957
CMD_GAC_SECTDISCIPLEPUTRET = 32922
CMD_GAC_SECTBUILDINGNAMERET = 32933
CMD_GAC_QUERYACTIVITYRET = 32949
CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFYALL = 32884
CMD_GAC_QUERYHOODLEPRIVACYRESULTRET = 32931
CMD_GAC_QUERYSTORYWEEKLIMITRET = 32939
CMD_GAC_UPDATESYSTEMMODULEENABLESTATE = 32954
CMD_GAC_ALLROLEFACERET = 32874
--------------------------------------------------------------
function registerGASToCLCommand()
	CmdGASToCLDecodeTable[CMD_GAC_GAMECMDRET] = Decode_SeGAC_GameCmdRet
	CmdGASToCLDecodeTable[CMD_GAC_ENCRYPTKEY] = Decode_SeGAC_EncryptKey
	CmdGASToCLDecodeTable[CMD_GAC_SHOWNOTICE] = Decode_SeGAC_ShowNotice
	CmdGASToCLDecodeTable[CMD_GAC_PLAYERVALIDATERET] = Decode_SeGAC_PlayerValidateRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYNAMERET] = Decode_SeGAC_QueryNameRet
	CmdGASToCLDecodeTable[CMD_GAC_CREATECHARRET] = Decode_SeGAC_CreateCharRet
	CmdGASToCLDecodeTable[CMD_GAC_PLAYERLEAVERET] = Decode_SeGAC_PlayerLeaveRet
	CmdGASToCLDecodeTable[CMD_GAC_KICKPLAYER] = Decode_SeGAC_KickPlayer
	CmdGASToCLDecodeTable[CMD_GAC_SCRIPTOPRRET] = Decode_SeGAC_ScriptOprRet
	CmdGASToCLDecodeTable[CMD_GAC_INITPLAYERINFO] = Decode_SeGAC_InitPlayerInfo
	CmdGASToCLDecodeTable[CMD_GAC_PLAYERCOMMONINFODATARET] = Decode_SeGAC_PlayerCommonInfoDataRet
	CmdGASToCLDecodeTable[CMD_GAC_PLAYERFUNCTIONINFODATARET] = Decode_SeGAC_PlayerFunctionInfoDataRet
	CmdGASToCLDecodeTable[CMD_GAC_PLAYERAPPEARANCEINFODATARET] = Decode_SeGAC_PlayerAppearanceInfoDataRet
	CmdGASToCLDecodeTable[CMD_GAC_HEARTBEAT] = Decode_SeGAC_HeartBeat
	CmdGASToCLDecodeTable[CMD_GAC_PLATITEMOPRRET] = Decode_SeGAC_PlatItemOprRet
	CmdGASToCLDecodeTable[CMD_GAC_ALLPLATITEMRET] = Decode_SeGAC_AllPlatItemRet
	CmdGASToCLDecodeTable[CMD_GAC_ALLPLATITEMEQUIPRET] = Decode_SeGAC_AllPlatItemEquipRet
	CmdGASToCLDecodeTable[CMD_GAC_SETCHARPICTUREURLRET] = Decode_SeGAC_SetCharPictureUrlRet
	CmdGASToCLDecodeTable[CMD_GAC_UNLOCKACHIEVEMENT] = Decode_SeGAC_UnlockAchievement
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEACHIEVESAVEDATA] = Decode_SeGAC_UpdateAchieveSaveData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEACHIEVERECORDDATA] = Decode_SeGAC_UpdateAchieveRecordData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEDIFFDROPDATA] = Decode_SeGAC_UpdateDiffDropData
	CmdGASToCLDecodeTable[CMD_GAC_CHOOSESCRIPTDIFFRET] = Decode_SeGAC_ChooseScriptDiffRet
	CmdGASToCLDecodeTable[CMD_GAC_MERIDIANSOPRRET] = Decode_SeGAC_MeridiansOprRet
	CmdGASToCLDecodeTable[CMD_GAC_UNLOCKINFORET] = Decode_SeGAC_UnlockInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_MAILOPRRET] = Decode_SeGAC_MailOprRet
	CmdGASToCLDecodeTable[CMD_GAC_JWTTOKENRET] = Decode_SeGAC_JWTTokenRet
	CmdGASToCLDecodeTable[CMD_GAC_FRIENDINFOOPRRET] = Decode_SeGAC_FriendInfoOprRet
	CmdGASToCLDecodeTable[CMD_GAC_MODIFYPLAYERAPPEARANCERET] = Decode_SeGAC_ModifyPlayerAppearanceRet
	CmdGASToCLDecodeTable[CMD_GAC_MONEYUPDATE] = Decode_SeGAC_MoneyUpdate
	CmdGASToCLDecodeTable[CMD_GAC_PUBLICCHATRET] = Decode_SeGAC_PublicChatRet
	CmdGASToCLDecodeTable[CMD_GAC_WORDFILTERRET] = Decode_SeGAC_WordFilterRet
	CmdGASToCLDecodeTable[CMD_GAC_PLAYERCOMMONINFORET] = Decode_SeGAC_PlayerCommonInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYCLANCOLLECTIONINFORET] = Decode_SeGAC_QueryClanCollectionInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_PLATPLAYERSIMPLEINFOS] = Decode_SeGAC_PlatPlayerSimpleInfos
	CmdGASToCLDecodeTable[CMD_GAC_PLAYERINSAMESCRIPTINFO] = Decode_SeGAC_PlayerInSameScriptInfo
	CmdGASToCLDecodeTable[CMD_GAC_BASEINFOUPDATE] = Decode_SeGAC_BaseInfoUpdate
	CmdGASToCLDecodeTable[CMD_GAC_PLATPLAYERDETAILINFO] = Decode_SeGAC_PlatPlayerDetailInfo
	CmdGASToCLDecodeTable[CMD_GAC_QUERYTREASUREBOOKBASEINFORET] = Decode_SeGAC_QueryTreasureBookBaseInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYTREASUREBOOKTASKINFORET] = Decode_SeGAC_QueryTreasureBookTaskInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYTREASUREBOOKMALLINFORET] = Decode_SeGAC_QueryTreasureBookMallInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYTREASUREBOOKALLREWARDPROGRESSRET] = Decode_SeGAC_QueryTreasureBookAllRewardProgressRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYTREASUREBOOKGETREWARDRET] = Decode_SeGAC_QueryTreasureBookGetRewardRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYHOODLELOTTERYBASEINFORET] = Decode_SeGAC_QueryHoodleLotteryBaseInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYHOODLELOTTERYOPENINFORET] = Decode_SeGAC_QueryHoodleLotteryOpenInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYHOODLELOTTERYRESULTRET] = Decode_SeGAC_QueryHoodleLotteryResultRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYPLATTEAMINFORET] = Decode_SeGAC_QueryPlatTeamInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_COPYTEAMINFORET] = Decode_SeGAC_CopyTeamInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_PLATEMBATTLERET] = Decode_SeGAC_PlatEmbattleRet
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_ROLECOMMON] = Decode_SeGAC_PlatTeam_RoleCommon
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_ROLEATTRS] = Decode_SeGAC_PlatTeam_RoleAttrs
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_ROLEITEMS] = Decode_SeGAC_PlatTeam_RoleItems
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_ROLEMARTIALS] = Decode_SeGAC_PlatTeam_RoleMartials
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_ROLEGIFT] = Decode_SeGAC_PlatTeam_RoleGift
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_ROLEWISHTASKS] = Decode_SeGAC_PlatTeam_RoleWishTasks
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_ITEMINFO] = Decode_SeGAC_PlatTeam_ItemInfo
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_MARTIALINFO] = Decode_SeGAC_PlatTeam_MartialInfo
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_WISHTASKINFO] = Decode_SeGAC_PlatTeam_WishTaskInfo
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_GIFTINFO] = Decode_SeGAC_PlatTeam_GiftInfo
	CmdGASToCLDecodeTable[CMD_GAC_PLATTEAM_EMBATTLEINFO] = Decode_SeGAC_PlatTeam_EmbattleInfo
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEARENAMATCHDATA] = Decode_SeGAC_UpdateArenaMatchData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEARENABATTLEDATA] = Decode_SeGAC_UpdateArenaBattleData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATESIGNUPNAME] = Decode_SeGAC_UpdateSignUpName
	CmdGASToCLDecodeTable[CMD_GAC_ARENABATTLERECORDDATA] = Decode_SeGAC_ArenaBattleRecordData
	CmdGASToCLDecodeTable[CMD_GAC_NOTIFYARENAMEMBERPKDATA] = Decode_SeGAC_NotifyArenaMemberPkData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEARENABETRANKDATA] = Decode_SeGAC_UpdateArenaBetRankData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEARENAMATCHHISTORYDATA] = Decode_SeGAC_UpdateArenaMatchHistoryData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEARENAMATCHJOKEBATTLEDATA] = Decode_SeGAC_UpdateArenaMatchJokeBattleData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEARENAMATCHCHAMPIONTIMES] = Decode_SeGAC_UpdateArenaMatchChampionTimes
	CmdGASToCLDecodeTable[CMD_GAC_NOTIFYARENANOTICE] = Decode_SeGAC_NotifyArenaNotice
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEARENAHUASHAN] = Decode_SeGAC_UpdateArenaHuaShan
	CmdGASToCLDecodeTable[CMD_GAC_HOODLEPUBLICINFORET] = Decode_SeGAC_HoodlePublicInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_HOODLEPUBLICRECORDRET] = Decode_SeGAC_HoodlePublicRecordRet
	CmdGASToCLDecodeTable[CMD_GAC_HOODLEPUBLICASSISTREWARD] = Decode_SeGAC_HoodlePublicAssistReward
	CmdGASToCLDecodeTable[CMD_GAC_SETMAINROLERET] = Decode_SeGAC_SetMainRoleRet
	CmdGASToCLDecodeTable[CMD_GAC_OBSERVEPLATROLERET] = Decode_SeGAC_ObservePlatRoleRet
	CmdGASToCLDecodeTable[CMD_GAC_ARENAMATCHOPERATERETCODE] = Decode_SeGAC_ArenaMatchOperateRetCode
	CmdGASToCLDecodeTable[CMD_GAC_RETROLEPETCARDOPERATE] = Decode_SeGAC_RetRolePetCardOperate
	CmdGASToCLDecodeTable[CMD_GAC_PLATSHOPMALLREWARDRET] = Decode_SeGAC_PlatShopMallRewardRet
	CmdGASToCLDecodeTable[CMD_GAC_PLATSHOPMALLQUERYITEMRET] = Decode_SeGAC_PlatShopMallQueryItemRet
	CmdGASToCLDecodeTable[CMD_GAC_PLATSHOPMALLBUYRET] = Decode_SeGAC_PlatShopMallBuyRet
	CmdGASToCLDecodeTable[CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFY] = Decode_SeGAC_SystemFunctionSwitchNotify
	CmdGASToCLDecodeTable[CMD_GAC_DAY3SINGINRET] = Decode_SeGAC_Day3SingInRet
	CmdGASToCLDecodeTable[CMD_GAC_EXCHANGEGOLDTOSILVERRET] = Decode_SeGAC_ExChangeGoldToSilverRet
	CmdGASToCLDecodeTable[CMD_GAC_CHECKTENCENTANTIADDICTIONRET] = Decode_SeGAC_CheckTencentAntiAddictionRet
	CmdGASToCLDecodeTable[CMD_GAC_CHOOSESCRIPTACHIEVERET] = Decode_SeGAC_ChooseScriptAchieveRet
	CmdGASToCLDecodeTable[CMD_GAC_PLATDISPLAYNEWTOAST] = Decode_SeGAC_PlatDisplayNewToast
	CmdGASToCLDecodeTable[CMD_GAC_SYNCTSSDATASENDTOCLIENT] = Decode_SeGAC_SyncTssDataSendToClient
	CmdGASToCLDecodeTable[CMD_GAC_GETREDPACKETRET] = Decode_SeGAC_GetRedPacketRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYFORBIDINFORET] = Decode_SeGAC_QueryForBidInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_REQUESTTENCENTCREDITSCORERET] = Decode_SeGAC_RequestTencentCreditScoreRet
	CmdGASToCLDecodeTable[CMD_GAC_REQUESTPRIVATECHATSCENELIMITRET] = Decode_SeGAC_RequestPrivateChatSceneLimitRet
	CmdGASToCLDecodeTable[CMD_GAC_LIMITSHOPRET] = Decode_SeGAC_LimitShopRet
	CmdGASToCLDecodeTable[CMD_GAC_HOODLENUMRET] = Decode_SeGAC_HoodleNumRet
	CmdGASToCLDecodeTable[CMD_GAC_GIFTBAGRESULTRET] = Decode_SeGAC_GiftBagResultRet
	CmdGASToCLDecodeTable[CMD_GAC_REQUESTCOLLECTIONPOINTRET] = Decode_SeGAC_RequestCollectionPointRet
	CmdGASToCLDecodeTable[CMD_GAC_LIMITSHOPGETYAZHUINFORET] = Decode_SeGAC_LimitShopGetYaZhuInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_SYNCPLATCOMMONFUNCTIONVALUE] = Decode_SeGAC_SyncPlatCommonFunctionValue
	CmdGASToCLDecodeTable[CMD_GAC_PLATCHALLENGEREWARD] = Decode_SeGAC_PlatChallengeReward
	CmdGASToCLDecodeTable[CMD_GAC_UPDATENOVICEGUIDEFLAGRET] = Decode_SeGAC_UpdateNoviceGuideFlagRet
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEZMROOMINFO] = Decode_SeGAC_UpdateZMRoomInfo
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEZMROOMINFOEXT] = Decode_SeGAC_UpdateZMRoomInfoExt
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEZMPLAYERINFO] = Decode_SeGAC_UpdateZMPlayerInfo
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEZMPLAYERINFOEXT] = Decode_SeGAC_UpdateZMPlayerInfoExt
	CmdGASToCLDecodeTable[CMD_GAC_ZMBATTLERECORDDATA] = Decode_SeGAC_ZmBattleRecordData
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEZMBATTLEDATA] = Decode_SeGAC_UpdateZmBattleData
	CmdGASToCLDecodeTable[CMD_GAC_RESPONSEZMOPERATE] = Decode_SeGAC_ResponseZmOperate
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEZMSHOP] = Decode_SeGAC_UpdateZmShop
	CmdGASToCLDecodeTable[CMD_GAC_UPDATEZMOTHERPLAYERINFO] = Decode_SeGAC_UpdateZMOtherPlayerInfo
	CmdGASToCLDecodeTable[CMD_GAC_ZMNOTICE] = Decode_SeGAC_ZmNotice
	CmdGASToCLDecodeTable[CMD_GAC_QUERYSECTINFORET] = Decode_SeGAC_QuerySectInfoRet
	CmdGASToCLDecodeTable[CMD_GAC_SECTBUILDINGSAVERET] = Decode_SeGAC_SectBuildingSaveRet
	CmdGASToCLDecodeTable[CMD_GAC_SECTBUILDINGUPGRADERET] = Decode_SeGAC_SectBuildingUpgradeRet
	CmdGASToCLDecodeTable[CMD_GAC_SECTMATERIALGETRET] = Decode_SeGAC_SectMaterialGetRet
	CmdGASToCLDecodeTable[CMD_GAC_SECTDISCIPLEPUTRET] = Decode_SeGAC_SectDisciplePutRet
	CmdGASToCLDecodeTable[CMD_GAC_SECTBUILDINGNAMERET] = Decode_SeGAC_SectBuildingNameRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYACTIVITYRET] = Decode_SeGAC_QueryActivityRet
	CmdGASToCLDecodeTable[CMD_GAC_SYSTEMFUNCTIONSWITCHNOTIFYALL] = Decode_SeGAC_SystemFunctionSwitchNotifyAll
	CmdGASToCLDecodeTable[CMD_GAC_QUERYHOODLEPRIVACYRESULTRET] = Decode_SeGAC_QueryHoodlePrivacyResultRet
	CmdGASToCLDecodeTable[CMD_GAC_QUERYSTORYWEEKLIMITRET] = Decode_SeGAC_QueryStoryWeekLimitRet
	CmdGASToCLDecodeTable[CMD_GAC_UPDATESYSTEMMODULEENABLESTATE] = Decode_SeGAC_UpdateSystemModuleEnableState
	CmdGASToCLDecodeTable[CMD_GAC_ALLROLEFACERET] = Decode_SeGAC_AllRoleFaceRet
end

function GetGASToCLDecodeFuncByCmd(iCmd)
	if CmdGASToCLDecodeTable[iCmd] ~= nil then
		return CmdGASToCLDecodeTable[iCmd]
	else
		return nil
	end
end

function Decode_SeGAC_GameCmdRet(netStreamValue)
	local result = { ["iSize"] = 0,["acData"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	local iSize = result["iSize"]
		result["acData"] = {}
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		result["acData"][i] = netStreamValue:ReadChar()
	end
	return result
end

function Decode_SeGAC_EncryptKey(netStreamValue)
	local result = { ["abyEncryptKey"] = nil,["dwVersion"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["abyEncryptKey"] = netStreamValue:ReadString()
	result["dwVersion"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_ShowNotice(netStreamValue)
	local result = { ["eNoticeCode"] = SNC_UNKNOW,["dwParam"] = 0,["dwParam2"] = 0,["dwParam3"] = 0,["acMessage"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eNoticeCode"] = netStreamValue:ReadInt()
	result["dwParam"] = netStreamValue:ReadDword64()
	result["dwParam2"] = netStreamValue:ReadInt()
	result["dwParam3"] = netStreamValue:ReadInt()
	result["acMessage"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_PlayerValidateRet(netStreamValue)
	local result = { ["eValidateType"] = SVT_SESSION_ID_ERROR,["acVersionCode"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eValidateType"] = netStreamValue:ReadInt()
	result["acVersionCode"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_QueryNameRet(netStreamValue)
	local result = { ["bHasExist"] = false,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bHasExist"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeGAC_CreateCharRet(netStreamValue)
	local result = { ["eResult"] = CCR_CREATE_CHAR_OK,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eResult"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlayerLeaveRet(netStreamValue)
	local result = { } 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_KickPlayer(netStreamValue)
	local result = { } 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_ScriptOprRet(netStreamValue)
	local result = { ["eOprType"] = SEOT_NULL,["dwScriptID"] = 0,["bOpr"] = 0,["kUnlockScriptInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eOprType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["bOpr"] = netStreamValue:ReadInt()
	result["kUnlockScriptInfo"] = {["dwScriptID"] = 0,["dwScriptTime"] = 0,["acMainRoleName"] = nil,["dwDreamLandTime"] = 0,["eStateType"] = SSS_NULL,["dwUnlockMaxDiff"] = 0,["dwWeekRoundNum"] = 0,["dwScriptLucyValue"] = 0,["bGotFirstReward"] = false,}
		result["kUnlockScriptInfo"]["dwScriptID"] = netStreamValue:ReadInt()
		result["kUnlockScriptInfo"]["dwScriptTime"] = netStreamValue:ReadInt()
		result["kUnlockScriptInfo"]["acMainRoleName"] = netStreamValue:ReadString()
		result["kUnlockScriptInfo"]["dwDreamLandTime"] = netStreamValue:ReadInt()
		result["kUnlockScriptInfo"]["eStateType"] = netStreamValue:ReadInt()
		result["kUnlockScriptInfo"]["dwUnlockMaxDiff"] = netStreamValue:ReadInt()
		result["kUnlockScriptInfo"]["dwWeekRoundNum"] = netStreamValue:ReadInt()
		result["kUnlockScriptInfo"]["dwScriptLucyValue"] = netStreamValue:ReadInt()
		result["kUnlockScriptInfo"]["bGotFirstReward"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeGAC_InitPlayerInfo(netStreamValue)
	local result = { ["defPlayerID"] = 0,["dwGold"] = 0,["dwSilver"] = 0,["dwDrinkMoney"] = 0,["dwPlatScore"] = 0,["dwActiveScore"] = 0,["dwAreaID"] = 0,["dwChallengeOrderType"] = 0,["dwLoginDayNum"] = 0,["dwReNameNum"] = 0,["dwLuckyValue"] = 0,["dwSecondGold"] = 0,["kCommInfo"] = nil,["kFuncInfo"] = nil,["dwSign_in_flag"] = 0,["dwServerOpenTime"] = 0,["kAppearanceInfo"] = nil,["iSize"] = 0,["kUnlockScriptInfos"] = nil,["iGuideInfoSize"] = 0,["auiGuideInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["defPlayerID"] = netStreamValue:ReadDword64()
	result["dwGold"] = netStreamValue:ReadInt()
	result["dwSilver"] = netStreamValue:ReadInt()
	result["dwDrinkMoney"] = netStreamValue:ReadInt()
	result["dwPlatScore"] = netStreamValue:ReadInt()
	result["dwActiveScore"] = netStreamValue:ReadInt()
	result["dwAreaID"] = netStreamValue:ReadInt()
	result["dwChallengeOrderType"] = netStreamValue:ReadInt()
	result["dwLoginDayNum"] = netStreamValue:ReadInt()
	result["dwReNameNum"] = netStreamValue:ReadInt()
	result["dwLuckyValue"] = netStreamValue:ReadInt()
	result["dwSecondGold"] = netStreamValue:ReadInt()
	result["kCommInfo"] = {["acPlayerName"] = nil,["charPicUrl"] = nil,["dwModelID"] = 0,["dwSex"] = 0,["dwWeekRoundTotalNum"] = 0,["dwALiveDays"] = 0,["bUnlockHouse"] = false,["dwAchievePoint"] = 0,["dwMeridiansLvl"] = 0,["dwCreateTime"] = 0,["dwLastLogoutTime"] = 0,["dwChallengeWinTimes"] = 0,["bRMBPlayer"] = false,["dwTitleID"] = 0,["acOpenID"] = nil,["acVOpenID"] = nil,["acIP"] = nil,["dwHoodleScore"] = 0,["dwNormalHighTowerMaxNum"] = 0,["dwBloodHighTowerMaxNum"] = 0,["dwRegimentHighTowerMaxNum"] = 0,["dwPlayerLastScriptID"] = 0,["dwNewBirdGuideState"] = 0,}
		result["kCommInfo"]["acPlayerName"] = netStreamValue:ReadString()
		result["kCommInfo"]["charPicUrl"] = netStreamValue:ReadString()
		result["kCommInfo"]["dwModelID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwSex"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwWeekRoundTotalNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwALiveDays"] = netStreamValue:ReadInt()
		result["kCommInfo"]["bUnlockHouse"] = netStreamValue:ReadByte()
		result["kCommInfo"]["dwAchievePoint"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwMeridiansLvl"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwCreateTime"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwLastLogoutTime"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwChallengeWinTimes"] = netStreamValue:ReadInt()
		result["kCommInfo"]["bRMBPlayer"] = netStreamValue:ReadByte()
		result["kCommInfo"]["dwTitleID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["acOpenID"] = netStreamValue:ReadString()
		result["kCommInfo"]["acVOpenID"] = netStreamValue:ReadString()
		result["kCommInfo"]["acIP"] = netStreamValue:ReadString()
		result["kCommInfo"]["dwHoodleScore"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwNormalHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwBloodHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwRegimentHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwPlayerLastScriptID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwNewBirdGuideState"] = netStreamValue:ReadInt()
	result["kFuncInfo"] = {["dwLowInCompleteTextNum"] = 0,["dwMidInCompleteTextNum"] = 0,["dwHighInCompleteTextNum"] = 0,["dwMeridianTotalLvl"] = 0,["dwAchieveTotalNum"] = 0,["dwLuckyValue"] = 0,["dwChallengeWinTimes"] = 0,["dwJingTieNum"] = 0,["dwTianGongChui"] = 0,["dwPerfectFenNum"] = 0,["dwWangYouCaoNum"] = 0,["dwHoodleBallNum"] = 0,["dwRefreshBallNum"] = 0,["dwDilatationNum"] = 0,["dwLimitShopBigmapAciton"] = 0,["dwFreeGiveBigCoin"] = 0,["dwShopGoldRewardTime"] = 0,["dwShopAdRewardTime"] = 0,["dwBondPelletNum"] = 0,["dwDailyRewardState"] = 0,["dwFundAchieveOpen"] = 0,["dwRedPacketGetTimes"] = 0,["dwResDropActivityFuncValue1"] = 0,["dwResDropActivityFuncValue2"] = 0,["dwResDropActivityFuncValue3"] = 0,["dwResDropActivityFuncValue4"] = 0,["dwResDropActivityFuncValue5"] = 0,["dwCurResDropCollectActivity"] = 0,["dwZmFreeTickets"] = 0,["dwZmTickets"] = 0,["bZmNewFlag"] = 0,["dwTreaSureExchangeValue1"] = 0,["dwTreaSureExchangeValue2"] = 0,["dwFestivalValue1"] = 0,["dwFestivalValue2"] = 0,["dwTongLingYu"] = 0,}
		result["kFuncInfo"]["dwLowInCompleteTextNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwMidInCompleteTextNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwHighInCompleteTextNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwMeridianTotalLvl"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwAchieveTotalNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwLuckyValue"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwChallengeWinTimes"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwJingTieNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwTianGongChui"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwPerfectFenNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwWangYouCaoNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwHoodleBallNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwRefreshBallNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwDilatationNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwLimitShopBigmapAciton"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFreeGiveBigCoin"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwShopGoldRewardTime"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwShopAdRewardTime"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwBondPelletNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwDailyRewardState"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFundAchieveOpen"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwRedPacketGetTimes"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue1"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue2"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue3"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue4"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue5"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwCurResDropCollectActivity"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwZmFreeTickets"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwZmTickets"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["bZmNewFlag"] = netStreamValue:ReadByte()
		result["kFuncInfo"]["dwTreaSureExchangeValue1"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwTreaSureExchangeValue2"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFestivalValue1"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFestivalValue2"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwTongLingYu"] = netStreamValue:ReadInt()
	result["dwSign_in_flag"] = netStreamValue:ReadInt()
	result["dwServerOpenTime"] = netStreamValue:ReadInt()
	result["kAppearanceInfo"] = {["acPlayerName"] = nil,["dwTitleID"] = 0,["dwPaintingID"] = 0,["dwModelID"] = 0,["charPicUrl"] = nil,["dwBackGroundID"] = 0,["dwBGMID"] = 0,["dwPoetryID"] = 0,["dwPedestalID"] = 0,["dwShowRoleID"] = 0,["dwShowPetID"] = 0,["dwLoginWordID"] = 0,["dwHeadBoxID"] = 0,["dwChatBoxID"] = 0,["dwLandLadyID"] = 0,}
		result["kAppearanceInfo"]["acPlayerName"] = netStreamValue:ReadString()
		result["kAppearanceInfo"]["dwTitleID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPaintingID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwModelID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["charPicUrl"] = netStreamValue:ReadString()
		result["kAppearanceInfo"]["dwBackGroundID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwBGMID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPoetryID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPedestalID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwShowRoleID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwShowPetID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwLoginWordID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwHeadBoxID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwChatBoxID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwLandLadyID"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["kUnlockScriptInfos"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempkUnlockScriptInfos = { ["dwScriptID"] = 0,["dwScriptTime"] = 0,["acMainRoleName"] = nil,["dwDreamLandTime"] = 0,["eStateType"] = SSS_NULL,["dwUnlockMaxDiff"] = 0,["dwWeekRoundNum"] = 0,["dwScriptLucyValue"] = 0,["bGotFirstReward"] = false,} 
		tempkUnlockScriptInfos["dwScriptID"] = netStreamValue:ReadInt()
		tempkUnlockScriptInfos["dwScriptTime"] = netStreamValue:ReadInt()
		tempkUnlockScriptInfos["acMainRoleName"] = netStreamValue:ReadString()
		tempkUnlockScriptInfos["dwDreamLandTime"] = netStreamValue:ReadInt()
		tempkUnlockScriptInfos["eStateType"] = netStreamValue:ReadInt()
		tempkUnlockScriptInfos["dwUnlockMaxDiff"] = netStreamValue:ReadInt()
		tempkUnlockScriptInfos["dwWeekRoundNum"] = netStreamValue:ReadInt()
		tempkUnlockScriptInfos["dwScriptLucyValue"] = netStreamValue:ReadInt()
		tempkUnlockScriptInfos["bGotFirstReward"] = netStreamValue:ReadByte()
		result["kUnlockScriptInfos"][i] = tempkUnlockScriptInfos
	end
	result["iGuideInfoSize"] = netStreamValue:ReadInt()
	local iGuideInfoSize = result["iGuideInfoSize"]
		result["auiGuideInfo"] = {}
	for i = 0,iGuideInfoSize or -1 do
		if i >= iGuideInfoSize then
			break
		end
		result["auiGuideInfo"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_PlayerCommonInfoDataRet(netStreamValue)
	local result = { ["kCommInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kCommInfo"] = {["acPlayerName"] = nil,["charPicUrl"] = nil,["dwModelID"] = 0,["dwSex"] = 0,["dwWeekRoundTotalNum"] = 0,["dwALiveDays"] = 0,["bUnlockHouse"] = false,["dwAchievePoint"] = 0,["dwMeridiansLvl"] = 0,["dwCreateTime"] = 0,["dwLastLogoutTime"] = 0,["dwChallengeWinTimes"] = 0,["bRMBPlayer"] = false,["dwTitleID"] = 0,["acOpenID"] = nil,["acVOpenID"] = nil,["acIP"] = nil,["dwHoodleScore"] = 0,["dwNormalHighTowerMaxNum"] = 0,["dwBloodHighTowerMaxNum"] = 0,["dwRegimentHighTowerMaxNum"] = 0,["dwPlayerLastScriptID"] = 0,["dwNewBirdGuideState"] = 0,}
		result["kCommInfo"]["acPlayerName"] = netStreamValue:ReadString()
		result["kCommInfo"]["charPicUrl"] = netStreamValue:ReadString()
		result["kCommInfo"]["dwModelID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwSex"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwWeekRoundTotalNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwALiveDays"] = netStreamValue:ReadInt()
		result["kCommInfo"]["bUnlockHouse"] = netStreamValue:ReadByte()
		result["kCommInfo"]["dwAchievePoint"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwMeridiansLvl"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwCreateTime"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwLastLogoutTime"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwChallengeWinTimes"] = netStreamValue:ReadInt()
		result["kCommInfo"]["bRMBPlayer"] = netStreamValue:ReadByte()
		result["kCommInfo"]["dwTitleID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["acOpenID"] = netStreamValue:ReadString()
		result["kCommInfo"]["acVOpenID"] = netStreamValue:ReadString()
		result["kCommInfo"]["acIP"] = netStreamValue:ReadString()
		result["kCommInfo"]["dwHoodleScore"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwNormalHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwBloodHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwRegimentHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwPlayerLastScriptID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwNewBirdGuideState"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlayerFunctionInfoDataRet(netStreamValue)
	local result = { ["kFuncInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kFuncInfo"] = {["dwLowInCompleteTextNum"] = 0,["dwMidInCompleteTextNum"] = 0,["dwHighInCompleteTextNum"] = 0,["dwMeridianTotalLvl"] = 0,["dwAchieveTotalNum"] = 0,["dwLuckyValue"] = 0,["dwChallengeWinTimes"] = 0,["dwJingTieNum"] = 0,["dwTianGongChui"] = 0,["dwPerfectFenNum"] = 0,["dwWangYouCaoNum"] = 0,["dwHoodleBallNum"] = 0,["dwRefreshBallNum"] = 0,["dwDilatationNum"] = 0,["dwLimitShopBigmapAciton"] = 0,["dwFreeGiveBigCoin"] = 0,["dwShopGoldRewardTime"] = 0,["dwShopAdRewardTime"] = 0,["dwBondPelletNum"] = 0,["dwDailyRewardState"] = 0,["dwFundAchieveOpen"] = 0,["dwRedPacketGetTimes"] = 0,["dwResDropActivityFuncValue1"] = 0,["dwResDropActivityFuncValue2"] = 0,["dwResDropActivityFuncValue3"] = 0,["dwResDropActivityFuncValue4"] = 0,["dwResDropActivityFuncValue5"] = 0,["dwCurResDropCollectActivity"] = 0,["dwZmFreeTickets"] = 0,["dwZmTickets"] = 0,["bZmNewFlag"] = 0,["dwTreaSureExchangeValue1"] = 0,["dwTreaSureExchangeValue2"] = 0,["dwFestivalValue1"] = 0,["dwFestivalValue2"] = 0,["dwTongLingYu"] = 0,}
		result["kFuncInfo"]["dwLowInCompleteTextNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwMidInCompleteTextNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwHighInCompleteTextNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwMeridianTotalLvl"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwAchieveTotalNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwLuckyValue"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwChallengeWinTimes"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwJingTieNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwTianGongChui"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwPerfectFenNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwWangYouCaoNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwHoodleBallNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwRefreshBallNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwDilatationNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwLimitShopBigmapAciton"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFreeGiveBigCoin"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwShopGoldRewardTime"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwShopAdRewardTime"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwBondPelletNum"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwDailyRewardState"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFundAchieveOpen"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwRedPacketGetTimes"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue1"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue2"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue3"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue4"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwResDropActivityFuncValue5"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwCurResDropCollectActivity"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwZmFreeTickets"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwZmTickets"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["bZmNewFlag"] = netStreamValue:ReadByte()
		result["kFuncInfo"]["dwTreaSureExchangeValue1"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwTreaSureExchangeValue2"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFestivalValue1"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwFestivalValue2"] = netStreamValue:ReadInt()
		result["kFuncInfo"]["dwTongLingYu"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlayerAppearanceInfoDataRet(netStreamValue)
	local result = { ["kAppearanceInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kAppearanceInfo"] = {["acPlayerName"] = nil,["dwTitleID"] = 0,["dwPaintingID"] = 0,["dwModelID"] = 0,["charPicUrl"] = nil,["dwBackGroundID"] = 0,["dwBGMID"] = 0,["dwPoetryID"] = 0,["dwPedestalID"] = 0,["dwShowRoleID"] = 0,["dwShowPetID"] = 0,["dwLoginWordID"] = 0,["dwHeadBoxID"] = 0,["dwChatBoxID"] = 0,["dwLandLadyID"] = 0,}
		result["kAppearanceInfo"]["acPlayerName"] = netStreamValue:ReadString()
		result["kAppearanceInfo"]["dwTitleID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPaintingID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwModelID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["charPicUrl"] = netStreamValue:ReadString()
		result["kAppearanceInfo"]["dwBackGroundID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwBGMID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPoetryID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPedestalID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwShowRoleID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwShowPetID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwLoginWordID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwHeadBoxID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwChatBoxID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwLandLadyID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_HeartBeat(netStreamValue)
	local result = { ["dwNowTimeStamp"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwNowTimeStamp"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlatItemOprRet(netStreamValue)
	local result = { ["eOprType"] = SPIO_NULL,["bOpr"] = false,["dwParam"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eOprType"] = netStreamValue:ReadInt()
	result["bOpr"] = netStreamValue:ReadByte()
	result["dwParam"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_AllPlatItemRet(netStreamValue)
	local result = { ["iFlag"] = 0,["iNum"] = 0,["akPlatItem"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iFlag"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akPlatItem"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakPlatItem = { ["iValueChangeFlag"] = 0,["uiID"] = 0,["uiTypeID"] = 0,["uiItemNum"] = 0,["uiDueTime"] = 0,["uiEnhanceGrade"] = 0,["uiCoinRemainRecastTimes"] = 0,["iAttrNum"] = 0,["auiAttrData"] = nil,["uiOwnerID"] = 0,["bBelongToMainRole"] = 0,["uiSpendIron"] = 0,["uiPerfectPower"] = 0,["uiSpendTongLingYu"] = 0,} 
		local iValueChangeFlag = netStreamValue:ReadInt()
		tempakPlatItem["iValueChangeFlag"] = iValueChangeFlag
		if (iValueChangeFlag & 1 << 0) == ( 1 << 0) then
			tempakPlatItem["uiID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 1) == ( 1 << 1) then
			tempakPlatItem["uiTypeID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 2) == ( 1 << 2) then
			tempakPlatItem["uiItemNum"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 3) == ( 1 << 3) then
			tempakPlatItem["uiDueTime"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 4) == ( 1 << 4) then
			tempakPlatItem["uiEnhanceGrade"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 5) == ( 1 << 5) then
			tempakPlatItem["uiCoinRemainRecastTimes"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 6) == ( 1 << 6) then
			tempakPlatItem["iAttrNum"] = netStreamValue:ReadInt()
		end
		local iAttrNum = tempakPlatItem["iAttrNum"]
		tempakPlatItem["auiAttrData"] = {}
		for j = 0,iAttrNum or -1 do
			if j >= iAttrNum then
				break
			end
			local tempauiAttrData = { ["uiAttrUID"] = 0,["uiType"] = 0,["iBaseValue"] = 0,["iExtraValue"] = 0,["uiRecastType"] = 0,} 
			tempauiAttrData["uiAttrUID"] = netStreamValue:ReadInt()
			tempauiAttrData["uiType"] = netStreamValue:ReadInt()
			tempauiAttrData["iBaseValue"] = netStreamValue:ReadInt()
			tempauiAttrData["iExtraValue"] = netStreamValue:ReadInt()
			tempauiAttrData["uiRecastType"] = netStreamValue:ReadByte()
			tempakPlatItem["auiAttrData"][j] = tempauiAttrData
		end
		if (iValueChangeFlag & 1 << 8) == ( 1 << 8) then
			tempakPlatItem["uiOwnerID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 9) == ( 1 << 9) then
			tempakPlatItem["bBelongToMainRole"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 10) == ( 1 << 10) then
			tempakPlatItem["uiSpendIron"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 11) == ( 1 << 11) then
			tempakPlatItem["uiPerfectPower"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 12) == ( 1 << 12) then
			tempakPlatItem["uiSpendTongLingYu"] = netStreamValue:ReadInt()
		end
		result["akPlatItem"][i] = tempakPlatItem
	end
	return result
end

function Decode_SeGAC_AllPlatItemEquipRet(netStreamValue)
	local result = { ["iFlag"] = 0,["iNum"] = 0,["akPlatItem"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iFlag"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akPlatItem"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakPlatItem = { ["iValueChangeFlag"] = 0,["uiID"] = 0,["uiTypeID"] = 0,["uiItemNum"] = 0,["uiDueTime"] = 0,["uiEnhanceGrade"] = 0,["uiCoinRemainRecastTimes"] = 0,["iAttrNum"] = 0,["auiAttrData"] = nil,["uiOwnerID"] = 0,["bBelongToMainRole"] = 0,["uiSpendIron"] = 0,["uiPerfectPower"] = 0,["uiSpendTongLingYu"] = 0,} 
		local iValueChangeFlag = netStreamValue:ReadInt()
		tempakPlatItem["iValueChangeFlag"] = iValueChangeFlag
		if (iValueChangeFlag & 1 << 0) == ( 1 << 0) then
			tempakPlatItem["uiID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 1) == ( 1 << 1) then
			tempakPlatItem["uiTypeID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 2) == ( 1 << 2) then
			tempakPlatItem["uiItemNum"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 3) == ( 1 << 3) then
			tempakPlatItem["uiDueTime"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 4) == ( 1 << 4) then
			tempakPlatItem["uiEnhanceGrade"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 5) == ( 1 << 5) then
			tempakPlatItem["uiCoinRemainRecastTimes"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 6) == ( 1 << 6) then
			tempakPlatItem["iAttrNum"] = netStreamValue:ReadInt()
		end
		local iAttrNum = tempakPlatItem["iAttrNum"]
		tempakPlatItem["auiAttrData"] = {}
		for j = 0,iAttrNum or -1 do
			if j >= iAttrNum then
				break
			end
			local tempauiAttrData = { ["uiAttrUID"] = 0,["uiType"] = 0,["iBaseValue"] = 0,["iExtraValue"] = 0,["uiRecastType"] = 0,} 
			tempauiAttrData["uiAttrUID"] = netStreamValue:ReadInt()
			tempauiAttrData["uiType"] = netStreamValue:ReadInt()
			tempauiAttrData["iBaseValue"] = netStreamValue:ReadInt()
			tempauiAttrData["iExtraValue"] = netStreamValue:ReadInt()
			tempauiAttrData["uiRecastType"] = netStreamValue:ReadByte()
			tempakPlatItem["auiAttrData"][j] = tempauiAttrData
		end
		if (iValueChangeFlag & 1 << 8) == ( 1 << 8) then
			tempakPlatItem["uiOwnerID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 9) == ( 1 << 9) then
			tempakPlatItem["bBelongToMainRole"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 10) == ( 1 << 10) then
			tempakPlatItem["uiSpendIron"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 11) == ( 1 << 11) then
			tempakPlatItem["uiPerfectPower"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 12) == ( 1 << 12) then
			tempakPlatItem["uiSpendTongLingYu"] = netStreamValue:ReadInt()
		end
		result["akPlatItem"][i] = tempakPlatItem
	end
	return result
end

function Decode_SeGAC_SetCharPictureUrlRet(netStreamValue)
	local result = { ["charPicUrl"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["charPicUrl"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_UnlockAchievement(netStreamValue)
	local result = { ["eNoticeType"] = SANT_NULL,["iNum"] = 0,["akUnlockAchieve"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eNoticeType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akUnlockAchieve"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakUnlockAchieve = { ["uiAchieveID"] = 0,["iCurNum"] = 0,} 
		tempakUnlockAchieve["uiAchieveID"] = netStreamValue:ReadInt()
		tempakUnlockAchieve["iCurNum"] = netStreamValue:ReadInt()
		result["akUnlockAchieve"][i] = tempakUnlockAchieve
	end
	return result
end

function Decode_SeGAC_UpdateAchieveSaveData(netStreamValue)
	local result = { ["iFlag"] = 0,["iNum"] = 0,["akSaveData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iFlag"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akSaveData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakSaveData = { ["uiAchieveID"] = 0,["iValue"] = 0,["iFetchReward"] = 0,} 
		tempakSaveData["uiAchieveID"] = netStreamValue:ReadInt()
		tempakSaveData["iValue"] = netStreamValue:ReadInt()
		tempakSaveData["iFetchReward"] = netStreamValue:ReadShort()
		result["akSaveData"][i] = tempakSaveData
	end
	return result
end

function Decode_SeGAC_UpdateAchieveRecordData(netStreamValue)
	local result = { ["iNum"] = 0,["akRecordData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["akRecordData"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["akRecordData"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_UpdateDiffDropData(netStreamValue)
	local result = { ["iNum"] = 0,["akSaveData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akSaveData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakSaveData = { ["uiTypeID"] = 0,["uiAccumulateTime"] = 0,["uiRoundFinish"] = 0,} 
		tempakSaveData["uiTypeID"] = netStreamValue:ReadInt()
		tempakSaveData["uiAccumulateTime"] = netStreamValue:ReadShort()
		tempakSaveData["uiRoundFinish"] = netStreamValue:ReadInt()
		result["akSaveData"][i] = tempakSaveData
	end
	return result
end

function Decode_SeGAC_ChooseScriptDiffRet(netStreamValue)
	local result = { ["dwChooseDiff"] = 0,["bChooseRet"] = false,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwChooseDiff"] = netStreamValue:ReadInt()
	result["bChooseRet"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeGAC_MeridiansOprRet(netStreamValue)
	local result = { ["eOprType"] = SMOT_NULL,["bOver"] = true,["bOpr"] = false,["dwlCurTotalExp"] = 0,["dwWeekExp"] = 0,["dwWeekLimitNum"] = 0,["iNum"] = 0,["akMeridiansInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eOprType"] = netStreamValue:ReadInt()
	result["bOver"] = netStreamValue:ReadByte()
	result["bOpr"] = netStreamValue:ReadByte()
	result["dwlCurTotalExp"] = netStreamValue:ReadDword64()
	result["dwWeekExp"] = netStreamValue:ReadInt()
	result["dwWeekLimitNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akMeridiansInfo"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakMeridiansInfo = { ["dwMeridianID"] = 0,["dwAcupointID"] = 0,["dwLevel"] = 0,} 
		tempakMeridiansInfo["dwMeridianID"] = netStreamValue:ReadInt()
		tempakMeridiansInfo["dwAcupointID"] = netStreamValue:ReadInt()
		tempakMeridiansInfo["dwLevel"] = netStreamValue:ReadInt()
		result["akMeridiansInfo"][i] = tempakMeridiansInfo
	end
	return result
end

function Decode_SeGAC_UnlockInfoRet(netStreamValue)
	local result = { ["eType"] = 0,["bOver"] = true,["bAll"] = false,["iNum"] = 0,["akUnlockInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eType"] = netStreamValue:ReadInt()
	result["bOver"] = netStreamValue:ReadByte()
	result["bAll"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadInt()
	result["akUnlockInfo"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakUnlockInfo = { ["dwTypeID"] = 0,["dwParam"] = 0,} 
		tempakUnlockInfo["dwTypeID"] = netStreamValue:ReadInt()
		tempakUnlockInfo["dwParam"] = netStreamValue:ReadInt()
		result["akUnlockInfo"][i] = tempakUnlockInfo
	end
	return result
end

function Decode_SeGAC_MailOprRet(netStreamValue)
	local result = { ["eOprType"] = SMAOT_NULL,["iNum"] = 0,["akResult"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eOprType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akResult"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakResult = { ["bOpr"] = false,["dwlMailID"] = 0,["iNum"] = 0,["akRetReason"] = nil,} 
		tempakResult["bOpr"] = netStreamValue:ReadByte()
		tempakResult["dwlMailID"] = netStreamValue:ReadDword64()
		tempakResult["iNum"] = netStreamValue:ReadInt()
		local iNum = tempakResult["iNum"]
		tempakResult["akRetReason"] = {}
		for j = 0,iNum or -1 do
			if j >= iNum then
				break
			end
			local tempakRetReason = { ["dwItemID"] = 0,["dwItemNum"] = 0,["eReason"] = SMRRT_SUC,} 
			tempakRetReason["dwItemID"] = netStreamValue:ReadInt()
			tempakRetReason["dwItemNum"] = netStreamValue:ReadInt()
			tempakRetReason["eReason"] = netStreamValue:ReadInt()
			tempakResult["akRetReason"][j] = tempakRetReason
		end
		result["akResult"][i] = tempakResult
	end
	return result
end

function Decode_SeGAC_JWTTokenRet(netStreamValue)
	local result = { ["acJson"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["acJson"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_FriendInfoOprRet(netStreamValue)
	local result = { ["eOprType"] = FROT_NULL,["bOpr"] = false,["iNum"] = 0,["akFriendInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eOprType"] = netStreamValue:ReadInt()
	result["bOpr"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadInt()
	result["akFriendInfo"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakFriendInfo = { ["defFriendID"] = 0,["acFriendName"] = nil,["charPicUrl"] = nil,["acOpenID"] = nil,["dwSex"] = 0,["dwTitleID"] = 0,["dwModelID"] = 0,["dwAchievePoint"] = 0,["dwMeridiansLvl"] = 0,["dwLogoutTime"] = 0,["bRMBPlayer"] = false,["bAdvancePurchase"] = false,["acVOpenID"] = nil,} 
		tempakFriendInfo["defFriendID"] = netStreamValue:ReadDword64()
		tempakFriendInfo["acFriendName"] = netStreamValue:ReadString()
		tempakFriendInfo["charPicUrl"] = netStreamValue:ReadString()
		tempakFriendInfo["acOpenID"] = netStreamValue:ReadString()
		tempakFriendInfo["dwSex"] = netStreamValue:ReadInt()
		tempakFriendInfo["dwTitleID"] = netStreamValue:ReadInt()
		tempakFriendInfo["dwModelID"] = netStreamValue:ReadInt()
		tempakFriendInfo["dwAchievePoint"] = netStreamValue:ReadInt()
		tempakFriendInfo["dwMeridiansLvl"] = netStreamValue:ReadInt()
		tempakFriendInfo["dwLogoutTime"] = netStreamValue:ReadInt()
		tempakFriendInfo["bRMBPlayer"] = netStreamValue:ReadByte()
		tempakFriendInfo["bAdvancePurchase"] = netStreamValue:ReadByte()
		tempakFriendInfo["acVOpenID"] = netStreamValue:ReadString()
		result["akFriendInfo"][i] = tempakFriendInfo
	end
	return result
end

function Decode_SeGAC_ModifyPlayerAppearanceRet(netStreamValue)
	local result = { ["eModifyType"] = SMPAT_NULL,["acChangeParam"] = nil,["eResultType"] = SNC_APPEAR_MODIFY_SUC,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eModifyType"] = netStreamValue:ReadInt()
	result["acChangeParam"] = netStreamValue:ReadString()
	result["eResultType"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_MoneyUpdate(netStreamValue)
	local result = { ["eMoneyType"] = STLMT_INVALID,["dwCurNum"] = 0,["dwAmtGold"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eMoneyType"] = netStreamValue:ReadInt()
	result["dwCurNum"] = netStreamValue:ReadInt()
	result["dwAmtGold"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PublicChatRet(netStreamValue)
	local result = { ["eChannelType"] = SPCCT_NULL,["eRetType"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eChannelType"] = netStreamValue:ReadInt()
	result["eRetType"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_WordFilterRet(netStreamValue)
	local result = { ["eFilterType"] = STWFT_NULL,["eRetType"] = nil,["dwParam"] = 0,["acContent"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eFilterType"] = netStreamValue:ReadInt()
	result["eRetType"] = netStreamValue:ReadInt()
	result["dwParam"] = netStreamValue:ReadInt()
	result["acContent"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_PlayerCommonInfoRet(netStreamValue)
	local result = { ["eCommonRetType"] = FLAT_COMMONINFO_NULL,["dwlParam"] = 0,["acContent"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eCommonRetType"] = netStreamValue:ReadInt()
	result["dwlParam"] = netStreamValue:ReadDword64()
	result["acContent"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_QueryClanCollectionInfoRet(netStreamValue)
	local result = { ["eQueryType"] = SCCQT_NULL,["iNum"] = 0,["akResult"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akResult"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakResult = { ["dwType"] = 0,["dwNum"] = 0,} 
		tempakResult["dwType"] = netStreamValue:ReadInt()
		tempakResult["dwNum"] = netStreamValue:ReadInt()
		result["akResult"][i] = tempakResult
	end
	return result
end

function Decode_SeGAC_PlatPlayerSimpleInfos(netStreamValue)
	local result = { ["dwPageID"] = 0,["eOptType"] = PSIOT_NULL,["iSize"] = 0,["kPlatPlayerSimpleInfos"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwPageID"] = netStreamValue:ReadInt()
	result["eOptType"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["kPlatPlayerSimpleInfos"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempkPlatPlayerSimpleInfos = { ["defPlyID"] = 0,["dwModelID"] = 0,["acPlayerName"] = nil,["bUnlockHouse"] = false,["bRMBPlayer"] = false,["charPicUrl"] = nil,["dwTitleID"] = 0,["dwPetID"] = 0,["dwHeadBoxID"] = 0,} 
		tempkPlatPlayerSimpleInfos["defPlyID"] = netStreamValue:ReadDword64()
		tempkPlatPlayerSimpleInfos["dwModelID"] = netStreamValue:ReadInt()
		tempkPlatPlayerSimpleInfos["acPlayerName"] = netStreamValue:ReadString()
		tempkPlatPlayerSimpleInfos["bUnlockHouse"] = netStreamValue:ReadByte()
		tempkPlatPlayerSimpleInfos["bRMBPlayer"] = netStreamValue:ReadByte()
		tempkPlatPlayerSimpleInfos["charPicUrl"] = netStreamValue:ReadString()
		tempkPlatPlayerSimpleInfos["dwTitleID"] = netStreamValue:ReadInt()
		tempkPlatPlayerSimpleInfos["dwPetID"] = netStreamValue:ReadInt()
		tempkPlatPlayerSimpleInfos["dwHeadBoxID"] = netStreamValue:ReadInt()
		result["kPlatPlayerSimpleInfos"][i] = tempkPlatPlayerSimpleInfos
	end
	return result
end

function Decode_SeGAC_PlayerInSameScriptInfo(netStreamValue)
	local result = { ["dwScriptID"] = 0,["iSize"] = 0,["kDatas"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["kDatas"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempkDatas = { ["dwPlayerID"] = 0,["acPlayerName"] = nil,["dwSex"] = 0,["dwWeekRoundTotalNum"] = 0,["dwALiveDays"] = 0,["bUnlockHouse"] = false,["dwAchievePoint"] = 0,["dwMeridiansLvl"] = 0,["dwCreateTime"] = 0,["dwLastLogoutTime"] = 0,["dwChallengeWinTimes"] = 0,["bRMBPlayer"] = false,["acOpenID"] = nil,["acVOpenID"] = nil,["acIP"] = nil,["dwHoodleScore"] = 0,["dwNormalHighTowerMaxNum"] = 0,["dwBloodHighTowerMaxNum"] = 0,["dwRegimentHighTowerMaxNum"] = 0,["dwTitleID"] = 0,["dwPaintingID"] = 0,["dwModelID"] = 0,["charPicUrl"] = nil,["dwBackGroundID"] = 0,["dwBGMID"] = 0,["dwPoetryID"] = 0,["dwPedestalID"] = 0,["dwShowRoleID"] = 0,["dwShowPetID"] = 0,["dwLoginWordID"] = 0,["dwHeadBoxID"] = 0,} 
		tempkDatas["dwPlayerID"] = netStreamValue:ReadInt()
		tempkDatas["acPlayerName"] = netStreamValue:ReadString()
		tempkDatas["dwSex"] = netStreamValue:ReadInt()
		tempkDatas["dwWeekRoundTotalNum"] = netStreamValue:ReadInt()
		tempkDatas["dwALiveDays"] = netStreamValue:ReadInt()
		tempkDatas["bUnlockHouse"] = netStreamValue:ReadByte()
		tempkDatas["dwAchievePoint"] = netStreamValue:ReadInt()
		tempkDatas["dwMeridiansLvl"] = netStreamValue:ReadInt()
		tempkDatas["dwCreateTime"] = netStreamValue:ReadInt()
		tempkDatas["dwLastLogoutTime"] = netStreamValue:ReadInt()
		tempkDatas["dwChallengeWinTimes"] = netStreamValue:ReadInt()
		tempkDatas["bRMBPlayer"] = netStreamValue:ReadByte()
		tempkDatas["acOpenID"] = netStreamValue:ReadString()
		tempkDatas["acVOpenID"] = netStreamValue:ReadString()
		tempkDatas["acIP"] = netStreamValue:ReadString()
		tempkDatas["dwHoodleScore"] = netStreamValue:ReadInt()
		tempkDatas["dwNormalHighTowerMaxNum"] = netStreamValue:ReadInt()
		tempkDatas["dwBloodHighTowerMaxNum"] = netStreamValue:ReadInt()
		tempkDatas["dwRegimentHighTowerMaxNum"] = netStreamValue:ReadInt()
		tempkDatas["dwTitleID"] = netStreamValue:ReadInt()
		tempkDatas["dwPaintingID"] = netStreamValue:ReadInt()
		tempkDatas["dwModelID"] = netStreamValue:ReadInt()
		tempkDatas["charPicUrl"] = netStreamValue:ReadString()
		tempkDatas["dwBackGroundID"] = netStreamValue:ReadInt()
		tempkDatas["dwBGMID"] = netStreamValue:ReadInt()
		tempkDatas["dwPoetryID"] = netStreamValue:ReadInt()
		tempkDatas["dwPedestalID"] = netStreamValue:ReadInt()
		tempkDatas["dwShowRoleID"] = netStreamValue:ReadInt()
		tempkDatas["dwShowPetID"] = netStreamValue:ReadInt()
		tempkDatas["dwLoginWordID"] = netStreamValue:ReadInt()
		tempkDatas["dwHeadBoxID"] = netStreamValue:ReadInt()
		result["kDatas"][i] = tempkDatas
	end
	return result
end

function Decode_SeGAC_BaseInfoUpdate(netStreamValue)
	local result = { ["eChangeType"] = SCBOT_NULL,["dwCurNum"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eChangeType"] = netStreamValue:ReadInt()
	result["dwCurNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlatPlayerDetailInfo(netStreamValue)
	local result = { ["defPlyID"] = 0,["kCommInfo"] = nil,["kAppearanceInfo"] = nil,["kPlatRoleInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["defPlyID"] = netStreamValue:ReadDword64()
	result["kCommInfo"] = {["acPlayerName"] = nil,["charPicUrl"] = nil,["dwModelID"] = 0,["dwSex"] = 0,["dwWeekRoundTotalNum"] = 0,["dwALiveDays"] = 0,["bUnlockHouse"] = false,["dwAchievePoint"] = 0,["dwMeridiansLvl"] = 0,["dwCreateTime"] = 0,["dwLastLogoutTime"] = 0,["dwChallengeWinTimes"] = 0,["bRMBPlayer"] = false,["dwTitleID"] = 0,["acOpenID"] = nil,["acVOpenID"] = nil,["acIP"] = nil,["dwHoodleScore"] = 0,["dwNormalHighTowerMaxNum"] = 0,["dwBloodHighTowerMaxNum"] = 0,["dwRegimentHighTowerMaxNum"] = 0,["dwPlayerLastScriptID"] = 0,["dwNewBirdGuideState"] = 0,}
		result["kCommInfo"]["acPlayerName"] = netStreamValue:ReadString()
		result["kCommInfo"]["charPicUrl"] = netStreamValue:ReadString()
		result["kCommInfo"]["dwModelID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwSex"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwWeekRoundTotalNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwALiveDays"] = netStreamValue:ReadInt()
		result["kCommInfo"]["bUnlockHouse"] = netStreamValue:ReadByte()
		result["kCommInfo"]["dwAchievePoint"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwMeridiansLvl"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwCreateTime"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwLastLogoutTime"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwChallengeWinTimes"] = netStreamValue:ReadInt()
		result["kCommInfo"]["bRMBPlayer"] = netStreamValue:ReadByte()
		result["kCommInfo"]["dwTitleID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["acOpenID"] = netStreamValue:ReadString()
		result["kCommInfo"]["acVOpenID"] = netStreamValue:ReadString()
		result["kCommInfo"]["acIP"] = netStreamValue:ReadString()
		result["kCommInfo"]["dwHoodleScore"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwNormalHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwBloodHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwRegimentHighTowerMaxNum"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwPlayerLastScriptID"] = netStreamValue:ReadInt()
		result["kCommInfo"]["dwNewBirdGuideState"] = netStreamValue:ReadInt()
	result["kAppearanceInfo"] = {["acPlayerName"] = nil,["dwTitleID"] = 0,["dwPaintingID"] = 0,["dwModelID"] = 0,["charPicUrl"] = nil,["dwBackGroundID"] = 0,["dwBGMID"] = 0,["dwPoetryID"] = 0,["dwPedestalID"] = 0,["dwShowRoleID"] = 0,["dwShowPetID"] = 0,["dwLoginWordID"] = 0,["dwHeadBoxID"] = 0,["dwChatBoxID"] = 0,["dwLandLadyID"] = 0,}
		result["kAppearanceInfo"]["acPlayerName"] = netStreamValue:ReadString()
		result["kAppearanceInfo"]["dwTitleID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPaintingID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwModelID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["charPicUrl"] = netStreamValue:ReadString()
		result["kAppearanceInfo"]["dwBackGroundID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwBGMID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPoetryID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwPedestalID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwShowRoleID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwShowPetID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwLoginWordID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwHeadBoxID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwChatBoxID"] = netStreamValue:ReadInt()
		result["kAppearanceInfo"]["dwLandLadyID"] = netStreamValue:ReadInt()
	result["kPlatRoleInfo"] = {["uiMainRoleID"] = 0,["acRoleName"] = nil,["iNum"] = 0,["akBaseRoleInfo"] = nil,}
		result["kPlatRoleInfo"]["uiMainRoleID"] = netStreamValue:ReadInt()
		result["kPlatRoleInfo"]["acRoleName"] = netStreamValue:ReadString()
		result["kPlatRoleInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["kPlatRoleInfo"]["iNum"]
		result["kPlatRoleInfo"]["akBaseRoleInfo"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakBaseRoleInfo = { ["uiID"] = 0,["uiTypeID"] = 0,["uiNameID"] = 0,["uiTitleID"] = 0,["uiFamilyNameID"] = 0,["uiFirstNameID"] = 0,["uiModelID"] = 0,["uiRank"] = 0,} 
		tempakBaseRoleInfo["uiID"] = netStreamValue:ReadInt()
		tempakBaseRoleInfo["uiTypeID"] = netStreamValue:ReadInt()
		tempakBaseRoleInfo["uiNameID"] = netStreamValue:ReadInt()
		tempakBaseRoleInfo["uiTitleID"] = netStreamValue:ReadInt()
		tempakBaseRoleInfo["uiFamilyNameID"] = netStreamValue:ReadInt()
		tempakBaseRoleInfo["uiFirstNameID"] = netStreamValue:ReadInt()
		tempakBaseRoleInfo["uiModelID"] = netStreamValue:ReadInt()
		tempakBaseRoleInfo["uiRank"] = netStreamValue:ReadInt()
		result["kPlatRoleInfo"]["akBaseRoleInfo"][i] = tempakBaseRoleInfo
	end
	return result
end

function Decode_SeGAC_QueryTreasureBookBaseInfoRet(netStreamValue)
	local result = { ["kBaseInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kBaseInfo"] = {["dwExp"] = 0,["dwLvl"] = 0,["dwMoney"] = 0,["bRMBPlayer"] = false,["bAdvancePurchase"] = false,["bOpenRepeatTask"] = false,["dwCurPeriods"] = 1,["dwCurPeriodsWeek"] = 1,["dwHeroCanGetExtraRewardTaskNum"] = 0,["dwRMBCanGetExtraRewardTaskNum"] = 0,["dwCurMaxGetDailySilverNum"] = 1,["bOpenDailyGift"] = false,["bEachDayGift"] = false,["bEachWeekGift"] = false,["dwProgressRewardFlag"] = 0,["dwRMBProgressRewardFlag"] = 0,["dwLvlRewardFlag1"] = 0,["dwLvlRewardFlag2"] = 0,["dwRMBLvlRewardFlag1"] = 0,["dwRMBLvlRewardFlag2"] = 0,["dwGivedFriendAdvanceNum"] = 0,["dwPurchaseBookEndTime"] = 0,["dwExtraGetRewardLvl"] = 0,}
		result["kBaseInfo"]["dwExp"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwLvl"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwMoney"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["bRMBPlayer"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["bAdvancePurchase"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["bOpenRepeatTask"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["dwCurPeriods"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwCurPeriodsWeek"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwHeroCanGetExtraRewardTaskNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwRMBCanGetExtraRewardTaskNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwCurMaxGetDailySilverNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["bOpenDailyGift"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["bEachDayGift"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["bEachWeekGift"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["dwProgressRewardFlag"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwRMBProgressRewardFlag"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwLvlRewardFlag1"] = netStreamValue:ReadDword64()
		result["kBaseInfo"]["dwLvlRewardFlag2"] = netStreamValue:ReadDword64()
		result["kBaseInfo"]["dwRMBLvlRewardFlag1"] = netStreamValue:ReadDword64()
		result["kBaseInfo"]["dwRMBLvlRewardFlag2"] = netStreamValue:ReadDword64()
		result["kBaseInfo"]["dwGivedFriendAdvanceNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwPurchaseBookEndTime"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwExtraGetRewardLvl"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_QueryTreasureBookTaskInfoRet(netStreamValue)
	local result = { ["eTaskType"] = STBTT_NORMAL,["iNum"] = 0,["akTask"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eTaskType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akTask"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakTask = { ["dwTaskTypeID"] = 0,["dwProgress"] = 0,["bReward"] = false,["bCanReward"] = false,["dwRepeatFinishNum"] = 0,} 
		tempakTask["dwTaskTypeID"] = netStreamValue:ReadInt()
		tempakTask["dwProgress"] = netStreamValue:ReadInt()
		tempakTask["bReward"] = netStreamValue:ReadByte()
		tempakTask["bCanReward"] = netStreamValue:ReadByte()
		tempakTask["dwRepeatFinishNum"] = netStreamValue:ReadInt()
		result["akTask"][i] = tempakTask
	end
	return result
end

function Decode_SeGAC_QueryTreasureBookMallInfoRet(netStreamValue)
	local result = { ["iNum"] = 0,["akMall"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akMall"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakMall = { ["dwItemTypeID"] = 0,["dwExchangedNum"] = 0,} 
		tempakMall["dwItemTypeID"] = netStreamValue:ReadInt()
		tempakMall["dwExchangedNum"] = netStreamValue:ReadInt()
		result["akMall"][i] = tempakMall
	end
	return result
end

function Decode_SeGAC_QueryTreasureBookAllRewardProgressRet(netStreamValue)
	local result = { ["iNum"] = 0,["dwProgress"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["dwProgress"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["dwProgress"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_QueryTreasureBookGetRewardRet(netStreamValue)
	local result = { ["bOpr"] = false,["eQueryType"] = STBQT_NULL,["bOpenDailyGift"] = false,["dwProgressRewardFlag"] = 0,["dwRMBProgressRewardFlag"] = 0,["dwLvlRewardFlag1"] = 0,["dwLvlRewardFlag2"] = 0,["dwRMBLvlRewardFlag1"] = 0,["dwRMBLvlRewardFlag2"] = 0,["iNum"] = 0,["akItem"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bOpr"] = netStreamValue:ReadByte()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["bOpenDailyGift"] = netStreamValue:ReadByte()
	result["dwProgressRewardFlag"] = netStreamValue:ReadInt()
	result["dwRMBProgressRewardFlag"] = netStreamValue:ReadInt()
	result["dwLvlRewardFlag1"] = netStreamValue:ReadDword64()
	result["dwLvlRewardFlag2"] = netStreamValue:ReadDword64()
	result["dwRMBLvlRewardFlag1"] = netStreamValue:ReadDword64()
	result["dwRMBLvlRewardFlag2"] = netStreamValue:ReadDword64()
	result["iNum"] = netStreamValue:ReadInt()
	result["akItem"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakItem = { ["uiItemID"] = 0,["uiItemNum"] = 0,} 
		tempakItem["uiItemID"] = netStreamValue:ReadInt()
		tempakItem["uiItemNum"] = netStreamValue:ReadInt()
		result["akItem"][i] = tempakItem
	end
	return result
end

function Decode_SeGAC_QueryHoodleLotteryBaseInfoRet(netStreamValue)
	local result = { ["ePoolType"] = SHLPLT_NULL,["kBaseInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["ePoolType"] = netStreamValue:ReadInt()
	result["kBaseInfo"] = {["bOpen"] = false,["dwSpecialSlotProgress"] = 0,["dwCurPoolHoodleNum"] = 0,["dwCurPoolFreeHoodleNum"] = 0,["dwCurPoolDailyFreeHoodleNum"] = 0,["dwAccForTenShootNum"] = 0,["akProgressInfo"] = nil,["akSlotInfo"] = nil,}
		result["kBaseInfo"]["bOpen"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["dwSpecialSlotProgress"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwCurPoolHoodleNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwCurPoolFreeHoodleNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwCurPoolDailyFreeHoodleNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["dwAccForTenShootNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["akProgressInfo"] = {}
	for i = 0,SSD_MAX_HOODLE_PROGRESS_BOX_NUM or -1 do
		if i >= SSD_MAX_HOODLE_PROGRESS_BOX_NUM then
			break
		end
		local tempakProgressInfo = { ["eProgressType"] = SHBPT_NULL,["dwCurProgress"] = 0,["kProgressTip"] = nil,["ePrivacyType"] = SHPCT_NULL,["dwTotalHPNum"] = 0,["dwPoolID"] = 0,["bHide"] = false,} 
		tempakProgressInfo["eProgressType"] = netStreamValue:ReadInt()
		tempakProgressInfo["dwCurProgress"] = netStreamValue:ReadInt()
		tempakProgressInfo["kProgressTip"] = {}
		tempakProgressInfo["kProgressTip"]["dwCurCDropBaseID"] = netStreamValue:ReadInt()
		tempakProgressInfo["kProgressTip"]["dwCurDropItemID"] = netStreamValue:ReadInt()
		tempakProgressInfo["kProgressTip"]["dwCurDropItemNum"] = netStreamValue:ReadInt()
		tempakProgressInfo["kProgressTip"]["dwCurRewardItemID"] = netStreamValue:ReadInt()
		tempakProgressInfo["kProgressTip"]["dwCurRewardItemNum"] = netStreamValue:ReadInt()
		tempakProgressInfo["ePrivacyType"] = netStreamValue:ReadInt()
		tempakProgressInfo["dwTotalHPNum"] = netStreamValue:ReadInt()
		tempakProgressInfo["dwPoolID"] = netStreamValue:ReadInt()
		tempakProgressInfo["bHide"] = netStreamValue:ReadByte()
		result["kBaseInfo"]["akProgressInfo"][i] = tempakProgressInfo
	end
		result["kBaseInfo"]["akSlotInfo"] = {}
	for i = 0,SSD_MAX_HOODLE_SLOT_NUM or -1 do
		if i >= SSD_MAX_HOODLE_SLOT_NUM then
			break
		end
		local tempakSlotInfo = { ["dwSlotIndex"] = 0,["kSlotTip"] = nil,} 
		tempakSlotInfo["dwSlotIndex"] = netStreamValue:ReadInt()
		tempakSlotInfo["kSlotTip"] = {}
		tempakSlotInfo["kSlotTip"]["dwCurCDropBaseID"] = netStreamValue:ReadInt()
		tempakSlotInfo["kSlotTip"]["dwCurDropItemID"] = netStreamValue:ReadInt()
		tempakSlotInfo["kSlotTip"]["dwCurDropItemNum"] = netStreamValue:ReadInt()
		tempakSlotInfo["kSlotTip"]["dwCurRewardItemID"] = netStreamValue:ReadInt()
		tempakSlotInfo["kSlotTip"]["dwCurRewardItemNum"] = netStreamValue:ReadInt()
		result["kBaseInfo"]["akSlotInfo"][i] = tempakSlotInfo
	end
	return result
end

function Decode_SeGAC_QueryHoodleLotteryOpenInfoRet(netStreamValue)
	local result = { ["acPoolOpenInfo"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["acPoolOpenInfo"] = {}
	for i = 0,SHLPLT_NUM or -1 do
		if i >= SHLPLT_NUM then
			break
		end
		result["acPoolOpenInfo"][i] = netStreamValue:ReadChar()
	end
	return result
end

function Decode_SeGAC_QueryHoodleLotteryResultRet(netStreamValue)
	local result = { ["eQueryType"] = SHLQT_NULL,["ePoolType"] = SHLPLT_NULL,["dwCurPoolHoodleNum"] = 0,["dwCurPoolFreeHoodleNum"] = 0,["dwCurPoolDailyFreeHoodleNum"] = 0,["dwAccForTenShootNum"] = 0,["iNum"] = 0,["akRetInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["ePoolType"] = netStreamValue:ReadInt()
	result["dwCurPoolHoodleNum"] = netStreamValue:ReadInt()
	result["dwCurPoolFreeHoodleNum"] = netStreamValue:ReadInt()
	result["dwCurPoolDailyFreeHoodleNum"] = netStreamValue:ReadInt()
	result["dwAccForTenShootNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akRetInfo"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakRetInfo = { ["bSpecialHoodle"] = false,["dwSpecialSlotProgress"] = 0,["kHitSlotInfo"] = nil,["akBoxInfo"] = nil,} 
		tempakRetInfo["bSpecialHoodle"] = netStreamValue:ReadByte()
		tempakRetInfo["dwSpecialSlotProgress"] = netStreamValue:ReadInt()
		tempakRetInfo["kHitSlotInfo"] = {}
		tempakRetInfo["kHitSlotInfo"]["dwSlotIndex"] = netStreamValue:ReadInt()
		tempakRetInfo["kHitSlotInfo"]["kSlotTip"] = {}
		tempakRetInfo["kHitSlotInfo"]["kSlotTip"]["dwCurCDropBaseID"] = netStreamValue:ReadInt()
		tempakRetInfo["kHitSlotInfo"]["kSlotTip"]["dwCurDropItemID"] = netStreamValue:ReadInt()
		tempakRetInfo["kHitSlotInfo"]["kSlotTip"]["dwCurDropItemNum"] = netStreamValue:ReadInt()
		tempakRetInfo["kHitSlotInfo"]["kSlotTip"]["dwCurRewardItemID"] = netStreamValue:ReadInt()
		tempakRetInfo["kHitSlotInfo"]["kSlotTip"]["dwCurRewardItemNum"] = netStreamValue:ReadInt()
		tempakRetInfo["akBoxInfo"] = {}
		for j = 0,3 or -1 do
			if j >= 3 then
				break
			end
			local tempakBoxInfo = { ["eProgressType"] = SHBPT_NULL,["dwCurProgress"] = 0,["kProgressTip"] = nil,["ePrivacyType"] = SHPCT_NULL,["dwTotalHPNum"] = 0,["dwPoolID"] = 0,["bHide"] = false,} 
			tempakBoxInfo["eProgressType"] = netStreamValue:ReadInt()
			tempakBoxInfo["dwCurProgress"] = netStreamValue:ReadInt()
			tempakBoxInfo["kProgressTip"] = {}
		tempakBoxInfo["kProgressTip"]["dwCurCDropBaseID"] = netStreamValue:ReadInt()
		tempakBoxInfo["kProgressTip"]["dwCurDropItemID"] = netStreamValue:ReadInt()
		tempakBoxInfo["kProgressTip"]["dwCurDropItemNum"] = netStreamValue:ReadInt()
		tempakBoxInfo["kProgressTip"]["dwCurRewardItemID"] = netStreamValue:ReadInt()
		tempakBoxInfo["kProgressTip"]["dwCurRewardItemNum"] = netStreamValue:ReadInt()
			tempakBoxInfo["ePrivacyType"] = netStreamValue:ReadInt()
			tempakBoxInfo["dwTotalHPNum"] = netStreamValue:ReadInt()
			tempakBoxInfo["dwPoolID"] = netStreamValue:ReadInt()
			tempakBoxInfo["bHide"] = netStreamValue:ReadByte()
			tempakRetInfo["akBoxInfo"][j] = tempakBoxInfo
		end
		result["akRetInfo"][i] = tempakRetInfo
	end
	return result
end

function Decode_SeGAC_QueryPlatTeamInfoRet(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["uiTime"] = 0,["dwMainRoleID"] = 0,["acName"] = nil,["iTeammatesNum"] = nil,["auiTeammates"] = nil,["iPetNum"] = 0,["akPets"] = nil,["iMeridiansNum"] = 0,["akMeridians"] = nil,["defPlayerID"] = 0,["bEnd"] = false,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["uiTime"] = netStreamValue:ReadInt()
	result["dwMainRoleID"] = netStreamValue:ReadInt()
	result["acName"] = netStreamValue:ReadString()
	result["iTeammatesNum"] = netStreamValue:ReadInt()
	local iTeammatesNum = result["iTeammatesNum"]
		result["auiTeammates"] = {}
	for i = 0,iTeammatesNum or -1 do
		if i >= iTeammatesNum then
			break
		end
		result["auiTeammates"][i] = netStreamValue:ReadInt()
	end
	result["iPetNum"] = netStreamValue:ReadInt()
	local iPetNum = result["iPetNum"]
		result["akPets"] = {}
	for i = 0,iPetNum or -1 do
		if i >= iPetNum then
			break
		end
		result["akPets"][i] = netStreamValue:ReadInt()
	end
	result["iMeridiansNum"] = netStreamValue:ReadInt()
	result["akMeridians"] = {}
		local iMeridiansNum = result["iMeridiansNum"]
	for i = 0,iMeridiansNum or -1 do
		if i >= iMeridiansNum then
			break
		end
		local tempakMeridians = { ["uiKey"] = 0,["uiValue"] = 0,} 
		tempakMeridians["uiKey"] = netStreamValue:ReadInt()
		tempakMeridians["uiValue"] = netStreamValue:ReadInt()
		result["akMeridians"][i] = tempakMeridians
	end
	result["defPlayerID"] = netStreamValue:ReadDword64()
	result["bEnd"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeGAC_CopyTeamInfoRet(netStreamValue)
	local result = { ["dwScriptID"] = 0,["bResult"] = true,["uiTime"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["bResult"] = netStreamValue:ReadByte()
	result["uiTime"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlatEmbattleRet(netStreamValue)
	local result = { ["bSingle"] = true,["bResult"] = true,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bSingle"] = netStreamValue:ReadByte()
	result["bResult"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeGAC_PlatTeam_RoleCommon(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["kPlatRoleCommon"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["kPlatRoleCommon"] = {["uiID"] = 0,["uiTypeID"] = 0,["uiNameID"] = 0,["uiTitleID"] = 0,["uiFamilyNameID"] = 0,["uiFirstNameID"] = 0,["uiLevel"] = 0,["uiClanID"] = 0,["uiHP"] = 0,["uiMP"] = 0,["uiExp"] = 0,["uiRemainAttrPoint"] = 0,["uiFragment"] = 0,["uiOverlayLevel"] = 0,["iGoodEvil"] = 0,["uiRemainGiftPoint"] = 0,["uiModelID"] = 0,["uiRank"] = 0,["uiMartialNum"] = 0,["uiEatFoodNum"] = 0,["uiEatFoodMaxNum"] = 0,["uiMarry"] = 0,["uiSubRole"] = 0,["uiFavorNum"] = 0,["auiFavor"] = nil,["uiBroAndSisNum"] = 0,["auiBroAndSis"] = nil,}
		result["kPlatRoleCommon"]["uiID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiTypeID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiNameID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiTitleID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFamilyNameID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFirstNameID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiLevel"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiClanID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiHP"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiMP"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiExp"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiRemainAttrPoint"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFragment"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiOverlayLevel"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["iGoodEvil"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiRemainGiftPoint"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiModelID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiRank"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiMartialNum"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiEatFoodNum"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiEatFoodMaxNum"] = netStreamValue:ReadInt()
	result["kPlatRoleCommon"]["uiMarry"] = {}
	for i = 0,256 or -1 do
		if i >= 256 then
			break
		end
			result["kPlatRoleCommon"]["uiMarry"][i] = netStreamValue:ReadInt()
		end
		result["kPlatRoleCommon"]["uiSubRole"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFavorNum"] = netStreamValue:ReadInt()
	local uiFavorNum = result["kPlatRoleCommon"]["uiFavorNum"]
		result["kPlatRoleCommon"]["auiFavor"] = {}
	for i = 0,uiFavorNum or -1 do
		if i >= uiFavorNum then
			break
		end
			result["kPlatRoleCommon"]["auiFavor"][i] = netStreamValue:ReadInt()
		end
		result["kPlatRoleCommon"]["uiBroAndSisNum"] = netStreamValue:ReadInt()
	local uiBroAndSisNum = result["kPlatRoleCommon"]["uiBroAndSisNum"]
		result["kPlatRoleCommon"]["auiBroAndSis"] = {}
	for i = 0,uiBroAndSisNum or -1 do
		if i >= uiBroAndSisNum then
			break
		end
			result["kPlatRoleCommon"]["auiBroAndSis"][i] = netStreamValue:ReadInt()
		end
	return result
end

function Decode_SeGAC_PlatTeam_RoleAttrs(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["uiID"] = 0,["aiAttrs"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["uiID"] = netStreamValue:ReadInt()
	result["aiAttrs"] = {}
	for i = 0,SSD_MAX_ROLE_DISPLAYATTR_NUMS or -1 do
		if i >= SSD_MAX_ROLE_DISPLAYATTR_NUMS then
			break
		end
		result["aiAttrs"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_PlatTeam_RoleItems(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["uiID"] = 0,["iItemNum"] = nil,["auiRoleItem"] = nil,["auiEquipItem"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["uiID"] = netStreamValue:ReadInt()
	result["iItemNum"] = netStreamValue:ReadInt()
	local iItemNum = result["iItemNum"]
		result["auiRoleItem"] = {}
	for i = 0,iItemNum or -1 do
		if i >= iItemNum then
			break
		end
		result["auiRoleItem"][i] = netStreamValue:ReadInt()
	end
	result["auiEquipItem"] = {}
	for i = 0,REI_NUMS or -1 do
		if i >= REI_NUMS then
			break
		end
		result["auiEquipItem"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_PlatTeam_RoleMartials(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["uiID"] = 0,["iMartialNum"] = nil,["auiRoleMartials"] = nil,["iNum"] = 0,["akEmBattleMartialInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["uiID"] = netStreamValue:ReadInt()
	result["iMartialNum"] = netStreamValue:ReadInt()
	local iMartialNum = result["iMartialNum"]
		result["auiRoleMartials"] = {}
	for i = 0,iMartialNum or -1 do
		if i >= iMartialNum then
			break
		end
		result["auiRoleMartials"][i] = netStreamValue:ReadInt()
	end
	result["iNum"] = netStreamValue:ReadInt()
	result["akEmBattleMartialInfo"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakEmBattleMartialInfo = { ["dwUID"] = 0,["dwTypeID"] = 0,["dwIndex"] = 0,} 
		tempakEmBattleMartialInfo["dwUID"] = netStreamValue:ReadInt()
		tempakEmBattleMartialInfo["dwTypeID"] = netStreamValue:ReadInt()
		tempakEmBattleMartialInfo["dwIndex"] = netStreamValue:ReadInt()
		result["akEmBattleMartialInfo"][i] = tempakEmBattleMartialInfo
	end
	return result
end

function Decode_SeGAC_PlatTeam_RoleGift(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["uiID"] = 0,["giftNum"] = nil,["auiRoleGift"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["uiID"] = netStreamValue:ReadInt()
	result["giftNum"] = netStreamValue:ReadInt()
	local giftNum = result["giftNum"]
		result["auiRoleGift"] = {}
	for i = 0,giftNum or -1 do
		if i >= giftNum then
			break
		end
		result["auiRoleGift"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_PlatTeam_RoleWishTasks(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["uiID"] = 0,["iWishTasksNum"] = nil,["auiRoleWishTasks"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["uiID"] = netStreamValue:ReadInt()
	result["iWishTasksNum"] = netStreamValue:ReadInt()
	local iWishTasksNum = result["iWishTasksNum"]
		result["auiRoleWishTasks"] = {}
	for i = 0,iWishTasksNum or -1 do
		if i >= iWishTasksNum then
			break
		end
		result["auiRoleWishTasks"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_PlatTeam_ItemInfo(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["iSize"] = 0,["akRoleItem"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["akRoleItem"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempakRoleItem = { ["iValueChangeFlag"] = 0,["uiID"] = 0,["uiTypeID"] = 0,["uiItemNum"] = 0,["uiDueTime"] = 0,["uiEnhanceGrade"] = 0,["uiCoinRemainRecastTimes"] = 0,["iAttrNum"] = 0,["auiAttrData"] = nil,["uiOwnerID"] = 0,["bBelongToMainRole"] = 0,["uiSpendIron"] = 0,["uiPerfectPower"] = 0,["uiSpendTongLingYu"] = 0,} 
		local iValueChangeFlag = netStreamValue:ReadInt()
		tempakRoleItem["iValueChangeFlag"] = iValueChangeFlag
		if (iValueChangeFlag & 1 << 0) == ( 1 << 0) then
			tempakRoleItem["uiID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 1) == ( 1 << 1) then
			tempakRoleItem["uiTypeID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 2) == ( 1 << 2) then
			tempakRoleItem["uiItemNum"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 3) == ( 1 << 3) then
			tempakRoleItem["uiDueTime"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 4) == ( 1 << 4) then
			tempakRoleItem["uiEnhanceGrade"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 5) == ( 1 << 5) then
			tempakRoleItem["uiCoinRemainRecastTimes"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 6) == ( 1 << 6) then
			tempakRoleItem["iAttrNum"] = netStreamValue:ReadInt()
		end
		local iAttrNum = tempakRoleItem["iAttrNum"]
		tempakRoleItem["auiAttrData"] = {}
		for j = 0,iAttrNum or -1 do
			if j >= iAttrNum then
				break
			end
			local tempauiAttrData = { ["uiAttrUID"] = 0,["uiType"] = 0,["iBaseValue"] = 0,["iExtraValue"] = 0,["uiRecastType"] = 0,} 
			tempauiAttrData["uiAttrUID"] = netStreamValue:ReadInt()
			tempauiAttrData["uiType"] = netStreamValue:ReadInt()
			tempauiAttrData["iBaseValue"] = netStreamValue:ReadInt()
			tempauiAttrData["iExtraValue"] = netStreamValue:ReadInt()
			tempauiAttrData["uiRecastType"] = netStreamValue:ReadByte()
			tempakRoleItem["auiAttrData"][j] = tempauiAttrData
		end
		if (iValueChangeFlag & 1 << 8) == ( 1 << 8) then
			tempakRoleItem["uiOwnerID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 9) == ( 1 << 9) then
			tempakRoleItem["bBelongToMainRole"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 10) == ( 1 << 10) then
			tempakRoleItem["uiSpendIron"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 11) == ( 1 << 11) then
			tempakRoleItem["uiPerfectPower"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 12) == ( 1 << 12) then
			tempakRoleItem["uiSpendTongLingYu"] = netStreamValue:ReadInt()
		end
		result["akRoleItem"][i] = tempakRoleItem
	end
	return result
end

function Decode_SeGAC_PlatTeam_MartialInfo(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["iSize"] = 0,["akRoleMartial"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["akRoleMartial"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempakRoleMartial = { ["iValueChangeFlag"] = 0,["uiID"] = 0,["uiRoleUID"] = 0,["uiTypeID"] = 0,["uiLevel"] = 0,["uiExp"] = 0,["uiExtExpApp"] = 0,["uiMaxLevel"] = 0,["iMartialAttrSize"] = 0,["akMartialAttrs"] = nil,["iMartialUnlockItemSize"] = 0,["auiMartialUnlockItems"] = nil,["iMartialInfluenceSize"] = 0,["akMartialInfluences"] = nil,["iMartialUnlockSkillSize"] = 0,["auiMartialUnlockSkills"] = nil,["iStrongLevel"] = 0,["iStrongCount"] = -1,["uiAttr1"] = 0,["uiAttr2"] = 0,["uiAttr3"] = 0,["uiColdTime"] = 0,} 
		local iValueChangeFlag = netStreamValue:ReadInt()
		tempakRoleMartial["iValueChangeFlag"] = iValueChangeFlag
		if (iValueChangeFlag & 1 << 0) == ( 1 << 0) then
			tempakRoleMartial["uiID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 1) == ( 1 << 1) then
			tempakRoleMartial["uiRoleUID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 2) == ( 1 << 2) then
			tempakRoleMartial["uiTypeID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 3) == ( 1 << 3) then
			tempakRoleMartial["uiLevel"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 4) == ( 1 << 4) then
			tempakRoleMartial["uiExp"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 5) == ( 1 << 5) then
			tempakRoleMartial["uiExtExpApp"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 6) == ( 1 << 6) then
			tempakRoleMartial["uiMaxLevel"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 7) == ( 1 << 7) then
			tempakRoleMartial["iMartialAttrSize"] = netStreamValue:ReadByte()
		end
		local iMartialAttrSize = tempakRoleMartial["iMartialAttrSize"]
		tempakRoleMartial["akMartialAttrs"] = {}
		for j = 0,iMartialAttrSize or -1 do
			if j >= iMartialAttrSize then
				break
			end
			local tempakMartialAttrs = { ["uiType"] = 0,["iValue"] = 0,} 
			tempakMartialAttrs["uiType"] = netStreamValue:ReadInt()
			tempakMartialAttrs["iValue"] = netStreamValue:ReadInt()
			tempakRoleMartial["akMartialAttrs"][j] = tempakMartialAttrs
		end
		if (iValueChangeFlag & 1 << 9) == ( 1 << 9) then
			tempakRoleMartial["iMartialUnlockItemSize"] = netStreamValue:ReadByte()
		end
		local iMartialUnlockItemSize = tempakRoleMartial["iMartialUnlockItemSize"]
			tempakRoleMartial["auiMartialUnlockItems"] = {}
		for j = 0,iMartialUnlockItemSize or -1 do
			if j >= iMartialUnlockItemSize then
				break
			end
			tempakRoleMartial["auiMartialUnlockItems"][j] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 11) == ( 1 << 11) then
			tempakRoleMartial["iMartialInfluenceSize"] = netStreamValue:ReadByte()
		end
		local iMartialInfluenceSize = tempakRoleMartial["iMartialInfluenceSize"]
		tempakRoleMartial["akMartialInfluences"] = {}
		for j = 0,iMartialInfluenceSize or -1 do
			if j >= iMartialInfluenceSize then
				break
			end
			local tempakMartialInfluences = { ["uiAttrType"] = 0,["uiMartialTypeID"] = 0,["uiMartialValue"] = 0,["uiMartialInit"] = 0,} 
			tempakMartialInfluences["uiAttrType"] = netStreamValue:ReadInt()
			tempakMartialInfluences["uiMartialTypeID"] = netStreamValue:ReadInt()
			tempakMartialInfluences["uiMartialValue"] = netStreamValue:ReadInt()
			tempakMartialInfluences["uiMartialInit"] = netStreamValue:ReadByte()
			tempakRoleMartial["akMartialInfluences"][j] = tempakMartialInfluences
		end
		if (iValueChangeFlag & 1 << 13) == ( 1 << 13) then
			tempakRoleMartial["iMartialUnlockSkillSize"] = netStreamValue:ReadByte()
		end
		local iMartialUnlockSkillSize = tempakRoleMartial["iMartialUnlockSkillSize"]
			tempakRoleMartial["auiMartialUnlockSkills"] = {}
		for j = 0,iMartialUnlockSkillSize or -1 do
			if j >= iMartialUnlockSkillSize then
				break
			end
			tempakRoleMartial["auiMartialUnlockSkills"][j] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 15) == ( 1 << 15) then
			tempakRoleMartial["iStrongLevel"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 16) == ( 1 << 16) then
			tempakRoleMartial["iStrongCount"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 17) == ( 1 << 17) then
			tempakRoleMartial["uiAttr1"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 18) == ( 1 << 18) then
			tempakRoleMartial["uiAttr2"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 19) == ( 1 << 19) then
			tempakRoleMartial["uiAttr3"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 20) == ( 1 << 20) then
			tempakRoleMartial["uiColdTime"] = netStreamValue:ReadByte()
		end
		result["akRoleMartial"][i] = tempakRoleMartial
	end
	return result
end

function Decode_SeGAC_PlatTeam_WishTaskInfo(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["iSize"] = 0,["akRoleWishTask"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["akRoleWishTask"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempakRoleWishTask = { ["uiID"] = 0,["uiTypeID"] = 0,["uiState"] = 0,["uiReward"] = 0,["uiRoleCard"] = 0,["bFirstGet"] = 0,} 
		tempakRoleWishTask["uiID"] = netStreamValue:ReadInt()
		tempakRoleWishTask["uiTypeID"] = netStreamValue:ReadInt()
		tempakRoleWishTask["uiState"] = netStreamValue:ReadInt()
		tempakRoleWishTask["uiReward"] = netStreamValue:ReadInt()
		tempakRoleWishTask["uiRoleCard"] = netStreamValue:ReadInt()
		tempakRoleWishTask["bFirstGet"] = netStreamValue:ReadByte()
		result["akRoleWishTask"][i] = tempakRoleWishTask
	end
	return result
end

function Decode_SeGAC_PlatTeam_GiftInfo(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,["iSize"] = 0,["akRoleGift"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["akRoleGift"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempakRoleGift = { ["uiID"] = 0,["uiTypeID"] = 0,["uiGiftSourceType"] = 0,["bIsGrowUp"] = 0,} 
		tempakRoleGift["uiID"] = netStreamValue:ReadInt()
		tempakRoleGift["uiTypeID"] = netStreamValue:ReadInt()
		tempakRoleGift["uiGiftSourceType"] = netStreamValue:ReadInt()
		tempakRoleGift["bIsGrowUp"] = netStreamValue:ReadByte()
		result["akRoleGift"][i] = tempakRoleGift
	end
	return result
end

function Decode_SeGAC_PlatTeam_EmbattleInfo(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["kEmbattleSingle"] = nil,["iEmbattleNum"] = 0,["akRoleEmbattle"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eQueryType"] = netStreamValue:ReadInt()
	result["kEmbattleSingle"] = {["uiRoleID"] = 0,["iID"] = 0,["iRound"] = 0,["iGridX"] = 0,["iGridY"] = 0,["eFlag"] = INVALID,["bPet"] = false,["uiFlag"] = 0,}
		result["kEmbattleSingle"]["uiRoleID"] = netStreamValue:ReadInt()
		result["kEmbattleSingle"]["iID"] = netStreamValue:ReadByte()
		result["kEmbattleSingle"]["iRound"] = netStreamValue:ReadByte()
		result["kEmbattleSingle"]["iGridX"] = netStreamValue:ReadByte()
		result["kEmbattleSingle"]["iGridY"] = netStreamValue:ReadByte()
		result["kEmbattleSingle"]["eFlag"] = netStreamValue:ReadInt()
		result["kEmbattleSingle"]["bPet"] = netStreamValue:ReadByte()
		result["kEmbattleSingle"]["uiFlag"] = netStreamValue:ReadInt()
	result["iEmbattleNum"] = netStreamValue:ReadInt()
	result["akRoleEmbattle"] = {}
		local iEmbattleNum = result["iEmbattleNum"]
	for i = 0,iEmbattleNum or -1 do
		if i >= iEmbattleNum then
			break
		end
		local tempakRoleEmbattle = { ["uiRoleID"] = 0,["iID"] = 0,["iRound"] = 0,["iGridX"] = 0,["iGridY"] = 0,["eFlag"] = INVALID,["bPet"] = false,["uiFlag"] = 0,} 
		tempakRoleEmbattle["uiRoleID"] = netStreamValue:ReadInt()
		tempakRoleEmbattle["iID"] = netStreamValue:ReadByte()
		tempakRoleEmbattle["iRound"] = netStreamValue:ReadByte()
		tempakRoleEmbattle["iGridX"] = netStreamValue:ReadByte()
		tempakRoleEmbattle["iGridY"] = netStreamValue:ReadByte()
		tempakRoleEmbattle["eFlag"] = netStreamValue:ReadInt()
		tempakRoleEmbattle["bPet"] = netStreamValue:ReadByte()
		tempakRoleEmbattle["uiFlag"] = netStreamValue:ReadInt()
		result["akRoleEmbattle"][i] = tempakRoleEmbattle
	end
	return result
end

function Decode_SeGAC_UpdateArenaMatchData(netStreamValue)
	local result = { ["iNum"] = nil,["akMatchData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akMatchData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakMatchData = { ["dwMatchType"] = 0,["dwMatchID"] = 0,["dwBufferID"] = 0,["dwSignUpCount"] = 0,["uiStage"] = 0,["dwRoundID"] = 0,["uiSignUpPlace"] = 0,["dwRank"] = 0,["dwBetWinTimes"] = 0,["dwBetWinMoney"] = 0,["dwBattleTime"] = 0,} 
		tempakMatchData["dwMatchType"] = netStreamValue:ReadInt()
		tempakMatchData["dwMatchID"] = netStreamValue:ReadInt()
		tempakMatchData["dwBufferID"] = netStreamValue:ReadInt()
		tempakMatchData["dwSignUpCount"] = netStreamValue:ReadInt()
		tempakMatchData["uiStage"] = netStreamValue:ReadByte()
		tempakMatchData["dwRoundID"] = netStreamValue:ReadByte()
		tempakMatchData["uiSignUpPlace"] = netStreamValue:ReadByte()
		tempakMatchData["dwRank"] = netStreamValue:ReadInt()
		tempakMatchData["dwBetWinTimes"] = netStreamValue:ReadInt()
		tempakMatchData["dwBetWinMoney"] = netStreamValue:ReadInt()
		tempakMatchData["dwBattleTime"] = netStreamValue:ReadInt()
		result["akMatchData"][i] = tempakMatchData
	end
	return result
end

function Decode_SeGAC_UpdateArenaBattleData(netStreamValue)
	local result = { ["dwMatchType"] = 0,["dwMatchID"] = 0,["dwPushFlag"] = 0,["iNum"] = nil,["akBattleData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwMatchType"] = netStreamValue:ReadInt()
	result["dwMatchID"] = netStreamValue:ReadInt()
	result["dwPushFlag"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadInt()
	result["akBattleData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakBattleData = { ["dwBattleID"] = 0,["dwRoundID"] = 0,["dwPly1BetRate"] = 0,["dwPly2BetRate"] = 0,["defPlyWinner"] = 0,["defBetPlyID"] = 0,["dwBetMoney"] = 0,["kPly1Data"] = nil,["kPly2Data"] = nil,} 
		tempakBattleData["dwBattleID"] = netStreamValue:ReadInt()
		tempakBattleData["dwRoundID"] = netStreamValue:ReadInt()
		tempakBattleData["dwPly1BetRate"] = netStreamValue:ReadInt()
		tempakBattleData["dwPly2BetRate"] = netStreamValue:ReadInt()
		tempakBattleData["defPlyWinner"] = netStreamValue:ReadDword64()
		tempakBattleData["defBetPlyID"] = netStreamValue:ReadDword64()
		tempakBattleData["dwBetMoney"] = netStreamValue:ReadInt()
		tempakBattleData["kPly1Data"] = {}
		tempakBattleData["kPly1Data"]["defPlayerID"] = netStreamValue:ReadDword64()
		tempakBattleData["kPly1Data"]["dwModelID"] = netStreamValue:ReadInt()
		tempakBattleData["kPly1Data"]["dwOnlineTime"] = netStreamValue:ReadInt()
		tempakBattleData["kPly1Data"]["dwMerdianLevel"] = netStreamValue:ReadInt()
		tempakBattleData["kPly1Data"]["acPlayerName"] = netStreamValue:ReadString()
		tempakBattleData["kPly1Data"]["charPicUrl"] = netStreamValue:ReadString()
		tempakBattleData["kPly1Data"]["dwRoleID"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"] = {}
		tempakBattleData["kPly2Data"]["defPlayerID"] = netStreamValue:ReadDword64()
		tempakBattleData["kPly2Data"]["dwModelID"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"]["dwOnlineTime"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"]["dwMerdianLevel"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"]["acPlayerName"] = netStreamValue:ReadString()
		tempakBattleData["kPly2Data"]["charPicUrl"] = netStreamValue:ReadString()
		tempakBattleData["kPly2Data"]["dwRoleID"] = netStreamValue:ReadInt()
		result["akBattleData"][i] = tempakBattleData
	end
	return result
end

function Decode_SeGAC_UpdateSignUpName(netStreamValue)
	local result = { ["dwMatchType"] = 0,["dwMatchID"] = 0,["iNum"] = nil,["akSignUpName"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwMatchType"] = netStreamValue:ReadInt()
	result["dwMatchID"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akSignUpName"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakSignUpName = { ["acPlayerName"] = nil,} 
		tempakSignUpName["acPlayerName"] = netStreamValue:ReadString()
		result["akSignUpName"][i] = tempakSignUpName
	end
	return result
end

function Decode_SeGAC_ArenaBattleRecordData(netStreamValue)
	local result = { ["uiBattleID"] = 0,["defPlayerID"] = 0,["winPlayerID"] = 0,["dwTotalSize"] = 0,["uiBatchIdx"] = 0,["iBatchSize"] = 0,["akData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiBattleID"] = netStreamValue:ReadInt()
	result["defPlayerID"] = netStreamValue:ReadDword64()
	result["winPlayerID"] = netStreamValue:ReadDword64()
	result["dwTotalSize"] = netStreamValue:ReadInt()
	result["uiBatchIdx"] = netStreamValue:ReadInt()
	result["iBatchSize"] = netStreamValue:ReadInt()
	local iBatchSize = result["iBatchSize"]
		result["akData"] = {}
	for i = 0,iBatchSize or -1 do
		if i >= iBatchSize then
			break
		end
		result["akData"][i] = netStreamValue:ReadByte()
	end
	return result
end

function Decode_SeGAC_NotifyArenaMemberPkData(netStreamValue)
	local result = { ["dwMatchType"] = 0,["dwMatchID"] = 0,["defPlayerID"] = 0,["iPkDataCount"] = 0,["akPkData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwMatchType"] = netStreamValue:ReadInt()
	result["dwMatchID"] = netStreamValue:ReadInt()
	result["defPlayerID"] = netStreamValue:ReadDword64()
	result["iPkDataCount"] = netStreamValue:ReadByte()
	result["akPkData"] = {}
		local iPkDataCount = result["iPkDataCount"]
	for i = 0,iPkDataCount or -1 do
		if i >= iPkDataCount then
			break
		end
		local tempakPkData = { ["iPkDataFlag"] = 0,["iDataSize"] = 0,["akData"] = nil,} 
		tempakPkData["iPkDataFlag"] = netStreamValue:ReadByte()
		tempakPkData["iDataSize"] = netStreamValue:ReadInt()
		local iDataSize = tempakPkData["iDataSize"]
			tempakPkData["akData"] = {}
		for j = 0,iDataSize or -1 do
			if j >= iDataSize then
				break
			end
			tempakPkData["akData"][j] = netStreamValue:ReadByte()
		end
		result["akPkData"][i] = tempakPkData
	end
	return result
end

function Decode_SeGAC_UpdateArenaBetRankData(netStreamValue)
	local result = { ["dwMatchType"] = 0,["dwMatchID"] = 0,["iNum"] = nil,["akRankData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwMatchType"] = netStreamValue:ReadInt()
	result["dwMatchID"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akRankData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakRankData = { ["defPlayerID"] = 0,["acPlayerName"] = nil,["dwValue"] = 0,} 
		tempakRankData["defPlayerID"] = netStreamValue:ReadDword64()
		tempakRankData["acPlayerName"] = netStreamValue:ReadString()
		tempakRankData["dwValue"] = netStreamValue:ReadInt()
		result["akRankData"][i] = tempakRankData
	end
	return result
end

function Decode_SeGAC_UpdateArenaMatchHistoryData(netStreamValue)
	local result = { ["iNum"] = nil,["akMatchHistoryData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akMatchHistoryData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakMatchHistoryData = { ["dwMatchType"] = 0,["dwMatchID"] = 0,["dwMatchTime"] = 0,["dwPlace"] = 0,["dwBetWinTimes"] = 0,["dwBetWinMoney"] = 0,["akMemberHistoryData"] = nil,} 
		tempakMatchHistoryData["dwMatchType"] = netStreamValue:ReadInt()
		tempakMatchHistoryData["dwMatchID"] = netStreamValue:ReadInt()
		tempakMatchHistoryData["dwMatchTime"] = netStreamValue:ReadInt()
		tempakMatchHistoryData["dwPlace"] = netStreamValue:ReadInt()
		tempakMatchHistoryData["dwBetWinTimes"] = netStreamValue:ReadInt()
		tempakMatchHistoryData["dwBetWinMoney"] = netStreamValue:ReadInt()
		tempakMatchHistoryData["akMemberHistoryData"] = {}
		for j = 0,3 or -1 do
			if j >= 3 then
				break
			end
			local tempakMemberHistoryData = { ["defPlayerID"] = 0,["acPlayerName"] = nil,["charPicUrl"] = nil,["dwModelID"] = 0,["dwPlace"] = 0,} 
			tempakMemberHistoryData["defPlayerID"] = netStreamValue:ReadDword64()
			tempakMemberHistoryData["acPlayerName"] = netStreamValue:ReadString()
			tempakMemberHistoryData["charPicUrl"] = netStreamValue:ReadString()
			tempakMemberHistoryData["dwModelID"] = netStreamValue:ReadInt()
			tempakMemberHistoryData["dwPlace"] = netStreamValue:ReadInt()
			tempakMatchHistoryData["akMemberHistoryData"][j] = tempakMemberHistoryData
		end
		result["akMatchHistoryData"][i] = tempakMatchHistoryData
	end
	return result
end

function Decode_SeGAC_UpdateArenaMatchJokeBattleData(netStreamValue)
	local result = { ["akJokeBattleData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["akJokeBattleData"] = {}
	for i = 0,5 or -1 do
		if i >= 5 then
			break
		end
		local tempakJokeBattleData = { ["acPlayerName"] = nil,["charPicUrl"] = nil,["dwModelID"] = 0,["dwResult"] = 0,} 
		tempakJokeBattleData["acPlayerName"] = netStreamValue:ReadString()
		tempakJokeBattleData["charPicUrl"] = netStreamValue:ReadString()
		tempakJokeBattleData["dwModelID"] = netStreamValue:ReadInt()
		tempakJokeBattleData["dwResult"] = netStreamValue:ReadInt()
		result["akJokeBattleData"][i] = tempakJokeBattleData
	end
	return result
end

function Decode_SeGAC_UpdateArenaMatchChampionTimes(netStreamValue)
	local result = { ["dwNewHandChampionTimes"] = 0,["dwPublicChampionTimes"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwNewHandChampionTimes"] = netStreamValue:ReadInt()
	result["dwPublicChampionTimes"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_NotifyArenaNotice(netStreamValue)
	local result = { ["uiNoticeFlag"] = ARENA_NOTICE_NULL,["dwMatchType"] = 0,["dwMatchID"] = 0,["defPlyID1"] = 0,["defPlyID2"] = 0,["acName1"] = nil,["acName2"] = nil,["dwPara1"] = 0,["dwPara2"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiNoticeFlag"] = netStreamValue:ReadInt()
	result["dwMatchType"] = netStreamValue:ReadInt()
	result["dwMatchID"] = netStreamValue:ReadInt()
	result["defPlyID1"] = netStreamValue:ReadDword64()
	result["defPlyID2"] = netStreamValue:ReadDword64()
	result["acName1"] = netStreamValue:ReadString()
	result["acName2"] = netStreamValue:ReadString()
	result["dwPara1"] = netStreamValue:ReadInt()
	result["dwPara2"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_UpdateArenaHuaShan(netStreamValue)
	local result = { ["iNum"] = nil,["akMemberes"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akMemberes"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakMemberes = { ["dwMatchType"] = 0,["defPlayerID"] = 0,["acPlayerName"] = nil,} 
		tempakMemberes["dwMatchType"] = netStreamValue:ReadInt()
		tempakMemberes["defPlayerID"] = netStreamValue:ReadDword64()
		tempakMemberes["acPlayerName"] = netStreamValue:ReadString()
		result["akMemberes"][i] = tempakMemberes
	end
	return result
end

function Decode_SeGAC_HoodlePublicInfoRet(netStreamValue)
	local result = { ["PublicInfo"] = nil,["uiCurItemId"] = 0,["DataInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["PublicInfo"] = {["uiOpenId"] = 0,["uiTurns"] = 0,["uiTotal"] = 0,["uiNeedTotal"] = 0,["uiBeginTime"] = 0,["bResult"] = false,["bOpen"] = false,["bUseUp"] = false,["uiPlayerNum"] = 0,["akHoodlePlayer"] = nil,["uiPersonalNum"] = 0,["akPersonalProc"] = nil,}
		result["PublicInfo"]["uiOpenId"] = netStreamValue:ReadInt()
		result["PublicInfo"]["uiTurns"] = netStreamValue:ReadInt()
		result["PublicInfo"]["uiTotal"] = netStreamValue:ReadInt()
		result["PublicInfo"]["uiNeedTotal"] = netStreamValue:ReadInt()
		result["PublicInfo"]["uiBeginTime"] = netStreamValue:ReadInt()
		result["PublicInfo"]["bResult"] = netStreamValue:ReadByte()
		result["PublicInfo"]["bOpen"] = netStreamValue:ReadByte()
		result["PublicInfo"]["bUseUp"] = netStreamValue:ReadByte()
		result["PublicInfo"]["uiPlayerNum"] = netStreamValue:ReadInt()
		local uiPlayerNum = result["PublicInfo"]["uiPlayerNum"]
		result["PublicInfo"]["akHoodlePlayer"] = {}
	for i = 0,uiPlayerNum or -1 do
		if i >= uiPlayerNum then
			break
		end
		local tempakHoodlePlayer = { ["defPlayerId"] = 0,["acPlayerName"] = nil,["uiPrecessValue"] = 0,["dwServerID"] = 0,} 
		tempakHoodlePlayer["defPlayerId"] = netStreamValue:ReadDword64()
		tempakHoodlePlayer["acPlayerName"] = netStreamValue:ReadString()
		tempakHoodlePlayer["uiPrecessValue"] = netStreamValue:ReadInt()
		tempakHoodlePlayer["dwServerID"] = netStreamValue:ReadInt()
		result["PublicInfo"]["akHoodlePlayer"][i] = tempakHoodlePlayer
	end
		result["PublicInfo"]["uiPersonalNum"] = netStreamValue:ReadInt()
		local uiPersonalNum = result["PublicInfo"]["uiPersonalNum"]
		result["PublicInfo"]["akPersonalProc"] = {}
	for i = 0,uiPersonalNum or -1 do
		if i >= uiPersonalNum then
			break
		end
		local tempakPersonalProc = { ["defPlayerId"] = 0,["acPlayerName"] = nil,["uiPrecessValue"] = 0,["dwServerID"] = 0,} 
		tempakPersonalProc["defPlayerId"] = netStreamValue:ReadDword64()
		tempakPersonalProc["acPlayerName"] = netStreamValue:ReadString()
		tempakPersonalProc["uiPrecessValue"] = netStreamValue:ReadInt()
		tempakPersonalProc["dwServerID"] = netStreamValue:ReadInt()
		result["PublicInfo"]["akPersonalProc"][i] = tempakPersonalProc
	end
	result["uiCurItemId"] = netStreamValue:ReadInt()
	result["DataInfo"] = {["uiBeginTime"] = 0,["uiEndTime"] = 0,["acResource"] = nil,["iNum"] = 0,["akAllItem"] = nil,["iNum2"] = 0,["akExchange"] = nil,["iNum3"] = 0,["akShowItem"] = nil,}
		result["DataInfo"]["uiBeginTime"] = netStreamValue:ReadDword64()
		result["DataInfo"]["uiEndTime"] = netStreamValue:ReadDword64()
		result["DataInfo"]["acResource"] = netStreamValue:ReadString()
		result["DataInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["DataInfo"]["iNum"]
		result["DataInfo"]["akAllItem"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakAllItem = { ["uiItemID"] = 0,["uiCurNum"] = 0,["uiTotalNum"] = 0,["uiShowTotalNum"] = 0,["bTopReward"] = false,} 
		tempakAllItem["uiItemID"] = netStreamValue:ReadInt()
		tempakAllItem["uiCurNum"] = netStreamValue:ReadInt()
		tempakAllItem["uiTotalNum"] = netStreamValue:ReadInt()
		tempakAllItem["uiShowTotalNum"] = netStreamValue:ReadInt()
		tempakAllItem["bTopReward"] = netStreamValue:ReadByte()
		result["DataInfo"]["akAllItem"][i] = tempakAllItem
	end
		result["DataInfo"]["iNum2"] = netStreamValue:ReadInt()
		local iNum2 = result["DataInfo"]["iNum2"]
		result["DataInfo"]["akExchange"] = {}
	for i = 0,iNum2 or -1 do
		if i >= iNum2 then
			break
		end
		local tempakExchange = { ["uiItemId"] = 0,["uiPrice"] = 0,} 
		tempakExchange["uiItemId"] = netStreamValue:ReadInt()
		tempakExchange["uiPrice"] = netStreamValue:ReadInt()
		result["DataInfo"]["akExchange"][i] = tempakExchange
	end
		result["DataInfo"]["iNum3"] = netStreamValue:ReadInt()
	local iNum3 = result["DataInfo"]["iNum3"]
		result["DataInfo"]["akShowItem"] = {}
	for i = 0,iNum3 or -1 do
		if i >= iNum3 then
			break
		end
			result["DataInfo"]["akShowItem"][i] = netStreamValue:ReadInt()
		end
	return result
end

function Decode_SeGAC_HoodlePublicRecordRet(netStreamValue)
	local result = { ["iCurPage"] = 0,["iSize"] = 0,["akHoodleRecord"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iCurPage"] = netStreamValue:ReadInt()
	result["iSize"] = netStreamValue:ReadInt()
	result["akHoodleRecord"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempakHoodleRecord = { ["uiRecordTime"] = 0,["defPlayerId"] = 0,["uiItemId"] = 0,["acPlayerName"] = nil,["bMaxCont"] = false,} 
		tempakHoodleRecord["uiRecordTime"] = netStreamValue:ReadInt()
		tempakHoodleRecord["defPlayerId"] = netStreamValue:ReadDword64()
		tempakHoodleRecord["uiItemId"] = netStreamValue:ReadInt()
		tempakHoodleRecord["acPlayerName"] = netStreamValue:ReadString()
		tempakHoodleRecord["bMaxCont"] = netStreamValue:ReadByte()
		result["akHoodleRecord"][i] = tempakHoodleRecord
	end
	return result
end

function Decode_SeGAC_HoodlePublicAssistReward(netStreamValue)
	local result = { ["dwItemId"] = 0,["dwItemNum"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwItemId"] = netStreamValue:ReadInt()
	result["dwItemNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_SetMainRoleRet(netStreamValue)
	local result = { ["uiRoleID"] = nil,["bResult"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiRoleID"] = netStreamValue:ReadInt()
	result["bResult"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeGAC_ObservePlatRoleRet(netStreamValue)
	local result = { ["defPlyID"] = 0,["uiRoleID"] = nil,["bResult"] = nil,["kPlatRoleCommon"] = nil,["aiAttrs"] = nil,["iGiftNum"] = 0,["auiRoleGift"] = nil,["iMartialNum"] = 0,["auiRoleMartial"] = nil,["auiEquipItem"] = nil,["iItemNum"] = 0,["akRoleItem"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["defPlyID"] = netStreamValue:ReadDword64()
	result["uiRoleID"] = netStreamValue:ReadInt()
	result["bResult"] = netStreamValue:ReadByte()
	result["kPlatRoleCommon"] = {["uiID"] = 0,["uiTypeID"] = 0,["uiNameID"] = 0,["uiTitleID"] = 0,["uiFamilyNameID"] = 0,["uiFirstNameID"] = 0,["uiLevel"] = 0,["uiClanID"] = 0,["uiHP"] = 0,["uiMP"] = 0,["uiExp"] = 0,["uiRemainAttrPoint"] = 0,["uiFragment"] = 0,["uiOverlayLevel"] = 0,["iGoodEvil"] = 0,["uiRemainGiftPoint"] = 0,["uiModelID"] = 0,["uiRank"] = 0,["uiMartialNum"] = 0,["uiEatFoodNum"] = 0,["uiEatFoodMaxNum"] = 0,["uiMarry"] = 0,["uiSubRole"] = 0,["uiFavorNum"] = 0,["auiFavor"] = nil,["uiBroAndSisNum"] = 0,["auiBroAndSis"] = nil,}
		result["kPlatRoleCommon"]["uiID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiTypeID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiNameID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiTitleID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFamilyNameID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFirstNameID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiLevel"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiClanID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiHP"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiMP"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiExp"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiRemainAttrPoint"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFragment"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiOverlayLevel"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["iGoodEvil"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiRemainGiftPoint"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiModelID"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiRank"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiMartialNum"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiEatFoodNum"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiEatFoodMaxNum"] = netStreamValue:ReadInt()
	result["kPlatRoleCommon"]["uiMarry"] = {}
	for i = 0,256 or -1 do
		if i >= 256 then
			break
		end
			result["kPlatRoleCommon"]["uiMarry"][i] = netStreamValue:ReadInt()
		end
		result["kPlatRoleCommon"]["uiSubRole"] = netStreamValue:ReadInt()
		result["kPlatRoleCommon"]["uiFavorNum"] = netStreamValue:ReadInt()
	local uiFavorNum = result["kPlatRoleCommon"]["uiFavorNum"]
		result["kPlatRoleCommon"]["auiFavor"] = {}
	for i = 0,uiFavorNum or -1 do
		if i >= uiFavorNum then
			break
		end
			result["kPlatRoleCommon"]["auiFavor"][i] = netStreamValue:ReadInt()
		end
		result["kPlatRoleCommon"]["uiBroAndSisNum"] = netStreamValue:ReadInt()
	local uiBroAndSisNum = result["kPlatRoleCommon"]["uiBroAndSisNum"]
		result["kPlatRoleCommon"]["auiBroAndSis"] = {}
	for i = 0,uiBroAndSisNum or -1 do
		if i >= uiBroAndSisNum then
			break
		end
			result["kPlatRoleCommon"]["auiBroAndSis"][i] = netStreamValue:ReadInt()
		end
	result["aiAttrs"] = {}
	for i = 0,SSD_MAX_ROLE_DISPLAYATTR_NUMS or -1 do
		if i >= SSD_MAX_ROLE_DISPLAYATTR_NUMS then
			break
		end
		result["aiAttrs"][i] = netStreamValue:ReadInt()
	end
	result["iGiftNum"] = netStreamValue:ReadInt()
	local iGiftNum = result["iGiftNum"]
		result["auiRoleGift"] = {}
	for i = 0,iGiftNum or -1 do
		if i >= iGiftNum then
			break
		end
		result["auiRoleGift"][i] = netStreamValue:ReadInt()
	end
	result["iMartialNum"] = netStreamValue:ReadInt()
	result["auiRoleMartial"] = {}
		local iMartialNum = result["iMartialNum"]
	for i = 0,iMartialNum or -1 do
		if i >= iMartialNum then
			break
		end
		local tempauiRoleMartial = { ["uiKey"] = 0,["uiValue"] = 0,} 
		tempauiRoleMartial["uiKey"] = netStreamValue:ReadInt()
		tempauiRoleMartial["uiValue"] = netStreamValue:ReadInt()
		result["auiRoleMartial"][i] = tempauiRoleMartial
	end
	result["auiEquipItem"] = {}
	for i = 0,REI_NUMS or -1 do
		if i >= REI_NUMS then
			break
		end
		result["auiEquipItem"][i] = netStreamValue:ReadInt()
	end
	result["iItemNum"] = netStreamValue:ReadInt()
	result["akRoleItem"] = {}
		local iItemNum = result["iItemNum"]
	for i = 0,iItemNum or -1 do
		if i >= iItemNum then
			break
		end
		local tempakRoleItem = { ["iValueChangeFlag"] = 0,["uiID"] = 0,["uiTypeID"] = 0,["uiItemNum"] = 0,["uiDueTime"] = 0,["uiEnhanceGrade"] = 0,["uiCoinRemainRecastTimes"] = 0,["iAttrNum"] = 0,["auiAttrData"] = nil,["uiOwnerID"] = 0,["bBelongToMainRole"] = 0,["uiSpendIron"] = 0,["uiPerfectPower"] = 0,["uiSpendTongLingYu"] = 0,} 
		local iValueChangeFlag = netStreamValue:ReadInt()
		tempakRoleItem["iValueChangeFlag"] = iValueChangeFlag
		if (iValueChangeFlag & 1 << 0) == ( 1 << 0) then
			tempakRoleItem["uiID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 1) == ( 1 << 1) then
			tempakRoleItem["uiTypeID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 2) == ( 1 << 2) then
			tempakRoleItem["uiItemNum"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 3) == ( 1 << 3) then
			tempakRoleItem["uiDueTime"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 4) == ( 1 << 4) then
			tempakRoleItem["uiEnhanceGrade"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 5) == ( 1 << 5) then
			tempakRoleItem["uiCoinRemainRecastTimes"] = netStreamValue:ReadShort()
		end
		if (iValueChangeFlag & 1 << 6) == ( 1 << 6) then
			tempakRoleItem["iAttrNum"] = netStreamValue:ReadInt()
		end
		local iAttrNum = tempakRoleItem["iAttrNum"]
		tempakRoleItem["auiAttrData"] = {}
		for j = 0,iAttrNum or -1 do
			if j >= iAttrNum then
				break
			end
			local tempauiAttrData = { ["uiAttrUID"] = 0,["uiType"] = 0,["iBaseValue"] = 0,["iExtraValue"] = 0,["uiRecastType"] = 0,} 
			tempauiAttrData["uiAttrUID"] = netStreamValue:ReadInt()
			tempauiAttrData["uiType"] = netStreamValue:ReadInt()
			tempauiAttrData["iBaseValue"] = netStreamValue:ReadInt()
			tempauiAttrData["iExtraValue"] = netStreamValue:ReadInt()
			tempauiAttrData["uiRecastType"] = netStreamValue:ReadByte()
			tempakRoleItem["auiAttrData"][j] = tempauiAttrData
		end
		if (iValueChangeFlag & 1 << 8) == ( 1 << 8) then
			tempakRoleItem["uiOwnerID"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 9) == ( 1 << 9) then
			tempakRoleItem["bBelongToMainRole"] = netStreamValue:ReadByte()
		end
		if (iValueChangeFlag & 1 << 10) == ( 1 << 10) then
			tempakRoleItem["uiSpendIron"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 11) == ( 1 << 11) then
			tempakRoleItem["uiPerfectPower"] = netStreamValue:ReadInt()
		end
		if (iValueChangeFlag & 1 << 12) == ( 1 << 12) then
			tempakRoleItem["uiSpendTongLingYu"] = netStreamValue:ReadInt()
		end
		result["akRoleItem"][i] = tempakRoleItem
	end
	return result
end

function Decode_SeGAC_ArenaMatchOperateRetCode(netStreamValue)
	local result = { ["akRankData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["akRankData"] = {["defPlayerID"] = 0,["acPlayerName"] = nil,["dwValue"] = 0,}
		result["akRankData"]["defPlayerID"] = netStreamValue:ReadDword64()
		result["akRankData"]["acPlayerName"] = netStreamValue:ReadString()
		result["akRankData"]["dwValue"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_RetRolePetCardOperate(netStreamValue)
	local result = { ["uiCardType"] = 0,["iNum"] = 0,["akData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiCardType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakData = { ["uiCardID"] = 0,["uiLevel"] = 0,["uiCardNum"] = 0,["uiUseFlag"] = 0,} 
		tempakData["uiCardID"] = netStreamValue:ReadInt()
		tempakData["uiLevel"] = netStreamValue:ReadInt()
		tempakData["uiCardNum"] = netStreamValue:ReadInt()
		tempakData["uiUseFlag"] = netStreamValue:ReadInt()
		result["akData"][i] = tempakData
	end
	return result
end

function Decode_SeGAC_PlatShopMallRewardRet(netStreamValue)
	local result = { ["eType"] = PSMRRT_FAILED,["iValue"] = 0,["iSelfValue"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eType"] = netStreamValue:ReadInt()
	result["iValue"] = netStreamValue:ReadInt()
	result["iSelfValue"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlatShopMallQueryItemRet(netStreamValue)
	local result = { ["uiType"] = 0,["iNum"] = 0,["akItem"] = nil,["iRackNum"] = 0,["auiValidRacks"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akItem"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakItem = { ["uiShopID"] = 0,["uiItemID"] = 0,["uiProperty"] = 0,["uiMoneyType"] = 0,["iPrice"] = 0,["iDiscount"] = 0,["iFinalPrice"] = 0,["uiFlag"] = 0,["iRemainTime"] = 0,["iCanBuyCount"] = -1,["iMaxBuyNums"] = -1,["iNeedUnlockType"] = -1,["iNeedUnlockID"] = -1,["iMaxBuyNumsPeriod"] = 0,["iType"] = 0,["iSort"] = 0,} 
		tempakItem["uiShopID"] = netStreamValue:ReadInt()
		tempakItem["uiItemID"] = netStreamValue:ReadInt()
		tempakItem["uiProperty"] = netStreamValue:ReadInt()
		tempakItem["uiMoneyType"] = netStreamValue:ReadInt()
		tempakItem["iPrice"] = netStreamValue:ReadInt()
		tempakItem["iDiscount"] = netStreamValue:ReadInt()
		tempakItem["iFinalPrice"] = netStreamValue:ReadInt()
		tempakItem["uiFlag"] = netStreamValue:ReadInt()
		tempakItem["iRemainTime"] = netStreamValue:ReadInt()
		tempakItem["iCanBuyCount"] = netStreamValue:ReadInt()
		tempakItem["iMaxBuyNums"] = netStreamValue:ReadInt()
		tempakItem["iNeedUnlockType"] = netStreamValue:ReadInt()
		tempakItem["iNeedUnlockID"] = netStreamValue:ReadInt()
		tempakItem["iMaxBuyNumsPeriod"] = netStreamValue:ReadInt()
		tempakItem["iType"] = netStreamValue:ReadInt()
		tempakItem["iSort"] = netStreamValue:ReadInt()
		result["akItem"][i] = tempakItem
	end
	result["iRackNum"] = netStreamValue:ReadInt()
	local iRackNum = result["iRackNum"]
		result["auiValidRacks"] = {}
	for i = 0,iRackNum or -1 do
		if i >= iRackNum then
			break
		end
		result["auiValidRacks"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_PlatShopMallBuyRet(netStreamValue)
	local result = { ["eType"] = PSMBRT_FAILED,["iItemTypeID"] = 0,["iNum"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eType"] = netStreamValue:ReadInt()
	result["iItemTypeID"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_SystemFunctionSwitchNotify(netStreamValue)
	local result = { ["bOpen"] = false,["eSwitch"] = SGLST_NONE,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bOpen"] = netStreamValue:ReadByte()
	result["eSwitch"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_Day3SingInRet(netStreamValue)
	local result = { ["eOpt"] = nil,["dwID"] = nil,["eState"] = nil,["dwTimeStamp"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["eOpt"] = netStreamValue:ReadInt()
	result["dwID"] = netStreamValue:ReadInt()
	result["eState"] = netStreamValue:ReadInt()
	result["dwTimeStamp"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_ExChangeGoldToSilverRet(netStreamValue)
	local result = { ["bResult"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bResult"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeGAC_CheckTencentAntiAddictionRet(netStreamValue)
	local result = { ["acMessage"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["acMessage"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_ChooseScriptAchieveRet(netStreamValue)
	local result = { ["bOpr"] = false,["iNum"] = 0,["akChooseAchieveRewardID"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bOpr"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["akChooseAchieveRewardID"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["akChooseAchieveRewardID"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_PlatDisplayNewToast(netStreamValue)
	local result = { ["uiBaseID"] = nil,["bShowInChatOnly"] = nil,["uiParam1"] = nil,["uiParam2"] = nil,["uiParam3"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiBaseID"] = netStreamValue:ReadInt()
	result["bShowInChatOnly"] = netStreamValue:ReadByte()
	result["uiParam1"] = netStreamValue:ReadInt()
	result["uiParam2"] = netStreamValue:ReadInt()
	result["uiParam3"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_SyncTssDataSendToClient(netStreamValue)
	local result = { ["acAntiData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["acAntiData"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_GetRedPacketRet(netStreamValue)
	local result = { ["redPacketUID"] = nil,["ret"] = 0,["iItemId"] = 0,["iItemNum"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["redPacketUID"] = netStreamValue:ReadString()
	result["ret"] = netStreamValue:ReadInt()
	result["iItemId"] = netStreamValue:ReadInt()
	result["iItemNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_QueryForBidInfoRet(netStreamValue)
	local result = { ["bAdd"] = false,["iNum"] = 0,["akRet"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bAdd"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadInt()
	result["akRet"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakRet = { ["eSeForBidType"] = SFBT_NULL,["dwBegineTime"] = 0,["iTime"] = 0,["acReason"] = nil,} 
		tempakRet["eSeForBidType"] = netStreamValue:ReadInt()
		tempakRet["dwBegineTime"] = netStreamValue:ReadInt()
		tempakRet["iTime"] = netStreamValue:ReadInt()
		tempakRet["acReason"] = netStreamValue:ReadString()
		result["akRet"][i] = tempakRet
	end
	return result
end

function Decode_SeGAC_RequestTencentCreditScoreRet(netStreamValue)
	local result = { ["TencentCreditScore"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["TencentCreditScore"] = {["iScore"] = 0,["iTagBlack"] = 0,["iMTime"] = nil,}
		result["TencentCreditScore"]["iScore"] = netStreamValue:ReadInt()
		result["TencentCreditScore"]["iTagBlack"] = netStreamValue:ReadInt()
		result["TencentCreditScore"]["iMTime"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_RequestPrivateChatSceneLimitRet(netStreamValue)
	local result = { ["bResult"] = 1,["iNum"] = 0,["akTencentSceneLimitState"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bResult"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadInt()
	result["akTencentSceneLimitState"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakTencentSceneLimitState = { ["uiKey"] = 0,["uiValue"] = 0,} 
		tempakTencentSceneLimitState["uiKey"] = netStreamValue:ReadInt()
		tempakTencentSceneLimitState["uiValue"] = netStreamValue:ReadInt()
		result["akTencentSceneLimitState"][i] = tempakTencentSceneLimitState
	end
	return result
end

function Decode_SeGAC_LimitShopRet(netStreamValue)
	local result = { ["iResult"] = 0,["acShopInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iResult"] = netStreamValue:ReadInt()
	result["acShopInfo"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_HoodleNumRet(netStreamValue)
	local result = { ["ePoolType"] = SHLPLT_NULL,["eHoodleBallType"] = SHBT_NULL,["dwCurNum"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["ePoolType"] = netStreamValue:ReadInt()
	result["eHoodleBallType"] = netStreamValue:ReadInt()
	result["dwCurNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_GiftBagResultRet(netStreamValue)
	local result = { ["iNum"] = 0,["akItems"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akItems"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakItems = { ["dwItemTypeID"] = 0,["dwItemUID"] = 0,["dwNum"] = 0,} 
		tempakItems["dwItemTypeID"] = netStreamValue:ReadInt()
		tempakItems["dwItemUID"] = netStreamValue:ReadInt()
		tempakItems["dwNum"] = netStreamValue:ReadInt()
		result["akItems"][i] = tempakItems
	end
	return result
end

function Decode_SeGAC_RequestCollectionPointRet(netStreamValue)
	local result = { ["iNum"] = 0,["aiCollectionPoint"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["aiCollectionPoint"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["aiCollectionPoint"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_LimitShopGetYaZhuInfoRet(netStreamValue)
	local result = { ["acData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["acData"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_SyncPlatCommonFunctionValue(netStreamValue)
	local result = { ["uiType"] = 0,["uiValue"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiType"] = netStreamValue:ReadInt()
	result["uiValue"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_PlatChallengeReward(netStreamValue)
	local result = { ["dwDropID"] = 0,["dwItemID"] = 0,["dwModelID"] = 0,["acPlayerName"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwDropID"] = netStreamValue:ReadInt()
	result["dwItemID"] = netStreamValue:ReadInt()
	result["dwModelID"] = netStreamValue:ReadInt()
	result["acPlayerName"] = netStreamValue:ReadString()
	return result
end

function Decode_SeGAC_UpdateNoviceGuideFlagRet(netStreamValue)
	local result = { ["dwFlag"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwFlag"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_UpdateZMRoomInfo(netStreamValue)
	local result = { ["dwRoundId"] = 0,["dwEquipLv"] = 0,["dwTime"] = 0,["dwFightId"] = 0,["iFreezeCardNum"] = 0,["akFreezeCardData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["dwRoundId"] = netStreamValue:ReadInt()
	result["dwEquipLv"] = netStreamValue:ReadInt()
	result["dwTime"] = netStreamValue:ReadInt()
	result["dwFightId"] = netStreamValue:ReadInt()
	result["iFreezeCardNum"] = netStreamValue:ReadInt()
	local iFreezeCardNum = result["iFreezeCardNum"]
		result["akFreezeCardData"] = {}
	for i = 0,iFreezeCardNum or -1 do
		if i >= iFreezeCardNum then
			break
		end
		result["akFreezeCardData"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeGAC_UpdateZMRoomInfoExt(netStreamValue)
	local result = { ["nRoomId"] = 0,["iNum"] = nil,["akPlyData"] = nil,["akCardData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["nRoomId"] = netStreamValue:ReadDword64()
	result["iNum"] = netStreamValue:ReadInt()
	result["akPlyData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakPlyData = { ["kPlyData"] = nil,["bRobot"] = 0,} 
		tempakPlyData["kPlyData"] = {}
		tempakPlyData["kPlyData"]["defPlayerID"] = netStreamValue:ReadDword64()
		tempakPlyData["kPlyData"]["dwModelID"] = netStreamValue:ReadInt()
		tempakPlyData["kPlyData"]["dwOnlineTime"] = netStreamValue:ReadInt()
		tempakPlyData["kPlyData"]["dwMerdianLevel"] = netStreamValue:ReadInt()
		tempakPlyData["kPlyData"]["acPlayerName"] = netStreamValue:ReadString()
		tempakPlyData["kPlyData"]["charPicUrl"] = netStreamValue:ReadString()
		tempakPlyData["kPlyData"]["dwRoleID"] = netStreamValue:ReadInt()
		tempakPlyData["bRobot"] = netStreamValue:ReadByte()
		result["akPlyData"][i] = tempakPlyData
	end
	result["akCardData"] = {}
	for i = 0,SSD_MAX_ZM_CARD_POOL_SIZE or -1 do
		if i >= SSD_MAX_ZM_CARD_POOL_SIZE then
			break
		end
		local tempakCardData = { ["dwBaseId"] = 0,["dwCardNum"] = 0,} 
		tempakCardData["dwBaseId"] = netStreamValue:ReadInt()
		tempakCardData["dwCardNum"] = netStreamValue:ReadInt()
		result["akCardData"][i] = tempakCardData
	end
	return result
end

function Decode_SeGAC_UpdateZMPlayerInfo(netStreamValue)
	local result = { ["kPlayerInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kPlayerInfo"] = {["akBattleCardData"] = nil,["iCardNum"] = 0,["akCardData"] = nil,["iEquipNum"] = 0,["akEquipData"] = nil,["dwClan"] = 0,["dwBattleCardNum"] = 0,}
	result["kPlayerInfo"]["akBattleCardData"] = {}
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
			result["kPlayerInfo"]["akBattleCardData"][i] = netStreamValue:ReadInt()
		end
		result["kPlayerInfo"]["iCardNum"] = netStreamValue:ReadInt()
		local iCardNum = result["kPlayerInfo"]["iCardNum"]
		result["kPlayerInfo"]["akCardData"] = {}
	for i = 0,iCardNum or -1 do
		if i >= iCardNum then
			break
		end
		local tempakCardData = { ["dwBaseId"] = 0,["dwLv"] = 0,["dwId"] = 0,["dwEquipId"] = 0,["wX"] = 0,["wY"] = 0,} 
		tempakCardData["dwBaseId"] = netStreamValue:ReadInt()
		tempakCardData["dwLv"] = netStreamValue:ReadInt()
		tempakCardData["dwId"] = netStreamValue:ReadInt()
		tempakCardData["dwEquipId"] = netStreamValue:ReadInt()
		tempakCardData["wX"] = netStreamValue:ReadShort()
		tempakCardData["wY"] = netStreamValue:ReadShort()
		result["kPlayerInfo"]["akCardData"][i] = tempakCardData
	end
		result["kPlayerInfo"]["iEquipNum"] = netStreamValue:ReadInt()
		local iEquipNum = result["kPlayerInfo"]["iEquipNum"]
		result["kPlayerInfo"]["akEquipData"] = {}
	for i = 0,iEquipNum or -1 do
		if i >= iEquipNum then
			break
		end
		local tempakEquipData = { ["dwBaseId"] = 0,["dwLv"] = 0,["dwId"] = 0,} 
		tempakEquipData["dwBaseId"] = netStreamValue:ReadInt()
		tempakEquipData["dwLv"] = netStreamValue:ReadInt()
		tempakEquipData["dwId"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["akEquipData"][i] = tempakEquipData
	end
		result["kPlayerInfo"]["dwClan"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwBattleCardNum"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_UpdateZMPlayerInfoExt(netStreamValue)
	local result = { ["kPlayerInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kPlayerInfo"] = {["akSelectCardData"] = nil,["akSelectClanData"] = nil,["akSelectEquipData"] = nil,["dwRound"] = 0,["dwEventId"] = 0,["dwReflashTimes"] = 0,["dwSkillUseTimes"] = 0,["dwGold"] = 0,}
		result["kPlayerInfo"]["akSelectCardData"] = {}
	for i = 0,SSD_MAX_ZM_SELECT_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_SELECT_CARD_SIZE then
			break
		end
		local tempakSelectCardData = { ["dwBaseId"] = 0,["dwLv"] = 0,} 
		tempakSelectCardData["dwBaseId"] = netStreamValue:ReadInt()
		tempakSelectCardData["dwLv"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["akSelectCardData"][i] = tempakSelectCardData
	end
	result["kPlayerInfo"]["akSelectClanData"] = {}
	for i = 0,SSD_MAX_ZM_SELECT_CLAN_SIZE or -1 do
		if i >= SSD_MAX_ZM_SELECT_CLAN_SIZE then
			break
		end
			result["kPlayerInfo"]["akSelectClanData"][i] = netStreamValue:ReadInt()
		end
	result["kPlayerInfo"]["akSelectEquipData"] = {}
	for i = 0,SSD_MAX_ZM_SELECT_EQUIP_SIZE or -1 do
		if i >= SSD_MAX_ZM_SELECT_EQUIP_SIZE then
			break
		end
			result["kPlayerInfo"]["akSelectEquipData"][i] = netStreamValue:ReadInt()
		end
		result["kPlayerInfo"]["dwRound"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwEventId"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwReflashTimes"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwSkillUseTimes"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwGold"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_ZmBattleRecordData(netStreamValue)
	local result = { ["uiBattleID"] = 0,["dwFightID"] = 0,["defPlayerID"] = 0,["winPlayerID"] = 0,["dwTotalSize"] = 0,["uiBatchIdx"] = 0,["iBatchSize"] = 0,["akData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiBattleID"] = netStreamValue:ReadInt()
	result["dwFightID"] = netStreamValue:ReadInt()
	result["defPlayerID"] = netStreamValue:ReadDword64()
	result["winPlayerID"] = netStreamValue:ReadDword64()
	result["dwTotalSize"] = netStreamValue:ReadInt()
	result["uiBatchIdx"] = netStreamValue:ReadInt()
	result["iBatchSize"] = netStreamValue:ReadInt()
	local iBatchSize = result["iBatchSize"]
		result["akData"] = {}
	for i = 0,iBatchSize or -1 do
		if i >= iBatchSize then
			break
		end
		result["akData"][i] = netStreamValue:ReadByte()
	end
	return result
end

function Decode_SeGAC_UpdateZmBattleData(netStreamValue)
	local result = { ["bGet"] = 0,["iNum"] = nil,["akBattleData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bGet"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadInt()
	result["akBattleData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakBattleData = { ["uiBattleID"] = 0,["uiRoundID"] = 0,["uiWinnerID"] = 0,["kPly1Data"] = nil,["kPly2Data"] = nil,} 
		tempakBattleData["uiBattleID"] = netStreamValue:ReadInt()
		tempakBattleData["uiRoundID"] = netStreamValue:ReadInt()
		tempakBattleData["uiWinnerID"] = netStreamValue:ReadDword64()
		tempakBattleData["kPly1Data"] = {}
		tempakBattleData["kPly1Data"]["defPlayerID"] = netStreamValue:ReadDword64()
		tempakBattleData["kPly1Data"]["dwModelID"] = netStreamValue:ReadInt()
		tempakBattleData["kPly1Data"]["dwOnlineTime"] = netStreamValue:ReadInt()
		tempakBattleData["kPly1Data"]["dwMerdianLevel"] = netStreamValue:ReadInt()
		tempakBattleData["kPly1Data"]["acPlayerName"] = netStreamValue:ReadString()
		tempakBattleData["kPly1Data"]["charPicUrl"] = netStreamValue:ReadString()
		tempakBattleData["kPly1Data"]["dwRoleID"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"] = {}
		tempakBattleData["kPly2Data"]["defPlayerID"] = netStreamValue:ReadDword64()
		tempakBattleData["kPly2Data"]["dwModelID"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"]["dwOnlineTime"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"]["dwMerdianLevel"] = netStreamValue:ReadInt()
		tempakBattleData["kPly2Data"]["acPlayerName"] = netStreamValue:ReadString()
		tempakBattleData["kPly2Data"]["charPicUrl"] = netStreamValue:ReadString()
		tempakBattleData["kPly2Data"]["dwRoleID"] = netStreamValue:ReadInt()
		result["akBattleData"][i] = tempakBattleData
	end
	return result
end

function Decode_SeGAC_ResponseZmOperate(netStreamValue)
	local result = { ["enRequest"] = EN_ZM_REQUEST_NULL,["enError"] = EN_ZM_ERROR_None,["iParams0"] = 0,["iParams1"] = 0,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["enRequest"] = netStreamValue:ReadInt()
	result["enError"] = netStreamValue:ReadInt()
	result["iParams0"] = netStreamValue:ReadInt()
	result["iParams1"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_UpdateZmShop(netStreamValue)
	local result = { ["bGet"] = 0,["dwGold"] = 0,["dwTime"] = 0,["iNum"] = 0,["akItems"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["bGet"] = netStreamValue:ReadByte()
	result["dwGold"] = netStreamValue:ReadInt()
	result["dwTime"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akItems"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakItems = { ["dwRoleId"] = 0,["dwRoleNum"] = 0,} 
		tempakItems["dwRoleId"] = netStreamValue:ReadInt()
		tempakItems["dwRoleNum"] = netStreamValue:ReadInt()
		result["akItems"][i] = tempakItems
	end
	return result
end

function Decode_SeGAC_UpdateZMOtherPlayerInfo(netStreamValue)
	local result = { ["kPlayerInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kPlayerInfo"] = {["defPlayerID"] = 0,["acPlayerName"] = nil,["akCardData"] = nil,["akEquipData"] = nil,["dwClan"] = 0,["dwBuffID"] = 0,["dwClanBuffID"] = 0,["dwClanBuffCount"] = 0,}
		result["kPlayerInfo"]["defPlayerID"] = netStreamValue:ReadDword64()
		result["kPlayerInfo"]["acPlayerName"] = netStreamValue:ReadString()
		result["kPlayerInfo"]["akCardData"] = {}
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		local tempakCardData = { ["dwBaseId"] = 0,["dwLv"] = 0,["dwId"] = 0,["dwEquipId"] = 0,["wX"] = 0,["wY"] = 0,} 
		tempakCardData["dwBaseId"] = netStreamValue:ReadInt()
		tempakCardData["dwLv"] = netStreamValue:ReadInt()
		tempakCardData["dwId"] = netStreamValue:ReadInt()
		tempakCardData["dwEquipId"] = netStreamValue:ReadInt()
		tempakCardData["wX"] = netStreamValue:ReadShort()
		tempakCardData["wY"] = netStreamValue:ReadShort()
		result["kPlayerInfo"]["akCardData"][i] = tempakCardData
	end
		result["kPlayerInfo"]["akEquipData"] = {}
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		local tempakEquipData = { ["dwBaseId"] = 0,["dwLv"] = 0,["dwId"] = 0,} 
		tempakEquipData["dwBaseId"] = netStreamValue:ReadInt()
		tempakEquipData["dwLv"] = netStreamValue:ReadInt()
		tempakEquipData["dwId"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["akEquipData"][i] = tempakEquipData
	end
		result["kPlayerInfo"]["dwClan"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwBuffID"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwClanBuffID"] = netStreamValue:ReadInt()
		result["kPlayerInfo"]["dwClanBuffCount"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeGAC_ZmNotice(netStreamValue)
	local result = { ["enNotice"] = EN_ZM_NOTICE_NULL,["acSrcPlayerName"] = nil,["acTargetPlayerName"] = nil,["iNum"] = 0,["akNoticePairs"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["enNotice"] = netStreamValue:ReadInt()
	result["acSrcPlayerName"] = netStreamValue:ReadString()
	result["acTargetPlayerName"] = netStreamValue:ReadString()
	result["iNum"] = netStreamValue:ReadInt()
	result["akNoticePairs"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakNoticePairs = { ["dwFirst"] = 0,["dwSecond"] = 0,} 
		tempakNoticePairs["dwFirst"] = netStreamValue:ReadInt()
		tempakNoticePairs["dwSecond"] = netStreamValue:ReadInt()
		result["akNoticePairs"][i] = tempakNoticePairs
	end
	return result
end

function Decode_SeGAC_QuerySectInfoRet(netStreamValue)
	local result = { ["kStoreInfo"] = nil,["iBuildingNum"] = nil,["akBuidlingInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kStoreInfo"] = {["iNum"] = 0,["akStoreItemInfo"] = nil,}
		result["kStoreInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["kStoreInfo"]["iNum"]
		result["kStoreInfo"]["akStoreItemInfo"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakStoreItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,} 
		tempakStoreItemInfo["dwItemID"] = netStreamValue:ReadInt()
		tempakStoreItemInfo["dwItemNum"] = netStreamValue:ReadInt()
		result["kStoreInfo"]["akStoreItemInfo"][i] = tempakStoreItemInfo
	end
	result["iBuildingNum"] = netStreamValue:ReadInt()
	result["akBuidlingInfo"] = {}
		local iBuildingNum = result["iBuildingNum"]
	for i = 0,iBuildingNum or -1 do
		if i >= iBuildingNum then
			break
		end
		local tempakBuidlingInfo = { ["dwBuildingID"] = 0,["dwBuildingType"] = 0,["dwBuildingLevel"] = 0,["dwBuildingPos"] = 0,["dwPreBuildingID"] = 0,["acName"] = nil,["dwBackGroundID"] = 0,["dwUpgradeEndTime"] = 0,["iNum"] = 0,["akWorkshopItemInfo"] = nil,["akDiscipleInfo"] = nil,} 
		tempakBuidlingInfo["dwBuildingID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingType"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingLevel"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingPos"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwPreBuildingID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["acName"] = netStreamValue:ReadString()
		tempakBuidlingInfo["dwBackGroundID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwUpgradeEndTime"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["iNum"] = netStreamValue:ReadInt()
		local iNum = tempakBuidlingInfo["iNum"]
		tempakBuidlingInfo["akWorkshopItemInfo"] = {}
		for j = 0,iNum or -1 do
			if j >= iNum then
				break
			end
			local tempakWorkshopItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,["dwUpdateTime"] = 0,} 
			tempakWorkshopItemInfo["dwItemID"] = netStreamValue:ReadInt()
			tempakWorkshopItemInfo["dwItemNum"] = netStreamValue:ReadInt()
			tempakWorkshopItemInfo["dwUpdateTime"] = netStreamValue:ReadInt()
			tempakBuidlingInfo["akWorkshopItemInfo"][j] = tempakWorkshopItemInfo
		end
		tempakBuidlingInfo["akDiscipleInfo"] = {}
		for j = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
			if j >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
				break
			end
			tempakBuidlingInfo["akDiscipleInfo"][j] = netStreamValue:ReadInt()
		end
		result["akBuidlingInfo"][i] = tempakBuidlingInfo
	end
	return result
end

function Decode_SeGAC_SectBuildingSaveRet(netStreamValue)
	local result = { ["kStoreInfo"] = nil,["iBuildingNum"] = nil,["akBuidlingInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kStoreInfo"] = {["iNum"] = 0,["akStoreItemInfo"] = nil,}
		result["kStoreInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["kStoreInfo"]["iNum"]
		result["kStoreInfo"]["akStoreItemInfo"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakStoreItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,} 
		tempakStoreItemInfo["dwItemID"] = netStreamValue:ReadInt()
		tempakStoreItemInfo["dwItemNum"] = netStreamValue:ReadInt()
		result["kStoreInfo"]["akStoreItemInfo"][i] = tempakStoreItemInfo
	end
	result["iBuildingNum"] = netStreamValue:ReadInt()
	result["akBuidlingInfo"] = {}
		local iBuildingNum = result["iBuildingNum"]
	for i = 0,iBuildingNum or -1 do
		if i >= iBuildingNum then
			break
		end
		local tempakBuidlingInfo = { ["dwBuildingID"] = 0,["dwBuildingType"] = 0,["dwBuildingLevel"] = 0,["dwBuildingPos"] = 0,["dwPreBuildingID"] = 0,["acName"] = nil,["dwBackGroundID"] = 0,["dwUpgradeEndTime"] = 0,["iNum"] = 0,["akWorkshopItemInfo"] = nil,["akDiscipleInfo"] = nil,} 
		tempakBuidlingInfo["dwBuildingID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingType"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingLevel"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingPos"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwPreBuildingID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["acName"] = netStreamValue:ReadString()
		tempakBuidlingInfo["dwBackGroundID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwUpgradeEndTime"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["iNum"] = netStreamValue:ReadInt()
		local iNum = tempakBuidlingInfo["iNum"]
		tempakBuidlingInfo["akWorkshopItemInfo"] = {}
		for j = 0,iNum or -1 do
			if j >= iNum then
				break
			end
			local tempakWorkshopItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,["dwUpdateTime"] = 0,} 
			tempakWorkshopItemInfo["dwItemID"] = netStreamValue:ReadInt()
			tempakWorkshopItemInfo["dwItemNum"] = netStreamValue:ReadInt()
			tempakWorkshopItemInfo["dwUpdateTime"] = netStreamValue:ReadInt()
			tempakBuidlingInfo["akWorkshopItemInfo"][j] = tempakWorkshopItemInfo
		end
		tempakBuidlingInfo["akDiscipleInfo"] = {}
		for j = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
			if j >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
				break
			end
			tempakBuidlingInfo["akDiscipleInfo"][j] = netStreamValue:ReadInt()
		end
		result["akBuidlingInfo"][i] = tempakBuidlingInfo
	end
	return result
end

function Decode_SeGAC_SectBuildingUpgradeRet(netStreamValue)
	local result = { ["kBuidlingInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kBuidlingInfo"] = {["dwBuildingID"] = 0,["dwBuildingType"] = 0,["dwBuildingLevel"] = 0,["dwBuildingPos"] = 0,["dwPreBuildingID"] = 0,["acName"] = nil,["dwBackGroundID"] = 0,["dwUpgradeEndTime"] = 0,["iNum"] = 0,["akWorkshopItemInfo"] = nil,["akDiscipleInfo"] = nil,}
		result["kBuidlingInfo"]["dwBuildingID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingType"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingLevel"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingPos"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwPreBuildingID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["acName"] = netStreamValue:ReadString()
		result["kBuidlingInfo"]["dwBackGroundID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwUpgradeEndTime"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["kBuidlingInfo"]["iNum"]
		result["kBuidlingInfo"]["akWorkshopItemInfo"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakWorkshopItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,["dwUpdateTime"] = 0,} 
		tempakWorkshopItemInfo["dwItemID"] = netStreamValue:ReadInt()
		tempakWorkshopItemInfo["dwItemNum"] = netStreamValue:ReadInt()
		tempakWorkshopItemInfo["dwUpdateTime"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["akWorkshopItemInfo"][i] = tempakWorkshopItemInfo
	end
	result["kBuidlingInfo"]["akDiscipleInfo"] = {}
	for i = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if i >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
			result["kBuidlingInfo"]["akDiscipleInfo"][i] = netStreamValue:ReadInt()
		end
	return result
end

function Decode_SeGAC_SectMaterialGetRet(netStreamValue)
	local result = { ["kBuidlingInfo"] = nil,["kStoreInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kBuidlingInfo"] = {["dwBuildingID"] = 0,["dwBuildingType"] = 0,["dwBuildingLevel"] = 0,["dwBuildingPos"] = 0,["dwPreBuildingID"] = 0,["acName"] = nil,["dwBackGroundID"] = 0,["dwUpgradeEndTime"] = 0,["iNum"] = 0,["akWorkshopItemInfo"] = nil,["akDiscipleInfo"] = nil,}
		result["kBuidlingInfo"]["dwBuildingID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingType"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingLevel"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingPos"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwPreBuildingID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["acName"] = netStreamValue:ReadString()
		result["kBuidlingInfo"]["dwBackGroundID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwUpgradeEndTime"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["kBuidlingInfo"]["iNum"]
		result["kBuidlingInfo"]["akWorkshopItemInfo"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakWorkshopItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,["dwUpdateTime"] = 0,} 
		tempakWorkshopItemInfo["dwItemID"] = netStreamValue:ReadInt()
		tempakWorkshopItemInfo["dwItemNum"] = netStreamValue:ReadInt()
		tempakWorkshopItemInfo["dwUpdateTime"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["akWorkshopItemInfo"][i] = tempakWorkshopItemInfo
	end
	result["kBuidlingInfo"]["akDiscipleInfo"] = {}
	for i = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if i >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
			result["kBuidlingInfo"]["akDiscipleInfo"][i] = netStreamValue:ReadInt()
		end
	result["kStoreInfo"] = {["iNum"] = 0,["akStoreItemInfo"] = nil,}
		result["kStoreInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["kStoreInfo"]["iNum"]
		result["kStoreInfo"]["akStoreItemInfo"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakStoreItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,} 
		tempakStoreItemInfo["dwItemID"] = netStreamValue:ReadInt()
		tempakStoreItemInfo["dwItemNum"] = netStreamValue:ReadInt()
		result["kStoreInfo"]["akStoreItemInfo"][i] = tempakStoreItemInfo
	end
	return result
end

function Decode_SeGAC_SectDisciplePutRet(netStreamValue)
	local result = { ["iBuildingNum"] = nil,["akBuidlingInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iBuildingNum"] = netStreamValue:ReadInt()
	result["akBuidlingInfo"] = {}
		local iBuildingNum = result["iBuildingNum"]
	for i = 0,iBuildingNum or -1 do
		if i >= iBuildingNum then
			break
		end
		local tempakBuidlingInfo = { ["dwBuildingID"] = 0,["dwBuildingType"] = 0,["dwBuildingLevel"] = 0,["dwBuildingPos"] = 0,["dwPreBuildingID"] = 0,["acName"] = nil,["dwBackGroundID"] = 0,["dwUpgradeEndTime"] = 0,["iNum"] = 0,["akWorkshopItemInfo"] = nil,["akDiscipleInfo"] = nil,} 
		tempakBuidlingInfo["dwBuildingID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingType"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingLevel"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwBuildingPos"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwPreBuildingID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["acName"] = netStreamValue:ReadString()
		tempakBuidlingInfo["dwBackGroundID"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["dwUpgradeEndTime"] = netStreamValue:ReadInt()
		tempakBuidlingInfo["iNum"] = netStreamValue:ReadInt()
		local iNum = tempakBuidlingInfo["iNum"]
		tempakBuidlingInfo["akWorkshopItemInfo"] = {}
		for j = 0,iNum or -1 do
			if j >= iNum then
				break
			end
			local tempakWorkshopItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,["dwUpdateTime"] = 0,} 
			tempakWorkshopItemInfo["dwItemID"] = netStreamValue:ReadInt()
			tempakWorkshopItemInfo["dwItemNum"] = netStreamValue:ReadInt()
			tempakWorkshopItemInfo["dwUpdateTime"] = netStreamValue:ReadInt()
			tempakBuidlingInfo["akWorkshopItemInfo"][j] = tempakWorkshopItemInfo
		end
		tempakBuidlingInfo["akDiscipleInfo"] = {}
		for j = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
			if j >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
				break
			end
			tempakBuidlingInfo["akDiscipleInfo"][j] = netStreamValue:ReadInt()
		end
		result["akBuidlingInfo"][i] = tempakBuidlingInfo
	end
	return result
end

function Decode_SeGAC_SectBuildingNameRet(netStreamValue)
	local result = { ["kBuidlingInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kBuidlingInfo"] = {["dwBuildingID"] = 0,["dwBuildingType"] = 0,["dwBuildingLevel"] = 0,["dwBuildingPos"] = 0,["dwPreBuildingID"] = 0,["acName"] = nil,["dwBackGroundID"] = 0,["dwUpgradeEndTime"] = 0,["iNum"] = 0,["akWorkshopItemInfo"] = nil,["akDiscipleInfo"] = nil,}
		result["kBuidlingInfo"]["dwBuildingID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingType"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingLevel"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwBuildingPos"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwPreBuildingID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["acName"] = netStreamValue:ReadString()
		result["kBuidlingInfo"]["dwBackGroundID"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["dwUpgradeEndTime"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["iNum"] = netStreamValue:ReadInt()
		local iNum = result["kBuidlingInfo"]["iNum"]
		result["kBuidlingInfo"]["akWorkshopItemInfo"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakWorkshopItemInfo = { ["dwItemID"] = 0,["dwItemNum"] = 0,["dwUpdateTime"] = 0,} 
		tempakWorkshopItemInfo["dwItemID"] = netStreamValue:ReadInt()
		tempakWorkshopItemInfo["dwItemNum"] = netStreamValue:ReadInt()
		tempakWorkshopItemInfo["dwUpdateTime"] = netStreamValue:ReadInt()
		result["kBuidlingInfo"]["akWorkshopItemInfo"][i] = tempakWorkshopItemInfo
	end
	result["kBuidlingInfo"]["akDiscipleInfo"] = {}
	for i = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if i >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
			result["kBuidlingInfo"]["akDiscipleInfo"][i] = netStreamValue:ReadInt()
		end
	return result
end

function Decode_SeGAC_QueryActivityRet(netStreamValue)
	local result = { ["iNum"] = nil,["akActivityInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akActivityInfo"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakActivityInfo = { ["dwActivityID"] = 0,["iReset_time"] = 0,["iCycle_count"] = 0,["iHistory_count"] = 0,["iState"] = 0,["iValue1"] = 0,["iValue2"] = 0,["iValue3"] = 0,["bEnabled"] = false,} 
		tempakActivityInfo["dwActivityID"] = netStreamValue:ReadInt()
		tempakActivityInfo["iReset_time"] = netStreamValue:ReadInt()
		tempakActivityInfo["iCycle_count"] = netStreamValue:ReadInt()
		tempakActivityInfo["iHistory_count"] = netStreamValue:ReadInt()
		tempakActivityInfo["iState"] = netStreamValue:ReadInt()
		tempakActivityInfo["iValue1"] = netStreamValue:ReadDword64()
		tempakActivityInfo["iValue2"] = netStreamValue:ReadDword64()
		tempakActivityInfo["iValue3"] = netStreamValue:ReadDword64()
		tempakActivityInfo["bEnabled"] = netStreamValue:ReadByte()
		result["akActivityInfo"][i] = tempakActivityInfo
	end
	return result
end

function Decode_SeGAC_SystemFunctionSwitchNotifyAll(netStreamValue)
	local result = { ["iNum"] = 0,["akChooseAchieveRewardID"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akChooseAchieveRewardID"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakChooseAchieveRewardID = { ["bOpen"] = false,["eSwitch"] = SGLST_NONE,} 
		tempakChooseAchieveRewardID["bOpen"] = netStreamValue:ReadByte()
		tempakChooseAchieveRewardID["eSwitch"] = netStreamValue:ReadInt()
		result["akChooseAchieveRewardID"][i] = tempakChooseAchieveRewardID
	end
	return result
end

function Decode_SeGAC_QueryHoodlePrivacyResultRet(netStreamValue)
	local result = { ["kPrivacyInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["kPrivacyInfo"] = {["dwCurHoodlePrivacyID"] = 0,["dwBeginTimeStamp"] = 0,["dwEndTimeStamp"] = 0,["dwTotalNormalNum"] = 0,["dwCurResetNum"] = 0,["bResetReFresh"] = false,["akChivalrousInfo"] = nil,}
		result["kPrivacyInfo"]["dwCurHoodlePrivacyID"] = netStreamValue:ReadInt()
		result["kPrivacyInfo"]["dwBeginTimeStamp"] = netStreamValue:ReadInt()
		result["kPrivacyInfo"]["dwEndTimeStamp"] = netStreamValue:ReadInt()
		result["kPrivacyInfo"]["dwTotalNormalNum"] = netStreamValue:ReadInt()
		result["kPrivacyInfo"]["dwCurResetNum"] = netStreamValue:ReadInt()
		result["kPrivacyInfo"]["bResetReFresh"] = netStreamValue:ReadByte()
		result["kPrivacyInfo"]["akChivalrousInfo"] = {}
	for i = 0,SHPCT_NUM or -1 do
		if i >= SHPCT_NUM then
			break
		end
		local tempakChivalrousInfo = { ["uiItemID"] = 0,["uiItemNum"] = 0,} 
		tempakChivalrousInfo["uiItemID"] = netStreamValue:ReadInt()
		tempakChivalrousInfo["uiItemNum"] = netStreamValue:ReadInt()
		result["kPrivacyInfo"]["akChivalrousInfo"][i] = tempakChivalrousInfo
	end
	return result
end

function Decode_SeGAC_QueryStoryWeekLimitRet(netStreamValue)
	local result = { ["iNum"] = nil,["akWeekLimitInfo"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akWeekLimitInfo"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakWeekLimitInfo = { ["dwStoryID"] = 0,["iTakeOutNum"] = 0,} 
		tempakWeekLimitInfo["dwStoryID"] = netStreamValue:ReadInt()
		tempakWeekLimitInfo["iTakeOutNum"] = netStreamValue:ReadInt()
		result["akWeekLimitInfo"][i] = tempakWeekLimitInfo
	end
	return result
end

function Decode_SeGAC_UpdateSystemModuleEnableState(netStreamValue)
	local result = { ["iNum"] = nil,["abSystemModuleEnableState"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["abSystemModuleEnableState"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["abSystemModuleEnableState"][i] = netStreamValue:ReadByte()
	end
	return result
end

function Decode_SeGAC_AllRoleFaceRet(netStreamValue)
	local result = { ["uiScriptID"] = 0,["iNum"] = 0,["akRoleFaceData"] = nil,} 
	result["dwSeqNum"] = netStreamValue:ReadInt()
	result["uiScriptID"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akRoleFaceData"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakRoleFaceData = { ["uiHat"] = 0,["uiBack"] = 0,["uiHairBack"] = 0,["uiBody"] = 0,["uiFace"] = 0,["uiEyebrow"] = 0,["uiEye"] = 0,["uiMouth"] = 0,["uiNose"] = 0,["uiForeheadAdornment"] = 0,["uiFacialAdornment"] = 0,["uiHairFront"] = 0,["iEyebrowWidth"] = 0,["iEyebrowHeight"] = 0,["iEyebrowLocation"] = 0,["iEyeWidth"] = 0,["iEyeHeight"] = 0,["iEyeLocation"] = 0,["iNoseWidth"] = 0,["iNoseHeight"] = 0,["iNoseLocation"] = 0,["iMouthWidth"] = 0,["iMouthHeight"] = 0,["iMouthLocation"] = 0,["uiModelID"] = 0,["uiSex"] = 0,["uiCGSex"] = 0,["uiRoleID"] = 0,} 
		tempakRoleFaceData["uiHat"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiBack"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiHairBack"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiBody"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiFace"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiEyebrow"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiEye"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiMouth"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiNose"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiForeheadAdornment"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiFacialAdornment"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiHairFront"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iEyebrowWidth"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iEyebrowHeight"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iEyebrowLocation"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iEyeWidth"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iEyeHeight"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iEyeLocation"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iNoseWidth"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iNoseHeight"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iNoseLocation"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iMouthWidth"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iMouthHeight"] = netStreamValue:ReadInt()
		tempakRoleFaceData["iMouthLocation"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiModelID"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiSex"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiCGSex"] = netStreamValue:ReadInt()
		tempakRoleFaceData["uiRoleID"] = netStreamValue:ReadInt()
		result["akRoleFaceData"][i] = tempakRoleFaceData
	end
	return result
end

