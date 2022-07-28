ArenaScriptDataManager = class('ArenaScriptDataManager');
ArenaScriptDataManager._instance = nil;

function ArenaScriptDataManager:GetInstance()
    if ArenaScriptDataManager._instance == nil then
        ArenaScriptDataManager._instance = ArenaScriptDataManager.new();
        ArenaScriptDataManager._instance:Init();
    end

    return ArenaScriptDataManager._instance;
end

function ArenaScriptDataManager:Init()
    self.canPro = {};
    self.tempTBData = {};
    self.tempMatchData = {};
    self.tempBattleCount = {};
    self.matchTypeData = {};
    self.complateData = {};
    self.arenaIsOver = {};
    self.curRoundIndex = 1;
end

function ArenaScriptDataManager:FormatScriptArenaData(data)

    data.auiBaseID = table_c2lua(data.auiBaseID);
    data.auiRandBaseID = table_c2lua(data.auiRandBaseID);

    local battleData = {};
    battleData.dwBattleID = 0;
    battleData.dwRoundID = 0;
    battleData.dwPly1BetRate = 0;
    battleData.dwPly2BetRate = 0;
    battleData.defPlyWinner = 0;
    battleData.defBetPlyID = 0;
    battleData.dwBetMoney = 0;
    battleData.kPly1Data = {};
    battleData.kPly1Data.defPlayerID = 0;
    battleData.kPly1Data.dwModelID = 0;
    battleData.kPly1Data.dwOnlineTime = 0;
    battleData.kPly1Data.dwMerdianLevel = 0;
    battleData.kPly1Data.acPlayerName = 0;
    battleData.kPly2Data = {};
    battleData.kPly2Data.defPlayerID = 0;
    battleData.kPly2Data.dwModelID = 0;
    battleData.kPly2Data.dwOnlineTime = 0;
    battleData.kPly2Data.dwMerdianLevel = 0;
    battleData.kPly2Data.acPlayerName = 0;

    local playerSetDataManager = PlayerSetDataManager:GetInstance();
    local mainRoleName = RoleDataManager:GetInstance():GetMainRoleName();
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData();
    local TB_StoryRace = TableDataManager:GetInstance():GetTable("StoryRace");
    local TB_StoryRacePlayer = TableDataManager:GetInstance():GetTable("StoryRacePlayer");
    if TB_StoryRace and TB_StoryRacePlayer and TB_StoryRace[data.uiArenaType] then

        local tbData = TB_StoryRace[data.uiArenaType];
    
        local canPro = {};
        for i = 1, #(tbData.EMBattle) - 1 do
            canPro[tbData.EMBattle[i]] = { width = i };
        end
    
        -- 16 8 4 2 1
        local battleCount = {}; 
        for i = 1, #(tbData.EMBattle) do
            table.insert(battleCount, math.floor(2 ^ (#(tbData.EMBattle) - i)));
        end
        
        local matchData = {};
        local createData = function(roundID)
            local cloneData = clone(battleData);
            cloneData.dwRoundID = roundID;
            cloneData.kPly1Data.defPlayerID = '随机角色';
            cloneData.kPly1Data.dwModelID = '随机角色';
            cloneData.kPly1Data.acPlayerName = '随机角色';
            cloneData.kPly2Data.defPlayerID = '随机角色';
            cloneData.kPly2Data.dwModelID = '随机角色';
            cloneData.kPly2Data.acPlayerName = '随机角色';
    
            if not matchData[cloneData.dwRoundID] then
                matchData[cloneData.dwRoundID] = {};
            end
            table.insert(matchData[cloneData.dwRoundID], cloneData);
        end

        for i = 1, #(battleCount) do
            for j = 1, math.ceil(battleCount[i] / 2) do
                createData(battleCount[i]);
            end
        end
    
        -- local randomList = clone(tbData.RandomList);
        for i = 1, #(matchData[battleCount[1]]) do
            local rBaseID1 = data.auiBaseID[i * 2 - 1];
            local rBaseID2 = data.auiBaseID[i * 2 - 0];
            local tbPlayer1 = TB_StoryRacePlayer[rBaseID1];
            local tbPlayer2 = TB_StoryRacePlayer[rBaseID2];
            if tbPlayer1 and tbPlayer2 then
                matchData[battleCount[1]][i].kPly1Data.defPlayerID = tbPlayer1.BaseID;
                matchData[battleCount[1]][i].kPly1Data.dwModelID = tbPlayer1.ModelID;
                matchData[battleCount[1]][i].kPly1Data.acPlayerName = tbPlayer1.Name;
                matchData[battleCount[1]][i].kPly2Data.defPlayerID = tbPlayer2.BaseID;
                matchData[battleCount[1]][i].kPly2Data.dwModelID = tbPlayer2.ModelID;
                matchData[battleCount[1]][i].kPly2Data.acPlayerName = tbPlayer2.Name;
            end
        end

        -- 2^0 2^1 2^2 2^3 -> 1 2 4 8
        local randomIndex = {};
        -- for i = 1, #(tbData.EMBattle) do
        --     local tempT = {};
        --     if i < #(tbData.EMBattle) then
        --         tempT.index = math.random(1, 2 ^ (i - 1)) + math.floor(2 ^ (i - 1));
        --     else
        --         tempT.index = 1;
        --     end
        --     tempT.role = tbData.EMBattle[i];
        --     table.insert(randomIndex, tempT);
        -- end
        for i = 1, #(data.auiRandBaseID) do
            local tempT = {};
            tempT.index = data.auiRandBaseID[i];
            tempT.role = tbData.EMBattle[i];
            table.insert(randomIndex, tempT);
        end
        
        for i = 1, #(randomIndex) do
            local index = randomIndex[i].index;
            local battleIndex = math.ceil(index / 2);
            local plyData = index % 2 == 1 and 'kPly1Data' or 'kPly2Data';

            if i < #(randomIndex) then
                local tbRoleData = TB_StoryRacePlayer[randomIndex[i].role];
                if tbRoleData then
                    matchData[battleCount[1]][battleIndex][plyData].defPlayerID = tbRoleData.BaseID;
                    matchData[battleCount[1]][battleIndex][plyData].dwModelID = tbRoleData.ModelID;
                    matchData[battleCount[1]][battleIndex][plyData].acPlayerName = tbRoleData.Name;
                end
            else
                if mainRoleData then
                    matchData[battleCount[1]][battleIndex][plyData].defPlayerID = playerSetDataManager:GetPlayerID();
                    matchData[battleCount[1]][battleIndex][plyData].dwModelID = mainRoleData:GetModelID();
                    matchData[battleCount[1]][battleIndex][plyData].acPlayerName = mainRoleName;
                end
            end
        end
    
        local _GetMatchType = function(peoples)
            local tbMatchData = ArenaDataManager:GetInstance():GetTBMatchData();
            for k, v in pairs(tbMatchData) do
                if v.Peoples == peoples then
                    return v.BaseID;
                end
            end
        end

        self.canPro = canPro;
        self.tempTBData = tbData;
        self.tempMatchData = matchData;
        self.tempBattleCount = battleCount;
        self.matchTypeData = {};
        self.matchTypeData.dwMatchType = _GetMatchType(tbData.BattleRoleCount);
        self.matchTypeData.dwMatchID = 1;
        self.matchTypeData.dwBufferID = 0;
        self.matchTypeData.dwSignUpCount = 0;
        self.matchTypeData.uiStage = ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET;
        self.matchTypeData.dwRoundID = battleCount[1];
        self.matchTypeData.uiSignUpPlace = 0;
    end
end

function ArenaScriptDataManager:ScriptArenaMatchData(tagValue) 
    if self.tempMatchData and next(self.tempMatchData) then
        local complateData = {};
        local tempTBData = self:GetTempTBData();
        for i = 0, 9 do
            if HasFlag(tagValue, i) then
                self.curRoundIndex = i + 1;
                if HasFlag(tagValue, i + 10) then
                    table.insert(complateData, true);
    
                    if tempTBData.EMBattle and i == #(tempTBData.EMBattle) - 2 then
                        self.arenaIsOver[tempTBData.BaseID] = true;
                    end
                else
                    self.arenaIsOver[tempTBData.BaseID] = true;
                end
            end
        end
    
        for i = #(complateData), 9 do
            table.insert(complateData, false);
        end
    
        self.complateData = complateData;
        self.matchTypeData.dwRoundID = self.tempBattleCount[self.curRoundIndex];
    end  
end

function ArenaScriptDataManager:CaculateMatch()
    local playerSetDataManager = PlayerSetDataManager:GetInstance();
    local canPro = self.canPro;
    local matchData = self.tempMatchData;
    local battleCount = self.tempBattleCount;
    local roundIndex = self.curRoundIndex;
    local complateData = self.complateData;

    if matchData and next(matchData) then
        local tempCount = 0;
        if roundIndex < #(battleCount) - 1 then
            tempCount = roundIndex;
        else
            tempCount = #(battleCount) - 1 - 1;
        end
    
        for i = 2, 1 + tempCount do
            local curData = matchData[battleCount[i]];
            local lastData = matchData[battleCount[i - 1]];
            if lastData and curData then
                local count = #(curData);
                for j = 1, count do
    
                    local _func = function(index, i)
                        if lastData[index] then
    
                            local bWin1 = canPro[lastData[index].kPly1Data.defPlayerID];
                            local bWin2 = canPro[lastData[index].kPly2Data.defPlayerID];
                            local bWin = true;
                            if bWin1 and bWin2 then
                                bWin = bWin1.width > bWin2.width;
                            elseif bWin1 then
                                bWin = true;
                            elseif bWin2 then
                                bWin = false;
                            end
                            if lastData[index].kPly1Data.defPlayerID == playerSetDataManager:GetPlayerID() then
                                bWin = complateData[i - 1];
                            end
    
                            if bWin then
                                if index % 2 == 0 then
                                    curData[j].kPly2Data.defPlayerID = lastData[index].kPly1Data.defPlayerID;
                                    curData[j].kPly2Data.dwModelID = lastData[index].kPly1Data.dwModelID;
                                    curData[j].kPly2Data.acPlayerName = lastData[index].kPly1Data.acPlayerName;
                                else
                                    curData[j].kPly1Data.defPlayerID = lastData[index].kPly1Data.defPlayerID;
                                    curData[j].kPly1Data.dwModelID = lastData[index].kPly1Data.dwModelID;
                                    curData[j].kPly1Data.acPlayerName = lastData[index].kPly1Data.acPlayerName;
                                end
        
                                lastData[index].defPlyWinner = lastData[index].kPly1Data.defPlayerID;
                            else
                                if index % 2 == 0 then
                                    curData[j].kPly2Data.defPlayerID = lastData[index].kPly2Data.defPlayerID;
                                    curData[j].kPly2Data.dwModelID = lastData[index].kPly2Data.dwModelID;
                                    curData[j].kPly2Data.acPlayerName = lastData[index].kPly2Data.acPlayerName;
                                else
                                    curData[j].kPly1Data.defPlayerID = lastData[index].kPly2Data.defPlayerID;
                                    curData[j].kPly1Data.dwModelID = lastData[index].kPly2Data.dwModelID;
                                    curData[j].kPly1Data.acPlayerName = lastData[index].kPly2Data.acPlayerName;
                                end
        
                                lastData[index].defPlyWinner = lastData[index].kPly2Data.defPlayerID;
                            end
                        end
                    end
    
                    _func(j * 2 - 1, i);
                    _func(j * 2 - 0, i);
                end
            end
        end
    
        for index = 1, roundIndex do
            if battleCount[index] == 4 then
                local sortData = function(data)
                    local tempT = {};
                    for i = 1, #(data) do
                        table.insert(tempT, data[i].kPly1Data);
                        table.insert(tempT, data[i].kPly2Data);
                    end
                    return tempT;
                end
            
                local data4 = sortData(matchData[4]);
                local data2 = sortData(matchData[2]);
            
                for i = 1, #(data2) do
                    for j = 1, #(data4) do
                        if data2[i].acPlayerName == data4[j].acPlayerName then
                            table.remove(data4, j);
                            break;
                        end
                    end
                end
                matchData[1][1].kPly1Data = data4[1];
                matchData[1][1].kPly2Data = data4[2];
            end
            
            if battleCount[index] == 2 then
                local bWin1 = canPro[matchData[2][1].kPly1Data.defPlayerID];
                local bWin2 = canPro[matchData[2][1].kPly2Data.defPlayerID];
                local bWin = true;
                if bWin1 and bWin2 then
                    bWin = bWin1.width > bWin2.width;
                elseif bWin1 then
                    bWin = true;
                elseif bWin2 then
                    bWin = false;
                end

                if matchData[2][1].kPly1Data.defPlayerID == playerSetDataManager:GetPlayerID() then
                    bWin = complateData[index];
                end
        
                if bWin then
                    matchData[2][1].defPlyWinner = matchData[2][1].kPly1Data.defPlayerID;
                else
                    matchData[2][1].defPlyWinner = matchData[2][1].kPly2Data.defPlayerID;
                end
        
                -- TODO 如果玩家是第3名或者第4名，直接获胜
                if matchData[1][1].kPly1Data.defPlayerID == playerSetDataManager:GetPlayerID() then
                    matchData[1][1].defPlyWinner = matchData[1][1].kPly1Data.defPlayerID;
                else
                    local bWin1 = canPro[matchData[1][1].kPly1Data.defPlayerID];
                    local bWin2 = canPro[matchData[1][1].kPly2Data.defPlayerID];
                    local bWin = true;
                    if bWin1 and bWin2 then
                        bWin = bWin1.width > bWin2.width;
                    elseif bWin1 then
                        bWin = true;
                    elseif bWin2 then
                        bWin = false;
                    end

                    if bWin then
                        matchData[1][1].defPlyWinner = matchData[1][1].kPly1Data.defPlayerID;
                    else
                        matchData[1][1].defPlyWinner = matchData[1][1].kPly2Data.defPlayerID;
                    end
                end
            end
        end
    
        if roundIndex < #(battleCount) then
            self.matchTypeData.uiStage = ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_WATCH;
            self.matchTypeData.dwRoundID = battleCount[roundIndex];
        else
            self.matchTypeData.uiStage = ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH;
            self.matchTypeData.dwRoundID = 0;
        end
    end
end

-- 获取缓存的比赛阶段, 如果没有, 就获取当前的比赛阶段, 获取一次后清除
function ArenaScriptDataManager:GetCurCacheStageID()
    local dwRoundID = 0
    if self.dwCacheRoundID then
        dwRoundID = self.dwCacheRoundID
        self.dwCacheRoundID = nil
    elseif self.matchTypeData then
        dwRoundID = self.matchTypeData.dwRoundID or 0
    end
    return dwRoundID
end

function ArenaScriptDataManager:GotoNextStage()
    if not self.matchTypeData then
        return
    end
    -- 切换阶段之前先缓存一下旧的比赛阶段id, 如果有未取用的缓存数据, 不覆盖
    if self.dwCacheRoundID == nil then
        self.dwCacheRoundID = self.matchTypeData.dwRoundID
    end
    -- 切换阶段
    local battleCount = self.tempBattleCount;
    local roundIndex = self.curRoundIndex + 1;
    if roundIndex < #(battleCount) then
        self.matchTypeData.uiStage = ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_BET;
        self.matchTypeData.dwRoundID = battleCount[roundIndex];
    else
        self.matchTypeData.uiStage = ARENA_MATCH_STAGE.ARENA_MATCH_STAGE_ID_FINISH;
        self.matchTypeData.dwRoundID = 0;
    end
end

function ArenaScriptDataManager:ScriptArenaDefCaculate()
    if self.tempTBData and self:GetArenaIsOver(self.tempTBData.BaseID) then
        if self.tempTBData.EMBattle and self.curRoundIndex < #(self.tempTBData.EMBattle) - 1 then
            self.curRoundIndex = #(self.tempTBData.EMBattle) - 1;
            self:CaculateMatch();
            self:GotoNextStage();
        end
    end
end

function ArenaScriptDataManager:GetSelfBattleData()
    local matchData = self.tempMatchData;
    local battleCount = self.tempBattleCount;
    local playerID = PlayerSetDataManager:GetInstance():GetPlayerID();
    
    local round = 0;
    for i = 1, #(battleCount) do
        if matchData[battleCount[i]] then
            for j = 1, #(matchData[battleCount[i]]) do
                local data = matchData[battleCount[i]][j];
                if playerID == data.kPly1Data.defPlayerID then
                    round = battleCount[i];
                end
    
                if playerID == data.kPly2Data.defPlayerID then
                    round = battleCount[i];
                end
            end
        end
    end

    return round ~= 0 and true or false, round;
end

function ArenaScriptDataManager:GetTempTBData()
    return self.tempTBData;
end

function ArenaScriptDataManager:GetTempMatchData()
    return self.tempMatchData;
end

function ArenaScriptDataManager:GetMatchTypeData()
    return self.matchTypeData;
end

function ArenaScriptDataManager:GetArenaIsOver(matchType)
    if not matchType then
        return false;    
    end
    return self.arenaIsOver[matchType];
end

function ArenaScriptDataManager:ResetOver(matchType)
    if not matchType then
        return false;    
    end

    self.arenaIsOver[matchType] = false;
    return true;
end

return ArenaScriptDataManager;