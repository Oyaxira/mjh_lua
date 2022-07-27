LittlePacketUI = class('LittlePacketUI', BaseWindow);

function LittlePacketUI:ctor()
    self.bindBtnTable = {};
    self.btnTable = {};
end

function LittlePacketUI:Create()
	local obj = LoadPrefabAndInit('MoneyPacketUI/LittlePacketUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function LittlePacketUI:Init()

    self.MoneyPacketDataManager = MoneyPacketDataManager:GetInstance();

    --
    self.objLayout = self:FindChild(self._gameObject, 'TransformAdapt_node_left/Layout');

    for k, v in pairs(self.objLayout.transform) do
        table.insert(self.btnTable, v.gameObject);
        table.insert(self.bindBtnTable, v.gameObject);
        v.gameObject:SetActive(false);
    end

    --
    self:BindBtnCB();

end

function LittlePacketUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);

        end
        self:CommonBind(self.bindBtnTable[i], _callback);

    end
end

function LittlePacketUI:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent('Button');
    local tog = gameObject:GetComponent('Toggle');
    if btn then
        local _callback = function()
            callback(gameObject);
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback);

    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide);
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback)

    end

end

function LittlePacketUI:OnclickBtn(obj, boolHide)
    if obj.transform.parent.gameObject == self.objLayout then
        self:OnClickPacket(obj);
    end
end

function LittlePacketUI:OnClickPacket(obj)
    local index = obj.transform:GetSiblingIndex();
    local packetData = self.MoneyPacketDataManager:GetPacketData();
    if packetData[index + 1] then
        local tempT = {};
        tempT.showType = 2;
        tempT.data = packetData[index + 1];
        OpenWindowImmediately("MoneyPacketUI", tempT);
    end
end

function LittlePacketUI:RefreshUI()
    self:OnRefPacket();
end

function LittlePacketUI:OnRefPacket()
    local packetData = self.MoneyPacketDataManager:GetPacketData();
    for i = 1, #(self.btnTable) do
        if i <= #(packetData) then
            self.btnTable[i]:SetActive(true);
        else
            self.btnTable[i]:SetActive(false);
        end
    end
end

function LittlePacketUI:OnDisable()

end

function LittlePacketUI:OnEnable()

end

function LittlePacketUI:OnDestroy()

end

return LittlePacketUI;