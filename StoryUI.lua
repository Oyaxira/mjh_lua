StoryUI = class("StoryUI",BaseWindow)

local Warning = '请问您是否要删除本存档？此操作不可取消。' ..
                '若本存档的游戏已开始，将进入周目结算界面<color=red>结束当前剧本的游戏进度，自动结算经脉并带出指定物品</color>，' ..
                '要继续吗？'

function StoryUI:ctor()
    self.comReturn_Button = nil
	self.objStart_Button = nil
	self.turnOver=true
	self.akItemUIClass = {}
	self.allToggle={}
	self.clickCooling=false
	self.tweenDissolve=nil

end

function StoryUI:Create()
	local obj = LoadPrefabAndInit("TownUI/StoryUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end

end
function StoryUI:OnEnable()
	self:RefreshData()
end

function StoryUI:Init()
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"Button_back","Button")
	if self.comReturn_Button then
		local fun = function()
	--退出动画
			self._gameObject:GetComponent("Animator"):SetTrigger("End")
			waitTime=300

			globalTimer:AddTimer(waitTime, function() self:ResetTogglesPos() self:OnClick_Return_Town_Button()  end);
			--self:OnClick_Return_Town_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
	end

	--进入动画
	--self._gameObject:GetComponent("Animator"):SetTrigger("Start")

	self.Start_Button = self:FindChild(self._gameObject, 'Start_Button')
    self.objStart_Button = self:FindChildComponent(self._gameObject,"Start_Button","Button")
    if self.objStart_Button then
        local fun = function()
			self:OnClick_Start_Button(self.curStoryID)
		end
        self:AddButtonClickListener(self.objStart_Button,fun)
	end

	self.DeleteSaveButtonObj = self:FindChild(self._gameObject, 'Delete_Save_Button')
	self.Delete_Save_Button = self:FindChildComponent(self._gameObject,"Delete_Save_Button","Button")
    if self.Delete_Save_Button then
        local fun = function()
			self:OnClick_Delete_Button(self.curStoryID)
		end
        self:AddButtonClickListener(self.Delete_Save_Button,fun)
	end

	self.CheckAllDropButtonObj = self:FindChild(self._gameObject, "Content_Scrollview/CheckAllDropButton")
	self.CheckAllDropButton = self:FindChildComponent(self._gameObject, "Content_Scrollview/CheckAllDropButton", "Button")
	if (self.CheckAllDropButton) then
		local fun = function()
			self:OnClick_CheckAllDrop_Button(self.curStoryID)
		end

		self:AddButtonClickListener(self.CheckAllDropButton,fun)
	end

	self.objBtnChallengeLock = self:FindChild(self._gameObject, "Button_ChallengeOrderLock")
	self.comBtnChallengeLock_Button = self.objBtnChallengeLock:GetComponent("Button")
	if (self.comBtnChallengeLock_Button) then
		local fun = function()
			OpenWindowImmediately("ChallengeOrderUI")
		end

		self:AddButtonClickListener(self.comBtnChallengeLock_Button,fun)
	end

	self.objOld_CG = self:FindChild(self._gameObject, 'Img_story/Image_old')
	self.comOld_CG = self.objOld_CG:GetComponent("Image")

	self.objNew_CG = self:FindChild(self._gameObject, 'Img_story/Image_new')
	self.objNew_CG:SetActive(false)
	self.comNew_CG = self.objNew_CG:GetComponent("Image")

	self.story_anim=self:FindChild(self._gameObject, 'Story_Anim')
	self.story_animLastCG=self:FindChild(self.story_anim, 'Image05')
	self.comStory_animLastCG=self.story_animLastCG:GetComponent("Image")

	self.allStoryCG={}
	self.comStory_anim={}
	--记录所有图片
	for i = 1,5 do
		self.comStory_anim[#self.comStory_anim+1]=self:FindChild(self._gameObject, 'Story_Anim/Image0'..i):GetComponent("Image")
		self.allStoryCG[#self.allStoryCG+1]=self.comStory_anim[#self.comStory_anim].sprite
	end


	self.objStoryContent = self:FindChild(self._gameObject,"Nav_Scrollview/Viewport/Content")
	self.comStoryLayoutGroup = self.objStoryContent:GetComponent("VerticalLayoutGroup")
	self.comStoryToggleGroup = self.objStoryContent:GetComponent("ToggleGroup")
	--	self.objLock_Story = self:FindChild(self._gameObject,"Nav_Scrollview/Viewport/Content/StoryListUI")
	--	self.objLock_StoryToggle = self:FindChildComponent(self._gameObject,"Nav_Scrollview/Viewport/Content/StoryListUI","Toggle")
	--	self.objLock_Story:SetActive(false)
	self.objNormal_Story = self:FindChild(self._gameObject,"Nav_Scrollview/Viewport/StoryListUI")
	self.objNormal_StoryToggle = self:FindChildComponent(self._gameObject,"Nav_Scrollview/Viewport/Content/StoryListUI","Toggle")
	self.objNormal_Story:SetActive(false)

	self.bIsGuideMode = PlayerSetDataManager:GetInstance():GetGuideModeFlag()
	-- 酒馆引导模式, 强制选择魔君剧本
	if GuideDataManager:GetInstance():IsGuideRunning(51) then
	-- if self.bIsGuideMode == true then
		self.curStoryID = 2  -- Story ID 2 => 魔君
	else
		self.curStoryID = 2		-- 第一个可选的
		local storyData = TableDataManager:GetInstance():GetTableData("Story", self.curStoryID)
		if storyData and storyData.IsDreamStory == TBoolean.BOOL_YES then
			self.curStoryID = 3 -- 畅想剧本
		end
	end

	self.objContent = self:FindChild(self._gameObject,"Content_Scrollview/Viewport/Content")
	self.objDissolve = self:FindChild(self._gameObject,"Content_Scrollview/DissolveLayer")
	self.objDissolve.gameObject:SetActive(false)
	self.IntroduceText = self:FindChildComponent(self.objContent, "Introduce/Text","Text")
	self.TimelineText = self:FindChildComponent(self.objContent, "TimeAndReward/Text","Text")
	local reward = self:FindChild(self.objContent, "TimeAndReward/Content_reward")
	self.transRewardContent = reward.transform
	reward:SetActive(false)
	self:FindChild(self.objContent, "TimeAndReward/Label_2"):SetActive(false)

	self.objExtraReward = self:FindChild(self.objContent, "TimeAndReward/Content_extra_reward").transform

	self.objLuckCost = self:FindChild(self._gameObject, "LuckyCostText")
	self.objLuckCost:SetActive(false)
	self.comLuckCostText = self:FindChildComponent(self._gameObject, "LuckyCostText/Text","Text")

	self.objStoryLucky = self:FindChild(self._gameObject, "LuckyState")
	self.objStoryLucky:SetActive(false)
	self.objStoryLuckyState = self:FindChild(self.objStoryLucky, "States")
	self.comBtnStoryInfo_Btn = self:FindChildComponent(self.objStoryLucky, "Info_Btn",'DRButton')
	if self.comBtnStoryInfo_Btn then
		self:AddButtonClickListener(self.comBtnStoryInfo_Btn, function()
			self:ShowLuckyValueTips()
		end)
	end
	self.transStoryLuckyState = self.objStoryLuckyState.transform
	self.textStoryLuckyValue = self:FindChildComponent(self.objStoryLucky, "Text_num", "Text")
	self.objStoryLucky:SetActive(false)

	self.objUnlockCond = self:FindChild(self._gameObject, "UnlockCond")
	self.objUnlockCond:SetActive(false)
	self.textUnlockCond = self:FindChildComponent(self.objUnlockCond, "Text", "Text")

	self.imgLuckyState = self:FindChild(self._gameObject, "LuckyState_story")
	---

	self.storyToggleObjDict = {}

	local table_story = TableDataManager:GetInstance():GetTable("Story")
	local storyDatas = {}

	for storyID, storyData in pairs(table_story) do
		table.insert(storyDatas, storyData)
	end
	table.sort(storyDatas, function(storyDataA, storyDataB)
		return storyDataA.SortIndex < storyDataB.SortIndex
	end)


	-- 按排序后的剧本显示
	for _, storyData in ipairs(storyDatas) do
		local storyID = storyData.BaseID
		-- 非调试模式下不要显示测试剧本, 不显示畅想剧本
		if ((DEBUG_MODE == true or DEBUG_CHEAT == true) or storyData.IsPublic == TBoolean.BOOL_YES) and storyData.IsDreamStory == TBoolean.BOOL_NO then
			local ui_clone = CloneObj(self.objNormal_Story, self.objStoryContent)
			if (ui_clone ~= nil) then
				ui_clone:SetActive(true)
				local ui_position = self:FindChild(ui_clone,"Position_box")

				local objImgDefault = self:FindChild(ui_position,"Img_default")
				local uiImg = self:FindChildComponent(ui_clone,"Position_box/CG_default","Image")
				local uiText = self:FindChildComponent(ui_clone,"Position_box/Text_name","Text")
		--		local uiTextOutline = self:FindChildComponent(ui_clone,"Position_box/Text_name","Outline")
				--uiImg.sprite = GetSprite(storyData.CG)
				self:SetSpriteAsync(storyData.CG,uiImg)

				uiText.text = GetLanguageByID(storyData.NameID)
		--		uiTextOutline.enabled = false

				local uiLock = self:FindChild(ui_clone,"Img_lock")
				if (PlayerSetDataManager:GetInstance():IsUnlockStory(storyID) == true) then
					uiLock:SetActive(false)
				else
					uiLock:SetActive(true)
				end

				local ui_clone_component = ui_clone:GetComponent("Toggle")
				ui_clone_component.group = self.comStoryToggleGroup

				if self.allToggle[1]==nil then
					self.allToggle[1]=ui_clone_component
				else
					self.allToggle[#self.allToggle+1]=ui_clone_component
				end

				self.storyToggleObjDict[storyID] = ui_clone

				local func = function(bool)
					if self.clickCooling==true then return end
					objImgDefault:SetActive(not bool)

					for key, value in pairs(self.allToggle) do
						value.enabled=false
					end
					if bool then
						--ui_position.transform.localPosition =  DRCSRef.Vec3(-2,0,0)
						ui_position.transform:DOLocalMove(DRCSRef.Vec3(-2,0,0),0.4):SetEase(DRCSRef.Ease.InOutCubic )

		--				uiTextOutline.enabled = true
		--				uiText.color = getUIColor('blue')
						local storyIndex=ui_clone_component.transform:GetSiblingIndex()
						local compareID
						if self.curStoryIndex then
							compareID=storyIndex<self.curStoryIndex
						end
						self:OnClick_StoryNormalButton(storyID,compareID)
						self.curStoryIndex=storyIndex
						setUIGray(uiImg, false)

						-- 隐藏宇文庄剧本1和毁天灭地剧本4的“唯一奖励列表”按钮
						local isShow = STORYID_SETTINGS[storyID]
						if isShow~=nil then
							self.CheckAllDropButtonObj:SetActive(isShow)
						end
					else

						--ui_position.transform.localPosition =  DRCSRef.Vec3(-14.5,0,0)

						ui_position.transform:DOLocalMove(DRCSRef.Vec3(-14.5,0,0),0.4):SetEase(DRCSRef.Ease.InOutCubic )

		--				uiTextOutline.enabled = false
		--				uiText.color = getUIColor('white')
						setUIGray(uiImg, true)
					end
				end
				self:AddToggleClickListener(ui_clone_component, func)
				if storyID == 2 then
					self.GuideDoneTog = ui_clone_component
				end
				if storyID == self.curStoryID then
					ui_clone_component.isOn = true
					self.curStoryIndex=ui_clone_component.transform:GetSiblingIndex()
					local rt = ui_clone:GetComponent("RectTransform")
					local pos = (self.objStoryContent.transform.childCount - 1) * (rt.rect.height + self.comStoryLayoutGroup.spacing)
					self.objStoryContent.transform.localPosition =  DRCSRef.Vec3(-2,pos,0)
				end

				--ui_position.gameObject:SetActive(false)
				--获得 351 或者 285 成就时，宇文庄剧本才出现
				local l_canEnter = AchieveDataManager:GetInstance():IsAchieveMade(351) or AchieveDataManager:GetInstance():IsAchieveMade(285)
				if storyID==1 and not l_canEnter then
					ui_clone:SetActive(false)
				end
			end
		end
	end
	--修复选择的刚打开界面那个剧本没有滑出来的问题
	self:ResetTogglesPos()

	self:UpdateStartAndDelButton(self.curStoryID)
	self:AddEventListener("DELETE_STORY_RET", function(info) self:DeleteStory(info)	end)
	self:AddEventListener("QUERY_STORY_RET", function() self.bNeedRefresh = true end)
	self:AddEventListener("CHALLENGEORDER_UNLOCK", function() self.bNeedRefresh = true end)


end
--从选中的第一个开始播放
function StoryUI:PlayToggleAnimation()
	local startToggle=false
	local index=0
	--动画
	--从选中的那个开始
	for key, value in pairs(self.allToggle) do
		if value.isOn==true  then
			startToggle=true
			local rt = value.gameObject:GetComponent("RectTransform")
			local pos = (key - 1) * (rt.rect.height + self.comStoryLayoutGroup.spacing)
			self.objStoryContent.transform.localPosition = DRCSRef.Vec3(-2,pos,0)
		end
		if startToggle==true or key>#self.allToggle-3 then
			local ui_position = self:FindChild(value.gameObject,"Position_box")
			ui_position.gameObject:SetActive(true)
			--进场
			ui_position.transform:DOLocalMove(DRCSRef.Vec3(-400,0,0),0.4):From()
			:SetDelay((index+1)*0.15):SetEase(DRCSRef.Ease.InOutCubic )
			index=index+1
		end
	end

	for key, value in pairs(self.allToggle) do
		if value.isOn or key>#self.allToggle-3 then startToggle=false end
			--动画还没播完就退出要设一下初始值
			local ui_position = self:FindChild(value.gameObject,"Position_box")
			ui_position.gameObject:SetActive(true)
			--进场
			ui_position.transform:DOLocalMove(DRCSRef.Vec3(-400,0,0),0.01):From()
			:SetDelay(index*0.01):SetEase(DRCSRef.Ease.Linear )
			index=index+1
	end
end

function StoryUI:StartAnimaition()
	self._gameObject:GetComponent("Animator"):SetTrigger("Start")
end

function StoryUI:ResetTogglesPos()
	for key, value in pairs(self.allToggle) do
			--动画还没播完就退出要设一下初始值
			local ui_position = self:FindChild(value.gameObject,"Position_box")
			ui_position.transform:DOKill()
			if value.isOn==true then
				ui_position.transform.localPosition=DRCSRef.Vec3(-2,ui_position.transform.localPosition.y,0)
			else
				ui_position.transform.localPosition=DRCSRef.Vec3(-14.5,ui_position.transform.localPosition.y,0)
			end
	end
end

function StoryUI:Update()
	if self.bNeedRefresh then
		self.bNeedRefresh = false
		self:RefreshData()
	end


	if 	self.comStory_animLastCG.sprite~=self.comOld_CG.sprite then

		local i=1
		for index, value in ipairs(self.allStoryCG) do
			-- body
			if value ~=self.comOld_CG.sprite then
				self.comStory_anim[i].sprite=value
				i=i+1
			end
		end

		self.comStory_animLastCG.sprite=self.comOld_CG.sprite
	end
end

function StoryUI:OnPressESCKey()
    if self.comReturn_Button and not IsWindowOpen("AchieveDiffDropUI") then
	    self.comReturn_Button.onClick:Invoke()
    end
end

-- 根据幸运值返回当前幸运档次
function StoryUI:GetLuckyLevel(iLuckyValue)
	iLuckyValue = iLuckyValue or 0
	local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
	if iLuckyValue >= (commonConfig.HighLuckyValueMin or 0) then
		return 1
	elseif iLuckyValue >= (commonConfig.MidLuckyValueMin or 0) then
		return 2
	else
		return 3
	end
end

function StoryUI:OnClick_Start_Button(curStoryID)
	if not self.DeleteSaveButtonObj.activeSelf then
		PlotDataManager:GetInstance():ClearPlotLog(curStoryID)
	end
	local playerMgr = PlayerSetDataManager:GetInstance()
	-- TODO: 掌门对决特殊处理，询问下要不要配表
	if (curStoryID == 9) then
		SetCurScriptID(curStoryID)
		PKManager:GetInstance():Start()
		return
	end

	local uiStorageItemCount = StorageDataManager:GetInstance():GetAllItemNum() or 0
	if uiStorageItemCount > StorageCopacity then
		local content = {};
		content.title = '系统提示';
		content.rightBtnText = '立即前往';
		content.text = '您的仓库容量已达上限\n请先前往清理！';

		local _callback = function()
			OpenWindowImmediately("StorageUI");
			RemoveWindowImmediately('StoryUI');
		end
		OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP_WITH_BTN, content, _callback, {confirm = 1} })
		return;
	end

	-- 畅想模式
	if curStoryID == 3 then
		if PlayerSetDataManager:GetInstance():IsChallengeOrderUnlock() then
			RemoveWindowImmediately("StoryUI")
			OpenWindowImmediately("DreamStoryUI")
		end
		return
	end

	if (playerMgr:IsUnlockStory(curStoryID) == false) then
		SystemTipManager:GetInstance():AddPopupTip("此剧本未解锁,请先解锁其他剧本后再进行此剧本")
		return
	end
	-- 单机版不需要判断带出次数
	-- if self:EnterScriptCheckTakeOutLimit(curStoryID) then
	-- 	return
	-- end

	-- 正常的读档进入剧本
	EnterStory(curStoryID, true, true, true)
end

function StoryUI:EnterScriptCheckTakeOutLimit(curStoryID)
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

function StoryUI:RefreshUIOnGuide()
	if self.GuideDoneTog then
		self.GuideDoneTog.isOn = true
	end
end

function StoryUI:OnClick_Delete_Button(curStoryID)
	if CLOSE_EXPERIENCE_OPERATION then
		SystemUICall:GetInstance():Toast('体验版暂不开放')
		return
	end

	local _callback = function()
		g_processDelStory = true
		SendClickDelStoryCMD(curStoryID)
		MSDKHelper:SetQQAchievementData('removescript', 1);
		MSDKHelper:SendAchievementsData('removescript');
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

function StoryUI:OnClick_CheckAllDrop_Button(scriptid)
	OpenWindowImmediately("AchieveDiffDropUI",scriptid)
end

function StoryUI:OnClick_Return_Town_Button()
	RemoveWindowImmediately("StoryUI")
	-- OpenWindowImmediately("HouseUI")
    -- OpenWindowImmediately("LoadingUI")
	-- ChangeScenceImmediately("Town","LoadingUI", function()
		local LoginUI = OpenWindowImmediately("LoginUI")
	-- end)
end

function StoryUI:ReturnUIClass()
	if #self.akItemUIClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
		self.akItemUIClass = {}
	end
end

function StoryUI:OnDestroy()
	-- self.ItemIconUI:Close()
	self:CleanTween()
	self:ReturnUIClass()
end

function StoryUI:CleanTween()
	if self.tweenNewCG and self.tweenNewCG.onComplete then
		self.tweenNewCG.onComplete = nil
		self.tweenNewCG = nil
		self.tweenNewCG1 = nil	end
	if self.tweenOldCG and self.tweenOldCG.onComplete then
		self.tweenOldCG.onComplete = nil
		self.tweenOldCG = nil
		self.tweenOldCG1=nil
	end

	if self.tweenDissolve then
		self.tweenDissolve.onComplete=nil
		self.tweenDissolve=nil

	end
	if self.tweenDissolveImage then
		self.tweenDissolveImage.onComplete=nil
		self.tweenDissolveImage=nil
	end
end

function StoryUI:EnableToggleClick()
	for key, value in pairs(self.allToggle) do
		value.enabled=true
	end
	self.clickCooling=false
	self.iHandleCall=nil
end

function StoryUI:OnClick_StoryNormalButton(storyID,compareID)
	if not storyID then return end
	if storyID == self.curStoryID then
		self.iHandleCall = os.clock()
		self.iHandleCall = globalTimer:AddTimer(200,function()
			local node = GetUIWindow("StoryUI")
			if node then
				node:EnableToggleClick()
			end
		end)
		return
	end
	local storyTable = TableDataManager:GetInstance():GetTable("Story")
	local before = storyTable[self.curStoryID]
	local after = storyTable[storyID]
	if not (before and after) then
		return
	end
	if self.clickCooling==false then self.clickCooling=true end
	self:CleanTween()


	-- 溶解效果
	--初始化组件和参数
	local dissolveImage=self.objDissolve:GetComponent("Graphic")

	dissolveImage.material:DOKill()
	dissolveImage:DOKill()

	self.objDissolve:GetComponent("Image").color=DRCSRef.Color(1,1,1,1)
	-- local PropertyBlock = CS.UnityEngine.MaterialPropertyBlock()
	-- PropertyBlock:SetFloat("_DissolveRange",0)
	-- dissolveImage:SetPropertyBlock(PropertyBlock)
	dissolveImage.material:SetFloat("_DissolveRange",0)
	self.objDissolve.gameObject:SetActive(true)
	--动画
	--这里动画如果时间太长，会出现画面还没溶解完就更新了说明文字的问题，如果出现
	--去RefreshData的Update里面做一下限制
	self.tweenDissolve = dissolveImage.material:DOFloat(1,"_DissolveRange",0.9):SetEase(DRCSRef.Ease.InQuad)
	self.tweenDissolve.onComplete=function()
		local storyUI=GetUIWindow("StoryUI")
		if storyUI~=nil then
			storyUI:RefreshData()
			if storyUI.tweenDissolve and storyUI.tweenDissolve.DORewind then
				storyUI.tweenDissolve:DORewind()
			end
		end
	end
	self.tweenDissolveImage=dissolveImage:DOFade(0,0.4):SetDelay(0.8)
	-- 播放动画
	self.objNew_CG:SetActive(true)
	--self.comNew_CG.sprite = GetSprite(after.CG)
	self:SetSpriteAsync(after.CG,self.comNew_CG)
    --进入
	local rectTransform = self.objNew_CG:GetComponent("RectTransform")
	self.tweenNewCG = self.comNew_CG:DOFade(0.0,0.4):SetEase(DRCSRef.Ease.Linear ):From()
	self.curStoryID = storyID
	if compareID then
		rectTransform.anchoredPosition3D = DRCSRef.Vec3(rectTransform.anchoredPosition.x-150,93-100,0)
		Twn_MoveX(nill, self.comNew_CG.gameObject, 150, 0.35, DRCSRef.Ease.OutSine, function() rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)
		Twn_MoveBy_Y(nill, self.comNew_CG.gameObject, 100, 0.35, DRCSRef.Ease.OutSine, function() rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)

		self.tweenNewCG1=self.comNew_CG.transform:DOLocalRotate(DRCSRef.Vec3(0, -1, 10), 0.4):SetEase(DRCSRef.Ease.OutSine):From()
	else
		rectTransform.anchoredPosition3D = DRCSRef.Vec3(rectTransform.anchoredPosition.x+150,93-100,0)
		Twn_MoveX(nill, self.comNew_CG.gameObject, -150, 0.35, DRCSRef.Ease.OutSine, function() rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)
		Twn_MoveBy_Y(nill, self.comNew_CG.gameObject, 100, 0.35, DRCSRef.Ease.OutSine, function() rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)

		self.tweenNewCG1=self.comNew_CG.transform:DOLocalRotate(DRCSRef.Vec3(0, -1, -10), 0.4):SetEase(DRCSRef.Ease.OutSine):From()
	end
	self.tweenNewCG.onComplete = function()
		--出去
		self.tweenOldCG = self.comOld_CG:DOFade(0,0.3):SetEase(DRCSRef.Ease.Linear )
		rectTransform = self.objOld_CG:GetComponent("RectTransform")
		if compareID then
			Twn_MoveX(nill, self.comOld_CG.gameObject, 350, 0.3, DRCSRef.Ease.Linear, function()
				 rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)
			Twn_MoveBy_Y(nill, self.comOld_CG.gameObject, -200, 0.3, DRCSRef.Ease.InSine, function()
				 rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)

			self.tweenOldCG1=self.comOld_CG.transform:DOLocalRotate(DRCSRef.Vec3(1, -2, -30), 0.3):SetEase(DRCSRef.Ease.InSine)
		else
			Twn_MoveX(nill, self.comOld_CG.gameObject, -260, 0.3, DRCSRef.Ease.Linear, function()
				 rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)
			Twn_MoveBy_Y(nill, self.comOld_CG.gameObject, -320, 0.3, DRCSRef.Ease.InSine, function()
				 rectTransform.anchoredPosition3D = DRCSRef.Vec3(0,93,0) end)

			self.tweenOldCG1=self.comOld_CG.transform:DOLocalRotate(DRCSRef.Vec3(1, 2, 30), 0.3):SetEase(DRCSRef.Ease.InSine)
		end


		self.tweenOldCG.onComplete = function()
			if IsWindowOpen("StoryUI") then
				local storyUI=GetUIWindow("StoryUI")
				if not storyUI then return end
				storyUI.comOld_CG:DORewind()
				--仅做延迟作用
				storyUI.comOld_CG:DOFade(0,0.01):SetEase(DRCSRef.Ease.Linear).onComplete=function()
					if IsWindowOpen("StoryUI") then
						local storyUI=GetUIWindow("StoryUI")
						if not storyUI then return end
						storyUI.comOld_CG:DORewind()
						storyUI:EnableToggleClick()
						storyUI:RefreshData()
					end
				end
			end
		end
		self.tweenOldCG1.onComplete = function()
			if IsWindowOpen("StoryUI") then
				local storyUI=GetUIWindow("StoryUI")
				if not storyUI then return end
				storyUI.comOld_CG.transform:DORewind()
			end
			--self.comOld_CG.transform:DORewind()
		end
		self:UpdateStartAndDelButton(storyID)
		self:UpdateLockText(storyID)
	end
end

function StoryUI:UpdateTogglesUnlock()
	if not self.storyToggleObjDict then
		return
	end

	for storyID, toggleObj in pairs(self.storyToggleObjDict) do
		if IsValidObj(toggleObj) then
			local uiLock = self:FindChild(toggleObj,"Img_lock")
			if (PlayerSetDataManager:GetInstance():IsUnlockStory(storyID) == true) then
				uiLock:SetActive(false)
			else
				uiLock:SetActive(true)
			end
		end
	end
end

function StoryUI:UpdateLockText(storyID)
	local storyTable = TableDataManager:GetInstance():GetTable("Story")
	local after = storyTable[storyID]
	if (PlayerSetDataManager:GetInstance():IsUnlockStory(storyID) ~= true) then
		if (after.UnlockID ~= nil) and (after.UnlockID > 0) then
			self.textUnlockCond.text = GetLanguageByID(after.UnlockID) or ""
			self.objUnlockCond:SetActive(true)
		else
			self.objUnlockCond:SetActive(false)
		end
	else
		self.objUnlockCond:SetActive(false)
	end
end

function StoryUI:UpdateStartAndDelButton(storyID)
	-- 解锁剧本是否显示
	self.objBtnChallengeLock:SetActive(false)
	if (PlayerSetDataManager:GetInstance():IsUnlockStory(storyID) == true) then
		self.Start_Button:SetActive(true)
	else
		self.Start_Button:SetActive(false)

		if PlayerSetDataManager:GetInstance():IsChallengeOrderLock(storyID) then
			self.objBtnChallengeLock:SetActive(true)
		end
	end

	-- 删除存档是否显示
	if (PlayerSetDataManager:GetInstance():IsEmptyScript(storyID) == true) then
		self.DeleteSaveButtonObj:SetActive(false)
		-- 如果删档按钮不需要显示, 说明是新档, 那么清除一些标记
		self:ClearScriptTags(storyID)
	else
		self.DeleteSaveButtonObj:SetActive(true)
	end

	local curStoryLucyValue = PlayerSetDataManager:GetInstance():GetLuckyValue(self.curStoryID)
	if (PlayerSetDataManager:GetInstance():IsEmptyScript(self.curStoryID) == false and
		curStoryLucyValue == SSLT_NEWPLAYER or curStoryLucyValue == SSLT_NORMAL) then
		self.imgLuckyState:SetActive(false)
	else
		self.imgLuckyState:SetActive(false)
	end
end

function StoryUI:ClearScriptTags(storyID)
	-- 清除城市动画播放标记
	local TB_MapPoem = TableDataManager:GetInstance():GetTable("MapPoem")
	for _, data in pairs(TB_MapPoem) do
		local checkKey = string.format("CityAnim_%s_%s", storyID, data.MapID)
		SetConfig(checkKey, 0)
	end
end

function StoryUI:GetDiffDropData()
	local AchieveDataMgrInst = AchieveDataManager:GetInstance()
	local storyAllDiffItem = AchieveDataMgrInst:GetDiffDropTBData(0,self.curStoryID)
	local storyLuckyDiffItem = {}
	local Luckyvalue = PlayerSetDataManager:GetInstance():GetLuckyValue(self.curStoryID)
	-- 已经获得的就不要了
	for k,v in pairs(storyAllDiffItem) do
		local getItem = AchieveDataMgrInst:GetDiffDropDataByTypeID(k, self.curStoryID, 1)
		local iget =  getItem and getItem.uiRoundFinish or 0
		local iLimitNum = v.NumLimit
        if not iLimitNum or iLimitNum == 0 then
            iLimitNum = 1
        end
		if (getItem == nil or iget < iLimitNum) then
			local diffdropitem = AchieveDataMgrInst:GetDiffDropRewordByLucky(v,Luckyvalue)
			if (diffdropitem) then
				table.insert(storyLuckyDiffItem, diffdropitem)
			end
		end
	end

	local tableItems = {}
	-- 分别筛选最高品质的武器，装备，残章，秘籍
	local weapon = self:_FilterDiffDropItem(0,storyLuckyDiffItem)
	local equip = self:_FilterDiffDropItem(1,storyLuckyDiffItem)
	local canzhang = self:_FilterDiffDropItem(2,storyLuckyDiffItem)
	local miji = self:_FilterDiffDropItem(3,storyLuckyDiffItem)

	if (weapon) then
		table.insert(tableItems,weapon)
	end
	if (equip) then
		table.insert(tableItems,equip)
	end
	if (canzhang) then
		table.insert(tableItems,canzhang)
	end
	if (miji) then
		table.insert(tableItems,miji)
	end

	--

	return tableItems
end

-- 筛选最高品质的武器
function StoryUI:_FilterDiffDropItem(FilterType, diffDropItemData)
	if (not diffDropItemData) then
		return nil
	end
	local ItemDataMgrInst =  ItemDataManager:GetInstance()
	local curItem = nil
	local curMaxRank = nil
	for i = 1, #(diffDropItemData) do
		local data = diffDropItemData[i]
		local itemTypeID = data["Value"]
		local type = data["Type"]
		if(FilterType == 0) then		-- 0 代表武器
			if (type == StoryDiffDropRewardType.SDDRT_Item) then
				if (ItemDataMgrInst:GetEquipPos(itemTypeID) == REI_WEAPON) then
					local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(itemTypeID)
					if (curItem == nil or curMaxRank == nil or itemTypeData.Rank > curMaxRank) then
						curItem = data
						curMaxRank = itemTypeData.Rank
					end
				end
			end
		elseif (FilterType == 1) then	-- 1代表装备
			if (type == StoryDiffDropRewardType.SDDRT_Item) then
				local equipPos = ItemDataMgrInst:GetEquipPos(itemTypeID)
				if (equipPos == REI_CLOTH or equipPos == REI_JEWELRY or equipPos == REI_SHOE or equipPos == REI_ANQI or equipPos == REI_MEDICAL or equipPos == REI_THRONE ) then
					local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(itemTypeID)
					if (curItem == nil or curMaxRank == nil or itemTypeData.Rank > curMaxRank) then
						curItem = data
						curMaxRank = itemTypeData.Rank
					end
				end
			end
		elseif (FilterType == 2) then 	-- 2代表残章
			if (type == StoryDiffDropRewardType.SDDRT_Canzhang) then
				local martialTypeData = GetTableData("Martial",itemTypeID)
				if(martialTypeData ~= nil) then
					if (curItem == nil or curMaxRank == nil or martialTypeData.Rank > curMaxRank) then
						curItem = data
						curMaxRank = martialTypeData.Rank
					end
				end
			end
		elseif (FilterType == 3) then 	-- 3代表秘籍
			if (type == StoryDiffDropRewardType.SDDRT_Miji) then
				local martialTypeData = GetTableData("Martial",itemTypeID)
				if(martialTypeData ~= nil) then
					if (curItem == nil or curMaxRank == nil or martialTypeData.Rank > curMaxRank) then
						curItem = data
						curMaxRank = martialTypeData.Rank
					end
				end
			end
		end
	end
	return curItem
end

function StoryUI:RefreshUI(info)
	-- 切换选择剧本
	local storyID = nil
	if info then
		storyID = info.ePageType
	end
	if storyID and storyID ~= self.curStoryID and self.storyToggleObjDict and self.storyToggleObjDict[storyID] then
		local ui_component = self.storyToggleObjDict[storyID]:GetComponent("Toggle")
		if ui_component then
			ui_component.isOn = true
		end
	end

	self._gameObject:GetComponent("Animator"):SetTrigger("Start")
	self:PlayToggleAnimation()

	self:EnableToggleClick()
	self.comOld_CG.color=DRCSRef.Color(1,1,1,1)
	self.comOld_CG.gameObject.transform.eulerAngles=DRCSRef.Vec3(0,0,0)

	--重置所有图片
	--前面如果出现选择的剧本的CG替换成其他没出现过的CG
	--暂时没用Story表,某些剧本没CG
	local i=1
	for index, value in ipairs(self.allStoryCG) do
		-- body
		if value ~=self.comOld_CG.sprite then
			self.comStory_anim[i].sprite=value
			i=i+1
		end
	end

	--最后一张图和选择剧本的CG一样
	self.comStory_animLastCG.sprite=self.comOld_CG.sprite

	globalTimer:AddTimer( 1000 ,function()
		GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_AnimEnd,'StoryUI')
	end )

	if not self.sendQueryStoryWeekLimitFlag then
		self.sendQueryStoryWeekLimitFlag = true
		SendQueryStoryWeekLimit()
	end
