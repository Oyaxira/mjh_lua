PlayerSetUI = class("PlayerSetUI",BaseWindow)
local AccountInfoCom = require 'UI/PlayerSet/AccountInfoUI'
local SystemSettingCom = require 'UI/PlayerSet/SystemSettingUI'

local childCom = {
	none = 0,
	accountInfoCom = 1,
	systemSettingCom = 2,
	--todo 阵容
}

function PlayerSetUI:ctor()

end

function PlayerSetUI:OnPressESCKey()
    if self.Button_back and not KeyboardManager:GetInstance():IsWaittingPresskey() then
	    self.Button_back.onClick:Invoke()
    end
end

function PlayerSetUI:Create()
	local obj = LoadPrefabAndInit("PlayerSetUI/PlayerSetUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function PlayerSetUI:Init()
	--启动特权
	self.WX_Privilege_bt_obj = self:FindChild(self._gameObject, 'TransformAdapt_node_left/WX_Privilege', 'Button')
	self.QQ_Privilege_bt_obj = self:FindChild(self._gameObject, 'TransformAdapt_node_left/QQ_Privilege', 'Button')
	self.WX_Privilege_bt_com = self:FindChildComponent(self._gameObject, 'TransformAdapt_node_left/WX_Privilege', 'Button')
	self.QQ_Privilege_bt_com = self:FindChildComponent(self._gameObject, 'TransformAdapt_node_left/QQ_Privilege', 'Button')

	if IsValidObj(self.QQ_Privilege_bt_obj) then
		local openQQBox = function()
			MSDKHelper:OpenUrl("https://speed.gamecenter.qq.com/pushgame/v1/inner-game/privilege?launchqq=1")
		end
		self:AddButtonClickListener(self.QQ_Privilege_bt_com, openQQBox)
	end

	if IsValidObj(self.WX_Privilege_bt_obj) then
		local openWXBox = function()
			OpenWindowImmediately("WXPrivilegeBox")
		end
		self:AddButtonClickListener(self.WX_Privilege_bt_com, openWXBox)
	end

	-- 暂时屏蔽一些A级平台能力入口
	self.QQ_Privilege_bt_obj:SetActive(false)
	self.WX_Privilege_bt_obj:SetActive(false)
	-- setUIGray(self.QQ_Privilege_bt_obj:GetComponent("Image"),true)
	-- setUIGray(self.WX_Privilege_bt_obj:GetComponent("Image"),true)


	self.Account_box = self:FindChild(self._gameObject,"Account_box")
	self.SystemSet_box = self:FindChild(self._gameObject,"SystemSet_box")

	self.SystemSettingCom = SystemSettingCom.new(self.SystemSet_box)

	self.comServiceSetting_Button = self:FindChildComponent(self._gameObject,"SystemSet_box/Button_Tencent_KF", "Button")
	if (self.comServiceSetting_Button) then
        local fun = function()
            MSDKHelper:OpenServiceUrl("Activity")
        end
        self:AddButtonClickListener(self.comServiceSetting_Button, fun)
    end

	self.Toggle_Account = self:FindChildComponent(self._gameObject,"WindowTabUI/TransformAdapt_node_right/Tab_box/Toggle_account","Toggle")
	if IsValidObj(self.Toggle_Account) then
		local fun = function(bool)
			if bool then
				self:OnClick_Toggle_Account()
			end
		end
		self:AddToggleClickListener(self.Toggle_Account,fun)
	end

	self.Toggle_Battle = self:FindChildComponent(self._gameObject,"WindowTabUI/TransformAdapt_node_right/Tab_box/Toggle_battle","Toggle")
	if IsValidObj(self.Toggle_Battle) then
		local fun = function(bool)
			if bool then
				self:OnClick_Toggle_Battle()
			end
		end
		self:AddToggleClickListener(self.Toggle_Battle,fun)
	end

	self.Toggle_Setting = self:FindChildComponent(self._gameObject,"WindowTabUI/TransformAdapt_node_right/Tab_box/Toggle_setting","Toggle")
	if IsValidObj(self.Toggle_Setting) then
		local fun = function(bool)
			if bool then
				self:OnClick_Toggle_Setting()
			end
		end
		self:AddToggleClickListener(self.Toggle_Setting,fun)
	end

	self.Button_back = self:FindChildComponent(self._gameObject,"TransformAdapt_node_left/Button_back","Button")
	if IsValidObj(self.Button_back) then
		local fun = function()
			self:OnClick_BackButton()
		end
		self:AddButtonClickListener(self.Button_back,fun)
	end

	self.Button_close = self:FindChildComponent(self._gameObject,"Button_close","Button")
	if IsValidObj(self.Button_close) then
		local fun = function()
			self:OnClick_BackButton()
		end
		self:AddButtonClickListener(self.Button_close,fun)
	end

	self.comService_Button = self:FindChildComponent(self._gameObject, "Account_box/TencentShareButtonGroupUI/TransformAdapt_node/Button_Tencent_KF", "Button")
    if (self.comService_Button) then
        local fun = function()
            MSDKHelper:OpenServiceUrl("Setting")
        end
        self:AddButtonClickListener(self.comService_Button, fun)
    end

	--
    self.objBaseBG = self:FindChild(self._gameObject, 'BG_base');
	self.objObserveMask = self:FindChild(self._gameObject, 'BG_base_mask');
	self.objObserveBG = self:FindChild(self._gameObject, 'BG_base_observe');
	self.objObserveImage = self:FindChild(self._gameObject, 'BG_base_image');
	self.objImage = self:FindChild(self._gameObject, 'Account_box/Image');
    self.objWindowTab = self:FindChild(self._gameObject, 'WindowTabUI');

	self.btnExit = self:FindChildComponent(self._gameObject,"frame/Btn_exit","Button")
	if self.btnExit then
		self:AddButtonClickListener(self.btnExit,function ()
			self:OnClick_BackButton()
		end)
	end

	self.comVerText = self:FindChildComponent(self._gameObject, "SystemSet_box/Panel_regard/Content/StudioContent/StudioDetails/Text_versions", "Text")
end

function PlayerSetUI:RefreshUI(info)
	info = info or {}
	-- 访客模式
	local bIsVisitor = (info.bIsVisitor == true)
	-- self.Toggle_Setting.isOn = true;
	-- self.Toggle_Account.interactable = (not bIsVisitor)
	-- self.Toggle_Battle.gameObject:SetActive(not bIsVisitor)
	self.Toggle_Account.gameObject:SetActive(false)


	self.bIfInLoginUI = info and info.bIfInLoginUI
	--初始化默认选中账号
	self:ShowOrHideCom(childCom.accountInfoCom, info)
	self:SetShowState(info);

	--
	local arenaUI = GetUIWindow('ArenaUI');
	if (not bIsVisitor) and arenaUI and arenaUI:IsOpen() then
		local playerid = tostring(globalDataPool:getData("PlayerID"));
		local _callback = function()
			local generalBoxUI = GetUIWindow('GeneralBoxUI');
			if generalBoxUI and generalBoxUI:GetCheckBoxState() then
				SetConfig(playerid .. '#HidePlatEMBattleTips', true);
			end
		end

		if GetConfig(playerid .. '#HidePlatEMBattleTips') then
			_callback();
		else
			local strText = '使用此处五人上阵\n点击“配置阵容”配置。';
			OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strText, _callback, { confirm = 1, checkBox = 1 } });
		end
	end
	--
	self:RefPrivilegeUI(bIsVisitor);

	-- 请求平台阵容
	if not globalDataPool:getData('PlatTeamInfo') then
		SendQueryPlatTeamInfo(SPTQT_PLAT, 0);
	end

	-- TODO 清楚剧本缓冲
	for i = 2, #(OUT_SCRIPT_ID) do
		local dataType = 'ScriptTeamInfo' .. OUT_SCRIPT_ID[i];
		globalDataPool:setData(dataType, nil, true);
	end
	self:ShowOrHideCom(childCom.systemSettingCom)
	self.comVerText.text = "当前版本：v"..CLIENT_VERSION.."("..TIME_YER.."年"..TIME_MONTH.."月"..TIME_DAY.."日"..")"
