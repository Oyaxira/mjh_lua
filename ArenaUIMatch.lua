ArenaUIMatch = class('ArenaUIMatch', BaseWindow);

local MatchType = {'32强赛','16强赛','8强赛','半决赛','决赛', '排名'};
local Rank = {'决赛第一名', '决赛第二名', '决赛第三名', '决赛第四名'}
local Round = {32, 16, 8, 4, 2, 1}
local Round2 = {16, 8, 4, 2, 1}
local Round3 = {8, 4, 2, 1}

local RoundToString = {
    [Round[1]] = MatchType[1],
    [Round[2]] = MatchType[2],
    [Round[3]] = MatchType[3],
    [Round[4]] = MatchType[4],
    [Round[5]] = MatchType[5],
    [Round[6]] = MatchType[5],
}

local redColor = DRCSRef.Color(0x91 / 0xff, 0x3E / 0xff, 0x2B / 0xff, 1);
local whiteColor = DRCSRef.Color(0.59, 0.48, 0.33, 1);
local whiteColor2 = DRCSRef.Color(1, 1, 1, 1);
local blackColor = DRCSRef.Color(0, 0, 0, 1);
local blackColor2 = DRCSRef.Color(0, 0, 0, 0.7);
local blackColor3 = DRCSRef.Color(0x32 / 0xff, 0x32 / 0xff, 0x32 / 0xff, 1);
local greenColor = DRCSRef.Color(0, 1, 0, 1);
local greenColor2 = DRCSRef.Color(0.86,0.9,0.73,1);
local grayColor = DRCSRef.Color(0.5, 0.5, 0.5, 1);

function ArenaUIMatch:ctor(info)
    self._script = info;
    self.bindBtnTable = {};
    self.showIndex = 1;
    self.itemName = '';
    self.clickCount = 0;
    self.bAutoMove = true;
    self.bClickObserve = false;
end

function ArenaUIMatch:Create()
    local arenaUI = GetUIWindow('ArenaUI');
    if arenaUI and arenaUI:IsOpen() then
        local obj = LoadPrefabAndInit('ArenaUI/Match', arenaUI.objArenaUIMatch or UI_UILayer, true);
        if obj then
            self:SetGameObject(obj);
        end
    end
end

function ArenaUIMatch:Init()

    self.ArenaDataManager = ArenaDataManager:GetInstance();
    self.PlayerSetDataManager = PlayerSetDataManager:GetInstance();
    self.TableDataManager = TableDataManager:GetInstance():GetTable("RoleModel");

    --
    self.objLeft = self:FindChild(self._gameObject, 'Left');
    self.objRight = self:FindChild(self._gameObject, 'Right');
    self.objCloseBtn = self:FindChild(self._gameObject, 'TransformAdapt_node_left/Button_close');
    
    --
    self.objImageTop = self:FindChild(self.objLeft, 'Image_Top');
    self.objImageBot = self:FindChild(self.objLeft, 'Image_Bot');
    self.objSCLeft1 = self:FindChild(self.objLeft, 'SC_Left1');
    self.objSCLeft2 = self:FindChild(self.objLeft, 'SC_Left2');
    self.objChangeBtn = self:FindChild(self.objLeft, 'Button_Change');
    
    self.objImageTop:SetActive(true);
    self.objSCLeft1:SetActive(true);
    self.objSCLeft2:SetActive(false);

    --
    self.objTopLeftBtn = self:FindChild(self.objImageTop, 'Button_Left');
    self.objTopRightBtn = self:FindChild(self.objImageTop, 'Button_Right');
    self.objImage1 = self:FindChild(self.objImageTop, 'Image1');
    self.objImage2 = self:FindChild(self.objImageTop, 'Image2');
    self.objImage3 = self:FindChild(self.objImageTop, 'Image3');
    
    --
    self.objTextDec = self:FindChild(self.objImageBot, 'Text_Dec');
    self.objTextCD = self:FindChild(self.objImageBot, 'Text_countdown');
    self.objMatchRecodeBtn = self:FindChild(self.objImageBot, 'Button_MatchRecode');

    --
    self.objTextTitle = self:FindChild(self.objRight, 'Text_Title');
    self.objImageAll = self:FindChild(self.objRight, 'Image_All');
    self.objImageAverage = self:FindChild(self.objRight, 'Image_Average');
    self.objSCRight = self:FindChild(self.objRight, 'SC_Right');
    self.objWhatBtn = self:FindChild(self.objRight, 'Button_What');

    --
    self.objSCLeftContent1 = self:FindChild(self.objSCLeft1, 'Viewport/Content');
    self.objSCLeftContent2 = self:FindChild(self.objSCLeft2, 'Viewport/Content');
    self.objSCRightContent = self:FindChild(self.objSCRight, 'Viewport/Content');

    --
    table.insert(self.bindBtnTable, self.objCloseBtn);
    table.insert(self.bindBtnTable, self.objTopLeftBtn);
    table.insert(self.bindBtnTable, self.objTopRightBtn);
    table.insert(self.bindBtnTable, self.objMatchRecodeBtn);
    table.insert(self.bindBtnTable, self.objWhatBtn);
    table.insert(self.bindBtnTable, self.objChangeBtn);

    self:BindBtnCB();
end

function ArenaUIMatch:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUIMatch:OnclickBtn(obj, boolHide)
    if obj == self.objCloseBtn then
        self:OnClickCloseBtn(obj);

    elseif obj == self.objTopLeftBtn then
        self:OnClickTopLeftBtn(obj);

    elseif obj == self.objTopRightBtn then
        self:OnClickTopRightBtn(obj);

    elseif obj == self.objMatchRecodeBtn then
        self:OnClickMatchRecodeBtn(obj);

    elseif obj == self.objWhatBtn then
        self:OnClickWhatBtn(obj);
    
    elseif obj == self.objChangeBtn then
        self:OnClickChangeBtn(obj);

    end

end

function ArenaUIMatch:OnClickChangeBtn(obj)
    if self.objSCLeft1.activeSelf then
        self.objImageTop:SetActive(false);
        self.objSCLeft1:SetActive(false);
        self.objSCLeft2:SetActive(true);
        self:OnRefSCLeft2();
    else
        self.objImageTop:SetActive(true);
        self.objSCLeft1:SetActive(true);
        self.objSCLeft2:SetActive(false);
    end
end

function ArenaUIMatch:OnClickCloseBtn(obj)
    if self._timeHandle ~= nil then
		for k, v in pairs(self._timeHandle) do
			globalTimer:RemoveTimer(v);
		end
    end

    --
    RoleDataManager:GetInstance():SetArenaObserveData(false);
    GiftDataManager:GetInstance():SetArenaObserveData(false);
    ItemDataManager:GetInstance():SetArenaObserveData(false);
    MartialDataManager:GetInstance():SetArenaObserveData(false);

    --
    RemoveWindowImmediately('ArenaUIMatch');
