TreasureBookDataManager = class("TreasureBookDataManager")
TreasureBookDataManager._instance = nil

function TreasureBookDataManager:GetInstance()
    if TreasureBookDataManager._instance == nil then
        TreasureBookDataManager._instance = TreasureBookDataManager.new()
    end

    return TreasureBookDataManager._instance
end

-- 记录百宝书打开时间
function TreasureBookDataManager:TreasurebookOpenTimeRec()
    local iCurStamp = os.time()
    SetConfig("TreasureBookOpenTime", iCurStamp)
end

-- 百宝书打开时间检查
function TreasureBookDataManager:TreasurebookOpenTimeCheck()
    local iLastOpenTime = GetConfig("TreasureBookOpenTime")
    if (not iLastOpenTime) or (iLastOpenTime <= 0) then
        return false, false
    end
    local bNeedRequest = false -- 是否需要重新请求百宝书数据
    local bIsOverMonth = false  -- 是否是跨月
    local kCurTimetable = os.date("*t", os.time())
    local kLastTimetable = os.date("*t", iLastOpenTime)
    bNeedRequest = (kCurTimetable.year ~= kLastTimetable.year) or (kCurTimetable.month ~= kLastTimetable.month)
    bIsOverMonth = (kCurTimetable.year == kLastTimetable.year) and (kCurTimetable.month == kLastTimetable.month + 1)
    return kCurTimetable, bNeedRequest, bIsOverMonth
end

-- 申请激活百宝书
function TreasureBookDataManager:RequestActiveBookVIP()
    if not (self.kBookBaseInfo and self.kBookBaseInfo.iCurBookID) then
        return
    end
    if self.kBookBaseInfo.bRMBPlayer == true then
        SystemUICall:GetInstance():Toast("您已经开通过壕侠版百宝书, 请勿重复操作")
        return
    end
    local iCurBookID = self.kBookBaseInfo.iCurBookID
    local kBook = TableDataManager:GetInstance():GetTableData("TreasureBook",iCurBookID)
    if not (kBook and kBook.GoldCost and (kBook.GoldCost > 0)) then
        return
    end
    local iGoldCost = kBook.GoldCost
    local msg = string.format("是否花费%d金锭开通壕侠版百宝书?", iGoldCost)
    if kBook.BeginDate and kBook.EndDate then
        msg = msg .. string.format("\n\n本期百宝书持续时间为%d月%d日至%d月%d日。购买后可立即获得已解锁等级的所有壕侠奖励。"
        , kBook.BeginDate.Month or 0, kBook.BeginDate.Day or 0, kBook.EndDate.Month or 0, kBook.EndDate.Day or 0)
    end
    local kInfo = {}
    kInfo.bForSelf = true
    kInfo.content = msg
    kInfo.callback = function()
        PlayerSetDataManager:GetInstance():RequestSpendGold(iGoldCost, function()
            SendQueryTreasureBookInfo(STBQT_BRMB)
        end)
    end
    OpenWindowImmediately('TreasureBookWarningBoxUI', kInfo)
end

-- 请求百宝书基础数据
function TreasureBookDataManager:RequestTreasureBookBaseInfo(funcCallBack)
    SendQueryTreasureBookInfo(STBQT_BASE)
    self.reqBookBaseInfoCallBack = funcCallBack
end

-- 更新百宝书基础数据
function TreasureBookDataManager:UpdateTreasureBookBaseInfo(kData)
    if not kData then
        return
    end
    local newInfo  = {
        ['iLevel'] = kData.dwLvl or 1,
        ['iExp'] = kData.dwExp or 0,
        ['iMoney'] = kData.dwMoney or 0,
        ['iCurBookID'] = kData.dwCurPeriods or 1,
        ['iCurRound'] = kData.dwCurPeriodsWeek or 1,
        ['bRMBPlayer'] = (kData.bRMBPlayer == 1),
        ['bDayGiftGot'] = (kData.bEachDayGift == 1),
        ['bWeekGiftGot'] = (kData.bEachWeekGift == 1),
        ['iServerProgressHeroFlag'] = kData.dwProgressRewardFlag or 0,
        ['iServerProgressRmbFlag'] = kData.dwRMBProgressRewardFlag or 0,
        ['iLvlRewardFlag1'] = kData.dwLvlRewardFlag1 or 0,
        ['iLvlRewardFlag2'] = kData.dwLvlRewardFlag2 or 0,
        ['iRMBLvlRewardFlag1'] = kData.dwRMBLvlRewardFlag1 or 0,
        ['iRMBLvlRewardFlag2'] = kData.dwRMBLvlRewardFlag2 or 0,
        ['bOpenDialyGift'] = (kData.bOpenDailyGift == 1),
        ['iDialyGiftNum'] = kData.dwCurMaxGetDailySilverNum or 0,
        ['iExtraHeroSlot'] = kData.dwHeroCanGetExtraRewardTaskNum or 0,
        ['iExtraRmbSlot'] = kData.dwRMBCanGetExtraRewardTaskNum or 0,
        ['bAdvancePurchase'] = (kData.bAdvancePurchase == 1),
        ['bOpenRepeatTask'] = (kData.bOpenRepeatTask == 1),
        ['iGivedFriendAdvanceNum'] = kData.dwGivedFriendAdvanceNum or 0,
        ['iPurchaseBookEndTime'] = kData.dwPurchaseBookEndTime or 0,
        ['iExtraGetRewardLvl'] = kData.dwExtraGetRewardLvl or 0,
    }
    -- 设置百宝书信息
    self:SetTreasureBookBaseInfo(newInfo)
    -- 执行其它回调
    if self.reqBookBaseInfoCallBack then
        self.reqBookBaseInfoCallBack()
        self.reqBookBaseInfoCallBack = nil
    end

    -- 刷新包裹
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

