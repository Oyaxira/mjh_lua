StorageDataManager = class("StorageDataManager")
StorageDataManager._instance = nil

function StorageDataManager:GetInstance()
    if StorageDataManager._instance == nil then
        StorageDataManager._instance = StorageDataManager.new()
        -- Test Code
        -- StorageDataManager._instance:MakeFakeData()
    end

    return StorageDataManager._instance
end

-- -- 测试代码, 伪造仓库数据
-- function StorageDataManager:MakeFakeData()
--     local template = {
--         ["uiTypeID"] = 0,
--         ["uiEnhanceGrade"] = 0,
--         ["uiItemNum"] = 1,
--         ["iAttrNum"] = 0,
--         ["uiCoinRecastTimes"] = 0,
--         ["auiAttrData"] = {},
--         ["uiID"] = 1,
--         ["uiCoinRecastUpper"] = 0,
--     }
--     -- 配置需要生成的静态id
--     local config = {
--         250601708,
--         1206,
--         1207,
--         250601709,
--         250601710,
--         250601501,
--         250601502,
--         250601606,
--         250601301,
--         250601711,
--         250601503,
--         250601712,
--         250601713,
--         250601714,
--         9666,
--         9667,
--         9668,
--         9669,
--         30561,
--         30562,
--         30572,
--         30571,
--         30711,
--         31629,
--         31331,
--         412102,
--         412103,
--         412202,
--         412302,
--         412401,
--         30531,
--         30541,
--         30551,
--         31321,
--         31332,
--         31333,
--         31341,
--         31342,
--         31351,
--         31361,
--         31371,
--     }
--     -- 开始生成
--     local iCurUid = 0
--     local akDatas = {}
--     local kDataClone = nil
--     for index, uiTypeID in ipairs(config) do
--         kDataClone = clone(template)
--         iCurUid = iCurUid + 1
--         kDataClone.uiID = iCurUid
--         kDataClone.uiTypeID = uiTypeID
--         kDataClone.uiItemNum = 2
--         akDatas[index - 1] = kDataClone
--     end
--     self:UpdateStorageItemsByArr(akDatas, #config)
-- end

-- 请求仓库数据
function StorageDataManager:RequestStorageData()
    local gameMode = globalDataPool:getData("GameMode")
    local bHasFullUpdate = self:GetFullUpdateFlag()
    if (gameMode == "ServerMode") and (bHasFullUpdate ~= true) then
        SendCheckStorageCMD()
    end
end

-- 更新仓库数据
function StorageDataManager:UpdateStorageItemsByArr(itemDataArray, arraySize, bIsFirstPush)
    if not (itemDataArray and next(itemDataArray) and arraySize) then 
        return
    end
    -- 设置一个标记， 表示有新的物品更新进仓库
    self.hasNewItemAdded = false
    local itemPool = self.itemPool or {}
    local itemPoolByTypeID = self.itemPoolByTypeID or {}
    local kTreasureBookTicketRec = self.kTreasureBookTicketRec or {}  -- 百宝书兑换券数量记录
    local kRenameCardRec = self.kRenameCardRec or {}  -- 取名卡数量记录
    local bDelete = false
    local kItemMgr = ItemDataManager:GetInstance()
    for i = 1, arraySize do 
        local itemData = itemDataArray[i - 1]
        itemData['InStorage'] = true  -- 添加一个标记, 表示该物品是存储在仓库中的
        -- 服务器约定： 如果下发物品的数量为0， 表示删除这个物品
        bDelete = (itemData.uiItemNum == 0)
        local uiID = itemData.uiID
        local uiTypeID = itemData.uiTypeID
        if bDelete then
            itemPool[uiID] = nil
            if itemPoolByTypeID[uiTypeID] then
                itemPoolByTypeID[uiTypeID][uiID] = nil
                if not next(itemPoolByTypeID[uiTypeID]) then
                    itemPoolByTypeID[uiTypeID] = nil
                end
            end
            kTreasureBookTicketRec[uiID] = nil
            kRenameCardRec[uiID] = nil
            kItemMgr:SetItemLockState(uiID, false)
        else
            itemPool[uiID] = itemData
            if not itemPoolByTypeID[uiTypeID] then
                itemPoolByTypeID[uiTypeID] = {}
            end
            itemPoolByTypeID[uiTypeID][uiID] = itemData
            if uiTypeID == 1603 then  -- 1603: 百宝书代金券
                kTreasureBookTicketRec[uiID] = (itemData.uiItemNum or 0)
            elseif uiTypeID == 1825 then  -- 1825: 改名卡
                kRenameCardRec[uiID] = (itemData.uiItemNum or 0)
            end
            self.hasNewItemAdded = true

            self:CheckRecordStoryEndItem(itemData.uiID)
        end
    end
    self.itemPool = itemPool
    self.itemPoolByTypeID = itemPoolByTypeID
    self.kTreasureBookTicketRec = kTreasureBookTicketRec
    self.kRenameCardRec = kRenameCardRec
    self:DispatchUpdateEvent()
    -- 获得仓库物品提示
    -- 弹珠界面需要延迟出提示, 所以不要这边弹
    -- if IsWindowOpen("PinballGameUI") ~= true then
    --     local kItemTypeData = nil
    --     if bIsFirstPush ~= true then
    --         for typeID, iNum in pairs(itemTypeID2Num) do
    --             kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",typeID)
    --             --失去物品不提示
    --             if iNum > 0 then
    --                 local strText = string.format("获得%sx%d, 已进入仓库", kItemTypeData.ItemName or '', iNum or 0);
    --                 SystemUICall:GetInstance():Toast(strText);
    --             elseif iNum < 0 then
    --                 local strText = string.format("失去%sx%d", kItemTypeData.ItemName or '', math.abs(iNum) or 0);
    --                 SystemUICall:GetInstance():Toast(strText);
    --             end
    --         end
    --     end
    -- end

    -- 检查是否需要提示完整版购买后的壕侠版百宝书开启提示
    if self.bTellUseTreasureBookTicket and next(self.kTreasureBookTicketRec) then
        self.bTellUseTreasureBookTicket = nil
        self:TellUseTreasureBookTicket()
    end
    -- 设置一个标记, 表示游戏已经进行过一次全量的仓库数据请求
    if bIsFirstPush == true then
        self.hasFullUpdated = true
    end
    -- 分析物品黑名单
    self:GenPlatItemBlackList()
end

-- 获取仓库中可用的百宝书代金券id
function StorageDataManager:GetkTreasureBookTicketUID()
    if not (self.kTreasureBookTicketRec and next(self.kTreasureBookTicketRec)) then
        return 0
    end
    local uiCanUseItemID = 0
    local uiSumCount = 0
    local uiMinNum = nil
    for uiItemID, uiNum in pairs(self.kTreasureBookTicketRec) do
        if (not uiMinNum) or (uiMinNum > uiNum) then
            uiMinNum = uiNum
            uiCanUseItemID = uiItemID
        end
        uiSumCount = uiSumCount + uiNum
    end
    return uiCanUseItemID, uiSumCount
end

-- 获取仓库中可用的改名卡的数量
function StorageDataManager:GetRenameCardNum()
    if not self.kRenameCardRec then
        return 0
    end
    local uiNum = 0
    for uid, num in pairs(self.kRenameCardRec) do
        uiNum = uiNum + num
    end
    return uiNum
end

-- 提示完整版购买后的壕侠版百宝书开启提示
function StorageDataManager:TellUseTreasureBookTicket()
    local uiTicketID, uiTicketNum = self:GetkTreasureBookTicketUID()
    if uiTicketNum and (uiTicketNum > 0) then
        local strMsg = string.format("您当前拥有%d张百宝书代金券, 是否消耗一张百宝书代金券免费激活本期壕侠版百宝书?", uiTicketNum)
        local callback = function()
            TreasureBookDataManager:GetInstance():CheckAndUseTreasureBookTicket(false)
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, callback})
    end
