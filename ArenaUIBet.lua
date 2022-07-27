ArenaUIBet = class('ArenaUIBet', BaseWindow);

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

local whiteColor = DRCSRef.Color(1, 1, 1, 1);
local blackColor = DRCSRef.Color(0x2C / 255, 0x2C / 255, 0x2C / 255, 1);

local TB_Bet = {
    [1] = {
        num = 0,
        stage = 3 ,
        text = '言语鼓励',
        cond = 0,
        itemID = 8001,
    },
    [2] = {
        num = 50,
        stage = 3 ,
        text = '请他喝茶',
        cond = 0,
        itemID = 8002,
    },
    [3] = {
        num = 200,
        stage = 3 ,
        text = '珍馐佳肴',
        cond = 0,
        itemID = 8003,
    },
    [4] = {
        num = 1000,
        stage = 7 ,
        text = '敲锣打鼓',
        cond = 16,
        itemID = 8004,
    },
    [5] = {
        num = 10000,
        stage = 11 ,
        text = '舞龙舞狮',
        cond = 4,
        itemID = 8005,
    },
}

local TextDec = '我若获胜，将送你<color=#913E2B>%d擂台币</color>作为谢礼！^_^~\n我若失败，也有残章相赠聊以慰藉。' ;

function ArenaUIBet:ctor(info)
    self._script = info;
    self.bindBtnTable = {};
    self.greenBtnTable = {};
end

function ArenaUIBet:Create()
    local arenaUI = GetUIWindow('ArenaUI');
    if arenaUI and arenaUI:IsOpen() then
        local obj = LoadPrefabAndInit('ArenaUI/Bet', arenaUI.objArenaUIBet or UI_UILayer, true);
        if obj then
            self:SetGameObject(obj);
            local objParent = arenaUI._gameObject
            local canvasParent = objParent:GetComponent(DRCSRef_Type.Canvas)
            local uiParentSort = canvasParent.sortingOrder
            local canvasSelf = obj:GetComponent(DRCSRef_Type.Canvas)
            canvasSelf.sortingOrder = uiParentSort + 100
        end
    end
end

function ArenaUIBet:Init()

    self.TableDataManager = TableDataManager:GetInstance():GetTable("RoleModel");
    self.ArenaDataManager = ArenaDataManager:GetInstance();
    self.ItemIconUI = ItemIconUI.new();

    --
    self.objImageMask = self:FindChild(self._gameObject, 'Image_Mask');
    self.objImageTop = self:FindChild(self._gameObject, 'Image_Top');
    self.objImageBot = self:FindChild(self._gameObject, 'Image_Bot');
    self.objImageBet = self:FindChild(self._gameObject, 'Image_Bet');
    self.objDRBtn = self:FindChild(self._gameObject, 'DRButton');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');
    
    --
    self.objGreenBtn1 = self:FindChild(self.objImageBet, 'Button_green_1');
    self.objGreenBtn2 = self:FindChild(self.objImageBet, 'Button_green_2');
    self.objGreenBtn3 = self:FindChild(self.objImageBet, 'Button_green_3');
    self.objGreenBtn4 = self:FindChild(self.objImageBet, 'Button_green_4');
    self.objGreenBtn5 = self:FindChild(self.objImageBet, 'Button_green_5');
    
    --
    self.objHead = self:FindChild(self.objImageTop, 'Head');
    self.objTextName = self:FindChild(self.objImageTop, 'Text_Name');
    self.objTextDec = self:FindChild(self.objImageTop, 'Text_Dec');

    --
    table.insert(self.greenBtnTable, self.objGreenBtn1);
    table.insert(self.greenBtnTable, self.objGreenBtn2);
    table.insert(self.greenBtnTable, self.objGreenBtn3);
    table.insert(self.greenBtnTable, self.objGreenBtn4);
    table.insert(self.greenBtnTable, self.objGreenBtn5);

    for i = 1, #(self.greenBtnTable) do
        local objBtn = self:FindChild(self.greenBtnTable[i], 'Button');
        table.insert(self.bindBtnTable, objBtn);
    end

    --
    table.insert(self.bindBtnTable, self.objImageMask);
    table.insert(self.bindBtnTable, self.objDRBtn);
    table.insert(self.bindBtnTable, self.objCloseBtn);

    self:BindBtnCB();

end

function ArenaUIBet:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUIBet:OnclickBtn(obj, boolHide)
    if obj == self.objImageMask or obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    elseif obj == self.objDRBtn then
        self:OnClickDRBtn(obj);

    elseif obj.transform.parent.parent.gameObject == self.objImageBet then
        self:OnClickGreenBtn(obj);

    end

