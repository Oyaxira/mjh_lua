NPCRole = class("NPCRole", BaseRole)
function NPCRole:ctor(uiID, roleData)
    self:UpdateNPCRoleInfo(roleData)
end

function NPCRole:UpdateNPCRoleInfo(roleData)
    self.uiOverlayLevel = roleData.uiOverlayLevel
    self.roleType = ROLE_TYPE.NPC_ROLE
    self.uiIndex = roleData.uiIndex
    self.iGoogEvil = roleData.iGoodEvil
    self.uiStaticItemsFlag = roleData.uiStaticItemsFlag
    self.uiStaticEquipsFlag = roleData.uiStaticEquipsFlag
    self._dbData = (TB_RoleHash[roleData.uiTypeID] or {})[self.uiIndex]
    if self._dbData == nil then
        self._dbData = {}
        dprint("[NPCRole] => NoRole: " .. roleData.uiTypeID)
    end
end

-- itemIndex: 武器随机下标（因为掌门对决固定为0，所以加上了）
function NPCRole:UpdateAttr(itemIndex)

    if self:IsError() then
        derror('npc dbData error');
        return;
    end

    local revert = {
        ["Strength"] = "力道",
        ["Constitution"] = "体质",
        ["Energy"] = "精力",
        ["Power"] = "内劲",
        ["Agility"] = "灵巧",
        ["Comprehension"] = "悟性",
        ["FistMastery"] = "拳掌精通",
        ["SwordMastery"] = "剑法精通",
        ["KnifeMastery"] = "刀法精通",
        ["LegMastery"] = "腿法精通",
        ["StickMastery"] = "奇门精通",
        ["NeedleMastery"] = "暗器精通",
        ["HealingMastery"] = "医术精通",
        ["SoulMastery"] = "内功精通",
        ["HP"] = "生命",
        ["MP"] = "真气",
        ["Speed"] = "速度值",
        ["HittingPer"] = "命中率",
        ["CritsPer"] = "暴击率",
        ["CritsFactor"] = "暴击伤害倍率"
    }
    -- 只对掌门对决的角色加特殊属性
    local bIfIsZM = GetCurScriptID() == 9 
    local level = self:GetLevel()
    local TB_Attr = TableDataManager:GetInstance():GetTableData("RoleAttr", self._dbData.AttributeID) or {}
    local revertT = {}
    if TB_Attr then
        for k, v in pairs(revert) do
            if AttrType_Revert[v] then
                revertT[AttrType_Revert[v]] = TB_Attr[k]
            end
        end
    end

    self.baseAttr = {revertT}
    self.convBaseAttr = RoleDataHelper.GetConvertAttr(revertT, level)

    local _func = function(attrData)
        local attr = {}
        for k, v in pairs(attrData) do
            for kk, vv in pairs(v) do
                if not attr[kk] then
                    attr[kk] = 0
                end
                attr[kk] = attr[kk] + vv
            end
        end
        return attr
    end

    self.martialAttr = RoleDataHelper.GetAttrByMartials(self, self._dbData)
    self.convMartialAttr = RoleDataHelper.GetConvertAttr(_func(self.martialAttr), level)

    self.equipAttr = RoleDataHelper.GetAttrByEquips(self, self._dbData, itemIndex)
    self.convEquipAttr = RoleDataHelper.GetConvertAttr(_func(self.equipAttr), level)

    self.titleAttr = RoleDataHelper.GetAttrByTitle(self, self._dbData, true)
    self.convTitleAttr = RoleDataHelper.GetConvertAttr(_func(self.titleAttr), level)
    
    self.fixGiftAttr = RoleDataHelper.GetAttrByGifts(self, self._dbData, true, false, false)
    self.perGiftAttr = RoleDataHelper.GetAttrByGifts(self, self._dbData, false, true, false)
    self.conGiftAttr = RoleDataHelper.GetAttrByGifts(self, self._dbData, false, false, true)
    self.convFixGiftAttr = RoleDataHelper.GetConvertAttr(_func(self.fixGiftAttr), level)
    self.convPerGiftAttr = RoleDataHelper.GetConvertAttr(_func(self.perGiftAttr), level)
    self.convConGiftAttr = RoleDataHelper.GetConvertAttr(_func(self.conGiftAttr), level)


    if bIfIsZM then 
        local uiCardLevel =
            self.uiOverlayLevel ~= nil and self.uiOverlayLevel or
            RoleDataManager:GetInstance():GetRoleOverlayLevel(self.uiID)
        local TB_RolePiece = TableDataManager:GetInstance():GetTable("RolePiece") or {}
        local sumAttrAdd = 0
        for i = 1, #(TB_RolePiece) do
            if uiCardLevel >= TB_RolePiece[i].Level then
                sumAttrAdd = sumAttrAdd + TB_RolePiece[i].AttrAdd
            end
        end
        local baseAttr = {
            AttrType.ATTR_LIDAO,
            AttrType.ATTR_TIZHI,
            AttrType.ATTR_JINGLI,
            AttrType.ATTR_NEIJIN,
            AttrType.ATTR_LINGQIAO,
            AttrType.ATTR_WUXING
        }
        local cardAttr = {}
        for i = 1, #(baseAttr) do
            cardAttr[baseAttr[i]] = (self.baseAttr[1][baseAttr[i]] or 0) * sumAttrAdd / 10000
        end
        self.cardAttr = {cardAttr}
        self.convCardAttr = RoleDataHelper.GetConvertAttr(cardAttr, level)
    else
        self.cardAttr = {}
        self.convCardAttr = {}
    end 
