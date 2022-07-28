BornChooseUI = class("BornChooseUI",BaseWindow)

-- 引言文字
local IntrosWords = {
	"漫漫江湖，各式侠客来来往往，有侠骨柔肠者，有侠肝义胆者，亦有#任财轻侠者...",
	"不知对大侠您来说，侠客应该是一个怎样的人？也许区区几个问题，#足以窥知大侠的内心想法。",
	"从心而答即可，这些奖励并非唯一，它们都可在游戏中获得。",
}
-- 引言触发语音
local IntroAutioEvents = {
	"EventQuestion1",
	"EventQuestion2",
	"EventQuestion3",
}
-- 抓周结果展示语音
local ChooseResultAudioID = 10019
-- 开始创角语音
local StartCreateAudioID = 10020

function BornChooseUI:Create()
	local obj = LoadPrefabAndInit("Game/BornChooseUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function BornChooseUI:Init()
	-- 引言
	self.objIntroduction = self:FindChild(self._gameObject, "Introduction")
	self.objIntroduction:SetActive(true)
	self.objIntroLineTemp = self:FindChild(self.objIntroduction, "LineTemp")
	self.objIntroWords = self:FindChild(self.objIntroduction, "Words")
	self.objIntroBtns = self:FindChild(self.objIntroduction, "Btns")
	self.objIntroBtnNext = self:FindChild(self.objIntroBtns, "Next")
	self.objIntroBtnStart = self:FindChild(self.objIntroBtns, "Start")
	local btnIntroBac = self.objIntroduction:GetComponent("Button")
	self:AddButtonClickListener(btnIntroBac, function()
		self:OnClickIntroNext()
	end)

	-- 江湖问答
	self.objQuestion = self:FindChild(self._gameObject, "Questions")
	self.objQuestion:SetActive(false)
	self.objFrameAnimQuestion = self:FindChild(self._gameObject, "FrameQuestion")
	self.objFrameAnimQuestion:SetActive(false)
	self.animQuestion = self.objFrameAnimQuestion:GetComponent("Animator")
	self.MaskCG=self:FindChild(self.objFrameAnimQuestion,"Mask")
	self.lastCG=1
	-- 问答结果
	self.objResult = self:FindChild(self._gameObject, "Result")
	self.objResult:SetActive(false)

	-- 其他值
	self.iTwnDoTextSpeed = 25
	self.iTwnQuestionMoveSpeed = 0.4
end

function BornChooseUI:RefreshUI()
	-- 初始化引言部分
	self.iIntroIndex = 0
	self:OnClickIntroNext()

	--这段代码 跟逻辑强耦合 如果后面 逻辑改了 这里也需要改
	--目前是 抓周界面后 一定会有creatroleui，difficultui。抓周界面没大的逻辑开销，把预加载放到这里 消除加载峰值
	local preLoadPerfab = {"UI/UIPrefabs/Game/CreateRoleUI","UI/UIPrefabs/Create/DifficultyUI","UI/UIPrefabs/Module/Role/Role_Head_Group",}
	local tableData = {"RoleSkinTag","RoleModel","Gift","CreateRole"}
	local iIndex = 1
	self:AddTimer(1000,function() PreLoadPerfabAsync(preLoadPerfab) end)
	self:AddTimer(400,function()
		if iIndex <= #tableData then
			TableDataManager:GetInstance():GetTable(tableData[iIndex])
			iIndex = iIndex+ 1
		end
	end,#tableData)
end

-- 显示一条引言
function BornChooseUI:ShowIntroduction(strMsg)
	local transIntroWords = self.objIntroWords.transform
	for index = 0, transIntroWords.childCount - 1 do
		transIntroWords:GetChild(index).gameObject:SetActive(false)
	end
	if (not strMsg) or (strMsg == "") then
		return
	end
	local wordsArr = string.split(strMsg, "#")
	self:ShowIntroductionSingleLine(wordsArr, 1)
end

-- 显示引言结尾按钮
function BornChooseUI:ShowIntroBtn()
	if not self.iIntroIndex and IntrosWords then
		return
	end
	self.objIntroBtnNext:SetActive(self.iIntroIndex < #IntrosWords)
	self.objIntroBtnStart:SetActive(self.iIntroIndex == #IntrosWords)
	self.bIntroClickEnable = true
end

-- 显示引言单行
function BornChooseUI:ShowIntroductionSingleLine(wordsArr, index)
	local iArrLen = #wordsArr
	if index > iArrLen then
		self:ShowIntroBtn()
		return
	end
	local objLine = self:FindChild(self.objIntroWords, tostring(index))
	if not objLine then
		return
	end
	local strWord = wordsArr[index]
	local textChild = objLine:GetComponent("Text")
	objLine:SetActive(true)
	local twnChild = Twn_DoText(nil, textChild, strWord, self.iTwnDoTextSpeed, function()
		self:ShowIntroductionSingleLine(wordsArr, index + 1)
	end)
	if (twnChild ~= nil) then
		twnChild:SetAutoKill(true)
	end
end

-- 按钮点击: 引言 下一条
function BornChooseUI:OnClickIntroNext()
	if self.bIntroClickEnable == false then
		return
	end
	self.bIntroClickEnable = false
	self.iIntroIndex = self.iIntroIndex + 1
	if self.iIntroIndex > 1 then 
		StopButtonSound(IntroAutioEvents[self.iIntroIndex-1])
	end
	local iLen = #IntrosWords
	if (self.iIntroIndex < 0) or (self.iIntroIndex > iLen) then
		self:OnClickIntroStart()
		return
	end
	self.objIntroBtnNext:SetActive(false)
	self.objIntroBtnStart:SetActive(false)
	PlayButtonSound(IntroAutioEvents[self.iIntroIndex])
	self:ShowIntroduction(IntrosWords[self.iIntroIndex])
end

-- 按钮点击: 引言 开始问答
function BornChooseUI:OnClickIntroStart()
	self.iIntroIndex = 0
	-- 显示问答界面
	self.objQuestion:SetActive(true)
	self.objFrameAnimQuestion:SetActive(true)
	
	self:InitQuestionUI()
	-- local sequence = DRCSRef.DOTween:Sequence()
	-- sequence:SetAutoKill(true)
	-- 隐藏word/btn 放大introduction
	-- local twn1 = self.objIntroWords:GetComponent("CanvasGroup"):DOFade(0, 1)
	-- local twn2 = self.objIntroBtns:GetComponent("CanvasGroup"):DOFade(0, 1)
	-- local twn3 = self.objIntroduction.transform:DOScale(1.55, 1)
	-- sequence:Append(twn3)
	-- sequence:Join(twn1)
	-- sequence:Join(twn2)
	-- 移动并隐藏introduction
	-- local twn4 = self.objIntroduction.transform:DOLocalMove(DRCSRef.Vec3(-877, -43, 0), 1)
	-- local twn5 = self.objIntroduction:GetComponent("Image"):DOFade(0, 2)
	-- sequence:Append(twn4)
	-- sequence:Join(twn5)
	-- 最终整理
	-- sequence:AppendCallback(function()
		self.objIntroduction:SetActive(false)
		self:StartQuestion()
	-- end)
end

-- 开始问答流程
function BornChooseUI:StartQuestion()
	self.iQuestionIndex = 1
	self.auiAnswer = {}
	self:ShowQuestion()
end

-- 初始化问答ui
function BornChooseUI:InitQuestionUI()
	local transQ = self.objQuestion.transform
	local objSubQ = nil
	local cavasSubQ = nil
	local textSubQ = nil
	for index = 0, transQ.childCount - 1 do
		objSubQ = transQ:GetChild(index).gameObject
		cavasSubQ = self:FindChildComponent(objSubQ, "Btns", "CanvasGroup")
		cavasSubQ.alpha = 0
		textSubQ = self:FindChildComponent(objSubQ, "Text", "Text")
		textSubQ.text = ""
		objSubQ:SetActive(index == 0)
		--隐藏CG
			local imageCG=self:FindChildComponent(objSubQ, "CG", "Image")
			--imageCG.gameObject:SetActive(false)
	end
end

-- 点击问答选项
function BornChooseUI:ShowQuestion()
	-- 显示数据
	self.iQuestionIndex = self.iQuestionIndex or 1
	-- 翻页动画, 第一页不翻
	if self.iQuestionIndex > 1 then
		--遮罩CG更新
		for i=0,self.MaskCG.transform.childCount-1 do
			self.MaskCG.transform:GetChild(i).gameObject:SetActive(false)
		end

		local CGTemp=self.MaskCG.transform:GetChild(self.iQuestionIndex-2)
		CGTemp.gameObject:SetActive(true)
		self.iHandleCall=os.clock()
		self.iHandleCall=globalTimer:AddTimer(350,function() CGTemp.gameObject:SetActive(false) self.iHandleCall=nil end)

		self.animQuestion:SetTrigger("bTurn")
			
	end
	local questionData = TableDataManager:GetInstance():GetTableData("StoryZhuazhou", self.iQuestionIndex)
	local objTarQuestion = self:FindChild(self.objQuestion, tostring(self.iQuestionIndex))
	if not (questionData and objTarQuestion) then
		self.objCurQ = nil
		-- 显示结果页
		self.objResult:SetActive(true)
		self.objQuestion:SetActive(false)
		self:InitResultUI()
		return
	end
	-- 关闭上一个问题
	if self.objCurQ then
		self.objCurQ:SetActive(false)
	end
	objTarQuestion:SetActive(true)
	self.objCurQ = objTarQuestion
	--淡入CG
	local imageCG=self:FindChildComponent(objTarQuestion, "CG", "Image")
	--imageCG.gameObject:SetActive(false)
	-- 初始化文字
	local textQ = self:FindChildComponent(objTarQuestion, "Text", "Text")
	local strQ = GetLanguageByID(questionData.QuestionID) or ""
	self:InitQuestionSelection(objTarQuestion, questionData)
	local canvasBtns = self:FindChildComponent(objTarQuestion, "Btns", "CanvasGroup")
	canvasBtns.alpha = 0
	local twnText = Twn_DoText(nil, textQ, strQ, self.iTwnDoTextSpeed, function()
		--imageCG.gameObject:SetActive(true)
		--imageCG:DOFade(0,0.5):From().onComplete=function()
		-- end
		canvasBtns:DR_DOFade(1, 1) 
	end)
	if (twnText ~= nil) then
		twnText:SetAutoKill(true)
	end
	-- 播放语音
	if questionData.AudioResID and (questionData.AudioResID > 0) then
		PlayDialogueSound(questionData.AudioResID)
	end
end

-- 初始化问答选项
function BornChooseUI:InitQuestionSelection(objTarQuestion, kQuestionData)
	if not (objTarQuestion and kQuestionData) then
		return
	end
	local objBtns = self:FindChild(objTarQuestion, "Btns")
	local transBtns = objBtns.transform
	local answers = kQuestionData.Answer or {}
	-- 以ui中摆好的按钮数量为准
	local iCount = math.min(transBtns.childCount, #answers)
	local objBtn = nil
	local comBtn = nil
	local textBtn = nil
	for index = 1, iCount do
		objBtn = transBtns:Find(tostring(index)).gameObject
		if objBtn then
			textBtn = self:FindChildComponent(objBtn, "Text", "Text")
			textBtn.text = GetLanguageByID(answers[index].LangID)
			comBtn = objBtn:GetComponent("Button")
			self:RemoveButtonClickListener(comBtn)
			local tempIndex = index
			self:AddButtonClickListener(comBtn, function()
				-- 钱程 将选项发给服务器
				SendZhuaZhouSelection(tempIndex)
				self.auiAnswer[self.iQuestionIndex] = tempIndex
				-- 显示下一个问题
				self.iQuestionIndex = self.iQuestionIndex + 1
				self:ShowQuestion()
			end)
		end
	end
end

-- 初始化结果页
function BornChooseUI:InitResultUI()
	-- 先隐藏开始创角界面
	local objRes = self:FindChild(self.objResult, "ChooseRes")
	local objCreate = self:FindChild(self.objResult, "StartCreate")
	objRes:SetActive(true)
	objCreate:SetActive(false)

	-- 播放顶部文字打字效果
	local textTitle = self:FindChildComponent(objRes, "TextAsk", "Text")
	local twnText = Twn_DoText(nil, textTitle, textTitle.text, self.iTwnDoTextSpeed)

	-- 抓周结果
	local objResScvContent = self:FindChild(objRes, "Res/Viewport/Content")
	local objRecItemTemp = self:FindChild(objRes, "Res/Viewport/ResItemTemp")
	RemoveAllChildren(objResScvContent)
	local getAttrValueStr = function(eAttr, iValue)
		local bIsPerMyriad, bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(eAttr)
		local ret = ""
		strSymbol = (iValue >= 0) and "+" or ""  -- 负数不用手动加负号
		if bIsPerMyriad then
			iValue = iValue / 10000
		end
		if bShowAsPercent then
			ret = string.format("%s%.1f%%", strSymbol, iValue * 100)
		else
			local fs = bIsPerMyriad and "%s%.1f" or "%s%.0f"
			ret = string.format(fs, strSymbol, iValue)
		end
		return ret
	end
	local objClone = nil
	local textClone = nil
	local createNewAttrItem = function(strName, strValue, bWithOwnColor)
		objClone = CloneObj(objRecItemTemp, objResScvContent)
		textClone = self:FindChildComponent(objClone, "Name", "Text")
		strName = strName or ""
		if bWithOwnColor ~= true then
			strName = "<color=white>" .. strName .. "</color>"
		end
		if (textClone ~= nil) then
			textClone.text = strName
			textClone = self:FindChildComponent(objClone, "Value", "Text")
			textClone.text = strValue or ""
		end

		if (objClone ~= nil) then
			objClone:SetActive(true)
		end
	end
	-- 对获得的奖励进行去重
	local parsedData = {}
	local kQuestion = nil
	local akAnswers = nil
	local kTarAnswer = nil
	local auiAttrs, auiAttrValues = nil, nil
	local auiItems, auiItemValues = nil, nil
	local iValue = nil
	local iRandomRewardID = nil
	local TB_StoryZhuazhou = TableDataManager:GetInstance():GetTable("StoryZhuazhou")
	for index, answerIndex in ipairs(self.auiAnswer) do
		kQuestion = TB_StoryZhuazhou[index]
		akAnswers = kQuestion.Answer or {}
		kTarAnswer = akAnswers[answerIndex] or {}
		-- 属性奖励
		auiAttrs = kTarAnswer.RewardAttrs or {}
		auiAttrValues = kTarAnswer.RewardAttrValues or {}
		for index, eAttr in ipairs(auiAttrs) do
			if not parsedData['AttrType'] then
				parsedData['AttrType'] = {}
			end
			parsedData['AttrType'][eAttr] = (parsedData['AttrType'][eAttr] or 0) + (auiAttrValues[index] or 0)
		end
		-- 物品奖励
		auiItems = kTarAnswer.RewardItems or {}
		auiItemValues = kTarAnswer.RewardItemValues or {}
		for index, itemTypeID in ipairs(auiItems) do
			if not parsedData['Items'] then
				parsedData['Items'] = {}
			end
			parsedData['Items'][itemTypeID] = (parsedData['Items'][itemTypeID] or 0) + (auiItemValues[index] or 0)
		end
		-- 仁义值奖励
		iValue = kTarAnswer.RewardRenyi or 0
		if iValue ~= 0 then
			parsedData['Renyi'] = (parsedData['Renyi'] or 0) + iValue
		end
		-- 随机奖励描述
		iRandomRewardID = kTarAnswer.RandomRewardDesc
		if not parsedData['RandomDesc'] then
			parsedData['RandomDesc'] = {}
		end
		if iRandomRewardID and (iRandomRewardID > 0) then
			parsedData['RandomDesc'][#parsedData['RandomDesc'] + 1] = iRandomRewardID
		end
	end
	-- 显示奖励
	local kItemTypeData = nil
	for strType, kData in pairs(parsedData) do
		if strType == "AttrType" then
			for eAttr, iValue in pairs(kData) do
				createNewAttrItem(
					GetEnumText("AttrType", eAttr),
					getAttrValueStr(eAttr, iValue or 0)
				)
			end
		elseif strType == "Items" then
			for itemTypeID, iNum in pairs(kData) do
				kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
				createNewAttrItem(
					getRankBasedText(kItemTypeData.Rank, kItemTypeData.ItemName or ''),
					string.format("%s%s", (iNum >= 0) and "+" or "", tostring(iNum)
					, true)
				)
			end
		elseif strType == "Renyi" then
			createNewAttrItem(
				"仁义值",
				string.format("%s%s", (kData >= 0) and "+" or "", tostring(kData))
			)
		elseif strType == "RandomDesc" then
			for index, iRandomRewardID in ipairs(kData) do
				createNewAttrItem(
					GetLanguageByID(iRandomRewardID),
					"x1"
				)
			end
		end        
	end

	-- 播放语音
	PlayDialogueSound(ChooseResultAudioID)

	-- 底部按钮
	local objBtns = self:FindChild(self.objResult, "Btns")
	objBtns:SetActive(false)
	self.iHandleCall = os.clock()
	self.iHandleCall = globalTimer:AddTimer(500,function() 
		objBtns:SetActive(true)
		local btnComfirm = self:FindChildComponent(objBtns, "Confirm", "Button")
		local btnAgain = self:FindChildComponent(objBtns, "Again", "Button")
		self:RemoveButtonClickListener(btnComfirm)
		self:RemoveButtonClickListener(btnAgain)
		self:AddButtonClickListener(btnComfirm, function()
			-- 展示开始创角界面
			self:ShowStartCreate()
		end)
		self:AddButtonClickListener(btnAgain, function()
			-- 重新开始答题
			self:RestartQuestion()
		end)
		self.iHandleCall=nil 
	end)


end

-- 重新开始答题
function BornChooseUI:RestartQuestion()
	-- 通知服务器重新答题
	SendZhuaZhouSelection(0)
	-- 隐藏按钮
	self:FindChild(self.objResult, "Btns"):SetActive(false)
	-- 获取屏高
	local iScHeight = DRCSRef.Screen.height
	local oriPos = self.objQuestion.transform.localPosition
	self.objQuestion.transform.localPosition = DRCSRef.Vec3(oriPos.x, iScHeight, oriPos.z)
	self.objQuestion:SetActive(true)
	self:InitQuestionUI()
	-- 新一轮答题从上面移动下来

	local twn = Twn_MoveY(nil, self.objQuestion, 0, -iScHeight, self.iTwnQuestionMoveSpeed, DRCSRef.Ease.Linear)

	if (twn ~= nil) then
		twn:SetAutoKill(true)
		twn.onComplete = function()
			self.objResult:SetActive(false)
			self:StartQuestion()
		end
	end

	
end

-- 显示开始创角界面
function BornChooseUI:ShowStartCreate()
	local objRes = self:FindChild(self.objResult, "ChooseRes")
	local objCreate = self:FindChild(self.objResult, "StartCreate")
	objCreate:SetActive(true)
	objCreate.transform.localScale = DRCSRef.Vec3(1.5, 1.5, 1)
	local twn = objCreate.transform:DOScale(1, 1)
	twn.onComplete = function()
		objRes:SetActive(false)
		local btnStart = self:FindChildComponent(objCreate, "Start", "Button")
		self:RemoveButtonClickListener(btnStart)
		self:AddButtonClickListener(btnStart, function()
			-- 开始创角
			self:OnClickStartCreate()
		end)
	end
	twn:SetAutoKill(true)
	-- 播放语音
	PlayDialogueSound(StartCreateAudioID)
end

-- 点击开始创角
function BornChooseUI:OnClickStartCreate()
	RemoveWindowImmediately("BornChooseUI")
	SendZhuaZhouSelection(2)
end

return BornChooseUI