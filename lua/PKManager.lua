local ZmWatchRole = require("UI/Role/RoleClass/ZmWatchRole")

PKManager = class("PKManager")

--TODO: 没有很好区分公共和私有函数，可以后期改改

-- 网络事件
PKManager.NET_EVENT = {
    UpdateRoom = "PK_NET_UpdateRoom",
    UpdateRoomExt = "PK_NET_UpdateRoomExt",
    UpdatePlayer = "PK_NET_UpdatePlayer",
    UpdatePlayerExt = "PK_NET_UpdatePlayerExt",
    UpdateRecord = "PK_NET_UpdateRecord",
    UpdateBattle = "PK_NET_UpdateBattle",
    UpdateShop = "PK_NET_UpdateShop",
    Response = "PK_NET_Response",
    UpdateOtherPlayer = "PK_NET_UpdateOtherPlayer",
    Notice = "PK_NET_Notice"
}

-- UI事件
PKManager.UI_EVENT = {
    -- 准备
    Ready = "PK_UI_Ready",
    -- 匹配
    MatchStart = "PK_UI_MatchStart",
    MatchEnd = "PK_UI_MatchEnd",
    MatchCancel = "PK_UI_MatchCancel",
    Match = "PK_UI_Match",
    -- 游戏阶段
    Start = "PK_UI_Start",
    End = "PK_UI_End",
    RoundStart = "PK_UI_RoundStart",
    RoundEnd = "PK_UI_RoundEnd",
    -- 选择掌门
    SelectClanStart = "PK_UI_SelectClanStart",
    SelectClanRefresh = "PK_UI_SelectClanRefresh",
    -- 选择角色
    SelectRoleStart = "PK_UI_SelectRoleStart",
    SelectRoleRefresh = "PK_UI_SelectRoleRefresh",
    -- 选择神器
    SelectEquipStart = "PK_UI_SelectEquipStart",
    SelectEquipRefresh = "PK_UI_SelectEquipRefresh",
    SelectEnd = "PK_UI_SelectEnd",
    RefreshBattleRole = "PK_UI_RefreshBattleRole",
    RefreshRoleNum = "PK_UI_RefreshRoleNum",
    -- 刷新提前选
    PreSelect = "PK_UI_PreSelect",
    RefreshPreSelect = "PK_UI_RefreshPreSelect"
}

-- 结束时间
PKManager.END_TYPE = {
    Null = 0,
    Die = 1,
    End = 2
}

-- 主角ID
PKManager.MAIN_ROLE_ID = 1

-- 掌门对决管理单例
local mInstance = nil
function PKManager:GetInstance()
    if not mInstance then
        mInstance = PKManager.new()
    end
    return mInstance
end

-- 构造函数
function PKManager:ctor()
    self.RankToName = {}
    for name, rank in pairs(RankType_Revert) do
        self.RankToName[rank] = name
    end

    self:ClearData()
    -- 请求下解锁信息
    CardsUpgradeDataManager:GetInstance():InitCardList()
end

-- 开始
function PKManager:Start()
    if self.mRunning then
        return
    end

    self.mRunning = true
    self.mEnd = PKManager.END_TYPE.Null

    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdateRoom, self.OnUpdateRoom, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdateRoomExt, self.OnUpdateRoomExt, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdatePlayer, self.OnUpdatePlayer, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdatePlayerExt, self.OnUpdatePlayerExt, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdateRecord, self.OnUpdateRecord, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdateBattle, self.OnUpdateBattle, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdateShop, self.OnUpdateShop, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.Response, self.OnResponse, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.UpdateOtherPlayer, self.OnUpdateOtherPlayer, self)
    LuaEventDispatcher:addEventListener(PKManager.NET_EVENT.Notice, self.OnNotice, self)

    LuaEventDispatcher:addEventListener("GAME_RECONNECT", self.OnGameReconnect, self)

    -- 去掌门对决
    OpenWindowImmediately("LoadingUI")
    ChangeScenceImmediately(
        "Town",
        "LoadingUI",
        function()
            -- 打开常驻的窗口
            OpenWindowImmediately("PKUI")
        end
    )

    self:ClearData()
    SendZmOperate(EN_ZM_REQUEST_GetRoom)
    g_hasReconnected = false
end

-- 结束
function PKManager:End(needResetGame)
    if not self.mRunning then
        return
    end

    self:ClearData()
    self.mRunning = false

    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdateRoom, self.OnUpdateRoom, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdateRoomExt, self.UpdateRoomExt, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdatePlayer, self.OnUpdatePlayer, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdatePlayerExt, self.OnUpdatePlayerExt, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdateRecord, self.OnUpdateRecord, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdateBattle, self.OnUpdateBattle, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdateShop, self.OnUpdateShop, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.Response, self.OnResponse, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.UpdateOtherPlayer, self.OnUpdateOtherPlayer, self)
    LuaEventDispatcher:removeEventListener(PKManager.NET_EVENT.Notice, self.OnNotice, self)

    LuaEventDispatcher:removeEventListener("GAME_RECONNECT", self.OnGameReconnect, self)

    -- 回酒馆
    if needResetGame ~= false then
        -- 重置下游戏，为了防止客户端强退导致复盘上局的信息
        ResetGame()

        ChangeScenceImmediately(
            "House",
            "LoadingUI",
            function()
                OpenWindowImmediately("HouseUI")
            end
        )
    end
end

function PKManager:ClearData()
    self.mRoleList = {}
    self.mMatchData = nil
    self.mRoomData = {}
    self.mPlayerData = {}
    self.mShopData = {}
    self.mRebuildFlag = false

    self.mAwardData = nil
    self.mRollData = nil

    -- 临时变量，为了防止异步加载的阵容不同步
    self.mTempRoleList = nil

    self.mEnd = PKManager.END_TYPE.Null
end

function PKManager:Update()
    if self.mRebuildFlag then
        self:RebuildDataPool()
    end
end

-- 判断是否在掌门对决
function PKManager:IsRunning()
    return self.mRunning
end

function PKManager:IsEnd()
    return self.mEnd ~= PKManager.END_TYPE.Null
end

function PKManager:GetEndType()
    return self.mEnd
end

function PKManager:IsEquip(roleID, itemID)
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID) or {}
    return (roleData["akEquipItem"] or {})[REI_THRONE] == itemID
end

function PKManager:HideAI()
    return true
end

function PKManager:HideEquipMartial()
    return true
end

function PKManager:GetRoleList()
    return self.mRoleList
end

function PKManager:GetMatchData()
    return self.mMatchData
end

function PKManager:GetRoomData()
    return self.mRoomData
end

function PKManager:GetPlayerData()
    return self.mPlayerData
end

function PKManager:GetShopData()
    return self.mShopData
end

-- 小阶段结束的检测
function PKManager:CheckRound(showSelect)
    if not showSelect then
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.SelectClanEnd)
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.SelectEquipEnd)
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.SelectRoleEnd)
    end

    -- 如果有对话框，取消对话框
    self:CloseDialog()
end

function PKManager:CloseDialog()
    -- 如果有对话框，取消对话框
    local window = GetUIWindow("DialogChoiceUI")
    if window then
        RemoveWindowImmediately("DialogChoiceUI", true)
        ResetWaitDisplayMsgState()
        DisplayActionEnd()
    end
end

function PKManager:ShowShop()
    -- 没有商城数据，直接不打开商城
    if self.mShopData == nil or self.mShopData["EndTime"] == nil then
        return
    end

    LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.Ready)
    self.mRunning = true

    OpenWindowImmediately("PKShopUI")

    self.mEnd = PKManager.END_TYPE.Null
end

--region 监听网络事件
function PKManager:OnUpdateRoom(data)
    -- 大阶段
    self.mRoomData["RoundID"] = data["dwRoundId"]
    -- 装备等级
    self.mRoomData["EquipLevel"] = data["dwEquipLv"]
    -- 大阶段结束时间戳（单位秒）
    self.mRoomData["EndTime"] = self:GetTrueTime(data["dwTime"])
    -- 下局FightID
    self.mRoomData["FightID"] = data["dwFightId"]
    -- ban掉的卡牌
    self.mRoomData["BanCardList"] = data["akFreezeCardData"]

    LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.RoundStart)
end

