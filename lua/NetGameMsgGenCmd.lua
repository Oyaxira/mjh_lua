
-- 地图操作统一接口
function SendClickMap(eType,mapID)
    local clickMapData = EncodeSendSeGC_ClickMap(eType, mapID or 0)
    local iSize = clickMapData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_MAP,iSize,clickMapData)
    -- 等待下行
    WaitDisplayMsg()
end

-- NPC操作统一接口
function SendClickNpcCMD(mapID, roleID, mazeTypeID, mazeAreaIndex, mazeRow, mazeColumn)
    -- 纠正RoleID
    roleID = RoleDataManager:GetInstance():CorrectRoleID(roleID)
    local clickNpcData = EncodeSendSeGC_ClickNPC(mapID, roleID, mazeTypeID, mazeAreaIndex, mazeRow, mazeColumn)
    local iSize = clickNpcData:GetCurPos()

    NetGameCmdSend(SGC_CLICK_NPC,iSize,clickNpcData)
    -- 等待下行
    WaitDisplayMsg()
end

function SendClickDialogCMD(dialogType, task, taskRet, retValue, taskRet2, retValue2)
    local data = EncodeSendSeGC_ClickDialog(dialogType, task, taskRet, retValue, taskRet2, retValue2)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_DIALOG,iSize,data)
    -- 等待下行
    WaitDisplayMsg()
end

-- 发送清空交互信息请求
function SendClearInteractInfoCMD()
    local data = EncodeSendSeGC_ClickClearInteractInfo(0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CLEAR_INTERACT_INFO,iSize,data)
end

-- 物品操作统一接口
function SendClickItemCMD(type, roleid, itemid, uinum, uichooseNum, adwchooseitem, uiMakerID, uiDynamicAttrID, isPerfect, uiGiveupDynamicAttrID, iItemNum, auiItem, mapID, mazeBaseID, roleBaseID)
    local clickItemData = EncodeSendSeGC_ClickItemOpr(type, roleid or 0, itemid or 0, uinum or 0, uichooseNum or 0, adwchooseitem or {}, uiMakerID or 0,uiDynamicAttrID or 0,isPerfect or 0,uiGiveupDynamicAttrID or 0,iItemNum or 0,auiItem or {}, mapID, mazeBaseID, roleBaseID)
    local iSize = clickItemData:GetCurPos();
    NetGameCmdSend(SGC_CLICK_ITEM_OP, iSize, clickItemData)
end

-- 迷宫操作统一接口
function SendClickMaze(eType, row, column)
    local mazeDataMgrInst = MazeDataManager:GetInstance()
    local curMazeID = mazeDataMgrInst:GetCurMazeID()
    local curAreaIndex = mazeDataMgrInst:GetCurAreaIndex()
    local clickMazeData = EncodeSendSeGC_ClickMaze(eType, curMazeID, curAreaIndex, row or 0, column or 0)
    local iSize = clickMazeData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_MAZE,iSize,clickMazeData)
    WaitDisplayMsg()
end

-- 商店操作统一接口
function SendClickShop(eShopType, uiShopID, uiNum, akItemData, uiMapID, uiMazeID, uiRoleBaseID)
    local clickBuyData = EncodeSendSeGC_Click_ShopOpr(eShopType, uiShopID or 0, uiNum or 0, akItemData or {}, uiMapID, uiMazeID, uiRoleBaseID)
    iSize = clickBuyData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLE_SHOP_OP, iSize, clickBuyData)
end

function SendEquipItemCMD(roleID, itemID)
    -- local clickEquipItemData = EncodeSendSeGC_ClickEquipItem(roleID, itemID)
    -- local iSize = clickEquipItemData:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ROLE_EQUIP_ITEM, iSize, clickEquipItemData)

    SendClickItemCMD(CIT_EQUIP, roleID, itemID, 0, 0, nil, 0,0,0,0,0,{})
end

function SendUnequipItemCMD(roleID, itemID)
    -- local clickUnequipItemData = EncodeSendSeGC_ClickUnequipItem(roleID, itemID)
    -- local iSize = clickUnequipItemData:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ROLE_UNEQUIP_ITEM, iSize, clickUnequipItemData)
    SendClickItemCMD(CIT_UNEQUIP, roleID, itemID, 0, 0, nil, 0,0,0,0,0,{})
end

function SendUseItemCMD(roleID, itemID, count, choosenum, ChooseItems)
    SendClickItemCMD(CIT_USE, roleID, itemID, count, choosenum, ChooseItems, 0,0,0,0,0,{})
end

-- 点击残章匣，发送这个
function SendClickIncompleteBoxCMD(roleID)
    local clickBoxData = EncodeSendSeGC_Click_InCompleteBookBox(roleID)
    local iSize = clickBoxData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_INCOMPLETE_BOOK_BOX, iSize, clickBoxData)
end

function SendRandomGiftCMD(uiType, roleID, count)
    -- uiType 0 代表初始化,1代表主动刷新
    local clickUseGiftData = EncodeSendSeGC_ClickRandomGift(uiType, roleID, count)
    local iSize = clickUseGiftData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLE_RANDOM_GIFT, iSize, clickUseGiftData)
end

function SendDeleteGiftCMD(roleID, giftID, giftTypeID)
    local clickDeleteGift = EncodeSendSeGC_ClickRoleDelGift(roleID, giftID, giftTypeID)
    local iSize = clickDeleteGift:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLE_DEL_GIFT, iSize, clickDeleteGift)
end

function SendRandomWishRewardsCMD(uiType,roleID, wishTaskID,count)
    local clickUseWishRewardsData = EncodeSendSeGC_ClickRandomWishRewards(uiType,roleID,wishTaskID, count)
    local iSize = clickUseWishRewardsData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLE_RANDOM_WISHREWARDS, iSize, clickUseWishRewardsData)
end

function SendChooseWishRewardsCMD(roleID, wishtaskID,rewardID)
    local clickUseWishRewardsData = EncodeSendSeGC_ClickChooseWishRewards(roleID,wishtaskID,rewardID)
    local iSize = clickUseWishRewardsData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLE_CHOOSE_WISHREWARD, iSize, clickUseWishRewardsData)
end

