MoneyPacketUI = class('MoneyPacketUI', BaseWindow);

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

local showType = {
    ['Give'] = 1,
    ['Open'] = 2,
    ['Opened'] = 3,
}

local moneyType = {
    [RedPacketType.RPT_Money] = {
        ['s'] = 50000,
        ['m'] = 250000,
        ['b'] = 500000,
    },
    [RedPacketType.RPT_Item] = {
        ['s'] = 50000,
        ['m'] = 250000,
        ['b'] = 500000,
    },
}

local redPacketType = {
    [RedPacketType.RPT_Money] = {
        ['s'] = 1001,
        ['m'] = 1002,
        ['b'] = 1003,
    },
    [RedPacketType.RPT_Item] = {
        ['s'] = 2001,
        ['m'] = 2002,
        ['b'] = 2003,
    },
}

local redPacketName = {
    [RedPacketType.RPT_Money] = {
        ['s'] = '小红包',
        ['m'] = '中红包',
        ['b'] = '大红包',
    },
    [RedPacketType.RPT_Item] = {
        ['s'] = '小礼包',
        ['m'] = '中礼包',
        ['b'] = '大礼包',
    }
}

local strTips = '发送红包后，自身获得%d经脉经验';

function MoneyPacketUI:ctor()
    self.bindBtnTable = {};
    self.clickPacket = 's';

    self.ItemIconUI = ItemIconUI.new();
end

function MoneyPacketUI:Create()
	local obj = LoadPrefabAndInit('MoneyPacketUI/MoneyPacketUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function MoneyPacketUI:Init()
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance();
    self.MoneyPacketDataManager = MoneyPacketDataManager:GetInstance();
    self.TBRoleModel = TableDataManager:GetInstance():GetTable("RoleModel");

    --
    self.obBlackBtn = self:FindChild(self._gameObject, 'btn_black');
    self.objGive = self:FindChild(self._gameObject, 'Give');
    self.objOpen = self:FindChild(self._gameObject, 'ef_hongbao_01');
    self.objOpened = self:FindChild(self._gameObject, 'ef_hongbao_02');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    self.objGreenBtn = self:FindChild(self._gameObject, 'Button_green_1');
    self.objOpenBtn = self:FindChild(self.objOpen, 'hb/Open');
    self.objOpenedBtn = self:FindChild(self.objOpened, 'hb2/bg2/Opened');

    --
    self.objInputField = self:FindChild(self.objGive, 'InputField');
    self.objSelectNode = self:FindChild(self.objGive, 'select_node');
    self.objTips = self:FindChild(self.objGive, 'tips');

    --
    self.objSmallBtn = self:FindChild(self.objSelectNode, 'Small');
    self.objMiddleBtn = self:FindChild(self.objSelectNode, 'Middle');
    self.objBigBtn = self:FindChild(self.objSelectNode, 'Big');
    
    --
    self.objOpenText = self:FindChild(self.objOpen, 'Text');
    self.objOpenTitle = self:FindChild(self.objOpen, 'Title');
    self.objOpenTitleHead = self:FindChild(self.objOpenTitle, 'Head/Mask/Image');
    self.objOpenTitleText = self:FindChild(self.objOpenTitle, 'Text');
    self.objOpenTitleType = self:FindChild(self.objOpenTitle, 'Type');

    --
    self.objOpenedText = self:FindChild(self.objOpened, 'Text');
    self.objOpenedTitleYindin = self:FindChild(self.objOpened, 'Type_yindin');
    self.objOpenedTitleLihe = self:FindChild(self.objOpened, 'Type_lihe');
    self.objOpenedTitle = self:FindChild(self.objOpened, 'Title');
    self.objOpenedTitleHead = self:FindChild(self.objOpenedTitle, 'Head/Mask/Image');
    self.objOpenedTitleText = self:FindChild(self.objOpenedTitle, 'Text');
    self.objOpenedTitleType = self:FindChild(self.objOpenedTitle, 'Type');

    --
    local inputField = self.objInputField:GetComponent('InputField');
    inputField.text = string.format('%s我爱你', self.PlayerSetDataManager:GetPlayerName());
    -- self.objOpened.transform.localScale = DRCSRef.Vec3(1, 0, 1);
    local fun = function(str)
        local forbidInfo = PlayerSetDataManager:GetInstance():GetForbidByType(SEOT_FORBIDEDITTEXT);
		if forbidInfo then
            HandleCommonFreezing(SEOT_FORBIDEDITTEXT);
            inputField.text = string.format('%s我爱你', self.PlayerSetDataManager:GetPlayerName());
            return;
        end
    end
    inputField.onEndEdit:AddListener(fun)

    --
    self.showNode = {};
    table.insert(self.showNode, self.objGive);
    table.insert(self.showNode, self.objOpen);
    table.insert(self.showNode, self.objOpened);

    --
    self.btnTable = {};
    table.insert(self.btnTable, self.objSmallBtn);
    table.insert(self.btnTable, self.objMiddleBtn);
    table.insert(self.btnTable, self.objBigBtn);

    --
    table.insert(self.bindBtnTable, self.obBlackBtn);
    table.insert(self.bindBtnTable, self.objOpenBtn);
    table.insert(self.bindBtnTable, self.objOpenedBtn);
    table.insert(self.bindBtnTable, self.objSmallBtn);
    table.insert(self.bindBtnTable, self.objMiddleBtn);
    table.insert(self.bindBtnTable, self.objBigBtn);
    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objGreenBtn);

    --
    self:BindBtnCB();

