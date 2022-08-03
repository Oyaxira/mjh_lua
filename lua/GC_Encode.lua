-- auto make by Tool ProtocolMaker don't modify anything!!!
function EncodeSendSeGC_StartScript(uiScriptID,iDataSize,akCarryData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_StartScript'
		g_encodeCache['uiScriptID'] = uiScriptID
		g_encodeCache['iDataSize'] = iDataSize
		g_encodeCache['akCarryData'] = akCarryData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiScriptID)
	kNetStream:WriteInt(iDataSize)
	for i = 0,iDataSize or -1 do
		if i >= iDataSize then
			break
		end
		kNetStream:WriteByte(akCarryData[i])
	end
	return kNetStream,39209
end

function EncodeSendSeGC_LoadScriptMaxID(uiMaxRoleID,uiMaxItemID,uiMaxMartialID,uiMaxTaskID,uiMaxTagID,uiMaxDynamicID,uiMaxGiftID,uiMaxEvolutionID,uiMaxWishID,uiMaxMapID,uiMaxMazeID,uiMaxMazeAreaID,uiMaxMazeCardID,uiMaxMazeGridID,uiMaxClanID,uiMaxCityID,uiMaxContactID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_LoadScriptMaxID'
		g_encodeCache['uiMaxRoleID'] = uiMaxRoleID
		g_encodeCache['uiMaxItemID'] = uiMaxItemID
		g_encodeCache['uiMaxMartialID'] = uiMaxMartialID
		g_encodeCache['uiMaxTaskID'] = uiMaxTaskID
		g_encodeCache['uiMaxTagID'] = uiMaxTagID
		g_encodeCache['uiMaxDynamicID'] = uiMaxDynamicID
		g_encodeCache['uiMaxGiftID'] = uiMaxGiftID
		g_encodeCache['uiMaxEvolutionID'] = uiMaxEvolutionID
		g_encodeCache['uiMaxWishID'] = uiMaxWishID
		g_encodeCache['uiMaxMapID'] = uiMaxMapID
		g_encodeCache['uiMaxMazeID'] = uiMaxMazeID
		g_encodeCache['uiMaxMazeAreaID'] = uiMaxMazeAreaID
		g_encodeCache['uiMaxMazeCardID'] = uiMaxMazeCardID
		g_encodeCache['uiMaxMazeGridID'] = uiMaxMazeGridID
		g_encodeCache['uiMaxClanID'] = uiMaxClanID
		g_encodeCache['uiMaxCityID'] = uiMaxCityID
		g_encodeCache['uiMaxContactID'] = uiMaxContactID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMaxRoleID)
	kNetStream:WriteInt(uiMaxItemID)
	kNetStream:WriteInt(uiMaxMartialID)
	kNetStream:WriteInt(uiMaxTaskID)
	kNetStream:WriteInt(uiMaxTagID)
	kNetStream:WriteInt(uiMaxDynamicID)
	kNetStream:WriteInt(uiMaxGiftID)
	kNetStream:WriteInt(uiMaxEvolutionID)
	kNetStream:WriteInt(uiMaxWishID)
	kNetStream:WriteInt(uiMaxMapID)
	kNetStream:WriteInt(uiMaxMazeID)
	kNetStream:WriteInt(uiMaxMazeAreaID)
	kNetStream:WriteInt(uiMaxMazeCardID)
	kNetStream:WriteInt(uiMaxMazeGridID)
	kNetStream:WriteInt(uiMaxClanID)
	kNetStream:WriteInt(uiMaxCityID)
	kNetStream:WriteInt(uiMaxContactID)
	return kNetStream,39186
end

function EncodeSendSeGC_CarryAchieveRewardID(iNum,auiAchieveReward)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_CarryAchieveRewardID'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['auiAchieveReward'] = auiAchieveReward
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(auiAchieveReward[i])
	end
	return kNetStream,39225
end

function EncodeSendSeGC_CarryScriptDiff(iDiff,iWeekNum,iDeleteNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_CarryScriptDiff'
		g_encodeCache['iDiff'] = iDiff
		g_encodeCache['iWeekNum'] = iWeekNum
		g_encodeCache['iDeleteNum'] = iDeleteNum
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iDiff)
	kNetStream:WriteInt(iWeekNum)
	kNetStream:WriteInt(iDeleteNum)
	return kNetStream,39217
end

function EncodeSendSeGC_CarrySpecialArray(iNum,akSpecialArray)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_CarrySpecialArray'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akSpecialArray'] = akSpecialArray
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akSpecialArray[i]["eType"])
		kNetStream:WriteInt(akSpecialArray[i]["iNum1"])
		kNetStream:WriteInt(akSpecialArray[i]["iNum2"])
		kNetStream:WriteByte(akSpecialArray[i]["iNum3"])
	end
	return kNetStream,39262
end

function EncodeSendSeGC_ChangeDynamicConfig(bOpenBattleLog,bOpenDebugLog)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ChangeDynamicConfig'
		g_encodeCache['bOpenBattleLog'] = bOpenBattleLog
		g_encodeCache['bOpenDebugLog'] = bOpenDebugLog
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bOpenBattleLog)
	kNetStream:WriteByte(bOpenDebugLog)
	return kNetStream,39234
end

function EncodeSendSeGC_ClickMap(eMapOpType,uiMapID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickMap'
		g_encodeCache['eMapOpType'] = eMapOpType
		g_encodeCache['uiMapID'] = uiMapID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eMapOpType)
	kNetStream:WriteInt(uiMapID)
	return kNetStream,39238
end

function EncodeSendSeGC_ClickNPC(uiMapID,uiNpcID,uiMazeBaseID,uiAreaIndex,uiRow,uiColumn)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickNPC'
		g_encodeCache['uiMapID'] = uiMapID
		g_encodeCache['uiNpcID'] = uiNpcID
		g_encodeCache['uiMazeBaseID'] = uiMazeBaseID
		g_encodeCache['uiAreaIndex'] = uiAreaIndex
		g_encodeCache['uiRow'] = uiRow
		g_encodeCache['uiColumn'] = uiColumn
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMapID)
	kNetStream:WriteInt(uiNpcID)
	kNetStream:WriteInt(uiMazeBaseID)
	kNetStream:WriteInt(uiAreaIndex)
	kNetStream:WriteInt(uiRow)
	kNetStream:WriteInt(uiColumn)
	return kNetStream,39169
end

function EncodeSendSeGC_Click_NPC_InteractOper(eNPCInteractType,iParam1,iParam2,iParam3)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_NPC_InteractOper'
		g_encodeCache['eNPCInteractType'] = eNPCInteractType
		g_encodeCache['iParam1'] = iParam1
		g_encodeCache['iParam2'] = iParam2
		g_encodeCache['iParam3'] = iParam3
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eNPCInteractType)
	kNetStream:WriteInt(iParam1)
	kNetStream:WriteInt(iParam2)
	kNetStream:WriteInt(iParam3)
	return kNetStream,39237
end

function EncodeSendSeGC_ClickNpcInteract(uiChoiceLangID,uiRoleBaseID,uiMapID,uiConditionID,uiMazeTypeID,uiAreaIndex,uiCardID,uiRow,uiColumn)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickNpcInteract'
		g_encodeCache['uiChoiceLangID'] = uiChoiceLangID
		g_encodeCache['uiRoleBaseID'] = uiRoleBaseID
		g_encodeCache['uiMapID'] = uiMapID
		g_encodeCache['uiConditionID'] = uiConditionID
		g_encodeCache['uiMazeTypeID'] = uiMazeTypeID
		g_encodeCache['uiAreaIndex'] = uiAreaIndex
		g_encodeCache['uiCardID'] = uiCardID
		g_encodeCache['uiRow'] = uiRow
		g_encodeCache['uiColumn'] = uiColumn
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiChoiceLangID)
	kNetStream:WriteInt(uiRoleBaseID)
	kNetStream:WriteInt(uiMapID)
	kNetStream:WriteInt(uiConditionID)
	kNetStream:WriteInt(uiMazeTypeID)
	kNetStream:WriteInt(uiAreaIndex)
	kNetStream:WriteInt(uiCardID)
	kNetStream:WriteInt(uiRow)
	kNetStream:WriteInt(uiColumn)
	return kNetStream,39207
end

function EncodeSendSeGC_ClickChoice(uiChoiceLangID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickChoice'
		g_encodeCache['uiChoiceLangID'] = uiChoiceLangID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiChoiceLangID)
	return kNetStream,39185
end

function EncodeSendSeGC_ClickTryInteractWithNpc(uiMapID,uiRoleID,uiMazeBaseID,uiAreaIndex,uiRow,uiColumn)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickTryInteractWithNpc'
		g_encodeCache['uiMapID'] = uiMapID
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiMazeBaseID'] = uiMazeBaseID
		g_encodeCache['uiAreaIndex'] = uiAreaIndex
		g_encodeCache['uiRow'] = uiRow
		g_encodeCache['uiColumn'] = uiColumn
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMapID)
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiMazeBaseID)
	kNetStream:WriteInt(uiAreaIndex)
	kNetStream:WriteInt(uiRow)
	kNetStream:WriteInt(uiColumn)
	return kNetStream,39210
end

function EncodeSendSeGC_ClickAddAttrPoint(uiRoleID,auiValue)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickAddAttrPoint'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['auiValue'] = auiValue
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	for i = 0,RAAPT_NUMS or -1 do
		if i >= RAAPT_NUMS then
			break
		end
		kNetStream:WriteInt(auiValue[i])
	end
	return kNetStream,39180
end

function EncodeSendSeGC_ClickEquipItem(uiRoleID,uiItemID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickEquipItem'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiItemID'] = uiItemID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiItemID)
	return kNetStream,39257
end

function EncodeSendSeGC_ClickUnequipItem(uiRoleID,uiItemID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickUnequipItem'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiItemID'] = uiItemID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiItemID)
	return kNetStream,39222
end

function EncodeSendSeGC_ClickSelectSubmitItem(uiTaskID,uiTaskEdgeID,iNum,auItems)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickSelectSubmitItem'
		g_encodeCache['uiTaskID'] = uiTaskID
		g_encodeCache['uiTaskEdgeID'] = uiTaskEdgeID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['auItems'] = auItems
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTaskID)
	kNetStream:WriteInt(uiTaskEdgeID)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(auItems[i]["uiItemID"])
		kNetStream:WriteInt(auItems[i]["uiItemNum"])
	end
	return kNetStream,39233
end

function EncodeSendSeGC_ClickGameOver(uiParam)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickGameOver'
		g_encodeCache['uiParam'] = uiParam
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiParam)
	return kNetStream,39249
end

function EncodeSendSeGC_ClickScriptArenaBattleStart(uiArenaType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickScriptArenaBattleStart'
		g_encodeCache['uiArenaType'] = uiArenaType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiArenaType)
	return kNetStream,39184
end

function EncodeSendSeGC_ClickCloseScriptArena(uiArenaType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickCloseScriptArena'
		g_encodeCache['uiArenaType'] = uiArenaType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiArenaType)
	return kNetStream,39231
end

function EncodeSendSeGC_ClickCheat(acCheatParam)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickCheat'
		g_encodeCache['acCheatParam'] = acCheatParam
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(acCheatParam)
	return kNetStream,39239
end

function EncodeSendSeGC_ClickPickUpAdvLoot(dwAdvLootCount,akAdvLootDatas)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickPickUpAdvLoot'
		g_encodeCache['dwAdvLootCount'] = dwAdvLootCount
		g_encodeCache['akAdvLootDatas'] = akAdvLootDatas
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwAdvLootCount)
	for i = 0,dwAdvLootCount or -1 do
		if i >= dwAdvLootCount then
			break
		end
		kNetStream:WriteInt(akAdvLootDatas[i]["uiSite"])
		kNetStream:WriteInt(akAdvLootDatas[i]["uiMID"])
		kNetStream:WriteInt(akAdvLootDatas[i]["uiAreaID"])
		kNetStream:WriteInt(akAdvLootDatas[i]["uiAdvLootID"])
		kNetStream:WriteInt(akAdvLootDatas[i]["uiDynamicAdvLootID"])
	end
	return kNetStream,39254
end

function EncodeSendSeGC_ClickItemOpr(eItemOprType,uiRoleID,uiItemID,uiNum,uiChooseNum,adwChooseItem,uiMakerID,uiDynamicAttrID,isPerfect,uiGiveupDynamicAttrID,iItemNum,auiItem,uiMapID,uiMazeID,uiRoleBaseID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickItemOpr'
		g_encodeCache['eItemOprType'] = eItemOprType
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiItemID'] = uiItemID
		g_encodeCache['uiNum'] = uiNum
		g_encodeCache['uiChooseNum'] = uiChooseNum
		g_encodeCache['adwChooseItem'] = adwChooseItem
		g_encodeCache['uiMakerID'] = uiMakerID
		g_encodeCache['uiDynamicAttrID'] = uiDynamicAttrID
		g_encodeCache['isPerfect'] = isPerfect
		g_encodeCache['uiGiveupDynamicAttrID'] = uiGiveupDynamicAttrID
		g_encodeCache['iItemNum'] = iItemNum
		g_encodeCache['auiItem'] = auiItem
		g_encodeCache['uiMapID'] = uiMapID
		g_encodeCache['uiMazeID'] = uiMazeID
		g_encodeCache['uiRoleBaseID'] = uiRoleBaseID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eItemOprType)
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiItemID)
	kNetStream:WriteInt(uiNum)
	kNetStream:WriteInt(uiChooseNum)
	for i = 0,uiChooseNum or -1 do
		if i >= uiChooseNum then
			break
		end
		kNetStream:WriteInt(adwChooseItem[i])
	end
	kNetStream:WriteInt(uiMakerID)
	kNetStream:WriteInt(uiDynamicAttrID)
	kNetStream:WriteByte(isPerfect)
	kNetStream:WriteInt(uiGiveupDynamicAttrID)
	kNetStream:WriteInt(iItemNum)
	for i = 0,iItemNum or -1 do
		if i >= iItemNum then
			break
		end
		kNetStream:WriteInt(auiItem[i])
	end
	kNetStream:WriteInt(uiMapID)
	kNetStream:WriteInt(uiMazeID)
	kNetStream:WriteInt(uiRoleBaseID)
	return kNetStream,39174
end

function EncodeSendSeGC_Click_InCompleteBookBox(uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_InCompleteBookBox'
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39195
end

function EncodeSendSeGC_Click_ShopOpr(eShopType,uiShopID,uiNum,akItemData,uiMapID,uiMazeID,uiRoleBaseID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_ShopOpr'
		g_encodeCache['eShopType'] = eShopType
		g_encodeCache['uiShopID'] = uiShopID
		g_encodeCache['uiNum'] = uiNum
		g_encodeCache['akItemData'] = akItemData
		g_encodeCache['uiMapID'] = uiMapID
		g_encodeCache['uiMazeID'] = uiMazeID
		g_encodeCache['uiRoleBaseID'] = uiRoleBaseID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eShopType)
	kNetStream:WriteInt(uiShopID)
	kNetStream:WriteInt(uiNum)
	for i = 0,uiNum or -1 do
		if i >= uiNum then
			break
		end
		kNetStream:WriteInt(akItemData[i]["uiItemID"])
		kNetStream:WriteInt(akItemData[i]["uiItemNum"])
	end
	kNetStream:WriteInt(uiMapID)
	kNetStream:WriteInt(uiMazeID)
	kNetStream:WriteInt(uiRoleBaseID)
	return kNetStream,39202
end

function EncodeSendSeGC_Click_Exchange_Silver(uiGoldNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Exchange_Silver'
		g_encodeCache['uiGoldNum'] = uiGoldNum
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiGoldNum)
	return kNetStream,39171
end

function EncodeSendSeGC_ClickCreateRole(uiTypeID,acName,uiModelID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickCreateRole'
		g_encodeCache['uiTypeID'] = uiTypeID
		g_encodeCache['acName'] = acName
		g_encodeCache['uiModelID'] = uiModelID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTypeID)
	kNetStream:WriteString(acName)
	kNetStream:WriteInt(uiModelID)
	return kNetStream,39188
end

function EncodeSendSeGC_ClickCreateBaby(uiTypeID,acName)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickCreateBaby'
		g_encodeCache['uiTypeID'] = uiTypeID
		g_encodeCache['acName'] = acName
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTypeID)
	kNetStream:WriteString(acName)
	return kNetStream,39203
end

function EncodeSendSeGC_ClickCreateRoleRandomAttr(uiTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickCreateRoleRandomAttr'
		g_encodeCache['uiTypeID'] = uiTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTypeID)
	return kNetStream,39183
end

function EncodeSendSeGC_ClickRandomGift(uiType,uiRoleID,uiNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickRandomGift'
		g_encodeCache['uiType'] = uiType
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiNum'] = uiNum
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiType)
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiNum)
	return kNetStream,39212
end

function EncodeSendSeGC_ClickRoleAddGift(uiRoleID,uiGiftTypeID,eAddType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickRoleAddGift'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiGiftTypeID'] = uiGiftTypeID
		g_encodeCache['eAddType'] = eAddType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiGiftTypeID)
	kNetStream:WriteInt(eAddType)
	return kNetStream,39214
end

function EncodeSendSeGC_ClickRoleDelGift(uiRoleID,uiGiftID,uiGiftTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickRoleDelGift'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiGiftID'] = uiGiftID
		g_encodeCache['uiGiftTypeID'] = uiGiftTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiGiftID)
	kNetStream:WriteInt(uiGiftTypeID)
	return kNetStream,39201
end

function EncodeSendSeGC_ClickRandomWishRewards(uiType,uiRoleID,uiWishTaskID,uiNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickRandomWishRewards'
		g_encodeCache['uiType'] = uiType
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiWishTaskID'] = uiWishTaskID
		g_encodeCache['uiNum'] = uiNum
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiType)
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiWishTaskID)
	kNetStream:WriteInt(uiNum)
	return kNetStream,39198
end

function EncodeSendSeGC_ClickChooseWishRewards(uiRoleID,uiWishTaskID,uiWishRewardID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickChooseWishRewards'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiWishTaskID'] = uiWishTaskID
		g_encodeCache['uiWishRewardID'] = uiWishRewardID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiWishTaskID)
	kNetStream:WriteInt(uiWishRewardID)
	return kNetStream,39242
end

function EncodeSendSeGC_ClickTaskTag_Set(uiTypeID,uiValue)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickTaskTag_Set'
		g_encodeCache['uiTypeID'] = uiTypeID
		g_encodeCache['uiValue'] = uiValue
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTypeID)
	kNetStream:WriteInt(uiValue)
	return kNetStream,39256
end

function EncodeSendSeGC_ClickChoosePlatItem(uiScriptID,bEnter,iItemNum,auiItem)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickChoosePlatItem'
		g_encodeCache['uiScriptID'] = uiScriptID
		g_encodeCache['bEnter'] = bEnter
		g_encodeCache['iItemNum'] = iItemNum
		g_encodeCache['auiItem'] = auiItem
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiScriptID)
	kNetStream:WriteByte(bEnter)
	kNetStream:WriteInt(iItemNum)
	for i = 0,iItemNum or -1 do
		if i >= iItemNum then
			break
		end
		kNetStream:WriteInt(auiItem[i])
	end
	return kNetStream,39266
end

function EncodeSendSeGC_ClickAchievePoint(uiFree)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickAchievePoint'
		g_encodeCache['uiFree'] = uiFree
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFree)
	return kNetStream,39215
end

function EncodeSendSeGC_ClickMaze(eMazeOprType,uiMazeID,uiAreaIndex,uiRow,uiColumn)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickMaze'
		g_encodeCache['eMazeOprType'] = eMazeOprType
		g_encodeCache['uiMazeID'] = uiMazeID
		g_encodeCache['uiAreaIndex'] = uiAreaIndex
		g_encodeCache['uiRow'] = uiRow
		g_encodeCache['uiColumn'] = uiColumn
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eMazeOprType)
	kNetStream:WriteInt(uiMazeID)
	kNetStream:WriteInt(uiAreaIndex)
	kNetStream:WriteInt(uiRow)
	kNetStream:WriteInt(uiColumn)
	return kNetStream,39263
end

function EncodeSendSeGC_ClickWeekDiff(uiChooseDiff)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickWeekDiff'
		g_encodeCache['uiChooseDiff'] = uiChooseDiff
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiChooseDiff)
	return kNetStream,39268
end

function EncodeSendSeGC_ClickChangeEmBattleMartial(uiRoleUID,kChooseMartialInfo,uiChooseIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickChangeEmBattleMartial'
		g_encodeCache['uiRoleUID'] = uiRoleUID
		g_encodeCache['kChooseMartialInfo'] = kChooseMartialInfo
		g_encodeCache['uiChooseIndex'] = uiChooseIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleUID)
	kNetStream:WriteInt(kChooseMartialInfo["dwUID"])
	kNetStream:WriteInt(kChooseMartialInfo["dwTypeID"])
	kNetStream:WriteInt(kChooseMartialInfo["dwIndex"])
	kNetStream:WriteInt(uiChooseIndex)
	return kNetStream,39251
end

function EncodeSendSeGC_ClickSetEmBattleSubRole(uiRoleUID,uiSubRoleUID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickSetEmBattleSubRole'
		g_encodeCache['uiRoleUID'] = uiRoleUID
		g_encodeCache['uiSubRoleUID'] = uiSubRoleUID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleUID)
	kNetStream:WriteInt(uiSubRoleUID)
	return kNetStream,39219
end

function EncodeSendSeGC_ClickUnlockRole(uiTitleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickUnlockRole'
		g_encodeCache['uiTitleID'] = uiTitleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTitleID)
	return kNetStream,39200
end

function EncodeSendSeGC_ClickUnlockSkin(uiTitleID,uiIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickUnlockSkin'
		g_encodeCache['uiTitleID'] = uiTitleID
		g_encodeCache['uiIndex'] = uiIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTitleID)
	kNetStream:WriteInt(uiIndex)
	return kNetStream,39246
end

function EncodeSendSeGC_ClickSetTitle(uiTitleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickSetTitle'
		g_encodeCache['uiTitleID'] = uiTitleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTitleID)
	return kNetStream,39187
end

function EncodeSendSeGC_ClickForgetMartial(uiRoleID,uiMartialTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickForgetMartial'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiMartialTypeID'] = uiMartialTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiMartialTypeID)
	return kNetStream,39220
end

function EncodeSendSeGC_ClickRoleDisguise(uiRoleID,uiDisguiseItemTypeID,bUseItem)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickRoleDisguise'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiDisguiseItemTypeID'] = uiDisguiseItemTypeID
		g_encodeCache['bUseItem'] = bUseItem
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiDisguiseItemTypeID)
	kNetStream:WriteByte(bUseItem)
	return kNetStream,39235
end

function EncodeSendSeGC_ClickFinalBattleEnterCity(uiFinalBattleCityID,bIsInCity)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickFinalBattleEnterCity'
		g_encodeCache['uiFinalBattleCityID'] = uiFinalBattleCityID
		g_encodeCache['bIsInCity'] = bIsInCity
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFinalBattleCityID)
	kNetStream:WriteByte(bIsInCity)
	return kNetStream,39181
end

function EncodeSendSeGC_ClickFinalBattleQuitCity(uiFinalBattleCityID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickFinalBattleQuitCity'
		g_encodeCache['uiFinalBattleCityID'] = uiFinalBattleCityID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFinalBattleCityID)
	return kNetStream,39267
end

function EncodeSendSeGC_ClickFinalBattleOpenBox(uiFinalBattleCityID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickFinalBattleOpenBox'
		g_encodeCache['uiFinalBattleCityID'] = uiFinalBattleCityID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFinalBattleCityID)
	return kNetStream,39172
end

function EncodeSendSeGC_ClickBabyLearn(uiBabyRoleID,uiMasterTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickBabyLearn'
		g_encodeCache['uiBabyRoleID'] = uiBabyRoleID
		g_encodeCache['uiMasterTypeID'] = uiMasterTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiBabyRoleID)
	kNetStream:WriteInt(uiMasterTypeID)
	return kNetStream,39255
end

