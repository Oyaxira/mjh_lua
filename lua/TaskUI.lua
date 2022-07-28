TaskUI = class("TaskUI",BaseWindow)

-- 变为滚动并且高度固定
local DESC_CONTENT_HEIGHT = {
    LONG = 315,
    SHORT = 210,
}

function TaskUI:Create()
	local obj = LoadPrefabAndInit("TaskUI/TaskUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TaskUI:Init()
    self.objNavigation = self:FindChild(self._gameObject,"SC_nav/Viewport/Content")
    self.comUIAction = self:FindChildComponent(self._gameObject, "SC_nav",'LuaUIAction')
    if self.comUIAction ~= nil then
        self.comUIAction:SetPointerEnterAction(function()
            g_isInScrollRect=true
        end)
        self.comUIAction:SetPointerExitAction(function()
            g_isInScrollRect=false
        end)
    end
    self.objNavTemplate = self:FindChild(self._gameObject,"SC_nav/TaskListUI")
    self.objNavPool = self:FindChild(self._gameObject,"SC_nav/TaskListPool")
    self.objNavTemplate:SetActive(false)
    self.objNavPool:SetActive(false)
    self.array_task_nav = {}
    self.array_nav_toggle = {}
    local iNacCount = self.objNavigation.transform.childCount
    for i = 1, iNacCount do
        local nav_box = self.objNavigation.transform:GetChild(i-1).gameObject
        -- 如果不是调试模式, 去除最后一个 其他 页签
        if (i == iNacCount) and (DEBUG_MODE ~= true) then
            nav_box:SetActive(false)
        else
            self.array_nav_toggle[i] = nav_box
            local comToggle = nav_box:GetComponent("Toggle")
            local objNormal = self:FindChild(nav_box, "title/normal")
            local comText = self:FindChildComponent(nav_box, "title/Text",'Text')
            comText.text = TaskDataManager:GetInstance():GetTaskTypeAbbr(i)
            self.array_task_nav[i] = self:FindChild(nav_box,"task_content")
            self.array_task_nav[i]:SetActive(false)
            self.array_task_nav[i].gameObject.name = tostring(i)
            if comToggle then
                local fun = function(bool)
                    PlayButtonSound("ButtonFold")
                    objNormal:SetActive(not bool)
                    self:ClickCategory(bool, nav_box, i)
                end
                self:AddToggleClickListener(comToggle,fun)
            end
        end
    end

    self.TaskDesc_box = self:FindChild(self._gameObject,"TaskDesc_box")
    self.comTitle_TMP = self:FindChildComponent(self.TaskDesc_box,"Image_title/TMP_title","Text")
    self.objDescContent = self:FindChild(self.TaskDesc_box,"SC_task_desc")
    self.objDescPool = self:FindChild(self.objDescContent,"TaskDescPool")
    self.objDescPool:SetActive(false)
    self.comTaskDescScroll = self.objDescContent:GetComponent("ScrollToBottom")
    self.objDescription = self:FindChild(self.objDescContent,"Viewport/Content")
    self.objDescTemplate = self:FindChild(self.objDescContent,"TaskDescUI_A")
    self.objCompleteMark = self:FindChild(self.TaskDesc_box,"Img_mark")
    self.objCompleteMark:SetActive(false)

    self.Button_trace = self:FindChildComponent(self.TaskDesc_box, "Button_trace", "Button")
    if self.Button_trace then
        self:AddButtonClickListener(self.Button_trace, function() 
            self:TraceTask()
        end)
    end

    -- self.Button_AntiJamma = self:FindChildComponent(self.TaskDesc_box, "Button_AntiJamma", "Button")
    -- if (self.Button_AntiJamma) then
    --   self:AddButtonClickListener(self.Button_AntiJamma, function() 
    --     self:AntiJamma()
    -- end)
    -- end

    self.objText_null = self:FindChild(self._gameObject,"Text_null")
    self.objText_null:SetActive(false)

    -- 奖励相关ui
    self.objBaseRewardTitle = self:FindChild(self.TaskDesc_box, "Reward1Title")
    self.objBranchRewardTitle = self:FindChild(self.TaskDesc_box, "Reward2Title")
    self.objBaseRewardBox = self:FindChild(self.TaskDesc_box, "Reward1Box_S")
    self.contentBaseRewardBox = self:FindChild(self.objBaseRewardBox, "Viewport/Content")
    self.objBaseRewardBox_Long = self:FindChild(self.TaskDesc_box, "Reward1Box_L")
    self.contentBaseRewardBox_Long = self:FindChild(self.objBaseRewardBox_Long, "Viewport/Content")
    self.objBranchRewardBox = self:FindChild(self.TaskDesc_box, "Reward2Box")
    self.contentBranchRewardBox = self:FindChild(self.objBranchRewardBox, "Viewport/Content")
    self.btnBranchRewardTips = self:FindChildComponent(self.objBranchRewardTitle, "Button", "Button")
    self:AddButtonClickListener(self.btnBranchRewardTips, function()
        self:ShowBranchRewardTips()
    end)

    self:AddEventListener("UPDATE_TASK_DATA",function() self:RefreshUI() end)
    self.taskData = nil
    self.select_nav_category = 1
    self.akItemUIClass = {}
    self.obj2ItemUIClass = {}

    -- 讨论区
    -- self.btnDiscuss = self:FindChildComponent(self.TaskDesc_box,"Button_discuss","Button")
    -- if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_TASK) then
    --     self.btnDiscuss.gameObject:SetActive(true)
    --     self:AddButtonClickListener(self.btnDiscuss, function()
    --         local taskData = TaskDataManager:GetInstance():GetTaskData(self.current_task_id)
    --         local targetId
    --         if (taskData) then
    --             targetId = taskData.uiTypeID
    --         end
    --         local articleId
    --         if (targetId) then
    --             articleId = DiscussDataManager:GetInstance():GetDiscussTitleId(ArticleTargetEnum.ART_TASK,targetId)
    --         end
    --         if (articleId == nil) then
    --             SystemUICall:GetInstance():Toast('该讨论区暂时无法进入',false)
    --         else
    --             OpenWindowImmediately("DiscussUI",articleId)
    --         end
    --     end)
    -- else
        -- self.btnDiscuss.gameObject:SetActive(false)
    -- end
    --退出ui界面按钮
    self.btnExit = self:FindChildComponent(self._gameObject, "Window_base_new/frame/Btn_exit","Button")
    self:AddButtonClickListener(self.btnExit, function()
        RemoveWindowImmediately("TaskUI")
    end)

    self.DEBUG_Fiter = self:FindChildComponent(self._gameObject, "Debug_Filter", DRCSRef_Type.InputField)
    self.DEBUG_Fiter.gameObject:SetActive(DEBUG_MODE)
    self.fliterID = ""
    if  self.DEBUG_Fiter then
        local fun = function(str)
            self.fliterID = str
            self:RefreshUI()
        end
        self.DEBUG_Fiter.onEndEdit:AddListener(fun)
    end  
