RulePopUI = class("RulePopUI",BaseWindow)

function RulePopUI:ctor()

end

function RulePopUI:Create()
	local obj = LoadPrefabAndInit("TipsUI/RulePopUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function RulePopUI:Init()
    self.comBGButton = self:FindChildComponent(self._gameObject, 'G_BgBtn', 'Button')
    self.comNameText = self:FindChildComponent(self._gameObject, 'G_Name', 'Text')
    self.comContentText = self:FindChildComponent(self._gameObject, 'G_Content', 'Text')
    self.objRoot = self:FindChild(self._gameObject, 'root')

    self:AddButtonClickListener(self.comBGButton, function()
        RemoveWindowImmediately("RulePopUI", false)
    end)
end

function RulePopUI:RefreshUI(info)
    local desid = info.desid
    local des = info.des
    local pivotx = info.pivotx
    local pivoty = info.pivoty
    local posx = info.posx
    local posy = info.posy

    local rectTransform = self.objRoot:GetComponent("RectTransform")
    rectTransform.pivot = DRCSRef.Vec2(pivotx, pivoty)
    rectTransform.position = DRCSRef.Vec3(posx, posy, rectTransform.position.z)
    local itemDes

    if des == nil and desid ~= nil then
        itemDes = GetLanguageByID(desid)  
    else
        itemDes = des
    end
     
    if self.comContentText then
        self.comContentText.text = itemDes or ""
    end
end

function RulePopUI:RefreshInfo(info)
    local des = info.des
    local pivotx = info.pivotx
    local pivoty = info.pivoty
    local posx = info.posx
    local posy = info.posy

    local rectTransform = self.objRoot:GetComponent("RectTransform")
    rectTransform.pivot = DRCSRef.Vec2(pivotx, pivoty)
    rectTransform.position = DRCSRef.Vec3(posx, posy, rectTransform.position.z)

    if self.comContentText then
        self.comContentText.text = des or ""
    end
end


function RulePopUI:OnDestroy()
	
end

return RulePopUI