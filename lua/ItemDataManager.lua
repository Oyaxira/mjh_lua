ItemDataManager = class("ItemDataManager")
ItemDataManager._instance = nil

local l_itemCommonCondTypeToAttrType = {
    [ItemCommonUseCondType.ICUCT_QUANZHANGJINGTONG] = AttrType.ATTR_QUANZHANGJINGTONG, -- 拳掌精通
    [ItemCommonUseCondType.ICUCT_JIANFAJINGTONG] = AttrType.ATTR_JIANFAJINGTONG, -- 剑法精通
    [ItemCommonUseCondType.ICUCT_DAOFAJINGTONG] = AttrType.ATTR_DAOFAJINGTONG, -- 刀法精通
    [ItemCommonUseCondType.ICUCT_TUIFAJINGTONG] = AttrType.ATTR_TUIFAJINGTONG, -- 腿法精通
    [ItemCommonUseCondType.ICUCT_QIMENJINGTONG] = AttrType.ATTR_QIMENJINGTONG, -- 奇门精通
    [ItemCommonUseCondType.ICUCT_ANQIJINGTONG] = AttrType.ATTR_ANQIJINGTONG, -- 暗器精通
    [ItemCommonUseCondType.ICUCT_YISHUJINGTONG] = AttrType.ATTR_YISHUJINGTONG, -- 医术精通
    [ItemCommonUseCondType.ICUCT_NEIGONGJINGTONG] = AttrType.ATTR_NEIGONGJINGTONG, -- 内功精通
    [ItemCommonUseCondType.ICUCT_MAXHP] = AttrType.ATTR_MAXHP, -- 生命
    [ItemCommonUseCondType.ICUCT_MAXMP] = AttrType.ATTR_MAXMP, -- 真气
    [ItemCommonUseCondType.ICUCT_MARTIAL_ATK] = AttrType.ATTR_MARTIAL_ATK, -- 武学攻击
    [ItemCommonUseCondType.ICUCT_DEF] = AttrType.ATTR_DEF, -- 防御
    [ItemCommonUseCondType.ICUCT_SUDUZHI] = AttrType.ATTR_SUDUZHI, -- 速度值
}

function ItemDataManager:GetInstance()
    if ItemDataManager._instance == nil then
        ItemDataManager._instance = ItemDataManager.new()
        ItemDataManager._instance:Init()
    end

    return ItemDataManager._instance
end

function ItemDataManager:Init()
    self:SplitTypeDatas()
    self:InitEquipSlot2Type()
end

function ItemDataManager:ResetManager()
    self.bIsObserveData = nil
    self.bIsArenaObserveData = nil
    self.newItems = nil
    self.smeltPowderLookUp = nil
    self.kItemStrengthenCondLevelUpValueMap = nil
    self.kFakeItemBattleDataPool = nil
    self.mainRoleNewItemRecord = nil
end

-- 根据类型分割数据
function ItemDataManager:SplitTypeDatas()
    if self._splitData then
        return
    end
    
    self._martial2book = {}
    self._gift2item = {}

    local splitData = {}
    local itemType = nil
    local TB_Item = TableDataManager:GetInstance():GetTable("Item")
    for index, typeData in pairs(TB_Item) do
        itemType = typeData.ItemType
        if not splitData[itemType] then
            splitData[itemType] = {}
        end
        if (itemType == ItemTypeDetail.ItemType_SecretBook) or (itemType == ItemTypeDetail.ItemType_IncompleteBook) then
            splitData[itemType][typeData.MartialID] = typeData
        elseif itemType == ItemTypeDetail.ItemType_HeavenBook then
            splitData[itemType][typeData.GiftID] = typeData
        elseif itemType == ItemTypeDetail.ItemType_RolePieces then
            splitData[itemType][typeData.FragmentRole] = typeData
        end

        if itemType == ItemTypeDetail.ItemType_SecretBook then
            self._martial2book[typeData.MartialID] = index
        elseif itemType == ItemTypeDetail.ItemType_HeavenBook then
            self._gift2item[typeData.GiftID] = index
        end
    end
    -- 宠物卡物品和宠物id的对应关系要到宠物表里去找
    local petItemType = ItemTypeDetail.ItemType_PetPieces
    if not splitData[petItemType] then
        splitData[petItemType] = {}
    end
    local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
    for index, typeData in pairs(TB_Pet) do
        splitData[petItemType][typeData.BaseID] = TB_Item[typeData.itemTypeID]
    end
    self._splitData = splitData
end

function ItemDataManager:GetBookItemByMartial(uiMartialTypeID)
    return self._martial2book[uiMartialTypeID]
end

function ItemDataManager:GetGiftItemByGift(uiGiftTypeID)
    return self._gift2item[uiGiftTypeID]
end

-- 根据类型和键查找物品静态数据
function ItemDataManager:GetItemTypeDataByItemTypeAndKey(itemType, iKey)
    if not (itemType and self._splitData and self._splitData[itemType]) then
        return
    end
    if not iKey then
        return self._splitData[itemType]
    end
    return self._splitData[itemType][iKey]
end

-- 装备位枚举对应到物品的大类
local EquipSlot2MainType = {
    [REI_CLOTH] = ItemTypeDetail.ItemType_Clothes,  -- 衣服
    [REI_SHOE] = ItemTypeDetail.ItemType_Shoe,  -- 鞋子
    [REI_JEWELRY] = ItemTypeDetail.ItemType_Ornaments,  -- 饰品
    [REI_WING] = ItemTypeDetail.ItemType_Wing,  -- 翅膀
    [REI_HORSE] = ItemTypeDetail.ItemType_Mounts,  -- 坐骑
    [REI_WEAPON] = ItemTypeDetail.ItemType_Weapon,  -- 武器
    [REI_THRONE] = ItemTypeDetail.ItemType_Artifact,  -- 神器
    [REI_RAREBOOK] = ItemTypeDetail.ItemType_SecretBook,  -- 秘籍
    [REI_ANQI] = ItemTypeDetail.ItemType_HiddenWeapon,  -- 暗器
    [REI_MEDICAL] = ItemTypeDetail.ItemType_Leechcraft,  -- 医术
}
function ItemDataManager:InitEquipSlot2Type()
    if self.kSlot2ItemType then
        return
    end
    -- 分析 物品子类 -> 装备位枚举
    local kSlot2ItemType = {}
    local kItemBaseData = nil
    local TB_ItemType = TableDataManager:GetInstance():GetTable("ItemType")
    for eSlot, eItemMainType in pairs(EquipSlot2MainType) do
        kSlot2ItemType[eItemMainType] = eSlot
        kItemBaseData = TB_ItemType[eItemMainType]
        if kItemBaseData.ChildItemType then
            for _, eChildType in ipairs(kItemBaseData.ChildItemType) do
                kSlot2ItemType[eChildType] = eSlot
            end
        end
    end
    self.kSlot2ItemType = kSlot2ItemType
end

