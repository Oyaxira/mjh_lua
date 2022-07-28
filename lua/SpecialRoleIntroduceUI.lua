SpecialRoleIntroduceUI = class("SpecialRoleIntroduceUI",BaseWindow)

function SpecialRoleIntroduceUI:ctor()

end

function SpecialRoleIntroduceUI:Create()
	local obj = LoadPrefabAndInit("Interactive/SpecialRoleIntroduceUI",TIPS_Layer,true)
	if obj then
        self:SetGameObject(obj)
	end
end

function SpecialRoleIntroduceUI:Init()
	self.comBtnBalck_Button = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", "DRButton")
	self.comName_Text = self:FindChildComponent(self._gameObject, "Name", "Text")
	self.comDesc_Text = self:FindChildComponent(self._gameObject, "Desc", "Text")

	self:AddButtonClickListener(self.comBtnBalck_Button, function()
		RemoveWindowImmediately("SpecialRoleIntroduceUI")

		local selectUI = GetUIWindow("SelectUI")
		if selectUI then
			selectUI:OnlyShowRole(false)
		end
	end)
end

function SpecialRoleIntroduceUI:RefreshUI(roleID)
	local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByID(roleID)

	if not roleTypeData or roleTypeData.SpecialIntroduce == 0 then
		return
	end

	self.comName_Text.text = "【" .. GetLanguageByID(roleTypeData.NameID) .. "】"
	self.comDesc_Text.text = GetLanguageByID(roleTypeData.SpecialIntroduce)

	local selectUI = GetUIWindow("SelectUI")
	if selectUI then
		selectUI:OnlyShowRole(true)
	end
end

function SpecialRoleIntroduceUI:OnPressESCKey() 
    if self.comBtnBalck_Button then
	    self.comBtnBalck_Button.onClick:Invoke()
    end
end

return SpecialRoleIntroduceUI