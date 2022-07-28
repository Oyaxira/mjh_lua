ShoppingMallUI = class('ShoppingMallUI', BaseWindow);

local ItemIconUI = require 'UI/ItemUI/ItemIconUI';
local PoemShowCom = require "UI/PlayerSet/PoemShowUI"
local ShoppingMallUIGet = require "UI/TownUI/ShoppingMallUIGet"
local ShoppingMallUIName = require "UI/TownUI/ShoppingMallUIName"
local ShoppingMallUIPreviewPlatS = require "UI/TownUI/ShoppingMallUIPreviewPlatS"
local ShoppingMallUIPreviewPlatB = require "UI/TownUI/ShoppingMallUIPreviewPlatB"

local normalColor = DRCSRef.Color(0x7C / 255, 0x4A / 255, 0x2D / 255, 1);
local clickColor = DRCSRef.Color(0xE3 / 255, 0xC0 / 255, 0xA5 / 255, 1);
local redColor = DRCSRef.Color(1, 0.1786178, 0.1179245, 1);
local whiteColor = DRCSRef.Color(0xE9 / 255, 0xE9 / 255, 0xE9 / 255, 1);
local blackColor = DRCSRef.Color(0x0d / 255, 0x0d / 255, 0x0d / 255, 1);

local propertyImageName = {
    'Image_zhekou',
    'Image_chaozhi',
    'Image_xianliang',
    'Image_jueban',
    'Image_xinpin',
    'Image_dijia',
    'Image_mianfei',
    'Image_xinshou',
}

local clanToAchieve = {
    [10] = {
        dec = '少林派的邀请',
        AchieveID = 24,
    },
    [4] = {
        dec = '武当派的邀请',
        AchieveID = 25,
    },
    [11] = {
        dec = '峨嵋派的邀请',
        AchieveID = 26,
    },
    [2] =	{
        dec = '丐帮的邀请',
        AchieveID = 344,
    },
    [63] =	{
        dec = '六扇门的邀请',
        AchieveID = 345,
    },
    [3] =	{
        dec = '长生门的邀请',
        AchieveID = 346,
    },
    [8] =	{
        dec = '赤刀门的邀请',
        AchieveID = 347,
    },
}

local charge = {
    [1] = 1,
    [2] = 6,
    [3] = 18,
    [4] = 30,
    [5] = 68,
    [6] = 128,
    [7] = 328,
    [8] = 648,
}

local shopBuyLimitResetTypeRevert = {
    [ShopBuyLimitResetType.SBLRT_NULL] = "-",
    [ShopBuyLimitResetType.SBLRT_DAILY] = "每日重置",
    [ShopBuyLimitResetType.SBLRT_WEEKLY] = "每周重置",
    [ShopBuyLimitResetType.SBLRT_MONTH] = "每月重置",
  }

function ShoppingMallUI:ctor()
    self.bindBtnTable = {};
    self.clickType = 1;
    self.clickTarget = nil;
    self.clickItemData = nil;
    self.buyCount = 1;
    self.buyMaxCount = 0;
    self.lvSCBindBtn = {};
    self.togTable = {};
    self.downCount = 0;
    self.clickSendBtn = false;
    self.dataIndex = 1;
    self.pageIndex = 0;
    self.bFrist = true;
end