function PKManager:OnUpdateRoomExt(data)
    -- 房间ID
    self.mRoomData["ID"] = data["nRoomId"]
    -- 玩家列表
    self.mRoomData["PlayerList"] = data["akPlyData"]

    -- 更新卡池
    local allRoleList = {}
    local idToNum = {}
    self.mRoomData["AllRoleList"] = allRoleList
    self.mRoomData["IDToNum"] = idToNum
    for _, card in pairs(data["akCardData"]) do
        local id = card["dwBaseId"]
        local num = card["dwCardNum"]
        table.insert(allRoleList, id)
        idToNum[id] = num
    end
    -- 卡池排序
    table.sort(
        allRoleList,
        function(baseID1, baseID2)
            local roleID1 = (GetTableData("PKRole", baseID1) or {}).RoleID
            local roleID2 = (GetTableData("PKRole", baseID2) or {}).RoleID
            local roleData1 = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleID1) or {}
            local roleData2 = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleID2) or {}

            return (roleData1.Rank or 0) > (roleData2.Rank or 0)
        end
    )
end

function PKManager:OnUpdatePlayer(data)
    local playerInfo = data["kPlayerInfo"] or {}

    self.mPlayerData["EquipList"] = playerInfo["akEquipData"]
    self.mPlayerData["ClanID"] = playerInfo["dwClan"]
    self.mPlayerData["LimitRoleNum"] = playerInfo["dwBattleCardNum"]

    -- 上阵角色信息
    self.mTempRoleList = playerInfo["akBattleCardData"]

    self.mPlayerData["IDToCard"] = {}
    local idToCard = self.mPlayerData["IDToCard"]
    local cardList = playerInfo["akCardData"]
    for index, card in pairs(cardList) do
        idToCard[card["dwId"]] = card
    end

    local wnd = GetUIWindow("PKUI")
    if wnd and wnd:IsOpen() then
        self.mRebuildFlag = true
    else
        self:RebuildDataPool()
    end
end

function PKManager:OnUpdatePlayerExt(data)
    local playerInfo = data["kPlayerInfo"] or {}

    self.mPlayerData["RoundID"] = playerInfo["dwRound"]
    self.mPlayerData["SelectRoleList"] = playerInfo["akSelectCardData"]
    self.mPlayerData["SelectClanList"] = playerInfo["akSelectClanData"]
    self.mPlayerData["SelectEquipList"] = playerInfo["akSelectEquipData"]
    self.mPlayerData["RefreshTimes"] = playerInfo["dwReflashTimes"]
    self.mPlayerData["SkillUseTimes"] = playerInfo["dwSkillUseTimes"] or 0
    self.mPlayerData["ZmGold"] = playerInfo["dwGold"] or 0

    local round = self.mPlayerData["RoundID"]
    local eventID = round > 0 and playerInfo["dwEventId"] or 0
    self.mPlayerData["EventID"] = eventID

    dprint("[PKManager] => OnUpdatePlayerExt , RoundID: " .. round .. " ,EventID: " .. eventID)

    LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.RefreshPreSelect)

    -- 如果还继续选择，就不要展示Wait界面了
    self:CheckRound(eventID == 1 or eventID == 2 or eventID == 3)

    -- 大阶段结束
    if round == 0 then
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.RoundEnd)
        return
    end

    if eventID == 1 then
        -- 1：选掌门
        local selctClanList = self.mPlayerData["SelectClanList"]
        if selctClanList and selctClanList[0] ~= nil then
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.SelectClanStart, self.mPlayerData)
        else
            SystemUICall:GetInstance():WarningBox("没有提供可选择的掌门")
        end
    elseif eventID == 2 then
        -- 2：选角色
        local selectRoleList = self.mPlayerData["SelectRoleList"]
        if selectRoleList and selectRoleList[0] ~= nil then
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.SelectRoleStart, self.mPlayerData)
        else
            SystemUICall:GetInstance():WarningBox("没有提供可选择的角色")
        end
    elseif eventID == 3 then
        -- 3：选神器
        local selectEquipList = self.mPlayerData["SelectEquipList"]
        if selectEquipList and selectEquipList[0] ~= nil then
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.SelectEquipStart, self.mPlayerData)
        else
            SystemUICall:GetInstance():WarningBox("没有提供可选择的神器")
        end
    elseif eventID == 4 then
        -- 4：PVE
    elseif eventID == 5 then
        -- 5：PVP
    elseif eventID == 6 then
        -- 6：队友+1
        SystemUICall:GetInstance():Toast("上阵队友数+1")
    elseif eventID == 7 then
        -- 7：解锁配置AI
        -- SystemUICall:GetInstance():Toast("解锁武学配置和AI配置")
    else
        SystemUICall:GetInstance():Toast("未知阶段", false)
    end
end

function PKManager:OnUpdateRecord(battle)
    local battleID = (battle or {})["uiBattleID"]
    if battleID then
        self:ShowLoading()

        ArenaDataManager:GetInstance():ReceiveReplayerData(
            battle,
            function()
                self:HideLoading()

                -- PVE显示数据
                local fightID = battle["dwFightID"] or 0
                if fightID > 0 then
                    ArenaDataManager:GetInstance():SetPlayBackData(self:GetPVEReplayData(battle, fightID))
                end

                if battle.winPlayerID ~= 0 and ARENA_PLAYBACK_DATA then
                    ARENA_PLAYBACK_DATA.defPlyWinner = battle.winPlayerID
                end
            end,
            function()
                SystemUICall:GetInstance():Toast("当前是战斗回放，可随时退出回放，不影响战斗结果", false)

                LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.PreSelect, true)
            end
        )
    end
end

function PKManager:OnUpdateBattle(data)
    self.mRoomData["IDToBattle"] = {}
    local idToBattle = self.mRoomData["IDToBattle"]
    local battleList = data["akBattleData"]
    -- 排序BattleID
    for index, battle in pairs(battleList) do
        idToBattle[battle["uiBattleID"]] = battle
    end

    local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
    local nextBattlePlayerID = nil

    -- 最后一场不会走这个接口
    local battleNum = #battleList + 1
    if battleNum % 2 == 0 then
        for i = 0, battleNum - 2, 2 do
            local battlePlayerID1 = battleList[i]["uiWinnerID"]
            local battlePlayerID2 = battleList[i + 1]["uiWinnerID"]

            if battlePlayerID1 == ownerID then
                nextBattlePlayerID = battlePlayerID2
            elseif battlePlayerID2 == ownerID then
                nextBattlePlayerID = battlePlayerID1
            end
        end
    end
    self.mRoomData["NextBattlePlayerID"] = nextBattlePlayerID

    -- 如果不是重连，则回放当前数据
    if data["bGet"] == 0 then
        local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
        local minRound = 9999
        local battleID = nil
        for id, battle in pairs(idToBattle) do
            local round = battle["uiRoundID"]
            if round <= minRound then
                minRound = round

                local player1 = battle["kPly1Data"]
                local player2 = battle["kPly2Data"]
                if player1 and player1["defPlayerID"] == ownerID then
                    battleID = battle["uiBattleID"]
                elseif player2 and player2["defPlayerID"] == ownerID then
                    battleID = battle["uiBattleID"]
                end
            end
        end

        if battleID then
            self:RequestRecord(battleID)
        end
    end
end

function PKManager:OnUpdateShop(data)
    local pkConfig = GetTableData("PKConfig", 1) or {}
    local jibanID = pkConfig["JibanID"] or 0

    local itemList = data["akItems"] or {}

    local itemNum = 0
    local idToNum = {}
    for index, item in pairs(itemList) do
        local id = item["dwRoleId"]
        local num = item["dwRoleNum"]
        -- 羁绊丹特殊处理
        if id == jibanID then
            idToNum[id] = num
        else
            local itemData =
                ItemDataManager:GetInstance():GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_RolePieces, id)
            idToNum[itemData["BaseID"]] = num
        end

        itemNum = itemNum + 1
    end

    if itemNum == 0 then
        return
    end

    local endTime = self:GetTrueTime(data["dwTime"])

    self.mShopData = {
        IDToNum = idToNum,
        Gold = data["dwGold"] or 0,
        EndTime = endTime
    }

    -- 重进直接打开商店
    if data["bGet"] == 1 then
        self:ShowShop()
    end

    -- 刷新商城
    local wnd = GetUIWindow("PKShopUI")
    if wnd and wnd:IsOpen() then
        wnd:RefreshUI()
    end
