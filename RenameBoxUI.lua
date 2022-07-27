RenameBoxUI = class("RenameBoxUI",BaseWindow)

function RenameBoxUI:Create()
	local obj = LoadPrefabAndInit("PlayerSetUI/RenameBoxUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function RenameBoxUI:Init()
	self.objClose = self:FindChild(self._gameObject, "Content/Close")
    local btnClose = self.objClose:GetComponent("Button")
    self:AddButtonClickListener(btnClose, function()
        self:OnClickClose()
    end)
    self.objRenameBoxFree = self:FindChild(self._gameObject, "Content/Free")
	self.inputRenameBoxFree = self:FindChildComponent(self.objRenameBoxFree, "InputField", "InputField")
	self.inputRenameBoxFree.onValueChanged:AddListener(function(newString,oldString)
		self:CheckNameLength(newString,self.inputRenameBoxFree)
    end)

    self.objRenameBoxPay = self:FindChild(self._gameObject, "Content/Pay")
    self.textRenameBoxOldName = self:FindChildComponent(self.objRenameBoxPay, "Name/Text", "Text")
	self.inputRenameBoxPay = self:FindChildComponent(self.objRenameBoxPay, "InputField", "InputField")
	self.inputRenameBoxPay.onValueChanged:AddListener(function(newString,oldString)
		self:CheckNameLength(newString,self.inputRenameBoxPay)
	end)
	
    local objRenameBoxButton = self:FindChild(self._gameObject, "Content/Rename")
    self.btnRenameBoxButton = objRenameBoxButton:GetComponent("Button")
    self:AddButtonClickListener(self.btnRenameBoxButton, function()
        self:OnClickRename()
    end)
	self.objRenameBoxButtonFree = self:FindChild(objRenameBoxButton, "Free")
	self.textButtonFree = self.objRenameBoxButtonFree:GetComponent("Text")
	
    self.objRenameBoxButtonPay = self:FindChild(objRenameBoxButton, "Pay")
	self.textButtonPay = self:FindChildComponent(self.objRenameBoxButtonPay, "Text", "Text")
	self.textRenameBoxButtonPay = self:FindChildComponent(self.objRenameBoxButtonPay, "Num", "Text")

	self.objRenameBoxButtonCard = self:FindChild(objRenameBoxButton, "Card")
	self.textButtonCard = self:FindChildComponent(self.objRenameBoxButtonCard, "Text", "Text")

	-- 事件监听
	self:AddEventListener("Modify_Player_Appearance", function()
		self:RenameOK()
	end)
	-- 其他数据
	self.iChangeNameCost = 1000    -- 改名一次消费1000银锭, 可以放到表里去, 服务器与客户端保持统一

	local fun = function(str)
        local forbidInfo = PlayerSetDataManager:GetInstance():GetForbidByType(SEOT_FORBIDEDITTEXT);
		if forbidInfo then
            HandleCommonFreezing(SEOT_FORBIDEDITTEXT);
			self.inputRenameBoxPay.text = "";
			return;
		end
    end
    self.inputRenameBoxPay.onEndEdit:AddListener(fun)
end

function RenameBoxUI:CheckNameLength(newString,objText)
	local iStringLen = string.stringWidth(newString)
	if iStringLen > 12 then
		SystemUICall:GetInstance():Toast('取名字数上限为6个汉字12个字符!')
		if objText then
			objText.text = self.oldText
		end
		return false
	else
		self.oldText = newString
		return true
	end
end

function RenameBoxUI:UpdatePayButton(bOn, strText)
	if bOn ~= nil then
		self.btnRenameBoxButton.interactable = bOn
	end
	if strText and (strText ~= "") then
		self.textButtonFree.text = strText
		self.textButtonPay.text = strText
		self.textButtonCard.text = strText
	else
		self.textButtonFree.text = "取名"
		self.textButtonPay.text = "取名"
		local uiCardNum = StorageDataManager:GetInstance():GetRenameCardNum()
		self.textButtonCard.text = string.format("使用一张改名卡\n拥有：%d", uiCardNum)
	end
end

function RenameBoxUI:RefreshUI()
	-- 如果用户没起过名字, 那么有一次免费的改名机会, 否则显示为付费起名
	local playerMgr = PlayerSetDataManager:GetInstance()
	local iRenameNum = playerMgr:GetReNameNum()
	self.iRenameNum = iRenameNum
	local strCurPlayerName = playerMgr:GetPlayerName()
    self.textRenameBoxOldName.text = strCurPlayerName or ""
	self.bFirstRename = (iRenameNum == 0)
	self.objRenameBoxFree:SetActive(self.bFirstRename)
	self.objRenameBoxButtonFree:SetActive(self.bFirstRename)
	self.objRenameBoxPay:SetActive(not self.bFirstRename)
	local uiCardNum = StorageDataManager:GetInstance():GetRenameCardNum()
	self.bUseRenameCard = (uiCardNum > 0)
	self.objRenameBoxButtonPay:SetActive((not self.bUseRenameCard) and (not self.bFirstRename))
	self.objRenameBoxButtonCard:SetActive(self.bUseRenameCard and (not self.bFirstRename))

	-- 第一次起名为强制起名, 所以要屏蔽关闭按钮
	self.objClose:SetActive(not self.bFirstRename)
	self.textRenameBoxButtonPay.text = self.iChangeNameCost
	
	self:UpdatePayButton(true)
end

function RenameBoxUI:OnEnable()
	--dprint("####"..MSDKHelper)
	--dprint("####renameBOx "..MSDKHelper:GetNickName())
	if (MSDKHelper ~= nil) then
		local nickName_origin = MSDKHelper:GetNickName()
		if (nickName_origin ~= nil) then
			--截取12个字符
			local nickName_after1 = string.stringLimit(nickName_origin,12)
			--去除非法字符
			local nickName_after2 = filter_spec_chars(nickName_after1)
			self.inputRenameBoxFree.text = nickName_after2
		else
			self.inputRenameBoxFree.text = ""
		end
	else
		self.inputRenameBoxFree.text = ""
	end
    
	self.inputRenameBoxPay.text = ""
end

function RenameBoxUI:OnClickClose()
	self:RemoveRenameTimeOutTimer()
	RemoveWindowImmediately("RenameBoxUI")
end

-- 添加改名超时计时器
function RenameBoxUI:AddRenameTimeOutTimer()
	self:RemoveRenameTimeOutTimer()
	local uiOffset = 1000  -- 间隔
	local uiTimes = 5  -- 次数
	self.uiDeadLine = uiTimes
	self:UpdatePayButton(false, string.format("%ds", uiTimes))
	local funcCall = function()
		local win = GetUIWindow("RenameBoxUI")
		if not win then
			return
		end
		if not win.uiDeadLine then
			return
		end
		win.uiDeadLine = win.uiDeadLine - 1
		win:UpdatePayButton(nil, string.format("%ds", win.uiDeadLine))
		if win.uiDeadLine == 0 then
			self:RemoveRenameTimeOutTimer()
		end
	end
	self.uiWaitForRenameOkTimer = self:AddTimer(uiOffset, funcCall, uiTimes)
end

-- 移除改名超时计时器
function RenameBoxUI:RemoveRenameTimeOutTimer()
	self:UpdatePayButton(true)
	if not self.uiWaitForRenameOkTimer then
		return
	end
	self:RemoveTimer(self.uiWaitForRenameOkTimer)
	self.uiWaitForRenameOkTimer = nil
end

-- 点击改名
function RenameBoxUI:OnClickRename()
	local bIsFree = (self.iRenameNum == 0)
	local strName = bIsFree and self.inputRenameBoxFree.text or self.inputRenameBoxPay.text
	if (not strName) or (strName == "") then
		SystemUICall:GetInstance():Toast("名字不能为空")
		return
	end
	-- 如果玩家填写了和现在相同的昵称, 那么进行提示
	local strCurPlayerName = PlayerSetDataManager:GetInstance():GetPlayerName(true)
	if strName == strCurPlayerName then
		SystemUICall:GetInstance():Toast("请填写新的昵称")
		return
	end

	if filter_spec_chars(strName) ~= strName then
		SystemUICall:GetInstance():Toast("含有非法字符")
		return
	end

	if self:CheckNameLength(strName) then
		if bIsFree then
			SendModifyPlayerAppearance(SMPAT_NAME, strName)
			self:AddRenameTimeOutTimer()
		else
			local msg = ""
			if self.bUseRenameCard then
				msg = "是否消耗一张改名卡修改您的昵称?"
			else
				msg = string.format("是否花费%s银锭修改您的昵称?", tostring(self.iChangeNameCost))
			end
			local boxCallback = function()
				-- 使用改名卡
				if self.bUseRenameCard then
					SendModifyPlayerAppearance(SMPAT_NAME, strName)
					self:AddRenameTimeOutTimer()
					return
				end
				-- 使用银锭
				PlayerSetDataManager:GetInstance():RequestSpendSilver(self.iChangeNameCost, function()
					SendModifyPlayerAppearance(SMPAT_NAME, strName)
					local win = GetUIWindow("RenameBoxUI")
					if not win then
						return
					end
					win:AddRenameTimeOutTimer()
				end)
			end
			OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback})
		end
	end
end

-- 是否等待用户自己点击改名结束
function RenameBoxUI:SetWaitForClickRenameOK(bOn)
	self.bWaitForClickRenameOK = (bOn == true)
end

-- 成功改名
function RenameBoxUI:RenameOK()
	if self.bWaitForClickRenameOK then
		self.bWaitForClickRenameOK = false
		return
	end
	-- 如果是第一次取名, 那么取名结束后打开引导22
	if self.iRenameNum == 0 then
		local iRenameGuideID = 22
        GuideDataManager:GetInstance():ClearGuide(iRenameGuideID)
		GuideDataManager:GetInstance():StartGuideByID(iRenameGuideID)
		iRenameGuideID = 51
        GuideDataManager:GetInstance():ClearGuide(iRenameGuideID)
		GuideDataManager:GetInstance():StartGuideByID(iRenameGuideID)
	end
	self:RemoveRenameTimeOutTimer()
	RemoveWindowImmediately("RenameBoxUI")
end

function RenameBoxUI:OnDestroy()
	self.inputRenameBoxPay.onEndEdit:RemoveAllListeners()
end

return RenameBoxUI