end

function ArenaUIMatch:OnClickTopLeftBtn(obj)
    obj:SetActive(true);
    self.objTopRightBtn:SetActive(true);

    if self.showIndex == 1 then
        obj:SetActive(false);

    elseif self.showIndex == 2 then
        if self.tbData.Peoples == 8 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftBig_8';

            obj:SetActive(false);
        end

        if self.tbData.Peoples == 16 then
            self.leftCount = 4;
            self.itemName = 'Item_LeftSmall';

            obj:SetActive(false);
        end
        
        if self.tbData.Peoples == 32 then
            self.leftCount = 8;
            self.itemName = 'Item_LeftSmall';

            obj:SetActive(false);
        end
        
    elseif self.showIndex == 3 then
        if self.tbData.Peoples == 16 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftBig_8';
        end

        if self.tbData.Peoples == 32 then
            self.leftCount = 4;
            self.itemName = 'Item_LeftSmall';
        end

    elseif self.showIndex == 4 then
        if self.tbData.Peoples == 32 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftBig_8';
        end

    end

    if self.showIndex > 1 then
        self.showIndex = self.showIndex - 1;
        self:OnRefSCLeft1();
        self:OnRefLeftTop();
    end

end

function ArenaUIMatch:OnClickTopRightBtn(obj)
    obj:SetActive(true);
    self.objTopLeftBtn:SetActive(true);

    if self.showIndex == 1 then
        if self.tbData.Peoples == 8 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftSmall1';

            obj:SetActive(false);
        end
    
        if self.tbData.Peoples == 16 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftBig_8';
        end

        if self.tbData.Peoples == 32 then
            self.leftCount = 4;
            self.itemName = 'Item_LeftSmall';
        end

    elseif self.showIndex == 2 then
        if self.tbData.Peoples == 8 then
            obj:SetActive(false);
        end
        
        if self.tbData.Peoples == 16 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftSmall1';

            obj:SetActive(false);
        end
    
        if self.tbData.Peoples == 32 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftBig_8';
        end

    elseif self.showIndex == 3 then
        if self.tbData.Peoples == 16 then
            obj:SetActive(false);
        end

        if self.tbData.Peoples == 32 then
            self.leftCount = 1;
            self.itemName = 'Item_LeftSmall1';

            obj:SetActive(false);
        end
    elseif self.showIndex == 4 then
        if self.tbData.Peoples == 32 then
            obj:SetActive(false);
        end
    end

    if self.showIndex < self.clickCount then
        self.showIndex = self.showIndex + 1;
        self:OnRefSCLeft1();
        self:OnRefLeftTop();
    end

end

function ArenaUIMatch:OnClickMatchRecodeBtn(obj)
    OpenWindowImmediately('ArenaUIMatchRecode', self.serverData);
    SendRequestArenaMatchOperate(ARENA_REQUEST_JOKE_MATCH_DATA, self.serverData.dwMatchType, self.serverData.dwMatchID);
end

function ArenaUIMatch:OnClickWhatBtn(obj)

end

function ArenaUIMatch:OnRefLeftTop()

    local strText1 = '';
    local strText2 = '';
    local strText3 = '';
    local strTable = {};
    table.insert(strTable, strText1);
    table.insert(strTable, strText2);
    table.insert(strTable, strText3);

    local curIndex = self:RoundIndexOf(self.serverData.dwRoundID);

    local _getDec = function()
        if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
            if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
                return '观战中';
            else
                return '助威中';
            end
        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
            return '观战中';
        else
            return '';
        end
    end

    if self.tbData.Peoples == 8 then
        if self.showIndex == 1 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 2];
            end
            
        elseif self.showIndex == 2 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 3];
            end

        end
    
    elseif self.tbData.Peoples == 16 then
        if self.showIndex == 1 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 1];
            end
            
        elseif self.showIndex == 2 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 2];
            end

        elseif self.showIndex == 3 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 3];
            end
            
        end
    
    elseif self.tbData.Peoples == 32 then
        if self.showIndex == 1 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i];
            end
            
        elseif self.showIndex == 2 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 1];
            end

        elseif self.showIndex == 3 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 2];
            end

        elseif self.showIndex == 4 then
            for i = 1, #(strTable) do
                strTable[i] = MatchType[i + 3];
            end

        end

    end

    local offSet = curIndex - self.showIndex;
    if strTable[offSet + 1] then
        strTable[offSet + 1] = strTable[offSet + 1] .. _getDec();
    end

    self:FindChildComponent(self.objImage1, 'Text', 'Text').text = strTable[1];
    self:FindChildComponent(self.objImage2, 'Text', 'Text').text = strTable[2];
    self:FindChildComponent(self.objImage3, 'Text', 'Text').text = strTable[3];

end

function ArenaUIMatch:RoundIndexOf(round)

    local tRound = Round;
    if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        tRound = Round3;
    elseif self.serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
        tRound = Round2;
    end

    for i = 1, #(tRound) do
        if tRound[i] == round then
            return i;
        end         
    end
    return 0;
end

function ArenaUIMatch:OnRefLeftBot()

    self.serverData = self.ArenaDataManager:GetMatchDataBy(self.serverData.dwMatchType, self.serverData.dwMatchID);
    local bSignUp, roundID = self.ArenaDataManager:GetSelfBattleData(self.serverData.dwMatchType, self.serverData.dwMatchID);
    
    local strText = '';
    if bSignUp then
        if self.serverData.dwRoundID > 0 then
            if roundID > self.serverData.dwRoundID then
                strText = roundID .. '强已淘汰';
                if roundID == 4 then
                    strText = '半决赛已淘汰';
                elseif roundID == 2 then
                    strText = '决赛已淘汰';
                end
            elseif roundID == self.serverData.dwRoundID then
                strText = roundID .. '强参赛中';
                if roundID == 4 then
                    strText = '半决赛参赛中';
                elseif roundID == 2 then
                    strText = '决赛参赛中';
                end
            end
        else
            if self.vtd then
                local playerID =PlayerSetDataManager:GetInstance():GetPlayerID();
                for i = 1, #(self.vtd) do
                    if playerID == self.vtd[i].defPlayerID then
                        strText = Rank[i];
                        break;
                    end
                end
            end
        end
    else
        if self.serverData.uiSignUpPlace == 0 then
            strText = '未报名';
        else
            strText = '娱乐赛参赛中';
        end

        if self.serverData.dwMatchType then
            strText = '未参赛'; 
        end
    end
    self.objTextDec:GetComponent('Text').text = strText;
    
    --
    local _timeToString = function(time)
        local h = math.floor(time / 60 / 60);
        local m = math.floor(time / 60) % 60;
        local s = math.floor(time) % 60;
        return string.format('%02d:%02d:%02d', h, m, s);
    end

    local time = self:Time();
    if time > 0 then
        local comText = self.objTextCD:GetComponent('Text');
        comText.text = '阶段倒计时：' .. _timeToString(time);
        if self.timer1 then
            self:RemoveTimer(self.timer1);
            self.timer1 = nil;
        end
        self.timer1 = self:AddTimer(1000, function()
            time = time - 1;
            local strTime = _timeToString(time)
            comText.text = '阶段倒计时：' .. strTime
            LuaEventDispatcher:dispatchEvent("ARENA_TIME_UPDATE", {
                ["strTime"] = strTime,
                ["bFinish"] = (time <= 0),
            })
        end, time);
    end

    if self.serverData.dwRoundID > 0 and time > 0 then
        self.objTextCD:SetActive(true);
    else
        self.objTextCD:SetActive(false);
    end
