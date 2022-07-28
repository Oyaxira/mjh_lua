ShopDataManager = class("ShopDataManager")
ShopDataManager._instance = nil

function ShopDataManager:GetInstance()
    if ShopDataManager._instance == nil then
        ShopDataManager._instance = ShopDataManager.new()
        ShopDataManager._instance:Init()
    end

    return ShopDataManager._instance
end

function ShopDataManager:Init()
    self:ResetManager()
end

function ShopDataManager:ResetManager()
    self.shopData = {}
    self.shopItemDiscountData = nil
    self.sellDisCount = nil
    self.dynamicShopItemRatio = nil
    self.kDyShopItemCheck = nil
    self.bLockShopItemDiscount = nil
    self.kLockShopItemDiscountMap = nil
end

-- 获取 Shop 表的 物品数据
function ShopDataManager:GetShopItemTypeDataByTypeID(baseID)
    return TableDataManager:GetInstance():GetTableData("Shop", baseID)
end

-- 获取 Item 表的 物品数据
function ShopDataManager:GetItemTypeDataByShopItemTypeID(baseID)
    local itemData = self:GetShopItemTypeDataByTypeID(baseID)
    if itemData then 
        local itemID = itemData.ItemID
        return TableDataManager:GetInstance():GetTableData("Item",itemID)
    end
    return nil
end

-- 获取 神秘商店经过强化后的售卖数值提升万分比
function ShopDataManager:GetItemMysterShopPricePer(RankType)
  local mainRoleInfo = globalDataPool:getData("MainRoleInfo");
  local curDiff = mainRoleInfo.MainRole[MainRoleData.MRD_DIFF];

  local baseid = RankType << 10 | curDiff;
  local tableAutoGenStrength = TableDataManager:GetInstance():GetTableData("ItemAutoGenStrength",baseid)

  if (tableAutoGenStrength) then
    return tableAutoGenStrength.MysteShopPricePer or 0
  end
  return 0
end

-- 获取Shop表商品原价
function ShopDataManager:GetShopItemOriPrice(baseID)
    local shopItemData = self:GetShopItemTypeDataByTypeID(baseID)
    if not shopItemData then return 0 end
    if shopItemData.BuyPrice ~= 0 then
        return shopItemData.BuyPrice
    end
    local itemTypeData = self:GetItemTypeDataByShopItemTypeID(baseID)
    if itemTypeData then 
        return itemTypeData.BuyPrice or 0
    end
    return 0
end

-- 锁定商店折扣
function ShopDataManager:SetLockShopItemDiscount(bLock)
    -- 锁定折扣时同一个DiscountID的折扣会记录缓存，不会重复计算
    self.bLockShopItemDiscount = bLock
    self.kLockShopItemDiscountMap = {}
end

-- 查询商店商品折扣
function ShopDataManager:GetShopItemDiscount(discountID)
    if not discountID or discountID == 0 then
        return 1
    end

    -- 折扣缓存
    if self.bLockShopItemDiscount and self.kLockShopItemDiscountMap and
     self.kLockShopItemDiscountMap[discountID] then
        return self.kLockShopItemDiscountMap[discountID] / 10000
    end

    -- 这个接口只根据主角仁义值或门派好感计算普通商店的折扣
    -- 黑心商人/神秘商人的价格折扣使用不同的规则另外计算的
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    local iGoodEvil = 0
    if mainRoleData then
        iGoodEvil = mainRoleData["iGoodEvil"] or 0
    end

    local discount = 10000
    local TB_ShopDiscount = TableDataManager:GetInstance():GetTable("ShopDiscount")
    for index, data in pairs(TB_ShopDiscount) do
        if data.DiscountID == discountID and data.Discount < discount then
            local success = false
            if data.DiscountType == ShopDiscountType.SPDT_GOODEVIL then
                if iGoodEvil >= data.GoodEvil then
                    success = true
                end
            elseif data.DiscountType == ShopDiscountType.SPDT_CLANDISPOSITION then
                local clanDisposition = ClanDataManager:GetInstance():GetDisposition(data.ClanID)
                success = clanDisposition >= data.ClanDisposition
            end

            if success then
                discount = data.Discount
            end
        end
    end

    if self.bLockShopItemDiscount then
        self.kLockShopItemDiscountMap = self.kLockShopItemDiscountMap or {}
        self.kLockShopItemDiscountMap[discountID] = discount
    end
    
    return discount / 10000
end

function ShopDataManager:GetShopItemSellPrice(itemID)
    -- 成就带入的折扣
    if self.sellDisCount == nil then
        self.sellDisCount = 10000
        local info = globalDataPool:getData("MainRoleInfo");
        if info then
            self.sellDisCount = self.sellDisCount + info.MainRole[MainRoleData.MRD_EXTRA_ROLESELLITEM];
        end
    end
    local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
    if itemTypeData then
        return math.floor(itemTypeData.SellPrice * self.sellDisCount / 10000);
    end
    return 0;
end

