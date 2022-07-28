PinballServerPlayUI = class("PinballServerPlayUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local TimerType = {
    ['SlowTimer'] = 1,
    ['FastTimer'] = 2,
}
local TimerCost = {
    [TimerType.SlowTimer] = 3000,  -- 进度小于 TimerTransProgress 时自动请求数据的时间间隔
    [TimerType.FastTimer] = 1000,  -- 进度大于等于 TimerTransProgress 时自动请求数据的时间间隔
}
local TimerTransProgress = 0.9  -- 计时器从满转换到快的进度
local TimerCostCreateBubble = 1000  -- 自动添加气泡的时间

function PinballServerPlayUI:ctor(obj)
    self.ItemIconUIInst = ItemIconUI.new()
    self:SetGameObject(obj)
    self:DoInit()
end

function PinballServerPlayUI:DoInit()
    -- 其他数据
    self.kPinballMgr = PinballDataManager:GetInstance()

    -- 广告图
    self.objAD = self:FindChild(self._gameObject, "AD")
    self.objAD:SetActive(false)
    self.imgAD = self.objAD:GetComponent(DRCSRef_Type.Image)
    -- 提示
    local btnTips = self:FindChildComponent(self.objAD, "Tips", DRCSRef_Type.Button)
    self:AddButtonClickListener(btnTips, function()
        self:ShowServerPlayTips()
    end)
    -- 倒计时
    self.objTimer = self:FindChild(self._gameObject, "Timer")
    self.textTimer = self.objTimer:GetComponent(DRCSRef_Type.Text)
    -- 进度条
    self.objProgress = self:FindChild(self._gameObject, "Progress")
    self.barProgress = self:FindChildComponent(self.objProgress, "Progress", DRCSRef_Type.Scrollbar)
    self.textProgress = self:FindChildComponent(self.objProgress, "Value", DRCSRef_Type.Text)
    local btnProgress = self:FindChildComponent(self.objProgress, "Btn", DRCSRef_Type.Button)
    self:AddButtonClickListener(btnProgress, function()
        self:OnClickProgressBtn()
    end)
    self.objProgressIcon = self:FindChild(self.objProgress, "Item/Icon")
    -- 贡献排行
    self.objProgressTips = self:FindChild(self._gameObject, "ProgressTips")
    self.textProgressTips = self:FindChildComponent(self.objProgressTips, "Content", DRCSRef_Type.Text)
    self:SetProgressTipsShowState(false)
    local btnProgressTips = self.objProgressTips:GetComponent(DRCSRef_Type.Button)
    self:AddButtonClickListener(btnProgressTips, function()
        self:SetProgressTipsShowState(false)
    end)
    -- 奖励九宫格
    self.objRewards = self:FindChild(self._gameObject, "Rewards")
    self.kRewardInfos = self:InitRewardsNodes()
    -- 全服通知
    self.objNotice = self:FindChild(self._gameObject, "Notice")
    self.textNotice = self:FindChildComponent(self.objNotice, "Text", DRCSRef_Type.Text)
    -- 在这里设置策划给的默认提示
    self:SetServerNotice()
    -- 即将开抢
    self.objNextReward = self:FindChild(self._gameObject, "NextReward")
    self.objNextRewardList = self:FindChild(self.objNextReward, "List")
    self.kNextRewardInfos = self:InitNextRewardList()
    -- 进度推进气泡
    self.objPusherList = self:FindChild(self._gameObject, "Bubbles/List")
    self.objPusherPool = self:FindChild(self._gameObject, "Bubbles/Pool")
    self.transPusherList = self.objPusherList.transform
    self.transPusherPool = self.objPusherPool.transform
    self:InitPushBubbles()
    -- 夺宝记录
    local btnRecordOpen = self:FindChildComponent(self._gameObject, "ShowRecord", DRCSRef_Type.Button)
    self:AddButtonClickListener(btnRecordOpen, function()
        OpenWindowImmediately("PinballServerPlayRecordUI")
    end)
    -- 积分系统
    self.objPointRec = self:FindChild(self._gameObject, "PointRec")
    self.textPointValue = self:FindChildComponent(self.objPointRec, "Value/Text", DRCSRef_Type.Text)
    self.objPointProgress = self:FindChild(self.objPointRec, "Progress")
    self:InitPointRewards()
    -- 初始值
    self.bHasServerPlayData = false
    -- 注册事件
    self:AddEventListener("UPDATE_HOODLE_SERVER_PLAY_DATA", function()
        self:RefreshUI()
        if self.bHasServerPlayData ~= true then
            self.bHasServerPlayData = true
            self:OnFirstRecServerPlayData()
        end
    end)
    self:AddEventListener("UPDATE_HOODLE_SERVER_PLAY_SCORE", function()
        self:UpdatePointRec()
    end)
    self:AddEventListener("PINBALL_SERVERPLAY_DEVOTED_MSG_UPDATE", function(strMsg)
        if not self.bProgressTipsShow then
            return
        end
        self.textProgressTips.text = strMsg
    end)
