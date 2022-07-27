RankUI = class('RankUI', BaseWindow);

local clickColor = DRCSRef.Color(0.91, 0.91, 0.91, 1);
local normalColor = DRCSRef.Color(0.3, 0.3, 0.3, 1);

local maxRankMember = 10;

function RankUI:ctor()
    self.bindBtnTable = {};

    self.objTOP = nil;
    self.objBOT = nil;
    self.clickTogData = {};
    self.listViewItemName = '';
    self.itemType = 2;
    self.isClickOtherTog = false;
end

function RankUI:Create()
	local obj = LoadPrefabAndInit('RankUI/RankUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
	end
end

function RankUI:Init()

    self.RankDataManager = RankDataManager:GetInstance();
    self.SocialDataManager = SocialDataManager:GetInstance();

    self.objLeft = self:FindChild(self._gameObject, 'Left');
    self.objRight = self:FindChild(self._gameObject, 'Right');
    self.objCloseBtn = self:FindChild(self._gameObject, 'Button_close');

    --
    self.objSCLeft = self:FindChild(self.objLeft, 'SC_Left');
    self.objSCLeftContent = self:FindChild(self.objSCLeft, 'Viewport/Content');
    self.transSCLeftContent = self.objSCLeftContent.transform

    --
    self.objTOP_2 = self:FindChild(self.objRight, 'TOP_2');
    self.objTOP_3 = self:FindChild(self.objRight, 'TOP_3');
    self.objTOP_4 = self:FindChild(self.objRight, 'TOP_4');
    self.objTOP_5 = self:FindChild(self.objRight, 'TOP_5');
    
    --
    self.objBOT_2 = self:FindChild(self.objRight, 'BOT_2');
    self.objBOT_3 = self:FindChild(self.objRight, 'BOT_3');
    self.objBOT_4 = self:FindChild(self.objRight, 'BOT_4');
    self.objBOT_5 = self:FindChild(self.objRight, 'BOT_5');

    --
    self.objSCRight = self:FindChild(self.objRight, 'SC_Right');
    self.objSCRightContent = self:FindChild(self.objSCRight, 'Viewport/Content');

    --
    table.insert(self.bindBtnTable, self.objCloseBtn);

    self:BindBtnCB();

    -- 测试
    -- self.RankDataManager:GetRankData();

end

function RankUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function RankUI:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    end
end

function RankUI:OnClickCloseBtn(obj)
    RemoveWindowImmediately('RankUI', true);
end

function RankUI:OnRefRankListLeft()

    local tbRankData = self.RankDataManager:GetTBRankData();
    local rankTypeTable = {};
    for k, v in pairs(tbRankData) do
        if tbRankData[k] and tbRankData[k].Show == TBoolean.BOOL_YES and tbRankData[k].BaseID < 100 then
            table.insert(rankTypeTable, tbRankData[k]);
        end
    end

    table.sort(rankTypeTable, function(a, b) 
        return (a.Order or 0) < (b.Order or 0);
    end)

    local toggleGroup = self.objSCLeftContent:GetComponent('ToggleGroup');

    self:RemoveAllChildToPool(self.transSCLeftContent);
    for i = 1, #(rankTypeTable) do
        local objToggle = self:LoadPrefabFromPool('RankUI/Toggle_Left', self.transSCLeftContent);
    
        local comToggle = objToggle:GetComponent('Toggle');
        comToggle.group = toggleGroup;

        local comText = self:FindChildComponent(objToggle, 'Text', 'Text');
        comText.text = GetLanguageByID(rankTypeTable[i].NameID);
        comText.color = normalColor;

        local _callback = function(gameObject, boolHide)
            if boolHide then
                comText.color = clickColor;
                self:OnClickRankToggle(gameObject, rankTypeTable[i], boolHide);
            else
                comText.color = normalColor;
            end
        end
        self:CommonBind(objToggle, _callback);

        comToggle.isOn = false;
    end

    self.transSCLeftContent:GetChild(0):GetComponent('Toggle').isOn = true;
end

function RankUI:OnClickRankToggle(obj, data, boolHide)

    self.loading = 0;
    self.clickTogData = data;
    self.isClickOtherTog = true;
    self.booleanError = false;

    self.objTOP_2:SetActive(false);
    self.objTOP_3:SetActive(false);
    self.objTOP_4:SetActive(false);
    self.objTOP_5:SetActive(false);
    self.objBOT_2:SetActive(false);
    self.objBOT_3:SetActive(false);
    self.objBOT_4:SetActive(false);
    self.objBOT_5:SetActive(false);

    if (data.EntryName3 ~= '') and (data.EntryName3 ~= 0) then
        self.itemType = 5;
        self.objTOP = self.objTOP_5;
        self.objBOT = self.objBOT_5;
        self.listViewItemName = 'Item_5';

        self:FindChildComponent(self.objTOP, 'Text_5', 'Text').text = data.EntryName3;
        self:FindChildComponent(self.objTOP, 'Text_4', 'Text').text = data.EntryName2;
        self:FindChildComponent(self.objTOP, 'Text_3', 'Text').text = data.EntryName1;

    elseif (data.EntryName2 ~= '') and (data.EntryName2 ~= 0) then
        self.itemType = 4;
        self.objTOP = self.objTOP_4;
        self.objBOT = self.objBOT_4;
        self.listViewItemName = 'Item_4';

        self:FindChildComponent(self.objTOP, 'Text_4', 'Text').text = data.EntryName2;
        self:FindChildComponent(self.objTOP, 'Text_3', 'Text').text = data.EntryName1;

    elseif (data.EntryName1 ~= '') and (data.EntryName1 ~= 0) then
        self.itemType = 3
        self.objTOP = self.objTOP_3;
        self.objBOT = self.objBOT_3;
        self.listViewItemName = 'Item_3';

        self:FindChildComponent(self.objTOP, 'Text_3', 'Text').text = data.EntryName1;
    else
        self.itemType = 2
        self.objTOP = self.objTOP_2;
        self.objBOT = self.objBOT_2;
        self.listViewItemName = 'Item_2';
    end

    local appearanceInfo = PlayerSetDataManager:GetInstance():GetAppearanceInfo();
    self:FindChildComponent(self.objBOT, 'Text_2', 'Text').text = appearanceInfo.playerName or '自己人';
    self.objTOP:SetActive(true);
    self.objBOT:SetActive(true);

    --
    self:QuerySelfData(data.BaseID);

    --
    if not self.rankPage[data.BaseID] then 
        NetCommonRank:QueryRank(tostring(data.BaseID), 1, maxRankMember, nil, nil, nil, nil, true);
    else
        self.RankDataManager:LoadByCacheData(data.BaseID);
    end
end

function RankUI:OnRefRankListRight(data)

    if not data then
        return;
    end

    self.rankData = data.members;
    self.rankDataCount = #(self.rankData);

    local lvSC = self.objSCRight:GetComponent('LoopListView2');
    local scrollRect = self.objSCRight:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem(self.listViewItemName);
            self:OnScrollChanged(obj.gameObject, self.rankData[index + 1], index);
            return obj;
        end
        
        local _func1 = function()
        end

        local _func2 = function()
        end
        
        local _func3 = function()
            if scrollRect.verticalNormalizedPosition > 0 then
            else
                local totalCount = self.RankDataManager:GetTotalCount();
                local rankPage = self.rankPage[self.clickTogData.BaseID] or 0;
                if rankPage < 10 and rankPage < math.ceil(totalCount / 10) then
                    NetCommonRank:QueryRank(tostring(self.clickTogData.BaseID), rankPage + 1, maxRankMember, nil, nil, nil, nil, true);
                end 
            end
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.rankDataCount, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.rankDataCount, false);
            lvSC:RefreshAllShownItem();
        end 

        if self.isClickOtherTog then
            self.isClickOtherTog = false;
            lvSC:MovePanelToItemIndex(0, 0);
        end

        self.lvSCRight = lvSC;
    end
    
