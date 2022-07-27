NetCommonService = {};

NetCommonData = require('Net/NetCommonSDK/NetCommonData');
NetCommonMail = require('Net/NetCommonSDK/NetCommonMail');
NetCommonFriend = require('Net/NetCommonSDK/NetCommonFriend');
NetCommonChat = require('Net/NetCommonSDK/NetCommonChat');
NetCommonRank = require('Net/NetCommonSDK/NetCommonRank');
NetCommonRedPacket = require('Net/NetCommonSDK/NetCommonRedPacket');
NetCommonAttrib = require('Net/NetCommonSDK/NetCommonAttrib');
DKJson = require('Base/Json/dkjson')
AppsManager = nil;
AppsManagerState = 'CLOSED';
AppsManagerFlag = false;

MaxMailReqCount = 20;
MaxFriendReqCount = 20;

function NetCommonService:Init()
    if not AppsManager then
        self.iTime = 0;

        local data = {};
        data.userid = tostring(globalDataPool:getData("PlayerID"));

        self.sfriend = NetCommonFriend:Init(data);
        self.smail = NetCommonMail:Init(data);
        self.schat = NetCommonChat:Init(data);
        self.srank = NetCommonRank:Init(data);
        self.redPacket = NetCommonRedPacket:Init(data);
        self.attrit = NetCommonAttrib:Init(data);

        local _callbackMail = function(data)
            self:OnMailEventCallBack(data);
        end

        local _callbackFriend = function(data)
            self:OnFriendEvent(data);
        end

        local _callbackSession = function(data)
            self:OnSessionEvent(data);
        end

        local _callbackBroadcast = function(data)
            -- self:OnBroadcastEventCallBack(data);
        end

        local _callbackPushService = function(data)
            self:OnBroadcastEventCallBack(data);
        end

        local _callbackDreamNotice = function(data)
            self:OnDreamNoticeCallBack(data);
        end

        local _callbackDreamNoticeRedPacket = function(data)
            self:OnDreamNoticeRedPacketCallBack(data);
        end

        local config = NetCommonData.Config;

        local DecodeJsonCallback = function(callback)
            return function(data)
                local r, n, err = DKJson.decode(data);
                if not err and type(r) == 'table' then
                    callback(r);
                end
            end
        end

        AppsManager = CS.apps_core.AppsManager.Instance;
        if AppsManager then
            AppsManager.StateChanged = function(state)
                AppsManagerState = state:ToString();
                if AppsManagerState == 'CLOSED' then
                    AppsManagerFlag = true;
                end
                CS.UnityEngine.Debug.Log("Lua: State: " .. state:ToString())
            end
    
            if type(config.url) == 'string' and type(config.appid) == 'string' and type(data.userid) == 'string' and
                type(config.token) == 'string' then
                AppsManager:Init(config.url, config.appid, data.userid, config.token, true);
                AppsManager:xLuaOn('OnMailEvent', DecodeJsonCallback(_callbackMail));
                AppsManager:xLuaOn('OnFriendEvent', DecodeJsonCallback(_callbackFriend));
                AppsManager:xLuaOn('OnSessionEvent', DecodeJsonCallback(_callbackSession));
                AppsManager:xLuaOn('OnBroadcastEvent', DecodeJsonCallback(_callbackBroadcast));
                AppsManager:xLuaOn('DreamTalk', DecodeJsonCallback(_callbackPushService));
                AppsManager:xLuaOn('DreamNotice', DecodeJsonCallback(_callbackDreamNotice));
                AppsManager:xLuaOn('DreamNoticeRedPacket', DecodeJsonCallback(_callbackDreamNoticeRedPacket));
    
                self:InitCommonSDK();
            else
                derror('config : %s, userid : %s', DKJson.encode(config), data.userid);
            end
        end 
    else
        self:InitCommonSDK();
    end
end

