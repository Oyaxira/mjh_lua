PrivateMessageUI = class("PrivateMessageUI",BaseWindow)

function PrivateMessageUI:Create()
	local obj = LoadPrefabAndInit("PlayerSetUI/PrivateMessageUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function PrivateMessageUI:Init()
	self.objClose = self:FindChild(self._gameObject, "bg")
    local btnClose = self.objClose:GetComponent("Button")
    self:AddButtonClickListener(btnClose, function()
        self:OnClickClose()
    end)
end

function PrivateMessageUI:RefreshUI()

end

function PrivateMessageUI:OnClickClose()
	RemoveWindowImmediately("PrivateMessageUI")
end


return PrivateMessageUI