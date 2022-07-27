Day7TaskUI = class("Day7TaskUI",BaseWindow)

local RewardModel = {
	['Progress'] = 1,
	['Exchange'] = 2,
}

function Day7TaskUI:ctor()
	self.akItemUIClass = {}
end

function Day7TaskUI:Create()
	-- #TODO 钱程 之后可能要读取表格中的样式字段, 加载其他在结构上兼容的预制体
	local obj = LoadPrefabAndInit("TownUI/Day7TaskUI", UI_UILayer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function Day7TaskUI:Init()
	self.objRoot = self:FindChild(self._gameObject, "Page")
	-- 广告图
	self.spriteAD = self:FindChildComponent(self.objRoot, "AD", "Image")
	-- 任务页
	self.objTask = self:FindChild(self.objRoot, "Task")
	self.objTaskContent = self:FindChild(self.objTask, "Viewport/Content")
	self.transTaskContent = self.objTaskContent.transform
	-- 底部栏
	self.objBar = self:FindChild(self.objRoot, "Bar")
	self.objDayTabs = self:FindChild(self.objBar, "Tabs")
	self:InitDayTabsListener()
	self.objPoint = self:FindChild(self.objBar, "Point")
	self.textPoint = self:FindChildComponent(self.objPoint, "Value", "Text")
	self.objRewardProgress = self:FindChild(self.objBar, "RewardsProgress")
	self.scrollBarProgress = self:FindChildComponent(self.objRewardProgress, "Progress", "Scrollbar")
	self.transRewardProgressList = self:FindChild(self.objRewardProgress, "List").transform
	self.objRewardGetSelf = self:FindChild(self.objBar, "RewardsGetSelf")
	self.transRewardGetSelfList = self:FindChild(self.objRewardGetSelf, "List").transform
	-- 关闭按钮
	local btnClose = self:FindChildComponent(self.objRoot, "Close", "Button")
	self:AddButtonClickListener(btnClose, function()
		self:OnClickClose()
	end)
end

-- 初始化tab栏按钮监听 
function Day7TaskUI:InitDayTabsListener()
	if not self.objDayTabs then
		return
	end
	self.btnTabs = {}
	local trnasDayTabs = self.objDayTabs.transform
	local transChild = nil
	local btnChild = nil
	for index = 1, trnasDayTabs.childCount do
		transChild = trnasDayTabs:GetChild(index - 1)
		btnChild = transChild:GetComponent("Button")
		self.btnTabs[index] = btnChild
		local iDayIndex = index
		self:AddButtonClickListener(btnChild, function()
			self:OnClickDayTab(iDayIndex)
		end)
	end
end

function Day7TaskUI:RefreshUI(info)
	-- #TODO 钱程 获取活动静态数据
	local kActivityData = nil
	self:InitWithActivityData(kActivityData)
end

function Day7TaskUI:OnDestroy()
	self:ReturnAllRecyclableObj()
end

------------------逻辑函数-----------------

-- 获取当前活动ID并设置活动相关的数据
function Day7TaskUI:InitWithActivityData(kActivityData)
	-- 记录本次活动ID
	-- self.iCurActivityID = kActivityData.iActivityID
	self.kCurActivityData = kActivityData

	-- 初始化广告图
	-- self:SetSpriteAsync("", self.spriteAD)

	-- 初始化任务数据
	-- self.akDayTasks = {}

	-- 获取当前是第几天, 并设置天数Tab状态(超过今天的不予点击)
	local iToday = 1
	self:SetDayTabsState(iToday)

	-- 显示今天的任务
	self:OnClickDayTab(iToday)

	-- 是 达标领取式 还是 积分兑换式?
	self.eRewardModel = RewardModel.Progress
	-- self.eRewardModel = RewardModel.Exchange

	-- 设置底部栏当前积分与进度
	-- #TODO 钱程 获取当前进度
	local iCurProgress = 30
	self.textPoint.text = tostring(iCurProgress)
	self.objRewardProgress:SetActive(false)
	self.objRewardGetSelf:SetActive(false)
	if self.eRewardModel == RewardModel.Progress then
		-- #TODO 钱程 获取最大进度
		self.iMaxProgess = 100
		self:SetCurProgressReward(iCurProgress)
		self.objRewardProgress:SetActive(true)
	elseif self.eRewardModel == RewardModel.Exchange then
		self:SetCurExchangeReward(iCurProgress)
		self.objRewardGetSelf:SetActive(true)
	end
end

-- 设置tab栏按钮状态
function Day7TaskUI:SetDayTabsState(iToday)
	if not self.btnTabs then
		return
	end
	for iDay, comBtn in ipairs(self.btnTabs) do
		comBtn.interactable = (iDay <= iToday)
	end
end

-- 设置当前积分进度
function Day7TaskUI:SetCurProgressReward(iProgress)
	-- #TODO 钱程 这里要用到活动的静态数据
	-- if not self.kCurActivityData then
	-- 	return
	-- end
	iProgress = iProgress or 0
	self.iMaxProgess = self.iMaxProgess or 1
	self.scrollBarProgress.size = (iProgress / self.iMaxProgess)
	if not self.transRewardProgressList then
		return
	end
	-- 初始化ui, 这里只会走进来一次, 不会重复FindChild
	if not self.akProgressRewardSlot then
		local coms = {}
		local iCount = self.transRewardProgressList.childCount
		local transChild = nil
		local objChild = nil
		local transSlot = nil
		local iTarget = nil
		local textTarget = nil
		for index = 1, iCount do
			transChild = self.transRewardProgressList:GetChild(index - 1)
			objChild = transChild.gameObject
			textTarget = self:FindChildComponent(objChild, "Text", "Text")
			-- #TODO 钱程 这里填写目标进度值
			iTarget = index * 10
			textTarget.text = tostring(iTarget)
			transSlot = self:FindChild(objChild, "ItemSlot").transform
			coms[index] = {
				['transSlot'] = transSlot,
				['iTarget'] = iTarget
			}
		end
		self.akProgressRewardSlot = coms
	end
	-- 下面这段逻辑是每次set都要走的
	self:ReturnAllIcons("Bar")
	local kIconBindData = nil
	local bRewardGot = false
	for index, kSlotData in ipairs(self.akProgressRewardSlot) do
		-- #TODO 钱程 这里初始化奖励图标
		kIconBindData = self:CreateIcon(TableDataManager:GetInstance():GetTableData("Item", 31613), 1, kSlotData.transSlot, "Bar")
		if not kSlotData.iTarget then
			kSlotData.iTarget = 0
		end
		-- #TODO 钱程 获取奖励是否已经被领取
		bRewardGot = false
		if bRewardGot then
			-- #TODO 钱程 打钩
		elseif kSlotData.iTarget <= iProgress then
			-- 取消置灰
			kIconBindData:SetIconState()
		else
			-- 图标置灰
			kIconBindData:SetIconState("gray")
		end
	end
end

-- 设置当前兑换状态
function Day7TaskUI:SetCurExchangeReward(iProgress)
	-- #TODO 钱程 这里要用到活动的静态数据
	-- if not self.kCurActivityData then
	-- 	return
	-- end
	if not self.transRewardGetSelfList then
		return
	end
	-- 初始化ui, 这里只会走进来一次, 不会重复FindChild
	if not self.akExchangeRewardSlot then
		local coms = {}
		local iCount = self.transRewardGetSelfList.childCount
		local transChild = nil
		local objChild = nil
		local transSlot = nil
		local iTarget = nil
		local textTarget = nil
		local btnGet = nil
		for index = 1, iCount do
			transChild = self.transRewardGetSelfList:GetChild(index - 1)
			objChild = transChild.gameObject
			btnGet = self:FindChildComponent(objChild, "Get", "Button")
			textTarget = self:FindChildComponent(objChild, "Get/Text", "Text")
			-- #TODO 钱程 这里填写目标进度值
			iTarget = index * 10
			textTarget.text = tostring(iTarget)
			transSlot = self:FindChild(objChild, "ItemSlot").transform
			coms[index] = {
				['transSlot'] = transSlot,
				['btnGet'] = btnGet,
				['textTarget'] = textTarget,
				['iTarget'] = iTarget
			}
		end
		self.akExchangeRewardSlot = coms
	end
	-- 下面这段逻辑是每次set都要走的
	self:ReturnAllIcons("Bar")
	local kIconBindData = nil
	local bRewardGot = false
	for index, kSlotData in ipairs(self.akExchangeRewardSlot) do
		-- #TODO 钱程 这里初始化奖励图标
		kIconBindData = self:CreateIcon(TableDataManager:GetInstance():GetTableData("Item", 31613), 1, kSlotData.transSlot, "Bar")
		if not kSlotData.iTarget then
			kSlotData.iTarget = 0
		end
		-- #TODO 钱程 获取奖励是否已经被领取
		bRewardGot = false
		kSlotData.btnGet.interactable = false
		if bRewardGot then
			-- #TODO 钱程 打钩, 并且按钮显示已领取
			kSlotData.textTarget.text = "已领取"
		elseif kSlotData.iTarget <= iProgress then
			-- 取消置灰, 按钮显示可领取
			kSlotData.textTarget.text = "可领取"
			kSlotData.btnGet.interactable = true
			kIconBindData:SetIconState()
		else
			-- 图标置灰, 按钮显示目标值
			kIconBindData:SetIconState("gray")
		end
	end
end

------------------工具函数------------------

-- 归还所有物品图标
function Day7TaskUI:ReturnAllIcons(strCackeKey)
	if not self.akItemUIClass then
		return
	end
	if strCackeKey then
		if self.akItemUIClass[strCackeKey] and (#self.akItemUIClass[strCackeKey] > 0) then
			LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass[strCackeKey])
			self.akItemUIClass[strCackeKey] = {}
		end
		return
	end
	
	for key, list in pairs(self.akItemUIClass) do
		LuaClassFactory:GetInstance():ReturnAllUIClass(list)
		self.akItemUIClass[key] = {}
	end
end

-- 从对象池中加载一个图标
function Day7TaskUI:CreateIcon(kItemTypeData, iNum, kTransParent, strCackeKey)
	if not (kItemTypeData and kTransParent) then
		return
	end
	local kIconBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI, kTransParent)
	local iNum = iNum or 0
	kIconBindData:UpdateUIWithItemTypeData(kItemTypeData)
	kIconBindData:SetItemNum(iNum, iNum == 1)
	if (not strCackeKey) or (strCackeKey == "") then
		strCackeKey = 'Default'
	end
	if not self.akItemUIClass[strCackeKey] then
		self.akItemUIClass[strCackeKey] = {}
	end
	self.akItemUIClass[strCackeKey][#self.akItemUIClass[strCackeKey] + 1] = kIconBindData
	return kIconBindData
end

-- 回收所有可回收资源
function Day7TaskUI:ReturnAllRecyclableObj(strCackeKey)
	self:ReturnAllIcons(strCackeKey)
	self:ReturnAllObjToPool()
end

-- 查找一个任务组件的节点
function Day7TaskUI:FindChildTaskItem(objTask)
	if not objTask then
		return
	end
	local objItemIcon1 = self:FindChild(objTask, "Reward/Slot1")
	local objItemIcon2 = self:FindChild(objTask, "Reward/Slot2")
	local ret = {
		["textDesc"] = self:FindChildComponent(objTask, "Msg/Desc", "Text"),
		["textPoint"] = self:FindChildComponent(objTask, "Msg/Point/Value", "Text"),
		["objProgressNum"] = self:FindChild(objTask, "Progress/Num"),
		["textProgressNum"] = self:FindChildComponent(objTask, "Progress/Num", "Text"),
		["objProgressHasGot"] = self:FindChild(objTask, "Progress/HasGet"),
		["objProgressBtnGet"] = self:FindChild(objTask, "Progress/ButtonGet"),
		["btnProgressBtnGet"] = self:FindChildComponent(objTask, "Progress/ButtonGet", "Button"),
		["objItemSlot1"] = objItemIcon1,
		["objItemSlot2"] = objItemIcon2,
		["transItemSlot1"] = objItemIcon1.transform,
		["transItemSlot2"] = objItemIcon2.transform,
	}
	-- 给领奖按钮注册一个点击监听
	local btnGetReward = ret.btnProgressBtnGet
	self:RemoveButtonClickListener(btnGetReward)
	self:AddButtonClickListener(btnGetReward, function()
		self:OnClickGetReward(btnGetReward)
	end)
	return ret
end

-- 设置任务列表
function Day7TaskUI:SetTasks(aiTasks)
	if not aiTasks then
		return
	end
	self:ReturnAllRecyclableObj("Default")
	-- 缓存一下新对象的子节点, 避免每次都要FindChild
	if not self.objChildCache then
		self.objChildCache = {}
	end
	-- 这是个按钮组件到任务id的映射, 领取奖励的时候用
	if not self.btn2TaskID then
		self.btn2TaskID = {}
	end
	local kChildCache = nil
	local objClone = nil
	for index, iTaskID in ipairs(aiTasks) do
		objClone = self:LoadPrefabFromPool("TownUI/Day7TaskItemUI", self.transTaskContent)
		if self.objChildCache[objClone] == nil then
			self.objChildCache[objClone] = self:FindChildTaskItem(objClone)
		end
		kChildCache = self.objChildCache[objClone]
		-- 要改变领奖按钮的点击行为, 不需要移除/添加监听, 只需要改变对应的数据
		self.btn2TaskID[kChildCache.btnProgressBtnGet] = iTaskID
		-- 设置任务数据
		kChildCache.textDesc.text = string.format("这是任务%d", index)
		-- 设置奖励图标
		self:CreateIcon(TableDataManager:GetInstance():GetTableData("Item", 31613), 1, kChildCache.transItemSlot1)
		self:CreateIcon(TableDataManager:GetInstance():GetTableData("Item", 31613), 1, kChildCache.transItemSlot2)
	end
end

------------------点击回调------------------

-- 点击关闭按钮
function Day7TaskUI:OnClickClose()
	self:ReturnAllRecyclableObj()
	RemoveWindowImmediately("Day7TaskUI")
end

-- 点击天数Tab栏
function Day7TaskUI:OnClickDayTab(iDayIndex)
	if not iDayIndex then
		return
	end
	-- self.akDayTasks[iDayIndex]
	SystemUICall:GetInstance():Toast("第" .. iDayIndex .. "天")
	local aiTasks = {}
	for index = 1, iDayIndex do
		aiTasks[#aiTasks + 1] = iDayIndex
	end
	self:SetTasks(aiTasks)
end

-- 点击任务领奖
function Day7TaskUI:OnClickGetReward(btnGetReward)
	if not (self.btn2TaskID and btnGetReward and self.btn2TaskID[btnGetReward]) then
		return
	end
	local iGetRewardTaskID = self.btn2TaskID[btnGetReward]
	-- 获取该任务的奖励
	SystemUICall:GetInstance():Toast("获取任务奖励:　" .. tostring(iGetRewardTaskID))
end

return Day7TaskUI