end

-- 初始化九宫格奖励节点
function PinballServerPlayUI:InitRewardsNodes()
    if not self.objRewards then
        return
    end
    local transRewards = self.objRewards.transform
    local objChild = nil
    local objReward = nil
    local kRewardInfos = {}
    for index = 1, transRewards.childCount do
        objChild = transRewards:GetChild(index - 1).gameObject
        kRewardInfos[index] = {}
        kRewardInfos[index].objNode = objChild
        kRewardInfos[index].objTopRewardEffect = self:FindChild(objChild, "TopRewardEffect")
        kRewardInfos[index].objTopReward = self:FindChild(objChild, "TopReward")
        kRewardInfos[index].objChoose = self:FindChild(objChild, "Choose")
        kRewardInfos[index].objOver = self:FindChild(objChild, "Over")
        objReward = self:FindChild(objChild, "Item")
        kRewardInfos[index].objReward = objReward
        kRewardInfos[index].objIcon = self:FindChild(objReward, "Icon")
        kRewardInfos[index].objName = self:FindChild(objReward, "Name")
        kRewardInfos[index].textName = self:FindChildComponent(objReward, "Name", DRCSRef_Type.Text)
        self:FindChild(objChild, "Item/NewSign"):SetActive(false)
    end
    return kRewardInfos
end

-- 初始化即将开抢列表地
function PinballServerPlayUI:InitNextRewardList()
    if not self.objNextRewardList then
        return
    end
    local transList = self.objNextRewardList.transform
    local objChild = nil
    local kRewardInfos = {}
    for index = 1, transList.childCount do
        objChild = transList:GetChild(index - 1).gameObject
        kRewardInfos[index] = {}
        kRewardInfos[index].objReward = objChild
        kRewardInfos[index].objIcon = self:FindChild(objChild, "Item/Icon")
        self:FindChild(objChild, "Item/Name"):SetActive(false)
        self:FindChild(objChild, "Item/NewSign"):SetActive(false)
    end
    return kRewardInfos
end

-- 初始化气泡
function PinballServerPlayUI:InitPushBubbles()
    if not self.transPusherPool then
        return
    end
    self.canvasGroupBubbles = {}
    local transBubble = nil
    for index = 0, self.transPusherPool.childCount - 1 do
        transBubble = self.transPusherPool:GetChild(index)
        self.canvasGroupBubbles[transBubble] = transBubble:GetComponent("CanvasGroup")
    end
end

-- 初始化积分系统奖励
function PinballServerPlayUI:InitPointRewards()
    if not self.objPointProgress then
        return
    end
    local comLayout = self.objPointProgress:GetComponent(DRCSRef_Type.HorizontalLayoutGroup)
    self.barPointProgress = self:FindChildComponent(self.objPointProgress, "Bar", DRCSRef_Type.Scrollbar)
    local rectTansBar = self:FindChildComponent(self.objPointProgress, "Bar", DRCSRef_Type.RectTransform)
    local kPointReward = {}
    local transNode = self.objPointProgress.transform
    local uiRewardWidth = nil
    for index = 0, transNode.childCount - 1 do
        local transReward = transNode:GetChild(index)
        local objReward = transReward.gameObject
        local objIcon = self:FindChild(objReward, "Icon")
        local textValue = self:FindChildComponent(objReward, "Price/Text", DRCSRef_Type.Text)
        if objIcon and textValue then
            kPointReward[#kPointReward + 1] = {
                ['objIcon'] = objIcon,
                ['textValue'] = textValue,
            }
            if not uiRewardWidth then
                uiRewardWidth = transReward.rect.width
            end
        end
    end
    self.kPointRewardNodes = kPointReward
    -- 生成进度发布数据
    local uiProgressWidth = rectTansBar.rect.width
    local uiSpacing = (comLayout.spacing or 0) + (uiRewardWidth or 0)
    local uiCount = #kPointReward
    local uiHeadSpacing = (uiProgressWidth - uiSpacing * (uiCount - 1)) / 2
    local kRewardOffsetX = {}
    for index = 1, uiCount do
        local uiWidth = (index == 1) and uiHeadSpacing or uiSpacing
        kRewardOffsetX[index] = uiWidth / uiProgressWidth
    end
    self.kPointRewardOffsetX = kRewardOffsetX
