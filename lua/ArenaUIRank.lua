ArenaUIRank = class('ArenaUIRank', BaseWindow);

local clickColor = DRCSRef.Color(0.91, 0.91, 0.91, 1);
local normalColor = DRCSRef.Color(0.3, 0.3, 0.3, 1);

local maxRankMember = 32;

function ArenaUIRank:ctor(info)
    self._script = info;

    self.bindBtnTable = {};
    self.objTOP = nil;
    self.objBOT = nil;
    self.clickTogData = {};
    self.listViewItemName = '';
    self.itemType = 2;
    self.isClickOtherTog = false;
    self.rankPage = {};

    self:SetGameObject(info.objRank);
    self:OnCreate(info.objRank);
end

function ArenaUIRank:Create()

end

function ArenaUIRank:Init()

    self.RankDataManager = RankDataManager:GetInstance();

    self.objLeft = self:FindChild(self._gameObject, 'Left');
    self.objRight = self:FindChild(self._gameObject, 'Right');
    self.objQuestionBtn = self:FindChild(self.objRight, 'Button_question');

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
    table.insert(self.bindBtnTable, self.objQuestionBtn);

    self:BindBtnCB();

    -- 测试
    -- self.RankDataManager:GetRankData();

end

function ArenaUIRank:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUIRank:OnclickBtn(obj, boolHide)
    if obj == self.objQuestionBtn then
        self:OnClickobjQuestionBtn(obj);

    end

end

function ArenaUIRank:OnClickobjQuestionBtn(obj)
    local strText = GetLanguageByID(559);
    local tips = {
        title = '提示',
        content = strText
    }
    if strText ~= '' then
        OpenWindowImmediately("TipsPopUI", tips);
    end
end

function ArenaUIRank:OnRefRankListLeft()

    local tbRankData = self.RankDataManager:GetTBRankData() or {};
    local rankTypeTable = {};
    for k, v in pairs(tbRankData) do
        if tbRankData[k] and tbRankData[k].Show == TBoolean.BOOL_YES and tbRankData[k].BaseID > 100 then
            table.insert(rankTypeTable, tbRankData[k])
        end
    end

    table.sort(rankTypeTable, function(a, b) 
        return (a.Order or 0) < (b.Order or 0);
    end)

    local toggleGroup = self.objSCLeftContent:GetComponent('ToggleGroup');

    self:RemoveAllChildToPoolAndClearEvent(self.transSCLeftContent)
    for i = 1, #(rankTypeTable) do
        local objToggle = self:LoadPrefabFromPool('RankUI/Toggle_Left', self.transSCLeftContent)
    
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

function ArenaUIRank:OnClickRankToggle(obj, data, boolHide)

    if not data then
        return;
    end

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
        NetCommonRank:QueryRank(tostring(data.BaseID), 1, maxRankMember);
    else
        self.RankDataManager:LoadByCacheData(data.BaseID);
    end
end

function ArenaUIRank:OnRefRankListRight(data)

    if not data then
        return;
    end

    local rankData = data.members;
    self.rankData = rankData;
    self.count = getTableSize2(self.rankData);
    self.count = self.count < 6 and 6 or self.count;

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
                -- local totalCount = self.RankDataManager:GetTotalCount();
                -- local rankPage = self.rankPage[self.clickTogData.BaseID] or 0;
                -- if rankPage < 10 and rankPage < math.ceil(totalCount / 10) then
                --     NetCommonRank:QueryRank(tostring(self.clickTogData.BaseID), rankPage + 1, maxRankMember);
                -- end 
            end
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.count, _func);
            lvSC.mOnBeginDragAction = _func1;
            lvSC.mOnDragingAction = _func2;
            lvSC.mOnEndDragAction = _func3;
        else
            lvSC:SetListItemCount(self.count, false);
            lvSC:RefreshAllShownItem();
        end 

        if self.isClickOtherTog then
            self.isClickOtherTog = false;
            lvSC:MovePanelToItemIndex(0, 0);
        end

        self.lvSCRight = lvSC;
    end
    
end

function ArenaUIRank:SetRankPage()
    if not self.rankPage[self.clickTogData.BaseID] then
        self.rankPage[self.clickTogData.BaseID] = 0;
    end
    self.rankPage[self.clickTogData.BaseID] = self.rankPage[self.clickTogData.BaseID] + 1;

