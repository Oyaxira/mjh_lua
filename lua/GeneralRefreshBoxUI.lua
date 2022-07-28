GeneralRefreshBoxUI = class('GeneralRefreshBoxUI',BaseWindow)

local NPCInteractToPlayerBehaviorType = {
    [NPCIT_REFRESH_CONSULT] = PlayerBehaviorType.PBT_QingJiao,
    [NPCIT_REFRESH_STEEL] = PlayerBehaviorType.PBT_TouXue,
    [NPCIT_REFRESH_COMPARE] = PlayerBehaviorType.PBT_QieCuo,
    [NPCIT_REFRESH_BEG] = PlayerBehaviorType.PBT_QiTao,
    [NPCIT_REFRESH_CALLUP] = PlayerBehaviorType.PBT_CallUp,
    [NPCIT_REFRESH_PUNISH] = PlayerBehaviorType.PBT_Punish,
    [NPCIT_REFRESH_INQUIRY] = PlayerBehaviorType.PBT_INQUIRY,
}

local NPCInteractLanguage = {
    [NPCIT_REFRESH_CONSULT] = '请教',
    [NPCIT_REFRESH_STEEL] = '观摩',
    [NPCIT_REFRESH_COMPARE] = '切磋',
    [NPCIT_REFRESH_BEG] = '乞讨',
    [NPCIT_REFRESH_CALLUP] = '号召',
    [NPCIT_REFRESH_PUNISH] = '惩恶',
    [NPCIT_REFRESH_INQUIRY] = '盘查',
}

function GeneralRefreshBoxUI:ctor()

end

function GeneralRefreshBoxUI:Create()
	local obj = LoadPrefabAndInit('Interactive/GeneralRefreshBoxUI', TIPS_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function GeneralRefreshBoxUI:OnPressESCKey()
    if self.comBtnClose then
        self.comBtnClose.onClick:Invoke()
    end
end

function GeneralRefreshBoxUI:Init()
    self.objContentBox = self:FindChild(self._gameObject, 'content_box')
    self.comContentText = self:FindChildComponent(self.objContentBox, 'Text', 'Text')
    self.comContentText.text = ''

    self.comBtnBg = self:FindChildComponent(self._gameObject, 'BgBtn', 'Button')
    self.comBtnClose = self:FindChildComponent(self._gameObject, 'newFrame/Btn_exit', 'Button')
    self.objBtnClose = self:FindChild(self._gameObject, 'Button_close')
    self.objBtnClose:SetActive(false)
    self.comBtnGreen = self:FindChildComponent(self._gameObject, 'Button_buy', 'Button')
    self.objBtnGreen = self:FindChild(self._gameObject, 'Button_buy')
    self.comBtnGreenText = self:FindChildComponent(self.objBtnGreen, 'Text', 'Text')
    self.comNumberText = self:FindChildComponent(self.objBtnGreen, 'Number', 'Text')

    self.objTitleBox = self:FindChild(self._gameObject, 'title_box')
    self.comTitleText = self:FindChildComponent(self.objTitleBox, 'TextMeshPro Text', 'Text')
   
    self.objImage_yinding = self:FindChild(self.objBtnGreen.gameObject, 'Image_yinding')
    self.objImage_refreshBall = self:FindChild(self.objBtnGreen.gameObject, 'Image_refreshBall')

    self:AddButtonClickListener(self.comBtnClose, function() 
        RemoveWindowImmediately("GeneralRefreshBoxUI")
    end)

    self:AddButtonClickListener(self.comBtnBg, function() 
        RemoveWindowImmediately("GeneralRefreshBoxUI")
    end)
end

function GeneralRefreshBoxUI:OnDestroy()
end

function GeneralRefreshBoxUI:RefreshUI(info)
    local TB_InteractLimit = TableDataManager:GetInstance():GetTable("InteractLimit")
    self.limitTImes = 0
    for i=1, #TB_InteractLimit do
        if TB_InteractLimit[i].PlayerBehavior == NPCInteractToPlayerBehaviorType[info.type] then
            self.limitTImes = TB_InteractLimit[i].RefreshTimes
        end
    end

   
    self.uiRestTime = self.limitTImes - RoleDataManager:GetInstance():GetRefreshTimes(NPCInteractToPlayerBehaviorType[info.type])
    self.resDayStr = EvolutionDataManager:GetInstance():GetRemainDay()


    self:RefreshUI_Item(info)

    
    self:RemoveButtonClickListener(self.comBtnGreen)
    self:AddButtonClickListener(self.comBtnGreen, function()
        local itemCount = PlayerSetDataManager:GetInstance():GetPlayerRefreshBall()
        if self.cost <= itemCount then
            if self.ClickFunc then
                self.ClickFunc(info)
            end
            RemoveWindowImmediately("GeneralRefreshBoxUI")
        else
            SystemUICall:GetInstance():Toast("幸运珠数量不足")
        end
    end)

    if self.des then
        self.comContentText.text = self.des
    end

    -- if self.uiRestTime and self.limitTImes and self.comBtnGreenText then
    --     self.comBtnGreenText.text = '解锁(' .. tostring(self.uiRestTime) .. '/' .. self.limitTImes .. ')'
    -- end
    self.comBtnGreenText.text = "刷新"
end

-- 使用道具
function GeneralRefreshBoxUI:RefreshUI_Item(info)
    self.cost = TableDataManager:GetInstance():GetTable("CommonConfig")[1].InteractRefreshCost or 1
    self.des = string.format( "尚在冷却中, 剩余%s天, 花费%d个幸运珠重置冷却", self.resDayStr, self.cost)
    local itemCount = PlayerSetDataManager:GetInstance():GetPlayerRefreshBall() or 0
    self.comNumberText.text = string.format( "(%d / %d)", itemCount, self.cost)

    self.objImage_yinding.gameObject:SetActive(false)
    self.objImage_refreshBall.gameObject:SetActive(true)
    self.ClickFunc = function(info)
        SendNPCInteractOperCMD(info.type, info.uiRoleID)
    end
end

-- 1401
-- 使用银锭
function GeneralRefreshBoxUI:RefreshUI_Silver(info)
    local cost = RoleDataHelper.GetRefreshCost(NPCInteractToPlayerBehaviorType[info.type])
     -- 请教和观摩现在共用一个cd 所以描述写死类型
    self.des = string.format( "尚在冷却中, 剩余%s天, 花费%0.f银锭重置冷却", self.resDayStr, cost)
    self.comNumberText.text = tostring(cost)

    self.objImage_yinding.gameObject:SetActive(true)
    self.objImage_refreshBall.gameObject:SetActive(false)

    self.ClickFunc = function()
        local cur = RoleDataManager:GetInstance():GetSilverNum()
        if cur < 50 then
            PlayerSetDataManager:GetInstance():RequestSpendSilver(cost, function()
                SendClickBagCapacityBuy()
                SendNPCInteractOperCMD(info.type, info.uiRoleID)
            end)
        else  
            SendNPCInteractOperCMD(info.type, info.uiRoleID)
        end
    end
end

function GeneralRefreshBoxUI:CheckMainRole_ItemRefreshBall()
    -- 刷新球数量
    local itemnum = PlayerSetDataManager:GetInstance():GetPlayerRefreshBall()
    if itemnum > 0 then
        return true
    else
        return false
    end
end

return GeneralRefreshBoxUI