end

function PinballServerPlayUI:OnEnable()
    if self.bHasServerPlayData then
        self:OpenAutoRequestTimer()
    end
end

function PinballServerPlayUI:OnDisable()
    self:CloseAutoRequestTimer()
    PinballDataManager:GetInstance():ClearServerPlayPushers()
end

function PinballServerPlayUI:OnFirstRecServerPlayData()
    self:UpdatePointRec()
end

-- 刷新活动界面
function PinballServerPlayUI:RefreshUI()
    -- 刷新宣传图
    self:UpdateAD()
    -- 刷新活动倒计时
    self:UpdateActivityTimer()
    -- 刷新夺宝进度
    self:UpdateProgress()
    -- 刷新即将开抢列表
    self:UpdateNextRewardsList()
    -- 刷新奖励九宫格
    self:UpdateRewards()
    -- 检查选中
    self:UpdateChooseReward()
    -- 开启自动请求计时器
    self:OpenAutoRequestTimer()
end

-- 刷新宣传图
function PinballServerPlayUI:UpdateAD()
    local strActivityImg = self.kPinballMgr:GetServerPlayActivityAdImgPath()
    if (not strActivityImg) or (strActivityImg == "") then
        return
    end
    if self.strCurImg ~= strActivityImg then
        self:SetSpriteAsync(strActivityImg, self.imgAD)
        self.strCurImg = strActivityImg
    end
    self.objAD:SetActive(true)
end

-- 设置全服提示
function PinballServerPlayUI:SetServerNotice(strWiner, strItemName, bIsTopReward)
    if not (strWiner and strItemName) then
        -- 恢复本地存储的记录
        local strRecNotice = GetConfig("PinballServerPlayNotice")
        if strRecNotice and (strRecNotice ~= "") then
            self.textNotice.text = strRecNotice
        else
            self.textNotice.text = GetLanguageByID(632004)
        end
        return
    end
    local strFormat = bIsTopReward and GetLanguageByID(632003) or GetLanguageByID(632002)
    if strFormat == "" then
        strFormat = "%s, %s"
    end
    self.textNotice.text = string.format(strFormat, strWiner, strItemName)
    -- 在客户端本地存下最新的记录
    SetConfig("PinballServerPlayNotice", self.textNotice.text)
end

-- 设置全服进度
function PinballServerPlayUI:UpdateProgress()
    local fProgress = self.kPinballMgr:GetServerPlayProgress() or 0
    self.barProgress.size = fProgress
    self.textProgress.text = string.format("%.2f%%", fProgress * 100)
end

-- 设置奖励图标
function PinballServerPlayUI:UpdateItemIcon(kNodeInfo, kItemTypeData, bShowName, bIsTop)
    if not (kNodeInfo and kNodeInfo.objIcon and kItemTypeData) then
        return
    end
    self.ItemIconUIInst:UpdateUIWithItemTypeData(kNodeInfo.objIcon, kItemTypeData)
    self.ItemIconUIInst:HideItemNum(kNodeInfo.objIcon)

    if kNodeInfo.objName then
        if bShowName == true then
            kNodeInfo.textName.text = getRankBasedText(kItemTypeData.Rank or 1, kItemTypeData.ItemName or '')
            kNodeInfo.objName:SetActive(true)
        else
            kNodeInfo.objName:SetActive(false)
        end
    end

    if kNodeInfo.objTopReward then
        kNodeInfo.objTopReward:SetActive(bIsTop == true)
    end
    if kNodeInfo.objTopRewardEffect then
        kNodeInfo.objTopRewardEffect:SetActive(bIsTop == true)
    end
end