-- 设置百宝书基础信息
function TreasureBookDataManager:SetTreasureBookBaseInfo(info, bRefreshUI)
    self.kBookBaseInfo = info
    if bRefreshUI == false then
        return
    end
    -- 更新界面
    local win = GetUIWindow("TreasureBookUI")
    if win then 
        local curSubView = win.curSubView
        if curSubView == win.PageType.Reward then
            win.TreasureBookRewardUIInst:UpdateTreasureBookBaseInfo()
        elseif curSubView == win.PageType.Server then
            win.TreasureBookServerRewardUIInst:UpdateTreasureBookProgress()
        elseif curSubView == win.PageType.Task then
            win.TreasureBookTaskUIInst:CheckTaskProgressData()
        elseif curSubView == win.PageType.Store then
            win.TreasureBookStoreUIInst:CheckStoreInfo()
        end
    end
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then 
        windowBarUI:UpdateWindow()
    end
    win = GetUIWindow("NavigationUI")
    if win then 
        win:RefreshTreasureBookRedPoint()
    end
end

-- 更新百宝书壕侠标记
function TreasureBookDataManager:UpdateTreasureBookVIPState(bRes)
    if not self.kBookBaseInfo then
        return
    end
    self.kBookBaseInfo['bRMBPlayer'] = (bRes == true)
    -- 更新界面
    local win = GetUIWindow("TreasureBookUI")
    if not win then return end
    if win.curSubView == win.PageType.Reward then
        win.TreasureBookRewardUIInst:UpdateTreasureBookBaseInfo()
    elseif win.curSubView == win.PageType.Server then
        win.TreasureBookServerRewardUIInst:UpdateTreasureBookProgress()
    elseif win.curSubView == win.PageType.Task then
        win.TreasureBookTaskUIInst:CheckTaskProgressData()
    elseif win.curSubView == win.PageType.Store then
        win.TreasureBookStoreUIInst:CheckStoreInfo()
    end
end

-- 更新百宝书壕侠到期时间戳
function TreasureBookDataManager:UpdateTreasureBookVIPEndTimeStamp(uiTimeStamp)
    if not (self.kBookBaseInfo and uiTimeStamp) then
        return
    end
    self.kBookBaseInfo['iPurchaseBookEndTime'] = uiTimeStamp
end

-- 获取百宝书壕侠标记
function TreasureBookDataManager:GetTreasureBookVIPState()
    if not self.kBookBaseInfo then
        return false
    end
    return (self.kBookBaseInfo['bRMBPlayer'] == true)
end

-- 更新百宝书个人等级奖励领取标记
function TreasureBookDataManager:UpdateTreasureBookRewardFlag(iHeroFlag1, iHeroFlag2, iRmbFlag1, iRmbFlag2)
    if not self.kBookBaseInfo then
        return
    end
    self.kBookBaseInfo['iLvlRewardFlag1'] = iHeroFlag1 or 0
    self.kBookBaseInfo['iLvlRewardFlag2'] = iHeroFlag2 or 0
    self.kBookBaseInfo['iRMBLvlRewardFlag1'] = iRmbFlag1 or 0
    self.kBookBaseInfo['iRMBLvlRewardFlag2'] = iRmbFlag2 or 0
    -- 更新界面
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Reward) then
        win.TreasureBookRewardUIInst:UpdateTreasureBookBaseInfo()
    end
end

-- 更新百宝书全服等级奖励领取标记
function TreasureBookDataManager:UpdateTreasureBookServerProgressFlag(iHeroFlag, iRmbFlag)
    self.kBookBaseInfo = self.kBookBaseInfo or {}
    self.kBookBaseInfo['iServerProgressHeroFlag'] = iHeroFlag
    self.kBookBaseInfo['iServerProgressRmbFlag'] = iRmbFlag
    -- 刷新全服奖励界面
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Server) then
        win.TreasureBookServerRewardUIInst:UpdateRewardList()
    end
end

-- 更新百宝书额外奖励领取等级
function TreasureBookDataManager:UpdateTreasureBookExtraGetRewardLvl(uiNewLevel)
    if not (self.kBookBaseInfo and uiNewLevel) then
        return
    end
    self.kBookBaseInfo['iExtraGetRewardLvl'] = uiNewLevel
    -- 更新界面
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Reward) then
        win.TreasureBookRewardUIInst:UpdateTreasureBookBaseInfo()
    end
end

