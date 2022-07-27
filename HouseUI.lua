HouseUI = class("HouseUI",BaseWindow)

local ChatBubble = require 'UI/TownUI/ChatBubble';

local UpdateTime = 5000;
local RandomDown = 2;
local RandomUp = 4;
local DelayTimeDown = 500;
local DelayTimeUp = 1000;
local BubbleText = {
	'比赛开始了，快去看吧',
	'擂台人好多啊，快挤挤',
	'让我围观一下高手的风采',
	'比赛进行到了%s',
	-- '%s好帅啊',
}

local TYPE = {
	SINGLE = 1,
	TEAM = 2,
}
local MATCH_BASEID = {
	SINGLE = 5,
	TEAM = 6
}

local MatchType = {'32强赛','16强赛','8强赛','半决赛','决赛', '排名'};
local Round = {32, 16, 8, 4, 2, 1}
local RoundToString = {
    [Round[1]] = MatchType[1],
    [Round[2]] = MatchType[2],
    [Round[3]] = MatchType[3],
    [Round[4]] = MatchType[4],
    [Round[5]] = MatchType[5],
    [Round[6]] = MatchType[5],
}

function HouseUI:Create()
	local obj = LoadPrefabAndInit("TownUI/HouseUI",Scence_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function HouseUI:Init()
	self.roleDataManager = RoleDataManager:GetInstance();
	self.arenaDataManager = ArenaDataManager:GetInstance();
	self.playerSetDataManager = PlayerSetDataManager:GetInstance();
	self.MoneyPacketDataManager = MoneyPacketDataManager:GetInstance();

	-- 是否服务器模式
	self.bIServerMode = (globalDataPool:getData("GameMode") == "ServerMode")
	-- 进入上一个剧本
	self.btnEnterScript = self:FindChildComponent(self._gameObject, "TransformAdapt_node_left/Button_Script", DRCSRef_Type.Button)
	self:AddButtonClickListener(self.btnEnterScript, function()
		self:OnClickEnterLastScript()
	end)

	-- 场景根节点
	self.objHouseSceneNode = self:FindChild(self._gameObject, "HouseSence_node")
	self.objSceneContent = self:FindChild(self.objHouseSceneNode, "Viewport/Content")
	self.transSceneContent = self.objSceneContent.transform
	self.iOriSceneContentX = self.transSceneContent.position.x
	self.objSceneRoot = self:FindChild(self.objSceneContent, "Root")
	self.objSceneJunction = self:FindChild(self.objHouseSceneNode, "Viewport/Junction")
	self.comBossSpine = self:FindChildComponent(self._gameObject, "HouseSence_node/Viewport/Content/Root/Scene_1/SpineBoss/Spine_LaoBanNaing",DRCSRef_Type.SkeletonGraphic)
	--老板娘的动作 循环播放
	local iBossAnimaitonIndex = 0
	local bossAnimation = {"animation","animation01","animation02"}
	self.addBossAnimationFunc = function()
		iBossAnimaitonIndex = (iBossAnimaitonIndex + 1) % 3
		self.comBossSpine.AnimationState:AddAnimation(0,bossAnimation[iBossAnimaitonIndex + 1],false,0)
    end
	self.comBossSpine.AnimationState:Complete("+",self.addBossAnimationFunc)

	self.objBG3 = self:FindChild(self.objSceneRoot, "Scene_4/BG_3");
	self.objText_1 = self:FindChild(self.objBG3, "Text_1");
	self.objText_2 = self:FindChild(self.objBG3, "Text_2");
	self.objSingle = self:FindChild(self.objBG3, "Image_single");
	self.objSingleLeft = self:FindChild(self.objSingle, "Player_left");
	self.objSingleMind = self:FindChild(self.objSingle, "Player_mind");
	self.objSingleRight = self:FindChild(self.objSingle, "Player_right");
	self.objTeam = self:FindChild(self.objBG3, "Image_team");
	self.objTeamLeft = self:FindChild(self.objTeam, "Player_left");
	self.objTeamMind = self:FindChild(self.objTeam, "Player_mind");
	self.objTeamRight = self:FindChild(self.objTeam, "Player_right");

	-- 场景连接点控制器
	self.comJunctionController = self.objSceneJunction:GetComponent("HouseJunctionFollower")

	-- 平台能力相关入口初始化
	self:InitTencentBtnGroup()

	-- 场景移动事件
	self.scrollRectScene = self.objHouseSceneNode:GetComponent("DragCtrlScrollRect")
	self.scrollRectScene:SetOnDragLuaFunc(function()
		self:OnSceneMove()
	end)
	self.scrollRectScene:SetOnEndDragLuaFunc(function()
		self:CheckSceneChangeAction()
	end)

	--
	local btnOnClickArena = self:FindChildComponent(self.objBG3, "Image_drbtn", DRCSRef_Type.Button)
	self:AddButtonClickListener(btnOnClickArena, function()
		self:OnClick_Arena_DRBtn()
	end)

	-- 选择剧本按钮
	local btnSelectScript = self:FindChildComponent(self.objSceneRoot, "Scene_1/Button_Story", DRCSRef_Type.Button)
	self:AddButtonClickListener(btnSelectScript, function()
		self:OnClick_Story_Button()
	end)

	-- 角色头像按钮
	self.btnRole = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/Button_Role", DRCSRef_Type.Button)
	self.textRoleName = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/Button_Role/Image/name", "Text")
	self:UpdateRoleName()
	self:AddButtonClickListener(self.btnRole, function()
		OpenWindowImmediately("PlayerSetUI")
	end)

	-- 右侧工具栏
	self.objRightToolBar = self:FindChild(self._gameObject, "TransformAdapt_node_right/Right_node")
	self.rectTransRightToolBar = self.objRightToolBar:GetComponent("RectTransform")
	self.iRightToolBarWidth = self.rectTransRightToolBar.rect.width
	self:SetRightToolBarXPos(self.iRightToolBarWidth)  -- 初始位置
	local btnRightToolBarHandler = self:FindChildComponent(self.objRightToolBar, "Button_hide", DRCSRef_Type.Button)
	self:AddButtonClickListener(btnRightToolBarHandler, function()
		self:MoveRightToolBar(self.bRightToolBarClose == false)
	end)
	self.objRightToolBarBtns = self:FindChild(self.objRightToolBar, "Btns")
	self.objRightToolBarRedPoint = self:FindChild(self.objRightToolBar, "Button_hide/Image_redPoint")
	self:MoveRightToolBar(false)  -- 默认打开工具栏
	
	-- 邮件按钮
	self.objMail_Button = self:FindChild(self.objRightToolBarBtns,"Button_Mail")
	if self.objMail_Button then
		self.btnMail_Button = self.objMail_Button:GetComponent(DRCSRef_Type.Button)
		local fun = function()
			if self:CheckGuideMode() then
				return
			end
			globalDataPool:setData("socialUI","mailUI",true);
			dprint("####click m"..globalDataPool:getData("socialUI"))
			OpenWindowImmediately("SocialUI");
			local socialUI = GetUIWindow("SocialUI");
			local _callback = function()
				self:RefMailRedPoint();
			end
			socialUI:SetRefRedPointFunc(_callback);

			-- local bClick = globalDataPool:getData('clickFriendTime');
			-- if not bClick or bClick == 1 then
			-- 	globalDataPool:setData('clickFriendTime', 0, true);
				
			-- 	local _callback = function()
			-- 		if socialUI and socialUI.IsOpen and socialUI:IsOpen() then
			-- 			socialUI:OnRefFriendUI();
			-- 			socialUI:OnRefApplyUI();
			-- 		end
			-- 	end
			-- 	SocialDataManager:GetInstance():QueryFriendInfoFromServer(_callback);
				
			-- 	local _func = function()
			-- 		globalDataPool:setData('clickFriendTime', 1, true);
			-- 	end
			-- 	globalTimer:AddTimer(1000 * 60, _func, 1);
			-- end
		end
        self:AddButtonClickListener(self.btnMail_Button,fun)
	end

	-- 好友按钮
	self.objFriend_Button = self:FindChild(self.objRightToolBarBtns,"Button_Friend")
	if self.objFriend_Button then
		self.btnFriend_Button = self.objFriend_Button:GetComponent(DRCSRef_Type.Button)
		local fun = function()
			if self:CheckGuideMode() then
				return
			end
			globalDataPool:setData("socialUI","friendUI",true);
			dprint("####click f"..globalDataPool:getData("socialUI"))
			OpenWindowImmediately("SocialUI");
			local socialUI = GetUIWindow("SocialUI");
			local _callback = function()
				self:RefFriendRedPoint();
			end
			socialUI:SetRefRedPointFunc(_callback);

			local bClick = globalDataPool:getData('clickFriendTime');
			if not bClick or bClick == 1 then
				globalDataPool:setData('clickFriendTime', 0, true);
				
				local _callback = function()
					if socialUI and socialUI.IsOpen and socialUI:IsOpen() then
						socialUI:OnRefFriendUI();
						socialUI:OnRefApplyUI();
					end
				end
				SocialDataManager:GetInstance():QueryFriendInfoFromServer(_callback);
				
				local _func = function()
					globalDataPool:setData('clickFriendTime', 1, true);
				end
				globalTimer:AddTimer(1000 * 60, _func, 1);
			end
		end
        self:AddButtonClickListener(self.btnFriend_Button,fun)
	end

	-- 排行榜按钮
	local btnRankButton = self:FindChildComponent(self.objRightToolBarBtns, "Button_RankList", DRCSRef_Type.Button)
	if btnRankButton then
		self:AddButtonClickListener(btnRankButton,function()
			self:OnClickRankListButton()
		end)
	end

	-- 公告按钮
	local btnNotice = self:FindChildComponent(self.objRightToolBarBtns, "Button_Notice", DRCSRef_Type.Button)
	if btnNotice then
		self:AddButtonClickListener(btnNotice,function()
			self:OnClickNoticeButton()
		end)
	end

	-- 微社区按钮
	local btnCommunity = self:FindChildComponent(self.objRightToolBarBtns, "Button_Community", "Button")
	if btnCommunity then
		self:AddButtonClickListener(btnCommunity,function()
			self:OnClickCommunityButton()
		end)
	end

	-- 问卷按钮
	local btnQuestion = self:FindChildComponent(self.objRightToolBarBtns, "Button_Questions", DRCSRef_Type.Button)
	if btnQuestion then
		self:AddButtonClickListener(btnQuestion,function()
			self:OnClickQuestionButton()
		end)
	end
	local objQuestion = self:FindChild(self.objRightToolBarBtns, "Button_Questions")
	local questionUrl = HttpHelper:GetQuestionUrl()
	if (questionUrl ~= nil and questionUrl ~= "") then
		objQuestion:SetActive(true)
	else
		objQuestion:SetActive(false)
	end

	-- 活动按钮列表
	self.objActivities = self:FindChild(self._gameObject, "TransformAdapt_node_right/ActivitiesBar")

	self.comPlayerReturnButton = self:FindChildComponent(self.objActivities, "Button_PlayerReturn", DRCSRef_Type.Button)
	self.objPlayerReturnRedPoint = self:FindChild(self.objActivities, "Button_PlayerReturn/RedPoint")
	self.comPlayerReturnTimeText = self:FindChildComponent(self.objActivities, "Button_PlayerReturn/Time (1)/Text", DRCSRef_Type.Text)
	self.comPlayerReturnButton.gameObject:SetActive(false)
	if self.comPlayerReturnButton then
		self:AddButtonClickListener(self.comPlayerReturnButton,function()
			OpenWindowImmediately("PlayerReturnTaskUI")
		end)
	end

	-- 3天签到活动
	self:HandleDay3SignInActivity()
	-- 完整版按钮
	self:HandleChallengeOrderActivity()
	-- 开始三天签到请求服务器数据 (完整版也需要监听)
	Day3SignInDataManager:GetInstance():RequestServerData()

	-- 7天活跃活动
	self:HandleDay7TaskActivity()

	-- 新门派签到活动
	self:InitActivitySign()

	-- 初始化节日活动按钮
	self:InitFestivalButton()

	-- 酒馆玩家显示相关
	self.fFixedPlayerNameScale = 0.6  -- 固定酒馆玩家名字的缩放
	self.akPlayerSpineItems = {}  -- 所有的玩家模型实例数据
	self.AreaRequestCDFlag = {}  -- 区域请求玩家数据CD标记
	self:InitAreaID2PlayerObjs()  -- 初始化AreaID -> playerSpines

	if self.id2AreaObjs and self.id2AreaObjs[0] then
		-- 老板讲讲话气泡节点
		local objScene0 = self.id2AreaObjs[0]
		self.objChatBubble = self:FindChild(objScene0, "SpineBoss/Chat")
		self.canvasGroupBubble = self.objChatBubble:GetComponent("CanvasGroup")
		self.canvasGroupBubble.alpha = 0
		self.textChatBubble = self:FindChildComponent(self.objChatBubble, "Text", "Text")
		self.fChatBubbleFadeTime = 0.8  -- 老板娘气泡渐变时间
		self.fChatBubbleStayTime = 2  -- 老板娘气泡停留时间
		-- 点击老板娘也可以进入剧本
		local btnBoss = self:FindChildComponent(objScene0, "SpineBoss", DRCSRef_Type.Button)
		self:AddButtonClickListener(btnBoss, function()
			self:OnClick_Story_Button()
		end)

		-- 老板娘每日奖励
		self.objDailyReward = self:FindChild(objScene0, "SpineBoss/DailyReward")
		if self.objDailyReward then
			local btnDailyReward = self.objDailyReward:GetComponent("DRButton")
			self:AddButtonClickListener(btnDailyReward, function()
				OpenWindowImmediately("DailyRewardUI")
			end)
		end
	end
	self:ShowRandomChatBubble()
	self:UpdateDailyReward()

	--
	-- MSDKHelper:GetSameServerFriendListAddToGameFriendsList()
	
	-- 讨论区
	self.btnDiscuss = self:FindChildComponent(self.objSceneRoot,"Scene_2/Button_discuss",DRCSRef_Type.Button)
    if DiscussDataManager:GetInstance():DiscussAreaOpen(ArticleTargetEnum.ART_TOWN) then
        self.btnDiscuss.gameObject:SetActive(true)
		self:AddButtonClickListener(self.btnDiscuss, function()
			self:OnClickDiscussBtn()
		end)
	else
        self.btnDiscuss.gameObject:SetActive(false)
	end

	-- 公告区
	-- 没活动的时候 按钮隐藏
	local ShowActivityFunc = function()
		self:CheckActivityUI()
	end
	self.btnNoticeArea = self:FindChildComponent(self.objSceneRoot,"Scene_2/Button_announcement",DRCSRef_Type.Button)
	self.objNoticeAreaRedPoint = self:FindChild(self.objSceneRoot,"Scene_2/Button_announcement/Image_redPoint")
	if self.btnNoticeArea then
		self.btnNoticeArea.gameObject:SetActive(true)
		self:AddButtonClickListener(self.btnNoticeArea,function()
			OpenWindowImmediately("ActivityUI")
			--self:OnClickNoticeButton()
		end)
	end

	-- 仓库区
	self.btnStorageArea = self:FindChildComponent(self.objSceneRoot,"Scene_3/Button_storage",DRCSRef_Type.Button)
	if self.btnStorageArea then
		self:AddButtonClickListener(self.btnStorageArea, function()
			self:OnClick_Storage_Button()
		end)
	end

	-- 擂台区
	self.btnArenaArea = self:FindChildComponent(self.objSceneRoot,"Scene_4/BG_3/Button_arena",DRCSRef_Type.Button)
	if self.btnArenaArea then
		self:AddButtonClickListener(self.btnArenaArea, function()
			self:OnClick_Arena_DRBtn()
		end)
	end

	self:AddListener();
end

function HouseUI:CheckActivityUI()
	local activityData = ActivityHelper:GetInstance():GetShowActivity()
	self.btnNoticeArea.gameObject:SetActive(not (#activityData == 0))

	local playerReturnData,iEndTime =  ActivityHelper:GetInstance():GetPlayerReturnInfo()
	if playerReturnData and iEndTime > GetCurServerTimeStamp() then
		self.comPlayerReturnButton.gameObject:SetActive(true)
		if playerReturnData.iValue2 == 0 then --如果回流奖励没领取过 则强制弹出
			OpenWindowImmediately("PlayerReturnUI")
		end
		self.objPlayerReturnRedPoint:SetActive(ActivityHelper:GetInstance():HasPlayerReturnRedPoint())
		local setLeftTime = function()
			local iDay,iHour,iMin = ActivityHelper:GetInstance():GetPlayerReturnTimeLeft()
			if iDay == 0 then
				self.comPlayerReturnTimeText.text = string.format("%d时%d分",iHour,iMin)
			else
				self.comPlayerReturnTimeText.text = string.format("%d天%d时",iDay,iHour)
			end

		end
		if self.iPlayerReturnTimer == nil then
			self.iPlayerReturnTimer = self:AddTimer(60000,setLeftTime,-1)
		else
			setLeftTime()
		end
	else
		self.comPlayerReturnButton.gameObject:SetActive(false)
	end
end

function HouseUI:updateLandLadySpine()
	if self and self.comBossSpine then 
		local modelpath = ActivityHelper:GetInstance():GetCurActiveLandLadyModelPath()
		if self.Lastmodelpath ~= modelpath then 
			DynamicChangeSpine(self.comBossSpine.gameObject,modelpath)
			self.Lastmodelpath = modelpath
		end 
	end 
end 

function HouseUI:AddListener()
	--
	self:AddEventListener('ONEVENT_REF_PLAYERSPINE', function(info)
		self.bPlayerSpineReady = true
		self:CheckAndShowHousePlayer()
	end, nil, nil, nil, true);

	self:AddEventListener('Modify_Player_Appearance', function(info)
		if info.eModifyType == SMPAT_SHOWROLE then
			self:OnRefHeadAndSpine();
		else
			self:UpdateRoleName();
			self:OnRefSpine();
		end
	end, nil, nil, nil, true);

	self:AddEventListener('Modify_UseTencentHeadPic', function(info)
        self:OnRefHead();
	end, nil, nil, nil, true);

	self:AddEventListener('UPDATE_LANDLADY', function(info)
        self:updateLandLadySpine();
	end, nil, nil, nil, true);

	self:AddEventListener('ONEVENT_REF_HISTORYDATA', function(info)
		self:OnRefArenaScene(info);
	end, nil, nil, nil, true);

	self:AddEventListener('ONEVENT_REF_MATCHDATA', function(info)
		local navigationUI = GetUIWindow("NavigationUI");
		if navigationUI then
			navigationUI:RefreshArenaUIRedPoint();
		end

		self:OnRefShowText(info);
	end, nil, nil, nil, true);

	self:AddEventListener('ONEVENT_REF_REDPACKET', function(info)
		self:AddLittlePacket();
	end, nil, nil, nil, true);

	self:AddEventListener('ONEVENT_REF_SERVERTIME', function(info)
		self:ShowSystemOpen();
	end, nil, nil, nil, true);

	self:AddEventListener('UPDATE_DAILY_REWARD_STATE', function(info)
		self:UpdateDailyReward();
	end, nil, nil, nil, true);

	self:AddEventListener('UpdateActivityInfo', function()
		self.needUpdateActivity = true
	end, nil, nil, nil, true)

	self:AddEventListener('ONEVENT_REF_SHOPDATA', function(info)
		self:RefreshShop(info)
	end)

	self:AddEventListener('ONEVENT_DIFF_DAY', function(info)
		self.needUpdateActivity = true
	end)
	
	--
	self:AddArenaMatchNotice();

	if self.bIServerMode then
		local requestArenaMatchOperateCmdList = {
			-- 请求擂台比赛数据
			[0] = {
				eRequestType = ARENA_REQUEST_MATCH
			},
			-- 请求擂台历史数据
			[1] = {
				eRequestType = ARENA_REQUEST_HISTORY_MATCH_DATA,
				uiMatchType = ARENA_TYPE.DA_SHI,
				uiMatchID = 0
			},
			[2] = {
				eRequestType = ARENA_REQUEST_HISTORY_MATCH_DATA,
				uiMatchType = ARENA_TYPE.HUA_SHAN,
				uiMatchID = 0
			}
		}
		SendRequestArenaMatchOperateList(requestArenaMatchOperateCmdList)

		-- 经脉数据
		SendMeridiansOpr(SMOT_REFRESH_ALL, 0);

		--
		QueryRedPacket();
	end

	self:AddEventListener('UPDATE_HOUSE_HOT_NAVIGATION', function()
		self.needUpdateHotNavigation = true
	end, nil, nil, nil, true);
end

function HouseUI:InitTencentBtnGroup()

	self.tencentBtnGroup = self:FindChild(self._gameObject, 'TransformAdapt_node_left/TencentBtnGroup')

	self.tencentBtnGroup:SetActive(false)

	self.exclusiveBtnQQ = self:FindChildComponent(self.tencentBtnGroup, "Btn_ExclusiveQQ", DRCSRef_Type.Button)
	self.exclusiveBtnWX = self:FindChildComponent(self.tencentBtnGroup, "Btn_ExclusiveWX", DRCSRef_Type.Button)
	self.exclusiveBtn4399 = self:FindChildComponent(self.tencentBtnGroup, "Btn_Exclusive4399", DRCSRef_Type.Button)
	self.exclusiveBtnHYKB = self:FindChildComponent(self.tencentBtnGroup, "Btn_ExclusiveHYKB", DRCSRef_Type.Button)
	self.weishequBtn = self:FindChildComponent(self.tencentBtnGroup, "Btn_Weishequ", DRCSRef_Type.Button)
	self.xinyueBtn = self:FindChildComponent(self.tencentBtnGroup, "Btn_XinYue", DRCSRef_Type.Button)
	self.gongzhongBtn = self:FindChildComponent(self.tencentBtnGroup, "Btn_GongZhong", DRCSRef_Type.Button)
	self.tapgonglueBtn = self:FindChildComponent(self.tencentBtnGroup, "Btn_TapGongLue", DRCSRef_Type.Button)
	self.xinyueRedImg = self:FindChild(self.tencentBtnGroup, "Btn_XinYue/Image_redPoint")
	

	self.moreBtn = self:FindChildComponent(self.tencentBtnGroup, "Btn_More", DRCSRef_Type.Button)

	self.objImageMaskBtn = self:FindChild(self.tencentBtnGroup, 'Image_Mask')
	self.imageMaskBtn = self:FindChildComponent(self.tencentBtnGroup, "Image_Mask", DRCSRef_Type.Button)
	
	self.objQQPrivilegeBtn = self:FindChild(self.tencentBtnGroup, 'Btn_QQPrivilege')
	self.qqPrivilegeBtn = self:FindChildComponent(self.tencentBtnGroup, "Btn_QQPrivilege", DRCSRef_Type.Button)

	self.objWxPrivilegeBtn = self:FindChild(self.tencentBtnGroup, 'Btn_WXPrivilege')
	self.wxPrivilegeBtn = self:FindChildComponent(self.tencentBtnGroup, "Btn_WXPrivilege", DRCSRef_Type.Button)

	--
	self.btns = self:FindChild(self.tencentBtnGroup, 'Btns')

	self.objGameClubBtn = self:FindChild(self.btns, 'Btn_GameClub')
	self.gameClubBtn = self:FindChildComponent(self.btns, "Btn_GameClub", DRCSRef_Type.Button)

	self.objGameTribeBtn = self:FindChild(self.btns, 'Btn_GameTribe')
	self.gameTribeBtn = self:FindChildComponent(self.btns, "Btn_GameTribe", DRCSRef_Type.Button)

	self.objServiceBtn = self:FindChild(self.btns, "Btn_Service")
	self.serviceBtn = self:FindChildComponent(self.btns, "Btn_Service", DRCSRef_Type.Button)

	self.objTapTapBtn = self:FindChild(self.btns, 'Btn_TapTap')
	self.tapTapBtn = self:FindChildComponent(self.btns, "Btn_TapTap", DRCSRef_Type.Button)

	self.objHuaWeiBtn = self:FindChild(self.btns, 'Btn_HuaWei')
	self.huaWeiBtn = self:FindChildComponent(self.btns, "Btn_HuaWei", DRCSRef_Type.Button)

	self.objXiaoMiBtn = self:FindChild(self.btns, 'Btn_XiaoMi')
	self.xiaoMiBtn = self:FindChildComponent(self.btns, "Btn_XiaoMi", DRCSRef_Type.Button)

	self.obj4399Btn = self:FindChild(self.btns, 'Btn_4399')
	self.g4399Btn = self:FindChildComponent(self.btns, "Btn_4399", DRCSRef_Type.Button)

	self.objHYKBBtn = self:FindChild(self.btns, 'Btn_HYKB')
	self.hykbBtn = self:FindChildComponent(self.btns, "Btn_HYKB", DRCSRef_Type.Button)

	self.objBwikiBtn = self:FindChild(self.btns, 'Btn_Bwiki')
	self.bwikiBtn = self:FindChildComponent(self.btns, "Btn_Bwiki", DRCSRef_Type.Button)

	self.objShareFriendtn = self:FindChild(self.btns, 'Btn_ShareFriend')
	self.comShareFriendtn = self:FindChildComponent(self.btns, "Btn_ShareFriend", DRCSRef_Type.Button)
	
	-- self.objGameClubBtn:SetActive(MSDKHelper:GetChannel()=="WeChat")
	-- self.objWxPrivilegeBtn:SetActive(MSDKHelper:GetChannel()=="WeChat")
	-- self.objWxShareBtn:SetActive(MSDKHelper:GetChannel()=="WeChat")
	-- self.objWxTimeLineShareBtn:SetActive(MSDKHelper:GetChannel()=="WeChat")
	-- self.objGameTribeBtn:SetActive(MSDKHelper:GetChannel()=="QQ")
	-- self.objQQPrivilegeBtn:SetActive(MSDKHelper:GetChannel()=="QQ")
	-- self.objQQShareBtn:SetActive(MSDKHelper:GetChannel()=="QQ")
  	-- self.objQQSpaceShareBtn:SetActive(MSDKHelper:GetChannel()=="QQ")
  
  	-- 去掉A级平台能力的一些入口
  	-- self.objGameClubBtn:SetActive(false)
	-- self.objWxPrivilegeBtn:SetActive(false)
	-- self.objWxShareBtn:SetActive(false)
	-- self.objWxTimeLineShareBtn:SetActive(false)
	-- self.objGameTribeBtn:SetActive(false)
	-- self.objQQPrivilegeBtn:SetActive(false)
	-- self.objQQShareBtn:SetActive(false)
  	-- self.objQQSpaceShareBtn:SetActive(false)
  	-- self.btns:SetActive(false)

	self:AddButtonClickListener(self.qqPrivilegeBtn, function()
		-- OpenWindowImmediately("QQPrivilegeBox")
		MSDKHelper:OpenUrl("https://speed.gamecenter.qq.com/pushgame/v1/inner-game/privilege?launchqq=1")
	end)

	self:AddButtonClickListener(self.wxPrivilegeBtn, function()
		OpenWindowImmediately("WXPrivilegeBox")
	end)

	self:AddButtonClickListener(self.gameClubBtn, function()
		MSDKHelper:OpenWXClubUrl()
	end)

	self:AddButtonClickListener(self.gameTribeBtn, function()
		MSDKHelper:OpenQQClubUrl()
	end)

	self:AddButtonClickListener(self.serviceBtn, function()
		MSDKHelper:OpenServiceUrl('Main')
	end)

	self:AddButtonClickListener(self.tapTapBtn, function()
		MSDKHelper:OpenUrl("https://l.taptap.com/olygqvtG")
	end)

	self:AddButtonClickListener(self.huaWeiBtn, function()
		MSDKHelper:OpenUrl("https://www.qq.com/")
	end)

	self:AddButtonClickListener(self.xiaoMiBtn, function()
		MSDKHelper:OpenUrl("https://www.qq.com/")
	end)

	self:AddButtonClickListener(self.g4399Btn, function()
		MSDKHelper:OpenUrl("http://bbs.4399.cn/forums-mtag-91861")
	end)

	self:AddButtonClickListener(self.hykbBtn, function()
		MSDKHelper:OpenUrl("https://bbs.3839.com/forum-519.htm")
	end)

	self:AddButtonClickListener(self.bwikiBtn, function()
		MSDKHelper:OpenUrl("https://wiki.biligame.com/wodexiake")
	end)

	self:AddButtonClickListener(self.comShareFriendtn, function()
		OpenWindowImmediately("ShareUI")
	end)

	self:AddButtonClickListener(self.exclusiveBtnQQ, function()
		MSDKHelper:OpenGiftCenter()
	end)

	self:AddButtonClickListener(self.exclusiveBtnWX, function()
		local playerid = PlayerSetDataManager:GetInstance():GetPlayerID() or 0
		CS.UnityEngine.PlayerPrefs.SetString('WXExclusiveRedPointTime_' .. tostring(playerid), os.time())
		MSDKHelper:OpenGiftCenter()
		self:RefPrivilegeUI()
	end)

	self:AddButtonClickListener(self.exclusiveBtn4399, function()
		MSDKHelper:OpenUrl("https://xk.qq.com/lbact/a20200922lb3h008/xk.html")
	end)

	self:AddButtonClickListener(self.exclusiveBtnHYKB, function()
		MSDKHelper:OpenUrl("https://xk.qq.com/lbact/a20200922lbayd30/xk.html")
	end)

	self:AddButtonClickListener(self.weishequBtn, function()
		self:OnClickCommunityButton()
	end)

	self:AddButtonClickListener(self.xinyueBtn, function()
		self:OnClickXinYueButton()
	end)
	
	self:AddButtonClickListener(self.gongzhongBtn, function()
		MSDKHelper:OpenUrl("https://game.weixin.qq.com/cgi-bin/comm/openlink?appid=wx62d9035fd4fd2059&url=https%3A%2F%2Fgame.weixin.qq.com%2Fcgi-bin%2Fh5%2Fstatic%2Fgamecenter%2Fdetail.html%3Fappid%3Dwx398d0e3e595d8823%26ssid%3D49%26isAutoShowFollow%3D1%23wechat_redirect#wechat_redirect")
	end)

	self:AddButtonClickListener(self.tapgonglueBtn, function()
		MSDKHelper:OpenUrl("https://www.taptap.com/strategy-station/177648")
	end)
	
	self.isOpenBtnGroup = true;
	self:AddButtonClickListener(self.moreBtn, function()
		self:MoveTencentBtnGroup(self.isOpenBtnGroup)
	end)

	self:AddButtonClickListener(self.imageMaskBtn, function()
		self:MoveTencentBtnGroup(self.isOpenBtnGroup)
	end)
end

-- function HouseUI:ShareToFriendByChannel(channel)
-- 	MSDKHelper:SendMessage('分享测试', channel)
-- end

function HouseUI:MoveTencentBtnGroup(isOpen)
	if self.bTencentBtnGroupMoving == true then
		return
	end
	self.bTencentBtnGroupMoving = true
	
	if isOpen then
		self.btns:SetActive(true)
	end
	local iFactor = isOpen and -1 or 1
	local iMoveTime = 0.2
	-- local twn = Twn_MoveBy_Y(nil, self.btnsGroup, iFactor * self.btnGroupTransY, iMoveTime, nil, function()
	-- 	self.btnsGroup:SetActive(isOpen)
	-- 	self.bTencentBtnGroupMoving = false
	-- 	self.isOpenBtnGroup = not isOpen
	-- end)
	local beginValue = isOpen and 0.1 or 1
	local endValue = isOpen and 1 or 0.1
	local twnScale = Twn_Scale(nil, self.btns, DRCSRef.Vec3(beginValue,beginValue,beginValue), endValue, iMoveTime, nil, function()
		self.btns:SetActive(isOpen)
		self.bTencentBtnGroupMoving = false
		self.isOpenBtnGroup = not isOpen
		self.objImageMaskBtn:SetActive(isOpen);
	end)
	
	if (twnScale ~= nil) then
		twnScale:SetAutoKill(true)
	end
end

-- 处理挑战令内容
function HouseUI:HandleChallengeOrderActivity()
	local btnChallengeOrder = self:FindChildComponent(self.objActivities, "Button_ChallengeOrder", DRCSRef_Type.Button)
	if btnChallengeOrder then
		self:AddButtonClickListener(btnChallengeOrder,function()
			self:OnClickChallengeOrderButton()
		end)

		self.btnChallengeOrder = btnChallengeOrder
	else
		return
	end

	-- 先关闭该入口, 在收到服务器开启信号后开启
	self.bDay3SignInOpen = nil
	self.btnChallengeOrder.gameObject:SetActive(false)
	self:AddEventListener('DAY3_SIGN_IN_OPEN_STATE_CHANGE', function(bIsOpen)
		self.bDay3SignInOpen = (bIsOpen == true)
		self:UpdateChallengeOrder()
	end)
	self:AddEventListener('CHALLENGEORDER_UNLOCK', function()
		self:UpdateChallengeOrder()
		self:UpdateDailyReward()
	end)
end

-- 处理三天签到内容
function HouseUI:HandleDay3SignInActivity()
	self.objDay3SignIn = self:FindChild(self.objActivities, "Button_Day3Sign")
	self.objDay3SignInTimer = self:FindChild(self.objDay3SignIn, "Time")
	self.textDay3SignInTimer = self:FindChildComponent(self.objDay3SignInTimer, "Text", "Text")
	self.objTitleLetter = self:FindChild(self.objDay3SignIn, "name_default")
	self.objTitleArrive = self:FindChild(self.objDay3SignIn, "name_arrive")
	local btnDay3SignIn = self.objDay3SignIn:GetComponent(DRCSRef_Type.Button)
	if btnDay3SignIn then
		self:AddButtonClickListener(btnDay3SignIn,function()
			self:OnClickDay3SignInButton()
		end)
	end
	-- 三天签到通知相关
	self.objDay3SignInNotice = self:FindChild(self.objDay3SignIn, 'Image_notice')
	self.textDay3SignInNotice = self:FindChildComponent(self.objDay3SignInNotice, "Text", "Text")
	self.canvasGroupDay3SignInNotice = self.objDay3SignInNotice:GetComponent("CanvasGroup")
	-- 收到三天签到捡垃圾消息时显示提示
	self:AddEventListener("DAY3_SIGN_IN_COLLECT_ITEM", function(info)
		self:OnRefDay3SignInNotice(info)
	end)
	-- 收到三天签到标题更新消息时更新标题
	self:AddEventListener("DAY3_SIGN_IN_TITLE_UPDATE", function()
		local strTitleState, bShowTimer, strTimer = Day3SignInDataManager:GetInstance():GetCurTitleAndTimer()
		self.objTitleLetter:SetActive(false)
		self.objTitleArrive:SetActive(false)
		if strTitleState == "Letter" then
			self.objTitleLetter:SetActive(true)
		elseif strTitleState == "Arrive" then
			self.objTitleArrive:SetActive(true)
		end
		if bShowTimer and strTimer and (strTimer ~= "") then
			self.textDay3SignInTimer.text = strTimer
			self.objDay3SignInTimer:SetActive(true)
		else
			self.objDay3SignInTimer:SetActive(false)
		end
	end)
	-- 注册事件, 当三天签到活动阶段更新的时候, 打开图标小红点
	self.objDay3SignInRedPoint = self:FindChild(self.objDay3SignIn, "RedPoint")
	self.objDay3SignInRedPoint:SetActive(false)
	self:AddEventListener('DAY3_SIGN_IN_IS_DIRTY', function()
		if IsWindowOpen("Day3SignInUI") == true then
			return
		end
		self.objDay3SignInRedPoint:SetActive(true)
	end)
	-- 先关闭该入口, 在收到服务器开启信号后开启
	self.objDay3SignIn:SetActive(false)
	self:AddEventListener('DAY3_SIGN_IN_OPEN_STATE_CHANGE', function(bIsOpen)
		self.objDay3SignIn:SetActive(bIsOpen == true)
	end)
end

-- 处理7天活跃内容
function HouseUI:HandleDay7TaskActivity()
	self.objDay7Task = self:FindChild(self.objActivities, "Button_Day7Task")
	self.textDay7Task = self:FindChildComponent(self.objDay7Task, "Text", "Text")
	local btnDay7Task = self.objDay7Task:GetComponent(DRCSRef_Type.Button)
	if btnDay7Task then
		self:AddButtonClickListener(btnDay7Task,function()
			self:OnClickDay7TaskButton()
		end)
	end
	-- 注册事件, 活动更新的时候, 打开图标小红点
	self.objDay7TaskRedPoint = self:FindChild(self.objDay7Task, "RedPoint")
	self.objDay7TaskRedPoint:SetActive(false)
	-- self:AddEventListener('DAY3_SIGN_IN_IS_DIRTY', function()
	-- 	if IsWindowOpen("Day7TaskUI") == true then
	-- 		return
	-- 	end
	-- 	self.objDay7TaskRedPoint:SetActive(true)
	-- end)
	-- 先关闭该入口, 在收到服务器开启信号后开启
	-- self.objDay7Task:SetActive(false)
	-- self:AddEventListener('DAY3_SIGN_IN_OPEN_STATE_CHANGE', function(bIsOpen)
	-- 	self.objDay7Task:SetActive(bIsOpen == true)
	-- end)
	-- 开始三天活跃请求服务器数据
	-- Day7TaskDataManager:GetInstance():RequestServerData()
end

---- 初始化节日活动按钮  start ----
function HouseUI:InitFestivalButton()
	self.objBtnFestival = self:FindChild(self.objActivities, "Button_Festival")
	if not self.objBtnFestival then
		return
	end

	self.comImgFestival = self:FindChildComponent(self.objActivities, "Button_Festival/border", "Image")
	self.comTextFestival = self:FindChildComponent(self.objActivities, "Button_Festival/Time/Text", "Text")
	self.objBtnFestival:SetActive(false)
	self.objFestivalRedPoint = self:FindChild(self.objBtnFestival,'RedPoint')

	self:AddButtonClickListener(self.objBtnFestival:GetComponent(DRCSRef_Type.Button), function()
		if self:CheckGuideMode() then
			return
		end
		OpenWindowImmediately("FestivalUI")
		local FestivalUI = GetUIWindow("FestivalUI")
		local _callback = function()
			self.needUpdateActivity = true
		end
		FestivalUI:SetCloseFunc(_callback)

	end)
	self:RefreshFestivalButton()
end
function HouseUI:RefreshFestivalButton()
	if not self.comImgFestival then 
		return 
	end 
	local iIconPath
	local showActivityData
	for i,activityData in ipairs(ActivityHelper:GetInstance():GetFestivalActivities()) do
		if activityData and activityData.ActIcon and activityData.ActIcon ~= '' then 
			iIconPath = activityData.ActIcon
			showActivityData = activityData
			break
		end 
		
	end 
	if iIconPath then 
		self:SetSpriteAsync(iIconPath, self.comImgFestival)
		self.objBtnFestival:SetActive(true)
	else
		self.objBtnFestival:SetActive(false)
	end 
	if not showActivityData then 
		return 
	end 
	self.objFestivalRedPoint:SetActive(ActivityHelper:GetInstance():HasFestivalRedPoint())
	local setLeftTime = function()
		local stampEndDay = os.time({
			year = tonumber(showActivityData.StopDate.Year) or 0,
			month = tonumber(showActivityData.StopDate.Month) or 0,
			day = tonumber(showActivityData.StopDate.Day) or 0,
			hour = tonumber(showActivityData.StopTime.Hour) or 0,
			min = tonumber(showActivityData.StopTime.Minute) or 0,
			sec = tonumber(showActivityData.StopTime.Second) or 0
		})

		local istampTimeLeft = stampEndDay - GetCurServerTimeStamp()
		local iDay = math.floor(istampTimeLeft / (86400)) 
		local iHour =  math.floor((istampTimeLeft - (86400 * iDay) ) / 3600) 
		local iMin = math.floor((istampTimeLeft - (86400 * iDay + iHour * 3600)) / 60)
		if iDay == 0 then
			self.comTextFestival.text = string.format("%d时%d分",iHour,iMin)
		else
			self.comTextFestival.text = string.format("%d天%d时",iDay,iHour)
		end
	end
	if self.iFestivalTimer == nil then
		self.iFestivalTimer = self:AddTimer(60000,setLeftTime,-1)
		setLeftTime()
	else
		setLeftTime()
	end

end 
---- 初始化节日活动按钮  end ----

---- 处理新门派签到活动 start ----
function HouseUI:InitActivitySign()
	self.mBtnActivitySign = self:FindChild(self.objActivities, "Button_ActivitySign")
	if not self.mBtnActivitySign then
		return
	end

	self.mImgActivitySign = self:FindChildComponent(self.objActivities, "Button_ActivitySign/border", "Image")

	self.mBtnActivitySign:SetActive(false)
	self.mActivitySignRedPoint = self:FindChild(self.mBtnActivitySign,'RedPoint')

	self:AddButtonClickListener(self.mBtnActivitySign:GetComponent(DRCSRef_Type.Button), function()
		if self:CheckGuideMode() then
			return
		end
		OpenWindowImmediately("ActivitySignUI")
	end)
	
end

-- 刷新新门派签到活动
function HouseUI:RefreshActivitySign()
	local signInfo = ActivityHelper.GetSignInfo()

	-- 是否显示小红点
	if self.mActivitySignRedPoint then
		if signInfo and signInfo.Receive and signInfo.Day > 0 and (not signInfo.LastDay) then
			self.mActivitySignRedPoint:SetActive(signInfo.Receive[signInfo.Day] ~= true)
		else
			self.mActivitySignRedPoint:SetActive(false)

			-- 超过活动时间，显示礼包的时间段，根据剩余免费礼包显示小红点
			if signInfo and (signInfo.Day == 0 or signInfo.LastDay) then
				SendPlatShopMallQueryItem(RackItemType.RTT_SIGN)
			end
		end
	end

	-- 显示图标
	if signInfo and signInfo.ID > 0 then
		local tableActivity = GetTableData("ActivitySign", signInfo.ID)
		if tableActivity and tableActivity.Icon and tableActivity.Icon ~= '' then
			self:SetSpriteAsync(tableActivity.Icon, self.mImgActivitySign)
		end
	end

	-- 是否显示按钮
	if self.mBtnActivitySign then
		self.mBtnActivitySign:SetActive(signInfo and signInfo.ID > 0)
	end
end

function HouseUI:RefreshShop(info)
	-- 只有当商城刷新到签到的物品，才进行刷新
	if info and info.uiType == RackItemType.RTT_SIGN then
		local signInfo = ActivityHelper.GetSignInfo()
		if signInfo and (signInfo.Day == 0 or signInfo.LastDay) then
			local showRedPoint = false
			local mallList = (TableDataManager:GetInstance():GetTableData("ActivitySign", signInfo.ID)or {}).MallList
			if mallList then
				for i, mallIDStr in pairs(mallList) do
					local mallID = tonumber(mallIDStr)
					if mallID then
						local mallData = TableDataManager:GetInstance():GetTableData("Rack", mallID)
						local shopData = ShoppingDataManager:GetInstance():GetShopDataBy(mallID, false)
						if mallData and shopData then
							local value = math.floor(mallData.OriginValue * mallData.Discount * 0.01)
							if value == 0 and shopData.iCanBuyCount > 0 then
								showRedPoint = true
							end
						end
					end
				end
			end
			self.mActivitySignRedPoint:SetActive(showRedPoint)
		end 
	end
end

-- 开始新门派签到活动（OnEnable）
function HouseUI:StartActivitySign()
	self:RefreshActivitySign()
end

-- 停止新门派签到活动（OnDisable）
function HouseUI:StopActivitySign()
end
---- 处理新门派签到活动 end ----

function HouseUI:OnEnable()
	PlayMusic(BGMID_HOURE)
	self.bPlayerSpineReady = true
	self:CheckAndShowHousePlayer()
	self:CheckActivityUI()
	-- 取一下信用积分如果有就不重新拉
	local uiCredit = PlayerSetDataManager:GetInstance():GetTencentCreditScore()

	self:StartActivitySign()
	self:RefreshFestivalButton()
end

function HouseUI:OnDisable()
	-- 关闭酒馆伪刷新机制
	self:CloseHousePlayerUpdate()

	if self.redPacketTimer then
		self:RemoveTimer(self.redPacketTimer);
		self.redPacketTimer = nil;
	end
	if self.arenaNoticeTimer then
		self:RemoveTimer(self.arenaNoticeTimer);
		self.arenaNoticeTimer = nil;
	end

	self:StopActivitySign()
end

-- 设置右工具栏的位置
function HouseUI:SetRightToolBarXPos(iPosX)
	if not iPosX then
		return
	end
	local v3OriPos = self.rectTransRightToolBar.anchoredPosition
	v3OriPos.x = iPosX
	self.rectTransRightToolBar.anchoredPosition = v3OriPos
end

-- 移动右边工具栏
function HouseUI:MoveRightToolBar(bClose)
	if self.bRightToolBarMoving == true then
		return
	end
	self.bRightToolBarMoving = true
	bClose = (bClose == true)
	if not bClose then
		self.objRightToolBarBtns:SetActive(true)
	end
	local iFactor = bClose and 1 or -1
	local iMoveTime = 0.2
	local twn = Twn_MoveX(nil, self.objRightToolBar, iFactor * self.iRightToolBarWidth, iMoveTime, nil, function()
		self.objRightToolBarBtns:SetActive(not bClose)
		self.bRightToolBarClose = bClose
		self.objRightToolBarRedPoint:SetActive(bClose and (next(self.kToolBarRedPointOn) ~= nil))
		self.bRightToolBarMoving = false
	end)
	if (twn ~= nil) then
		twn:SetAutoKill(true)
	end
end

-- 根据引导结果执行一些逻辑
function HouseUI:OnGuidDone(bRes)
	-- 是否是引导模式(引导模式会屏蔽一些功能, 并且酒馆玩家使用假数据)
	local iRenamNum = PlayerSetDataManager:GetInstance():GetReNameNum() or 0
	if iRenamNum > 0 then
		bRes = false
	end
	
	self.bIsGuideMode = bRes
	PlayerSetDataManager:GetInstance():SetGuideModeFlag(bRes)
	-- 如果不是引导模式, 那么请求一下公告
	if bRes ~= true then
		-- HttpHelper:RequestNotice(true, false)
		-- 接入MSDK公告
		xpcall(function() MSDKHelper:QueryNotice(false) end,function()
            derror("MSDKHelper:QueryNotice error")
		end)
	end
	-- 检查酒馆站人数据
	self:CheckAndShowHousePlayer()
	-- 引导模式下屏蔽一些按钮
	self.objMail_Button:SetActive(not bRes)
	self.objFriend_Button:SetActive(not bRes)
	self.objActivities:SetActive(not bRes)
	-- 导航栏
	OpenWindowImmediately("NavigationUI", {['bInTown'] = true})
	-- 聊天界面
	-- OpenWindowImmediately("ChatBoxUI")
	-- 玩家列表
	OpenWindowImmediately("TownPlayerListUI")

	GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_EnterHouse)
end

function HouseUI:CheckGuideMode()
	local iRenameCount = PlayerSetDataManager:GetInstance():GetReNameNum()
	if iRenameCount > 0 then
		-- 如果已经起过名, 那么酒馆自身退出引导模式, 以便可以点击剧本按钮
		-- 其他ui有没有退出引导模式无所谓, 因为引导会强制切换场景清空所有ui
		self.bIsGuideMode = false
	end
	if self.bIsGuideMode == true then
		SystemUICall:GetInstance():Toast("请先在个人界面创建形象")
		return true
	end
	return false
end

-- 这里实际上是返回上一个剧本, 暂时处理成打开选剧本界面
function HouseUI:OnClickEnterLastScript()
	self:OnClick_Story_Button()
end

function HouseUI:UpdateRoleName()
	local AppearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo()
    if not AppearanceInfo then
        return
    end
	local strName = AppearanceInfo.playerName or ""
	-- TIPS: 【【称号】酒馆主界面的头像下文本框内容需要把称号去除，只显示玩家所取的名字】
	-- https://www.tapd.cn/69041585/bugtrace/bugs/view?bug_id=1169041585001087351
    -- local tbl_RoleTitle = TableDataManager:GetInstance():GetTableData("RoleTitle",AppearanceInfo.titleID)
    -- if tbl_RoleTitle and tbl_RoleTitle.TitleID > 0 then
    --     strName = GetLanguageByID(tbl_RoleTitle.TitleID) .. "·" .. strName
    -- end
    self.textRoleName.text = strName
end

function HouseUI:OnClick_Story_Button()
	if self:CheckGuideMode() then
		return
	end
	-- RemoveWindowImmediately("ChatBoxUI")
	local kStoryUI = OpenWindowImmediately("StoryUI")
	if kStoryUI then
		kStoryUI:StartAnimaition()
	end
end

function HouseUI:OnClick_Arena_DRBtn(index, showBet)
	if CanOpenArena() then
		local info = {index = index, showBet = showBet}
		OpenWindowImmediately("ArenaUI", info)
	else
		SystemUICall:GetInstance():Toast('维护中');
	end
end

function HouseUI:OnClick_Storage_Button()
	local info = {}
	info.auiNewItems = StorageDataManager:GetInstance():GetRecordStoryEndItems()
	OpenWindowImmediately("StorageUI", info)	
end

function HouseUI:OnClickNoticeButton()
	-- HttpHelper:RequestNotice(true, true)
	-- 接入MSDK公告
	MSDKHelper:QueryNotice(true)
end

function HouseUI:OnClickDiscussBtn()
	local articleId = DiscussDataManager:GetInstance():GetDiscussTitleId(ArticleTargetEnum.ART_TOWN,1)
	if (articleId == nil) then
		SystemUICall:GetInstance():Toast('该讨论区暂时无法进入',false)
	else
		OpenWindowImmediately("DiscussUI",articleId)
	end
end

function HouseUI:OnClickCommunityButton()
	if (MSDKHelper == nil) then
		SystemUICall:GetInstance():Toast("未成功获取登录状态")
	else
		MSDKHelper:OpenCommunity()
	end
end

function HouseUI:OnClickXinYueButton()
	local icurTime = os.time()
	local playerid = PlayerSetDataManager:GetInstance():GetPlayerID() or 0
	CS.UnityEngine.PlayerPrefs.SetString('XinYueRedPointTime_' .. tostring(playerid) , icurTime)
	-- 直接隐藏红点
	self.xinyueRedImg:SetActive(self:IsXinYueRedPointShow())
	if (MSDKHelper) then
		MSDKHelper:SVipUrl()
	end
end

-- 心悦的红点是否显示
function HouseUI:IsXinYueRedPointShow()
	local icurTime = os.time()
	local playerid = PlayerSetDataManager:GetInstance():GetPlayerID() or 0
	local lastLaunchtime = CS.UnityEngine.PlayerPrefs.GetString('XinYueRedPointTime_' .. tostring(playerid))
	if (not lastLaunchtime or (tonumber(lastLaunchtime) == nil) or IsDiffWeek(tonumber(lastLaunchtime), icurTime) == true) then
		return true
	end

	return false
end

function HouseUI:OnClickQuestionButton()
	local questionUrl = HttpHelper:GetQuestionUrl()
	if (questionUrl ~= nil and questionUrl ~= "") then
		DRCSRef.MSDKWebView.OpenUrl(questionUrl)
	end
end

function HouseUI:OnClickChallengeOrderButton()
	if PlayerSetDataManager:GetInstance():GetChallengeOrderType() == COT_FREE then
		OpenWindowImmediately("ChallengeOrderUI")
	end
end

-- 点击排行榜按钮
function HouseUI:OnClickRankListButton()
	if self:CheckGuideMode() then
		return
	end
	OpenWindowImmediately("RankUI")
end

-- 点击3天签到
function HouseUI:OnClickDay3SignInButton()
	if self:CheckGuideMode() then
		return
	end
	OpenWindowImmediately("Day3SignInUI")
	self.objDay3SignInRedPoint:SetActive(false)
end

-- 3天签到通知
function HouseUI:OnRefDay3SignInNotice(info)
	if not (info and info.msg) then
		return
	end
	if Day3SignInDataManager:GetInstance():GetOpenState() ~= true then
		return
	end
	self.textDay3SignInNotice.text = info.msg or ""
	self.objDay3SignInNotice:SetActive(true)
	local fAnimTime = 0.5
	local twnFade = Twn_CanvasGroupFade(nil, self.canvasGroupDay3SignInNotice, 0, 1, fAnimTime)
	if (twnFade ~= nil) then
		twnFade:SetAutoKill(true)
	end
	
	-- 3秒后自动关闭
	local twnFade = Twn_CanvasGroupFade(nil, self.canvasGroupDay3SignInNotice, 1, 0, fAnimTime, 3, function()
		self.objDay3SignInNotice:SetActive(false)
		self.canvasGroupDay3SignInNotice.alpha = 1
	end)
	if (twnFade ~= nil) then
		twnFade:SetAutoKill(true)
	end
end

-- 点击7天活跃
function HouseUI:OnClickDay7TaskButton()
	if self:CheckGuideMode() then
		return
	end
	OpenWindowImmediately("Day7TaskUI")
	self.objDay7TaskRedPoint:SetActive(false)
end

-- 酒馆玩家显示相关 --------------------------------------
-- 这里是策划提供的可出现的假数据ModelID
local kFakeModelList = {
    [1] = {  -- man
        198,
        88,
        892,
        469,
        485,
        151,
        149,
    },
    [2] = {  -- woman
        907,
        349,
        904,
        898,
        908,
        596,
        28,
    },
}
-- 产生酒馆站立角色假数据
function HouseUI:MakeFakeAreaPlayersData(iNeedNum)
	iNeedNum = iNeedNum or 0
	if iNeedNum <= 0 then
		return
	end
	-- 获得一个随机名称
	local getRandomRoleName = function(iSex)
		local iFamiyID = nil
		local sFamilyName = nil
		local iFirstID = nil
		local sFirstName = nil
		local kData = nil
		local TB_RoleName = TableDataManager:GetInstance():GetTable("RoleName")
		for int_i = 1, #TB_RoleName do
			kData = TB_RoleName[int_i]
			if kData.RoleNameType == TextType.RNT_FamilyName then
				iFamiyID = math.random( kData.MinTextID, kData.MaxTextID)
				sFamilyName = GetLanguageByID(iFamiyID)
			elseif (kData.RoleNameType == TextType.RNT_FristName) and (kData.Sex == iSex) then
				iFirstID = math.random( kData.MinTextID, kData.MaxTextID)
				sFirstName = GetLanguageByID(iFirstID)
			end
			if sFamilyName and sFirstName then
				return sFamilyName .. sFirstName
			end
		end
		return ""
	end
	-- 获得一个随机模型
	local getRandomModelID = function(iSex)
		local kPool = kFakeModelList[iSex]
		local iMax = #kPool
		local iRandom = math.random(1, iMax)
		return kPool[iRandom] or kPool[1]
	end
	-- 生成假数据
	local akPlayersData = {}
	for index = 1, iNeedNum do
		local iSex = (index & 1) + 1
		akPlayersData[index] = {
			["defPlyID"] = 0,
			["acPlayerName"] = getRandomRoleName(iSex),
			["dwModelID"] = getRandomModelID(iSex),
		}
	end
	return akPlayersData
end

-- 初始化AreaID -> PlayerObj
function HouseUI:InitAreaID2PlayerObjs()
	local id2PlayerObjSlots = {}  -- 通过玩家id查找玩家模型插槽
	local id2AreaObjs = {}  -- 通过区域id查找区域游戏对象
	local id2CPosPlayerObjIndex = {}  -- 通过区域id查找当前区域的c位玩家模型
	local areaName2ID = {}  -- 通过区域名称查找该区域的区域id
	local objRoot = self.objSceneRoot
	-- 最大区域ID获取直接从子节点个数获取
	self.iMaxAreaID = objRoot.transform.childCount - 1
	-- 获取一个场景节点中所有的玩家模型节点
	local genAllPlayerNodesInScene = function(id, objScene)
		if not (id and objScene) then
			return
		end
		id2PlayerObjSlots[id] = {}
		local index = 1
		local objPlayersNode = self:FindChild(objScene, "Players_node_" .. index)
		local transPlayersNode = nil
		local comSlot = nil
		local transSlot = nil
		local objSlot = nil
		local objSpot = nil
		local objShowPet = nil
		while objPlayersNode do
			transPlayersNode = objPlayersNode.transform
			for i = 0, transPlayersNode.childCount - 1 do
				transSlot = transPlayersNode:GetChild(i)
				objSlot = transSlot.gameObject
				objSlot:SetActive(false)
				comSlot = objSlot:GetComponent("PlayerSpineItemSlot")
				id2PlayerObjSlots[id][#id2PlayerObjSlots[id] + 1] = {
					['transObj'] = transSlot,
					['obj'] = objSlot,
					['bSpotOn'] = (comSlot.bSpotOn == true),
					['bIsFlip'] = (comSlot.bIsFlip == true),
					['v3ParentScale'] = transSlot.localScale,
				}
				-- 玩家模型中, 打光的就是c为模型, 默认c位选择为第一个玩家模型
				if (not id2CPosPlayerObjIndex[id]) or (comSlot.bSpotOn == true) then
					id2CPosPlayerObjIndex[id] = #id2PlayerObjSlots[id]
				end
			end
			index = index + 1
			objPlayersNode = self:FindChild(objScene, "Players_node_" .. index)
		end
	end
	-- 获取id->模型对象  id->区域对象
	local objArea = nil
	local sAreaName = nil
	for id = 0, self.iMaxAreaID do
		sAreaName = "Scene_" .. tostring(id + 1)
		objArea = self:FindChild(objRoot, sAreaName)
		if objArea then
			-- 记录第一个场景节点和最后一个场景节点
			if id == 0 then
				self.objFirstScene = objArea
				self.vec3OriFirstScenePos = objArea.transform.localPosition
			elseif id == self.iMaxAreaID then
				self.objLastScene = objArea
				self.vec3OriLastScenePos = objArea.transform.localPosition
			end
			id2AreaObjs[id] = objArea
			areaName2ID[sAreaName] = id
			-- 玩家模型的节点分散在场景节点的 Players_node_x 中
			genAllPlayerNodesInScene(id, objArea)
		end
	end
	self.areaID2PlayerObjSlots = id2PlayerObjSlots
	self.areaName2ID = areaName2ID
	self.id2AreaObjs = id2AreaObjs
	self.areaID2CPosPlayerObjIndex = id2CPosPlayerObjIndex
	-- 分析单次移动场景的距离 = 场景宽度 + 衔接部分的宽度
	local objScene = self.objFirstScene
	local transScene = objScene:GetComponent('RectTransform')
	local objSceneSide = self:FindChild(objScene, "side") 
	local transSceneSide = objSceneSide:GetComponent('RectTransform')
	self.iMoveDis = transScene.rect.width + transSceneSide.rect.width
	-- 分析场景根节点在首尾场景时的本地位置
	local iRootXOnFirstScene = self.objSceneRoot.transform.localPosition.x
	local iRootXOnLastScene = iRootXOnFirstScene - self.iMaxAreaID * self.iMoveDis
	local vec3OriRootPos = self.objSceneRoot.transform.localPosition
	self.vec3RootPosOnFirstScene = DRCSRef.Vec3(iRootXOnFirstScene, vec3OriRootPos.y, vec3OriRootPos.z)
	self.vec3RootPosOnLastScene = DRCSRef.Vec3(iRootXOnLastScene, vec3OriRootPos.y, vec3OriRootPos.z)
end

-- 检查并显示酒馆玩家
function HouseUI:CheckAndShowHousePlayer()
	-- 需要同时获得 引导的状态 玩家spine状态 之后, 才能显示酒馆玩家
	-- 这个check接口会在这两个标记被设置的时候调用并检查
	if (self.bIsGuideMode == nil) or (self.bPlayerSpineReady == nil) then
		return
	end
	-- 进入酒馆
	self:OnEnterHouse()
	-- 开启酒馆伪刷新机制
	self:OpenHousePlayerUpdate()
end

-- 进入酒馆回调
function HouseUI:OnEnterHouse()
	--
	self:OnRefHead();
	-- 初始化区域id
	self.curArea = self.curArea or 0
	-- 引导模式下使用假数据
	if self.bIsGuideMode == true then
		local iPlayersNum = #(self.areaID2PlayerObjSlots[self.curArea] or {})
		local akPlayersData = self:MakeFakeAreaPlayersData(iPlayersNum)
		self:SetAreaPlayers(self.curArea, akPlayersData)
		return
	end
	-- 请求分线玩家数据
	self:RequestAreaPlayersData(self.curArea)
end

-- 服务器下行分线数据回调
function HouseUI:OnReceiveAreaPlayersData(kStreamData)
	if not kStreamData then 
		return 
	end
	local iAreaID = kStreamData["dwPageID"]
	local akPlayersData = kStreamData["kPlatPlayerSimpleInfos"]

	--
	if self.bInArena then
		self.arenaDataManager:SetArenaScenePlayerData(kStreamData);
		self.downCount = self.downCount + 1;
		if self.downCount == 4 then
			akPlayersData = self.arenaDataManager:GetArenaScenePlayerData();
			self:SetAreaPlayers(self.iMaxAreaID, akPlayersData);
		end
	else
		self:SetAreaPlayers(iAreaID, akPlayersData)
	end
end

-- 场景移动
function HouseUI:OnSceneMove()
	self.sChangeSceneAction = nil
	if self.bSceneMoving == true then
		return
	end
	-- 场景移动偏移
	local iDeltaX = self.transSceneContent.position.x - self.iOriSceneContentX
	-- 移动前的场景预处理
	if (not self.iSceneMovePreProcess) or (self.iSceneMovePreProcess <= 0) then
		self.iSceneMovePreProcess = self:OnBeginSceneMove(self.curArea, iDeltaX)
	end

	local iThresholdProcessJunction = 0.2  -- 设定一个阈值, 当酒馆滑动偏移超过阈值时处理连接点
	if (iDeltaX >= iThresholdProcessJunction) or (iDeltaX <= -iThresholdProcessJunction) then
		local iDir = (iDeltaX > 0) and 1 or -1
		if (self.bHasProcessJunction == nil) or (self.bHasProcessJunction ~= iDir) then
			self.comJunctionController:SetTargetScene(self.id2AreaObjs[self.curArea], self.iMoveDis, iDir)
			self.bHasProcessJunction = iDir
		end
	end
	
	local iThreshold = 5  -- 设定一个阈值, 当酒馆滑动偏移超过阈值时切换场景
	if iDeltaX >= iThreshold then  --往右移, 左边场景出现
		self.sChangeSceneAction = "right"
	elseif iDeltaX <= -iThreshold then  -- 往左移, 右边场景出现
		self.sChangeSceneAction = "left"
	end
end

-- 检查是否需要切换场景
function HouseUI:CheckSceneChangeAction()
	if self.bSceneMoving == true then
		return
	end
	local iMoveFactor = nil
	if self.sChangeSceneAction == "left" then
		iMoveFactor = -1
	elseif self.sChangeSceneAction == "right" then
		iMoveFactor = 1
	end
	if not iMoveFactor then
		-- 如果没有触发拖拽移动操作, 直接复位首尾场景的位置
		self:OnEndSceneMove(false)
		return
	end
	self.bSceneMoving = true
	self.curArea = self.curArea - iMoveFactor
	-- id循环处理
	if self.curArea < 0 then
		self.curArea = self.iMaxAreaID
	elseif self.curArea > self.iMaxAreaID then
		self.curArea = 0
	end
	-- 请求新场景的玩家数据
	self.bInArena = self.curArea == self.iMaxAreaID;
	if self.bInArena then
		self.downCount = 0;
		for i = 0, self.iMaxAreaID do
			SendGetPlatPlayerSimpleInfos(PSIOT_AREA, i, SSD_MAX_PLAYER_COUNT_PER_PLAT_AREA)
		end
	else
		self:RequestAreaPlayersData(self.curArea)
	end
	-- 场景移动结束回调
	local callbackMoveEnd = function()
		self.bSceneMoving = false
		self:OnEndSceneMove(true, iMoveFactor)
	end
	local fMoveTime = 0.5  -- 场景滑动的时间 
	local twn_move = Twn_MoveX(nil, self.objSceneRoot, iMoveFactor * self.iMoveDis, fMoveTime, DRCSRef.Ease.OutCubic, callbackMoveEnd)
	if (twn_move ~= nil) then
		twn_move:SetAutoKill(true)
	end
end

-- 场景开始移动前处理
function HouseUI:OnBeginSceneMove(iBeforeMovingAreaID, iDir)
	-- 如果当前在区域0 , 手指往右移的话, 那么要将最后一个区域移动到场景0的前面来
	if (iBeforeMovingAreaID == 0) and (iDir > 0) then
		local iObjFirstX = self.objFirstScene.transform.localPosition.x
		local vec3OriObjLastPos = self.objLastScene.transform.localPosition
		vec3OriObjLastPos.x = iObjFirstX - self.iMoveDis
		self.objLastScene.transform.localPosition = vec3OriObjLastPos
		return 1
	-- 如果当前在最后一个区域, 手指往左移的话, 那么将第一个区域移动到最后一个区域的后面去
	elseif (iBeforeMovingAreaID == self.iMaxAreaID) and (iDir < 0) then
		local iObjLastX = self.objLastScene.transform.localPosition.x
		local vec3OriObjFirstPos = self.objFirstScene.transform.localPosition
		vec3OriObjFirstPos.x = iObjLastX + self.iMoveDis
		self.objFirstScene.transform.localPosition = vec3OriObjFirstPos
		return 2
	end
	return 0
end

-- 场景移动结束后处理
function HouseUI:OnEndSceneMove(bMoveSuccess, iDir)
	-- 是否成功预处理场景
	bMoveSuccess = (bMoveSuccess== true)
	-- EndFollow(bool bKeepCurJunction = false)
	self.comJunctionController:EndFollow(not bMoveSuccess)
	if bMoveSuccess then
		self.bHasProcessJunction = nil
	end
	-- 后处理中只需要针对首尾两个场景进行复位, 并且在场景拖拽动作成功触发时对整体位移
	local iCurFirstSceneX = self.objFirstScene.transform.localPosition.x
	local iCurLastSceneX = self.objLastScene.transform.localPosition.x
	-- 复位操作
	if (self.iSceneMovePreProcess == 2) and (iCurLastSceneX > 0) and (iCurFirstSceneX > iCurLastSceneX) then
		self.objFirstScene.transform.localPosition = self.vec3OriFirstScenePos
		-- 重定位到首场景
		if bMoveSuccess and iDir and (iDir < 0) then
			self.objSceneRoot.transform.localPosition = self.vec3RootPosOnFirstScene
		end
	elseif (self.iSceneMovePreProcess == 1) and (iCurLastSceneX < 0) and (iCurLastSceneX < iCurFirstSceneX) then
		self.objLastScene.transform.localPosition = self.vec3OriLastScenePos
		-- 重定位到尾场景
		if bMoveSuccess and iDir and (iDir > 0) then
			self.objSceneRoot.transform.localPosition = self.vec3RootPosOnLastScene
		end
	end
	-- 清空预处理标记
	self.iSceneMovePreProcess = nil

	-- 移动成功做的一些处理
	if bMoveSuccess then
		LuaEventDispatcher:dispatchEvent("HOUSE_SCENE_MOVE_END")
	end
end

function HouseUI:RequestRedPointActivitys()
	-- 查一次需要标记为红点的活动
	if not self.bRequestRPActivitys then
		self.bRequestRPActivitys = true
		ActivityHelper:GetInstance():RequestRedPointActivitys()
	end
end

-- 请求分线玩家数据
function HouseUI:RequestAreaPlayersData(iAreaID)
	if self.AreaRequestCDFlag[iAreaID] == true then
		-- 记录一下当前想要请求但是却被cd拦截的区域id
		self.uiForbidByCDAreaID = iAreaID
		return
	end
	self.uiForbidByCDAreaID = nil
	self.curArea = self.curArea or 0
	local iId2Req = iAreaID or self.curArea
	self.AreaRequestCDFlag[iId2Req] = true
    if self.bIServerMode == true then
		-- 请求分线玩家数据, 等待下行
		SendGetPlatPlayerSimpleInfos(PSIOT_AREA, iId2Req, SSD_MAX_PLAYER_COUNT_PER_PLAT_AREA)
	else
		-- 假数据测试代码
		self:SetAreaPlayers(iId2Req, self:MakeFakeAreaPlayersData(#(self.areaID2PlayerObjSlots[iId2Req] or {})))
    end
	-- 开启刷新冷却计时器
	globalTimer:AddTimer(4000, function()
		local win = GetUIWindow("HouseUI")
		if win then
			win.AreaRequestCDFlag[iId2Req] = false
			-- 如果某个区域的数据请求被cd拦截导致没有请求
			-- 计时器到期后还是停留在这个界面上
			-- 那么发起一次请求
			if win.uiForbidByCDAreaID == iId2Req then
				win.uiForbidByCDAreaID = nil
				win:RequestAreaPlayersData(iId2Req)
			end
		end
	end)
end

-- 预处理玩家数据
function HouseUI:PreProcessPlayersData(iAreaID, akPlayersData)
	-- 获取当前区域c位ID
	self.areaID2CPosPlayerObjIndex = self.areaID2CPosPlayerObjIndex or {}
	local iCurAreaCPosID = self.areaID2CPosPlayerObjIndex[iAreaID] or 1
	-- 拿到 "我" 的数据
	akPlayersData = akPlayersData or {}
	local playerSetMgr = PlayerSetDataManager:GetInstance()
	local iMyID = playerSetMgr:GetPlayerID() or 0
	local kMyData = {
		['defPlyID'] = iMyID,
		['acPlayerName'] = playerSetMgr:GetPlayerName() or "",
		['dwModelID'] = playerSetMgr:GetModelID() or 0,
		['IsME'] = true,
	}
	-- 遍历一遍玩家数据, 去重, 并且如果存在"我"的数据, 找出索引
	local akPlayersSet = {}
	local kSetCheck = {}
	local uiMyDataIndex = nil
	local uiStartIndex = akPlayersData[0] and 0 or 1
	for index = uiStartIndex, #akPlayersData, 1 do
		local data = akPlayersData[index]
		local uiPlayerID = data.defPlyID
		if uiPlayerID and (uiPlayerID > 0) and (kSetCheck[uiPlayerID] ~= true) then
			kSetCheck[uiPlayerID] = true
			akPlayersSet[#akPlayersSet + 1] = data
			if uiPlayerID == iMyID then
				uiMyDataIndex = #akPlayersSet
			end
		end
	end
	-- 检查c位位置是否在数据集之内
	-- 如果在内部, 并且存在"我"的数据下标, 那么将"我"的数据与c位玩家互换
	-- 否则直接将"我"的数据放在c位, 如果存在"我"的数据下标, 移除对应位置的数据
	if (iCurAreaCPosID <= #akPlayersSet)
	and uiMyDataIndex and (uiMyDataIndex > 0) then
		local tempPlayer = akPlayersSet[iCurAreaCPosID]
		akPlayersSet[iCurAreaCPosID] = kMyData
		akPlayersSet[uiMyDataIndex] = tempPlayer
		return akPlayersSet
	end
	if uiMyDataIndex and (uiMyDataIndex > 0) then
		akPlayersSet[uiMyDataIndex] = nil
	end
	akPlayersSet[iCurAreaCPosID] = kMyData
	return akPlayersSet
end
function HouseUI:RefreshShowPet()
	if not self.kMeSpineBindData then
		return
	end

	local PlatShowInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo() or {}
	local kPetBaseData = TableDataManager:GetInstance():GetTableData("Pet", PlatShowInfo.showPetID or 0)
	local iPetModelID = nil
	if kPetBaseData then 
		iPetModelID = kPetBaseData.ArtID
	end 
	local kPetModelData = TableDataManager:GetInstance():GetTableData("RoleModel", iPetModelID or 0)
	local data = {
		['kPetModelData'] = kPetModelData,
		['bRefreshPetOnly'] = true,
	}
	self.kMeSpineBindData:RefreshUI(data);
end

-- 将底部站人全部归还给对象池
function HouseUI:ReturnAllStandPlayers()
	if (not self.akPlayerSpineItems) or (#self.akPlayerSpineItems <= 0) then
		return
	end
	LuaClassFactory:GetInstance():ReturnAllUIClass(self.akPlayerSpineItems)
    self.akPlayerSpineItems = {}
end

-- 创建一个底部站人
function HouseUI:CreateStandPlayer(kData)
	if not kData then
		return
	end
	local kBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.PlayerSpineItemUI, kData.transObj, kData)
	kBindData:RefreshUI(kData)
	self.akPlayerSpineItems[#self.akPlayerSpineItems + 1] = kBindData
	return kBindData
end

-- 设置酒馆模型数据
function HouseUI:SetAreaPlayers(iAreaID, akPlayersData, bAll)
	local akPlayersSet = self:PreProcessPlayersData(iAreaID, akPlayersData)
	if not (iAreaID and akPlayersSet and next(akPlayersSet)) then
		return
	end

	if not (self.areaID2PlayerObjSlots and self.areaID2PlayerObjSlots[iAreaID]) then
		return
	end

	self:ReturnAllStandPlayers()

	local TBPetData = TableDataManager:GetInstance():GetTable("Pet")
	local TBRoleModel = TableDataManager:GetInstance():GetTable("RoleModel")

	local InitSpineWithData = function(kSlotInfo, kData)
		if not (kSlotInfo and kData) then return end

		local tempPetData = TBPetData[kData.dwPetID];
		local artID = tempPetData and tempPetData.ArtID or 0;

		kSlotInfo.kPetModelData = TBRoleModel[artID]
		kSlotInfo.kTarModelData = TBRoleModel[kData.dwModelID]
		kSlotInfo.defPlyID = kData.defPlyID
		local strName = kData.acPlayerName
		if kData.bUnlockHouse == 0 then
			strName = STR_ACCOUNT_DEFAULT_PREFIX .. tostring(kData.defPlyID or 0)
		end
		if (not strName) or (strName == "") then
			strName = STR_ACCOUNT_DEFAULT_NAME
		end
		kSlotInfo.acPlayerName = strName
		kSlotInfo.titleID = kData.dwTitleID
		kSlotInfo.IsME = (kData.IsME == true)
		local kBindData = self:CreateStandPlayer(kSlotInfo)
		-- 记录主角站位的节点
		if kSlotInfo.IsME then
			self.kMeSpineBindData = kBindData
		end
	end

	-- 初始化酒馆内的玩家Spine
	local akSlots = self.areaID2PlayerObjSlots[iAreaID]
	local kData = nil
	for index, kSlotInfo in ipairs(akSlots) do
		if akPlayersSet[index] then
			kData = akPlayersSet[index]
			if bAll == false  then
				if kData.IsME == true then
					InitSpineWithData(kSlotInfo, kData)
					kSlotInfo.obj:SetActive(true)
				end
			else
				kData = akPlayersSet[index]
				InitSpineWithData(kSlotInfo, kData)
				kSlotInfo.obj:SetActive(true)
			end
		else
			kSlotInfo.obj:SetActive(false)
		end
	end

	-- 更新完所有角色之后, 刷新一下自己的宠物
	self:RefreshShowPet()
end

-- 酒馆玩家伪刷新机制
function HouseUI:OpenHousePlayerUpdate()
	if not (self:IsOpen() and self:IsActive()) then
		self.iCurTimerIndex = nil
		return
  end
  if (self.iCurTimerIndex ~= nil) then
    globalTimer:RemoveTimer(self.iCurTimerIndex)
    self.iCurTimerIndex = nil
  end
	-- 一分钟刷新一次
	self.iCurTimerIndex = globalTimer:AddTimer(60000, function()
		local win = GetUIWindow("HouseUI")
		if win then
			win:RequestAreaPlayersData(self.curArea or 0)
		end
	end, -1)
end

-- 关闭酒馆伪刷新机制
function HouseUI:CloseHousePlayerUpdate()
	if not self.iCurTimerIndex then
		return
	end
	globalTimer:RemoveTimer(self.iCurTimerIndex)
end

-- 更新完整版显示状态
function HouseUI:UpdateChallengeOrder()
	if not self.btnChallengeOrder then
		return
	end

	local eType = PlayerSetDataManager:GetInstance():GetChallengeOrderType()
	local bUnlock = (eType and eType ~= COT_FREE)
	local bOpen = (not bUnlock) and (self.bDay3SignInOpen == false)

	self.btnChallengeOrder.gameObject:SetActive(bOpen)
end

--====================================================================================================
-- 刷新酒馆工具栏红点提示
function HouseUI:SetToolBarRedPoint(strKey, bOn)
	if not self.kToolBarRedPointOn then
		self.kToolBarRedPointOn = {}
	end
	if bOn == true then
		self.kToolBarRedPointOn[strKey] = bOn
	else
		self.kToolBarRedPointOn[strKey] = nil
	end
	if self.bRightToolBarClose then
		self.objRightToolBarRedPoint:SetActive(true)
	end
end

function HouseUI:OnRefHeadAndSpine()
	self:OnRefHead();
	self:OnRefSpine();
end

function HouseUI:OnRefSpine()
	self.curArea = self.curArea or 0
	local iPlayersNum = #(self.areaID2PlayerObjSlots[self.curArea] or {})
	local akPlayersData = self:MakeFakeAreaPlayersData(iPlayersNum)
	self:SetAreaPlayers(self.curArea, akPlayersData, false);
end

function HouseUI:OnRefHead()
	self.headImage = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/Button_Role/head", "Image");
	local callback = function(sprite)
		local uiWindow = GetUIWindow("HouseUI")
		if (uiWindow) then
			self.headImage.sprite = sprite
		end
	end
	if (MSDKHelper ~= nil) then
		MSDKHelper:SetHeadPic(callback)
	end
	local objPar = self:FindChild(self._gameObject, "TransformAdapt_node_right/Button_Role/bg_2")
	if objPar and not self.objheadboxUI then 
		self.objheadboxUI = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,objPar.transform)
	end 
	if self.objheadboxUI then  
		self.objheadboxUI._gameObject:SetActive(true)
		self.objheadboxUI:SetReplacedHeadBoxUI(objPar,true)	
		self.objheadboxUI:SetPlayerID()	
	end 
end

function HouseUI:RefreshUI()
	
	--
	self:RefMailRedPoint();
	self:RefFriendRedPoint();
	self:RefreshActivityRedPoint()
	--
	self:ShowSelfLoginWord();
	self:ShowResultGuide();

	--
	self:RefPrivilegeUI();
	self:updateLandLadySpine()

	-- 查一遍隐藏的商品数据
	SendPlatShopMallQueryItem(RackItemType.RTT_SIGN)
	-- 获取活动数据
	SendQueryTreasureBookInfo(STBQT_TASK,0,STBTT_ACTIVITY)
	-- 获取需要显示红点的活动
	self:RequestRedPointActivitys()
	-- 检查百宝书赠送邮件
	self:CheckTreasureBookSendMail()
end

function HouseUI:RefPrivilegeUI()
	if not MSDKHelper:IsPlayerTestNet() then
		self.tencentBtnGroup:SetActive(true);
		self.objWxPrivilegeBtn:SetActive(false);
		self.objQQPrivilegeBtn:SetActive(false);
		self.exclusiveBtnQQ.gameObject:SetActive(false);
		self.exclusiveBtnWX.gameObject:SetActive(false);
		self.exclusiveBtn4399.gameObject:SetActive(false);
		self.exclusiveBtnHYKB.gameObject:SetActive(false);
		self.weishequBtn.gameObject:SetActive(true);
		self.xinyueBtn.gameObject:SetActive(false);
		self.gongzhongBtn.gameObject:SetActive(false);
		self.tapgonglueBtn.gameObject:SetActive(false);
		self.xinyueRedImg:SetActive(self:IsXinYueRedPointShow())
		

		local _setActive = function(param, bActive)
			if param then
				self.serviceBtn.gameObject:SetActive(param.serviceBtn or false);
				self.gameClubBtn.gameObject:SetActive(param.gameClubBtn or false);
				self.gameTribeBtn.gameObject:SetActive(param.gameTribeBtn or false);
				self.tapTapBtn.gameObject:SetActive(param.tapTapBtn or false);
				self.huaWeiBtn.gameObject:SetActive(param.huaWeiBtn or false);
				self.xiaoMiBtn.gameObject:SetActive(param.xiaoMiBtn or false);
				self.g4399Btn.gameObject:SetActive(param.g4399Btn or false);
				self.hykbBtn.gameObject:SetActive(param.hykbBtn or false);
				self.bwikiBtn.gameObject:SetActive(param.bwikiBtn or false);
				self.objShareFriendtn.gameObject:SetActive(param.shareFriend or false);
				self.xinyueBtn.gameObject:SetActive(param.xinyueBtn or false);
				self.gongzhongBtn.gameObject:SetActive(param.gongzhongBtn or false);
				self.tapgonglueBtn.gameObject:SetActive(param.tapgonglueBtn or false);

				if bActive then
					if tostring(GetCurChannelID()) == CHANNEL.G4399 then
						self.exclusiveBtn4399.gameObject:SetActive(true);
					elseif tostring(GetCurChannelID()) == CHANNEL.HYKB then
						self.exclusiveBtnHYKB.gameObject:SetActive(true);
					else
						-- 手Q平台
						if MSDKHelper:IsLoginQQ() then
							self.exclusiveBtnQQ.gameObject:SetActive(true);
							self.objQQPrivilegeBtn:SetActive(true)
						end
						-- 微信平台
						if (MSDKHelper:IsLoginWeChat()) then
							self.exclusiveBtnWX.gameObject:SetActive(true);
							self.objWxPrivilegeBtn:SetActive(true);
							local objRedPointImage = self:FindChild(self.exclusiveBtnWX.gameObject, "Image_redPoint")
							-- 判断是否需要显示红点
							local playerid = PlayerSetDataManager:GetInstance():GetPlayerID() or 0
							local lastclicktime = CS.UnityEngine.PlayerPrefs.GetString('WXExclusiveRedPointTime_' .. tostring(playerid)) or '0'
							lastclicktime = tonumber(lastclicktime)
							if (lastclicktime == nil or IsDiffWeek(lastclicktime, os.time())) then
								-- 这里显示红点
								objRedPointImage:SetActive(true)
							else
								-- 这里隐藏红点
								objRedPointImage:SetActive(false)
							end
						end
					end
				end
			end
		end

		local _QQ = function()
			local param = {};
			param.serviceBtn = true;
			param.gameTribeBtn = true;
			param.xinyueBtn = true;
			_setActive(param, true);
		end

		local _WeChat = function()
			local param = {};
			param.serviceBtn = true;
			param.gameClubBtn = true;
			param.shareFriend = true;
			param.xinyueBtn = true;
			param.gongzhongBtn = true;
			_setActive(param, true);
		end

		local _CommonFunc = function()
			if MSDKHelper:IsLoginQQ() then
				_QQ();
			elseif MSDKHelper:IsLoginWeChat() then
				_WeChat();
			end
		end

		local _TapTap = function()
			local param = {};
			param.serviceBtn = true;
			param.tapTapBtn = true;
			param.tapgonglueBtn = true;
			_setActive(param);
		end

		local _HuaWei = function()
			local param = {};
			param.serviceBtn = true;
			_setActive(param);
		end

		local _XiaoMi = function()
			local param = {};
			param.serviceBtn = true;
			_setActive(param);
		end

		local _4399 = function()
			local param = {};
			param.serviceBtn = true;
			param.g4399Btn = true;
			_setActive(param, true);
		end

		local _HYKB = function()
			local param = {};
			param.serviceBtn = true;
			param.hykbBtn = true;
			_setActive(param, true);
		end

		local _Bweb = function()
			local param = {};
			param.serviceBtn = true;
			param.bwikiBtn = true;
			_setActive(param);
		end

		local _OV = function()
			local param = {};
			param.serviceBtn = true;
			_setActive(param);
		end

		local tabFunc = {
			[CHANNEL.OFFICIAL] 	= _CommonFunc,
			[CHANNEL.WX] 		= _CommonFunc,
			[CHANNEL.QQ] 		= _CommonFunc,
			[CHANNEL.YYB] 		= _CommonFunc,
			[CHANNEL.TAPTAP] 	= _TapTap,
			[CHANNEL.TAPTAP2] 	= _TapTap,
			[CHANNEL.HW] 		= _HuaWei,
			[CHANNEL.XM] 		= _XiaoMi,
			[CHANNEL.G4399] 	= _4399,
			[CHANNEL.HYKB] 		= _HYKB,
			[CHANNEL.BWEB] 		= _Bweb,
			[CHANNEL.OPPO] 		= _OV,
			[CHANNEL.VIVO] 		= _OV,
		}

		-- TODO
		-- 官网包+QQ登录
		local regChannel = tostring(GetCurChannelID());
		if regChannel and tabFunc[regChannel] then
			tabFunc[regChannel]();
		else
			if MSDKHelper:IsLoginWeChat() then
				_WeChat();
			elseif MSDKHelper:IsLoginQQ() then
				_QQ();
			end
		end
	end
end

function HouseUI:ShowResultGuide()
	local playerID = globalDataPool:getData('PlayerID');
	local resultGuide = GetConfig(tostring(playerID) .. '#ResultGuide');
	if IsOveredStory(2) and (not resultGuide) then
		SetConfig(tostring(playerID) .. '#ResultGuide', 1, true);
		OpenWindowImmediately('ResultUIGuide');
	end
end

function HouseUI:ShowSystemOpen()
	if GuideDataManager:GetInstance():IsGuideRunning() then 
		return 
	end 
	if self.bIsGuideMode == true then
		return
	end

	local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
	local sortTable = {};
	local TB_System = TableDataManager:GetInstance():GetTable('SystemOpenLanguage');
	for k, v in pairs(TB_System) do
		table.insert(sortTable, v);
	end

	table.sort(sortTable, function(a, b)
		return a.BaseID < b.BaseID;
	end)

	local tempData = nil;
	for i = 1, #(sortTable) do
		if sortTable[i].BaseID <= time then
			tempData = sortTable[i];
		end
	end

	if tempData then
		local playerID = globalDataPool:getData('PlayerID');
		local systemOpen = GetConfig(tostring(playerID) .. '#SystemOpen') or {};
		if not systemOpen[tostring(tempData.BaseID)] then
			systemOpen[tostring(tempData.BaseID)] = 'true';
			SetConfig(tostring(playerID) .. '#SystemOpen', systemOpen, true);
			
			local language = GetLanguageByID(tempData.LanguageID);
			local info = {
				type = 'l',
				title = '系统提示',
				text = language,
			}
			if language ~= '' then
				OpenWindowImmediately('PopUpWindowUI', info);
			end
		end
	end
end

function HouseUI:AddLittlePacket()
	local packetData = self.MoneyPacketDataManager:GetPacketData();
	if true or packetData and #(packetData) > 0 then
		OpenWindowImmediately("LittlePacketUI");
	else
		RemoveWindowImmediately("LittlePacketUI");
	end
end

function HouseUI:AddArenaMatchNotice()
	local _addLocalNotice = function()
		local _tonumber = function(array)
			for i = 1, #(array) do
				array[i] = tonumber(array[i]);          
			end
			return array;
		end
	
		local bInTime = false;
		local tbData = ArenaDataManager:GetInstance():GetTBMatchData();
		for i = 1, #(tbData) do
			if tbData[i].BaseID == 5 or tbData[i].BaseID == 6 then		
				local tTime = tbData[i].MatchTime;
				local timeTable = string.split(tTime, ';');
				local openWeekday = _tonumber(string.split(timeTable[1], '-'));
				local openFromTime = _tonumber(string.split(timeTable[2], ':'));
				local openToTime = _tonumber(string.split(timeTable[3], ':'));
				local week = tonumber(os.date('%w'));
				week = week == 0 and 7 or week;
				if week == openWeekday[1] then
					if InTime(os.time(), openFromTime, openToTime) then
						bInTime = true;
						break;
					end
				end 
			end
		end
		
		if not self.bInArena and bInTime then
	
			local info = nil;
			local temp = clone(BubbleText);
			local matchData = ArenaDataManager:GetInstance():GetFormatData();
			for k, v in pairs(matchData) do
				if v.dwMatchType == 5 or v.dwMatchType == 6 then
					if v.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET or
					v.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
						info = v;
					end
				end
			end
	
			if info then
				local times = math.random(RandomDown, RandomUp);
				local _func2;
				_func2 = function()
					local random = math.random(1, #(temp));
					local strNotice = table.remove(temp, random);
					local a, b = string.find(strNotice, '%%s');
					if a and b then
						if a > 1 then
							strNotice = string.format(strNotice, RoundToString[info.dwRoundID]);
						else
							local battleData = ArenaDataManager:GetInstance():GetBattleDataBy(info.dwMatchType, info.dwMatchID);
							local random = math.random(1, #(battleData[info.dwRoundID]));
							local name = battleData[info.dwRoundID][random].kPly1Data.acPlayerName;
							strNotice = string.format(strNotice, name);
						end
					end
	
					SystemUICall:GetInstance():AddBubble(strNotice);
	
					times = times - 1;
					if times > 0 then
						local delay = math.random(DelayTimeDown, DelayTimeUp);
						self:AddTimer(delay, _func2, 1);
					end
				end
				_func2();
			end
			
		end
  end
  if (self.arenaNoticeTimer ~= nil) then
    self:RemoveTimer(self.arenaNoticeTimer)
    self.arenaNoticeTimer = nil
  end
	self.arenaNoticeTimer = self:AddTimer(UpdateTime, _addLocalNotice, -1);
end

function HouseUI:RefMailRedPoint()
	local count = SocialDataManager:GetInstance():GetMailRedPoint();
	local redPoint = self:FindChild(self.objMail_Button, 'Image_redPoint');
    -- self:FindChildComponent(redPoint, 'Text', 'Text').text = count;
    if count > 0 then
		redPoint:SetActive(true);
		self:SetToolBarRedPoint("Mail", true)
    else
		redPoint:SetActive(false);
		self:SetToolBarRedPoint("Mail", false)
    end
end

function HouseUI:RefFriendRedPoint()
	local count = #(SocialDataManager:GetInstance():GetApplyData2());
	local redPoint = self:FindChild(self.objFriend_Button, 'Image_redPoint');
    -- self:FindChildComponent(redPoint, 'Text', 'Text').text = count;
    if count > 0 then
		redPoint:SetActive(true);
		self:SetToolBarRedPoint("Friend", true)
    else
		redPoint:SetActive(false);
		self:SetToolBarRedPoint("Friend", false)
    end
end

function HouseUI:OnRefShowText()
	local singleData = self.arenaDataManager:GetCurMatchData(MATCH_BASEID.SINGLE);
	local teamData = self.arenaDataManager:GetCurMatchData(MATCH_BASEID.TEAM);

	local strText1 = ''
	local strText2 = ''

	if teamData then
		if teamData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_NONE then

		elseif teamData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP then
			strText1 = '大师赛报名中';
		elseif teamData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_CALC_BATTLE_RESULT then
			strText1 = '大师赛计算中';
		elseif teamData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_START_MATCH then
			strText1 = '大师赛比赛开始';
		elseif teamData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
			strText1 = '组队擂台';
			strText2 = RoundToString[teamData.dwRoundID] .. '助威中';
		elseif teamData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
			strText1 = '组队擂台';
			strText2 = RoundToString[teamData.dwRoundID] .. '观战中';
		elseif teamData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
			strText1 = '大师赛比赛结束';

		end
	end

	if singleData then
		if singleData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_NONE then
			
		elseif singleData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP then
			strText1 = '大师赛报名中';
		elseif singleData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_CALC_BATTLE_RESULT then
			strText1 = '大师赛计算中';
		elseif singleData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_START_MATCH then
			strText1 = '大师赛比赛开始';
		elseif singleData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
			strText1 = '单人擂台';
			strText2 = RoundToString[singleData.dwRoundID] .. '助威中';
		elseif singleData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
			strText1 = '单人擂台';
			strText2 = RoundToString[singleData.dwRoundID] .. '观战中';
		elseif singleData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
			
		end
	end

	self.objText_1:GetComponent('Text').text = strText1;
	self.objText_2:GetComponent('Text').text = strText2;
end

function HouseUI:OnRefArenaScene(data)
	local daShiData = self.arenaDataManager:GetHistoryData(ARENA_TYPE.DA_SHI);
	local huaShanData = self.arenaDataManager:GetHistoryData(ARENA_TYPE.HUA_SHAN);
	self:OnRefScene4ArenaSpine(TYPE.SINGLE, daShiData);
	self:OnRefScene4ArenaSpine(TYPE.TEAM, huaShanData);
end

function HouseUI:OnRefScene4ArenaSpine(type, data)

	if not data then
		return;
	end

	local parent = self.objSingle;
	if type == TYPE.TEAM then
		parent = self.objTeam;
	end

	local luaTable = data[1].akMemberHistoryData;
	for i = 1, #(luaTable) do
		local temp = luaTable[i];
		local objSpine = self:FindChild(parent, 'Player_mind/spine');
		local objName = self:FindChild(objSpine, 'head_Node/Text_Name');
		if temp.dwPlace == 2 then
			objSpine = self:FindChild(parent, 'Player_left/spine');
			objName = self:FindChild(objSpine, 'head_Node/Text_Name');
			
		elseif temp.dwPlace == 3 then
			objSpine = self:FindChild(parent, 'Player_right/spine');
			objName = self:FindChild(objSpine, 'head_Node/Text_Name');
			
		end
		
		if objSpine and objName then
			local modelData = TableDataManager:GetInstance():GetTableData("RoleModel", temp.dwModelID)
			if modelData then
				DynamicChangeSpine(objSpine, modelData.Model);
			end
			objName:GetComponent('Text').text = temp.acPlayerName;
		end
	end

	parent:SetActive(true);
end

-- 显示随机老板娘气泡
function HouseUI:ShowRandomChatBubble()
	if self.bIsGuideMode == true then
		return
	end
	-- 游戏登录
	-- * 每次登录会从对话类型为“登录”的内容里面随机抽取
	-- * 当登录天数大于等于2天时，每天首次登录会从对话类型为“特殊”的内容里面随机，非当天首次登录，随机池为类型“登录”+“特殊”
	-- 单局内返回
	-- * 每次从单局内返回至酒馆时，会从对话类型为“返回”的内容里面随机抽取
	-- * 当登录天数大于等于2天时，每天首次返回会从对话类型为“特殊”的内容里面随机，非当天首次返回，随机池为类型“返回”+“特殊”
	local bEnableType = {}
	local bIsLogin = PlayerSetDataManager:GetInstance():GetLoginFlag()
	if bIsLogin == true then
		PlayerSetDataManager:GetInstance():SetLoginFlag(false)
		bEnableType[HouseChatBubbleType.HCBT_Login] = true
	else
		bEnableType[HouseChatBubbleType.HCBT_Back] = true
	end
	local iAliveDay = PlayerSetDataManager:GetInstance():GetALiveDays() or 0
	local iShowSpecialDayLimit = 2  -- 显示特殊气泡要求的登录天数
	if iAliveDay >= iShowSpecialDayLimit then
		bEnableType[HouseChatBubbleType.HCBT_Special] = true
	end
	-- 当前渠道是否允许显示我们项目自身信息?
	local bCanShowOurExtraInfo = JungCurCannelIDForOueExtraInfo()
	-- 注意, 直接拿到老板娘讲话中有项目自身信息的id
	local bHideChat = {
		[670005] = (bCanShowOurExtraInfo ~= true),
		[670006] = (bCanShowOurExtraInfo ~= true),
		[670007] = (bCanShowOurExtraInfo ~= true),
	}
	local list = {}
	local TB_HouseChatBubble = TableDataManager:GetInstance():GetTable("HouseChatBubble")
	for index, data in pairs(TB_HouseChatBubble) do
		if (bEnableType[data.DialogueType] == true)
		and (bHideChat[data.BaseID] ~= true) then
			list[#list + 1] = data
		end
	end
	-- start random
	local iRandom = math.random(1, #list)
	local kData = list[iRandom]
	if not (kData and kData.ChatID) then
		return
	end
	strWord = GetLanguageByID(kData.ChatID) or ""
	self:ShowBossChatBubble(strWord)
	if kData.AudioID and (kData.AudioID > 0) then
		PlaySound(kData.AudioID)
	end 
end

-- 老板娘对话气泡
function HouseUI:ShowBossChatBubble(strWord)
	if (not strWord) or (strWord == "") then
		return
	end
	self.textChatBubble.text = ""
	local twnFadeIn = Twn_CanvasGroupFade(nil, self.canvasGroupBubble, 0, 1, self.fChatBubbleFadeTime)
	if (twnFadeIn ~= nil) then
		twnFadeIn:SetAutoKill(true)
	end
	local onDoTextComp = function()
		local win = GetUIWindow("HouseUI")
		if not win then
			return
		end
		local twnFadeOut = Twn_CanvasGroupFade(nil, win.canvasGroupBubble, 1, 0, win.fChatBubbleFadeTime, win.fChatBubbleStayTime)
		if (twnFadeOut ~= nil) then
			twnFadeOut:SetAutoKill(true)
		end
	end
	local twnDoText = Twn_DoText(nil, self.textChatBubble, strWord, 10, onDoTextComp)
	if (twnDoText ~= nil) then
		twnDoText:SetAutoKill(true)
	end
end

function HouseUI:ShowSelfLoginWord()
	local appearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo();
	if appearanceInfo.loginWordID then
		local tbl_PlayerINfoLogin = TB_PlayerInfoData[PlayerInfoType.PIT_LOGINWORD][appearanceInfo.loginWordID];
		if tbl_PlayerINfoLogin then
			local unlockPool = globalDataPool:getData("UnlockPool") or {};
			local loginWord = unlockPool[PlayerInfoType.PIT_LOGINWORD];
            if loginWord and loginWord[tbl_PlayerINfoLogin.BaseID] then
                local subTime = loginWord[tbl_PlayerINfoLogin.BaseID].dwParam - os.time();
				if subTime <= 0 then
					return;
				end
			end
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

			local playerID = globalDataPool:getData('PlayerID');
			local lastTime = GetConfig(tostring(playerID) .. '#loginWordShowTime');
			local bToday = false;
			if not lastTime or not InTime(lastTime, fromTime, toTime) then
				SetConfig(tostring(playerID) .. '#loginWordShowTime', os.time(), true);
				bToday = true;
			else
				bToday = false;
			end

			if bToday then
				local jsonData = {};
				jsonData.iParam1 = appearanceInfo.loginWordID;
				jsonData.acUserName1 = PlayerSetDataManager:GetInstance():GetPlayerName();
				SystemUICall:GetInstance():BarrageLoginShow(jsonData);
			end
		end
	end
end

function HouseUI:UpdateDailyReward()
	if not IsValidObj(self.objDailyReward) then
		return
	end

	local objImgNormal = self:FindChild(self.objDailyReward, "img_normal")
	local objImgSuper = self:FindChild(self.objDailyReward, "img_super")

	local state = PlayerSetDataManager:GetInstance():GetDailyRewardState()
    local eType = PlayerSetDataManager:GetInstance():GetChallengeOrderType()
	local bUnlockOrder = (eType and eType ~= COT_FREE)
	
	if state == DRS_NULL or (state == DRS_FREE and bUnlockOrder) then
		self.objDailyReward:SetActive(true)
		
		objImgNormal:SetActive(not bUnlockOrder)
		objImgSuper:SetActive(bUnlockOrder)
    else
		self.objDailyReward:SetActive(false)
		
		objImgNormal:SetActive(false)
		objImgSuper:SetActive(false)
    end
end

function HouseUI:GetCurArea()
	return self.curArea
end

function HouseUI:RefreshActivityRedPoint()
	if IsValidObj(self.objNoticeAreaRedPoint) then
		local bActive = ActivityHelper:GetInstance():HasActivityRedPoint()
		self.objNoticeAreaRedPoint:SetActive(bActive)
	end
end

-- 检查百宝书赠送邮件
function HouseUI:CheckTreasureBookSendMail()
	local akMails = SocialDataManager:GetInstance():GetMailData(SMAT_GIVEFRIEND_TREASUREBOOK, MailState.New)
	if (not akMails) or (#akMails == 0) then
		return
	end
	local aiOprIds = {}
	local uiCount = 0
	for index, kMail in ipairs(akMails) do
		aiOprIds[uiCount] = tonumber(kMail.id)
		uiCount = uiCount + 1
	end
	SendMailOpr(SMAOT_GET, uiCount, aiOprIds)
end

function HouseUI:Update()
	if self.needUpdateActivity then
		self.needUpdateActivity = false
		self:CheckActivityUI()
		self:RefreshActivityRedPoint()
		self:RefreshFestivalButton()
	end
end

function HouseUI:OnDestroy()
	self.comBossSpine.AnimationState:Complete("-",self.addBossAnimationFunc)
	self:RemoveListener();
	self:ReturnAllStandPlayers()

	LuaClassFactory:GetInstance():ReturnAllUIClass({self.objheadboxUI})
end

function HouseUI:RemoveListener()
	self:RemoveEventListener('ONEVENT_REF_PLAYERSPINE');
	self:RemoveEventListener('Modify_UseTencentHeadPic');
	self:RemoveEventListener('UPDATE_LANDLADY');
	self:RemoveEventListener('ONEVENT_REF_HISTORYDATA')
	self:RemoveEventListener('ONEVENT_REF_MATCHDATA')
	self:RemoveEventListener('Modify_Player_Appearance');
	self:RemoveEventListener('ONEVENT_REF_REDPACKET');
	self:RemoveEventListener('ONEVENT_REF_SERVERTIME');
	self:RemoveEventListener('ONEVENT_DIFF_DAY');
end

return HouseUI