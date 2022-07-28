TreasureBookTaskUI = class("TreasureBookTaskUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type
function TreasureBookTaskUI:ctor()

end

function TreasureBookTaskUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self._gameObjectParent = objParent
    self._instParent = instParent
    local obj = self:FindChild(objParent, "TreasureBookTaskUI")
	if obj then
		self:SetGameObject(obj)
    end
    local objPage = self:FindChild(self._gameObject, "Page")
    local objTaskContent = self:FindChild(objPage, "Board/Viewport/Content")
    self.rectTransTaskContent = objTaskContent:GetComponent(l_DRCSRef_Type.RectTransform)
    self.objHeroTitle = self:FindChild(objTaskContent, "HeroTitle")
    self.objHeroTitle:SetActive(false)
    self.objHeroTasks = self:FindChild(objTaskContent, "HeroTasks")
    self.rectTransHeroTasks = self.objHeroTasks:GetComponent(l_DRCSRef_Type.RectTransform)
    self.objHeroTasks:SetActive(false)
    self.objVIPTitle = self:FindChild(objTaskContent, "VIPTitle")
    self.objVIPTitle:SetActive(false)
    self.objVIPTasks = self:FindChild(objTaskContent, "VIPTasks")
    self.rectTransVIPTasks = self.objVIPTasks:GetComponent(l_DRCSRef_Type.RectTransform)
    self.objVIPTasks:SetActive(false)
    self.objRepeatTitle = self:FindChild(objTaskContent, "RepeatTitle")
    self.objRepeatTitle:SetActive(false)
    self.objRepeatTasks = self:FindChild(objTaskContent, "RepeatTasks")
    self.rectTransRepeatTasks = self.objRepeatTasks:GetComponent(l_DRCSRef_Type.RectTransform)
    self.objRepeatTasks:SetActive(false)
    -- 底部栏
    self.objBar = self:FindChild(objPage, "Bar")
    self.objSwitch = self:FindChild(self.objBar, "Switch")
    self.textWeekthMsg = self:FindChildComponent(self.objSwitch, "Msg/Weekth", l_DRCSRef_Type.Text)
    self.textDatethMsg = self:FindChildComponent(self.objSwitch, "Msg/Date", l_DRCSRef_Type.Text)
    local btnSwitchLeft =self:FindChildComponent(self.objSwitch, "Left", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnSwitchLeft, function()
        self:OnClickSwitchLeft()
    end)
    local btnSwitchRight =self:FindChildComponent(self.objSwitch, "Right", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnSwitchRight, function()
        self:OnClickbwitchRight()
    end)
    self.objBtnDialyMoney = self:FindChild(self.objBar, "DialyMoney")
    self.objEffectBtnDialyMoney = self:FindChild(self.objBtnDialyMoney, "Get/eff")
    self.textBtnDialyMoney = self:FindChildComponent(self.objBtnDialyMoney, "Text", l_DRCSRef_Type.Text)
    self.textBtnDialyMoneyGet = self:FindChildComponent(self.objBtnDialyMoney, "Get/Text", l_DRCSRef_Type.Text)
    self.imgBtnDialyMoneyGet = self:FindChildComponent(self.objBtnDialyMoney, "Get", l_DRCSRef_Type.Image)
    self.btnDialyMoney = self:FindChildComponent(self.objBtnDialyMoney, "Get", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnDialyMoney, function()
        self:OnClickDialyMoney()
    end)
    self.objBtnWeeklyExp = self:FindChild(self.objBar, "WeeklyExp")
    self.objEffectBtnWeeklyExp = self:FindChild(self.objBtnWeeklyExp, "Get/eff")
    self.textBtnWeeklyExp = self:FindChildComponent(self.objBtnWeeklyExp, "Text", l_DRCSRef_Type.Text)
    self.textBtnWeeklyExpGet = self:FindChildComponent(self.objBtnWeeklyExp, "Get/Text", l_DRCSRef_Type.Text)
    self.imgBtnWeeklyExpGet = self:FindChildComponent(self.objBtnWeeklyExp, "Get", l_DRCSRef_Type.Image)
    self.btnWeeklyExp = self:FindChildComponent(self.objBtnWeeklyExp, "Get", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnWeeklyExp, function()
        self:OnClickWeeklyExp()
    end)
    self.objBar:SetActive(false)
    -- 其他数据
    self.bookManager = TreasureBookDataManager:GetInstance()
    self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
end

function TreasureBookTaskUI:RefreshUI(info)
    -- 检查百宝书基础信息
    if self.bookManager:GetTreasureBookBaseInfo() then
        self:CheckTaskProgressData()
    else
        self.bookManager:RequestTreasureBookBaseInfo()
    end
end

-- 检查任务进度信息
function TreasureBookTaskUI:CheckTaskProgressData()
    if self.bookManager:GetTaskProgressData() then
        self:InitTaskData()
    else
        self.bookManager:RequestTaskProgressData()
    end
end

-- 初始化任务ui
function TreasureBookTaskUI:InitTaskData()
    local info = self.bookManager:GetTreasureBookBaseInfo()
    local progressData = self.bookManager:GetTaskProgressData()
    if not (info and progressData) then 
        return 
    end
    self.kBookInfo = info
    self.iCurBookID = info.iCurBookID
    self.bIsVIP = info.bRMBPlayer
    self.kBookData = TableDataManager:GetInstance():GetTableData("TreasureBook",self.iCurBookID)
    self.iRealRound = info.iCurRound
    self.iCurRound = info.iCurRound
    self.iMaxRound = #(self.kBookData.TreasureBookTaskIDs or {})
    self.kTaskSlots = {
        ["HeroTask"] = (self.kBookData.NormalVersionInitSlot or 0) + info.iExtraHeroSlot,
        ["VIPTask"] = (self.kBookData.HighVersionInitSlot or 0) + info.iExtraRmbSlot,
    }
    self.kProgressData = progressData
    self:SetRoundTasks()
end

-- 更新单条任务ui的进度
function TreasureBookTaskUI:UpdateSingleTaskUIProgessData(iTask, kProgressData)
    if not (self.taskID2Obj and iTask and kProgressData) then
        return
    end
    local kObjData = self.taskID2Obj[iTask]
    if not (kObjData and kObjData.state and kObjData.progressBar and kObjData.progressValue) then
        return
    end

    -- 设置进度
    local kTaskData = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTask)
    iTargetProgress = kTaskData.TargetProgress or 0

    iCurProgress = kProgressData.iProgress or 0
    iCurProgress = (iCurProgress > iTargetProgress) and iTargetProgress or iCurProgress

    local scrollbarProgress = kObjData.progressBar
    scrollbarProgress.size = iCurProgress / iTargetProgress

    local textTaskProgressValue = kObjData.progressValue
    textTaskProgressValue.text = string.format("%d/%d", iCurProgress, iTargetProgress)

    -- 设置状态
    local objTaskState = kObjData.state
    local bTaskAchieve = kProgressData.bReward == true
    self:FindChild(objTaskState, "NotAchieve"):SetActive(not bTaskAchieve)
    self:FindChild(objTaskState, "Achieve"):SetActive(bTaskAchieve)

    -- 更新进度缓存
    self.kProgressData[iTask] = kProgressData