-- 购买经验成功后, 增加相应额度的经验
function TreasureBookDataManager:AddBoughtExp()
    if not self.kBookBaseInfo then
        return
    end
    local iBookID = self.kBookBaseInfo.iCurBookID
    local kBook = TableDataManager:GetInstance():GetTableData("TreasureBook",iBookID)
    if not (iBookID and kBook) then
        return
    end
    
    self.kBookBaseInfo.iExp = self.kBookBaseInfo.iExp + (kBook.BuyExpDeltaValue or 0)
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Reward) then
        win.TreasureBookRewardUIInst:UpdateTreasureBookLevel()
    end
end

-- 获取百宝书基础数据
function TreasureBookDataManager:GetTreasureBookBaseInfo()
    -- 测试代码, 单机下返回假数据
    local strMode = globalDataPool:getData("GameMode")
    if (not strMode) or (strMode == "SingleMode") then
        return {
            ['iLevel'] = 1,
            ['iExp'] = 0,
            ['iMoney'] = 40,
            ['iCurBookID'] = 2,
            ['iCurRound'] = 3,
            ['bRMBPlayer'] = false,
            ['bDayGiftGot'] = false,
            ['bWeekGiftGot'] = false,
            ['iServerProgressHeroFlag'] = 0,
            ['iServerProgressRmbFlag'] = 0,
            ['iLvlRewardFlag1'] = 0,
            ['iLvlRewardFlag2'] =  0,
            ['iRMBLvlRewardFlag1'] = 0,
            ['iRMBLvlRewardFlag2'] = 0,
            ['bOpenDialyGift'] = false,
            ['iDialyGiftNum'] = 0,
            ['iExtraHeroSlot'] = 1,
            ['iExtraRmbSlot'] = 1,
            ['bAdvancePurchase'] = false,
            ['bOpenRepeatTask'] = true,
        }
    end

    return self.kBookBaseInfo
end

-- 请求百宝书全服等级进度信息
function TreasureBookDataManager:RequestTreasureBookServerProgressData(funcCallBack)
    SendQueryTreasureBookInfo(STBQT_RECHARGE_PROGRESS)
    self.reqBookServerProgressDataCallBack = funcCallBack
end

-- 更新百宝书全服等级进度信息
function TreasureBookDataManager:UpdateTreasureBookServerProgressData(kRetData)
    self.kBookServerProgressData = {}
    local aiProgressData = kRetData.dwProgress or {}
    local iDay = kRetData.iNum and (kRetData.iNum - 1) or 0
    self.kBookServerProgressData['iSumLevel'] = aiProgressData[iDay] or 0
    -- 记录一下当前的百宝书id
    local kBaseInfo = self:GetTreasureBookBaseInfo() or {}
    self.kBookServerProgressData['iCurBookID'] = kBaseInfo.iCurBookID or 0
    -- 更新全服等级进度界面
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Server) then
        win.TreasureBookServerRewardUIInst:CheckBookProgressRewardFlag()
    end
    -- 执行回调
    if self.reqBookServerProgressDataCallBack then
        self.reqBookServerProgressDataCallBack()
        self.reqBookServerProgressDataCallBack = nil
    end
end

-- 获取百宝书全服等级进度信息
function TreasureBookDataManager:GetTreasureBookServerProgressData()
    -- 测试代码, 单机下返回假数据
    local strMode = globalDataPool:getData("GameMode")
    if (not strMode) or (strMode == "SingleMode") then
        return {
            ['iSumLevel'] = 3000,
        }
    end

    -- 如果当前百宝书id已经和缓存的数据不一样了, 那么清除缓存数据
    local kBaseInfo = self:GetTreasureBookBaseInfo() or {}
    local iCurBookID = kBaseInfo.iCurBookID or 0
    if self.kBookServerProgressData and (self.kBookServerProgressData.iCurBookID ~= iCurBookID) then
        self.kBookServerProgressData = nil
        return
    end

    return self.kBookServerProgressData
end

-- 请求任务进度数据
function TreasureBookDataManager:RequestTaskProgressData()
    SendQueryTreasureBookInfo(STBQT_TASK)
end

-- 更新百宝书任务进度数据
function TreasureBookDataManager:UpdateTaskProgressData(kData)
    if not (kData and kData.akTask and kData.iNum) then
        return
    end
    local taskID2Progress = self.taskID2Progress or {}
    local akTasks = kData.akTask
    local kTask = nil
    for index = 0, kData.iNum - 1 do
        kTask = akTasks[index]
        if kTask then
            taskID2Progress[kTask.dwTaskTypeID] = {
                ['iProgress'] = kTask.dwProgress or 0,
                ['iRepeatTimes'] = kTask.dwRepeatFinishNum or 0,
                ['bReward'] = (kTask.bReward == 1),
            }
        end
    end
    self.taskID2Progress = taskID2Progress
    -- 记录一下百宝书id
    local kBaseInfo = self:GetTreasureBookBaseInfo() or {}
    self.taskID2Progress['iCurBookID'] = kBaseInfo.iCurBookID or 0
    -- 更新界面
    local win = GetUIWindow("TreasureBookUI")
    if (not win) or (win.curSubView ~= win.PageType.Task) then
        return
    end
    local taskUI = win.TreasureBookTaskUIInst
    -- 如果只有一条数据, 那么只需要更新单个任务ui
    if kData.iNum == 1 then
        local iTaskID = kTask.dwTaskTypeID
        taskUI:UpdateSingleTaskUIProgessData(iTaskID, taskID2Progress[iTaskID])
    else
        taskUI:InitTaskData()
    end
