CollectionDataManager = class('CollectionDataManager');
CollectionDataManager._instance = nil;

local displayTable = {
    [12199] = true,
    [12189] = true,
    [12190] = true,
    [12191] = true,
    [12192] = true,
    [12193] = true,
    [12194] = true,
    [12195] = true,
}
local BaseLevelLimitUp = 10


function CollectionDataManager:GetInstance()
    if CollectionDataManager._instance == nil then
        CollectionDataManager._instance = CollectionDataManager.new();
        CollectionDataManager._instance:Init();
    end

    return CollectionDataManager._instance;
end

function CollectionDataManager:Init()
    self.martialData = {};
    self.allMartialData = {};
    self.aiCollectionPoint ={}
    local TB_CollectionPoint = TableDataManager:GetInstance():GetTable("CollectionPoint")
    self.map_colpoint = {}
    if TB_CollectionPoint then 
        for i,line in pairs (TB_CollectionPoint) do 
            local etype = line.CollectionType
            self.map_colpoint[etype] = {line.Point1,line.Point2,line.Point3,line.Point4,line.Point5,line.Point6,line.Point7}
        end 
    end
    self.CGTestMode = false
end
function CollectionDataManager:SetPointsDetails(aiCollectionPoint)
    self.aiCollectionPoint = aiCollectionPoint or {}
    LuaEventDispatcher:dispatchEvent("UPDATE_COLLECTION_POINT")
end
function CollectionDataManager:GetPointsDetails()
    return self.aiCollectionPoint or {}
end
function CollectionDataManager:GetPointByCollectionType(eCollectionType)
    return self.aiCollectionPoint[eCollectionType] or 0
end

function CollectionDataManager:GetPointMaxByCollectionType(eCollectionType)
    -- ["角色"] = CollectionType.CLT_ROLE
    -- ["宠物"] = CollectionType.CLT_PET
    -- ["武学"] = CollectionType.CLT_MARTIAL
    -- ["门派"] = CollectionType.CLT_CLAN
    -- ["配方"] = CollectionType.CLT_FORGE
    -- ["传家宝"] = CollectionType.CLT_HEIR
    -- ["插画"] = CollectionType.CLT_CG
    -- ["漫画"] = CollectionType.CLT_COMIC
    local ret 
    if eCollectionType == CollectionType.CLT_ROLE then 
        ret =  self:GetMaxPoint_RoleCard(eCollectionType)
    elseif eCollectionType == CollectionType.CLT_PET then 
        ret =  self:GetMaxPoint_PetCard(eCollectionType)
    elseif eCollectionType == CollectionType.CLT_MARTIAL then 
        ret =  self:GetMaxPoint_Martial(eCollectionType)
    elseif eCollectionType == CollectionType.CLT_CLAN then 
        ret =  self:GetMaxPoint_Clan(eCollectionType)
    elseif eCollectionType == CollectionType.CLT_FORGE then 
        ret =  self:GetMaxPoint_Forge(eCollectionType)
    elseif eCollectionType == CollectionType.CLT_HEIR then 
        ret =  self:GetMaxPoint_Heir(eCollectionType)
    elseif eCollectionType == CollectionType.CLT_CG then 
        ret =  self:GetMaxPoint_CG(eCollectionType)
    elseif eCollectionType == CollectionType.CLT_COMIC then 
        ret =  self:GetMaxPoint_Comic(eCollectionType)
    end 

    return ret or '~'
end
function CollectionDataManager:GetMaxPoint_RoleCard()
    -- 角色卡：SUM1->可收藏角色数（品质对应分数*最大修行等级）
    if not self.data_Max_RoleCard then 
        local MMAP = self.map_colpoint[CollectionType.CLT_ROLE]
        if not MMAP then return end 
        self.data_Max_RoleCard = 0
        local TB_RoleCard = TableDataManager:GetInstance():GetTable("RoleCard")
        local iAll = 0
        local maprole = {}
        for i ,line in pairs(TB_RoleCard) do 
            iRoleID = line.RoleID
            if iRoleID and not maprole[iRoleID] and TB_Role[iRoleID]  then 
                self.data_Max_RoleCard = self.data_Max_RoleCard + (MMAP[TB_Role[iRoleID].Rank] or 0) * 10
                maprole[iRoleID] = true
            end 
        end 
    end 
    return self.data_Max_RoleCard 
