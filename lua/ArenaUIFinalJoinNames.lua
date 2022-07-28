ArenaUIFinalJoinNames = class('ArenaUIFinalJoinNames', BaseWindow);

local Type = {
    DaShi = 1,
    MenPai = 2,
}

local rankMemberCount = 32;

function ArenaUIFinalJoinNames:ctor(info)
    self._script = info;
    self.bindBtnTable = {};
end

function ArenaUIFinalJoinNames:Create()
    local obj = LoadPrefabAndInit('ArenaUI/FinalJoinNames', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function ArenaUIFinalJoinNames:Init()
    self.ArenaDataManager = ArenaDataManager:GetInstance();
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance();

    --
    self.objImageMask = self:FindChild(self._gameObject, 'Image_Mask');
    self.objSCNames = self:FindChild(self._gameObject, 'SC_Names');
    self.objSCNamesContent = self:FindChild(self.objSCNames, 'Viewport/Content');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objTextTop1 = self:FindChild(self._gameObject, 'Image_Top/Text_Top_1');
    self.objTextTop2 = self:FindChild(self._gameObject, 'Image_Top/Text_Top_2');
    self.objTextTop3 = self:FindChild(self._gameObject, 'Image_Top/Text_Top_3');

    --
    table.insert(self.bindBtnTable, self.objImageMask);
    table.insert(self.bindBtnTable, self.objCloseBtn);

    self:BindBtnCB();

end

function ArenaUIFinalJoinNames:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUIFinalJoinNames:OnclickBtn(obj, boolHide)
    if obj == self.objImageMask or obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    end
end

function ArenaUIFinalJoinNames:OnClickCloseBtn(obj)
    RemoveWindowImmediately('ArenaUIFinalJoinNames');
end

function ArenaUIFinalJoinNames:OnRefDaShiSCNames(info)
    
    if not info then
        return;
    end

    RemoveAllChildren(self.objSCNamesContent);
    for i = 1, 32 do
        if info[i] then
            local objItem = LoadPrefabAndInit('ArenaUI/Item_Name', self.objSCNamesContent, true);
            if objItem then
                objItem:GetComponent('Text').text = info[i].acPlayerName;
                if info[i].defPlayerID == globalDataPool:getData('PlayerID') then
                    self:FindChild(objItem, 'self_mark'):SetActive(true);
                else
                    self:FindChild(objItem, 'self_mark'):SetActive(false);
                end
            end
        end
    end

end

function ArenaUIFinalJoinNames:OnRefMenPaiSCNames(info)
    
    if not info then
        return;
    end
    
    RemoveAllChildren(self.objSCNamesContent);
    for i = 1, 32 do
        if info.members and info.members[i] then
            local objItem = LoadPrefabAndInit('ArenaUI/Item_Name', self.objSCNamesContent, true);
            if objItem then
                objItem:GetComponent('Text').text = info.members[i].metadata;
                if info.members[i].member == globalDataPool:getData('PlayerID') then
                    self:FindChild(objItem, 'self_mark'):SetActive(true);
                else
                    self:FindChild(objItem, 'self_mark'):SetActive(false);
                end
            end
        end
    end
end

function ArenaUIFinalJoinNames:RefreshUI(data)
    self.objSCNamesContent:SetActive(false);
    if data and data.data then
        self.objTextTop1:SetActive(data.type == Type.DaShi);
        self.objTextTop2:SetActive(data.type == Type.MenPai);
        self.objTextTop3:SetActive(data.type == Type.MenPai);

        if data.type == Type.DaShi then
            SendRequestArenaMatchOperate(ARENA_REQUEST_SIGNUP_MEMBER_NAME, data.data.dwMatchType, data.data.dwMatchID);
        elseif data.type == Type.MenPai then
            NetCommonRank:QueryRank(tostring(data.tbData.ClanRankID), 1, rankMemberCount);
        end
    end
end

function ArenaUIFinalJoinNames:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_FINALJOINNAME');
    self:RemoveEventListener('ONEVENT_REF_RANKUI');
end

function ArenaUIFinalJoinNames:OnEnable()
    self:AddEventListener('ONEVENT_REF_FINALJOINNAME', function(info)
        self.objSCNamesContent:SetActive(true);
        self:OnRefDaShiSCNames(info);
    end);
    self:AddEventListener('ONEVENT_REF_RANKUI', function(info)
        self.objSCNamesContent:SetActive(true);
        self:OnRefMenPaiSCNames(info);
    end);
end

function ArenaUIFinalJoinNames:OnDestroy()

end

return ArenaUIFinalJoinNames;