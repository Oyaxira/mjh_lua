TestGraphicUI = class("TestGraphicUI",BaseWindow)

function TestGraphicUI:ctor()
	self.comReturn_Button = nil
end

function TestGraphicUI:Create()
	local obj = LoadPrefabAndInit("TestGraphicUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TestGraphicUI:Init()
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"Return_Town_Button","Button")
	if self.comReturn_Button then
		local fun = function()
			self:OnClick_Return_Town_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
	end
end

function TestGraphicUI:OnClick_Return_Town_Button()
	OpenWindowImmediately("LoadingUI")
	ChangeScenceImmediately("Town","LoadingUI", function() 
		OpenWindowImmediately("CheatUI")
	end)
end

function TestGraphicUI:OnDestroy()

end


return TestGraphicUI