function NetCommonService:InitCommonSDK()

    ChatBoxUIDataManager:GetInstance():ResetData();
    SocialDataManager:GetInstance():ResetData();

    globalTimer:AddTimer(1000, function()
        -- TODO 平台好友
        local platFriend = MSDKHelper:GetSameServerFriendListAddToGameFriendsList();
        if platFriend then
            for i = 1, #(platFriend) do
                local friendData = {
                    friendid = tostring(platFriend[i])
                };
                SocialDataManager:GetInstance():AddQWFriendData(friendData);
            end
        end

        NetCommonMail:CountMails(nil, MailState1, MailType, true);
        NetCommonMail:CountMails(nil, MailState2, MailType, false);
        NetCommonMail:GetMailPageV2(1, MaxMailReqCount, nil, MailState1, MailType, false);
        NetCommonFriend:GetFriendList();
        
        --拉取私聊会话可能会延迟 此处置上标记 在拉取成功时重置标记 在私聊相关处使用标记判断
        ChatBoxUIDataManager:GetInstance():SetSessionGetFinishFlag(false)
        NetCommonChat:GetSessionList()

        --初始化完成如果在酒馆查询一下红包
        local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');
        if houseUI and houseUI:IsOpen() then
            QueryRedPacket();
        end
    end, 1);
end

function NetCommonService:Update(time)
    if AppsManager then
        self.iTime = self.iTime + time;
        if self.iTime > 100 then
            self.iTime = 0;
            AppsManager:Update(0.1);
        end
    end
end

function NetCommonService:OnBroadcastEventCallBack(data)
    --
    local jsonData = data;
    if jsonData and jsonData.content then
        local chatBoxUI = WindowsManager:GetInstance():GetUIWindow('ChatBoxUI');
        if chatBoxUI then
            chatBoxUI:AddNotice(data);
            chatBoxUI:OnRefNormalList(nil);
        end
        SystemUICall:GetInstance():BarrageShow(jsonData);
    end

end