end

function NPCRole:GetAttrByMeridians()
    return {};
end

function NPCRole:GetConvAttrByMeridians()
    return {};
end

function NPCRole:GetAttrByCardLevel()
    return self.cardAttr or {}
end

function NPCRole:GetConvAttrByCardLevel()
    return self.convCardAttr or {}
end

function NPCRole:GetAttrByTBData()
    return self.baseAttr or {}
end

function NPCRole:GetConvAttrByTBData()
    return self.convBaseAttr or {}
end

function NPCRole:GetAttrByMartials()
    return self.martialAttr or {}
end

function NPCRole:GetConvAttrByMartials()
    return self.convMartialAttr or {}
end

function NPCRole:GetAttrByEquips()
    return self.equipAttr or {}
end

function NPCRole:GetConvAttrByEquips()
    return self.convEquipAttr or {}
end

function NPCRole:GetAttrByTitle()
    return self.titleAttr or {}
end

function NPCRole:GetConvAttrByTitle()
    return self.convTitleAttr or {}
end

function NPCRole:GetFixAttrByGifts()
    return self.fixGiftAttr or {}
end

function NPCRole:GetPerAttrByGifts()
    return self.perGiftAttr or {}
end

function NPCRole:GetConAttrByGifts()
    return self.conGiftAttr or {}
end

function NPCRole:GetFixConvAttrByGifts()
    return self.convFixGiftAttr or {}
end

function NPCRole:GetPerConvAttrByGifts()
    return self.convPerGiftAttr or {}
end

function NPCRole:GetConConvAttrByGifts()
    return self.convConGiftAttr or {}
end

function NPCRole:IsError()
    if not self._data or not self._dbData then
        return true
    end
    return false
end

function NPCRole:GetStaticItemFlag(index)
    local eState = NSIS_NUMS

    if index and index >= 0 and index < 32 then
        local iFlagPos = index * 2
        eState = (self.uiStaticItemsFlag >> iFlagPos) & 3
    end

    return eState
end

function NPCRole:GetStaticBagItemInfo(bagItemIndex)
    local dbBag = self:GetDBBag()
    local eState = 0

    if not bagItemIndex or bagItemIndex < 1 then
        return nil
    end

    if not dbBag or #dbBag < bagItemIndex then
        return false
    end

    local uiFlagPos = bagItemIndex * 2 - 2
    eState = (self.uiStaticItemsFlag >> uiFlagPos) & 3

    if eState == NSIS_DEFAULT then
        eState = NSIS_BAG
    end

    local info = {}
    info.uiItemTypeID = dbBag[bagItemIndex]
    info.eState = eState

    return info
end

