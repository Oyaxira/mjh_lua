TreasureBookWarningBoxUI = class("TreasureBookWarningBoxUI",BaseWindow)
local l_DRCSRef_Type = DRCSRef_Type

function TreasureBookWarningBoxUI:Create()
	local obj = LoadPrefabAndInit("TownUI/TreasureBookWarningBoxUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function TreasureBookWarningBoxUI:Init()
    self.objRoot = self:FindChild(self._gameObject, "Box")
    self.textContent = self:FindChildComponent(self.objRoot, "Content/Text", l_DRCSRef_Type.Text)
    
    self.objBtns = self:FindChild(self.objRoot, "Btns")
    local btnCancel = self:FindChildComponent(self.objBtns, "Cancel", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnCancel, function()
        RemoveWindowImmediately("TreasureBookWarningBoxUI")
    end)
    local btnCancel2 = self:FindChildComponent(self._gameObject, "PopUpWindow_2/Board/Button_close", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnCancel2, function()
        RemoveWindowImmediately("TreasureBookWarningBoxUI")
    end)

    local btnConfirm = self:FindChildComponent(self.objBtns, "Confirm", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnConfirm, function()
        if not self.OnClickConfirm then
            return
        end
        self.OnClickConfirm()
        RemoveWindowImmediately("TreasureBookWarningBoxUI")
    end)
    self.objBtnTicket = self:FindChild(self.objBtns, "Ticket")
    local btnTicket = self.objBtnTicket:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnTicket, function()
        self:OnClickUseTicket()
    end)
    self.objTicketInfo = self:FindChild(self._gameObject, "Content/Ticket")
    self.textTicketName = self:FindChildComponent(self.objTicketInfo, "Title", l_DRCSRef_Type.Text)
    self.textTicketNum = self:FindChildComponent(self.objTicketInfo, "Num", l_DRCSRef_Type.Text)
end

function TreasureBookWarningBoxUI:RefreshUI(info)
    if not info then
        return
    end
    self.textContent.text = info.content or ""
    self.OnClickConfirm = info.callback
    self.objBtnTicket:SetActive(false)
    self.objTicketInfo:SetActive(false)
    if info.bForSelf then
        local uiTicketID, uiTicketNum = StorageDataManager:GetInstance():GetkTreasureBookTicketUID()
        if uiTicketNum and (uiTicketNum > 0) then
            self.objBtnTicket:SetActive(true)
            self.objTicketInfo:SetActive(true)
            self.textTicketNum.text = string.format("(%d / 1)", uiTicketNum)
        end
    end
end

function TreasureBookWarningBoxUI:OnClickUseTicket()
    TreasureBookDataManager:GetInstance():CheckAndUseTreasureBookTicket(false)
    RemoveWindowImmediately("TreasureBookWarningBoxUI")
end

function TreasureBookWarningBoxUI:OnDestroy()

end

return TreasureBookWarningBoxUI
