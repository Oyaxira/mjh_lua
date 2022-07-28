ForgeItemIconUI = class("ForgeItemIconUI", ItemIconUINew)

function ForgeItemIconUI:Create(kParent)
	local obj = LoadPrefabAndInit("ForgeUI/ForgeItemIconUI",kParent,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ForgeItemIconUI:Init()
    self.imgFrame = self:FindChildComponent(self._gameObject, "Frame","Image")
    self.imgHeirloom = self:FindChildComponent(self._gameObject, "Heirloom","Image")
    self.objEffect = self:FindChild(self._gameObject, "Effect")
    if  self.objEffect  then
        self.imgEffect = self.objEffect:GetComponent("Image")
        self.transEffect = self.objEffect:GetComponent("Transform")
    end
    self.imgIcon = self:FindChildComponent(self._gameObject, "Icon", "Image")
    self.textNum = self:FindChildComponent(self._gameObject, "Text_num", "Text")
    self.comRectTran = self._gameObject:GetComponent('RectTransform')
    self.objImg_true = self:FindChild(self._gameObject, "Img_true")
    self:SetDefaultClickListener()
end

function ForgeItemIconUI:InitCountInfo(iHaveCount,iMakeOneCount,iMakeCount)
    self.iHaveCount = iHaveCount
    self.iMakeOneCount = iMakeOneCount
    self.iMakeCount = iMakeCount
    self:RefreshStatus()
end

function ForgeItemIconUI:SetMakeCount(iMakeCount)
    self.iMakeCount = iMakeCount
    self:RefreshStatus()
end

function ForgeItemIconUI:RefreshStatus()
    if self.textNum then
        self.textNum.gameObject:SetActive(true)
        self.textNum.text = string.format( "%d/%d", self.iHaveCount, self.iMakeOneCount * self.iMakeCount)
    end

    if self.iHaveCount < self.iMakeOneCount * self.iMakeCount then
        setUIGray(self.imgIcon, true)
        self.objImg_true:SetActive(false)
        self.textNum.color = getUIColor("red")
    else
        setUIGray(self.imgIcon, false)
        self.objImg_true:SetActive(true)
        self.textNum.color = getUIColor("green")
    end
end


return ForgeItemIconUI