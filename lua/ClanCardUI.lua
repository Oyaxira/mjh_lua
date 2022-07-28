ClanCardUI = class("ClanCardUI", BaseWindow)
local SkillIconUI = require 'UI/ItemUI/SkillIconUINew'
-- local TencentShareButtonGroupUI = require "UI/PrivilegeUI/TencentShareButtonGroupUI"

function ClanCardUI:ctor()
    self:Init()
end

function ClanCardUI:Init()
	self.SkillIconUI = SkillIconUI.new()
	self.skillIconBtnList = {}
end

-- 该结构需要删除
local clantype_convert = {
	[ClanType.CLT_Null] = '全部',
	[ClanType.CLT_BaDao] = '霸道盟',
	[ClanType.CLT_WuLin] = '武林盟',
	[ClanType.CLT_XianSan] = '中立闲散',
}

function ClanCardUI:RefreshUI(clanData)
	-- 单独展示此门派界面剧情的时候才会调用,关闭时需要调用DisplayActionEnd()

	-- 联网状态下先去请求数据
	local dwClanTypeID = clanData['uiClanTypeID'] or 0
	ClanDataManager:GetInstance():SendQueryClanCollectionInfo(dwClanTypeID)

	self:UpdateClanCardUI(nil, clanData)
	self:SetShowOnly()
	
end

