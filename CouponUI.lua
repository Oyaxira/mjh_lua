CouponUI = class("CouponUI",BaseWindow)


function CouponUI:ctor()
	self.akItemUIClass = {}
end

function CouponUI:Create()
	local obj = LoadPrefabAndInit("TownUI/CouponUI", UI_UILayer, true)
	if obj then
		self:SetGameObject(obj)
	end
	self.objRoot = self:FindChild(self._gameObject, "Root")
	self.textTitle = self:FindChildComponent(self.objRoot, "Title/Text", "Text")
	self.textDesc = self:FindChildComponent(self.objRoot, "Desc", "Text")
	self.objItemList = self:FindChild(self.objRoot, "ItemList")
	local btnClose = self:FindChildComponent(self.objRoot, "Close", "Button")
	self:AddButtonClickListener(btnClose, function()
		self:OnClickClose()
	end)
	local objBuy = self:FindChild(self.objRoot, "Buy")
	local btnBuy = objBuy:GetComponent("Button")
	self:AddButtonClickListener(btnBuy, function()
		self:OnCLickBuy()
	end)
	self.textBuyNum = self:FindChildComponent(objBuy, "Number", "Text")
	self.objSilverSign = self:FindChild(objBuy, "Number/Silver")
	self.objGoldSign = self:FindChild(objBuy, "Number/Gold")
end

function CouponUI:ReturnAllIcons()
	if self.akItemUIClass and (#self.akItemUIClass > 0) then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
		self.akItemUIClass = {}
	end
end

function CouponUI:CreateIcon(kItemTypeData, iNum, kTransParent)
	if not (kItemTypeData and kTransParent) then
		return
	end
	local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, kTransParent)
	local iNum = iNum or 0
	kIconBindData:UpdateUIWithItemTypeData(kItemTypeData)
	kIconBindData:SetItemNum(iNum, iNum == 1)
	self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
	return kIconBindData
end

function CouponUI:RefreshUI(itemID)
	if not itemID then
		return
	end
	local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
	if (not itemTypeData) or (itemTypeData.ItemType ~= ItemTypeDetail.ItemType_Pub)
	or (not itemTypeData.Value1) or (itemTypeData.Value1 == 0) then
		return
	end
	local iCouponID = tonumber(itemTypeData.Value1)
	local kCouponData = TableDataManager:GetInstance():GetTableData("Coupon",iCouponID)
	if not (iCouponID and kCouponData) then
		return
	end
	self.iCurItemID = itemID
	
	self.textTitle.text = GetLanguageByID(kCouponData.NameID)
	self.textDesc.text = GetLanguageByID(kCouponData.DescID)
	local transItemList = self.objItemList.transform
	self:ReturnAllIcons()
	local objIconClone = nil
	for index, itemTypeID in ipairs(kCouponData.ItemInclude) do
		self:CreateIcon(TableDataManager:GetInstance():GetTableData("Item",itemTypeID), kCouponData.ItemNum[index] or 0, transItemList)
	end
	if kCouponData.CostSilver > 0 then
		self.objSilverSign:SetActive(true)
		self.textBuyNum.text = tostring(kCouponData.CostSilver)
		self.iCostSilver = kCouponData.CostSilver
	elseif kCouponData.CostGold > 0 then
		self.objGoldSign:SetActive(true)
		self.textBuyNum.text = tostring(kCouponData.CostGold)
		self.iCostGold = kCouponData.CostGold
	end
end

-- 点击关闭按钮
function CouponUI:OnClickClose()
	self:ReturnAllIcons()
	RemoveWindowImmediately("CouponUI")
end

-- 点击购买
function CouponUI:OnCLickBuy()
	local useFunc = function()
		SendUseStorageItem(1, {[0] = {["uiItemID"] = self.iCurItemID, ["uiItemNum"] = 1,}})
		RemoveWindowImmediately("CouponUI")
	end
	if self.iCostSilver and self.iCostSilver > 0 then
		PlayerSetDataManager:GetInstance():RequestSpendSilver(self.iCostSilver, useFunc)
		return
	end
	if self.iCostGold and self.iCostGold > 0 then
		PlayerSetDataManager:GetInstance():RequestSpendGold(self.iCostGold, useFunc, true)
	end
end

function CouponUI:OnDestroy()
	self:ReturnAllIcons()
end

return CouponUI