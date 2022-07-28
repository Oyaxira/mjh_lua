ArenaUIRecode = class('ArenaUIRecode', BaseWindow);

function ArenaUIRecode:ctor(info)
    self._script = info;
    self.curMatchData = nil;
    self.bindBtnTable = {};

    self:SetGameObject(info.objRecode);
    self:OnCreate(info.objRecode);
end

function ArenaUIRecode:Create()

end

function ArenaUIRecode:Init()

    self.ArenaDataManager = ArenaDataManager:GetInstance();

    self.objSCMatch = self:FindChild(self._gameObject, 'SC_Match');
end

function ArenaUIRecode:OnRefRecodeList()

    local _, matchData = self.ArenaDataManager:GetFormatData();
    self.matchData = matchData;
    self.count = getTableSize2(self.matchData);

    local lvSC = self.objSCMatch:GetComponent('LoopListView2');
    local scrollRect = self.objSCMatch:GetComponent('ScrollRect');
    if lvSC then

        local _func = function(item, index)
            local obj = item:NewListViewItem('Item_Recode');
            self:OnScrollChanged(obj.gameObject, self.matchData[index + 1], index);
            return obj;
        end
        
        if not self.inited then
            self.inited = true;
            lvSC:InitListView(self.count, _func);
        else
            lvSC:SetListItemCount(self.count, false);
            lvSC:RefreshAllShownItem();
        end 

        self.lvSCList = lvSC;
    end

end

function ArenaUIRecode:OnScrollChanged(gameObject, data, index)
    gameObject:SetActive(true);

    self:SetItemSingle(gameObject, data);
end

function ArenaUIRecode:SetItemSingle(gameObject, data)
    if not data then
        return;
    end

    local tbMatchData = self.ArenaDataManager:GetTBMatchData() or {};
    local tempData = tbMatchData[data.dwMatchType];

    if not tempData then
        return;
    end

    local comTime = self:FindChildComponent(gameObject, 'Text_Time', 'Text');
    local comTitle = self:FindChildComponent(gameObject, 'Text_Title', 'Text');
    local comRank = self:FindChildComponent(gameObject, 'Text_Rank', 'Text');
    local comBet = self:FindChildComponent(gameObject, 'Text_Bet', 'Text');
    local objGreenBtn = self:FindChild(gameObject, 'Button_green_1');

    local _callback = function()
        self.curMatchData = data;
        SendRequestArenaMatchOperate(ARENA_REQUEST_BATTLE, data.dwMatchType, data.dwMatchID);
    end
    self:CommonBind(objGreenBtn, _callback);

    comTitle.text = GetLanguageByID(tempData.MatchDecNameID) .. data.dwMatchID;
    local matchText = data.dwRoundID .. '强进行中';
    
    local strRank = string.format('排名：%d', data.dwRank);
    if data.dwRank <= 3 then
        local matchText = '状元';
        if data.dwRank == 2 then
            matchText = '榜眼';
        elseif data.dwRank == 3 then
            matchText = '探花';
        end
        strRank = string.format('排名：%s', matchText);
    elseif data.dwRank == 100 then
        strRank = '排名：未参赛';
    end
    comRank.text = strRank;
    comBet.text = string.format('我的助威：%d胜 +%d擂台币', data.dwBetWinTimes, data.dwBetWinMoney);
    local week = tonumber(os.date('%w', data.dwBattleTime));
    week = week == 0 and 7 or week;
    local weekday = {'一', '二', '三', '四', '五', '六', '日'};
    local time = os.date('%m月%d日', data.dwBattleTime);
    comTime.text = string.format('%s(周%s)', time, weekday[week]);
end

function ArenaUIRecode:RefreshUI()
    if self._gameObject.activeSelf then
        SendRequestArenaMatchOperate(ARENA_REQUEST_MATCH);
    end
end

function ArenaUIRecode:OnDisable()
    self:RemoveEventListener('ONEVENT_REF_BATTLEDATA');
    self:RemoveEventListener('ONEVENT_REF_MATCHDATA');

end

function ArenaUIRecode:OnEnable()
    self:AddEventListener('ONEVENT_REF_BATTLEDATA', function(info)
        if self._gameObject.activeSelf then
            self:OnRefRecode(info);
        end
    end);
    self:AddEventListener('ONEVENT_REF_MATCHDATA', function(info)
        if self._gameObject.activeSelf then
            self:OnRefRecodeList(info);
        end
    end);

end

function ArenaUIRecode:OnRefRecode(info)
    if self.curMatchData then
        OpenWindowImmediately('ArenaUIMatchRecode', self.curMatchData);
        SendRequestArenaMatchOperate(ARENA_REQUEST_JOKE_MATCH_DATA, self.curMatchData.dwMatchType, self.curMatchData.dwMatchID);
    end
end

function ArenaUIRecode:OnDestroy()
    if self.lvSCList then
        self.lvSCList.mOnGetItemByIndex = nil;
    end
end

return ArenaUIRecode;