MemoriesUI = class('MemoriesUI',BaseWindow)

function MemoriesUI:ctor()
    self._tween = {}
    self.posList = {}
    self.lastText = {}
    self.speed = 100
    self.count = 0
end

function MemoriesUI:Create()
    local obj = LoadPrefabAndInit("CommonUI/MemoriesUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function MemoriesUI:Update()
    local canvas = self._gameObject:GetComponent("Canvas")
    if not canvas then
        return
    end

    if self.sortingOrder == nil then
        self.sortingOrder = canvas.sortingOrder
    end

    local setOrder = 0
    if IsWindowOpen("DialogChoiceUI") or IsWindowOpen("SelectUI") or IsWindowOpen("BlackBackgroundUI") then
        setOrder = 9999
    else
        setOrder = self.sortingOrder
    end

    if canvas.sortingOrder ~= setOrder then
        canvas.sortingOrder = setOrder
    end
end

return MemoriesUI