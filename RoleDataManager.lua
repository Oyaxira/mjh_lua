RoleDataManager = class("RoleDataManager")
RoleDataManager._instance = nil
reloadModule('UI/Role/RoleDataHelper')
local giveRoleTypeID = 1000001370;
local ROLE_DATA_INIT_VALUE = {
    uiID = 0,
    uiTypeID = 0,
    uiSex = 0,
    uiNameID = 0,
    uiFamilyNameID = 0,
    uiFirstNameID = 0,
    uiTitleID = 0,
    uiPostFixNameID = 0,
    uiLevel = 0,
    uiClanID = 0,
    uiHP = 0,
    uiMP = 0,
    uiExp = 0,
    uiRemainAttrPoint = 0,
    uiFragment = 0,
    uiOverlayLevel = 0,
    iGoodEvil = 200,
    uiRemainGiftPoint = 0,
    uiModelID = 0,
    uiRank = 0,
    uiMartialNum = 0,
    uiGiftNum = 0,
    uiEatFoodNum = 0,
    uiEatFoodMaxNum = 0,
    uiMarry = {},
    uiSubRole = 0,
}

local g_basicAttrMap = {
    -- 生命
    [AttrType.ATTR_MAXHP] = true,
    -- 真气
    [AttrType.ATTR_MAXMP] = true,
    -- 防御
    [AttrType.ATTR_DEF] = true,
    -- 武学攻击
    [AttrType.ATTR_MARTIAL_ATK] = true,
}

local g_martialAttrMap = {
    [AttrType.ATTR_QUANZHANGJINGTONG] = true,	-- 拳掌精通
    [AttrType.ATTR_JIANFAJINGTONG] = true,	-- 剑法精通
    [AttrType.ATTR_DAOFAJINGTONG] = true,	-- 刀法精通
    [AttrType.ATTR_TUIFAJINGTONG] = true,	-- 腿法精通
    [AttrType.ATTR_QIMENJINGTONG] = true,	-- 奇门精通
    [AttrType.ATTR_ANQIJINGTONG] = true,	-- 暗器精通
    [AttrType.ATTR_YISHUJINGTONG] = true,	-- 医术精通
    [AttrType.ATTR_NEIGONGJINGTONG] = true,	-- 内功精通
    [AttrType.ATTR_JIANFAATK] = true,	-- 剑法攻击
    [AttrType.ATTR_DAOFAATK] = true,	-- 刀法攻击
    [AttrType.ATTR_QUANZHANGATK] = true,	-- 拳掌攻击
    [AttrType.ATTR_TUIFAATK] = true,	-- 腿法攻击
    [AttrType.ATTR_QIMENATK] = true,	-- 奇门攻击
    [AttrType.ATTR_ANQIATK] = true,	-- 暗器攻击
    [AttrType.ATTR_YISHUATK] = true,	-- 医术攻击
    [AttrType.ATTR_NEIGONGATK] = true,	-- 内功攻击
}

function RoleDataManager:ctor()
end

function RoleDataManager:GetInstance()
    if RoleDataManager._instance == nil then
        RoleDataManager._instance = RoleDataManager.new()
        RoleDataManager._instance:Init()
    end

    return RoleDataManager._instance
end

-- 缓存初始化，建立角色 - 传家宝反查表
function RoleDataManager:Init()
    self:ResetManager()
    self:InitHeirloom()

    self.akRoleEmbattle = {}
    self.akLastRoleEmbattle = nil
    self.akNewRoleEmbattle = nil
    local schemeID = nil
    local TB_EmbattleScheme = TableDataManager:GetInstance():GetTable("EmbattleScheme")
    for index, data in pairs(TB_EmbattleScheme) do
        schemeID = data.BaseID
        self.akRoleEmbattle[schemeID] = {}
        self.akRoleEmbattle[schemeID][1] = {}
        if data.EmbattleType == EmBattleSchemeType.EBST_WheelWar then
            self.akRoleEmbattle[schemeID][2] = {}
            self.akRoleEmbattle[schemeID][3] = {}
        end
    end
    self.playerInfoMap = {}
end

function RoleDataManager:ResetManager()
    self.akDispositions = {}
    self.akInteractDates = {}
    self.akRoleChatDatas = nil
    self.akRefreshTimes = {}
    self.akRoleTypeIDInviteable = {}
    self.akScriptRoleTitle = {}
    self.akRedKnifes = {}
    self.akBabyStates = {}
    self.bIsFullArenaData = true;
    self.bIsObserveData = false;
    self.bIsArenaObserveData = false;
    self.auiUnleaveableRoleID = {}
    self.bShowEvo = false
    self.uiScript = nil
    self.levelUpWaitToShow = false
    self.bSort = nil
    self.interactChoiceMap = nil
    self.roleSelectEventMap = nil
    self.interactInfo = nil
    self.storyMasterCache = nil
    self.playerInfoMap = {}
end

-- 缓存初始化，建立角色 - 传家宝反查表
function RoleDataManager:InitHeirloom()
    local heirloom = {}
    local TB_Item = TableDataManager:GetInstance():GetTable("Item")
    for itemID, itemData in pairs(TB_Item) do
        if itemData.PersonalTreasure and itemData.PersonalTreasure > 0 then
            heirloom[itemData.PersonalTreasure] = itemID
        end
    end
    self.heirloom = heirloom
end



-- 根据 角色TypeID 获取 角色的传家宝（已经建立了反查表）
function RoleDataManager:GetHeirloomByTypeID(typeID)
    if not typeID then return end
    local heirloom = self.heirloom or {}
    return heirloom[typeID]
end

function RoleDataManager:UpdateUnLeaveableRoleID(auiRoleID)
    self.auiUnleaveableRoleID = auiRoleID
end

function RoleDataManager:Leaveable(uiRoleID)
    if uiRoleID == self:GetMainRoleID() then
        return false
    end

    local roleBaseID = self:GetRoleTypeID(uiRoleID)
    for _, id in pairs(self.auiUnleaveableRoleID) do
        if id == roleBaseID then
            return false
        end
    end
    return true
end

function RoleDataManager:GetMainRoleData()
    local mainRoleID = self:GetMainRoleID()
    return self:GetRoleData(mainRoleID)
end

function RoleDataManager:GetMainRoleID()
    local info = nil;

    --
    if GetGameState() == -1 then
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        elseif self.bIsFullArenaData then
            info = globalDataPool:getData("PlatTeamInfo") or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
        return info.dwMainRoleID;
    else
        if self.bIsObserveData then 
            info = globalDataPool:getData("ObserveInfo") or {};
            return info.dwMainRoleID;
        end
        info = globalDataPool:getData("MainRoleInfo")
        if not (info and info["MainRole"] and info["MainRole"][MRIT_MAINROLEID]) then
            return 0
        end
        return info["MainRole"][MRIT_MAINROLEID]
    end

end

function RoleDataManager:GetMartialNumMax(uiID)
    -- 实现方式修改掉，取主角的下行协议信息
    local roleData = self:GetRoleData(uiID or self:GetMainRoleID())
    if (not roleData) then
        return 0
    end

    return roleData.uiMartialNum
end

function RoleDataManager:GetGiftNumMax(uiID)
    -- 实现方式修改掉，取主角的下行协议信息
    local roleData = self:GetRoleData(uiID or self:GetMainRoleID())
    if (not roleData) then
        return 0
    end

    return roleData.uiGiftNum or 0
end

function RoleDataManager:GetMainRoleMartial()
    local roleData = self:GetMainRoleData()
    return roleData.auiRoleMartials or {}
end

-- 获取 武学 真实数量(不包含奥义)
function RoleDataManager:GetRoleMartialNum(uiID)
    local iOwnMartialNum = 0
    local roleData = self:GetRoleData(uiID or self:GetMainRoleID())
    if (not roleData) then
        return iOwnMartialNum
    end
    local auiRoleMartials = roleData.auiRoleMartials
    if auiRoleMartials then
        for i=0, getTableSize(auiRoleMartials)-1 do
            local kRoleMartial = MartialDataManager:GetInstance():GetMartialData(auiRoleMartials[i])
            if kRoleMartial then
               local uiTypeID = kRoleMartial.uiTypeID
               typeData = TableDataManager:GetInstance():GetTableData("Martial",uiTypeID)
                if typeData and typeData.KFFeature ~= KFFeatureType.KFFT_AustrianMartialArts  then
                    iOwnMartialNum = iOwnMartialNum + 1
                end
            end
        end
    end

    return iOwnMartialNum
end

-- 判断某角色是否已经学会某武学
function RoleDataManager:GetMartialInstByTypeID(uiRoleID, uiMartialBaseID)
    local kRoleData = self:GetRoleData(uiRoleID or self:GetMainRoleID())
    if (not kRoleData) or (not kRoleData.auiRoleMartials) then
        return nil
    end
    local auiRoleMartials = kRoleData.auiRoleMartials
    local kMartialMgr = MartialDataManager:GetInstance()
    for index = 0, #auiRoleMartials do
        local kRoleMartial = kMartialMgr:GetMartialData(auiRoleMartials[index] or 0)
        if kRoleMartial and (kRoleMartial.uiTypeID == uiMartialBaseID) then
            return kRoleMartial
        end
    end
    return nil
end

function RoleDataManager:GetMainRoleTypeID()
    local roleID = self:GetMainRoleID()
    return self:GetRoleTypeID(roleID)
end

function RoleDataManager:GetSubRoleId()
    local roleData = self:GetMainRoleData()
    return roleData.uiSubRole
end

function RoleDataManager:GetMainRoleModelID()
    local mainRoleID = self:GetMainRoleID()
    local roleTypeID = self:GetRoleTypeID(mainRoleID)
    local roleData = self:GetRoleData(mainRoleID)

    -- 显示数据记录
    local dataRecordModelID = ShowDataRecordManager:GetInstance():GetEndRecordValue(SDRT_ROLEMODEL, mainRoleID, 1)
    if dataRecordModelID and dataRecordModelID ~= 0 then
        return dataRecordModelID
    end

    -- 判断人物外观是否改变(易容面具)
    if TB_Role[roleTypeID] and TB_Role[roleTypeID].ArtID and roleData and roleData.uiModelID then
        if roleData.uiModelID ~= TB_Role[roleTypeID].ArtID then
            dprint('GetMainRoleModelID', roleData.uiModelID)
            return roleData.uiModelID
        end
    end

    --
    local info = nil;
    if GetGameState() == -1 then
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        elseif self.bIsFullArenaData then
            info = globalDataPool:getData("PlatTeamInfo") or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
        if (info and info.RoleInfos and info.RoleInfos[info.dwMainRoleID]) then
            return info.RoleInfos[info.dwMainRoleID].uiModelID
        end
    else
        if self.bIsObserveData then 
            info = globalDataPool:getData("ObserveInfo") or {};
            if (info and info.RoleInfos and info.RoleInfos[info.dwMainRoleID]) then
                return info.RoleInfos[info.dwMainRoleID].uiModelID
            end
        end
        local info = globalDataPool:getData("MainRoleInfo")
        if not (info and info["MainRole"] and info["MainRole"][MRIT_MAINROLE_MODELID]) then
            return 0
        end
        return info["MainRole"][MRIT_MAINROLE_MODELID]
    end

    return nil
end

function RoleDataManager:GetMainRoleName()
    local info = nil;
    if GetGameState() == -1 then
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        elseif self.bIsFullArenaData then
            info = globalDataPool:getData("PlatTeamInfo") or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
        return info.acName or '';
    else
        if self.bIsObserveData then 
            info = globalDataPool:getData("ObserveInfo") or {};
            return info.acName or '';
        end
        info = globalDataPool:getData("MainRoleInfo")
        if info == nil then
            return ''
        end
        return info["kName"] or ''
    end
end

function RoleDataManager:GetMainRoleSex()
    local mainRoleData = self:GetMainRoleData()
    if mainRoleData then
        return mainRoleData.uiSex
    end
    return SexType.ST_Male;
end

