DifficultyUI = class("DifficultyUI",BaseWindow)

local Jar2 = false;
local maxDiff = 30;

function DifficultyUI:ctor()

end

function DifficultyUI:OnPressESCKey()
	if self.comReturn_Button then
		self.comReturn_Button.onClick:Invoke();
	end
end

function DifficultyUI:Create()
	local obj = LoadPrefabAndInit("Create/DifficultyUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function DifficultyUI:Init()
	self.objlist = self:FindChild(self._gameObject, "nav_box/SC_list")
	-- 滚动栏的回调
	self.comList_Scroller = self.objlist:GetComponent(typeof(CS.FancyScrollView.FancyScroller))
	if self.comList_Scroller then
		local fun = function(index)
			self:OnSectionChanged(index)
		end
		self.comList_Scroller:SetLuaFunction(fun)
	end
	-- 滚动栏拖拽结束回调
	self.comList_Scroller:SetOnDragEndLuaFunction(function(idx)
		self:OnScrollToBottom(idx)
	end)
	-- cell 的回调
	self.comList_ScrollView = self.objlist:GetComponent(typeof(CS.FancyScrollView.ScrollView))
	if self.comList_ScrollView then
		local fun = function(cell, idx)
			self:OnScrollChanged(cell, idx)
        end
		self.comList_ScrollView:SetLuaFunction(fun)
	end

	-- 返回按钮
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"TransformAdapt_node_left/Button_back","Button")
	if self.comReturn_Button then
		local fun = function()
			self:OnClick_Return_Town_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
    end

	-- 确定按钮
	self.objSubmit_Button = self:FindChild(self._gameObject, "Button_submit")
    self.comSubmit_Button = self.objSubmit_Button:GetComponent("Button")
	if self.comSubmit_Button then
		local fun = function()
			self:OnClick_Submit_Town_Button()
		end
		self:AddButtonClickListener(self.comSubmit_Button,fun)
	end

	-- 解锁完整版按钮
	self.objBtnChallengeLock = self:FindChild(self._gameObject, "Button_ChallengeOrderLock")
	self.comBtnChallengeLock_Button = self.objBtnChallengeLock:GetComponent("Button")
	if (self.comBtnChallengeLock_Button) then
		local fun = function()
			OpenWindowImmediately("ChallengeOrderUI")
		end

		self:AddButtonClickListener(self.comBtnChallengeLock_Button,fun)
	end

	-- 信息栏
	self.objTextTips = self:FindChild(self._gameObject, "Text_Tips")
	self.objMsgScv = self:FindChild(self._gameObject, "content_box/item_box")
    self.objMsgContent = self:FindChild(self.objMsgScv, "Viewport/Content")
	self.objExtraDescTemp = self:FindChild(self.objMsgScv, "Viewport/ExtraDesc")
	self.objAttrDescTemp = self:FindChild(self.objMsgScv, "Viewport/AttrDesc")
	self.objExtraDescTemp:SetActive(false)
	self.objAttrDescTemp:SetActive(false)

	self.objTips = self:FindChild(self._gameObject, "content_box/tips")
	self.comObjTips = self.objTips:GetComponent("Text")

	self.objBtnBuyUnlock = self:FindChild(self._gameObject, "content_box/BuyUnlock")
	self.textBuyUnlock = self:FindChildComponent(self.objBtnBuyUnlock, "Text", "Text")
	self.textBuyUnlockPrice = self:FindChildComponent(self.objBtnBuyUnlock, "Number", "Text")
	local btnBuyUnlock = self.objBtnBuyUnlock:GetComponent("Button")
	self:AddButtonClickListener(btnBuyUnlock, function()
		self:OnClickBuyUnlock()
	end)

	self:AddEventListener("QUERY_STORY_RET", function() self.bNeedRefresh = true end)
	self:AddEventListener("CHALLENGEORDER_UNLOCK", function() self.bNeedRefresh = true end)
end

