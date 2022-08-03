-- auto make by Tool ProtocolMaker don't modify anything!!!
function EncodeSendSeCGA_PlayerValidate(dwMSangoMagic,defPlayerID,dwSessionId,dwVersion,acToken,kSystemInfo,bReconnect)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlayerValidate'
		g_encodeCache['dwMSangoMagic'] = dwMSangoMagic
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['dwSessionId'] = dwSessionId
		g_encodeCache['dwVersion'] = dwVersion
		g_encodeCache['acToken'] = acToken
		g_encodeCache['kSystemInfo'] = kSystemInfo
		g_encodeCache['bReconnect'] = bReconnect
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwMSangoMagic)
	kNetStream:WriteDword64(defPlayerID)
	kNetStream:WriteInt(dwSessionId)
	kNetStream:WriteInt(dwVersion)
	kNetStream:WriteString(acToken)
	kNetStream:WriteString(kSystemInfo["acClientVersion"])
	kNetStream:WriteString(kSystemInfo["acSystemSoftware"])
	kNetStream:WriteString(kSystemInfo["acSystemHardware"])
	kNetStream:WriteString(kSystemInfo["acTelecomOper"])
	kNetStream:WriteInt(kSystemInfo["iScreenWidth"])
	kNetStream:WriteInt(kSystemInfo["iScreenHight"])
	kNetStream:WriteString(kSystemInfo["acNetwork"])
	kNetStream:WriteString(kSystemInfo["acDensity"])
	kNetStream:WriteInt(kSystemInfo["iRegChannel"])
	kNetStream:WriteString(kSystemInfo["acCpuHardware"])
	kNetStream:WriteInt(kSystemInfo["iMemory"])
	kNetStream:WriteString(kSystemInfo["acGLRender"])
	kNetStream:WriteString(kSystemInfo["acGLVersion"])
	kNetStream:WriteString(kSystemInfo["acDeviceId"])
	kNetStream:WriteString(kSystemInfo["acAndroidId"])
	kNetStream:WriteString(kSystemInfo["acRealIMEI"])
	kNetStream:WriteString(kSystemInfo["acIdfv"])
	kNetStream:WriteInt(kSystemInfo["dwPlatID"])
	kNetStream:WriteInt(kSystemInfo["iTssSDKLen"])
	kNetStream:WriteString(kSystemInfo["acSecTssSDK"])
	kNetStream:WriteString(kSystemInfo["acVOpenID"])
	kNetStream:WriteString(kSystemInfo["acGOpenId"])
	kNetStream:WriteInt(kSystemInfo["iClientLoginMethod"])
	kNetStream:WriteInt(kSystemInfo["iTencentPrivate"])
	kNetStream:WriteString(kSystemInfo["acPF"])
	kNetStream:WriteString(kSystemInfo["acPFKey"])
	kNetStream:WriteString(kSystemInfo["acOpenKey"])
	kNetStream:WriteByte(kSystemInfo["isGuest"])
	kNetStream:WriteByte(kSystemInfo["dwOS"])
	kNetStream:WriteString(kSystemInfo["iLoginChannel"])
	kNetStream:WriteByte(bReconnect)
	return kNetStream,2089
end

function EncodeSendSeCGA_HeartBeat()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_HeartBeat'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2066
end

function EncodeSendSeCGA_GameCmd(eType,iSize,acData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_GameCmd'
		g_encodeCache['eType'] = eType
		g_encodeCache['iSize'] = iSize
		g_encodeCache['acData'] = acData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eType)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteChar(acData[i])
	end
	return kNetStream,2105
end

function EncodeSendSeCGA_ScriptOpr(eOprType,dwScriptID,bUseLucky)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ScriptOpr'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['bUseLucky'] = bUseLucky
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteByte(bUseLucky)
	return kNetStream,2097
end

function EncodeSendSeCGA_PlayerCheat(defOprPlayerID,dwScriptID,kPlayerCheat)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlayerCheat'
		g_encodeCache['defOprPlayerID'] = defOprPlayerID
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['kPlayerCheat'] = kPlayerCheat
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(defOprPlayerID)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteString(kPlayerCheat["acParam"])
	return kNetStream,2142
