AchievementTreasureUI = class("AchievementTreasureUI",BaseWindow)

function AchievementTreasureUI:ctor()
    
end

function AchievementTreasureUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self.instParent = instParent
    self._gameObject_parent = objParent
    local obj = self:FindChild(objParent, "Achieve_box/Treasure")
    if obj then
        self:SetGameObject(obj)
    end


end

function AchievementTreasureUI:RefreshUI(info)
    if not info then return end
    
end

function AchievementTreasureUI:OnDestroy()
    
end

return AchievementTreasureUI