end

function ArenaUIRank:OnScrollChanged(gameObject, data, index)
    gameObject:SetActive(true);

    local objImageNum = self:FindChild(gameObject, 'Image_num')
    local objText1 = self:FindChild(gameObject, 'Text_1');
    local objText2 = self:FindChild(gameObject, 'Text_2');
    local objText3 = self:FindChild(gameObject, 'Text_3');

    if data then
        self:SetRank(gameObject, index + 1);
        self:SetItemSingle(gameObject, data);

        objImageNum:SetActive(true);
        if objText1 then
            objText1:SetActive(true);
        end
        if objText2 then
            objText2:SetActive(true);
        end
        if objText3 then
            objText3:SetActive(true);
        end
    else
        objImageNum:SetActive(false);
        if objText1 then
            objText1:SetActive(false);
        end
        if objText2 then
            objText2:SetActive(false);
        end
        if objText3 then
            objText3:SetActive(false);
        end
        self:FindChild(gameObject, 'Image_1'):SetActive(false);
        self:FindChild(gameObject, 'Image_2'):SetActive(false);
        self:FindChild(gameObject, 'Image_3'):SetActive(false);
    end

    local objImageQQ = self:FindChild(gameObject,"Image_QQ");
    local objImageWX = self:FindChild(gameObject,"Image_WX");
    if objImageQQ and objImageWX then
        objImageQQ:SetActive(false);
        objImageWX:SetActive(false);
    end
end

function ArenaUIRank:SetRank(gameObject, rank)

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
        self:FindChild(gameObject, 'Image_num'):SetActive(false);
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

function ArenaUIRank:UpdateSelfData()
    local playerID = globalDataPool:getData("PlayerID");
    local playerName = PlayerSetDataManager:GetInstance():GetPlayerName();
    local member = string.format('%d', playerID);
    local data, rank = self.RankDataManager:GetRankDataByPlayerID(self.clickTogData.BaseID, playerID);
    if not data then
        data = RankDataManager:GetInstance():GetRankDataByMember(self.clickTogData.BaseID, member);
        if not data then
            -- self.objBOT:SetActive(false);
            -- return;
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
        rank = data.rank > 32 and 0 or data.rank;
    end
    self:SetRank(self.objBOT, rank);
    self:SetItemSingle(self.objBOT, data);
    self.objBOT:SetActive(true);
end

function ArenaUIRank:QuerySelfData(rankid)
    -- self.objBOT:SetActive(false);
    local playerID = globalDataPool:getData("PlayerID");
    local playerName = PlayerSetDataManager:GetInstance():GetPlayerName();
    if playerID and playerName then
        local member = string.format('%d', playerID);
        NetCommonRank:QueryWithMember(tostring(rankid), {member});
    end
end

function ArenaUIRank:SetItemSingle(gameObject, data)

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
    else 
        comName.text = '自己人';

    end

end

function ArenaUIRank:ConvertScore(score, index)

    if not score then  
        return 0; 
    end

    return tonumber(score);
end

function ArenaUIRank:RefreshUI()
    local gameMode = globalDataPool:getData('GameMode');
    if gameMode ~= 'ServerMode' then
        return;
    end
    self.rankPage = {};
    self:OnRefRankListLeft();
end

function ArenaUIRank:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_RANKUI');
    self:RemoveEventListener('ONEVENT_REF_RANKINGDATA');

end

function ArenaUIRank:OnEnable()
    self:AddEventListener('ONEVENT_REF_RANKUI', function(info)
        if self._gameObject.activeSelf then
            self:SetRankPage();
            self:OnRefRankListRight(info);
        end
    end);
    self:AddEventListener('ONEVENT_REF_RANKINGDATA', function(info)
        if self._gameObject.activeSelf then
            self:UpdateSelfData();
        end
    end);

end

function ArenaUIRank:OnDestroy()
    if self.lvSCRight then
        self.lvSCRight.mOnBeginDragAction = nil;
        self.lvSCRight.mOnDragingAction = nil;
        self.lvSCRight.mOnEndDragAction = nil;
        self.lvSCRight.mOnGetItemByIndex = nil;
    end
end

return ArenaUIRank;