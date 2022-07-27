EvolutionUI = class("EvolutionUI",BaseWindow)

local poemLanguageList = {
	240002,
	240003,
	240004,
	240005,
	240006,
	240007,
	240008,
	240009,
	240010,
	240011,
	240012,
	240013,
}
local timeLanguage = 240001
local ITEM_SHOWTIME = 20
local MAX_SHOW_MONTH_COUNT = 6

function EvolutionUI:ctor()

end

function EvolutionUI:Create()
	local obj = LoadPrefabAndInit("Game/EvoluteUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function EvolutionUI:OnPressESCKey()
	if self.comClose_Button then
		self.comClose_Button.onClick:Invoke()
	end
end



function EvolutionUI:Init()
	self.objEvolutionBox = self:FindChild(self._gameObject, "Evolute_box")
	self.comTime_TMP = self:FindChildComponent(self._gameObject, "newFrame/Title", "Text")
	self.comPoem_Text = self:FindChildComponent(self.objEvolutionBox, "Text_Poem", "Text")
	self.comImportant_Button = self:FindChildComponent(self.objEvolutionBox, "Button_Important", "Button")
	self.comClose_Button = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", "Button")
	self.objEvolutionInfo = self:FindChild(self.objEvolutionBox, "SC_EvoluteInfo/Content")
	self.objOnlyImportant = self:FindChild(self.objEvolutionBox, "Button_Important/Image_true")

	self.objBottomBar = self:FindChild(self.objEvolutionBox, "Slider_Bottom")
	self.objScrollbar = self:FindChild(self.objEvolutionBox, "Scrollbar")
	self.comBottom_Text = self:FindChildComponent(self.objBottomBar, "Text", "EmojiText")

	self.objBtnLeft = self:FindChild(self._gameObject, "Button_left")
	self.objBtnRight = self:FindChild(self._gameObject, "Button_right")
	self.comLeft_Button = self.objBtnLeft:GetComponent("DRButton")
	self.comRight_Button = self.objBtnRight:GetComponent("DRButton")

	self:AddButtonClickListener(self.comClose_Button, function()
		RemoveWindowImmediately("EvolutionUI")
		DisplayActionEnd()
	end)
	self:AddButtonClickListener(self.comImportant_Button, function()
		--if not self.itemShowing then
			EvolutionShowManager:GetInstance():SetOnlyShowImportant(not self.onlyImportant)
			self:SetOnlyImportant(not self.onlyImportant)
		--end
	end)
	self:AddButtonClickListener(self.comLeft_Button, function()
		if self.showOldRecordIndex then
			self:ChangeHistroyRecord(self.showOldRecordIndex + 1)
		end
	end)
	self:AddButtonClickListener(self.comRight_Button, function()
		if self.showOldRecordIndex then
			self:ChangeHistroyRecord(self.showOldRecordIndex - 1)
		end
	end)

	self.comLoopScroll = self:FindChildComponent(self._gameObject, 'SC_EvoluteInfo', 'LoopVerticalScrollRect')
	self.comLoopScroll:AddListener(function(...) self:UpdateItemUI(...) end)
	self:SetOnlyImportant(EvolutionShowManager:GetInstance():GetOnlyShowImportant(), true)
end

function EvolutionUI:SetItemActive(objEvolutionItem, active)
	local objRoot = self:FindChild(objEvolutionItem, "Root")
	objRoot:SetActive(active)	
end

function EvolutionUI:GetParamData(recordType, param)
	local data = nil
	if recordType == EvoluteRecordType.ERT_Item then
		data = TableDataManager:GetInstance():GetTableData("Item", param)
	elseif recordType == EvoluteRecordType.ERT_Martial then
		data = TableDataManager:GetInstance():GetTableData("Martial", param)
	elseif recordType == EvoluteRecordType.ERT_Gift then
		data = TableDataManager:GetInstance():GetTableData("Gift", param)
	end
	return data
end

function EvolutionUI:UpdateItemUI(transform, index)
	if transform == nil then 
		return
	end
	local objEvolutionItem = transform.gameObject
	local objTitle = self:FindChild(objEvolutionItem, "Title")
	local objInfo = self:FindChild(objEvolutionItem, "Info_List")
	local comTitle_Text = self:FindChildComponent(objTitle, "Text", "Text")
	local comInfo_Text = self:FindChildComponent(objInfo, "left", "Text")
	local herf = self:FindChild(objInfo, "middle")
	herf:SetActive(false)
	local objImprotant = self:FindChild(objInfo, "BG_Important")

	local isCityItem = self.listRecContent[index+1][1]
	local text = self.listRecContent[index+1][2]
	local important = self.listRecContent[index+1][3]
	local hyperlinkDataDict = self.listRecContent[index+1][4]

	if isCityItem then
		objInfo:SetActive(false)
		objTitle:SetActive(true)	
		comTitle_Text.text = text

		local titlePos = objTitle:GetComponent("RectTransform").anchoredPosition
		titlePos.y = -5
		objTitle:GetComponent("RectTransform").anchoredPosition = titlePos
		objEvolutionItem:GetComponent("LayoutElement").preferredHeight = 50
	else
		objInfo:SetActive(true)
		objTitle:SetActive(false)
		comInfo_Text.text = text

		local titlePos = objTitle:GetComponent("RectTransform").anchoredPosition
		titlePos.y = 0
		objTitle:GetComponent("RectTransform").anchoredPosition = titlePos
		objEvolutionItem:GetComponent("LayoutElement").preferredHeight = 30

		for i,v in pairs(hyperlinkDataDict) do
			herf:SetActive(true)
			local rectPos = herf:GetComponent("RectTransform")

			local nameText
			local data = self:GetParamData(v.dataType, v.dataID)
			if v.dataType == EvoluteRecordType.ERT_Item then
				nameText = data.ItemName or ''
			else
				nameText = GetLanguageByID(data.NameID)
			end
			local leftText = string.sub(text,1,(string.find(text,nameText) or -1))
			local _,dotNum = string.gsub(leftText,"·","A")
			local unit = 17.1
			if dotNum == 2 then
				rectPos.anchoredPosition = DRCSRef.Vec2(v.left * unit + 12, 0)
			elseif dotNum == 1 then
				rectPos.anchoredPosition = DRCSRef.Vec2(v.left * unit + 6, 0)
			else
				rectPos.anchoredPosition = DRCSRef.Vec2(v.left * unit, 0)	
			end
			rectPos.sizeDelta = DRCSRef.Vec2(v.width * 18, 30)

			local comReturnUIAction = self:FindChildComponent(objInfo,"middle","LuaUIAction")
			if comReturnUIAction then
				local fun = function()
					self:ShowHyperlinkData(v)
					self.comLoopScroll.vertical = false
				end
				comReturnUIAction:SetPointerEnterAction(function()
					fun()
				end)
		
				comReturnUIAction:SetPointerExitAction(function()
					RemoveWindowImmediately("TipsPopUI")
					self.comLoopScroll.vertical = true
				end)
			end
		end
		-- -- 添加超链接
		-- comInfo_Text.onHrefClick = nil
		-- if next(hyperlinkDataDict) then
		-- 	comInfo_Text.raycastTarget = true
		-- 	comInfo_Text.onHrefClick = function(str)
		-- 		local index = tonumber(str)
		-- 		if index and hyperlinkDataDict[index] then
		-- 			self:ShowHyperlinkData(hyperlinkDataDict[index])
		-- 		end
		-- 	end
		-- else
		-- 	comInfo_Text.raycastTarget = false
		-- end
	end

	objImprotant:SetActive(false)
	if important then
		if not isCityItem then
			objImprotant:SetActive(true)
		end
	end

	if self.itemShowing then
		if not self.aniItemsObjFlag[objEvolutionItem] and self.showIndex <= index + 1 then
			self.aniItemsObjFlag[objEvolutionItem] = true
			self.aniItemsObj[index + 1] = objEvolutionItem
			self:SetItemActive(objEvolutionItem, false)
		else
			self:SetItemActive(objEvolutionItem, true)
		end
	else
		self:SetItemActive(objEvolutionItem, true)
	end
end

function EvolutionUI:ShowHyperlinkData(data)
	if data.dataType == EvoluteRecordType.ERT_Item then
		local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",data.dataID)
		if kItemTypeData then
			local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, kItemTypeData)
			tips.isSkew = true
			OpenWindowImmediately("TipsPopUI", tips)
		end
	elseif data.dataType == EvoluteRecordType.ERT_Gift then
		local giftData = TableDataManager:GetInstance():GetTableData("Gift", data.dataID)
		local name = GetLanguageByID(giftData.NameID)
		local rank = giftData.Rank
		if rank then
			name = getRankBasedText(rank, name)
		end
		local tips={
			title = name,
			content = GetLanguageByID(giftData.DescID),
			isSkew = true,
		}
		OpenWindowImmediately("TipsPopUI",tips)
	elseif data.dataType == EvoluteRecordType.ERT_Martial then
		local martialData = TableDataManager:GetInstance():GetTableData("Martial", data.dataID)
		local name = GetLanguageByID(martialData.NameID)
		local rank = martialData.Rank
		if rank then
			name = getRankBasedText(rank, name)
		end
		local tips={
			title = name,
			content = GetLanguageByID(martialData.DesID),
			isSkew = true,
		}
		OpenWindowImmediately("TipsPopUI",tips)
	end
