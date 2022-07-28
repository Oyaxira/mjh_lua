ChoiceUI = class("ChoiceUI",BaseWindow)

function ChoiceUI:ctor()
end

function ChoiceUI:Create()
	local obj = LoadPrefabAndInit("Interactive/ChoiceUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end



function ChoiceUI:Init()
	self.objChoiceContent = self:FindChild(self._gameObject, "TransformAdapt_node_right/ChoiceView/Viewport/Content")
	self.comUIAction = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/ChoiceView", "LuaUIAction")
	if self.comUIAction ~= nil then
		self.comUIAction:SetPointerEnterAction(function()
			g_isInScrollRect = true
		end)
		self.comUIAction:SetPointerExitAction(function()
			g_isInScrollRect = false
		end)
	end
	self.comRoleCGImg = self:FindChildComponent(self._gameObject, "NameBox/RoleCG", DRCSRef_Type.Image)
	self.objCreateCGParent = self:FindChild(self._gameObject, "NameBox/CreateCG")
	self.comNameText = self:FindChildComponent(self._gameObject, "NameBox/Text", DRCSRef_Type.Text)
	self.comTitleText = self:FindChildComponent(self._gameObject, "NameBox/Text/TitleText", DRCSRef_Type.Text)
	self.objNameBack = self:FindChild(self._gameObject, "NameBox/Back")
	self.objNameTitleFlag = self:FindChild(self._gameObject, "NameBox/TitleFlag")
	self.comNameTitleFlagButton = self.objNameTitleFlag:GetComponent('DRButton')
	if self.comNameTitleFlagButton then
		self:RemoveButtonClickListener(self.comNameTitleFlagButton)
		self:AddButtonClickListener(self.comNameTitleFlagButton, function()
			self:OnClickTitleFlag()
		end)
	end

	self.comDialogueText = self:FindChildComponent(self._gameObject, "NameBox/DialogueText", "Text")
	self.comDialogueOutline = self:FindChildComponent(self._gameObject, "NameBox/DialogueText", 'OutlineEx')
	self.comDialogueOutline.enabled = false 

	self:ResetChoiceUI()
end

function ChoiceUI:RefreshUI(selectInfo)
	
end

function ChoiceUI:AddChoice(choiceLangID, customCallback, isLocked, choiceText, deletFunc, isKeyChoice, taskID)
    local objCloneChoice = self:GetAvailableChoiceButtonObj()
	local comBtn = objCloneChoice:GetComponent(DRCSRef_Type.Button)
	self:RemoveButtonClickListener(comBtn)
	local comBack = objCloneChoice:GetComponent(DRCSRef_Type.Image)
	local comText = self:FindChildComponent(objCloneChoice, "dialogue/Text", DRCSRef_Type.Text)
	local objImage = self:FindChild(objCloneChoice,"dialogue/Image")
	local comImage = objImage:GetComponent(DRCSRef_Type.Image)
	local objAnim = self:FindChild(objCloneChoice, "anim")
	local comDtAnim = objAnim:GetComponent(DRCSRef_Type.DOTweenAnimation)
	local comLockImage = self:FindChildComponent(objCloneChoice, "dialogue/lock", DRCSRef_Type.Image)
	local comNumText = self:FindChildComponent(objCloneChoice,"Num/Text", DRCSRef_Type.Text)
	local comLuaAction = objCloneChoice:GetComponent('LuaUIPointAction')
    if comLuaAction then 
        comLuaAction:SetPointerEnterAction(function()
            comBack.sprite = GetSprite("DialogueUI/bt_xuanxiangdi_ss")
        end)
        comLuaAction:SetPointerExitAction(function()
            comBack.sprite = GetSprite("DialogueUI/bt_xuanxiangdi")
        end)
    end
	comNumText.text = tostring(self.iChoiceIndex) 
	self.iChoiceIndex = self.iChoiceIndex + 1
	objImage:SetActive(false)
	if choiceText == '' then 
		choiceText = nil

	end
    choiceText = choiceText or GetLanguageByID(choiceLangID, taskID) or ""
	if choiceText == '返回' or choiceText == '离开' or choiceText == '算了' then
		self.btnExit = comBtn
	end
	comText.text = choiceText
	if isLocked then
		local objKeyOptionFrameAnim = self:FindChild(objCloneChoice, "KeyOptionFrameAnim")
		objKeyOptionFrameAnim:SetActive(false)

		comText.color = UI_COLOR.red
		objImage:SetActive(true)
		local lockSprite = comLockImage.sprite
		comImage.sprite = lockSprite
		SetUIAxis(objImage, lockSprite.rect.width, lockSprite.rect.height)
		objImage.transform.localScale = DRCSRef.Vec3(1, 1, 1)
		self:AddButtonClickListener(comBtn, function()
			SystemUICall:GetInstance():Toast("你的条件不足, 无法解锁该选项")
		end)
	else
		local objKeyOptionFrameAnim = self:FindChild(objCloneChoice, "KeyOptionFrameAnim")
		-- 判断是否为关键选项
		if isKeyChoice then 
			-- 显示关键选项动画
			objKeyOptionFrameAnim:SetActive(true)
		else
			objKeyOptionFrameAnim:SetActive(false)
		end
		comText.color = UI_COLOR.black
		local callback = function()
			if type(customCallback) == 'function' then 
				customCallback()
			else
				SendClickChoiceCMD(choiceLangID)
			end
			if deletFunc then
				deletFunc()
			end
			comDtAnim.tween.onComplete = nil
		end
		if callback then
			self:AddButtonClickListener(comBtn, function()
				-- 等待下行时不允许点击
				if g_isWaitingDisplayMsg then 
					return
				end
				objAnim:SetActive(true)
				RewindDoAnimation(objCloneChoice)
				comDtAnim:DOPlayAllById("anim")
				comDtAnim.tween.onComplete = callback
				AddLoadingDelayRemoveWindow('DialogChoiceUI', false)
				-- 记录选项
				DialogRecordDataManager:GetInstance():RecordDialog(string.format("你选择了\"%s\"", choiceText))
			end)
		end
	end
end

function ChoiceUI:OnPressESCKey()
	if self.btnExit then
		self.btnExit.onClick:Invoke()
	end
end

--通过键盘输入的数字激活选项
function ChoiceUI:ActivateBtn(index)
	local childCount = self.objChoiceContent.transform.childCount
	if childCount < index then
		return
	end
	local objBtn = self.objChoiceContent.transform:GetChild(index - 1)
	if objBtn and objBtn.gameObject.activeSelf then
		local comText = self:FindChildComponent(objBtn.gameObject, "dialogue/Text", DRCSRef_Type.Text)
		if comText.text ~= "返回" and comText.text ~= "离开" then
			local comBtn = objBtn.gameObject:GetComponent(DRCSRef_Type.Button)
			comBtn.onClick:Invoke()
		end
	end
end

function ChoiceUI:UpdateChoiceText(textLangID, roleTypeID, tipText, boolean_outline, taskID, customModelID, playerName)
	self.strRoleName = nil
	self.strRoleHead = nil
	self:UpdateDialogueText(textLangID, tipText,boolean_outline, taskID)
	self:UpdateRole(roleTypeID, customModelID, playerName)
	-- 对话记录
	local kRecInfo = {
		['roleBaseID'] = roleTypeID,
		['name'] = self.strRoleName,
		['avatar'] = self.strRoleHead,
	}
	DialogRecordDataManager:GetInstance():RecordDialog(self.dialogue, kRecInfo)
end

function ChoiceUI:UpdateChoiceTextStr(textLangID, roleTypeID, tipText,boolean_outline)
	self:UpdateDialogueTextStr(textLangID, tipText,boolean_outline)
	self:UpdateRole(roleTypeID)
end

function ChoiceUI:UpdateDialogueTextStr(textLangStr, roleTypeID, tipText,boolean_outline)
	if tipText == '' then 
		tipText = nil
	end
	self.dialogue = tipText or textLangStr
	local keepDialogue = StringHelper:GetInstance():GetPlot()
	if 	keepDialogue and keepDialogue ~= '' then
		StringHelper:GetInstance():SetPlot('')
	end
	self.comDialogueOutline.enabled = boolean_outline or false
	self.dialogue = keepDialogue..StringHelper:GetInstance():NameConversion(self.dialogue)
	self.dialogue = string.gsub(self.dialogue, '\\n', '\n')
	self.comDialogueText.text = ''
	self.comDialogueText:DOText(tostring(self.dialogue), DOTWEEN_DOTEXT_SPEED, true, DRCSRef.ScrambleMode.None, ""):SetEase(DRCSRef.Ease.Linear)
end

function ChoiceUI:UpdateDialogueText(textLangID, tipText, boolean_outline, taskID)
	if tipText == '' then 
		tipText = nil
	end
	self.dialogue = tipText or GetLanguageByID(textLangID, taskID)
	local keepDialogue = StringHelper:GetInstance():GetPlot()
	if 	keepDialogue and keepDialogue ~= '' then
		StringHelper:GetInstance():SetPlot('')
	end
	self.comDialogueOutline.enabled = boolean_outline or false
	self.dialogue = keepDialogue..StringHelper:GetInstance():NameConversion(self.dialogue)
	self.dialogue = string.gsub(self.dialogue, '\\n', '\n')
	self.comDialogueText.text = ''
	self.comDialogueText:DOText(tostring(self.dialogue), DOTWEEN_DOTEXT_SPEED, true, DRCSRef.ScrambleMode.None, ""):SetEase(DRCSRef.Ease.Linear)
end

function ChoiceUI:UpdateRole(roleTypeID, customModelID, playerName)
	self:UpdateRoleImg(roleTypeID, customModelID)
	self:UpdateRoleName(roleTypeID, playerName)
end

function ChoiceUI:UpdateRoleImg(roleTypeID, customModelID)
	local tableDataMgr = TableDataManager:GetInstance()
	local artData
	if customModelID ~= nil and tableDataMgr:GetTableData("RoleModel", customModelID) ~= nil then 
		artData = tableDataMgr:GetTableData("RoleModel", customModelID)
	else
		artData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleTypeID)
	end
    if artData == nil then 
        return
    end
	local roleCG = artData.Drawing 
	self.strRoleHead = artData.Head
	if roleCG then 
		self.comRoleCGImg.sprite = GetSprite(roleCG)
		self.comRoleCGImg.gameObject:SetActive(true)
	else
		self.comRoleCGImg.sprite = nil
		self.comRoleCGImg.gameObject:SetActive(false)
	end
	--self.comRoleCGImg:SetNativeSize()
	-- TODO捏脸部分
	local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
	local iMainRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
    local iMainRoleCreateRoleID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
	local iRoleTypeID = roleTypeID
	if iRoleTypeID == iMainRoleTypeID then 
		iRoleTypeID = iMainRoleCreateRoleID
	end
	if iRoleTypeID == iMainRoleCreateRoleID and CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, iRoleTypeID) then
		self.comRoleCGImg.gameObject:SetActive(false)
		-- 调用接口 生成立绘Prefab
		if self.objCreateFace then
			self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, iRoleTypeID, self.objCreateCGParent, self.objCreateFace)
			self.objCreateFace:SetActive(true)
		else
			self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, iRoleTypeID, self.objCreateCGParent)
		end
	else
		if self.objCreateFace then
			self.objCreateFace:SetActive(false)
		end
	end