-- 获取角色的名字，返回字符串
function RoleDataManager:GetRoleName(roleID, bIgnore)
    -- 显示数据记录
    local dataRecordNameID = ShowDataRecordManager:GetInstance():GetEndRecordValue(SDRT_ROLENAME, roleID, 1)
    if dataRecordNameID and dataRecordNameID ~= 0 then
        return GetLanguageByID(dataRecordNameID)
    end

    -- NPC孩子名字
    if not bIgnore then
        local npcChildName = self:GetNpcChildName(roleID)
        if npcChildName then
            return npcChildName
        end
    end
    -- 孩子名字
    local kBabyInfo = self.akBabyStates[roleID]
    if kBabyInfo then
        return kBabyInfo.acPlayerName
    end
    -- 随机姓名
    local roleData = self:GetRoleData(roleID)
    if roleData and roleData.uiFamilyNameID and roleData.uiFirstNameID and 
    roleData.uiFamilyNameID ~= 0 and roleData.uiFirstNameID ~= 0 and 
    roleData.uiTypeID ~= giveRoleTypeID
    then
        return GetLanguageByID(roleData.uiFamilyNameID)..GetLanguageByID(roleData.uiFirstNameID)
    end
    -- 设置名字
    if roleData and roleData.uiNameID and roleData.uiNameID > 0 then
        return GetLanguageByID(roleData.uiNameID)
    end
    
    local roleTypeData = self:GetRoleTypeDataByID(roleID) or self:GetRoleTypeDataByTypeID(roleID)
    if not roleTypeData then return "" end

    if (roleID == self:GetMainRoleID() or roleID == self:GetMainRoleTypeID()) and (not bIgnore) then
        return self:GetMainRoleName()
    end

    local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID,NET_NAME_ID)
    local NameID = roleTypeData.NameID
    if BeEvolution then
        -- 随机姓名
        if BeEvolution.iParam2 == -1 then 
            local strname = self:GetPlayerNameByPlayerID(tonumber(BeEvolution.iParam1) or 0) 
            if strname then 
                return strname 
            end
            -- NameID = roleTypeData.NameID
        else 
            NameID = tonumber(BeEvolution.iParam1) or 0
            local familynameID = tonumber(BeEvolution.iParam2) or 0
            local firstnameID = tonumber(BeEvolution.iParam3) or 0
            if familynameID and firstnameID and familynameID ~= 0 and firstnameID ~= 0 then
                return GetLanguageByID(familynameID) .. GetLanguageByID(firstnameID)
            end
        end 
    end
    return GetLanguageByID(NameID)
end

function RoleDataManager:GetNpcChildName(childRoleID)
    -- 演化孩子名字
    local parentEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(childRoleID,NET_PARENTS)
    if not parentEvolution then
        return nil
    end

    local fatherTypeID = parentEvolution.iParam1
    local motherTypeID = parentEvolution.iParam2
    local fatherID = self:GetRoleID(fatherTypeID)
    local motherID = self:GetRoleID(motherTypeID)
    local familyNameID = nil
    local firstNameID = nil

    local getRoleFamilyName = function(roleID)
        if not roleID then
            return nil
        end

        local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID,NET_NAME_ID)
        local roleNameID2 = 0
        if BeEvolution then
            roleNameID2 = tonumber(BeEvolution.iParam2) or 0
        end

        if roleNameID2 > 0 then
            return roleNameID2
        end

        local roleTypeData = self:GetRoleTypeDataByID(roleID)
        if roleTypeData and roleTypeData.SurnameID and roleTypeData.SurnameID > 0 then
            return roleTypeData.SurnameID
        end
    end

    familyNameID = getRoleFamilyName(fatherID)
    if not familyNameID then
        familyNameID = getRoleFamilyName(motherID)
    end

    if not familyNameID then
        return nil
    end

    local familyName = GetLanguageByID(familyNameID)
    if not familyName or familyName == '' then
        return nil
    end

    local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(childRoleID,NET_NAME_ID)
    if BeEvolution then
        firstNameID = tonumber(BeEvolution.iParam3) or 0
        if firstNameID <= 0 then
            local roleTypeData = self:GetRoleTypeDataByID(childRoleID)
            if roleTypeData and roleTypeData.GivennameID and roleTypeData.SurnamGivennameIDeID > 0 then
                firstNameID = roleTypeData.GivennameID
            end
        end
    end

    if not firstNameID then
        return nil
    end
    local firstName = GetLanguageByID(firstNameID)
    if not firstName or firstName == '' then
        return nil
    end

    return familyName..firstName
end

--未找到时返回null
function RoleDataManager:GetPlayerNameByPlayerID(iPlayerID)
    if not iPlayerID then 
        return nil 
    end 
    local data = RankDataManager:GetInstance():GetRankDataByMember(1,iPlayerID)
    if data then 
        if data.name and data.metadata then
            local strName = string.match(data.name, '#(.+)');
            -- local playerID = globalDataPool:getData("PlayerID");
            -- local curPlayerID = string.match(data.name, '(.+)#') or data.member;
            strName = data.metadata ~= '' and data.metadata or strName;

            if not strName or strName == '' then
                strName = data.name;
            end
            return strName;
        end
    end 
    NetCommonRank:QueryWithMember('1', { string.format('%d', iPlayerID)});
    return nil
end

--未找到时返回null
function RoleDataManager:GetRoleTitleStr(roleID, istypeid)
    local TitleID = 0
   
    if istypeid then
        local dbdata = TB_Role[roleID]
        if dbdata then
            TitleID = dbdata.TitleID
        end
    else
        local roleData = self:GetRoleData(roleID)
        if roleData and roleData.roleType == ROLE_TYPE.INST_ROLE then
            if roleData.uiTitleID and roleData.uiTitleID > 0 then
                TitleID = roleData.uiTitleID
            end
        else
            local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID,NET_TITLE)
            if BeEvolution then
                TitleID = BeEvolution.iParam1
            elseif roleData and roleData.uiTypeID then
                local dbdata = TB_Role[roleData.uiTypeID]
                if dbdata then
                    TitleID = dbdata.TitleID
                end
            end
        end
    end
 
    if TitleID > 0 then
        local roleTitleData = TableDataManager:GetInstance():GetTableData("RoleTitle",TitleID)
        if roleTitleData and roleTitleData.TitleID then
            local string_title = GetLanguageByID(roleTitleData.TitleID) or ""
            return string_title
        end
    end
end

-- 获取角色的称号+名字，返回字符串
function RoleDataManager:GetRoleTitleAndName(roleIDIn, istypeid, noShowRelate, ingoreMainRole)
    local roleID = roleIDIn
    if istypeid then
        roleID = self:GetRoleID(roleIDIn)
        if roleID == 0 then
            roleID = roleIDIn
        end
    end

    local roleTypeData = self:GetRoleTypeDataByID(roleID)
    if not roleTypeData then 
        return "" 
    end
    
    local roleData = self:GetRoleData(roleID)
    if not roleData then 
        local titleStr = self:GetRoleTitleStr(roleID, true) 
        if titleStr then
            return titleStr .. "·" .. self:GetRoleNameByTypeID(roleID) 
        end
        return self:GetRoleNameByTypeID(roleID) 
    end

    local string_title = self:GetRoleTitleStr(roleID)
    local string_name = self:GetRoleName(roleID, ingoreMainRole)
 
    if string_title then
        string_name =  string_title .. "·" .. string_name
    end

    if not noShowRelate then
        local relatStr = self:GetRoleRelationshipStr(roleID)
        if relatStr then
            string_name = relatStr .. "·" .. string_name
        end
    end

    return string_name
end

--通过roleIDIn 返回角色名字
function RoleDataManager:GetRoleNameByRoleID(roleIDIn)
    local roleID = roleIDIn
    local roleTypeData = self:GetRoleTypeDataByID(roleID)
    if not roleTypeData then 
        return "" 
    end
    
    local roleData = self:GetRoleData(roleID)
    if not roleData then 
        return self:GetRoleNameByTypeID(roleID) 
    end

    return self:GetRoleName(roleID)
 
end

function RoleDataManager:GetRoleRelationshipStr(roleID)
    local mainRoleInfo = self:GetMainRoleData()
    if not mainRoleInfo then
        return
    end
    local roleTypeID = self:GetRoleTypeID(roleID)
    if self:IsSwornedWithMainRole(roleID, false) then
        return "金兰"
    elseif self:IsMarriedWithMainRole(mainRoleInfo.uiMarry,roleTypeID) and roleTypeID > 0 then
        return "情侣"
    end
end

