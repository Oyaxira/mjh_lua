ActionDebugUI = class("ActionDebugUI", BaseWindow)

function ActionDebugUI:ctor()
end

function ActionDebugUI:Create()
	local obj = LoadPrefabAndInit("DebugUI/ActionDebugUI", Load_Layer, true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ActionDebugUI:Init()    
    self.comLoopScroll = self:FindChildComponent(self._gameObject, 'ActionList', 'LoopVerticalScrollRect')
    self.comLoopScroll:AddListener(function(...) 
        if self:IsOpen() then
            self:UpdateActionList(...)
        end
    end)
    self.comLoopScroll:RefreshCells()
    self.comLoopScroll:RefreshNearestCells()

    self.comCloseButton = self:FindChildComponent(self._gameObject, 'CloseButton', 'Button')
    self:AddButtonClickListener(self.comCloseButton, function() 
        RemoveWindowImmediately("ActionDebugUI")
    end)
    
    self.comResetButton = self:FindChildComponent(self._gameObject, 'ResetButton', 'Button')
    self:AddButtonClickListener(self.comResetButton, function() 
        CheatDataManager:GetInstance():ClearHistoryActionList()
        self.comLoopScroll:RefreshCells()
        self.comLoopScroll:RefreshNearestCells()
    end)

    self.comActionDetailText = self:FindChildComponent(self._gameObject, 'ActionDetail/Text', 'Text')
    self.comActionDetailText.text = ''
end

function ActionDebugUI:RefreshUI()    
end

function ActionDebugUI:OnDestroy()
    self.comLoopScroll:RemoveListener()
end

function ActionDebugUI:UpdateActionList(transform, index)
    local allActionList = CheatDataManager:GetInstance():GetAllActionList() or {}
    local objActionInfo = transform.gameObject
    local actionIndex = #allActionList - index
    local action = allActionList[#allActionList - index]
    if action == nil then
        objActionInfo:SetActive(false)
        return
    end

    local curAction = DisplayActionManager:GetInstance():GetCurAction()

    local comButton = self:FindChildComponent(objActionInfo, 'Button', 'Button')
    self:RemoveButtonClickListener(comButton)
    self:AddButtonClickListener(comButton, function() 
        self:ShowActionDetail(action, actionIndex)
    end)

    local comNameText = self:FindChildComponent(objActionInfo, 'Name', 'Text')
    if curAction == action then 
        comNameText.color = UI_COLOR['red']
    else
        comNameText.color = UI_COLOR['black']
    end
    local actionDesc = self:GetActionTypeStr(action, actionIndex)
    comNameText.text = actionDesc
end

function ActionDebugUI:ShowActionDetail(action, actionIndex)
    local detailStr = ''
    detailStr = detailStr .. 'Action类型:\n\t' .. self:GetActionTypeStr(action, actionIndex) .. '\n'
    for index, value in ipairs(action.params) do 
        detailStr = detailStr .. '[' .. index .. ']:\n\t' .. tostring(value) .. '\n'
    end
    self.comActionDetailText.text = detailStr
end

function ActionDebugUI:GetActionTypeStr(action, actionIndex)
    local actionTypeStr = 'NO.' .. tostring(actionIndex) .. ' '
    local actionType = action.actionType
    if actionType == nil then 
        actionTypeStr = actionTypeStr .. 'nil(nil)'
    else
        actionTypeStr = actionTypeStr .. (DisplayActionType_Revert[actionType] or '') .. '(' .. actionType .. ')'
    end
    return actionTypeStr
end

return ActionDebugUI