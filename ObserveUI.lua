ObserveUI = class("ObserveUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local array_attr_revert ={
	[AttrType.ATTR_MAXHP] = 'HP',
	[AttrType.ATTR_MAXMP] = 'MP',
	[AttrType.ATTR_LIDAO] = 'Strength',
	[AttrType.ATTR_LINGQIAO] = 'Agility',
	[AttrType.ATTR_JINGLI] = 'Energy',
	[AttrType.ATTR_TIZHI] = 'Constitution',
	[AttrType.ATTR_WUXING] = 'Comprehension',
	[AttrType.ATTR_NEIJIN] = 'Power',
	[AttrType.ATTR_JIANFAJINGTONG] = 'SwordMastery',
	[AttrType.ATTR_DAOFAJINGTONG] = 'KnifeMastery',
	[AttrType.ATTR_QUANZHANGJINGTONG] = 'FistMastery',
	[AttrType.ATTR_TUIFAJINGTONG] = 'LegMastery',
	[AttrType.ATTR_QIMENJINGTONG] = 'StickMastery',
	[AttrType.ATTR_ANQIJINGTONG] = 'NeedleMastery',
	[AttrType.ATTR_YISHUJINGTONG] = 'HealingMastery',
	[AttrType.ATTR_NEIGONGJINGTONG] = 'SoulMastery',
	[AttrType.ATTR_CRITATK] = 'Crits',
	[AttrType.ATTR_HITATK] = 'Hits',
	[AttrType.ATTR_CONTINUATK] = 'Continu',
	[AttrType.ATTR_NEILIYANGXING] = 'YangXing',
	[AttrType.ATTR_NEILIYINXING] = 'YinXing',
	[AttrType.ATTR_DEF] = 'Defense',
	[AttrType.ATTR_MARTIAL_ATK] = 'MartialATK',
	[AttrType.ATTR_SUDUZHI] = 'Speed',
	[AttrType.ATTR_XINGDONGJIANGE] = 'ActionInterval',
	[AttrType.ATTR_BAOSHANGZHI]   = "baoshang",
	[AttrType.ATTR_LIANZHAOLV]    = "lianzhaolv",
	[AttrType.ATTR_IGNOREDEFPER]   = "ignoreDefense",
	[AttrType.ATTR_HEJILV]        = "hejilv",
	[AttrType.ATTR_SHANBI]            = "shanbi",
	[AttrType.ATTR_BAOJIDIKANGZHI]    = "baojidikang",
	[AttrType.ATTR_KANGLIANJI]        = "kanglianji",
	[AttrType.ATTR_FANJIZHI]   = "fanji",
	[AttrType.ATTR_POZHAOVALUE]   = "pozhao",
	[AttrType.ATTR_FANTANVALUE]          = "fantan",
	[AttrType.ATTR_ROUNDMP]           = "roundMP",
	[AttrType.ATTR_FANGYUTISHENGLV]   = "fangyutishenglv",
	[AttrType.ATTR_SUCKHP]            = "suckHP",
	[AttrType.ATTR_ZHILIAOXIAOGUO]    = "zhiliaoxiaoguo",
	[AttrType.ATTR_FANTANBEISHU]      = "fantanbeishu",
	[AttrType.ATTR_ZHONGDUKANGXING]   = "zhongdukangxing",
	[AttrType.ATTR_LIUXUEKANGXING]    = "liuxuekangxing",
	[AttrType.ATTR_POJIAKANGXING]     = "pojiakangxing",
	[AttrType.ATTR_JIANSUKANGXING]    = "jiansukangxing",
	[AttrType.ATTR_NEISHANGKANGXING]  = "neishangkangxing",
	[AttrType.ATTR_CANFEIKANGXING]    = "canfeikangxing",
}
local array_attr = {
    {[AttrType.ATTR_HITATK]        = "命中"},
    {[AttrType.ATTR_CRITATK]       = "暴击"},
    {[AttrType.ATTR_CONTINUATK]    = "连击"},
    {[AttrType.ATTR_BAOSHANGZHI]   = "暴伤"},
    {[AttrType.ATTR_LIANZHAOLV]    = "连招率"},
    {[AttrType.ATTR_IGNOREDEFPER]   = "忽视防御率"}, -- 防御削减率 = 忽视防御率
    {[AttrType.ATTR_HEJILV]        = "合击率"},
    {[AttrType.ATTR_NEILIYANGXING] = "内力阳性"},
    {[AttrType.ATTR_NEILIYINXING]  = "内力阴性"},
    {[AttrType.ATTR_SHANBI]            = "闪避"},
    {[AttrType.ATTR_BAOJIDIKANGZHI]    = "暴击抵抗"},
    {[AttrType.ATTR_KANGLIANJI]        = "抗连击"},
    {[AttrType.ATTR_FANJIZHI]   = "反击"},
    {[AttrType.ATTR_POZHAOVALUE]   = "破招"},
    {[AttrType.ATTR_FANTANVALUE]          = "反弹"},
    -- {[AttrType.ATTR_ROUNDHP]           = "回合恢复生命"},
    {[AttrType.ATTR_ROUNDMP]           = "回合回真气"},
    -- {[AttrType.ATTR_MAX_NUM]   = "体质转生命值"},
    {[AttrType.ATTR_FANGYUTISHENGLV]   = "防御提升率"},
    {[AttrType.ATTR_SUCKHP]            = "吸血率"},
    {[AttrType.ATTR_ZHILIAOXIAOGUO]    = "治疗效果"},
    {[AttrType.ATTR_FANTANBEISHU]      = "反弹倍数"},
    {[AttrType.ATTR_ZHONGDUKANGXING]   = "中毒抗性"},
    {[AttrType.ATTR_LIUXUEKANGXING]    = "流血抗性"},
    {[AttrType.ATTR_POJIAKANGXING]     = "破甲抗性"},
    {[AttrType.ATTR_JIANSUKANGXING]    = "减速抗性"},
    {[AttrType.ATTR_NEISHANGKANGXING]  = "内伤抗性"},
    {[AttrType.ATTR_CANFEIKANGXING]    = "残废抗性"},
}

local weekLimitValue = {
    [AttrType.ATTR_HITATKPER]               ="HitRate",
    [AttrType.ATTR_SHANBILV]                ="MissRate",
    [AttrType.ATTR_CRITATKPER]              ="CritRate",
    [AttrType.ATTR_BAOJIDIKANGLV]           ="CritDefenseRate",
    [AttrType.ATTR_CRITATKTIME]             ="CritTimes",
    [AttrType.ATTR_CONTINUATKPER]           ="RepeatRate",
    [AttrType.ATTR_LIANZHAOLV]              ="LianZhaoRate",
    [AttrType.ATTR_HEJILV]                  ="JointAttackRate",
    [AttrType.ATTR_IGNOREDEFPER]            ="PenetrateDefenseRate",
    [AttrType.ATTR_KANGLIANJILV]            ="AntiHitRate",
    [AttrType.ATTR_POZHAOLV]                ="PoZhaoRate",
    [AttrType.ATTR_FANJILV]                 ="CounterAttackRate",
    [AttrType.ATTR_SUCKHP]                  ="BloodSuckRate",
    [AttrType.ATTR_FANTANLV]                ="ReboundRate",
    [AttrType.ATTR_FANTANBEISHU]            ="Rebound",
    [AttrType.ATTR_YUANHULV]                ="AidRate",
    [AttrType.ATTR_JUEZHAOLV]               ="UniqueSkillRate",
}

-- 角色通用属性 (一般直接获取)
local l_roleCommonAttr = {
	[1] = { attrName = "Level", attrChName = "等级"},
	[2] = { attrName = "GoodEvil", attrChName = "仁义"},
	[3] = { attrName = "Clan", attrChName = "门派"},
	--[4] = { attrName = "HP", attrChName = "生命"},
	--[5] = { attrName = "MP", attrChName = "真气"},
	[4] = { attrName = "Favor", attrChName = "喜好"}
}

-- 角色实例属性 (需要计算)
local l_roleInstAttr = {
	--[1] = { attrName = "Defense", attrChName = "防御"},
	[1] = { attrName = "SwordMastery", attrChName = "剑法精通"},
	[2] = { attrName = "KnifeMastery", attrChName = "刀法精通"},
	[3] = { attrName = "FistMastery", attrChName = "拳掌精通"},
	[4] = { attrName = "LegMastery", attrChName = "腿法精通"},
	[5] = { attrName = "StickMastery", attrChName = "奇门精通"},
	[6] = { attrName = "NeedleMastery", attrChName = "暗器精通"},
	[7] = { attrName = "HealingMastery", attrChName = "医术精通"},
	[8] = { attrName = "SoulMastery", attrChName = "内功精通"},
	--[10] = { attrName = "MartialATK", attrChName = "攻击"},
}

