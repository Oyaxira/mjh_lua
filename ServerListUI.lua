ServerListUI = class("ServerListUI",BaseWindow)

function ServerListUI:ctor()
end

function ServerListUI:Create()
	local obj = LoadPrefabAndInit("Logon/ServerListUI",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ServerListUI:Init()
	self.objAllServerListUI = {}
	self.colorServerPick = "#F1F1F1"
	self.colorNamePick = "#F1F1F1"
	self.colorServerUnPick = "#2C2C2C"
	self.colorNameUnPick = "#585656"

	-- 服务器列表
	self.objRoot = self:FindChild(self._gameObject,"Root")
	self.objServerList = self:FindChild(self.objRoot,"List")
	self.comServerList = self.objServerList:GetComponent("LoopVerticalScrollRect")
	if self.comServerList then
		self.comServerList:AddListener(function(...) self:UpdateServerGroup(...) end)
	end

	-- 注册回退按钮
    local Mask_Button = self:FindChildComponent(self._gameObject, "Mask_Button", "Button") 
	if Mask_Button then
		self:RemoveButtonClickListener(Mask_Button)
		self:AddButtonClickListener(Mask_Button, function ()
			self:Quit()
        end)
	end
end

function ServerListUI:RefreshUI(info)
	-- 清空列表
	self.comServerList.totalCount = 0
	self.comServerList:RefillCells()
	-- 请求服务器列表, 以防 增/删 服务器时客户端显示不及时
	HttpHelper:GetPublicLoginServerList(function()
		local win = GetUIWindow("ServerListUI")
		if win then
			win:SetServerList()
		end
	end)
end

-- 设置服务器状态
function ServerListUI:SetServerState(objStateNode, eServerState, kSvrTags)
	if not (objStateNode and eServerState) then
		return
	end
	if not self.eServerStateRevert then
		self.eServerStateRevert = {}
		for strState, eState in pairs(SERVER_STATE) do
			self.eServerStateRevert[eState] = strState	
		end
	end
	local kTAgCheck = {}
	for index, kTAg in ipairs(kSvrTags or {}) do
		kTAgCheck[(kTAg.name or "") .. (kTAg.value or "")] = true
	end
	local transState = objStateNode.transform
	local transChild = nil
	local objChild = nil
	local kRang = 0
	local strCurState = ""
	for index = 0, transState.childCount - 1 do
		transChild = transState:GetChild(index)
		objChild = transChild.gameObject
		if (transChild.name == self.eServerStateRevert[eServerState]) then
			objChild:SetActive(true)
			strCurState = transChild.name
		elseif kTAgCheck[transChild.name] then
			objChild:SetActive(true)
		else
			objChild:SetActive(false)
		end
	end
	return strCurState
end

function ServerListUI:SetServerList()
	-- 获取服务器分组
	self.akServerGroups = HttpHelper:GetServerListGroup()
	if not self.akServerGroups then
		return
	end
	
	-- 显示服务器列表
	self.lastChooseZone = GetConfig("LoginZone")
	local strServerKey = string.format("LoginServer_%s", tostring(self.lastChooseZone))
	self.lastChooseServer = GetConfig(strServerKey)
	self.kServerState = {}

	self.comServerList.totalCount = #self.akServerGroups
	self.comServerList:RefillCells()

	globalDataPool:setData("ServerState", self.kServerState, true)
end

function ServerListUI:UpdateServerGroup(transform, index)
	if not (self.akServerGroups and transform and index) then
		return
	end
	local objGroup = transform.gameObject
	local kGroupData = self.akServerGroups[index + 1]
	if not (kGroupData and objGroup) then
		return
	end
	local objTagMyServer = self:FindChild(objGroup, "TagMyServer")
	objTagMyServer:SetActive(false)
	local objTagOtherServer = self:FindChild(objGroup, "TagOtherServer")
	objTagOtherServer:SetActive(false)
	local objTagAllServer = self:FindChild(objGroup, "TagAllServer")
	objTagAllServer:SetActive(false)
	local objTagRecommendServer = self:FindChild(objGroup, "TagRecommendServer")
	objTagRecommendServer:SetActive(false)
	local objServers = self:FindChild(objGroup, "Servers")
	objServers:SetActive(false)

	local strGroupType = kGroupData.type
	if strGroupType == "TagMyServer" then
		objTagMyServer:SetActive(true)
		return
	end
	if strGroupType == "TagOtherServer" then
		objTagOtherServer:SetActive(true)
		return
	end
	if strGroupType == "TagAllServer" then
		objTagAllServer:SetActive(true)
		return
	end
	if strGroupType == "TagRecommendServer" then
		objTagRecommendServer:SetActive(true)
		return
	end
	local akServerList = kGroupData.list
	if (strGroupType == "ServerGroup") and akServerList and (#akServerList > 0) then
		local kServers = objServers.transform
		for index = 1, kServers.childCount do
			local kChildTrans = kServers:GetChild(index - 1)
			local objChild = kChildTrans.gameObject
			local kServerData = akServerList[index]
			if kServerData then
				self:SetServerNode(objChild, kServerData.zone, kServerData.server)
				objChild:SetActive(true)
			else
				objChild:SetActive(false)
			end
		end
		objServers:SetActive(true)
	end
end

function ServerListUI:SetServerNode(objNode, kZone, kServer)
	if not (objNode 
	and kZone and kZone.zone 
	and kServer and kServer.server) then
		return
	end
	if not self.kServerState then
		self.kServerState = {}
	end
	if not self.kServerState[kZone.zone] then
		self.kServerState[kZone.zone] = {}
	end
	local strCurState = self:SetServerState(self:FindChild(objNode, "State"), kServer.state, kServer.svrTags)
	self.kServerState[kZone.zone][kServer.server] = strCurState
	local objSelect = self:FindChild(objNode, "image_select")
	local bIsPick = false
	if (self.lastChooseZone == kZone.zone) 
	and (self.lastChooseServer == kServer.server) then
		objSelect:SetActive(true)
		bIsPick = true
	else
		objSelect:SetActive(false)
	end
	local bHasAccountOnThisServer = (kServer.usrName ~= nil) and (kServer.usrName  ~= "") 
	local bIsHotServer = false
	for index, kTag in ipairs(kServer.svrTags or {}) do
		if kTag.name == "RegState" then
			bIsHotServer = (tostring(kTag.value) == SERVER_TAG.HotSvr)
			break
		end
	end
	local objNode_button = objNode:GetComponent("Button")
	self:RemoveButtonClickListener(objNode_button)
	self:AddButtonClickListener(objNode_button, function ()
		-- 带有 "火爆" 标签的服务器, 新用户不允许注册
		if bIsHotServer and (bHasAccountOnThisServer ~= true) then
			SystemUICall:GetInstance():WarningBox("当前服务器爆满暂时无法容纳新进大侠，请选择其他服务器。")
			return
		end
		-- 储存上次登录的服务器
		SetConfig("LoginZone",kZone.zone)
		local strServerKey = string.format("LoginServer_%s", tostring(kZone.zone))
		local strServerNameKey = string.format("LoginServerName_%s", tostring(kZone.zone))
		SetConfig(strServerKey,kServer.server)
		SetConfig(strServerNameKey, kServer.serverName)
		self:Quit()
	end)
	-- 服务器名字后面要跟上<size=18>角色名</size>
	local uiText = self:FindChildComponent(objNode,"Name_Text","Text")
	local strZoneName = PlayerSetDataManager:GetInstance():GetServerZoneNameByServerID(kServer.server)
	local strServerName = string.format("%s %s", strZoneName or "", kServer.serverName or "")
	local strText = string.format("<color=%s>%s</color>", (bIsPick and self.colorServerPick or self.colorServerUnPick), strServerName)
	if bHasAccountOnThisServer then
		strText = strText .. string.format("<color=%s><size=18>(%s)</size></color>", (bIsPick and self.colorNamePick or self.colorNameUnPick), kServer.usrName or "")
	end
	uiText.text = strText
end

function ServerListUI:Quit()
	local loginUI = GetUIWindow('LoginUI')
	if loginUI ~= nil then 
		loginUI.objUIRoot_Node:SetActive(true)
		loginUI:UpdateServerNode()
	end
	RemoveWindowImmediately("ServerListUI") 
end

function ServerListUI:OnDestroy()
	self.comServerList:RemoveListener()
end

return ServerListUI