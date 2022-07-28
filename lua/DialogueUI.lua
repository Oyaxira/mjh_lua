DialogueUI = class("DialogueUI",BaseWindow)

local CucolorisMaterial = LoadPrefab("Materials/GlowAndDark",typeof(CS.UnityEngine.Material))

function DialogueUI:ctor()
	self:ResetData()
end

-- 由外部创建,需要自己调用 Init
function DialogueUI:ExternalInit(obj, str, objParent)
	self:SetGameObject(obj)
	self:ResetData()
	self:Init()
	self.external = str
	self.objParent = objParent
end

function DialogueUI:ResetData()
	self._coroutine = {}
	self._tween = {}
	self.isSpeedUp = false
end

-- 由 OpenWindow 创建窗口，会自动跑 Init
function DialogueUI:Create()
	local obj = LoadPrefabAndInit("Interactive/DialogueUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
	self.external = nil
end

function DialogueUI:Init()
	self.comDialogueText = self:FindChildComponent(self._gameObject, "Name_box/Dialog_Text", "Text")
	self.comDialogueOutline = self:FindChildComponent(self._gameObject, "Name_box/Dialog_Text","OutlineEx")
	self.comDialogueOutline.enabled = false 
	self.objNameBox = self:FindChild(self._gameObject, "Name_box")
	self.comNameText = self:FindChildComponent(self.objNameBox, "Text", "Text")
	self.comTitleText = self:FindChildComponent(self.objNameBox, "Text/TitleText", "Text")
	self.objDialogBg = self:FindChild(self.objNameBox, "Back")
	self.objNameTitleFlag = self:FindChild(self.objNameBox, "TitleFlag")
	self.comNameTitleFlag = self:FindChildComponent(self.objNameBox, "TitleFlag",'DRButton')
	if self.comNameTitleFlag then
		self:RemoveButtonClickListener(self.comNameTitleFlag)
		self:AddButtonClickListener(self.comNameTitleFlag, function()
			self:OnClickTitleFlag()
		end)
	end


	self.comDialogueBtn = self:FindChildComponent(self._gameObject,"raycast","Button")
	if self.comDialogueBtn then
		self:RemoveButtonClickListener(self.comDialogueBtn)
		self:AddButtonClickListener(self.comDialogueBtn, function()
			self:OnClickDialogue()
		end)
	end

	self.objFrames_arrow = self:FindChild(self._gameObject, 'Dialog_box/frames_arrow')
	self.objFrames_arrow:SetActive(false)

	self.objCG = self:FindChild(self._gameObject, 'Name_box/CG')
	self.transCG = self.objCG.transform
	self.v3OriCGPos = self.transCG.localPosition
	self.comRoleCGImg = self.objCG:GetComponent('Image')
	self.comRoleCGRect = self.objCG:GetComponent('RectTransform')
	self.comRoleCGScript = self.objCG:GetComponent('ImageCucoloris')
	self.comRoleCGMask = self.objCG:GetComponent('Mask')
	self.comRoleForeCGImg = self:FindChildComponent(self.objCG, 'ForeCG', 'Image')	

	self.objRoleMoodBg = self:FindChild(self.objCG, 'Mood')
	self.objCreateCGParent = self:FindChild(self._gameObject, "CreateCG")

	self.objFavor_box = self:FindChild(self._gameObject, 'TransformAdapt_node_left/Favor_box')
	if self.objFavor_box then 
		self.objFavor_box:SetActive(false)
		self.comFavor_box_DT = self.objFavor_box:GetComponent("DOTweenAnimation")
		self.comFavor_Text = self:FindChildComponent(self.objFavor_box, "Text", "Text")
		self.objFavor_Text_action = self:FindChild(self.objFavor_box, "Text_action")
		self.comFavor_Text_action = self.objFavor_Text_action:GetComponent("Text")
		self.comFavor_DT_action = self.objFavor_Text_action:GetComponent("DOTweenAnimation")
		self.comFavor_Text_action.gameObject:SetActive(false)
	end

	self.comWhiteForegroundImage = self:FindChildComponent(self._gameObject, "WhiteForeground", "Image")
	self.comWhiteForegroundImage.gameObject:SetActive(false)

	self:MarkOriginalValue()

	self:AddEventListener("UPDATE_DISPOSITION",function() self:UpdateRoleFavor(self.roleTypeID) end)
	LogicMain:GetInstance().DialogUI=self
end

function DialogueUI:ClearDialog()
	self.dialogueInfo = nil
end

function DialogueUI:StopDialogSound()
	StopDialogueSound()
	DialogRecordDataManager:GetInstance():SetDialogSoundPlayState(false)
	if self.iSoundPlayTimer then
		self:RemoveTimer(self.iSoundPlayTimer)
		self.iSoundPlayTimer = nil
	end
end

function DialogueUI:ExitDialog(dispatchActionEnd)
	self:StopDialogSound()
	self:RedisplayBattleUI()
	RemoveWindowImmediately('DialogueUI', true)
	RemoveWindowImmediately('DialogChoiceUI', true)
	if dispatchActionEnd ~= false then
		DisplayActionEnd()
	end
end

function DialogueUI:OnClickTitleFlag()
	if self.iEvoPlayerID then 
		SendGetPlatPlayerDetailInfo(self.iEvoPlayerID, RLAYER_REPORTON_SCENE.UserBoard)	
	end 
end

function DialogueUI:OnClickDialogue(dispatchActionEnd)
	self:ClearDialog()
	if self.txtTween and self.txtTween:IsPlaying() then
		self.txtTween:Kill(false)
		self:DialogEnd()
		return false
	else
		self:ExitDialog(dispatchActionEnd)
		return true
	end
	return false
end

function DialogueUI:DialogueSpeedUp(dispatchActionEnd)
	self.isSpeedUp = true
	if self.txtTween and self.txtTween:IsPlaying() then
		self.txtTween:ChangeEndValue(tostring(self.dialogue),1 / 20)
	else
		self:ExitDialog(dispatchActionEnd)
	end
end

function DialogueUI:DialogueRecoverSpeed()
	self.isSpeedUp = false
	if self.txtTween and self.txtTween:IsPlaying() then
		self.txtTween:ChangeEndValue(tostring(self.dialogue),string.utf8len(self.dialogue) * (1 / 50))
	end
end

function DialogueUI:OnDestroy()
	---- 回收动画 ----
	if self.txtTween then
		self.txtTween.onComplete = nil
		self.txtTween = nil
	end
	self:ResetData()
end

local tmp = 't.t'
local in_file = 'in.t'
local t_wav = 'o.wav'
local f_wav = '1.wav'

function DialogueUI:Update()
	if not io.exists(in_file) then
		if io.exists(t_wav) then
			DRCSRef.LogError('3')
			os.remove(f_wav)
			local ok = os.rename(t_wav, f_wav)
			if ok then
				DRCSRef.LogError('4')
				CS.GameApp.FMODManager.PlayDialogue('')
			end
		end
	end
end


function DialogueUI:UpdateUI(dialogueID, roleTypeID, storyActionStr, storyEffectStr, StoryMood,resourceBgmID, roleNameID, roleArtID, noTween, bIsImpressionDesc, playerID)
	self.strRoleName = nil
	self.strRoleHead = nil
	self.objFavor_box:SetActive(false)
	local kDialogRecMgr = DialogRecordDataManager:GetInstance()
	-- 快进对话模式下调过角色语音的播放
	if not kDialogRecMgr:IsFastChatOpen() then
		local iSoundLength = PlayDialogueSound(resourceBgmID)
		if iSoundLength and (iSoundLength > 0) then
			kDialogRecMgr:SetDialogSoundPlayState(true)
			if self.iSoundPlayTimer then
				self:RemoveTimer(self.iSoundPlayTimer)
				self.iSoundPlayTimer = nil
			end
			self.iSoundPlayTimer = self:AddTimer(iSoundLength, function()
				DialogRecordDataManager:GetInstance():SetDialogSoundPlayState(false)
				LuaEventDispatcher:dispatchEvent("DialogueSoundEnd")
			end)
		end
	end
	self:UpdateDialogue(dialogueID, noTween, roleTypeID)
	if not self.iSoundPlayTimer then -- not sound		
		local d_txt = string.gsub(self.dialogue, "<.+>", "")
		io.writefile(tmp, d_txt)
		os.remove(in_file)
		os.rename(tmp, in_file)
	end
	self:UpdateRole(roleTypeID, storyActionStr, storyEffectStr, StoryMood, roleNameID, roleArtID, playerID)
	if RoleDataHelper.CanShowFavor(roleTypeID) then 
		self.objFavor_box:SetActive(true)
		self:CheckRoleFavorCache(roleTypeID)
	else
		self.objFavor_box:SetActive(false)
	end
	-- 不是印象描述时, 进行对话记录
	if not bIsImpressionDesc then
		local kRecInfo = {
			['roleBaseID'] = roleTypeID,
			['name'] = self.strRoleName,
			['avatar'] = self.strRoleHead,
		}
		kDialogRecMgr:RecordDialog(self.dialogue, kRecInfo)
	end
end

function DialogueUI:DialogEnd()
	self.comDialogueText.text = self.dialogue
	self.objFrames_arrow:SetActive(true)
	
	---- 回收动画 ----
	if self.txtTween then
		self.txtTween.onComplete = nil
		self.txtTween = nil
	end

	LuaEventDispatcher:dispatchEvent("DialogEnd")
end

function DialogueUI:UpdateDialogue(dialogueID, noTween, roleTypeID)
	if type(dialogueID) == 'string' then
		self.dialogue = dialogueID
	else
		self.dialogue = GetLanguageByID(dialogueID, self.dialogueInfo.taskID, nil, roleTypeID)
	end
	local  keepDialogue = StringHelper:GetInstance():GetPlot()
	if 	keepDialogue and keepDialogue ~= '' then
		StringHelper:GetInstance():SetPlot('')
	end
	
	self.dialogue = (keepDialogue or '') .. (StringHelper:GetInstance():NameConversion(self.dialogue) or '')
	self.dialogue = string.gsub(self.dialogue, '\\n', '\n')

	-- if string.find(self.dialogue,'<color=' ) then 
	-- 	self.comDialogueOutline.enabled = true 
	-- else 
		self.comDialogueOutline.enabled = false 
	-- end 
	self:ClearDialogueAnim()
	if self.txtTween and self.txtTween:IsPlaying() then
		self.txtTween:Kill(false)
	end

	if noTween == true then
		self.comDialogueText.text = self.dialogue
		self.objFrames_arrow:SetActive(true)
		return
	end

	-- 播放打字动画 --
	local funcDialogComplete = function() 
		self:DialogEnd()
		if self.isSpeedUp then
			self:ExitDialog()
		end
	end
	-- 快进对话模式不显示打字动画
	local bFastChatModel = DialogRecordDataManager:GetInstance():IsFastChatOpen() == true
	if bFastChatModel then
		self.comDialogueText.text = tostring(self.dialogue)
		funcDialogComplete()
	else
		self.comDialogueText.text = ""
		self.objFrames_arrow:SetActive(false)
		local fTypeSpeed = PlayerSetDataManager:GetInstance():GetStoryChatSpeed() or 0
		local dura = (bFastChatModel or self.isSpeedUp) and (1 / 20) or (string.utf8len(self.dialogue) * fTypeSpeed)
		self.txtTween = self.comDialogueText:DOText(tostring(self.dialogue), dura, true, DRCSRef.ScrambleMode.None, ""):SetEase(DRCSRef.Ease.Linear)
		self.txtTween.onComplete = funcDialogComplete
	end
end

function DialogueUI:ClearDialogueAnim()
	for _, tween in pairs(self._tween) do 
		if type(tween.Kill) == 'function' then 
			tween:Kill(false)
		end
	end
	self._tween = {}
	self.comRoleCGScript:KillTween()
end

function DialogueUI:UpdateRole(roleTypeID, storyActionStr, storyEffectStr, StoryMood, roleNameID, roleArtID, playerID)
	self.roleTypeID = roleTypeID
	self:ResetOriginalValue()
	self:UpdateRoleImg(roleTypeID, roleArtID, playerID)
	self:UpdateRoleName(roleTypeID, roleNameID, playerID)
	self:UpdateRoleFavor(roleTypeID)
	self:UpdateRoleMood(StoryMood)
	self:ProcStoryEffect(storyEffectStr)
	self:ProcStoryAction(storyActionStr, storyEffectStr)
end

function DialogueUI:UpdateRoleImg(roleTypeID, roleArtID, playerID)
	self.objCG:SetActive(false)
	local roleDataMgr = RoleDataManager:GetInstance()
	local artData = nil
	if playerID ~= nil and roleDataMgr:GetPlayerInfo(playerID) ~= nil then 
		local playerInfo = roleDataMgr:GetPlayerInfo(playerID)
		roleArtID = playerInfo.uiModelID
	end
	if roleArtID == nil then 
		artData = roleDataMgr:GetRoleArtDataByTypeID(roleTypeID)
	else
		artData = TableDataManager:GetInstance():GetTableData("RoleModel", roleArtID)
	end
    if artData == nil then 
        return
    end
	local roleCG = artData.Drawing
	self.strRoleHead = artData.Head
	if roleCG then 
		self.objCG:SetActive(true)
		self.comRoleCGImg.sprite = GetSprite(roleCG)
	else
		self.comRoleCGImg.sprite = nil
	end
	--self.comRoleCGImg:SetNativeSize()
	local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
	--TODO 捏脸17 立绘 通过RoleTypeID来判断是否是主角 拿到主角createRoleID 再调接口判断是否有捏脸数据
	local iMainRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
	local iMainRoleCreateRoleID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
	local iRoleTypeID = roleTypeID
	if iRoleTypeID == iMainRoleTypeID then 
		iRoleTypeID = iMainRoleCreateRoleID
	end
	if iRoleTypeID == iMainRoleCreateRoleID and CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, iRoleTypeID) then
		self.objCG:SetActive(false)
		-- 调用接口 生成立绘Prefab
		if self.objCreateCG then
			self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, iRoleTypeID, self.objCreateCGParent, self.objCreateCG)
			self.objCreateCG:SetActive(true)
		else
			self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, iRoleTypeID, self.objCreateCGParent)
		end
	else
		if self.objCreateCG then
			self.objCreateCG:SetActive(false)
		end
	end