end

function PKManager:OnResponse(data)
    dprint(
        "[PKManager] => OnResponse enRequest: " ..
            (data["enRequest"] or "unknow") .. ", error: " .. (data["enError"] or "unknow")
    )

    local errorCode = data["enError"]
    if errorCode and errorCode > 0 then
        if errorCode == EN_ZM_ERROR_InRoom then
            SystemUICall:GetInstance():WarningBox("已加入掌门对决,无法加入其他场掌门对决")
            SendZmOperate(EN_ZM_REQUEST_GetRoom)
        elseif errorCode == EN_ZM_ERROR_NoExist then
            SystemUICall:GetInstance():WarningBox("掌门对决场次不存在")
            SendZmOperate(EN_ZM_REQUEST_GetRoom)
        elseif errorCode == EN_ZM_ERROR_Playing then
            SystemUICall:GetInstance():WarningBox("掌门对决已经开始,无法加入")
        elseif errorCode == EN_ZM_ERROR_AlreadyClan then
            SystemUICall:GetInstance():WarningBox("掌门已选")
            SendZmOperate(EN_ZM_REQUEST_GetRoom)
        elseif errorCode == EN_ZM_ERROR_NoJoin then
            dprint("[PKManager] => MatchCancel")
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.MatchCancel)
        elseif errorCode == EN_ZM_ERROR_AlreadyJoin then
            -- TODO: 已在匹配队列里面，数据没有刷新
            if self.mMatchData == nil then
                self.mMatchData = {Num = 1, EndTime = os.time() + 60}
            end
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.MatchStart)
        elseif errorCode == EN_ZM_ERROR_Die then
            SystemUICall:GetInstance():WarningBox("已被淘汰无法操作")
        elseif errorCode == EN_ZM_ERROR_RoomNoPlayer then
            SystemUICall:GetInstance():WarningBox("玩家没有参加本场次")
        elseif errorCode == EN_ZM_ERROR_AlreadyOpt then
            SystemUICall:GetInstance():Toast("时间耗尽，选择角色或神器失败", false)
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.RoundEnd)
        elseif errorCode == EN_ZM_ERROR_Parmas then
            -- SendZmOperate(EN_ZM_REQUEST_GetRoom)
            SystemUICall:GetInstance():WarningBox("参数错误")
        elseif errorCode == EN_ZM_ERROR_NoRoom then
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.Ready)
        elseif errorCode == EN_ZM_ERROR_NoShop then
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.Ready)
        elseif errorCode == EN_ZM_ERROR_InShop then
            SystemUICall:GetInstance():WarningBox("结算不能匹配")
            SendZmOperate(EN_ZM_REQUEST_GetRoom)
        elseif errorCode == EN_ZM_ERROR_NoGold then
            SystemUICall:GetInstance():WarningBox("掌门币不够")
        elseif errorCode == EN_ZM_ERROR_NoTickets then
            SystemUICall:GetInstance():WarningBox("门票不足")
        elseif errorCode == EN_ZM_ERROR_NoRole then
            SystemUICall:GetInstance():WarningBox("不存在此角色卡")
        elseif errorCode == EN_ZM_ERROR_AlreadyBuyRole then
            SystemUICall:GetInstance():WarningBox("此角色卡已购买")
        elseif errorCode == EN_ZM_ERROR_AlreadyUseClanSkill then
            SystemUICall:GetInstance():WarningBox("掌门技能已使用")
            SendZmOperate(EN_ZM_REQUEST_GetRoom)
        elseif errorCode == EN_ZM_ERROR_NoServer then
            SystemUICall:GetInstance():WarningBox("匹配暂不可用，请留意游戏内公告")
        elseif errorCode == EN_ZM_ERROR_AlreadyNewFlag then
            SystemUICall:GetInstance():WarningBox("已完成新手引导")
        elseif errorCode == EN_ZM_ERROR_NotMatchTime then
            SystemUICall:GetInstance():WarningBox("当前不在匹配时间内")
        else
            SystemUICall:GetInstance():WarningBox("未知错误: " .. errorCode)
        end

        return
    end

    local id = data["enRequest"]
    -- 匹配开始
    if id == EN_ZM_REQUEST_Match then
        OpenWindowImmediately("PKMatchUI")
        self.mMatchData = {Num = data["iParams0"], EndTime = os.time() + 60}
        dprint("[PKManager] => MatchStart, Num: " .. self.mMatchData.Num)
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.MatchStart)
    elseif id == EN_ZM_REQUEST_SelectClan then
    elseif id == EN_ZM_REQUEST_SelectCard then
    elseif id == EN_ZM_REQUEST_SelectEquip then
    elseif id == EN_ZM_REQUEST_SetBattleCard then
        SystemUICall:GetInstance():Toast("布阵成功", false)
    elseif id == EN_ZM_REQUEST_EquipCard then
        -- SystemUICall:GetInstance():Toast("装备成功", false)
    elseif id == EN_ZM_REQUEST_ReflashClan then
        SystemUICall:GetInstance():Toast("刷新掌门", false)
    elseif id == EN_ZM_REQUEST_ReflashCard then
        SystemUICall:GetInstance():Toast("刷新卡牌", false)
    elseif id == EN_ZM_REQUEST_ReflashEquip then
        SystemUICall:GetInstance():Toast("刷新装备", false)
    elseif id == EN_ZM_REQUEST_ViewRecord then
    elseif id == EN_ZM_REQUEST_GetRoom then
        SystemUICall:GetInstance():Toast("获取房间", false)
    elseif id == EN_ZM_REQUEST_Die then
        self:OnEnd(PKManager.END_TYPE.Die)
    elseif id == EN_ZM_REQUEST_End then
        self:OnEnd(PKManager.END_TYPE.End)
    elseif id == EN_ZM_REQUEST_MatchEnd then
        SystemUICall:GetInstance():Toast("匹配成功", false)
        -- 匹配取消
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.MatchEnd)
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.Start)
    elseif id == EN_ZM_REQUEST_MatchCancle then
        SystemUICall:GetInstance():Toast("取消匹配成功", false)
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.MatchCancel)
    elseif id == EN_ZM_REQUEST_BuyShop then
        SystemUICall:GetInstance():Toast("购买成功", false)
    elseif id == EN_ZM_REQUEST_LeaveShop then
        PKManager:GetInstance():End()
    elseif id == EN_ZM_REQUEST_WatchOther then
    elseif id == EN_ZM_REQUEST_UseClanSkill then
        SystemUICall:GetInstance():Toast("使用门派技能成功", false)
        self.mPlayerData["SkillUseTimes"] = (self.mPlayerData["SkillUseTimes"] or 0) + 1
    else
        SystemUICall:GetInstance():Toast("未知返回数据: " .. id, false)
    end
end

--  观察别人
function PKManager:OnUpdateOtherPlayer(data)
    local playerInfo = data["kPlayerInfo"] or {}
    local cardList = playerInfo["akCardData"]
    local equipList = playerInfo["akEquipData"]

    local observeInfo = {}
    observeInfo["RoleInfos"] = {}

    local roleInfos = observeInfo["RoleInfos"]
    globalDataPool:setData("ObserveInfo", observeInfo, true)

    local idToEquip = {}
    for _, equip in pairs(equipList) do
        idToEquip[equip["dwId"]] = equip["dwBaseId"]
    end

    local info = {
        index = 1,
        roleIDs = {}
    }
    local roleIDs = info.roleIDs

    local teamNum = 0
    for _, card in pairs(cardList) do
        local baseID = card["dwBaseId"]

        if baseID > 0 then
            local mixLevel = math.max(card["dwLv"], 1)
            local uiID = card["dwId"]

            local pkRoleMain = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16)) or {}
            local pkRoleUpgrade = GetTableData("PKRoleUpgrade", mixLevel) or {}
            local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(pkRoleMain.RoleID)

            if roleData then
                local equipID = idToEquip[card["dwEquipId"] or 0] or 0
                local role =
                    ZmWatchRole.new(
                    uiID,
                    {
                        uiRemainAttrPoint = 0,
                        uiExp = 0,
                        uiStaticItemsFlag = 0,
                        uiStaticEquipsFlag = 0,
                        uiID = uiID,
                        uiTypeID = pkRoleMain.RoleID,
                        uiRank = roleData.Rank,
                        uiLevel = roleData.Level,
                        uiIndex = 0,
                        uiOverlayLevel = pkRoleMain.Grade,
                        equipLevel = pkRoleUpgrade.WeaponUpgrade,
                        equipID = equipID,
                        throneLevel = self.mRoomData["EquipLevel"]
                    }
                )

                roleInfos[uiID] = role

                table.insert(roleIDs, {uiRoleID = uiID})

                teamNum = teamNum + 1
            end
        end
    end

    local data = globalDataPool:getData("ObserveInfo")
    if teamNum > 0 then
        RoleDataManager:GetInstance():SetObserveData(true)
        OpenWindowImmediately("ObserveUI", info)
    else
        SystemUICall:GetInstance():Toast("玩家还没上阵任何角色", false)
    end