function ShoppingMallUI:Create()
	local obj = LoadPrefabAndInit('TownUI/ShoppingMallUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function ShoppingMallUI:Init()
    self.ItemDataManager = ItemDataManager:GetInstance();
    self.ShoppingDataManager = ShoppingDataManager:GetInstance();
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance();
    self.StorageDataManager = StorageDataManager:GetInstance();
    self.RoleDataManager = RoleDataManager:GetInstance();
    self.MeridiansDataManager = MeridiansDataManager:GetInstance();
    self.TreasureBookDataManager = TreasureBookDataManager:GetInstance();
    self.AchieveDataManager = AchieveDataManager:GetInstance();
    self.PinballDataManager = PinballDataManager:GetInstance();

    --
    self.objImageMall = self:FindChild(self._gameObject, 'Image_Mall');
    self.objImagePay = self:FindChild(self._gameObject, 'Image_Pay');
    self.objDRBtn = self:FindChild(self._gameObject, 'DRButton');
    self.objPopupNode = self:FindChild(self._gameObject,'Popup_node');
    self.objCharge = self:FindChild(self.objImagePay, 'Charge');

    self.objSCProducts = self:FindChild(self.objImageMall, 'SC_Products');
    self.objBegNode = self:FindChild(self.objImageMall, 'Beg_node');
    self.objPoemShow = self:FindChild(self.objPopupNode, 'Poem_show_box');
    self.objPlayerList = self:FindChild(self.objPopupNode, 'PlayerList');
    self.objGive = self:FindChild(self.objPopupNode, 'Give');
    self.objGet = self:FindChild(self.objPopupNode, 'Get');
    self.objPlatPreview = self:FindChild(self.objPopupNode, 'Preview_node');
    self.objPlatPreviewS = self:FindChild(self.objPlatPreview, 'Small');
    self.objPlatPreviewB = self:FindChild(self.objPlatPreview, 'Big');
    self.objPlatPreview:SetActive(true);
    
    self.objBeg = self:FindChild(self.objImageMall, 'Beg');
    self.objBegTextAll = self:FindChild(self.objBeg, 'Text_all');
    self.objBegTextMine = self:FindChild(self.objBeg, 'Text_mine');
    self.objBegPromiseBtn = self:FindChild(self.objBeg, 'Button_promise');
    self.objBegFormulaBtn = self:FindChild(self.objBeg, 'Button_formula');
    self.objBegGiveBtn = self:FindChild(self.objBeg, 'Button_give');
    self.objBegADBtn = self:FindChild(self.objBeg, 'Button_ad');
    self.objBegSlider = self:FindChild(self.objBeg, 'Slider');
    self.objBegTextNum1 = self:FindChild(self.objBegSlider, 'mark/Text_num1');
    self.objBegTextNum2 = self:FindChild(self.objBegSlider, 'mark/Text_num2');

    self.objNavTop = self:FindChild(self._gameObject, 'Nav_top');
    self.objTog1 = self:FindChild(self.objNavTop, 'toggle_1');
    self.objTog2 = self:FindChild(self.objNavTop, 'toggle_2');
    self.objTog3 = self:FindChild(self.objNavTop, 'toggle_3');
    self.objTog4 = self:FindChild(self.objNavTop, 'toggle_4');
    self.objTog5 = self:FindChild(self.objNavTop, 'toggle_5');
    self.objTog6 = self:FindChild(self.objNavTop, 'toggle_6');
    self.objTog7 = self:FindChild(self.objNavTop, 'toggle_7');
    self.objTog8 = self:FindChild(self.objNavTop, 'toggle_8');

    self.objNavRight = self:FindChild(self._gameObject, 'Nav_right');
    self.objTogMall = self:FindChild(self.objNavRight, 'Toggle_mall');
    self.objTogPay = self:FindChild(self.objNavRight, 'Toggle_pay');

    self.objInfoNode = self:FindChild(self.objImageMall, 'Info_node');
    self.objInfoName = self:FindChild(self.objInfoNode, 'name');
    self.objInfoDiscount = self:FindChild(self.objInfoNode, 'Image_discount');
    self.objInfoText = self:FindChild(self.objInfoNode, 'Text');
    self.objInfoMoneyNode = self:FindChild(self.objInfoNode, 'Money_node');
    self.objInfoTextPricePrevious = self:FindChild(self.objInfoNode, 'Text_price_previous');
    self.objInfoTextPriceNow = self:FindChild(self.objInfoNode, 'Text_price_now');
    self.objInfoSC = self:FindChild(self.objInfoNode, 'SC_info');
    self.objInfoItemTips = self:FindChild(self.objInfoSC, 'Viewport/Content/InfoItem');
    
    self.objInfoImage = self:FindChild(self.objInfoNode, 'Image_btn');
    self.objState1 = self:FindChild(self.objInfoImage, 'state1');
    self.objState1BuyBtn = self:FindChild(self.objState1, 'Button_buy');
    self.objState2 = self:FindChild(self.objInfoImage, 'state2');
    self.objState2PreviewBtn = self:FindChild(self.objState2, 'Button_preview');
    self.objState2BuyBtn = self:FindChild(self.objState2, 'Button_buy');
    
    self.objInfoChooseNum = self:FindChild(self.objInfoNode, 'ChooseNum');
    self.objInfoReduceBtn = self:FindChild(self.objInfoChooseNum, 'Button_reduce');
    self.objInfoAddBtn = self:FindChild(self.objInfoChooseNum, 'Button_add');
    self.objInfoAllBtn = self:FindChild(self.objInfoChooseNum, 'Button_all');
    self.objInfoNum = self:FindChild(self.objInfoChooseNum, 'num');
    
    self.objInfoOwn = self:FindChild(self.objInfoNode, 'Image_own');
    self.objInfoTextOwn = self:FindChild(self.objInfoOwn, 'Text_own');
    self.objInfoTextLimit = self:FindChild(self.objInfoOwn, 'Text_limit');
    self.objInfoTextReset = self:FindChild(self.objInfoOwn, 'Text_reset');
    self.objInfoTextReset:SetActive(false);

    --
    self.ItemIconUI = ItemIconUI.new();
    self.PoemShowCom = PoemShowCom.new(self.objPoemShow);

    --
    self.objChargeByns = self:FindChild(self.objCharge, 'buttons');
    self.objFirstInfos = {}
    for k, v in pairs(self.objChargeByns.transform) do
        table.insert(self.bindBtnTable, v.gameObject);
        table.insert(self.objFirstInfos,self:FindChild( v.gameObject, 'FirstInfo'))
    end

    --
    table.insert(self.bindBtnTable, self.objTog1);
    table.insert(self.bindBtnTable, self.objTog2);
    table.insert(self.bindBtnTable, self.objTog3);
    table.insert(self.bindBtnTable, self.objTog4);
    table.insert(self.bindBtnTable, self.objTog5);
    table.insert(self.bindBtnTable, self.objTog6);
    table.insert(self.bindBtnTable, self.objTog7);
    table.insert(self.bindBtnTable, self.objTog8);
    table.insert(self.bindBtnTable, self.objTogMall);
    table.insert(self.bindBtnTable, self.objTogPay);
    table.insert(self.bindBtnTable, self.objInfoReduceBtn);
    table.insert(self.bindBtnTable, self.objInfoAddBtn);
    table.insert(self.bindBtnTable, self.objInfoAllBtn);
    table.insert(self.bindBtnTable, self.objState1BuyBtn);
    table.insert(self.bindBtnTable, self.objState2PreviewBtn);
    table.insert(self.bindBtnTable, self.objState2BuyBtn);
    table.insert(self.bindBtnTable, self.objBegPromiseBtn);
    table.insert(self.bindBtnTable, self.objBegFormulaBtn);
    table.insert(self.bindBtnTable, self.objBegGiveBtn);
    table.insert(self.bindBtnTable, self.objBegADBtn);
    table.insert(self.bindBtnTable, self.objDRBtn);

    --
    table.insert(self.togTable, self.objTog8);
    table.insert(self.togTable, self.objTog1);
    table.insert(self.togTable, self.objTog2);
    table.insert(self.togTable, self.objTog3);
    table.insert(self.togTable, self.objTog4);
    table.insert(self.togTable, self.objTog5);
    table.insert(self.togTable, self.objTog6);
    table.insert(self.togTable, self.objTog7);

    --
    self:BindBtnCB();

    self.comService_Button = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/Button_Tencent_KF", "Button")
    if (self.comService_Button) then
        local fun = function()
            MSDKHelper:OpenServiceUrl("Money")
        end
        self:AddButtonClickListener(self.comService_Button, fun)
    end


    -- +2 需求 直接隐藏分享页签
    self.objDRBtn:SetActive(false)
    SetConfig('hideBeg', 'false')

end

function ShoppingMallUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);

        end
        self:CommonBind(self.bindBtnTable[i], _callback);

    end
end

function ShoppingMallUI:RefreshUI(info)
    self.bFrist = true;
    self.downCount = 0;
    self.clickTarget = nil;
    self.clickSendBtn = false;
    self.pageIndex = info and info.ePageType or nil;
    self.ShoppingDataManager:ResetShopData();

    self.objTogMall:GetComponent('Toggle').isOn = true;

    self:QureyTog();

    -- 请求平台阵容
	if not globalDataPool:getData('PlatTeamInfo') then
		SendQueryPlatTeamInfo(SPTQT_PLAT, 0);
    end
    
    MidasHelper:QueryMPInfo()
end

function ShoppingMallUI:QureyTog()
    SendPlatShopMallQueryItem(RackItemType.RIT_ITEM);

    local hideBeg = GetConfig('hideBeg');
    if (not hideBeg) or (hideBeg and hideBeg == 'true') then
        SendPlatShopMallReward(PSMRT_QUERY);
    else
        self.objBeg:SetActive(false);
    end
end

function ShoppingMallUI:OnRefSCProducts(bMove)
    
    self.lvSCBindBtn = {};

    local shopData = self.ShoppingDataManager:GetShopData(self.clickType);
    self.shopData = shopData or {};

    self.fixCount = 4;
    self.mod = #(self.shopData) % 4;
    self.count = math.ceil(#(self.shopData) / 4);
    self.scCount = self.count < self.fixCount and self.fixCount or self.count + 1;

    local lvSC = self.objSCProducts:GetComponent('LoopListView2');
    local scrollRect = self.objSCProducts:GetComponent('ScrollRect');
    local content = self:FindChild(self.objSCProducts, 'Image/Viewport/Content');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('MallItem');
            self:OnScrollChanged(obj.gameObject, index);
            return obj;
        end
        
        local _func1 = function()
            self.beginPos = content.transform.localPosition;
        end

        local _func2 = function()
        end
        
        local _func3 = function()
            
            self.endPos = content.transform.localPosition;
            if self.endPos.y - self.beginPos.y > 20 then
                local y = math.ceil(self.endPos.y / 207) * 207;
                content.transform:DR_DOLocalMoveY(y, 0.1);
            else
                local y = math.floor(self.endPos.y / 207) * 207;
                content.transform:DR_DOLocalMoveY(y, 0.1);
            end

            self.beginPos.y = 0;
            self.endPos.y = 0;
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.scCount, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.scCount, false);
            lvSC:RefreshAllShownItem();
        end 

        if bMove then
            local localPosition = content.transform.localPosition;
            content.transform.localPosition = DRCSRef.Vec3(localPosition.x, 0, localPosition.z);
            scrollRect.velocity = DRCSRef.Vec2Zero;
        end

        self.lvSCProducts = lvSC;
    end
end

function ShoppingMallUI:OnScrollChanged(gameObject, index)
    gameObject:SetActive(true);
    self:SetItemSingle(gameObject, index);
