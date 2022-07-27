BattleAIUI = class("BattleAIUI",BaseWindow)
local TeamListUICom = require 'UI/Role/TeamListUI'
local MAX_COMBO_SIZE = 7
local l_DRCSRef_Type = DRCSRef_Type
local errCol = DRCSRef.Color(0x91/255, 0x3e/255, 0x2b/255, 1)
local errColHover = DRCSRef.Color(0xe4/255, 0x62/255, 0x44/255, 1)
local AI_ID_OFFSET = 1000
local COMBO_UNLOCK_LV = 3
function BattleAIUI:ctor(obj)
	self:SetGameObject(obj)
	self.iUpdateFlag = 0
	self.toggleAI = {}
	self.toggleAction = {}
	self.toggleActGroup = {}
	self.targetFold = {}
	self.actionFold = {}
end

function BattleAIUI:setDropValue(v)
	if self.mode == 'action' then
		self.fromProgram = true
		self.comDropDown.value = v
		self.fromProgram = nil
	end
end

function BattleAIUI:InitDropDown()
	self.comDropDown = self.bbox:FindChildComponent('Dropdown','Dropdown')
	self.comDropDown:ClearOptions()
	local BM = BattleAIDataManager:GetInstance()
	local options,data = BM:GetOptions()
	self.comDropDown:AddOptions(options)
	local fun = function(index)
		self:UpdateDropDown(index)
		if self.fromProgram then return end
		BM:ChangeIndex(self.selectRole,self.comDropDown.value+1)
		self.iUpdateFlag = 1
	end
	self.comDropDown.onValueChanged:AddListener(fun)
end

function BattleAIUI:UpdateDropDown(index)
	local BM = BattleAIDataManager:GetInstance()
	local options,data = BM:GetOptions()
	self.lastIndex = index
	local editable = index == BM:GetCustomTemplateIndex() - 1
	self.editable = editable
	-- if editable and not PlayerSetDataManager:GetInstance():IsChallengeOrderUnlock() then
	-- 	local oldIndex = BM:GetCurIndex(self.selectRole)
	-- 	self:setDropValue(oldIndex - 1)
	-- 	OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.BATTLE_AI_TIP, '', function()
	-- 		OpenWindowImmediately("ChallengeOrderUI")
	-- 	end})
	-- 	return
	-- end
	if self.mode == 'action' then
		self.rightA:SetActive(editable)
		self.rightB:SetActive(not editable)
	end
	if not editable then
		self.titleText.text = GetLanguageByID(data[index + 1].NameID)
		self.tipsText.text = GetLanguageByID(data[index + 1].StrategyNameID)
	end
	DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rightB:GetComponent("RectTransform"))
end

-- function BattleAIUI:CheckAndChangeToCustom()
-- 	local l_baid = BattleAIDataManager:GetInstance()
-- 	local customIndex = l_baid:GetCustomTemplateIndex()
-- 	if self.comDropDown.value + 1 ~= customIndex then
-- 		l_baid:WriteCustomAIInfo(self.selectRole,self.comDropDown.value+1)
-- 		l_baid:ChangeIndex(self.selectRole,customIndex)
-- 		self:setDropValue(customIndex - 1)
-- 	end 
-- end

