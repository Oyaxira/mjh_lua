CityRoleListUI = class("CityRoleListUI",BaseWindow)


function CityRoleListUI:ctor()

end

function CityRoleListUI:Create()
	local obj = LoadPrefabAndInit("City/CityRoleListUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function CityRoleListUI:Init()
    self.rectTransObj = self._gameObject:GetComponent("RectTransform")

    -- 射线
    self.objBac = self:FindChild(self._gameObject, "Bac")
    self.btnBac = self.objBac:GetComponent("Button")
    self:AddButtonClickListener(self.btnBac, function()
        self:OnClick_Button()
    end)
    self.objBac:SetActive(false)

    -- 滚动栏
    self.objCityRoleList = self:FindChild(self._gameObject, "TransformAdapt_node_left/CityRoleList")
    self.objRoleListContent = self:FindChild(self.objCityRoleList, "Content")
    self.comLoopScroll = self:FindChildComponent(self.objRoleListContent, 'LoopScrollView', 'LoopVerticalScrollRect')
    self.comLoopScroll.totalCount = 0
    self.comLoopScroll:AddListener(function(...) self:SetLabel(...) end)
    self.objRoleListContent:SetActive(false)

    -- 按钮区域
    self.objButtonLayout = self:FindChild(self.objCityRoleList, "Handle")
    self.comButton = self.objButtonLayout:GetComponent("Button")
    if self.comButton then
        self:AddButtonClickListener(self.comButton, function() self:OnClick_Button() end)
    end

    -- 监听
    self:AddEventListener("UPDATE_CURRENT_MAP", function() self.bNeedUpdate = true end)
    self:AddEventListener("UPDATE_ROLE_DATA", function() self.bNeedUpdate = true end)
    self:AddEventListener("MAP_UPDATE", function(iMapID)
        if iMapID == MapDataManager:GetInstance():GetCurMapID() then
            -- self.bNeedUpdate = true
            -- 这里要立即刷新, 不能放到下一帧更新, 否则会出现点快决斗两次的情况
            self:UpdateData()
        end
    end)

    -- 状态
    self.boolean_expand = false
    self.bNeedRefill = true 
end

function CityRoleListUI:OnClick_Button()
    self.btnBac.interactable = false
    self.comButton.interactable = false
    local iMoveDis = 555
    local fMoveTime = 0.3
    if self.boolean_expand then     -- 收起来
        self.twnClose = Twn_MoveX(self.twnClose, self.objCityRoleList, -iMoveDis, fMoveTime, nil, function()
            self:OnClick_Button_End()
            self.objBac:SetActive(false)
        end)
    else    -- 展开
        self.objRoleListContent:SetActive(true)
        self.objBac:SetActive(true)
        self:UpdateData()
        self.twnOpen = Twn_MoveX(self.twnOpen, self.objCityRoleList, iMoveDis, fMoveTime, nil, function()
            self:OnClick_Button_End()
            self.btnBac.interactable = true
        end)
    end
end

function CityRoleListUI:OnClick_Button_End()
    self.comButton.interactable = true

    if self.boolean_expand then
        self.objRoleListContent:SetActive(false)
    end
    self.boolean_expand = not self.boolean_expand
    self.bNeedRefill = true
end

function CityRoleListUI:Update()
    if self.bNeedUpdate == true then
        self.bNeedUpdate = false
        self:UpdateData()
    end
end

-- 不占用 RefreshUI，因为游戏刚打开界面时还没有数据
function CityRoleListUI:UpdateData()
    if not self.objRoleListContent.activeSelf then return end
    self.rolePosDataList = CityDataManager:GetInstance():GetRolePositionDataListInCurCity()
    local iOldCount = self.comLoopScroll.totalCount
    self.comLoopScroll.totalCount = getTableSize(self.rolePosDataList)
    if iOldCount < 10 or self.bNeedRefill then
        self.comLoopScroll:RefillCells()
    else
        self.comLoopScroll:RefreshCells()
    end
    self.bNeedRefill = false
end

-- roleList 被互斥界面收起来以后，再加载要重新刷新。
function CityRoleListUI:OnEnable()
    self.bNeedUpdate = true
end

-- function CityRoleListUI:OnDisable()
--     self.bNeedUpdate = false
-- end

function CityRoleListUI:SetLabel(transform, index)
    index = index + 1   -- self.rolePosDataList 拿到的是 lua table
    local ui_label = transform.gameObject
    self.comTextName = self:FindChildComponent(ui_label, "Name", "Text")
    self.comTextLevel = self:FindChildComponent(ui_label, "Level", "Text")
    self.comTextClan = self:FindChildComponent(ui_label, "Clan", "Text")
    self.comTextChain = self:FindChildComponent(ui_label, "Chain", "Text")
    self.comTextLocation = self:FindChildComponent(ui_label, "Location", "Text")
    self.objNameTitleFlag = self:FindChild(ui_label, "Name/TitleFlag")
    local comInteractButton = self:FindChildComponent(ui_label, "Button", "Button")
    if not (self.rolePosDataList and self.rolePosDataList[index]) then
        dwarning("[CityRoleListUI]->无法获取该项数据",index)
        return
    end
    local roleDataMgr = RoleDataManager:GetInstance()
    local mapDataMgr = MapDataManager:GetInstance()
    local rolePosData = self.rolePosDataList[index]
    local roleID = rolePosData.roleID
    local mapID = rolePosData.mapID
    local roleTypeData = roleDataMgr:GetRoleTypeDataByID(roleID)
    local strRoleName = ""
    if self.objNameTitleFlag then 
        local BeEvolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(roleID,NET_NAME_ID)
		if BeEvolution and BeEvolution.iParam2 == -1 then
			self.objNameTitleFlag:SetActive(true)
		else
			self.objNameTitleFlag:SetActive(false)
        end 
    end 
    if roleTypeData then 
        strRoleName = roleDataMgr:GetRoleTitleAndName(roleID)
        local uiRank = roleDataMgr:GetRoleRank(roleID)
        strRoleName = getRankBasedText(uiRank, strRoleName)
	else
		strRoleName = tostring(roleID)
    end
    self.comTextName.text = strRoleName
    local roleData = roleDataMgr:GetRoleData(roleID)
    local clanID
    if roleData then
        self.comTextLevel.text = roleData.uiLevel or roleTypeData.Level
        if roleData.uiClanID and roleData.uiClanID > 0 then
            clanID = roleData.uiClanID
        elseif roleTypeData and roleTypeData.Clan and roleTypeData.Clan > 0 then
            clanID = roleTypeData.Clan
        end
        local clanData = ClanDataManager:GetInstance():GetClanTypeDataByTypeID(clanID)
        if clanData then
            self.comTextClan.text = GetLanguageByID(clanData.NameID)
        else
            self.comTextClan.text = dtext(995)
        end
    end
    local favorData = roleDataMgr:GetDispotionDataToMainRole(roleID)
    self.comTextChain.text = tostring(favorData.iValue)

    -- 角色在当前场景的地图或在城市根地图, 左侧列表可以直接交互
    local cityDataMgr = CityDataManager:GetInstance()
    local curCityID = cityDataMgr:GetCurCityID()
    if mapID ~= nil and not mapDataMgr:IsCurMapChild(mapID) and mapID ~= cityDataMgr:GetEnterMapID(curCityID) then
        comInteractButton.gameObject:SetActive(false)
        self.comTextLocation.gameObject:SetActive(true)
        self.comTextLocation.text = MapDataManager:GetInstance():GetMapBuildingName(mapID)
    else
        comInteractButton.interactable = true 
        comInteractButton.gameObject:SetActive(true)
        self.comTextLocation.gameObject:SetActive(false)
    end

    self:RemoveButtonClickListener(comInteractButton)
    self:AddButtonClickListener(comInteractButton, function()
        RoleDataManager:GetInstance():TryInteract(roleID, mapID)
    end)
end

function CityRoleListUI:OnDestroy()
    self.comLoopScroll:RemoveListener()
    if (self.comDoTween and self.comDoTween.tween) then
        self.comDoTween.tween:Kill()
    end
end

return CityRoleListUI