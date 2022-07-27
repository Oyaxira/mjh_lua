AchievementPetUI = class("AchievementPetUI",BaseWindow)

function AchievementPetUI:ctor()
    
end

function AchievementPetUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self.instParent = instParent
    self._gameObject_parent = objParent
    local obj = self:FindChild(objParent, "Achieve_box/Pet")
    if obj then
        self:SetGameObject(obj)
    end


end

function AchievementPetUI:RefreshUI(info)
    if not info then return end
    
end

function AchievementPetUI:OnDestroy()
    
end

return AchievementPetUI