function EncodeSendSeGC_ClickHighTowerEmbattleOver(bSubmit)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickHighTowerEmbattleOver'
		g_encodeCache['bSubmit'] = bSubmit
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bSubmit)
	return kNetStream,39229
end

function EncodeSendSeGC_ClickClearInteractInfo(uiFree)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickClearInteractInfo'
		g_encodeCache['uiFree'] = uiFree
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFree)
	return kNetStream,39191
end

function EncodeSendSeGC_ClickFinalBattleAntiJamma(uiFree)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickFinalBattleAntiJamma'
		g_encodeCache['uiFree'] = uiFree
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFree)
	return kNetStream,39250
end

function EncodeSendSeGC_ClickChooseRoleID(uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickChooseRoleID'
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39182
end

function EncodeSendSeGC_ClickGetBabyClose(uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickGetBabyClose'
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39178
end

function EncodeSendSeGC_ClickQueryResDropActivityInfo(eQueryType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickQueryResDropActivityInfo'
		g_encodeCache['eQueryType'] = eQueryType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eQueryType)
	return kNetStream,39226
end

function EncodeSendSeGC_ClickExchangeCollectActivity(uiCollectResDropActivityID,uiCollectActivityIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickExchangeCollectActivity'
		g_encodeCache['uiCollectResDropActivityID'] = uiCollectResDropActivityID
		g_encodeCache['uiCollectActivityIndex'] = uiCollectActivityIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiCollectResDropActivityID)
	kNetStream:WriteInt(uiCollectActivityIndex)
	return kNetStream,39232
end

function EncodeSendSeGC_ClickDialog(uiDialogType,uiTask,uiTaskRet,uiRetValue,uiTaskRet2,uiRetValue2)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickDialog'
		g_encodeCache['uiDialogType'] = uiDialogType
		g_encodeCache['uiTask'] = uiTask
		g_encodeCache['uiTaskRet'] = uiTaskRet
		g_encodeCache['uiRetValue'] = uiRetValue
		g_encodeCache['uiTaskRet2'] = uiTaskRet2
		g_encodeCache['uiRetValue2'] = uiRetValue2
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiDialogType)
	kNetStream:WriteInt(uiTask)
	kNetStream:WriteInt(uiTaskRet)
	kNetStream:WriteInt(uiRetValue)
	kNetStream:WriteInt(uiTaskRet2)
	kNetStream:WriteInt(uiRetValue2)
	return kNetStream,39176
end

function EncodeSendSeGC_SetNickName(uiNpcID,acName)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_SetNickName'
		g_encodeCache['uiNpcID'] = uiNpcID
		g_encodeCache['acName'] = acName
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiNpcID)
	kNetStream:WriteString(acName)
	return kNetStream,39218
end

function EncodeSendSeGC_SetClanBranchState(uiClanID,uiClanType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_SetClanBranchState'
		g_encodeCache['uiClanID'] = uiClanID
		g_encodeCache['uiClanType'] = uiClanType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanID)
	kNetStream:WriteInt(uiClanType)
	return kNetStream,39252
end

function EncodeSendSeGC_KillClanBranch(uiClanTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_KillClanBranch'
		g_encodeCache['uiClanTypeID'] = uiClanTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanTypeID)
	return kNetStream,39248
end

function EncodeSendSeGC_Display_Begin(uiParam)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Begin'
		g_encodeCache['uiParam'] = uiParam
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiParam)
	return kNetStream,39259
end

function EncodeSendSeGC_Display_SubmitItem_Select(uiConditionNum,acCondDescID,iNum,auItems)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_SubmitItem_Select'
		g_encodeCache['uiConditionNum'] = uiConditionNum
		g_encodeCache['acCondDescID'] = acCondDescID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['auItems'] = auItems
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiConditionNum)
	kNetStream:WriteInt(acCondDescID)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(auItems[i])
	end
	return kNetStream,39194
end

function EncodeSendSeGC_Display_Update_Delegation_State(uiClanTaskCount,auiClanIDList,auiHasStartClanDelegation,uiCityTaskCount,auiCityIDList,auiHasStartCityDelegation)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Update_Delegation_State'
		g_encodeCache['uiClanTaskCount'] = uiClanTaskCount
		g_encodeCache['auiClanIDList'] = auiClanIDList
		g_encodeCache['auiHasStartClanDelegation'] = auiHasStartClanDelegation
		g_encodeCache['uiCityTaskCount'] = uiCityTaskCount
		g_encodeCache['auiCityIDList'] = auiCityIDList
		g_encodeCache['auiHasStartCityDelegation'] = auiHasStartCityDelegation
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanTaskCount)
	for i = 0,uiClanTaskCount or -1 do
		if i >= uiClanTaskCount then
			break
		end
		kNetStream:WriteInt(auiClanIDList[i])
	end
	for i = 0,uiClanTaskCount or -1 do
		if i >= uiClanTaskCount then
			break
		end
		kNetStream:WriteInt(auiHasStartClanDelegation[i])
	end
	kNetStream:WriteInt(uiCityTaskCount)
	for i = 0,uiCityTaskCount or -1 do
		if i >= uiCityTaskCount then
			break
		end
		kNetStream:WriteInt(auiCityIDList[i])
	end
	for i = 0,uiCityTaskCount or -1 do
		if i >= uiCityTaskCount then
			break
		end
		kNetStream:WriteInt(auiHasStartCityDelegation[i])
	end
	return kNetStream,39244
end

function EncodeSendSeGC_ServerFriendOpenTreasure(uiScriptID,uiTreasureID,uiMazeID,uiFromID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ServerFriendOpenTreasure'
		g_encodeCache['uiScriptID'] = uiScriptID
		g_encodeCache['uiTreasureID'] = uiTreasureID
		g_encodeCache['uiMazeID'] = uiMazeID
		g_encodeCache['uiFromID'] = uiFromID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiScriptID)
	kNetStream:WriteInt(uiTreasureID)
	kNetStream:WriteInt(uiMazeID)
	kNetStream:WriteInt(uiFromID)
	return kNetStream,39177
end

function EncodeSendSeGC_WeekRoundEnd(uiEndType,uiEndShowType,uiCurScriptID,uiCurDiff,uiTotalScore,uiItemConvertMeridians,uiTakeOutBabyID,uiDontTakeOut,iStoryItemCount,kStoryItem,iAwardItemCount,kAwardItem,iScriptEndItemCount,kScriptEndItem)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_WeekRoundEnd'
		g_encodeCache['uiEndType'] = uiEndType
		g_encodeCache['uiEndShowType'] = uiEndShowType
		g_encodeCache['uiCurScriptID'] = uiCurScriptID
		g_encodeCache['uiCurDiff'] = uiCurDiff
		g_encodeCache['uiTotalScore'] = uiTotalScore
		g_encodeCache['uiItemConvertMeridians'] = uiItemConvertMeridians
		g_encodeCache['uiTakeOutBabyID'] = uiTakeOutBabyID
		g_encodeCache['uiDontTakeOut'] = uiDontTakeOut
		g_encodeCache['iStoryItemCount'] = iStoryItemCount
		g_encodeCache['kStoryItem'] = kStoryItem
		g_encodeCache['iAwardItemCount'] = iAwardItemCount
		g_encodeCache['kAwardItem'] = kAwardItem
		g_encodeCache['iScriptEndItemCount'] = iScriptEndItemCount
		g_encodeCache['kScriptEndItem'] = kScriptEndItem
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiEndType)
	kNetStream:WriteInt(uiEndShowType)
	kNetStream:WriteInt(uiCurScriptID)
	kNetStream:WriteInt(uiCurDiff)
	kNetStream:WriteInt(uiTotalScore)
	kNetStream:WriteInt(uiItemConvertMeridians)
	kNetStream:WriteInt(uiTakeOutBabyID)
	kNetStream:WriteInt(uiDontTakeOut)
	kNetStream:WriteInt(iStoryItemCount)
	for i = 0,iStoryItemCount or -1 do
		if i >= iStoryItemCount then
			break
		end
		kNetStream:WriteInt(kStoryItem[i]["uiEnumType"])
		kNetStream:WriteDword64(kStoryItem[i]["uiCompleteNum"])
	end
	kNetStream:WriteInt(iAwardItemCount)
	for i = 0,iAwardItemCount or -1 do
		if i >= iAwardItemCount then
			break
		end
		kNetStream:WriteInt(kAwardItem[i]["uiRewardType"])
		kNetStream:WriteInt(kAwardItem[i]["uiBaseID"])
		kNetStream:WriteInt(kAwardItem[i]["uiNum"])
	end
	kNetStream:WriteInt(iScriptEndItemCount)
	for i = 0,iScriptEndItemCount or -1 do
		if i >= iScriptEndItemCount then
			break
		end
		kNetStream:WriteInt(kScriptEndItem[i]["uiScriptEndType"])
		kNetStream:WriteInt(kScriptEndItem[i]["uiNum"])
	end
	return kNetStream,39247
end

function EncodeSendSeGC_UpdateWeekRoundData(iStoryItemCount,kStoryItem)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_UpdateWeekRoundData'
		g_encodeCache['iStoryItemCount'] = iStoryItemCount
		g_encodeCache['kStoryItem'] = kStoryItem
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iStoryItemCount)
	for i = 0,iStoryItemCount or -1 do
		if i >= iStoryItemCount then
			break
		end
		kNetStream:WriteInt(kStoryItem[i]["uiEnumType"])
		kNetStream:WriteDword64(kStoryItem[i]["uiCompleteNum"])
	end
	return kNetStream,39228
end

function EncodeSendSeGC_StartScriptArena(uiArenaType,uiTaskTag,iCount,auiBaseID,iRandCount,auiRandBaseID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_StartScriptArena'
		g_encodeCache['uiArenaType'] = uiArenaType
		g_encodeCache['uiTaskTag'] = uiTaskTag
		g_encodeCache['iCount'] = iCount
		g_encodeCache['auiBaseID'] = auiBaseID
		g_encodeCache['iRandCount'] = iRandCount
		g_encodeCache['auiRandBaseID'] = auiRandBaseID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiArenaType)
	kNetStream:WriteInt(uiTaskTag)
	kNetStream:WriteInt(iCount)
	for i = 0,iCount or -1 do
		if i >= iCount then
			break
		end
		kNetStream:WriteInt(auiBaseID[i])
	end
	kNetStream:WriteInt(iRandCount)
	for i = 0,iRandCount or -1 do
		if i >= iRandCount then
			break
		end
		kNetStream:WriteInt(auiRandBaseID[i])
	end
	return kNetStream,39196
end

function EncodeSendSeGC_ScriptArenaBattleEnd(uiTagValue)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ScriptArenaBattleEnd'
		g_encodeCache['uiTagValue'] = uiTagValue
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTagValue)
	return kNetStream,39205
end

function EncodeSendSeGC_Display_LogicDebugInfo(uiMemorySize,uiInstRoleNums,uiNpcRoleNums,uiNpcItemNums,uiMartialNums,uiShopNums,uiTaskNums,uiGiftNums,uiCityNums,uiMapNums,uiAttrsNums,uiAchieveNums,uiEvolutionNums,uiMazeGridNums,uiMazeCardNums,uiMazeAreaNums,uiInstRoleMemSize,uiNpcRoleMemSize,uiNpcItemMemSize,uiMartialMemSize,uiShopMemSize,uiTaskMemSize,uiGiftMemSize,uiCityMemSize,uiMapMemSize,uiAttrsMemSize,uiAchieveMemSize,uiEvolutionMemSize,uiMazeGridMemSize,uiMazeCardMemSize,uiMazeAreaMemSize,uiBattleMemSize,uiInstRoleUpdateMemSize,uiNpcRoleUpdateMemSize,uiNpcItemUpdateMemSize,uiMartialUpdateMemSize,uiShopUpdateMemSize,uiTaskUpdateMemSize,uiGiftUpdateMemSize,uiCityUpdateMemSize,uiMapUpdateMemSize,uiAttrsUpdateMemSize,uiAchieveUpdateMemSize,uiEvolutionUpdateMemSize,uiMazeGridUpdateMemSize,uiMazeCardUpdateMemSize,uiMazeAreaUpdateMemSize,uiInstRoleInsertMemSize,uiNpcRoleInsertMemSize,uiNpcItemInsertMemSize,uiMartialInsertMemSize,uiShopInsertMemSize,uiTaskInsertMemSize,uiGiftInsertMemSize,uiCityInsertMemSize,uiMapInsertMemSize,uiAttrsInsertMemSize,uiAchieveInsertMemSize,uiEvolutionInsertMemSize,uiMazeGridInsertMemSize,uiMazeCardInsertMemSize,uiMazeAreaInsertMemSize,uiSerializeSize,uiGenerateShowSize,uiCostTime,iFuncCallNums,akFuncCallInfos)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_LogicDebugInfo'
		g_encodeCache['uiMemorySize'] = uiMemorySize
		g_encodeCache['uiInstRoleNums'] = uiInstRoleNums
		g_encodeCache['uiNpcRoleNums'] = uiNpcRoleNums
		g_encodeCache['uiNpcItemNums'] = uiNpcItemNums
		g_encodeCache['uiMartialNums'] = uiMartialNums
		g_encodeCache['uiShopNums'] = uiShopNums
		g_encodeCache['uiTaskNums'] = uiTaskNums
		g_encodeCache['uiGiftNums'] = uiGiftNums
		g_encodeCache['uiCityNums'] = uiCityNums
		g_encodeCache['uiMapNums'] = uiMapNums
		g_encodeCache['uiAttrsNums'] = uiAttrsNums
		g_encodeCache['uiAchieveNums'] = uiAchieveNums
		g_encodeCache['uiEvolutionNums'] = uiEvolutionNums
		g_encodeCache['uiMazeGridNums'] = uiMazeGridNums
		g_encodeCache['uiMazeCardNums'] = uiMazeCardNums
		g_encodeCache['uiMazeAreaNums'] = uiMazeAreaNums
		g_encodeCache['uiInstRoleMemSize'] = uiInstRoleMemSize
		g_encodeCache['uiNpcRoleMemSize'] = uiNpcRoleMemSize
		g_encodeCache['uiNpcItemMemSize'] = uiNpcItemMemSize
		g_encodeCache['uiMartialMemSize'] = uiMartialMemSize
		g_encodeCache['uiShopMemSize'] = uiShopMemSize
		g_encodeCache['uiTaskMemSize'] = uiTaskMemSize
		g_encodeCache['uiGiftMemSize'] = uiGiftMemSize
		g_encodeCache['uiCityMemSize'] = uiCityMemSize
		g_encodeCache['uiMapMemSize'] = uiMapMemSize
		g_encodeCache['uiAttrsMemSize'] = uiAttrsMemSize
		g_encodeCache['uiAchieveMemSize'] = uiAchieveMemSize
		g_encodeCache['uiEvolutionMemSize'] = uiEvolutionMemSize
		g_encodeCache['uiMazeGridMemSize'] = uiMazeGridMemSize
		g_encodeCache['uiMazeCardMemSize'] = uiMazeCardMemSize
		g_encodeCache['uiMazeAreaMemSize'] = uiMazeAreaMemSize
		g_encodeCache['uiBattleMemSize'] = uiBattleMemSize
		g_encodeCache['uiInstRoleUpdateMemSize'] = uiInstRoleUpdateMemSize
		g_encodeCache['uiNpcRoleUpdateMemSize'] = uiNpcRoleUpdateMemSize
		g_encodeCache['uiNpcItemUpdateMemSize'] = uiNpcItemUpdateMemSize
		g_encodeCache['uiMartialUpdateMemSize'] = uiMartialUpdateMemSize
		g_encodeCache['uiShopUpdateMemSize'] = uiShopUpdateMemSize
		g_encodeCache['uiTaskUpdateMemSize'] = uiTaskUpdateMemSize
		g_encodeCache['uiGiftUpdateMemSize'] = uiGiftUpdateMemSize
		g_encodeCache['uiCityUpdateMemSize'] = uiCityUpdateMemSize
		g_encodeCache['uiMapUpdateMemSize'] = uiMapUpdateMemSize
		g_encodeCache['uiAttrsUpdateMemSize'] = uiAttrsUpdateMemSize
		g_encodeCache['uiAchieveUpdateMemSize'] = uiAchieveUpdateMemSize
		g_encodeCache['uiEvolutionUpdateMemSize'] = uiEvolutionUpdateMemSize
		g_encodeCache['uiMazeGridUpdateMemSize'] = uiMazeGridUpdateMemSize
		g_encodeCache['uiMazeCardUpdateMemSize'] = uiMazeCardUpdateMemSize
		g_encodeCache['uiMazeAreaUpdateMemSize'] = uiMazeAreaUpdateMemSize
		g_encodeCache['uiInstRoleInsertMemSize'] = uiInstRoleInsertMemSize
		g_encodeCache['uiNpcRoleInsertMemSize'] = uiNpcRoleInsertMemSize
		g_encodeCache['uiNpcItemInsertMemSize'] = uiNpcItemInsertMemSize
		g_encodeCache['uiMartialInsertMemSize'] = uiMartialInsertMemSize
		g_encodeCache['uiShopInsertMemSize'] = uiShopInsertMemSize
		g_encodeCache['uiTaskInsertMemSize'] = uiTaskInsertMemSize
		g_encodeCache['uiGiftInsertMemSize'] = uiGiftInsertMemSize
		g_encodeCache['uiCityInsertMemSize'] = uiCityInsertMemSize
		g_encodeCache['uiMapInsertMemSize'] = uiMapInsertMemSize
		g_encodeCache['uiAttrsInsertMemSize'] = uiAttrsInsertMemSize
		g_encodeCache['uiAchieveInsertMemSize'] = uiAchieveInsertMemSize
		g_encodeCache['uiEvolutionInsertMemSize'] = uiEvolutionInsertMemSize
		g_encodeCache['uiMazeGridInsertMemSize'] = uiMazeGridInsertMemSize
		g_encodeCache['uiMazeCardInsertMemSize'] = uiMazeCardInsertMemSize
		g_encodeCache['uiMazeAreaInsertMemSize'] = uiMazeAreaInsertMemSize
		g_encodeCache['uiSerializeSize'] = uiSerializeSize
		g_encodeCache['uiGenerateShowSize'] = uiGenerateShowSize
		g_encodeCache['uiCostTime'] = uiCostTime
		g_encodeCache['iFuncCallNums'] = iFuncCallNums
		g_encodeCache['akFuncCallInfos'] = akFuncCallInfos
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMemorySize)
	kNetStream:WriteInt(uiInstRoleNums)
	kNetStream:WriteInt(uiNpcRoleNums)
	kNetStream:WriteInt(uiNpcItemNums)
	kNetStream:WriteInt(uiMartialNums)
	kNetStream:WriteInt(uiShopNums)
	kNetStream:WriteInt(uiTaskNums)
	kNetStream:WriteInt(uiGiftNums)
	kNetStream:WriteInt(uiCityNums)
	kNetStream:WriteInt(uiMapNums)
	kNetStream:WriteInt(uiAttrsNums)
	kNetStream:WriteInt(uiAchieveNums)
	kNetStream:WriteInt(uiEvolutionNums)
	kNetStream:WriteInt(uiMazeGridNums)
	kNetStream:WriteInt(uiMazeCardNums)
	kNetStream:WriteInt(uiMazeAreaNums)
	kNetStream:WriteInt(uiInstRoleMemSize)
	kNetStream:WriteInt(uiNpcRoleMemSize)
	kNetStream:WriteInt(uiNpcItemMemSize)
	kNetStream:WriteInt(uiMartialMemSize)
	kNetStream:WriteInt(uiShopMemSize)
	kNetStream:WriteInt(uiTaskMemSize)
	kNetStream:WriteInt(uiGiftMemSize)
	kNetStream:WriteInt(uiCityMemSize)
	kNetStream:WriteInt(uiMapMemSize)
	kNetStream:WriteInt(uiAttrsMemSize)
	kNetStream:WriteInt(uiAchieveMemSize)
	kNetStream:WriteInt(uiEvolutionMemSize)
	kNetStream:WriteInt(uiMazeGridMemSize)
	kNetStream:WriteInt(uiMazeCardMemSize)
	kNetStream:WriteInt(uiMazeAreaMemSize)
	kNetStream:WriteInt(uiBattleMemSize)
	kNetStream:WriteInt(uiInstRoleUpdateMemSize)
	kNetStream:WriteInt(uiNpcRoleUpdateMemSize)
	kNetStream:WriteInt(uiNpcItemUpdateMemSize)
	kNetStream:WriteInt(uiMartialUpdateMemSize)
	kNetStream:WriteInt(uiShopUpdateMemSize)
	kNetStream:WriteInt(uiTaskUpdateMemSize)
	kNetStream:WriteInt(uiGiftUpdateMemSize)
	kNetStream:WriteInt(uiCityUpdateMemSize)
	kNetStream:WriteInt(uiMapUpdateMemSize)
	kNetStream:WriteInt(uiAttrsUpdateMemSize)
	kNetStream:WriteInt(uiAchieveUpdateMemSize)
	kNetStream:WriteInt(uiEvolutionUpdateMemSize)
	kNetStream:WriteInt(uiMazeGridUpdateMemSize)
	kNetStream:WriteInt(uiMazeCardUpdateMemSize)
	kNetStream:WriteInt(uiMazeAreaUpdateMemSize)
	kNetStream:WriteInt(uiInstRoleInsertMemSize)
	kNetStream:WriteInt(uiNpcRoleInsertMemSize)
	kNetStream:WriteInt(uiNpcItemInsertMemSize)
	kNetStream:WriteInt(uiMartialInsertMemSize)
	kNetStream:WriteInt(uiShopInsertMemSize)
	kNetStream:WriteInt(uiTaskInsertMemSize)
	kNetStream:WriteInt(uiGiftInsertMemSize)
	kNetStream:WriteInt(uiCityInsertMemSize)
	kNetStream:WriteInt(uiMapInsertMemSize)
	kNetStream:WriteInt(uiAttrsInsertMemSize)
	kNetStream:WriteInt(uiAchieveInsertMemSize)
	kNetStream:WriteInt(uiEvolutionInsertMemSize)
	kNetStream:WriteInt(uiMazeGridInsertMemSize)
	kNetStream:WriteInt(uiMazeCardInsertMemSize)
	kNetStream:WriteInt(uiMazeAreaInsertMemSize)
	kNetStream:WriteInt(uiSerializeSize)
	kNetStream:WriteInt(uiGenerateShowSize)
	kNetStream:WriteInt(uiCostTime)
	kNetStream:WriteInt(iFuncCallNums)
	for i = 0,iFuncCallNums or -1 do
		if i >= iFuncCallNums then
			break
		end
		kNetStream:WriteString(akFuncCallInfos[i]["acFuncName"])
		kNetStream:WriteInt(akFuncCallInfos[i]["uiCallTimes"])
		kNetStream:WriteInt(akFuncCallInfos[i]["uiCallCostTime"])
	end
	return kNetStream,39223
end

function EncodeSendSeGC_Display_SystemInfo(eSysInfoType,kContent)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_SystemInfo'
		g_encodeCache['eSysInfoType'] = eSysInfoType
		g_encodeCache['kContent'] = kContent
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eSysInfoType)
	kNetStream:WriteString(kContent)
	return kNetStream,39245
end

function EncodeSendSeGC_Display_Dialog(kContent)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Dialog'
		g_encodeCache['kContent'] = kContent
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(kContent)
	return kNetStream,39192
end

function EncodeSendSeGC_Display_Select(iNum,akContent)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Select'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akContent'] = akContent
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteString(akContent[i]["acContent"])
	end
	return kNetStream,39224
end

function EncodeSendSeGC_Display_MapMove(uiMapID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MapMove'
		g_encodeCache['uiMapID'] = uiMapID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMapID)
	return kNetStream,39265
end

function EncodeSendSeGC_Display_GameData(eCurState,eCurUIState,uiParam1,uiParam2)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_GameData'
		g_encodeCache['eCurState'] = eCurState
		g_encodeCache['eCurUIState'] = eCurUIState
		g_encodeCache['uiParam1'] = uiParam1
		g_encodeCache['uiParam2'] = uiParam2
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eCurState)
	kNetStream:WriteInt(eCurUIState)
	kNetStream:WriteInt(uiParam1)
	kNetStream:WriteInt(uiParam2)
	return kNetStream,39243