end

function RankUI:OnScrollChanged(gameObject, data, index)
    gameObject:SetActive(true);

    self:SetRank(gameObject, index + 1);
    self:SetItemSingle(gameObject, data);
end

function RankUI:SetRank(gameObject, rank)

    if rank == 1 then

        self:FindChild(gameObject, 'Image_1'):SetActive(true);
        self:FindChild(gameObject, 'Image_2'):SetActive(false);
        self:FindChild(gameObject, 'Image_3'):SetActive(false);
        self:FindChild(gameObject, 'Text_1'):SetActive(false);
        self:FindChild(gameObject, 'Image_num'):SetActive(false);

    elseif rank == 2 then

        self:FindChild(gameObject, 'Image_1'):SetActive(false);
        self:FindChild(gameObject, 'Image_2'):SetActive(true);
        self:FindChild(gameObject, 'Image_3'):SetActive(false);
        self:FindChild(gameObject, 'Text_1'):SetActive(false);
        self:FindChild(gameObject, 'Image_num'):SetActive(false);

    elseif rank == 3 then

        self:FindChild(gameObject, 'Image_1'):SetActive(false);
        self:FindChild(gameObject, 'Image_2'):SetActive(false);
        self:FindChild(gameObject, 'Image_3'):SetActive(true);
        self:FindChild(gameObject, 'Text_1'):SetActive(false);
        self:FindChild(gameObject, 'Image_num'):SetActive(false);
        
    else

        self:FindChild(gameObject, 'Image_1'):SetActive(false);
        self:FindChild(gameObject, 'Image_2'):SetActive(false);
        self:FindChild(gameObject, 'Image_3'):SetActive(false);
        self:FindChild(gameObject, 'Text_1'):SetActive(true);

        local comText = self:FindChildComponent(gameObject, 'Text_1', 'Text');
        if rank <= 0 then
            comText.text = '未上榜';
            self:FindChild(self.objBOT, 'Image_null'):SetActive(true);
            self:FindChild(gameObject, 'Image_num'):SetActive(false);
        elseif rank > 3 then
            comText.text = rank;
            self:FindChild(self.objBOT, 'Image_null'):SetActive(false);
            self:FindChild(gameObject, 'Image_num'):SetActive(true);
        end

    end