function BattleAIUI:Init()
	--self.selectRole = role
	--derror('BattleAIUI +++++++++++++++++++++++++++++')
	self.comBtnExit = self:FindChildComponent(self._gameObject,"TabFrame/frame/Btn_exit","Button")
	self:AddButtonClickListener(self.comBtnExit,function()
		self._gameObject:SetActive(false)
		GetUIWindow("CharacterUI").objWindowTabUI:SetActive(true)
	end)
	self:AddEventListener("UPDATE_BATTLEAI_DATA", function()
		self.iUpdateFlag = 1
	end)
	self.bbox = self:FindChild(self._gameObject,"BattleAI_box")
	self.TeamListUI = self:FindChild(self.bbox,"TeamListUI")
	self.TeamListUICom = TeamListUICom.new()
    self.TeamListUICom:SetGameObject(self.TeamListUI)
    self.TeamListUICom:Init()
	self.TeamListUICom:SetScriptUI(self)

    self.objTeammateLimit = self:FindChild(self.bbox, "TeammateLimit")
    self.textTeammateLimit = self:FindChildComponent(self.objTeammateLimit, "Text", l_DRCSRef_Type.Text)
	
	self.left_box = self:FindChild(self.bbox,"left_box")
	self.sc_list = self:FindChild(self.left_box,"SC_list")
	self.objListContent = self:FindChild(self.left_box,"SC_list/Viewport/Content")
	self.comListContent_TG = self.objListContent:GetComponent("ToggleGroup")
	self.objListTemplate = self:FindChild(self.left_box,"SC_list/Toggle_ai")
	self.objListTemplate:SetActive(false)

	self.text_title = self:FindChild(self.bbox,"Text_title")
	
	self.sc_combo = self:FindChild(self.left_box,"SC_combo") or self.text_title
	self.combo_back = self:FindChild(self.bbox,"combo_back") or self.text_title
	self.com_text_title = self.text_title:GetComponent('Text')
	self:AddButtonClickListener(self.combo_back:GetComponent('DRButton'), function()
		self:SetMode('combo')
	end)
	self.combo_list = {}
	local tmp_combo = self:FindChild(self.sc_combo,"Toggle_combo")
	local combo_content = self:FindChild(self.sc_combo, "Viewport/Content")
	local comComboContent_TG = combo_content:GetComponent("ToggleGroup")
	local tmp_sk = self:FindChild(self.bbox,"skillIcon")
	local comFrameImage = tmp_sk:GetComponent("Image")
	self.commonSkillIcon = comFrameImage.sprite
	for k = 1, 3 do
		local clone = self:LoadGameObjFromPool(tmp_combo, combo_content.transform)
		local comText = self:FindChildComponent(clone,"Name","Text")
		local skill_list = self:FindChild(clone,"skill_list")
		for i = 1, MAX_COMBO_SIZE do
			local itemClass = self:LoadGameObjFromPool(tmp_sk,skill_list)
			self.combo_list[k * 100 + i] = itemClass
		end
		comText.text = GetLanguageByID(530)..k
		self.combo_list[k] = clone
		clone:SetActive(true)
		local comUIToggle = clone:GetComponent("Toggle")
		comUIToggle.group = comComboContent_TG
		local fun = function(bool)
			if self.fromProgram then return end
			local oldAI = self.curAI
			if bool then
				self.selectCombo = k
			end
		end
		self:AddToggleClickListener(comUIToggle, fun)
		comUIToggle.isOn = k == 1
	end
	tmp_sk:SetActive(false)

	self.objTab_box = self:FindChild(self._gameObject,"TabFrame/WindowTabUI/TransformAdapt_node_right/Tab_box")
    self.Toggle_ai_action = self:FindChildComponent(self.objTab_box,"Toggle_ai_action",l_DRCSRef_Type.Toggle)
    if self.Toggle_ai_action then
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_ai_action()
            end
        end
        self:AddToggleClickListener(self.Toggle_ai_action,fun)
    end
    self.Toggle_ai_combo = self:FindChildComponent(self.objTab_box,"Toggle_ai_combo",l_DRCSRef_Type.Toggle)
    if self.Toggle_ai_combo then
        local fun = function(bool)
            if bool then
                self:OnClick_Toggle_ai_combo()
            end
        end
        self:AddToggleClickListener(self.Toggle_ai_combo,fun)
	end
	
	self:InitDropDown()

	self.right_box = self:FindChild(self.bbox,"right_box")
	self.rightA = self:FindChild(self.right_box,"rightA")
	self.actionOrder = self:FindChild(self.rightA,"clist/Viewport/Order")
	self.actionList = self:FindChild(self.rightA,"clist/Viewport/Content")
	self.actionList_TG = self.actionList:GetComponent("ToggleGroup")
	self.actionTemplate = self:FindChild(self.rightA,"Toggle")
	self.actionTemplate:SetActive(false)
	self.actGroupTemplate = self:FindChild(self.rightA,"ToggleGroup")
	self.actGroupTemplate:SetActive(false)
	
	self.rightB = self:FindChild(self.right_box,"rightB")
	local comEditAIBtn = self:FindChild(self.rightB, "edit"):GetComponent('DRButton')

	self.titleText = self:FindChild(self.rightB, "title"):GetComponent('Text')
	self.titleImage = self:FindChild(self.rightB, "edit"):GetComponent('Image')
	self.tipsText = self:FindChild(self.rightB, "desc"):GetComponent('Text')
	
	self:AddButtonClickListener(comEditAIBtn, function()
		if self.mode == 'combo' then
			local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()
			if curDiff >= COMBO_UNLOCK_LV then
				self.selectCombo = self.selectCombo or 1
				self:SetMode('sub_action', self.selectCombo)
			else
				OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.SYSTEM_TIP, '难度3以上开放自创套路功能'})
			end
		else
			self.comDropDown.value = BattleAIDataManager:GetInstance():GetCustomTemplateIndex() - 1
		end
	end)
	local comTipBtn = self:FindChild(self.bbox, "Button"):GetComponent('DRButton')	
	self:AddButtonClickListener(comTipBtn, function()
		local id = 516
		if self.mode == 'combo' then
			id = 581
		end
		local tips = TipsDataManager:GetInstance():GetBattleAITips(id)
		OpenWindowImmediately("TipsPopUI", tips)
	end)
	self.comTipBtn = comTipBtn
	
	self.editTab = self:FindChild(self.right_box,"nav_box")
	local BM = BattleAIDataManager:GetInstance()
	self.tabCB = {}
	self.tabCom = {}
	self:BindToggleFunc(self.editTab, 1, function()
		self.tab = 1
		self:setOrderTab(false)
		local tarlist = BM:GetOpenTargetList()
		self:setTabData(tarlist, BM:GetTarget(self.selectRole, self.curAI, self.stg),"Target")
		self:addRoleTab(#tarlist,BM:GetTarget(self.selectRole, self.curAI, self.stg))
	end , true)
	self:BindToggleFunc(self.editTab, 2, function()
		self.tab = 2
		self:setOrderTab(false)
		local alist = BM:GetOpenActionList(self.selectRole)		
		self:setTabData(alist, BM:GetAction(self.selectRole, self.curAI, self.stg),"Action")
	end )
	self:BindToggleFunc(self.editTab, 3, function()
		self.tab = 3
		self:setOrderTab(true)
	end )
	self:BindButtonFunc(self.actionOrder, 'BtnAdd' , function()
		if BM:AIItemSize(self.selectRole, self.stg) >= SSD_AI_LIST_NUM then
			local msg = GetLanguageByID(557)
			OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.SYSTEM_TIP, msg})
			return
		end
		local oldAI = self.curAI
		oldAI = oldAI or 0
		if BM:AddAI(self.selectRole, oldAI, self.stg) then
			self:setDropValue(BM:GetCustomTemplateIndex() - 1)
			self.curAI = oldAI + 1
			local ai = BM:GetRoleBattleAI(self.selectRole, self.stg)
			local tm = BM:GetTargetMap()
			local am = BM:GetActionMap(self.selectRole)
			if oldAI == 0 then oldAI = 1 end
			for i = oldAI, SSD_AI_LIST_NUM do
				self:UpdateAItem(self.toggleAI[i], ai[i], tm, am)
			end
		end
	end)	
	self:BindButtonFunc(self.actionOrder, 'BtnUp' , function()
		if self.curAI and self.curAI > 1 then
			local oldAI = self.curAI
			self.curAI = oldAI - 1
			BM:SwapAI(self.selectRole, self.curAI, oldAI, self.stg)
			self:setDropValue(BM:GetCustomTemplateIndex() - 1)
			local ai = BM:GetRoleBattleAI(self.selectRole, self.stg)
			local tm = BM:GetTargetMap()
			local am = BM:GetActionMap(self.selectRole)
			self:UpdateAItem(self.toggleAI[oldAI], ai[oldAI], tm, am)
			self:UpdateAItem(self.toggleAI[self.curAI], ai[self.curAI], tm, am)
		end
	end)
	self:BindButtonFunc(self.actionOrder, 'BtnDown' , function()
		local ai = BM:GetRoleBattleAI(self.selectRole, self.stg)
		if self.curAI and self.curAI < #ai then
			local oldAI = self.curAI
			self.curAI = oldAI + 1
			BM:SwapAI(self.selectRole, self.curAI, oldAI, self.stg)
			self:setDropValue(BM:GetCustomTemplateIndex() - 1)
			local tm = BM:GetTargetMap()
			local am = BM:GetActionMap(self.selectRole)
			self:UpdateAItem(self.toggleAI[oldAI], ai[oldAI], tm, am)
			self:UpdateAItem(self.toggleAI[self.curAI], ai[self.curAI], tm, am)
		end
	end)
	self:BindButtonFunc(self.actionOrder, 'BtnDel' , function()
		if BM:DelAI(self.selectRole, self.curAI, self.stg) then
			self:setDropValue(BM:GetCustomTemplateIndex() - 1)
			local ai = BM:GetRoleBattleAI(self.selectRole, self.stg)
			local tm = BM:GetTargetMap()
			local am = BM:GetActionMap(self.selectRole)
			
			if ai[self.curAI] == nil then
				self.curAI = self.curAI - 1
			end
			if self.curAI < 1 then self.curAI = 0 end
			for i = self.curAI, SSD_AI_LIST_NUM do
				self:UpdateAItem(self.toggleAI[i], ai[i], tm, am)
			end
		end
	end)

	local max_sz = SSD_AI_LIST_NUM	
	for k = 1, max_sz do
		self:addAI_Item(k)
	end

	self.actionList:SetActive(false)
	self.actionOrder:SetActive(false)
	self:UpdateDropDown(0)
	--self.TeamListUICom:SetSelectRoleID(self.selectRole)
	--self.TeamListUICom:RefreshUI()
	--self.TeamListUICom.comList_Scroller:ScrollTo(2,1)