-- 获取商品价格
function ShopDataManager:GetShopItemPrice(baseID)
    local kShopItemBaseData = self:GetShopItemTypeDataByTypeID(baseID)
    if not kShopItemBaseData then
        return 0, 0, false
    end
    
    -- 查询折扣
    local discount = self:GetShopItemDiscount(kShopItemBaseData.DiscountID) or 1
    -- 获取物品原价
    local oriPrice = self:GetShopItemOriPrice(baseID)
    -- 计算折扣价
    local finalPrice = math.floor(oriPrice * discount)
    -- 不小于1
    if finalPrice <= 0 and oriPrice > 0 then
        finalPrice = 1
    end
    -- 判断是否发生了折扣
    local bIsDiscount = finalPrice < oriPrice
    -- 返回 实际价格, 原价, 是否发生了折扣
    return finalPrice, oriPrice, bIsDiscount
end

-- 获取商品余量
function ShopDataManager:GetShopItemRemainNum(baseID)
    local shopItemTypeData = self:GetShopItemTypeDataByTypeID(baseID)
    if not shopItemTypeData then 
        return 0
    end
    local maxCount = shopItemTypeData.MaxCount
    local boughtCount = self:GetShopItemBoughtNum(baseID) or 0
    return maxCount - boughtCount
end

-- 获取某个物品是否补货
function ShopDataManager:IsReplenish(baseID)
    local itemData = self:GetShopItemTypeDataByTypeID(baseID)
    if not itemData then 
        return false
    end
    return (itemData['IsReplenish'] == TBoolean.BOOL_YES)
end

-- 获取商品已购数量
function ShopDataManager:GetShopItemBoughtNum(shopItemBaseID)
    local shopData = self.shopData
    if not (shopData and shopData["BuyItem"] and shopData["BuyItem"][shopItemBaseID]) then
        return 0
    end
    return shopData["BuyItem"][shopItemBaseID]
end

function ShopDataManager:ClearShopItem()
    -- 保留静态商店中不补货商品的购买信息, 其他的全部清空
    local boughtItemList = self.shopData["BuyItem"] or {}
    local newBoughtList = {}
    local baseID, data = nil, nil
    for shopBaseID, iNum in pairs(boughtItemList) do
        if self:IsReplenish(shopBaseID) == false then
            newBoughtList[shopBaseID] = iNum
        end
    end
    self.shopData = {
        ["BuyItem"] = newBoughtList
    }
    self.kDyShopItemCheck = nil
end

-- 服务器操作：更新购买的物品数量
function ShopDataManager:UpdateBuyItem(info)
    if not info then return end
    local akShopItems = info.akShopItems
    if not (akShopItems and akShopItems[0]) then return end
    local shopData = self.shopData
    local bussinessManID = info.uiShopID
    local bussinessManData = TableDataManager:GetInstance():GetTableData("Businessman", bussinessManID)
    if not bussinessManData then
        derror("can't find bussinessManData in table [Businessman] with base id: " .. tostring(bussinessManID))
        return
    end
    -- 如果是动态商店, 那么下发的是Item的动态id
    -- 如果是静态商店, 那么下发的是ShopItem的静态id与数量
    if bussinessManData["PlanID"] and (bussinessManData["PlanID"] ~= 0) then
        -- 动态商店每个月演化一次补货一次,会先全部清空,在进行补货
        -- 动态商店在售商品表
        local onSellItemList = shopData["OnSellItem"] or {}
        local itemListThisShop = onSellItemList[bussinessManID] or {}
        -- 清理原来的排序表
        itemListThisShop['sortedList'] = nil
        -- 更新数据
        if not self.kDyShopItemCheck then
            self.kDyShopItemCheck = {}
        end
        for index, data in pairs(akShopItems) do
            -- 下发的数据中, 如果数量为0则表示移除该条数据, 否则, 存入商品列表
            if data.uiNum > 0 then
                itemListThisShop[data.uiShopItemID] = {['num'] = data.uiNum, ['price'] = data.uiPrice}
                self.kDyShopItemCheck[data.uiShopItemID] = true
            elseif data.uiNum == 0 then
                itemListThisShop[data.uiShopItemID] = nil
                self.kDyShopItemCheck[data.uiShopItemID] = nil
            end
        end
        -- 生成排序表, 用于固定商店商品显示的顺序
        local sortedList = {}
        for id, v in pairs(itemListThisShop) do
            sortedList[#sortedList + 1] = {
                ['uid'] = id,
                ['num'] = v.num,
                ['price'] = v.price
            }
        end
        table.sort(sortedList, function(a, b)
            return a.uid < b.uid
        end)
        itemListThisShop['sortedList'] = sortedList
        onSellItemList[bussinessManID] = itemListThisShop
        shopData["OnSellItem"] = onSellItemList
    else
        -- 静态商店已购商品数量
        local boughtItemList = shopData["BuyItem"] or {}
        local baseID = nil
        local data = nil
        for index = 0, #akShopItems do
            data = akShopItems[index]
            baseID = data['uiShopItemID']
            boughtItemList[baseID] = data['uiNum'] or 0
        end
        shopData["BuyItem"] = boughtItemList
    end
    self.shopData = shopData
    self:DispatchUpdateEvent()