function RoleDataManager:IsMarriedWithMainRole(mainRoleMarrys,roleTypeID)
    if not mainRoleMarrys or not roleTypeID then
        return false
    end
    for i = 0,(#mainRoleMarrys-1) do
        if mainRoleMarrys[i]==roleTypeID then
            return true
        end
    end
    return false
end

function RoleDataManager:GetMainRoleClanTypeID()
    local roleData = self:GetRoleData(self:GetMainRoleID())     -- 动态数据

    if roleData and roleData.uiClanID and roleData.uiClanID > 0 then
        return roleData.uiClanID or 0
    end

    return 0
end

function RoleDataManager:GetRoleData(roleID)
    local info = nil

    if GetGameState() == -1 then
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        elseif self.bIsFullArenaData then
            info = globalDataPool:getData("PlatTeamInfo") or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
        if info and info.RoleInfos and info.RoleInfos[roleID] then
            return info.RoleInfos[roleID];
        end
    else
        if self.bIsObserveData then 
            info = globalDataPool:getData("ObserveInfo") or {};
            if info and info.RoleInfos and info.RoleInfos[roleID] then
                return info.RoleInfos[roleID];
            end
        end
        info = globalDataPool:getData("GameData")
        if info and info.RoleInfos and info.RoleInfos[roleID] then
            return info.RoleInfos[roleID];
        end
    end
    return nil;
end

function RoleDataManager:IsMarryed(roleID)
    local roledata = self:GetRoleData(roleID)
    
    if not roledata or not roledata.uiMarry then
        return false
    end

    local uiMarry = roledata.uiMarry[0] or 0
    if uiMarry > 0 then
        return true
    end

    return false
end
-- 用于判断徒弟是否可遗传该武学
function RoleDataManager:CanHeritMartial(roleID,martialTypeid)
    local roleData = self:GetRoleData(roleID)
    if roleData then
        for k,v in  pairs(roleData.auiHeritMartial or {}) do
            if v == martialTypeid then
                return true
            end
        end
    end
    return false
end

-- 用于判断徒弟是否可遗传该天赋
function RoleDataManager:CanHeritGift(roleID,giftTypeId)
    local roleData = self:GetRoleData(roleID)
    if roleData then
        for k,v in  pairs(roleData.auiHeritGift or {}) do
            if v == giftTypeId then
                return true
            end
        end
    end
    return false
end

function RoleDataManager:IsBabyRoleType(roleID,bIncludeEvolute)
    -- bIncludeEvolute 第二个参数 目前没开
    local roledata = self:GetRoleData(roleID)
    if not roledata then
        return false
    end
    if self.akBabyStates and self.akBabyStates[roleID] then 
        return true
    end 

    local evolution = EvolutionDataManager:GetInstance():GetOneEvolutionByType(roleID,NET_PARENTS)
    if evolution and bIncludeEvolute then 
        return true 
    end 
    
    local mainRoleID = self:GetMainRoleID()
    if evolution then
        return mainRoleID == evolution.iParam1 or  mainRoleID == evolution.iParam2 or false 
    end 

    return false
end

function RoleDataManager:GetAllCanSubRoleList(roleID)
    local roledata = self:GetRoleData(roleID)
    local list = {}
    if not roledata then
        return list
    end

    local brodata = roledata.auiBroAndSis or {}
    local marrydata = roledata.uiMarry or 0

    for k,v in pairs(brodata) do
        local subRoleId = self:GetRoleID(v)
        if subRoleId > 0 and self:IsRoleInTeam(subRoleId) then
            table.insert(list,subRoleId)
        end
    end
    if marrydata then
        for i =0,#marrydata-1 do
            
            if marrydata[i] > 0  then
                local subRoleId = self:GetRoleID(marrydata[i])
                if subRoleId > 0 and self:IsRoleInTeam(subRoleId) then
                    table.insert(list,subRoleId)
                end
            end
        end
    end

    return list
end

function RoleDataManager:IsSwornedWithMainRole(roleID, istypeid)
    local mainroledata = self:GetMainRoleData()
    
    if not mainroledata then
        return false
    end

    local brodata = mainroledata.auiBroAndSis or {}
    local roleTypeID = roleID
    if not istypeid then
        roleTypeID = self:GetRoleTypeID(roleID)
    end

    for k,v in pairs(brodata) do
        if v == roleTypeID and roleTypeID > 0 then
            return true
        end
    end

    return false
end

function RoleDataManager:IsMarryWithMainRole(roleID, istypeid)
    local mainroledata = self:GetMainRoleData()
    
    if not mainroledata then
        return false
    end

    local marrydata = mainroledata.uiMarry or 0
    local roleTypeID = roleID
    if not istypeid then
        roleTypeID = self:GetRoleTypeID(roleID)
    end
    for i=0,255 do
        if marrydata[i] == roleTypeID and roleTypeID > 0 then
            return true
        end
    end
   
    return false
end

function RoleDataManager:GetCreateRoleData(index, createData)
    
    local info = globalDataPool:getData("CreateMainRole")

    if createData then
        info = createData
    end
    
    if not (info and info['akRoles'] and info['akRoles'][index]) then
        return nil
    end
    return info["akRoles"][index]
end

function RoleDataManager:CheckCreateRoleHaveBaby()

    local info = globalDataPool:getData("StartCreateMainRole")

    if not info then
       return false
    end
    for key, value in pairs(info['akRoles']) do
        if value.uiChild == 1 then
            return true
        end
    end
    return false
end

function RoleDataManager:GetRoleTypeDataByID(roleID)
    local typeID = self:GetRoleTypeID(roleID)
    if typeID == 0 then return TB_Role[roleID] end
    return TB_Role[typeID]
end


function RoleDataManager:GetRoleTypeDataByTypeID(roleTypeID)
    return TB_Role[roleTypeID]
end

function RoleDataManager:GetRoleBaseDataByTypeID(roleTypeID)
    self.baseRoles = self.baseRoles or {}
    if self.baseRoles[roleTypeID] == nil then 
        self.baseRoles[roleTypeID] = BaseRole.new(0,{["uiTypeID"]=roleTypeID})
    end
    return self.baseRoles[roleTypeID]
end

function RoleDataManager:GetRoleTypeID(roleID)
    local info = nil;
    if GetGameState() == -1 then
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        elseif self.bIsFullArenaData then
            info = globalDataPool:getData("PlatTeamInfo") or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
        if info and info.RoleInfos and info.RoleInfos[roleID] then
            return info.RoleInfos[roleID].uiTypeID;
        end
    else
        if self.bIsObserveData then 
            info = globalDataPool:getData("ObserveInfo") or {};
            if info and info.RoleInfos and info.RoleInfos[roleID] then
                return info.RoleInfos[roleID].uiTypeID;
            end
        end
        info = globalDataPool:getData("GameData")
        if info and info.RoleInfos and info.RoleInfos[roleID] then
            return info.RoleInfos[roleID].uiTypeID;
        end
    end

    return 0;
end

-- 通过静态ID，反查动态ID。参数二：优先获取哪一种
-- 角色入队后，队伍里的角色为 instRole，场景上的角色监听为 NPC Role
function RoleDataManager:GetRoleID(roleTypeID, type)
    type = type or ROLE_TYPE.INST_ROLE

    local info = globalDataPool:getData("GameData")
    if not (info and info["RoleInfos"]) then
        return 0
    end

    local findID = 0
    for roleID, roleData in pairs(info["RoleInfos"]) do 
        if roleData.uiTypeID == roleTypeID then 
            findID = roleID
            if roleData.roleType == type then
                return findID   -- 如果 类型一致，立刻返回，否则再搜索一下。
            end
        end
    end
    return findID   -- 类型不一致，但是 typeID 一致
end

-- 角色是否在队伍中
function RoleDataManager:IsRoleInTeam(uiID)
    local info = globalDataPool:getData("MainRoleInfo")
    if not (info and info["TeammatesCheck"]) then
        return false
    end
    local kTeammatesCheck = info["TeammatesCheck"]
    return kTeammatesCheck[uiID] == true
end

function RoleDataManager:GetTeammatesRoleTypeID()
    local typeIDs = {}
    local info = globalDataPool:getData("MainRoleInfo")
	if info and info["Teammates"] then
		for i = 0, getTableSize(info["Teammates"]) do
            local id = info["Teammates"][i]
            local roleData = self:GetRoleData(id)
            if roleData and roleData.uiTypeID then
                typeIDs[#typeIDs + 1] = roleData.uiTypeID
            end
		end
    end

    return typeIDs
end

function RoleDataManager:GetInstRoleByTypeID(roleTypeID)
    local info = globalDataPool:getData("MainRoleInfo")
	if info and info["Teammates"] then
		for i = 0, getTableSize(info["Teammates"]) do
            local id = info["Teammates"][i]
            local roleData = self:GetRoleData(id)
            if roleData and roleData.uiTypeID == roleTypeID then
                return roleData
            end
		end
    end
    return nil
end

function RoleDataManager:GetTeammateDataByID(roleID)
    local info = globalDataPool:getData("MainRoleInfo")
	if info and info["Teammates"] then
		for i = 0, getTableSize(info["Teammates"]) do
			local id = info["Teammates"][i]
			if (id == roleID) then
				return self:GetRoleID(roleID)
			end
		end
    end
    return nil
end

function RoleDataManager:GetRoleArtDataByID(roleID)
    -- 如果是主角,那么返回主角的信息里面的模型ID
    if (roleID == self:GetMainRoleID()) then
        return self:GetMainRoleArtData()
    end

    -- 显示数据记录
    local dataRecordModelID = ShowDataRecordManager:GetInstance():GetEndRecordValue(SDRT_ROLEMODEL, roleID, 1)
    if dataRecordModelID and dataRecordModelID ~= 0 then
        return TableDataManager:GetInstance():GetTableData("RoleModel", dataRecordModelID)
    end

    -- InstRole
    local roleData = self:GetRoleData(roleID)
    if roleData and roleData.uiModelID and roleData.uiModelID ~= 0 then
        return TableDataManager:GetInstance():GetTableData("RoleModel", roleData.uiModelID)
    end

    -- NpcRole
    local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID, NET_ROLEMODEL)
    if BeEvolution then
        local uiModelID = tonumber(BeEvolution.iParam1)
        if uiModelID and uiModelID ~= 0 then
            return TableDataManager:GetInstance():GetTableData("RoleModel", uiModelID)
        end
    end

    local typeID = self:GetRoleTypeID(roleID)

    --传进来就是TypeID
    if typeID == 0 then return self:GetRoleArtDataByTypeID(roleID, true) end
    return self:GetRoleArtDataByTypeID(typeID, true)
end

function RoleDataManager:GetRoleNameByTypeID(roleTypeID)
    local name = ''
    if roleTypeID == self:GetMainRoleTypeID() then 
        name = self:GetMainRoleName()
    else
        local roleTypeData = self:GetRoleTypeDataByTypeID(roleTypeID)
        if type(roleTypeData) == 'table' then 
            name = GetLanguageByID(roleTypeData.NameID)
        end
    end
    return name
end

function RoleDataManager:GetRoleArtDataByTypeID(roleTypeID, isRawData)
    if roleTypeID == nil or roleTypeID == 0 then
        return nil
    end

    if roleTypeID == self:GetMainRoleTypeID() then 
        return self:GetMainRoleArtData()
    else
        local uiRoleID = self:GetRoleID(roleTypeID)

        if isRawData or not uiRoleID or uiRoleID == 0 then
            local roleTypeData = TB_Role[roleTypeID]
            if not (roleTypeData ~= nil and roleTypeData.ArtID ~= nil) then 
                return 
            end
            artID = roleTypeData.ArtID

            return TableDataManager:GetInstance():GetTableData("RoleModel", artID)
        else
            return self:GetRoleArtDataByID(uiRoleID)
        end
    end
end

function RoleDataManager:GetModelByRoleModelID(roleModeID)
    local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", roleModeID)
    if roleModelData then
        return roleModelData.Texture or ""
    end
    return ""
end
function RoleDataManager:GetMainRoleArtData()
    local iRoleModel = self:GetMainRoleModelID()
    if (not iRoleModel) or (iRoleModel == 0) then
        return
    end
    return TableDataManager:GetInstance():GetTableData("RoleModel", iRoleModel)
end

function RoleDataManager:DeleteRoleData(roleID)
    local info = globalDataPool:getData("GameData")
    if not (info and info["RoleInfos"] and info["RoleInfos"][roleID]) then
        return nil
    end
    info["RoleInfos"][roleID] = nil
    globalDataPool:setData('GameData', info, true)
end

function RoleDataManager:UpdateRoleData(roleID, roleData)
    local info = globalDataPool:getData("GameData")
    if not info then
        info = {['RoleInfos'] = {}}
    elseif not info["RoleInfos"] then
        info.RoleInfos = {}
    end
    roleData["uiID"] = roleID
    info["RoleInfos"][roleID] = roleData
    globalDataPool:setData('GameData', info, true)
    LuaEventDispatcher:dispatchEvent("UPDATE_ROLE_DATA",roleID, true)
end

function RoleDataManager:UpdateRoleCommonData(kRetData)
    local uiID = kRetData.uiID
    local roleData = self:GetRoleData(uiID)
    if not roleData then 
        derror("角色不存在,id=" .. tostring(uiID).." typeID = "..tostring(kRetData.uiTypeID))
        return 
    end
    if not roleData.hasInit then 
        -- 各个属性赋予初始值
        roleData.hasInit = true
        for key, defaultValue in pairs(ROLE_DATA_INIT_VALUE) do 
            roleData[key] = roleData[key] or defaultValue
        end
    end
    -- 不要一个一个字段写，直接全部覆盖
    for k,v in pairs(kRetData) do
        roleData[k] = v
    end

    LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_ROLECOMMON",uiID, true)
    if uiID == self:GetMainRoleID() then
        LuaEventDispatcher:dispatchEvent("UPDATE_MAIN_ROLE_INFO")
    end

    if kRetData.uiHasSubRole ~= nil then
        LuaEventDispatcher:dispatchEvent("UPDATE_MAIN_ROLE_SUBROLEINFO",{kRetData.uiID , roleData.uiSubRole}, true)
        --之前是替补 ，现在去掉了
		if roleData.uiHasSubRole == 1 and roleData.uiSubRole ~= 0 then
            roleData.uiSubRole = 0
        end 
    end
end

-- 获取角色品质
function RoleDataManager:GetRoleRank(roleID)
    local defaultRank = RankType.RT_White
    local roleInstData = self:GetRoleData(roleID)
    if roleInstData == nil then 
        return defaultRank 
    end
    if roleInstData.uiRank then
        return roleInstData.uiRank
    end
    local roleTypeData = self:GetRoleTypeDataByID(roleID)
    if roleTypeData then
        defaultRank = roleTypeData.Rank
    end

    -- NPC未入队  品质加等级
    return math.min(defaultRank + CardsUpgradeDataManager:GetInstance():GetRoleExRankByRoleID(roleInstData.uiTypeID),RankType.RT_DarkGolden)
end
-- typeid获取角色品质
function RoleDataManager:GetRoleRankByTypeID(TypeID)
    local defaultRank = RankType.RT_White

    local roleTypeData = self:GetRoleTypeDataByTypeID(TypeID)
    if roleTypeData then
        defaultRank = roleTypeData.Rank
    end

    -- NPC未入队  品质加等级
    return math.min(defaultRank + CardsUpgradeDataManager:GetInstance():GetRoleExRankByRoleID(TypeID),RankType.RT_DarkGolden)
end


-- 获取角色喜好
function RoleDataManager:GetRoleFavor(roleID)
    local defaultFavor = {}
    local roleInstData = self:GetRoleData(roleID)
    if roleInstData == nil then 
        return defaultFavor 
    end

    local aiFavor = roleInstData.auiFavor or {}
    for k, v in pairs(aiFavor) do
        if aiFavor[k] > 0 then
            table.insert(defaultFavor, aiFavor[k]);
        end
    end

    local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID,NET_FAVORTYPE)
    if BeEvolution then
        for i=1,3 do
            if BeEvolution['iParam'..i] and BeEvolution['iParam'..i] > 0 then
                table.insert(defaultFavor, BeEvolution['iParam'..i])
            end
        end
    end
    return defaultFavor

end

-- 缓存角色升级数据
function RoleDataManager:CacheRoleLevelUpMsg(roleID, oldLevel, newLevel)
    if not self:isInBattleTeam(roleID) then 
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
    roleCache.oldRoleLevel = oldLevel
    roleCache.newRoleLevel = newLevel
    globalDataPool:setData("GameData", info, true)
    return true
end

-- 获取角色叠加等级
function RoleDataManager:GetRoleOverlayLevel(roleID)
    local uiOverlayLevel = 0
    local roleInstData = self:GetRoleData(roleID)
    if roleInstData then 
        if self.bIsArenaObserveData then
            return roleInstData.uiOverlayLevel
        else
            if roleInstData.uiOverlayLevel and roleInstData.uiOverlayLevel > 0 then 
                return roleInstData.uiOverlayLevel 
            else 
                return self:GetRoleOverlayLevelByBaseID(roleInstData.uiTypeID)
            end 
        end
    end
    return uiOverlayLevel
end

-- 获取角色叠加等级
function RoleDataManager:GetRoleOverlayLevelByBaseID(roleBaseID)
    local carddata = CardsUpgradeDataManager:GetInstance():GetRoleCardDataByRoleBaseID(roleBaseID)
    return carddata.level or 0
end

-- 清空角色升级数据缓存
function RoleDataManager:ClearRoleLevelUpMsg()
    local info = globalDataPool:getData("GameData")
    info = info or {}
    info.LevelUpCache = {}
    globalDataPool:setData("GameData", info, true)
end

-- 是否存在角色升级数据
function RoleDataManager:HasLevelUpMsgCached()
    local info = globalDataPool:getData("GameData")
    return (info ~= nil) and (info.LevelUpCache ~= nil) and (next(info.LevelUpCache) ~= nil)
end

