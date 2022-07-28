CreateRoleUI = class("CreateRoleUI",BaseWindow)
local forbidText = require 'ForbidText'
local forbidTexts = string.split(forbidText, '\n')
local SpineRoleUI = require 'UI/Role/SpineRoleUI'
-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

-- 皮肤数量最大值
local skin_num_max = 8

local aiBabayGift = {
	[2274] = true,
	[50193] = true,
	[50195] = true,
	[50194] = true,
}

-- 数据字段名映射表
local rangeAttrDataKeyMap = {
	[AttrType.ATTR_QUANZHANGJINGTONG] = 'QuanzhangJingTongRange',
    [AttrType.ATTR_JIANFAJINGTONG] = 'JianfaJingTongRange',
    [AttrType.ATTR_DAOFAJINGTONG] = 'DaofaJingTongRange',
    [AttrType.ATTR_TUIFAJINGTONG] = 'TuifaJingTongRange',
    [AttrType.ATTR_QIMENJINGTONG] = 'QimenJingTongRange',
    [AttrType.ATTR_ANQIJINGTONG] = 'AnqiJingTongRange',
    [AttrType.ATTR_YISHUJINGTONG] = 'YishuJingTongRange',
    [AttrType.ATTR_NEIGONGJINGTONG] = 'NeigongJingTongRange',
    [AttrType.ATTR_JIANFAATK] = 'JianfaATKRange',
    [AttrType.ATTR_DAOFAATK] = 'DaofaATKRange',
    [AttrType.ATTR_QUANZHANGATK] = 'QuanzhangATKRange',
    [AttrType.ATTR_TUIFAATK] = 'TuifaATKRange',
    [AttrType.ATTR_QIMENATK] = 'QimenATKRange',
    [AttrType.ATTR_ANQIATK] = 'AnqiATKRange',
    [AttrType.ATTR_YISHUATK] = 'YishuATKRange',
    [AttrType.ATTR_NEIGONGATK] = 'NeigongATKRange',
	[AttrType.ATTR_MAXHP] = 'MaxHpRange',
	[AttrType.ATTR_MAXMP] = 'MaxMpRange',
	[AttrType.ATTR_DEF] = 'DefRange',
	[AttrType.ATTR_MARTIAL_ATK] = 'MartialATKRange',
}

-- 数据最大值配置枚举映射表
local showAttrMaxValueConfigName = {
	['剑法精通'] = ConfigType.CFG_CREATE_ROLE_JIAN_FA_SHOW_MAX_VALUE,
	['刀法精通'] = ConfigType.CFG_CREATE_ROLE_DAO_FA_SHOW_MAX_VALUE,
	['拳掌精通'] = ConfigType.CFG_CREATE_ROLE_QUAN_ZHANG_SHOW_MAX_VALUE,
	['腿法精通'] = ConfigType.CFG_CREATE_ROLE_TUI_FA_SHOW_MAX_VALUE,
	['奇门精通'] = ConfigType.CFG_CREATE_ROLE_QI_MEN_SHOW_MAX_VALUE,
	['暗器精通'] = ConfigType.CFG_CREATE_ROLE_AN_QI_SHOW_MAX_VALUE,
	['医术精通'] = ConfigType.CFG_CREATE_ROLE_YI_SHU_SHOW_MAX_VALUE,
	['内功精通'] = ConfigType.CFG_CREATE_ROLE_NEI_GONG_SHOW_MAX_VALUE,

	['生命'] = ConfigType.CFG_CREATE_ROLE_MAX_HP_SHOW_MAX_VALUE,
	['真气'] = ConfigType.CFG_CREATE_ROLE_MAX_MP_SHOW_MAX_VALUE,
	['防御'] = ConfigType.CFG_CREATE_ROLE_DEF_SHOW_MAX_VALUE,
	['攻击'] = ConfigType.CFG_CREATE_ROLE_MARTIAL_ATK_SHOW_MAX_VALUE,
}

local l_attrTypeToAttrNameMap = {
    [AttrType.ATTR_QUANZHANGJINGTONG] = '拳掌精通',
    [AttrType.ATTR_JIANFAJINGTONG] = '剑法精通',
    [AttrType.ATTR_DAOFAJINGTONG] = '刀法精通',
    [AttrType.ATTR_TUIFAJINGTONG] = '腿法精通',
    [AttrType.ATTR_QIMENJINGTONG] = '奇门精通',
    [AttrType.ATTR_ANQIJINGTONG] = '暗器精通',
    [AttrType.ATTR_YISHUJINGTONG] = '医术精通',
    [AttrType.ATTR_NEIGONGJINGTONG] = '内功精通',
    [AttrType.ATTR_JIANFAATK] = '剑法攻击',
    [AttrType.ATTR_DAOFAATK] = '刀法攻击',
    [AttrType.ATTR_QUANZHANGATK] = '拳掌攻击',
    [AttrType.ATTR_TUIFAATK] = '腿法攻击',
    [AttrType.ATTR_QIMENATK] = '奇门攻击',
    [AttrType.ATTR_ANQIATK] = '暗器攻击',
    [AttrType.ATTR_YISHUATK] = '医术攻击',
    [AttrType.ATTR_NEIGONGATK] = '内功攻击',
	[AttrType.ATTR_MAXHP] = '生命',
	[AttrType.ATTR_MAXMP] = '真气',
	[AttrType.ATTR_DEF] = '防御',
	[AttrType.ATTR_MARTIAL_ATK] = '攻击',
}

local IsNotAllSimpleChinese = function(str)
	local strList = {utf8.codepoint(str,1,-1)}
    for i=1,#strList do
		if strList[i] < 0x4e00 or strList[i] >  0x9fa5 then
			return true
		end
	end
	return false
end

local UPDATE_TYPE = 
{
	["UPDATE_CREATE_ROLE"] = 1,
	["UPDATE_UNLOCK_ROLE"] = 2,
	["UPDATE_UNLOCK_SKIN"] = 3,
} 

function CreateRoleUI:ctor()
	self.iUpdateFlag = 0
end