local l_roleHpMpAttr = {
	[1] = { attrName = "HP", attrChName = "生命"},
	[2] = { attrName = "MP", attrChName = "真气"},
	[3] = { attrName = "Speed", attrChName = "速度"},
}

local l_roleDefenseAttacakAttr = {
	[1] = { attrName = "MartialATK", attrChName = "攻击"},
	[2] = { attrName = "Defense", attrChName = "防御"},
	[3] = { attrName = "ActionInterval", attrChName = "行动间隔"},
}

local temp_battle_factor

function ObserveUI:ctor()
	temp_battle_factor = TableDataManager:GetInstance():GetTableData("BattleFactor",1)
end

function ObserveUI:Create()
	local obj = LoadPrefabAndInit("Interactive/ObserveUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ObserveUI:Init()
	self.akDispositionItemUIClass = {}
	self.akEquipmentItemUIClass = {}
	self.ItemIconUI = ItemIconUI.new()
    self.comReturn_Button = self:FindChildComponent(self._gameObject,"Back_Button","Button")
	if self.comReturn_Button then
		local fun = function()
			self:OnClick_Return_Town_Button()
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
	end

	self.comCloseButton = self:FindChildComponent(self._gameObject, 'frame/Btn_exit', 'Button')
	if self.comCloseButton then
		self:AddButtonClickListener(self.comCloseButton,function()
			if self.callback then
				self.callback();
			end
			RemoveWindowImmediately("ObserveUI")
			DisplayActionEnd()
		end)
	end

	self.btnGiftTips = self:FindChildComponent(self._gameObject, "gift_box/Button_question", "Button")
	self:AddButtonClickListener(self.btnGiftTips, function()
		self:ShowGiftTips()
	end)

	self.btnMartialTips = self:FindChildComponent(self._gameObject, "martial_box/Button_question", "Button")
	self:AddButtonClickListener(self.btnMartialTips, function()
		self:ShowMartialTips()
	end)

	self.objDRButton_left = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/DRButton_left", 'DRButton')
	self:AddButtonClickListener(self.objDRButton_left, function()
		self:OnClick_DRButton_left()
	end)
	self.objDRButton_right = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/DRButton_right", 'DRButton')
	self:AddButtonClickListener(self.objDRButton_right, function()
		self:OnClick_DRButton_right()
	end)

	self.objFavorBox = self:FindChild(self._gameObject, "Favor_box")

	self.comRoleImage = self:FindChildComponent(self._gameObject, "G_CG", "Image")
	self.objCreateCGParent = self:FindChild(self._gameObject, "Mask_CG/CreateCG")

	self.comRoleName = self:FindChildComponent(self._gameObject, "G_RoleName", "Text")

	self.objbackpack_info = self:FindChild(self._gameObject, "backpack_info")

	self.objbackpack_box = self:FindChild(self.objbackpack_info, "backpack_box")
	self.objbackpack_icon = self:FindChild(self.objbackpack_info, "backpack_icon")
	self.objnosee_txt = self:FindChild(self.objbackpack_info, "nosee_txt")

	self.objState_info = self:FindChild(self._gameObject, "Content/Right/state_info")
	self.objStateScrollRect = self:FindChild(self.objState_info, "ScrollRect")
	self.txtStateContnet = self:FindChild(self.objState_info, "ScrollRect/ViewPort/ContentText")
	self.objStatenosee_txt = self:FindChild(self.objState_info, "nosee_txt")
	self.objState_info:SetActive(false)

	self.objBackpackContent = self:FindChild(self._gameObject, "backpack_info/backpack_box/Content")

	self.transEquipContent = {}
	for index = 1, 8 do
		local objRoot = self:FindChild(self._gameObject, "equipment_box/equip_bgicon/")
		local obj = self:FindChild(objRoot, index)
		if obj then
			self.transEquipContent[index]  = obj.transform
		end
	end

	self.objGiftContent = self:FindChild(self._gameObject, "gift_box/Viewport/Content")

	self.objMartialsContent = self:FindChild(self._gameObject, "martial_box/Viewport/Content")
	self.obGiftItem = self:FindChild(self._gameObject, "Content/Left/kungfu_box/martial_box/Gift_Text")
	self.obGiftItem:SetActive(false)

	self.objAttrBox_1 = self:FindChild(self._gameObject, "G_AttrBox_1")
	self.objAttrBox_2 = self:FindChild(self._gameObject, "G_AttrBox_2")
	self.objAttrBox_3 = self:FindChild(self._gameObject, "G_AttrBox_3")
	self.objAttrBox_4 = self:FindChild(self._gameObject, "G_AttrBox_4")

	self.objAttrBox1Item = {}
	self.objAttrBox2Item = {}
	self.objAttrBox3Item = {}
	self.objAttrBox4Item = {}

	for i = 1, #l_roleCommonAttr do
		local objText = self:FindChild(self.objAttrBox_1, i)
		local comTextName = self:FindChildComponent(objText, "Label", "Text")
		local comTextValue = self:FindChildComponent(objText, "Value", "Text")
		local comTextValue2 = self:FindChildComponent(objText, "Value2", "Text")
		self.objAttrBox1Item[i] = {comTextName,comTextValue,comTextValue2}
	end

	for i = 1, #l_roleHpMpAttr do
		local objText = self:FindChild(self.objAttrBox_2, i)
		local comTextName = self:FindChildComponent(objText, "Label", "Text")
		local comTextValue = self:FindChildComponent(objText, "Value", "Text")
		local comTextValue2 = self:FindChildComponent(objText, "Value2", "Text")
		self.objAttrBox2Item[i] = {comTextName,comTextValue,comTextValue2}
	end

	for i = 1, #l_roleDefenseAttacakAttr do
		local objText = self:FindChild(self.objAttrBox_3, i)
		local comTextName = self:FindChildComponent(objText, "Label", "Text")
		local comTextValue = self:FindChildComponent(objText, "Value", "Text")
		--local comTextValue2 = self:FindChildComponent(objText, "Value2", "Text")
		self.objAttrBox3Item[i] = {comTextName,comTextValue}
	end

	for i = 1, #l_roleInstAttr do
		local objText = self:FindChild(self.objAttrBox_4, i)
		local comTextName = self:FindChildComponent(objText, "Label", "Text")
		local comTextValue = self:FindChildComponent(objText, "Value", "Text")
		self.objAttrBox4Item[i] = {comTextName,comTextValue}
	end

	self.objChain = self:FindChild(self._gameObject, "G_ChainContent").transform
	self.objChainBox = self:FindChild(self._gameObject, "chain_box")
	self.chain_box = self:FindChild(self._gameObject, "chain_box/Viewport")
	self.chain_box_nosee_txt = self:FindChild(self._gameObject, "chain_box/nosee_txt")

	self.objAttrBox = self:FindChild(self._gameObject, "attribute_box")
	self.comAttrBoxContent = self:FindChildComponent(self.objAttrBox, "Viewport/Content","Transform")

	self.needUpdateDispositions = false
	self:AddEventListener("UPDATE_DISPOSITION", function()
		self.needUpdateDispositions = true
	end)
end

function ObserveUI:OnPressESCKey()
	if self.comCloseButton then
		self.comCloseButton.onClick:Invoke()
	end
end
function ObserveUI:OnClick_DRButton_left()
	if self.roleData.index > 1 then
		self.roleData.index = self.roleData.index - 1;
		self:RefreshUI(self.roleData);
		if self.roleData.index == 1 then
			self.objDRButton_left.gameObject:SetActive(false);
		end
	end
end

function ObserveUI:OnClick_DRButton_right()
	if self.roleData.index < #(self.roleData.roleIDs) then
		self.roleData.index = self.roleData.index + 1;
		self:RefreshUI(self.roleData);
		if self.roleData.index == #(self.roleData.roleIDs) then
			self.objDRButton_right.gameObject:SetActive(false);
		end
	end
end

function ObserveUI:OnClick_Return_Town_Button()
	OpenWindowImmediately("LoadingUI")
	ChangeScenceImmediately("House","LoadingUI",function()
		OpenWindowImmediately("HouseUI")
	end)
	DisplayActionEnd()
end

function ObserveUI:Update()
	-- 刷新关系链显示
	if self.needUpdateDispositions then
		self.needUpdateDispositions = false
		if not self.roleData then
			return
		end

		local roleData = self.roleData
		local roleID = roleData.roleID
		local isBattleUnit = roleData.roleType == ROLE_TYPE.BATTLE_ROLE
		local isInTown = GetGameState() == -1;
		
		if roleID and not isBattleUnit and not isInTown then
			self:RefreshDispositions(roleID, isBattleUnit, isInTown)
		end
	end
end

function ObserveUI:OnDestroy()
	self.ItemIconUI:Close()
	self:ReturnUIClass()
end

function ObserveUI:RefreshAttr(roleData, dbRoleData)

	if roleData.roleType == ROLE_TYPE.NPC_ROLE or roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
		roleData:UpdateAttr();
	end

	local attr = {};
	if self.objAttrBox_4 then
		for index, attrInfo in ipairs(l_roleInstAttr) do
			local comTextName = self.objAttrBox4Item[index][1]
			local comTextValue = self.objAttrBox4Item[index][2]
			local attrName = attrInfo.attrName
			local attrChName = attrInfo.attrChName
			comTextName.text = attrChName

			local baseAttr = RoleDataHelper.GetAttr(roleData, dbRoleData, attrName);
			if roleData.roleType == ROLE_TYPE.NPC_ROLE or roleData.roleType == ROLE_TYPE.HOUSE_ROLE then

				local value = RoleDataHelper.GetObserveAttr(roleData, dbRoleData, attrName)

				comTextValue.text = math.floor(value);
				attr[AttrType_Revert[attrChName]] = math.floor(value);
			else
				comTextValue.text = math.floor(baseAttr + 0.5);
			end
		end
	end

	local convert = {};
	RoleDataHelper.GetConvertAttr(attr, roleData:GetLevel());

	if self.objAttrBox_1 then
		for index, attrInfo in ipairs(l_roleCommonAttr) do
			local comTextName = self.objAttrBox1Item[index][1]
			local comTextValue = self.objAttrBox1Item[index][2]
			local comTextValue2 = self.objAttrBox1Item[index][3]
			local attrName = attrInfo.attrName
			local attrChName = attrInfo.attrChName
			comTextName.text = attrChName
			local text = RoleDataHelper.GetAttr(roleData, dbRoleData, attrName)
			text = text ~= '' and text or '无'
			if attrName == 'Favor' then
				comTextValue2.text = text
				comTextValue.gameObject:SetActive(false)
				comTextValue2.gameObject:SetActive(true)
			else
				
				local _func = function(attrType)
					local value = 0;
					for k, v in pairs(convert) do
						for kk, vv in pairs(v) do
							if kk == attrType then
								value = value + vv;
							end
						end
					end	
					return value;
				end

				if roleData.roleType == ROLE_TYPE.NPC_ROLE or roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
					local _getAttr = function(eAttr)
						local cardLevelAttrs = roleData:GetAttrByCardLevel();
						local convCardLevelAttrs = roleData:GetConvAttrByCardLevel();
						local baseAttrs = roleData:GetAttrByTBData();
						local convBaseAttrs = roleData:GetConvAttrByTBData();
						local martialAttrs = roleData:GetAttrByMartials();
						local convMartialAttrs = roleData:GetConvAttrByMartials();
						local equipAttrs = roleData:GetAttrByEquips();
						local convEquipAttrs = roleData:GetConvAttrByEquips();
						local titleAttrs = roleData:GetAttrByTitle();
						local convTitleAttrs = roleData:GetConvAttrByTitle();
						local meridiansAttrs = {};
						local convMeridiansAttrs = {};
						if roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
							meridiansAttrs = roleData:GetAttrByMeridians();
							convMeridiansAttrs = roleData:GetConvAttrByMeridians();
						end

						local fixGiftAttrs = roleData:GetFixAttrByGifts();
						local perGiftAttrs = roleData:GetPerAttrByGifts();
						local conGiftAttrs = roleData:GetConAttrByGifts();
						local convFixGiftAttrs = roleData:GetFixConvAttrByGifts();
						local convPerGiftAttrs = roleData:GetPerConvAttrByGifts();
						local convConGiftAttrs = roleData:GetConConvAttrByGifts();
		
						local cardLevelAttr = RoleDataHelper.GetAttrByType(cardLevelAttrs, eAttr);
						local convCardLevelAttr = RoleDataHelper.GetAttrByType(convCardLevelAttrs, eAttr);
						local baseAttr = RoleDataHelper.GetAttrByType(baseAttrs, eAttr);
						local convBaseAttr = RoleDataHelper.GetAttrByType(convBaseAttrs, eAttr);
						local martialAttr = RoleDataHelper.GetAttrByType(martialAttrs, eAttr);
						local convMartialAttr = RoleDataHelper.GetAttrByType(convMartialAttrs, eAttr);
						local equipAttr = RoleDataHelper.GetAttrByType(equipAttrs, eAttr);
						local convEquipAttr = RoleDataHelper.GetAttrByType(convEquipAttrs, eAttr);
						local titleAttr = RoleDataHelper.GetAttrByType(titleAttrs, eAttr);
						local convTitleAttr = RoleDataHelper.GetAttrByType(convTitleAttrs, eAttr);
						local meridiansAttr = 0;
						local convMeridiansAttr = 0;
						if roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
							meridiansAttr = RoleDataHelper.GetAttrByType(meridiansAttrs, eAttr);
							convMeridiansAttr = RoleDataHelper.GetAttrByType(convMeridiansAttrs, eAttr);
						end

						local fixGiftAttr = RoleDataHelper.GetAttrByType(fixGiftAttrs, eAttr);
						local perGiftAttr = RoleDataHelper.GetAttrByType(perGiftAttrs, eAttr);
						local conGiftAttr = RoleDataHelper.GetAttrByType(conGiftAttrs, eAttr);
						local convFixGiftAttr = RoleDataHelper.GetAttrByType(convFixGiftAttrs, eAttr);
						local convPerGiftAttr = RoleDataHelper.GetAttrByType(convPerGiftAttrs, eAttr);
						local convConGiftAttr = RoleDataHelper.GetAttrByType(convConGiftAttrs, eAttr);

						local attrB = cardLevelAttr + martialAttr + equipAttr + titleAttr + fixGiftAttr + perGiftAttr + conGiftAttr + meridiansAttr;
						local attrCB = convCardLevelAttr + convBaseAttr + convMartialAttr + convEquipAttr + convTitleAttr + convFixGiftAttr + convPerGiftAttr + convConGiftAttr + convMeridiansAttr;
						return attrB + attrCB;
					end

					if attrName == 'HP' then
						local value = _func(17)
						text = text + math.floor(_getAttr(attrName) + 0.5)
					elseif attrName == 'MP' then
						local value = _func(18)
						text = text + math.floor(_getAttr(attrName) + 0.5)
					end
				end

				comTextValue.text = type(text) == 'number' and math.floor(text) or text;
				comTextValue.gameObject:SetActive(true)
				comTextValue2.gameObject:SetActive(false)
			end
		end
	end
	if self.objAttrBox_2 then
		for index, attrInfo in ipairs(l_roleHpMpAttr) do
			local comTextName = self.objAttrBox2Item[index][1]
			local comTextValue = self.objAttrBox2Item[index][2]
			local comTextValue2 = self.objAttrBox2Item[index][3]
			local attrName = attrInfo.attrName
			local attrChName = attrInfo.attrChName
			comTextName.text = attrChName
			local text = RoleDataHelper.GetAttr(roleData, dbRoleData, attrName)
			text = text ~= '' and text or '无'
			if attrName == 'Favor' then
				comTextValue2.text = text
				comTextValue.gameObject:SetActive(false)
				comTextValue2.gameObject:SetActive(true)
			else
				
				local _func = function(attrType)
					local value = 0;
					for k, v in pairs(convert) do
						for kk, vv in pairs(v) do
							if kk == attrType then
								value = value + vv;
							end
						end
					end	
					return value;
				end

				if roleData.roleType == ROLE_TYPE.NPC_ROLE or roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
					local _getAttr = function(eAttr)
						local cardLevelAttrs = roleData:GetAttrByCardLevel();
						local convCardLevelAttrs = roleData:GetConvAttrByCardLevel();
						local baseAttrs = roleData:GetAttrByTBData();
						local convBaseAttrs = roleData:GetConvAttrByTBData();
						local martialAttrs = roleData:GetAttrByMartials();
						local convMartialAttrs = roleData:GetConvAttrByMartials();
						local equipAttrs = roleData:GetAttrByEquips();
						local convEquipAttrs = roleData:GetConvAttrByEquips();
						local titleAttrs = roleData:GetAttrByTitle();
						local convTitleAttrs = roleData:GetConvAttrByTitle();
						local meridiansAttrs = {};
						local convMeridiansAttrs = {};
						if roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
							meridiansAttrs = roleData:GetAttrByMeridians();
							convMeridiansAttrs = roleData:GetConvAttrByMeridians();
						end

						local fixGiftAttrs = roleData:GetFixAttrByGifts();
						local perGiftAttrs = roleData:GetPerAttrByGifts();
						local conGiftAttrs = roleData:GetConAttrByGifts();
						local convFixGiftAttrs = roleData:GetFixConvAttrByGifts();
						local convPerGiftAttrs = roleData:GetPerConvAttrByGifts();
						local convConGiftAttrs = roleData:GetConConvAttrByGifts();
		
						local cardLevelAttr = RoleDataHelper.GetAttrByType(cardLevelAttrs, eAttr);
						local convCardLevelAttr = RoleDataHelper.GetAttrByType(convCardLevelAttrs, eAttr);
						local baseAttr = RoleDataHelper.GetAttrByType(baseAttrs, eAttr);
						local convBaseAttr = RoleDataHelper.GetAttrByType(convBaseAttrs, eAttr);
						local martialAttr = RoleDataHelper.GetAttrByType(martialAttrs, eAttr);
						local convMartialAttr = RoleDataHelper.GetAttrByType(convMartialAttrs, eAttr);
						local equipAttr = RoleDataHelper.GetAttrByType(equipAttrs, eAttr);
						local convEquipAttr = RoleDataHelper.GetAttrByType(convEquipAttrs, eAttr);
						local titleAttr = RoleDataHelper.GetAttrByType(titleAttrs, eAttr);
						local convTitleAttr = RoleDataHelper.GetAttrByType(convTitleAttrs, eAttr);
						local meridiansAttr = 0;
						local convMeridiansAttr = 0;
						if roleData.roleType == ROLE_TYPE.HOUSE_ROLE then
							meridiansAttr = RoleDataHelper.GetAttrByType(meridiansAttrs, eAttr);
							convMeridiansAttr = RoleDataHelper.GetAttrByType(convMeridiansAttrs, eAttr);
						end

						local fixGiftAttr = RoleDataHelper.GetAttrByType(fixGiftAttrs, eAttr);
						local perGiftAttr = RoleDataHelper.GetAttrByType(perGiftAttrs, eAttr);
						local conGiftAttr = RoleDataHelper.GetAttrByType(conGiftAttrs, eAttr);
						local convFixGiftAttr = RoleDataHelper.GetAttrByType(convFixGiftAttrs, eAttr);
						local convPerGiftAttr = RoleDataHelper.GetAttrByType(convPerGiftAttrs, eAttr);
						local convConGiftAttr = RoleDataHelper.GetAttrByType(convConGiftAttrs, eAttr);

						local attrB = cardLevelAttr + martialAttr + equipAttr + titleAttr + fixGiftAttr + perGiftAttr + conGiftAttr + meridiansAttr;
						local attrCB = convCardLevelAttr + convBaseAttr + convMartialAttr + convEquipAttr + convTitleAttr + convFixGiftAttr + convPerGiftAttr + convConGiftAttr + convMeridiansAttr;
						return attrB + attrCB;
					end

					if attrName == 'HP' then
						local value = _func(17)
						text = text + math.floor(_getAttr(attrName) + 0.5)
					elseif attrName == 'MP' then
						local value = _func(18)
						text = text + math.floor(_getAttr(attrName) + 0.5)
					end
				end
				if attrName == "Speed" then
					self.speed = math.floor(text)
				end
				comTextValue.text = type(text) == 'number' and math.floor(text) or text;
				comTextValue.gameObject:SetActive(true)
				comTextValue2.gameObject:SetActive(false)
			end
		end
	end

	if self.objAttrBox_3 then
		for index, attrInfo in ipairs(l_roleDefenseAttacakAttr) do
			local comTextName = self.objAttrBox3Item[index][1]
			local comTextValue = self.objAttrBox3Item[index][2]
			local attrName = attrInfo.attrName
			local attrChName = attrInfo.attrChName
			comTextName.text = attrChName

			local baseAttr = RoleDataHelper.GetAttr(roleData, dbRoleData, attrName);
			if roleData.roleType == ROLE_TYPE.NPC_ROLE or roleData.roleType == ROLE_TYPE.HOUSE_ROLE then

				local value = RoleDataHelper.GetObserveAttr(roleData, dbRoleData, attrName)

				comTextValue.text = math.floor(value);
				attr[AttrType_Revert[attrChName]] = math.floor(value);
			else
				comTextValue.text = math.floor(baseAttr + 0.5);
			end

			if attrInfo.attrName == "ActionInterval" then
				local roleID = RoleDataManager:GetInstance():GetRoleID(roleData.uiTypeID)
				comTextValue.text = string.format('%.2f', RoleDataManager:GetInstance():GetInitialActionTime(roleID,self.speed))
			end
		end
	end

	if self.objAttrBox then
		        -- 设置属性
				self:RemoveAllChildToPool(self.comAttrBoxContent)
				for k, v in pairs(array_attr) do
					local ekey, strname = next(v)
					self.cache_zero_value = false
					local str_value = self:getTranslate(ekey, roleData:GetAttr(ekey,true),nil,strname,roleData)
					--local str_value = RoleDataHelper.GetObserveAttr(roleData, dbRoleData, array_attr_revert[ekey])
					if self.cache_zero_value then
					local ui_clone = self:LoadPrefabFromPool("Module/NPCAttributeUI", self.comAttrBoxContent)
					local obj_Name = self:FindChildComponent(ui_clone,"Label","Text")
					obj_Name.text = strname
					local obj_Value = self:FindChildComponent(ui_clone,"Value","Text")
					obj_Value.text = str_value
					end
				end
	end
end

function ObserveUI:RefreshDispositions(roleID,isBattleUnit,isInTown)
	self:ReturnDispositionUIClass()
	-- 根据观察的不同状态控制UI的显示与隐藏
	if isBattleUnit or isInTown then 
		self.objAttrBox:SetActive(true)
		self.objChainBox:SetActive(false)
		self.chain_box:SetActive(false)
		self.chain_box_nosee_txt:SetActive(true)
		if isInTown then
			local nosee_txt = self:FindChild(self.chain_box_nosee_txt, 'nosee_txt');
			nosee_txt:GetComponent('Text').text = '酒馆中无法查看';
		end
		return;
	end
	self.objAttrBox:SetActive(false)
	self.objChainBox:SetActive(true)
	self.chain_box:SetActive(true)
	self.chain_box_nosee_txt:SetActive(false)

	local dispositions = RoleDataManager:GetInstance():GetDispositionData(roleID) or {}
	
	local mainRoleID = RoleDataManager:GetInstance():GetMainRoleTypeID()
	local tempSort = {}
	for k, v in pairs(dispositions) do
		v.dstRoleID = k;
		if k ~= mainRoleID then
			table.insert(tempSort, v);
		end
	end

	table.sort(tempSort, function(a, b)
		return a.iValue > b.iValue;
	end)

	table.insert(tempSort, 1, dispositions[mainRoleID]);
	for k, v in pairs(tempSort) do
		dstRoleID = v.dstRoleID;
		if mainRoleID ~= dstRoleID or (v.DescID and v.DescID > 0) then
			local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemDispositionUI,self.objChain)
			kItem:UpdateDisposition(v)
			table.insert(self.akDispositionItemUIClass,kItem)
		end
	end
