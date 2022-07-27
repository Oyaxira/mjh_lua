SystemCrashUI = class("SystemCrashUI",BaseWindow)

function SystemCrashUI:ctor()

end

function SystemCrashUI:Create()
	local obj = LoadPrefabAndInit("CommonUI/SystemCrashUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function SystemCrashUI:Init()
    self.btnClose = self:FindChildComponent(self._gameObject, "PopUpWindow_3/Board/Button_close", "Button")
    self:AddButtonClickListener(self.btnClose, function()
        RemoveWindowImmediately("SystemCrashUI", false)
    end)
    self.btnSubmit = self:FindChildComponent(self._gameObject, "Button_submit", "Button")
    self:AddButtonClickListener(self.btnSubmit, function()
        self:SubmitBugMsg()
    end)

    self.imageBG = self:FindChild(self._gameObject, "Image_null")
    self.imageBG:SetActive(true)

    self.textuid = self:FindChildComponent(self._gameObject, "Text_uid", "Text")
    local strZoneID = GetConfig("LoginZone")
	local strServerNameKey = string.format("LoginServerName_%s", tostring(strZoneID))
	local serverName = GetConfig(strServerNameKey) or ''
    local playerid = globalDataPool:getData("PlayerID") or 0
    local host = globalDataPool:getData("GameServerHost") or ''
    local ips = string.split(host,".")
    self.textuid.text = "UID : "..(G_UID or "") --tostring(serverName) .. ips[4] or '' .. ':' .. tostring(playerid)

    self.textbody = self:FindChildComponent(self._gameObject, "Text", "Text")

    self.inputField = self:FindChildComponent(self._gameObject, "InputField", "InputField")
    self.inputField.onValueChanged:AddListener(function()
        self:UpdateWordRemain()
    end)  

    local fun = function(str)
        local forbidInfo = PlayerSetDataManager:GetInstance():GetForbidByType(SEOT_FORBIDEDITTEXT);
		if forbidInfo then
            HandleCommonFreezing(SEOT_FORBIDEDITTEXT);
			self.inputField.text = "";
			return;
        end
    end
    self.inputField.onEndEdit:AddListener(fun)
end

function SystemCrashUI:RefreshUI(info)
    self.inputField.text = ""
    self.errorInfo = info
    if (self.errorInfo) then
        self.textbody.text = self.textbody.text.."\n("..self.errorInfo..")"
    end
end

function SystemCrashUI:UpdateWordRemain()
    local limit = self.inputField.characterLimit or 0
    local remain = self.inputField.characterLimit - string.utf8len(self.inputField.text)
    if remain <=0 then
        SystemUICall:GetInstance():Toast("已经超出字数上限500字")
    end
    if remain < limit then
        self.imageBG:SetActive(false)
    else 
        self.imageBG:SetActive(true)
    end
end

function SystemCrashUI:SubmitBugMsg()
    -- 提交bug信息数据
    local bugReportBody = self.inputField.text
    local reportNum = string.utf8len(self.inputField.text)
    -- 没有写任何信息 则不提交
    if (reportNum > 0) then
        if (self.errorInfo) then
            SendBugReport(self.errorInfo,bugReportBody)
        else
            SendBugReport("nil",bugReportBody)
        end
    end
    SystemUICall:GetInstance():Toast("感谢您的提交！")
    RemoveWindowImmediately("SystemCrashUI", false)
end

function SystemCrashUI:OnDestroy()
    if self.inputField then 
        self.inputField.onValueChanged:RemoveAllListeners()
        self.inputField.onEndEdit:RemoveAllListeners()
        self.inputField.onValueChanged:Invoke()
    end
end

return SystemCrashUI