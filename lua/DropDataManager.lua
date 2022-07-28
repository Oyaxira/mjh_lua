DropDataManager = class("DropDataManager")
DropDataManager._instance = nil

function DropDataManager:GetInstance()
    if DropDataManager._instance == nil then
        DropDataManager._instance = DropDataManager.new()
    end

    return DropDataManager._instance
end

function DropDataManager:InitDropCache()
    local TB_Drop = TableDataManager:GetInstance():GetTable("Drop")

    if TB_Drop == nil then
        return
    end

    self.dropCache = {}

    for baseID, dropData in pairs(TB_Drop) do
        local dropID = dropData.DropID
        if dropID and dropID ~= 0 then
            self.dropCache[dropID] = self.dropCache[dropID] or {}
            table.insert(self.dropCache[dropID], baseID)
        end
    end
end

function DropDataManager:GetDropBaseIDListByDropID(dropID)
    if self.dropCache == nil then
        self:InitDropCache()
    end

    if self.dropCache then
        return self.dropCache[dropID]
    end

    return nil
end

function DropDataManager:GetDropItemsByDropID(uiDropID, bFromZero)
    if (not uiDropID) or (uiDropID == 0) then
        return {}
    end
    local auiBaseIDs = self:GetDropBaseIDListByDropID(uiDropID)
    if (not auiBaseIDs) or (not next(auiBaseIDs)) then
        return {}
    end
    local kRet = {}
    local kDropBaseData = nil
    local kTableMgr = TableDataManager:GetInstance()
    local kItemMgr = ItemDataManager:GetInstance()
    local funcDealBaseID = function(uiBaseID)
        if (not uiBaseID) or (uiBaseID == 0) then
            return
        end
        kDropBaseData = kTableMgr:GetTableData("Drop", uiBaseID)
        if (not kDropBaseData) or (not kDropBaseData.DropDatas) 
        or (#kDropBaseData.DropDatas == 0) then
            return
        end
        local kItemBaseData = nil
        for index, kDropData in ipairs(kDropBaseData.DropDatas) do
            if kDropData.ItemTypes and (#kDropData.ItemTypes > 0) then
                for index, eItemType in ipairs(kDropData.ItemTypes) do
                    local akItems = kItemMgr:GetItemTypeDataByItemTypeAndKey(eItemType) or {}
                    for iBaseID, kBaseItem in pairs(akItems) do
                        kRet[#kRet + 1] = iBaseID
                    end
                end
            end
            if kDropData.ItemID and (kDropData.ItemID > 0) then
                kItemBaseData = kItemMgr:GetItemTypeDataByTypeID(kDropData.ItemID)
                if kItemBaseData then
                    kRet[#kRet + 1] = kDropData.ItemID
                end
            end
            if kDropData.MartialBook and (kDropData.MartialBook > 0) then
                kItemBaseData = kItemMgr:GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_SecretBook, kDropData.MartialBook)
                if kItemBaseData then
                    kRet[#kRet + 1] = kItemBaseData.BaseID
                end
            end
            if kDropData.MartialPage and (kDropData.MartialPage > 0) then
                kItemBaseData = kItemMgr:GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_IncompleteBook, kDropData.MartialPage)
                if kItemBaseData then
                    kRet[#kRet + 1] = kItemBaseData.BaseID
                end
            end
            if kDropData.RoleCard and (kDropData.RoleCard > 0) then
                kItemBaseData = kItemMgr:GetItemTypeDataByItemTypeAndKey(ItemTypeDetail.ItemType_RolePieces, kDropData.RoleCard)
                if kItemBaseData then
                    kRet[#kRet + 1] = kItemBaseData.BaseID
                end
            end
        end
    end
    for index, uiBaseID in ipairs(auiBaseIDs) do
        funcDealBaseID(uiBaseID)
    end
    if bFromZero then
        kRet[0] = kRet[#kRet]
        kRet[#kRet] = nil
    end
    return kRet
end