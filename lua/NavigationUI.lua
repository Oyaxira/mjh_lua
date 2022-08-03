NavigationUI = class("NavigationUI",BaseWindow)
local MenuPanelUI = require "UI/MenuPanelUI"
function NavigationUI:ctor()

end

function NavigationUI:Create()
	local obj = LoadPrefabAndInit("Game/NavigationUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function NavigationUI:Init()
	g_canClickBtn = true
	--菜单面板
	self.objMenuPanel = self:FindChild(self._gameObject,"TransformAdapt_node_right/menuPanel")
	if self.objMenuPanel then
		self.MenuPanelUI = MenuPanelUI.new()
		self.MenuPanelUI:SetGameObject(self.objMenuPanel)
		self.MenuPanelUI:Init()
	end
	
	-- 开启酒馆的状态
	self.bReturnHouseState = PlayerSetDataManager:GetInstance():GetUnlockHouseState()
	self.LimitShopManager = LimitShopManager:GetInstance()

	local iRenameCount = PlayerSetDataManager:GetInstance():GetReNameNum() or 0
	-- 玩家起名状态
	self.bHasRenamed = (iRenameCount > 0)
	---------------- 酒馆导航栏 -----------------
	self.objTownNav = self:FindChild(self._gameObject,"TransformAdapt_node_right/TownNav")
	self.objTownNavLayout = self:FindChild(self.objTownNav,"layout")
	self.objTownArenaNavLayout = self:FindChild(self.objTownNav,"layout_Arena")
	self.objTownStorageNavLayout = self:FindChild(self.objTownNav,"layout_Storage")
	self.objTownActivityNavLayout = self:FindChild(self.objTownNav,"layout_Activity")
	self.objAchieve_Button = self:FindChildComponent(self.objTownNavLayout, "Button_Achievement","Button")
	if self.objAchieve_Button then
		self:AddMenuButtonListener(self.objAchieve_Button, function()
			self:OnClick_Achieve_Button()
		end)
	end
	
	self.objCollection_Button = self:FindChildComponent(self.objTownNavLayout, "Button_Collection","Button")
	self.objCollection_redPoint = self:FindChild(self.objTownNavLayout, 'Button_Collection/Image_redPoint')
	if self.objCollection_Button then
		self:AddMenuButtonListener(self.objCollection_Button, function()
			self:OnClick_Collection_Button()
		end)
	end
	
	self.objArena_Button = self:FindChildComponent(self.objTownNavLayout, "Button_Arena","Button")
	if self.objArena_Button then
		self:AddMenuButtonListener(self.objArena_Button, function()
			self:OnClick_Arena_Button()
		end)
	end
	
	self.objFriends_Button = self:FindChildComponent(self.objTownNavLayout, "Button_Friends","Button")
	if self.objFriends_Button then
		self:AddMenuButtonListener(self.objFriends_Button, function()
			self:OnClick_Friends_Button()
		end)
	end
	
	self.objQJBM_Button = self:FindChildComponent(self.objTownNavLayout, "Button_QJBM","Button")
	if self.objQJBM_Button then
		self:AddMenuButtonListener(self.objQJBM_Button, function()
			self:OnClick_QJBM_Button()
		end)
	end
	
	self.objRank_Button = self:FindChildComponent(self.objTownNavLayout, "Button_Ranking","Button")
	if self.objRank_Button then
		self:AddMenuButtonListener(self.objRank_Button, function()
			self:OnClick_Rank_Button()
		end)
	end

	self.objRole_Button = self:FindChildComponent(self.objTownNavLayout,"Button_Role","Button")
	if self.objRole_Button then 
		self:AddMenuButtonListener(self.objRole_Button, function()
			self:OnClick_Role_Button()
		end)
	end
	self.objActivity_Button = self:FindChildComponent(self.objTownNavLayout,"Button_Activity","Button")
	if self.objActivity_Button then 
		self:AddMenuButtonListener(self.objActivity_Button, function()
			self:OnClickActivityBtn()
		end)
	end
	self.objRoleHead_Image = self:FindChildComponent(self.objRole_Button.gameObject,"headCommon/head","Image")
	self.objRoleName_Text = self:FindChildComponent(self.objRole_Button.gameObject,"Image/name","Text")

	self.btnStorage = self:FindChildComponent(self.objTownNavLayout, "Button_Storage", "Button")
	self:AddMenuButtonListener(self.btnStorage, function()
		self:OnClickStorageBtn()
	end)

	self.objBtnMall = self:FindChild(self.objTownNavLayout, "Button_Mall")
	self.btnBtnMall = self.objBtnMall:GetComponent("Button")
	self.objMallRedPoint = self:FindChild(self.objTownNavLayout, "Button_Mall/Image_redPoint")
	self:AddMenuButtonListener(self.btnBtnMall, function()
		self:OnClickShop()
	end)

	self.objBtnVIP = self:FindChild(self.objTownNavLayout, "Button_VIP")
	self.btnBtnVIP = self.objBtnVIP:GetComponent("Button")
	self:AddMenuButtonListener(self.btnBtnVIP, function()
		self:OnClickVip()
	end)
	-- 要显示百宝书, 两个条件: 1. 开启酒馆功能, 2.玩家起过名字
	self.objBtnVIP:SetActive(self.bReturnHouseState and self.bHasRenamed)
	-- 侠客行入口显示条件保持与百宝书相同
	self.objBtnPinball = self:FindChild(self.objTownNavLayout, "Button_Pinball")
	if self.objBtnPinball then
		self.objBtnPinball:SetActive(self.bReturnHouseState and self.bHasRenamed)
		self.btnBtnPinball = self.objBtnPinball:GetComponent("Button")
		self:AddMenuButtonListener(self.btnBtnPinball, function()
			self:OnClickPinball()
		end)
		self.objPinballRedPoint = self:FindChild(self.objBtnPinball, 'Image_redPoint')
	end

	self.SocialDataManager = SocialDataManager:GetInstance()

	---- 酒馆仓库导航 --------------
	self.objStorageShow_Button = self:FindChildComponent(self.objTownStorageNavLayout, "Button_Show","Button")
	if self.objStorageShow_Button then
		self:AddMenuButtonListener(self.objStorageShow_Button, function()
			self:OnClickStorageBtn()
		end)
	end
	self.objStorageRecover_Button = self:FindChildComponent(self.objTownStorageNavLayout, "Button_Recover","Button")
	if self.objStorageRecover_Button then
		self:AddMenuButtonListener(self.objStorageRecover_Button, function()
			self:OnClick_Storage_Recover_Button()
		end)
	end

	---- 酒馆擂台导航 --------------
	self.objArenaShow_Button = self:FindChildComponent(self.objTownArenaNavLayout, "Button_Show","Button")
	if self.objArenaShow_Button then
		self:AddMenuButtonListener(self.objArenaShow_Button, function()
			self:OnClick_Arena_Button()
		end)
	end

	self.objArenaMatch_Button = self:FindChildComponent(self.objTownArenaNavLayout, "Button_Match","Button")
	if self.objArenaMatch_Button then
		self:AddMenuButtonListener(self.objArenaMatch_Button, function()
			self:OnClick_Arena_Button(2, false)
		end)
	end

	self.objArenaRank_Button = self:FindChildComponent(self.objTownArenaNavLayout, "Button_Rank","Button")
	if self.objArenaRank_Button then
		self:AddMenuButtonListener(self.objArenaRank_Button, function()
			self:OnClick_Arena_Button(4, false)
		end)
	end

	self.objArenaRecord_Button = self:FindChildComponent(self.objTownArenaNavLayout, "Button_Record","Button")
	if self.objArenaRecord_Button then
		self:AddMenuButtonListener(self.objArenaRecord_Button, function()
			self:OnClick_Arena_Button(5, false)
		end)
	end

	self.objArenaExchange_Button = self:FindChildComponent(self.objTownArenaNavLayout, "Button_Exchange","Button")
	if self.objArenaExchange_Button then
		self:AddMenuButtonListener(self.objArenaExchange_Button, function()
			self:OnClick_Arena_Exchange_Button()
		end)
	end

	self.objArenaBet_Button = self:FindChildComponent(self.objTownArenaNavLayout, "Button_Bet","Button")
	if self.objArenaBet_Button then
		self:AddMenuButtonListener(self.objArenaBet_Button, function()
			self:OnClick_Arena_Bet_Button()
		end)
	end

	---- 酒馆活动导航 --------------
	self.objActivityShow_Button = self:FindChildComponent(self.objTownActivityNavLayout, "Button_Show","Button")
	if self.objActivityShow_Button then
		self:AddMenuButtonListener(self.objActivityShow_Button, function()
			self:OnClickActivityBtn()
		end)
	end
	self.objActivityDiscuss_Button = self:FindChildComponent(self.objTownActivityNavLayout, "Button_Discuss","Button")
	if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_TOWN) then
        self.objActivityDiscuss_Button.gameObject:SetActive(true)
		self:AddMenuButtonListener(self.objActivityDiscuss_Button, function()
			self:OnClickDiscussBtn()
		end)
	else
        self.objActivityDiscuss_Button.gameObject:SetActive(false)
	end

	---------------- 剧本导航栏 ----------------
	self.objGameNav = self:FindChild(self._gameObject,"TransformAdapt_node_right/GameNav")
	self.objGameNavLayout = self:FindChild(self.objGameNav,"layout")
	self.objBtnVIPGameNav = self:FindChild(self.objGameNavLayout, "Button_VIP")
	self.btnBtnVIPGameNav = self.objBtnVIPGameNav:GetComponent("Button")
	self:AddMenuButtonListener(self.btnBtnVIPGameNav, function()
		self:OnClickVip()
	end)
	-- 要显示百宝书, 两个条件: 1. 开启酒馆功能, 2.玩家起过名字
	self.objBtnVIPGameNav:SetActive(self.bReturnHouseState and self.bHasRenamed)

	self.objBtnQuest = self:FindChild(self.objGameNavLayout, "Button_quest")
	self.Button_quest = self:FindChildComponent(self.objGameNavLayout, "Button_quest","Button")
	self.Button_quest_UIAction = self:FindChildComponent(self.objGameNavLayout, "Button_quest","LuaUIAction")
	self.questTip = self:FindChild(self.objBtnQuest, "Tips")
	local comQuestText = self:FindChildComponent(self.questTip,"Text","Text")
	--self.comBtnQuestUIAction
	if self.Button_quest then 
		self:AddMenuButtonListener(self.Button_quest, function()
			self:OnClick_Button_quest()
			
		end)
		self.Button_quest_UIAction:SetPointerEnterAction(function()
			RefreshTipsText(comQuestText,"任务",FuncType.OpenOrCloseQuestUI)
			self.questTip:SetActive(true)
		end)
		self.Button_quest_UIAction:SetPointerExitAction(function()
			--RemoveWindowImmediately("TipsPopUI",tips)
			self.questTip:SetActive(false)
		end)
	end

	self.objBtnLineup = self:FindChild(self.objGameNavLayout, "Button_lineup")
	self.Button_lineup = self:FindChildComponent(self.objGameNavLayout, "Button_lineup","Button")
	self.Button_lineup_UIAction = self:FindChildComponent(self.objGameNavLayout, "Button_lineup","LuaUIAction")
	self.lineupTip = self:FindChild(self.objBtnLineup, "Tips")
	local comLineupText = self:FindChildComponent(self.lineupTip, "Text","Text")
	if self.Button_lineup then
		self:AddMenuButtonListener(self.Button_lineup, function()
			self:OnClick_Button_lineup()
		end)
		self.Button_lineup_UIAction:SetPointerEnterAction(function()
			RefreshTipsText(comLineupText,"队伍",FuncType.OpenOrCloseTeamUI)
			self.lineupTip:SetActive(true)
		end)
		self.Button_lineup_UIAction:SetPointerExitAction(function()
			self.lineupTip:SetActive(false)
		end)
	end

	self.objBtnBackpack = self:FindChild(self.objGameNavLayout, "Button_backpack")
	self.Button_backpack = self:FindChildComponent(self.objGameNavLayout, "Button_backpack","Button")
	self.Button_backpack_UIAction = self:FindChildComponent(self.objGameNavLayout, "Button_backpack","LuaUIAction")
	self.backpackTip = self:FindChild(self.objBtnBackpack, "Tips")
	local comBackpackText = self:FindChildComponent(self.backpackTip, "Text","Text")
	if self.Button_backpack then
		self:AddMenuButtonListener(self.Button_backpack, function()
			self:OnClick_Button_backpack()
		end)
		self.Button_backpack_UIAction:SetPointerEnterAction(function()
			RefreshTipsText(comBackpackText,"背包",FuncType.OpenOrCloseBackpackUI)
			self.backpackTip:SetActive(true)
		end)
		self.Button_backpack_UIAction:SetPointerExitAction(function()
			self.backpackTip:SetActive(false)
		end)
	end

	self.objBtnForge = self:FindChild(self.objGameNavLayout, "Button_forge")
	self.Button_forge = self:FindChildComponent(self.objGameNavLayout, "Button_forge","Button")
	self.objBtnForge:SetActive(false)
	if self.Button_forge then
		self:AddMenuButtonListener(self.Button_forge, function()
			self:OnClick_Button_forge()
		end)
	end
	
	self.objBtnForge = self:FindChild(self.objGameNavLayout, "Button_setting")
	self.comButton_setting = self:FindChildComponent(self.objGameNavLayout, "Button_setting","Button")
	if self.objBtnForge then
		self.objBtnForge:SetActive(true)
	end
	if self.comButton_setting then
		self:AddMenuButtonListener(self.comButton_setting, function()
			if g_canClickBtn == false then
				return
			end
			self:OnClick_Button_setting()
		end)
	end

	self.objHouse = self:FindChild(self.objGameNavLayout, "Button_House")
	self.Button_House = self.objHouse:GetComponent("Button")
	if self.Button_House then
		self:AddMenuButtonListener(self.Button_House, function()
			self:OnClick_Button_House()
		end)
	end

	self.objLimitGift = self:FindChild(self.objGameNavLayout, "Button_LimitGift")
	self.comLimitGiftTimeText = self:FindChildComponent(self.objGameNavLayout, "Button_LimitGift/Text",'Text')
	self.Button_LimitGift = self.objLimitGift:GetComponent("Button")
	if self.Button_LimitGift then
		self:AddMenuButtonListener(self.Button_LimitGift, function()
			self:OnClick_Button_LimitGift()
		end)
	end
	self:RefreshLimitShopBtn()

	self.objHouse:SetActive(false)
	self.objHouseNotice = self:FindChild(self.objHouse, 'Image_notice')
	self.textHouseNotice = self:FindChildComponent(self.objHouseNotice, "Text", "Text")
	self.canvasGroupHouseNotice = self.objHouseNotice:GetComponent("CanvasGroup")

	---------------- 掌门对决导航栏 ----------------
	self.objZmRank = self:FindChild(self.objGameNavLayout,'Button_Zm_Rank')
	local btnZmRank = self:FindChildComponent(self.objGameNavLayout, "Button_Zm_Rank","Button")
	if btnZmRank then
		self:AddMenuButtonListener(btnZmRank, function()
			self:OnClick_Button_Zm_Rank()
		end)
	end

	self.objZmCard = self:FindChild(self.objGameNavLayout,'Button_Zm_Card')
	local btnZmCard = self:FindChildComponent(self.objGameNavLayout, "Button_Zm_Card","Button")
	if btnZmCard then
		self:AddMenuButtonListener(btnZmCard, function()
			self:OnClick_Button_Zm_Card()
		end)
	end

	---------------- 中间临时提示区 ----------------
	self.objHotNavigation = self:FindChild(self._gameObject,"HotNavigation")
	self.btnHotStorage = self:FindChild(self.objHotNavigation,"Content/Button_Storage")
	if self.btnHotStorage then
		self.btnHotStorage_Button = self.btnHotStorage:GetComponent(DRCSRef_Type.Button)
		self:AddButtonClickListener(self.btnHotStorage_Button, function()
			self:OnClickStorageBtn()
		end)
	end
	self.btnHotArenaSignUp = self:FindChild(self.objHotNavigation,"Content/Button_Arena_SinUp")
	if self.btnHotArenaSignUp then
		self.btnHotArenaSignUp_Button = self.btnHotArenaSignUp:GetComponent(DRCSRef_Type.Button)
		self:AddButtonClickListener(self.btnHotArenaSignUp_Button, function()
			self:OnClick_Arena_Button(2, false)
		end)
	end
	self.btnHotArenaBet = self:FindChild(self.objHotNavigation,"Content/Button_Arena_Bet")
	if self.btnHotArenaBet then
		self.btnHotArenaBet_Button = self.btnHotArenaBet:GetComponent(DRCSRef_Type.Button)
		self:AddButtonClickListener(self.btnHotArenaBet_Button, function()
			if GetGameState() == -1 then
				self:OnClick_Arena_Button(2, true)
			else
				self:OpenArenaTip()
			end
		end)
	end
	

	-- 开启返回酒馆功能时开启酒馆按钮
	self:AddEventListener("UPDATE_MAIN_ROLE_INFO", function(info)
		self:RefreshBtn_House(info)
	end)
	self:AddEventListener("UPDATE_COLLECTION_BUTTON", function(info)
		self:RefreshCollectionRedPoint()
	end)
	self:AddEventListener("UPDATE_ACHIEVE_BUTTON", function(info)
		self:RefreshAchieveRedPoint()
	end)
	self:AddEventListener("ONEVENT_REF_SHOPDATA", function(info)
		self:RefreshMallRedPoint()
	end)
	-- 收到三天签到捡垃圾消息时显示提示
	self:AddEventListener("DAY3_SIGN_IN_COLLECT_ITEM", function(info)
		self:OnRefDay3SignInNotice(info)
	end)

	self:AddEventListener("UPDATE_LIMITSHOP_BUTTON", function(info)
		self:RefreshLimitShopBtn(true)
	end)

	self:AddEventListener("HOUSE_SCENE_MOVE_END", function(info)
		self:RefreshHouseLayout()
	end)

	self:AddEventListener('UPDATE_HOUSE_HOT_NAVIGATION', function()
		self:RefreshStoragePoint()
		self:RefreshArenaBetBtn()
		self.needUpdateHotNavigation = true
	end, nil, nil, nil, true)

	self:AddEventListener('UpdateActivityInfo', function()
		self:RefreshActivityBtn()
		self.needUpdateActivity = true
	end, nil, nil, nil, true)

	-- 成就可能影响基金活动
	self:AddEventListener('UPDATE_ACHIEVE_DATA', function()		
		self.needUpdateAchieveDataForFund = true
	end, nil, nil, nil, true)

	-- 经脉可能影响基金活动
	self:AddEventListener('UPDATE_MERIDIANS_EXP', function()	
		self.needUpdateMeridiansDataForFund = true
	end, nil, nil, nil, true)

	-- 请求一次仓库数据
	StorageDataManager:GetInstance():RequestStorageData()