end

-- 刷新人物伪造属性（资产）
function StorageDataManager:RefreshPlayerAsset()
    if not self.itemPool then 
        self.itemPool = {} 
    end

    local itemPool = self.itemPool 
    -- 将自身属性伪装成物品，在仓库显示(-1开始，防止和真实物品冲突)
    local playerAssets = TableDataManager:GetInstance():GetTable('PlayerAsset') 
    for index, playerAsset in pairs(playerAssets) do
        local num = GetAssetValue(playerAsset.AssetType, playerAsset.AssetKey)
        -- 如果是资源掉落活动的资产值的话, 需要动态取到ItemID
        if (playerAsset.AssetType == 5) and (num > 0) then
            local iIndex = tonumber(playerAsset.AssetKey) or 0
            playerAsset.ItemID = ResDropActivityDataManager:GetInstance():GetResDropActivityFuncValueItemID(iIndex)
        elseif (playerAsset.AssetType == 6) and (num > 0) then
            local iIndex = tonumber(playerAsset.AssetKey) or 0
            playerAsset.ItemID = ActivityHelper:GetInstance():GetTreasureExchangeItemID(iIndex)
        end
        if playerAsset.ItemID then
            local uiID = - index
            if num > 0 then
                itemPool[uiID] = {}
                itemPool[uiID]["uiID"] = uiID
                itemPool[uiID]["uiTypeID"] = playerAsset.ItemID
                itemPool[uiID]["paging"] = playerAsset.PagingID
                itemPool[uiID]["uiItemNum"] = num
                if playerAsset.Window and playerAsset.Window ~= '' then
                    itemPool[uiID]["window"] = playerAsset.Window
                    itemPool[uiID]["windowPage"] = playerAsset.WindowPage
                end
            else
                itemPool[uiID] = nil
            end
        end
    end