function DifficultyUI:OnEnable()
	--暂时把动画放到这里

	-- --难度选择
	self.objlist.transform.parent.transform:DOKill()
	self.objlist.transform.parent.transform:DOLocalMoveY(480,0.3):From():SetEase(DRCSRef.Ease.OutQuad)
	--右边信息栏子
	self:FindChild(self._gameObject, "content_box").transform:DOKill()
	self:FindChild(self._gameObject, "content_box").transform:DOLocalMoveX(1218,0.2):From():SetEase(DRCSRef.Ease.OutQuad):SetDelay(0.2)
	--按钮
	self:FindChild(self._gameObject, "Button_submit").transform:DOKill()
	self:FindChild(self._gameObject, "Button_submit").transform:DOLocalMoveX(942,0.2):From():SetEase(DRCSRef.Ease.OutQuad):SetDelay(0.2)

end

function DifficultyUI:Update()
	if self.bNeedRefresh then
		self:RefreshUI()
		self.bNeedRefresh = false
	end
end

function DifficultyUI:RefreshUI()
	self.tbSysOpenData = TableDataManager:GetInstance():GetSystemOpenByType(SystemType.SYST_ScriptDiff);

	-- 获取当前难度
	-- 生成难度个数的数量为 全部
	local maxDiff = 30
	local minDiff = 1
	local storyData = TableDataManager:GetInstance():GetTableData("Story", GetCurScriptID())
	if storyData then
		maxDiff = storyData.DifficultMax
		minDiff = storyData.DifficultMin
	end
	self.storyMinDiff = minDiff
	self.storyMaxDiff = maxDiff
	self.curDiff = self:GetUnlockDiff()

	-- 错误,未达到剧本指定解锁难度
	if self.curDiff < minDiff then
		self.curDiff = minDiff
	end

	-- 显示所有难度
	local showNum = maxDiff
	if (IsGameServerMode() == false) then
		self.selectdiff = 1
	else
		self.selectdiff = self.curDiff
	end
	self.comList_ScrollView:UpdateScroll(showNum, self.selectdiff - minDiff)
	-- if (self.curDiff == 1) then
	-- 	self.comList_ScrollView.iMaxClickAbleIndex = 0
	-- end
	self.comList_Scroller.Draggable = self.curDiff ~= 1
end

-- 滚动栏触底检查
function DifficultyUI:OnScrollToBottom(idx)
	-- 当滚动超过当前难度时, 弹回
	local diff = idx + self.storyMinDiff
	if diff > self.curDiff then
		self.comList_Scroller:ScrollTo(self.curDiff - 1, 0.3)
	end
end

-- 玩家点击滚动栏后，每个显示的 Child 都会进行更新。
function DifficultyUI:OnScrollChanged(cell, idx)
	local objDark = self:FindChild(cell,"box/dark")
	local objChoose = self:FindChild(cell,"box/choose")
	local objLight = self:FindChild(cell,"box/light")
	local objLock = self:FindChild(cell,"box/lock")
	local comDarkLevelText = self:FindChildComponent(objDark,"Text","Text")
	local comLightLevelText = self:FindChildComponent(objLight,"Text","Text")
	local diff = idx + self.storyMinDiff
	if self.selectdiff == diff then
		objDark:SetActive(false)
		objChoose:SetActive(true)
		objLight:SetActive(true)
		self:SetDetail()
	else
		objDark:SetActive(true)
		objChoose:SetActive(false)
		objLight:SetActive(false)
	end
	comDarkLevelText.text = string.format("%d",diff)
	comLightLevelText.text = string.format("%d",diff)

	if (self.curDiff >= diff) then
		objLock:SetActive(false)
	else
		objLock:SetActive(true)
	end

	-- 设置右侧的难度系数详细数据
	self:SetDetail()
end

