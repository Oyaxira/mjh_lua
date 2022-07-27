DisguiseUI = class("DisguiseUI",BaseWindow)

function DisguiseUI:Create()
	local obj = LoadPrefabAndInit("DisguiseUI/DisguiseUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function DisguiseUI:OnPressESCKey()
    if self.objDetail.activeSelf then
        self.comDetailCancel_Button2.onClick:Invoke()
    else
        self.comClose_Button.onClick:Invoke()
    end
end

function DisguiseUI:Init()
	-- 左侧导航
	self.objSC_nav = self:FindChild(self._gameObject, "SC_nav")
	self.objNav_content = self:FindChild(self.objSC_nav, "Viewport/Content")
	self.objNav_content_TG = self.objNav_content:GetComponent("ToggleGroup")
	self.objNav_template = self:FindChild(self.objSC_nav, "Tab_template")
    self.objNav_template:SetActive(false)
    
    -- 右侧易容展示列表
	self.objSC_disguise = self:FindChild(self._gameObject, "SC_disguise")
	self.objDisguise_content = self:FindChild(self.objSC_disguise, "Viewport/Content")
    self.objDisguise_template = self:FindChild(self.objSC_disguise, "Disguise_block")
    
    -- 易容详情展示
    self.objDetail = self:FindChild(self._gameObject, "Detail")
    self.comDetailDrawing_Image = self:FindChildComponent(self.objDetail, "img_bg/Mask/img_drawing", "Image")
    self.comDetailSubmit_Button = self:FindChildComponent(self.objDetail, "Button_green", "Button")
    self.comDetailCancel_Button =self:FindChildComponent(self.objDetail, "Button_red", "Button")
    self.comDetailCancel_Button2 =self:FindChildComponent(self.objDetail, "newFrame/Btn_exit", "Button")

    -- 标题
    self.comRoleName_Text = self:FindChildComponent(self._gameObject, "label/NameText", "Text")

    -- 关闭
    self.comClose_Button = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", "Button")

    self.comDetailText = self:FindChildComponent(self._gameObject,"Detail/Type/Text","Text")

    self:AddButtonClickListener(self.comClose_Button, function()
        RemoveWindowImmediately("DisguiseUI")
    end)
    self:AddButtonClickListener(self.comDetailSubmit_Button, function()
        SendClickRoleDisguise(self.roleID, self.selectDisguiseID, 1)

        self.objDetail:SetActive(false)
        RemoveWindowImmediately("DisguiseUI")
    end)
    self:AddButtonClickListener(self.comDetailCancel_Button, function()
        self.objDetail:SetActive(false)
    end)
    self:AddButtonClickListener(self.comDetailCancel_Button2, function()
        self.objDetail:SetActive(false)
    end)

    self.blockObjsList = {}
    self.navObjsList = {}

    RemoveAllChildren(self.objDisguise_content)
end

-- 该结构需要删除
local disguisetype_convert = {
	[DisguiseType.DGT_POPULACE] = '江湖百姓',
	[DisguiseType.DGT_FEMALE] = '女性角色',
	[DisguiseType.DGT_ETHNICMINORITY] = '少数民族',
	[DisguiseType.DGT_IMPORTANTROLE] = '重要角色',
    [DisguiseType.DGT_BUDDHISM] = '正派形象',
    [DisguiseType.DGT_SWORDMAN] = '武林人士',
	[DisguiseType.DGT_ROYAL] = '朝廷形象',
	[DisguiseType.DGT_MENINBALCK] = '黑衣面具',
	[DisguiseType.DGT_VILLAIN] = '反派形象',
	[DisguiseType.DGT_TASK] = '任务易容',
}

-- 导航显示排序
local navtype_sort = {
    DisguiseType.DGT_TASK,
    DisguiseType.DGT_POPULACE,
    DisguiseType.DGT_FEMALE,
    DisguiseType.DGT_ETHNICMINORITY,
    DisguiseType.DGT_IMPORTANTROLE,
    DisguiseType.DGT_BUDDHISM,
    DisguiseType.DGT_SWORDMAN,
    DisguiseType.DGT_ROYAL,
    DisguiseType.DGT_MENINBALCK,
    DisguiseType.DGT_VILLAIN,
}

local function IsDisguiseItemUnlock(baseID)
    local disguiseItemData = TableDataManager:GetInstance():GetTableData("DisguiseItem",baseID)

    local itemIDsMap = globalDataPool:getData("UnlockDisguiseIDMap") or {}

    return disguiseItemData.Lock ~= TBoolean.BOOL_YES or itemIDsMap[baseID]
end

function DisguiseUI:RefreshUI(roleID)
    -- 数据
    self.roleID = roleID
    self.disguiseTypeMap = {}
    local TB_DisguiseItem = TableDataManager:GetInstance():GetTable("DisguiseItem")
    for baseID, disguiseItemData in pairs(TB_DisguiseItem) do
        if IsDisguiseItemUnlock(baseID) then
            local typeList = disguiseItemData.DisguiseTypeList

            for _, type in ipairs(typeList) do
                self.disguiseTypeMap[type] = self.disguiseTypeMap[type] or {}
                table.insert(self.disguiseTypeMap[type], baseID)
            end
        end
    end

    -- 界面
    self.comRoleName_Text.text = RoleDataHelper.GetNameByID(roleID)

    self:RefreshNav()
end

function DisguiseUI:RefreshNav()
    local isOnFlag = false
    local showIndex = 1

    for i = 1, #navtype_sort do
        local disguiseType = navtype_sort[i]

        if self.disguiseTypeMap[disguiseType] and disguisetype_convert[disguiseType] then
            if self.navObjsList[showIndex] == nil then
                self.navObjsList[showIndex] = CloneObj(self.objNav_template, self.objNav_content)
            end

            local ui_child = self.navObjsList[showIndex]
            if ui_child ~= nil then
                ui_child:SetActive(true)
                local comText = self:FindChildComponent(ui_child, "Text", "Text")
                comText.text = disguisetype_convert[disguiseType]
                local comToggle = ui_child:GetComponent("Toggle")
                local objNormal = self:FindChild(ui_child, "normal")
                if comToggle then
                    comToggle.group = self.objNav_content_TG
                    self:RemoveToggleClickListener(comToggle)
                    self:AddToggleClickListener(comToggle, function(bool)
                        objNormal:SetActive(not bool)
                        if bool then
                            self:ChooseNav(disguiseType)
                        end
                        if bool then
                            comText.color = COLOR_VALUE[COLOR_ENUM.White]
                        else
                            comText.color = COLOR_VALUE[COLOR_ENUM.Black]
                        end
                    end)
                    if not isOnFlag then 
                        self:ChooseNav(disguiseType)
                        comToggle.isOn = true 
                        isOnFlag = true
                    end
                end

                showIndex = showIndex + 1
            else
                break
            end
        end
    end
    
    for index = showIndex, #self.navObjsList do
        local ui_child = self.navObjsList[index]
        if ui_child ~= nil then
            ui_child:SetActive(false)
        end
    end


end

function DisguiseUI:ChooseNav(disguiseType)
    if not self.disguiseTypeMap[disguiseType] then
        return
    end
    self.comDetailText.text = disguisetype_convert[disguiseType]
    for index, baseID in ipairs(self.disguiseTypeMap[disguiseType]) do
        if self.blockObjsList[index] == nil then
            self.blockObjsList[index] = CloneObj(self.objDisguise_template, self.objDisguise_content)
        end

        local objBlock = self.blockObjsList[index]
        if objBlock ~= nil then
            objBlock:SetActive(true)
            self:UpdateDisguiseBlock(objBlock, TableDataManager:GetInstance():GetTableData("DisguiseItem",baseID))
        else
            break
        end
    end
    for index = #self.disguiseTypeMap[disguiseType] + 1, #self.blockObjsList do
        local objBlock = self.blockObjsList[index]
        if objBlock ~= nil then
            objBlock:SetActive(false)
        end
    end
    
    self.objDisguise_content.transform.localPosition = DRCSRef.Vec3(0,0,0)
end

function DisguiseUI:UpdateDisguiseBlock(objBlock, typeData)
    if not objBlock or not typeData then
        return
    end

    SetUIntDataInGameObject(objBlock, 'baseID', typeData.BaseID)

    local comDrawing_Image = self:FindChildComponent(objBlock, "mask/img_drawing", "Image")
    local objLabelName = self:FindChild(objBlock, "mask/label_name")
    local comLabelName_Text = self:FindChildComponent(objLabelName, "Text", "Text")
    local comImgBG_Button = self:FindChildComponent(objBlock, "img_bg", "Button")

    local roleModelTypeData = TableDataManager:GetInstance():GetTableData("RoleModel", typeData.Model)
    local nameLanguageID = typeData.NameID

    if roleModelTypeData then
        comDrawing_Image.sprite = GetSprite(roleModelTypeData.Drawing)
    end

    if nameLanguageID and nameLanguageID ~= 0 then
        objLabelName:SetActive(true)
        comLabelName_Text.text = GetLanguageByID(nameLanguageID)
    else
        objLabelName:SetActive(false)
    end

    if comImgBG_Button then
        self:RemoveButtonClickListener(comImgBG_Button)
		self:AddButtonClickListener(comImgBG_Button, function() 
			self:ShowDetail(typeData.BaseID)
		end)
	end
end

function DisguiseUI:ShowDetail(baseID)
    local disguiseItemData = TableDataManager:GetInstance():GetTableData("DisguiseItem",baseID)

    if not disguiseItemData then
        return
    end

    self.selectDisguiseID = baseID

    self.objDetail:SetActive(true)

    local roleModelTypeData = TableDataManager:GetInstance():GetTableData("RoleModel", disguiseItemData.Model)

    if roleModelTypeData then
        self.comDetailDrawing_Image.sprite = GetSprite(roleModelTypeData.Drawing)
    end
end

function DisguiseUI:OnDestroy()
    
end


return DisguiseUI