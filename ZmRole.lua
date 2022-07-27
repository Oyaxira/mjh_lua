ZmRole = class("ZmRole", NPCRole)

function ZmRole:ctor(uiID, roleData)
    self.uiRemainAttrPoint = 0
    self.uiExp = 0
    self.uiLevel = roleData["uiLevel"]
    self.uiRank = roleData["uiRank"]

    self.equipLevel = roleData["equipLevel"] or 1
    self.equipID = roleData["equipID"] or 0
    self.throneLevel = roleData["throneLevel"] or 1

    self.aiAttrs = {}
    self.auiRoleGift = {}
    self.akEquipItem = {}

    self.uiModelID = self._dbData.ArtID

    self.mUpdateFlag = false

    roleData.uiStaticItemsFlag = 0
    roleData.uiStaticEquipsFlag = 0
    self:UpdateNPCRoleInfo(roleData)

    -- 哎，必须得设为HouseRole，这样才能读实例的装备
    self.roleType = ROLE_TYPE.HOUSE_ROLE
    -- 哎，必须得设为0，不然HouseRole调用TitileAttrib报错
    self.uiTitleID = 0
    -- self:Update()
end

function ZmRole:Update()
    if self.mUpdateFlag then
        return
    end
    self.mUpdateFlag = true

    -- 装备
    local equipMap = self.akEquipItem
    equipMap[REI_CLOTH] = PKManager:GetInstance():AddEquip(self._dbData["Clothes"], self.equipLevel)
    equipMap[REI_SHOE] = PKManager:GetInstance():AddEquip(self._dbData["Shoe"], self.equipLevel)
    equipMap[REI_JEWELRY] = PKManager:GetInstance():AddEquip(self._dbData["Ornaments"], self.equipLevel)
    equipMap[REI_WEAPON] = PKManager:GetInstance():AddEquip(self._dbData["Weapon"], self.equipLevel)

    -- 神器
    if self.equipID > 0 then
        equipMap[REI_THRONE] = PKManager:GetInstance():AddEquip(nil, self.throneLevel, self.equipID)
    end

    self:UpdateAttr(0)

    for key, attrType in pairs(AttrType) do
        -- TODO: 属性四舍五入
        self.aiAttrs[attrType] = math.floor(self:GetAttrEx(attrType) + 0.5)
    end

    self.uiHP = self.aiAttrs[AttrType.ATTR_MAXHP]
    self.uiMP = self.aiAttrs[AttrType.ATTR_MAXMP] + self.aiAttrs[AttrType.ATTR_ROLE_MP]

    -- 天赋
    local giftMap = self:GetGifts()
    for index, id in pairs(giftMap) do
        self.auiRoleGift[index - 1] = id

        -- 加入到天赋池
        AddGift(id)
    end

    self:UpdateMartial()
    RoleDataManager:GetInstance():UpdateRoleCommonData(self)
end

