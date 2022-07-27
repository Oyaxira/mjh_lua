SystemTipManager = class("SystemTipManager")
SystemTipManager._instance = nil

function SystemTipManager:GetInstance()
    if SystemTipManager._instance == nil then
        SystemTipManager._instance = SystemTipManager.new()
    end

    return SystemTipManager._instance
end

function SystemTipManager:ResetManager()
    self.popupTipList = nil
    self.rollTipList = nil
    self.isShowingRoll = nil
end

function SystemTipManager:AddPopupTip(content)
    self.popupTipList = self.popupTipList or {}
    table.insert(self.popupTipList, content)
    if not self:isShowingPopup() then 
        self.bShowingPopup = true
        -- FIXME: 如果切换场景, 会导致正在显示的提示丢失
        self:ShowNextPopupTip()
    end
end

function SystemTipManager:ClearPopupTipList()
    self.popupTipList = {}
    self.bShowingPopup = false
end

function SystemTipManager:ShowNextPopupTip()
    if self.popupTipList == nil or #self.popupTipList == 0 then 
        self.bShowingPopup = false
        return 
    end
    local content = table.remove(self.popupTipList, 1)
    OpenWindowImmediately('GeneralBoxUI',{GeneralBoxType.SYSTEM_TIP_NEXT, content})
end

function SystemTipManager:isShowingPopup()
    return self.bShowingPopup == true
    -- return IsWindowOpen('GeneralBoxUI')
end

function SystemTipManager:AddRollTip(content)
    self.rollTipList = self.rollTipList or {}
    table.insert(self.rollTipList, content)
    if not self.isShowingRoll then 
        self:ShowNextRollTip()
    end
end

function SystemTipManager:ShowNextRollTip()
    self.isShowingRoll = true
    if self.rollTipList == nil or #self.rollTipList == 0 then 
        self.isShowingRoll = false
        return false
    end
    local content = table.remove(self.rollTipList, 1)
    OpenWindowImmediately('RollTipUI', content)
    return true
end

function AddPopupTip(content)
    return SystemTipManager:GetInstance():AddPopupTip(content)
end