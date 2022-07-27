FinalBattleDataManager = class("FinalBattleDataManager")
FinalBattleDataManager._instance = nil

function FinalBattleDataManager:ctor()

end

function FinalBattleDataManager:GetInstance()
    if FinalBattleDataManager._instance == nil then
        FinalBattleDataManager._instance = FinalBattleDataManager.new()
    end

    return FinalBattleDataManager._instance
end

function FinalBattleDataManager:ResetManager()
    self.bIsNeedUpdateUI = nil
end

function FinalBattleDataManager:IsOpen()
    local info = self:GetInfo()

    if info and info.uiState ~= FBS_NULL then
        return true
    end

    return false
end

function FinalBattleDataManager:IsRunning()
    local info = self:GetInfo()

    if info and info.uiState == FBS_RUNNING then
        return true
    end

    return false
end

function FinalBattleDataManager:IsEvilFinalBattle()
    local config = TableDataManager:GetInstance():GetTableData("FinalBattleConfig",1)
    if not config or not config.EvilModeTag then
        return false
    end

    return TaskTagManager:GetInstance():TagIsValue(config.EvilModeTag, 1)
end

function FinalBattleDataManager:IsNeedUpdateUI()
    return self.bIsNeedUpdateUI == true
end

function FinalBattleDataManager:SetNeedUpdateUI(isNeed)
    self.bIsNeedUpdateUI = isNeed
end

function FinalBattleDataManager:CheckRestRole(iRoleID)
    local info = self:GetInfo()

    if info then
        for index = 0, getTableSize(info.auiRestTeammatesIDs) - 1 do
            if iRoleID == info.auiRestTeammatesIDs[index] then
                return true
            end
        end
    end

    return false
end

function FinalBattleDataManager:UpdateInfo(retStream)
    globalDataPool:setData("FinalBattleInfo", retStream, true)
    self:SetNeedUpdateUI(true)
end

function FinalBattleDataManager:UpdateCityInfo(retStream)
    local finalBattleCitys = globalDataPool:getData("FinalBattleCityInfos") or {}
    local uiFinalBattleCityTypeID = retStream.uiFinalBattleCityID

    finalBattleCitys[uiFinalBattleCityTypeID] = retStream

    globalDataPool:setData("FinalBattleCityInfos", finalBattleCitys)

    self:SetNeedUpdateUI(true)
end

function FinalBattleDataManager:GetInfo()
    return globalDataPool:getData("FinalBattleInfo")
end

function FinalBattleDataManager:GetCityInfo(uiFBCityID)
    local cityInfos = globalDataPool:getData("FinalBattleCityInfos") or {}

    return cityInfos[uiFBCityID]
end

function FinalBattleDataManager:GetCityInfos()
    local cityInfos = globalDataPool:getData("FinalBattleCityInfos") or {}

    return cityInfos
end

function FinalBattleDataManager:EnterCityEmbattle(uiFinalBattleCityID, isInCity)
    if not self:IsRunning() then
        return
    end

    local embattleInfo = {}
    embattleInfo.bOpenByWheelWar = false
    embattleInfo.bOpenByFinalBattle = true
    embattleInfo.data = {}

    embattleInfo.data.uiFinalBattleCityID = uiFinalBattleCityID
    embattleInfo.data.bInCity = isInCity
    embattleInfo.data.auiRestRole = {}


    OpenWindowImmediately("RoleEmbattleUI", embattleInfo)
end