end

function BattleAIUI:SetMainRoleInfoActive(bActive)
    --self:FindChild(self.nav_box, '3'):SetActive(bActive)
end
function BattleAIUI:UpdateTeamLimitMsg()
    if not (self.textTeammateLimit and self.TeamListUICom) then
        return
    end
    local iCur = self.TeamListUICom:GetCurTeammateNum() or 0
    local iMax = RoleDataManager:GetInstance():GetCurTeammateLimit() or 0
    self.textTeammateLimit.text = string.format("(%d/%d)", iCur, iMax)
end

function BattleAIUI:addAI_Item(k)
	local ui_clone = self:LoadGameObjFromPool(self.objListTemplate,self.objListContent.transform)
	ui_clone:SetActive(true)
	local comUIToggle = ui_clone:GetComponent("Toggle")
	local comDesc = self:FindChildComponent(ui_clone,"Desc","Text")
	comUIToggle.group = self.comListContent_TG
	self.toggleAI[k] = ui_clone
	local fun = function(bool)
		if self.fromProgram then return end
		local oldAI = self.curAI
		if bool then
			self:OnSelectAI(k)
			local BM = BattleAIDataManager:GetInstance()
			local ai, stratergy = BM:GetRoleBattleAI(self.selectRole, self.stg)
			local tm = BM:GetTargetMap()
			local am = BM:GetActionMap(self.selectRole)
			self:UpdateAItem(self.toggleAI[oldAI], ai[oldAI], tm, am)
			self:UpdateAItem(self.toggleAI[self.curAI], ai[self.curAI], tm, am)
		end
	end
	self:AddToggleClickListener(comUIToggle, fun)
