TaskTipsUI = class("TaskTipsUI",BaseWindow)

local iMoneyTask = 3154

function TaskTipsUI:ctor()
end

function TaskTipsUI:Create()
	local obj = LoadPrefabAndInit("TaskUI/TaskTipsUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TaskTipsUI:Init()
	self.objStatic = self:FindChild(self._gameObject, "TransformAdapt_node_right/static")
	self.comStaticDT = self.objStatic:GetComponent("DOTweenAnimation")
	self.comFoldButton = self:FindChildComponent(self.objStatic, "Button", "Button")
	self.comFoldButtonDT = self:FindChildComponent(self.objStatic, "Button", "DOTweenAnimation")
	if self.comFoldButton then
		self:AddButtonClickListener(self.comFoldButton, function()
			-- 点击收起按钮
			if self.fold then
				self.comStaticDT:DOPlayBackwards()
				self.comFoldButtonDT:DOPlayBackwards()
			else
				self.comStaticDT:DOPlayForward()
				self.comFoldButtonDT:DOPlayForward()
			end
			self.fold = not self.fold
		end)
	end

	self.comTaskButton = self:FindChildComponent(self.objStatic, "back", "Button")
	self.comTaskDescButton = self:FindChildComponent(self.objStatic, "anim/descBg", "Button")
	if self.comTaskButton then
		self:AddButtonClickListener(self.comTaskButton, function()
			-- TODO：点击任务按钮，跳转到对应任务
			local uiID
			if self.trace_task then
				uiID = self.trace_task.uiID
			end
			OpenWindowImmediately("TaskUI", uiID, true)
			--防止快捷键呼出TaskUI时 CharacterUI下面的模型显示
			if IsWindowOpen("CharacterUI") then
				RemoveWindowImmediately("CharacterUI")
			end
		end)
	end
	if self.comTaskDescButton then
		self:AddButtonClickListener(self.comTaskDescButton, function()
			-- TODO：点击任务按钮，跳转到对应任务
			local uiID
			if self.trace_task then
				uiID = self.trace_task.uiID
			end
			OpenWindowImmediately("TaskUI", uiID, true)
		end)
	end
	self.objBack = self:FindChild(self.objStatic, "back")
	self.objStaticContent = self:FindChild(self.objStatic, "anim")
	self.objBack:SetActive(true)
	self.objStaticContent:SetActive(false)	-- 先默认隐藏
	self.objStaticContentCanvasGroup = self.objStaticContent:GetComponent("CanvasGroup")
	self.comStaticNameText = self:FindChildComponent(self.objStaticContent, 'name', 'Text')		-- 名称
	self.comStaticTypeText = self:FindChildComponent(self.objStaticContent, 'type', 'Text')		-- 类型
	self.comStaticDescText = self:FindChildComponent(self.objStaticContent, 'descBg/desc', 'Text')		-- 描述

	self.objStaticEmpty = self:FindChild(self.objStatic, "empty")						-- 空
	self.objStaticEmpty:SetActive(true)
	self.comStaticEmptyText = self.objStaticEmpty:GetComponent('Text')					-- 空，文字
	self.comStaticEmptyText.text = dtext(978)

	self.objDynamic = self:FindChild(self._gameObject, "TransformAdapt_node_right/dynamic")
	self.array_dynamic = {}	-- 根节点
	self.button_dynamic = {}	-- 按钮
	self.anim_dynamic = {}	-- 动画
	for i = 1, 3 do
		self.array_dynamic[i] = self.objDynamic.transform:GetChild(i-1).gameObject
		self.array_dynamic[i]:SetActive(false)
		self.anim_dynamic[i] = self:FindChildComponent(self.array_dynamic[i], "anim", "DOTweenAnimation")
		self.anim_dynamic[i].tween:OnComplete(function()
			if self.array_dynamic and self.array_dynamic[i] then
				self.array_dynamic[i]:SetActive(false)
			end
			self:CheckAndShow()		-- 每次动画完成了，都检查一下要不要播放下一个动画
		end)
		self.button_dynamic[i] = self.array_dynamic[i]:GetComponent("Button")
		if self.button_dynamic[i] then
			self:AddButtonClickListener(self.button_dynamic[i], function() 
				self.anim_dynamic[i]:DOComplete()
			end)
		end
	end

	self.trace_task = nil		-- 当前跟踪的任务 动态数据
	self.trace_desc = nil		-- 当前跟踪的任务 描述结构

	-- 任务广播下行的刷新界面，等 plot 对话都说完，再执行
	self:AddEventListener("TASK_BROADCAST",function(taskData) 
		DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TASK_BROADCAST_TIPS, false, taskData)
	end)

	self:AddEventListener("REMOVE_TASK_DATA", function(uiTaskID)
		if (not uiTaskID) 
		or (not self.trace_task) 
		or (uiTaskID ~= self.trace_task.uiID) then
			return
		end
		self:UpdateStatic()
	end)

	self.msg_queue = {}