end

function ArenaUIBet:OnClickDRBtn(obj)

    local betData = self.betData;
    local battleData = self.info.battleData;
    local tempData = self.info.tempData;
    local serverData = self.info.serverData;

    local _netMessage = function()
        SendRequestArenaMatchBet(serverData.dwMatchType, 
            serverData.dwMatchID, 
            battleData.dwBattleID, 
            battleData.dwRoundID, 
            tempData.defPlayerID, 
            betData.num, 
            tempData.acPlayerName
        );
        
        self.ArenaDataManager:SetBetFlag(1);
        self:OnClickCloseBtn();

        -- TODO 数据上报
        MSDKHelper:SetQQAchievementData('arenabet', betData.num);
        MSDKHelper:SendAchievementsData('arenabet');
    end

    local silver = PlayerSetDataManager:GetInstance():GetPlayerSliver();
    local itemData = StorageDataManager:GetInstance():GetItemDataByTypeID(betData.itemID);

    if betData.itemID == 8001 or (itemData and itemData.uiItemNum > 0) then
        _netMessage();
    else
        local strText = '确定花费' .. betData.num .. '银锭购买' .. betData.text .. '为' .. tempData.acPlayerName .. '助威吗?';
        local _callback = function()
            if betData.num > 0 and betData.num > silver then
                PlayerSetDataManager.GetInstance():RequestSpendSilver(betData.num,function()
                    _netMessage();
                end)
                --SystemUICall:GetInstance():Toast('银锭不足');
            else
                _netMessage();
            end
        end
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, strText, _callback });
    end
end

function ArenaUIBet:OnClickGreenBtn(obj)

    self:SetBetBtnState(obj);
    
    local betData = TB_Bet[1];
    if obj.transform.parent.gameObject == self.objGreenBtn1 then
        betData = TB_Bet[1];
        
    elseif obj.transform.parent.gameObject == self.objGreenBtn2 then
        betData = TB_Bet[2];
    
    elseif obj.transform.parent.gameObject == self.objGreenBtn3 then
        betData = TB_Bet[3];
    
    elseif obj.transform.parent.gameObject == self.objGreenBtn4 then
        betData = TB_Bet[4];
    
    elseif obj.transform.parent.gameObject == self.objGreenBtn5 then
        betData = TB_Bet[5];
        
    end

    self.betData = betData;
    local tempData = self.info.tempData;
    local battleData = self.info.battleData;
    local serverData = self.info.serverData;

    if betData.cond ~= 0 and betData.cond < self.info.serverData.dwRoundID then
        SystemUICall:GetInstance():Toast('条件不满足');
        self.objDRBtn:GetComponent('Button').enabled = false;
        setUIGray(self.objDRBtn:GetComponent('Image'), true);
    else
        if betData.num == 10000 then
            if serverData.dwMatchType == 3 or serverData.dwMatchType == 4 then
                SystemUICall:GetInstance():Toast('条件不满足');
                self.objDRBtn:GetComponent('Button').enabled = false;
                setUIGray(self.objDRBtn:GetComponent('Image'), true);
            end
        else
            self.objDRBtn:GetComponent('Button').enabled = true;
            setUIGray(self.objDRBtn:GetComponent('Image'), false);
        end
    end

    self:RefBetText();
end

function ArenaUIBet:RefBetText()

    local tempData = self.info.tempData;
    local battleData = self.info.battleData;
    local serverData = self.info.serverData;

    local comDecText = self.objTextDec:GetComponent('Text');
    local num = self.betData.num;
    if tempData.defPlayerID == battleData.kPly1Data.defPlayerID then
        if num ~= 0 then
            local totalMoney = battleData.dwPly1BetRate + battleData.dwPly2BetRate + num;
            local betRate = (totalMoney * 0.9) / (battleData.dwPly1BetRate + num);
            betRate = betRate < 1.01 and 1.01 or betRate;
            num = math.ceil(num * betRate);
        end
    elseif tempData.defPlayerID == battleData.kPly2Data.defPlayerID then
        if num ~= 0 then
            local totalMoney = battleData.dwPly1BetRate + battleData.dwPly2BetRate + num;
            local betRate = (totalMoney * 0.9) / (battleData.dwPly2BetRate + num);
            betRate = betRate < 1.01 and 1.01 or betRate;
            num = math.ceil(num * betRate);
        end
    end
    num = num == 0 and 5 or num;
    comDecText.text = string.format(TextDec, num);
