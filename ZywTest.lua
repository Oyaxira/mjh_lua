ZywTest = class("ZywTest",BaseWindow)

function ZywTest:ctor()
	self.comReturn_Button = nil
end

function ZywTest:Create()
	local obj = LoadPrefabAndInit("ZywTest/ZywTest",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ZywTest:Init()
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"Button_back","Button")
	if self.comReturn_Button then
		local fun = function()
			self:OnClick_Return_Town_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
    end
    
    self.comText = self:FindChildComponent(self._gameObject, "SC_error/Viewport/Content/Text", "Text")
    self.error_text = ""
end

function ZywTest:OnClick_Return_Town_Button()
    RemoveWindowByQueue("ZywTest")
end

function ZywTest:RefreshUI()
    local taskEdgeTable = TableDataManager:GetInstance():GetTable("TaskEdge")
    for k,v in pairs(taskEdgeTable) do
        local d = v.DescIDs
        local s = v.DescStates
        if getTableSize(d) ~= getTableSize(s) then
            self.error_text = self.error_text .. string.format( "%d %s %s %d %d \n", 
                v.BaseID, v.TaskStateName, v.TaskEdgeName, getTableSize(d), getTableSize(s) )
        end
    end
    self.comText.text = self.error_text
end

function ZywTest:OnDestroy()

end


return ZywTest