-- 显示升级界面, 或者刷新升级界面
function RoleDataManager:ShowLevelUpMsg(bNeedDisplayEnd)
    -- 如果要显示等级提升界面的时候 战斗 界面处于打开中状态, 则等到结束后再显示
    if IsWindowOpen('BattleUI') then
        self.levelUpWaitToShow = true
        return false
    end
    local info = globalDataPool:getData("GameData")
    if not (info and info["LevelUpCache"] and next(info["LevelUpCache"])) then 
        return false
    end
    local sendInfo = info["LevelUpCache"]
    -- 显示升级信息
    local bIsLevelUpOpen = WindowsManager:GetInstance():IsWindowOpen("LevelUPUI")
    if bIsLevelUpOpen == true then
        local uiLevelUp = GetUIWindow("LevelUPUI")
        -- 当刷新已存在的ui的数据时, 只允许 "需要DisplayEnd" 覆盖 "不需要DisplayEnd"
        if bNeedDisplayEnd ~= false then
            sendInfo['bNeedDisplayEnd'] = true
        end
        uiLevelUp:RefreshUI(sendInfo)
    else
        sendInfo['bNeedDisplayEnd'] = (bNeedDisplayEnd ~= false)
        OpenWindowImmediately("LevelUPUI", sendInfo)
    end
    self.levelUpWaitToShow = false
    return (bIsLevelUpOpen ~= true)
end

-- 检查标记并显示等级提升界面
function RoleDataManager:CheckAndShowLevelUp()
    if self.levelUpWaitToShow ~= true then
        return
    end
    self:ShowLevelUpMsg(false)
end

function RoleDataManager:InitRoleEmbattleData(rkData)
    local iID = 0
    local iRound = 0
    self.akRoleEmbattle = {}
    local TB_EmbattleScheme = TableDataManager:GetInstance():GetTable("EmbattleScheme")
    for i = 1,getTableSize2(TB_EmbattleScheme) do
        self.akRoleEmbattle[i] = {}
        self.akRoleEmbattle[i][1] = {}
        if i == EmBattleSchemeType.EBST_WheelWar then --只有车轮战需要多轮
            for j=1,3 do
                self.akRoleEmbattle[i][j] = {}
            end
        end
    end

    for i = 0,rkData['iNum'] - 1 do 
        local data = rkData['akRoleEmbattle'][i]
        iID = data['iID']
        iRound = data['iRound']

        data.iGridX = data.iGridX + 1
        data.iGridY = data.iGridY + 1

        if self.akRoleEmbattle[iID] and self.akRoleEmbattle[iID][iRound] then
            self.akRoleEmbattle[iID][iRound][#self.akRoleEmbattle[iID][iRound] + 1] = data
        end
    end

    self.akLastRoleEmbattle = self.akRoleEmbattle
end

function RoleDataManager:InitTownRoleEmbattleData(kRetData)
    local luaTable = table_c2lua(kRetData);

    -- 该接口是批量下发阵容，所以得先清理一遍阵容，重新布阵
    local tp = luaTable[1]
    if tp and tp.iID and tp.iRound and self.akRoleEmbattle[tp.iID] and self.akRoleEmbattle[tp.iID][tp.iRound] then
        self.akRoleEmbattle[tp.iID][tp.iRound] = {}
    end

    for i = 1, #(luaTable) do
        local tp = luaTable[i];
        if tp.uiRoleID ~= 0 then
            if self.akRoleEmbattle[tp.iID] and self.akRoleEmbattle[tp.iID][tp.iRound] then
                tp.iGridX = tp.iGridX + 1;
                tp.iGridY = tp.iGridY + 1;
                self.akRoleEmbattle[tp.iID][tp.iRound][i] = tp;
            end
        end
    end
end

function RoleDataManager:InitTownPetEmbattleData(kRetData)
    local luaTable = table_c2lua(kRetData) or {};
    for i = 1, #(luaTable) do
        if luaTable[i] then
            local arenaHelp = self.akRoleEmbattle[EmBattleSchemeType.EBST_ArenaHelp];
            if arenaHelp and arenaHelp[1] then
                local petEmbattle = self:CreatRoleEmbattleData(luaTable[i], EmBattleSchemeType.EBST_ArenaHelp, 1, ASSISTCOMBATPOS[i].x, ASSISTCOMBATPOS[i].y, INVALID, 1);
                arenaHelp[1][i] = petEmbattle;
            end
        end
    end
end

function RoleDataManager:GetObserveRoleEmbattleInfo()
    local info = globalDataPool:getData('ObserveInfo') or {};
    return info.EmbattleInfo or {};
end

function RoleDataManager:ResetRoleEmbattle2()
    self.akRoleEmbattle[EmBattleSchemeType.EBST_Team][1] = {};
end

function RoleDataManager:isInBattleTeam(iRoleID)
	local embattleData = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]
	if embattleData then
		for index, data in ipairs(embattleData) do
			if data.uiRoleID == iRoleID then
				return true
			end
		end
	end

	for i=1,3 do
		local embattleData = self.akRoleEmbattle[EmBattleSchemeType.EBST_WheelWar][i]
		if embattleData then
			for index, data in ipairs(embattleData) do
				if data.uiRoleID == iRoleID then
					return true
				end
			end
		end
	end

	return false
end
function RoleDataManager:AutoAddRole2EmbattleData(iRoleID,iToggleID,iRound)
    local iCount = #self.akRoleEmbattle[iToggleID][iRound]
    for i = 1,#self.akRoleEmbattle[iToggleID][iRound] do 
        if self.akRoleEmbattle[iToggleID][iRound][i].uiRoleID == iRoleID then
            return 
        end
    end

    local aiDefalutPos = {{3,3},{2,4},{2,2},{3,1},{3,5},{1,3},{1,1},{1,5},{4,4},{4,2},
    {3,4},{4,3},{3,2},{2,3},{4,5},{4,1},{2,1},{2,5},{1,2},{1,4}}--默认布阵规则

    if iCount < self:GetCanEmbattleCount() then
        local data = self.akRoleEmbattle[iToggleID][iRound]
        local x = 0
        local y = 0
        local bCanAdd = true
        for i =1,#aiDefalutPos do
            x = aiDefalutPos[i][1]
            y = aiDefalutPos[i][2]
            bCanAdd = true
            for j=1,iCount do
                if data[j].iGridX == x and  data[j].iGridY == y then
                    bCanAdd = false
                    break
                end
            end
            if bCanAdd then
                local roleEmbattle = self:CreatRoleEmbattleData(iRoleID,iToggleID,iRound,x,y,IN_TEAM,0)
                table.insert(data,roleEmbattle)
                SendUpdateEmbattleData(data,iToggleID,iRound)
                return x,y
            end
        end
    end
end

function RoleDataManager:AutoAddRole2EmbattleDataPlat(iRoleID)
    local embattleInfo = self:GetRoleEmbattleInfo();
    if embattleInfo[EmBattleSchemeType.EBST_Team] then
        local team = embattleInfo[EmBattleSchemeType.EBST_Team][1];
        local iCount = #(team);
        for i = 1, iCount do
            if team[i].uiRoleID == iRoleID then
                return;
            end
        end
    
        local aiDefalutPos = {{3,3},{2,4},{2,2},{3,1},{3,5},{1,3},{1,1},{1,5},{4,4},{4,2},
        {3,4},{4,3},{3,2},{2,3},{4,5},{4,1},{2,1},{2,5},{1,2},{1,4}}--默认布阵规则
    
        if iCount < 5 then
            local x = 0;
            local y = 0;
            local bCanAdd = true;
            for i = 1, #(aiDefalutPos) do
                x = aiDefalutPos[i][1];
                y = aiDefalutPos[i][2];
                bCanAdd = true;
                for j = 1, iCount do
                    if team[j].iGridX == x and team[j].iGridY == y then
                        bCanAdd = false;
                        break;
                    end
                end
    
                if bCanAdd then
                    local roleEmbattle = self:CreatRoleEmbattleData(iRoleID, EmBattleSchemeType.EBST_Team, 1, x, y, IN_TEAM, 0);
                    table.insert(team, roleEmbattle)
                    local temp = {};
                    for i = 1, #(team) do
                        temp[i - 1] = team[i];
                    end
                    SendPlatEmbattle(0, #(team), temp);
                    break;
                end
            end
        end
    end
end

function RoleDataManager:CreatRoleEmbattleData(iRoleID,iToggleID,iRound,iGridX,iGridY,eFlag,bpet)
    local roleEmbattle = {} --commdefine.xml中定义
    roleEmbattle.uiRoleID = iRoleID
    roleEmbattle.iID = iToggleID
    roleEmbattle.iRound = iRound
    roleEmbattle.iGridX = iGridX
    roleEmbattle.iGridY = iGridY
    roleEmbattle.eFlag = eFlag
    roleEmbattle.bPet = bpet
    return roleEmbattle
end

function RoleDataManager:lastRoleEmbattleData(iToggleID,iRound)
    if not self.akLastRoleEmbattle then
        self.akLastRoleEmbattle = {}
    end

    if not self.akLastRoleEmbattle[iToggleID] then
        self.akLastRoleEmbattle[iToggleID] = {}
    end

    self.akLastRoleEmbattle[iToggleID][iRound] = self.akRoleEmbattle[iToggleID][iRound]
end

function RoleDataManager:SaveRoleEmbattleData(iToggleID,iRound,bSuccess)
    if not bSuccess then
        self.akRoleEmbattle[iToggleID] = self.akLastRoleEmbattle[iToggleID][iRound]
        LuaEventDispatcher:dispatchEvent("UPDATE_EMBATTLE",{ToggleID = iToggleID,Round = iRound})
    else
        self.akLastRoleEmbattle = self.akRoleEmbattle
    end
end

function RoleDataManager:GetCanEmbattleCount()
    local info  = globalDataPool:getData("MainRoleInfo") 
    local iNum = 1
    if info and info["MainRole"] then
        iNum = info["MainRole"][MRIT_BATTLE_TEAMNUMS]
    end
    return iNum 
end

function RoleDataManager:GetRoleEmbattleInfo()
    -- todo 排序
    -- 布阵  替补:
    --1.等级排序,品质排序
    local sort = function(role1,role2)
        if role1 == nil or role2 == nil then
            return false
        end

        if role1.bPet == 1 or role2.bPet == 1 then
            return false;
        end

        local roledata1 = self:GetRoleData(role1.uiRoleID)
        local roledata2 = self:GetRoleData(role2.uiRoleID)

        if roledata1 == nil or roledata2 == nil then
            return false
        end

        if roledata1["uiLevel"] == roledata2["uiLevel"] then
            if roledata1["uiRank"] == roledata2["uiRank"] then
                return role1.uiRoleID > role2.uiRoleID
            else
                return roledata1["uiRank"] > roledata2["uiRank"]
            end
        else
            return roledata1["uiLevel"] >  roledata2["uiLevel"]
        end

        return false
    end
    self.akNewRoleEmbattle = self.akNewRoleEmbattle or {}
    for id, value in pairs(self.akRoleEmbattle) do
        local akRoundEmbattle = value or {}
        self.akNewRoleEmbattle[id] = {}
        for iRound, akRoleList in pairs(akRoundEmbattle) do
            if #akRoleList  > 0 then
                table.sort(akRoleList,sort)
            end

            self.akNewRoleEmbattle[id][iRound] = akRoleList
        end
    end

    return self.akNewRoleEmbattle
end

function RoleDataManager:CheckRoleEmbattleState(roleID)
    if not roleID then
        return false
    end
    self.akRoleEmbattle = self.akRoleEmbattle or {}
    self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal] =  self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal] or {}
    local akRoleList = self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]

    if not akRoleList then
        return false
    end

    if #akRoleList  > 0 then
        for index = 1, #akRoleList  do
            if akRoleList[index] and akRoleList[index].uiRoleID then
                if (akRoleList[index].uiRoleID == roleID) then
                    return true
                end
            end
        end
    end

    return false
end

function RoleDataManager:GetRoleTeammates(bSort, bSortMainRole)
    local info = {};
    if GetGameState() == -1 then
        if self.bIsFullArenaData then
            info = globalDataPool:getData('PlatTeamInfo') or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
	else
		info = globalDataPool:getData("MainRoleInfo") or {};
	end
    local teammates = info["Teammates"] or info["auiTeammates"];
    teammates = teammates or {};
    local sort = function(role1,role2)
        if role1 == nil or role2 == nil then
            return false
        end

        if GetGameState() == -1 then
            --
        else
            if role1 == self:GetMainRoleID() then
                return true
            end
    
            if role2 == self:GetMainRoleID() then
                return false
            end
        end

        local roledata1 = self:GetRoleData(role1)
        local roledata2 = self:GetRoleData(role2)

        if roledata1 == nil or roledata2 == nil then
            return false
        end

        local _comp = function()
            if roledata1["uiLevel"] == roledata2["uiLevel"] then
                if roledata1["uiRank"] == roledata2["uiRank"] then
                    return role1 > role2
                else
                    return roledata1["uiRank"] > roledata2["uiRank"]
                end
            else
                return roledata1["uiLevel"] >  roledata2["uiLevel"]
            end
        end

        if GetGameState() == -1 then
            return _comp();
        end

        local boolInbattle1 = self:CheckRoleEmbattleState(role1)
        local boolInbattle2 = self:CheckRoleEmbattleState(role2)

        if boolInbattle1 == boolInbattle2 then
            return _comp();
        elseif boolInbattle1 then
            return true
        end

        return false
    end

    if bSort ~= false then
        table.sort(teammates,sort)
    end
    
    if bSortMainRole then
        teammates = table_c2lua(teammates);
        table.sort(teammates, sort);
    end

    return teammates