end
function CollectionDataManager:GetMaxPoint_PetCard()
    -- 宠物卡：SUM1->可收藏宠物数（品质对应分数*最大修行等级），包括所有分支的
    if not self.data_Max_PetCard then 
        local MMAP = self.map_colpoint[CollectionType.CLT_PET]
        if not MMAP then return end 
        self.data_Max_PetCard = 0
        local TB_Pet = TableDataManager:GetInstance():GetTable("Pet")
        local iAll = 0
        for i ,line in pairs(TB_Pet) do 
            if line.Chain and #line.Chain > 0 then 
                self.data_Max_PetCard = (MMAP[line.Rank] or 0) * 5 + self.data_Max_PetCard
            else 
                self.data_Max_PetCard = (MMAP[line.Rank] or 0) * 10 + self.data_Max_PetCard
            end 
        end 
    end 
    return self.data_Max_PetCard 
end
function CollectionDataManager:GetMaxPoint_Martial(eCollectionType)
    -- 武学：SUM1->可收藏武学数（品质对应分数*20级）
    if not self.data_Max_Martial then 
        local MMAP = self.map_colpoint[eCollectionType]
        if not MMAP then return end 
        self.data_Max_Martial = 0

        local TB_MartialData = TableDataManager:GetInstance():GetTable("Martial")
        if TB_MartialData then 
            for i,line in pairs(TB_MartialData) do 
                if line.Display == TBoolean.BOOL_YES then 
                    local Rank = line.Rank
                    self.data_Max_Martial = self.data_Max_Martial + (MMAP[Rank] or 0) * 20
                end
            end 
        end 
    end 
    return self.data_Max_Martial 
end
function CollectionDataManager:GetMaxPoint_Clan(eCollectionType)
    -- 门派：可收藏门派数*分数
    if not self.data_Max_Clan then 
        local MMAP = self.map_colpoint[eCollectionType]
        if not MMAP then return end 
        self.data_Max_Clan = 0

        local TB_Clan = TableDataManager:GetInstance():GetTable("Clan")
        if TB_Clan then 
            for i,line in pairs(TB_Clan) do 
                if line.ClanLock ~= ClanLock.CLL_NeverJoin then 
                    local Rank = line.Rank
                    self.data_Max_Clan = self.data_Max_Clan + (MMAP[Rank] or 0) 
                end 
            end 
        end 
    end 
    return self.data_Max_Clan 
end
function CollectionDataManager:GetMaxPoint_Forge(eCollectionType)
    -- 配方：SUM1->可收藏配方数（品质对应分数）
    if not self.data_Max_Forge then 
        local MMAP = self.map_colpoint[eCollectionType]
        if not MMAP then return end 
        self.data_Max_Forge = 0

        local TB_Item = TableDataManager:GetInstance():GetTable("Item") or {}
        local TB_ForgeMake = TableDataManager:GetInstance():GetTable("ForgeMake") or {}
        if TB_ForgeMake then 
            for i,line in pairs(TB_ForgeMake) do 
                local item =  TB_Item[line.TargetItemID or 0] 
                if item and line.IsInvisible ~= TBoolean.BOOL_YES then 
                    local Rank = item and item.Rank
                    self.data_Max_Forge = self.data_Max_Forge + (MMAP[Rank] or 0) 
                end 
            end 
        end

    end 
    return self.data_Max_Forge 
end
function CollectionDataManager:GetMaxPoint_Heir(eCollectionType)
    -- 传家宝：SUM1->可收藏传家宝数（品质对应分数）
    if not self.data_Max_Heir then 
        local MMAP = self.map_colpoint[eCollectionType]
        if not MMAP then return end 
        self.data_Max_Heir = 0

        local TB_Item = TableDataManager:GetInstance():GetTable("Item") or {}
        if TB_Item then 
            for i,line in pairs(TB_Item) do 
                if line.ClanTreasure ~= 0 or line.PersonalTreasure ~= 0 then 
                    if not (line.OrigItemID~= 0 and line.OrigItemID ~= line.BaseID) then
                        local Rank = line and line.Rank
                        self.data_Max_Heir = self.data_Max_Heir + (MMAP[Rank] or 0) 
                    end
                end 
            end 
        end
    end 
    return self.data_Max_Heir 
