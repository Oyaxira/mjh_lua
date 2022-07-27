ShoppingMallUIPreviewPlatB = class('ShoppingMallUIPreviewPlatB', BaseWindow);

function ShoppingMallUIPreviewPlatB:ctor(info)
    self.bindBtnTable = {};
    self.spineTable = {};

    self:SetGameObject(info.objPlatPreviewB);
end

function ShoppingMallUIPreviewPlatB:Init()
    self.RoleDataManager = RoleDataManager:GetInstance();
    self.ShoppingDataManager = ShoppingDataManager:GetInstance();
    self.TableDataManager = TableDataManager:GetInstance();
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance();

    --
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objSpine = self:FindChild(self._gameObject,"Spine")
    self.objBigGround = self:FindChild(self.objSpine,"Image_BigGround")

    self.objRole1 = self:FindChild(self.objSpine,"Role_spine (1)")
    self.objRole2 = self:FindChild(self.objSpine,"Role_spine (2)")
    self.objRole3 = self:FindChild(self.objSpine,"Role_spine (3)")
    self.objRole4 = self:FindChild(self.objSpine,"Role_spine (4)")
    self.objRole5 = self:FindChild(self.objSpine,"Role_spine (5)")

    table.insert(self.spineTable, self.objRole1);
    table.insert(self.spineTable, self.objRole2);
    table.insert(self.spineTable, self.objRole3);
    table.insert(self.spineTable, self.objRole4);
    table.insert(self.spineTable, self.objRole5);

    --
    table.insert(self.bindBtnTable, self.objCloseBtn);

    --
    self:BindBtnCB();

end

function ShoppingMallUIPreviewPlatB:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);

        end
        self:CommonBind(self.bindBtnTable[i], _callback);

    end
end

function ShoppingMallUIPreviewPlatB:CommonBind(gameObject, callback)
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

function ShoppingMallUIPreviewPlatB:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    end
end

function ShoppingMallUIPreviewPlatB:OnClickCloseBtn(obj)
    self._gameObject:SetActive(false);
end

function ShoppingMallUIPreviewPlatB:RefreshUI(info)
    self:OnRefSpineAndPlat(info);
end

function ShoppingMallUIPreviewPlatB:OnRefSpineAndPlat(info)
    local platTeamInfo = globalDataPool:getData('PlatTeamInfo');
    local akRoleEmbattle = self.RoleDataManager:GetRoleEmbattleInfo();
    local Local_TB_RoleModel = self.TableDataManager:GetTable("RoleModel")
    local team = {};
    if akRoleEmbattle[EmBattleSchemeType.EBST_Team] then
        team = akRoleEmbattle[EmBattleSchemeType.EBST_Team][1];
    end
    if platTeamInfo then
        local mainRoleID = platTeamInfo.dwMainRoleID;
        if platTeamInfo.dwMainRoleID == 0 then
            platTeamInfo.dwMainRoleID = 1;
        end

        if next(team) then
            -- TODO 主角排在中间
            local sortTeam = {};
            for i = 1, #(team) do
                if team[i].uiRoleID == mainRoleID then
                    table.insert(sortTeam, 1, team[i]);
                else
                    table.insert(sortTeam, team[i]);
                end
            end
    
            for i = 1, #(self.spineTable) do
                if sortTeam[i] then
                    local roleData = self.RoleDataManager:GetRoleData(sortTeam[i].uiRoleID);
                    local strName = self.RoleDataManager:GetRoleTitleAndName(sortTeam[i].uiRoleID);
                    if roleData then
                        local modelData = Local_TB_RoleModel[roleData.uiModelID];
                        if modelData then
                            local spine = self:FindChild(self.spineTable[i], 'Spine_node/Spine');
                            DynamicChangeSpine(spine, modelData.Model);
                        end

                        self.spineTable[i]:SetActive(true);
                    else
                        self.spineTable[i]:SetActive(false);
                    end
                else
                    self.spineTable[i]:SetActive(false);
                end
            end
        end
    end

    if not next(team) then
        for i = 2, #(self.spineTable) do
            self.spineTable[i]:SetActive(false);
        end

        local modelID = self.PlayerSetDataManager:GetModelID();
        local modelData = Local_TB_RoleModel[modelID];
        if modelData then
            DynamicChangeSpine(self.spineTable[1], modelData.Model);
        end
        self.spineTable[1]:SetActive(true);
    end

    if info then
        self.objBigGround:GetComponent('Image').sprite = GetSprite(info.ShowPath);
    end
end

function ShoppingMallUIPreviewPlatB:OnEnable()

end

function ShoppingMallUIPreviewPlatB:OnDisable()

end

function ShoppingMallUIPreviewPlatB:OnDestroy()

end

return ShoppingMallUIPreviewPlatB;