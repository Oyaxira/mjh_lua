SelectUI = class("SelectUI",BaseWindow)
local DialogueUICom = require 'UI/Interactive/DialogueUI'

-- 任务标记
local CommonAtlas = {
	'main_new', 'main_doing', 'main_done',
	'regional_new', 'regional_doing', 'regional_done',
}

local UPDATE_TYPE = 
{
	UPDATE_ROLE_DATA = 1,
	UPDATE_CHOICE = 2,
	UPDATE_ROLE = 3,
	UPDATE_INTERACT = 4,
}
local InterctGroupData = 
{
	Introduce = 1,
	Show = 2,
	Observe = 3,
	GiveGift = 4,
	Compare = 5,
	Absorb = 6,
	Invite = 7,
	LearnMartial = 8,
	Marry = 9,
	Sworn = 10,
	Beg = 11,
	Fight = 12,
	CallUp = 13,
	Punish = 14,
	Inquiry = 15,
}

local KeyCodeNum = {
    CS.UnityEngine.KeyCode.Alpha1,
    CS.UnityEngine.KeyCode.Alpha2,
    CS.UnityEngine.KeyCode.Alpha3,
    CS.UnityEngine.KeyCode.Alpha4,
    CS.UnityEngine.KeyCode.Alpha5,
    CS.UnityEngine.KeyCode.Alpha6,
    CS.UnityEngine.KeyCode.Alpha7,
    CS.UnityEngine.KeyCode.Alpha8,
    CS.UnityEngine.KeyCode.Alpha9,
}

local funcType = {
	FuncType.SwitchDialog1,
	FuncType.SwitchDialog2,
	FuncType.SwitchDialog3,
	FuncType.SwitchDialog4,
	FuncType.SwitchDialog5,
	FuncType.SwitchDialog6,
	FuncType.SwitchDialog7,
	FuncType.SwitchDialog8,
	FuncType.SwitchDialog9,
}
local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown

local hasFlag = HasFlag
function SelectUI:ctor()
end

function SelectUI:Create()
	local obj = LoadPrefabAndInit("Interactive/SelectUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function SelectUI:Init()
	self.DialogueUI = self:FindChild(self._gameObject, "DialogueUI")
	self.DialogueUICom = DialogueUICom.new(self.DialogueUI)
	self.DialogueUICom.toShow = nil
	self.DialogueUICom:ExternalInit(self.DialogueUI, 'SelectUI', self._gameObject)
	
	self.selectionContent = self:FindChild(self._gameObject, "TransformAdapt_node_right/SelctionView/Viewport/Content")

	self.comRoleCGImg = self:FindChildComponent(self._gameObject, "RoleCG", DRCSRef_Type.Image)
	self.comNameText = self:FindChildComponent(self._gameObject, "NameBox/Text", DRCSRef_Type.Text)

	self.objSelctionView = self:FindChild(self._gameObject, "TransformAdapt_node_right/SelctionView")
	self.comUIAction = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/SelctionView","LuaUIAction")
	if self.comUIAction ~= nil then 
		self.comUIAction:SetPointerEnterAction(function()
			g_isInScrollRect = true
		end)
		self.comUIAction:SetPointerExitAction(function()
			g_isInScrollRect = false
		end)
	end
	self.objInteractGroup = self:FindChild(self._gameObject, "TransformAdapt_node_right/InteractGroup2")
	self.comUIInteractGroupAction = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/InteractGroup2","LuaUIAction")
	if self.comUIInteractGroupAction ~= nil then 
		self.comUIInteractGroupAction:SetPointerEnterAction(function()
			g_isInScrollRect = true
		end)
		self.comUIInteractGroupAction:SetPointerExitAction(function()
			g_isInScrollRect = false
		end)
	end
	self.objInteractGroup2 = self:FindChild(self._gameObject, "TransformAdapt_node_right/InteractGroup2/Viewport/Content")
	self.objShowImage = self:FindChild(self._gameObject, "TransformAdapt_node_right/ShowImage")
	self.objShowImageText= self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/ShowImage/Text", "Text")
	-- 送礼
	self.objGiveGift = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/GiveGift")
	self.objGiveGiftButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/GiveGift", DRCSRef_Type.Button)
	if self.objGiveGiftButton then
		self:AddButtonClickListener(self.objGiveGiftButton,function()
			OpenWindowByQueue("GiveGiftDialogUI", self.selectInfo.roleID)
		end)
	end

	-- 观察
	self.objObs = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Observe")
	self.objObsButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Observe", DRCSRef_Type.Button)
	if self.objObsButton then
		self:AddButtonClickListener(self.objObsButton,function()
			-- DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_OB_ROLE, false, self.selectInfo.roleID)
			SendNPCInteractOperCMD(NPCIT_WATCH, self.selectInfo.roleID)
		end)
	end

	-- 邀请
	self.objInvite = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Invite")
	self.objInviteBan = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Invite/Ban")
	self.objInviteShader = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Invite/Shader")
	self.objInviteBan:SetActive(false)
	self.comInviteText = self:FindChildComponent(self._gameObject, "InteractGroup2/Viewport/Content/Invite/Text", DRCSRef_Type.Text)
	self.comInviteButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Invite", DRCSRef_Type.Button)
	if self.comInviteButton then
		self:AddButtonClickListener(self.comInviteButton,function()
			self:InviteInteractRole()
		end)
	end

	-- 切磋
	self.objCompare = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Compare")
	self.objCompareRefresh = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Compare/Refresh")
	self.objCompareCompareShader = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Compare/Shader")
	self.objCompareBan = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Compare/Ban")
	self.objCompareBan:SetActive(false)
	self.comCompareText = self:FindChildComponent(self._gameObject, "InteractGroup2/Viewport/Content/Compare/Text", DRCSRef_Type.Text)
	self.objCompareButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Compare", DRCSRef_Type.Button)
	self.comCompareImg = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Compare", DRCSRef_Type.Image)
	if self.objCompareButton then
		self:AddButtonClickListener(self.objCompareButton,function()
			self:CompareWithInteractRole()
		end)
	end
	

	-- 吸能
	self.comAbsorbImg = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Absorb", DRCSRef_Type.Image)

	-- 乞讨
	self.objBegShader = self:FindChild(self.objInteractGroup2, "Beg/Shader")
	self.objBeg = self:FindChild(self.objInteractGroup2, "Beg")
	self.comBegText = self:FindChildComponent(self.objInteractGroup2, "Beg/Text", DRCSRef_Type.Text)
	self.comBegButton = self:FindChildComponent(self.objInteractGroup2,"Beg", DRCSRef_Type.Button)
	self.comBegImg = self:FindChildComponent(self.objInteractGroup2,"Beg", DRCSRef_Type.Image)
	self.objBegRefresh = self:FindChild(self.objInteractGroup2, "Beg/Refresh")
	if self.comBegButton then
		self:AddButtonClickListener(self.comBegButton,function()
			self:BegInteractRole()
		end)
	end

	-- 盘查
	self.objInquiry = self:FindChild(self.objInteractGroup2, "Inquiry")
	self.objInquiryShader = self:FindChild(self.objInteractGroup2, "Inquiry/Shader")
	self.comInquiryText = self:FindChildComponent(self.objInteractGroup2, "Inquiry/Text", DRCSRef_Type.Text)
	self.objInquiryButton = self:FindChildComponent(self.objInteractGroup2,"Inquiry", DRCSRef_Type.Button)
	self.comInquiryImg = self:FindChildComponent(self.objInteractGroup2,"Inquiry", DRCSRef_Type.Image)
	self.objInquiryRefresh = self:FindChild(self.objInteractGroup2, "Inquiry/Refresh")
	if self.objInquiryButton then
		self:AddButtonClickListener(self.objInquiryButton,function()
			self:InquiryInteractRole()
		end)
	end

	-- 请教
	self.objLearnMartial = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/LearnMartial")
	self.objLearnMartialRefresh = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/LearnMartial/Refresh")
	self.comLearnMartialImg = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/LearnMartial", DRCSRef_Type.Image)
	self.comLearnMartialText = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/LearnMartial/Text", DRCSRef_Type.Text)
	self.objLearnMartialButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/LearnMartial", DRCSRef_Type.Button)
	if self.objLearnMartialButton then
		self:AddButtonClickListener(self.objLearnMartialButton,function()
			self:LearnMartial()
		end)
	end

	-- 决斗
	self.objFight = self:FindChild(self.objInteractGroup2, "Fight")
	self.objFightShader = self:FindChild(self.objInteractGroup2, "Fight/Shader")
	self.comFightButton = self:FindChildComponent(self.objInteractGroup2,"Fight", DRCSRef_Type.Button)
	self.comFightImg = self:FindChildComponent(self.objInteractGroup2,"Fight", DRCSRef_Type.Image)
	self.objFightBan = self:FindChild(self.objInteractGroup2, "Fight/Ban")
	self.objFightBan:SetActive(false)
	if self.comFightButton then
		self:AddButtonClickListener(self.comFightButton,function()
			self:ShowDuelSelection()
		end)
	end

	-- 结义
	self.objSworn = self:FindChild(self.objInteractGroup2, "Sworn")
	self.objSwornShader = self:FindChild(self.objInteractGroup2, "Sworn/Shader")
	self.comSwornText = self:FindChildComponent(self.objInteractGroup2, "Sworn/Text", DRCSRef_Type.Text)
	self.objSwornButton = self:FindChildComponent(self.objInteractGroup2,"Sworn", DRCSRef_Type.Button)
	if self.objSwornButton then
		self:AddButtonClickListener(self.objSwornButton,function()	
			if self:GetIfChild(self.selectInfo.roleID) then 
				DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false,RoleDataManager:GetInstance():GetRoleTypeID(self.selectInfo.roleID), "我还只是个孩子，这样是不允许的")
				return 
			end
			AddLoadingDelayRemoveWindow('SelectUI')
			SendNPCInteractOperCMD(NPCIT_SWORN, self.selectInfo.roleID)
		end)
	end

	-- 结婚
	self.objMarry = self:FindChild(self.objInteractGroup2, "Marry")
	self.objMarryShader = self:FindChild(self.objInteractGroup2, "Marry/Shader")
	self.comMarryText = self:FindChildComponent(self.objInteractGroup2, "Marry/Text", DRCSRef_Type.Text)
	self.objMarryButton = self:FindChildComponent(self.objInteractGroup2,"Marry", DRCSRef_Type.Button)
	if self.objMarryButton then
		self:AddButtonClickListener(self.objMarryButton,function()
			if self:GetIfChild(self.selectInfo.roleID) then 
				DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false,RoleDataManager:GetInstance():GetRoleTypeID(self.selectInfo.roleID),"我还只是个孩子，这样是不允许的")
				return 
			end
			AddLoadingDelayRemoveWindow('SelectUI')
			SendNPCInteractOperCMD(NPCIT_MARRY, self.selectInfo.roleID)
		end)
	end

	-- 号召
	self.objCallUp = self:FindChild(self.objInteractGroup2, "CallUp")
	self.objCallUpShader = self:FindChild(self.objInteractGroup2, "CallUp/Shader")
	self.comCallUpText = self:FindChildComponent(self.objInteractGroup2, "CallUp/Text", DRCSRef_Type.Text)
	self.objCallUpButton = self:FindChildComponent(self.objInteractGroup2,"CallUp", DRCSRef_Type.Button)
	self.comCallUpImg = self:FindChildComponent(self.objInteractGroup2,"CallUp", DRCSRef_Type.Image)
	self.objCallUpRefresh = self:FindChild(self.objInteractGroup2, "CallUp/Refresh")
	self.objCallUpBan = self:FindChild(self.objInteractGroup2, "CallUp/Ban")
	self.objCallUpBan:SetActive(false)
	if self.objCallUpButton then
		self:AddButtonClickListener(self.objCallUpButton,function()
			self:ClickCallUp()
		end)
	end

	-- 惩恶
	self.objPunish = self:FindChild(self.objInteractGroup2, "Punish")
	self.objPunishShader = self:FindChild(self.objInteractGroup2, "Punish/Shader")
	self.comPunishText = self:FindChildComponent(self.objInteractGroup2, "Punish/Text", DRCSRef_Type.Text)
	self.objPunishButton = self:FindChildComponent(self.objInteractGroup2,"Punish",DRCSRef_Type.Button)
	self.comPunishImg = self:FindChildComponent(self.objInteractGroup2,"Punish",DRCSRef_Type.Image)
	self.objPunishRefresh = self:FindChild(self.objInteractGroup2, "Punish/Refresh")
	if self.objPunishButton then
		self:AddButtonClickListener(self.objPunishButton,function()
			self:ClickPunish()
		end)
	end

	-- 特别介绍
	self.objSpecialIntroduce = self:FindChild(self._gameObject, "InteractGroup2/Viewport/Content/Introduce")
	self.objSpecialIntroduceButton = self:FindChildComponent(self._gameObject,"InteractGroup2/Viewport/Content/Introduce", DRCSRef_Type.Button)
	if self.objSpecialIntroduceButton then
		self:AddButtonClickListener(self.objSpecialIntroduceButton,function()
			self:ClickSpecialIntroduce()
		end)
	end
	self.updateFlag = 0
	self:InitEventListener()
	g_hasInteract = false

