RollTipUI = class("RollTipUI",BaseWindow)

function RollTipUI:ctor()
end

function RollTipUI:Create()
	local obj = LoadPrefabAndInit("TipsUI/RollTipUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function RollTipUI:Init()
    self.comContentText = self:FindChildComponent(self._gameObject, 'Text', 'Text')
    self.comTextRectTransform = self.comContentText.gameObject:GetComponent('RectTransform')
end

function RollTipUI:ShowTip(content)
    self.comContentText.text = content
    self:ResetTextPosition()
    self:AddTimer(300, function() self:PlayRollAnim() end, 1)
end

function RollTipUI:PlayRollAnim()
    local width = self:GetTextWidth()
    local action = self.comTextRectTransform.gameObject.transform:DOLocalMoveX(-width - 640, 10)
    action:SetEase(CS.DG.Tweening.Ease.Linear)
    action:OnComplete(function()
        if not SystemTipManager:GetInstance():ShowNextRollTip() then 
            RemoveWindowImmediately("RollTipUI", true) 
        end
    end)
end

function RollTipUI:ResetTextPosition()
    local y = self.comTextRectTransform.gameObject.transform.localPosition.y
    self.comTextRectTransform.gameObject.transform.localPosition = DRCSRef.Vec3(640, y, 0)
end

function RollTipUI:GetTextWidth()
    return self.comTextRectTransform.rect.width
end

function RollTipUI:OnDestroy()
end

function RollTipUI:RefreshUI(content)
    self:ShowTip(content)
end

return RollTipUI