end

function EncodeSendSeGC_Display_RoleCreate(uiID,bNewRole)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleCreate'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['bNewRole'] = bNewRole
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteByte(bNewRole)
	return kNetStream,39206
end

function EncodeSendSeGC_Display_RoleDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39230
end

function EncodeSendSeGC_Display_NpcUpdate(uiID,kNpcData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_NpcUpdate'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['kNpcData'] = kNpcData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(kNpcData["uiTypeID"])
	kNetStream:WriteInt(kNpcData["uiIndex"])
	kNetStream:WriteInt(kNpcData["iGoodEvil"])
	kNetStream:WriteInt(kNpcData["uiStaticItemsFlag"])
	kNetStream:WriteInt(kNpcData["uiStaticEquipsFlag"])
	return kNetStream,39170
end

function EncodeSendSeGC_Display_NpcDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_NpcDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39258
end

function EncodeSendSeGC_Display_MainRoleInfo(uiInfoNum,akInfos)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MainRoleInfo'
		g_encodeCache['uiInfoNum'] = uiInfoNum
		g_encodeCache['akInfos'] = akInfos
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiInfoNum)
	for i = 0,uiInfoNum or -1 do
		if i >= uiInfoNum then
			break
		end
		kNetStream:WriteInt(akInfos[i]["uiDataType"])
		kNetStream:WriteInt(akInfos[i]["uiValue"])
	end
	return kNetStream,39190
end

function EncodeSendSeGC_Display_TeamInfo(iTeammatesNum,auiTeammates)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TeamInfo'
		g_encodeCache['iTeammatesNum'] = iTeammatesNum
		g_encodeCache['auiTeammates'] = auiTeammates
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iTeammatesNum)
	for i = 0,iTeammatesNum or -1 do
		if i >= iTeammatesNum then
			break
		end
		kNetStream:WriteInt(auiTeammates[i])
	end
	return kNetStream,39253
end

function EncodeSendSeGC_Display_MainRoleName(kName)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MainRoleName'
		g_encodeCache['kName'] = kName
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(kName)
	return kNetStream,39241
end

function EncodeSendSeGC_Display_MainRolePetInfo(iMainRoleID,iTotalNum,iPetsNum,auiPets)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MainRolePetInfo'
		g_encodeCache['iMainRoleID'] = iMainRoleID
		g_encodeCache['iTotalNum'] = iTotalNum
		g_encodeCache['iPetsNum'] = iPetsNum
		g_encodeCache['auiPets'] = auiPets
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iMainRoleID)
	kNetStream:WriteInt(iTotalNum)
	kNetStream:WriteInt(iPetsNum)
	for i = 0,iPetsNum or -1 do
		if i >= iPetsNum then
			break
		end
		kNetStream:WriteInt(auiPets[i]["uiBaseID"])
		kNetStream:WriteInt(auiPets[i]["uiFragment"])
	end
	return kNetStream,39221
end

function EncodeSendSeGC_Display_MainRoleNickInfo(iNicksNum,auiNicks)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MainRoleNickInfo'
		g_encodeCache['iNicksNum'] = iNicksNum
		g_encodeCache['auiNicks'] = auiNicks
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNicksNum)
	for i = 0,iNicksNum or -1 do
		if i >= iNicksNum then
			break
		end
		kNetStream:WriteInt(auiNicks[i]["uiNpcID"])
		kNetStream:WriteString(auiNicks[i]["acName"])
	end
	return kNetStream,39199
end

function EncodeSendSeGC_Display_RoleCommon(iValueChangeFlag,uiID,uiTypeID,uiSex,uiNameID,uiFamilyNameID,uiFirstNameID,uiTitleID,uiPostFixNameID,uiLevel,uiClanID,uiHP,uiMP,uiExp,uiRemainAttrPoint,uiFragment,uiOverlayLevel,iGoodEvil,uiRemainGiftPoint,uiModelID,uiRank,uiMartialNum,uiGiftNum,uiEatFoodNum,uiEatFoodMaxNum,uiMarry,uiSubRole,uiHasSubRole,uiRoleChallengeState,auiHeritGift,auiHeritMartial)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleCommon'
		g_encodeCache['iValueChangeFlag'] = iValueChangeFlag
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiTypeID'] = uiTypeID
		g_encodeCache['uiSex'] = uiSex
		g_encodeCache['uiNameID'] = uiNameID
		g_encodeCache['uiFamilyNameID'] = uiFamilyNameID
		g_encodeCache['uiFirstNameID'] = uiFirstNameID
		g_encodeCache['uiTitleID'] = uiTitleID
		g_encodeCache['uiPostFixNameID'] = uiPostFixNameID
		g_encodeCache['uiLevel'] = uiLevel
		g_encodeCache['uiClanID'] = uiClanID
		g_encodeCache['uiHP'] = uiHP
		g_encodeCache['uiMP'] = uiMP
		g_encodeCache['uiExp'] = uiExp
		g_encodeCache['uiRemainAttrPoint'] = uiRemainAttrPoint
		g_encodeCache['uiFragment'] = uiFragment
		g_encodeCache['uiOverlayLevel'] = uiOverlayLevel
		g_encodeCache['iGoodEvil'] = iGoodEvil
		g_encodeCache['uiRemainGiftPoint'] = uiRemainGiftPoint
		g_encodeCache['uiModelID'] = uiModelID
		g_encodeCache['uiRank'] = uiRank
		g_encodeCache['uiMartialNum'] = uiMartialNum
		g_encodeCache['uiGiftNum'] = uiGiftNum
		g_encodeCache['uiEatFoodNum'] = uiEatFoodNum
		g_encodeCache['uiEatFoodMaxNum'] = uiEatFoodMaxNum
		g_encodeCache['uiMarry'] = uiMarry
		g_encodeCache['uiSubRole'] = uiSubRole
		g_encodeCache['uiHasSubRole'] = uiHasSubRole
		g_encodeCache['uiRoleChallengeState'] = uiRoleChallengeState
		g_encodeCache['auiHeritGift'] = auiHeritGift
		g_encodeCache['auiHeritMartial'] = auiHeritMartial
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	local iValueChangeFlagPos = kNetStream:GetCurPos()
	local iValueChangeFlag = 1
	kNetStream:WriteInt(iValueChangeFlag)
	if uiID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<0
		kNetStream:WriteInt(uiID)
	end
	if uiTypeID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<1
		kNetStream:WriteInt(uiTypeID)
	end
	if uiSex ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<2
		kNetStream:WriteByte(uiSex)
	end
	if uiNameID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<3
		kNetStream:WriteInt(uiNameID)
	end
	if uiFamilyNameID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<4
		kNetStream:WriteInt(uiFamilyNameID)
	end
	if uiFirstNameID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<5
		kNetStream:WriteInt(uiFirstNameID)
	end
	if uiTitleID ~= -1 then 
		iValueChangeFlag = iValueChangeFlag | 1<<6
		kNetStream:WriteInt(uiTitleID)
	end
	if uiPostFixNameID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<7
		kNetStream:WriteInt(uiPostFixNameID)
	end
	if uiLevel ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<8
		kNetStream:WriteByte(uiLevel)
	end
	if uiClanID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<9
		kNetStream:WriteInt(uiClanID)
	end
	if uiHP ~= -1 then 
		iValueChangeFlag = iValueChangeFlag | 1<<10
		kNetStream:WriteInt(uiHP)
	end
	if uiMP ~= -1 then 
		iValueChangeFlag = iValueChangeFlag | 1<<11
		kNetStream:WriteInt(uiMP)
	end
	if uiExp ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<12
		kNetStream:WriteInt(uiExp)
	end
	if uiRemainAttrPoint ~= -1 then 
		iValueChangeFlag = iValueChangeFlag | 1<<13
		kNetStream:WriteInt(uiRemainAttrPoint)
	end
	if uiFragment ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<14
		kNetStream:WriteByte(uiFragment)
	end
	if uiOverlayLevel ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<15
		kNetStream:WriteByte(uiOverlayLevel)
	end
	if iGoodEvil ~= 200 then 
		iValueChangeFlag = iValueChangeFlag | 1<<16
		kNetStream:WriteInt(iGoodEvil)
	end
	if uiRemainGiftPoint ~= -1 then 
		iValueChangeFlag = iValueChangeFlag | 1<<17
		kNetStream:WriteInt(uiRemainGiftPoint)
	end
	if uiModelID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<18
		kNetStream:WriteInt(uiModelID)
	end
	if uiRank ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<19
		kNetStream:WriteInt(uiRank)
	end
	if uiMartialNum ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<20
		kNetStream:WriteByte(uiMartialNum)
	end
	if uiGiftNum ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<21
		kNetStream:WriteByte(uiGiftNum)
	end
	if uiEatFoodNum ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<22
		kNetStream:WriteByte(uiEatFoodNum)
	end
	if uiEatFoodMaxNum ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<23
		kNetStream:WriteByte(uiEatFoodMaxNum)
	end
	for i = 0,256 or -1 do
		if i >= 256 then
			break
		end
		kNetStream:WriteInt(uiMarry[i])
	end
	if uiSubRole ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<25
		kNetStream:WriteInt(uiSubRole)
	end
	if uiHasSubRole ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<26
		kNetStream:WriteByte(uiHasSubRole)
	end
	if uiRoleChallengeState ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<27
		kNetStream:WriteByte(uiRoleChallengeState)
	end
	for i = 0,256 or -1 do
		if i >= 256 then
			break
		end
		kNetStream:WriteInt(auiHeritGift[i])
	end
	for i = 0,256 or -1 do
		if i >= 256 then
			break
		end
		kNetStream:WriteInt(auiHeritMartial[i])
	end
	local iCurPos = kNetStream:GetCurPos()
	kNetStream:SetCurPos(iValueChangeFlagPos)
	kNetStream:WriteInt(iValueChangeFlag)
	kNetStream:SetCurPos(iCurPos)
	return kNetStream,39193
end

function EncodeSendSeGC_Display_RoleFavor(uiID,auiFavor)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleFavor'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['auiFavor'] = auiFavor
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	for i = 0,SSD_MAX_ROLE_FAVOR_NUM or -1 do
		if i >= SSD_MAX_ROLE_FAVOR_NUM then
			break
		end
		kNetStream:WriteInt(auiFavor[i])
	end
	return kNetStream,39261
end

function EncodeSendSeGC_Display_RoleBro(uiID,uiBroAndSisNum,auiBroAndSis)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleBro'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiBroAndSisNum'] = uiBroAndSisNum
		g_encodeCache['auiBroAndSis'] = auiBroAndSis
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteByte(uiBroAndSisNum)
	for i = 0,uiBroAndSisNum or -1 do
		if i >= uiBroAndSisNum then
			break
		end
		kNetStream:WriteInt(auiBroAndSis[i])
	end
	return kNetStream,39179
end

function EncodeSendSeGC_Display_RoleAttrs(uiID,iAttrsNums,akAttrs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleAttrs'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iAttrsNums'] = iAttrsNums
		g_encodeCache['akAttrs'] = akAttrs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iAttrsNums)
	for i = 0,iAttrsNums or -1 do
		if i >= iAttrsNums then
			break
		end
		kNetStream:WriteInt(akAttrs[i]["uiType"])
		kNetStream:WriteInt(akAttrs[i]["iValue"])
		kNetStream:WriteInt(akAttrs[i]["iBaseValue"])
	end
	return kNetStream,39189
end

function EncodeSendSeGC_Display_RoleItems(uiID,iItemNum,iDelItemNum,auiRoleItem,auiDelRoleItem,auiEquipItem)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleItems'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iItemNum'] = iItemNum
		g_encodeCache['iDelItemNum'] = iDelItemNum
		g_encodeCache['auiRoleItem'] = auiRoleItem
		g_encodeCache['auiDelRoleItem'] = auiDelRoleItem
		g_encodeCache['auiEquipItem'] = auiEquipItem
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iItemNum)
	kNetStream:WriteInt(iDelItemNum)
	for i = 0,iItemNum or -1 do
		if i >= iItemNum then
			break
		end
		kNetStream:WriteInt(auiRoleItem[i])
	end
	for i = 0,iDelItemNum or -1 do
		if i >= iDelItemNum then
			break
		end
		kNetStream:WriteInt(auiDelRoleItem[i])
	end
	for i = 0,REI_NUMS or -1 do
		if i >= REI_NUMS then
			break
		end
		kNetStream:WriteInt(auiEquipItem[i])
	end
	return kNetStream,39211
end

function EncodeSendSeGC_Display_RoleMartials(uiID,iMartialNum,auiRoleMartials)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleMartials'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iMartialNum'] = iMartialNum
		g_encodeCache['auiRoleMartials'] = auiRoleMartials
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iMartialNum)
	for i = 0,iMartialNum or -1 do
		if i >= iMartialNum then
			break
		end
		kNetStream:WriteInt(auiRoleMartials[i])
	end
	return kNetStream,39264
end

function EncodeSendSeGC_DisplayAchievePoint(uiAchievePoint)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayAchievePoint'
		g_encodeCache['uiAchievePoint'] = uiAchievePoint
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiAchievePoint)
	return kNetStream,39227
end

function EncodeSendSeGC_DisplayUnlockRole(uiTitleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayUnlockRole'
		g_encodeCache['uiTitleID'] = uiTitleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTitleID)
	return kNetStream,39236
end

function EncodeSendSeGC_DisplayUnlockSkin(uiTitleID,uiIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayUnlockSkin'
		g_encodeCache['uiTitleID'] = uiTitleID
		g_encodeCache['uiIndex'] = uiIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTitleID)
	kNetStream:WriteInt(uiIndex)
	return kNetStream,39208
end

function EncodeSendSeGC_DisplayNewToast(uiBaseID,uiParam1,uiParam2,uiParam3)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayNewToast'
		g_encodeCache['uiBaseID'] = uiBaseID
		g_encodeCache['uiParam1'] = uiParam1
		g_encodeCache['uiParam2'] = uiParam2
		g_encodeCache['uiParam3'] = uiParam3
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiBaseID)
	kNetStream:WriteInt(uiParam1)
	kNetStream:WriteInt(uiParam2)
	kNetStream:WriteInt(uiParam3)
	return kNetStream,39197
end