function NPCRole:GetStaticEquipItemInfo(equipPos)
    local dbRole = self:GetDBRole()
    local uiFlagIndex = 0
    local uiItemTypeID = 0
    local eState = 0

    -- 写死索引了
    if equipPos == REI_WEAPON then
        uiItemTypeID = dbRole.Weapon
        uiFlagIndex = 0
    elseif equipPos == REI_CLOTH then
        uiItemTypeID = dbRole.Clothes
        uiFlagIndex = 1
    elseif equipPos == REI_SHOE then
        uiItemTypeID = dbRole.Shoe
        uiFlagIndex = 2
    elseif equipPos == REI_JEWELRY then
        uiItemTypeID = dbRole.Ornaments
        uiFlagIndex = 3
    elseif equipPos == REI_THRONE then
        uiItemTypeID = dbRole.Artifacts
        uiFlagIndex = 4
    elseif equipPos == REI_RAREBOOK then
        uiItemTypeID = dbRole.KungfuBook
        uiFlagIndex = 5
    elseif equipPos == REI_HORSE then
        uiItemTypeID = dbRole.Horse
        uiFlagIndex = 6
    end

    if not uiItemTypeID or uiItemTypeID == 0 then
        return nil
    end

    local iFlagPos = uiFlagIndex * 2
    eState = (self.uiStaticEquipsFlag >> iFlagPos) & 3

    if eState == NSIS_DEFAULT then
        eState = NSIS_EQUIP
    end

    local info = {}
    info.uiItemTypeID = uiItemTypeID
    info.eState = eState

    return info
end

function NPCRole:GetEvolutionsByType(eType)
    return EvolutionDataManager:GetInstance():GetEvolutionsByType(self.uiID, eType)
end

-- 获取Npc背包表配置物品 map : typeid - num
function NPCRole:GetBagStaticItems()
    if self:IsError() then
        return {}
    end

    local dbBag = self:GetDBBag()
    local staticItemNums = {}

    if dbBag then
        for index = 1, #dbBag do
            local info = self:GetStaticBagItemInfo(index)
            if info and info.eState == NSIS_BAG then
                staticItemNums[info.uiItemTypeID] = staticItemNums[info.uiItemTypeID] or 0
                staticItemNums[info.uiItemTypeID] = staticItemNums[info.uiItemTypeID] + 1
            end
        end
    end

    for equipPos = REI_NULL, REI_NUMS do
        local info = self:GetStaticEquipItemInfo(equipPos)
        if info and info.eState == NSIS_BAG then
            staticItemNums[info.uiItemTypeID] = staticItemNums[info.uiItemTypeID] or 0
            staticItemNums[info.uiItemTypeID] = staticItemNums[info.uiItemTypeID] + 1
        end
    end

    return staticItemNums
end

-- 获取Npc背包实例物品 array : instid
function NPCRole:GetBagItems()
    if self:IsError() then
        return {}
    end

    return self.auiRoleItem or {}
end

function NPCRole:GetItemNum(uiItemTypeID)
    if self:IsError() then
        return 0
    end

    local iNum = 0

    local bagInstItems = self:GetBagItems()
    for index, itemID in pairs(bagInstItems) do
        local typeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
        local num = ItemDataManager:GetInstance():GetItemNum(itemID)
        if typeID == uiItemTypeID then
            iNum = iNum + num
        end
    end

    local bagStaticItems = self:GetBagStaticItems()
    for typeID, num in ipairs(bagStaticItems) do
        if typeID == uiItemTypeID then
            iNum = iNum + num
        end
    end

    local equipInstItems = self:GetEquipItems()
    for pos, itemID in pairs(equipInstItems) do
        if itemID and itemID ~= 0 then
            local typeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
            local num = ItemDataManager:GetInstance():GetItemNum(itemID)
            if typeID == uiItemTypeID then
                iNum = iNum + num
            end
        end
    end

    local equipStaticItems = self:GetEquipStaticItems()
    for pos, typeID in pairs(equipStaticItems) do
        if typeID == uiItemTypeID then
            iNum = iNum + 1
        end
    end

    return iNum
end