-- 刷新夺宝图标状态 (余量, 总量, 选中)
function PinballServerPlayUI:UpdateRewardState(kNodeInfo, bChosen, iNum, iMax, iItemBaseID)
    if not (kNodeInfo and kNodeInfo.objIcon) then
        return
    end
    if iNum and iMax then
        -- 如果最大值是0, 说明这个物品是无限的, 不需要显示余量
        if iMax == 0 then
            self.ItemIconUIInst:HideItemNum(kNodeInfo.objIcon)
        else
            self.ItemIconUIInst:SetItemNum(kNodeInfo.objIcon, string.format("%d/%d", iNum, iMax))
        end
        kNodeInfo.objOver:SetActive((iNum == 0) and (iMax > 0))
    end
    if kNodeInfo.objChoose then
        if bChosen then
            local uiItemBaseID = iItemBaseID or 0
            local kItemBaseData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(uiItemBaseID)
            if kItemBaseData then
                self.ItemIconUIInst:UpdateUIWithItemTypeData(self.objProgressIcon, kItemBaseData)
                self.ItemIconUIInst:HideItemNum(self.objProgressIcon)
            end
            self.kCurChooseNodeInfo = kNodeInfo
        end
        kNodeInfo.objChoose:SetActive(bChosen == true)
    end
end

-- 设置即将开抢列表
function PinballServerPlayUI:UpdateNextRewardsList()
    local aiItems = self.kPinballMgr:GetServerPlayNextRewardQueue()
    if not aiItems then
        return
    end
    local kRewardInfo = nil
    local iItemBaseID = nil
    local kItemTypeData = nil
    for index = 1, #self.kNextRewardInfos do
        kRewardInfo = self.kNextRewardInfos[index]
        iItemBaseID = aiItems[index] or 0
        kItemTypeData = TableDataManager:GetInstance():GetTableData("Item", iItemBaseID)
        if kItemTypeData then
            self:UpdateItemIcon(kRewardInfo, kItemTypeData, true)
            kRewardInfo.objReward:SetActive(true)
        else
            kRewardInfo.objReward:SetActive(false)
        end
    end
end

-- 设置九宫格奖励
function PinballServerPlayUI:UpdateRewards()
    if not (self.kPinballMgr and self.kRewardInfos) then
        return
    end

    local kRewardPoolData = self.kPinballMgr:GetServerPlayRewardPool()
    if not kRewardPoolData then
        return
    end

    if not self.kRewardInfo2ItemBaseID then
        self.kRewardInfo2ItemBaseID = {}
        self.kItemBaseID2RewardInfo = {}
    end

    for index = 1, #self.kRewardInfos do
        local kRewardNodeInfo = self.kRewardInfos[index]
        local kRewardInfo = kRewardPoolData[index]
        local iItemBaseID = 0
        local kItemTypeData = nil
        if kRewardInfo and kRewardInfo.iItemBaseID then
            iItemBaseID = kRewardInfo.iItemBaseID
            kItemTypeData = TableDataManager:GetInstance():GetTableData("Item", iItemBaseID)
        end
        if kItemTypeData then
            if self.kRewardInfo2ItemBaseID[kRewardNodeInfo] ~= iItemBaseID then
                local uiOldRecID = self.kRewardInfo2ItemBaseID[kRewardNodeInfo]
                if uiOldRecID then
                    self.kItemBaseID2RewardInfo[uiOldRecID] = nil
                end
                self.kItemBaseID2RewardInfo[iItemBaseID] = kRewardNodeInfo
                self.kRewardInfo2ItemBaseID[kRewardNodeInfo] = iItemBaseID
                self:UpdateItemIcon(kRewardNodeInfo, kItemTypeData, true, kRewardInfo.bIsTop)
            end
            local iRemain = self.kPinballMgr:GetServerPlayRewardRemain(iItemBaseID) or 0
            local iLimit = kRewardInfo.iLimit or 0
            self:UpdateRewardState(kRewardNodeInfo, false, iRemain, iLimit)
            kRewardNodeInfo.objNode:SetActive(true)
        else
            kRewardNodeInfo.objNode:SetActive(false)
        end
    end
end