end

function DialogueUI:ProcStoryAction(storyActionStr, storyEffectStr)
	local storyAction = StoryAction_Revert[storyActionStr]
	local storyEffect = StoryEffect_Revert[storyEffectStr]
	if storyAction == StoryAction.SA_Shack then
		self._tween.ShakeTween = AnimationMgr:GetInstance():ShakeAction(self._tween.ShakeTween, self.objCG, 0.3, DRCSRef.Vec3(30,30,30))
	elseif storyAction == StoryAction.SA_Movein then
		self._tween.moveInTween = AnimationMgr:GetInstance():MoveInAction(self._tween.moveInTween, self.objCG, self.comRoleCGRect.localScale.x < 0 and -1 or 1, 800, self.comRoleCGRect.anchoredPosition.x, 0.3)
	elseif storyAction == StoryAction.SA_Moveout then
		self._tween.moveOutTween = AnimationMgr:GetInstance():MoveOutAction(self._tween.moveOutTween, self.objCG, self.comRoleCGRect.localScale.x < 0 and -1 or 1, 800, 0.3)
	elseif storyAction == StoryAction.SA_Fadein then
		self._tween.FadeInTween = AnimationMgr:GetInstance():FadeAction(self._tween.FadeInTween, self.comRoleCGImg, 0, 255, 0.5)
	elseif storyAction == StoryAction.SA_Fadeout then
		local deltaTime = 0.5
		self._tween.FadeOutTween = AnimationMgr:GetInstance():FadeAction(self._tween.FadeOutTween, self.comRoleCGImg, 255, 0, deltaTime)
		self.comRoleCGScript:DoAlphaFactor(0, deltaTime)
		-- local curColor = self.comRoleCGScript.Color
		-- if curColor then 
		-- 	self.comRoleCGScript:DoColor(curColor.r, curColor.g, curColor.b, 0, deltaTime)
		-- end
	elseif storyAction == StoryAction.SA_Show then
		if storyEffect == nil or storyEffect == StoryEffect.SE_White then -- 白色显型
			local func = function()
				self.comRoleForeCGImg.gameObject:SetActive(false)
				self.comRoleCGMask.enabled = false
			end
			self.comRoleCGMask.enabled = true
			self.comRoleForeCGImg.gameObject:SetActive(true)
			self._tween.whiteShowTween = AnimationMgr:GetInstance():FadeAction(self._tween.whiteShowTween, self.comRoleForeCGImg, 255, 0, 0.3, 0.2, nil, func) 
		elseif storyEffect == StoryEffect.SE_Mask then -- 剪影显型
			self.comRoleCGScript.EdgeWidth = 2.23
			self.comRoleCGScript.AlphaFactor = 0.12
			self.comRoleCGScript.Color = CS.UnityEngine.Color32(48,48,48,255)
			self.comRoleCGScript.EdgeColor = CS.UnityEngine.Color32(255, 255, 255, 255)
		end
	elseif storyAction == StoryAction.SA_Floatin then
		self._tween.FloatinXTween = AnimationMgr:GetInstance():MoveInAction(self._tween.FloatinXTween, self.objCG, self.comRoleCGRect.localScale.x < 0 and -1 or 1, 800, self.comRoleCGRect.anchoredPosition.x, 0.5)
		self._tween.FloatinFadeTween = AnimationMgr:GetInstance():FadeAction(self._tween.FloatinFadeTween, self.comRoleCGImg, 0, 255, 0.5)
	elseif storyAction == StoryAction.SA_Floatout then
		self._tween.FloatoutXTween = AnimationMgr:GetInstance():MoveOutAction(self._tween.FloatoutXTween, self.objCG, self.comRoleCGRect.localScale.x < 0 and -1 or 1, 800, 0.5)
		self._tween.FloatoutXTween:SetDelay(1.7)
		self._tween.FloatoutFadeTween = AnimationMgr:GetInstance():FadeAction(self._tween.FloatoutFadeTween, self.comRoleCGImg, 255, 0, 0.5, 1.7)
	elseif storyAction == StoryAction.SA_Zoom then
		local func = function()
			self._tween.ZoomOutTween = AnimationMgr:GetInstance():ZoomAction(self._tween.ZoomOutTween, self.objCG, DRCSRef.Vec3(-1.1,1.1,1.1), DRCSRef.Vec3(-1,1,1), 0.15)
		end
		self._tween.ZoomInTween = AnimationMgr:GetInstance():ZoomAction(self._tween.ZoomInTween, self.objCG, DRCSRef.Vec3(-1,1,1), DRCSRef.Vec3(-1.1,1.1,1.1), 0.15, nil, func)
	end