end

function EncodeSendSeCGA_PlatItemOpr(eOprType,iNum,akOprItem,iChooseNum,adwChooseGift)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatItemOpr'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akOprItem'] = akOprItem
		g_encodeCache['iChooseNum'] = iChooseNum
		g_encodeCache['adwChooseGift'] = adwChooseGift
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akOprItem[i]["uiItemID"])
		kNetStream:WriteInt(akOprItem[i]["uiItemNum"])
	end
	kNetStream:WriteInt(iChooseNum)
	for i = 0,iChooseNum or -1 do
		if i >= iChooseNum then
			break
		end
		kNetStream:WriteInt(adwChooseGift[i])
	end
	return kNetStream,2114
end

function EncodeSendSeCGA_ChooseScriptDiff(dwChooseDiff)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ChooseScriptDiff'
		g_encodeCache['dwChooseDiff'] = dwChooseDiff
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwChooseDiff)
	return kNetStream,2118
end

function EncodeSendSeCGA_UserSuggestion(acErrorInfo,acContent)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_UserSuggestion'
		g_encodeCache['acErrorInfo'] = acErrorInfo
		g_encodeCache['acContent'] = acContent
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(acErrorInfo)
	kNetStream:WriteString(acContent)
	return kNetStream,2049
end

function EncodeSendSeCGA_ChooseScriptAchieve(iNum,akChooseAchieveRewardID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ChooseScriptAchieve'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akChooseAchieveRewardID'] = akChooseAchieveRewardID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akChooseAchieveRewardID[i])
	end
	return kNetStream,2117
end

function EncodeSendSeCGA_GetScriptAchieveReward(iNum,auiRewardID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_GetScriptAchieveReward'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['auiRewardID'] = auiRewardID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(auiRewardID[i])
	end
	return kNetStream,2087
end

function EncodeSendSeCGA_MeridiansOpr(eOprType,iNum,akMeridiansInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_MeridiansOpr'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMeridiansInfo'] = akMeridiansInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMeridiansInfo[i]["dwMeridianID"])
		kNetStream:WriteInt(akMeridiansInfo[i]["dwAcupointID"])
		kNetStream:WriteInt(akMeridiansInfo[i]["dwLevel"])
	end
	return kNetStream,2065
end

function EncodeSendSeCGA_MartialInCompleteTextOpr(iOprType,dwMartialID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_MartialInCompleteTextOpr'
		g_encodeCache['iOprType'] = iOprType
		g_encodeCache['dwMartialID'] = dwMartialID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iOprType)
	kNetStream:WriteInt(dwMartialID)
	return kNetStream,2090
end

function EncodeSendSeCGA_MailOpr(eOprType,playerName,iNum,adwlMailID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_MailOpr'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['playerName'] = playerName
		g_encodeCache['iNum'] = iNum
		g_encodeCache['adwlMailID'] = adwlMailID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteString(playerName)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteDword64(adwlMailID[i])
	end
	return kNetStream,2060
end

function EncodeSendSeCGA_FriendInfoOpr(eOprType,iNum,adefFriendID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_FriendInfoOpr'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['adefFriendID'] = adefFriendID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteDword64(adefFriendID[i])
	end
	return kNetStream,2137
end

function EncodeSendSeCGA_ModifyPlayerAppearance(eModifyType,acChangeParam)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ModifyPlayerAppearance'
		g_encodeCache['eModifyType'] = eModifyType
		g_encodeCache['acChangeParam'] = acChangeParam
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eModifyType)
	kNetStream:WriteString(acChangeParam)
	return kNetStream,2102
end

function EncodeSendSeCGA_TLogUpdate(eTLogNameType,acTLogContent)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_TLogUpdate'
		g_encodeCache['eTLogNameType'] = eTLogNameType
		g_encodeCache['acTLogContent'] = acTLogContent
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eTLogNameType)
	kNetStream:WriteString(acTLogContent)
	return kNetStream,2113
