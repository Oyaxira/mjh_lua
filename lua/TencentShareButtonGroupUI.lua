TencentShareButtonGroupUI = class("TencentShareButtonGroupUI", BaseWindow)

local objButtonGroup = nil
local objShareButton = nil
local objQQButton = nil
local objWXButton = nil
local objQQSpaceButton = nil
local objWXTimeLineButton = nil
local objQQArkButton = nil
local showChilds = false

function TencentShareButtonGroupUI:ShowUI(root, baseid, callback, ShowMiniApp)
    if not self.objButtonGroup then
        self.objButtonGroup = root;
    end

    if not self.objButtonGroup then
        return;
    end

    self.objButtonGroup:SetActive(false);
    self.showChilds = false
    self.objImageBG = self:FindChild(self.objButtonGroup, "TransformAdapt_node/ImageBG")
    self.objImageBG:SetActive(false)
    self.objShareButton = self:FindChild(self.objButtonGroup, "TransformAdapt_node/ShareButton")
    self.objShareButton:SetActive(false)
    self.objQQButton = self:FindChild(self.objButtonGroup, "TransformAdapt_node/BtnGroup/QQButton")
    self.objQQButton:SetActive(false)
    self.objWXButton = self:FindChild(self.objButtonGroup, "TransformAdapt_node/BtnGroup/WXButton")
    self.objWXButton:SetActive(false)
    self.objQQSpaceButton = self:FindChild(self.objButtonGroup, "TransformAdapt_node/BtnGroup/QQSpaceButton")
    self.objQQSpaceButton:SetActive(false)
    self.objWXTimeLineButton = self:FindChild(self.objButtonGroup, "TransformAdapt_node/BtnGroup/WXTimeLineButton")
    self.objWXTimeLineButton:SetActive(false)
    self.objQQArkButton = self:FindChild(self.objButtonGroup, "TransformAdapt_node/BtnGroup/QQArkButton")
    self.objQQArkButton:SetActive(false)
    self.objImageBot = self:FindChild(self.objButtonGroup, "TransformAdapt_node/BtnGroup/Image_bottom")
    self.objImageBot:SetActive(false)
    self.objShareButtonData = self:FindChild(self.objButtonGroup, "TransformAdapt_node/ShareButton_data")
    if (self.objShareButtonData) then
        self.objShareButtonData:SetActive(false)
        if (ShowMiniApp) then
            self.objShareButtonData:SetActive(false)
        end
        -- colourstar, 暂时屏蔽小程序分享
        self.objShareButtonData:SetActive(false)
    end

    if MSDKHelper:IsLoginWeChat() and MSDKHelper:IsSpecialChannel() then
        self.objShareButton:SetActive(false);
        return;
    end

    local shareButton = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/ShareButton", "DRButton")
    if shareButton then
        self:RemoveButtonClickListener(shareButton)
        self:AddButtonClickListener(shareButton, function()
            self:ShowChildButtons()
        end)
    end

    local shareButtonData = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/ShareButton_data", "DRButton")
    if (shareButtonData) then
        self:RemoveButtonClickListener(shareButtonData)
        self:AddButtonClickListener(shareButtonData, function()
            MSDKHelper:OpenMiniApp()
        end)
    end

    local qqbutton = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/BtnGroup/QQButton", "DRButton")
    if qqbutton then
        self:RemoveButtonClickListener(qqbutton)
        self:AddButtonClickListener(qqbutton, function()
            self:CloseUI(callback)
            MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, baseid, false, function()
                self:ShowUI(nil, baseid, callback);
            end)
        end)
    end

    local wxbutton = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/BtnGroup/WXButton", "DRButton")
    if wxbutton then
        self:RemoveButtonClickListener(wxbutton)
        self:AddButtonClickListener(wxbutton, function()
            self:CloseUI(callback)
            MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, baseid, false, function()
                self:ShowUI(nil, baseid, callback)
            end)
        end)
    end

    local qqSpaceButton = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/BtnGroup/QQSpaceButton", "DRButton")
    if qqSpaceButton then
        self:RemoveButtonClickListener(qqSpaceButton)
        self:AddButtonClickListener(qqSpaceButton, function()
            self:CloseUI(callback)
            MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, baseid, true, function()
                self:ShowUI(nil, baseid, callback)
            end)
        end)
    end

    local wxTimeLineButton = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/BtnGroup/WXTimeLineButton", "DRButton")
    if wxTimeLineButton then
        self:RemoveButtonClickListener(wxTimeLineButton)
        self:AddButtonClickListener(wxTimeLineButton, function()
            self:CloseUI(callback)
            MSDKHelper:ShareScreenShotToFriendNewTest(nil, nil, baseid, true, function()
                self:ShowUI(nil, baseid, callback)
            end)
        end)
    end

    local qqArkButton = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/BtnGroup/QQArkButton", "DRButton")
    if qqArkButton then
        self:RemoveButtonClickListener(qqArkButton)
        self:AddButtonClickListener(qqArkButton, function()
            MSDKHelper:ShareToQQFriendWithArk(MSDKHelper:GetOpenID(), baseid)
        end)
    end

    local imageBGButton = self:FindChildComponent(self.objButtonGroup, "TransformAdapt_node/ImageBG", 'DRButton')
    if imageBGButton then
        self:RemoveButtonClickListener(imageBGButton)
        self:AddButtonClickListener(imageBGButton, function()
            self:ShowChildButtons();
        end)
    end

    if callback then
        callback(true);
    end
end

function TencentShareButtonGroupUI:ShowChildButtons()
    if self.showChilds then
        self.showChilds = false
    else
        self.showChilds = false
    end
    
    if MSDKHelper:IsLoginWeChat() then
        if not MSDKHelper:IsSpecialChannel() then
            self.objWXButton:SetActive(self.showChilds)
            self.objWXTimeLineButton:SetActive(self.showChilds)
        end
    else
        self.objQQArkButton:SetActive(self.showChilds)
        if not MSDKHelper:IsSpecialChannel() then
            self.objQQButton:SetActive(self.showChilds)
            self.objQQSpaceButton:SetActive(self.showChilds)
        end
    end

    self.objImageBG:SetActive(self.showChilds)
    self.objImageBot:SetActive(self.showChilds)
end

function TencentShareButtonGroupUI:CloseUI(callback)
    if self.objButtonGroup ~= nil then
        self.objButtonGroup:SetActive(false)
        self.showChilds = false
        if MSDKHelper:IsLoginWeChat() then
            if not MSDKHelper:IsSpecialChannel() then
                self.objWXButton:SetActive(self.showChilds)
                self.objWXTimeLineButton:SetActive(self.showChilds)
            end
        else
            self.objQQArkButton:SetActive(self.showChilds)
            if not MSDKHelper:IsSpecialChannel() then
                self.objQQButton:SetActive(self.showChilds)
                self.objQQSpaceButton:SetActive(self.showChilds)
            end
        end

        self.objImageBG:SetActive(self.showChilds)
        self.objImageBot:SetActive(self.showChilds)
    end

    if callback then
        callback(false);
    end
end

return TencentShareButtonGroupUI
