ClanDataManager = class("RoleDataManager")
ClanDataManager._instance = nil

function ClanDataManager:ctor()
end

function ClanDataManager:GetInstance()
    if ClanDataManager._instance == nil then
        ClanDataManager._instance = ClanDataManager.new()
        ClanDataManager._instance:Init()
    end

    return ClanDataManager._instance
end

function ClanDataManager:Init()
    self:ResetManager()
    self.auiMapID2ClanID = {}
    self.smallClanSearchMap = {}
    local TB_ClanEliminate = TableDataManager:GetInstance():GetTable("ClanEliminate")
    for baseid, ClanEliminateDta in pairs(TB_ClanEliminate) do
        self.auiMapID2ClanID[ClanEliminateDta.ClanBuilding] = baseid
        self.smallClanSearchMap[ClanEliminateDta.ClanID] = ClanEliminateDta.IsSmallClan == TBoolean.BOOL_YES
    end
end

function ClanDataManager:ResetManager()
    self.akClanEliminate = {}
    self.akClanBranch = {}
    self.akClanMissions = {}
    self.delegationStartState = nil
    self.delegationTaskPublishConfig = nil
    self.bNewflag = nil
end

-- 根据 门派ID 获取 门派的传家宝（可能不止一个）
function ClanDataManager:GetHeirloomByID(clanID)
    if not clanID then return end
    local clanTypeData = self:GetClanTypeDataByTypeID(clanID)
    if clanTypeData then
        return clanTypeData.ClanTreasure
    end
end

function ClanDataManager:GetAllClanMission()
    return self.akClanMissions
end

function ClanDataManager:GetClanDataByBuildTypeID(uiMapBaseID)
    if self.auiMapID2ClanID[uiMapBaseID] then
        local kClan = self:GetClanShowData(self.auiMapID2ClanID[uiMapBaseID])
        return kClan
    end
end

-- TODO : 这里的逻辑是这样的，遍历静态表，然后取一下对应的动态数据，如果开启阶段有变化的话就用动态的，没有变化就用静态初始的
function ClanDataManager:GetClanShowData(baseID)
    local showData = {}
    local clanData = self:GetClanData(baseID)
    local clanTypeData = self:GetClanTypeDataByTypeID(baseID)
    if not clanData then
        local displayState = clanTypeData.ClanLock
        if self:IsClanUnlockForever(baseID) then
            displayState = ClanLock.CLL_JoinClan
        end

        showData = {['uiClanTypeID'] = clanTypeData.BaseID, ['uiClanDisplayState'] = displayState}
    else
        for k,v in pairs(clanData) do
            showData[k] = v
        end
    end
    return showData
end

-- 根据门派的 baseID 获取门派的动态数据
function ClanDataManager:GetClanData(baseID)
    if baseID == nil then return end
    if self.akClanEliminate[baseID] ~= nil then 
        return self.akClanEliminate[baseID]
    end
    local clanTypeData = self:GetClanTypeDataByTypeID(baseID)
    if clanTypeData == nil then 
        return nil
    end

    local displayState = clanTypeData.ClanLock
    if self:IsClanUnlockForever(baseID) then
        displayState = ClanLock.CLL_JoinClan
    end
    local clanData = {
        uiClanTypeID = baseID,
        uiClanDisplayState = displayState,
        iClanDisposition = 0
    }
    return clanData
end

function ClanDataManager:GetClanTypeDataByTypeID(baseID)
    if not baseID then return end
    return TB_Clan[baseID]
end

function ClanDataManager:UpdateClanData(uiClanTypeID, clanData)
    self.bNewflag = nil
    if uiClanTypeID then
        -- ["uiClanTypeID"] -- 门派的TypeID
		-- ["uiClanDisplayState"]  -- 开启状态/显示状态
		-- ["uiClanState"] -- 门派状态（结盟/驱逐）
        -- ["iClanDisposition"] -- 门派好感度
        self.akClanEliminate[uiClanTypeID] = clanData
        LuaEventDispatcher:dispatchEvent("UPDATE_CLAN_DATA")
    else
        error("lua error => UpdateClanData: uiClanTypeID is null")
    end
end

function ClanDataManager:UpdateMissionData(uiClanTypeID, missionData)
    if uiClanTypeID then
        self.akClanMissions[uiClanTypeID] = missionData
    else
        error("lua error => UpdateClanData: uiClanTypeID is null")
    end