end

-- 监听通知
function PKManager:OnNotice(data)
    local ownerName = PlayerSetDataManager:GetInstance():GetPlayerName()

    local noticeType = data["enNotice"]
    if noticeType == EN_ZM_NOTICE_NULL then
        SystemUICall:GetInstance():Toast("无效消息", false)
    elseif noticeType == EN_ZM_NOTICE_Match then
        local num = (data["akNoticePairs"][0] or {})["dwFirst"]
        if self.mMatchData then
            self.mMatchData["Num"] = num
            LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.Match)
        end
    elseif noticeType == EN_ZM_NOTICE_SelectClan then
        local clanID = (data["akNoticePairs"][0] or {})["dwFirst"]
        if clanID then
            local clanData = TableDataManager.GetInstance():GetTableData("Clan", clanID)
            local clanName = clanData and GetLanguageByID(clanData.NameID) or ""
            SystemUICall:GetInstance():BarrageShow(string.format("%s选择了%s掌门", data["acSrcPlayerName"], clanName))
        end
    elseif noticeType == EN_ZM_NOTICE_SelectCard then
        local akNoticePairsList = data["akNoticePairs"]
        for _, akNoticePairs in pairs(akNoticePairsList) do
            local baseID = (akNoticePairs or {})["dwFirst"]
            local mixLevel = math.max((akNoticePairs or {})["dwSecond"], 1)

            if baseID == nil then
                break
            end

            local pkRole = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16)) or {}
            local roleID = pkRole["RoleID"]
            local name = RoleDataManager:GetInstance():GetRoleNameByTypeID(roleID)

            SystemUICall:GetInstance():Toast(string.format("%s加入了队伍", name))
        end
    elseif noticeType == EN_ZM_NOTICE_CardLvUp then
        local baseID = (data["akNoticePairs"][0] or {})["dwFirst"] or 0
        local mixLevel = math.max((data["akNoticePairs"][0] or {})["dwSecond"], 1)

        local pkRole = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16)) or {}
        local roleID = pkRole["RoleID"]

        local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleID)

        local name = RoleDataManager:GetInstance():GetRoleNameByTypeID(roleID)

        local grade = pkRole["Grade"] or 0

        if grade == 0 then
            local colorName = self.RankToName[roleData["Rank"]]
            SystemUICall:GetInstance():Toast(string.format("%s升到了%s%d级", name, colorName, roleData["Level"]))
        else
            local colorName = self.RankToName[roleData["Rank"]]
            SystemUICall:GetInstance():Toast(
                string.format("%s升到了%s%d级，修行等级+%d", name, colorName, roleData["Level"], grade)
            )
        end
    elseif noticeType == EN_ZM_NOTICE_SelectEquip then
        local weaponID = (data["akNoticePairs"][0] or {})["dwFirst"]
        local itemData = weaponID ~= nil and ItemDataManager:GetInstance():GetItemTypeDataByTypeID(weaponID) or nil

        local baseID = (data["akNoticePairs"][1] or {})["dwFirst"] or 0
        local mixLevel = (data["akNoticePairs"][1] or {})["dwSecond"] or 0
        local pkRole = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16))

        if pkRole then
            local roleID = pkRole["RoleID"] or 0
            local name = RoleDataManager:GetInstance():GetRoleName(roleID, true)

            SystemUICall:GetInstance():Toast(string.format("获得%s，%s装备上了", itemData.ItemName or '', name))
        end
    elseif noticeType == EN_ZM_NOTICE_AwardCard then
        if data["acSrcPlayerName"] == ownerName or data["acTargetPlayerName"] == ownerName then
            local roleList = {}

            local zmGold = 0
            local map = table_c2lua(data["akNoticePairs"])
            for _, value in pairs(map) do
                local baseID = value["dwFirst"]

                -- 服务器硬性规定这个id是掌门币！！！
                if baseID == EN_ZM_NOTICE_Gold then
                    zmGold = value["dwSecond"]
                else
                    local pkRole = GetTableData("PKRole", baseID)
                    roleList[#roleList + 1] = pkRole["RoleID"]
                end
            end

            self.mAwardData = {
                WinName = data["acSrcPlayerName"] == ownerName and data["acTargetPlayerName"] or nil,
                LoseName = data["acTargetPlayerName"] == ownerName and data["acSrcPlayerName"] or nil,
                RoleList = roleList,
                ZmGold = zmGold
            }
        end
    elseif noticeType == EN_ZM_NOTICE_Pvp then
        local srcPlayerName = data["acSrcPlayerName"]
        local targetPlayerName = data["acTargetPlayerName"]

        if srcPlayerName ~= ownerName and targetPlayerName ~= ownerName then
            SystemUICall:GetInstance():BarrageShow(string.format("%s战胜了%s", srcPlayerName, targetPlayerName))
        end
    elseif noticeType == EN_ZM_NOTICE_Pve then
        local srcPlayerName = data["acSrcPlayerName"]
        if srcPlayerName ~= ownerName then
            local fightID = (data["akNoticePairs"][0] or {})["dwFirst"]
            local formatStr = (data["akNoticePairs"][0] or {})["dwSecond"] == 1 and "%s战胜了%s" or "%s败给了%s"

            local name = nil
            local battleData = GetTableData("Battle", fightID) or {}
            local roleTypeID = (battleData["BossList"] or {})[1]
            if roleTypeID then
                local role = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleTypeID)
                if role then
                    name = GetLanguageByID(role["NameID"])
                end
            end

            SystemUICall:GetInstance():BarrageShow(string.format(formatStr, srcPlayerName, name or "敌人"))
        end
    elseif noticeType == EN_ZM_NOTICE_Beg then
        local roleID = (data["akNoticePairs"][0] or {})["dwFirst"] or 0
        local fightID = (data["akNoticePairs"][0] or {})["dwSecond"] or 0

        if roleID and roleID > 0 then
            roleID = (GetTableData("PKRole", roleID) or {})["RoleID"] or 0
        else
            local battleData = GetTableData("Battle", fightID) or {}
            roleID = (battleData["BossList"] or {})[1]
        end

        -- 乞讨类型
        local begType = (data["akNoticePairs"][1] or {})["dwFirst"]
        -- 乞讨数目或者乞讨神器
        local numOrID = (data["akNoticePairs"][1] or {})["dwSecond"]

        local config = GetTableData("PKConfig", 1) or {}
        local begList = config["BegRate"] or {}
        local itemList = {}
        local itemID = 0

        local refreshItemID = 9657
        local zmBiItemID = 9656

        -- TODO: 乞讨总数量，硬编码
        local total = 20
        -- 空数量
        local emptyNum = math.floor(total * (begList[EN_ZM_BEG_NONE + 1] or 0) / 10000)
        -- 刷新次数数量
        local refreshNum = math.floor(total * (begList[EN_ZM_BEG_REFRESHTIMES + 1] or 0) / 10000)
        -- 掌门币数量
        local zmBiNum = math.floor(total * (begList[EN_ZM_BEG_LETTAIBI + 1] or 0) / 10000)
        -- 神器数量
        local shenqiNum = total - emptyNum - refreshNum - zmBiNum

        for i = 1, refreshNum do
            table.insert(itemList, refreshItemID)
        end
        for i = 1, zmBiNum do
            table.insert(itemList, zmBiItemID)
        end

        -- 神器特殊处理一下，需要客户端自己随，服务器传的是PKWeapon的BaseID!!!
        local pkWeaponTable = TableDataManager:GetInstance():GetTable("PKWeapon") or {}
        local shenqiList = {}
        local selectShenqiList = {}
        for _, pkWeaponTable in pairs(pkWeaponTable) do
            table.insert(shenqiList, pkWeaponTable["BaseID"])
        end
        for i = 1, shenqiNum do
            local randomIdx = math.random(1, #shenqiList)
            local baseID = shenqiList[randomIdx]
            local weaponConfig = pkWeaponTable[baseID] or {}
            table.remove(shenqiList, randomIdx)
            table.insert(selectShenqiList, weaponConfig["WeaponID"] or 0)
        end

        if begType == EN_ZM_BEG_NONE then
        elseif begType == EN_ZM_BEG_SHENQI then
            itemID = numOrID

            if table.indexof(selectShenqiList, itemID) == false then
                local randomIdx = math.random(1, #shenqiList)
                selectShenqiList[randomIdx] = itemID
            end
        elseif begType == EN_ZM_BEG_REFRESHTIMES then
            itemID = refreshItemID
        elseif begType == EN_ZM_BEG_LETTAIBI then
            itemID = zmBiItemID
        end

        for _, selectShenqi in pairs(selectShenqiList) do
            table.insert(itemList, selectShenqi)
        end

        -- 把itemList打乱掉
        local tempItemList = {}
        local num = #itemList
        for i = 1, num do
            local randIdx = math.random(1, #itemList)
            local item = itemList[randIdx]
            tempItemList[i - 1] = item
            table.remove(itemList, randIdx)
        end

        self.mRollData = {
            ItemList = tempItemList,
            RoleID = roleID,
            ItemID = itemID
        }
    elseif noticeType == EN_ZM_NOTICE_PanCha then
        local baseID = (data["akNoticePairs"][0] or {})["dwFirst"] or 0
        local roleID = (GetTableData("PKRole", baseID) or {})["RoleID"] or 0
        local roleName = RoleDataManager:GetInstance():GetRoleName(roleID, true)

        SystemUICall:GetInstance():BarrageShow(
            string.format("%s盘查了%s，下轮战斗所有玩家的%s无法出战", data["acSrcPlayerName"], roleName, roleName)
        )
    elseif noticeType == EN_ZM_NOTICE_DecomposeCard then
        local roleList = {}

        local refreshTimes = 0
        local map = table_c2lua(data["akNoticePairs"])
        for _, value in pairs(map) do
            local baseID = value["dwFirst"]

            -- 服务器硬性规定这个id是刷新次数！！！
            if baseID == EN_ZM_NOTICE_RefreshTimes then
                refreshTimes = value["dwSecond"]
            else
                local pkRole = GetTableData("PKRole", baseID)
                roleList[#roleList + 1] = pkRole["RoleID"]
            end
        end

        self.mDecomposeData = {
            RoleList = roleList,
            RefreshTimes = refreshTimes
        }
    elseif noticeType == EN_ZM_NOTICE_RoundEnd then
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.RoundEnd)
    elseif noticeType == EN_ZM_NOTICE_RoleNum then
        -- 更新卡池
        local idToNum = self.mRoomData["IDToNum"] or {}
        for _, value in pairs(data["akNoticePairs"]) do
            local baseID = value["dwFirst"]
            local num = value["dwSecond"]

            if idToNum[baseID] then
                idToNum[baseID] = num
            end
        end
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.RefreshRoleNum)
    else
        SystemUICall:GetInstance():Toast("未知返回通知类型: " .. noticeType, false)
    end
end

function PKManager:OnEnd(endType)
    self.mEnd = endType
end

function PKManager:OnGameReconnect()
    SendZmOperate(EN_ZM_REQUEST_GetRoom)
end
--endregion

--region 服务器消息
-- 开始新手引导
function PKManager:RequestStartGuide()
    dprint("[PKManager] => RequestStartGuide")
    SendZmOperate(EN_ZM_REQUEST_Match, 0, 1)
end

-- 开始匹配
function PKManager:RequestStartMatch()
    -- 匹配前清空数据
    self:ClearData()
    dprint("[PKManager] => RequestStartMatch")
    SendZmOperate(EN_ZM_REQUEST_Match, 0, 0)
end

-- 取消匹配
function PKManager:RequestCancelMatch()
    dprint("[PKManager] => RequestCancelMatch")
    SendZmOperate(EN_ZM_REQUEST_MatchCancle)
end

-- 选择掌门
function PKManager:RequestSelectClan(index)
    if self.mRoomData and self.mRoomData.ID then
        dprint("[PKManager] => RequestSelectClan")
        SendZmOperate(EN_ZM_REQUEST_SelectClan, self.mRoomData.ID, index)
    end
end

-- 刷新掌门
function PKManager:RequestRefreshClan()
    local refrehsTimes = (self.mPlayerData["RefreshTimes"] or 0)
    if refrehsTimes <= 0 then
        return SystemUICall:GetInstance():Toast("刷新次数为0，不能刷新")
    end

    if self.mRoomData and self.mRoomData.ID then
        dprint("[PKManager] => RequestRefreshClan")
        SendZmOperate(EN_ZM_REQUEST_ReflashClan, self.mRoomData.ID)
    end
end

-- 选择角色
function PKManager:RequestSelectRole(index)
    if self.mRoomData and self.mRoomData.ID then
        dprint("[PKManager] => RequestSelectRole")
        SendZmOperate(EN_ZM_REQUEST_SelectCard, self.mRoomData.ID, index)
    end
end

-- 刷新角色
function PKManager:RequestRefreshRole()
    local refrehsTimes = (self.mPlayerData["RefreshTimes"] or 0)
    if refrehsTimes <= 0 then
        return SystemUICall:GetInstance():Toast("刷新次数为0，不能刷新")
    end

    if self.mRoomData and self.mRoomData.ID then
        dprint("[PKManager] => RequestRefreshRole")
        SendZmOperate(EN_ZM_REQUEST_ReflashCard, self.mRoomData.ID)
    end
end

-- 选择神器
function PKManager:RequestSelectEquip(index)
    if self.mRoomData and self.mRoomData.ID then
        dprint("[PKManager] => RequestSelectEquip")
        SendZmOperate(EN_ZM_REQUEST_SelectEquip, self.mRoomData.ID, index)
    end
end

-- 刷新神器
function PKManager:RequestRefreshEquip()
    local refrehsTimes = (self.mPlayerData["RefreshTimes"] or 0)
    if refrehsTimes <= 0 then
        return SystemUICall:GetInstance():Toast("刷新次数为0，不能刷新")
    end

    if self.mRoomData and self.mRoomData.ID then
        dprint("[PKManager] => RequestRefreshEquip")
        SendZmOperate(EN_ZM_REQUEST_ReflashEquip, self.mRoomData.ID)
    end
end

-- 请求回放
function PKManager:RequestRecord(battleID)
    local roomData = self:GetRoomData() or {}
    local idToBattle = roomData["IDToBattle"] or {}
    local battle = idToBattle[battleID]
    if self.mRoomData and self.mRoomData.ID and battle then
        self:HideLoading()
        self:ShowLoading()
        ArenaDataManager:GetInstance():ReplayZm(self:GetPVPReplayData(battle), self.mRoomData.ID)
    end
end

-- 装备神器
function PKManager:RequestEquip(roleID, itemID)
    local item = ItemDataManager:GetInstance():GetItemData(itemID)
    if item and item.serverID then
        SendZmOperate(EN_ZM_REQUEST_EquipCard, self.mRoomData.ID, roleID, item.serverID)
    end
end
function PKManager:RequestUnEquip(roleID, itemID)
    local item = ItemDataManager:GetInstance():GetItemData(itemID)
    if item and item.serverID then
        SendZmOperate(EN_ZM_REQUEST_EquipCard, self.mRoomData.ID, roleID, 0)
    end
end

-- 商城购买
function PKManager:RequestBuy(id, num)
    SendZmOperate(EN_ZM_REQUEST_BuyShop, 0, id, num or 1)
end

-- 商城离开
function PKManager:RequestLeave()
    SendZmOperate(EN_ZM_REQUEST_LeaveShop)
end

-- 观察
function PKManager:RequestWatch(id)
    SendZmOperate(EN_ZM_REQUEST_WatchOther, self.mRoomData.ID, 0, 0, 0, 0, id)
end

-- 布阵
function PKManager:RequestBattlePos(posDataList, round)
    if round ~= 1 then
        return
    end

    local battleCardList = {}
    local count = 0
    local maxCount = RoleDataManager:GetInstance():GetCanEmbattleCount()
    for i = 1, maxCount do
        local posData = posDataList[i]

        if posData then
            -- WARNING: 坐标必须要-1，保持与服务器同步
            battleCardList[count] = {
                dwId = posData["uiRoleID"],
                dwBattleIndex = count,
                wX = posData["iGridX"] - 1,
                wY = posData["iGridY"] - 1
            }
            count = count + 1
        end
    end
    SendZmBattleCard(self.mRoomData.ID, count, battleCardList)
end

function PKManager:RequestUseSkill(param0)
    SendZmOperate(EN_ZM_REQUEST_UseClanSkill, self.mRoomData.ID, param0)
end

function PKManager:RequestSkip()
    -- TODO: 跳过协议未定义
    dprint("Request Skip")
end
--endregion

--region util
function PKManager:GetPVPReplayData(battle)
    local data = {}

    data.dwBattleID = battle["uiBattleID"]
    data.dwRoundID = battle["uiRoundID"]
    data.dwPly1BetRate = 0
    data.dwPly2BetRate = 0
    data.defPlyWinner = battle["uiWinnerID"]
    data.defBetPlyID = 0
    data.dwBetMoney = 0

    local player1 = battle["kPly1Data"]
    data.kPly1Data = {}
    data.kPly1Data.defPlayerID = player1["defPlayerID"]
    data.kPly1Data.acPlayerName = player1["acPlayerName"]

    -- data.kPly1Data.dwModelID = 0
    local baseID = player1["dwRoleID"] or 0
    local pkRoleData = GetTableData("PKRole", baseID) or {}
    local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(pkRoleData["RoleID"])
    if roleData then
        data.kPly1Data.dwModelID = roleData["ArtID"]
    end

    local player2 = battle["kPly2Data"]
    data.kPly2Data = {}
    data.kPly2Data.defPlayerID = player2["defPlayerID"]
    data.kPly2Data.acPlayerName = player2["acPlayerName"]

    -- data.kPly2Data.dwModelID = 0
    local baseID = player2["dwRoleID"] or 0
    local pkRoleData = GetTableData("PKRole", baseID) or {}
    local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(pkRoleData["RoleID"])
    if roleData then
        data.kPly2Data.dwModelID = roleData["ArtID"]
    end

    return data
end

function PKManager:GetPVEReplayData(battle, fightID)
    local data = {}

    data.dwBattleID = battle["uiBattleID"]
    data.dwRoundID = battle["uiRoundID"]
    data.dwPly1BetRate = 0
    data.dwPly2BetRate = 0
    data.defPlyWinner = battle["uiWinnerID"]
    data.defBetPlyID = 0
    data.dwBetMoney = 0

    data.kPly1Data = {}
    data.kPly1Data.defPlayerID = PlayerSetDataManager:GetInstance():GetPlayerID()
    data.kPly1Data.acPlayerName = PlayerSetDataManager:GetInstance():GetPlayerName()
    data.kPly1Data.dwModelID = PlayerSetDataManager:GetInstance():GetModelID()
    local maxBaseID = nil
    local maxLevel = 0
    local roleList = self.mRoleList or {}
    local idToCard = self.mPlayerData["IDToCard"] or {}
    for _, id in pairs(roleList) do
        local card = idToCard[id]
        if card and card["dwLv"] > maxLevel then
            maxLevel = card["dwLv"]
            maxBaseID = card["dwBaseId"]
        end
    end
    if maxBaseID then
        local roleData = GetTableData("PKRole", maxBaseID)
        local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleData["RoleID"])
        if roleData then
            data.kPly1Data.dwModelID = roleData["ArtID"]
        end
    end

    data.kPly2Data = {}
    data.kPly2Data.defPlayerID = 0
    data.kPly2Data.dwModelID = 0
    data.kPly2Data.acPlayerName = ""

    -- 刷新PVE的角色
    local battleData = GetTableData("Battle", fightID) or {}
    local roleTypeID = (battleData["BossList"] or {})[1]
    if roleTypeID then
        local role = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleTypeID)
        if role then
            data.kPly2Data.acPlayerName = GetLanguageByID(role["NameID"])
            data.kPly2Data.dwModelID = role["ArtID"]
        end
    end

    return data
