TreasureBookStoreUI = class("TreasureBookStoreUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local l_DRCSRef_Type = DRCSRef_Type
function TreasureBookStoreUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function TreasureBookStoreUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self._gameObjectParent = objParent
    self._instParent = instParent
    local obj = self:FindChild(objParent, "TreasureBookStoreUI")
	if obj then
		self:SetGameObject(obj)
    end
    self.objPage = self:FindChild(self._gameObject, "Page")
    self.objPage:SetActive(false)
    self.svItemList = self:FindChildComponent(self.objPage, "ItemList/List", l_DRCSRef_Type.LoopVerticalScrollRect)
    self.svItemList:AddListener(function(...)
        self:UpdateItem(...)
    end)
    -- 详情
    self.objDetail = self:FindChild(self.objPage, "Detail")
    self.objDetail:SetActive(false)
    self.objRmbSign = self:FindChild(self.objDetail, "RmbSign")
    self.textDetailTitle = self:FindChildComponent(self.objDetail, "Title", l_DRCSRef_Type.Text)
    self.textDetailType = self:FindChildComponent(self.objDetail, "Type", l_DRCSRef_Type.Text)
    self.textDetailDesc = self:FindChildComponent(self.objDetail, "Desc/Viewport/Text", l_DRCSRef_Type.Text)
    self.textDetailChangeMsg = self:FindChildComponent(self.objDetail, "ChangeMsg", l_DRCSRef_Type.Text)
    self.textDetailCond = self:FindChildComponent(self.objDetail, "Cond", l_DRCSRef_Type.Text)
    local objNumBox = self:FindChild(self.objDetail, "NumBox")
    local btnNumBoxMin = self:FindChildComponent(objNumBox, "Min", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnNumBoxMin, function()
        self:OnClickNumBoxMin()
    end)
    local btnNumBoxAdd = self:FindChildComponent(objNumBox, "Add", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnNumBoxAdd, function()
        self:OnClickNumBoxAdd()
    end)
    local btnNumBoxAll =  self:FindChildComponent(objNumBox, "All", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnNumBoxAll, function()
        self:OnClickNumBoxAll()
    end)
    self.textNumBoxValue = self:FindChildComponent(objNumBox, "Value/Text", l_DRCSRef_Type.Text)
    -- 兑换按钮
    local objGet = self:FindChild(self.objDetail, "Get")
    self.btnGet = objGet:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnGet, function()
        self:OnClickGet()
    end)
    self.imgGet = objGet:GetComponent(l_DRCSRef_Type.Image)
    self.imgMoneyGet = self:FindChildComponent(objGet, "Image", l_DRCSRef_Type.Image)
    self.textGetValue = self:FindChildComponent(objGet, "Value", l_DRCSRef_Type.Text)
    -- 其他数据
    self.bookManager = TreasureBookDataManager:GetInstance()
    self.colorItemNamePick = DRCSRef.Color(0.9137255,0.9137255,0.9137255,1)
    self.colorItemNameUnPick = DRCSRef.Color(0.2352941, 0.2352941, 0.2352941,1)
    self.colorItemPricePick = DRCSRef.Color(0.8431373,0.7254902,0.6235294,1)
    self.colorItemPriceUnPick = DRCSRef.Color(0.5058824,0.4235294,0.3568628,1)
    self.strColorCondTrue = "<color=#10783f>%s</color>"
    self.strColorCondFalse = "<color=#913E2B>%s</color>"
    -- 灰度材质
    self.grayMat = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
end

function TreasureBookStoreUI:RefreshUI()
    -- 检查百宝书基础信息
    if self.bookManager:GetTreasureBookBaseInfo() then
        self:CheckStoreInfo()
    else
        self.bookManager:RequestTreasureBookBaseInfo()
    end
end

-- 检查百宝书商店兑换数据
function TreasureBookStoreUI:CheckStoreInfo()
    if self.bookManager:GetTreasureBookStoreData() then
        self:UpdateItemList()
    else
        self.bookManager:RequestTreasureBookStoreData()
    end
end