end

function ArenaUIMatch:Time()

    local _func = function()
        local tTime = '';
        if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
            if self.serverData.dwRoundID == 32 then
                tTime = self.tbData.BetTime32;
            
            elseif self.serverData.dwRoundID == 16 then
                tTime = self.tbData.BetTime16;
                
            elseif self.serverData.dwRoundID == 8 then
                tTime = self.tbData.BetTime8;
                
            elseif self.serverData.dwRoundID == 4 then
                tTime = self.tbData.BetTime4;
                
            elseif self.serverData.dwRoundID == 2 then
                tTime = self.tbData.BetTime2;
            
            end
        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
            if self.serverData.dwRoundID == 32 then
                tTime = self.tbData.WatchTime32;
            
            elseif self.serverData.dwRoundID == 16 then
                tTime = self.tbData.WatchTime16;
                
            elseif self.serverData.dwRoundID == 8 then
                tTime = self.tbData.WatchTime8;
                
            elseif self.serverData.dwRoundID == 4 then
                tTime = self.tbData.WatchTime4;
                
            elseif self.serverData.dwRoundID == 2 then
                tTime = self.tbData.WatchTime2;
            
            end
        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
    
        end

        return tTime;
    end
    
    local _tonumber = function(array)
        for i = 1, #(array) do
            array[i] = tonumber(array[i]);          
        end
        return array;
    end
    
    local _formatTime = function(today, timeTable)
        local time = {
            year = today.year, 
            month = today.month,
            day = today.day, 
            hour = timeTable[1], 
            min = timeTable[2], 
            sec = timeTable[3],
        };
        return os.time(time);
    end
    
    local tTime = _func();
    if tTime ~= '' then
        local today = os.date('*t');
        local timeTable = string.split(tTime, ';');
        local timeBegin = {today.hour, today.min, today.sec};
        local timeEnd = _tonumber(string.split(timeTable[3], ':'));
        return _formatTime(today, timeEnd) - _formatTime(today, timeBegin);
    else
        return 0;
    end
end