function EncodeSendSeGC_Display_EvolutionDelete(iSize,akEvolutionData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_EvolutionDelete'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akEvolutionData'] = akEvolutionData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteByte(akEvolutionData[i]["iValueChangeFlag"])
		if akEvolutionData[i]["uiNpcID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akEvolutionData[i]["uiNpcID"])
		end
		if akEvolutionData[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akEvolutionData[i]["uiID"])
		end
		if akEvolutionData[i]["uiType"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akEvolutionData[i]["uiType"])
		end
		if akEvolutionData[i]["iParam1"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akEvolutionData[i]["iParam1"])
		end
		if akEvolutionData[i]["iParam2"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akEvolutionData[i]["iParam2"])
		end
		if akEvolutionData[i]["iParam3"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akEvolutionData[i]["iParam3"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteByte(akEvolutionData[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,39175
end

function EncodeSendSeGC_Display_EvolutionUpdate(iSize,akEvolutionData,uiTime)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_EvolutionUpdate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akEvolutionData'] = akEvolutionData
		g_encodeCache['uiTime'] = uiTime
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteByte(akEvolutionData[i]["iValueChangeFlag"])
		if akEvolutionData[i]["uiNpcID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akEvolutionData[i]["uiNpcID"])
		end
		if akEvolutionData[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akEvolutionData[i]["uiID"])
		end
		if akEvolutionData[i]["uiType"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akEvolutionData[i]["uiType"])
		end
		if akEvolutionData[i]["iParam1"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akEvolutionData[i]["iParam1"])
		end
		if akEvolutionData[i]["iParam2"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akEvolutionData[i]["iParam2"])
		end
		if akEvolutionData[i]["iParam3"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akEvolutionData[i]["iParam3"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteByte(akEvolutionData[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	kNetStream:WriteInt(uiTime)
	return kNetStream,39240
end

function EncodeSendSeGC_Display_EvolutionRecordUpdate(iSize,akEvolutionRecord)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_EvolutionRecordUpdate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akEvolutionRecord'] = akEvolutionRecord
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akEvolutionRecord[i]["iValueChangeFlag"])
		if akEvolutionRecord[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akEvolutionRecord[i]["uiID"])
		end
		if akEvolutionRecord[i]["uiBaseID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akEvolutionRecord[i]["uiBaseID"])
		end
		if akEvolutionRecord[i]["iParam1"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam1"])
		end
		if akEvolutionRecord[i]["iParam2"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam2"])
		end
		if akEvolutionRecord[i]["iParam3"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam3"])
		end
		if akEvolutionRecord[i]["iParam4"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam4"])
		end
		if akEvolutionRecord[i]["uiCityID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akEvolutionRecord[i]["uiCityID"])
		end
		if akEvolutionRecord[i]["iTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteInt(akEvolutionRecord[i]["iTime"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akEvolutionRecord[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,39216
end

function EncodeSendSeGC_Display_EvolutionRecordDelete(iSize,akEvolutionRecord)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_EvolutionRecordDelete'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akEvolutionRecord'] = akEvolutionRecord
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akEvolutionRecord[i]["iValueChangeFlag"])
		if akEvolutionRecord[i]["uiID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akEvolutionRecord[i]["uiID"])
		end
		if akEvolutionRecord[i]["uiBaseID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akEvolutionRecord[i]["uiBaseID"])
		end
		if akEvolutionRecord[i]["iParam1"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam1"])
		end
		if akEvolutionRecord[i]["iParam2"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam2"])
		end
		if akEvolutionRecord[i]["iParam3"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam3"])
		end
		if akEvolutionRecord[i]["iParam4"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akEvolutionRecord[i]["iParam4"])
		end
		if akEvolutionRecord[i]["uiCityID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akEvolutionRecord[i]["uiCityID"])
		end
		if akEvolutionRecord[i]["iTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteInt(akEvolutionRecord[i]["iTime"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akEvolutionRecord[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,39173
end

function EncodeSendSeGC_Display_MonthEvolution(uiYear,uiMonth)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MonthEvolution'
		g_encodeCache['uiYear'] = uiYear
		g_encodeCache['uiMonth'] = uiMonth
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiYear)
	kNetStream:WriteInt(uiMonth)
	return kNetStream,39260
end

function EncodeSendSeGC_Display_ItemDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ItemDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39213
end

function EncodeSendSeGC_Display_ItemUpdate(iValueChangeFlag,iSize,akRoleItem)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ItemUpdate'
		g_encodeCache['iValueChangeFlag'] = iValueChangeFlag
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleItem'] = akRoleItem
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	local iValueChangeFlagPos = kNetStream:GetCurPos()
	local iValueChangeFlag = 1
	kNetStream:WriteByte(iValueChangeFlag)
	if iSize ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<0
		kNetStream:WriteInt(iSize)
	end
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
	local iCurPos = kNetStream:GetCurPos()
	kNetStream:SetCurPos(iValueChangeFlagPos)
	kNetStream:WriteByte(iValueChangeFlag)
	kNetStream:SetCurPos(iCurPos)
	return kNetStream,39204
end

function EncodeSendSeGC_Display_TempBag_Update(iFlag,iLength,auiItemIDs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TempBag_Update'
		g_encodeCache['iFlag'] = iFlag
		g_encodeCache['iLength'] = iLength
		g_encodeCache['auiItemIDs'] = auiItemIDs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iFlag)
	kNetStream:WriteInt(iLength)
	for i = 0,iLength or -1 do
		if i >= iLength then
			break
		end
		kNetStream:WriteInt(auiItemIDs[i])
	end
	return kNetStream,39309
end

function EncodeSendSeGC_Click_TempBag_MoveBack(iLength,auiItemIDs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_TempBag_MoveBack'
		g_encodeCache['iLength'] = iLength
		g_encodeCache['auiItemIDs'] = auiItemIDs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iLength)
	for i = 0,iLength or -1 do
		if i >= iLength then
			break
		end
		kNetStream:WriteInt(auiItemIDs[i])
	end
	return kNetStream,39286
end

function EncodeSendSeGC_Click_BagCapacity_Buy(uiCount)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_BagCapacity_Buy'
		g_encodeCache['uiCount'] = uiCount
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(uiCount)
	return kNetStream,39325
end

function EncodeSendSeGC_Display_DRTimer_Update(iFlag,uiTimerID,uiTimerExpiration)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_DRTimer_Update'
		g_encodeCache['iFlag'] = iFlag
		g_encodeCache['uiTimerID'] = uiTimerID
		g_encodeCache['uiTimerExpiration'] = uiTimerExpiration
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iFlag)
	kNetStream:WriteInt(uiTimerID)
	kNetStream:WriteInt(uiTimerExpiration)
	return kNetStream,39317
end

function EncodeSendSeGC_Display_MartialDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MartialDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39362
end

function EncodeSendSeGC_Display_MartialUpdate(iValueChangeFlag,iSize,akRoleMartial)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MartialUpdate'
		g_encodeCache['iValueChangeFlag'] = iValueChangeFlag
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleMartial'] = akRoleMartial
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	local iValueChangeFlagPos = kNetStream:GetCurPos()
	local iValueChangeFlag = 1
	kNetStream:WriteByte(iValueChangeFlag)
	if iSize ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<0
		kNetStream:WriteInt(iSize)
	end
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
	local iCurPos = kNetStream:GetCurPos()
	kNetStream:SetCurPos(iValueChangeFlagPos)
	kNetStream:WriteByte(iValueChangeFlag)
	kNetStream:SetCurPos(iCurPos)
	return kNetStream,39334
end

function EncodeSendSeGC_Display_RoleGift(uiID,giftNum,uiGiftUsedNum,uiRemainGiftPoint,auiRoleGift)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleGift'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['giftNum'] = giftNum
		g_encodeCache['uiGiftUsedNum'] = uiGiftUsedNum
		g_encodeCache['uiRemainGiftPoint'] = uiRemainGiftPoint
		g_encodeCache['auiRoleGift'] = auiRoleGift
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(giftNum)
	kNetStream:WriteInt(uiGiftUsedNum)
	kNetStream:WriteInt(uiRemainGiftPoint)
	for i = 0,giftNum or -1 do
		if i >= giftNum then
			break
		end
		kNetStream:WriteInt(auiRoleGift[i])
	end
	return kNetStream,39338
end

function EncodeSendSeGC_Display_GiftUpdate(iSize,akRoleGift)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_GiftUpdate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleGift'] = akRoleGift
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
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
	return kNetStream,39269
end

function EncodeSendSeGC_Display_GiftDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_GiftDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39337
end

function EncodeSendSeGC_Display_RoleWishTasks(uiID,iWishTasksNum,auiRoleWishTasks)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleWishTasks'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iWishTasksNum'] = iWishTasksNum
		g_encodeCache['auiRoleWishTasks'] = auiRoleWishTasks
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iWishTasksNum)
	for i = 0,iWishTasksNum or -1 do
		if i >= iWishTasksNum then
			break
		end
		kNetStream:WriteInt(auiRoleWishTasks[i])
	end
	return kNetStream,39307
end

function EncodeSendSeGC_Display_WishTaskUpdate(iSize,akRoleWishTask)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_WishTaskUpdate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akRoleWishTask'] = akRoleWishTask
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
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
	return kNetStream,39285
end

function EncodeSendSeGC_Display_WishTaskDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_WishTaskDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39310
end

function EncodeSendSeGC_Display_AchieveDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_AchieveDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39280
end

function EncodeSendSeGC_Display_UnLockUpdate(iSize,akItems)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_UnLockUpdate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akItems'] = akItems
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(akItems[i]["uiUnLockType"])
		kNetStream:WriteInt(akItems[i]["uiUnLockID"])
		kNetStream:WriteInt(akItems[i]["uiUnLockNum"])
	end
	return kNetStream,39357
end

function EncodeSendSeGC_Display_TagUpdate(iSize,akTag)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TagUpdate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akTag'] = akTag
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(akTag[i]["uiID"])
		kNetStream:WriteInt(akTag[i]["uiTypeID"])
		kNetStream:WriteInt(akTag[i]["uiValue"])
	end
	return kNetStream,39322
end

function EncodeSendSeGC_Display_TagDelete(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TagDelete'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39333
end

function EncodeSendSeGC_Display_WeekRoundItemOut(iSize,auiItemIDs,uiBackJingmai)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_WeekRoundItemOut'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['auiItemIDs'] = auiItemIDs
		g_encodeCache['uiBackJingmai'] = uiBackJingmai
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(auiItemIDs[i])
	end
	kNetStream:WriteInt(uiBackJingmai)
	return kNetStream,39349
end

function EncodeSendSeGC_Display_WeekRoundItemIn(iSize)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_WeekRoundItemIn'
		g_encodeCache['iSize'] = iSize
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	return kNetStream,39284
end

function EncodeSendSeGC_Display_Item_ReForge_Result(uiDynamicAttrID,uiAttrTypeID,iBaseValue,iExtraValue,uiEnhanceWhiteAttrTypeID,uiBlueAttrTypeID,iBlueBaseValue)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Item_ReForge_Result'
		g_encodeCache['uiDynamicAttrID'] = uiDynamicAttrID
		g_encodeCache['uiAttrTypeID'] = uiAttrTypeID
		g_encodeCache['iBaseValue'] = iBaseValue
		g_encodeCache['iExtraValue'] = iExtraValue
		g_encodeCache['uiEnhanceWhiteAttrTypeID'] = uiEnhanceWhiteAttrTypeID
		g_encodeCache['uiBlueAttrTypeID'] = uiBlueAttrTypeID
		g_encodeCache['iBlueBaseValue'] = iBlueBaseValue
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiDynamicAttrID)
	kNetStream:WriteInt(uiAttrTypeID)
	kNetStream:WriteInt(iBaseValue)
	kNetStream:WriteInt(iExtraValue)
	kNetStream:WriteInt(uiEnhanceWhiteAttrTypeID)
	kNetStream:WriteInt(uiBlueAttrTypeID)
	kNetStream:WriteInt(iBlueBaseValue)
	return kNetStream,39331
end

function EncodeSendSeGC_Display_TaskAdd(uiID,uiTypeID,uiTaskProgressType,uiTaskState,iDescStateSize,auiDescStates)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TaskAdd'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiTypeID'] = uiTypeID
		g_encodeCache['uiTaskProgressType'] = uiTaskProgressType
		g_encodeCache['uiTaskState'] = uiTaskState
		g_encodeCache['iDescStateSize'] = iDescStateSize
		g_encodeCache['auiDescStates'] = auiDescStates
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(uiTypeID)
	kNetStream:WriteInt(uiTaskProgressType)
	kNetStream:WriteInt(uiTaskState)
	kNetStream:WriteInt(iDescStateSize)
	for i = 0,iDescStateSize or -1 do
		if i >= iDescStateSize then
			break
		end
		kNetStream:WriteInt(auiDescStates[i]["uiDescID"])
		kNetStream:WriteInt(auiDescStates[i]["uiDescState"])
		for j = 0,4 or -1 do
		if j >= 4 then
			break
		end
		kNetStream:WriteInt(auiDescStates[i]["auiDescProcess"][j])
	end
	end
	return kNetStream,39339
end

function EncodeSendSeGC_Display_TaskUpdate(uiID,uiTypeID,uiTaskProgressType,uiTaskState,iDescStateSize,uiCompleteBranchReward,auiDescStates,iNotRepeatedEdgeSize,auiFinishNotRepeatedEdge,iEdgeSize,auiEdgeIdList,akEdgeRegState,akEdgeCondState,uiTaskGroup,uiNormalRewardCount,auiTaskNormalRewardList,uiRewardCount,auiTaskRewardList,uiRewardGoodEvil,uiRoleDispositionRewardSize,auiRoleDispositionRole,auiRoleDispositionValue,uiClanDispositionRewardSize,auiClanDispositionClan,auiClanDispositionValue,uiCityDispositionRewardSize,auiCityDispositionCity,auiCityDispositionValue,uiRoleCardReward,bGetRoleCardReward,uiTaskLevel,uiTaskDifficulty,uiCustomKeyDyDataSize,auiCustomKeyDyDataKeyList,auiCustomKeyDyDataValueList)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TaskUpdate'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiTypeID'] = uiTypeID
		g_encodeCache['uiTaskProgressType'] = uiTaskProgressType
		g_encodeCache['uiTaskState'] = uiTaskState
		g_encodeCache['iDescStateSize'] = iDescStateSize
		g_encodeCache['uiCompleteBranchReward'] = uiCompleteBranchReward
		g_encodeCache['auiDescStates'] = auiDescStates
		g_encodeCache['iNotRepeatedEdgeSize'] = iNotRepeatedEdgeSize
		g_encodeCache['auiFinishNotRepeatedEdge'] = auiFinishNotRepeatedEdge
		g_encodeCache['iEdgeSize'] = iEdgeSize
		g_encodeCache['auiEdgeIdList'] = auiEdgeIdList
		g_encodeCache['akEdgeRegState'] = akEdgeRegState
		g_encodeCache['akEdgeCondState'] = akEdgeCondState
		g_encodeCache['uiTaskGroup'] = uiTaskGroup
		g_encodeCache['uiNormalRewardCount'] = uiNormalRewardCount
		g_encodeCache['auiTaskNormalRewardList'] = auiTaskNormalRewardList
		g_encodeCache['uiRewardCount'] = uiRewardCount
		g_encodeCache['auiTaskRewardList'] = auiTaskRewardList
		g_encodeCache['uiRewardGoodEvil'] = uiRewardGoodEvil
		g_encodeCache['uiRoleDispositionRewardSize'] = uiRoleDispositionRewardSize
		g_encodeCache['auiRoleDispositionRole'] = auiRoleDispositionRole
		g_encodeCache['auiRoleDispositionValue'] = auiRoleDispositionValue
		g_encodeCache['uiClanDispositionRewardSize'] = uiClanDispositionRewardSize
		g_encodeCache['auiClanDispositionClan'] = auiClanDispositionClan
		g_encodeCache['auiClanDispositionValue'] = auiClanDispositionValue
		g_encodeCache['uiCityDispositionRewardSize'] = uiCityDispositionRewardSize
		g_encodeCache['auiCityDispositionCity'] = auiCityDispositionCity
		g_encodeCache['auiCityDispositionValue'] = auiCityDispositionValue
		g_encodeCache['uiRoleCardReward'] = uiRoleCardReward
		g_encodeCache['bGetRoleCardReward'] = bGetRoleCardReward
		g_encodeCache['uiTaskLevel'] = uiTaskLevel
		g_encodeCache['uiTaskDifficulty'] = uiTaskDifficulty
		g_encodeCache['uiCustomKeyDyDataSize'] = uiCustomKeyDyDataSize
		g_encodeCache['auiCustomKeyDyDataKeyList'] = auiCustomKeyDyDataKeyList
		g_encodeCache['auiCustomKeyDyDataValueList'] = auiCustomKeyDyDataValueList
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(uiTypeID)
	kNetStream:WriteInt(uiTaskProgressType)
	kNetStream:WriteInt(uiTaskState)
	kNetStream:WriteInt(iDescStateSize)
	kNetStream:WriteInt(uiCompleteBranchReward)
	for i = 0,iDescStateSize or -1 do
		if i >= iDescStateSize then
			break
		end
		kNetStream:WriteInt(auiDescStates[i]["uiDescID"])
		kNetStream:WriteInt(auiDescStates[i]["uiDescState"])
		for j = 0,4 or -1 do
		if j >= 4 then
			break
		end
		kNetStream:WriteInt(auiDescStates[i]["auiDescProcess"][j])
	end
	end
	kNetStream:WriteInt(iNotRepeatedEdgeSize)
	for i = 0,iNotRepeatedEdgeSize or -1 do
		if i >= iNotRepeatedEdgeSize then
			break
		end
		kNetStream:WriteInt(auiFinishNotRepeatedEdge[i])
	end
	kNetStream:WriteInt(iEdgeSize)
	for i = 0,iEdgeSize or -1 do
		if i >= iEdgeSize then
			break
		end
		kNetStream:WriteInt(auiEdgeIdList[i])
	end
	for i = 0,iEdgeSize or -1 do
		if i >= iEdgeSize then
			break
		end
		kNetStream:WriteInt(akEdgeRegState[i])
	end
	for i = 0,iEdgeSize or -1 do
		if i >= iEdgeSize then
			break
		end
		kNetStream:WriteInt(akEdgeCondState[i])
	end
	kNetStream:WriteInt(uiTaskGroup)
	kNetStream:WriteInt(uiNormalRewardCount)
	for i = 0,uiNormalRewardCount or -1 do
		if i >= uiNormalRewardCount then
			break
		end
		kNetStream:WriteInt(auiTaskNormalRewardList[i])
	end
	kNetStream:WriteInt(uiRewardCount)
	for i = 0,uiRewardCount or -1 do
		if i >= uiRewardCount then
			break
		end
		kNetStream:WriteInt(auiTaskRewardList[i])
	end
	kNetStream:WriteInt(uiRewardGoodEvil)
	kNetStream:WriteInt(uiRoleDispositionRewardSize)
	for i = 0,uiRoleDispositionRewardSize or -1 do
		if i >= uiRoleDispositionRewardSize then
			break
		end
		kNetStream:WriteInt(auiRoleDispositionRole[i])
	end
	for i = 0,uiRoleDispositionRewardSize or -1 do
		if i >= uiRoleDispositionRewardSize then
			break
		end
		kNetStream:WriteInt(auiRoleDispositionValue[i])
	end
	kNetStream:WriteInt(uiClanDispositionRewardSize)
	for i = 0,uiClanDispositionRewardSize or -1 do
		if i >= uiClanDispositionRewardSize then
			break
		end
		kNetStream:WriteInt(auiClanDispositionClan[i])
	end
	for i = 0,uiClanDispositionRewardSize or -1 do
		if i >= uiClanDispositionRewardSize then
			break
		end
		kNetStream:WriteInt(auiClanDispositionValue[i])
	end
	kNetStream:WriteInt(uiCityDispositionRewardSize)
	for i = 0,uiCityDispositionRewardSize or -1 do
		if i >= uiCityDispositionRewardSize then
			break
		end
		kNetStream:WriteInt(auiCityDispositionCity[i])
	end
	for i = 0,uiCityDispositionRewardSize or -1 do
		if i >= uiCityDispositionRewardSize then
			break
		end
		kNetStream:WriteInt(auiCityDispositionValue[i])
	end
	kNetStream:WriteInt(uiRoleCardReward)
	kNetStream:WriteInt(bGetRoleCardReward)
	kNetStream:WriteInt(uiTaskLevel)
	kNetStream:WriteInt(uiTaskDifficulty)
	kNetStream:WriteInt(uiCustomKeyDyDataSize)
	for i = 0,uiCustomKeyDyDataSize or -1 do
		if i >= uiCustomKeyDyDataSize then
			break
		end
		kNetStream:WriteInt(auiCustomKeyDyDataKeyList[i])
	end
	for i = 0,uiCustomKeyDyDataSize or -1 do
		if i >= uiCustomKeyDyDataSize then
			break
		end
		kNetStream:WriteInt(auiCustomKeyDyDataValueList[i])
	end
	return kNetStream,39354
end

function EncodeSendSeGC_Display_TaskComplete(uiID,uiTaskProgressType,uiTaskDesc,uiFinalDispositionDeltaNums,auiFinalDispositionDeltaRole,aiFinalDispositionDeltaValue)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TaskComplete'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiTaskProgressType'] = uiTaskProgressType
		g_encodeCache['uiTaskDesc'] = uiTaskDesc
		g_encodeCache['uiFinalDispositionDeltaNums'] = uiFinalDispositionDeltaNums
		g_encodeCache['auiFinalDispositionDeltaRole'] = auiFinalDispositionDeltaRole
		g_encodeCache['aiFinalDispositionDeltaValue'] = aiFinalDispositionDeltaValue
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(uiTaskProgressType)
	kNetStream:WriteInt(uiTaskDesc)
	kNetStream:WriteInt(uiFinalDispositionDeltaNums)
	for i = 0,uiFinalDispositionDeltaNums or -1 do
		if i >= uiFinalDispositionDeltaNums then
			break
		end
		kNetStream:WriteInt(auiFinalDispositionDeltaRole[i])
	end
	for i = 0,uiFinalDispositionDeltaNums or -1 do
		if i >= uiFinalDispositionDeltaNums then
			break
		end
		kNetStream:WriteInt(aiFinalDispositionDeltaValue[i])
	end
	return kNetStream,39274
end

function EncodeSendSeGC_Display_TaskRemove(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TaskRemove'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39295
end

function EncodeSendSeGC_Display_EnterBigMap(uiTemp)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_EnterBigMap'
		g_encodeCache['uiTemp'] = uiTemp
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTemp)
	return kNetStream,39302
end

function EncodeSendSeGC_Display_ShopItem(uiFlag,uiShopID,uiSize,akShopItems)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ShopItem'
		g_encodeCache['uiFlag'] = uiFlag
		g_encodeCache['uiShopID'] = uiShopID
		g_encodeCache['uiSize'] = uiSize
		g_encodeCache['akShopItems'] = akShopItems
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFlag)
	kNetStream:WriteInt(uiShopID)
	kNetStream:WriteInt(uiSize)
	for i = 0,uiSize or -1 do
		if i >= uiSize then
			break
		end
		kNetStream:WriteInt(akShopItems[i]["uiShopItemID"])
		kNetStream:WriteInt(akShopItems[i]["uiNum"])
		kNetStream:WriteInt(akShopItems[i]["uiPrice"])
	end
	return kNetStream,39297
end

function EncodeSendSeGC_Display_Disposition(iNums,akDispositions)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Disposition'
		g_encodeCache['iNums'] = iNums
		g_encodeCache['akDispositions'] = akDispositions
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNums)
	for i = 0,iNums or -1 do
		if i >= iNums then
			break
		end
		kNetStream:WriteInt(akDispositions[i]["iNums"])
		kNetStream:WriteInt(akDispositions[i]["uiFromTypeID"])
		for j = 0,iNums or -1 do
		if j >= iNums then
			break
		end
		kNetStream:WriteInt(akDispositions[i]["auiToTypeIDList"][j])
	end
		for j = 0,iNums or -1 do
		if j >= iNums then
			break
		end
		kNetStream:WriteInt(akDispositions[i]["aiValueList"][j])
	end
	end
	return kNetStream,39288
end

function EncodeSendSeGC_Display_CreateMainRole(iNum,akRoles)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_CreateMainRole'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRoles'] = akRoles
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRoles[i]["uiTypeID"])
		kNetStream:WriteInt(akRoles[i]["uiChild"])
		kNetStream:WriteInt(akRoles[i]["uiRank"])
		kNetStream:WriteInt(akRoles[i]["uiAttrCount"])
		for j = 0,uiAttrCount or -1 do
		if j >= uiAttrCount then
			break
		end
		kNetStream:WriteInt(akRoles[i]["akAttrs"][j]["uiAttrType"])
		kNetStream:WriteInt(akRoles[i]["akAttrs"][j]["iAttrValue"])
	end
		for j = 0,SSD_MAX_ROLE_GIFT or -1 do
		if j >= SSD_MAX_ROLE_GIFT then
			break
		end
		kNetStream:WriteInt(akRoles[i]["uiGifts"][j])
	end
		for j = 0,SSD_MAX_ROLE_SKIN or -1 do
		if j >= SSD_MAX_ROLE_SKIN then
			break
		end
		kNetStream:WriteInt(akRoles[i]["uiUnlock"][j])
	end
	end
	return kNetStream,39303
end

function EncodeSendSeGC_Display_CreateBabyRole(iNum,akRoles)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_CreateBabyRole'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRoles'] = akRoles
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRoles[i]["uiTypeID"])
		kNetStream:WriteInt(akRoles[i]["uiBabyStateID"])
		kNetStream:WriteInt(akRoles[i]["uiChild"])
		kNetStream:WriteInt(akRoles[i]["uiAttrCount"])
		for j = 0,uiAttrCount or -1 do
		if j >= uiAttrCount then
			break
		end
		kNetStream:WriteInt(akRoles[i]["akAttrs"][j]["uiAttrType"])
		kNetStream:WriteInt(akRoles[i]["akAttrs"][j]["iAttrValue"])
	end
		for j = 0,SSD_MAX_ROLE_GIFT or -1 do
		if j >= SSD_MAX_ROLE_GIFT then
			break
		end
		kNetStream:WriteInt(akRoles[i]["uiGifts"][j])
	end
		for j = 0,SSD_MAX_ROLE_SKIN or -1 do
		if j >= SSD_MAX_ROLE_SKIN then
			break
		end
		kNetStream:WriteInt(akRoles[i]["uiUnlock"][j])
	end
	end
	return kNetStream,39283
end

function EncodeSendSeGC_DisplayCityData(iNum,akCitys)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayCityData'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akCitys'] = akCitys
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akCitys[i]["uiCityID"])
		kNetStream:WriteInt(akCitys[i]["uiWeatherID"])
		kNetStream:WriteInt(akCitys[i]["uiState"])
		kNetStream:WriteInt(akCitys[i]["iNum"])
		for j = 0,iNum or -1 do
		if j >= iNum then
			break
		end
		kNetStream:WriteInt(akCitys[i]["akCityEvents"][j]["uiPos"])
		kNetStream:WriteInt(akCitys[i]["akCityEvents"][j]["uiType"])
		kNetStream:WriteInt(akCitys[i]["akCityEvents"][j]["uiTag"])
		kNetStream:WriteInt(akCitys[i]["akCityEvents"][j]["uiEx"])
		kNetStream:WriteInt(akCitys[i]["akCityEvents"][j]["uiTask"])
	end
		kNetStream:WriteInt(akCitys[i]["iCityDispo"])
		kNetStream:WriteInt(akCitys[i]["uiTimerCount"])
		for j = 0,uiTimerCount or -1 do
		if j >= uiTimerCount then
			break
		end
		kNetStream:WriteInt(akCitys[i]["auiTimers"][j])
	end
	end
	return kNetStream,39312
end

function EncodeSendSeGC_DisplayCityMove(uiSrcCityID,uiDstCityID,uiEventSrcCityID,uiEventDstCityID,uiLastMoveDstCityID,uiRandomCityMoveNpcCount,akRandomCityMoveNpcInfos)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayCityMove'
		g_encodeCache['uiSrcCityID'] = uiSrcCityID
		g_encodeCache['uiDstCityID'] = uiDstCityID
		g_encodeCache['uiEventSrcCityID'] = uiEventSrcCityID
		g_encodeCache['uiEventDstCityID'] = uiEventDstCityID
		g_encodeCache['uiLastMoveDstCityID'] = uiLastMoveDstCityID
		g_encodeCache['uiRandomCityMoveNpcCount'] = uiRandomCityMoveNpcCount
		g_encodeCache['akRandomCityMoveNpcInfos'] = akRandomCityMoveNpcInfos
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiSrcCityID)
	kNetStream:WriteInt(uiDstCityID)
	kNetStream:WriteInt(uiEventSrcCityID)
	kNetStream:WriteInt(uiEventDstCityID)
	kNetStream:WriteInt(uiLastMoveDstCityID)
	kNetStream:WriteInt(uiRandomCityMoveNpcCount)
	for i = 0,uiRandomCityMoveNpcCount or -1 do
		if i >= uiRandomCityMoveNpcCount then
			break
		end
		kNetStream:WriteInt(akRandomCityMoveNpcInfos[i]["uiRoleID"])
		kNetStream:WriteInt(akRandomCityMoveNpcInfos[i]["uiSrcCityID"])
		kNetStream:WriteInt(akRandomCityMoveNpcInfos[i]["uiDstCityID"])
		kNetStream:WriteInt(akRandomCityMoveNpcInfos[i]["uiDstMapID"])
	end
	return kNetStream,39314
end

function EncodeSendSeGC_Display_RandomGift(uiGifts)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RandomGift'
		g_encodeCache['uiGifts'] = uiGifts
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	for i = 0,SSD_RANDOMGIFT_COUNT or -1 do
		if i >= SSD_RANDOMGIFT_COUNT then
			break
		end
		kNetStream:WriteInt(uiGifts[i])
	end
	return kNetStream,39301
end

function EncodeSendSeGC_Display_RandomWishRewardPool(uiWishRewards)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RandomWishRewardPool'
		g_encodeCache['uiWishRewards'] = uiWishRewards
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	for i = 0,SSD_RANDOMWISHTTASKREWARD_COUNT or -1 do
		if i >= SSD_RANDOMWISHTTASKREWARD_COUNT then
			break
		end
		kNetStream:WriteInt(uiWishRewards[i])
	end
	return kNetStream,39298
end

function EncodeSendSeGC_Display_ChooseWishRewards(uiWishReward,uiCode)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ChooseWishRewards'
		g_encodeCache['uiWishReward'] = uiWishReward
		g_encodeCache['uiCode'] = uiCode
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiWishReward)
	kNetStream:WriteInt(uiCode)
	return kNetStream,39342
end

function EncodeSendSeGC_Display_ExecutePlot(uiTaskID,uiPlotCount,auiPlotID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ExecutePlot'
		g_encodeCache['uiTaskID'] = uiTaskID
		g_encodeCache['uiPlotCount'] = uiPlotCount
		g_encodeCache['auiPlotID'] = auiPlotID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTaskID)
	kNetStream:WriteInt(uiPlotCount)
	for i = 0,uiPlotCount or -1 do
		if i >= uiPlotCount then
			break
		end
		kNetStream:WriteInt(auiPlotID[i])
	end
	return kNetStream,39356
end

function EncodeSendSeGC_Display_ExecuteCustomPlot(uiTaskID,uiPlotType,sPlotParam1,sPlotParam2,sPlotParam3,sPlotParam4,sPlotParam5,sPlotParam6,sPlotParam7,sPlotParam8,sPlotParam9,sPlotParam10)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ExecuteCustomPlot'
		g_encodeCache['uiTaskID'] = uiTaskID
		g_encodeCache['uiPlotType'] = uiPlotType
		g_encodeCache['sPlotParam1'] = sPlotParam1
		g_encodeCache['sPlotParam2'] = sPlotParam2
		g_encodeCache['sPlotParam3'] = sPlotParam3
		g_encodeCache['sPlotParam4'] = sPlotParam4
		g_encodeCache['sPlotParam5'] = sPlotParam5
		g_encodeCache['sPlotParam6'] = sPlotParam6
		g_encodeCache['sPlotParam7'] = sPlotParam7
		g_encodeCache['sPlotParam8'] = sPlotParam8
		g_encodeCache['sPlotParam9'] = sPlotParam9
		g_encodeCache['sPlotParam10'] = sPlotParam10
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTaskID)
	kNetStream:WriteInt(uiPlotType)
	kNetStream:WriteString(sPlotParam1)
	kNetStream:WriteString(sPlotParam2)
	kNetStream:WriteString(sPlotParam3)
	kNetStream:WriteString(sPlotParam4)
	kNetStream:WriteString(sPlotParam5)
	kNetStream:WriteString(sPlotParam6)
	kNetStream:WriteString(sPlotParam7)
	kNetStream:WriteString(sPlotParam8)
	kNetStream:WriteString(sPlotParam9)
	kNetStream:WriteString(sPlotParam10)
	return kNetStream,39366
end

function EncodeSendSeGC_DisplayMapAdvLoots(iNum,akAdvLootInfos)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayMapAdvLoots'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akAdvLootInfos'] = akAdvLootInfos
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akAdvLootInfos[i]["uiID"])
		kNetStream:WriteInt(akAdvLootInfos[i]["uiSiteType"])
		kNetStream:WriteInt(akAdvLootInfos[i]["uiSiteID"])
		kNetStream:WriteInt(akAdvLootInfos[i]["uiAdvLootID"])
		kNetStream:WriteInt(akAdvLootInfos[i]["uiAdvLootType"])
		kNetStream:WriteInt(akAdvLootInfos[i]["uiNum"])
	end
	return kNetStream,39315
end

function EncodeSendSeGC_Display_MazeUpdate(iNum,akMazeDatas)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeUpdate'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMazeDatas'] = akMazeDatas
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMazeDatas[i]["uiID"])
		kNetStream:WriteInt(akMazeDatas[i]["uiTypeID"])
		kNetStream:WriteInt(akMazeDatas[i]["uiCurAreaIndex"])
		kNetStream:WriteInt(akMazeDatas[i]["uiCurPosRow"])
		kNetStream:WriteInt(akMazeDatas[i]["uiCurPosColumn"])
		kNetStream:WriteInt(akMazeDatas[i]["iBuffCount"])
		for j = 0,iBuffCount or -1 do
		if j >= iBuffCount then
			break
		end
		kNetStream:WriteInt(akMazeDatas[i]["auiBuffIDs"][j]["iBuffTypeID"])
		kNetStream:WriteInt(akMazeDatas[i]["auiBuffIDs"][j]["iLayer"])
	end
		kNetStream:WriteInt(akMazeDatas[i]["iAreaCount"])
		for j = 0,iAreaCount or -1 do
		if j >= iAreaCount then
			break
		end
		kNetStream:WriteInt(akMazeDatas[i]["auiAreaIDs"][j])
	end
	end
	return kNetStream,39363
