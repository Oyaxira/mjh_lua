Day3SignInDataManager = class("Day3SignInDataManager")
Day3SignInDataManager._instance = nil

function Day3SignInDataManager:GetInstance()
    if Day3SignInDataManager._instance == nil then
        Day3SignInDataManager._instance = Day3SignInDataManager.new()
    end
    return Day3SignInDataManager._instance
end

-- 请求签到活动数据, 请求到数据后, 执行一个回调
function Day3SignInDataManager:RequestServerData(callback)
    -- 向服务器请求活动数据
    self.onRecvServerDataCallback = callback
    SendDay3SignInCmd(D3SOT_REQUEST)

    -- #TODO 钱程 以下是测试代码, 直接调用回调
    -- self.bIsOpen = true
    -- self.iActivityID = 1
    -- self.kActivityData = TableDataManager:GetInstance():GetTableData("Day3SignIn", self.iActivityID)
    -- self.eCurStep = 1
    -- self.iCurStamp = os.time()
    -- self.asTitles = {
    --     [D3SST_NULL] = "风冲到达",
    --     [D3SST_FIRST] = "风冲到达\n<size=18><color=#FDC972>[TIME]</color></size>",
    --     [D3SST_SECOND_NORMAL] = "风冲飞书",
    --     [D3SST_SECOND_FREE] = "风冲到达\n<size=18><color=#FDC972>[TIME]</color></size>",
    --     [D3SST_THIRD] = "风冲抵达",
    -- }
    -- if self.eCurStep == 1 then
    --     -- 开启捡垃圾计时器
    --     self:OpenCollectItemTimer()
    --     -- 开启活动标题刷新计时器
    --     self:OpenActivityTitleUpdateTimer()
    -- end
    -- LuaEventDispatcher:dispatchEvent("DAY3_SIGN_IN_IS_DIRTY")
    -- if callback then
    --     callback()
    -- end
end

-- 接受服务器活动数据
function Day3SignInDataManager:OnRecvServerData(kData)
    if not kData then
        return
    end
    -- 处理服务器下行数据
    self.kDataCache = kData or {}
    self.iActivityID = kData.dwID or 0
    self.kActivityData = TableDataManager:GetInstance():GetTableData("Day3SignIn", self.iActivityID)
    self.eCurStep = kData.eState or 0
    self.bIsOpen = (self.iActivityID > 0) and (self.eCurStep ~= D3SST_END)
    self.iCurStamp = kData.dwTimeStamp or 0

    -- 获取此次活动各个阶段的标题, 如果可以, 这里之后可以改成配表
    if (self.iActivityID > 0) and ((not self.asTitles) or (self.asTitles.key ~= self.iActivityID)) then
        self.asTitles = {
            ['key'] = self.iActivityID,
            [D3SST_NULL] = "Letter",
            [D3SST_FIRST] = "Arrive[Timer]",
            [D3SST_SECOND_NORMAL] = "Letter",
            [D3SST_SECOND_FREE] = "Arrive[Timer]",
            [D3SST_THIRD] = "Arrive",
        }
    end

    -- 如果活动阶段发生了变化. 发送事件通知
    if self.eOldStep ~= self.eCurStep then
        self.eOldStep = self.eCurStep
        LuaEventDispatcher:dispatchEvent("DAY3_SIGN_IN_IS_DIRTY", self.eCurStep)
    end
    -- 刷新标题
    LuaEventDispatcher:dispatchEvent("DAY3_SIGN_IN_TITLE_UPDATE")        
    -- 刷新开启状态
    LuaEventDispatcher:dispatchEvent("DAY3_SIGN_IN_OPEN_STATE_CHANGE", self.bIsOpen)

    -- 开启计时器
    if (self.eCurStep == D3SST_FIRST) and self.iCurStamp and (self.iCurStamp > 0) then
        -- 开启捡垃圾计时器
        self:OpenCollectItemTimer()
        -- 开启活动标题刷新计时器
        self:OpenActivityTitleUpdateTimer()
    end
    
    if self.onRecvServerDataCallback then
        self.onRecvServerDataCallback()
        self.onRecvServerDataCallback = nil
    end
end

-- 告诉服务器用户打开了活动界面
function Day3SignInDataManager:OpenActivityUINotify()
    -- 仅在服务器没有时间戳记录的时候通知服务器
    if (not self.iActivityID) or (self.eCurStep ~= D3SST_NULL) then
        return
    end
    -- 通知服务器用户打开活动
    SendDay3SignInCmd(D3SOT_OPENWINDOW, self.iActivityID)
    -- 更新本地缓存
    if self.eCurStep == D3SST_NULL then
        self.kDataCache = self.kDataCache or {}
        self.kDataCache.eState = D3SST_FIRST
        self.kDataCache.dwTimeStamp = os.time()
        self:OnRecvServerData(self.kDataCache)
    end