-- 获取Npc装备表配置物品 map : equip - typeid
function NPCRole:GetEquipStaticItems()
    if self:IsError() then
        return {}
    end

    local dbBag = self:GetDBBag()
    local equips = {}

    if dbBag then
        for index = 1, #dbBag do
            local info = self:GetStaticBagItemInfo(index)
            if info and info.eState == NSIS_EQUIP then
                local uiItemTypeID = info.uiItemTypeID
                local equipPos = ItemDataManager:GetEquipPos(uiItemTypeID)

                if equipPos ~= REI_NULL then
                    equips[equipPos] = uiItemTypeID
                end
            end
        end
    end

    for equipPos = REI_NULL, REI_NUMS do
        local info = self:GetStaticEquipItemInfo(equipPos)
        if info and info.eState == NSIS_EQUIP then
            equips[equipPos] = info.uiItemTypeID
        end
    end

    return equips
end

-- 获取Npc装备实例物品 map : equip - instid
function NPCRole:GetEquipItems()
    if self:IsError() then
        return {}
    end

    return self.akEquipItem or {}
end

-- 获取所有装备信息
function NPCRole:GetEquipItemInfos()
    local infos = {}

    local equipItems = self:GetEquipItems()
    if equipItems then
        for equips, itemID in pairs(equipItems) do
            local info = {}
            info.iInstID = itemID
            infos[equips] = info
        end
    end

    local equipStaticItems = self:GetEquipStaticItems()
    if equipStaticItems then
        for equips, itemID in pairs(equipStaticItems) do
            local info = {}
            info.iTypeID = itemID
            infos[equips] = info
        end
    end

    return infos
end

