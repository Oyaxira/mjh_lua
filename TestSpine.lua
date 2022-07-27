TestSpine = class("TestSpine",BaseWindow)

function TestSpine:ctor()
	self.comReturn_Button = nil
end

function TestSpine:Create()
	local obj = LoadPrefabAndInit("TestSpine",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TestSpine:Init()
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"Return_Town_Button","Button")
	if self.comReturn_Button then
		local fun = function()
			self:OnClick_Return_Town_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
	end
end

function TestSpine:OnClick_Return_Town_Button()
	OpenWindowImmediately("LoadingUI")
	ChangeScence("Town","LoadingUI")
	OpenWindowImmediately("CheatUI")
end

function TestSpine:OnDestroy()

end


return TestSpine