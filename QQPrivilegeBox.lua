QQPrivilegeBox = class("QQPrivilegeBox",BaseWindow)

local closeBtn = nil

function QQPrivilegeBox:ctor()
    
end

function QQPrivilegeBox:Create()
	local obj = LoadPrefabAndInit("Privilege/QQ_Privilege_Box",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function QQPrivilegeBox:Init()
    closeBtn = self:FindChildComponent(self._gameObject, 'CloseBtn', 'Button')
    local closeFun = function()
        RemoveWindowImmediately('QQPrivilegeBox')
    end
    self:AddButtonClickListener(closeBtn, closeFun)
end


function QQPrivilegeBox:OnDestroy()

end

function QQPrivilegeBox:OnEnable()
  
   
end

function QQPrivilegeBox:OnDisable()

end
return QQPrivilegeBox