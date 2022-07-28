ArenaPlayerCompareUI = class("ArenaPlayerCompareUI",BaseWindow)

function ArenaPlayerCompareUI:Create()
	local obj = LoadPrefabAndInit("ArenaUI/ArenaPlayerCompareUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ArenaPlayerCompareUI:Init()
	local objRoot = self:FindChild(self._gameObject, "Root")
	-- 顶部标题
	self.textRootTitle = self:FindChildComponent(objRoot, "Top/Title", DRCSRef_Type.Text)
	-- 显示内容
	local objContent = self:FindChild(objRoot, "Content")
	-- 初始化对手ui信息
	self:InitPlayerInfoUI(objContent)
	-- 初始化队友ui信息
	self:InitMatesUI(objContent)
	-- 关闭按钮
	local btnRootClose = self:FindChildComponent(objRoot, "Close", DRCSRef_Type.Button)
	self:AddButtonClickListener(btnRootClose, function()
		self:OnClickExit()
	end)
	-- 切换按钮
	local objSwitch = self:FindChild(self._gameObject, "Switch")
	local btnSwitchLeft = self:FindChildComponent(objSwitch, "Left", DRCSRef_Type.Button)
	local btnSwitchRight = self:FindChildComponent(objSwitch, "Right", DRCSRef_Type.Button)
	self:AddButtonClickListener(btnSwitchLeft, function()
		self:OnClickSwitch(false)
	end)
	self:AddButtonClickListener(btnSwitchRight, function()
		self:OnClickSwitch(true)
	end)
	-- 事件处理
	self:AddEventListener("ONEVENT_REF_SHOW_OBSERVE", function(uiPlayerID)
        self:OnRecvPlayerObserveData(uiPlayerID)
	end)
	self:AddEventListener("ARENA_TIME_UPDATE", function(kInfo)
		self:RefreshRootTitleTime(kInfo)
	end)
	self:AddEventListener("ARENA_BET_RESULT", function(kBattleInfo)
		self:ResetCurBattleInfo(kBattleInfo)
	end)	
end

-- 初始化对手ui信息
function ArenaPlayerCompareUI:InitPlayerInfoUI(objContent)
	if not objContent then
		return
	end
	local objPlayerInfoL = self:FindChild(objContent, "PlayerInfoL")
	local objPlayerInfoR = self:FindChild(objContent, "PlayerInfoR")
	local kPlayerInfoUINodes = {
		L = {objRoot = objPlayerInfoL}, 
		R = {objRoot = objPlayerInfoR}
	}
	for strKey, kInfo in pairs(kPlayerInfoUINodes) do
		local objRoot = kInfo.objRoot
		kPlayerInfoUINodes[strKey]["imgCG"] = self:FindChildComponent(objRoot, "CG/Img", DRCSRef_Type.Image)
		kPlayerInfoUINodes[strKey]["imgAvatar"] = self:FindChildComponent(objRoot, "Title/Head/head", DRCSRef_Type.Image)
		kPlayerInfoUINodes[strKey]["textName"] = self:FindChildComponent(objRoot, "Title/Name", DRCSRef_Type.Text)
		kPlayerInfoUINodes[strKey]["textFactor"] = self:FindChildComponent(objRoot, "Opt/Factor/Text", DRCSRef_Type.Text)
		kPlayerInfoUINodes[strKey]["textBet"] = self:FindChildComponent(objRoot, "Opt/Bet/Text", DRCSRef_Type.Text)
		-- button click listener just register once
		local btnBet = self:FindChildComponent(objRoot, "Opt/Bet", DRCSRef_Type.Button)
		self:RemoveButtonClickListener(btnBet)
		self:AddButtonClickListener(btnBet, function()
			local strWho = strKey
			self:OnClickBet(strWho)
		end)
		kPlayerInfoUINodes[strKey]["btnBet"] = btnBet
	end
	self.kPlayerInfoUINodes = kPlayerInfoUINodes
end

-- 初始化队友ui信息
function ArenaPlayerCompareUI:InitMatesUI(objContent)
	if not objContent then
		return
	end
	local transMates = self:FindChildComponent(objContent, "Mates", DRCSRef_Type.Transform)
	local kMatesUINodes = {L = {}, R = {}}
	for indexMate = 0, transMates.childCount - 1, 1 do
		local transGroup = transMates:GetChild(indexMate)
		for indexGroup = 0, transGroup.childCount - 1, 1 do
			local transMan = transGroup:GetChild(indexGroup)
			local objMan = transMan.gameObject
			local kManInfo = {}
			kManInfo["objRoot"] = objMan
			kManInfo["textName"] = self:FindChildComponent(objMan, "Name", DRCSRef_Type.Text)
			kManInfo["textLevel"] = self:FindChildComponent(objMan, "Level", DRCSRef_Type.Text)
			kManInfo["imgAvatar"] = self:FindChildComponent(objMan, "Head/head", DRCSRef_Type.Image)
			-- button click listener just register once
			local btnWatch = self:FindChildComponent(objMan, "Button", DRCSRef_Type.Button)
			local strWho = (indexGroup == 0) and "L" or "R"
			local uiMateIndex = #kMatesUINodes[strWho] + 1
			self:AddButtonClickListener(btnWatch, function()
				self:OnClickWatchMate(strWho, uiMateIndex)
			end)
			kManInfo["btnWatch"] = btnWatch
			kMatesUINodes[strWho][uiMateIndex] = kManInfo
			-- Left, Right, Max 2 Player
			if indexGroup >= 1 then
				break
			end
		end
	end
	kMatesUINodes["objRoot"] = transMates.gameObject
	-- Loading
	local objLoading = self:FindChild(objContent, "MatesLoading")
	kMatesUINodes["L"]["objLoading"] = self:FindChild(objLoading, "L")
	kMatesUINodes["R"]["objLoading"] = self:FindChild(objLoading, "R")
	self.kMatesUINodes = kMatesUINodes
end

-- 刷新界面
-- info desc: {kMatch = {}, akBattleInfoGroup = {}, uiCurIndex = 1}
function ArenaPlayerCompareUI:RefreshUI(info)
	if not info then
		return
	end
	self.kCurMatch = info.kMatch
	self.akCurGroup = info.akBattleInfoGroup
	self.uiCurIndex = info.uiCurIndex
	-- 刷新标题
	self:RefreshRootTitle(info)
	-- 显示当前两个对手
	self:ShowOpponent()
end

-- 重新设置当前比赛信息
function ArenaPlayerCompareUI:ResetCurBattleInfo(kBattleInfo)
	if not kBattleInfo then
		return
	end
	self:RefreshPlayerInfo({kMatch = self.kCurMatch, kBattleInfo = self.akCurGroup[self.uiCurIndex]})
end

-- 显示当前两个对手
function ArenaPlayerCompareUI:ShowOpponent(iJumpPage)
	if (not self.kCurMatch) or (not self.akCurGroup) then
		return
	end
	self:RmAllTimers()
	if not self.uiCurIndex then
		uiCurIndex = 1
	end
	self.uiCurIndex = self.uiCurIndex + (iJumpPage or 0)
	if self.uiCurIndex > #self.akCurGroup then
		self.uiCurIndex = 1
	elseif self.uiCurIndex < 1 then
		self.uiCurIndex = #self.akCurGroup
	end
	local kCurBattleInfo = self.akCurGroup[self.uiCurIndex]
	local kInfo = {kMatch = self.kCurMatch, kBattleInfo = kCurBattleInfo}
	self:RefreshPlayerInfo(kInfo)
	self:RefreshMatesInfo(kInfo)
end

-- 移除所有计时器
function ArenaPlayerCompareUI:RmAllTimers()
	if self.uiRequestRPlayerMatesTimer then
		self:RemoveTimer(self.uiRequestRPlayerMatesTimer)
		self.uiRequestRPlayerMatesTimer = nil
	end
	if self.uiRequestLPlayerMatesTimer then
		self:RemoveTimer(self.uiRequestLPlayerMatesTimer)
		self.uiRequestLPlayerMatesTimer = nil
	end
end

-- 关闭界面
function ArenaPlayerCompareUI:OnDisable()
	self:RmAllTimers()
end

-- 刷新界面标题
function ArenaPlayerCompareUI:RefreshRootTitle(info)
	if (not info) or (not info.kMatch) or (not self.textRootTitle) then
		return
	end
	self.textRootTitle.text = "【比赛进行中】"
	local kMatch = info.kMatch
	local kMatchTypeBaseData = TableDataManager:GetInstance():GetTableData("ArenaType", kMatch.dwMatchType)
	if not kMatchTypeBaseData then
		return
	end
	local strMatchName = GetLanguageByID(kMatchTypeBaseData.MatchDecNameID or 0) or ""
	-- remove some words, ori string format is like "(周一至周五)少年赛"
	local uiDateIndex, uiNameIndex, strDate, strName = string.find(strMatchName, "(%(.*%))(.*)")
	-- gen round string
	local strRoundDesc = kMatch.dwRoundID .. '强赛'
    if kMatch.dwRoundID == 4 then
        strRoundDesc = "半决赛"
    elseif kMatch.dwRoundID == 2 then
		strRoundDesc = "决赛"
    end
	strName = (strName or "") .. tostring(kMatch.dwMatchID) .. "—" .. strRoundDesc
	self.strBaseRootTitleString = "【" .. strName .. "进行中】"
	self.textRootTitle.text = self.strBaseRootTitleString
end

-- 刷新界面标题时间
function ArenaPlayerCompareUI:RefreshRootTitleTime(kInfo)
	if (not kInfo) or (not self.textRootTitle) or (not self.strBaseRootTitleString) then
		return
	end
	if kInfo.bFinish == true then
		SystemUICall:GetInstance():Toast("当前助威阶段结束")
		self:OnClickExit()
		return
	end
	self.textRootTitle.text = self.strBaseRootTitleString .. "<size=26>" .. (kInfo.strTime or "") .. "</size>"
end

-- 刷新玩家信息
function ArenaPlayerCompareUI:RefreshPlayerInfo(info)
	if (not info) or (not self.kPlayerInfoUINodes) then
		return
	end
	local kBattleInfo = info.kBattleInfo
	if not kBattleInfo then
		return
	end
	local uiBetPlyID = kBattleInfo.defBetPlyID

	-- 这倍率计算规则是从 ArenaUIMatch里面拿的, 这些魔法数暂时没有地方统一
	local fBetDisCount = 0.9
	local fMinBetRate = 1.01
	local fTotalRate = kBattleInfo.dwPly1BetRate + kBattleInfo.dwPly2BetRate
	local fBetRate1 = math.max(fMinBetRate, (fTotalRate * 0.9) / kBattleInfo.dwPly1BetRate)
	local fBetRate2 = math.max(fMinBetRate, (fTotalRate * 0.9) / kBattleInfo.dwPly2BetRate)

	local kPlayerInfos = {
		L = {
			kPlayer = kBattleInfo.kPly1Data, 
			bBeted = (kBattleInfo.kPly1Data.defPlayerID == uiBetPlyID),
			uiRate = fBetRate1,
		}, 
		R = {
			kPlayer = kBattleInfo.kPly2Data, 
			bBeted = (kBattleInfo.kPly2Data.defPlayerID == uiBetPlyID),
			uiRate = fBetRate2,
		},
	}
	local bHasBeted = (kPlayerInfos.L.bBeted == true) or (kPlayerInfos.R.bBeted == true)
	local kPlayerBet = {L = kBattleInfo.dwPly1BetRate, R = kBattleInfo.dwPly2BetRate}
	local TBModel = TableDataManager:GetInstance():GetTable("RoleModel")
	for strWho, kPlayerInfo in pairs(kPlayerInfos) do
		local kNodes = self.kPlayerInfoUINodes[strWho]
		if not kNodes then
			break
		end
		local kPlayer = kPlayerInfo.kPlayer
		-- name
		kNodes.textName.text = kPlayer.acPlayerName or "？？？"
		-- avatar
		GetHeadPicByData(kPlayer, function(sprite)
			kNodes.imgAvatar.sprite = sprite
		end)
		-- cg
		local kArtData = TBModel[kPlayer.dwModelID or 0]
		if kArtData and kArtData.Drawing then
			self:SetSpriteAsync(kArtData.Drawing, kNodes.imgCG)
		end
		-- factor
		kNodes.textFactor.text = string.format("%0.02f", kPlayerInfo.uiRate or 0) .. "倍奖励"
		-- button state
		if bHasBeted then
			if kPlayerInfo.bBeted == true then
				kNodes.textBet.text = "已助威"
			else
				kNodes.textBet.text = "未助威"
			end
			kNodes.btnBet.interactable = false
		else
			kNodes.textBet.text = "助威"
			kNodes.btnBet.interactable = true
		end
		-- click action
		if not self.kClickActionBet then
			self.kClickActionBet = {}
		end
		-- 组装为 ArenaUIBet 所需要的结构
		local kSendToArenaBet = {
			["tempData"] = kPlayer,
			["serverData"] = info.kMatch,
			["battleData"] = kBattleInfo,
		}
		self.kClickActionBet[strWho] = kSendToArenaBet
	end
end

-- 刷新队友信息
function ArenaPlayerCompareUI:RefreshMatesInfo(info)
	if (not info) or (not self.kMatesUINodes) or (not self.kCurMatch) then
		return
	end
	self.kMatesUINodes.L.objLoading:SetActive(true)
	self.kMatesUINodes.R.objLoading:SetActive(true)
	self:SetMatesUI("L", true)
	self:SetMatesUI("R", true)
	local kMatch = info.kMatch
	local kBattleInfo = info.kBattleInfo or {}
	local kPlayerL = kBattleInfo.kPly1Data
	local kPlayerR = kBattleInfo.kPly2Data
	if (not kMatch) or (not kPlayerL) or (not kPlayerR) then
		return
	end
	local kArenaMgr = ArenaDataManager:GetInstance()
	-- 检查是否已经存在之前请求过的队友信息, 如果有, 直接使用缓存的数据, 如果没有, 发起请求
	self.kPlayerMatesInfos = {
		["L"] = {["uiPlayerID"] = kPlayerL.defPlayerID, ["bSet"] = false},
		["R"] = {["uiPlayerID"] = kPlayerR.defPlayerID, ["bSet"] = false},
		["OriInfo"] = info,
	}
	local kBackupL = kArenaMgr:GetChachePlayerObserverData(self.kCurMatch, kPlayerL.defPlayerID)
	local kBackupR = kArenaMgr:GetChachePlayerObserverData(self.kCurMatch, kPlayerR.defPlayerID)
	local bHasBackupL = (kBackupL ~= nil) and (kBackupL.defPlayerID == kPlayerL.defPlayerID)
	local bHasBackupR = (kBackupR ~= nil) and (kBackupR.defPlayerID == kPlayerR.defPlayerID)
	if bHasBackupL then
		globalDataPool:setData("ObserveArenaInfo", kBackupL, true)
		self:OnRecvPlayerObserveData(kPlayerL.defPlayerID, bHasBackupL, bHasBackupR)
	end

	if bHasBackupR then
		globalDataPool:setData("ObserveArenaInfo", kBackupR, true)
		self:OnRecvPlayerObserveData(kPlayerR.defPlayerID, bHasBackupL, bHasBackupR)
	end
	
	if bHasBackupL or bHasBackupR then
		return
	end
	-- 开始请求双方队友数据, 
	-- 需要等一条请求结束再开始下一条,
	-- 先请求左边玩家的数据
	-- 由于擂台观察数据较大, 服务器强制限制了三秒请求限制
	-- 所以需要先判断是否需要延迟请求
	local doReqLPlayerInfo = function()
		SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_OTHER_MEMBER_PK_DATA, 
			kMatch.dwMatchType, kMatch.dwMatchID, kBattleInfo.dwRoundID, kBattleInfo.dwBattleID, kPlayerL.defPlayerID)
		kArenaMgr:RecordPlayerCompareUIStamp()
	end
	if self.uiRequestLPlayerMatesTimer then
		self:RemoveTimer(self.uiRequestLPlayerMatesTimer)
		self.uiRequestLPlayerMatesTimer = nil
	end
	local uiDelayMillSecs = kArenaMgr:GetPlayerCompareUICD() or 0
	if uiDelayMillSecs > 0 then
		self.uiRequestLPlayerMatesTimer = self:AddTimer(uiDelayMillSecs, function()
			doReqLPlayerInfo()
		end)
	else
		doReqLPlayerInfo()
	end
	-- waitting for observe data ...