end


function RoleDataManager:GetBattleRoles()
    if not (self.akRoleEmbattle ~= nil and self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal] ~= nil and self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1] ~= nil) then 
        return {}
    end
    local battleRoles = {}
    for _, roleInfo in ipairs(self.akRoleEmbattle[EmBattleSchemeType.EBST_Normal][1]) do 
        table.insert(battleRoles, self:GetRoleData(roleInfo.uiRoleID))
    end
    return battleRoles
end

-- <protocol Name="Display_Disposition" Stream='true' Comment="好感度">
-- <member Name="iNums" Type="DWord" InitValue="0" Comment="数量"/>
-- <member Name="akDispositions" Type="RoleDisposition" ArraySize="SSD_MAX_DISPOSITIONS_NUMS" Refer="iNums" Comment="好感度结构"/>
-- </protocol>
-- <struct Name="RoleDisposition" Comment="好感度结构">
-- <member Name="uiSrcRoleID" Type="DWord" Comment="源角色ID"/>
-- <member Name="uiDstRoleID" Type="DWord" Comment="目标角色ID"/>
-- <member Name="iValue" Type="int" InitValue="0" Comment="好感度值"/>
-- </struct>
function RoleDataManager:UpdateDisposition(kRetData)
    for i = 1, getTableSize(kRetData.akDispositions) do
        local kRoleDisposition = kRetData.akDispositions[i-1]

        local srcRoleTypeID = kRoleDisposition.uiFromTypeID
        local num = kRoleDisposition.iNums

        if num == 0 then
            self.akDispositions[srcRoleTypeID] = nil
        else
            self.akDispositions[srcRoleTypeID] = self.akDispositions[srcRoleTypeID] or {}
            for index = 0, num - 1 do
                local dstRoleTypeID = kRoleDisposition.auiToTypeIDList[index]
                local value = kRoleDisposition.aiValueList[index]

                if value == 0 and dstRoleTypeID ~= self:GetMainRoleTypeID() then
                    self.akDispositions[srcRoleTypeID][dstRoleTypeID] = nil
                else
                    self.akDispositions[srcRoleTypeID][dstRoleTypeID] = {["iValue"] = value}
                end

                self:UpdateDisplayFavor(srcRoleTypeID, dstRoleTypeID, value)
            end
        end
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_DISPOSITION", kRetData)
end

-- 获取一个角色的好感度【动态数据】，返回的是一个数组，存储角色对目标角色的好感
-- 数组的下标 为 【roleID，动态ID】
function RoleDataManager:GetDispositions(srcRoleID)
    local srcTypeRoleID = self:GetRoleTypeID(srcRoleID)

    if srcTypeRoleID and self.akDispositions then
        return self.akDispositions[srcTypeRoleID]
    end
end

-- 获取角色好感度【动态+静态】数据，返回数组，存储角色对目标角色的好感、描述ID
-- 数组的下标 统一为 【roleTypeID，静态ID】
function RoleDataManager:GetDispositionData(roleID, roleTypeID)
    if not roleID then return end
    -- 先拼接静态数据，再读取动态数据，覆盖静态数据
    -- 如果有动态数据 就直接取动态数据
    local disData = {}
    local ifinstMainrole = false
    local roleTypeData = nil
    if roleTypeID then
        roleTypeData = self:GetRoleTypeDataByTypeID(roleTypeID)
    else
        roleTypeData = self:GetRoleTypeDataByID(roleID)
    end
    if not roleTypeData then return end     -- 静态数据肯定要有
    local relationID = roleTypeData['RelationID']
    local relationDisposition = roleTypeData.RelationDisposition
    local relationDescID = roleTypeData.RelationDescID

    local evoDesMap = EvolutionDataManager:GetInstance():GetDispositionDesEvo(roleID)

    local mainRoleTypeID = self:GetMainRoleTypeID()

    local dispositions = self:GetDispositions(roleID)
    if dispositions then
        for roleTypeID,v in pairs(dispositions) do
            if roleTypeID == 0 then
                local typeData = self:GetRoleTypeDataByTypeID(roleTypeID);
                roleTypeID = typeData and typeData.RoleID or 0;
            elseif mainRoleTypeID == roleTypeID then 
                ifinstMainrole = true
            end
            if roleTypeID > 0 then
                if not disData[roleTypeID] then
                    disData[roleTypeID] = {}
                end
                if (dispositions[roleTypeID]) then
                    for key,var in pairs(dispositions[roleTypeID])  do
                        disData[roleTypeID].iValue = var
                        if evoDesMap[roleTypeID] then
                            disData[roleTypeID].DescID = evoDesMap[roleTypeID]
                        end
                    end
                end
            end
        end
    end
    if not ifinstMainrole then 
        if disData[mainRoleTypeID] then 
            local roleData = self:GetRoleData(roleID)
            if roleData and roleData.roleType ~= ROLE_TYPE.INST_ROLE then
                local iva = disData[mainRoleTypeID].iValue + CardsUpgradeDataManager:GetInstance():GetRoleExFavorByRoleID(roleTypeData.RoleID)
                disData[mainRoleTypeID].iValue = iva
            end 
        else
            if relationDisposition and relationID  then
                for i = 1, #relationID do
                    if relationID[i] == mainRoleTypeID then
                        if not disData[mainRoleTypeID] and relationDisposition[i] then
                            local iva = relationDisposition[i] + CardsUpgradeDataManager:GetInstance():GetRoleExFavorByRoleID(roleTypeData.RoleID)
                            disData[mainRoleTypeID] = {iValue = iva}
                        end
                    end
                end
            end
        end 
    end

    if roleTypeData and relationID and relationDescID then
        for i = 1, #relationID do
            if relationDescID[i] and relationDescID[i] > 0 then
                if disData[relationID[i]] and not disData[relationID[i]].DescID then
                    disData[relationID[i]].DescID = relationDescID[i]
                end
            end
        end
    end

    return disData
end

-- 获取 roleID 对主角的 好感度结构。
-- 这里动态ID 获取动态数据，静态ID 获取数据表
-- 因为对话界面 只有静态ID，没有动态ID，反查得到0，就不能再正查了。
function RoleDataManager:GetDispotionDataToMainRole(roleID, roleTypeID)
    local mainRoleTypeID = self:GetMainRoleTypeID()
    local favorData = self:GetDispositionData(roleID, roleTypeID)
    if favorData and favorData[mainRoleTypeID] then
        return favorData[mainRoleTypeID]
    end

    -- TODO 成就加成
    local iValue = ROLE_DEFAULT_DISPOSITION;
    local info = globalDataPool:getData("MainRoleInfo");
    if info and info.MainRole then
        iValue = info.MainRole[MainRoleData.MRD_DEFAULT_GOOD];
    end

    -- 加角色卡好感度加成
    iValue = iValue + CardsUpgradeDataManager:GetInstance():GetRoleExFavorByRoleID(self:GetRoleTypeID(roleID))
    return {["iValue"] = iValue}
end

function RoleDataManager:GetDispotionValueToMainRole(roleID)
    local dispoData = self:GetDispotionDataToMainRole(roleID)
    if (dispoData ~= nil and dispoData.iValue ~= nil) then
        return dispoData.iValue
    end

    return 0
end

-- 获取角色对主角的动画用好感度[!] 动画用的，不是真正的好感度
function RoleDataManager:GetDisplayFavor(srcRoleTypeID, dstRoleTypeID)
    if (srcRoleTypeID == nil) or (dstRoleTypeID == nil) then return end
    local info = globalDataPool:getData("DisplayFavor")
    if not info then return end
    return info[srcRoleTypeID..':'..dstRoleTypeID]
end

-- 存储角色对主角的动画用好感度
function RoleDataManager:UpdateDisplayFavor(srcRoleTypeID, dstRoleTypeID, value)
    if (srcRoleTypeID == nil) or (dstRoleTypeID == nil) then return end
    local info = globalDataPool:getData("DisplayFavor") or {}
    if self:GetMainRoleTypeID() == dstRoleTypeID then
        local oldValue = info[srcRoleTypeID..':'..dstRoleTypeID]
        if oldValue then
            local offvalue = value - oldValue
            if offvalue ~= 0 then
                -- 显示好感度过渡动画
                local winMgr = WindowsManager:GetInstance()
                if winMgr:IsWindowOpen("SelectUI") then
                    local win = winMgr:GetUIWindow("SelectUI")
                    win:ShowRoleFavorUp(srcRoleTypeID, oldValue, value)
                elseif winMgr:IsWindowOpen("DialogChoiceUI") then
                    local win = winMgr:GetUIWindow("DialogChoiceUI")
                    win:ShowRoleFavorUp(srcRoleTypeID, oldValue, value)
                else
                    self:CacheRoleFavorChangeMsg(srcRoleTypeID, oldValue, value)
                end
            end
        end
    end
    info[srcRoleTypeID..':'..dstRoleTypeID] = value
    globalDataPool:setData('DisplayFavor', info, true)
end

-- 缓存角色好感度变化信息
function RoleDataManager:CacheRoleFavorChangeMsg(roleTypeID, iStart, iEnd)
    local info = globalDataPool:getData("RoleFavorChangeMsg") or {}
    info[roleTypeID] = {
        ['roleTypeID'] = roleTypeID,
        ['iStart'] = iStart,
        ['iEnd'] = iEnd
    }
    globalDataPool:setData('RoleFavorChangeMsg', info, true)
end

-- 读取角色好感度变化信息
function RoleDataManager:ReadRoleFavorChangeMsg(roleTypeID)
    if not roleTypeID then return end
    local info = globalDataPool:getData("RoleFavorChangeMsg") or {}
    local toRet = info[roleTypeID]
    info[roleTypeID] = nil
    globalDataPool:setData('RoleFavorChangeMsg', info, true)
    return toRet
end

-- 获取角色初始行动时间(按速度值)
function RoleDataManager:GetInitialActionTime(roleID,speed)
    local tableDataManager = TableDataManager:GetInstance()
    local battleFactorData = TableDataManager:GetInstance():GetTableData("BattleFactor",1)
    if battleFactorData == nil then
        return  2
    end
    local fSpeedn = 0.1
    if battleFactorData.speed_n ~= 0 then
        fSpeedn = battleFactorData.speed_n
    end
    local iSuDuZhi = 1
    local iSuDuBianDong = 1
    local roleData = self:GetRoleData(roleID)
    if roleData and roleData.aiAttrs then
        iSuDuZhi = roleData.aiAttrs[AttrType.ATTR_SUDUZHI] 
        iSuDuBianDong = roleData.aiAttrs[AttrType.MP_SUDUBIANDONG] or 0
    end
    if speed then
        iSuDuZhi = speed
    end
    local speedDownPanelData = tableDataManager:GetTableData("BattleFactorRelate",BattleFactorType.BFACT_speedDownPanel)
    local speedUpPanelData = tableDataManager:GetTableData("BattleFactorRelate",BattleFactorType.BFACT_speedUpPanel)
    local speedChangeFactorData = tableDataManager:GetTableData("BattleFactorRelate",BattleFactorType.BFACT_speedChangeFactor)

    local fSpeedBase = (iSuDuZhi + battleFactorData.speed_m) / (iSuDuZhi + fSpeedn)
    Clamp(fSpeedBase,speedDownPanelData.Value,speedUpPanelData.Value)
    local iSpeed = fSpeedBase * (1+ speedChangeFactorData.Value *iSuDuBianDong)

    local speedNormData = tableDataManager:GetTableData("BattleFactorRelate",BattleFactorType.BFACT_speedNorm)
    local speedMinFactorData = tableDataManager:GetTableData("BattleFactorRelate",BattleFactorType.BFACT_speedMinFactor)
    local speedUpData = tableDataManager:GetTableData("BattleFactorRelate",BattleFactorType.BFACT_speedUp)
    local speedDownData = tableDataManager:GetTableData("BattleFactorRelate",BattleFactorType.BFACT_speedDown)

    local fValueA = speedNormData.Value + iSpeed * - speedMinFactorData.Value
    local fValueB = speedUpData.Value

    local iActionTime = Clamp(fValueA,speedDownData.Value,fValueB)
    return iActionTime
end

local array_basic_attack = 
{
    [AttrType.ATTR_JIANFAATK] =             "剑法攻击",
    [AttrType.ATTR_DAOFAATK] =              "刀法攻击",
    [AttrType.ATTR_QUANZHANGATK] =          "拳掌攻击",
    [AttrType.ATTR_TUIFAATK] =              "腿法攻击",
    [AttrType.ATTR_QIMENATK] =              "奇门攻击",
    [AttrType.ATTR_ANQIATK] =               "暗器攻击",
    [AttrType.ATTR_YISHUATK] =              "医术攻击",
    [AttrType.ATTR_NEIGONGATK] =            "内功攻击",
}

