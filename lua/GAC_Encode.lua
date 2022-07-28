-- auto make by Tool ProtocolMaker don't modify anything!!!
function EncodeSendSeGAC_GameCmdRet(iSize,acData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_GameCmdRet'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['acData'] = acData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteChar(acData[i])
	end
	return kNetStream,32809
end

function EncodeSendSeGAC_EncryptKey(abyEncryptKey,dwVersion,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_EncryptKey'
		g_encodeCache['abyEncryptKey'] = abyEncryptKey
		g_encodeCache['dwVersion'] = dwVersion
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(abyEncryptKey)
	kNetStream:WriteInt(dwVersion)
	return kNetStream,32786
end

function EncodeSendSeGAC_ShowNotice(eNoticeCode,dwParam,dwParam2,dwParam3,acMessage,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ShowNotice'
		g_encodeCache['eNoticeCode'] = eNoticeCode
		g_encodeCache['dwParam'] = dwParam
		g_encodeCache['dwParam2'] = dwParam2
		g_encodeCache['dwParam3'] = dwParam3
		g_encodeCache['acMessage'] = acMessage
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eNoticeCode)
	kNetStream:WriteDword64(dwParam)
	kNetStream:WriteInt(dwParam2)
	kNetStream:WriteInt(dwParam3)
	kNetStream:WriteString(acMessage)
	return kNetStream,32825
end

function EncodeSendSeGAC_PlayerValidateRet(eValidateType,acVersionCode,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlayerValidateRet'
		g_encodeCache['eValidateType'] = eValidateType
		g_encodeCache['acVersionCode'] = acVersionCode
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eValidateType)
	kNetStream:WriteString(acVersionCode)
	return kNetStream,32817
end

function EncodeSendSeGAC_QueryNameRet(bHasExist,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryNameRet'
		g_encodeCache['bHasExist'] = bHasExist
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bHasExist)
	return kNetStream,32862
end

function EncodeSendSeGAC_CreateCharRet(eResult,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_CreateCharRet'
		g_encodeCache['eResult'] = eResult
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eResult)
	return kNetStream,32834
end

function EncodeSendSeGAC_PlayerLeaveRet(dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlayerLeaveRet'
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	return kNetStream,32838
end

function EncodeSendSeGAC_KickPlayer(dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_KickPlayer'
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	return kNetStream,32769
end

function EncodeSendSeGAC_ScriptOprRet(eOprType,dwScriptID,bOpr,kUnlockScriptInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ScriptOprRet'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['bOpr'] = bOpr
		g_encodeCache['kUnlockScriptInfo'] = kUnlockScriptInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(bOpr)
	kNetStream:WriteInt(kUnlockScriptInfo["dwScriptID"])
	kNetStream:WriteInt(kUnlockScriptInfo["dwScriptTime"])
	kNetStream:WriteString(kUnlockScriptInfo["acMainRoleName"])
	kNetStream:WriteInt(kUnlockScriptInfo["dwDreamLandTime"])
	kNetStream:WriteInt(kUnlockScriptInfo["eStateType"])
	kNetStream:WriteInt(kUnlockScriptInfo["dwUnlockMaxDiff"])
	kNetStream:WriteInt(kUnlockScriptInfo["dwWeekRoundNum"])
	kNetStream:WriteInt(kUnlockScriptInfo["dwScriptLucyValue"])
	kNetStream:WriteByte(kUnlockScriptInfo["bGotFirstReward"])
	return kNetStream,32837
end

function EncodeSendSeGAC_InitPlayerInfo(defPlayerID,dwGold,dwSilver,dwDrinkMoney,dwPlatScore,dwActiveScore,dwAreaID,dwChallengeOrderType,dwLoginDayNum,dwReNameNum,dwLuckyValue,dwSecondGold,kCommInfo,kFuncInfo,dwSign_in_flag,dwServerOpenTime,kAppearanceInfo,iSize,kUnlockScriptInfos,iGuideInfoSize,auiGuideInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_InitPlayerInfo'
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['dwGold'] = dwGold
		g_encodeCache['dwSilver'] = dwSilver
		g_encodeCache['dwDrinkMoney'] = dwDrinkMoney
		g_encodeCache['dwPlatScore'] = dwPlatScore
		g_encodeCache['dwActiveScore'] = dwActiveScore
		g_encodeCache['dwAreaID'] = dwAreaID
		g_encodeCache['dwChallengeOrderType'] = dwChallengeOrderType
		g_encodeCache['dwLoginDayNum'] = dwLoginDayNum
		g_encodeCache['dwReNameNum'] = dwReNameNum
		g_encodeCache['dwLuckyValue'] = dwLuckyValue
		g_encodeCache['dwSecondGold'] = dwSecondGold
		g_encodeCache['kCommInfo'] = kCommInfo
		g_encodeCache['kFuncInfo'] = kFuncInfo
		g_encodeCache['dwSign_in_flag'] = dwSign_in_flag
		g_encodeCache['dwServerOpenTime'] = dwServerOpenTime
		g_encodeCache['kAppearanceInfo'] = kAppearanceInfo
		g_encodeCache['iSize'] = iSize
		g_encodeCache['kUnlockScriptInfos'] = kUnlockScriptInfos
		g_encodeCache['iGuideInfoSize'] = iGuideInfoSize
		g_encodeCache['auiGuideInfo'] = auiGuideInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteDword64(defPlayerID)
	kNetStream:WriteInt(dwGold)
	kNetStream:WriteInt(dwSilver)
	kNetStream:WriteInt(dwDrinkMoney)
	kNetStream:WriteInt(dwPlatScore)
	kNetStream:WriteInt(dwActiveScore)
	kNetStream:WriteInt(dwAreaID)
	kNetStream:WriteInt(dwChallengeOrderType)
	kNetStream:WriteInt(dwLoginDayNum)
	kNetStream:WriteInt(dwReNameNum)
	kNetStream:WriteInt(dwLuckyValue)
	kNetStream:WriteInt(dwSecondGold)
	kNetStream:WriteString(kCommInfo["acPlayerName"])
	kNetStream:WriteString(kCommInfo["charPicUrl"])
	kNetStream:WriteInt(kCommInfo["dwModelID"])
	kNetStream:WriteInt(kCommInfo["dwSex"])
	kNetStream:WriteInt(kCommInfo["dwWeekRoundTotalNum"])
	kNetStream:WriteInt(kCommInfo["dwALiveDays"])
	kNetStream:WriteByte(kCommInfo["bUnlockHouse"])
	kNetStream:WriteInt(kCommInfo["dwAchievePoint"])
	kNetStream:WriteInt(kCommInfo["dwMeridiansLvl"])
	kNetStream:WriteInt(kCommInfo["dwCreateTime"])
	kNetStream:WriteInt(kCommInfo["dwLastLogoutTime"])
	kNetStream:WriteInt(kCommInfo["dwChallengeWinTimes"])
	kNetStream:WriteByte(kCommInfo["bRMBPlayer"])
	kNetStream:WriteInt(kCommInfo["dwTitleID"])
	kNetStream:WriteString(kCommInfo["acOpenID"])
	kNetStream:WriteString(kCommInfo["acVOpenID"])
	kNetStream:WriteString(kCommInfo["acIP"])
	kNetStream:WriteInt(kCommInfo["dwHoodleScore"])
	kNetStream:WriteInt(kCommInfo["dwNormalHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwBloodHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwRegimentHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwPlayerLastScriptID"])
	kNetStream:WriteInt(kCommInfo["dwNewBirdGuideState"])
	kNetStream:WriteInt(kFuncInfo["dwLowInCompleteTextNum"])
	kNetStream:WriteInt(kFuncInfo["dwMidInCompleteTextNum"])
	kNetStream:WriteInt(kFuncInfo["dwHighInCompleteTextNum"])
	kNetStream:WriteInt(kFuncInfo["dwMeridianTotalLvl"])
	kNetStream:WriteInt(kFuncInfo["dwAchieveTotalNum"])
	kNetStream:WriteInt(kFuncInfo["dwLuckyValue"])
	kNetStream:WriteInt(kFuncInfo["dwChallengeWinTimes"])
	kNetStream:WriteInt(kFuncInfo["dwJingTieNum"])
	kNetStream:WriteInt(kFuncInfo["dwTianGongChui"])
	kNetStream:WriteInt(kFuncInfo["dwPerfectFenNum"])
	kNetStream:WriteInt(kFuncInfo["dwWangYouCaoNum"])
	kNetStream:WriteInt(kFuncInfo["dwHoodleBallNum"])
	kNetStream:WriteInt(kFuncInfo["dwRefreshBallNum"])
	kNetStream:WriteInt(kFuncInfo["dwDilatationNum"])
	kNetStream:WriteInt(kFuncInfo["dwLimitShopBigmapAciton"])
	kNetStream:WriteInt(kFuncInfo["dwFreeGiveBigCoin"])
	kNetStream:WriteInt(kFuncInfo["dwShopGoldRewardTime"])
	kNetStream:WriteInt(kFuncInfo["dwShopAdRewardTime"])
	kNetStream:WriteInt(kFuncInfo["dwBondPelletNum"])
	kNetStream:WriteInt(kFuncInfo["dwDailyRewardState"])
	kNetStream:WriteInt(kFuncInfo["dwFundAchieveOpen"])
	kNetStream:WriteInt(kFuncInfo["dwRedPacketGetTimes"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue1"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue2"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue3"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue4"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue5"])
	kNetStream:WriteInt(kFuncInfo["dwCurResDropCollectActivity"])
	kNetStream:WriteInt(kFuncInfo["dwZmFreeTickets"])
	kNetStream:WriteInt(kFuncInfo["dwZmTickets"])
	kNetStream:WriteByte(kFuncInfo["bZmNewFlag"])
	kNetStream:WriteInt(kFuncInfo["dwTreaSureExchangeValue1"])
	kNetStream:WriteInt(kFuncInfo["dwTreaSureExchangeValue2"])
	kNetStream:WriteInt(kFuncInfo["dwFestivalValue1"])
	kNetStream:WriteInt(kFuncInfo["dwFestivalValue2"])
	kNetStream:WriteInt(kFuncInfo["dwTongLingYu"])
	kNetStream:WriteInt(dwSign_in_flag)
	kNetStream:WriteInt(dwServerOpenTime)
	kNetStream:WriteString(kAppearanceInfo["acPlayerName"])
	kNetStream:WriteInt(kAppearanceInfo["dwTitleID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPaintingID"])
	kNetStream:WriteInt(kAppearanceInfo["dwModelID"])
	kNetStream:WriteString(kAppearanceInfo["charPicUrl"])
	kNetStream:WriteInt(kAppearanceInfo["dwBackGroundID"])
	kNetStream:WriteInt(kAppearanceInfo["dwBGMID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPoetryID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPedestalID"])
	kNetStream:WriteInt(kAppearanceInfo["dwShowRoleID"])
	kNetStream:WriteInt(kAppearanceInfo["dwShowPetID"])
	kNetStream:WriteInt(kAppearanceInfo["dwLoginWordID"])
	kNetStream:WriteInt(kAppearanceInfo["dwHeadBoxID"])
	kNetStream:WriteInt(kAppearanceInfo["dwChatBoxID"])
	kNetStream:WriteInt(kAppearanceInfo["dwLandLadyID"])
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(kUnlockScriptInfos[i]["dwScriptID"])
		kNetStream:WriteInt(kUnlockScriptInfos[i]["dwScriptTime"])
		kNetStream:WriteString(kUnlockScriptInfos[i]["acMainRoleName"])
		kNetStream:WriteInt(kUnlockScriptInfos[i]["dwDreamLandTime"])
		kNetStream:WriteInt(kUnlockScriptInfos[i]["eStateType"])
		kNetStream:WriteInt(kUnlockScriptInfos[i]["dwUnlockMaxDiff"])
		kNetStream:WriteInt(kUnlockScriptInfos[i]["dwWeekRoundNum"])
		kNetStream:WriteInt(kUnlockScriptInfos[i]["dwScriptLucyValue"])
		kNetStream:WriteByte(kUnlockScriptInfos[i]["bGotFirstReward"])
	end
	kNetStream:WriteInt(iGuideInfoSize)
	for i = 0,iGuideInfoSize or -1 do
		if i >= iGuideInfoSize then
			break
		end
		kNetStream:WriteInt(auiGuideInfo[i])
	end
	return kNetStream,32807
end

function EncodeSendSeGAC_PlayerCommonInfoDataRet(kCommInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlayerCommonInfoDataRet'
		g_encodeCache['kCommInfo'] = kCommInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(kCommInfo["acPlayerName"])
	kNetStream:WriteString(kCommInfo["charPicUrl"])
	kNetStream:WriteInt(kCommInfo["dwModelID"])
	kNetStream:WriteInt(kCommInfo["dwSex"])
	kNetStream:WriteInt(kCommInfo["dwWeekRoundTotalNum"])
	kNetStream:WriteInt(kCommInfo["dwALiveDays"])
	kNetStream:WriteByte(kCommInfo["bUnlockHouse"])
	kNetStream:WriteInt(kCommInfo["dwAchievePoint"])
	kNetStream:WriteInt(kCommInfo["dwMeridiansLvl"])
	kNetStream:WriteInt(kCommInfo["dwCreateTime"])
	kNetStream:WriteInt(kCommInfo["dwLastLogoutTime"])
	kNetStream:WriteInt(kCommInfo["dwChallengeWinTimes"])
	kNetStream:WriteByte(kCommInfo["bRMBPlayer"])
	kNetStream:WriteInt(kCommInfo["dwTitleID"])
	kNetStream:WriteString(kCommInfo["acOpenID"])
	kNetStream:WriteString(kCommInfo["acVOpenID"])
	kNetStream:WriteString(kCommInfo["acIP"])
	kNetStream:WriteInt(kCommInfo["dwHoodleScore"])
	kNetStream:WriteInt(kCommInfo["dwNormalHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwBloodHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwRegimentHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwPlayerLastScriptID"])
	kNetStream:WriteInt(kCommInfo["dwNewBirdGuideState"])
	return kNetStream,32785
end

function EncodeSendSeGAC_PlayerFunctionInfoDataRet(kFuncInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlayerFunctionInfoDataRet'
		g_encodeCache['kFuncInfo'] = kFuncInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kFuncInfo["dwLowInCompleteTextNum"])
	kNetStream:WriteInt(kFuncInfo["dwMidInCompleteTextNum"])
	kNetStream:WriteInt(kFuncInfo["dwHighInCompleteTextNum"])
	kNetStream:WriteInt(kFuncInfo["dwMeridianTotalLvl"])
	kNetStream:WriteInt(kFuncInfo["dwAchieveTotalNum"])
	kNetStream:WriteInt(kFuncInfo["dwLuckyValue"])
	kNetStream:WriteInt(kFuncInfo["dwChallengeWinTimes"])
	kNetStream:WriteInt(kFuncInfo["dwJingTieNum"])
	kNetStream:WriteInt(kFuncInfo["dwTianGongChui"])
	kNetStream:WriteInt(kFuncInfo["dwPerfectFenNum"])
	kNetStream:WriteInt(kFuncInfo["dwWangYouCaoNum"])
	kNetStream:WriteInt(kFuncInfo["dwHoodleBallNum"])
	kNetStream:WriteInt(kFuncInfo["dwRefreshBallNum"])
	kNetStream:WriteInt(kFuncInfo["dwDilatationNum"])
	kNetStream:WriteInt(kFuncInfo["dwLimitShopBigmapAciton"])
	kNetStream:WriteInt(kFuncInfo["dwFreeGiveBigCoin"])
	kNetStream:WriteInt(kFuncInfo["dwShopGoldRewardTime"])
	kNetStream:WriteInt(kFuncInfo["dwShopAdRewardTime"])
	kNetStream:WriteInt(kFuncInfo["dwBondPelletNum"])
	kNetStream:WriteInt(kFuncInfo["dwDailyRewardState"])
	kNetStream:WriteInt(kFuncInfo["dwFundAchieveOpen"])
	kNetStream:WriteInt(kFuncInfo["dwRedPacketGetTimes"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue1"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue2"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue3"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue4"])
	kNetStream:WriteInt(kFuncInfo["dwResDropActivityFuncValue5"])
	kNetStream:WriteInt(kFuncInfo["dwCurResDropCollectActivity"])
	kNetStream:WriteInt(kFuncInfo["dwZmFreeTickets"])
	kNetStream:WriteInt(kFuncInfo["dwZmTickets"])
	kNetStream:WriteByte(kFuncInfo["bZmNewFlag"])
	kNetStream:WriteInt(kFuncInfo["dwTreaSureExchangeValue1"])
	kNetStream:WriteInt(kFuncInfo["dwTreaSureExchangeValue2"])
	kNetStream:WriteInt(kFuncInfo["dwFestivalValue1"])
	kNetStream:WriteInt(kFuncInfo["dwFestivalValue2"])
	kNetStream:WriteInt(kFuncInfo["dwTongLingYu"])
	return kNetStream,32810
end

function EncodeSendSeGAC_PlayerAppearanceInfoDataRet(kAppearanceInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlayerAppearanceInfoDataRet'
		g_encodeCache['kAppearanceInfo'] = kAppearanceInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(kAppearanceInfo["acPlayerName"])
	kNetStream:WriteInt(kAppearanceInfo["dwTitleID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPaintingID"])
	kNetStream:WriteInt(kAppearanceInfo["dwModelID"])
	kNetStream:WriteString(kAppearanceInfo["charPicUrl"])
	kNetStream:WriteInt(kAppearanceInfo["dwBackGroundID"])
	kNetStream:WriteInt(kAppearanceInfo["dwBGMID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPoetryID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPedestalID"])
	kNetStream:WriteInt(kAppearanceInfo["dwShowRoleID"])
	kNetStream:WriteInt(kAppearanceInfo["dwShowPetID"])
	kNetStream:WriteInt(kAppearanceInfo["dwLoginWordID"])
	kNetStream:WriteInt(kAppearanceInfo["dwHeadBoxID"])
	kNetStream:WriteInt(kAppearanceInfo["dwChatBoxID"])
	kNetStream:WriteInt(kAppearanceInfo["dwLandLadyID"])
	return kNetStream,32780
end

function EncodeSendSeGAC_HeartBeat(dwNowTimeStamp,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_HeartBeat'
		g_encodeCache['dwNowTimeStamp'] = dwNowTimeStamp
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwNowTimeStamp)
	return kNetStream,32857
end

function EncodeSendSeGAC_PlatItemOprRet(eOprType,bOpr,dwParam,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatItemOprRet'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['bOpr'] = bOpr
		g_encodeCache['dwParam'] = dwParam
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteByte(bOpr)
	kNetStream:WriteInt(dwParam)
	return kNetStream,32822
end

function EncodeSendSeGAC_AllPlatItemRet(iFlag,iNum,akPlatItem,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_AllPlatItemRet'
		g_encodeCache['iFlag'] = iFlag
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akPlatItem'] = akPlatItem
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iFlag)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akPlatItem[i]["iValueChangeFlag"])
		if akPlatItem[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akPlatItem[i]["uiID"])
		end
		if akPlatItem[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akPlatItem[i]["uiTypeID"])
		end
		if akPlatItem[i]["uiItemNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akPlatItem[i]["uiItemNum"])
		end
		if akPlatItem[i]["uiDueTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akPlatItem[i]["uiDueTime"])
		end
		if akPlatItem[i]["uiEnhanceGrade"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteShort(akPlatItem[i]["uiEnhanceGrade"])
		end
		if akPlatItem[i]["uiCoinRemainRecastTimes"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteShort(akPlatItem[i]["uiCoinRemainRecastTimes"])
		end
		if akPlatItem[i]["iAttrNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akPlatItem[i]["iAttrNum"])
		end
		for j = 0,iAttrNum or -1 do
		if j >= iAttrNum then
			break
		end
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["uiAttrUID"])
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["uiType"])
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["iBaseValue"])
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["iExtraValue"])
		kNetStream:WriteByte(akPlatItem[i]["auiAttrData"][j]["uiRecastType"])
	end
		if akPlatItem[i]["uiOwnerID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akPlatItem[i]["uiOwnerID"])
		end
		if akPlatItem[i]["bBelongToMainRole"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteByte(akPlatItem[i]["bBelongToMainRole"])
		end
		if akPlatItem[i]["uiSpendIron"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akPlatItem[i]["uiSpendIron"])
		end
		if akPlatItem[i]["uiPerfectPower"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akPlatItem[i]["uiPerfectPower"])
		end
		if akPlatItem[i]["uiSpendTongLingYu"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteInt(akPlatItem[i]["uiSpendTongLingYu"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akPlatItem[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,32833
end

function EncodeSendSeGAC_AllPlatItemEquipRet(iFlag,iNum,akPlatItem,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_AllPlatItemEquipRet'
		g_encodeCache['iFlag'] = iFlag
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akPlatItem'] = akPlatItem
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iFlag)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akPlatItem[i]["iValueChangeFlag"])
		if akPlatItem[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akPlatItem[i]["uiID"])
		end
		if akPlatItem[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akPlatItem[i]["uiTypeID"])
		end
		if akPlatItem[i]["uiItemNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akPlatItem[i]["uiItemNum"])
		end
		if akPlatItem[i]["uiDueTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akPlatItem[i]["uiDueTime"])
		end
		if akPlatItem[i]["uiEnhanceGrade"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteShort(akPlatItem[i]["uiEnhanceGrade"])
		end
		if akPlatItem[i]["uiCoinRemainRecastTimes"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteShort(akPlatItem[i]["uiCoinRemainRecastTimes"])
		end
		if akPlatItem[i]["iAttrNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akPlatItem[i]["iAttrNum"])
		end
		for j = 0,iAttrNum or -1 do
		if j >= iAttrNum then
			break
		end
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["uiAttrUID"])
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["uiType"])
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["iBaseValue"])
		kNetStream:WriteInt(akPlatItem[i]["auiAttrData"][j]["iExtraValue"])
		kNetStream:WriteByte(akPlatItem[i]["auiAttrData"][j]["uiRecastType"])
	end
		if akPlatItem[i]["uiOwnerID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akPlatItem[i]["uiOwnerID"])
		end
		if akPlatItem[i]["bBelongToMainRole"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteByte(akPlatItem[i]["bBelongToMainRole"])
		end
		if akPlatItem[i]["uiSpendIron"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akPlatItem[i]["uiSpendIron"])
		end
		if akPlatItem[i]["uiPerfectPower"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akPlatItem[i]["uiPerfectPower"])
		end
		if akPlatItem[i]["uiSpendTongLingYu"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteInt(akPlatItem[i]["uiSpendTongLingYu"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akPlatItem[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,32849
end

function EncodeSendSeGAC_SetCharPictureUrlRet(charPicUrl,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SetCharPictureUrlRet'
		g_encodeCache['charPicUrl'] = charPicUrl
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(charPicUrl)
	return kNetStream,32784
end

function EncodeSendSeGAC_UnlockAchievement(eNoticeType,iNum,akUnlockAchieve,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UnlockAchievement'
		g_encodeCache['eNoticeType'] = eNoticeType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akUnlockAchieve'] = akUnlockAchieve
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eNoticeType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akUnlockAchieve[i]["uiAchieveID"])
		kNetStream:WriteInt(akUnlockAchieve[i]["iCurNum"])
	end
	return kNetStream,32831
end

function EncodeSendSeGAC_UpdateAchieveSaveData(iFlag,iNum,akSaveData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateAchieveSaveData'
		g_encodeCache['iFlag'] = iFlag
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akSaveData'] = akSaveData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iFlag)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akSaveData[i]["uiAchieveID"])
		kNetStream:WriteInt(akSaveData[i]["iValue"])
		kNetStream:WriteShort(akSaveData[i]["iFetchReward"])
	end
	return kNetStream,32839
end

function EncodeSendSeGAC_UpdateAchieveRecordData(iNum,akRecordData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateAchieveRecordData'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRecordData'] = akRecordData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRecordData[i])
	end
	return kNetStream,32854
end

function EncodeSendSeGAC_UpdateDiffDropData(iNum,akSaveData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateDiffDropData'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akSaveData'] = akSaveData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akSaveData[i]["uiTypeID"])
		kNetStream:WriteShort(akSaveData[i]["uiAccumulateTime"])
		kNetStream:WriteInt(akSaveData[i]["uiRoundFinish"])
	end
	return kNetStream,32774
end

function EncodeSendSeGAC_ChooseScriptDiffRet(dwChooseDiff,bChooseRet,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ChooseScriptDiffRet'
		g_encodeCache['dwChooseDiff'] = dwChooseDiff
		g_encodeCache['bChooseRet'] = bChooseRet
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwChooseDiff)
	kNetStream:WriteByte(bChooseRet)
	return kNetStream,32795
end

function EncodeSendSeGAC_MeridiansOprRet(eOprType,bOver,bOpr,dwlCurTotalExp,dwWeekExp,dwWeekLimitNum,iNum,akMeridiansInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_MeridiansOprRet'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['bOver'] = bOver
		g_encodeCache['bOpr'] = bOpr
		g_encodeCache['dwlCurTotalExp'] = dwlCurTotalExp
		g_encodeCache['dwWeekExp'] = dwWeekExp
		g_encodeCache['dwWeekLimitNum'] = dwWeekLimitNum
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMeridiansInfo'] = akMeridiansInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteByte(bOver)
	kNetStream:WriteByte(bOpr)
	kNetStream:WriteDword64(dwlCurTotalExp)
	kNetStream:WriteInt(dwWeekExp)
	kNetStream:WriteInt(dwWeekLimitNum)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMeridiansInfo[i]["dwMeridianID"])
		kNetStream:WriteInt(akMeridiansInfo[i]["dwAcupointID"])
		kNetStream:WriteInt(akMeridiansInfo[i]["dwLevel"])
	end
	return kNetStream,32802
end

function EncodeSendSeGAC_UnlockInfoRet(eType,bOver,bAll,iNum,akUnlockInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UnlockInfoRet'
		g_encodeCache['eType'] = eType
		g_encodeCache['bOver'] = bOver
		g_encodeCache['bAll'] = bAll
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akUnlockInfo'] = akUnlockInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eType)
	kNetStream:WriteByte(bOver)
	kNetStream:WriteByte(bAll)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akUnlockInfo[i]["dwTypeID"])
		kNetStream:WriteInt(akUnlockInfo[i]["dwParam"])
	end
	return kNetStream,32771
end

function EncodeSendSeGAC_MailOprRet(eOprType,iNum,akResult,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_MailOprRet'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akResult'] = akResult
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteByte(akResult[i]["bOpr"])
		kNetStream:WriteDword64(akResult[i]["dwlMailID"])
		kNetStream:WriteInt(akResult[i]["iNum"])
		for j = 0,iNum or -1 do
		if j >= iNum then
			break
		end
		kNetStream:WriteInt(akResult[i]["akRetReason"][j]["dwItemID"])
		kNetStream:WriteInt(akResult[i]["akRetReason"][j]["dwItemNum"])
		kNetStream:WriteInt(akResult[i]["akRetReason"][j]["eReason"])
	end
	end
	return kNetStream,32788
end

function EncodeSendSeGAC_JWTTokenRet(acJson,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_JWTTokenRet'
		g_encodeCache['acJson'] = acJson
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(acJson)
	return kNetStream,32803
end

function EncodeSendSeGAC_FriendInfoOprRet(eOprType,bOpr,iNum,akFriendInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_FriendInfoOprRet'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['bOpr'] = bOpr
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akFriendInfo'] = akFriendInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteByte(bOpr)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteDword64(akFriendInfo[i]["defFriendID"])
		kNetStream:WriteString(akFriendInfo[i]["acFriendName"])
		kNetStream:WriteString(akFriendInfo[i]["charPicUrl"])
		kNetStream:WriteString(akFriendInfo[i]["acOpenID"])
		kNetStream:WriteInt(akFriendInfo[i]["dwSex"])
		kNetStream:WriteInt(akFriendInfo[i]["dwTitleID"])
		kNetStream:WriteInt(akFriendInfo[i]["dwModelID"])
		kNetStream:WriteInt(akFriendInfo[i]["dwAchievePoint"])
		kNetStream:WriteInt(akFriendInfo[i]["dwMeridiansLvl"])
		kNetStream:WriteInt(akFriendInfo[i]["dwLogoutTime"])
		kNetStream:WriteByte(akFriendInfo[i]["bRMBPlayer"])
		kNetStream:WriteByte(akFriendInfo[i]["bAdvancePurchase"])
		kNetStream:WriteString(akFriendInfo[i]["acVOpenID"])
	end
	return kNetStream,32783
end

function EncodeSendSeGAC_ModifyPlayerAppearanceRet(eModifyType,acChangeParam,eResultType,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ModifyPlayerAppearanceRet'
		g_encodeCache['eModifyType'] = eModifyType
		g_encodeCache['acChangeParam'] = acChangeParam
		g_encodeCache['eResultType'] = eResultType
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eModifyType)
	kNetStream:WriteString(acChangeParam)
	kNetStream:WriteInt(eResultType)
	return kNetStream,32812
end

function EncodeSendSeGAC_MoneyUpdate(eMoneyType,dwCurNum,dwAmtGold,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_MoneyUpdate'
		g_encodeCache['eMoneyType'] = eMoneyType
		g_encodeCache['dwCurNum'] = dwCurNum
		g_encodeCache['dwAmtGold'] = dwAmtGold
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eMoneyType)
	kNetStream:WriteInt(dwCurNum)
	kNetStream:WriteInt(dwAmtGold)
	return kNetStream,32814
end

function EncodeSendSeGAC_PublicChatRet(eChannelType,eRetType,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PublicChatRet'
		g_encodeCache['eChannelType'] = eChannelType
		g_encodeCache['eRetType'] = eRetType
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eChannelType)
	kNetStream:WriteInt(eRetType)
	return kNetStream,32801
end

function EncodeSendSeGAC_WordFilterRet(eFilterType,eRetType,dwParam,acContent,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_WordFilterRet'
		g_encodeCache['eFilterType'] = eFilterType
		g_encodeCache['eRetType'] = eRetType
		g_encodeCache['dwParam'] = dwParam
		g_encodeCache['acContent'] = acContent
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eFilterType)
	kNetStream:WriteInt(eRetType)
	kNetStream:WriteInt(dwParam)
	kNetStream:WriteString(acContent)
	return kNetStream,32798
end

function EncodeSendSeGAC_PlayerCommonInfoRet(eCommonRetType,dwlParam,acContent,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlayerCommonInfoRet'
		g_encodeCache['eCommonRetType'] = eCommonRetType
		g_encodeCache['dwlParam'] = dwlParam
		g_encodeCache['acContent'] = acContent
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eCommonRetType)
	kNetStream:WriteDword64(dwlParam)
	kNetStream:WriteString(acContent)
	return kNetStream,32842
end

function EncodeSendSeGAC_QueryClanCollectionInfoRet(eQueryType,iNum,akResult,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryClanCollectionInfoRet'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akResult'] = akResult
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akResult[i]["dwType"])
		kNetStream:WriteInt(akResult[i]["dwNum"])
	end
	return kNetStream,32856
end

function EncodeSendSeGAC_PlatPlayerSimpleInfos(dwPageID,eOptType,iSize,kPlatPlayerSimpleInfos,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatPlayerSimpleInfos'
		g_encodeCache['dwPageID'] = dwPageID
		g_encodeCache['eOptType'] = eOptType
		g_encodeCache['iSize'] = iSize
		g_encodeCache['kPlatPlayerSimpleInfos'] = kPlatPlayerSimpleInfos
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwPageID)
	kNetStream:WriteInt(eOptType)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteDword64(kPlatPlayerSimpleInfos[i]["defPlyID"])
		kNetStream:WriteInt(kPlatPlayerSimpleInfos[i]["dwModelID"])
		kNetStream:WriteString(kPlatPlayerSimpleInfos[i]["acPlayerName"])
		kNetStream:WriteByte(kPlatPlayerSimpleInfos[i]["bUnlockHouse"])
		kNetStream:WriteByte(kPlatPlayerSimpleInfos[i]["bRMBPlayer"])
		kNetStream:WriteString(kPlatPlayerSimpleInfos[i]["charPicUrl"])
		kNetStream:WriteInt(kPlatPlayerSimpleInfos[i]["dwTitleID"])
		kNetStream:WriteInt(kPlatPlayerSimpleInfos[i]["dwPetID"])
		kNetStream:WriteInt(kPlatPlayerSimpleInfos[i]["dwHeadBoxID"])
	end
	return kNetStream,32866
end

function EncodeSendSeGAC_PlayerInSameScriptInfo(dwScriptID,iSize,kDatas,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlayerInSameScriptInfo'
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['iSize'] = iSize
		g_encodeCache['kDatas'] = kDatas
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(kDatas[i]["dwPlayerID"])
		kNetStream:WriteString(kDatas[i]["acPlayerName"])
		kNetStream:WriteInt(kDatas[i]["dwSex"])
		kNetStream:WriteInt(kDatas[i]["dwWeekRoundTotalNum"])
		kNetStream:WriteInt(kDatas[i]["dwALiveDays"])
		kNetStream:WriteByte(kDatas[i]["bUnlockHouse"])
		kNetStream:WriteInt(kDatas[i]["dwAchievePoint"])
		kNetStream:WriteInt(kDatas[i]["dwMeridiansLvl"])
		kNetStream:WriteInt(kDatas[i]["dwCreateTime"])
		kNetStream:WriteInt(kDatas[i]["dwLastLogoutTime"])
		kNetStream:WriteInt(kDatas[i]["dwChallengeWinTimes"])
		kNetStream:WriteByte(kDatas[i]["bRMBPlayer"])
		kNetStream:WriteString(kDatas[i]["acOpenID"])
		kNetStream:WriteString(kDatas[i]["acVOpenID"])
		kNetStream:WriteString(kDatas[i]["acIP"])
		kNetStream:WriteInt(kDatas[i]["dwHoodleScore"])
		kNetStream:WriteInt(kDatas[i]["dwNormalHighTowerMaxNum"])
		kNetStream:WriteInt(kDatas[i]["dwBloodHighTowerMaxNum"])
		kNetStream:WriteInt(kDatas[i]["dwRegimentHighTowerMaxNum"])
		kNetStream:WriteInt(kDatas[i]["dwTitleID"])
		kNetStream:WriteInt(kDatas[i]["dwPaintingID"])
		kNetStream:WriteInt(kDatas[i]["dwModelID"])
		kNetStream:WriteString(kDatas[i]["charPicUrl"])
		kNetStream:WriteInt(kDatas[i]["dwBackGroundID"])
		kNetStream:WriteInt(kDatas[i]["dwBGMID"])
		kNetStream:WriteInt(kDatas[i]["dwPoetryID"])
		kNetStream:WriteInt(kDatas[i]["dwPedestalID"])
		kNetStream:WriteInt(kDatas[i]["dwShowRoleID"])
		kNetStream:WriteInt(kDatas[i]["dwShowPetID"])
		kNetStream:WriteInt(kDatas[i]["dwLoginWordID"])
		kNetStream:WriteInt(kDatas[i]["dwHeadBoxID"])
	end
	return kNetStream,32815
end

function EncodeSendSeGAC_BaseInfoUpdate(eChangeType,dwCurNum,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_BaseInfoUpdate'
		g_encodeCache['eChangeType'] = eChangeType
		g_encodeCache['dwCurNum'] = dwCurNum
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eChangeType)
	kNetStream:WriteInt(dwCurNum)
	return kNetStream,32863
end

function EncodeSendSeGAC_PlatPlayerDetailInfo(defPlyID,kCommInfo,kAppearanceInfo,kPlatRoleInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatPlayerDetailInfo'
		g_encodeCache['defPlyID'] = defPlyID
		g_encodeCache['kCommInfo'] = kCommInfo
		g_encodeCache['kAppearanceInfo'] = kAppearanceInfo
		g_encodeCache['kPlatRoleInfo'] = kPlatRoleInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteDword64(defPlyID)
	kNetStream:WriteString(kCommInfo["acPlayerName"])
	kNetStream:WriteString(kCommInfo["charPicUrl"])
	kNetStream:WriteInt(kCommInfo["dwModelID"])
	kNetStream:WriteInt(kCommInfo["dwSex"])
	kNetStream:WriteInt(kCommInfo["dwWeekRoundTotalNum"])
	kNetStream:WriteInt(kCommInfo["dwALiveDays"])
	kNetStream:WriteByte(kCommInfo["bUnlockHouse"])
	kNetStream:WriteInt(kCommInfo["dwAchievePoint"])
	kNetStream:WriteInt(kCommInfo["dwMeridiansLvl"])
	kNetStream:WriteInt(kCommInfo["dwCreateTime"])
	kNetStream:WriteInt(kCommInfo["dwLastLogoutTime"])
	kNetStream:WriteInt(kCommInfo["dwChallengeWinTimes"])
	kNetStream:WriteByte(kCommInfo["bRMBPlayer"])
	kNetStream:WriteInt(kCommInfo["dwTitleID"])
	kNetStream:WriteString(kCommInfo["acOpenID"])
	kNetStream:WriteString(kCommInfo["acVOpenID"])
	kNetStream:WriteString(kCommInfo["acIP"])
	kNetStream:WriteInt(kCommInfo["dwHoodleScore"])
	kNetStream:WriteInt(kCommInfo["dwNormalHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwBloodHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwRegimentHighTowerMaxNum"])
	kNetStream:WriteInt(kCommInfo["dwPlayerLastScriptID"])
	kNetStream:WriteInt(kCommInfo["dwNewBirdGuideState"])
	kNetStream:WriteString(kAppearanceInfo["acPlayerName"])
	kNetStream:WriteInt(kAppearanceInfo["dwTitleID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPaintingID"])
	kNetStream:WriteInt(kAppearanceInfo["dwModelID"])
	kNetStream:WriteString(kAppearanceInfo["charPicUrl"])
	kNetStream:WriteInt(kAppearanceInfo["dwBackGroundID"])
	kNetStream:WriteInt(kAppearanceInfo["dwBGMID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPoetryID"])
	kNetStream:WriteInt(kAppearanceInfo["dwPedestalID"])
	kNetStream:WriteInt(kAppearanceInfo["dwShowRoleID"])
	kNetStream:WriteInt(kAppearanceInfo["dwShowPetID"])
	kNetStream:WriteInt(kAppearanceInfo["dwLoginWordID"])
	kNetStream:WriteInt(kAppearanceInfo["dwHeadBoxID"])
	kNetStream:WriteInt(kAppearanceInfo["dwChatBoxID"])
	kNetStream:WriteInt(kAppearanceInfo["dwLandLadyID"])
	kNetStream:WriteInt(kPlatRoleInfo["uiMainRoleID"])
	kNetStream:WriteString(kPlatRoleInfo["acRoleName"])
	kNetStream:WriteInt(kPlatRoleInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiID"])
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiTypeID"])
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiNameID"])
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiTitleID"])
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiFamilyNameID"])
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiFirstNameID"])
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiModelID"])
		kNetStream:WriteInt(kPlatRoleInfo["akBaseRoleInfo"][i]["uiRank"])
	end
	return kNetStream,32868
end

function EncodeSendSeGAC_QueryTreasureBookBaseInfoRet(kBaseInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryTreasureBookBaseInfoRet'
		g_encodeCache['kBaseInfo'] = kBaseInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kBaseInfo["dwExp"])
	kNetStream:WriteInt(kBaseInfo["dwLvl"])
	kNetStream:WriteInt(kBaseInfo["dwMoney"])
	kNetStream:WriteByte(kBaseInfo["bRMBPlayer"])
	kNetStream:WriteByte(kBaseInfo["bAdvancePurchase"])
	kNetStream:WriteByte(kBaseInfo["bOpenRepeatTask"])
	kNetStream:WriteInt(kBaseInfo["dwCurPeriods"])
	kNetStream:WriteInt(kBaseInfo["dwCurPeriodsWeek"])
	kNetStream:WriteInt(kBaseInfo["dwHeroCanGetExtraRewardTaskNum"])
	kNetStream:WriteInt(kBaseInfo["dwRMBCanGetExtraRewardTaskNum"])
	kNetStream:WriteInt(kBaseInfo["dwCurMaxGetDailySilverNum"])
	kNetStream:WriteByte(kBaseInfo["bOpenDailyGift"])
	kNetStream:WriteByte(kBaseInfo["bEachDayGift"])
	kNetStream:WriteByte(kBaseInfo["bEachWeekGift"])
	kNetStream:WriteInt(kBaseInfo["dwProgressRewardFlag"])
	kNetStream:WriteInt(kBaseInfo["dwRMBProgressRewardFlag"])
	kNetStream:WriteDword64(kBaseInfo["dwLvlRewardFlag1"])
	kNetStream:WriteDword64(kBaseInfo["dwLvlRewardFlag2"])
	kNetStream:WriteDword64(kBaseInfo["dwRMBLvlRewardFlag1"])
	kNetStream:WriteDword64(kBaseInfo["dwRMBLvlRewardFlag2"])
	kNetStream:WriteInt(kBaseInfo["dwGivedFriendAdvanceNum"])
	kNetStream:WriteInt(kBaseInfo["dwPurchaseBookEndTime"])
	kNetStream:WriteInt(kBaseInfo["dwExtraGetRewardLvl"])
	return kNetStream,32851
end

function EncodeSendSeGAC_QueryTreasureBookTaskInfoRet(eTaskType,iNum,akTask,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryTreasureBookTaskInfoRet'
		g_encodeCache['eTaskType'] = eTaskType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akTask'] = akTask
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eTaskType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akTask[i]["dwTaskTypeID"])
		kNetStream:WriteInt(akTask[i]["dwProgress"])
		kNetStream:WriteByte(akTask[i]["bReward"])
		kNetStream:WriteByte(akTask[i]["bCanReward"])
		kNetStream:WriteInt(akTask[i]["dwRepeatFinishNum"])
	end
	return kNetStream,32819
end

function EncodeSendSeGAC_QueryTreasureBookMallInfoRet(iNum,akMall,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryTreasureBookMallInfoRet'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMall'] = akMall
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMall[i]["dwItemTypeID"])
		kNetStream:WriteInt(akMall[i]["dwExchangedNum"])
	end
	return kNetStream,32800
end

function EncodeSendSeGAC_QueryTreasureBookAllRewardProgressRet(iNum,dwProgress,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryTreasureBookAllRewardProgressRet'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['dwProgress'] = dwProgress
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(dwProgress[i])
	end
	return kNetStream,32846
end

function EncodeSendSeGAC_QueryTreasureBookGetRewardRet(bOpr,eQueryType,bOpenDailyGift,dwProgressRewardFlag,dwRMBProgressRewardFlag,dwLvlRewardFlag1,dwLvlRewardFlag2,dwRMBLvlRewardFlag1,dwRMBLvlRewardFlag2,iNum,akItem,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryTreasureBookGetRewardRet'
		g_encodeCache['bOpr'] = bOpr
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['bOpenDailyGift'] = bOpenDailyGift
		g_encodeCache['dwProgressRewardFlag'] = dwProgressRewardFlag
		g_encodeCache['dwRMBProgressRewardFlag'] = dwRMBProgressRewardFlag
		g_encodeCache['dwLvlRewardFlag1'] = dwLvlRewardFlag1
		g_encodeCache['dwLvlRewardFlag2'] = dwLvlRewardFlag2
		g_encodeCache['dwRMBLvlRewardFlag1'] = dwRMBLvlRewardFlag1
		g_encodeCache['dwRMBLvlRewardFlag2'] = dwRMBLvlRewardFlag2
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akItem'] = akItem
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bOpr)
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteByte(bOpenDailyGift)
	kNetStream:WriteInt(dwProgressRewardFlag)
	kNetStream:WriteInt(dwRMBProgressRewardFlag)
	kNetStream:WriteDword64(dwLvlRewardFlag1)
	kNetStream:WriteDword64(dwLvlRewardFlag2)
	kNetStream:WriteDword64(dwRMBLvlRewardFlag1)
	kNetStream:WriteDword64(dwRMBLvlRewardFlag2)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akItem[i]["uiItemID"])
		kNetStream:WriteInt(akItem[i]["uiItemNum"])
	end
	return kNetStream,32787
end

function EncodeSendSeGAC_QueryHoodleLotteryBaseInfoRet(ePoolType,kBaseInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryHoodleLotteryBaseInfoRet'
		g_encodeCache['ePoolType'] = ePoolType
		g_encodeCache['kBaseInfo'] = kBaseInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(ePoolType)
	kNetStream:WriteByte(kBaseInfo["bOpen"])
	kNetStream:WriteInt(kBaseInfo["dwSpecialSlotProgress"])
	kNetStream:WriteInt(kBaseInfo["dwCurPoolHoodleNum"])
	kNetStream:WriteInt(kBaseInfo["dwCurPoolFreeHoodleNum"])
	kNetStream:WriteInt(kBaseInfo["dwCurPoolDailyFreeHoodleNum"])
	kNetStream:WriteInt(kBaseInfo["dwAccForTenShootNum"])
	for i = 0,SSD_MAX_HOODLE_PROGRESS_BOX_NUM or -1 do
		if i >= SSD_MAX_HOODLE_PROGRESS_BOX_NUM then
			break
		end
		kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["eProgressType"])
		kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["dwCurProgress"])
		kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["kProgressTip"]["dwCurCDropBaseID"])
	kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["kProgressTip"]["dwCurDropItemID"])
	kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["kProgressTip"]["dwCurDropItemNum"])
	kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["kProgressTip"]["dwCurRewardItemID"])
	kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["kProgressTip"]["dwCurRewardItemNum"])
		kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["ePrivacyType"])
		kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["dwTotalHPNum"])
		kNetStream:WriteInt(kBaseInfo["akProgressInfo"][i]["dwPoolID"])
		kNetStream:WriteByte(kBaseInfo["akProgressInfo"][i]["bHide"])
	end
	for i = 0,SSD_MAX_HOODLE_SLOT_NUM or -1 do
		if i >= SSD_MAX_HOODLE_SLOT_NUM then
			break
		end
		kNetStream:WriteInt(kBaseInfo["akSlotInfo"][i]["dwSlotIndex"])
		kNetStream:WriteInt(kBaseInfo["akSlotInfo"][i]["kSlotTip"]["dwCurCDropBaseID"])
	kNetStream:WriteInt(kBaseInfo["akSlotInfo"][i]["kSlotTip"]["dwCurDropItemID"])
	kNetStream:WriteInt(kBaseInfo["akSlotInfo"][i]["kSlotTip"]["dwCurDropItemNum"])
	kNetStream:WriteInt(kBaseInfo["akSlotInfo"][i]["kSlotTip"]["dwCurRewardItemID"])
	kNetStream:WriteInt(kBaseInfo["akSlotInfo"][i]["kSlotTip"]["dwCurRewardItemNum"])
	end
	return kNetStream,32820
end

function EncodeSendSeGAC_QueryHoodleLotteryOpenInfoRet(acPoolOpenInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryHoodleLotteryOpenInfoRet'
		g_encodeCache['acPoolOpenInfo'] = acPoolOpenInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	for i = 0,SHLPLT_NUM or -1 do
		if i >= SHLPLT_NUM then
			break
		end
		kNetStream:WriteChar(acPoolOpenInfo[i])
	end
	return kNetStream,32835
end

function EncodeSendSeGAC_QueryHoodleLotteryResultRet(eQueryType,ePoolType,dwCurPoolHoodleNum,dwCurPoolFreeHoodleNum,dwCurPoolDailyFreeHoodleNum,dwAccForTenShootNum,iNum,akRetInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryHoodleLotteryResultRet'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['ePoolType'] = ePoolType
		g_encodeCache['dwCurPoolHoodleNum'] = dwCurPoolHoodleNum
		g_encodeCache['dwCurPoolFreeHoodleNum'] = dwCurPoolFreeHoodleNum
		g_encodeCache['dwCurPoolDailyFreeHoodleNum'] = dwCurPoolDailyFreeHoodleNum
		g_encodeCache['dwAccForTenShootNum'] = dwAccForTenShootNum
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRetInfo'] = akRetInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(ePoolType)
	kNetStream:WriteInt(dwCurPoolHoodleNum)
	kNetStream:WriteInt(dwCurPoolFreeHoodleNum)
	kNetStream:WriteInt(dwCurPoolDailyFreeHoodleNum)
	kNetStream:WriteInt(dwAccForTenShootNum)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteByte(akRetInfo[i]["bSpecialHoodle"])
		kNetStream:WriteInt(akRetInfo[i]["dwSpecialSlotProgress"])
		kNetStream:WriteInt(akRetInfo[i]["kHitSlotInfo"]["dwSlotIndex"])
	kNetStream:WriteInt(akRetInfo[i]["kHitSlotInfo"]["kSlotTip"]["dwCurCDropBaseID"])
	kNetStream:WriteInt(akRetInfo[i]["kHitSlotInfo"]["kSlotTip"]["dwCurDropItemID"])
	kNetStream:WriteInt(akRetInfo[i]["kHitSlotInfo"]["kSlotTip"]["dwCurDropItemNum"])
	kNetStream:WriteInt(akRetInfo[i]["kHitSlotInfo"]["kSlotTip"]["dwCurRewardItemID"])
	kNetStream:WriteInt(akRetInfo[i]["kHitSlotInfo"]["kSlotTip"]["dwCurRewardItemNum"])
		for j = 0,3 or -1 do
		if j >= 3 then
			break
		end
		kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["eProgressType"])
		kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["dwCurProgress"])
		kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["kProgressTip"]["dwCurCDropBaseID"])
	kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["kProgressTip"]["dwCurDropItemID"])
	kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["kProgressTip"]["dwCurDropItemNum"])
	kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["kProgressTip"]["dwCurRewardItemID"])
	kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["kProgressTip"]["dwCurRewardItemNum"])
		kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["ePrivacyType"])
		kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["dwTotalHPNum"])
		kNetStream:WriteInt(akRetInfo[i]["akBoxInfo"][j]["dwPoolID"])
		kNetStream:WriteByte(akRetInfo[i]["akBoxInfo"][j]["bHide"])
	end
	end
	return kNetStream,32781
end

function EncodeSendSeGAC_QueryPlatTeamInfoRet(eQueryType,dwScriptID,uiTime,dwMainRoleID,acName,iTeammatesNum,auiTeammates,iPetNum,akPets,iMeridiansNum,akMeridians,defPlayerID,bEnd,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryPlatTeamInfoRet'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['uiTime'] = uiTime
		g_encodeCache['dwMainRoleID'] = dwMainRoleID
		g_encodeCache['acName'] = acName
		g_encodeCache['iTeammatesNum'] = iTeammatesNum
		g_encodeCache['auiTeammates'] = auiTeammates
		g_encodeCache['iPetNum'] = iPetNum
		g_encodeCache['akPets'] = akPets
		g_encodeCache['iMeridiansNum'] = iMeridiansNum
		g_encodeCache['akMeridians'] = akMeridians
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['bEnd'] = bEnd
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(uiTime)
	kNetStream:WriteInt(dwMainRoleID)
	kNetStream:WriteString(acName)
	kNetStream:WriteInt(iTeammatesNum)
	for i = 0,iTeammatesNum or -1 do
		if i >= iTeammatesNum then
			break
		end
		kNetStream:WriteInt(auiTeammates[i])
	end
	kNetStream:WriteInt(iPetNum)
	for i = 0,iPetNum or -1 do
		if i >= iPetNum then
			break
		end
		kNetStream:WriteInt(akPets[i])
	end
	kNetStream:WriteInt(iMeridiansNum)
	for i = 0,iMeridiansNum or -1 do
		if i >= iMeridiansNum then
			break
		end
		kNetStream:WriteInt(akMeridians[i]["uiKey"])
		kNetStream:WriteInt(akMeridians[i]["uiValue"])
	end
	kNetStream:WriteDword64(defPlayerID)
	kNetStream:WriteByte(bEnd)
	return kNetStream,32867
end

function EncodeSendSeGAC_CopyTeamInfoRet(dwScriptID,bResult,uiTime,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_CopyTeamInfoRet'
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['bResult'] = bResult
		g_encodeCache['uiTime'] = uiTime
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteByte(bResult)
	kNetStream:WriteInt(uiTime)
	return kNetStream,32772
end

function EncodeSendSeGAC_PlatEmbattleRet(bSingle,bResult,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatEmbattleRet'
		g_encodeCache['bSingle'] = bSingle
		g_encodeCache['bResult'] = bResult
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bSingle)
	kNetStream:WriteByte(bResult)
	return kNetStream,32855
end

function EncodeSendSeGAC_PlatTeam_RoleCommon(eQueryType,dwScriptID,kPlatRoleCommon,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_RoleCommon'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['kPlatRoleCommon'] = kPlatRoleCommon
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(kPlatRoleCommon["uiID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiTypeID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiNameID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiTitleID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFamilyNameID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFirstNameID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiLevel"])
	kNetStream:WriteInt(kPlatRoleCommon["uiClanID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiHP"])
	kNetStream:WriteInt(kPlatRoleCommon["uiMP"])
	kNetStream:WriteInt(kPlatRoleCommon["uiExp"])
	kNetStream:WriteInt(kPlatRoleCommon["uiRemainAttrPoint"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFragment"])
	kNetStream:WriteInt(kPlatRoleCommon["uiOverlayLevel"])
	kNetStream:WriteInt(kPlatRoleCommon["iGoodEvil"])
	kNetStream:WriteInt(kPlatRoleCommon["uiRemainGiftPoint"])
	kNetStream:WriteInt(kPlatRoleCommon["uiModelID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiRank"])
	kNetStream:WriteInt(kPlatRoleCommon["uiMartialNum"])
	kNetStream:WriteInt(kPlatRoleCommon["uiEatFoodNum"])
	kNetStream:WriteInt(kPlatRoleCommon["uiEatFoodMaxNum"])
	for i = 0,256 or -1 do
		if i >= 256 then
			break
		end
		kNetStream:WriteInt(kPlatRoleCommon["uiMarry"][i])
	end
	kNetStream:WriteInt(kPlatRoleCommon["uiSubRole"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFavorNum"])
	for i = 0,uiFavorNum or -1 do
		if i >= uiFavorNum then
			break
		end
		kNetStream:WriteInt(kPlatRoleCommon["auiFavor"][i])
	end
	kNetStream:WriteInt(kPlatRoleCommon["uiBroAndSisNum"])
	for i = 0,uiBroAndSisNum or -1 do
		if i >= uiBroAndSisNum then
			break
		end
		kNetStream:WriteInt(kPlatRoleCommon["auiBroAndSis"][i])
	end
	return kNetStream,32829
end

function EncodeSendSeGAC_PlatTeam_RoleAttrs(eQueryType,dwScriptID,uiID,aiAttrs,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_RoleAttrs'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['uiID'] = uiID
		g_encodeCache['aiAttrs'] = aiAttrs
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(uiID)
	for i = 0,SSD_MAX_ROLE_DISPLAYATTR_NUMS or -1 do
		if i >= SSD_MAX_ROLE_DISPLAYATTR_NUMS then
			break
		end
		kNetStream:WriteInt(aiAttrs[i])
	end
	return kNetStream,32791
end

function EncodeSendSeGAC_PlatTeam_RoleItems(eQueryType,dwScriptID,uiID,iItemNum,auiRoleItem,auiEquipItem,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_RoleItems'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iItemNum'] = iItemNum
		g_encodeCache['auiRoleItem'] = auiRoleItem
		g_encodeCache['auiEquipItem'] = auiEquipItem
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iItemNum)
	for i = 0,iItemNum or -1 do
		if i >= iItemNum then
			break
		end
		kNetStream:WriteInt(auiRoleItem[i])
	end
	for i = 0,REI_NUMS or -1 do
		if i >= REI_NUMS then
			break
		end
		kNetStream:WriteInt(auiEquipItem[i])
	end
	return kNetStream,32850
end

function EncodeSendSeGAC_PlatTeam_RoleMartials(eQueryType,dwScriptID,uiID,iMartialNum,auiRoleMartials,iNum,akEmBattleMartialInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_RoleMartials'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iMartialNum'] = iMartialNum
		g_encodeCache['auiRoleMartials'] = auiRoleMartials
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akEmBattleMartialInfo'] = akEmBattleMartialInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iMartialNum)
	for i = 0,iMartialNum or -1 do
		if i >= iMartialNum then
			break
		end
		kNetStream:WriteInt(auiRoleMartials[i])
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akEmBattleMartialInfo[i]["dwUID"])
		kNetStream:WriteInt(akEmBattleMartialInfo[i]["dwTypeID"])
		kNetStream:WriteInt(akEmBattleMartialInfo[i]["dwIndex"])
	end
	return kNetStream,32782
end

function EncodeSendSeGAC_PlatTeam_RoleGift(eQueryType,dwScriptID,uiID,giftNum,auiRoleGift,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_RoleGift'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['uiID'] = uiID
		g_encodeCache['giftNum'] = giftNum
		g_encodeCache['auiRoleGift'] = auiRoleGift
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(giftNum)
	for i = 0,giftNum or -1 do
		if i >= giftNum then
			break
		end
		kNetStream:WriteInt(auiRoleGift[i])
	end
	return kNetStream,32778
end

function EncodeSendSeGAC_PlatTeam_RoleWishTasks(eQueryType,dwScriptID,uiID,iWishTasksNum,auiRoleWishTasks,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_RoleWishTasks'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iWishTasksNum'] = iWishTasksNum
		g_encodeCache['auiRoleWishTasks'] = auiRoleWishTasks
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iWishTasksNum)
	for i = 0,iWishTasksNum or -1 do
		if i >= iWishTasksNum then
			break
		end
		kNetStream:WriteInt(auiRoleWishTasks[i])
	end
	return kNetStream,32826
end

function EncodeSendSeGAC_PlatTeam_ItemInfo(eQueryType,dwScriptID,iSize,akRoleItem,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_ItemInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleItem'] = akRoleItem
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akRoleItem[i]["iValueChangeFlag"])
		if akRoleItem[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akRoleItem[i]["uiID"])
		end
		if akRoleItem[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akRoleItem[i]["uiTypeID"])
		end
		if akRoleItem[i]["uiItemNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akRoleItem[i]["uiItemNum"])
		end
		if akRoleItem[i]["uiDueTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akRoleItem[i]["uiDueTime"])
		end
		if akRoleItem[i]["uiEnhanceGrade"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteShort(akRoleItem[i]["uiEnhanceGrade"])
		end
		if akRoleItem[i]["uiCoinRemainRecastTimes"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteShort(akRoleItem[i]["uiCoinRemainRecastTimes"])
		end
		if akRoleItem[i]["iAttrNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akRoleItem[i]["iAttrNum"])
		end
		for j = 0,iAttrNum or -1 do
		if j >= iAttrNum then
			break
		end
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["uiAttrUID"])
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["uiType"])
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["iBaseValue"])
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["iExtraValue"])
		kNetStream:WriteByte(akRoleItem[i]["auiAttrData"][j]["uiRecastType"])
	end
		if akRoleItem[i]["uiOwnerID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akRoleItem[i]["uiOwnerID"])
		end
		if akRoleItem[i]["bBelongToMainRole"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteByte(akRoleItem[i]["bBelongToMainRole"])
		end
		if akRoleItem[i]["uiSpendIron"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akRoleItem[i]["uiSpendIron"])
		end
		if akRoleItem[i]["uiPerfectPower"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akRoleItem[i]["uiPerfectPower"])
		end
		if akRoleItem[i]["uiSpendTongLingYu"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteInt(akRoleItem[i]["uiSpendTongLingYu"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akRoleItem[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,32832
end

function EncodeSendSeGAC_PlatTeam_MartialInfo(eQueryType,dwScriptID,iSize,akRoleMartial,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_MartialInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleMartial'] = akRoleMartial
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akRoleMartial[i]["iValueChangeFlag"])
		if akRoleMartial[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akRoleMartial[i]["uiID"])
		end
		if akRoleMartial[i]["uiRoleUID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akRoleMartial[i]["uiRoleUID"])
		end
		if akRoleMartial[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akRoleMartial[i]["uiTypeID"])
		end
		if akRoleMartial[i]["uiLevel"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteByte(akRoleMartial[i]["uiLevel"])
		end
		if akRoleMartial[i]["uiExp"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akRoleMartial[i]["uiExp"])
		end
		if akRoleMartial[i]["uiExtExpApp"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akRoleMartial[i]["uiExtExpApp"])
		end
		if akRoleMartial[i]["uiMaxLevel"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteByte(akRoleMartial[i]["uiMaxLevel"])
		end
		if akRoleMartial[i]["iMartialAttrSize"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteByte(akRoleMartial[i]["iMartialAttrSize"])
		end
		for j = 0,iMartialAttrSize or -1 do
		if j >= iMartialAttrSize then
			break
		end
		kNetStream:WriteInt(akRoleMartial[i]["akMartialAttrs"][j]["uiType"])
		kNetStream:WriteInt(akRoleMartial[i]["akMartialAttrs"][j]["iValue"])
	end
		if akRoleMartial[i]["iMartialUnlockItemSize"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteByte(akRoleMartial[i]["iMartialUnlockItemSize"])
		end
		for j = 0,iMartialUnlockItemSize or -1 do
		if j >= iMartialUnlockItemSize then
			break
		end
		kNetStream:WriteInt(akRoleMartial[i]["auiMartialUnlockItems"][j])
	end
		if akRoleMartial[i]["iMartialInfluenceSize"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteByte(akRoleMartial[i]["iMartialInfluenceSize"])
		end
		for j = 0,iMartialInfluenceSize or -1 do
		if j >= iMartialInfluenceSize then
			break
		end
		kNetStream:WriteInt(akRoleMartial[i]["akMartialInfluences"][j]["uiAttrType"])
		kNetStream:WriteInt(akRoleMartial[i]["akMartialInfluences"][j]["uiMartialTypeID"])
		kNetStream:WriteInt(akRoleMartial[i]["akMartialInfluences"][j]["uiMartialValue"])
		kNetStream:WriteByte(akRoleMartial[i]["akMartialInfluences"][j]["uiMartialInit"])
	end
		if akRoleMartial[i]["iMartialUnlockSkillSize"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<13
			kNetStream:WriteByte(akRoleMartial[i]["iMartialUnlockSkillSize"])
		end
		for j = 0,iMartialUnlockSkillSize or -1 do
		if j >= iMartialUnlockSkillSize then
			break
		end
		kNetStream:WriteInt(akRoleMartial[i]["auiMartialUnlockSkills"][j])
	end
		if akRoleMartial[i]["iStrongLevel"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<15
			kNetStream:WriteByte(akRoleMartial[i]["iStrongLevel"])
		end
		if akRoleMartial[i]["iStrongCount"] ~= -1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<16
			kNetStream:WriteByte(akRoleMartial[i]["iStrongCount"])
		end
		if akRoleMartial[i]["uiAttr1"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<17
			kNetStream:WriteInt(akRoleMartial[i]["uiAttr1"])
		end
		if akRoleMartial[i]["uiAttr2"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<18
			kNetStream:WriteInt(akRoleMartial[i]["uiAttr2"])
		end
		if akRoleMartial[i]["uiAttr3"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<19
			kNetStream:WriteInt(akRoleMartial[i]["uiAttr3"])
		end
		if akRoleMartial[i]["uiColdTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<20
			kNetStream:WriteByte(akRoleMartial[i]["uiColdTime"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akRoleMartial[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,32776
end

function EncodeSendSeGAC_PlatTeam_WishTaskInfo(eQueryType,dwScriptID,iSize,akRoleWishTask,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_WishTaskInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleWishTask'] = akRoleWishTask
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(akRoleWishTask[i]["uiID"])
		kNetStream:WriteInt(akRoleWishTask[i]["uiTypeID"])
		kNetStream:WriteInt(akRoleWishTask[i]["uiState"])
		kNetStream:WriteInt(akRoleWishTask[i]["uiReward"])
		kNetStream:WriteInt(akRoleWishTask[i]["uiRoleCard"])
		kNetStream:WriteByte(akRoleWishTask[i]["bFirstGet"])
	end
	return kNetStream,32818
end

function EncodeSendSeGAC_PlatTeam_GiftInfo(eQueryType,dwScriptID,iSize,akRoleGift,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_GiftInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['dwScriptID'] = dwScriptID
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleGift'] = akRoleGift
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(dwScriptID)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(akRoleGift[i]["uiID"])
		kNetStream:WriteInt(akRoleGift[i]["uiTypeID"])
		kNetStream:WriteInt(akRoleGift[i]["uiGiftSourceType"])
		kNetStream:WriteByte(akRoleGift[i]["bIsGrowUp"])
	end
	return kNetStream,32852
end

function EncodeSendSeGAC_PlatTeam_EmbattleInfo(eQueryType,kEmbattleSingle,iEmbattleNum,akRoleEmbattle,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatTeam_EmbattleInfo'
		g_encodeCache['eQueryType'] = eQueryType
		g_encodeCache['kEmbattleSingle'] = kEmbattleSingle
		g_encodeCache['iEmbattleNum'] = iEmbattleNum
		g_encodeCache['akRoleEmbattle'] = akRoleEmbattle
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eQueryType)
	kNetStream:WriteInt(kEmbattleSingle["uiRoleID"])
	kNetStream:WriteByte(kEmbattleSingle["iID"])
	kNetStream:WriteByte(kEmbattleSingle["iRound"])
	kNetStream:WriteByte(kEmbattleSingle["iGridX"])
	kNetStream:WriteByte(kEmbattleSingle["iGridY"])
	kNetStream:WriteInt(kEmbattleSingle["eFlag"])
	kNetStream:WriteByte(kEmbattleSingle["bPet"])
	kNetStream:WriteInt(kEmbattleSingle["uiFlag"])
	kNetStream:WriteInt(iEmbattleNum)
	for i = 0,iEmbattleNum or -1 do
		if i >= iEmbattleNum then
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
	return kNetStream,32848
end

function EncodeSendSeGAC_UpdateArenaMatchData(iNum,akMatchData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateArenaMatchData'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMatchData'] = akMatchData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMatchData[i]["dwMatchType"])
		kNetStream:WriteInt(akMatchData[i]["dwMatchID"])
		kNetStream:WriteInt(akMatchData[i]["dwBufferID"])
		kNetStream:WriteInt(akMatchData[i]["dwSignUpCount"])
		kNetStream:WriteByte(akMatchData[i]["uiStage"])
		kNetStream:WriteByte(akMatchData[i]["dwRoundID"])
		kNetStream:WriteByte(akMatchData[i]["uiSignUpPlace"])
		kNetStream:WriteInt(akMatchData[i]["dwRank"])
		kNetStream:WriteInt(akMatchData[i]["dwBetWinTimes"])
		kNetStream:WriteInt(akMatchData[i]["dwBetWinMoney"])
		kNetStream:WriteInt(akMatchData[i]["dwBattleTime"])
	end
	return kNetStream,32859
end

function EncodeSendSeGAC_UpdateArenaBattleData(dwMatchType,dwMatchID,dwPushFlag,iNum,akBattleData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateArenaBattleData'
		g_encodeCache['dwMatchType'] = dwMatchType
		g_encodeCache['dwMatchID'] = dwMatchID
		g_encodeCache['dwPushFlag'] = dwPushFlag
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akBattleData'] = akBattleData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwMatchType)
	kNetStream:WriteInt(dwMatchID)
	kNetStream:WriteByte(dwPushFlag)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akBattleData[i]["dwBattleID"])
		kNetStream:WriteInt(akBattleData[i]["dwRoundID"])
		kNetStream:WriteInt(akBattleData[i]["dwPly1BetRate"])
		kNetStream:WriteInt(akBattleData[i]["dwPly2BetRate"])
		kNetStream:WriteDword64(akBattleData[i]["defPlyWinner"])
		kNetStream:WriteDword64(akBattleData[i]["defBetPlyID"])
		kNetStream:WriteInt(akBattleData[i]["dwBetMoney"])
		kNetStream:WriteDword64(akBattleData[i]["kPly1Data"]["defPlayerID"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwModelID"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwOnlineTime"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwMerdianLevel"])
	kNetStream:WriteString(akBattleData[i]["kPly1Data"]["acPlayerName"])
	kNetStream:WriteString(akBattleData[i]["kPly1Data"]["charPicUrl"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwRoleID"])
		kNetStream:WriteDword64(akBattleData[i]["kPly2Data"]["defPlayerID"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwModelID"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwOnlineTime"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwMerdianLevel"])
	kNetStream:WriteString(akBattleData[i]["kPly2Data"]["acPlayerName"])
	kNetStream:WriteString(akBattleData[i]["kPly2Data"]["charPicUrl"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwRoleID"])
	end
	return kNetStream,32794
end

function EncodeSendSeGAC_UpdateSignUpName(dwMatchType,dwMatchID,iNum,akSignUpName,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateSignUpName'
		g_encodeCache['dwMatchType'] = dwMatchType
		g_encodeCache['dwMatchID'] = dwMatchID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akSignUpName'] = akSignUpName
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwMatchType)
	kNetStream:WriteInt(dwMatchID)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteString(akSignUpName[i]["acPlayerName"])
	end
	return kNetStream,32844
end

function EncodeSendSeGAC_ArenaBattleRecordData(uiBattleID,defPlayerID,winPlayerID,dwTotalSize,uiBatchIdx,iBatchSize,akData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ArenaBattleRecordData'
		g_encodeCache['uiBattleID'] = uiBattleID
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['winPlayerID'] = winPlayerID
		g_encodeCache['dwTotalSize'] = dwTotalSize
		g_encodeCache['uiBatchIdx'] = uiBatchIdx
		g_encodeCache['iBatchSize'] = iBatchSize
		g_encodeCache['akData'] = akData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiBattleID)
	kNetStream:WriteDword64(defPlayerID)
	kNetStream:WriteDword64(winPlayerID)
	kNetStream:WriteInt(dwTotalSize)
	kNetStream:WriteInt(uiBatchIdx)
	kNetStream:WriteInt(iBatchSize)
	for i = 0,iBatchSize or -1 do
		if i >= iBatchSize then
			break
		end
		kNetStream:WriteByte(akData[i])
	end
	return kNetStream,32777
end

function EncodeSendSeGAC_NotifyArenaMemberPkData(dwMatchType,dwMatchID,defPlayerID,iPkDataCount,akPkData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_NotifyArenaMemberPkData'
		g_encodeCache['dwMatchType'] = dwMatchType
		g_encodeCache['dwMatchID'] = dwMatchID
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['iPkDataCount'] = iPkDataCount
		g_encodeCache['akPkData'] = akPkData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwMatchType)
	kNetStream:WriteInt(dwMatchID)
	kNetStream:WriteDword64(defPlayerID)
	kNetStream:WriteByte(iPkDataCount)
	for i = 0,iPkDataCount or -1 do
		if i >= iPkDataCount then
			break
		end
		kNetStream:WriteByte(akPkData[i]["iPkDataFlag"])
		kNetStream:WriteInt(akPkData[i]["iDataSize"])
		for j = 0,iDataSize or -1 do
		if j >= iDataSize then
			break
		end
		kNetStream:WriteByte(akPkData[i]["akData"][j])
	end
	end
	return kNetStream,32847
end

function EncodeSendSeGAC_UpdateArenaBetRankData(dwMatchType,dwMatchID,iNum,akRankData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateArenaBetRankData'
		g_encodeCache['dwMatchType'] = dwMatchType
		g_encodeCache['dwMatchID'] = dwMatchID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRankData'] = akRankData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwMatchType)
	kNetStream:WriteInt(dwMatchID)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteDword64(akRankData[i]["defPlayerID"])
		kNetStream:WriteString(akRankData[i]["acPlayerName"])
		kNetStream:WriteInt(akRankData[i]["dwValue"])
	end
	return kNetStream,32828
end

function EncodeSendSeGAC_UpdateArenaMatchHistoryData(iNum,akMatchHistoryData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateArenaMatchHistoryData'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMatchHistoryData'] = akMatchHistoryData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMatchHistoryData[i]["dwMatchType"])
		kNetStream:WriteInt(akMatchHistoryData[i]["dwMatchID"])
		kNetStream:WriteInt(akMatchHistoryData[i]["dwMatchTime"])
		kNetStream:WriteInt(akMatchHistoryData[i]["dwPlace"])
		kNetStream:WriteInt(akMatchHistoryData[i]["dwBetWinTimes"])
		kNetStream:WriteInt(akMatchHistoryData[i]["dwBetWinMoney"])
		for j = 0,3 or -1 do
		if j >= 3 then
			break
		end
		kNetStream:WriteDword64(akMatchHistoryData[i]["akMemberHistoryData"][j]["defPlayerID"])
		kNetStream:WriteString(akMatchHistoryData[i]["akMemberHistoryData"][j]["acPlayerName"])
		kNetStream:WriteString(akMatchHistoryData[i]["akMemberHistoryData"][j]["charPicUrl"])
		kNetStream:WriteInt(akMatchHistoryData[i]["akMemberHistoryData"][j]["dwModelID"])
		kNetStream:WriteInt(akMatchHistoryData[i]["akMemberHistoryData"][j]["dwPlace"])
	end
	end
	return kNetStream,32796
end

function EncodeSendSeGAC_UpdateArenaMatchJokeBattleData(akJokeBattleData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateArenaMatchJokeBattleData'
		g_encodeCache['akJokeBattleData'] = akJokeBattleData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	for i = 0,5 or -1 do
		if i >= 5 then
			break
		end
		kNetStream:WriteString(akJokeBattleData[i]["acPlayerName"])
		kNetStream:WriteString(akJokeBattleData[i]["charPicUrl"])
		kNetStream:WriteInt(akJokeBattleData[i]["dwModelID"])
		kNetStream:WriteInt(akJokeBattleData[i]["dwResult"])
	end
	return kNetStream,32805
end

function EncodeSendSeGAC_UpdateArenaMatchChampionTimes(dwNewHandChampionTimes,dwPublicChampionTimes,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateArenaMatchChampionTimes'
		g_encodeCache['dwNewHandChampionTimes'] = dwNewHandChampionTimes
		g_encodeCache['dwPublicChampionTimes'] = dwPublicChampionTimes
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwNewHandChampionTimes)
	kNetStream:WriteInt(dwPublicChampionTimes)
	return kNetStream,32823
end

function EncodeSendSeGAC_NotifyArenaNotice(uiNoticeFlag,dwMatchType,dwMatchID,defPlyID1,defPlyID2,acName1,acName2,dwPara1,dwPara2,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_NotifyArenaNotice'
		g_encodeCache['uiNoticeFlag'] = uiNoticeFlag
		g_encodeCache['dwMatchType'] = dwMatchType
		g_encodeCache['dwMatchID'] = dwMatchID
		g_encodeCache['defPlyID1'] = defPlyID1
		g_encodeCache['defPlyID2'] = defPlyID2
		g_encodeCache['acName1'] = acName1
		g_encodeCache['acName2'] = acName2
		g_encodeCache['dwPara1'] = dwPara1
		g_encodeCache['dwPara2'] = dwPara2
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiNoticeFlag)
	kNetStream:WriteInt(dwMatchType)
	kNetStream:WriteInt(dwMatchID)
	kNetStream:WriteDword64(defPlyID1)
	kNetStream:WriteDword64(defPlyID2)
	kNetStream:WriteString(acName1)
	kNetStream:WriteString(acName2)
	kNetStream:WriteInt(dwPara1)
	kNetStream:WriteInt(dwPara2)
	return kNetStream,32845
end

function EncodeSendSeGAC_UpdateArenaHuaShan(iNum,akMemberes,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateArenaHuaShan'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMemberes'] = akMemberes
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMemberes[i]["dwMatchType"])
		kNetStream:WriteDword64(akMemberes[i]["defPlayerID"])
		kNetStream:WriteString(akMemberes[i]["acPlayerName"])
	end
	return kNetStream,32792
end

function EncodeSendSeGAC_HoodlePublicInfoRet(PublicInfo,uiCurItemId,DataInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_HoodlePublicInfoRet'
		g_encodeCache['PublicInfo'] = PublicInfo
		g_encodeCache['uiCurItemId'] = uiCurItemId
		g_encodeCache['DataInfo'] = DataInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(PublicInfo["uiOpenId"])
	kNetStream:WriteInt(PublicInfo["uiTurns"])
	kNetStream:WriteInt(PublicInfo["uiTotal"])
	kNetStream:WriteInt(PublicInfo["uiNeedTotal"])
	kNetStream:WriteInt(PublicInfo["uiBeginTime"])
	kNetStream:WriteByte(PublicInfo["bResult"])
	kNetStream:WriteByte(PublicInfo["bOpen"])
	kNetStream:WriteByte(PublicInfo["bUseUp"])
	kNetStream:WriteInt(PublicInfo["uiPlayerNum"])
	for i = 0,uiPlayerNum or -1 do
		if i >= uiPlayerNum then
			break
		end
		kNetStream:WriteDword64(PublicInfo["akHoodlePlayer"][i]["defPlayerId"])
		kNetStream:WriteString(PublicInfo["akHoodlePlayer"][i]["acPlayerName"])
		kNetStream:WriteInt(PublicInfo["akHoodlePlayer"][i]["uiPrecessValue"])
		kNetStream:WriteInt(PublicInfo["akHoodlePlayer"][i]["dwServerID"])
	end
	kNetStream:WriteInt(PublicInfo["uiPersonalNum"])
	for i = 0,uiPersonalNum or -1 do
		if i >= uiPersonalNum then
			break
		end
		kNetStream:WriteDword64(PublicInfo["akPersonalProc"][i]["defPlayerId"])
		kNetStream:WriteString(PublicInfo["akPersonalProc"][i]["acPlayerName"])
		kNetStream:WriteInt(PublicInfo["akPersonalProc"][i]["uiPrecessValue"])
		kNetStream:WriteInt(PublicInfo["akPersonalProc"][i]["dwServerID"])
	end
	kNetStream:WriteInt(uiCurItemId)
	kNetStream:WriteDword64(DataInfo["uiBeginTime"])
	kNetStream:WriteDword64(DataInfo["uiEndTime"])
	kNetStream:WriteString(DataInfo["acResource"])
	kNetStream:WriteInt(DataInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(DataInfo["akAllItem"][i]["uiItemID"])
		kNetStream:WriteInt(DataInfo["akAllItem"][i]["uiCurNum"])
		kNetStream:WriteInt(DataInfo["akAllItem"][i]["uiTotalNum"])
		kNetStream:WriteInt(DataInfo["akAllItem"][i]["uiShowTotalNum"])
		kNetStream:WriteByte(DataInfo["akAllItem"][i]["bTopReward"])
	end
	kNetStream:WriteInt(DataInfo["iNum2"])
	for i = 0,iNum2 or -1 do
		if i >= iNum2 then
			break
		end
		kNetStream:WriteInt(DataInfo["akExchange"][i]["uiItemId"])
		kNetStream:WriteInt(DataInfo["akExchange"][i]["uiPrice"])
	end
	kNetStream:WriteInt(DataInfo["iNum3"])
	for i = 0,iNum3 or -1 do
		if i >= iNum3 then
			break
		end
		kNetStream:WriteInt(DataInfo["akShowItem"][i])
	end
	return kNetStream,32824
end

function EncodeSendSeGAC_HoodlePublicRecordRet(iCurPage,iSize,akHoodleRecord,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_HoodlePublicRecordRet'
		g_encodeCache['iCurPage'] = iCurPage
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akHoodleRecord'] = akHoodleRecord
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iCurPage)
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(akHoodleRecord[i]["uiRecordTime"])
		kNetStream:WriteDword64(akHoodleRecord[i]["defPlayerId"])
		kNetStream:WriteInt(akHoodleRecord[i]["uiItemId"])
		kNetStream:WriteString(akHoodleRecord[i]["acPlayerName"])
		kNetStream:WriteByte(akHoodleRecord[i]["bMaxCont"])
	end
	return kNetStream,32865
end

function EncodeSendSeGAC_HoodlePublicAssistReward(dwItemId,dwItemNum,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_HoodlePublicAssistReward'
		g_encodeCache['dwItemId'] = dwItemId
		g_encodeCache['dwItemNum'] = dwItemNum
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwItemId)
	kNetStream:WriteInt(dwItemNum)
	return kNetStream,32843
end

function EncodeSendSeGAC_SetMainRoleRet(uiRoleID,bResult,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SetMainRoleRet'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['bResult'] = bResult
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteByte(bResult)
	return kNetStream,32806
end

function EncodeSendSeGAC_ObservePlatRoleRet(defPlyID,uiRoleID,bResult,kPlatRoleCommon,aiAttrs,iGiftNum,auiRoleGift,iMartialNum,auiRoleMartial,auiEquipItem,iItemNum,akRoleItem,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ObservePlatRoleRet'
		g_encodeCache['defPlyID'] = defPlyID
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['bResult'] = bResult
		g_encodeCache['kPlatRoleCommon'] = kPlatRoleCommon
		g_encodeCache['aiAttrs'] = aiAttrs
		g_encodeCache['iGiftNum'] = iGiftNum
		g_encodeCache['auiRoleGift'] = auiRoleGift
		g_encodeCache['iMartialNum'] = iMartialNum
		g_encodeCache['auiRoleMartial'] = auiRoleMartial
		g_encodeCache['auiEquipItem'] = auiEquipItem
		g_encodeCache['iItemNum'] = iItemNum
		g_encodeCache['akRoleItem'] = akRoleItem
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteDword64(defPlyID)
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteByte(bResult)
	kNetStream:WriteInt(kPlatRoleCommon["uiID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiTypeID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiNameID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiTitleID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFamilyNameID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFirstNameID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiLevel"])
	kNetStream:WriteInt(kPlatRoleCommon["uiClanID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiHP"])
	kNetStream:WriteInt(kPlatRoleCommon["uiMP"])
	kNetStream:WriteInt(kPlatRoleCommon["uiExp"])
	kNetStream:WriteInt(kPlatRoleCommon["uiRemainAttrPoint"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFragment"])
	kNetStream:WriteInt(kPlatRoleCommon["uiOverlayLevel"])
	kNetStream:WriteInt(kPlatRoleCommon["iGoodEvil"])
	kNetStream:WriteInt(kPlatRoleCommon["uiRemainGiftPoint"])
	kNetStream:WriteInt(kPlatRoleCommon["uiModelID"])
	kNetStream:WriteInt(kPlatRoleCommon["uiRank"])
	kNetStream:WriteInt(kPlatRoleCommon["uiMartialNum"])
	kNetStream:WriteInt(kPlatRoleCommon["uiEatFoodNum"])
	kNetStream:WriteInt(kPlatRoleCommon["uiEatFoodMaxNum"])
	for i = 0,256 or -1 do
		if i >= 256 then
			break
		end
		kNetStream:WriteInt(kPlatRoleCommon["uiMarry"][i])
	end
	kNetStream:WriteInt(kPlatRoleCommon["uiSubRole"])
	kNetStream:WriteInt(kPlatRoleCommon["uiFavorNum"])
	for i = 0,uiFavorNum or -1 do
		if i >= uiFavorNum then
			break
		end
		kNetStream:WriteInt(kPlatRoleCommon["auiFavor"][i])
	end
	kNetStream:WriteInt(kPlatRoleCommon["uiBroAndSisNum"])
	for i = 0,uiBroAndSisNum or -1 do
		if i >= uiBroAndSisNum then
			break
		end
		kNetStream:WriteInt(kPlatRoleCommon["auiBroAndSis"][i])
	end
	for i = 0,SSD_MAX_ROLE_DISPLAYATTR_NUMS or -1 do
		if i >= SSD_MAX_ROLE_DISPLAYATTR_NUMS then
			break
		end
		kNetStream:WriteInt(aiAttrs[i])
	end
	kNetStream:WriteInt(iGiftNum)
	for i = 0,iGiftNum or -1 do
		if i >= iGiftNum then
			break
		end
		kNetStream:WriteInt(auiRoleGift[i])
	end
	kNetStream:WriteInt(iMartialNum)
	for i = 0,iMartialNum or -1 do
		if i >= iMartialNum then
			break
		end
		kNetStream:WriteInt(auiRoleMartial[i]["uiKey"])
		kNetStream:WriteInt(auiRoleMartial[i]["uiValue"])
	end
	for i = 0,REI_NUMS or -1 do
		if i >= REI_NUMS then
			break
		end
		kNetStream:WriteInt(auiEquipItem[i])
	end
	kNetStream:WriteInt(iItemNum)
	for i = 0,iItemNum or -1 do
		if i >= iItemNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akRoleItem[i]["iValueChangeFlag"])
		if akRoleItem[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akRoleItem[i]["uiID"])
		end
		if akRoleItem[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akRoleItem[i]["uiTypeID"])
		end
		if akRoleItem[i]["uiItemNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akRoleItem[i]["uiItemNum"])
		end
		if akRoleItem[i]["uiDueTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akRoleItem[i]["uiDueTime"])
		end
		if akRoleItem[i]["uiEnhanceGrade"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteShort(akRoleItem[i]["uiEnhanceGrade"])
		end
		if akRoleItem[i]["uiCoinRemainRecastTimes"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteShort(akRoleItem[i]["uiCoinRemainRecastTimes"])
		end
		if akRoleItem[i]["iAttrNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akRoleItem[i]["iAttrNum"])
		end
		for j = 0,iAttrNum or -1 do
		if j >= iAttrNum then
			break
		end
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["uiAttrUID"])
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["uiType"])
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["iBaseValue"])
		kNetStream:WriteInt(akRoleItem[i]["auiAttrData"][j]["iExtraValue"])
		kNetStream:WriteByte(akRoleItem[i]["auiAttrData"][j]["uiRecastType"])
	end
		if akRoleItem[i]["uiOwnerID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akRoleItem[i]["uiOwnerID"])
		end
		if akRoleItem[i]["bBelongToMainRole"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteByte(akRoleItem[i]["bBelongToMainRole"])
		end
		if akRoleItem[i]["uiSpendIron"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akRoleItem[i]["uiSpendIron"])
		end
		if akRoleItem[i]["uiPerfectPower"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akRoleItem[i]["uiPerfectPower"])
		end
		if akRoleItem[i]["uiSpendTongLingYu"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteInt(akRoleItem[i]["uiSpendTongLingYu"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akRoleItem[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,32830
end

function EncodeSendSeGAC_ArenaMatchOperateRetCode(akRankData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ArenaMatchOperateRetCode'
		g_encodeCache['akRankData'] = akRankData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteDword64(akRankData["defPlayerID"])
	kNetStream:WriteString(akRankData["acPlayerName"])
	kNetStream:WriteInt(akRankData["dwValue"])
	return kNetStream,32770
end

function EncodeSendSeGAC_RetRolePetCardOperate(uiCardType,iNum,akData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_RetRolePetCardOperate'
		g_encodeCache['uiCardType'] = uiCardType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akData'] = akData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiCardType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akData[i]["uiCardID"])
		kNetStream:WriteInt(akData[i]["uiLevel"])
		kNetStream:WriteInt(akData[i]["uiCardNum"])
		kNetStream:WriteInt(akData[i]["uiUseFlag"])
	end
	return kNetStream,32858
end

function EncodeSendSeGAC_PlatShopMallRewardRet(eType,iValue,iSelfValue,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatShopMallRewardRet'
		g_encodeCache['eType'] = eType
		g_encodeCache['iValue'] = iValue
		g_encodeCache['iSelfValue'] = iSelfValue
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eType)
	kNetStream:WriteInt(iValue)
	kNetStream:WriteInt(iSelfValue)
	return kNetStream,32790
end

function EncodeSendSeGAC_PlatShopMallQueryItemRet(uiType,iNum,akItem,iRackNum,auiValidRacks,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatShopMallQueryItemRet'
		g_encodeCache['uiType'] = uiType
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akItem'] = akItem
		g_encodeCache['iRackNum'] = iRackNum
		g_encodeCache['auiValidRacks'] = auiValidRacks
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiType)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akItem[i]["uiShopID"])
		kNetStream:WriteInt(akItem[i]["uiItemID"])
		kNetStream:WriteInt(akItem[i]["uiProperty"])
		kNetStream:WriteInt(akItem[i]["uiMoneyType"])
		kNetStream:WriteInt(akItem[i]["iPrice"])
		kNetStream:WriteInt(akItem[i]["iDiscount"])
		kNetStream:WriteInt(akItem[i]["iFinalPrice"])
		kNetStream:WriteInt(akItem[i]["uiFlag"])
		kNetStream:WriteInt(akItem[i]["iRemainTime"])
		kNetStream:WriteInt(akItem[i]["iCanBuyCount"])
		kNetStream:WriteInt(akItem[i]["iMaxBuyNums"])
		kNetStream:WriteInt(akItem[i]["iNeedUnlockType"])
		kNetStream:WriteInt(akItem[i]["iNeedUnlockID"])
		kNetStream:WriteInt(akItem[i]["iMaxBuyNumsPeriod"])
		kNetStream:WriteInt(akItem[i]["iType"])
		kNetStream:WriteInt(akItem[i]["iSort"])
	end
	kNetStream:WriteInt(iRackNum)
	for i = 0,iRackNum or -1 do
		if i >= iRackNum then
			break
		end
		kNetStream:WriteInt(auiValidRacks[i])
	end
	return kNetStream,32853
end

function EncodeSendSeGAC_PlatShopMallBuyRet(eType,iItemTypeID,iNum,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatShopMallBuyRet'
		g_encodeCache['eType'] = eType
		g_encodeCache['iItemTypeID'] = iItemTypeID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eType)
	kNetStream:WriteInt(iItemTypeID)
	kNetStream:WriteInt(iNum)
	return kNetStream,32841
end

function EncodeSendSeGAC_SystemFunctionSwitchNotify(bOpen,eSwitch,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SystemFunctionSwitchNotify'
		g_encodeCache['bOpen'] = bOpen
		g_encodeCache['eSwitch'] = eSwitch
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bOpen)
	kNetStream:WriteInt(eSwitch)
	return kNetStream,32821
end

function EncodeSendSeGAC_Day3SingInRet(eOpt,dwID,eState,dwTimeStamp,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_Day3SingInRet'
		g_encodeCache['eOpt'] = eOpt
		g_encodeCache['dwID'] = dwID
		g_encodeCache['eState'] = eState
		g_encodeCache['dwTimeStamp'] = dwTimeStamp
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(eOpt)
	kNetStream:WriteInt(dwID)
	kNetStream:WriteInt(eState)
	kNetStream:WriteInt(dwTimeStamp)
	return kNetStream,32799
end

function EncodeSendSeGAC_ExChangeGoldToSilverRet(bResult,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ExChangeGoldToSilverRet'
		g_encodeCache['bResult'] = bResult
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bResult)
	return kNetStream,32793
end

function EncodeSendSeGAC_CheckTencentAntiAddictionRet(acMessage,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_CheckTencentAntiAddictionRet'
		g_encodeCache['acMessage'] = acMessage
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(acMessage)
	return kNetStream,32861
end

function EncodeSendSeGAC_ChooseScriptAchieveRet(bOpr,iNum,akChooseAchieveRewardID,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ChooseScriptAchieveRet'
		g_encodeCache['bOpr'] = bOpr
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akChooseAchieveRewardID'] = akChooseAchieveRewardID
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bOpr)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akChooseAchieveRewardID[i])
	end
	return kNetStream,32779
end

function EncodeSendSeGAC_PlatDisplayNewToast(uiBaseID,bShowInChatOnly,uiParam1,uiParam2,uiParam3,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatDisplayNewToast'
		g_encodeCache['uiBaseID'] = uiBaseID
		g_encodeCache['bShowInChatOnly'] = bShowInChatOnly
		g_encodeCache['uiParam1'] = uiParam1
		g_encodeCache['uiParam2'] = uiParam2
		g_encodeCache['uiParam3'] = uiParam3
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiBaseID)
	kNetStream:WriteByte(bShowInChatOnly)
	kNetStream:WriteInt(uiParam1)
	kNetStream:WriteInt(uiParam2)
	kNetStream:WriteInt(uiParam3)
	return kNetStream,32789
end

function EncodeSendSeGAC_SyncTssDataSendToClient(acAntiData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SyncTssDataSendToClient'
		g_encodeCache['acAntiData'] = acAntiData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(acAntiData)
	return kNetStream,32811
end

function EncodeSendSeGAC_GetRedPacketRet(redPacketUID,ret,iItemId,iItemNum,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_GetRedPacketRet'
		g_encodeCache['redPacketUID'] = redPacketUID
		g_encodeCache['ret'] = ret
		g_encodeCache['iItemId'] = iItemId
		g_encodeCache['iItemNum'] = iItemNum
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(redPacketUID)
	kNetStream:WriteInt(ret)
	kNetStream:WriteInt(iItemId)
	kNetStream:WriteInt(iItemNum)
	return kNetStream,32864
end

function EncodeSendSeGAC_QueryForBidInfoRet(bAdd,iNum,akRet,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryForBidInfoRet'
		g_encodeCache['bAdd'] = bAdd
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRet'] = akRet
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bAdd)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRet[i]["eSeForBidType"])
		kNetStream:WriteInt(akRet[i]["dwBegineTime"])
		kNetStream:WriteInt(akRet[i]["iTime"])
		kNetStream:WriteString(akRet[i]["acReason"])
	end
	return kNetStream,32827
end

function EncodeSendSeGAC_RequestTencentCreditScoreRet(TencentCreditScore,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_RequestTencentCreditScoreRet'
		g_encodeCache['TencentCreditScore'] = TencentCreditScore
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(TencentCreditScore["iScore"])
	kNetStream:WriteInt(TencentCreditScore["iTagBlack"])
	kNetStream:WriteInt(TencentCreditScore["iMTime"])
	return kNetStream,32836
end

function EncodeSendSeGAC_RequestPrivateChatSceneLimitRet(bResult,iNum,akTencentSceneLimitState,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_RequestPrivateChatSceneLimitRet'
		g_encodeCache['bResult'] = bResult
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akTencentSceneLimitState'] = akTencentSceneLimitState
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bResult)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akTencentSceneLimitState[i]["uiKey"])
		kNetStream:WriteInt(akTencentSceneLimitState[i]["uiValue"])
	end
	return kNetStream,32808
end

function EncodeSendSeGAC_LimitShopRet(iResult,acShopInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_LimitShopRet'
		g_encodeCache['iResult'] = iResult
		g_encodeCache['acShopInfo'] = acShopInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iResult)
	kNetStream:WriteString(acShopInfo)
	return kNetStream,32797
end

function EncodeSendSeGAC_HoodleNumRet(ePoolType,eHoodleBallType,dwCurNum,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_HoodleNumRet'
		g_encodeCache['ePoolType'] = ePoolType
		g_encodeCache['eHoodleBallType'] = eHoodleBallType
		g_encodeCache['dwCurNum'] = dwCurNum
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(ePoolType)
	kNetStream:WriteInt(eHoodleBallType)
	kNetStream:WriteInt(dwCurNum)
	return kNetStream,32775
end

function EncodeSendSeGAC_GiftBagResultRet(iNum,akItems,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_GiftBagResultRet'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akItems'] = akItems
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akItems[i]["dwItemTypeID"])
		kNetStream:WriteInt(akItems[i]["dwItemUID"])
		kNetStream:WriteInt(akItems[i]["dwNum"])
	end
	return kNetStream,32840
end

function EncodeSendSeGAC_RequestCollectionPointRet(iNum,aiCollectionPoint,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_RequestCollectionPointRet'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['aiCollectionPoint'] = aiCollectionPoint
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(aiCollectionPoint[i])
	end
	return kNetStream,32816
end

function EncodeSendSeGAC_LimitShopGetYaZhuInfoRet(acData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_LimitShopGetYaZhuInfoRet'
		g_encodeCache['acData'] = acData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteString(acData)
	return kNetStream,32773
end

function EncodeSendSeGAC_SyncPlatCommonFunctionValue(uiType,uiValue,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SyncPlatCommonFunctionValue'
		g_encodeCache['uiType'] = uiType
		g_encodeCache['uiValue'] = uiValue
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiType)
	kNetStream:WriteInt(uiValue)
	return kNetStream,32860
end

function EncodeSendSeGAC_PlatChallengeReward(dwDropID,dwItemID,dwModelID,acPlayerName,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_PlatChallengeReward'
		g_encodeCache['dwDropID'] = dwDropID
		g_encodeCache['dwItemID'] = dwItemID
		g_encodeCache['dwModelID'] = dwModelID
		g_encodeCache['acPlayerName'] = acPlayerName
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwDropID)
	kNetStream:WriteInt(dwItemID)
	kNetStream:WriteInt(dwModelID)
	kNetStream:WriteString(acPlayerName)
	return kNetStream,32813
end

function EncodeSendSeGAC_UpdateNoviceGuideFlagRet(dwFlag,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateNoviceGuideFlagRet'
		g_encodeCache['dwFlag'] = dwFlag
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwFlag)
	return kNetStream,32804
end

function EncodeSendSeGAC_UpdateZMRoomInfo(dwRoundId,dwEquipLv,dwTime,dwFightId,iFreezeCardNum,akFreezeCardData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateZMRoomInfo'
		g_encodeCache['dwRoundId'] = dwRoundId
		g_encodeCache['dwEquipLv'] = dwEquipLv
		g_encodeCache['dwTime'] = dwTime
		g_encodeCache['dwFightId'] = dwFightId
		g_encodeCache['iFreezeCardNum'] = iFreezeCardNum
		g_encodeCache['akFreezeCardData'] = akFreezeCardData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(dwRoundId)
	kNetStream:WriteInt(dwEquipLv)
	kNetStream:WriteInt(dwTime)
	kNetStream:WriteInt(dwFightId)
	kNetStream:WriteInt(iFreezeCardNum)
	for i = 0,iFreezeCardNum or -1 do
		if i >= iFreezeCardNum then
			break
		end
		kNetStream:WriteInt(akFreezeCardData[i])
	end
	return kNetStream,32909
end

function EncodeSendSeGAC_UpdateZMRoomInfoExt(nRoomId,iNum,akPlyData,akCardData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateZMRoomInfoExt'
		g_encodeCache['nRoomId'] = nRoomId
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akPlyData'] = akPlyData
		g_encodeCache['akCardData'] = akCardData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteDword64(nRoomId)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteDword64(akPlyData[i]["kPlyData"]["defPlayerID"])
	kNetStream:WriteInt(akPlyData[i]["kPlyData"]["dwModelID"])
	kNetStream:WriteInt(akPlyData[i]["kPlyData"]["dwOnlineTime"])
	kNetStream:WriteInt(akPlyData[i]["kPlyData"]["dwMerdianLevel"])
	kNetStream:WriteString(akPlyData[i]["kPlyData"]["acPlayerName"])
	kNetStream:WriteString(akPlyData[i]["kPlyData"]["charPicUrl"])
	kNetStream:WriteInt(akPlyData[i]["kPlyData"]["dwRoleID"])
		kNetStream:WriteByte(akPlyData[i]["bRobot"])
	end
	for i = 0,SSD_MAX_ZM_CARD_POOL_SIZE or -1 do
		if i >= SSD_MAX_ZM_CARD_POOL_SIZE then
			break
		end
		kNetStream:WriteInt(akCardData[i]["dwBaseId"])
		kNetStream:WriteInt(akCardData[i]["dwCardNum"])
	end
	return kNetStream,32886
end

function EncodeSendSeGAC_UpdateZMPlayerInfo(kPlayerInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateZMPlayerInfo'
		g_encodeCache['kPlayerInfo'] = kPlayerInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akBattleCardData"][i])
	end
	kNetStream:WriteInt(kPlayerInfo["iCardNum"])
	for i = 0,iCardNum or -1 do
		if i >= iCardNum then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwBaseId"])
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwLv"])
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwId"])
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwEquipId"])
		kNetStream:WriteShort(kPlayerInfo["akCardData"][i]["wX"])
		kNetStream:WriteShort(kPlayerInfo["akCardData"][i]["wY"])
	end
	kNetStream:WriteInt(kPlayerInfo["iEquipNum"])
	for i = 0,iEquipNum or -1 do
		if i >= iEquipNum then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akEquipData"][i]["dwBaseId"])
		kNetStream:WriteInt(kPlayerInfo["akEquipData"][i]["dwLv"])
		kNetStream:WriteInt(kPlayerInfo["akEquipData"][i]["dwId"])
	end
	kNetStream:WriteInt(kPlayerInfo["dwClan"])
	kNetStream:WriteInt(kPlayerInfo["dwBattleCardNum"])
	return kNetStream,32925
end

function EncodeSendSeGAC_UpdateZMPlayerInfoExt(kPlayerInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateZMPlayerInfoExt'
		g_encodeCache['kPlayerInfo'] = kPlayerInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	for i = 0,SSD_MAX_ZM_SELECT_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_SELECT_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akSelectCardData"][i]["dwBaseId"])
		kNetStream:WriteInt(kPlayerInfo["akSelectCardData"][i]["dwLv"])
	end
	for i = 0,SSD_MAX_ZM_SELECT_CLAN_SIZE or -1 do
		if i >= SSD_MAX_ZM_SELECT_CLAN_SIZE then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akSelectClanData"][i])
	end
	for i = 0,SSD_MAX_ZM_SELECT_EQUIP_SIZE or -1 do
		if i >= SSD_MAX_ZM_SELECT_EQUIP_SIZE then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akSelectEquipData"][i])
	end
	kNetStream:WriteInt(kPlayerInfo["dwRound"])
	kNetStream:WriteInt(kPlayerInfo["dwEventId"])
	kNetStream:WriteInt(kPlayerInfo["dwReflashTimes"])
	kNetStream:WriteInt(kPlayerInfo["dwSkillUseTimes"])
	kNetStream:WriteInt(kPlayerInfo["dwGold"])
	return kNetStream,32917
end

function EncodeSendSeGAC_ZmBattleRecordData(uiBattleID,dwFightID,defPlayerID,winPlayerID,dwTotalSize,uiBatchIdx,iBatchSize,akData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ZmBattleRecordData'
		g_encodeCache['uiBattleID'] = uiBattleID
		g_encodeCache['dwFightID'] = dwFightID
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['winPlayerID'] = winPlayerID
		g_encodeCache['dwTotalSize'] = dwTotalSize
		g_encodeCache['uiBatchIdx'] = uiBatchIdx
		g_encodeCache['iBatchSize'] = iBatchSize
		g_encodeCache['akData'] = akData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiBattleID)
	kNetStream:WriteInt(dwFightID)
	kNetStream:WriteDword64(defPlayerID)
	kNetStream:WriteDword64(winPlayerID)
	kNetStream:WriteInt(dwTotalSize)
	kNetStream:WriteInt(uiBatchIdx)
	kNetStream:WriteInt(iBatchSize)
	for i = 0,iBatchSize or -1 do
		if i >= iBatchSize then
			break
		end
		kNetStream:WriteByte(akData[i])
	end
	return kNetStream,32962
end

function EncodeSendSeGAC_UpdateZmBattleData(bGet,iNum,akBattleData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateZmBattleData'
		g_encodeCache['bGet'] = bGet
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akBattleData'] = akBattleData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bGet)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akBattleData[i]["uiBattleID"])
		kNetStream:WriteInt(akBattleData[i]["uiRoundID"])
		kNetStream:WriteDword64(akBattleData[i]["uiWinnerID"])
		kNetStream:WriteDword64(akBattleData[i]["kPly1Data"]["defPlayerID"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwModelID"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwOnlineTime"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwMerdianLevel"])
	kNetStream:WriteString(akBattleData[i]["kPly1Data"]["acPlayerName"])
	kNetStream:WriteString(akBattleData[i]["kPly1Data"]["charPicUrl"])
	kNetStream:WriteInt(akBattleData[i]["kPly1Data"]["dwRoleID"])
		kNetStream:WriteDword64(akBattleData[i]["kPly2Data"]["defPlayerID"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwModelID"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwOnlineTime"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwMerdianLevel"])
	kNetStream:WriteString(akBattleData[i]["kPly2Data"]["acPlayerName"])
	kNetStream:WriteString(akBattleData[i]["kPly2Data"]["charPicUrl"])
	kNetStream:WriteInt(akBattleData[i]["kPly2Data"]["dwRoleID"])
	end
	return kNetStream,32934
end

function EncodeSendSeGAC_ResponseZmOperate(enRequest,enError,iParams0,iParams1,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ResponseZmOperate'
		g_encodeCache['enRequest'] = enRequest
		g_encodeCache['enError'] = enError
		g_encodeCache['iParams0'] = iParams0
		g_encodeCache['iParams1'] = iParams1
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(enRequest)
	kNetStream:WriteInt(enError)
	kNetStream:WriteInt(iParams0)
	kNetStream:WriteInt(iParams1)
	return kNetStream,32938
end

function EncodeSendSeGAC_UpdateZmShop(bGet,dwGold,dwTime,iNum,akItems,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateZmShop'
		g_encodeCache['bGet'] = bGet
		g_encodeCache['dwGold'] = dwGold
		g_encodeCache['dwTime'] = dwTime
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akItems'] = akItems
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteByte(bGet)
	kNetStream:WriteInt(dwGold)
	kNetStream:WriteInt(dwTime)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akItems[i]["dwRoleId"])
		kNetStream:WriteInt(akItems[i]["dwRoleNum"])
	end
	return kNetStream,32869
end

function EncodeSendSeGAC_UpdateZMOtherPlayerInfo(kPlayerInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateZMOtherPlayerInfo'
		g_encodeCache['kPlayerInfo'] = kPlayerInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteDword64(kPlayerInfo["defPlayerID"])
	kNetStream:WriteString(kPlayerInfo["acPlayerName"])
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwBaseId"])
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwLv"])
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwId"])
		kNetStream:WriteInt(kPlayerInfo["akCardData"][i]["dwEquipId"])
		kNetStream:WriteShort(kPlayerInfo["akCardData"][i]["wX"])
		kNetStream:WriteShort(kPlayerInfo["akCardData"][i]["wY"])
	end
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kPlayerInfo["akEquipData"][i]["dwBaseId"])
		kNetStream:WriteInt(kPlayerInfo["akEquipData"][i]["dwLv"])
		kNetStream:WriteInt(kPlayerInfo["akEquipData"][i]["dwId"])
	end
	kNetStream:WriteInt(kPlayerInfo["dwClan"])
	kNetStream:WriteInt(kPlayerInfo["dwBuffID"])
	kNetStream:WriteInt(kPlayerInfo["dwClanBuffID"])
	kNetStream:WriteInt(kPlayerInfo["dwClanBuffCount"])
	return kNetStream,32937
end

function EncodeSendSeGAC_ZmNotice(enNotice,acSrcPlayerName,acTargetPlayerName,iNum,akNoticePairs,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_ZmNotice'
		g_encodeCache['enNotice'] = enNotice
		g_encodeCache['acSrcPlayerName'] = acSrcPlayerName
		g_encodeCache['acTargetPlayerName'] = acTargetPlayerName
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akNoticePairs'] = akNoticePairs
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(enNotice)
	kNetStream:WriteString(acSrcPlayerName)
	kNetStream:WriteString(acTargetPlayerName)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akNoticePairs[i]["dwFirst"])
		kNetStream:WriteInt(akNoticePairs[i]["dwSecond"])
	end
	return kNetStream,32907
end

function EncodeSendSeGAC_QuerySectInfoRet(kStoreInfo,iBuildingNum,akBuidlingInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QuerySectInfoRet'
		g_encodeCache['kStoreInfo'] = kStoreInfo
		g_encodeCache['iBuildingNum'] = iBuildingNum
		g_encodeCache['akBuidlingInfo'] = akBuidlingInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kStoreInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(kStoreInfo["akStoreItemInfo"][i]["dwItemID"])
		kNetStream:WriteInt(kStoreInfo["akStoreItemInfo"][i]["dwItemNum"])
	end
	kNetStream:WriteInt(iBuildingNum)
	for i = 0,iBuildingNum or -1 do
		if i >= iBuildingNum then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingType"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingLevel"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingPos"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwPreBuildingID"])
		kNetStream:WriteString(akBuidlingInfo[i]["acName"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBackGroundID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwUpgradeEndTime"])
		kNetStream:WriteInt(akBuidlingInfo[i]["iNum"])
		for j = 0,iNum or -1 do
		if j >= iNum then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwItemID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwItemNum"])
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwUpdateTime"])
	end
		for j = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if j >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["akDiscipleInfo"][j])
	end
	end
	return kNetStream,32885
end

function EncodeSendSeGAC_SectBuildingSaveRet(kStoreInfo,iBuildingNum,akBuidlingInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SectBuildingSaveRet'
		g_encodeCache['kStoreInfo'] = kStoreInfo
		g_encodeCache['iBuildingNum'] = iBuildingNum
		g_encodeCache['akBuidlingInfo'] = akBuidlingInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kStoreInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(kStoreInfo["akStoreItemInfo"][i]["dwItemID"])
		kNetStream:WriteInt(kStoreInfo["akStoreItemInfo"][i]["dwItemNum"])
	end
	kNetStream:WriteInt(iBuildingNum)
	for i = 0,iBuildingNum or -1 do
		if i >= iBuildingNum then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingType"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingLevel"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingPos"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwPreBuildingID"])
		kNetStream:WriteString(akBuidlingInfo[i]["acName"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBackGroundID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwUpgradeEndTime"])
		kNetStream:WriteInt(akBuidlingInfo[i]["iNum"])
		for j = 0,iNum or -1 do
		if j >= iNum then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwItemID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwItemNum"])
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwUpdateTime"])
	end
		for j = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if j >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["akDiscipleInfo"][j])
	end
	end
	return kNetStream,32910
end

function EncodeSendSeGAC_SectBuildingUpgradeRet(kBuidlingInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SectBuildingUpgradeRet'
		g_encodeCache['kBuidlingInfo'] = kBuidlingInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingID"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingType"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingLevel"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingPos"])
	kNetStream:WriteInt(kBuidlingInfo["dwPreBuildingID"])
	kNetStream:WriteString(kBuidlingInfo["acName"])
	kNetStream:WriteInt(kBuidlingInfo["dwBackGroundID"])
	kNetStream:WriteInt(kBuidlingInfo["dwUpgradeEndTime"])
	kNetStream:WriteInt(kBuidlingInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwItemID"])
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwItemNum"])
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwUpdateTime"])
	end
	for i = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if i >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
		kNetStream:WriteInt(kBuidlingInfo["akDiscipleInfo"][i])
	end
	return kNetStream,32880
end

function EncodeSendSeGAC_SectMaterialGetRet(kBuidlingInfo,kStoreInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SectMaterialGetRet'
		g_encodeCache['kBuidlingInfo'] = kBuidlingInfo
		g_encodeCache['kStoreInfo'] = kStoreInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingID"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingType"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingLevel"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingPos"])
	kNetStream:WriteInt(kBuidlingInfo["dwPreBuildingID"])
	kNetStream:WriteString(kBuidlingInfo["acName"])
	kNetStream:WriteInt(kBuidlingInfo["dwBackGroundID"])
	kNetStream:WriteInt(kBuidlingInfo["dwUpgradeEndTime"])
	kNetStream:WriteInt(kBuidlingInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwItemID"])
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwItemNum"])
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwUpdateTime"])
	end
	for i = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if i >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
		kNetStream:WriteInt(kBuidlingInfo["akDiscipleInfo"][i])
	end
	kNetStream:WriteInt(kStoreInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(kStoreInfo["akStoreItemInfo"][i]["dwItemID"])
		kNetStream:WriteInt(kStoreInfo["akStoreItemInfo"][i]["dwItemNum"])
	end
	return kNetStream,32957
end

function EncodeSendSeGAC_SectDisciplePutRet(iBuildingNum,akBuidlingInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SectDisciplePutRet'
		g_encodeCache['iBuildingNum'] = iBuildingNum
		g_encodeCache['akBuidlingInfo'] = akBuidlingInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iBuildingNum)
	for i = 0,iBuildingNum or -1 do
		if i >= iBuildingNum then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingType"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingLevel"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBuildingPos"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwPreBuildingID"])
		kNetStream:WriteString(akBuidlingInfo[i]["acName"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwBackGroundID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["dwUpgradeEndTime"])
		kNetStream:WriteInt(akBuidlingInfo[i]["iNum"])
		for j = 0,iNum or -1 do
		if j >= iNum then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwItemID"])
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwItemNum"])
		kNetStream:WriteInt(akBuidlingInfo[i]["akWorkshopItemInfo"][j]["dwUpdateTime"])
	end
		for j = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if j >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
		kNetStream:WriteInt(akBuidlingInfo[i]["akDiscipleInfo"][j])
	end
	end
	return kNetStream,32922
end

function EncodeSendSeGAC_SectBuildingNameRet(kBuidlingInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SectBuildingNameRet'
		g_encodeCache['kBuidlingInfo'] = kBuidlingInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingID"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingType"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingLevel"])
	kNetStream:WriteInt(kBuidlingInfo["dwBuildingPos"])
	kNetStream:WriteInt(kBuidlingInfo["dwPreBuildingID"])
	kNetStream:WriteString(kBuidlingInfo["acName"])
	kNetStream:WriteInt(kBuidlingInfo["dwBackGroundID"])
	kNetStream:WriteInt(kBuidlingInfo["dwUpgradeEndTime"])
	kNetStream:WriteInt(kBuidlingInfo["iNum"])
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwItemID"])
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwItemNum"])
		kNetStream:WriteInt(kBuidlingInfo["akWorkshopItemInfo"][i]["dwUpdateTime"])
	end
	for i = 0,SSD_MAX_DISCIPLENUM_PER_BUILDING or -1 do
		if i >= SSD_MAX_DISCIPLENUM_PER_BUILDING then
			break
		end
		kNetStream:WriteInt(kBuidlingInfo["akDiscipleInfo"][i])
	end
	return kNetStream,32933
end

function EncodeSendSeGAC_QueryActivityRet(iNum,akActivityInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryActivityRet'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akActivityInfo'] = akActivityInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akActivityInfo[i]["dwActivityID"])
		kNetStream:WriteInt(akActivityInfo[i]["iReset_time"])
		kNetStream:WriteInt(akActivityInfo[i]["iCycle_count"])
		kNetStream:WriteInt(akActivityInfo[i]["iHistory_count"])
		kNetStream:WriteInt(akActivityInfo[i]["iState"])
		kNetStream:WriteDword64(akActivityInfo[i]["iValue1"])
		kNetStream:WriteDword64(akActivityInfo[i]["iValue2"])
		kNetStream:WriteDword64(akActivityInfo[i]["iValue3"])
		kNetStream:WriteByte(akActivityInfo[i]["bEnabled"])
	end
	return kNetStream,32949
end

function EncodeSendSeGAC_SystemFunctionSwitchNotifyAll(iNum,akChooseAchieveRewardID,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_SystemFunctionSwitchNotifyAll'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akChooseAchieveRewardID'] = akChooseAchieveRewardID
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteByte(akChooseAchieveRewardID[i]["bOpen"])
		kNetStream:WriteInt(akChooseAchieveRewardID[i]["eSwitch"])
	end
	return kNetStream,32884
end

function EncodeSendSeGAC_QueryHoodlePrivacyResultRet(kPrivacyInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryHoodlePrivacyResultRet'
		g_encodeCache['kPrivacyInfo'] = kPrivacyInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(kPrivacyInfo["dwCurHoodlePrivacyID"])
	kNetStream:WriteInt(kPrivacyInfo["dwBeginTimeStamp"])
	kNetStream:WriteInt(kPrivacyInfo["dwEndTimeStamp"])
	kNetStream:WriteInt(kPrivacyInfo["dwTotalNormalNum"])
	kNetStream:WriteInt(kPrivacyInfo["dwCurResetNum"])
	kNetStream:WriteByte(kPrivacyInfo["bResetReFresh"])
	for i = 0,SHPCT_NUM or -1 do
		if i >= SHPCT_NUM then
			break
		end
		kNetStream:WriteInt(kPrivacyInfo["akChivalrousInfo"][i]["uiItemID"])
		kNetStream:WriteInt(kPrivacyInfo["akChivalrousInfo"][i]["uiItemNum"])
	end
	return kNetStream,32931
end

function EncodeSendSeGAC_QueryStoryWeekLimitRet(iNum,akWeekLimitInfo,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_QueryStoryWeekLimitRet'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akWeekLimitInfo'] = akWeekLimitInfo
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akWeekLimitInfo[i]["dwStoryID"])
		kNetStream:WriteInt(akWeekLimitInfo[i]["iTakeOutNum"])
	end
	return kNetStream,32939
end

function EncodeSendSeGAC_UpdateSystemModuleEnableState(iNum,abSystemModuleEnableState,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_UpdateSystemModuleEnableState'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['abSystemModuleEnableState'] = abSystemModuleEnableState
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteByte(abSystemModuleEnableState[i])
	end
	return kNetStream,32954
end

function EncodeSendSeGAC_AllRoleFaceRet(uiScriptID,iNum,akRoleFaceData,dwSeqNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGAC_AllRoleFaceRet'
		g_encodeCache['uiScriptID'] = uiScriptID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRoleFaceData'] = akRoleFaceData
		g_encodeCache['dwSeqNum'] = dwSeqNum	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	if nil == dwSeqNum then
		kNetStream.WriteInt(0)
	else
		kNetStream.WriteInt(dwSeqNum)
	end
	kNetStream:WriteInt(uiScriptID)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRoleFaceData[i]["uiHat"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiBack"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiHairBack"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiBody"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiFace"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiEyebrow"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiEye"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiMouth"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiNose"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiForeheadAdornment"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiFacialAdornment"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiHairFront"])
		kNetStream:WriteInt(akRoleFaceData[i]["iEyebrowWidth"])
		kNetStream:WriteInt(akRoleFaceData[i]["iEyebrowHeight"])
		kNetStream:WriteInt(akRoleFaceData[i]["iEyebrowLocation"])
		kNetStream:WriteInt(akRoleFaceData[i]["iEyeWidth"])
		kNetStream:WriteInt(akRoleFaceData[i]["iEyeHeight"])
		kNetStream:WriteInt(akRoleFaceData[i]["iEyeLocation"])
		kNetStream:WriteInt(akRoleFaceData[i]["iNoseWidth"])
		kNetStream:WriteInt(akRoleFaceData[i]["iNoseHeight"])
		kNetStream:WriteInt(akRoleFaceData[i]["iNoseLocation"])
		kNetStream:WriteInt(akRoleFaceData[i]["iMouthWidth"])
		kNetStream:WriteInt(akRoleFaceData[i]["iMouthHeight"])
		kNetStream:WriteInt(akRoleFaceData[i]["iMouthLocation"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiModelID"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiSex"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiCGSex"])
		kNetStream:WriteInt(akRoleFaceData[i]["uiRoleID"])
	end
	return kNetStream,32874
end

