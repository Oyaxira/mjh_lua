TreasureBookActivityAdUI = class("TreasureBookActivityAdUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type

function TreasureBookActivityAdUI:Create()
	local obj = LoadPrefabAndInit("TownUI/TreasureBookActivityAdUI",Load_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function TreasureBookActivityAdUI:Init()
    self.objAD = self:FindChild(self._gameObject, "AD")
    self.comTwn = self.objAD:GetComponent(l_DRCSRef_Type.DOTweenAnimation)

    local btnGoTo = self:FindChildComponent(self.objAD, "GoTo", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnGoTo, function()
        self:OnClickGoTo()
    end)

    local btnEnter = self:FindChildComponent(self.objAD, "Enter", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnEnter, function()
        self:OnClickEnter()
    end)

    local btnClose = self:FindChildComponent(self.objAD, "Button_close", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnClose, function()
        self:OnClickEnter()
    end)
end

function TreasureBookActivityAdUI:RefreshUI()
    self.comTwn:DOPlay()
end

-- 点击跳转到活动页面
function TreasureBookActivityAdUI:OnClickGoTo()
    OpenWindowImmediately("ActivityUI", {["type"] = ActivityType.ACCT_TreasureBookBuyGift})
    RemoveWindowImmediately("TreasureBookActivityAdUI", false)
end

-- 点击进入百宝书
function TreasureBookActivityAdUI:OnClickEnter()
    OpenWindowImmediately("TreasureBookUI")
    RemoveWindowImmediately("TreasureBookActivityAdUI", false)
end

return TreasureBookActivityAdUI