end

function ChoiceUI:UpdateRoleName(roleTypeID, playerName)
	local roleMgr = RoleDataManager:GetInstance()
	local name = roleMgr:GetRoleTitleAndName(roleTypeID, true)
	if type(playerName) == 'string' and playerName ~= '' then
		name = playerName
	else
		name = roleMgr:GetRoleTitleAndName(roleTypeID, true)
	end
	self.strRoleName = tostring(name)
	self.comNameText.text = roleMgr:GetRoleNameByTypeID(roleTypeID)
	local roleID = roleMgr:GetRoleID(roleTypeID)
	if roleID > 0 then
		self.comTitleText.text = roleMgr:GetRoleTitleStr(roleID) or ""
	else
		self.comTitleText.text = roleMgr:GetRoleTitleStr(roleTypeID, true) or ""
	end
	
	if name ~= nil then
		self.objNameBack:SetActive(true)
	else
		self.objNameBack:SetActive(false)
	end
	if self.objNameTitleFlag then 
		self.objNameTitleFlag:SetActive(false)
		local roleID = roleMgr:GetRoleID(roleTypeID)
		local evolutionData = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID, NET_NAME_ID)
		if evolutionData and evolutionData.iParam2 == -1 then
			self.objNameTitleFlag:SetActive(true)
			self.playerID = evolutionData.iParam1
		elseif dnull(playerName) and dnull(roleMgr:GetPlayerIDByName(playerName)) then
			self.objNameTitleFlag:SetActive(true)
			self.playerID = roleMgr:GetPlayerIDByName(playerName)
		end 
	end
