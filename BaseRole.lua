BaseRole = class("BaseRole")
function BaseRole:ctor(uiID,roleData)
    self.roleType = ROLE_TYPE.BASE_ROLE
    self.uiTypeID = roleData.uiTypeID
    self.uiID = uiID
    self._data = roleData
    self._dbData = TB_Role[roleData.uiTypeID]
end
function BaseRole:IsError()
    return false
end

function BaseRole:GetDBRole()
    return self._dbData
end

function BaseRole:GetType()
    return self.roleType
end

function BaseRole:GetDBBag()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.Bag or {}
    end
end

function BaseRole:GetInstRole()
    return nil
end

function BaseRole:IsInstRole()
    return self.roleType == ROLE_TYPE.INST_ROLE
end

function BaseRole:GetDBKungfu()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.Kungfu or {}
    end
    return {}
end

function BaseRole:GetDBKungfuLevel()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.KungfuLevel or 1
    end
    return 1
end

function BaseRole:GetDBLevel()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.Level or 1
    end
    return 1
end

function BaseRole:GetDBClan()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.Clan
    end
end

function BaseRole:GetDBFavor()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.Favor
    end
end

function BaseRole:GetDBDisposition()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.Disposition or 0
    end
    return 0
end

function BaseRole:GetDBGift()
    local dbRole = self:GetDBRole()
    if dbRole then 
        return dbRole.Gift or {}
    end
    return {}
end

function BaseRole:GetDBDrawing()
    local dbRole = self:GetDBRole()
    if dbRole and dbRole.ArtID and dbRole.ArtID > 0 then
        local _RoleModel = TableDataManager:GetInstance():GetTableData("RoleModel", dbRole.ArtID)
        if _RoleModel then
            return _RoleModel.Drawing
        end
    end
end

function BaseRole:GetDBHead()
    local dbRole = self:GetDBRole()
    if dbRole.ArtID and dbRole.ArtID > 0 then
        local _RoleModel = TableDataManager:GetInstance():GetTableData("RoleModel", dbRole.ArtID)
        if _RoleModel then
            return _RoleModel.Head
        end
    end
end

function BaseRole:GetBagItems()
    return {}
end

function BaseRole:GetItemNum(uiItemTypeID)
    return 0
end

function BaseRole:GetEquipItems()
    return {}
end

function BaseRole:GetMartials()
    return {}
end

function BaseRole:GetLevel()
    return 1
end

function BaseRole:GetClan()
    if self._dbData then
        return self._dbData.Clan or 0
    end
    return 0
end

function BaseRole:GetFavors()
    return self:GetDBFavors()
end

function BaseRole:GetGoodEvil()
    return 0
end

function BaseRole:GetAttr(sAttr)
    local dbRole = self:GetDBRole()
    local kData = TableDataManager:GetInstance():GetTableData("RoleAttr", dbRole.AttributeID)
    local arrtData = kData or {}
    return arrtData[sAttr] or 0
end

function BaseRole:GetGifts()
    return {}
end

function BaseRole:GetDrawing()
    local modelID = self:GetModelID()
    if modelID then
        local modelData = TableDataManager:GetInstance():GetTableData("RoleModel", modelID)
        if modelData then
            return modelData.Drawing
        end
    end

    return self:GetDBDrawing()
end

function BaseRole:GetName()
    if self.uiID ~= nil and self.uiID ~= 0 then 
        return RoleDataManager:GetInstance():GetRoleTitleAndName(self.uiID)
    else
        return RoleDataManager:GetInstance():GetRoleTitleAndName(self.uiTypeID, true)
    end
end

function BaseRole:GetRoleRank()
    local irank = 0
    if self.uiID ~= nil and self.uiID ~= 0 then 
        return RoleDataManager:GetInstance():GetRoleRank(self.uiID)
    else
        if (self._dbData) then
            irank =  self._dbData.Rank  
        end
    end
    irank = irank + CardsUpgradeDataManager:GetInstance():GetRoleExRankByRoleID(self.uiTypeID)
    return irank
end

function BaseRole:GetOverlayLevel()
    if self.uiID ~= nil and self.uiID ~= 0 then 
        return RoleDataManager:GetInstance():GetRoleOverlayLevel(self.uiID)
    else
        return RoleDataManager:GetInstance():GetRoleOverlayLevelByBaseID(self.uiTypeID)
    end
    return 0
end

function BaseRole:GetModelID()
    local roleModelData = nil
    if self.uiID ~= nil and self.uiID ~= 0 then 
        roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByID(self.uiID)
    elseif self.uiTypeID ~= nil and self.uiTypeID ~= 0 then 
        roleModelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(self.uiTypeID)
    end

    if roleModelData == nil then 
        return 0
    end

    return roleModelData.BaseID
end

function BaseRole:GetIdleAnimName()
    return ROLE_SPINE_DEFAULT_ANIM
end

function BaseRole:GetWeaponTypeID()
    return 0
end

function BaseRole:SetOldWeapon(weaponID)
    self.oldWeaponID = weaponID
end

function BaseRole:GetEnchanceGrade()
    return 0
end

function BaseRole:GetObserveGifts()
    return self:GetGifts()
end