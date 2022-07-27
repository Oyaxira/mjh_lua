ArenaDataManager = class('ArenaDataManager');
ArenaDataManager._instance = nil;

local Round = {32, 16, 8, 4, 2, 1}
local Round2 = {16, 8, 4, 2, 1}
local Round3 = {8, 4, 2, 1}

function ArenaDataManager:GetInstance()
    if ArenaDataManager._instance == nil then
        ArenaDataManager._instance = ArenaDataManager.new();
        ArenaDataManager._instance:Init();
    end

    return ArenaDataManager._instance;
end

function ArenaDataManager:Init()
    self.matchData = {};
    self.finalJoinNamesData = {};
    self.battleData = {};
    self.rankData = {};
    self.historyData = {};
    self.arenaScenePlayerData = {};
    self.complateMatchData = {};
    self.formatMatchData = {};
    self.jokeBattleData = {};
    self.championData = {};
    self.huaShanNames = {};
    self.curBattleData = {};
    self.championData.dwNewHandChampionTimes = 0;
    self.championData.dwPublicChampionTimes = 0;
    self.pushFlag = 0;
    self.betFlag = 0;
    self.downCount = 0;
end

function ArenaDataManager:GetTBDataCount()
    return getTableSize2(self:GetTBMatchData());
end

function ArenaDataManager:SetMatchData(data)
    local luaTable = table_c2lua(data.akMatchData);
    if #(luaTable) == 1 then
        local tp = luaTable[1];
        if not self.matchData[tp.dwMatchType] then
            self.matchData[tp.dwMatchType] = {};
        end

        --
        if tp.dwMatchType == ARENA_TYPE.DA_SHI then
            if tp.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_CALC_BATTLE_RESULT then
                if self.matchData[tp.dwMatchType][tp.dwMatchID] and
                not self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest then
                    self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest = true;
                    -- SendRequestArenaMatchOperate(ARENA_REQUEST_MATCH, tp.dwMatchType, tp.dwMatchID);
                    return;
                end
            end
        end

        --
        local bRequest = false;
        if self.matchData[tp.dwMatchType][tp.dwMatchID] then
            bRequest = self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest;
        end

        --
        if tp.uiSignUpPlace > 0 then
            self.matchData[tp.dwMatchType][tp.dwMatchID] = tp;
        else
            -- 准备插入异常未报名的新比赛, 如果在插入之前, 缓存里面已经有了[相同类型的][未报名的]比赛
            -- 说明这是有一个多开赛, 那么为了保持缓存中总是只有一场最新的可报名比赛, 在插入数据前, 对旧数据做一个移除

            -- 以下是原来的插入新数据的逻辑
            local temp = clone(tp);
            if not self.matchData[tp.dwMatchType][tp.dwMatchID] then
                self.matchData[tp.dwMatchType][tp.dwMatchID] = tp;
            end
            temp.uiSignUpPlace = self.matchData[tp.dwMatchType][tp.dwMatchID].uiSignUpPlace;
            self.matchData[tp.dwMatchType][tp.dwMatchID] = temp;
        end

        --
        self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest = bRequest;
    else
        for i = 1, #(luaTable) do
            local tp = luaTable[i];
            if not self.matchData[tp.dwMatchType] then
                self.matchData[tp.dwMatchType] = {};
            end
            
            --
            if tp.dwMatchType == ARENA_TYPE.DA_SHI then
                if tp.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_CALC_BATTLE_RESULT then
                    if self.matchData[tp.dwMatchType][tp.dwMatchID] and
                    not self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest then
                        self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest = true;
                        -- SendRequestArenaMatchOperate(ARENA_REQUEST_MATCH, tp.dwMatchType, tp.dwMatchID);
                        return;
                    end
                end
            end

            --
            local bRequest = false;
            if self.matchData[tp.dwMatchType][tp.dwMatchID] then
                bRequest = self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest;
            end

            --
            if tp.uiSignUpPlace > 0 then
                self.matchData[tp.dwMatchType][tp.dwMatchID] = tp;
            else
                local temp = clone(tp);
                if not self.matchData[tp.dwMatchType][tp.dwMatchID] then
                    self.matchData[tp.dwMatchType][tp.dwMatchID] = tp;
                end
                temp.uiSignUpPlace = self.matchData[tp.dwMatchType][tp.dwMatchID].uiSignUpPlace;
                self.matchData[tp.dwMatchType][tp.dwMatchID] = temp;
            end

            --
            self.matchData[tp.dwMatchType][tp.dwMatchID].bRequest = bRequest;
        end        
    end

    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_QUREYDATA', luaTable[1]);
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_MATCHDATA', luaTable[1]);
    if luaTable[1].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
        LuaEventDispatcher:dispatchEvent('ONEVENT_REF_BATTLEDATA_FINISH', luaTable[1]);
    elseif luaTable[1].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
        LuaEventDispatcher:dispatchEvent('ONEVENT_QUARY_RANKDATA', luaTable[1]);
    end

    LuaEventDispatcher:dispatchEvent('UPDATE_HOUSE_HOT_NAVIGATION')

    self.downCount = self.downCount + 1;
    if self.downCount == self:GetTBDataCount() then
        self.downCount = 0;
        self:MenPaiSingn();
    end