end

function RankUI:UpdateSelfData()
    local playerID = globalDataPool:getData("PlayerID");
    local playerName = PlayerSetDataManager:GetInstance():GetPlayerName();
    local data, rank = self.RankDataManager:GetRankDataByPlayerID(self.clickTogData.BaseID, playerID);
    if not data then
        data = RankDataManager:GetInstance():GetRankDataByMember(self.clickTogData.BaseID, playerID);
        if not data then
            data = {
                rank = 0,
                name = playerName,
                member = playerID,
                metadata = playerName,
                score = {
                    [1] = 0,
                    [2] = 0,
                    [3] = 0,
                };
            };
        end
        rank = data.rank > 100 and 0 or data.rank;
    end
    self:SetRank(self.objBOT, rank);
    self:SetItemSingle(self.objBOT, data);
    self.objBOT:SetActive(true);
    self:Score350();
end

function RankUI:QuerySelfData(rankid)
    local playerID = globalDataPool:getData("PlayerID");
    local playerName = PlayerSetDataManager:GetInstance():GetPlayerName();
    if playerID and playerName then
        NetCommonRank:QueryWithMember(tostring(rankid), { tostring(playerID) });
    end
end

function RankUI:SetItemSingle(gameObject, data)

    if not data then
        return;
    end 

    if self.itemType == 5 then
        self:FindChildComponent(gameObject, 'Text_5', 'Text').text = self:ConvertScore(data.score[3], 3);
        self:FindChildComponent(gameObject, 'Text_4', 'Text').text = self:ConvertScore(data.score[2], 2);
        self:FindChildComponent(gameObject, 'Text_3', 'Text').text = self:ConvertScore(data.score[1], 1);

    elseif self.itemType == 4 then
        self:FindChildComponent(gameObject, 'Text_4', 'Text').text = self:ConvertScore(data.score[2], 2);
        self:FindChildComponent(gameObject, 'Text_3', 'Text').text = self:ConvertScore(data.score[1], 1);

    elseif self.itemType == 3 then
        self:FindChildComponent(gameObject, 'Text_3', 'Text').text = self:ConvertScore(data.score[1], 1);

    end

    local comName = self:FindChildComponent(gameObject, 'Text_2', 'Text');
    if data.name and data.metadata then
        local strName = string.match(data.name, '#(.+)');
        local playerID = globalDataPool:getData("PlayerID");
        local curPlayerID = string.match(data.name, '(.+)#') or data.member;
        strName = data.metadata ~= '' and data.metadata or strName;
        if curPlayerID == playerID then
            strName = PlayerSetDataManager:GetInstance():GetPlayerName();
        end
        if not strName or strName == '' then
            strName = data.name;
        end
        comName.text = strName;

        local playerData = self.SocialDataManager:GetOtherPlayerData(curPlayerID);
        local objImageQQ = self:FindChild(gameObject,"Image_QQ");
        local objImageWX = self:FindChild(gameObject,"Image_WX");
        if objImageQQ and objImageWX then
            objImageQQ:SetActive(false);
            objImageWX:SetActive(false);
            
            local _callback = function(gameObject)
                if gameObject.name == 'Image_QQ' then
                    -- SystemUICall:GetInstance():Toast('从QQ游戏中心启动尊享特权'); 
                    MSDKHelper:OpenUrl("https://speed.gamecenter.qq.com/pushgame/v1/inner-game/privilege?launchqq=1")
                elseif gameObject.name == 'Image_WX' then
                    SystemUICall:GetInstance():Toast('从微信游戏中心启动尊享特权');
                end
            end
            self:CommonBind(objImageQQ, _callback);
            self:CommonBind(objImageWX, _callback);

            if curPlayerID == playerID then
                if MSDKHelper:IsLoginQQ() then
                    if MSDKHelper:IsOpenQQPrivilege() then
                        objImageQQ:SetActive(true);
                    end
                elseif MSDKHelper:IsLoginWeChat() then
                    if MSDKHelper:IsOpenWXPrivilege() then
                        objImageWX:SetActive(true);
                    end
                end
            else
                if playerData and playerData.ext and playerData.ext.iTencentPrivate then
                    if MSDKHelper:IsLoginQQ() then
                        if HasFlag(tonumber(playerData.ext.iTencentPrivate), STPT_QQ) then
                            objImageQQ:SetActive(true);
                        end
                    elseif MSDKHelper:IsLoginWeChat() then
                        if HasFlag(tonumber(playerData.ext.iTencentPrivate), STPT_WECHAT) then
                            objImageWX:SetActive(true);
                        end 
                    end
                end
            end
        end
    else 
        comName.text = '自己人';
    end