function RoleDataManager:GetMaxAttrack(roleData)
    local tab_max = {
        ['enum'] = AttrType.ATTR_JIANFAATK,
        ['key'] = '攻击',
        ['value'] = 0,
    } 
    for k,v in pairs(array_basic_attack) do
        local val = roleData.aiAttrs[k] or 0
        tab_max = val > tab_max.value and {['enum'] = k,['key'] = v,['value'] = val} or tab_max
        -- dprint('最大的是',tab_max.key,tab_max.value)
    end
    return tab_max
end

--玩家是否在剧本中
function RoleDataManager:IsPlayerInGame()
    local info = globalDataPool:getData("GameData") or {}
    local curState = info['eCurState']
    return curState and (curState ~= GS_NULL)
end

--获取玩家当前难度系数
function RoleDataManager:GetDifficultyValue()
    return globalDataPool:getData("ScriptDiff") or 1
end

function RoleDataManager:UpdateInteractDate(retStream)
    local uiRoleID = retStream.uiRoleID
    local eInteractType = retStream.eInteractType

    if not self.akInteractDates[uiRoleID] then
        self.akInteractDates[uiRoleID] = {}
    end

    local roleInteractDateMap = self.akInteractDates[uiRoleID]
    roleInteractDateMap[eInteractType] = retStream
end

function RoleDataManager:GetRoleInteractData(uiRoleID, eInteractType)
    -- 观摩共用请教的冷却
    if eInteractType and eInteractType >= NPCIT_STEAL and eInteractType <= NPCIT_STEAL_MARTIAL then
        eInteractType = (eInteractType - NPCIT_STEAL) + NPCIT_CONSULT
    end

    if not self.akInteractDates[uiRoleID] then
        return
    end
    local roleInteractDateMap = self.akInteractDates[uiRoleID]
    return roleInteractDateMap[eInteractType]
end

-- NPCIT_STEAL = 6                         
-- NPCIT_STEAL_GIFT = 7                   
-- NPCIT_STEAL_MARTIAL = 8                 
-- NPCIT_CONSULT = 9                       
-- NPCIT_CONSULT_GIFT = 10               
-- NPCIT_CONSULT_MARTIAL = 11 
function RoleDataManager:InteractAvailable(uiRoleID, eInteractType)
    if not eInteractType then
        return false
    end

    if eInteractType == NPCIT_STEAL_GIFT or eInteractType == NPCIT_STEAL_MARTIAL then
        eInteractType = NPCIT_STEAL
        return true 
    end

    if eInteractType == NPCIT_CONSULT_GIFT or eInteractType == NPCIT_CONSULT_MARTIAL then
        eInteractType = NPCIT_CONSULT
    end

    local kInteractDate = self:GetRoleInteractData(uiRoleID, eInteractType)
    if not kInteractDate then
        return true
    else
        if kInteractDate.uiTimes < 1 then
            return true
        else
            return false
        end
    end
end

function RoleDataManager:UpdateRefreshTimes(uiType, uiTimes)
    self.akRefreshTimes[uiType] = uiTimes
    LuaEventDispatcher:dispatchEvent("UPDATE_INTERACT_REFRESHTIMES",uiType)
end

function RoleDataManager:GetRefreshTimes(uiType, uiTimes)
    -- 偷学共用请教的刷新次数
    if uiType == PlayerBehaviorType.PBT_TouXue then
        uiType = PlayerBehaviorType.PBT_QingJiao
    end

    return self.akRefreshTimes[uiType] or 0
end

-- 设置当前选择的角色
function RoleDataManager:SetCurSelectRole(roleID)
    globalDataPool:setData("CurSelectRole", roleID, true)
end

-- 获取当前选中的角色
function RoleDataManager:GetCurSelectRole()
    return globalDataPool:getData("CurSelectRole") or 1
end

-- 获取角色的交互选项
function RoleDataManager:GetInteractChoice(roleTypeID, mapID, mazeTypeID, areaIndex, cardTypeID, row, column)
    if self.interactChoiceMap == nil or type(roleTypeID) ~= 'number' or (self.interactChoiceMap[0] == nil and self.interactChoiceMap[roleTypeID] == nil) then 
        return {}
    end
    local optionList = self.interactChoiceMap[roleTypeID] or {}
    local allRoleOptionList = self.interactChoiceMap[0] or {}
    local retOptionList = {}
    for _, option in ipairs(optionList) do 
        local oMapID = option.mapID
        if mapID and (mapID & 0x20000000) ~=0 then
            oMapID = oMapID & 0x200000ff --city
        end
        if (self:IsEventArgEqual(oMapID, mapID) and self:IsEventArgEqual(option.mazeTypeID, mazeTypeID)
        and self:IsEventArgEqual(option.areaIndex, areaIndex) and self:IsEventArgEqual(option.cardID, cardTypeID)
        and self:IsEventArgEqual(option.row, row) and self:IsEventArgEqual(option.column, column)) then 
            table.insert(retOptionList, option)
        end
    end
    for _, option in ipairs(allRoleOptionList) do
        local oMapID = option.mapID
        if mapID and (mapID & 0x20000000) ~=0 then
            oMapID = oMapID & 0x200000ff --city
        end
        if (self:IsEventArgEqual(oMapID, mapID) and self:IsEventArgEqual(option.mazeTypeID, mazeTypeID)
        and self:IsEventArgEqual(option.areaIndex, areaIndex) and self:IsEventArgEqual(option.cardID, cardTypeID)
        and self:IsEventArgEqual(option.row, row) and self:IsEventArgEqual(option.column, column)) then 
            table.insert(retOptionList, option)
        end
    end
    return retOptionList
end

function RoleDataManager:AddInteractChoice(newOption)
    if type(newOption) ~= 'table' then 
        return 
    end
    local roleTypeID = newOption.roleTypeID
    local mapID = newOption.mapID
    if (mapID & 0x70000000) ~= 0 then
        TileDataManager:GetInstance():AddTileEvent(
            roleTypeID, 
            mapID,
            1,
            0, 
            0, 
            newOption.taskID)
    end
    newOption.refCount = 1
    self.interactChoiceMap = self.interactChoiceMap or {}
    if self.interactChoiceMap[roleTypeID] == nil then 
        self.interactChoiceMap[roleTypeID] = {newOption}
        return
    end
    for _, option in ipairs(self.interactChoiceMap[roleTypeID]) do 
        if self:IsOptionEqual(option, newOption) then 
            option.refCount = option.refCount + 1
            return 
        end
    end
    table.insert(self.interactChoiceMap[roleTypeID], newOption)
    LuaEventDispatcher:dispatchEvent("UPDATE_INTERACT_CHOICE")
end

function RoleDataManager:RemoveInteractChoice(newOption)
    if type(newOption) ~= 'table' or self.interactChoiceMap == nil then 
        return 
    end
    local roleTypeID = newOption.roleTypeID
    local mapID = newOption.mapID
    if (mapID & 0x70000000) ~= 0 then
        TileDataManager:GetInstance():RemoveTileEvent(mapID, roleTypeID, 1, 0, 0, newOption.taskID)
    end
    if self.interactChoiceMap[roleTypeID] == nil then
        return         
    end
    for i = #self.interactChoiceMap[roleTypeID], 1, -1 do 
        local option = self.interactChoiceMap[roleTypeID][i]
        if self:IsOptionEqual(option, newOption) then 
            option.refCount = option.refCount - 1
            if option.refCount <= 0 then 
                table.remove(self.interactChoiceMap[roleTypeID], i)
                LuaEventDispatcher:dispatchEvent("UPDATE_INTERACT_CHOICE")
            end
            return
        end
    end
end

function RoleDataManager:ClearInteractChoice()
    self.interactChoiceMap = {}
end

function RoleDataManager:IsEventArgEqual(arg1, arg2)
    if arg1 == 0 or arg2 == 0 or arg1 == nil or arg2 == nil or arg1 == arg2 then 
        return true
    end
    return false
end

function RoleDataManager:IsOptionEqual(option1, option2)
    if type(option1) ~= 'table' or type(option2) ~= 'table' then 
        return false
    end
    for key, value in pairs(option1) do
        if key ~= 'refCount' and key ~= 'isLock' then 
            if option2[key] ~= value then 
                return false
            end
        end
    end
    return true
end

-- 获取角色的 选择角色 事件
function RoleDataManager:GetRoleSelectEvent(roleTypeID, mapID, mazeTypeID, areaIndex, cardTypeID, row, column)
    if self.roleSelectEventMap == nil or type(roleTypeID) ~= 'number' or self.roleSelectEventMap[roleTypeID] == nil then 
        return {}
    end
    local eventList = self.roleSelectEventMap[roleTypeID]
    local retEventList = {}
    for _, event in ipairs(eventList) do 
        if (self:IsEventArgEqual(event.mapTypeID, mapID) and self:IsEventArgEqual(event.mazeTypeID, mazeTypeID)
        and self:IsEventArgEqual(event.areaIndex, areaIndex) and self:IsEventArgEqual(event.cardTypeID, cardTypeID)
        and self:IsEventArgEqual(event.row, row) and self:IsEventArgEqual(event.column, column)) then 
            table.insert(retEventList, event)
        end
    end
    return retEventList
end

-- 新增角色的 选择角色 事件
function RoleDataManager:AddRoleSelectEvent(newEvent)
    if type(newEvent) ~= 'table' then 
        return 
    end
    local roleTypeID = newEvent.roleTypeID
    newEvent.refCount = 1
    self.roleSelectEventMap = self.roleSelectEventMap or {}
    if self.roleSelectEventMap[roleTypeID] == nil then 
        self.roleSelectEventMap[roleTypeID] = {newEvent}
        return
    end
    for _, event in ipairs(self.roleSelectEventMap[roleTypeID]) do 
        if self:IsOptionEqual(event, newEvent) then 
            event.refCount = event.refCount + 1
            return 
        end
    end
    table.insert(self.roleSelectEventMap[roleTypeID], newEvent)
    LuaEventDispatcher:dispatchEvent("UPDATE_ROLE_SELECT_EVENT")
end

-- 移除角色的 选择角色 事件
function RoleDataManager:RemoveRoleSelectEvent(newEvent)
    if type(newEvent) ~= 'table' or self.roleSelectEventMap == nil then 
        return 
    end
    local roleTypeID = newEvent.roleTypeID
    if self.roleSelectEventMap[roleTypeID] == nil then
        return         
    end
    for i = #self.roleSelectEventMap[roleTypeID], 1, -1 do 
        local event = self.roleSelectEventMap[roleTypeID][i]
        if self:IsOptionEqual(event, newEvent) then 
            event.refCount = event.refCount - 1
            if event.refCount <= 0 then 
                table.remove(self.roleSelectEventMap[roleTypeID], i)
                LuaEventDispatcher:dispatchEvent("UPDATE_ROLE_SELECT_EVENT")
            end
            return
        end
    end
end

function RoleDataManager:GetMainRoleRemainGiftPoint()
    local roleData = self:GetMainRoleData()
    return (roleData.aiAttrs[AttrType.ATTR_WUXING] or 0) * 2  - (roleData.uiGiftUsedNum or 0)
    --return mainrole.uiRemainGiftPoint or 0 不知道这个为什么不对
end

function RoleDataManager:GetRoleChatDataByRoleId(roleId)
    if not self.akRoleChatDatas then
        self.akRoleChatDatas = {}
        local TB_RoleChat = TableDataManager:GetInstance():GetTable("RoleChat")
        for _,v in pairs(TB_RoleChat) do
            self.akRoleChatDatas[v.RoleID] = v
        end
    end

    return self.akRoleChatDatas[roleId]
end

function RoleDataManager:GetTaskChoiceCount(selectInfo)
    local choiceInfoList = self:GetChoiceInfoList(selectInfo)
    return #choiceInfoList
end

