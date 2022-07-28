ActivityUI = class("ActivityUI",BaseWindow)

local PHONE_NUMS_COLLECT_ID = 40001
local WEIBO_COLLECT_ID = 40004

function ActivityUI:ctor()
    self.iCurTabIndex = 1
    self.iCurChooseType = 1
    self.iCurActivityID = 0
    self.akShowActivityData = {}
end

function ActivityUI:Create()
	local obj = LoadPrefabAndInit("ActivityUI/ActivityUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ActivityUI:Init()
    self.comTabScrollRect = self:FindChildComponent(self._gameObject,"ActivityTabel/SC_activitys",DRCSRef_Type.LoopVerticalScrollRect)
    if self.comTabScrollRect then
        local fun = function(transform, idx)
            self:OnTabScrollChanged(transform, idx)
        end
        self.comTabScrollRect:AddListener(fun)
    end
    self.akPreExperienceData = ActivityHelper:GetInstance():GetPreExperienceData()
    self.comToggleGroup = self.comTabScrollRect.gameObject:GetComponent(DRCSRef_Type.ToggleGroup)
    self.objDefaultActivity =  self:FindChild(self._gameObject,"ActivityPanel/DefaultActivity")
    self.iUpdateFlag = 0

    self:AddEventListener("QueryActivityRet",function(kRetData) 
        local activityBase = TableDataManager:GetInstance():GetTableData("ActivityBase",kRetData.dwActivityID) 
        if activityBase and activityBase.Type == self.iCurChooseType then
            self.iUpdateFlag = SetFlag(self.iUpdateFlag,self.iCurChooseType) 
        end
    end,nil,nil,nil,true )

    self:AddEventListener("UpdatePreExperienceData",function() 
        if self.iCurChooseType == ActivityType.ACCT_PreExperience then
            self.iUpdateFlag = SetFlag(self.iUpdateFlag , ActivityType.ACCT_PreExperience) 
        end
    end,nil,nil,nil,true )


    self:AddEventListener("UpdateActivityInfo",function() 
       self.bNeedRefreshUI = true
    end,nil,nil,nil,true )
    
    
    self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))

    --跳转ui
    self.objActivityNode = {}
    self.objJumpUIActivityNode = self:FindChild(self._gameObject,"ActivityPanel/JumpUIActivity")
    self.objActivityNode[ActivityType.ACCT_ToUI] = self.objJumpUIActivityNode
    self:InitJumpUINode()
    
    --跳转网页
    self.objJumpWebActivityNode = self:FindChild(self._gameObject,"ActivityPanel/JumpWebActivity")
    self.objActivityNode[ActivityType.ACCT_ToWebsite] = self.objJumpWebActivityNode
    self:InitJumpWebNode()

    -- ACCT_PreExperience = 6; -- 预先体验
    self.objPreExperienceNode = self:FindChild(self._gameObject,"ActivityPanel/PreExperience")
    self.objActivityNode[ActivityType.ACCT_PreExperience] = self.objPreExperienceNode
    self:InitPreExperience()

    -- 百宝书满赠活动
    self.objTreasureBookBuyGiftNode = self:FindChild(self._gameObject,"ActivityPanel/TreasureBookBuyGiftActivity")
    self.objActivityNode[ActivityType.ACCT_TreasureBookBuyGift] = self.objTreasureBookBuyGiftNode
    self:InitTreasureBookBuyGiftNode()

    -- 剧本内活动
    self.objScriptActivityNode = self:FindChild(self._gameObject,"ActivityPanel/ScriptActivity")
    self.objActivityNode[ActivityType.ACCT_ScriptShow] = self.objScriptActivityNode

    --秘宝大会
    self.objTreasureActivityNode = self:FindChild(self._gameObject,"ActivityPanel/TreasureActivity")
    self.objActivityNode[ActivityType.ACCT_TreasureExchange] = self.objTreasureActivityNode

    --擂台助力
    self.objArenaAssistActivityNode = self:FindChild(self._gameObject,"ActivityPanel/ArenaAssistActivity")
    self.objActivityNode[ActivityType.ACCT_ArenaAssist] = self.objArenaAssistActivityNode

    self:AddEventListener('ONEVENT_REF_SHOPDATA', function(info)
        if not (self.akShowActivityData and self.iCurTabIndex) then
            return
        end
        local kActivityData = self.akShowActivityData[self.iCurTabIndex]
        if not kActivityData then
            return
        end
        if self.iCurChooseType == ActivityType.ACCT_TreasureBookBuyGift then
            self:ShowTreasureBookBuyGiftNode(kActivityData)
        end
    end)

    self:HideAllActivityNode()

end