end

function EncodeSendSeGC_Display_MazeCardUpdate(iNum,akMazeCardDatas)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeCardUpdate'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMazeCardDatas'] = akMazeCardDatas
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMazeCardDatas[i]["uiID"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiTypeID"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiNameID"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiArtSettingID"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiNeverAutoMove"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiNeverAutoTrigger"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiPlotID"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiRoleID"])
		kNetStream:WriteInt(akMazeCardDatas[i]["kCardItem"]["uiNameID"])
	kNetStream:WriteInt(akMazeCardDatas[i]["kCardItem"]["uiModelID"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiUnlockGiftType"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiUnlockGiftLevel"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiClickAudio"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiCardType"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiCardSecondType"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiNeedResetTreasure"])
		kNetStream:WriteInt(akMazeCardDatas[i]["uiTaskID"])
	end
	return kNetStream,39364
end

function EncodeSendSeGC_Display_MazeAreaUpdate(iNum,akMazeAreaDatas)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeAreaUpdate'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMazeAreaDatas'] = akMazeAreaDatas
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMazeAreaDatas[i]["uiID"])
		kNetStream:WriteInt(akMazeAreaDatas[i]["uiTypeID"])
		kNetStream:WriteInt(akMazeAreaDatas[i]["iMazeGridCount"])
		for j = 0,iMazeGridCount or -1 do
		if j >= iMazeGridCount then
			break
		end
		kNetStream:WriteInt(akMazeAreaDatas[i]["auiMazeGridIDs"][j])
	end
		kNetStream:WriteInt(akMazeAreaDatas[i]["uiTemplateTerrainID"])
	end
	return kNetStream,39351
end

function EncodeSendSeGC_Display_MazeGridUpdate(iNum,akMazeGridDatas)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeGridUpdate'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akMazeGridDatas'] = akMazeGridDatas
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akMazeGridDatas[i]["uiID"])
		kNetStream:WriteInt(akMazeGridDatas[i]["uiRow"])
		kNetStream:WriteInt(akMazeGridDatas[i]["uiColumn"])
		kNetStream:WriteInt(akMazeGridDatas[i]["eFirstType"])
		kNetStream:WriteInt(akMazeGridDatas[i]["eSecondType"])
		kNetStream:WriteInt(akMazeGridDatas[i]["uiCardID"])
		kNetStream:WriteInt(akMazeGridDatas[i]["uiBaseCardTypeID"])
		kNetStream:WriteInt(akMazeGridDatas[i]["bCanReplace"])
		kNetStream:WriteInt(akMazeGridDatas[i]["bHasTriggered"])
		kNetStream:WriteInt(akMazeGridDatas[i]["bHasExplored"])
		kNetStream:WriteInt(akMazeGridDatas[i]["bIsUnlock"])
		kNetStream:WriteInt(akMazeGridDatas[i]["uiEventRoleID"])
	end
	return kNetStream,39319
end

function EncodeSendSeGC_Display_MazeUnlockGridChoice(uiGiftType,uiGiftLevel,uiCurGiftLevel)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeUnlockGridChoice'
		g_encodeCache['uiGiftType'] = uiGiftType
		g_encodeCache['uiGiftLevel'] = uiGiftLevel
		g_encodeCache['uiCurGiftLevel'] = uiCurGiftLevel
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiGiftType)
	kNetStream:WriteInt(uiGiftLevel)
	kNetStream:WriteInt(uiCurGiftLevel)
	return kNetStream,39300
end

function EncodeSendSeGC_Display_MazeUnlockGridSuccess(uiGiftType,uiRow,uiColumn,uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeUnlockGridSuccess'
		g_encodeCache['uiGiftType'] = uiGiftType
		g_encodeCache['uiRow'] = uiRow
		g_encodeCache['uiColumn'] = uiColumn
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiGiftType)
	kNetStream:WriteInt(uiRow)
	kNetStream:WriteInt(uiColumn)
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39346
end

function EncodeSendSeGC_Display_MazeMove(uiMazeID,uiAreaIndex,uiCurRow,uiCurColumn,uiDestRow,uiDestColumn)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeMove'
		g_encodeCache['uiMazeID'] = uiMazeID
		g_encodeCache['uiAreaIndex'] = uiAreaIndex
		g_encodeCache['uiCurRow'] = uiCurRow
		g_encodeCache['uiCurColumn'] = uiCurColumn
		g_encodeCache['uiDestRow'] = uiDestRow
		g_encodeCache['uiDestColumn'] = uiDestColumn
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMazeID)
	kNetStream:WriteInt(uiAreaIndex)
	kNetStream:WriteInt(uiCurRow)
	kNetStream:WriteInt(uiCurColumn)
	kNetStream:WriteInt(uiDestRow)
	kNetStream:WriteInt(uiDestColumn)
	return kNetStream,39287
end

function EncodeSendSeGC_Display_MazeMoveToNewArea(uiMazeID,uiAreaIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeMoveToNewArea'
		g_encodeCache['uiMazeID'] = uiMazeID
		g_encodeCache['uiAreaIndex'] = uiAreaIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMazeID)
	kNetStream:WriteInt(uiAreaIndex)
	return kNetStream,39320
end

function EncodeSendSeGC_Display_DynamicAdvLootUpdate(iSize,akDynamicAdvLoot)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_DynamicAdvLootUpdate'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['akDynamicAdvLoot'] = akDynamicAdvLoot
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(akDynamicAdvLoot[i]["uiID"])
		kNetStream:WriteInt(akDynamicAdvLoot[i]["uiDataTypeID"])
		kNetStream:WriteInt(akDynamicAdvLoot[i]["uiAdvLootType"])
		kNetStream:WriteInt(akDynamicAdvLoot[i]["uiNum"])
	end
	return kNetStream,39335
end

function EncodeSendSeGC_Display_ClearInteractState(uiFree)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ClearInteractState'
		g_encodeCache['uiFree'] = uiFree
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFree)
	return kNetStream,39281
end

function EncodeSendSeGC_Display_TriggerAdvGift(uiAdvGiftType,uiItemTypeID,uiCoinCount)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_TriggerAdvGift'
		g_encodeCache['uiAdvGiftType'] = uiAdvGiftType
		g_encodeCache['uiItemTypeID'] = uiItemTypeID
		g_encodeCache['uiCoinCount'] = uiCoinCount
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiAdvGiftType)
	kNetStream:WriteInt(uiItemTypeID)
	kNetStream:WriteInt(uiCoinCount)
	return kNetStream,39367
end

function EncodeSendSeGC_Display_InCompleteBookBox(uiTotalInCompleteTextNum,iNum,akRecord)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_InCompleteBookBox'
		g_encodeCache['uiTotalInCompleteTextNum'] = uiTotalInCompleteTextNum
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRecord'] = akRecord
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTotalInCompleteTextNum)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRecord[i]["dwTypeID"])
		kNetStream:WriteInt(akRecord[i]["dwDreamLandTime"])
		kNetStream:WriteInt(akRecord[i]["dwArriveMaxLvl"])
		kNetStream:WriteInt(akRecord[i]["dwAddInCompleteBookNum"])
		kNetStream:WriteInt(akRecord[i]["dwAddInCompleteTextNum"])
	end
	return kNetStream,39272
end

function EncodeSendSeGC_Display_EnterCity(uiCityID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_EnterCity'
		g_encodeCache['uiCityID'] = uiCityID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiCityID)
	return kNetStream,39355
end

function EncodeSendSeGC_Display_EmBattleMartialUpdate(uiRoleUID,iNum,akEmBattleMartialInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_EmBattleMartialUpdate'
		g_encodeCache['uiRoleUID'] = uiRoleUID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akEmBattleMartialInfo'] = akEmBattleMartialInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleUID)
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akEmBattleMartialInfo[i]["dwUID"])
		kNetStream:WriteInt(akEmBattleMartialInfo[i]["dwTypeID"])
		kNetStream:WriteInt(akEmBattleMartialInfo[i]["dwIndex"])
	end
	return kNetStream,39329
end

function EncodeSendSeGC_Display_ShowForeground(iSize,auiMapEffectID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ShowForeground'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['auiMapEffectID'] = auiMapEffectID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(auiMapEffectID[i])
	end
	return kNetStream,39291
end

function EncodeSendSeGC_Display_UpdateUnlockDisguise(iSize,auiDisguiseItemIDs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_UpdateUnlockDisguise'
		g_encodeCache['iSize'] = iSize
		g_encodeCache['auiDisguiseItemIDs'] = auiDisguiseItemIDs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iSize)
	for i = 0,iSize or -1 do
		if i >= iSize then
			break
		end
		kNetStream:WriteInt(auiDisguiseItemIDs[i])
	end
	return kNetStream,39350
end

function EncodeSendSeGC_Display_FinalBattleUpdateInfo(iCurRound,uiState,uiCurFBCityID,uiCurEnemyID,iRestTeammatesSize,auiRestTeammatesIDs,iAntiJammaCount)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_FinalBattleUpdateInfo'
		g_encodeCache['iCurRound'] = iCurRound
		g_encodeCache['uiState'] = uiState
		g_encodeCache['uiCurFBCityID'] = uiCurFBCityID
		g_encodeCache['uiCurEnemyID'] = uiCurEnemyID
		g_encodeCache['iRestTeammatesSize'] = iRestTeammatesSize
		g_encodeCache['auiRestTeammatesIDs'] = auiRestTeammatesIDs
		g_encodeCache['iAntiJammaCount'] = iAntiJammaCount
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iCurRound)
	kNetStream:WriteInt(uiState)
	kNetStream:WriteInt(uiCurFBCityID)
	kNetStream:WriteInt(uiCurEnemyID)
	kNetStream:WriteInt(iRestTeammatesSize)
	for i = 0,iRestTeammatesSize or -1 do
		if i >= iRestTeammatesSize then
			break
		end
		kNetStream:WriteInt(auiRestTeammatesIDs[i])
	end
	kNetStream:WriteInt(iAntiJammaCount)
	return kNetStream,39282
end

function EncodeSendSeGC_Display_FinalBattleUpdateCity(uiFinalBattleCityID,uiState,iAliveFriendSize,auiAliveFriendIDs,iDeadFriendSize,auiDeadFriendIDs,iAliveEnemySize,auiAliveEnemyIDs,iDeadEnemySize,auiDeadEnemyIDs,iCurFriendHP,iCurEnemyHP,bGotReward)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_FinalBattleUpdateCity'
		g_encodeCache['uiFinalBattleCityID'] = uiFinalBattleCityID
		g_encodeCache['uiState'] = uiState
		g_encodeCache['iAliveFriendSize'] = iAliveFriendSize
		g_encodeCache['auiAliveFriendIDs'] = auiAliveFriendIDs
		g_encodeCache['iDeadFriendSize'] = iDeadFriendSize
		g_encodeCache['auiDeadFriendIDs'] = auiDeadFriendIDs
		g_encodeCache['iAliveEnemySize'] = iAliveEnemySize
		g_encodeCache['auiAliveEnemyIDs'] = auiAliveEnemyIDs
		g_encodeCache['iDeadEnemySize'] = iDeadEnemySize
		g_encodeCache['auiDeadEnemyIDs'] = auiDeadEnemyIDs
		g_encodeCache['iCurFriendHP'] = iCurFriendHP
		g_encodeCache['iCurEnemyHP'] = iCurEnemyHP
		g_encodeCache['bGotReward'] = bGotReward
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFinalBattleCityID)
	kNetStream:WriteInt(uiState)
	kNetStream:WriteInt(iAliveFriendSize)
	for i = 0,iAliveFriendSize or -1 do
		if i >= iAliveFriendSize then
			break
		end
		kNetStream:WriteInt(auiAliveFriendIDs[i])
	end
	kNetStream:WriteInt(iDeadFriendSize)
	for i = 0,iDeadFriendSize or -1 do
		if i >= iDeadFriendSize then
			break
		end
		kNetStream:WriteInt(auiDeadFriendIDs[i])
	end
	kNetStream:WriteInt(iAliveEnemySize)
	for i = 0,iAliveEnemySize or -1 do
		if i >= iAliveEnemySize then
			break
		end
		kNetStream:WriteInt(auiAliveEnemyIDs[i])
	end
	kNetStream:WriteInt(iDeadEnemySize)
	for i = 0,iDeadEnemySize or -1 do
		if i >= iDeadEnemySize then
			break
		end
		kNetStream:WriteInt(auiDeadEnemyIDs[i])
	end
	kNetStream:WriteInt(iCurFriendHP)
	kNetStream:WriteInt(iCurEnemyHP)
	kNetStream:WriteByte(bGotReward)
	return kNetStream,39278
end

function EncodeSendSeGC_Display_Clan_Eliminate_Show(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Clan_Eliminate_Show'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39326
end

function EncodeSendSeGC_Display_ShowDataEndRecord(uiType,uiID,iValue1,iValue2,iValue3)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ShowDataEndRecord'
		g_encodeCache['uiType'] = uiType
		g_encodeCache['uiID'] = uiID
		g_encodeCache['iValue1'] = iValue1
		g_encodeCache['iValue2'] = iValue2
		g_encodeCache['iValue3'] = iValue3
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiType)
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(iValue1)
	kNetStream:WriteInt(iValue2)
	kNetStream:WriteInt(iValue3)
	return kNetStream,39332
end

function EncodeSendSeGC_Display_HighTowerBaseInfo(bNormalUnlock,bBloodUnlock,bRegimentUnlock,uiNormalHistoryStage,uiBloodHistoryStage,uiRegimentHistoryStage,uiCurBloodStage)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_HighTowerBaseInfo'
		g_encodeCache['bNormalUnlock'] = bNormalUnlock
		g_encodeCache['bBloodUnlock'] = bBloodUnlock
		g_encodeCache['bRegimentUnlock'] = bRegimentUnlock
		g_encodeCache['uiNormalHistoryStage'] = uiNormalHistoryStage
		g_encodeCache['uiBloodHistoryStage'] = uiBloodHistoryStage
		g_encodeCache['uiRegimentHistoryStage'] = uiRegimentHistoryStage
		g_encodeCache['uiCurBloodStage'] = uiCurBloodStage
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bNormalUnlock)
	kNetStream:WriteByte(bBloodUnlock)
	kNetStream:WriteByte(bRegimentUnlock)
	kNetStream:WriteInt(uiNormalHistoryStage)
	kNetStream:WriteInt(uiBloodHistoryStage)
	kNetStream:WriteInt(uiRegimentHistoryStage)
	kNetStream:WriteInt(uiCurBloodStage)
	return kNetStream,39368
end

function EncodeSendSeGC_Display_HighTowerRestRole(iNum,auiRestRoles)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_HighTowerRestRole'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['auiRestRoles'] = auiRestRoles
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(auiRestRoles[i])
	end
	return kNetStream,39318
end

function EncodeSendSeGC_Display_AIInfo(uiRoleID,curStrategy,customNum,iNum,actionList)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_AIInfo'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['curStrategy'] = curStrategy
		g_encodeCache['customNum'] = customNum
		g_encodeCache['iNum'] = iNum
		g_encodeCache['actionList'] = actionList
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteByte(curStrategy)
	kNetStream:WriteByte(customNum)
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteDword64(actionList[i])
	end
	return kNetStream,39352
end

function EncodeSendSeGC_Display_Battle_ShowEmbattleUI(iRoundNum,iAllRoundNum,iCantChooseClan,bShowRound,bEvilEliminate)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_ShowEmbattleUI'
		g_encodeCache['iRoundNum'] = iRoundNum
		g_encodeCache['iAllRoundNum'] = iAllRoundNum
		g_encodeCache['iCantChooseClan'] = iCantChooseClan
		g_encodeCache['bShowRound'] = bShowRound
		g_encodeCache['bEvilEliminate'] = bEvilEliminate
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iRoundNum)
	kNetStream:WriteByte(iAllRoundNum)
	kNetStream:WriteByte(iCantChooseClan)
	kNetStream:WriteByte(bShowRound)
	kNetStream:WriteByte(bEvilEliminate)
	return kNetStream,39386
end