end

-- 获取活动开启状态
function Day3SignInDataManager:GetOpenState()
    return (self.bIsOpen == true)
end

-- 获取当前活动id
function Day3SignInDataManager:GetCurActivityID()
    return self.iActivityID
end

-- 获取当前活动静态数据
function Day3SignInDataManager:GetCurActivityTypeData()
    return self.kActivityData
end

-- 获取当前步骤状态
function Day3SignInDataManager:GetCurStep()
    return self.eCurStep
end

-- 获取当前活动标题
function Day3SignInDataManager:GetCurTitleAndTimer()
    if not self.asTitles then
        return ""
    end
    if not (self.eCurStep and self.asTitles[self.eCurStep] and self.iCurStamp and (self.iCurStamp > 0)) then
        return self.asTitles[0] or ""
    end
    local strTitleState = self.asTitles[self.eCurStep]
    local bShowTimer = false
    local strTimer = ""
    if string.find(strTitleState, "%[Timer%]") then
        bShowTimer = true
        strTitleState = string.gsub(strTitleState, "%[Timer%]", "")
    end
    if bShowTimer then
        strTimer = string.format("<color=#FDC972>%s</color>", self:GetCurTimeStr() or "")
    end
    return strTitleState, bShowTimer, strTimer
end

-- 获取目标角色的名称
function Day3SignInDataManager:GetTarRoleName()
    if not self.kActivityData then
        return
    end
    if self.tarRoleName and self.tarRoleName[self.iActivityID] then
        return self.tarRoleName[self.iActivityID]
    end
    local strTarRoleName = RoleDataManager:GetInstance():GetRoleName(self.kActivityData.TargetRole or 0) or ""
    self.tarRoleName = {[self.iActivityID] = strTarRoleName}
    return strTarRoleName
end