end

-- 门派任务
function ClanDataManager:GetClanMission(uiClanTypeID)
    if uiClanTypeID then
        return self.akClanMissions[uiClanTypeID]
    else
        error("lua error => UpdateClanData: uiClanTypeID is null")
    end
end

-- 门派好感度
function ClanDataManager:GetDisposition(uiClanTypeID)
    if not uiClanTypeID then 
        return 0
    end
    if self.akClanEliminate[uiClanTypeID] then
        return self.akClanEliminate[uiClanTypeID].iClanDisposition or 0
    else
        return 0
    end
end

function ClanDataManager:GetIntroducePlotID(uiClanTypeID)
    local TB_ClanEliminate = TableDataManager:GetInstance():GetTable("ClanEliminate")
    for k, v in pairs(TB_ClanEliminate) do
        if v.ClanID == uiClanTypeID then
            if v.IntroducePlotID > 0 then
                return v.IntroducePlotID
            end
        end
    end
end

-- 更新门派人数
function ClanDataManager:UpdateClanCollectionInfo(kRetData)
    -- ['eQueryType']
    -- ['iNum']
    -- ['akResult']  -- ['dwType']
                     -- ['dwNum']  
    

    self.bNewflag = nil
    local ClanCollectionInfo = globalDataPool:getData("ClanCollectionInfo") or {}

    local iNum = kRetData.iNum
    if iNum and iNum > 0 then
        for index = 0, iNum do
            local result = kRetData.akResult[index]
            if result then
                local dwType = result.dwType
                local dwNum = result.dwNum
                ClanCollectionInfo[dwType] = ClanCollectionInfo[dwType] or {}
                if ClanCollectionInfo[dwType] then 
                    ClanCollectionInfo[dwType] = dwNum
                    globalDataPool:setData("ClanCollectionInfo", ClanCollectionInfo, true)
                end
            end
        end
        LuaEventDispatcher:dispatchEvent("UPDATE_CLAN_INFO_DATA")
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_CLAN_COLLECTIONINFO")
end

-- 获取门派人数
function ClanDataManager:GetClanCollectionInfo(dwType)
    local ClanCollectionInfo = globalDataPool:getData("ClanCollectionInfo") or {}
    if ClanCollectionInfo and ClanCollectionInfo[dwType] then
        return ClanCollectionInfo[dwType]
    end

    return 0
end

-- 获取门派人数
function ClanDataManager:SendQueryClanCollectionInfo(dwClanTypeID)
    local gameMode = globalDataPool:getData("GameMode")
	if (gameMode == "ServerMode") then
		SendQueryClanCollectionInfo(SCCQT_HEAT,dwClanTypeID)
	end
end

-- 设置委托任务的接取状态
function ClanDataManager:SetDelegationTaskState(clanBaseID, hasStartTask)
    self.delegationStartState = self.delegationStartState or {}
    self.delegationStartState[clanBaseID] = hasStartTask
end

-- 门派是否已经开始委托任务
function ClanDataManager:IsClanDelegationTaskStart(clanBaseID)
    if self.delegationStartState == nil then
        return false
    end
    return self.delegationStartState[clanBaseID]
end

-- 判断门派能否踢馆
function ClanDataManager:CanClanBeEliminated(clanBaseID)
    local roleClanTypeID = RoleDataManager:GetInstance():GetMainRoleClanTypeID()
    if not (self:CheckClanState(clanBaseID, CLAN_OPENED) and not self:CheckClanState(clanBaseID, CLAN_DISAPPEAR)) then 
        return false
    end
    -- 本门要出师后才能踢馆
    if roleClanTypeID == clanBaseID and not self:IsMainRoleGraduate() then 
        return false
    end
    return true
end

-- 判断还能不能接取这个门派的委托任务
function ClanDataManager:CanAddDelegationTask(roleID)
    local evo = RoleDataHelper.CheckDoorKeeper(roleID)
    if not evo then
        evo = RoleDataHelper.CheckSubMaster(roleID)
    end

    if evo then
        clanBaseID = evo.iParam1
    else
        return false
    end
    -- 检查是否是主角门派
    local mainRoleClanTypeID = RoleDataManager:GetInstance():GetMainRoleClanTypeID()
    -- 主角门派出师后才可以领取委托
    if clanBaseID == mainRoleClanTypeID and not self:IsMainRoleGraduate() then 
        return false
    end
    -- 检查角色是否满足发放任务条件
    if not self:CanRolePublishDelegationTask(clanBaseID, roleID) then 
        return false
    end
    -- 检查是不是已经在该门派接取过委托任务了
    if self:IsClanDelegationTaskStart(clanBaseID) then 
        return false
    end
    return true, clanBaseID
