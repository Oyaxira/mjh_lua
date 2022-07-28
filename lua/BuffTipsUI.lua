BuffTipsUI = class("BuffTipsUI",BaseWindow)

function BuffTipsUI:Create()
	local obj = LoadPrefabAndInit("Role/BuffTipsUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end

    self:UpdateData()
end

function BuffTipsUI:Init()
    self.comClose = self:FindChildComponent(self._gameObject, "close", "Button")
    self.comName = self:FindChildComponent(self._gameObject, "name", "Text")
    self.comDes = self:FindChildComponent(self._gameObject, "des", "Text")

    if self.comClose then
    self:RemoveButtonClickListener(self.comClose)
		self:AddButtonClickListener(self.comClose, function()
      RemoveWindowImmediately("BuffTipsUI",true)
		end)
    end
end

function BuffTipsUI:RefreshUI(info)
    buffID,iLayer,pos = table.unpack(info)
    local buffdata = TableDataManager:GetInstance():GetTableData("Buff", buffID)
    if buffdata == nil then
        return
    end

    self.comName.text = string.format("%s,(%d层)", GetLanguageByID(buffdata.NameID) ,iLayer)
    self.comDes.text = GetLanguageByID(buffdata.DescID)

    if  pos ~= nil then
       self:SetPos(pos)
    end
end

function BuffTipsUI:SetPos(pos)
    self.comRect = self:FindChildComponent(self._gameObject, "Root", "RectTransform")
    self.comRect:SetTransAnchoredPosition(pos.x, pos.y -720)
end

function BuffTipsUI:OnEnable()
end

function BuffTipsUI:OnDisable()
end

function BuffTipsUI:OnDestroy()
end

function BuffTipsUI:UpdateData()
end

return BuffTipsUI