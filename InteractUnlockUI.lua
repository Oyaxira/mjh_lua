InteractUnlockUI = class("InteractUnlockUI",BaseWindow)

function InteractUnlockUI:ctor()

end

function InteractUnlockUI:Create()
	local obj = LoadPrefabAndInit("Interactive/InteractUnlockUI", TIPS_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

local interacttype_convert = {
	[PlayerBehaviorType.PBT_CallUp] = '号召',
	[PlayerBehaviorType.PBT_Punish] = '惩恶',
	[PlayerBehaviorType.PBT_JueDou] = '决斗',
    [PlayerBehaviorType.PBT_QiTao] = '乞讨',
    [PlayerBehaviorType.PBT_INQUIRY] = '盘查',
    [PlayerBehaviorType.PBT_Absorb] = '吸能',
}

function InteractUnlockUI:RefreshUI(playerBehaviorType)
    self.unLockConfig = nil
    local TB_InteractUnLock = TableDataManager:GetInstance():GetTable("InteractUnLock")
    for key, value in pairs(TB_InteractUnLock) do
        if value.PlayerBehavior == playerBehaviorType then
            self.unLockConfig = value
        end
    end
    if self.unLockConfig then
        self.comContent_title.text = interacttype_convert[self.unLockConfig.PlayerBehavior]
    end
end

function InteractUnlockUI:Init()
    self.comBtnClose = self:FindChildComponent(self._gameObject, 'Button_close', 'Button')
    self.comBtnButton_left = self:FindChildComponent(self._gameObject, 'Button_left/Buy_red', 'Button')
    self.comBtnButton_right = self:FindChildComponent(self._gameObject, 'Button_right/Buy_red', 'Button')
    self.comContent_title = self:FindChildComponent(self._gameObject, 'title_box/Text', 'Text')

    self:AddButtonClickListener(self.comBtnClose, function()
        if self.unLockConfig then 
            SendNPCInteractOperCMD(NPCIT_UNLOCK, self.unLockConfig.PlayerBehavior, IUW_NULL)
        end 
        RemoveWindowImmediately("InteractUnlockUI")
        --DisplayActionEnd()
    end)

    self:AddButtonClickListener(self.comBtnButton_left, function()
        if self.unLockConfig then
            if RoleDataManager:GetInstance():IsInteractUnlock(self.unLockConfig.PlayerBehavior) then
                local str = "此剧本已解锁"
                SystemUICall:GetInstance():Toast(str)
            else
                PlayerSetDataManager:GetInstance():RequestSpendSilver(self.unLockConfig.UnlockOnceCost, function()
                    SendNPCInteractOperCMD(NPCIT_UNLOCK, self.unLockConfig.PlayerBehavior, IUW_ONCE)
                    RemoveWindowImmediately("InteractUnlockUI")
                end)
            end
            --DisplayActionEnd()
        end
    end)
    self:AddButtonClickListener(self.comBtnButton_right, function()
        if self.unLockConfig then
            PlayerSetDataManager:GetInstance():RequestSpendSilver(self.unLockConfig.UnlockForever, function()
                SendNPCInteractOperCMD(NPCIT_UNLOCK, self.unLockConfig.PlayerBehavior, IUW_FOREVER)
                RemoveWindowImmediately("InteractUnlockUI")
            end)
        end
    end)
end

function InteractUnlockUI:OnEnable()
   
end

function InteractUnlockUI:OnDisable()
    
end

function InteractUnlockUI:OnDestroy()

end


return InteractUnlockUI