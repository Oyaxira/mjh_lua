ArenaUISignUp = class('ArenaUISignUp', BaseWindow);

local whiteColor = DRCSRef.Color(1, 1, 1, 1);
local blackColor = DRCSRef.Color(0.17, 0.17, 0.17, 1);

function ArenaUISignUp:ctor(info)
    self._script = info;
    self.bindBtnTable = {};

    self:SetGameObject(info.objSignUp);
    self:OnCreate(info.objSignUp);
end

function ArenaUISignUp:Create()

end

function ArenaUISignUp:Init()

    self.RankDataManager = RankDataManager:GetInstance();
    self.ArenaDataManager = ArenaDataManager:GetInstance();
    self.tbClanData = TableDataManager:GetInstance():GetTable("Clan");

    --
    self.objImageToggleGroup = self:FindChild(self._gameObject, 'Image_ToggleGroup');
    
    --
    self.objToggle1 = self:FindChild(self.objImageToggleGroup, 'Toggle1');
    self.objToggle2 = self:FindChild(self.objImageToggleGroup, 'Toggle2');
    
    --
    self.objSCMatch = self:FindChild(self._gameObject, 'SC_Match');
    self.objSCMatchContent = self:FindChild(self.objSCMatch, 'Viewport/Content');

    --
    table.insert(self.bindBtnTable, self.objToggle1);
    table.insert(self.bindBtnTable, self.objToggle2);

    self:BindBtnCB();

end

function ArenaUISignUp:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUISignUp:OnclickBtn(obj, boolHide)
    if obj == self.objToggle1 then
        self:OnClickToggle1(obj, boolHide);
        
    elseif obj == self.objToggle2 then
        self:OnClickToggle2(obj, boolHide);

    end

end

function ArenaUISignUp:OnClickToggle1(obj, boolHide)
    
    local comText = self:FindChildComponent(obj, 'Label', 'Text');
    if boolHide then
        comText.color = whiteColor;
    else
        comText.color = blackColor;
    end
end

function ArenaUISignUp:OnClickToggle2(obj, boolHide)

    local comText = self:FindChildComponent(obj, 'Label', 'Text');
    if boolHide then
        comText.color = whiteColor;
    else
        comText.color = blackColor;
    end
end

