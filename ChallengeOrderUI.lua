ChallengeOrderUI = class("ChallengeOrderUI",BaseWindow)



function ChallengeOrderUI:ctor()
end

function ChallengeOrderUI:Create()
	local obj = LoadPrefabAndInit("TownUI/ChallengeOrderUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ChallengeOrderUI:Init()
	self.infoNodeTransform = self:FindChild(self._gameObject, "Info_node").transform
	self.spotNodeTransform = self:FindChild(self._gameObject, "spot_node").transform
	self.comBtnLeft_Button = self:FindChildComponent(self._gameObject, "Button_Left", "Button")
	self.comBtnRight_Button = self:FindChildComponent(self._gameObject, "Button_Right", "Button")
	self.comBtnOpenA_Button = self:FindChildComponent(self._gameObject, "Button_OpenA", "Button")
	self.comBtnOpenB_Button = self:FindChildComponent(self._gameObject, "Button_OpenB", "Button")
	self.comBtnOpenC_Button = self:FindChildComponent(self._gameObject, "Button_OpenC", "Button")
	self.comBtnClose_Button = self:FindChildComponent(self._gameObject, "Button_Close", "Button")
	self.objUnlockBoxs = self:FindChild(self._gameObject, "UnlockBoxs")
	self.objBoxA = self:FindChild(self.objUnlockBoxs, "Box_OpenA")
	self.objBoxB = self:FindChild(self.objUnlockBoxs, "Box_OpenB")
	self.objBoxC = self:FindChild(self.objUnlockBoxs, "Box_OpenC")
	self.closeBoxBtnComs = {}
	table.insert(self.closeBoxBtnComs, self:FindChildComponent(self.objBoxA, "Button_close", "DRButton"))
	table.insert(self.closeBoxBtnComs, self:FindChildComponent(self.objBoxB, "Button_close", "DRButton"))
	table.insert(self.closeBoxBtnComs, self:FindChildComponent(self.objBoxB, "Button_red", "DRButton"))
	table.insert(self.closeBoxBtnComs, self:FindChildComponent(self.objBoxC, "Button_close", "DRButton"))
	table.insert(self.closeBoxBtnComs, self:FindChildComponent(self.objBoxC, "Button_red", "DRButton"))

	self.comUnlockFree_Button = self:FindChildComponent(self.objBoxA, "Box_Free/Button_Unlock", "DRButton")
	self.comUnlock50off_Button = self:FindChildComponent(self.objBoxA, "Box_50off/Button_Unlock", "DRButton")
	self.comUnlock25off_Button = self:FindChildComponent(self.objBoxA, "Box_25off/Button_Unlock", "DRButton")
	self.comUnlockMid_Button = self:FindChildComponent(self.objBoxB, "Button_green", "DRButton")
	self.comUnlockHigh_Button = self:FindChildComponent(self.objBoxC, "Button_green", "DRButton")

	self.com50offAchieve_Text = self:FindChildComponent(self.objBoxA, "Box_50off/Text_Achieve", "Text")
	self.com25offAchieve_Text = self:FindChildComponent(self.objBoxA, "Box_25off/Text_Achieve", "Text")
	self.comFreeDay_Text = self:FindChildComponent(self.objBoxA, "Box_Free/Text", "Text")

	self:AddButtonClickListener(self.comBtnLeft_Button, function()
		self:ShowImage(self.showImageIndex - 1)
	end)
	self:AddButtonClickListener(self.comBtnRight_Button, function()
		self:ShowImage(self.showImageIndex + 1)
	end)

	self:AddButtonClickListener(self.comBtnOpenA_Button, function()
		self:OpenOthersBox()
	end)
	self:AddButtonClickListener(self.comBtnOpenB_Button, function()
		self:OpenMidBox()
	end)
	self:AddButtonClickListener(self.comBtnOpenC_Button, function()
		self:OpenHighBox()
	end)
	self:AddButtonClickListener(self.comBtnClose_Button, function()
        RemoveWindowImmediately("ChallengeOrderUI")
	end)

	for index, comCloseBoxBtn in ipairs(self.closeBoxBtnComs) do
		self:AddButtonClickListener(comCloseBoxBtn, function()
			self.objUnlockBoxs:SetActive(false)
		end)
	end

	self:AddButtonClickListener(self.comUnlockFree_Button, function()
        self:OnSubmitUnlock(COT_FREE)
	end)
	self:AddButtonClickListener(self.comUnlockMid_Button, function()
        self:OnSubmitUnlock(COT_MID)
	end)
	self:AddButtonClickListener(self.comUnlockHigh_Button, function()
        self:OnSubmitUnlock(COT_HIGH)
	end)
	self:AddButtonClickListener(self.comUnlock50off_Button, function()
		if self.canBuy50Off then
			self:OnSubmitUnlock(COT_FIFTY_DISCOUNT)
		else
			SystemUICall:GetInstance():Toast('条件未达成')
		end
	end)
	self:AddButtonClickListener(self.comUnlock25off_Button, function()
		if self.canBuy25Off then
			self:OnSubmitUnlock(COT_TWENTYFIVE_DISCOUNT)
		else
			SystemUICall:GetInstance():Toast('条件未达成')
		end
	end)
	
	self:AddEventListener("CHALLENGEORDER_UNLOCK", function() RemoveWindowImmediately("ChallengeOrderUI") end)
	self:AddEventListener("UPDATE_PLAYER_GOLD", function() self.needUpdateBuyText = true end)

	self:InitShowImage()

	self.curTime = 0
end

function ChallengeOrderUI:Update(deltaTime)
	self.curTime = self.curTime + deltaTime

	if self.curTime > 5000 then
		self:ShowImage(self.showImageIndex + 1)
		self.curTime = 0
	end

	if self.needUpdateBuyText then
		self.needUpdateBuyText = false
		self:RefreshBuyText()
	end
end

function ChallengeOrderUI:InitShowImage()
	self.showImageMaxNum = 10
	self.spotObjs = {}
	self.showImageObjs = {}
	self.showImageIndex = 1

	self.showImageNum = self.infoNodeTransform.childCount
	if self.showImageNum > self.showImageMaxNum then
		self.showImageNum = self.showImageMaxNum
	end

	for i = 0, self.showImageNum - 1 do
		self.showImageObjs[i + 1] = self.infoNodeTransform.transform:GetChild(i).gameObject
		self.showImageObjs[i + 1]:SetActive(false)
		self.spotObjs[i + 1] = self.spotNodeTransform.transform:GetChild(i).gameObject
		self.spotObjs[i + 1]:SetActive(true)
		self:ShowSpot(self.spotObjs[i + 1], false)
	end

	self:ShowImage(1)
end

function ChallengeOrderUI:ShowSpot(objSpot, enable)
	self:FindChild(objSpot, "chosen").gameObject:SetActive(enable)
end

function ChallengeOrderUI:ShowImage(index)
	self.showImageObjs[self.showImageIndex]:SetActive(false)
	self:ShowSpot(self.spotObjs[self.showImageIndex], false)

	index = (index - 1) % self.showImageNum + 1

	self.showImageObjs[index]:SetActive(true)
	self:ShowSpot(self.spotObjs[index], true)

	self.showImageIndex = index

	self.curTime = 0
end

function ChallengeOrderUI:OpenOthersBox()
	self.objUnlockBoxs:SetActive(true)
	self.objBoxA:SetActive(true)
	self.objBoxB:SetActive(false)
	self.objBoxC:SetActive(false)

	local data = TableDataManager:GetInstance():GetTableData("PlusEditionConfig", 1)
	local achieveText, finishNum = self:ShowAchieveInfoText()
	local achieveCount = #data.DiscountCondition
	local freeDay = self:GetFreeDay()

	self.com50offAchieve_Text.text = achieveText
	self.com25offAchieve_Text.text = achieveText

	if freeDay > 0 then
		self.comFreeDay_Text.text = string.format("还需登录%d天", freeDay)
		setUIGray(self.comUnlockFree_Button:GetComponent(DRCSRef_Type.Image), true)
		self.comUnlockFree_Button.enabled = false
	else
		self.comFreeDay_Text.text = string.format("可领取")
		setUIGray(self.comUnlockFree_Button:GetComponent(DRCSRef_Type.Image), false)
		self.comUnlockFree_Button.enabled = true
	end
	
	self.canBuy50Off = finishNum > 0
	self.canBuy25Off = finishNum >= achieveCount
end

function ChallengeOrderUI:OpenMidBox()
	self.objUnlockBoxs:SetActive(true)
	self.objBoxA:SetActive(false)
	self.objBoxB:SetActive(true)
	self.objBoxC:SetActive(false)
end

function ChallengeOrderUI:OpenHighBox()
	self.objUnlockBoxs:SetActive(true)
	self.objBoxA:SetActive(false)
	self.objBoxB:SetActive(false)
	self.objBoxC:SetActive(true)
end

function ChallengeOrderUI:ClickOpen(type)
	if type == COT_FREE then
		if self:GetFreeDay() > 0 then
			SystemUICall:GetInstance():Toast("登陆天数不足")
		else
			SendUnlockChallengeOrder(type)
		end
	elseif type == COT_MID then
		local uiPrice = SSD_CHALLENGEORDER_MID_PRICE * 10
		local strSecondConfirm = string.format("是否花费%d金锭解锁完整版？", uiPrice)
		PlayerSetDataManager:GetInstance():RequestSpendGold(uiPrice, function()
			SendUnlockChallengeOrder(type)
			RemoveWindowImmediately("ChallengeOrderUI")
		end, true, strSecondConfirm, 5)
	elseif type == COT_HIGH then
		local uiPrice = SSD_CHALLENGEORDER_HIGH_PRICE * 10
		local strSecondConfirm = string.format("是否花费%d金锭解锁完整版+2个月壕侠百宝书？", uiPrice)
		PlayerSetDataManager:GetInstance():RequestSpendGold(uiPrice, function()
			SendUnlockChallengeOrder(type)
			RemoveWindowImmediately("ChallengeOrderUI")
		end, true, strSecondConfirm, 5)
	end
end

function ChallengeOrderUI:OnSubmitUnlock(type)
	local data = TableDataManager:GetInstance():GetTableData("PlusEditionConfig", 1)
	if data == nil then
		return '', 0
	end

	local num = 0

	if type == COT_FREE then
		num = 0
	elseif type == COT_MID then
		num = data.MidPrice
	elseif type == COT_HIGH then
		num = data.HighPrice
	elseif type == COT_FIFTY_DISCOUNT then
		num = data.MidPrice * data.Discount[1] / 100
		math.floor(num + 0.5)
	elseif type == COT_TWENTYFIVE_DISCOUNT then
		num = data.MidPrice * data.Discount[2] / 100
		math.floor(num + 0.5)
	end

	if type == COT_FREE then
		-- 解锁免费版需要服务器验证条件
		SendUnlockChallengeOrder(type)
		self.objUnlockBoxs:SetActive(false)
	elseif num == 0 then
		SendUnlockChallengeOrder(type)
		RemoveWindowImmediately("ChallengeOrderUI")
	elseif type == COT_FIFTY_DISCOUNT or type == COT_TWENTYFIVE_DISCOUNT then
        local msg = string.format("是否花费%d金锭解锁完整版？\n5个暗金掌门自选卡，仅在原价180金锭解锁完整版，去看看吗？", num)
        local boxCallback = function()
			PlayerSetDataManager:GetInstance():RequestSpendGold(num, function()
				SendUnlockChallengeOrder(type)
				RemoveWindowImmediately("ChallengeOrderUI")
			end, false, nil, 5)
		end
		
		local showContent = {
			['title'] = '提示',
			['text'] = msg,
			['leftBtnText'] = '去看看',
			['rightBtnText'] = '解锁',
			['leftBtnFunc'] = function()
				self:OpenMidBox()
			end
		}
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.CHALLENGEORDER_TIP, showContent, boxCallback})
	else
		PlayerSetDataManager:GetInstance():RequestSpendGold(num, function()
			SendUnlockChallengeOrder(type)
			RemoveWindowImmediately("ChallengeOrderUI")
		end, true, nil, 5)
	end