end

function TaskTipsUI:AddNeedUpdateTaskInfo(taskInfo)
	self.updateTaskInfoList = self.updateTaskInfoList or {}
	table.insert(self.updateTaskInfoList, taskInfo)
	self.isDirty = true
end
local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
NavigationHotKeyInvalidWindows ={	--当这些窗口任意一个打开时热键无效
	"StoreUI",
	"PlayerSetUI",
	"StorageUI"
}
function TaskTipsUI:Update()

	if IsNotInGuide() and GetKeyDownByFuncType(FuncType.OpenOrCloseQuestUI) and not IsAnyWindowOpen(NavigationHotKeyInvalidWindows)  then
		if not IsWindowOpen("TaskUI") then
			self.comTaskButton.onClick:Invoke()
		else
			RemoveWindowImmediately("TaskUI",false)
		end
		
	end
	if self.isDirty then 
		self.isDirty = nil
		if self.updateTaskInfoList then 
			for _, updateTaskInfo in ipairs(self.updateTaskInfoList) do 
				self:RefreshUI(updateTaskInfo)
			end
			self.updateTaskInfoList = {}
		end
	end
end

-- 常驻追踪任务的逻辑：
-- 常驻任务的 ID 应该记在 GameData 里
-- 1. 界面打开时，取出 该任务数据 并刷新。
-- 2. 任务更新时，检查该任务确实更新以后，判断该任务是不是常驻任务，如果是常驻任务，则进行刷新。
-- 刷新之前，还要判断 有没有正在运行，则说明任务追踪完毕，将常驻任务置空，并执行 traverse
-- 3. 刷新的逻辑为，如果取不到正在运行的一条描述，

-- 遍历所有的任务，找到一个主线任务用于追踪，如果没有找到则不显示
function TaskTipsUI:Traverse()
	self.trace_task = nil
    self.taskPool = TaskDataManager:GetInstance():GetTaskPool()
    for k,v in pairs(self.taskPool) do
		if self:CheckStaticDisplay(v) then
			local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByTypeID(v.uiTypeID)
			if taskTypeData.Type == TaskType.TT_zhuxian then
				self.trace_task = v
				break
			end
		end
    end
end

-- 刷新静态任务显示 ＜（＾－＾）＞
function TaskTipsUI:UpdateStatic()

	-- 当用户设置，或者遍历得到了 追踪任务后，服务器下发了新任务，则判断一下下发数据是不是 追踪任务
	if self.newData and self.trace_task then
		if self.newData.uiID ~= self.trace_task.uiID then return end
		self.trace_task = self.newData
	end
	if self:CheckStaticDisplay(self.trace_task) == false then
		self:Traverse()
	end
	self:SetStaticInfo()
end

-- 常驻界面，只更新正在进行中的任务，不考虑完成/失败的任务
function TaskTipsUI:CheckStaticDisplay(taskData)
	if not taskData then return false end
	if taskData['uiTaskProgressType'] ~= TPT_INIT then 
		return false 
	end
	if taskData.bIsRemoved == true then
		return false
	end
	return self:CheckDisplay(taskData)
end

