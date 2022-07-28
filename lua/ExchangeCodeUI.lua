ExchangeCodeUI = class("ExchangeCodeUI",BaseWindow)

function ExchangeCodeUI:Create()
	local obj = LoadPrefabAndInit("PlayerSetUI/ExchangeCodeWindow",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function ExchangeCodeUI:Init()
	self.objClose = self:FindChild(self._gameObject, "PopUpWindow_1/Board/Button_close")
    local btnClose = self.objClose:GetComponent("Button")
    self:AddButtonClickListener(btnClose, function()
        self:OnClickClose()
	end)
	
	self.objButton1 = self:FindChild(self._gameObject, "Button_1")
    local btnButton1 = self.objButton1:GetComponent("Button")
    self:AddButtonClickListener(btnButton1, function()
        self:OnClickButton1()
	end)
	
	self.objButton2 = self:FindChild(self._gameObject, "Button_2")
    local btnButton2 = self.objButton2:GetComponent("Button")
    self:AddButtonClickListener(btnButton2, function()
        self:OnClickButton2()
	end)
    
end

function ExchangeCodeUI:OnClickButton1()
	--channel 1 微信 2 QQ
	local channel = 1
	if (MSDKHelper:GetChannel() == "WeChat") then
		channel = 1
	elseif (MSDKHelper:GetChannel() == "QQ") then
		channel = 2
	end
	--system  0 苹果 1 安卓
	local system = 1
	if (MSDK_OS == 1) then
		system = 1
	elseif (MSDK_OS == 2) then
		system = 0
	end
	local url = "https://xk.qq.com/jinli/passcode/UmBY7rfLTq4HzxR/index.html?channel="..channel.."&system="..system
	dprint(url)
	DRCSRef.MSDKWebView.OpenUrl(url)
	RemoveWindowImmediately("ExchangeCodeUI")
end

function ExchangeCodeUI:OnClickButton2()
	DRCSRef.MSDKWebView.OpenUrl("https://xk.qq.com/act/agile/321602/index.html")
	RemoveWindowImmediately("ExchangeCodeUI")
end


function ExchangeCodeUI:RefreshUI()
	
end

function ExchangeCodeUI:OnEnable()
	
end

function ExchangeCodeUI:OnClickClose()
	RemoveWindowImmediately("ExchangeCodeUI")
end


function ExchangeCodeUI:OnDestroy()
	
end

return ExchangeCodeUI