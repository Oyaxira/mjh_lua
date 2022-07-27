DreamStoryUI = class("DreamStoryUI",BaseWindow)

function DreamStoryUI:ctor()

end

function DreamStoryUI:Create()
	local obj = LoadPrefabAndInit("TownUI/StorySpecialRoleUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function DreamStoryUI:Init()
    self.comDelete_Button = self:FindChildComponent(self._gameObject, 'Bottom_panel/Button_delete', 'DRButton')
	self.comStart_Button = self:FindChildComponent(self._gameObject, 'Bottom_panel/Button_start', 'DRButton')
	self.comBuy_Button = self:FindChildComponent(self._gameObject, 'Bottom_panel/Button_buy', 'DRButton')
	self.comReturn_Button = self:FindChildComponent(self._gameObject,"Button_back","Button")
	self.comBuy_Text = self:FindChildComponent(self._gameObject,"Bottom_panel/Button_buy/Number","Text")
	self.objDesc = self:FindChild(self._gameObject, 'Bottom_panel/SC_StoryDesc/Viewport/Content')
	self.comIntroduce_Text = self:FindChildComponent(self.objDesc, 'Introduce/Text', 'Text')
	self.comIntroduceLabel_Text = self:FindChildComponent(self.objDesc, 'Introduce/Label', 'Text')
	self.objRewardContent = self:FindChild(self.objDesc, 'TimeAndReward/Content_reward')
	self.comRewardLabel_Text = self:FindChildComponent(self.objDesc, 'TimeAndReward/Label', 'Text')

	self.rowStoryCount = 6
	self.comLoopScroll = self:FindChildComponent(self._gameObject, 'SC_Books', 'LoopVerticalScrollRect')
	self.comLoopScroll:AddListener(function(...) self:UpdateRowItemUI(...) end)

	self.akItemUIClass = {}

	self.dreamStoryIDs = {}
	self.selectStoryID = nil
	self.playingStoryID = nil

	if self.comDelete_Button then
		local fun = function()
			self:OnClick_Delete_Button(self.selectStoryID)
		end
		self:AddButtonClickListener(self.comDelete_Button,fun)
	end
	if self.comStart_Button then
		local fun = function()
			self:OnClick_Start_Button(self.selectStoryID)
		end
		self:AddButtonClickListener(self.comStart_Button,fun)
    end
	if self.comReturn_Button then
		local fun = function()
			self:OnClick_Return_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
	end
	if self.comBuy_Button then
		local fun = function()
			self:OnClick_Buy_Button(self.selectStoryID)
		end
		self:AddButtonClickListener(self.comBuy_Button,fun)
	end

	self:AddEventListener("DELETE_STORY_RET", function(info)
		self:DeleteStory(info)
		self.bNeedRefresh = true
	end)
	self:AddEventListener("QUERY_STORY_RET", function()
		self.bNeedRefresh = true
	end)
end

function DreamStoryUI:Update()
	if not self.bNeedRefresh then
		return
	end
	self.bNeedRefresh = false

	self:UpdateDreamStoryIDs()
	self:UpdateStoryRows()

	if self.selectStoryID then
		self:SelectStoryItem(self.selectStoryID)
	else
		self:SelectStoryItem(self.dreamStoryIDs[1])
	end
end

function DreamStoryUI:RefreshUI()
	self:UpdateDreamStoryIDs()
	self:UpdateStoryRows()

	if self.playingStoryID then
		self:SelectStoryItem(self.playingStoryID)
	else
		self:SelectStoryItem(self.dreamStoryIDs[1])
	end
end

function DreamStoryUI:UpdateStoryRows()
	local rowCount = math.floor((#self.dreamStoryIDs - 1) / self.rowStoryCount) + 1
	if rowCount < 3 then
		rowCount = 3
	end
	self.comLoopScroll.totalCount = rowCount
end

function DreamStoryUI:ReturnUIClass()
	if #self.akItemUIClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
		self.akItemUIClass = {}
	end
end

function DreamStoryUI:UpdateDreamStoryIDs()
	local storyDatas = TableDataManager:GetInstance():GetTable("Story")
	self.dreamStoryIDs = {}
	self.dreamStoryDatas = {}
	self.playingStoryID = nil

	if storyDatas then
		for _, storyData in pairs(storyDatas) do
			if storyData.IsDreamStory == TBoolean.BOOL_YES then
				if (DEBUG_MODE == true) or storyData.IsPublic == TBoolean.BOOL_YES then
					table.insert(self.dreamStoryDatas, storyData)
					if self:IsPlayingStory(storyData.BaseID) then
						self.playingStoryID = storyData.BaseID
					end
				end
			end
		end
	end

	function GetStorySortValue(storyData)
		local baseID = storyData.BaseID
		local val = 0

		if baseID == self.playingStoryID then
			val = val + 100000
		end

		if self:IsStoryUnlock(baseID) then
			val = val + 10000
		end

		val = val + 1000 - storyData.SortIndex
		return val
	end

	table.sort(self.dreamStoryDatas, function(storyData1, storyData2)
		local val1 = GetStorySortValue(storyData1)
		local val2 = GetStorySortValue(storyData2)

		return val1 > val2
	end)

	for index, storyData in ipairs(self.dreamStoryDatas) do
		self.dreamStoryIDs[index] = storyData.BaseID
	end
end

function DreamStoryUI:UpdateRowItemUI(transform, index)
	if transform == nil then
		return
	end
	local comConten_Transform = self:FindChild(transform.gameObject, 'Books').transform

	local childCount = comConten_Transform.childCount
	local objStoryItem = nil
	if childCount <= 0 then
		return
	end
	objStoryItem = comConten_Transform:GetChild(0).gameObject
	for idx = childCount + 1, self.rowStoryCount do
		CloneObj(objStoryItem, comConten_Transform)
	end

	for idx = 1, self.rowStoryCount do
		self:UpdateStoryItem(comConten_Transform:GetChild(idx - 1).gameObject, index * self.rowStoryCount + idx)
	end

	local objTop = self:FindChild(transform.gameObject, 'woods/top')
	objTop:SetActive(index == 0)
end

function DreamStoryUI:IsStoryUnlock(storyID)
	return PlayerSetDataManager:GetInstance():IsUnlockStory(storyID) == true
end

function DreamStoryUI:UpdateStoryItem(objStoryItem, index)
	local objButtonStory = self:FindChild(objStoryItem, 'Button_Story')
	local comBtnStory_Button = self:FindChildComponent(objStoryItem, 'Button_Story', 'DRButton')
	local objBottom = self:FindChild(objStoryItem, 'Image_bottom')
	local objLockName = self:FindChild(objStoryItem, 'Image_name')
	local comLockName_Text = self:FindChildComponent(objStoryItem, 'Image_name/Text', 'Text')
	local objLock = self:FindChild(objStoryItem, 'Image_lock')
	local objUnknown = self:FindChild(objStoryItem, 'Image_unknown')
	local objActive = self:FindChild(objStoryItem, 'Image_active')
	local comRole_Image = self:FindChildComponent(objStoryItem, 'Image_active/Image_role', 'Image')
	local comName_Text = self:FindChildComponent(objStoryItem, 'Image_active/Text_name', 'Text')
	local objSelect = self:FindChild(objStoryItem, 'Image_select')
	local objLockSelect = self:FindChild(objStoryItem, 'Image_select_lock')
	local objFinish = self:FindChild(objStoryItem, 'Image_finish')

	local storyID = self.dreamStoryIDs[index]
	local storyData = nil
	if storyID then
		storyData = TableDataManager:GetInstance():GetTableData("Story", storyID)
	end

	if storyID == nil or storyData == nil then
		objButtonStory:SetActive(false)
		objBottom:SetActive(true)
		objLockName:SetActive(true)
		comLockName_Text.text = '未知'
		objLock:SetActive(false)
		objUnknown:SetActive(true)
		objActive:SetActive(false)
		objSelect:SetActive(false)
		objLockSelect:SetActive(false)
	elseif not self:IsStoryUnlock(storyID) then
		objButtonStory:SetActive(true)
		objBottom:SetActive(true)
		objLockName:SetActive(true)
		comLockName_Text.text = GetLanguageByID(storyData.NameID)
		objLock:SetActive(true)
		objUnknown:SetActive(false)
		objActive:SetActive(false)
		objSelect:SetActive(false)
		objLockSelect:SetActive(self.selectStoryID == storyID)
	else
		objButtonStory:SetActive(true)
		objBottom:SetActive(false)
		objLockName:SetActive(false)
		objLock:SetActive(false)
		objUnknown:SetActive(false)
		objActive:SetActive(true)
		objLockSelect:SetActive(false)
		if storyData.DreamStoryRole > 0 then
			local modelData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(storyData.DreamStoryRole)
			if (modelData) then
				comRole_Image.sprite = GetSprite(modelData.Head)
			end
		end
		comName_Text.text = GetLanguageByID(storyData.NameID)
		objSelect:SetActive(self.selectStoryID == storyID)
	end

	if objFinish then
		local finish = IsOveredStory(storyID)
		objFinish:SetActive(finish)
	end

	self:RemoveButtonClickListener(comBtnStory_Button)
	self:AddButtonClickListener(comBtnStory_Button,function()
		self:SelectStoryItem(storyID)
	end)
end

function DreamStoryUI:SelectStoryItem(storyID)
	local storyData = nil
	if storyID then
		storyData = TableDataManager:GetInstance():GetTableData("Story", storyID)
	end

	if storyData == nil then
		return
	end

	local ItemDataMgrInst =  ItemDataManager:GetInstance()

	self.comRewardContent_Transform = self:FindChild(self.objDesc, 'TimeAndReward/Content_reward').transform

	self:ReturnUIClass()

	local isUnlock = self:IsStoryUnlock(storyID)
	if isUnlock then
		self.comIntroduceLabel_Text.text = "【剧本介绍】"
		self.comIntroduce_Text.text = GetLanguageByID(storyData.DescID)
	else
		self.comIntroduceLabel_Text.text = "【解锁方式】"
		self.comIntroduce_Text.text = GetLanguageByID(storyData.UnlockID)
	end


	if not IsOveredStory(storyID) then
		if storyData.FirstStoryReward and next(storyData.FirstStoryReward) then
			self.comRewardLabel_Text.text = "【首通奖励】"
			for index = 1,#storyData.FirstStoryReward do
				local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.RewardItemIconUI,self.comRewardContent_Transform)
				local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(storyData.FirstStoryReward[index])
				local itemNums = storyData.FirstStoryRewardNum[index]
				kItem:UpdateUIWithItemTypeData(itemTypeData)
				kItem:SetFirstStory(true)
				kItem:SetItemNum(itemNums, itemNums == 1)
				self.akItemUIClass[#self.akItemUIClass+1] = kItem
			end
		end
	else
		if storyData.StoryReward and next(storyData.StoryReward) then
			self.comRewardLabel_Text.text = "【通关奖励】"
			for index = 1,#storyData.StoryReward do
				local kItem =  LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.RewardItemIconUI,self.comRewardContent_Transform)
				local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(storyData.StoryReward[index])
				local itemNums = storyData.StoryRewardNum[index]
				kItem:UpdateUIWithItemTypeData(itemTypeData)
				kItem:SetFirstStory(false)
				kItem:SetItemNum(itemNums, itemNums == 1)
				self.akItemUIClass[#self.akItemUIClass+1] = kItem
			end
		end
	end

	if isUnlock then
		self.comBuy_Button.gameObject:SetActive(false)
		self.comStart_Button.gameObject:SetActive(true)
	else
		local unlockCost = self:GetStoryUnlockCost(storyID)
		if unlockCost and unlockCost > 0 then
			self.comBuy_Button.gameObject:SetActive(true)
			self.comBuy_Text.text = tostring(unlockCost)
		else
			self.comBuy_Button.gameObject:SetActive(false)
		end

		self.comStart_Button.gameObject:SetActive(false)
	end

	if not self:IsPlayingStory(storyID) then
		self.comDelete_Button.gameObject:SetActive(false)
		-- 如果删档按钮不需要显示, 说明是新档, 那么清除一些标记
		self:ClearScriptTags(storyID)
	else
		self.comDelete_Button.gameObject:SetActive(true)
	end

	self.selectStoryID = storyID

	self.comLoopScroll:RefillCells()
end

function DreamStoryUI:IsPlayingStory(storyID)
	return not PlayerSetDataManager:GetInstance():IsEmptyScript(storyID)
end

function DreamStoryUI:OnClick_Buy_Button(uiStoryID)
	local gameMode = globalDataPool:getData("GameMode")
	if (gameMode ~= "ServerMode") then
		return
	end

	local storyData = nil
	if uiStoryID then
		storyData = TableDataManager:GetInstance():GetTableData("Story", uiStoryID)
	end

	if storyData == nil then
		return nil
	end

	PlayerSetDataManager:GetInstance():RequestSpendSilver(storyData.UnlockCost, function()
		local tipStr = string.format("是否花费%d银锭解锁此剧本？", storyData.UnlockCost)
		OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, tipStr, function()
			SendUnlockStory(uiStoryID)
			self.comBuy_Button.gameObject:SetActive(false)
		end})
	end)

end

function DreamStoryUI:GetStoryUnlockCost(storyID)
	local storyData = nil
	if storyID then
		storyData = TableDataManager:GetInstance():GetTableData("Story", storyID)
	end

	if storyData == nil then
		return nil
	end

	if storyData.UnlockType == StoryUnlockType.SUT_FLAG and storyData.UnlockCost > 0 then
		return storyData.UnlockCost
	end
end

function DreamStoryUI:OnClick_Return_Button()
	RemoveWindowImmediately("DreamStoryUI")
	OpenWindowImmediately("StoryUI")
end

-- TODO:合并StoryUI相同逻辑
local Warning = '请问您是否要删除本存档？此操作不可取消。' ..
                '若本存档的游戏已开始，将进入周目结算界面<color=red>结束当前剧本的游戏进度，自动结算经脉并带出指定物品</color>，' ..
                '要继续吗？'

function DreamStoryUI:ClearScriptTags(storyID)
	-- 清除城市动画播放标记
	local TB_MapPoem = TableDataManager:GetInstance():GetTable("MapPoem")
	for _, data in pairs(TB_MapPoem) do
		local checkKey = string.format("CityAnim_%s_%s", storyID, data.MapID)
		SetConfig(checkKey, 0)
	end
end

function DreamStoryUI:OnClick_Start_Button(uiStoryID)
	local gameMode = globalDataPool:getData("GameMode")
	if (gameMode ~= "ServerMode") then
		return
	end

	if self.playingStoryID and self.playingStoryID ~= uiStoryID then
		local playingStoryData = TableDataManager:GetInstance():GetTableData("Story", self.playingStoryID)
		if playingStoryData then
			local storyName = GetLanguageByID(playingStoryData.NameID) or "剧本"

			local content = {};
			content.title = '系统提示'
			content.rightBtnText = '跳转'
			content.leftBtnText = '取消'
			content.text = string.format('您之前玩的《%s》有存档记录，是否跳转到该剧本？', storyName)

			local _callback = function()
				self:SelectStoryItem(self.playingStoryID)
			end
			OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, content, _callback })
			return
		end
	end
	-- 单机版不需要判断带出次数
	-- if self:EnterScriptCheckTakeOutLimit(uiStoryID) then
	-- 	return
	-- end

	EnterStory(uiStoryID, false, false, true)