-- 在奖池中选中一个奖励
function PinballServerPlayUI:UpdateChooseReward()
    local iItemBaseID = self.kPinballMgr:GetCurChooseRewardItem()
    if (not iItemBaseID) or (iItemBaseID == 0) then
        return
    end
    if (not self.kItemBaseID2RewardInfo) or (not self.kItemBaseID2RewardInfo[iItemBaseID]) then
        derror("PinballServerPlayUI:UpdateChooseReward => can't find item reward info: " .. tostring(iItemBaseID))
        return
    end
    if self.kCurChooseNodeInfo then
        self:UpdateRewardState(self.kCurChooseNodeInfo, false)
    end
    self:UpdateRewardState(self.kItemBaseID2RewardInfo[iItemBaseID], true, nil, nil, iItemBaseID)
end

-- 开启自动请求计时器
function PinballServerPlayUI:OpenAutoRequestTimer(bSkipBubble, bSkipAutoReq, bIgnoreProgress)
    -- 自动刷进度推进气泡计时器
    if (bSkipBubble ~= true) and (not self.iAutoUpdateBubbleTimer) then
        self.iAutoUpdateBubbleTimer = self:AddTimer(TimerCostCreateBubble, function()
            local win = GetUIWindow("PinballGameUI")
            if not win then
                return
            end
            win.PinballServerPlayInst:CreateNewPusherBubble()
            -- 顺便刷新活动倒计时
            win.PinballServerPlayInst:UpdateActivityTimer()
        end, -1)
    end
    -- 自动请求数据计时器
    if bSkipAutoReq == true then
        return
    end
    local fProgress = 0
    if bIgnoreProgress ~= true then
        fProgress = self.kPinballMgr:GetServerPlayProgress() or 0
    end
    local eTimerType = TimerType.FastTimer
    if fProgress <= TimerTransProgress then
        eTimerType = TimerType.SlowTimer
    end
    -- 已经开了这个类型的计时器, 就不用再开了
    if self.iAutoRequestTimer and (self.iCurTimerType == eTimerType) then
        return
    end
    self:CloseAutoRequestTimer(true)
    if TimerCost[eTimerType] and (TimerCost[eTimerType] > 0) then
        self.iAutoRequestTimer = self:AddTimer(TimerCost[eTimerType], function()
            PinballDataManager:GetInstance():RequestServerPlayData()
        end, -1)
        self.iCurTimerType = eTimerType
    end
end

-- 关闭自动请求计时器
function PinballServerPlayUI:CloseAutoRequestTimer(bSkipBubble, bSkipAutoReq)
    -- 关闭自动推气泡计时器
    if (bSkipBubble ~= true) and self.iAutoUpdateBubbleTimer then
        self:RemoveTimer(self.iAutoUpdateBubbleTimer)
        self.iAutoUpdateBubbleTimer = nil
    end
    -- 关闭自动请求数据计时器
    if (bSkipAutoReq == true) or (not self.iAutoRequestTimer) then
        return
    end
    self:RemoveTimer(self.iAutoRequestTimer)
    self.iAutoRequestTimer = nil
    self.iCurTimerType = nil
end

-- 设置进度推进气泡
function PinballServerPlayUI:CreateNewPusherBubble(bIsSelf)
    if not self.bHasServerPlayData then
        return
    end
    local kPlayer = nil
    if bIsSelf then
        kPlayer = {['acPlayerName'] = PlayerSetDataManager:GetInstance():GetPlayerName()}
    else
        kPlayer = self.kPinballMgr:GetNextServerPlayPushers()
    end
    if (not kPlayer) or (not kPlayer.acPlayerName) then
        return
    end
    -- 如果池中没有对象, 将顶部气泡推入池中
    if self.transPusherPool.childCount == 0 then
        local transTop = self.transPusherList:GetChild(0)
        -- 停止动画
        if self.animBubbles[transTop] then
            for index, anim in ipairs(self.animBubbles[transTop]) do
                anim:Pause()
            end
        end
        -- 转移父节点
        transTop:SetParent(self.transPusherPool)
    end
    -- 从池中请求一个对象
    local transBubble = self.transPusherPool:GetChild(0)
    local textBubble = self:FindChildComponent(transBubble.gameObject, "Text", DRCSRef_Type.Text)
    textBubble.text =  string.format("玩家%s推进了夺宝进度", kPlayer.acPlayerName)
    transBubble:SetParent(self.transPusherList)
    -- 播放动画
    if not self.canvasGroupBubbles[transBubble] then
        return
    end
    if not self.animBubbles then
        self.animBubbles = {}
    end
    if not self.animBubbles[transBubble] then
        self.animBubbles[transBubble] = {}
    end
    self.canvasGroupBubbles[transBubble].alpha = 0
    self.animBubbles[transBubble][1] = Twn_CanvasGroupFade(self.animBubbles[transBubble][1], self.canvasGroupBubbles[transBubble], 0, 1, 0.4)
    self.animBubbles[transBubble][2] = Twn_CanvasGroupFade(self.animBubbles[transBubble][2], self.canvasGroupBubbles[transBubble], 1, 0, 0.4, 2.2, function()
        transBubble:SetParent(self.transPusherPool)
    end)
    self.animBubbles[transBubble][1]:SetAutoKill(false)
    self.animBubbles[transBubble][2]:SetAutoKill(false)