function ArenaUISignUp:OnRefSCMatch(data)

    local matchData = self.ArenaDataManager:GetFormatData();
    self.matchData = matchData;

    -- 
    local week = tonumber(os.date('%w'));
    week = week == 0 and 7 or week;
    
    local tempTable = {};
    if week >= 1 and week <= 5 then
        for i = 1, #(matchData) do
            if matchData[i].dwMatchType <= ARENA_TYPE.DA_ZHONG then
                table.insert(tempTable, matchData[i]);
            end
        end
    elseif week == 6 then
        for i = 1, #(matchData) do
            if matchData[i].dwMatchType == ARENA_TYPE.DA_SHI then
                table.insert(tempTable, matchData[i]);
            end
        end
    end

    for i = 1, #(tempTable) do
        for j = 1, #(matchData) do
            if tempTable[i].dwMatchType == matchData[j].dwMatchType then
                table.remove(matchData, j);
                break;
            end
        end
    end
    for i = #(tempTable), 1, -1 do
        table.insert(matchData, 1, tempTable[i]);
    end

    local lvSC = self.objSCMatch:GetComponent('LoopListView2');
    local scrollRect = self.objSCMatch:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Item_Match');
            self:OnScrollChanged(obj.gameObject, self.matchData[index + 1], index);
            return obj;
        end
        
        self.count = getTableSize2(self.matchData);
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.count, _func);
        else
            lvSC:SetListItemCount(self.count, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCMatch = lvSC;
    end
    
end

function ArenaUISignUp:OnScrollChanged(gameObject, data, index)
    gameObject:SetActive(true);

    self:SetItemSingle(gameObject, data, index);
end

function ArenaUISignUp:SetItemSingle(gameObject, data, index)

    if not data then
        return;
    end

    self.singleMatchData = data;
    local roleEmbattle = RoleDataManager:GetInstance():GetRoleEmbattleInfo();
    local tbMatchData = self.ArenaDataManager:GetTBMatchData() or {};
    local tbLimitData = self.ArenaDataManager:GetTBLimitData() or {};
    local tempData = tbMatchData[data.dwMatchType];

    if not tempData then
        return;
    end

    local place = data.uiSignUpPlace;
    local state = data.uiStage;
    local bWhatBtnShow = data.dwMatchType == ARENA_TYPE.DA_SHI;

    --
    local objImageBG1 = self:FindChild(gameObject, 'Image_BG1');
    local objImageBG2 = self:FindChild(gameObject, 'Image_BG2');
    local objImageBG3 = self:FindChild(gameObject, 'Image_BG3');
    local objImageFire = self:FindChild(gameObject, 'Image_fire');
    local comTextTitle = self:FindChildComponent(gameObject, 'Text_Title', DRCSRef_Type.Text);
    local objTextDec = self:FindChild(gameObject, 'Text_Dec');
    --local objImageBuff = self:FindChild(gameObject, 'Image_Buff');
    local objTips = self:FindChild(gameObject, 'Tips');
    local objSignUP = self:FindChild(gameObject, 'SignUP');
    local objSignUpLater = self:FindChild(gameObject, 'SignUpLater');
    local objTipsBtn = self:FindChild(gameObject, 'Button_Tips');
    local objWhatBtn = self:FindChild(gameObject, 'Button_What');
    local objRedPoint = self:FindChild(gameObject, 'Image_redPoint');
    objTipsBtn:SetActive(data.dwMatchType < ARENA_TYPE.HUA_SHAN);

    objImageFire:SetActive(false);
    if tempData.BaseID == ARENA_TYPE.HUA_SHAN then
        objImageBG1:SetActive(false);
        objImageBG2:SetActive(false);
        objImageBG3:SetActive(true);
    elseif tempData.BaseID >= ARENA_TYPE.DA_SHI and tempData.BaseID < ARENA_TYPE.HUA_SHAN then
        objImageBG1:SetActive(false);
        objImageBG2:SetActive(true);
        objImageBG3:SetActive(false);
    else
        objImageBG1:SetActive(true);
        objImageBG2:SetActive(false);
        objImageBG3:SetActive(false);
    end

    --
    local objTextTime = self:FindChild(objSignUP, 'Text_Time');
    local objDec = self:FindChild(objSignUpLater, 'Dec');
    local objImage1 = self:FindChild(objDec, 'Mark1');
    local objImage2 = self:FindChild(objDec, 'Mark2');
    local objImage3 = self:FindChild(objDec, 'Mark3');
    local objImage4 = self:FindChild(objDec, 'Mark4');
    local objImage5 = self:FindChild(objDec, 'Mark5');
    local objTextDec1 = self:FindChild(objDec, 'Text_Dec1');
    local objTextDec2 = self:FindChild(objDec, 'Text_Dec2');
    local objTextDec3 = self:FindChild(objDec, 'Text_Dec3');
    objDec:SetActive(true);
    objTextDec1:SetActive(false);
    objTextDec2:SetActive(false);
    objTextDec3:SetActive(false);
    local imageTable = {};
    table.insert(imageTable, objImage1);
    table.insert(imageTable, objImage2);
    table.insert(imageTable, objImage3);
    table.insert(imageTable, objImage4);
    table.insert(imageTable, objImage5);

    --
    local _callbackTips = function(obj)
        local tips = {};
        local content = {};
        if data.dwMatchType > ARENA_TYPE.DA_SHI then
            tips.title = string.format('%s规则', GetLanguageByID(tempData.MatchDecNameID));
            table.insert(content, '无能力限制');
            table.insert(content, string.format('使用%s武学造成伤害+100%%', self.tbClanData[tempData.clan].ClanName));
        else
            tips.title = string.format('%s能力限制', GetLanguageByID(tempData.MatchDecNameID));
            local limitData = tbLimitData[tempData.BaseID];
            if limitData then
                if limitData.DarkGoldenMartialLevelUp > 0 then
                    table.insert(content, string.format('暗金武学等级上限：%d', limitData.DarkGoldenMartialLevelUp));
                end
                if limitData.GoldenMartialLevelUp > 0 then
                    table.insert(content, string.format('金色武学等级上限：%d', limitData.GoldenMartialLevelUp));
                end
                if limitData.OtherMartialLevelUps > 0 then
                    table.insert(content, string.format('其他武学等级上限：%d', limitData.OtherMartialLevelUps));
                end
                if limitData.HP > 0 then
                    table.insert(content, string.format('生命上限：%d', limitData.HP));
                end
                if limitData.BaseAttrUp > 0 then
                    table.insert(content, string.format('一级属性上限：%d', limitData.BaseAttrUp));
                end
                if limitData.JingTongAttrUp > 0 then
                    table.insert(content, string.format('精通属性上限：%d', limitData.JingTongAttrUp));
                end
            end
            table.insert(content, '（超过上限的能力不计算）');
        end
        tips.content = table.concat(content, '\n');
        OpenWindowImmediately('ArenaUIClanTips', tips);
    end

    local _func = function(type)
        local info = {
            type = type,
            data = data,
            tbData = tempData,
        }

        OpenWindowImmediately('ArenaUIFinalJoinNames', info);
    end

    local _callbackTipsWhat = function(obj)
        OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP_WITH_BTN, '不符合报名条件!', nil, {confirm = 1} });
    end
    
    local _callbackSignUp = function(obj)

        local sendData = function(matchType)
            -- TODO 数据上报
            MSDKHelper:SetQQAchievementData('arenasignup', matchType);
            MSDKHelper:SendAchievementsData('arenasignup');
        end

        local type = EmBattleSchemeType.EBST_Team;
        local championData = self.ArenaDataManager:GetChampionData();

        if data.dwMatchType == ARENA_TYPE.SHAO_NIAN then
            if roleEmbattle[type] and roleEmbattle[type][1] and #(roleEmbattle[type][1]) > 0 then
                SendRequestArenaMatchOperate(ARENA_REQUEST_SIGNUP, tempData.BaseID);
                sendData(tempData.BaseID);
            else
                SystemUICall:GetInstance():Toast('请先配置平台阵容才可报名');
            end
        end

        if data.dwMatchType == ARENA_TYPE.DA_ZHONG then

            if championData.dwNewHandChampionTimes < tempData.SignUpCondNewHandChampion then
                local strText = string.format('少年赛状元可报名大众赛');
                SystemUICall:GetInstance():Toast(strText);
            else
                if roleEmbattle[type] and roleEmbattle[type][1] and #(roleEmbattle[type][1]) > 0 then
                    SendRequestArenaMatchOperate(ARENA_REQUEST_SIGNUP, tempData.BaseID);
                    sendData(tempData.BaseID);
                else
                    SystemUICall:GetInstance():Toast('请先配置平台阵容才可报名');
                end
            end
        end
        
        if data.dwMatchType == ARENA_TYPE.DA_SHI then
            if championData.dwPublicChampionTimes < tempData.SignUpCondPublicChampion then
                local strText = string.format('大众赛前三甲可报名大师赛');
                SystemUICall:GetInstance():Toast(strText);
            else
                if roleEmbattle[type] and roleEmbattle[type][1] and #(roleEmbattle[type][1]) > 0 then
                    SendRequestArenaMatchOperate(ARENA_REQUEST_SIGNUP, tempData.BaseID);
                    sendData(tempData.BaseID);
                else
                    SystemUICall:GetInstance():Toast('请先配置平台阵容才可报名');
                end
            end
        end
    end
    
    local _callbackTeam = function(obj)
        OpenWindowImmediately('PlayerSetUI');
        local playerSetUI = GetUIWindow('PlayerSetUI');
        if playerSetUI then
            local _callback = function()
                SendRequestArenaMatchOperate(ARENA_REQUEST_UPDATE_PK_DATA, data.dwMatchType, data.dwMatchID, 0, 0, 0, 7);
            end
            playerSetUI:SetCallBack(_callback);
        end
    end
    
    local _callbackInto = function(obj)
        OpenWindowImmediately('ArenaUIMatch', data);
    end

    local _callbackJoin = function(obj)
        if data.dwMatchType == ARENA_TYPE.DA_ZHONG then
            local tips = {
                title = '大众赛',
                content = '参加并获得一次少年赛冠军，即可永久开启大众赛报名资格，且永远不能再参加少年赛。'
            }
            OpenWindowImmediately("TipsPopUI", tips);

        elseif data.dwMatchType == ARENA_TYPE.DA_SHI then
            local tips = {
                title = '大师赛',
                content = '本周内参加并获得一次大众赛前三名，即可开启本周的大师赛报名资格。'
            }
            OpenWindowImmediately("TipsPopUI", tips);

        elseif data.dwMatchType == ARENA_TYPE.HUA_SHAN then
            OpenWindowImmediately('ArenaUIHuaShanFinalJoinNames');

        else
            _func(2);
            
        end
    end

    local _callbackWhat = function(obj)
        _callbackJoin(obj);
    end
    
    local objTipsWhatBtn = self:FindChild(objTips, 'Button_What');
    local objSignUpBtn = self:FindChild(objSignUP, 'Button_SignUp');
    local objTeamBtn = self:FindChild(objSignUpLater, 'Button_Team');
    local objIntoBtn = self:FindChild(objSignUpLater, 'Button_Into');
    local objJoinBtn = self:FindChild(objSignUpLater, 'Button_Join');
    
    self:CommonBind(objTipsBtn, _callbackTips);
    self:CommonBind(objTipsWhatBtn, _callbackTipsWhat);
    self:CommonBind(objSignUpBtn, _callbackSignUp);
    self:CommonBind(objTeamBtn, _callbackTeam);
    self:CommonBind(objIntoBtn, _callbackInto);
    self:CommonBind(objJoinBtn, _callbackJoin);
    self:CommonBind(objWhatBtn, _callbackWhat);

    objTeamBtn:SetActive(false);
    objIntoBtn:SetActive(false);
    objJoinBtn:SetActive(false);
    objWhatBtn:SetActive(false);

    --
    objTips:SetActive(false);
    objSignUP:SetActive(false);
    objSignUpLater:SetActive(false);
    objRedPoint:SetActive(false);
    
    -- TODO 各种判断
    local _tonumber = function(array)
        for i = 1, #(array) do
            array[i] = tonumber(array[i]);          
        end
        return array;
    end
    local nowTime = os.date('*t');
    local timeTable = string.split(tempData.SignTime or {}, ';');
    local openWeekday = _tonumber(string.split(timeTable[1] or '', '-'));
    local openFromTime = _tonumber(string.split(timeTable[2] or '', ':'));
    local openToTime = _tonumber(string.split(timeTable[3] or '', ':'));
    
    local timeTable1 = string.split(tempData.MatchTime or {}, ';');
    local openWeekday1 = _tonumber(string.split(timeTable1[1] or '', '-'));
    local openFromTime1 = _tonumber(string.split(timeTable1[2] or '', ':'));
    local openToTime1 = _tonumber(string.split(timeTable1[3] or '', ':'));
    
    --
    local strText1 = '';
    local strText2 = '';
    local bInTime = false;
    if tempData.OpenGap == 1 then

        strText1 = string.format('【报名截止：今日%d点】', openToTime[1]);
        strText2 = string.format('【比赛时间：今日%d点】', openFromTime1[1]);
    
        -- if InTime(os.time(), openFromTime, openToTime) then
        --     bInTime = true;
        -- end
        
    elseif tempData.OpenGap == 6 or tempData.OpenGap == 7 then
        local week = tonumber(os.date('%w'));
        if week == 0 then
            week = 7;
        end
        local weekday = {'一', '二', '三', '四', '五', '六', '日'};
        strText1 = string.format('【报名截止：本周%s %d点】', weekday[openWeekday1[1]], openToTime[1]);
        strText2 = string.format('【比赛时间：本周%s %d点】', weekday[openWeekday1[1]], openFromTime1[1]);

        if week == openWeekday1[1] then
            strText1 = string.format('【报名截止：今日 %d点】', openToTime[1]);
            strText2 = string.format('【比赛时间：今日 %d点】', openFromTime1[1]);
        end

        -- if week < openWeekday[#(openWeekday)] then
        --     bInTime = true;
        -- elseif week == openWeekday[#(openWeekday)] then
        --     if InTime(os.time(), openFromTime, openToTime) then
        --         bInTime = true;
        --     end
        -- end 

        if week < 7 then
            bInTime = true;
        end
    end
    
    comTextTitle.text = GetLanguageByID(tempData.MatchDecNameID) .. data.dwMatchID;
    if DEBUG_MODE then 
        comTextTitle.text = comTextTitle.text .. '(' .. data.dwMatchType .. ')'
    end
    objTextDec:GetComponent('Text').text = GetLanguageByID(tempData.MatchTypeNameID);

    objTextTime:GetComponent('Text').text = strText1;
    objTextDec2:GetComponent('Text').text = strText2;
    local strText = place > 32 and '入围娱乐赛' or '排名' .. place .. '，暂时入围正式赛';
    objTextDec1:GetComponent('Text').text = strText;
        
    -- 
    if data.dwMatchType == ARENA_TYPE.SHAO_NIAN or data.dwMatchType == ARENA_TYPE.DA_ZHONG then
        objTextDec1:GetComponent('Text').text = '报名成功';
    end
    
    local _setImageActive = function(obj)
        for i = 1, #(imageTable) do
            if obj == imageTable[i] then
                imageTable[i]:SetActive(true);
            else
                imageTable[i]:SetActive(false);
            end            
        end
    end

    _setImageActive();

    local matchText = data.dwRoundID .. '强进行中';
    if data.dwRoundID == 4 then
        matchText = '半决赛进行中';
    elseif data.dwRoundID == 2 then
        matchText = '决赛进行中';
    end

    --
    if state == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_NONE then

        objSignUpLater:SetActive(true);
        if data.dwMatchType <= ARENA_TYPE.DA_SHI then
            _setImageActive(objImage4);
        end
        objWhatBtn:SetActive(true);

    elseif state == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP then
        if data.dwMatchType > ARENA_TYPE.DA_SHI then
            if bInTime then
                objWhatBtn:SetActive(true);
            else
                objSignUpLater:SetActive(true);
                objJoinBtn:SetActive(true);
                if data.uiSignUpPlace == 100 then
                    _setImageActive(objImage5);
                end
                objTextDec2:SetActive(true);
            end
        else
            local bCon = self.ArenaDataManager:ArenaCanSignUp(data)

            if bCon then
                objSignUP:SetActive(true);
                objTeamBtn:SetActive(true);
                objRedPoint:SetActive(true);
                
                if place > 0 then
                    objSignUP:SetActive(false);
                    objSignUpLater:SetActive(true);
                    objRedPoint:SetActive(false);
                    objTextDec2:SetActive(true);
                    _setImageActive(objImage1);
                end
            else
                objSignUP:SetActive(false);
                objWhatBtn:SetActive(true);
            end
        end

    elseif state == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_CALC_BATTLE_RESULT then
        objSignUpLater:SetActive(true);
        objTextDec2:SetActive(true);

        if data.dwMatchType > ARENA_TYPE.DA_SHI then
            if data.uiSignUpPlace == 100 then
                _setImageActive(objImage5);
            end
        else
            if place > 0 then
                _setImageActive(objImage1);
            else
                _setImageActive(objImage3);
            end
        end

    elseif state == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_START_MATCH then
        objSignUpLater:SetActive(true);
        -- objTextDec2:SetActive(true);

        if place > 0 then
            _setImageActive(objImage2);
        else
            _setImageActive(objImage3);
        end

    elseif state == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
        objSignUpLater:SetActive(true);
        objIntoBtn:SetActive(true);
        objTextDec2:SetActive(false);
        objTextDec3:SetActive(true);
        objImageFire:SetActive(true);
        
        if place > 0 then
            _setImageActive(objImage2);
        else
            _setImageActive(objImage3);
        end
        objTextDec3:GetComponent('Text').text = matchText;
        
    elseif state == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
        objSignUpLater:SetActive(true);
        objIntoBtn:SetActive(true);
        objTextDec2:SetActive(false);
        objTextDec3:SetActive(true);
        objImageFire:SetActive(true);

        if place > 0 then
            _setImageActive(objImage2);
        else
            _setImageActive(objImage3);
        end
        objTextDec3:GetComponent('Text').text = matchText;

    elseif state == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
        objSignUpLater:SetActive(true);
        _setImageActive(objImage4);

        --
        if data.dwMatchType == ARENA_TYPE.HUA_SHAN then
            --
            self.RankDataManager:ResetArenaRankData();
            
            -- 擂台历史数据
            -- SendRequestArenaMatchOperate(ARENA_REQUEST_HISTORY_MATCH_DATA, ARENA_TYPE.HUA_SHAN, 0);
        end
    end

end

function ArenaUISignUp:RefreshUI()
    if self._gameObject.activeSelf then
        SendRequestArenaMatchOperate(ARENA_REQUEST_MATCH);
    end
end

function ArenaUISignUp:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_MATCHDATA');

end

function ArenaUISignUp:OnEnable()
    self:AddEventListener('ONEVENT_REF_MATCHDATA', function(info)
        self:OnRefSCMatch();
    end);

end

function ArenaUISignUp:OnDestroy()
    if self.lvSCMatch then
        self.lvSCMatch.mOnGetItemByIndex = nil;
    end
end

return ArenaUISignUp;