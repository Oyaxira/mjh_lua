HighTowerDataManager = class("HighTowerDataManager")
HighTowerDataManager._instance = nil

function HighTowerDataManager:ctor()

end

function HighTowerDataManager:GetInstance()
    if HighTowerDataManager._instance == nil then
        HighTowerDataManager._instance = HighTowerDataManager.new()
        HighTowerDataManager._instance:ResetManager()
    end

    return HighTowerDataManager._instance
end

function HighTowerDataManager:ResetManager()
    self.baseInfo = nil
    self.restRoleMap = nil
end

function HighTowerDataManager:UpdateBaseInfo(retStream)
    self.baseInfo = retStream

    local toptitleUI = GetUIWindow("ToptitleUI")
    if toptitleUI then
        toptitleUI:UpdateNavLabel()
    end
end

function HighTowerDataManager:UpdateRestRoles(retStream)
    self.restRoleMap = {}
    
    for index = 0, retStream.iNum - 1 do
        self.restRoleMap[retStream.auiRestRoles[index]] = true
    end
end

function HighTowerDataManager:GetBaseInfo()
    return self.baseInfo
end

function HighTowerDataManager:CheckRestRole(iRoleID)
    if not self.restRoleMap or not self.restRoleMap[iRoleID] then
        return false
    else
        return true
    end
end

function HighTowerDataManager:EnterRegimentEmbattle()
    local embattleInfo = {}
    embattleInfo.bOpenByWheelWar = false
    embattleInfo.bOpenByFinalBattle = false
    embattleInfo.bOpenByHighTower = true

    OpenWindowImmediately("RoleEmbattleUI", embattleInfo)
end

function HighTowerDataManager:RegimentEmbattleOver(bSubmit)
    SendHighTowerEmbattleOver(bSubmit)
end

function HighTowerDataManager:GetConfig()
    return TableDataManager:GetInstance():GetTable("HighTowerConfig")[1]
end

function HighTowerDataManager:GetHighTowerBuildingDesc(mapID)
    local config = self:GetConfig()
    local baseInfo = self.baseInfo

    if not config or not baseInfo then
        return
    end

    local desc = nil

    if mapID == config.NormalBuilding then
        desc = GetLanguageByID(config.NormalMapDesc)
        desc = desc..string.format("\n<color=red>历史记录:%d</color>", baseInfo.uiNormalHistoryStage)
    elseif mapID == config.BloodBuilding then
        if baseInfo.bBloodUnlock >= 1 then
            desc = GetLanguageByID(config.BloodMapDesc)
            desc = desc..string.format("\n<color=red>历史记录:%d</color>", baseInfo.uiBloodHistoryStage)
        else
            desc = GetLanguageByID(config.BloodMapLockDesc)
        end
    elseif mapID == config.RegimentBuilding then
        if baseInfo.bRegimentUnlock >= 1 then
            desc = GetLanguageByID(config.RegimentMapDesc)
            desc = desc..string.format("\n<color=red>历史记录:%d</color>", baseInfo.uiRegimentHistoryStage)
        else
            desc = GetLanguageByID(config.RegimentMapLockDesc)
        end
    end

    return desc
end

function HighTowerDataManager:GetHighTowerMapName(mapID)
    local config = self:GetConfig()
    local baseInfo = self.baseInfo

    if not config or not baseInfo then
        return
    end

    local desc = nil

    if mapID == config.NormalMap then
        desc = string.format("普通模式-第%d层", baseInfo.uiNormalHistoryStage + 1)
    elseif mapID == config.BloodMap then
        desc = string.format("血斗模式-第%d层", baseInfo.uiCurBloodStage)
    elseif mapID == config.RegimentMap then
        desc = string.format("混战模式-第%d层", baseInfo.uiRegimentHistoryStage + 1)
    end


    -- 宇文千层塔
    local commonConfig = TableDataManager:GetInstance():GetTable("CommonConfig")[1]
    if commonConfig then
        local ywMapID = commonConfig.YWHighTowerMapID or 0
        local ywTagID = commonConfig.YWHighTowerMapNameTag or 0

        if mapID == ywMapID then
            local nameID = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(ywTagID)

            if nameID and nameID ~= 0 then
                desc = GetLanguageByID(nameID)
            end
        end
    end

    return desc
end

function HighTowerDataManager:IsInHighTowerMap()
    if GetGameState() ~= GS_NORMALMAP then
        return false
    end

    local uiCurMap = MapDataManager:GetInstance():GetCurMapID()

    local config = TableDataManager:GetInstance():GetTable("HighTowerConfig")[1]
    if config then
        if uiCurMap == config.NormalMap or uiCurMap == config.BloodMap or uiCurMap == config.RegimentMap then
            return true
        end
    end

    return false
end