function RoleDataManager:GetChoiceCount(selectInfo)
	local choiceCount = 0

	-- 计算商店选项
	if self:GetShopID(selectInfo.roleID) ~= 0 then 
		choiceCount = choiceCount + 1
	end

	-- 计算任务选项
    choiceCount = choiceCount + self:GetTaskChoiceCount(selectInfo)

	-- 送信任务选项
	if RoleDataHelper.CheckClanLetterMission(selectInfo.roleID) then 
		choiceCount = choiceCount + 1
	end

	-- 守门人选项
	if RoleDataHelper.CheckDoorKeeper(selectInfo.roleID) then 
		-- FIXME: 守门人不一定只有一个选项
		choiceCount = choiceCount + 1
	end

	-- 门派学武选项
	if RoleDataHelper.CheckSubMaster(selectInfo.roleID, true) then 
		choiceCount = choiceCount + 1
    end
    
	-- 门派踢馆选项
	if RoleDataHelper.CheckMainMaster(selectInfo.roleID, true) then 
		choiceCount = choiceCount + 1
    end

    -- n流高手闲聊
    local roleTypeID = self:GetRoleTypeID(selectInfo.roleID)
    local masterChartID = RoleDataHelper.CheckMasterChat(roleTypeID, selectInfo.mapID) or 0
	if masterChartID > 0 then
		choiceCount = choiceCount + 1
    end
    
    -- 好感突破
    roleTypeID = self:GetRoleTypeID(selectInfo.roleID)
    local dispoValue = self:GetDispotionValueToMainRole(selectInfo.roleID)
    local bShowSubRole = RoleDataHelper.CheckShowSubRole(roleTypeID)
    local isInTeam = RoleDataHelper.GetTeammatesByUID(selectInfo.roleID)
	if dispoValue == 99 and not bShowSubRole and isInTeam and 0 == EvolutionDataManager:GetInstance():GetBreakLimitTaskFlag(selectInfo.roleID) then
		choiceCount = choiceCount + 1
    end

    if bShowSubRole then
		choiceCount = choiceCount + 1
    end
    
    local bBabyLearn = self:CheckBabyMaster(selectInfo.roleID)
    if bBabyLearn then
        choiceCount = choiceCount + 1
    end

	return choiceCount
end

function RoleDataManager:GetShopID(roleID)
	return EvolutionDataManager:GetInstance():GetRoleShopID(roleID) or 0
end

function RoleDataManager:GetChoiceInfoList(selectInfo)
	local choiceInfoList = {}
	local roleTypeID = self:GetRoleTypeID(selectInfo.roleID)
	local optionList = self:GetInteractChoice(roleTypeID, selectInfo.mapID, selectInfo.mazeTypeID, (selectInfo.mazeAreaIndex or 0) + 1, selectInfo.mazeCardBaseID, selectInfo.mazeRow, selectInfo.mazeColumn)
	if optionList then
        for _, option in ipairs(optionList) do 
            local choiceLangID = 0
            if option.isLock == 1 then 
                choiceLangID = option.lockLangID
            else
                choiceLangID = option.choiceLangID
            end
            local choiceInfo = {
                langID = choiceLangID,
                isLock = option.isLock == 1,
                interactType = option.eInteractType,
                taskID = option.taskID,
                mapID = option.mapID
            }
            table.insert(choiceInfoList, choiceInfo)
		end
	end
	return choiceInfoList
end

function GetGameState()
    local info = globalDataPool:getData("GameData") or {}
    return info['eCurState'] or -1
end

function RoleDataManager:GetScriptCreateTime()
	local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        return role_info["MainRole"][MRIT_CREATE_SCRIPT_TIME] or 0        
    end
    return 0
end

function RoleDataManager:GetSilverNum()
	local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        return role_info["MainRole"][MRIT_SILVER] or 0        
    end
    return 0
end

function RoleDataManager:GetGoldNum()
	local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        return role_info["MainRole"][MRIT_GOLD] or 0      
    end

    return 0
end

function RoleDataManager:GetCoinNum()
	local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        return role_info["MainRole"][MRIT_CURCOIN] or 0     
    end
    return 0
end