end

function ObserveUI:RefreshDrawing(roleData,dbRoleData,isBattleUnit)
	local drawing = roleData:GetDrawing()
	if drawing then
		--self.comRoleImage.sprite = drawing
		self:SetSpriteAsync(drawing,self.comRoleImage)
	end
	local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID() -- 剧本ID(酒馆0)

	local iRoleTypeID = roleData.uiTypeID
	local iMainRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
    local iMainRoleCreateRoleID = PlayerSetDataManager:GetInstance():GetCreatRoleID()
	if iRoleTypeID == iMainRoleTypeID then 
		iRoleTypeID = iMainRoleCreateRoleID
	end
	if CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, iRoleTypeID) then
		if self.objCreateCG then
			self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId,iRoleTypeID, self.objCreateCGParent, self.objCreateCG)
			self.objCreateCG:SetActive(true)
		else
			self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId,iRoleTypeID, self.objCreateCGParent)
		end
		self.comRoleImage.gameObject:SetActive(false)
	else
		if self.objCreateCG then
			self.objCreateCG:SetActive(false)
		end
		self.comRoleImage.gameObject:SetActive(true)
	end
end

function ObserveUI:RefreshName(roleID,roleData,dbRoleData,isBattleUnit)
	local strTitle = RoleDataManager:GetInstance():GetRoleTitleStr(roleID);
	local strName = roleData:GetName()
	if GetGameState() == -1 then
		if roleData.uiFragment == 1 then
			strName = RoleDataManager:GetInstance():GetMainRoleName();
			if strTitle then
				strName = strTitle .. strName;
			end
		else
			strName = RoleDataManager:GetInstance():GetRoleName(roleID, true);
		end
	end

	local roleRank = roleData:GetRoleRank()
	local roleOverlayLevel = roleData:GetOverlayLevel()
	if roleOverlayLevel and roleOverlayLevel ~= 0 then
		self.comRoleName.text = strName .. ' +' .. roleOverlayLevel
	else
		self.comRoleName.text = strName
	end
	if DEBUG_MODE then 
		self.comRoleName.text = self.comRoleName.text .. '(' .. dbRoleData.RoleID .. ')'
	end
	self.comRoleName.color = getRankColor(roleRank)