function SendNPCInteractOperCMD(eNPCInteractType, param1, param2, param3)
    param1 = param1 or 0
    param2 = param2 or 0
    param3 = param3 or 0
    local bNpcOper = false

    -- TODO 数据上报
    if eNPCInteractType == NPCIT_COMPARE or --切磋
    eNPCInteractType == NPCIT_GIFT or       --送礼
    eNPCInteractType == NPCIT_BEG or        --乞讨
    eNPCInteractType == NPCIT_FIGHT or      --决斗
    eNPCInteractType == NPCIT_CALLUP or     --惩恶
    eNPCInteractType == NPCIT_PUNISH or     --号召
    eNPCInteractType == NPCIT_INQUIRY or    --盘查
    eNPCInteractType == NPCIT_CONSULT_GIFT or    --请教天赋
    eNPCInteractType == NPCIT_CONSULT_MARTIAL or --请教武学
    eNPCInteractType == NPCIT_STEAL_GIFT or      --偷学天赋
    eNPCInteractType == NPCIT_STEAL_MARTIAL or   --偷学武学
    eNPCInteractType == NPCIT_STEAL_MARTIAL then --偷学武学
        bNpcOper = true
    end

    if bNpcOper then
        -- 纠正roleID
        param1 = RoleDataManager:GetInstance():CorrectRoleID(param1)
    end
    local clickdata = EncodeSendSeGC_Click_NPC_InteractOper(eNPCInteractType, param1, param2, param3)
    local iSize = clickdata:GetCurPos()
    NetGameCmdSend(SGC_CLICK_NPC_INTERACT_OPER, iSize, clickdata)

    if bNpcOper then
        MSDKHelper:SetQQAchievementData('selectrole', eNPCInteractType);
        MSDKHelper:SendAchievementsData('selectrole');
    end
end

function SendTitleSelectCMD(uiTitleID)
    uiTitleID = uiTitleID or 0
    local clickdata = EncodeSendSeGC_ClickSetTitle(uiTitleID)
    local iSize = clickdata:GetCurPos()
    NetGameCmdSend(SGC_CLICK_SET_TITLE, iSize, clickdata)
end

function SendBabyLearnCMD(uiBabyRoleID, uiMasterTypeID)
    local clickdata = EncodeSendSeGC_ClickBabyLearn(uiBabyRoleID, uiMasterTypeID)
    local iSize = clickdata:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BABY_LEARN, iSize, clickdata)
end

function SendChangeSubRoleCMD(uiRoleID, uiSubroleTypeID)
    local clickdata = EncodeSendSeGC_Click_ChangeSubRole(uiRoleID, uiSubroleTypeID)
    local iSize = clickdata:GetCurPos()
    NetGameCmdSend(SGC_CLICK_SET_SUBROLE, iSize, clickdata)
end

function SendLeaveTeamCMD(uiRoleID)
    local clickdata = EncodeSendSeGC_Click_LeaveTeam(uiRoleID)
    local iSize = clickdata:GetCurPos()
    NetGameCmdSend(SGC_CLICK_LEAVETEAM, iSize, clickdata)
end

function SendBreakDispLimitCMD(uiRoleID)
    local clickdata = EncodeSendSeGC_Click_BreakDispLimit(uiRoleID)
    local iSize = clickdata:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BREAK_DISP_LIMIT, iSize, clickdata)
end

function SendUpdateEmbattleData(embattleData,iToggle,iRound)
    local sendData = {}
    local cloneData = clone(embattleData)
    local iNum = #cloneData
    for i = 1,iNum do --c++里从0开始 lua用1开始
        sendData[i-1] = cloneData[i]
        sendData[i-1].iGridX = sendData[i-1].iGridX - 1 
        sendData[i-1].iGridY = sendData[i-1].iGridY - 1
    end

    local data =  EncodeSendSeGC_Click_UpdateRoleEmbattle(iToggle,iRound,iNum,sendData)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_UPDATE_EMBATTLE_ROLES, iSize, data)
end

-- function SendClickMazeQuitCMD()
--     local data = EncodeSendSeGC_ClickMazeQuit(0)
--     local iSize = data:GetCurPos()
--     NetGameCmdSend(SGC_CLICK_MAZE_QUIT,iSize,data)
-- end

function SendSetEmBattleSubRoleCMD(uiRoleID, uiSubroleID)
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiRoleID)
    if roleData and roleData.uiSubRole > 0 then
        local subRoleID = RoleDataManager:GetInstance():GetRoleID(roleData.uiSubRole)
        if subRoleID == uiSubroleID then
            uiSubroleID = 0
        end
    end

    local clickdata = EncodeSendSeGC_ClickSetEmBattleSubRole(uiRoleID, uiSubroleID)
    local iSize = clickdata:GetCurPos()
    NetGameCmdSend(SGC_CLICK_SET_EMBBATTLE_SUBROLE, iSize, clickdata)
end