-- 武学
function ZmRole:UpdateMartial()
    local kungfu = self:GetDBKungfu()
    local kungfuLevel = self:GetDBKungfuLevel()
    local martials = {}
    for index, id in pairs(kungfu) do
        martials[index - 1] = AddMartial(self, index - 1, id, kungfuLevel[index])
    end

    MartialDataManager:GetInstance():UpdateMartialDataByArray(martials, #kungfu)
end

function ZmRole:GetAttrEx(attrType)
    local attr = 0

    attr = attr + GetAttr(self.baseAttr, attrType)
    attr = attr + GetAttr(self.convBaseAttr, attrType)

    attr = attr + GetAttr(self.martialAttr, attrType)
    attr = attr + GetAttr(self.convMartialAttr, attrType)

    attr = attr + GetAttr(self.equipAttr, attrType)
    attr = attr + GetAttr(self.convEquipAttr, attrType)

    attr = attr + GetAttr(self.titleAttr, attrType)
    attr = attr + GetAttr(self.convTitleAttr, attrType)

    attr = attr + GetAttr(self.fixGiftAttr, attrType)
    attr = attr + GetAttr(self.convFixGiftAttr, attrType)

    attr = attr + GetAttr(self.perGiftAttr, attrType)
    attr = attr + GetAttr(self.convPerGiftAttr, attrType)

    attr = attr + GetAttr(self.conGiftAttr, attrType)
    attr = attr + GetAttr(self.convConGiftAttr, attrType)

    attr = attr + GetAttr(self.cardAttr, attrType)
    attr = attr + GetAttr(self.convCardAttr, attrType)

    return attr
end

function ZmRole:GetAttr(sAttr)
    local eAttr
    if tonumber(sAttr) then
        eAttr = sAttr
    else
        eAttr = RoleAttrTypeMap[sAttr]
    end
    return self.aiAttrs[eAttr] or 0
end

function ZmRole:GetModelID()
    local roleModelData = nil

    if self.uiTypeID ~= nil and self.uiTypeID ~= 0 then
        roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(self.uiTypeID)
    end

    if roleModelData == nil then
        return 0
    end

    return roleModelData.BaseID
end

function ZmRole:GetName()
    return RoleDataManager:GetInstance():GetRoleTitleAndName(self.uiID, false, false, true)
end

function ZmRole:GetRoleRank()
    return self.uiRank or RankType.RT_White
end

function ZmRole:GetWeaponTypeID()
    if self.akEquipItem then
        local uid = self.akEquipItem[REI_WEAPON]
        if uid then
            return ItemDataManager:GetInstance():GetItemTypeID(uid)
        end
    end

    return 0
end

function ZmRole:GetEnchanceGrade()
    if self.akEquipItem then
        local uid = self.akEquipItem[REI_WEAPON]
        if uid then
            return ItemDataManager:GetInstance():GetItemEnhanceGrade(uid)
        end
    end
    return 0
end

-- 获取Npc装备表配置物品 map : equip - typeid
function ZmRole:GetEquipStaticItems()
    return nil
end

-- 获取Npc装备实例物品 map : equip - instid
function ZmRole:GetEquipItems()
    if self:IsError() then
        return {}
    end

    return self.akEquipItem or {}
end

function ZmRole:GetEquipItemInfos()
    local infos = {}

    local equipItems = self:GetEquipItems()
    if equipItems then
        for equips, itemID in pairs(equipItems) do
            local info = {}
            info.iInstID = itemID
            infos[equips] = info
        end
    end

    return infos
end

function GetAttr(convAttrMap, attrType)
    local attr = 0

    if convAttrMap then
        for key, attrMap in pairs(convAttrMap) do
            attr = attr + (attrMap[attrType] or 0)
        end
    end

    return attr
end

function AddGift(id)
    local giftPool = globalDataPool:getData("GiftPool")
    if giftPool == nil then
        giftPool = {}
        globalDataPool:setData("GiftPool", giftPool)
    end

    giftPool[id] = {
        bIsGrowUp = 0,
        uiID = id,
        uiGiftSourceType = 0,
        uiTypeID = id
    }
end

function AddMartial(self, index, id, level)
    local battleList = globalDataPool:getData("EmbattleMartial")
    if battleList == nil then
        return
    end

    local uiID = PKManager:GetInstance():BuildUID()

    -- TODO: 卸载的武学也不装备
    local martialData = GetTableData("Martial", id)
    if martialData and martialData.MartMovIDs then
        local martialItemData = GetTableData("MartialItem", martialData.MartMovIDs[1])
        if martialItemData and martialItemData.ItemType ~= MartialItemType.MIT_GrowUp then
            if battleList[self.uiID] == nil then
                battleList[self.uiID] = {}
            end
            battleList = battleList[self.uiID]
            table.insert(
                battleList,
                {
                    dwTypeID = id,
                    dwUID = uiID,
                    dwIndex = index
                }
            )
        end
    end

    return {
        uiID = uiID,
        uiTypeID = id,
        uiLevel = level,
        iMartialUnlockItemSize = 0,
        uiMaxLevel = level,
        uiRoleUID = self.uiID,
        akMartialInfluences = {}
    }
end