end

function DialogueUI:ProcStoryEffect(storyEffect)
	self:ResetStoryEffect()
	
	if StoryEffect_Revert[storyEffect] == StoryEffect.SE_Hidden then
		self.objCG:SetActive(false)
	elseif StoryEffect_Revert[storyEffect] == StoryEffect.SE_Mask then
		if (CucolorisMaterial ~= nil) then
			self.comRoleCGImg.material = CucolorisMaterial
		end
		self.comRoleCGScript.EdgeWidth = 2.23
		self.comRoleCGScript.AlphaFactor = 0.12
		self.comRoleCGScript.Color = CS.UnityEngine.Color32(48,48,48,255)
		self.comRoleCGScript.EdgeColor = CS.UnityEngine.Color32(255, 255, 255, 255)
	elseif StoryEffect_Revert[storyEffect] == StoryEffect.SE_White then
		self.comRoleForeCGImg.gameObject:SetActive(true)
		self.comRoleCGMask.enabled = true
	elseif StoryEffect_Revert[storyEffect] == StoryEffect.SE_Flash then
		local waitTime = CS.UnityEngine.WaitForSeconds(0.1)
		self._coroutine.flashWhite = CS_Coroutine.start(function()
			self.comWhiteForegroundImage.gameObject:SetActive(true)
			coroutine.yield(waitTime)
			self.comWhiteForegroundImage.gameObject:SetActive(false)
			coroutine.yield(waitTime)
			self.comWhiteForegroundImage.gameObject:SetActive(true)
			coroutine.yield(waitTime)
			self.comWhiteForegroundImage.gameObject:SetActive(false)
		end)
	end