end

function NavigationUI:RefreshUI(info)
	info = info or {}

	-- 是否在酒馆
	local bInTown = (info.bInTown == true)
	self.bIsGuideMode = PlayerSetDataManager:GetInstance():GetGuideModeFlag()
	self.objTownNav:SetActive(bInTown)
	self.bInTown = bInTown
	self:CheckGameNavShow()
	
	self.objZmRank:SetActive(false)
	self.objZmCard:SetActive(false)

	-- 掌门对决特殊处理
	if info.bInZm then
		self.objBtnVIPGameNav:SetActive(false)
		self.objBtnQuest:SetActive(false)
		self.objBtnForge:SetActive(false)
		self.objLimitGift:SetActive(false)

		self.objHouse:SetActive(true)

		self.objBtnLineup:SetActive(false)
		self.objBtnBackpack:SetActive(false)

		return
	end

	if bInTown then
		self:RefreshRoleInfo()
		-- 查询成就按钮是否需要显示小红点
		self:RefreshAchieveRedPoint()
		self:RefreshMallRedPoint()
		-- 查询侠客行是否需要显示小红点
		self:RefreshPinballRedPoint()
		self:RefreshArenaUIRedPoint();
		self:RefreshStoragePoint()
		self:RefreshActivityRedPoint()
		self:RefreshArenaBetBtn()
		self:RefreshActivityBtn()
		-- 引导模式下屏蔽一些按钮
		self.objBtnMall:SetActive(not self.bIsGuideMode)
		self.objBtnVIP:SetActive(not self.bIsGuideMode)
		self.objBtnPinball:SetActive(not self.bIsGuideMode)

		self:RefreshHouseLayout()

		GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenHouseNavigation)
	end
	
	self:RefHotNavigation()
	self:RefreshCollectionRedPoint()
	SendLimitShopOpr()
