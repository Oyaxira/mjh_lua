HttpHelper = require('Net/NetHttpHelper');
NetCommonData = {};
NetCommonData.Config = {};

-- 邮件状态定义
MailState = {
    Any             = -1,  -- 任意状态
    New             = 0,   -- 未读未收		From: -
    Read            = 1,   -- 已读未收		From: 新邮件
    Received        = 2,   -- 未读已收		From: 新邮件, 已读
    ReadReceived    = 3,   -- 已读已收		From: 新邮件, 已读, 已收取
}

-- 聊天频道
BroadcastChannelType = {
    BCT_Null = 0,
    BCT_World = 1,     --  
    BCT_Script = 2,     --  
    BCT_Town = 3,     -- 
    BCT_System = 4,     --
    BCT_Private = 5,    --
    BCT_All = 6,     --  
}

MailType = {}
for i = 0, SMAT_END - 1 do
    if i ~= SMAT_TREASUREMAZE then
        table.insert(MailType, i);
    end
end

MailState1 = {}
table.insert(MailState1, MailState.New);
table.insert(MailState1, MailState.Read);
table.insert(MailState1, MailState.Received);
table.insert(MailState1, MailState.ReadReceived);

MailState2 = {}
table.insert(MailState2, MailState.New);

local DKJson = require("Base/Json/dkjson")

function SetToken(kRetData)
    if kRetData.acJson then
        local jsonData = DKJson.decode(kRetData.acJson);
        if jsonData then
            NetCommonData.Config.appKey = jsonData.clientkey;
            NetCommonData.Config.token = jsonData.token;
            NetCommonData.Config.appid = jsonData.appid;
            NetCommonData.Config.url = jsonData.url;

            NetCommonService:Init();
        end
    end
end

CheckTokenTimer = nil
function CheckToken()
    if (CheckTokenTimer) then
        globalTimer:RemoveTimer(CheckTokenTimer)
        CheckTokenTimer = nil
    end
    CheckTokenTimer = globalTimer:AddTimer(5000, function()
        if not NetCommonData.Config.token then
            SendQueryPublicJWT();
        end
    end, -1);
end

RefreshCommonTimer = nil;
function RefreshCommonData()
    if (RefreshCommonTimer) then
        globalTimer:RemoveTimer(RefreshCommonTimer)
        RefreshCommonTimer = nil
    end
    RefreshCommonTimer = globalTimer:AddTimer(1000 * 60 * 5, function()
        NetCommonData.Config.token = nil;
    end, -1);
end

return NetCommonData;