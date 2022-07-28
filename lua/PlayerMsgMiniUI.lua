PlayerMsgMiniUI = class("PlayerMsgMiniUI",BaseWindow)

local clickCDTimeIn = 5;
local clickCDTimeOut = 10;

function PlayerMsgMiniUI:Create()
	local obj = LoadPrefabAndInit("TownUI/PlayerMsgMiniUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function PlayerMsgMiniUI:Init()
	-- 点击背景关闭界面
	local btnBack = self:FindChildComponent(self._gameObject, "Bac", "Button")
	self:AddButtonClickListener(btnBack, function()
		RemoveWindowImmediately("PlayerMsgMiniUI")
	end)
	local btnBack2 = self:FindChildComponent(self._gameObject, "Board/Button_close", "Button")
	self:AddButtonClickListener(btnBack2, function()
		RemoveWindowImmediately("PlayerMsgMiniUI")
	end)
	-- 信息面板
	local objBoard = self:FindChild(self._gameObject, "Board")
	self.imgAvatar = self:FindChildComponent(objBoard, "Head/Image", "Image")
	self.objOldHeadBox = self:FindChild(objBoard, "Head")
	self.objVIPMark = self:FindChild(objBoard, "Head/VIPmark")
	local objMsg = self:FindChild(objBoard, "Msg")
	self.textPlayerName = self:FindChildComponent(objMsg, "PlayerName/Value", "Text")
	self.textWeekNum = self:FindChildComponent(objMsg, "WeekNum/Value", "Text")
	self.textMeridianLevel = self:FindChildComponent(objMsg, "MeridianLevel/Value", "Text")
	self.textAchievePoint = self:FindChildComponent(objMsg, "AchievePoint/Value", "Text")
	self.textFightWin = self:FindChildComponent(objMsg, "FightWin/Value", "Text")
	local objBtns = self:FindChild(objMsg, "Btns")
	local btnChat = self:FindChildComponent(objBtns, "Chat", "Button")
	self:AddButtonClickListener(btnChat, function()
		self:OnClickChat()
	end)
	local btnFriend = self:FindChildComponent(objBtns, "Friend", "Button")
	self:AddButtonClickListener(btnFriend, function()
		self:OnClickFriend()
	end)
	local btnObserve = self:FindChildComponent(objBtns, "Observe", "Button")
	self:AddButtonClickListener(btnObserve, function()
		self:OnClickObserve()
	end)
	local btnFight = self:FindChildComponent(objBtns, "Fight", "Button")
	self:AddButtonClickListener(btnFight, function()
		self:OnClickFight()
	end)
	local btnReportOn = self:FindChildComponent(objBtns, "ReportOn", "Button")
	self:AddButtonClickListener(btnReportOn, function()
		self:OnClickReportOn()
	end)

	local btnShield = self:FindChildComponent(objBtns, "Shield", "Button")
	self:AddButtonClickListener(btnShield, function()
		SystemUICall:GetInstance():Toast('屏蔽功能暂未实现');
	end)
end

function PlayerMsgMiniUI:RefreshUI(info)
	if not info then
		return
	end
	self.kCurPlayerInfo = info
	self.iCurPlayerID = info.defPlyID
	self:SetMsgBoard()
end

-- 设置信息面板
function PlayerMsgMiniUI:SetMsgBoard()
	if not self.kCurPlayerInfo then
		return
	end
	local commonInfo = self.kCurPlayerInfo.kCommInfo
	if not commonInfo then
		return
	end
	local callback = function(sprite)
		local uiWindow = GetUIWindow("PlayerMsgMiniUI")
        if (uiWindow) then
			self.imgAvatar.sprite = sprite;
		end
	end
	GetHeadPicByData(commonInfo,callback)
	self.objVIPMark:SetActive(commonInfo.bRMBPlayer == 1)

	-- local objoldbox = self:FindChild(self.imgAvatar.gameObject,'head')
	-- local objpar = self:FindChild(self.imgAvatar.gameObject,'head/Image')
	if self.imgAvatar then 
		if not self.objheadboxUI then 
			self.objheadboxUI = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,self.imgAvatar.gameObject.transform)
		end 
	end
	if self.objheadboxUI then 
		if  self.kCurPlayerInfo.kAppearanceInfo and self.kCurPlayerInfo.kAppearanceInfo.dwHeadBoxID ~= 0 then  
			self.objheadboxUI._gameObject:SetActive(true)
			self.objheadboxUI:SetReplacedHeadBoxUI(self.objOldHeadBox,false)
			self.objheadboxUI:SetHeadBoxID(self.kCurPlayerInfo.kAppearanceInfo.dwHeadBoxID)	
		else
			self.objheadboxUI._gameObject:SetActive(false)
		end
	end 
	
	local strName = commonInfo.acPlayerName
	if commonInfo.bUnlockHouse == 0 then
		strName = STR_ACCOUNT_DEFAULT_PREFIX .. tostring(self.iCurPlayerID or 0)
	end
	if (not strName) or (strName == "") then
		strName = STR_ACCOUNT_DEFAULT_NAME
	end
	self.textPlayerName.text = strName
	self.textWeekNum.text = commonInfo.dwWeekRoundTotalNum or 0
	self.textMeridianLevel.text = commonInfo.dwMeridiansLvl or 0
	self.textAchievePoint.text = commonInfo.dwAchievePoint or 0
	self.textFightWin.text = "暂未开放"
end