end

function ShoppingMallUI:SetItemSingle(gameObject, idx)

    local unlock = globalDataPool:getData('UnlockPool');

    local itemHasCount = 4;

    local _setMoneyType = function(gameObject, data)

        local _setMoneyTypeState = function(strName)
            for k, v in pairs(gameObject.transform) do
                if v.gameObject.name ~= 'Num' then
                    if v.gameObject.name == strName then
                        v.gameObject:SetActive(true);
                    else
                        v.gameObject:SetActive(false);
                    end
                end
            end
        end

        if data.uiMoneyType == RackItemMoneyType.RIMT_GOLD then 
            _setMoneyTypeState('Image_JinDing');
            
        elseif data.uiMoneyType == RackItemMoneyType.RIMT_SILVER then 
            _setMoneyTypeState('Image_YinDing');
            
        elseif data.uiMoneyType == RackItemMoneyType.RIMT_TREASUREBOOK then 
            _setMoneyTypeState('Image_CanYe');
            
        elseif data.uiMoneyType == RackItemMoneyType.RIMT_DRINK then 
            _setMoneyTypeState('Image_JiuQuan');
            
        elseif data.uiMoneyType == RackItemMoneyType.RIMT_PLATSCORE then 
            _setMoneyTypeState('Image_Ziyuan');

        elseif data.uiMoneyType == RackItemMoneyType.RIMT_ACTIVITYSCORE then
            _setMoneyTypeState('Image_JiFen');
            
        end   
    end

    local _func = function(child, i, bRemoveListener)

        local comScript = child:GetComponent('LoopListViewItemChildPool');

        local dataIndex = (idx * itemHasCount) + (i + 1);
        local drButton = self:FindChild(child.gameObject, 'DRButton');
        local imageProperty = self:FindChild(child.gameObject, 'Image_property');
        local clanUnlock = self:FindChild(child.gameObject, 'Image_clanunlock');
        local comName = self:FindChildComponent(child.gameObject, 'Image/name', 'Text');
        local comIcon = self:FindChildComponent(child.gameObject, 'Image/Image_icon', 'Image');
        local discount = self:FindChild(child.gameObject, 'Image/Image_discount');
        local timelimit = self:FindChild(child.gameObject, 'Image/Image_timelimit');
        local imgRedPoint = self:FindChild(child.gameObject, 'Image/Image_redpoint');
        local price = self:FindChild(child.gameObject, 'Image/Price');
        local discountNum = self:FindChild(discount, 'Num');
        local comtimelimitNum = self:FindChildComponent(timelimit, 'Text', 'Text');
        local botDiscount = self:FindChild(discount, 'bottom_discount');
        local botFree = self:FindChild(discount, 'bottom_free');
        local priceNum = self:FindChild(price, 'Num');
        local itemIconUI = self:FindChild(child.gameObject, 'ItemIconUI');
        local imageSoldOut = self:FindChild(child.gameObject, 'Image_soldout');

        local _setProperty = function(data)
            local size = getTableSize2(RackItemProperty);
            for k, v in pairs(RackItemProperty) do
                if v > 0 and v < size - 1 then
                    if data and HasFlag(data.uiProperty, v) then
                        if propertyImageName[v] and propertyImageName[v] ~= 'Image_zhekou' and propertyImageName[v] ~= 'Image_mianfei' then
                            self:FindChild(imageProperty, propertyImageName[v]):SetActive(true);
                        end
                    else
                        if propertyImageName[v] then
                            self:FindChild(imageProperty, propertyImageName[v]):SetActive(false);
                        end
                    end
                end
            end
        end

        clanUnlock:SetActive(false);

        if bRemoveListener then
            imageSoldOut:SetActive(false);
            _setProperty();
            local comBtn = drButton:GetComponent('Button');
            self:RemoveButtonClickListener(comBtn);
        else            
            local data = self.shopData[dataIndex];
            local itemData = self.ItemDataManager:GetItemTypeDataByTypeID(data.uiItemID);
            local reckData = self.ShoppingDataManager:GetRackData(data.uiShopID);
    
            if itemData then
                comName.text = itemData.ItemName or ''
                comName.color = getRankColor(itemData.Rank);
                comIcon.sprite = GetSprite(itemData.Icon);
                priceNum:GetComponent('Text').text = data.iFinalPrice;

                imgRedPoint:SetActive(data.iFinalPrice == 0 and data.iCanBuyCount > 0)

                for k, v in pairs(imageProperty.transform) do
                    v.gameObject:SetActive(false);
                end
    
                _setProperty(data);
    
                --
                if data.iType == RackItemType.RIT_CANZHANG then
		            clanUnlock:SetActive(true);
                    local TB_Clan = TableDataManager:GetInstance():GetTable("Clan");
                    if (unlock and unlock[PlayerInfoType.PIT_CLAN] and unlock[PlayerInfoType.PIT_CLAN][data.iNeedUnlockID]) or
                    (TB_Clan and TB_Clan[data.iNeedUnlockID] and TB_Clan[data.iNeedUnlockID].ClanLock == ClanLock.CLL_JoinClan)
                    then
		                clanUnlock:SetActive(false);
		            end
                end

                --
                imageSoldOut:SetActive(data.iCanBuyCount == 0);
                if data.iRemainTime and data.iRemainTime > 0 then 
                    discount:SetActive(false)
                    botFree:SetActive(false)
                    timelimit:SetActive(true)
                    comtimelimitNum.text = self:GetTimeLeftStr(data.iRemainTime)
                elseif data.iDiscount == 100 then
                    discount:SetActive(false);
                    timelimit:SetActive(false)
                else
                    local strText = string.format('%0.1f', data.iDiscount / 10) .. '折';
                    if data.iDiscount == 0 then
                        strText = '免费';
                        botDiscount:SetActive(false);
                        botFree:SetActive(true);
                    elseif data.iDiscount > 0 then
                        botDiscount:SetActive(true);
                        botFree:SetActive(false);
                    end

                    discountNum:GetComponent('Text').text = strText;
                    discount:SetActive(true);
                    timelimit:SetActive(false)

                end
    
                _setMoneyType(price, data);
    
                self.ItemIconUI:UpdateUIWithItemTypeData(itemIconUI, itemData);
    
                local _callback = function()
                    self.buyCount = 1;
                    local shopData = self.ShoppingDataManager:GetShopData(self.clickType);
                    if shopData then
                        self.clickItemData = shopData[dataIndex];
                        self.dataIndex = dataIndex;
                        self:SetTabState();
                        self:SetShopItemState(child.gameObject);
                    end
                end
                self:CommonBind(drButton, _callback);
            end
        end
    end

    if idx == (self.count - 1) then
        for i = 0, itemHasCount - 1 do
            local child = gameObject.transform:GetChild(i);
            if i < self.mod or self.mod == 0 then
                _func(child, i, false);
                self:FindChild(child.gameObject, 'Image'):SetActive(true);
            else
                _func(child, i, true);
                self:FindChild(child.gameObject, 'Image'):SetActive(false);
            end
            table.insert(self.lvSCBindBtn, child.gameObject);
        end
    else
        if self.count < self.scCount then
            if idx > (self.count - 1) and idx < self.scCount then
                for i = 0, itemHasCount - 1 do
                    local child = gameObject.transform:GetChild(i);
                    _func(child, i, true);
                    self:FindChild(child.gameObject, 'Image'):SetActive(false);
                    table.insert(self.lvSCBindBtn, child.gameObject);
                end
            else
                for i = 0, itemHasCount - 1 do
                    local child = gameObject.transform:GetChild(i);
                    _func(child, i, false);
                    self:FindChild(child.gameObject, 'Image'):SetActive(true);
                    table.insert(self.lvSCBindBtn, child.gameObject);
                end
            end
        else
            for i = 0, itemHasCount - 1 do
                local child = gameObject.transform:GetChild(i);
                _func(child, i, false);
                self:FindChild(child.gameObject, 'Image'):SetActive(true);
                table.insert(self.lvSCBindBtn, child.gameObject);
            end
        end
    end
