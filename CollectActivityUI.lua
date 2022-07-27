CollectActivityUI = class("CollectActivityUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

local l_DRCSRef_Type = DRCSRef_Type

local eBoardState = {
	Emmpty = 0,
	Loading = 1,
	Activity = 2,
}

-- 以下参数视UI而定
local REWARD_KEY = {
	"Reward1",
	"Reward2",
	"Reward3",
}
local COLLECT_KEY = {
	"Collect1",
	"Collect2",
	"Collect3",
	"Collect4",
	"Collect5",
}

function CollectActivityUI:Create()
	local obj = LoadPrefabAndInit("ResDropActivityUI/CollectActivityUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function CollectActivityUI:Init()
	self.kItemIconUIInst = ItemIconUI.new()

	self.objRoot = self:FindChild(self._gameObject, "Root")
	self.objAD = self:FindChild(self.objRoot, "AD")
	self.objADimg = self:FindChild(self.objAD, "Image")
	self.imgAD = self.objADimg:GetComponent(l_DRCSRef_Type.Image)
	self.textADDate = self:FindChildComponent(self.objAD, "Date", l_DRCSRef_Type.Text)
	self.textADDesc = self:FindChildComponent(self.objAD, "Desc", l_DRCSRef_Type.Text)
	self.objSCTask = self:FindChild(self.objRoot, "SCTask")
	self.scTask = self.objSCTask:GetComponent(l_DRCSRef_Type.LoopVerticalScrollRect)
	self.scTask:AddListener(function(transform, index) 
		if self:IsOpen() ~= true then
			return
        end
        self:UpdateCollectTask(transform, index)
    end)
	self.objLoading = self:FindChild(self.objRoot, "Loading")
	self.objEmpty = self:FindChild(self.objRoot, "Empty")
	-- 注册事件
	self:AddEventListener("UPDATE_MAIN_ROLE_INFO", function()
		self:UpdateBoard()
	end)
	-- 初始化收集任务
	self.scTask.totalCount = 0
    self.scTask:RefillCells()
end

function CollectActivityUI:RefreshUI(info)
	self:SetBoardState(eBoardState.Loading)
	if info and info.kActivityInfo then
		self:OnRecvActivityInfo(info.kActivityInfo)
	else
		SendRequestQueryResDropActivityInfo(EN_QUERY_RESDROP_ACTIVITY_COLLECT)
	end
end

function CollectActivityUI:OnEnable()
	OpenWindowBar({
        ['windowstr'] = "CollectActivityUI", 
        ['titleName'] = ResDropActivityDataManager:GetInstance():GetCurResDropCollectActivityName(),
        ['topBtnState'] = {
            ['bBackBtn'] = true,
        },
        ['bSaveToCache'] = true,
    })
end

function CollectActivityUI:OnDisable()
	RemoveWindowBar('CollectActivityUI')
end

-- 接受到服务器下行的活动信息
function CollectActivityUI:OnRecvActivityInfo(kInfo)
	-- 安全判断
	if (not kInfo) 
	or (not kInfo.aiOpenActivities) 
	or (not kInfo.aiExchangeNum)
	or (not kInfo.iNum) or (kInfo.iNum <= 0) then
		self:SetBoardState(eBoardState.Emmpty)
		return
	end
	-- 获取活动静态数据
	-- 下行资源掉落活动走的是通用结构, 所以虽然 aiOpenActivities 是个数组
	-- 但是对于收集活动来说, 同一时间只应该有一期活动开放, 所以这里只取数组第一个id即可
	local uiActivityID = kInfo.aiOpenActivities[0]
	local kActivityBaseData = TableDataManager:GetInstance():GetTableData("ResDropActivity", uiActivityID)
	if not kActivityBaseData then
		self:SetBoardState(eBoardState.Emmpty)
		return
	end
	self.uiCurResDropActivityID = uiActivityID
	ResDropActivityDataManager:GetInstance():SetCurResDropCollectActivityID(uiActivityID)
	-- 显示活动
	self:SetBoardState(eBoardState.Activity)
	-- 设置宣传图
	self:SetSpriteAsync(kActivityBaseData.ActivityImg or "", self.imgAD)
	local kStartDate = kActivityBaseData.StartDate or {}
	local iStartTimeStamp = os.time({['year'] = (kStartDate.Year or 0), ['month'] = (kStartDate.Month or 0), ['day'] = (kStartDate.Day or 0), ['hour'] = 0, ['min'] = 0, ['sec'] = 0})
	local iEndTimeStamp = iStartTimeStamp + (kActivityBaseData.Duration or 0)
	local kEndDate = os.date("*t", iEndTimeStamp)
	-- 由于描述字符串是拼接的, 如果策划需要控制富文本颜色, 约定在活动规则的文本中添加, 这里分析出颜色标签
	local strOriDesc = GetLanguageByID(kActivityBaseData.DescID or 0) or ""
	local uiColorTagIndex, uiMsgIndex, strColorTag, strMsg = string.find(strOriDesc, "(<color=.+>)(.*)</color>")
	strColorTag = strColorTag or ""
	strColorCloseTag = (strColorTag == "") and "" or "</color>"
	self.textADDate.text = string.format("%s活动时间: %d月%d日00:00 - %d月%d日%02d:%02d%s", strColorTag, kStartDate.Month or 0, kStartDate.Day or 0, kEndDate.month or 0, kEndDate.day or 0, kEndDate.hour or 0, kEndDate.min, strColorCloseTag)
	self.textADDesc.text = string.format("%s%s%s", strColorTag, strMsg or strOriDesc, strColorCloseTag)
	-- 设置收集任务
	local aiTasks = kActivityBaseData.ExtraInfoGroup or {}
	local akTasks, kTaskExchangeNum = {}, {}
	local kTBTask = TableDataManager:GetInstance():GetTable("CollectActivity")
	local kTaskBaseData = nil
	for index, iTaskID in ipairs(aiTasks) do
		kTaskBaseData = kTBTask[iTaskID]
		if kTaskBaseData then
			akTasks[#akTasks + 1] = {
				['BaseData'] = kTaskBaseData,
				['TaskIndex'] = index - 1,  -- 这里是传给服务器兑换用的, 所以转化为c++数组
			}
			kTaskExchangeNum[iTaskID] = kInfo.aiExchangeNum[index - 1] or 0
		end
	end
	self.akCollectTasks = akTasks
	self.kTaskExchangeNum = kTaskExchangeNum
	self.scTask.totalCount = #akTasks
	self.bNeedRefillBoard = true
end

-- 刷新活动面板
function CollectActivityUI:UpdateBoard(uiCollectActivityID, uiExchangeNum)
	if not (self.akCollectTasks and self.kTaskExchangeNum) then
		return
	end
	if uiCollectActivityID and uiExchangeNum then
		self.kTaskExchangeNum[uiCollectActivityID] = uiExchangeNum
	end
	self.bNeedUpdateBoard = true
end

function CollectActivityUI:Update()
	if self.bNeedRefillBoard == true then
		self.bNeedRefillBoard = false
		self.bNeedUpdateBoard = false
		self.scTask:RefillCells()
	end
	if self.bNeedUpdateBoard == true then
		self.bNeedUpdateBoard = false
		self.scTask:RefreshCells()
	end
end

-- 设置活动面板状态
function CollectActivityUI:SetBoardState(eState)
	local bIsEmpty = eState == eBoardState.Emmpty
	local bIsActivity = eState == eBoardState.Activity
	local bIsLoading = eState == eBoardState.Loading
	self.objAD:SetActive((not bIsEmpty) and bIsActivity)
	self.objSCTask:SetActive((not bIsEmpty) and bIsActivity)
	self.objLoading:SetActive((not bIsEmpty) and bIsLoading)
	self.objEmpty:SetActive(bIsEmpty)
end

-- 设置一个收集任务ui
function CollectActivityUI:UpdateCollectTask(transform, index)
	if not (self.akCollectTasks and transform and index) then
		return
	end
	local kInfo = self.akCollectTasks[index + 1] or {}
	local kTaskBaseData = kInfo.BaseData
	local uiTaskIndex = kInfo.TaskIndex
	if not (kTaskBaseData and uiTaskIndex) then
		return
	end
	local uiTaskBaseID = kTaskBaseData.BaseID
	local objNode = transform.gameObject
	local objRewards = self:FindChild(objNode, "Rewards")
	local objCost = self:FindChild(objNode, "Cost")
	local objExchange = self:FindChild(objNode, "Exchange")
	
	-- 设置物品奖励
	local objIcon = nil
	local iNum = 0
	local kItemBaseData = nil
	local kItemMgr = ItemDataManager:GetInstance()
	local aiReward = kTaskBaseData.RewardItemIDs or {}
	local aiRewardNum = kTaskBaseData.RewardNums or {}
	for index, strKey in ipairs(REWARD_KEY) do
		objIcon = self:FindChild(objRewards, strKey)
		if objIcon then
			kItemBaseData = kItemMgr:GetItemTypeDataByTypeID(aiReward[index] or 0)
			if not kItemBaseData then
				objIcon:SetActive(false)
			else
				iNum = aiRewardNum[index] or 0
				self.kItemIconUIInst:UpdateUIWithItemTypeData(objIcon, kItemBaseData)
				self.kItemIconUIInst:SetItemNum(objIcon, iNum, iNum <= 1 )
				objIcon:SetActive(true)
			end
		end
	end

	-- 设置收集栏
	local bCanExchange = true  -- 可兑换
	local bSingleEnough = true
	local uiCollectNum, uiCollectNeed = 0, 0
	local kResDropActivityMgr = ResDropActivityDataManager:GetInstance()
	local aiCollect = kTaskBaseData.TarItemIDs or {}
	local aiCollectNum = kTaskBaseData.TarNums or {}
	for index, strKey in ipairs(COLLECT_KEY) do
		objIcon = self:FindChild(objCost, strKey)
		if objIcon then
			kItemBaseData = kItemMgr:GetItemTypeDataByTypeID(aiCollect[index] or 0)
			if not kItemBaseData then
				objIcon:SetActive(false)
			else
				-- 获取物品使用效果中指定的资产的数值
				uiCollectNum = kResDropActivityMgr:GetAssetValueByGameDataType(kItemBaseData.GameData)
				uiCollectNeed = aiCollectNum[index] or 0
				bSingleEnough = uiCollectNum >= uiCollectNeed
				if not bSingleEnough then
					bCanExchange = false
				end
				self.kItemIconUIInst:UpdateUIWithItemTypeData(objIcon, kItemBaseData)
				local strColorTag = bSingleEnough and "<color=#81c96e>" or "<color=#ed5653>"
				local strNum = string.format("%s%d</color>/%d", strColorTag, uiCollectNum, uiCollectNeed)
				self.kItemIconUIInst:SetItemNum(objIcon, strNum, false)
				objIcon:SetActive(true)
			end
		end
	end

	-- 设置兑换次数
	if not self.kTaskExchangeNum then
		self.kTaskExchangeNum = {}
	end
	local uiHasExchangedNum = self.kTaskExchangeNum[uiTaskBaseID] or 0
	local uiMaxExchangeNum = kTaskBaseData.ExchangeNum or 0
	local textExchangeDesc = self:FindChildComponent(objExchange, "Limit", l_DRCSRef_Type.Text)
	textExchangeDesc.text = string.format("每日次数: %d/%d", uiHasExchangedNum, uiMaxExchangeNum)

	-- 设置化兑换目标
	if not self.kExchangeTarget then
		self.kExchangeTarget = {}
	end
	local btnExchange = self:FindChildComponent(objExchange, "Btn", l_DRCSRef_Type.Button)
	if not self.kExchangeTarget[btnExchange] then
		self.RemoveButtonClickListener(btnExchange)
		self:AddButtonClickListener(btnExchange, function()
			self:OnClickExchangeBtn(btnExchange)
		end)
	end
	self.kExchangeTarget[btnExchange] = uiTaskIndex

	-- 设置兑换按钮状态
	local bHasExchangeTimes = (uiHasExchangedNum < uiMaxExchangeNum)  -- 是否达到最大兑换上限
	local bBtnExchangeEnable = (bCanExchange and bHasExchangeTimes)
	btnExchange.interactable = bBtnExchangeEnable
	local objBtnExchangeOn = self:FindChild(objExchange, "Btn/On")
	local objBtnExchangeOff = self:FindChild(objExchange, "Btn/Off")
	objBtnExchangeOn:SetActive(bBtnExchangeEnable)
	objBtnExchangeOff:SetActive(not bBtnExchangeEnable)
end

function CollectActivityUI:OnClickExchangeBtn(btnExchange)
	if not self.kExchangeTarget then
		return
	end
	local uiCollectActivityIndex = self.kExchangeTarget[btnExchange]
	if not uiCollectActivityIndex then
		return
	end
	local strMsg = string.format("确定消耗材料兑换此奖励吗?")
	local uiCurResDropActivityID = self.uiCurResDropActivityID 
	local funcCallback = function()
		SendRequestExchangeCollectActivity(uiCurResDropActivityID, uiCollectActivityIndex)
	end
	OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, funcCallback})
end

function CollectActivityUI:OnDestroy()
	self.kItemIconUIInst:Close()
end

return CollectActivityUI