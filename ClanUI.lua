ClanUI = class("ClanUI",BaseWindow)
local ClanPanelUI = require 'UI/Clan/ClanPanelUI'

local ClanSortFunction = function(clanData1, clanData2)
	if clanData1.uiClanDisplayState ~= nil and clanData1.uiClanDisplayState ~= clanData2.uiClanDisplayState then
		return ClanLockWeightMap[clanData1.uiClanDisplayState] > ClanLockWeightMap[clanData2.uiClanDisplayState]
	end
	return (clanData1.uiClanTypeID or 0) < (clanData2.uiClanTypeID or 0)
end

function ClanUI:ctor()

end

function ClanUI:Create()
	local obj = LoadPrefabAndInit("Clan/ClanUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ClanUI:Init()
	-- 左侧导航
	self.objSC_nav = self:FindChild(self._gameObject, "SC_nav")
	self.objNav_content = self:FindChild(self.objSC_nav, "Viewport/Content")
	self.objNav_content_TG = self.objNav_content:GetComponent("ToggleGroup")
	self.objNav_template = self:FindChild(self.objSC_nav, "Tab_template")
	self.objNav_template:SetActive(false)

	-- 右侧门派列表
	self.objSC_clan = self:FindChild(self._gameObject, "SC_clan")
	self.objClan_content = self:FindChild(self.objSC_clan, "Viewport/Content")
	self.objClan_template = self:FindChild(self.objSC_clan, "Clan_block")

	-- 门派卡片
	self.detail_panel = self:FindChild(self._gameObject, "detail_panel")
	self.detail_panel:SetActive(false)
	self.ClanPanelUI = ClanPanelUI.new()
	------------------------------------------
	self.ClanPanelUI:SetCloseFunc(  function() self.detail_panel:SetActive(false) end)
	self.ClanPanelUI:SetSubmitFunc( function() self:OnClick_JoinClan() end)
	self.ClanPanelUI:SetLeftFunc( function()
		self:ShowNextClan('left')
	end)
	self.ClanPanelUI:SetRightFunc( function()
		self:ShowNextClan('right')
	end)
	------------------------------------------
	self.ClanPanelUI:ExternalInit(self.detail_panel)


	self.comText_Unlock = self:FindChildComponent(self._gameObject,"Unlock_text", DRCSRef_Type.Text)

	-- 临时关闭
	self.comButton = self:FindChildComponent(self._gameObject,"Button", DRCSRef_Type.Button)
	if self.comButton then
		self:AddButtonClickListener(self.comButton,
		function()
			RemoveWindowImmediately('ClanUI')
			if self.closeActionEnd then
				DisplayActionEnd()
			end
		end)
	end

	--
	self.comButtonClose = self:FindChildComponent(self._gameObject, "frame/Btn_exit", DRCSRef_Type.Button);
	if self.comButtonClose then
		self:AddButtonClickListener(self.comButtonClose, function()
			RemoveWindowImmediately('ClanUI');
			if self.closeActionEnd then
				DisplayActionEnd()
			end
			if self.callback then
				self.callback();
			end
		end)
	end
	self.comButtonClose.gameObject:SetActive(false);

	self:InitNav()	-- 加载导航栏

	self:AddEventListener("UPDATE_CLAN_DATA", function()
		self:RefreshUI(nil, true)
	end)
end

function ClanUI:OnPressESCKey()
    if self.comButtonClose then
		if self.detail_panel.activeSelf then
			self.detail_panel:SetActive(false)
		else
			if self.comButtonClose.gameObject.activeSelf then
				self.comButtonClose.onClick:Invoke()
			end
		end
    end
end

function ClanUI:SetCloseCallBack(callback)
	self.callback = callback;
end

function ClanUI:SetCloseBtnActive(active)
	self.comButtonClose.gameObject:SetActive(active);
end

-- 该结构需要删除
local clantype_convert = {
	[ClanType.CLT_Null] = '全部',
	[ClanType.CLT_BaDao] = '霸道盟',
	[ClanType.CLT_WuLin] = '武林盟',
	[ClanType.CLT_XianSan] = '中立闲散',
}
local clantype = {
	[1] = ClanType.CLT_Null,
	[2] = ClanType.CLT_BaDao,
	[3] = ClanType.CLT_WuLin,
	[4] = ClanType.CLT_XianSan,
}

-- 加载门派导航
function ClanUI:InitNav()
	RemoveAllChildren(self.objNav_content)
	for i = 1, #clantype do
		local ui_child = CloneObj(self.objNav_template, self.objNav_content)
		if (ui_child ~= nil) then
			ui_child:SetActive(true)
			local comText = self:FindChildComponent(ui_child, "Text", DRCSRef_Type.Text)
			comText.text = clantype_convert[clantype[i]]
			local comToggle = ui_child:GetComponent("Toggle")
			local objNormal = self:FindChild(ui_child, "normal")
			if comToggle then
				comToggle.group = self.objNav_content_TG
				self:AddToggleClickListener(comToggle, function(bool)
					objNormal:SetActive(not bool)
					comText.color = bool and DRCSRef.Color.white or DRCSRef.Color(0.17,0.17,0.17,1)
					if bool then
						self:ChooseNav(clantype[i])
					end
				end)
				if i == 1 then comToggle.isOn = true end
			end
		end
	end
end

-- 选中一个导航按钮，筛选对应的门派 block
function ClanUI:ChooseNav(clantype)
	self.eChooseNav = clantype
	local eShowState
	local iAll = 0
	local iUnlock = 0
	local clandatamgr = ClanDataManager:GetInstance()
	if self.objClan_content and self.comText_Unlock then
		for i = 1, self.objClan_content.transform.childCount do
			eShowState = nil
			local objChild = self.objClan_content.transform:GetChild(i-1).gameObject
			if clantype == ClanType.CLT_Null then
				objChild:SetActive(true)
				eShowState = GetUIntDataInGameObject(objChild, 'eShowState')
				iAll = iAll + 1
				if eShowState == ClanLock.CLL_JoinClan then
					iUnlock = iUnlock+ 1
				end
			else
				-- 读取 UINT
				local childtype = GetUIntDataInGameObject(objChild,"type")
				if childtype == clantype then
					objChild:SetActive(true)
					eShowState = GetUIntDataInGameObject(objChild, 'eShowState')
					iAll = iAll + 1
					if eShowState == ClanLock.CLL_JoinClan then
						iUnlock = iUnlock+ 1
					end
				else
					objChild:SetActive(false)
				end
			end
		end
		self.comText_Unlock.text = '已解锁:' .. iUnlock .. '/' .. iAll
	end
end

function ClanUI:RefreshUI(info, dontModifyInfo)
	local isShowOnly = false
	if dontModifyInfo == true then
		isShowOnly = self.isShowOnly
	else
		if info then
			isShowOnly = info.isShowOnly
			-- 关闭之后推进 action 队列
			self.closeActionEnd = info.closeActionEnd
		else
			self.closeActionEnd = false
		end
	end

	-- TODO: 处理参数 isShowOnly, 如果仅展示的话, 不显示 加入门派 按钮且显示 关闭 按钮
	self:ResetClanUI()
	local clanDataList = self:GetClanDataList()
	self.isShowOnly = isShowOnly
	if isShowOnly and self.comButtonClose then
		self.comButtonClose.gameObject:SetActive(true)
	elseif self.comButtonClose then
		self.comButtonClose.gameObject:SetActive(false)
	end
	if self.objClan_template and self.objClan_content then
		for i = 1, #clanDataList do
			if clanDataList[i].uiClanDisplayState ~= ClanLock.CLL_NeverJoin and			-- 不可加入
				clanDataList[i].uiClanDisplayState ~= ClanLock.CLL_UnknownClan then		-- 未知
				local objClanBlock = self:GetAvailableClanBlockObj()
				objClanBlock:SetActive(true)
				self:UpdateClanBlock(objClanBlock, clanDataList[i])
			end
		end
	end
	if self.ClanPanelUI and self.clan_toshow then
		self.ClanPanelUI:SetSwitch(#self.clan_toshow > 1)
	end

	self:ChooseNav(self.eChooseNav or 1)
end

-- 重置界面, 清除不需要的数据
function ClanUI:ResetClanUI()
	self.clan_toshow = {}
	-- TODO: 失效的可以隐藏, 而不是直接 remove
	RemoveAllChildrenImmediate(self.objClan_content)
end

-- 获取一个可用的 门派信息块 界面节点
function ClanUI:GetAvailableClanBlockObj()
	-- TODO: 不需要每次都重新 Clone, 失效的可以先隐藏, 需要用的时候再显示出来
	return CloneObj(self.objClan_template, self.objClan_content)
end

-- 返回经过排序的门派数据列表
function ClanUI:GetClanDataList()
	local clanDataList = {}
	for k,v in pairs(TB_Clan) do
		local baseID = v.BaseID
		local clanData = ClanDataManager:GetInstance():GetClanShowData(baseID)
		if clanData.uiClanTypeID and clanData.uiClanDisplayState then
			table.insert(clanDataList, clanData)
		end
	end
	table.sort(clanDataList, ClanSortFunction)
	return clanDataList
end

-- 更新门派列表的一个方块
function ClanUI:UpdateClanBlock(objBlock, clanData)
	local comImageClan = self:FindChildComponent(objBlock, "Image_clan", DRCSRef_Type.Image)
	local comTextName = self:FindChildComponent(objBlock, "Text_name", DRCSRef_Type.Text)
	local objLock = self:FindChild(objBlock, "lock")
	local objNew = self:FindChild(objBlock, "new")
	local comButton = objBlock:GetComponent(DRCSRef_Type.Button)
	local clanTypeData = TB_Clan[clanData['uiClanTypeID']]
	if clanTypeData and clanTypeData['Type'] then
		SetUIntDataInGameObject(objBlock, 'uiClanTypeID', clanData['uiClanTypeID'])
		SetUIntDataInGameObject(objBlock, 'type', clanTypeData['Type'])
		SetUIntDataInGameObject(objBlock, 'eShowState', clanData['uiClanDisplayState'])
	end

	comImageClan.sprite = GetSprite(clanTypeData.IconPath)
	if clanData.uiClanDisplayState == ClanLock.CLL_UnknownClan then	-- 未知：灰度图片，锁，无法点击
		setUIGray(comImageClan, true)
		objLock:SetActive(true)
		comButton.interactable = false
		comTextName.text = '未知'
		objNew:SetActive(false)
	elseif clanData.uiClanDisplayState == ClanLock.CLL_FamousClan then		-- 听闻，正常图片，锁，可点击
		setUIGray(comImageClan, false)
		objLock:SetActive(true)
		comButton.interactable = true
		comTextName.text = GetLanguageByID(clanTypeData.NameID)
		table.insert(self.clan_toshow, clanData)
		objNew:SetActive(not ClanDataManager:GetInstance():GetIfNew(clanData['uiClanTypeID']))
	elseif clanData.uiClanDisplayState == ClanLock.CLL_JoinClan then			-- 正常可加入，可点击
		setUIGray(comImageClan, false)
		objLock:SetActive(false)
		comButton.interactable = true
		comTextName.text = GetLanguageByID(clanTypeData.NameID)
		table.insert(self.clan_toshow, clanData)		-- 放到可显示详细信息里面
		objNew:SetActive(not ClanDataManager:GetInstance():GetIfNew(clanData['uiClanTypeID']))
	end

	if comButton then
		self:RemoveButtonClickListener(comButton)
		self:AddButtonClickListener(comButton, function()
			self.detail_panel:SetActive(true)
			self:SetCard(clanData)
		end)
	end
end

function ClanUI:OnClick_JoinClan()
	if not self.clanData_choose then return end
	dprint(string.format("OnClick_JoinClan"))
	local uiRoleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
	local uiClanTypeID = self.clanData_choose.uiClanTypeID
	local clickData = EncodeSendSeGC_Click_Clan_Join(uiRoleTypeID, uiClanTypeID)
	local iSize = clickData:GetCurPos()
	NetGameCmdSend(SGC_CLICK_ROLE_JOIN_CLAN, iSize, clickData)
	RemoveWindowImmediately("ClanUI")
	if self.closeActionEnd then
		DisplayActionEnd()
	end
	-- log
	SendClanLog(2, uiClanTypeID)
end

-- 更新门派列表的卡片
function ClanUI:SetCard(clanData)
	self.clanData_choose = clanData		-- 当前选中的门派

	-- 遍历 block，找到对应的卡片，将“新”标记去掉
	for i = 1, self.objClan_content.transform.childCount do
		local objChild = self.objClan_content.transform:GetChild(i-1).gameObject
		local clanID = GetUIntDataInGameObject(objChild, 'uiClanTypeID')
		if clanData and (clanID == clanData['uiClanTypeID']) then
			ClanDataManager:GetInstance():SetHaveOB(clanID)
			local objNew = self:FindChild(objChild, "new")
			objNew:SetActive(false)
			break
		end
	end

	self.ClanPanelUI:SetCard(clanData, self.isShowOnly)
	if clanData == nil then
		return
	end

	local uiClanTypeID = clanData['uiClanTypeID'] or 0
	SendClanLog(1, uiClanTypeID)
end

-- 显示下一个门派，填写数据，要做动画切换效果（在 Panel 里）
function ClanUI:ShowNextClan(direction)
	local curIndex = 1
	local curChooseType=self.eChooseNav
	for i = 1, #self.clan_toshow do
		if self.clan_toshow[i].uiClanTypeID == self.clanData_choose.uiClanTypeID then
			curIndex = i
			break
		end
	end
	local nextIndex = self:GetNextIndex(curIndex,direction)
	-- nextIndex = (direction == 'left') and (nextIndex - 1) or ((nextIndex + 1) % #self.clan_toshow)
	-- nextIndex = (nextIndex < 1) and #self.clan_toshow or nextIndex
	self:SetCard(self.clan_toshow[nextIndex])
end

function ClanUI:GetNextIndex(curIndex,dir)
	if self.eChooseNav ~= clantype[1] then
		if dir=='right' then
			for i=curIndex+1,curIndex+#self.clan_toshow do --从当前位置后面一位开始遍历一圈
				local index=(i-1)%#self.clan_toshow+1	
				if TB_Clan[self.clan_toshow[index].uiClanTypeID].Type == self.eChooseNav then
					return index
				end
			end
		elseif dir=='left' then
			for i=curIndex+#self.clan_toshow-1,curIndex,-1 do --从当前位置前面一位开始遍历一圈
				local index=(i-1)%#self.clan_toshow+1	
				if TB_Clan[self.clan_toshow[index].uiClanTypeID].Type == self.eChooseNav then
					return index
				end
			end
		end
	else
		if dir=='right' then
			return curIndex%#self.clan_toshow+1	--当前位置的后一位,如果是最后一位回到第一位
		elseif dir=='left' then
			return (curIndex+#self.clan_toshow-2)%#self.clan_toshow+1	--当前位置的前一位,等价于当前位置前两位的后一位,防止前面不够两位,所以向后偏移#self.clan_toshow位计算完后取模
		end
	end

	derror("clan GetNextIndex error")	--不应该走到
	return curIndex
end

function ClanUI:OnDestroy()
	self.comButtonClose = nil
	self.objClan_template = nil
	self.objClan_content = nil
	self.clan_toshow = nil
	self.objClan_content = nil
	self.comText_Unlock = nil
	SendClanLog(3, 0)
	self.ClanPanelUI:Close()
	self.ClanPanelUI = nil
end


return ClanUI