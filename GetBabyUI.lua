GetBabyUI = class("GetBabyUI",BaseWindow)

local SpineRoleUI = require 'UI/Role/SpineRoleUI'

function GetBabyUI:ctor()
	
end

function GetBabyUI:Create()
	local obj = LoadPrefabAndInit("Role/GetBabyUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function GetBabyUI:Init()
    self.roleSpine = self:FindChild(self._gameObject, "Spine")
    self.SpineRoleUI = SpineRoleUI.new()

    self.comReturn_Button = self:FindChildComponent(self._gameObject,"btn_close","Button")
    if self.comReturn_Button then
		local fun = function()
            RemoveWindowImmediately('GetBabyUI', true)
            DisplayActionEnd()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
    end
end

function GetBabyUI:RefreshUI(uiRoleID)
    uiRoleID = tonumber(uiRoleID)
    self.SpineRoleUI:UpdateRoleSpine(self.roleSpine, uiRoleID)
    local comtwn = self.roleSpine:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
    if comtwn then 
        comtwn:DORestart()
    end
end

function GetBabyUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
end

function GetBabyUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
end

function GetBabyUI:OnDestroy()
    self.SpineRoleUI:Close()
end

return GetBabyUI