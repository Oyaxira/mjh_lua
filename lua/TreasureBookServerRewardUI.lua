TreasureBookServerRewardUI = class("TreasureBookServerRewardUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local l_DRCSRef_Type = DRCSRef_Type
function TreasureBookServerRewardUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function TreasureBookServerRewardUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self._gameObjectParent = objParent
    self._instParent = instParent
    local obj = self:FindChild(objParent, "TreasureBookServerRewardUI")
	if obj then
		self:SetGameObject(obj)
    end
    -- 其他数据
    self.bookManager = TreasureBookDataManager:GetInstance()
    local sortedData = {}
    local TB_TreasureBookGlobal = TableDataManager:GetInstance():GetTable("TreasureBookGlobal")
    for index, data in pairs(TB_TreasureBookGlobal) do
        sortedData[#sortedData + 1] = data
    end
    table.sort(sortedData, function(a, b)
        return (a.NeedNum or 0) < (b.NeedNum or 0)
    end)
    self.akSortedData = sortedData
    -- ui界面
    local objPage = self:FindChild(self._gameObject, "Page")
    local objBoard = self:FindChild(objPage, "Board")
    --等级信息
    local objLevelMsg = self:FindChild(objBoard, "LevelMsg")
    self.textLevel = self:FindChildComponent(objLevelMsg, "Level", l_DRCSRef_Type.Text)
    self.scrollBarLevel = self:FindChildComponent(objLevelMsg, "Scrollbar", l_DRCSRef_Type.Scrollbar)
    self:SetLevelText(0)
    -- 奖励信息
    local objRewardMsg = self:FindChild(objBoard, "RewardMsg")
    self.objSvRewards = self:FindChild(objRewardMsg, "Rewards")
    self.svRewards = self.objSvRewards:GetComponent(l_DRCSRef_Type.LoopHorizontalScrollRect)
    self.svRewards:AddListener(function(...)
        if self:IsOpen() == true then
            self:UpdateRewardItem(...)
        end
    end)
    self.objSvRewards:SetActive(false)
    -- 底部栏
    self.objBar = self:FindChild(objPage, "Bar")
    self.objActivation = self:FindChild(self.objBar, "Activation")
    local btnActivation = self.objActivation:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnActivation, function()
        self:OnClickActivation()
    end)
    self.objActiveSign = self:FindChild(self.objBar, "ActiveSign")
    local btnActiveSign = self.objActiveSign:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnActiveSign, function()
        self:OnClickActiveSign()
    end)
    self.textActiveSignMsg = self:FindChildComponent(self.objActiveSign, "ActivaeMsg", l_DRCSRef_Type.Text)
    self.objBar:SetActive(false)
end

function TreasureBookServerRewardUI:RefreshUI(info)
    self:CheckBookProgressData()
end

-- 检查百宝书全服等级进度信息
function TreasureBookServerRewardUI:CheckBookProgressData()
    if self.bookManager:GetTreasureBookServerProgressData() then
        self:CheckBookProgressRewardFlag()
    else
        self.bookManager:RequestTreasureBookServerProgressData()
    end
end

-- 检查全服进度奖励领取标记
function TreasureBookServerRewardUI:CheckBookProgressRewardFlag()
    if self.bookManager:GetTreasureBookBaseInfo() then
        self:UpdateTreasureBookProgress()
    else
        local callBack = function()
            local win = GetUIWindow("TreasureBookUI")
            if not win then return end
            win.TreasureBookServerRewardUIInst:UpdateTreasureBookProgress()
        end
        self.bookManager:RequestTreasureBookBaseInfo(callBack)
    end
end

-- 设置等级数据
function TreasureBookServerRewardUI:SetLevelText(iLevel)
    self.textLevel.text = string.format("全服玩家总等级: %d", iLevel)
    -- 进度条的等级分布不是均匀的, 因此将进度换算到某区间的值, 而不能直接用 当前等级/总等级
    if not self.kMapW then
        -- 一共有 x 个等级分层
        local x = #self.akSortedData
        -- 中间x-1段均匀分为 pCenter = 1 / x 占比, 首末两端则长度为 pEnd = 1 / 2x
        local pCenter = 1 / x
        local pEnd = pCenter / 2
        -- 阶段长度映射
        local kMapW = {}
        for index = 1, x + 1 do
            kMapW[index] = ((index == 1) or (index == x + 1)) and pEnd or pCenter
        end
        self.kMapW = kMapW
    end
    -- 计算长度
    local fSumProgress = 0
    local iPreNeedNum = 0
    local iMaxNum = 0
    for index, data in ipairs(self.akSortedData) do
        local fProgressPerStep = self.kMapW[index] or 0
        local uiNeedNum = data.NeedNum or 0
        if uiNeedNum > iMaxNum then
            iMaxNum = uiNeedNum
        end
        if iLevel >= uiNeedNum then
            fSumProgress = fSumProgress + fProgressPerStep
            iPreNeedNum = uiNeedNum
        else
            fSumProgress = fSumProgress + ((iLevel - iPreNeedNum) / (uiNeedNum - iPreNeedNum)) * fProgressPerStep
            break
        end
    end
    -- 比最大值还要大, 直接设为满值
    if iLevel > iMaxNum then
        fSumProgress = 1
    end
    self.scrollBarLevel.size = fSumProgress