function ClanCardUI:UpdateClanCardUI(ui_card, clanData)
	-- 
	local dwClanTypeID = clanData['uiClanTypeID'] or 0
	ClanDataManager:GetInstance():SendQueryClanCollectionInfo(dwClanTypeID)

	if ui_card == nil then 
		if self._gameObject ~= nil then 
			ui_card = self._gameObject
		else
			ui_card = LoadPrefabAndInit("Clan/ClanCardUI", UI_UILayer, true)
			self.isSingleDisplay = true
			self.comCloseButton = self:FindChildComponent(ui_card, 'Button_close', 'Button')
			self:AddButtonClickListener(self.comCloseButton, function()
				RemoveWindowImmediately('ClanCardUI')
				DisplayActionEnd()
			end)
		end
	end
    self:SetGameObject(ui_card)

	-- 初始化当前卡片的ui数据（取节点）
	self.BtnExit = self:FindChildComponent(ui_card, "frame/Btn_exit", "Button")
	if not self.Initialized then
		self:AddButtonClickListener(self.BtnExit, function()
			RemoveWindowImmediately('ClanCardUI')
			DisplayActionEnd()
		end)
		self.Initialized=true
	end
	self.comTeacher_CG = self:FindChildComponent(ui_card, "mask/CG", "Image")	-- 立绘
	self.intro_box = self:FindChild(ui_card, "intro_box")
		self.comText_camp = self:FindChildComponent(self.intro_box, "Name/Text_camp", "Text")	-- 阵营
		self.comName = self:FindChildComponent(self.intro_box, "Name", "Text")	-- 名字
		self.comText_join = self:FindChildComponent(self.intro_box, "Text_join", "Text")	-- 加入人数
		self.objText_BubbleUI = self:FindChild(self.intro_box, "BubbleUI")	-- 加入提示语
		self.comText_BubbleUI_text = self:FindChildComponent(self.objText_BubbleUI, "desc", "Text")	-- 加入提示语
		self.comIcon_Image = self:FindChildComponent(self.intro_box, "clan_mark", "Image")	-- 门派小图标
	
	self.detail_box = self:FindChild(ui_card, "detail_box")
		self.objFeature = self:FindChild(self.detail_box, "feature")
			self.objSC_feature = self:FindChild(self.objFeature, "SC_feature")
			self.objSC_featureScroll = self.objSC_feature:GetComponent("ScrollRect")
			self.objFeatureContent = self:FindChild(self.objSC_feature, "Viewport/Content")	-- 特色滚动栏
			self.objFeatureNormal = self:FindChild(self.objSC_feature, "normal")	-- 普通模板
			self.objFeatureHeirloom = self:FindChild(self.objSC_feature, "heirloom")	-- 传家宝模板
			self.objFeatureNormal:SetActive(false)
			self.objFeatureHeirloom:SetActive(false)

		self.objContent = self:FindChild(self.detail_box, "content")
			self.objTopSkillNav = self:FindChild(self.objContent, "Clan_nav_box")
			self.array_TopNav = {}
			for i = 1, 4 do		-- 顶级武学导航，目前默认有四个武学
				local objChild = self.objTopSkillNav.transform:GetChild(i-1).gameObject
				self.array_TopNav[i] = objChild
				local comChildToggle = objChild:GetComponent("Toggle")
				local objChildImage = self:FindChild(objChild, "Image")
				local comChildText = self:FindChildComponent(objChild, "Text", "Text")
				if comChildToggle then
					comChildText.text = self:GetClanSkillDepartText(clanData, i)
					self:RemoveToggleClickListener(comChildToggle)
					self:AddToggleClickListener(comChildToggle, function(bool)
						objChildImage:SetActive(not bool)
						if bool then
							comChildText.color = getUIColor('white')
							self:UpdateSKillInfo(clanData, i)
						else
							comChildText.color = getUIColor('black')
						end
					end)
				end
			end
			self.comSkillTitle_TMP = self:FindChildComponent(self.objContent, "skill_info/title/TMP_name","Text")	-- 技能标题
			self.comSkillTag_Text = self:FindChildComponent(self.objContent, "skill_info/title/Text_tag","Text")	-- 标签
			self.comSkillDesc_Text = self:FindChildComponent(self.objContent, "skill_info/Text_desc","Text")	-- 描述

			self.objSkill_list = self:FindChild(self.objContent, "show/skill_list")		-- 技能列表
			self.objSkill_icon = self:FindChild(self.objContent, "show/SkillIconUI")	-- 技能图标模板
			self.objSkill_icon:SetActive(false)
			self.objClanMartialVideo = self:FindChild(self.objContent, "show/Video")  -- 武学技能展示视频
			self.comClanMartialVideo = self.objClanMartialVideo:GetComponent("VideoPlayer")

		self.objIntroduce = self:FindChild(self.detail_box, "introduce")
			self.comIntroduceText = self:FindChildComponent(self.objIntroduce, "Text", "Text")	-- 详细介绍

	self.comButton_submit = self:FindChildComponent(ui_card, "Button_submit", "Button")	-- 加入按钮
	self.comText_submit = self:FindChildComponent(ui_card, "Button_submit/Text", "Text")	-- 按钮样式

	self.objUnlockCond = self:FindChild(ui_card, "UnlockCond")
	self.textUnlockCond = self:FindChildComponent(self.objIntroduce, "LockText", "Text")

	-- 设置ui显示数据

	-- 显示门派信息（调用下面的接口）
	self:SetClanInfo(clanData)
	local clanTypeData = TB_Clan[clanData['uiClanTypeID']]
	self:SetCardFeature(clanTypeData)
	self:SetClanSkill(clanData)
	self:SetJoinNumber(clanData)

	self:RemoveEventListener("UPDATE_CLAN_INFO_DATA")
	self:AddEventListener("UPDATE_CLAN_INFO_DATA", function()
		if self.clanData and  IsValidObj(self._gameObject) then
			self:SetJoinNumber(self.clanData)
		end
	end)
	-- 注：点击传家宝和技能，都要出 tips

	--
	-- local shareGroupUI = self:FindChild(self._gameObject, 'TencentShareButtonGroupUI');
	-- if shareGroupUI then
	-- 	if not MSDKHelper:IsPlayerTestNet() then

	-- 		local _callback = function(bActive)
    --             local serverAndUIDUI = GetUIWindow('ServerAndUIDUI');
    --             if serverAndUIDUI and serverAndUIDUI._gameObject then
    --                 serverAndUIDUI._gameObject:SetActive(bActive);
    --             end
    --         end

	-- 		self.TencentShareButtonGroupUI = TencentShareButtonGroupUI.new();
	-- 		self.TencentShareButtonGroupUI:ShowUI(shareGroupUI, SHARE_TYPE.MENPAI, _callback);

	-- 		local canvas = shareGroupUI:GetComponent('Canvas');
    --         if canvas then
    --             canvas.sortingOrder = 1301;
    --         end
	-- 	else
    --         shareGroupUI:SetActive(false);
    --     end
	-- end
