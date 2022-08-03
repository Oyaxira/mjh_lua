-- auto make by Tool ProtocolMaker don't modify anything!!!
local CmdCLToGASDecodeTable = {}

--------  the cmd type to iCmd code--------------------------
CMD_CGA_PLAYERVALIDATE = 2089
CMD_CGA_HEARTBEAT = 2066
CMD_CGA_GAMECMD = 2105
CMD_CGA_SCRIPTOPR = 2097
CMD_CGA_PLAYERCHEAT = 2142
CMD_CGA_PLATITEMOPR = 2114
CMD_CGA_CHOOSESCRIPTDIFF = 2118
CMD_CGA_USERSUGGESTION = 2049
CMD_CGA_CHOOSESCRIPTACHIEVE = 2117
CMD_CGA_GETSCRIPTACHIEVEREWARD = 2087
CMD_CGA_MERIDIANSOPR = 2065
CMD_CGA_MARTIALINCOMPLETETEXTOPR = 2090
CMD_CGA_MAILOPR = 2060
CMD_CGA_FRIENDINFOOPR = 2137
CMD_CGA_MODIFYPLAYERAPPEARANCE = 2102
CMD_CGA_TLOGUPDATE = 2113
CMD_CGA_PUBLICCHAT = 2129
CMD_CGA_WORDFILTER = 2064
CMD_CGA_QUERYCLANCOLLECTIONINFO = 2111
CMD_CGA_PLATPLAYERSIMPLEINFOS = 2119
CMD_CGA_PLATPLAYERDETAILINFO = 2134
CMD_CGA_QUERYTREASUREBOOKINFO = 2054
CMD_CGA_QUERYHOODLELOTTERYINFO = 2075
CMD_CGA_SETCHARPICTUREURL = 2082
CMD_CGA_QUERYPLATTEAMINFO = 2051
CMD_CGA_COPYTEAMINFO = 2068
CMD_CGA_PLATEMBATTLE = 2083
CMD_CGA_REQUESTARENAMATCHOPERATE = 2063
CMD_CGA_REQUESTARENAMATCHBET = 2092
CMD_CGA_SETMAINROLE = 2094
CMD_CGA_OBSERVEPLATROLE = 2081
CMD_CGA_CHALLENGEPLATROLE = 2078
CMD_CGA_GIVEUPCHALLENGEPLATROLE = 2122
CMD_CGA_REQUESTROLEPETCARDOPERATE = 2136
CMD_CGA_PLATSHOPMALLREWARD = 2146
CMD_CGA_PLATITEMTOSCRIPTDILATATION = 2095
CMD_CGA_PLATSHOPMALLQUERYITEM = 2143
CMD_CGA_PLATSHOPMALLBUYITEM = 2148
CMD_CGA_UNLOCKCHALLENGEORDER = 2131
CMD_CGA_DAY3SINGIN = 2099
CMD_CGA_EXCHANGEGOLDTOSILVER = 2080
CMD_CGA_CHECKTENCENTANTIADDICTION = 2126
CMD_CGA_TSSSDK = 2067
CMD_CGA_QUERYHOODLEPUBLICRECORD = 2100
CMD_CGA_QUERYHOODLEPUBLICINFO = 2115
CMD_CGA_BUYHOODLESHOPITEM = 2061
CMD_CGA_QUERYPLAYERGOLD = 2147
CMD_CGA_REQUESTPLAYERINSAMESCRIPT = 2052
CMD_CGA_REPORTCHEATPLAYER = 2135
CMD_CGA_ADDFRIENDREQ = 2109
CMD_CGA_GETREDPACKET = 2071
CMD_CGA_QUERYFORBIDINFO = 2130
CMD_CGA_REQUESTTENCENTCREDITSCORE = 2062
CMD_CGA_REQUESTPRIVATECHATSCENELIMIT = 2058
CMD_CGA_LIMITSHOPOPR = 2106
CMD_CGA_REQUESTCOLLECTIONPOINT = 2112
CMD_CGA_OPERATORSIGNINFLAG = 2056
CMD_CGA_BUYSECONDGOLD = 2098
CMD_CGA_UPDATENOVICEGUIDEFLAG = 2132
CMD_CGA_QUERYPUBLICJWT = 2128
CMD_CGA_REQUESTZMOPERATE = 2139
CMD_CGA_REQUESTZMBATTLECARD = 2074
CMD_CGA_REQUESTGETDAILYREWARD = 2124
CMD_CGA_UNLOCKSTORY = 2057
CMD_CGA_QUERYSECTINFO = 2127
CMD_CGA_SECTBUILDINGUPGRADE = 2108
CMD_CGA_SECTBUILDINGSAVE = 2076
CMD_CGA_SECTBUILDINGNAME = 2085
CMD_CGA_SECTDISCIPLEPUT = 2103
CMD_CGA_SECTMATERIALGET = 2125
CMD_CGA_ACTIVITYEVENT = 2072
CMD_CGA_QUERYSTORYWEEKLIMIT = 2104
CMD_CGA_STOPENTERSTORY = 2145
CMD_CGA_SYNCNEWBIRDGUIDESTATE = 2123
CMD_CGA_REQUESTSAVEFILEOPT = 2086
--------------------------------------------------------------
function registerCLToGASCommand()
	CmdCLToGASDecodeTable[CMD_CGA_PLAYERVALIDATE] = Decode_SeCGA_PlayerValidate
	CmdCLToGASDecodeTable[CMD_CGA_HEARTBEAT] = Decode_SeCGA_HeartBeat
	CmdCLToGASDecodeTable[CMD_CGA_GAMECMD] = Decode_SeCGA_GameCmd
	CmdCLToGASDecodeTable[CMD_CGA_SCRIPTOPR] = Decode_SeCGA_ScriptOpr
	CmdCLToGASDecodeTable[CMD_CGA_PLAYERCHEAT] = Decode_SeCGA_PlayerCheat
	CmdCLToGASDecodeTable[CMD_CGA_PLATITEMOPR] = Decode_SeCGA_PlatItemOpr
	CmdCLToGASDecodeTable[CMD_CGA_CHOOSESCRIPTDIFF] = Decode_SeCGA_ChooseScriptDiff
	CmdCLToGASDecodeTable[CMD_CGA_USERSUGGESTION] = Decode_SeCGA_UserSuggestion
	CmdCLToGASDecodeTable[CMD_CGA_CHOOSESCRIPTACHIEVE] = Decode_SeCGA_ChooseScriptAchieve
	CmdCLToGASDecodeTable[CMD_CGA_GETSCRIPTACHIEVEREWARD] = Decode_SeCGA_GetScriptAchieveReward
	CmdCLToGASDecodeTable[CMD_CGA_MERIDIANSOPR] = Decode_SeCGA_MeridiansOpr
	CmdCLToGASDecodeTable[CMD_CGA_MARTIALINCOMPLETETEXTOPR] = Decode_SeCGA_MartialInCompleteTextOpr
	CmdCLToGASDecodeTable[CMD_CGA_MAILOPR] = Decode_SeCGA_MailOpr
	CmdCLToGASDecodeTable[CMD_CGA_FRIENDINFOOPR] = Decode_SeCGA_FriendInfoOpr
	CmdCLToGASDecodeTable[CMD_CGA_MODIFYPLAYERAPPEARANCE] = Decode_SeCGA_ModifyPlayerAppearance
	CmdCLToGASDecodeTable[CMD_CGA_TLOGUPDATE] = Decode_SeCGA_TLogUpdate
	CmdCLToGASDecodeTable[CMD_CGA_PUBLICCHAT] = Decode_SeCGA_PublicChat
	CmdCLToGASDecodeTable[CMD_CGA_WORDFILTER] = Decode_SeCGA_WordFilter
	CmdCLToGASDecodeTable[CMD_CGA_QUERYCLANCOLLECTIONINFO] = Decode_SeCGA_QueryClanCollectionInfo
	CmdCLToGASDecodeTable[CMD_CGA_PLATPLAYERSIMPLEINFOS] = Decode_SeCGA_PlatPlayerSimpleInfos
	CmdCLToGASDecodeTable[CMD_CGA_PLATPLAYERDETAILINFO] = Decode_SeCGA_PlatPlayerDetailInfo
	CmdCLToGASDecodeTable[CMD_CGA_QUERYTREASUREBOOKINFO] = Decode_SeCGA_QueryTreasureBookInfo
	CmdCLToGASDecodeTable[CMD_CGA_QUERYHOODLELOTTERYINFO] = Decode_SeCGA_QueryHoodleLotteryInfo
	CmdCLToGASDecodeTable[CMD_CGA_SETCHARPICTUREURL] = Decode_SeCGA_SetCharPictureUrl
	CmdCLToGASDecodeTable[CMD_CGA_QUERYPLATTEAMINFO] = Decode_SeCGA_QueryPlatTeamInfo
	CmdCLToGASDecodeTable[CMD_CGA_COPYTEAMINFO] = Decode_SeCGA_CopyTeamInfo
	CmdCLToGASDecodeTable[CMD_CGA_PLATEMBATTLE] = Decode_SeCGA_PlatEmbattle
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTARENAMATCHOPERATE] = Decode_SeCGA_RequestArenaMatchOperate
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTARENAMATCHBET] = Decode_SeCGA_RequestArenaMatchBet
	CmdCLToGASDecodeTable[CMD_CGA_SETMAINROLE] = Decode_SeCGA_SetMainRole
	CmdCLToGASDecodeTable[CMD_CGA_OBSERVEPLATROLE] = Decode_SeCGA_ObservePlatRole
	CmdCLToGASDecodeTable[CMD_CGA_CHALLENGEPLATROLE] = Decode_SeCGA_ChallengePlatRole
	CmdCLToGASDecodeTable[CMD_CGA_GIVEUPCHALLENGEPLATROLE] = Decode_SeCGA_GiveUpChallengePlatRole
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTROLEPETCARDOPERATE] = Decode_SeCGA_RequestRolePetCardOperate
	CmdCLToGASDecodeTable[CMD_CGA_PLATSHOPMALLREWARD] = Decode_SeCGA_PlatShopMallReward
	CmdCLToGASDecodeTable[CMD_CGA_PLATITEMTOSCRIPTDILATATION] = Decode_SeCGA_PlatItemToScriptDilatation
	CmdCLToGASDecodeTable[CMD_CGA_PLATSHOPMALLQUERYITEM] = Decode_SeCGA_PlatShopMallQueryItem
	CmdCLToGASDecodeTable[CMD_CGA_PLATSHOPMALLBUYITEM] = Decode_SeCGA_PlatShopMallBuyItem
	CmdCLToGASDecodeTable[CMD_CGA_UNLOCKCHALLENGEORDER] = Decode_SeCGA_UnlockChallengeOrder
	CmdCLToGASDecodeTable[CMD_CGA_DAY3SINGIN] = Decode_SeCGA_Day3SingIn
	CmdCLToGASDecodeTable[CMD_CGA_EXCHANGEGOLDTOSILVER] = Decode_SeCGA_ExChangeGoldToSilver
	CmdCLToGASDecodeTable[CMD_CGA_CHECKTENCENTANTIADDICTION] = Decode_SeCGA_CheckTencentAntiAddiction
	CmdCLToGASDecodeTable[CMD_CGA_TSSSDK] = Decode_SeCGA_TssSDK
	CmdCLToGASDecodeTable[CMD_CGA_QUERYHOODLEPUBLICRECORD] = Decode_SeCGA_QueryHoodlePublicRecord
	CmdCLToGASDecodeTable[CMD_CGA_QUERYHOODLEPUBLICINFO] = Decode_SeCGA_QueryHoodlePublicInfo
	CmdCLToGASDecodeTable[CMD_CGA_BUYHOODLESHOPITEM] = Decode_SeCGA_BuyHoodleShopItem
	CmdCLToGASDecodeTable[CMD_CGA_QUERYPLAYERGOLD] = Decode_SeCGA_QueryPlayerGold
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTPLAYERINSAMESCRIPT] = Decode_SeCGA_RequestPlayerInSameScript
	CmdCLToGASDecodeTable[CMD_CGA_REPORTCHEATPLAYER] = Decode_SeCGA_ReportCheatPlayer
	CmdCLToGASDecodeTable[CMD_CGA_ADDFRIENDREQ] = Decode_SeCGA_addFriendReq
	CmdCLToGASDecodeTable[CMD_CGA_GETREDPACKET] = Decode_SeCGA_GetRedPacket
	CmdCLToGASDecodeTable[CMD_CGA_QUERYFORBIDINFO] = Decode_SeCGA_QueryForBidInfo
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTTENCENTCREDITSCORE] = Decode_SeCGA_RequestTencentCreditScore
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTPRIVATECHATSCENELIMIT] = Decode_SeCGA_RequestPrivateChatSceneLimit
	CmdCLToGASDecodeTable[CMD_CGA_LIMITSHOPOPR] = Decode_SeCGA_LimitShopOpr
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTCOLLECTIONPOINT] = Decode_SeCGA_RequestCollectionPoint
	CmdCLToGASDecodeTable[CMD_CGA_OPERATORSIGNINFLAG] = Decode_SeCGA_OperatorSignInFlag
	CmdCLToGASDecodeTable[CMD_CGA_BUYSECONDGOLD] = Decode_SeCGA_BuySecondGold
	CmdCLToGASDecodeTable[CMD_CGA_UPDATENOVICEGUIDEFLAG] = Decode_SeCGA_UpdateNoviceGuideFlag
	CmdCLToGASDecodeTable[CMD_CGA_QUERYPUBLICJWT] = Decode_SeCGA_QueryPublicJWT
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTZMOPERATE] = Decode_SeCGA_RequestZmOperate
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTZMBATTLECARD] = Decode_SeCGA_RequestZmBattleCard
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTGETDAILYREWARD] = Decode_SeCGA_RequestGetDailyReward
	CmdCLToGASDecodeTable[CMD_CGA_UNLOCKSTORY] = Decode_SeCGA_UnlockStory
	CmdCLToGASDecodeTable[CMD_CGA_QUERYSECTINFO] = Decode_SeCGA_QuerySectInfo
	CmdCLToGASDecodeTable[CMD_CGA_SECTBUILDINGUPGRADE] = Decode_SeCGA_SectBuildingUpgrade
	CmdCLToGASDecodeTable[CMD_CGA_SECTBUILDINGSAVE] = Decode_SeCGA_SectBuildingSave
	CmdCLToGASDecodeTable[CMD_CGA_SECTBUILDINGNAME] = Decode_SeCGA_SectBuildingName
	CmdCLToGASDecodeTable[CMD_CGA_SECTDISCIPLEPUT] = Decode_SeCGA_SectDisciplePut
	CmdCLToGASDecodeTable[CMD_CGA_SECTMATERIALGET] = Decode_SeCGA_SectMaterialGet
	CmdCLToGASDecodeTable[CMD_CGA_ACTIVITYEVENT] = Decode_SeCGA_ActivityEvent
	CmdCLToGASDecodeTable[CMD_CGA_QUERYSTORYWEEKLIMIT] = Decode_SeCGA_QueryStoryWeekLimit
	CmdCLToGASDecodeTable[CMD_CGA_STOPENTERSTORY] = Decode_SeCGA_StopEnterStory
	CmdCLToGASDecodeTable[CMD_CGA_SYNCNEWBIRDGUIDESTATE] = Decode_SeCGA_SyncNewBirdGuideState
	CmdCLToGASDecodeTable[CMD_CGA_REQUESTSAVEFILEOPT] = Decode_SeCGA_RequestSaveFileOpt