end

function BattleAIUI:setToggleOn(com, on)
	self.fromProgram = true
	com.isOn = on
	self.fromProgram = nil
end

function BattleAIUI:addAction_Item(id, gk, data, isOn)
    local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()
	local BM = BattleAIDataManager:GetInstance()	
	-- if data.LockLevel and curDiff < data.LockLevel then return end
	
	local ui_clone = self:LoadGameObjFromPool(self.actionTemplate,self.actionList.transform)
	ui_clone:SetActive(true)
	local comUIToggle = ui_clone:GetComponent("Toggle")
	local comText = self:FindChildComponent(ui_clone, 'Text_task', 'Text')
	local comOutline = self:FindChildComponent(ui_clone, 'Text_task', 'OutlineEx')
	local lockText = self:FindChild(ui_clone, 'Text_lock')
	local comLockText = self:FindChildComponent(ui_clone, 'Text_lock', 'Text')
	local lockImage = self:FindChild(ui_clone, 'Image_lock')
	local locked = data.LockLevel and curDiff < data.LockLevel
	lockText:SetActive(locked)
	lockImage:SetActive(locked)
	comText.text = data.text
	comUIToggle.interactable = not locked
	if locked then
		comLockText.text = '难度'.. data.LockLevel .. '解锁'		
	end

	local white = DRCSRef.Color(1, 1, 1, 1)
	local gb = 0.17
	local gray = DRCSRef.Color(gb, gb, gb, 1)
	if self.tab == 1 then
		if isOn then
			comText.color = white
		else
			comText.color = gray
		end
		comOutline.OutlineWidth = 0
	else
		if data.color then
			comText.color = data.color
		else
			comText.color = white
		end
		comOutline.OutlineWidth = 2
	end
	comUIToggle.group = self.actionList_TG
	self.toggleAction[id] = ui_clone
	ui_clone:SetActive(not self.targetFold[gk])
	local fun = function(bool)
		if self.fromProgram then return end
		if bool then
			comText.color = white
			if self.curAI and  not self._initTab then
				local changed
				if self.tab == 1 then
					changed = BM:UpdateAI(self.selectRole, self.curAI, data.id, nil, nil, self.stg)
				else
					changed = BM:UpdateAI(self.selectRole, self.curAI, nil, data.class.ClassType, data.id, self.stg)
				end
				if changed then
					local ai, stratergy = BM:GetRoleBattleAI(self.selectRole, self.stg)
					local tm = BM:GetTargetMap()
					local am = BM:GetActionMap(self.selectRole)
					self.stratergy = stratergy
					self:setDropValue(BM:GetCustomTemplateIndex() - 1)
					self:UpdateAItem(self.toggleAI[self.curAI], ai[self.curAI], tm, am)
				end
			end
		else
			if self.tab == 1 then
				comText.color = gray
			end
		end
	end
	self:AddToggleClickListener(comUIToggle, fun)
	self:setToggleOn(comUIToggle, isOn)
