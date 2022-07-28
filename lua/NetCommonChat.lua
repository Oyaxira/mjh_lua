-- 聊天服务 （注意：世界聊天，分频道聊天，场景聊天等 不属于聊天服务负责，请使用BroadcastService）
-- 基于会话的聊天服务实现，私聊，群聊功能
-- 支持离线消息
-- @module ChatService
-- @author linbo

NetCommonChat = {};

EventType = {
    None = 0,   -- 无
    Create = 1, -- 创建会话
    Join = 2,   -- 加入会话
    Leave = 3,  -- 离开会话
    Publish = 4, -- 发布消息
    Rename = 5, -- 修改主题
}

local urlGetSessionList = 'ChatService.GetSessionList';
local urlCreateSession  = 'ChatService.CreateSession';
local urlJoinSession    = 'ChatService.JoinSession';
local urlRenameSession  = 'ChatService.RenameSession';
local urlLeaveSession   = 'ChatService.LeaveSession';
local urlPublishMsg     = 'ChatService.PublishMsg';
local urlTakeEvents     = 'ChatService.TakeEvents';
local urlDestroySession = 'ChatService.DestroySession';
local urlAckSessionVer = 'ChatService.AckSessionVer';


function NetCommonChat:Init(data)

	local chat = {};
    chat.data = data;
    
	local config = NetCommonData.Config;
    local from = ''--config.host .. config.url;
    chat.urlGetSessionList  = from .. urlGetSessionList;
    chat.urlCreateSession   = from .. urlCreateSession;
    chat.urlJoinSession     = from .. urlJoinSession;
    chat.urlRenameSession   = from .. urlRenameSession;
    chat.urlLeaveSession    = from .. urlLeaveSession;
    chat.urlPublishMsg      = from .. urlPublishMsg;
    chat.urlTakeEvents      = from .. urlTakeEvents;
    chat.urlDestroySession  = from .. urlDestroySession;
    chat.urlAckSessionVer  = from .. urlAckSessionVer;

    self.chat = chat;
    return chat;
end

-- 获得当前会话列表
-- @callback function(string, GetSessionListReply) end
function NetCommonChat:GetSessionList()
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.chat.data.userid,
        }

        AppsManager.Invoker:AsyncCall(self.chat.urlGetSessionList, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnGetSessionList(r.data, r.code);
        end)
    end
end

function NetCommonChat:OnGetSessionList(data, code)
    if code ~= 0 then
        return;
    end

    ChatBoxUIDataManager:GetInstance():SetSessionList(data.list);
end

-- 创建会话
-- @[]string members  包含成员列表
-- @string name  会话名
-- @bool offmsg  是否支持离线消息，否则仅转发在线
-- @callback function(string, CreateSessionReply) end
function NetCommonChat:CreateSession(members, name)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid  = self.chat.data.userid,
            members = members,
            name    = name,
        }
        
        AppsManager.Invoker:AsyncCall(self.chat.urlCreateSession, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnCreateSession(members, name, r.data, r.code);
        end)
    end
end

function NetCommonChat:OnCreateSession(members, name, data, code)
    if code ~= 0 then
        return;
    end

    -- TODO
    ChatBoxUIDataManager:GetInstance():AddSession(data.data, true);
end

-- 加入玩家到会话
-- @int64 sessid  会话
-- @[]string members  邀请的人
-- @callback function(string, JoinSessionReply) end
function NetCommonChat:JoinSession(sessid, members)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid  = self.chat.data.userid,
            sessid  = sessid,
            members = members,
        }
        
        AppsManager.Invoker:AsyncCall(self.chat.urlJoinSession, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnJoinSession(r.data, r.code);
        end)
    end
end

function NetCommonChat:OnJoinSession(data, code)
    
end

-- 修改会话主题
-- @int64 sessid  会话ID
-- @string name  会话名
-- @callback function(string, RenameSessionReply) end
function NetCommonChat:RenameSession(sessid, name)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.chat.data.userid,
            sessid = sessid,
            name   = name,
        }
        
        AppsManager.Invoker:AsyncCall(self.chat.urlRenameSession, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnRenameSession(r.data, r.code);
        end)
    end