end

function SelectUI:InitEventListener()
	self:AddEventListener("UPDATE_INTERACT_CHOICE", function()
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_CHOICE)
	end)

	self:AddEventListener("UPDATE_DISPOSITION", function(data)
		if type(data) ~= 'table' then 
			return
		end
		-- local curInteractRoleID = self.selectInfo.roleID
		-- if data.uiSrcRoleID == curInteractRoleID or data.uiDstRoleID == curInteractRoleID then 
		-- 	self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_ROLE)
		-- end

		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_ROLE)
	end)

	self:AddEventListener("UPDATE_DELEGATION_TASK_STATE", function()
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_CHOICE)
	end)
	
	--作弊不会刷新
	self:AddEventListener("UPDATE_INTERACT_REFRESHTIMES", function(uiType)
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_INTERACT)
		self.uiInteractType = uiType
	end)

	--邀请后, npc id 会变化, 需要使用inst roll
	self:AddEventListener("UPDATE_MAIN_ROLE_INFO", function()
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_ROLE_DATA)
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_CHOICE)
	end)

	-- 任务进度更新时, 如果选择界面打开, 那么重新查新一下任务标记的状态
	self:AddEventListener("TASK_BROADCAST", function()
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_CHOICE)
	end)
end

function SelectUI:Update(deltaTime)
	if self.updateFlag ~= nil and self.updateFlag ~= 0 then
		if hasFlag(self.updateFlag, UPDATE_TYPE.UPDATE_ROLE_DATA) then
			self:UpdateRoleData()
		end
		if hasFlag(self.updateFlag, UPDATE_TYPE.UPDATE_CHOICE) then
			self:UpdateChoiceList(self.selectInfo) 
		end
		if hasFlag(self.updateFlag, UPDATE_TYPE.UPDATE_ROLE) then
			self:UpdateRole(self.selectInfo.roleID)
		end
		if hasFlag(self.updateFlag, UPDATE_TYPE.UPDATE_INTERACT) then
			self:UpdateInteractUI()
		end
		self.updateFlag = 0
	end
	if self:HasOtherUIWindow() then 
		RemoveWindowImmediately('SelectUI')
	end
	for i = 1,9 do	--1到9的按键支持修改
		if GetKeyDownByFuncType(funcType[i]) then
			self:ActivateBtn(i)
		end
	end
end

function SelectUI:ActivateBtn(index)
	local childCount = self.selectionContent.transform.childCount
	if childCount < index then
		return
	end
	local objBtn = self.selectionContent.transform:GetChild(index - 1)
	if objBtn and objBtn.gameObject.activeSelf then
		local comText = self:FindChildComponent(objBtn.gameObject, "dialogue/Text", DRCSRef_Type.Text)
		if comText.text ~= "返回" then
			local comBtn = objBtn.gameObject:GetComponent(DRCSRef_Type.Button)
			comBtn.onClick:Invoke()
		end
	end
end

function SelectUI:Exit()
	SendClearInteractInfoCMD()
	RoleDataManager:GetInstance():ClearInteractState()
	RemoveWindowImmediately("SelectUI")
end

function SelectUI:ShowOtherSubRoleList(roleData)
	OpenWindowImmediately("DialogChoiceUI")
	local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
	if not dialogChoiceUI then
		return
	end
	local des = "让谁成为" .. RoleDataManager:GetInstance():GetRoleTitleAndName(roleData.uiID) .. "战斗替补呢"
	if roleData.uiSubRole and roleData.uiSubRole > 0 then
		des = des .. ",现在战斗替补是" .. RoleDataManager:GetInstance():GetRoleTitleAndName(roleData.uiSubRole, true)
	end

	dialogChoiceUI:UpdateChoiceText(0, roleData.uiTypeID, des)

	local choicelist = {}
	choicelist[1] = {
		func = function()
			DisplayActionEnd()
		end, 
		str = "返回"
	}

	local auiBroAndSis = table_c2lua(roleData.auiBroAndSis or {})
	auiBroAndSis[#auiBroAndSis + 1] = roleData.uiMarry or 0
	for i=1, #auiBroAndSis do
		if auiBroAndSis[i] > 0 then
			local roleID = RoleDataManager:GetInstance():GetRoleID(auiBroAndSis[i])
			if roleID > 0 then
				local name = RoleDataManager:GetInstance():GetRoleTitleAndName(roleID)
				choicelist[i+1] = {
					func = function()
						SendChangeSubRoleCMD(roleData.uiID, auiBroAndSis[i])
						AddLoadingDelayRemoveWindow('DialogChoiceUI', true)
					end,
					str = name
				}
			end
		end
	end

	DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_CUSTOM_CHOICE, false, roleData.uiID, des, choicelist)
end

function SelectUI:ShowLeaveTeamSelection(rolename)
	if not self.selectInfo then
		return
	end

	OpenWindowImmediately("DialogChoiceUI")
    local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
	if dialogChoiceUI then
		local choicelist = {}
		choicelist[2] = {
			func= function()
				ResetWaitDisplayMsgState()
				DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
				DisplayActionEnd()
			end, 
			str = "再想想"
		}
		choicelist[1] = {
			func = function()
				RoleDataManager:GetInstance():ClearInteractState()
				--AddLoadingDelayRemoveWindow('SelectUI')
				SendLeaveTeamCMD(self.selectInfo.roleID)
				AddLoadingDelayRemoveWindow('DialogChoiceUI', true)
			end,
			str = "告别"
		}
	
		local str = "选择告别，【".. rolename .."】将离开队伍（好感度不会变化），要告别吗？"
		DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_CUSTOM_CHOICE, false, self.selectInfo.roleID, str, choicelist)
    end
end

function SelectUI:ShowBabyLearnMasterSelection()
	if not self.selectInfo then
		return
	end

	OpenWindowImmediately("DialogChoiceUI")
    local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
	if dialogChoiceUI then
		local uiMainRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
		local uiRoleTypeIds = RoleDataManager:GetInstance():GetTeammatesRoleTypeID()
		local uiCanLearnTypeIDs = {}
		local kBabyInfo = RoleDataManager:GetInstance():GetBabyInfoByBabyRoleID(self.selectInfo.roleID)
		if not kBabyInfo then
			return
		end

		for n = 1, #uiRoleTypeIds do
			local typeData = TB_Role[uiRoleTypeIds[n]]
			if typeData and uiRoleTypeIds[n] ~= uiMainRoleTypeID and typeData.BabyTemplate ~= TBoolean.BOOL_YES then
				uiCanLearnTypeIDs[#uiCanLearnTypeIDs + 1] = uiRoleTypeIds[n]
			end
		end
		if #uiCanLearnTypeIDs == 0 then
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false, uiMainRoleTypeID, "我没有队友，无法给徒儿习武")
			return	
		end

		local choicelist = {}
		choicelist[1] = {
			func = function()
				self:Exit()
				DisplayActionEnd()					
			end, 
			str = "返回"
		}
		dialogChoiceUI:UpdateChoiceText(0, uiMainRoleTypeID, "徒儿想要习武，我该找谁给他传授武学呢？（随机学会队友所会武学中的其中一门，该方式无法学习到 <color=red>专属武学</color>）")

		for n = 1, #uiCanLearnTypeIDs do
			choicelist[n + 1] = {
				func = function()
					AddLoadingDelayRemoveWindow('SelectUI')
					SendBabyLearnCMD(self.selectInfo.roleID, uiCanLearnTypeIDs[n])
					AddLoadingDelayRemoveWindow('DialogChoiceUI', true)
				end,
				str = RoleDataManager:GetInstance():GetRoleTitleAndName(uiCanLearnTypeIDs[n], true, true)
			}
		end
		
		DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_CUSTOM_CHOICE, false, RoleDataManager:GetInstance():GetMainRoleID(), "徒儿想要习武，我该找谁给他传授武学呢？（随机学会队友所会武学中的其中一门，该方式无法学习到 <color=red>专属武学</color>）", choicelist)
    end
end

function SelectUI:ShowSubRoleSelection()
	if not self.selectInfo then
		return
	end

	OpenWindowImmediately("DialogChoiceUI")
    local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
	if dialogChoiceUI then
		local choicelist = {}
		choicelist[1] = {
			func = function()
				DisplayActionEnd()
			end, 
			str = "返回"
		}

		local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectInfo.roleID)
		local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()

		local des1 = "将" .. RoleDataManager:GetInstance():GetRoleTitleAndName(self.selectInfo.roleID) .. "当作我的替补"
		local des2 = "更换" .. RoleDataManager:GetInstance():GetRoleTitleAndName(self.selectInfo.roleID) .. "的替补"
		
		dialogChoiceUI:UpdateChoiceText(0, roleData.uiTypeID, "我是要做什么")

		choicelist[2] = {
			func = function()
				SendChangeSubRoleCMD(mainRoleID, roleData.uiTypeID)
				AddLoadingDelayRemoveWindow('DialogChoiceUI', true)
			end,
			str = des1
		}

		choicelist[3] = {
			func = function()
				self:ShowOtherSubRoleList(roleData)
				DisplayActionEnd()
			end,
			str = des2
		}

		DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_CUSTOM_CHOICE, false, self.selectInfo.roleID, "我是要做什么", choicelist)
    end
end

function SelectUI:ShowDuelSelection()
	if not self.selectInfo then
		return
	end
	OpenWindowImmediately("DialogChoiceUI")
    local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
	if dialogChoiceUI then
		local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectInfo.roleID)
    	dialogChoiceUI:UpdateChoiceText(180027, roleData.uiTypeID)
		dialogChoiceUI:AddChoice(180028, function()	
			AddLoadingDelayRemoveWindow('DialogChoiceUI')
			SendNPCInteractOperCMD(NPCIT_FIGHT, self.selectInfo.roleID)
		end)
		dialogChoiceUI:AddChoice(180029, function()	
			ResetWaitDisplayMsgState()
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
		end)
	end
	RemoveWindowImmediately('SelectUI')