end

function ArenaUIBet:SetBetBtnState(gameObject)
    for i = 1, #(self.greenBtnTable) do
        local objBtn = self:FindChild(self.greenBtnTable[i], 'Button');
        local objTextDec = self:FindChild(self.greenBtnTable[i], 'Text_Dec');
        if gameObject == objBtn then
            self:FindChild(objBtn, 'Image_choosen'):SetActive(true);
            objTextDec:GetComponent('Text').color = whiteColor;
        else
            self:FindChild(objBtn, 'Image_choosen'):SetActive(false);
            objTextDec:GetComponent('Text').color = blackColor;
        end
    end
end

function ArenaUIBet:OnClickCloseBtn(obj)
    RemoveWindowImmediately("ArenaUIBet");
end

function ArenaUIBet:RefreshUI(info)

    self.info = info;
    self:OnRefUI();

    --
    self:OnClickGreenBtn(self:FindChild(self.objGreenBtn1, 'Button'));
end

function ArenaUIBet:OnRefUI()

    if not self.info then
        return;
    end

    local tempData = self.info.tempData;
    local serverData = self.info.serverData;
    local battleData = self.info.battleData;

    --
    for i = 1, #(self.greenBtnTable) do
        local betData = TB_Bet[i];
        if betData then
            local gameObject = self.greenBtnTable[i];
            local itemIconUI = self:FindChild(gameObject, 'ItemIconUI');
            local drBtn = self:FindChild(gameObject, 'DRButton');
            local textDec = self:FindChild(gameObject, 'Text_Dec');
            local textTips = self:FindChild(gameObject, 'Text_Tips');
            textTips:SetActive(true);
    
            gameObject:SetActive(true);
            -- if serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
            --     if betData.num == 10000 then
            --         gameObject:SetActive(false);
            --     end
            -- end
    
            if betData.cond == 0 or betData.cond >= self.info.serverData.dwRoundID then
                if betData.num == 10000 then
                    if serverData.dwMatchType >= ARENA_TYPE.DA_SHI then
                        textTips:SetActive(false);
                    end
                else
                    textTips:SetActive(false);
                end
            end
    
            local itemTypeData = StorageDataManager:GetInstance():GetItemTypeDataByTypeID(betData.itemID);
            local itemData = StorageDataManager:GetInstance():GetItemDataByTypeID(betData.itemID);
            local itemNum = itemData and itemData.uiItemNum or 0;
            itemNum = i == 1 and 99 or itemNum;
            self.ItemIconUI:UpdateUIWithItemTypeData(itemIconUI, itemTypeData);
            self.ItemIconUI:SetItemNum(itemIconUI, itemNum);
    
            --
            local _callback = function(gameObject)
                local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, itemTypeData);
                OpenWindowImmediately("TipsPopUI", tips);
            end
            self:CommonBind(drBtn, _callback);
        end
    end

    local comNameText = self.objTextName:GetComponent('Text');
    comNameText.text = serverData.acPlayerName;

    --
    local objHeadImage = self:FindChild(self.objHead, 'Mask/Image');
    local callback = function(sprite)
        local uiWindow = GetUIWindow("ArenaUIBet")
        if (uiWindow and objHeadImage) then
            local comImage = objHeadImage:GetComponent('Image');
            comImage.sprite = sprite;
        end
    end
    GetHeadPicByData(serverData,callback)
end

function ArenaUIBet:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_BETDATA');

end

function ArenaUIBet:OnEnable()
    self:AddEventListener('ONEVENT_REF_BETDATA', function(info)
        self:OnRefBetText(info);
    end);

end

function ArenaUIBet:OnRefBetText(data)
    if not data then
        return;
    end
    for i = 1, #(data) do
        if data[i].dwRoundID == self.info.battleData.dwRoundID and
        data[i].dwBattleID == self.info.battleData.dwBattleID
        then
            self.info.battleData = data[i];
            if self.info.tempData.defPlayerID == data[i].kPly1Data.defPlayerID then
                self.info.tempData = data[i].kPly1Data;
            elseif self.info.tempData.defPlayerID == data[i].kPly2Data.defPlayerID then
                self.info.tempData = data[i].kPly2Data;
            end
            self:RefBetText();
            break;
        end
    end
end

function ArenaUIBet:OnDestroy()
    self.ItemIconUI:Close();
end

return ArenaUIBet;