end

-- 更新活动结束时间
function PinballServerPlayUI:UpdateActivityTimer()
    local uiBeginTimeStamp, uiEndTimeStamp = self.kPinballMgr:GetServerPlayActivityTime()
    if not (uiBeginTimeStamp and uiEndTimeStamp) then
        self.objTimer:SetActive(false)
        return
    end
    self.objTimer:SetActive(true)
    local uiCurTimeStamp = GetCurServerTimeStamp()
    local iDelta = uiEndTimeStamp - uiCurTimeStamp
    if iDelta < 0 then
        self.textTimer.text = "即将切换至下一期"
        return
    end
    local kTimers = {}
    local iDaySec = 24 * 3600
    if iDelta > iDaySec then
        local iDay = math.floor(iDelta / iDaySec)
        iDelta = iDelta - iDaySec * iDay
        kTimers[#kTimers + 1] = string.format("%d天", iDay)
    end
    if iDelta > 3600 then
        local iHour = math.floor(iDelta / 3600)
        iDelta = iDelta - 3600 * iHour
        kTimers[#kTimers + 1] = string.format("%d时", iHour)
    end
    if iDelta > 60 then
        local iMin = math.floor(iDelta / 60)
        iDelta = iDelta - 60 * iMin
        kTimers[#kTimers + 1] = string.format("%d分", iMin)
    end
    if iDelta > 0 then
        kTimers[#kTimers + 1] = string.format("%d秒", iDelta)
    end
    self.textTimer.text = string.format("%s%s后到期", kTimers[1] or "", kTimers[2] or "")
end

-- 刷新积分奖励
function PinballServerPlayUI:UpdatePointRec()
    self.objPointProgress:SetActive(false)
    if not (self.kPointRewardNodes and self.kPointRewardOffsetX and (#self.kPointRewardNodes > 0)) then
        return
    end
    local aiExchangeItem, aiExchangePrice = PinballDataManager:GetInstance():GetPointExchangeReward()
    if not aiExchangeItem then aiExchangeItem = {} end
    if not aiExchangePrice then aiExchangePrice = {} end
    local uiNodeCount = #self.kPointRewardNodes
    local uiItemCount = #aiExchangeItem
    local uiPriceCount = #aiExchangePrice
    if (uiItemCount < uiNodeCount) or (uiPriceCount < uiNodeCount) then
        return
    end
    -- self.kPointRewardOffsetX 中已经计算好了以奖励图标中心点为段的每段的进度值分布
    -- 这里只需要将用户的积分与从低到高奖励的价格进行比较, 并且累加进度即可
    local uiUserPoint = PlayerSetDataManager:GetInstance():GetHoodleScore() or 0
    self.textPointValue.text = uiUserPoint
    local fCurProgress = 0
    local uiCurPoint = 0
    local uiPointRemain = uiUserPoint
    local kCanExchange = {}
    for index, iPoint in ipairs(aiExchangePrice) do
        if self.kPointRewardOffsetX[index] then
            if iPoint > uiUserPoint then
                local fOffset = (uiUserPoint - uiCurPoint) * self.kPointRewardOffsetX[index] / (iPoint - uiCurPoint)
                fCurProgress = fCurProgress + fOffset
                uiCurPoint = uiUserPoint
                break
            else
                fCurProgress = fCurProgress + self.kPointRewardOffsetX[index]
                uiCurPoint = aiExchangePrice[index]
                kCanExchange[aiExchangeItem[index] or 0] = true
            end
        end
    end
    -- 如果已经比较完了所有奖励的价格, 这时候用户的积分依然是超的
    -- 那么由于进度条上的奖励是居中均匀分布的, 超出最后一个奖励的最末端进度条和第一个奖励的首端进度条是一样长的
    -- 就用第一个奖励的进度发布来计算超出的进度
    if uiCurPoint < uiUserPoint then
        fCurProgress = fCurProgress + (uiUserPoint - uiCurPoint) * self.kPointRewardOffsetX[1] / aiExchangePrice[1]
    end
    -- 如果进度已经爆了, 置为最大进度
    if fCurProgress > 1 then
        fCurProgress = 1
    end
    -- 设置进度条
    self.barPointProgress.size = fCurProgress
    -- 设置奖励图标
    local kTBItem = TableDataManager:GetInstance():GetTable("Item")
    local funcIcon = function(objIcon, uiItemBaseID)
        local tips = TipsDataManager:GetInstance():GetItemTips(nil, uiItemBaseID)
        if not tips then
            return
        end
        local btns = {[1] = {["name"] = "兑换",}}
        local kPinballMgr = PinballDataManager:GetInstance()
        if kPinballMgr:CanExchangeServerReward(uiItemBaseID) then
            btns[1]['func'] = function()
                kPinballMgr:RequestExchangeServerReward(uiItemBaseID)
            end
        end
        tips.buttons = btns
        OpenWindowImmediately("TipsPopUI", tips)
    end
    local kNewItemID2Index = {}
    local kOldItemID2Index = PinballDataManager:GetInstance():GetExchangeServerRewardIndexInfo() or {}
    for index, kNodeInfo in ipairs(self.kPointRewardNodes) do
        local objIcon = kNodeInfo.objIcon
        local textValue = kNodeInfo.textValue
        local uiPrice = aiExchangePrice[index] or 0
        local uiItemID = aiExchangeItem[index] or 0
        local bNeedSetIcons = (kOldItemID2Index[uiItemID] ~= index)  -- 是否需要重新设置图标
        if objIcon then
            local kItemBaseData = kTBItem[uiItemID]
            if kItemBaseData then
                kNewItemID2Index[uiItemID] = index
                if bNeedSetIcons then
                    self.ItemIconUIInst:UpdateUIWithItemTypeData(objIcon, kItemBaseData)
                    self.ItemIconUIInst:HideItemNum(objIcon)
                    self.ItemIconUIInst:AddClickFunc(objIcon, funcIcon, uiItemID)
                end
                -- 更新图标状态
                local strState = nil
                if uiPrice > uiUserPoint then
                    strState = "dark"
                end
                self.ItemIconUIInst:SetIconState(objIcon, strState)
                objIcon:SetActive(true)
            else
                objIcon:SetActive(false)
            end
        end
        if textValue then
            textValue.text = uiPrice
        end
    end
    PinballDataManager:GetInstance():SetExchangeServerRewardInfo(kCanExchange, kNewItemID2Index)
    self.objPointProgress:SetActive(true)
end

-- 设置贡献排行显示状态
function PinballServerPlayUI:SetProgressTipsShowState(bOn)
    self.bProgressTipsShow = (bOn == true)
    self.objProgressTips:SetActive(self.bProgressTipsShow)
end

-- 点击进度条
function PinballServerPlayUI:OnClickProgressBtn()
    if self.bProgressTipsShow then
        self:SetProgressTipsShowState(false)
        return
    end
    self.textProgressTips.text = PinballDataManager:GetInstance():GetServerPlayDevotedPlayersMsg()
    self:SetProgressTipsShowState(true)
end

-- 展示tips
function PinballServerPlayUI:ShowServerPlayTips()
    if not self.kRateTip then
        self.kRateTip = {
            ['kind'] = 'wide',
            ['title'] = "关于全服夺宝",
            ['titlecolor'] = DRCSRef.Color.white,
            ['content'] = GetLanguageByID(555),
        }
    end
    OpenWindowImmediately("TipsPopUI", self.kRateTip)
end

function PinballServerPlayUI:OnDestroy()
    self.ItemIconUIInst:Close()
    self:CloseAutoRequestTimer()
    self.bHasServerPlayData = false
    PinballDataManager:GetInstance():ClearExchangeServerRewardIndexInfo()
end

return PinballServerPlayUI