end

function NavigationUI:RefHotNavigation()
	if self.bInTown then
		if self.btnHotStorage then
			if StorageDataManager:GetInstance():GetRecordStoryEndItems() then
				self.btnHotStorage:SetActive(true)
				bShowPanel = true
			else
				self.btnHotStorage:SetActive(false)
			end
		end

		local arenaHotInfo = ArenaDataManager:GetInstance():GetArenaHotInfo()

		if self.btnHotArenaSignUp then
			if not arenaHotInfo or not arenaHotInfo.showSignUp then
				self.btnHotArenaSignUp:SetActive(false)
			else
				self.btnHotArenaSignUp:SetActive(true)
				bShowPanel = true
			end
		end

		if self.btnHotArenaBet then
			if not arenaHotInfo or not arenaHotInfo.showBet then
				self.btnHotArenaBet:SetActive(false)
			else
				self.btnHotArenaBet:SetActive(true)
				bShowPanel = true
			end
		end

		ArenaDataManager:GetInstance():SetStoryShowBetTipFlag(false)
	else
		if self.btnHotStorage then
			self.btnHotStorage:SetActive(false)
		end
		if self.btnHotArenaSignUp then
			self.btnHotArenaSignUp:SetActive(false)
		end
		if self.btnHotArenaBet then
			local isShow = ArenaDataManager:GetInstance():GetStoryShowBetTipFlag()
			self.btnHotArenaBet:SetActive(isShow)
		end
	end
