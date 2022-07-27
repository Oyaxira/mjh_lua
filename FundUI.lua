
FundUI = class("FundUI",BaseWindow)

local dkJson = require("Base/Json/dkjson")
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local TB_ITEM 

function FundUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
    self.ItemIconUI:SetCanSaveButton(false)
    TB_ITEM = TableDataManager:GetInstance():GetTable("Item") or {}

end

function FundUI:Create()
	local obj = LoadPrefabAndInit("ActivityUI/Fund",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function FundUI:Init()
    self.comChallengeOrderButton =  self:FindChildComponent(self._gameObject,'Image_ad/Button_challengeorder',DRCSRef_Type.Button)
    if self.comChallengeOrderButton then
        self:RemoveButtonClickListener(self.comChallengeOrderButton)
        self:AddButtonClickListener(self.comChallengeOrderButton, function()
            dprint("打开完整版购买界面")
            OpenWindowImmediately("ChallengeOrderUI")
        end)
    end
    
    self.comBuyButton =  self:FindChildComponent(self._gameObject,'Image_ad/Button_buy',DRCSRef_Type.Button)
    if self.comBuyButton then
        self:RemoveButtonClickListener(self.comBuyButton)
        self:AddButtonClickListener(self.comBuyButton, function()
            self:UnLockBtnClick()
        end)
    end
    self.txtBuyButton = self:FindChildComponent(self._gameObject,'Image_ad/Button_buy/Text','Text')
        
    self.comGetAllRewardsButton =  self:FindChildComponent(self._gameObject,'Button_getall',DRCSRef_Type.Button)
    if self.comGetAllRewardsButton then
        self:RemoveButtonClickListener(self.comGetAllRewardsButton)
        self:AddButtonClickListener(self.comGetAllRewardsButton, function()
           --获取所有可领奖励
           dprint("获取所有可领奖励")
           --获得多个物品的弹窗
           --刷新已领取状态
           if (self.getAllList and #self.getAllList>0) then
            for i=1,#self.getAllList do
                SendActivityOper(SAOT_EVENT,self.activityBase.BaseID,SATET_FUND_RECEIVE,itemIndex)
            end
           end

        end)
    end

    self.objRewardNode = self:FindChildComponent(self._gameObject,"Reward_node")
    self.objRewardNodeList = self:FindChild(self.objRewardNode, "Content")
    self.objRewardNodeList_LoopScrollView = self:FindChildComponent(self._gameObject,"Reward_node","LoopHorizontalScrollRect")
    if self.objRewardNodeList_LoopScrollView then
        self.objRewardNodeList_LoopScrollView:AddListener(function(...) self:OnRewardContentChanged(...) end)
    end

    self.objStageBtn1 =  self:FindChild(self._gameObject,"Stages/Button_stage1")
    self.objStageBtn1.gameObject:SetActive(false)

    self.txtTitleTypeNum = self:FindChildComponent(self._gameObject,'Image_ad/Text_point','Text')

    self:AddEventListener("CHALLENGEORDER_UNLOCK",function() 
        -- 数据刷新
        dprint("完整版解锁后，刷新")
        self:OnStageButtonClick(true)
    end,nil,nil,nil,true )

    -- self:AddEventListener("UpdateActivityInfo",function() 
    --     -- 数据刷新
    --     dprint("活动数据下发后，刷新")
    --     self:OnStageButtonClick()
    -- end,nil,nil,nil,true )

    self.imageFundBG = self:FindChildComponent(self._gameObject,'Image_ad','Image')

    self.setHighestStage = false
    self.playerid = tostring(globalDataPool:getData("PlayerID"))
end

function FundUI:UnLockBtnClick()
    if self.buyBtnState then
        if self.buyBtnState == 2 then
            --金锭购买基金
            local content = {
                ['title'] = "系统提示",
                ['text'] = "消耗"..self.activityBase.MoneyCost.."金锭解锁大侠之证?"
            }
            local callback = function()
                dprint("金锭购买基金")
                --申请消费金锭cd延长到5秒
                if (self.activityBase) then
                    PlayerSetDataManager.GetInstance():RequestSpendGold(self.activityBase.MoneyCost,function()
                        SendActivityOper(SAOT_EVENT,self.activityBase.BaseID,SATET_FUND_OPEN,2)
                    end,false,nil,5)
                end
            end
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback})  
            
        elseif self.buyBtnState == 1 then
            --使用完整版解锁基金
            local content = {
                ['title'] = "系统提示",
                ['text'] = "仅限此一次可免费解锁大侠之证,是否解锁?"
            }
            local callback = function()
                dprint("使用完整版解锁基金")
                if (self.activityBase) then
                    SendActivityOper(SAOT_EVENT,self.activityBase.BaseID,SATET_FUND_OPEN,1) 
                end
            end
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback})                   
        end
    end
