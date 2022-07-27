GiftDataManager = class("GiftDataManager")
GiftDataManager._instance = nil

function GiftDataManager:GetInstance()
    if GiftDataManager._instance == nil then
        GiftDataManager._instance = GiftDataManager.new()
    end

    return GiftDataManager._instance
end

function GiftDataManager:ResetManager()
    self.bIsObserveData = nil
    self.bIsArenaObserveData = nil
    self.IsUpdatePickGift = nil
end

-- 根据 uiTypeID，返回 uiID（从静态表里找动态数据）
function GiftDataManager:FindGift(uiTypeID)
    local GiftPool = globalDataPool:getData("GiftPool") or {}
    for i,v in pairs(GiftPool) do
        if v.uiTypeID == uiTypeID then
            return v.uiID
        end
    end
end

-- 根据角色的 roleID，获取角色拥有的天赋列表
function GiftDataManager:GetRoleGift(roleID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色天赋,角色不存在,id=" .. roleID)
        return
    end
    return roleData["auiRoleGift"]
end

-- 根据角色的 roleID，获取角色拥有的战斗天赋列表
function GiftDataManager:GetRoleBatGift(roleID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色天赋,角色不存在,id=" .. roleID)
        return
    end
    local Gift = {}
    for i = 0, getTableSize(roleData.auiRoleGift) - 1 do 
        local gift =  self:GetGiftTypeData(roleData.auiRoleGift[i])
        if gift and (gift.GiftType == GiftType.GT_Battle or gift.GiftType == GiftType.GT_AssistBattle or gift.GiftType == GiftType.GT_Extra) and (gift.BaseID ~= 794) then
            local giftTypeData = self:GetGiftTypeData(roleData.auiRoleGift[i])
            giftTypeData.id = roleData.auiRoleGift[i]
            table.insert(Gift,giftTypeData)
        end
    end
    table.sort( Gift, Gift_Comps )
    return Gift
end

--角色是否有助战天赋
function GiftDataManager:isExistAssistGift(roleID)
    if not roleID then
        return nil
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        return nil
    end

    for i = 0, getTableSize(roleData.auiRoleGift) - 1 do 
        local gift =  self:GetGiftTypeData(roleData.auiRoleGift[i])
        if gift and gift.GiftType == GiftType.GT_AssistBattle then
            return gift
        end
    end
    return nil
end

-- 根据角色的 roleID，获取角色拥有的冒险天赋列表
function GiftDataManager:GetRoleAdvGift(roleID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色天赋,角色不存在,id=" .. roleID)
        return
    end
    local Gift = {} 
    for i = 0, getTableSize(roleData.auiRoleGift)-1 do 
        local gift = self:GetGiftTypeData(roleData.auiRoleGift[i])
        if gift then
            --尝遍四海特殊处理
            if gift.BaseID == 794 then
                gift.Rank = RankType.RT_DarkGolden;--所有人统一为暗金
                gift.EatFoodNum = roleData.uiEatFoodNum;
                gift.MaxEatFoodNum = self:GetEatFoodMaxNum(roleData);
            end
            if (gift.GiftType == GiftType.GT_Adventure) or (gift.BaseID == 794) then
                local giftTypeData = self:GetGiftTypeData(roleData.auiRoleGift[i])
                giftTypeData.id = roleData.auiRoleGift[i]
                table.insert(Gift,giftTypeData)
            end
        end
    end
    table.sort( Gift, Gift_Comps )
    return Gift
end

-- 获取固定天赋，即直接加入到角色的，不是通过学习，偷学、请教、天书这几种方式获取的
function GiftDataManager:GetStaticGift(roleID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色天赋,角色不存在,id=" .. roleID)
        return
    end

    local Gift = {} 
    for i = 0, getTableSize(roleData.auiRoleGift)-1 do 
        local giftData = self:GetGiftData(roleData.auiRoleGift[i])
        if giftData then
            local giftTypeData = self:GetGiftTypeData(roleData.auiRoleGift[i])

            local giftFlag = giftTypeData.GiftFlag;
            local bCanShow = true;
            if giftFlag and #(giftFlag) > 0 then
                for k, v in pairs(giftFlag) do
                    if v == GiftFlagType.GFT_Hide and MSDK_MODE ~= 0 then
                        bCanShow = false;
                        break;
                    end
                end
            end

            if(bCanShow and giftTypeData and self:CheckGiftCanForget(giftTypeData.BaseID) == false) then
                giftTypeData.id = roleData.auiRoleGift[i]
                table.insert(Gift,giftTypeData)
            end
        end
    end

    -- 陈辉特殊需求门派特殊天赋需要置顶
    local tempGift = nil;
    for i = 1, #(Gift) do
        if Gift[i].AddGiftType == 10 then
            tempGift = table.remove(Gift, i);
            break;
        end
    end
    table.sort( Gift, Gift_Comps )
    if tempGift then
        table.insert(Gift, 1, tempGift);
    end
    return Gift
end

--检查天赋或者武学能否观摩和请教
function GiftDataManager:CheckTypeIDAvailable(typeID, isgift)
    local typeData = nil
    if isgift then
        typeData = TableDataManager:GetInstance():GetTableData("Gift", typeID)
    else
        typeData = GetTableData("Martial",typeID) 
    end
    if not typeData then
        return false
    end
    
    if isgift then
        local flag = typeData.GiftFlag or {}
        for i=1, #flag do
            if flag[i] == GiftFlagType.GFT_WatchEnable then
                return true
            end
        end
    else
        return typeData.Drop == TBoolean.BOOL_YES
    end
    return false
end

-- 检查天赋是否可以被遗忘
function GiftDataManager:CheckGiftCanForget(typeID)
    local typeData = TableDataManager:GetInstance():GetTableData("Gift",typeID)
    if not typeData then
        return false
    end
    
    local flag = typeData.GiftFlag or {}
    for i=1, #flag do
        if flag[i] == GiftFlagType.GFT_EnableForget then
            return true
        end
    end
    return false
end

-- 获取动态天赋，通过偷学、请教、天书这几种方式获取的，可以进行遗忘的
function GiftDataManager:GetDynamicGift(roleID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色天赋,角色不存在,id=" .. roleID)
        return
    end
    local Gift = {} 
    for i = 0, getTableSize(roleData.auiRoleGift)-1 do 
        local giftData = self:GetGiftData(roleData.auiRoleGift[i])
        if giftData then
            local giftTypeData = self:GetGiftTypeData(roleData.auiRoleGift[i])
            if(self:CheckGiftCanForget(giftTypeData.BaseID) == true) then
                giftTypeData.id = roleData.auiRoleGift[i]
                table.insert(Gift,giftTypeData)
            end
        end
    end
    table.sort( Gift, Gift_Comps )
    return Gift
end

function GiftDataManager:GetEatFoodMaxNum(roleData)
    local curDiff = RoleDataManager:GetInstance():GetDifficultyValue();
    local kDiffData = StoryDataManager:GetInstance():GetStoryDifficultData(GetCurScriptID(), curDiff) or {}
    return kDiffData.EatFoodCountMax or 0;
end

--排序函数
function Gift_Comps(a,b)
    if  a == nil or b == nil then
        return false
    end
    if a.Rank == b.Rank then
        return a.BaseID < b.BaseID
    else
        return  a.Rank > b.Rank
    end
end

function GiftDataManager:GetRank(roleData, giftDBData)
    -- 尝遍四海特殊处理
    if giftDBData.BaseID == 794 then
        giftDBData.Rank = RankType.RT_DarkGolden    --所有人统一为暗金
    end

    return giftDBData.Rank
end

function GiftDataManager:GetDes(roleData, giftDBData)
    -- 尝遍四海特殊处理
    if giftDBData.BaseID == 794 then
        giftDBData.EatFoodNum = roleData.uiEatFoodNum;
        giftDBData.MaxEatFoodNum = self:GetEatFoodMaxNum(roleData);
        return '使用食物次数限制:　(' .. (giftDBData.EatFoodNum or 0) .. '/' .. (giftDBData.MaxEatFoodNum or 0) ..')'
    elseif giftDBData.BaseID == 616 then -- 阴阳调和
        local contentText = GetLanguagePreset(giftDBData.DescID,"天赋描述"..giftDBData.DescID) or ""

        local yinValue = RoleDataHelper.GetObserveAttr(roleData, nil, "YinXing") / 10;
        local yangValue = RoleDataHelper.GetObserveAttr(roleData, nil, "YangXing") / 10;
        return  string.format(contentText, yinValue or 0, yangValue or 0);
    end
    -- TODO : 这块代码和 CharacterUI:OnBatGiftScrollChanged 重合 可以整合在一起

    return GetLanguageByID(giftDBData.DescID) or ""
end

-- 查询 GiftID（也就是 uiID）对应的天赋信息
function GiftDataManager:GetGiftData(GiftID)
    local GiftPool = nil;
    if GetGameState() == -1 then
        local info = globalDataPool:getData("PlatTeamInfo") or {};
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        end
        return info.GiftInfo and info.GiftInfo[GiftID];
    else
        if self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
            return info.GiftInfo and info.GiftInfo[GiftID];
        end
        local GiftPool = globalDataPool:getData("GiftPool") or {}
        return GiftPool[GiftID]
    end
end

-- 查询 天赋 在 TB_RoleGift 表中的静态信息
function GiftDataManager:GetGiftTypeData(GiftID)

    local GiftPool = nil;
    if GetGameState() == -1 then
        local info = globalDataPool:getData("PlatTeamInfo") or {};
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        end
        GiftPool = info.GiftInfo;
    else
        if self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
            GiftPool = info.GiftInfo;
        else
            GiftPool = globalDataPool:getData("GiftPool") or {}
        end
    end

    local GiftData = GiftPool[GiftID]
    if GiftData then 
        local typeID = GiftData.uiTypeID
        return TableDataManager:GetInstance():GetTableData("Gift", typeID)
    end
    return nil
end

function GiftDataManager:SetObserveData(bIsObserveData)
    self.bIsObserveData = bIsObserveData;
end

function GiftDataManager:SetArenaObserveData(bIsArenaObserveData)
    self.bIsArenaObserveData = bIsArenaObserveData;
end

function GiftDataManager:GetGiftDataByID(baseID)
    return TableDataManager:GetInstance():GetTableData("Gift", baseID)
end

-- 服务器下行：删除天赋信息
function GiftDataManager:DeleteGiftData(GiftID)
    local GiftPool = globalDataPool:getData("GiftPool") or {}
    if GiftPool[GiftID] then 
        GiftPool[GiftID] = nil
        globalDataPool:setData("GiftPool", GiftPool, true)
        self:DispatchUpdateEvent()
    end
end

-- 服务器下行：更新全部天赋信息
function GiftDataManager:UpdateGiftDataByArray(GiftDataArray, arraySize)
    local GiftPool = globalDataPool:getData("GiftPool") or {}
    if not (GiftDataArray and arraySize) then 
        return
    end
    for i = 1, arraySize do 
        local GiftData = GiftDataArray[i - 1]
        local uiID = GiftData.uiID
        GiftPool[uiID] = GiftData
    end

    globalDataPool:setData("GiftPool", GiftPool, true)
    self:DispatchUpdateEvent()
end

function GiftDataManager:GetIsUpdatePickGiftUI(roleID)
    self.IsUpdatePickGift = self.IsUpdatePickGift or {}
    if self.IsUpdatePickGift[roleID] == nil then
        self.IsUpdatePickGift[roleID] = true
    end

    return self.IsUpdatePickGift[roleID]
end

function GiftDataManager:SetIsUpdatePickGiftUI(roleID,bool_update)
    self.IsUpdatePickGift = self.IsUpdatePickGift or {}
    self.IsUpdatePickGift[roleID] = bool_update
end

function GiftDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_GIFT",nil, true)
end

-- 可升级天赋的辅助函数 
function GiftDataManager:GetUpgradeGiftMaxLevel(uiUnitIndex,typeupgradeid,bIsEnemy)
    -- 遍历武学
    local maxlevel = 0
    local SuperImposed = TableDataManager:GetInstance():GetTableData("SuperImposed",typeupgradeid)
    local bufflist = SuperImposed and SuperImposed.BuffList
    local map_bufflist = {}
    if bufflist then 
        for i,v in ipairs(bufflist) do 
            map_bufflist[v] = i
        end 
    end 
    local Local_TB_Gift = TableDataManager:GetInstance():GetTable("Gift")

    local role_check_func = function(uiUnitIndex,akUnit)
        local GiftPool
        if not akUnit then 
            akUnit = UnitMgr:GetInstance():GetUnit(uiUnitIndex)
        end 
        local akBattleRole = akUnit.battleRole
        local GiftPool = akBattleRole and  akBattleRole:GetGifts() 

        if GiftPool and next(map_bufflist) then 
            for i,gift in ipairs(GiftPool) do 
                local giftData = GiftDataManager:GetInstance():GetGiftData(gift);
                local giftbasedata = Local_TB_Gift[giftData and giftData.uiTypeID or gift]
                if giftbasedata.SurperType == typeupgradeid then 
                    if map_bufflist[giftbasedata.BaseID] > maxlevel then 
                        maxlevel = map_bufflist[giftbasedata.BaseID] 
                    end 
                end 
            end 
        end 
    end 
    if bIsEnemy then 
        local roleself = UnitMgr:GetInstance():GetUnit(uiUnitIndex)
        local role_list = UnitMgr:GetInstance():GetAllUnit()
        for i,akUnit in pairs(role_list) do 
            if roleself and akUnit and akUnit.iCamp ~= roleself.iCamp then 
                role_check_func(nil,akUnit)
            end
        end 
    else 
        role_check_func(uiUnitIndex or 1)
    end 
    return maxlevel
end 

-- 可升级天赋的辅助函数 
function GiftDataManager:GetUpgradeGiftInfluenceNum(uiUnitIndex,iBuffTypeID,iLayerNum)
    iLayerNum = iLayerNum or 1
    local levelNum 
    local UpgradeGiftConfig
    local iSurperType 
    local TB_UpgradeGiftConfig = TableDataManager:GetInstance():GetTable("UpgradeGiftConfig")
    for int_i,upgrade in ipairs(TB_UpgradeGiftConfig) do  
        if upgrade.InfluenceBuff ==  iBuffTypeID then 
            UpgradeGiftConfig = upgrade
            break
        end 
    end 
    iSurperType = UpgradeGiftConfig and UpgradeGiftConfig.UpgradeBuffType
    if iSurperType then 
        local maxlevel = self:GetUpgradeGiftMaxLevel(uiUnitIndex,iSurperType,true)
        levelNum = UpgradeGiftConfig.AddPercent[maxlevel + 1] 
    end 
    levelNum = levelNum or 10000
    return iLayerNum * levelNum / 10000
end 


-- 根据角色的 roleID，判断是否有天赋
function GiftDataManager:InstRoleHaveGift(roleID, uiTypeID)
    if not roleID then
        return false
    end
    if not uiTypeID then
        return false
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色天赋,角色不存在,id=" .. roleID)
        return false
    end

    if not roleData.auiRoleGift then
        return false
    end

    for i = 0, getTableSize(roleData.auiRoleGift) - 1 do 
        local gift =  self:GetGiftTypeData(roleData.auiRoleGift[i])
        if gift and gift.BaseID == uiTypeID then
            return true
        end
    end

    return false
end

function GiftDataManager:HasMoreLevelAdvGift(giftData)
    if not giftData then
        return false
    end

    if giftData.GiftType ~= GiftType.GT_Adventure then
        return false
    end

    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    local gifts = self:GetRoleAdvGift(mainRoleID)
    if not gifts then
        return false
    end

    if #gifts <= 0 then
        return false
    end

    -- 主句拥有更高等级的天赋
    for index = 1, #gifts do
        local tempGift = gifts[index]
        if tempGift and tempGift.AdventureType and tempGift.AdventureType == giftData.AdventureType and giftData.AdventureLevel and tempGift.AdventureLevel then
            if  tempGift.AdventureLevel >= giftData.AdventureLevel then
                return true
            end
        end
    end
    return false
end

function GiftDataManager:CheckRoleGiftNum(uiID)
    local iMaxNum = RoleDataManager:GetInstance():GetGiftNumMax(uiID) or 0
    local iNum =  getTableSize(self:GetDynamicGift(uiID)) or 0
    return iNum < iMaxNum
end

-- 天赋是否是专属天赋
function GiftDataManager:IfExclusiveGift(uiTypeID)
    local typeData = TableDataManager:GetInstance():GetTableData("Gift",uiTypeID)
    -- 101 情缘
    if typeData and typeData.CollectionClan == 101 then
        return true
    end
    return false
end