-- 分流ItemType
function ItemDataManager:SplitItemType()
    if self.eItemType2ChildType then
        return self.eItemType2ChildType
    end
    self.eItemType2ChildType = {}
    local kChildTypes = nil
    local kChildTypeBaseData = nil
    local TBItemType = TableDataManager:GetInstance():GetTable("ItemType")
    for index, baseData in ipairs(TBItemType) do
        kChildTypes = baseData.ChildItemType
        if kChildTypes and (#kChildTypes > 0) then
            for _, baseID in ipairs(kChildTypes) do
                kChildTypeBaseData = TBItemType[baseID]
                if kChildTypeBaseData then
                    if not self.eItemType2ChildType[baseData.EnumType] then
                        self.eItemType2ChildType[baseData.EnumType] = {}
                    end
                    table.insert(self.eItemType2ChildType[baseData.EnumType], kChildTypeBaseData)
                end
            end
        end
    end
    return self.eItemType2ChildType
end


-- 根据物品类型获取装备对应的装备位
function ItemDataManager:GetEquipSlotByItemType(eItemType)
    if not self.kSlot2ItemType then
        return REI_NULL
    end
    if not eItemType then
        return self.kSlot2ItemType
    end
    return self.kSlot2ItemType[eItemType] or REI_NULL
end

-- 根据物品类型获取装备对应的装备位
function ItemDataManager:GetEquipSlotByItemInstID(uiItemInstID)
    if not self.kSlot2ItemType then
        return REI_NULL
    end
    local kTarInstItem = self:GetItemDataInItemPool(uiItemInstID or 0)
    if not kTarInstItem then
        return REI_NULL
    end
    if kTarInstItem.eTarEquipSlot then
        return kTarInstItem.eTarEquipSlot
    end
    kTarInstItem.eTarEquipSlot = self:GetEquipSlotByItemBaseID(kTarInstItem.uiTypeID)
    return kTarInstItem.eTarEquipSlot
end

-- 根据物品类型获取装备对应的装备位
function ItemDataManager:GetEquipSlotByItemBaseID(uiItemBaseID)
    if not self.kSlot2ItemType then
        return REI_NULL
    end
    local kTarBaseItem = TableDataManager:GetInstance():GetTableData("Item", uiItemBaseID or 0)
    if (not kTarBaseItem) or (not kTarBaseItem.ItemType) then
        return REI_NULL
    end
    return self.kSlot2ItemType[kTarBaseItem.ItemType] or REI_NULL
end

-- 获取物品品质
function ItemDataManager:GetItemRankByItemInstID(uiItemInstID)
    local kTarInstItem = self:GetItemDataInItemPool(uiItemInstID or 0)
    if not kTarInstItem then
        return RankType.RT_White
    end
    if kTarInstItem.eRank then
        return kTarInstItem.eRank
    end
    kTarInstItem.eRank = self:GetItemRankByItemBaseID(kTarInstItem.uiTypeID)
    return kTarInstItem.eRank
end

-- 装备是否属于主角
function ItemDataManager:IsEquipItemBelongToMainRole(uiItemInstID)
    local kTarInstItem = self:GetItemDataInItemPool(uiItemInstID or 0)
    if not kTarInstItem then
        return false
    end
    return (kTarInstItem.bBelongToMainRole == 1)
end

-- 获取物品品质
function ItemDataManager:GetItemRankByItemBaseID(uiItemBaseID)
    local kTarBaseItem = TableDataManager:GetInstance():GetTableData("Item", uiItemBaseID or 0)
    if not kTarBaseItem then
        return RankType.RT_White
    end
    return kTarBaseItem.Rank or RankType.RT_White
end

-- 根据 静态ID，获取当前物品的数量
function ItemDataManager:GetItemNumByTypeID(baseID, ownerID)
    if not baseID then 
        return 0 
    end
    ownerID = ownerID or RoleDataManager:GetInstance():GetMainRoleID()
    local total = 0
    local itemPool = globalDataPool:getData("ItemPool") or {}
    for k,v in pairs(itemPool) do
        if v.uiTypeID == baseID and (ownerID == 0 or ownerID == v.uiOwnerID) then
            total = total + (v.uiItemNum or 0)
        end
    end
    return total
end

function ItemDataManager:GetItemData(itemID)
    if not itemID then
        return
    end
    local info = nil
    --- -1平台 
    if GetGameState() == -1 then
        local observeUI = GetUIWindow('ObserveUI');
        local characterUI = GetUIWindow('CharacterUI');
        if (observeUI and observeUI:IsOpen()) or (characterUI and characterUI:IsOpen()) then
            info = globalDataPool:getData("PlatTeamInfo") or {};
            if self.bIsArenaObserveData then
                info = globalDataPool:getData("ObserveArenaInfo") or {};
            elseif self.bIsObserveData then
                info = globalDataPool:getData("ObserveInfo") or {};
            end
            if (info.ItemInfos and info.ItemInfos[itemID]) then
                return info.ItemInfos[itemID]
            end
        end 
    else
        if self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
            if (info.ItemInfos and info.ItemInfos[itemID]) then
                return info.ItemInfos[itemID]
            end
        end
        -- 查找itembattle 假物品
        if (itemID < 0) and (self.kFakeItemBattleDataPool ~= nil)
        and (self.kFakeItemBattleDataPool[itemID]) then
            return self.kFakeItemBattleDataPool[itemID]
        end
        -- 查找常规动态物品
        info = globalDataPool:getData("ItemPool") or {}
        if info[itemID] then
            return info[itemID]
        end
    end

    -- 如果剧本内物品查找不到, 查找仓库物品
    return StorageDataManager:GetInstance():GetItemData(itemID)
end

function ItemDataManager:GetItemDataInItemPool(itemID)
    if (not itemID) or (itemID == 0) then
        return
    end
    info = globalDataPool:getData("ItemPool") or {}
    return info[itemID]
end

function ItemDataManager:SetObserveData(bIsObserveData)
    self.bIsObserveData = bIsObserveData;
end

function ItemDataManager:SetArenaObserveData(bIsArenaObserveData)
    self.bIsArenaObserveData = bIsArenaObserveData;
end

function ItemDataManager:GetItemNum(itemID)
    local itemData = self:GetItemData(itemID)
    if not itemData then 
        return 0
    end
    return itemData.uiItemNum or 0
end

function ItemDataManager:GetItemTypeID(itemID)
    local itemData = self:GetItemData(itemID)
    if itemData then 
        return itemData.uiTypeID
    end
    return 0
end

function ItemDataManager:GetItemEnhanceGrade(itemID)
    local itemData = self:GetItemData(itemID)
    if itemData then 
        return itemData.uiEnhanceGrade
    end
    return 0
end

function ItemDataManager:GetItemTypeData(itemID)
    local typeID = self:GetItemTypeID(itemID)
    return self:GetItemTypeDataByTypeID(typeID)
end

function ItemDataManager:GetItemTypeDataByTypeID(typeID)
    if (not typeID) or (typeID == 0) then
        return
    end
    local data = TableDataManager:GetInstance():GetTableData("Item",typeID)
    if not data and DEBUG_MODE then
        dprint("物品ID [" .. typeID .. "] 对应的物品数据不存在, 但是企图使用!\n" .. debug.traceback())
    end
    return data
end

function ItemDataManager:DeleteItemData(itemID)
    local itemPool = globalDataPool:getData("ItemPool") or {}
    if itemPool[itemID] then 
        itemPool[itemID] = nil
        globalDataPool:setData("ItemPool", itemPool, true)
        self:SetItemLockState(itemID, false)
        self:DispatchUpdateEvent()
    else
        -- 如果剧本内物品查找不到, 查找仓库物品
        StorageDataManager:GetInstance():DeleteItemData(itemID)
    end
    if self.alreadyNewItems then
        self.alreadyNewItems[itemID] = nil
    end
end

-- 调用这个接口设置一个 [物品BaseID列表]
-- 在下一次走到物品动态数据更新 UpdateItemDataByArray 时
-- 在此列表内的物品, 都会检查是否需要自动加锁
function ItemDataManager:SetAutoLockCheckBaseIDList(aiBaseIDList)
    self.kAutoLockCheckMap = nil
    if not aiBaseIDList then
        return
    end
    local kCheckMap = {}
    for index, uiID in ipairs(aiBaseIDList) do
        kCheckMap[uiID] = true
    end
    self.kAutoLockCheckMap = kCheckMap
end

-- 道具是否需要强制锁定
function ItemDataManager:IsNewItemDataNeedAutoLock(kNewData)
    if not (kNewData and kNewData.uiTypeID) then
        return false
    end

    if (not self.kAutoLockCheckMap)
    or (self.kAutoLockCheckMap[kNewData.uiTypeID] ~= true) then
        return false
    end

    local bAssetProtect = ((kNewData.uiEnhanceGrade or 0) >= SSD_ITEM_PROTECT_ENHANCE_GRADE)
                        or ((kNewData.uiSpendTongLingYu or 0) > 0) 
                        or ((kNewData.uiPerfectPower or 0) > 0) 
                        or ((kNewData.uiSpendIron or 0) > 0)
    return bAssetProtect
end

function ItemDataManager:UpdateItemDataByArray(itemDataArray, arraySize)
    local itemPool = globalDataPool:getData("ItemPool") or {}
    if not (itemDataArray and arraySize) then 
        return
    end
    self.newItems = self.newItems or {}
    self.alreadyNewItems = self.alreadyNewItems or {}
    for i = 1, arraySize do 
        local itemData = itemDataArray[i - 1]
        local itemID = itemData.uiID
        if self:IsNewItemDataNeedAutoLock(itemData) then 
            self:SetItemLockState(itemID, true)
        end
        itemPool[itemID] = itemData
        -- 存下当前新入的item
        if not self.alreadyNewItems[itemID] then
            self.newItems[itemID] = true
            self.alreadyNewItems[itemID] = true
        end

        self:CheckMainRoleNewItem(itemData)
    end
    self:SetAutoLockCheckBaseIDList(nil)
    globalDataPool:setData("ItemPool", itemPool, true)
    self:DispatchUpdateEvent()
end

-- 设置新物品标记
function ItemDataManager:SetNewItemFlag(itemID)
    if itemID then
        self.newItems = self.newItems or {}
        self.newItems[itemID] = true
    end
end

-- 当前物品是否为新物品
function ItemDataManager:IsItemNew(itemID)
    self.newItems = self.newItems or {}
    return (self.newItems[itemID] == true)
end

-- 清空新物品标记
function ItemDataManager:ClearNewItemFlag(itemID)
    if itemID then
        self.newItems = self.newItems or {}
        self.newItems[itemID] = nil
    else
        self.newItems = {}
    end
end

function ItemDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_ITEM_DATA")
end

-- 传入物品的静态ID，判断他是不是装备
function ItemDataManager:IsEquip(itemTypeID)
    local itemTypeData = self:GetItemTypeDataByTypeID(itemTypeID)
    if itemTypeData == nil then 
        return 
    end
    local TB_ItemType =TableDataManager:GetInstance():GetTable("ItemType")
    local EquipMent = TB_ItemType[ItemTypeDetail.ItemType_Equipment]
    
    if EquipMent.ChildItemType == nil then
        return false
    end

    for key, value in pairs(EquipMent.ChildItemType) do
        if itemTypeData.ItemType == value then
            return true
        end
    end

    return false
end

-- 传入物品类型 A, B
-- 判断 A 是否和 B类型相同 或 A 是否归属于 B 的子类型
function ItemDataManager:IsTypeEqual(eTypeA, eTypeB)
    if (not eTypeA) or (not eTypeB) then 
        return false 
    end

    -- 判断完全相等
    if eTypeA == eTypeB then
        return true
    end

    -- 找不到待比较的类型或子类型, 判为不等
    local kDBItemType = TableDataManager:GetInstance():GetTable("ItemType")
    local kBaseItemType = kDBItemType[eTypeB]
    if (not kBaseItemType) or (not kBaseItemType.ChildItemType) then
        return false
    end

    -- 查找子类到大类的检查表, 若找不到对应的缓存数据, 
    -- 遍历且仅遍历一次大类eTypeB下的子类型, 在缓存中生成子类型到大类的映射
    if not self.kItemChildTypeCheck then
        self.kItemChildTypeCheck = {}
    end
    if not self.kItemChildTypeCheck[eTypeB] then
        self.kItemChildTypeCheck[eTypeB] = {}
        for index, eChildType in pairs(kBaseItemType.ChildItemType) do
            self.kItemChildTypeCheck[eTypeB][eChildType] = true
        end
    end

    -- 使用缓存数据, 判断eTypeA作为子类能否映射到eTypeB大类, 映射结果作为判等结果
    return (self.kItemChildTypeCheck[eTypeB][eTypeA] == true)
end

-- 获取装备数值提升
function ItemDataManager:GetItemElevateValue(iDiffValue)
    iDiffValue = iDiffValue or RoleDataManager:GetInstance():GetDifficultyValue() or 1
    local iElevateValue = iDiffValue 
    --# TODO 钱程 千层塔模式现在还不能获取
    -- if G.call('千层塔-获取模式') > 0 then
    --     iElevateValue = 1
    -- end
    local diffdata = StoryDataManager:GetInstance():GetStoryDifficultData(GetCurScriptID(), iDiffValue)
    if diffdata then
        iElevateValue = diffdata.EquipLvMax
    end
    return iElevateValue
end

-- 获取道具属性极限(物品动态id, 物品静态id[可缺省], 属性枚举值, 期望等级[可缺省], 是否是固定属性[默认为可重铸属性], 是否获取最小值[默认获取最大值], 是否自动转化万分比(默认是))
function ItemDataManager:GetItemAttrLimitValue(itemID, itemTypeID, attrTypeID, int_expect_level, bIsStableAttr, bGetMinValue, bAutoPerMyriad)
    local instItem = nil
    local staticItem = nil
    -- 如果传入了动态物品id, 静态数据以动态数据中物品的静态数据为准
    if itemID then
        instItem = self:GetItemData(itemID)
        staticItem = self:GetItemTypeData(itemID)
    elseif itemTypeID then
        staticItem = self:GetItemTypeDataByTypeID(itemTypeID)
    end
    -- 至少要有静态数据
    if not staticItem then return end
    -- 如果没有传入期望等级, 默认获取物品的当前强化等级
    if not int_expect_level then
        int_expect_level = instItem and instItem.uiEnhanceGrade or 0
    end
    local iRank = staticItem.Rank
    local matDataManager = MartialDataManager:GetInstance()
    local rangeData = (bIsStableAttr == true) and (TableDataManager:GetInstance():GetTable("ItemBaseStatic")) or (TableDataManager:GetInstance():GetTable("ItemBaseRecast"))
    for index, data in ipairs(rangeData) do
        if (data.AttrType ==  attrTypeID) or (data.KFAttrType == attrTypeID) then
            local randomBase = data.RandomBase
            -- 数据第一位是0(空数据), 因此从第二位开始索引
            local section = randomBase[iRank + 1]
            if not section then return 0 end
            local iBase = 0
            local iExtra = 0
            if bGetMinValue == true then
                iBase = section.MinBaseValue or 0
                iExtra = section.MinExtraValue or 0
            else
                iBase = section.MaxBaseValue or 0
                iExtra = section.MaxExtraValue or 0
            end
            -- 最终值 = 基础值 + 物品强化等级 * 叠加值
            --# TODO 钱程 这里暂时只乘以强化等级, 原逻辑是乘以 装备数值提升值 (接口: GetItemElevateValue)
            -- 由于牵扯到的数值重构内暂时没有, 先不做, 如果后面要换成装备数值提升值, 需要与服务器协调, 保证显示与数据相同
            local finalValue = iBase  + iExtra * int_expect_level
            if bAutoPerMyriad ~= false then
                local bIsPerMyriad, bShowAsPercent = matDataManager:AttrValueIsPermyriad(attrTypeID)
                if bIsPerMyriad then
                    return finalValue / 10000
                end
            end
            return finalValue
        end
    end
    return 0
end

-- 获取道具可重铸属性最大属性值
function ItemDataManager:GetItemRcastableAttrMaxValue(itemID, itemTypeID, attrTypeID, int_expect_level, bAutoPerMyriad)
    return self:GetItemAttrLimitValue(itemID, itemTypeID, attrTypeID, int_expect_level, false, false, bAutoPerMyriad)
end

-- 获取道具可重铸属性最小属性值
function ItemDataManager:GetItemRcastableAttrMinValue(itemID, itemTypeID, attrTypeID, int_expect_level, bAutoPerMyriad)
    return self:GetItemAttrLimitValue(itemID, itemTypeID, attrTypeID, int_expect_level, false, true, bAutoPerMyriad)
end

-- 获取道具固定属性最大属性值
function ItemDataManager:GetItemStableAttrMaxValue(itemID, itemTypeID, attrTypeID, int_expect_level, bAutoPerMyriad)
    return self:GetItemAttrLimitValue(itemID, itemTypeID, attrTypeID, int_expect_level, true, false, bAutoPerMyriad)
end

-- 获取道具固定属性最小属性值
function ItemDataManager:GetItemStableAttrMinValue(itemID, itemTypeID, attrTypeID, int_expect_level, bAutoPerMyriad)
    return self:GetItemAttrLimitValue(itemID, itemTypeID, attrTypeID, int_expect_level, true, true, bAutoPerMyriad)
end

-- 判断一条属性是白字/绿字还是蓝字
function ItemDataManager:JudgeAttrRankType(attrData, sType)
    -- RecastType_FixTVWhite = 0  -- 白字属性,类型和属性值固定一旦生成不再改变,重铸条目达到完美时可以提升一点属性值
    -- RecastType_RandTVGreen = 1 -- 绿字属性,类型和属性值可以重新生成
    -- RecastType_RandVGreen = 2  -- 绿字属性,属性值可以重新生成(必出属性,重铸时只能属性值变化)
    -- RecastType_RandTVBlue = 3  -- 蓝字属性,类型和属性值可以重新生成(重铸条目达到完美时小概率出现,最多只有两条)
    if (not attrData) then
        return false
    end

    -- 特殊判断，藏宝图类型的属性不计算其属性
    if (attrData.uiType == ItemType_TreasureMap) then
        return false
    end
    local rank = attrData.uiRecastType
    local type = nil
    if rank == 0 then
        type = "white"
    elseif rank <= 2 then
        type = "green"
    elseif rank == 3 then
        type = "blue"
    end
    return (type == sType)
end

-- 判断一条属性是否为完美 物品动态id 属性动态数据
function ItemDataManager:IsItemAttrPerfect(itemID, attrData)
    if not (itemID and attrData) then return end
    local bIsRecastableAttr = self:JudgeAttrRankType(attrData, "green")
    local attrMaxRecastableValue = 0
    if bIsRecastableAttr then
        attrMaxRecastableValue = self:GetItemRcastableAttrMaxValue(itemID, nil, attrData.uiType, nil, false) or 0
    else
        attrMaxRecastableValue = self:GetItemStableAttrMaxValue(itemID, nil, attrData.uiType, nil, false) or 0
    end
    local iBaseValue = attrData.iBaseValue or 0
    return (iBaseValue >= attrMaxRecastableValue)
end

-- 获取一个物品完美属性条数
function ItemDataManager:GetItemPerfectRecastAttrCount(itemID)
    if not itemID then return 0 end
    local itemInstData = self:GetItemData(itemID)
    if not itemInstData then return 0 end
    local auiAttrData = itemInstData.auiAttrData
    if (not auiAttrData) or (#auiAttrData == 0) then
        return 0
    end
    local count = 0
    for index, data in pairs(auiAttrData) do
        if self:JudgeAttrRankType(data, "green") and self:IsItemAttrPerfect(itemID, data) then
            count = count + 1
        end
    end
    return count
end

--判断一个装备是否为完美(所有可重铸属性都完美)
function ItemDataManager:IsItemPerfect(itemID)
    if not itemID then return false end
    local itemInstData = self:GetItemData(itemID)
    local itemStaticData = self:GetItemTypeData(itemID)
    if not (itemInstData and itemStaticData) then return end
    local auiAttrData = itemInstData.auiAttrData
    if (not auiAttrData) or (#auiAttrData == 0) then
        return false
    end
    -- 先筛选出所有可重铸属性
    local recastableAttr = {}
    for index, data in pairs(auiAttrData) do
        if self:JudgeAttrRankType(data, "green") then
            recastableAttr[#recastableAttr + 1] = data
        end
    end
    -- 计算裂痕的数量
    local countMax = self:CanItemRank2MaxAttrCount(itemStaticData.Rank)
    local crackNum = countMax - #recastableAttr
    -- 如果存在裂痕, 肯定就不完美
    if crackNum > 0 then
        return false
    end
    -- 否则, 遍历所有可重铸属性, 判断是否全完美
    local bIsItemPerfect = true
    for index, data in pairs(recastableAttr) do
        if self:IsItemAttrPerfect(itemID, data) ~= true then
            bIsItemPerfect = false
            break
        end
    end
    return bIsItemPerfect
end

function ItemDataManager:CanItemRank2MaxAttrCount(iRank)
    iRank = iRank or 1
    local imax = 0
    local TB_ItemCrackBase = TableDataManager:GetInstance():GetTable("ItemCrackBase")
    if TB_ItemCrackBase then 
        for i,line in pairs(TB_ItemCrackBase) do 
            if iRank == line.Rank then 
                imax = line.EquipAttrCountUp or 0
                break
            end 
        end 
    end 
    return imax
end

-- 判断一个道具能否被熔炼(是否存在完美的可重铸属性)
function ItemDataManager:CanItemBeSmelted(itemID)
    if not itemID then 
        return false 
    end
    local itemInst = self:GetItemData(itemID)
    if not itemInst then
        return false
    end
    
    -- if QuerySystemIsOpen(SGLST_SMELT_SPECIAL) then 
    --     if itemInst.uiPerfectPower and itemInst.uiPerfectPower > 0 then return true end
    --     if itemInst.uiSpendIron and itemInst.uiSpendIron > 0 then return true end
    --     -- 熔炼通灵玉打九折且向下取整, 所以通灵玉必须要大于1才能被熔炼
    --     if itemInst.uiSpendTongLingYu and itemInst.uiSpendTongLingYu > 1 then return true end
    -- end
    local iRank =  self:GetItemRankByItemInstID(itemID)
    local ForgeSmeltData = TableDataManager:GetInstance():GetTableData("ForgeSmelt", iRank)
    if ForgeSmeltData then
        return ForgeSmeltData.JingTieNum > 0
    else
        return false
    end
end

-- 判断一个道具能否被重铸
function ItemDataManager:CanItemBeRecasted(itemID, itemTypeID)
    local itemTypeData = nil
    if itemID then
        itemTypeData = self:GetItemTypeData(itemID)
    elseif itemTypeID then
        itemTypeData = self:GetItemTypeDataByTypeID(itemTypeID)
    end
    if not itemTypeData then return false end
    local itemType = itemTypeData.ItemType
    local TB_ItemType = TableDataManager:GetInstance():GetTable("ItemType")
    local data = TB_ItemType[itemType]
    if (data ~= nil) then
        return (data.CanRecast == TBoolean.BOOL_YES)
    end
end

-- 物品静态表通用条件是否有效
function ItemDataManager:IsItemConditionAvaliable(itemBaseID)
    local itemBaseData = self:GetItemTypeDataByTypeID(itemBaseID)
    if not itemBaseData then 
        return false 
    end
    if itemBaseData.CommonUseCondition and #itemBaseData.CommonUseCondition > 0 then 
        return true
    end
    return false
end

-- 检查物品 等级 条件
function ItemDataManager:CheckLevelCondition(itemBaseID, itemID, roleID)
    local checkResult = true
    local condLevel = self:GetItemLevelCondByID(itemBaseID, itemID)
    local condDesc = ''
    if condLevel and (condLevel > 0) then
        local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
        if roleData then
            local roleLevel = roleData.uiLevel or 0
            checkResult = roleLevel >= condLevel
        end
        condDesc = "等级达到" .. tostring(condLevel) .. '\n'
    end
    return checkResult, condDesc
end

-- 检查物品 门派 条件
function ItemDataManager:CheckClanCondition(itemBaseID, roleID)
    local checkResult = true
    local itemBaseData = self:GetItemTypeDataByTypeID(itemBaseID)
    if not itemBaseData then 
        return false, '物品数据丢失'
    end
    if not itemBaseData.CommonUseCondition then
        return true, ''
    end
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    local condDesc = ''
    local isMainRole = RoleDataManager:GetInstance():GetMainRoleID() == roleID
    for _, condition in ipairs(itemBaseData.CommonUseCondition) do 
        if condition.CondType == ItemCommonUseCondType.ICUCT_CLAN then 
            local condClanBaseID = condition.CondValue or 0
            if roleData then 
                local roleClan = roleData.uiClanID
                checkResult = checkResult and (isMainRole or condClanBaseID == 0 or roleClan == condClanBaseID)
            end
            local clanBaseData = TableDataManager:GetInstance():GetTableData('Clan', condClanBaseID)
            condDesc = condDesc .. '加入' .. GetLanguageByID(clanBaseData.NameID) .. '\n'
        end
    end
    return checkResult, condDesc
end

-- 检查物品 角色 条件
function ItemDataManager:CheckRoleCondition(itemBaseID, roleID)
    local itemBaseData = self:GetItemTypeDataByTypeID(itemBaseID)
    if not itemBaseData then 
        return false, '物品数据丢失'
    end
    if not itemBaseData.CommonUseCondition then
        return true, ''
    end
    local checkResult = true
    local roleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(roleID) or 0
    local isMainRole = RoleDataManager:GetInstance():GetMainRoleID() == roleID
    local condDesc = ''
    for _, condition in ipairs(itemBaseData.CommonUseCondition) do 
        if condition.CondType == ItemCommonUseCondType.ICUCT_ROLE then 
            local condRoleBaseID = condition.CondValue or 0 
            if condRoleBaseID ~= 0 then 
                local roleName = RoleDataManager:GetInstance():GetRoleNameByTypeID(condRoleBaseID)
                checkResult = checkResult and (isMainRole or roleBaseID == 0 or condRoleBaseID == roleBaseID)
                condDesc = condDesc .. '专属角色:' .. roleName .. '\n'
            end
        end
    end
    return checkResult, condDesc
end

-- 检查物品 属性 条件
function ItemDataManager:CheckAttrCondition(itemBaseID, roleID)
    local itemBaseData = self:GetItemTypeDataByTypeID(itemBaseID)
    if not itemBaseData then 
        return false, '物品数据丢失'
    end
    if not itemBaseData.CommonUseCondition then
        return true, ''
    end
    local checkResult = true
    local condDesc = ''
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    for _, condition in ipairs(itemBaseData.CommonUseCondition) do 
        if l_itemCommonCondTypeToAttrType[condition.CondType] then 
            local condAttrType = l_itemCommonCondTypeToAttrType[condition.CondType]
            local condAttrValue = condition.CondValue or 0
            if roleData then 
                local roleAttrValue = roleData.aiAttrs[condAttrType] or 0
                checkResult = checkResult and (roleAttrValue >= condAttrValue)
            end
            local attrName = GetLanguageByID(AttrType_Lang[condAttrType]) or ''
            condDesc = condDesc .. attrName .. '属性达到' .. condAttrValue .. '\n'
        end
    end
    return checkResult, condDesc
end

-- 检查物品静态表通用条件
function ItemDataManager:CheckItemCondition(itemBaseID, itemID, roleID)
    local condDesc = ''
    local checkResult = true
    roleID = roleID or RoleDataManager:GetInstance():GetCurSelectRole()
    -- 等级
    local levelCondResult, levelCondDesc = self:CheckLevelCondition(itemBaseID, itemID, roleID)
    checkResult = checkResult and levelCondResult
    condDesc = condDesc .. levelCondDesc
    -- 门派
    local clanCondResult, clanCondDesc = self:CheckClanCondition(itemBaseID, roleID)
    checkResult = checkResult and clanCondResult
    condDesc = condDesc .. clanCondDesc
    -- 角色
    local roleCondResult, roleCondDesc = self:CheckRoleCondition(itemBaseID, roleID)
    checkResult = checkResult and roleCondResult
    condDesc = condDesc .. roleCondDesc
    -- 属性
    local attrCondResult, attrCondDesc = self:CheckAttrCondition(itemBaseID, roleID)
    checkResult = checkResult and attrCondResult
    condDesc = condDesc .. attrCondDesc
    return checkResult, condDesc
end

-- 获取物品使用条件 (物品动态id, 是否忽略使用条件, 是否需要返回条件描述的字符串, 是否在剧本内)
-- 返回值: 物品能否使用(boolean) 物品条件描述(string)
function ItemDataManager:ItemUseCondition(itemID, itemTypeID, bIgnoreCond, bGetCondDesc, bInGame)
    -- 规则: 先读取物品的 等级要求 门派要求 和 属性要求, 看是否满足条件, 若都为空且为秘籍, 则查询 TB_MartialBookCondition
    local itemBaseData = self:GetItemTypeDataByTypeID(itemTypeID)
    if not itemBaseData then 
        return 
    end
    --如果忽视条件, 则该物品能够直接使用
    if bIgnoreCond then 
        return true, ""
    end
    -- 默认值
    local canUse = true
    local condDesc = ""
    -- 获取物品类型
    local itemType = itemBaseData.ItemType
    -- 获取当前角色数据
    local roleData = nil
    local roleID = 0
    local roleDataManager = RoleDataManager:GetInstance()
    roleID = roleDataManager:GetCurSelectRole()
    roleData = roleDataManager:GetRoleData(roleID)
    if self:IsItemConditionAvaliable(itemTypeID) then
        return self:CheckItemCondition(itemTypeID, itemID)
    elseif itemType == ItemTypeDetail.ItemType_SecretBook then
        -- 获取武学数据
        local martialDataManager = MartialDataManager:GetInstance()
        local martialStaticData = martialDataManager:GetMartialTypeDataByItemTypeID(itemBaseData.BaseID)
        if not martialStaticData then
            return canUse, condDesc
        end
        local martialBaseID = martialStaticData.BaseID
        local clanBaseID = nil
        if bInGame and roleData then	--主界面仓库拿不到roledata
            clanBaseID = roleData.uiClanID or 0 
         end
        local condTypeList, condValueList = martialDataManager:GetMartialLearnCondition(martialBaseID, clanBaseID)
        if #condTypeList == 0 or #condTypeList ~= #condValueList
         then 
            return canUse, condDesc
        end
        canUse = true
        for index, condType in ipairs(condTypeList) do 
            canUse = canUse and martialDataManager:CheckMartialLearnConditionByType(clanBaseID, martialBaseID, condType, condValueList[index] or 0, roleID)
        end
        -- 如果不需要描述字符串, 那么直接返回
        if not bGetCondDesc then
            return canUse, condDesc
        end
        -- 组装条件描述
        for index, condType in ipairs(condTypeList) do 
            local condValue = condValueList[index] or 0
            local prefix = '<color=#FFFFFF>'
            if not martialDataManager:CheckMartialLearnConditionByType(clanBaseID, martialBaseID, condType, condValueList[index] or 0, roleID) then 
                prefix = '<color=#C53926>'
            end
            if condDesc ~= '' then
                condDesc = condDesc .. '\n'
            end
            if condValue >= 6000 then
                condDesc = condDesc .. "<color=#C1AE0F>调整中，暂不开放学习</color>"
            else
                condDesc = condDesc .. prefix .. martialDataManager:GetMartialLearnConditionTypeText(condType) .. "达到" .. condValue .. '</color>'
            end
        end
        return canUse, condDesc
    elseif itemType == ItemTypeDetail.ItemType_HeavenBook then
        local staticGiftData = TableDataManager:GetInstance():GetTableData("Gift", itemBaseData.GiftID)
        if not staticGiftData then 
            return canUse, condDesc
        end
        -- 分析使用条件
        local cost = staticGiftData.Cost
        if bInGame and roleData and roleData.aiAttrs then
            local remainGiftPoint = 0
            if roleData.aiAttrs[AttrType.ATTR_WUXING] == nil then
                remainGiftPoint = 0
            else
                roleData.uiGiftUsedNum = roleData.uiGiftUsedNum or 0
                remainGiftPoint = roleData.aiAttrs[AttrType.ATTR_WUXING] * 2 - roleData.uiGiftUsedNum;
            end
            -- 当前天赋上限
            local maxNum = RoleDataManager:GetInstance():GetGiftNumMax(roleData.uiID)
            local RoleAdvGift = GiftDataManager:GetInstance():GetDynamicGift(roleData.uiID)
            local curNum = getTableSize(RoleAdvGift)
            if curNum >= maxNum then
                canUse = false
                condDesc = "天赋数量已经达到上限"
                return canUse, condDesc
            end
            canUse = remainGiftPoint >= cost
        end
        -- 如果不需要描述字符串, 那么直接返回
        if not bGetCondDesc then
            return canUse, condDesc
        end
        -- 组装条件描述
        if cost ~= 0 then
            condDesc = '剩余天赋点达到' .. tostring(cost)
        end
        return canUse, condDesc
    end
    return canUse, condDesc
end

-- 物品能否批量使用
function ItemDataManager:CanItemUsedInBatches(itemID,bInStorage)
    local itemTypeData = self:GetItemTypeData(itemID)
    if not itemTypeData then
        return false
    end
    if bInStorage then 
        if itemTypeData.ItemType == ItemTypeDetail.ItemType_Formula and self:GetItemUnlockType(itemTypeData)  then
            return false
        end
    end 
    -- 如果物品是自选礼包,那么不允许自动使用
    if (itemTypeData.EffectSubType == EffectSubType.EST_HouseChooseGift) then
        return false
    end
    -- 判断是否为消耗品 或 残章
    local isBatchable = false
    isBatchable = self:IsTypeEqual(itemTypeData.ItemType,ItemTypeDetail.ItemType_Consume) 
    or self:IsTypeEqual(itemTypeData.ItemType,ItemTypeDetail.ItemType_IncompleteBook)

    -- 如果拥有 不可批量使用 特性, 不可批量使用
    local feature = itemTypeData.Feature or {}
    for i, f in ipairs(feature) do
        if f == ItemFeature.IF_DontBatchUse then
            return false
        end
    end
    -- 否则, 数量大于1可批量, 小于1不可批量
    local num = self:GetItemNum(itemID) or 0
    return num > 1
end

-- 获取物品的完整名称
function ItemDataManager:GetItemName(itemID, typeID, noRank,instItemData)
    if (not instItemData) and itemID then
        instItemData = self:GetItemData(itemID)
    end
    local typeItemData = self:GetItemTypeDataByTypeID(typeID)
    -- 如果传入了动态物品数据, 则使用的静态数据以动态数据的静态id为准
    if instItemData and typeID == nil then
        typeItemData = self:GetItemTypeData(itemID)
        typeID = typeItemData.BaseID
    end
    if not typeItemData then
        return ""
    end
    -- 完美前缀
    local sPrefix = ''
    if itemID then
        local isPerfect = self:IsItemPerfect(itemID)
        if isPerfect then
            sPrefix = '完美·' .. sPrefix
        end
    end
    -- 强化等级
    local sItemLevel = ""
    if instItemData then
        local level = instItemData.uiEnhanceGrade or 0
        if level > 0 then
            sItemLevel = string.format("+%d", level)
        end
    end
    -- 物品名称
    local sItemName = nil
    local matDataManager = MartialDataManager:GetInstance()
    local itemType = typeItemData.ItemType
    -- 首先, 如果是传家宝, 那么直接显示物品名称(有的秘籍是传家宝)
    local bIsTreasure = false
    if (typeItemData.PersonalTreasure ~= 0 )
    or (typeItemData.ClanTreasure ~= 0)
    or (typeItemData.NoneTreasure == TBoolean.BOOL_YES) then
        bIsTreasure = true
    end
    if bIsTreasure then
        sItemName = typeItemData.ItemName or ''
    -- 其次, 如果物品为 残章/秘籍/天书, 则通过 武学/天赋 名称拼接标题
    elseif itemType then
        if (itemType == ItemTypeDetail.ItemType_SecretBook)
        or (itemType == ItemTypeDetail.ItemType_IncompleteBook) then
            local martialTypeData = matDataManager:GetMartialTypeDataByItemTypeID(typeID)
            if martialTypeData then
                local martialName = GetLanguageByID(martialTypeData.NameID)
                local postfix = (itemType == ItemTypeDetail.ItemType_SecretBook) and "秘籍" or "残章"
                sItemName = string.format("《%s》%s", martialName, postfix)
            end
        elseif itemType == ItemTypeDetail.ItemType_HeavenBook then
            local giftTypeData = matDataManager:GetGiftTypeDataByItemTypeID(typeID)
            if giftTypeData then
                local giftName = GetLanguageByID(giftTypeData.NameID)
                sItemName = string.format("《%s》天书", giftName)
            end
        end
    end
    -- 最后, 使用物品名称
    if (not sItemName) or (sItemName == "") then
        sItemName = typeItemData.ItemName or ''
    end
    -- 组装
    if noRank then 
        return sPrefix .. sItemName .. sItemLevel
    end
    local string_ret = getRankBasedText(typeItemData.Rank, sPrefix .. sItemName .. sItemLevel)
    return string_ret
end

-- 道具是否可交易 (物品动态id)
-- 完美道具 和 完美后可交易 return 3
-- 不完美道具 和 完美后可交易 2
-- 无完美后可交易 1
function ItemDataManager:CanItemBeTraded(itemID)
    local itemBaseData = self:GetItemTypeData(itemID)
    if not itemBaseData then return 1 end
    local bTradeAfterPerfect = false
    if itemBaseData.Feature then
        for index, feature in ipairs(itemBaseData.Feature) do
            if feature == ItemFeature.IF_SellAfterPerfect then
                bTradeAfterPerfect = true
                break
            end
        end
    end
    if bTradeAfterPerfect then
        if self:IsItemPerfect(itemID) then
            return 3
        else
            return 2
        end
    else
        return 1
    end
    return  2
end


function ItemDataManager:CalculateEnhanceGradeAttr(itemID,itemTypeID,attrEnum,iAttrValue,iTargetLevel, bIsRecastableAttr, bIsPerfectAttr)
    local iAttrValueOnTargetLevel = iAttrValue
    if iTargetLevel and iTargetLevel > 0 and (attrEnum ~= AttrType.MP_WUXUEDENGJISHANGXIAN) then
        local iItemAttrMinValue = 0  -- 物品属性当前等级最小值
        local iItemAttrMaxValue = 0  -- 物品属性当前等级最大值
        if bIsRecastableAttr then
            iItemAttrMinValue = self:GetItemRcastableAttrMinValue(itemID, itemTypeID, attrEnum, nil, false)
            iItemAttrMaxValue = self:GetItemRcastableAttrMaxValue(itemID, itemTypeID, attrEnum, nil, false)
        else
            iItemAttrMinValue = self:GetItemStableAttrMinValue(itemID, itemTypeID, attrEnum, nil, false)
            iItemAttrMaxValue = self:GetItemStableAttrMaxValue(itemID, itemTypeID, attrEnum, nil, false)
        end

        local iItemAttrNextMinValue = 0  -- 物品属性下一等级最小值
        local iItemAttrNextMaxValue = 0  -- 物品属性下一等级最大值
        if bIsRecastableAttr then
            iItemAttrNextMinValue = self:GetItemRcastableAttrMinValue(itemID, itemTypeID, attrEnum, iTargetLevel, false) or iItemAttrMinValue
            iItemAttrNextMaxValue = self:GetItemRcastableAttrMaxValue(itemID, itemTypeID, attrEnum, iTargetLevel, false) or iItemAttrMaxValue
        else
            iItemAttrNextMinValue = self:GetItemStableAttrMinValue(itemID, itemTypeID, attrEnum, iTargetLevel, false) or iItemAttrMinValue
            iItemAttrNextMaxValue = self:GetItemStableAttrMaxValue(itemID, itemTypeID, attrEnum, iTargetLevel, false) or iItemAttrMaxValue
        end
        -- 如果当前属性比当前区间的最小值还小, 那么直接安全处理成下一级的中间值
        if iAttrValue < iItemAttrMinValue then
            iAttrValueOnTargetLevel = math.floor((iItemAttrNextMinValue + iItemAttrNextMaxValue) / 2)
        else
            -- 如果是完美属性, 则放大至下一级的最大值
            -- 否则: 等比放大: ((当前值 - 当前区间最小值) / 当前区间跨度) * 下级区间跨度 + 下级区间最小值
            if bIsPerfectAttr then
                iAttrValueOnTargetLevel = iItemAttrNextMaxValue
            else
                local deltaCur = iItemAttrMaxValue - iItemAttrMinValue
                if deltaCur > 0 then  -- 防止除0
                    local deltaNext = iItemAttrNextMaxValue - iItemAttrNextMinValue
                    iAttrValueOnTargetLevel = math.floor(((iAttrValue - iItemAttrMinValue) / deltaCur) * deltaNext + iItemAttrNextMinValue)
                end
            end
        end
    end
    return iAttrValueOnTargetLevel
end

-- 道具属性条目翻译
function ItemDataManager:GetItemAttrDesc(attrData, itemInstData, bIsItemPerfect, iTargetLevel, bIsRecastableAttr, sDescColor, sNumColor, sPerfectColor)
    local string_ret = ''
    if not (attrData and itemInstData) then return string_ret end

    local itemID = itemInstData.uiID
    local attrEnum = attrData.uiType
    local sAttrName = nil
    local sMartialName = nil
    local martialTypeData = nil
    local iAttrValue = 0

    -- 获取必要数据, 如果属性类型是 武学威力 和 武学等级 的话, 则iExtraValue表示武学id
    if (attrEnum == AttrType.MP_WEILI) or (attrEnum == AttrType.MP_WUXUEDENGJISHANGXIAN) then
        local martialTypeID = attrData.iExtraValue  --武学静态id
        martialTypeData = GetTableData("Martial",martialTypeID)
        sMartialName = GetLanguageByID(martialTypeData.NameID)
        sAttrName = GetEnumText("AttrType", attrEnum)
    else
        sAttrName = GetEnumText("AttrType", attrEnum)
    end

    if (sAttrName == nil) then
        sAttrName = ""
    end
    iAttrValue = attrData.iBaseValue
    local bIsPerfectAttr = self:IsItemAttrPerfect(itemID, attrData)  -- 属性是否完美
    local iAttrValueOnTargetLevel = self:CalculateEnhanceGradeAttr(itemID, nil, attrEnum,iAttrValue,iTargetLevel, bIsRecastableAttr, bIsPerfectAttr)

    if martialTypeData then
        if sMartialName and (sMartialName ~= "") then
            sAttrName = '《' .. sMartialName .. '》' .. sAttrName
        end
    end
    if attrEnum ~= AttrType.MP_WUXUEDENGJISHANGXIAN and sAttrName ~= nil then
        if bIsItemPerfect then
            sAttrName = '全完美·'.. sAttrName
        elseif bIsPerfectAttr then
            sAttrName = '完美·' .. sAttrName
        end
    end
    if  bIsPerfectAttr and  sPerfectColor then
        sAttrName = sPerfectColor .. sAttrName
    else
        if sDescColor then
            sAttrName = sDescColor .. sAttrName
        end
        if sNumColor then
            sAttrName = sAttrName .. sNumColor
        end
    end
    -- 属性名 +/- 值
    local bIsPerMyriad, bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(attrEnum)  -- 属性是否为万分比?
    if bIsPerMyriad then
        iAttrValueOnTargetLevel = iAttrValueOnTargetLevel / 10000
    end
    local siAttrValueOnTargetLevel = nil
    if bShowAsPercent then
        siAttrValueOnTargetLevel = string.format("%.1f%%", iAttrValueOnTargetLevel * 100)
    else
        local fs = bIsPerMyriad and "%.1f" or "%.0f"
        siAttrValueOnTargetLevel = string.format(fs, iAttrValueOnTargetLevel)
    end
    if iAttrValue >= 0 then
        sAttrName = sAttrName .. '+' .. siAttrValueOnTargetLevel
    else
        sAttrName = sAttrName .. '-' .. siAttrValueOnTargetLevel
    end
    if bIsItemPerfect or sDescColor or sNumColor then
        sAttrName = sAttrName .. "</color>"
    end
    -- 属性加成计算
    local addition = 0  -- 总加成
    -- 只有铸造属性会有所加成
    if bIsRecastableAttr == true then
        -- 如果这件物品是完美物品, 那么其所有铸造属性都会有10%的加成
        if bIsItemPerfect then
            addition = addition + iAttrValueOnTargetLevel * 0.1
        end
        -- 其它蓝字对铸造属性的百分比加成(值为百分比的整数部分)
        local auiAttrData = itemInstData.auiAttrData or {} -- 所有属性
        local factor = 0
        for index, data in pairs(auiAttrData) do
            -- 寻找对本条目加成的蓝字属性
            if self:JudgeAttrRankType(data, "blue") and (attrEnum == data.uiType) then
                factor = (data.iBaseValue or 0) / 100  -- 百分比转换为小数
                addition = addition + iAttrValueOnTargetLevel * factor
            end
        end
    end
    -- 如果存在属性加成, 根据属性是否为万分比属性, 处理成不同的描述
    if addition > 0 then
        if bShowAsPercent then
            sPerfectExtraValue =  string.format("%.1f%%", addition * 100)
        else
            sPerfectExtraValue = string.format("%.1f", addition)
        end
        sAttrName = sAttrName .. ' <color=#F8DF60>+' .. sPerfectExtraValue .. "</color>"
    end
    string_ret = sAttrName
    return string_ret
end

-- 更新角色与装备物品的对应关系
function ItemDataManager:UpdateTeammateEquipItemMap()
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
    if not mainRoleInfo then
        return
    end
    -- 包括自己在内的人数
    local teammatesCount = mainRoleInfo["TeammatesNums"] or 1
    -- 包括自己在内的所有队友, 索引从0开始
    local teammates = mainRoleInfo["Teammates"]
    if (teammatesCount == 0) or (not teammates) then
        return
    end
    local kEquipItemMap = {}
    local uiRoleID = nil
    local kRoleInstData = nil
    local kRoleMgr = RoleDataManager:GetInstance()
    for index = 0, teammatesCount - 1 do
        uiRoleID = teammates[index]
        kRoleInstData = kRoleMgr:GetRoleData(uiRoleID)
        if kRoleInstData and kRoleInstData.akEquipItem then
            for _, uiItemID in pairs(kRoleInstData.akEquipItem) do
                kEquipItemMap[uiItemID] = uiRoleID
            end
        end
    end
    self.kTeammateEquipItemMap = kEquipItemMap
    return kEquipItemMap
end

function ItemDataManager:SetReGenRoleEquipItemFlag()
    self.bNeedReGenRoleEquipItemMap = true
end

-- 判断一个物品当前是否被某个角色装备中
function ItemDataManager:IsItemEquipedByRole(itemID)
    if not itemID then 
        return false 
    end
    if GetGameState() == -1 then
        return false
    end
    if (not self.kTeammateEquipItemMap) or (self.bNeedReGenRoleEquipItemMap == true) then
        self.bNeedReGenRoleEquipItemMap = false
        self:UpdateTeammateEquipItemMap()
    end
    if not self.kTeammateEquipItemMap then
        return false
    end
    local uiTarRole = self.kTeammateEquipItemMap[itemID]
    local bEuiped = (uiTarRole ~= nil) and (uiTarRole > 0)
    return bEuiped, uiTarRole
end

-- 获取背包物品(角色id, 包含装备道具, 包含队友装备道具, 过滤函数)
function ItemDataManager:GetPackageItems(roleID, includeEquipedRoleID, bIncludeTeammateEquiped, funcFliter, needSort)
    local roleDataManager = RoleDataManager:GetInstance()
    -- 参数矫正
    if not roleID then
        roleID = roleDataManager:GetMainRoleID()
    end
    bIncludeTeammateEquiped = (bIncludeTeammateEquiped == true)
    -- 获取数据
    local retItems = {}
    local itemCount = 0
    local roleData = roleDataManager:GetRoleData(roleID)
    if roleData == nil then 
        return {}
    end
    -- 筛选物品
    local auiItemIDList = roleData.auiRoleItem or {}
    for index, id in pairs(auiItemIDList) do
        if (not funcFliter) or funcFliter(id) then
            itemCount = itemCount + 1
            retItems[itemCount] = id
        end
    end
    -- 筛选出 装备中 物品
    local akEquipItem = nil
    -- 包括队友装备也包括了主角的装备
    if bIncludeTeammateEquiped then
        local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
        local teammatesCount = mainRoleInfo["TeammatesNums"] or 1
        local teammates = mainRoleInfo["Teammates"]
        for index = 0, teammatesCount - 1 do
            roleID = teammates[index]
            roleData = roleDataManager:GetRoleData(roleID)
            akEquipItem = roleData.akEquipItem or {}
            for _, id in pairs(akEquipItem) do
                if (not funcFliter) or funcFliter(id) then
                    itemCount = itemCount + 1
                    retItems[itemCount] = id
                end
            end
        end
    -- 包括自身装备但不包括主角装备时, 直接拿上面的roleData就好
    elseif includeEquipedRoleID ~= 0 then
        local targetRoleData = roleDataManager:GetRoleData(includeEquipedRoleID)
        akEquipItem = {}
        if targetRoleData then 
            akEquipItem = targetRoleData.akEquipItem or {}
        end
        for index, id in pairs(akEquipItem) do
            if (not funcFliter) or funcFliter(id) then
                itemCount = itemCount + 1
                retItems[itemCount] = id
            end
        end
    end
    -- 排序
    if needSort ~= false then 
        table.sort(retItems, function(a, b)
            local typeDataA = self:GetItemTypeData(a)
            local typeDataB = self:GetItemTypeData(b)
            local iRankA = typeDataA and (typeDataA.Rank or 0) or -2
            local iRankB = typeDataB and (typeDataB.Rank or 0) or -1
            if iRankA == iRankB then
                return typeDataA.BaseID > typeDataB.BaseID
            else
                return iRankA > iRankB
            end
        end)
    end
    return retItems
end

-- 获取道具产出完美粉
function ItemDataManager:GetITemSmeltPowder(itemID, bReturnMax, bReturnMin)
    local instItem = self:GetItemData(itemID)
    local typeData = self:GetItemTypeData(itemID)
    if not (instItem and typeData) then
        return 0
    end
    -- 建立查询表
    if not self.smeltPowderLookUp then
        self.smeltPowderLookUp = {}
        local TB_ForgeRecastPowder = TableDataManager:GetInstance():GetTable("ForgeRecastPowder")
        for count, rankData in ipairs(TB_ForgeRecastPowder) do
            -- 注意, 第一位是空数据 0, index - 1 才与品质对应
            for index, powderNum in ipairs(rankData.RankBase) do
                if index > 1 then
                    self.smeltPowderLookUp[index - 1] = self.smeltPowderLookUp[index - 1] or {}
                    self.smeltPowderLookUp[index - 1][count] = powderNum / 10
                end
            end
        end
    end
    -- 获取物品品质
    local rank = typeData.Rank or 1
    -- 获取物品完美可重铸属性条数
    local count = self:GetItemPerfectRecastAttrCount(itemID)
    -- 获取概率
    local p = 0
    if self.smeltPowderLookUp[rank] then
        p = self.smeltPowderLookUp[rank][count] or 0
    end
    if bReturnMax then
        return math.ceil(p)
    elseif bReturnMin then
        return math.floor(p)
    elseif p < 1 then
        return math.random(0, 10) < (p * 10) and 1 or 0
    else
        return p
    end
end

function ItemDataManager:GetItemTreasureMapDesc(attrs)
    if (attrs == nil) then
        return nil
    end
    for k,v in pairs(attrs) do
        local attr = v
        if (attr.uiType == AttrType.ATTR_TREASUREMAP_ID) then
            local tbData = TableDataManager:GetInstance():GetTableData("TreasureMaze",attr.iBaseValue)
            if (tbData ~= nil) then
                local cityID = tbData.Maze
                -- local mazeArea = tbData.MazeArea
                local name = CityDataManager:GetInstance():GetCityShowName(cityID)
                local content = string.format("在%s附近发现宝藏",name)
                return content
            end
        end
    end

    return nil
end

-- 更新临时背包数据
function ItemDataManager:UpdateTempBagItems(info)
    -- 更新标记: 0新增 1删除
    local flag = info.iFlag or 0
    local bIsAdd = flag == 0
    local len = info.iLength or 0
    local auiItemIDs = info.auiItemIDs or {}
    local itemID = nil
    local itemTypeData = nil
    local sItemName = nil
    local tempItemPool = globalDataPool:getData("TempItemPool") or {}
    local sysUICall = SystemUICall:GetInstance()
    for index = 0, len - 1 do
        itemID = auiItemIDs[index]
        if bIsAdd then
            tempItemPool[itemID] = true
            itemTypeData = self:GetItemTypeData(itemID)
            sItemName = itemTypeData.ItemName or ''
            sysUICall:Toast(string.format("获得%s，背包已满，进入临时背包", sItemName))
        else
            tempItemPool[itemID] = nil
        end
    end
    -- 生成数组
    local arr = {}
    for itemID, result in pairs(tempItemPool) do
        if result == true then
            arr[#arr + 1] = itemID
        end
    end
    tempItemPool['array'] = arr
    globalDataPool:setData("TempItemPool", tempItemPool, true)
end

-- 获取临时背包数据
function ItemDataManager:GetTempBackpackItems()
    local tempItemPool = globalDataPool:getData("TempItemPool") or {}
    return tempItemPool.array or {}
end

-- fix me 建表吧
function ItemDataManager:GetEquipPos(itemTypeID)
    local itemTypeData = self:GetItemTypeDataByTypeID(itemTypeID)
    if itemTypeData == nil then
        if DEBUG_MODE then
            SystemUICall:GetInstance():Toast("物品" .. tostring(itemTypeID) .. "未找到数据") 
        end
        return REI_NULL
    end

    local TB_ItemType = TableDataManager:GetInstance():GetTable("ItemType")
    for k, v in pairs(TB_ItemType[ItemTypeDetail.ItemType_Weapon].ChildItemType) do
        if itemTypeData.ItemType == v then
            return REI_WEAPON;                                              --武器
        end
    end

    if itemTypeData.ItemType == ItemTypeDetail.ItemType_Clothes then        --衣服
        return REI_CLOTH
    end

    if itemTypeData.ItemType == ItemTypeDetail.ItemType_Shoe then           --鞋子
        return REI_SHOE
    end

    if itemTypeData.ItemType == ItemTypeDetail.ItemType_Ornaments then      --饰品
        return REI_JEWELRY
    end

    if itemTypeData.ItemType == ItemTypeDetail.ItemType_Wing then           --翅膀
        return REI_WING
    end

    if itemTypeData.ItemType == ItemTypeDetail.ItemType_SecretBook then           --秘籍
        return REI_RAREBOOK
    end
    
    if itemTypeData.ItemType == ItemTypeDetail.ItemType_Artifact then
        return REI_THRONE
    end

    if itemTypeData.ItemType == ItemTypeDetail.ItemType_HiddenWeapon then -- 暗器
        return REI_ANQI
    end

    if itemTypeData.ItemType == ItemTypeDetail.ItemType_Leechcraft then
        return REI_MEDICAL
    end

    return REI_NULL
end

-- 分析装备强化后使用等级条件增幅数值
function ItemDataManager:GenItemStrengthenCondLevelUpData()
    if self.kItemStrengthenCondLevelUpValueMap
    and self.uiItemUseLevelWillRaiseLevel then
        return false
    end
    local TB_ItemStrengthenConfig = TableDataManager:GetInstance():GetTable("ItemStrengthenConfig")
    self.kItemStrengthenCondLevelUpValueMap = {}
    self.uiItemUseLevelWillRaiseLevel = nil
    for iLevel, configData in pairs(TB_ItemStrengthenConfig) do
        if (not self.uiItemUseLevelWillRaiseLevel) and (configData.LevelCondUpValue > 0) then
            self.uiItemUseLevelWillRaiseLevel = iLevel - 1
        end
        self.kItemStrengthenCondLevelUpValueMap[configData.StrengthenLevel] = configData.LevelCondUpValue
    end
    return true
end

-- 获取装备强化后使用等级条件增幅数值
function ItemDataManager:GetItemStrengthenCondLevelUpValue(strengthenLv)
    if not strengthenLv then
        return 0 
    end
    if not self.kItemStrengthenCondLevelUpValueMap then
        self:GenItemStrengthenCondLevelUpData()
    end
    return self.kItemStrengthenCondLevelUpValueMap[strengthenLv] or 0
end

-- 获取装备强化后使用等级条件将要提升的等级
function ItemDataManager:GetItemStrengthenCondLevelWillRaiseLevel()
    if not self.uiItemUseLevelWillRaiseLevel then
        self:GenItemStrengthenCondLevelUpData()
    end
    return self.uiItemUseLevelWillRaiseLevel or 0
end

-- 获取装备使用等级要求
function ItemDataManager:GetItemLevelCondByID(itemTypeID, itemID, strengthenLvDelta)
    local itemTypeData = nil
    -- 当且仅当只填了物品静态id的时候, 直接返回物品表内使用等级条件
    if (itemID == nil) and (itemTypeID ~= nil) then
        return self:GetItemLevelCondByBaseID(itemTypeID)
    end
    local itemData = self:GetItemData(itemID)
    if itemData == nil then
        return 0 
    end
    local itemStrengthenLv = (itemData.uiEnhanceGrade or 0) + (strengthenLvDelta or 0)
    local itemStrengthenCondLevelUpValue = self:GetItemStrengthenCondLevelUpValue(itemStrengthenLv)
    local itemTypeData = self:GetItemTypeData(itemID)
    local uiBaseLvCond = self:GetItemLevelCondByBaseID(itemTypeData.BaseID)
    return itemStrengthenCondLevelUpValue + uiBaseLvCond
end

-- 获取装备使用等级要求
function ItemDataManager:GetItemLevelCondByBaseID(itemBaseID)
    local itemBaseData = self:GetItemTypeDataByTypeID(itemBaseID)
    if (not itemBaseData) or (not itemBaseData.CommonUseCondition) then 
        return 0
    end
    for _, condition in ipairs(itemBaseData.CommonUseCondition) do 
        if condition.CondType == ItemCommonUseCondType.ICUCT_LEVEL then 
            return condition.CondValue
        end
    end
    return 0
end

-- 设置道具锁定状态
function ItemDataManager:SetItemLockState(itemID, isLock)
    local itemIdStr = tostring(itemID)
    local itemLockState = GetConfig('ItemLockState') or {}
    local oldLockState = (itemLockState[itemIdStr] == true)
    local newLockState = (isLock == true)
    if oldLockState == newLockState then
        return 
    end
    if newLockState == true then
        itemLockState[itemIdStr] = true
    else
        itemLockState[itemIdStr] = nil
    end
    SetConfig('ItemLockState', itemLockState)
    LuaEventDispatcher:dispatchEvent("UPDATE_ITEM_LOCK_STATE", itemID)
end

-- 获取道具锁定状态, 使用第二个bool值来表示是否是静态表表中填写的锁定
function ItemDataManager:GetItemLockState(itemID)
    local hasLockFeature = self:ItemHasLockFeature(itemID)
    if hasLockFeature then
        return true, true
    end
    local itemLockState = GetConfig('ItemLockState') or {}
    local itemIdStr = tostring(itemID)
    return (itemLockState[itemIdStr] == true), false
end

-- 道具是否强制锁定
function ItemDataManager:ItemHasLockFeature(itemID)
    local itemTypeData = self:GetItemTypeData(itemID)
    if not itemTypeData then 
        return 
    end
    local features = itemTypeData.Feature or {}
    for index, feature in ipairs(features) do
        if feature == ItemFeature.IF_Locking then
            return true
        end
    end
    return false
end

function ItemDataManager:genItemAttrByItemBattle(data,typename,valuename,recastType)
    if typename ~= 0 then 
        table.insert(data,{
            uiType = typename,
            iBaseValue = valuename,
            uiRecastType = recastType,
        })
    end
end

function ItemDataManager:genInstItemByItemBattle(itemBattleInfo, uiKey)
	if itemBattleInfo == nil then return nil end
    local instData = {}
    instData['auiAttrData'] = {}
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.WhiteType1,itemBattleInfo.WhiteValue1,RecastType_FixTVWhite)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.WhiteType2,itemBattleInfo.WhiteValue2,RecastType_FixTVWhite)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.GreenType1,itemBattleInfo.GreenValue1,RecastType_RandTVGreen)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.GreenType2,itemBattleInfo.GreenValue2,RecastType_RandTVGreen)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.GreenType3,itemBattleInfo.GreenValue3,RecastType_RandTVGreen)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.GreenType4,itemBattleInfo.GreenValue4,RecastType_RandTVGreen)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.GreenType5,itemBattleInfo.GreenValue5,RecastType_RandTVGreen)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.GreenType6,itemBattleInfo.GreenValue6,RecastType_RandTVGreen)
    self:genItemAttrByItemBattle(instData['auiAttrData'],itemBattleInfo.GreenType7,itemBattleInfo.GreenValue7,RecastType_RandTVGreen)
    instData.uiEnhanceGrade = itemBattleInfo.EnhanceGrade
    instData.uiCoinRemainRecastTimes = itemBattleInfo.CoinRemainRecastTimes
    -- 固定一个假的uid
    if uiKey and (uiKey > 0) then
        instData.uiID = -1 * uiKey
    end
    -- 缓存
    if not self.kFakeItemBattleDataPool then
        self.kFakeItemBattleDataPool = {}
    end
    if instData.uiID then
        self.kFakeItemBattleDataPool[instData.uiID] = instData
    end
    return instData