end

function DialogueUI:ResetStoryEffect()
	self.comRoleCGImg.material = nil
	self.comRoleCGMask.enabled = false
	self.comRoleForeCGImg.gameObject:SetActive(false)
	self.comRoleCGMask.enabled = false
	self.comWhiteForegroundImage.gameObject:SetActive(false)
end

function DialogueUI:ResetCoroutine()
	if self._coroutine.flashWhite then 
		CS_Coroutine.stop(self._coroutine.flashWhite)
		self._coroutine.flashWhite = nil
	end
	if self._coroutine.MaskShow then 
		CS_Coroutine.stop(self._coroutine.MaskShow)
		self._coroutine.MaskShow = nil
	end
end

function DialogueUI:MarkOriginalValue()
	self.ShaderColor =  CS.UnityEngine.Color32(255,255,255,255)
	self.EdgeWidth = 0
	self.CGColor = self.comRoleCGImg.color
	self.CGRectPosX = self.comRoleCGRect.anchoredPosition.x
	self.CGRectPosY = self.comRoleCGRect.anchoredPosition.y
	self.CGRecsPos = DRCSRef.Vec2(self.CGRectPosX, self.CGRectPosY)
	self.CGScale = self.comRoleCGRect.localScale
end

function DialogueUI:ResetOriginalValue()
	if self.comRoleCGImg and self.CGColor then
		self.comRoleCGImg.color = self.CGColor
	end
	if self.comRoleCGRect and self.CGRecsPos then
		self.comRoleCGRect.anchoredPosition = self.CGRecsPos
	end
	if self.comRoleCGRect and self.CGScale then
		self.comRoleCGRect.localScale = self.CGScale
	end
	if self.comRoleCGScript then
		if self.ShaderColor then
			self.comRoleCGScript.Color = self.ShaderColor
		end
		if self.EdgeWidth then
			self.comRoleCGScript.EdgeWidth = self.EdgeWidth
		end
	end

	self.transCG.localPosition = self.v3OriCGPos

	self.objCG:SetActive(true)
	self.comRoleForeCGImg.gameObject:SetActive(false)
	self.objRoleMoodBg:SetActive(false)
	self.comRoleCGMask.enabled = false
