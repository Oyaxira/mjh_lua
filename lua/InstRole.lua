InstRole = class("InstRole",BaseRole)
function InstRole:ctor(uiID,roleData)
    self.roleType = ROLE_TYPE.INST_ROLE
end

function InstRole:GetBagItems()
    return self.auiRoleItem or {}
end

function InstRole:GetDBRole()
    if self._dbData == nil then
        self._dbData = TB_Role[self.uiTypeID]
    end 
    return self._dbData
end

function InstRole:GetDrawing()
    if self:IsMainRole() then 
        local data = RoleDataManager:GetInstance():GetMainRoleArtData()
        if data then 
            return data.Drawing
        end
    end

    local _RoleModel = TableDataManager:GetInstance():GetTableData("RoleModel", self.uiModelID)
    if _RoleModel then
        return _RoleModel.Drawing
    end
end

function InstRole:GetItemNum(uiItemTypeID)
    return ItemDataManager:GetInstance():GetItemNum(uiItemTypeID)
end

function InstRole:GetEquipItems()
    return self.akEquipItem or {}
end

function InstRole:GetEquipItemInfos()
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

function InstRole:GetMartials()
    local auiRoleMartials = self.auiRoleMartials or {}
    local auiTypeIds = {}
    local auiLvs = {}
    for i=0, getTableSize(auiRoleMartials)-1 do
        local kRoleMartial = MartialDataManager:GetInstance():GetMartialData(auiRoleMartials[i])
        if kRoleMartial then
            auiLvs[i] = kRoleMartial.uiLevel
            auiTypeIds[i] = kRoleMartial.uiTypeID
        end
    end
    return auiTypeIds,auiLvs
end

function InstRole:CureIsDemage()
    local auiRoleMartials = self.auiRoleMartials or {}
    local auiTypeIds = {}
    local auiLvs = {}
    for i=0, getTableSize(auiRoleMartials)-1 do
        local kRoleMartial = MartialDataManager:GetInstance():GetMartialData(auiRoleMartials[i])
        if kRoleMartial then
            if kRoleMartial.uiLevel >= 30 and kRoleMartial.uiTypeID == 10315 then 
                return true
            end
        end
    end
    return false
end

function InstRole:AnqiIsCure(MartialTypeData)
    local martialInst = RoleDataManager:GetInstance():GetMartialInstByTypeID(self.uiID,MartialTypeData.BaseID)
    if martialInst then
        local Level = martialInst.uiLevel
        if ANQI_IS_CURE_MARTIAL and ANQI_IS_CURE_MARTIAL[MartialTypeData.BaseID] and ANQI_IS_CURE_MARTIAL[MartialTypeData.BaseID] <= Level then 
            return true
        end
    end
    return false
end


function InstRole:GetAttr(sAttr)
    local eAttr
    if tonumber(sAttr) then 
        eAttr = sAttr
    else
        eAttr = RoleAttrTypeMap[sAttr]
    end
    return self['aiAttrs'][eAttr] or 0
end

function InstRole:GetGifts()
    local auiTypeIds = {}
    local auiRoleGift = self.auiRoleGift or {}
    local TB_Gift = TableDataManager:GetInstance():GetTable("Gift")
    for i=0, getTableSize(auiRoleGift)-1 do
        local kRoleGift = GiftDataManager:GetInstance():GetGiftData(auiRoleGift[i])
        if kRoleGift and TB_Gift[kRoleGift.uiTypeID] then
            if (TB_Gift[kRoleGift.uiTypeID].SurperType > 0 and kRoleGift.bIsGrowUp > 0) or (TB_Gift[kRoleGift.uiTypeID].SurperType == 0) then
                auiTypeIds[i] = kRoleGift.uiTypeID;
            end
        end
    end
    return auiTypeIds
end

function InstRole:GetAllGifts()
    local auiTypeIds = {}
    local auiRoleGift = self.auiRoleGift or {}
    local TB_Gift = TableDataManager:GetInstance():GetTable("Gift")
    for i=0, getTableSize(auiRoleGift)-1 do
        local kRoleGift = GiftDataManager:GetInstance():GetGiftData(auiRoleGift[i])
        if kRoleGift and TB_Gift[kRoleGift.uiTypeID] then
                auiTypeIds[i] = kRoleGift.uiTypeID;
        end
    end
    return auiTypeIds
end

function InstRole:GetLevel()
    return self['uiLevel'] or 1
end

function InstRole:GetClan()
    return self['uiClanID']
end

function InstRole:GetGoodEvil()
    return self['iGoodEvil']
end

-- 延迟到访问时才设置
function InstRole:IsMainRole()
    if self._isMainRole == nil then 
        self._isMainRole = (self.uiID == RoleDataManager:GetInstance():GetMainRoleID())
    end
    return self._isMainRole
end
function InstRole:GetModelID()
    return self.super.GetModelID(self)
end

function InstRole:GetWeaponTypeID()
    if self.akEquipItem then 
        local uid = self.akEquipItem[REI_WEAPON]
        if uid then 
            return ItemDataManager:GetInstance():GetItemTypeID(uid)
        end
    end
    return 0
end

function InstRole:GetEnchanceGrade()
    if self.akEquipItem then 
        local uid = self.akEquipItem[REI_WEAPON]
        if uid then 
            return ItemDataManager:GetInstance():GetItemEnhanceGrade(uid)
        end
    end
    return 0
end