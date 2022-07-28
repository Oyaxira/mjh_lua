TaskCompleteUI = class("TaskCompleteUI",BaseWindow)

function TaskCompleteUI:ctor()
    self.mailbox = {}
end

function TaskCompleteUI:Create()
	local obj = LoadPrefabAndInit("TaskUI/TaskCompleteUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function TaskCompleteUI:OnPressESCKey()
    if self.comBG_Button then
        self.comBG_Button.onClick:Invoke()
    end
end

function TaskCompleteUI:Init()
    -- 顶部
    self.comTitleText = self:FindChild(self._gameObject, "newFrame/Title","Text")
    self.objTitle_complete = self:FindChild(self._gameObject, "title_complete")
    self.objTitle_failed = self:FindChild(self._gameObject, "title_failed")

    -- 背景
    self.comBG_Button = self:FindChildComponent(self._gameObject, "BG_black","Button")
    if self.comBG_Button then
        local fun = function()
			self:Onclick_Continue()
        end
        self:AddButtonClickListener(self.comBG_Button,fun)
    end
    
    -- 起因与结局
    self.comTitle = self:FindChildComponent(self._gameObject, "Title", "Text")
    self.comCause = self:FindChildComponent(self._gameObject, "SC_desc/Viewport/Content/cause", "Text")
    self.comResult = self:FindChildComponent(self._gameObject, "SC_desc/Viewport/Content/result", "Text")

    -- 奖励
    self.objReward_back = self:FindChild(self._gameObject, "reward_back")
    self.objBranch_reward_back = self:FindChild(self._gameObject, "branch_reward_back")
    self.objReward_TMP = self:FindChild(self._gameObject, "TMP_reward")
    self.objBranch_reward_TMP = self:FindChild(self._gameObject, "TMP_reward_2")
    self.objReward = self:FindChild(self._gameObject, "Reward_S")
    self.contentReward = self:FindChild(self.objReward, "Viewport/Content")
    self.objReward_L = self:FindChild(self._gameObject, "Reward_L")
    self.contentReward_L = self:FindChild(self.objReward_L, "Viewport/Content")
    self.objReward2 = self:FindChild(self._gameObject, "Reward_2")
    self.contentReward2 = self:FindChild(self.objReward2, "Viewport/Content")

    -- 右下
    self.objMark_box = self:FindChild(self._gameObject, "mark_box")
    self.objMark_light = self:FindChild(self.objMark_box, "light")
    self.objMark_succeed = self:FindChild(self.objMark_box, "succeed")
    self.objMark_failed = self:FindChild(self.objMark_box, "failed")
    self.comSucceed_DOTween = self.objMark_succeed:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
    self.comFailed_DOTween = self.objMark_failed:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))

    self.akItemUIClass = {}
end

function TaskCompleteUI:Enqueue(taskInfo)
    -- 将当前任务、任务是否完成、失败描述 加入队列
    table.insert(self.mailbox, taskInfo)
end

-- 返回出队第一项
function TaskCompleteUI:Dequeue( )
    if #self.mailbox <= 0 then return nil end
    return table.remove(self.mailbox, 1)
end

function TaskCompleteUI:Onclick_Continue()
    if #self.mailbox == 0 then
        self:Exit()
    else    -- 跳过当前，检查下一个
        self.boolean_showing = false
        self:UpdateDisplay()
    end
end

function TaskCompleteUI:Exit()
    self.boolean_showing = false
    self:ReturnAllTaskItemIcon()
    RemoveWindowImmediately("TaskCompleteUI")
    DisplayActionEnd()
end

function TaskCompleteUI:RefreshUI(taskInfo)
    if taskInfo then
        self:Enqueue(taskInfo)
    end
    self:UpdateDisplay()    -- 测试

    -- 显示任务完成的时候, 关闭快进对话模式
	DialogRecordDataManager:GetInstance():SetFastChatState(false)
end