-- 最终：更新追踪任务的常驻信息，在这之后不再做处理
function TaskTipsUI:SetStaticInfo()
	-- 记录 当前追踪任务 的 ID
	local trace_task_id
	if self.trace_task then
		trace_task_id = self.trace_task.uiID
	end
    globalDataPool:setData("TraceTask", trace_task_id, true)

	if self.trace_task == nil then
		-- 淡入淡出动画
		if self.objStaticContent.activeSelf then
			local tween1 = Twn_CanvasGroupFade(nil, self.objStaticContentCanvasGroup, 255, 0, 0.3, 0, function()
				if self.objStaticContent then
					self.objStaticContent:SetActive(false)
				end
				if self.objBack then
					self.objBack:SetActive(true)
				end
			end)
			self.objStaticEmpty:SetActive(true)
			Twn_Fade(nil, self.comStaticEmptyText, 0, 255, 0.3, 0.3)
		end
	else
		-- 查询数据
		local desc_to_show = TaskDataManager:GetInstance():GetDescShowData(self.trace_task)
		if not next(desc_to_show) then return end
		local final_desc
		-- local state = {
		-- 	['index'] = i,
		-- 	['uiDescID'] = descStates[i-1].uiDescID,
		-- 	['uiDescState'] = descStates[i-1].uiDescState,
		-- }
		for i = 1, #desc_to_show do
			if desc_to_show[i].uiDescState == TaskDescStatesType.TDST_jinxingzhong then
				final_desc = desc_to_show[i]
				break
			end
		end

		-- 判断是否需要刷新  --DataIsEqual(self.trace_desc, final_desc)
		if final_desc == nil then return end
		local str = TaskDataManager:GetInstance():GetDescByState(trace_task_id, final_desc['uiDescID'], final_desc['uiDescState'])
		if self.comStaticDescText.text == str then return end	-- 直接判断描述字符串是否相同

		-- 开始填入数据
		local edit_data = function()
			if not (self.trace_task and self.trace_task.uiID) then
				return
			end
			self.trace_desc = final_desc or ""
			local taskID = self.trace_task.uiID
			local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByID(taskID)
			if not taskTypeData then
				return
			end
			local taskType = taskTypeData['Type']		-- 追踪任务类型
			local taskTypeIndex = TaskDataManager:GetInstance():GetNavIndex(taskID)
			local taskTypeText = TaskDataManager:GetInstance():GetTaskTypeAbbr(taskTypeIndex)	-- 任务类型缩写

			-- local taskTypeText = GetEnumValueLanguageID('TaskType', taskType)
			-- taskTypeText = GetLanguageByID(taskTypeText)	-- 追踪任务类型 - 语言表

			self.comStaticNameText.text = self:GetTaskName(taskTypeData) 	-- 名字
			--最多显示100个字符
			if string.stringWidthWithoutTag(str) > 100 then
				str = StringLimitWithTag(str,100)
				str = str .. '......'
			end
			self.comStaticDescText.text = str						-- 追踪任务描述
			if taskType == TaskType.TT_zhuxian then			-- 主线 - 橙色，支线 - 蓝色
				self.comStaticTypeText.text = getRankBasedText(RankType.RT_Orange, taskTypeText)
			else
				self.comStaticTypeText.text = getRankBasedText(RankType.RT_Blue, taskTypeText)
			end
		end

		-- 播放淡入淡出动画
		self.sequence = DRCSRef.DOTween:Sequence()     -- 创建一个队列
		self.sequence:SetAutoKill(false)
		if self.objStaticEmpty.activeSelf then
			self.event_anim = Twn_Fade(nil, self.comStaticEmptyText, 255, 0, 0.3, 0, function() 
				if self.objStaticEmpty then
					self.objStaticEmpty:SetActive(false)
				end
				edit_data()
			end)
			self.objStaticContent:SetActive(true)
			self.objBack:SetActive(false)
			self.objStaticContentCanvasGroup:DR_DOCanvasGroupFade(0,1,0.3,0.3)
		else
			local canvasGroup = self.objStaticContentCanvasGroup
			local tween3 = canvasGroup:DOFade(0, 0.3)
			tween3.onComplete = edit_data()
			local tween4 = canvasGroup:DOFade(255, 0.3)
			self.sequence:Append(tween3)
			self.sequence:AppendInterval(0.1)
			self.sequence:Append(tween4)
		end
	end
end

function TaskTipsUI:GetTaskName(taskTypeData)
	if not taskTypeData or not self.trace_task then 
		return 
	end
	local str = GetLanguageByID(taskTypeData['NameID'],self.trace_task.uiID or 0)

	-- 如果没有匹配，返回原字符串，则不需要截取，例如 "猎户张的日记"
	-- 如果匹配了，则截取前缀，返回后面的部分，例如 "【月牙村】小村大侠梦" → "小村大侠梦"
	-- 如果前缀后面没有文字，则截取括号，例如"【严妈妈的爱心鸡汤】" → "严妈妈的爱心鸡汤"
	local get = string.gsub(str, "【(.*)】(.*)","%2")
    if string.len(get) == 0 then
        get = string.gsub( str, "【(.+)】", "%1")
    end
    return get