end

function NavigationUI:RefreshButtonZm(process)
	self.objBtnLineup:SetActive(process and process ~= 1)
	self.objBtnBackpack:SetActive(process and process ~= 1)

	self.objZmRank:SetActive(process and process >= 0)
	self.objZmCard:SetActive(process and process >= 0)
end

function NavigationUI:RefreshBtn_House(info)
	-- local bRetHouseState = PlayerSetDataManager:GetInstance():GetUnlockHouseState()
	-- if bRetHouseState ~= self.bReturnHouseState then
	-- 	self.bReturnHouseState = bRetHouseState
	-- 	self.objHouse:SetActive(bRetHouseState)
	-- end
end
function NavigationUI:CheckGuideMode()
	if (self.bIsGuideMode == true) and (self.bInTown == true) then
		SystemUICall:GetInstance():Toast("请先在个人界面创建形象")
		return true
	end
	return false
end

function NavigationUI:RefreshHouseLayout()
	local houseUI = GetUIWindow("HouseUI")
	local curArea = 0

	if houseUI then
		curArea = houseUI:GetCurArea()
	end

	local inArenaArea = (curArea == HOUSEUI_AREA_INDEX.ARENA)
	local inStorageArea = (curArea == HOUSEUI_AREA_INDEX.STORAGE)
	local inActivityArea = (curArea == HOUSEUI_AREA_INDEX.ACTIVITY)
	local inDefault = (not inArenaArea and not inStorageArea and not inActivityArea)

	if curArea~=self.lastArea then
		local function SetStatus(obj,status)
			local alpha=obj:GetComponent("CanvasGroup").alpha	
			local anim=obj:GetComponent("Animation")
				
				if status==true and alpha==0 then
					obj:SetActive(true)
					anim:DR_Play("NavigationUI_In")
					obj:GetComponent("CanvasGroup").interactable=true
					obj:GetComponent("CanvasGroup").blocksRaycasts=true
				elseif status == false and alpha == 1 then
					anim:DR_Play("NavigationUI_Out")
					obj:GetComponent("CanvasGroup").interactable=false
					obj:GetComponent("CanvasGroup").blocksRaycasts=false
				end
		end

		SetStatus(self.objTownNavLayout,inDefault)
		SetStatus(self.objTownArenaNavLayout,inArenaArea)
		SetStatus(self.objTownStorageNavLayout,inStorageArea)		
		SetStatus(self.objTownActivityNavLayout,inActivityArea)		
	end

	--根据动画是否在播放和interact设置Active
	-- local function M_SetActive(obj,status)
	-- 	local anim=obj:GetComponent("Animation")	
	-- 	if anim.isPlaying==false  then
	-- 		obj:SetActive(status)
	-- 	elseif anim.isPlaying==true  then
	-- 		--如果动画在播放，延迟一会然后
	-- 		self:AddTimer(250,function() 
	-- 			local navigationUI=GetUIWindow("NavigationUI")
	-- 			if navigationUI then
	-- 				obj:SetActive(status)
	-- 			end
	-- 		end) 
	-- 	end
	-- end

	-- M_SetActive(self.objTownNavLayout,inDefault)
	-- M_SetActive(self.objTownArenaNavLayout,inArenaArea)
	-- M_SetActive(self.objTownStorageNavLayout,inStorageArea)

	-- self.objTownNavLayout:SetActive(inDefault)
	-- self.objTownArenaNavLayout:SetActive(inArenaArea)
	-- self.objTownStorageNavLayout:SetActive(inStorageArea)
	--记录上一次所在地区
	self.lastArea = curArea
