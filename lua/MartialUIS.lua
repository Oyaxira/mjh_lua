MartialUIS = class("MartialUIS",BaseWindow)
local AIUICom = require 'UI/Role/BattleAIUI'

local EMBATTLE_MARTIAL_MAX = 8
local l_DRCSRef_Type = DRCSRef_Type
local rank_enumtostr = { 'White','Green','Blue','Purple','Orange','Gold','DarkGold','JingliangDarkGold', 'YouxiuDarkGold' }
local depart_type_ets = {
    [1] = "暗器",
    [2] = "刀法",
    [3] = "剑法",
    [4] = "内功",
    [5] = "奇门",
    [6] = "轻功",
    [7] = "拳掌",
    [8] = "腿法",
    [9] = "医术",
    [10] = "外功",
}
local attr_revert = {
	[AttrType.ATTR_LIDAO] = '力道',
	[AttrType.ATTR_TIZHI] = '体质',
	[AttrType.ATTR_JINGLI] = '精力',
	[AttrType.ATTR_NEIJIN] = '内劲',
	[AttrType.ATTR_LINGQIAO] = '灵巧',
	[AttrType.ATTR_WUXING] = '悟性',
	[AttrType.ATTR_QUANZHANGJINGTONG] = "拳掌精通",
	[AttrType.ATTR_JIANFAJINGTONG] = "剑法精通",
	[AttrType.ATTR_DAOFAJINGTONG] = "刀法精通",
	[AttrType.ATTR_TUIFAJINGTONG] = "腿法精通",
	[AttrType.ATTR_QIMENJINGTONG] = "奇门精通",
	[AttrType.ATTR_ANQIJINGTONG] = "暗器精通",
	[AttrType.ATTR_YISHUJINGTONG] = "医术精通",
	[AttrType.ATTR_NEIGONGJINGTONG] = "内功精通",
	[AttrType.ATTR_SUDUZHI] = "速度值",
}

local UPDATE_TYPE =
{
    ["UpdateMartialByRole"] = 1,
    ["UpdateEmbattleMartial"] = 2,
}

function MartialUIS:ctor(obj)
    -- 如果是背包里的武学界面，则 martial_box 位置 20，-30
    -- BG 大小为 998, 645
    -- Button_back 隐藏，Window_base 隐藏，不打开 toptitle

    -- 如果是请教界面，
    -- 人物信息显示，修炼介绍、修炼按钮显示
    -- Button_back 显示，Window_base 显示，打开 toptitle

    -- 如果是观摩界面，观摩按钮显示
	-- 重置冷却时间，一直隐藏，需要再显示
	self:SetGameObject(obj)
	self.akItemUIClass = {}
	self.iUpdateFlag = 0
end

function MartialUIS:IsBattleAIUIShow()
	return self.AIUI and self.AIUI.activeSelf
end
function MartialUIS:InitBattleAIUI()
	if self.AIUI then return end
	self.AIUI = self:FindChild(self._gameObject,"BattleAIUI")
	if self.AIUI then
		self.AIUICom = AIUICom.new(self.AIUI)
		self.AIUICom:Init(self.selectRole)
	end
end