end

function ArenaDataManager:ResetDownCount()
    self.downCount = 0;
end

function ArenaDataManager:MenPaiSingn()
    local requestArenaMatchOperateCmdList = {}
    -- 请求一次少年赛获胜记录
    table.insert(requestArenaMatchOperateCmdList, {
        eRequestType = ARENA_REQUEST_CHAMPION_TIMES_DATA
    })

    -- 信用分不足的情况下, 不自动报名擂台赛
    if not PlayerSetDataManager:GetInstance():GetTXCreditSceneLimit(TCSSLS_ARENA_SIGNUP) then 
        return
    end

    local menpai = {};
    -- for k, v in pairs(self:GetFormatData()) do
    --     if math.floor(v.dwMatchType / 1000) == ARENA_ENUM.MEN_PAI then
    --         table.insert(menpai, v);
    --     end
    -- end
    for k, v in pairs(self:GetFormatData()) do
        if math.floor(v.dwMatchType / 1000) == ARENA_ENUM.MEN_PAI or v.dwMatchType == ARENA_TYPE.HUA_SHAN then
            table.insert(menpai, v);
        end
    end

    for i = 1, #(menpai) do
        if menpai[i].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP and menpai[i].uiSignUpPlace == 0 then
            table.insert(requestArenaMatchOperateCmdList, {
                eRequestType = ARENA_REQUEST_SIGNUP,
                uiMatchType = menpai[i].dwMatchType
            })
        end
    end
    SendRequestArenaMatchOperateList(requestArenaMatchOperateCmdList)
end

function ArenaDataManager:MenPaiUpdateData()
    local menpai = {};
    local kHuaShan = {}
    local normal = {};
    for k, v in pairs(self:GetFormatData()) do
        if math.floor(v.dwMatchType / 1000) == ARENA_ENUM.MEN_PAI then
            table.insert(menpai, v);
        end
        if v.dwMatchType == ARENA_TYPE.SHAO_NIAN or
        v.dwMatchType == ARENA_TYPE.DA_ZHONG or
        v.dwMatchType == ARENA_TYPE.DA_SHI then
            table.insert(normal, v);
        elseif v.dwMatchType == ARENA_TYPE.HUA_SHAN then
            kHuaShan[#kHuaShan + 1] = v
        end
    end

    for i = 1, #(menpai) do
        if menpai[i].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP then
            if menpai[i].uiSignUpPlace == 0 then
                SendRequestArenaMatchOperate(ARENA_REQUEST_SIGNUP, menpai[i].dwMatchType);
            else
                SendRequestArenaMatchOperate(ARENA_REQUEST_UPDATE_PK_DATA, menpai[i].dwMatchType, menpai[i].dwMatchID, 0, 0, 0, 7);
            end
        end
    end

    for i = 1, #(normal) do
        if normal[i].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP then
            if normal[i].uiSignUpPlace > 0 then
                SendRequestArenaMatchOperate(ARENA_REQUEST_UPDATE_PK_DATA, normal[i].dwMatchType, normal[i].dwMatchID, 0, 0, 0, 7);
            end
        end 
    end
    
    -- for i = 1, #(kHuaShan) do
    --     if (kHuaShan[i].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP) 
    --     and (kHuaShan[i].uiSignUpPlace > 0) then
    --         SendRequestArenaMatchOperate(ARENA_REQUEST_UPDATE_PK_DATA, kHuaShan[i].dwMatchType, kHuaShan[i].dwMatchID, 0, 0, 0, 7);
    --     end
    -- end
    for i = 1, #(kHuaShan) do
        if (kHuaShan[i].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP) then
            if kHuaShan[i].uiSignUpPlace == 0 then
                SendRequestArenaMatchOperate(ARENA_REQUEST_SIGNUP, kHuaShan[i].dwMatchType);
            else
                SendRequestArenaMatchOperate(ARENA_REQUEST_UPDATE_PK_DATA, kHuaShan[i].dwMatchType, kHuaShan[i].dwMatchID, 0, 0, 0, 7);
            end
        end
    end
end

function ArenaDataManager:SetFinalJoinNamesData(data)
    local luaTable = table_c2lua(data.akSignUpName);
    if not self.finalJoinNamesData[data.dwMatchType] then
        self.finalJoinNamesData[data.dwMatchType] = {};
    end
    self.finalJoinNamesData[data.dwMatchType][data.dwMatchID] = luaTable;

    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_FINALJOINNAME', luaTable);
end

function ArenaDataManager:SetBattleData(data)
    local luaTable = table_c2lua(data.akBattleData);
    if not self.battleData[data.dwMatchType] then
        self.battleData[data.dwMatchType] = {};
    end
    if not self.battleData[data.dwMatchType][data.dwMatchID] then
        self.battleData[data.dwMatchType][data.dwMatchID] = {};
    end
   
    for i = 1, #(luaTable) do
        local tp = luaTable[i];
        if not self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID] then
            self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID] = {};
        end

        if #(self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID]) == 0 then
            table.insert(self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID], tp);
        else
            local bHas = false;
            for k, v in pairs(self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID]) do
                if v.dwBattleID == tp.dwBattleID and v.dwRoundID == tp.dwRoundID then

                    if tp.defBetPlyID > 0 then
                        self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID][k] = tp;
                    else
                        local temp = clone(tp);
                        temp.defBetPlyID = self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID][k].defBetPlyID;
                        self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID][k] = temp;
                    end

                    bHas = true;
                    break;
                end
            end

            if not bHas then
                table.insert(self.battleData[data.dwMatchType][data.dwMatchID][tp.dwRoundID], tp);
            end
        end
    end

    data.akBattleData = luaTable;
    self:SetPushFlag(data.dwPushFlag);
    self:SetCurBattleData(data);
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_BATTLEDATA', luaTable);
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_BETDATA', luaTable);
end