end

function DreamStoryUI:EnterScriptCheckTakeOutLimit(curStoryID)
	if not self.submitTakeOutLimit and self:IsWeekTakeOutLimit(curStoryID) then
		local limit = 0
		local storyData = TableDataManager:GetInstance():GetTableData("Story", curStoryID)
		if storyData then
			limit = storyData.WeekTakeOutLimit
		end

		local msg = "当前剧本每周可结算带出"..limit.."次，您当前的带出次数已用尽，您可以选择玩其他的剧本，也可以等待每周日24点，带出次数重置后再继续"
		OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, nil, {confirm = true}})

		return true
	else
		self.submitTakeOutLimit = false
		return false
	end
end

function DreamStoryUI:IsWeekTakeOutLimit(uiStoryID)
	local iNum = PlayerSetDataManager:GetInstance():GetStoryWeekTakeOutNum(uiStoryID)
	if not iNum or iNum == 0 then
		return false
	end

	local storyData = TableDataManager:GetInstance():GetTableData("Story", uiStoryID)
	if not storyData then
		return false
	end

	return iNum >= storyData.WeekTakeOutLimit
end

function DreamStoryUI:OnClick_Delete_Button(uiStoryID)
	local _callback = function()
		SendClickDelStoryCMD(uiStoryID)
		-- self.comDelete_Button.gameObject:SetActive(false)
		-- self.playingStoryID = nil
	end

	--再想想 绿色 右 认输 红色 左
	local showContent = {
		['title'] = '提示',
		['text'] = Warning,
		['leftBtnText'] = '删档',
		['rightBtnText'] = '再想想',
		['leftBtnFunc'] = function()
		_callback()
		end
	}
	if DEBUG_MODE then
		showContent.leftBtnText = '删档(DEBUG)'
	end

	OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.DELETE_SCRIPT, showContent, nil})
end

function DreamStoryUI:DeleteStory(uiStoryID)
	local playerinfo = globalDataPool:getData("PlayerInfo")
	if not playerinfo then return true end	-- 单机没有 info 数据
	for i = 0, playerinfo.iSize - 1 do
		if (playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == uiStoryID) then
			playerinfo.kUnlockScriptInfos[i]["dwScriptTime"] = 0
			playerinfo.kUnlockScriptInfos[i]["eStateType"] = SSS_NULL
		end
    end
    self.comDelete_Button.gameObject:SetActive(false)
    self.playingStoryID = nil
end

return DreamStoryUI