NetCommonFriend = {};

FriendEventType = {
    FE_None = 0,
    FE_Apply = 1,   -- 申请加好友
    FE_Accept = 2,  -- 申请结果有变化
	FE_Deleted = 3, -- 被删除
	FE_Blocked = 4, -- 被拉黑
	FE_Message = 5, -- 短消息
}

local urlGetFriendList      = 'FriendService.GetFriendList';
local urlGetFriendListV2    = 'FriendService.GetFriendListV2';
local urGetApplyList        = 'FriendService.GetApplyList';
local urlApplyAddFriend     = 'FriendService.ApplyAddFriend';
local urlDeleteFriend       = 'FriendService.DeleteFriend';
local urlAddFriend          = 'FriendService.AddFriend';
local urlAnswerAddFriend    = 'FriendService.AnswerAddFriend';
local urlRenameFriend       = 'FriendService.RenameFriend';

function NetCommonFriend:Init(data)
    
	local friend = {};
    friend.data = data;
    
	local config = NetCommonData.Config;
    local from = ''--config.host .. config.url;
    friend.urlGetFriendList     = from .. urlGetFriendList;
    friend.urlGetFriendListV2   = from .. urlGetFriendListV2;
    friend.urGetApplyList       = from .. urGetApplyList;
    friend.urlApplyAddFriend    = from .. urlApplyAddFriend;
    friend.urlDeleteFriend      = from .. urlDeleteFriend;
    friend.urlAddFriend         = from .. urlAddFriend;
    friend.urlAnswerAddFriend   = from .. urlAnswerAddFriend;
    friend.urlRenameFriend      = from .. urlRenameFriend;

    self.friend = friend;
    return friend;
end

-- 查询好友列表
-- @callback function(string, GetFriendListReply) end
function NetCommonFriend:GetFriendList()
    if self.friend and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid  = self.friend.data.userid,
        }

        AppsManager.Invoker:AsyncCall(self.friend.urlGetFriendList, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnGetFriendList(r.data, r.code);
        end)
    end
end

function NetCommonFriend:OnGetFriendList(data, code)
    if code ~= 0 then
        return;
    end

    local _callback = function()

        local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
        local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');

        if socialUI then
            socialUI:RefFriendRedPoint();
        end

        if houseUI then
            houseUI:RefFriendRedPoint();
        end
    end
    
    SocialDataManager:GetInstance():SetApplyData(data);
    SocialDataManager:GetInstance():SetFriendData(data);
    SocialDataManager:GetInstance():SetOtherPlayerData(data.friends.friends);
    SocialDataManager:GetInstance():QueryQWFriendInfoFromServer(_callback);
end

--  分页查询好友列表
--  获得当前用户的好友列表，包含好友的基础数据
-- @int32 page  @Validate(min = 1, max = 100)
-- @int32 pageNum  @Validate(min = 1, max = 200)
-- @callback function(string, GetFriendListV2Reply) end
function NetCommonFriend:GetFriendListV2(page, pageNum)
    if self.friend and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid, 
            userid      = self.friend.data.userid,
            page        = page,
            pageNum     = pageNum,
        }
    
        AppsManager.Invoker:AsyncCall(self.friend.urlGetFriendListV2, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp)
            if not r and err then
                return;
            end
            self:OnGetFriendListV2(r.data, r.code)
        end)
    end
end

function NetCommonFriend:OnGetFriendListV2(data, code)
    if code ~= 0 then
        return;
    end

    SocialDataManager:GetInstance():SetFriendTotleCount(data.total);
    SocialDataManager:GetInstance():SetFriendData(data);
end

--  获取申请列表
--  包含申请列表和发出的申请
-- @callback function(string, GetApplyListReply) end
function NetCommonFriend:GetApplyList()
    local parameters = {
        appid       = NetCommonData.Config.appid, 
        userid      = self.friend.data.userid,
    }

    AppsManager.Invoker:AsyncCall(self.friend.urGetApplyList, DKJson.encode(parameters), function(resp)
        local r, n, err = DKJson.decode(resp)
        if not r and err then
            return;
        end
        self:OnGetApplyList(r.data, r.code)
    end)
end

function NetCommonFriend:OnGetApplyList(data, code)
    if code ~= 0 then
        return;
    end

    SocialDataManager:GetInstance():SetApplyData(data);
