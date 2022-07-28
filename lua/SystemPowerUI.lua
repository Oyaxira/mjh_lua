SystemPowerUI = class("SystemPowerUI",BaseWindow)

function SystemPowerUI:Create()
	local obj = LoadPrefabAndInit("PlayerSetUI/SystemPowerUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function SystemPowerUI:Init()
	self.objClose = self:FindChild(self._gameObject, "Button_close")
    local btnClose = self.objClose:GetComponent("Button")
    self:AddButtonClickListener(btnClose, function()
        self:OnClickClose()
    end)
end

function SystemPowerUI:RefreshUI()

end

function SystemPowerUI:OnClickClose()
	RemoveWindowImmediately("SystemPowerUI")
end


return SystemPowerUI