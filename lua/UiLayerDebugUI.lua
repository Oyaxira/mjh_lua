UiLayerDebugUI = class("UiLayerDebugUI", BaseWindow)

function UiLayerDebugUI:ctor()
end

function UiLayerDebugUI:Create()
	local obj = LoadPrefabAndInit("DebugUI/UiLayerDebugUI", Load_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function UiLayerDebugUI:Init()    
end

function UiLayerDebugUI:RefreshUI()    
end

function UiLayerDebugUI:OnDestroy()
end

return UiLayerDebugUI