end

-- 申请添加好友
-- @string friendid  好友玩家ID
-- @callback function(string, ApplyAddFriendReply) end
function NetCommonFriend:ApplyAddFriend(friendid)
    if self.friend and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid, 
            userid      = self.friend.data.userid,
            friendid    = tostring(friendid),
        }
        
        AppsManager.Invoker:AsyncCall(self.friend.urlApplyAddFriend, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnApplyAddFriend(friendid, r.data, r.code);
        end)
    end
end

function NetCommonFriend:OnApplyAddFriend(friendid, data, code)

end

-- 审核添加请求
-- @string friendid  好友玩家ID
-- @bool accept  是否同意
-- @callback function(string, AnswerAddFriendReply) end
function NetCommonFriend:AnswerAddFriend(friendid, accept)
    if self.friend and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid,
            userid      = self.friend.data.userid,
            friendid    = tostring(friendid),
            accept      = accept,
        }
        
        AppsManager.Invoker:AsyncCall(self.friend.urlAnswerAddFriend, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnAnswerAddFriend(friendid, accept, r.data, r.code);
        end)
    end
end

function NetCommonFriend:OnAnswerAddFriend(friendid, accept, data, code)
    if code ~= 0 then
        SystemUICall:GetInstance():Toast('添加好友失败');
        return;
    end

    local delData = SocialDataManager:GetInstance():DelApplyDataByID(friendid);
    local delData2 = SocialDataManager:GetInstance():DelApplyDataByID2(friendid);
    if accept then
        SystemUICall:GetInstance():Toast('添加好友成功');
        if delData then
            SocialDataManager:GetInstance():AddFriendData(delData);
        end
        if delData2 then
            SocialDataManager:GetInstance():AddFriendData2(delData2);
        end
    else
        
    end

    local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
    local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');
    
    if socialUI then
        socialUI:RefAnswerAddFriend(friendid, accept);
    end
    
    if houseUI then
        houseUI:RefFriendRedPoint();
    end
end

-- 删除好友
-- @string friendid  好友玩家ID
-- @callback function(string, DeleteFriendReply) end
function NetCommonFriend:DeleteFriend(friendid)
    if self.friend and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid,
            userid      = self.friend.data.userid,
            friendid    = tostring(friendid),
        }
        
        AppsManager.Invoker:AsyncCall(self.friend.urlDeleteFriend, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnDeleteFriend(friendid, r.data, r.code);
        end)
    end
end

function NetCommonFriend:OnDeleteFriend(friendid, data, code)
    if code ~= 0 then
        SystemUICall:GetInstance():Toast('删除好友失败');
        return;
    end

    SystemUICall:GetInstance():Toast('删除好友成功');

    SocialDataManager:GetInstance():DelFriendDataByID(friendid);
    SocialDataManager:GetInstance():DelFriendDataByID2(friendid);

    local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
    if socialUI then
        socialUI:OnRefFriendUI();
    end
end

-- 修改好友备注(仅自己查看)
-- @string friendid  好友玩家ID
-- @string nickname  备注
-- @callback function(string, RenameFriendReply) end
function NetCommonFriend:RenameFriend(friendid, nickname)
    if self.friend and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid,
            userid      = self.friend.data.userid,
            friendid    = tostring(friendid),
            nickname    = nickname,
        }
        
        AppsManager.Invoker:AsyncCall(self.friend.urlRenameFriend, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnRenameFriend(friendid, nickname, r.data, r.code);
        end)
    end
end

function NetCommonFriend:OnRenameFriend(friendid, nickname, data, code)

end

-- 无须确认直接加好友
-- @string friendid  好友玩家ID
-- @callback function(string, AddFriendReply) end
function NetCommonFriend:AddFriend(friendid)
    if self.friend and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid       = NetCommonData.Config.appid,
            userid      = self.friend.data.userid,
            friendid    = tostring(friendid),
        }
        
        AppsManager.Invoker:AsyncCall(self.friend.urlAddFriend, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnAddFriend(friendid, r.data, r.code);
        end)
    end
end

function NetCommonFriend:OnAddFriend(friendid, data, code)
    local bSuccess = (code == 0)
    if not bSuccess then
        return
    end
    -- 这里是强制加好友的回调
end

return NetCommonFriend;