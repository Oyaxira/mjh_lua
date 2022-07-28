BugReportUI = class("BugReportUI",BaseWindow)

function BugReportUI:ctor()

end

function BugReportUI:Create()
	local obj = LoadPrefabAndInit("TownUI/BugReportUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function BugReportUI:Init()
    self.objMainNode = self:FindChild(self._gameObject, "MainNode")
    self.btnClose = self:FindChildComponent(self.objMainNode, "ButtonClose", "Button")
    self:AddButtonClickListener(self.btnClose, function()
        self:RemoveSelfWindow(false)
    end)
    self.btnSubmit = self:FindChildComponent(self.objMainNode, "ButtonSubmit", "Button")
    self:AddButtonClickListener(self.btnSubmit, function()
        self:SubmitBugMsg(self.inputField.text)
    end)
    self.textWordRemain = self:FindChildComponent(self.objMainNode, "WordReamin", "Text")
    self.inputField = self:FindChildComponent(self.objMainNode, "InputArea", "InputField")
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

function BugReportUI:RefreshUI()
    self.inputField.text = ""

    --
	--BidEditText();
end

function BugReportUI:UpdateWordRemain()
    local limit = self.inputField.characterLimit or 0
    local remain = self.inputField.characterLimit - string.utf8len(self.inputField.text)
    if remain < 0 then
        remain = 0
    end
    self.textWordRemain.text = string.format("剩余可输入: %d/%d", remain, limit)
end

function BugReportUI:SubmitBugMsg(text,bugType)
    bugType = bugType or "AutoReport"
    -- 提交bug信息数据
    SendBugReport(bugType,text)
    SystemUICall:GetInstance():Toast("感谢您的提交")
    self:RemoveSelfWindow(false)
end

function BugReportUI:OnDestroy()
    self.inputField.onValueChanged:RemoveAllListeners()
	self.inputField.onEndEdit:RemoveAllListeners()
	self.inputField.onValueChanged:Invoke()
end

return BugReportUI