end


local bTest = false;

function NavigationUI:OnRefArenaNotice(info)
	if info then
		if info.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_START_MATCH or 
		info.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
			local fromTime = {
				[1] = 0,
				[2] = 0,
				[3] = 0,
			}
			local toTime = {
				[1] = 23,
				[2] = 59,
				[3] = 59,
			}

			local lastTime = GetConfig('OpenArenaTip');
			local bToday = false;
			if not lastTime or not InTime(lastTime, fromTime, toTime) then
				SetConfig('OpenArenaTip', os.time(), true);
				bToday = true;
			else
				bToday = false;
			end

			if bToday or bTest then
				bTest = false;
				self:CheckOpenArenaTip()
			end
		end
	end
end

function NavigationUI:SetStoryArenaBetTip(isShow)
	ArenaDataManager:GetInstance():SetStoryShowBetTipFlag(false)
	if GetGameState() ~= -1 then
		ArenaDataManager:GetInstance():SetStoryShowBetTipFlag(isShow)
		self:RefHotNavigation()
	end
end

function NavigationUI:CheckOpenArenaTip()
	if GetGameState() == -1 then
		self:OpenArenaTip()
	else
		self:SetStoryArenaBetTip(true)
	end
end

function NavigationUI:OpenArenaTip()
	local _callback = function()
		if GetGameState() == -1 then
			local arenaUI = GetUIWindow('ArenaUI');
			local info = { index = 2, showBet = true };
			if arenaUI and arenaUI:IsOpen() then
				arenaUI:RefreshUI(info);
			else
                OpenWindowImmediately("ArenaUI", info)
			end
		else
			JUMP_AND_OPEN_ARENA = true;
			SendClickQuitStoryCMD()
			SendQueryPlayerGold(false);
		end

		self:SetStoryArenaBetTip(false)
	end
	local arenaUIMatch = GetUIWindow('ArenaUIMatch');
	if (not arenaUIMatch) or (arenaUIMatch and (not arenaUIMatch:IsOpen())) then
		local showContent = {
			['title'] = '提示',
			['text'] = '擂台赛已经开始了，\n是否跳转到擂台界面参与助威？\n助威可得残章、擂台币等珍贵奖励！',
			['leftBtnFunc'] = function()
				self:SetStoryArenaBetTip(false)
			end
		}
		local _button = { confirm = 1, cancel = 1, tips = 1 };
		OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.ARENA_TIP, showContent, _callback, _button })
	end
end