end

function ChoiceUI:OnClickTitleFlag()
	if self.playerID then 
		SendGetPlatPlayerDetailInfo(self.playerID, RLAYER_REPORTON_SCENE.UserBoard)	
	end 
end

function ChoiceUI:GetAvailableChoiceButtonObj()
	local childCount = self.objChoiceContent.transform.childCount
	for i = 1, childCount do 
		local objBtn = self.objChoiceContent.transform:GetChild(i - 1)
		if not objBtn.gameObject.activeSelf then 
			objBtn.gameObject:SetActive(true)
			return objBtn.gameObject
		end
	end
	local objBtn = LoadPrefabAndInit("Interactive/ChoiceButtonUI", self.objChoiceContent, true)
	if (objBtn ~= nil and objBtn.gameObject ~= nil) then
		objBtn.gameObject:SetActive(true)
		return objBtn.gameObject
	end
	return nil
end

function ChoiceUI:ResetChoiceUI()
	self.iChoiceIndex = 1
	self:ResetChoiceText()
	self:ResetChoiceBtn()
end

function ChoiceUI:ResetChoiceText()
	self.comRoleCGImg.sprite = nil
	self.comRoleCGImg.gameObject:SetActive(false)
	self.comNameText.text = ''
	self.comTitleText.text = ""
	self.comDialogueText.text = ''
end

function ChoiceUI:ResetChoiceBtn()
	local childCount = self.objChoiceContent.transform.childCount
	for i = 1, childCount do 
		local objBtn = self.objChoiceContent.transform:GetChild(i - 1)
		objBtn.gameObject:SetActive(false)
	end
end

function ChoiceUI:OnDestroy()
end

function ChoiceUI:OnEnable()
	self.toShow = true
	BlurBackgroundManager:GetInstance():ShowBlurBG()
	-- 打开对话控制界面
	if not IsWindowOpen("DialogControlUI") then
		OpenWindowImmediately("DialogControlUI")
	end
	HideAllHUD()
end

function ChoiceUI:OnDisable()
	self.toShow = false
	self:ResetChoiceUI()
	BlurBackgroundManager:GetInstance():HideBlurBG()
	-- 关闭对话控制界面
	if IsWindowOpen("DialogControlUI") then
		RemoveWindowImmediately("DialogControlUI")
	end
	ShowAllHUD()
end

return ChoiceUI