end

function ShoppingMallUI:SetShopItemState(obj)
    for i = 1, #(self.lvSCBindBtn) do
        if obj == self.lvSCBindBtn[i] then
            self:FindChild(self.lvSCBindBtn[i], 'Image_choosen'):SetActive(true);
            local num = self:FindChild(self.lvSCBindBtn[i], 'Image/Price/Num');
            num:GetComponent('Text').color = blackColor;
        else
            self:FindChild(self.lvSCBindBtn[i], 'Image_choosen'):SetActive(false);
            local num = self:FindChild(self.lvSCBindBtn[i], 'Image/Price/Num');
            num:GetComponent('Text').color = whiteColor;
        end
    end
end

function ShoppingMallUI:OnclickBtn(obj, boolHide)

    if obj == self.objInfoReduceBtn then
        self:OnClickInfoReduceBtn(obj);

    elseif obj == self.objInfoAddBtn then
        self:OnClickInfoAddBtn(obj);

    elseif obj == self.objInfoAllBtn then
        self:OnClickInfoAllBtn(obj);

    elseif obj == self.objState1BuyBtn then
        self:OnClickState1BuyBtn(obj);

    elseif obj == self.objState2PreviewBtn then
        self:OnClickState2PreviewBtn(obj);

    elseif obj == self.objState2BuyBtn then
        self:OnClickState2BuyBtn(obj);

    elseif obj == self.objBegPromiseBtn then
        self:OnClickBegPromiseBtn(obj);

    elseif obj == self.objBegFormulaBtn then
        self:OnClickBegFormulaBtn(obj);

    elseif obj == self.objBegGiveBtn then
        self:OnClickBegGiveBtn(obj);

    elseif obj == self.objBegADBtn then
        self:OnClickBegADBtn(obj);

    elseif obj == self.objDRBtn then
        self:OnClickDRBtn(obj);

    elseif obj == self.objTog1 then
        self:OnClickTog(obj, RackItemType.RIT_ITEM);

    elseif obj == self.objTog2 then
        self:OnClickTog(obj, RackItemType.RIT_EXPAND);

    elseif obj == self.objTog3 then
        self:OnClickTog(obj, RackItemType.RIT_SHOW);

    elseif obj == self.objTog4 then
        self:OnClickTog(obj, RackItemType.RIT_CANZHANG);

    elseif obj == self.objTog5 then
        self:OnClickTog(obj, RackItemType.RIT_DRINK);

    elseif obj == self.objTog6 then
        self:OnClickTog(obj, RackItemType.RIT_EXCHANGE);

    elseif obj == self.objTog7 then
        self:OnClickTog(obj, RackItemType.RIT_ACTIVITY);
    
    elseif obj == self.objTog8 then
        self:OnClickTog8(obj);

    elseif obj == self.objTogMall then
        self:OnClickTogMall(obj, boolHide);

    elseif obj == self.objTogPay then
        self:OnClickTogPay(obj, boolHide)

    elseif obj.transform.parent.gameObject == self.objChargeByns then
        self:OnClickChargeBtn(obj);

    end

end

function ShoppingMallUI:OnClickChargeBtn(obj)
    -- 这里额外做一个事情，就是如果用模拟器模拟IOS登录的，那么不允许进行充值
    if (g_IS_SIMULATORIOS) then
        SystemUICall:GetInstance():Toast('您当前为模拟IOS登录状态，无法进行充值!')
        return
    end
    for k, v in pairs(self.objChargeByns.transform) do
        if v.gameObject == obj then
            local _callback = function()
                SystemUICall:GetInstance():Toast('充值成功!')
                MidasHelper:QueryMPInfo()
                -- TODO:隐藏首充图标
            end
            MidasHelper:Deposit(charge[k + 1], _callback);
            local node = self:FindChild(v.gameObject, 'FirstInfo')
            if node then 
                node:SetActive(false) -- 隐藏首充
            end

            if self._Index_FirstRecharge == nil then 
                self._Index_FirstRecharge = self:AddTimer(2000,function()
                    MidasHelper:QueryMPInfo()
                end,-1)
            end
            break;
        end
    end
end

function ShoppingMallUI:OnClickTogMall(obj, boolHide)
    if boolHide then
        self.objImageMall:SetActive(true);
        self.objImagePay:SetActive(false);
        self.objDRBtn:SetActive(false);

        --
        self:OnRefWindowBar(self.clickTarget);
    end
end

function ShoppingMallUI:OnClickTogPay(obj, boolHide)
    if boolHide then
         --充值界面除了msdk_mode=1的情况下关闭 其他状态都打开
        if (MSDK_MODE ~= 1) then  
            self.objImageMall:SetActive(false);
            self.objImagePay:SetActive(true);
            self.objDRBtn:SetActive(false);
            MidasHelper:QueryMPInfo()
        else 
            SystemUICall:GetInstance():Toast('未开放充值')
            self.objTogMall:GetComponent('Toggle').isOn = true;
        end

        --
        local windowBarUI = GetUIWindow("WindowBarUI");
        if windowBarUI and windowBarUI:IsOpen() then
            local windowInfo = windowBarUI:GetCurAssociateWindowInfo()
            local topBtnState = {
                ['bGold'] = true,
                ['bSilver'] = true,
            }
            windowInfo.topBtnState = topBtnState;
            windowBarUI:UpdateWindow();
        end
    end
end

function ShoppingMallUI:OnClickTog8(obj)
    self:SetTogDRBtnState(obj);
    self.objBegNode:SetActive(true);
    self.objSCProducts:SetActive(false);
    self.objBeg:SetActive(true);

    SendPlatShopMallReward(PSMRT_QUERY);

    local _func = function(bActive)
        for k, v in pairs(self.objBeg.transform) do
            if v.gameObject.name ~= 'DRButton' then
                v.gameObject:SetActive(bActive);
            end
        end
        self:FindChild(self.objDRBtn, 'Image_chosen'):SetActive(bActive);
    end

    local hideBeg = GetConfig('hideBeg');
    if (not hideBeg) or (hideBeg and hideBeg == 'true') then
        _func(true);
    else
        _func(false);
    end

    self:OnRefWindowBar(obj);
end

function ShoppingMallUI:OnClickTog(obj, clickType)

    self:SetShopItemState();
    self:SetTogDRBtnState(obj);
    self.objBegNode:SetActive(false);
    self.objSCProducts:SetActive(true);
    self.objBeg:SetActive(false);
    self.clickType = clickType;
    self.clickTarget = obj;

    local shopData = self.ShoppingDataManager:GetShopData(self.clickType);
    if shopData then
        self:OnRefUI(true, true);
    else
        SendPlatShopMallQueryItem(self.clickType);
    end

    self:OnRefWindowBar(obj);