end

function ClanCardUI:SetShowOnly( ... )
	self.comButton_submit.gameObject:SetActive(false)
	self.objUnlockCond:SetActive(false)
	self.comIntroduceText.gameObject:SetActive(true)
	self.textUnlockCond.gameObject:SetActive(false)
	-- body
end

-- 设置门派简介（掌门立绘、名字、阵营、有几人加入、下方描述）
function ClanCardUI:SetClanInfo(clanData)
	local clanTypeData = TB_Clan[clanData['uiClanTypeID']]
	if not clanTypeData then return end
	local teacher = clanTypeData['Teacher']
	local roleData = TableDataManager:GetInstance():GetTableData("RoleTemplate",teacher)
	local roleModelData = TableDataManager:GetInstance():GetTableData("RoleModel", roleData.ArtID)
    if roleModelData and roleModelData["Drawing"] then
        self.comTeacher_CG.sprite = GetSprite(roleModelData.Drawing)
	end
	self.comName.text = GetLanguageByID(clanTypeData.NameID)
	self.comIcon_Image.sprite = GetSprite(clanTypeData.SmallIconPath)
	if clanTypeData.ClanTipsID and  clanTypeData.ClanTipsID ~= 0 then 
		self.objText_BubbleUI:SetActive(true)
		local tipsstr = GetLanguageByID(clanTypeData.ClanTipsID)
		if tipsstr == "" then
			self.objText_BubbleUI:SetActive(false)
		end
		self.comText_BubbleUI_text.text = tipsstr
	else
		self.objText_BubbleUI:SetActive(false)
	end 
	self.comText_camp.text = clantype_convert[clanTypeData.Type]
	self.comIntroduceText.text = GetLanguageByID(clanTypeData.DescID)
	self.comText_submit.text = dtext(998) .. GetLanguagePreset(clanTypeData.NameID, 997)
	self.comIntroduceText.gameObject:SetActive(true)
	self.textUnlockCond.gameObject:SetActive(false)
	self.objUnlockCond:SetActive(false)
	if clanData.uiClanDisplayState == ClanLock.CLL_FamousClan then		-- 听闻门派不可加入
		self.comButton_submit.gameObject:SetActive(false)
		if clanTypeData.UnlockCondDesc and (clanTypeData.UnlockCondDesc > 0) then
			self.objUnlockCond:SetActive(true)
			self.comIntroduceText.gameObject:SetActive(false)
			self.textUnlockCond.gameObject:SetActive(true)
			self.textUnlockCond.text = GetLanguageByID(clanTypeData.UnlockCondDesc)
		end
	elseif clanData.uiClanDisplayState == ClanLock.CLL_JoinClan then		-- 可加门派
		self.comButton_submit.gameObject:SetActive(true)
	else
		self.comButton_submit.gameObject:SetActive(false)
	end
end