end

local Path_StoryMood = {
	["-"] = StoryMood.SM_Null;
	["喜悦"] = "aixin";
	["惊讶"] = "jingya";
	["愤怒"] = "zoumei";
	["疑惑"] = "wenhao";
	["流汗"] = "hanyan";
	["烦躁"] = "fanzao";
	["沉默"] = "wuyu";
	["灵光"] = "hanghua";
	["爱意"] = "aixin";
	["心碎"] = "liexin";
  }
  
--表情
function DialogueUI:UpdateRoleMood(StoryMood)
	if not StoryMood then
		return
	end

	if self.objMood ~= nil then
		ReturnObjectToPool(self.objMood.gameObject)
		self.objMood = nil
	end

	if (Path_StoryMood[StoryMood]) then
		local mood = tostring(Path_StoryMood[StoryMood])
		if (mood ~= nil and mood ~= "") then
			self.objMood = LoadPrefabFromPool("UI/UISprite/Mood/"..mood,self.objRoleMoodBg.transform,true)
			self.objMood.transform.localScale = DRCSRef.Vec3(100,100,100)
			self.SortingGroup = self.objMood:GetComponent(typeof(DRCSRef.SortingGroup)) 
			if self.SortingGroup == nil then 
				self.SortingGroup = self.objMood:AddComponent(typeof(DRCSRef.SortingGroup))
			end
			if self.objParent and (not self.canvasParent) then
				self.canvasParent = self.objParent:GetComponent(DRCSRef_Type.Canvas)
			end
			if self.canvasParent then
				self.SortingGroup.sortingOrder = self.canvasParent.sortingOrder + 5
			else
				self.SortingGroup.sortingOrder = 10000
			end
		end
	end
	
	self.objRoleMoodBg:SetActive(StoryMood_Revert[StoryMood] ~= StoryMood.SM_Null)
