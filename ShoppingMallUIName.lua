ShoppingMallUIName = class('ShoppingMallUIName', BaseWindow);

local rankBaseID = '27';
local maxPage = 10;
local pageCount = 27;
local maxRankMember = 27 * 10;

function ShoppingMallUIName:ctor(info)
    self.bindBtnTable = {};
    self.pageIndex = 1;

    self:SetGameObject(info.objPlayerList);
end

function ShoppingMallUIName:Init()
    self.RoleDataManager = RoleDataManager:GetInstance();
    self.ShoppingDataManager = ShoppingDataManager:GetInstance();
    self.RankDataManager = RankDataManager:GetInstance();

    --
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objName = self:FindChild(self._gameObject, 'PlayerName');
    self.objContent = self:FindChild(self.objName, 'Content');
    self.objBot = self:FindChild(self._gameObject, 'bottom');
    self.objBotUpBtn = self:FindChild(self.objBot, 'Button_up');
    self.objBotDownBtn = self:FindChild(self.objBot, 'Button_down');

    --
    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objBotUpBtn);
    table.insert(self.bindBtnTable, self.objBotDownBtn);

    --
    self:BindBtnCB();

end

function ShoppingMallUIName:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);

        end
        self:CommonBind(self.bindBtnTable[i], _callback);

    end
end

function ShoppingMallUIName:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    elseif obj == self.objBotUpBtn then
        self:OnClickUpBtn(obj);
    
    elseif obj == self.objBotDownBtn then
        self:OnClickDownBtn(obj);

    end
end

function ShoppingMallUIName:OnClickUpBtn(obj)
    local rankPage = self.rankPage[rankBaseID];
    if rankPage and rankPage > 1 and self.pageIndex and self.pageIndex > 1 then
        self.pageIndex = self.pageIndex - 1;
        local cacheData = RankDataManager:GetInstance():GetRankCacheData(rankBaseID);
        self:OnRefList(cacheData);
    else
        SystemUICall:GetInstance():Toast('已经到顶了');
    end
end

function ShoppingMallUIName:OnClickDownBtn(obj)
    local rankPage = self.rankPage[rankBaseID];
    if rankPage and rankPage < maxPage and self.pageIndex and self.pageIndex < maxPage then
        local totalCount = RankDataManager:GetInstance():GetTotalCount();
        local cacheData = RankDataManager:GetInstance():GetRankCacheData(rankBaseID);
        self.pageIndex = self.pageIndex + 1;
        if self.pageIndex > rankPage then
            if totalCount > cacheData.total then
                NetCommonRank:QueryRank(rankBaseID, self.pageIndex, pageCount, nil, nil, nil, nil, nil, maxRankMember);
            else
                self.pageIndex = self.pageIndex - 1;
                SystemUICall:GetInstance():Toast('已经到底了');
            end
        else
            self:OnRefList(cacheData);
        end
    else
        SystemUICall:GetInstance():Toast('已经到底了');
    end
end

function ShoppingMallUIName:OnClickCloseBtn(obj)
    self._gameObject:SetActive(false);
end

function ShoppingMallUIName:RefreshUI()
    self.rankPage = {};
    self.pageIndex = 1;
    self.rankPage[rankBaseID] = 0;
    self.objContent:SetActive(false);
    RankDataManager:GetInstance():ResetRankDataByID(rankBaseID);
    NetCommonRank:QueryRank(rankBaseID, self.pageIndex, pageCount, nil, nil, nil, nil, nil, maxRankMember);
end

function ShoppingMallUIName:SetRankPage()
    if not self.rankPage[rankBaseID] then
        self.rankPage[rankBaseID] = 0;
    end
    self.rankPage[rankBaseID] = self.rankPage[rankBaseID] + 1;
end

function ShoppingMallUIName:OnRefList(info)
    if not info then
        return;
    end
    
    if self.pageIndex > self.rankPage[rankBaseID] then
        return;
    end

    for i = 1, pageCount do
        local objItem = self.objContent.transform:GetChild(i - 1);
        local memberIndex = (self.pageIndex - 1) * pageCount + i;
        if info.members[memberIndex] then
            objItem.gameObject:SetActive(true);
            self:FindChildComponent(objItem.gameObject, 'Text', 'Text').text = info.members[memberIndex].metadata;
            self:FindChildComponent(objItem.gameObject, 'Name', 'Text').text = info.members[memberIndex].score[1];
        else
            objItem.gameObject:SetActive(false);
        end
    end

    self.objContent:SetActive(true);
end

function ShoppingMallUIName:OnEnable()
    self:AddEventListener('ONEVENT_REF_RANKUI', function(info)
        if self._gameObject.activeSelf then
            self:SetRankPage();
            self:OnRefList(info);
        end
    end);
end

function ShoppingMallUIName:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_RANKUI');
end

function ShoppingMallUIName:OnDestroy()
end

return ShoppingMallUIName;