end

function EncodeSendSeCGA_PublicChat(eChannelType,acContent,kTalkInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PublicChat'
		g_encodeCache['eChannelType'] = eChannelType
		g_encodeCache['acContent'] = acContent
		g_encodeCache['kTalkInfo'] = kTalkInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eChannelType)
	kNetStream:WriteString(acContent)
	kNetStream:WriteDword64(kTalkInfo["defPlyID"])
	kNetStream:WriteString(kTalkInfo["acSessionID"])
	kNetStream:WriteString(kTalkInfo["acOpenID"])
	kNetStream:WriteString(kTalkInfo["acVOpenID"])
	return kNetStream,2129
end

function EncodeSendSeCGA_WordFilter(eFilterType,dwParam,acContent)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_WordFilter'
		g_encodeCache['eFilterType'] = eFilterType
		g_encodeCache['dwParam'] = dwParam
		g_encodeCache['acContent'] = acContent
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eFilterType)
	kNetStream:WriteInt(dwParam)
	kNetStream:WriteString(acContent)
	return kNetStream,2064
end

function EncodeSendSeCGA_QueryClanCollectionInfo(eQueryType,dwClanTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryClanCollectionInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwClanTypeID'] = dwClanTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwClanTypeID)
	return kNetStream,2111
end

function EncodeSendSeCGA_PlatPlayerSimpleInfos(eOptType,dwPageID,dwCount)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatPlayerSimpleInfos'
		g_encodeCache['eOptType'] = eOptType
		g_encodeCache['dwPageID'] = dwPageID
		g_encodeCache['dwCount'] = dwCount
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOptType)
	kNetStream:WriteInt(dwPageID)
	kNetStream:WriteInt(dwCount)
	return kNetStream,2119
end