end

-- 道具是否拥有某个特性
function ItemDataManager:ItemHasFeature(itemID, eFeature)
    if not itemID then
        return false
    end
    local itemTypeData = self:GetItemTypeData(itemID)
    if not itemTypeData then 
        return false
    end
    local features = itemTypeData.Feature or {}
    for index, feature in ipairs(features) do
        if feature == eFeature then
            return true
        end
    end
    return false
end

function ItemDataManager:GetHorseCityMoveTimeFactor(itemID)
    local itemBaseID = self:GetItemTypeID(itemID)
    if itemBaseID == 0 then 
        return 0
    end
    if self.horseFactorMap == nil then 
        self.horseFactorMap = {}
        local horseDataMap = TableDataManager:GetInstance():GetTable('Horse')
        for _, horseData in pairs(horseDataMap) do 
            local horseBaseID = horseData.ItemBaseID
            local cityMoveTimeFactor = horseData.CityMoveTimeFactor
            if horseBaseID ~= nil and horseBaseID ~= 0 and cityMoveTimeFactor ~= nil and cityMoveTimeFactor ~= 0 then 
                self.horseFactorMap[horseBaseID] = cityMoveTimeFactor
            end
        end
    end
    return self.horseFactorMap[itemBaseID] or 0
end

-- 获取物品品质特效数据, 主要是为了资源只做一次加载
function ItemDataManager:GetItemFrameEffectData(key)
    if not (key and ITEM_FRAME_EFFECT and ITEM_FRAME_EFFECT[key]) then
        return
    end
    local kData = ITEM_FRAME_EFFECT[key]
    local kRet = {}
    if not self.kCacheRes then
        self.kCacheRes = {
            ['material'] = {},
            ['sprite'] = {},
            ['scale'] = {}
        }
    end
    -- 精灵
    if kData.sprite and (kData.sprite ~= "") then
        if not self.kCacheRes['sprite'][key] then
            self.kCacheRes['sprite'][key] = GetSprite(kData.sprite)
        end
        kRet.sprite = self.kCacheRes['sprite'][key]
    end
    -- 材质球
    if kData.material and (kData.material ~= "") then
        if not self.kCacheRes['material'][key] then
            self.kCacheRes['material'][key] = LoadPrefab(kData.material,typeof(CS.UnityEngine.Material))
        end
        kRet.material = self.kCacheRes['material'][key]
    end
    -- 本地缩放
    local iScale = kData.scale or 1
    local strScale = tostring(iScale)
    if not self.kCacheRes['scale'][strScale] then
        self.kCacheRes['scale'][strScale] = DRCSRef.Vec3(iScale, iScale, 1)
    end
    kRet.scale = self.kCacheRes['scale'][strScale]

    return kRet