end

function ObserveUI:RefreshBackage(roleData,dbRoleData,isBattleUnit,isInTown)
	--如果处于非战斗界面 就显示包裹界面 否则不显示
	if isBattleUnit then
		self.objbackpack_info:SetActive(false)
	else
		self.objbackpack_info:SetActive(true)
	end
	if isInTown then
		-- TODO: 隐藏UI
		self.objbackpack_box:SetActive(false)
		self.objbackpack_icon:SetActive(false)
		self.objnosee_txt:SetActive(true)
		if isInTown then
			local nosee_txt = self:FindChild(self.objnosee_txt, 'nosee_txt');
			nosee_txt:GetComponent('Text').text = '酒馆中无法查看';
			return 
		end
	end
	self.objbackpack_box:SetActive(true)
	self.objbackpack_icon:SetActive(true)
	self.objnosee_txt:SetActive(false)
	local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE
	local auiRoleItem = roleData:GetBagItems()
	local auiRoleStaticItems = {}
	local auiRoleItemCount = getTableSize(auiRoleItem)
	local itemData, itemTypeData = nil, nil
	local itemMgr = ItemDataManager:GetInstance()

	if isNPC and roleData.GetBagStaticItems then
		auiRoleStaticItems = roleData:GetBagStaticItems()
	end

	if self.objBackpackContent then
		local transform = self.objBackpackContent.transform
		local showIndex = 1
		local normalItemDict = {}

		for itemTypeID, num in pairs(auiRoleStaticItems) do
			if showIndex > 16 then
				break
			end

			if not ItemDataManager:GetInstance():IsEquipItem(nil, itemTypeID) then
				normalItemDict[itemTypeID] = normalItemDict[itemTypeID] or 0
				normalItemDict[itemTypeID] = normalItemDict[itemTypeID] + num
			else
				local tempItemData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
				if tempItemData or MSDK_MODE == 0 then
					local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,transform)

					kItem:UpdateUIWithItemTypeData(tempItemData)

					if num > 1 then
						kItem:SetItemNum(num)
					end
					table.insert(self.akEquipmentItemUIClass,kItem)
					showIndex = showIndex + 1
				end
			end
		end

		for index = 0, auiRoleItemCount - 1 do
			if showIndex > 16 then
				break
			end

			local itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(auiRoleItem[index])
			if itemTypeID and itemTypeID > 0 then
				if not ItemDataManager:GetInstance():IsEquipItem(nil, itemTypeID) then
					local num = ItemDataManager:GetInstance():GetItemNum(auiRoleItem[index])
					if num then
						normalItemDict[itemTypeID] = normalItemDict[itemTypeID] or 0
						normalItemDict[itemTypeID] = normalItemDict[itemTypeID] + num
					end
				else
					local tempItemData = itemMgr:GetItemTypeData(auiRoleItem[index])
					if tempItemData or MSDK_MODE == 0 then
						local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,transform)
						local num = 0
		
						kItem:UpdateUIWithItemTypeData(tempItemData)
						num = ItemDataManager:GetInstance():GetItemNum(auiRoleItem[index])
			
						if num > 1 then
							kItem:SetItemNum(num)
						end
						table.insert(self.akEquipmentItemUIClass,kItem)
		
						showIndex = showIndex + 1
					end
				end
			end

		end
		
		-- 统一显示可堆叠物品
		for itemTypeID, itemNum in pairs(normalItemDict) do
			if showIndex > 16 then
				break
			end

			local tempItemData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
			if tempItemData then
				local maxNum = tempItemData.MaxNum
				if maxNum == 0 then
					maxNum = 99
				end

				while itemNum > 0 do
					if showIndex > 16 then
						break
					end

					local num = itemNum
					if num > maxNum then
						num = maxNum
					end
					itemNum = itemNum - num

					local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,transform)

					kItem:UpdateUIWithItemTypeData(tempItemData)
	
					if num > 1 then
						kItem:SetItemNum(num)
					end
					table.insert(self.akEquipmentItemUIClass,kItem)
					showIndex = showIndex + 1
				end
			end
		end
	end