function SendClickQuitStoryCMD()
    local curStoryID = GetCurScriptID()
    local binData, iCmd = EncodeSendSeCGA_ScriptOpr(SEOT_QUIT,curStoryID, 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendClickDelStoryCMD(storyID)
    local binData, iCmd = EncodeSendSeCGA_ScriptOpr(SEOT_FORCEEND,storyID, 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendClickQueryStoryCMD(storyID)
    local binData, iCmd = EncodeSendSeCGA_ScriptOpr(SEOT_QUERY, storyID, 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendClickEnterStoryCMD(storyID, useLucky)
    if (not useLucky or useLucky == 0) then
        useLucky = 0
    else
        useLucky = 1
    end
    local binData, iCmd = EncodeSendSeCGA_ScriptOpr(SEOT_ENTER, storyID, useLucky)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendClickQuitGameCMD()
    local binData, iCmd = EncodeSendSeCGA_ScriptOpr(SEOT_QUITGAME, 0, 1)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 购买剧本难度
function SendClickBuyStoryDiff(storyID)
    local binData, iCmd = EncodeSendSeCGA_ScriptOpr(SEOT_BUYDIFF, storyID, 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendClickChoiceCMD(choiceLangID)
    local data = EncodeSendSeGC_ClickChoice(choiceLangID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CHOICE,iSize,data)
    -- 等待下行
    WaitDisplayMsg()
end

function SendEnterClanCMD(uiClanTypeID)
    local clickEnterClanData = EncodeSendSeGC_Click_Clan_Enter(uiClanTypeID)
    local iSize = clickEnterClanData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CLAN_ENTER, iSize, clickEnterClanData)
end

function SendClanMissionStartCMD(uiClanTypeID)
    local clickData = EncodeSendSeGC_Click_Clan_Mission_Start(uiClanTypeID)
    local iSize = clickData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CLAN_MISSION_START, iSize, clickData)
end

function SendClanMartialLearnCMD(uiClanTypeID, uiMartialID, uiConditionIdx)
    local clickData = EncodeSendSeGC_Click_Clan_Martial_Learn(uiClanTypeID, uiMartialID, uiConditionIdx)
    local iSize = clickData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CLAN_MARTIAL_LEARN, iSize, clickData)
end

-- 请求仓库下发数据
function SendCheckStorageCMD()
    local binData, iCmd =  EncodeSendSeCGA_PlatItemOpr(SPIO_QUERY,0,0,0,{})
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求从仓库带入物品
function SendStorageInScript(iNum,akItems)
    local binData, iCmd =  EncodeSendSeCGA_PlatItemOpr(SPIO_INTO_SCRIPT,iNum,akItems, 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求使用仓库物品
function SendUseStorageItem(iNum,akItems,iChooseNum,akChooseItems)
    local binData, iCmd = EncodeSendSeCGA_PlatItemOpr(SPIO_USEITEM,iNum,akItems,iChooseNum or 0,akChooseItems)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求开具流程-成就点数奖励
function SendAchieveRewardScript(akChooseAchieveRewardID)
    if not akChooseAchieveRewardID then
        return
    end
    local iNum = #(akChooseAchieveRewardID);
    local temp = {};
    for i = 1, #(akChooseAchieveRewardID) do
        temp[i - 1] = akChooseAchieveRewardID[i];
    end
    local binData, iCmd =  EncodeSendSeCGA_ChooseScriptAchieve(iNum,temp)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求门派人数查询
function SendQueryClanCollectionInfo(eQueryType,dwClanTypeID)
    if (not dwClanTypeID) then
        dprint('缺少门派ID')
        return
    end

    if (not eQueryType)  then
        eQueryType = SCCQT_HEAT
    end
    local binData, iCmd =  EncodeSendSeCGA_QueryClanCollectionInfo(eQueryType,dwClanTypeID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendClickNpcInteractCMD(choiceLangID, roleTypeID, mapID, mazeTypeID, mazeAreaIndex, mazeCardBaseID, mazeRow, mazeColumn)
    local data = EncodeSendSeGC_ClickNpcInteract(choiceLangID, roleTypeID, mapID, 0, mazeTypeID, mazeAreaIndex, mazeCardBaseID, mazeRow, mazeColumn)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_NPC_INTERACT, iSize, data)
end

function SendClickTryInteractWithNpc(roleID, mapBaseID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn)
    -- 纠正RoleID
    roleID = RoleDataManager:GetInstance():CorrectRoleID(roleID)
    local data = EncodeSendSeGC_ClickTryInteractWithNpc(mapBaseID, roleID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_TRY_INTERACT_WITH_NPC, iSize, data)
end

function SendClickCreateMainRole(createMainRoleInfo)
    createMainRoleInfo = createMainRoleInfo or globalDataPool:getData("CreateMainRoleInfo") or {}
    local uiID = createMainRoleInfo['uiTypeID'] or 0
    local strName = createMainRoleInfo['strName'] or ""
    local roleModelID = createMainRoleInfo['roleModelID'] or 0
    local data = EncodeSendSeGC_ClickCreateRole(uiID, strName, roleModelID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CREATE_ROLE, iSize, data)
end

function SendClickSetNickName(npcID, name)
    local data = EncodeSendSeGC_SetNickName(npcID,name)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_SAVE_NICKNAME, iSize, data)    
end

function SendClickCreateBaby(uiBabyStateID, strName)
    local data = EncodeSendSeGC_ClickCreateBaby(uiBabyStateID, strName)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CREATE_BABY, iSize, data)
end

function SendClickDiffChoose(curDiff)
    local binData, iCmd =  EncodeSendSeCGA_ChooseScriptDiff(curDiff)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- function SendClickMazeGridCMD(mazeID, areaIndex, row, column)
--     row = MazeDataManager:GetInstance():FormatRow(mazeID, areaIndex, row)
--     local data = EncodeSendSeGC_ClickMazeGrid(mazeID, areaIndex, row, column)
--     local iSize = data:GetCurPos()
--     NetGameCmdSend(SGC_CLICK_MAZE_GRID, iSize, data)
-- end

-- function SendClickMazeUnlockGridCMD(mazeID, areaIndex, row, column)
--     row = MazeDataManager:GetInstance():FormatRow(mazeID, areaIndex, row)
--     local data = EncodeSendSeGC_ClickMazeUnlockGrid(mazeID, areaIndex, row, column)
--     local iSize = data:GetCurPos()
--     NetGameCmdSend(SGC_CLICK_MAZE_UNLOCK_GRID, iSize, data)
-- end

-- function SendClickMazeGoAwayCMD()
--     local data = EncodeSendSeGC_ClickMazeGoAway()
--     local iSize = data:GetCurPos()
--     NetGameCmdSend(SGC_CLICK_MAZE_GO_AWAY, iSize, data)
-- end

-- 物品制造
function SendClickItemForgeCMD(uiMakerID, iForgeNpcID ,iMakeCount, mapID, mazeBaseID, roleBaseID)
    -- local data = EncodeSendSeGC_Click_Item_Forge(uiMakerID)
    -- local iSize = data:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ITEM_FORGE, iSize, data)
    iForgeNpcID = iForgeNpcID or 1
    SendClickItemCMD(CIT_MAKE, iForgeNpcID, 0, iMakeCount or 1, 0, nil, uiMakerID, 0, 0, 0, 0, {}, mapID, mazeBaseID, roleBaseID)
end

-- 物品重铸
function SendClickItemReforgeCMD(uiItemID,uiDynamicAttrID,isPerfect)
    SendClickItemCMD(CIT_REFORGE, 0, uiItemID, 0, 0, {}, 0,uiDynamicAttrID,isPerfect,0,0,{})

    -- local data = EncodeSendSeGC_Click_Item_ReForge(uiItemID,uiDynamicAttrID,isPerfect)
    -- local iSize = data:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ITEM_REFORGE, iSize, data)
end

-- 物品保存重铸绿字条目
function SendClickItemReforgeSaveCMD(uiItemID,uiDynamicAttrID,uiGiveUpBlueAttrID,bIgnoreGreenAttrOpt)
    bIgnoreGreenAttrOpt = (bIgnoreGreenAttrOpt == true) and 1 or 0
    SendClickItemCMD(CIT_REFORGESAVE, 0, uiItemID, 0, 0, {}, 0,uiDynamicAttrID,bIgnoreGreenAttrOpt,uiGiveUpBlueAttrID,0,nil)
    -- local data = EncodeSendSeGC_Click_Item_ReForge_Save(uiItemID,uiDynamicAttrID,uiGiveUpBlueAttrID)
    -- local iSize = data:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ITEM_REFORGE_SAVE, iSize, data)
end

-- 物品修复裂痕
function SendClickItemRepairCrackCMD(uiItemID)
    SendClickItemCMD(CIT_REPAIR, 0, uiItemID, 0, 0, {}, 0,0,nil,0,0,nil)
    -- local data = EncodeSendSeGC_Click_Item_RepairCrack(uiItemID)
    -- local iSize = data:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ITEM_REPAIRCRACK, iSize, data)
end