end
-- 控制每个接口的红点刷新
-- obj： tog的gameobject
-- clickType： 道具类型 
-- bHide： true:强制隐藏
function ShoppingMallUI:OnRefTogRedPoint(obj,clickType,bHide)
    if not obj then 
        return 
    end 
    local imgRedPoint = self:FindChild(obj,'Image_redpoint')
    if imgRedPoint then 
        if bHide then 
            imgRedPoint:SetActive(false)
        else
            imgRedPoint:SetActive(self.ShoppingDataManager:CheckIfHasFreeRackByType(clickType))
        end 
    end 
end

function ShoppingMallUI:OnRefWindowBar(obj)
    local windowBarUI = GetUIWindow("WindowBarUI");
    if windowBarUI and windowBarUI:IsOpen() then
        local windowInfo = windowBarUI:GetCurAssociateWindowInfo()
        local topBtnState = {
            ['bGoodEvil'] = false,
            ['bGold'] = false,
            ['bSilver'] = false,
            ['bCoin'] = false,
            ['bTreasureBook'] = false,
            ['bJuiQuan'] = false,
            ['bJiFenPlat'] = false,
            ['bJiFenActive'] = false,
            ['bMeridians'] = false,
        }

        if obj == self.objTog1 then
            topBtnState.bGold = true;
            topBtnState.bSilver = true;
        
        elseif obj == self.objTog2 then
            topBtnState.bGold = true;
            topBtnState.bSilver = true;

        elseif obj == self.objTog3 then
            topBtnState.bGold = true;
            topBtnState.bSilver = true;

        elseif obj == self.objTog4 then
            topBtnState.bTreasureBook = true;

        elseif obj == self.objTog5 then
            topBtnState.bJuiQuan = true;

        elseif obj == self.objTog6 then
            topBtnState.bJiFenPlat = true;

        elseif obj == self.objTog7 then
            topBtnState.bJiFenActive = true;

        elseif obj == self.objTog8 then
            topBtnState.bGold = true;
            topBtnState.bSilver = true;

        end
        windowInfo.topBtnState = topBtnState;
        windowBarUI:UpdateWindow();
    end
end

function ShoppingMallUI:OnRefUI(bClickFrist, bMove)

    self:OnRefSCProducts(bMove);
    self:OnRefClickTarget(bClickFrist);
end

function ShoppingMallUI:OnRefClickTarget(bClickFrist)
    if next(self.lvSCBindBtn) then
        local dataIndex = 1;
        if not bClickFrist then
            dataIndex = self.dataIndex > 1 and self.dataIndex or 1;
        end
        self:FindChild(self.lvSCBindBtn[dataIndex], 'DRButton'):GetComponent('Button').onClick:Invoke();
    end
end

function ShoppingMallUI:SetTogDRBtnState(obj)
    for i = 1, #(self.togTable) do
        if obj == self.togTable[i] then
            self:FindChild(self.togTable[i], 'Image_toggle'):SetActive(true);
            self:FindChild(self.togTable[i], 'Lab'):GetComponent('Text').color = clickColor;
        else
            self:FindChild(self.togTable[i], 'Image_toggle'):SetActive(false);
            self:FindChild(self.togTable[i], 'Lab'):GetComponent('Text').color = normalColor;
        end
    end
end

function ShoppingMallUI:OnClickInfoReduceBtn()
    self.buyCount = self.buyCount - 1;
    self.buyCount = self.buyCount < 1 and 1 or self.buyCount;
    self.objInfoNum:GetComponent('Text').text = self.buyCount;
    self:UpdateBuyPrice();
end

function ShoppingMallUI:OnClickInfoAddBtn()
    self.buyCount = self.buyCount + 1;
    local maxCount = self:GetBuyMaxCount();
    self.buyCount = self.buyCount > maxCount and maxCount or self.buyCount;
    self.objInfoNum:GetComponent('Text').text = self.buyCount;
    self:UpdateBuyPrice();
end

function ShoppingMallUI:GetBuyMaxCount()
    local count = 1;
    if self.clickItemData then
        local treasureBook = self.TreasureBookDataManager:GetTreasureBookBaseInfo()
        self.tbMoney = treasureBook.iMoney or 0;
        self.gold = self.PlayerSetDataManager:GetPlayerGold();
        self.sliver = self.PlayerSetDataManager:GetPlayerSliver();
        self.drinkMoney = self.PlayerSetDataManager:GetPlayerDrinkMoney();
        self.jiFenPlat = self.PlayerSetDataManager:GetPlayerPlatScore();
        self.jiFenActive = self.PlayerSetDataManager:GetPlayerActiveScore();

        local price = self.clickItemData.iFinalPrice;

        if price == 0 then
            count = self.clickItemData.iCanBuyCount;
        else
            if self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_GOLD then 
                count = math.floor(self.gold / price);
                
            elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_SILVER then 
                count = math.floor(self.sliver / price);
    
            elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_TREASUREBOOK then 
                count = math.floor(self.tbMoney / price);

            elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_DRINK then 
                count = math.floor(self.drinkMoney / price);

            elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_PLATSCORE then 
                count = math.floor(self.jiFenPlat / price);

            elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_ACTIVITYSCORE then 
                count = math.floor(self.jiFenActive / price);

            end
        end

        -- TODO 其他货币还没有处理
        local iCanBuyCount = 99;
        if self.clickItemData.iCanBuyCount > 0 then
            iCanBuyCount = self.clickItemData.iCanBuyCount;
            count = count > iCanBuyCount and iCanBuyCount or count;
        end

        count = count > 10 and 10 or count;
    end

    return count == 0 and 1 or count;
end

function ShoppingMallUI:OnClickInfoAllBtn(obj)
    self.buyCount = self:GetBuyMaxCount();
    self.objInfoNum:GetComponent('Text').text = self.buyCount;
    self:UpdateBuyPrice();
end

function ShoppingMallUI:OnClickState1BuyBtn(obj)

    if self.clickItemData then
    
        if self.clickItemData.iCanBuyCount == 0 then
            SystemUICall:GetInstance():Toast('已超购买上限!');
            return;
        end

        local money, moneyName = self:CheckMoney();
        if money then

            local playerid = tostring(globalDataPool:getData("PlayerID"));
            local boxCallback = function()
                self.clickSendBtn = true;
                SendPlatShopMallBuyItem(self.clickItemData.uiShopID, self.buyCount);
            end
            local _callback = function()
                local generalBoxUI = GetUIWindow('GeneralBoxUI');
                if generalBoxUI and generalBoxUI:GetCheckBoxState() then
                    SetConfig(playerid .. '#HideShoppingMallTips', true);
                end
                boxCallback();
            end
            
            if GetConfig(playerid .. '#HideShoppingMallTips') then
                boxCallback();
            else
                local price = self.clickItemData.iFinalPrice * self.buyCount;
                if (price == 0) then
                    boxCallback()
                    return
                end            

                local itemData = self.ItemDataManager:GetItemTypeDataByTypeID(self.clickItemData.uiItemID);
                if itemData then
                    local color = RANK_COLOR_STR[itemData.Rank] or '#FFFFFF';
                    local name = itemData.ItemName or ''
                    local strText = string.format('是否花费%s%s购买%d个<outline=%s>%s</outline>？', tostring(price) ,moneyName, self.buyCount, color, name);
                    OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strText, _callback, { confirm = 1, close = 1, checkBox = 1 } });
                end
            end
        else
            SystemUICall:GetInstance():Toast(moneyName .. '不足!');
        end
    end

end

