MartialDataManager = class("MartialDataManager")
MartialDataManager._instance = nil

local BATTLE_CONFIG = 10000
local l_MartialConditionTypeToAttrTypeMap = {
    [ClanMartialConfig.CMT_QuanZhangJingTong] = AttrType.ATTR_QUANZHANGJINGTONG,  -- 拳掌精通
    [ClanMartialConfig.CMT_JianFaJingTong] = AttrType.ATTR_JIANFAJINGTONG,  -- 剑法精通
    [ClanMartialConfig.CMT_DaoFaJingTong] = AttrType.ATTR_DAOFAJINGTONG,  -- 刀法精通
    [ClanMartialConfig.CMT_TuiFaJingTong] = AttrType.ATTR_TUIFAJINGTONG,  -- 腿法精通
    [ClanMartialConfig.CMT_QiMenJingTong] = AttrType.ATTR_QIMENJINGTONG,  -- 奇门精通
    [ClanMartialConfig.CMT_AnQiJingTong] = AttrType.ATTR_ANQIJINGTONG,  -- 暗器精通
    [ClanMartialConfig.CMT_YiShuJingTong] = AttrType.ATTR_YISHUJINGTONG,  -- 医术精通
    [ClanMartialConfig.CMT_NeiGongJingTong] = AttrType.ATTR_NEIGONGJINGTONG,  -- 内功精通
    [ClanMartialConfig.CMT_SPEED] = AttrType.ATTR_SUDUZHI,  -- 速度
}

local l_MartialConditionTypeToString = {
    [ClanMartialConfig.CMT_QuanZhangJingTong] = '拳掌精通',
    [ClanMartialConfig.CMT_JianFaJingTong] = '剑法精通',
    [ClanMartialConfig.CMT_DaoFaJingTong] = '刀法精通',
    [ClanMartialConfig.CMT_TuiFaJingTong] = '腿法精通',
    [ClanMartialConfig.CMT_QiMenJingTong] = '奇门精通',
    [ClanMartialConfig.CMT_AnQiJingTong] = '暗器精通',
    [ClanMartialConfig.CMT_YiShuJingTong] = '医术精通',
    [ClanMartialConfig.CMT_NeiGongJingTong] = '内功精通',
    [ClanMartialConfig.CMT_SPEED] = '速度',
}

function MartialDataManager:GetInstance()
    if MartialDataManager._instance == nil then
        MartialDataManager._instance = MartialDataManager.new()
        MartialDataManager._instance:BeforeInit()
    end

    return MartialDataManager._instance
end

function MartialDataManager:BeforeInit()
    self.akMartialPool = {}
    local LOCAL_TB = TableDataManager:GetInstance():GetTable("MartialStrongRandom")
    self.iMaxMartialStrongLevel = 0
    local lmax = math.max
    for id,item in pairs(LOCAL_TB) do
        self.iMaxMartialStrongLevel = lmax(self.iMaxMartialStrongLevel,item.level or 0)
    end

    self.MartialStrongLevelMap = {}
    for name,level in pairs(MartialStrongLevel_Revert) do
        self.MartialStrongLevelMap[level] = name
    end
    local l_martialStrongType = {}
    for name,level in pairs(MartialStrongType_Revert) do
        l_martialStrongType[level] = name
    end
    self.MartialStrongType = {}
    self.MartialStrongType[ENUM_MSEC_SUPER_STRONG] = l_martialStrongType[MartialStrongType.EMST_TYPE_STRONG]
    self.MartialStrongType[ENUM_MSEC_SUPER_CLEAR] = l_martialStrongType[MartialStrongType.EMST_TYPE_CLEAR]
    self.MartialStrongType[ENUM_MSEC_SUPER_CHANGE] = l_martialStrongType[MartialStrongType.EMST_TYPE_CHANGE]
    self.MartialStrongType[ENUM_MSEC_SUPER_CHANGESTRONG] = l_martialStrongType[MartialStrongType.EMST_TYPE_STRONGANDCHANGE]

    self.martialRankColdTimeDict = {}
    local martialCDTable = TableDataManager:GetInstance():GetTable("MartialCD")
    for _, martialCDData in pairs(martialCDTable) do 
        if martialCDData.MartialRank then 
            self.martialRankColdTimeDict[martialCDData.MartialRank] = martialCDData.CDRound
        end
    end
end

function MartialDataManager:GetLevelName(level)
    if self.MartialStrongLevelMap == nil then return "error" end
    local sname = self.MartialStrongLevelMap[level]
    if sname then 
        return sname
    end
    if self.MartialStrongType and self.MartialStrongType[level] then 
        return self.MartialStrongType[level]
    end

    return ("error " .. level)
end

function MartialDataManager:GetMaxMartialStrongLevel()
    return self.iMaxMartialStrongLevel or 0
end

function MartialDataManager:GetMartialStrongRandomData(rank,level)
    return GetTableData("MartialStrongRandom",(rank<<15) | level)
end

function MartialDataManager:GetMartialStrongChangeData(rank,type)
    return GetTableData("MartialStrongChange",(rank<<0) | (type<<15))
end

function MartialDataManager:GetKungfuBaseData(attrtype,kftype,isroleattr,isgrowup)
    if attrtype == nil then 
        return nil
    end
    if attrtype ~= AttrType.ATTR_SUDUZHI then 
        kftype = 0
    end
    isroleattr = isroleattr or TBoolean.BOOL_YES
    isgrowup = isgrowup or TBoolean.BOOL_YES
    local id = (attrtype << 0) | (kftype << 10) | (isroleattr << 14) | (isgrowup << 15)
    return GetTableData("KungfuBase",id)
end

function MartialDataManager:ResetManager()
    self.bIsObserveData = nil
    self.bIsArenaObserveData = nil
    self.akMartialPool = {}
end

-- 根据 uiTypeID，返回 uiID（从静态表里找动态数据）
function MartialDataManager:FindMartial(uiTypeID)
    local martialPool = self.akMartialPool
    for i,v in pairs(martialPool) do
        if v.uiTypeID == uiTypeID then
            return v.uiID
        end
    end
end

