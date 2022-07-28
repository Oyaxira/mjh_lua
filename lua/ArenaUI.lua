ArenaUI = class('ArenaUI', BaseWindow);

local ArenaUIShow = require 'UI/ArenaUI/ArenaUIShow';
local ArenaUISignUp = require 'UI/ArenaUI/ArenaUISignUp';
local ArenaUIRank = require 'UI/ArenaUI/ArenaUIRank';
local ArenaUIRecode = require 'UI/ArenaUI/ArenaUIRecode';

local rankMemberCount = 32;

function ArenaUI:ctor()
    self.bindBtnTable = {};
    self.TABTable = {};
    self.togTable = {};
end

function ArenaUI:Create()
	local obj = LoadPrefabAndInit('ArenaUI/ArenaUI', UI_UILayer, true);
    if obj then
        self:SetGameObject(obj);
    end
end

function ArenaUI:Init()

    self.RankDataManager = RankDataManager:GetInstance();
    self.ArenaDataManager = ArenaDataManager:GetInstance();

    --
    self.objWindowTabUI = self:FindChild(self._gameObject, 'WindowTabUI');
    self.objShow = self:FindChild(self._gameObject, 'Show');
    self.objSignUp = self:FindChild(self._gameObject, 'SignUp');
    self.objRank = self:FindChild(self._gameObject, 'Rank');
    self.objRecode = self:FindChild(self._gameObject, 'Recode');

    self.objArenaUIMatch = self:FindChild(self._gameObject, 'ArenaUIMatch');
    self.objArenaUIBet = self:FindChild(self._gameObject, 'ArenaUIBet');
    self.objArenaUIMatchRecode = self:FindChild(self._gameObject, 'ArenaUIMatchRecode');
    self.objArenaUIFinalJoinNames = self:FindChild(self._gameObject, 'ArenaUIFinalJoinNames');
    self.objArenaUIHuaShanFinalJoinNames = self:FindChild(self._gameObject, 'ArenaUIHuaShanFinalJoinNames');

    --
    self.objBackBtn = self:FindChild(self._gameObject, 'TransformAdapt_node_left/Button_back');
    self.objTabTog1 = self:FindChild(self.objWindowTabUI, 'TransformAdapt_node_right/Tab_box/Tab_toggle1');
    self.objTabTog2 = self:FindChild(self.objWindowTabUI, 'TransformAdapt_node_right/Tab_box/Tab_toggle2');
    self.objTabTog3 = self:FindChild(self.objWindowTabUI, 'TransformAdapt_node_right/Tab_box/Tab_toggle3');
    self.objTabTog4 = self:FindChild(self.objWindowTabUI, 'TransformAdapt_node_right/Tab_box/Tab_toggle4');
    self.objTabTog5 = self:FindChild(self.objWindowTabUI, 'TransformAdapt_node_right/Tab_box/Tab_toggle5');

    -- 打开擂台赛程网页
    self.btnBattleCalendar = self:FindChildComponent(self.objSignUp, "Button_calendar",  "Button")
    self:AddButtonClickListener(self.btnBattleCalendar, function()
        DRCSRef.MSDKWebView.OpenUrl("https://xk.qq.com/web202008/detail.shtml?newsid=13402549")
    end)
    
    --
    table.insert(self.TABTable, self.objShow);
    table.insert(self.TABTable, self.objSignUp);
    table.insert(self.TABTable, self.objRank);
    table.insert(self.TABTable, self.objRecode);

    --
    table.insert(self.bindBtnTable, self.objBackBtn);
    table.insert(self.bindBtnTable, self.objTabTog1);
    table.insert(self.bindBtnTable, self.objTabTog2);
    table.insert(self.bindBtnTable, self.objTabTog3);
    table.insert(self.bindBtnTable, self.objTabTog4);
    table.insert(self.bindBtnTable, self.objTabTog5);

    --
    table.insert(self.togTable, self.objTabTog1);
    table.insert(self.togTable, self.objTabTog2);
    table.insert(self.togTable, self.objTabTog3);
    table.insert(self.togTable, self.objTabTog4);
    table.insert(self.togTable, self.objTabTog5);

    --
    self.objShow:SetActive(true);
    self.objSignUp:SetActive(false);
    self.objRank:SetActive(false);
    self.objRecode:SetActive(false);

    --
    self.ArenaUIShow = ArenaUIShow.new(self);
    self.ArenaUISignUp = ArenaUISignUp.new(self);
    self.ArenaUIRank = ArenaUIRank.new(self);
    self.ArenaUIRecode = ArenaUIRecode.new(self);

    --
    self:BindBtnCB();

    -- 事件
    -- 如果在擂台界面打开了私聊(点击华山论剑冠军), 那么退出擂台界面
    self:AddEventListener("PRIVATE_CHAT_PLAYER", function(uiPlayerID)
        RemoveWindowImmediately("ArenaUI")
    end)
    -- 如果在擂台界面打开了切磋(点击华山论剑冠军), 那么退出擂台界面
    self:AddEventListener("CHALLENGE_PLAT_PLAYER", function(uiPlayerID)
        RemoveWindowImmediately("ArenaUI")
    end)
    -- 如果在擂台界面的时候跨天, 那么请求一次比赛胜利次数信息
    self:AddEventListener("ONEVENT_DIFF_DAY", function(uiTimeStamp)
        SendRequestArenaMatchOperate(ARENA_REQUEST_CHAMPION_TIMES_DATA)
    end)
end