function ShoppingMallUI:CheckMoney()
    local moneyName = '货币';
    if self.clickItemData then
        local money = 0;
        if self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_GOLD then 
            money = self.PlayerSetDataManager:GetPlayerGold();
            moneyName = '金锭';

        elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_SILVER then 
            money = self.PlayerSetDataManager:GetPlayerSliver();
            moneyName = '银锭';

        elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_TREASUREBOOK then 
            local TBBaseInfo = self.TreasureBookDataManager:GetTreasureBookBaseInfo();
            money = TBBaseInfo.iMoney or 0;
            moneyName = '百宝书残页';

        elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_DRINK then 
            money = self.PlayerSetDataManager:GetPlayerDrinkMoney();
            moneyName = '擂台币';

        elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_PLATSCORE then 
            money = self.PlayerSetDataManager:GetPlayerPlatScore();
            moneyName = '资源值';

        elseif self.clickItemData.uiMoneyType == RackItemMoneyType.RIMT_ACTIVITYSCORE then 
            money = self.PlayerSetDataManager:GetPlayerActiveScore();
            moneyName = '活动积分';

        end

        local price = self.clickItemData.iFinalPrice;
        if money >= self.buyCount * price then
            return true, moneyName;
        else
            return false, moneyName;
        end
    end
    return false, moneyName;
end

function ShoppingMallUI:SetRightInfo()

end

function ShoppingMallUI:OnClickState2BuyBtn(obj)
    self:OnClickState1BuyBtn(obj);
end

function ShoppingMallUI:OnClickBegPromiseBtn(obj)
    self.objGet:SetActive(true);
    if not self.uiGet then
        self.uiGet = ShoppingMallUIGet.new(self);
        self.uiGet:OnCreate();
    else
        self.uiGet:RefreshUI();
    end
end

function ShoppingMallUI:OnClickBegFormulaBtn(obj)
    self.objPlayerList:SetActive(true);
    if not self.uiName then
        self.uiName = ShoppingMallUIName.new(self);
        self.uiName:OnCreate();
    else
        self.uiName:RefreshUI();
    end
end

function ShoppingMallUI:OnClickBegGiveBtn(obj)
    local _netMessage = function()
        SendPlatShopMallReward(PSMRT_MONEY);
    end

    local rewardTime = self.PlayerSetDataManager:GetShopGoldRewadTime(); 
    if rewardTime and rewardTime > 0 and MSDKHelper:IsSameDay(rewardTime, GetCurServerTimeStamp()) then
        SystemUICall:GetInstance():Toast('感谢您的打赏，支持《我的侠客》');
    else
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '是否给《我的侠客》项目组无偿打赏1金锭?', _netMessage });
    end

    -- SystemUICall:GetInstance():Toast('暂未开放');
end

function ShoppingMallUI:OnClickBegADBtn(obj)
    local _netMessage = function()
        SendPlatShopMallReward(PSMRT_AD);

        local binData, iCmd = EncodeSendSeCGA_TLogUpdate(STLNT_WatchADSFlow, '');
        SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
        --CS.UnityEngine.Application.OpenURL("https://wiki.biligame.com/wodexiake");

        MSDKHelper:OpenCommunity();
    end

    local rewardTime = self.PlayerSetDataManager:GetShopAdRewadTime();
    if rewardTime and rewardTime > 0 and MSDKHelper:IsSameDay(rewardTime, GetCurServerTimeStamp()) then
        SystemUICall:GetInstance():Toast('感谢您看广告，支持《我的侠客》');
    else
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '项目组暂时未接入广告，跳转到微社区\n也算打赏一次！', _netMessage });
    end  

    -- SystemUICall:GetInstance():Toast('暂未开放');
end

function ShoppingMallUI:OnClickDRBtn(obj)

    local _func = function(bActive)
        -- for k, v in pairs(self.objBeg.transform) do
        --     if v.gameObject.name ~= 'DRButton' then
        --         v.gameObject:SetActive(bActive);
        --     end
        -- end
        self:FindChild(self.objDRBtn, 'Image_chosen'):SetActive(bActive);
    end

    local hideBeg = GetConfig('hideBeg');
    if (not hideBeg) or (hideBeg and hideBeg == 'true') then
        SetConfig('hideBeg', 'false');
        self.objTog8:SetActive(false);
        self.objBeg:SetActive(false);
        
        _func(false);
    else
        SetConfig('hideBeg', 'true');
        self.objTog8:SetActive(true);
        self.objBeg:SetActive(true);

        _func(true);
    end

    self:AutoChooseTag();
end

function ShoppingMallUI:OnClickState2PreviewBtn(obj)
    if self.clickItemData then
        local itemData = self.ItemDataManager:GetItemTypeDataByTypeID(self.clickItemData.uiItemID);
        if itemData.ItemType == ItemTypeDetail.ItemType_Poetry then
            local data = self.PlayerSetDataManager:GetPlayerInfoData(PlayerInfoType.PIT_POERTY, itemData.Value1);
            self:PreviewPoetry(data);
        elseif itemData.ItemType == ItemTypeDetail.ItemType_Platform then
            local data = self.PlayerSetDataManager:GetPlayerInfoData(PlayerInfoType.PIT_PEDESTAL, itemData.Value1);
            self:PreviewPlatform(data);
        end
    end
end

function ShoppingMallUI:PreviewPoetry(data)
    self.PoemShowCom:RefreshUI({TB = data});
end

function ShoppingMallUI:PreviewPlatform(data)
    if data.PicType == 0 then
        if not self.uiPreviewPlatS then
            self.uiPreviewPlatS = ShoppingMallUIPreviewPlatS.new(self);
            self.uiPreviewPlatS:OnCreate(data);
        else
            self.uiPreviewPlatS:RefreshUI(data);
        end
        self.objPlatPreviewS:SetActive(true);
    elseif data.PicType == 1 then
        if not self.uiPreviewPlatB then
            self.uiPreviewPlatB = ShoppingMallUIPreviewPlatB.new(self);
            self.uiPreviewPlatB:OnCreate(data);
        else
            self.uiPreviewPlatB:RefreshUI(data);
        end
        self.objPlatPreviewB:SetActive(true);
    end
end

