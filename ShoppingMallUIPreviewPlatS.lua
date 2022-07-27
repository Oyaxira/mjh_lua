ShoppingMallUIPreviewPlatS = class('ShoppingMallUIPreviewPlatS', BaseWindow);

function ShoppingMallUIPreviewPlatS:ctor(info)
    self.bindBtnTable = {};

    self:SetGameObject(info.objPlatPreviewS);
end

function ShoppingMallUIPreviewPlatS:Init()
    self.RoleDataManager = RoleDataManager:GetInstance();
    self.ShoppingDataManager = ShoppingDataManager:GetInstance();
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance();

    --
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objPlat = self:FindChild(self._gameObject, 'Mask/Platform');
    self.objSpine = self:FindChild(self._gameObject, 'Spine');

    --
    table.insert(self.bindBtnTable, self.objCloseBtn);

    --
    self:BindBtnCB();

end

function ShoppingMallUIPreviewPlatS:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);

        end
        self:CommonBind(self.bindBtnTable[i], _callback);

    end
end

function ShoppingMallUIPreviewPlatS:CommonBind(gameObject, callback)
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

function ShoppingMallUIPreviewPlatS:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    end
end

function ShoppingMallUIPreviewPlatS:OnClickCloseBtn(obj)
    self._gameObject:SetActive(false);
end

function ShoppingMallUIPreviewPlatS:RefreshUI(info)
    self:OnRefSpineAndPlat(info);
end

function ShoppingMallUIPreviewPlatS:OnRefSpineAndPlat(info)
    local Local_TB_RoleModel = TableDataManager:GetInstance():GetTable("RoleModel");
    local modelID = self.PlayerSetDataManager:GetModelID();
    local modelData = Local_TB_RoleModel[modelID];
    local roleData = self.RoleDataManager:GetMainRoleData();
    if modelData then
        DynamicChangeSpine(self.objSpine, modelData.Model);
    end

    if info then
        self.objPlat:GetComponent('Image').sprite = GetSprite(info.ShowPath);
    end
end

function ShoppingMallUIPreviewPlatS:OnEnable()

end

function ShoppingMallUIPreviewPlatS:OnDisable()

end

function ShoppingMallUIPreviewPlatS:OnDestroy()

end

return ShoppingMallUIPreviewPlatS;