end

-- 接受到角色的观察数据时, 设置双方的队友数据
function ArenaPlayerCompareUI:OnRecvPlayerObserveData(uiPlayerID, bHasBackupL, bHasBackupR)
	if (not self.kPlayerMatesInfos) 
	or (not self.kPlayerMatesInfos.OriInfo)
	or (not self.kMatesUINodes) then
		return
	end
	local kArenaMgr = ArenaDataManager:GetInstance()
	-- 设置队友数据
	local funcSetPlayerMates = function(strWho)
		if not strWho then
			return false
		end
		self.kMatesUINodes[strWho].objLoading:SetActive(false)
		if (not self.kPlayerMatesInfos) or (not self.kPlayerMatesInfos[strWho]) then
			return false
		end
		local kObserverInfo = globalDataPool:getData('ObserveArenaInfo')
		if (not kObserverInfo) or (uiPlayerID ~= kObserverInfo.defPlayerID) then
			return false
		end
		local akMates = kObserverInfo.RoleInfos or {}
		self.kPlayerMatesInfos[strWho]["akMates"] = akMates
		-- backup info
		if (bHasBackupL and (strWho == "L"))
		or (bHasBackupR and (strWho == "R")) then
			self.kPlayerMatesInfos[strWho]["kOriObserverInfo"] = kObserverInfo
		else
			self.kPlayerMatesInfos[strWho]["kOriObserverInfo"] = kArenaMgr:SetCachePlayerObserverData(self.kCurMatch, kObserverInfo)
		end
		-- 设置ui
		self:SetMatesUI(strWho)
		return true
	end
	-- 先接收左边玩家的数据
	if self.kPlayerMatesInfos.L and self.kPlayerMatesInfos.L.bSet == false then
		-- 设置左边玩家的队友
		if funcSetPlayerMates("L") == false then
			return
		end
		self.kPlayerMatesInfos.L.bSet = true
		-- 如果拥有右边对手的备份数据, 不需要另外开启计时器去请求
		if bHasBackupR then
			return
		end
		-- 再请求右边玩家的数据
		-- 由于擂台观察数据较大, 服务器强制限制了三秒请求限制
		-- 所以第二条请求三秒之后发起
		if self.uiRequestRPlayerMatesTimer then
			self:RemoveTimer(self.uiRequestRPlayerMatesTimer)
		end
		local uiDelayMillSecs = ARENA_OBSERVE_CD
		if bHasBackupL then
			uiDelayMillSecs = kArenaMgr:GetPlayerCompareUICD() or 0
		end
		local doReqRPlayerInfo = function()
			local kOriInfo = self.kPlayerMatesInfos.OriInfo
			local kMatch = kOriInfo.kMatch
			local kBattleInfo = kOriInfo.kBattleInfo or {}
			local kPlayerR = kBattleInfo.kPly2Data
			SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_OTHER_MEMBER_PK_DATA, 
				kMatch.dwMatchType, kMatch.dwMatchID, kBattleInfo.dwRoundID, kBattleInfo.dwBattleID, kPlayerR.defPlayerID)
			kArenaMgr:RecordPlayerCompareUIStamp()
		end
		if uiDelayMillSecs > 0 then
			self.uiRequestRPlayerMatesTimer = self:AddTimer(uiDelayMillSecs, function()
				doReqRPlayerInfo()
			end)
		else
			doReqRPlayerInfo()
		end
		return
	end
	-- 再接收右边玩家的数据
	if (not self.kPlayerMatesInfos.R) or (self.kPlayerMatesInfos.R.bSet ~= false) then
		return
	end
	-- 设置右边玩家的队友
	if funcSetPlayerMates("R") == false then
		return
	end
	self.kPlayerMatesInfos.R.bSet = true