end

function BattleAIUI:addActGroup_Item(k, data,tabtype)
	local ui_clone = self:LoadGameObjFromPool(self.actGroupTemplate,self.actionList.transform)
	ui_clone:SetActive(true)
	local comUIToggle = ui_clone:GetComponent("DRButton")
	local arrow = self:FindChild(ui_clone, "arrow"):GetComponent("RectTransform")
	local comText = self:FindChildComponent(ui_clone, 'Name', 'Text')
	comText.text = data.text
	self.toggleActGroup[k] = ui_clone
	local fold = {}
	if tabtype == "Target" then
		fold = self.targetFold
	else
		fold = self.actionFold
	end
	local fun = function(p)
		local expand = not fold[k]
		if p == 'init' then
			expand = not expand
		end
		fold[k] = expand
		local base = k * 256
		local bool
		for i = 1, 100 do
			local act = self.toggleAction[base + i]
			if act then
				act:SetActive(expand)
			end
		end
		local rot = 0
		if expand then rot = -90 end
		arrow.localEulerAngles = DRCSRef.Vec3(0, 0, rot)
	end
	self:AddButtonClickListener(comUIToggle, fun)
	return fun
end

function BattleAIUI:BindToggleFunc(ent, id, func, isOn)
	local child = self:FindChild(ent,tostring(id))
	local textCom = self:FindChildComponent(child, "Text", "Text")
	local toggle = child:GetComponent("Toggle")
	self:AddToggleClickListener(toggle, function(bool)
		if bool then
			func()
			textCom.color = DRCSRef.Color(1, 1, 1, 1)
		else
			textCom.color = DRCSRef.Color(0.2, 0.2, 0.2, 1)
		end
	end)
	self:setToggleOn(toggle, isOn)
	self.tabCB[id] = func
	self.tabCom[id] = toggle
	if isOn then
		func()
	end
end

function BattleAIUI:BindButtonFunc(ent, name, func)
	local child = self:FindChild(ent, name)
	local btnCom = child:GetComponent('DRButton')
	self:AddButtonClickListener(btnCom, func)
end

function BattleAIUI:RefreshUI()
	self.iUpdateFlag = 1
	self.TeamListUICom:RefreshUI()
end

function BattleAIUI:Update()
    if self.iUpdateFlag ~= 0 then
		local BM = BattleAIDataManager:GetInstance()
		self:UpdateBattleAIByRole(self.selectRole,self.iUpdateFlag)
		local ai = BM:GetRoleBattleAI(self.selectRole, self.stg)
		if ai then
			local tm = BM:GetTargetMap()
			local am = BM:GetActionMap(self.selectRole)
			for i = 1, SSD_AI_LIST_NUM do
				self:UpdateAItem(self.toggleAI[i], ai[i], tm, am)
			end
		end
		self:UpdateAICombo(1)
		self:UpdateAICombo(2)
		self:UpdateAICombo(3)
        self.iUpdateFlag = 0
	end
	
    self.TeamListUICom:Update()
end

function BattleAIUI:setOrderTab(active)
	self.actionOrder:SetActive(active)
	self.actionList:SetActive(not active)
end

function BattleAIUI:setTabData(lst, id, tabtype, group)
	self._initTab = true
	self:ClearActionToggle()
	for k = 1,#lst do
		local g = lst[k]
		if (g.ClassType ~= BattleAIActionClass.BAAC_CUSTOM_COMBO and g.ClassType ~= BattleAIActionClass.BAAC_COMBO ) or self.mode == 'action' then
			local f = self:addActGroup_Item(k, g,tabtype)
			for a = 1, #g do
				local view_id = k * 256 + a
				local sel = g[a].id == id
				if sel and group then
					sel = group == g.ClassType
				end
				self:addAction_Item(view_id, k, g[a], sel)
			end
			f('init')
		end
	end
	self._initTab = nil