end

function TaskUI:OnPressESCKey()
    if self.btnExit then
        self.btnExit.onClick:Invoke()
    end
end

function TaskUI:RefreshUI(taskID)
    -- 清空委托任务
    self.delegationTask = {}     
    self:HideAllRewardNode() 
    self.current_task_id = taskID
    if self:IsActive() == false then
        return
    end
    self:CleanTaskList()

    self.taskPool = TaskDataManager:GetInstance():GetTaskPool()
    for k,v in pairs(self.taskPool) do
        self:AddTaskToNav(v)
    end

    self:UpdateNavStatus()
    self:ExpandAvailableCategory()
    -- self:UpdateAntiJamma()
end

-- 由于连续设置isOn不能多次回调，所以要主动调用一下设置接口。
function TaskUI:ClickCategory(bool, nav_box, index)
    local objArrow = self:FindChild(nav_box, "title/arrow")
    local comText = self:FindChildComponent(nav_box, "title/TMP",'Text')
    for k = 1, #self.array_task_nav do
        if k == index then 
            self.array_task_nav[k]:SetActive(bool)
        else
            self.array_task_nav[k]:SetActive(false)
        end
    end
    if bool then
        objArrow.transform.localEulerAngles = DRCSRef.Vec3Zero
        comText.color = DRCSRef.Color(1,1,1,1)
        --objArrow.transform.localPosition = DRCSRef.Vec3(90,0,0)
        self:SetCategory(index)
    else
        objArrow.transform.localEulerAngles = DRCSRef.Vec3(0,0,90)
        comText.color = DRCSRef.Color(0.17,0.17,0.17,1)
        --objArrow.transform.localPosition = DRCSRef.Vec3(90,0,0)
    end
end

-- 任务全部加好了，更新一下按钮能否展开。
function TaskUI:UpdateNavStatus()
    for i = 1, #self.array_nav_toggle do
        local objArrow = self:FindChild(self.array_nav_toggle[i], "title/arrow")
        local comToggle = self.array_nav_toggle[i]:GetComponent("Toggle")
        if self.array_task_nav[i].transform.childCount == 0 then
            objArrow:SetActive(false)
            comToggle.isOn = false
            comToggle.interactable = false
        else
            objArrow:SetActive(true)
            comToggle.interactable = true
        end
    end
end