function MartialUIS:Init(type, CharacterUI)
	self.CharacterUI = CharacterUI
	self.parentType = type
	self.type = type		-- 设置外层界面的类型
	-- 左边武学列表
	self.mbox = self:FindChild(self._gameObject, "martial_box")
	self.left_box = self:FindChild(self._gameObject,"martial_box/left_box")
	self.objMartial_num = self:FindChild(self._gameObject,"martial_box/Martial_num");
	self.Martial_num = self:FindChildComponent(self._gameObject,"martial_box/Martial_num/Number",l_DRCSRef_Type.Text);
	-- self.comHaveMartial_TMP = self:FindChildComponent(self.left_box,"label/Number",l_DRCSRef_Type.Text)
	self.objListContent = self:FindChild(self.left_box,"SC_list/Viewport/Content")
	self.comListContent_TG = self.objListContent:GetComponent(l_DRCSRef_Type.ToggleGroup)
	self.objListTemplate = self:FindChild(self.left_box,"SC_list/Toggle_skillS")
	self.objListTemplate:SetActive(false)

	-- 右边武学详细信息
	self.objEquipMartial = self:FindChild(self._gameObject,"martial_box/right_box/equipMartial")
	if self.objEquipMartial then
		self.comEquipMartialBtn = self.objEquipMartial:GetComponent("DRButton")
	end
	self.objUnEquipMartial = self:FindChild(self._gameObject,"martial_box/right_box/unequipMartial")
	if self.objUnEquipMartial then
		self.comUnEquipMartialBtn = self.objUnEquipMartial:GetComponent("DRButton")
	end
	self:AddButtonClickListener(self.comEquipMartialBtn,function()
		if next(self.array_skill_icons) then
			self:OnClick_Embattle_Skill(self.array_skill_icons[0], self.dynData)
		end
	end)

	self:AddButtonClickListener(self.comUnEquipMartialBtn,function()
		local uiID = self.dynData['uiID']
		local typeID = self.dynData['uiTypeID']
		local aInfo = {
			['dwUID'] = uiID,
			['dwTypeID'] = typeID,
			['dwIndex'] = 0,
		}
		self:OnClick_Embattle_Submit(aInfo, 0)
	end)
	self.objNo_martial = self:FindChild(self._gameObject,"martial_box/no_martial")
	self.objNo_martial:SetActive(false)
	self.right_box = self:FindChild(self._gameObject,"martial_box/right_box")
	self.title_box = self:FindChild(self.right_box,"title_box/layout")
	self.comMartialTitle = self:FindChildComponent(self.title_box,"label/Name",l_DRCSRef_Type.Text)
	self.objTitleClassText = self:FindChild(self.title_box,"Text_class")
	self.objTitleClanText = self:FindChild(self.title_box,"Text_clan")
	self.objTitleTagText = self:FindChild(self.title_box,"Text_tag")
	self.objTitleInheritText = self:FindChild(self.title_box,"Text_inherit")
	self.objMarkStrong = self:FindChild(self._gameObject,"martial_box/right_box/title_box/layout/Mark_strong")
	self.comTitleClassText = self.objTitleClassText:GetComponent(l_DRCSRef_Type.Text)
	self.comTitleClanText = self.objTitleClanText:GetComponent(l_DRCSRef_Type.Text)
	self.comTitleTagText = self.objTitleTagText:GetComponent(l_DRCSRef_Type.Text)
	self.comTitleInheritText = self.objTitleInheritText:GetComponent(l_DRCSRef_Type.Text)
	-- self.comTitleStrongText = self.objTitleStrongText:GetComponent(l_DRCSRef_Type.Text)
	if self.objMarkStrong then
		self.objMartialStrong = {
			[1] = self:FindChild(self.objMarkStrong,"level_1"),
			[2] = self:FindChild(self.objMarkStrong,"level_2"),
			[3] = self:FindChild(self.objMarkStrong,"level_3"),
			[4] = self:FindChild(self.objMarkStrong,"level_4"),
			[100] = self:FindChild(self.objMarkStrong,"evolution_1"),
			[101] = self:FindChild(self.objMarkStrong,"evolution_3"),
			[102] = self:FindChild(self.objMarkStrong,"evolution_2"),
			[103] = self:FindChild(self.objMarkStrong,"evolution_4"),
		}

		local btnMarkStrong = self.objMarkStrong:GetComponent(DRCSRef_Type.Button)
		if MartialDataManager:GetInstance():OpenMakeMartialStrong() then
			self:AddButtonClickListener(btnMarkStrong,function()
				if self.dynData then
					local maxLevel = MartialDataManager:GetInstance():GetMaxMartialStrongLevel()
					local level = self.dynData.iStrongLevel or 0
					if level <= maxLevel then
						OpenWindowImmediately("MartialStrongUI",{self.dynData.uiRoleUID, self.dynData})
					else
						SystemUICall:GetInstance():Toast(GetLanguageByID(730016)) --已经研读到顶级，无法继续研读
					end
				end
			end)
		end
	end

	self.exp_box = self:FindChild(self.right_box,"exp_box")
	self.comLevel_TMP = self:FindChildComponent(self.exp_box,"TMP_level",l_DRCSRef_Type.Text)
	self.comExpScrollbar = self:FindChildComponent(self.exp_box,"Scrollbar",l_DRCSRef_Type.Scrollbar)
	self.comExp_TMP = self:FindChildComponent(self.exp_box,"TMP_exp",l_DRCSRef_Type.Text)
	self.comBtnExp = self:FindChildComponent(self.exp_box,"Button_exp",l_DRCSRef_Type.Button)
	self.comTextValue = self:FindChildComponent(self.exp_box,"Button_exp/Text_value",l_DRCSRef_Type.Text)
	self.comBtnExp.gameObject:SetActive(false)
	self.skill_box = self:FindChild(self.right_box,"skill_box")
	self.comSkillLayoutElement = self.skill_box:GetComponent(l_DRCSRef_Type.LayoutElement)
	self.skill_box_content = self:FindChild(self.skill_box,"Viewport/Content")
	self.comScrollRect = self.skill_box:GetComponent("ScrollRect")
	self.dataSkillboxHeight = self.comSkillLayoutElement.minHeight or 0
	self.forgottenMartial = self:FindChild(self.right_box,"forgottenMartial")
	self.makeSecret = self:FindChild(self.right_box,"makeSecret")
	self.comTextMakeSecret = self:FindChildComponent(self.right_box,"makeSecret/Text",l_DRCSRef_Type.Text)
	if self.comTextMakeSecret then
		self.comTextMakeSecret.text = GetLanguageByID(730010)
	end
	self.objDetail_content = self:FindChild(self.right_box, "SC_content/Viewport/Content")
	self.objDetail_template = self:FindChild(self.right_box, "SC_content/Viewport/templateS")
	self.objDetail_template:SetActive(false)

	self.btnAI = self:FindChild(self._gameObject, "martial_box/btnAI")
	if self.btnAI then
		-- if DEBUG_MODE then
		self.btnAIText = self:FindChildComponent(self.btnAI,"Text",l_DRCSRef_Type.Text)
		self.btnAI:SetActive(true)
		self.btnAICom = self.btnAI:GetComponent(l_DRCSRef_Type.Button)
		if self.btnAICom then
			self:AddButtonClickListener(self.btnAICom, function()
				-- derror(self.selectRole,'444444')
				if CLOSE_EXPERIENCE_OPERATION then
					SystemUICall:GetInstance():Toast('体验版暂不开放')
					return
				else
					local role = self.selectRole
					self:InitBattleAIUI()
					--self.mbox:SetActive(false)
					self.AIUI:SetActive(true)
					self.CharacterUI.objWindowTabUI:SetActive(false)	--打开AIUI时隐藏背景的tab
					self.AIUICom:UpdateBattleAIByRole(role)
					--self.CharacterUI:ResetMode('ai')
					self.IsAI = true
					self.AIUICom:SetMode('action')
					self.AIUICom.Toggle_ai_action.isOn = true
				end
				
			end)
		end
		-- else
		-- 	self.btnAI:SetActive(false)
		-- end
	end
	self.btn_forgottenMartial =  self:FindChildComponent(self.right_box,"forgottenMartial",l_DRCSRef_Type.Button)
	if self.btn_forgottenMartial then
		self:AddButtonClickListener(self.btn_forgottenMartial, function()
			if CLOSE_EXPERIENCE_OPERATION then
				SystemUICall:GetInstance():Toast('体验版暂不开放')
				return
			else
				self:ForgottenMartial()
			end
		end)
	end

	self.makeSecret = self:FindChild(self.right_box, "makeSecret")
	self.btn_makeSecret =  self:FindChildComponent(self.right_box,"makeSecret",l_DRCSRef_Type.Button)
	if self.btn_makeSecret then
		self:AddButtonClickListener(self.btn_makeSecret, function()
			self:MakeSecret()
		end)
	end

	-- 出战配置
	self.skill_use_box = self:FindChild(self._gameObject,"martial_box/skill_use_box")
	self.skill_list_box = self:FindChild(self.skill_use_box,"skill_list")
	self.embattleSkillIconClass = {}
	
	for i = 1, EMBATTLE_MARTIAL_MAX do
		local itemClass
		if self.parentType == 'Character' then
			itemClass = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.SkillIconUIS,self.skill_list_box.transform)
		else
			itemClass = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.SkillIconUI,self.skill_list_box.transform)
		end
		-- if self.parentType == 'Character' then
		-- 	itemClass.transform.localScale= DRCSRef.Vec3(2/3,2/3,2/3)
		-- 	local rectItemClass =  itemClass._gameObject:GetComponent("RectTransform")
		-- 	SetUIAxis(itemClass._gameObject,rectItemClass.rect.width/3 * 2,rectItemClass.rect.height/3 * 2)
		-- end
		self.embattleSkillIconClass[i] = itemClass
	end
	self.comButtonEmbattleLeft = self:FindChildComponent(self.skill_use_box, "Button_left", l_DRCSRef_Type.Button)
	if self.comButtonEmbattleLeft then
		self:AddButtonClickListener(self.comButtonEmbattleLeft, function()
			self:EmbattleMartialPage(false)
		end)
	end
	self.comButtonEmbattleRight = self:FindChildComponent(self.skill_use_box, "Button_right", l_DRCSRef_Type.Button)
	if self.comButtonEmbattleRight then
		self:AddButtonClickListener(self.comButtonEmbattleRight, function()
			self:EmbattleMartialPage(true)
		end)
	end
	self.embattle_page = 1		-- 出战配置 - 页码


	self.tipsPopUIMini = self:FindChild(self._gameObject,"TipsPopUIMini")
	self.objRaycast = self:FindChild(self.tipsPopUIMini, 'raycast');

	-- 武学经验加成tips
	self.exp_box = self:FindChild(self.right_box,"exp_box")

	self.comSCContentLayoutElement = self:FindChildComponent(self.right_box, "SC_content",l_DRCSRef_Type.LayoutElement)
	self.dataSCContentMinHeight = self.comSCContentLayoutElement.minHeight

	self.martial_toggle = {}
	self:InitOtherDataByType()		-- 按界面类型，加载其他数据

	-- 讨论区
	self.btnDiscuss = self:FindChildComponent(self.mbox,"Button_discuss","Button")
	if (self.btnDiscuss) then
		if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_MARTIAL) then
			self.btnDiscuss.gameObject:SetActive(true)
			self:AddButtonClickListener(self.btnDiscuss, function()
				local articleId
				if (self.typeData ~= nil) then
					local targetId = self.typeData.BaseID
					articleId = DiscussDataManager:GetInstance():GetDiscussTitleId(ArticleTargetEnum.ART_MARTIAL,targetId)
				end
				if (articleId == nil) then
					SystemUICall:GetInstance():Toast('该讨论区暂时无法进入',false)
				else
					OpenWindowImmediately("DiscussUI",articleId)
				end
			end)
		else
			self.btnDiscuss.gameObject:SetActive(false)
		end
	end

	if self:IsShowHelpButton() then
		self.objHelpState = self:FindChild(self._gameObject, "HelpState")
		if self.objHelpState then
			self.objHelpState:SetActive(false)
			self.comBtnHelpState_Btn = self:FindChildComponent(self.objHelpState, "Info_Btn",'DRButton')
			if self.comBtnHelpState_Btn then
				self:AddButtonClickListener(self.comBtnHelpState_Btn, function()
					self:ShowHelpValueTips()
				end)
			end
		end
	end