end
function CollectionDataManager:GetMaxPoint_CG(eCollectionType)
    -- CG：可收藏CG数*分数
    if not self.data_Max_CG then 
        local MMAP = self.map_colpoint[eCollectionType]
        if not MMAP then return end 
        self.data_Max_CG = 0        
        local TB_ResourceCG = TableDataManager:GetInstance():GetTable("ResourceCG") or {}
        if TB_ResourceCG then 
            for i,line in pairs(TB_ResourceCG) do 
                if line.CGType == CGType.CGT_CG then 
                    self.data_Max_CG = self.data_Max_CG + (MMAP[1] or 0)
                end 
            end 
        end 

    end 
    return self.data_Max_CG 
end
function CollectionDataManager:GetMaxPoint_Comic(eCollectionType)
    -- 漫画：可收藏漫画数*分数
    if not self.data_Max_Comic then 
        local MMAP = self.map_colpoint[eCollectionType]
        if not MMAP then return end 
        self.data_Max_Comic = 0

        local TB_ResourceCG = TableDataManager:GetInstance():GetTable("ResourceCG") or {}
        local mapcomic = {}
        if TB_ResourceCG then 
            for i,line in pairs(TB_ResourceCG) do 
                if line.CGType == CGType.CGT_Comic and not  mapcomic[line.ComicIndex] then 
                    self.data_Max_Comic = self.data_Max_Comic + (MMAP[1] or 0)
                    mapcomic[line.ComicIndex] = true 
                 end 
            end 
        end 
    end 
    return self.data_Max_Comic 
end

function CollectionDataManager:GetMartialNum(type)
    local sum = 0;
    local typeSum = 0;
    local TB_Martial = TableDataManager:GetInstance():GetTable("Martial");
    for k, v in pairs(TB_Martial) do
        if (v.Display == TBoolean.BOOL_YES) or (displayTable[v.BaseID]) then
            sum = sum + 1;
            if type == v.DepartEnum then
                typeSum = typeSum + 1;
            end
        end
    end
    return typeSum, sum;
end

