LoginAggrementUI = class("LoginAggrementUI",BaseWindow)

function LoginAggrementUI:ctor()
end

function LoginAggrementUI:Create()
	  local obj = LoadPrefabAndInit("Logon/AgreementUI",UI_UILayer,true)
	  if obj then
		  self:SetGameObject(obj)
	  end
end

function LoginAggrementUI:Init()
    self.objProfile = self:FindChild(self._gameObject,"Icons/Profile")
    if (MSDK_OS == 2) then
        self.objProfile:SetActive(false)
    else
        self.objProfile:SetActive(true)
    end
    self.comButtonYes = self:FindChildComponent(self._gameObject , "Button_yes", "Button")
    if self.comButtonYes then
      local fun = function()
        local uiLogin = GetUIWindow("LoginUI")
        if (uiLogin) then
          uiLogin:SetAgreeMent(true)
          MSDKHelper:InitSDK()  
        end
        RemoveWindowImmediately("LoginAggrementUI") 
      end
      self:AddButtonClickListener(self.comButtonYes,fun)
    end
    self.comButtonNo = self:FindChildComponent(self._gameObject , "Button_no", "Button")
    if self.comButtonNo then
      local fun = function()
        local uiLogin = GetUIWindow("LoginUI")
        if (uiLogin) then
          uiLogin:SetAgreeMent(false)
        end

        local content = {}
        content['title'] = '提示'
        content['text'] = '尊敬的用户，您需要详细阅读并同意腾讯游戏用户协议、隐私保护指引和儿童隐私保护指引，才可进入游戏。'
        content['leftBtnText'] = '不同意'
        content['rightBtnText'] = '返回'
        content['leftBtnFunc'] = function()
          QuitGame()
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, nil})
      end
      
      self:AddButtonClickListener(self.comButtonNo,fun)
    end


    local linkButton  = self:FindChildComponent(self._gameObject, "ScrollView/Viewport/Content/Text/Button_Link1", "Button")
    if linkButton then
        local fun = function()
            MSDKHelper:OpenContractUrl()
        end
        self:AddButtonClickListener(linkButton, fun)
    end

    linkButton  = self:FindChildComponent(self._gameObject, "ScrollView/Viewport/Content/Text/Button_Link11", "Button")
    if linkButton then
        local fun = function()
            MSDKHelper:OpenContractUrl()
        end
        self:AddButtonClickListener(linkButton, fun)
    end

    linkButton  = self:FindChildComponent(self._gameObject, "ScrollView/Viewport/Content/Text/Button_Link111", "Button")
    if linkButton then
        local fun = function()
            MSDKHelper:OpenContractUrl()
        end
        self:AddButtonClickListener(linkButton, fun)
    end


    linkButton  = self:FindChildComponent(self._gameObject, "ScrollView/Viewport/Content/Text/Button_Link2", "Button")
    if linkButton then
        local fun = function()
            MSDKHelper:OpenPrivacyGuideUrl()
        end
        self:AddButtonClickListener(linkButton, fun)
    end

    linkButton  = self:FindChildComponent(self._gameObject, "ScrollView/Viewport/Content/Text/Button_Link22", "Button")
    if linkButton then
        local fun = function()
            MSDKHelper:OpenPrivacyGuideUrl()
        end
        self:AddButtonClickListener(linkButton, fun)
    end

    linkButton  = self:FindChildComponent(self._gameObject, "ScrollView/Viewport/Content/Text/Button_Link3", "Button")
    if linkButton then
        local fun = function()
            MSDKHelper:OpenPrivacyGuideChildrenUrl()
        end
        self:AddButtonClickListener(linkButton, fun)
    end

    linkButton  = self:FindChildComponent(self._gameObject, "ScrollView/Viewport/Content/Text/Button_Link33", "Button")
    if linkButton then
        local fun = function()
            MSDKHelper:OpenPrivacyGuideChildrenUrl()
        end
        self:AddButtonClickListener(linkButton, fun)
    end
end

function LoginAggrementUI:RefreshUI(info)
	
end

function LoginAggrementUI:OnDestroy()
	
end

return LoginAggrementUI