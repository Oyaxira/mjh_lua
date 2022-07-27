TownPlayerListUI = class("TownPlayerListUI",BaseWindow)

function TownPlayerListUI:Create()
	local obj = LoadPrefabAndInit("TownUI/TownPlayerListUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TownPlayerListUI:Init()
	-- 是否服务器模式
	self.bIServerMode = (globalDataPool:getData("GameMode") == "ServerMode")
	-- 点击背景关闭界面
	self.objBack = self:FindChild(self._gameObject, "Bac")
	self.btnBack = self.objBack:GetComponent("Button")
	self:AddButtonClickListener(self.btnBack, function()
		self:MovePlayerList(true)
	end)
	-- 信息面板
	self.objBoard = self:FindChild(self._gameObject, "TransformAdapt_node_left/Board")
	self.objBG = self:FindChild(self.objBoard, "BG")
	self.objTitle = self:FindChild(self.objBoard, "label")
	self.objMsg = self:FindChild(self.objBoard, "Msg")
	self.objList = self:FindChild(self.objMsg, "List")
	self.objContent = self:FindChild(self.objMsg, "Viewport/Content")
	self.transContent = self.objContent.transform
	self.iOriContentY = self.transContent.position.y
	self.objWaiting = self:FindChild(self.objMsg, "Waiting")
	-- 把手
	self.bIsListOpen = false
	self.btnHandler = self:FindChildComponent(self.objBoard, "Handler", "Button")
	self:AddButtonClickListener(self.btnHandler, function()
		self:MovePlayerList(self.bIsListOpen)
	end)
	-- 列表拖动事件
	self.scrollRectList = self.objMsg:GetComponent("DragCtrlScrollRect")
	self.scrollRectList:SetOnDragLuaFunc(function()
		self:OnListMove()
	end)
	self.scrollRectList:SetOnEndDragLuaFunc(function()
		self:CheckRequestAction()
	end)
	-- 初始化
	self:InitUIState()
end

function TownPlayerListUI:OnDestroy()
	self.scrollRectList.onValueChanged:RemoveAllListeners()
	LuaClassFactory:GetInstance():ReturnAllUIClass(self.objs_headboxInst or {})

end

function TownPlayerListUI:RefreshUI(info)
	self.bIsGuideMode = PlayerSetDataManager:GetInstance():GetGuideModeFlag()
end

-- 设置ui初始状态
function TownPlayerListUI:InitUIState()
	self.objBack:SetActive(false)
	self:SetListObjState(false)
	self.btnHandler.interactable = true
	local transBoard = self.objBoard.transform
	local vec3Pos = transBoard.localPosition
	vec3Pos.x = 0
	transBoard.localPosition = vec3Pos
end

function TownPlayerListUI:SetListObjState(bActive)
	bActive = (bActive == true)
	self.objBG:SetActive(bActive)
	self.objTitle:SetActive(bActive)
	self.objMsg:SetActive(bActive)
end

-- 移动玩家列表
function TownPlayerListUI:MovePlayerList(bClose)
	if self.bIsGuideMode == true then
		SystemUICall:GetInstance():Toast("请先在个人界面创建形象", false)
		return
	end

	bClose = (bClose == true)
	if (self.bIsListOpen ~= true) and (bClose == true) then
		return
	end
	if not self.iMoveX then
		local transBoard = self.objBoard:GetComponent('RectTransform')
		self.iMoveDis = transBoard.rect.width
	end
	local iMoveFactor = bClose and -1 or 1
	local fMoveTime = 0.5  -- 移动时间
	local callbackMoveEnd = function()  -- 移动回调
		self.objBack:SetActive(not bClose)
		self.bIsListOpen = (not bClose)
		self.btnHandler.interactable = true
		if bClose then
			self:SetListObjState(false)
		end
	end
	self.objBack:SetActive(false)
	self:SetListObjState(true)
	self.btnHandler.interactable = false
	local twn_move = Twn_MoveX(nil, self.objBoard, iMoveFactor * self.iMoveDis, fMoveTime, DRCSRef.Ease.OutCubic, callbackMoveEnd)
	if (twn_move ~= nil) then
		twn_move:SetAutoKill(true)
	end
	-- 打开列表时, 请求第1分页的玩家
	if bClose ~= true then
		self.kPlayersDataCache  = nil
		self:RequestPage()
	end
end

function TownPlayerListUI:RequestPage(bPre)
	if self.bIServerMode ~= true then
		return	
	end
	self.objList:SetActive(false)
	self.objWaiting:SetActive(true)
	bPre = (bPre == true)
	-- 如果没有当前玩家列表的缓存, 那么请求第1分页的玩家
	if not self.kPlayersDataCache then
		SendGetPlatPlayerSimpleInfos(PSIOT_LIST, 0, SSD_MAX_PLAYER_COUNT_FOR_REQ_PER_PAGE)
		return
	end
	-- 否则, 请求下一页或上一页, 存在缓存数据时, 读取缓存数据
	if bPre then
		if self.iCurPage > 1 then
			self.iCurPage = self.iCurPage - 1
			local kPreData = self.kPlayersDataCache[self.iCurPage]
			self:LocalSetPlayerListData(kPreData)
		else
			SystemUICall:GetInstance():Toast("已经到达第一页", false)
			self:RequestPageOver()
		end
	else
		if self.iCurPage < self.iMaxPage then
			self.iCurPage = self.iCurPage + 1
			local kNextData = self.kPlayersDataCache[self.iCurPage]
			self:LocalSetPlayerListData(kNextData)
		else
			local kCurData = self.kPlayersDataCache[self.iCurPage]
			local iSize = kCurData["iSize"]
			local akInfos = kCurData["kPlatPlayerSimpleInfos"]
			local lastInfo = akInfos[iSize - 1]
			if not lastInfo then
				self:RequestPageOver()
				SystemUICall:GetInstance():Toast("没有更多的数据", false)
			else
				-- 请求所用的页数是从0开始的, 所以直接用self.iCurPage去请求
				SendGetPlatPlayerSimpleInfos(PSIOT_LIST, self.iCurPage, SSD_MAX_PLAYER_COUNT_FOR_REQ_PER_PAGE)
			end
		end
	end
end

-- 请求结束处理
function TownPlayerListUI:RequestPageOver()
	self.objList:SetActive(true)
	self.objWaiting:SetActive(false)
	self.bRequesting = false
end

-- 接收到服务器数据
function TownPlayerListUI:OnRecivePlayerListData(kRetData)
	if not kRetData then
		return
	end

	local iSize = kRetData["iSize"]
	local akInfos = kRetData["kPlatPlayerSimpleInfos"] or {}
	if not (iSize and (iSize > 0)) then
		SystemUICall:GetInstance():Toast("没有更多的数据", false)
		-- 尝试重新显示当前页
		if kRetData.dwPageID and (kRetData.dwPageID > 0) then
			self.iCurPage = self.iCurPage + 1
			self:RequestPage(true)
		end
	else
		-- 移除自己的数据, 然后缓存
		local iMyID = PlayerSetDataManager:GetInstance():GetPlayerID() or 0
		local index = 0
		local kProcessedData = {}
		local kOriData = nil
		for i = 0, iSize - 1 do
			kOriData = akInfos[i]
			if kOriData.defPlyID ~= iMyID then
				kProcessedData[index] = kOriData
				index = index + 1
			end
		end
		kRetData.kPlatPlayerSimpleInfos = kProcessedData
		kRetData.iSize = index
		self.kPlayersDataCache = self.kPlayersDataCache or {}
		self.kPlayersDataCache[#self.kPlayersDataCache + 1] = kRetData
		self.iMaxPage = #self.kPlayersDataCache
		self.iCurPage = self.iMaxPage
		self:SetPlayerList(kProcessedData)
	end
	self:RequestPageOver()
end

-- 直接设置分页数据
function TownPlayerListUI:LocalSetPlayerListData(kLocalData)
	if not kLocalData then
		return
	end
	local akInfos = kLocalData["kPlatPlayerSimpleInfos"]
	self:SetPlayerList(akInfos)
	self:RequestPageOver()
end

function TownPlayerListUI:SetPlayerList(akInfos)
	if not akInfos then
		return
	end
	local index = 0
	local objName = self:FindChild(self.objList, "Player0")
	local objNameText = self:FindChild(objName, "Text_name")
	--local objHeadPic = nil
	local textName = nil
	local rmbImage = nil
	local btnName = nil
	local kData= nil
	while objName ~= nil do
		kData = akInfos[index]
		if kData and kData.acPlayerName and kData.defPlyID then
			textName = objNameText:GetComponent("Text")
			local strPlayerName = nil
			if kData.bUnlockHouse == 0 then
				strPlayerName = string.format("%s%d", STR_ACCOUNT_DEFAULT_PREFIX, kData.defPlyID)
			else
				strPlayerName = kData.acPlayerName
			end
			if (not strPlayerName) or (strPlayerName == "") then
				strPlayerName = STR_ACCOUNT_DEFAULT_NAME
			end
			textName.text = strPlayerName
			btnName = objName:GetComponent("Button")
			self:RemoveButtonClickListener(btnName)
			local defPlyID = kData.defPlyID
			self:AddButtonClickListener(btnName, function()
				ChallengeFrom = ChallengeFromType.PlayerList;
				SendGetPlatPlayerDetailInfo(defPlyID, RLAYER_REPORTON_SCENE.UserBoard)	
			end)
			--GetSprite(modelData.Head)
			local objHeadPic = self:FindChildComponent(objName, "image_head/head", "Image")
			local callback = function(sprite)
				local uiWindow = GetUIWindow("TownPlayerListUI")
        		if (uiWindow) then
					objHeadPic.sprite = sprite
				end
			end
			GetHeadPicByData(kData,callback)

			self.objs_headboxInst = self.objs_headboxInst or {}
			local par = self:FindChild(objName, "image_head/head")
			local objoldbox = self:FindChild(objName, "image_head")
			if par and not self.objs_headboxInst[index] then 
				self.objs_headboxInst[index] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.HeadBoxUI,par.transform)
			end 
			if self.objs_headboxInst[index] then  
				self.objs_headboxInst[index]._gameObject:SetActive(true)
				self.objs_headboxInst[index]:SetReplacedHeadBoxUI(objoldbox,false)
				self.objs_headboxInst[index]:SetHeadBoxID(kData.dwHeadBoxID)
			end 

			rmbImage = self:FindChild(objName, "image_rmb")
			if (rmbImage ~= nil) then
				if (kData.bRMBPlayer == 1) then		
					rmbImage.gameObject:SetActive(true)
				else
					rmbImage.gameObject:SetActive(false)
				end
			end
			objName:SetActive(true)
		else
			objName:SetActive(false)
		end
		index = index + 1
		objName = self:FindChild(self.objList, "Player" .. index)
		objNameText = self:FindChild(objName, "Text_name")
	end
end

function TownPlayerListUI:OnListMove(vec2)
	self.sRequestFlag = nil
	if self.bRequesting == true then
		return
	end
	local iDeltaY = self.transContent.position.y - self.iOriContentY
	local iThresholdPre = -2.5  -- 向上翻页的阈值
	local iThresholdNext = 4  -- 向下翻页的阈值
	local bRequestFactor = nil
	if iDeltaY >= iThresholdNext then
		self.sRequestFlag = "next"
	elseif iDeltaY <= iThresholdPre then
		self.sRequestFlag = "pre"
	end
end

-- 检查是否需要发送数据请求
function TownPlayerListUI:CheckRequestAction()
	local bRequestFactor = nil
	if self.sRequestFlag == "pre" then
		bRequestFactor = true
	elseif self.sRequestFlag == "next" then
		bRequestFactor = false
		-- 复位content
		local vec3Pos = self.transContent.localPosition
		vec3Pos.y = 0
		self.transContent.localPosition = vec3Pos
	end
	if bRequestFactor ~= nil then
		self.bRequesting = true
		self:RequestPage(bRequestFactor)
	end
end

return TownPlayerListUI