end

function BattleAIUI:canAddTab(tab)
	if #tab == 0 then
		return false
	end
	for i = 1,#tab do
		if tab[i]["lock"] == 0 then
			return true
		end
	end
	return false
end

function BattleAIUI:addRoleTab(k, id)	
	k = k + 1
	local g = { ClassType = 13, text = '选择我方-根据布阵'}
	local f = self:addActGroup_Item(k, g,"Target")

	local emBattle = RoleDataManager:GetInstance():GetRoleEmbattleInfo()
	local data = emBattle[EmBattleSchemeType.EBST_Normal][1]
	if data then
		for i = 1, #data do
			local view_id = k * 256 + i
			local sel = false --g.id == id and g.ClassType == group			
			local sName = RoleDataManager:GetInstance():GetRoleTitleAndName(data[i].uiRoleID)
			self:addAction_Item(view_id, k, { id = AI_ID_OFFSET + data[i].uiRoleID, text = sName, color = DRCSRef.Color(1, 1, 1, 1), class = g }, sel)
		end
	end
	f('init')
end
function BattleAIUI:SetSelectRoleIndex(index, autoSelect)
    local teammates = RoleDataManager:GetInstance():GetRoleTeammates()
	local roleID = teammates[index]
	if roleID then
		self:UpdateBattleAIByRole(roleID)
	end
end

function BattleAIUI:onAIDataSwitch(alist, idx)
	self:UpdateAI(alist)
	self:UpdateAICombo(1)
	self:UpdateAICombo(2)
	self:UpdateAICombo(3)
	self:setDropValue(idx - 1)
	local toggle = self.toggleAI[1]	
	if toggle then
		com = toggle:GetComponent("Toggle")
		com.isOn = true
	end
end

function BattleAIUI:setRole(roleID)
	if self.selectRole ~= roleID then
		if self.selectRole then
			BattleAIDataManager:GetInstance():UploadServerAIInfo(self.selectRole, self.stg)
		end
		self.selectRole = roleID
		if self.TeamListUICom.selectRole ~= roleID then
			self.TeamListUICom:SetSelectRoleID(roleID)
			self.TeamListUICom:RefreshUI()
		end
	end
end

function BattleAIUI:UpdateBattleAIByRole(role, flag)
	if flag ~= 1 then
		if self.selectRole == role or self.wait_role == role then return end
	end
	-- if role == 20 then print('123'..nil) end
	if role then
		local alist, stratergy = BattleAIDataManager:GetInstance():GetRoleBattleAI(role, self.stg)
		if alist == nil then
			self.left_box:SetActive(false)
			self.right_box:SetActive(false)
			self.wait_role = role
			self:setRole(role)
		else
			self.left_box:SetActive(true)
			self.right_box:SetActive(true)
			
			if self.selectRole ~= role or self.wait_role == role or self.stratergy ~= stratergy then
				self:setRole(role)
				self.wait_role = nil
				self.stratergy = stratergy
				self:onAIDataSwitch(alist, BattleAIDataManager:GetInstance():GetCurIndex(role))
			end
			if self.tab and self.tabCB[self.tab] then
				self.tabCB[self.tab]()
			end
		end
		
	end
end

function BattleAIUI:UpdateAItem(ui, ai_item, tm,  am, isOn)
	if ui == nil then return end
	if ai_item == nil then
		ui:SetActive(false)
		return
	end
	ui:SetActive(true)
	local comToggle = ui:GetComponent("Toggle")	
	if isOn == nil then
		isOn = self.curAI and self.toggleAI[self.curAI] == ui
		self:setToggleOn(comToggle, isOn)
	end
	local comText = self:FindChildComponent(ui,"Name","Text")
	local comDesc = self:FindChildComponent(ui,"Desc","Text")
	local MarkErr = self:FindChild(ui,"Mark_error")
	if isOn then
		comDesc.color = DRCSRef.Color(1, 1, 1, 1)
	else
		local gb = 0.17
		comDesc.color = DRCSRef.Color(gb, gb, gb, 1)
	end
	if ai_item == nil then
		comDesc.text = ''
		comText.text = ''
		return
	end
	local targetID = ai_item.targetID
	local action = ai_item.action
	local actParam = ai_item.actionParam
	local data = GetTableData("BattleAIAction",action)
	if data and data.ClassType == BattleAIActionClass.BAAC_OTHER then
		actParam = action
		action = BattleAIActionClass.BAAC_OTHER
	end

	local tarValid = targetID and targetID ~= 0
	local actValid = action and action ~= 0
	local err = nil
	if tarValid or actValid then
		local t1, t2 = "...", "..."
		if targetID then
			if targetID >= AI_ID_OFFSET then
				t1 = RoleDataManager:GetInstance():GetRoleTitleAndName(targetID - AI_ID_OFFSET)
			elseif tm[targetID] then
				t1 = tm[targetID].text or ""
			end
		end
		if action then
			local tmg = am[action]
			if tmg then
				local ti = tmg.map[actParam]
				if ti then
					t2 = ti.text or "..."
				else
					t2 = BattleAIDataManager:GetInstance():GetActionText(action, actParam) or "..."
					err = 1
				end
			end
		end
		if not err then
			err = not BattleAIDataManager:GetInstance():CheckValid(targetID, action, actParam,self.selectRole)
		end
		if err then
			if isOn then
				comDesc.color = errColHover
			else
				comDesc.color = errCol
			end
		end
		MarkErr:SetActive(err)
		
		comDesc.text = '对'.. t1 .. "释放 "
		if BattleAIActionClass.BAAC_CUSTOM_COMBO == action then
			comDesc.text = '释放 '
		end		
		comText.text = t2
	else		
		comDesc.text = ''
		comText.text = ''
	end
