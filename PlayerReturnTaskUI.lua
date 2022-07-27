PlayerReturnTaskUI = class("PlayerReturnTaskUI",BaseWindow)

function PlayerReturnTaskUI:ctor()
    
end

function PlayerReturnTaskUI:Create()
	local obj = LoadPrefabAndInit("PlayerReturnUI/PlayerReturnTaskUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function PlayerReturnTaskUI:Init()
    self.comProgressText =  self:FindChildComponent(self._gameObject,'Page_Task/Board/TaskProgress/Progress',DRCSRef_Type.Text)
    self.comProgressBar = self:FindChildComponent(self._gameObject,'Page_Task/Board/TaskProgress/Scrollbar',DRCSRef_Type.Scrollbar)
    self.comProgressBar.size = 0
    self.comTimeText = self:FindChildComponent(self._gameObject,'Page_Task/Board/TaskProgress/Tip',DRCSRef_Type.Text)
    self.objRewardNode = self:FindChild(self._gameObject,'Page_Task/Board/RewardMsg/Rewards/Viewport/Content').transform
    self.objTaskItemNode = self:FindChild(self._gameObject,'Page_Task/Board/Tasks/SC_task/Viewport/Content')
    self.objRewardItems = {}
    self.kDaysRewardItems = {}
    self.objDaysTask = {}
    self:AddEventListener("UpdatePlayerReturnData",function() 
        self.iUpdateFlag =  true
    end,nil,nil,nil,true )

    self:AddEventListener("UpdateActivityInfo",function() 
        self.iUpdatePrograss =  true
    end,nil,nil,nil,true )

    self.comDaysToggle = {}
    for i=1,7 do 
        local toggle = self:FindChildComponent(self._gameObject,"Page_Task/Days/Button_day"..i,DRCSRef_Type.Toggle)
        local iIndex = i
        local fun = function(isOn)
            if isOn then
                self:OnClickDaysToggle(iIndex)
                self.iCurChooseDayIndex = iIndex
            end
        end
        self.comDaysToggle[i] = toggle
        self:AddToggleClickListener(toggle,fun)
    end
    self.iCurChooseDayIndex = 1
end

function PlayerReturnTaskUI:RefreshUI()
    self.activityInfo = ActivityHelper:GetInstance():GetPlayerReturnInfo()
    if  self.activityInfo == nil then
        derror("无回流数据 开启了回流界面")
        return
    end

    self.activityBase = TableDataManager:GetInstance():GetTableData("ActivityBase",self.activityInfo.dwActivityID) 
    local kStartDate = os.date("*t", self.activityInfo.iValue3)
    self.iDffDay = os.date("*t").day - kStartDate.day  + 1 
    self.akPreExperienceData = ActivityHelper:GetInstance():GetPreExperienceData()
    self:OnClickDaysToggle(self.iCurChooseDayIndex)
    SendActivityOper(SAOT_REQUEST, self.activityBase.BaseID)
    SendQueryTreasureBookInfo(STBQT_TASK,0,STBTT_ACTIVITY_BACKFLOW)
end

function PlayerReturnTaskUI:SetDaysToggle()
    for i = 1,7 do
        self.comDaysToggle[i].interactable = self.iDffDay >= i
        local objLocked = self:FindChild(self.comDaysToggle[i].gameObject,"Locked")
        local comText = self:FindChildComponent(self.comDaysToggle[i].gameObject,"Text",DRCSRef_Type.Text)
        local isLock = self.iDffDay < i
        objLocked:SetActive(isLock)
        if isLock then
            comText.color = DRCSRef.Color(0.313, 0.313, 0.313, 1);
        else
            comText.color = DRCSRef.Color(0.235, 0.098, 0.058, 1);
        end
    end
end

function PlayerReturnTaskUI:SetProgressInfo()
    self.comProgressText.text = self.activityInfo.iValue1
    local iGotState = self.activityInfo.iValue2 or 0

    for k,rewardItem in ipairs(self.activityBase.RewardItems) do 
        local tempItemData = TableDataManager:GetInstance():GetTableData("Item",rewardItem.ItemId)
        if tempItemData then
            local kItem = self.objRewardItems[k]
            if kItem == nil then
                kItem =  LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.PlayerReturnRewardItemUI,self.objRewardNode)
                self.objRewardItems[k] = kItem
            end
            kItem:UpdateUIWithItemTypeData(tempItemData,true)
            kItem:SetItemNum(rewardItem.ItemNum)
            local iState = 0 --状态信息 0 未达成 1已达成未领取 2已领取
            local bGotReward = HasFlag(iGotState , k)
            if bGotReward then
                iState = 2
            else 
                local bValueEnough = self.activityInfo.iValue1 >= self.activityBase.RewardParams[k]   
                if bValueEnough then
                    iState = 1  
                end
            end
            kItem:SetProgressState(self.activityBase.RewardParams[k],iState,self.activityBase.BaseID,k)
        end
    end

    local iTotalValue = 0
    local iIndex = 0
    for k ,iTaskID in ipairs(self.activityBase.ParamTask) do
        local kTaskData = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
        if kTaskData then
            iTotalValue = iTotalValue + kTaskData.ExpHandsel
        end
    end
    self.comProgressBar.size = self.activityInfo.iValue1 / iTotalValue
end

function PlayerReturnTaskUI:SetTimeLeft()         
    local iDay,iHour = ActivityHelper:GetInstance():GetPlayerReturnTimeLeft()
    self.comTimeText.text = string.format("活动时间剩余%d天%d时",iDay,iHour)