end

-- 设置队友ui
function ArenaPlayerCompareUI:SetMatesUI(strWho, bShowEmpty)
	if (not strWho) or (not self.kMatesUINodes) 
	or (not self.kMatesUINodes[strWho]) then
		return
	end

	local bHasMatesInfo = (self.kPlayerMatesInfos ~= nil) and (self.kPlayerMatesInfos[strWho] ~= nil)
	if (bShowEmpty ~= true) and (bHasMatesInfo ~= true) then
		return
	end

	local TBModel = TableDataManager:GetInstance():GetTable("RoleModel")
	local kRoleMgr = RoleDataManager:GetInstance()
	local funcSetMeates = function(akNodes, akMates)
		if (not akNodes) or (not akMates) then
			return
		end
		-- 依据队友能力做一个排序
		local akSortdMates = {}
		for index, kMate in pairs(akMates) do
			akSortdMates[#akSortdMates + 1] = kMate
		end
		table.sort(akSortdMates, function(a, b)
			-- 需求单要求顺序: 修行等级 > 角色等级 > 角色品质, 剩余按id排序
			if a.uiOverlayLevel == b.uiOverlayLevel then
				if a.uiLevel == b.uiLevel then
					if a.uiRank == b.uiRank then
						return	(a.uiID or 0) > (b.uiID or 0)
					end
					return (a.uiRank or 0) > (b.uiRank or 0)
				end
				return (a.uiLevel or 0) > (b.uiLevel or 0)
			end
			return (a.uiOverlayLevel or 0) > (b.uiOverlayLevel or 0)
		end)
		local aiRoleIDs = {}
		for index, kNodes in ipairs(akNodes) do
			local kMate = akSortdMates[index]
			if kMate then
				aiRoleIDs[#aiRoleIDs + 1] = {["uiRoleID"] = (kMate.uiID or 0)}
				kNodes.textLevel.text = tostring(kMate.uiLevel or 0) .. "级"
				local strName = nil
				if kMate.uiFragment == 1 then
					strName = kRoleMgr:GetMainRoleName() or ""
					local strTitle = kRoleMgr:GetRoleTitleStr(kMate.uiID)
					if strTitle then
						strName = strTitle .. strName
					end
				else
					strName = kRoleMgr:GetRoleName(kMate.uiID, true)
				end
				kNodes.textName.text = getRankBasedText(kMate.uiRank, strName or "")
				local kModelInfo = TBModel[kMate.uiModelID or 0]
				if kModelInfo and kModelInfo.Head then
					self:SetSpriteAsync(kModelInfo.Head, kNodes.imgAvatar)
				end
				kNodes.objRoot:SetActive(true)
			else
				kNodes.objRoot:SetActive(false)
			end
		end
		return akSortdMates, aiRoleIDs
	end

	local akMates = {}
	if not bShowEmpty then
		akMates = self.kPlayerMatesInfos[strWho].akMates or {}
	end
	local akNodes = self.kMatesUINodes[strWho]
	local akSortdMates, aiRoleIDs = funcSetMeates(akNodes, akMates)
	if not bShowEmpty then
		self.kPlayerMatesInfos[strWho]["akSortdMates"] = akSortdMates
		self.kPlayerMatesInfos[strWho]["aiRoleIDs"] = aiRoleIDs
	end
end

-- 点击助威玩家
function ArenaPlayerCompareUI:OnClickBet(strWho)
	if (not self.kClickActionBet) or (not strWho) then
		return
	end
	local kSendToBet = self.kClickActionBet[strWho]
	if not kSendToBet then
		return
	end
	OpenWindowImmediately("ArenaUIBet", kSendToBet)
end

-- 点击观察玩家队友
function ArenaPlayerCompareUI:OnClickWatchMate(strWho, uiMateIndex)
	if (not self.kPlayerMatesInfos)
	or (not self.kPlayerMatesInfos[strWho]) then
		return
	end
	local aiRoleIDs = self.kPlayerMatesInfos[strWho].aiRoleIDs
	if (not aiRoleIDs) or (not aiRoleIDs[uiMateIndex]) then
		return
	end
	-- reset observer info
	globalDataPool:setData('ObserveArenaInfo', self.kPlayerMatesInfos[strWho].kOriObserverInfo, true)
	-- open observer ui
	local kSendParam = {
		["roleIDs"] = aiRoleIDs,
		["index"] = uiMateIndex,
	}
	OpenWindowImmediately("ObserveUI", kSendParam)
end

-- 点击关闭界面
function ArenaPlayerCompareUI:OnClickExit()
	RemoveWindowImmediately("ArenaPlayerCompareUI", true)
end

-- 点击切换按钮
function ArenaPlayerCompareUI:OnClickSwitch(bNext)
	self:ShowOpponent(bNext and 1 or -1)
end

return ArenaPlayerCompareUI