-- 优先展开上一次选择的标签，如果没有任务则依次检查标签
function TaskUI:ExpandAvailableCategory()
    -- 如果是从追踪任务点过来的，优先展开追踪任务的标签。
    if self.current_task_id then
        local taskData = TaskDataManager:GetInstance():GetTaskData(self.current_task_id)
        if self:CheckDisplay(self.current_task_id) then
            local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByTypeID(taskData.uiTypeID)
            self.select_nav_category = TaskDataManager:GetInstance():GetNavIndex(taskData.uiID)
        end
    end

    local comToggle = self.array_nav_toggle[self.select_nav_category]:GetComponent("Toggle")
    local index
    if comToggle.interactable == true then
        index = self.select_nav_category
    else
        for i = 1, #self.array_nav_toggle do
            local toggle = self.array_nav_toggle[i]:GetComponent("Toggle")
            if toggle.interactable == true then
                comToggle = toggle
                index = i
            end
        end
    end

    if index then
        if comToggle.isOn == true then
            self:ClickCategory(true, comToggle.gameObject, index)
        else
            comToggle.isOn = true
        end
        return
    end

    -- 循环结束还没有找到可以展开的标签，则需要显示暂无任务
    self.objText_null:SetActive(true)
    self.TaskDesc_box:SetActive(false)
end

-- function TaskUI:UpdateAntiJamma()
--   if (self:IsCanAntiJamma()) then
--     self.Button_AntiJamma.gameObject:SetActive(true)
--   else
--     self.Button_AntiJamma.gameObject:SetActive(false)
--   end
-- end

-- 选中一个分类，加载分类数据
function TaskUI:SetCategory(groupID)
    dprint("当前选中的分类是:",groupID)
    self.select_nav_category = groupID

    -- 已完成分类显示 已完成图标【TODO：如果任务是失败的，应该显示失败图标】
    if groupID == 6 then
        self.objCompleteMark:SetActive(true)
        self.Button_trace.gameObject:SetActive(false)
        SetUIAxis(self.objDescContent, nil, DESC_CONTENT_HEIGHT.SHORT)
    elseif groupID == 5 then
        -- 委托类任务不显示追踪
        self.objCompleteMark:SetActive(false)
        self.Button_trace.gameObject:SetActive(false)
        SetUIAxis(self.objDescContent, nil, DESC_CONTENT_HEIGHT.LONG)
    else
        self.objCompleteMark:SetActive(false)
        self.Button_trace.gameObject:SetActive(true)
        SetUIAxis(self.objDescContent, nil, DESC_CONTENT_HEIGHT.SHORT)
    end



    local objTransform = self.array_task_nav[groupID].transform
    if not objTransform then return end

    -- 标签逻辑：先选中 self.current_task_id，再选中分类下第一个任务
    local taskGroup = nil
    local chooseTaskID
    local chooseToggle
    if objTransform.childCount > 0 then
        local node =  nil
        if self.current_task_id ~= nil then
            node = DRCSRef.CommonFunction.StoreUI_GetNodeByID(objTransform,"ID",self.current_task_id)
        end
        if node then
            chooseTaskID = self.current_task_id
            chooseToggle = node:GetComponent("Toggle")
            taskGroup = node:GetUIntDataInGameObject('TaskGroup')
        else
            local objNavChild = objTransform:GetChild(0)
            if objNavChild then
                chooseTaskID =  GetUIntDataInGameObject(objNavChild, 'ID')
                taskGroup = GetUIntDataInGameObject(objNavChild, 'TaskGroup')
                chooseToggle = objNavChild:GetComponent("Toggle")
            end
        end
    end

    -- 选中任务，注意要触发 OnValueChanged
    if not chooseToggle then return end
    if chooseToggle.isOn == true then
        self:HideAllRewardNode()
        if taskGroup and taskGroup ~= 0 then
            self:SetDelegationTaskData(taskGroup)
        else
            self:SetTaskData(chooseTaskID)
        end
    else
        chooseToggle.isOn = true
    end
end

function TaskUI:HideAllRewardNode()
    self.objBaseRewardTitle:SetActive(false)
    self.objBaseRewardBox:SetActive(false)
    self.objBaseRewardBox_Long:SetActive(false)
    self.objBranchRewardTitle:SetActive(false)
    self.objBranchRewardBox:SetActive(false)
end

-- 加载一个委托组所有的任务数据，包括名称、描述、节点列表、奖励
function TaskUI:SetDelegationTaskData(taskGroup)
    if taskGroup == nil then
        return 
    end
    local taskNameLangID = TaskGroup_Lang[taskGroup] or 0
    if self.delegationTask[taskNameLangID] == nil then
        return 
    end
    -- 更新任务名称
    self:UpdateTaskDetailName(nil, taskNameLangID)
    -- 清理一下之前的条目
    self:CleanTaskDesc()
    for _, taskID in ipairs(self.delegationTask[taskNameLangID]) do 
        -- 加载任务阶段描述
        self:AddDesc(taskID, true, true)
    end
    -- 刷新高度
    self:ForceRebuildObjLayout(self.objDescription)
end