end

-- 根据角色精通属性获取合适的武器
function ItemDataManager:GetFitnessWeapon(uiRoleID, auiWeapons)
    if auiWeapons == nil or #auiWeapons == 0 then 
        return 0
    end
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiRoleID)
    -- 精通值最高的精通类型
    local maxJingTongAttrType = AttrType.ATTR_JIANFAJINGTONG
    local maxAttrValue = 0
    for attrType, _ in pairs(JingTongAttrs) do 
        local attrValue = roleData:GetAttr(attrType) or 0
        if attrValue > maxAttrValue then 
            maxAttrValue = attrValue
            maxJingTongAttrType = attrType
        end
    end
    local weaponType = JingTongWeaponTypeDict[maxJingTongAttrType] or ItemTypeDetail.ItemType_Sword
    for _, itemID in ipairs(auiWeapons) do 
        local itemBaseData = self:GetItemTypeData(itemID)
        if itemBaseData.ItemType == weaponType then 
            return itemID
        end
    end
    return auiWeapons[1]
end

function ItemDataManager:IsEquipItem(uiItemID, uiItemTypeID)
    if uiItemID then
        uiItemTypeID = self:GetItemTypeID(uiItemID)
    end

    if not uiItemTypeID or uiItemTypeID == 0 then
        return false
    end

    local itemTypeData = self:GetItemTypeDataByTypeID(uiItemTypeID)
    if not itemTypeData then
        return false
    end

    if itemTypeData.Feature then
        for index, feature in ipairs(itemTypeData.Feature) do
            if feature == ItemFeature.IF_Equipped then
                return true
            end
        end
    end

    return false