end

-- 检查某一物品是否是属于动态商店的物品
function ShopDataManager:CheckDyShopBelongItem(uiItemID)
    if (not self.kDyShopItemCheck) or (not uiItemID) then
        return false
    end
    return (self.kDyShopItemCheck[uiItemID] == true)
end

-- 获取动态商店在售物品列表
function ShopDataManager:GetDynamicShopItems(bussinessManID)
    local shopData =  self.shopData
    local onSellItemList = shopData["OnSellItem"] or {}
    local itemListThisShop = onSellItemList[bussinessManID] or {}
    return itemListThisShop['sortedList'] or {}
end

-- 获取动态商店在售物品数量
function ShopDataManager:GetDynamicShopItemNum(bussinessManID, itemID)
    local shopData = self.shopData
    local onSellItemList = shopData["OnSellItem"] or {}
    local itemListThisShop = onSellItemList[bussinessManID] or {}
    if (not itemListThisShop[itemID]) then return 0 end
    return itemListThisShop[itemID].num or 0
end

function ShopDataManager:GetDynamicShopItemPrice(bussinessManID, itemID)
  local shopData = self.shopData
  local onSellItemList = shopData["OnSellItem"] or {}
  local itemListThisShop = onSellItemList[bussinessManID] or {}
  if (not itemListThisShop[itemID]) then return 0 end
  return itemListThisShop[itemID].price or 0
end

-- 获取动态商店在售物品溢价倍数
function ShopDataManager:GetDynamicShopItemRatio(bussinessManID, iRank)
    -- bussinessManID [1:神秘商人] [2:黑市商人][6:张小瑛]
    if not self.dynamicShopItemRatio then
        local ratioMap = {}
        local MysteryShopID = 1
        local BadMerchantID = 2
        local MysteryShopID_ZHANGXIAOYING = 6

        ratioMap[MysteryShopID] = {}
        ratioMap[BadMerchantID] = {}
        ratioMap[MysteryShopID_ZHANGXIAOYING] = {}
        local TB_ShopDiscount = TableDataManager:GetInstance():GetTable("ShopDiscount")
        for index, data in pairs(TB_ShopDiscount) do
            if data.MysteryShop then
                ratioMap[MysteryShopID][data.MysteryShop] = (data.Discount or 10000) / 10000
                ratioMap[MysteryShopID_ZHANGXIAOYING][data.MysteryShop] = (data.Discount or 10000) / 10000
            elseif data.BadMerchant then
                ratioMap[BadMerchantID][data.BadMerchant] = (data.Discount or 10000) / 10000
            end
        end
        self.dynamicShopItemRatio = ratioMap
    end
    local data = self.dynamicShopItemRatio[bussinessManID] or {}
    local ratio = data[iRank] or 1
    return ratio
end

-- -- 获取动态商店在售物品价格
-- function ShopDataManager:GetDynamicShopItemPrice(bussinessManID, itemID)
--     local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
--     if not itemTypeData then return 0 end
--     local oriPrice = itemTypeData and (itemTypeData.BuyPrice or 0) or 0

--     local priceStrengthPer = 0    
--     if (ItemDataManager:GetInstance():IsEquipItem(nil,itemTypeData.BaseID)) then
--       priceStrengthPer = self:GetItemMysterShopPricePer(itemTypeData.Rank) / 10000.0 + 1.0
--       oriPrice = (priceStrengthPer * oriPrice)
--     end

--     -- 根据神秘商店/黑心商人, 做溢价
--     local rank = itemTypeData.Rank or 1
--     local ratio = self:GetDynamicShopItemRatio(bussinessManID, rank) or 1
--     return math.ceil(oriPrice * ratio)
-- end

-- 获取商品购买条件 返回(能否购买, 条件描述)
function ShopDataManager:GenShopItemBuyCondition(shopItemTypeID)
    local shopItemTypeData = TableDataManager:GetInstance():GetTableData("Shop",shopItemTypeID)
    if not (shopItemTypeData) then 
        return true
    end
    local cityFavorLimit = shopItemTypeData.BuyInt
    local cityTypeID = shopItemTypeData.BuyCity
    if not (cityFavorLimit and cityTypeID) or (cityFavorLimit <= 0) or (cityTypeID <= 0) then
        return true
    end

	local cityData = CityDataManager:GetInstance():GetCityData(cityTypeID)
    if not cityData then
        return true
    end
    local sCityName = GetLanguageByID(cityData.NameID)
    local condRes = (cityData.iCityDispo or 0) >= cityFavorLimit
    local condDesc = string.format("%s好感度达到%.0f", sCityName, cityFavorLimit)
    return condRes, condDesc
end

function ShopDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_STORE_DATA")
end