end

function BattleAIUI:UpdateAI(ai_list)
	if ai_list == nil then return end
	local tm = BattleAIDataManager:GetInstance():GetTargetMap()
	local am = BattleAIDataManager:GetInstance():GetActionMap(self.selectRole)
	for k = 1, SSD_AI_LIST_NUM do
		local ai_item = ai_list[k]
		local ui_clone = self.toggleAI[k]
		self:UpdateAItem(ui_clone, ai_item,tm, am)
	end
end

function BattleAIUI:UpdateAICombo(k)
	local BM = BattleAIDataManager:GetInstance()
	local tmg = BM:GetActionMap(self.selectRole)[BattleAIActionClass.BAAC_OTHER]
	
	local data = BM:GetRoleComboAI(self.selectRole, BM._CustomAIInfoIndex + k)
	if data == nil then return end	
	for i = 1, MAX_COMBO_SIZE do
		local skill = self.combo_list[k * 100 + i]
		local ai_item = data[i]
		local comFrameImage = skill:GetComponent("Image")
		local comText = self:FindChildComponent(skill, "Text", "Text")		
		local comImg = self:FindChildComponent(skill,"Image","Image")
		comImg.gameObject:SetActive(false)
		if ai_item == nil then
			skill:SetActive(false)
		else
			skill:SetActive(true)
			if i == MAX_COMBO_SIZE and data[i + 1] then
				comFrameImage.sprite = self.commonSkillIcon
				comText.text = '...'
			else
				local sk = BM:GetActionSkill(ai_item.action, ai_item.actionParam)
				if sk then
					comFrameImage.sprite = GetAtlasSprite("CommonAtlas", RANK_SKILL_BORDER[sk.Rank])
					comImg.gameObject:SetActive(true)
					comImg.sprite = GetSprite(sk.Icon)
					comText.text = ''
				else
					comText.text = ''
					comFrameImage.sprite = self.commonSkillIcon
					local ti = tmg.map[ai_item.action]
					if ti then
						comText.text = ti.text or ""
					end
				end
			end
		end
	end
	if self.selectCombo == k then
		local com = self.combo_list[k]:GetComponent("Toggle")
		com.isOn = true
	end
end


function BattleAIUI:ClearToggle()
	for i = 1, SSD_AI_LIST_NUM do
		if self.toggleAI[i]	then
			local comUIToggle = self.toggleAI[i]:GetComponent("Toggle")
			self:RemoveToggleClickListener(comUIToggle)
		end
	end
	self.toggleAI = {}
	self:RemoveAllChildToPool(self.objListContent.transform)
	for k = 1, 3 do
		local clone = self.combo_list[k]
		local comUIToggle = clone:GetComponent("Toggle")
		self:RemoveToggleClickListener(comUIToggle)
		
		local skill_list = self:FindChild(clone,"skill_list")
		for i = 1, MAX_COMBO_SIZE do
			local itemClass = self.combo_list[k * 100 + i]			
			self:RemoveAllChildToPool(itemClass.transform)
		end
		self:RemoveAllChildToPool(skill_list.transform)
	end
	local combo_content = self:FindChild(self.sc_combo, "Viewport/Content")
	self:RemoveAllChildToPool(combo_content.transform)
	self.combo_list = {}
end

