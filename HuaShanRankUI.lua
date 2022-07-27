HuaShanRankUI = class("HuaShanRankUI",BaseWindow)

function HuaShanRankUI:ctor()
end

function HuaShanRankUI:Create()
	local obj = LoadPrefabAndInit("RankUI/HuaShanRankUI",UI_UILayer,true)
	if obj then
        self:SetGameObject(obj)
	end
end

function HuaShanRankUI:Init()
    self.comDeleteStory_Toggle = self:FindChildComponent(self._gameObject, "ToggleGroup/Toggle1", "Toggle")
    self.comWeekRound_Toggle = self:FindChildComponent(self._gameObject, "ToggleGroup/Toggle2", "Toggle")
    self.comDifficult_Toggle = self:FindChildComponent(self._gameObject, "ToggleGroup/Toggle3", "Toggle")
    self.comFirstTest_Toggle = self:FindChildComponent(self._gameObject, "ToggleGroup/Toggle_FirstTest", "Toggle")
    self.comClose_Button = self:FindChildComponent(self._gameObject, "Button_close", "DRButton")
    self.comBottomDown = self:FindChildComponent(self._gameObject, "bottom/Button_down", "DRButton")
    self.comBottomUp = self:FindChildComponent(self._gameObject, "bottom/Button_up", "DRButton")

    self.objNameBG = self:FindChild(self._gameObject, "name_bottom")
    self.objNameNodes = self:FindChild(self._gameObject, "name_node")
    self.objFirstTest = self:FindChild(self._gameObject, "name_firsttest")

    self.objToggleTempalte = self:FindChild(self._gameObject, "ToggleItem")
    self.objLabelTempalte = self:FindChild(self._gameObject, "LabelItem")
    self.objContentTempalte = self:FindChild(self._gameObject, "ContentItem")

    self.comToggleGroup = self:FindChildComponent(self._gameObject, "ToggleGroup", "ToggleGroup")
    self.comToggleGroup_Transform = self:FindChildComponent(self._gameObject, "ToggleGroup", "Transform")

    self.comRankContent_Transform = self:FindChildComponent(self._gameObject, "SC_RankShow/Viewport/Content", "Transform")

    self:AddButtonClickListener(self.comClose_Button, function()
        RemoveWindowImmediately("HuaShanRankUI")
    end)

    self.toggleDisableColor = DRCSRef.Color(32 / 255,32 / 255, 32 / 255,1)
    self.toggleEnableColor = DRCSRef.Color(1,1,1,1)

    self:InitDataCache()
    self:InitToggles()
end

function HuaShanRankUI:SortTableKeys(tableData)
    local keys = {}

    if type(tableData) ~= 'table' then
        return keys
    end

    for key, value in pairs(tableData) do
        table.insert(keys, key)
    end

    table.sort(keys, function(keyA, keyB)
        return keyA < keyB
    end)

    return keys
end

function HuaShanRankUI:InitDataCache()
    local dataCache = {}

    for baseID, rankData in pairs(TableDataManager:GetInstance():GetTable("HuaShanRank")) do
        if rankData.VersionNameID ~= 0 and rankData.TypeNameID ~= 0 then
            local tableData = GetOrCreateInnerTable(dataCache, rankData.VersionNameID, rankData.TypeNameID)
            if tableData then
                table.insert(tableData, baseID)
            end
        end
    end

    self.dataCache = dataCache
end

function HuaShanRankUI:InitToggles()
    local versionNameIDs = self:SortTableKeys(self.dataCache)
    local isOnFlag = false

    RemoveAllChildren(self.comToggleGroup_Transform)

    for index, verNameID in ipairs(versionNameIDs) do
        local verName = GetLanguageByID(verNameID)

        if verName then
            local objToggleItem = CloneObj(self.objToggleTempalte, self.comToggleGroup_Transform)
            objToggleItem:SetActive(true)
            local objMark = self:FindChild(objToggleItem, "Background/Checkmark")
            local comToggleName_Text = self:FindChildComponent(objToggleItem, "Label", "Text")
            comToggleName_Text.text = verName

            local comToggle = objToggleItem:GetComponent("Toggle")
            if comToggle then
                local toggleCallBack = function(isOn)
                    objMark:SetActive(isOn)
                    if isOn then
                        comToggleName_Text.color = self.toggleEnableColor
                        self:SelectRank(verNameID)
                    else
                        comToggleName_Text.color = self.toggleDisableColor
                    end
                end

                comToggle.group = self.comToggleGroup
                self:RemoveToggleClickListener(comToggle)
                self:AddToggleClickListener(comToggle, toggleCallBack)
                
                if not isOnFlag then 
                    comToggle.isOn = true 
                    toggleCallBack(true)
                    isOnFlag = true
                else
                    comToggle.isOn = false
                    toggleCallBack(false)
                end
            end
        end
    end

end

function HuaShanRankUI:SelectRank(verNameID)
    if not verNameID then
        return
    end
    RemoveAllChildren(self.comRankContent_Transform)

    local typeNameIDs = self:SortTableKeys(self.dataCache[verNameID])
    if not typeNameIDs or #typeNameIDs == 0 then
        return
    end

    for _, typeNameID in ipairs(typeNameIDs) do
        local typeDataIDs = GetInnerTable(self.dataCache, verNameID, typeNameID)
        if typeDataIDs then
            local playerNameDesc = ""
            for index, rankDataID in ipairs(typeDataIDs) do
                local rankData = TableDataManager:GetInstance():GetTableData("HuaShanRank", rankDataID)
                if rankData then
                    if index == 1 then
                        playerNameDesc = rankData.PlayerName
                    else
                        playerNameDesc = playerNameDesc..'、'..rankData.PlayerName
                    end

                end
            end
            playerNameDesc = playerNameDesc..'\n'

            -- 排行类型标题
            local objLabelItem = CloneObj(self.objLabelTempalte, self.comRankContent_Transform)
            objLabelItem:GetComponent("Text").text = "【"..GetLanguageByID(typeNameID).."】"
            objLabelItem:SetActive(true)

            -- 玩家显示名
            local objContentItem = CloneObj(self.objContentTempalte, self.comRankContent_Transform)
            objContentItem:GetComponent("Text").text = playerNameDesc
            objContentItem:SetActive(true)
        end
    end
end

return HuaShanRankUI