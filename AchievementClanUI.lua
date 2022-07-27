AchievementClanUI = class("AchievementClanUI",BaseWindow)

function AchievementClanUI:ctor()
    
end

function AchievementClanUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self.instParent = instParent
    self._gameObject_parent = objParent
    local obj = self:FindChild(objParent, "Achieve_box/Clan")
    if obj then
        self:SetGameObject(obj)
    end


end

function AchievementClanUI:RefreshUI(info)
    if not info then return end
    
end

function AchievementClanUI:OnDestroy()
    
end

return AchievementClanUI