SystemScreenShotShareTipUI = class("SystemScreenShotShareTipUI",BaseWindow)

function SystemScreenShotShareTipUI:ctor()

end

function SystemScreenShotShareTipUI:Create()
	local obj = LoadPrefabAndInit("Privilege/SystemScreenShotShareTipUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function SystemScreenShotShareTipUI:Init()
	self.objCloseBtn = self:FindChild(self._gameObject,"CloseButton")
	self.objWXShareBtn  = self:FindChild(self._gameObject,"WXShareButton")
	self.objQQShareBtn  = self:FindChild(self._gameObject,"QQShareButton")
	self.objWXTimeLineShareBtn  = self:FindChild(self._gameObject,"WXTimeLineShareButton")
	self.objQQSpaceShareBtn  = self:FindChild(self._gameObject,"QQSpaceShareButton")
	self.objQQArkShareBtn  = self:FindChild(self._gameObject,"QQArkShareButton")
	self.objImageBtn  = self:FindChild(self._gameObject,"ImageBtn")
	self.objImageBG  = self:FindChild(self._gameObject,"ImageBG")

	self.objQQSpaceShareBtn:SetActive(false);
	self.objWXTimeLineShareBtn:SetActive(false);

	local closeButton = self:FindChildComponent(self._gameObject, "CloseButton", "DRButton")
	if closeButton then
		self:AddButtonClickListener(closeButton, function()
			RemoveWindowImmediately('SystemScreenShotShareTipUI')
        end)
	end

	local imageBG = self:FindChildComponent(self._gameObject, "ImageBG", "DRButton")
	if imageBG then
		self:AddButtonClickListener(imageBG, function()
			RemoveWindowImmediately('SystemScreenShotShareTipUI')
        end)
	end

    local qqbutton = self:FindChildComponent(self._gameObject, "QQShareButton", "DRButton")
    if qqbutton then
		self:AddButtonClickListener(qqbutton, function()
			MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, 11)
            -- MSDKHelper:ShareSystemScreenShotToFriend(self.path, nil, nil)
			RemoveWindowImmediately('SystemScreenShotShareTipUI')
        end)
    end

    local wxbutton = self:FindChildComponent(self._gameObject, "WXShareButton", "DRButton")
    if wxbutton then
		self:AddButtonClickListener(wxbutton, function()
			MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, 11)
            -- MSDKHelper:ShareSystemScreenShotToFriend(self.path, nil, nil)
			RemoveWindowImmediately('SystemScreenShotShareTipUI')
        end)
    end

    local qqSpaceButton = self:FindChildComponent(self._gameObject, "QQSpaceShareButton", "DRButton")
    if qqSpaceButton then
		self:AddButtonClickListener(qqSpaceButton, function()
			MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, 11, true)
            -- MSDKHelper:ShareSystemScreenShotToTimeLineOrSpace(self.path,nil)
			RemoveWindowImmediately('SystemScreenShotShareTipUI')
        end)
	end

    local wxTimeLineButton = self:FindChildComponent(self._gameObject, "WXTimeLineShareButton", "DRButton")
    if wxTimeLineButton then
		self:AddButtonClickListener(wxTimeLineButton, function()
			MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, 11, true)
            -- MSDKHelper:ShareSystemScreenShotToTimeLineOrSpace(self.path,nil)
			RemoveWindowImmediately('SystemScreenShotShareTipUI')
        end)
	end
	
	local qqArkButton = self:FindChildComponent(self._gameObject, "QQArkShareButton", "DRButton")
    if qqArkButton then
        self:AddButtonClickListener(qqArkButton, function()
			MSDKHelper:ShareToQQFriendWithArk(MSDKHelper:GetOpenID(), 11)
			RemoveWindowImmediately('SystemScreenShotShareTipUI')
        end)
    end

	--
	if self.objImageBtn then
		local layout = self.objImageBtn:GetComponent('HorizontalLayoutGroup');
		if layout then
			if MSDKHelper:IsLoginQQ() then
				layout.spacing = 15;
			elseif MSDKHelper:IsLoginWeChat() then
				layout.spacing = 40;
			end
		end
	end
end

function SystemScreenShotShareTipUI:OnDestroy()

end

function SystemScreenShotShareTipUI:Update()

end

function SystemScreenShotShareTipUI:RefreshUI(path)
	if path ~= nil then 
		self.path = path
	end

	if MSDKHelper:IsLoginQQ() then
		if not MSDKHelper:IsSpecialChannel() then
			self.objQQShareBtn:SetActive(true)
			self.objQQSpaceShareBtn:SetActive(true)
		end
		self.objQQArkShareBtn:SetActive(false)
		self.objWXShareBtn:SetActive(false)
		self.objWXTimeLineShareBtn:SetActive(false)
	elseif MSDKHelper:IsLoginWeChat() then
		self.objQQShareBtn:SetActive(false)
		self.objQQSpaceShareBtn:SetActive(false)
		self.objQQArkShareBtn:SetActive(false)
		if not MSDKHelper:IsSpecialChannel() then
			self.objWXShareBtn:SetActive(true)
			self.objWXTimeLineShareBtn:SetActive(true)
		end
	end
end

return SystemScreenShotShareTipUI