end

function ObserveUI:RefreshState(unitID,isBattleUnit)
	local txt = ""
	if isBattleUnit then
		self.objState_info:SetActive(true)
		txt = self:GetBattleRoleTips(unitID)
		if txt and txt ~= "" then
			self.objStateScrollRect:SetActive(true)
			self.objStatenosee_txt:SetActive(false)
			self.txtStateContnet:GetComponent('Text').text = txt
		else
			self.objStateScrollRect:SetActive(false)
			self.objStatenosee_txt:SetActive(true)
		end
	else
		self.objState_info:SetActive(false)
	end
end
function ObserveUI:GetBattleRoleTips(uiUnitIndex)
    local tips = nil
    local content = {}
    local kUnit = LogicMain:GetInstance().kUnitMgr:GetUnit(uiUnitIndex)
    if kUnit then
        local allBuff = {}
        kUnit.iBuffNum = kUnit.iBuffNum or 0
        for index = 0,kUnit.iBuffNum - 1 do
            local buff = kUnit.akBuffData[index]
            if buff ~= nil then
                local id = tostring(buff.iBuffTypeID) .. "_" .. tostring(buff.iRoundNum)
                if allBuff[id] then
                    allBuff[id].iLayerNum = allBuff[id].iLayerNum + buff.iLayerNum
                else
                    allBuff[id] = buff
                end
            end
        end
        kUnit.iBuffNum = 0
        kUnit.akBuffData = {}
        for k,buff in pairs(allBuff) do
            kUnit.akBuffData[kUnit.iBuffNum] = buff
            kUnit.iBuffNum = kUnit.iBuffNum + 1
        end
        --buff
        local Local_TB_Buff = TableDataManager:GetInstance():GetTable("Buff")
        for index = 0,kUnit.iBuffNum - 1 do
            local buff = kUnit.akBuffData[index]
            if  buff ~= nil then
                local iBuffIndex = buff.iBuffIndex
                local iBuffTypeID = buff.iBuffTypeID
                local iRoundNum = buff.iRoundNum
                local iLayerNum = buff.iLayerNum
                local tbBuffData = Local_TB_Buff[iBuffTypeID]
                if  iRoundNum ~= 0 and tbBuffData ~= nil then
                    local texnum = GiftDataManager:GetInstance():GetUpgradeGiftInfluenceNum(uiUnitIndex,iBuffTypeID,iLayerNum)
                    local color = "#3B2525"
                    for k,bufFea in pairs(tbBuffData.BuffFeature) do
                        if bufFea == BuffFeatureType.BuffFeatureType_PositiveBuff then
                            color = "green"
                            break
                        elseif bufFea == BuffFeatureType.BuffFeatureType_NegativeBuff then
                            color = "red"
                            break
                        end
                    end
                    local string_level = ""
                    local string_layer = ""
                    string_level = string.format("%d 层",iLayerNum)
                    if iRoundNum >= 99 then
                        string_layer = "不衰减"
                    else
                        string_layer = string.format("%d 回合",iRoundNum)
                    end
                    content[#content + 1] = string.format("<color=%s>%s(%s)---%s </color>",color,GetLanguageByID(tbBuffData.NameID),string_level,string_layer) .. "\n"
                    local strDesc =  TipsDataManager:GetInstance():GetBuffDescReplace(LogicMain:GetInstance():GetBuffDesc(iBuffIndex,tbBuffData), texnum,iBuffTypeID)
                    content[#content + 1] = string.format("<color=#3B2525>%s </color>",strDesc) .. "\n"
                end
            end
        end
        tips = table.concat(content, "")
    end
    return tips
end

function ObserveUI:ReturnUIClass()
	--[TODO] 如果后面 setparent开销太高，按LUA_CLASS_TYPE 分类，UI里自己再做一层缓存，不直接使用ReturnAllUIClass
	if #self.akEquipmentItemUIClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akEquipmentItemUIClass)
		self.akEquipmentItemUIClass = {}
	end
end

function ObserveUI:ReturnDispositionUIClass()
	if #self.akDispositionItemUIClass > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.akDispositionItemUIClass)
		self.akDispositionItemUIClass = {}
	end
end

function ObserveUI:RefreshEquip(roleData,dbRoleData)
	local isNPC = roleData.roleType == ROLE_TYPE.NPC_ROLE
	local isBattle = roleData.roleType == ROLE_TYPE.BATTLE_ROLE
	local instRole = roleData:GetInstRole()
	if instRole then 
		roleData = instRole
	end
	local auiEquipItemInfos = roleData:GetEquipItemInfos()

	if self.transEquipContent then
		local itemMgr = ItemDataManager:GetInstance()
		for i=1,8 do
			local kItem = nil
			local enumKey = EQUIPMENT_ITEM_POS[i]
			local itemInfo = auiEquipItemInfos[enumKey]
			
			if itemInfo then
				local itemID = itemInfo.iInstID or 0
				local typeID = itemInfo.iTypeID or 0

				if itemID > 0 then
					kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,self.transEquipContent[i])
					local itemData = itemMgr:GetItemData(itemID)
					if itemData then
						kItem._gameObject:SetActive(true)
						kItem:UpdateUIWithItemInstData(itemData,nil,true)
					else
						-- if MSDK_MODE ~= 0 then
							kItem._gameObject:SetActive(false)
						-- end
					end
				elseif typeID > 0 then
					kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemIconUITrigger,self.transEquipContent[i])
					local itemIndex = roleData.uiID % ITEMBATTLE_NUM
					local uiTypeID = typeID | (itemIndex << 28)
					local itemBattleInfo = TableDataManager:GetInstance():GetTableData("ItemBattle", uiTypeID)
					local instData = ItemDataManager:GetInstance():genInstItemByItemBattle(itemBattleInfo, uiTypeID)
					if instData then 
						instData.uiTypeID = typeID
						kItem:UpdateUIWithItemInstData(instData,nil,true)
					else
						local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",typeID)
						if itemTypeData then 
							kItem._gameObject:SetActive(true)
							kItem:UpdateUIWithItemTypeData(itemTypeData,true)
						else
							if MSDK_MODE ~= 0 then
								kItem._gameObject:SetActive(false)
							end
						end
					end
				else
					
					-- if MSDK_MODE ~= 0 then
					-- 	kItem._gameObject:SetActive(false)
					-- end
				end
			end

			if kItem then
				kItem:ResetAnchors()
				table.insert(self.akEquipmentItemUIClass,kItem)
			end
		end
	end
