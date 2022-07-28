AchievementForgeMakeUI = class("AchievementForgeMakeUI",BaseWindow)

function AchievementForgeMakeUI:ctor()
    
end

function AchievementForgeMakeUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self.instParent = instParent
    self._gameObject_parent = objParent
    local obj = self:FindChild(objParent, "Achieve_box/ForgeMake")
    if obj then
        self:SetGameObject(obj)
    end


end

function AchievementForgeMakeUI:RefreshUI(info)
    if not info then return end
    
end

function AchievementForgeMakeUI:OnDestroy()
    
end

return AchievementForgeMakeUI