-- 物品熔炼
function SendClickItemSmeltCMD(iItemNum,auiItem)
    SendClickItemCMD(CIT_SMELT, 0, 0, 0, 0, {}, 0,0,nil,0,iItemNum,auiItem)
    -- local data = EncodeSendSeGC_Click_Item_Smelt(iItemNum,auiItem)
    -- local iSize = data:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ITEM_SMELT, iSize, data)
end 

-- 物品强化
function SendClickItemUpGrade(uiItemID)
    SendClickItemCMD(CIT_UPGRADE, 0, uiItemID, 0, 0, {}, 0,0,nil,0,0,nil)
    -- local data = EncodeSendSeGC_Click_Item_UpGrade(uiItemID)
    -- local iSize = data:GetCurPos()
    -- NetGameCmdSend(SGC_CLICK_ITEM_UPGRADE, iSize, data)
end

-- 获取邮件奖励
function SendMailOpr(eOprType, iNum, adwlMailID)
    local selfName = PlayerSetDataManager:GetInstance():GetPlayerName(true);
    local binData, iCmd = EncodeSendSeCGA_MailOpr(eOprType, selfName, iNum, adwlMailID);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 查询好友信息
function SendFriendInfoOpr(friendIDs)
    local iLen = (friendIDs[0] and 1 or 0) + #friendIDs
    local binData, iCmd = EncodeSendSeCGA_FriendInfoOpr(FROT_QUERY, iLen, friendIDs);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 查询经脉信息
function SendMeridiansOpr(eOprType, iNum, akMeridiansInfo)
    local binData, iCmd = EncodeSendSeCGA_MeridiansOpr(eOprType, iNum, akMeridiansInfo);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendModifyPlayerAppearance(eModifyType,acChangeParam)
    local binData, iCmd = EncodeSendSeCGA_ModifyPlayerAppearance(eModifyType, acChangeParam);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- function SendInteractDateUpdate(roleID)
--     local data = EncodeSendSeGC_Click_Interact_Date_Update(roleID)
--     local iSize = data:GetCurPos()
--     NetGameCmdSend(SGC_CLICK_INTERACT_DATE_UPDATE, iSize, data)
-- end

function SendClickCloseSubmitItemUICMD()
    local data = EncodeSendSeGC_ClickCloseSubmitItemUI(0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CLOSE_SUBMIT_ITEM_UI, iSize, data)
end

-- 购买背包容量
function SendClickBagCapacityBuy()
    local data = EncodeSendSeGC_Click_BagCapacity_Buy(0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BAGCAPACITY_BUY, iSize, data)
end

-- 移动临时背包物品
function SendTempBagMoveBack(iLength,auiItemIDs)
    local data = EncodeSendSeGC_Click_TempBag_MoveBack(iLength,auiItemIDs)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_TEMPBAG_MOVEBACK, iSize, data)
end

-- 请求兑换银锭
function SendExchangeSilver(uiGoldNum)
    local data = EncodeSendSeGC_Click_Exchange_Silver(uiGoldNum)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_EXCHANGE_SILVER, iSize, data)
end

function SendBroadcastNotice(eChannelType, acContent, kTalkInfo)
    local binData, iCmd = EncodeSendSeCGA_PublicChat(eChannelType, acContent, kTalkInfo);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendWeekEndGameOver(uiParam)
    local submitData = EncodeSendSeGC_ClickGameOver(uiParam);
    local iSize = submitData:GetCurPos();
    NetGameCmdSend(SGC_CLICK_WEEKROUND_GAME_OVER, iSize, submitData);
end

function SendScriptArenaBattleStart(uiParam)
    local submitData = EncodeSendSeGC_ClickScriptArenaBattleStart(uiParam);
    local iSize = submitData:GetCurPos();
    NetGameCmdSend(SGC_CLICK_SCRIPT_ARENA_BATTLE_START, iSize, submitData);
end

function SendCloseScriptArena(uiParam)
    local submitData = EncodeSendSeGC_ClickCloseScriptArena(uiParam);
    local iSize = submitData:GetCurPos();
    NetGameCmdSend(SGC_CLICK_CLOSE_SCRIPT_ARENA, iSize, submitData);
end

function SendLimitShopAction(uiType,uiIfSuc,uiBeginTime,uistate)
    --
    local submitData = EncodeSendSeGC_Click_LimitShop_Action(uiType,uiIfSuc,uiBeginTime,uistate);
    local iSize = submitData:GetCurPos();
    NetGameCmdSend(SGC_CLICK_LIMITSHOP_ACTION, iSize, submitData);
end

function SendMartialInComleteText(dwMartialID)
    local binData, iCmd = EncodeSendSeCGA_MartialInCompleteTextOpr(0, dwMartialID);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendNewBirdGuideState(dwCurState,bSet)
    local binData, iCmd = EncodeSendSeCGA_SyncNewBirdGuideState(dwCurState,bSet);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendUpdateCollectionPoint()
    local binData, iCmd = EncodeSendSeCGA_RequestCollectionPoint();
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 发送检测屏蔽字消息
function SendCheckInvalidName(name)
    local binData, iCmd = EncodeSendSeCGA_WordFilter(STWFT_SCRIPT_RENAME,0,name)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendCheckRedPacketWord(typeID,packetWord)
    local binData, iCmd = EncodeSendSeCGA_WordFilter(STWFT_REDPACKET_WORD,typeID,packetWord)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 
function SendStorageRecycle(iNum, akItems)
    local binData, iCmd =  EncodeSendSeCGA_PlatItemOpr(SPIO_RECYCLE, iNum, akItems,0,{});
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 发送bug报告
function SendBugReport(acErrorInfo,acContent)
    if not (acContent and (acContent ~= "")) then
        return
    end
    local binData, iCmd =  EncodeSendSeCGA_UserSuggestion(acErrorInfo,acContent)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 领取成就奖励
