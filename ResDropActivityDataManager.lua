ResDropActivityDataManager = class("ResDropActivityDataManager")
ResDropActivityDataManager._instance = nil

function ResDropActivityDataManager:GetInstance()
    if ResDropActivityDataManager._instance == nil then
        ResDropActivityDataManager._instance = ResDropActivityDataManager.new()
    end

    return ResDropActivityDataManager._instance
end

-- 清空缓存
function ResDropActivityDataManager:Clear()
    self.iCurResDropCollectActivityID = nil
    self.kIndex2ItemID = nil
    self.bHasRequestResDropCollect = nil
end

-- 设置当前活动id
function ResDropActivityDataManager:SetCurResDropCollectActivityID(uiActivityID)
    if (not uiActivityID) or (uiActivityID == 0) then
        return
    end
    if self.iCurResDropCollectActivityID == uiActivityID then
        return
    end
    self.iCurResDropCollectActivityID = uiActivityID
    self:SetResDropActivityFuncValueItemID(uiActivityID)
end

-- 获取当前活动id
function ResDropActivityDataManager:GetCurResDropCollectActivityID()
    return self.iCurResDropCollectActivityID
end

-- 获取当前活动名称
function ResDropActivityDataManager:GetCurResDropCollectActivityName()
    if (not self.iCurResDropCollectActivityID) or (self.iCurResDropCollectActivityID == 0) then
        return ""
    end
    local uiActivityID = self.iCurResDropCollectActivityID
    if not self.kNameCache then
        self.kNameCache = {}
    end
    if not self.kNameCache[uiActivityID] then
        local strName = ""
        local kActivity = TableDataManager:GetInstance():GetTableData("ResDropActivity", uiActivityID)
        if kActivity and kActivity.NameID then
            strName =  GetLanguageByID(kActivity.NameID) or ""
        end
        self.kNameCache[uiActivityID] = strName
    end
    return self.kNameCache[uiActivityID] or ""
end

-- 通过物品 使用类型 [修改游戏数值] [游戏数据] 中的游戏数据类型来获取对应的资产值
function ResDropActivityDataManager:GetAssetValueByGameDataType(eGameDataType)
    if (not eGameDataType) or (eGameDataType == GameData.GD_GameDateNull) then
        return 0
    end
    local eBaseType = GameData.GD_ResDropActivityValue1
    local iIndex = eGameDataType - eBaseType + 1
    if iIndex <= 0 then
        return 0
    end
    return PlayerSetDataManager:GetInstance():GetResDropActivityFuncValue(iIndex) or 0
end

-- 通过活动id查找当前活动对应的物品id
function ResDropActivityDataManager:SetResDropActivityFuncValueItemID(uiActivityID)
    if self.kIndex2ItemID and (self.kIndex2ItemID.uiActivityID == uiActivityID) then
        return
    end
    if (not uiActivityID) or (uiActivityID == 0) then
        return
    end
    local kTableMgr = TableDataManager:GetInstance()
    local kActivityBaseData = kTableMgr:GetTableData("ResDropActivity", uiActivityID)
    if not kActivityBaseData then
        return
    end
    local aiExtraIDs = kActivityBaseData.ExtraInfoGroup or {}
    local kDBCollectTask = kTableMgr:GetTable("CollectActivity")
    local kDBItem = kTableMgr:GetTable("Item")
    local kIndex2ItemID = {}
    for index, uiCollectTaskID in ipairs(aiExtraIDs) do
        local kCollectTaskData = kDBCollectTask[uiCollectTaskID]
        if kCollectTaskData then
            local aiItemIDs = kCollectTaskData.TarItemIDs or {}
            for _, ItemBaseID in ipairs(aiItemIDs) do
                local kItemBaseData = kDBItem[ItemBaseID]
                if kItemBaseData and kItemBaseData.GameData
                and (kItemBaseData.GameData ~= GameData.GD_GameDateNull)
                and (kItemBaseData.GameData >= GameData.GD_ResDropActivityValue1) then
                    local iIndex = kItemBaseData.GameData - GameData.GD_ResDropActivityValue1 + 1
                    kIndex2ItemID[iIndex] = ItemBaseID
                end
            end
        end
    end
    self.kIndex2ItemID = kIndex2ItemID
    self.kIndex2ItemID.uiActivityID = uiActivityID
end

-- 获取资源掉落活动资产值的物品
function ResDropActivityDataManager:GetResDropActivityFuncValueItemID(iIndex)
    if not self.kIndex2ItemID then
        return
    end
    return self.kIndex2ItemID[iIndex] or 0
end

-- 请求一次收集活动数据
function ResDropActivityDataManager:RequestResDropCollectActivityOnce()
    -- if GetCurScriptID() ~= self.uiCurStoryID then
    --     self.bHasRequestResDropCollect = nil
    -- end
    -- if self.bHasRequestResDropCollect then
    --     return
    -- end
    -- self.uiCurStoryID = GetCurScriptID()
    SendRequestQueryResDropActivityInfo(EN_QUERY_RESDROP_ACTIVITY_COLLECT)
    -- self.bHasRequestResDropCollect = true
end

-- 重置 请求一次收集活动数据 标记
function ResDropActivityDataManager:ResetResDropCollectActivityOnceFlag()
    self.bHasRequestResDropCollect = false
end