function ShoppingMallUI:SetTabState(data)
    if self.clickItemData then
        local unlock = globalDataPool:getData('UnlockPool');
        local reckData = self.ShoppingDataManager:GetRackData(self.clickItemData.uiShopID);
        local itemData = self.ItemDataManager:GetItemTypeDataByTypeID(self.clickItemData.uiItemID);
        local storageData = self.StorageDataManager:GetItemDataByTypeID(self.clickItemData.uiItemID);
        local price = self.clickItemData.iFinalPrice;
        local money, moneyName = self:CheckMoney();

        self.objInfoName:GetComponent('Text').text = itemData.ItemName or ''
        self.objInfoName:GetComponent('Text').color = getRankColor(itemData.Rank);
        self.objInfoTextPricePrevious:GetComponent('Text').text = self.clickItemData.iPrice;
        self.objInfoTextPriceNow:GetComponent('Text').text = price;
        self.objInfoNum:GetComponent('Text').text = 1;
        
        -- TODO
        local previous1 = self:FindChild(self.objState1BuyBtn, 'Image/Text_price_previous');
        local previous2 = self:FindChild(self.objState2BuyBtn, 'Image/Text_price_previous');
        previous1:SetActive(false);
        previous2:SetActive(false);

        local comState1BuyBtnText = self:FindChildComponent(self.objState1BuyBtn, 'Image/Num', 'Text');
        local comState2BuyBtnText = self:FindChildComponent(self.objState2BuyBtn, 'Image/Num', 'Text');
        comState1BuyBtnText.text = price;
        comState1BuyBtnText.color = money and whiteColor or redColor;
        comState2BuyBtnText.text = price;
        comState2BuyBtnText.color = money and whiteColor or redColor;

        local strText = string.format('%0.1f', self.clickItemData.iDiscount / 10) .. '折';
        if self.clickItemData.iDiscount == 0 then
            strText = '免费';
        else
            if self.clickItemData.iDiscount < 100 then
                previous1:SetActive(true);
                previous2:SetActive(true);

                previous1:GetComponent('Text').text = self.clickItemData.iPrice;
                previous1:GetComponent('Text').color = whiteColor;
                previous2:GetComponent('Text').text = self.clickItemData.iPrice;
                previous2:GetComponent('Text').color = whiteColor;

                comState1BuyBtnText.text = price;
                comState1BuyBtnText.color = money and whiteColor or redColor;
                comState2BuyBtnText.text = price;
                comState2BuyBtnText.color = money and whiteColor or redColor;
            end
        end

        -- TODO 精铁，完美粉，忘忧草
        --[[
            30951	1010854	精铁
            30941	1010853	完美粉
            9626	1010857	忘忧草
            9620	1010857	冲灵丹
            1601	1010857	小侠客
            9698    10020008 、10020003 幸运珠
        ]]

        local itemNum = storageData and storageData.uiItemNum or 0;
        if itemData.BaseID == 30951 then
            itemNum = self.PlayerSetDataManager:GetPlayerRefinedIron();
        elseif itemData.BaseID == 30941 then
            itemNum = self.PlayerSetDataManager:GetPlayerPerfectPowder();
        elseif itemData.BaseID == 9626 then
            itemNum = self.PlayerSetDataManager:GetPlayerWangyoucao();
        elseif itemData.BaseID == 9620 then
            itemNum = self.MeridiansDataManager:GetCurTotalBreak();
        elseif itemData.BaseID == 1601 then
            local pool = self.PinballDataManager:GetPoolBaseInfoWithType(1);
            itemNum = pool and pool.dwCurPoolHoodleNum or 0;
        elseif itemData.BaseID == 9698 then
            itemNum = self.PlayerSetDataManager:GetPlayerRefreshBall() or 0
        end
        self:FindChildComponent(self.objInfoDiscount, 'Text', 'Text').text = strText;
        self:FindChildComponent(self.objInfoTextOwn, 'Text_value', 'Text').text = itemNum;
        self:FindChildComponent(self.objInfoTextLimit, 'Text_value', 'Text').text = self.clickItemData.iCanBuyCount;
        self:FindChildComponent(self.objInfoTextReset, 'Text', 'Text').text = shopBuyLimitResetTypeRevert[self.clickItemData.iMaxBuyNumsPeriod];
        self.objInfoTextReset:SetActive(self.clickItemData.iMaxBuyNumsPeriod > 0);
        
        --
        if self.clickItemData.iCanBuyCount >= 0 then
            self.objInfoTextLimit:SetActive(true);
        else
            self.objInfoTextLimit:SetActive(false);
        end

        --
        local bCanBuy = false;
        if self.clickItemData.Type == RackItemType.RIT_CANZHANG then
            local TB_Clan = TableDataManager:GetInstance():GetTable("Clan");
            if (unlock and unlock[PlayerInfoType.PIT_CLAN] and unlock[PlayerInfoType.PIT_CLAN][self.clickItemData.iNeedUnlockID]) or
            (TB_Clan and TB_Clan[self.clickItemData.iNeedUnlockID] and TB_Clan[self.clickItemData.iNeedUnlockID].ClanLock == ClanLock.CLL_JoinClan)
            then
                bCanBuy = true;
            end
        end
        
        if (not bCanBuy and self.clickItemData.Type == RackItemType.RIT_CANZHANG) or (self.clickItemData.iCanBuyCount == 0) then
            self.objState1BuyBtn:GetComponent('Button').enabled = false;
            self.objState2BuyBtn:GetComponent('Button').enabled = false;

            setUIGray(self.objState1BuyBtn:GetComponent('Image'), true);
            setUIGray(self.objState2BuyBtn:GetComponent('Image'), true);
        else
            self.objState1BuyBtn:GetComponent('Button').enabled = true;
            self.objState2BuyBtn:GetComponent('Button').enabled = true;

            setUIGray(self.objState1BuyBtn:GetComponent('Image'), false);
            setUIGray(self.objState2BuyBtn:GetComponent('Image'), false);
        end

        --
        local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, itemData);
        for w in string.gmatch(tips.content, '#(%w+)>') do
            tips.content = string.gsub(tips.content, w, '000000');
        end
        self.objInfoItemTips:GetComponent('Text').text = tips.content;

        --
        local _SetActive = function(bActive)
            -- self.objInfoText:SetActive(bActive);
            -- self.objInfoMoneyNode:SetActive(bActive);
            -- self.objInfoTextPricePrevious:SetActive(bActive);
            self.objInfoDiscount:SetActive(bActive);
        end
        if self.clickItemData.iDiscount == 100 then
            _SetActive(false);
        else
            _SetActive(true);
        end

        --
        local _setMoneyType = function(gameObject, data)
            local _setMoneyTypeState = function(strName)
                for k, v in pairs(gameObject.transform) do
                    if v.gameObject.name ~= 'Num' then
                        if v.gameObject.name == strName then
                            v.gameObject:SetActive(true);
                        else
                            v.gameObject:SetActive(false);
                        end
                    end
                end
            end
    
            if data.uiMoneyType == RackItemMoneyType.RIMT_GOLD then 
                _setMoneyTypeState('Image_JinDing');
                
            elseif data.uiMoneyType == RackItemMoneyType.RIMT_SILVER then 
                _setMoneyTypeState('Image_YinDing');
                
            elseif data.uiMoneyType == RackItemMoneyType.RIMT_TREASUREBOOK then 
                _setMoneyTypeState('Image_CanYe');
                
            elseif data.uiMoneyType == RackItemMoneyType.RIMT_DRINK then 
                _setMoneyTypeState('Image_JiuQuan');
                
            elseif data.uiMoneyType == RackItemMoneyType.RIMT_PLATSCORE then 
                _setMoneyTypeState('Image_Ziyuan');
            
            elseif data.uiMoneyType == RackItemMoneyType.RIMT_ACTIVITYSCORE then 
                _setMoneyTypeState('Image_JiFen');
                
            end   
        end
        
        local objState1MoneyNode = self:FindChild(self.objState1BuyBtn, 'Image/Money_node');
        local objState2MoneyNode = self:FindChild(self.objState2BuyBtn, 'Image/Money_node');
        _setMoneyType(objState1MoneyNode, self.clickItemData);
        _setMoneyType(objState2MoneyNode, self.clickItemData);
        -- _setMoneyType(self.objInfoMoneyNode, self.clickItemData);

        --
        if itemData.ItemType == ItemTypeDetail.ItemType_Poetry or
        itemData.ItemType == ItemTypeDetail.ItemType_Platform
        then
            self.objState1:SetActive(false);
            self.objState2:SetActive(true);
        else
            self.objState1:SetActive(true);
            self.objState2:SetActive(false);
        end

        --
        ReBuildRect(self:FindChild(self.objState1BuyBtn, 'Image'));
        ReBuildRect(self:FindChild(self.objState2BuyBtn, 'Image'));
    end
end