function CreateRoleUI:Create()
	local obj = LoadPrefabAndInit("Game/CreateRoleUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function CreateRoleUI:Init()
	self.SpineRoleUI = SpineRoleUI.new()
	self.bShowCreateFace = true -- 默认需显示捏脸数据

	self.unLayName = {}
	self.unlockRole = false
	self.unlockSkin = false
	self.aniPalyTime = os.clock();

	self.objContent = self:FindChild(self._gameObject, "TransformAdapt_node_left/left/LoopScrollView/Content")
	self.comLoopScrollView = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/left/LoopScrollView", "LoopVerticalScrollRect")
	self.comContent_ToggleGroup = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/left/LoopScrollView/Content","ToggleGroup")
	self.comContent_CG = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/left/CG","Image")
	self.objCreateCGParent = self:FindChild(self._gameObject, "TransformAdapt_node_left/left/CreateCG")

	-- 中间区域
	self.objInput = self:FindChild(self._gameObject,"mid/ButtonGroup/InputField")
	self.comInput_InputField = self.objInput:GetComponent("InputField")
	self.comNameRoll_Button = self:FindChildComponent(self.objInput, "Button_name_roll", "Button")
	self.comPlay_Button = self:FindChildComponent(self._gameObject, "mid/Button_play", "Button")
	self.objPlay_Button = self:FindChild(self._gameObject, "mid/Button_play")
	self.objBuy_Button = self:FindChild(self._gameObject, "mid/Button_buy_1")
	self.objSpine = self:FindChild(self._gameObject,"mid/Spine")
	self.objCondition = self:FindChild(self._gameObject,"mid/TMP_condition")
	self.objTextTMP = self:FindChildComponent(self._gameObject, "mid/Button_play/TMP_Text", "Text")
	self.objButton = self:FindChildComponent(self._gameObject, "mid/Button", "Empty4Raycast")
	self.objImage = self:FindChild(self._gameObject, "mid/Image");
	self.objImageGift = self:FindChild(self.objImage, "Image_Gift");
	self.objImageLimitUp = self:FindChild(self.objImage, "Image_LimitUp");
	self.objImageFreeTask = self:FindChild(self.objImage, "Image_FreeTask");
	self.objChallengeOrderLock = self:FindChild(self._gameObject, "mid/Button_ChallengeOrderLock");

	self.objCreateFaceButton = self:FindChild(self._gameObject, "mid/ButtonGroup/Button_CreateFace")
	self.comCreateFaceButton = self:FindChildComponent(self._gameObject, "mid/ButtonGroup/Button_CreateFace", "Button")
	if self.comCreateFaceButton then
		self:RemoveButtonClickListener(self.comCreateFaceButton)
		self:AddButtonClickListener(self.comCreateFaceButton, function()
			local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo)
			local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
			local typedata = self:GetTypeData(info, self.selectrole)
			local iRoleTypeID =  typedata.OldRoleID
			OpenWindowImmediately("CreateFaceUI",{['iStoryId'] = iStoryId,['iRoleId'] = iRoleTypeID})
		end)
	end

	self.objResetFaceButton = self:FindChild(self.objCreateFaceButton, "Button_Reset")
	self.comResetFaceButton = self:FindChildComponent(self.objCreateFaceButton, "Button_Reset", "Button")
	if self.comResetFaceButton then
		self:RemoveButtonClickListener(self.comResetFaceButton)
		self:AddButtonClickListener(self.comResetFaceButton, function()
			local content = "将重置形象！"
			local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo)
			local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
			local typedata = self:GetTypeData(info, self.selectrole)
			local iRoleTypeID =  typedata.OldRoleID
			local callback = function()
				-- 发送上行 服务器端清数据
				CreateFaceManager:GetInstance():DeleteFaceData(iStoryId, iRoleTypeID)
			end
			OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback,{cancel = true,confirm = true}})
		end)
	end

	self.objResetFaceButton = self:FindChild(self.objCreateFaceButton, "Button_Reset")
	self.comResetFaceButton = self:FindChildComponent(self.objCreateFaceButton, "Button_Reset", "Button")
	if self.comResetFaceButton then
		self:RemoveButtonClickListener(self.comResetFaceButton)
		self:AddButtonClickListener(self.comResetFaceButton, function()
			local content = "将重置形象！"
			local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo)
			local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
			local typedata = self:GetTypeData(info, self.selectrole)
			local iRoleTypeID =  typedata.OldRoleID
			local callback = function()
				-- 发送上行 服务器端清数据
				CreateFaceManager:GetInstance():DeleteFaceData(iStoryId, iRoleTypeID)
			end
			OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback,{cancel = true,confirm = true}})
		end)
	end

	-- 右边区域
	self.objBasicAttrBox = self:FindChild(self._gameObject,"TransformAdapt_node_right/right/BasicAttrBox/Viewport/Content") 
	self.objMartialAttrBox = self:FindChild(self._gameObject, "TransformAdapt_node_right/right/MartialAttrBox/Viewport/Content")
	self.back_special  = self:FindChild(self._gameObject,"TransformAdapt_node_right/right/back_special")
    self.LoopScrollView_Gift = self.back_special:GetComponent(DRCSRef_Type.LoopVerticalScrollRect)
	self.comAbilityRoll_Button = self:FindChildComponent(self._gameObject, "Button_ability_roll", "Button")
	self.objAbilityRoll_Button = self:FindChild(self._gameObject, "Button_ability_roll")
	
	-- 皮肤选择
	self.objSkin_layout = self:FindChild(self._gameObject,"mid/skin_box/skin_layout")
	self.array_objSkin = {}
	for i = 1, skin_num_max do
		self.array_objSkin[i] = self.objSkin_layout.transform:GetChild(i-1).gameObject
		self.array_objSkin[i]:SetActive(false)
		local comSkin_child_Toggle = self.array_objSkin[i]:GetComponent('Toggle')
		local objSkin_child_border = self:FindChild(self.array_objSkin[i], "toggle/border")
		local objSkin_child_normal = self:FindChild(self.array_objSkin[i], "normal")
		local objSkin_child_normal_lock = self:FindChild(self.array_objSkin[i], "normal/lock")
		local objSkin_child_toggle_lock = self:FindChild(self.array_objSkin[i], "toggle/lock")
		if comSkin_child_Toggle and objSkin_child_border then
			local fun = function(bool)
				objSkin_child_normal:SetActive(not bool)
				if bool then
					if self._oldSkinIndex == i then return end
					self._oldSkinIndex = i
					--toggle动画
					self.array_objSkin[i].transform:DOKill()
					self.array_objSkin[i].transform:DOScale(DRCSRef.Vec3(0.2,0.2,1),0.2):SetEase(DRCSRef.Ease.OutBack):From()

					local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo)
					local typedata = self:GetTypeData(info, self.selectrole)
					local iRoleTypeID =  typedata.OldRoleID

					if self.objCreateCG and self.objCreateCG.activeSelf then
						-- TODO 捏脸 二次确认
						local content = "将重置形象！"
						local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
						local callback = function()
							-- 发送上行 服务器端清数据
							CreateFaceManager:GetInstance():DeleteFaceData(iStoryId, iRoleTypeID)
						end
						OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback,{cancel = true,confirm = true}})
					else
						self:ChooseSkin(i)
					end
					objSkin_child_border:SetActive(true)

					local _setActive = function(isActive1, isActive2, isActive3, isActive4)
						self.objInput:SetActive(isActive1);
						self:SetCreateFaceButtonVisible(isActive1)
						self.objCondition:SetActive(isActive2);
						self.objBuy_Button:SetActive(isActive4);

						if isActive3 then
							if info and self:IsChallengeOrderLock(info.uiTypeID) then
								self.objChallengeOrderLock:SetActive(true)
								self.objPlay_Button:SetActive(false)
							else
								self.objPlay_Button:SetActive(true)
							end
						else
							self.objPlay_Button:SetActive(false)
						end
					end

					local _func = function(isBool)
						if self:IsSkinLock(self.selectrole, i) then

							objSkin_child_toggle_lock:SetActive(true)
							-- _setActive(false, false, false, true);
							
							-- local numText = self:FindChildComponent(self.objBuy_Button, 'Number', 'Text');
							-- numText.text = typedata.UnlockCost[i];
							-- if i == 1 then
							-- 	objSkin_child_toggle_lock:SetActive(false);
							-- 	numText.text = typedata.UnlockCostSilver;
							-- end
						else

							objSkin_child_toggle_lock:SetActive(false)	
							-- if isBool then
							-- 	_setActive(true, false, true, false);
							-- end

							-- local numText = self:FindChildComponent(self.objBuy_Button, 'Number', 'Text');
							-- numText.text = typedata.UnlockCostSilver;
						end
						self:RefreshCondition(self.selectrole, i)
					end

					-- TODO 首先需要判断服务端的皮肤解锁数据
					_func(false);

					-- if i == 1 then
					-- 	self.unlockRole = true;
					-- 	self.unlockSkin = false;
					-- else
					-- 	self.unlockRole = false;
					-- 	self.unlockSkin = true;
					-- end
				else
					objSkin_child_border:SetActive(false)
					objSkin_child_toggle_lock:SetActive(false)
				end
			end
			self:AddToggleClickListener(comSkin_child_Toggle,fun)
		end
	end

	self.unLawName = {}

	self.attrNodesPool = {}

	self:InitListener()
end

function CreateRoleUI:OnEnable()
	self:OpenCreateRoleWindowBar()
end

function CreateRoleUI:OpenCreateRoleWindowBar()
	-- 引导模式不允许从创角返回到酒馆
	local bIsGuideMode = PlayerSetDataManager:GetInstance():GetGuideModeFlag()
	local info = {
		['doAfterInit'] = function()
			-- 偏移货币资源图标
			self:InitWindowBarResourceBoxPos()
		end,
		['callback'] = function()
			if IsGameServerMode() then
				SendClickQuitStoryCMD()
			elseif self.bIsBabyRole then
				-- 什么都不做
			else
				QuitStory()
			end
		end,  --回调
		['topBtnState'] = {  --决定顶部栏资源显示状态
			['bBackBtn'] = (bIsGuideMode ~= true),
			['bGold'] = true,
			['bSilver'] = true,
		},
		['iOffset'] = 115,
	}
	
	if not self.bIsBabyRole then
		info['windowstr'] = "CreateRoleUI"
	end
	if not self.bIsBabyRole then 
		OpenWindowBar(info)
	end
end

function CreateRoleUI:OnDisable()
	RemoveWindowBar('CreateRoleUI')
end

function CreateRoleUI:InitWindowBarResourceBoxPos()
	if not IsWindowOpen("WindowBarUI") then
		return
	end
	local windowBarUI = GetUIWindow("WindowBarUI")
	if not windowBarUI then
		return
	end
	windowBarUI:ResetResourcesBox()
end