end

-- 主角是否出师
function ClanDataManager:IsMainRoleGraduate()
    local commonConfigTable = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
    if (commonConfigTable == nil) then
        return false
    end
    local graduateTag = commonConfigTable.GraduateTag
    if graduateTag ~= nil then
        return TaskTagManager:GetInstance():TagIsValue(graduateTag, 1)
    end
	return false
end

-- 角色能否发放门派任务
function ClanDataManager:CanRolePublishDelegationTask(clanBaseID, roleID)
    local dispositionConfig = self:GetDelegationTaskPublishDispositionConfig(clanBaseID, roleID)
    if dispositionConfig == nil then 
        return false
    end
    local clanDisposition = self:GetDisposition(clanBaseID)
    local minDisposition = dispositionConfig.minDisposition
    local maxDisposition = dispositionConfig.maxDisposition
    if clanDisposition >= minDisposition and clanDisposition < maxDisposition then 
        return true
    end
    return false
end

-- 获取委托任务发放要求
function ClanDataManager:GetDelegationTaskPublishDispositionConfig(clanBaseID, roleID)
    local clanBaseData = TB_Clan[clanBaseID]
    if clanBaseData == nil then 
        return nil
    end
    local rank = clanBaseData.Rank or RankType.RT_RankTypeNull
    if self.delegationTaskPublishConfig == nil then 
        -- 先缓存起来, 方便之后查找
        self:InitDelegationTaskPublishConfigCache()
    end
    local clanMemberType = nil
    if RoleDataHelper.CheckDoorKeeper(roleID) then 
        clanMemberType = ClanMemberType.CMET_DOORKEEPER
    elseif RoleDataHelper.CheckSubMaster(roleID) then 
        clanMemberType = ClanMemberType.CMET_TEMP_MASTER
    end
    if clanMemberType ~= nil and self.delegationTaskPublishConfig[rank] then 
        return self.delegationTaskPublishConfig[rank][clanMemberType] 
    end
    return nil
end

-- 初始化门派委托任务发放配置缓存
function ClanDataManager:InitDelegationTaskPublishConfigCache()
    self.delegationTaskPublishConfig = {}
    local TB_DelegationTaskPublishConfig = TableDataManager:GetInstance():GetTable("DelegationTaskPublishConfig")
    for _, config in pairs(TB_DelegationTaskPublishConfig) do 
        if config.PublisherDispositionConfigList ~= nil then 
            local configRank = config.ClanRank
            self.delegationTaskPublishConfig[configRank] = {}
            for _, dispositionConfig in ipairs(config.PublisherDispositionConfigList) do
                local clanMemberType = dispositionConfig.ClanMember
                self.delegationTaskPublishConfig[configRank][clanMemberType] = {
                    minDisposition = dispositionConfig.MinDisposition,
                    maxDisposition = dispositionConfig.MaxDisposition
                }
            end
        end
    end
end

-- 判断门派是否处于可加入状态
function ClanDataManager:IsClanCanJoin(clanBaseID)
    if not clanBaseID or clanBaseID == 0 then
        return false
    end

    -- 先判断是否永久解锁
    if self:IsClanUnlockForever(clanBaseID) then
        return true
    end

    -- 再判断门派显示状态
    local clanData = ClanDataManager:GetInstance():GetClanShowData(clanBaseID)
    if clanData then
        return (clanData.uiClanDisplayState == ClanLock.CLL_JoinClan)
    end
	
	return false
end

-- 判断门派是否永久解锁
function ClanDataManager:IsClanUnlockForever(clanBaseID)
    local UnlockPool = globalDataPool:getData("UnlockPool")
    if UnlockPool and UnlockPool[PlayerInfoType.PIT_CLAN] then
        for _,value in pairs(UnlockPool[PlayerInfoType.PIT_CLAN]) do
            if value.dwTypeID == clanBaseID then
                return true
            end
        end
    end

    return false
end

