CartoonUI = class("CartoonUI",BaseWindow)

function CartoonUI:ctor()

end

function CartoonUI:Create()
	local obj = LoadPrefabAndInit("Game/ComicUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function CartoonUI:Init()
    self.objNextButton = self:FindChildComponent(self._gameObject, 'Button_next', 'Button')
	if self.objNextButton then
		self:AddButtonClickListener(self.objNextButton,function()
			self:OnClickCartoon()
		end)
    end

    self.imgCartoonPic = self:FindChildComponent(self._gameObject, 'Image_comic', 'Image')

end

function CartoonUI:RefreshUI(cartoonInfo)
    self.curCartoonId = cartoonInfo.CartoonId
    if (self.curCartoonId == nil or self.curCartoonId == 0) then
        RemoveWindowImmediately("CartoonUI")
        return
    end

    local tableCartoon = TableDataManager:GetInstance():GetTableData("Cartoon",self.curCartoonId)
    if (tableCartoon == nil) then
        RemoveWindowImmediately("CartoonUI")
        return
    end

    self:RefreshCartoon(tableCartoon.PicPath)
end

function CartoonUI:OnClickCartoon()
    local tableCartoon = TableDataManager:GetInstance():GetTableData("Cartoon",self.curCartoonId)
    if (tableCartoon == nil) then
        RemoveWindowImmediately("CartoonUI")
        return
    end

    self.curCartoonId = tableCartoon.nextCartoon
    if (self.curCartoonId == nil or self.curCartoonId == 0) then
        RemoveWindowImmediately("CartoonUI")
        return
    end

    local nextTableCartoon = TableDataManager:GetInstance():GetTableData("Cartoon",self.curCartoonId)
    self:RefreshCartoon(nextTableCartoon.PicPath)
end

function CartoonUI:RefreshCartoon(picPath)
    self.imgCartoonPic.sprite = GetSprite(picPath)
end


return CartoonUI