end
--endregion

--region UI
function PKManager:ShowRankUI()
    local roomData = self:GetRoomData() or {}

    local rankTitleList = {"64强", "32强", "16强", "8强", "半决赛", "决赛"}
    local rankNumList = {64, 32, 16, 8, 4, 2}

    local idToBattle = roomData["IDToBattle"] or {}
    local keyToBattle = {}
    local idToLoseRound = {}
    local maxLoseRound = 0
    for id, battle in pairs(idToBattle) do
        local player1 = battle["kPly1Data"] or {}
        local player2 = battle["kPly2Data"] or {}

        local round = table.indexof(rankNumList, battle["uiRoundID"])
        if round then
            -- key: [Round_PlayerID] => [BattleID]
            keyToBattle[round .. "_" .. player1["defPlayerID"]] = battle["uiBattleID"]
            keyToBattle[round .. "_" .. player2["defPlayerID"]] = battle["uiBattleID"]

            if battle["uiWinnerID"] == player1["defPlayerID"] then
                idToLoseRound[player2["defPlayerID"]] = round
            else
                idToLoseRound[player1["defPlayerID"]] = round
            end

            if round > maxLoseRound then
                maxLoseRound = round
            end
        end
    end

    local roomPlayerList = roomData["PlayerList"] or {}
    local playerList = {}
    for index, roomPlayer in pairs(roomPlayerList) do
        local roomPlayerEx = roomPlayer["kPlyData"] or {}
        local playerID = roomPlayerEx["defPlayerID"]
        playerList[index + 1] = {
            Name = roomPlayerEx["acPlayerName"],
            charPicUrl = roomPlayerEx["charPicUrl"],
            dwModelID = roomPlayerEx["dwModelID"],
            ID = roomPlayerEx["defPlayerID"],
            Robot = roomPlayer["bRobot"] == 1,
            LoseRound = playerID ~= nil and idToLoseRound[playerID] or nil
        }
    end

    OpenWindowImmediately(
        "PKRankUI",
        {
            Index = math.max(maxLoseRound, 1),
            NextRound = math.max(maxLoseRound, 1),
            RankTitleList = rankTitleList,
            RankNumList = rankNumList,
            ShowColNum = {4, 2, 1},
            PlayerList = playerList,
            KeyToBattle = keyToBattle
        }
    )