function ClanDataManager:GetClanNameByBaseID(clanBaseID)
    local clanBaseData = self:GetClanTypeDataByTypeID(clanBaseID)
    if clanBaseData == nil then 
        return ""
    end
    return GetLanguageByID(clanBaseData.NameID)
end


function ClanDataManager:GetClanTiaoXinNum(int_baseid)
    local num = 0
    local clan_base = int_baseid and self:GetClanTypeDataByTypeID(int_baseid)
    if self.akClanEliminate then 
        for i,clanData in pairs(self.akClanEliminate) do 
            if HasFlag(clanData.uiClanState, CLAN_DISAPPEAR) or HasFlag(clanData.uiClanState, CLAN_ALIGN) or HasFlag(clanData.uiClanState, CLAN_DRIVE_OUT) then 
                -- uiClanTypeID
                if clan_base then 
                    local tempclan = self:GetClanTypeDataByTypeID(clanData.uiClanTypeID)
                    if tempclan.Type == clan_base.Type then 
                        num = num + 1 
                    end
                else
                    num = num + 1 
                end
            end
        end 
    end 
    return num
end

function ClanDataManager:GetClanJoinNumber(clanBaseID)
	local tempData = {
		[2] = 569,		-- 丐帮
		[3] = 534,		-- 长生
		[8] = 638,		-- 赤刀
		[10] = 896,		-- 少林
		[12] = 765,		-- 华山
		[63] = 512,		-- 六扇
		[15] = 657,		-- 拜月
		[4] = 456,		-- 武当
		[11] = 234,		-- 峨嵋
    }
    
	-- 加入联网状态下获取人数
	local num = 0
    local gameMode = globalDataPool:getData("GameMode")
    if not clanBaseID or clanBaseID == 0 then
        num = 0
	elseif gameMode == "ServerMode" then
		num = ClanDataManager:GetInstance():GetClanCollectionInfo(clanBaseID)
	else
		num = tempData[clanBaseID]
	end
    num = num or 0
    
    return num
end

function ClanDataManager:GetYeJingYuQinLayer(clanBaseID)
    local clanTypeData = TableDataManager:GetInstance():GetTableData("Clan",clanBaseID)
    local configData = TableDataManager:GetInstance():GetTableData("ClanEliminateConfig",1)
    local layer = 0

    if not configData or not clanTypeData then
        return 0
    end

    local bigClanNum = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(configData.BigClanTag) or 0
    local smallClanNum = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(configData.SmallClanTag) or 0
    if clanTypeData.Rank >= RankType.RT_Golden then
        if bigClanNum > #configData.BigClanBuffPowerList then
            bigClanNum = #configData.BigClanBuffPowerList
        end

        if bigClanNum > 1 then
            layer = configData.BigClanBuffPowerList[bigClanNum]
        end
    else
        layer = (smallClanNum + bigClanNum) * configData.SmallClanBuffPower
    end

    return layer
end

function ClanDataManager:GetGongShouTongMengLayer(clanBaseID)
    local clanTypeData = TableDataManager:GetInstance():GetTableData("Clan",clanBaseID)
    local configData = TableDataManager:GetInstance():GetTableData("ClanEliminateConfig",1)
    local layer = 0
    local tagID = 0

    if not configData or not clanTypeData then
        return 0
    end

    for index = 1, #configData.ClanTypeList do
        if clanTypeData.Type == configData.ClanTypeList[index] then
            if #configData.ClanTypeTagList >= index then
                tagID = configData.ClanTypeTagList[index]
            end
            break
        end
    end

    if tagID == 0 then
        return 0
    end

    local eliminateNum = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(tagID) or 0
    if eliminateNum > #configData.ClanTypeBuffPowerList then
        eliminateNum = #configData.ClanTypeBuffPowerList
    end
    if eliminateNum > 0 then
        layer = configData.ClanTypeBuffPowerList[eliminateNum]
    end

    return layer
end

function ClanDataManager:CheckClanState(clanBaseID, clanState)
    local clanData = self:GetClanData(clanBaseID)
    if not clanData then 
        return false
    end
    return HasFlag(clanData.uiClanState, clanState)
end

function ClanDataManager:GetIfNew(iClanID)
    if iClanID and iClanID ~= 0 then 
        local iPlayerid = tostring(globalDataPool:getData("PlayerID"))
        local haveDone = GetConfig('ClanNotNew' .. iClanID .. '_' .. iPlayerid) 
        return haveDone == 1 and true or false
    end
    return false 