end

-- 更新单条任务的数据
function TreasureBookDataManager:UpdateSingleTaskData(iTaskID, iProgress)
    if not (iTaskID and iProgress) then
        return
    end
    if not self.taskID2Progress then
        self.taskID2Progress = {}
    end
    local kTask = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
    local iTargetProgress = kTask.TargetProgress or 0
    if not self.taskID2Progress[iTaskID] then
        self.taskID2Progress[iTaskID] = {
            ['iProgress'] = iProgress,
            ['iRepeatTimes'] = 0,
            ['bReward'] = (iProgress >= iTargetProgress),
        }
    else
        self.taskID2Progress[iTaskID].iProgress = iProgress
        local bFull = (iProgress >= iTargetProgress)
        if bFull then
            self.taskID2Progress[iTaskID].iRepeatTimes = (self.taskID2Progress[iTaskID].iRepeatTimes or 0) + 1
        end
        self.taskID2Progress[iTaskID].bReward = bFull
    end
    -- 更新界面
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Task) then
        win.TreasureBookTaskUIInst:InitTaskData()
    end
end

-- 获取任务进度数据
function TreasureBookDataManager:GetTaskProgressData()
    -- 测试代码, 单机下返回假数据
    local strMode = globalDataPool:getData("GameMode")
    if (not strMode) or (strMode == "SingleMode") then
        return setmetatable({}, {__index = function(tab, key)
            return {
                ['iProgress'] = 0,
                ['iRepeatTimes'] = 0,
                ['bReward'] = false,
            }
        end})
    end

    -- 如果当前百宝书id已经和缓存的数据不一样了, 那么清除缓存数据
    local kBaseInfo = self:GetTreasureBookBaseInfo() or {}
    local iCurBookID = kBaseInfo.iCurBookID or 0
    if self.taskID2Progress and (self.taskID2Progress.iCurBookID ~= iCurBookID) then
        self.taskID2Progress = nil
        return
    end

    return self.taskID2Progress
end

-- 请求百宝书兑换商店数据
function TreasureBookDataManager:RequestTreasureBookStoreData()
    SendQueryTreasureBookInfo(STBQT_MALL)
end

-- 更新百宝书兑换商店数据
function TreasureBookDataManager:UpdateTreasureBookStoreData(kData)
    if not (kData and kData.akMall and kData.iNum) then
        return
    end
    if kData.iNum > 0 then
        local id2info = self.mallItemID2StoreInfo or {}
        local infos = kData.akMall
        local info = nil
        for index = 0, kData.iNum - 1 do
            info = infos[index]
            id2info[info.dwItemTypeID] = info.dwExchangedNum or 0
        end
        self.mallItemID2StoreInfo = id2info
        -- 记录一下百宝书id
        local kBaseInfo = self:GetTreasureBookBaseInfo() or {}
        self.mallItemID2StoreInfo['iCurBookID'] = kBaseInfo.iCurBookID or 0
    end
    -- 更新界面
    local win = GetUIWindow("TreasureBookUI")
    if win and (win.curSubView == win.PageType.Store) then
        win.TreasureBookStoreUIInst:UpdateItemList()
    end
end

-- 获取百宝书兑换商店数据
function TreasureBookDataManager:GetTreasureBookStoreData()
    -- 测试代码, 单机下返回假数据
    local strMode = globalDataPool:getData("GameMode")
    if (not strMode) or (strMode == "SingleMode") then
        return {}
    end

    -- 如果当前百宝书id已经和缓存的数据不一样了, 那么清除缓存数据
    local kBaseInfo = self:GetTreasureBookBaseInfo() or {}
    local iCurBookID = kBaseInfo.iCurBookID or 0
    if self.mallItemID2StoreInfo and (self.mallItemID2StoreInfo.iCurBookID ~= iCurBookID) then
        self.mallItemID2StoreInfo = nil
        return
    end

    return self.mallItemID2StoreInfo
end