end

function NetCommonChat:OnRenameSession(data, code)

end

-- 离开会话
-- @int64 sessid  会话ID
-- @callback function(string, LeaveSessionReply) end
function NetCommonChat:LeaveSession(sessid)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.chat.data.userid,
            sessid = sessid,
        }
        
        AppsManager.Invoker:AsyncCall(self.chat.urlLeaveSession, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnLeaveSession(r.data, r.code);
        end)
    end
end

function NetCommonChat:OnLeaveSession(data, code)

end

-- 发送消息
-- @int64 sessid  会话
-- @string data  消息
-- @callback function(string, PublishMsgReply) end
function NetCommonChat:PublishMsg(sessid, data)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            userid = self.chat.data.userid,
            sessid = sessid,
            data   = data,
        }

        AppsManager.Invoker:AsyncCall(self.chat.urlPublishMsg, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnPublishMsg(r.data, r.code);
        end)
    end
end

function NetCommonChat:OnPublishMsg(data, code)

end

-- 拉取消息
-- @[]*TakeArgs reqs  请求列表
-- @int32 page  页数
-- @int32 pageNum  每页数量
-- @callback function(string, TakeEventsReply) end
function NetCommonChat:TakeEvents(sessid, version, num)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid  = self.chat.data.userid,
            sessid  = sessid,
            version = version,
            num     = num,
            forward = true,
        }
        
        AppsManager.Invoker:AsyncCall(self.chat.urlTakeEvents, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnTakeEvents(r.data, r.code);
        end)
    end
end

function NetCommonChat:OnTakeEvents(data, code)
    if code ~= 0 then
        return;
    end

    ChatBoxUIDataManager:GetInstance():SetTakeEventsData(data.events);
    ChatBoxUIDataManager:GetInstance():AssembleRedPointData();
    ChatBoxUIDataManager:GetInstance():SetTakeEventsCount();
    
    local sessionList = ChatBoxUIDataManager:GetInstance():GetSessionList();
    local takeEventsCount = ChatBoxUIDataManager:GetInstance():GetTakeEventsCount();
    if takeEventsCount == #(sessionList) then
        ChatBoxUIDataManager:GetInstance():ResetTakeEventsCount();
        local chatBoxUI = WindowsManager:GetInstance():GetUIWindow('ChatBoxUI');
        if chatBoxUI then
            chatBoxUI:OnRefNewMsgUI(data);
            chatBoxUI:OnRefPrivateRedPointCount();
        end
    end
end

-- 销毁会话
-- @int64 sessid  会话
-- @callback function(string, DestroySessionReply) end
function NetCommonChat:DestroySession(sessid)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid  = NetCommonData.Config.appid,
            sessid = sessid,
        }
        
        AppsManager.Invoker:AsyncCall(self.chat.urlDestroySession, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnDestroySession(r.data, r.code);
        end)
    end
end  

function NetCommonChat:OnDestroySession(data, code)

end

--  确认已读回执
--  将标记会话的已读位置, 方便客户端下次从未读点继续
--  比如玩家上次确认版本号是 5
--  收到了新消息
--  6
--  7
--  8 <- 本次最大值
--  玩家点开会话查看之后，需要发送最大的版本号给服务器确认，比如这里的例子是 8
-- @int64 sessid   会话, @Validate(nonzero)
-- @int64 version   确认版本号, @Validate(min = 1)
-- @callback function(string, AckSessionVerReply) end
function NetCommonChat:AckSessionVer(sessid, version)
    if self.chat and AppsManager and AppsManager.Invoker then
        local parameters = {
            appid   = NetCommonData.Config.appid,
            userid  = self.chat.data.userid,
            sessid  = sessid,
            version = version,
        }
    
        AppsManager.Invoker:AsyncCall(self.chat.urlAckSessionVer, DKJson.encode(parameters), function(resp)
            local r, n, err = DKJson.decode(resp);
            self:OnAckSessionVer(r.data, r.code);
        end)
    end
end

function NetCommonChat:OnAckSessionVer(data, code)

end

return NetCommonChat;