function BattleAIUI:ClearActionToggle()	
	for k = 1, #self.toggleActGroup + 1 do
		local base = k * 256
		for i = 1, 100 do
			local act = self.toggleAction[base + i]
			if act then
				local com = act:GetComponent("Toggle")
				self:RemoveToggleClickListener(com)
			end
		end
		if self.toggleActGroup[k] then
			local com = self.toggleActGroup[k]:GetComponent("DRButton")
			self:RemoveButtonClickListener(com)
		end
	end
	self.toggleAction = {}
	self.toggleActGroup = {}
	self:RemoveAllChildToPool(self.actionList.transform)
end

function BattleAIUI:OnSelectAI(idx)
	self.curAI = 0
	local alist = BattleAIDataManager:GetInstance():GetRoleBattleAI(self.selectRole, self.stg)
	if alist then
		self.curAI = idx
		local ai_data = alist[idx]
		local ui = self.toggleAI[idx]
		self.tabCB[self.tab]()
	end
end

function BattleAIUI:NetGameCmdSend()
	local uiRoleUID = self.dynData.uiRoleUID
	local uiBattleAITypeID = self.dynData.uiTypeID
	local data = EncodeSendSeGC_ClickForgetBattleAI(uiRoleUID, uiBattleAITypeID)
	local iSize = data:GetCurPos()
	NetGameCmdSend(SGC_CLICK_ROLE_BattleAI_FORGET, iSize, data)
end

function BattleAIUI:OnDestroy()
	if self.TeamListUICom then
		self.TeamListUICom:Close()
		self.TeamListUICom = nil
	end
	self:ClearToggle()
	self:ClearActionToggle()
	BattleAIDataManager:GetInstance():UploadServerAIInfo(self.selectRole, self.stg)
	--self:ClearBattleAIItemTips()
	--RemoveEventTrigger(self.objRaycast)
end

function BattleAIUI:OnClose()
	BattleAIDataManager:GetInstance():UploadServerAIInfo(self.selectRole, self.stg)
end

function BattleAIUI:SetMode(m, combo_idx)
	local isCombo = m == 'combo'
	local notCombo = not isCombo
	if self.mode ~= m and self.mode ~= 'combo' then
		BattleAIDataManager:GetInstance():UploadServerAIInfo(self.selectRole, self.stg)
	end
	self.mode = m
	self.stg = nil
	if combo_idx then
		self.stg = BattleAIDataManager:GetInstance()._CustomAIInfoIndex + combo_idx
	end

	self.text_title:SetActive(true)
	self.com_text_title.text = '自动战斗方式'
	self.comDropDown.gameObject:SetActive(false)
	self.sc_list:SetActive(true)
	self.sc_combo:SetActive(false)	
	self.combo_back:SetActive(false)
	self.comTipBtn.gameObject:SetActive(true)
	self.titleImage.color = DRCSRef.Color(1, 1, 1, 1)
	self.curAI = 0
	if m == 'combo' then
		local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()
		if curDiff < COMBO_UNLOCK_LV then
			self.titleImage.color = DRCSRef.Color(0.5, 0.5, 0.5, 1)
		end
		self.com_text_title.text = '套路列表'
		self.selectCombo = 1
		self.sc_list:SetActive(false)
		self.sc_combo:SetActive(true)
		self.rightA:SetActive(false)
		self.rightB:SetActive(true)
		self.titleText.text = GetLanguageByID(530)
		self.tipsText.text = GetLanguageByID(529)
		self:UpdateAICombo(1)
		self:UpdateAICombo(2)
		self:UpdateAICombo(3)
	else
		if m == 'sub_action' then
			self.com_text_title.text = '套路战斗方式'		
			self.combo_back:SetActive(true)
			self.comTipBtn.gameObject:SetActive(false)
			self.rightA:SetActive(true)
			self.rightB:SetActive(false)
		else
			self.comDropDown.gameObject:SetActive(true)
			local editable = self.editable
			self:UpdateDropDown(self.lastIndex or 0)
		end
		
		local alist = BattleAIDataManager:GetInstance():GetRoleBattleAI(self.selectRole, self.stg)
		if alist and alist[1] then
			self:OnSelectAI(1)
		end
		self:UpdateAI(alist)
		self.tabCB[self.tab]()
	end
end

function BattleAIUI:OnClick_Toggle_ai_action()
	self:SetMode('action')
	self.tabCB[self.tab]()
end

function BattleAIUI:OnClick_Toggle_ai_combo()
    self:SetMode('combo')
end

return BattleAIUI