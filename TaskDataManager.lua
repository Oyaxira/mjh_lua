TaskDataManager = class("TaskDataManager")
TaskDataManager._instance = nil

function TaskDataManager:GetInstance()
    if TaskDataManager._instance == nil then
        TaskDataManager._instance = TaskDataManager.new()
        TaskDataManager:InitTaskEdge()
        TaskDataManager:InitDynamicTaskDataKeyMapping()
        TaskDataManager._instance:InitListeners()
    end

    return TaskDataManager._instance
end

function TaskDataManager:ResetManager()
    self.eventIsDirty = nil
    self.runningTasks = nil
    self.taskBeginToastLog = nil
    self.curTaskID = nil
    self.choiceInfo = nil
end

-- 注册监听
function TaskDataManager:InitListeners()
    self.eventIsDirty = {}
    local func = function(strEvent)
        -- 给事件设置脏标
        self.eventIsDirty[strEvent] = true
        self.eventIsDirty["hasDirtyEvent"] = true
    end
    -- 物品进度 物品类型
    LuaEventDispatcher:addEventListener("UPDATE_ITEM_DATA", function()
        func("UPDATE_ITEM_DATA")
    end)
    -- 主角属性进度
    LuaEventDispatcher:addEventListener("UPDATE_DISPLAY_ROLEATTRS", function(uiRoleID)
        if uiRoleID == RoleDataManager:GetInstance():GetMainRoleID() then
            func("UPDATE_DISPLAY_ROLEATTRS")
        end
    end)
    -- 公共属性进度 好友入队也会走到这里
    LuaEventDispatcher:addEventListener("UPDATE_MAIN_ROLE_INFO", function()
        func("UPDATE_MAIN_ROLE_INFO")
    end)
    -- 好感度进度
    LuaEventDispatcher:addEventListener("UPDATE_DISPOSITION", function()
        func("UPDATE_DISPOSITION")
    end)
    -- 武学等级提升
    LuaEventDispatcher:addEventListener("UPDATE_MARTIAL_DATA", function()
        func("UPDATE_MARTIAL_DATA")
    end)
    -- 门派好感度提升
    LuaEventDispatcher:addEventListener("UPDATE_CLAN_DATA", function()
        func("UPDATE_CLAN_DATA")
    end)
    -- 新的冒险天赋
    LuaEventDispatcher:addEventListener("UPDATE_GIFT", function()
        func("UPDATE_GIFT")
    end)
    -- 计时器进度
    LuaEventDispatcher:addEventListener("UPDATE_RIVAKE_TIME", function()
        func("UPDATE_RIVAKE_TIME")
    end)
    -- 标记
    LuaEventDispatcher:addEventListener("UPDATE_TASKTAG_DATA", function()
        func("UPDATE_TASKTAG_DATA")
    end)
    -- 开启检查脏标记的计时器
    if self.uiCheckTimer then
        globalTimer:RemoveTimer(self.uiCheckTimer)
    end
    self.uiCheckTimer = globalTimer:AddTimer(1000, function()
		TaskDataManager:GetInstance():CheckEventDirtyAndUpdateProgressData()
	end, -1)
end

-- 事件对应到任务进度类型
local event2ProgressType = {
    ["UPDATE_ITEM_DATA"] = {
        -- 物品进度
        TaskDescProgressType.TDPT_wupin,
        -- 物品类型
        TaskDescProgressType.TDPT_wupinleixing,
    },
    ["UPDATE_DISPLAY_ROLEATTRS"] = {
        -- 主角属性进度
        TaskDescProgressType.TDPT_zhujueshuxing,
    },
    ["UPDATE_MAIN_ROLE_INFO"] = {
        -- 公共属性进度
        TaskDescProgressType.TDPT_youxishuxing,
        -- 队友数量进度
        TaskDescProgressType.TDPT_teammatenum,
        -- 冒险天赋等级进度
        TaskDescProgressType.TDPT_maoxiantianfudengji,
    },
    ["UPDATE_DISPOSITION"] = {
        -- 好感度进度
        TaskDescProgressType.TDPT_haogandu,
    },
    ["UPDATE_MARTIAL_DATA"] = {
        -- 武学等级进度
        TaskDescProgressType.TDPT_wuxuedengji,
    },
    ["UPDATE_CLAN_DATA"] = {
        -- 门派好感进度
        TaskDescProgressType.TDPT_menpaihaogan,
    },
    ["UPDATE_GIFT"] = {
        -- 冒险天赋等级进度
        TaskDescProgressType.TDPT_maoxiantianfudengji,
    },
    ["UPDATE_RIVAKE_TIME"] = {
        -- 计时器进度数据走另外的消息
        TaskDescProgressType.TDPT_jishiqi,
        TaskDescProgressType.TDPT_MonLeftDayCount,
    },
    ["UPDATE_TASKTAG_DATA"] = {
        -- 标记值
        TaskDescProgressType.TDPT_biaoji,
    },
}

