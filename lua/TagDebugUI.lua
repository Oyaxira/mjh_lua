TagDebugUI = class("TagDebugUI", BaseWindow)

function TagDebugUI:ctor()
end

function TagDebugUI:Create()
	local obj = LoadPrefabAndInit("DebugUI/TagDebugUI", Load_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function TagDebugUI:Init()    
    self.comLoopScroll = self:FindChildComponent(self._gameObject, 'TagList', 'LoopVerticalScrollRect')
    self.comLoopScroll:AddListener(function(...) 
        if self:IsOpen() then
            self:UpdateTagList(...)
        end
    end)
    self.comLoopScroll:RefreshCells()
    self.comLoopScroll:RefreshNearestCells()

    self.comCloseButton = self:FindChildComponent(self._gameObject, 'CloseButton', 'Button')
    self:AddButtonClickListener(self.comCloseButton, function() 
        RemoveWindowImmediately("TagDebugUI")
    end)

    self.comSearchInputField = self:FindChildComponent(self._gameObject, 'SearchText/Text', 'InputField')

    self.comSearchButton = self:FindChildComponent(self._gameObject, 'SearchButton', 'Button')
    self:AddButtonClickListener(self.comSearchButton, function() 
        self:SetSearchKey(self.comSearchInputField.text)
    end)
end

function TagDebugUI:RefreshUI()    
    self.comLoopScroll:RefreshCells()
    self.comLoopScroll:RefreshNearestCells()
end

function TagDebugUI:OnDestroy()
    self.comLoopScroll:RemoveListener()
end

function TagDebugUI:UpdateTagList(transform, index)
    local allTagList = TaskTagManager:GetInstance():GetAllTagList() or {}
    allTagList = self:ApplySearchKey(allTagList)
    local objTagInfo = transform.gameObject
    local tagData = allTagList[index]
    if tagData == nil then
        objTagInfo:SetActive(false)
        return
    end
    local comNameText = self:FindChildComponent(objTagInfo, 'Name', 'Text')
    local tagDesc = self:GetTagDescStr(tagData)
    comNameText.text = tagDesc
end

function TagDebugUI:GetTagDescStr(tagData)
    if type(tagData) ~= 'table' then 
        return ''
    end
    local tagDescStr = ''
    tagDescStr = tagDescStr .. 'ID(' .. tostring(tagData.uiID) .. ')'
    tagDescStr = tagDescStr .. ' BaseID(' .. tostring(tagData.uiTypeID) .. ')'
    tagDescStr = tagDescStr .. ' Value(' .. tostring(tagData.uiValue) .. ')'
    return tagDescStr
end

function TagDebugUI:SetSearchKey(searchKey)
    if searchKey == '' then 
        searchKey = nil
    end
    self.searchKey = searchKey
    self.comLoopScroll:RefreshCells()
    self.comLoopScroll:RefreshNearestCells()
end

function TagDebugUI:ApplySearchKey(allTagList)
    if type(allTagList) ~= 'table' then 
        return allTagList
    end
    local searchID = tonumber(self.searchKey)
    if searchID == nil then 
        return allTagList
    end
    local newAllTagList = {}
    for _, tagData in ipairs(allTagList) do
        if tagData.uiID == searchID or tagData.uiTypeID == searchID then 
            table.insert(newAllTagList, tagData)
        end
    end
    return newAllTagList
end

return TagDebugUI