function EncodeSendSeCGA_PlatPlayerDetailInfo(defPlyID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatPlayerDetailInfo'
		g_encodeCache['defPlyID'] = defPlyID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(defPlyID)
	return kNetStream,2134
end

function EncodeSendSeCGA_QueryTreasureBookInfo(eQueryType,dwParam1,dwParam2,acOpenID,acVOpenID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryTreasureBookInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwParam1'] = dwParam1
		g_encodeCache['dwParam2'] = dwParam2
		g_encodeCache['acOpenID'] = acOpenID
		g_encodeCache['acVOpenID'] = acVOpenID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteDword64(dwParam1)
	kNetStream:WriteInt(dwParam2)
	kNetStream:WriteString(acOpenID)
	kNetStream:WriteString(acVOpenID)
	return kNetStream,2054
end

function EncodeSendSeCGA_QueryHoodleLotteryInfo(eQueryType,ePoolType,bSpecialHoodle,dwCurPoolID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryHoodleLotteryInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['ePoolType'] = ePoolType
		g_encodeCache['bSpecialHoodle'] = bSpecialHoodle
		g_encodeCache['dwCurPoolID'] = dwCurPoolID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(ePoolType)
	kNetStream:WriteByte(bSpecialHoodle)
	kNetStream:WriteInt(dwCurPoolID)
	return kNetStream,2075
end

function EncodeSendSeCGA_SetCharPictureUrl(charPicUrl)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SetCharPictureUrl'
		g_encodeCache['charPicUrl'] = charPicUrl
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(charPicUrl)
	return kNetStream,2082
end

function EncodeSendSeCGA_QueryPlatTeamInfo(eQueryType,dwScriptID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryPlatTeamInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	return kNetStream,2051
end

function EncodeSendSeCGA_CopyTeamInfo(dwScriptID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_CopyTeamInfo'
		g_encodeCache['dwScriptID'] = dwScriptID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwScriptID)
	return kNetStream,2068
end

function EncodeSendSeCGA_PlatEmbattle(bPet,iNum,akRoleEmbattle)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatEmbattle'
		g_encodeCache['bPet'] = bPet
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRoleEmbattle'] = akRoleEmbattle
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bPet)
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRoleEmbattle[i]["uiRoleID"])
		kNetStream:WriteByte(akRoleEmbattle[i]["iID"])
		kNetStream:WriteByte(akRoleEmbattle[i]["iRound"])
		kNetStream:WriteByte(akRoleEmbattle[i]["iGridX"])
		kNetStream:WriteByte(akRoleEmbattle[i]["iGridY"])
		kNetStream:WriteInt(akRoleEmbattle[i]["eFlag"])
		kNetStream:WriteByte(akRoleEmbattle[i]["bPet"])
		kNetStream:WriteInt(akRoleEmbattle[i]["uiFlag"])
	end
	return kNetStream,2083
end

function EncodeSendSeCGA_RequestArenaMatchOperate(iSize,akCmdData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestArenaMatchOperate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akCmdData'] = akCmdData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(akCmdData[i]["eRequestType"])
		kNetStream:WriteInt(akCmdData[i]["uiMatchType"])
		kNetStream:WriteInt(akCmdData[i]["uiMatchID"])
		kNetStream:WriteInt(akCmdData[i]["uiRoundID"])
		kNetStream:WriteInt(akCmdData[i]["uiBattleID"])
		kNetStream:WriteDword64(akCmdData[i]["kPlayerID"])
		kNetStream:WriteByte(akCmdData[i]["iUploadFlag"])
	end
	return kNetStream,2063
end

function EncodeSendSeCGA_RequestArenaMatchBet(uiMatchType,uiMatchID,uiBattleID,uiRoundID,defBetPlyID,uiMoney,acPlayerName)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestArenaMatchBet'
		g_encodeCache['uiMatchType'] = uiMatchType
		g_encodeCache['uiMatchID'] = uiMatchID
		g_encodeCache['uiBattleID'] = uiBattleID
		g_encodeCache['uiRoundID'] = uiRoundID
		g_encodeCache['defBetPlyID'] = defBetPlyID
		g_encodeCache['uiMoney'] = uiMoney
		g_encodeCache['acPlayerName'] = acPlayerName
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMatchType)
	kNetStream:WriteInt(uiMatchID)
	kNetStream:WriteInt(uiBattleID)
	kNetStream:WriteInt(uiRoundID)
	kNetStream:WriteDword64(defBetPlyID)
	kNetStream:WriteInt(uiMoney)
	kNetStream:WriteString(acPlayerName)
	return kNetStream,2092
end

function EncodeSendSeCGA_SetMainRole(uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SetMainRole'
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,2094
end

function EncodeSendSeCGA_ObservePlatRole(defTarPlyID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ObservePlatRole'
		g_encodeCache['defTarPlyID'] = defTarPlyID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(defTarPlyID)
	return kNetStream,2081
end

function EncodeSendSeCGA_ChallengePlatRole(defTarPlyID,otherFlag)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ChallengePlatRole'
		g_encodeCache['defTarPlyID'] = defTarPlyID
		g_encodeCache['otherFlag'] = otherFlag
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(defTarPlyID)
	kNetStream:WriteInt(otherFlag)
	return kNetStream,2078
end

function EncodeSendSeCGA_GiveUpChallengePlatRole()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_GiveUpChallengePlatRole'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2122
end

function EncodeSendSeCGA_RequestRolePetCardOperate(uiReqType,uiOptType,uiReqPara1,uiReqPara2)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestRolePetCardOperate'
		g_encodeCache['uiReqType'] = uiReqType
		g_encodeCache['uiOptType'] = uiOptType
		g_encodeCache['uiReqPara1'] = uiReqPara1
		g_encodeCache['uiReqPara2'] = uiReqPara2
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(uiReqType)
	kNetStream:WriteByte(uiOptType)
	kNetStream:WriteInt(uiReqPara1)
	kNetStream:WriteInt(uiReqPara2)
	return kNetStream,2136
end

function EncodeSendSeCGA_PlatShopMallReward(eType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatShopMallReward'
		g_encodeCache['eType'] = eType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eType)
	return kNetStream,2146
end

function EncodeSendSeCGA_PlatItemToScriptDilatation()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatItemToScriptDilatation'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2095
end

function EncodeSendSeCGA_PlatShopMallQueryItem(uiType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatShopMallQueryItem'
		g_encodeCache['uiType'] = uiType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiType)
	return kNetStream,2143
end

function EncodeSendSeCGA_PlatShopMallBuyItem(uiShopID,uiPileCount)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_PlatShopMallBuyItem'
		g_encodeCache['uiShopID'] = uiShopID
		g_encodeCache['uiPileCount'] = uiPileCount
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiShopID)
	kNetStream:WriteInt(uiPileCount)
	return kNetStream,2148
end

function EncodeSendSeCGA_UnlockChallengeOrder(eType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_UnlockChallengeOrder'
		g_encodeCache['eType'] = eType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eType)
	return kNetStream,2131
end

function EncodeSendSeCGA_Day3SingIn(eOpt,uiBaseID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_Day3SingIn'
		g_encodeCache['eOpt'] = eOpt
		g_encodeCache['uiBaseID'] = uiBaseID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOpt)
	kNetStream:WriteInt(uiBaseID)
	return kNetStream,2099
end

function EncodeSendSeCGA_ExChangeGoldToSilver(uiValue)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ExChangeGoldToSilver'
		g_encodeCache['uiValue'] = uiValue
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiValue)
	return kNetStream,2080
end

function EncodeSendSeCGA_CheckTencentAntiAddiction(acOpenID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_CheckTencentAntiAddiction'
		g_encodeCache['acOpenID'] = acOpenID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(acOpenID)
	return kNetStream,2126
end

function EncodeSendSeCGA_TssSDK(kTssData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_TssSDK'
		g_encodeCache['kTssData'] = kTssData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(kTssData)
	return kNetStream,2067
end

function EncodeSendSeCGA_QueryHoodlePublicRecord(iCurPage)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryHoodlePublicRecord'
		g_encodeCache['iCurPage'] = iCurPage
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iCurPage)
	return kNetStream,2100
end

function EncodeSendSeCGA_QueryHoodlePublicInfo()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryHoodlePublicInfo'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2115
end

function EncodeSendSeCGA_BuyHoodleShopItem(iSelectIndex,iSelectID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_BuyHoodleShopItem'
		g_encodeCache['iSelectIndex'] = iSelectIndex
		g_encodeCache['iSelectID'] = iSelectID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSelectIndex)
	kNetStream:WriteInt(iSelectID)
	return kNetStream,2061
end

function EncodeSendSeCGA_QueryPlayerGold(bCharge)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryPlayerGold'
		g_encodeCache['bCharge'] = bCharge
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(bCharge)
	return kNetStream,2147
end

function EncodeSendSeCGA_RequestPlayerInSameScript()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestPlayerInSameScript'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2052
end

function EncodeSendSeCGA_ReportCheatPlayer(kClientReportInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ReportCheatPlayer'
		g_encodeCache['kClientReportInfo'] = kClientReportInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(kClientReportInfo["defReportPlayerID"])
	kNetStream:WriteString(kClientReportInfo["acReportType"])
	kNetStream:WriteString(kClientReportInfo["acReportDesc"])
	kNetStream:WriteString(kClientReportInfo["acReportContent"])
	kNetStream:WriteInt(kClientReportInfo["dwReportScene"])
	kNetStream:WriteInt(kClientReportInfo["dwReportEntrance"])
	kNetStream:WriteString(kClientReportInfo["acPicUrl"])
	return kNetStream,2135
end

function EncodeSendSeCGA_addFriendReq(friendID,acOpenID,acVOpenID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_addFriendReq'
		g_encodeCache['friendID'] = friendID
		g_encodeCache['acOpenID'] = acOpenID
		g_encodeCache['acVOpenID'] = acVOpenID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(friendID)
	kNetStream:WriteString(acOpenID)
	kNetStream:WriteString(acVOpenID)
	return kNetStream,2109
end

function EncodeSendSeCGA_GetRedPacket(playerName,redPacketUID,token)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_GetRedPacket'
		g_encodeCache['playerName'] = playerName
		g_encodeCache['redPacketUID'] = redPacketUID
		g_encodeCache['token'] = token
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(playerName)
	kNetStream:WriteString(redPacketUID)
	kNetStream:WriteString(token)
	return kNetStream,2071
end

function EncodeSendSeCGA_QueryForBidInfo()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryForBidInfo'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2130
end

function EncodeSendSeCGA_RequestTencentCreditScore()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestTencentCreditScore'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2062
end

function EncodeSendSeCGA_RequestPrivateChatSceneLimit()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestPrivateChatSceneLimit'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2058
end

function EncodeSendSeCGA_LimitShopOpr(eOprType,iType,iParams0,iParams1,iParams2,iParams3,acFreshCon)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_LimitShopOpr'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['iType'] = iType
		g_encodeCache['iParams0'] = iParams0
		g_encodeCache['iParams1'] = iParams1
		g_encodeCache['iParams2'] = iParams2
		g_encodeCache['iParams3'] = iParams3
		g_encodeCache['acFreshCon'] = acFreshCon
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(iType)
	kNetStream:WriteInt(iParams0)
	kNetStream:WriteInt(iParams1)
	kNetStream:WriteInt(iParams2)
	kNetStream:WriteInt(iParams3)
	kNetStream:WriteString(acFreshCon)
	return kNetStream,2106
end

function EncodeSendSeCGA_RequestCollectionPoint()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestCollectionPoint'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2112
end

function EncodeSendSeCGA_OperatorSignInFlag()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_OperatorSignInFlag'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2056
end

function EncodeSendSeCGA_BuySecondGold(bShareSuccess)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_BuySecondGold'
		g_encodeCache['bShareSuccess'] = bShareSuccess
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bShareSuccess)
	return kNetStream,2098
end

function EncodeSendSeCGA_UpdateNoviceGuideFlag(dwFlag)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_UpdateNoviceGuideFlag'
		g_encodeCache['dwFlag'] = dwFlag
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwFlag)
	return kNetStream,2132
end

function EncodeSendSeCGA_QueryPublicJWT()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryPublicJWT'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2128
end

function EncodeSendSeCGA_RequestZmOperate(enRequest,nRoomId,iParams0,iParams1,iParams2,iParams3,defTagetId)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestZmOperate'
		g_encodeCache['enRequest'] = enRequest
		g_encodeCache['nRoomId'] = nRoomId
		g_encodeCache['iParams0'] = iParams0
		g_encodeCache['iParams1'] = iParams1
		g_encodeCache['iParams2'] = iParams2
		g_encodeCache['iParams3'] = iParams3
		g_encodeCache['defTagetId'] = defTagetId
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(enRequest)
	kNetStream:WriteDword64(nRoomId)
	kNetStream:WriteInt(iParams0)
	kNetStream:WriteInt(iParams1)
	kNetStream:WriteInt(iParams2)
	kNetStream:WriteInt(iParams3)
	kNetStream:WriteDword64(defTagetId)
	return kNetStream,2139
end

function EncodeSendSeCGA_RequestZmBattleCard(nRoomId,iNum,akZmCardBattle)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestZmBattleCard'
		g_encodeCache['nRoomId'] = nRoomId
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akZmCardBattle'] = akZmCardBattle
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(nRoomId)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akZmCardBattle[i]["dwId"])
		kNetStream:WriteInt(akZmCardBattle[i]["dwBattleIndex"])
		kNetStream:WriteShort(akZmCardBattle[i]["wX"])
		kNetStream:WriteShort(akZmCardBattle[i]["wY"])
	end
	return kNetStream,2074
end

function EncodeSendSeCGA_RequestGetDailyReward()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestGetDailyReward'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2124
end

function EncodeSendSeCGA_UnlockStory(dwStoryID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_UnlockStory'
		g_encodeCache['dwStoryID'] = dwStoryID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwStoryID)
	return kNetStream,2057
end

function EncodeSendSeCGA_QuerySectInfo()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QuerySectInfo'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2127
end

function EncodeSendSeCGA_SectBuildingUpgrade(dwBuidlingID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SectBuildingUpgrade'
		g_encodeCache['dwBuidlingID'] = dwBuidlingID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwBuidlingID)
	return kNetStream,2108
end

function EncodeSendSeCGA_SectBuildingSave(iNum,akSectBuildingPos)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SectBuildingSave'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akSectBuildingPos'] = akSectBuildingPos
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akSectBuildingPos[i]["dwBuildingID"])
		kNetStream:WriteInt(akSectBuildingPos[i]["dwBuildingPos"])
		kNetStream:WriteInt(akSectBuildingPos[i]["dwPreBuildingID"])
	end
	return kNetStream,2076