function NetCommonService:OnDreamNoticeCallBack(data)
    local jsonData = data;
    if not jsonData then
        return
    end

    if jsonData.braodCast and jsonData.braodCast > 0 then
        local broadData = TableDataManager:GetInstance():GetTableData("BroadCastTips", jsonData.broadId);
        if not broadData then
            return
        end
        local broadText = "";
        if jsonData.broadId == BroadCastTipsNameType.BCTNT_ZhuWei then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.acUserName2)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_DaZhongLeiTai then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.acsubStr, jsonData.acUserName2)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_DaShiLeiTai then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.acsubStr, jsonData.acUserName2)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_QieCuoShengLi then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.acUserName2)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_WaBaoAnJin then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.acUserName2)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_MoJunTongGuan then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.iParam1, jsonData.acUserName2)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_ZiYouTongGuan then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.iParam1, jsonData.acUserName2)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_GuoBan then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_DuoBaoPuTong_KaiQi or jsonData.broadId ==
            BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_KaiQi then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_JieShu or jsonData.broadId ==
            BroadCastTipsNameType.BCTNT_DuoBaoPuTong_JieShu or jsonData.broadId ==
            BroadCastTipsNameType.BCTNT_DuoBaoPuTong_ZhuGong or jsonData.broadId ==
            BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_ZhuGong then
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, jsonData.acUserName2)
            -- 如果是结束奖励, 调用全服侠客行底部的显示
            local bIsRoundEndNormalReward = (jsonData.broadId == BroadCastTipsNameType.BCTNT_DuoBaoPuTong_JieShu)
            local bIsRoundEndTopReward = (jsonData.broadId == BroadCastTipsNameType.BCTNT_DuoBaoZhongJi_JieShu)
            local uiItemBaseID = jsonData.iParam1 or 0
            local winPinball = GetUIWindow("PinballGameUI")
            if winPinball and winPinball.PinballServerPlayInst and (bIsRoundEndNormalReward or bIsRoundEndTopReward) and (uiItemBaseID > 0) then
                local strItemName = ItemDataManager:GetInstance():GetItemName(nil, uiItemBaseID)
                winPinball.PinballServerPlayInst:SetServerNotice(jsonData.acUserName1, strItemName, bIsRoundEndTopReward)
            end
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_LeiTaiKaiShi then
            broadText = string.format(broadData.TipsText)
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_XiaKeXingAnjin then
            broadText = nil
            local uiItemBaseID = jsonData.iParam1 or 0
            local strItemName = ItemDataManager:GetInstance():GetItemName(nil, uiItemBaseID)
            if strItemName and (strItemName ~= "") then
                broadText = string.format(broadData.TipsText, jsonData.acUserName1 or "", strItemName)
            end
        elseif jsonData.broadId == BroadCastTipsNameType.BCTNT_WanMeiAnJin then
			local strItemName = ItemDataManager:GetInstance():GetItemName(nil, jsonData.iParam1 or 0) or ""
            broadText = string.format(broadData.TipsText, jsonData.acUserName1, strItemName)
        end
        jsonData.content = broadText;
    end

    if jsonData.TvType and jsonData.content then
        if jsonData.TvType == SBCT_PAOMA then
            PlayerSetDataManager:GetInstance():AddSystemTipsData(jsonData.content);
        elseif jsonData.TvType == SBCT_DANMU then
            SystemUICall:GetInstance():BarrageShow(jsonData.content);
        elseif jsonData.TvType == SBCT_DENGLUCI then
            SystemUICall:GetInstance():BarrageLoginShow(jsonData);
        elseif jsonData.TvType == SBCT_DANMUJILU then
            local chatBoxUI = WindowsManager:GetInstance():GetUIWindow('ChatBoxUI');
            if chatBoxUI then
                chatBoxUI:AddNotice(jsonData);
                chatBoxUI:OnRefNormalList(nil);
            end
            SystemUICall:GetInstance():BarrageShow(jsonData.content);
        elseif jsonData.TvType == SBCT_CLEARONEPLAYERCHAT then
            for kF, vF in pairs(BroadcastChannelType) do
                local chatData = ChatBoxUIDataManager:GetInstance():GetChannelData(vF);
                if #(chatData) > 0 then
                    local tempD = {};
                    for kS, vS in pairs(chatData) do
                        if vS.id == tostring(jsonData.id) then
                            table.insert(tempD, vS);
                        end
                    end

                    for kF, vF in pairs(tempD) do
                        for kS, vS in pairs(chatData) do
                            if vF.id == vS.id then
                                table.remove(chatData, kS);
                                break
                            end
                        end
                    end
                end
            end
            local chatBoxUI = WindowsManager:GetInstance():GetUIWindow('ChatBoxUI');
            if chatBoxUI then
                chatBoxUI:OnRefSmallChatList();
                chatBoxUI:OnRefNormalList();
            end
            -- 清理一下私聊信息
            ChatBoxUIDataManager:GetInstance():RemoveEveentsDataByPlayerID(data.id);
        elseif jsonData.TvType == SBCT_SendRedTip then
            SystemUICall:GetInstance():BarrageRedPacketShow(jsonData.content);
        elseif jsonData.TvType == SBCT_SysTips then
            local chatBoxUI = WindowsManager:GetInstance():GetUIWindow('ChatBoxUI');
            if chatBoxUI then
                chatBoxUI:AddNotice(jsonData);
                chatBoxUI:OnRefNormalList(nil);
            end
        elseif jsonData.TvType == SBCT_PINBALLREWARD then
            LuaEventDispatcher:dispatchEvent("PINBALL_GET_DARKGOLD_REWARD", {
                ['text'] = jsonData.content or "",
                ['name'] = jsonData.acUserName1 or ""
            })
        end
    end
end

function NetCommonService:OnDreamNoticeRedPacketCallBack(data)
    MoneyPacketDataManager:GetInstance():InsertPacketData(data);
end

function NetCommonService:OnSessionEventCallBack(data)

    local playerID = globalDataPool:getData('PlayerID');
    local chatBoxSetting = GetConfig(tostring(playerID) .. '#ChatBoxSetting');
    local private = BroadcastChannelType.BCT_Private;
    if chatBoxSetting and (chatBoxSetting[private] == true or chatBoxSetting[tostring(private)] == true) then
        if data.userid ~= globalDataPool:getData('PlayerID') then
            return;
        end
    end

    if ChatBoxUIDataManager:GetInstance():HasEventsData(data) then
        return;
    end

    ChatBoxUIDataManager:GetInstance():AddEventsData(data);
    ChatBoxUIDataManager:GetInstance():SetRedPoint(data);
    local chatBoxUI = WindowsManager:GetInstance():GetUIWindow('ChatBoxUI');
    if chatBoxUI then
        local curSessid = chatBoxUI:GetCurSessionID();
        if chatBoxUI:GetPrivateOpen() and curSessid then
            ChatBoxUIDataManager:GetInstance():ResetRedPointBySessionID(curSessid);
            chatBoxUI:OnClickPrivateChatListItem(nil, curSessid);
        else
            -- chatBoxUI:SetCurSessionID(data.sessid);
            chatBoxUI:OnRefNewMsgUI(data);
            chatBoxUI:OnRefPrivateRedPointCount();
        end
    end
