RankDataManager = class('RankDataManager');
RankDataManager._instance = nil;

function RankDataManager:GetInstance()
    if RankDataManager._instance == nil then
        RankDataManager._instance = RankDataManager.new();
        RankDataManager._instance:Init();
    end

    return RankDataManager._instance;
end

function RankDataManager:Init()
    self.rankData = {};
    self.singleData = {};
    self.rankCheckData = {};
    self.totalCount = 0;
    self.limitCount = 100;
end

function RankDataManager:GetTestRankData()
    local data = {
            ["members"] = {
                ['1'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "425",
                    ["snap_rank"] = 0,
                },
                ['2'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "420",
                    ["snap_rank"] = 0,
                },
                ['3'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "415",
                    ["snap_rank"] = 0,
                },
                ['4'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "410",
                    ["snap_rank"] = 0,
                },
                ['5'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "405",
                    ["snap_rank"] = 0,
                },
                ['6'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "405",
                    ["snap_rank"] = 0,
                },
                ['7'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "405",
                    ["snap_rank"] = 0,
                },
                ['8'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "405",
                    ["snap_rank"] = 0,
                },
                ['9'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "405",
                    ["snap_rank"] = 0,
                },
                ['10'] = {
                    ["member"]    = "600144#南风共酒",
                    ["score"]     = "99999",
                    ["snap_rank"] = 0,
                },
               
            },
        ["total"]      = 10,
        ["total_page"] = 1,
    }

    self:OnQryRankRep(data, 1);

    return data;
end

function RankDataManager:SetLimitCount(limitCount)
    self.limitCount = limitCount;
end

function RankDataManager:OnQryRankMemberRep(msg, rankid, member)
    
    if not msg.datas then
        return;
    end
    
    if not self.singleData[rankid] then
        self.singleData[rankid] = {};
    end

    for k, v in pairs(msg.datas) do
        if type(k) == 'number' then
            self.singleData[rankid][v.member] = v;
            self.singleData[rankid][v.member].name = v.member;
            self.singleData[rankid][v.member].member = v.member;
            self.singleData[rankid][v.member].metadata = v.metadata;
            self.singleData[rankid][v.member].score = { self:TryToTransRankScore(rankid, v.score) or 0 };
        end
    end
end

function RankDataManager:GetRankDataByMember(rankid, member)
    if (not rankid) or (not member) then
        return nil;
    end

    rankid = tostring(rankid);
    if not self.singleData[rankid] then
        return nil;
    end
    
    member = tostring(member);
    return self.singleData[rankid][member];
end

function RankDataManager:GetRankDataByPlayerID(rankid, playerID)

    rankid = tostring(rankid);
    if not self.rankData[rankid] then
        return nil, 0;
    end

    local members = self.rankData[rankid]['members'] or {};
    for i = 1, #(members) do
        local curPlayerID = string.match(members[i].member, '(.+)#') or members[i].member;
        if curPlayerID == tostring(playerID) then
            return members[i], i;
        end
    end

    return nil, 0;
end