function NavigationUI:OnRefDay3SignInNotice(info)
	if self.bInTown == true then
		return
	end
	if not (info and info.msg) then
		return
	end
	self.textHouseNotice.text = info.msg or ""
	self.objHouseNotice:SetActive(true)
	local fAnimTime = 0.5
	local twnFade = Twn_CanvasGroupFade(nil, self.canvasGroupHouseNotice, 0, 1, fAnimTime)
	if (twnFade ~= nil) then
		twnFade:SetAutoKill(true)
	end
	-- 3秒后自动关闭
	twnFade = Twn_CanvasGroupFade(nil, self.canvasGroupHouseNotice, 1, 0, fAnimTime, 3, function()
		local win = GetUIWindow("NavigationUI")
		if not win then
			return
		end
		win.objHouseNotice:SetActive(false)
		win.canvasGroupHouseNotice.alpha = 1
	end)
	if (twnFade ~= nil) then
		twnFade:SetAutoKill(true)
	end
end
local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
local l_LineupKey = "w"
local l_BackpackKey = "e"
local l_SettingsKey = "r"
function NavigationUI:Update()
	if IsNotInGuide() then
		if not IsAnyWindowOpen(NavigationHotKeyInvalidWindows) then
			if GetKeyDownByFuncType(FuncType.OpenOrCloseTeamUI) then 
				if not IsWindowOpen("CharacterUI") then
					self.Button_lineup.onClick:Invoke()
				else
					if self.objCharacterUI then
						if self.objCharacterUI:GetSignIndex() == 1 then
							RemoveWindowImmediately("CharacterUI",false)
						elseif self.objCharacterUI:GetSignIndex() == 2 then
							self.Button_lineup.onClick:Invoke()
						end
					end
				end		
			elseif GetKeyDownByFuncType(FuncType.OpenOrCloseBackpackUI) then
				if not IsWindowOpen("CharacterUI") then
					self.Button_backpack.onClick:Invoke()
				else
					if self.objCharacterUI then
						if self.objCharacterUI:GetSignIndex() == 2 then
							RemoveWindowImmediately("CharacterUI",false)
						elseif self.objCharacterUI:GetSignIndex() == 1 then
							self.Button_backpack.onClick:Invoke()
						end
					end
				end
			elseif GetKeyDownByFuncType(FuncType.OpenOrCloseQuestUI) and not IsWindowOpen("TaskTipsUI") then
				self.Button_quest.onClick:Invoke()
			elseif GetKeyDownByFuncType(FuncType.OpenSaveFileUI) then
				OpenWindowImmediately("SaveFileUI")
			end
		end
	end

	if self.needUpdateHotNavigation then
		self.needUpdateHotNavigation = false
		self:RefHotNavigation()
	end

	if self.needUpdateActivity then
		self.needUpdateActivity = false
		self:RefreshActivityRedPoint()
	end

	if self.needUpdateAchieveDataForFund then
		self.needUpdateAchieveDataForFund = false
		ActivityHelper:GetInstance():RequestRedPointActivitys()
	end

	if self.needUpdateMeridiansDataForFund then
		self.needUpdateMeridiansDataForFund = false
		ActivityHelper:GetInstance():RequestRedPointActivitys()
	end

end

function NavigationUI:LateUpdate()
	self:RefreshLimitShopBtn()
	 
end
function NavigationUI:RefreshLimitShopBtn(bUsrNeWData)
	local str = self.LimitShopManager:GetLeftTimeStr_Shop()
	if str and str ~= 0 then 
		self.objLimitGift:SetActive(true)
		self.comLimitGiftTimeText.text = str
	else 
		self.objLimitGift:SetActive(false)
	end 
	 
end
function NavigationUI:OnEnable()
    --
    OpenWindowImmediately("ChatBoxUI")

	self:CheckGameNavShow()
	self:RefreshTreasureBookRedPoint()
	self:RefreshCollectionRedPoint()
	self:RefreshAchieveRedPoint()
	self:RefreshMallRedPoint()
	self:RefreshBtn_House()

	self:AddEventListener('ONEVENT_REF_MATCHDATA', function(info)
		self:OnRefArenaNotice(info);
    end);
end

function NavigationUI:OnDisable()
    --
    RemoveWindowImmediately("ChatBoxUI")

	self:CheckGameNavShow()
	self:RefreshTreasureBookRedPoint()
	self:RefreshCollectionRedPoint()

	self:RemoveEventListener('ONEVENT_REF_MATCHDATA');

end

function NavigationUI:CheckGameNavShow()
	local uiHideTagTypeID = 70010	-- 隐藏标记

	local tagValue = TaskTagManager:GetInstance():GetTag(uiHideTagTypeID)
	local isShow = (not self.bInTown) and (not (tagValue == 1))

	self.objGameNav:SetActive(isShow)
end

function NavigationUI:AddMenuButtonListener(btn, func)
	if type(func) ~= 'function' then 
		return
	end
	self:AddButtonClickListener(btn, function()
		local navigationUI = GetUIWindow('NavigationUI')
		if navigationUI:CanClickMenuButton() then 
			func()
		end
	end)
end

function NavigationUI:CanClickMenuButton()
	--local bigMapUI = GetUIWindow('BigMapUI')
	local cityUI = GetUIWindow('CityUI')
	
	-- if bigMapUI and bigMapUI:IsMoving() then
	-- 	return false
	if cityUI and cityUI:IsOpenAnim() then
		return false
	end
	return true
end

function NavigationUI:OnClick_Button_quest()
	OpenWindowImmediately("TaskUI",nil,true)
end

function NavigationUI:OnClick_Button_lineup()
	-- 可以直接在打开界面的时候传信息过去，目前临时按旧方法写一下。
	-- OpenWindowImmediately("CharacterUI",	globalDataPool:getData("GameData"))

	OpenWindowImmediately("CharacterUI",nil,false)
	if IsWindowOpen("TaskUI") then
		RemoveWindowImmediately("TaskUI")
	end
	self.objCharacterUI = WindowsManager:GetInstance():GetUIWindow("CharacterUI")
	self.objCharacterUI:SetIndex(1)