end

function FundUI:SetFrameAnimation(obj, key)
    local objEffect = self:FindChild(obj, "Effect")
    if not objEffect then
        return
    end
    local imgEffect = objEffect:GetComponent("Image")
    local kEffectData = ItemDataManager:GetInstance():GetItemFrameEffectData(key)
    if not (imgEffect and kEffectData) then
        objEffect:SetActive(false)
        return
    end
    imgEffect.sprite = kEffectData.sprite
    imgEffect.material = kEffectData.material
    objEffect:GetComponent("Transform").localScale = kEffectData.scale
    objEffect:SetActive(true)
end

function FundUI:SetItem(obj,data,num,haveGot,isLock)
    local objItemicon_icon = self:FindChildComponent(obj,'Icon',DRCSRef_Type.Image)
    objItemicon_icon.sprite = GetSprite(data.Icon)

    local objItemicon_frame = self:FindChildComponent(obj,'Frame',DRCSRef_Type.Image)
    if (data.Rank) then
        local framedata = TableDataManager:GetInstance():GetTableData("RankMsg",data.Rank)
        objItemicon_frame.sprite = GetSprite(framedata.IconFrame)
        self:SetFrameAnimation(obj,data.Rank)
    end


    local objItemicon_num = self:FindChildComponent(obj,'Num','Text')
    objItemicon_num.text = num

    local objItemicon_gotReward = self:FindChild(obj,'GotReward')
    if (haveGot==1) then
        objItemicon_gotReward.gameObject:SetActive(true)
    else
        objItemicon_gotReward.gameObject:SetActive(false)
    end

    local btnItemicon = obj:GetComponent(DRCSRef_Type.Button)
    if btnItemicon then
        self:RemoveButtonClickListener(btnItemicon)
        self:AddButtonClickListener(btnItemicon, function()
            local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, data)
            OpenWindowImmediately("TipsPopUI", tips)
        end)
    end

    local objItemicon_effect = self:FindChildComponent(obj,'Effect',DRCSRef_Type.Image)
    local lockColor = DRCSRef.Color(0.68,0.68,0.68,1)
    local enlockColor = DRCSRef.Color(1,1,1,1)
    if (isLock) then
        objItemicon_icon.color = lockColor
        objItemicon_frame.color = lockColor
        objItemicon_effect.color = lockColor
    else
        objItemicon_icon.color = enlockColor
        objItemicon_frame.color = enlockColor
        objItemicon_effect.color = enlockColor    
    end
    
end

