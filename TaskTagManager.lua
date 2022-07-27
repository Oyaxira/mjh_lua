TaskTagManager = class("TaskTagManager")
TaskTagManager._instance = nil

function TaskTagManager:GetInstance()
    if TaskTagManager._instance == nil then
        TaskTagManager._instance = TaskTagManager.new()
    end

    return TaskTagManager._instance
end

function TaskTagManager:ResetManager()
    self.taskTagPool = nil
end

function TaskTagManager:GetTag(uiTypeID)
    if self.taskTagPool == nil then 
        return nil
    end
    for tagID, tagData in pairs(self.taskTagPool) do
        if tagData.uiTypeID == uiTypeID then
            return tagData.uiValue
        end
    end
end

function TaskTagManager:GetAllTagList(uiTypeID)
    if self.taskTagPool == nil then 
        return {}
    end
    local allTagList = {}
    for tagID, tagData in pairs(self.taskTagPool) do
        table.insert(allTagList, tagData)
    end
    return allTagList
end

function TaskTagManager:SetTag(uiTypeID, uiValue)
    local clickSetTag = EncodeSendSeGC_ClickCheat(CHET_TASKTAG_SET, uiTypeID, uiValue)
    local iSize = clickSetTag:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CHEAT,iSize,clickSetTag)
end

-- <struct Name="TaskTagData" Comment="任务标识">
-- <member Name="uiID" Type="DWord" InitValue="0" Comment="标识唯一ID"/>
-- <member Name="uiTypeID" Type="DWord" InitValue="0" Comment="标识TypeID"/>
-- <member Name="uiValue" Type="DWord" InitValue="0" Comment="标识值"/>
-- </struct>

-- 服务器下行：更新全部任务标识
function TaskTagManager:UpdateTaskTagByArray(TaskTagDataArray, arraySize)
    if not (TaskTagDataArray and arraySize) then 
        return
    end
    if self.taskTagPool == nil then 
        self.taskTagPool = {}
    end
    for i = 1, arraySize do 
        local taskTagData = TaskTagDataArray[i - 1]
        local uiID = taskTagData.uiID
        if taskTagData.uiValue == 0 then
            self.taskTagPool[uiID] = nil
        else
            self.taskTagPool[uiID] = taskTagData
        end
    end
    self:DispatchUpdateEvent()
end

-- 服务器下行：删除任务标识
function TaskTagManager:DeleteTaskTagData(taskTagID)
    if self.taskTagPool == nil then 
        return
    end
    if self.taskTagPool[taskTagID] then 
        self.taskTagPool[taskTagID] = nil
        self:DispatchUpdateEvent()
    end
end

-- 取任务tag值
function TaskTagManager:GetTaskTagValueByTypeID(typeID)
    if self.taskTagPool == nil then 
        return nil
    end
    for tagID, tagData in pairs(self.taskTagPool) do
        if (tagData.uiTypeID == typeID) then
            return tagData.uiValue
        end
    end

    return nil
end

function TaskTagManager:DispatchUpdateEvent()
    LuaEventDispatcher:dispatchEvent("UPDATE_TASKTAG_DATA")
end

-- 【ID1027978】 1406 == 1 表示正在新手村阶段
function TaskTagManager:IsNewVillageState()
    local uiValue = self:GetTag(1406) 
    if uiValue and uiValue == 1 then
        return true
    else
        return false
    end
end


function TaskTagManager:TagIsValue(tagID,value)
    local uiValue = self:GetTag(tagID) 
    if uiValue and uiValue == value then
        return true
    else
        return false
    end
end