end

-- 重新调整自适应高度
function TreasureBookTaskUI:RebuildRectTransform(rectTrans)
    if not rectTrans then
        return
    end
    DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rectTrans)
end

-- 设置某一轮的任务
function TreasureBookTaskUI:SetRoundTasks()
    if not (self.kBookInfo and self.kBookData and self.kProgressData and self.kTaskSlots 
    and self.kBookData.TreasureBookTaskIDs and self.iCurRound) then
        return
    end
    local iCurRoundTaskManagerID = self.kBookData.TreasureBookTaskIDs[self.iCurRound]
    if not iCurRoundTaskManagerID then
        return
    end
    self.bIsPreRound = self.iCurRound < self.iRealRound
    self.bIsCurRound = self.iCurRound == self.iRealRound
    self.bIsFutureRound = self.iCurRound > self.iRealRound
    self.kCurTaskManager = TableDataManager:GetInstance():GetTableData("TreasureBookTaskPlan",iCurRoundTaskManagerID)
    local taskID2Obj = {}
    local setTaskHelper = function(aiTasks, sResKey, objParent, bLock, bIgnoreExpDiscount)
        if not (aiTasks and (#aiTasks > 0) and sResKey and objParent) then
            return false
        end
        bLock = (bLock == true)
        local iSlotCount = self.kTaskSlots[sResKey] or 0
        self.objTaskTemp = self.objTaskTemp or {}
        if not self.objTaskTemp[sResKey] then
            self.objTaskTemp[sResKey] = LoadPrefab("UI/UIPrefabs/TownUI/" .. sResKey,typeof(CS.UnityEngine.GameObject))
        end
        local objTaskTemp = self.objTaskTemp[sResKey]
        local transParent = objParent.transform
        local iCurChildCount = transParent.childCount
        local iNeedChildCount = #aiTasks
        local iDeltaCount = iNeedChildCount - iCurChildCount
        if iDeltaCount > 0 then
            for index = 1, iDeltaCount do
                CloneObj(objTaskTemp, objParent)
            end
        end
        local iTaskID = nil
        local kTaskData = nil
        local objTaskChild = nil
        local objTaskProgress = nil
        local objTaskProgressValue = nil
        local textTaskProgressValue = nil
        local scrollbarProgress = nil
        local objTaskState = nil
        local objTaskExp = nil
        local kProgress = nil
        local iCurProgress, iTargetProgress = 0, 0
        for index = 1, transParent.childCount do
            objTaskChild = transParent:GetChild(index - 1).gameObject
            iTaskID = aiTasks[index]
            local booktask = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
            if (index <= iSlotCount) and iTaskID and booktask then
                kTaskData = booktask
                kProgress = self.kProgressData[iTaskID]
                -- 设置标题
                objTaskProgress = self:FindChild(objTaskChild, "Progress")
                scrollbarProgress = objTaskProgress:GetComponent(l_DRCSRef_Type.Scrollbar)
                iTargetProgress = kTaskData.TargetProgress or 0
                if bLock then
                    scrollbarProgress.size = 0
                else
                    iCurProgress = kProgress and kProgress.iProgress or 0
                    iCurProgress = (iCurProgress > iTargetProgress) and iTargetProgress or iCurProgress
                    scrollbarProgress.size = iCurProgress / iTargetProgress
                end
                objTaskProgressValue = self:FindChild(objTaskProgress, "Value")
                textTaskProgressValue = objTaskProgressValue:GetComponent(l_DRCSRef_Type.Text)
                if bLock then
                    self:FindChildComponent(objTaskProgress, "Title", l_DRCSRef_Type.Text).text = "需要先解锁壕侠版百宝书"
                    objTaskProgressValue:SetActive(false)
                else
                    self:FindChildComponent(objTaskProgress, "Title", l_DRCSRef_Type.Text).text = GetLanguageByID(kTaskData.NameID)
                    textTaskProgressValue.text = string.format("%d/%d", iCurProgress, iTargetProgress)
                    objTaskProgressValue:SetActive(true)
                end
                -- 设置状态
                objTaskState = self:FindChild(objTaskChild, "State")
                local bTaskAchieve = (kProgress ~= nil) and (kProgress.bReward == true)
                self:FindChild(objTaskState, "NotAchieve"):SetActive((not bLock) and (not bTaskAchieve))
                self:FindChild(objTaskState, "Achieve"):SetActive((not bLock) and bTaskAchieve)
                self:FindChild(objTaskState, "Lock"):SetActive(bLock)
                -- 设置经验
                objTaskExp = self:FindChild(objTaskChild, "Exp")
                objTaskExp:SetActive(not bLock)
                self:FindChild(objTaskExp, "BackNotAchieve"):SetActive(not bTaskAchieve)
                self:FindChild(objTaskExp, "BackAchieve"):SetActive(bTaskAchieve)
                local objDiscount = self:FindChild(objTaskExp, "Discount")
                objDiscount:SetActive(false)
                local oriExp = kTaskData.ExpHandsel
                if self.bIsPreRound and (bIgnoreExpDiscount ~= true) then
                    local fDiscount = (self.kBookData.OvertimeTaskExpDecay or 10000) / 10000
                    oriExp = math.ceil(oriExp * fDiscount)
                    if fDiscount < 1 then
                        objDiscount:GetComponent(l_DRCSRef_Type.Text).text = string.format("-%.0f%%", (1 - fDiscount) * 100)
                        objDiscount:SetActive(true)
                    end
                end
                self:FindChildComponent(objTaskExp, "Value", l_DRCSRef_Type.Text).text = tostring(oriExp)
                -- ui数据缓存
                taskID2Obj[iTaskID] = {
                    ['state'] = objTaskState,
                    ['progressBar'] = scrollbarProgress,
                    ['progressValue'] = textTaskProgressValue,
                }
                -- 如果是用户累计时长的任务, 重新请求一次任务进度
                if kTaskData.TaskTypeA == TreasureTaskTypeA.TTTA_CumulativeTime then
                    SendQueryTreasureBookInfo(STBQT_TASK, kTaskData.BaseID)
                end
                objTaskChild:SetActive(true)
            else
                objTaskChild:SetActive(false)
            end
        end
        return true
    end
    local bRes = false
    -- 英雄任务
    bRes = setTaskHelper(self.kCurTaskManager.HeroTask, "HeroTask", self.objHeroTasks)
    self.objHeroTitle:SetActive(bRes)
    self.objHeroTasks:SetActive(bRes)
    if bRes then
        self:RebuildRectTransform(self.rectTransHeroTasks)
    end
    -- 壕侠任务
    bRes = setTaskHelper(self.kCurTaskManager.RichmanTask, "VIPTask", self.objVIPTasks, not self.bIsVIP)
    self.objVIPTitle:SetActive(bRes)
    self.objVIPTasks:SetActive(bRes)
    if bRes then
        self:RebuildRectTransform(self.rectTransVIPTasks)
    end
    -- 重复任务
    local bOpenRepeatTask = (self.kBookInfo.bOpenRepeatTask == true)
    if bOpenRepeatTask then
        -- 获取本期百宝书的重复任务 目前只设计为一期百宝书有且只有一个可重复任务
        local iRepeatTaskID = self:GetBookRepeatTaskID()
        if iRepeatTaskID then
            local kTask = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iRepeatTaskID)
            local kProgress = self.kProgressData[iRepeatTaskID]
            local iRepeatTimes = (kProgress and kProgress.iRepeatTimes) and kProgress.iRepeatTimes or 0
            local iRepeatLimit = kTask.RepetitiveTask or 0
            self.objRepeatTitle:GetComponent(l_DRCSRef_Type.Text).text = string.format("【重复任务】(%d/%d次)", iRepeatTimes, iRepeatLimit)
            setTaskHelper({iRepeatTaskID}, "VIPTask", self.objRepeatTasks, nil, true)
        end
    end
    self.objRepeatTasks:SetActive(bOpenRepeatTask)
    self.objRepeatTitle:SetActive(bOpenRepeatTask)
    if bOpenRepeatTask then
        self:RebuildRectTransform(self.rectTransRepeatTasks)
    end
    self:RebuildRectTransform(self.rectTransTaskContent)
    -- 设置数据
    self.taskID2Obj = taskID2Obj
    -- 设置底部栏
    self:UpdateBar()
end

-- 获取本期百宝书可重复任务
function TreasureBookTaskUI:GetBookRepeatTaskID()
    if not (self.kBookData and self.kBookData.TreasureBookTaskIDs) then
        return
    end
    local iBookID = self.kBookData.BaseID
    self.repeatTaskID = self.repeatTaskID or {}
    if self.repeatTaskID[iBookID] then
        return self.repeatTaskID[iBookID]
    end
    local kTaskMgr = nil
    for _, iTaskMgrID in ipairs(self.kBookData.TreasureBookTaskIDs) do
        kTaskMgr = TableDataManager:GetInstance():GetTableData("TreasureBookTaskPlan",iTaskMgrID)
        if kTaskMgr and kTaskMgr.RepeatTask and (kTaskMgr.RepeatTask > 0) then
            self.repeatTaskID[iBookID] = kTaskMgr.RepeatTask
            return kTaskMgr.RepeatTask
        end
    end
end

-- 设置底部栏
function TreasureBookTaskUI:UpdateBar()
    local info = self.bookManager:GetTreasureBookBaseInfo()
    if not (info and self.kBookData and self.iCurRound) then
        return
    end
    -- 日期
    self.textWeekthMsg.text = string.format("第%d期", self.iCurRound or 0)
    self.textDatethMsg.text = GetLanguageByID(self.kCurTaskManager.NameID)
    -- 每日银锭
    self.textBtnDialyMoney.text = string.format("每日银锭(%d)", info.iDialyGiftNum or 0)
    self.textBtnDialyMoneyGet.text = (info.bDayGiftGot == true) and "已领取" or "领取"
    if info.bDayGiftGot == true then
        self.textBtnDialyMoneyGet.text = "已领取"
        self.imgBtnDialyMoneyGet.material = self.grayMat
        self.objEffectBtnDialyMoney:SetActive(false)
    else
        self.textBtnDialyMoneyGet.text = "领取"
        self.imgBtnDialyMoneyGet.material = nil
        self.objEffectBtnDialyMoney:SetActive(true)
    end
    self.btnDialyMoney.interactable = info.bDayGiftGot ~= true
    self.objBtnDialyMoney:SetActive((info.bOpenDialyGift == true) and (self.bIsCurRound == true))
    -- 每周壕侠经验
    self.textBtnWeeklyExp.text = string.format("每周壕侠经验(%d)", self.kCurTaskManager.WeeklyRichmanExp or 0)
    local strBtn = "领取"
    local bShowEffect = true
    self.imgBtnWeeklyExpGet.material = nil
    if self.bIsPreRound then
        strBtn = "已过期"
        self.imgBtnWeeklyExpGet.material = self.grayMat
        bShowEffect = false
    elseif info.bWeekGiftGot == true then
        strBtn = "已领取"
        self.imgBtnWeeklyExpGet.material = self.grayMat
        bShowEffect = false
    end
    self.objEffectBtnWeeklyExp:SetActive(bShowEffect)
    self.textBtnWeeklyExpGet.text = strBtn
    self.btnWeeklyExp.interactable = (self.bIsCurRound == true) and (info.bWeekGiftGot ~= true)
    self.objBtnWeeklyExp:SetActive(self.bIsFutureRound ~= true)
    self.objBar:SetActive(true)
end

-- 点击切换到上一周的任务
function TreasureBookTaskUI:OnClickSwitchLeft()
    if self.iCurRound <= 1 then
        return
    end
    self.iCurRound = self.iCurRound - 1
    self:SetRoundTasks()
end

-- 点击切换到下一周的任务
function TreasureBookTaskUI:OnClickbwitchRight()
    if self.iCurRound >= self.iMaxRound then
        return
    end
    self.iCurRound = self.iCurRound + 1
    self:SetRoundTasks()
end

-- 点击领取每日银锭
function TreasureBookTaskUI:OnClickDialyMoney()
    SendQueryTreasureBookInfo(STBQT_FREE_REWARD, 1)
end

-- 点击领取每周经验
function TreasureBookTaskUI:OnClickWeeklyExp()
    if not self.kBookData then
        return
    end
    if self.bIsVIP ~= true then
        local msg = "此福利为壕侠玩家专属, 是否花费%d金锭激活壕侠百宝书, 解锁壕侠任务和壕侠加成, 并获得总价值超过50000银锭的奖励?"
        if self.kBookData.BeginDate and self.kBookData.EndDate then
            msg = msg .. string.format("\n\n本期百宝书持续时间为%d月%d日至%d月%d日。购买后可立即获得已解锁等级的所有壕侠奖励。"
            , self.kBookData.BeginDate.Month or 0, self.kBookData.BeginDate.Day or 0, self.kBookData.EndDate.Month or 0, self.kBookData.EndDate.Day or 0)
        end
        local content = {
            ['title'] = "解锁壕侠版",
            ['text'] = string.format(msg, self.kBookData.GoldCost or 0),
        }
        local boxCallback = function()
            TreasureBookDataManager:GetInstance():TryToBuyVIPForSelf(function()
                TreasureBookDataManager:GetInstance():RequestActiveBookVIP()
            end)
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, boxCallback})
        return
    end
    SendQueryTreasureBookInfo(STBQT_FREE_REWARD, 0)
end

function TreasureBookTaskUI:OnDestroy()
end

return TreasureBookTaskUI