end

-- 获取卸载装备的好感度需求与扣除好感度
function ItemDataManager:GetUnloadRoleEquipFavorInfo(uiItemBaseID, uiRoleTypeID)
    if (not uiItemBaseID) or (uiItemBaseID == 0) then
        return 0, 0, false
    end
    local kItemBaseData = self:GetItemTypeDataByTypeID(uiItemBaseID)
    if not kItemBaseData then
        return 0, 0, false
    end
    local uiFavorNeed, uiFavorSub = 0, 0
    local bIsRoleTreasure = (kItemBaseData.PersonalTreasure == uiRoleTypeID)
    if bIsRoleTreasure then
        local kPlayerSetMgr = PlayerSetDataManager:GetInstance()
        uiFavorNeed = kPlayerSetMgr:GetSingleFieldConfig(ConfigType.CFG_UNLOAD_ROLETREASURE_FAVOR_NEED) or 0
        uiFavorSub = kPlayerSetMgr:GetSingleFieldConfig(ConfigType.CFG_UNLOAD_ROLETREASURE_FAVORSUB) or 0
        return uiFavorNeed, uiFavorSub, bIsRoleTreasure
    end
    local eRank = kItemBaseData.Rank or RankType.RT_White
    local kRankMsg = TableDataManager:GetInstance():GetTableData("RankMsg", eRank)
    if not kRankMsg then
        return 0, 0, false
    end
    uiFavorNeed = kRankMsg.UnloadEquipFavorNeed or 0
    uiFavorSub = kRankMsg.ForceUnloadEquipFavorSub or 0
    return uiFavorNeed, uiFavorSub, bIsRoleTreasure