end

function SelectUI:UpdateChoiceList(selectInfo)
	-- 先检查能不能显示交互界面, (队伍界面交互不用检查 @sxb)
	if not self:IsTeamInteract(selectInfo) then 
		if not RoleDataManager:GetInstance():CanRoleInteract(selectInfo) then 
			self:Exit()
			if selectInfo.mapID ~= 0 and selectInfo.mapID ~= nil then 
				RoleDataManager:GetInstance():TryInteract(selectInfo.roleID, selectInfo.mapID, selectInfo.mazeTypeID, selectInfo.mazeAreaIndex, selectInfo.mazeRow, selectInfo.mazeColumn, selectInfo.mazeCardBaseID, selectInfo.mazeCardID)
			end
			return
		end
	end
	self.choiceAnim={}
	self:ClearAllChoiceButton()
	self:UpdateShopChoice(selectInfo)
	self:UpdateTaskChoice(selectInfo)
	self:UpdateClanChoice(selectInfo.roleID, selectInfo.mapID)
	self:UpdateGovernmentChoice(selectInfo.roleID, selectInfo.mapID)
	self:UpdateCommonChoice(selectInfo)
	self:UpdateMazeChoice(selectInfo)
	self:UpdateActivityChoice(selectInfo.roleID, selectInfo.mapID)	
	self:UpdateClanBranchChoice(selectInfo)

	-- 增加一个离开
	self:AddSelection("离开", function() 
		self:Exit()
		self.choiceAnim=nil
	end)

	--队伍界面交互不播动画
	-- if self:IsTeamInteract(selectInfo) then return end
	
	-- if self.myTimer ~=nil then
	-- 	self:RemoveTimer(self.myTimer)
	-- 	self.myTimer = nil
	-- else	
	-- 	for key, obj in pairs(self.choiceAnim) do
	-- 		local canvasGroup=obj.gameObject:GetComponent("CanvasGroup")
	-- 		canvasGroup.alpha=0
	-- 		obj.transform:DOKill()
	-- 	end
	-- end
	-- self.myTimer=self:AddTimer(33,function()
	-- 	if IsWindowOpen("SelectUI") then
	-- 		local selectUI = GetUIWindow('SelectUI')
	-- 		if selectUI then 
	-- 			--一个一个Play滑入动画
	-- 			for key, obj in pairs(selectUI.choiceAnim) do
	-- 				local canvasGroup=obj.gameObject:GetComponent("CanvasGroup")
	-- 				local rect=obj.gameObject:GetComponent("RectTransform").anchoredPosition3D
	-- 				obj.gameObject:GetComponent("RectTransform").anchoredPosition=DRCSRef.Vec2(425,rect.y)	
									
	-- 				local twn1=obj.transform:DOLocalMoveX(rect.x+80,0.08):From():SetEase(DRCSRef.Ease.OutCubic):SetDelay((key-1)*0.05)
	-- 				local twn2=canvasGroup:DOFade(1,0.08):SetDelay((key-1)*0.05)
	-- 			end
	-- 			selectUI.choiceAnim={}
	-- 			selectUI.myTimer=nil
	-- 		end
	-- 	end
	-- end)
end
local invalidWindows = 
{
	"ObserveUI",
	"GiveGiftDialogUI",
	"SpecialRoleIntroduceUI",
	"ObsBabyUI",
	"NpcConsultUI",
	"GeneralRefreshBoxUI",
	"DialogRecordUI"
}
function SelectUI:OnPressESCKey()
	if IsAnyWindowOpen(invalidWindows) then return end
	self:Exit()
	self.choiceAnim=nil
end

function SelectUI:UpdateMazeChoice(selectInfo)
	if not MazeDataManager:GetInstance():IsInMaze() then 
		return
	end
	if self:IsTeamInteract(selectInfo) then 
		return
	end
	-- 迷宫中的角色需要增加绕道而行接口
	local goAwayChoiceText = GetLanguageByID(MAZE_GO_AWAY_CHOICE_LANG_ID) or ''
	self:AddSelection(goAwayChoiceText, function() 
		-- 等待下行时不允许点击
		if g_isWaitingDisplayMsg then 
			return
		end
		AddLoadingDelayRemoveWindow('SelectUI')
		SendClickMaze(CMAT_GOAWAY)
	end)
end
function SelectUI:UpdateActivityChoice(roleID,mapID)
	local akActiveTreasureExchange = ActivityHelper:GetInstance():GetActiveTreasureExchange()
	if akActiveTreasureExchange and akActiveTreasureExchange ~= {} then
		local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
		-- TODO:移表
		if roleTypeID == 1000214002 and  mapID ==  8 then 
			self:AddSelection("秘宝大会", function() 
				-- 等待下行时不允许点击
				if g_isWaitingDisplayMsg then 
					return
				end
				self:Exit()
				OpenWindowImmediately('TreasureExchangeUI')
			end)
		end
	end 
end

function SelectUI:IsTeamInteract(selectInfo)
	if selectInfo == nil then 
		return false
	end
	if (selectInfo.mazeTypeID == nil or selectInfo.mazeTypeID == 0) and (selectInfo.mapID == nil or selectInfo.mapID == 0) then 
		return true
	end
	return false
end

function SelectUI:UpdateCommonChoice(selectInfo)
	local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(selectInfo.roleID)
	local chatData = RoleDataManager:GetInstance():GetRoleChatDataByRoleId(roleTypeID)
	local StoryID = GetCurScriptID()
	local bShowSubRole = RoleDataHelper.CheckShowSubRole(roleTypeID)
	local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(self.selectInfo.roleID)
	local bBabyLearn = RoleDataManager:GetInstance():CheckBabyMaster(self.selectInfo.roleID)

	local masterChartID = RoleDataHelper.CheckMasterChat(roleTypeID, selectInfo.mapID, selectInfo.mazeTypeID, selectInfo.mazeAreaIndex) or 0
	local clanSelection = RoleDataHelper.CheckClanSelecttion(selectInfo.roleID)
	local breakLimitState = EvolutionDataManager:GetInstance():GetBreakLimitTaskFlag(self.selectInfo.roleID) or 0

	local isInTeam = RoleDataHelper.GetTeammatesByUID(self.selectInfo.roleID)
	if not self:IsCloseSwornAndMarry() and 
	 dispoValue == 99 and 
	 isInTeam and 
	 (not bShowSubRole or breakLimitState == 2) and
	 breakLimitState ~= 1 then
		local rolename = RoleDataManager:GetInstance():GetRoleTitleAndName(selectInfo.roleID)
		self:AddSelection("【" .. rolename .. "】好感突破", function()
			AddLoadingDelayRemoveWindow('SelectUI')
			SendBreakDispLimitCMD(selectInfo.roleID)
		end)
	end

	if bBabyLearn and isInTeam and RoleDataManager:GetInstance():Leaveable(selectInfo.roleID) then
		local rolename = RoleDataManager:GetInstance():GetRoleTitleAndName(selectInfo.roleID)
		self:AddSelection("【" .. rolename .. "】告别", function()
			RemoveWindowImmediately("SelectUI")
			self:ShowLeaveTeamSelection(rolename)
		end)
	end

	if masterChartID > 0 and selectInfo.clanBranchID == 0 then
		self:AddSelection("闲聊", function() 
			RemoveWindowImmediately("SelectUI")
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE, false, roleTypeID, masterChartID)
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
		end)
	end
	
	if not bBabyLearn and isInTeam and RoleDataManager:GetInstance():Leaveable(selectInfo.roleID) then
		local rolename = RoleDataManager:GetInstance():GetRoleTitleAndName(selectInfo.roleID)
		self:AddSelection("【" .. rolename .. "】告别", function()
			RemoveWindowImmediately("SelectUI")
			self:ShowLeaveTeamSelection(rolename)
		end)
	end

	if self.choiceTextMap['__count'] == 0 and selectInfo.clanBranchID == 0 then
		self:AddSelection("闲聊", function() 
			RemoveWindowImmediately("SelectUI")
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false, roleTypeID, "......")
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false, nil, "对方似乎并不想和你说话")
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
		end)
	end
end

function SelectUI:RefreshUI(selectInfo)
	self.selectInfo = selectInfo
	self:ClearAllChoiceButton()
	if selectInfo == nil then 
		self:Exit()
		return 
	end

	if self.selectInfo.roleID then
		-- 纠正RoleID
		self.selectInfo.roleID = RoleDataManager:GetInstance():CorrectRoleID(self.selectInfo.roleID)
	end
	
	self.isRefreshSetActive = true
	WindowsManager:GetInstance():HideOrWindow("SelectUI", false)
	self.isRefreshSetActive = false
	self:UpdateRoleData()
	if self.updateFlag ~= nil then
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_CHOICE)
	end
	self:UpdateRole(self.selectInfo.roleID)
end

function SelectUI:UpdateRoleData()
	if self.selectInfo.roleID then
		local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectInfo.roleID)
		if roleData == nil then 
			self:Exit()
			return
		end
		local instroleData = RoleDataManager:GetInstance():GetInstRoleByTypeID(roleData.uiTypeID)
		-- 优先使用instrole
		if instroleData then
			self.selectInfo.roleID = instroleData.uiID
		end
	end
end

function SelectUI:ClearAllChoiceButton()
	local childCount = self.selectionContent.transform.childCount
	for i = 1, childCount do 
		local objChild = self.selectionContent.transform:GetChild(i - 1)
		objChild.gameObject:SetActive(false)
		local comButton = objChild.gameObject:GetComponent(DRCSRef_Type.Button)
		if comButton then 
			self:RemoveButtonClickListener(comButton)
		end
	end
	self.choiceTextMap = {}
	self.choiceTextMap['__count'] = 0
end

function SelectUI:UpdateShopChoice(selectInfo)
	local mapID = selectInfo.mapID
	local roleID = selectInfo.roleID
	local shopID = RoleDataManager:GetInstance():GetShopID(roleID)
	if shopID ~= 0 then 
		self:AddSelection("商店", function()
			dprint("Click 商店!!!,id = " .. shopID)
			RemoveWindowImmediately("SelectUI")
			OpenWindowImmediately("StoreUI",shopID)
		end)
	else
		-- 动态商店
		-- 神秘商人

		if not mapID or mapID == 0 then
			return
		end

		local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
		local secretShopPosDatas = TableDataManager:GetInstance():GetTable("SecretShopPos")
		if not secretShopPosDatas then
			return
		end

		if roleTypeID == 1000114001 and mapID and mapID ~= 0 then
			local obj = self:AddSelection("神秘商店", function()
				dprint("打开动态商店")
				RemoveWindowImmediately("SelectUI")
				OpenWindowImmediately("StoreUI", 1)
			end)
			self:UpdateMark(obj, nil, nil, nil, InteractType.IT_SHOP)
		-- 神秘商人之女
		elseif roleTypeID == 1000114002 and mapID and mapID ~= 0 and GetCurScriptID() ~= 4 then
			local obj = self:AddSelection("神秘商店", function()
				dprint("打开动态商店")
				RemoveWindowImmediately("SelectUI")
				OpenWindowImmediately("StoreUI", 6)
			end)
			self:UpdateMark(obj, nil, nil, nil, InteractType.IT_SHOP)
		end
	end
end