-- 加载各组件监听/事件监听
function CreateRoleUI:InitListener()
	if self.comLoopScrollView then
        local fun = function(transform, idx)
			self:OnScrollChanged(transform, idx)
        end
        self.comLoopScrollView:AddListener(fun)
	end

	if self.LoopScrollView_Gift then
		local fun = function(transform, idx)
			self:OnScrollChangedGift(transform, idx)
        end
        self.LoopScrollView_Gift:AddListener(fun)
	end

	if self.comInput_InputField then
		local fun = function(str)
			self.role_name = str
			self:check_rolename(str)
		end
		self.comInput_InputField.onEndEdit:AddListener(fun)

	end
	if self.comNameRoll_Button then
		local fun = function()
			self:RefreshName()
			self.comNameRoll_Button.transform:DOKill()
			self.comNameRoll_Button.transform:DOScale(DRCSRef.Vec3(0.8,0.8,1),0.2):SetEase(DRCSRef.Ease.OutBack):From()
		end
		self:AddButtonClickListener(self.comNameRoll_Button,fun)
	end
	if self.comPlay_Button then
		self:AddButtonClickListener(self.comPlay_Button, function() self:OnClick_Play_Button() end)
	end
	if self.comAbilityRoll_Button then
		local fun = function()
			self:OnClick_Ability_Roll_Button()
			self.comAbilityRoll_Button.transform:DOKill()
			self.comAbilityRoll_Button.transform:DOScale(DRCSRef.Vec3(0.8,0.8,1),0.2):SetEase(DRCSRef.Ease.OutBack):From()
		end
		self:AddButtonClickListener(self.comAbilityRoll_Button,fun)
	end

	--
	local backSpecialBtn = self.back_special:GetComponent('Button');
	if backSpecialBtn then
		local fun = function()
			self:OnClick_SpecialBtn();
		end
		self:AddButtonClickListener(backSpecialBtn, fun)
	end
	
	--
	local buyBtn = self.objBuy_Button:GetComponent('Button')
	if buyBtn then
		local fun = function()
			self:OnClick_Buy_Button();
		end
		self:AddButtonClickListener(buyBtn, fun)
	end

	--
	if self.objButton then
		local fun = function()
			self:PlayerSpineAni();
		end
		AddEventTrigger(self.objButton,fun)
	end

	--
	if self.objImageGift then
		local fun = function()
			self:OnClickImageGift();
		end
		self:AddButtonClickListener(self.objImageGift:GetComponent('Button'), fun);
	end

	if self.objImageLimitUp then
		local fun = function()
			self:OnClickImageLimitUp();
		end
		self:AddButtonClickListener(self.objImageLimitUp:GetComponent('Button'), fun);
	end

	if self.objImageFreeTask then
		local fun = function()
			self:OnClickImageFreeTask();
		end
		self:AddButtonClickListener(self.objImageFreeTask:GetComponent('Button'), fun);
	end

	if self.objChallengeOrderLock then
		local fun = function()
			OpenWindowImmediately("ChallengeOrderUI")
		end
		self:AddButtonClickListener(self.objChallengeOrderLock:GetComponent("Button"),fun)
	end

	local updateCreateRole = function(info)
		self.updateCreateRole = info
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_CREATE_ROLE)
    end

	local updateUnlockRole = function(info)
		self.updateUnlockRole = info
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_UNLOCK_ROLE)
	end
	
	local updateUnlockSkin = function(info)
		self.updateUnlockSkin = info
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_UNLOCK_SKIN)
    end

	self:AddEventListener("UPDATE_CREATE_ROLE", updateCreateRole)
	self:AddEventListener("UPDATE_UNLOCK_ROLE", updateUnlockRole)
	self:AddEventListener("UPDATE_UNLOCK_SKIN", updateUnlockSkin)
	self:AddEventListener("CHALLENGEORDER_UNLOCK", updateCreateRole)

	-- 捏脸数据上传成功事件
	self:AddEventListener(CreateFaceManager.UI_EVENT.UploadFaceDataSuccess, function()
		self.bShowCreateFace = true -- 自定义形象上传后 需显示捏脸数据
		self.comLoopScrollView:RefreshCells() -- 左侧角色头像
		self:SetCreateFaceButtonVisible(true)
	self:ChooseSkin(self.selectskin)-- 中间模型和立绘 
		self.bCreateFaceRole = true -- 不能播放人物音效
	end)
	-- 捏脸数据删除成功事件
	self:AddEventListener(CreateFaceManager.UI_EVENT.DeleteFaceDataSuccess, function()
		self.bShowCreateFace = false -- 不显示捏脸
		self.bCreateFaceRole = true -- 可以播放人物音效
		-- 再次刷新该界面 使得显示默认立绘和模型
		self:SetCreateFaceButtonVisible(true)
		self:ChooseSkin(self.selectskin) -- 中间模型和立绘
		self.comLoopScrollView:RefreshCells() -- 左侧角色头像
	end)
	
	self:AddEventListener('OPEN_WINDOW', function(windowName)
		if windowName == 'CreateFaceUI' then 
			RemoveWindowBar('CreateRoleUI')
		end
	end)

	self:AddEventListener('REMOVE_WINDOW', function(windowName)
		if windowName == 'CreateFaceUI' then 
			self:OpenCreateRoleWindowBar()
		end
	end)
end

-- 先加载一次数据，之后不用再次刷新。
function CreateRoleUI:InitUI()
	self.init_done = true
	self.selectrole = 0		-- 角色，C++ 数组
	self.selectskin = 1		-- 皮肤，Lua Table
	self._oldSkinIndex = nil
	self._audioIndex = 0
	self.need_reset_model = true	-- 是否需要重新加载模型
	if self.bIsBabyRole then
		self.role_name = self:GetRandomRoleName(self.selectrole)
	else
		self.role_name = "包子"
	end
	self.pass_name = self.role_name
	self.comInput_InputField.text = self.role_name
	self:RefreshData(self.selectrole)
end

function CreateRoleUI:_RefreshUI_help(info)
	info = info or globalDataPool:getData("CreateMainRole")
	if info.bIsBabyRole then
		self.createInfo = info
		self.bIsBabyRole = true
		self.need_reset_model = true
		RemoveWindowBar('CreateRoleUI')
	else
		local tempTable = {}
		for i = 0, info.iNum - 1 do
			if info.akRoles and info.akRoles[i] then
				local tbData = TableDataManager:GetInstance():GetTableData("CreateRole", info.akRoles[i].uiTypeID);
				if tbData and tbData.ClientHide == TBoolean.BOOL_NO then					
					if tbData.OwnDLC == TBoolean.BOOL_NO or DRCSRef.LogicMgr:GetInfo("dlc", 1) == 1 then					
						table.insert(tempTable, info.akRoles[i]);
					end
				end
			end
		end
		info.iNum = #(tempTable);
		info.akRoles = FormatTable(tempTable);
		self.createInfo = nil
		self.bIsBabyRole = false
	end
	local TB_CreateRole = TableDataManager:GetInstance():GetTable("CreateRole")
	local _sort = function(a, b)
		local isAUnlock = (a.uiUnlock[0] > 0)
		local isBUnlock = (b.uiUnlock[0] > 0)

		if isAUnlock == isBUnlock then
			if TB_CreateRole then
				local aSortIndex = 0
				local bSortIndex = 0

				if a.uiTypeID and TB_CreateRole[a.uiTypeID] then
					aSortIndex = TB_CreateRole[a.uiTypeID].SortIndex or 0
				end
				if b.uiTypeID and TB_CreateRole[b.uiTypeID] then
					bSortIndex = TB_CreateRole[b.uiTypeID].SortIndex or 0
				end

				return aSortIndex < bSortIndex
			else
				return false
			end
		elseif isAUnlock then
			return true
		end

		return false;
	end

	table.sort(info.akRoles, _sort);
	if self.unlockRoleTypeID then
		for k, v in pairs(info.akRoles) do
			if v.uiTypeID == self.unlockRoleTypeID then
				self.selectrole = k;
			end
		end
		self.unlockRoleTypeID = nil;
	end
end