-- 分析百宝书的所有奖励
function TreasureBookDataManager:GenBookAllRewards(kTreasureBook)
    if not kTreasureBook then
        return
    end
    -- 再次访问时直接返回上次缓存的结果
    local iBookID = kTreasureBook.BaseID
    self.kBookRewardsCache = self.kBookRewardsCache or {}
    if self.kBookRewardsCache[iBookID] then
        return self.kBookRewardsCache[iBookID]
    end

    -- 这个用来保存一份哪些物品是自动使用的数据
    local autoUseItem = {}
    self.kBookAutoUseItemList = self.kBookAutoUseItemList or {}

    local ret = {
        ['Hero'] = {},
        ['VIP'] = {}
    }

    local iMaxlLevel = 0
    local parseSingleData = function(kData)
        if not kData then
            return
        end
        local iLevel = kData.Level
        if not iLevel then
            return
        end
        if iLevel > iMaxlLevel then
            iMaxlLevel = iLevel
        end
        -- 英雄奖励
        local heroReward = {}
        local index = 1
        local autoUseIndex = 1
        local id = kData["HeroItemID1"]
        local num = kData["HeroItemAmount1"]
        local bAutoUse = kData["AutoUse1"]
        local bMoneyItemID = 9660  -- 百宝书残页的物品id
        while (id and num and (id > 0) and (num > 0)) do
            heroReward[#heroReward + 1] =     {
                ['itemTypeID'] = id,
                ['itemNum'] = num,
            }
            if (bAutoUse == TBoolean.BOOL_YES) or (bMoneyItemID == id) then
                autoUseItem[id] = true
            end
            index = index + 1
            autoUseIndex = autoUseIndex + 1
            id = kData["HeroItemID" .. index]
            num = kData["HeroItemAmount" .. index]
            bAutoUse = kData["AutoUse" .. autoUseIndex]
        end
        ret['Hero'][iLevel] = heroReward
        -- 壕侠奖励
        local vipReward = {}
        index = 1
        id = kData["RichmanItemID1"]
        num = kData["RIchmanItemAmount1"]
        while (id and num and (id > 0) and (num > 0)) do
            vipReward[#vipReward + 1] =     {
                ['itemTypeID'] = id,
                ['itemNum'] = num,
            }
            if (bAutoUse == TBoolean.BOOL_YES) or (bMoneyItemID == id) then
                autoUseItem[id] = true
            end
            index = index + 1
            autoUseIndex = autoUseIndex + 1
            id = kData["RichmanItemID" .. index]
            num = kData["RIchmanItemAmount" .. index]
            bAutoUse = kData["AutoUse" .. autoUseIndex]
        end
        ret['VIP'][iLevel] = vipReward
    end

    local tbData = TableDataManager:GetInstance():GetTable("TreasureBookLevelReward")
    for _, data in pairs(tbData) do
        if data.Phase == iBookID then
            parseSingleData(data)
        end
    end

    ret['iMaxlLevel'] = iMaxlLevel
    ret['iBookID'] = iBookID
    -- 从1级到最大等级吗检查是否有空数据
    for index = 1, iMaxlLevel do
        if not ret['Hero'][index] then
            ret['Hero'][index] = {}
        end
        if not ret['VIP'][index] then
            ret['VIP'][index] = {}
        end
    end

    self.kBookRewardsCache[iBookID] = ret
    self.kBookAutoUseItemList[iBookID] = autoUseItem

    return ret
end

-- 获取百宝书当前自动使用的物品
function TreasureBookDataManager:GetCurBookAutoUseItemList()
    local kBaseInfo = self:GetTreasureBookBaseInfo()
    if not (self.kBookAutoUseItemList and kBaseInfo and kBaseInfo.iCurBookID) then
        return
    end
    return self.kBookAutoUseItemList[kBaseInfo.iCurBookID]
end