function ActivityUI:InitPreExperience()
    self.comPreExperienceBG = self.objPreExperienceNode:FindChildComponent("Image_ad",DRCSRef_Type.Image)
    self.comPreExperienceTimeText = self.objPreExperienceNode:FindChildComponent("Text_Time",DRCSRef_Type.Text)
    self.comPreExperienceDescText = self.objPreExperienceNode:FindChildComponent("Text_Desc",DRCSRef_Type.Text)

    self.comPreExperienceScrollRect = self.objPreExperienceNode:FindChildComponent("SC_TreasureExchange",DRCSRef_Type.LoopVerticalScrollRect)
    if self.comPreExperienceScrollRect then
        local fun = function(transform, idx)
            self:OnPreExperienceChanged(transform, idx)
        end
        self.comPreExperienceScrollRect:AddListener(fun)
    end

    self.comPreExperienceBar = self.objPreExperienceNode:FindChildComponent("Process/Slider",DRCSRef_Type.Slider)
    self.comPreExperienceBar.value = 0
    self.comPreExperienceText = self.objPreExperienceNode:FindChildComponent("Process/Slider/Handle Slide Area/Handle/Text",DRCSRef_Type.Text)
    self.comPreExperienceText.text = 0
    self.objPreExperienceReward = {}

    self.objRewardClone = self.objPreExperienceNode:FindChild("Process/RewardItem")
    self.objRewardClone:SetActive(false)
    self.objRewardItems = {}
end

function ActivityUI:InitJumpUINode()
    local button = self.objJumpUIActivityNode:FindChildComponent("BG",DRCSRef_Type.Button)
    if button then
        self:AddButtonClickListener(button, function()
           self:JumpToUI()
        end)
    end

    self.comJumpUIBg = self.objJumpUIActivityNode:FindChildComponent("BG",DRCSRef_Type.Image)
    self.comJumpUITimeText = self.objJumpUIActivityNode:FindChildComponent("Text_Time",DRCSRef_Type.Text)
    self.comJumpUIDescText = self.objJumpUIActivityNode:FindChildComponent("Text_Desc",DRCSRef_Type.Text)
end

function ActivityUI:InitJumpWebNode()
    local button = self.objJumpWebActivityNode:FindChildComponent("BG",DRCSRef_Type.Button)
    if button then
        self:AddButtonClickListener(button, function()
           self:JumpToWeb()
        end)
    end
    self.comJumpWebBg = self.objJumpWebActivityNode:FindChildComponent("BG",DRCSRef_Type.Image)
    self.comJumpWebTimeText = self.objJumpWebActivityNode:FindChildComponent("Text_Time",DRCSRef_Type.Text)
    self.comJumpWebDescText = self.objJumpWebActivityNode:FindChildComponent("Text_Desc",DRCSRef_Type.Text)
    self.objJumpWetTimeText1 = self.objJumpWebActivityNode:FindChild("Text")
end

function ActivityUI:InitTreasureBookBuyGiftNode()
    -- self.comTreasureBookBg = self.objTreasureBookBuyGiftNode:FindChildComponent("BG",DRCSRef_Type.Image)

    local objBuy1 = self:FindChild(self.objTreasureBookBuyGiftNode, "Button_buy1")
    local objBuy2 = self:FindChild(self.objTreasureBookBuyGiftNode, "Button_buy2")
    self.btnTreasureBookBuy1 = objBuy1:GetComponent(DRCSRef_Type.Button)
    self.btnTreasureBookBuy2 = objBuy2:GetComponent(DRCSRef_Type.Button)

    self:RemoveButtonClickListener(self.btnTreasureBookBuy1)
    self:AddButtonClickListener(self.btnTreasureBookBuy1, function()
        if (not self.uiTreasureBookBuyPrice1)
        or (not self.uiTreasureBookMallItemBaseID1) then
            return
        end
        PlayerSetDataManager:GetInstance():RequestSpendGold(
            self.uiTreasureBookBuyPrice1, 
            function()
                SendPlatShopMallBuyItem(self.uiTreasureBookMallItemBaseID1, 1)
            end,
            true
        )
    end)

    self:RemoveButtonClickListener(self.btnTreasureBookBuy2)
    self:AddButtonClickListener(self.btnTreasureBookBuy2, function()
        if (not self.uiTreasureBookBuyPrice2)
        or (not self.uiTreasureBookMallItemBaseID2) then
            return
        end
        PlayerSetDataManager:GetInstance():RequestSpendGold(
            self.uiTreasureBookBuyPrice2, 
            function()
                SendPlatShopMallBuyItem(self.uiTreasureBookMallItemBaseID2, 1)
            end,
            true
        )
    end)

    self.objImgTreasureBookNormal1 = self:FindChild(objBuy1, "BacNormal")
    self.objImgTreasureBookGray1 = self:FindChild(objBuy1, "BacNormalGray")
    self.objImgTreasureBookNormal2 = self:FindChild(objBuy2, "BacNormal")
    self.objImgTreasureBookGray2 = self:FindChild(objBuy2, "BacNormalGray")

    self.textTreasureBookBtn1 = self:FindChildComponent(self.objTreasureBookBuyGiftNode, "Button_buy1/Text", DRCSRef_Type.Text)
    self.textTreasureBookBuy1 = self:FindChildComponent(self.objTreasureBookBuyGiftNode, "Button_buy1/Text_num", DRCSRef_Type.Text)
    self.textTreasureBookBtn2 = self:FindChildComponent(self.objTreasureBookBuyGiftNode, "Button_buy2/Text", DRCSRef_Type.Text)
    self.textTreasureBookBuy2 = self:FindChildComponent(self.objTreasureBookBuyGiftNode, "Button_buy2/Text_num", DRCSRef_Type.Text)