-- 设置门派特色（左上区域）
function ClanCardUI:SetCardFeature(clanTypeData)

	if self.comHeirloomButton and self.comHeirloomButton.gameObject then	-- 先移除监听
		self:RemoveButtonClickListener(self.comHeirloomButton)
	end
	RemoveAllChildren(self.objFeatureContent)

	local array_feature = clanTypeData['MartialFeatureID']
	if array_feature then
		for i = 1, #array_feature do
			local ui_child = CloneObj(self.objFeatureNormal, self.objFeatureContent)
			if (ui_child ~= nil) then
				ui_child:SetActive(true)
				local comTMP_title = self:FindChildComponent(ui_child, "TMP_title", "Text")
				local comText_desc = self:FindChildComponent(ui_child, "Text", "Text")
				comTMP_title.text = GetLanguageByID(array_feature[i])
				comText_desc.text = GetLanguageByID(clanTypeData['MartialDescID'][i])
			end
		end
	end 

	-- 设置传家宝
	local heirloomItemID = ClanDataManager:GetInstance():GetHeirloomByID(clanTypeData.BaseID)
	local heirloomItemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(heirloomItemID)
	if heirloomItemData then
		local ui_child = CloneObj(self.objFeatureHeirloom, self.objFeatureContent)
		if (ui_child ~= nil) then
			ui_child:SetActive(true)
			local comTMP_title = self:FindChildComponent(ui_child, "TMP_title", "Text")
			local comText_desc = self:FindChildComponent(ui_child, "Text", "Text")
			local comImage_item = self:FindChildComponent(ui_child, "item/Icon", "Image")
			comTMP_title.text = heirloomItemData.ItemName or ''
			comTMP_title.color = getRankColor(heirloomItemData.Rank or RankType.RT_White)
			comText_desc.text = heirloomItemData.ItemDesc or ''
			local itemIcon = heirloomItemData.Icon
			if itemIcon then 
				comImage_item.sprite = GetSprite(itemIcon)
			end
			self.comHeirloomButton = self:FindChildComponent(ui_child, "item", "Button")	-- 这个 button 的监听要存起来
			self.comLuaUIAction = self:FindChildComponent(ui_child, "item", "LuaUIAction")
			if self.comHeirloomButton then
				-- local fun = function()
				-- 	local tips = TipsDataManager:GetInstance():GetItemTips(nil, heirloomItemID)
				-- 	OpenWindowImmediately("TipsPopUI", tips)
				-- end
				-- self:AddButtonClickListener(self.comHeirloomButton, fun)
			end
			if self.comLuaUIAction then
				self.comLuaUIAction:SetPointerEnterAction(function()
					local tips = TipsDataManager:GetInstance():GetItemTips(nil, heirloomItemID)
					tips.isSkew = true
					tips.movePositions = {
						x = 250,
						y = 0
					}
					OpenWindowImmediately("TipsPopUI", tips)
				end)
				self.comLuaUIAction:SetPointerExitAction(function()
					RemoveWindowImmediately("TipsPopUI")
				end)
			end
		end
	end

	local ContentRect = self.objFeatureContent:GetComponent("RectTransform")
	if ContentRect.sizeDelta.y > 420 then
		self.objSC_featureScroll.vertical = true
	else
		self.objSC_featureScroll.vertical = false
	end
end

-- 设置门派顶级武学信息（右上区域）
function ClanCardUI:SetClanSkill(clanData)
	local clanTypeData = TB_Clan[clanData['uiClanTypeID']]
	if not clanTypeData then return end
	local length = 0
	if clanTypeData['SpecialMartial'] and next(clanTypeData['SpecialMartial']) then
		length = #clanTypeData['SpecialMartial']
	end
	for i = 1, 4 do
		if i > length then
			self.array_TopNav[i]:SetActive(false)
		else
			self.array_TopNav[i]:SetActive(true)
		end
		if i == 1 then 
			local comChildToggle = self.array_TopNav[i]:GetComponent("Toggle")
			comChildToggle.isOn = true
			self:UpdateSKillInfo(clanData, i)		-- 保险起见直接调用一次
		end
	end
end

function ClanCardUI:GetClanSkillDepartText(clanData, index)
	local clanTypeData = TB_Clan[clanData['uiClanTypeID']]
	if clanTypeData == nil then
		return ''
	end
	local martialTypeID = clanTypeData['SpecialMartial'][index]
	if martialTypeID == nil then
		return ''
	end
	local martialTypeData = GetTableData("Martial",martialTypeID)
	if martialTypeData == nil then
		return ''
	end
	local departLangID = DepartEnumType_Lang[martialTypeData.DepartEnum]
	return GetLanguageByID(departLangID)
end