end

-- 分析物品黑名单
function StorageDataManager:GenPlatItemBlackList()
    if not self.itemPool then
        return
    end
    local kCommonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
    if not (kCommonConfig and kCommonConfig.LimitNumMultiple and (kCommonConfig.LimitNumMultiple > 0)) then
        return
    end
    local uiLimitNumMultiple = kCommonConfig.LimitNumMultiple
    -- 如果一个物品BaseID对应的总数量超过了 物品携带上限 * 物品非法携带上限倍数, 那么将这个物品视为非法物品, 加入黑名单
    local itemBlackList = {}
    local itemSumBaseID2Num = {}
    local uiLegalLimit = 0
    local uiBaseID = nil
    local kItemTypeData = nil
    local kTBItem = TableDataManager:GetInstance():GetTable("Item")
    for uid, itemData in pairs(self.itemPool) do
        uiBaseID = itemData.uiTypeID
        kItemTypeData = kTBItem[uiBaseID]
        if kItemTypeData and kItemTypeData.LimitNum and (kItemTypeData.LimitNum > 0) then
            itemSumBaseID2Num[uiBaseID] = (itemSumBaseID2Num[uiBaseID] or 0) + (itemData.uiItemNum or 0)
            uiLegalLimit = uiLimitNumMultiple * kItemTypeData.LimitNum
            if itemSumBaseID2Num[uiBaseID] > uiLegalLimit then
                itemBlackList[uiBaseID] = true
            end
        end
    end
    self.itemBlackList = itemBlackList
    self.itemSumBaseID2Num = itemSumBaseID2Num
end

-- 判断一个物品是否非法
function StorageDataManager:IsFlatItemIllegal(uiBaseID)
    if not (uiBaseID and self.itemBlackList) then
        return false
    end
    return (self.itemBlackList[uiBaseID] == true), (self.itemSumBaseID2Num[uiBaseID] or 0)
end

-- 获取仓库内某个BaseID对应的物品总量
function StorageDataManager:GetBaseID2InstItemNum(uiBaseID)
    if not (self.itemSumBaseID2Num and uiBaseID) then
        return 0
    end
    return self.itemSumBaseID2Num[uiBaseID] or 0
end