function SelectUI:UpdateTaskChoice(selectInfo)
	local roleID = selectInfo.roleID
	local mapID = selectInfo.mapID
	local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
	local choiceInfoList = RoleDataManager:GetInstance():GetChoiceInfoList(selectInfo)

	choiceInfoList = self:RemoveRepeatChoice(choiceInfoList)
	table.sort(choiceInfoList,function(a,b)
		return a.langID < b.langID
	end)
	for _, choiceInfo in ipairs(choiceInfoList) do 
		local langID = choiceInfo.langID
		local isLock = choiceInfo.isLock
		local interactType = choiceInfo.interactType
		local taskID = choiceInfo.taskID
		local choiceContent = GetLanguageByID(langID, taskID)
		local obj = self:AddSelection(choiceContent, function()
			-- 等待下行时不允许点击
			if g_isWaitingDisplayMsg then 
				return
			end
			AddLoadingDelayRemoveWindow('SelectUI')
			SendClickNpcInteractCMD(langID, roleTypeID, choiceInfo.mapID, selectInfo.mazeTypeID, selectInfo.mazeAreaIndex, selectInfo.mazeCardBaseID, selectInfo.mazeRow, selectInfo.mazeColumn)
		end, isLock)
		if not isLock then
			self:UpdateMark(obj, roleID, mapID, langID, interactType)
		end
	end
	-- TODO: 更新闲聊按钮, 不走服务器, 直接读本地数据
end

function SelectUI:UpdateClanChoice(roleID, mapID)
	local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData() or {}
	local mainRoleClan = mainRoleData.uiClanID or 0
	local clanBaseID = 0
	local evo = RoleDataHelper.CheckDoorKeeper(roleID)
	if evo then
		clanBaseID = evo.iParam1
		local dbClanData = TB_Clan[evo.iParam1]
		local dbClanEliminate = TableDataManager:GetInstance():GetTableData("ClanEliminate",evo.iParam1)
        local clanName = "not find"  
		if dbClanData then
			clanName = GetLanguagePreset(dbClanData.NameID, tostring(dbClanData.NameID) )
		end

		if mapID == dbClanEliminate.ClanBuilding then
			self:AddSelection("进入" .. clanName, function() 
				AddLoadingDelayRemoveWindow('SelectUI')
				SendEnterClanCMD(evo.iParam1)
			end)
	
			if mainRoleClan ~= clanBaseID then
				self:AddSelection(clanName .. "介绍", function()
					RemoveWindowImmediately("SelectUI")
					local uiPoltID = ClanDataManager:GetInstance():GetIntroducePlotID(evo.iParam1)
					if uiPoltID then
						AnimationMgr:GetInstance():showBattlePlot(uiPoltID)
					end
					DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
				end)
			end
			-- 检查门派委托功能开启
			if ClanDataManager:GetInstance():CanAddDelegationTask(roleID) then 
				local clanName = ClanDataManager:GetInstance():GetClanNameByBaseID(clanBaseID)
				local obj = self:AddSelection("【" .. clanName .. "】委托任务", function()
					-- 等待下行时不允许点击
					if g_isWaitingDisplayMsg then 
						return
					end
					AddLoadingDelayRemoveWindow('SelectUI')
					SendClickAddClanDelegationTask(clanBaseID)
				end)
				self:UpdateMark(obj, nil, nil, nil, nil, 'regional_new')
			end
		end
	end

	-- 尝试添加学习武学选项
	self:AddLearnMartialChoice(roleID, mapID, mainRoleClan)

	-- 委托任务
	local evo_sub_master = RoleDataHelper.CheckSubMaster(roleID)
	if evo_sub_master then
		clanBaseID = evo_sub_master.iParam1
		local dbClanData = TB_Clan[evo_sub_master.iParam1]
		local dbClanEliminate = TableDataManager:GetInstance():GetTableData("ClanEliminate",evo_sub_master.iParam1)
		local clanName = "???"  
		if dbClanData then
			clanName = GetLanguagePreset(dbClanData.NameID, tostring(dbClanData.NameID) )
		end
		if dbClanEliminate and mapID == dbClanEliminate.SubMasterPosition then
			-- 检查门派委托功能开启
			if ClanDataManager:GetInstance():CanAddDelegationTask(roleID) then 
				local clanName = ClanDataManager:GetInstance():GetClanNameByBaseID(clanBaseID)
				local obj = self:AddSelection("【" .. clanName .. "】委托任务", function()
					-- 等待下行时不允许点击
					if g_isWaitingDisplayMsg then 
						return
					end
					AddLoadingDelayRemoveWindow('SelectUI')
					SendClickAddClanDelegationTask(clanBaseID)
				end)
				self:UpdateMark(obj, nil, nil, nil, nil, 'regional_new')
			end
		end
	end

	-- 尝试添加踢馆选项
	self:AddClanEliminateChoice(roleID, mapID, mainRoleClan)
end

function SelectUI:UpdateClanBranchChoice(selectInfo)
	local uiClanTypeID = selectInfo.clanBranchID
	local clanBaseData = TableDataManager:GetInstance():GetTableData("ClanBranch", uiClanTypeID)
	local info = ClanDataManager:GetInstance():GetClanBranchData(uiClanTypeID)
	if clanBaseData and info then
		--self:ClearAllChoiceButton()
		local cost = TableDataManager:GetInstance():GetTableData("ClanBranchConfig", 1).DonateMoneyNum
		local playerCoin = PlayerSetDataManager:GetInstance():GetPlayerCoin() or 0
		local mapID = MapDataManager:GetInstance():GetCurMapID()
		local trunkClanName = TableDataManager:GetInstance():GetTableData("Clan", clanBaseData.Trunk).ClanName
		local challengeFun = function()
			OpenWindowImmediately("DialogChoiceUI")
			local dialogChoiceSubUI = GetUIWindow('DialogChoiceUI')
			local winBlur = GetUIWindow("BlurBGUI")
			if winBlur then
				winBlur:ShowNormalMapBG(mapID)
			end
			local str2 = "要踢馆"..trunkClanName.."的分舵"..GetLanguageByID(info.uiClanNameID).."吗？".."踢馆分舵会导致<color=red>"..trunkClanName.."好感度降低，该门派队友降低好感度并在此次踢馆中无法上阵。踢馆分舵不会完成踢馆成就，也不会提升后续踢馆难度</color>。"
			dialogChoiceSubUI:UpdateChoiceText(nil, nil, str2)
			local challengeCallback = function()
				RemoveWindowImmediately("TileBigMap")
				ClanDataManager:GetInstance():SetTiGuanState(uiClanTypeID)
				OpenWindowImmediately("ClanBranchEliminateUI",{info,pos})
				RemoveWindowImmediately("DialogChoiceUI")
			end
			dialogChoiceSubUI:AddChoice(nil, challengeCallback,false,"踢馆",function()end,true)
			dialogChoiceSubUI:AddChoice(nil, function()	
				ResetWaitDisplayMsgState()
				DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
			end,nil,"算了")
		end
		
		local donateFun = function()
			ClanDataManager:GetInstance():SetClanBranchDonate(uiClanTypeID, 1)
			local str = string.format("多谢少侠！有了这些钱，这个月应该不会有人踢馆我们门派了！")
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_DIALOGUE_STR, false,clanBaseData.Master, str)
		end

		local donateStr = "捐钱"
		if info.iDonateNum > 0 then
			donateStr = donateStr.."(本月已捐献)"
		else
			donateStr = donateStr.."("..cost.."铜币)"
		end
		self:AddSelection("踢馆", challengeFun)
		self:AddSelection(donateStr, donateFun, (playerCoin<cost) or (info.iDonateNum > 0))			
	end
end

function SelectUI:AddLearnMartialChoice(roleID, mapID, mainRoleClan)
	-- 是否是 正掌门
	local isMainMaster = false
	local evoData = RoleDataHelper.CheckSubMaster(roleID)
	if evoData == nil and RoleDataHelper.CheckMainMaster(roleID) then 
		evoData = RoleDataHelper.CheckMainMaster(roleID)
		isMainMaster = true
	end
	if not evoData then 
		return
	end
	local clanBaseID = evoData.iParam1
	-- 本门学武做特殊处理
	if clanBaseID == mainRoleClan then 
		if ClanDataManager:GetInstance():CheckClanState(clanBaseID, CLAN_DRIVE_OUT) then 
			-- 驱逐掌门后, 挂在副掌门身上
			if isMainMaster then 
				return
			end
		else
			-- 驱逐掌门前, 挂在掌门身上
			-- 检查一下是不是代理掌门, 代理掌门享受掌门待遇
			if (not isMainMaster) and (not RoleDataHelper.CheckTempMainMaster(roleID)) then 
				return
			end
		end
	elseif clanBaseID ~= mainRoleClan and isMainMaster then 
		-- 非本门掌门不教武学
		return
	end
	-- 门派踢馆信息
	local clanEliminateBaseData = TableDataManager:GetInstance():GetTableData("ClanEliminate", clanBaseID)
	if not clanEliminateBaseData then 
		return
	end
	-- 检查位置是否符合显示条件
	local requireMapID = 0
	if isMainMaster then 
		requireMapID = clanEliminateBaseData.MainMasterPosition
	else
		requireMapID = clanEliminateBaseData.SubMasterPosition
	end
	if requireMapID ~= mapID then 
		return
	end

	local clanName = "???"  
	local clanBaseData = TB_Clan[clanBaseID]
	if clanBaseData then
		clanName = GetLanguagePreset(clanBaseData.NameID, tostring(clanBaseData.NameID) )
	end

	local uiLearnClan = clanEliminateBaseData.MartialClan or 0
	-- 本门使用对内武学
	if clanBaseID == mainRoleClan then 
		uiLearnClan = clanEliminateBaseData.InsideMartialClan or 0
	end
	if uiLearnClan ~= 0 then
		self:AddSelection("学习" .. clanName .. "武学", function() 
			--RemoveWindowImmediately("SelectUI")
			OpenWindowByQueue("ClanMartialUI", {true, uiLearnClan})
		end)
	end
end

function SelectUI:AddClanEliminateChoice(roleID, mapID, mainRoleClan)
	-- 是否是 正掌门
	local isMainMaster = false
	local evoData = RoleDataHelper.CheckSubMaster(roleID)
	if RoleDataHelper.CheckMainMaster(roleID) then 
		evoData = RoleDataHelper.CheckMainMaster(roleID)
		isMainMaster = true
	end
	if not evoData then 
		return
	end
	local clanBaseID = evoData.iParam1
	-- 先判断能否踢馆
	if not ClanDataManager:GetInstance():CanClanBeEliminated(clanBaseID, roleID) then 
		return
	end
	-- 查找门派踢馆信息
	local clanEliminateBaseData = TableDataManager:GetInstance():GetTableData("ClanEliminate", clanBaseID)
	if not clanEliminateBaseData then 
		return
	end
	if (not ClanDataManager:GetInstance():CheckClanState(clanBaseID, CLAN_DRIVE_OUT)) and (isMainMaster or RoleDataHelper.CheckTempMainMaster(roleID)) then 
		-- 驱逐之前, 正掌门具备踢馆功能
	elseif ClanDataManager:GetInstance():CheckClanState(clanBaseID, CLAN_DRIVE_OUT) and not isMainMaster then
		-- 驱逐之后, 功能移交副掌门
	else
		return
	end
	-- 检查位置是否符合显示条件
	local requireMapID = 0
	if isMainMaster then 
		requireMapID = clanEliminateBaseData.MainMasterPosition
	else
		requireMapID = clanEliminateBaseData.SubMasterPosition
	end
	if requireMapID ~= mapID then 
		return
	end

	local clanName = "???"  
	local clanBaseData = TB_Clan[clanBaseID]
	if clanBaseData then
		clanName = GetLanguagePreset(clanBaseData.NameID, tostring(clanBaseData.NameID) )
	end
	self:AddSelection("【踢馆" .. clanName .. "】", function() 
		-- 等待下行时不允许点击
		if g_isWaitingDisplayMsg then 
			return
		end
		self:Exit()
		SendClickAddClanEliminationTask(clanBaseID)
	end)