-- 百宝书个人等级奖励是否已领取
function TreasureBookDataManager:IsBookRewardGot(kBookData, iLevel, bIsRmbReward)
    if not (kBookData and iLevel and (iLevel > 0)) then
        return false
    end
    local kBaseInfo = self:GetTreasureBookBaseInfo()
    if not kBaseInfo then
        return false
    end
    local allRewards = self:GenBookAllRewards(kBookData)
    if not allRewards then
        return false
    end
    -- 空值处理
    local iLvlRewardFlag1 = kBaseInfo.iLvlRewardFlag1 or 0
    local iLvlRewardFlag2 = kBaseInfo.iLvlRewardFlag2 or 0
    local iRMBLvlRewardFlag1 = kBaseInfo.iRMBLvlRewardFlag1 or 0
    local iRMBLvlRewardFlag2 = kBaseInfo.iRMBLvlRewardFlag2 or 0
    bIsRmbReward = (bIsRmbReward == true)
    -- 英雄奖励/壕侠奖励分别使用两个Uint64来记录, 记录段为 1位~63位 + 0位~63位 (63个+64个)
    local iMaxSlot = 63
    local iFlag = 0
    local iOffset = iLevel
    -- 如果某一档是没有奖励的, 直接返回已完成
    if (bIsRmbReward and (#(allRewards['VIP'][iLevel] or {}) == 0))
    or ((not bIsRmbReward) and (#(allRewards['Hero'][iLevel] or {}) == 0)) then
        return true
    end
    if iLevel <= iMaxSlot then
        -- 1~63
        iFlag = bIsRmbReward and iRMBLvlRewardFlag1 or iLvlRewardFlag1
        return (iFlag & (1 << iOffset)) ~= 0
    else
        -- 0~63
        iOffset = iOffset - iMaxSlot
        iFlag = bIsRmbReward and iRMBLvlRewardFlag2 or iLvlRewardFlag2
        return (iFlag & (1 << (iOffset - 1))) ~= 0
    end
    return false
end

-- 检查是否存在可领取的百宝书奖励
function TreasureBookDataManager:IfHaveReward2Get()
    local info = self:GetTreasureBookBaseInfo()
    if not info then 
        return false
    end
    local kTreasureBook = TableDataManager:GetInstance():GetTableData("TreasureBook",info.iCurBookID)
    if not kTreasureBook then
        return false
    end
    local rewards = self:GenBookAllRewards(kTreasureBook)
    if not (rewards and rewards.iMaxlLevel) then
        return false
    end
    local iCurLevel = info.iLevel or 0
    local iMaxlLevel = math.min(iCurLevel, rewards.iMaxlLevel)
    local bIsVip = info.bRMBPlayer == true
    local bHeroCanGet, bVipCanGet = false, false
    for iLevel = 1, iMaxlLevel do
        bHeroCanGet = self:IsBookRewardGot(kTreasureBook, iLevel, false) ~= true
        bVipCanGet = bIsVip and (self:IsBookRewardGot(kTreasureBook, iLevel, true) ~= true)
        if bHeroCanGet or bVipCanGet then
            return true
        end
    end
    return false
end

-- 百宝书全服等级奖励是否已经领取(分英雄和壕侠查询)
function TreasureBookDataManager:IsBookServerRewardGot(iLevel, bIsRmbReward, bWithIdentityCheck)
    local info = self:GetTreasureBookBaseInfo()
    if not info then
        return false
    end
    bIsRmbReward = (bIsRmbReward == true)
    bWithIdentityCheck = (bWithIdentityCheck == true)

    -- 如果带身份检测, 那么没有开通壕侠时, 壕侠奖励当做已领取
    if bWithIdentityCheck and (info.bRMBPlayer ~= true) then
        return true
    end

    -- 英雄奖励是否已经领取
    if not bIsRmbReward then
        local iFlag = info.iServerProgressHeroFlag or 0
        local bHeroGot = (iFlag & (1 << iLevel)) ~= 0
        return bHeroGot
    end
    
    -- 壕侠奖励是否已经领取
    local iFlag = info.iServerProgressRmbFlag or 0
    local bRmbGot = (iFlag & (1 << iLevel)) ~= 0
    return bRmbGot
end

-- 检查是否存在可领取的百宝书全服奖励
function TreasureBookDataManager:IfHaveServerReward2Get()
    local info = self:GetTreasureBookServerProgressData()
    if not (info and info.iSumLevel) then 
        return false
    end
    local iCurSumLevel = info.iSumLevel or 0
    local bRewardCanGet = false
    local bHeroRewardGot = false
    local bRmbRewardGot = false
    local TB_TreasureBookGlobal = TableDataManager:GetInstance():GetTable("TreasureBookGlobal")
    for index, data in ipairs(TB_TreasureBookGlobal) do
        bRewardCanGet = iCurSumLevel >= (data.NeedNum or 0)
        bHeroRewardGot = self:IsBookServerRewardGot(index, false)
        bRmbRewardGot = self:IsBookServerRewardGot(index, true, true)
        if bRewardCanGet and ((not bHeroRewardGot) or (not bRmbRewardGot)) then
            return true
        end
    end
    return false
end

-- 经验转化为等级
function TreasureBookDataManager:Exp2Level(iExp)
    iExp = iExp or 0
    local TB_TreasureBookLV = TableDataManager:GetInstance():GetTable("TreasureBookLV")
    local iMaxLevel = #TB_TreasureBookLV
    local kData = nil
    for ilevel = 2, iMaxLevel do
        kData = TB_TreasureBookLV[ilevel]
        if kData.EXP > iExp then
            return ilevel - 1
        end
    end
    return iMaxLevel
end

-- 检查是否存在百宝书满赠活动
function TreasureBookDataManager:CheckHasTreasureBookBuyGiftActivity()
    local kActivityMgr = ActivityHelper:GetInstance()
    if not kActivityMgr then
        return false
    end
    local akShowActivityData = kActivityMgr:GetShowActivity()
    if (not akShowActivityData) or (#akShowActivityData == 0) then
        return false
    end
    local kTarActicity = nil
    for index, kActivity in ipairs(akShowActivityData) do
        if kActivity.Type == ActivityType.ACCT_TreasureBookBuyGift then
            kTarActicity = kActivity
            break
        end
    end
    if not kTarActicity then
        return false
    end
    -- 找到了活动, 需要继续检查用户有没有购买该活动的最高档次
    -- 如果用户已经参与了最高档次, 也不需要继续处理活动相关的内容
    -- 检查活动最高档的商品, 暂时指定为第二个参数, 之后活动需要修改
    local uiBestMallItemBaseID = kTarActicity.Param2 or 0
    if uiBestMallItemBaseID == 0 then
        return false
    end
    local kBestMallInstItem = ShoppingDataManager:GetInstance():GetShopDataBy(uiBestMallItemBaseID)
    if not kBestMallInstItem then
        return false
    end
    -- 如果玩家已经购买了最高档, 那么跳过该广告
    if kBestMallInstItem.iCanBuyCount == 0 then
        return false
    end
    return true, kTarActicity
end

-- 用户准备购买百宝书时, 如果有百宝书满赠活动, 弹框引导跳转到活动
-- 需要提供用户不选择跳转活动时的回调
function TreasureBookDataManager:TryToBuyVIPForSelf(funcDontChooseActivity)
    -- 先检查此时有没有百宝书满赠的活动正在开启
    local bHasBuyGiftActivity, kTarActicity = self:CheckHasTreasureBookBuyGiftActivity()
    -- 如果有满赠活动, 那么弹出提示框, 提醒用户前往活动
    if bHasBuyGiftActivity and kTarActicity
    and (kTarActicity.Type == ActivityType.ACCT_TreasureBookBuyGift) then
        local kContent = {}
        kContent["title"] = "活动提示"
        kContent["text"] = "现在有更划算的壕侠买二赠一，买三赠九活动，是否跳转？"
        kContent["rightBtnText"] = "去看看"
        kContent["leftBtnText"] = "只买1个月"
        local funcGoto = function()
            OpenWindowImmediately("ActivityUI", {["type"] = ActivityType.ACCT_TreasureBookBuyGift})
            local win = GetUIWindow("TreasureBookEarlyBuyUI")
            if win then
                RemoveWindowImmediately("TreasureBookEarlyBuyUI")
            end
        end
        kContent["leftBtnFunc"] = funcDontChooseActivity
        local kBtnSets = {
            ['confirm'] = true,
            ['cancel'] = true,
            ['close'] = false,
        }
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, kContent, funcGoto, kBtnSets})
        return
    end
    -- 没有活动的情况下, 直接执行为自己开通壕侠的逻辑
    if funcDontChooseActivity then
        funcDontChooseActivity()
    end
end

-- 检查百宝书活动广告
function TreasureBookDataManager:CheckTreasureBookActivityAD()
    -- 当前是否有百宝书相关的活动开启
    local bHasBuyGiftActivity, kTarActicity = self:CheckHasTreasureBookBuyGiftActivity()
    if (not bHasBuyGiftActivity) or (not kTarActicity) then
        return false
    end
    OpenWindowImmediately("TreasureBookActivityAdUI")
    -- 现在百宝书活动广告改为每次都弹, 第二个参数用于广告不弹的时候告诉下文直接弹出百宝书, 这里直接返回false
    return true, false
end

-- 检查百宝书开屏广告
function TreasureBookDataManager:CheckTreasureBookAD()
    -- 检查百宝书基础信息
    local info = self:GetTreasureBookBaseInfo()
    if not info then
        self:RequestTreasureBookBaseInfo(function()
            self:CheckTreasureBookAD()
        end)
        return
    end
    -- 百宝书有的时候会有活动宣传(如 百宝书满赠活动)
    -- 这种活动广告优先级是高于百宝书自己的广告的
    -- 是要在当前时间段有百宝书相关活动广告, 直接跳过百宝书自己的广告判断流程
    local bHasActivityAD, bJustOpenTreasureBook = self:CheckTreasureBookActivityAD()
    if bHasActivityAD then
        if bJustOpenTreasureBook then
            OpenWindowImmediately("TreasureBookUI")
        end
        return
    end
    -- 如果已经在广告界面和百宝书界面, 那么跳出
    if IsWindowOpen("TreasureBookUI")
    or IsWindowOpen("TreasureBookAdUI") then
        return
    end
    -- 壕侠玩家, 没有任何广告, x下一步检查预购信息
    if info.bRMBPlayer == true then
        self:CheckTreasureBookEarlyBuy()
        return
    end
    -- 检查百宝书数据
    local kTreasureBook = TableDataManager:GetInstance():GetTableData("TreasureBook",info.iCurBookID)
    if not kTreasureBook then
        return
    end
    local iMaxRound = #(kTreasureBook.TreasureBookTaskIDs or {})
    local iCurRound = info.iCurRound or 1
    local timetable = os.date("*t", os.time())
    -- 非壕侠玩家, 若没有勾选今日不显示, 则显示普通广告或月末崔氪广告
    local strStyle = (iCurRound == iMaxRound) and "MonthEnd" or "Normal"
    local key = "TreasureBookDialyAD"
    local value = string.format("%d-%d-%d", timetable.year, timetable.month, timetable.day)
    local bShowAD = GetConfig(key) ~= value
    if bShowAD then
        OpenWindowImmediately("TreasureBookAdUI", {["style"] = strStyle})
    else
        self:CheckTreasureBookEarlyBuy()
    end
end

-- 检查百宝书月末预购
function TreasureBookDataManager:CheckTreasureBookEarlyBuy()
    -- TIPS 2020/9/17 钱程 现在预购和好友赠送在百宝书里面做了常驻入口
    -- 所以月末检查弹预购广告这一步就不要了, 为了防止之后有需要, 这里直接注释函数体, 打开百宝书并跳过
    OpenWindowImmediately("TreasureBookUI")
    do return end
    -- -- 检查百宝书基础信息
    -- local info = self:GetTreasureBookBaseInfo()
    -- if not info then
    --     self:RequestTreasureBookBaseInfo(function()
    --         self:CheckTreasureBookEarlyBuy()
    --     end)
    --     return
    -- end
    -- -- *Tips 就算已经预购, 也还是要显示预购信息的, 只不过给自己预购的按钮显示为已预购, 但是可以给好友继续预购
    -- -- 首先判断玩家是否已经预购, 已经预购的就直接进入百宝书
    -- -- if info.bAdvancePurchase == true then
    -- --     OpenWindowImmediately("TreasureBookUI")
    -- --     return
    -- -- end
    -- -- 判断玩家是不是壕侠, 如果不是壕侠, 那就没有接下来的预购流程
    -- if info.bRMBPlayer ~= true then
    --     OpenWindowImmediately("TreasureBookUI")
    --     return
    -- end
    -- -- 预购只在最后一期出现
    -- local kTreasureBook = TableDataManager:GetInstance():GetTableData("TreasureBook",info.iCurBookID)
    -- if not kTreasureBook then
    --     return
    -- end
    -- local iMaxRound = #(kTreasureBook.TreasureBookTaskIDs or {})
    -- local iCurRound = info.iCurRound or 1
    -- if iMaxRound ~= iCurRound then
    --     OpenWindowImmediately("TreasureBookUI")
    --     return
    -- end
    -- -- 如果玩家勾选了今日不再出现, 则直接进入百宝书
    -- local timetable = os.date("*t", os.time())
    -- local value = string.format("%d-%d-%d", timetable.year, timetable.month, timetable.day)
    -- if GetConfig("TreasureBookEarlyBuy") == value then
    --     OpenWindowImmediately("TreasureBookUI")
    --     return
    -- end
    -- -- 打开预购界面
    -- OpenWindowImmediately("TreasureBookEarlyBuyUI")
end

-- 添加一个百宝书关闭时的回调
function TreasureBookDataManager:AddBookCloseCallBack(luaFunc)
    if type(luaFunc) ~= "function" then
        return
    end
    if not self.aFuncOnDisableCallback then
        self.aFuncOnDisableCallback = {}
    end
    self.aFuncOnDisableCallback[#self.aFuncOnDisableCallback + 1] = luaFunc
end

-- 获取所有百宝书关闭回调函数
function TreasureBookDataManager:GetBookCloseCallBack()
    return self.aFuncOnDisableCallback
end

-- 清空百宝书关闭回调函数
function TreasureBookDataManager:ClearBookCloseCallBack()
    self.aFuncOnDisableCallback = {}
end

-- 执行进入百宝书动作
function TreasureBookDataManager:DoEnterTreasureBook()
    -- 检查百宝书打开时间
    local kTimeTable, bNeedRequest, bIsOverMonth = self:TreasurebookOpenTimeCheck()

    -- 如果百宝书数据需要重新请求, 那么直接清除现有的百宝书数据缓存, 下一次请求百宝书数据的时候就会重新请求
    if bNeedRequest == true then
        self:SetTreasureBookBaseInfo(nil, false)
        local win = GetUIWindow("TreasureBookUI")
        if win then
            win.curSubView = nil
        end
    end

    local doEnter = function()
        -- 记录一下百宝书的打开时间
        TreasureBookDataManager:GetInstance():TreasurebookOpenTimeRec()
        TreasureBookDataManager:GetInstance():CheckTreasureBookAD()
    end

    -- 如果这次打开据上次打开已经跨月, 那么显示百宝书切换提示
    if bIsOverMonth == true then
        local msg = string.format("现已进入%d月百宝书周期，上月百宝书等级将会重置", (kTimeTable and kTimeTable.month) and kTimeTable.month or 0)
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, doEnter, {['confirm'] = true}})
        return
    end

    -- 如果跨天了, 重新请求一下百宝书基础信息
    if CheckDiffDayFlag(DIFF_DAY_FLAG_ENUMS.TREASUREBOOK) then
        CloseDiffDayFlag(DIFF_DAY_FLAG_ENUMS.TREASUREBOOK)
        self:RequestTreasureBookBaseInfo()
    end

    doEnter()
end

-- 检查并使用百宝书代金券
function TreasureBookDataManager:CheckAndUseTreasureBookTicket(bWarning)
    local uiCanUseItemID = StorageDataManager:GetInstance():GetkTreasureBookTicketUID()
    if (not uiCanUseItemID) or (uiCanUseItemID == 0) then
        return  
    end
    local doUse = function()
        SendUseStorageItem( 1, {[0] = {["uiItemID"] = uiCanUseItemID, ["uiItemNum"] = 1}})
    end
    if not bWarning then
        doUse()
        return
    end
    local strMsg = string.format("是否消耗一张百宝书代金券, 激活百宝书壕侠版?\n(若本期壕侠版百宝书已激活, 则预先开启下一期壕侠版百宝书)")
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, doUse, {['confirm'] = true}})
end

