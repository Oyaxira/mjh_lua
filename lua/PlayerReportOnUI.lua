PlayerReportOnUI = class("PlayerReportOnUI",BaseWindow)

local ReportList = {  -- value 请 按2^n往下排
	{['text'] = "恶意辱骂", ['value'] = STRCT_CURSE},
	{['text'] = "垃圾广告", ['value'] = STRCT_ADVERTISING},
	{['text'] = "恶意昵称", ['value'] = STRCT_ILLEGAL_NAME},
	{['text'] = "使用外挂", ['value'] = STRCT_CHEAT},
	{['text'] = "工作室行为", ['value'] = STRCT_ILLEGAL_WORK},
	{['text'] = "其他", ['value'] = STRCT_OTHER},
}

local iMAX_CHAT_LEN = 15

function PlayerReportOnUI:Create()
	local obj = LoadPrefabAndInit("TownUI/PlayerReportOnUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function PlayerReportOnUI:Init()
	-- 信息面板
	local objMsg = self:FindChild(self._gameObject, "Board/Msg")
	self.objPlayerName = self:FindChild(objMsg, "PlayerName")
	self.objPlayerNameWithChat = self:FindChild(objMsg, "PlayerNameWithChat")
	self.textPlayerName = self:FindChildComponent(self.objPlayerName, "Value", "Text")
	self.textPlayerNameWithChat = self:FindChildComponent(self.objPlayerNameWithChat, "Value", "Text")
	self.textChatContent = self:FindChildComponent(self.objPlayerNameWithChat, "ValueChat", "Text")
	self.inputOtherMsg = self:FindChildComponent(objMsg, "OtherMsg", "InputField")
	self.inputOtherMsg.text = ""
	local objBtns = self:FindChild(objMsg, "Btns")
	local btnCancel = self:FindChildComponent(objBtns, "Cancel", "Button")
	self:AddButtonClickListener(btnCancel, function()
		self:OnClickCancel()
	end)
	self.btnComfirm = self:FindChildComponent(objBtns, "Comfirm", "Button")
	self:AddButtonClickListener(self.btnComfirm, function()
		self:OnClickComfirm()
	end)
	local objCheckBox = self:FindChild(objMsg, "CheckBox/Viewport/Content")
	local objCheckItemTemp = self:FindChild(objCheckBox, "Temp")
	self:InitCheckBox(objCheckBox, objCheckItemTemp)

	local fun = function(str)
		local forbidInfo = PlayerSetDataManager:GetInstance():GetForbidByType(SEOT_FORBIDEDITTEXT);
		if forbidInfo then
            HandleCommonFreezing(SEOT_FORBIDEDITTEXT);
			self.inputOtherMsg.text = "";
			return;
		end
	end
	self.inputOtherMsg.onEndEdit:AddListener(fun)
end

-- 初始化选项框
function PlayerReportOnUI:InitCheckBox(objContent, objTemp)
	if not(objContent and objTemp) then
		return
	end
	self.kAllTogs = {}
	local toggleChild = nil
	local textChild = nil
	local objNode = nil
	for index, kData in ipairs(ReportList) do
		objNode = CloneObj(objTemp, objContent)
		textChild = self:FindChildComponent(objNode, "Label", DRCSRef_Type.Text)
		textChild.text = kData.text or ""
		toggleChild = objNode:GetComponent(DRCSRef_Type.Toggle)
		self.kAllTogs[#self.kAllTogs + 1] = toggleChild
		local iChoose = kData.value or 0
		self:RemoveToggleClickListener(toggleChild)
		toggleChild.isOn = false
		self:AddToggleClickListener(toggleChild, function(bOn)
			self:OnClickToggle(bOn, iChoose)
		end)
		objNode:SetActive(true)
	end
end

function PlayerReportOnUI:RefreshUI(info)
	local dwReportScene, strChatContent = PlayerSetDataManager:GetInstance():GetCurReportScene()
	self.objPlayerName:SetActive(false)
	self.objPlayerNameWithChat:SetActive(false)
	local textName = nil
	if strChatContent and strChatContent ~= "" then
		self.objPlayerNameWithChat:SetActive(true)
		local uiStrLen = string.utf8len(strChatContent)
		if uiStrLen > iMAX_CHAT_LEN then
			strChatContent = string.utf8sub(strChatContent, 1, iMAX_CHAT_LEN) .. "..."
		end
		self.textChatContent.text = strChatContent
		textName = self.textPlayerNameWithChat
	else
		self.objPlayerName:SetActive(true)
		textName = self.textPlayerName
	end

	if not (info and info.kCommInfo and info.defPlyID) then
		SystemUICall:GetInstance():Toast("信息获取失败")
		textName.text = "获取失败"
		return
	end

	self.iCurPlayerID = info.defPlyID
	self.strCurPlayerOpenID = info.kCommInfo.acOpenID or ""
	textName.text = info.kCommInfo.acPlayerName or "无名大侠"
	self:ResetAllReport()
end

-- 重置所有举报项
function PlayerReportOnUI:ResetAllReport()
	if self.kAllTogs then
		for index, kTog in ipairs(self.kAllTogs) do
			kTog.isOn = false
		end
	end
	self.iCurChoose = 0
	self.inputOtherMsg.text = ""
end

-- 点击举报选项
function PlayerReportOnUI:OnClickToggle(bOn, iChoose)
	if not iChoose then
		return
	end
	if bOn then
		self.iCurChoose = (self.iCurChoose or 0) + iChoose
	else
		self.iCurChoose = (self.iCurChoose or 0) - iChoose
	end
	if self.iCurChoose < 0 then
		self.iCurChoose = 0
	end
	self.btnComfirm.interactable = (self.iCurChoose > 0)
end

-- 点击确定
function PlayerReportOnUI:OnClickComfirm()
	if not (self.iCurPlayerID and self.strCurPlayerOpenID) then
		SystemUICall:GetInstance():Toast("数据错误", false)
		return
	end
	-- 分析选项字符串
	if (not self.iCurChoose) or (self.iCurChoose <= 0) then
		SystemUICall:GetInstance():Toast("请选择该用户的违规行为", false)
		return
	end
	-- 如果用户勾选了 "其他" 选项, 那么必须要填写其他信息
	if (self.iCurChoose == STRCT_OTHER) and (self.inputOtherMsg.text == "") then
		SystemUICall:GetInstance():Toast("请详细描述其违规行为", false)
		return
	end
	-- 举报场景
	local dwReportScene, strChatContent = PlayerSetDataManager:GetInstance():GetCurReportScene()
	-- SystemUICall:GetInstance():Toast("举报: ".. tostring(self.iCurChoose) .. ", " .. tostring(dwReportScene))
	SendReportCheatPlayer(self.iCurPlayerID, tostring(self.iCurChoose), self.inputOtherMsg.text, strChatContent, dwReportScene)
	SystemUICall:GetInstance():Toast("举报成功", false)
	RemoveWindowImmediately("PlayerReportOnUI")
end

-- 点击取消
function PlayerReportOnUI:OnClickCancel()
	RemoveWindowImmediately("PlayerReportOnUI")
end

function PlayerReportOnUI:OnDestroy()
	self.inputOtherMsg.onEndEdit:RemoveAllListeners();
end

return PlayerReportOnUI