end

function DialogueUI:UpdateRoleName(roleTypeID, roleNameID, playerID)
	local roleDataMgr = RoleDataManager:GetInstance()
	roleTypeID = roleTypeID or 0
	local uiRoleID = roleDataMgr:GetRoleID(roleTypeID)
	self.uiRoleID = uiRoleID
	local name = ""
	local sName = nil
	local titleName = ""
	if playerID and roleDataMgr:GetPlayerInfo(playerID) ~= nil then 
		name = roleDataMgr:GetPlayerName(playerID)
		sName = roleDataMgr:GetPlayerName(playerID)
		
	elseif roleNameID == nil then 
		if uiRoleID > 0 then
			name = roleDataMgr:GetRoleTitleAndName(uiRoleID)
			sName = roleDataMgr:GetRoleName(uiRoleID)
			titleName = roleDataMgr:GetRoleTitleStr(uiRoleID)
		elseif roleTypeID > 0 then
			name = roleDataMgr:GetRoleTitleAndName(roleTypeID, true)
			sName = roleDataMgr:GetRoleNameByTypeID(roleTypeID)
			titleName = roleDataMgr:GetRoleTitleStr(roleTypeID,true)
		end
	else
		name = GetLanguageByID(roleNameID) 
		sName =  GetLanguageByID(roleNameID) 
	end
	
	name = tostring(name)
	if DEBUG_MODE then 
		name = name .. '(' .. tostring(uiRoleID) .. ')'
	end
	self.strRoleName = name
	self.comNameText.text = sName
	self.comTitleText.text = titleName
	if self.objNameTitleFlag then 
		self.objNameTitleFlag:SetActive(false)
		local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(uiRoleID,NET_NAME_ID)
		if BeEvolution and BeEvolution.iParam2 == -1 then
			self.objNameTitleFlag:SetActive(true)
			self.iEvoPlayerID = BeEvolution.iParam1
		elseif dnull(playerID) then
			self.objNameTitleFlag:SetActive(true)
			self.iEvoPlayerID = playerID
		end 
	end
	self.objDialogBg:SetActive(true)
	-- if dnull(sName) then
	-- 	self.objDialogBg:SetActive(true)
	-- else
	-- 	self.objDialogBg:SetActive(false)
	-- end