end

function PKManager:ShowRoleUI()
    OpenWindowImmediately("PKRoleUI")
end

function PKManager:ShowEndUI()
    RoleDataManager:GetInstance():SetObserveData(false)

    if self.mEnd == PKManager.END_TYPE.Null then
        return false
    elseif self.mEnd == PKManager.END_TYPE.Die then
        -- SystemUICall:GetInstance():WarningBox("已被淘汰，进入商城")
        self:ShowShop()
        return true
    elseif self.mEnd == PKManager.END_TYPE.End then
        -- SystemUICall:GetInstance():WarningBox("比赛结束，进入商城")
        self:ShowShop()
        return true
    end
end

function PKManager:ShowLoading()
    -- 乞讨界面要做特殊处理，不然会报错！！！
    if IsWindowOpen("RandomRollUI") then
        RemoveWindowImmediately("RandomRollUI", false)
        DisplayActionEnd()
    end

    if not IsWindowOpen("LoadingUI") then
        -- 关掉引导
        if GuideDataManager:GetInstance().curGuideList and GuideDataManager:GetInstance().curGuideList.GuideKey then
            GuideDataManager:GetInstance():GuideEnd()
        end

        -- reset window
        WindowsManager:GetInstance():CloseAll("BarrageUI")

        OpenWindowImmediately("PKUI")

        OpenWindowImmediately("LoadingUI")
    end

    if self.mTimer then
        globalTimer:RemoveTimer(self.mTimer)
    end

    self.mTimer =
        globalTimer:AddTimer(
        3000,
        function()
            self.mTimer = nil
            RemoveWindowImmediately("LoadingUI")
        end,
        1
    )
end

