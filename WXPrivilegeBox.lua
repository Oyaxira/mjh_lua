WXPrivilegeBox = class("WXPrivilegeBox",BaseWindow)

local closeBtn = nil

function WXPrivilegeBox:ctor()
    
end

function WXPrivilegeBox:Create()
	local obj = LoadPrefabAndInit("Privilege/WX_Privilege_Box",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function WXPrivilegeBox:Init()
    closeBtn = self:FindChildComponent(self._gameObject, 'CloseBtn', 'Button')
    local closeFun = function()
        RemoveWindowImmediately('WXPrivilegeBox')
    end
    self:AddButtonClickListener(closeBtn, closeFun)
end


function WXPrivilegeBox:OnDestroy()

end

function WXPrivilegeBox:OnEnable()
  
   
end

function WXPrivilegeBox:OnDisable()

end
return WXPrivilegeBox