-- 设置百宝书赠送开关
function TreasureBookDataManager:SetTreasureBookSendSwitch(bOpen)
    -- 如果开关 由开变为关, 那么关闭当前的预购界面
    if (self.bTreasureBookSendSwitch ~= false) and (bOpen == false) and IsWindowOpen("TreasureBookEarlyBuyUI") then
        SystemUICall:GetInstance():Toast("百宝书赠送功能已关闭")
        RemoveWindowImmediately("TreasureBookEarlyBuyUI", false)
    end
    self.bTreasureBookSendSwitch = (bOpen ~= false)
end

-- 获取百宝书赠送开关
function TreasureBookDataManager:GetTreasureBookSendSwitch()
    return (self.bTreasureBookSendSwitch ~= false)
end

-- 这里发送每次进入百宝书需要进行的请求
function TreasureBookDataManager:SendEnterTreasureBookRequest()
    SendQueryTreasureBookInfo(STBQT_CLICK_REQUEST)
end

-- 清空缓存
function TreasureBookDataManager:Clear()
    self.kBookBaseInfo = nil
    self.kBookServerProgressData = nil
    self.taskID2Progress = nil
    self.mallItemID2StoreInfo = nil
    self.kBookRewardsCache = nil
    self.kBookAutoUseItemList = nil
    self.aFuncOnDisableCallback = nil
    self.bTreasureBookSendSwitch = nil
end