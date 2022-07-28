AchieveDataManager = class("AchieveDataManager")
AchieveDataManager._instance = nil

function AchieveDataManager:GetInstance()
    if AchieveDataManager._instance == nil then
        AchieveDataManager._instance = AchieveDataManager.new()
        AchieveDataManager._instance:InitData()
    end

    return AchieveDataManager._instance
end

-- 数据初始化
function AchieveDataManager:InitData()
    self.AchieveEventData = {};

    local TypeID2Depart = {}
    local Depart2TypeID = {}
    local typeID = nil
    local eEventType = nil
    local eEventSubType = nil
    local genData = nil
    local typeIDSavePos = nil
    local TB_Achieve = TableDataManager:GetInstance():GetTable("Achieve")
    for index, data in pairs(TB_Achieve) do
        -- 根据不同的成就事件枚举, 将成就typeId的主/子事件类型提前分析出来
        typeID = data.BaseID
        genData = {}
        eEventSubType = nil
        eEventType = data.Event
        -- 为敌人附加buff 为我方附加buff 子类型为buff id
        if (eEventType == Event.Event_WeiDiRenFuJiaBuff) 
        or (eEventType == Event.Event_WeiWoFangFuJiaBuff) then
            eEventSubType = tonumber(data.EventArg1)
        -- 千层塔层数 子类型为千层塔的模式
        elseif eEventType == Event.Event_QianCengTaCengShu then
            --# TODO 钱程 千层塔模式
        -- 角色属性变化 子类型为角色属性
        elseif eEventType == Event.Event_JueSeShuXingBianHua then
            eEventSubType = tonumber(data.EventArg1) -- AttrType Enum Value
        -- 角色交互 子类型为交互类型
        elseif eEventType == Event.Event_RoleInteractive then
            --# TODO 钱程 角色交互 子事件类型
        -- 角色好感度变化 子类型为角色id
        elseif eEventType == Event.Event_JueSeHaoGanDuBianHua then
            eEventSubType = tonumber(data.EventArg1)  -- role id
        -- 打破迷宫障碍 子类型为 所使用的冒险天赋类型
        elseif eEventType == Event.Event_DaPoMiGongZhangAi then
            eEventSubType = AdventureType_Revert[data.EventArg1] or AdventureType.AT_Null
        -- 城市好感度变化, 子类型为城市id
        elseif eEventType == Event.Event_ChengShiHaoGanDuBianHua then
            eEventSubType = tonumber(data.EventArg1)  -- city id
        end
        -- 添加数据
        if eEventType then
            genData["EventType"] = eEventType
            if not Depart2TypeID[eEventType] then
                Depart2TypeID[eEventType] = {}
                typeIDSavePos = Depart2TypeID[eEventType]
                typeIDSavePos['HasEventSubType'] = false
            end
        end
        if eEventSubType then
            genData["EventSubType"] = eEventSubType
            Depart2TypeID[eEventType]['HasEventSubType'] = true
            if not Depart2TypeID[eEventType][eEventSubType] then
                Depart2TypeID[eEventType][eEventSubType] = {}
                typeIDSavePos = Depart2TypeID[eEventType][eEventSubType]
            end
        end
        TypeID2Depart[typeID] = genData
        if typeIDSavePos then
            typeIDSavePos[#typeIDSavePos + 1] = typeID
        end
    end
    self.TypeID2Depart = TypeID2Depart
    self.Depart2TypeID = Depart2TypeID
    self:InitDiffDropTBData()
end

-- 更新全部成就信息
function AchieveDataManager:UpdateAchieveDataByArray(retStream)
    if not (retStream and retStream.akSaveData and next(retStream.akSaveData)) then
        return
    end
    -- local achieveEventData = self.AchieveEventData or {}
    -- 使用 事件类型/子事件类型 将成就动态数据重新缓存
    -- local kData = nil
    -- local eEventType = nil
    -- local eEventSubType = nil
    -- for index = 0, retStream.iNum - 1 do
    --     kData = retStream.akSaveData[index]
    --     eEventType = kData.uiEventType
    --     if not achieveEventData[eEventType] then
    --         achieveEventData[eEventType] = {}
    --     end
    --     eEventSubType = kData.uiEventSubType
    --     if eEventSubType and (eEventSubType > 0) then
    --         if not achieveEventData[eEventType][eEventSubType] then
    --             achieveEventData[eEventType][eEventSubType] = {}
    --         end
    --         achieveEventData[eEventType][eEventSubType] = kData
    --     else
    --         achieveEventData[eEventType] = kData
    --     end
    --     -- 弹出成就框
    --     self:CheckAchievementTipShow(kData)
    -- end

    local bFirstPush = (retStream.iFlag == 1)

    local achieveDataList = table_c2lua(retStream.akSaveData)
    
    -- 增加achieveDataList按照order排序
    local achieveTypeDataList = {}
    for index, achieveData in ipairs(achieveDataList) do
        iCurAchieveID = achieveData.uiAchieveID
        achieveTypeData = TableDataManager:GetInstance():GetTableData("Achieve",iCurAchieveID)
        achieveTypeDataList[iCurAchieveID] = achieveTypeData
    end

    local sort_func = function(a,b)
        local iranka = 0 
        if (achieveTypeDataList[b.uiAchieveID]) then
            iranka = achieveTypeDataList[b.uiAchieveID].Order
        end
        local irankb = 0
        if (achieveTypeDataList[a.uiAchieveID]) then
            irankb = achieveTypeDataList[a.uiAchieveID].Order
        end
        return iranka > irankb
    end
    table.sort(achieveDataList,sort_func)

    local iCurAchieveID = nil
    local achieveTypeData = nil
    local oldAchieveData = nil
    for index, achieveData in ipairs(achieveDataList) do
        iCurAchieveID = achieveData.uiAchieveID
        achieveTypeData = achieveTypeDataList[iCurAchieveID]
        if (achieveTypeData) then
            -- 如果更新之前该成就进度就已经满了, 那么不再更新数据
            oldAchieveData = self.AchieveEventData[iCurAchieveID]
            -- 更新领取状态
            if oldAchieveData then
                oldAchieveData.iFetchReward = achieveData.iFetchReward
            end
            -- 更新任务进度
            if (not oldAchieveData) or (oldAchieveData.iValue ~= (achieveTypeData.ProgressMax or 0)) then
                self.AchieveEventData[iCurAchieveID] = achieveData
                -- 如果此时是第一次全量下拉数据, 那么不弹任何提示
                if bFirstPush ~= true then
                    self:CheckAchievementTipShow(achieveData)
                end
            end
        end
    end
    self:DispatchUpdateEvent()
    -- 设置全量更新标记
    self.bHasFullUpdated = true
end

-- 检查是否需要弹出成就弹框
function AchieveDataManager:CheckAchievementTipShow(kData)
    -- if (RoleDataManager:GetInstance():IsPlayerInGame() ~= true) and self.Depart2TypeID then
    --     return
    -- end

    if not kData then
        return
    end 
    -- local eEventType = kData.uiEventType
    -- local eEventSubType = kData.uiEventSubType
    -- local auiTypeIDList = nil
    -- if eEventType and (eEventType > 0) and self.Depart2TypeID[eEventType] then
    --     local subDepart = self.Depart2TypeID[eEventType]
    --     auiTypeIDList = subDepart
    --     if eEventSubType and (eEventSubType > 0) and subDepart[eEventSubType] then
    --         auiTypeIDList = subDepart[eEventSubType]
    --     end
    -- end
    -- if not (auiTypeIDList and next(auiTypeIDList)) then
    --     return
    -- end
    -- local readyList = nil
    -- for index, uiTypeID in ipairs(auiTypeIDList) do
    --     if self:CheckAchieveState(uiTypeID) == "ready" then
    --         readyList = readyList or {}
    --         readyList[#readyList + 1] = uiTypeID
    --     end
    -- end

    local readyList = nil
    local uiTypeID = kData.uiAchieveID;
    if self:CheckAchieveState(uiTypeID) == "ready" then
        readyList = readyList or {}
        readyList[#readyList + 1] = uiTypeID
    end

    if readyList and (#readyList > 0) then
        self:SetReRankFlag(true)
        OpenWindowImmediately("AchievementTipUI", readyList)

        local curAchievePoint = 0
        local subAchieveList = TableDataManager:GetInstance():GetTable("Achieve")
        for index, achieveData in pairs(subAchieveList) do
            curAchievePoint = curAchievePoint + self:GetAchievePoint(achieveData.BaseID)
        end

        -- TODO 数据上报
        MSDKHelper:SetQQAchievementData('achievementpoint', curAchievePoint);
        MSDKHelper:SendAchievementsData('achievementpoint');
        
		LuaEventDispatcher:dispatchEvent("UPDATE_ACHIEVE_BUTTON")
    end
end

-- 设置一个标记, 表示成就界面的数据需要重新排序
function AchieveDataManager:SetReRankFlag(bOn)
    self.bAchieveUIReRank = (bOn == true)
end

-- 获取重新排序标记
function AchieveDataManager:GetReRankFlag()
    return (self.bAchieveUIReRank == true)
end

-- 更新成就领取信息
function AchieveDataManager:UpdateAchieveRecordDataByArray(retStream)
    if not (retStream and retStream.akRecordData and next(retStream.akRecordData)) then
        return
    end
    local achieveRecordData = self.AchieveRecordData or {}
    -- 使用 事件类型/子事件类型 将成就动态数据重新缓存
    local uiTypeID = nil
    for index = 0, retStream.iNum - 1 do
        uiTypeID = retStream.akRecordData[index]
        achieveRecordData[uiTypeID] = true
    end
    self.AchieveRecordData = achieveRecordData
    self:DispatchUpdateEvent()
end

function AchieveDataManager:UpdateDiffDropData(retStream, bUpdatePldDataCache)
    if not (retStream and retStream.akSaveData and next(retStream.akSaveData)) then
        return
    end
    local achieveDiffDropData = self.achieveDiffDropData or {}

    local uiTypeID = nil
    local kOldData = nil
    if not self.kOldAchieveDiffDropData then
        self.kOldAchieveDiffDropData = {}
    end
    for index = 0, retStream.iNum - 1 do
        local data = retStream.akSaveData[index]
        uiTypeID = data.uiTypeID
        -- 记录一下旧的周目奖励获取状态
        if bUpdatePldDataCache then
            self.kOldAchieveDiffDropData[uiTypeID] = achieveDiffDropData[uiTypeID]
        end
        achieveDiffDropData[uiTypeID] = data
    end
    self.achieveDiffDropData = achieveDiffDropData
end


function AchieveDataManager:GetDiffDropOldDataByTypeID(uiTypeID, uiStoryID, uiDiff)
    if not (uiTypeID and uiStoryID and uiDiff and self.kOldAchieveDiffDropData) then
        return
    end
    local id = uiTypeID * 10000 + (uiStoryID or 0) * 100 + (uiDiff or 0)
    return self.kOldAchieveDiffDropData[id]
end

function AchieveDataManager:GetDiffDropDataByTypeID(uiTypeID, uiStoryID, uiDiff)
    if (not uiTypeID) then
        return nil
    end
    self.achieveDiffDropData = self.achieveDiffDropData or {}
    local id = uiTypeID * 10000 + (uiStoryID or 0) * 100 + (uiDiff or 0)

    return self.achieveDiffDropData[id]
end

function AchieveDataManager:InitDiffDropTBData()
    self.akDiffDropTBData = {}
    local storyDiffDropTable = TableDataManager:GetInstance():GetTable("StoryDiffDrop")
    for id, v in pairs(storyDiffDropTable) do
        if v.Script ~= nil and v.Diff then 
            for iDiff = 1, #v.Diff do
              local difflv = v.Diff[iDiff]
              local kDiffData = self.akDiffDropTBData[difflv]
              if kDiffData == nil then
                  kDiffData = {}
                  self.akDiffDropTBData[difflv] = kDiffData
              end
              for i = 1,#v.Script do
                local script = v.Script[i]
                local kScriptData = kDiffData[script]
                if (kScriptData == nil) then
                    kScriptData = {}
                    kDiffData[script] = kScriptData
                end
                kScriptData[v.BaseID] = v
              end
            end
        else
            derror('请联系相关策划检查数据配置, StoryDiffDrop 缺少 Script 字段配置. ID:' .. tostring(id))
        end
    end
end

function AchieveDataManager:GetDiffDropTBData(diff, scriptid)
    local retTable = {}
    if diff == 0 then
        for k, v in pairs(self.akDiffDropTBData) do
            if v[scriptid] then
                local data  = v[scriptid]
                for key,value in pairs(data) do
                    retTable[key] = value 
                end
            end
        end
    else
        local data = self.akDiffDropTBData[diff]
        if data ~= nil and data[scriptid] then
            retTable = data[scriptid]
        end
    end
    return retTable
end

function AchieveDataManager:_GetDiffDropDataScriptIsOK(tb_diffData,scriptid)
    if (tb_diffData.Script == nil) then
        return true
    end
    local scriptIsOK = false
    for i = 1,#tb_diffData.Script do
        local script = tb_diffData.Script[i]
        if (script == scriptid) then
            return true
        end
    end

    return false
end

function AchieveDataManager:GetDiffDropTBDataByDropID(tableData,dropid)
    local tableRet = {}
    if (tableData == nil) then
        tableData = TableDataManager:GetInstance():GetTable("StoryDiffDrop")
    end

    local dropdata = TableDataManager:GetInstance():GetTableData("Drop",dropid)

    if (dropdata == nil) then
        return tableRet
    end

    for k,v in pairs(tableData) do
        if (v.Event == StoryDiffItemEvent.SDIE_DROP and v.Param1 == dropdata.DropID) then
            tableRet[k] = v
        end
    end

    return tableRet
end

function AchieveDataManager:GetLuckyLevel(lucky)
    local commonConfigTable = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    if (commonConfigTable == nil) then
        return nil
    end
    local level = 0
    lucky = lucky or 0
    if (lucky >= commonConfigTable.LowLuckyValueMin and lucky <= commonConfigTable.LowLuckyValueMax) then
        level = 0
    elseif (lucky >= commonConfigTable.MidLuckyValueMin and lucky <= commonConfigTable.MidLuckyValueMax) then
        level = 1
    elseif (lucky >= commonConfigTable.HighLuckyValueMin and lucky <= commonConfigTable.HighLuckyValueMax) then
        level = 2
    end

    return level
end

function AchieveDataManager:GetDiffDropRewordByLucky(tableData, lucky)
    if (not (tableData and lucky)) then
        return nil
    end

    local level = self:GetLuckyLevel(lucky)

    if (level == 0) then
        return {["BaseID"] = tableData.BaseID, ["Type"] = tableData.LowType, ["Value"] = tableData.LowLuckItem}
    elseif (level == 1) then
        return {["BaseID"] = tableData.BaseID, ["Type"] = tableData.MidType, ["Value"] = tableData.MidLuckItem}
    elseif (level == 2) then
        return {["BaseID"] = tableData.BaseID, ["Type"] = tableData.HighType, ["Value"] = tableData.HighLuckItem}
    end
    return nil
end

-- 成就奖励是否已领取
function AchieveDataManager:IsAchieveRewardGot(uiTypeID)
    if not uiTypeID then
        return false
    end
    -- local achieveRecordData = self.AchieveRecordData or {}
    -- return (achieveRecordData[uiTypeID] == true)

    if self.AchieveEventData[uiTypeID] then
        return self.AchieveEventData[uiTypeID].iFetchReward > 0;
    else
        return false;
    end    
end

-- 获取成就最大值
function AchieveDataManager:GetAchieveProgressMax(uiTypeID)
    local data = TableDataManager:GetInstance():GetTableData("Achieve",uiTypeID)
    if not data then
        return 0
    end
    return data.ProgressMax or 1
end

-- 获取成就当前值
function AchieveDataManager:GetAchieveProgressCur(uiTypeID)
    -- if not (self.TypeID2Depart and self.TypeID2Depart[uiTypeID]) then
    --     return 0
    -- end
    -- local departData = self.TypeID2Depart[uiTypeID]
    -- local eEventType = departData.EventType
    -- local eEventSubType = departData.EventSubType
    -- local achieveEventData = self.AchieveEventData or {}
    -- local readDataPos = nil
    -- if eEventType then
    --     if eEventSubType then
    --         readDataPos = achieveEventData[eEventType] or {}
    --         readDataPos = readDataPos[eEventSubType]
    --     else
    --         readDataPos = achieveEventData[eEventType]
    --     end
    -- end
    -- if not readDataPos then
    --     return 0
    -- end
    -- -- 与服务器约定, 如果进度最大值存在负数的成就, 值还是存在同一个事件数据里,
    -- -- 其中, uiValue(int32)存负值, auiRecords[0](uint32)存正值
    -- -- 目前的成就中, 进度最大值存在负值的事件有 所有城市好感度变化 城市好感度变化 仁义值变化
    -- -- 其它的成就, 则按 一次性达成记录的记在 auiRecords, 持续记录数值的存在 uiValue 中处理
    -- if (eEventType == Event.Event_SuoYouChengShiHaoGanDuBianHua)
    -- or (eEventType == Event.Event_ChengShiHaoGanDuBianHua)
    -- or (eEventType == Event.Event_RenYiZhiBianHua) then
    --     local achieveTypeData = TB_Achieve[uiTypeID]
    --     if achieveTypeData.ProgressMax >= 0 then
    --         return (readDataPos.auiRecords and readDataPos.auiRecords[0]) and readDataPos.auiRecords[0] or 0
    --     else
    --         return readDataPos.uiValue or 0
    --     end
    -- else
    --     -- 如果存在记录列表, 分不同枚举比对记录列表
    --     if readDataPos.auiRecords and next(readDataPos.auiRecords) then
    --         local selfID = 0
    --         -- 分枚举取值
    --         -- 自定义事件直接在列表中记录成就id
    --         if (eEventType == Event.Event_Customize) then
    --             selfID = uiTypeID
    --         -- 掌门驱逐 门派征服 门派联盟 记录门派id
    --         elseif (eEventType == Event.Event_ZhangMenQuZhu)
    --         or (eEventType == Event.Event_MenPaiLianMeng)
    --         or (eEventType == Event.Event_MenPaiZhengFu) then
    --             selfID = tonumber(data.EventArg1)
    --         -- 剧本完成 记录剧本id
    --         elseif eEventType == Event.Event_JuBenWanCheng then
    --             selfID = tonumber[data.EventArg1]
    --         -- 角色所有心愿完成 记录角色id
    --         elseif eEventType == Event.Event_JueSeSuoYouXinYuanWanCheng then
    --             selfID = tonumber[data.EventArg1]
    --         end
    --         -- 对比
    --         for index = 0, #readDataPos.auiRecords do
    --             if selfID == readDataPos.auiRecords[index] then
    --                 return 1
    --             end
    --         end
    --     end
    --     -- 如果存在进度值的 返回进度值
    --     if readDataPos.uiValue then
    --         return readDataPos.uiValue
    --     end
    -- end
    -- return 0

    if self.AchieveEventData[uiTypeID] then
        return self.AchieveEventData[uiTypeID].iValue;
    else
        return 0;
    end
end

-- 查询成就状态
function AchieveDataManager:CheckAchieveState(uiTypeID)
    if self:IsAchieveRewardGot(uiTypeID) then
        return "achieved"
    end
    local state = "running"  -- 进行中
    local iMax = self:GetAchieveProgressMax(uiTypeID)
    if iMax == 0 then
        dprint("@未未, 成就[BaseID = " .. uiTypeID .. "]数据错误, 进度最大值无效")
        return state
    end
    local iCur = self:GetAchieveProgressCur(uiTypeID)
    -- 如果最大值是正值, 那么判断当前值是否大于正值
    -- 如果最大值是负值, 那么判断当前值是否小于负值
    if (iMax >= 0) and (iCur >= iMax) 
    or (iMax < 0) and (iCur <= iMax) then
        state = "ready"  -- 可领取
    end
    return state
end

-- 成就是否已经达成
function AchieveDataManager:IsAchieveMade(uiTypeID)
    local state = self:CheckAchieveState(uiTypeID)

    return (state == "ready" or state == "achieved")
end


-- 查询是否有可领取的成就
function AchieveDataManager:CheckIfHasReadyAchieve()
    local TB_Achieve = TableDataManager:GetInstance():GetTable("Achieve")
    for index, data in pairs(TB_Achieve) do
        if self:CheckAchieveState(data.BaseID) == "ready" then
            return true
        end
    end
    return false
end

-- 获取成就奖励数组
function AchieveDataManager:GetAchieveRewardArray(uiTypeID)
    local achieveTypeData = TableDataManager:GetInstance():GetTableData("Achieve",uiTypeID)
    if not achieveTypeData then return end
    local ret = {}
    local iIndex = 1
    local itemTypeID = achieveTypeData['AchieveReward' .. iIndex]
    while itemTypeID and (itemTypeID > 0) do
        ret[#ret + 1] = {
            ["uiTypeID"] = itemTypeID,
            ["uiNum"] = achieveTypeData['RewardNum' .. iIndex] or 0,
        }
        iIndex = iIndex + 1
        itemTypeID = achieveTypeData['AchieveReward' .. iIndex]
    end
    return ret
end

function AchieveDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_ACHIEVE_DATA")
end

function AchieveDataManager:GetAchievePoint(uiTypeID)
    if not uiTypeID then
        return 0
    end
    local typeData = TableDataManager:GetInstance():GetTableData("Achieve",uiTypeID)
    local iPoint = 0
    local state = self:CheckAchieveState(uiTypeID)
    if (state == "ready") or (state == "achieved") then
        iPoint = typeData.AchievePoint or 0
    end
    return iPoint
end

function AchieveDataManager:GetAllAchievePoint()
    local iPoint = 0
    local typeID = nil
    local state = nil
    local TB_Achieve = TableDataManager:GetInstance():GetTable("Achieve")
    for index, data in pairs(TB_Achieve) do
        typeID = data.BaseID
        iPoint = iPoint + self:GetAchievePoint(typeID)
    end
    return iPoint
end

-- 记录已经领取过的成就奖励
function AchieveDataManager:RecordChosenAchieveRewards(cArrayList, iLen)
    if not (cArrayList and next(cArrayList) and iLen) then
        return
    end
    self.kChosenAchieveRewards = {}
    for index = 0, iLen - 1 do
        self.kChosenAchieveRewards[cArrayList[index]] = true
    end
end

-- 查询一个成就奖励是否已经被领取过
function AchieveDataManager:IfAchieveRewardBeenChosen(iAchieveRewardID)
    if not (iAchieveRewardID and self.kChosenAchieveRewards) then
        return false
    end
    return (self.kChosenAchieveRewards[iAchieveRewardID] == true)
end

function AchieveDataManager:Clear()
    self.AchieveEventData = {}
end