-- 物品非法提示框
function StorageDataManager:IllegalItemCheckWithUID(aiUIDArry, bFromZero)
    if not (self.itemPool and aiUIDArry) then
        return false
    end
    local bPass = true
    local iStrat = bFromZero and 0 or 1
    local strReason = nil
    local kReason = {}
    local kReasonCheck = {}
    local uiBaseID = nil
    local kItemData = nil
    local kItemTypeData = nil
    local kTBItem = TableDataManager:GetInstance():GetTable("Item")
    local bIsIllegal, iIllegalNum = false, 0
    for index = iStrat, #aiUIDArry do
        kItemData = self.itemPool[aiUIDArry[index]]
        if kItemData and kItemData.uiTypeID and (kItemData.uiTypeID > 0) then
            uiBaseID = kItemData.uiTypeID
            bIsIllegal, iIllegalNum = self:IsFlatItemIllegal(uiBaseID)
            if (bIsIllegal == true) and (iIllegalNum > 0) and kTBItem[uiBaseID] then
                bPass = false
                kItemTypeData = kTBItem[uiBaseID]
                strReason = string.format("%sx%d", kItemTypeData.ItemName or '', iIllegalNum or 0)
                if kReasonCheck[strReason] ~= true then
                    kReasonCheck[strReason] = true
                    kReason[#kReason + 1] = strReason
                end
            end
        end
    end
    -- 合法物品, 通过
    if bPass then
        return false
    end
    -- 非法物品, 弹框提示
    SystemUICall:GetInstance():WarningBox("抱歉, 由于下列物品在仓库内总量异常, 您对异常物品的操作将不会产生任何效果, 如有疑问或误判, 请联系官方人员进行相关处理:　\n" .. table.concat(kReason, ","))
    return true
end

-- 获取标记: 仓库是否已经全量更新过
function StorageDataManager:GetFullUpdateFlag()
    return (self.hasFullUpdated == true)
end

-- 获取标记：仓库是是否更新了新的物品
function StorageDataManager:GetNewItemAddedFlag()
    return (self.hasNewItemAdded == true)
end

-- 通过动态id获取动态数据
function StorageDataManager:GetItemData(uiID)
    if not (self.itemPool and uiID) then
        return
    end
    return self.itemPool[uiID]
end

-- 通过动态id获取静态数据
function StorageDataManager:GetItemTypeData(uiID)
    if not (self.itemPool and uiID) then
        return
    end
    local itemData = self.itemPool[uiID]
    if not itemData then
        return
    end
    return self:GetItemTypeDataByTypeID(itemData.uiTypeID)
end

-- 通过静态id获取随机一个动态数据
function StorageDataManager:GetItemDataByTypeID(uiTypeID)
    if not (self.itemPoolByTypeID and uiTypeID) then
        return
    end
    local kInstItems = self.itemPoolByTypeID[uiTypeID] or {}
    for uiItemID, kItemInst in pairs(kInstItems) do
        return kItemInst
    end
    return nil
end

-- 通过静态id获取静态数据
function StorageDataManager:GetItemTypeDataByTypeID(uiTypeID)
    if not uiTypeID then
        return
    end

    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",uiTypeID);
    if not itemTypeData then
        derror("[StorageDataManager] itemTypeData is nil, typeid is " .. tostring(uiTypeID));
    end
    return itemTypeData;
end

-- 删除仓库动态数据
function StorageDataManager:DeleteItemData(uiID)
    if not (self.itemPool and self.itemPool[uiID]) then
        return
    end
    self.itemPool[uiID] = nil
    ItemDataManager:GetInstance():SetItemLockState(uiID, false)
    self:DispatchUpdateEvent()
end

-- 获取仓库物品的个数
function StorageDataManager:GetItemNum(uiID)
    if not uiID then
        return 0
    end
    local itemData = self:GetItemData(uiID)
    return itemData and itemData.uiItemNum or 0
end

-- 获取所有仓库物品
function StorageDataManager:GetAllItemDatas()
    return self.itemPool
end

-- 获取所有仓库物品数量
function StorageDataManager:GetAllItemNum()
    if not self.itemPool then
        return 0
    end

    local index = 0;
    for uiID, _ in pairs(self.itemPool) do
        if uiID > 0 then
            index = index + 1
        end
    end
    return index;
end

-- 获取所有仓库物品动态id
function StorageDataManager:GetAllItemUIDs()
    if not self.itemPool then
        return
    end
    local list = {}
    for uiID, data in pairs(self.itemPool) do
        list[#list + 1] = uiID
    end
    return list
end

-- 获取所有仓库物品动态数据
function StorageDataManager:GetAllInstItems()
    if not self.itemPool then
        return
    end
    local list = {}
    local TBItem = TableDataManager:GetInstance():GetTable("Item")
    for uiID, data in pairs(self.itemPool) do
        -- 过滤掉无效数据
        if TBItem[data.uiTypeID] then
            list[#list + 1] = data
        end
    end
    return list
end

-- 获取当前可带入的上限与本局游戏总上限
function StorageDataManager:GetStorageCarryLimit()
    local haveCarriedNum = 0
    local info = globalDataPool:getData("MainRoleInfo")
    if info and info["MainRole"] then
        haveCarriedNum = info["MainRole"][MRIT_SCRIPT_CARRY_ITEM_NUM] or 0
    end
    -- 带入上限的提升有很多种原因
    -- 难度变化带来的背包容量提升
    local strReason = ""
    local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()
    local kDiffData = StoryDataManager:GetInstance():GetStoryDifficultData(GetCurScriptID(), curDiff) or {}
    local carryLimit = kDiffData.StorageInItem or 0
    strReason = strReason .. string.format("难度%d +%d", curDiff, carryLimit)  -- 难度信息
    -- 壕侠奖励带来的提升
    if TreasureBookDataManager:GetInstance():GetTreasureBookVIPState() == true then
        local kMiscData = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
        local iNum = kMiscData.TreasureBookVIPBringInUP or 0
        if iNum > 0 then
            carryLimit = carryLimit + iNum
            strReason = strReason .. "\n壕侠 +" .. tostring(iNum)
        end
    end
    if PlayerSetDataManager:GetInstance():GetPlayerDilatationNum() > 0 then
        carryLimit = carryLimit + PlayerSetDataManager:GetInstance():GetPlayerDilatationNum();
    end
    --# TODO 钱程 周目奖励/成就点数奖励... 带来的上限提升
    -- 当前剩余可带入数量
    local remainCarryNum = carryLimit - haveCarriedNum
    return remainCarryNum, carryLimit, strReason
end

function StorageDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_STORAGE_ITEM")
end


function StorageDataManager:Clear()
    self.itemPool = {}
    self.itemPoolByTypeID = {}
    self.itemBlackList = {}
    self.itemSumBaseID2Num = {}
    self.kTreasureBookTicketRec = nil
    self.hasFullUpdated = false
end

-- 获取人物属性值
function GetAssetValue(type, key)
    if type == 1 then
        return PlayerSetDataManager:GetInstance()[key] or 0
    elseif type == 2 then
        return (TreasureBookDataManager:GetInstance():GetTreasureBookBaseInfo() or {}).iMoney or 0
    elseif type == 3 then
        return PinballDataManager:GetInstance():GetUserAllNormalHoodleNum() or 0
    elseif type == 4 then
        return MeridiansDataManager:GetInstance()[key] or 0
    elseif type == 5 then
        local iIndex = tonumber(key) or 0
        return PlayerSetDataManager:GetInstance():GetResDropActivityFuncValue(iIndex)
    elseif type == 6 then
        local iIndex = tonumber(key) or 0
        return PlayerSetDataManager:GetInstance():GetTreasureExchangeValue(iIndex)
    else
        return 0
    end
end

function FinishRecordStoryEndItems()
    local inst = StorageDataManager:GetInstance()

    if inst then
        inst.recordStoryEnd = false
    end
end
function StorageDataManager:StartRecordStoryEndItems()
    self.recordStoryEnd = true
    self.newStoryEnd = true
    self.storyEndItems = {}

    LuaEventDispatcher:addEventListener("QUIT_STORY_RET", FinishRecordStoryEndItems)
end
function StorageDataManager:CheckRecordStoryEndItem(itemid)
    if self.recordStoryEnd and itemid then
        self.storyEndItems[itemid] = true
    end
end
function StorageDataManager:GetRecordStoryEndItems()
    if self.newStoryEnd and next(self.storyEndItems) then
        return self.storyEndItems
    end

    return nil
end
function StorageDataManager:ClearRecordStoryEndItems()
    self.newStoryEnd = false
    self.recordStoryEnd = false

    LuaEventDispatcher:dispatchEvent("UPDATE_HOUSE_HOT_NAVIGATION")
end