function PKManager:HideLoading()
    -- 强制清空战斗
    if IsBattleOpen() then
        ArenaDataManager:GetInstance():ReplayerOver()
        LogicMain:GetInstance():ReturnToTown(true)
    end

    -- 移除loading
    if self.mTimer then
        globalTimer:RemoveTimer(self.mTimer)
        RemoveWindowImmediately("LoadingUI")
        self.mTimer = nil
    end
end

function PKManager:ShowDialog(npcID, des, choiceList)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_ROLE_CHOICE, false, npcID, des, choiceList)

    -- 修改对话背景
    local winBlur = GetUIWindow("BlurBGUI")
    if winBlur then
        -- 背景硬编码
        local sprite = GetSprite("MapBG/sc_bg_zmdjleitai")
        winBlur:SetBlurBGImg(sprite)
    end
end

function PKManager:ShowAward()
    if self.mAwardData then
        local tip = ""
        local roleListName = ""

        for _, roleID in pairs(self.mAwardData.RoleList) do
            local roleName = RoleDataManager:GetInstance():GetRoleName(roleID, true)
            roleListName = roleListName .. roleName .. "、"
        end
        -- WARNING: 一个中文字符占3个字节
        roleListName = string.sub(roleListName, 1, string.len(roleListName) - 3)

        if self.mAwardData.WinName then
            tip =
                string.format(
                "你在对战中战胜了%s，获得了他的%s角色，%d个掌门币",
                self.mAwardData.WinName,
                roleListName,
                self.mAwardData.ZmGold or 0
            )
        else
            tip = string.format("你在对战中败给了%s，失去了%s角色", self.mAwardData.LoseName, roleListName)
        end

        SystemUICall:GetInstance():BarrageShow(tip)

        local chatBoxUI = GetUIWindow("ChatBoxUI")
        if chatBoxUI then
            local notice = {channel = BroadcastChannelType.BCT_System, content = tip}
            chatBoxUI:AddNotice(notice)
            chatBoxUI:OnRefNormalList(nil)
        end

        self.mAwardData = nil
    end

    if self.mDecomposeData then
        local roleListName = ""

        for _, roleID in pairs(self.mDecomposeData.RoleList) do
            local roleName = RoleDataManager:GetInstance():GetRoleName(roleID, true)
            roleListName = roleListName .. roleName .. "、"
        end
        -- WARNING: 一个中文字符占3个字节
        roleListName = string.sub(roleListName, 1, string.len(roleListName) - 3)

        local tip = string.format("%s重复角色已离队，返还刷新次数%d次", roleListName, self.mDecomposeData.RefreshTimes)
        SystemUICall:GetInstance():BarrageShow(tip)

        local chatBoxUI = GetUIWindow("ChatBoxUI")
        if chatBoxUI then
            local notice = {channel = BroadcastChannelType.BCT_System, content = tip}
            chatBoxUI:AddNotice(notice)
            chatBoxUI:OnRefNormalList(nil)
        end

        self.mDecomposeData = nil
    end
end

function PKManager:ShowRoll()
    if self.mRollData then
        local artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(self.mRollData["RoleID"]) or {}
        OpenWindowImmediately(
            "RandomRollUI",
            {
                auiRoleItem = self.mRollData["ItemList"],
                strDrawing = artData.Drawing,
                uiItemID = self.mRollData["ItemID"],
                bNeedDisplayEnd = true,
                eInteractType = 1,
                iItemP = 100
            }
        )

        -- 修改对话背景
        local winBlur = GetUIWindow("BlurBGUI")
        if winBlur then
            -- 背景硬编码
            local sprite = GetSprite("MapBG/sc_bg_zmdjleitai")
            winBlur:SetBlurBGImg(sprite)
        end

        self.mRollData = nil
    end
end

function PKManager:ShowPVPWatchUI(id)
    local ownerID = PlayerSetDataManager:GetInstance():GetPlayerID()
    if id == ownerID then
        local info = {
            index = 1,
            roleIDs = {}
        }
        local roleIDs = info.roleIDs

        local mainRoleInfo = globalDataPool:getData("MainRoleInfo") or {}
        local teamList = mainRoleInfo["Teammates"] or {}
        local teamNum = mainRoleInfo["TeammatesNums"] or 0
        for _, roleID in pairs(teamList) do
            table.insert(roleIDs, {uiRoleID = roleID})
        end

        if teamNum > 0 then
            RoleDataManager:GetInstance():SetObserveData(false)
            OpenWindowImmediately("ObserveUI", info)
        else
            SystemUICall:GetInstance():Toast("玩家还没上阵任何角色")
        end
    else
        PKManager:GetInstance():RequestWatch(id)
    end
end

function PKManager:ShowPVEWatchUI(roleTypeID)
    local observeInfo = {}
    observeInfo["RoleInfos"] = {}
    local roleInfos = observeInfo["RoleInfos"]
    globalDataPool:setData("ObserveInfo", observeInfo, true)

    local info = {
        index = 1,
        roleID = roleTypeID
    }

    roleInfos[roleTypeID] =
        NPCRole.new(
        roleTypeID,
        {
            uiTypeID = roleTypeID,
            uiStaticItemsFlag = 0,
            uiStaticEquipsFlag = 0,
            uiIndex = 0,
            uiOverlayLevel = 0,
            iGoodEvil = 0
        }
    )

    RoleDataManager:GetInstance():SetObserveData(true)
    OpenWindowImmediately("ObserveUI", info)
end
--endregion

function PKManager:RebuildDataPool()
    -- 数据重置
    globalDataPool:setData("ItemPool", {}, true)
    globalDataPool:setData("GiftPool", {}, true)
    globalDataPool:setData("EmbattleMartial", {}, true)
    globalDataPool:setData("MainRoleInfo", {}, true)
    globalDataPool:setData("GameData", {}, true)

    self.mItemID = PKManager.MAIN_ROLE_ID

    local mainRoleID = nil
    local idToCard = self.mPlayerData["IDToCard"] or {}

    local mainRoleInfo = globalDataPool:getData("MainRoleInfo")

    local info = globalDataPool:getData("GameData")

    info["eCurState"] = 0

    info["RoleInfos"] = {}
    local roleInfos = info["RoleInfos"]

    local teamCheck = {}
    local teamList = {}
    local teamNum = 0

    local equipState = {}
    for id, card in pairs(idToCard) do
        local baseID = card["dwBaseId"]
        local mixLevel = math.max(card["dwLv"], 1)
        local uiID = card["dwId"]

        if mainRoleID == nil then
            mainRoleID = uiID
        end

        local pkRoleMain = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16)) or {}
        local pkRoleUpgrade = GetTableData("PKRoleUpgrade", mixLevel) or {}
        local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(pkRoleMain.RoleID)

        local equipID = card["dwEquipId"]
        local role =
            ZmRole.new(
            uiID,
            {
                uiID = uiID,
                uiTypeID = pkRoleMain.RoleID,
                uiRank = roleData.Rank,
                uiLevel = roleData.Level,
                uiIndex = 0,
                uiOverlayLevel = pkRoleMain.Grade,
                equipLevel = pkRoleUpgrade.WeaponUpgrade,
                equipID = equipID,
                throneLevel = self.mRoomData["EquipLevel"]
            }
        )

        if equipID and equipID > 0 then
            equipState[equipID] = true
        end

        roleInfos[uiID] = role

        teamList[teamNum] = uiID
        teamNum = teamNum + 1
        teamCheck[uiID] = true
    end

    mainRoleInfo["Teammates"] = teamList
    mainRoleInfo["TeammatesNums"] = teamNum
    mainRoleInfo["TeammatesCheck"] = teamCheck

    -- 设置布阵
    self.mRoleList = self.mTempRoleList
    self.mTempRoleList = nil
    local roleList = self.mRoleList or {}
    local battleList = {}
    local battleIdx = 0
    for i = 0, getTableSize(roleList) do
        local id = roleList[i]
        if id and id ~= 0 then
            local roleData = idToCard[id]
            battleList[battleIdx] = {
                uiFlag = 0,
                bPet = 0,
                eFlag = IN_TEAM,
                iRound = 1,
                iID = 1,
                iGridY = roleData["wY"],
                iGridX = roleData["wX"],
                uiRoleID = id
            }
            battleIdx = battleIdx + 1
        end
    end

    -- 给战斗关联的系统界面用
    if mainRoleID then
        local mainRole = roleInfos[mainRoleID]

        mainRoleInfo["MainRole"] = {
            [MRIT_MAINROLE_MODELID] = mainRole.uiModelID,
            [MRIT_MAINROLEID] = mainRole.uiID,
            [MRIT_BATTLE_TEAMNUMS] = (self.mPlayerData["LimitRoleNum"] or 0),
            [MainRoleData.MRD_DEFAULT_GOOD] = 0
        }

        -- 生成主角名称（有点变态的……不这样操作，队伍主角名称会显示为空）
        mainRoleInfo["kName"] = RoleDataManager:GetInstance():GetRoleName(mainRole.uiID, true)

        -- 生成主角包裹
        if mainRole then
            mainRole["auiRoleItem"] = {}
            local itemList = mainRole["auiRoleItem"]

            local equipList = self.mPlayerData["EquipList"]
            for i = 0, getTableSize(equipList) do
                local equip = equipList[i]
                -- 排除已经装备的神器
                if equip and equip["dwId"] and equipState[equip["dwId"]] ~= true then
                    itemList[#itemList + 1] = self:AddEquip(equip["dwBaseId"], equip["dwLv"], equip["dwId"])
                end
            end
        end
    end

    -- 发送包裹刷新
    ItemDataManager:GetInstance():DispatchUpdateEvent()

    -- 刷新装备状态
    ItemDataManager:GetInstance():SetReGenRoleEquipItemFlag()

    -- 发送人物界面刷新
    LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_ROLECOMMON")
    LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_ROLEITEMS")
    LuaEventDispatcher:dispatchEvent("UPDATE_GIFT")

    -- 发送阵型界面刷新
    RoleDataManager:GetInstance():InitTownRoleEmbattleData(battleList)
    LuaEventDispatcher:dispatchEvent("UPDATE_EMBATTLE", {ToggleID = 1, Round = 1})

    LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.RefreshBattleRole)

    local wnd = GetUIWindow("CharacterUI")
    if wnd and wnd:IsOpen() then
        wnd:RefreshUI()
    end

    self.mRebuildFlag = false