function EncodeSendSeGC_Display_Battle_Start(iValueChangeFlag,iNum,akUnits,iAssistNum,akAssistUnits,iBattleTypeID,iBattleType,akUnitsTime,sFriendName,sEnemyName)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_Start'
		g_encodeCache['iValueChangeFlag'] = iValueChangeFlag
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akUnits'] = akUnits
		g_encodeCache['iAssistNum'] = iAssistNum
		g_encodeCache['akAssistUnits'] = akAssistUnits
		g_encodeCache['iBattleTypeID'] = iBattleTypeID
		g_encodeCache['iBattleType'] = iBattleType
		g_encodeCache['akUnitsTime'] = akUnitsTime
		g_encodeCache['sFriendName'] = sFriendName
		g_encodeCache['sEnemyName'] = sEnemyName
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	local iValueChangeFlagPos = kNetStream:GetCurPos()
	local iValueChangeFlag = 1
	kNetStream:WriteInt(iValueChangeFlag)
	if iNum ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<0
		kNetStream:WriteByte(iNum)
	end
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akUnits[i]["iValueChangeFlag"])
		if akUnits[i]["uiUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akUnits[i]["uiUnitIndex"])
		end
		if akUnits[i]["iGridX"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteByte(akUnits[i]["iGridX"])
		end
		if akUnits[i]["iGridY"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteByte(akUnits[i]["iGridY"])
		end
		if akUnits[i]["iMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akUnits[i]["iMP"])
		end
		if akUnits[i]["iHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akUnits[i]["iHP"])
		end
		if akUnits[i]["iMAXMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akUnits[i]["iMAXMP"])
		end
		if akUnits[i]["iMAXHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akUnits[i]["iMAXHP"])
		end
		if akUnits[i]["uiRoleID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteInt(akUnits[i]["uiRoleID"])
		end
		if akUnits[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akUnits[i]["uiTypeID"])
		end
		if akUnits[i]["uiModleID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteInt(akUnits[i]["uiModleID"])
		end
		if akUnits[i]["uiNameID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akUnits[i]["uiNameID"])
		end
		if akUnits[i]["uiFamilyNameID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akUnits[i]["uiFamilyNameID"])
		end
		if akUnits[i]["uiFirstNameID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteInt(akUnits[i]["uiFirstNameID"])
		end
		if akUnits[i]["iAssistFlag"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<13
			kNetStream:WriteByte(akUnits[i]["iAssistFlag"])
		end
		if akUnits[i]["iFace"] ~= 1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<14
			kNetStream:WriteChar(akUnits[i]["iFace"])
		end
		if akUnits[i]["eCamp"] ~= SE_INVALID then 
			iValueChangeFlag = iValueChangeFlag | 1<<15
			kNetStream:WriteInt(akUnits[i]["eCamp"])
		end
		if akUnits[i]["iEquipItemNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<16
			kNetStream:WriteByte(akUnits[i]["iEquipItemNum"])
		end
		for j = 0,iEquipItemNum or -1 do
		if j >= iEquipItemNum then
			break
		end
		kNetStream:WriteInt(akUnits[i]["akEquipItem"][j]["iInstID"])
		kNetStream:WriteInt(akUnits[i]["akEquipItem"][j]["iTypeID"])
		kNetStream:WriteInt(akUnits[i]["akEquipItem"][j]["iEnhanceGrade"])
	end
		if akUnits[i]["iSex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<18
			kNetStream:WriteByte(akUnits[i]["iSex"])
		end
		kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiHat"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiBack"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiHairBack"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiBody"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiFace"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiEyebrow"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiEye"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiMouth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiNose"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiForeheadAdornment"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiFacialAdornment"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiHairFront"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyebrowWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyebrowHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyebrowLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyeWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyeHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyeLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iNoseWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iNoseHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iNoseLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iMouthWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iMouthHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iMouthLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiModelID"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiSex"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiCGSex"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiRoleID"])
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akUnits[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	if iAssistNum ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<2
		kNetStream:WriteByte(iAssistNum)
	end
	for i = 0,iAssistNum or -1 do
		if i >= iAssistNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteByte(akAssistUnits[i]["iValueChangeFlag"])
		if akAssistUnits[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akAssistUnits[i]["uiTypeID"])
		end
		if akAssistUnits[i]["eCamp"] ~= SE_INVALID then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akAssistUnits[i]["eCamp"])
		end
		if akAssistUnits[i]["bPet"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteByte(akAssistUnits[i]["bPet"])
		end
		if akAssistUnits[i]["uiLevel"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteByte(akAssistUnits[i]["uiLevel"])
		end
		if akAssistUnits[i]["uiMoedlID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akAssistUnits[i]["uiMoedlID"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteByte(akAssistUnits[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	if iBattleTypeID ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<4
		kNetStream:WriteInt(iBattleTypeID)
	end
	if iBattleType ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<5
		kNetStream:WriteInt(iBattleType)
	end
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akUnitsTime[i]["uiUnitIndex"])
		kNetStream:WriteInt(akUnitsTime[i]["fMoveTime"])
		kNetStream:WriteInt(akUnitsTime[i]["fOptNeedTime"])
	end
	if sFriendName ~= 'hero' then 
		iValueChangeFlag = iValueChangeFlag | 1<<7
		kNetStream:WriteString(sFriendName)
	end
	if sEnemyName ~= 'hero' then 
		iValueChangeFlag = iValueChangeFlag | 1<<8
		kNetStream:WriteString(sEnemyName)
	end
	local iCurPos = kNetStream:GetCurPos()
	kNetStream:SetCurPos(iValueChangeFlagPos)
	kNetStream:WriteInt(iValueChangeFlag)
	kNetStream:SetCurPos(iCurPos)
	return kNetStream,39348
end

function EncodeSendSeGC_Display_Battle_UpdateUnit(iNum,akUnits)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_UpdateUnit'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akUnits'] = akUnits
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akUnits[i]["iValueChangeFlag"])
		if akUnits[i]["uiUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akUnits[i]["uiUnitIndex"])
		end
		if akUnits[i]["iGridX"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteByte(akUnits[i]["iGridX"])
		end
		if akUnits[i]["iGridY"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteByte(akUnits[i]["iGridY"])
		end
		if akUnits[i]["iMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteDword64(akUnits[i]["iMP"])
		end
		if akUnits[i]["iHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteDword64(akUnits[i]["iHP"])
		end
		if akUnits[i]["iMAXMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteDword64(akUnits[i]["iMAXMP"])
		end
		if akUnits[i]["iMAXHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteDword64(akUnits[i]["iMAXHP"])
		end
		if akUnits[i]["iRoundHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteDword64(akUnits[i]["iRoundHP"])
		end
		if akUnits[i]["iRoundMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteDword64(akUnits[i]["iRoundMP"])
		end
		if akUnits[i]["iShield"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteDword64(akUnits[i]["iShield"])
		end
		if akUnits[i]["iAssistFlag"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteByte(akUnits[i]["iAssistFlag"])
		end
		if akUnits[i]["iFace"] ~= 1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteChar(akUnits[i]["iFace"])
		end
		if akUnits[i]["eMaxAttackType"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteByte(akUnits[i]["eMaxAttackType"])
		end
		if akUnits[i]["iMaxAttack"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<13
			kNetStream:WriteInt(akUnits[i]["iMaxAttack"])
		end
		if akUnits[i]["iDefend"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<14
			kNetStream:WriteInt(akUnits[i]["iDefend"])
		end
		if akUnits[i]["iMoveValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<15
			kNetStream:WriteInt(akUnits[i]["iMoveValue"])
		end
		if akUnits[i]["iMoveDistance"] ~= SSD_BATTLE_INIT_MOVE then 
			iValueChangeFlag = iValueChangeFlag | 1<<16
			kNetStream:WriteByte(akUnits[i]["iMoveDistance"])
		end
		if akUnits[i]["iBuffNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<17
			kNetStream:WriteInt(akUnits[i]["iBuffNum"])
		end
		for j = 0,iBuffNum or -1 do
		if j >= iBuffNum then
			break
		end
		kNetStream:WriteInt(akUnits[i]["akBuffData"][j]["iBuffIndex"])
		kNetStream:WriteInt(akUnits[i]["akBuffData"][j]["iBuffTypeID"])
		kNetStream:WriteInt(akUnits[i]["akBuffData"][j]["iLayerNum"])
		kNetStream:WriteInt(akUnits[i]["akBuffData"][j]["iRoundNum"])
	end
		if akUnits[i]["iChuanTouCiShu"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<19
			kNetStream:WriteInt(akUnits[i]["iChuanTouCiShu"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akUnits[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,39294
end

function EncodeSendSeGC_Display_Battle_CreateUnit(iNum,akUnits)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_CreateUnit'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akUnits'] = akUnits
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akUnits[i]["iValueChangeFlag"])
		if akUnits[i]["uiUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akUnits[i]["uiUnitIndex"])
		end
		if akUnits[i]["iGridX"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteByte(akUnits[i]["iGridX"])
		end
		if akUnits[i]["iGridY"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteByte(akUnits[i]["iGridY"])
		end
		if akUnits[i]["iMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akUnits[i]["iMP"])
		end
		if akUnits[i]["iHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akUnits[i]["iHP"])
		end
		if akUnits[i]["iMAXMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akUnits[i]["iMAXMP"])
		end
		if akUnits[i]["iMAXHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akUnits[i]["iMAXHP"])
		end
		if akUnits[i]["uiRoleID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteInt(akUnits[i]["uiRoleID"])
		end
		if akUnits[i]["uiTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akUnits[i]["uiTypeID"])
		end
		if akUnits[i]["uiModleID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteInt(akUnits[i]["uiModleID"])
		end
		if akUnits[i]["uiNameID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akUnits[i]["uiNameID"])
		end
		if akUnits[i]["uiFamilyNameID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akUnits[i]["uiFamilyNameID"])
		end
		if akUnits[i]["uiFirstNameID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteInt(akUnits[i]["uiFirstNameID"])
		end
		if akUnits[i]["iAssistFlag"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<13
			kNetStream:WriteByte(akUnits[i]["iAssistFlag"])
		end
		if akUnits[i]["iFace"] ~= 1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<14
			kNetStream:WriteChar(akUnits[i]["iFace"])
		end
		if akUnits[i]["eCamp"] ~= SE_INVALID then 
			iValueChangeFlag = iValueChangeFlag | 1<<15
			kNetStream:WriteInt(akUnits[i]["eCamp"])
		end
		if akUnits[i]["iEquipItemNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<16
			kNetStream:WriteByte(akUnits[i]["iEquipItemNum"])
		end
		for j = 0,iEquipItemNum or -1 do
		if j >= iEquipItemNum then
			break
		end
		kNetStream:WriteInt(akUnits[i]["akEquipItem"][j]["iInstID"])
		kNetStream:WriteInt(akUnits[i]["akEquipItem"][j]["iTypeID"])
		kNetStream:WriteInt(akUnits[i]["akEquipItem"][j]["iEnhanceGrade"])
	end
		if akUnits[i]["iSex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<18
			kNetStream:WriteByte(akUnits[i]["iSex"])
		end
		kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiHat"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiBack"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiHairBack"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiBody"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiFace"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiEyebrow"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiEye"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiMouth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiNose"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiForeheadAdornment"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiFacialAdornment"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiHairFront"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyebrowWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyebrowHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyebrowLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyeWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyeHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iEyeLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iNoseWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iNoseHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iNoseLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iMouthWidth"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iMouthHeight"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["iMouthLocation"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiModelID"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiSex"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiCGSex"])
	kNetStream:WriteInt(akUnits[i]["kRoleFaceData"]["uiRoleID"])
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akUnits[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	return kNetStream,39344
end

function EncodeSendSeGC_Display_Battle_UpdateCombo(aComboInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_UpdateCombo'
		g_encodeCache['aComboInfo'] = aComboInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(aComboInfo["uiUnitIndex"])
	kNetStream:WriteByte(aComboInfo["iComboNum"])
	for i = 0,iComboNum or -1 do
		if i >= iComboNum then
			break
		end
		kNetStream:WriteInt(aComboInfo["aiComboBaseID"][i]["uiComboID"])
		kNetStream:WriteByte(aComboInfo["aiComboBaseID"][i]["iCount"])
	end
	return kNetStream,39277
end

function EncodeSendSeGC_Display_Battle_ObserveUnit(akUnit)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_ObserveUnit'
		g_encodeCache['akUnit'] = akUnit
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akUnit["iValueChangeFlag"])
	if akUnit["uiUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akUnit["uiUnitIndex"])
		end
	if akUnit["iMAXMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteDword64(akUnit["iMAXMP"])
		end
	if akUnit["iMAXHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteDword64(akUnit["iMAXHP"])
		end
	if akUnit["iDefend"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akUnit["iDefend"])
		end
	if akUnit["iMoveValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akUnit["iMoveValue"])
		end
	if akUnit["iBuffNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteByte(akUnit["iBuffNum"])
		end
	for i = 0,iBuffNum or -1 do
		if i >= iBuffNum then
			break
		end
		kNetStream:WriteInt(akUnit["akBuffData"][i])
	end
	for i = 0,SSD_MAX_ROLE_GUANCA_NUMS or -1 do
		if i >= SSD_MAX_ROLE_GUANCA_NUMS then
			break
		end
		kNetStream:WriteInt(akUnit["aiAttrs"][i])
	end
	if akUnit["uiLevel"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteByte(akUnit["uiLevel"])
		end
	if akUnit["iGoodEvil"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteInt(akUnit["iGoodEvil"])
		end
	if akUnit["iRank"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akUnit["iRank"])
		end
	if akUnit["iClan"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akUnit["iClan"])
		end
	kNetStream:WriteByte(akUnit["akUnitsMartial"]["iSkillNum"])
	for i = 0,iSkillNum or -1 do
		if i >= iSkillNum then
			break
		end
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiMartialIndex"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiMartialID"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiMartialItemID"])
		kNetStream:WriteByte(akUnit["akUnitsMartial"]["akMartial"][i]["uiMartialLevel"])
		kNetStream:WriteByte(akUnit["akUnitsMartial"]["akMartial"][i]["uiRangeLevel"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiDamageValue"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiPower"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiPowerBase"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiPowerPercent"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiCostMP"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["eStateFalg"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiSkillEvolution"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["eParamInfo"])
		kNetStream:WriteByte(akUnit["akUnitsMartial"]["akMartial"][i]["uiColdTime"])
		kNetStream:WriteInt(akUnit["akUnitsMartial"]["akMartial"][i]["uiRoleUID"])
	end
	return kNetStream,39347
end

function EncodeSendSeGC_Display_Battle_BuffDesc(iNum,akUnits)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_BuffDesc'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akUnits'] = akUnits
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akUnits[i]["iBuffIndex"])
		kNetStream:WriteInt(akUnits[i]["iDescLangID"])
		kNetStream:WriteInt(akUnits[i]["iParam1"])
		kNetStream:WriteInt(akUnits[i]["iParam2"])
		kNetStream:WriteByte(akUnits[i]["iDescType"])
	end
	return kNetStream,39328
end

function EncodeSendSeGC_Display_Battle_UpdateRound(iRound)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_UpdateRound'
		g_encodeCache['iRound'] = iRound
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iRound)
	return kNetStream,39296
end

function EncodeSendSeGC_Display_Battle_AutoBattle(bCloseAuto)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_AutoBattle'
		g_encodeCache['bCloseAuto'] = bCloseAuto
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bCloseAuto)
	return kNetStream,39305
end

function EncodeSendSeGC_Display_Battle_Check(iResult)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_Check'
		g_encodeCache['iResult'] = iResult
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iResult)
	return kNetStream,39323
end

function EncodeSendSeGC_Display_Battle_UpdateOptUnit(uiUnitIndex,iRound,iFlag,iNum,akUnitsTime,akUnitsMartial)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_UpdateOptUnit'
		g_encodeCache['uiUnitIndex'] = uiUnitIndex
		g_encodeCache['iRound'] = iRound
		g_encodeCache['iFlag'] = iFlag
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akUnitsTime'] = akUnitsTime
		g_encodeCache['akUnitsMartial'] = akUnitsMartial
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiUnitIndex)
	kNetStream:WriteByte(iRound)
	kNetStream:WriteByte(iFlag)
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akUnitsTime[i]["uiUnitIndex"])
		kNetStream:WriteInt(akUnitsTime[i]["fMoveTime"])
		kNetStream:WriteInt(akUnitsTime[i]["fOptNeedTime"])
	end
	kNetStream:WriteByte(akUnitsMartial["iSkillNum"])
	for i = 0,iSkillNum or -1 do
		if i >= iSkillNum then
			break
		end
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiMartialIndex"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiMartialID"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiMartialItemID"])
		kNetStream:WriteByte(akUnitsMartial["akMartial"][i]["uiMartialLevel"])
		kNetStream:WriteByte(akUnitsMartial["akMartial"][i]["uiRangeLevel"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiDamageValue"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiPower"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiPowerBase"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiPowerPercent"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiCostMP"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["eStateFalg"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiSkillEvolution"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["eParamInfo"])
		kNetStream:WriteByte(akUnitsMartial["akMartial"][i]["uiColdTime"])
		kNetStream:WriteInt(akUnitsMartial["akMartial"][i]["uiRoleUID"])
	end
	return kNetStream,39345
end

function EncodeSendSeGC_Display_Battle_GameEnd(iValueChangeFlag,akEndData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_GameEnd'
		g_encodeCache['iValueChangeFlag'] = iValueChangeFlag
		g_encodeCache['akEndData'] = akEndData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	local iValueChangeFlagPos = kNetStream:GetCurPos()
	local iValueChangeFlag = 1
	kNetStream:WriteByte(iValueChangeFlag)
	local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akEndData["iValueChangeFlag"])
	if akEndData["iTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akEndData["iTypeID"])
		end
	if akEndData["iEndScore"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteByte(akEndData["iEndScore"])
		end
	if akEndData["eFlag"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akEndData["eFlag"])
		end
	if akEndData["iScoreNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteByte(akEndData["iScoreNum"])
		end
	if akEndData["uiTeamExp"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akEndData["uiTeamExp"])
		end
	if akEndData["uiMartialExp"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akEndData["uiMartialExp"])
		end
	if akEndData["uiResultAddExp"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akEndData["uiResultAddExp"])
		end
	if akEndData["uiLevelAddExp"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteInt(akEndData["uiLevelAddExp"])
		end
	for i = 0,iScoreNum or -1 do
		if i >= iScoreNum then
			break
		end
		kNetStream:WriteInt(akEndData["aiScoreType"][i])
	end
	for i = 0,iScoreNum or -1 do
		if i >= iScoreNum then
			break
		end
		kNetStream:WriteInt(akEndData["aiScoreCount"][i])
	end
	for i = 0,iScoreNum or -1 do
		if i >= iScoreNum then
			break
		end
		kNetStream:WriteInt(akEndData["aiScore"][i])
	end
	if akEndData["iAwardNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteByte(akEndData["iAwardNum"])
		end
	for i = 0,iAwardNum or -1 do
		if i >= iAwardNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteByte(akEndData["asAward"][i]["iValueChangeFlag"])
		if akEndData["asAward"][i]["uiItemID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akEndData["asAward"][i]["uiItemID"])
		end
		if akEndData["asAward"][i]["uiNums"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akEndData["asAward"][i]["uiNums"])
		end
		if akEndData["asAward"][i]["eType"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akEndData["asAward"][i]["eType"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteByte(akEndData["asAward"][i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	local iCurPos = kNetStream:GetCurPos()
	kNetStream:SetCurPos(iValueChangeFlagPos)
	kNetStream:WriteByte(iValueChangeFlag)
	kNetStream:SetCurPos(iCurPos)
	return kNetStream,39292
end

function EncodeSendSeGC_Click_Battle_OperateUnit(uiUnitIndex,iGridX,iGridY,uiSkillIndex,iSkillPosX,iSkillPosY,iSelectPosX,iSelectPosY)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Battle_OperateUnit'
		g_encodeCache['uiUnitIndex'] = uiUnitIndex
		g_encodeCache['iGridX'] = iGridX
		g_encodeCache['iGridY'] = iGridY
		g_encodeCache['uiSkillIndex'] = uiSkillIndex
		g_encodeCache['iSkillPosX'] = iSkillPosX
		g_encodeCache['iSkillPosY'] = iSkillPosY
		g_encodeCache['iSelectPosX'] = iSelectPosX
		g_encodeCache['iSelectPosY'] = iSelectPosY
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiUnitIndex)
	kNetStream:WriteByte(iGridX)
	kNetStream:WriteByte(iGridY)
	kNetStream:WriteInt(uiSkillIndex)
	kNetStream:WriteByte(iSkillPosX)
	kNetStream:WriteByte(iSkillPosY)
	kNetStream:WriteByte(iSelectPosX)
	kNetStream:WriteByte(iSelectPosY)
	return kNetStream,39324
end

function EncodeSendSeGC_Click_Battle_GameEnd(eFlag)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Battle_GameEnd'
		g_encodeCache['eFlag'] = eFlag
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(eFlag)
	return kNetStream,39365
end

function EncodeSendSeGC_Click_Battle_Auto(uiUnitIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Battle_Auto'
		g_encodeCache['uiUnitIndex'] = uiUnitIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiUnitIndex)
	return kNetStream,39343
end

function EncodeSendSeGC_Click_Battle_OBSERVE(uiUnitIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Battle_OBSERVE'
		g_encodeCache['uiUnitIndex'] = uiUnitIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiUnitIndex)
	return kNetStream,39306
end

function EncodeSendSeGC_Click_Battle_WheelWar_Result(bStart,uiClanID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Battle_WheelWar_Result'
		g_encodeCache['bStart'] = bStart
		g_encodeCache['uiClanID'] = uiClanID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bStart)
	kNetStream:WriteInt(uiClanID)
	return kNetStream,39330
end

function EncodeSendSeGC_Display_HurtInfo(iValueChangeFlag,iNum,akBattleLog)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_HurtInfo'
		g_encodeCache['iValueChangeFlag'] = iValueChangeFlag
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akBattleLog'] = akBattleLog
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	local iValueChangeFlagPos = kNetStream:GetCurPos()
	local iValueChangeFlag = 1
	kNetStream:WriteByte(iValueChangeFlag)
	if iNum ~= 0 then 
		iValueChangeFlag = iValueChangeFlag | 1<<0
		kNetStream:WriteInt(iNum)
	end
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteDword64(akBattleLog[i]["iValueChangeFlag"])
		if akBattleLog[i]["eEvent"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akBattleLog[i]["eEvent"])
		end
		if akBattleLog[i]["iOwnerUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akBattleLog[i]["iOwnerUnitIndex"])
		end
		if akBattleLog[i]["iOwnerMartialIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akBattleLog[i]["iOwnerMartialIndex"])
		end
		if akBattleLog[i]["iSkillTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akBattleLog[i]["iSkillTypeID"])
		end
		if akBattleLog[i]["iBuffIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akBattleLog[i]["iBuffIndex"])
		end
		if akBattleLog[i]["iBuffTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akBattleLog[i]["iBuffTypeID"])
		end
		if akBattleLog[i]["iBuffDamage"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akBattleLog[i]["iBuffDamage"])
		end
		if akBattleLog[i]["iSourceUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteInt(akBattleLog[i]["iSourceUnitIndex"])
		end
		if akBattleLog[i]["iSourceMartialIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akBattleLog[i]["iSourceMartialIndex"])
		end
		if akBattleLog[i]["iCastPosX"] ~= -1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteChar(akBattleLog[i]["iCastPosX"])
		end
		if akBattleLog[i]["iCastPosY"] ~= -1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteChar(akBattleLog[i]["iCastPosY"])
		end
		if akBattleLog[i]["iMoveX"] ~= -1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteChar(akBattleLog[i]["iMoveX"])
		end
		if akBattleLog[i]["iMoveY"] ~= -1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteChar(akBattleLog[i]["iMoveY"])
		end
		if akBattleLog[i]["iSpendMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<13
			kNetStream:WriteInt(akBattleLog[i]["iSpendMP"])
		end
		if akBattleLog[i]["iAddMP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<14
			kNetStream:WriteInt(akBattleLog[i]["iAddMP"])
		end
		if akBattleLog[i]["iAddHP"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<15
			kNetStream:WriteInt(akBattleLog[i]["iAddHP"])
		end
		if akBattleLog[i]["iSpendItemID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<16
			kNetStream:WriteInt(akBattleLog[i]["iSpendItemID"])
		end
		if akBattleLog[i]["iLianJiCount"] ~= 100 then 
			iValueChangeFlag = iValueChangeFlag | 1<<17
			kNetStream:WriteByte(akBattleLog[i]["iLianJiCount"])
		end
		if akBattleLog[i]["eSkillEventType"] ~= BSET_Null then 
			iValueChangeFlag = iValueChangeFlag | 1<<18
			kNetStream:WriteInt(akBattleLog[i]["eSkillEventType"])
		end
		if akBattleLog[i]["iBuffNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<19
			kNetStream:WriteInt(akBattleLog[i]["iBuffNum"])
		end
		for j = 0,iBuffNum or -1 do
		if j >= iBuffNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteByte(akBattleLog[i]["akBuffData"][j]["iValueChangeFlag"])
		if akBattleLog[i]["akBuffData"][j]["iOwnUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akBattleLog[i]["akBuffData"][j]["iOwnUnitIndex"])
		end
		if akBattleLog[i]["akBuffData"][j]["eEventType"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akBattleLog[i]["akBuffData"][j]["eEventType"])
		end
		if akBattleLog[i]["akBuffData"][j]["iBuffIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akBattleLog[i]["akBuffData"][j]["iBuffIndex"])
		end
		if akBattleLog[i]["akBuffData"][j]["iBuffTypeID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akBattleLog[i]["akBuffData"][j]["iBuffTypeID"])
		end
		if akBattleLog[i]["akBuffData"][j]["iLayerNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteInt(akBattleLog[i]["akBuffData"][j]["iLayerNum"])
		end
		if akBattleLog[i]["akBuffData"][j]["iRoundNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteByte(akBattleLog[i]["akBuffData"][j]["iRoundNum"])
		end
		if akBattleLog[i]["akBuffData"][j]["iFlag"] ~= SBHBT_NULL then 
			iValueChangeFlag = iValueChangeFlag | 1<<6
			kNetStream:WriteInt(akBattleLog[i]["akBuffData"][j]["iFlag"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteByte(akBattleLog[i]["akBuffData"][j]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
		if akBattleLog[i]["iPlotNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<21
			kNetStream:WriteByte(akBattleLog[i]["iPlotNum"])
		end
		for j = 0,iPlotNum or -1 do
		if j >= iPlotNum then
			break
		end
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["eEventType"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["iPlotTaskID"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["iPlotID"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["PlotType"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["Param1"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["Param2"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["Param3"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["Param4"])
		kNetStream:WriteInt(akBattleLog[i]["akPlotData"][j]["Param5"])
	end
		if akBattleLog[i]["iHeJiTargetNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<23
			kNetStream:WriteByte(akBattleLog[i]["iHeJiTargetNum"])
		end
		for j = 0,iHeJiTargetNum or -1 do
		if j >= iHeJiTargetNum then
			break
		end
		kNetStream:WriteInt(akBattleLog[i]["aiHeJiTargetUnit"][j])
	end
		if akBattleLog[i]["iSkillDamageData"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<25
			kNetStream:WriteByte(akBattleLog[i]["iSkillDamageData"])
		end
		for j = 0,iSkillDamageData or -1 do
		if j >= iSkillDamageData then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iValueChangeFlag"])
		if akBattleLog[i]["akSkillDamageData"][j]["iTargetUnitIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iTargetUnitIndex"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iFinalDamageValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iFinalDamageValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iFinalMPDamageValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iFinalMPDamageValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iFinalHPAddValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<3
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iFinalHPAddValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iFinalValueFlag"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<4
			kNetStream:WriteByte(akBattleLog[i]["akSkillDamageData"][j]["iFinalValueFlag"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iDuoDuanNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<5
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iDuoDuanNum"])
		end
		for k = 0,iDuoDuanNum or -1 do
		if k >= iDuoDuanNum then
			break
		end
		kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["aiFinalNumberAddValue"][k])
	end
		if akBattleLog[i]["akSkillDamageData"][j]["iLeechValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<7
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iLeechValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iShieldValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<8
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iShieldValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iReboundDamageValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<9
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iReboundDamageValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["eSkillDataType"] ~= 1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<10
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["eSkillDataType"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["eExtraFlag"] ~= BDEF_NULL then 
			iValueChangeFlag = iValueChangeFlag | 1<<11
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["eExtraFlag"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iJituiX"] ~= 100 then 
			iValueChangeFlag = iValueChangeFlag | 1<<12
			kNetStream:WriteByte(akBattleLog[i]["akSkillDamageData"][j]["iJituiX"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iJituiY"] ~= 100 then 
			iValueChangeFlag = iValueChangeFlag | 1<<13
			kNetStream:WriteByte(akBattleLog[i]["akSkillDamageData"][j]["iJituiY"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iYuanhuX"] ~= -1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<14
			kNetStream:WriteChar(akBattleLog[i]["akSkillDamageData"][j]["iYuanhuX"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iYuanhuY"] ~= -1 then 
			iValueChangeFlag = iValueChangeFlag | 1<<15
			kNetStream:WriteChar(akBattleLog[i]["akSkillDamageData"][j]["iYuanhuY"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalDamageAddValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<16
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalDamageAddValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalDamageAddPer"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<17
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalDamageAddPer"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalHPAddValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<18
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalHPAddValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalHPAddPer"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<19
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iExtraFinalHPAddPer"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iBaseDamageValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<20
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iBaseDamageValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iBaseHPAddValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<21
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iBaseHPAddValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iNumberAddPer"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<22
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iNumberAddPer"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iNumberAddValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<23
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iNumberAddValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iCurNumberAddValue"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<24
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iCurNumberAddValue"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["eSpecialFlag"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<25
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["eSpecialFlag"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iAddPassTime"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<26
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iAddPassTime"])
		end
		if akBattleLog[i]["akSkillDamageData"][j]["iDodge"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<27
			kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iDodge"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteInt(akBattleLog[i]["akSkillDamageData"][j]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
		if akBattleLog[i]["iMutilTag"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<27
			kNetStream:WriteInt(akBattleLog[i]["iMutilTag"])
		end
		if akBattleLog[i]["bDeath"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<28
			kNetStream:WriteByte(akBattleLog[i]["bDeath"])
		end
		if akBattleLog[i]["iCallDiscipleIndex"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<29
			kNetStream:WriteInt(akBattleLog[i]["iCallDiscipleIndex"])
		end
		if akBattleLog[i]["iPetNum"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<30
			kNetStream:WriteByte(akBattleLog[i]["iPetNum"])
		end
		for j = 0,iPetNum or -1 do
		if j >= iPetNum then
			break
		end
		kNetStream:WriteInt(akBattleLog[i]["aiPetID"][j])
	end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteDword64(akBattleLog[i]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	local iCurPos = kNetStream:GetCurPos()
	kNetStream:SetCurPos(iValueChangeFlagPos)
	kNetStream:WriteByte(iValueChangeFlag)
	kNetStream:SetCurPos(iCurPos)
	return kNetStream,39270
end

function EncodeSendSeGC_Display_Battle_UpdateTreasureBox(iNum,akBattleLog)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Battle_UpdateTreasureBox'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akBattleLog'] = akBattleLog
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akBattleLog[i]["iGridX"])
		kNetStream:WriteInt(akBattleLog[i]["iGridY"])
		kNetStream:WriteInt(akBattleLog[i]["uiDropTypeID"])
		kNetStream:WriteInt(akBattleLog[i]["uiLevel"])
		kNetStream:WriteInt(akBattleLog[i]["iFlag"])
		kNetStream:WriteInt(akBattleLog[i]["iNum"])
		for j = 0,iNum or -1 do
		if j >= iNum then
			break
		end
		local iValueChangeFlagPos = kNetStream:GetCurPos()
		local iValueChangeFlag = 1
		kNetStream:WriteByte(akBattleLog[i]["akReward"][j]["iValueChangeFlag"])
		if akBattleLog[i]["akReward"][j]["uiItemID"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<0
			kNetStream:WriteInt(akBattleLog[i]["akReward"][j]["uiItemID"])
		end
		if akBattleLog[i]["akReward"][j]["uiNums"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<1
			kNetStream:WriteInt(akBattleLog[i]["akReward"][j]["uiNums"])
		end
		if akBattleLog[i]["akReward"][j]["eType"] ~= 0 then 
			iValueChangeFlag = iValueChangeFlag | 1<<2
			kNetStream:WriteInt(akBattleLog[i]["akReward"][j]["eType"])
		end
		local iCurPos = kNetStream:GetCurPos()
		kNetStream:SetCurPos(iValueChangeFlagPos)
		kNetStream:WriteByte(akBattleLog[i]["akReward"][j]["iValueChangeFlag"])
		kNetStream:SetCurPos(iCurPos)
	end
	end
	return kNetStream,39358
end

function EncodeSendSeGC_Click_Battle_Check(ccount,scount)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Battle_Check'
		g_encodeCache['ccount'] = ccount
		g_encodeCache['scount'] = scount
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(ccount)
	kNetStream:WriteInt(scount)
	return kNetStream,39290
end

function EncodeSendSeGC_Display_CallHelpBackInfo(isSuccess,reason)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_CallHelpBackInfo'
		g_encodeCache['isSuccess'] = isSuccess
		g_encodeCache['reason'] = reason
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(isSuccess)
	kNetStream:WriteInt(reason)
	return kNetStream,39353
end

function EncodeSendSeGC_Display_Inviteable_Update(uiRoleTypeID,uiInviteable)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Inviteable_Update'
		g_encodeCache['uiRoleTypeID'] = uiRoleTypeID
		g_encodeCache['uiInviteable'] = uiInviteable
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleTypeID)
	kNetStream:WriteInt(uiInviteable)
	return kNetStream,39341
end

function EncodeSendSeGC_Click_NPC_Interact_Beg(uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_NPC_Interact_Beg'
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39321
end

function EncodeSendSeGC_Display_NPC_Interact_Random_Items(uiRoleID,uiItemID,iNum,iItemP,iTreasureP,iRandomItemNum,eInteractType,auiRoleItem)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_NPC_Interact_Random_Items'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiItemID'] = uiItemID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['iItemP'] = iItemP
		g_encodeCache['iTreasureP'] = iTreasureP
		g_encodeCache['iRandomItemNum'] = iRandomItemNum
		g_encodeCache['eInteractType'] = eInteractType
		g_encodeCache['auiRoleItem'] = auiRoleItem
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiItemID)
	kNetStream:WriteInt(iNum)
	kNetStream:WriteByte(iItemP)
	kNetStream:WriteByte(iTreasureP)
	kNetStream:WriteInt(iRandomItemNum)
	kNetStream:WriteInt(eInteractType)
	for i = 0,iRandomItemNum or -1 do
		if i >= iRandomItemNum then
			break
		end
		kNetStream:WriteInt(auiRoleItem[i])
	end
	return kNetStream,39299
end

function EncodeSendSeGC_Display_MapUpdate(uiMapID,kMapData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MapUpdate'
		g_encodeCache['uiMapID'] = uiMapID
		g_encodeCache['kMapData'] = kMapData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMapID)
	kNetStream:WriteInt(kMapData["iRoleCount"])
	for i = 0,iRoleCount or -1 do
		if i >= iRoleCount then
			break
		end
		kNetStream:WriteInt(kMapData["auiRoleIDs"][i])
	end
	kNetStream:WriteInt(kMapData["uiNameID"])
	kNetStream:WriteString(kMapData["sBuildingImg"])
	kNetStream:WriteInt(kMapData["uiBuildingType"])
	kNetStream:WriteByte(kMapData["bCanShow"])
	kNetStream:WriteByte(kMapData["bCanReturn"])
	return kNetStream,39293
end

function EncodeSendSeGC_Display_NPC_Interact_Give_Gift(uiSrcRoleID,uiDstRoleID,iResoult)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_NPC_Interact_Give_Gift'
		g_encodeCache['uiSrcRoleID'] = uiSrcRoleID
		g_encodeCache['uiDstRoleID'] = uiDstRoleID
		g_encodeCache['iResoult'] = iResoult
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiSrcRoleID)
	kNetStream:WriteInt(uiDstRoleID)
	kNetStream:WriteInt(iResoult)
	return kNetStream,39361
end

function EncodeSendSeGC_Display_Interact_Date_Update(uiRoleID,eInteractType,uiTimes)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Interact_Date_Update'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['eInteractType'] = eInteractType
		g_encodeCache['uiTimes'] = uiTimes
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(eInteractType)
	kNetStream:WriteInt(uiTimes)
	return kNetStream,39279
end

function EncodeSendSeGC_Display_Interact_RefreshTimes_Update(uiPlayerBehaviorType,uiRefreshTimes)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Interact_RefreshTimes_Update'
		g_encodeCache['uiPlayerBehaviorType'] = uiPlayerBehaviorType
		g_encodeCache['uiRefreshTimes'] = uiRefreshTimes
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiPlayerBehaviorType)
	kNetStream:WriteInt(uiRefreshTimes)
	return kNetStream,39271
end

function EncodeSendSeGC_Click_Choose_TiGuan(uiID,uiIsAbandom,uiIsBranch)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Choose_TiGuan'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiIsAbandom'] = uiIsAbandom
		g_encodeCache['uiIsBranch'] = uiIsBranch
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(uiIsAbandom)
	kNetStream:WriteInt(uiIsBranch)
	return kNetStream,39275
end

function EncodeSendSeGC_CLICK_START_CLAN_ELIMINATE(uiID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_CLICK_START_CLAN_ELIMINATE'
		g_encodeCache['uiID'] = uiID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	return kNetStream,39273
end

function EncodeSendSeGC_Click_LimitShop_Action(uiType,uiIfSuc,uiBeginTime,uistate)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_LimitShop_Action'
		g_encodeCache['uiType'] = uiType
		g_encodeCache['uiIfSuc'] = uiIfSuc
		g_encodeCache['uiBeginTime'] = uiBeginTime
		g_encodeCache['uistate'] = uistate
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiType)
	kNetStream:WriteInt(uiIfSuc)
	kNetStream:WriteInt(uiBeginTime)
	kNetStream:WriteInt(uistate)
	return kNetStream,39289
end

function EncodeSendSeGC_Click_Select_Zhuazhou(uiAnswerID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Select_Zhuazhou'
		g_encodeCache['uiAnswerID'] = uiAnswerID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiAnswerID)
	return kNetStream,39369
end

function EncodeSendSeGC_Click_Add_Clan_Delegation_Task(uiClanBaseID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Add_Clan_Delegation_Task'
		g_encodeCache['uiClanBaseID'] = uiClanBaseID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanBaseID)
	return kNetStream,39304
end

function EncodeSendSeGC_Click_Add_City_Delegation_Task(uiCityBaseID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Add_City_Delegation_Task'
		g_encodeCache['uiCityBaseID'] = uiCityBaseID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiCityBaseID)
	return kNetStream,39276
end

function EncodeSendSeGC_Display_Add_Interact_Option(kInteractOption)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Add_Interact_Option'
		g_encodeCache['kInteractOption'] = kInteractOption
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(kInteractOption["uiChoiceLangID"])
	kNetStream:WriteInt(kInteractOption["uiLockLangID"])
	kNetStream:WriteInt(kInteractOption["uiRoleTypeID"])
	kNetStream:WriteInt(kInteractOption["uiMapID"])
	kNetStream:WriteInt(kInteractOption["uiConditionID"])
	kNetStream:WriteByte(kInteractOption["bIsLock"])
	kNetStream:WriteInt(kInteractOption["uiMazeTypeID"])
	kNetStream:WriteInt(kInteractOption["uiAreaIndex"])
	kNetStream:WriteInt(kInteractOption["uiCardID"])
	kNetStream:WriteInt(kInteractOption["uiRow"])
	kNetStream:WriteInt(kInteractOption["uiColumn"])
	kNetStream:WriteInt(kInteractOption["eInteractType"])
	kNetStream:WriteInt(kInteractOption["uiTaskID"])
	return kNetStream,39379
end

function EncodeSendSeGC_Display_Remove_Interact_Option(kInteractOption)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Remove_Interact_Option'
		g_encodeCache['kInteractOption'] = kInteractOption
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(kInteractOption["uiChoiceLangID"])
	kNetStream:WriteInt(kInteractOption["uiLockLangID"])
	kNetStream:WriteInt(kInteractOption["uiRoleTypeID"])
	kNetStream:WriteInt(kInteractOption["uiMapID"])
	kNetStream:WriteInt(kInteractOption["uiConditionID"])
	kNetStream:WriteByte(kInteractOption["bIsLock"])
	kNetStream:WriteInt(kInteractOption["uiMazeTypeID"])
	kNetStream:WriteInt(kInteractOption["uiAreaIndex"])
	kNetStream:WriteInt(kInteractOption["uiCardID"])
	kNetStream:WriteInt(kInteractOption["uiRow"])
	kNetStream:WriteInt(kInteractOption["uiColumn"])
	kNetStream:WriteInt(kInteractOption["eInteractType"])
	kNetStream:WriteInt(kInteractOption["uiTaskID"])
	return kNetStream,39380
end

function EncodeSendSeGC_Display_CloseGiveGift(uiFreeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_CloseGiveGift'
		g_encodeCache['uiFreeID'] = uiFreeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFreeID)
	return kNetStream,39381
end

function EncodeSendSeGC_Display_Update_Role_Select_Event(uiRoleTypeID,uiMapTypeID,uiMazeTypeID,uiAreaIndex,uiCardTypeID,uiRow,uiColumn)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Update_Role_Select_Event'
		g_encodeCache['uiRoleTypeID'] = uiRoleTypeID
		g_encodeCache['uiMapTypeID'] = uiMapTypeID
		g_encodeCache['uiMazeTypeID'] = uiMazeTypeID
		g_encodeCache['uiAreaIndex'] = uiAreaIndex
		g_encodeCache['uiCardTypeID'] = uiCardTypeID
		g_encodeCache['uiRow'] = uiRow
		g_encodeCache['uiColumn'] = uiColumn
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleTypeID)
	kNetStream:WriteInt(uiMapTypeID)
	kNetStream:WriteInt(uiMazeTypeID)
	kNetStream:WriteInt(uiAreaIndex)
	kNetStream:WriteInt(uiCardTypeID)
	kNetStream:WriteInt(uiRow)
	kNetStream:WriteInt(uiColumn)
	return kNetStream,39391
end

function EncodeSendSeGC_Display_PlayMazeRoleAnim(uiRow,uiColumn,uiAnimType,bIsLoop,bNeedRecover)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_PlayMazeRoleAnim'
		g_encodeCache['uiRow'] = uiRow
		g_encodeCache['uiColumn'] = uiColumn
		g_encodeCache['uiAnimType'] = uiAnimType
		g_encodeCache['bIsLoop'] = bIsLoop
		g_encodeCache['bNeedRecover'] = bNeedRecover
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRow)
	kNetStream:WriteInt(uiColumn)
	kNetStream:WriteInt(uiAnimType)
	kNetStream:WriteByte(bIsLoop)
	kNetStream:WriteByte(bNeedRecover)
	return kNetStream,39393
end

function EncodeSendSeGC_Display_ShowMazeRoleBubble(uiContentLangID,uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ShowMazeRoleBubble'
		g_encodeCache['uiContentLangID'] = uiContentLangID
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiContentLangID)
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39383
end

function EncodeSendSeGC_Display_MazeEnemyEscape(uiGridID,uiRoleExp,uiMartialExp)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MazeEnemyEscape'
		g_encodeCache['uiGridID'] = uiGridID
		g_encodeCache['uiRoleExp'] = uiRoleExp
		g_encodeCache['uiMartialExp'] = uiMartialExp
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiGridID)
	kNetStream:WriteInt(uiRoleExp)
	kNetStream:WriteInt(uiMartialExp)
	return kNetStream,39382
end

function EncodeSendSeGC_Display_Update_TitleID(uiTitleID,uiUsed)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Update_TitleID'
		g_encodeCache['uiTitleID'] = uiTitleID
		g_encodeCache['uiUsed'] = uiUsed
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTitleID)
	kNetStream:WriteInt(uiUsed)
	return kNetStream,39392
end

function EncodeSendSeGC_Display_Custom_Plot(uiPlotType,uiRoleID,uiLanguage,iParamSize,auiCustomIDs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Custom_Plot'
		g_encodeCache['uiPlotType'] = uiPlotType
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiLanguage'] = uiLanguage
		g_encodeCache['iParamSize'] = iParamSize
		g_encodeCache['auiCustomIDs'] = auiCustomIDs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiPlotType)
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiLanguage)
	kNetStream:WriteInt(iParamSize)
	for i = 0,iParamSize or -1 do
		if i >= iParamSize then
			break
		end
		kNetStream:WriteInt(auiCustomIDs[i])
	end
	return kNetStream,39308
end

function EncodeSendSeGC_Display_Dynamics_Toast(uiLanguage,iParamSize,auiCustomIDs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Dynamics_Toast'
		g_encodeCache['uiLanguage'] = uiLanguage
		g_encodeCache['iParamSize'] = iParamSize
		g_encodeCache['auiCustomIDs'] = auiCustomIDs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiLanguage)
	kNetStream:WriteInt(iParamSize)
	for i = 0,iParamSize or -1 do
		if i >= iParamSize then
			break
		end
		kNetStream:WriteInt(auiCustomIDs[i])
	end
	return kNetStream,39387
end

function EncodeSendSeGC_Click_ChangeSubRole(uiRoleUID,uiSubRoleTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_ChangeSubRole'
		g_encodeCache['uiRoleUID'] = uiRoleUID
		g_encodeCache['uiSubRoleTypeID'] = uiSubRoleTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleUID)
	kNetStream:WriteInt(uiSubRoleTypeID)
	return kNetStream,39311
end

function EncodeSendSeGC_Click_BreakDispLimit(uiRoleUID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_BreakDispLimit'
		g_encodeCache['uiRoleUID'] = uiRoleUID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleUID)
	return kNetStream,39370
end

function EncodeSendSeGC_Click_ConsultClose(uiRoleUID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_ConsultClose'
		g_encodeCache['uiRoleUID'] = uiRoleUID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleUID)
	return kNetStream,39398
end

function EncodeSendSeGC_Click_LeaveTeam(uiRoleUID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_LeaveTeam'
		g_encodeCache['uiRoleUID'] = uiRoleUID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleUID)
	return kNetStream,39399
end

function EncodeSendSeGC_Display_UnLeaveable_Update(iNum,auiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_UnLeaveable_Update'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['auiRoleID'] = auiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(auiRoleID[i])
	end
	return kNetStream,39400
end

function EncodeSendSeGC_Display_UpdateChoiceInfo(uiChoiceLangID,uiTextLangID,uiRoleBaseID,uiCustomModelID,acPlayerName,bIsLocked,bIsImportantChoice,uiTaskID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_UpdateChoiceInfo'
		g_encodeCache['uiChoiceLangID'] = uiChoiceLangID
		g_encodeCache['uiTextLangID'] = uiTextLangID
		g_encodeCache['uiRoleBaseID'] = uiRoleBaseID
		g_encodeCache['uiCustomModelID'] = uiCustomModelID
		g_encodeCache['acPlayerName'] = acPlayerName
		g_encodeCache['bIsLocked'] = bIsLocked
		g_encodeCache['bIsImportantChoice'] = bIsImportantChoice
		g_encodeCache['uiTaskID'] = uiTaskID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiChoiceLangID)
	kNetStream:WriteInt(uiTextLangID)
	kNetStream:WriteInt(uiRoleBaseID)
	kNetStream:WriteInt(uiCustomModelID)
	kNetStream:WriteString(acPlayerName)
	kNetStream:WriteByte(bIsLocked)
	kNetStream:WriteByte(bIsImportantChoice)
	kNetStream:WriteInt(uiTaskID)
	return kNetStream,39401
end

function EncodeSendSeGC_Display_ShowChoiceWindow(uiTaskID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ShowChoiceWindow'
		g_encodeCache['uiTaskID'] = uiTaskID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTaskID)
	return kNetStream,39402
end

function EncodeSendSeGC_Display_ClearChoiceInfo(uiTaskID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ClearChoiceInfo'
		g_encodeCache['uiTaskID'] = uiTaskID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTaskID)
	return kNetStream,39403
end

function EncodeSendSeGC_Display_Start_Guide(uiGuideID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Start_Guide'
		g_encodeCache['uiGuideID'] = uiGuideID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiGuideID)
	return kNetStream,39404
end

function EncodeSendSeGC_Display_RedKnife_Update(uiID,uiCuiLian,uiItemID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RedKnife_Update'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiCuiLian'] = uiCuiLian
		g_encodeCache['uiItemID'] = uiItemID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(uiCuiLian)
	kNetStream:WriteInt(uiItemID)
	return kNetStream,39405
end

function EncodeSendSeGC_Display_RedKnife_Delete(uiID,uiItemID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RedKnife_Delete'
		g_encodeCache['uiID'] = uiID
		g_encodeCache['uiItemID'] = uiItemID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiID)
	kNetStream:WriteInt(uiItemID)
	return kNetStream,39406
end

function EncodeSendSeGC_Display_End(uiParam)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_End'
		g_encodeCache['uiParam'] = uiParam
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiParam)
	return kNetStream,39407
end

function EncodeSendSeGC_Click_Clan_Join(uiRoleTypeID,uiClanTypeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Clan_Join'
		g_encodeCache['uiRoleTypeID'] = uiRoleTypeID
		g_encodeCache['uiClanTypeID'] = uiClanTypeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleTypeID)
	kNetStream:WriteInt(uiClanTypeID)
	return kNetStream,39408
end

function EncodeSendSeGC_Display_Clan_Info_Update(kClanEliminate)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Clan_Info_Update'
		g_encodeCache['kClanEliminate'] = kClanEliminate
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(kClanEliminate["uiClanTypeID"])
	kNetStream:WriteInt(kClanEliminate["uiClanDisplayState"])
	kNetStream:WriteInt(kClanEliminate["uiClanState"])
	kNetStream:WriteInt(kClanEliminate["iClanDisposition"])
	return kNetStream,39409
end

function EncodeSendSeGC_Click_Clan_Enter(uiClanID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Clan_Enter'
		g_encodeCache['uiClanID'] = uiClanID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanID)
	return kNetStream,39410
end

function EncodeSendSeGC_Click_Clan_Mission_Start(uiClanID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Clan_Mission_Start'
		g_encodeCache['uiClanID'] = uiClanID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanID)
	return kNetStream,39411
end

function EncodeSendSeGC_Click_Clan_Mission_Select_Role(uiClanID,uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Clan_Mission_Select_Role'
		g_encodeCache['uiClanID'] = uiClanID
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanID)
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39412
end

function EncodeSendSeGC_Click_Clan_Martial_Learn(uiClanID,uiMartialID,uiConditionID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_Clan_Martial_Learn'
		g_encodeCache['uiClanID'] = uiClanID
		g_encodeCache['uiMartialID'] = uiMartialID
		g_encodeCache['uiConditionID'] = uiConditionID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiClanID)
	kNetStream:WriteInt(uiMartialID)
	kNetStream:WriteInt(uiConditionID)
	return kNetStream,39413
end

function EncodeSendSeGC_Display_Clan_Branch_Info_Update(kClanBranch)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Clan_Branch_Info_Update'
		g_encodeCache['kClanBranch'] = kClanBranch
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(kClanBranch["uiClanTypeID"])
	kNetStream:WriteInt(kClanBranch["uiClanNameID"])
	kNetStream:WriteInt(kClanBranch["iDonateNum"])
	kNetStream:WriteInt(kClanBranch["uiClanCityID"])
	kNetStream:WriteInt(kClanBranch["uiClanState"])
	kNetStream:WriteInt(kClanBranch["uiClanTreasureID"])
	return kNetStream,39414
end

function EncodeSendSeGC_Display_Clan_Branch_Result(iResult)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Clan_Branch_Result'
		g_encodeCache['iResult'] = iResult
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iResult)
	return kNetStream,39415
end

function EncodeSendSeGC_Click_AIInfo(uiRoleID,iIndex)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_AIInfo'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['iIndex'] = iIndex
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(iIndex)
	return kNetStream,39416
end

function EncodeSendSeGC_Click_UploadAIInfo(uiRoleID,iIndex,iNum,actionList)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_UploadAIInfo'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['iIndex'] = iIndex
		g_encodeCache['iNum'] = iNum
		g_encodeCache['actionList'] = actionList
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteByte(iIndex)
	kNetStream:WriteByte(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteDword64(actionList[i])
	end
	return kNetStream,39417
end

function EncodeSendSeGC_Click_UpdateRoleEmbattle(iID,iRound,iNum,akRoleEmbattle)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_UpdateRoleEmbattle'
		g_encodeCache['iID'] = iID
		g_encodeCache['iRound'] = iRound
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRoleEmbattle'] = akRoleEmbattle
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iID)
	kNetStream:WriteByte(iRound)
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
	return kNetStream,39418
end

function EncodeSendSeGC_Display_UpdateRoleEmbattleRet(iID,iRound,bSuccess)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_UpdateRoleEmbattleRet'
		g_encodeCache['iID'] = iID
		g_encodeCache['iRound'] = iRound
		g_encodeCache['bSuccess'] = bSuccess
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(iID)
	kNetStream:WriteByte(iRound)
	kNetStream:WriteByte(bSuccess)
	return kNetStream,39419
end

function EncodeSendSeGC_Display_InitRoleEmbattle(iNum,akRoleEmbattle)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_InitRoleEmbattle'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRoleEmbattle'] = akRoleEmbattle
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
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
	return kNetStream,39420
end

function EncodeSendSeGC_UpdateRanklist(iNum,akRanklistInfos)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_UpdateRanklist'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRanklistInfos'] = akRanklistInfos
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akRanklistInfos[i]["uiRankID"])
		kNetStream:WriteInt(akRanklistInfos[i]["uiScore"])
		kNetStream:WriteByte(akRanklistInfos[i]["bIsAdd"])
	end
	return kNetStream,39421
end

function EncodeSendSeGC_DispalyBabyState(uiBabyRoleID,kBabyInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DispalyBabyState'
		g_encodeCache['uiBabyRoleID'] = uiBabyRoleID
		g_encodeCache['kBabyInfo'] = kBabyInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiBabyRoleID)
	kNetStream:WriteInt(kBabyInfo["uiStateID"])
	kNetStream:WriteInt(kBabyInfo["uiBabyID"])
	kNetStream:WriteInt(kBabyInfo["uiFatherID"])
	kNetStream:WriteInt(kBabyInfo["uiMotherID"])
	kNetStream:WriteInt(kBabyInfo["uiBirthday"])
	kNetStream:WriteInt(kBabyInfo["uiState"])
	kNetStream:WriteInt(kBabyInfo["uiNextLearnTime"])
	kNetStream:WriteString(kBabyInfo["acPlayerName"])
	kNetStream:WriteInt(kBabyInfo["uiMasterNum"])
	for i = 0,uiMasterNum or -1 do
		if i >= uiMasterNum then
			break
		end
		kNetStream:WriteInt(kBabyInfo["auiMasters"][i])
	end
	return kNetStream,39422
end

function EncodeSendSeGC_ArenaBattleCalc(kCalcInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ArenaBattleCalc'
		g_encodeCache['kCalcInfo'] = kCalcInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(kCalcInfo["uiMatchType"])
	kNetStream:WriteInt(kCalcInfo["uiMatchID"])
	kNetStream:WriteInt(kCalcInfo["uiRoundID"])
	kNetStream:WriteInt(kCalcInfo["uiBattleID"])
	kNetStream:WriteDword64(kCalcInfo["uiPlyID1"])
	kNetStream:WriteDword64(kCalcInfo["uiPlyID2"])
	kNetStream:WriteInt(kCalcInfo["uiBuffTypeID"])
	kNetStream:WriteInt(kCalcInfo["uiArenaTypeID"])
	kNetStream:WriteInt(kCalcInfo["uiEnemyArenaTypeID"])
	kNetStream:WriteInt(kCalcInfo["iPly1PkDataCount"])
	kNetStream:WriteInt(kCalcInfo["iPly2PkDataCount"])
	for i = 0,iPly1PkDataCount or -1 do
		if i >= iPly1PkDataCount then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly1PkData"][i]["iPkDataFlag"])
		kNetStream:WriteInt(kCalcInfo["akPly1PkData"][i]["iDataSize"])
		for j = 0,iDataSize or -1 do
		if j >= iDataSize then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly1PkData"][i]["akData"][j])
	end
	end
	for i = 0,iPly2PkDataCount or -1 do
		if i >= iPly2PkDataCount then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly2PkData"][i]["iPkDataFlag"])
		kNetStream:WriteInt(kCalcInfo["akPly2PkData"][i]["iDataSize"])
		for j = 0,iDataSize or -1 do
		if j >= iDataSize then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly2PkData"][i]["akData"][j])
	end
	end
	return kNetStream,39423
end

function EncodeSendSeGC_ArenaBattleCalcResult(uiSeqID,bEndPakcet,kResultInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ArenaBattleCalcResult'
		g_encodeCache['uiSeqID'] = uiSeqID
		g_encodeCache['bEndPakcet'] = bEndPakcet
		g_encodeCache['kResultInfo'] = kResultInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(uiSeqID)
	kNetStream:WriteByte(bEndPakcet)
	kNetStream:WriteInt(kResultInfo["uiMatchType"])
	kNetStream:WriteInt(kResultInfo["uiMatchID"])
	kNetStream:WriteInt(kResultInfo["uiRoundID"])
	kNetStream:WriteInt(kResultInfo["uiBattleID"])
	kNetStream:WriteDword64(kResultInfo["uiPlyID1"])
	kNetStream:WriteDword64(kResultInfo["uiPlyID2"])
	for i = 0,SSD_MAX_ARENA_ROLE_SIZE or -1 do
		if i >= SSD_MAX_ARENA_ROLE_SIZE then
			break
		end
		kNetStream:WriteInt(kResultInfo["aiClan1"][i])
	end
	for i = 0,SSD_MAX_ARENA_ROLE_SIZE or -1 do
		if i >= SSD_MAX_ARENA_ROLE_SIZE then
			break
		end
		kNetStream:WriteInt(kResultInfo["aiClan2"][i])
	end
	kNetStream:WriteDword64(kResultInfo["uiWinnerID"])
	kNetStream:WriteInt(kResultInfo["iRecordDataSize"])
	for i = 0,SSD_MAX_ARENA_RECORD_DATA_ALL_MAX_SIZE or -1 do
		if i >= SSD_MAX_ARENA_RECORD_DATA_ALL_MAX_SIZE then
			break
		end
		kNetStream:WriteByte(kResultInfo["akRecordData"][i])
	end
	return kNetStream,39424
end

function EncodeSendSeGC_ChallengePlatRoleCalc(kCalcInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ChallengePlatRoleCalc'
		g_encodeCache['kCalcInfo'] = kCalcInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(kCalcInfo["uiClientID1"])
	kNetStream:WriteDword64(kCalcInfo["uiPlyID1"])
	kNetStream:WriteDword64(kCalcInfo["uiPlyID2"])
	kNetStream:WriteInt(kCalcInfo["uiModelID2"])
	kNetStream:WriteInt(kCalcInfo["uiMeridian2"])
	kNetStream:WriteString(kCalcInfo["acPly1Name"])
	kNetStream:WriteString(kCalcInfo["acPly2Name"])
	kNetStream:WriteInt(kCalcInfo["iPly1PkDataCount"])
	kNetStream:WriteInt(kCalcInfo["iPly2PkDataCount"])
	for i = 0,iPly1PkDataCount or -1 do
		if i >= iPly1PkDataCount then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly1PkData"][i]["iPkDataFlag"])
		kNetStream:WriteInt(kCalcInfo["akPly1PkData"][i]["iDataSize"])
		for j = 0,iDataSize or -1 do
		if j >= iDataSize then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly1PkData"][i]["akData"][j])
	end
	end
	for i = 0,iPly2PkDataCount or -1 do
		if i >= iPly2PkDataCount then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly2PkData"][i]["iPkDataFlag"])
		kNetStream:WriteInt(kCalcInfo["akPly2PkData"][i]["iDataSize"])
		for j = 0,iDataSize or -1 do
		if j >= iDataSize then
			break
		end
		kNetStream:WriteByte(kCalcInfo["akPly2PkData"][i]["akData"][j])
	end
	end
	kNetStream:WriteInt(kCalcInfo["uiBattleID"])
	kNetStream:WriteInt(kCalcInfo["uiMatchType"])
	return kNetStream,39425
end

function EncodeSendSeGC_GiveUpChallengePlatRoleCalc(defPlayerID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_GiveUpChallengePlatRoleCalc'
		g_encodeCache['defPlayerID'] = defPlayerID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(defPlayerID)
	return kNetStream,39426
end

function EncodeSendSeGC_ZmBattleCalc(kCalcInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ZmBattleCalc'
		g_encodeCache['kCalcInfo'] = kCalcInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(kCalcInfo["nRoomId"])
	kNetStream:WriteInt(kCalcInfo["uiRoundID"])
	kNetStream:WriteInt(kCalcInfo["uiBattleID"])
	kNetStream:WriteInt(kCalcInfo["uiFightID"])
	kNetStream:WriteDword64(kCalcInfo["kPlayerInfo1"]["defPlayerID"])
	kNetStream:WriteString(kCalcInfo["kPlayerInfo1"]["acPlayerName"])
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["akCardData"][i]["dwBaseId"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["akCardData"][i]["dwLv"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["akCardData"][i]["dwId"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["akCardData"][i]["dwEquipId"])
		kNetStream:WriteShort(kCalcInfo["kPlayerInfo1"]["akCardData"][i]["wX"])
		kNetStream:WriteShort(kCalcInfo["kPlayerInfo1"]["akCardData"][i]["wY"])
	end
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["akEquipData"][i]["dwBaseId"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["akEquipData"][i]["dwLv"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["akEquipData"][i]["dwId"])
	end
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["dwClan"])
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["dwBuffID"])
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["dwClanBuffID"])
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo1"]["dwClanBuffCount"])
	kNetStream:WriteDword64(kCalcInfo["kPlayerInfo2"]["defPlayerID"])
	kNetStream:WriteString(kCalcInfo["kPlayerInfo2"]["acPlayerName"])
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["akCardData"][i]["dwBaseId"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["akCardData"][i]["dwLv"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["akCardData"][i]["dwId"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["akCardData"][i]["dwEquipId"])
		kNetStream:WriteShort(kCalcInfo["kPlayerInfo2"]["akCardData"][i]["wX"])
		kNetStream:WriteShort(kCalcInfo["kPlayerInfo2"]["akCardData"][i]["wY"])
	end
	for i = 0,SSD_MAX_ZM_BATTLE_CARD_SIZE or -1 do
		if i >= SSD_MAX_ZM_BATTLE_CARD_SIZE then
			break
		end
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["akEquipData"][i]["dwBaseId"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["akEquipData"][i]["dwLv"])
		kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["akEquipData"][i]["dwId"])
	end
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["dwClan"])
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["dwBuffID"])
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["dwClanBuffID"])
	kNetStream:WriteInt(kCalcInfo["kPlayerInfo2"]["dwClanBuffCount"])
	kNetStream:WriteInt(kCalcInfo["iFreezeCardNum"])
	for i = 0,iFreezeCardNum or -1 do
		if i >= iFreezeCardNum then
			break
		end
		kNetStream:WriteInt(kCalcInfo["akFreezeCardData"][i])
	end
	return kNetStream,39427
end

function EncodeSendSeGC_ZmBattleCalcResult(kResultInfo)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ZmBattleCalcResult'
		g_encodeCache['kResultInfo'] = kResultInfo
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(kResultInfo["nRoomId"])
	kNetStream:WriteInt(kResultInfo["uiRoundID"])
	kNetStream:WriteInt(kResultInfo["uiBattleID"])
	kNetStream:WriteDword64(kResultInfo["uiPlyID1"])
	kNetStream:WriteDword64(kResultInfo["uiPlyID2"])
	kNetStream:WriteDword64(kResultInfo["uiWinnerID"])
	kNetStream:WriteInt(kResultInfo["iRecordDataSize"])
	for i = 0,SSD_MAX_ARENA_RECORD_DATA_MAX_SIZE or -1 do
		if i >= SSD_MAX_ARENA_RECORD_DATA_MAX_SIZE then
			break
		end
		kNetStream:WriteByte(kResultInfo["akRecordData"][i])
	end
	return kNetStream,39428
end

function EncodeSendSeGC_Display_DuelRole(uiResult,uiMapID,uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_DuelRole'
		g_encodeCache['uiResult'] = uiResult
		g_encodeCache['uiMapID'] = uiMapID
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiResult)
	kNetStream:WriteInt(uiMapID)
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39429
end

function EncodeSendSeGC_ShowChooseRole(uiParam1)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ShowChooseRole'
		g_encodeCache['uiParam1'] = uiParam1
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiParam1)
	return kNetStream,39430
end

function EncodeSendSeGC_ArenaBattleBigCmdPack(kBatchData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ArenaBattleBigCmdPack'
		g_encodeCache['kBatchData'] = kBatchData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(kBatchData["uiTotalSize"])
	kNetStream:WriteInt(kBatchData["uiBatchIdx"])
	kNetStream:WriteInt(kBatchData["uiBatchSize"])
	for i = 0,uiBatchSize or -1 do
		if i >= uiBatchSize then
			break
		end
		kNetStream:WriteByte(kBatchData["akData"][i])
	end
	return kNetStream,39431
end

function EncodeSendSeGC_StartShareLimitShop(uiParam1,uiParam2)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_StartShareLimitShop'
		g_encodeCache['uiParam1'] = uiParam1
		g_encodeCache['uiParam2'] = uiParam2
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiParam1)
	kNetStream:WriteInt(uiParam2)
	return kNetStream,39432
end

function EncodeSendSeGC_RoleLearnSecretBookMartial(uiRoleID,uiItemID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_RoleLearnSecretBookMartial'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiItemID'] = uiItemID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiItemID)
	return kNetStream,39433
end

function EncodeSendSeGC_Display_DiffDropUpdate(iNum,akSaveData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_DiffDropUpdate'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akSaveData'] = akSaveData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(akSaveData[i]["uiTypeID"])
		kNetStream:WriteShort(akSaveData[i]["uiAccumulateTime"])
		kNetStream:WriteInt(akSaveData[i]["uiRoundFinish"])
	end
	return kNetStream,39434
end

function EncodeSendSeGC_Display_ForceWeekEnd(uiFree)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ForceWeekEnd'
		g_encodeCache['uiFree'] = uiFree
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFree)
	return kNetStream,39435
end

function EncodeSendSeGC_Click_RoleChallengeSelectRole(uiRoleID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_RoleChallengeSelectRole'
		g_encodeCache['uiRoleID'] = uiRoleID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	return kNetStream,39436
end

function EncodeSendSeGC_Click_MartialStrong(uiRoleID,uiMartialTypeID,uiLevel)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_MartialStrong'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiMartialTypeID'] = uiMartialTypeID
		g_encodeCache['uiLevel'] = uiLevel
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiMartialTypeID)
	kNetStream:WriteByte(uiLevel)
	return kNetStream,39437
end

function EncodeSendSeGC_Display_MartialStrong(iResult,uiRoleID,uiMartialTypeID,uiLevel)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MartialStrong'
		g_encodeCache['iResult'] = iResult
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiMartialTypeID'] = uiMartialTypeID
		g_encodeCache['uiLevel'] = uiLevel
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iResult)
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiMartialTypeID)
	kNetStream:WriteByte(uiLevel)
	return kNetStream,39438
end

function EncodeSendSeGC_Click_MakeMartialSecret(uiMartialID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_MakeMartialSecret'
		g_encodeCache['uiMartialID'] = uiMartialID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMartialID)
	return kNetStream,39439
end

function EncodeSendSeGC_Display_MakeMartialSecret(iResult)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_MakeMartialSecret'
		g_encodeCache['iResult'] = iResult
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iResult)
	return kNetStream,39440
end

function EncodeSendSeGC_Display_ResDropActivity(iNum,aiOpenActivities,iTaskNum,aiExchangeNum,bIsNew,iAddMeridianExp)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ResDropActivity'
		g_encodeCache['iNum'] = iNum
		g_encodeCache['aiOpenActivities'] = aiOpenActivities
		g_encodeCache['iTaskNum'] = iTaskNum
		g_encodeCache['aiExchangeNum'] = aiExchangeNum
		g_encodeCache['bIsNew'] = bIsNew
		g_encodeCache['iAddMeridianExp'] = iAddMeridianExp
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iNum)
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
		end
		kNetStream:WriteInt(aiOpenActivities[i])
	end
	kNetStream:WriteInt(iTaskNum)
	for i = 0,iTaskNum or -1 do
		if i >= iTaskNum then
			break
		end
		kNetStream:WriteInt(aiExchangeNum[i])
	end
	kNetStream:WriteByte(bIsNew)
	kNetStream:WriteInt(iAddMeridianExp)
	return kNetStream,39441
end

function EncodeSendSeGC_Display_CollectActivityExchangeRes(bRes,uiCollectActivityID,uiExchangeNum)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_CollectActivityExchangeRes'
		g_encodeCache['bRes'] = bRes
		g_encodeCache['uiCollectActivityID'] = uiCollectActivityID
		g_encodeCache['uiExchangeNum'] = uiExchangeNum
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bRes)
	kNetStream:WriteInt(uiCollectActivityID)
	kNetStream:WriteInt(uiExchangeNum)
	return kNetStream,39442
end

function EncodeSendSeGC_Display_UpdateSameThreadPlayerInfo(uiPlayerID,uiModelID,uiPetID,bIsUnlockHouse,acOpenID,acVOpenID,acPlayerName)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_UpdateSameThreadPlayerInfo'
		g_encodeCache['uiPlayerID'] = uiPlayerID
		g_encodeCache['uiModelID'] = uiModelID
		g_encodeCache['uiPetID'] = uiPetID
		g_encodeCache['bIsUnlockHouse'] = bIsUnlockHouse
		g_encodeCache['acOpenID'] = acOpenID
		g_encodeCache['acVOpenID'] = acVOpenID
		g_encodeCache['acPlayerName'] = acPlayerName
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiPlayerID)
	kNetStream:WriteInt(uiModelID)
	kNetStream:WriteInt(uiPetID)
	kNetStream:WriteByte(bIsUnlockHouse)
	kNetStream:WriteString(acOpenID)
	kNetStream:WriteString(acVOpenID)
	kNetStream:WriteString(acPlayerName)
	return kNetStream,39443
end

function EncodeSendSeGC_Display_NoticeClientFightPlayer(uiPlayerID,uiModelID,acPlayerName)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_NoticeClientFightPlayer'
		g_encodeCache['uiPlayerID'] = uiPlayerID
		g_encodeCache['uiModelID'] = uiModelID
		g_encodeCache['acPlayerName'] = acPlayerName
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiPlayerID)
	kNetStream:WriteInt(uiModelID)
	kNetStream:WriteString(acPlayerName)
	return kNetStream,39444
end

function EncodeSendSeGC_Display_NoticeClientAddFriend(uiFriendPlayerID,acOpenID,acVOpenID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_NoticeClientAddFriend'
		g_encodeCache['uiFriendPlayerID'] = uiFriendPlayerID
		g_encodeCache['acOpenID'] = acOpenID
		g_encodeCache['acVOpenID'] = acVOpenID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiFriendPlayerID)
	kNetStream:WriteString(acOpenID)
	kNetStream:WriteString(acVOpenID)
	return kNetStream,39445
end

function EncodeSendSeGC_Display_LevelUP(uiRoleID,uiMartialID,uiOldLevel,uiNewLevel,bHasNewAttr)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_LevelUP'
		g_encodeCache['uiRoleID'] = uiRoleID
		g_encodeCache['uiMartialID'] = uiMartialID
		g_encodeCache['uiOldLevel'] = uiOldLevel
		g_encodeCache['uiNewLevel'] = uiNewLevel
		g_encodeCache['bHasNewAttr'] = bHasNewAttr
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiRoleID)
	kNetStream:WriteInt(uiMartialID)
	kNetStream:WriteInt(uiOldLevel)
	kNetStream:WriteInt(uiNewLevel)
	kNetStream:WriteByte(bHasNewAttr)
	return kNetStream,39446
end

function EncodeSendSeGC_Display_ClearAllChoiceInfo(uiTemp)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ClearAllChoiceInfo'
		g_encodeCache['uiTemp'] = uiTemp
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTemp)
	return kNetStream,39447
end

function EncodeSendSeGC_Display_ShowCommonEmbattle(uiType)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_ShowCommonEmbattle'
		g_encodeCache['uiType'] = uiType
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiType)
	return kNetStream,39448
end

function EncodeSendSeGC_Click_CommonEmbattleResult(bSubmit)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_CommonEmbattleResult'
		g_encodeCache['bSubmit'] = bSubmit
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bSubmit)
	return kNetStream,39449
end

function EncodeSendSeGC_DisplayUpdateCustomAdvLoot(uiTaskEventID,bEnable)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayUpdateCustomAdvLoot'
		g_encodeCache['uiTaskEventID'] = uiTaskEventID
		g_encodeCache['bEnable'] = bEnable
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiTaskEventID)
	kNetStream:WriteByte(bEnable)
	return kNetStream,39450
end

function EncodeSendSeGC_ClickPickCustomAdvLoot(uiCount,auiTaskEventIDs)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ClickPickCustomAdvLoot'
		g_encodeCache['uiCount'] = uiCount
		g_encodeCache['auiTaskEventIDs'] = auiTaskEventIDs
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiCount)
	for i = 0,uiCount or -1 do
		if i >= uiCount then
			break
		end
		kNetStream:WriteInt(auiTaskEventIDs[i])
	end
	return kNetStream,39451
end

function EncodeSendSeGC_DisplayAutoBattleTestReplay(uiBattleID,defPlayerID,winPlayerID,dwTotalSize,uiBatchIdx,iBatchSize,akData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_DisplayAutoBattleTestReplay'
		g_encodeCache['uiBattleID'] = uiBattleID
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['winPlayerID'] = winPlayerID
		g_encodeCache['dwTotalSize'] = dwTotalSize
		g_encodeCache['uiBatchIdx'] = uiBatchIdx
		g_encodeCache['iBatchSize'] = iBatchSize
		g_encodeCache['akData'] = akData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
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
	return kNetStream,39457
end

function EncodeSendSeGC_ShowDialog(uiDialogType,uiTitle,uiContent,uiTask,uiTaskRet,uiTaskRet2)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_ShowDialog'
		g_encodeCache['uiDialogType'] = uiDialogType
		g_encodeCache['uiTitle'] = uiTitle
		g_encodeCache['uiContent'] = uiContent
		g_encodeCache['uiTask'] = uiTask
		g_encodeCache['uiTaskRet'] = uiTaskRet
		g_encodeCache['uiTaskRet2'] = uiTaskRet2
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiDialogType)
	kNetStream:WriteInt(uiTitle)
	kNetStream:WriteInt(uiContent)
	kNetStream:WriteInt(uiTask)
	kNetStream:WriteInt(uiTaskRet)
	kNetStream:WriteInt(uiTaskRet2)
	return kNetStream,39453
end

function EncodeSendSeGC_Click_RoleFaceOperate(eOprType,uiParam,kRoleFaceData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_RoleFaceOperate'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['uiParam'] = uiParam
		g_encodeCache['kRoleFaceData'] = kRoleFaceData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(uiParam)
	kNetStream:WriteInt(kRoleFaceData["uiHat"])
	kNetStream:WriteInt(kRoleFaceData["uiBack"])
	kNetStream:WriteInt(kRoleFaceData["uiHairBack"])
	kNetStream:WriteInt(kRoleFaceData["uiBody"])
	kNetStream:WriteInt(kRoleFaceData["uiFace"])
	kNetStream:WriteInt(kRoleFaceData["uiEyebrow"])
	kNetStream:WriteInt(kRoleFaceData["uiEye"])
	kNetStream:WriteInt(kRoleFaceData["uiMouth"])
	kNetStream:WriteInt(kRoleFaceData["uiNose"])
	kNetStream:WriteInt(kRoleFaceData["uiForeheadAdornment"])
	kNetStream:WriteInt(kRoleFaceData["uiFacialAdornment"])
	kNetStream:WriteInt(kRoleFaceData["uiHairFront"])
	kNetStream:WriteInt(kRoleFaceData["iEyebrowWidth"])
	kNetStream:WriteInt(kRoleFaceData["iEyebrowHeight"])
	kNetStream:WriteInt(kRoleFaceData["iEyebrowLocation"])
	kNetStream:WriteInt(kRoleFaceData["iEyeWidth"])
	kNetStream:WriteInt(kRoleFaceData["iEyeHeight"])
	kNetStream:WriteInt(kRoleFaceData["iEyeLocation"])
	kNetStream:WriteInt(kRoleFaceData["iNoseWidth"])
	kNetStream:WriteInt(kRoleFaceData["iNoseHeight"])
	kNetStream:WriteInt(kRoleFaceData["iNoseLocation"])
	kNetStream:WriteInt(kRoleFaceData["iMouthWidth"])
	kNetStream:WriteInt(kRoleFaceData["iMouthHeight"])
	kNetStream:WriteInt(kRoleFaceData["iMouthLocation"])
	kNetStream:WriteInt(kRoleFaceData["uiModelID"])
	kNetStream:WriteInt(kRoleFaceData["uiSex"])
	kNetStream:WriteInt(kRoleFaceData["uiCGSex"])
	kNetStream:WriteInt(kRoleFaceData["uiRoleID"])
	return kNetStream,39458
end

function EncodeSendSeGC_Display_RoleFaceQuery(uiScriptID,iNum,akRoleFaceData)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleFaceQuery'
		g_encodeCache['uiScriptID'] = uiScriptID
		g_encodeCache['iNum'] = iNum
		g_encodeCache['akRoleFaceData'] = akRoleFaceData
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
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
	return kNetStream,39455
end

function EncodeSendSeGC_Display_RoleFaceResult(eOprType,nResult,uiScriptID,uiParam)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_RoleFaceResult'
		g_encodeCache['eOprType'] = eOprType
		g_encodeCache['nResult'] = nResult
		g_encodeCache['uiScriptID'] = uiScriptID
		g_encodeCache['uiParam'] = uiParam
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eOprType)
	kNetStream:WriteInt(nResult)
	kNetStream:WriteInt(uiScriptID)
	kNetStream:WriteInt(uiParam)
	return kNetStream,39460
end

function EncodeSendSeGC_Click_MazeEntry(uiMazeID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Click_MazeEntry'
		g_encodeCache['uiMazeID'] = uiMazeID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(uiMazeID)
	return kNetStream,39452
end

function EncodeSendSeGC_Display_Disguise(bRefresh)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeGC_Display_Disguise'
		g_encodeCache['bRefresh'] = bRefresh
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteByte(bRefresh)
	return kNetStream,39454
end