function ShoppingMallUI:UpdateBuyPrice()
    if self.clickItemData then
        local price = self.clickItemData.iFinalPrice;
        local comState1BuyBtnText = self:FindChildComponent(self.objState1BuyBtn, 'Image/Num', 'Text');
        local comState2BuyBtnText = self:FindChildComponent(self.objState2BuyBtn, 'Image/Num', 'Text');
        comState1BuyBtnText.text = price * self.buyCount;
        comState2BuyBtnText.text = price * self.buyCount;
    end
end

function ShoppingMallUI:SetPayTag()
    self.objTogPay:GetComponent('Toggle').isOn = true;
    self:OnClickTogPay(nil,true)
end

function ShoppingMallUI:OnRefBeg()
    local begValue = self.ShoppingDataManager:GetBegValue();
    local selfBegValue = self.ShoppingDataManager:GetSelfBegValue();
    local nextData = self.ShoppingDataManager:GetNextGetData();
    local percent = begValue / nextData.NeedMoney;
    self.objBegTextAll:GetComponent('Text').text = '总计打赏额:' .. begValue;
    self.objBegTextMine:GetComponent('Text').text = '我的打赏额:' .. selfBegValue;
    self.objBegSlider:GetComponent('Slider').value = percent * 0.75;

    self.objBegTextNum1:GetComponent('Text').text = '目标:' .. nextData.NeedMoney;
    self.objBegTextNum2:GetComponent('Text').text = '承诺:' .. GetLanguageByID(nextData.LanguageID);
end

function ShoppingMallUI:SetTogState(data)
    -- self.downCount = self.downCount + 1;
    if self.togTable[data.uiType + 1] then
        local luaTable = table_c2lua(data.auiValidRacks);
        for i = 1, #(self.togTable) do
            local bFind = false
            for j = 1, #(luaTable or {}) do
                if luaTable[j] + 1 == i then
                    bFind = true;
                end
            end

            self.togTable[i]:SetActive(bFind)

            -- table 内容为 {8,1,2，...} 所以减了1
            local eRackItemType = i - 1
            if bFind then 
                local maptog_type = {
                    [RackItemType.RIT_ITEM] = true ,
                    [RackItemType.RIT_CANZHANG] = true ,
                    [RackItemType.RIT_DRINK] = true ,
                    [RackItemType.RIT_EXCHANGE] = true ,
                    [RackItemType.RIT_ACTIVITY] = true ,
                }
                -- 不确定为什么只控制了这几个类型的页签的显示，先保留这部分逻辑
                if maptog_type[eRackItemType] then 
                    self.togTable[i]:SetActive(self.ShoppingDataManager:CheckIfUITogShow(eRackItemType))
                end 
                -- 现在红点只针对道具，可以拓展，传类型就行
                if eRackItemType == RackItemType.RIT_ITEM then 
                    self:OnRefTogRedPoint(self.togTable[i],eRackItemType)
                else
                    self:OnRefTogRedPoint(self.togTable[i],nil,true)
                end
            end
        end

        -- if getTableSize2(data.akItem) == 0 then
        --     self.togTable[data.uiType + 1]:SetActive(false);
        -- else
        --     self.togTable[data.uiType + 1]:SetActive(true);
        -- end
    end

    local hideBeg = GetConfig('hideBeg');
    if (not hideBeg) or (hideBeg and hideBeg == 'true') then
        self.objTog8:SetActive(true)
    else
        self.objTog8:SetActive(false);
    end

    -- if self.downCount == getTableSize2(RackItemType) - 1 then
    --     self:AutoChooseTag();
    -- end

    if self.bFrist then
        self.bFrist = false;
        self:AutoChooseTag();
    end
        
    -- if self.clickSendBtn then
        -- self.clickSendBtn = false;
        -- local newData = self.ShoppingDataManager:GetShopDataBy(self.clickItemData.uiShopID);
        -- -- newData.bCanBuy = self.clickItemData.bCanBuy;
        -- self.clickItemData = newData;
        -- self:SetTabState();

        self:OnRefUI(false, false);
    -- end
end

function ShoppingMallUI:AutoChooseTag()
    local index = 1;
    local hideBeg = GetConfig('hideBeg');
    if (hideBeg and hideBeg == 'false') then
        index = 2;
    end

    while not self.togTable[index].activeSelf do
        index = index + 1;
        if index > getTableSize2(RackItemType) - 1 then
            break;
        end
    end

    if self.pageIndex and self.pageIndex > 0 and self.togTable[self.pageIndex] then
        index = self.pageIndex; 
    end
    self:OnclickBtn(self.togTable[index]);
end

function ShoppingMallUI:RequestItemInfo()
    if self.clickType then
        SendPlatShopMallQueryItem(self.clickType);
    end
end

function ShoppingMallUI:OnEnable()
    self:AddEventListener('ONEVENT_REF_SHOPDATA', function(info)
        self:SetTogState(info);
    end);

    self:AddEventListener('ONEVENT_REF_BEGDATA', function(info)
        self:OnRefBeg();
    end);

    LuaEventDispatcher:dispatchEvent("ShoppingMallUI",1)
    local topBtnState = {
        ['bBackBtn'] = true,
        ['bGold'] = true,
        ['bSilver'] = true,
    }

    local callback = function()

    end
    local info = {
        ['windowstr'] = "ShoppingMallUI", 
        --['titleName'] = "商城",
        ['topBtnState'] = topBtnState,
        ['callback'] = callback;
    }
    OpenWindowBar(info);
    local windowBarUI = GetUIWindow('WindowBarUI');
    if windowBarUI and windowBarUI:IsOpen() then
        windowBarUI:SetBGType(2);
    end
end

function ShoppingMallUI:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_SHOPDATA');
    self:RemoveEventListener('ONEVENT_REF_BEGDATA');

    local windowBarUI = GetUIWindow('WindowBarUI');
    if windowBarUI and windowBarUI:IsOpen() then
        windowBarUI:SetBGType(1);
    end
    RemoveWindowBar('ShoppingMallUI')
    LuaEventDispatcher:dispatchEvent("ShoppingMallUI",0)
end

function ShoppingMallUI:OnDestroy()
    if self.lvSCProducts then
        self.lvSCProducts.mOnBeginDragAction = nil;
        self.lvSCProducts.mOnDragingAction = nil;
        self.lvSCProducts.mOnEndDragAction = nil;
        self.lvSCProducts.mOnGetItemByIndex = nil;
    end

    self.ItemIconUI:Close();
    self.PoemShowCom:Close();
    if self.uiGet then
        self.uiGet:Close();
    end
    if self.uiName then
        self.uiName:Close();
    end
    if self.uiPreviewPlatS then
        self.uiPreviewPlatS:Close();
    end
    if self.uiPreviewPlatB then
        self.uiPreviewPlatB:Close();
    end
end

function ShoppingMallUI:UpdateFirstRechargeInfo(ans)
    for i=1,#charge do
        if ans[i] then 
            self.objFirstInfos[i]:SetActive(true)
        else
            self.objFirstInfos[i]:SetActive(false)
        end
    end
end

function ShoppingMallUI:GetTimeLeftStr(time)
    time = time or 0
    local d = math.floor(time / 60 / 60 / 24)
    local h = math.floor(time / 60 / 60) % 24
    local m = math.floor(time / 60) % 60
    local s = math.floor(time) % 60

    if d > 0 then
        return string.format('剩余：%d天', d)
    end
    if h > 0 then
        return string.format('剩余：%d小时', h)
    end
    if m > 0 then
        return string.format('剩余：%d分钟', m)
    end
    return string.format('即将结束')
end
return ShoppingMallUI;