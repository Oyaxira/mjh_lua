PlayerReturnUI = class("PlayerReturnUI",BaseWindow)

function PlayerReturnUI:ctor()
    
end

function PlayerReturnUI:Create()
	local obj = LoadPrefabAndInit("PlayerReturnUI/PlayerReturnUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function PlayerReturnUI:Init()
    self.comSpine = self:FindChildComponent(self._gameObject,'Spine_Letter',DRCSRef_Type.SkeletonGraphic)
    self.objLetter_node = self:FindChild(self._gameObject,'Letter_node')
    self.objLetter_node:SetActive(false)
    self.comBGButton =  self:FindChildComponent(self._gameObject,'Spine_Letter',DRCSRef_Type.Button)

    self.openAnimationFunc = function()
        self.objLetter_node:SetActive(true) 
    end
    
    self.activityInfo,self.iEndTime = ActivityHelper:GetInstance():GetPlayerReturnInfo()
    if  self.activityInfo == nil then
        return
    end
    self.activityBase = TableDataManager:GetInstance():GetTableData("ActivityBase",self.activityInfo.dwActivityID) 
    -- 测试获取数据
    -- self.activityInfo = {iValue3 = os.time()}
    -- self.activityBase = TableDataManager:GetInstance():GetTableData("ActivityBase",10501) 

    self.objActivityJump = self:FindChild(self._gameObject,'ActivityJump')
    self.objActivityJump:SetActive(false)
    self.bOpen = false;
    if self.comBGButton then
        self:AddButtonClickListener(self.comBGButton, function()
            if self.bOpen == false then
                self.bOpen = true
                self.comSpine.AnimationState:AddAnimation(0,"open",false,0)
                self.comSpine.AnimationState:Complete("+",self.openAnimationFunc)
            end
        end)
    end
    
    self.comGetRewardButton =  self:FindChildComponent(self._gameObject,'Letter_node/Button_get',DRCSRef_Type.Button)
    if self.comGetRewardButton then
        self:AddButtonClickListener(self.comGetRewardButton, function()
            if self.activityBase then
                SendActivityOper(SAOT_EVENT, self.activityBase.BaseID, SATET_BACKFLOW_RECEIVE)
                self.objActivityJump:SetActive(true)
                self.objLetter_node:SetActive(false)
                self.comSpine.gameObject:SetActive(false)
            end
        end)
    end

    self:SetRewardNode()
    self:SetActivityJump()
end

function PlayerReturnUI:SetRewardNode()
    local objRewardNode = self:FindChild(self._gameObject,'Letter_node/Rewards').transform
    local activityBase = self.activityBase
    self.objRewardItems = {}
    for i = 1,#activityBase.HuiLiuItems do
        local tempItemData = TableDataManager:GetInstance():GetTableData("Item",activityBase.HuiLiuItems[i])
        if tempItemData then
            local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemReward,objRewardNode)
            self.objRewardItems[#self.objRewardItems + 1] = kItem
            kItem:UpdateUIWithItemTypeData(tempItemData,true)
            kItem:SetItemNum(activityBase.HuiLiuItemsNum[i])
        end
    end

    local activityInfo = ActivityHelper:GetInstance():GetActivityInfo(self.activityBase.BaseID)

    local comPlayerNameText = self:FindChildComponent(self._gameObject,'TextContent/Text1',DRCSRef_Type.Text)
    local name = PlayerSetDataManager:GetInstance():GetPlayerName() or ''
    comPlayerNameText.text = string.format(GetLanguageByID(831001),name)
    
    local comContentText = self:FindChildComponent(self._gameObject,'TextContent/Text2',DRCSRef_Type.Text)
    comContentText.text = string.format(GetLanguageByID(831002),activityInfo.iHistory_count or 0,activityBase.Name)
    --local comSignatureText = self:FindChildComponent(self._gameObject,'TextContent/Text3',DRCSRef_Type.Text)
end

function PlayerReturnUI:SetActivityJump()
    local comBGImage = self:FindChildComponent(self._gameObject,'ActivityJump/Image',DRCSRef_Type.Image)
    comBGImage.sprite = GetSprite(self.activityBase.ActPic)

    local kEndDate = os.date("*t", self.iEndTime)
    local iStartTime = self.activityInfo.iValue3
    if iStartTime == 0 then
        iStartTime = os.time()
    end
    local kStartDate = os.date("*t",  iStartTime)
    local comDateText = self:FindChildComponent(self._gameObject,'ActivityJump/Image/Text',DRCSRef_Type.Text)
    comDateText.text = string.format("活动时间：%d/%d 00:00 - %d/%d 23:59",kStartDate.month,kStartDate.day,kEndDate.month,kEndDate.day )

    local activityBase = self.activityBase
    local objRewardNode = self:FindChild(self._gameObject,'ActivityJump/RewardsNode').transform
    for k,v in ipairs(activityBase.RewardItems) do
        local tempItemData = TableDataManager:GetInstance():GetTableData("Item",v.ItemId)
        if tempItemData then
            local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemReward,objRewardNode)
            self.objRewardItems[#self.objRewardItems + 1] = kItem
            kItem:UpdateUIWithItemTypeData(tempItemData,true)
            kItem:SetItemNum(v.ItemNum)
        end
    end

    self.comCloseButton =  self:FindChildComponent(self._gameObject,'ActivityJump/PopUpWindow_3/Board/Button_close',DRCSRef_Type.Button)
    if self.comCloseButton then
        self:AddButtonClickListener(self.comCloseButton, function()
            RemoveWindowImmediately("PlayerReturnUI")
        end)
    end

    self.comJumpButton =  self:FindChildComponent(self._gameObject,'ActivityJump/Button_jump',DRCSRef_Type.Button)
    if self.comJumpButton then
        self:AddButtonClickListener(self.comJumpButton, function()
            OpenWindowImmediately("PlayerReturnTaskUI")
            RemoveWindowImmediately("PlayerReturnUI")
        end)
    end
end

function PlayerReturnUI:OnDestroy()
    self.comSpine.AnimationState:Complete("-",self.openAnimationFunc)
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.objRewardItems)
end

return PlayerReturnUI