end

function PKManager:UpdateRole(id)
    if id then
        local info = globalDataPool:getData("GameData") or {}
        local roleInfos = info["RoleInfos"] or {}
        local role = roleInfos[id]
        if role then
            local success = true
            xpcall(
                function()
                    role:Update()
                end,
                function()
                    success = false
                end
            )
            return success
        end
    end

    return false
end

function PKManager:BuildUID()
    local uiID = self.mItemID
    self.mItemID = self.mItemID + 1
    return uiID
end

function PKManager:AddEquip(id, level, serverID)
    local itemPool = globalDataPool:getData("ItemPool")
    if itemPool == nil then
        return
    end

    -- 物品已存在，用来判断神器的装备与否
    if serverID then
        -- 先去包裹里面找
        for uiID, item in pairs(itemPool) do
            if item.serverID == serverID then
                return item.uiID
            end
        end

        -- 再去选择的神器列表里面找
        local equipList = self.mPlayerData["EquipList"]
        for i = 0, getTableSize(equipList) do
            local equip = equipList[i]
            if equip and equip["dwId"] == serverID then
                id = equip["dwBaseId"]
                break
            end
        end

        if id == nil then
            return
        end
    end

    local itemBattleInfo = TableDataManager:GetInstance():GetTableData("ItemBattle", id)
    local instData = ItemDataManager:GetInstance():genInstItemByItemBattle(itemBattleInfo) or {}

    level = level or 0
    -- 装备强化属性
    local auiAttrData = instData.auiAttrData or {}
    local kItemaDataMgr = ItemDataManager:GetInstance()
    for k, attrInfo in pairs(auiAttrData) do
        local bIsRecastableAttr = (kItemaDataMgr:JudgeAttrRankType(attrInfo, "green") == true)
        attrInfo.iBaseValue =
            ItemDataManager:GetInstance():CalculateEnhanceGradeAttr(
            nil,
            id,
            attrInfo.uiType,
            attrInfo.iBaseValue,
            level,
            bIsRecastableAttr
        )
    end

    local uiID = self:BuildUID()
    itemPool[uiID] = {
        iInstID = uiID,
        uiID = uiID,
        uiTypeID = id,
        uiEnhanceGrade = level,
        auiAttrData = auiAttrData,
        -- 服务器生成的uiID，装备神器的时候会用
        serverID = serverID
    }

    return uiID
end

function PKManager:GetShopData()
    local shopData = self.mShopData or {}
    local itemIDList = {}
    local itemIDToNum = {}
    for id, num in pairs(shopData["IDToNum"] or {}) do
        if num > 0 then
            table.insert(itemIDList, id)
            itemIDToNum[id] = num
        end
    end

    return {
        ItemIDList = itemIDList,
        ItemIDToNum = itemIDToNum,
        Gold = shopData["Gold"] or 0,
        EndTime = shopData["EndTime"]
    }
end

function PKManager:GetZmGold()
    local shopData = self:GetShopData() or {}
    return shopData["Gold"] or 0
end

function PKManager:GetRankName(rank)
    return self.RankToName[rank]
end

function PKManager:InTeam(baseID)
    local idToCard = self.mPlayerData["IDToCard"] or {}

    for _, card in pairs(idToCard) do
        if card["dwBaseId"] == baseID then
            return true
        end
    end
    return false
end

function PKManager:GetMainRoleID()
    local info = globalDataPool:getData("MainRoleInfo")

    -- 主角不存在，选取列表第一个当主角
    if not (info and info["MainRole"] and info["MainRole"][MRIT_MAINROLEID]) then
        return PKManager.MAIN_ROLE_ID
    end

    return info["MainRole"][MRIT_MAINROLEID]
end

function PKManager:GetLastSelectTimes(eventID)
    local lastTimes = 0

    local round = self.mPlayerData["RoundID"]
    if round and round > 0 then
        local processConfig = GetTableData("PKProcessDetail", round) or {}
        local roundID = processConfig["RoundID"] or 0
        lastTimes = 1

        while true do
            round = round + 1
            processConfig = GetTableData("PKProcessDetail", round)
            if processConfig == nil then
                break
            end

            if processConfig["RoundID"] ~= roundID then
                break
            end

            if processConfig["EventID"] ~= eventID then
                break
            end

            lastTimes = lastTimes + 1
        end
    end

    return lastTimes
end

function PKManager:SetIdleAction(cityRole, baseID, mixLevel)
    local pkRoleMain = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16)) or {}
    local roleID = pkRoleMain["RoleID"]
    local role = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleID) or {}
    local weaponID = role["Weapon"] or 0

    local aniName = nil
    if weaponID >= 0 then
        local itemData = TableDataManager:GetInstance():GetTableData("Item", weaponID)
        if itemData then
            aniName = ItemTypeToPrepareMap[itemData.ItemType]
        end
    end

    if aniName == nil then
        aniName = SPINE_ANIMATION.BATTLE_IDEL
    end

    local pkRoleUpgrade = GetTableData("PKRoleUpgrade", mixLevel) or {}
    local weaponUpgrade = pkRoleUpgrade["WeaponUpgrade"] or 0
    cityRole:SetActionWithWeapon(aniName, weaponID, weaponUpgrade, true)
end

function PKManager:CanShowSkip()
    local config = GetTableData("PKConfig", 1) or {}
    local forbidSelectLock = config["ForbidSelectLock"] == 1
    if forbidSelectLock then
        local playerData = PKManager:GetInstance():GetPlayerData()
        local refrehsTimes = (playerData["RefreshTimes"] or 0)

        if refrehsTimes > 0 then
            return false
        end

        local selectRoleList = playerData["SelectRoleList"]
        if selectRoleList == nil or selectRoleList[0] == nil then
            return false
        end

        for _, role in pairs(selectRoleList) do
            if role and role["dwBaseId"] > 0 then
                local baseID = role["dwBaseId"]
                local pkRole = GetTableData("PKRole", baseID) or {}
                if CardsUpgradeDataManager:GetInstance():IsRoleCardUnlock(pkRole["RoleID"] or 0) then
                    return false
                end
            end
        end

        return true
    end

    return false
end

-- TODO: 应该做成公共方法
function PKManager:GetTrueTime(serverTime)
    local diffTime = g_ServerTimeRecordTimeStamp - g_ServerTime
    return serverTime + diffTime
end

return PKManager