end

function PlayerSetUI:RefPrivilegeUI(bIsVisitor)
	if (MSDKHelper:IsLoginQQ()) then
		self.QQ_Privilege_bt_obj:SetActive(true)
		if MSDKHelper:IsOpenQQPrivilege() then
			setUIGray(self.QQ_Privilege_bt_obj:GetComponent("Image"),false);
		else
			setUIGray(self.QQ_Privilege_bt_obj:GetComponent("Image"),true);
		end
	end
	if (MSDKHelper:IsLoginWeChat()) then
		self.WX_Privilege_bt_obj:SetActive(true);
	end

	if bIsVisitor then
		self.QQ_Privilege_bt_obj:SetActive(false);
		self.WX_Privilege_bt_obj:SetActive(false);
	end
end

function PlayerSetUI:SetShowState(info)
	--self.objBaseBG:SetActive(true);
	self.objObserveMask:SetActive(false);
	self.objObserveBG:SetActive(false);
	self.objObserveImage:SetActive(false);
	self.objImage:SetActive(true);
	--self.objWindowTab:SetActive(true);
	self.Button_back.gameObject:SetActive(true);
	self.Button_close.gameObject:SetActive(false);

	if info.bIsVisitor then
		self.objBaseBG:SetActive(false);
		self.objObserveMask:SetActive(true);
		self.objObserveBG:SetActive(true);
		self.objObserveImage:SetActive(true);
		self.objImage:SetActive(false);
		self.objWindowTab:SetActive(false);
		self.Button_back.gameObject:SetActive(false);
		self.Button_close.gameObject:SetActive(true);
	end