function CreateRoleUI:_RefreshUI(info)
	info = info or globalDataPool:getData("CreateMainRole")
	if info.bIsBabyRole then
		self.createInfo = info
		self.bIsBabyRole = true
		self.need_reset_model = true
		RemoveWindowBar('CreateRoleUI')
	else
		local tempTable = {}
		for i = 0, info.iNum - 1 do
			if info.akRoles and info.akRoles[i] then
				local tbData = TableDataManager:GetInstance():GetTableData("CreateRole", info.akRoles[i].uiTypeID);
				if tbData and tbData.ClientHide == TBoolean.BOOL_NO then
					if tbData.OwnDLC == TBoolean.BOOL_NO or (DRCSRef.LogicMgr.GetInfo and DRCSRef.LogicMgr:GetInfo("dlc", 1) == 1) then
						table.insert(tempTable, info.akRoles[i])
					end
				end

			end
		end
		info.iNum = #(tempTable);
		info.akRoles = FormatTable(tempTable);
		self.createInfo = nil
		self.bIsBabyRole = false
	end

	local TB_CreateRole = TableDataManager:GetInstance():GetTable("CreateRole")
	local _sort = function(a, b)
		local isAUnlock = (a.uiUnlock[0] > 0)
		local isBUnlock = (b.uiUnlock[0] > 0)

		if isAUnlock == isBUnlock then
			if TB_CreateRole then
				local aSortIndex = 0
				local bSortIndex = 0

				if a.uiTypeID and TB_CreateRole[a.uiTypeID] then
					aSortIndex = TB_CreateRole[a.uiTypeID].SortIndex or 0
				end
				if b.uiTypeID and TB_CreateRole[b.uiTypeID] then
					bSortIndex = TB_CreateRole[b.uiTypeID].SortIndex or 0
				end

				return aSortIndex < bSortIndex
			else
				return false
			end
		elseif isAUnlock then
			return true
		end

		return false;
	end

	table.sort(info.akRoles, _sort);

	if self.unlockRoleTypeID then
		for k, v in pairs(info.akRoles) do
			if v.uiTypeID == self.unlockRoleTypeID then
				self.selectrole = k;
			end
		end
		self.unlockRoleTypeID = nil;
	end

	if self.comLoopScrollView and info and info["iNum"] then
		self.iNum = info["iNum"]
		self.comLoopScrollView.totalCount = math.ceil(info["iNum"] / 2);
		self.comLoopScrollView:RefreshCells()
		if self.init_done then
			self:RefreshData(self.selectrole)
		else
			self:InitUI()
		end
	else	-- 打开界面还没有数据
		self.comLoopScrollView.totalCount = 0
	end
end

function CreateRoleUI:RefreshUI(info)
	self.updateCreateRole = info or globalDataPool:getData("CreateMainRole")
	self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_CREATE_ROLE)
end

-- (网络下行、点击头像) 刷新创角数据
function CreateRoleUI:RefreshData(index, boolean_reset_skin)
	self.unlockRole = false
	self.unlockSkin = false
	self.selectrole = index
	self._oldSkinIndex = nil
	self._audioIndex = 0
	-- 先查询是否为捏脸角色
	local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo)
	local typedata = self:GetTypeData(info, self.selectrole)
	local iRoleTypeID =  typedata.OldRoleID
	local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
	self.bCreateFaceRole = (CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, iRoleTypeID) ~= nil and self.bShowCreateFace) and true or false
	StopSound(self.oldAudio)
	self:PlayRoleAudio(os.clock())
	if boolean_reset_skin then
		self.selectskin = 1
		self.need_reset_model = true
	end
	self:RefreshAbility(index)	-- 刷新能力			 --6ms
	self:RefreshSkin(index)		-- 刷新皮肤解锁情况  --45ms
	self:RefreshGiftPool(index)	-- 刷新天赋
	self:RefreshCondition(index, self.selectskin)-- 刷新购买条件
	if not boolean_reset_skin then	-- TODO BUG单【ID1081480】
		self.comLoopScrollView:SrollToCell(math.floor(index/2), 600) 
	end
end

function CreateRoleUI:RefreshCondition(index, skinIdx)
	local info = RoleDataManager:GetInstance():GetCreateRoleData(index, self.createInfo);
	local roleData = self:GetTypeData(info, index)

	self.lock = self:IsSkinLock(index, skinIdx)

	self.objChallengeOrderLock:SetActive(false)
	if self.lock then
		self.objAbilityRoll_Button:SetActive(false)
		self.objBuy_Button:SetActive(false);
		self.objInput:SetActive(false);
		self:SetCreateFaceButtonVisible(false)
		self.objCondition:SetActive(true);
		self.objPlay_Button:SetActive(true);
		local comTextTMP = self.objCondition:GetComponent('Text');		
		local ac_data = TableDataManager:GetInstance():GetTableData("Achieve", self.lock)
		comTextTMP.text = string.format("获得成就[%s]后解锁", GetLanguageByID(ac_data.NameID))
		self.objTextTMP.text = '未解锁'

		if self:IsChallengeOrderLock(info.uiTypeID) then
			self.objChallengeOrderLock:SetActive(true)
			self.objPlay_Button:SetActive(false)
		end
	else		
		if self:IsSkinLock(index, self.selectskin or 1) then
			self.objInput:SetActive(false);
			self:SetCreateFaceButtonVisible(false)
			self.objCondition:SetActive(false);
			self.objPlay_Button:SetActive(false);
			self.objBuy_Button:SetActive(true);
			local numText = self:FindChildComponent(self.objBuy_Button, 'Number', 'Text');
			local unlockCost = roleData.UnlockCost[self.selectskin];
			numText.text = unlockCost > 0 and unlockCost or roleData.UnlockCostSilver;	
		else
			if info.uiChild == 0 then
				self.objAbilityRoll_Button:SetActive(true)
			else
				self.objAbilityRoll_Button:SetActive(false)
			end

			self.objInput:SetActive(true);
			self:SetCreateFaceButtonVisible(true)
			self.objCondition:SetActive(false);
			self.objPlay_Button:SetActive(true);
			self.objBuy_Button:SetActive(false);
			self.objTextTMP.text = '开始游戏';
		end
	end

	if self.bIsBabyRole then
		self:SetCreateFaceButtonVisible(false)
		self.objTextTMP.text = '确认徒弟名';
	end
end

function CreateRoleUI:IsChallengeOrderLock(createRoleID)
	if not createRoleID then
		return false
	end

	local TB_PlusEditionConfig = TableDataManager:GetInstance():GetTable("PlusEditionConfig")
	if not TB_PlusEditionConfig then
		return false
	end

	if PlayerSetDataManager:GetInstance():IsChallengeOrderUnlock() then
		return false
	end

	local plusEditionConfig = TB_PlusEditionConfig[1]
	for index, lockCreateRoleID in ipairs(plusEditionConfig.LockCreateRole) do
		if lockCreateRoleID == createRoleID then
			return true
		end
	end

	return false
end

function CreateRoleUI:NoAchieve(achieveID)
	if AchieveDataManager:GetInstance():IsAchieveMade(achieveID) then
		return nil
	end
	return achieveID
end

function CreateRoleUI:IsSkinLock(roleIndex, skinIndex)
	local info = RoleDataManager:GetInstance():GetCreateRoleData(roleIndex, self.createInfo);
	if info then
		local roleData = TableDataManager:GetInstance():GetTableData("CreateRole",info.uiTypeID)
		if skinIndex == nil then
			for k, v in pairs(roleData.UnlockAchieve) do
				if v == 0 or self:NoAchieve(v) == nil then
					return false
				end
			end
			return true
		end
		local ua = roleData.UnlockAchieve[skinIndex]
		if ua ~= nil and ua ~= 0 then
			return self:NoAchieve(ua)
		end
		-- for kk, vv in pairs(info.uiUnlock) do
		-- 	if roleData.Models[skinIndex] == vv then
		-- 		return true;
		-- 	end
		-- end
	end

	return false;
end

-- 滚动栏发生了变化
function CreateRoleUI:OnScrollChanged(transform, idx)
	self.Role_Head_1 = self:FindChild(transform.gameObject, "Role_Head_1")
	self.Role_Head_2 = self:FindChild(transform.gameObject, "Role_Head_2")
	self:RefreshHead(self.Role_Head_1, idx*2)
	if (idx+1) * 2 > (self.iNum or 0) then
		self.Role_Head_2:SetActive(false)
	else
		self:RefreshHead(self.Role_Head_2, idx*2+1)
	end
	if not self.init and idx == 3 then
		self.init = true;
		self:ClickRoleHead();
	end
end