function FundUI:OnRewardContentChanged(gameobj,index)
    -- 奖励栏
    -- 刷新领取按钮
    local itemIndex = index+1
    local rootObj = gameobj.gameObject
    local freeItem = self:FindChild(rootObj,"FreeItem")
    local goalRequireText = self:FindChildComponent(freeItem,'Text','Text')
    goalRequireText.text = self.activityBase.StageGoal[itemIndex]..self.typeName.."\n可领取"

    local objFreeItemicon = self:FindChild(freeItem,'ItemIcon')
    local freeDataItem =  TB_ITEM[self.activityBase.FreeReward1[itemIndex] or 0]
    local freeItemNum = self.activityBase.FreeRewardNum1[itemIndex] or 0
    local freeItemGot = self.freeRewardGetStateList[itemIndex] or 0
    self:SetItem(objFreeItemicon,freeDataItem,freeItemNum,freeItemGot,false)    
    
    -- 完整版解锁有一份奖励
    -- 金锭解锁也有一份奖励
    -- 都有可能只领取了一部分
    -- 显示几份奖励 两份都没领 两份都领了
    local awardTimes = 1
    if (self.heroLevel and self.heroLevelByComplete and self.paidRewardGetStateList[itemIndex] == self.paidRewardMoreGetStateList[itemIndex]) then
        awardTimes = 2
    end
    local paidItem = self:FindChild(rootObj,'PaidItem')
    local objPaidItemicon = self:FindChild(paidItem,'ItemIcon1')
    local paidDataItem =  TB_ITEM[self.activityBase.PaidReward1[itemIndex] or 0] 
    local paidItemNum = self.activityBase.PaidRewardNum1[itemIndex] or 0
    -- 显示已领取
    local paidItemGot = 0
    if (self.heroLevel and self.heroLevelByComplete) then
        if (self.paidRewardGetStateList[itemIndex] == 1 and self.paidRewardMoreGetStateList[itemIndex] == 1) then
            paidItemGot = 1
        end
    else
        if (self.heroLevel and self.paidRewardGetStateList[itemIndex] == 1) then
            paidItemGot = 1
        elseif (self.heroLevelByComplete and self.paidRewardMoreGetStateList[itemIndex] == 1) then
            paidItemGot = 1
        end
    end
    -- 是否解锁
    local isLock = true
    if (self.heroLevel or self.heroLevelByComplete) then
        isLock = false
    end
    self:SetItem(objPaidItemicon,paidDataItem,paidItemNum*awardTimes,paidItemGot,isLock)

    local objPaidItemicon2 = self:FindChild(paidItem,'ItemIcon2')
    if (self.activityBase.PaidRewardNum2[itemIndex]>0) then
        local paidDataItem2 =  TB_ITEM[self.activityBase.PaidReward2[itemIndex] or 0] 
        local paidItemNum2 = self.activityBase.PaidRewardNum2[itemIndex] or 0
        self:SetItem(objPaidItemicon2,paidDataItem2,paidItemNum2*awardTimes,paidItemGot,isLock) 
        objPaidItemicon2.gameObject:SetActive(true)
    else
        objPaidItemicon2.gameObject:SetActive(false)
    end

    -- 点击未解锁按钮 功能为点击金锭解锁按钮
    local paidItemLock = self:FindChild(paidItem,'Image_lock')
    if (not isLock) then
        paidItemLock.gameObject:SetActive(false)
    else
        paidItemLock.gameObject:SetActive(true)
        local paidItemLockBtn = paidItemLock:GetComponent(DRCSRef_Type.Button)
        if (paidItemLockBtn) then
            self:RemoveButtonClickListener(paidItemLockBtn)
            self:AddButtonClickListener(paidItemLockBtn,function()
                self:UnLockBtnClick()
            end)
        end
    end

    -- 领取按钮功能
    local btnGet = self:FindChildComponent(freeItem,'Button_get',DRCSRef_Type.Button)
    if btnGet then
        self:RemoveButtonClickListener(btnGet)
        self:AddButtonClickListener(btnGet, function()
           -- 领取奖励
           SendActivityOper(SAOT_EVENT,self.activityBase.BaseID,SATET_FUND_RECEIVE,itemIndex)
        end)
    end
    -- 领取按钮状态
    local getbtnbg = btnGet.transform:GetComponent("Image")
    local getbtnText = self:FindChildComponent(freeItem,'Button_get/Text','Text')        
    if self:CanGotReward(itemIndex,freeItemGot) then
        btnGet.gameObject:SetActive(true)
        setUIGray(getbtnbg,false)
        btnGet.interactable = true
        getbtnText.text = "领取"
    elseif self.typeNum < self.activityBase.StageGoal[itemIndex] then
        btnGet.gameObject:SetActive(false)
    else
        btnGet.gameObject:SetActive(false)
        goalRequireText.text = "已领取"
    end
end

-- 还有没领取完的
function FundUI:CanGotReward(index,freeItemGot)
    if self.typeNum >= self.activityBase.StageGoal[index] then
        if freeItemGot == 0 then
            return true
        end
        if self.heroLevel and self.paidRewardGetStateList[index]==0 then
            return true
        end
        if self.heroLevelByComplete and self.paidRewardMoreGetStateList[index]==0 then
            return true
        end
    end
    return false
end