function RoleDataManager:AddScriptRoleTitle(uiTitleID)
    if uiTitleID == 0 then
        return
    end

    for i = 1, #self.akScriptRoleTitle do
        local kInfo = self.akScriptRoleTitle[i]
        if kInfo == uiTitleID then
            return
        end
    end
    self.akScriptRoleTitle[#self.akScriptRoleTitle + 1] = uiTitleID
end

function RoleDataManager:GetScriptRoleTitle()
    return self.akScriptRoleTitle
end

function RoleDataManager:GetCurMainRoleTitle()
    local info = nil;
    if GetGameState() == -1 then
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        elseif self.bIsFullArenaData then
            info = globalDataPool:getData("PlatTeamInfo") or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
        return info.uiTitleID or 0;
    else
        if self.bIsObserveData then 
            info = globalDataPool:getData("ObserveInfo") or {};
            return info.uiTitleID or 0;
        end
        info = globalDataPool:getData("MainRoleInfo")
        if info and info["MainRole"] then
            return info["MainRole"][MRIT_CUR_TITLE] or 0     
        end
    end
    return 0
end

-- 记录交互状态
function RoleDataManager:LogInteractState(selectInfo)
    if selectInfo == nil then 
        self:ClearInteractState()
    else
        self.interactInfo = selectInfo
    end
end

-- 清空交互状态
function RoleDataManager:ClearInteractState()
    self.interactInfo = nil
    if IsWindowOpen('SelectUI', true) then 
        RemoveWindowImmediately('SelectUI')
    end
end

-- 还原交互状态
function RoleDataManager:RecoverInteractState()
    if self.interactInfo == nil then 
        return
    end

    if IsWindowOpen('SelectUI') then 
        return
    end

    if DisplayActionManager:GetInstance():GetActionListSize() > 0 then 
        return
    end

    if IsBattleOpen() then 
        return 
    end

    if dnull(self.interactInfo.mapID) then 
        if self:GetChoiceCount(self.interactInfo) == 0 then 
            local roleBaseID = self:GetRoleTypeID(self.interactInfo.roleID)
            if RoleDataHelper.CheckMasterChat(roleBaseID, self.interactInfo.mapID, self.interactInfo.mazeTypeID, self.interactInfo.mazeAreaIndex) == 0 then 
                return
            end
        end
        -- 如果交互位置不为空, 需要检查交互角色是否仍然在交互位置上
        if not dnull(self.interactInfo.mazeTypeID) 
        and not MapDataManager:GetInstance():IsRoleInMap(self.interactInfo.roleID, self.interactInfo.mapID) 
        and not TileDataManager:GetInstance():HasRole(self.interactInfo.roleID) then 
            return
        end
    end

    if( GetCurScriptID() == 4 and self.interactInfo.mapID == nil) then
        return
    end

    -- 部分界面不允许恢复交互界面
    if IsWindowOpen('StoreUI') or IsWindowOpen('RandomRollUI') or IsWindowOpen('DialogChoiceUI') or IsWindowOpen('DialogueUI') or IsWindowOpen('ChoiceUI') then
        return
    end

    -- 只有在 城市界面, 迷宫界面, 角色界面 可以恢复交互界面
    self.interactInfo.recover = true
    OpenWindowByQueue("SelectUI", self.interactInfo)
end

function RoleDataManager:UpdateInviteable(uiRoleTypeID, bInviteable)
    self.akRoleTypeIDInviteable[uiRoleTypeID] = bInviteable
end

function RoleDataManager:UpdateRedKnife(uiItemID, uiCuiLianValue)
    if not uiItemID then
        return
    end
    if not self.akRedKnifes then
        self.akRedKnifes = {}
    end
    self.akRedKnifes[uiItemID] = uiCuiLianValue or 0
end

function RoleDataManager:DeleteRedKnife(uiItemID)
    if not uiItemID then
        return
    end
    if not self.akRedKnifes then
        self.akRedKnifes = {}
    end
    self.akRedKnifes[uiItemID] = nil
end

function RoleDataManager:CheckBabyMaster(uiBabyRoleID)
    local babyStateInfo = self.akBabyStates[uiBabyRoleID]
    if babyStateInfo then
        local scriptTime = EvolutionDataManager:GetInstance():GetRivakeTime()
        if babyStateInfo.uiNextLearnTime <= scriptTime then
            return true
        end
    end
end

function RoleDataManager:GetBabyInfoAll()
    return self.akBabyStates
end
function RoleDataManager:GetBabyInfoByBabyRoleID(uiBabyRoleID)
    return self.akBabyStates[uiBabyRoleID]
end

function RoleDataManager:UpdateBabyState(uiBabyRoleID, kInfo)
    self.akBabyStates[uiBabyRoleID] = kInfo
end

function RoleDataManager:GetRedKnifeCuiLian(uiItemID)
    return self.akRedKnifes[uiItemID]
end

function RoleDataManager:GetInviteable(uiRoleTypeID)
    if self.akRoleTypeIDInviteable[uiRoleTypeID] ~= nil then
        return self.akRoleTypeIDInviteable[uiRoleTypeID] == TBoolean.BOOL_YES
    else
        local dbRole = TB_Role[uiRoleTypeID]
        if dbRole then
            local flagNum = dbRole.TeamCondition
            local enable, des = TeamCondition:GetInstance():CheckTeamCondition(flagNum, true)
            return enable, des
        end
    end

    return false
end

local checkInteractUnlock = {
    [PlayerBehaviorType.PBT_QiTao] = true,
    [PlayerBehaviorType.PBT_JueDou] = true,
    [PlayerBehaviorType.PBT_RECAST] = true,
    [PlayerBehaviorType.PBT_STRENGTHEN] = true,
    [PlayerBehaviorType.PBT_SMELT] = true,
    [PlayerBehaviorType.PBT_CallUp] = true,
    [PlayerBehaviorType.PBT_Punish] = true,
    [PlayerBehaviorType.PBT_INQUIRY] = true,
}

function RoleDataManager:IsInteractUnlock(playerBehavior)
    local info = globalDataPool:getData("MainRoleInfo")
    local flag = 0
    local unLockConfig
    local scriptUnlock = false
    local platformUnlock = false

    if info and info["MainRole"] then
        flag = info["MainRole"][MRIT_INTERACT_UNLOCK_FLAG] or 0
    end

    local TB_InteractUnLock = TableDataManager:GetInstance():GetTable("InteractUnLock")
    for _, value in pairs(TB_InteractUnLock) do
        if value.PlayerBehavior == playerBehavior then
            unLockConfig = value
        end
    end
    
    -- 永久解锁的交互也要在剧本的某个阶段才能打开
    if unLockConfig and unLockConfig.UnlockOnceTag > 0 then
        local iValue = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(unLockConfig.UnlockOnceTag) or 0
        scriptUnlock = (iValue > 0)
        return scriptUnlock
    end

    if checkInteractUnlock[playerBehavior] then
        -- 检查剧本内是否解锁
        scriptUnlock = HasFlag(flag, playerBehavior)
        if scriptUnlock then 
            return true
        end
    end

    return false 
end

function RoleDataManager:SetFullArenaData(bIsFullArenaData, uiScript)
    self.bIsFullArenaData = bIsFullArenaData;
    self.uiScript = uiScript;
end

function RoleDataManager:SetObserveData(bIsObserveData)
    self.bIsObserveData = bIsObserveData;
end

function RoleDataManager:SetArenaObserveData(bIsArenaObserveData)
    self.bIsArenaObserveData = bIsArenaObserveData;
end

function RoleDataManager:CanRolePublishGovernmentTask(roleID, mapID)
    local config = TableDataManager:GetInstance():GetTableData("GovernmentTaskConfig",1)
    if config == nil then
        DRCSRef.LogError('[RoleDataManager]->CanRolePublishGovernmentTask Government task config is not exist!')
        return false 
    end

    local bGovermentRole = false
    local roleBaseID = self:GetRoleTypeID(roleID)
    for index, publishRoleBaseID in ipairs(config.TaskPublishList) do 
        if roleBaseID == publishRoleBaseID and mapID == config.TaskPublishMapList[index] then 
            bGovermentRole = true
            break
        end
    end

    -- 判断当前城市好感度
    if bGovermentRole then
        local curCityID = CityDataManager:GetInstance():GetCurCityID()
        local curCityData = nil
        if curCityID and curCityID ~= 0 then
            curCityData = CityDataManager:GetInstance():GetCityData(curCityID)
        end
        if not curCityData then
            return false
        elseif not curCityData.iCityDispo or curCityData.iCityDispo >= 100 then
            return false
        end

        return true
    end

    return false
end

-- 获取交互信息
function RoleDataManager:GetSelectInfo()
    return self.selectInfo
end

-- 交互行为
function RoleDataManager:TryInteract(roleID, mapID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn, cardBaseID, cardID)
    SendClickTryInteractWithNpc(roleID, mapID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn, cardBaseID, cardID)
    local roleTypeID = self:GetRoleTypeID(roleID)
    self.selectInfo = {
        roleID = roleID,
        mapID = mapID,
        mazeTypeID = mazeBaseID,   
        mazeAreaIndex = mazeAreaIndex,
        mazeRow = mazeRow,
        mazeColumn = mazeColumn,
        mazeCardBaseID = cardBaseID,
        mazeCardID = cardID
    }
    if not self:CanRoleInteract(self.selectInfo) then 
        self:ClearInteractState()
        SendClickNpcCMD(mapID, roleID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn)
    else
        if not IsBattleOpen() then
            self:EnterInteractState(roleID, mapID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn, cardBaseID, cardID)
        end
    end
end

-- 直接进入交互状态, 不走选择角色逻辑
function RoleDataManager:DirectInteract(roleID, mapID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn, cardBaseID, cardID)
    SendClickTryInteractWithNpc(roleID, mapID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn, cardBaseID, cardID)
    if not self:IsRevengeRole(roleID) then
        self:EnterInteractState(roleID, mapID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn, cardBaseID, cardID)
    else
        SendClickNpcCMD(mapID, roleID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn)
    end
end

function RoleDataManager:EnterInteractState(roleID, mapID, mazeBaseID, mazeAreaIndex, mazeRow, mazeColumn, cardBaseID, cardID, clanBranchID)
    local roleTypeID = self:GetRoleTypeID(roleID)
    self.selectInfo = {
        roleID = roleID,
        mapID = mapID,
        mazeTypeID = mazeBaseID,   
        mazeAreaIndex = mazeAreaIndex,
        mazeRow = mazeRow,
        mazeColumn = mazeColumn,
        mazeCardBaseID = cardBaseID,
        mazeCardID = cardID,
        clanBranchID = clanBranchID or 0
    }
    self:LogInteractState(self.selectInfo)
    PlayNPCSound(roleTypeID)
    OpenWindowByQueue("SelectUI", self.selectInfo)
end

function RoleDataManager:HasSelectRoleListener(roleID, mapID)
    local roleBaseID = self:GetRoleTypeID(roleID)
	local roleSelectEventList = self:GetRoleSelectEvent(roleBaseID, mapID)
	if #roleSelectEventList > 0 then
		return true
    end
    return false
end

function RoleDataManager:CanRoleInteract(selectInfo)
    local roleID = selectInfo.roleID
    local mapID = selectInfo.mapID
    local mazeBaseID = selectInfo.mazeTypeID
    local mazeAreaIndex = selectInfo.mazeAreaIndex
    local mazeRow = selectInfo.mazeRow
    local mazeColumn = selectInfo.mazeColumn
    local cardBaseID = selectInfo.mazeCardBaseID
    local cardID = selectInfo.mazeCardID
    if self:IsRevengeRole(roleID) then
        return false
    end
    if self:HasSelectRoleListener(roleID, mapID) then
        return false 
    end

    do return true end --现在默认会有闲聊，所以返回true

    local choiceCount = self:GetChoiceCount(selectInfo)
    if choiceCount > 0 then
        return true
	end
	
	if RoleDataHelper.CheckClanSelecttion(selectInfo.roleID) then
		return true
	end

    local roleTypeID = self:GetRoleTypeID(roleID);
	local masterChartID = RoleDataHelper.CheckMasterChat(roleTypeID, selectInfo.mapID) or 0
	if masterChartID > 0 then
		return true
	end

    -- 丐帮密函
	if roleTypeID == 1000114001 then
		return true
	end

	return false
end


-- 获取当前队友上限
function RoleDataManager:GetCurTeammateLimit()
    if not self.kTeammateLimit then
        self.kTeammateLimit = {}
        local kCommonconfig = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
        if kCommonconfig then
            self.kTeammateLimit[true] = kCommonconfig.VIPTeammateLimit or 0
            self.kTeammateLimit[false] = kCommonconfig.NormalTeammateLimit or 0
        end
    end
    local bVIPState = (TreasureBookDataManager:GetInstance():GetTreasureBookVIPState() == true)
    return self.kTeammateLimit[bVIPState] or 0
end

-- 当前队友是否已满
function RoleDataManager:IfTeammateNumFull()
    local kTeammates = self:GetRoleTeammates(false) or {}
    local iCur = #kTeammates
    if kTeammates[0] ~= nil then
        iCur = iCur + 1
    end
    local iMax = self:GetCurTeammateLimit() or 0
    return iCur >= iMax
end

-- 获取当前难度数值上限
function RoleDataManager:GetCurDiffValueLimit(strKey)
    if (not strKey) or (strKey == "") then
        return 0
    end
    local iCurDiff = self:GetDifficultyValue()
    if not iCurDiff then
        return 0
    end
    local kDiffInfo = StoryDataManager:GetInstance():GetStoryDifficultData(GetCurScriptID(), iCurDiff)
    if not kDiffInfo then
        return 0
    end
    return kDiffInfo[strKey] or 0
end

function RoleDataManager:IsRevengeRole(roleID)
    if self.roleRevengeDispositionUpvalue == nil then 
        local config = TableDataManager:GetInstance():GetTableData('DispositionConfig', 1)
        if config and config.RoleRevengeUpValue ~= nil then 
            self.roleRevengeDispositionUpvalue = config.RoleRevengeUpValue
        end
    end
    local roleDisposition = self:GetDispotionValueToMainRole(roleID)
    if roleDisposition <= (self.roleRevengeDispositionUpvalue or -200) then 
        return true
    end
    return false
end

function RoleDataManager:GetRoleClanID(roleID)
    local roleData = self:GetRoleData(roleID)
    local roleBaseData = self:GetRoleTypeDataByID(roleID)
    return RoleDataHelper.GetRoleClan(roleData, roleBaseData)
end

-- 获取角色身上的武学数量
function RoleDataManager:GetRoleMartialCount(roleID, bExceptAoYi)
    local kMartialList = MartialDataManager:GetInstance():GetRoleMartial(roleID) or {}
    local kMartialBaseData = nil
    local uiNormalMartialCount = 0
    local kTBMartial = TableDataManager:GetInstance():GetTable("Martial")
    for uiMartialBaseID, kInstMartial in pairs(kMartialList) do
        kMartialBaseData = kTBMartial[uiMartialBaseID]
        if kMartialBaseData then
            if (bExceptAoYi ~= true)
            or ((bExceptAoYi == true) and (kMartialBaseData.KFFeature ~= KFFeatureType.KFFT_AustrianMartialArts)) then
                uiNormalMartialCount = uiNormalMartialCount + 1
            end
        end
    end
    return uiNormalMartialCount
end

function RoleDataManager:GetStoryMasterData(roleID)
    if not self.storyMasterCache then
        local curStroy = GetCurScriptID()
        self.storyMasterCache = {}
        local TB_NPCMaster = TableDataManager:GetInstance():GetTable("NpcMaster")
        for key, value in pairs(TB_NPCMaster) do
            if not self.storyMasterCache[value.Role] or self.storyMasterCache[value.Role].BaseID > value.BaseID then
                
                if value.Story == nil or #value.Story == 0  then
                    self.storyMasterCache[value.Role] = value
                else
                    for index, openStroy in ipairs(value.Story) do
                        if openStroy == curStroy then
                            self.storyMasterCache[value.Role] = value
                        end
                    end
                end

            end
        end
    end

    return self.storyMasterCache[roleID]
end

function RoleDataManager:UpdatePlayerInfo(playerID, playerInfo)
    self.playerInfoMap[playerID] = playerInfo
end

function RoleDataManager:GetPlayerInfo(playerID)
    return self.playerInfoMap[playerID]
end

function RoleDataManager:GetPlayerName(playerID)
    local playerInfo = self.playerInfoMap[playerID]
    if playerInfo then 
        if playerInfo.bIsUnlockHouse == 1 or playerInfo.bIsUnlockHouse == true then 
            return playerInfo.acPlayerName
        else
            return STR_ACCOUNT_DEFAULT_NAME
        end
    end
    return ''
end

function RoleDataManager:GetPlayerIDByName(playerName)
    for playerID, playerInfo in pairs(self.playerInfoMap) do 
        if playerName == playerInfo.acPlayerName then 
            return playerID
        end
    end
    return 0
end

function RoleDataManager:GetAssistTipsInfo(embattleData,allpetdata,strRoleName)
    local strContent = {}
    local map_allpet = {}
    for k,petData in pairs(allpetdata) do
        map_allpet[petData.uiBaseID] = petData
    end
	for index, data in ipairs(embattleData) do
		--宠物
		if data.bPet > 0 then
            local tb_petdata = TableDataManager:GetInstance():GetTableData("Pet",data.uiRoleID)
            if tb_petdata then 
                
                local petData = map_allpet[data.uiRoleID ]
                if petData then 
                    local str_petname = GetLanguageByID(tb_petdata.NameID)
                    if petData.uiFragment and petData.uiFragment > 0 then 
                        str_petname = str_petname .. '+' ..  petData.uiFragment
                    end
                    str_petname = getRankBasedText(tb_petdata.Rank, str_petname)
                    strContent[#strContent + 1] = string.format("<size=24>%s</size>",str_petname)
                    local _str = CardsUpgradeDataManager:GetInstance():GetPetCardDesc(petData.uiBaseID,petData.uiFragment)
                    for i,v in ipairs(_str or {}) do 
                        if v and v.lock == false then 
                            strContent[#strContent + 1] = "　·"..(v.basedesc or "")
                        end
                    end 
                end
            end
			strContent[#strContent + 1] = '　'
		--角色
		else
			local gift = GiftDataManager:GetInstance():isExistAssistGift(data.uiRoleID)
            if gift then 
                local strName = ""
                if strRoleName then 
                    strName = strRoleName[data.uiRoleID]
                else
                    strName = self:GetRoleName(data.uiRoleID)
                end
                
				strContent[#strContent + 1] = string.format("<size=24>%s</size>",strName)
				strContent[#strContent + 1] = "　·"..(GetLanguageByID(gift.NameID) or '') .. (GetLanguageByID(gift.DescID) or '')
			end
			strContent[#strContent + 1] = '　'
		end

	end
	local finalStr  = table.concat(strContent, '\n')
	return {
		['content'] = finalStr,
    }
end

function RoleDataManager:GetRoleStatus(roleID, isTypeID)
    if not roleID then
        return StatusType.STT_StatusTypeNull
    end

    local roleTypeID = nil

    if isTypeID then
        roleTypeID = roleID
        roleID = self:GetRoleID(roleTypeID)
    else
        roleTypeID = self:GetRoleTypeID(roleID)
    end

    if roleID then
        local evolution = EvolutionDataManager:GetInstance():GetOneEvolutionByType(roleID, NET_STATUS)
        if evolution then
            return evolution.iParam1
        end
    end

    local roleTypeData = self:GetRoleTypeDataByTypeID(roleTypeID)
    if roleTypeData then
        return roleTypeData.Status
    end

    return StatusType.STT_StatusTypeNull
end

function RoleDataManager:GetRoleExclusiveMartial(roleTypeID)
    local roleTypeData = TB_Role[roleTypeID]
    if roleTypeData and roleTypeData.Kungfu then 
        for index,kungfuID in pairs(roleTypeData.Kungfu) do
            local kungfuData = GetTableData("Martial",kungfuID)
            if kungfuData and kungfuData.Exclusive and #kungfuData.Exclusive > 0 then 
                return kungfuID
            end
        end
    end
end

function RoleDataManager:CorrectRoleID(uiID)
    if not uiID or uiID == 0 then
        return uiID
    end

    local roleTypeID = self:GetRoleTypeID(uiID)
    if not roleTypeID or roleTypeID == 0 then
        return uiID
    end

    local roleID = self:GetRoleID(roleTypeID)
    if not roleID or roleID == 0 then
        return uiID
    end

    return roleID
end

-- 当前可以进行npc交互
function RoleDataManager:CanNPCInteractOper()
    if HighTowerDataManager:GetInstance():IsInHighTowerMap() then
        return false
    end

    return true
end

-- 判断属性类型是不是基础属性
function RoleDataManager:IsBasicAttr(attrType)
    return attrType ~= nil and g_basicAttrMap[attrType]
end

function RoleDataManager:GetMainRoleCreateRoleTypeID()
    local info = nil;
    --
    if GetGameState() == -1 then
        if self.bIsArenaObserveData then
            info = globalDataPool:getData("ObserveArenaInfo") or {};
        elseif self.bIsObserveData then
            info = globalDataPool:getData("ObserveInfo") or {};
        elseif self.bIsFullArenaData then
            info = globalDataPool:getData("NewPlatTeamInfo") or {};
        else
            local dataType = 'ScriptTeamInfo' .. self.uiScript.scriptID;
            info = globalDataPool:getData(dataType) or {};
        end
        return self:GetRoleTypeID(info.dwMainRoleID);
    else
        if self.bIsObserveData then 
            info = globalDataPool:getData("ObserveInfo") or {};
            return info.dwMainRoleID;
        end
        info = globalDataPool:getData("MainRoleInfo")
        if not (info and info["MainRole"] and info["MainRole"][MRIT_CREATR_ROLE_ID]) then
            return 0
        end
        return info["MainRole"][MRIT_CREATR_ROLE_ID]
    end
end

-- 通过角色卡id拿到角色性别
function RoleDataManager:GetRoleSexByTypeID(iRoleTypeID)
    if self.oldRoleIdList == nil then
        self.oldRoleIdList = {}
        local TB_CreateRole = TableDataManager:GetInstance():GetTable("CreateRole")
        for key, value in pairs(TB_CreateRole) do
            local oldRoleID = value.OldRoleID
            self.oldRoleIdList[oldRoleID] = value
        end        
    end
    if self.oldRoleIdList[iRoleTypeID] then
        return self.oldRoleIdList[iRoleTypeID].ModelFeMale
    end
    return SexType.ST_Male
end

return RoleDataManager