-- 刷新左侧 头像列表
function CreateRoleUI:RefreshHead(child, index)
	child:SetActive(true)
	local info = RoleDataManager:GetInstance():GetCreateRoleData(index, self.createInfo)
	if info == nil then 
		return
	end
	self.child_lock = self:FindChild(child,"lock")
	self.child_child = self:FindChild(child,"child")
	self.child_Text_child = self:FindChild(child,"Text_child")
	self.child_Mask_head = self:FindChildComponent(child,"head",'Image')

	if self:IsSkinLock(index, nil) then
		self.child_lock:SetActive(true)
		setHeadUIGray(self.child_Mask_head, true);
	else
		self.child_lock:SetActive(false)
		setHeadUIGray(self.child_Mask_head,false);
	end

	if info['uiChild'] == 0 then
		self.child_child:SetActive(false)
		self.child_Text_child:SetActive(false)
	else
		self.child_child:SetActive(true)
		self.child_Text_child:SetActive(true)
	end

	self.objChild_Name = self:FindChildComponent(child,"Name","Text")
	local typedata = self:GetTypeData(info, index)
	local selectrole_title = typedata['Title']
	if self.objChild_Name and selectrole_title then
		local uirank = (info.uiRank and info.uiRank > 0) and info.uiRank 
		local strName = GetLanguageByID(selectrole_title)
		local uiLevel = CardsUpgradeDataManager:GetInstance():GetRoleCardLevelByRoleBaseID(typedata.OldRoleID)
		if uiLevel and uiLevel > 0 then 
			strName = strName .. '+' .. uiLevel 
		end
		if not uirank then 
			uirank = RoleDataManager:GetInstance():GetRoleRankByTypeID(typedata.OldRoleID)
		end 

		self.objChild_Name.text = getRankBasedText(uirank,strName)
	else
		self.objChild_Name.text = ""
	end

	local kRoleModle = TableDataManager:GetInstance():GetTableData("RoleModel", typedata.Models[1])
	if kRoleModle then
		self.child_Mask_head.sprite = GetSprite(kRoleModle.Head)
	end
		-- TODO 捏脸12 头像
		local iRoleTypeId = typedata.OldRoleID
		local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
		local objParent = self:FindChild(child, "CreateHead")
		self.objCreateFace = self:FindChild(child, "CreateHead/Create_Head(Clone)")
	
		if CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, iRoleTypeId) and self.bShowCreateFace then
			if self.objCreateFace then
				self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeId, objParent, self.objCreateFace)
				self.objCreateFace:SetActive(true)
			else
				self.objCreateFace = CreateFaceManager:GetInstance():GetCreateFaceHeadImage(iStoryId, iRoleTypeId, objParent)
			end
			self.child_Mask_head.gameObject:SetActive(false)
		else
			if self.objCreateFace then
				self.objCreateFace:SetActive(false)
			end
			self.child_Mask_head.gameObject:SetActive(true)
		end
	self:SetToggleHeadState(child,index)
	self.comChild_Toggle = self:FindChildComponent(child, 'Image_button_target', 'Button');
	if self.comChild_Toggle then
		local fun = function()
			self:ClickRoleHead(index)
		end
		self:RemoveButtonClickListener(self.comChild_Toggle)
        self:AddButtonClickListener(self.comChild_Toggle, fun);
	end
end

function CreateRoleUI:UpdateAllToggleHeadState()
	for k, v in pairs(self.objContent.transform) do
		local obj1 = v.transform:GetChild(0).gameObject
		local index = tonumber(v.name)  * 2
		self:SetToggleHeadState(obj1,index)

		local obj2 = v.transform:GetChild(1).gameObject
		self:SetToggleHeadState(obj2,index + 1)
	end
end

function CreateRoleUI:SetToggleHeadState(child,index)
	if child then
		local objTog = self:FindChild(child, 'Toggle');
		local bNeedShow = index == self.selectrole
		if objTog and objTog.activeSelf ~= bNeedShow then
			local Child_name_back = self:FindChild(child, "name_back")
			local Child_Name = self:FindChild(child, "Name")
			local objImage = self:FindChild(child, "Image")
			objTog:SetActive(bNeedShow)
			Child_name_back:SetActive(bNeedShow)
			Child_Name:SetActive(bNeedShow)
			objImage:SetActive(not bNeedShow)
		end
	end
end

-- 点击左侧 角色头像 列表
function CreateRoleUI:ClickRoleHead(index)
	index = index or 0;
	if index ~= self.selectrole then
		self:RefreshData(index, true)
	end
	self:UpdateAllToggleHeadState()
end

-- 获取角色 称号
function CreateRoleUI:GetTypeData(info, index)	
	local table_index = info['uiTypeID']
	return TableDataManager:GetInstance():GetTableData("CreateRole",table_index) --索引就是baseid
end

-- 获取角色 性别
function CreateRoleUI:GetSex(index)
	index = index or self.selectrole
	local info = RoleDataManager:GetInstance():GetCreateRoleData(index, self.createInfo)
	if info and info['uiTypeID'] then
		local table_index = info['uiTypeID']
		local createRoleDataMap = TableDataManager:GetInstance():GetTable("CreateRole")
		for baseID, createRoleData in pairs(createRoleDataMap) do
			if baseID == table_index then
				return createRoleData['ModelFeMale']
			end
		end
	end
	return 0
end

-- TODO：刷新皮肤，这里应该动态设置
function CreateRoleUI:RefreshSkin(index)
	local info = RoleDataManager:GetInstance():GetCreateRoleData(index, self.createInfo)
	local typedata = self:GetTypeData(info, index)

	-- 换模型的时候还需要这些数据，所以记在 self 里面
	self.models_count = 0
	self.models = typedata['Models']
	self.roleTypeID = typedata.OldRoleID
	if self.models then self.models_count = #self.models end
	if self.models_count == 0 then
		self.objSpine:SetActive(false)
	end
	-----[todo] 40ms begin sqt
	local Local_TB_RoleModel = TableDataManager:GetInstance():GetTable("RoleModel")
	for i = 1, #self.array_objSkin do
		local comSkin_child_Toggle = self.array_objSkin[i]:GetComponent('Toggle')
		if i > self.models_count then
			self.array_objSkin[i]:SetActive(false)
		else
			local RoleModelData = Local_TB_RoleModel[self.models[i]]
			if not RoleModelData then
				derror("没有找到角色模型数据",self.models[i])
				self.array_objSkin[i]:SetActive(false)
				return
			end
			self.array_objSkin[i]:SetActive(true)
			local comSkin_child_normal_Image = self:FindChildComponent(self.array_objSkin[i], "normal", 'Image')
			local comSkin_child_toggle_Image = self:FindChildComponent(self.array_objSkin[i], "toggle", 'Image')
			local objSkin_child_normal_lock = self:FindChild(self.array_objSkin[i], "normal/lock")
			local objSkin_child_toggle_lock = self:FindChild(self.array_objSkin[i], "toggle/lock")
			local final_color = stringToColor(RoleModelData['Hue'])
			comSkin_child_normal_Image.color = final_color
			comSkin_child_toggle_Image.color = final_color

			-- TODO 首先需要判断服务端的皮肤解锁数据
			if self:IsSkinLock(self.selectrole, i) then
				objSkin_child_normal_lock:SetActive(true);
			else
				objSkin_child_normal_lock:SetActive(false);
			end

			-- 皮肤初始化选择，更换角色时需要将皮肤重置
			if i == self.selectskin then 

				if self:IsSkinLock(self.selectrole, i) then
					objSkin_child_toggle_lock:SetActive(true);
				else
					objSkin_child_toggle_lock:SetActive(false);
				end
				
				if comSkin_child_Toggle.isOn then
					self:ChooseSkin(self.selectskin)
				else
					comSkin_child_Toggle.isOn = true
				end

			end
			
		end
	end
	----[todo] 40ms end
	self:PlayerSpineAni()
end