-- 根据角色的 roleID，获取角色拥有的武学列表
function MartialDataManager:GetRoleMartial(roleID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色武学,角色不存在,id=" .. roleID)
        return
    end

    local OwnMartial = {}
    if GetGameState() == -1 then
        OwnMartial = roleData.MartialsTypeIDValue;
    else
        if roleData['RoleInfos'] then
           OwnMartial = roleData['RoleInfos']['Martials']
        end
    end
    return OwnMartial
end

-- 根据角色的 roleID，判断是否有武学
function MartialDataManager:InstRoleHaveMartial(roleID, uiTypeID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色武学,角色不存在,id=" .. roleID)
        return
    end
    
    if not roleData['RoleInfos'] then
        return
    end

    local typeIDAll = roleData['RoleInfos']['Martials'] or {}
    -- typeIDAll = table_c2lua(typeIDAll)
    -- 结构改了
    for key, value in pairs(typeIDAll) do
        if value.uiTypeID == uiTypeID then
            return value
        end
    end
    return 
end

-- 查询 martialID（也就是 uiID）对应的武学信息
function MartialDataManager:GetMartialData(martialID)
    local info = nil;
    if GetGameState() == -1 then
        info = globalDataPool:getData("PlatTeamInfo") or {};
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        end
        if info.MartialInfo then
            return info.MartialInfo[martialID];
        end
    else
        if self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
            if info.MartialInfo then
                return info.MartialInfo[martialID];
            end
        end
        info = self.akMartialPool
        return info[martialID]
    end
end

function MartialDataManager:SetObserveData(bIsObserveData)
    self.bIsObserveData = bIsObserveData;
end

function MartialDataManager:SetArenaObserveData(bIsArenaObserveData)
    self.bIsArenaObserveData = bIsArenaObserveData;
end

-- 查询 武学 在 TB_Martial 表中的静态信息
function MartialDataManager:GetMartialTypeData(martialID)
    local martialData = self.akMartialPool[martialID]
    if martialData then 
        local typeID = martialData.uiTypeID
        return GetTableData("Martial",typeID)
    end
    return nil
end

function MartialDataManager:GetData(martialID)
    local martialData = self:GetMartialData(martialID)
    if not martialData then
        derror("武学动态数据不存在,id=" .. martialID)
        return
    end
    local typeID = martialData.uiTypeID
    local martialBaseData =  GetTableData("Martial",typeID)
    if not martialBaseData then
        derror("武学静态数据不存在,id=" .. martialID)
        return
    end
    return martialData, martialBaseData
end

-- 查询武学条目 在 表中的静态信息
function MartialDataManager:GetMartialItemTypeData(martialItemID)
    return TableDataManager:GetInstance():GetTableData("MartialItem", martialItemID)
end

-- 查询物品静态数据中对应的武学数据 (秘籍/ 残章)
function MartialDataManager:GetMartialTypeDataByItemTypeID(itemTypeID)
    if not itemTypeID then return end
    local typeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
    if not (typeData and typeData.MartialID) then return end
    local martialTypeID = typeData.MartialID
    return  GetTableData("Martial",martialTypeID)
end

-- 查询物品静态数据中对应的天赋数据 (天书)
function MartialDataManager:GetGiftTypeDataByItemTypeID(itemTypeID)
    if not itemTypeID then return end
    local typeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
    if not (typeData and typeData.GiftID) then return end
    local GiftTypeID = typeData.GiftID
    return TableDataManager:GetInstance():GetTableData("Gift", GiftTypeID)
end

-- 服务器下行：删除武学信息
function MartialDataManager:DeleteMartialData(martialID)
    local martialData = self.akMartialPool[martialID]
    if martialData then 
        -- 删除人物武学信息
        local uiTypeID = martialData.uiTypeID
        local uiRoleUID = martialData.uiRoleUID
        local RoleData = RoleDataManager:GetInstance():GetRoleData(uiRoleUID)
        if RoleData and RoleData['RoleInfos'] and RoleData['RoleInfos']['Martials'] then
            RoleData['RoleInfos']['Martials'][uiTypeID] = nil
        end

        self.akMartialPool[martialID] = nil
        BattleAIDataManager:GetInstance():ClearAIInfo(uiRoleUID)
        self:DispatchUpdateEvent()
    end
end

-- 服务器下行：更新全部武学信息
function MartialDataManager:UpdateMartialDataByArray(martialDataArray, arraySize)
    local martialPool = self.akMartialPool
    if not (martialDataArray and arraySize) then 
        return
    end
    for i = 1, arraySize do 
        local martialData = martialDataArray[i - 1]
        local uiID = martialData.uiID
        if martialData.uiColdTime == nil then 
            martialData.uiColdTime = 0
        end
        if martialPool[uiID]  == nil then
            martialPool[uiID] = martialData
        else
            for k,v in pairs(martialData) do
                martialPool[uiID][k] = v
            end
        end
        local uiTypeID = martialData.uiTypeID
        local uiRoleUID = martialData.uiRoleUID
        local RoleData = RoleDataManager:GetInstance():GetRoleData(uiRoleUID)
        if RoleData then
            RoleData['RoleInfos'] = RoleData['RoleInfos'] or {}
            RoleData['RoleInfos']['Martials'] = RoleData['RoleInfos']['Martials'] or {}
            if RoleData['RoleInfos']['Martials'][uiTypeID] == nil then
                RoleData['RoleInfos']['Martials'][uiTypeID] = martialData
            else
                local data = RoleData['RoleInfos']['Martials'][uiTypeID]
                for k,v in pairs(martialData) do
                    data[k] = v
                end
            end 
        end
        BattleAIDataManager:GetInstance():ClearAIInfo(uiRoleUID)
    end
    self:DispatchUpdateEvent()
end

-- 缓存武学升级数据
function MartialDataManager:CacheMartialLevelUpMsg(roleID, martialTypeID, oldLevel, newLevel, bHasNewAttr)
    if not RoleDataManager:GetInstance():isInBattleTeam(roleID) then 
        return false
    end 
    local info = globalDataPool:getData("GameData")
    if not info then
        info = {['LevelUpCache'] = {}}
    elseif not info["LevelUpCache"] then
        info.LevelUpCache = {}
    end
    local cache = info.LevelUpCache
    cache[roleID] = cache[roleID] or {}
    local roleCache = cache[roleID]
    roleCache.martialLevelUp = roleCache.martialLevelUp or {}
    local martialCache = roleCache.martialLevelUp
    martialCache[martialTypeID] = {
        ['oldLevel'] = oldLevel,
        ['newLevel'] = newLevel,
        ['bHasNewAttr'] = (bHasNewAttr == true),
    }
    globalDataPool:setData("GameData", info, true)
    return true
end

-- 服务器下行：出战配置
-- 感觉不像是增量更新，直接覆盖就好了。
function MartialDataManager:UpdateEmbattleMartial(retStream)
    if not retStream then return end
    local martialList = globalDataPool:getData("EmbattleMartial") or {}
    local newData = retStream['akEmBattleMartialInfo']
    local roleID = retStream['uiRoleUID']
    if roleID then
        martialList[roleID] = newData
        globalDataPool:setData("EmbattleMartial", martialList, true)
        BattleAIDataManager:GetInstance():ClearAIInfo(roleID)
        LuaEventDispatcher:dispatchEvent("UPDATE_EMBATTLE_MARTIAL")
    end
end

-- 获取武学有效条目数量
function MartialDataManager:GetMartialEffectiveAttrsNum(instMartialData)
    if not instMartialData then return 0 end
    local staticMartialData = self:GetMartialTypeData(instMartialData.uiID)
    if not staticMartialData then return 0 end
    -- 条目解锁查询表 索引从0开始
    local matItemUnlockLookUp = setmetatable({},{__index = function(tab, key) return false end})
    local auiMartialUnlockItems = instMartialData.auiMartialUnlockItems
    local iMatItemsLen = instMartialData.iMartialUnlockItemSize or 0
    local uiMartialUnlockItem = nil
    for i = 0, iMatItemsLen - 1 do
        uiMartialUnlockItem = auiMartialUnlockItems[i]
        matItemUnlockLookUp[uiMartialUnlockItem] = true
    end
    -- 查询所有武学条目
    local state = nil
    local levelCond = 0
    local count = 0
    local iMartialCurLevel = instMartialData.uiLevel
    local aiUnlockLvls = staticMartialData.UnlockLvls or {}
    local aiUnlockClauses = staticMartialData.UnlockClauses or {}
    for index, matItemID in ipairs(aiUnlockClauses) do
        levelCond = aiUnlockLvls[index] or 0
        if (matItemUnlockLookUp and (matItemUnlockLookUp[matItemID] == true)) 
        or (iMartialCurLevel >= levelCond) then
            count = count + 1
        end
    end
    return count
end

function MartialDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_MARTIAL_DATA")
end

-- 获取默认武学等级上限
function MartialDataManager:GetMartialDefaultMaxLevel()
    local config = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    local int_ret = config.DefaultMartialMaxLevel or 10 
    --# TODO 钱程 额外等级上限应该要从玩家数据中去获取, 现在还没有, 后面加上
    -- if G.MISC and G.MISC.额外武学等级上限 then 
    --     int_ret = int_ret + G.MISC.额外武学等级上限
    -- end
    return int_ret
end

-- 获取最终武学等级上限
function MartialDataManager:GetMartialFinalMaxLevel()
    local config = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    local int_ret = config.MartialMaxLevelFinal or 30
    return int_ret
end

-- 获取武学等级上限
function MartialDataManager:GetMartialMaxLevel(martialID)
    local int_level = self:GetMartialDefaultMaxLevel() or 0
    if not martialID then 
        return int_level 
    end
    --武学等级上限从动态数据获取
    local instMartialData = self:GetData(martialID)
    if not instMartialData then
        return int_level
    end
    return instMartialData.uiMaxLevel or int_level
end

-- 获取技能描述
function MartialDataManager:GetSkillDesc(skillTypeData, instMartialData)
    -- FLAGCJ
    if not skillTypeData then
        return "missing skillTypeData"
    end
    local sSkillDesc = self:FillPlaceholder(GetLanguageByID(skillTypeData.DescID))
    return sSkillDesc
end

-- 获取武学条目中的技能
function MartialDataManager:GetMartialItemSkill(staticMartialItemData)
    local itemType = staticMartialItemData.ItemType
    if (itemType ~= MartialItemType.MIT_GrowUp) then
        return
    end
    local index = 1
    local trigger = staticMartialItemData['EffectEnum' .. index]
    while trigger and (trigger ~= MartialItemEffect.MIE_MartialItemEffectNull) do
        -- 查询技能数据
        if trigger == MartialItemEffect.MTT_ZHAOSHIJINENG then
            local skillID = staticMartialItemData['SkillID' .. index]
            local skillData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
            return skillData
        elseif trigger == MartialItemEffect.MTT_JINENGJINGHUA then
            local newSkillID = 0
            if staticMartialItemData and staticMartialItemData["Effect1Value"] then
                newSkillID = staticMartialItemData["Effect1Value"][2] or 0
            end 
            local newSkillTypeData = TableDataManager:GetInstance():GetTableData("Skill", newSkillID)
            return newSkillTypeData
        end 
        -- 检查下一个
        index = index + 1
        trigger = staticMartialItemData['EffectEnum' .. index]
    end
end

-- 武学条目是否隐藏
function MartialDataManager:IfMartialItemHide(staticMartialItemData)
    for _, feature in ipairs(staticMartialItemData.ItemFeature or {}) do
        if feature == MartialItemFeature.IFF_Hide then
            return true
        end
    end
    return false
end

-- 辅助获取威力(武学数据, 按系别, 按指定武学. 按自身武学)
function MartialDataManager:AssistGetMartialPower(StaticMartialData, iFactor1,eMartialType)
    local rank = StaticMartialData.Rank
    local factor1 = iFactor1 or 1

    local factor2 = 1
    local TB_MartialUnlockAttr = TableDataManager:GetInstance():GetTable("MartialUnlockAttr")
    for index, data in pairs(TB_MartialUnlockAttr) do
        if data.DepartEnum == eMartialType then
            factor2 = (data.Factor or 10000) / BATTLE_CONFIG
            break
        end
    end

    local factor3 = 1
    local TB_RankMartialAddition = TableDataManager:GetInstance():GetTable("RankMartialAddition")
    for index, data in pairs(TB_RankMartialAddition) do
        if data.MartialRank == rank then
            factor3 = (data.MartialAddition or 10000) / BATTLE_CONFIG
            break
        end
    end

    return factor1 * factor2 * factor3
end

-- 获取武学触发条目-武学威力/威力系数 指定系别 威力
function MartialDataManager:AssistGetMartialPowerByDepart(StaticMartialData,eMartialType)
    local factor1 = (TableDataManager:GetInstance():GetTableData("CommonConfig",1)["MartialUnlockAttrDepart"] or 10000) / BATTLE_CONFIG
    return self:AssistGetMartialPower(StaticMartialData, factor1,eMartialType)
end
-- 获取武学触发条目-武学威力/威力系数 指定门派 威力
function MartialDataManager:AssistGetMartialPowerByClan(StaticMartialData,eMartialType)
    local factor1 = (TableDataManager:GetInstance():GetTableData("CommonConfig",1)["MartialUnlockClan"] or 10000) / BATTLE_CONFIG
    return self:AssistGetMartialPower(StaticMartialData, factor1,eMartialType)
end
-- 获取武学触发条目-武学威力/威力系数 指定 武学 威力
function MartialDataManager:AssistGetMartialPowerAppointed(StaticMartialData,eMartialType)
    local factor1 = (TableDataManager:GetInstance():GetTableData("CommonConfig",1)["MartialUnlockAppointed"] or 10000) / BATTLE_CONFIG
    return self:AssistGetMartialPower(StaticMartialData, factor1,eMartialType)
end

-- 获取武学触发条目-武学威力/威力系数 本武学 威力
function MartialDataManager:AssistGetMartialPowerSelf(StaticMartialData,eMartialType)
    local factor1 = (TableDataManager:GetInstance():GetTableData("CommonConfig",1)["MartialUnlockAttrSelf"] or 10000) / BATTLE_CONFIG    
    return self:AssistGetMartialPower(StaticMartialData, factor1,eMartialType)
end

-- 获取武学触发条目-武学威力/威力系数 所有武学 威力
function MartialDataManager:AssistGetMartialPowerAll(StaticMartialData,eMartialType)
    local factor1 = (TableDataManager:GetInstance():GetTableData("CommonConfig",1)["MartialUnlockAll"] or 10000) / BATTLE_CONFIG
    local rank = StaticMartialData.Rank
    local factor2 = 1
    local TB_RankMartialAddition = TableDataManager:GetInstance():GetTable("RankMartialAddition")
    for index, data in pairs(TB_RankMartialAddition) do
        if data.MartialRank == rank then
            factor2 = (data.MartialAddition or 10000) / BATTLE_CONFIG
            break
        end
    end
    return factor1 * factor2
end

--武学_满足条件_门派系别
function MartialDataManager:MartialAdditionMeetDepart(instMartialData,staticMartialData,clan,depart,poison,multistage,rank)
    if self:MartialIsAssignedDepart(staticMartialData,depart) then
        if clan == nil or staticMartialData.Clan == clan then
            if rank == nil or staticMartialData.Rank == rank then
                if instMartialData then
                    if poison == nil or instMartialData.poison == poison then
                        if multistage == nil or multistage == instMartialData.multistage then
                            return true
                        end
                    end
                else
                    return true
                end
            end 
        end
    end
    return false
end

--武学_属于指定系别
function MartialDataManager:MartialIsAssignedDepart(staticMartialData,departEnum)
    if staticMartialData == nil or  staticMartialData.DepartEnum == nil then return false end 
    if departEnum == nil then return true end 
    if staticMartialData.DepartEnum == departEnum then 
        return true 
    end 
    return false
end

-- 获取武学条目过滤器描述
function MartialDataManager:GetMartialFilterDesc(martialFilterTypeID, staticMartialData)
    local filterDesc = ""
    local filterInstData = TableDataManager:GetInstance():GetTableData("MartialFilter",martialFilterTypeID)
    -- 特定武学
    local targetMartialID = filterInstData.MartialID
    if targetMartialID and (targetMartialID > 0) then
        local martialBaseData = GetTableData("Martial",targetMartialID)
        return GetLanguageByID(martialBaseData.NameID)
    end
    -- 特定门派
    local targetClanID = filterInstData.ClanID
    if targetClanID and (targetClanID > 0) then
        local clanTypeData = TB_Clan[targetClanID]
        filterDesc = filterDesc .. GetLanguageByID(clanTypeData.NameID)
    else
        filterDesc = filterDesc .. "所有"
    end
    -- 品质
    local rank = filterInstData.Rank
    if rank and (rank ~= RankType.RT_RankTypeNull) then
        filterDesc = filterDesc .. ( GetEnumText('RankType', rank) or "missing rank" ) .. "品质"
    end
    -- 毒系
    local bIsToxic = filterInstData.Toxic
    if bIsToxic and (bIsToxic == TBoolean.BOOL_YES) then
        filterDesc = filterDesc .. "有毒"
    end
    -- 多段
    local bIsMult = filterInstData.Multistage
    if bIsMult and (bIsMult == TBoolean.BOOL_YES) then
        filterDesc = filterDesc .. "多段"
    end
    -- 系别  如果过滤器自动系别(AutoMartialType)属性为true, 则系别使用本武学的系别
    local martialTypeEnum = DepartEnumType.DET_DepartEnumTypeNull
    if filterInstData.AutoMartialType == TBoolean.BOOL_YES then
        martialTypeEnum = staticMartialData.DepartEnum
    else
        martialTypeEnum = filterInstData.MartialType
    end
    -- 默认没有填系别过滤的情况下指向所有武学
    local sTarget = "武学"
    if martialTypeEnum and (martialTypeEnum ~= DepartEnumType.DET_DepartEnumTypeNull) then
        sTarget = GetEnumText('DepartEnumType', martialTypeEnum)
    end
    filterDesc = filterDesc .. sTarget
    return filterDesc
end

--获取武学攻击段数
function MartialDataManager:GetMartialAttackTimes(MartialID,roleId,skillid)
    local martialData = GetTableData("Martial",MartialID)
    if not martialData then
        return 0
    end
    

    local kMartialItemTable = TableDataManager:GetInstance():GetTableData("MartialItem", martialData.MartMovIDs[1])
    if not kMartialItemTable then
        return 0
    end

    local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillid or kMartialItemTable.SkillID1)
    if not kSKillData then
        return 0
    end

    local effectId = kSKillData.SkillTriggers[1] and kSKillData.SkillTriggers[1].EffectID or 0
    local effectData = TableDataManager:GetInstance():GetTableData("SkillEffect",effectId)
    if not effectData then
        return 0
    end

    local times = 1
    if effectData.Name == SkillEffectDescription.SED_SkillLogic_RemoteMultisegmentAnQiSkill or 
        effectData.Name == SkillEffectDescription.SED_SkillLogic_MultisegmentAttackSkill or 
        effectData.Name == SkillEffectDescription.SED_SpecificSkillLogic_XiaJiBaKan then
            times = effectData.EventArg3[1]/BATTLE_CONFIG
    end

    if effectData.Name == SkillEffectDescription.SED_SkillLogic_CommonInitiativeSkill and effectData.EventArg1 and effectData.EventArg1[1] then
        local realEffectData = TableDataManager:GetInstance():GetTableData("SkillEffect",effectData.EventArg1[1])
        times = realEffectData.EventArg3 and realEffectData.EventArg3[1]/BATTLE_CONFIG or 1
    end

    if roleId > 0 then
        local roleData = RoleDataManager:GetInstance():GetRoleData(roleId)
        if roleData then
            times = times + (roleData.aiAttrs[AttrType.ATTR_DUODUANGONGJICISHU] or 0)
        end
    end
    
    return times
end

function MartialDataManager:GetMartialCatapult(MartialID,roleId,skillid)
    local martialData = GetTableData("Martial",MartialID)
    if not martialData then
        return 0
    end
    

    local kMartialItemTable = TableDataManager:GetInstance():GetTableData("MartialItem", martialData.MartMovIDs[1])
    if not kMartialItemTable then
        return 0
    end

    local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillid or kMartialItemTable.SkillID1)
    if not kSKillData then
        return 0
    end
    local times = kSKillData.Catapult or 0

    if roleId and roleId > 0 then
        local roleData = RoleDataManager:GetInstance():GetRoleData(roleId)
        if roleData then
            times = times + (roleData.aiAttrs[AttrType.MP_TANSHECISHU] or 0)
        end
    end
    return times