-- 设置右侧的详细信息，包括解锁内容，难度，并且需要与上一级的难度进行比较
function DifficultyUI:SetDetail()
	RemoveAllChildren(self.objMsgContent)
	-- 如果当前等级大于1级(selectdiff > 0), 则获取上一等级
	-- 注意, TB_Difficult索引从1开始, self.selectdiff从1开始
	local tbDiffPre = nil
	if self.selectdiff > 1 then
		tbDiffPre = StoryDataManager:GetInstance():GetStoryDifficultData(GetCurScriptID(), self.selectdiff - 1)
	end
	local tbDiff = StoryDataManager:GetInstance():GetStoryDifficultData(GetCurScriptID(), self.selectdiff)
	if (tbDiff == nil) then
		return
	end
	-- 如果当前难度有额外描述信息, 先生成额外描述信息
	if tbDiff.ExtraMsgs and (#tbDiff.ExtraMsgs > 0) then
		local objClone = nil
		local comTextClone = nil
		for index, iLangID in ipairs(tbDiff.ExtraMsgs) do
			-- 生成组件
			objClone = CloneObj(self.objExtraDescTemp, self.objMsgContent)
			if (objClone ~= nil) then
				comTextClone = self:FindChildComponent(objClone, "Text", "Text")
				comTextClone.text = GetLanguageByID(iLangID) or ""
				objClone:SetActive(true)
			end
		end
	end
	-- 随后生成数值变化信息, 这里给定了需要显示哪些属性的变动以及对应的名称
	local attrAndNameList = {
		{
			['key'] = "NumberUp",
			['text'] = "敌人数值",
			['showAsPercent'] = true
		},
		{
			['key'] = "RoleLvMax",
			['text'] = "角色等级上限",
		},
		{
			['key'] = "MartialNumMax",
			['text'] = "武学数量上限",
		},
		{
			['key'] = "GiftCountMax",
			['text'] = "天赋数量上限",
		},
		{
			['key'] = "EatFoodCountMax",
			['text'] = "食物使用数量上限",
		},
		{
			['key'] = "MarryCountMax",
			['text'] = "誓约人数上限",
		},
		{
			['key'] = "EquipLvMax",
			['text'] = "出现装备最高等级",
		},
		{
			['key'] = "BagMax",
			['text'] = "背包格上限",
		},
	}
	-- 将所有值与旧值进行比较并对生成组件
	local curValue = 0
	local preValue = 0
	local objClone = nil
	local comTextClone = nil
	local color_same = getUIColor('black')
	local color_new = getUIColor('green')
	local showColor = nil
	local key = nil
	local sName = nil
	for index, data in ipairs(attrAndNameList) do
		key = data.key
		sName = data.text
		-- 获取值
		curValue = tbDiff[key] or 0
		if tbDiffPre then
			preValue = tbDiffPre[key] or 0
		else
			preValue = curValue
		end
		-- 当前等级值与上一级一样的部分显示为黑色, 不一样的部分显示为绿色
		if curValue == preValue then
			showColor = color_same
		else
			showColor = color_new
		end
		-- 生成组件
		objClone = CloneObj(self.objAttrDescTemp, self.objMsgContent)
		if (objClone ~= nil) then
			-- 组件颜色
			comTextClone = self:FindChildComponent(objClone, "Text_Value", "Text")
			comTextClone.color = showColor
			-- 组件值
			if data.showAsPercent == true then
				comTextClone.text = string.format("%.0f%%", curValue / 100)
			else
				comTextClone.text = string.format("%d", curValue)
			end
			-- 组件名称
			comTextClone = self:FindChildComponent(objClone, "Text_Name", "Text")
			comTextClone.text = sName or ""
			objClone:SetActive(true)
		end
	end
	-- 如果当前难度未解锁, 不显示下一步按钮, 显示解锁提示
	local bCurDiffIsUnlock = (self.selectdiff <= self.curDiff)
	self.objSubmit_Button:SetActive(bCurDiffIsUnlock)
	-- 设置提示文字与显示状态
	self.objTips:SetActive(false)
	self.objBtnBuyUnlock:SetActive(false)
	self.objBtnChallengeLock:SetActive(false)
	self.objTextTips:SetActive(false)
	if not bCurDiffIsUnlock then
		if (self.selectdiff > self:GetCurDiff()) then
			self.objTextTips:SetActive(true)
		else
			if self:IsChallengeOrderLockDiff(self.selectdiff) then
				self.objBtnChallengeLock:SetActive(true)
			else
				self.comObjTips.text = string.format("通关难度%d后，将解锁难度%d", self.selectdiff - 1, self.selectdiff)
				self.objTips:SetActive(true)
				-- 显示难度解锁按钮, 最高只支持解锁到难度 SSD_MAX_SILVER_UNLOCK_SCRIPT_DIFF
				if self.selectdiff <= (SSD_MAX_SILVER_UNLOCK_SCRIPT_DIFF or 0) then
					self.textBuyUnlock.text = string.format("提前解锁难度%d", self.selectdiff)
					self.textBuyUnlockPrice.text = SSD_BUY_UNLOCK_NEXT_DIFF_SILVER_NUM or 9999
					self.objBtnBuyUnlock:SetActive(false)
				end
			end
		end
	end
end

-- 滚动视图定位到 某一个难度时，回调（设置当前难度）。
function DifficultyUI:OnSectionChanged(idx)
	if not idx then return end
	-- 如果当前idx大于当前难度 + 1, 关闭scroller并赋值
	-- 如果当前idx大于当前难度 + 2, 不响应
	-- 否则, 激活scroller并赋值
	if idx == self.curDiff then
		-- self.comList_Scroller.enabled = false
	elseif idx > self.curDiff then
		--return 直接查看到难度1-难度5的所有解锁内容
	else
		self.comList_Scroller.enabled = true
	end
	self.selectdiff = idx + self.storyMinDiff
	self:SetDetail()
end

function DifficultyUI:OnClick_Return_Town_Button()
	if not StoryDataManager:GetInstance():GetSpecialCreateRole() then
		OpenWindowByQueue("CreateRoleUI")
		RemoveWindowImmediately("DifficultyUI")
	else
		-- 无选择创角的剧本直接退出
		SendClickQuitStoryCMD()
	end
end

function DifficultyUI:OnClick_Submit_Town_Button()
	if self.diffError then
		return
	end

	-- 设置当前选择的难度
	if (self.curDiff < self.selectdiff) then
		SystemUICall:GetInstance():Toast("当前难度未解锁")
		return
	end
	g_selectStoryDiff = self.selectdiff
	OpenWindowByQueue("AchieveRewardUI")
    RemoveWindowImmediately("DifficultyUI")
end

function DifficultyUI:OnDestroy()

end

function DifficultyUI:GetCurDiff(time)
	local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
	local tempTable = {};
	for i = 1, #(self.tbSysOpenData) do
		if self.tbSysOpenData[i].OpenTime <= time then
			table.insert(tempTable, self.tbSysOpenData[i]);
		end
	end

	if #(tempTable) == 0 then
		return self.storyMaxDiff or maxDiff;
	end

	local tempDiff = 5;
	for i = 1, #(tempTable) do
		tempDiff = tempTable[i].Param1;
	end

	return tempDiff;
end

function DifficultyUI:GetUnlockDiff()
	if (IsGameServerMode() == false) then
		return self.storyMaxDiff or maxDiff
	end
	local storyID = GetCurScriptID()
	local curDiff = PlayerSetDataManager:GetInstance():GetMaxStoryUnlockDiff()

	-- 当前难度上限判断
	if curDiff > self:GetChallengeOrderLimitDiff() then
		curDiff = self:GetChallengeOrderLimitDiff()
	end
	-- 当前难度不应该小于1
	if (curDiff <= 0) then
		curDiff = 1
	end

	-- TODO Jar2 需求最多只能解锁难度5
	if curDiff >= self:GetCurDiff() then
		curDiff = self:GetCurDiff();
	end

	return curDiff
end

function DifficultyUI:GetChallengeOrderLimitDiff()
	local TB_PlusEditionConfig = TableDataManager:GetInstance():GetTable("PlusEditionConfig")
	if not TB_PlusEditionConfig then
		return 1
	end

	if PlayerSetDataManager:GetInstance():IsChallengeOrderUnlock() then
		return self.storyMaxDiff or maxDiff
	end

	return TB_PlusEditionConfig[1].DifficultLimit
end

function DifficultyUI:IsChallengeOrderLockDiff(diff)
	local limit = self:GetChallengeOrderLimitDiff()
	return diff > limit
end

-- 花费银锭提前解锁难度
function DifficultyUI:OnClickBuyUnlock()
	local msg = string.format("花费%d银锭, 提前解锁难度%d?", SSD_BUY_UNLOCK_NEXT_DIFF_SILVER_NUM or 9999, self.selectdiff)
	local boxCallback = function()
		local curStoryID = GetCurScriptID()
		if (not curStoryID) or (curStoryID == 0) then
			return
		end
		PlayerSetDataManager:GetInstance():RequestSpendSilver(SSD_BUY_UNLOCK_NEXT_DIFF_SILVER_NUM, function()
			local iTarScriptId = curStoryID
			SendClickBuyStoryDiff(iTarScriptId)
		end)
	end
	OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback})
end


return DifficultyUI