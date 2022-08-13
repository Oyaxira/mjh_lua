BatchChooseUI = class("BatchChooseUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

function BatchChooseUI:Create()
	local obj = LoadPrefabAndInit("Game/BatchChooseUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function BatchChooseUI:OnPressESCKey()
    if self.btnClose then
        self.btnClose.onClick:Invoke()
    end
end

function BatchChooseUI:Init()
    self.objChoose = self:FindChild(self._gameObject, "Choose")
    self.objBox = self:FindChild(self.objChoose, "Box")
    self.Template = self:FindChild(self.objChoose, "Template")
    local objCheckBox = self:FindChild(self.Template, "CheckBox")
    self.iMaxColumn = objCheckBox.transform.childCount or 0
    self.Template:SetActive(false)
    self.objBtnOK = self:FindChild(self.objChoose, "Btns/ButtonOK")
    self.btnBtnOk = self.objBtnOK:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnBtnOk, function()
        self:ComfirmToggleRes(BATCH_CHOOSE_TYPE.CHOOSE)
    end)
    self.objBtnLock = self:FindChild(self.objChoose, "Btns/ButtonLock")
    self.btnBtnLock = self.objBtnLock:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnBtnLock, function()
        self:ComfirmToggleRes(BATCH_CHOOSE_TYPE.LOCK)
    end)
    self.objBtnUnLock = self:FindChild(self.objChoose, "Btns/ButtonUnLock")
    self.btnBtnUnLock = self.objBtnUnLock:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnBtnUnLock, function()
        self:ComfirmToggleRes(BATCH_CHOOSE_TYPE.UNLOCK)
    end)
    self.btnClose = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnClose, function()
        self:DoExit()
    end)
    self.objToggleGroup = {}
end

function BatchChooseUI:RefreshUI(info)
    -- 多选结果
    self.toggleRes = self:DecodeRes(GetConfig("BatchChooseRes"), self.iMaxColumn) or {}
    -- -- 清空原有toggle组
    -- 设置回调
    if info.callback then
        self.callback = info.callback
    end
    if info.onClose then
        self.onCloseCallback = info.onClose
    end
    -- 设置参数
    local fliter = nil
    if info.fliter then
        fliter = info.fliter
    else
        fliter = {
            22,  -- 装备
            2,  -- 消耗品
            23,  -- 武学书
            20,  -- 材料
        }
    end
    -- 根据所给数据生成toggle组
    if (not fliter) or (#fliter <= 0) then
        return
    end

    local iCount = 1
    for index, baseID in ipairs(fliter) do
        local objClone = nil
        if iCount > #self.objToggleGroup then
            objClone = CloneObj(self.Template, self.objBox)
            self.objToggleGroup[iCount] = objClone
        else
            objClone = self.objToggleGroup[iCount]
        end
        self:CreateToggleGroup(baseID,objClone)
        iCount = iCount + 1
    end

    for i = iCount,  #self.objToggleGroup do
        self.objToggleGroup[i]:SetActive(false)
    end
end

-- 创建一个Togge组(物品类型)
function BatchChooseUI:CreateToggleGroup(itemTypeBaseID,objClone)
    if not (itemTypeBaseID and objClone) then
        return
    end
    local kItemType = TableDataManager:GetInstance():GetTableData("ItemType", itemTypeBaseID)
    if not kItemType then
        return
    end
    local enumItemType = kItemType.EnumType
    local childItemType = {}
    if kItemType.ChildItemType then
        local kChildItemType = nil
        for index, baseID in ipairs(kItemType.ChildItemType) do
            kChildItemType = TableDataManager:GetInstance():GetTableData("ItemType", baseID)
            if kChildItemType then
                childItemType[#childItemType + 1] = kChildItemType.EnumType
            end
        end
    end
    local strItemType = GetEnumText("ItemTypeDetail", enumItemType) or "missing"
    local textTitle = self:FindChildComponent(objClone, "Title/Text", l_DRCSRef_Type.Text)
    textTitle.text = strItemType
    local objCheckBox = self:FindChild(objClone, "CheckBox")
    local transCheckBox = objCheckBox.transform
    local comToggle = nil
    -- index 与 品质 是对应的
    for index = 1, transCheckBox.childCount do
        comToggle = transCheckBox:GetChild(index - 1):GetComponent(l_DRCSRef_Type.Toggle)
        self:RemoveToggleClickListener(comToggle)
        self:AddToggleClickListener(comToggle, function(bIsOn)
            self.toggleRes[enumItemType] = self.toggleRes[enumItemType] or {}
            self.toggleRes[enumItemType][index] = bIsOn
            -- 如果有子类型, 那么子类型对应的品质也需要设置
            for _, eChildType in ipairs(childItemType) do
                self.toggleRes[eChildType] = self.toggleRes[eChildType] or {}
                self.toggleRes[eChildType][index] = bIsOn
                -- 暗金需要发散
                if index == RankType.RT_DarkGolden then
                    self.toggleRes[eChildType][RankType.RT_MultiColor] = bIsOn
                    self.toggleRes[eChildType][RankType.RT_ThirdGearDarkGolden] = bIsOn
                end
            end
        end)
        if self.toggleRes and self.toggleRes[enumItemType] and self.toggleRes[enumItemType][index] then
            comToggle.isOn = true
        else
            comToggle.isOn = false
        end
    end
    objClone:SetActive(true)
end

-- 确认批量选择结果
function BatchChooseUI:ComfirmToggleRes(eBatchType)
    -- 保存选项结果
    SetConfig("BatchChooseRes",self:EncodeRes())
    if self.callback then
        self.callback(self.toggleRes, eBatchType)
        self.callback = nil
    end
    self:DoExit()
end

-- 将选择结果编为一个字符串
function BatchChooseUI:EncodeRes()
    if not (self.toggleRes and next(self.toggleRes)) then
        return
    end
    local strCode = ""
    local bitGroup = nil
    for enumItemType, res in pairs(self.toggleRes) do
        bitGroup = 0
        for index, bIsOn in pairs(res) do
            if bIsOn == true then
                bitGroup = bitGroup | (1 << index)
            end
        end
        strCode = strCode .. ((strCode == "") and "" or "|") .. tostring(enumItemType) .. "#"  .. tostring(bitGroup)
    end
    return strCode
end

-- 解析保存的选择结果
function BatchChooseUI:DecodeRes(strCode, iMaxColumn)
    if (not strCode) or (strCode == "") then
        return
    end
    local astrMsg = string.split(strCode, "|")
    if (not astrMsg) or (#astrMsg <= 0) then
        return
    end
    iMaxColumn = iMaxColumn or 0
    local res = {}
    local subGroup = nil
    local enumItemType = nil
    local bitGroup = nil
    local bIsOn = nil
    for index, strGroup in ipairs(astrMsg) do
        subGroup = string.split(strGroup, "#")
        if subGroup and (#subGroup >= 2) then
            enumItemType = toint(subGroup[1])
            res[enumItemType] = {}
            bitGroup = toint(subGroup[2])
            for index = 1, iMaxColumn do
                bIsOn = (bitGroup & (1 << index) ~= 0)
                res[enumItemType][index] = bIsOn
            end
        end
    end
    return res
end

-- 退出
function BatchChooseUI:DoExit()
    if self.onCloseCallback then
        self.onCloseCallback()
        self.onCloseCallback = nil
    end
    RemoveWindowImmediately("BatchChooseUI", false)
end

return BatchChooseUI