function ArenaUIMatch:OnRefSCLeft1()

    self.serverData = self.ArenaDataManager:GetMatchDataBy(self.serverData.dwMatchType, self.serverData.dwMatchID);
    local matchData = self.ArenaDataManager:GetBattleDataBy(self.serverData.dwMatchType, self.serverData.dwMatchID);
    self.matchData = matchData;

    local lvSC = self.objSCLeft1:GetComponent('LoopListView2');
    local scrollRect = self.objSCLeft1:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem(self.itemName);
            self:OnScrollChanged(obj.gameObject, index);
            return obj;
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.leftCount, _func);
        else
            lvSC:SetListItemCount(self.leftCount, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCLeft = lvSC;
    end
    
end

function ArenaUIMatch:OnScrollChanged(gameObject, index)
    gameObject:SetActive(true);

    self:SetItemSingle(gameObject, index);
end

function ArenaUIMatch:SetItemSingle(gameObject, index)

    if not self.matchData then
        return;
    end

    --
    local objItemTable = {};
    local objParentTable = {};
    local goTF = gameObject.transform;
    for i = 0, goTF.childCount - 1 do
        if not objItemTable[i] then
            objItemTable[i] = {};
        end

        local goTF2 = goTF:GetChild(i);

        objParentTable[i] = goTF2.gameObject;

        for j = 0, goTF2.childCount - 1 do
            local go = goTF2:GetChild(j).gameObject;
            objItemTable[i][j] = go;
        end
        
    end
    
    --
    -- self.serverData.dwRoundID = 32;
    local tRound = Round;
    if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        tRound = Round3;
    elseif self.serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
        tRound = Round2;
    end

    local tempRoundData = {};
    for i = 1, #(tRound) do
        if tRound[i] >= self.serverData.dwRoundID then
            table.insert(tempRoundData, self.matchData[tRound[i]]);
        end
    end

    --
    local count = #(tRound);
    if self.serverData.dwRoundID <= 2 then
        if tempRoundData[count - 1] and self.matchData[tRound[count]] then
            tempRoundData[count - 1][2] = self.matchData[tRound[count]][1];
            if self.serverData.dwRoundID == 0 then
                tempRoundData[count] = clone(tempRoundData[count - 1]);
            end
        end
    end
    self:SortBattleData(tempRoundData);

    --
    local _func = function(i, iIndex)

        local tIndex = i;

        if gameObject.name == 'Item_LeftSmall1(Clone)' then

            if self.serverData.dwRoundID == 4 then

                if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                    if i > 0 then
                        i = i + 1;
                    end

                    objParentTable[1]:SetActive(false);
                    objParentTable[2]:SetActive(true);
                    objParentTable[3]:SetActive(true);
                    objParentTable[4]:SetActive(false);

                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                    if i > 0 then
                        i = i + 1;
                    end

                    objParentTable[1]:SetActive(false);
                    objParentTable[2]:SetActive(true);
                    objParentTable[3]:SetActive(true);
                    objParentTable[4]:SetActive(false);

                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                    if i > 1 then
                        i = i + 1;
                    end

                    objParentTable[1]:SetActive(true);
                    objParentTable[2]:SetActive(false);
                    objParentTable[3]:SetActive(true);
                    objParentTable[4]:SetActive(false);
                end

            elseif self.serverData.dwRoundID <= 2 then

                if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                    if i > 1 then
                        i = i + 2;
                    end

                    objParentTable[1]:SetActive(true);
                    objParentTable[2]:SetActive(false);
                    objParentTable[3]:SetActive(false);
                    objParentTable[4]:SetActive(true);

                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                    if i > 1 then
                        i = i + 2;
                    end

                    objParentTable[1]:SetActive(true);
                    objParentTable[2]:SetActive(false);
                    objParentTable[3]:SetActive(false);
                    objParentTable[4]:SetActive(true);

                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                    if i > 1 then
                        i = i + 1;
                    end

                    objParentTable[1]:SetActive(true);
                    objParentTable[2]:SetActive(false);
                    objParentTable[3]:SetActive(true);
                    objParentTable[4]:SetActive(false);
                
                else

                    if i > 0 then
                        i = i + 1;
                    end
                    
                end
            
            else

                if i > 0 then
                    i = i + 1;
                end

                objParentTable[1]:SetActive(false);
                objParentTable[2]:SetActive(true);
                objParentTable[3]:SetActive(true);
                objParentTable[4]:SetActive(false);
            end
        end
        
        if gameObject.name == 'Item_LeftBig_8(Clone)' then

            if self.serverData.dwRoundID == 4 then

                if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                    if i > 1 then
                        i = i + 1;
                    end
                
                    objParentTable[2]:SetActive(false);
                    objParentTable[3]:SetActive(true);

                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                    if i > 1 then
                        i = i + 1;
                    end

                    objParentTable[2]:SetActive(false);
                    objParentTable[3]:SetActive(true);
                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                    
                end

            elseif self.serverData.dwRoundID <= 2 then

                if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then

                    objParentTable[2]:SetActive(true);
                    objParentTable[3]:SetActive(false);

                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then

                    objParentTable[2]:SetActive(true);
                    objParentTable[3]:SetActive(false);

                elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then

                    objParentTable[2]:SetActive(true);
                    objParentTable[3]:SetActive(false);
                
                else
                    
                    if i > 1 then
                        i = i + 1;
                    end

                end

            else

                if i > 1 then
                    i = i + 1;
                end

                objParentTable[2]:SetActive(false);
                objParentTable[3]:SetActive(true);
            end
            
        end

        for j = 0, getTableSize2(objItemTable[i]) - 1 do

            local go = objItemTable[i][j];
            local objImageBG1 = self:FindChild(go, 'Image_BG1');
            local objImage1 = self:FindChild(go, 'Image1');
            local objImage2 = self:FindChild(go, 'Image2');
            local objImage3 = self:FindChild(go, 'Image3');
            local objImage4 = self:FindChild(go, 'Image4');
            local objImage5 = self:FindChild(go, 'Image5');
            local objImageLine1 = self:FindChild(go, 'Image_Line1');
            local objImageLine2 = self:FindChild(go, 'Image_Line2');
            local objImageLine6 = self:FindChild(go, 'Image_Line6');
            local objImageLine7 = self:FindChild(go, 'Image_Line7');
            local objName = self:FindChild(go, 'Image_Head/Text_Name');
            local objOdds = self:FindChild(go, 'Image_Head/Image_Odds');
            local objText = self:FindChild(go, 'Image_Head/Image_Odds/Text (1)');
            local objRank = self:FindChild(go, 'Image_Rank');
            local objImageNotStart = self:FindChild(go, 'Image_NotStart');
            local objImagePlaying = self:FindChild(go, 'Image_Playing');
            local objBetBtn = self:FindChild(go, 'Button_Bet');
            local objPlayBackBtn = self:FindChild(go, 'Button_PlayBack');
            local objHeadBtn = self:FindChild(go, 'Button_Head');
            local objHead = self:FindChild(go, 'Image_Head');
            local objHeadImage = self:FindChild(objHead, 'Head/Mask/Image');

            objHead:SetActive(false);
            objRank:SetActive(false);
            objBetBtn:SetActive(false);
            objPlayBackBtn:SetActive(false);
            objImageNotStart:SetActive(false);
            objImagePlaying:SetActive(false);
            objImage1:SetActive(false);
            objImage2:SetActive(false);
            objImage3:SetActive(false);
            objImage4:SetActive(false);
            objImage5:SetActive(false);

            local _setLineColor = function(color)
                local lineTable = {objImageLine1, objImageLine2}
                for p = 1, #(lineTable) do
                    for k, v in pairs(lineTable[p].transform) do
                        v.gameObject:GetComponent('Image').color = color;
                    end
                end
            end
            _setLineColor(whiteColor);
            
            objImageBG1:GetComponent('Image').color = whiteColor2;

            local lineTable = {objImageLine6, objImageLine7};
            for p = 1, #(lineTable) do
                for k, v in pairs(lineTable[p].transform) do
                    v.gameObject:GetComponent('Image').color = whiteColor;
                    v.gameObject:SetActive(false);
                end
            end

            if tempRoundData[self.showIndex + tIndex] then
                local ceof = i > 1 and math.floor(index / 2) or index * math.floor(2 / 2 ^ tIndex);
                local akDataGroup = tempRoundData[self.showIndex + tIndex]
                local uiCurGroupIndex = ceof + (math.floor(j / 2) + 1)
                local data = akDataGroup[uiCurGroupIndex]

                if data then

                    local _sort = function(a, b)
                        return a.defPlayerID < b.defPlayerID;
                    end
                    
                    local _1 = data.kPly1Data;
                    local _2 = data.kPly2Data;
                    
                    local info = nil;
                    local roundData = nil;
                    local iIndex = iIndex or j;
                    if iIndex % 2 == 0 then

                        roundData = _1;
                        info = { 
                            serverData = self.serverData, 
                            battleData = data, 
                            tempData = _1,
                        };

                        local totalMoney = data.dwPly1BetRate + data.dwPly2BetRate;
                        local betRate = (totalMoney * 0.9) / data.dwPly1BetRate;
                        betRate = betRate < 1.01 and 1.01 or betRate;
                        objText:GetComponent('Text').text = string.format('%0.02f', betRate);

                    elseif iIndex % 2 == 1 then
                        
                        roundData = _2;
                        info = { 
                            serverData = self.serverData, 
                            battleData = data, 
                            tempData = _2,
                        };

                        local totalMoney = data.dwPly1BetRate + data.dwPly2BetRate;
                        local betRate = (totalMoney * 0.9) / data.dwPly2BetRate;
                        betRate = betRate < 1.01 and 1.01 or betRate;
                        objText:GetComponent('Text').text = string.format('%0.02f', betRate);

                    end

                    objHead:SetActive(true);
                    objBetBtn:SetActive(true);
                    objOdds:SetActive(true);
                    
                    local callback = function(sprite)
                        local uiWindow = GetUIWindow("ArenaUIMatch")
		                if (uiWindow and objHeadImage) then
                            local comImage = objHeadImage:GetComponent('Image');
                            comImage.sprite = sprite;
                        end
                    end
                    GetHeadPicByData(roundData,callback)

                    if data.defPlyWinner ~= 0 then
                        objBetBtn:SetActive(false);

                        if data.defPlyWinner == roundData.defPlayerID then
                            objImage2:SetActive(true);
                        else
                            objImage4:SetActive(true);
                        end

                        if data.defBetPlyID == roundData.defPlayerID then
                            objImage5:SetActive(true);
                        end 
                    end

                    if roundData.defPlayerID == self.PlayerSetDataManager:GetPlayerID() then
                        objImageBG1:GetComponent('Image').color = greenColor2;
                    else
                        objImageBG1:GetComponent('Image').color = whiteColor2;
                    end

                    if data.defPlyWinner == roundData.defPlayerID then
                        _setLineColor(blackColor);
                    end

                    objName:GetComponent('Text').text = roundData.acPlayerName;

                    local _callbackBet = function()
                        -- OpenWindowImmediately('ArenaUIBet', info);
                        local akTarGroup = akDataGroup
                        local uiTarIndex = uiCurGroupIndex
                        -- OpenWindowImmediately('ArenaPlayerCompareUI', {kMatch = self.serverData, kBattleInfo = data})
                        OpenWindowImmediately('ArenaPlayerCompareUI', {kMatch = self.serverData, akBattleInfoGroup = akTarGroup, uiCurIndex = uiTarIndex})
                    end
                    
                    local _callbackHead = function()
                        -- 优先使用缓存数据, 如果有缓存数据, 那么不要再次请求了
                        if ArenaDataManager:GetInstance():ResetChachePlayerObserverDataToGlobalData(self.serverData, roundData.defPlayerID) then
                            self:ShowObserveUI(true, roundData.defPlayerID)
                            return
                        end
                        if not self.bClickObserve then
                            OpenWindowImmediately("LoadingUI")
                            self.bClickObserve = true;
                            SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_OTHER_MEMBER_PK_DATA, self.serverData.dwMatchType, self.serverData.dwMatchID, data.dwRoundID, data.dwBattleID, roundData.defPlayerID);
                        else
                            SystemUICall:GetInstance():Toast('点击太频繁了');
                            return;
                        end
                        local wait = CS.UnityEngine.WaitForSeconds(3);
                        CS_Coroutine.start(function()
                            coroutine.yield(wait);
                            self.bClickObserve = false;
                        end)		
                    
                        globalTimer:AddTimer(5000, function()
                            RemoveWindowImmediately("LoadingUI");
                        end, 1);
                    end

                    self:CommonBind(objBetBtn, _callbackBet);
                    self:CommonBind(objHeadBtn, _callbackHead);

                    --
                    local _func = function(obj)
                        if data.defPlyWinner == roundData.defPlayerID then
                            if iIndex == 0 then
                                self:FindChild(obj, 'Image_Mind'):SetActive(true);
                                self:FindChild(obj, 'Image_Mind'):GetComponent('Image').color = blackColor2;
                            elseif iIndex == 1 then
                                self:FindChild(obj, 'Image_Top1'):SetActive(true);
                                self:FindChild(obj, 'Image_Top1'):GetComponent('Image').color = blackColor2;
                            elseif iIndex == 2 then
                                self:FindChild(obj, 'Image_Top1'):SetActive(true);
                                self:FindChild(obj, 'Image_Top1'):GetComponent('Image').color = blackColor2;
                            elseif iIndex == 3 then
                                self:FindChild(obj, 'Image_Top2'):SetActive(true);
                                self:FindChild(obj, 'Image_Top2'):GetComponent('Image').color = blackColor2;
                            end
                        else
                            if iIndex == 0 then
                                self:FindChild(obj, 'Image_Bot2'):SetActive(true);
                            elseif iIndex == 1 then
                                self:FindChild(obj, 'Image_Bot1'):SetActive(true);
                            elseif iIndex == 2 then
                                self:FindChild(obj, 'Image_Bot1'):SetActive(true);
                            elseif iIndex == 3 then
                                self:FindChild(obj, 'Image_Mind'):SetActive(true);
                            end
                        end 
                    end

                    if gameObject.name == 'Item_LeftSmall1(Clone)' then
    
                        if tIndex == 0 or tIndex == 1 then
                            objImageLine1:SetActive(true);
                        end

                        if tIndex == 0 then

                            if self.serverData.dwRoundID <= 2 then
                                
                                if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET or
                                
                                self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH or 
                                
                                self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                                    objImageLine1:SetActive(false);
                                    _func(objImageLine6);
                                end
                            end
                        
                        elseif tIndex == 1 then

                            if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then

                            elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then

                            elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                                objImageLine1:SetActive(false);
                            end
                        end
                    end
                
                    if gameObject.name == 'Item_LeftBig_8(Clone)' then
    
                        if tIndex == 1 then
                            objImageLine2:SetActive(true);
                        end

                        if tIndex == 1 then
                            
                            if self.serverData.dwRoundID <= 2 then
                                
                                if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET or
                                
                                self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH or
                                
                                self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                                    objImageLine2:SetActive(false);
                                    _func(objImageLine7);          
                                end
                            end
                        end
                    end

                    --
                    if data.defBetPlyID == roundData.defPlayerID then
                        objBetBtn:SetActive(false);
                        
                        if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                            if self.serverData.dwRoundID >= data.dwRoundID or data.dwRoundID <= 2 then
                                objImage1:SetActive(true);
                                LuaEventDispatcher:dispatchEvent("ARENA_BET_RESULT", data)
                            end
                            
                        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then

                        end
                    else
                        if data.defBetPlyID > 0 then
                            objBetBtn:SetActive(false);
                        end
                    end

                    --
                    if self.tbData.CanBet == 0 then
                        objBetBtn:SetActive(false);
                        objOdds:SetActive(false);
                    end
                end
            else

                local curIndex = 0;

                local tRound = Round;
                if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
                    tRound = Round3;
                elseif self.serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
                    tRound = Round2;
                end

                for k = 1, #(tRound) do
                    if self.serverData.dwRoundID == tRound[k] then
                        curIndex = k;
                        break;
                    end

                    if self.serverData.dwRoundID == 0 then
                        curIndex = 6;
                        break;
                    end
                end

                if gameObject.name == 'Item_LeftSmall1(Clone)' then
                    if tIndex == 0 then
                        objImageLine1:SetActive(true);
                    end
                end

                if gameObject.name == 'Item_LeftBig_8(Clone)' then
                    if tIndex == 1 then
                        objImageLine2:SetActive(true);
                    end
                end

                if self.showIndex <= curIndex + 1 then
                    
                    if tIndex == (curIndex - self.showIndex + 1) % 3 then

                        local data = nil;
                        if tempRoundData[curIndex] then

                            if gameObject.name == 'Item_LeftSmall1(Clone)' or gameObject.name == 'Item_LeftBig_8(Clone)' then
                                data = tempRoundData[curIndex][j + 1];
                            else
                                data = tempRoundData[curIndex][index * 2 ^ (2 - tIndex) + j + 1];
                            end

                        end

                        if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                            
                            objImageNotStart:SetActive(true);

                        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                            
                            objImagePlaying:SetActive(true);
                            objPlayBackBtn:SetActive(true);

                            if data then
                                local name = '';
                                if data.defPlyWinner == data.kPly1Data.defPlayerID then
                                    name = data.kPly1Data.acPlayerName;
                                else
                                    name = data.kPly2Data.acPlayerName;
                                end
                                self:FindChildComponent(objImagePlaying, 'Text', 'Text').text = name .. '获胜';
                            end
                            
                            local _callbackPlay = function(obj)
                                ARENA_PLAYBACK_DATA = data;
                                self.ArenaDataManager:RePlay(self.serverData.dwMatchType, self.serverData.dwMatchID, data)
                            end
                            self:CommonBind(objPlayBackBtn, _callbackPlay);

                        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                            
                        end

                    elseif tIndex > (curIndex - self.showIndex + 1) % 3 then
                        
                        if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                            
                            objImageNotStart:SetActive(true);
                        
                        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                        
                            objImageNotStart:SetActive(true);
                        
                        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then

                        end

                    else

                        if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                            
                            objImageNotStart:SetActive(true);
                        
                        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                        
                            objImageNotStart:SetActive(true);
                        
                        elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then

                        end

                    end
                else
                    
                    if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                        
                        objImageNotStart:SetActive(true);
                    
                    elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                        
                        objImageNotStart:SetActive(true);
                    
                    elseif self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then

                    end

                end
                
            end

        end
    end

    if gameObject.name == 'Item_LeftSmall(Clone)' then

        for i = 0, 2 do
            if i < 2 then
                _func(i);
            else
                _func(i, index);
            end
        end

    elseif gameObject.name == 'Item_LeftSmall1(Clone)' then

        for i = 0, 2 do
            _func(i);
        end
        
        -- TODO 排名特殊处理
        if self.serverData.dwRoundID <= 2 then

            if self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then

                for i = 0, getTableSize2(objItemTable[3]) - 1 do
                    if self.vtd and self.vtd[i + 1] then
                        local data = self.vtd[i + 1];
                        local objHead = self:FindChild(objItemTable[3][i], 'Image_Head');
                        local objHeadImage = self:FindChild(objHead, 'Head/Mask/Image');
                        local objHeadOdds = self:FindChild(objHead, 'Image_Odds');
                        local objBetBtn = self:FindChild(objItemTable[3][i], 'Button_Bet');
                        local objImageRank = self:FindChild(objItemTable[3][i], 'Image_Rank');
                        local objImage1 = self:FindChild(objItemTable[3][i], 'Image1');
                        local objImage2 = self:FindChild(objItemTable[3][i], 'Image2');
                        local objImage3 = self:FindChild(objItemTable[3][i], 'Image3');
                        local objImage4 = self:FindChild(objItemTable[3][i], 'Image4');
                        local objImage5 = self:FindChild(objItemTable[3][i], 'Image5');
                        
                        objImageRank:SetActive(true);
                        objHeadOdds:SetActive(false);
                        objBetBtn:SetActive(false);
                        objImage1:SetActive(false);
                        objImage2:SetActive(false);
                        objImage3:SetActive(false);
                        objImage4:SetActive(false);
                        objImage5:SetActive(false);
                        
                        self:FindChildComponent(objHead, 'Text_Name', 'Text').text = data.acPlayerName;
                        objImageRank.transform:GetChild(i + 1).gameObject:SetActive(true);
                        local callback = function(sprite)
                            local uiWindow = GetUIWindow("ArenaUIMatch")
                            if (uiWindow and objHeadImage) then
                                local comImage = objHeadImage:GetComponent('Image');
                                comImage.sprite = sprite;
                            end
                        end
                        GetHeadPicByData(data,callback)
                    end
                end
            end
        end

    elseif gameObject.name == 'Item_LeftBig_8(Clone)' then

        for i = 0, 2 do
            _func(i);
        end

    end