-- 根据任务成功、失败，初始化UI界面
function TaskCompleteUI:UpdateDisplay()
    if self.boolean_showing then return end
    self.boolean_showing = true
    
    local taskInfo = self:Dequeue()
    if not taskInfo then
        self.boolean_showing = false
        self:Exit()
        return
    end

    local taskID = taskInfo.uiID
    local taskData = TaskDataManager:GetInstance():GetTaskData(taskID)
    if not taskData then
        self.boolean_showing = false
        self:Exit()
        return
    end

    local suc = taskInfo.uiTaskProgressType == 1
    local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByID(taskID)
    local display = false
    if taskTypeData then 
        local flags = taskTypeData.SpecialFlag
        if flags then       
            for k,v in pairs(flags) do
                if v == TaskFlag.TF_mianban then
                    display = true
                    break
                end
            end
        end
    end
    if not display then
        self.boolean_showing = false
        self:Exit()
        return
    end

    -- 标题
    local titleStr = suc and "任务成功" or "任务失败"
    self.comTitleText = titleStr
    -- self.objTitle_complete:SetActive(suc)
    -- self.objTitle_failed:SetActive(not suc)

    -- 右下
    self.objMark_light:SetActive(suc)
    self.objMark_succeed:SetActive(suc)
    self.objMark_failed:SetActive(not suc)

    -- 奖励
    local bHasNormalRewards = (taskTypeData.TaskRewards and next(taskTypeData.TaskRewards)) or (taskTypeData.TaskNormalRewards and next(taskTypeData.TaskNormalRewards))
    local bHasBranchRewards = taskTypeData.TaskBranchRewards and next(taskTypeData.TaskBranchRewards)
    self.objReward_back:SetActive(bHasNormalRewards and suc)
    self.objBranch_reward_back:SetActive(bHasBranchRewards and suc)
    self.objReward_TMP:SetActive(bHasNormalRewards and suc)
    self.objBranch_reward_TMP:SetActive(bHasBranchRewards and suc)

    -- 因为服务器下发任务结束的时候, 任务可能已经移除了, 所以调用任务结束的时候可能会下发任务结局描述
    local iTaskEndDescID = taskInfo.uiTaskDesc
    self:UpdateDescData(taskData, suc, iTaskEndDescID)
    self:UpdateTaskReward(taskData, suc)

    if suc then
        self.comSucceed_DOTween:DORestart()
    else
        self.comFailed_DOTween:DORestart()
    end

    PlayButtonSound("EventQuestDone")
end