end
function MartialUIS:IsShowHelpButton()
	-- 只在难度1-4的自由、魔君剧本中显示，其他剧本、或难度5以上，就不显示了
	local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()
	if curDiff <= 4 then
		local curStoryID = GetCurScriptID()
		if curStoryID == 2 or curStoryID == 7 then
			return true
		end
	end
	return false
end
-- 显示tips
function MartialUIS:ShowHelpValueTips()
	if not self.kRateTip then
        self.kRateTip = {
            ['kind'] = 'wide',
            ['title'] = "关于武学如何提升",
            ['titlecolor'] = DRCSRef.Color.white,
            ['content'] = GetLanguageByID(568),
        }
    end
    OpenWindowImmediately("TipsPopUI", self.kRateTip)
end
function MartialUIS:RefreshUI()
	self:UpdateMartialByRole()
end

function MartialUIS:Update()
	if self.comScrollRect and self.skill_box_content then
		if self.skill_box_content.transform.childCount <= 4 then
			self.comScrollRect.horizontal = false
		elseif IsWindowOpen("TipsPopUI") then
			local tipsPopUI = GetUIWindow("TipsPopUI")
			local value = tipsPopUI:GetScrollValue()
			--TipsPopUI中的内容是否滚动完
			if 1 - value < 0.01 then
				self.comScrollRect.horizontal = true
			else
				self.comScrollRect.horizontal = false
			end
		else
			self.comScrollRect.horizontal = true
		end
	end

	if self:IsBattleAIUIShow() then
		self.AIUICom:Update()
	end
    if self.iUpdateFlag ~= 0 then
        if HasFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateMartialByRole) then
			self:UpdateMartialByRole()
        end
        if HasFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateEmbattleMartial) then
            self:UpdateEmbattleMartial()
        end
        self.iUpdateFlag = 0
    end
end

function MartialUIS:InitOtherDataByType()
	if self.type == 'Clan' then		-- 门派学武界面
		self.comTextMartialTip = self:FindChildComponent(self._gameObject,"person_info/Describe/Text",l_DRCSRef_Type.Text)
	else
		self:AddEventListener("UPDATE_MARTIAL_DATA", function()
			self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateMartialByRole)
		end)
		self:AddEventListener("UPDATE_DISPLAY_ROLE_MARTIALS", function()
			self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateMartialByRole)
		end)
		self:AddEventListener("UPDATE_EMBATTLE_MARTIAL", function()
			self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UpdateEmbattleMartial)
		end)
		self:AddEventListener("UPDATE_BATTLEAI_DATA", function()
			self:UpdateStratergy()
		end)
	end
end

-- 从角色界面发送调用，使用的是角色的武学面板
function MartialUIS:UpdateMartialByRole(role)
	if role and (role ~= self.selectRole) then
		self.selectRole = role
		self.comCurMatTog = nil
	end
	if self:IsBattleAIUIShow() then
		--self.AIUICom:UpdateBattleAIByRole(self.selectRole)
	end
	if self.selectRole then
		self:UpdateStratergy(self.selectRole)
	end

	local martial_list = MartialDataManager:GetInstance():GetRoleMartial(self.selectRole) or {}
	if next(martial_list) then
		self.skill_use_box:SetActive(true)
	else
		self.skill_use_box:SetActive(false)
	end
	self:UpdateMartial(martial_list)		-- 这里的武学列表，是 按 动态 ID - 动态数据 存的

	self:UpdateEmbattleMartial()			-- 人物界面 - 刷新出战配置

    local showAI = true
    -- TODO: 走掌门对决逻辑，等待重构，不写在赋值前面判断是因为怕污染现有逻辑代码，所以进行后处理
	if PKManager:GetInstance():IsRunning() and PKManager:GetInstance():HideAI() then
		showAI = false
	end
	self:ShowAI(showAI)
end

function MartialUIS:EmbattleMartialPage(isAdd)
	local martialList = globalDataPool:getData("EmbattleMartial")
	local info = martialList[self.selectRole]
	if not (info and next(info)) then return end

	if isAdd == false and self.embattle_page <= 1 then return end
	if isAdd == true and self.embattle_page * EMBATTLE_MARTIAL_MAX >= getTableSize(info) then return end
	if isAdd then
		self.embattle_page = self.embattle_page + 1
	else
		self.embattle_page = self.embattle_page - 1
	end
	self:UpdateEmbattleMartial(info)
end

function MartialUIS:SortEmbattleMartial(info)
	-- 对服务器下行存到 global 里的数据按 index 进行排序
	local sortArray = table_c2lua(info)
	table.sort(sortArray, function(a,b)
		return a.dwIndex < b.dwIndex
	end)
	return sortArray
end