end

-- 设置百宝书全服等级进度
function TreasureBookServerRewardUI:UpdateTreasureBookProgress()
    local info = self.bookManager:GetTreasureBookServerProgressData()
    if not info then
        return
    end
    self.iCurSumLevel = info.iSumLevel or 0
    self:SetLevelText(self.iCurSumLevel)
    -- 更新进度奖励领取状态
    self:UpdateRewardList()
    -- 更新底部栏
    self:UpdateBar()
end

-- 更新进度奖励领取状态
function TreasureBookServerRewardUI:UpdateRewardList()
    local info = self.bookManager:GetTreasureBookBaseInfo()
    if not (info and self.iCurSumLevel) then
        return
    end
    self.bIsVIP = (info.bRMBPlayer == true)
    self.svRewards.totalCount = #self.akSortedData
    if self.bFirstRefresh ~= true then
        self.svRewards:RefillCells()
        self.bFirstRefresh = true
    else
        self.svRewards:RefreshCells()
    end
    -- self.svRewards:RefreshNearestCells()
    self.objSvRewards:SetActive(true)
end

-- 更新奖励滚动栏子节点
function TreasureBookServerRewardUI:UpdateRewardItem(transform, index)
    if not (transform and index) then
        return
    end
    local obj = transform.gameObject
    local typeData = self.akSortedData[index + 1]
    -- 设置进度条与标记
    -- local scrollBar = self:FindChildComponent(obj, "Scrollbar", "Scrollbar")
    local iLevelNeed = typeData.NeedNum or 0
    local strState = nil
    if self.iCurSumLevel >= iLevelNeed then
        -- scrollBar.size = 1
        strState = "pass"
    else
        local kPreStage = self.akSortedData[index]
        if kPreStage and (self.iCurSumLevel < (kPreStage.NeedNum or 0)) then
            -- scrollBar.size = 0
            strState = "notyet"
        else
            -- scrollBar.size = (self.iCurSumLevel / iLevelNeed)
            strState = "current"
        end
    end
    -- 设置标记
    local objSign = self:FindChild(obj, "Sign")
    local objSignNotYet = self:FindChild(objSign, "NotYet")
    local objSignPass = self:FindChild(objSign, "Pass")
    local objSignCurrent = self:FindChild(objSign, "Current")
    objSignNotYet:SetActive(strState == "notyet")
    objSignPass:SetActive(strState == "pass")
    objSignCurrent:SetActive(strState == "current")
    -- 设置标题
    local objTitle = self:FindChild(obj, "Title")
    local objTitleText = self:FindChild(objTitle, "Text")
    local objTitleBtn = self:FindChild(objTitle, "Get")
    objTitleText:SetActive(false)
    objTitleBtn:SetActive(false)
    local bHeroRewardGot = false
    local bRmbRewardGot = false
    local bRmbRewardGotWithIdentity = false
    if strState == "pass" then
        bHeroRewardGot = self.bookManager:IsBookServerRewardGot(index + 1, false)
        bRmbRewardGot = self.bookManager:IsBookServerRewardGot(index + 1, true, false)
        bRmbRewardGotWithIdentity = self.bookManager:IsBookServerRewardGot(index + 1, true, true)
        if bHeroRewardGot and bRmbRewardGotWithIdentity then
            objTitleText:SetActive(true)
            objTitleText:GetComponent(l_DRCSRef_Type.Text).text = string.format("总等级: %d\n已领取", iLevelNeed)
        else
            objTitleBtn:SetActive(true)
            self:FindChildComponent(objTitleBtn, "Text", l_DRCSRef_Type.Text).text = string.format("总等级: %d\n可领取", iLevelNeed)
            local btnTitle = objTitleBtn:GetComponent(l_DRCSRef_Type.Button)
            self:RemoveButtonClickListener(btnTitle)
            local iCurStage = index + 1
            self:AddButtonClickListener(btnTitle, function()
                SendQueryTreasureBookInfo(STBQT_PROGRESS_REWARD, iCurStage)
            end)
        end
    else
        objTitleText:SetActive(true)
        objTitleText:GetComponent(l_DRCSRef_Type.Text).text = string.format("总等级: %d\n未达成", iLevelNeed)
    end
    -- 设置英雄奖励
    local objIcon = nil
    local strKeyItem = nil
    local strKeyNum = nil
    local itemTypeID = nil
    local itemNum = nil
    local transRewards = self:FindChild(obj, "HeroReward/Rewards").transform
    local objTick = nil
    local strIconState = nil
    local bLock = (strState ~= "pass")
    for i = 0, transRewards.childCount - 1 do
        objIcon = transRewards:GetChild(i).gameObject
        strKeyItem = string.format("HeroID%d", i + 1)
        strKeyNum = string.format("HeroNum%d", i + 1)
        if typeData[strKeyItem] and (typeData[strKeyItem] > 0) then
            itemTypeID = typeData[strKeyItem]
            itemNum = typeData[strKeyNum] or 0
            self.ItemIconUI:UpdateUIWithItemTypeData(objIcon, TableDataManager:GetInstance():GetTableData("Item",itemTypeID))
            self.ItemIconUI:SetItemNum(objIcon, itemNum, itemNum <= 1)
            strIconState = nil
            if bLock then
                strIconState = "dark"
            end
            self.ItemIconUI:SetIconState(objIcon, strIconState)
            objTick = self:FindChild(objIcon, "Tick")
            objTick:SetActive(bHeroRewardGot)
            objIcon:SetActive(true)
        else
            objIcon:SetActive(false)
        end
    end
    -- 设置壕侠奖励
    transRewards = self:FindChild(obj, "RmbReward/Rewards").transform
    bLock = (strState ~= "pass") or (self.bIsVIP ~= true)
    for i = 0, transRewards.childCount - 1 do
        objIcon = transRewards:GetChild(i).gameObject
        strKeyItem = string.format("RichID%d", i + 1)
        strKeyNum = string.format("RichNum%d", i + 1)
        if typeData[strKeyItem] and (typeData[strKeyItem] > 0) then
            itemTypeID = typeData[strKeyItem]
            itemNum = typeData[strKeyNum] or 0
            self.ItemIconUI:UpdateUIWithItemTypeData(objIcon, TableDataManager:GetInstance():GetTableData("Item",itemTypeID))
            self.ItemIconUI:SetItemNum(objIcon, itemNum, itemNum <= 1)
            strIconState = nil
            if bLock then
                strIconState = "dark"
            end
            self.ItemIconUI:SetIconState(objIcon, strIconState)
            objTick = self:FindChild(objIcon, "Tick")
            objTick:SetActive(bRmbRewardGot)
            objIcon:SetActive(true)
        else
            objIcon:SetActive(false)
        end
    end