end

function MoneyPacketUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);

        end
        self:CommonBind(self.bindBtnTable[i], _callback);

    end
end

function MoneyPacketUI:CommonBind(gameObject, callback)
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

function MoneyPacketUI:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    elseif obj == self.objGreenBtn then
        self:OnClickGreenBtn(obj);

    elseif obj == self.objSmallBtn then
        self:OnClickSmallBtn(obj);

    elseif obj == self.objMiddleBtn then
        self:OnClickMiddleBtn(obj);
    
    elseif obj == self.objBigBtn then
        self:OnClickBigBtn(obj);
    
    elseif obj == self.objOpenBtn then
        self:OnClickOpenBtn(obj);
    
    elseif obj == self.objOpenedBtn then
        -- self:OnClickCloseBtn(obj);

    elseif obj == self.obBlackBtn then
        self:OnClickCloseBtn(obj);

    end

end

function MoneyPacketUI:OnClickOpenBtn(obj)
    local infoD = self.info.data;
    if infoD then
        self:ShowNodeByType(showType.Opened, infoD);
        -- self.objOpened.transform.localScale = DRCSRef.Vec3(1, 0, 1);
        -- self.objOpened.transform:DR_DOScaleY(1, 0.2);
        GetRedPacket(infoD.UID,infoD.token);
    end
end

function MoneyPacketUI:OnClickCloseBtn(obj)
    self:SetNodeActiveByType();
    RemoveWindowImmediately('MoneyPacketUI', true);

end

function MoneyPacketUI:OnClickGreenBtn(obj)
    if self.info then
        local redTypeID = redPacketType[self.info.redPacketType][self.clickPacket];
        local comInputField = self.objInputField:GetComponent('InputField');
        if comInputField.text == '' then
            SystemUICall:GetInstance():Toast('请输入文字');
            return;
        end
        if filter_spec_chars(comInputField.text) ~= comInputField.text then
            SystemUICall:GetInstance():Toast("含有非法字符");
            return;
        end
        SendRedPacket(self.info.redPacketType, redTypeID, comInputField.text);
        self:OnClickCloseBtn();
    end
end