-- 服务器下行：更新全部出战配置
function MartialUIS:UpdateEmbattleMartial(info)

	-- 获取数据
	if GetGameState() == -1 then
		local platTeamInfo = globalDataPool:getData('PlatTeamInfo') or {};
		info = info or platTeamInfo.RoleInfos[self.selectRole].akEmBattleMartialInfo;
	else
		local martialList = globalDataPool:getData("EmbattleMartial") or {}
		info = info or martialList[self.selectRole];
    end
	info = info or {}
	if next(info) then
		info = self:SortEmbattleMartial(info)
	end
	self.embattle_skill_info = info
	-- 生成一份id->出战状态的映射
	self.kSkillEmbatteState = {}
	for index, kSkillInfo in ipairs(info) do
		self.kSkillEmbatteState[kSkillInfo.dwUID] = kSkillInfo.dwIndex
	end
	if info and #info > 0 then
		for i = 1, EMBATTLE_MARTIAL_MAX do
			-- 修正page
			local iMaxPage = math.ceil(#info / EMBATTLE_MARTIAL_MAX)
			if self.embattle_page > iMaxPage then
				self.embattle_page = iMaxPage
			elseif self.embattle_page < 1 then
				self.embattle_page = 1
			end

			local pos = (self.embattle_page - 1) * EMBATTLE_MARTIAL_MAX + i
			if pos <= #info and info[pos] then
				self.embattleSkillIconClass[i]:SetActive(true)
				self:UpdateSkillByMartial(self.embattleSkillIconClass[i], info[pos])
				-- TODO：需要给 SKillIcon 记录一个 UINT
			else
				self.embattleSkillIconClass[i]:SetActive(false)
			end
		end

		-- 左右按钮
		if #info <= EMBATTLE_MARTIAL_MAX then
			self.comButtonEmbattleLeft.gameObject:SetActive(false)
			self.comButtonEmbattleRight.gameObject:SetActive(false)
		else
			self.comButtonEmbattleLeft.gameObject:SetActive(true)
			self.comButtonEmbattleRight.gameObject:SetActive(true)
		end
	else
		-- 角色的出战配置为空，正常情况下，必须拥有一个武学
		for i = 1, EMBATTLE_MARTIAL_MAX do
			self.embattleSkillIconClass[i]:SetActive(false)
		end
	end
end

-- [1] 更新出战配置中的一个武学（技能）
function MartialUIS:UpdateSkillByMartial(itemIconClass, aInfo)
	local dynID = aInfo.dwUID
	local martialBaseID = aInfo.dwTypeID
	local dynMartialData = MartialDataManager:GetInstance():GetMartialData(dynID)
	local martialBaseData = GetTableData("Martial",martialBaseID)
	local _map_skillid
	if dynMartialData and dynMartialData.auiMartialUnlockSkills then
		_map_skillid = {}
		for i,v in pairs(dynMartialData.auiMartialUnlockSkills) do
			_map_skillid[v] = true
		end
	end
	local martialLevel = dynMartialData and dynMartialData['uiLevel']		-- TODO: 出战配置里等级也要显示

	local iconData = {
		['skillID'] = nil,
		['isCombo'] = false,
		['isLock'] = false,
		['unlockLvl'] = 0,
	}

	-- 招式技能
	if martialBaseData['MartMovIDs'] then
		for i = 1, #martialBaseData['MartMovIDs'] do
			local miTypeData = MartialDataManager:GetInstance():GetMartialItemTypeData(martialBaseData['MartMovIDs'][i])
			iconData = self:ParseMiEmbattle( iconData, miTypeData)
		end
	end

	--技能进化 替换原来的技能图标
	if dynMartialData and dynMartialData['iMartialUnlockItemSize'] then
		for j = 0,dynMartialData['iMartialUnlockItemSize'] - 1 do
			local miTypeData = MartialDataManager:GetInstance():GetMartialItemTypeData(dynMartialData['auiMartialUnlockItems'][j])
			if miTypeData and (miTypeData.EffectEnum1 == MartialItemEffect.MTT_JINENGJINGHUA or miTypeData.EffectEnum2 == MartialItemEffect.MTT_JINENGJINGHUA) then
				iconData = self:ParseMiEmbattle( iconData, miTypeData)
			end
		end
	end

	local buttons ={}
	buttons[#buttons + 1] =
	{
		['name'] = dtext(1005),
		['func'] = function()
			-- 卸下，发送服务器信息
			self:OnClick_Embattle_Submit(aInfo, 0)
		end
	}

    -- TODO: 走掌门对决逻辑，等待重构，不写在赋值前面判断是因为怕污染现有逻辑代码，所以进行后处理
	if PKManager:GetInstance():IsRunning() and PKManager:GetInstance():HideEquipMartial() then
		table.remove(buttons, #buttons)
	end
	local coldTime = (dynMartialData or {})['uiColdTime']
	itemIconClass:UpdateUI(iconData['skillID'], iconData['isCombo'], iconData['isLock'], iconData['unlockLvl'], coldTime, martialBaseID)
	--itemIconClass:SetTipsValue(dynMartialData,iconData['skillID'],buttons)
	itemIconClass.parentType = 'IsEmbattle'
	itemIconClass:SetTipsValue(dynMartialData,iconData['skillID'],nil)	--去除tips中的按钮
	
	itemIconClass:SetLayer(martialLevel)
end

-- 服务器上下行，传输的 ID 为本武学 ID
function MartialUIS:OnClick_Embattle_Skill(iconData, dynData)
	if dynData == nil then return end
	local uiID = dynData['uiID']
	local typeID = dynData['uiTypeID']
	local aInfo = {
		['dwUID'] = uiID,
		['dwTypeID'] = typeID,
		['dwIndex'] = 0,
	}

	local tempAdd = 1 		-- 临时处理

	-- 如果已经在出战配置里了，说明是换位置，位置不要加一
	-- if self.embattle_skill_info then
	-- 	for i = 1, #self.embattle_skill_info do
	-- 		if self.embattle_skill_info[i].dwUID == uiID then
	-- 			aInfo = self.embattle_skill_info[i]
	-- 			tempAdd = 0
	-- 			break
	-- 		end
	-- 	end
	-- end

	local iSkillEmbattleState = 0
	if self.kSkillEmbatteState and self.kSkillEmbatteState[uiID] then
		iSkillEmbattleState = self.kSkillEmbatteState[uiID]
	end
	if self.embattle_skill_info
	and (iSkillEmbattleState > 0)
	and self.embattle_skill_info[iSkillEmbattleState] then
		aInfo = self.embattle_skill_info[iSkillEmbattleState]
		tempAdd = 0
	end

	-- TODO：这里通过拖拽， 可以改变位置
	self:OnClick_Embattle_Submit(aInfo, #self.embattle_skill_info + tempAdd)
end

-- 玩家操作：将武学上阵/斜下
function MartialUIS:OnClick_Embattle_Submit(aInfo, index)
	if not (aInfo and index) then return end
	if (index == 0)  and  (#self.embattle_skill_info <= 1) then
		SystemUICall:GetInstance():Toast("至少保留一个出战武学")
		return
	end

    local data = EncodeSendSeGC_ClickChangeEmBattleMartial(self.selectRole, aInfo, index)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CHANGE_EMBATTLE_MARTIAL, iSize, data)
end

-- [2] 解析 技能配置栏 一个 MartialItem
function MartialUIS:ParseMiEmbattle( iconData, miTypeData)
	-- [2-1] 普通技能，只显示第一个技能
	if miTypeData.EffectEnum1 == MartialItemEffect.MTT_ZHAOSHIJINENG then
		iconData['skillID'] = iconData['skillID'] or miTypeData.SkillID1
	end
	if miTypeData.EffectEnum2 == MartialItemEffect.MTT_ZHAOSHIJINENG then
		iconData['skillID'] = iconData['skillID'] or miTypeData.SkillID2
	end

	-- [2-2] 技能进化，要替换之前的技能
	if miTypeData.EffectEnum1 == MartialItemEffect.MTT_JINENGJINGHUA then
		iconData = self:ParseEvoEmbattle(iconData, miTypeData.Effect1Value)
	end
	if miTypeData.EffectEnum2 == MartialItemEffect.MTT_JINENGJINGHUA then
		iconData = self:ParseEvoEmbattle(iconData, miTypeData.Effect2Value)
	end

	return iconData
end

-- [2-3] 解析 技能配置栏 武学的技能进化 替换
function MartialUIS:ParseEvoEmbattle( iconData, effectArray)
	local beforeSkillID = effectArray[1]
	local afterSkillID = effectArray[2]
	if iconData['skillID'] == beforeSkillID then
		iconData['skillID'] = afterSkillID
	end
	return iconData
end

function MartialUIS:ClearToggle()
	-- 清理左侧已有的武学列表
	for i = 1, #self.martial_toggle do
		self:RemoveToggleClickListener(self.martial_toggle[i])
	end
	self.martial_toggle = {}
	self:RemoveAllChildToPool(self.objListContent.transform)
end

function MartialUIS:ClearMartialItemTips()
	self:RemoveAllChildToPool(self.objDetail_content.transform)
end

-- 门派发过来的武学列表，只有静态 ID
function MartialUIS:UpdateMartial(martial_list, isTypeID)
	self:ClearToggle()
	if not isTypeID then
		martial_list = table_hash2array(martial_list)
		table.sort( martial_list, function(a, b)
			local typeA = GetTableData("Martial",a.uiTypeID)
			local typeB = GetTableData("Martial",b.uiTypeID)

			-- 品质
			if typeA.Rank and typeB.Rank and (typeA.Rank == typeB.Rank) then

				-- 等级
				if a.uiLevel == b.uiLevel then

					-- 系别
					if typeA.DepartEnum == typeB.DepartEnum then
						return (a.uiTypeID or 0) > (b.uiTypeID or 0)
					elseif typeA.DepartEnum == DepartEnumType.DET_Soul then
						return true
					elseif typeB.DepartEnum == DepartEnumType.DET_Soul then
						return false
					else
						return (typeA.DepartEnum or 0) < (typeB.DepartEnum or 0)
					end
				end
				return (a.uiLevel or 0) > (b.uiLevel or 0)

			elseif typeA.Rank and typeB.Rank and (typeA.Rank ~= typeB.Rank) then
				return typeA.Rank > typeB.Rank

			elseif typeA.Rank == nil and typeB.Rank == nil then
				return (a.uiTypeID or 0) > (b.uiTypeID or 0)
			else
				return typeB.Rank == nil
			end
		end)
	end

	-- 添加左侧武学列表
	local iOwnMartialNum = 0
	if next(martial_list) then
		self.objNo_martial:SetActive(false)
		self.right_box:SetActive(true)
		local togFirst, dynDataFirst, typeDataFirst = nil, nil, nil
		local bCurChooseMatExist = false
		for k, v in pairs(martial_list) do
			local ui_clone = self:LoadGameObjFromPool(self.objListTemplate,self.objListContent.transform)
			ui_clone:SetActive(true)
			local objName = self:FindChild(ui_clone,"Name")
			local objNameFull = self:FindChild(ui_clone,"NameFull")
			local objLevel = self:FindChild(ui_clone,"Text_level")
			local comUIName_TMP = objName:GetComponent(l_DRCSRef_Type.Text)
			local comUINameFull_TMP = objNameFull:GetComponent(l_DRCSRef_Type.Text)
			local comUILevel_TMP = objLevel:GetComponent(l_DRCSRef_Type.Text)
			objName:SetActive(false)
			objNameFull:SetActive(false)
			objLevel:SetActive(false)

			local dynData		-- 动态数据
			local typeID		-- 静态ID
			local typeData		-- 静态数据
			local comName2Set = nil

			if self.type == 'Clan' then		-- 门派学武界面
				typeID = v
				objNameFull:SetActive(true)
				comUILevel_TMP.text = ""
				comName2Set = comUINameFull_TMP
			else							-- 角色界面
				dynData = v
				typeID = v.uiTypeID
				if dynData['uiLevel'] then
					comUILevel_TMP.text = string.format("%d级", dynData['uiLevel'])
				else
					comUILevel_TMP.text = "?级"
				end
				objName:SetActive(true)
				objLevel:SetActive(true)
				comName2Set = comUIName_TMP
			end
			if typeID then
				typeData = GetTableData("Martial",typeID)
			end
			if not typeData then
				derror("武学静态数据不存在,id=" .. typeID)
				return
			end

			if self.iCurMatBaseID and (self.iCurMatBaseID == typeID) then
				bCurChooseMatExist = true
			end

			comName2Set.text = GetLanguageByID(typeData.NameID)
			comName2Set.color = getRankColor(typeData.Rank)
			local comUIToggle = ui_clone:GetComponent(l_DRCSRef_Type.Toggle)
			comUIToggle.group = self.comListContent_TG
			if comUIToggle then
				if not togFirst then
					togFirst = comUIToggle
					dynDataFirst = dynData
					typeDataFirst = typeData
				end
				local fun = function(bool)
					if bool then
						self.comCurMatTog = comUIToggle
						self.iCurMatBaseID = typeID
						self:UpdateDetail(dynData, typeData)
					end
				end
				self:RemoveToggleClickListener(comUIToggle)
				comUIToggle.isOn = false
				self:AddToggleClickListener(comUIToggle, fun)
				table.insert(self.martial_toggle, comUIToggle)
			end

			if typeData.KFFeature ~= KFFeatureType.KFFT_AustrianMartialArts then
				iOwnMartialNum = iOwnMartialNum + 1
			end
		end

		-- 无论如何都要刷新detail
		-- 只有当前选中为空或者当前的选择被删除了的时候，会重新选择一个
		if self.comCurMatTog ~= nil and bCurChooseMatExist then
			self.comCurMatTog.isOn = true
			self:UpdateDetail(self.dynData, self.typeData)
		else
			if togFirst then
				togFirst.isOn = true
			end
			self:UpdateDetail(dynDataFirst, typeDataFirst)
		end

	else
		self.objNo_martial:SetActive(true)
		self.right_box:SetActive(false)
	end
	if self.type == 'Clan' then		-- 门派学武界面
        local curNum = RoleDataManager:GetInstance():GetRoleMartialNum()
		local maxNum = RoleDataManager:GetInstance():GetMartialNumMax()
		self.objMartial_num.gameObject:SetActive(true)
		self.Martial_num.text = string.format("我的武学：%d/%d",curNum, maxNum)		-- 武学数量
		self.Martial_num.gameObject:SetActive(true);
	else
		local mainRoleInfo = globalDataPool:getData("MainRoleInfo");
		local maxNum = RoleDataManager:GetInstance():GetMartialNumMax(self.selectRole) or 0
		self.objMartial_num.gameObject:SetActive(true)
		self.Martial_num.text = string.format("%d/%d",iOwnMartialNum, maxNum)		-- 武学数量
		self.Martial_num.gameObject:SetActive(true);

	end
end

-- 点击一个武学，刷新右侧列表：分动态和静态数据刷新
function MartialUIS:UpdateDetail(dynData, typeData)
	self.typeData = typeData;
	self.dynData = dynData;
	self:UpdateTitle(typeData)			-- 标题，标签，系别，门派
	self:UpdateExp(dynData, typeData)	-- 等级，经验条
	self:UpdateIcon(dynData, typeData)	-- 技能图标
	self:UpdateEntry(dynData, typeData)	-- 技能条目描述
	self:UpdateBtnForgottenMartial(dynData, typeData)
	self:UpdateBtnEquipMartial(dynData, typeData)	--出战与卸下
end

function MartialUIS:UpdateStrongMark(level)
	if self.objMartialStrong == nil then return end
	if self._oldStrongLevel and self._oldStrongLevel ~= level and self.objMartialStrong[self._oldStrongLevel] then
		self.objMartialStrong[self._oldStrongLevel]:SetActive(false)
	end
	self._oldStrongLevel = level
	if level and self.objMartialStrong[level] then
		self.objMartialStrong[level]:SetActive(true)
	else
		for k,v in pairs(self.objMartialStrong) do
			v:SetActive(false)
		end
	end
end
-- 更新右侧 / 标题，标签，系别，门派
function MartialUIS:UpdateTitle(typeData)
	if not typeData then return end
	self.comMartialTitle.text = GetLanguageByID(typeData.NameID)
	-- self.comMartialTitle.color = getRankColor(typeData.Rank)
	-- 先隐藏所有标签
	self.objTitleClassText:SetActive(false)
	self.objTitleClanText:SetActive(false)
	self.objTitleTagText:SetActive(false)
	self.objTitleInheritText:SetActive(false)
	-- 更新武学系别
	if typeData.DepartEnum then
		self.comTitleClassText.text = string.format("[%s]",GetEnumText("DepartEnumType", typeData.DepartEnum))
		self.objTitleClassText:SetActive(true)
	end
	-- 更新武学门派
	if typeData.ClanID then
		local clanTypeData = TB_Clan[typeData.ClanID]
		-- 需要过滤专属武学门派（门派ID 101），专属武学门派单独显示为红色标签
		if clanTypeData and typeData.ClanID ~= 101 then
			self.comTitleClanText.text = string.format("[%s]", GetLanguageByID(clanTypeData.NameID))
			self.objTitleClanText:SetActive(true)
		end
	end
	-- 经验
	if self.dynData then --学武界面只有静态数据
		self:UpdateStrongMark(self.dynData.iStrongLevel)
		self.exp_box:SetActive(true)
		local append = 1;
		self.comTextValue.text = (append * 100) .. '%'
		self.makeSecret:SetActive(true)
		if MartialDataManager:GetInstance():MartialCouldMake(typeData) then
			self.makeSecret:SetActive(true)
		else
			self.makeSecret:SetActive(false)
		end
	else
		self:UpdateStrongMark(nil)
		self.exp_box:SetActive(false)
		if self.makeSecret then
			self.makeSecret:SetActive(false)
		end
	end
	-- 标签
	if typeData.Exclusive and #typeData.Exclusive > 0 then
		self.comTitleTagText.text = GetLanguageByID(140093)
		self.objTitleTagText:SetActive(true)
		-- 可遗传标签
		local kRoleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
		if RoleDataManager:GetInstance():IsBabyRoleType(self.selectRole) or kRoleData.auiHeritMartial and #kRoleData.auiHeritMartial > 0 then
			local show = RoleDataManager:GetInstance():CanHeritMartial(self.selectRole,typeData.BaseID)
			self.objTitleInheritText:SetActive(show)
		else
			self.objTitleInheritText:SetActive(true)
		end
	end
end

-- 更新右侧 / 等级，经验条
function MartialUIS:UpdateExp(dynData, typeData)
	if GetGameState() == -1 then
		self.exp_box:SetActive(false);
		return
	end
	if not dynData or not typeData then						-- TODO：这里根据楼下版本，应该是全部隐藏的
		self.comExp_TMP.text = ""			-- 经验条
		self.comExpScrollbar.size = 0
		self.comLevel_TMP.text = ""
		self.comTextMartialTip.text = GetLanguageByID(typeData.DesID) or ""		-- TODO：显示学习武学的 Tips，最好移动到 ClanMartialUI 里面
		self.exp_box:SetActive(false);
		return
	end

	local TB_MartialExp = TableDataManager:GetInstance():GetTable("MartialExp")

	self.exp_box:SetActive(true);
	local exp_now = dynData['uiExp']  or 0
	local martial_level = dynData['uiLevel'] or 0
	local martial_rank = typeData['Rank'] or 0
	local string_rank = rank_enumtostr[martial_rank] or 0
	local exp_max = TB_MartialExp[martial_level][string_rank] or 0
	self.comExp_TMP.text = string.format("%d/%d", exp_now, exp_max)		-- 经验条
	self.comExpScrollbar.size = exp_now/exp_max
	--剧本内可以通过收藏页面突破提升武学等级上限
	local maxLevel = dynData['uiMaxLevel']
	self.comLevel_TMP.text = string.format("%d/%d级", dynData['uiLevel'], maxLevel)
end

-- 更新右侧 / 技能图标
function MartialUIS:UpdateIcon(dynData, typeData)
	self.array_skill_icons = {}
	local martialLevel = dynData and dynData['uiLevel']

	-- o_skill_技能 → 附加能力
	-- 技能解锁等级：附加能力[k].解锁等级 or 0
	-- 技能进化：每种绝学，都有解锁的条件，没解锁显示进化图标加锁，解锁了就替换基础图标（角色界面）或者在后面显示（门派界面）
	-- MartMovIDs 招式ID数组（固定有的技能，对应上面一块的技能栏）
	if typeData['MartMovIDs'] then
		for i = 1, #typeData['MartMovIDs'] do
			local miTypeData = MartialDataManager:GetInstance():GetMartialItemTypeData(typeData['MartMovIDs'][i])
			self:ParseMiToSkill( miTypeData, false, -1, i>1 )
		end
	end
	--进化的武学
	if dynData and typeData['UnlockLvls'] and typeData['UnlockClauses'] then
		for i = 1, #typeData['UnlockClauses'] do
			local isLock = true
			if dynData['iMartialUnlockItemSize'] then
				for j = 0,dynData['iMartialUnlockItemSize'] - 1 do
					if typeData['UnlockClauses'][i] == dynData['auiMartialUnlockItems'][j] then
						isLock = false
						break
					end
				end
			end
			local miTypeData = MartialDataManager:GetInstance():GetMartialItemTypeData(typeData['UnlockClauses'][i])
			self:ParseMiToSkill( miTypeData, isLock, typeData['UnlockLvls'][i], false)
		end
	end
	local iMinHeight = self.dataSCContentMinHeight
	-- 最后将填好的 Skill 数据 做成 图标
	if next(self.array_skill_icons) then
		self.skill_box:SetActive(true)
		self:ReturnUIClass()
		for k,v in pairs(self.array_skill_icons) do
			self:AddSkillIcon(v, dynData,typeData and typeData.BaseID)
		end

		if self.objEquipMartial and self.objUnEquipMartial then
			if self:IsEmbattleMartial(self.dynData['uiID']) == true then
				self.objEquipMartial:SetActive(false)
				self.objUnEquipMartial:SetActive(true)
			else
				self.objEquipMartial:SetActive(true)
				self.objUnEquipMartial:SetActive(false)
			end
		end
	else
		if self.objEquipMartial and self.objUnEquipMartial then
			self.objEquipMartial:SetActive(false)
			self.objUnEquipMartial:SetActive(false)
		end
		self.skill_box:SetActive(false)
		iMinHeight = iMinHeight + self.dataSkillboxHeight
	end
	self.comSCContentLayoutElement.minHeight = iMinHeight
end

function MartialUIS:ReturnUIClass()
	--[TODO] 如果后面 setparent开销太高，按LUA_CLASS_TYPE 分类，UI里自己再做一层缓存，不直接使用ReturnAllUIClass
	if #self.akItemUIClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akItemUIClass)
		self.akItemUIClass = {}
	end
end

-- 解析一个 MartialItemTypeData
function MartialUIS:ParseMiToSkill( miTypeData, isLock, UnlockLvl, isCombo )
	if not miTypeData then return end
	if miTypeData.EffectEnum1 then
		if miTypeData.EffectEnum1 == MartialItemEffect.MTT_ZHAOSHIJINENG then
			self:AddSkillNormal(miTypeData.SkillID1, isLock, UnlockLvl, isCombo)

		elseif miTypeData.EffectEnum1 == MartialItemEffect.MTT_JINENGJINGHUA then
			self:AddSkillEvolution(miTypeData.Effect1Value, miTypeData.CondID, isLock, UnlockLvl)
		end
	end
	if miTypeData.EffectEnum2 then
		if miTypeData.EffectEnum2 == MartialItemEffect.MTT_ZHAOSHIJINENG then
			self:AddSkillNormal(miTypeData.SkillID2, isLock, UnlockLvl, isCombo)

		elseif miTypeData.EffectEnum2 == MartialItemEffect.MTT_JINENGJINGHUA then
			self:AddSkillEvolution(miTypeData.Effect2Value, miTypeData.CondID, isLock, UnlockLvl)
		end
	end
end

-- 处理普通技能的 UI 更新
function MartialUIS:AddSkillNormal(skillID, isLock, unlockLvl, isCombo)
	local data = {
		['skillID'] = skillID,
		['isCombo'] = isCombo,
		['unlockLvl'] = unlockLvl,
		['isLock'] = isLock,
	}
	table.insert( self.array_skill_icons, data )
end

-- 处理技能进化的 UI 更新
function MartialUIS:AddSkillEvolution(effectArray, condID, isLock, unlockLvl)


	local beforeSkillID = effectArray[1]
	local afterSkillID = effectArray[2]
	local data = {
		['skillID'] = afterSkillID,
		['isCombo'] = false,
		['unlockLvl'] = unlockLvl,
		['isLock'] = isLock,
	}
	local bHas = false;
	if not isLock then
		for k,v in ipairs(self.array_skill_icons) do
			if v.skillID == beforeSkillID then
				self.array_skill_icons[k] = data
				bHas = true
				break
			end
		end
	end

	if not bHas then
		table.insert( self.array_skill_icons, data )
	end
end

function MartialUIS:UpdateBtnForgottenMartial(dynData, typeData)
	if GetGameState() == -1 then
		self.forgottenMartial:SetActive(false);
		self.makeSecret:SetActive(false);
		return
	end


	if dynData == nil or typeData == nil then
		self.forgottenMartial:SetActive(false)
		return
	end
	if typeData.KFFeature == KFFeatureType.KFFT_AustrianMartialArts then
		self.forgottenMartial:SetActive(false)
		return
	end

	self.forgottenMartial:SetActive(true)
	self.bool_state = false
	self.type = ForgottenMartialType.FMT_Null
	self.languageID = 0
end

function MartialUIS:UpdateBtnEquipMartial(dynData, typeData)

	if (self.objEquipMartial and self.objUnEquipMartial and dynData == nil or typeData == nil) or typeData.KFFeature == KFFeatureType.KFFT_AustrianMartialArts then
		self.objEquipMartial:SetActive(false)
		self.objUnEquipMartial:SetActive(false)
		return
	end
end

function MartialUIS:IsEmbattleMartial(id)
	local martialList = globalDataPool:getData("EmbattleMartial")
	local info = martialList[self.selectRole]
	if not info then return false end
	for index, kSkillInfo in pairs(info) do
		if kSkillInfo['dwUID'] == id then
			return true
		end
	end
	return false
end

function MartialUIS:CheckMainRole_WANGYOUCAO()
	local type = ForgottenMartialType.FMT_Null
	local mainRoledata = RoleDataManager:GetInstance():GetMainRoleData()
	if mainRoledata then
		local roleLevel = mainRoledata.uiLevel or 0
		if roleLevel >= GetCommonConfig("ForgetMartialFreeLv") then
      --忘忧草数量
      local itemnum = PlayerSetDataManager:GetInstance():GetPlayerWangyoucao()
			if itemnum > 0 then
				type = ForgottenMartialType.FMT_MAINROLE_USEITEM
			else
				type = ForgottenMartialType.FMT_NOITEM
			end
		else
			type = ForgottenMartialType.FMT_MAINROLE_FREE
		end
	end
	return type
end

function MartialUIS:CheckTeammate_WANGYOUCAO(uiRoleUID)
	local bool_state = false
  local type = ForgottenMartialType.FMT_Null
  local itemnum = PlayerSetDataManager:GetInstance():GetPlayerWangyoucao()
	if itemnum > 0 then
		--忘忧草数量
		type = ForgottenMartialType.FMT_TEAMMATR_USEITEM
	else
		type = ForgottenMartialType.FMT_NOITEM
	end
	return type
end

function MartialUIS:MakeSecret()
	local itemnum = PlayerSetDataManager:GetInstance():GetMakeMartialSecretBook()
	if itemnum == 0 then -- 银锭通用弹窗
		-- 没有武学空白书的toast
		-- DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, GetLanguageByID(730005), false)
		callback = function()
			CommonSpendSliverWindow(GetCommonConfig("MakeSecretCostSilver"),function()
				SendClickMakeMartialSecret(self.dynData.uiID)
			end)
		end

		local showContent = {
            ['title'] = GetLanguageByID(730006),
            ['text'] = GetLanguageByID(730007),
            ['btnType'] = "silver",
            ['num'] = GetCommonConfig("MakeSecretCostSilver") or 500,
			['btnText'] = GetLanguageByID(730008),
			['btnColor'] = 'green',
        }
		OpenWindowImmediately('GeneralBoxUI', {
			GeneralBoxType.Pay_TIP,
			showContent,
			callback
		})
	else -- 确定弹框
		local s_tips = string.format(GetLanguageByID(730009), GetLanguageByID(self.typeData.NameID))
		-- 空白武学书道具ID
		local content = {
			["title"] = "提示",
			["text"] = s_tips,
			["ItemID"] = ID_ITEM_MakeMartialSceret,
			["ItemNum"] = itemnum,
			["ItemCost"] = 1,
		}

		callback = function()
			SendClickMakeMartialSecret(self.dynData.uiID)
		end
		OpenWindowImmediately('GeneralBoxUI', {
			GeneralBoxType.COSTITEM_TIP,
			content,
			callback
		})
	end
end

-- 遗忘武学
function MartialUIS:ForgottenMartial()
	--todo: 等级以及忘忧草判断
	--提示框
	--①主角在15级以及以下的时候，被允许无任何代价遗忘任何武学（包括暗金）
	--②其他角色或者主角到达15级以上后，玩家只能通过忘忧草来遗忘对应的武学，玩家的背包和仓库中必须拥有忘忧草
	local callback

	-- 检测当前武学是不是最后一个
	local uiRoleUID = self.dynData.uiRoleUID
	local akOwnMartial = MartialDataManager:GetInstance():GetRoleMartial(uiRoleUID)
	if getTableSize2(akOwnMartial) == 1 then
		DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, "至少需要保留一个武学!")
		return
	end
	local exContent = ""
	local typeData = GetTableData("Martial",self.dynData.uiTypeID)
	if typeData and typeData.Exclusive and #typeData.Exclusive > 0 then
		exContent = "\n" .. GetLanguageByID(140094)
	end

	local uiMainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
	if uiRoleUID == uiMainRoleID then
		self.type = self:CheckMainRole_WANGYOUCAO()
	else
		self.type = self:CheckTeammate_WANGYOUCAO(uiRoleUID)
	end

	if self.type ==  ForgottenMartialType.FMT_MAINROLE_FREE then
		self.languageID = 418

		callback = function()
			self:NetGameCmdSend()
		end
		OpenWindowImmediately('GeneralBoxUI', {
			GeneralBoxType.COMMON_TIP,
			string.format(GetLanguageByID(self.languageID), GetLanguageByID(self.typeData.NameID)) .. exContent,
			callback
		})
	elseif self.type ==  ForgottenMartialType.FMT_MAINROLE_USEITEM
		or self.type ==  ForgottenMartialType.FMT_TEAMMATR_USEITEM then
		self.languageID = 417
		local s_tips = string.format(GetLanguageByID(self.languageID), GetLanguageByID(self.typeData.NameID)) .. exContent
		-- 显示当前道具
		local itemnum = PlayerSetDataManager:GetInstance():GetPlayerWangyoucao()
		local ID_WANGYOUCAO = 9626
		local content = {
			["title"] = "提示",
			["text"] = s_tips,
			["ItemID"] = ID_WANGYOUCAO,
			["ItemNum"] = itemnum,
			["ItemCost"] = 1,
		}

		callback = function()
			self:NetGameCmdSend()
		end
		OpenWindowImmediately('GeneralBoxUI', {
			GeneralBoxType.COSTITEM_TIP,
			content,
			callback
		})
	elseif self.type ==  ForgottenMartialType.FMT_NOITEM then
		SystemUICall:GetInstance():Toast("忘忧草不足")
		-- self.languageID = 419
		-- DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, GetLanguageByID(self.languageID), false)

		-- callback = function()
		-- 	CommonSpendSliverWindow(GetCommonConfig("ForgetMartialCostSilver"),function()
		-- 		self:NetGameCmdSend()
		-- 	end)
		-- end

		-- local showContent = {
        --     ['title'] = '忘忧草不足',
        --     ['text'] = string.format('\n\n忘忧草数量不足,继续遗忘武学将以每个忘忧草%d银锭的价格消耗银锭',GetCommonConfig("ForgetMartialCostSilver") or 999999) .. exContent,
        --     ['btnType'] = "silver",
        --     ['num'] = GetCommonConfig("ForgetMartialCostSilver") or 999999,
		-- 	['btnText'] = '继续遗忘',
		-- 	['btnColor'] = 'green',
        -- }
		-- --会弹出对应的购买忘忧草界面
		-- OpenWindowImmediately('GeneralBoxUI', {
		-- 	GeneralBoxType.Pay_TIP,
		-- 	showContent,
		-- 	callback
		-- })
	end
end

function MartialUIS:NetGameCmdSend()
	local uiRoleUID = self.dynData.uiRoleUID
	local uiMartialTypeID = self.dynData.uiTypeID
	local data = EncodeSendSeGC_ClickForgetMartial(uiRoleUID, uiMartialTypeID)
	local iSize = data:GetCurPos()
	NetGameCmdSend(SGC_CLICK_ROLE_MARTIAL_FORGET, iSize, data)
end

-- 一个需要添加技能的模板
local data_example = {
	['skillID'] = 0,		-- 是绝招 或者奥义，在 SkillIcon 里判断。被动/连招 技能不管
	['isCombo'] = false,	-- 有些连招技能是 战斗里打 combo 会放，要显示连招线的都是基础技能里的
	['isLock'] = false,		-- 是否有锁，包括等级条件 和 其他解锁条件（天赋）
	['unlockLvl'] = 0,		-- 当是等级条件解锁的时候，显示多少级解锁	-- MartialItem 对应技能图标，等级不到，要显示锁+多少级
}

-- 在这里真正创建一个 Skill 的图标，并填入数据
function MartialUIS:AddSkillIcon(iconData, dynData, martialBaseID)
	local itemClass
	if self.parentType == 'Character' then
		dprint("It's in CharacterUI")
		itemClass = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.SkillIconUIS,self.skill_box_content.transform)
	else
	 	itemClass = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.SkillIconUI,self.skill_box_content.transform)
	end
	-- if self.parentType == 'Character' then
	-- 	itemClass.transform.localScale= DRCSRef.Vec3(2/3,2/3,2/3)
	-- 	-- local rectItemClass =  itemClass._gameObject:GetComponent("RectTransform")
	-- 	-- SetUIAxis(itemClass._gameObject,rectItemClass.rect.width/3 * 2,rectItemClass.rect.height/3 * 2)
	-- end
	local coldTime = (dynData or {})['uiColdTime']
	itemClass:UpdateUI(iconData['skillID'], iconData['isCombo'], iconData['isLock'], iconData['unlockLvl'], coldTime, martialBaseID)
	-- itemClass:SetTipsValue(dynData,iconData['skillID'],nil, function()
	-- 	if not (self and self.kSkillEmbatteState) then
	-- 		return
	-- 	end
	-- 	local tarSkill = dynData
	-- 	if not (tarSkill and tarSkill.uiID) then

	-- 		return
	-- 	end
	-- 	local iState = self.kSkillEmbatteState[tarSkill.uiID]
	-- 	local strName = nil
	-- 	local func = nil
	-- 	if iState and (iState > 0) then
	-- 		strName = dtext(1003)
	-- 	else
	-- 		strName = dtext(1004)
	-- 		func = function()
	-- 			-- 上阵，发送服务器信息
	-- 			self:OnClick_Embattle_Skill(iconData, dynData)
	-- 		end
	-- 	end
	-- 	return {{
	-- 		['name'] = strName,
	-- 		['func'] = func,
	-- 	}}
	-- end, martialBaseID)
	if  self.parentType == 'Clan' then
		itemClass.parentType = 'Clan'
	elseif self.parentType == 'Character' then
		itemClass.parentType = 'Character'
	end
	itemClass:SetTipsValue(dynData,iconData['skillID'],nil, nil, martialBaseID)	
	self.akItemUIClass[#self.akItemUIClass + 1] = itemClass
end

-- 更新右侧 / 技能条目描述
function MartialUIS:UpdateEntry(dynData, typeData)
	self:ClearMartialItemTips()
	-- 对于条目栏
	-- MartialItem 等级和条件都满足 才是 橙色激活，否则是灰色
	-- 还有部分，是隐藏的技能，等级没到的时候 显示灰色 ？？？
	local descs = MartialDataManager:GetInstance():GetMartialItemsDesc(typeData, dynData) or {}
	for index, data in ipairs(descs) do
		local ui_clone =   self:LoadGameObjFromPool(self.objDetail_template,self.objDetail_content.transform)
		-- 更新前缀
		local prefix = data.prefix
		local comlabel = self:FindChild(ui_clone,"Label")
		local textComlabel = comlabel:GetComponent(l_DRCSRef_Type.Text)
		if prefix == "" then
			comlabel:SetActive(false)
		else
			comlabel:SetActive(true)
			textComlabel.text = prefix
			textComlabel.color = data.color
		end
		-- 更新条目信息
		local objtext = self:FindChildComponent(ui_clone, "Text", l_DRCSRef_Type.Text)
		objtext.color = data.color
		objtext.text = data.desc
		-- 更新条目标记
		local state = data.state
		if state == "achieve" then
			local comImage = self:FindChildComponent(ui_clone,"Icon_unlock", l_DRCSRef_Type.Image)
			comImage.color = COLOR_VALUE[COLOR_ENUM.Douzi_brown]
		end
		-- 设置条目显示
		ui_clone:SetActive(true)
	end

	-- 奥义特殊处理
	if typeData.KFFeature == KFFeatureType.KFFT_AustrianMartialArts then
		local TB_AoYi = TableDataManager:GetInstance():GetTable("AoYi")
		for k, v in pairs(TB_AoYi) do
			if v.AoYiID == typeData.BaseID then
				local ui_clone = self:LoadGameObjFromPool(self.objDetail_template,self.objDetail_content.transform)
				local desc = string.format('本奥义仅第%.0f回合可用,组成公式：\n', v.EffectiveRound);
				for i = 1, #v.MartialList do
					local martialID = v.MartialList[i];
					local martialLV = v.LVList[i];
					local martialData = GetTableData("Martial",martialID)
					desc = string.format('%s《%s》%.0f级\n', desc, GetLanguageByID(martialData.NameID), martialLV);
				end

				desc = desc .. '奥义等级上限，等于以上武学中等级上限的最低者'

				self:FindChild(ui_clone, "Icon_unlock"):SetActive(false);
				self:FindChild(ui_clone, "Label"):SetActive(false);

				-- 更新条目信息
				local objtext = self:FindChildComponent(ui_clone, "Text", l_DRCSRef_Type.Text)
				objtext.text = desc;
				objtext.color = DRCSRef.Color(0, 0, 0, 0.8)

				ui_clone:SetActive(true);
			end
		end

    end

	-- 重新调整一下自适应
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.objDetail_content.transform)
end


function MartialUIS:OnDestroy()
	self:ClearToggle()
	self:ClearMartialItemTips()
	self:ReturnUIClass()
	if self.embattleSkillIconClass and #self.embattleSkillIconClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.embattleSkillIconClass)
	end
	if self.AIUICom then
		self.AIUICom:OnDestroy()
	end
	RemoveEventTrigger(self.objRaycast)
end

function MartialUIS:OnClose()
	if self.AIUI and self.IsAI then
		self.mbox:SetActive(true)
		self.AIUI:SetActive(false)
		self.AIUICom:OnClose()
		self.IsAI = false
		self.CharacterUI:ResetMode()
		self:UpdateStratergy()
	end
end

function MartialUIS:ShowAI(show)
	self.btnAI:SetActive(show)
end

function MartialUIS:UpdateStratergy()
	if self.btnAI and self.selectRole then
		self.btnAIText.text = BattleAIDataManager:GetInstance():GetRoleBattleStrategy(self.selectRole)
	end
end

return MartialUIS