function FundUI:OnStageButtonClick(isRefresh)
    -- 阶段按钮被点击
    stageIndex = self.nowStage
    -- 刷新当前活动信息
    self.activityBase = self.activityBaseNowList[stageIndex]
    self.activityInfo = ActivityHelper:GetInstance():GetActivityInfo(self.activityBase.BaseID)
    -- 判断当前英雄版是否解锁
    self.heroLevel = false
    -- 判断当前免费英雄版是否解锁
    self.heroLevelByComplete = false
    local lockState = self.activityInfo.iValue1
    if (lockState == 1) then
        self.heroLevelByComplete = true
    elseif (lockState == 2) then
        self.heroLevel = true
    elseif (lockState == 3) then
        self.heroLevelByComplete = true
        self.heroLevel = true
    end
    
    -- 刷新 奖励获取状态
    local freeRewardGetState = self.activityInfo.iValue2
    local paidRewardGetState = self.activityInfo.iValue3
    self.freeRewardGetStateList = {}
    self.paidRewardGetStateList = {}
    self.paidRewardMoreGetStateList = {}
    self.getAllList = {}
    local getAllCount = 0
    for i=1,64 do
        local iCurValue1 = freeRewardGetState >> (i-1) & 1
        local iCurValue2 = paidRewardGetState >> (i-1) & 1
        self.freeRewardGetStateList[i] = iCurValue1
        if (i<=32) then
            self.paidRewardMoreGetStateList[i] = iCurValue2
        else
            self.paidRewardGetStateList[i-32] = iCurValue2
        end
    end
    for i=1,10 do 
        if self:CanGotReward(i,self.freeRewardGetStateList[i]) then
            self.getAllList[getAllCount+1] = i
            getAllCount = getAllCount + 1
        end
    end 
    -- 刷新 全部领取按钮 (无可领按钮置灰)
    local getbtnbg = self.comGetAllRewardsButton.transform:GetComponent("Image")
    if (getAllCount>0) then
        setUIGray(getbtnbg,false)
        self.comGetAllRewardsButton.interactable = true
    else
        setUIGray(getbtnbg,true)
        self.comGetAllRewardsButton.interactable = false
    end
    -- 判断当前完整版是否解锁
    self.completeLevel = PlayerSetDataManager:GetInstance():IsChallengeOrderUnlock()
    -- 判断其他基金是否已经使用过免费解锁
    self.haveUsedHeroLevelByComplete = PlayerSetDataManager:GetInstance():GetFundAchieveOpen()
    -- 刷新 完整版按钮 
        -- 已解锁完整版 此按钮不显示
    if (self.completeLevel) then
        self.comChallengeOrderButton.gameObject:SetActive(false)
    else 
        -- 只在stage=1时显示 点击后跳转到完整版解锁界面
        if (stageIndex == 1) then
            self.comChallengeOrderButton.gameObject:SetActive(true)
        else
            self.comChallengeOrderButton.gameObject:SetActive(false)
        end
    end
    -- 刷新 金锭购买按钮
       -- 已解锁完整版 没有使用免费解锁机会的情况下 金锭解锁的地方功能改变
    self.buyBtnState = 2       
    local btnbg = self.comBuyButton.transform:GetComponent("Image")
    if (self.completeLevel and self.haveUsedHeroLevelByComplete==0 and stageIndex == 1 and self.heroLevelByComplete == false ) then
        self.txtBuyButton.text = "免费解锁"
        self.buyBtnState = 1
        setUIGray(btnbg,false)
        self.comBuyButton.interactable = true
    else
        if (self.heroLevel) then
            self.txtBuyButton.text = "已激活"
            self.buyBtnState = 0
            setUIGray(btnbg,true)
            self.comBuyButton.interactable = false
        else
            self.txtBuyButton.text = self.activityBase.MoneyCost.."金锭"
            self.buyBtnState = 2
            setUIGray(btnbg,false)
            self.comBuyButton.interactable = true
        end
    end
    

    -- 刷新 奖励 用isRefresh来控制是refresh还是refill
    if self.objRewardNodeList_LoopScrollView then
        self.objRewardNodeList_LoopScrollView.totalCount = 10
        if (isRefresh) then
            self.objRewardNodeList_LoopScrollView:RefreshCells()
        else
            self.objRewardNodeList_LoopScrollView:RefillCells()
       end
    end
end

