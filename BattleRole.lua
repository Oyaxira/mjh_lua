-- TODO:和unit合并
BattleRole = class("BattleRole",BaseRole)
function BattleRole:ctor(uiID,roleData)
    self.roleType = ROLE_TYPE.BATTLE_ROLE
    self._uiInstRoleID = roleData.uiRoleID 
    self.uiRank = 1
    self.uiEatFoodNum = 1
end

function BattleRole:GetItemNum(uiItemTypeID)
    return ItemDataManager:GetInstance():GetItemNum(uiItemTypeID)
end

function BattleRole:GetInstRole()
    if LogicMain:GetInstance():IsArenaBattle() or GetGameState() == -1 then
        return nil
    end
    if self._uiInstRoleID ~= 0 then 
        local instRoleData = RoleDataManager:GetInstance():GetRoleData(self._uiInstRoleID)
        return instRoleData
    end
    return nil
end

function BattleRole:GetEquipItemInfos()
    local infos = {}
    if self._data.akEquipItem then
        for equips, info in pairs(self._data.akEquipItem) do
            infos[equips] = info
        end
    end

    return infos
end

function BattleRole:GetMartialData()
    return  self.akMartialData
end

function BattleRole:GetMartials()
    local instRole = self:GetInstRole()
    if instRole then 
        return instRole:GetMartials()
    end
    local auiTypeIds = {}
    local auiLvs = {}
    local MartialData = self._data:GetMartialData()
    local i = 0
    local noShowMap = { [12209] = true, [12206] = true, [12207] = true, [12208] = true, [12205] = true }
    for k,kRoleMartial in pairs(MartialData) do
        if  noShowMap[kRoleMartial.iMartialID] == nil then
            auiLvs[i] = kRoleMartial.iMartialLevel
            auiTypeIds[i] = kRoleMartial.iMartialID
            i = i + 1
        end
    end
    return auiTypeIds,auiLvs
end

function BattleRole:GetAttr(attr,bIsEnum)
    if bIsEnum then
        return self._data['aiAttrs'][attr]
    end
    if attr == "HP" then 
        attrvalue = self._data:GetHP()
    elseif attr == "MP" then 
        attrvalue = self._data:GetMP()
    else
        local eAttr = RoleAttrTypeMap[attr]
        attrvalue = self._data['aiAttrs'][eAttr]
    end
    return attrvalue or 0
end

function BattleRole:GetGifts()
    local instRole = self:GetInstRole()
    if instRole then 
        return instRole:GetGifts()
    end
    return self._data:GetGifts()
end

function BattleRole:GetDrawing()
    return self._data:GetDrawing()
end

function BattleRole:GenName(unit)
    if LogicMain:GetInstance():IsReplaying() and ARENA_PLAYBACK_DATA then
        if MAINROLE_TYPE_ID == self.uiTypeID then 
            local sname;
            if unit:IsEnemy() then 
                sname = LogicMain:GetInstance():GetEnemyName();
            else
                sname = LogicMain:GetInstance():GetFriendName();
            end
            return sname
        else
            local roleTypeData = TB_Role[self.uiTypeID]
            if type(roleTypeData) == 'table' then 
                name = GetLanguageByID(roleTypeData.NameID)
            end
            return name
        end
    end
    local instRole = self:GetInstRole()
    if instRole then 
        return instRole:GetName()
    end
    return RoleDataHelper.GetName(unit, self._dbData)
end

function BattleRole:GetName()
    local instRole = self:GetInstRole()
    if instRole then 
        return instRole:GetName()
    end
    return self._data:GetName()
end

function BattleRole:GetLevel()
    return self._data.uiLevel or 1
end

function BattleRole:GetGoodEvil()
    return self._data.iGoodEvil or 0
end

function BattleRole:GetClan()
    return self._data.iClan or 0
end

function BattleRole:GetRoleRank()
    local instRole = self:GetInstRole()
    if instRole then 
        return instRole:GetRoleRank()
    end
    return self._data.iRank or 0
end

function BattleRole:GetModelID()
    -- local instRole = self:GetInstRole()
    -- if instRole then 
    --     return instRole:GetModelID()
    -- end
    return self._data.uiModleID or 0
end

function BattleRole:GetIdleAnimName()
    local itemID = self:GetWeaponTypeID()
    if itemID == 0 then 
        itemID = self.oldWeaponID or 0
    end
    local prepareName
    if itemID and itemID ~= 0 then
        local itemData = TableDataManager:GetInstance():GetTableData("Item",itemID)
        if itemData then 
            prepareName = ItemTypeToPrepareMap[itemData.ItemType]
        end
    end
    return prepareName or SPINE_ANIMATION.BATTLE_IDEL
end

function BattleRole:GetWeaponTypeID(spineAnimInfo)
    local akEquipItemInfos = self:GetEquipItemInfos()
    local ans = 0
    if akEquipItemInfos and akEquipItemInfos[REI_WEAPON] then
        local itemID = akEquipItemInfos[REI_WEAPON].iInstID or 0
        local typeID = 0  
        -- 根据武器是否有动态id来获取静态id
        if itemID == 0 then
            typeID = akEquipItemInfos[REI_WEAPON].iTypeID
        else
            typeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
        end
        ans = typeID
    end

    if (ans == nil or ans == 0 ) and spineAnimInfo then 
        if spineAnimInfo.action ~= SPINE_ANIMATION.BATTLE_IDEL and spineAnimInfo.type then 
            ans = SPINE_ANIM_DEFAULT_ITEM[spineAnimInfo.type]
        else
            ans = self.oldWeaponID or 0
        end
    end
    return ans
end


function BattleRole:GetEnchanceGrade()
    local ans = 0
    local akEquipItemInfos = self:GetEquipItemInfos()
    if akEquipItemInfos and akEquipItemInfos[REI_WEAPON] then
        ans = self._data.akEquipItem[REI_WEAPON].iEnhanceGrade
    end
    return ans
end