end

function GetCLToGASDecodeFuncByCmd(iCmd)
	if CmdCLToGASDecodeTable[iCmd] ~= nil then
		return CmdCLToGASDecodeTable[iCmd]
	else
		return nil
	end
end

function Decode_SeCGA_PlayerValidate(netStreamValue)
	local result = { ["dwMSangoMagic"] = SSD_MSANGO_MAGIC,["defPlayerID"] = 0,["dwSessionId"] = 0,["dwVersion"] = 0,["acToken"] = nil,["kSystemInfo"] = nil,["bReconnect"] = false,} 
	result["dwMSangoMagic"] = netStreamValue:ReadInt()
	result["defPlayerID"] = netStreamValue:ReadDword64()
	result["dwSessionId"] = netStreamValue:ReadInt()
	result["dwVersion"] = netStreamValue:ReadInt()
	result["acToken"] = netStreamValue:ReadString()
	result["kSystemInfo"] = {["acClientVersion"] = NULL,["acSystemSoftware"] = NULL,["acSystemHardware"] = NULL,["acTelecomOper"] = NULL,["iScreenWidth"] = 0,["iScreenHight"] = 0,["acNetwork"] = NULL,["acDensity"] = 0,["iRegChannel"] = 0,["acCpuHardware"] = NULL,["iMemory"] = 0,["acGLRender"] = NULL,["acGLVersion"] = NULL,["acDeviceId"] = NULL,["acAndroidId"] = NULL,["acRealIMEI"] = NULL,["acIdfv"] = NULL,["dwPlatID"] = 0,["iTssSDKLen"] = 0,["acSecTssSDK"] = nil,["acVOpenID"] = nil,["acGOpenId"] = nil,["iClientLoginMethod"] = 0,["iTencentPrivate"] = 0,["acPF"] = nil,["acPFKey"] = nil,["acOpenKey"] = nil,["isGuest"] = false,["dwOS"] = 0,["iLoginChannel"] = 0,}
		result["kSystemInfo"]["acClientVersion"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acSystemSoftware"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acSystemHardware"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acTelecomOper"] = netStreamValue:ReadString()
		result["kSystemInfo"]["iScreenWidth"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["iScreenHight"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["acNetwork"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acDensity"] = netStreamValue:ReadString()
		result["kSystemInfo"]["iRegChannel"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["acCpuHardware"] = netStreamValue:ReadString()
		result["kSystemInfo"]["iMemory"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["acGLRender"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acGLVersion"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acDeviceId"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acAndroidId"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acRealIMEI"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acIdfv"] = netStreamValue:ReadString()
		result["kSystemInfo"]["dwPlatID"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["iTssSDKLen"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["acSecTssSDK"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acVOpenID"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acGOpenId"] = netStreamValue:ReadString()
		result["kSystemInfo"]["iClientLoginMethod"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["iTencentPrivate"] = netStreamValue:ReadInt()
		result["kSystemInfo"]["acPF"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acPFKey"] = netStreamValue:ReadString()
		result["kSystemInfo"]["acOpenKey"] = netStreamValue:ReadString()
		result["kSystemInfo"]["isGuest"] = netStreamValue:ReadByte()
		result["kSystemInfo"]["dwOS"] = netStreamValue:ReadByte()
		result["kSystemInfo"]["iLoginChannel"] = netStreamValue:ReadString()
	result["bReconnect"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeCGA_HeartBeat(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_GameCmd(netStreamValue)
	local result = { ["eType"] = SGC_NULL,["iSize"] = 0,["acData"] = 0,} 
	result["eType"] = netStreamValue:ReadInt()
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

function Decode_SeCGA_ScriptOpr(netStreamValue)
	local result = { ["eOprType"] = SEOT_NULL,["dwScriptID"] = 0,["bUseLucky"] = false,} 
	result["eOprType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["bUseLucky"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeCGA_PlayerCheat(netStreamValue)
	local result = { ["defOprPlayerID"] = 0,["dwScriptID"] = 0,["kPlayerCheat"] = nil,} 
	result["defOprPlayerID"] = netStreamValue:ReadDword64()
	result["dwScriptID"] = netStreamValue:ReadInt()
	result["kPlayerCheat"] = {["acParam"] = nil,}
		result["kPlayerCheat"]["acParam"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_PlatItemOpr(netStreamValue)
	local result = { ["eOprType"] = SPIO_NULL,["iNum"] = 0,["akOprItem"] = nil,["iChooseNum"] = 0,["adwChooseGift"] = nil,} 
	result["eOprType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	result["akOprItem"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakOprItem = { ["uiItemID"] = 0,["uiItemNum"] = 0,} 
		tempakOprItem["uiItemID"] = netStreamValue:ReadInt()
		tempakOprItem["uiItemNum"] = netStreamValue:ReadInt()
		result["akOprItem"][i] = tempakOprItem
	end
	result["iChooseNum"] = netStreamValue:ReadInt()
	local iChooseNum = result["iChooseNum"]
		result["adwChooseGift"] = {}
	for i = 0,iChooseNum or -1 do
		if i >= iChooseNum then
			break
		end
		result["adwChooseGift"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeCGA_ChooseScriptDiff(netStreamValue)
	local result = { ["dwChooseDiff"] = 0,} 
	result["dwChooseDiff"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_UserSuggestion(netStreamValue)
	local result = { ["acErrorInfo"] = nil,["acContent"] = nil,} 
	result["acErrorInfo"] = netStreamValue:ReadString()
	result["acContent"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_ChooseScriptAchieve(netStreamValue)
	local result = { ["iNum"] = 0,["akChooseAchieveRewardID"] = nil,} 
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

function Decode_SeCGA_GetScriptAchieveReward(netStreamValue)
	local result = { ["iNum"] = 0,["auiRewardID"] = nil,} 
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["auiRewardID"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["auiRewardID"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeCGA_MeridiansOpr(netStreamValue)
	local result = { ["eOprType"] = SMOT_NULL,["iNum"] = 0,["akMeridiansInfo"] = nil,} 
	result["eOprType"] = netStreamValue:ReadInt()
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

function Decode_SeCGA_MartialInCompleteTextOpr(netStreamValue)
	local result = { ["iOprType"] = 0,["dwMartialID"] = 0,} 
	result["iOprType"] = netStreamValue:ReadByte()
	result["dwMartialID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_MailOpr(netStreamValue)
	local result = { ["eOprType"] = SMAOT_NULL,["playerName"] = nil,["iNum"] = 0,["adwlMailID"] = 0,} 
	result["eOprType"] = netStreamValue:ReadInt()
	result["playerName"] = netStreamValue:ReadString()
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["adwlMailID"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["adwlMailID"][i] = netStreamValue:ReadDword64()
	end
	return result
end

function Decode_SeCGA_FriendInfoOpr(netStreamValue)
	local result = { ["eOprType"] = FROT_NULL,["iNum"] = 0,["adefFriendID"] = 0,} 
	result["eOprType"] = netStreamValue:ReadInt()
	result["iNum"] = netStreamValue:ReadInt()
	local iNum = result["iNum"]
		result["adefFriendID"] = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		result["adefFriendID"][i] = netStreamValue:ReadDword64()
	end
	return result
end

function Decode_SeCGA_ModifyPlayerAppearance(netStreamValue)
	local result = { ["eModifyType"] = SMPAT_NULL,["acChangeParam"] = nil,} 
	result["eModifyType"] = netStreamValue:ReadInt()
	result["acChangeParam"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_TLogUpdate(netStreamValue)
	local result = { ["eTLogNameType"] = STLNT_Null,["acTLogContent"] = nil,} 
	result["eTLogNameType"] = netStreamValue:ReadInt()
	result["acTLogContent"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_PublicChat(netStreamValue)
	local result = { ["eChannelType"] = SPCCT_NULL,["acContent"] = nil,["kTalkInfo"] = nil,} 
	result["eChannelType"] = netStreamValue:ReadInt()
	result["acContent"] = netStreamValue:ReadString()
	result["kTalkInfo"] = {["defPlyID"] = 0,["acSessionID"] = nil,["acOpenID"] = nil,["acVOpenID"] = nil,}
		result["kTalkInfo"]["defPlyID"] = netStreamValue:ReadDword64()
		result["kTalkInfo"]["acSessionID"] = netStreamValue:ReadString()
		result["kTalkInfo"]["acOpenID"] = netStreamValue:ReadString()
		result["kTalkInfo"]["acVOpenID"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_WordFilter(netStreamValue)
	local result = { ["eFilterType"] = STWFT_NULL,["dwParam"] = 0,["acContent"] = nil,} 
	result["eFilterType"] = netStreamValue:ReadInt()
	result["dwParam"] = netStreamValue:ReadInt()
	result["acContent"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_QueryClanCollectionInfo(netStreamValue)
	local result = { ["eQueryType"] = SCCQT_NULL,["dwClanTypeID"] = 0,} 
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwClanTypeID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_PlatPlayerSimpleInfos(netStreamValue)
	local result = { ["eOptType"] = PSIOT_NULL,["dwPageID"] = 0,["dwCount"] = 0,} 
	result["eOptType"] = netStreamValue:ReadInt()
	result["dwPageID"] = netStreamValue:ReadInt()
	result["dwCount"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_PlatPlayerDetailInfo(netStreamValue)
	local result = { ["defPlyID"] = 0,} 
	result["defPlyID"] = netStreamValue:ReadDword64()
	return result
end

function Decode_SeCGA_QueryTreasureBookInfo(netStreamValue)
	local result = { ["eQueryType"] = STBQT_NULL,["dwParam1"] = 0,["dwParam2"] = 0,["acOpenID"] = nil,["acVOpenID"] = nil,} 
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwParam1"] = netStreamValue:ReadDword64()
	result["dwParam2"] = netStreamValue:ReadInt()
	result["acOpenID"] = netStreamValue:ReadString()
	result["acVOpenID"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_QueryHoodleLotteryInfo(netStreamValue)
	local result = { ["eQueryType"] = SHLQT_NULL,["ePoolType"] = SHLPLT_NULL,["bSpecialHoodle"] = false,["dwCurPoolID"] = 0,} 
	result["eQueryType"] = netStreamValue:ReadInt()
	result["ePoolType"] = netStreamValue:ReadInt()
	result["bSpecialHoodle"] = netStreamValue:ReadByte()
	result["dwCurPoolID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_SetCharPictureUrl(netStreamValue)
	local result = { ["charPicUrl"] = nil,} 
	result["charPicUrl"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_QueryPlatTeamInfo(netStreamValue)
	local result = { ["eQueryType"] = SPTQT_NULL,["dwScriptID"] = 0,} 
	result["eQueryType"] = netStreamValue:ReadInt()
	result["dwScriptID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_CopyTeamInfo(netStreamValue)
	local result = { ["dwScriptID"] = 0,} 
	result["dwScriptID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_PlatEmbattle(netStreamValue)
	local result = { ["bPet"] = true,["iNum"] = nil,["akRoleEmbattle"] = nil,} 
	result["bPet"] = netStreamValue:ReadByte()
	result["iNum"] = netStreamValue:ReadByte()
	result["akRoleEmbattle"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
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

function Decode_SeCGA_RequestArenaMatchOperate(netStreamValue)
	local result = { ["iSize"] = 0,["akCmdData"] = nil,} 
	result["iSize"] = netStreamValue:ReadInt()
	result["akCmdData"] = {}
		local iSize = result["iSize"]
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local tempakCmdData = { ["eRequestType"] = ARENA_REQUEST_NULL,["uiMatchType"] = 0,["uiMatchID"] = 0,["uiRoundID"] = 0,["uiBattleID"] = 0,["kPlayerID"] = 0,["iUploadFlag"] = 0,} 
		tempakCmdData["eRequestType"] = netStreamValue:ReadInt()
		tempakCmdData["uiMatchType"] = netStreamValue:ReadInt()
		tempakCmdData["uiMatchID"] = netStreamValue:ReadInt()
		tempakCmdData["uiRoundID"] = netStreamValue:ReadInt()
		tempakCmdData["uiBattleID"] = netStreamValue:ReadInt()
		tempakCmdData["kPlayerID"] = netStreamValue:ReadDword64()
		tempakCmdData["iUploadFlag"] = netStreamValue:ReadByte()
		result["akCmdData"][i] = tempakCmdData
	end
	return result
end

function Decode_SeCGA_RequestArenaMatchBet(netStreamValue)
	local result = { ["uiMatchType"] = 0,["uiMatchID"] = 0,["uiBattleID"] = 0,["uiRoundID"] = 0,["defBetPlyID"] = 0,["uiMoney"] = 0,["acPlayerName"] = nil,} 
	result["uiMatchType"] = netStreamValue:ReadInt()
	result["uiMatchID"] = netStreamValue:ReadInt()
	result["uiBattleID"] = netStreamValue:ReadInt()
	result["uiRoundID"] = netStreamValue:ReadInt()
	result["defBetPlyID"] = netStreamValue:ReadDword64()
	result["uiMoney"] = netStreamValue:ReadInt()
	result["acPlayerName"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_SetMainRole(netStreamValue)
	local result = { ["uiRoleID"] = 0,} 
	result["uiRoleID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_ObservePlatRole(netStreamValue)
	local result = { ["defTarPlyID"] = 0,} 
	result["defTarPlyID"] = netStreamValue:ReadDword64()
	return result
end

function Decode_SeCGA_ChallengePlatRole(netStreamValue)
	local result = { ["defTarPlyID"] = 0,["otherFlag"] = 0,} 
	result["defTarPlyID"] = netStreamValue:ReadDword64()
	result["otherFlag"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_GiveUpChallengePlatRole(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_RequestRolePetCardOperate(netStreamValue)
	local result = { ["uiReqType"] = 0,["uiOptType"] = 0,["uiReqPara1"] = 0,["uiReqPara2"] = 0,} 
	result["uiReqType"] = netStreamValue:ReadByte()
	result["uiOptType"] = netStreamValue:ReadByte()
	result["uiReqPara1"] = netStreamValue:ReadInt()
	result["uiReqPara2"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_PlatShopMallReward(netStreamValue)
	local result = { ["eType"] = PSMRT_NULL,} 
	result["eType"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_PlatItemToScriptDilatation(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_PlatShopMallQueryItem(netStreamValue)
	local result = { ["uiType"] = 0,} 
	result["uiType"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_PlatShopMallBuyItem(netStreamValue)
	local result = { ["uiShopID"] = 0,["uiPileCount"] = 0,} 
	result["uiShopID"] = netStreamValue:ReadInt()
	result["uiPileCount"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_UnlockChallengeOrder(netStreamValue)
	local result = { ["eType"] = COT_FREE,} 
	result["eType"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_Day3SingIn(netStreamValue)
	local result = { ["eOpt"] = D3SOT_NULL,["uiBaseID"] = 0,} 
	result["eOpt"] = netStreamValue:ReadInt()
	result["uiBaseID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_ExChangeGoldToSilver(netStreamValue)
	local result = { ["uiValue"] = 0,} 
	result["uiValue"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_CheckTencentAntiAddiction(netStreamValue)
	local result = { ["acOpenID"] = nil,} 
	result["acOpenID"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_TssSDK(netStreamValue)
	local result = { ["kTssData"] = nil,} 
	result["kTssData"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_QueryHoodlePublicRecord(netStreamValue)
	local result = { ["iCurPage"] = 1,} 
	result["iCurPage"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_QueryHoodlePublicInfo(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_BuyHoodleShopItem(netStreamValue)
	local result = { ["iSelectIndex"] = 1,["iSelectID"] = 0,} 
	result["iSelectIndex"] = netStreamValue:ReadInt()
	result["iSelectID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_QueryPlayerGold(netStreamValue)
	local result = { ["bCharge"] = 0,} 
	result["bCharge"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_RequestPlayerInSameScript(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_ReportCheatPlayer(netStreamValue)
	local result = { ["kClientReportInfo"] = nil,} 
	result["kClientReportInfo"] = {["defReportPlayerID"] = 0,["acReportType"] = nil,["acReportDesc"] = nil,["acReportContent"] = nil,["dwReportScene"] = 0,["dwReportEntrance"] = 1,["acPicUrl"] = nil,}
		result["kClientReportInfo"]["defReportPlayerID"] = netStreamValue:ReadDword64()
		result["kClientReportInfo"]["acReportType"] = netStreamValue:ReadString()
		result["kClientReportInfo"]["acReportDesc"] = netStreamValue:ReadString()
		result["kClientReportInfo"]["acReportContent"] = netStreamValue:ReadString()
		result["kClientReportInfo"]["dwReportScene"] = netStreamValue:ReadInt()
		result["kClientReportInfo"]["dwReportEntrance"] = netStreamValue:ReadInt()
		result["kClientReportInfo"]["acPicUrl"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_addFriendReq(netStreamValue)
	local result = { ["friendID"] = 0,["acOpenID"] = nil,["acVOpenID"] = nil,} 
	result["friendID"] = netStreamValue:ReadDword64()
	result["acOpenID"] = netStreamValue:ReadString()
	result["acVOpenID"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_GetRedPacket(netStreamValue)
	local result = { ["playerName"] = nil,["redPacketUID"] = nil,["token"] = nil,} 
	result["playerName"] = netStreamValue:ReadString()
	result["redPacketUID"] = netStreamValue:ReadString()
	result["token"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_QueryForBidInfo(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_RequestTencentCreditScore(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_RequestPrivateChatSceneLimit(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_LimitShopOpr(netStreamValue)
	local result = { ["eOprType"] = EN_LIMIT_SHOP_GET,["iType"] = 0,["iParams0"] = 0,["iParams1"] = 0,["iParams2"] = 0,["iParams3"] = 0,["acFreshCon"] = nil,} 
	result["eOprType"] = netStreamValue:ReadInt()
	result["iType"] = netStreamValue:ReadInt()
	result["iParams0"] = netStreamValue:ReadInt()
	result["iParams1"] = netStreamValue:ReadInt()
	result["iParams2"] = netStreamValue:ReadInt()
	result["iParams3"] = netStreamValue:ReadInt()
	result["acFreshCon"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCGA_RequestCollectionPoint(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_OperatorSignInFlag(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_BuySecondGold(netStreamValue)
	local result = { ["bShareSuccess"] = false,} 
	result["bShareSuccess"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeCGA_UpdateNoviceGuideFlag(netStreamValue)
	local result = { ["dwFlag"] = 0,} 
	result["dwFlag"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_QueryPublicJWT(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_RequestZmOperate(netStreamValue)
	local result = { ["enRequest"] = EN_ZM_REQUEST_NULL,["nRoomId"] = 0,["iParams0"] = 0,["iParams1"] = 0,["iParams2"] = 0,["iParams3"] = 0,["defTagetId"] = 0,} 
	result["enRequest"] = netStreamValue:ReadInt()
	result["nRoomId"] = netStreamValue:ReadDword64()
	result["iParams0"] = netStreamValue:ReadInt()
	result["iParams1"] = netStreamValue:ReadInt()
	result["iParams2"] = netStreamValue:ReadInt()
	result["iParams3"] = netStreamValue:ReadInt()
	result["defTagetId"] = netStreamValue:ReadDword64()
	return result
end

function Decode_SeCGA_RequestZmBattleCard(netStreamValue)
	local result = { ["nRoomId"] = 0,["iNum"] = 0,["akZmCardBattle"] = nil,} 
	result["nRoomId"] = netStreamValue:ReadDword64()
	result["iNum"] = netStreamValue:ReadInt()
	result["akZmCardBattle"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakZmCardBattle = { ["dwId"] = 0,["dwBattleIndex"] = 0,["wX"] = 0,["wY"] = 0,} 
		tempakZmCardBattle["dwId"] = netStreamValue:ReadInt()
		tempakZmCardBattle["dwBattleIndex"] = netStreamValue:ReadInt()
		tempakZmCardBattle["wX"] = netStreamValue:ReadShort()
		tempakZmCardBattle["wY"] = netStreamValue:ReadShort()
		result["akZmCardBattle"][i] = tempakZmCardBattle
	end
	return result
end

function Decode_SeCGA_RequestGetDailyReward(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_UnlockStory(netStreamValue)
	local result = { ["dwStoryID"] = 0,} 
	result["dwStoryID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_QuerySectInfo(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_SectBuildingUpgrade(netStreamValue)
	local result = { ["dwBuidlingID"] = 0,} 
	result["dwBuidlingID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_SectBuildingSave(netStreamValue)
	local result = { ["iNum"] = 0,["akSectBuildingPos"] = nil,} 
	result["iNum"] = netStreamValue:ReadInt()
	result["akSectBuildingPos"] = {}
		local iNum = result["iNum"]
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local tempakSectBuildingPos = { ["dwBuildingID"] = 0,["dwBuildingPos"] = 0,["dwPreBuildingID"] = 0,} 
		tempakSectBuildingPos["dwBuildingID"] = netStreamValue:ReadInt()
		tempakSectBuildingPos["dwBuildingPos"] = netStreamValue:ReadInt()
		tempakSectBuildingPos["dwPreBuildingID"] = netStreamValue:ReadInt()
		result["akSectBuildingPos"][i] = tempakSectBuildingPos
	end
	return result
end

function Decode_SeCGA_SectBuildingName(netStreamValue)
	local result = { ["dwBuidlingID"] = 0,["acName"] = nil,["dwBackground"] = 0,} 
	result["dwBuidlingID"] = netStreamValue:ReadInt()
	result["acName"] = netStreamValue:ReadString()
	result["dwBackground"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_SectDisciplePut(netStreamValue)
	local result = { ["dwDiscipleID"] = 0,["dwBuildingID"] = 0,} 
	result["dwDiscipleID"] = netStreamValue:ReadInt()
	result["dwBuildingID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_SectMaterialGet(netStreamValue)
	local result = { ["dwBuildingID"] = 0,} 
	result["dwBuildingID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_ActivityEvent(netStreamValue)
	local result = { ["eOprType"] = nil,["iActivityBaseID"] = 0,["iParam1"] = 0,["iParam2"] = 0,["iParam3"] = 0,["dwActivityCount"] = 0,["adwActivityIDs"] = nil,} 
	result["eOprType"] = netStreamValue:ReadInt()
	result["iActivityBaseID"] = netStreamValue:ReadInt()
	result["iParam1"] = netStreamValue:ReadInt()
	result["iParam2"] = netStreamValue:ReadInt()
	result["iParam3"] = netStreamValue:ReadInt()
	result["dwActivityCount"] = netStreamValue:ReadInt()
	local dwActivityCount = result["dwActivityCount"]
		result["adwActivityIDs"] = {}
	for i = 0,dwActivityCount or -1 do
		if i >= dwActivityCount then
			break
		end
		result["adwActivityIDs"][i] = netStreamValue:ReadInt()
	end
	return result
end

function Decode_SeCGA_QueryStoryWeekLimit(netStreamValue)
	local result = { ["dwStoryID"] = 0,} 
	result["dwStoryID"] = netStreamValue:ReadInt()
	return result
end

function Decode_SeCGA_StopEnterStory(netStreamValue)
	local result = { } 
	return result
end

function Decode_SeCGA_SyncNewBirdGuideState(netStreamValue)
	local result = { ["dwCurState"] = 0,["bSet"] = true,} 
	result["dwCurState"] = netStreamValue:ReadInt()
	result["bSet"] = netStreamValue:ReadByte()
	return result
end

function Decode_SeCGA_RequestSaveFileOpt(netStreamValue)
	local result = { ["eOptType"] = SSFRT_NEW_FILE,["acFileName"] = nil,["bOpenSaveFile"] = true,} 
	result["eOptType"] = netStreamValue:ReadInt()
	result["acFileName"] = netStreamValue:ReadString()
	result["bOpenSaveFile"] = netStreamValue:ReadByte()
	return result
end