function MoneyPacketUI:OnClickSmallBtn(obj)
    self:SetBtnState(obj);

    if self.info.redPacketType then
        local comTips = self.objTips:GetComponent('Text');
        comTips.text = string.format(strTips, moneyType[self.info.redPacketType].s);
        self.clickPacket = 's';
    end
end

function MoneyPacketUI:OnClickMiddleBtn(obj)
    self:SetBtnState(obj);

    if self.info.redPacketType then
        local comTips = self.objTips:GetComponent('Text');
        comTips.text = string.format(strTips, moneyType[self.info.redPacketType].m);
        self.clickPacket = 'm';
    end
end

function MoneyPacketUI:OnClickBigBtn(obj)
    self:SetBtnState(obj);

    if self.info.redPacketType then
        local comTips = self.objTips:GetComponent('Text');
        comTips.text = string.format(strTips, moneyType[self.info.redPacketType].b);
        self.clickPacket = 'b';
    end
end

function MoneyPacketUI:SetBtnState(btn)
    for i = 1, #(self.btnTable) do
        if btn == self.btnTable[i] then
            self:FindChild(self.btnTable[i], 'img_chosen'):SetActive(true);
            self:FindChildComponent(self.btnTable[i], 'img_bottom','Image').color = DRCSRef.Color.black;
            self:FindChildComponent(self.btnTable[i], 'cost1','Text').color = DRCSRef.Color(0.9,0.9,0.9,1);
        else
            self:FindChild(self.btnTable[i], 'img_chosen'):SetActive(false);
            self:FindChildComponent(self.btnTable[i], 'img_bottom','Image').color = DRCSRef.Color.white;
            self:FindChildComponent(self.btnTable[i], 'cost1','Text').color = DRCSRef.Color(0.24,0.24,0.24,1);
        end
    end

end

function MoneyPacketUI:RefreshUI(info)
    self.info = info or {};
    self:ShowNodeByType(info.showType, info.data);
    self:OnClickSmallBtn(self.objSmallBtn);
end

function MoneyPacketUI:ShowNodeByType(type, data)
    if type == showType.Give then
        self:SetNodeActiveByType(self.objGive);
        self:OnRefGive();
    elseif type == showType.Open then
        self:SetNodeActiveByType(self.objOpen);
        self:OnRefOpen();
    elseif type == showType.Opened then
        local getTimes = PlayerSetDataManager:GetInstance():GetRedPacketGetTimes();
        if getTimes >=  SSD_MAX_GETREDPACKETTIMES then
            return;
        end
        self:SetNodeActiveByType(self.objOpened);
    end
end

function MoneyPacketUI:OnRefGive()
    if self.info then
        self:FindChildComponent(self.objSmallBtn, 'Text', 'Text').text = redPacketName[self.info.redPacketType].s;
        self:FindChildComponent(self.objMiddleBtn, 'Text', 'Text').text = redPacketName[self.info.redPacketType].m;
        self:FindChildComponent(self.objBigBtn, 'Text', 'Text').text = redPacketName[self.info.redPacketType].b;
    end
end

function MoneyPacketUI:OnRefOpen()

    local infoD = self.info.data;
    if infoD then
        --[[
        local modelData = self.TBRoleModel[infoD.mId];
        if modelData then
            self.objOpenTitleHead:GetComponent('Image').sprite = GetSprite(modelData.Head);
        end]]

        local callback = function(sprite)
            local uiWindow = GetUIWindow("MoneyPacketUI")
            if (uiWindow) then
                self.objOpenTitleHead:GetComponent('Image').sprite = sprite
            end
        end
        local pjsondata = {
            ['dwModelID'] = infoD.mId,
            ['charPicUrl'] = infoD.picture
        }
        GetHeadPicByData(pjsondata, callback)

        self.objOpenText:GetComponent('Text').text = infoD.token;
        self.objOpenTitleText:GetComponent('Text').text = string.format('%s的', infoD.Name);
        
        local objYindin = self:FindChild(self.objOpenTitleType, 'yindin');
        local objLihe = self:FindChild(self.objOpenTitleType, 'lihe');
        if infoD.type == RedPacketType.RPT_Money then
            objYindin:SetActive(true);
            objLihe:SetActive(false);
        elseif infoD.type == RedPacketType.RPT_Item then
            objYindin:SetActive(false);
            objLihe:SetActive(true);
        end
    end
