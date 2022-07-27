DisplayActionManager = class("DisplayActionManager")
DisplayActionManager._instance = nil
reloadModule("UI/DisplayAction")

local RunNextActionFunction = function()
    DisplayActionManager:GetInstance():RunNextAction()
end
local MAX_ACTION_PARAMS_COUNT = 200

function DisplayActionEnd()
    if DisplayActionManager._instance == nil then
        DisplayActionManager._instance = DisplayActionManager:GetInstance()
    end
    DisplayActionManager._instance.curFrameActionCount = (DisplayActionManager._instance.curFrameActionCount or 0) + 1
    if DisplayActionManager._instance.curFrameActionCount > ONE_FRAME_MAX_ACTION_COUNT then 
        displayActionEndFlag = true
    else
        DisplayActionManager._instance:RunNextAction()
    end
end

function DisplayActionManager:GetInstance()
    if DisplayActionManager._instance == nil then
        DisplayActionManager._instance = DisplayActionManager.new()
        DisplayActionManager._instance:Init()
    end

    return DisplayActionManager._instance
end

function DisplayActionManager:Init()
    self:ResetManager()
    self:InitEventListener()
    self:InitFunctionMap()
end

function DisplayActionManager:ResetManager()
    self.curFrameActionCount = 0
    self.actionList = nil
    self.isRunning = nil
    self.curAction = nil
    self.isCacheAllAction = nil
    self.actionCacheList = nil
    self.forceHideMenuLayer = nil
    self.isShowToptitle = nil
    self.toptitleType = nil
    self.isShowNavigation = nil
end

function DisplayActionManager:InitEventListener()
end

function DisplayActionManager:Update(deltaTime)
    if displayActionEndFlag then 
        displayActionEndFlag = false
        self.curFrameActionCount = 0
        self:RunNextAction()
    end
end

function DisplayActionManager:RunNextAction()
    if type(self.actionList) ~= 'table' or #self.actionList == 0 then 
        if self.isRunning then 
            self.isRunning = false
            self.curAction = nil
            if not self:HasActionCache() then 
                WaitPlotEnd()
            end
            LuaEventDispatcher:dispatchEvent("ACTION_LIST_EMPTY")
        end
        return 
    end
    if IsLoadingSceneAsync() then 
        LuaEventDispatcher:addEventListener('LoadSceneFinish', RunNextActionFunction)
        return
    end
    LuaEventDispatcher:removeEventListener('LoadSceneFinish', RunNextActionFunction)
    local action = table.remove(self.actionList, 1)
    -- FIXME: 可以合并执行的 action 不允许在执行过程中调用 DisplayActionEnd
    self:RunAction(action)
    if action.canMergeRun then 
        while #self.actionList > 0 do 
            if self.actionList[1].canMergeRun then 
                action = table.remove(self.actionList, 1)
                self:RunAction(action)
            else
                break
            end
        end
    end
end

function DisplayActionManager:RunAction(action)
    if not (action and action.actionType and self.functionMap[action.actionType]) then 
        DisplayActionEnd()
        return 
    end
    self.isRunning = true
    if DEBUG_ACTION_ENABLE then
        CheatDataManager:GetInstance():AddHistoryAction(action)
    end

    self.curAction = action
    local actionParams = action.params
    if actionParams then 
        self:ExecuteAction(action.actionType, table.unpack(actionParams, 1, actionParams.n))
    else
        self:ExecuteAction(action.actionType)
    end
end

function DisplayActionManager:ExecuteAction(actionType, ...)
    local actionFunc = self.functionMap[actionType]
    if actionFunc ~= nil then 
        actionFunc(self, ...)
    else
        DisplayActionEnd()
    end
end

-- 添加一个显示动作, 相邻的所有 canMergeRun 为 true 的动作在执行的时候会一起执行
function DisplayActionManager:AddAction(actionType, canMergeRun, ...)
    if actionType == nil then 
        return
    end
    if self.isCacheAllAction then 
        self.actionCacheList = self.actionCacheList or {}
        local cacheAction = {
            ActionType = actionType,
            CanMergeRun = canMergeRun,
            TaskID = TaskDataManager:GetInstance():GetCurTaskID(),
            Params = {...}
        }
        table.insert(self.actionCacheList, cacheAction)
        return 
    end
    local runImmadiate = false
    if not self.isRunning then 
        self.actionList = {} -- TODO: 建议改成循环队列
        self.isRunning = true
        runImmadiate = true
    end
    local index = self:GetActionListSize() + 1
    self:InsertAction(index, actionType, canMergeRun, ...)
    if self.curAction and self.curAction.canMergeRun == true and canMergeRun == true then 
        runImmadiate = true
    end 
    if runImmadiate then 
        self:RunNextAction()
    end
end

-- 在队列的指定位置插入显示动作
-- @actionType: 动作类型
-- @canMergeRun: 相邻同类型动作能否合并执行
-- @...: 动作的参数
function DisplayActionManager:InsertAction(index, actionType, canMergeRun, ...)
    local action = {}
    local actionParams = {...}
    action.actionType = actionType
    action.params = actionParams
    actionParams.n = GetTableMaxIndex(actionParams)
    action.canMergeRun = canMergeRun
    table.insert(self.actionList, index, action)
end

function DisplayActionManager:GetCurActionType()
    if type(self.curAction) ~= 'table' then 
        return nil
    end
    return self.curAction.actionType
end

-- 获取队列长度
function DisplayActionManager:GetActionListSize()
    if type(self.actionList) ~= 'table' then 
        return 0
    end
    return #self.actionList
end

function DisplayActionManager:GetActionList()
    return self.actionList
end

function DisplayActionManager:GetCurAction()
    return self.curAction
end

-- 开启缓存机制, 所有 action 都会被加入缓存, 而不是加入队列
function DisplayActionManager:CacheAllAction()
    self.isCacheAllAction = true
end

function DisplayActionManager:HasActionCache()
    return self.actionCacheList ~= nil and #self.actionCacheList > 0
end

-- 处理所有 action 的缓存并关闭缓存机制
function DisplayActionManager:ProcActionCache()
    self.isCacheAllAction = false
    if self.actionCacheList == nil then 
        return 
    end
    self.actionList = self.actionList or {}
    for index, actionCache in ipairs(self.actionCacheList) do 
        local index = self:GetActionListSize() + 1
        self:InsertAction(index, actionCache.ActionType, actionCache.CanMergeRun, table.unpack(actionCache.Params, 1, MAX_ACTION_PARAMS_COUNT))
    end
    self.actionCacheList = nil
    if not self.isRunning then 
        self:RunNextAction()
    end
end