function FundUI:RefreshUI(activityData)
    self.activityBase = activityData

    -- 修改活动底图
    self.imageFundBG.sprite = GetSprite(self.activityBase.ActPic)

    -- 先判断基金类型
    -- 切换基金的时候清除当前stage 并且使用refill
    local doRefillCells = false
    if (self.fundType~=nil and self.fundType ~= self.activityBase.FundType) then
        self.nowStage = nil
        doRefillCells = true
    end

    self.fundType = self.activityBase.FundType
    
    -- 再根据类型 获取阶段解锁需要的属性 eg 经脉、成就
    self.typeName = "成就点"
    if (self.fundType == ActFundType.AFT_Achievement) then
        self.typeName = "成就点"
        self.typeNum = AchieveDataManager:GetInstance():GetAllAchievePoint() or 0
    elseif (self.fundType == ActFundType.AFT_Meridian) then
        self.typeName = "经脉等级"
        self.typeNum = MeridiansDataManager:GetInstance():GetSumLevel() or 0
    end
    --self.typeNum = 5000
    self.txtTitleTypeNum.text = "当前"..self.typeName..":"..self.typeNum

    -- 根据属性范围解锁不同阶段
    self.activityBaseList = ActivityHelper:GetInstance():GetFundData()
    self.activityBaseNowList = {}
    
    local nowStageCount = 0
    for k ,v in pairs(self.activityBaseList) do
        if v.FundType == self.fundType and self.typeNum >= v.StageAreaA then
            self.activityBaseNowList[nowStageCount+1] = v
            nowStageCount = nowStageCount + 1
        end  
    end
    
    -- 默认页面在最高解锁阶段
    if (self.nowStage == nil) then
        self.nowStage = nowStageCount
    end

    -- 当前显示几个阶段
    for i=1,self.objStageBtn1.transform.parent.childCount do
        self.objStageBtn1.transform.parent:GetChild(i-1).gameObject:SetActive(false)
    end
    if (nowStageCount>1) then
        for i=1,nowStageCount do
            local newStageBtn
            if (self.objStageBtn1.transform.parent.childCount > i) then
                newStageBtn = self.objStageBtn1.transform.parent:GetChild(i-1).gameObject
            else
                newStageBtn = CloneObj(self.objStageBtn1,self.objStageBtn1.transform.parent)
            end
            local txtNewStageBtn = self:FindChildComponent(newStageBtn,'Text','Text')
            txtNewStageBtn.text = "第"..i.."阶段"
            local btnNewStageBtn = newStageBtn:GetComponent(DRCSRef_Type.Button)
            if btnNewStageBtn then
                self:RemoveButtonClickListener(btnNewStageBtn)
                self:AddButtonClickListener(btnNewStageBtn, function()
                    -- 原来的点击置灰清除
                    if (self.lastStageButton ~= nil) then
                        local setGrayImage = self:FindChild(self.lastStageButton.transform.gameObject, "Image_choose")
                        setGrayImage.gameObject:SetActive(false)
                        self.lastStageButton.interactable = true
                    end
                    self.lastStageButton = btnNewStageBtn
                    -- 当前的按钮置灰
                    local setGrayImage2 = self:FindChild(self.lastStageButton.transform.gameObject, "Image_choose")
                    setGrayImage2.gameObject:SetActive(true)
                    self.lastStageButton.interactable = false
                    self.nowStage = i
                    self:OnStageButtonClick()
                end)
            end
            local setGrayImage = self:FindChild(btnNewStageBtn.transform.gameObject, "Image_choose")
            if (i == self.nowStage) then
                setGrayImage.gameObject:SetActive(true)
                btnNewStageBtn.interactable = false
                self.lastStageButton = btnNewStageBtn
            else
                setGrayImage.gameObject:SetActive(false)
                btnNewStageBtn.interactable = true
            end
            newStageBtn.gameObject:SetActive(true)
        end    
    end

    -- 调用OnStageButtonClick来刷新页面 传入参数来控制是refill还是refresh
    if (self.objRewardNodeList_LoopScrollView.totalCount ~= 10 or doRefillCells == true) then
        self:OnStageButtonClick()
    else
        self:OnStageButtonClick(true)
    end

    -- 解锁完整版之后第一次打开基金界面出提示弹框
    if self.completeLevel and self.haveUsedHeroLevelByComplete==0 and not GetConfig(self.playerid..'#HadOpenedFundTips') then
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.FUND_FREE_TIP, "您是尊贵的完整版玩家，获得一次免费解锁大侠之证的机会"}) 
        SetConfig(self.playerid..'#HadOpenedFundTips', true);
    end

    -- 与上次打开时的stagecount进行比较 不同的话第一次打开基金界面出提示弹框
    local lastStageCount = GetConfig(self.playerid..'#LastStageCount'..self.fundType)
    if lastStageCount and lastStageCount~= nowStageCount then
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.FUND_FREE_TIP, "已解锁新阶段！"}) 
        SetConfig(self.playerid..'#LastStageCount'..self.fundType, nowStageCount);
    elseif not lastStageCount then
        SetConfig(self.playerid..'#LastStageCount'..self.fundType, nowStageCount);
    end
end

function FundUI:Update()
    
end

function FundUI:OnEnable()
    
end

function FundUI:OnDisable()
    
end

function FundUI:OnDestroy()
    self:RemoveEventListener("CHALLENGEORDER_UNLOCK")
    -- self:RemoveEventListener("UpdateActivityInfo")
end

return FundUI
