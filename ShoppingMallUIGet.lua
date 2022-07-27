ShoppingMallUIGet = class('ShoppingMallUIGet', BaseWindow);

function ShoppingMallUIGet:ctor(info)
    self.bindBtnTable = {};

    self:SetGameObject(info.objGet);
end

function ShoppingMallUIGet:Init()
    self.RoleDataManager = RoleDataManager:GetInstance();
    self.ShoppingDataManager = ShoppingDataManager:GetInstance();

    --
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objList = self:FindChild(self._gameObject, 'List');

    --
    table.insert(self.bindBtnTable, self.objCloseBtn);

    --
    self:BindBtnCB();

end

function ShoppingMallUIGet:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);

        end
        self:CommonBind(self.bindBtnTable[i], _callback);

    end
end

function ShoppingMallUIGet:CommonBind(gameObject, callback)
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

function ShoppingMallUIGet:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    end
end

function ShoppingMallUIGet:OnClickCloseBtn(obj)
    self._gameObject:SetActive(false);
end

function ShoppingMallUIGet:RefreshUI()
    self:OnRefList();
end

function ShoppingMallUIGet:OnRefList()
    
    local shopData = self.ShoppingDataManager:GetFormatGetData();
    self.shopData = shopData;
    self.count = #(shopData);

    local lvSC = self.objList:GetComponent('LoopListView2');
    local scrollRect = self.objList:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Text');
            self:OnScrollChanged(obj.gameObject, index);
            return obj;
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.count, _func);
        else
            lvSC:SetListItemCount(self.count, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSC = lvSC;
    end
end

function ShoppingMallUIGet:OnScrollChanged(gameObject, index)
    gameObject:SetActive(true);
    self:SetItemSingle(gameObject, index);
end

function ShoppingMallUIGet:SetItemSingle(gameObject, index)
    local data = self.shopData[index + 1];
    
    if data then
        gameObject:GetComponent('Text').text = GetLanguageByID(data.LanguageID);
    end
end

function ShoppingMallUIGet:OnEnable()

end

function ShoppingMallUIGet:OnDisable()

end

function ShoppingMallUIGet:OnDestroy()
    if self.lvSC then
        self.lvSC.mOnGetItemByIndex = nil;
    end
end

return ShoppingMallUIGet;