end

function SelectUI:UpdateGovernmentChoice(roleID, mapID)
	-- 检查城市委托功能开启
	local uiCityDelegationOpenTagID = TableDataManager:GetInstance():GetTableData("CommonConfig",1).CityDelegationOpenTag
	if not uiCityDelegationOpenTagID or not TaskTagManager:GetInstance():TagIsValue(uiCityDelegationOpenTagID, 1) then
		return false
	end

	local curCityID = CityDataManager:GetInstance():GetCurCityID()
	if CityDataManager:GetInstance():IsCityDelegationTaskStart(curCityID) then 
		return
	end
	if RoleDataManager:GetInstance():CanRolePublishGovernmentTask(roleID, mapID) then
		local obj = self:AddSelection("【六扇门】委托任务", function()
			-- 等待下行时不允许点击
			if g_isWaitingDisplayMsg then 
				return
			end
			AddLoadingDelayRemoveWindow('SelectUI')
			SendClickAddCityDelegationTask(curCityID)
		end)
		self:UpdateMark(obj, nil, nil, nil, nil, 'regional_new')
	end
end

function SelectUI:RemoveRepeatChoice(choiceInfoList)
	local choiceIDMap = {}
	for i = #choiceInfoList, 1, -1 do 
		local choiceID = choiceInfoList[i].langID
		if choiceIDMap[choiceID] then 
			table.remove(choiceInfoList, i)
		else
			choiceIDMap[choiceID] = true
		end
	end
	return choiceInfoList
end

function SelectUI:ProcessText(strText)
	if (not strText) or (strText == "") then
		return ""
	end

	if strText == "集字活动兑换" then
		local strActivityName = ResDropActivityDataManager:GetInstance():GetCurResDropCollectActivityName()
		if strActivityName and (strActivityName ~= "") then
			return strActivityName
		end
	end

	return strText
end
local regionalSize = {35,28}

function SelectUI:AddSelection(text, func, isLock)
	local objChoice = self:GetAvailableChoiceObj()
	if not self.choiceAnim then self.choiceAnim = {} end
	self.choiceAnim[#self.choiceAnim+1]=objChoice

	local comBack = objChoice:GetComponent(DRCSRef_Type.Image)
	local comText = self:FindChildComponent(objChoice,"dialogue/Text", DRCSRef_Type.Text)
	local objImage = self:FindChild(objChoice,"dialogue/Image")
	local comImage = objImage:GetComponent(DRCSRef_Type.Image)
	local objAnim = self:FindChild(objChoice, "anim")
	local comDtAnim = objAnim:GetComponent(DRCSRef_Type.DOTweenAnimation)
	local comLockImage = self:FindChildComponent(objChoice, "dialogue/lock", DRCSRef_Type.Image)
	local comNumText = self:FindChildComponent(objChoice,"Num/Text", DRCSRef_Type.Text)
	local comLuaAction = objChoice:GetComponent('LuaUIPointAction')
    if comLuaAction then 
        comLuaAction:SetPointerEnterAction(function()
            comBack.sprite = GetSprite("DialogueUI/bt_xuanxiangdi_ss")
        end)
        comLuaAction:SetPointerExitAction(function()
            comBack.sprite = GetSprite("DialogueUI/bt_xuanxiangdi")
        end)
    end
	comText.text = self:ProcessText(text)
	comNumText.text = getTableSize(self.choiceAnim)
	if isLock == true then 
		comText.color = UI_COLOR.red
		comBack.color = COLOR_VALUE[COLOR_ENUM.WhiteGray]
		objImage:SetActive(true)
		local lockSprite = comLockImage.sprite
		comImage.sprite = lockSprite
		SetUIAxis(objImage, lockSprite.rect.width, lockSprite.rect.height)
		objImage.transform.localScale = DRCSRef.Vec3(1, 1, 1)
	else
		comBack.color = COLOR_VALUE[COLOR_ENUM.White]
		comText.color = UI_COLOR.black
		objImage:SetActive(false)
		SetUIAxis(objImage, regionalSize[1], regionalSize[2])
	end
	local comButton = objChoice:GetComponent(DRCSRef_Type.Button)
	self:AddButtonClickListener(comButton, function()
		if isLock == true then 
			local lockTip = GetLanguageByID(LOCK_CHOICE_CLICK_TIP_LANGUAGE_ID)
			SystemUICall:GetInstance():Toast(lockTip)
			return
		end
		if g_hasInteract then 
			return
		end
		-- 1s 后才允许点击其他选项
		g_hasInteract = true
		globalTimer:AddTimer(1000, function()
			g_hasInteract = false
		end)
		objAnim:SetActive(true)
		RewindDoAnimation(objChoice)
		comDtAnim:DOPlayAllById("anim")
		comDtAnim.tween.onComplete = function()
			if type(func) == 'function' then 
				func()
			end
		end
		-- 选择记录
		if text ~= "离开" then
			DialogRecordDataManager:GetInstance():RecordDialog(string.format("你选择了\"%s\"", text))
		end
	end)

	self.choiceTextMap[text] = true
	self.choiceTextMap['__count'] = self.choiceTextMap['__count'] + 1
	return objChoice
end

function SelectUI:GetAvailableChoiceObj()
	local childCount = self.selectionContent.transform.childCount
	for i = 1, childCount do 
		local objChoice = self.selectionContent.transform:GetChild(i - 1).gameObject
		if not objChoice.activeSelf then 
			objChoice:SetActive(true)
			return objChoice
		end
	end
	local objChoice = LoadPrefabAndInit("Interactive/ChoiceButtonUI", self.selectionContent)
	if (objChoice ~= nil) then
		objChoice:SetActive(true)
	end

	
	return objChoice
end

function SelectUI:UpdateMark(obj, roleID, mapID, choiceID, eInteractType, markSpriteName)
	local objMark = self:FindChild(obj, 'Image')
	local comMark = objMark:GetComponent(DRCSRef_Type.Image)
	objMark:SetActive(false)
	local iScale = 0.5
	if markSpriteName == nil then 
		local max_weight_info = TaskDataManager:GetInstance():CheckRoleMark(roleID, mapID, nil, choiceID)
		if max_weight_info and max_weight_info.state then
			markSpriteName = max_weight_info.state
		else
			if eInteractType == InteractType.IT_SHOP then
				markSpriteName = "ShangDian"
				iScale = 0.85 
			elseif eInteractType == InteractType.IT_HeCheng then
				markSpriteName = "HeCheng"
				iScale = 0.85 
			elseif eInteractType == InteractType.IT_QiangHuaZhuangBei then
				markSpriteName = "DuanZao"
				iScale = 0.85 
			elseif eInteractType == InteractType.IT_XueXiWuXue then
				markSpriteName = "WuXue"
				iScale = 0.85 
			end
		end
	end
	
	if markSpriteName then
		local markSprite = GetAtlasSprite("CommonAtlas", markSpriteName)
		if (markSprite ~= nil) then
			objMark:SetActive(true)
			comMark.sprite = markSprite
			--SetUIAxis(objMark, markSprite.rect.width, markSprite.rect.height)
			objMark.transform.localScale = DRCSRef.Vec3(1, 1, 1)
		end
	end
end

function SelectUI:UpdateRole(roleID)
	-- 填写一下选项时的对话逻辑
	local dialogueInfo = {}

	-- 印象描述
	local ok, impressionDesc = xpcall(SelectUI.GetRoleImpressionDesc, showError, self, roleID)
	if ok and impressionDesc then
		dialogueInfo.dialogueStr = impressionDesc
	else
		dialogueInfo.dialogueID = 376 -- 显示省略号
	end

	dialogueInfo.roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
	dialogueInfo.recover = self.selectInfo.recover
	dialogueInfo.noTween = true
	self.DialogueUICom:RefreshUI(dialogueInfo, true)

	-- SelectUI 的 任务CG、名字 已经在 内嵌的 DialogueUI 中显示了，不需要更新
	-- self:UpdateRoleImg(roleID)
	-- self:UpdateRoleName(roleID)
	self:UpdateInteractUI()
end

function SelectUI:UpdateRoleImg(roleID)
	local artData = RoleDataManager:GetInstance():GetRoleArtDataByID(roleID)
    if artData == nil then 
        return
    end
	local roleCG = artData.Drawing 
	if roleCG then 
		self.comRoleCGImg.sprite = GetSprite(roleCG)
		self.comRoleCGImg.gameObject:SetActive(true)
	else
		self.comRoleCGImg.sprite = nil
		self.comRoleCGImg.gameObject:SetActive(false)
	end
end

function SelectUI:UpdateRoleName(roleTypeID)
	self.DialogueUICom:UpdateRoleName(roleTypeID)
end

function SelectUI:ShowRoleFavorUp(roleTypeID, iStart, iEnd)
	self.DialogueUICom:ShowRoleFavorUp(roleTypeID, iStart, iEnd)
end

function SelectUI:UpdateInteractUI()
	self.akInteractData = {}
	self.akInteractData[InterctGroupData.Introduce] = "简介"
	self.akInteractData[InterctGroupData.Show] = "简介"
	self.akInteractData[InterctGroupData.Observe] = "观察"
	self.akInteractData[InterctGroupData.GiveGift] = "送礼"
	self.akInteractData[InterctGroupData.Absorb] = "吸能"
	self.akInteractData[InterctGroupData.Fight] = "决斗"

	local isInTeam = RoleDataHelper.GetTeammatesByUID(self.selectInfo.roleID)

	-- 观察默认永远开启
	self.objObs:SetActive(true)
	-- 送礼默认永远开启
	self.objGiveGift:SetActive(true)

	-- 决斗
	if self:IsDuelUnlock() then
		self.objFight:SetActive(true)
		local enabele = self:IsCanDuel()
		self.comFightButton.interactable = enabele
		self.objFightShader:SetActive(not enabele)
		self.objFightBan:SetActive(not enabele)
	else
		self.objFight:SetActive(false)
	end

	-- 切磋
	local compareEnabele, des, needRefresh = self:IsCanCompare()
	self.objCompareButton.interactable = (needRefresh or compareEnabele)
	self.objCompareCompareShader:SetActive(not compareEnabele)
	self.objCompareRefresh:SetActive(needRefresh)
	if needRefresh then
		self.comCompareImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
		--self.comCompareText.text = ''
		local str = des ~= "" and "<color=red>("..des..")</color>" or ""
		self.akInteractData[InterctGroupData.Compare] = "切磋"..str
	else
		self.comCompareImg.color = DRCSRef.Color(1,1,1,1)
		--self.comCompareText.text = des
		local str = des ~= "" and "<color=red>("..des..")</color>" or ""
		self.akInteractData[InterctGroupData.Compare] = "切磋"..str
	end

	-- 吸能
	local bAbsrobUnlock = RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_Absorb)
	if bAbsrobUnlock then
		-- 吸能开启,图标直接替换
		if not self.compareSprite then
			self.compareSprite = self.comCompareImg.sprite
		end
		self.comCompareImg.sprite = self.comAbsorbImg.sprite
	else
		if self.compareSprite then
			self.comCompareImg.sprite = self.compareSprite
			self.compareSprite = nil
		end
	end

	-- 乞讨
	if (self:IsBegUnlock() == true) then
		self.objBeg:SetActive(true)
		local begEnabele, des, needRefresh= self:IsCanBeg()
		self.objBegRefresh:SetActive(needRefresh)
		self.comBegButton.interactable = begEnabele or needRefresh
		self.objBegShader:SetActive(not (begEnabele or needRefresh))
		if needRefresh then
			self.comBegImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
			--self.comBegText.text = ''
            local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Beg] = "乞讨"..str
		else
			self.comBegImg.color = DRCSRef.Color(1,1,1,1)
			--self.comBegText.text = des
			local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Beg] = "乞讨"..str
		end
	else
		self.objBeg:SetActive(false)
	end

	-- 盘查
	if (self:IsInquiryUnlock() == true) then
		self.objInquiry:SetActive(true)
		local begEnabele, des, needRefresh= self:IsCanInquiry()
		self.objInquiryRefresh:SetActive(needRefresh)
		self.objInquiryButton.interactable = begEnabele or needRefresh
		self.objInquiryShader:SetActive(not (begEnabele or needRefresh))
		if needRefresh then
			self.comInquiryImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
			--self.comInquiryText.text = ''
            local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Inquiry] = "盘查"..str
		else
			self.comInquiryImg.color = DRCSRef.Color(1,1,1,1)
			--self.comInquiryText.text = des
			local str = des ~= "" and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Inquiry] = "盘查"..str
		end
	else
		self.objInquiry:SetActive(false)
	end

	-- 请教
	--if (self:IsCanLearn() == true) then
	if isInTeam then
		local needRefresh = not RoleDataManager:GetInstance():InteractAvailable(self.selectInfo.roleID, NPCIT_STEAL_CONSULT)
		local resDayStr = EvolutionDataManager:GetInstance():GetRemainDay()
		local des = UIConstStr["SelectUI_Left"] .. resDayStr .. '天'

		if needRefresh then
			-- self.comLearnMartialImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
			--self.comLearnMartialText.text = des
			local str = des and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.LearnMartial] = "请教"..str
		else
			-- self.comLearnMartialImg.color = DRCSRef.Color(1,1,1,1)
			--self.comLearnMartialText.text = ""
			self.akInteractData[InterctGroupData.LearnMartial] = "请教"
		end

		self.objLearnMartialRefresh:SetActive(needRefresh)
		self.objLearnMartial:SetActive(true)
	else
		self.objLearnMartial:SetActive(false)
	end

	-- 邀请
	local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(self.selectInfo.roleID)

	local enabele, des = self:IsCanInvite()
	local bInviteable, condDes = RoleDataManager:GetInstance():GetInviteable(roleTypeID)
	local bBan = not bInviteable
	local str = bBan and "" or des
	str = str ~= "" and "<color=red>("..str..")</color>" or ""
	--self.comInviteText.text = str
	self.akInteractData[InterctGroupData.Invite] = "邀请"..str
	if bBan then 
		enabele = false 
		str = condDes or ""
		str = str ~= "" and "<color=red>("..str..")</color>" or ""
		--self.comInviteText.text = str
		self.akInteractData[InterctGroupData.Invite] = "邀请"..str
	end
	self.objInviteBan:SetActive(bBan)
	self.comInviteButton.interactable = enabele
	self.objInviteShader:SetActive(not enabele)
	self.objInvite:SetActive(not isInTeam)

	-- 结义 永久关闭
	--if (self:IsCanSworn() == true) then
	self.objSworn:SetActive(false)
	-- local enable, des = self:IsCanSworn()
	-- if isInTeam and not self:IsCloseSwornAndMarry() then
	-- 	local isSworned = RoleDataManager:GetInstance():IsSwornedWithMainRole(roleTypeID, true)
	-- 	local ismarryed = RoleDataManager:GetInstance():IsMarryWithMainRole(roleTypeID, true)
	-- 	if isSworned or ismarryed then
	-- 		self.objSworn:SetActive(false)
	-- 	else
	-- 		self.objSworn:SetActive(true)
	-- 	end
		
	-- 	self.objSwornButton.interactable = enable
	-- 	self.objSwornShader:SetActive(not enable)
	-- 	--self.comSwornText.text = des
	-- 	local str = des ~= "" and "<color=red>("..des..")</color>" or ""
	-- 	self.akInteractData[InterctGroupData.Sworn] = "结义"..str
	-- else
	-- 	self.objSworn:SetActive(false)
	-- end
	
	-- 结婚 永久关闭
	self.objMarry:SetActive(false)
	--if (self:IsCanMarry() == true) then
	-- local enable, des = self:IsCanMarry()
	-- if isInTeam and not self:IsCloseSwornAndMarry() then
	-- 	local isSworned = RoleDataManager:GetInstance():IsSwornedWithMainRole(roleTypeID, true)
	-- 	local ismarryed = RoleDataManager:GetInstance():IsMarryed(self.selectInfo.roleID)
	-- 	if ismarryed or isSworned then
	-- 		self.objMarry:SetActive(false)
	-- 	else
	-- 		self.objMarry:SetActive(true)
	-- 	end
		
	-- 	self.objMarryButton.interactable = enable
	-- 	self.objMarryShader:SetActive(not enable)
	-- 	--self.comMarryText.text = des
	-- 	local str = des ~= "" and "<color=red>("..des..")</color>" or ""
	-- 	self.akInteractData[InterctGroupData.Marry] = "誓约"..str
	-- else
	-- 	self.objMarry:SetActive(false)
	-- end

	-- 号召
	if not isInTeam and self:IsCallUpUnlock() then
		self.objCallUp:SetActive(true)
		local callUpEnabele, des, needRefresh= self:IsCanCallUp()
		local bInviteable, condDes = RoleDataManager:GetInstance():GetInviteable(roleTypeID)
		local bBan = not bInviteable
		--self.comCallUpText.text = ""
		self.akInteractData[InterctGroupData.CallUp] = '号召'
		if bBan then 
			local str =condDes or ""
			--self.comCallUpText.text = str
			str = str ~= "" and "<color=red>("..str..")</color>" or ""
			self.akInteractData[InterctGroupData.CallUp] = '号召'..str
		end
		self.objCallUpBan:SetActive(bBan)

		self.objCallUpButton.interactable = bBan or callUpEnabele or needRefresh
		self.objCallUpShader:SetActive(not (bBan or callUpEnabele or needRefresh))
		self.objCallUpRefresh:SetActive(needRefresh)
		if needRefresh then
			self.comCallUpImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
			--self.comCallUpText.text = ''
            local str = des and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.CallUp] = "号召"..str
		else
			self.comCallUpImg.color = DRCSRef.Color(1,1,1,1)
			--self.comCallUpText.text = des
			local str = des and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.CallUp] = "号召"..str
		end
	else
		self.objCallUp:SetActive(false)
	end

	-- 惩恶
	if self:IsPunishUnlock() then
		self.objPunish:SetActive(true)
		local punishEnabele, des, needRefresh= self:IsCanPunish()

		self.objPunishButton.interactable = punishEnabele or needRefresh
		self.objPunishShader:SetActive(not (punishEnabele or needRefresh))
		self.objPunishRefresh:SetActive(needRefresh)
		if needRefresh then
			self.comPunishImg.color = DRCSRef.Color(0.7,0.7,0.7,1)
			--self.comPunishText.text = ''
			self.akInteractData[InterctGroupData.Punish] = "惩恶"
		else
			self.comPunishImg.color = DRCSRef.Color(1,1,1,1)
			--self.comPunishText.text = des
			local str = des and "<color=red>("..des..")</color>" or ""
			self.akInteractData[InterctGroupData.Punish] = "惩恶"..str
		end
	else
		self.objPunish:SetActive(false)
	end

	-- 特别介绍
	self.objSpecialIntroduce:SetActive(self:IsSpecialIntroduceUnlock())

	if self.uiInteractType ~= nil then
		local pbtType = self.uiInteractType
		if pbtType == PlayerBehaviorType.PBT_QingJiao or 
		pbtType == PlayerBehaviorType.PBT_TouXue then
			local npcConsultUI =  GetUIWindow("NpcConsultUI") 
			if npcConsultUI ~= nil then
				local bSkip = npcConsultUI:QuickSkip()
				if not bSkip then
					self:LearnMartial()
				end
			else
				self:LearnMartial()
			end
		elseif pbtType == PlayerBehaviorType.PBT_QiTao then
			self:BegInteractRole()
		elseif pbtType == PlayerBehaviorType.PBT_QieCuo then
			self:CompareWithInteractRole()
		elseif pbtType == PlayerBehaviorType.PBT_INQUIRY then
			self:InquiryInteractRole()
		elseif pbtType == PlayerBehaviorType.PBT_Punish then
			self:ClickPunish()
		elseif pbtType == PlayerBehaviorType.PBT_CallUp then
			self:ClickCallUp()
		end

		self.uiInteractType = nil
	end
	self:SetButtonHightState()