function SendGetScriptAchieveReward(iNum, auiRewardID)
    if not (iNum and auiRewardID) then
        return
    end
    local binData, iCmd =  EncodeSendSeCGA_GetScriptAchieveReward(iNum,auiRewardID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendConsultClose(uiRoleID)
    local data = EncodeSendSeGC_ClickGameOver(uiRoleID);
    local iSize = data:GetCurPos();
    NetGameCmdSend(SGC_CLICK_CONSULT_CLOSE, iSize, data);
end


function SendGetPlatPlayerSimpleInfos(eOptType,dwPageID,dwCount)
    if not (eOptType and dwPageID and dwCount) then
        return
    end
    local binData, iCmd = EncodeSendSeCGA_PlatPlayerSimpleInfos(eOptType,dwPageID,dwCount)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendGetPlatPlayerDetailInfo(defPlyID, eReportScene, strContent)
    if not defPlyID then
        return
    end
    if eReportScene and (eReportScene > 0) then
        PlayerSetDataManager:GetInstance():SetCurReportScene(eReportScene, strContent)
    else
        dwarning("[SendGetPlatPlayerDetailInfo]: you havn't given the eReportScene!")
    end
    -- 测试代码, 请求自己的id
    -- defPlyID = PlayerSetDataManager:GetInstance():GetPlayerID()
    local binData, iCmd = EncodeSendSeCGA_PlatPlayerDetailInfo(defPlyID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求百宝书数据
function SendQueryTreasureBookInfo(eQueryType,dwParam1,dwParam2,acOpenID,acVOpenID)
    if not eQueryType then
        return
    end
    if not dwParam1 then
        dwParam1 = 0
    end
    if not dwParam2 then
        dwParam2 = 0
    end
    if not acOpenID then
        acOpenID = ""
    end
    if not acVOpenID then
        acVOpenID = ""
    end
    local binData, iCmd = EncodeSendSeCGA_QueryTreasureBookInfo(eQueryType,dwParam1,dwParam2,acOpenID,acVOpenID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求信用分数据
function SendQueryCriditInfo(dwParam1,dwParam2)
    local binData, iCmd = EncodeSendSeCGA_QueryCriditInfo(dwParam1,dwParam2)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 角色确认易容
function SendClickRoleDisguise(uiRoleID, uiDisguiseItemTypeID, bUseItem)
    if not uiRoleID or uiRoleID == 0 then
        return 
    end
    if bUseItem and (not uiDisguiseItemTypeID or uiDisguiseItemTypeID == 0) then
        return 
    end
    local data = EncodeSendSeGC_ClickRoleDisguise(uiRoleID, uiDisguiseItemTypeID, bUseItem)
    local iSize = data:GetCurPos();
    NetGameCmdSend(SGC_CLICK_ROLE_DISGUISE, iSize, data);
end

-- 新增门派委托任务
function SendClickAddClanDelegationTask(uiClanBaseID)
    local data = EncodeSendSeGC_Click_Add_Clan_Delegation_Task(uiClanBaseID)
    local iSize = data:GetCurPos();
    NetGameCmdSend(SGC_CLICK_ADD_CLAN_DELEGATION_TASK, iSize, data);
end

-- 新增门派征服任务 
function SendClickAddClanEliminationTask(uiClanBaseID)
    local data = EncodeSendSeGC_CLICK_START_CLAN_ELIMINATE(uiClanBaseID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_START_CLAN_ELIMINATE, iSize, data)
end
-- 新增门派委托任务
function SendClickAddCityDelegationTask(uiCityBaseID)
    local data = EncodeSendSeGC_Click_Add_City_Delegation_Task(uiCityBaseID)
    local iSize = data:GetCurPos();
    NetGameCmdSend(SGC_CLICK_ADD_CITY_DELEGATION_TASK, iSize, data);
end

-- 抓周选项
function SendZhuaZhouSelection(uiAnswerID)
    local data = EncodeSendSeGC_Click_Select_Zhuazhou(uiAnswerID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_SELECT_ZHUAZHOU, iSize, data)
end

-- 进入大决战据点
function SendClickFinalBattleEnterCity(uiFinalBattleCityID, bIsInCity)
    if not uiFinalBattleCityID then
        uiFinalBattleCityID = 0 
    end

    if bIsInCity then
        bIsInCity = 1
    end
    
    local data = EncodeSendSeGC_ClickFinalBattleEnterCity(uiFinalBattleCityID, bIsInCity)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_FINALBATTLE_ENTERCITY, iSize, data)
end

-- 退出大决战据点
function SendClickFinalBattleQuitCity()
    local data = EncodeSendSeGC_ClickFinalBattleQuitCity(0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_FINALBATTLE_QUITCITY, iSize, data)
end
function SendClickChooseNPCMaster(uiRoleID)
    if uiRoleID == 0 then 
        return 
    end
    local data = EncodeSendSeGC_ClickChooseRoleID(uiRoleID or 0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CHOOSE_NPCMASTER, iSize, data)
end
function SendClickChooseRoleChallengeSelectRole(uiRoleID)
    if uiRoleID == 0 then 
        return 
    end
    local data = EncodeSendSeGC_Click_RoleChallengeSelectRole(uiRoleID or 0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLECHALLENGE_SELECTROLE, iSize, data)
end

function SendClickMartialStrong(uiRoleID,uiMartialID,uiLevel)
    if uiRoleID ==nil or uiMartialID == nil or uiLevel == nil then 
        SystemUICall:GetInstance():Toast('研读上传失败，请重新再试')
        return 
    end
    local data = EncodeSendSeGC_Click_MartialStrong(uiRoleID,uiMartialID,uiLevel)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_MARTIAL_STRONG, iSize, data)
end

function SendClickMakeMartialSecret(uiMartialID)
    if uiMartialID == nil then 
        SystemUICall:GetInstance():Toast('武学信息上传失败，请重新再试')
        return 
    end
    local data = EncodeSendSeGC_Click_MakeMartialSecret(uiMartialID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_MAKEMARTIALSECRET, iSize, data)
end

function SendClickGetBabyClose(uiRoleID)
    local data = EncodeSendSeGC_ClickGetBabyClose(uiRoleID or 0)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_GETBABY_CLOSE, iSize, data)
end
-- 打开大决战据点宝箱
function SendClickFinalBattleOpenBox(uiFinalBattleCityID)
    if not uiFinalBattleCityID then
        return
    end

    local data = EncodeSendSeGC_ClickFinalBattleOpenBox(uiFinalBattleCityID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_FINALBATTLE_OPENBOX, iSize, data)
end

-- 千层塔混战布阵结束
function SendHighTowerEmbattleOver(bSubmit)
    if bSubmit then
        bSubmit = 1
    else
        bSubmit = 0
    end

    local data = EncodeSendSeGC_ClickHighTowerEmbattleOver(bSubmit)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_HIGHTOWER_EMBATTLE_OVER, iSize, data)
end

-- 角色直接习得某本秘籍上的武学
function SendRoleLearnSecretBookMartial(uiRoleID, uiItemID)
    if (not uiRoleID) or (uiRoleID == 0)
    or (not uiItemID) or (uiItemID == 0) then
        return
    end
    local data = EncodeSendSeGC_RoleLearnSecretBookMartial(uiRoleID,uiItemID)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_ROLE_LEARN_SECRET_BOOK_MARTIAL, iSize, data)
end

-- 请求资源掉落活动信息
function SendRequestQueryResDropActivityInfo(eQueryType)
    local data = EncodeSendSeGC_ClickQueryResDropActivityInfo(eQueryType)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_QUERY_RES_DROP_ACTIVITY_INFO, iSize, data)