function CreateRoleUI:ChooseSkin(index)

	if not (index and self.models and self.models[index]) then 
		derror("传入数据错误",index, self.models)
		return
	end
	self.selectskin = index

	--  直接检测是否有捏脸数据 self.roleTypeID

	local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
	if CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId, self.roleTypeID) and self.bShowCreateFace then
		-- TODO 捏脸11 立绘
		if self.objCreateCG then
			self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, self.roleTypeID, self.objCreateCGParent, self.objCreateCG)
			self.objCreateCG:SetActive(true)
		else
			self.objCreateCG = CreateFaceManager:GetInstance():GetCreateFaceCGImage(iStoryId, self.roleTypeID, self.objCreateCGParent)
		end
		self.comContent_CG.gameObject:SetActive(false)
		-- TODO 捏脸10 模型
		self.rolemodelid = CreateFaceManager:GetInstance():GetModelIdByStoryIDAndRoleId(iStoryId, self.roleTypeID)
		self.need_reset_model = true
	else
		if self.objCreateCG then
			self.objCreateCG:SetActive(false)
		end
		self.comContent_CG.gameObject:SetActive(true)
		self.rolemodelid = self.models[index]
		self.need_reset_model = true
	end

	local RoleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", self.rolemodelid)
	if not (RoleModelData and RoleModelData['Model']) then
		derror("没有找到角色模型数据",self.rolemodelid)
		self.objSpine:SetActive(false)
		return
	end

	self.comContent_CG.sprite = GetSprite(RoleModelData['Drawing'])

	if self.need_reset_model then
		-- 如果是换角色了，则需要用下面这个
		local result = DynamicChangeSpine(self.objSpine,RoleModelData['Model'])
		self.objSpine_Texture =  ChnageSpineSkin(self.objSpine,RoleModelData['Texture'])
		self.objSpine:SetActive(result)
		self.need_reset_model = false

		--CG动画
		local rectTransform = self.comContent_CG:GetComponent("RectTransform")
		rectTransform.localScale = DRCSRef.Vec3(-0.66,0.66,1)
		self.comContent_CG.transform.transform:DOScale(DRCSRef.Vec3(-0.8,0.8,1),0.3):SetEase(DRCSRef.Ease.OutBack):From()
		--Twn_Scale(nil, self.comContent_CG,DRCSRef.Vec3(-0.8,0.8,1), DRCSRef.Vec3(-0.66,0.66,1), 0.3, DRCSRef.Ease.OutBack)
		if self.objCreateCG then
			self.objCreateCG.transform:DOScale(DRCSRef.Vec3(-0.8,0.8,1),0.3):SetEase(DRCSRef.Ease.OutBack):From()
		end
	elseif self.objSpine.activeSelf then
		self.objSpine_Texture = ChnageSpineSkin(self.objSpine,RoleModelData['Texture'])

	end



	local skinTagData = TableDataManager:GetInstance():GetTableData("RoleSkinTag",self.rolemodelid) or {}
	if skinTagData.Gift and next(skinTagData.Gift) then
		self.objImageGift:SetActive(true);
		self.giftTips = TipsDataManager:GetInstance():GetRoleGiftTips(skinTagData.Gift);
		self.giftTips.title = '特殊天赋';
	else
		self.objImageGift:SetActive(false);
	end
	if skinTagData.LimitUp and next(skinTagData.LimitUp) then
		self.objImageLimitUp:SetActive(true);
		self.limitUpTips = {
			title = '特殊上限',
			content = '这个是特殊上限',
		}
	else
		self.objImageLimitUp:SetActive(false);
	end
	
	if skinTagData.FreeTask and skinTagData.FreeTask > 0 then
		self.objImageFreeTask:SetActive(true);
		self.freeTaskTips = {
			title = '畅想任务',
			content = '选择该主角，可以体验与默认剧情不同的专属角色剧情。',
		}
	else
		self.objImageFreeTask:SetActive(false);
	end

	if skinTagData.WeaponList then
		local weapon = skinTagData.WeaponList[1];
		if #(skinTagData.WeaponList) > 1 then
			local rIndex = math.random(1, #(skinTagData.WeaponList));
			weapon = skinTagData.WeaponList[rIndex];
		end 
		self.weapon = weapon
	else
		self.weapon = nil
	end

	-- local scale = DRCSRef.Vec3One
    -- if RoleModelData.ModelID > 0 then
    --     scale = self.SpineRoleUI:GetRoleWeaponScale(RoleModelData.ModelID)
	-- end
	
	-- self.SpineRoleUI:SetEquipItem(self.objSpine, {itemID = self.weapon, uiEnhanceGrade = 0} ,nil,scale); -- 10ms
end

local lPlayAni = {
	"attack_f_001","attack_f_002","attack_f_101",
	"attack_l_001","attack_l_002","attack_l_101",
	"attack_r_001","attack_r_002","attack_r_101",
	"attack_s_001","attack_s_002","attack_s_101",
}
function CreateRoleUI:PlayerSpineAni()
	self.aniPalyTime = os.clock();
	local skeletonAnimation = self.objSpine:GetComponent('SkeletonAnimation');
	local attackList = {};
	local spineAnimaitionData = TableDataManager:GetInstance():GetTableData("SpineAnimaitionTime", self.rolemodelid)
	if spineAnimaitionData then
		for key, value in ipairs(lPlayAni) do
			if  spineAnimaitionData[value] then
				local spineaniminfo = self.SpineRoleUI:GetAnimInfoByName(value,self.rolemodelid,spineAnimaitionData)
				table.insert(attackList, spineaniminfo);
			end
		end
	end
	if #attackList == 0 then return end 

    if (not self.aniIndex) or (self.aniIndex >= #(attackList)) then
        self.aniIndex = 0;
    end
	self.aniIndex = self.aniIndex + 1;
	-- if self.weapon then 
	-- 	self.SpineRoleUI:SetEquipItemEX(self.objSpine,self.rolemodelid, {itemID = self.weapon, uiEnhanceGrade = 0} ,attackList[self.aniIndex])
	-- end
	local prepareName = "prepare"
	local animName = attackList[self.aniIndex]['oldActionName']
	
	local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo);
	if info then
		local createRoleInfo  = TableDataManager:GetInstance():GetTableData("CreateRole",info.uiTypeID)
		if createRoleInfo and createRoleInfo[animName] ~= 0 then 
			PlaySound(createRoleInfo[animName])
		end
	end

	SetSkeletonAnimation(skeletonAnimation, 0, animName, false, function()
		if not attackList[self.aniIndex] then return end
		if self.weapon then 
			local scale = DRCSRef.Vec3One
			local RoleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", self.rolemodelid)
			if RoleModelData and RoleModelData.ModelID > 0 then
				scale = self.SpineRoleUI:GetRoleWeaponScale(RoleModelData.ModelID)
			end
			attackList[self.aniIndex]['action'] = 'prepare'
			self.SpineRoleUI:SetEquipItemEX(self.objSpine,self.rolemodelid, {itemID = self.weapon, uiEnhanceGrade = 0},attackList[self.aniIndex]);
		else
			self.SpineRoleUI:SetEquipItemEX(self.objSpine,self.rolemodelid, nil,attackList[self.aniIndex]);
		end
		
		if skeletonAnimation == nil or skeletonAnimation.AnimationState == nil then
			return
		end
		skeletonAnimation.AnimationState:AddAnimation(0, attackList[self.aniIndex]['prepare'], true, 0)
	end)
end

-- 刷新中间 角色名字
function CreateRoleUI:RefreshName(index)
	self.role_name = self:GetRandomRoleName(index)
	self.comInput_InputField.text = self.role_name
	self.pass_name = self.role_name
end

function CreateRoleUI:GetRandomRoleName(index)
	index = index or self.selectrole
	self.selectrole_sex = self:GetSex(index)
	dprint("当前角色性别：",self.selectrole_sex)
	self.family_id = nil
	self.family_name = nil
	self.first_id = nil
	self.first_name = nil
	local TB_RoleName = TableDataManager:GetInstance():GetTable("RoleName")
	for int_i = 1, #TB_RoleName do
		if TB_RoleName[int_i].RoleNameType == TextType.RNT_FamilyName then
			self.family_id = math.random( TB_RoleName[int_i].MinTextID, TB_RoleName[int_i].MaxTextID)
			self.family_name = GetLanguageByID(self.family_id)
			dprint("姓：",self.family_id, self.family_name)
		elseif TB_RoleName[int_i].RoleNameType == TextType.RNT_FristName and
		   TB_RoleName[int_i].Sex == self.selectrole_sex then
			self.first_id = math.random( TB_RoleName[int_i].MinTextID, TB_RoleName[int_i].MaxTextID)
			self.first_name = GetLanguageByID(self.first_id)
			dprint("名：",self.first_id, self.first_name)
		-- elseif TB_RoleName[int_i].RoleNameType == TextType.RNT_FullName and
		--    TB_RoleName[int_i].Sex == self.selectrole_sex then
		-- 	self.first_id = math.random( TB_RoleName[int_i].MinTextID, TB_RoleName[int_i].MaxTextID)
		-- 	self.first_name = GetLanguageByID(self.first_id)
		-- 	self.family_name = ''
		end
		if self.family_name and self.first_name then
			return self.family_name .. self.first_name		-- todo：英文的话要反过来拼写
		end
	end
	-- 循环结束后还没找到 姓 + 名
	return ""
end

-- 隐藏所有属性界面节点
function CreateRoleUI:HideAllAttrNode()
	for _, objAttrNode in ipairs(self.attrNodesPool) do 
		objAttrNode:SetActive(false)
	end
end

-- 获取可用的属性界面节点
function CreateRoleUI:GetAvaliableAttrNode(objParent)
	local objAvaliableAttrNode = nil
	for _, objAttrNode in ipairs(self.attrNodesPool) do 
		if not objAttrNode.activeSelf then 
			objAvaliableAttrNode = objAttrNode
			break
		end
	end
	if not objAvaliableAttrNode then 
		objAvaliableAttrNode = LoadPrefabAndInit("Module/CreateRoleAttrNode")
		table.insert(self.attrNodesPool, objAvaliableAttrNode)
	end
	objAvaliableAttrNode:SetActive(true)
	if objParent then 
		objAvaliableAttrNode.transform:SetParent(objParent.transform)
		objAvaliableAttrNode:SetObjLocalScale(1, 1, 1)
		objAvaliableAttrNode:SetObjLocalPosition(0, 0, 0)
	end
	return objAvaliableAttrNode
end

-- 属性类型反查属性名
function CreateRoleUI:GetAttrName(attrType)
	if attrType and l_attrTypeToAttrNameMap and l_attrTypeToAttrNameMap[attrType] then 
		return l_attrTypeToAttrNameMap[attrType]
	end
	return ''
end

-- 获取创角数据的属性最大值
function CreateRoleUI:GetCreateRoleMaxAttrValue(createRoleData, attrType)
	local rangeAttrKeyName = rangeAttrDataKeyMap[attrType]
	local createRoleBaseID = createRoleData['uiTypeID']
	local tbCreateRole = TableDataManager:GetInstance():GetTableData("CreateRole", createRoleBaseID)
	if not (tbCreateRole and tbCreateRole[rangeAttrKeyName]) then 
		return 0
	end
	return tbCreateRole[rangeAttrKeyName].MaxValue or 0
end

-- 刷新右侧能力数据
function CreateRoleUI:RefreshAbility(index)
	local createRoleData = RoleDataManager:GetInstance():GetCreateRoleData(index, self.createInfo)
	if not (createRoleData and createRoleData.akAttrs) then 
		return 
	end
	self:HideAllAttrNode()
	for i = 1, createRoleData.uiAttrCount do
		local attrData = createRoleData.akAttrs[i - 1]
		if attrData then 
			local objAttrParentNode = nil
			if RoleDataManager:GetInstance():IsBasicAttr(attrData.uiAttrType) then
				objAttrParentNode = self.objBasicAttrBox
			else
				objAttrParentNode = self.objMartialAttrBox
			end
			local objAttrNode = self:GetAvaliableAttrNode(objAttrParentNode)
			local comAttrScrollBar = self:FindChildComponent(objAttrNode, "Scrollbar", "Scrollbar")
			local attrName = self:GetAttrName(attrData.uiAttrType)
			local createRoleMaxAttrValue = self:GetCreateRoleMaxAttrValue(createRoleData, attrData.uiAttrType)
			self:RefreshScrollbar(comAttrScrollBar, attrData.iAttrValue, createRoleMaxAttrValue, self:GetShowAttrMaxValue(attrName))
			local comAttrNameText = self:FindChildComponent(objAttrNode, "Text", "Text")
			if comAttrNameText then 
				comAttrNameText.text = attrName
			end 
		end
	end
end

function CreateRoleUI:SetWidth(ui, width)
	local rt = ui:GetComponent("RectTransform")
	rt:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, width)