end

-- 更新角色好感度
function DialogueUI:UpdateRoleFavor(roleTypeID)
	if not roleTypeID then return end
	local instance = RoleDataManager:GetInstance()
	local srcID = instance:GetRoleID(roleTypeID)	-- 这里由于是任务生成的人物，与他对话的时候，可能还没有动态数据
	local mainRoleID = instance:GetMainRoleID()
	if (srcID == mainRoleID) then
		self.objFavor_box:SetActive(false)
		return
	end

	local favorData = instance:GetDispotionDataToMainRole(srcID, roleTypeID)
	local new_favor = favorData.iValue

	local isRecover = false
	if self.dialogueInfo and self.dialogueInfo.recover then
		isRecover = true
	end

	if new_favor and (self.external == 'SelectUI') and WindowsManager:GetInstance():IsWindowOpen(self.external) then
		-- 显示好感度UI，播动画
		self.objFavor_box:SetActive(true)
		self.comFavor_Text.text = new_favor
		self.comFavor_box_DT:DORestart()
		local roleFavorChangeMsg = RoleDataManager:GetInstance():ReadRoleFavorChangeMsg(roleTypeID)
		if roleFavorChangeMsg then 
			if roleFavorChangeMsg.iEnd >roleFavorChangeMsg.iStart then 
				PlayButtonSound("EventFavorUp")
			end
		end
	else
		self.objFavor_box:SetActive(false)
	end