end

-- 一条新的任务更新，加入队列
function TaskTipsUI:Enqueue(info)
	if not info then return end
	self.msg_queue[#self.msg_queue + 1] = info
end

-- 弹出一条任务更新，移出队列
function TaskTipsUI:Dequeue()
    -- 出队
    table.remove(self.msg_queue, 1)
end

-- 检查队列是否在播放，如果没有播放，就 Dequeue
function TaskTipsUI:CheckAndShow()

	if not self.msg_queue then
        derror("任务追踪队列出现错误")
        return
    end

    -- 检查队列，如果为空则不继续
    if #self.msg_queue == 0 then return end

	local index = self:GetAvaliable()

	-- 当前没有可用节点，则不继续
	if not index then return end

	-- 有队列，又有可用节点，可以播放动画。
	local msg = self.msg_queue[1]
	local comNameText = self:FindChildComponent(self.array_dynamic[index], "anim/Name", "Text")
	local comDescText = self:FindChildComponent(self.array_dynamic[index], "anim/Desc", "Text")
	comNameText.text = msg['name']
	comDescText.text = msg['flag']
	comDescText.color = msg['color']
	RewindDoAnimation(self.array_dynamic[index])

	-- 将节点放到最下方
	self.array_dynamic[index].transform:SetSiblingIndex(2)
	self.array_dynamic[index]:SetActive(true)
	self.anim_dynamic[index]:DOPlayAllById("anim")

	self:Dequeue()
end

-- 获取一个可用的节点
function TaskTipsUI:GetAvaliable()
	for i = 1, 3 do
		if self.array_dynamic[i].activeSelf == false then
			return i
		end
	end
end

-- 1. 父界面（城镇/迷宫/大地图）打开，需要还原追踪任务信息，TODO：可能还要还原正在播放的动画节点
-- 2. 任务更新 的时候调用，判断该任务是否要 跳更新提示；判断该任务是不是 追踪任务，要不要更新常驻 / 切下一个任务
-- 3. 玩家在任务界面 追踪某个任务，立刻替换成追踪任务(直接 设置 TraceTask 就可以了)，并更新常驻
function TaskTipsUI:RefreshUI(info)
	if info and info['new'] then
		self.oldData = info['old']
		self.newData = info['new']
		self.isDescRefresh = info['desc']
		if not self:CheckDisplay(self.newData) then return end
		self:CheckUpdate()
		self:CheckAndShow()
		self.oldData = nil
		self.newData = nil
		local trace_task_id = globalDataPool:getData("TraceTask")
		self.trace_task = TaskDataManager:GetInstance():GetTaskData(trace_task_id)
		self:UpdateStatic()
	else
		self.oldData = nil
		self.newData = nil
		local trace_task_id = globalDataPool:getData("TraceTask")
		self.trace_task = TaskDataManager:GetInstance():GetTaskData(trace_task_id)
		self:UpdateStatic()
	end
end

-- 第二步，当前任务是要显示的，那么检查一下是否任务更新了
function TaskTipsUI:CheckUpdate()
	local info = nil
	local newTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByTypeID(self.newData.uiTypeID)
	--为铜币任务就不显示了
	if self.newData.uiTypeID == iMoneyTask then
		return
	end
	local newName = self:GetTaskName(newTypeData)

	-- 【1】检查任务开启状态是否发生改变。新开启的任务不显示任务更新
	if self.oldData then
		local oldProgressType = self.oldData['uiTaskProgressType']
		local newProgressType = self.newData['uiTaskProgressType']
		if oldProgressType and newProgressType and oldProgressType ~= newProgressType then
			info = {
				['name'] = newName,
			}
			if newProgressType == TPT_INIT then
				info['flag'] = '任务重接'
				info['color'] = getUIColor('white')
			elseif newProgressType == TPT_SUCCEED then
				info['flag'] = '任务完成'
				info['color'] = getUIColor('green')
			elseif newProgressType == TPT_FAILED then
				info['flag'] = '任务失败'
				info['color'] = getUIColor('red')
			end
		end
	end

	-- 检查任务阶段是否发生改变，全部算作进度更新
	-- local oldStateID = self.oldData['uiTaskState']
	-- local newStateID = self.newData['uiTaskState']
	-- if oldStateID and newStateID and oldStateID ~= newStateID then
	-- 	info = {
	-- 		['name'] = newName,
	-- 		['flag'] = '进度更新',
	-- 		['color'] = getUIColor('green'),
	-- 	}
	-- end
	
	-- 【2】任务阶段是否改变，为什么不能判断任务阶段ID (⊙⊙?)
	-- 由于很多任务都是带环的，如果只是判断阶段ID改变的话，不一定是真的进度推进了
	-- 例如 交付一件物品，失败了，又回到待交付
	-- 因此，任务阶段的更新，最终反映的是【描述数组的变动】
	-- 规则1：如果描述数组发生变化，那么可以看做是进度推进了
	-- 规则2：如果多出现了一条失败描述（简单判断数量即可）那么需要显示“任务失败”，否则显示“进度更新”
	-- 规则3：这里判断的描述，已经是经过排序处理后的描述了，防止服务器发下来的数据是无序的造成匹配错误
	if not info then
		local oldDescStates = TaskDataManager:GetInstance():GetDescShowData(self.oldData)
		local newDescStates = TaskDataManager:GetInstance():GetDescShowData(self.newData)

		if oldDescStates and newDescStates and DataIsEqual(oldDescStates, newDescStates) == false then
			info = {
				['name'] = newName,
				['flag'] = '进度更新',
				['color'] = getUIColor('green'),
			}
			if self:CalculateFail(oldDescStates) < self:CalculateFail(newDescStates) then
				info['flag'] = '任务失败'
			end
		end
	end

	-- if oldDescSize and newDescSide and 

    -- auiDescStates    描述数组
        -- result["auiDescStates"][i]["uiDescID"]
        -- result["auiDescStates"][i]["uiDescState"]

		-- [TaskDescStatesType.TDST_yiwancheng] = 3,
        -- [TaskDescStatesType.TDST_yishibai] = 3,
        -- [TaskDescStatesType.TDST_jinxingzhong] = 2,
        -- [TaskDescStatesType.TDST_yincang] = 1,

	-- 【3】检查任务进度 是否发生改变
	if self.isDescRefresh then
		info = {
			['name'] = newName,
			['flag'] = '进度更新',
			['color'] = getUIColor('green'),
		}
	end

	-- 如果确实有任务更新，就加入队列，并检查是否要更新常驻任务
	if info then
		self:UpdateStatic()
		self:Enqueue(info)
	end
end

function TaskTipsUI:CalculateFail(desc)
	local fail = 0
	for i = 1, #desc do
		if desc[i]['uiDescState'] == TaskDescStatesType.TDST_yishibai then
			fail = fail + 1
		end
	end
	return fail
end

-- 检查该任务是否要进行 任务广播 ＜（＾－＾）＞
-- 1. 该任务配置了正确的任务类型，非无效任务
-- 2. 该任务配置了面板显示，也就是需要玩家查看的
-- 3. 正在进行中的任务，至少有一条任务描述被开启（任务初始化阶段不要跳任务更新）
function TaskTipsUI:CheckDisplay(taskData)
	if not taskData then return false end
	local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByTypeID(taskData.uiTypeID)
	if not taskTypeData then return false end
    local taskProgressType = taskData['uiTaskProgressType']

    -- 1. 任务配置了正确的任务类型，非无效任务
	if (taskTypeData.Type == TaskType.TT_wuxiao) or (taskTypeData.Type == TaskType.TaskType_NULL) then return false end
	
	-- 2. 该任务配置了面板显示，也就是需要玩家查看的
    local flags = taskTypeData.SpecialFlag
    if not flags then return false end
    local display = false
    for k,v in pairs(flags) do
        if v == TaskFlag.TF_mianban then
            display = true
        end
    end

    -- 3. 正在进行中的任务，至少有一条任务描述被开启
	if taskProgressType == TPT_INIT then
		local desc_to_show = TaskDataManager:GetInstance():GetDescShowData(taskData)
        if next(desc_to_show) == nil then
            return false
        end
    end
    return display
end

function TaskTipsUI:OnDestroy()
	for i = 1, 3 do
		self.anim_dynamic[i].tween:OnComplete(nil)
	end

	if self.event_anim then
		self.event_anim.onComplete = nil
		self.event_anim = nil
	end
end


return TaskTipsUI