end

-- 获取武学条目条件描述
function MartialDataManager:GenMartialItemCondDesc(condID)
    local condData = TableDataManager:GetInstance():GetTableData("Condition",condID)
    if not condData then return "" end
    -- 空
    local emptyDescGen = function()
        return ""
    end 
    -- 角色_角色拥有天赋
    local roleGiftDescGen = function()
        local giftTypeID = tonumber(condData['CondArg2'])
        local giftTypeData = TableDataManager:GetInstance():GetTableData("Gift",giftTypeID)
        if not giftTypeData then return "" end
        return string.format("拥有%s时", GetLanguageByID(giftTypeData.NameID))
    end
    -- 角色_武学等级
    local martialLevelDescGen = function()
        local martialTypeID = tonumber(condData['CondArg1'])
        local levelLimit = tonumber(condData['CondArg3'])
        local martialBaseData = GetTableData("Martial",martialTypeID)
        if (not martialBaseData) or (levelLimit <= 0) then
            return ""
        end
        local desc = ""
        local martialName = GetLanguageByID(martialBaseData.NameID)
        if levelLimit == 1 then
            desc = string.format("习得%s时", martialName)
        else
            desc = string.format("%s等级达到%d时", martialName, levelLimit)
        end
        return desc
    end
    -- 角色属性比较
    local roleAttrDescGen = function()
        local eAttr = tonumber(condData['CondArg1'])
        local sAttr = GetEnumText("AttrType", eAttr)
        local attrLimit = tonumber(condData['CondArg3'])
        if (not sAttr) or (sAttr == "") or (attrLimit <= 0) then
            return ""
        end
        return string.format("角色%s大于%d时", sAttr, attrLimit)
    end
    
    -- 根据不同类型生成描述
    local genCenter = {
        [ConditionType.CT_auto_jiao3se4_jiao3se4yong1you3tian1fu4] = roleGiftDescGen,
        [ConditionType.CT_Role_MartialLV] = martialLevelDescGen,
        [ConditionType.CT_ROLR_ATTR_CMP] = roleAttrDescGen,
    }
    genCenter = setmetatable(genCenter, {__index = function(tab, key)
        return emptyDescGen
    end})
    return genCenter[condData.CondType]()
end

-- 武学条目触发逻辑-武学威力计算规则
function MartialDataManager:GetMartialItemMartialPrower(staticMartialData, staticMatItemData, iIndex)
    if not (staticMartialData and staticMatItemData and iIndex) then
        return 0
    end
    -- 获取武学条目过滤器
    local filterID = staticMatItemData['MartialFilter' .. iIndex]
    local bHasFilter = (filterID ~= nil) and (filterID ~= 0)
    local filterData = nil
    if bHasFilter then
        filterData = TableDataManager:GetInstance():GetTableData("MartialFilter",filterID)
    end
    local bIfDepart = (bHasFilter and filterData) and ((filterData.MartialType and (filterData.MartialType ~= DepartEnumType.DET_DepartEnumTypeNull))
    or (filterData.AutoMartialType == TBoolean.BOOL_YES))

    local eMartialType = (bHasFilter and filterData) and filterData.MartialType
    if   (bHasFilter and filterData) and filterData.AutoMartialType  == TBoolean.BOOL_YES then 
        eMartialType = staticMartialData.DepartEnum
    end 
    -- 没有填写过滤器时, 表示本武学属性, 用本武学公式计算对应威力, 表中EffectValue不生效
    if not (bHasFilter and filterData) then
        local value = self:AssistGetMartialPowerSelf(staticMartialData,eMartialType)
        return value * BATTLE_CONFIG
    -- 过滤器中填写了指定门派时, 取门派武学威力去计算对应的数值, 表中EffectValue不生效
    elseif filterData.ClanID and (filterData.ClanID > 0) then
        local value = self:AssistGetMartialPowerByClan(staticMartialData,eMartialType)
        return value * BATTLE_CONFIG
    -- 过滤器中填写了指定系别时, 用系别武学威力去计算对应的数值, 表中EffectValue不生效
    elseif bIfDepart then
        local value = self:AssistGetMartialPowerByDepart(staticMartialData,eMartialType)
        return value * BATTLE_CONFIG
    -- 过滤器中填写了指定武学时, 用指定武学公式计算对应威力，表中EffectValue不生效
    elseif filterData.MartialID and (filterData.MartialID > 0) then
        local value = self:AssistGetMartialPowerAppointed(staticMartialData,eMartialType)
        return value * BATTLE_CONFIG
    -- 过滤器没有填写任何指向字段时, 指向所有武学, 用所有武学公式计算对应威力, 表中EffectValue不生效
    else
        local value = self:AssistGetMartialPowerAll(staticMartialData,eMartialType)
        return value * BATTLE_CONFIG
    end
end