end

function ActivityUI:HideAllActivityNode()
    if not self.objActivityNode then
        return
    end
    for eType, uiNode in pairs(self.objActivityNode) do
        uiNode:SetActive(false)
    end
end

function ActivityUI:RefreshUI(info)
    self.akShowActivityData, self.kActivityIndexCache, bActivityChanged = ActivityHelper:GetInstance():GetShowActivity(self.kActivityIndexCache)
    if info and info.dontRequest == true then
    
    else
        SendQueryTreasureBookInfo(STBQT_TASK,0,STBTT_ACTIVITY)
    end
    if bActivityChanged then
        -- gen map of activity type to tab index
        self.kType2Index = {}
        self.iCurTabIndex = 1
        for index, kActivity in ipairs(self.akShowActivityData) do
            local eType = kActivity.Type
            if eType and (not self.kType2Index[eType]) then
                if info and (info.type == eType) then
                    self.iCurTabIndex = index
                end
                self.kType2Index[eType] = index
            end
        end
        self.comTabScrollRect.totalCount = #self.akShowActivityData
        self.comTabScrollRect:RefillCells()
        if #self.akShowActivityData > 0 then
            self:OnClickTab(self.iCurTabIndex)
        else
            self:HideAllActivityNode()
        end
    elseif self.kType2Index and info and info.type and self.kType2Index[info.type] then
        self.iCurTabIndex = self.kType2Index[info.type]
        self.comTabScrollRect:RefreshCells()
        self:OnClickTab(self.iCurTabIndex)
    elseif self.iCurTabIndex then
        self.dontRequestAcitvity = true
        self:OnClickTab(self.iCurTabIndex)
        self.comTabScrollRect:RefreshCells()
        self.dontRequestAcitvity = false
    end
end

function ActivityUI:OnTabScrollChanged(transform,idx)
    local objTab = transform.gameObject
    local iTabIndex = idx + 1
    local comText = objTab:FindChildComponent("Lab",DRCSRef_Type.Text)
    local objRedPoint = objTab:FindChild("Image_redPoint")

    if comText then
        comText.text = self.akShowActivityData[iTabIndex].Name
    end

    if objRedPoint then
        local showRedPoint = ActivityHelper:GetInstance():CheckActivityRedPoint(self.akShowActivityData[iTabIndex].BaseID)
        objRedPoint:SetActive(showRedPoint)
    end

    local comToggle = objTab:GetComponent(DRCSRef_Type.Toggle)
    if comToggle then
        comToggle.isOn = iTabIndex == self.iCurTabIndex
        local fun = function(isOn)
            if isOn then
                self:OnClickTab(iTabIndex)
            end
        end
        comToggle.group = self.comToggleGroup
        self:RemoveToggleClickListener(comToggle)
        self:AddToggleClickListener(comToggle,fun)
    end
end

