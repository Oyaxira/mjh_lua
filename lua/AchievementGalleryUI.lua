AchievementGalleryUI = class("AchievementGalleryUI",BaseWindow)

function AchievementGalleryUI:ctor()
    
end

function AchievementGalleryUI:Init(objParent, instParent)
    --初始化
    if not (objParent and instParent) then return end
    self.instParent = instParent
    self._gameObject_parent = objParent
    local obj = self:FindChild(objParent, "Achieve_box/Gallery")
    if obj then
        self:SetGameObject(obj)
    end


end

function AchievementGalleryUI:RefreshUI(info)
    if not info then return end
    
end

function AchievementGalleryUI:OnDestroy()
    
end

return AchievementGalleryUI