end

function NetCommonService:OnSessionEventCreateCallBack(data)

    local playerID = globalDataPool:getData("PlayerID");

    -- TODO 自己
    if data.userid == playerID then

        -- TODO 对方
    else
        local _callback = function()

            local bFriend = SocialDataManager:GetInstance():GetFriendDataByID(data.userid);
            local name = bFriend and 'FChat' or 'NChat';

            local session = {};
            session.version = 0;
            session.name = name;
            session.sessid = data.sessid;
            session.members = {data.userid, data.data};
            ChatBoxUIDataManager:GetInstance():AddSession(session);
        end

        SocialDataManager:GetInstance():QueryFriendInfo({tostring(data.userid)}, _callback);
    end
end

function NetCommonService:OnSessionEvent(data)
    if data.type == EventType.Publish then
        self:OnSessionEventCallBack(data);
    elseif data.type == EventType.Create then
        self:OnSessionEventCreateCallBack(data);
    end
end

function NetCommonService:OnFriendApply(data)

    if SocialDataManager:GetInstance():HasApplyData(data.friendid) then
        return;
    end

    local _callback = function()
        local friendServerData = SocialDataManager:GetInstance():GetOtherPlayerData(data.friendid);
        SocialDataManager:GetInstance():AddApplyData2(friendServerData);

        local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
        local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');

        if socialUI then
            socialUI:RefFriendRedPoint();
            if socialUI:IsApplyOpen() then
                socialUI:OnRefApplyUI();
            end
        end

        if houseUI then
            houseUI:RefFriendRedPoint();
        end
    end

    SocialDataManager:GetInstance():AddApplyData(data);
    SocialDataManager:GetInstance():QueryFriendInfo({tostring(data.friendid)}, _callback);
end

function NetCommonService:OnFriendAccept(data)

    local _callback = function()
        local friendServerData = SocialDataManager:GetInstance():GetOtherPlayerData(data.friendid);
        SocialDataManager:GetInstance():AddFriendData2(friendServerData);

        SocialDataManager:GetInstance():DelApplyDataByID(data.friendid);
        SocialDataManager:GetInstance():DelApplyDataByID2(data.friendid);

        local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
        local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI');

        if socialUI then
            socialUI:RefAnswerAddFriend(data.friendid, data.accept);
        end

        if houseUI then
            houseUI:RefFriendRedPoint();
        end
    end

    SocialDataManager:GetInstance():AddFriendData(data);
    SocialDataManager:GetInstance():QueryFriendInfo({tostring(data.friendid)}, _callback);
end

function NetCommonService:OnFriendDel(data)

    SocialDataManager:GetInstance():DelFriendDataByID(data.friendid);
    SocialDataManager:GetInstance():DelFriendDataByID2(data.friendid);

    local socialUI = WindowsManager:GetInstance():GetUIWindow('SocialUI');
    if socialUI then
        socialUI:OnRefFriendUI();
    end
end

function NetCommonService:OnFriendEvent(data)
    if data.friend_event == FriendEventType.FE_Apply then
        self:OnFriendApply(data);
    elseif data.friend_event == FriendEventType.FE_Accept then
        if data.accept then
            self:OnFriendAccept(data);
        else

        end
    elseif data.friend_event == FriendEventType.FE_Deleted then
        self:OnFriendDel(data);
    end
end

function NetCommonService:OnMailEventCallBack(data)
    if data.mail_event == MailEventType.ME_NewMail then
        if SocialDataManager:GetInstance():HasMailData(data.id) then
            return;
        end

        NetCommonMail:GetMail(data.id);
    end
end

return NetCommonService;