-- 更新物品列表
function TreasureBookStoreUI:UpdateItemList()
    self.kBaseInfo = self.bookManager:GetTreasureBookBaseInfo()
    if not self.kBaseInfo then
        return
    end
    self.kMallItemID2StoreInfo = self.bookManager:GetTreasureBookStoreData() or {}
    local iCurBookID = self.kBaseInfo.iCurBookID
    local kBook = TableDataManager:GetInstance():GetTableData("TreasureBook",iCurBookID)
    if not kBook then
        return
    end
    local aiShopIDs = kBook.ShopIDs
    if not (aiShopIDs and (#aiShopIDs > 0)) then
        return
    end
    -- 数据整理
    local akMallData = {}
    local kData = nil
    for index, id in ipairs(aiShopIDs) do
        kData = TableDataManager:GetInstance():GetTableData("TreasureBookMall",id)
        if kData then
            akMallData[#akMallData + 1] = kData
        end
    end
    table.sort(akMallData, function(a, b)
        return (a.ConvertLV or 0) < (b.ConvertLV or 0)
    end)
    self.akMallData = akMallData
    local iCount = #akMallData
    self.svItemList.totalCount = iCount
    if iCount == 0 then
        self.svItemList:RefillCells()
    else
        self.svItemList:RefreshCells()
        self.svItemList:RefreshNearestCells()
    end
    -- 更新商品显示
    self:UpdateCurChooseMallItemDetail()
    self.objPage:SetActive(true)
end

-- 更新物品ui信息
function TreasureBookStoreUI:UpdateItem(transform, index)
    if not (self.akMallData and transform and index) then
        return
    end
    local obj = transform.gameObject
    local kMallData = self.akMallData[index + 1]
    local iItemTypeID = kMallData.ItemID or 0
    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",iItemTypeID)
    if not itemTypeData then
        return
    end
    local textName = self:FindChildComponent(obj, "Name", l_DRCSRef_Type.Text)
    local strName = GetLanguageByID(kMallData.NameID)
    textName.text = getRankBasedText(itemTypeData.Rank, strName)
    local textPrice = self:FindChildComponent(obj, "Price/Text", l_DRCSRef_Type.Text)
    textPrice.text = tostring(kMallData.ConvertPrice)
    local objIcon = self:FindChild(obj, "Icon")
    self.ItemIconUI:UpdateUIWithItemTypeData(objIcon,itemTypeData)
    self.ItemIconUI:HideItemNum(objIcon)
    local funcOnClick = function()
        self:OnClickMallItem(obj, kMallData)
    end
    self.ItemIconUI:AddClickFunc(objIcon, funcOnClick)
    local btnItemInfo = self:FindChildComponent(obj, "Button", l_DRCSRef_Type.Button)
    self:RemoveButtonClickListener(btnItemInfo)
    self:AddButtonClickListener(btnItemInfo, funcOnClick)
    if not self.kFirstMallItem then
        self.kFirstMallItem = kMallData
        self.objFirstMallItem = obj
    end
end

-- 设置商店物品点击状态
function TreasureBookStoreUI:SetMallItemClickState(obj, bOn)
    if not obj then
        return
    end
    bOn = (bOn == true)
    local objOnClick = self:FindChild(obj, "ToggleFrame")
    if not objOnClick then
        return
    end
    objOnClick:SetActive(bOn)
    -- local textName = self:FindChildComponent(obj, "Name", l_DRCSRef_Type.Text)
    -- textName.color = bOn and self.colorItemNamePick or self.colorItemNameUnPick
    local textPrice = self:FindChildComponent(obj, "Price/Text", l_DRCSRef_Type.Text)
    textPrice.color = bOn and self.colorItemPricePick or self.colorItemPriceUnPick
end

-- 点击商店物品
function TreasureBookStoreUI:OnClickMallItem(obj, kMallData)
    if not (self.kMallItemID2StoreInfo and self.kBaseInfo
     and obj and kMallData) then
        return
    end
    local iItemTypeID = kMallData.ItemID or 0
    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",iItemTypeID)
    if not itemTypeData then
        return
    end
    if self.objCurChoose then
        self:SetMallItemClickState(self.objCurChoose, false)
    end
    
    local bNeedVip = kMallData.RichmanOnly == TBoolean.BOOL_YES
    local bIsVip = self.kBaseInfo.bRMBPlayer == true
    self.objRmbSign:SetActive(bNeedVip)
    local strName = GetLanguageByID(kMallData.NameID)
    self.textDetailTitle.text = getRankBasedText(itemTypeData.Rank, strName)
    self.textDetailType.text = GetEnumText("ItemTypeDetail", itemTypeData.ItemType)
    self.textDetailDesc.text = itemTypeData.ItemDesc or ''
    local iFullAmount = kMallData.ConvertAmount or 0  -- 商品总量
    local iCostAmount = self.kMallItemID2StoreInfo[kMallData.BaseID] or 0  --商品已兑量
    local iRemainAmount = iFullAmount - iCostAmount  --商品剩余可兑量
    iRemainAmount = (iRemainAmount < 0) and 0 or iRemainAmount
    local iAffordAmound = math.floor(self.kBaseInfo.iMoney / kMallData.ConvertPrice)  -- 目前余额可购量
    local iCanBuyMaxAmount = math.min(iRemainAmount, iAffordAmound)  -- 可兑最大量
    self.textDetailChangeMsg.text = string.format("已兑换%d个, 剩余可兑换%d个", iCostAmount, iRemainAmount)
    local bCanChange = (iCanBuyMaxAmount > 0)  -- 能否兑换
    local iCondLevel = kMallData.ConvertLV or 1
    local strCond = string.format("要求: 百宝书等级%d", iCondLevel)
    if (self.kBaseInfo.iLevel or 1) < iCondLevel then
        bCanChange = false
        strCond = string.format(self.strColorCondFalse, strCond)
    else
        strCond = string.format(self.strColorCondTrue, strCond)
    end
    if (not bIsVip) and bNeedVip then
        strCond = strCond .. string.format(self.strColorCondFalse, "\n开通壕侠版百宝书")
        bCanChange = false
    end
    self.textDetailCond.text = strCond
    self.textNumBoxValue.text = 1
    
    -- 设置按钮状态
    self.textGetValue.text = tostring(kMallData.ConvertPrice)
    self.btnGet.interactable = bCanChange
    if bCanChange then
        self.imgGet.material = nil
        self.imgMoneyGet.material = nil
    else
        self.imgGet.material = self.grayMat
        self.imgMoneyGet.material = self.grayMat
    end
    
    self.objCurChoose = obj
    self:SetMallItemClickState(obj, true)
    self.kCurChooseMallItem = kMallData
    self.iCurChooseCount = 1
    self.iCurChooseMaxCount = iCanBuyMaxAmount
    self.objDetail:SetActive(true)
end

-- 更新当前选择的物品的信息显示
function TreasureBookStoreUI:UpdateCurChooseMallItemDetail()
    -- 如果存在之前选中的物品, 那么保持选中, 否则选中第一个商品
    if self.objCurChoose and self.kCurChooseMallItem then
        self:OnClickMallItem(self.objCurChoose, self.kCurChooseMallItem)
    elseif self.objFirstMallItem and self.kFirstMallItem then
        self:OnClickMallItem(self.objFirstMallItem, self.kFirstMallItem)
    end
end

-- 更新数量显示
function TreasureBookStoreUI:UpdateChooseAmountMsg()
    if not self.kCurChooseMallItem then
        return
    end
    self.textNumBoxValue.text = tostring(self.iCurChooseCount)
    self.textGetValue.text = tostring(self.kCurChooseMallItem.ConvertPrice * self.iCurChooseCount)
end

-- 点击数量选择减
function TreasureBookStoreUI:OnClickNumBoxMin()
    self.iCurChooseCount = self.iCurChooseCount or 0
    if self.iCurChooseCount <= 1 then
        return
    end
    self.iCurChooseCount = self.iCurChooseCount - 1
    self:UpdateChooseAmountMsg()
end

-- 点击数量选择加
function TreasureBookStoreUI:OnClickNumBoxAdd()
    self.iCurChooseCount = self.iCurChooseCount or 0
    if self.iCurChooseCount >= self.iCurChooseMaxCount then
        return
    end
    self.iCurChooseCount = self.iCurChooseCount + 1
    self:UpdateChooseAmountMsg()
end

-- 点击数量选择 全部
function TreasureBookStoreUI:OnClickNumBoxAll()
    self.iCurChooseCount = self.iCurChooseMaxCount
    self:UpdateChooseAmountMsg()
end

-- 点击兑换物品
function TreasureBookStoreUI:OnClickGet()
    if not (self.kCurChooseMallItem and self.iCurChooseCount) then
        return
    end
    local iCost = self.iCurChooseCount * (self.kCurChooseMallItem.ConvertPrice or 0)
    local content = {
        ['title'] = "兑换物品",
        ['text'] = string.format("是否花费%d百宝书残页兑换%d件%s?", iCost, self.iCurChooseCount, GetLanguageByID(self.kCurChooseMallItem.NameID)),
    }
    local boxCallback = function()
        SendQueryTreasureBookInfo(STBQT_EXCHANGE, self.kCurChooseMallItem.BaseID, self.iCurChooseCount)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, boxCallback})
end

function TreasureBookStoreUI:OnDestroy()
    self.ItemIconUI:Close()
end

return TreasureBookStoreUI