end

function ArenaUIMatch:SortBattleData(tempRoundData)

    local tRound = Round;
    if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        tRound = Round3;
    elseif self.serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
        tRound = Round2;
    end

    local count = #(tRound);

    local vtd = {};
    if tempRoundData[count] then
        for i = 1, #(tempRoundData[count]) do
            if tempRoundData[count][i].defPlyWinner == tempRoundData[count][i].kPly1Data.defPlayerID then
                table.insert(vtd, tempRoundData[count][i].kPly1Data);
                table.insert(vtd, tempRoundData[count][i].kPly2Data);
            else
                table.insert(vtd, tempRoundData[count][i].kPly2Data);
                table.insert(vtd, tempRoundData[count][i].kPly1Data);
            end
        end
        self.vtd = vtd;
    end
end

function ArenaUIMatch:OnRefSCLeft2()
    --
    local objItemTable = {};
    local objItemLeftBig = self:FindChild(self.objSCLeftContent2, 'Item_LeftBig');
    local objItemLeftBig2 = self:FindChild(self.objSCLeftContent2, 'Item_LeftBig2');
    local objItemLeftBig3 = self:FindChild(self.objSCLeftContent2, 'Item_LeftBig3');
    objItemLeftBig:SetActive(false);
    objItemLeftBig2:SetActive(false);
    objItemLeftBig3:SetActive(false);

    local tempObj = nil;
    if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        tempObj = objItemLeftBig3;
    elseif self.serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
        tempObj = objItemLeftBig2;
    elseif self.serverData.dwMatchType >= ARENA_TYPE.DA_SHI then
        tempObj = objItemLeftBig;
    end
    
    tempObj:SetActive(true);
    local tRect = tempObj:GetComponent('RectTransform');
    local rect = self.objSCLeftContent2:GetComponent('RectTransform');
    rect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, tRect.rect.width);
    rect:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, tRect.rect.height);

    local goTF = tempObj.transform;
    for i = 0, goTF.childCount - 1 do
        if not objItemTable[i] then
            objItemTable[i] = {};
        end

        local goTF2 = goTF:GetChild(i);
        for j = 0, goTF2.childCount - 1 do
            local go = goTF2:GetChild(j).gameObject;
            objItemTable[i][j] = go;
        end
        
    end

    --
    -- self.serverData.dwRoundID = 32;

    local tRound = Round;
    if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        tRound = Round3;
    elseif self.serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
        tRound = Round2;
    end

    local count = #(tRound);
    local tempRoundData = {};
    for i = 1, #(tRound) do
        if tRound[i] >= self.serverData.dwRoundID then
            table.insert(tempRoundData, self.matchData[tRound[i]]);
        end
    end

    --
    local curIndex = 0;
    for i = 0, getTableSize2(objItemTable) - 1 do
        for j = 0, getTableSize2(objItemTable[i]) - 1 do
            local comName = self:FindChild(objItemTable[i][j], 'Text_Name');
            local comBG = self:FindChild(objItemTable[i][j], 'Image_BG');
            local comBGlose = self:FindChild(objItemTable[i][j], 'Image_BG_lose');
            comBG:SetActive(true);
            comBGlose:SetActive(false);
            comBG:GetComponent('Image').color = whiteColor2;
            comBGlose:GetComponent('Image').color = whiteColor2;

            if tempRoundData[i + 1] and tempRoundData[i + 1][math.floor(j / 2) + 1] then
                curIndex = i;
                local data = tempRoundData[i + 1][math.floor(j / 2) + 1];
                local roundData = nil;
                if j % 2 == 0 then
                    roundData = data.kPly1Data;
                elseif j % 2 == 1 then
                    roundData = data.kPly2Data;
                end

                if i == count - 1 then
                    roundData = self.vtd[1];
                end

                local objImageLineTable = {};
                table.insert(objImageLineTable, self:FindChild(objItemTable[i][j], 'Image_Line1'));
                table.insert(objImageLineTable, self:FindChild(objItemTable[i][j], 'Image_Line2'));
                table.insert(objImageLineTable, self:FindChild(objItemTable[i][j], 'Image_Line3'));
                table.insert(objImageLineTable, self:FindChild(objItemTable[i][j], 'Image_Line4'));
                table.insert(objImageLineTable, self:FindChild(objItemTable[i][j], 'Image_Line5'));
                local _setLineColor = function(color)
                    for p = 1, #(objImageLineTable) do
                        if objImageLineTable[p].activeSelf then
                            for k, v in pairs(objImageLineTable[p].transform) do
                                if v.gameObject.activeSelf then
                                    v.gameObject:GetComponent('Image').color = color;
                                end
                            end
                        end
                    end
                end

                if roundData.defPlayerID == self.PlayerSetDataManager:GetPlayerID() then
                    comBG:GetComponent('Image').color = greenColor2;
                    comBGlose:GetComponent('Image').color = greenColor2;
                end

                if data.defPlyWinner == 0 then
                    _setLineColor(whiteColor);
                else
                    if data.defPlyWinner == roundData.defPlayerID then
                        _setLineColor(blackColor);
                    else
                        if i ~= getTableSize2(objItemTable) - 1 then
                            comBG:SetActive(false);
                            comBGlose:SetActive(true);
                        end
                    end
                end

                comName:GetComponent('Text').text = roundData.acPlayerName;
            else
                if i == curIndex + 1 and tempRoundData[curIndex + 1] then
                    local data = tempRoundData[curIndex + 1][j + 1];
                    if data and data.defPlyWinner ~= 0 then
                        if data.defPlyWinner == data.kPly1Data.defPlayerID then
                            comName:GetComponent('Text').text = data.kPly1Data.acPlayerName;
                        else
                            comName:GetComponent('Text').text = data.kPly2Data.acPlayerName;
                        end
                    else
                        comName:GetComponent('Text').text = '比赛未开始';
                    end
                else
                    comName:GetComponent('Text').text = '比赛未开始';
                end
            end
        end
    end

    