function ArenaDataManager:SetPushFlag(flag)
    self.pushFlag = flag;
end

function ArenaDataManager:SetCurBattleData(data)
    self.curBattleData = data;
end

function ArenaDataManager:GetPushFlag()
    return self.pushFlag;
end

function ArenaDataManager:GetCurBattleData()
    return self.curBattleData;
end

function ArenaDataManager:SetRankData(data)
    local luaTable = table_c2lua(data.akRankData);
    if not self.rankData[data.dwMatchType] then
        self.rankData[data.dwMatchType] = {};
    end

    self.rankData[data.dwMatchType][data.dwMatchID] = luaTable;

    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_RANKDATA');
end

function ArenaDataManager:SetHistoryData(data)
    local luaTable = table_c2lua(data.akMatchHistoryData);
    data.akMatchHistoryData = luaTable;
    if next(luaTable) then
        for i = 1, #(luaTable) do
            luaTable[i].akMemberHistoryData = table_c2lua(luaTable[i].akMemberHistoryData);
        end
        local _sort = function(a, b)
            return a.dwMatchTime > b.dwMatchTime;
        end
        table.sort(luaTable, _sort);
        local tempD = luaTable[1];
        self.historyData[tempD.dwMatchType] = luaTable;
    end
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_HISTORYDATA', data);
end

function ArenaDataManager:GetMatchData()
    return self.matchData;
end

function ArenaDataManager:GetBattleDataBy(matchType, matchID)
    if self.battleData[matchType] then
        return self.battleData[matchType][matchID]
    end
    return {};
end