function ActivityUI:OnClickTab(iChooseIndex)
    if self.iCurChooseType ~= 0 then
        local objNode = self.objActivityNode[self.iCurChooseType]
        if objNode == nil then
            objNode = self.objDefaultActivity
        end
        objNode:SetActive(false)
    end
    
    self.iCurTabIndex = iChooseIndex
    local activityData = self.akShowActivityData[self.iCurTabIndex]
    if not activityData then
        return
    end

    self.iCurChooseType = activityData.Type
    self.iCurActivityID = activityData.BaseID
    if self.iCurChooseType == ActivityType.ACCT_ToUI then
        self:ShowJumpUINode(activityData)
    elseif self.iCurChooseType == ActivityType.ACCT_ToWebsite then
        self:ShowJumpWebNode(activityData)
    elseif self.iCurChooseType == ActivityType.ACCT_PreExperience then
        if not self.dontRequestAcitvity then
            SendActivityOper(SAOT_REQUEST, activityData.BaseID)
        end
        self:ShowPreExperience(activityData)
    elseif self.iCurChooseType == ActivityType.ACCT_TreasureBookBuyGift then
        self:ShowTreasureBookBuyGiftNode(activityData)
    elseif self.iCurChooseType == ActivityType.ACCT_Fund then
        --self:ShowFundActivityNode(activityData)
        OpenWindowImmediately("FundUI",activityData)
    elseif  self.iCurChooseType == ActivityType.ACCT_ScriptShow then-- 剧本内活动
        self:ShowScriptACtivity(activityData)
    elseif self.iCurChooseType == ActivityType.ACCT_TreasureExchange then
        self:ShowTreasureExchangeActivity(activityData)
    elseif self.iCurChooseType == ActivityType.ACCT_ArenaAssist then
        self:ShowArenaAssistActivity(activityData)
    else
        -- 保底显示 类型活动没有 都显示个默认的 正常情况下 不会有这个
        self:ShowDefaultUINode(activityData)
    end

    if (self.iCurChooseType ~= ActivityType.ACCT_Fund) then
        local FundUI = GetUIWindow("FundUI")
        if FundUI then
            RemoveWindowImmediately("FundUI")
        end
    end

end


function ActivityUI:OnPreExperienceChanged(transform,idx)
    local objItem = transform.gameObject
    local kActivityData = self.akShowActivityData[self.iCurTabIndex]
    if not kActivityData then
        return
    end
    local iTaskIndex = idx + 1
    local iTaskID = kActivityData.ParamN[iTaskIndex]
    local kTaskData = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
    if not kTaskData then
        return
    end

    local comNameText = objItem:FindChildComponent("Text_name",DRCSRef_Type.Text)
    if comNameText then
        comNameText.text = kTaskData.TaskTitle
    end

    local iCompleteTime  = 0
    if self.akPreExperienceData[iTaskID] then
        iCompleteTime = self.akPreExperienceData[iTaskID].dwRepeatFinishNum
    end
    local comNumText = objItem:FindChildComponent("Text_num",DRCSRef_Type.Text)
    if comNumText then
        comNumText.text = iCompleteTime.."/"..kTaskData.RepetitiveTask
    end

    local comFavorText = objItem:FindChildComponent("Text_favor",DRCSRef_Type.Text)
    if comFavorText then
        comFavorText.text = (iCompleteTime * kTaskData.ExpHandsel) .."/".. (kTaskData.RepetitiveTask * kTaskData.ExpHandsel)
    end
     
    local objNo = objItem:FindChild("TaskState/No")
    if objNo then
        objNo:SetActive(iCompleteTime < kTaskData.RepetitiveTask)
    end

    local objYes = objItem:FindChild("TaskState/Yes")
    if objYes then
        objYes:SetActive(iCompleteTime >= kTaskData.RepetitiveTask)
    end

    local comImage = objItem:FindChildComponent("Item/Icon",DRCSRef_Type.Image)
    if comImage then
        self:SetSpriteAsync(kTaskData.TaskIcon,comImage)
    end

    local button = objItem:FindChildComponent("Image_bg",DRCSRef_Type.Button)
    if button then
        self:RemoveButtonClickListener(button)
        self:AddButtonClickListener(button, function() 
            local content = "任务描述:"..GetLanguageByID(kTaskData.NameID)
            if self.akPreExperienceData and self.akPreExperienceData[iTaskID] then
                local curNum = string.format("（%d/%d）", self.akPreExperienceData[iTaskID].dwProgress, kTaskData.TargetProgress)
                content = content..curNum
            end

            OpenWindowImmediately("ActivityTipsUI", {
                ['IconPath'] = kTaskData.TaskIcon,
                ['CompleteTimes'] = iCompleteTime.."/"..kTaskData.RepetitiveTask ,
                ['Time'] = self:GetActivityTimeStr(self.akShowActivityData[self.iCurTabIndex]),
                ["Favor"] = kTaskData.ExpHandsel * kTaskData.RepetitiveTask,
                ["Title"] = kTaskData.TaskTitle,
                ["Content"] = content,
            })
        end)
    end
end