end

-- 刷新一个能力条，传入Scrollbar
function CreateRoleUI:RefreshScrollbar(comAttrScrollBar, value, maxval, unimax)
	-- 灰色部分长度
	local objScrollbar = comAttrScrollBar.gameObject
	comAttrScrollBar.size = math.min(maxval / unimax, 1)
	local scrollbar_length = objScrollbar:GetComponent("RectTransform").rect.width
    local handle = self:FindChild(objScrollbar,"Sliding Area/Handle")
    local green = self:FindChild(objScrollbar,"Sliding Area/green")
    local yellow = self:FindChild(objScrollbar,"Sliding Area/yellow")
    local orange = self:FindChild(objScrollbar,"Sliding Area/orange")
    local red = self:FindChild(objScrollbar,"Sliding Area/red")
	local objTMP_Value = self:FindChildComponent(objScrollbar, "TMP_Value", "Text")
	objTMP_Value.text = string.format("%d", value)
	if value > maxval then
		green:SetActive(false)
		yellow:SetActive(true)
		orange:SetActive(true)
		red:SetActive(true)
		local extra_length = (value-maxval)/maxval * comAttrScrollBar.size * scrollbar_length
		self:SetWidth(orange, 	extra_length)
		self:SetWidth(red, 		extra_length)
		self:SetWidth(yellow,  	comAttrScrollBar.size * scrollbar_length)
	elseif value == maxval then
		green:SetActive(false)
		yellow:SetActive(true)
		orange:SetActive(false)
		red:SetActive(false)
		self:SetWidth(yellow,  	comAttrScrollBar.size * scrollbar_length)
	else
		green:SetActive(true)
		yellow:SetActive(false)
		orange:SetActive(false)
		red:SetActive(false)
		self:SetWidth(green, value/maxval * comAttrScrollBar.size * scrollbar_length)
	end
end

-- 刷新右下角天赋
function CreateRoleUI:RefreshGiftPool(index)
	local info = RoleDataManager:GetInstance():GetCreateRoleData(index, self.createInfo)
	if not (info and info['uiGifts']) then
		dprint("Error，数据中没有 uiGifts".. index)
		return
	end
	self.aiCurGift = table_c2lua(info['uiGifts'])

	for i = #self.aiCurGift , 2, -1 do
		if self.aiCurGift [i] == 0 then
			table.remove(self.aiCurGift, i)
		end
	end
	if info.uiChild then
		local fun = function (a ,b)
			if aiBabayGift[a] then
				return true
			end
			return false
		end
		table.sort(self.aiCurGift, fun)
	end
	
	if self.LoopScrollView_Gift then
		if self.aiCurGift[1] == 0 then
			self.LoopScrollView_Gift:ClearCells()	
		else
			self.LoopScrollView_Gift.totalCount = getTableSize(self.aiCurGift)
			self.LoopScrollView_Gift:RefillCells()
		end
    end 
	
end

function CreateRoleUI:OnScrollChangedGift(transform, index)
	local giftID = self.aiCurGift[index + 1]
	dprint("创建天赋，giftID为：", giftID)
	local _Gift = TableDataManager:GetInstance():GetTableData("Gift", giftID)
	if giftID and giftID ~= 794 and giftID ~= 616 and giftID ~= 77 and _Gift  then
		local title = self:FindChildComponent(transform.gameObject, "TMP_title", "Text")
		local value = self:FindChildComponent(transform.gameObject, "Value","Text")
		local talentTitle = GetLanguagePreset(_Gift.NameID,"天赋名".._Gift.NameID)
		local talentContent = GetLanguagePreset(_Gift.DescID,"天赋描述".._Gift.DescID)
		transform.gameObject:SetActive(true)


		dprint(GetLanguageByID(_Gift.NameID))
		
		--给文字变个色
		talentTitle = getRankBasedText(_Gift.Rank, talentTitle)

		title.text = talentTitle

		value.text  = talentContent
		--value.color = getRankColor(_Gift.Rank)
		--因为只有悬浮显示的tipsPopUI上面需要显示 “(角色独有)” 的文字 所以在这里先将CreateRoleUI上的文本信息先赋值然后再改talentTitle
		if int_i == 1 then
			talentTitle = talentTitle .. '<color=#FF0000> (角色独有)</color>'
		end

		local comReturnUIAction = transform:GetComponent("LuaUIAction")
		if comReturnUIAction then
			local fun = function()
				local tips={
					title = talentTitle,
					content = talentContent,
					isSkew = true,
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
end


function CreateRoleUI:OnClick_SpecialBtn()
	local aiGift = {}
	for key, giftID in pairs(self.aiCurGift) do
		local _Gift = TableDataManager:GetInstance():GetTableData("Gift", giftID)
		if giftID and giftID ~= 794 and giftID ~= 616 and giftID ~= 77 and _Gift  then
			table.insert(aiGift, giftID);
		end
	end
	local tips = TipsDataManager:GetInstance():GetRoleGiftTips(aiGift)
	local spGift = string.match(tips.content, '(<.-color>)');
	tips.content = string.gsub(tips.content, spGift, spGift .. '<color=#FF0000> (角色独有)</color>');
	OpenWindowImmediately("TipsPopUI", tips)	
end

function CreateRoleUI:OnClick_Ability_Roll_Button()
	local info = globalDataPool:getData("CreateMainRole")
	local uiID = info['akRoles'][self.selectrole]['uiTypeID']
	dprint("当前随机属性角色ID：",uiID)
	local data = EncodeSendSeGC_ClickCreateRoleRandomAttr(uiID)
	local iSize = data:GetCurPos()
	NetGameCmdSend(SGC_CLICK_RANDOM_ATTR, iSize, data)
	self._click_dice = true
end

function CreateRoleUI:OnClick_Play_Button()
	if self.pass_name == self.role_name then
		self:OnBeginEnterGame()
		return
	end
	if self.fail_name then
		SystemUICall:GetInstance():Toast(self.err_log)
		return
	end
	SystemUICall:GetInstance():Toast("正在检查姓名，请稍等")
end

function CreateRoleUI:OnClick_Buy_Button()
	--原始角色没解锁 不让买皮肤
	if self.selectskin ~= 1 and self:IsSkinLock(self.selectrole, 1) then
		SystemUICall:GetInstance():Toast('请先解锁角色');
		return
	end

	
	local mainRoleInfo = globalDataPool:getData("MainRoleInfo");
	local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole)
	local typedata = self:GetTypeData(info, self.selectrole)
	
	local strTips = '是否耗费银锭解锁该皮肤?';
	local _netMessage = function()
		if self.unlockRole then
			dprint('需要购买')
			local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole);
			local submitData = EncodeSendSeGC_ClickUnlockRole(info.uiTypeID);
			local iSize = submitData:GetCurPos();
			NetGameCmdSend(SGC_CLICK_UNLOCK_ROLE, iSize, submitData);
			self.unlockRole = false;
			self.unlockRoleTypeID = info.uiTypeID;
		end
		if self.unlockSkin then
			dprint('需要解锁')
			local modelID = typedata.Models[self.selectskin];
			local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole);
			local submitData = EncodeSendSeGC_ClickUnlockSkin(info.uiTypeID, modelID);
			local iSize = submitData:GetCurPos();
			NetGameCmdSend(SGC_CLICK_UNLOCK_SKIN, iSize, submitData);
			self.unlockSkin = false;
			self.unlockSkinIndex = self.selectskin;
		end
	end
	local silver = mainRoleInfo.MainRole[MRIT_SILVER]
	local needSilver = 0;
	if self.unlockRole then
		needSilver = typedata.UnlockCostSilver;
	end
	if self.unlockSkin then
		needSilver = typedata.UnlockCost[self.selectskin];
	end
	if silver < needSilver then
		PlayerSetDataManager:GetInstance():RequestSpendSilver(needSilver, _netMessage)
	else
		OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strTips, _netMessage});
	end
