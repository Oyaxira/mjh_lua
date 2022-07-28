ResultUI6 = class('ResultUI6', BaseWindow)

local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI';

local TYPE = {
    OUT = 1,        -- 带出
    RECYCLE = 2,    -- 回收
}

local outTips = {
    title = '带出规则',
    content = GetLanguageByID(560),
}

local covTips = {
    title = '转化规则',
    content = GetLanguageByID(560),
}

function ResultUI6:ctor(obj)
    self._scriptUI = obj;
    self._gameObject = obj.objResultUI6;
    self.ItemInfoUI = ItemInfoUI.new();

    self.bindBtnTable = {};
    self.mornalMsgInited = false;
    self.totleCount = 6;
end

function ResultUI6:Init()
    self.objImage = self:FindChild(self._gameObject, 'Image');
    self.objScrollView = self:FindChild(self._gameObject, 'Scroll View');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objImageTips = self:FindChild(self._gameObject, 'Image_Tips');

    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objImageTips);

    self:BindBtnCB();

end

function ResultUI6:RefreshUI(info)
    self.info = info;
    self:OnRefSC(info);
end

function ResultUI6:OnRefSC(info)
    local comText = self:FindChildComponent(self.objImage, 'Text', 'Text');
    local comTips = self:FindChildComponent(self.objImageTips, 'Text', 'Text');
    if info.type == TYPE.OUT then
        comText.text = '带出物品';
        comTips.text = '带出规则';
    elseif info.type == TYPE.RECYCLE then
        comText.text = '转化物品';
        comTips.text = '转化规则';
    end

    self.count = math.ceil(#(info.data) / 4);
    self.scCount = self.count < 6 and 6 or self.count;
    self.mod = #(info.data) % 4;

    self.data = info.data;
    local lvSC = self.objScrollView:GetComponent('LoopListView2');
    local scrollRect = self.objScrollView:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            dprint('index : ' .. index)

            local obj = item:NewListViewItem('Item_ResultUI6');

            self:OnScrollChanged(obj.gameObject, index);

            local _func;
            _func = function(gameObject, uiObjArray)
    
                local csf = gameObject:GetComponent('ContentSizeFitter');
                if csf then
                    table.insert(uiObjArray, gameObject);
                end
                
                for k, v in pairs(gameObject.transform) do
                    _func(v.gameObject, uiObjArray);
                end
            end
    
            local uiObjArray = {};
            _func(obj, uiObjArray);
            for i = #(uiObjArray), 1, -1 do
                local rtf = uiObjArray[i]:GetComponent('RectTransform');
                DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf);
            end
    
            return obj;
        end
        
        local _func1 = function()
            dprint('_func1~~~~~~~~~~~~~~~~~~~')
        end

        local _func2 = function()
            dprint('_func2~~~~~~~~~~~~~~~~~~~')
        end
        
        local _func3 = function()
            dprint('_func3~~~~~~~~~~~~~~~~~~~')

            if scrollRect.verticalNormalizedPosition > 0 then

                dprint('self.isLock = true');
            else

                dprint('self.isLock = false');
            end
        end
        
        if not self.mornalMsgInited then
            self.mornalMsgInited = true;
            lvSC:InitListView(self.scCount, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.scCount, false);
            lvSC:RefreshAllShownItem();
        end 
    end

    self.lvSC = lvSC;
end

function ResultUI6:OnScrollChanged(gameObject, idx)
    if idx == (self.count - 1) then
        for i = 0, 3 do
            local child = gameObject.transform:GetChild(i);
            if i < self.mod or self.mod == 0 then
                child.gameObject:SetActive(true);
                local dataIndex = (idx * 4) + (i + 1);
                local itemData = ItemDataManager:GetInstance():GetItemData(self.data[dataIndex].itemUID)
                self.ItemInfoUI:UpdateUIWithItemInstData(child.gameObject, itemData);
            else
                self.ItemInfoUI:SetItemUIActiveState(child.gameObject, false);
            end
        end
    else
        if self.count < 6 then
            if idx > (self.count - 1) and idx < self.totleCount then
                for i = 0, 3 do
                    local child = gameObject.transform:GetChild(i);
                    self.ItemInfoUI:SetItemUIActiveState(child.gameObject, false);
                end
            else
                for i = 0, 3 do
                    local child = gameObject.transform:GetChild(i);
                    local dataIndex = (idx * 4) + (i + 1);
                    local itemData = ItemDataManager:GetInstance():GetItemData(self.data[dataIndex].itemUID)
                    self.ItemInfoUI:UpdateUIWithItemInstData(child.gameObject, itemData);
                end
            end
        else
            for i = 0, 3 do
                local child = gameObject.transform:GetChild(i);
                local dataIndex = (idx * 4) + (i + 1);
                local itemData = ItemDataManager:GetInstance():GetItemData(self.data[dataIndex].itemUID)
                self.ItemInfoUI:UpdateUIWithItemInstData(child.gameObject, itemData);
            end
        end
    end
end

function ResultUI6:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ResultUI6:CommonBind(gameObject, callback)
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
        self:AddToggleClickListener(tog, _callback);

    end
end

function ResultUI6:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    elseif obj == self.objImageTips then
        self:OnClickTips(obj);

    end
end

function ResultUI6:OnClickTips(obj)
    if self.info.type == TYPE.OUT then
        OpenWindowImmediately("TipsPopUI", outTips);	

    elseif self.info.type == TYPE.RECYCLE then
        OpenWindowImmediately("TipsPopUI", covTips);	

    end
end

function ResultUI6:OnClickCloseBtn(obj)
    self._gameObject:SetActive(false);
end

function ResultUI6:OnEnable()
end

function ResultUI6:OnDisable()
end

function ResultUI6:OnDestroy()
    self.ItemInfoUI:Close();
    if self.lvSC then
        self.lvSC.mOnBeginDragAction = nil;
        self.lvSC.mOnDragingAction = nil;
        self.lvSC.mOnEndDragAction = nil;
    end
end

return ResultUI6