ServerAndUIDUI = class('ServerAndUIDUI', BaseWindow)

function ServerAndUIDUI:ctor()

end

function ServerAndUIDUI:Create()
    local obj = LoadPrefabAndInit("CommonUI/ServerAndUIDUI", TIPS_Layer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function ServerAndUIDUI:Init()
    self.DontDestroy = true;
    self.comText = self:FindChildComponent(self._gameObject, 'Text', 'Text');

end

function ServerAndUIDUI:RefreshUI()
    self.comText.text = "UID : " .. string.format("%u",G_UID or 1)
end

return ServerAndUIDUI;