end

function StoryUI:RefreshData()
	local storyTable = TableDataManager:GetInstance():GetTable("Story")
	local storyData = storyTable[self.curStoryID]
	if (storyData == nil) then
		return
	end

	self.IntroduceText.text = GetLanguageByID(storyData.DescID)
	self.TimelineText.text = GetLanguageByID(storyData.TimeID)

	if self.clickCooling==false then
		self:SetSpriteAsync(storyData.CG,self.comOld_CG)
		self.comNew_CG.gameObject:SetActive(false)
	end

	--[TODO] 如果后面 setparent开销太高，按LUA_CLASS_TYPE 分类，UI里自己再做一层缓存，不直接使用ReturnAllUIClass
	self:ReturnUIClass()

	self:UpdateLockText(self.curStoryID)
	self:UpdateStartAndDelButton(self.curStoryID)
	self:UpdateTogglesUnlock()

	local ItemDataMgrInst =  ItemDataManager:GetInstance()
	if storyData.FirstStoryReward and next(storyData.FirstStoryReward) and IsOveredStory(self.curStoryID) == false then
		for index = 1,#storyData.FirstStoryReward do
			local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI,self.transRewardContent)
			local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(storyData.FirstStoryReward[index])
			local itemNums = storyData.FirstStoryRewardNum[index]
			kItem:UpdateUIWithItemTypeData(itemTypeData)
			kItem:SetFirstStory(true)
			kItem:SetItemNum(itemNums, itemNums == 1)
			self.akItemUIClass[#self.akItemUIClass+1] = kItem
		end
	end

	if storyData.StoryReward and next(storyData.StoryReward) then
		for index = 1,#storyData.StoryReward do
			local kItem =  LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI,self.transRewardContent)
			local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(storyData.StoryReward[index])
			local itemNums = storyData.StoryRewardNum[index]
			kItem:UpdateUIWithItemTypeData(itemTypeData)
			kItem:SetFirstStory(false)
			kItem:SetItemNum(itemNums, itemNums == 1)
			self.akItemUIClass[#self.akItemUIClass+1] = kItem
		end
	end

	-- 显示周目控制的物品
	if storyData.StoryRewardShow and next(storyData.StoryRewardShow) then
		for index = 1,#storyData.StoryRewardShow do
			local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUI,self.objExtraReward)
			local itemTypeData = ItemDataMgrInst:GetItemTypeDataByTypeID(storyData.StoryRewardShow[index])
			local itemNums = 1
			kItem:UpdateUIWithItemTypeData(itemTypeData)
			kItem:SetFirstStory(false)
			kItem:SetItemNum(itemNums, itemNums == 1)
			self.akItemUIClass[#self.akItemUIClass+1] = kItem
		end
	end
	-- local diffDropitems = self:GetDiffDropData()
	-- if (diffDropitems ~= nil) then
	-- 	for i = 1,#(diffDropitems) do
	-- 		local item = diffDropitems[i]
	-- 		local diffTypeData = TableDataManager:GetInstance():GetTableData("StoryDiffDrop", item.BaseID)
	-- 		if(diffTypeData ~= nil) then
	-- 			local kItem =  LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.LuckItemIconUI,self.objExtraReward)
	-- 			kItem:UpdateIcon(diffTypeData,false,true, self.curStoryID)
	-- 			self.akItemUIClass[#self.akItemUIClass+1] = kItem
	-- 		end
	-- 	end
	-- end

	-- 显示幸运值减少
	local costLucyValue = storyData.LuckeyCost
  	-- if (costLucyValue == 0) or
    --   (PlayerSetDataManager:GetInstance():IsEmptyScript(self.curStoryID) == false) or
    --   (PlayerSetDataManager:GetInstance():IsUnlockStory(self.curStoryID) == false) then
	-- 	self.objLuckCost:SetActive(false)
	-- else
	-- 	self.objLuckCost:SetActive(true)
	-- end

	self.comLuckCostText.text = string.format("%d", costLucyValue)


	local curStoryLucyValue = PlayerSetDataManager:GetInstance():GetLuckyValue(self.curStoryID)
	if (PlayerSetDataManager:GetInstance():IsEmptyScript(self.curStoryID) == false and
		curStoryLucyValue == SSLT_NEWPLAYER or curStoryLucyValue == SSLT_NORMAL) then
		self.imgLuckyState:SetActive(false)
	else
		self.imgLuckyState:SetActive(false)
	end
	local curLucyValue = PlayerSetDataManager:GetInstance():GetLuckyValue()
	self.textStoryLuckyValue.text = string.format("%.0f", curLucyValue)
	local iCurLevel = self:GetLuckyLevel(curLucyValue) or 1
	for index = 1, self.transStoryLuckyState.childCount do
		self.transStoryLuckyState:GetChild(index - 1).gameObject:SetActive(iCurLevel == index)
	end
end

function StoryUI:IsWeekTakeOutLimit(uiStoryID)
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

function StoryUI:DeleteStory(uiStoryID)
	local playerinfo = globalDataPool:getData("PlayerInfo")
	if not playerinfo then return true end	-- 单机没有 info 数据
	for i = 0, playerinfo.iSize - 1 do
		if (playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == uiStoryID) then
			playerinfo.kUnlockScriptInfos[i]["dwScriptTime"] = 0
			playerinfo.kUnlockScriptInfos[i]["eStateType"] = SSS_NULL
		end
	end
	self:UpdateStartAndDelButton(uiStoryID)
	-- self.DeleteSaveButtonObj:SetActive(false)
end

-- 显示tips
function StoryUI:ShowLuckyValueTips()
	if not self.kRateTip then
        self.kRateTip = {
            ['kind'] = 'wide',
            ['title'] = "关于幸运值",
            ['titlecolor'] = DRCSRef.Color.white,
            ['content'] = GetLanguageByID(554),
        }
    end
    OpenWindowImmediately("TipsPopUI", self.kRateTip)
end

function StoryUI:OnDisable()
	self:ReturnUIClass()
end

return StoryUI