end

function ChallengeOrderUI:ShowAchieveInfoText()
	local data = TableDataManager:GetInstance():GetTableData("PlusEditionConfig", 1)
	if data == nil then
		return '', 0
	end

	local text = ""
	local num = 0
	for index, achieveID in ipairs(data.DiscountCondition) do
		local achieveData = TableDataManager:GetInstance():GetTableData("Achieve", achieveID)
		if achieveData then
			local achieveName = GetLanguageByID(achieveData.NameID)
			if achieveName then
				if AchieveDataManager:GetInstance():IsAchieveMade(achieveID) then
					achieveName = "<color=#1E808C>"..achieveName.."</color>"
					num = num + 1
				end

				if text ~= "" then
					text = text ..'、'
				end
				text = text..achieveName
			end
		end
	end

	return text, num
end

function ChallengeOrderUI:OnCancelUnlock()
	
end

function ChallengeOrderUI:GetFreeDay()
	local loginDay = (PlayerSetDataManager:GetInstance():GetLoginDayNum() or 0) 
	local lastDay = SSD_CHALLENGEORDER_MID_LOGIN_DAYS - loginDay

	if lastDay < 0 then
		lastDay = 0
	end

	return lastDay 
end

function ChallengeOrderUI:RefreshUI()
	self.objUnlockBoxs:SetActive(false)
	self:RefreshBuyText()