function NPCRole:GetMartials()
    local Kungfu = self:GetDBKungfu()
    local KungfuLevel = self:GetDBKungfuLevel()

    local akEvolutions = self:GetEvolutionsByType(NET_MARTIAL_TYPEID)
    local idx = 0
    local auiMartialsLvs = {}
    for i = 0, getTableSize(akEvolutions) - 1 do
        local lastValue = auiMartialsLvs[akEvolutions[i].iParam1]
        if not lastValue or lastValue < akEvolutions[i].iParam2 then
            auiMartialsLvs[akEvolutions[i].iParam1] = akEvolutions[i].iParam2
        end
    end

    akEvolutions = self:GetEvolutionsByType(NET_MARTIAL)
    for i = 0, getTableSize(akEvolutions) - 1 do
        local typeid = ItemDataManager:GetInstance():GetItemTypeID(akEvolutions[i].iParam1)
        local lastValue = auiMartialsLvs[typeid]
        if not lastValue or lastValue < akEvolutions[i].iParam2 then
            auiMartialsLvs[typeid] = akEvolutions[i].iParam2
        end
    end

    for i = 1, #Kungfu do
        local typeid = Kungfu[i]
        local lastValue = auiMartialsLvs[typeid]
        if not lastValue or lastValue < KungfuLevel[i] then
            auiMartialsLvs[typeid] = KungfuLevel[i]
        end
    end

    local keytable = {}
    for k, v in pairs(auiMartialsLvs) do
        keytable[#keytable + 1] = k
    end

    local aoYi = {}
    for i = 1, #(keytable) do
        local aoyiTypeID, aoyiLevel = self:UpdateAoyi(auiMartialsLvs, keytable[i], auiMartialsLvs[keytable[i]])
        if aoyiTypeID and aoyiLevel then
            aoYi[aoyiTypeID] = aoyiLevel
        end
    end

    for k, v in pairs(aoYi) do
        keytable[#(keytable) + 1] = k
        auiMartialsLvs[k] = v
    end

    table.sort(
        keytable,
        function(a, b)
            local dba = GetTableData("Martial", a)
            local dbb = GetTableData("Martial", b)
            if not dba or not dbb then
                return a > b
            end

            if dba.Rank == dbb.Rank then
                return auiMartialsLvs[a] > auiMartialsLvs[b]
            else
                return dba.Rank > dbb.Rank
            end

            return a > b
        end
    )
    local auiTypeIds = {}
    local auiLvs = {}
    for i = 1, #keytable do
        auiTypeIds[i - 1] = keytable[i]
        auiLvs[i - 1] = auiMartialsLvs[keytable[i]]
    end

    return auiTypeIds, auiLvs
end

function NPCRole:GetLevel()
    local dblv = self:GetDBLevel()
    local akEvolutions = self:GetEvolutionsByType(NET_LEVEL)
    for i = 0, getTableSize(akEvolutions) - 1 do
        return akEvolutions[i].iParam1 or 0
    end

    return dblv
end

function NPCRole:GetClan()
    return self:GetDBClan()
end

function NPCRole:GetGoodEvil()
    return self.iGoogEvil
end

function NPCRole:GetAttr(sAttr)
    attrvalue = self.super.GetAttr(self, sAttr)
    local eAttr = RoleAttrTypeMap[sAttr]
    local akEvolutions = self:GetEvolutionsByType(NET_ATTR)
    for i = 0, getTableSize(akEvolutions) - 1 do
        local kEvolution = akEvolutions[i]
        if eAttr == kEvolution.iParam1 then
            attrvalue = attrvalue + akEvolutions[i].iParam2
        end
    end
    return attrvalue
end

function NPCRole:GetGifts()
    local TB_Item = TableDataManager:GetInstance():GetTable("Item")
    local TB_Gift = TableDataManager:GetInstance():GetTable("Gift")
    local TB_Clan = TableDataManager:GetInstance():GetTable("Clan")
    local TB_Skill = TableDataManager:GetInstance():GetTable("Skill")
    local TB_SuperImposed = TableDataManager:GetInstance():GetTable("SuperImposed")
    local Gift = self:GetDBGift()
    local akEvolutions = self:GetEvolutionsByType(NET_GIFT_TYPEID)
    local equipItemInfos = self:GetEquipItemInfos()
    local idx = 0
    local auiTypeIds = {}

    local tempClanData = TB_Clan[self._dbData.Clan]
    if self._dbData and self._dbData.Clan and tempClanData and tempClanData.ClanGiftID then
        if tempClanData.ClanGiftID[self:GetRoleRank()] then
            auiTypeIds[idx] = tempClanData.ClanGiftID[self:GetRoleRank()]
            idx = idx + 1
        end
    end

    for k, v in pairs(equipItemInfos) do
        local itemTypeID = 0
        if v.iInstID and v.iInstID > 0 then
            itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(v.iInstID)
        elseif v.iTypeID and v.iTypeID > 0 then
            itemTypeID = v.iTypeID
        end

        local equip = TB_Item[itemTypeID]
        if equip and equip.BlueGift then
            for kk, vv in pairs(equip.BlueGift) do
                if TB_Gift[vv] and TB_Gift[vv].GiftType == GiftType.GT_Adventure and self:GetEnchanceGrade() >=equip.BlueGiftUnlockLv[kk]then
                    auiTypeIds[idx] = vv
                    idx = idx + 1
                end
            end
        end
    end

    for i = 0, getTableSize(akEvolutions) - 1 do
        auiTypeIds[idx] = akEvolutions[i].iParam1
        idx = idx + 1
    end

    for i = 1, #Gift do
        auiTypeIds[idx] = Gift[i]
        idx = idx + 1
    end

    -- TODO 组装 NPC 可成长天赋
    -- 装备
    local growupGifts = {}
    for k, v in pairs(equipItemInfos) do
        local itemTypeID = 0
        if v.iInstID and v.iInstID > 0 then
            itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(v.iInstID)
        elseif v.iTypeID and v.iTypeID > 0 then
            itemTypeID = v.iTypeID
        end

        local equip = TB_Item[itemTypeID]
        if equip and equip.BlueGift then
            for kk, vv in pairs(equip.BlueGift) do
                if TB_Gift[vv] and TB_Gift[vv].SurperType > 0 and self:GetEnchanceGrade() >=equip.BlueGiftUnlockLv[kk] then
                    table.insert(growupGifts, vv)
                end
            end
        end
    end

    -- 天赋
    for i = 1, #(Gift) do
        if TB_Gift[Gift[i]] and TB_Gift[Gift[i]].SurperType > 0 and TB_Gift[Gift[i]].Cost == 0 then
            table.insert(growupGifts, Gift[i])
        end
    end

    -- 武学
    local martialInfo = RoleDataHelper.GetMartialInfo(self)
    local skill = {}
    for k, v in pairs(martialInfo.martialUnlockSkills) do
        for kk, vv in pairs(v) do
            if TB_Skill[vv] and TB_Skill[vv].SurperType > 0 then
                if not skill[TB_Skill[vv].SurperType] then
                    skill[TB_Skill[vv].SurperType] = 0
                end
                skill[TB_Skill[vv].SurperType] = skill[TB_Skill[vv].SurperType] + TB_Skill[vv].AddLevel
            end
        end
    end
    local giftIDs = {}
    for k, v in pairs(skill) do
        local tbData = TB_SuperImposed[k]
        if tbData and tbData.BuffList then
            local index = v > #(tbData.BuffList) and #(tbData.BuffList) or v
            local giftID = tbData.BuffList[index]
            table.insert(growupGifts, giftID)
        end
    end
    local tempT = {}
    for k, v in pairs(growupGifts) do
        if TB_Gift[v] then
            if not tempT[TB_Gift[v].SurperType] then
                tempT[TB_Gift[v].SurperType] = 0
            end
            tempT[TB_Gift[v].SurperType] = tempT[TB_Gift[v].SurperType] + TB_Gift[v].AddLevel
        end
    end

    for k, v in pairs(tempT) do
        if TB_SuperImposed[k] then
            local buffCount = #(TB_SuperImposed[k].BuffList)
            local addLevel = v > buffCount and buffCount or v
            local giftID = TB_SuperImposed[k].BuffList[addLevel]
            auiTypeIds[idx] = giftID
            idx = idx + 1
        end
    end

    return auiTypeIds
end

function NPCRole:GetModelID()
    return self.super.GetModelID(self)
end

function NPCRole:GetWeaponTypeID()
    local akEquipItemInfos = self:GetEquipItemInfos()
    if akEquipItemInfos and akEquipItemInfos[REI_WEAPON] then
        return akEquipItemInfos[REI_WEAPON]["iTypeID"]
    end
    return 0
end

function NPCRole:GetEnchanceGrade()
    return 0
end

function NPCRole:UpdateAoyi(martialsLvs, martialTypeID, martialLevel)
    local TB_Aoyi = TableDataManager:GetInstance():GetTable("AoYi")
    local aoYiTable = MartialDataManager:GetInstance():GetAoYiTable()
    if aoYiTable[martialTypeID] then
        for k, v in pairs(aoYiTable[martialTypeID]) do
            if martialLevel >= v and TB_Aoyi[k] and TB_Aoyi[k].MartialList then
                local flag = true
                local uiLevel = 0
                for kk, vv in pairs(TB_Aoyi[k].MartialList) do
                    if (not martialsLvs[vv]) or (martialsLvs[vv] < v) then
                        flag = false
                        break
                    else
                        uiLevel = martialsLvs[vv]
                    end
                end
                if flag then
                    return TB_Aoyi[k].AoYiID, uiLevel
                end
            end
        end
    end
end


function NPCRole:GetRoleJingTongGift()
    local kConfig = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
    if not kConfig then
        return nil
    end

    if not kConfig.JingTongGiftType or not kConfig.JingTongGifts or 
    #kConfig.JingTongGiftType ~= #kConfig.JingTongGifts or
    #kConfig.JingTongGiftType == 0 then
        return nil
    end


    local uiCurMaxAttrValue = 0
    local uiCurMaxAttrGift = 0
    if kConfig.JingTongGiftType then
        for iIndex, eAttrType in ipairs(kConfig.JingTongGiftType) do
            local uiAttrValue = RoleDataHelper.GetObserveAttr(self, self:GetDBRole(), RoleAttrTypeMapRevert[eAttrType]) or 0

            if uiAttrValue > uiCurMaxAttrValue then
                uiCurMaxAttrValue = uiAttrValue
                uiCurMaxAttrGift = kConfig.JingTongGifts[iIndex]
            end
        end
    end

    if uiCurMaxAttrGift ~= 0 then
        return uiCurMaxAttrGift
    end
end

function NPCRole:GetObserveGifts()
    local auiTypeIds = self:GetGifts()

    -- 精通天赋
    local uiJingTongGift = self:GetRoleJingTongGift()
    if uiJingTongGift then
        table.insert(auiTypeIds, uiJingTongGift)
    end

    return auiTypeIds
end