end

function ArenaUIMatch:OnRefSCRight()

    local rankData = self.ArenaDataManager:GetRankData(self.serverData.dwMatchType, self.serverData.dwMatchID);
    local averageSliver, TopRank = self.ArenaDataManager:GetobjAverageSliver(self.serverData.dwMatchType, self.serverData.dwMatchID);
    self.rankData = rankData;
    self.topRank = TopRank;

    local lvSC = self.objSCRight:GetComponent('LoopListView2');
    local scrollRect = self.objSCRight:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Item_Right');
            self:OnScrollChanged1(obj.gameObject, self.rankData[index + 1], index);
            return obj;
        end
        
        self.rightCount = getTableSize2(self.rankData);
        if not self.inited1 then
            self.inited1 = true;
            lvSC:InitListView(self.rightCount, _func);
        else
            lvSC:SetListItemCount(self.rightCount, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCRight = lvSC;
    end
    
    --
    local objTextAll = self:FindChild(self.objImageAll, 'Image/Text');
    objTextAll:GetComponent('Text').text = self.tbData.RankRewardPool;
    local objTextAverage = self:FindChild(self.objImageAverage, 'Image/Text');
    objTextAverage:GetComponent('Text').text = math.floor(averageSliver);
end

function ArenaUIMatch:OnScrollChanged1(gameObject, data, index)
    gameObject:SetActive(true);

    self:SetItemSingle1(gameObject, data, index)
end

function ArenaUIMatch:SetItemSingle1(gameObject, data, index)

    if not data then
        return;
    end

    local comName = self:FindChildComponent(gameObject, 'Text_Name', 'Text');
    local comNum = self:FindChildComponent(gameObject, 'Text_Num', 'Text');
    comName.text = data.acPlayerName;
    comNum.text = data.dwValue;

    if self.rankData then
        local rData = self.topRank[data.defPlayerID];
        if rData then
            comName.color = redColor;
            comNum.color = redColor;
        else
            comName.color = blackColor3;
            comNum.color = blackColor3;
        end
    end
end

function ArenaUIMatch:RefreshUI(data)

    if not data then
        return;
    end

    local tbMatchData = self.ArenaDataManager:GetTBMatchData() or {};
    local tbData = tbMatchData[data.dwMatchType];

    if not tbData then
        return;
    end

    self.bAutoMove = true;

    self.tbData = tbData;
    self.serverData = data;
    self.showIndex = 1;
    self.objTopLeftBtn:SetActive(false);
    self.objTopRightBtn:SetActive(true);
    self.objImageTop:SetActive(true);
    self.objSCLeft1:SetActive(true);
    self.objSCLeft2:SetActive(false);
    
    if self.tbData.Peoples == 8 then
        self.leftCount = 1;
        self.clickCount = 2;
        self.itemName = 'Item_LeftBig_8';
    
    elseif self.tbData.Peoples == 16 then
        self.leftCount = 4;
        self.clickCount = 3;
        self.itemName = 'Item_LeftSmall';

    elseif self.tbData.Peoples == 32 then
        self.leftCount = 8;
        self.clickCount = 4;
        self.itemName = 'Item_LeftSmall';

    end

    self:OnRefLeftTop();

    SendRequestArenaMatchOperate(ARENA_REQUEST_BATTLE, data.dwMatchType, data.dwMatchID);
    SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_BET_RANK, data.dwMatchType, data.dwMatchID);

    --
    if self.timer then
        self:RemoveTimer(self.timer);
        self.timer = nil;
    end
    self.timer = self:AddTimer(10000, function()
        SendRequestArenaMatchOperate(ARENA_REQUEST_BATTLE, self.serverData.dwMatchType, self.serverData.dwMatchID);
    end, -1);

    --
    RoleDataManager:GetInstance():SetArenaObserveData(true);
    GiftDataManager:GetInstance():SetArenaObserveData(true);
    ItemDataManager:GetInstance():SetArenaObserveData(true);
    MartialDataManager:GetInstance():SetArenaObserveData(true);