function ActivityUI:OnClickPreExperienceReward(rewardIndex)
    local activityInfo =  ActivityHelper:GetInstance():GetActivityInfo(self.iCurActivityID)
    local iCurValue = activityInfo.iValue1 or 0
    local iGotState = activityInfo.iValue2 or 0
    local activityData = self.akShowActivityData[self.iCurTabIndex]
    if iCurValue ~= 0 then
        local bValueEnough = iCurValue >= activityData.RewardParams[rewardIndex]
        local bGotReward = HasFlag(iGotState ,(rewardIndex - 1))
        if bValueEnough and not bGotReward then
            SendActivityOper(SAOT_EVENT, self.iCurActivityID, SATET_PREEXP_RECEIVE, rewardIndex -1)
            SendActivityOper(SAOT_REQUEST, activityData.BaseID)
        else
            local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",activityData.RewardItems[rewardIndex].ItemId)
            local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, kItemTypeData)
            OpenWindowImmediately("TipsPopUI", tips)
        end
    else
        local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",activityData.RewardItems[rewardIndex].ItemId)
        local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, kItemTypeData)
        OpenWindowImmediately("TipsPopUI", tips)
    end
end

--显示预先体验类型活动
function ActivityUI:ShowPreExperience(activityData)
    if activityData == nil then
        return
    end
    self.objPreExperienceNode:SetActive(true)

    self.comPreExperienceBG.sprite = GetSprite(activityData.ActPic)
    self.comPreExperienceDescText.text = activityData.Description

	local uiColorTagIndex, uiMsgIndex, strColorTag, strMsg = string.find(activityData.Description, "(<color=.+>)(.*)</color>")
	strColorTag = strColorTag or ""
    strColorCloseTag = (strColorTag == "") and "" or "</color>"
    self.comPreExperienceTimeText.text = string.format("%s%s%s", strColorTag, self:GetActivityTimeStr(activityData), strColorCloseTag)

    if activityData.ParamN then
        self.comPreExperienceScrollRect.totalCount = #activityData.ParamN
    else    
        self.comPreExperienceScrollRect.totalCount = 0
    end 
 
    self.comPreExperienceScrollRect:RefillCells()

    self:SetPreExperienceRewardNode(activityData)
end

function ActivityUI:ShowPreExperienceTips()
    
end