-- 加载一个任务数据，包括名称、描述、节点列表、奖励
function TaskUI:SetTaskData(taskID)
    local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
    local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByID(taskID)
    if taskData == nil or taskTypeData == nil then 
        return 
    end
    -- 记录一下当前的任务，方便跟踪
    self.current_task_id = taskID

    -- 更新任务名称
    self:UpdateTaskDetailName(taskID)

    -- 清理一下之前的条目
    self:CleanTaskDesc()

    -- 先加载任务描述
    local taskDescID = taskTypeData['TaskDescID']
    if taskDescID and (taskDescID > 0) then
        self:AddDescEntry(self.current_task_id, taskDescID)
    end
    
    -- 加载任务阶段描述
    self:AddDesc(taskID)

    -- 设置任务奖励
    self:SetTaskReward(taskID)

    -- 刷新高度
    self:ForceRebuildObjLayout(self.objDescription)

    -- 将描述置为底部
    self.comTaskDescScroll.Position = 0
end

-- 更新任务详情任务名称
function TaskUI:UpdateTaskDetailName(taskID, nameLangID)
    self.TaskDesc_box:SetActive(true)
    self.objText_null:SetActive(false)
    local taskInfo = ''
    if nameLangID == nil then 
        local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
        local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByID(taskID)
        if taskData ~= nil and taskTypeData ~= nil then 
            nameLangID = taskTypeData['NameID']
            if DEBUG_MODE then
                -- 如果是pc平台, 跟上id
                taskInfo = string.format(" %d[%d] - %d", taskData.uiTypeID, taskID or 0, taskData.uiTaskState)
            end
        end
    end
    local strName = string.format("%s", GetLanguageByID(nameLangID, taskID)) .. taskInfo
    self.comTitle_TMP.text = strName
end

function TaskUI:CleanTaskDesc()
    for i = self.objDescription.transform.childCount, 1, -1 do
        local objTaskDescUI = self.objDescription.transform:GetChild(i -1)
        objTaskDescUI:SetParent(self.objDescPool.transform)
    end
end

-- 获取List缓存
function TaskUI:GetTaskDescUI()
    local childCount = self.objDescPool.transform.childCount
    if childCount > 0 then
        local obj = self.objDescPool.transform:GetChild(0)
        obj:SetParent(self.objDescription.transform)
        return obj.gameObject
    else
        local ui_clone = CloneObj(self.objDescTemplate, self.objDescription)
        if (ui_clone ~= nil) then
            ui_clone:SetActive(true)
        end
        return ui_clone
    end
end

-- 强制刷新对象的高度
function TaskUI:ForceRebuildObjLayout(obj)
    if not obj then
        return
    end
    local rectTrans = obj:GetComponent("RectTransform")
    if not rectTrans then
        return
    end
    if not self.funcRebuild then
        self.funcRebuild = CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate
    end
    self.funcRebuild(rectTrans)
end

-- 添加一个描述条目
-- @ descID (int) 描述ID
-- @ descState (TDST_) 描述对应状态
function TaskUI:AddDescEntry(taskID, descID, descState, showTaskReward, showGiveUpButton)
    if not (taskID and (taskID > 0) and descID and (descID > 0)) then
        return
    end
    local str = TaskDataManager:GetInstance():GetDescByState(taskID, descID, descState)
    local type = TaskDataManager:GetInstance():GetTypeByDescID(descID)
    local ui_desc = self:GetTaskDescUI()
    local objTaskStatus = self:FindChild(ui_desc, "Desc/Task_status")
    local objNormal = self:FindChild(objTaskStatus,"Img_normal")
    local objSuccess = self:FindChild(objTaskStatus,"Img_succ")
    local objFail = self:FindChild(objTaskStatus,"Img_fail")
    local objDescReward = self:FindChild(ui_desc, "Reward")
    objNormal:SetActive(false)
    objSuccess:SetActive(false)
    objFail:SetActive(false)
    objDescReward:SetActive(false)

    local objDesc = self:FindChild(ui_desc, "Desc")
    local comTaskText = objDesc:GetComponent("Text")
    ui_desc:SetActive(true)
    if type == TaskDescType.TDT_qiyin or type == TaskDescType.TDT_jieju then
            -- 起因和结局不用显示 前面的圆圈
    else    -- 要显示圆圈，勾和叉 根据 descState 判断
        if descState == TaskDescStatesType.TDST_jinxingzhong then
            objNormal:SetActive(true)
        elseif descState == TaskDescStatesType.TDST_yiwancheng then
            objSuccess:SetActive(true)
        elseif descState == TaskDescStatesType.TDST_yishibai then
            objFail:SetActive(true)
        elseif descState == TaskDescStatesType.TDST_yincang then
            str = "？？？？？？"
        end
    end
    comTaskText.text = str
    if showTaskReward then
        objDescReward:SetActive(true)
        self:SetDelegateTaskReward(taskID, objDescReward)
    end
    if showGiveUpButton then
        -- TODO: 显示放弃按钮 
    end

    -- 刷新高度
    self:ForceRebuildObjLayout(objDesc)
    self:ForceRebuildObjLayout(ui_desc)
end