end

-- 分析卸下队友装备的前提条件
function ItemDataManager:GenUnloadRoleEquipPrecondition(uiItemBaseID, uiRoleID)
    if (not uiRoleID) or (uiRoleID == 0) then
        return
    end
    local kRoleMgr = RoleDataManager:GetInstance()
    local uiRoleTypeID = kRoleMgr:GetRoleTypeID(uiRoleID)
    if (not uiRoleTypeID) or (uiRoleTypeID == 0) then
        return
    end
    local kBaseItem = TableDataManager:GetInstance():GetTableData("Item", uiItemBaseID or 0)
    if not kBaseItem then
        return
    end
    local strRoleName = kRoleMgr:GetRoleName(uiRoleID) or "该角色"
    local uiFavorNeed, uiFavorSub, bIsRoleTreasure = self:GetUnloadRoleEquipFavorInfo(uiItemBaseID, uiRoleTypeID)
    local kPreCond = {
        ['strRoleName'] = strRoleName,  -- 装备所属角色的名称
        ['uiFavorNeed'] = uiFavorNeed,  -- 卸下装备所需要的好感
        ['uiFavorSub'] = uiFavorSub,    -- 好感度未达标时扣除的好感
        ['bCondTrue'] = true,           -- 条件是否满足
        ['bWillLeave'] = false,         -- 卸下装备后队友是否会离队
        ['strItemDesc'] = "",           -- 装备简述
    }
    -- 卸下装备, 需要扣除好感度, 并且与该角色的好感度需要判断是否有达到免扣需求
    if uiFavorSub > 0 then
        local uiCurFavor = kRoleMgr:GetDispotionValueToMainRole(uiRoleID) or 0
        kPreCond['bCondTrue'] = uiCurFavor >= uiFavorNeed
        kPreCond['bWillLeave'] = uiCurFavor <= uiFavorSub
    end
    if not kPreCond['bCondTrue'] then
        local strItemDesc = ""
        if bIsRoleTreasure then
            strItemDesc = "角色传家宝"
        else
            strItemDesc = string.format("<color=#913E2B>%s</color>品质装备", GetEnumText("RankType", kBaseItem.Rank) or "")
        end
        kPreCond['strItemDesc'] = strItemDesc
    end
    return kPreCond