end

function ArenaUIMatch:QuaryBetRank(info)
    if self.serverData.dwMatchType == info.dwMatchType and self.serverData.dwMatchID == info.dwMatchID then
        SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_BET_RANK, info.dwMatchType, info.dwMatchID);
    end
end

function ArenaUIMatch:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_BATTLEDATA');
    self:RemoveEventListener('ONEVENT_REF_BATTLEDATA_FINISH');
    self:RemoveEventListener('ONEVENT_QUARY_RANKDATA');
    self:RemoveEventListener('ONEVENT_REF_RANKDATA');
    self:RemoveEventListener('ONEVENT_REF_SHOW_OBSERVE');
end

function ArenaUIMatch:OnEnable()
    local _callback = function(info)
        self:OnRefSCLeft1();
        self:OnRefLeftTop();
        self:OnRefLeftBot();
        -- self:HideBetUI();
        self:MoveToCurRound();
        self:DanMu();

        self.ArenaDataManager:SetPushFlag(0);
        self.ArenaDataManager:SetBetFlag(0);
    end
    self:AddEventListener('ONEVENT_REF_BATTLEDATA', function(info)
        _callback(info);
    end);
    self:AddEventListener('ONEVENT_REF_BATTLEDATA_FINISH', function(info)
        _callback(info);
    end);
    self:AddEventListener('ONEVENT_QUARY_RANKDATA', function(info)
        self:QuaryBetRank(info);
    end);
    self:AddEventListener('ONEVENT_REF_RANKDATA', function(info)
        self:OnRefSCRight();
    end);
    self:AddEventListener('ONEVENT_REF_SHOW_OBSERVE', function(uiPlayerID)
        self:ShowObserveUI(false, uiPlayerID)
    end);