function TaskCompleteUI:UpdateDescData(taskData, bIsSuc, iTaskEndDescID)
    self.taskData = taskData
    local taskTypeData = TableDataManager:GetInstance():GetTableData("Task", taskData.uiTypeID)
    local taskID = taskData.uiID

    -- 标题
    local nameID = taskTypeData['NameID']
    local strTitle = GetLanguageByID(nameID, taskID)
    if DEBUG_MODE then
        strTitle = string.format("%s(curState:%d)", strTitle, taskData.uiTaskState)
    end
    self.comTitle.text = strTitle

    -- 起因
    local taskDescID = taskTypeData['TaskDescID']
    local causeDesc = TaskDataManager:GetInstance():GetDescByState(taskID, taskDescID)
    self.comCause.text = causeDesc

    -- 结局
    local endDesc = nil
    if (bIsSuc ~= nil) and (iTaskEndDescID ~= nil) and (iTaskEndDescID > 0) then
        endDesc = {
            ['uiDescID'] = iTaskEndDescID,
            ['uiDescState'] = (bIsSuc == true) and TaskDescStatesType.TDST_yiwancheng or TaskDescStatesType.TDST_yishibai
        }
    else
        endDesc = TaskDataManager:GetInstance():GetEndingDescState(taskID, bIsSuc)
    end
    if endDesc then
        local descID = endDesc.uiDescID
        local descState = endDesc.uiDescState
        local str = TaskDataManager:GetInstance():GetDescByState(taskID, descID, descState)
        -- local type = TaskDataManager:GetInstance():GetTypeByDescID(descID)
        self.comResult.text = str
        self.comResult.gameObject:SetActive(true)
    else
        -- 没有结局描述时, 显示任务的过程描述
        local akDescData = TaskDataManager:GetInstance():GetDescShowData(taskData)
        local astrDesc = {}
        local strSingleDesc = nil
        for index, data in ipairs(akDescData) do
            if (data.uiDescState == TaskDescStatesType.TDST_yiwancheng)
            or (data.uiDescState == TaskDescStatesType.TDST_yishibai) then
                strSingleDesc = TaskDataManager:GetDescByState(taskID, data.uiDescID, data.uiDescState)
                if strSingleDesc and (strSingleDesc ~= "") then
                    astrDesc[#astrDesc + 1] = strSingleDesc
                end
            end
        end
        if #astrDesc > 0 then
            self.comResult.text = table.concat(astrDesc, "\n")
            self.comResult.gameObject:SetActive(true)
        else
            self.comResult.gameObject:SetActive(false)
        end
    end
end

-- 更新任务奖励数据，包括通用奖励和物品奖励
function TaskCompleteUI:UpdateTaskReward(taskData, isSuc)
    self:ReturnAllTaskItemIcon()
    if not taskData then
        return
    end
    self.taskData = taskData
    local taskMgr = TaskDataManager:GetInstance()
    local taskID = taskData.uiID
    local taskTypeData = TableDataManager:GetInstance():GetTableData("Task", taskData.uiTypeID)
    if (isSuc ~= true) or (not taskTypeData) then
        return 
    end

    -- 创建一个动画队列
    self.sequence = DRCSRef.DOTween:Sequence()     -- 创建一个队列
    self.sequence:SetAutoKill(false)
    
    local rewardDataList = taskMgr:ParseAllToRewardList(taskID, true, true)
    local bHasBaseReward = rewardDataList and (#rewardDataList > 0)
    local aiBranchRewards = taskTypeData.TaskBranchRewards
    local bHasBranchReward = (aiBranchRewards ~= nil) and (#aiBranchRewards > 0)
    self.objReward:SetActive(bHasBaseReward and bHasBranchReward)
    self.objReward_L:SetActive(bHasBaseReward and (not bHasBranchReward))
    self.objReward2:SetActive(bHasBranchReward)
    local contentBaseReward = bHasBranchReward and self.contentReward or self.contentReward_L

    -- 普通奖励
    if bHasBaseReward then
        for k = 1, #rewardDataList do
            local kReward = rewardDataList[k]
            -- 如果是周目唯一的奖励, 并且本周目已经获得, 那么就不打钩, 显示已获得
            local bNeedTick = (not kReward.bShowEmpty)
            self:AddRewardIcon(kReward, bNeedTick, contentBaseReward)
        end
    end
    
    -- 分支奖励
    local branchRewardNodes = {}
    local branchRewardHasEmpty = {}
    local rewardID = nil
    local node = nil
    local kReward = nil
    if bHasBranchReward then
        for i = 1, #aiBranchRewards do
            rewardID = aiBranchRewards[i]
            local rewardDataList = taskMgr:ParseTaskReward(rewardID, taskID, true, taskMgr:HasGotTaskBranchReward(taskID, rewardID))
            if rewardDataList then
                for k = 1, #rewardDataList do
                    kReward = rewardDataList[k]
                    node = self:AddRewardIcon(kReward, false, self.contentReward2)
                    if node then
                        if not branchRewardNodes[rewardID] then
                            branchRewardNodes[rewardID] = {}
                            branchRewardHasEmpty[rewardID] = {}
                        end
                        branchRewardNodes[rewardID][k] = node
                        branchRewardHasEmpty[rewardID][k] = (kReward.bShowEmpty == true) and (kReward["DiffDropGet"] ~= nil) and (kReward["DiffDropGet"] ~= false)
                    end
                end
            end
        end
        self.objBranch_reward_back:SetActive(true)
        self.objBranch_reward_TMP:SetActive(true)
    else
        self.objBranch_reward_back:SetActive(false)
        self.objBranch_reward_TMP:SetActive(false)
    end

    -- 将已完成的分支奖励逐一打上勾, 这一步是在分支奖励全部显示出来之后做的
    local achieveBranchReward = taskMgr:GetTaskAchieveBranchReward(taskData.uiID)
    if not achieveBranchReward then return end
    for index, rewardID in ipairs(achieveBranchReward) do
        if branchRewardNodes[rewardID] then
            for index, node in ipairs(branchRewardNodes[rewardID]) do
                if (not branchRewardHasEmpty[rewardID]) or (branchRewardHasEmpty[rewardID] and (branchRewardHasEmpty[rewardID][index] ~= true)) then
                    self:DoTickAnim(node)
                end
            end
        end
    end
end

function TaskCompleteUI:DoTickAnim(node)
    if not node then return end
    local objTick = self:FindChild(node, "Tick")
    if not objTick then return end
    objTick:SetActive(true)
    local comTickImage = objTick:GetComponent('Image')
    local tween = Twn_Fade(nil, comTickImage, 0, 255, 0.3)
    self.sequence:AppendInterval(0.2)
    self.sequence:Append(tween)
end

function TaskCompleteUI:ReturnAllTaskItemIcon()
    if #self.akItemUIClass > 0 then
        LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
        self.akItemUIClass = {}
    end
end

function TaskCompleteUI:CreateTaskItemIcon(kRewardData, kTransParent)
    if not (kRewardData and kTransParent) then
        return
    end
    local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.TaskItemIconUI, kTransParent)
    kIconBindData:UpdateUI(kRewardData)
    self.akItemUIClass[#self.akItemUIClass + 1] = kIconBindData
	return kIconBindData
end

-- 添加一个物品图标到任务奖励中
function TaskCompleteUI:AddRewardIcon(rewardData, bIsNeedTick, objParent)
    if not (rewardData and objParent) then return end
    -- bIsBranchReward = (bIsBranchReward == true)
    local kTransParent = objParent.transform
    local kIconBindData = self:CreateTaskItemIcon(rewardData, kTransParent)
    local objNode = kIconBindData._gameObject
    local bIsEmpty = (rewardData.bShowEmpty == true) and (rewardData["DiffDropGet"] ~= nil) and (rewardData["DiffDropGet"] ~= false)
    if bIsNeedTick and (not bIsEmpty) then
        self:DoTickAnim(objNode)
    end
    return objNode
end

function TaskCompleteUI:OnDestroy()
    self.comSucceed_DOTween:DOKill()
    self.comFailed_DOTween:DOKill()
    self:ReturnAllTaskItemIcon()
end

function TaskCompleteUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
end

function TaskCompleteUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
end

return TaskCompleteUI