-- 添加描述到 任务面板
function TaskUI:AddDesc(taskID, showTaskReward, showGiveUpButton)
    local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
    local taskTypeData = TableDataManager:GetInstance():GetTableData("Task", taskData.uiTypeID)
    local taskProgressType = taskData['uiTaskProgressType']

    if taskProgressType == TPT_SUCCEED or taskProgressType == TPT_FAILED then
        self:AddCompleteDesc(taskData, showTaskReward, showGiveUpButton)
    else    -- 未完成任务，需要对描述进行排序
        local desc_tab_toshow = TaskDataManager:GetInstance():GetDescShowData(taskData)
        self:AddNormalDesc(taskData.uiID, desc_tab_toshow, showTaskReward, showGiveUpButton)
    end
end

function TaskUI:AddCompleteDesc(taskData, showTaskReward, showGiveUpButton)
    -- 完成任务的话只要显示结局描述，包括成功 和 失败
    local endDesc = TaskDataManager:GetInstance():GetEndingDescState(taskData.uiID)
    if endDesc then
        local descID = endDesc.uiDescID
        local descState = endDesc.uiDescState
        self:AddDescEntry(taskData.uiID, descID, descState, showTaskReward, showGiveUpButton)
    end
end

-- 将任务条目显示在面板上,进行渲染
function TaskUI:AddNormalDesc(taskID, desc_tab_toshow, showTaskReward, showGiveUpButton)
    for i = 1, #desc_tab_toshow do
        local desc_tab = desc_tab_toshow[i]
        self:AddDescEntry(taskID, desc_tab['uiDescID'], desc_tab['uiDescState'], showTaskReward, showGiveUpButton)
    end
end

-- 
function TaskUI:GetTaskInfo(taskID)
    local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
    local edgeIds = {}
    local tips = string.format("作弊指令所需ID：%d\n 任务编辑器ID：%d\n 当前状态ID：%d\n当前状态出边数：", taskData.uiID, taskData.uiTypeID, taskData.uiTaskState)
    local cnt = 0

    local taskEdgeTable = TableDataManager:GetInstance():GetTable("TaskEdge")
    for taskEdgeId, taskEdgeData in pairs(taskEdgeTable) do
        if taskEdgeData.StateID == taskData.uiTaskState then
            cnt = cnt + 1
        end
    end
    tips = tips .. cnt
    return tips
end

-- 将任务加入分类栏
function TaskUI:AddTaskToNav(taskData)
    if not taskData then 
        return 
    end

    -- 任务筛选
    if DEBUG_MODE and self.fliterID ~= "" and tonumber(self.fliterID) ~= taskData.uiTypeID then
        return
    end

    local taskID = taskData.uiID
    local taskTypeData = TableDataManager:GetInstance():GetTableData("Task", taskData.uiTypeID)

    local taskProgressType = taskData['uiTaskProgressType']
    local nav_index = TaskNav.ZhuXian

    if taskProgressType == TPT_SUCCEED or taskProgressType == TPT_FAILED then
        if self:CheckDisplay(taskID, true) then
            nav_index = TaskNav.YiWanCheng
        else
            return
        end
    elseif self:CheckDisplay(taskID) then
        nav_index = TaskDataManager:GetInstance():GetNavIndex(taskID)
    elseif DEBUG_MODE then
        --测试代码
        nav_index = TaskNav.QiTa
    else
        return
    end

    local taskGroupLangID = 0
    if nav_index == TaskNav.WeiTuo then
        local taskGroup = taskData.uiTaskGroup
        taskGroupLangID = TaskGroup_Lang[taskGroup]
        if taskGroupLangID then 
            self.delegationTask[taskGroupLangID] = self.delegationTask[taskGroupLangID] or {}
            table.insert(self.delegationTask[taskGroupLangID], taskID)
            if #self.delegationTask[taskGroupLangID] > 1 then
                return 
            end
        end
    end

    -- 开始 clone 节点，给节点记上 int
    local ui_clone = self:GetTaskListUI(self.array_task_nav[nav_index])
    local comToggleGroup = self.array_task_nav[nav_index]:GetComponent("ToggleGroup")
    local comTaskText = self:FindChildComponent(ui_clone, "Text_task", "Text")
    local comToggle = ui_clone:GetComponent("Toggle")
    local objImage = self:FindChild(ui_clone, "Image")

    if comToggle then
        comToggle.group = comToggleGroup
        local fun = function(bool)
            self:HideAllRewardNode()
            objImage:SetActive(not bool)
            if bool then
                comTaskText.color = DRCSRef.Color(1,1,1,1)
                if nav_index == TaskNav.WeiTuo then
                    -- 委托任务
                    self:SetDelegationTaskData(taskData.uiTaskGroup)
                else
                    -- 其他任务
                    self:SetTaskData(taskID)
                    if (DEBUG_MODE) then
                        -- SystemTipManager:GetInstance():AddPopupTip( self:GetTaskInfo(taskID) )    -- 不需要了，直接显示在标题栏即可
                    end
                end
            else
                comTaskText.color = DRCSRef.Color(0.24,0.24,0.24,1)
            end
        end
        self:RemoveToggleClickListener(comToggle)
        self:AddToggleClickListener(comToggle, fun)
    end

    local nameID = 0
    if nav_index == TaskNav.WeiTuo then
        nameID = taskGroupLangID
    else
        nameID = taskTypeData['NameID']
    end    
    comTaskText.text = GetLanguageByID(nameID, taskID)
    -- 将 taskID 绑定到节点上，点击的时候，读取当前选择ID
    SetUIntDataInGameObject(ui_clone, 'ID', taskID)
    if nav_index == TaskNav.WeiTuo then
        SetUIntDataInGameObject(ui_clone, 'TaskGroup', taskData.uiTaskGroup)
    else
        SetUIntDataInGameObject(ui_clone, 'TaskGroup', 0)
    end
    local objClock = self:FindChild(ui_clone,"Image_clock")
    if self:CheckTimer(taskTypeData) then
        objClock:SetActive(true)
    else
        objClock:SetActive(false)
    end