end

function MoneyPacketUI:OnRefOpened(data)

    local infoD = self.info.data;
    if infoD and data then
        --[[
        local modelData = self.TBRoleModel[infoD.mId];
        if modelData then
            self.objOpenedTitleHead:GetComponent('Image').sprite = GetSprite(modelData.Head);
        end]]

        local callback = function(sprite)
            local uiWindow = GetUIWindow("MoneyPacketUI")
            if (uiWindow) then
                self.objOpenedTitleHead:GetComponent('Image').sprite = sprite
            end
        end
        local pjsondata = {
            ['dwModelID'] = infoD.mId,
            ['charPicUrl'] = infoD.picture
        }
        GetHeadPicByData(pjsondata, callback)

        local moneyStr = infoD.token;

        local objYindin = self:FindChild(self.objOpenedTitleType, 'yindin');
        local objLihe = self:FindChild(self.objOpenedTitleType, 'lihe');
        if infoD.type == RedPacketType.RPT_Money then
            self.objOpenedTitleYindin:SetActive(true);
            self.objOpenedTitleLihe:SetActive(false);
            
            objYindin:SetActive(true);
            objLihe:SetActive(false);
            if data.iItemNum and data.iItemNum > 0 then
                local comYindin = self:FindChildComponent(self.objOpenedTitleYindin, 'Text', 'Text');
                comYindin.text = data.iItemNum;
            else
                self.objOpenedTitleYindin:SetActive(false);
                moneyStr = '红包已领完';
            end
        elseif infoD.type == RedPacketType.RPT_Item then
            self.objOpenedTitleYindin:SetActive(false);
            self.objOpenedTitleLihe:SetActive(true);
            
            objYindin:SetActive(false);
            objLihe:SetActive(true);

            local itemTypeData = TableDataManager:GetInstance():GetTableData("Item", data.iItemId);
            local objItemIconUI = self:FindChild(self.objOpenedTitleLihe, 'ItemIconUI');
            if itemTypeData then
                if data.iItemNum and data.iItemNum > 0 then
                    self:FindChild(objItemIconUI, 'Icon'):SetActive(true);
                    self.ItemIconUI:UpdateUIWithItemTypeData(objItemIconUI, itemTypeData);
                    self.ItemIconUI:SetItemNum(objItemIconUI, data.iItemNum);
                else
                    self.objOpenedTitleLihe:SetActive(false);
                    moneyStr = '红包已领完';
                end
            else
                self:FindChild(objItemIconUI, 'Icon'):SetActive(false);
                self.ItemIconUI:SetItemNum(objItemIconUI, 0);
            end
        end

        self.objOpenedText:GetComponent('Text').text = moneyStr;
        self.objOpenedTitleText:GetComponent('Text').text = string.format('%s的', infoD.Name);
    end
end

function MoneyPacketUI:SetNodeActiveByType(showNode)
    for i = 1, #(self.showNode) do
        if showNode == self.showNode[i] then
            self.showNode[i]:SetActive(true);
        else
            self.showNode[i]:SetActive(false);
        end
    end
end

function MoneyPacketUI:OnDisable()
	self:RemoveEventListener('ONEVENT_REF_GETREDPACKET');
end

function MoneyPacketUI:OnEnable()
	self:AddEventListener('ONEVENT_REF_GETREDPACKET', function(info)
        self:OnRefOpened(info);
    end);
end

function MoneyPacketUI:OnDestroy()
    self.objInputField:GetComponent('InputField').onEndEdit:RemoveAllListeners();
end

return MoneyPacketUI;