end

function EvolutionUI:SetOnlyImportant(flag, initCall)
	self.onlyImportant = flag
	self.objOnlyImportant:SetActive(flag)
	
	if not initCall then
		self:RefreshEvolution()
		self:StopSliderAnim()
	end
end

function EvolutionUI:RefreshUI(info)
	self.infoYear = nil
	self.infoMonth = nil
	self.infoIsHistory = true
	self.showOldRecordIndex = 0

	if type(info) ~= "table" or not info.uiYear or not info.uiMonth then
		EvolutionShowManager:GetInstance():UpdateCurMonthShowData()
	else
		EvolutionShowManager:GetInstance():UpdateMonthShowData(info.uiYear, info.uiMonth)
	end

	local kShowData = EvolutionShowManager:GetInstance():GetShowData()
	if kShowData and kShowData.year and kShowData.month then
		self.infoYear = kShowData.year
		self.infoMonth = kShowData.month
	else
		return
	end

	

	if type(info) ~= "table" or info.bHistory then
		self.infoIsHistory = true
		self:ShowHistory()
	else
		self.infoIsHistory = false
		self:ShowEvolution()
	end
end

local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
local l_EvolutionKey = "t"

function EvolutionUI:Update(delay)
	if self.itemShowing then
		
		self.displayDelay = self.displayDelay - delay

		if self.displayDelay <= 0 then
			
			if self.aniItemsObj[self.showIndex] then
				self:SetItemActive(self.aniItemsObj[self.showIndex], true)
		    end
   
			self.objBottomBar:SetActive(true)
			if self.listRecContent[self.showIndex] then
				local isCityItem = self.listRecContent[self.showIndex][1]
				if not isCityItem then
					self.comBottom_Text.text = self.listRecContent[self.showIndex][2]
					self.objBottomBar:GetComponent("Slider").value = (self.showIndex / #self.listRecContent) * 0.9 + 0.1
				end
			end

			self.showIndex = self.showIndex + 1
			if self.showIndex > #self.listRecContent then
				self:StopSliderAnim()
			end

			self.displayDelay = ITEM_SHOWTIME
		end
	end
	if l_GetKeyDown(l_EvolutionKey) then
		if IsWindowOpen("EvolutionUI") then
			self:OnPressESCKey()
		end
	end
end

function EvolutionUI:ChangeHistroyRecord(index)
	if index > MAX_SHOW_MONTH_COUNT or index < 0 then
		return
	end

	if not self.infoYear or not self.infoMonth then
		return
	end

	local monthNum = (self.infoYear - 1) * 12 + self.infoMonth - index
	if monthNum < 1 then
		return
	end

	local showMonth = (monthNum - 1) % 12 + 1
	local showYear = math.floor((monthNum - 1 + 0.1) / 12) + 1

	EvolutionShowManager:GetInstance():UpdateMonthShowData(showYear, showMonth)
	local kShowData = EvolutionShowManager:GetInstance():GetShowData()
	if kShowData and kShowData.year and kShowData.month then
		self.showOldRecordIndex = index
		if self.infoIsHistory == false and index == 0 then
			self:ShowEvolution()
			self:StopSliderAnim()
			self:RefreshEvolution()
		else
			self:ShowHistory()
		end
	end
end

function EvolutionUI:UpdateChangeHistroyButton()
	if not self.showOldRecordIndex or not self.infoYear or not self.infoMonth then
		self.objBtnLeft:SetActive(false)
		self.objBtnRight:SetActive(false)
		return
	end

	local monthNum = (self.infoYear - 1) * 12 + self.infoMonth - self.showOldRecordIndex

	if self.showOldRecordIndex == 0 then
		self.objBtnRight:SetActive(false)
	else
		self.objBtnRight:SetActive(true)
	end
	if monthNum <= 1 or self.showOldRecordIndex >= 6 then
		self.objBtnLeft:SetActive(false)
	else
		self.objBtnLeft:SetActive(true)
	end
end

function EvolutionUI:StopSliderAnim()
	self.itemShowing = false
	self.objBottomBar:GetComponent("Slider").value = 1

	self.comBottom_Text.text = "本月演化已结束"
end

function EvolutionUI:RefreshEvolution()
	self.aniItemsObjFlag = {}
	self.aniItemsObj = {}

	local kShowData = EvolutionShowManager:GetInstance():GetShowData()

	if not kShowData or not kShowData.cityMap then
		return
	end

	local iYear, iMonth = kShowData.year, kShowData.month
	-- self.comTime_TMP.text = string.format(GetLanguageByID(240001), tostring(iYear), tostring(iMonth))
	self.comTime_TMP.text = EvolutionDataManager:GetInstance():GetLunarDate(iYear,iMonth) or ""
	self.comPoem_Text.text = GetLanguageByID(poemLanguageList[iMonth] or poemLanguageList[1])

	--self.objBottomBar:SetActive(false)
	self:ClearEvolutionItems()

	self.listRecContent = {}

	local TB_City = TableDataManager:GetInstance():GetTable("City")
	local cityRecordList = {}
	for k, v in pairs(kShowData.cityMap) do
		if TB_City[v.cityID] or v.teammatesRecord then
			table.insert(cityRecordList, v)
		end
	end

	table.sort(cityRecordList, function(a, b)
		return a.cityID < b.cityID
	end)

	local bOnlyImp = EvolutionShowManager:GetInstance():GetOnlyShowImportant()

	for i, cityRecord in ipairs(cityRecordList) do
		local cityRecData = {}
		for i, record in ipairs(cityRecord.textList) do
			if bOnlyImp and record.important then
				cityRecData[#cityRecData + 1] = {false, record.text, record.important, record.hyperlinkDataDict}
			elseif not bOnlyImp then
				cityRecData[#cityRecData + 1] = {false, record.text, record.important, record.hyperlinkDataDict}
			end	
		end

		if #cityRecData > 0 then
			if cityRecord.teammatesRecord then
				self.listRecContent[#self.listRecContent + 1] = {true, "队伍", cityRecord.important}
			else
				self.listRecContent[#self.listRecContent + 1] = {true, GetLanguageByID(TB_City[cityRecord.cityID].NameID), cityRecord.important}
			end
		end

		for n = 1, #cityRecData do
			self.listRecContent[#self.listRecContent + 1] = cityRecData[n]
		end	
	end

	self.comLoopScroll.totalCount = #self.listRecContent
	self.comLoopScroll:RefillCells()
end

function EvolutionUI:ShowEvolution()
	self.itemShowing = true
	self.showIndex = 1
	self.displayDelay = ITEM_SHOWTIME
	self.comBottom_Text.text = ""
	self.objBottomBar:SetActive(true)
	self.objScrollbar:SetActive(true)
	self:UpdateChangeHistroyButton()
	self:RefreshEvolution()
end

function EvolutionUI:ShowHistory()
	self.itemShowing = false
	self.objBottomBar:SetActive(false)
	self.objScrollbar:SetActive(false)
	self:UpdateChangeHistroyButton()
	self:RefreshEvolution()
end

function EvolutionUI:TestShow()
	
end

function EvolutionUI:ClearEvolutionItems()
	self.aniItemsObj = {}
	self.aniItemsObjFlag = {}
end

function EvolutionUI:OnDestroy()
end

function EvolutionUI:OnEnable()
    BlurBackgroundManager:GetInstance():ShowBlurBG()
end

function EvolutionUI:OnDisable()
    BlurBackgroundManager:GetInstance():HideBlurBG()
end

return EvolutionUI