end

function SelectUI:IsDuelUnlock()
	return RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_JueDou)
end

-- 是否允许决斗
function SelectUI:IsCanDuel()
	local dbData = RoleDataManager:GetInstance():GetRoleTypeDataByID(self.selectInfo.roleID)
	-- EvoKill = false 表示可以决斗 名字跟含义有出入 有点迷惑
	if dbData then
		if dbData.KillCond > 0 then
			do return false end

			local bCond = TeamCondition:GetInstance():CheckTeamCondition(dbData.KillCond, true)
			if not bCond then
				return false
			end	
		end
	end

	if MapDataManager:GetInstance():GetCurMapID() == PRISON_MAP_ID then
		return false
	end

	return true
end

-- 是否允许乞讨
function SelectUI:IsCanBeg()
	local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(self.selectInfo.roleID)
	if not dispoValue or dispoValue < 0 then
		return false, UIConstStr["SelectUI_Favor0"],false
	end

	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectInfo.roleID, NPCIT_BEG)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr 
		return false, des, true
	end

	return true, ""
end

-- 是否乞讨功能解锁
function SelectUI:IsBegUnlock()
	return RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_QiTao)
end

-- 是否允许盘查
function SelectUI:IsCanInquiry()
	-- 检查盘查是否开启
	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectInfo.roleID, NPCIT_INQUIRY)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr 
		return false, des, true
	end
	
	return true, ""
end

-- 盘查功能是否解锁
function SelectUI:IsInquiryUnlock()
	-- 监牢不允许盘查
	if MapDataManager:GetInstance():GetCurMapID() == 661 then
		return false
	end
	return RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_INQUIRY)
end

-- 是否允许请教
function SelectUI:IsCanLearn()
	-- TODO: 目前都返回true,后面需要取特定的tag值\
	local uiTaskTagTypeid = 0
	TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiTaskTagTypeid)
	return true
end

-- 是否允许邀请
function SelectUI:IsCanInvite()
	-- if not self.selectInfo then
	-- 	return flase, "error"
	-- end

	-- local roleID = self.selectInfo.roleID
	-- local mapID = self.selectInfo.mapID
	-- local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
	-- local interactEdgeList = TaskDataManager:GetInstance():GetTaskEdgeListByEvent(Event.Event_InviteRole, nil, roleTypeID)
	-- for _, edge in ipairs(interactEdgeList) do 
	-- 	local taskEventId = edge.TaskEventID
	-- 	if (taskEventId) then
	-- 		return false, UIConstStr['SelectUI_NoInvite']-- 有任务在监听,则走任务的流程
	-- 	end
	-- end
	local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(self.selectInfo.roleID)
	if (dispoValue and dispoValue >= 60) then
		return true, ""
	end

	return false, UIConstStr["SelectUI_Favor60"]
end