function ArenaDataManager:GetFormatData()

    local tempT = {}
    for k, v in pairs(self.matchData) do
        table.insert(tempT, k);
    end
    table.sort(tempT, function(a, b)
        return a > b;
    end)

    local formatData = {};
    for k, v in pairs(tempT) do

        local index = 0;

        local _func = function()
            for kk, vv in pairs(self.matchData[v]) do
                if kk > index then
                    index = kk;
                end
            end

            if v == ARENA_TYPE.SHAO_NIAN then
                local tbMatchData = self:GetTBMatchData()[self.matchData[v][index].dwMatchType];
                if tbMatchData and tbMatchData.ShowCond > 0 then
                    if self.championData.dwNewHandChampionTimes and self.championData.dwNewHandChampionTimes < tbMatchData.ShowCond then
                        table.insert(formatData, self.matchData[v][index]);          
                    end
                else
                    table.insert(formatData, self.matchData[v][index]);
                end
            else
                table.insert(formatData, self.matchData[v][index]);
            end
        end

        local kTBMatchDBData = self:GetTBMatchData()
        local kBaseMatchTypeData = kTBMatchDBData[v]
        local bIsShaoNianMatch = (v == ARENA_TYPE.SHAO_NIAN)
        if (getTableSize2(self.matchData[v]) > 1) and kBaseMatchTypeData then
            --[[
                如果一个类型的次赛数据存在多场, 那么遵循以下规则遍历查找自己应该显示的数据:
                1.如果比赛是已经结束的, 那么直接插入formatData, 在后面的步骤中会分类到 "比赛记录" 页签中
                2.否则, 如果比赛还在进行中, 那么遍历过程中: 记录第一场自己已报名的比赛 A, 最后一场未报名的比赛 B
                3.遍历结束后, 如果A存在, formatData中插入A, 否则插入B
            ]]
            -- 插入为数组
            local akSortedMathes = {}
            for uiMatchID, kMatch in pairs(self.matchData[v]) do
                akSortedMathes[#akSortedMathes + 1] = kMatch
            end
            -- 按比赛id升序排序, 因为新增开的比赛, matchID总是递增的
            table.sort(akSortedMathes, function(a, b)
                return (a.dwMatchID or 0) < (b.dwMatchID or 0)
            end)
            -- 查找并插入比赛数据
            local bHasMatchData = false
            local bIsAddOpenType = (kBaseMatchTypeData.AddOpen > 0)
            local kMySignUpMatch = nil  -- 我报名的比赛
            local kFinalUnSignUpMatch = nil  -- 最后一个未报名的比赛
            local kFinalFinishMatch = nil
            for uiIndex, kMatch in ipairs(akSortedMathes) do
                if bIsAddOpenType == false then
                    bHasMatchData = true
                    table.insert(formatData, kMatch)
                else
                    -- 判断是否满足插入数据的条件
                    local bCanInsert = (not bIsShaoNianMatch)
                        or (kBaseMatchTypeData.ShowCond == 0)
                        or (self.championData.dwNewHandChampionTimes and (self.championData.dwNewHandChampionTimes < kBaseMatchTypeData.ShowCond))
                    -- 如果可插入, 判断下面的逻辑
                    if bCanInsert then
                        local bIsRunningMatch = (kMatch.uiStage > ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_NONE) 
                            and (kMatch.uiStage < ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH)
                        
                        if bIsRunningMatch then
                            -- 记录我报名的比赛
                            if (not kMySignUpMatch)
                            and (kMatch.uiSignUpPlace > 0) then
                                kMySignUpMatch = kMatch
                            end
                            -- 记录最后一个可报名比赛
                            if (kMatch.uiSignUpPlace == 0) then
                                kFinalUnSignUpMatch = kMatch
                            end
                        else
                            table.insert(formatData, kMatch)
                            bHasMatchData = true
                            kFinalFinishMatch = kMatch
                        end
                    end
                end
            end

            local kToInsertMatch = (kMySignUpMatch ~= nil) and kMySignUpMatch or kFinalUnSignUpMatch
            if kToInsertMatch 
            and ((not kFinalFinishMatch) or (kToInsertMatch.dwMatchID > kFinalFinishMatch.dwMatchID)) then
                table.insert(formatData, kToInsertMatch)
                bHasMatchData = true
            end

            if not bHasMatchData then
                _func();
            end
        else
            _func();
        end 
    end
    
    self.formatMatchData = {}
    self.complateMatchData = {}
    for i = 1, #(formatData) do
        if self:CanOpen(formatData[i].dwMatchType) then
            if formatData[i].uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then
                table.insert(self.complateMatchData, formatData[i]);
            end

            if formatData[i].dwMatchType == ARENA_TYPE.HUA_SHAN then
                table.insert(self.formatMatchData, formatData[i]);
            else
                if formatData[i].uiStage > ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_NONE and
                formatData[i].uiStage < ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH then

                    local bJoin = false;
                    local tbData = self:GetTBMatchData()[formatData[i].dwMatchType];
                    if tbData then
                        local rankData = RankDataManager:GetInstance():GetRankCacheData(tbData.ClanRankID);
                        if rankData and rankData.members then
                            for i = 1, #(rankData.members) do
                                if rankData.members[i].member == globalDataPool:getData('PlayerID') then
                                    bJoin = true;
                                    break;
                                end
                            end
                        end
                    end

                    if bJoin then
                        formatData[i].uiSignUpPlace = 100;
                    end
                    table.insert(self.formatMatchData, formatData[i]);
                end
            end
        end
    end
    
    return self.formatMatchData, self.complateMatchData;
end

function ArenaDataManager:CanOpen(typeID)
    local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
    local tbSysOpenData = TableDataManager:GetInstance():GetSystemOpenByType(SystemType.SYST_ARENA);
    local tempTable = {};
    for i = 1, #(tbSysOpenData) do
        if tbSysOpenData[i].OpenTime <= time then
            table.insert(tempTable, tbSysOpenData[i]);
        end
    end

    for i = 1, #(tempTable) do
        if tempTable[i].Param1 == math.floor(typeID / 1000) then
            return true;
        end
    end

    return false;
end

function ArenaDataManager:GetMatchDataBy(matchType, matchID)
    if self.matchData[matchType] then
        return self.matchData[matchType][matchID];
    end
    return {};
end

function ArenaDataManager:GetCurMatchData(matchType)
    if self.matchData[matchType] then
        local index = 0;
        for k, v in pairs(self.matchData[matchType]) do
            if k > index then
                index = k;
            end
        end
        return self.matchData[matchType][index];
    end
    return nil;
end

function ArenaDataManager:GetRankData(matchType, matchID)
    if self.rankData[matchType] then
        return self.rankData[matchType][matchID]
    end
    return {};
end

function ArenaDataManager:GetTBMatchData()
    return TableDataManager:GetInstance():GetTable("ArenaType")
end

function ArenaDataManager:GetTBLimitData()
    return TableDataManager:GetInstance():GetTable("ArenaLimit")
end

function ArenaDataManager:ResetMatchData()
    self.matchData = {};
end

function ArenaDataManager:GetHistoryData(matchType)
    return self.historyData[matchType];
end

function ArenaDataManager:GetSelfBattleData(matchType, matchID)
    local playerID = PlayerSetDataManager:GetInstance():GetPlayerID();
    local matchData = self.battleData[matchType];
    local battleData = matchData and matchData[matchID];
    
    local round = 0;
    for i = 1, #(Round) do
        if battleData and battleData[Round[i]] then
            for j = 1, #(battleData[Round[i]]) do
                local data = battleData[Round[i]][j];
                if playerID == data.kPly1Data.defPlayerID then
                    round = Round[i];
                end
    
                if playerID == data.kPly2Data.defPlayerID then
                    round = Round[i];
                end
            end
        end
    end

    return round ~= 0 and true or false, round;
end

function ArenaDataManager:GetobjAverageSliver(matchType, matchID)
    local rankData = self:GetRankData(matchType, matchID);
    
    local maxValue = 0;
    for i = 1, #(rankData) do
        if rankData[i].dwValue > maxValue then
            maxValue = rankData[i].dwValue;
        end
    end

    local tTable = {};
    for i = 1, #(rankData) do
        if rankData[i].dwValue == maxValue then
            tTable[rankData[i].defPlayerID] = rankData[i];
        end
    end

    local tbData = self:GetTBMatchData()[matchType];
    local count = getTableSize2(tTable);
    return count > 0 and tbData.RankRewardPool / count or tbData.RankRewardPool, tTable;
end

function ArenaDataManager:SetArenaScenePlayerData(data)
    local dwPlatAreaID = data.dwPageID
	local kPlatPlayerSimpleInfos = data.kPlatPlayerSimpleInfos;
    self.arenaScenePlayerData[dwPlatAreaID] = kPlatPlayerSimpleInfos;
end

function ArenaDataManager:GetArenaScenePlayerData()
    local tempT = {};
    for k, v in pairs(self.arenaScenePlayerData) do
        local luaT = table_c2lua(v);
        table.move(luaT, 1, #(luaT), #(tempT) + 1, tempT);
    end
    return tempT;
end

function ArenaDataManager:SetHuaShanNames(data)
    local luaT = table_c2lua(data.akMemberes);

    local bJoin = false;
    for i = 1, #(luaT) do
        if luaT[i].defPlayerID == globalDataPool:getData('PlayerID') then
            bJoin = true;
        end
    end

    for k, v in pairs(self:GetFormatData()) do
        if v.dwMatchType == ARENA_TYPE.HUA_SHAN and bJoin then
            v.uiSignUpPlace = 100;
            break;
        end
    end

    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_HUASHAN_NAME', luaT);
end

-- TODO 客户端装配数据不奇怪？
function ArenaDataManager:ResetJokeData()
    
    local tempT = {};
    tempT.dwBattleID = 0;
    tempT.dwRoundID = 0;
    tempT.dwPly1BetRate = 0;
    tempT.dwPly2BetRate = 0;
    tempT.defPlyWinner = 0;
    tempT.defBetPlyID = 0;
    tempT.dwBetMoney = 0;
    tempT.isJoke = 1;
    tempT.kPly1Data = {};
    tempT.kPly1Data.defPlayerID = 0;
    tempT.kPly1Data.dwModelID = 0;
    tempT.kPly1Data.dwOnlineTime = 0;
    tempT.kPly1Data.dwMerdianLevel = 0;
    tempT.kPly1Data.acPlayerName = 0;
    tempT.kPly2Data = {};
    tempT.kPly2Data.defPlayerID = 0;
    tempT.kPly2Data.dwModelID = 0;
    tempT.kPly2Data.dwOnlineTime = 0;
    tempT.kPly2Data.dwMerdianLevel = 0;
    tempT.kPly2Data.acPlayerName = 0;
    
    self.jokeBattleData = {};
    for i = 1, 5 do
        local data = clone(tempT);
        table.insert(self.jokeBattleData, data);
    end
end

function ArenaDataManager:SetJokeData(data)
    local luaTable = table_c2lua(data.akJokeBattleData);
    self:ResetJokeData();
    local selfID = PlayerSetDataManager:GetInstance():GetPlayerID();
    local selfName = PlayerSetDataManager:GetInstance():GetPlayerName();
    local selfModel = PlayerSetDataManager:GetInstance():GetModelID();
    for i = 1, #(luaTable) do
        if luaTable[i].dwResult == 1 then
            self.jokeBattleData[i].kPly1Data.defPlayerID = selfID;
            self.jokeBattleData[i].kPly1Data.acPlayerName = selfName;
            self.jokeBattleData[i].kPly1Data.dwModelID = selfModel;
            self.jokeBattleData[i].kPly2Data.defPlayerID = 0;
            self.jokeBattleData[i].kPly2Data.acPlayerName = luaTable[i].acPlayerName;
            self.jokeBattleData[i].kPly2Data.dwModelID = luaTable[i].dwModelID;
            self.jokeBattleData[i].defPlyWinner = selfID;
        else
            self.jokeBattleData[i].kPly1Data.defPlayerID = 0;
            self.jokeBattleData[i].kPly1Data.acPlayerName = luaTable[i].acPlayerName;
            self.jokeBattleData[i].kPly1Data.dwModelID = luaTable[i].dwModelID;
            self.jokeBattleData[i].kPly2Data.defPlayerID = selfID;
            self.jokeBattleData[i].kPly2Data.acPlayerName = selfName;
            self.jokeBattleData[i].kPly2Data.dwModelID = selfModel;
            self.jokeBattleData[i].defPlyWinner = 0;
        end
    end
end

function ArenaDataManager:GetJokeData()
    return self.jokeBattleData;
end

function ArenaDataManager:SetChampionData(data)
    self.championData = data;
end

function ArenaDataManager:GetChampionData()
    return self.championData;
end

function ArenaDataManager:SetBetFlag(flag)
    self.betFlag = flag;
end

function ArenaDataManager:GetBetFlag()
    return self.betFlag;
end

function ArenaDataManager:ChallengePlatRoleRePlay(playerID, modelID, playerName)
    if self._replayState ~= nil then 
        SystemUICall:GetInstance():Toast(self._replayState)
        return
    end
    local playerSetDataMgr = PlayerSetDataManager:GetInstance()
	ARENA_PLAYBACK_DATA = {
        dwBattleID = 0,
        dwRoundID = 0,
        dwPly1BetRate = 0,
        dwPly2BetRate = 0,
        defPlyWinner = 0,
        defBetPlyID = 0,
        dwBetMoney = 0,
        kPly1Data = {
            defPlayerID = playerSetDataMgr:GetPlayerID(),
            dwModelID = playerSetDataMgr:GetModelID(),
            acPlayerName = playerSetDataMgr:GetPlayerName(),
        },
        kPly2Data = {
            defPlayerID = playerID,
            dwModelID = modelID,
            acPlayerName = playerName,
        }
    }
    OpenWindowImmediately("LoadingUI")
	SendChallengePlatRole(playerID)
	RemoveWindowImmediately("PlayerMsgMiniUI")
	self:AddLoadingUI(true)
    -- 事件: 切磋玩家
	LuaEventDispatcher:dispatchEvent("CHALLENGE_PLAT_PLAYER", playerID)
end

function ArenaDataManager:AddLoadingUI(bShowToast)
    globalTimer:AddTimer(10000, function()
        local loadingUI = GetUIWindow("LoadingUI")
        if loadingUI and loadingUI:IsOpen() then 
            RemoveWindowImmediately("LoadingUI");
            if bShowToast then
                SystemUICall:GetInstance():Toast('该玩家已下线')
            end
        end
        self._replayState = nil
    end, 1);
end

function ArenaDataManager:RePlay(dwMatchType,dwMatchID,data)
    if self._replayState ~= nil then 
        SystemUICall:GetInstance():Toast(self._replayState)
        return
    end
    ARENA_PLAYBACK_DATA = data;
    ARENA_PLAYBACK_DATA.dwMatchType = dwMatchType
    ARENA_PLAYBACK_DATA.dwMatchID = dwMatchID
    if self:IsHaveReplayData(data.dwBattleID) then 
        -- 直接进入回放
        self:PlayReplayer(data.dwBattleID)
        LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.PreSelect, true)
    else
        self._replayState = "准备接收回放数据"
        OpenWindowImmediately("LoadingUI")
        SendRequestArenaMatchOperate(ARENA_REQUEST_VIEW_RECORD, dwMatchType,dwMatchID, data.dwRoundID, data.dwBattleID);
        self:AddLoadingUI()
    end
end

function ArenaDataManager:SetPlayBackData(data)
    ARENA_PLAYBACK_DATA = data;
end

function ArenaDataManager:ReplayZm(data, roomID)
    if self._replayState ~= nil then 
        SystemUICall:GetInstance():Toast(self._replayState)
        return
    end
    
    self:SetPlayBackData(data)

    if self:IsHaveReplayData(data.dwBattleID) then 
        -- 直接进入回放
        self:PlayReplayer(data.dwBattleID)
    else
        self._replayState = "准备接收回放数据"
        SendZmOperate(EN_ZM_REQUEST_ViewRecord, roomID, data.dwBattleID)
    end
end

function ArenaDataManager:IsHaveReplayData(battleID)
    if self.arenaRecordCache == nil or self.arenaRecordCache[battleID] == nil then 
        return false
    end
    return true
end

function ArenaDataManager:GetReplayData(battleID)
    if self.arenaRecordCache ~= nil then 
        return self.arenaRecordCache[battleID]
    end
end

function ArenaDataManager:ReplayerOver()
    self._replayState = nil
    ClearBattleMsg()
end

function ArenaDataManager:PlayReplayer(battleID)
    -- ClearBattleMsg()
    local info = self:GetReplayData(battleID)
    if info then 
        local iCount = info['iCount'] 
        local dwTotalSize = info['dwTotalSize'] 
        if iCount >= dwTotalSize then
            local tstr = info['tstr']
            start_t = os.clock()
            local kNetStream = GenerateNetStream()
            kNetStream:Attach(tstr,dwTotalSize)
            while kNetStream:GetCurPos() < dwTotalSize  do
                local iCmdType = kNetStream:ReadInt()
                local iDataSize = kNetStream:ReadInt()
                local kRetData = nil
                ReplayBattleCmd(iCmdType,kNetStream)
            end
            local arenaUI= GetUIWindow('ArenaUI')
            if arenaUI then
                arenaUI.DontDestroy = true
                arenaUI:SetAlpha(0)
            end
            ProcessBattleMsg()
            self._replayState = "正在回放中"
        end
    end
end

--[[
-- description: 接收回放数据
-- param {type} 
-- return: 
--]]
function ArenaDataManager:ReceiveReplayerData(ArenaBattleRecordData, onReceiveEnd, onReceiveAfter)
    local uiBattleID = ArenaBattleRecordData.uiBattleID
    local dwTotalSize = ArenaBattleRecordData.dwTotalSize
    local uiBatchIdx = ArenaBattleRecordData.uiBatchIdx
    local iBatchSize = ArenaBattleRecordData.iBatchSize
    local akData = ArenaBattleRecordData.akData
    self.arenaRecordCache = self.arenaRecordCache or {}

    if self.arenaRecordCache[uiBattleID] == nil then 
        self.arenaRecordCache[uiBattleID] = {
            ['dwTotalSize'] = dwTotalSize,
            ['iCount'] = 0,
            ['content'] = {},
        }
    end

    --battleID为0 的 是切磋 切磋的数据是分段下发的，发什么播什么。
    --擂台赛 是一次性下发，每次下发 都按照新的处理
    local tempCache = self.arenaRecordCache[uiBattleID]
    if uiBattleID == 0 and (tempCache['iCount'] >= tempCache['dwTotalSize']) then
        tempCache['content'] = {}
        tempCache['iCount'] = 0
        tempCache['dwTotalSize'] = dwTotalSize
        LogicMain:GetInstance():SetReplayNeedGiveUp(true)
    else
        LogicMain:GetInstance():SetReplayNeedGiveUp(false)
    end

    local tstr = tempCache['content']
    local count = tempCache['iCount']
    --DRCSRef.Log("-----replay start" .. os.clock())
    -- local start_t = os.clock()
    for k = 0,iBatchSize-1 do
        count = count + 1
        if akData[k] < 0 then
            tstr[count] = string.char(akData[k] + 256)
        else
            tstr[count] = string.char(akData[k])
        end
    end
    -- _areanDecodeTime = (_areanDecodeTime or 0) + os.clock() - start_t
    -- dprint("_areanByteTime",_areanDecodeTime,iBatchSize,dwTotalSize)
    tempCache['iCount'] = count
    self._replayState = "正在接收回放数据"
    if count >= dwTotalSize then
        tempCache['tstr'] = table.concat(tstr,"")

        if onReceiveEnd then
            onReceiveEnd()
        end
        self:PlayReplayer(uiBattleID)
        if onReceiveAfter then
            onReceiveAfter()
        end
    end
end

function ArenaDataManager:Clear()
    self._replayState = nil
    self.arenaRecordCache = nil
end

function ArenaDataManager:ClearReplay(battleID)
    if self.arenaRecordCache then 
        self.arenaRecordCache[0] = nil
    end
end

function ArenaDataManager:GetStoreTBData()
    return TableDataManager:GetInstance():GetTable('ArenaShop');
end

function ArenaDataManager:ArenaCanSignUp(data)

    if not data then
        return false;
    end

    local tbMatchData = self:GetTBMatchData()
    if not tbMatchData then
        return false;
    end

    local tempData = tbMatchData[data.dwMatchType]

    local bCon = false;
    local championData = self:GetChampionData()
    if data.dwMatchType == ARENA_TYPE.SHAO_NIAN then
        bCon = true;
    elseif data.dwMatchType == ARENA_TYPE.DA_ZHONG then
        if tempData.SignUpCondNewHandChampion == 0 then
            bCon = true;
        elseif tempData.SignUpCondNewHandChampion > 0 then
            if championData.dwNewHandChampionTimes >= tempData.SignUpCondNewHandChampion then
                bCon = true;
            end
        end
    elseif data.dwMatchType == ARENA_TYPE.DA_SHI then
        if tempData.SignUpCondPublicChampion == 0 then
            bCon = true;
        elseif tempData.SignUpCondPublicChampion > 0 then
            if championData.dwPublicChampionTimes >= tempData.SignUpCondPublicChampion then
                bCon = true;
            end
        end
    end

    return bCon
end

-- 用于在酒馆界面展示正在进行的擂台信息
function ArenaDataManager:GetArenaHotInfo()
    if not self.matchData then
        return nil
    end

    local showSignUp = false
    local showBet = false

    local formatData = self:GetFormatData();
    -- for matchType, matchs in pairs(self.matchData) do
        for matchID, matchData in pairs(formatData) do
            if matchData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_SIGNUP then
                if self:ArenaCanSignUp(matchData) and matchData.uiSignUpPlace == 0 then
                    showSignUp = true
                end
            elseif matchData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET then
                showBet = true
            end
        end
    -- end

    if self.hideBetHotInfo then
        showBet = false
    end

    return {showSignUp = showSignUp, showBet = showBet}
end
function ArenaDataManager:HideBetHotInfo()
    self.hideBetHotInfo = true

    LuaEventDispatcher:dispatchEvent("UPDATE_HOUSE_HOT_NAVIGATION")
end

function ArenaDataManager:HasRunningMatch()
    if not self.matchData then
        return false
    end

    for matchType, matchs in pairs(self.matchData) do
        for matchID, matchData in pairs(matchs) do
            if matchData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_START_MATCH or 
            matchData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET or
            matchData.uiStage == ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH then
                return true
            end
        end
    end

    return false
end

-- 用于记录在剧本中显示助威临时图标
function ArenaDataManager:SetStoryShowBetTipFlag(isShow)
    self.storyShowBetTip = isShow
end
function ArenaDataManager:GetStoryShowBetTipFlag()
    return self.storyShowBetTip == true
end

-- 记录助威界面显示时间戳
function ArenaDataManager:RecordPlayerCompareUIStamp()
    self.uiRecordPlayerCompareUIStamp = os.time()
end

-- 获取助威界面显示CD
function ArenaDataManager:GetPlayerCompareUICD()
    if not self.uiRecordPlayerCompareUIStamp then
        return 0
    end
    local iOffsetSec = os.time() - self.uiRecordPlayerCompareUIStamp
    return ARENA_OBSERVE_CD - (iOffsetSec * 1000)
end

-- 缓存当前擂台玩家观察数据
function ArenaDataManager:SetCachePlayerObserverData(kMatch, kObserverInfo)
    if not kMatch then
        return
    end
    local kTarInfo = kObserverInfo
    if not kTarInfo then
        kTarInfo = globalDataPool:getData('ObserveArenaInfo')
    end
    if (not kTarInfo) or (not kTarInfo.defPlayerID) or (kTarInfo.defPlayerID == 0) then
        return
    end
    if (not self.kBackupObserveInfos)
    or (self.kBackupObserveInfos.dwMatchType ~= kMatch.dwMatchType)
    or (self.kBackupObserveInfos.dwMatchID ~= kMatch.dwMatchID) then
        self.kBackupObserveInfos = {dwMatchType = kMatch.dwMatchType, dwMatchID = kMatch.dwMatchID}
    end
    local uiPlayerID = kTarInfo.defPlayerID
    self.kBackupObserveInfos[uiPlayerID] = clone(kTarInfo)
    return self.kBackupObserveInfos[uiPlayerID]
end

-- 获取当前擂台玩家观察数据缓存
function ArenaDataManager:GetChachePlayerObserverData(kMatch, uiPlayerID)
    if (not kMatch) or (not uiPlayerID) or (0 == uiPlayerID) then
        return
    end
    if (not self.kBackupObserveInfos)
    or (self.kBackupObserveInfos.dwMatchType ~= kMatch.dwMatchType)
    or (self.kBackupObserveInfos.dwMatchID ~= kMatch.dwMatchID) then
        self.kBackupObserveInfos = nil
        return
    end
    return self.kBackupObserveInfos[uiPlayerID]
end

-- 设置当前擂台玩家观察数据缓存到GlobalData
function ArenaDataManager:ResetChachePlayerObserverDataToGlobalData(kMatch, uiPlayerID)
    local kBackUpInfo = self:GetChachePlayerObserverData(kMatch, uiPlayerID)
    if not kBackUpInfo then
        return false, nil
    end
    globalDataPool:setData("ObserveArenaInfo", kBackUpInfo, true)
    return true, kBackUpInfo
end

return ArenaDataManager;