function ArenaUI:BindBtnCB()
    for i = 1, #(self.bindBtnTable) do
        local _callback = function(gameObject, boolHide)
            self:OnclickBtn(gameObject, boolHide);
        end
        self:CommonBind(self.bindBtnTable[i], _callback);
    end
end

function ArenaUI:OnclickBtn(obj, boolHide)
    if obj == self.objBackBtn then
        self:OnClicBackBtn(obj);

    elseif obj == self.objTabTog1 then
        if boolHide then
            self:OnClickTabTog1(obj);
        end
        
    elseif obj == self.objTabTog2 then
        if boolHide then
            self:OnClickTabTog2(obj);
        end

    elseif obj == self.objTabTog3 then
        if boolHide then
            self:OnClickTabTog3(obj);
        end

    elseif obj == self.objTabTog4 then
        if boolHide then
            self:OnClickTabTog4(obj);
        end

    elseif obj == self.objTabTog5 then
        if boolHide then
            self:OnClickTabTog5(obj);
        end
    
    end

end

function ArenaUI:OnClicBackBtn(obj)
    RemoveWindowImmediately('ArenaUI', true);
end

function ArenaUI:OnClickTabTog1(obj)
    self:SetTabState(self.objShow);
end

function ArenaUI:OnClickTabTog2(obj)
    self:SetTabState(self.objSignUp);
end

function ArenaUI:OnClickTabTog3(obj)

end

function ArenaUI:OnClickTabTog4(obj)
    self:SetTabState(self.objRank);
end

function ArenaUI:OnClickTabTog5(obj)
    self:SetTabState(self.objRecode);
end

function ArenaUI:SetTabState(obj)

    --
    for i = 1, #(self.TABTable) do
        if obj == self.TABTable[i] then            
            self.TABTable[i]:SetActive(true);
        else
            self.TABTable[i]:SetActive(false);
        end
    end

    local _func = function(str)
        self.bClickShow = str == 'show';
        self.bClickSignUp = str == 'signup';
        self.bClickRank = str == 'rank';
        self.bClickRecode = str == 'recode';
    end 

    if obj == self.objShow then
        if not self.bClickShow then
            _func('show');
            self.ArenaUIShow:RefreshUI();
        end
    elseif obj == self.objSignUp then
        if not self.bClickSignUp then
            _func('signup');
            self.ArenaUISignUp:RefreshUI();
        end
    elseif obj == self.objRank then
        if not self.bClickRank then
            _func('rank');
            self.ArenaUIRank:RefreshUI();
        end
    elseif obj == self.objRecode then
        if not self.bClickRecode then
            _func('recode');
            self.ArenaUIRecode:RefreshUI();
        end
    end
end

function ArenaUI:RefreshUI(data)
    local moveTogIndex = nil
    local showBet = false

    if data then
        moveTogIndex = data.index
        showBet = (data.showBet == true)
    end

    if not globalDataPool:getData('PlatTeamInfo') then
        SendQueryPlatTeamInfo(SPTQT_PLAT, 0);
    end

    if moveTogIndex and self.togTable[moveTogIndex] then
        self.togTable[moveTogIndex]:GetComponent('Toggle').isOn = true;

        if showBet then
            local week = tonumber(os.date('%w'));
            week = week == 0 and 7 or week;

            local matchData = self.ArenaDataManager:GetFormatData();
            local tempTable = {};
            for i = 1, #(matchData) do
                if matchData[i].dwMatchType <= ARENA_TYPE.DA_ZHONG then
                    table.insert(tempTable, matchData[i]);
                end
            end
            
            if week >= 1 and week <= 5 then
                for i = 1, #(tempTable) do
                    if tempTable[i] then
                        OpenWindowImmediately('ArenaUIMatch', tempTable[i]);
                        break;
                    end
                end
            end
        end
    else
        if self.objTabTog1 then
            self.objTabTog1:GetComponent('Toggle').isOn = true;
        end
    end

    --
    self.ArenaDataManager:ResetDownCount();

    local hotInfo = self.ArenaDataManager:GetArenaHotInfo()
    if hotInfo and hotInfo.showBet then
        self.ArenaDataManager:HideBetHotInfo()
    end
end

function ArenaUI:OnDisable()
    WINDOW_ORDER_INFO.RoleEmbattleUI.fullscreen = true;

    self.RankDataManager:ResetRankData();

    local navigationUI = GetUIWindow("NavigationUI");
    if navigationUI then
        navigationUI:RefreshArenaUIRedPoint();
    end
end

function ArenaUI:OnEnable()
    WINDOW_ORDER_INFO.RoleEmbattleUI.fullscreen = false;

    --
    self:RequestArenaRank();
    SendRequestArenaMatchOperate(ARENA_REQUEST_HUASHANTOPMEMBER);
    SendRequestArenaMatchOperate(ARENA_REQUEST_CHAMPION_TIMES_DATA);
end

function ArenaUI:RequestArenaRank()
    local tbRankData = self.RankDataManager:GetTBRankData();
    local rankTypeTable = {};
    for k, v in pairs(tbRankData) do
        if tbRankData[k] and tbRankData[k].Show == TBoolean.BOOL_YES and tbRankData[k].BaseID > 100 then
            table.insert(rankTypeTable, tbRankData[k]);
        end
    end

    for i = 1, #(rankTypeTable) do
        NetCommonRank:QueryRank(tostring(rankTypeTable[i].BaseID), 1, rankMemberCount);
    end
end

function ArenaUI:OnDestroy()
    self.ArenaUIShow:Close();
    self.ArenaUISignUp:Close();
    self.ArenaUIRank:Close();
    self.ArenaUIRecode:Close();
end

return ArenaUI;