DialogControlUI = class("DialogControlUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

function DialogControlUI:Create()
	local obj = LoadPrefabAndInit("Game/DialogControlUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function DialogControlUI:Init()
	self.objRoot = self:FindChild(self._gameObject, "Btns")

	self.objBtnAuto = self:FindChild(self.objRoot, "Auto")
	local btnAuto = self.objBtnAuto:GetComponent(l_DRCSRef_Type.Button)
	self:AddButtonClickListener(btnAuto, function()
		self:OnClickOpenAuto()
	end)
	self.objBtnAutoOn = self:FindChild(self.objBtnAuto, "On")
	self.objBtnAutoOff = self:FindChild(self.objBtnAuto, "Off")

	self.objBtnFast = self:FindChild(self.objRoot, "Fast")
	local btnFast = self.objBtnFast:GetComponent(l_DRCSRef_Type.Button)
	self:AddButtonClickListener(btnFast, function()
		self:OnClickOpenFast()
	end)
	self.objBtnFastOn = self:FindChild(self.objBtnFast, "On")
	self.objBtnFastOff = self:FindChild(self.objBtnFast, "Off")

	self.objBtnRecord = self:FindChild(self.objRoot, "Record")
	local btnRecord = self.objBtnRecord:GetComponent(l_DRCSRef_Type.Button)
	self:AddButtonClickListener(btnRecord, function()
		self:OnClickOpenRecord()
	end)
	LogicMain:GetInstance().DialogControlUI=self
end

function DialogControlUI:RefreshUI(bIsChat)
	self.objBtnAuto:SetActive(bIsChat == true)
	self.objBtnFast:SetActive(false)	--去除快进对话按钮
	self.objBtnRecord:SetActive(true)

	if bIsChat then
		self:UpdateFuncBtnState("AutoChatOpen")
		--self:UpdateFuncBtnState("FastChatOpen")
	end
end

function DialogControlUI:OnClickOpenAuto()
	local kDialogMgr = DialogRecordDataManager:GetInstance()
	local bAutoChatOpen = (kDialogMgr:IsAutoChatOpen() == true)
	local bNewState = (not bAutoChatOpen)
	kDialogMgr:SetAutoChatState(bNewState)
	self:UpdateFuncBtnState("AutoChatOpen")

	if bNewState then
		LuaEventDispatcher:dispatchEvent("DialogEnd")
	end
end

function DialogControlUI:OnClickOpenFast()
	local kDialogMgr = DialogRecordDataManager:GetInstance()
	local bFastChatOpen = (kDialogMgr:IsFastChatOpen() == true)
	local bNewState = (not bFastChatOpen)
	kDialogMgr:SetFastChatState(bNewState)
	self:UpdateFuncBtnState("FastChatOpen")

	if bNewState then
		LuaEventDispatcher:dispatchEvent("DialogEnd")
	end
end

function DialogControlUI:OnClickOpenRecord()
	OpenWindowImmediately("DialogRecordUI")
end

function DialogControlUI:UpdateFuncBtnState(strKey)
	local imgBtn = nil
	local bFuncOpen = false
	local kDialogMgr = DialogRecordDataManager:GetInstance()
	if strKey == "AutoChatOpen" then
		bFuncOpen = (kDialogMgr:IsAutoChatOpen() == true)
		self.objBtnAutoOn:SetActive(bFuncOpen)
		self.objBtnAutoOff:SetActive(not bFuncOpen)
	elseif strKey == "FastChatOpen" then
		bFuncOpen = (kDialogMgr:IsFastChatOpen() == true)
		self.objBtnFastOn:SetActive(bFuncOpen)
		self.objBtnFastOff:SetActive(not bFuncOpen)
	end
end

function DialogControlUI:HideBtns()
	self.objRoot:SetActive(false)
end

function DialogControlUI:ShowBtns()
	self.objRoot:SetActive(true)
end

return DialogControlUI