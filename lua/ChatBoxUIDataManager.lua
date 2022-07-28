ChatBoxUIDataManager = class('ChatBoxUIDataManager');
ChatBoxUIDataManager._instance = nil;

function ChatBoxUIDataManager:GetInstance()
    if ChatBoxUIDataManager._instance == nil then
        ChatBoxUIDataManager._instance = ChatBoxUIDataManager.new();
        ChatBoxUIDataManager._instance:Init();
    end

    return ChatBoxUIDataManager._instance;
end

function ChatBoxUIDataManager:Init()
    self.channelAll = {};
    self:ResetData();
end

function ChatBoxUIDataManager:ResetData()
    self.sessionList = {};
    self.eventsData = {};
    self.redPoint = {};
    self.msgVersion = {};
    self.takeEventsCount = 0;
end

function ChatBoxUIDataManager:AssembleMsgVersion()
    for i = 1, #(self.sessionList) do
        self.msgVersion[self.sessionList[i].sessid] = self.sessionList[i].version;
    end
end

function ChatBoxUIDataManager:GetTakeEvents()
    for i = 1, #(self.sessionList) do
        local num = 100;
        local version = 0;
        NetCommonChat:TakeEvents(self.sessionList[i].sessid, version, num);
    end
end

function ChatBoxUIDataManager:QuerySessionListMemberInfo(callback)
    local memberT = {};
    for i = 1, #(self.sessionList) do
        local otherMember = self:GetOtherMember(self.sessionList[i].members);
        if otherMember then
            table.insert(memberT, otherMember);
        end
    end
    SocialDataManager:QueryFriendInfo(memberT, callback);
end

function ChatBoxUIDataManager:CheckSession()
    local tempT = {};
    local haveSessionMember = {}
    local playerID = globalDataPool:getData("PlayerID")
    for i = 1, #(self.sessionList) do
        if #(self.sessionList[i].members) > 1 then
            local otherID
            for j=1,#self.sessionList[i].members do
                if (self.sessionList[i].members[j]~=playerID) then
                    otherID = self.sessionList[i].members[j]
                    break
                end
            end
            -- 过滤重复开启的会话
            if not haveSessionMember[otherID] then
                table.insert(tempT, self.sessionList[i])
                haveSessionMember[otherID] = true
            else
                -- 退出重复会话
                NetCommonChat:LeaveSession(self.sessionList[i].sessid);
            end
        end
    end
    self.sessionList = tempT;
end

-- 增加setGetSessionFlag判断拉取私聊会话是否结束
function ChatBoxUIDataManager:SetSessionGetFinishFlag(f)
    self.setGetSessionFlag = f
    if DEBUG_MODE then
        if (f) then
            dprint("拉取私聊会话成功！！")
        else
            dprint("开始拉取私聊会话..")
        end
    end
end

function ChatBoxUIDataManager:GetSessionGetFinishFlag()
    return self.setGetSessionFlag
end

function ChatBoxUIDataManager:SetSessionList(data)
    if not data then
        return;
    end

    -- TODO 拉取消息这块公共技术部门的方法修改了
    self.sessionList = data;
    self:CheckSession();
    self:AssembleMsgVersion();
    self:GetTakeEvents();
    self:QuerySessionListMemberInfo();
    self:SetSessionGetFinishFlag(true)
end

function ChatBoxUIDataManager:SetTakeEventsCount()
    self.takeEventsCount = self.takeEventsCount + 1;
end

function ChatBoxUIDataManager:ResetTakeEventsCount()
    self.takeEventsCount = 0;
end

function ChatBoxUIDataManager:GetTakeEventsCount()
    return self.takeEventsCount;
end

function ChatBoxUIDataManager:GetSessionMemberData()

end

function ChatBoxUIDataManager:GetOtherMember(members)
    if members then
        for i = 1, #(members) do
            if members[i] ~= globalDataPool:getData('PlayerID') then
                return members[i];
            end
        end
    end
    return nil;
end

function ChatBoxUIDataManager:GetSessionList()
    return self.sessionList;
end

function ChatBoxUIDataManager:AddSession(session, bRefUI)
    table.insert(self.sessionList, session);

    if bRefUI then
        LuaEventDispatcher:dispatchEvent('ONEVENT_REFPRIVATEUI', session);
    end
end

function ChatBoxUIDataManager:GetSessionByID(sessid)
    for i = 1, #(self.sessionList) do
        if self.sessionList[i].sessid == sessid then
            return self.sessionList[i];
        end
    end

    return nil;
end

