ZmWatchRole = class("ZmWatchRole", NPCRole)

function ZmWatchRole:ctor(uiID, roleData)
    self.equipLevel = roleData["equipLevel"]
    self.equipID = roleData["equipID"]
    self.throneLevel = roleData["throneLevel"]

    -- 强制设为npcrole
    self.roleType = ROLE_TYPE.NPC_ROLE

    self.super:UpdateNPCRoleInfo(roleData)
end

-- TODO: 还没设置装备等级
-- 获取所有装备信息
function ZmWatchRole:GetEquipItemInfos()
    local infos = {}

    local dbRole = self:GetDBRole()

    if dbRole.Ornaments and dbRole.Ornaments > 0 then
        infos[REI_WEAPON] = {
            iTypeID = dbRole.Weapon,
            eState = NSIS_EQUIP
        }
    end

    if dbRole.Ornaments and dbRole.Ornaments > 0 then
        infos[REI_CLOTH] = {
            iTypeID = dbRole.Clothes,
            eState = NSIS_EQUIP
        }
    end

    if dbRole.Ornaments and dbRole.Ornaments > 0 then
        infos[REI_SHOE] = {
            iTypeID = dbRole.Shoe,
            eState = NSIS_EQUIP
        }
    end

    if dbRole.Ornaments and dbRole.Ornaments > 0 then
        infos[REI_JEWELRY] = {
            iTypeID = dbRole.Ornaments,
            eState = NSIS_EQUIP
        }
    end

    if self.equipID and self.equipID > 0 then
        infos[REI_THRONE] = {
            iTypeID = self.equipID,
            eState = NSIS_EQUIP
        }
    end

    return infos
end

-- 获取Npc背包表配置物品 map : typeid - num
function ZmWatchRole:GetBagStaticItems()
    return {}
end

function ZmWatchRole:GetAttr(sAttr)
    return self.super.GetAttr(self.super, sAttr)
end

function ZmWatchRole:GetDrawing()
    return self:GetDBDrawing()
end

return ZmWatchRole
