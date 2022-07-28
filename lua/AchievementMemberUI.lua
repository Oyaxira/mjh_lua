AchievementMemberUI = class("AchievementMemberUI",BaseWindow)

function AchievementMemberUI:ctor()
    
end

function AchievementMemberUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self.instParent = instParent
    self._gameObject_parent = objParent
    local obj = self:FindChild(objParent, "Achieve_box/Member")
    if obj then
        self:SetGameObject(obj)
    end


end

function AchievementMemberUI:RefreshUI(info)
    if not info then return end
    
end

function AchievementMemberUI:OnDestroy()
    
end

return AchievementMemberUI