end

function PlayerReturnTaskUI:OnClickDaysToggle(iDaysIndex)
    local iDaysTaskCount = 0
    local iItemCount = 0
    for k,v in ipairs(self.activityBase.ParamDay) do
        if v == iDaysIndex then
            local iTaskID = self.activityBase.ParamTask[k]
            local kTaskData = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
            if kTaskData then
                iDaysTaskCount = iDaysTaskCount + 1
                if  self.objDaysTask[iDaysTaskCount] == nil then
                    self.objDaysTask[iDaysTaskCount] = LoadPrefabAndInit("PlayerReturnUI/PlayerReturnDaysTaskItem",self.objTaskItemNode,true)
                end    
                local obj = self.objDaysTask[iDaysTaskCount]
                obj:SetActive(true)
                self:SetDaysTaskInfo(obj,kTaskData)

                local itemNode = self:FindChild(self.objDaysTask[iDaysTaskCount],"ItemIconNode")
                for kk,itemID in ipairs(kTaskData.ItemReward) do
                    iItemCount = iItemCount + 1
                    local kItem = self.kDaysRewardItems[iItemCount]
                    if kItem == nil then
                        kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemReward,itemNode.transform)
                        self.kDaysRewardItems[iItemCount] = kItem
                    else
                        kItem.transform:SetParent(itemNode.transform,false)
                    end
                    local tempItemData = TableDataManager:GetInstance():GetTableData("Item",itemID)
                    if tempItemData then
                        kItem:UpdateUIWithItemTypeData(tempItemData,true)
                        kItem:SetItemNum(kTaskData.ItemRewardSum[1])
                    end
                end
            else
                derror("回流活动 任务ID 不存在 "..iTaskID)
            end
        end
    end

    for i = iItemCount + 1,#self.kDaysRewardItems do
        LuaClassFactory:GetInstance():ReturnUIClass(self.kDaysRewardItems[i])
        self.kDaysRewardItems[i] = nil
    end

    for i = iDaysTaskCount + 1,#self.objDaysTask do
        self.objDaysTask[i]:SetActive(false)
    end
end

function PlayerReturnTaskUI:SetDaysTaskInfo(objTask,kTaskData)
    local comNameText = objTask:FindChildComponent("Progress/Title",DRCSRef_Type.Text)
    comNameText.text = GetLanguageByID(kTaskData.NameID)

    local iCompleteTime  = 0
    if self.akPreExperienceData[kTaskData.BaseID] then
        iCompleteTime = self.akPreExperienceData[kTaskData.BaseID].dwProgress
    end
    if iCompleteTime > kTaskData.TargetProgress then
        iCompleteTime = kTaskData.TargetProgress
    end
    local comValueText = objTask:FindChildComponent("Progress/Value",DRCSRef_Type.Text)
    comValueText.text = iCompleteTime .."/".. kTaskData.TargetProgress
    local comProgressBar = objTask:FindChildComponent('Progress',DRCSRef_Type.Scrollbar)
    comProgressBar.size = iCompleteTime / kTaskData.TargetProgress
    local isComplete = iCompleteTime >= kTaskData.TargetProgress
    local objYes = objTask:FindChild("State/Achieve")
    if objYes then
        objYes:SetActive(isComplete)
    end

    if kTaskData.TaskTypeA == TreasureTaskTypeA.TTTA_CumulativeTime and not isComplete then
        SendQueryTreasureBookInfo(STBQT_TASK,kTaskData.BaseID,STBTT_ACTIVITY)
    end 

    local objNo = objTask:FindChild("State/NotAchieve")
    if objNo then
        objNo:SetActive(not isComplete)
    end

    local objValueYes = objTask:FindChild("State/Exp/BackAchieve")
    if objValueYes then
        objValueYes:SetActive(isComplete)
    end
    
    local objValueNo = objTask:FindChild("State/Exp/BackNotAchieve")
    if objValueNo then
        objValueNo:SetActive(not isComplete)
    end

    local comExpValueText = objTask:FindChildComponent("Exp/Value",DRCSRef_Type.Text)
    comExpValueText.text = kTaskData.ExpHandsel
end

function PlayerReturnTaskUI:OnDestroy()
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.objRewardItems)
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.kDaysRewardItems)
end

function PlayerReturnTaskUI:OnEnable()
    OpenWindowBar({
        ['windowstr'] = "PlayerReturnTaskUI", 
        ['bSaveToCache'] = true,
    })
end

function PlayerReturnTaskUI:OnDisable()
    RemoveWindowBar('PlayerReturnTaskUI')
end


function PlayerReturnTaskUI:Update()
    if self.iUpdateFlag == true then
        self.iUpdateFlag = false
        self:OnClickDaysToggle(self.iCurChooseDayIndex)
    end

    if self.iUpdatePrograss == true then
        self.iUpdatePrograss = false
        self.iDffDay =   math.floor((GetCurServerTimeStamp() - self.activityInfo.iValue3) / 86400) + 1
        self.akPreExperienceData = ActivityHelper:GetInstance():GetPreExperienceData()
        self.activityInfo = ActivityHelper:GetInstance():GetPlayerReturnInfo()
        self:SetTimeLeft()
        self:SetDaysToggle()
        self:SetProgressInfo()
    end
end

return PlayerReturnTaskUI