-- 点击私聊
function PlayerMsgMiniUI:OnClickChat()
	if not self.iCurPlayerID then
		return
	end
	RemoveWindowImmediately("PlayerMsgMiniUI")
	local winPlayerList = GetUIWindow("TownPlayerListUI")
	if winPlayerList then
		winPlayerList:MovePlayerList(true)
	end
	local chatBoxUI = GetUIWindow("ChatBoxUI")
	if chatBoxUI then
		local bFriend = SocialDataManager:GetInstance():GetFriendDataByID(self.iCurPlayerID);
		chatBoxUI:OnClickExtenBtn(nil, true);
		chatBoxUI:SetToggleState(chatBoxUI.objTogglePrivate);
		chatBoxUI:OnClickFriendListItem(nil, { uid = self.iCurPlayerID }, bFriend);
	end
	local discussUI = GetUIWindow("DiscussUI");
    if discussUI then
        RemoveWindowImmediately("DiscussUI", true);
	end
	-- 事件: 私聊玩家
	LuaEventDispatcher:dispatchEvent("PRIVATE_CHAT_PLAYER", self.iCurPlayerID)
end

-- 点击加好友
function PlayerMsgMiniUI:OnClickFriend()
	if (not self.kCurPlayerInfo) or (not self.kCurPlayerInfo.kCommInfo) or (not self.iCurPlayerID) then
		return
	end
	local kCommInfo = self.kCurPlayerInfo.kCommInfo
	if SocialDataManager:GetInstance():AddFriend(self.iCurPlayerID, kCommInfo.acOpenID, kCommInfo.acVOpenID) then 
		RemoveWindowImmediately("PlayerMsgMiniUI")
	end
end

-- 点击观察
function PlayerMsgMiniUI:OnClickObserve()

	if false then
		SystemUICall:GetInstance():Toast('酒馆观察暂时维护中！');
		return;
	end

	if not self.kCurPlayerInfo then
		return
	end

	-- OBSERVE_OTHER_PLAYER_ID = self.iCurPlayerID;
	-- if PlayerSetDataManager:GetInstance():GetObserveOtherPlayerData(self.iCurPlayerID) then
	-- 	self:OnRefPlayerSetUI()
	-- else
		SendObservePlatRole(self.iCurPlayerID);
	-- end
	local discussUI = GetUIWindow("DiscussUI");
    if discussUI then
        RemoveWindowImmediately("DiscussUI", true);
    end
end

function PlayerMsgMiniUI:ResetFrghtTime()
	local timeCD = DEBUG_MODE == true and clickCDTimeIn or clickCDTimeOut;
	self.clickFightTime = os.time() + 5;
end

-- 点击切磋
function PlayerMsgMiniUI:OnClickFight()

	if false then
		SystemUICall:GetInstance():Toast('酒馆切磋暂时维护中！');
		return;
	end

	if ChallengeFrom == ChallengeFromType.Chat then
		SystemUICall:GetInstance():Toast('从聊天中暂不可发起切磋');
		return
	end

	if not PlayerSetDataManager:GetInstance():GetTXCreditSceneLimit(TCSSLS_CHALLENGE) then
		OnRecv_TencentCredit_SceneLimit(1,{dwParam = TCSSLS_CHALLENGE}) 
		return  
	end 

	-- 剧本内切磋 如果布阵了 需要5s后才让切磋，因为服务器需要同步阵容，最迟5s
	if RoleDataManager:GetInstance():IsPlayerInGame() == true then
		local lastTime = GetConfig("LastEmbattleTime")
		if lastTime == nil then
			lastTime = 0
		end
		local diffTime = os.time() - lastTime
		local iNeedTime = 10
		if lastTime ~= nil and diffTime <= iNeedTime then
			SystemUICall:GetInstance():Toast(string.format('剧本阵容同步中，请在%d秒后重试',iNeedTime - diffTime));
			return
		end
	end

	local timeCD = DEBUG_MODE == true and clickCDTimeIn or clickCDTimeOut;
	self.clickFightTime = self.clickFightTime or 0;
	if os.time() - self.clickFightTime < timeCD then
		SystemUICall:GetInstance():Toast(string.format('切磋冷却中，请在%d秒后重试', timeCD - (os.time() - self.clickFightTime)));
		return;
	end
	self.clickFightTime = os.time();

	local playerid = globalDataPool:getData("PlayerID");
	if self.iCurPlayerID == tonumber(playerid) then
		SystemUICall:GetInstance():Toast('无法切磋自己');
		return;
	end
	local appearanceInfo = self.kCurPlayerInfo.kAppearanceInfo
	ArenaDataManager:GetInstance():ChallengePlatRoleRePlay(self.iCurPlayerID, appearanceInfo.dwModelID, appearanceInfo.acPlayerName)
	local discussUI = GetUIWindow("DiscussUI");
    if discussUI then
        RemoveWindowImmediately("DiscussUI", true);
    end
end

function PlayerMsgMiniUI:OnDisable()
	self:RemoveEventListener('ONEVENT_REF_OBAERVEUI');
end

function PlayerMsgMiniUI:OnDestroy()
	LuaClassFactory:GetInstance():ReturnAllUIClass({self.objheadboxUI})
end

function PlayerMsgMiniUI:OnEnable()
	RequestPrivateChatSceneLimit()
	self:AddEventListener('ONEVENT_REF_OBAERVEUI', function(info)
		self:OnRefPlayerSetUI();
    end);
end

function PlayerMsgMiniUI:OnRefPlayerSetUI()
	PlayerSetDataManager:GetInstance():SetObserveOtherPlayerData();
	self.kCurPlayerInfo["bIsVisitor"] = true
	OpenWindowImmediately("PlayerSetUI", self.kCurPlayerInfo)
	RemoveWindowImmediately("PlayerMsgMiniUI")
end

-- 点击举报
function PlayerMsgMiniUI:OnClickReportOn()
	OpenWindowImmediately("PlayerReportOnUI", self.kCurPlayerInfo)
	RemoveWindowImmediately("PlayerMsgMiniUI")
end

return PlayerMsgMiniUI