FriendListUI = class("FriendListUI",BaseWindow)

--FriendInfoList = {}

function FriendListUI:ctor()
end

function FriendListUI:Create()
	local obj = LoadPrefabAndInit("Logon/FriendsListUI",UI_MainLayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

local msdkCombineFriendList = {}

function FriendListUI:Init()
	self.objFriendList = self:FindChild(self._gameObject,"LoopScrollView")
	self.comFriendList = self.objFriendList:GetComponent("LoopVerticalScrollRect")
	if self.comFriendList then
		self.comFriendList:AddListener(function(...) self:UpdateFriendGroup(...) end)
	end
	-- self:FriendListFreshData()
	-- 注册回退按钮
    local Mask_Button = self:FindChildComponent(self._gameObject, "Mask_Button", "Button") 
	if Mask_Button then
		self:RemoveButtonClickListener(Mask_Button)
		self:AddButtonClickListener(Mask_Button, function ()
			self:Quit()
        end)
	end
end

function FriendListUI:FriendListFreshData()
	if MSDKHelper then
		local callback = function(list)
			msdkCombineFriendList = list
			self.comFriendList.totalCount = #msdkCombineFriendList
			self.comFriendList:RefillCells()
		end
		MSDKHelper:GetFriendList(callback)
	end
end

function FriendListUI:UpdateFriendGroup(transform, index)
	if not (msdkCombineFriendList and transform and index) then
		return
	end
	local objGroup = transform.gameObject
	local objInfo = msdkCombineFriendList[index+1]
	if not (objInfo and objGroup) then
		return
	end
	local serverList = globalDataPool:getData("LoginServerList")
	if not serverList then
		return
	end
	local zone = objInfo.lastZone
	local server = objInfo.lastServer
	local kTarZoneData = nil
	for _, zoneData in pairs(serverList) do
		if zone == zoneData.zone then
			kTarZoneData = zoneData
			break
		end
	end
	--[[
	if not kTarZoneData then
		return
	end]]
	local kTarServerData = nil
	if (kTarZoneData~=nil) then
		for _, serverData in pairs(kTarZoneData.servers) do
			if server == serverData.server then
				kTarServerData = serverData
				break
			end
		end
	end
	--[[
	if not kTarServerData then
		return
	end	]]
	local strUserName = "(信息未同步)"
	if objInfo.userTags then
		for kindex, kTag in pairs(objInfo.userTags) do
			if kTag.name == "PlatName" then
				if (kTag.value == "") then
					strUserName = "江湖小虾米"
				else
					strUserName = kTag.value
				end
			end
		end
	end
	local serverName = "(未同步)"
	if (kTarServerData ~= nil) then
		serverName = kTarServerData.serverName
	end
	if (kTarServerData ~= nil and kTarZoneData ~= nil) then
		local objNode_button = self:FindChildComponent(objGroup, "DRButton", "Button")
		self:RemoveButtonClickListener(objNode_button)
		self:AddButtonClickListener(objNode_button, function ()
			dprint("####click")
			-- 储存上次登录的服务器
			SetConfig("LoginZone",kTarZoneData.zone)
			local strServerKey = string.format("LoginServer_%s", tostring(kTarZoneData.zone))
			local strServerNameKey = string.format("LoginServerName_%s", tostring(kTarZoneData.zone))
			SetConfig(strServerKey, kTarServerData.server)
			SetConfig(strServerNameKey, kTarServerData.serverName)
			self:Quit()
		end)
	end
	dprint("$$$$"..objInfo.user_name.." "..index)
	dprint("$$$$"..objInfo.lastLoginTime)
	-- self:FindChildComponent(objGroup, "Text_name", "Text").text = strUserName.."("..objInfo.user_name..")"
	self:FindChildComponent(objGroup, "Text_server", "Text").text = "所在区服:"..serverName
	self:FindChildComponent(objGroup, "Text_state", "Text").text = "最后登录:"..os.date("%Y.%m.%d",objInfo.lastLoginTime)

	-- TODO
	local comTextName = self:FindChildComponent(objGroup, "Text_name", "Text");
	local index = 0;
	local nameStr = strUserName.."("..objInfo.user_name..")";
	for i = 1, string.utf8len(nameStr) do
		comTextName.text = string.utf8sub(nameStr, 1, i);
		if comTextName.preferredWidth > 250 then
			index = i - 1;
			break;
		end
	end

	if index > 0 then
		nameStr = string.utf8sub(nameStr, 1, index) .. '...';
	end
	comTextName.text = nameStr;

	local objHeadPic = self:FindChildComponent(objGroup,"Friends_Head/head","Image")
	local picSize = "40"
	if (MSDKHelper:GetChannelId()==1) then
		picSize = "/46"
	end
	GetHeadPicByUrl(objInfo.picture_url..picSize,function(sprite)
		objHeadPic.sprite = sprite
	end)
end


function FriendListUI:RefreshUI(info)
	dprint("####Refresh FriendlistUI")
	-- 清空列表
	-- 请求服务器列表, 以防 增/删 服务器时客户端显示不及时
	self:FriendListFreshData()
end



function FriendListUI:Quit()
	
	local loginUI = GetUIWindow('LoginUI')
	if loginUI ~= nil then 
		loginUI.objUIRoot_Node:SetActive(true)
		loginUI:UpdateServerNode()
	end
	RemoveWindowImmediately("FriendListUI")
end

function FriendListUI:OnDestroy()
	--self.comServerList:RemoveListener()
end

return FriendListUI