end

-- 获取背包是否已达上限 
function ItemDataManager:GetIfMainRolePackageFilled(iMayAddNum)
    local roleInfo = globalDataPool:getData("MainRoleInfo") or {}
    local iLimit = roleInfo and roleInfo["MainRole"] and roleInfo["MainRole"][MRIT_BAG_ITEMNUM] or 0
    local iCurBackpackSize = RoleDataHelper.GetMainRoleBackpackSize() or 0
    iMayAddNum = iMayAddNum or 0
    if iMayAddNum > 0 and iCurBackpackSize + iMayAddNum > iLimit then 
        return true 
    elseif iCurBackpackSize >= iLimit then 
        return true
    end 
    return false
end 

-- 检查并记录主角获得的新装备
function ItemDataManager:CheckMainRoleNewItem(itemData)
    if not itemData or itemData.bBelongToMainRole ~= 1 then
        return
    end

    self.mainRoleNewItemRecord = self.mainRoleNewItemRecord or {}
    self.mainRoleNewItemRecord[itemData.uiTypeID] = itemData.uiID
end

function ItemDataManager:GetMainRoleNewItemID(itemTypeID)
    if self.mainRoleNewItemRecord then
        local itemData = self.mainRoleNewItemRecord[itemTypeID]
        return itemData
    end