--设置下方奖励显示
function ActivityUI:SetPreExperienceRewardNode(activityData)
    local iTotalValue = 0
    if activityData.ParamN then
        for k,iTaskID in ipairs(activityData.ParamN) do
            local kTaskData = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
            if  kTaskData then
                iTotalValue = iTotalValue + kTaskData.RepetitiveTask * kTaskData.ExpHandsel
            end
        end
    end

    local iDefalutWidth = 1000
    local activityInfo =  ActivityHelper:GetInstance():GetActivityInfo(activityData.BaseID)
    local iCurValue = activityInfo.iValue1 or 0
    local iGotState = activityInfo.iValue2 or 0

    local iCount = (activityData.RewardParams and #activityData.RewardParams or 0)
    for i = 1 ,iCount do
        local objItem = self.objRewardItems[i] 
        if objItem == nil then
            objItem = CloneObj(self.objRewardClone,self.objRewardClone.transform.parent)
            self.objRewardItems[i]  = objItem

            local button = objItem:FindChildComponent("Item",DRCSRef_Type.Button)
            if button then
                self:AddButtonClickListener(button, function() 
                    self:OnClickPreExperienceReward(i)
                end)
            end
        end

        local comFavorText = objItem:FindChildComponent("Text_favor",DRCSRef_Type.Text)
        if comFavorText then
            comFavorText.text = activityData.RewardParams[i]
        end      
        local comNumText = objItem:FindChildComponent("Item/Num",DRCSRef_Type.Text)
        if comNumText then
            comNumText.gameObject:SetActive(activityData.RewardItems[i].ItemNum > 1 )
            comNumText.text = activityData.RewardItems[i].ItemNum
        end

        local comIconImage  = objItem:FindChildComponent("Item/Icon",DRCSRef_Type.Image)
        if comIconImage then
            local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",activityData.RewardItems[i].ItemId)
            if kItemTypeData then
                comIconImage.sprite = GetSprite(kItemTypeData.Icon)
            end
        end

        local bValueEnough = iCurValue >= activityData.RewardParams[i]
        local bGotReward = HasFlag(iGotState ,(i - 1))

        local objGetReward = objItem:FindChild("Item/GotReward")
        if objGetReward then
            if bGotReward then
                comIconImage.material = self.grayMat
            else
                comIconImage.material = nil
            end
        end

        local objGetReward = objItem:FindChild("Item/Lighteffet")
        if objGetReward then
            objGetReward:SetActive(bValueEnough and not bGotReward)
        end

        objItem:SetActive(true)
        objItem:SetObjLocalPosition(iDefalutWidth /(iCount + 1) * i,0,0)
    end

    self.comPreExperienceBar.value = iCurValue / iTotalValue
    self.comPreExperienceText.text = iCurValue
    
    for i = iCount+1,#self.objRewardItems do
        local objItem = self.objRewardItems[i] 
        if objItem then
            objItem:SetActive(false)
        end
    end
end

function ActivityUI:ShowScriptACtivity(activityData)
    if activityData == nil then
        return
    end
    self.objScriptActivityNode:SetActive(true)
    local comJumpUIBg = self.objScriptActivityNode:FindChildComponent("BG",DRCSRef_Type.Image)
    if comJumpUIBg then
        comJumpUIBg.sprite = GetSprite(activityData.ActPic)
    end

    local comJumpUITimeText = self.objScriptActivityNode:FindChildComponent("Text_Time",DRCSRef_Type.Text)
    if comJumpUITimeText then
        local uiColorTagIndex, uiMsgIndex, strColorTag, strMsg = string.find(activityData.Description, "(<color=.+>)(.*)</color>")
        strColorTag = strColorTag or ""
        strColorCloseTag = (strColorTag == "") and "" or "</color>"
        comJumpUITimeText.text = string.format("%s%s%s", strColorTag, self:GetActivityTimeStr(activityData), strColorCloseTag)
    end

    local comJumpUIDescText = self.objScriptActivityNode:FindChildComponent("Text_Desc",DRCSRef_Type.Text)
    if comJumpUIDescText then
        comJumpUIDescText.text = activityData.Description
    end
end


function ActivityUI:ShowTreasureExchangeActivity(activityData)
    if activityData == nil then
        return
    end
    self.objTreasureActivityNode:SetActive(true)
    local comJumpUIBg = self.objTreasureActivityNode:FindChildComponent("BG",DRCSRef_Type.Image)
    if comJumpUIBg then
        comJumpUIBg.sprite = GetSprite(activityData.ActPic)
    end

    local comJumpUITimeText = self.objTreasureActivityNode:FindChildComponent("Image/Text_Time",DRCSRef_Type.Text)
    if comJumpUITimeText then
        comJumpUITimeText.text = self:GetActivityTimeStr(activityData,false)
    end

    local comJumpUIDescText = self.objTreasureActivityNode:FindChildComponent("Image/Text_Desc",DRCSRef_Type.Text)
    if comJumpUIDescText then
        comJumpUIDescText.text = activityData.Description
    end

    local comTimeText1 = self.objTreasureActivityNode:FindChildComponent("Text_Time1",DRCSRef_Type.Text)
    local comTimeText2 = self.objTreasureActivityNode:FindChildComponent("Text_Time2",DRCSRef_Type.Text)
    if activityData.TitleColor ~= "" and activityData.TitleColor ~= nil then
        comTimeText1.text = string.format("<color=#%s>活动时间</color>" , activityData.TitleColor) 
        comTimeText2.text = string.format("<color=#%s>活动入口</color>" , activityData.TitleColor) 
    else
        comTimeText1.text = "活动时间"
        comTimeText2.text = "活动入口"
    end
end

function ActivityUI:ShowArenaAssistActivity(activityData)
    if activityData == nil then
        return
    end
    self.objArenaAssistActivityNode:SetActive(true)
    local comJumpUIBg = self.objArenaAssistActivityNode:FindChildComponent("BG",DRCSRef_Type.Image)
    if comJumpUIBg then
        comJumpUIBg.sprite = GetSprite(activityData.ActPic)
    end

    local comJumpUITimeText = self.objArenaAssistActivityNode:FindChildComponent("Text_Time",DRCSRef_Type.Text)
    if comJumpUITimeText then
        local uiColorTagIndex, uiMsgIndex, strColorTag, strMsg = string.find(activityData.Description, "(<color=.+>)(.*)</color>")
        strColorTag = strColorTag or ""
        strColorCloseTag = (strColorTag == "") and "" or "</color>"
        comJumpUITimeText.text = string.format("%s【比赛时间】%d月%d日%s",strColorTag,activityData.StartDate.Month,activityData.StartDate.Day,strColorCloseTag)
    end

    local comJumpUIDescText = self.objArenaAssistActivityNode:FindChildComponent("Text_Desc",DRCSRef_Type.Text)
    if comJumpUIDescText then
        comJumpUIDescText.text = activityData.Description
    end
end

function ActivityUI:ShowDefaultUINode(activityData)
    if activityData == nil then
        return
    end
    self.objDefaultActivity:SetActive(true)
    local comJumpUIBg = self.objDefaultActivity:FindChildComponent("BG",DRCSRef_Type.Image)
    if comJumpUIBg then
        comJumpUIBg.sprite = GetSprite(activityData.ActPic)
    end

    local comJumpUITimeText = self.objDefaultActivity:FindChildComponent("Text_Time",DRCSRef_Type.Text)
    if comJumpUITimeText then
        if  self.iCurChooseType == ActivityType.ACCT_TreasureExchange then
            local uiColorTagIndex, uiMsgIndex, strColorTag, strMsg = string.find(activityData.Description, "(<color=.+>)(.*)</color>")
            strColorTag = strColorTag or ""
            strColorCloseTag = (strColorTag == "") and "" or "</color>"
            comJumpUITimeText.text = string.format("%s%s%s", strColorTag, self:GetActivityTimeStr(activityData), strColorCloseTag)
        else
            comJumpUITimeText.text = self:GetActivityTimeStr(activityData,false)
        end
    end

    local comJumpUIDescText = self.objDefaultActivity:FindChildComponent("Text_Desc",DRCSRef_Type.Text)
    if comJumpUIDescText then
        comJumpUIDescText.text = activityData.Description
    end
end

function ActivityUI:ShowJumpUINode(activityData)
    if activityData == nil then
        return
    end
    self.objJumpUIActivityNode:SetActive(true)
    
    local sprite = GetSprite(activityData.ActPic)
    if sprite ~= nil then
        self.comJumpUIBg.sprite = sprite
    end
    -- self.comJumpUITimeText.text = self:GetActivityTimeStr(activityData)
    -- self.comJumpUIDescText.text = activityData.Description
end

function ActivityUI:ShowJumpWebNode(activityData)
    if activityData == nil then
        return
    end
    self.objJumpWebActivityNode:SetActive(true)
    
    self.comJumpWebBg.sprite = GetSprite(activityData.ActPic)
    --超过2年的时间不显示
    -- local bShow = ActivityHelper.GetDiffDayByDate(activityData) < 365 * 2
    -- self.comJumpWebTimeText.gameObject:SetActive(bShow)
    -- self.objJumpWetTimeText1:SetActive(bShow)
    -- self.comJumpWebTimeText.text = self:GetActivityTimeStr(activityData)
    -- self.comJumpWebDescText.text = activityData.Description
end

function ActivityUI:ShowTreasureBookBuyGiftNode(activityData)
    if not activityData then
        return
    end

    -- self.comTreasureBookBg.sprite = GetSprite(activityData.ActPic)
    self.uiTreasureBookMallItemBaseID1 = activityData.Param1 or 0
    self.uiTreasureBookMallItemBaseID2 = activityData.Param2 or 0

    local kMallInstItem1 = ShoppingDataManager:GetInstance():GetShopDataBy(self.uiTreasureBookMallItemBaseID1)
    local kMallInstItem2 = ShoppingDataManager:GetInstance():GetShopDataBy(self.uiTreasureBookMallItemBaseID2)

    if not (kMallInstItem1 and kMallInstItem2) then
        return
    end

    local kMallBaseItem1 = TableDataManager:GetInstance():GetTableData("Rack", self.uiTreasureBookMallItemBaseID1)
    local kMallBaseItem2 = TableDataManager:GetInstance():GetTableData("Rack", self.uiTreasureBookMallItemBaseID2)

    local bBuy1Enable = (kMallInstItem1 ~= nil) and (kMallInstItem1.iCanBuyCount > 0)
    self.btnTreasureBookBuy1.interactable = bBuy1Enable
    self.objImgTreasureBookNormal1:SetActive(bBuy1Enable)
    self.objImgTreasureBookGray1:SetActive(not bBuy1Enable)
    self.textTreasureBookBtn1.text = bBuy1Enable and "购买" or "已购买"

    local bBuy2Enable = (kMallInstItem2 ~= nil) and (kMallInstItem2.iCanBuyCount > 0)
    self.btnTreasureBookBuy2.interactable = bBuy2Enable
    self.objImgTreasureBookNormal2:SetActive(bBuy2Enable)
    self.objImgTreasureBookGray2:SetActive(not bBuy2Enable)
    self.textTreasureBookBtn2.text = bBuy2Enable and "购买" or "已购买"

    self.uiTreasureBookBuyPrice1 = nil
    self.uiTreasureBookBuyPrice2 = nil
    if kMallBaseItem1 then
        self.uiTreasureBookBuyPrice1 = math.ceil((kMallBaseItem1.OriginValue or 0) * (kMallBaseItem1.Discount or 0) * 0.01)
        self.textTreasureBookBuy1.text = tostring(self.uiTreasureBookBuyPrice1)
    end
    if kMallBaseItem2 then
        self.uiTreasureBookBuyPrice2 = math.ceil((kMallBaseItem2.OriginValue or 0) * (kMallBaseItem2.Discount or 0) * 0.01)
        self.textTreasureBookBuy2.text = tostring(self.uiTreasureBookBuyPrice2)
    end

    self.objTreasureBookBuyGiftNode:SetActive(true)
end

function ActivityUI:GetActivityTimeStr(activityData,bShow)
    local str = nil
    if bShow == false then
        str = string.format("%d月%d日%02d:%02d - %d月%d日%02d:%02d",
        activityData.StartDate.Month,activityData.StartDate.Day,activityData.StartTime.Hour,activityData.StartTime.Minute,
        activityData.StopDate.Month,activityData.StopDate.Day,activityData.StopTime.Hour,activityData.StopTime.Minute)
    else
        
        str = string.format("活动时间：%d月%d日%02d:%02d - %d月%d日%02d:%02d",
        activityData.StartDate.Month,activityData.StartDate.Day,activityData.StartTime.Hour,activityData.StartTime.Minute,
        activityData.StopDate.Month,activityData.StopDate.Day,activityData.StopTime.Hour,activityData.StopTime.Minute)
    end
    return str
end

function ActivityUI:Update()
    if self.iUpdateFlag ~= 0 then
        if HasFlag(self.iUpdateFlag, ActivityType.ACCT_PreExperience)  then
            if self.iCurChooseType == ActivityType.ACCT_PreExperience then
                local activityData = self.akShowActivityData[self.iCurTabIndex]
                self:ShowPreExperience(activityData)
            end
        end     
        self.iUpdateFlag = 0
    end

    if self.bNeedRefreshUI == true then
        self.bNeedRefreshUI = false
        self:RefreshUI({dontRequest = true})
    end
end

function ActivityUI:OnEnable()
    OpenWindowBar({
        ['windowstr'] = "ActivityUI", 
        ['bSaveToCache'] = true,
    })
end

function ActivityUI:OnDisable()
    RemoveWindowBar('ActivityUI')
    RemoveWindowImmediately('ActivityTipsUI')
    local FundUI = GetUIWindow("FundUI")
    local ChallengeOrderUI = GetUIWindow("ChallengeOrderUI")
    local ShoppingMallUI = GetUIWindow("ShoppingMallUI")
    if FundUI and (not ChallengeOrderUI or (ChallengeOrderUI and not ChallengeOrderUI:IsOpen())) and (not ShoppingMallUI or (ShoppingMallUI and not ShoppingMallUI:IsOpen())) then
        RemoveWindowImmediately("FundUI")
    end
end

function ActivityUI:JumpToUI()
    local activityData = self.akShowActivityData[self.iCurTabIndex]
    if activityData then
        if ActivityHelper.IsInActivityTime(activityData) then
            OpenWindowImmediately(activityData.ToWhere)   
        else
            SystemUICall:GetInstance():Toast('活动已结束')
        end
    end
end

--网页跳转
function ActivityUI:JumpToWeb()
    local activityData = self.akShowActivityData[self.iCurTabIndex]
    if activityData then
        if ActivityHelper.IsInActivityTime(activityData) then
            local url = self:GetActivityWebUrl(activityData)
            if (url and url ~= '') then
                -- 活动针对安卓特殊处理,主干上无需这样改,主干已经是最终解决方案了,colourstar 2020/10/30
                if (MSDK_OS == 1 and activityData.BaseID == WEIBO_COLLECT_ID) then
                    local weibourl = "https://weibo.com/p/100808de8632f47c53636bb1009e6a50d9a003"
                    DRCSRef.MSDKWebView.OpenUrl(weibourl)
                else
                    DRCSRef.MSDKWebView.OpenUrl(url)
                end
            end
        else
            SystemUICall:GetInstance():Toast('活动已结束')
        end  
    end
end

function ActivityUI:GetActivityWebUrl(activityData)
    if (not activityData) then
        return nil
    end

    local url = activityData.ToWhere
    if (activityData.BaseID == PHONE_NUMS_COLLECT_ID) then
        local platid = 1
        if (MSDK_OS == 2) then platid = 0 end
        local appid = 0
        if (MSDKHelper:IsLoginWeChat()) then
            appid = "wx8b048cb88ea98f1d"
        end
        if (MSDKHelper:IsLoginQQ()) then
            appid = "1108328494"
        end

        local lastChooseZone = GetConfig("LoginZone") or "X"
        local strServerKey = string.format("LoginServer_%s", tostring(lastChooseZone))
        local server = GetConfig(strServerKey) or "ZoneX"

        url = url .. "?platid=" .. tostring(platid) .. "&zoneid=" .. tostring(server) .. "&appid=" .. tostring(appid) .. "&gopenid=" .. tostring(MSDKHelper:GetOpenID())
    end
    return url
end

function ActivityUI:OnBuySuccess()
    -- 请求服务器刷新签到物品数据
    SendPlatShopMallQueryItem(RackItemType.RTT_SIGN)
end

return ActivityUI