end

function ObserveUI:RefreshGift(roleID, roleData,dbRoleData)
	local tempSort = {}
	if roleData:GetInstRole() then 
		roleData = roleData:GetInstRole()
	end
	local auiRoleGifts = roleData:GetObserveGifts()
	local Local_TB_RoleGift = TableDataManager:GetInstance():GetTable("Gift")
	local kGift = nil
	local bcontinue = true 
	local tempGift = {};
	for k, v in pairs(auiRoleGifts) do
		kGift = Local_TB_RoleGift[v]
		if kGift then 
			bcanshow = true 
			if kGift.GiftFlag then 
				for i,Flag in ipairs(kGift.GiftFlag) do 
					if Flag == GiftFlagType.GFT_Hide then 
						bcanshow = false  
					end 
				end 
			end 
			if bcanshow then
				if kGift.AddGiftType == 10 then
					table.insert(tempGift, kGift);
				else
					table.insert(tempSort, kGift);
				end
			end 
		end
	end
	table.sort(tempSort, function(a, b)
		return GiftDataManager:GetInstance():GetRank(roleData, a) > GiftDataManager:GetInstance():GetRank(roleData, b);
	end)
	-- 陈辉特殊需求门派特殊天赋需要置顶
	for i = 1, #(tempGift) do
        table.insert(tempSort, 1, tempGift[i]);
	end
	self.sRoleGiftsDesc = nil  -- 生成一份角色天赋描述
	if self.objGiftContent then
		local transform = self.objGiftContent.transform
		self:RemoveAllChildToPool(transform)
		local tRoleGiftsDesc = {}
		for i = 1, #(tempSort) do
			local objGiftText = self:LoadGameObjFromPool(self.obGiftItem,self.objGiftContent.transform)
			local _Gift = tempSort[i];
			objGiftText:SetActive(true)
			local typeID = _Gift.BaseID
			local comTextName = self:FindChildComponent(objGiftText, "name", "Text")
			local excObj = self:FindChild(objGiftText, "exc")
			local inheritanceObj = self:FindChild(objGiftText, "inheritance")
			local spRank = GiftDataManager:GetInstance():GetRank(roleData, _Gift)
			local exc = GiftDataManager:GetInstance():IfExclusiveGift(typeID)
			local bShowInherianceObj = RoleDataManager:GetInstance():CanHeritGift(roleID,typeID)
			excObj:SetActive(exc)
			inheritanceObj:SetActive(bShowInherianceObj)
			if (comTextName ~= nil) then
				comTextName.color = getRankColor(spRank)
			end
			local sGiftName = GetLanguagePreset(_Gift.NameID, dtext(999).._Gift.NameID) or ""
			if sGiftName ~= nil and _Gift.AttrType == AttrType.ATTR_NULL then
				sGiftName = sGiftName .. '(未实现)'
			end
			if (comTextName ~= nil) then
				comTextName.text = sGiftName
			end
			self:FindChild(objGiftText, "lv"):SetActive(false);

			local comReturnUIAction = self:FindChildComponent(objGiftText,"name","LuaUIAction")
			if comReturnUIAction then
				local fun = function()
					local tips={
						title = exc==true and getRankBasedText(_Gift.Rank, sGiftName).."<color=#ff0000>[专属]</color>" or getRankBasedText(_Gift.Rank, sGiftName),
						content = GiftDataManager:GetInstance():GetDes(roleData, _Gift),
						movePositions = {
							x = 350,
							y = 0
						},
						isSkew = true
					}
					OpenWindowImmediately("TipsPopUI",tips)
				end
				comReturnUIAction:SetPointerEnterAction(function()
					fun()
				end)
		
				comReturnUIAction:SetPointerExitAction(function()
					RemoveWindowImmediately("TipsPopUI")
				end)
			end
		end
		
		if #tRoleGiftsDesc> 0 then
			self.sRoleGiftsDesc = table.concat(tRoleGiftsDesc, "\n")
		end
	end
end