function RankDataManager:OnQryRankRep(msg, rankid, maxNum)

    if msg then

        self.totalCount = msg.total;

        self.rankData[rankid] = self.rankData[rankid] or {};
        -- self.rankData[rankid]['members'] = {};
        -- self.rankData[rankid]['total'] = 0;
        
        local data = self:FormateData(msg.members, rankid);
        -- local sortT = {};
        -- if self.rankCheckData[rankid] then
        --     for k, v in pairs(self.rankCheckData[rankid]) do
        --         table.insert(sortT, v);
        --     end
        -- end

        -- local _sort = function(a, b)
        --     if a.score[1] == b.score[1] then
        --         local playerID1 = string.match(a.member, '(.+)#') or a.member;
        --         local playerID2 = string.match(b.member, '(.+)#') or b.member;
        --         return tonumber(playerID1) < tonumber(playerID2);
        --     else
        --         return a.score[1] > b.score[1];
        --     end
        -- end
        -- table.sort(sortT, _sort);

        local tempT = {};
        maxNum = maxNum or self.limitCount;
        if #(data) > maxNum then
            table.move(data, 1, maxNum, #(tempT) + 1, tempT);
            data = tempT;
        end

        -- local length = #(self.rankData[rankid]['members']);
        -- local lastline = self.rankData[rankid]['members'][length];
        -- for k, v in pairs(sortT) do
        --     if lastline then
        --         if v.score and lastline.score and v.score[1] == lastline.score[1] then 
        --             v.rank = lastline.rank;
        --         else
        --             v.rank = length + 1;
        --         end
        --     end

        --     length = length + 1;
        --     self.rankData[rankid]['members'][length] = v;
        --     lastline = self.rankData[rankid]['members'][length];

        --     self.rankData[rankid]['total'] = self.rankData[rankid]['total'] + 1;
        -- end
        self.rankData[rankid]['members'] = data;
        self.rankData[rankid]['total'] = #(data);

        --
        local tempT = {};
        for i,member in ipairs(msg.members or {} ) do
            local playerID = string.match(member.member, '(.+)#') or member.member;
            table.insert(tempT, playerID);
        end
    
        local _callback = function()
            --
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_RANKUI', self.rankData[rankid]);
            LuaEventDispatcher:dispatchEvent('ONEVENT_REF_RANKINGDATA');
        
            --
            REQUEST_WEIWANG_COUNT = REQUEST_WEIWANG_COUNT - 1;
            if REQUEST_WEIWANG_COUNT == 0 then
                REQUEST_WEIWANG_COUNT = 9;
                LuaEventDispatcher:dispatchEvent('ONEVENT_REF_WEIWANG');
            end
        end
    
        -- if getTableSize2(tempT) > 0 then
        --     SocialDataManager:GetInstance():QueryFriendInfo(tempT, _callback);
        -- else
        --     _callback();
        -- end
        _callback();
    end
end

function RankDataManager:ResetRankData()
    self.rankData = {};
    self.rankCheckData = {};
end

function RankDataManager:ResetRankDataByID(rankid)
    self.rankData[tostring(rankid)] = {};
    self.rankCheckData[tostring(rankid)] = {};
end

function RankDataManager:ResetArenaRankData()
    local tbRankData = self:GetTBRankData();
    local rankTypeTable = {};
    for k, v in pairs(tbRankData) do
        if tbRankData[k] and tbRankData[k].Show == TBoolean.BOOL_YES and tbRankData[k].BaseID > 100 then
            table.insert(rankTypeTable, tbRankData[k]);
        end
    end

    for i = 1, #(rankTypeTable) do
        self:ResetRankDataByID(rankTypeTable[i].BaseID);
    end
end

function RankDataManager:GetTotalCount()
    return self.totalCount;
end

-- TIPS: 由于声望排行榜在声望值相等的同时还要额外做经脉值的排行
-- 所以声望排行榜的数值实际是由经脉值加声望值组合而成的
-- 客户端在使用 "声望排行榜" 数据之前, 需要先对数值做一个转换:
-- 将原值右移14位拿到实际的声望值
function RankDataManager:TryToTransRankScore(strRankID, strOriScore)
    if (not strRankID) or (not strOriScore) then
        return 0
    end
    local uiOriScore = tonumber(strOriScore) or 0
    -- 拿到所有声望排行榜
    if not self.kAllPrestigeRankIDCheck then
        self.kAllPrestigeRankIDCheck = {}
        local kRankListDBData = TableDataManager:GetInstance():GetTable("RankListAll")
        for uiBaseID, kData in pairs(kRankListDBData) do
            if kData.EntryName1 == "声望" then
                self.kAllPrestigeRankIDCheck[tostring(uiBaseID)] = true
            end
        end
    end
    if self.kAllPrestigeRankIDCheck[strRankID] ~= true then
        return uiOriScore
    end
    -- 右移14位处理
    return (uiOriScore >> 14)
end

function RankDataManager:FormateData(members, rankid)
    local data = self.rankData[rankid]['members'] or {};

    -- TODO 去重
    if members then
        for i = 1, #(members) do
            local v = members[i];

            if not self.rankCheckData[rankid] then
                self.rankCheckData[rankid] = {};
            end

            -- 检查是否需要预处理数值
            if v.bPreProcessValue ~= true then
                v.bPreProcessValue = true
                v.score = self:TryToTransRankScore(rankid, v.score)
            end

            local tempD = {
                rank = k,
                name = v.member,
                member = v.member,
                metadata = v.metadata,
                score = { v.score };
            };

            if v.attrib then
                SocialDataManager:GetInstance():SetPlayerData(v.attrib);
            end

            local playerID = string.match(v.member, '(.+)#') or v.member;
            if not self.rankCheckData[rankid][playerID] then
                table.insert(data, tempD);
                if rankid and playerID then
                    self.rankCheckData[rankid][playerID] = tempD;
                end
            else
                if tempD.score[1] > self.rankCheckData[rankid][playerID].score[1] then
                    self.rankCheckData[rankid][playerID] = tempD;
                end
            end
        end
    end
    
    return data;
end

function RankDataManager:LoadByCacheData(rankid)
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_RANKUI', self.rankData[tostring(rankid)]);
    LuaEventDispatcher:dispatchEvent('ONEVENT_REF_RANKINGDATA');
end

function RankDataManager:GetRankCacheData(rankid)
    return self.rankData[tostring(rankid)];
end

function RankDataManager:GetRankData()
    return self.rankData;
end

function RankDataManager:GetTBRankData()
    return TableDataManager:GetInstance():GetTable("RankListAll")
end

return RankDataManager;