end

function NavigationUI:OnClick_Button_backpack()
	OpenWindowImmediately("CharacterUI",nil,false)
	if IsWindowOpen("TaskUI") then
		RemoveWindowImmediately("TaskUI")
	end
	self.objCharacterUI = WindowsManager:GetInstance():GetUIWindow("CharacterUI")
	self.objCharacterUI:SetIndex(2)
end

function NavigationUI:OnClick_Button_forge()
	OpenWindowImmediately("ForgeUI")
end

function NavigationUI:OnClick_Button_setting()
	OpenWindowImmediately("PlayerSetUI")
end

function NavigationUI:OnClick_Button_LimitGift()
	OpenWindowImmediately('LimitShopUI')
	SendOpenLimitShopUI()
end
function NavigationUI:OnClick_Button_House()
	--TODO: 先走掌门对决自带接口，后面走剧本
	if PKManager:GetInstance():IsRunning() then
		OpenWindowImmediately('GeneralBoxUI', {
			GeneralBoxType.COMMON_TIP, 
			"是否需要离开掌门对决, 回到酒馆?", 
			function()
				self.objHouseNotice:SetActive(false);
				self.canvasGroupHouseNotice.alpha = 1
				PKManager:GetInstance():End()
			end})
		return
	end
 
	local msg = nil
	-- 如果这个时候临时背包中还有物品, 那么在返回酒馆的时候给个提示
	local tempItems = ItemDataManager:GetInstance():GetTempBackpackItems() or {}
	if #tempItems > 0 then
		msg = "临时背包中还有物品, 离开剧本就会消失, 确定要回到酒馆吗?"
	else
		msg = "是否需要离开当前剧本, 回到酒馆?"
	end
	local boxCallback = function()
		self.objHouseNotice:SetActive(false);
		self.canvasGroupHouseNotice.alpha = 1
		SendClickQuitStoryCMD()
		--回酒馆查询一下金锭
		SendQueryPlayerGold(false);
		-- 重置资源掉落活动查询标记
		ResDropActivityDataManager:GetInstance():ResetResDropCollectActivityOnceFlag()
	end
	OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg or "", boxCallback})
end

function NavigationUI:OnClick_Achieve_Button()
	if self:CheckGuideMode() then
		return
	end
	OpenWindowImmediately("AchievementAchieveUI")
end

function NavigationUI:OnClick_Collection_Button()
	if self:CheckGuideMode() then
		return
	end	
	OpenWindowImmediately("CollectionUI")
    SendUpdateCollectionPoint()
end
function NavigationUI:OnClick_QJBM_Button()
	if self:CheckGuideMode() then
		return
	end
	OpenWindowImmediately("MeridiansUI");
end

function NavigationUI:OnClick_Rank_Button()
	if self:CheckGuideMode() then
		return
	end
	OpenWindowImmediately("RankUI");
end

function NavigationUI:OnClick_Role_Button()
	dprint("open PlayerSet")
	OpenWindowImmediately("PlayerSetUI")
end

function NavigationUI:OnClick_Arena_Button(index, showBet)
	if self:CheckGuideMode() then
		return
	end
	if CanOpenArena() then
		local info = {index = index, showBet = showBet}
		OpenWindowImmediately("ArenaUI", info)
	else
		SystemUICall:GetInstance():Toast('维护中');
	end
end

function NavigationUI:OnClick_Arena_Exchange_Button()
	OpenWindowImmediately("ShoppingMallUI", {ePageType = 6})
end

function NavigationUI:OnClick_Arena_Bet_Button()
	self:OnClick_Arena_Button(2, true)
end

function NavigationUI:OnClick_Storage_Recover_Button()
	OpenWindowImmediately("ItemRecycleUI")
end

function NavigationUI:RefreshArenaUIRedPoint()
	local objRedPoint = self:FindChild(self.objArena_Button.gameObject, 'Image_redPoint');
	if objRedPoint then
		local bActive = false;
		local data = ArenaDataManager:GetInstance():GetFormatData();
		if data then
			for i = 1, #(data) do
				if data[i].uiSignUpPlace == 0 and data[i].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP then
					local bCon = ArenaDataManager:GetInstance():ArenaCanSignUp(data[i]);
					if bCon then
						bActive = true;
					end
				end
			end
		end
		objRedPoint:SetActive(bActive);
	end
end

function NavigationUI:RefreshStoragePoint()
	local objRedPoint1 = self:FindChild(self.btnStorage.gameObject, 'Image_redPoint')
	local objRedPoint2 = self:FindChild(self.objStorageShow_Button.gameObject, 'Image_redPoint')

	local bActive = false
	local items = StorageDataManager:GetInstance():GetRecordStoryEndItems()
	if items and next(items) then
		bActive = true
	end

	if objRedPoint1 then
		objRedPoint1:SetActive(bActive)
	end
	if objRedPoint2 then
		objRedPoint2:SetActive(bActive)
	end
end

function NavigationUI:RefreshActivityRedPoint()
	local bActive = ActivityHelper:GetInstance():HasActivityRedPoint()
	local objRedPoint = self:FindChild(self.objActivityShow_Button.gameObject, 'Image_redPoint')
	local objRedPoint2 = self:FindChild(self.objActivity_Button.gameObject, 'Image_redPoint')

	objRedPoint:SetActive(bActive)
	if objRedPoint2 then
		objRedPoint2:SetActive(bActive)
	end
end

function NavigationUI:OnClick_Friends_Button()

end

function NavigationUI:OnClick_Button_Zm_Rank()
	PKManager:GetInstance():ShowRankUI()
end

function NavigationUI:OnClick_Button_Zm_Card()
	PKManager:GetInstance():ShowRoleUI()
end