end

-- 检查该物品操作时是否需要二次确认框 (同时操作多个物品的时候必须要二次确认)
function ItemDataManager:ItemUseNeedCheck(itemInstID)
    if not itemInstID then 
        return false 
    end
    local itemInst = self:GetItemData(itemInstID)
    if not itemInst then
        return false
    end
    --1\是否暗金及以上
    local itemRank = self:GetItemRankByItemBaseID(itemInst.uiTypeID)
    if itemRank >= RankType.RT_DarkGolden then 
        return true
    end
    --2\是否被重铸、熔炼 （使用了精铁完美粉）
    if itemInst.uiPerfectPower and itemInst.uiPerfectPower > 0 then 
        return true 
    end
    if itemInst.uiSpendIron and itemInst.uiSpendIron > 0 then 
        return true 
    end
    --3\强化等级>5 （后续需要改成判断是否消耗银锭）
    if itemInst.uiEnhanceGrade and itemInst.uiEnhanceGrade > 5 then
        return true
    end

    return false
end


-- 获取道具解锁类型
function ItemDataManager:GetItemUnlockType(itemStaticData)
    if not (itemStaticData) then return nil end
    
    local map_type_Unlockid = {
        [EffectType.ETT_UnlockRecipe] = PlayerInfoType.PIT_FORMULA,
        [EffectType.ETT_UseItem_AddTitle] = PlayerInfoType.PIT_TITLE,
        [EffectType.ETT_UseItem_AddBackgroundImage] = PlayerInfoType.PIT_BACKGROUND,
        [EffectType.ETT_UseItem_AddMusic] = PlayerInfoType.PIT_BGM,
        [EffectType.ETT_UseItem_AddPoetry] = PlayerInfoType.PIT_POERTY,
        [EffectType.ETT_UseItem_AddPlatform] = PlayerInfoType.PIT_PEDESTAL,
        [EffectType.ETT_UNLOCK_LOGINWORD] = PlayerInfoType.PIT_LOGINWORD,
        [EffectType.ETT_UseItem_AddHeadFrame] = PlayerInfoType.PIT_HEADBOX,
        [EffectType.ETT_UseItem_AddWaiter] = PlayerInfoType.PIT_LANDLADY,
        [EffectType.ETT_UseItem_AddChatFrame] = PlayerInfoType.PIT_CHATBUBBLE,
    }
    local EffectType = itemStaticData.EffectType
    local iUnlockID = itemStaticData.Value1
    local retStr = ''
    if iUnlockID and iUnlockID ~= '' then 
        iUnlockID = tonumber(iUnlockID)
        return map_type_Unlockid[EffectType]
    end 
    return nil
end

-- 依道具使用效果的id获取unlockpool的id
function ItemDataManager:GetEffectTypeUnlockPoolID(eEffectType,iItemUnlcokID)
    if not eEffectType or not iItemUnlcokID then 
        return 0 
    end 
    local map_dontneedChange = {
        [PlayerInfoType.PIT_FORMULA] = true,
        [PlayerInfoType.PIT_TITLE] = true,
    }
    -- 照着服务器的逻辑 不同的效果会存不同的unlockpool的id
    if not map_dontneedChange[eEffectType] then 
        -- 这类unlockpool里存的是playerinfo表的baseid 
        -- 传入的iItemUnlcokID为playerinfo表的unlockid
        if not self.PlayerInfoMap then 
            self.PlayerInfoMap = {}
            local TBPlayerInfo = TableDataManager:GetInstance():GetTable('PlayerInfo')
            for i,PlayerInfo in pairs(TBPlayerInfo) do 
                self.PlayerInfoMap[PlayerInfo.Type] = self.PlayerInfoMap[PlayerInfo.Type] or {}
                self.PlayerInfoMap[PlayerInfo.Type][PlayerInfo.UnlockID] = PlayerInfo
            end
        end
        if self.PlayerInfoMap[eEffectType] and self.PlayerInfoMap[eEffectType][iItemUnlcokID] then 
            return self.PlayerInfoMap[eEffectType][iItemUnlcokID].BaseID 
        end 

    end 
    return iItemUnlcokID
end

-- 获取道具是否为解锁道具，及是否已经解锁
function ItemDataManager:GetIfUnlockItemUnlocked(itemStaticData)
    if not (itemStaticData) then return false end
    
    local eUnlockType = self:GetItemUnlockType(itemStaticData)
    local iUnlockID = itemStaticData.Value1
    local retStr = ''
    if eUnlockType then 
        iUnlockID = tonumber(iUnlockID)
        iUnlockID = self:GetEffectTypeUnlockPoolID(eUnlockType,iUnlockID)
        if UnlockDataManager:GetInstance():HasUnlock(eUnlockType,iUnlockID) then 
            return true
        else
            return false
        end
    end 
    return false
end 

-- 获取某资产对应的物品静态id
function ItemDataManager:GetPlayerAssetItemBaseIDByName(strName)
    if (not strName) or (strName == "") then
        return 0
    end

    -- 分析且只分析一次映射表
    if not self.kName2Asse then
        local kDBAsset = TableDataManager:GetInstance():GetTable("PlayerAsset") or {}
        local kName2Asset = {}
        for _, kData in pairs(kDBAsset) do
            if kData.ItemID and (kData.ItemID > 0) 
            and kData.AssetName and (kData.AssetName ~= "") then
                kName2Asset[kData.AssetName] = kData.ItemID
            end
        end
        self.kName2Asset = kName2Asset
    end

    -- 直接使用缓存的数据
    if not self.kName2Asset then
        return 0
    end
    return self.kName2Asset[strName] or 0
end

-- 尝试修复装备通灵玉数量
-- 说明: 
-- 由于后面新开发了使用通灵玉强化装备以及熔炼返还通灵玉的系统
-- 来代替原来的银锭重铸, 所以这个接口用于对外网玩家花银锭强化过的装备, 自动转化记录上通灵玉
-- 操作如下: 在维护期间, 使用SQL对玩家所有装备置上通灵玉数量 1 
-- (主要目的是为了和策划后期可能会在游戏中投入的高强化等级自然产出装备作区分, 自然产出的装备不需要做修复, 装备上记录的通灵玉数量会是 0)
-- 在玩家进行 强化/熔炼 操作前, 先调用该接口对装备进行检查修复, 检查条件为, 装备上记录的通灵玉数量是否严格等于 1
-- 符合条件的玩家装备中, 强化+4以上(+5开始才需要花银锭)的, 计算其等价消耗的通灵玉, 并更新该装备的数据,
function ItemDataManager:TryToFixEquipTongLingYu(kInstItem, bEnableLowRankSetZero)
	local uiFixTongLingYu = 0

    if not (kInstItem and kInstItem.uiTypeID) then
        return false, uiFixTongLingYu
    end

    local kBaseItem = self:GetItemTypeDataByTypeID(kInstItem.uiTypeID)
    if not (kBaseItem and kBaseItem.Rank) then
        return false, uiFixTongLingYu
    end

    local eRank = kBaseItem.Rank or 0
    local uiEnhanceLevel = kInstItem.uiEnhanceGrade or 0
    local uiCurTongLingYu = kInstItem.uiSpendTongLingYu or 0

	-- 当前通灵玉数量需要强等于 1
	if (not uiEnhanceLevel) or (0 == uiEnhanceLevel) or (uiCurTongLingYu ~= 1) then
        return false, uiFixTongLingYu
    end

    -- 新加一条规则: 只对金色及以上的装备进行转化, 金色以下的置回0
    if (eRank or RankType.RT_White) < RankType.RT_Golden then
        -- 是否需要对低配置装备的通灵玉进行归0
        if bEnableLowRankSetZero ~= false then
            return true, 0
        end
        return false, uiFixTongLingYu
    end

	-- 根据静态表生成一次映射
    if not self.kRankEnhanceCostTongLingYu then
        local kDBForgeLvupCost = TableDataManager:GetInstance():GetTable("ForgeLvupCost")
		if not kDBForgeLvupCost then
            return false, uiFixTongLingYu
        end
        -- 强化装备是单级晋升的, 所以到每级所需要消耗的通灵玉应该是从上一级累加的
        local kMap = {}
        for _, kData in pairs(kDBForgeLvupCost) do
            if not kMap[kData.Rank] then
                kMap[kData.Rank] = {}
            end
            kMap[kData.Rank][#kMap[kData.Rank] + 1] = kData
        end
        self.kRankEnhanceCostTongLingYu = {}
        for eRank, akDatas in pairs(kMap) do
            table.sort(akDatas, function(a, b)
                return (a.StrengthLv or 0) < (b.StrengthLv or 0)
            end)
            local uiSumRankJade = 0
            local kRankCostMap = {}
            for index, kData in ipairs(akDatas) do
                uiSumRankJade = uiSumRankJade + (kData.Jade or 0)
                kRankCostMap[#kRankCostMap + 1] = uiSumRankJade
            end
            self.kRankEnhanceCostTongLingYu[eRank] = kRankCostMap
        end
	end

	-- 获取当前品质的消耗数组
	if not self.kRankEnhanceCostTongLingYu[eRank] then
		return false, uiFixTongLingYu
    end
	local kRankCostMap = self.kRankEnhanceCostTongLingYu[eRank]

    -- 如果装备的强化等级已经超过了缓存的数据上限, 直接返回最高一级的数量
    local uiLimit = #kRankCostMap
	if uiEnhanceLevel >= uiLimit then
        uiFixTongLingYu = kRankCostMap[uiLimit]
    else
        uiFixTongLingYu = kRankCostMap[uiEnhanceLevel]
    end

    kInstItem.uiSpendTongLingYu = uiFixTongLingYu
	return true, uiFixTongLingYu
end