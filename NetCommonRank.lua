NetCommonRank = {};

local urlUpdateRank     = 'RankingService.UpdateRank';
local urlQueryRank      = 'RankingService.QueryRank';
local urlDeleteRank     = 'RankingService.DeleteRank';
local urlSnapshotRank   = 'RankingService.SnapshotRank';
local urlQueryWithScore = 'RankingService.QueryWithScore';
local urlQueryWithRank  = 'RankingService.QueryWithRank';
local urlQueryWithMember = 'RankingService.QueryWithMember';
local urlTruncate       = 'RankingService.Truncate';

function NetCommonRank:Init(data)

	local rank = {};
    rank.data = data;
    
	local config = NetCommonData.Config;
    local from = ''--config.host .. config.url;
    rank.urlUpdateRank      = from .. urlUpdateRank;
    rank.urlQueryRank       = from .. urlQueryRank;
    rank.urlDeleteRank      = from .. urlDeleteRank;
    rank.urlSnapshotRank    = from .. urlSnapshotRank;
    rank.urlQueryWithScore  = from .. urlQueryWithScore;
    rank.urlQueryWithRank   = from .. urlQueryWithRank;
    rank.urlQueryWithMember  = from .. urlQueryWithMember;
    rank.urlTruncate        = from .. urlTruncate;

    self.rank = rank;
    return rank;
end

-- 更新排行榜
-- 更新指排行榜中的玩家的排名值，支持设置是否为替换或者加法
-- @string rank  @Validate(nonzero)
-- @string member  @Validate(nonzero)
-- @int64 score  排名积分
-- @bool is_add  是否为添加值模式，否则为替换模式
-- @callback function(string, UpdateRankReply) end
function NetCommonRank:UpdateRank(rank, member, score, is_add)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            rank   = rank,
            member = member,
            score  = score,
            is_add = is_add,
        }

        AppsManager.Invoker:AsyncCall(self.rank.urlUpdateRank, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnUpdateRank(r.data, r.code, member, score);
        end)
    end
end

function NetCommonRank:OnUpdateRank(data, code, member, score)

end

-- 查询排行榜
-- 支持分页查询，支持设置降序或者升序模式
-- 支持查询指定的玩家所在排名
-- 支持查询快照排行榜
-- @string rank  @Validate(nonzero)
-- @int32 page  @Validate(min = 1, max = 100)
-- @int32 page_num  @Validate(min = 1, max = 100)
-- @bool is_asc  是否升序 (默认降序)
-- @string member  查询成员排名 (可选)
-- @string snap  快照排行榜(可选，用于查询排名升降)
-- @bool is_snap  查询快照排行榜(查询快照时，snap参数自动失效)
-- @bool incAttrib   是否包含玩家属性（排行榜键必须是玩家ID）
-- @callback function(string, QueryRankReply) end
function NetCommonRank:QueryRank(rank, page, page_num, is_asc, member, snap, is_snap, incAttrib, maxNum)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            rank     = rank,
            page     = page,
            page_num = page_num,
            is_asc   = is_asc,
            member   = member,
            snap     = snap,
            is_snap  = is_snap,
            incAttrib = incAttrib,
        }
        
        AppsManager.Invoker:AsyncCall(self.rank.urlQueryRank, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnQueryRank(r.data, r.code, rank, page, page_num, is_asc, member, snap, is_snap, incAttrib, maxNum);
        end)
    end
end

function NetCommonRank:OnQueryRank(data, code, rank, page, page_num, is_asc, member, snap, is_snap, incAttrib, maxNum)
    if code ~= 0 then
        return;
    end

    RankDataManager:GetInstance():OnQryRankRep(data, rank, maxNum);
end

-- 删除排行榜
-- 支持删除指定排名段或者指定玩家的数据
-- 优先删除指定玩家的排行数据
-- 删除开始排名(0 代表第一个, -1代表最后)
-- @string rank  @Validate(nonzero)
-- @int32 start  删除开始排名(0 代表第一个)
-- @int32 stop  删除结束排名(-1 代表最后一个)
-- @string member  删除指定成员
-- @bool is_asc  是否升序 (默认降序)
-- @callback function(string, DeleteRankReply) end
function NetCommonRank:DeleteRank(rank, start, stop, member, is_asc)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            rank   = rank,
            start  = start,
            stop   = stop,
            member = member,
            is_asc = is_asc,
        }
        
        AppsManager.Invoker:AsyncCall(self.rank.urlDeleteRank, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnDeleteRank(r.data, r.code, rank, start, stop, member, is_asc);
        end)
    end