function ChatBoxUIDataManager:SetTakeEventsData(data)
    if not data then
        return;
    end
    
    -- TODO 聊天回话超过 30 天自动退出并销毁
    local bInsert = true;
    if data[1] then
        local sessid = data[1].sessid;
        if data[#(data)] then
            local day = timeDay(os.time(), tonumber(data[#(data)].time));
            if day > 30 then
                bInsert = false;
                NetCommonChat:LeaveSession(sessid);
            end
        end
    end

    if bInsert then
        for i = 1, #(data) do
            if not self.eventsData[data[i].sessid] then
                self.eventsData[data[i].sessid] = {};
            end
    
            if data[i].type == EventType.Publish then
                table.insert(self.eventsData[data[i].sessid], data[i]);
            end
        end
    end
end

function ChatBoxUIDataManager:AddEventsData(data)
    if not self.eventsData[data.sessid] then
        self.eventsData[data.sessid] = {};
    end

    table.insert(self.eventsData[data.sessid], data);
end

function ChatBoxUIDataManager:GetEventsDataBySessionID(sessid)
    return self.eventsData[sessid] or {};
end

function ChatBoxUIDataManager:HasEventsData(data)
    local eventData = self.eventsData[data.sessid];
    if not eventData then
        return false;
    end 

    for i = 1, #(eventData) do
        if data.version == eventData[i].version then
            return true;
        end
    end

    return false;
end

-- 按memberid返回第一个会话
function ChatBoxUIDataManager:HasSession(memberID)
    for i = 1, #(self.sessionList) do
        local session = self.sessionList[i];
        for j = 1, #(session.members) do
            if tostring(memberID) == session.members[j] then
                return session;
            end
        end
    end

    return nil;
end 

function ChatBoxUIDataManager:SetRedPoint(data)
    if not self.redPoint[data.sessid] then
        self.redPoint[data.sessid] = 0;
    end
    
    self.redPoint[data.sessid] = self.redPoint[data.sessid] + 1;
end

function ChatBoxUIDataManager:ResetRedPointBySessionID(sessid)

    if not sessid then
        return;
    end

    if self.redPoint[sessid] then
        self.redPoint[sessid] = 0;
    end
end

function ChatBoxUIDataManager:ResetRedPoint()
    for i = 1, #(self.redPoint) do
        self.redPoint[i] = 0;
    end
end

function ChatBoxUIDataManager:GetRedPointBySessionID(sessid)
    return self.redPoint[sessid] or 0;
end

function ChatBoxUIDataManager:GetRedPoint()
    return self.redPoint;
end

function ChatBoxUIDataManager:GetRedPointCount()
    local count = 0;
    for k, v in pairs(self.redPoint) do
        if self:ValidityCheck(k) then
            count = count + v;
        end
    end
    return count;
end

function ChatBoxUIDataManager:ValidityCheck(sessid)
    local session = self:GetSessionByID(sessid);
    if session then
        for i = 1, #(session.members) do
            if SocialDataManager:GetInstance():GetOtherPlayerData(session.members[i]) then
                return true;
            end
        end
    end
    return false;
end

function ChatBoxUIDataManager:AssembleRedPointData()
    for k, v in pairs(self.eventsData) do
        if self.msgVersion[k] then
            if tonumber(self.msgVersion[k]) == 0 then
                self.redPoint[k] = #(v);
            else
                self.redPoint[k] = #(v) + 1 - tonumber(self.msgVersion[k]);
            end
        else
            self.redPoint[k] = #(v);
        end
    end
end

function ChatBoxUIDataManager:RemoveEveentsDataByPlayerID(playerID)
    if not playerID then
        return
    end

    for k, v in pairs(self.eventsData) do
        local tmpList = {}
        for index, value in ipairs(v) do
            if value.userid == playerID then
                table.insert(tmpList,value)
            end
        end

        for kF, vF in pairs(tmpList) do
            for kS, vS in pairs(v) do
                if vF.userid == vS.userid then
                    table.remove(v, kS);
                    break;
                end
            end
        end

        local chatBoxUI = GetUIWindow("ChatBoxUI")
        if chatBoxUI and chatBoxUI:GetPrivateOpen() then
            chatBoxUI:OnClickPrivateChatListItem(nil, k);
        end
    end
end

function ChatBoxUIDataManager:AddChannelAllData(data)
    if not self.channelAll[data.channel] then
        self.channelAll[data.channel] = {};
    end
    table.insert(self.channelAll[data.channel], data);
    if #(self.channelAll[data.channel]) > 100 then
        table.remove(self.channelAll[data.channel], 1);
    end

    if not self.channelAll[BroadcastChannelType.BCT_All] then
        self.channelAll[BroadcastChannelType.BCT_All] = {};
    end
    table.insert(self.channelAll[BroadcastChannelType.BCT_All], data);
    if #(self.channelAll[BroadcastChannelType.BCT_All]) > 200 then
        table.remove(self.channelAll[BroadcastChannelType.BCT_All], 1);
    end
end

function ChatBoxUIDataManager:GetChannelData(channel)
    return self.channelAll[channel] or {};
end

function ChatBoxUIDataManager:GetEmojiSmallDTData()
    return TableDataManager:GetInstance():GetTable('EmojiSmall') or {};
end

function ChatBoxUIDataManager:GetEmojiBigDTData()
    return TableDataManager:GetInstance():GetTable('EmojiBig') or {};
end

return ChatBoxUIDataManager