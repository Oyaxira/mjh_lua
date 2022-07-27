MultDropActivityUI = class("MultDropActivityUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type
function MultDropActivityUI:Create()
	local obj = LoadPrefabAndInit("ResDropActivityUI/MultDropActivityUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function MultDropActivityUI:Init()

end

function MultDropActivityUI:RefreshUI(info)
    -- SendRequestQueryResDropActivityInfo(EN_QUERY_RESDROP_ACTIVITY_MULTDROP)
end

return MultDropActivityUI