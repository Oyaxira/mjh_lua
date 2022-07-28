MiniLoadingUI = class("MiniLoadingUI",BaseWindow)

function MiniLoadingUI:ctor()
	self.objProgress_Text = nil
end

function MiniLoadingUI:Create()
	local obj = LoadPrefabAndInit("MiniLoadingUI/MiniLoadingUI", Load_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function MiniLoadingUI:Init()
end

function MiniLoadingUI:OnDestroy()
end

return MiniLoadingUI