end

function EncodeSendSeCGA_SectBuildingName(dwBuidlingID,acName,dwBackground)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SectBuildingName'
		g_encodeCache['dwBuidlingID'] = dwBuidlingID
		g_encodeCache['acName'] = acName
		g_encodeCache['dwBackground'] = dwBackground
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwBuidlingID)
	kNetStream:WriteString(acName)
	kNetStream:WriteInt(dwBackground)
	return kNetStream,2085
end

function EncodeSendSeCGA_SectDisciplePut(dwDiscipleID,dwBuildingID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SectDisciplePut'
		g_encodeCache['dwDiscipleID'] = dwDiscipleID
		g_encodeCache['dwBuildingID'] = dwBuildingID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwDiscipleID)
	kNetStream:WriteInt(dwBuildingID)
	return kNetStream,2103
end

function EncodeSendSeCGA_SectMaterialGet(dwBuildingID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SectMaterialGet'
		g_encodeCache['dwBuildingID'] = dwBuildingID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwBuildingID)
	return kNetStream,2125
end

function EncodeSendSeCGA_ActivityEvent(eOprType,iActivityBaseID,iParam1,iParam2,iParam3,dwActivityCount,adwActivityIDs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_ActivityEvent'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['iActivityBaseID'] = iActivityBaseID
		g_encodeCache['iParam1'] = iParam1
		g_encodeCache['iParam2'] = iParam2
		g_encodeCache['iParam3'] = iParam3
		g_encodeCache['dwActivityCount'] = dwActivityCount
		g_encodeCache['adwActivityIDs'] = adwActivityIDs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(iActivityBaseID)
	kNetStream:WriteInt(iParam1)
	kNetStream:WriteInt(iParam2)
	kNetStream:WriteInt(iParam3)
	kNetStream:WriteInt(dwActivityCount)
	for i = 0,dwActivityCount or -1 do
		if i >= dwActivityCount then
			break
		end
		kNetStream:WriteInt(adwActivityIDs[i])
	end
	return kNetStream,2072
end

function EncodeSendSeCGA_QueryStoryWeekLimit(dwStoryID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_QueryStoryWeekLimit'
		g_encodeCache['dwStoryID'] = dwStoryID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwStoryID)
	return kNetStream,2104
end

function EncodeSendSeCGA_StopEnterStory()
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_StopEnterStory'
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	return kNetStream,2145
end

function EncodeSendSeCGA_SyncNewBirdGuideState(dwCurState,bSet)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_SyncNewBirdGuideState'
		g_encodeCache['dwCurState'] = dwCurState
		g_encodeCache['bSet'] = bSet
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwCurState)
	kNetStream:WriteByte(bSet)
	return kNetStream,2123
end

function EncodeSendSeCGA_RequestSaveFileOpt(eOptType,acFileName,bOpenSaveFile)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCGA_RequestSaveFileOpt'
		g_encodeCache['eOptType'] = eOptType
		g_encodeCache['acFileName'] = acFileName
		g_encodeCache['bOpenSaveFile'] = bOpenSaveFile
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOptType)
	kNetStream:WriteString(acFileName)
	kNetStream:WriteByte(bOpenSaveFile)
	return kNetStream,2086
end