end

function PlayerSetUI:ShowOrHideCom(type, info)
	self.Account_box:SetActive(false)
	self.SystemSet_box:SetActive(false)

	if type == childCom.accountInfoCom then
		if not self.AccountInfoCom then
			self.AccountInfoCom = AccountInfoCom.new(self.Account_box)
			self.AccountInfoCom:OnCreate(info);
		else
			self.AccountInfoCom:RefreshUI(info)
		end
		self.Account_box:SetActive(true)
		self.Toggle_Account.isOn = true
	elseif type == childCom.systemSettingCom then
		self.SystemSettingCom:RefreshUI(self.bIfInLoginUI)
		self.SystemSet_box:SetActive(true)
		self.Toggle_Setting.isOn = true
	end
end

function PlayerSetUI:OnClick_Toggle_Account()
	self:ShowOrHideCom(childCom.accountInfoCom)
end

function PlayerSetUI:OnClick_Toggle_Battle()
	self:ShowOrHideCom(childCom.none)
end

function PlayerSetUI:OnClick_Toggle_Setting()
	self:ShowOrHideCom(childCom.systemSettingCom)
end

function PlayerSetUI:OnClick_BackButton()
	local arenaUI = GetUIWindow('ArenaUI');
	if arenaUI and arenaUI:IsOpen() then
		if self.callback then
			self.callback()
			self.callback = nil;
		end
	end

	--
	RoleDataManager:GetInstance():SetObserveData(false);
	GiftDataManager:GetInstance():SetObserveData(false);
	ItemDataManager:GetInstance():SetObserveData(false);
	MartialDataManager:GetInstance():SetObserveData(false);

	RemoveWindowImmediately("PlayerSetUI")
	if IsWindowOpen("DialogControlUI") then		
		RemoveWindowImmediately("DialogControlUI")
	end
end

function PlayerSetUI:SetCallBack(callback)
	self.callback = callback;
end

function PlayerSetUI:OnDestroy()
	self.AccountInfoCom:Close()
	self.SystemSettingCom:Close()
end

function PlayerSetUI:OnEnable()
    WINDOW_ORDER_INFO.CharacterUI.fullscreen = false;
    WINDOW_ORDER_INFO.RoleEmbattleUI.fullscreen = false;
	WINDOW_ORDER_INFO.RoleEmbattleUI.order = 299;

	local dialogControlUI = GetUIWindow("DialogControlUI")
	if dialogControlUI then
		self.bHideDialogControlUI = true
		dialogControlUI:SetActive(false)
	end

	LuaEventDispatcher:dispatchEvent("UI_OPEN", "PlayerSetUI")
end

function PlayerSetUI:OnDisable()
    WINDOW_ORDER_INFO.CharacterUI.fullscreen = false;
	WINDOW_ORDER_INFO.RoleEmbattleUI.fullscreen = true;
	WINDOW_ORDER_INFO.RoleEmbattleUI.order = 126;
	if self.bHideDialogControlUI then
		self.bHideDialogControlUI = false
		local dialogControlUI = GetUIWindow("DialogControlUI")
		if dialogControlUI then
			dialogControlUI:SetActive(true)
		end
	end

	LuaEventDispatcher:dispatchEvent("UI_CLOSE", "PlayerSetUI")
end

return PlayerSetUI