end

-- 请求兑换收集任务奖励
function SendRequestExchangeCollectActivity(uiResDropActivityID, uiCollectActivityIndex)
    local data = EncodeSendSeGC_ClickExchangeCollectActivity(uiResDropActivityID, uiCollectActivityIndex)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_EXCHANGE_COLLECT_ACTIVITY, iSize, data)
end

-- 请求弹珠数据
function SendQueryHoodleLotteryInfo(eQueryType,ePoolType,bSpecialHoodle,dwCurPoolID)
    if not (eQueryType and ePoolType) then
        return
    end
    local iSpecialHoodle = (bSpecialHoodle == true) and 1 or 0
    local binData, iCmd = EncodeSendSeCGA_QueryHoodleLotteryInfo(eQueryType,ePoolType,iSpecialHoodle,dwCurPoolID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求侠客行全服玩法数据
function SendQueryHoodlePublicInfo()
    local binData, iCmd = EncodeSendSeCGA_QueryHoodlePublicInfo()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求侠客行全服玩法奖励领取记录
function SendQueryHoodlePublicRecord(iPage)
    local binData, iCmd = EncodeSendSeCGA_QueryHoodlePublicRecord(iPage or 1)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求兑换侠客行全服玩法积分奖励
function SendBuyHoodleShopItem(iSelectIndex,iSelectID)
    if not (iSelectIndex and iSelectID) then
        return
    end
    local binData, iCmd = EncodeSendSeCGA_BuyHoodleShopItem(iSelectIndex,iSelectID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 开启完整版
function SendUnlockChallengeOrder(eType)
    if not eType then
        return
    end
    local binData, iCmd = EncodeSendSeCGA_UnlockChallengeOrder(eType)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 设置引导完成标记
function SendSetNoviceGuideFlag(eFlag)
    if not eFlag then
        return
    end
    local binData, iCmd = EncodeSendSeCGA_UpdateNoviceGuideFlag(eFlag)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- uiReqType 0：role ;1 : pet ; 2 : bond 
function SendRequestRolePetCardOperate(uiReqType,uiOptType,uiReqPara1,uiReqPara2)
    local binData, iCmd = EncodeSendSeCGA_RequestRolePetCardOperate(uiReqType or 0,uiOptType or 0,uiReqPara1 or 0,uiReqPara2 or 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendSelectSubmitItem(uiTaskID, uiTaskEdgeID, iNum, auItems)
    local submitData = EncodeSendSeGC_ClickSelectSubmitItem(uiTaskID, uiTaskEdgeID, iNum, auItems)
    local iSize = submitData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_SELECT_SUBMIT_ITEM, iSize, submitData)
end

--========================================================================
function SendQueryPlatTeamInfo(eQueryType, dwScriptID)
    local binData, iCmd = EncodeSendSeCGA_QueryPlatTeamInfo(eQueryType, dwScriptID);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendCopyTeamInfo(dwScriptID)
    local binData, iCmd = EncodeSendSeCGA_CopyTeamInfo(dwScriptID);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendPlatEmbattle(bSingle, iNum, akRoleEmbattle)

    local sendData = {};
    local cloneData = clone(table_c2lua(akRoleEmbattle));
    if cloneData then
        if #(cloneData) >= 1 then
            for i = 1, iNum do --c++里从0开始 lua用1开始
                sendData[i-1] = cloneData[i];
                sendData[i-1].iGridX = sendData[i-1].iGridX - 1;
                sendData[i-1].iGridY = sendData[i-1].iGridY - 1;
            end
        end
        local binData, iCmd = EncodeSendSeCGA_PlatEmbattle(bSingle, iNum, sendData);
        SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
    end  
end

function SendSetMainRole(uiRoleID)
    local binData, iCmd = EncodeSendSeCGA_SetMainRole(uiRoleID);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendRequestArenaMatchOperateList(cmdList)
    if type(cmdList) ~= 'table' or cmdList[0] == nil then 
        return
    end
    local binData, iCmd = EncodeSendSeCGA_RequestArenaMatchOperate((#cmdList) + 1, cmdList)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendRequestArenaMatchOperate(eRequestType,uiMatchType,uiMatchID,uiRoundID,uiBattleID,kPlayerID,iUploadFlag)
    local cmdList = {
        [0] = {
            eRequestType = eRequestType,
            uiMatchType = uiMatchType,
            uiMatchID = uiMatchID,
            uiRoundID = uiRoundID,
            uiBattleID = uiBattleID,
            kPlayerID = kPlayerID,
            iUploadFlag = iUploadFlag
        }
    }
    SendRequestArenaMatchOperateList(cmdList)
end

function SendRequestArenaMatchBet(uiMatchType,uiMatchID,uiBattleID,uiRoundID,defBetPlyID,uiMoney,acPlayerName)
    local binData, iCmd = EncodeSendSeCGA_RequestArenaMatchBet(uiMatchType,uiMatchID,uiBattleID,uiRoundID,defBetPlyID,uiMoney,acPlayerName);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end
--========================================================================

--========================================================================
function SendPlatShopMallReward(eType)
    local binData, iCmd = EncodeSendSeCGA_PlatShopMallReward(eType);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function SendPlatShopMallQueryItem(uiType)
    if uiType and uiType > RackItemType.RIT_Null then  
        local binData, iCmd = EncodeSendSeCGA_PlatShopMallQueryItem(uiType);
        SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
    end 
end

function SendPlatShopMallBuyItem(uiShopID,uiPileCount)
    local binData, iCmd = EncodeSendSeCGA_PlatShopMallBuyItem(uiShopID,uiPileCount);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end
--========================================================================

--========================================================================
function SendObservePlatRole(defTarPlyID)
    local binData, iCmd = EncodeSendSeCGA_ObservePlatRole(defTarPlyID);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end
--========================================================================

--========================================================================
function SendChallengePlatRole(defTarPlyID,otherFlag)
    ArenaDataManager:GetInstance():ClearReplay(0)
    local binData, iCmd = EncodeSendSeCGA_ChallengePlatRole(defTarPlyID,otherFlag or 0);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end
--========================================================================

-- 向服务器上报机型信息
-- function SendSystemInfo()
--     local binData, iCmd = EncodeSendSeCGA_TLogUpdate(uiShopID,uiPileCount);
--     SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
-- end

--设置玩家QQ或微信头像
function SendSetCharPictureUrl(charPicUrl)
    local binData, iCmd = EncodeSendSeCGA_SetCharPictureUrl(charPicUrl)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendExchangeGoldToSilver(uiGoldNum)
    local binData, iCmd = EncodeSendSeCGA_ExChangeGoldToSilver(uiGoldNum)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

--查询玩家金锭
function SendQueryPlayerGold(bshow, bCharge)
    --设置客户端是否显示tip
    if not bCharge then
        bCharge = 0
    end

    PlayerSetDataManager:GetInstance():setIsShowGoldTips(bshow)
    local binData, iCmd = EncodeSendSeCGA_QueryPlayerGold(bCharge)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

--请求添加好友
function SendAddFriendReq(friendID,acOpenID,acVOpenID)
    local binData, iCmd = EncodeSendSeCGA_addFriendReq(friendID,acOpenID,acVOpenID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

--发送红包
function SendRedPacket(redType,redTypeID,redPacketWord)
    SendCheckRedPacketWord(redTypeID,redPacketWord)
end

--查询红包
function QueryRedPacket()
    local getTimes = PlayerSetDataManager:GetInstance():GetRedPacketGetTimes();
    if getTimes >=  SSD_MAX_GETREDPACKETTIMES then
        return;
    end
    NetCommonRedPacket:GetLatestRedPacket();
end

--领取红包
function GetRedPacket(redPacketUID,token)
    local selfName = PlayerSetDataManager:GetInstance():GetPlayerName(true);
    local binData, iCmd = EncodeSendSeCGA_GetRedPacket(selfName,redPacketUID,token)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function SendQueryForBidInfo()
    local binData, iCmd = EncodeSendSeCGA_QueryForBidInfo()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

--仓库带入扩容格子
function SendPlatItemToScriptDilatation()
    local binData, iCmd = EncodeSendSeCGA_PlatItemToScriptDilatation()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function RequestTencentCreditScore()
    local binData, iCmd = EncodeSendSeCGA_RequestTencentCreditScore()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end
local PrivateChatSceneLimit_time
function RequestPrivateChatSceneLimit()
    local a = os.time() 
    if not PrivateChatSceneLimit_time or  PrivateChatSceneLimit_time + 300 < a then 
        local binData, iCmd = EncodeSendSeCGA_RequestPrivateChatSceneLimit()
        SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
        PrivateChatSceneLimit_time = a
    end
end

-- 3天签到活动指令
function SendDay3SignInCmd(eOpt, uiBaseID)
    local binData, iCmd = EncodeSendSeCGA_Day3SingIn(eOpt, uiBaseID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 新门派签到活动
function SendActivitySignCmd()
    local binData, iCmd = EncodeSendSeCGA_OperatorSignInFlag()
    return SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end
local LimitShopTime
function SendLimitShopOpr(eOprType,iType,iParams0,iParams1,iParams2,iParams3, acJson)
    
    -- if MSDKHelper:IsPlayerTestNet() then 
    --     return 
    -- end 
    local curStoryID = GetCurScriptID()
    if curStoryID and  (curStoryID == 2 or curStoryID == 6 or curStoryID == 7) then
        if eOprType == nil then 
            local curtime = os.time()
            if LimitShopTime and curtime < LimitShopTime + 60 then 
                return 
            end 
            LimitShopTime = curtime
            eOprType = EN_LIMIT_SHOP_GET 
            SendLimitShopOpr(EN_LIMIT_SHOP_GETFIRSTSHARE)
        end
        if eOprType == EN_LIMIT_SHOP_REFLASH then 
            if CityDataManager:GetInstance():GetCityEventExsist(18,21) then 
                return 
            end
        elseif eOprType == EN_LIMIT_SHOP_BUY then 
            LimitShopManager:GetInstance():SetCatchDateBought(iType or 0)
        end 
        local binData, iCmd = EncodeSendSeCGA_LimitShopOpr(eOprType ,iType or 0,iParams0 or 0,iParams1 or 0,iParams2 or 0, iParams3 or 0, acJson or "")
        SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
         
    end 
end

local dkJson = require("Base/Json/dkjson")
-- 向服务器上报门派引导阶段
function SendClanLog(iType, iClanID)
    if  iType == nil or iClanID == nil then
        return
    end

    -- local guideTab = {
    --     ['iType'] = iType,          -- 0 查看 1 查看 2加入 3 关闭
    --     ['iClanID'] = iClanID,      -- 门派ID
    -- }
    -- local sendStr = dkJson.encode(guideTab);
    local sendStr = string.format('%d|%d', iType, iClanID);
    local binData, iCmd = EncodeSendSeCGA_TLogUpdate(STLNT_ScriptClanFlow,sendStr);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 向服务器上报新手引导阶段
function SendGuideLog(iGuideID, iNodeIndex)
    if  iGuideID == nil or iNodeIndex == nil then
        return
    end
    local sendStr = string.format('%d|%d', iGuideID, iNodeIndex);
    local binData, iCmd = EncodeSendSeCGA_TLogUpdate(STLNT_GuideFlow,sendStr);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end
function SendOpenLimitShopUI()
    local sendstr = ''
    local bSHU = false
    local LimitShopData = LimitShopManager:GetInstance():GetShopShowData()
    if LimitShopData then 
        for i,kLimitShopData in pairs(LimitShopData) do 
            if bSHU then 
                sendstr = sendstr .. '|'
            end 
            sendstr = sendstr .. (kLimitShopData.giftType or 0) ..'@' .. (kLimitShopData.grade or 0)
            bSHU = true 
        end 
    end
    local binData, iCmd = EncodeSendSeCGA_TLogUpdate(STLNT_LimitShopFlow,sendstr);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end
-- 向服务器上报分享
function SendShareInfo(baseid, shareType)
    if not baseid or not shareType then
        return
    end
    local sendStr = string.format('%d|%d', baseid, shareType);
    local binData, iCmd = EncodeSendSeCGA_TLogUpdate(STLNT_SceneShare,sendStr);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 向服务器上报删除好友
function SendDelFriendInfo(type, playerID)
    if not type or not playerID then
        return
    end
    local sendStr = string.format('%d|%d', tonumber(type), tonumber(playerID));
    local binData, iCmd = EncodeSendSeCGA_TLogUpdate(STLNT_PlayerActPlayerFlow,sendStr);
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

-- 发送防沉迷心跳
function SendPrajnaHeartBeat(openID)
    local binData, iCmd = EncodeSendSeCGA_CheckTencentAntiAddiction(openID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求在同一剧本中的玩家
function SendRequestPlayerInSameScript()
    local binData, iCmd = EncodeSendSeCGA_RequestPlayerInSameScript()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 举报玩家
function SendReportCheatPlayer(defReportPlayerID,acReportType,acReportDesc,acReportContent,dwReportScene)
    local kClientReportInfo = {
        ["defReportPlayerID"] = defReportPlayerID,
        ["acReportType"] = acReportType,
        ["acReportDesc"] = acReportDesc,  -- 八个字
        ["acReportContent"] = acReportContent,
        ["dwReportScene"] = dwReportScene,
        ["dwReportEntrance"] = 1,
        ["acPicUrl"] = "",
    }
    local binData, iCmd = EncodeSendSeCGA_ReportCheatPlayer(kClientReportInfo)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求服务器同步时间
function SendQuestServerTime()
    g_lastHeartBeatCheckTime = os.time()
    local binData, iCmd = EncodeSendSeCGA_HeartBeat()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 请求JWT
function SendQueryPublicJWT()
    local binData, iCmd = EncodeSendSeCGA_QueryPublicJWT()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 掌门对决
function SendZmOperate(enRequest,nRoomId,iParams0,iParams1,iParams2,iParams3,defTagetId)
    local binData, iCmd = EncodeSendSeCGA_RequestZmOperate(enRequest,nRoomId,iParams0,iParams1,iParams2,iParams3,defTagetId)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end
function SendZmBattleCard (nRoomId,iNum,akZmCardBattle)
    local binData, iCmd = EncodeSendSeCGA_RequestZmBattleCard(nRoomId,iNum,akZmCardBattle)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 捏脸 平台和剧本内是两个协议
function SendCreateFaceOperate(iStoryId,eOprType,uiParam,kRoleFaceData)
    if iStoryId == 0 then
        local binData, iCmd = EncodeSendSeCGA_RoleFaceOpr(eOprType,uiParam,kRoleFaceData)
        SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
    else
        local sendData = EncodeSendSeGC_Click_RoleFaceOperate(eOprType,uiParam,kRoleFaceData)
        local iSize = sendData:GetCurPos()
        NetGameCmdSend(SGC_CLICK_ROLE_FACE_OPERATE,iSize,sendData)
    end
end

-- 解锁剧本
function SendUnlockStory(storyID)
    local binData, iCmd = EncodeSendSeCGA_UnlockStory(storyID)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 领取每日奖励
function SendRequestGetDailyReward(storyID)
    local binData, iCmd = EncodeSendSeCGA_RequestGetDailyReward()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 活动操作
local actiontimes
function SendActivityOper(type, activityid, param1, param2, param3, activityIDList)
    if DEBUG_MODE then
        if not actiontimes then 
            actiontimes = {}
        end
        local ostiem = os.time()
        if actiontimes.ostiem ~= ostiem then 
            actiontimes.list = {}
        end
        local  str  = string.format('type :%s, activityid :%s, param1 :%s, param2 :%s, param3 :%s, activityIDList :%s',type or 0, activityid or 0, param1 or 0, param2 or 0, param3 or 0, activityIDList or 0)
        table.insert(actiontimes.list,str)
        if #actiontimes.list > 10 then 
            SystemTipManager:GetInstance():AddPopupTip('WARNING:SendActivityOper too frequently:' .. table.concat(actiontimes.list,'；；').. trace)
            dwarning('WARNING:SendActivityOper too frequently:' .. table.concat(actiontimes.list,'；；') )
        end 
    end

    activityIDList = activityIDList or {}
    local binData, iCmd = EncodeSendSeCGA_ActivityEvent(type, activityid or 0, param1 or 0, param2 or 0, param3 or 0, #activityIDList, activityIDList)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function OnClickTestSendFriendShare()
    SendActivityOper(SAOT_EVENT, 0, SATET_SHAREFRIEND, 6)
    SendActivityOper(SAOT_RECEIVE, 1003, 6)
end

-- 拾取冒险掉落
function SendClickPickUpAdvLoot(dwAdvLootCount,akAdvLootDatas)
    local sendData = EncodeSendSeGC_ClickPickUpAdvLoot(dwAdvLootCount,akAdvLootDatas)
    local iSize = sendData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_PICKUP_ADVLOOT, iSize, sendData)
end

-- 请求秘宝大会状态协议
local iTreaSureAskTime
function SendRequestTreasureExchangeState(bForce)
    local iCurTime = os.time()
    if bForce or not iTreaSureAskTime or iTreaSureAskTime + 200 < iCurTime then 
        iTreaSureAskTime = iCurTime
        local TB_ActivityBase = TableDataManager:GetInstance():GetTable("ActivityBase") 
        if TB_ActivityBase then 
            for i,activityBase in pairs(TB_ActivityBase) do 
                if ActivityType.ACCT_TreasureExchange == activityBase.Type then 
                    if ActivityHelper.IsInActivityTime(activityBase) then 
                        SendActivityOper(SAOT_REQUEST, activityBase.BaseID, 0, 0)
                        break
                    end
                end 
            end 
        end
    end 
end 
-- 刷新秘宝大会列表协议
function SendRefreshTreasureExchangeList(iActivityID,iGroup,iCoinType)
    SendActivityOper(SAOT_EVENT, iActivityID, SATET_REFRESH_EXCHANGE, iGroup)
end

-- 兑换指定组
function SendRefreshTreasureExchangeList(iActivityID,iGroup,iCoinType)
    SendActivityOper(SAOT_EVENT, iActivityID, SATET_TREASURE_EXCHANGE, iGroup)
end

-- 请求剧本周限制信息
function SendQueryStoryWeekLimit(uiStoryID)
    local binData, iCmd = EncodeSendSeCGA_QueryStoryWeekLimit(uiStoryID or 0)
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 中止进入剧本逻辑
function SendStopEnterStory()
    local binData, iCmd = EncodeSendSeCGA_StopEnterStory()
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

-- 通常布阵完毕
function SendCommonEmbattleResult(bSubmit)
    local sendData = EncodeSendSeGC_Click_CommonEmbattleResult(bSubmit and 1 or 0)
    local iSize = sendData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_COMMON_EMBATTLE_RESULT, iSize, sendData)
end

function SendClickCustomAdvLoot(customAdvLootCount, customAdvLoots)
    if customAdvLootCount == 0 then 
        return
    end
    local auiTaskEventIDs = {}
    for index, customAdvLoot in ipairs(customAdvLoots) do 
        auiTaskEventIDs[index - 1] = customAdvLoot.uiMID
    end
    local sendData = EncodeSendSeGC_ClickPickCustomAdvLoot(customAdvLootCount, auiTaskEventIDs)
    local iSize = sendData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_PICK_CUSTOM_ADV_LOOT, iSize, sendData)
end

function SendEnterMaze(mazeID)
    local sendData = EncodeSendSeGC_Click_MazeEntry(mazeID or 0)
    local iSize = sendData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_MAZE_ENTRY, iSize, sendData)    
end

function KillClanBranch(clanID)
    local sendData = EncodeSendSeGC_KillClanBranch(clanID or 0)
    local iSize = sendData:GetCurPos()
    NetGameCmdSend(SGC_KILL_CLANBRANCH, iSize, sendData)        
end