end

-- 清理List缓存
function TaskUI:CleanTaskList()
    for i = 1, #self.array_task_nav do
        for j = self.array_task_nav[i].transform.childCount, 1, -1 do
            local objTaskListUI =  self.array_task_nav[i].transform:GetChild(j - 1)
            objTaskListUI:SetParent(self.objNavPool.transform)
            local comTaskListToggle = objTaskListUI:GetComponent("Toggle")
            if comTaskListToggle then
                comTaskListToggle.group = nil
                comTaskListToggle.onValueChanged:RemoveAllListeners()
            end
        end
    end
end

-- 获取List缓存
function TaskUI:GetTaskListUI(parent)
    local childCount = self.objNavPool.transform.childCount
    if childCount > 0 then
        local obj = self.objNavPool.transform:GetChild(0)
        obj:SetParent(parent.transform)
        obj.gameObject:SetActive(true)
        return obj.gameObject
    else
        local ui_clone = CloneObj(self.objNavTemplate, parent)
        if (ui_clone ~= nil) then
            ui_clone:SetActive(true)
        end
        return ui_clone
    end
end

-- todo: 加上计时器
function TaskUI:CheckTimer(taskTypeData)
    return false
end

-- 检查是否要显示在面板上：面板显示，且 （没有完成后移除，或者没有完成）
function TaskUI:CheckDisplay(taskID, boolean_complete)
    local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
    local taskTypeData = TableDataManager:GetInstance():GetTableData("Task", taskData.uiTypeID)

    if not (taskData and taskTypeData) then 
        return false
    end

    -- 1. 任务配置了正确的任务类型，非无效任务
    if taskData.uiTaskGroup == 0 and ((taskTypeData.Type == TaskType.TT_wuxiao) or (taskTypeData.Type == TaskType.TaskType_NULL)) then 
        return false
    end

    -- 2. 任务配置了面板显示，并且对于 "已完成"/ "已失败" 的任务, 如果任务拥有 [任务完成时从面板移除] 的特性, 则不在任务面板上显示该任务
    local flags = taskTypeData.SpecialFlag
    if not flags then 
        return false 
    end
    local display = false
    for k,v in pairs(flags) do
        if v == TaskFlag.TF_mianban then
            display = true
        elseif boolean_complete and (v == TaskFlag.TF_wanchengyichu) then
            return false
        end
    end

    -- 3. 正在进行中的任务，至少有一条任务描述被开启
    if not boolean_complete then
        local desc_to_show = TaskDataManager:GetInstance():GetDescShowData(taskData)
        if next(desc_to_show) == nil then
            return false
        end
    end

    -- 4. 当前状态不为0
    if not boolean_complete and taskData.uiTaskState == 0 then
        return false
    end

    return display
end