end

-- 更新底部栏
function TreasureBookServerRewardUI:UpdateBar()
    local info = self.bookManager:GetTreasureBookBaseInfo()
    if not info then
        return
    end
    local bIsVIP = info.bRMBPlayer == true
    self.objActivation:SetActive(not bIsVIP)
    self.objActiveSign:SetActive(bIsVIP)
    local strMsg = "已激活壕侠版，继续升级可得更多奖励"
    -- 如果玩家已经预购, 那么在底部栏添加预购信息
    -- if info.bAdvancePurchase == true then
    --     self.textActiveSignMsg.text = self.strOriActiveSighMsg .. " <color=#913E2B>(已预购)</color>"
    -- else
    --     self.textActiveSignMsg.text = self.strOriActiveSighMsg
    -- end
    -- 添加壕侠到期时间
    local uiOutOfDateTimeStamp = info.iPurchaseBookEndTime or 0
    local kDate = os.date("*t", uiOutOfDateTimeStamp)
    strMsg = strMsg .. string.format("\n壕侠到期时间 %04d年%02d月%02d日", kDate.year or 0, kDate.month or 0, kDate.day or 0)
    self.textActiveSignMsg.text = strMsg
    self.objBar:SetActive(true)
end

-- 点击激活壕侠
function TreasureBookServerRewardUI:OnClickActivation()
    if not self.bookManager then
        return
    end
    self.bookManager:TryToBuyVIPForSelf(function()
        TreasureBookDataManager:GetInstance():RequestActiveBookVIP()
    end)
end

-- 请求 续费/赠送 壕侠百宝书
function TreasureBookServerRewardUI:OnClickActiveSign()
    OpenWindowImmediately("TreasureBookEarlyBuyUI")
end

function TreasureBookServerRewardUI:OnDestroy()
    self.ItemIconUI:Close()
end

return TreasureBookServerRewardUI