-- 是否允许结义
function SelectUI:IsCanSworn()
	local uiTaskTagTypeid = 0
	TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiTaskTagTypeid)
	--return false
	if self:GetIfChild(self.selectInfo.roleID) then
		return true, "不可结义"
	end
	local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(self.selectInfo.roleID)
	if (dispoValue and dispoValue >= 100) then
		return true, ""
	end

	return false, UIConstStr["SelectUI_Favor100"]
end

-- 是否允许结婚
function SelectUI:IsCanMarry()
	local uiTaskTagTypeid = 0
	TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiTaskTagTypeid)
	if RoleDataManager:GetInstance():IsMarryed(self.selectInfo.roleID) then
		return false, "已誓约"
	end
	if self:GetIfChild(self.selectInfo.roleID) then
		return true, "不可誓约"
	end
	--return false
	local dispoValue = RoleDataManager:GetInstance():GetDispotionValueToMainRole(self.selectInfo.roleID)
	if (dispoValue and dispoValue >= 100) then
		return true, ""
	end

	return false, UIConstStr["SelectUI_Favor100"]
end

function SelectUI:GetRemainDay()
	local resDayStr = EvolutionDataManager:GetInstance():GetRemainDay()
	return (resDayStr or 0) .. UIConstStr["NpcConsultUI_Day"] 
end
function SelectUI:GetIfChild(iRoleID)
	-- 判断是否孩童，不单判断主角的徒弟
	if RoleDataManager:GetInstance():IsBabyRoleType(iRoleID) then
		return true
	end
    local status = RoleDataManager:GetInstance():GetRoleStatus(iRoleID, false)
    if status == StatusType.STT_Haitong then 
        return true 
	end
	return false 
end 
-- 是否允许切磋
function SelectUI:IsCanCompare()
	local uiTaskTagTypeid = 0
	TaskTagManager:GetInstance():GetTaskTagValueByTypeID(uiTaskTagTypeid)
	local favorData = RoleDataManager:GetInstance():GetDispotionDataToMainRole(self.selectInfo.roleID)
	if favorData and favorData.iValue and favorData.iValue < 20 then
		return false, UIConstStr["SelectUI_Favor"],false
	end

	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectInfo.roleID, NPCIT_COMPARE)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr 
		return false, des, true
	end

	return true, ""
end

-- 是否号召功能解锁
function SelectUI:IsCallUpUnlock()
	return RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_CallUp)
end

-- 是否允许号召
function SelectUI:IsCanCallUp()
	if not (self.selectInfo and self.selectInfo.roleID and (self.selectInfo.roleID > 0)) then
		return false, "没有选择角色", false
	end
	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectInfo.roleID, NPCIT_CALLUP)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr
		return false, des, true
	end
	if MapDataManager:GetInstance():GetCurMapID() == PRISON_MAP_ID then
		return false
	end
	return true
end

-- 是否惩恶功能解锁
function SelectUI:IsPunishUnlock()
	return RoleDataManager:GetInstance():IsInteractUnlock(PlayerBehaviorType.PBT_Punish)
end

-- 是否允许惩恶
function SelectUI:IsCanPunish()
	local bAvailable = RoleDataManager:GetInstance():InteractAvailable(self.selectInfo.roleID, NPCIT_PUNISH)
	local resDayStr = self:GetRemainDay()
	if not bAvailable then
		local des = UIConstStr["SelectUI_Left"] .. resDayStr
		return false, des, true
	end
	if MapDataManager:GetInstance():GetCurMapID() == PRISON_MAP_ID then
		return false
	end
	return true
end

-- 是否有特别介绍
function SelectUI:IsSpecialIntroduceUnlock()
	if not (self.selectInfo and self.selectInfo.roleID and (self.selectInfo.roleID > 0)) then
		return false
	end
	local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByID(self.selectInfo.roleID)

	if roleTypeData and roleTypeData.SpecialIntroduce and roleTypeData.SpecialIntroduce ~= 0 then
		return true
	end

	return false
end

-- 判断结婚结义是否被关闭
function SelectUI:IsCloseSwornAndMarry()
	local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)

	if not commonConfig then
		return false
	end

	local tagID = commonConfig.CloseSwornAndMarryTag
	if TaskTagManager:GetInstance():TagIsValue(tagID, 1) then
		return true
	end

	return false
end

function SelectUI:OnDestroy()
	self.DialogueUICom:Close()
end

--打开的时候会调用
function SelectUI:OnEnable()
	if self.selectInfo ~= nil and not self.isRefreshSetActive then 
		-- FIXME：服务器那边调用次数太多了，做了重复处理，但是又得至少刷新一次
		self.DialogueUICom:ClearDialog()
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_ROLE_DATA)
		self.updateFlag = SetFlag(self.updateFlag, UPDATE_TYPE.UPDATE_CHOICE)
	end
	
	if WindowsManager:GetInstance():IsWindowOpen("GiveGiftDialogUI") then
		WindowsManager:GetInstance():SetTop("GiveGiftDialogUI")
	end

	if WindowsManager:GetInstance():IsWindowOpen("RandomRollUI") then
		WindowsManager:GetInstance():SetTop("RandomRollUI")
	end 

	BlurBackgroundManager:GetInstance():ShowBlurBG()
	--首次打开对话开启模糊背景动画
	if self.choiceAnim==nil then
		if IsWindowOpen("BlurBGUI") then
			local blurBGUI=GetUIWindow("BlurBGUI")
			blurBGUI:ScaleAndBlurAnim()
		end
	end
	-- 打开对话控制界面
	if not IsWindowOpen("DialogControlUI") then
		OpenWindowImmediately("DialogControlUI")
	end
	HideAllHUD()
end

function SelectUI:ClickCallUp(roleID)
	

	local begEnabele, des, needRefresh = self:IsCanCallUp()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_CALLUP , uiRoleID = self.selectInfo.roleID}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
		local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectInfo.roleID)
		if not mainRoleData or not mainRoleData.GetGoodEvil then
			return
		end
		if not roleData or not roleData.GetGoodEvil then
			return
		end

		local iMainRoleGoodEvil = mainRoleData:GetGoodEvil()
		local iRoleGoodEvil = roleData:GetGoodEvil()
		local roleName = RoleDataHelper.GetNameByID(self.selectInfo.roleID)

		local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(self.selectInfo.roleID)
		local bInviteable, condDes = RoleDataManager:GetInstance():GetInviteable(roleTypeID)
		if iMainRoleGoodEvil < 0 then
			local text = "主角仁义值过低"
			SystemUICall:GetInstance():Toast(text)
		elseif bInviteable == false then
			local text = "此角色无法入队"
			SystemUICall:GetInstance():Toast(text)				
		else
			if iRoleGoodEvil < 0 and roleTypeID ~= 1000001127 then	-- 不为教学角色
				local tipStr = string.format("你与%s善恶不两立，号召他不仅不会成功，还会与你展开决斗，是否继续？", roleName or "")
				OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, tipStr, function()
					SendNPCInteractOperCMD(NPCIT_CALLUP, self.selectInfo.roleID,0)
					AddLoadingDelayRemoveWindow('SelectUI')
				end})
			else
				SendNPCInteractOperCMD(NPCIT_CALLUP, self.selectInfo.roleID,0)
				AddLoadingDelayRemoveWindow('SelectUI')
			end
		end
	end
end

function SelectUI:ClickPunish(roleID)
	local punishEnabele, des, needRefresh = self:IsCanPunish()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_PUNISH , uiRoleID = self.selectInfo.roleID}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		SendNPCInteractOperCMD(NPCIT_PUNISH, self.selectInfo.roleID)
		AddLoadingDelayRemoveWindow('SelectUI')
	end
end

function SelectUI:ClickSpecialIntroduce()
	if not self.selectInfo then
		return
	end

	OpenWindowImmediately("SpecialRoleIntroduceUI", self.selectInfo.roleID)
end

-- 获取角色擅长武学
function SelectUI:GetRoleBestMartialDepart(roleID, limit)
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
	if not roleData then
		return DepartEnumType.DET_DepartEnumTypeNull
	end
	limit = limit or 2

	local bestDepart = DepartEnumType.DET_DepartEnumTypeNull
	local martials = roleData:GetMartials() or {}
	local bestDepartNum = 0
	local departNum = {}

	for index = 0, #martials do
		typeID = martials[index]
		if typeID then
			local data = GetTableData("Martial",typeID) 
			if data then
				departNum[data.DepartEnum] = departNum[data.DepartEnum] or 0
				departNum[data.DepartEnum] = departNum[data.DepartEnum] + 1
				if departNum[data.DepartEnum] > bestDepartNum then
					bestDepart = data.DepartEnum
					bestDepartNum = departNum[data.DepartEnum]
				end
			end
		end
	end

	if bestDepartNum >= limit then
		return bestDepart
	else
		return nil
	end
end

-- 获取角色当前传家宝
function SelectUI:GetRoleCurTreasure(roleID)
	if not roleID or roleID == 0 then
		return nil
	end

	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
	local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)

	if not roleData or not roleTypeID then
		return nil
	end

	local itemTypeIDs = {}
	local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE

	local auiRoleItems = roleData:GetBagItems()
	if auiRoleItems then
		for index, itemID in pairs(auiRoleItems) do
			local itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)

			if itemTypeID and itemTypeID ~= 0 then
				table.insert(itemTypeIDs, itemTypeID)
			end
		end
	end

	if isNPC and roleData.GetBagStaticItems then
		local auiRoleStaticItems = roleData:GetBagStaticItems()
		if auiRoleStaticItems then
			for itemTypeID, num in pairs(auiRoleStaticItems) do
				if itemTypeID and itemTypeID ~= 0 then
					table.insert(itemTypeIDs, itemTypeID)
				end
			end
		end
	end

	local auiEquipItemInfos = roleData:GetEquipItemInfos()
	if auiEquipItemInfos then
		for pos, itemInfo in pairs(auiEquipItemInfos) do
			if itemInfo then
				local itemID = itemInfo.iInstID or 0
				local typeID = itemInfo.iTypeID or 0

				if itemID > 0 then
					typeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
				end

				if typeID and typeID > 0 then
					table.insert(itemTypeIDs, typeID)
				end
			end
		end
	end

	for index, itemTypeID in ipairs(itemTypeIDs) do
		local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
		if itemTypeData then
			if itemTypeData.PersonalTreasure == roleTypeID then
				return itemTypeID
			end
		end
	end

	return nil
end

-- 特殊的人物门派名称显示
local specialRoleClanText = {
	[1210314003] = "五岳御剑宗",
	[1210314002] = "五岳混元宗",
}