end

function ChallengeOrderUI:RefreshBuyText()
	local numList = {45, 90, 180, 380}
	local buyTextComList = {}
	local buyLinkTextComList = {}

	buyTextComList[1] = self:FindChildComponent(self.comUnlock25off_Button.gameObject, "Text", "Text")
	buyTextComList[2] = self:FindChildComponent(self.comUnlock50off_Button.gameObject, "Text", "Text")
	buyTextComList[3] = self:FindChildComponent(self.comUnlockMid_Button.gameObject, "Text", "Text")
	buyTextComList[4] = self:FindChildComponent(self.comUnlockHigh_Button.gameObject, "Text", "Text")
	buyLinkTextComList[1] = self.comUnlock25off_Button.gameObject:GetComponent("LinkButtonColor")
	buyLinkTextComList[2] = self.comUnlock50off_Button.gameObject:GetComponent("LinkButtonColor")
	buyLinkTextComList[3] = self.comUnlockMid_Button.gameObject:GetComponent("LinkButtonColor")
	buyLinkTextComList[4] = self.comUnlockHigh_Button.gameObject:GetComponent("LinkButtonColor")

	local curNum = PlayerSetDataManager:GetInstance():GetPlayerGold()

	for index, num in ipairs(numList) do
		if curNum >= num then
			buyTextComList[index].color = COLOR_VALUE[COLOR_ENUM.White]
			buyLinkTextComList[index].defaultColor = COLOR_VALUE[COLOR_ENUM.White]
		else
			buyTextComList[index].color = COLOR_VALUE[COLOR_ENUM.Red]
			buyLinkTextComList[index].defaultColor = COLOR_VALUE[COLOR_ENUM.Red]
		end
	end
end

return ChallengeOrderUI