function CollectionDataManager:GetMartialData(index, isAll)
    
    local UnlockPool = globalDataPool:getData("UnlockPool") or {};
    local incompleteBookData = UnlockPool[PlayerInfoType.PIT_INCOMPLETE_BOOK];

    if not incompleteBookData then
        return nil;
    end

    local data = {};
    for k, v in pairs(incompleteBookData) do
        local martialData = GetTableData("Martial",v.dwTypeID)
        if (martialData.Display == TBoolean.BOOL_YES) or (displayTable[martialData.BaseID]) then
            local temp = {};
            temp.martialData = martialData;
            temp.level = v.dwParam;

            if not data[martialData.DepartEnum] then
                data[martialData.DepartEnum] = {};            
            end
            table.insert(data[martialData.DepartEnum], temp);
        end
    end

    local KungfuType = {
        '所有',
        '拳掌',
        '剑法',
        '刀法',
        '腿法',
        '暗器',
        '奇门',
        '内功',
        '轻功',
        '医术',
        '阵法',
    }

    local _sort = function(typeA, typeB)

        if typeA.martialData and typeB.martialData then
            -- 品质
            if typeA.martialData.Rank and typeB.martialData.Rank and (typeA.martialData.Rank == typeB.martialData.Rank) then
    
                -- 等级
                if typeA.level == typeB.level then
    
                    -- 系别
                    if typeA.martialData.DepartEnum == typeB.martialData.DepartEnum then
                        return typeA.martialData.BaseID > typeB.martialData.BaseID;
    
                    elseif typeA.martialData.DepartEnum == DepartEnumType.DET_Soul then
                        return true;
    
                    elseif typeB.martialData.DepartEnum == DepartEnumType.DET_Soul then
                        return false;
    
                    else
                        return typeA.martialData.DepartEnum < typeB.martialData.DepartEnum;
    
                    end
                end
    
                return typeA.level > typeB.level;
    
            elseif typeA.martialData.Rank and typeB.martialData.Rank and typeA.martialData.Rank ~= typeB.martialData.Rank then
                return typeA.martialData.Rank > typeB.martialData.Rank;
    
            elseif (not typeA.martialData.Rank) and (not typeB.martialData.Rank) then
                return typeA.martialData.uiTypeID > typeB.martialData.uiTypeID;
    
            else
                return typeB.martialData.Rank == nil;
    
            end
        end
        
        return false;
    end
    
    for k, v in pairs(data) do
        table.sort(v, _sort);
    end

    local temp = {};
    for i = 2, #(KungfuType) do
        local revert = DepartEnumType_Revert[KungfuType[i]];
        if data[revert] then
            table.move(data[revert], 1, #(data[revert]), #(temp) + 1, temp);
        end
    end

    table.sort(temp, _sort);

    self.martialData = data;
    self.allMartialData = temp;

    return isAll == true and temp or data[index];
end

function CollectionDataManager:GetAllMartialData()
    return self.allMartialData;
end

function CollectionDataManager:GetSingleMartialData(index)
    return self.martialData[index];
end

function CollectionDataManager:ResetAllMartialScreenList()
    self.rankChooseList = {["All"]=true}
    self.levelChooseList = {["All"]=true}
    self.clanChooseList = {["All"]=true}
    self.typeChooseList = {["All"]=true}
end

function CollectionDataManager:GetMartialScreenList(index)
    -- index 1 品质list 2 等级list 3门派list
    if index == 1 then 
        return self.rankChooseList 
    elseif index == 2 then
        return self.levelChooseList
    elseif index == 3 then
        return self.clanChooseList
    else
        return self.typeChooseList
    end
end

function CollectionDataManager:SetMartialScreenList(index,list)
    -- index 1 品质list 2 等级list 3门派list
    --self.rankChooseList self.levelChooseList self.clanChooseList

end

-- 检查武学是否符合目前的筛选条件
function CollectionDataManager:CheckScreen(martialInfo)
    local KungfuType = {
        '拳掌',
        '剑法',
        '刀法',
        '腿法',
        '暗器',
        '奇门',
        '内功',
        '轻功',
        '医术',
        '阵法',
    }
    --类别
    if self.typeChooseList then
        local typeChoose = false
        for k,v in pairs (self.typeChooseList) do
            if (k == "All" or (DepartEnumType_Revert[KungfuType[tonumber(k)]] == martialInfo.martialData.DepartEnum)) and v then
                typeChoose = true
                break
            end    
        end
        if not typeChoose then
            return false
        end
    end
    -- 品质
    if self.rankChooseList then
        local rankChoose = false
        for k,v in pairs (self.rankChooseList) do
            if (k == "All" or (tonumber(k) == martialInfo.martialData.Rank)) and v then
                rankChoose = true
                break
            end    
        end
        if not rankChoose then
            return false
        end
    end
    -- 等级
    -- levelChooseList为空则表示没有对等级进行筛选
    if self.levelChooseList then
        local levelChoose = false
        for k,v in pairs (self.levelChooseList) do
            if (k == "All" and v) then
                levelChoose = true
                break
            end
            if (v) then
                if (k == "1" and martialInfo.level + BaseLevelLimitUp >=20) then
                    levelChoose = true
                    break
                end
                if (k == "2" and martialInfo.level  + BaseLevelLimitUp <20) then
                    levelChoose = true
                    break
                end
            end
        end
        if not levelChoose then
            return false
        end
    end
    
    -- 门派
    -- clanChooseList为空则表示没有对门派进行筛选
    if self.clanChooseList then 
        local clanChoose = false
        for k,v in pairs (self.clanChooseList) do
            if v and (k == "All" or tonumber(k) == martialInfo.martialData.ClanID)  then
                clanChoose = true
                break
            end
            if v and k == "-1" then
                local clanTypeData = TB_Clan[martialInfo.martialData.ClanID]
                if not clanTypeData or not clanTypeData.Rank or (clanTypeData.Rank~= RankType.RT_Golden and clanTypeData.Rank~= RankType.RT_DarkGolden) then
                    clanChoose = true
                    break
                end
            end
        end
        if not clanChoose then
            return false
        end
    end

    return true
end

return CollectionDataManager;