-- 获取角色印象描述
function SelectUI:GetRoleImpressionDesc(roleID)
	if not roleID or roleID == 0 then
		return nil
	end
	local config = TableDataManager:GetInstance():GetTableData("RoleImpressionConfig", 1)
	if not config then
		return
	end

	local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
	local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByID(roleID)

	if not roleData or not roleTypeData then
		return nil
	end

	if roleTypeData.Impression and roleTypeData.Impression > 0 then
		return GetLanguageByID(roleTypeData.Impression)
	end

	local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
	local isFemale = (roleTypeData.Sex == SexType.ST_Female)
	local rank = roleTypeData.Rank
	local status = RoleDataManager:GetInstance():GetRoleStatus(roleID, false)
	local martials = {}
	local bestDepart = self:GetRoleBestMartialDepart(roleID)
	local items = {}
	local treasureTypeID = self:GetRoleCurTreasure(roleID)
	local level = 0
	local mainRoleRank = 0
	local mainRoleLevel = 0
	local clanText = RoleDataHelper.GetAttr(roleData, roleTypeData, "Clan")

	if roleData.GetLevel then
		level = roleData:GetLevel()
	end
	if mainRoleData and mainRoleData.uiRank and mainRoleData.uiLevel then
		mainRoleRank = mainRoleData.uiRank
		mainRoleLevel = mainRoleData.uiLevel
	end
	
	if not rank or rank == RankType.RT_RankTypeNull then
		rank = RankType.White
	end
	if status == StatusType.STT_StatusTypeNull then
		status = nil
	end

	local finalDesc = ""
	-- 性别描述
	local sexDescIndex = math.floor(#config.SexDesc / 2)
	if sexDescIndex < 1 then
		return
	end
	sexDescIndex = math.random(sexDescIndex)
	if isFemale then
		sexDescIndex = sexDescIndex * 2
	else
		sexDescIndex = sexDescIndex * 2 - 1
	end
	finalDesc = finalDesc..GetLanguageByID(config.SexDesc[sexDescIndex])

	-- 身份和门派描述
	if specialRoleClanText[roleTypeID] then
		clanText = specialRoleClanText[roleTypeID]
	end

	if not clanText or clanText == "" or clanText == "无" then
		finalDesc = finalDesc.."师出无门。"
	else
		local statusFlag = false

		if status then
			local statusText = nil
			for index, statusItem in ipairs(config.StatusList) do
				if statusItem == status then
					if config.StatusDescList[index] then
						statusText = GetLanguageByID(config.StatusDescList[index])
					end
					break
				end
			end

			if statusText then
				local subDesc = config.ClanDescHasStatusDesc[math.random(#config.ClanDescHasStatusDesc)]
				subDesc = GetLanguageByID(subDesc)
				clanText = string.format("<color=red>%s</color>", clanText)
				finalDesc = finalDesc..string.format(subDesc, clanText)
				finalDesc = finalDesc..statusText.."。"
				statusFlag = true
			end
		end

		if not statusFlag then
			local subDesc = config.ClanDescNoStatusDesc[math.random(#config.ClanDescNoStatusDesc)]
			subDesc = GetLanguageByID(subDesc)
			clanText = string.format("<color=red>%s</color>", clanText)
			finalDesc = finalDesc..string.format(subDesc.."。", clanText)
		end
	end

	-- 品质描述
	-- local rankText = nil
	-- for index, rankItem in ipairs(config.RankList) do
	-- 	if rankItem == rank then
	-- 		if config.RankDescList[index] then
	-- 			rankText = GetLanguageByID(config.RankDescList[index])
	-- 			rankText = string.format("<color=red>%s</color>", rankText)
	-- 		end
	-- 		break
	-- 	end
	-- end
	-- if rankText then
	-- 	finalDesc = finalDesc..string.format("此人%s，", rankText)
	-- end

	-- 战斗力描述
	local showPowerIndex = nil
	local function GetRolePower(roleRank, roleLevel)
		return config.LevelToPower * roleLevel + config.RankToPower * roleRank
	end
	local rolePower = GetRolePower(rank, level)
	local mainRolePower = GetRolePower(mainRoleRank, mainRoleLevel)
	for index, power in ipairs(config.PowerList) do
		if rolePower - mainRolePower <= power then
			showPowerIndex = index
			break
		end
	end
	if showPowerIndex then
		local powerText = GetLanguageByID(config.PowerDescList[showPowerIndex])
		finalDesc = finalDesc..powerText.."。"
	end

	-- 擅长武学类型
	local departText = nil
	if bestDepart then
		for text, depart in pairs(DepartEnumType_Revert) do
			if depart == bestDepart then
				departText = text
				break
			end
		end
	end
	if departText then
		local subDesc = config.HasGoodMartialDesc[math.random(#config.HasGoodMartialDesc)]
		subDesc = GetLanguageByID(subDesc)
		departText = string.format("<color=red>%s</color>", departText)
		finalDesc = finalDesc..string.format(subDesc.."。", departText)
	end
	-- else
	-- 	local subDesc = config.NoGoodMartialDesc[math.random(#config.NoGoodMartialDesc)]
	-- 	subDesc = GetLanguageByID(subDesc)
	-- 	finalDesc = finalDesc..string.format("%s。", subDesc)
	-- end

	-- 传家宝描述
	if treasureTypeID then
		local itemTypeData = TableDataManager:GetInstance():GetTableData("Item", treasureTypeID)
		if itemTypeData then
			local itemText = itemTypeData.ItemName or ''
			local subDesc = config.HasTreasureDesc[math.random(#config.HasTreasureDesc)]
			subDesc = GetLanguageByID(subDesc)
			itemText = string.format("<color=red>%s</color>", itemText)
			finalDesc = finalDesc..string.format(subDesc.."。", itemText)
		end

	-- 喜好描述
	else
		local favorText = RoleDataHelper.GetAttr(roleData, roleTypeData, "Favor")
		if favorText ~= "" then
			local subDesc = config.NoTreasureDesc[math.random(#config.NoTreasureDesc)]
			subDesc = GetLanguageByID(subDesc)
			favorText = string.format("<color=red> %s</color>", favorText)
			finalDesc = finalDesc..string.format(subDesc.."。", favorText)
		end
	end

	return finalDesc
end

function SelectUI:OnlyShowRole(flag)
	local hideObjList = {
		self.objSelctionView,
		self.objInteractGroup,
		self.objInteractGroup2,
	}

	for index, obj in ipairs(hideObjList) do
		if obj then
			obj:SetActive(not flag)
		end
	end
end

--界面隐藏的时候 会调用
function SelectUI:OnDisable()
	BlurBackgroundManager:GetInstance():HideBlurBG()
	-- 关闭对话控制界面
	if IsWindowOpen("DialogControlUI") then
		RemoveWindowImmediately("DialogControlUI")
	end
	ShowAllHUD()
end

function SelectUI:HasOtherUIWindow()
	if IsWindowOpen('StoreUI') or IsWindowOpen('RandomRollUI') or IsWindowOpen('DialogChoiceUI') then
        return true
	end
	return false
end

function SelectUI:InviteInteractRole()
	if self.selectInfo == nil then 
		return
	end
	-- 如果队友已满, 提示先踢几个队友
	if RoleDataManager:GetInstance():IfTeammateNumFull() == true then
		SystemUICall:GetInstance():Toast("队友数量已达上限，可与队友对话，告别队友留出位置")
		return
	end
	AddLoadingDelayRemoveWindow('SelectUI')
	SendNPCInteractOperCMD(NPCIT_INVITE, self.selectInfo.roleID, self.selectInfo.mapID)
end

function SelectUI:CompareWithInteractRole()
	local compareEnabele, des, needRefresh = self:IsCanCompare()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_COMPARE , uiRoleID = self.selectInfo.roleID}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		AddLoadingDelayRemoveWindow('SelectUI')
		SendNPCInteractOperCMD(NPCIT_COMPARE, self.selectInfo.roleID)
	end
end

function SelectUI:BegInteractRole()
	local begEnabele, des, needRefresh = self:IsCanBeg()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_BEG , uiRoleID = self.selectInfo.roleID}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		AddLoadingDelayRemoveWindow('SelectUI')
		SendNPCInteractOperCMD(NPCIT_BEG, self.selectInfo.roleID, self.selectInfo.mapID)
	end
end

function SelectUI:InquiryInteractRole()
	local InquiryEnabele, des, needRefresh = self:IsCanInquiry()
	if needRefresh then
		local info = {type = NPCIT_REFRESH_INQUIRY , uiRoleID = self.selectInfo.roleID}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		AddLoadingDelayRemoveWindow('SelectUI')
		SendNPCInteractOperCMD(NPCIT_INQUIRY, self.selectInfo.roleID, self.selectInfo.mapID)
	end
end

function SelectUI:LearnMartial()
	local needRefresh = not RoleDataManager:GetInstance():InteractAvailable(self.selectInfo.roleID, NPCIT_STEAL_CONSULT)
	if needRefresh then
		local info = {type = NPCIT_REFRESH_CONSULT , uiRoleID = self.selectInfo.roleID}
		OpenWindowByQueue("GeneralRefreshBoxUI", info)
	else
		OpenWindowByQueue("NpcConsultUI", {self.selectInfo.roleID})
	end
end

function SelectUI:SetButtonHightState()
	local iNum = self.objInteractGroup2.transform.childCount
	for i = 0, iNum -1  do
		local str = self.akInteractData[i + 1] 
		local kChild = self.objInteractGroup2.transform:GetChild(i)
		local comLuaAction = kChild:GetComponent('LuaUIPointAction')
        if comLuaAction then 
            comLuaAction:SetPointerEnterAction(function()
				local objShader = self:FindChild(comLuaAction.gameObject, "Shader")
				if not objShader then
					self:SetButtonHight(kChild, true, str)
				else
					if not objShader.activeSelf then
						self:SetButtonHight(kChild, true, str)
					else
						self:SetTitleShow(kChild, true, str)
					end
				end
                
            end)
            comLuaAction:SetPointerExitAction(function()
                self:SetButtonHight(kChild, false, str)
            end)
			comLuaAction:SetPointerUpAction(function()
                self:SetButtonHight(kChild, false, str)
            end)
        end
	end
end

local sUsuallyIconPath = "DialogueUI/bt_tongyongyuandi"
local sHightIconPath = "DialogueUI/bt_tongyongyuandi_ss"

function SelectUI:SetButtonHight(kObject, bHight, str)
	local comImage = kObject:GetComponent("Image")
	if bHight then
		self.objShowImageText.text = str
		self.comBGRectTransform = self.objShowImage:GetComponent("RectTransform")
		self.iBGWidth = self.comBGRectTransform.rect.width
		self.objShowImage:SetActive(true)
		local pos = DRCSRef.Camera.main:WorldToScreenPoint(kObject.transform.position + DRCSRef.Vec3(0,2.5,0))
		local scWidth = CS.UnityEngine.Screen.width
		local iScale = scWidth / design_ui_w
		if pos.x + self.iBGWidth * iScale > scWidth then
			pos.x = pos.x - (self.iBGWidth - 285) * iScale
		end
		local newPos = DRCSRef.Camera.main:ScreenToWorldPoint(pos)
		self.objShowImage.transform.position = newPos
		comImage.sprite = GetSprite(sHightIconPath)
	else
		self.objShowImage:SetActive(false)
		comImage.sprite = GetSprite(sUsuallyIconPath)
	end
end

-- just show the little title
function SelectUI:SetTitleShow(kObject, bHight, str)
	--local comImage = kObject:GetComponent("Image")
	if bHight then
		self.objShowImageText.text = str
		self.comBGRectTransform = self.objShowImage:GetComponent("RectTransform")
		self.iBGWidth = self.comBGRectTransform.rect.width
		self.objShowImage:SetActive(true)
		local pos = DRCSRef.Camera.main:WorldToScreenPoint(kObject.transform.position + DRCSRef.Vec3(0,2.5,0))
		local scWidth = CS.UnityEngine.Screen.width
		local iScale = scWidth / design_ui_w
		if pos.x + self.iBGWidth * iScale > scWidth then
			pos.x = pos.x - (self.iBGWidth - 285) * iScale
		end
		local newPos = DRCSRef.Camera.main:ScreenToWorldPoint(pos)
		self.objShowImage.transform.position = newPos
		--comImage.sprite = GetSprite(sHightIconPath)
	else
		self.objShowImage:SetActive(false)
		--comImage.sprite = GetSprite(sUsuallyIconPath)
	end
end

function SelectUI:GetDialogChoiceUI()
	return self.DialogueUICom
end

return SelectUI 
