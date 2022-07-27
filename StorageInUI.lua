StorageInUI = class("StorageInUI",BaseWindow)
local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'

function StorageInUI:ctor()

end

function StorageInUI:Create()
	local obj = LoadPrefabAndInit("Create/StorageInUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function StorageInUI:Init()
	self.ItemInfoUI = ItemInfoUI.new()

	self.comCloseButton = self:FindChildComponent(self._gameObject, 'Button_close', 'Button')
	if self.comCloseButton then
		self:AddButtonClickListener(self.comCloseButton,function()
			RemoveWindowImmediately("StorageInUI")
		end)
	end

	self.comLoopScroll = self:FindChildComponent(self._gameObject, 'SC_item/LoopScrollView', 'LoopVerticalScrollRect')
    self.comLoopScroll:AddListener(function(...) self:UpdateItemUI(...) end)
end

function StorageInUI:RefreshUI(info)
	self.auiItemIDList = info.auiItemIDs
	self.comLoopScroll.totalCount = info.iSize
	self.comLoopScroll:RefreshNearestCells()
end

function StorageInUI:UpdateItemUI(transform, index)
    if not self.auiItemIDList then 
        self:UpdateBackpack()
	end
	local itemData = ItemDataManager:GetInstance():GetItemData(self.auiItemIDList[index])
	if itemData then
		self.ItemInfoUI:UpdateUIWithItemInstData(transform.gameObject, itemData)
	end
end

function StorageInUI:OnDestroy()
    self.comLoopScroll:RemoveListener()
	self.ItemInfoUI:Close()
end

return StorageInUI