end

function ArenaUIMatch:DanMu()

    if self.ArenaDataManager:GetPushFlag() == 0 then
        return;
    end

    local battleData = self.ArenaDataManager:GetCurBattleData();
    if self.serverData.dwMatchType == battleData.dwMatchType and 
    self.serverData.dwMatchID == battleData.dwMatchID and
    self.serverData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then

        local matchData = self.matchData[self.serverData.dwRoundID];
        if matchData then
            local index = 0;
            local random = 500;
            local times = #(matchData);
            local _func;
            _func = function(random)
                random = random and random or math.random(1000, 2000);

                if times == 0 then
                    return;
                end
                times = times - 1;

                self:AddTimer(random, function()
                    index = index + 1;
                    local winP = matchData[index].kPly1Data;
                    local defP = matchData[index].kPly2Data;
                    if matchData[index].defPlyWinner ~= matchData[index].kPly1Data.defPlayerID then
                        winP = matchData[index].kPly2Data;
                        defP = matchData[index].kPly1Data;
                    end
                    local strText = '%s在%s中战胜了%s';
                    strText = string.format(strText, winP.acPlayerName, RoundToString[matchData[index].dwRoundID], defP.acPlayerName);
                    SystemUICall:GetInstance():BarrageShow(strText);
    
                    _func();
                end, 1);
            end
            _func(random);
        end
    end
end

function ArenaUIMatch:HideBetUI()
    local arenaUIBet = GetUIWindow('ArenaUIBet');
    if arenaUIBet then
        arenaUIBet:OnClickCloseBtn();
    end
end

function ArenaUIMatch:MoveToCurRound()

    if self.bAutoMove then
        self.bAutoMove = false;
    else
        if self.ArenaDataManager:GetPushFlag() == 0 or self.ArenaDataManager:GetBetFlag() == 1 then
            return;
        end
    end

    local round = self.serverData.dwRoundID;
    round = round == 0 and 2 or round;
    local index = 1;

    local tRound = Round;
    if self.serverData.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        tRound = Round3;
    elseif self.serverData.dwMatchType == ARENA_TYPE.DA_ZHONG then
        tRound = Round2;
    end

    for i = 1, #(tRound) do
        if round == tRound[i] then
            index = i;
            break;
        end
    end

    local count = index - self.showIndex;
    if self.showIndex < 4 then
        for i = 1, count do
            self:OnClickTopRightBtn(self.objTopRightBtn);
        end
    end
end

function ArenaUIMatch:OnDestroy()
    if self.lvSCLeft then
        self.lvSCLeft.mOnGetItemByIndex = nil;
    end

    if self.lvSCRight then
        self.lvSCRight.mOnGetItemByIndex = nil;
    end
end

function ArenaUIMatch:ShowObserveUI(bUseCache, uiPlayerID)
    -- 助威界面开启时由助威界面接收数据
    if (not uiPlayerID) or (uiPlayerID == 0) or IsWindowOpen("ArenaPlayerCompareUI") then
        return
    end
    RemoveWindowImmediately("LoadingUI")
    local observeArenaInfo = globalDataPool:getData('ObserveArenaInfo');
    if (not observeArenaInfo) or (uiPlayerID ~= observeArenaInfo.defPlayerID) then
        return
    end
    -- 保存一份数据到缓存
    if bUseCache ~= true then
        ArenaDataManager:GetInstance():SetCachePlayerObserverData(self.serverData, observeArenaInfo)
    end
    local info = {};
    info.index = 1;
    info.roleIDs = observeArenaInfo.EmbattleInfo;
    OpenWindowImmediately("ObserveUI", info);
end

return ArenaUIMatch;