end

function RankUI:ConvertScore(score, index)

    if not score then  
        return 0; 
    end

    return tonumber(score);
end

function RankUI:RefreshUI()
    local gameMode = globalDataPool:getData('GameMode');
    if gameMode ~= 'ServerMode' then
        return;
    end
    self.rankPage = {};
    self.RankDataManager:ResetRankData();
    self:OnRefRankListLeft();
    --提示是否被禁
    HandleCommonFreezing(SEOT_FORBIDRANK);
end

function RankUI:Score350()
    local bLimit = PlayerSetDataManager:GetInstance():GetTXCreditSceneLimit(TCSSLS_RANKLIST);
    if not bLimit then
        self:SetRank(self.objBOT, 0);
        self:FindChild(self.objBOT, 'Image350'):SetActive(true);
        local objText2 = self:FindChild(self.objBOT, 'Text_2');
        if objText2 then
            objText2:SetActive(false);
        end
        local objText3 = self:FindChild(self.objBOT, 'Text_3');
        if objText3 then
            objText3:SetActive(false);
        end
        local objText4 = self:FindChild(self.objBOT, 'Text_4');
        if objText4 then
            objText4:SetActive(false);
        end
        local objText5 = self:FindChild(self.objBOT, 'Text_5');
        if objText5 then
            objText5:SetActive(false);
        end

        local comText = self:FindChildComponent(self.objBOT, 'Image350/Text350','Text')
        if comText then 
            comText.text = '您的信用分低于350分，游戏环境异常或存在安全风险，无法进入排行榜。'
        end
        
        local objRedBtn = self:FindChild(self.objBOT, 'Image350/Button_red_1');
        local _callback = function(gameObject)
            MSDKHelper:OpenCriditUrl();
        end
        self:CommonBind(objRedBtn, _callback);
    end
end

function RankUI:SetRankPage()
    if not self.rankPage[self.clickTogData.BaseID] then
        self.rankPage[self.clickTogData.BaseID] = 0;
    end
    self.rankPage[self.clickTogData.BaseID] = self.rankPage[self.clickTogData.BaseID] + 1;
end

function RankUI:OnEnable()
    self:AddEventListener('ONEVENT_REF_RANKUI', function(info)
        self:SetRankPage();
        self:OnRefRankListRight(info);
    end);
    self:AddEventListener('ONEVENT_REF_RANKINGDATA', function(info)
        self:UpdateSelfData();
    end);
end

function RankUI:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_RANKUI');
    self:RemoveEventListener('ONEVENT_REF_RANKINGDATA');
end

function RankUI:OnDestroy()
    if self.lvSCRight then
        self.lvSCRight.mOnBeginDragAction = nil;
        self.lvSCRight.mOnDragingAction = nil;
        self.lvSCRight.mOnEndDragAction = nil;
        self.lvSCRight.mOnGetItemByIndex = nil;
    end
end

return RankUI;