function ObserveUI:RefreshMartials(roleID, roleData,dbRoleData)
	local auiMartials, auiLvs = roleData:GetMartials()
	-- martial id -> lv, id -> typeData
	local kMartialID2Level = {}
	local akMartials = {}
	local typeID = nil
	for index = 0, #auiMartials do
		typeID = auiMartials[index]
		if typeID then
			local data = GetTableData("Martial",typeID) 
			if data then
				kMartialID2Level[typeID] = auiLvs[index]
				akMartials[#akMartials + 1] = data
			end
		end
	end
	-- sort
	table.sort(akMartials, function(a, b)
		return (a.Rank or 0) > (b.Rank or 0)
	end)
	self.sRoleMartialsDesc = nil  -- 生成一份角色武学描述
	if self.objMartialsContent then
		local transform = self.objMartialsContent.transform
		self:RemoveAllChildToPool(transform)
		local tRoleMartialsDesc = {}
		for index, kMartialTypeData in ipairs(akMartials) do
			local objGiftText = self:LoadGameObjFromPool(self.obGiftItem,self.objMartialsContent.transform)
			objGiftText:SetActive(true)
			for k, v in pairs(objGiftText.transform) do
				v.gameObject:SetActive(true);
			end
			local typeID = kMartialTypeData.BaseID
			local comTextName = self:FindChildComponent(objGiftText, "name", "Text")
			local comTextLv = self:FindChildComponent(objGiftText, "lv", "Text")
			local excObj = self:FindChild(objGiftText, "exc")
			local exc = false 
			local typeData = TableDataManager:GetInstance():GetTableData("Martial",typeID)
			local inheritanceObj = self:FindChild(objGiftText, "inheritance")
			local bShowInherianceObj = RoleDataManager:GetInstance():CanHeritMartial(roleID,typeID)
			inheritanceObj:SetActive(bShowInherianceObj)
			if typeData and typeData.Exclusive then
				exc = true
			end
			local sName = ""
			if (comTextName ~= nil) then
				comTextName.color = getRankColor(kMartialTypeData.Rank)
				sName = GetLanguagePreset(kMartialTypeData.NameID, dtext(993)..kMartialTypeData.NameID)
				comTextName.text = sName or ""
				excObj:SetActive(exc)
			end
			
			if (comTextLv ~= nil) then
				comTextLv.text = tostring(kMartialID2Level[typeID] or "") .. '级'
			end

			local tipName = exc == true and (getRankBasedText(kMartialTypeData.Rank, sName).."<color=#ff0000>[专属]</color>") or getRankBasedText(kMartialTypeData.Rank, sName)
			tRoleMartialsDesc[#tRoleMartialsDesc + 1] = string.format("%s  <color=#FFFFFF>%d级</color>", tipName, kMartialID2Level[typeID])
			tRoleMartialsDesc[#tRoleMartialsDesc + 1] = GetLanguageByID(kMartialTypeData.DesID) or ""

			local comReturnUIAction = self:FindChildComponent(objGiftText,"name","LuaUIAction")
			if comReturnUIAction then
				local fun = function()
					local tips={
						title = string.format("%s  <color=#FFFFFF>%d级</color>",
							tipName,
							kMartialID2Level[typeID]
						),
						content = GetLanguageByID(kMartialTypeData.DesID) or "",
						movePositions = {
							x = 350,
							y = 0
						},
						isSkew = true
					}
					OpenWindowImmediately("TipsPopUI",tips)
				end
				comReturnUIAction:SetPointerEnterAction(function()
					fun()
				end)
		
				comReturnUIAction:SetPointerExitAction(function()
					RemoveWindowImmediately("TipsPopUI")
				end)
			end

		end
		if #tRoleMartialsDesc > 0 then
			self.sRoleMartialsDesc = table.concat(tRoleMartialsDesc, "\n")
		end
	end
end

function ObserveUI:RefreshFavor(roleID,roleData,isBattleUnit,isInTown)
	if isInTown then
		self.objFavorBox:SetActive(false);
		return;
	end
	if isBattleUnit then 
		roleID = RoleDataManager:GetInstance():GetRoleID(roleData.uiTypeID)
	end
	self.objFavorBox:SetActive(RoleDataHelper.CanShowFavor(roleData.uiTypeID) and roleID ~= 0)
	local favor = RoleDataManager:GetInstance():GetDispotionValueToMainRole(roleID)
	local fText = self:FindChildComponent(self._gameObject, "Favor_box/Text", "Text");
	fText.text = string.format('%d', toint(favor) )
end

function ObserveUI:RefreshUI(roleData)
	self.roleData = roleData;
	local roleID = roleData.roleID
	local unitID = roleData.unitID
	local roleIDs = roleData.roleIDs

	local observeTeam = false;
	local faceData = nil 
	if roleIDs and roleIDs[roleData.index] then
		observeTeam = true;
		roleID = roleIDs[roleData.index].uiRoleID;
		faceData = roleIDs[roleData.index].faceData
		if #(roleIDs) > 1 then
			if self.roleData.index == 1 then
				self.objDRButton_left.gameObject:SetActive(false);
			else
				self.objDRButton_left.gameObject:SetActive(true);
			end
			if self.roleData.index == #(self.roleData.roleIDs) then
				self.objDRButton_right.gameObject:SetActive(false);
			else
				self.objDRButton_right.gameObject:SetActive(true);
			end
		end
	else
		self.objDRButton_left.gameObject:SetActive(false);
		self.objDRButton_right.gameObject:SetActive(false);
	end

	local roleData
	
	if roleID then   
		roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
		if not observeTeam and roleData then 
			-- 这里做一个特殊处理,如果观察的NPC在队友里面有同样typeid的,那么直接观察队友
			local teammatesData = RoleDataManager:GetInstance():GetInstRoleByTypeID(roleData.uiTypeID)
			if (teammatesData ~= nil) then
				roleData = teammatesData
			end
		end
	elseif unitID then 
		roleData = UnitMgr:GetInstance():GetUnit(unitID)
		if roleData then 
			roleData = roleData.battleRole
		end
	end
    if roleData == nil then
        -- derror("获取角色武学,角色不存在,id=" .. roleID)
        return
	end
	
	-- 增加捏脸数据
	roleData.faceData = faceData
	
	local dbRoleData = roleData:GetDBRole()
	local isBattleUnit = roleData.roleType == ROLE_TYPE.BATTLE_ROLE
	local isInTown = GetGameState() == -1;
	self:ReturnUIClass()
	-- 关系链
	self:RefreshDispositions(roleID,isBattleUnit,isInTown)
	
	-- 属性
	self:RefreshAttr(roleData, dbRoleData)
	
	-- 立绘
	self:RefreshDrawing(roleData, dbRoleData,isBattleUnit)
	
	-- 显示名字
	self:RefreshName(roleID,roleData, dbRoleData,isBattleUnit)
	
	-- 背包显示
	self:RefreshBackage(roleData, dbRoleData,isBattleUnit,isInTown)

	-- 状态显示
	self:RefreshState(unitID,isBattleUnit)

	-- 装备显示
	self:RefreshEquip(roleData, dbRoleData)

	-- 天赋显示
	self:RefreshGift(roleID, roleData, dbRoleData)

	--武学显示
	self:RefreshMartials(roleID, roleData, dbRoleData)

	-- 好感度显示
	self:RefreshFavor(roleID,roleData,isBattleUnit,isInTown)
end

-- 显示天赋tips
function ObserveUI:ShowGiftTips()
	if not self.sRoleGiftsDesc then
		return
	end
	local tips = {
		['title'] = "天赋",
		['titlecolor'] = DRCSRef.Color.white,
		['kind'] = "wide",
		['content'] = self.sRoleGiftsDesc
	}
    OpenWindowImmediately("TipsPopUI", tips)
end

-- 显示武学tips
function ObserveUI:ShowMartialTips()
	if not self.sRoleMartialsDesc then
		return
	end
	local tips = {
		['title'] = "武学",
		['titlecolor'] = DRCSRef.Color.white,
		['kind'] = "wide",
		['content'] = self.sRoleMartialsDesc
	}
    OpenWindowImmediately("TipsPopUI", tips)
end

function ObserveUI:OnEnable()
	local winDialogRec = GetUIWindow("DialogControlUI")
	if winDialogRec then
		winDialogRec:HideBtns()
	end
end

function ObserveUI:OnDisable()
	self:ReturnUIClass()
	local winDialogRec = GetUIWindow("DialogControlUI")
	if winDialogRec then
		winDialogRec:ShowBtns()
	end
end

function ObserveUI:SetCallBack(callback)
	self.callback = callback;
end

local f_getMaxRate = function(eType)
    if not eType then return 1 end
    local BattleFactorRelate = TableDataManager:GetInstance():GetTableData("BattleFactorRelate",eType)
    if not BattleFactorRelate or not BattleFactorRelate.Value then return 1 end
    return BattleFactorRelate.Value
end
function ObserveUI:f_checkzero(va1,va2)
    local bret = true
    if va2 == nil and  va1 == 0 then
        bret = false
    elseif va2 == 0 and va1 == 0 then
        bret = false
    end
    self.cache_zero_value =  bret
end
----------------------------------------------------
function ObserveUI:getTranslate(enum, value, isMainRoleAttr,stringname,roleData)
    if enum == AttrType.ATTR_MAX_NUM then
        if stringname == '' then
            return ''
        elseif stringname == '体质转生命值' then
            local roleData = RoleDataManager:GetInstance():GetRoleData(self.selectRole)
            local BattleFactor = TableDataManager:GetInstance():GetTableData("BattleFactor",roleData and roleData.uiLevel or 1)
            self.cache_zero_value =  true
            return BattleFactor and BattleFactor.physique_hp or 50
        end
    elseif roleData then
        local BattleFactorRelate = TableDataManager:GetInstance():GetTable('BattleFactorRelate')
        local finalStr = nil
        local addStr = nil
        if enum == AttrType.ATTR_SHANBI then
            local n_shanbi = roleData:GetAttr(AttrType.ATTR_SHANBI,true) or 0
            local n_shanbi_percent = (roleData:GetAttr(AttrType.ATTR_SHANBILV,true) or 0 )/ 10000
            local n_shanbi_gen = (n_shanbi + temp_battle_factor["dodge_m"]) / (n_shanbi + temp_battle_factor["dodge_n"]) * f_getMaxRate(BattleFactorType.BFACT_DodgeMax)
            n_shanbi_gen = n_shanbi_gen >= 0 and n_shanbi_gen or 0
            local n_shanbi_final = n_shanbi_gen + n_shanbi_percent
            self:f_checkzero(n_shanbi,n_shanbi_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_shanbi, n_shanbi_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_shanbi, addStr, n_shanbi_final * 100)
            end
        elseif enum == AttrType.ATTR_HITATK then
            --  HELP CH TO REM: 由于命中影响过大 调小倍率 初始为0.5 改到了 0.1
            local n_mingzhong = roleData:GetAttr(AttrType.ATTR_HITATK,true) or 0
            local n_mingzhong_percent = (roleData:GetAttr(AttrType.ATTR_HITATKPER,true) or 0 )/ 10000
            local n_mingzhong_gen = (n_mingzhong + temp_battle_factor["dodge_m"]) / (n_mingzhong + temp_battle_factor["dodge_n"]) * 0.1
            n_mingzhong_gen = n_mingzhong_gen >= 0 and n_mingzhong_gen or 0
            local n_mingzhong_final = n_mingzhong_gen + n_mingzhong_percent
            self:f_checkzero(n_mingzhong, n_mingzhong_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_mingzhong, n_mingzhong_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_mingzhong, addStr, n_mingzhong_final * 100)
            end
        elseif enum == AttrType.ATTR_CRITATK then
            local n_critatk = roleData:GetAttr(AttrType.ATTR_CRITATK,true) or 0
            local n_critatk_percent = (roleData:GetAttr(AttrType.ATTR_CRITATKPER,true) or 0 )/ 10000
            local n_critatk_gen = (n_critatk + temp_battle_factor["crit_m"]) / (n_critatk + temp_battle_factor["crit_n"]) * f_getMaxRate(BattleFactorType.BFACT_CritMax)
            n_critatk_gen = n_critatk_gen >= 0 and n_critatk_gen or 0
            local n_critatc_final = n_critatk_gen + n_critatk_percent
            self:f_checkzero(n_critatk, n_critatc_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_critatk, n_critatc_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_critatk, addStr, n_critatc_final * 100)
            end
        elseif enum == AttrType.ATTR_BAOJIDIKANGZHI then
            local n_count_crittk = roleData:GetAttr(AttrType.ATTR_BAOJIDIKANGZHI,true) or 0
            local n_count_crittk_percent = (roleData:GetAttr(AttrType.ATTR_IGNOREDEFPER,true) or 0 )/ 10000
            local n_count_crittk_gen = (n_count_crittk + temp_battle_factor["crit_m"]) / (n_count_crittk + temp_battle_factor["crit_n"]) * f_getMaxRate(BattleFactorType.BFACT_CritMax)
            n_count_crittk_gen = n_count_crittk_gen >= 0 and n_count_crittk_gen or 0
            local n_critatc_final = n_count_crittk_gen + n_count_crittk_percent
            self:f_checkzero(n_count_crittk, n_critatc_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_count_crittk, n_critatc_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_count_crittk, addStr, n_critatc_final * 100)
            end
        elseif enum == AttrType.ATTR_CONTINUATK then
            local n_continuatk = roleData:GetAttr(AttrType.ATTR_CONTINUATK,true) or 0
            local n_continuatk_percent = (roleData:GetAttr(AttrType.ATTR_CONTINUATKPER,true) or 0 )/ 10000
            local n_continuatk_gen = (n_continuatk + temp_battle_factor["Combo_m"]) / (n_continuatk + temp_battle_factor["Combo_n"]) * f_getMaxRate(BattleFactorType.BFACT_ComboMax)
            n_continuatk_gen = n_continuatk_gen >= 0 and n_continuatk_gen or 0
            local n_continuatk_final = n_continuatk_gen + n_continuatk_percent
            self:f_checkzero(n_continuatk, n_continuatk_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_continuatk, n_continuatk_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_continuatk, addStr, n_continuatk_final * 100)
            end
        elseif enum == AttrType.ATTR_KANGLIANJI then
            local n_kanglianji = roleData:GetAttr(AttrType.ATTR_KANGLIANJI,true) or 0
            local n_kanglianji_percent = (roleData:GetAttr(AttrType.ATTR_KANGLIANJILV,true) or 0 )/ 10000
            local n_kanglianji_gen = (n_kanglianji + temp_battle_factor["Combo_m"]) / (n_kanglianji + temp_battle_factor["Combo_n"]) * f_getMaxRate(BattleFactorType.BFACT_ComboMax)
            n_kanglianji_gen = n_kanglianji_gen >= 0 and n_kanglianji_gen or 0
            local n_kanglianji_final = n_kanglianji_gen + n_kanglianji_percent
            self:f_checkzero(n_kanglianji, n_kanglianji_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_kanglianji, n_kanglianji_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_kanglianji, addStr, n_kanglianji_final * 100)
            end
        elseif enum == AttrType.ATTR_FANJIZHI then
            local n_fanji = roleData:GetAttr(AttrType.ATTR_FANJIZHI,true) or 0
            local n_fanji_percent = (roleData:GetAttr(AttrType.ATTR_FANJILV,true) or 0 )/ 10000
            local n_fanji_gen = (n_fanji + temp_battle_factor["counter_m"]) / (n_fanji + temp_battle_factor["counter_n"]) * f_getMaxRate(BattleFactorType.BFACT_counterMax)
            n_fanji_gen = n_fanji_gen >= 0 and n_fanji_gen or 0
            local n_fanji_final = n_fanji_gen + n_fanji_percent
            self:f_checkzero(n_fanji, n_fanji_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_fanji, n_fanji_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_fanji, addStr, n_fanji_final * 100)
            end
        elseif enum == AttrType.ATTR_POZHAOVALUE then
            local n_seethrough = roleData:GetAttr(AttrType.ATTR_POZHAOVALUE,true) or 0
            local n_seethrough_percent = (roleData:GetAttr(AttrType.ATTR_POZHAOLV,true) or 0 )/ 10000
            local n_seethrough_gen = (n_seethrough + temp_battle_factor["seeThrough_m"]) / (n_seethrough + temp_battle_factor["seeThrough_n"]) * f_getMaxRate(BattleFactorType.BFACT_seeThroughMax)
            n_seethrough_gen = n_seethrough_gen >= 0 and n_seethrough_gen or 0
            local n_seethrough_final = n_seethrough_gen + n_seethrough_percent
            self:f_checkzero(n_seethrough, n_seethrough_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_seethrough, n_seethrough_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_seethrough, addStr, n_seethrough_final * 100)
            end
        elseif enum == AttrType.ATTR_BAOSHANGZHI then
            local n_baojibeishu = roleData:GetAttr(AttrType.ATTR_BAOSHANGZHI,true) or 0
            local n_baojibeishu_percent = (roleData:GetAttr(AttrType.ATTR_CRITATKTIME,true) or 0 )/ 10000
            local n_baojibeishu_gen = (n_baojibeishu + temp_battle_factor["critDge_m"]) / (n_baojibeishu + temp_battle_factor["critDge_n"]) * f_getMaxRate(BattleFactorType.BFACT_CritDgeMax)
            n_baojibeishu_gen = n_baojibeishu_gen >= 0 and n_baojibeishu_gen or 0
            local n_baojibeishu_final = n_baojibeishu_gen + n_baojibeishu_percent + 1
            self:f_checkzero(n_baojibeishu, n_baojibeishu_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_baojibeishu, n_baojibeishu_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_baojibeishu, addStr, n_baojibeishu_final * 100)
            end
        elseif enum == AttrType.ATTR_FANTANVALUE then
            local n_rebound = roleData:GetAttr(AttrType.ATTR_FANTANVALUE,true) or 0
            local n_rebound_percent = (roleData:GetAttr(AttrType.ATTR_FANTANLV,true) or 0 )/ 10000
            local n_rebound_gen = (n_rebound + temp_battle_factor["rebound_m"]) / (n_rebound + temp_battle_factor["rebound_n"]) * f_getMaxRate(BattleFactorType.BFACT_reboundMax)
            n_rebound_gen = n_rebound_gen >= 0 and n_rebound_gen or 0
            local n_rebound_final = n_rebound_gen + n_rebound_percent
            self:f_checkzero(n_rebound, n_rebound_final)
            if addStr == nil then
                return string.format('%d(%0.f%%)',n_rebound, n_rebound_final * 100)
            else
                return string.format('%d%s(%0.f%%)',n_rebound, addStr, n_rebound_final * 100)
            end
        end

    end
    local iDiffValue = RoleDataManager:GetInstance():GetDifficultyValue()
    local table_AttrMaxDiff = TableDataManager:GetInstance():GetTable("AttrmaxDifficuty")
    if iDiffValue > #table_AttrMaxDiff then
        iDiffValue = #table_AttrMaxDiff
    end
    local bMax = false
    local attrMaxData = table_AttrMaxDiff[iDiffValue]
    if attrMaxData then
        local field = weekLimitValue[enum]
        local maxValue = attrMaxData[field]
        if maxValue then
            if value >= maxValue then
                value = maxValue
                bMax = true
            end
        end
    end
    self:f_checkzero(value)
    local ret_string = getAttrBasedText(enum, value, isMainRoleAttr)
    if bMax then
        ret_string = getUIBasedText('red',ret_string)
    end

    return ret_string
end

return ObserveUI