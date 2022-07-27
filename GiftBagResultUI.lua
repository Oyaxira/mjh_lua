GiftBagResultUI = class("GiftBagResultUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
--------以下是界面配置数据----------
-- 单行物品的数量
local SINGLE_ROW_COUNT = 5
-- 行数对应的高度
local ROW_COUNT_HEIGHT = {
	[1] = 200,
	[2] = 300,
	[3] = 360,
}
-- 轮询间隔时间 ms
local ROLL_CHECK_TIME = 300
-- 允许关闭间隔时间 ms
local CLOSE_WAIT_TIME = 500

function GiftBagResultUI:ctor()
	self.kItemIconMgr = ItemIconUI.new()
end

function GiftBagResultUI:Create()
	local obj = LoadPrefabAndInit("TownUI/GiftBagResultUI", TIPS_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
	self.objRoot = self:FindChild(self._gameObject, "Root")
	self.svItemList = self:FindChildComponent(self.objRoot, "ItemList", l_DRCSRef_Type.LoopVerticalScrollRect)
	self.svItemList:AddListener(function(transform, index) 
		if self:IsOpen() ~= true then
			return
		end
        self:UpdateItemIcon(transform, index)
	end)
	local btnClose = self:FindChildComponent(self._gameObject, "Bac", l_DRCSRef_Type.Button)
	self:AddButtonClickListener(btnClose, function()
		self:OnClickClose()
	end)
end

function GiftBagResultUI:RefreshUI(akItemListInfo)
	if not (akItemListInfo and next(akItemListInfo)) then
		return
	end
	self:AppendItems(akItemListInfo)
	self:ReSortAndShow()
	-- 开启一个计时器轮询
	if self.iCheckTimer then
		self:RemoveTimer(self.iCheckTimer)
		self.iCheckTimer = nil
	end
	self.iCheckTimer = self:AddTimer(ROLL_CHECK_TIME, function()
		if self.bNeedReset ~= true then
			return
		end
		self:ReSortAndShow()
	end, -1)

	-- 延迟一段时间后才能关闭窗口
	self.bCanClose = false
	if self.iCanCloseTimer then
		self:RemoveTimer(self.iCanCloseTimer)
		self.iCanCloseTimer = nil
	end
	self.iCanCloseTimer = self:AddTimer(CLOSE_WAIT_TIME, function()
		self.bCanClose = true
	end, 1)
end

function GiftBagResultUI:AppendItems(akItemListInfo)
	if not self.kItemList then
		self.kItemList = {}
	end
	local bHasNewItem = false
	for index = 0, #akItemListInfo do
		local iItemInstID = akItemListInfo[index].dwItemUID or 0
		local kItemInstData = ItemDataManager:GetInstance():GetItemData(iItemInstID)
		local iItemBaseID = akItemListInfo[index].dwItemTypeID or 0
		local kItemBaseData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(iItemBaseID)
		if kItemBaseData then
			local iNum = akItemListInfo[index].dwNum or 0
			self.kItemList[#self.kItemList + 1] = {
				['BaseItem'] = kItemBaseData,
				['InstItem'] = kItemInstData,
				['Num'] = iNum
			}
			bHasNewItem = true
		end
	end
	self.bNeedReset = bHasNewItem
end

-- 排序数据并刷新滚动栏
function GiftBagResultUI:ReSortAndShow()
	if not self.kItemList then
		self.kItemList = {}
	end
	table.sort(self.kItemList, function(a, b)
		if a.BaseItem.Rank == b.BaseItem.Rank then
			return a.BaseItem.BaseID > b.BaseItem.BaseID
		else
			return a.BaseItem.Rank > b.BaseItem.Rank
		end
	end)
	-- 刷新界面高度
	self:ReSetUIHeight()
	-- 设置滚动栏
	self.svItemList.totalCount = #self.kItemList
	self.svItemList:RefillCells()
	-- 重置标记
	self.bNeedReset = false
end

-- 刷新界面高度
function GiftBagResultUI:ReSetUIHeight()
	if not self.kItemList then
		self.kItemList = {}
	end
	local iSumItemCount = #self.kItemList
	local iRowCount = math.ceil(iSumItemCount / SINGLE_ROW_COUNT)
	if iRowCount <= 0 then
		iRowCount = 1
	end
	if iRowCount > #ROW_COUNT_HEIGHT then
		iRowCount = #ROW_COUNT_HEIGHT
	end
	if iRowCount == self.iCurRowCount then
		return
	end
	local iRootHeight = ROW_COUNT_HEIGHT[iRowCount]
	if iRootHeight <= 0 then
		return
	end
	SetUIAxis(self.objRoot, nil, iRootHeight)
	self.iCurRowCount = iRowCount
end

function GiftBagResultUI:UpdateItemIcon(transform, index)
	if not (transform and index and self.kItemList and self.kItemList[index + 1]) then
		return
	end
	local objIcon = transform.gameObject
	local kItemInfo = self.kItemList[index + 1]
	local kItemInstData = kItemInfo.InstItem
	local kItemBaseData = kItemInfo.BaseItem
	local iItemNum = kItemInfo.Num or 1
	-- 至少需要拥有静态数据来表现
	if not (objIcon and kItemBaseData) then
		return
	end
	if kItemInstData then
		self.kItemIconMgr:UpdateUIWithItemInstData(objIcon, kItemInstData)
	else
		self.kItemIconMgr:UpdateUIWithItemTypeData(objIcon, kItemBaseData)
	end
	self.kItemIconMgr:SetItemNum(objIcon, iItemNum, iItemNum <= 1)
	self.kItemIconMgr:ShowExtraName(objIcon, true)
end

-- 点击关闭按钮
function GiftBagResultUI:OnClickClose()
	if self.bCanClose == false then
		return
	end

	if self.iCheckTimer then
		self:RemoveTimer(self.iCheckTimer)
		self.iCheckTimer = nil
	end
	self.kItemList = {}
	RemoveWindowImmediately("GiftBagResultUI")
end

function GiftBagResultUI:OnDestroy()
	self.kItemIconMgr:Close()
end

return GiftBagResultUI