-- 检查事件脏标记, 并刷新对应任务的进度数据
function TaskDataManager:CheckEventDirtyAndUpdateProgressData()
    if not (self.eventIsDirty and self.runningTasks)
    or (self.eventIsDirty["hasDirtyEvent"] ~= true) then
        return
    end
    local processEvent = function(strEvent)
        if not (strEvent and event2ProgressType[strEvent]) then
            return
        end
        for index, eProgressType in pairs(event2ProgressType[strEvent]) do
            local akInstTasks = self.runningTasks[eProgressType]
            if akInstTasks and (#akInstTasks > 0) then
                self:UpdateRunningTasksProgress(akInstTasks)
            end
        end
    end
    for strEvent, bIsDirty in pairs(self.eventIsDirty) do
        if bIsDirty == true then
            processEvent(strEvent)
            self.eventIsDirty[strEvent] = false
        end
    end
    self.eventIsDirty["hasDirtyEvent"] = false
end

-- 缓存初始化，建立任务阶段 - 节点反查表
function TaskDataManager:InitTaskEdge()
    local edgePool = {}
    local taskEdgeTable = TableDataManager:GetInstance():GetTable("TaskEdge")
    for taskEdgeID, taskEdgeData in pairs(taskEdgeTable) do
        if dnull(taskEdgeData.StateID) then 
            local StateID = taskEdgeData.StateID
            if not edgePool[StateID] then
                edgePool[StateID] = {}
            end
            table.insert(edgePool[StateID], taskEdgeData)
        end
    end
    globalDataPool:setData("TaskEdge", edgePool, true)
end

-- 根据 状态ID 获取 TaskEdge 数据列表 根据阶段ID，获取对应的节点数组（已经建立了反查表）
function TaskDataManager:GetTaskEdgeListByStateID(StateID)
    if not StateID then 
        return 
    end
    local edgePool = globalDataPool:getData("TaskEdge") or {}
    return edgePool[StateID]
end

-- 根据出边 ID 获取 TaskEdge 数据
function TaskDataManager:GetTaskEdgeByID(taskEdgeTypeID)
    if not taskEdgeTypeID then 
        return 
    end
    return GetTableData("TaskEdge", taskEdgeTypeID)
end

-- 查询任务的动态信息
function TaskDataManager:GetTaskData(taskID)
    local taskPool = globalDataPool:getData("TaskPool") or {}
    return taskPool[taskID]
end

-- 设置单个任务的动态数据
function TaskDataManager:SetTaskDynData(taskID, kTaskData)
    local taskPool = globalDataPool:getData("TaskPool") or {}
    taskPool[taskID] = kTaskData
    globalDataPool:setData("TaskPool", taskPool, true)
end


-- 查询任务 在 TB_Task 表中的静态信息
function TaskDataManager:GetTaskTypeDataByID(taskID)
    local taskPool = globalDataPool:getData("TaskPool") or {}
    local taskData = taskPool[taskID]
    if taskData then 
        local typeID = taskData.uiTypeID
        return TableDataManager:GetInstance():GetTableData("Task", typeID)
    end
    return nil
end

-- 查询任务 在 TB_Task 表中的静态信息
function TaskDataManager:GetTaskTypeDataByTypeID(taskID)
    return TableDataManager:GetInstance():GetTableData("Task", taskID)
end
-- 获取任务的结局描述(descID + descState 数组)
-- bIsSuc 任务是否成功
function TaskDataManager:GetEndingDescState(taskID, bIsSuc)
    local taskData = self:GetTaskData(taskID)
    if not taskData then return end
    -- 任务状态为 已完成 或 已失败 并且描述列表中有 类型为结局的描述
    local taskProgressType = taskData['uiTaskProgressType']
    local bTaskSuc = (bIsSuc == true) or (taskProgressType == TPT_SUCCEED)
    local bTaskFail = (bIsSuc == false) or (taskProgressType == TPT_FAILED)
    local taskStateCheck = bTaskSuc or bTaskFail
    if not taskStateCheck then return end
    -- 尝试从动态数据中获取结局描述
    local descStates = taskData['auiDescStates']
    local descSize = taskData['iDescStateSize']
    local descTypeData = nil
    for i = descSize - 1, 0, -1 do
        descTypeData = TableDataManager:GetInstance():GetTableData("TaskDescription",descStates[i].uiDescID)
        if (descTypeData ~= nil) and (descTypeData.Type == TaskDescType.TDT_jieju) then
            return descStates[i]
        end
    end
    return nil
end

-- 获取描述对应的类型 TDT
function TaskDataManager:GetTypeByDescID(descID)
    local taskDescData = TableDataManager:GetInstance():GetTableData("TaskDescription",descID)
    if not taskDescData then return end
    return taskDescData.Type
end

-- 根据描述ID和状态，返回描述string
function TaskDataManager:GetDescByState(taskID, descID, descState)
    local taskDescData = TableDataManager:GetInstance():GetTableData("TaskDescription",descID)
    if not taskDescData then return end

    -- 根据 描述的任务进度 TPT，获取 desc 里的对应 描述，未做任何处理
    local string_desc = nil
    if descState == TaskDescStatesType.TDST_yishibai and dnull(taskDescData.FailDescTextID) then
        string_desc = GetLanguageByID(taskDescData.FailDescTextID, taskID)
    elseif descState == TaskDescStatesType.TDST_yiwancheng and dnull(taskDescData.CompleteDescTextID) then
        string_desc = GetLanguageByID(taskDescData.CompleteDescTextID, taskID)
    end
    if (not string_desc) or (string_desc == "") then
        string_desc = GetLanguageByID(taskDescData.DescTextID or 0, taskID)
    end

    -- 处理进度描述
    while string.match(string_desc, '@prc%d+@') do
        -- 分析进度标签位置
        sProcessTag = string.match(string_desc, '@prc%d+@')
        local iProcessTagLen = string.len(sProcessTag)
        iProcessTagPos1 = string.find(string_desc, sProcessTag)
        iProcessTagPos2 = iProcessTagLen + iProcessTagPos1 - 1
        sDescPart1 = string.sub(string_desc, 1, iProcessTagPos1 - 1)
        local iDescLen = string.len(string_desc)
        if iProcessTagPos2 == iDescLen then
            sDescPart2 = ""
        else
            sDescPart2 = string.sub(string_desc, iProcessTagPos2 + 1, iDescLen)
        end
        iProcessIndex = tonumber(string.sub(sProcessTag, 5, iProcessTagLen - 1))
        -- 获取进度数据
        local processData = self:GetTaskProcessData(taskID, descID, iProcessIndex) or {}
        -- 已完成的描述直接显示最大值
        if descState == TaskDescStatesType.TDST_yiwancheng then
            processData.iCurValue = processData.iMaxValue
        end
        local strProcessDesc = string.format("(%d/%d)", processData.iCurValue or 0, processData.iMaxValue or 0)
        -- 获取进度对象名称
        local descProcessType = taskDescData['Progress' .. iProcessIndex]
        local sProcessItemName = ""
        local arg1 = taskDescData['Progress' .. iProcessIndex .. "_arg1"]
        -- 物品进度
        if descProcessType == TaskDescProgressType.TDPT_wupin then
            local itemTypeID = DecodeNumber(arg1, taskID)
            if itemTypeID and (itemTypeID > 0) then
                local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
                if itemTypeData then
                    sProcessItemName = itemTypeData.ItemName or ''
                end
            end
        -- 主角属性进度
        elseif descProcessType == TaskDescProgressType.TDPT_zhujueshuxing then
            sProcessItemName = arg1 or ""
        -- 公共属性进度
        elseif descProcessType == TaskDescProgressType.TDPT_youxishuxing then
            sProcessItemName = arg1 or ""
        -- 杀敌进度
        elseif descProcessType == TaskDescProgressType.TDPT_shadi then
            local roleTypeID = DecodeNumber(arg1, taskID)
            if roleTypeID then
                local roleTypeData = TB_Role[roleTypeID]
                sProcessItemName = GetLanguageByID(roleTypeData.NameID, taskID)
            end
        -- 武学等级进度
        elseif descProcessType == TaskDescProgressType.TDPT_wuxuedengji then
            local martialTypeID = DecodeNumber(arg1, taskID)
            if martialTypeID then
                local martialTypeData = GetTableData("Martial", martialTypeID)
                if martialTypeData then
                    sProcessItemName = string.format("《%s》", GetLanguageByID(martialTypeData.NameID, taskID))
                end
            end
        -- 门派好感进度
        elseif descProcessType == TaskDescProgressType.TDPT_menpaihaogan then
            local clanTypeID = DecodeNumber(arg1, taskID)
            if clanTypeID then
                local clanTypeData = TB_Clan[clanTypeID]
                sProcessItemName = GetLanguageByID(clanTypeData.NameID, taskID)
            end
        -- 冒险天赋等级进度
        elseif descProcessType == TaskDescProgressType.TDPT_maoxiantianfudengji then
            local eGiftType = DecodeNumber(arg1, taskID)
            if eGiftType then
                sProcessItemName = GetEnumText("AdventureType", eGiftType)
            end
        elseif descProcessType == TaskDescProgressType.TDPT_jishiqi then
            local iDeltaTime = (processData.iMaxValue or 0) - (processData.iCurValue or 0)
            iDeltaTime = math.max(iDeltaTime, 0)
            
            if iDeltaTime == 0 then
                strProcessDesc = "0日"
            else
                local y, m, d, h = EvolutionDataManager:GetInstance():GetRivakeTimeYMD(iDeltaTime, true)
                local strY = (y > 0) and string.format("%d年", y) or ""
                local strM = (m > 0) and string.format("%d月", m) or ""
                local strD = (d > 0) and string.format("%d日", d) or ""
                -- local strH = (h > 0) and string.format("%d时", h) or ""
                -- strProcessDesc = strY .. strM .. strD .. strH
                strProcessDesc = strY .. strM .. strD
            end
        -- 队友数量
        elseif descProcessType == TaskDescProgressType.TDPT_teammatenum then
            sProcessItemName = "队友数量"
        -- 本月剩余天数
        elseif descProcessType == TaskDescProgressType.TDPT_MonLeftDayCount then
            strProcessDesc = tostring(processData.iCurValue or 0)
        end
        string_desc = string.format("%s%s%s%s", sDescPart1, sProcessItemName, strProcessDesc, sDescPart2)
    end

    return string_desc
end

-- 任务是否有效并且正在进行中
function TaskDataManager:IsTaskActiveAndRunning(taskData)
    local taskTypeData = TableDataManager:GetInstance():GetTableData("Task", taskData.uiTypeID)
    if not taskTypeData then 
        return false 
    end
    local taskType = taskTypeData.Type
    -- 无效任务或者没有任务类型的任务, 去除
    if (taskType == TaskType.TT_wuxiao) or (taskType == TaskType.TaskType_NULL) then 
        return false
    end
    -- 不是进行中的任务, 去除
    if taskData['uiTaskProgressType'] ~= TPT_INIT then
        return false
    end 
    -- 正在进行中的任务，需要至少有一条任务描述被开启
    local auiDescStates = taskData.auiDescStates
    if not(auiDescStates and auiDescStates[0]) then
        return false
    end
    return true
end

-- 添加一个任务到 进行中 任务列表
function TaskDataManager:AddTaskToRunningList(taskData)
    if not (taskData and taskData.auiEdgeIdList and taskData.auiEdgeIdList[0]) then
        return
    end
    if not self:IsTaskActiveAndRunning(taskData) then
        return
    end
    -- 储存位置
    self.runningTasks = self.runningTasks or {}
    local checkMap = self.runningTasks['checkMap'] or {}  -- 标记一个任务是否存在于某个任务类型的分类里
    -- 追加任务动态数据到缓存
    local appendTaskWithType = function(kTaskData, eDescProgressType)
        if (not kTaskData) or (not eDescProgressType) 
        or (eDescProgressType == TaskDescProgressType.TaskDescProgressType_NULL) then
            return
        end
        if not self.runningTasks[eDescProgressType] then
            self.runningTasks[eDescProgressType] = {}
        end
        if not checkMap[eDescProgressType] then
            checkMap[eDescProgressType] = {}
        end
        local taskID = taskData.uiID
        -- 如果已存在, 更新旧值
        if checkMap[eDescProgressType][taskID] == true then
            for index, oldTaskData in ipairs(self.runningTasks[eDescProgressType]) do
                if oldTaskData.uiID == taskID then
                    self.runningTasks[eDescProgressType][index] = taskData
                    break
                end
            end
            return
        end
        -- 追加
        checkMap[eDescProgressType][taskID] = true
        self.runningTasks[eDescProgressType][#self.runningTasks[eDescProgressType] + 1] = kTaskData
    end
    -- 任务数据按照任务进度类型进行分类
    -- 由于更新任务信息(如阶段跳转的时候)都会AddTaskToRunningList并替换掉旧的数据
    -- 所以这里不需要取到任务静态数据所有的边上的描述, 只需要遍历动态数据中已经走过的边即可
    local kDescInfo, kDescData = nil, nil
    local eDescState = nil
    local auiDescStates = taskData.auiDescStates or {}  -- 通过了IsTaskActiveAndRunning测试的, auiDescStates至少是有一条数据的
    for index = 0, #auiDescStates do
        kDescInfo = auiDescStates[index]
        kDescData = TableDataManager:GetInstance():GetTableData("TaskDescription", kDescInfo.uiDescID or 0)
        if kDescData then
            eDescState = kDescInfo.uiDescState
            if (eDescState == TaskDescStatesType.TDST_jinxingzhong) then
                -- 更新/添加 进行中的标书数据
                -- 固定的三个进度结构, 这里就不用字符串拼接遍历了
                appendTaskWithType(taskData, kDescData.Progress1)
                appendTaskWithType(taskData, kDescData.Progress2)
                appendTaskWithType(taskData, kDescData.Progress3)
            end
        else
            derror("@策划: 描述id [" .. tostring(kDescInfo.uiDescID) .. "] 没有对应的描述数据, 但是任务中开启了这个描述!")
        end
    end
    -- 重新赋值checkMap
    self.runningTasks['checkMap'] = checkMap
end

-- 将一个任务从 任务列表 移除
function TaskDataManager:RemoveTaskFromRunningList(taskData)
    if not taskData then
        return
    end
    local taskID = taskData.uiID
    self.runningTasks = self.runningTasks or {}
    local checkMap = self.runningTasks['checkMap'] or {}
    local taskGroup = nil
    for eDescType, taskIDChecker in pairs(checkMap) do
        if taskIDChecker[taskID] == true then
            taskGroup = self.runningTasks[eDescType] or {}
            for index = #taskGroup, 1, -1 do
                if taskGroup[index].uiID == taskID then
                    table.remove(taskGroup, index)
                    break
                end
            end
            self.runningTasks[eDescType] = taskGroup
            taskIDChecker[taskID] = nil
        end
    end
    self.runningTasks['checkMap'] = checkMap
end

-- 服务器下行：添加一条任务信息
function TaskDataManager:AddTaskData(taskData)
    -- uiID，
    -- uiTypeID，（Task表里的ID）
    -- uiTaskProgressType		任务进度TPT（开始 完成 失败）
    -- uiTaskState		状态（任务对应的进度，其实是TaskEdge 里的 StateID，有反查表）
    -- auiDescStates    描述数组
        -- result["auiDescStates"][i]["uiDescID"]
        -- result["auiDescStates"][i]["uiDescState"]
    -- iDescStateSize   描述数组的长度


    if not taskData then return end
    local taskPool = globalDataPool:getData("TaskPool") or {}

    local uiID = taskData.uiID
    taskPool[uiID] = taskData

    globalDataPool:setData("TaskPool", taskPool, true)

    -- 更新任务进度缓存
    self:UpdateTaskProgressData(taskData)

    -- 维护进行中任务列表
    self:AddTaskToRunningList(taskData)

    -- 执行遍历 前端操作
    self:Traverse(taskData)
    self:DispatchUpdateEvent()
end

function TaskDataManager:IsBattleTask(uiID)
    local taskData = self:GetTaskTypeDataByID(uiID)
    if not taskData then return false end
    if taskData.SpecialFlag then 
        for k,v in ipairs(taskData.SpecialFlag) do
            if v == TaskFlag.TF_BattleTask then
                return true
            end
        end
    end
    return false
end

-- 服务器下行：更新一条任务信息
function TaskDataManager:UpdateTaskData(taskData)
    if not taskData then 
        return 
    end
    local isBattleTask = self:IsBattleTask(taskData.uiID)
    local taskPool = globalDataPool:getData("TaskPool") or {}
    local uiID = taskData.uiID
    local oldTaskData = taskPool[uiID]

    -- 先清理之前的任务标记
    if not isBattleTask then 
        self:ClearMark(oldTaskData)
    end
    
    -- 更新任务信息
    if taskPool[uiID] == nil then 
        taskPool[uiID] = taskData
    else
        for k, v in pairs(taskData) do 
            taskPool[uiID][k] = v
        end
    end
    globalDataPool:setData("TaskPool", taskPool, true)

    if not isBattleTask then 
        -- 更新任务进度缓存
        self:UpdateTaskProgressData(taskData) 

        -- 维护进行中任务列表
        self:AddTaskToRunningList(taskData)

        -- 执行遍历 前端操作
        self:Traverse(taskData)

        -- 更新 任务广播
        self:UpdateBroadcast(oldTaskData, taskData)

        self:DispatchUpdateEvent()
    end
end

-- 更新任务进度数据缓存
function TaskDataManager:UpdateTaskProgressData(taskData)
    if not taskData then return end
    local taskID = taskData.uiID
    local auiDescStates = taskData.auiDescStates
    if not(auiDescStates and auiDescStates[0]) then return end
    -- 该任务进度数值是否发生了变化?
    local bCurValueChanged = false
    -- 所有进度数值的缓存
    local cacheData = globalDataPool:getData("TaskProcessData") or {}
    local taskCache = cacheData[taskID] or {}
    -- 分析人物进度之前先遍历角色背包, 生成物品数量的查询表
    local itemTypeID2Num = {}  -- 物品静态id -> 数量
    local itemType2Num = {}  -- 物品类型 -> 数量
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if not mainRoleData then
        return
    end
    local auiItemIDList = mainRoleData.auiRoleItem or {}
    local itemTypeID = nil
    local itemTypeData = nil
    local itemType = nil
    local itemNum = nil
    local itemMgr = ItemDataManager:GetInstance()
    for index, id in pairs(auiItemIDList) do
        itemTypeData = itemMgr:GetItemTypeData(id)
        if itemTypeData then
            itemTypeID = (itemTypeData.OrigItemID and itemTypeData.OrigItemID > 0) and itemTypeData.OrigItemID or itemTypeData.BaseID
            itemType = itemTypeData.ItemType
            itemNum = itemMgr:GetItemNum(id)
            itemTypeID2Num[itemTypeID] = (itemTypeID2Num[itemTypeID] or 0) + itemNum
            itemType2Num[itemType] = (itemType2Num[itemType] or 0) + itemNum
        end
    end
    -- 根据进度类型分析进度数值
    local genProcessByType = function(index, progressType, descTypeID, curValueData)
        local progressTypeData = TableDataManager:GetInstance():GetTableData("TaskDescription",descTypeID)
        local arg1 = progressTypeData["Progress" .. index .. "_arg1"]
        local arg2 = progressTypeData["Progress" .. index .. "_arg2"]
        local arg3 = progressTypeData["Progress" .. index .. "_arg3"]
        -- 初始化
        local iCurValue = 0
        local oldValue = taskCache[descTypeID][index] or 0
        -- 物品进度
        if progressType == TaskDescProgressType.TDPT_wupin then
            local itemTypeID = DecodeNumber(arg1, taskID)
            itemTypeData = itemMgr:GetItemTypeData(itemTypeID)
            if itemTypeData then
                itemTypeID = (itemTypeData.OrigItemID and itemTypeData.OrigItemID > 0) and itemTypeData.OrigItemID or itemTypeData.BaseID
            end
            iCurValue = itemTypeID2Num[itemTypeID] or 0
        -- 物品类型
        elseif progressType == TaskDescProgressType.TDPT_wupinleixing then
            --# TODO 钱程 暂无数据
        -- 主角属性进度
        elseif progressType == TaskDescProgressType.TDPT_zhujueshuxing then
            local eTargetAttr = AttrType_Revert[arg1]
            iCurValue = mainRoleData["aiAttrs"][eTargetAttr] or 0
        -- 公共属性进度
        elseif progressType == TaskDescProgressType.TDPT_youxishuxing then
            -- FIXME 钱程 目前公共属性进度只有 铜币 一种, 如果有其他的类型, 也许要更换枚举类型
            local eTargetAttr = GameData_Revert[arg1]
            if eTargetAttr == GameData.GD_Copper then
                iCurValue = PlayerSetDataManager:GetInstance():GetPlayerCoin()
            end
        -- 好感度进度
        elseif progressType == TaskDescProgressType.TDPT_haogandu then
            local roleTypeID = DecodeNumber(arg1, taskID)
            local roleID = RoleDataManager:GetInstance():GetRoleID(roleTypeID)
            if roleID then
                local data = RoleDataManager:GetInstance():GetDispotionDataToMainRole(roleID, roleTypeID)
                if data then
                    iCurValue = data.iValue or 0
                end
            end
        -- 武学等级进度
        elseif progressType == TaskDescProgressType.TDPT_wuxuedengji then
            local targetMartialTypeID = DecodeNumber(arg1, taskID)
            local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
            if mainRoleData['RoleInfos'] and mainRoleData['RoleInfos']['Martials'] then
                for martialTypeID, martialData in pairs(mainRoleData['RoleInfos']['Martials']) do
                    if martialTypeID == targetMartialTypeID then
                        iCurValue = martialData.uiLevel
                        break
                    end
                end
            end
        -- 门派好感进度
        elseif progressType == TaskDescProgressType.TDPT_menpaihaogan then
            local clanTypeID = DecodeNumber(arg1, taskID)
            iCurValue = ClanDataManager:GetInstance():GetDisposition(clanTypeID)
        -- 冒险天赋等级进度
        elseif progressType == TaskDescProgressType.TDPT_maoxiantianfudengji then
            local eGiftType = DecodeNumber(arg1, taskID)
            local info = globalDataPool:getData("MainRoleInfo")
            if info and info["Teammates"] and next(info["Teammates"]) then
                local giftMgr = GiftDataManager:GetInstance()
                for i = 0, #info["Teammates"] do
                    local iRoleID = info["Teammates"][i]
                    local akGiftTypeDatas = giftMgr:GetRoleAdvGift(iRoleID)
                    for index, giftTypeData in ipairs(akGiftTypeDatas) do
                        if (giftTypeData.AdventureType == eGiftType) and giftTypeData.AdventureLevel then
                            iCurValue = iCurValue + giftTypeData.AdventureLevel
                        end
                    end
                end
            end
        -- 杀敌进度
        elseif progressType == TaskDescProgressType.TDPT_shadi then
            iCurValue = curValueData[index] or 0
        -- 计时器进度数据走另外的消息
        elseif progressType == TaskDescProgressType.TDPT_jishiqi then
            local iYear,iMonth,iDay = EvolutionDataManager:GetInstance():GetRivakeTimeYMD()
            iCurValue = iYear*365+iMonth*30+iDay
        -- 标记值进度
        elseif progressType == TaskDescProgressType.TDPT_biaoji then
            local iTaskTagID = DecodeNumber(arg1, taskID)
            iCurValue = TaskTagManager:GetInstance():GetTag(iTaskTagID) or 0
        elseif progressType == TaskDescProgressType.TDPT_VALUE then
            iCurValue = DecodeNumber(arg1, taskID)
        elseif progressType == TaskDescProgressType.TDPT_teammatenum then
            local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
            if mainRoleInfo and (mainRoleInfo["TeammatesNums"]) then
                -- 包括了主角, 所以人数要减1
                iCurValue = (mainRoleInfo["TeammatesNums"] or 1) - 1
            end
        end
        -- 组合数据
        taskCache[descTypeID][index] = iCurValue
        if oldValue ~= iCurValue then
            bCurValueChanged = true
        end
    end
    -- 处理某一个进度数据
    local processProgressData = function(descTypeID, data)
        local progressTypeData = TableDataManager:GetInstance():GetTableData("TaskDescription",descTypeID)
        if not progressTypeData then return end
        taskCache[descTypeID] = taskCache[descTypeID] or {}
        -- 获取最大值与当前值并存入全局缓存中
        -- 函数进度/ 杀敌进度 从任务动态数据中获取
        -- 其它进度从游戏数据或静态表中获取
        local index = 1
        local progressType = progressTypeData.Progress1
        while (progressType ~= nil) and (progressType > 0) do
            genProcessByType(index, progressType, descTypeID, data)
            index = index + 1
            progressType = progressTypeData["Progress" .. index]
        end
    end
    -- 遍历一个描述所有的进度数据
    local data = nil
    local descState = nil
    for index = 0, #auiDescStates do
        data = auiDescStates[index]
        descState = data.uiDescState
        if not descState then
            taskCache[data.uiDescID] = nil
        elseif (descState == TaskDescStatesType.TDST_jinxingzhong) then
            processProgressData(data.uiDescID, data.auiDescProcess)
        end
    end

    cacheData[taskID] = taskCache
    globalDataPool:setData("TaskProcessData", cacheData, true)

    return bCurValueChanged
end

-- 更新进行中任务列表进度数据, 并通知更新
function TaskDataManager:UpdateRunningTasksProgress(akInstTasks)
    if not akInstTasks then return end
    for index, taskData in ipairs(akInstTasks) do
        if self:UpdateTaskProgressData(taskData) then
            self:NotifyTaskProgressUpdate(taskData.uiID)
        end
    end
end

-- 通知任务进度更新
function TaskDataManager:NotifyTaskProgressUpdate(taskID)
    -- do something to update task state
    local taskPool = globalDataPool:getData("TaskPool") or {}
    local taskData = taskPool[taskID]
    if not taskData then return end
    local taskTypeData = TableDataManager:GetInstance():GetTableData("Task", taskData.uiTypeID)
    self:UpdateBroadcast(nil, taskData, true)
end

-- 获取任务进度当前值
function TaskDataManager:GetTaskProgressCurValue(taskId, descTypeID, iIndex)
    -- 判断当前描述如果填写的是计时器进度, 那么直接返回当前江湖时间, 否则, 读取任务进度缓存
    local progressTypeData = TableDataManager:GetInstance():GetTableData("TaskDescription",descTypeID)
    local progressType = progressTypeData["Progress" .. iIndex]
    if progressType == TaskDescProgressType.TDPT_jishiqi then
        return EvolutionDataManager:GetInstance():GetRivakeTime() or 0
    elseif progressType == TaskDescProgressType.TDPT_MonLeftDayCount then
        -- 获取本月剩余天数
        local iYear,iMonth,iDay,iHour = EvolutionDataManager:GetInstance():GetRivakeTimeYMD()
        return 30 - (iDay or 0) + 1
    else
        local cacheData = globalDataPool:getData("TaskProcessData") or {}
        if not (cacheData[taskId] and cacheData[taskId][descTypeID]) then return 0 end
        return cacheData[taskId][descTypeID][iIndex] or 0
    end
end

-- 获取任务进度最大值
function TaskDataManager:GetTaskProgressMaxValue(taskID, descTypeID, iIndex)
    if not (descTypeID and iIndex) then return 0 end
    -- 根据进度类型分析进度最大值
    local progressTypeData = TableDataManager:GetInstance():GetTableData("TaskDescription",descTypeID)
    local progressType = progressTypeData["Progress" .. iIndex]
    local iMaxValue = 0
    -- 物品进度 主角属性进度 公共属性进度 杀敌进度 函数进度 好感度进度 武学等级进度 门派好感度进度 冒险天赋等级进度
    if (progressType == TaskDescProgressType.TDPT_wupin)
    or (progressType == TaskDescProgressType.TDPT_zhujueshuxing)
    or (progressType == TaskDescProgressType.TDPT_youxishuxing)
    or (progressType == TaskDescProgressType.TDPT_shadi)
    or (progressType == TaskDescProgressType.TDPT_hanshu) 
    or (progressType == TaskDescProgressType.TDPT_haogandu)      
    or (progressType == TaskDescProgressType.TDPT_wuxuedengji)
    or (progressType == TaskDescProgressType.TDPT_menpaihaogan)
    or (progressType == TaskDescProgressType.TDPT_maoxiantianfudengji)
    or (progressType == TaskDescProgressType.TDPT_biaoji) 
    or (progressType == TaskDescProgressType.TDPT_VALUE) then
        local arg2 = progressTypeData["Progress" .. iIndex .. "_arg2"]
        return (arg2 and DecodeNumber(arg2, taskID) or 0)
    -- 计时器进度
    elseif progressType == TaskDescProgressType.TDPT_jishiqi then
        local arg1 = progressTypeData["Progress" .. iIndex .. "_arg1"]
        local timerID = DecodeNumber(arg1, taskID)
        return self:GetTimerTriggerTime(timerID) or 0
    elseif progressType == TaskDescProgressType.TDPT_teammatenum then
        local arg1 = progressTypeData["Progress" .. iIndex .. "_arg1"]
        return (arg1 and DecodeNumber(arg1, taskID) or 0)
    -- 物品类型
    elseif progressType == TaskDescProgressType.TDPT_wupinleixing then
        --# TODO 钱程 暂无数据
        return 0
    end
    return 0
end

-- 获取任务进度数据
function TaskDataManager:GetTaskProcessData(taskID, descID, iIndex)
    local kRet = {
        ['iCurValue'] = 0,
        ['iMaxValue'] = 0,
    }
    -- check
    if not (taskID and descID and iIndex) then
        return kRet
    end
    local taskPool = globalDataPool:getData("TaskPool") or {}
    local taskData = taskPool[taskID]
    if not taskData then
        return kRet
    end
    -- Get Max
    kRet.iMaxValue = self:GetTaskProgressMaxValue(taskID, descID, iIndex)
    local bIsDescFinish = false
    -- 如果一个描述的状态是已完成(有可能是策划在任务中手动标记的)
    -- 那么查询这个进度时, 当前值直接取最大值
    -- 并且清除掉缓存的进度值
    local akDescStates = taskData.auiDescStates or {}
    for index, kState in pairs(akDescStates) do
        if (kState.uiDescID == descID) 
        and (kState.uiDescState == TaskDescStatesType.TDST_yiwancheng) then
            bIsDescFinish = true
            break 
        end
    end
    -- Get Cur
    if bIsDescFinish then
        kRet.iCurValue = kRet.iMaxValue
    else
        kRet.iCurValue = self:GetTaskProgressCurValue(taskID, descID, iIndex)
    end
    -- iCur = math.min(iCur, iMax)

    return kRet
end

-- 清空任务进度数据缓存
function TaskDataManager:ClearTaskProcessData(taskID)
    if not taskID then return end
    local cacheData = globalDataPool:getData("TaskProcessData")
    if not cacheData then return end
    cacheData[taskID] = nil
    globalDataPool:setData("TaskProcessData", cacheData, true)
end

-- 判断任务的某条边是否满足任务进度条件
function TaskDataManager:IfTaskEdgeProcessComplete(taskID, taskEdgeTypeID)
    local edgeTypeData = GetTableData("TaskEdge",taskEdgeTypeID)
    if not (taskID and edgeTypeData) then return true end
    --如果一个交付节点设置了 标记不关心进度 为true, 则直接认为进度跑满
    if HasValue(edgeTypeData.EdgeFlags, EdgeFlagType.EFT_dont_care_progress) then
        return true
    end
    -- 分析当前边的屏蔽描述ID列表
    local bHide = {}
    local kHide = edgeTypeData.HideProgressDescIDList
    if kHide and (#kHide > 0) then
        for index, descID in ipairs(kHide) do
            bHide[descID] = true
        end
    end
    -- 获取任务进度缓存
    local cacheData = globalDataPool:getData("TaskProcessData") or {}
    local taskCache = cacheData[taskID] or {}
    --否则, 判断所有已开启的进度描述否跑满
    local kProgressData = nil
    for descID, descCache in pairs(taskCache) do
        if bHide[descID] ~= true then
            for index = 1, #descCache do
                kProgressData = self:GetTaskProcessData(taskID, descID, index) or {}
                iCurValue = kProgressData.iCurValue or 0
                iMaxValue = kProgressData.iMaxValue or 0
                if iCurValue < iMaxValue then
                    return false
                end
            end
        end
    end
    return true
end

-- 更新 任务广播
function TaskDataManager:UpdateBroadcast(old, new, desc)
    local dispatchData = {
        ['old'] = old,
        ['new'] = new,
        ['desc'] = desc,
    }
    LuaEventDispatcher:dispatchEvent("TASK_BROADCAST", dispatchData)
end

-- 移除任务实例数据
function TaskDataManager:RemoveTaskData(taskID)
    local taskPool = globalDataPool:getData("TaskPool") or {}
    local taskData = taskPool[taskID]
    if not taskData then return end
    self:ClearMark(taskData)
    -- 客户端尝试不删除任务动态数据
    -- taskPool[taskID] = nil
    -- globalDataPool:setData("TaskPool", taskPool, true)
    -- 重置任务状态
    taskData.uiTaskState = 0
    taskData.bIsRemoved = true
    -- 维护进行中任务列表
    self:RemoveTaskFromRunningList(taskData)
    -- 清空任务进度数据
    self:ClearTaskProcessData(taskID)
    self:DispatchUpdateEvent()
    self:DispatchRemoveEvent(taskID)
end

-- 提交物品时，服务器占位
function TaskDataManager:DisplayShowItem(itemData)
    if not itemData then return end
    globalDataPool:setData("TaskShowItem", itemData, true)

    -- local result = {}
	-- result["uiConditionNum"] = netStreamValue:ReadInt()  -- 动态数量
	-- result["acCondDescID"] = netStreamValue:ReadInt()    -- 动态描述
	-- result["iNum"] = netStreamValue:ReadInt()
	-- result["auItems"] = {}       -- 符合筛选条件的背包
	-- for i = 0,result["iNum"] do
	-- 	if i >= result["iNum"] then
	-- 		break
	-- 	end
	-- 	result["auItems"][i] = netStreamValue:ReadInt()
	-- 	end
	-- return result
end

-- 更新 角色 - 任务 缓存表（下发一个 TaskData）
-- uiID，
-- uiTypeID，（Task表里的ID）
-- uiTaskProgressType		任务进度TPT（开始 完成 失败）
-- uiTaskState		状态（任务对应的进度，其实是TaskEdge 里的 StateID，有反查表）
-- auiDescStates    描述数组
function TaskDataManager:Traverse(taskData)
    -- 安全处理，无效排除
    if not (taskData and taskData.uiID) then 
        return 
    end
    local taskID = taskData.uiID
    local taskTypeData = self:GetTaskTypeDataByID(taskID)
    if not (taskTypeData and taskTypeData.Type) then 
        return 
    end

    local isNullType = (taskTypeData.Type == TaskType.TT_wuxiao) or (taskTypeData.Type == TaskType.TaskType_NULL)

    -- 动态数据
    local roleMarkPool = globalDataPool:getData("TaskRoleMarkPool") or {}
    local roleMarkEdge2Key = roleMarkPool.edgeID2Key or {}
    local mapMarkPool = globalDataPool:getData("TaskMapMarkPool") or {}
    local mapMarkEdge2Key = mapMarkPool.edgeID2Key or {}
    local mazeCardMarkPool = globalDataPool:getData("TaskMazeCardMarkPool") or {}
    local mazeCardMarkEdge2Key = mazeCardMarkPool.edgeID2Key or {}
    local taskStateID = taskData['uiTaskState']
    local norepEdgeTable = taskData['auiFinishNotRepeatedEdge']
    local array_edgeID = table_c2lua(taskData['auiEdgeIdList'])
    local array_condRes = table_c2lua(taskData['akEdgeCondState'])
    local array_edgeState = table_c2lua(taskData['akEdgeRegState'])
    if not (array_edgeID and array_condRes and array_edgeState) then return end

    -- 取 对应的所有 Edge
    -- local taskEdgeDataList = self:GetTaskEdgeListByStateID(taskStateID)
    -- if not taskEdgeDataList then return end

    -- 不重复触发边检查表
    local norepEdgeCheck = {}
    if norepEdgeTable then                      -- TaskEdge -> ConditionID 条件
        for k,v in pairs(norepEdgeTable) do
            norepEdgeCheck[v] = true
        end
    end

    for i = 1, #array_edgeID do
        local taskEdgeID = array_edgeID[i]
        local taskEdge = self:GetTaskEdgeByID(taskEdgeID)
        local bCondRes = dnull(array_condRes[i])  -- 边条件状态
        local bEdgeEnable = dnull(array_edgeState[i])  -- 边激活状态 
        if norepEdgeCheck[taskEdgeID] == true then
            bEdgeEnable = false
        end

        -- [1] 检查任务开始提示。
        -- 判断边条件。跑一条边的时候，如果这条边配了 显示任务开启提示，并且这个任务不是无效的，有任务类型，就显示任务开启提示
        -- 客户端这里做的话，就是得在 任务刷新之前，遍历所有的边，然后找到任务开启的这条边，是一个“上一步” 的过程
        -- 因为 updateTask 的时候已经是下一个阶段了。服务器下行 “等待交付”阶段的时候，先不更新，遍历 “开场白”阶段的边，找一下有没有 任务开启提示
        -- if not isNullType then
        --     self:CheckBeginToast(taskID, taskEdge, taskTypeData)
        -- end

        if bEdgeEnable and taskEdge and taskEdge.TaskEventID then
            -- [2] 检查 道具提交界面 是否需要打开
            self:CheckShowItemUI(taskData, taskEdge)

            -- [3] 更新角色标记
            local roleInfo = self:UpdateRoleMark(taskData, taskEdge, bCondRes)
            if roleInfo then
                local roleTypeID = roleInfo['roleTypeID']
                self:AddTaskMarkInfo(roleMarkPool, roleInfo, roleTypeID)
                roleMarkEdge2Key[taskEdgeID] = roleTypeID
            end

            -- [4] 更新地图标记
            local mapInfo = self:UpdateMapMark(taskData, taskEdge, bCondRes)
            if mapInfo then
                local typeID = mapInfo['mapTypeID']
                self:AddTaskMarkInfo(mapMarkPool, mapInfo, typeID)
                -- 建立一份edgeTypeID到mapTypeID的反查
                mapMarkEdge2Key[taskEdgeID] = typeID
            end

            -- [5] 更新迷宫卡片标记
            local mazeCardInfo = self:UpdateMazeCardMark(taskData, taskEdge, bCondRes)
            if mazeCardInfo then
                local mazeBaseID = mazeCardInfo['mazeBaseID']
                local areaIndex = mazeCardInfo['areaIndex']
                local key = self:GetMazeCardMarkPoolKey(mazeBaseID, areaIndex)
                self:AddTaskMarkInfo(mazeCardMarkPool, mazeCardInfo, key)
                mazeCardMarkEdge2Key[taskEdgeID] = key
            end
        elseif bEdgeEnable == false then
            -- 移除失活边的任务标记缓存数据
            roleMarkPool = self:RemoveTaskMarkInfoByEdge(roleMarkPool, roleMarkEdge2Key[taskEdgeID], taskEdgeID)
            mapMarkPool = self:RemoveTaskMarkInfoByEdge(mapMarkPool, mapMarkEdge2Key[taskEdgeID], taskEdgeID)
            mazeCardMarkPool = self:RemoveTaskMarkInfoByEdge(mazeCardMarkPool, mazeCardMarkEdge2Key[taskEdgeID], taskEdgeID)
        end
    end

    -- 更新缓存池
    roleMarkPool.edgeID2Key = roleMarkEdge2Key
    mapMarkPool.edgeID2Key = mapMarkEdge2Key
    mazeCardMarkPool.edgeID2Key = mazeCardMarkEdge2Key
    globalDataPool:setData("TaskRoleMarkPool", roleMarkPool, true)
    globalDataPool:setData("TaskMapMarkPool", mapMarkPool, true)
    globalDataPool:setData("TaskMazeCardMarkPool", mazeCardMarkPool, true)
end

function TaskDataManager:RemoveTaskMarkInfoByEdge(kPool, iKey, iEdgeTypeID)
    if not (kPool and iKey and iEdgeTypeID) then
        return kPool
    end
    local kMarkInfos = kPool[iKey]
    if not (kMarkInfos and kMarkInfos.edgeTypeID2TaskID and kMarkInfos.edgeTypeID2TaskID[iEdgeTypeID]) then
        return kPool
    end
    local iTaskID = kMarkInfos.edgeTypeID2TaskID[iEdgeTypeID]
    if not kMarkInfos[iTaskID] then
        return kPool
    end
    kPool[iKey][iTaskID][iEdgeTypeID] = nil
    kPool[iKey].edgeTypeID2TaskID[iEdgeTypeID] = nil
    return kPool
end

function TaskDataManager:AddTaskMarkInfo(markPool, markInfo, key)
    if not (markPool and markInfo and key) then
        return 
    end
    local taskID = markInfo.taskID
    local edgeTypeID = markInfo.edgeTypeID
    if not markPool[key] then
        markPool[key] = {}
    end
    if not markPool[key][taskID] then
        markPool[key][taskID] = {}
    end
    -- 如果已经存在对应的标记数据, 返回
    if markPool[key][taskID][edgeTypeID] then
        return
    end
    markPool[key][taskID][edgeTypeID] = markInfo
    -- 记录一份 edgeid -> taskid 的查询
    if not markPool.edgeTypeID2TaskID then
        markPool.edgeTypeID2TaskID = {}
    end
    markPool.edgeTypeID2TaskID[edgeTypeID] = taskID
end

-- 如果节点类型是开始且任务类型不为无效,那么在剧情对话后显示开启任务提示
function TaskDataManager:CheckBeginToast(taskID, taskEdge, taskTypeData)
    if not (taskEdge and taskTypeData) then 
        return 
    end
    -- FIXME: 只是一个安全容错, 建议整个任务开始提示的机制改一下, 不要太依赖 TaskUpdate 这个和任务开始没有关系的网络消息
    if not self:IsFirstShowTaskBeginToast(taskID) then
        return
    end
    if HasValue(taskEdge.EdgeFlags, EdgeFlagType.EFT_xianshi_kaiqi_tost) then
        local nameID = taskTypeData['NameID']
        local text = GetLanguageByID(nameID, taskID) or ''
        SystemUICall:GetInstance():TaskBeginToast(text)
        self.taskBeginToastLog[taskID] = true
    end
end

-- 是否是第一次显示任务开始提示
function TaskDataManager:IsFirstShowTaskBeginToast(taskID)
    self.taskBeginToastLog = self.taskBeginToastLog or {}
    if self.taskBeginToastLog[taskID] then 
        return false
    end
    return true
end

-- 是否要打开道具提交界面
function TaskDataManager:CheckShowItemUI(taskData, taskEdge)
    local taskEventID = taskEdge.TaskEventID
    local conditionID = nil
    local descID = nil
    local itemIDs = nil
    local itemNums = nil
    local taskID = taskData.uiID
    local taskEventTable = GetTableData("TaskEvent",taskEventID )

    if taskEventTable then
        if taskEventTable.Event == Event.Event_UI_tijiao_wupin then
            conditionID = DecodeNumber(taskEventTable.EventArg1, taskID)
            descID = DecodeNumber(taskEventTable.EventArg2, taskID)
            itemNums = table_arg2array(taskEventTable.EventArg3, taskID)
        elseif taskEventTable.Event == Event.Event_UI_tijiao_teding_wupin then
            itemIDs = table_arg2array(taskEventTable.EventArg1, taskID)
            descID = DecodeNumber(taskEventTable.EventArg2, taskID)
            itemNums = table_arg2array(taskEventTable.EventArg3, taskID)
        end
    end

    if conditionID or itemIDs then
        if itemIDs then
            for k,v in pairs(itemIDs) do
                if v == 0 then
                    itemIDs[k] = nil
                end
            end
        end

        local info = {
            ['taskID'] = taskData.uiID,
            ['taskEdgeID'] = taskEdge.BaseID,
            ['conditionID'] = conditionID,
            ['itemIDs'] = itemIDs,
            ['itemNums'] = itemNums,
            ['descID'] = descID,
        }
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_SUBMIT_ITEM, false, info)
    end
end

function TaskDataManager:UpdateMapMark(taskData, taskEdge, bCondRes)
    local mapTypeID = nil
    local taskEventID = taskEdge.TaskEventID
    local taskEventTable = GetTableData("TaskEvent",taskEventID )
    if not taskEventTable then
        return
    end
    if taskEventTable.Event == Event.Event_MapSelect then
        mapTypeID = DecodeNumber(taskEventTable.EventArg1, taskData.uiID)
    end
    if not mapTypeID then
        return 
    end
    return {
        ['type'] = taskEdge.Type,
        ['taskID'] = taskData.uiID,
        ['edgeTypeID'] = taskEdge.BaseID,
        ['stateID'] = taskData['uiTaskState'],
        ['eventID'] = taskEventID,
        ['mapTypeID'] = mapTypeID,
        ['bCondRes'] = bCondRes,
    }
end


local function BigMapID(sx, sy, scity, taskData, oldID)
    local tx = DecodeNumber(sx, taskData.uiID)
    local ty = DecodeNumber(sy, taskData.uiID)
    local cityID = DecodeNumber(scity, taskData.uiID)
    local mapTypeID = oldID
    if cityID ~= 0 then
        mapTypeID = cityID | (taskData.uiTypeID << 8) | 0x20000000        
    elseif tx ~= 0 or ty ~= 0 then
        mapTypeID = ToTileID(tx,ty) | 0x10000000
    end
    return mapTypeID
end
function TaskDataManager:UpdateRoleMark(taskData, taskEdge, bEdgeCondRes)
    bEdgeCondRes = (bEdgeCondRes ~= false)
    local choiceLangID = nil
    local roleTypeID = nil
    local mapTypeID = nil
    local mazeTypeID = nil
    local taskEventID = taskEdge.TaskEventID
    local taskEventTable = GetTableData("TaskEvent",taskEventID )
    if not taskEventTable then
        return
    end
    if taskEventTable.Event == Event.Event_RoleInteractive then
        choiceLangID = DecodeNumber(taskEventTable.EventArg1, taskData.uiID)
        roleTypeID = DecodeNumber(taskEventTable.EventArg2, taskData.uiID)
        mapTypeID = DecodeNumber(taskEventTable.EventArg3, taskData.uiID)
        mazeTypeID = DecodeNumber(taskEventTable.EventArg4, taskData.uiID)

        mapTypeID = BigMapID(taskEventTable.EventArg12, taskEventTable.EventArg13, taskEventTable.EventArg14, taskData, mapTypeID)
    elseif taskEventTable.Event == Event.Event_RoleSelect then
        roleTypeID = DecodeNumber(taskEventTable.EventArg1, taskData.uiID)
        mapTypeID = DecodeNumber(taskEventTable.EventArg2, taskData.uiID)
        mazeTypeID = DecodeNumber(taskEventTable.EventArg3, taskData.uiID)
        
        mapTypeID = BigMapID(taskEventTable.EventArg12, taskEventTable.EventArg13, taskEventTable.EventArg14, taskData, mapTypeID)
        
    end
    if not roleTypeID then
        return
    end
    return {
        ['type'] = taskEdge.Type,
        ['taskID'] = taskData.uiID,
        ['edgeTypeID'] = taskEdge.BaseID, 
        ['stateID'] = taskData['uiTaskState'],
        ['eventID'] = taskEventID,
        ['langID'] = choiceLangID,
        ['roleTypeID'] = roleTypeID,
        ['mapTypeID'] = mapTypeID,
        ['mazeTypeID'] = mazeTypeID,
        ['bEdgeCondRes'] = bEdgeCondRes,
    }
end

function TaskDataManager:UpdateMazeCardMark(taskData, taskEdge, bEdgeCondRes)
    bEdgeCondRes = (bEdgeCondRes ~= false)
    local mazeBaseID = nil
    local areaIndex = nil
    local cardBaseID = nil
    local row = nil
    local column = nil
    local cardID = nil
    local taskEventID = taskEdge.TaskEventID
    local taskEventTable = GetTableData("TaskEvent",taskEventID )
    local taskID = taskData.uiID
    if not taskEventTable then
        return
    end
    if taskEventTable.Event == Event.Event_ClickMazeCard then
        mazeBaseID = DecodeNumber(taskEventTable.EventArg1, taskID)
        areaIndex = DecodeNumber(taskEventTable.EventArg2, taskID)
        cardBaseID = DecodeNumber(taskEventTable.EventArg3, taskID)
        row = DecodeNumber(taskEventTable.EventArg4, taskID)
        column = DecodeNumber(taskEventTable.EventArg5, taskID)
        cardID = DecodeNumber(taskEventTable.EventArg6, taskID)
    end
    if not mazeBaseID then
        return
    end
    return {
        ['type'] = taskEdge.Type,
        ['taskID'] = taskID,
        ['edgeTypeID'] = taskEdge.BaseID, 
        ['stateID'] = taskData['uiTaskState'],
        ['eventID'] = taskEventID,
        ['mazeBaseID'] = mazeBaseID,
        ['areaIndex'] = areaIndex,
        ['cardBaseID'] = cardBaseID,
        ['row'] = row,
        ['column'] = column,
        ['cardID'] = cardID,
        ['bEdgeCondRes'] = bEdgeCondRes,
    }
end

-- 清理任务标记，任务更新时 清除之前阶段的标记
function TaskDataManager:ClearMark(taskData)
    if not taskData then return end
    local roleMarkPool = globalDataPool:getData("TaskRoleMarkPool") or {}
    local mapMarkPool = globalDataPool:getData("TaskMapMarkPool") or {}
    local mazeCardMarkPool = globalDataPool:getData("TaskMazeCardMarkPool") or {}

    local taskStateID = taskData['uiTaskState']
    if taskStateID == -1 then return end
    local taskEdgeDataList = self:GetTaskEdgeListByStateID(taskStateID)
    if not taskEdgeDataList then return end
    -- 这里就是要遍历当前阶段下所有的边, 来清除角色/地图/迷宫的任务标记数据的, 优化不了
    for _, taskEdge in ipairs(taskEdgeDataList) do 
        local taskEventID = taskEdge.TaskEventID

        if taskEventID then
            roleMarkPool = self:ClearRoleMark(taskData, taskEventID, roleMarkPool)
            mapMarkPool = self:ClearMapMark(taskData, taskEventID, mapMarkPool)
            mazeCardMarkPool = self:ClearMazeCardMark(taskData, taskEventID, mazeCardMarkPool)
        end
    end

    globalDataPool:setData("TaskRoleMarkPool", roleMarkPool, true)
    globalDataPool:setData("TaskMapMarkPool", mapMarkPool, true)
    globalDataPool:setData("TaskMazeCardMarkPool", mazeCardMarkPool, true)
end

function TaskDataManager:ClearMapMark(taskData, taskEventID, mapMarkPool)
    if not (taskData and taskEventID and mapMarkPool) then
        return mapMarkPool
    end
    local taskEventTable = GetTableData("TaskEvent",taskEventID )
    if not taskEventTable then
        return mapMarkPool
    end
    local mapTypeID = nil
    if taskEventTable.Event == Event.Event_MapSelect then
        mapTypeID = DecodeNumber(taskEventTable.EventArg1, taskData.uiID)
    end
    local taskID = taskData.uiID
    if not (mapTypeID and mapMarkPool[mapTypeID] and mapMarkPool[mapTypeID][taskID]) then
        return mapMarkPool
    end
    -- 清除对应任务的任务标记数据
    mapMarkPool[mapTypeID][taskID] = nil
    return mapMarkPool
end

function TaskDataManager:ClearMazeCardMark(taskData, taskEventID, mazeCardMarkPool)
    if not (taskData and taskEventID and mazeCardMarkPool) then
        return
    end
    local taskEventTable = GetTableData("TaskEvent",taskEventID )
    if not taskEventTable then
        return mazeCardMarkPool
    end
    local mazeBaseID = nil
    local areaIndex = nil
    local taskID =  taskData.uiID
    if taskEventTable.Event == Event.Event_ClickMazeCard then
        mazeBaseID = DecodeNumber(taskEventTable.EventArg1, taskID)
        areaIndex = DecodeNumber(taskEventTable.EventArg2, taskID)
    end
    if not (mazeBaseID and areaIndex) then
        return mazeCardMarkPool
    end
    local key = self:GetMazeCardMarkPoolKey(mazeBaseID, areaIndex)
    if not (key and mazeCardMarkPool[key] and mazeCardMarkPool[key][taskID]) then
        return mazeCardMarkPool
    end
    -- 移除对应任务的任务标记数据
    mazeCardMarkPool[key][taskID] = nil
    return mazeCardMarkPool
end

function TaskDataManager:ClearRoleMark(taskData, taskEventID, roleMarkPool)
    if not (taskData and taskEventID and roleMarkPool) then
        return roleMarkPool
    end
    local taskEventTable = GetTableData("TaskEvent",taskEventID )
    if not taskEventTable then
        return roleMarkPool
    end
    local roleTypeID = nil
    if taskEventTable.Event == Event.Event_RoleInteractive then
        roleTypeID = DecodeNumber(taskEventTable.EventArg2, taskData.uiID)
    elseif taskEventTable.Event == Event.Event_RoleSelect then
        roleTypeID = DecodeNumber(taskEventTable.EventArg1, taskData.uiID)
    end
    local taskID = taskData.uiID
    if not (roleTypeID and roleMarkPool[roleTypeID] and roleMarkPool[roleTypeID][taskID]) then
        return roleMarkPool
    end
    -- 移除对应任务的任务标记数据
    if roleMarkPool[roleTypeID][taskID] then
        roleMarkPool[roleTypeID][taskID] = nil  
    end
    return roleMarkPool
end

-- 任务标记
local roleMarkAtlas = {
    ['main_done'] = 31,
    ['regional_done'] = 30,
    ['main_new'] = 21,
    ['regional_new'] = 20, 
    ['main_doing'] = 11,
    ['regional_doing'] = 10, 
}
-- 获取任务Edge的 标记名字 和 标记权重
function TaskDataManager:GetTaskMark(taskType, edgeType, canSubmit)
    local task_type = ''
    local node_type = ''

    if taskType == TaskType.TT_zhuxian then
        task_type = 'main_'
    else
        task_type = 'regional_'
    end

    -- 节点类型配置为待交付, 则 npc/建筑头顶 强制显示为不可交付标记(灰色问号)
    -- 节点类型若配置为普通或结局, 则 npc/建筑头顶 不会显示任何标记
    -- 节点类型配置为可接, 则 npc/建筑头顶 显示可接标记
    if edgeType == TaskEdgeType.TET_CanTake then
        node_type = 'new'
    elseif edgeType == TaskEdgeType.TET_NeedGive then 
        node_type = 'doing'
    elseif (edgeType == TaskEdgeType.TET_Give and canSubmit == true ) then
        node_type = 'done'
    elseif (edgeType == TaskEdgeType.TET_Give and canSubmit == false ) then
        node_type = 'doing'
    end

    local comb = task_type..node_type
    for k,v in pairs(roleMarkAtlas) do
        if k == comb then
            return k, v
        end
    end
    return nil, 0
end

-- 返回地图标记
function TaskDataManager:CheckMapMark(mapData)
    if not mapData then 
        return
    end
    local mapTypeID = mapData.BaseID
    local mapMarkPool = globalDataPool:getData("TaskMapMarkPool") or {}
    if not mapMarkPool[mapTypeID] then
        return
    end
    local mapMarks = mapMarkPool[mapTypeID]
    local max_weight_info = nil  -- 该地图对应的任务标记中, 所占权重最大的任务标记数据
    local max_weight = -1  -- 当前的最大权重
    local node_type  -- 当前节点(边)所对应的任务标记类型
    local weight  -- 当前节点(边)所对应的任务标记权重
    local taskTypeData, taskType = nil, nil

    for taskID, kEdgeMark in pairs(mapMarks) do
        taskTypeData = self:GetTaskTypeDataByID(taskID)
        taskType = taskTypeData.Type
        for edgeTypeID, info in pairs(kEdgeMark) do
            node_type, weight = self:GetTaskMark(taskType, info['type'], true)
            info['state'] = node_type   -- 记录标记类型方便显示
            if weight > max_weight then
                max_weight = weight
                max_weight_info = info
            end
        end
    end

    return max_weight_info
end

function TaskDataManager:GetMazeCardMarkPoolKey(mazeBaseID, areaIndex)
    return tostring(mazeBaseID) .. ',' .. tostring(areaIndex)
end

-- 点击迷宫卡片标记
function TaskDataManager:CheckMazeCardMark(cardData)
    if not cardData then 
        return
    end
    local mazeDataManagerInstance = MazeDataManager:GetInstance()
    local mazeBaseID = mazeDataManagerInstance:GetCurMazeTypeID()
    local areaIndex = mazeDataManagerInstance:GetCurAreaIndex()
    if not dnull(mazeBaseID) then
        return
    end
    areaIndex = areaIndex + 1
    local key = self:GetMazeCardMarkPoolKey(mazeBaseID, areaIndex)
    local mazeCardMarkPool = globalDataPool:getData("TaskMazeCardMarkPool") or {}
    if not (key and mazeCardMarkPool[key]) then
        return
    end
    local marks = mazeCardMarkPool[key]
    local max_weight_info = nil  -- 该迷宫卡片对应的任务标记中, 所占权重最大的任务标记数据
    local max_weight = -1  -- 当前的最大权重
    local node_type  -- 当前节点(边)所对应的任务标记类型
    local weight  -- 当前节点(边)所对应的任务标记权重
    local taskTypeData, taskType = nil, nil

    for taskID, kEdgeMark in pairs(marks) do
        taskTypeData = self:GetTaskTypeDataByID(taskID)
        taskType = taskTypeData.Type
        for edgeTypeID, info in pairs(kEdgeMark) do
            if (info.cardBaseID == cardData.BaseID) or (info.cardID == cardData.ID) then 
                node_type, weight = self:GetTaskMark(taskType, info['type'], true)
                info['state'] = node_type   -- 记录标记类型方便显示
                if weight > max_weight then
                    max_weight = weight
                    max_weight_info = info
                end
            end 
        end
    end

    return max_weight_info
end

function TaskDataManager:CheckRoleMark(roleID, mapTypeID, mazeTypeID, choiceID, roleTypeID)
    if not roleID and not roleTypeID then
        return
    end
    local roleMarkPool = globalDataPool:getData("TaskRoleMarkPool") or {}
    roleTypeID = roleTypeID or RoleDataManager:GetInstance():GetRoleTypeID(roleID)
    local roleMarks = roleMarkPool[roleTypeID]
    if not (roleMarks and next(roleMarks)) then
        return
    end
    --计算权值并选择权值最大的任务状态, 只遍历一次
    local map_bingo = false  -- 数据是否命中参数指定的地图?
    local select_bingo = false  -- 数据是否命中参数指定的对话选项?
    local max_weight_info = nil  -- 该角色对应的任务标记中, 所占权重最大的任务标记数据
    local max_weight = -1  -- 当前的最大权重
    local node_type  -- 当前节点(边)所对应的任务标记类型
    local weight  -- 当前节点(边)所对应的任务标记权重
    local taskTypeData, taskType = nil, nil
    -- 对于一个角色来说:
    -- 如果现实的是卡片中人物头顶的任务标记, 那么就要对比挂在该角色身上所有的任务, 挑选最优先现实的任务标记数据来显示
    -- 对于任务对话选项上的任务标记, 优先找到与该对话选项所对应的任务标记数据
    for taskID, kEdgeMark in pairs(roleMarks) do
        taskTypeData = self:GetTaskTypeDataByID(taskID)
        taskType = taskTypeData.Type
        for edgeTypeID, info in pairs(kEdgeMark) do
            local canSubmit = (info['bEdgeCondRes'] ~= false)
            -- 判断任务进度是否跑满, 没跑满, 则不可交付
            if not self:IfTaskEdgeProcessComplete(taskID, edgeTypeID) then
                canSubmit = false
            end
            node_type, weight = self:GetTaskMark(taskType, info['type'], canSubmit)
            info['state'] = node_type   -- 记录标记类型方便显示
            if weight > max_weight then
                -- 注意，当和队友交互的时候，传入的 mapTypeID 是 0，这时候所有地图的交互都要显示
                map_bingo = (dnull(mapTypeID) ~= true) or (info.mapTypeID == nil) or (info.mapTypeID == 0) or (info.mapTypeID == mapTypeID)
                if not map_bingo then
                    if (mapTypeID & 0x20000000) ~= 0 then
                        map_bingo = (info.mapTypeID & 0x200000ff) == (mapTypeID & 0x200000ff)
                    end
                end
                select_bingo = (choiceID == nil) or (info.langID == nil) or (info.langID == choiceID)
                if (map_bingo == true) and (select_bingo == true) then
                    -- 一般情况下, 不认为会出现有多个任务的角色事件挂在同一个角色的同一个选项上
                    -- 所以, 当形参的选项不为空, 并且命中任务标记数据的时候, 可以将这个任务标记数据直接返回给调用方了
                    if choiceID ~= nil then 
                        return info
                    end
                    -- 否则, 记录相应的数据并留与下次对比
                    max_weight = weight
                    max_weight_info = info
                end
            end
        end
    end
    return max_weight_info
end

function TaskDataManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_TASK_DATA")
end

function TaskDataManager:DispatchRemoveEvent(taskID)
    LuaEventDispatcher:dispatchEvent("REMOVE_TASK_DATA", taskID)
end

-- 获取当前的所有任务
function TaskDataManager:GetTaskPool()
    return globalDataPool:getData("TaskPool") or {}
end

-- 获取事件相关的任务数据
function TaskDataManager:GetTaskEdgeListByEvent(eventType, ...)
    local findArgList = {...}
    local taskPool = self:GetTaskPool()
    local taskEdgeList = {}

    for taskID, taskData in pairs(taskPool) do 
        local taskStateID = taskData.uiTaskState
        local taskEdgeDataList = self:GetTaskEdgeListByStateID(taskStateID)
        if taskEdgeDataList then 
            for _, taskEdge in ipairs(taskEdgeDataList) do 
                local taskEventId = taskEdge.TaskEventID
                if (taskEventId) then
                    local taskEventTable = GetTableData("TaskEvent",taskEventId )
                    if taskEventTable and taskEventTable.Event == eventType then 
                        local argList = {taskEventTable.EventArg1, taskEventTable.EventArg2, taskEventTable.EventArg3, taskEventTable.EventArg4, taskEventTable.EventArg5}
                        argList = self:DecodeEventArgList(eventType, argList, taskID)
                        if self:IsEventArgListEqual(findArgList, argList) then 
                            table.insert(taskEdgeList, taskEdge)
                        end
                    end
                end
            end
        end
    end

    return taskEdgeList
end

-- 获取事件参数的真实数据
function TaskDataManager:DecodeEventArgList(eventType, argList, taskID)
    if eventType == Event.Event_RoleInteractive then 
        for index, arg in ipairs(argList) do 
            argList[index] = DecodeNumber(arg, taskID)
        end
    elseif eventType == Event.Event_RoleSelect then 
        for index, arg in ipairs(argList) do 
            argList[index] = DecodeNumber(arg, taskID)
        end
    end
    return argList
end

-- 判断事件数据是否匹配
function TaskDataManager:IsEventArgListEqual(eventArgList1, eventArgList2)
    if type(eventArgList1) ~= 'table' or type(eventArgList2) ~= 'table' then 
        return false
    end
    for index, arg1 in pairs(eventArgList1) do 
        local arg2 = eventArgList2[index]
        if arg1 == 0 or arg2 == 0 or arg1 == arg2 or arg1 == nil or arg2 == nil then 
            return true
        else
            return false
        end
    end
    return true
end


function TaskDataManager:GetTaskTypeAbbr(index)
    local type_nav = {
        [1] = "主线",
        [2] = "历练",
        [3] = "角色",
        [4] = "传闻",
        [5] = "委托",
        [6] = "已完成",
        [7] = "其他(测试)"
    }
    return type_nav[index]
end

-- 确定要显示后，需要把任务放到哪一个导航栏下
function TaskDataManager:GetNavIndex(taskID)
    local taskData = self:GetTaskData(taskID)
    local taskTypeData = self:GetTaskTypeDataByID(taskID)
    if taskData == nil or taskTypeData == nil then
        return TaskNav.QiTa
    end 
    local taskType = taskTypeData['Type']

    if taskType == TaskType.TT_zhuxian or taskType == TaskType.TT_liliang or taskType == TaskType.TT_juese or taskType == TaskType.TT_chuanwen then
        return taskType
    elseif taskType == TaskType.TT_menpaiwtuo or taskType == TaskType.TT_juesewtuo or taskType == TaskType.TT_guanfuwtuo then
        return TaskNav.WeiTuo
    elseif taskData.uiTaskGroup ~= 0 then
        return TaskNav.WeiTuo
    else
        return TaskNav.QiTa
    end
end


-- 从一个任务转换出任务面板显示所用的数据结构
function TaskDataManager:GetDescShowData(taskData)
    if not taskData then return end
    local descStates = taskData['auiDescStates']
    local descSize = taskData['iDescStateSize']     -- 个数
    local desc_tab_toshow = {}
    if not descStates then return desc_tab_toshow end
    local state_weight = {
        [TaskDescStatesType.TDST_yiwancheng] = 3,
        [TaskDescStatesType.TDST_yishibai] = 3,
        [TaskDescStatesType.TDST_jinxingzhong] = 2,
        [TaskDescStatesType.TDST_yincang] = 1,
    }
    -- 拷贝一份用于排序，并把 C++ 数组 转化为 Lua 数组
    for i = 1, descSize do
        -- 排除 "移除" 和 "空" 节点，剩下的用于排序
        if descStates[i-1].uiDescState ~= TaskDescStatesType.TDST_yichu and 
        descStates[i-1].uiDescState ~= TaskDescStatesType.TDST_NULL  then
            local state = {
                ['index'] = i,
                ['uiDescID'] = descStates[i-1].uiDescID,
                ['uiDescState'] = descStates[i-1].uiDescState,
            }
            table.insert(desc_tab_toshow, state)
        end
    end
    table.sort(desc_tab_toshow, function(a, b)
        if state_weight[a.uiDescState] == state_weight[b.uiDescState] then
            return (a.index < b.index)
        end
        return (state_weight[a.uiDescState] > state_weight[b.uiDescState])
    end)
    return desc_tab_toshow
end

-- 缓存任务计时器信息
function TaskDataManager:CacheTaskTimerData(retStream)
    -- <protocol Name="Display_DRTimer_Update" Stream='true' Comment="计时器更新">
    --     <member Name="iFlag" Type="Byte" InitValue="0" Comment="更新标记0更新1删除"/>
    --     <member Name="uiTimerID" Type="DWord" InitValue="0" Comment="计时器ID"/>
    --     <member Name="uiTimerExpiration" Type="DWord" InitValue="0" Comment="计时器到期时间"/>
    -- </protocol>
    local uiTimerID = retStream.uiTimerID
    if (not uiTimerID) or (uiTimerID == 0) then return end
    local bDetete = (retStream.iFlag == 1)
    local taskTimerRecord = globalDataPool:getData("taskTimerRecord") or {}
    if bDetete then
        taskTimerRecord[uiTimerID] = nil
    else
        taskTimerRecord[uiTimerID] = retStream.uiTimerExpiration or 0
    end
    globalDataPool:setData("taskTimerRecord", taskTimerRecord, true)
end

-- 获取计时器到期时间
function TaskDataManager:GetTimerTriggerTime(timerID)
    if timerID == nil then 
        return 0
    end
    local taskTimerRecord = globalDataPool:getData("taskTimerRecord") or {}
    return taskTimerRecord[timerID] or 0
end

---------------------------------- 任务奖励部分 --------------------------------

-- 解析一整个任务的所有基础奖励，合并为一个表格返回
function TaskDataManager:ParseAllToRewardList(taskID, bCaculateOriDispo, alreadyAddDispo)
    local taskBaseData = self:GetTaskTypeDataByID(taskID)
    local taskData = self:GetTaskData(taskID)
    if not (taskData ~= nil and taskBaseData ~= nil) then
        return {} 
    end

    local reward_list = {}
    -- [1] 解析基础奖励（经验 金币）
    local normalRewardList = {}
    if taskData.uiNormalRewardCount > 0 then
        -- 动态奖励
        for i = 0, taskData.uiNormalRewardCount - 1 do 
            local rewardType = taskData.auiTaskNormalRewardList[i]
            table.insert(normalRewardList, rewardType) 
        end
    elseif taskBaseData.TaskNormalRewards then
        -- 静态表奖励
        normalRewardList = taskBaseData.TaskNormalRewards
    end
    local taskLevel = self:GetTaskLevel(taskID)
    local taskDifficulty = self:GetTaskDifficulty(taskID)
    for _, rewardType in ipairs(normalRewardList) do 
        local reward = self:GetReward(rewardType, taskLevel, taskDifficulty)
        table.insert(reward_list, reward)
    end
    
    -- [2] 检查任务是否有直接填写的 仁义值 奖励 (与奖励ID同级)
    local rewardShanE = 0
    if taskData.uiRewardGoodEvil ~= 0 then
        -- 动态奖励
        rewardShanE = taskData.uiRewardGoodEvil
    elseif dnull(taskBaseData.Shane) then
        -- 静态表奖励
        rewardShanE = taskBaseData.Shane
    end
    if rewardShanE ~= 0 then 
        local reward = self:ParseTaskGoodEvilReward(rewardShanE)
        table.insert(reward_list, reward)
    end

    -- [3] 检查任务是否有直接填写的 角色好感度 奖励 (与奖励ID同级)
    if taskData.uiRoleDispositionRewardSize > 0 then 
        -- 动态奖励
        for i = 0, taskData.uiRoleDispositionRewardSize - 1 do 
            local roleID = taskData.auiRoleDispositionRole[i]
            local roleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
            local dispositionValue = taskData.auiRoleDispositionValue[i]
            local rewards = self:ParseTaskFavorReward(taskID, roleBaseID, nil, nil, dispositionValue, bCaculateOriDispo, alreadyAddDispo)
            if rewards and next(rewards) then
                table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
            end
        end
    end
    if dnull(taskBaseData.RoleDispositionRewardList) then
        for _, roleValuePair in ipairs(taskBaseData.RoleDispositionRewardList) do 
            local roleBaseID = roleValuePair.Role
            local dispositionValue = roleValuePair.Value
            local rewards = self:ParseTaskFavorReward(taskID, roleBaseID, nil, nil, dispositionValue, bCaculateOriDispo, alreadyAddDispo)
            if rewards and next(rewards) then
                table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
            end
        end
    end

    -- [4] 检查任务是否有直接填写的 门派好感度 奖励 (与奖励ID同级)
    if taskData.uiClanDispositionRewardSize > 0 then 
        -- 动态奖励
        for i = 0, taskData.uiClanDispositionRewardSize - 1 do 
            local clanBaseID = taskData.auiClanDispositionClan[i]
            local dispositionValue = taskData.auiClanDispositionValue[i]
            local rewards = self:ParseTaskFavorReward(taskID, nil, clanBaseID, nil, dispositionValue)
            if rewards and next(rewards) then
                table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
            end
        end
    end
    if dnull(taskBaseData.ClanDispositionReward) then
        for _, clanValuePair in ipairs(taskBaseData.ClanDispositionReward) do 
            local clanBaseID = clanValuePair.Clan
            local dispositionValue = clanValuePair.Value
            local rewards = self:ParseTaskFavorReward(taskID, nil, clanBaseID, nil, dispositionValue)
            if rewards and next(rewards) then
                table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
            end
        end
    end

    -- [5] 检查任务是否有直接填写的 城市好感度 奖励 (与奖励ID同级)
    if taskData.uiCityDispositionRewardSize > 0 then 
        -- 动态奖励
        for i = 0, taskData.uiCityDispositionRewardSize - 1 do 
            local cityBaseID = taskData.auiCityDispositionCity[i]
            local dispositionValue = taskData.auiCityDispositionValue[i]
            local rewards = self:ParseTaskFavorReward(taskID, nil, nil, cityBaseID, dispositionValue)
            if rewards and next(rewards) then
                table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
            end
        end
    end
    if dnull(taskBaseData.CityDispositionRewardList) then
        for _, cityValuePair in ipairs(taskBaseData.CityDispositionRewardList) do 
            local cityBaseID = cityValuePair.City
            local dispositionValue = cityValuePair.Value
            local rewards = self:ParseTaskFavorReward(taskID, nil, nil, cityBaseID, dispositionValue)
            if rewards and next(rewards) then
                table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
            end
        end
    end

    -- [6] TaskRewards 奖励ID 的解析
    local rewardList = {}
    if taskData.uiRewardCount > 0 then
        -- 动态奖励
        for i = 0, taskData.uiRewardCount - 1 do 
            local rewardID = taskData.auiTaskRewardList[i]
            table.insert(rewardList, rewardID) 
        end
    end
    if taskBaseData.TaskRewards then
        -- 静态表奖励
        for _, rewardID in ipairs(taskBaseData.TaskRewards) do
            table.insert(rewardList, rewardID) 
        end
    end
    for _, rewardID in ipairs(rewardList) do
        local rewards = self:ParseTaskReward(rewardID, taskID, bCaculateOriDispo, alreadyAddDispo)
        if rewards and next(rewards) then
            table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
        end
    end

    -- [7] RoleCardReward 角色卡 的解析
    if taskData.uiRoleCardReward > 0 then
        taskData.bGetRoleCardReward = taskData.bGetRoleCardReward or 1
        local rewards = self:ParseRoleCard(taskData.uiRoleCardReward, taskData.bGetRoleCardReward)
        if rewards and next(rewards) then
            table.move(rewards, 1, #rewards, #reward_list + 1, reward_list)
        end
    end

    return reward_list
end

-- 解析一个 TaskReward，返回 reward 表
function TaskDataManager:ParseTaskReward(taskRewardID, taskID, bCaculateOri, alreadyAddDispo)
    if not taskRewardID then return end
    local taskRewardTypeData = GetTableData("TaskReward",taskRewardID)
    if not taskRewardTypeData then return end
    local taskRewards = {}
    local type = taskRewardTypeData['Reward']
    if type == TaskRewardType.TRT_diaoluo then
        local dropID = DecodeNumber(taskRewardTypeData['RewardArg1'], taskID)
        return self:ParseTaskDrop(dropID, taskRewards)
    elseif type == TaskRewardType.TRT_renwu then
        return
    elseif type == TaskRewardType.TRT_xinyuan then
        local roleTypeID = DecodeNumber(taskRewardTypeData['RewardArg1'], taskID)
        local iWishTaskID = DecodeNumber(taskRewardTypeData['RewardArg2'], taskID)
        roleTypeID = taskRewardTypeData['RewardArg1'] == 'MAINROLE' and 1000001260 or roleTypeID;
        return self:ParseTaskWishTaskReward(roleTypeID, iWishTaskID)
    elseif type == TaskRewardType.TRT_haogandu then
        local roleTypeID = DecodeNumber(taskRewardTypeData['RewardArg1'], taskID)
        local iFavor = DecodeNumber(taskRewardTypeData['RewardArg2'], taskID)
        return self:ParseTaskFavorReward(taskID, roleTypeID, nil, nil, iFavor, bCaculateOri, alreadyAddDispo)
    elseif type == TaskRewardType.TRT_city_haogandu then
        local cityTypeID = DecodeNumber(taskRewardTypeData['RewardArg1'], taskID)
        local iFavor = DecodeNumber(taskRewardTypeData['RewardArg2'], taskID)
        return self:ParseTaskFavorReward(taskID, nil, nil, cityTypeID, iFavor)
    elseif type == TaskRewardType.TRT_clan_haogandu then
        local clanTypeID = DecodeNumber(taskRewardTypeData['RewardArg1'], taskID)
        local iFavor = DecodeNumber(taskRewardTypeData['RewardArg2'], taskID)
        return self:ParseTaskFavorReward(taskID, nil, clanTypeID, nil, iFavor)
    elseif type == TaskRewardType.TRT_ROLE_CARD then
        local roleID = DecodeNumber(taskRewardTypeData['RewardArg1'], taskID)
        return self:ParseTaskFavorReward(taskID, nil, clanTypeID, nil, iFavor)
    end
end

-- 解析任务仁义值奖励
function TaskDataManager:ParseTaskGoodEvilReward(iGoodEvilValue)
    iGoodEvilValue = iGoodEvilValue or 0
    -- 仁义值 80147（显示模板）
    return {
        ['BaseID'] = 80147,
        ['Num'] = iGoodEvilValue,
    }
end

-- 解析心愿任务奖励
function TaskDataManager:ParseTaskWishTaskReward(roleTypeID, wishTaskID)
    if not (roleTypeID and wishTaskID) then
        return
    end
    local kRoleTypeData = TB_Role[roleTypeID]
    local kWishTypeData = TableDataManager:GetInstance():GetTableData("RoleWishQuest", wishTaskID)
    if not (kRoleTypeData and kWishTypeData) then
        return
    end
    local title = "心愿任务"
    local desc = string.format("完成%s心愿任务:　%s", GetLanguageByID(kRoleTypeData.NameID), GetLanguageByID(kWishTypeData.NameID))
    local data = {
        ['RoleTypeID'] = roleTypeID,
        ['IsWishTask'] = true,
        ['Name'] = title,
        ['Desc'] = desc,
    }
    -- 需要返回一个数组
    local ret = {[1] = data}
    return ret
end

-- @desc:解析任务好感度奖励
-- @param1:角色typeid
-- @param2:门派typeid
-- @param3:城市id
-- @param4:好感度
-- @param5:是否需要计算衰减
-- @param6:代表好感度是否已经加上了，会影响计算结果
function TaskDataManager:ParseTaskFavorReward(taskID, roleTypeID, clanTypeID, cityBaseID, iFavor, caculateOri, alreadyAddDispo)
    iFavor = iFavor or 0
    local ret = {}
    if roleTypeID and (roleTypeID ~= 0) then
        local instance = RoleDataManager:GetInstance()
        local srcID = instance:GetRoleID(roleTypeID)
        local favorData = instance:GetDispotionDataToMainRole(srcID, roleTypeID)
        local new_favor = favorData.iValue
        local roleTypeData = instance:GetRoleTypeDataByTypeID(roleTypeID)
        local name_str = instance:GetRoleName(roleTypeID)
        if (caculateOri) then
            -- 获取经过衰减的好感变化值
            iFavor = self:GetRewardFavorChangeValue(taskID, roleTypeID, new_favor, iFavor, alreadyAddDispo)
        end
        -- 角色好感度 80145（显示模板）
        table.insert(ret, {
            ['BaseID'] = 80145,
            ['RoleTypeID'] = roleTypeID,
            ['Num'] = iFavor,
            ['Name'] = dtext(972) .. name_str,
            ['Desc'] = string.format('更改%s的好感度（当前：%d）\n该奖励可能会随着当前好感度而衰减', name_str, new_favor),
        })
    elseif clanTypeID and (clanTypeID ~= 0) then
        -- 门派好感度 80146（显示模板）
        local clanTypeData = ClanDataManager:GetInstance():GetClanTypeDataByTypeID(clanTypeID)
        local name_str = GetLanguageByID(clanTypeData.NameID)
        local new_favor = ClanDataManager:GetInstance():GetDisposition(clanTypeID)
        table.insert(ret, {
            ['BaseID'] = 80146,
            ['ClanTypeID'] = clanTypeID,
            ['Num'] = iFavor,
            ['Name'] = dtext(971) .. name_str,
            ['Desc'] = string.format('更改%s的好感度（当前：%d）', name_str, new_favor),
        })
    elseif cityBaseID and (cityBaseID ~= 0) then 
        local cityData = CityDataManager:GetInstance():GetCityData(cityBaseID)
        local name_str = GetLanguageByID(cityData.NameID)
        local dispostion = cityData.iCityDispo or 0
        table.insert(ret, {
            ['BaseID'] = 80146,
            ['CityTypeID'] = cityBaseID,
            ['Num'] = iFavor,
            ['Name'] = dtext(1006) .. name_str,
            ['Desc'] = string.format('更改%s的好感度（当前：%d）', name_str, dispostion),
        })
    end
    return ret
end

-- 解析一个 Drop-task
-- 如果是掉落，则需要读 Drop 表
function TaskDataManager:ParseTaskDrop(dropID)
    if not dropID then return end
    local dropTypeData = TableDataManager:GetInstance():GetTableData("Drop",dropID)
    if not dropTypeData then return end
    local rewardList = {}

    -- DropID   一个掉落可能由多条 Base 组成
    -- DropCountMin 掉落下限
    -- DropCountMax 掉落上限
    -- RandomType 随机类型  1.0版本可以先不管随机类型，直接显示
    -- DropDatas 产出组合
    if (dropTypeData['DropDatas']) then
        for k,v in pairs(dropTypeData['DropDatas']) do
            local count = v.ItemCountMin or 1
            local reward
            -- 权重概率不用管，产出限制ID先不管（如果缺了东西，客户端也要表现）
            if v.ItemCountMin == v.ItemCountMax then
                reward = self:GetItem(v.ItemID, count)                   -- 物品ID
                if reward then
                    table.insert(rewardList, reward)
                end
    
                reward = self:GetMartialBookItem(v.MartialBook, count)   -- 秘籍武学ID
                if reward then
                    table.insert(rewardList, reward)
                end
    
                reward = self:GetMartialPageItem(v.MartialPage, count)   -- 残章武学ID
                if reward then
                    table.insert(rewardList, reward)
                end
    
                reward = self:GetTianshuGiftItem(v.TianshuGift, count)   -- 天书的giftID
                if reward then
                    table.insert(rewardList, reward)
                end
    
                reward = self:GetRoleCardItem(v.RoleCard, count)         -- 角色卡角色ID
                if reward then
                    table.insert(rewardList, reward)
                end
    
                if v.RoleAttr then              -- TODO：角色属性，不知道怎么表现
                end
                -- 还有一堆属性，先不管
            else
                dprint('客户端未处理数量不固定任务奖励Drop')
            end
        end
    end

    -- 根据掉落表，获取幸运值掉落物品，予以显示
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo");
    local curDiff = mainRoleInfo.MainRole[MainRoleData.MRD_DIFF];
    local scriptID = GetCurScriptID()
    local storyDiffDrop = AchieveDataManager:GetInstance():GetDiffDropTBData(curDiff,scriptID)
    local difftableData = AchieveDataManager:GetInstance():GetDiffDropTBDataByDropID(storyDiffDrop,dropID)

    local Luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue(scriptID)
    for k, v in pairs(difftableData) do
        local reward
        local dropRewordItem = AchieveDataManager:GetInstance():GetDiffDropRewordByLucky(v,Luckyvalue)
        local iLimitNum = v.NumLimit 
        if not iLimitNum or iLimitNum == 0 then 
            iLimitNum = 1 
        end 

        local diffdropdata = AchieveDataManager:GetInstance():GetDiffDropDataByTypeID(k, scriptID, curDiff)
        local iget =  diffdropdata and diffdropdata.uiRoundFinish or 0

        local finish = false
        local bShowEmpty = false
        if (diffdropdata) then
            finish = iget >= iLimitNum
            local kOldData = AchieveDataManager:GetInstance():GetDiffDropOldDataByTypeID(k, scriptID, curDiff)
            if kOldData and kOldData.uiRoundFinish then
                bShowEmpty = kOldData.uiRoundFinish >= iLimitNum
            end
        end
        local onlyGetOnce = false
        if (v.WeekUnique == TBoolean.BOOL_YES) then
            onlyGetOnce = true
        end

        if (dropRewordItem and dropRewordItem.Type == StoryDiffDropRewardType.SDDRT_Item) then
            reward = self:GetItem(dropRewordItem.Value, 1)                   -- 物品ID
            reward["DiffDropGet"] = finish
            reward["onlyGetOnce"] = onlyGetOnce
            reward['bShowEmpty'] = bShowEmpty
            if (reward) then
                table.insert(rewardList, reward)
            end
        elseif (dropRewordItem and dropRewordItem.Type == StoryDiffDropRewardType.SDDRT_Canzhang) then
            reward = self:GetMartialPageItem(dropRewordItem.Value, dropRewordItem.ItemCountMin)   -- 残章武学ID
            reward["DiffDropGet"] = finish
            reward["onlyGetOnce"] = onlyGetOnce
            reward['bShowEmpty'] = bShowEmpty
            if reward then
                table.insert(rewardList, reward)
            end
        elseif (dropRewordItem and dropRewordItem.Type == StoryDiffDropRewardType.SDDRT_Miji) then
            reward = self:GetMartialBookItem(dropRewordItem.Value, dropRewordItem.ItemCountMin)   -- 秘籍武学ID
            reward["DiffDropGet"] = finish
            reward["onlyGetOnce"] = onlyGetOnce
            reward['bShowEmpty'] = bShowEmpty
            if reward then
                table.insert(rewardList, reward)
            end
        end
    end
    
    return rewardList
end

function TaskDataManager:ParseRoleCard(itemID, bGetRoleCardReward)
    local rewardList = {}
    if itemID == nil then
        return rewardList
    end

    local bFirstGet = false

    if bGetRoleCardReward == nil  then
        bGetRoleCardReward = 1
    end

    -- 此难度第一次获得
    if bGetRoleCardReward == 0 then
        bFirstGet = false
    else
        bFirstGet = true
    end

   
    local reward
    reward = self:GetItem(itemID, 1)                   -- 物品ID
    reward["DiffDropGet"] = bFirstGet
    reward["onlyGetOnce"] = true
    reward['bShowEmpty'] = false
    if (reward) then
        table.insert(rewardList, reward)
    end
    return rewardList
end

-- 获取一个通用礼物
function TaskDataManager:GetReward(type, level, difficulty)
    if type == TaskNormalRewardType.TNRT_tongbi then
        return self:GetTongBiItem(level, difficulty)
    elseif type == TaskNormalRewardType.TNRT_jingyan then
        return self:GetExpItem(level, difficulty)
    end
    -- TODO：礼物的返回
end

-- TODO：根据任务 等级、难度，和 奖励类型，查询 阶位表，返回阶位数据
function TaskDataManager:GetRewardBase(level, difficulty, type)
    local TB_TaskNormalReward = TableDataManager:GetInstance():GetTable("TaskNormalReward")
    for index, data in pairs(TB_TaskNormalReward) do
        if (data.Difficulty == difficulty) and (data.Level == level) then
            return {
                ['Exp'] = data.ExpValue,
                ['TongBi'] = data.MoneyValue,
                ['Item'] = {},
            }
        end
    end
    return nil
end

-- [1] 获取经验
function TaskDataManager:GetExpItem(level, difficulty)
    if not (level ~= nil and difficulty ~= nil) then 
        return 
    end
    local rewardBaseData = self:GetRewardBase(level, difficulty)
    if not rewardBaseData then return end
    local reward = {
        ['BaseID'] = 9609,
        ['Num'] = rewardBaseData['Exp'],
    }
    return reward
end
-- [2] 获取铜币
function TaskDataManager:GetTongBiItem(level, difficulty)
    if not (level and difficulty) then return end
    local rewardBaseData = TaskDataManager:GetInstance():GetRewardBase(level, difficulty)
    if not rewardBaseData then return end
    local reward = {
        ['BaseID'] = 1301,
        ['Num'] = rewardBaseData['TongBi'],
    }
    return reward
end 
-- [3] 获取物品
function TaskDataManager:GetItem(itemID, count)
    if itemID == nil or itemID == 0 then return end
    local reward = {
        ['BaseID'] = itemID,
        ['Num'] = count,
    }
    return reward
end
-- [4] 获取秘籍
function TaskDataManager:GetMartialBookItem(martialTypeID, count)
    if martialTypeID == nil or martialTypeID == 0 then return end
    local martialTypeData =  GetTableData("Martial",martialTypeID)
    if not martialTypeData then return end
    local martialName = GetLanguageByID(martialTypeData.NameID)
    local sItemName = string.format("《%s》秘籍", martialName)
    local sDesc = string.format("装备：战斗后学会《%s》，并加快此武学的升级速度", martialName)
    local descID = martialTypeData.DesID
    if descID then
        sDesc = sDesc .. "\n" .. GetLanguageByID(descID)
    end
    -- 要显示秘籍, 只需要 系别 与 品质 数据
    local reward = {
        ['ItemType'] = ItemTypeDetail.ItemType_SecretBook,
        ['Depart'] = martialTypeData.DepartEnum,
        ['MartialID'] = martialTypeID,
        ['Rank'] = martialTypeData.Rank or RankType.RT_White,
        ['Name'] = sItemName,
        ['Desc'] = sDesc, 
        ['Num'] = count,
    }
    return reward
end
-- [5] 获取残章
function TaskDataManager:GetMartialPageItem(martialTypeID, count)
    if martialTypeID == nil or martialTypeID == 0 then return end
    local martialTypeData = GetTableData("Martial",martialTypeID)
    if not martialTypeData then return end
    local martialName = GetLanguageByID(martialTypeData.NameID)
    local sItemName = string.format("《%s》残章", martialName)
    local sDesc = string.format("永久提升《%s》等级上限1级，此途径最高提升到20级\n\n可在残章匣中查看", martialName)
    -- 要显示残章, 只需要 系别 数据
    local reward = {
        ['ItemType'] = ItemTypeDetail.ItemType_IncompleteBook,
        ['Depart'] = martialTypeData.DepartEnum,
        ['MartialID'] = martialTypeID,
        ['Rank'] = martialTypeData.Rank or RankType.RT_White,
        ['Name'] = sItemName,
        ['Desc'] = sDesc,
        ['Num'] = count,
    }
    return reward
end
-- [6] 获取天书
function TaskDataManager:GetTianshuGiftItem(giftTypeID, count)
    if giftTypeID == nil or giftTypeID == 0 then return end
    local giftTypeData = GetTableData("Gift",giftTypeID)
    if not giftTypeData then return end
    local giftName = GetLanguageByID(giftTypeData.NameID)
    local sItemName = string.format("《%s》天书", giftName)
    local sDesc = string.format("使角色获得《%s》天赋:　%s", giftName, GetLanguageByID(giftTypeData.DescID))
    -- 要显示天书, 只需要 品质 数据
    local reward = {
        ['ItemType'] = ItemTypeDetail.ItemType_HeavenBook,
        ['GiftID'] = giftTypeID,
        ['Rank'] = giftTypeData.Rank or RankType.RT_White,
        ['Name'] = sItemName,
        ['Desc'] = sDesc,
        ['Num'] = count,
    }
    return reward
end
-- [7] 获取角色卡
function TaskDataManager:GetRoleCardItem(roleTypeID, count)
    if roleTypeID == nil or roleTypeID == 0 then return end
    local roleDataMgr = RoleDataManager:GetInstance()
    local roleTypeData = roleDataMgr:GetRoleTypeDataByTypeID(roleTypeID)
    local roleArtData = roleDataMgr:GetRoleArtDataByTypeID(roleTypeID)
    if not (roleTypeData and roleArtData) then return end
    local roleName = GetLanguagePreset(roleTypeData.NameID, 992)
    local reward = {
        ['BaseID'] = 1923,
        ['ItemType'] = ItemTypeDetail.ItemType_RolePieces,
        ['Name'] = roleName .. dtext(987),
        ['Desc'] = dtext(985) .. roleName .. dtext(986),
        ['Rank'] = roleTypeData.Rank or RankType.RT_Golden,
        ['Icon'] = roleArtData.Head,
        ['RoleID'] = roleTypeID,
        ['Num'] = count,
    }
    return reward
end

-- 获取达成的分支奖励列表
function TaskDataManager:GetTaskAchieveBranchReward(taskID)
    local taskData = self:GetTaskData(taskID)
    local taskTypeData = self:GetTaskTypeDataByID(taskID)
    if not (taskData and taskTypeData) then return end
    local taskBranchRewards = taskTypeData.TaskBranchRewards
    if not taskBranchRewards then return end
    local uiCompleteBranchReward = taskData.uiCompleteBranchReward or 0
    local achieve = {}
    for index, rewardID in ipairs(taskBranchRewards) do
        if (uiCompleteBranchReward & (1 << (index - 1))) ~= 0 then
            achieve[#achieve + 1] = rewardID
        end
    end
    return achieve
end

-- 判断分支奖励是否领取
function TaskDataManager:HasGotTaskBranchReward(taskID, searchRewardID)
    local branchRewardList = self:GetTaskAchieveBranchReward(taskID)
    if not branchRewardList then 
        return false
    end
    for _, rewardID in ipairs(branchRewardList) do
        if searchRewardID == rewardID then 
            return true
        end
    end
    return false
end

-- 获取当前执行剧情的任务ID
function TaskDataManager:GetCurTaskID()
    return self.curTaskID or 0
end

-- 设置当前执行剧情的任务ID
function TaskDataManager:SetCurTaskID(taskID)
    self.curTaskID = taskID
end

-- 获取任务动态数据
function TaskDataManager:GetTaskDynamicData(taskID, dynamicDataType)
    local taskData = self:GetTaskData(taskID)
    if taskData == nil or taskData.auiDyDataList == nil or dynamicDataType <= 0 or dynamicDataType >= TaskDynamicType.TDynType_End then 
        return 0
    end
    return taskData.auiDyDataList[dynamicDataType] or 0
end

-- 获取自定义键任务动态数据
function TaskDataManager:GetTaskCustomDynamicData(taskID, logicKey)
    local taskData = self:GetTaskData(taskID)
    if taskData == nil or taskData.uiCustomKeyDyDataSize == nil or taskData.uiCustomKeyDyDataSize == 0 then 
        return 0
    end
    for i = 0, taskData.uiCustomKeyDyDataSize - 1 do 
        if taskData.auiCustomKeyDyDataKeyList[i] == logicKey then
            return taskData.auiCustomKeyDyDataValueList[i] or 0
        end
    end
    return 0
end

-- 获取任务等级
function TaskDataManager:GetTaskLevel(taskID)
    local taskData = self:GetTaskData(taskID)
    local taskLevel = taskData.uiTaskLevel or 1
    if taskLevel == 0 then
        taskLevel = 1 
    end
    return taskLevel
end

-- 获取任务难度
function TaskDataManager:GetTaskDifficulty(taskID)
    local taskData = self:GetTaskData(taskID)
    local taskDifficulty = taskData.uiTaskDifficulty or 1
    if taskDifficulty == 0 then
        taskDifficulty = 1 
    end
    return taskDifficulty
end

-- 初始化动态任务逻辑键查询表
function TaskDataManager:InitDynamicTaskDataKeyMapping()
    self.DynamicTaskDataKeyMapping = {}
    local TB_DynamicTaskDataKeyMapping = TableDataManager:GetInstance():GetTable("DynamicTaskDataKeyMapping")
    for _, mappingData in pairs(TB_DynamicTaskDataKeyMapping) do
        local logicKey = mappingData.BaseID
        if self.DynamicTaskDataKeyMapping[mappingData.CustomTag] ~= nil and self.DynamicTaskDataKeyMapping[mappingData.CustomTag] < logicKey then 
            -- 如果重复了, 使用值最小的
            logicKey = self.DynamicTaskDataKeyMapping[mappingData.CustomTag]
        end
        self.DynamicTaskDataKeyMapping[mappingData.CustomTag] = logicKey
    end
end

-- 基于策划表格自定义键查找动态任务逻辑键查询表
function TaskDataManager:GetTaskDynamicDataLogicKey(customKey)
    if customKey == nil or self.DynamicTaskDataKeyMapping == nil then
        return nil
    end
    return self.DynamicTaskDataKeyMapping[customKey]
end

-- <member Name="uiChoiceLangID" Type="DWord" InitValue="0" Comment="选项多语言ID"/>
-- <member Name="uiTextLangID" Type="DWord" InitValue="0" Comment="说明文字多语言ID"/>
-- <member Name="uiRoleBaseID" Type="DWord" InitValue="0" Comment="角色ID"/>
-- <member Name="uiCustomModelID" Type="DWord" InitValue="0" Comment="自定义模型ID"/>
-- <member Name="acPlayerName" Type="string" Length="256" Comment="玩家名称"/>
-- <member Name="bIsLocked" Type="bool" Comment="是否锁定"/>
-- <member Name="bIsImportantChoice" Type="bool" Comment="是否是重要选项"/>
-- <member Name="uiTaskID" Type="DWord" InitValue="0" Comment="任务ID"/>
-- 记录选项信息
function TaskDataManager:LogChoiceInfo(choiceInfoNetStream)
    local taskID = choiceInfoNetStream.uiTaskID
    local textLangID = choiceInfoNetStream.uiTextLangID
    self.choiceInfo = self.choiceInfo or {}
    local singleChoiceInfo = self.choiceInfo[taskID] or {}
    singleChoiceInfo.taskID = taskID
    if textLangID ~= 0 then 
        -- 记录 显示文字
        singleChoiceInfo.textLangID = textLangID
        singleChoiceInfo.roleBaseID = choiceInfoNetStream.uiRoleBaseID
        singleChoiceInfo.customModelID = choiceInfoNetStream.uiCustomModelID
        singleChoiceInfo.playerName = choiceInfoNetStream.acPlayerName
    else
        local choice = {
            choiceLangID = choiceInfoNetStream.uiChoiceLangID,
            isLocked = choiceInfoNetStream.bIsLocked == 1,
            isImportantChoice = choiceInfoNetStream.bIsImportantChoice == 1
        }
        singleChoiceInfo.choiceList = singleChoiceInfo.choiceList or {}
        table.insert(singleChoiceInfo.choiceList, choice)
    end
    self.choiceInfo[taskID] = singleChoiceInfo
end

-- 获取选项信息
function TaskDataManager:GetChoiceInfo(taskID)
    if self.choiceInfo == nil then 
        return nil
    end
    return self.choiceInfo[taskID]
end

-- 清空选项信息
function TaskDataManager:ClearChoiceInfo(taskID)
    if self.choiceInfo == nil then 
        return
    end
    self.choiceInfo[taskID] = nil
end

-- 清空选项信息
function TaskDataManager:ClearAllChoiceInfo()
    self.choiceInfo = {}
end

-- @param1:当前值
-- @param2:配置改变值
-- @param1:好感变化是否已经应用
function TaskDataManager:GetRewardFavorChangeValue(taskID, roleBaseID, curFavor, favorDelta, hasApply)
    if (curFavor == nil or favorDelta == nil or favorDelta == 0) then
        return 0
    end

    if hasApply then
        -- 如果当前值是好感度变化后的值, 需要去任务数据里面获取
        local taskData = self:GetTaskData(taskID)
        if not (taskData ~= nil and taskData.roleFinalDispositionDelta ~= nil) then 
            return 0
        end
        return taskData.roleFinalDispositionDelta[roleBaseID]
    else
        local minValue = 0
        if favorDelta > 0 then 
            minValue = 5
        else
            minValue = -5
        end
        if curFavor < 0 then 
            curFavor = -curFavor
        end
        local rate = ((100.0 - curFavor) / 100.0) + 0.2
        if favorDelta > 0 then 
            favorDelta = math.floor(favorDelta * rate + 0.5)
        else
            favorDelta = math.floor(favorDelta * rate - 0.5)
        end
    end
    return favorDelta
end

-- @param1:当前值
-- @param2:配置改变值
function TaskDataManager:GetRoleOriginFavor(curFavor, staticFavorDelta)
    -- 设原始值为 x
    -- (((100.0 - x) / 100) + 0.2) * staticFavorDelta + x = curFavor
    local originFavor = (curFavor - (1.2*staticFavorDelta)) / (1 - (0.01*staticFavorDelta))
    originFavor = math.floor(originFavor)
    return originFavor
end

function TaskDataManager:IsTaskComplete(taskID)
    local taskData = self:GetTaskData(taskID)
    if not taskData then
        return TPT_INIT
    end
    local taskProgressType = taskData['uiTaskProgressType']
    return taskProgressType == TPT_SUCCEED or taskProgressType == TPT_FAILED
end