function NavigationUI:OnClickDiscussBtn()
	local houseUI = GetUIWindow("HouseUI")
	if houseUI then
		houseUI:OnClickDiscussBtn()
	end
end

function NavigationUI:OnClickActivityBtn()
	OpenWindowImmediately("ActivityUI")
end

function NavigationUI:RefreshRoleInfo()
	local tbl_ResourcePicture = PlayerSetDataManager:GetInstance():GetResourcePictureTB()
	if tbl_ResourcePicture and tbl_ResourcePicture.HeadPath then
		self.objRoleHead_Image.sprite = GetSprite(tbl_ResourcePicture.HeadPath)
	else
		dprint("ResourceRolePicture未配置headpath")
	end
	local data = PlayerSetDataManager:GetInstance():GetAppearanceInfo()
	if data and data.playerName then
		self.objRoleName_Text.text = data.playerName
	end
end
function NavigationUI:RefreshMallRedPoint()
	if self.objMallRedPoint then 
		self.objMallRedPoint:SetActive(ShoppingDataManager:GetInstance():CheckIfHasFreeRackByType())
	end 
end

function NavigationUI:RefreshAchieveRedPoint()
	local redPoint = self:FindChild(self.objAchieve_Button.gameObject, 'Image_redPoint')
	redPoint:SetActive(AchieveDataManager:GetInstance():CheckIfHasReadyAchieve() == true)
end

function NavigationUI:RefreshPinballRedPoint()
	local iDialyFreeHoodleNum = PinballDataManager:GetInstance():GetUserAllDailyFreeHoodleNum() or 0
	self.objPinballRedPoint:SetActive(iDialyFreeHoodleNum > 0)
end

function NavigationUI:RefreshCollectionRedPoint()
	local bActive = CardsUpgradeDataManager:GetInstance():CheckRoleCardsExsUpGrade()
	if not bActive then 
		bActive = CardsUpgradeDataManager:GetInstance():CheckPetCardsExsUpGrade()
	end 
	if not bActive then 
		bActive = ClanDataManager:GetInstance():CheckHasNewData()
	end 
	if self.objCollection_redPoint then 
		self.objCollection_redPoint:SetActive(bActive)
	end 
end

function NavigationUI:CanCurStoryBringIn()
	local curStoryID = GetCurScriptID()
	local TB_Story = TableDataManager:GetInstance():GetTable("Story")
	local storyData = TB_Story[curStoryID]
	if storyData ~= nil and storyData.bAllowStorageIn == TBoolean.BOOL_NO then
		return false
	end
	return true
end

function NavigationUI:OnClickStorageBtn()
	if self:CheckGuideMode() then
		return
	end

	local info = {}
	info.auiNewItems = StorageDataManager:GetInstance():GetRecordStoryEndItems()
	OpenWindowImmediately("StorageUI", info)	
end

function NavigationUI:RefreshArenaBetBtn()
	if not self.objArenaBet_Button then
		return
	end

	local flag = ArenaDataManager:GetInstance():HasRunningMatch()
	self.objArenaBet_Button.gameObject:SetActive(flag)
end

function NavigationUI:RefreshActivityBtn()
	if not self.objActivityShow_Button then
		return
	end

	local flag = true
	if ActivityHelper == nil or ActivityHelper.GetInstance == nil then
		flag = false
	else
		local activityData = ActivityHelper:GetInstance():GetShowActivity()
		if #activityData == 0 then
			flag = false
		end
	end
	self.objActivityShow_Button.gameObject:SetActive(flag)

	if self.objActivity_Button then
		self.objActivity_Button.gameObject:SetActive(flag)
	end
end


function NavigationUI:OnClickVip()
	if self:CheckGuideMode() then
		return
	end
	TreasureBookDataManager:GetInstance():DoEnterTreasureBook()
end

function NavigationUI:OnClickShop()
	if self:CheckGuideMode() then
		return
	end
	OpenWindowImmediately("ShoppingMallUI")
end

function NavigationUI:OnClickPinball()
	if self:CheckGuideMode() then
		return
	end
	if GetUIWindow("PinballGameUI") then
		OpenWindowImmediately("PinballGameUI")
	else
		OpenWindowImmediately("LoadingUI")
		globalTimer:AddTimer(100, function()
			OpenWindowImmediately("PinballGameUI")
		end)
	end
end

function NavigationUI:RefreshTreasureBookRedPoint()
	local bookManager = TreasureBookDataManager:GetInstance()
	local kBaseInfo = bookManager:GetTreasureBookBaseInfo()
	if not kBaseInfo then
		return
	end
	local redPoint = self:FindChild(self.objBtnVIP, 'Image_redPoint')
	local redPoint2 = self:FindChild(self.objBtnVIPGameNav, 'Image_redPoint')
	local bHasPersonalReward2Get = (bookManager:IfHaveReward2Get() == true)  -- 个人奖励
	local bHasServerReward2Get = (bookManager:IfHaveServerReward2Get() == true)  -- 全服奖励
	local bHasDialySliver2Get = (kBaseInfo.bDayGiftGot ~= true)  -- 每日银锭
	local bHasWeeklyExp2Get = (kBaseInfo.bRMBPlayer == true) and (kBaseInfo.bWeekGiftGot ~= true)  -- 壕侠每周经验
	local bShow = bHasPersonalReward2Get or bHasServerReward2Get or bHasDialySliver2Get or bHasWeeklyExp2Get
	redPoint:SetActive(bShow)
	redPoint2:SetActive(bShow)
end

function NavigationUI:OnDestroy()

	self:RemoveEventListener('UPDATE_COLLECTION_BUTTON')
	self:RemoveEventListener('UPDATE_ACHIEVE_BUTTON')
	self:RemoveEventListener('ONEVENT_REF_SHOPDATA')
end

return NavigationUI