end

function NetCommonRank:OnDeleteRank(data, code, rank, start, stop, member, is_asc)

end


-- 创建快照
-- 支持为排行榜创建快照，支持设定快照排行榜有效期，超时自动删除
-- @string rank  @Validate(nonzero)
-- @string snap  @Validate(nonzero)
-- @int32 ttl  快照有效期(秒，<= 0 代表永久有效)
-- @callback function(string, SnapshotRankReply) end
function NetCommonRank:SnapshotRank(rank, snap, ttl)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            rank  = rank,
            snap  = snap,
            ttl   = ttl,
        }
        
        AppsManager.Invoker:AsyncCall(self.rank.urlSnapshotRank, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnSnapshotRank(r.data, r.code, rank, snap, ttl);
        end)
    end
end

function NetCommonRank:OnSnapshotRank(data, code, rank, snap, ttl)

end

-- 根据分数查询
-- 指定排行榜分值进程查询
-- @string rank  @Validate(nonzero)
-- @int64 min_score  最小分 (0最小)
-- @int64 max_score  最大分 (-1最大)
-- @bool is_asc  是否升序 (默认降序)
-- @int32 limit  @Validate(max = 100)
-- @callback function(string, QueryWithScoreReply) end
function NetCommonRank:QueryWithScore(rank, min_score, max_score, is_asc, limit)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            rank      = rank,
            min_score = min_score,
            max_score = max_score,
            is_asc    = is_asc,
            limit     = limit,
        }
        
        AppsManager.Invoker:AsyncCall(self.rank.urlQueryWithScore, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnQueryWithScore(r.data, r.code, rank, min_score, max_score, is_asc, limit);
        end)
    end
end

function NetCommonRank:OnQueryWithScore(data, code, rank, min_score, max_score, is_asc, limit)

end

-- 根据排名查询
-- 指定排名进行查询
-- @string rank  @Validate(nonzero)
-- @[]int32 ranks  @Validate(min = 1, max = 100)
-- @bool is_asc  是否升序 (默认降序)
-- @callback function(string, QueryWithRankReply) end
function NetCommonRank:QueryWithRank(rank, ranks, is_asc)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            rank      = rank,
            ranks     = ranks,
            is_asc    = is_asc,
        }
        
        AppsManager.Invoker:AsyncCall(self.rank.urlQueryWithRank, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnQueryWithRank(r.data, r.code, rank, ranks, is_asc);
        end)
    end
end

function NetCommonRank:OnQueryWithRank(data, code, rank, ranks, is_asc)

end

-- 根据玩家查询
-- 指定玩家id进行查询
-- @string rank  @Validate(nonzero)
-- @[]string members  @Validate(min = 1, max = 100)
-- @bool is_asc  是否升序 (默认降序)
-- @callback function(string, QueryWithMemberReply) end
function NetCommonRank:QueryWithMember(rank, members, is_asc)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            rank    = rank,
            members = members,
            is_asc  = is_asc,
        }
        
        AppsManager.Invoker:AsyncCall(self.rank.urlQueryWithMember, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnQueryWithMember(r.data, r.code, rank, members, is_asc);
        end)
    end
end

function NetCommonRank:OnQueryWithMember(data, code, rank, members, is_asc)
    if code ~= 0 then
        return;
    end

    RankDataManager:GetInstance():OnQryRankMemberRep(data, rank, members);
end

-- 清除数据
-- 该操作仅允许服务端角色经常操作
-- 该操作将会清除数据，请慎重操作，数据无法恢复
-- @TruncateArgs.ClearType type  
-- @callback function(string, TruncateReply) end
function NetCommonRank:Truncate(type)
    if self.rank and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid = self.rank.data.userid,
            type   = type,
        }
        
        AppsManager.Invoker:AsyncCall(self.rank.urlTruncate, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnTruncate(r.data, r.code, type);
        end)
    end
end

function NetCommonRank:OnTruncate(data, code, type)

end

return NetCommonRank;