-- 开启捡垃圾计时器
function Day3SignInDataManager:OpenCollectItemTimer()
    if not self.kActivityData then
        return
    end
    -- 先移除旧的计时器
    if self.timer and (#self.timer > 0) then
        for index, iTimerIndex in ipairs(self.timer) do
            globalTimer:RemoveTimer(iTimerIndex)
        end
    end
    self.timer = {}
    -- 获取用户开启活动的时间
    if not self.iCurStamp then
        self.iCurStamp = os.time()
    end
    local iCurTime = os.time()
    -- 开启新的计时器
    local aiNormalItems = self.kActivityData.FirstDayItems or {}
    local aiCollectTime = self.kActivityData.FDIAppearTime or {}
    local iItemTimer, iDeltaTime = 0, 0
    for index, iItemID in ipairs(aiNormalItems) do
        iItemTimer = aiCollectTime[index] or 0
        iDeltaTime = iItemTimer + self.iCurStamp - iCurTime
        if iDeltaTime > 0 then
            local iTimerIndex = globalTimer:AddTimer(iDeltaTime * 1000, function()
                self:CollectItem(iItemID, true)
            end)
            self.timer[#self.timer + 1] = iTimerIndex
        else
            -- 时间已过, 就是以前直接收集的物品
            self:CollectItem(iItemID, false)
        end
    end
end

-- 捡起一个垃圾
function Day3SignInDataManager:CollectItem(iItemID, bNotify)
    if not (iItemID and self.iActivityID and self.kActivityData) then
        return
    end
    if not self.kPickedItem then
        self.kPickedItem = {}
    end
    self.kPickedItem[iItemID] = true
    if bNotify ~= true then
        return
    end
    -- 如果没有, 生成一份 物品ID->数量
    if (not self.kItemID2Num) or (not self.kItemID2Num[self.iActivityID]) then
        local itemID2Num = {}
        local aiNormalItems = self.kActivityData.FirstDayItems or {}
        local aiNumList = self.kActivityData.FDINums or {}
        for index, id in ipairs(aiNormalItems) do
            itemID2Num[id] = aiNumList[index] or 1
        end
        if not self.kItemID2Num then
            self.kItemID2Num = {}
        end
        self.kItemID2Num[self.iActivityID] = itemID2Num
    end
    local kItemID2Num = self.kItemID2Num[self.iActivityID] or {}
    local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item", iItemID)
    local strItemName = "???"
	if kItemTypeData then
        strItemName = getRankBasedText(kItemTypeData.Rank, kItemTypeData.ItemName or '')
	end
    local msg = string.format("%s在赶来的途中\n获得了%s x%d", self:GetTarRoleName() or "", strItemName, kItemID2Num[iItemID] or 1)
    LuaEventDispatcher:dispatchEvent("DAY3_SIGN_IN_COLLECT_ITEM", {['msg'] = msg,})
    LuaEventDispatcher:dispatchEvent("DAY3_SIGN_IN_IS_DIRTY")
end

-- 获取所有捡起来的垃圾
function Day3SignInDataManager:GetAllPickedItems()
    if not self.kActivityData then
        return
    end
    local aiNormalItems = self.kActivityData.FirstDayItems or {}
    local aiNumList = self.kActivityData.FDINums or {}
    -- 如果当前阶段已经超过第一天, 那就直接返回所有物品
    self.kDataCache = self.kDataCache or {}
    if self.kDataCache.eState == D3SST_FIRST then
        local ret = {}
        local retNum = {}
        self.kPickedItem = self.kPickedItem or {}
        for index, itemID in ipairs(aiNormalItems) do
            if self.kPickedItem[itemID] == true then
                ret[#ret + 1] = itemID
                retNum[#retNum + 1] = aiNumList[index] or 1
            end
        end
        return ret, retNum
    end
    return aiNormalItems, aiNumList
end

-- 获取当前时间字符串
function Day3SignInDataManager:GetCurTimeStr()
	-- 获取时间字符串
	local iCurTime = os.time()
    local kDate = os.date("*t")
    local iTomorrowTime = os.time({year = kDate.year, month = kDate.month, day = (kDate.day + 1), hour = 0, min = 1, sec = 0})
    local iDeltaTime = (iTomorrowTime - iCurTime)
    local strTimer = ""
    local iHour = math.floor(iDeltaTime / 3600)
    if iHour >= 1 then
        strTimer = strTimer .. tostring(iHour) .. "时"
        iDeltaTime = iDeltaTime - iHour * 3600
    end
    local iMin = math.floor(iDeltaTime / 60)
    if iMin >= 1 then
        strTimer = strTimer .. tostring(iMin) .. "分"
        iDeltaTime = iDeltaTime - iMin * 60
    end
	return strTimer
end

-- 开启活动标题刷新计时器
function Day3SignInDataManager:OpenActivityTitleUpdateTimer()
    if self.iTitleUpdateTimer then
        return
    end
    self.iTitleUpdateTimer = globalTimer:AddTimer(60000, function()
        -- 如果不是第一阶段了或者已经离开了酒馆, 那么关闭这个计时器
        local kManager = Day3SignInDataManager:GetInstance()
        if (kManager.eCurStep ~= 1) or (GetGameState() ~= -1) then
            globalTimer:RemoveTimer(kManager.iTitleUpdateTimer)
            kManager.iTitleUpdateTimer = nil
            return
        end
        -- 刷新标题
        LuaEventDispatcher:dispatchEvent("DAY3_SIGN_IN_TITLE_UPDATE")
    end, -1)
end

-- 通知服务器买马
function Day3SignInDataManager:NotifyBuyHouse()
    if not self.iActivityID then
        return
    end
    SendDay3SignInCmd(D3SOT_BUYHORSE, self.iActivityID)
end

-- 通知服务器走回
function Day3SignInDataManager:NotifyWalkBack()
    if not self.iActivityID then
        return
    end
    SendDay3SignInCmd(D3SOT_WALK, self.iActivityID)
end

-- 通知服务器获取角色奖励
function Day3SignInDataManager:NotifyGetRoleReward()
    if not self.iActivityID then
        return
    end
    SendDay3SignInCmd(D3SOT_JOINTEAM, self.iActivityID)
end

-- 关闭活动
function Day3SignInDataManager:CloseActivity()
    self.kDataCache = self.kDataCache or {}
    self.kDataCache.eState = D3SST_END
    self:OnRecvServerData(self.kDataCache)
    -- 清空计时器
    if self.iTitleUpdateTimer then
        globalTimer:RemoveTimer(self.iTitleUpdateTimer)
        self.iTitleUpdateTimer = nil
    end
    if self.timer and (#self.timer > 0) then
        for index, iTimerIndex in ipairs(self.timer) do
            globalTimer:RemoveTimer(iTimerIndex)
        end
    end
    -- 关闭 ui
    if IsWindowOpen("Day3SignInUI") == true then
        RemoveWindowImmediately("Day3SignInUI", false)
    end
end

-- 清除缓存
function Day3SignInDataManager:Clear()
    self.kDataCache = nil
    self.iActivityID = nil
    self.kActivityData = nil
    self.eCurStep = nil
    self.eOldStep = nil
    self.bIsOpen = nil
    self.iCurStamp = nil
    self.asTitles = nil
    self.kPickedItem = nil
    self.kItemID2Num = nil
end