-- 设置一个任务的奖励
function TaskUI:SetTaskReward(taskID)
    if not taskID then
        return
    end
    -- 获取数据
    local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
    local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByID(taskID)
    if not (taskData and taskTypeData) then 
        return 
    end
    local isTaskComplete = taskData['uiTaskProgressType'] == TPT_SUCCEED or taskData['uiTaskProgressType'] == TPT_FAILED
    -- 奖励状态
    local rewardDataList = TaskDataManager:GetInstance():ParseAllToRewardList(taskID, true)
    local bHasBaseReward = (rewardDataList ~= nil) and (#rewardDataList > 0)
    local branchRewards = taskTypeData.TaskBranchRewards
    local bHasBranchReward = (branchRewards ~= nil) and (#branchRewards > 0)
    -- ui初始化
    self.objBaseRewardTitle:SetActive(bHasBaseReward)
    self.objBaseRewardBox:SetActive(bHasBaseReward and bHasBranchReward)
    self.objBaseRewardBox_Long:SetActive(bHasBaseReward and (not bHasBranchReward))
    self.objBranchRewardTitle:SetActive(bHasBranchReward)
    self.objBranchRewardBox:SetActive(bHasBranchReward)
    local objBaseRewardContent = bHasBranchReward and self.contentBaseRewardBox or self.contentBaseRewardBox_Long

    self:ReturnAllTaskItemIcon()

    -- 普通奖励
    if bHasBaseReward then
        for k = 1, #rewardDataList do
            self:AddRewardIcon(rewardDataList[k], objBaseRewardContent, nil, isTaskComplete)
        end
    end

    -- 分支奖励
    if bHasBranchReward then
        local rewardDataList = nil
        local taskMgr = TaskDataManager:GetInstance()
        for i = 1, #branchRewards do
            rewardDataList = taskMgr:ParseTaskReward(branchRewards[i], taskID, true)
            if rewardDataList and (#rewardDataList > 0) then
                for k = 1, #rewardDataList do
                    self:AddRewardIcon(rewardDataList[k], nil, self.contentBranchRewardBox, isTaskComplete)
                end
            end
        end
    end
end

-- !FIXME 钱程 这里暂时将委托任务的逻辑从原来的散落的地方整理到一块了
-- !但是还是存在每次刷新都会FindChild的问题, 之后改成工厂类产生节点与类实例绑定的数据以复用
function TaskUI:SetDelegateTaskReward(taskID, objDelegateTaskReward)
    if not (taskID and objDelegateTaskReward) then
        return
    end
    -- 获取数据
    local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
    local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByID(taskID)
    if not (taskData and taskTypeData) then 
        return 
    end
    -- ui获取
    kRewardBoxes = kRewardBoxes or {}
    local objBaseRewardTitle = self:FindChild(objDelegateTaskReward, "BaseRewardTitle")
    local objBaseRewardBox = self:FindChild(objDelegateTaskReward, "BaseRewardBox_S")
    local contentBaseReward = self:FindChild(objBaseRewardBox, "Viewport/Content")
    local objBaseRewardBox_Long = self:FindChild(objDelegateTaskReward, "BaseRewardBox_L")
    local contentBaseReward_Long = self:FindChild(objBaseRewardBox_Long, "Viewport/Content")
    local objBranchRewardTitle = self:FindChild(objDelegateTaskReward, "BranchRewardTitle")
    local objBranchRewardBox = self:FindChild(objDelegateTaskReward, "BranchRewardBox")
    local contentBranchReward = self:FindChild(objBranchRewardBox, "Viewport/Content")
    -- 奖励状态
    local rewardDataList = TaskDataManager:GetInstance():ParseAllToRewardList(taskID, true)
    local bHasBaseReward = (rewardDataList ~= nil) and (#rewardDataList > 0)
    local branchRewards = taskTypeData.TaskBranchRewards
    local bHasBranchReward = (branchRewards ~= nil) and (#branchRewards > 0)
    -- ui初始化
    objBaseRewardTitle:SetActive(bHasBaseReward)
    objBaseRewardBox:SetActive(bHasBaseReward and bHasBranchReward)
    objBaseRewardBox_Long:SetActive(bHasBaseReward and (not bHasBranchReward))
    objBranchRewardTitle:SetActive(bHasBranchReward)
    objBranchRewardBox:SetActive(bHasBranchReward)
    local objBaseRewardContent = bHasBranchReward and contentBaseReward or contentBaseReward_Long

    self:ReturnAllChildrenTaskItemIcon(objBaseRewardContent.transform)
    self:ReturnAllChildrenTaskItemIcon(contentBranchReward.transform)

    local isTaskComplete = taskData['uiTaskProgressType'] == TPT_SUCCEED or taskData['uiTaskProgressType'] == TPT_FAILED
    -- 普通奖励
    if bHasBaseReward then
        for k = 1, #rewardDataList do
            self:AddRewardIcon(rewardDataList[k], objBaseRewardContent, nil, isTaskComplete)
        end
    end

    -- 分支奖励
    if bHasBranchReward then
        local rewardDataList = nil
        local taskMgr = TaskDataManager:GetInstance()
        for i = 1, #branchRewards do
            rewardDataList = taskMgr:ParseTaskReward(branchRewards[i], taskID)
            if rewardDataList and (#rewardDataList > 0) then
                for k = 1, #rewardDataList do
                    self:AddRewardIcon(rewardDataList[k], nil, contentBranchReward, isTaskComplete)
                end
            end
        end
    end
end

function TaskUI:ReturnAllTaskItemIcon()
    if #self.akItemUIClass > 0 then
        LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
        self.akItemUIClass = {}
        self.obj2ItemUIClass = {}
    end
end

function TaskUI:ReturnAllChildrenTaskItemIcon(kTransParent)
    if not (kTransParent and self.akItemUIClass 
    and self.obj2ItemUIClass and self.obj2ItemUIClass[kTransParent]) then
        return
    end
    -- 归还子节点并产生检查数据
    local aInst2Remove = self.obj2ItemUIClass[kTransParent]
    local removeCheck = {}
    for index, inst in ipairs(aInst2Remove) do
        removeCheck[inst] = true
        LuaClassFactory:GetInstance():ReturnUIClass(inst)
    end
    self.obj2ItemUIClass[kTransParent] = nil
    -- 先从实例数组中移除子节点对应的实例
    local inst = nil
    for index = #self.akItemUIClass, 1, -1 do
        inst = self.akItemUIClass[index]
        if removeCheck[inst] == true then
            table.remove(self.akItemUIClass, index)
        end
    end
end

function TaskUI:CreateTaskItemIcon(kRewardData, kTransParent, isTaskComplete)
    if not (kRewardData and kTransParent) then
        return
    end
    local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.TaskItemIconUI, kTransParent)
    kIconBindData:UpdateUI(kRewardData, isTaskComplete)
    self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
    if not self.obj2ItemUIClass[kTransParent] then
        self.obj2ItemUIClass[kTransParent] = {}
    end
    self.obj2ItemUIClass[kTransParent][#self.obj2ItemUIClass[kTransParent] + 1] = kIconBindData
	return kIconBindData
end

-- 添加一个物品图标到任务奖励中
function TaskUI:AddRewardIcon(rewardData, objBaseRewardBox, objBranchRewardBox, isTaskComplete)
    if not rewardData then 
        return 
    end
    local kTransParent = nil
    if objBranchRewardBox then
        kTransParent = objBranchRewardBox.transform
    elseif objBaseRewardBox then
        kTransParent = objBaseRewardBox.transform
    end
    if not kTransParent then
        return
    end
    local kIconBindData = self:CreateTaskItemIcon(rewardData, kTransParent, isTaskComplete)
    return kIconBindData._gameObject
end

-- 显示分支奖励提示
function TaskUI:ShowBranchRewardTips()
    local tips = {}
    tips.title = "分支奖励"
    tips.kind = "wide"
    tips.content = "根据任务中的分支选项, 可获得其中的部分或全部奖励"
    OpenWindowImmediately("TipsPopUI", tips)
end

function TaskUI:OnEnable()
    -- OpenWindowBar({
    --     ['windowstr'] = "TaskUI", 
    --     ['titleName'] = "任务",
    --     ['topBtnState'] = {  --决定顶部栏资源显示状态
    --         ['bBackBtn'] = true,
    --     },
    --     ['bSaveToCache'] = true, 
    --     ['callback'] = function()
    --         self:AddTimer(200,function()
    --             GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_AnimEnd,'TaskUI')
    --         end )
    --     end,
    -- })
    -- 打开对话控制界面
	-- if not IsWindowOpen("DialogControlUI") then
	-- 	OpenWindowImmediately("DialogControlUI")
	-- end
end

function TaskUI:OnDisable()
    self:ReturnAllTaskItemIcon()
    RemoveWindowBar('TaskUI')
    -- 关闭对话控制界面
	if IsWindowOpen("DialogControlUI") then
		RemoveWindowImmediately("DialogControlUI")
    end
    -- 关闭对话记录界面
    if IsWindowOpen("DialogRecordUI") then
        RemoveWindowImmediately("DialogRecordUI")
    end
end

-- 追踪任务
function TaskUI:TraceTask()
    globalDataPool:setData("TraceTask", self.current_task_id, true)
    local win = GetUIWindow("TaskTipsUI")
    if win then
        win:RefreshUI()
    end
    
    RemoveWindowImmediately("TaskUI")
end

-- function TaskUI:AntiJamma()
--   if (self:IsCanAntiJamma() == false) then
--     SystemTipManager:GetInstance():AddPopupTip("您已经使用过防卡住机制了，本次测试期间无法再次使用")
--     return
--   end
--   local strTips = '是否跳过所有任务，直接进入大决战？\n这是解决主线任务卡住的临时功能，本次测试期间仅可使用一次，正式运营时不会保留此功能。\n如有疑问，请加入官方Q群1061471593咨询客服。'
--   OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strTips, function()
--     local data = EncodeSendSeGC_ClickFinalBattleAntiJamma(1)
--     local iSize = data:GetCurPos()
--     NetGameCmdSend(SGC_CLICK_FINALBATTLE_ANTIJAMMA,iSize,data)
--   end})
-- end


-- function TaskUI:IsCanAntiJamma()
--   -- 首先判断剧本是否正确
--   local iCurScriptID = GetCurScriptID()
-- 	if iCurScriptID == nil or (iCurScriptID ~= 2) then
-- 		return false
--   end
--   -- 再判断是否已经使用过了
--   local info = FinalBattleDataManager:GetInstance():GetInfo()
--   if (info and info.iAntiJammaCount and info.iAntiJammaCount >= 1) then
--     return false
--   end

--   return true
-- end

function TaskUI:OnDestroy()
    self:ReturnAllTaskItemIcon()
end

return TaskUI