-- 生成武学条目触发逻辑描述
function MartialDataManager:GenMartialItemTriggerDesc(staticMartialData, instMartialData, iFakeLevel, iFakeMaxLevel, bForceShowCond, refRetTable)
    -- 如果没有传入条目描述总表, 新建一个
    if not refRetTable then 
        refRetTable = {} 
    end
    -- 如果传入动态数据, 静态数据以动态数据中的静态id为准
    if instMartialData then
        staticMartialData = GetTableData("Martial",instMartialData.uiTypeID)
    end
    -- 如果获取不到必要数据, 直接返回总表
    if not staticMartialData then 
        return refRetTable 
    end
    -- 如果传入了动态武学数据, 建立 条目解锁查询表
    -- 后续优化 不能只简单的判断有无检索 还需要判断 等级是否已达成 
    -- 如果解锁的条目一样 则优先记录等级低的 默认高级的解锁了 低级的也解锁了
    local matItemUnlockLookUp = nil
    if instMartialData then
        -- 条目解锁查询表 索引从0开始
        matItemUnlockLookUp = setmetatable({},{__index = function(tab, key) return false end})
        local auiMartialUnlockItems = instMartialData.auiMartialUnlockItems
        local iMatItemsLen = instMartialData.iMartialUnlockItemSize or 0
        local uiMartialUnlockItem = nil
        local iStaticMatItemLv = 1
        local iStaticMatItemIndex = 1
        local _map_cout_ItemIndex = {}
        for i = 0, iMatItemsLen - 1 do
            uiMartialUnlockItem = auiMartialUnlockItems[i]
            _map_cout_ItemIndex[uiMartialUnlockItem] = (_map_cout_ItemIndex[uiMartialUnlockItem] or 0) + 1
        end
        -- 遍历静态1-30级 从低到高 
        for iStaticMatItemLv = 1,30 do  
            if staticMartialData.UnlockLvls then 
                for iStaticMatItemIndex = 1,#staticMartialData.UnlockLvls do 
                    if iStaticMatItemLv == staticMartialData.UnlockLvls[iStaticMatItemIndex] then 
                        uiMartialUnlockItem = staticMartialData.UnlockClauses[iStaticMatItemIndex]
                        for iMatItemID,iCount in pairs(_map_cout_ItemIndex) do
                            if uiMartialUnlockItem == iMatItemID and iCount > 0 then 
                                matItemUnlockLookUp[uiMartialUnlockItem] = iStaticMatItemLv
                                _map_cout_ItemIndex[iMatItemID] = _map_cout_ItemIndex[iMatItemID] - 1
                                break
                            end 
                        end
                    end 
                end 
            end
        end 
    end
    local matDataManager = MartialDataManager:GetInstance()
    -- 分析条目描述的逻辑
    local genFunc = function(matItemData, iIndex)
        local retDesc = ""
        local effectEnum = matItemData['EffectEnum' .. iIndex]
        local skillID = nil
        local skillTypeData = nil
        local effectValue = nil
        if effectEnum == MartialItemEffect.MTT_BEIDONGJINENG then
            skillID = matItemData['SkillID' .. iIndex]
            skillTypeData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
            retDesc = self:GetSkillDesc(skillTypeData, matItemData)
        elseif effectEnum == MartialItemEffect.MTT_ZHAOSHIJINENG then
            skillID = matItemData['SkillID' .. iIndex]
            skillTypeData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
            if skillTypeData.Type == SkillType.SkillType_juezhao then
                retDesc = "解锁绝招:　" .. GetLanguageByID(skillTypeData.NameID)
            else
                retDesc = self:GetSkillDesc(skillTypeData, matItemData)
            end
        elseif effectEnum == MartialItemEffect.MTT_JINENGJINGHUA then
            effectValue = matItemData['Effect' .. iIndex .. 'Value']
            if effectValue and (#effectValue >= 2) then
                skillID = effectValue[2]
                skillTypeData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
                retDesc = "技能进化为" .. GetLanguageByID(skillTypeData.NameID)
            end
        elseif effectEnum == MartialItemEffect.MTT_BUFF then
            effectValue = matItemData['Effect' .. iIndex .. 'Value']
            skillID = effectValue[1]
            skillTypeData = TableDataManager:GetInstance():GetTableData("Buff", skillID)
            retDesc = self:GetSkillDesc(skillTypeData, matItemData)
        elseif effectEnum == MartialItemEffect.MTT_AOYI then
            effectValue = matItemData['Effect' .. iIndex .. 'Value']
            retDesc = "解锁绝招:　" .. GetLanguageByID(effectValue and effectValue[1])
        else
            local attrEnum = matItemData['AttrEnum' .. iIndex]
            if attrEnum and (attrEnum ~= AttrType.ATTR_NULL) then
                local attrName = GetEnumText("AttrType", attrEnum) or "missing attr name"
                -- 武学威力/威力系数需要用特殊规则另外计算, 其它条目直接读取表格数值
                local value = 0
                effectValue = matItemData['Effect' .. iIndex .. 'Value']
                if (attrEnum == AttrType.MP_WEILI) or (attrEnum == AttrType.MP_WEILIXISHU) or (attrEnum == AttrType.ATTR_WEILIBAIFENBI) then
                    -- 单机调整为威力百分比如果有填effectValue 就用effectValue的值
                    if effectValue and effectValue[1] and attrEnum == AttrType.ATTR_WEILIBAIFENBI then
                        value = effectValue[1] or 0
                    else
                        value = self:GetMartialItemMartialPrower(staticMartialData, matItemData, iIndex)
                    end
                else
                    --effectValue = matItemData['Effect' .. iIndex .. 'Value']
                    value = effectValue[1] or 0
                end
                local strSymbol = (value >= 0) and "+" or ""
                local bIsPerMyriad, bShowAsPercent = matDataManager:AttrValueIsPermyriad(attrEnum)
                if bIsPerMyriad then
                    value = value / BATTLE_CONFIG
                end
                if bShowAsPercent then
                    retDesc = string.format("%s%s%.1f%%", attrName, strSymbol, value * 100)
                else
                    local fs = bIsPerMyriad and "%s%s%.1f" or "%s%s%.0f"
                    retDesc = string.format(fs, attrName, strSymbol, value)
                end
            end
        end
        return retDesc
    end
    -- 获取武学等级相关数据
    local iMartialCurLevel = 0
    local iMartialMaxLevel = 0
    if instMartialData then
        iMartialCurLevel = instMartialData.uiLevel
        iMartialMaxLevel = self:GetMartialMaxLevel(instMartialData.uiID)
    elseif iFakeLevel then
        -- 如果传入了假的武学等级, 那么设当前等级为假等级
        iMartialCurLevel = iFakeLevel
        iMartialMaxLevel = iFakeMaxLevel and iFakeMaxLevel or iFakeLevel
    else
        -- 既没有动态数据也没有假数据, 显示最终最大等级
        iMartialCurLevel = self:GetMartialFinalMaxLevel()
        iMartialMaxLevel = self:GetMartialFinalMaxLevel()
    end
    -- 开始分析武学中所有的条目
    local aiUnlockLvls = staticMartialData.UnlockLvls or {}
    local aiUnlockClauses = staticMartialData.UnlockClauses or {}
    -- 分析条目触发逻辑描述与状态 状态分为 achieve > unclok > lock
    -- for循环变量
    local state = nil
    local prefix = nil
    local color = nil
    local colorTag = nil
    local levelCond = 0
    local sortWeight = 0
    local staticMatItemData = nil
    local matItemDesc = {}
    -- while循环变量
    local index = 1
    local trigger = nil
    local filter = nil
    local filterDesc = nil
    local attrType = nil
    local bHide = false
    local genDesc = nil
    -- 查询所有武学条目
    for index, matItemID in ipairs(aiUnlockClauses) do
        -- 数据初始化
        state = "lock"
        levelCond = aiUnlockLvls[index] or 0
        prefix = string.format("%d级", levelCond)
        color = getUIColor('lightgray')
        colorTag = "<color=#A0A09E>"
        if (iMartialCurLevel >= levelCond)
        or (iMartialMaxLevel + 5 >= levelCond) then  -- 武学最大等级 + 5 为条目控制隐藏等级
            state = "unlock"
        end
        staticMatItemData = TableDataManager:GetInstance():GetTableData("MartialItem", matItemID)

        if instMartialData then
            if (matItemUnlockLookUp and matItemUnlockLookUp[matItemID] and  (matItemUnlockLookUp[matItemID] >= levelCond)) and
             (staticMatItemData.CondID == 0 or RoleDataHelper.ConditionComp(staticMatItemData.CondID,instMartialData,staticMartialData)) then 
                state = "achieve"
                color = getUIColor('black')
                colorTag = "<color=#FFFFFF>"
            end
        else
            if levelCond <= iMartialCurLevel then
                state = "achieve"
                color = getUIColor('black')
                colorTag = "<color=#FFFFFF>"
            end
        end

        matItemDesc = {}
        -- 描述数据处理
        sortWeight = levelCond
        if state == "lock" and not IsWindowOpen("CollectionMartialUI") then
            bHide = false
            matItemDesc[1] = "？？？"
        else
            bHide = self:IfMartialItemHide(staticMatItemData)
            -- 如果武学条目存在自己的描述, 则使用武学条目的描述, 否则, 分析条目触发效果
            if staticMatItemData.DesID and (staticMatItemData.DesID > 0) and (not bHide) then
                matItemDesc[1] = GetLanguageByID(staticMatItemData.DesID)
            else
                -- 循环变量初始化
                filter = nil
                attrType = AttrType.ATTR_NULL
                -- 查询条目数据中所有的触发效果
                index = 1
                trigger = staticMatItemData['EffectEnum' .. index]
                while trigger and (trigger ~= MartialItemEffect.MIE_MartialItemEffectNull) do
                    -- 查询数据
                    attrType = staticMatItemData['AttrEnum' .. index]
                    if attrType == AttrType.ATTR_NEILIYANGXING then
                        color = getUIColor('yang')
                        colorTag = "<color=#EE6230>"
                        prefix = ""
                        bHide = false
                        sortWeight = 0
                    elseif attrType == AttrType.ATTR_NEILIYINXING then
                        color = getUIColor('yin')
                        colorTag = "<color=#669ABA>"
                        prefix = ""
                        bHide = false
                        sortWeight = 0
                    end
                    if not bHide then
                        -- 过滤器描述
                        filterDesc = nil
                        filter = staticMatItemData['MartialFilter' .. index]
                        if filter and (filter > 0) then
                            filterDesc = self:GetMartialFilterDesc(filter, staticMartialData)
                        elseif trigger == MartialItemEffect.MTT_WUXUESHUXING then
                            filterDesc = "本武学"
                        end
                        -- 生成描述
                        genDesc = genFunc(staticMatItemData, index)
                        -- 接上过滤器描述
                        if filterDesc and (filterDesc ~= "") then
                            genDesc = filterDesc .. genDesc
                        end
                        matItemDesc[#matItemDesc + 1] = genDesc
                    end
                    -- 检查下一个
                    index = index + 1
                    trigger = staticMatItemData['EffectEnum' .. index]
                end
            end
        end
        -- 插入数据
        if not bHide then
            -- 分析条目条件描述
            local condID = staticMatItemData.CondID
            local strCondDesc = ""
            -- 除去强制需要显示条目条件(比如秘籍tips)的情况, 
            -- 一般情况下, 只有在你解锁了该条目(状态不为lock), 并且没有满足条件(状态不为achieve), 即条件为unlock的情况下才吧条件标红显示出来
            if ((state == "unlock") or (bForceShowCond == true)) and (condID ~= nil) and (condID > 0) then
                strCondDesc = self:GenMartialItemCondDesc(condID)
                if strCondDesc and (strCondDesc ~= "") then
                    strCondDesc = strCondDesc .. ","
                    -- 如果当前武学等级达到该条目的等级要求, 则说明是等级满足条件的情况下条件不满足导致的没有achieve, 
                    -- 条件描述部分使用红色, 条目描述其它部分使用灰色
                    -- 如果当前武学等级没有达到该条目的等级要求, 则条件+条目描述全部使用灰色
                    -- 强制显示条件的情况下, 条件没有状态, 也显示灰色
                    if (iMartialCurLevel >= levelCond) and (bForceShowCond ~= true) then
                        strCondDesc = "<color=" .. UI_COLOR_STR['red_half'] .. ">" .. strCondDesc .. "</color>"
                    end
                end
            elseif (condID ~= nil) and (condID > 0) and (state == "achieve") and GetGameState() == -1 then
                strCondDesc = self:GenMartialItemCondDesc(condID)
                if strCondDesc and (strCondDesc ~= "") then
                    strCondDesc = strCondDesc .. ","
                    -- 剧本外面 achieve的时候 就直接加上去 
                end
            end
            -- 拼接最终描述
            local strFinalDesc = strCondDesc .. table.concat(matItemDesc, ',')
            refRetTable[#refRetTable + 1] = {
                ['sortKey'] = sortWeight,
                ['state'] = state,
                ['prefix'] = prefix,
                ['color'] = color,
                ['colorTag'] = colorTag,
                ['desc'] = strFinalDesc
            }
        end
    end
    -- 返回总表
    return refRetTable
end

-- 生成武学成长条目描述
function MartialDataManager:GenMartialItemGrowDesc(staticMartialData, instMartialData, refRetTable,bShowAll,iStrongLevel)
    -- 如果没有传入条目描述总表, 新建一个
    if not refRetTable then 
        refRetTable = {} 
    end
    -- 如果传入动态数据, 静态数据以动态数据中的静态id为准
    if instMartialData then
        staticMartialData = GetTableData("Martial",instMartialData.uiTypeID)
        if iStrongLevel == nil then 
            iStrongLevel = instMartialData.iStrongLevel
        end
    end
    -- 如果获取不到必要数据, 直接返回总表
    if not staticMartialData then 
        return refRetTable 
    end
    iStrongLevel = iStrongLevel or 0
    local iLevel = 0
    -- 从武学实例数据中获取等级
    if instMartialData and instMartialData.uiLevel then 
        iLevel = instMartialData.uiLevel
    end
    -- 成长威力-品质 系数表
    local growRankPowerFactor = {}
    -- 成长威力-档次 系数表
    local growGradePowerFactor = {}
    -- 初始化品质系数表
    local kfType = nil
    local iRank = nil
    local rankData = nil
    local subTab = nil
    local TB_KungfuBase = TableDataManager:GetInstance():GetTable("KungfuBase")
    for _, data in pairs(TB_KungfuBase) do
        kfType = data.KfType
        -- 陈辉加了个 威力系数 属性, 说显示就当威力处理
        if ((data.AttrType == AttrType.MP_WEILI) or (data.AttrType == AttrType.MP_WEILIXISHU)) and (data.IsGrowup == TBoolean.BOOL_YES) then
            if not growRankPowerFactor[kfType] then
                growRankPowerFactor[kfType] = {}
            end
            subTab = growRankPowerFactor[kfType]
            rankData = data.RankDatas or {}
            for index, factor in ipairs(rankData) do
                -- 第1位是0, 所以数据是从第2位开始的, 将索引减1对应到品质枚举值
                if index > 1 then
                    subTab[index - 1] = (factor or 0) / BATTLE_CONFIG
                end
            end
        end
    end
    -- 初始化档次系数表
    local grade = nil
    local TB_MatGrowUPAttrGrade = TableDataManager:GetInstance():GetTable("MatGrowUPAttrGrade")
    for _, data in pairs(TB_MatGrowUPAttrGrade) do
        grade = data.Grade
        growGradePowerFactor[grade] = (data.GrowFactor or 0) / BATTLE_CONFIG
    end
    local matDataManager = MartialDataManager:GetInstance()
    -- 分析武学成长条目的逻辑
    local genFunc = function(martialItemData, iIndex,iChangeInfo)
        local effectEnum = martialItemData['EffectEnum' .. iIndex]
        local attrEnum = martialItemData['AttrEnum' .. iIndex]
        local args = martialItemData['Effect' .. iIndex .. 'Value']
        local sAttr = ""
        local iValue = 0

        -- 变异替换属性
        if iStrongLevel == ENUM_MSEC_SUPER_CHANGE or iStrongLevel == ENUM_MSEC_SUPER_CHANGESTRONG then
            if effectEnum == MartialItemEffect.MTT_JUESECHENGZHANG or effectEnum == MartialItemEffect.MTT_WUXUECHENGZHANG then
                if iChangeInfo.index == 1 then 
                    attrEnum =instMartialData.uiAttr1
                    iChangeInfo.index = iChangeInfo.index + 1
                elseif iChangeInfo.index == 2 then 
                    attrEnum =instMartialData.uiAttr2
                    iChangeInfo.index = iChangeInfo.index + 1
                else
                    attrEnum =instMartialData.uiAttr3
                end
				if attrEnum == AttrType.MP_WEILI or attrEnum == AttrType.MP_WEILIXISHU or attrEnum == AttrType.MP_WEILIJIXIAN or attrEnum == AttrType.ATTR_WEILIXISHUDUGU or attrEnum == AttrType.MP_ZHAOHUANDIZIDENGJIZENGJIA then
					effectEnum = MartialItemEffect.MTT_WUXUECHENGZHANG;
				else
                    effectEnum = MartialItemEffect.MTT_JUESECHENGZHANG
                end
            end
        end
        -- 根据不同的枚举分析数据
        if effectEnum == MartialItemEffect.MTT_JUESECHENGZHANG then
            sAttr = GetEnumText('AttrType', attrEnum)
            iValue = self:GetMartialGrowValue(staticMartialData.DepartEnum,attrEnum,staticMartialData.Rank or 1)
        elseif effectEnum == MartialItemEffect.MTT_WUXUECHENGZHANG then
            local grade = martialItemData['Grade' .. iIndex]
            -- 陈辉加了个 威力系数 属性, 说显示就当威力处理
            if (attrEnum == AttrType.MP_WEILIXISHU) then
                -- 武学成长条目_增加武学威力
                sAttr = GetEnumText("AttrType", attrEnum)
                kfType = staticMartialData.DepartEnum
                iRank = staticMartialData.Rank or 1
                grade = martialItemData['Grade' .. iIndex]
                if growRankPowerFactor[kfType] and growRankPowerFactor[kfType][iRank] and growGradePowerFactor[grade] then
                    iValue = self:GetStaticMartialWeiLiXiShuGrow(staticMartialData.BaseID,1)
                    iValue = iValue * SKILL_SHOW_NUM_RATE
                end
            elseif attrEnum == AttrType.MP_ZHAOHUANDIZIDENGJIZENGJIA then
                sAttr = GetEnumText("AttrType", attrEnum)
                iValue = self:GetMartialGrowValue(staticMartialData.DepartEnum,attrEnum,staticMartialData.Rank or 1,TBoolean.BOOL_NO)
            elseif attrEnum > 0 then
                sAttr = '本武学' .. (GetEnumText("AttrType", attrEnum) or "missing attr text")
                iValue = args[1]
            end   
        end 

        local ret = sAttr
        if not iValue then return end
        local strSymbol = (iValue >= 0) and "+" or ""
        local bIsPerMyriad, bShowAsPercent = matDataManager:AttrValueIsPermyriad(attrEnum)
        if bIsPerMyriad then
            iValue = iValue / BATTLE_CONFIG
        end

        local StrongInc = 0
        local lStrongLevel = iStrongLevel
        if lStrongLevel > 0 then
            -- 根据属性查询加成幅度
            -- int64 _id = ((int64)(level) << 0) | ((int64)(rank) << 5) | ((int64)(attrs) << 15);
            local iMaxStrongLevel = matDataManager:GetMaxMartialStrongLevel()
            if lStrongLevel == ENUM_MSEC_SUPER_CLEAR then 
                StrongInc = -100
            elseif lStrongLevel == ENUM_MSEC_SUPER_STRONG or lStrongLevel == ENUM_MSEC_SUPER_CHANGESTRONG then 
                lStrongLevel = iMaxStrongLevel + 1
            elseif lStrongLevel == ENUM_MSEC_SUPER_CHANGE then
                lStrongLevel = iMaxStrongLevel
            end
            if lStrongLevel <= iMaxStrongLevel+1 then
                local id = lStrongLevel | (staticMartialData.Rank << 5) | (attrEnum << 15)
                local info = GetTableData("MartialStrongAttr",id)
                if info then 
                    StrongInc = info.Value or 0
                end
            end
        end
        if bShowAsPercent then
            local percent = iValue * (100 + StrongInc) 
            ret = ret .. string.format("%s%.1f%%", strSymbol, percent)
            if bShowAll ~= false and iLevel and (iLevel > 0) then
                ret = ret .. string.format("(累计%s%s%.1f%%)", sAttr, strSymbol, percent * iLevel)
            end
        else
            local fs = "%s%.1f"
            iValue = iValue * (1 + StrongInc/100)
            ret = ret .. string.format(fs, strSymbol, iValue )
            if bShowAll ~= false and iLevel and (iLevel > 0) then
                fs = "(累计%s%s%.1f)"
                ret = ret .. string.format(fs, sAttr, strSymbol, iValue * iLevel)
            end
        end
        return ret
    end
    -- 分析武学所有的成长条目
    local staticMatItemData = nil
    local matItemDesc = nil
    local growProIDs = staticMartialData.GrowProIDs
    if (not growProIDs) or (#growProIDs <= 0) then
        return refRetTable
    end
    local iChangeInfo = {index = 1}
    for index, id in ipairs(growProIDs) do
        staticMatItemData = TableDataManager:GetInstance():GetTableData("MartialItem", id)
        if not self:IfMartialItemHide(staticMatItemData) then
            matItemDesc = {}
            -- 如果武学条目存在自己的描述, 则使用武学条目的描述, 否则, 分析条目触发效果
            if staticMatItemData.DesID and (staticMatItemData.DesID > 0) then
                matItemDesc[1] = GetLanguageByID(staticMatItemData.DesID)
            else
                local index = 1
                local trigger = staticMatItemData['EffectEnum' .. index]
                while trigger and (trigger ~= MartialItemEffect.MIE_MartialItemEffectNull) do
                    -- 数据处理
                    matItemDesc[#matItemDesc + 1] = genFunc(staticMatItemData, index,iChangeInfo)
                    -- 继续检查下一个触发逻辑
                    index = index + 1
                    trigger = staticMatItemData['EffectEnum' .. index]
                end
            end
            -- 将分析出的条目描述拼接并加入总表
            refRetTable[#refRetTable + 1] = {
                -- 触发逻辑条目权重同等级(从1级开始), 阴阳权重是0, 
                -- 这里只做排序, 将成长插在阴阳与触发逻辑之间, 所以填个0.5就行
                ['sortKey'] = 0.5,
                ['state'] = "achieve",
                ['prefix'] = "每级",
                ['color'] = getUIColor('black'),
                ['colorTag'] = "<color=#FFFFFF>",
                ['desc'] = table.concat(matItemDesc, ',')
            }
        end
    end
    -- 将总表返回
    return refRetTable
end

-- 获取武学条目描述数据
----------------------------------------------
--  【1】内力阴性 内力阳性（在触发逻辑里）
--  【2】阳性、阴性加成系数（在 staticMartialData 里）
--  【3】成长逻辑（每级 巴拉巴拉）
--  【4】其他触发逻辑（X级 巴拉巴拉）
-----------------------------------------------
function MartialDataManager:GetMartialItemsDesc(staticMartialData, instMartialData, iFakeLevel, iFakeMaxLevel, bForceShowCond)
    if instMartialData then
        staticMartialData = GetTableData("Martial",instMartialData.uiTypeID)
    end
    if not staticMartialData then return end
    -- 描述总表
    local retTab = {}

    -- 分析阳性、阴性加成系数
    -- self:GenMartialFemMas(staticMartialData, instMartialData, retTab)
    -- 分析条目触发逻辑描述与状态
    self:GenMartialItemTriggerDesc(staticMartialData, instMartialData, iFakeLevel, iFakeMaxLevel, bForceShowCond, retTab)
    -- 分析条目成长逻辑与状态
    self:GenMartialItemGrowDesc(staticMartialData, instMartialData, retTab)
    -- 条目排序
    table.sort(retTab, function(a, b)
        return (a.sortKey or 0) < (b.sortKey or 0)
    end)
    return retTab
end

-- 阳性、阴性加成系数
function MartialDataManager:GenMartialFemMas(typeData, dynData, retTab)
    -- 如果没有传入条目描述总表, 新建一个
    if not retTab then 
        retTab = {} 
    end
    -- 如果传入动态数据, 静态数据以动态数据中的静态id为准
    if dynData then
        typeData = GetTableData("Martial",dynData.uiTypeID)
    end
    -- 如果获取不到必要数据, 直接返回总表
    if not typeData then 
        return retTab 
    end
    if typeData['MascCoef'] and typeData['MascCoef'] ~= 0 then	-- 阳性加成率
        local desc = string.format("受内力阳性加成 %.1f",typeData['MascCoef']/BATTLE_CONFIG)
        retTab[#retTab + 1] = {
            ['sortKey'] = 0.2,
            ['state'] = "achieve",
            ['prefix'] = "",
            ['color'] = getUIColor('yang'),
            ['colorTag'] = "<color=#EE6230>",
            ['desc'] = desc,
        }
    end
    
    if typeData['FemiCoef'] and typeData['FemiCoef'] ~= 0 then	-- 阴性加成率
        local desc = string.format("受内力阴性加成 %.1f",typeData['FemiCoef']/BATTLE_CONFIG)
        retTab[#retTab + 1] = {
            ['sortKey'] = 0.2,
            ['state'] = "achieve",
            ['prefix'] = "",
            ['color'] = getUIColor('yin'),
            ['colorTag'] = "<color=#669ABA>",
            ['desc'] = desc,
        }
    end
    return retTab
end

-- 获取技能攻击范围，按武学等级，范围可能会升级（例如狮吼功的 矩形 → 全体）
function MartialDataManager:GetSkillAttackRange(martialRangeID, level)
    local iRangeID = 0
    if martialRangeID == 0 then
        martialRangeID = 100
    end
    local TB_MartialRange = TableDataManager:GetInstance():GetTable("MartialRange")
    local martialRangeData = TB_MartialRange[martialRangeID]
    if martialRangeData  == nil then
        derror("TB_MartialRange: martialRangeID is nil ", martialRangeID)
        return iRangeID
    end

    if martialRangeData.AttackRangeIDs then
        iMartialLevel = Clamp(level, 1, #martialRangeData.AttackRangeIDs)
        iRangeID = martialRangeData.AttackRangeIDs[iMartialLevel]
    else
        derror("TB_MartialRange AttackRangeIDs is nil  ", martialRangeID)
    end
    return iRangeID
end

-- 一条属性的值 [是否是万分比值, 是否要显示为百分比]
function MartialDataManager:AttrValueIsPermyriad(attrEnum, isMainRoleAttr)
    -- 现在武学属性和角色属性枚举都合并到了AttrType, 所以角色属性也可以使用这个接口判断
    if not attrEnum then return false, false end
    local data
    if isMainRoleAttr then
        local TB_MainRoleDataIsPercent = TableDataManager:GetInstance():GetTable("MainRoleDataIsPercent")
        data = TB_MainRoleDataIsPercent[attrEnum]
    else
        data = TableDataManager:GetInstance():GetTableData("AttrIsPercent", attrEnum)
        -- data = TB_AttrIsPercent[attrEnum]
    end
    if not data then return false, false end
    local bIsPerMyriad = data.PerMyriad == TBoolean.BOOL_YES
    local bShowAsPercent = data.ShowAsPercent == TBoolean.BOOL_YES
    return bIsPerMyriad, bShowAsPercent
end

-- 获取技能效果多段次数
function MartialDataManager:GetSkillMultiStepCount(effectID)
    local res = 1
    if not effectID then return res end
    local effectData = TableDataManager:GetInstance():GetTableData("SkillEffect",effectID)
    if not effectData then return res end
    local effectType = effectData.Name or SkillEffectDescription.SED_Null
    local argPos = 1
    local argData = nil
    local TB_Multistage = TableDataManager:GetInstance():GetTable("Multistage")
    for index, data in ipairs(TB_Multistage) do
        if effectType == data.EffectDescription then
            argPos = data.MultistagePosition or 1
            argData = effectData['EventArg' .. argPos] or {}
            res = (argData[1] or 10000) / BATTLE_CONFIG
        end
    end
    return res
end

function MartialDataManager:FillPlaceholder(str, iDamageCount,iDamageValue,CureValue,CatapultTimes)
    if not str or type(str) ~= 'string' then
        return ''
    end

    if not iDamageCount then
        iDamageCount = 0
    end

    if not iDamageValue then
        iDamageValue = 0
    end

    if not CatapultTimes then
        CatapultTimes = 0
    end
    
    if not CureValue then
        CureValue = 0
    end
    local damagestr = 0
    local iDiffValue = math.floor(CureValue - iDamageValue) 
    if iDiffValue == 0 then
        damagestr = iDamageValue
    elseif iDiffValue > 0 then
        damagestr = string.format("%d<color=#6CD458>(+%d)</color>",math.floor(iDamageValue),iDiffValue)
    elseif iDiffValue < 0 then
        damagestr = string.format("%d<color=#FF0000>(%d)</color>",math.floor(iDamageValue),iDiffValue)
    end

    local ans = string.gsub(string.gsub(string.gsub(str, "%[DamageCount%]", math.floor(iDamageCount)), "%[DamageValue%]", damagestr), "%[CureValue%]", math.floor(CureValue))
    return string.gsub(ans, "%[TanSheCount%]",CatapultTimes)
end
-- 获取实例技能的武学属性
function MartialDataManager:GetMartialAttrValue(martialData,iattr)
    if not martialData or not iattr then 
        return 0 
    end 
    if martialData.akMartialAttrs then 
        for i,v in pairs(martialData.akMartialAttrs ) do  
            if v.uiType == iattr then  
                return v.iValue or 0
            end 
        end 
    end
    return 0
    -- TODO: 模板数据

end

--获取实例武学MartialInfluence属性
function MartialDataManager:GetMartialInfluencesAttr(martialData,iattr)
    if not martialData or not iattr then 
        return 0 
    end 
    local total = 0
    if martialData.akMartialInfluences then 
        for i,v in pairs(martialData.akMartialInfluences ) do  
            if v.uiAttrType == iattr then  
                total = total + v.uiMartialValue or 0
            end
        end
    end
    return total
end

--获取静态技能威力 -- 初始 
function MartialDataManager:GetStaticMartialWeiLiXiShuBase(martialTypeID,level)
    if not martialTypeID then
        return 0
    end

    local martialRank = nil
    local martialDepart = nil
    local martialGrade = nil

    local gradeFactor = nil
    local rankFactor = nil

    local staticMartialData = GetTableData("Martial",martialTypeID)

    if not staticMartialData then
        return 0
    end
    
    martialRank = staticMartialData.Rank
    martialDepart = staticMartialData.DepartEnum
   -- 获取武学档次
    for index = 1, #staticMartialData.GrowProIDs do
        local martialItemID = staticMartialData.GrowProIDs[index]
        local martialItem = TableDataManager:GetInstance():GetTableData("MartialItem", martialItemID)
        if martialItem.AttrEnum1 == AttrType.MP_WEILIXISHU then
             if martialItem.Grade1 ~= Grade.GA_GradeNull then
                martialGrade = martialItem.Grade1
                break
            end
        end
    end
    -- 获取武学档次的 威力系数/成长威力系数
    local TB_MatGrowUPAttrGrade = TableDataManager:GetInstance():GetTable("MatGrowUPAttrGrade")
    if martialGrade then
        for _, data in pairs(TB_MatGrowUPAttrGrade) do
            if martialGrade == data.Grade then
                gradeFactor = (data.Factor or 0) / BATTLE_CONFIG
                break
            end
        end
    end

     -- 获取武学品质和系别的 威力系数/成长威力系数
     local TB_KungfuBase = TableDataManager:GetInstance():GetTable("KungfuBase")
     for _, data in pairs(TB_KungfuBase) do
        if data.AttrType == AttrType.MP_WEILIXISHU then
            if data.IsGrowup ~= TBoolean.BOOL_YES and data.KfType == martialDepart then 
                rankFactor = (data.RankDatas[martialRank + 1] or 0) / BATTLE_CONFIG
                break
            end
        end
    end

    gradeFactor = gradeFactor or 1
    rankFactor = rankFactor or 1
    
    return (gradeFactor * rankFactor) * BATTLE_CONFIG
end

function MartialDataManager:GetMartialGrowValue(eDepartType,eAttrType,eRankType,isRoleAttr)
	-- 首先根据属性类型/武学系别,角色属性还是成长得出来一个ID
	local pkKungfuBase = self:GetKungfuBaseData(eAttrType, eDepartType,isRoleAttr)
	if not pkKungfuBase then
		return 0;
    end
	if (eRankType < 1 or eRankType > #pkKungfuBase.RankDatas) then 
		return 0;
    end
	return pkKungfuBase.RankDatas[eRankType+1];
end
--获取静态技能威力 -- 成长
function MartialDataManager:GetStaticMartialWeiLiXiShuGrow(martialTypeID,level,martialData)
    if not martialTypeID then
        return 0
    end

    local martialRank = nil
    local martialDepart = nil
    local martialGrade = nil

    local gradeGrowFactor = nil
    local rankGrowFactor = nil
    local staticMartialData = GetTableData("Martial",martialTypeID)

    if not staticMartialData then
        return 0
    end

    martialRank = staticMartialData.Rank
    martialDepart = staticMartialData.DepartEnum
    if martialData and martialData.iStrongLevel == ENUM_MSEC_SUPER_CLEAR then 
        return 0 -- 入魔直接返回0
    end
    if martialData and martialData.iStrongLevel == ENUM_MSEC_SUPER_CHANGE then 
        -- 威力变异，直接取中
        if martialData.uiAttr1 == AttrType.MP_WEILIXISHU or martialData.uiAttr2 == AttrType.MP_WEILIXISHU or martialData.uiAttr3 == AttrType.MP_WEILIXISHU then 
            martialGrade = Grade.GA_Medium
        else
            martialGrade = Grade.GA_GradeNull
        end
    end

    if martialGrade == nil then 
        -- 获取武学档次
        for index = 1, #staticMartialData.GrowProIDs do
            local martialItemID = staticMartialData.GrowProIDs[index]
            local martialItem = TableDataManager:GetInstance():GetTableData("MartialItem", martialItemID)
            if martialItem.AttrEnum1 == AttrType.MP_WEILIXISHU then
                if martialItem.Grade1 ~= Grade.GA_GradeNull then
                    martialGrade = martialItem.Grade1
                    break
                end
            end
        end
    end
    -- 获取武学档次的 威力系数/成长威力系数
    if martialGrade then
        local TB_MatGrowUPAttrGrade = TableDataManager:GetInstance():GetTable("MatGrowUPAttrGrade")
        for _, data in pairs(TB_MatGrowUPAttrGrade) do
            if martialGrade == data.Grade then
                gradeGrowFactor = (data.GrowFactor or 0) / BATTLE_CONFIG
                break
            end
        end
    end
    -- 获取武学品质和系别的 威力系数/成长威力系数
    local TB_KungfuBase = TableDataManager:GetInstance():GetTable("KungfuBase")
    for _, data in pairs(TB_KungfuBase) do
        if data.AttrType == AttrType.MP_WEILIXISHU then
            if data.IsGrowup == TBoolean.BOOL_YES and data.KfType == martialDepart then 
                rankGrowFactor = (data.RankDatas[martialRank + 1] or 0) / BATTLE_CONFIG
                break
            end
        end
    end

    gradeGrowFactor = gradeGrowFactor or 0
    rankGrowFactor = rankGrowFactor or 0
    --取小数点后3位
    local iValue = math.floor(gradeGrowFactor * rankGrowFactor * BATTLE_CONFIG / 10 + 0.5) * 10
    local result = level * iValue
    if martialData then 
        local iStrongLevel = martialData.iStrongLevel or 0
        local maxLevel = MartialDataManager:GetInstance():GetMaxMartialStrongLevel()
        if iStrongLevel == ENUM_MSEC_SUPER_STRONG or iStrongLevel == ENUM_MSEC_SUPER_CHANGESTRONG then 
            iStrongLevel = maxLevel + 1
        elseif iStrongLevel == ENUM_MSEC_SUPER_CHANGE then
            iStrongLevel = maxLevel
        end
        local id = iStrongLevel | (martialRank << 5) | (AttrType.MP_WEILIXISHU  << 15)
        local info = GetTableData("MartialStrongAttr",id)
        if info then 
            result = result * (1 + (info.Value or 0)/100)
        end
    end
    return result
end
--获取静态技能威力
function MartialDataManager:GetStaticMartialWeiLiXiShu(martialTypeID,skillid,level,fpowerpercent,martialData)
    if not martialTypeID then
        return 0
    end

    local staticMartialData = GetTableData("Martial",martialTypeID)

    if not staticMartialData then
        return 0
    end

    
    local martialRank = staticMartialData.Rank
    local martialDepart = staticMartialData.DepartEnum


    level = level or 1
    local intFinalWeiLiXiShu = 0
    local intGrowWeiLiXiShu = MartialDataManager:GetInstance():GetStaticMartialWeiLiXiShuGrow(martialTypeID,level,martialData)
    
    local intBaseWeiLiXiShu = MartialDataManager:GetInstance():GetStaticMartialWeiLiXiShuBase(martialTypeID,level)

    fpowerpercent = fpowerpercent or 0

    local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillid)
    if not kSKillData then
        return 0
    end

    if kSKillData.Type == SkillType.SkillType_lianzhao then 
        -- 连招加的基础威力 
        for i,marmovid in pairs(staticMartialData.MartMovIDs) do 
            local MartialItem = TableDataManager:GetInstance():GetTableData("MartialItem", marmovid)
            local skillID1 = MartialItem and MartialItem.SkillID1
            local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillID1)
            if skillID1 ==  skillid then
                intBaseWeiLiXiShu = intBaseWeiLiXiShu * self:GetSkillDepartPowerEft(kSKillData.Type,i)
                break
            end
        end
    else 
        intBaseWeiLiXiShu = intBaseWeiLiXiShu * self:GetSkillDepartPowerEft(kSKillData.Type,0)
    end 
    intFinalWeiLiXiShu = intBaseWeiLiXiShu * (1 + fpowerpercent) + intGrowWeiLiXiShu

    -- -- 显示衰减倍数
    -- local intMartialPowerCutTimes = TB_BattleConfig[1]['MartialPowerCutTimes'] or 1
    -- local intpowerdepart  --TODO:

    -- for _, data in pairs(TB_KungfuBase) do
    --     if data.AttrType == AttrType.ATTR_JICHU_WEILIXISHU then
    --         if data.IsGrowup ~= TBoolean.BOOL_YES and data.KfType == martialDepart then 
    --             intpowerdepart = (data.RankDatas[martialRank + 1] or 0) 
    --             break
    --         end
    --     end
    -- end
    -- intpowerdepart = intpowerdepart or 10000

    -- intFinalWeiLiXiShu = intpowerdepart + (intFinalWeiLiXiShu / intMartialPowerCutTimes)
    return intFinalWeiLiXiShu
end
--获取技能类型影响的威力系数倍数
function MartialDataManager:GetSkillDepartPowerEft(skillType,lianzhao)
    local SkillDepartPowerEftData = TableDataManager:GetInstance():GetTable("SkillDepartPowerEft")
    for i,dataline in ipairs(SkillDepartPowerEftData) do 
        if dataline.Type == skillType then 
            if lianzhao == dataline.LianZhao then 
                return dataline.Factor / BATTLE_CONFIG
            end 
        end 
    end 
    return 1
end 
--获取实例技能初始威力系数，直接乘上 展示的倍数 即为显示的基础威力系数
function MartialDataManager:GetMartialWeiLiXiShuBase(martialData,skillID)
    if not martialData  then 
        return 0 
    end 

    local iattr = AttrType.MP_WEILIXISHU
    local number_rate = 1
    local base_num = 0
    local total = 0
    local BaseData = GetTableData("Martial",martialData.uiTypeID)
    if martialData.akMartialInfluences then 
        for i,v in pairs(martialData.akMartialInfluences ) do  
            if v.uiAttrType == iattr then 
                if v.uiMartialInit == 1 then  
                    base_num =  v.uiMartialValue or 0
                else 
                    total = total + (v.uiMartialValue or 0)
                end 
            end
        end
    end

    local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
    if not kSKillData then
        return total + base_num 
    end


    if kSKillData.Type == SkillType.SkillType_lianzhao then 
        -- 连招加的基础威力 
        for i,marmovid in pairs(BaseData.MartMovIDs) do 
            local MartialItem = TableDataManager:GetInstance():GetTableData("MartialItem", marmovid)
            local skillID1 = MartialItem and MartialItem.SkillID1
            local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillID1)
            if skillID1 ==  skillID then
                base_num = base_num * self:GetSkillDepartPowerEft(kSKillData.Type,i)
                break
            end
        end
        total = total + base_num 
    else 
        -- 绝招和奥义加的总的威力系数
        total = total + base_num
        total = total * self:GetSkillDepartPowerEft(kSKillData.Type,0)
    end 

    return total


end 
--获取实例技能威力
function MartialDataManager:GetMartialWeiLiXiShu(martialData,skillID)
    if not martialData  then 
        return 0 
    end 

    local iattr = AttrType.MP_WEILIXISHU
    local number_rate = 1
    local base_num = 0
    local total = self:GetStaticMartialWeiLiXiShuBase(martialData.uiTypeID,martialData.uiLevel)
    
    local BaseData = GetTableData("Martial",martialData.uiTypeID)
    if martialData.akMartialInfluences then 
        for i,v in pairs(martialData.akMartialInfluences ) do  
            if v.uiAttrType == iattr then 
                if v.uiMartialInit == 1 then  
                    base_num =  v.uiMartialValue or 0
                else 
                    total = total + (v.uiMartialValue or 0)
                end 
            end
        end
    end

    local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
    if not kSKillData then
        return total + base_num 
    end


    if kSKillData.Type == SkillType.SkillType_lianzhao then 
        -- 连招加的基础威力 
        for i,marmovid in pairs(BaseData.MartMovIDs) do 
            local MartialItem = TableDataManager:GetInstance():GetTableData("MartialItem", marmovid)
            local skillID1 = MartialItem and MartialItem.SkillID1
            local kSKillData = TableDataManager:GetInstance():GetTableData("Skill", skillID1)
            if skillID1 ==  skillID then
                base_num = base_num * self:GetSkillDepartPowerEft(kSKillData.Type,i)
                break
            end
        end
        total = total + base_num 
    else 
        -- 绝招和奥义加的总的威力系数
        total = total + base_num
        total = total * self:GetSkillDepartPowerEft(kSKillData.Type,0)
    end 

    return total
end

-- 获取实例威力百分比
function MartialDataManager:GetMartialWeiLiBaiFenBi(martialData,skillid)
    if not martialData  then 
        return 0 
    end 
    local iattr = AttrType.ATTR_WEILIBAIFENBI
    local number_rate = 1
    local base_num = 0
    local total = 0
    
    local BaseData = GetTableData("Martial",martialData.uiTypeID)
    if martialData.akMartialInfluences then 
        for i,v in pairs(martialData.akMartialInfluences ) do  
            if v.uiAttrType == iattr then 
                if v.uiMartialInit == 1 then  
                    base_num =  v.uiMartialValue or 0
                else 
                    total = total + (v.uiMartialValue or 0)
                end 
            end
        end
    end

    return base_num + total
end 

-- 获取技能消耗的真气
function MartialDataManager:GetSkillMPCost(skillBaseData, martialLevel, roleData)
    if skillBaseData == nil or martialLevel == nil then 
        return 0, 0
    end
    local baseCostPercent = skillBaseData.MPBaseCostPercent or 0
    local levelCostPercent = skillBaseData.MPCostPercentLevel or 0
    local costPercent = baseCostPercent + (martialLevel * levelCostPercent)
    local maxMP = 0
    if roleData then 
        maxMP = roleData:GetAttr(AttrType.ATTR_MAXMP) or 0
    end
    local costValue = math.floor(maxMP * costPercent / 100)
    return costPercent, costValue
end

local gongji_map = {
    [0] = AttrType.ATTR_NULL, -- -
    [91] = AttrType.ATTR_YISHUATK, -- 医术
    [150] = AttrType.ATTR_NULL, -- 轻功
    [148] = AttrType.ATTR_NEIGONGATK, -- 内功
    [87] = AttrType.ATTR_ANQIATK, -- 暗器
    [149] = AttrType.ATTR_QIMENATK, -- 奇门
    [152] = AttrType.ATTR_TUIFAATK, -- 腿法
    [146] = AttrType.ATTR_DAOFAATK, -- 刀法
    [147] = AttrType.ATTR_JIANFAATK, -- 剑法
    [151] = AttrType.ATTR_QUANZHANGATK, -- 拳掌
}
local jingtong_map = {
    [0] = AttrType.ATTR_NULL, -- -
    [91] = AttrType.ATTR_YISHUJINGTONG, -- 医术
    [150] = AttrType.ATTR_NULL, -- 轻功
    [148] = AttrType.ATTR_NEIGONGJINGTONG, -- 内功
    [87] = AttrType.ATTR_ANQIJINGTONG, -- 暗器
    [149] = AttrType.ATTR_QIMENJINGTONG, -- 奇门
    [152] = AttrType.ATTR_TUIFAJINGTONG, -- 腿法
    [146] = AttrType.ATTR_DAOFAJINGTONG, -- 刀法
    [147] = AttrType.ATTR_JIANFAJINGTONG, -- 剑法
    [151] = AttrType.ATTR_QUANZHANGJINGTONG, -- 拳掌
}

-- 获取静态技能伤害值 (表现用)
function MartialDataManager:GetStaticSkillDamageValue(martialID,skillid,martialLevel)
    local int_ret = 1
    local ipower = 0 
    ipower = self:GetStaticMartialWeiLiXiShu(martialID,skillid,martialLevel) or 0
    ipower = ipower / BATTLE_CONFIG

    -- int_ret = int_ret * ipower 
    local number_xibie_damagevalue =  1000 -- 武学系别攻击力
    local number_base_damagevalue = 0 -- number_角色基本攻击力 = 0
    local number_final_ex_damagevalue_rate = 1 -- 最终伤害附加百分比
    local number_final_ex_damagevalue = 0 -- 最终伤害附加值 = 0
    local number_neili_yang = 0 -- number_内力阳性 = 0
    local number_neili_yin = 0 -- number_内力阴性 = 0
    local number_jingtong_martial = 0 -- int_攻击者武学精通值 = 0

    local int_role_base_damage = number_xibie_damagevalue + number_base_damagevalue
    local int_base_damage = math.max(1,int_role_base_damage)
    local int_base_damage_value = int_base_damage
    int_base_damage_value = int_base_damage_value * 1 * ipower--+ number_基础附加值

    local TB_BattleConfig = TableDataManager:GetInstance():GetTable("BattleConfig")
    local int_yingyanghurt = TB_BattleConfig[1].YingYangHurt or 20
    number_final_ex_damagevalue_rate = number_final_ex_damagevalue_rate + (number_neili_yang  + number_neili_yin ) * int_yingyanghurt
    local int_DamageMinPer = TB_BattleConfig[1].DamageMinPer or 200
    local int_BATTLE_KUNGFU_JINGTONG = 0.000005 -- TB_BattleConfig[1].KungFuJingTongPer or 0.000005
    local int_SHOW_SKILL_HURT_PROPORTION = TB_BattleConfig[1].ShowSkillHurtProportion or 10000
    int_SHOW_SKILL_HURT_PROPORTION = int_SHOW_SKILL_HURT_PROPORTION / BATTLE_CONFIG
    number_final_ex_damagevalue_rate = number_final_ex_damagevalue_rate + int_BATTLE_KUNGFU_JINGTONG * number_jingtong_martial
    int_ret = int_base_damage_value * number_final_ex_damagevalue_rate + number_final_ex_damagevalue
    int_ret = math.min(int_ret,int_role_base_damage * int_DamageMinPer)
    return int_ret * int_SHOW_SKILL_HURT_PROPORTION
end

-- 获取技能伤害值
function MartialDataManager:GetSkillDamageValue(roleData,martialData,departEnumLanguageID,departEnum,iRank)
    local int_ret = 1
    if roleData then  
        local TB_BattleConfig = TableDataManager:GetInstance():GetTable("BattleConfig")
        local ipower = self:GetMartialInfluencesAttr(martialData,AttrType.MP_WEILIXISHU) or 0 
        local iRankDatas = 0
        if departEnum then
            local baseid =  AttrType.ATTR_JICHU_WEILIXISHU << 0 | departEnum << 10 
            local kungfuBase = TableDataManager:GetInstance():GetTableData("KungfuBase",baseid)
            if kungfuBase then
                iRankDatas = kungfuBase.RankDatas[iRank + 1] or 0
            end
        end

        ipower = ipower / BATTLE_CONFIG / TB_BattleConfig[1].MartialPowerCutTimes + iRankDatas / BATTLE_CONFIG

        -- int_ret = int_ret * ipower 
        local number_xibie_damagevalue =  1000 -- 武学系别攻击力
        local number_base_damagevalue = 0 -- number_角色基本攻击力 = 0
        local number_final_ex_damagevalue_rate = 1 -- 最终伤害附加百分比
        local number_final_ex_damagevalue = 0 -- 最终伤害附加值 = 0
        local number_neili_yang = 0 -- number_内力阳性 = 0
        local number_neili_yin = 0 -- number_内力阴性 = 0
        local number_jingtong_martial = 0 -- int_攻击者武学精通值 = 0
        if roleData.aiAttrs then 
            local int_temp = gongji_map[departEnumLanguageID]
            number_xibie_damagevalue = roleData.aiAttrs[int_temp] or number_jingtong_martial -- 系别
            int_temp = AttrType['ATTR_MARTIAL_ATK']
            number_base_damagevalue = roleData.aiAttrs[int_temp] or number_base_damagevalue
            int_temp = AttrType['MP_ZUIZHONGSHANGHAIFUJIABAIFENBI']
            number_final_ex_damagevalue_rate = roleData.aiAttrs[int_temp] or number_final_ex_damagevalue_rate
            int_temp = AttrType['MP_ZUIZHONGSHANGHAIFUJIAZHI']
            number_final_ex_damagevalue = roleData.aiAttrs[int_temp] or number_final_ex_damagevalue
            int_temp = AttrType['ATTR_NEILIYANGXING']
            number_neili_yang = roleData.aiAttrs[int_temp] or number_neili_yang
            int_temp = AttrType['ATTR_NEILIYINXING']
            number_neili_yin = roleData.aiAttrs[int_temp] or number_neili_yin
            int_temp = jingtong_map[departEnumLanguageID]
            number_jingtong_martial = roleData.aiAttrs[int_temp] or number_jingtong_martial
        end 

        local int_role_base_damage = number_base_damagevalue * TB_BattleConfig[1].AtkRate / BATTLE_CONFIG + TB_BattleConfig[1].BaseAtk
        local int_base_damage = math.max(1,int_role_base_damage)
        local int_base_damage_value = int_base_damage
        int_base_damage_value = int_base_damage_value  * ipower--+ number_基础附加值
    

        local int_yingyanghurt = (TB_BattleConfig[1].YingYangHurt or 20) / BATTLE_CONFIG
        local kfTypeData = TableDataManager:GetInstance():GetTableData("Kftype",departEnum)
        local meridiansAddPercent = 0
        if kfTypeData then
            meridiansAddPercent = MeridiansDataManager:GetInstance():GetDepartEnumAddPercent(kfTypeData.id)
        end
        number_final_ex_damagevalue_rate = number_final_ex_damagevalue_rate + (number_neili_yang  + number_neili_yin ) * int_yingyanghurt + meridiansAddPercent
        local int_DamageMinPer = (TB_BattleConfig[1].DamageMinPer or 200) /BATTLE_CONFIG
        local int_BATTLE_KUNGFU_JINGTONG = (TB_BattleConfig[1].KungFuJingTongPer or 1)/ BATTLE_CONFIG  / BATTLE_CONFIG
        local int_SHOW_SKILL_HURT_PROPORTION = (TB_BattleConfig[1].ShowSkillHurtProportion or 1) / BATTLE_CONFIG
 
        number_final_ex_damagevalue_rate = number_final_ex_damagevalue_rate + int_BATTLE_KUNGFU_JINGTONG * number_jingtong_martial
        int_ret = int_base_damage_value * number_final_ex_damagevalue_rate + number_final_ex_damagevalue
        int_ret = math.max(int_ret,int_role_base_damage * int_DamageMinPer)
        return math.floor(int_ret * int_SHOW_SKILL_HURT_PROPORTION + 0.5) 
    end
    return math.floor(int_ret + 0.5)

    -- local numbers者武学精通值 = G.call('角色_获取角色属性当前值',o_role_攻击者,o_kungfu_武学 and o_kungfu_武学.系别.对应属性)
end

function MartialDataManager:InitAoYiTable()
    local TB_Aoyi = TableDataManager:GetInstance():GetTable('AoYi');
    local martial2AoYiAndLvl = {};
    for k, v in pairs(TB_Aoyi) do
        for kk, vv in pairs(v.MartialList) do
            if not martial2AoYiAndLvl[vv] then
                martial2AoYiAndLvl[vv] = {};
            end
            if not martial2AoYiAndLvl[vv][k] then
                martial2AoYiAndLvl[vv][k] = {};
            end
            martial2AoYiAndLvl[vv][k] = v.LVList[kk];
        end
    end
    self.martial2AoYiAndLvl = martial2AoYiAndLvl;
end

function MartialDataManager:GetAoYiTable()
    return self.martial2AoYiAndLvl or {};
end

function MartialDataManager:CheckRoleMartialNum(uiID)
    local iLearnedNum = RoleDataManager:GetInstance():GetRoleMartialNum(uiID) or 0
    local iMaxNum = RoleDataManager:GetInstance():GetMartialNumMax(uiID) or 0
    return iLearnedNum < iMaxNum
end

-- 是否开启武学研读系统
function MartialDataManager:OpenMakeMartialStrong()
    if self._openMartialStrong == nil then 
        self._openMartialStrong = false
        local curStoryID = GetCurScriptID()
        local info = GetTableData("Story",curStoryID)
        if info then 
            if info.OpenMartialStrong == TBoolean.BOOL_YES then 
                local commonConfigTable = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
                if (commonConfigTable ~= nil) then
                    local difficultValue = RoleDataManager:GetInstance():GetDifficultyValue()
                    if difficultValue >= (commonConfigTable.OpenMartialStrongLevel or 1) then 
                        self._openMartialStrong = true
                    end
                end
            end
        end
    end
    return self._openMartialStrong
end

-- 是否开启武学抄录系统
function MartialDataManager:OpenMakeMartialSecret()
    if self._openMartialSecret == nil then 
        self._openMartialSecret = false
        local curStoryID = GetCurScriptID()
        local info = GetTableData("Story",curStoryID)
        if info then 
            if info.OpenMakeSecret == TBoolean.BOOL_YES then 
                self._openMartialSecret = true
            end
        end
    end
    return self._openMartialSecret
end

-- 是否开启武学抄录系统
function MartialDataManager:MartialCouldMake(typeData)
    if self:OpenMakeMartialSecret() and typeData and typeData.CouldCopy ~= TBoolean.BOOL_NO then 
        return true
    end
    return false
end

function MartialDataManager:Clear()
    self._openMartialStrong = nil
    self._openMartialSecret = nil
end

function MartialDataManager:GetMartialMaxColdTime(martialBaseID)
    local martialBaseData = TableDataManager:GetInstance():GetTableData("Martial", martialBaseID)
    if not martialBaseData then 
        return 0
    end
    return martialBaseData.ColdTime or 0
end

function MartialDataManager:GetMartialConfig(martialBaseID, clanBaseID)
    local martialBaseData = GetTableData("Martial", martialBaseID)
    if not martialBaseData then
        return nil
    end
    local martialConfigTable = TableDataManager:GetInstance():GetTable("MartialConfig")
    if not martialConfigTable then
        return nil
    end
    for _, martialConfig in pairs(martialConfigTable) do 
        if martialConfig.ClanID == clanBaseID and martialConfig.Rank == martialBaseData.Rank then
            return martialConfig
        end
    end
    return nil
end

function MartialDataManager:GetMartialLearnCondition(martialBaseID, clanBaseID, checkMartialConfig)
    local martialBaseData = GetTableData("Martial", martialBaseID)
    if not martialBaseData then
        return {}, {}
    end

    local condTypeList = {}
    local condValueList = {}
    -- 门派武学学习条件
    if checkMartialConfig then 
        local martialConfig = self:GetMartialConfig(martialBaseID, clanBaseID)
        if not martialConfig then 
            return condTypeList, condValueList
        end
        local curStoryID = GetCurScriptID()
        -- 自由模式
        if curStoryID == 7 then
            if RoleDataManager:GetInstance():GetMainRoleClanTypeID() == clanBaseID then
                for index, condType in ipairs(martialConfig.SelfConfigFree) do 
                    table.insert(condTypeList, condType)
                    table.insert(condValueList, martialConfig.SelfParamFree[index])
                end
            else
                for index, condType in ipairs(martialConfig.OtherConfigFree) do 
                    table.insert(condTypeList, condType)
                    table.insert(condValueList, martialConfig.OtherParamFree[index])
                end
            end
        else
            if RoleDataManager:GetInstance():GetMainRoleClanTypeID() == clanBaseID then
                for index, condType in ipairs(martialConfig.SelfConfig) do 
                    table.insert(condTypeList, condType)
                    table.insert(condValueList, martialConfig.SelfParam[index])
                end
            else
                for index, condType in ipairs(martialConfig.OtherConfig) do 
                    table.insert(condTypeList, condType)
                    table.insert(condValueList, martialConfig.OtherParam[index])
                end
            end
        end
    end
    
    -- 武学基础学习条件
    if martialBaseData.LearnCondition and martialBaseData.LearnConditionValue then 
        for index, condType in ipairs(martialBaseData.LearnCondition) do 
            table.insert(condTypeList, condType)
            table.insert(condValueList, martialBaseData.LearnConditionValue[index])
        end
    end
    return condTypeList, condValueList
end

function MartialDataManager:IsJingTongConditionType(conditionType)
    if conditionType ~= nil and l_MartialConditionTypeToAttrTypeMap[conditionType] ~= nil then 
        return true
    end
    return false
end

function MartialDataManager:CheckJingTongCondition(conditionType, conditionValue, roleID)
    if not self:IsJingTongConditionType(conditionType) then 
        return false
    end
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if not roleData then 
        return false
    end
    local attrType = l_MartialConditionTypeToAttrTypeMap[conditionType]
    return roleData:GetAttr(attrType) >= conditionValue
end

local function GetClanDisposition(clanBaseID)
    -- 五岳宗 分支好感度 
    if clanBaseID == 97 or clanBaseID == 45 then
        clanBaseID = 12
    end
    -- 天阴教好感度
    if clanBaseID == 49 or clanBaseID == 98 then
        clanBaseID = 15
    end
    return ClanDataManager:GetInstance():GetDisposition(clanBaseID) or 0
end

-- 获取燃木令数量
local function GetRanMuLingItemCount()
    local clanMartialUI = GetUIWindow('ClanMartialUI')
    if clanMartialUI and clanMartialUI:GetTag_ZANGJINGGE() then
        local ranMuLingItemBaseID = 80603
        return ItemDataManager:GetInstance():GetItemNumByTypeID(ranMuLingItemBaseID)
    else
        -- 不在藏经阁 燃木令的判断就直接通过
        return 9999
    end
end

local function GetMainRoleGoodEvilValue()
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if mainRoleData then
        return mainRoleData['iGoodEvil']
    else
        return 0
    end
end

function MartialDataManager:CheckMartialLearnConditionByType(clanBaseID, martialBaseID, conditionType, conditionValue, roleID)
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    roleID = roleID or mainRoleID
    local isMainRole = (roleID == mainRoleID)
    if isMainRole and conditionType == ClanMartialConfig.CMT_HaoGanDu then
        return GetClanDisposition(clanBaseID) >= conditionValue
    elseif isMainRole and conditionType == ClanMartialConfig.CMT_RanMuLing then
        return GetRanMuLingItemCount() >= conditionValue
    elseif isMainRole and conditionType == ClanMartialConfig.CMT_RenYiZhi then
        if conditionValue < 0 then
            return GetMainRoleGoodEvilValue() <= conditionValue
        else
            return GetMainRoleGoodEvilValue() >= conditionValue
        end
    elseif self:IsJingTongConditionType(conditionType) then
        return self:CheckJingTongCondition(conditionType, conditionValue, roleID or mainRoleID)
    end 
    return false
end

function MartialDataManager:GetMartialLearnConditionTypeText(conditionType)
    return l_MartialConditionTypeToString[conditionType] or ''
end