end
function ClanDataManager:SetHaveOB(iClanID)
    self.bNewflag = nil
    if iClanID and iClanID ~= 0 then 
        local iPlayerid = tostring(globalDataPool:getData("PlayerID"))
        SetConfig('ClanNotNew' .. iClanID .. '_' .. iPlayerid,1) 
    end
end
function ClanDataManager:CheckHasNewData()
    if self.bNewflag == nil then 
        -- 更新后重置标记，重新刷新
        for k,v in pairs(TB_Clan) do
            local baseID = v.BaseID
            local clanData = self:GetClanShowData(baseID)
            if clanData.uiClanTypeID and (clanData.uiClanDisplayState == ClanLock.CLL_FamousClan or clanData.uiClanDisplayState == ClanLock.CLL_JoinClan) then
                if not self:GetIfNew(baseID) then 
                    self.bNewflag = true 
                    break 
                end 
            end
        end
    end 
    return self.bNewflag
end

function ClanDataManager:GetClanState(clanBaseID)
    local clanData = self:GetClanData(clanBaseID)
    if not clanData then 
        return 0
    end
    if HasFlag(clanData.uiClanState, CLAN_DISAPPEAR) then 
        return CLAN_DISAPPEAR
    elseif HasFlag(clanData.uiClanState, CLAN_DRIVE_OUT) then 
        return CLAN_DRIVE_OUT
    elseif HasFlag(clanData.uiClanState, CLAN_ALIGN) then 
        return CLAN_ALIGN
    end
    return 0
end

function ClanDataManager:IsSmallClan(clanBaseID)
    if self.smallClanSearchMap == nil then 
        return false
    end
    return self.smallClanSearchMap[clanBaseID] or false
end

--  "uiClanTypeID" 门派typeID
-- 	"uiClanNameID" 门派nameID
-- 	"iDonateNum" 本月捐钱次数
-- 	"uiClanCityID" 门派pos
-- 	"uiClanState" 门派状态"
--  uiClanTreasureID 传家宝ID
function ClanDataManager:UpdateClanBranchData(uiClanTypeID, clanData)
    local tdm = TileDataManager:GetInstance()
    if uiClanTypeID then
        local success = false
        if not self.akClanBranch[uiClanTypeID] and clanData.uiClanState ~= SCT_DELETE then -- 新增地图事件
            success = tdm:AddTileEvent(0,clanData.uiClanCityID,15,clanData.uiClanNameID,11,clanData.uiClanTypeID,15)
        end
        if self.akClanBranch[uiClanTypeID] and clanData.uiClanState == SCT_DELETE then -- 移除地图事件
            tdm:RemoveTileEvent(clanData.uiClanCityID,0,15,clanData.uiClanNameID,11,clanData.uiClanTypeID)
        end
        if success or self.akClanBranch[uiClanTypeID] then
            self.akClanBranch[uiClanTypeID] = clanData
        end
    end
end

function ClanDataManager:SetClanBranchDonate(uiClanTypeID, time)
    local data = EncodeSendSeGC_SetClanBranchState(uiClanTypeID,time)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_SET_CLANBRANCHSTATE, iSize, data)  
end

function ClanDataManager:GetClanBranchData(uiClanID)
    if self.akClanBranch[uiClanID] then
        return self.akClanBranch[uiClanID]
    end
    return nil
end

function ClanDataManager:SetTiGuanState(ID)
    self.tiGuanState = ID
end

function ClanDataManager:GetTiGuanState()
    return self.tiGuanState or 0
end

function ClanDataManager:BattleResult(bWin)
    if bWin == 1 then
        local clanID = TileDataManager:GetInstance():GetCurClan() 
        if clanID ~= 0 then
            local clanData = self:GetClanBranchData(clanID)
            local clanBaseData = TableDataManager:GetInstance():GetTableData("ClanBranch",clanID)
            local trunkClanName = TableDataManager:GetInstance():GetTableData("Clan", clanBaseData.Trunk).ClanName
            local str = string.format("我技不如人，%s从此解散。",GetLanguageByID(clanData.uiClanNameID))
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false,clanBaseData.Master, str)
            SystemUICall:GetInstance():Toast(trunkClanName.."的分舵"..GetLanguageByID(clanData.uiClanNameID).."已解散")
            KillClanBranch(clanID)
        end
    else

    end
end