end

function DialogueUI:CheckRoleFavorCache(roleTypeID)
	local roleFavorChangeMsg = RoleDataManager:GetInstance():ReadRoleFavorChangeMsg(roleTypeID)
	if roleFavorChangeMsg then
		self:ShowRoleFavorUp(roleFavorChangeMsg.roleTypeID, roleFavorChangeMsg.iStart, roleFavorChangeMsg.iEnd)
	end
end

-- 显示好感度过渡动画
function DialogueUI:ShowRoleFavorUp(roleTypeID, iStart, iEnd)
	-- TODO: 部分剧本/角色 不要显示好感度 与动画
	if not (roleTypeID and iStart and iEnd) or (iStart == iEnd) then 
		self.objFavor_box:SetActive(false)
		self.objFavor_Text_action:SetActive(false)
		return 
	end
	if not self.objCG.activeSelf then
		RoleDataManager:GetInstance():CacheRoleFavorChangeMsg(roleTypeID, iStart, iEnd)
		self.objFavor_box:SetActive(false)
		self.objFavor_Text_action:SetActive(false)
		return
	end
	-- 显示好感度UI，播动画
	self.objFavor_box:SetActive(true)
	self.objFavor_Text_action:SetActive(true)
	self.comFavor_Text.text = iEnd
	self.comFavor_box_DT:DORestart()
	
	self.comFavor_Text_action.text = iStart
	DRCSRef.DOTween.Restart("roll")
end

function DialogueUI:RefreshUI(dialogueInfo, bIsImpressionDesc)
	-- FIXME: 服务器那边调用次数太多了，至少刷了20多次，这里先做一个重复处理
	-- 但是连续点击同一个人，或者一个人连续说两次同样的话，就没刷新
	if self.dialogueInfo and DataIsEqual(dialogueInfo, self.dialogueInfo) then
		return 
	end
	self:ResetCoroutine()
	self.dialogueInfo = dialogueInfo
	if (dialogueInfo ~= nil) then
		local dialogueID = dialogueInfo.dialogueID or dialogueInfo.dialogueStr
		local roleTypeID = dialogueInfo.roleTypeID
		local roleNameID = dialogueInfo.roleNameID
		local roleArtID = dialogueInfo.roleArtID
		local storyActionStr = dialogueInfo.StoryAction
		local storyEffectStr = dialogueInfo.StoryEffect
		local StoryMood = dialogueInfo.StoryMood
		local resourceBgmID = dialogueInfo.resourceBgmID
		local noTween = dialogueInfo.noTween
		local playerID = dialogueInfo.playerID
		self:UpdateUI(dialogueID, roleTypeID, storyActionStr, storyEffectStr, StoryMood,resourceBgmID, roleNameID, roleArtID, noTween, bIsImpressionDesc, playerID)
		
		-- 若是在战斗场景,则隐藏模糊背景和战斗UI,只显示战斗背景
		ShowBattleUIDialogueUI(false)
	end
end

-- 若是在战斗场景,则关闭对话时重新显示战斗UI
function DialogueUI:RedisplayBattleUI()
	
end

function DialogueUI:OnEnable()
	self.toShow = true
	BlurBackgroundManager:GetInstance():ShowBlurBG()
	-- 打开对话控制界面
	if not IsWindowOpen("DialogControlUI") then
		OpenWindowImmediately("DialogControlUI", true)
	end
end

function DialogueUI:OnDisable()
	self.toShow = false
	BlurBackgroundManager:GetInstance():HideBlurBG()
	-- 关闭对话控制界面
	if IsWindowOpen("DialogControlUI") then
		RemoveWindowImmediately("DialogControlUI")
	end
end

return DialogueUI