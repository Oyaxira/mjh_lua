ChooseLuckyUI = class("ChooseLuckyUI",BaseWindow)

function ChooseLuckyUI:ctor()
end

function ChooseLuckyUI:Create()
	local obj = LoadPrefabAndInit("LuckyUI/StartPopWindow",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ChooseLuckyUI:Init()
	-- 注册回退按钮
    local comButton_back = self:FindChildComponent(self._gameObject, "Buttons/Button_back", "Button")
	if comButton_back then
		self:RemoveButtonClickListener(comButton_back)
		self:AddButtonClickListener(comButton_back, function ()
			RemoveWindowImmediately("ChooseLuckyUI")
        end)
	end

	comButton_back = self:FindChildComponent(self._gameObject, "PopUpWindow_2/Board/Button_close", "Button")
	if comButton_back then
		self:RemoveButtonClickListener(comButton_back)
		self:AddButtonClickListener(comButton_back, function ()
			RemoveWindowImmediately("ChooseLuckyUI")
        end)
	end
	
	

	-- 注册使用按钮
    local comButton_Use = self:FindChildComponent(self._gameObject, "Buttons/Button_yes", "Button")
	if comButton_Use then
		self:RemoveButtonClickListener(comButton_Use)
		self:AddButtonClickListener(comButton_Use, function ()
			self:OnClick_UseLucky(true)
        end)
	end
	
	-- 注册不使用按钮
	local comButton_NotUse = self:FindChildComponent(self._gameObject, "Buttons/Button_no", "Button")
	if comButton_NotUse then
		self:RemoveButtonClickListener(comButton_NotUse)
		self:AddButtonClickListener(comButton_NotUse, function ()
			self:OnClick_UseLucky(false)
		end)
	end

	-- 当前拥有的幸运值
	self.txtText_CurLucky = self:FindChildComponent(self._gameObject, "Buttons/Button_yes/have/num", "Text")
	self.txtText_CostLucky = self:FindChildComponent(self._gameObject, "Buttons/Button_yes/Number", "Text")
    

end

function ChooseLuckyUI:RefreshUI(info)
	self.storyID = info.storyID

	local luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue() or 0
	self.txtText_CurLucky.text = tostring(luckyvalue)
	local storyData = TableDataManager:GetInstance():GetTableData("Story", self.storyID)
	if (storyData == nil) then
		return
	end
	self.txtText_CostLucky.text = tostring(storyData.LuckeyCost or 0)
end

-- 是否使用幸运值进入剧本
function ChooseLuckyUI:OnClick_UseLucky(use)
	if (use == nil) then
		return
	end

	if (not self.storyID) then
		return
	end

	local storyWindow = GetUIWindow("StoryUI")
	if (not storyWindow) then
		return
	end
	
	EnterStory(self.storyID, use, false, true)
end

return ChooseLuckyUI