-- 更新顶级武学信息（玩家点击了页签）
function ClanCardUI:UpdateSKillInfo(clanData, index)
	if not (clanData and index) then return end
	local clanTypeData = TB_Clan[clanData['uiClanTypeID']]
	if not (clanTypeData and clanTypeData['SpecialMartial'] and clanTypeData['SpecialMartial'][index]) then return end
	local martialTypeID = clanTypeData['SpecialMartial'][index]
	local martialTypeData = GetTableData("Martial",martialTypeID)
	if not martialTypeData then
		derror("没有找到武学，武学ID为：",martialTypeID,' 对应门派为：',clanData['uiClanTypeID'])
		return
	end
	self.comSkillTitle_TMP.text = GetLanguageByID(martialTypeData.NameID)
	self.comSkillTitle_TMP.color = getRankColor(martialTypeData.Rank)
	self.comSkillDesc_Text.text = GetLanguageByID(martialTypeData.DesID)

	if #self.skillIconBtnList > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.skillIconBtnList)
	end
	self.skillIconBtnList = {}

	-- MartMovIDs 招式ID数组（固定有的技能，对应上面一块的技能栏）
	local kMartMoveIDs = martialTypeData['MartMovIDs']
	if kMartMoveIDs and next(kMartMoveIDs) then
		for k,v in pairs(kMartMoveIDs) do
			local miTypeData = MartialDataManager:GetInstance():GetMartialItemTypeData(v)
			if miTypeData and miTypeData.ItemType == MartialItemType.MIT_Move and miTypeData['SkillID1'] then
				-- 更新技能标签
				local flags = miTypeData['Flags']
				local str_flag = ''
				if flags and next(flags) then
					str_flag = '[' .. table.concat(flags, '] [') .. ']'
				end
				self.comSkillTag_Text.text = str_flag

				-- 更新技能图标
				local ui_clone =  LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.SkillIconUI,self.objSkill_list.transform)
				ui_clone:SetActive(true)
				ui_clone:UpdateUI( miTypeData['SkillID1'])
				ui_clone:SetTipsValue(nil,miTypeData['SkillID1'],nil,nil,martialTypeID)
				table.insert(self.skillIconBtnList, ui_clone)
			end
		end
		self.objSkill_list:SetActive(true)
	else
		self.comSkillTag_Text.text = ""
		self.objSkill_list:SetActive(false)
	end

	self:UpdateMartialVideo(clanTypeData, index)  -- 展示武学演示视频
end

function ClanCardUI:OnClick_ShowSkillTip(skillid, martialTypeID)
    local tips = TipsDataManager:GetInstance():GetSkillTips(nil,skillid,martialTypeID)
	if tips == nil then return end
	SystemUICall:GetInstance():TipsPop(tips)
end


-- 掌门演示技能
function ClanCardUI:UpdateMartialVideo(kClanBaseData, iIndex)
	if not IsValidObj(self.objClanMartialVideo) then
		return
	end
	self.objClanMartialVideo:SetActive(false) 
	if not (kClanBaseData and iIndex and self.comClanMartialVideo) then
		return
	end
	local aiVideoIDs = kClanBaseData.SpecialMartialVideo
	if (not aiVideoIDs) or (not aiVideoIDs[iIndex]) or (aiVideoIDs[iIndex] == 0) then
		return
	end
	local kResData = TableDataManager:GetInstance():GetTableData("ResourceVideo", aiVideoIDs[iIndex])
	if (not kResData) or (not kResData.Path) or (kResData.Path == "") then
		return
	end
	local videoclip = LoadPrefab(kResData.Path, typeof(DRCSRef.VideoClip))
	if not videoclip then
		return
	end
	self.objClanMartialVideo:SetActive(true)
	self.comClanMartialVideo.clip = videoclip
	self.comClanMartialVideo:Play()
end

function ClanCardUI:OnDisable()
	if IsValidObj(self.objClanMartialVideo) then 
		self.objClanMartialVideo:SetActive(false)
	end
end

-- 显示加入人数
function ClanCardUI:SetJoinNumber(clanData)
	if not clanData then return end
	local num = ClanDataManager:GetInstance():GetClanJoinNumber(clanData.uiClanTypeID)

	self.comText_join.text = string.format("当前已有%d玩家加入", num)
end

function ClanCardUI:OnDestroy()
	self.SkillIconUI:Close()
	if #self.skillIconBtnList > 0 then
		LuaClassFactory:GetInstance():ReturnAllUIClass(self.skillIconBtnList)
	end

	-- if self.TencentShareButtonGroupUI then
	-- 	self.TencentShareButtonGroupUI:Close();
	-- end
end

function ClanCardUI:InitListener()    

end

function ClanCardUI:OnPressESCKey()    
	if self.BtnExit then
	    self.BtnExit.onClick:Invoke()
    end
end

return ClanCardUI