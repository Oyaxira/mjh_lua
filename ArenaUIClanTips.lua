ArenaUIClanTips = class('ArenaUIClanTips', BaseWindow);

function ArenaUIClanTips:ctor()

end

function ArenaUIClanTips:Create()
	local obj = LoadPrefabAndInit('TipsUI/ClanArenaTipUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function ArenaUIClanTips:Init()

    --
    self.objRaycast = self:FindChild(self._gameObject, 'raycast');
    AddEventTrigger(self.objRaycast, function()
        RemoveWindowImmediately("ArenaUIClanTips");
    end)

    self.comName = self:FindChildComponent(self._gameObject, 'name', 'Text');
    self.comText1 = self:FindChildComponent(self._gameObject, 'rule/Text_1', 'Text');

end

function ArenaUIClanTips:RefreshUI(info)
    if info then
        self.comName.text = info.title;
        self.comText1.text = info.content;
    end
end

function ArenaUIClanTips:OnDisable()

end

function ArenaUIClanTips:OnEnable()

end

function ArenaUIClanTips:OnDestroy()

end

return ArenaUIClanTips;