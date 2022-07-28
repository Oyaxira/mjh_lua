TakeExtraUI = class('TakeExtraUI', BaseWindow);

local localConfig = {
    BaseSize = 4,
    VIP = 2,
}

local buyConfig = {
    [1] = 5000,
    [2] = 10000,
    [3] = 20000,
    [4] = 40000,
}

function TakeExtraUI:ctor()
    self.bindBtnTable = {};
end

function TakeExtraUI:Create()
	local obj = LoadPrefabAndInit('Role/BackpackExtend', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function TakeExtraUI:Init()

    self.StoryItemBring = TableDataManager:GetInstance():GetTable('StoryItemBring') or {};

    self.objCloseBtn = self:FindChild(self._gameObject, 'Background/CloseButton');
    self.objList = self:FindChild(self._gameObject, 'Background/List');
    self.objNum = self:FindChild(self._gameObject, 'Num');
    self.objBaseNum = self:FindChild(self._gameObject, 'BaseNum');
    self.objDiffNum = self:FindChild(self._gameObject, 'DiffNum');
    self.objWeeklyNum = self:FindChild(self._gameObject, 'WeeklyNum');
    self.objBuyNum = self:FindChild(self._gameObject, 'BuyNum');
    
    self.objBuyBtn = self:FindChild(self.objBuyNum, 'Button');

    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objBuyBtn);

    --
    self:BindBtnCB();

end

function TakeExtraUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function TakeExtraUI:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);
    elseif obj == self.objBuyBtn then
        self:OnClickBuyBtn(obj);
    end
end

function TakeExtraUI:OnClickCloseBtn(obj)
    RemoveWindowImmediately("TakeExtraUI");
end

function TakeExtraUI:OnClickBuyBtn(obj)
    local buyNum = PlayerSetDataManager:GetInstance():GetPlayerDilatationNum();
    buyNum = buyNum + 1 > #(self.StoryItemBring) and #(self.StoryItemBring) or buyNum + 1;
    local silverIgnot = self.StoryItemBring[buyNum].SilverIgnot or 0;
    local warningText = string.format("花费%d银锭激活1个带入格子吗？\n激活后<color=red>永久</color>生效！", silverIgnot);

    local content = {
        ['btnText'] = "确定",
        ['btnType'] = "silver",
        ['title'] = "带入扩容", 
        ['text'] = warningText,
        ['num'] = silverIgnot,
    }
    local callBack = function()
        PlayerSetDataManager:GetInstance():RequestSpendSilver(silverIgnot, function()
            SendPlatItemToScriptDilatation();
        end)
    end
    OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.Pay_TIP, content, callBack });

end

function TakeExtraUI:RefreshUI()
    self:OnRefUI();
end

function TakeExtraUI:OnRefUI()

    local curDiff = RoleDataManager:GetInstance():GetDifficultyValue();
    local kDiffData = StoryDataManager:GetInstance():GetStoryDifficultData(GetCurScriptID(), curDiff) or {}
    local carryLimit = kDiffData.StorageInItem or 0;
    local bVIP = TreasureBookDataManager:GetInstance():GetTreasureBookVIPState();
    local roleInfo = globalDataPool:getData("MainRoleInfo") or {};
    local mainRoleInfo = roleInfo["MainRole"];
    local buyNum = PlayerSetDataManager:GetInstance():GetPlayerDilatationNum();
    
    -- 基础
    self:FindChildComponent(self.objBaseNum, 'Num', 'Text').text = localConfig.BaseSize;
    self:FindChildComponent(self.objBaseNum, 'State', 'Text').text = '已激活';
    
    -- 难度
    self:FindChildComponent(self.objDiffNum, 'Title', 'Text').text = '难度' .. curDiff;
    self:FindChildComponent(self.objDiffNum, 'Num', 'Text').text = carryLimit - localConfig.BaseSize;
    self:FindChildComponent(self.objDiffNum, 'State', 'Text').text = '已激活';

    -- 壕侠
    local kMiscData = TableDataManager:GetInstance():GetTableData("CommonConfig", 1)
    local iNum = 0
    if kMiscData then
        iNum = kMiscData.TreasureBookVIPBringInUP or 0
    end
    self:FindChildComponent(self.objWeeklyNum, 'Num', 'Text').text = iNum
    self:FindChildComponent(self.objWeeklyNum, 'State', 'Text').text = bVIP == true and '已激活' or '未激活';
    
    -- 银锭解锁
    self:FindChildComponent(self.objBuyNum, 'Num', 'Text').text = buyNum;
    local strText = buyNum > 0 and string.format('已激活(%d/%d)', buyNum, #(self.StoryItemBring)) or '未激活';
    self:FindChildComponent(self.objBuyNum, 'State', 'Text').text = strText;

    local sum = carryLimit + (bVIP == true and iNum or 0) + buyNum;
    self:FindChildComponent(self.objNum, 'Text', 'Text').text = '当前总容量' .. sum;

    self.objBuyBtn:SetActive(buyNum < #(self.StoryItemBring));
end

function TakeExtraUI:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_BUYTAKE');
end

function TakeExtraUI:OnEnable()
    self:AddEventListener('ONEVENT_REF_BUYTAKE', function()
        self:OnRefUI();

        local storageUI = GetUIWindow('StorageUI');
        if storageUI then
            storageUI:UpdateBringPackMsg();
        end
    end);
end

function TakeExtraUI:OnDestroy()

end

return TakeExtraUI;