end

function CreateRoleUI:OnRefUnlockRole(data)
end

function CreateRoleUI:OnRefUnlockSkin(data)
end

function CreateRoleUI:OnDestroy()
	if self.objButton then
		RemoveEventTrigger(self.objButton)
	end
	-- if self.TencentShareButtonGroupUI then
	-- 	self.TencentShareButtonGroupUI:Close();
	-- end
	self.comInput_InputField.onEndEdit:RemoveAllListeners()
end

function CreateRoleUI:PlayRoleAudio(curTime)
	self.audioTime = curTime
	local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole)
	if not info then return end 
	local table_index = info['uiTypeID']
	local createRoleInfo = TableDataManager:GetInstance():GetTableData("CreateRole", table_index)
	if createRoleInfo and createRoleInfo.Audios and #createRoleInfo.Audios > 0 then 
		self._audioIndex = self._audioIndex or 0
		self._audioIndex = (self._audioIndex) % (#createRoleInfo.Audios) + 1
		StopSound(self.oldAudio)
		self.oldAudio = createRoleInfo.Audios[self._audioIndex]
		self.audioTime = self.audioTime + PlaySound(self.oldAudio) / 1000
	end
end


local hasFlag = HasFlag
function CreateRoleUI:Update(deltaTime)
	local curTime = os.clock()
    if curTime - self.aniPalyTime >= 3 then
        self:PlayerSpineAni();
	end

	if self.audioTime and curTime - self.audioTime > 10 then 
		self:PlayRoleAudio(curTime)
	end
	
	if self.iUpdateFlag ~= 0 then
		if self._click_dice then 
			self._click_dice = false
			self.iUpdateFlag = 0
			self:_RefreshUI_help(self.updateCreateRole)
			self:RefreshAbility(self.selectrole)	-- 刷新能力			 --6ms
			self:RefreshGiftPool(self.selectrole)	-- 刷新天赋
			return
		end
		if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_CREATE_ROLE) then
			self:_RefreshUI(self.updateCreateRole)
        end

		if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_UNLOCK_ROLE) then
			self:OnRefUnlockRole(self.updateUnlockRole)
		end
		
		if  hasFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_UNLOCK_SKIN) then
			self:OnRefUnlockSkin(self.updateUnlockSkin)
		end
		
		self.iUpdateFlag = 0
	end
end

function CreateRoleUI:CheckNameResult(name,ret)
	self.unLayName[name] = ret
end

function IsForbid(str)
	for k = 1, #forbidTexts do
		if string.find(str, forbidTexts[k]) then
			return true
		end
	end
	return false
end
function CreateRoleUI:CheckResult(ok)	
	if ok then
		self.pass_name = self.checking_name
	else
		self.fail_name = self.checking_name
		self.err_log = "姓名中包含敏感词汇"
		SystemUICall:GetInstance():Toast(self.err_log)--
		self.comInput_InputField.text = "*"
	end
	self.checking_name = nil
end

function CreateRoleUI:check_rolename(string_name)
	string_name = string_name or ''
	
	self.comInput_InputField.text = string_name
	if self.checking_name == string_name then
		return
	end
	if self.pass_name == string_name then
		return
	end
	self.comInput_InputField.text = "*"
	if self.fail_name == string_name then
		SystemUICall:GetInstance():Toast(self.err_log)
		return
	end
	if WEGAME then
		self.checking_name = string_name	
		self.fail_name = nil
		self.comInput_InputField.text = string_name
		SendCheckInvalidName(self.role_name)
	else
		self.fail_name = string_name
		if string.len(string_name) == 0 then
			self.err_log = "姓名不可为空"
			--SystemUICall:GetInstance():Toast(self.err_log)
			return
		elseif string.len(string_name) > 12 then
			self.err_log = "姓名不可以超过四个字"
			--SystemUICall:GetInstance():Toast(self.err_log)
			return
		elseif string.find(string_name,' ') then
			self.err_log = "姓名中不可以有空格"
			--SystemUICall:GetInstance():Toast(self.err_log)
			return
		elseif IsNotAllSimpleChinese(string_name) then
			self.err_log = "姓名只能使用简体中文"
			--SystemUICall:GetInstance():Toast(self.err_log)
			return
		elseif IsForbid(string_name) then
			self.err_log = "姓名中包含敏感词汇"
			--SystemUICall:GetInstance():Toast(self.err_log)--
			return
		end
			
		self.fail_name = nil
		self.pass_name = string_name
		self.comInput_InputField.text = string_name
	end
end

function CreateRoleUI:OnBeginEnterGame()
	if self.lock then
	elseif self.bIsBabyRole then
		local info = RoleDataManager:GetInstance():GetCreateRoleData(0, self.createInfo)
		SendClickGetBabyClose()
		SendClickCreateBaby(info.uiBabyStateID, self.role_name)
		RemoveWindowImmediately("CreateRoleUI",false)
	else
		local info = globalDataPool:getData("CreateMainRole")
		local infoCreateRole = globalDataPool:getData("CreateMainRoleInfo") or {}
		infoCreateRole['uiTypeID'] = info['akRoles'][self.selectrole]['uiTypeID']
		infoCreateRole['strName'] = self.role_name
		infoCreateRole['roleModelID'] = self.rolemodelid
		globalDataPool:setData("CreateMainRoleInfo",infoCreateRole,true)
		OpenWindowByQueue("DifficultyUI")
		RemoveWindowImmediately("CreateRoleUI",false)
	end
	MSDKHelper:SendAchievementsData('create')
end

function CreateRoleUI:OnClickImageGift()
	OpenWindowImmediately("TipsPopUI", self.giftTips);
end

function CreateRoleUI:OnClickImageLimitUp()
	OpenWindowImmediately("TipsPopUI", self.limitUpTips);	
end

function CreateRoleUI:OnClickImageFreeTask()
	OpenWindowImmediately("TipsPopUI", self.freeTaskTips);	
end

function CreateRoleUI:SetCreateFaceButtonVisible(bIsShow)
	self.objResetFaceButton:SetActive(false)
	if bIsShow and CreateFaceManager:GetInstance():IsOpenCreateFace() then
		self.objCreateFaceButton:SetActive(true)
		-- 如果已经有捏脸数据则显示重置按钮
		local info = RoleDataManager:GetInstance():GetCreateRoleData(self.selectrole, self.createInfo)
		local iStoryId = (GetGameState() == -1) and 0 or GetCurScriptID()
		local typedata = self:GetTypeData(info, self.selectrole)
		local iRoleTypeID =  typedata.OldRoleID
		local kFaceData = CreateFaceManager:GetInstance():GetFaceDataByStoryIDAndRoleId(iStoryId,iRoleTypeID) 
		if kFaceData and kFaceData.uiRoleID~=0 then
			self.objResetFaceButton:SetActive(true)
		end
	else
		self.objCreateFaceButton:SetActive(false)
	end
end

function CreateRoleUI:GetShowAttrMaxValue(attrName)
	if (not showAttrMaxValueConfigName) or (not showAttrMaxValueConfigName[attrName]) then 
		return 0
	end
	return PlayerSetDataManager:GetInstance():GetSingleFieldConfig(showAttrMaxValueConfigName[attrName]) or 0
end

return CreateRoleUI