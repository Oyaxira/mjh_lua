local dkJson = require("Base/Json/dkjson")
local HttpHelper = {}
local lastConnetTime = 0

-- 内网登录网址
local PublishInLineUrl = {
    ['ValidateUrl'] = 'http://192.168.0.23:9901/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'http://192.168.0.23:9901/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'http://192.168.0.23:9901/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'http://192.168.0.23:9901/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'http://192.168.0.23:9901/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'http://192.168.0.23:9901/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://testgm.op.dianhun.cn/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://hktest.itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] =  "http://192.168.110.230:6266/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://hktest.itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网测试区登录网址
local PublishTestAreaOutLineUrl = {
    ['ValidateUrl'] = 'https://test.wdxk.qq.com:4001/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'https://test.wdxk.qq.com:4001/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'https://test.wdxk.qq.com:4001/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'https://test.wdxk.qq.com:4001/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'https://test.wdxk.qq.com:4001/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'https://test.wdxk.qq.com:4001/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://hktest.itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网正式区登录网址
local PublishOutLineUrl = {
    ['ValidateUrl'] = 'https://login.wdxk.qq.com:4001/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'https://login.wdxk.qq.com:4001/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'https://login.wdxk.qq.com:4001/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'https://login.wdxk.qq.com:4001/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'https://login.wdxk.qq.com:4001/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'https://login.wdxk.qq.com:4001/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网Taptap测试区登录网址
local PublishTaptapLineUrl = {
    ['ValidateUrl'] = 'https://test.wdxk.qq.com:4002/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'https://test.wdxk.qq.com:4002/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'https://test.wdxk.qq.com:4002/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'https://test.wdxk.qq.com:4002/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'https://test.wdxk.qq.com:4002/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'https://test.wdxk.qq.com:4002/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网调试登录网址
local DebugOutLineUrl = {
    ['ValidateUrl'] = 'http://139.199.74.76:4010/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'http://139.199.74.76:4010/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'http://139.199.74.76:4010/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'http://139.199.74.76:4010/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'http://139.199.74.76:4010/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'http://139.199.74.76:4010/api/v1/json/LoginService.QueryUsers',
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网审核网址
local ExamOutLineUrl = {
    ['ValidateUrl'] = 'https://test.wdxk.qq.com:4003/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'https://test.wdxk.qq.com:4003/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'https://test.wdxk.qq.com:4003/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'https://test.wdxk.qq.com:4003/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'https://test.wdxk.qq.com:4003/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'https://test.wdxk.qq.com:4003/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网A级平台测试压测网址
local APlatPresureTestUrl = {
  ['ValidateUrl'] = 'https://test.wdxk.qq.com:4004/api/v1/json/LoginService.Login',
  ['ValidateUrl1'] = 'https://test.wdxk.qq.com:4004/api/v1/json/LoginService.Login',
  ['SelectUrl'] = 'https://test.wdxk.qq.com:4004/api/v1/json/LoginService.Select',
  ['ServerListUrl'] = 'https://test.wdxk.qq.com:4004/api/v1/json/LoginService.ServerList',
  ['LeaveQueueUrl'] = 'https://test.wdxk.qq.com:4004/api/v1/json/LoginService.LeaveQueue',
  ['QueryUsersUrl'] = 'https://test.wdxk.qq.com:4004/api/v1/json/LoginService.QueryUsers',
  ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
  ['QuestionUrl'] = "",
  ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
  ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
  ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
  ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
  ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网灵波压测测试压测网址
local LingboPresureTestUrl = {
  ['ValidateUrl'] = 'https://test.wdxk.qq.com:4005/api/v1/json/LoginService.Login',
  ['ValidateUrl1'] = 'https://test.wdxk.qq.com:4005/api/v1/json/LoginService.Login',
  ['SelectUrl'] = 'https://test.wdxk.qq.com:4005/api/v1/json/LoginService.Select',
  ['ServerListUrl'] = 'https://test.wdxk.qq.com:4005/api/v1/json/LoginService.ServerList',
  ['LeaveQueueUrl'] = 'https://test.wdxk.qq.com:4005/api/v1/json/LoginService.LeaveQueue',
  ['QueryUsersUrl'] = 'https://test.wdxk.qq.com:4005/api/v1/json/LoginService.QueryUsers',
  ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
  ['QuestionUrl'] = "",
  ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
  ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
  ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
  ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
  ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- 外网CJ测试网址
local CJTestUrl = {
  ['ValidateUrl'] = 'https://test.wdxk.qq.com:4006/api/v1/json/LoginService.Login',
  ['ValidateUrl1'] = 'https://test.wdxk.qq.com:4006/api/v1/json/LoginService.Login',
  ['SelectUrl'] = 'https://test.wdxk.qq.com:4006/api/v1/json/LoginService.Select',
  ['ServerListUrl'] = 'https://test.wdxk.qq.com:4006/api/v1/json/LoginService.ServerList',
  ['LeaveQueueUrl'] = 'https://test.wdxk.qq.com:4006/api/v1/json/LoginService.LeaveQueue',
  ['QueryUsersUrl'] = 'https://test.wdxk.qq.com:4006/api/v1/json/LoginService.QueryUsers',
  ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
  ['QuestionUrl'] = "",
  ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
  ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
  ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
  ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
  ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
}

-- IOS提审服测试网址
local IOSExamUrl = {
    ['ValidateUrl'] = 'https://login.wdxk.qq.com:4003/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'https://login.wdxk.qq.com:4003/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'https://login.wdxk.qq.com:4003/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'https://login.wdxk.qq.com:4003/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'https://login.wdxk.qq.com:4003/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'https://login.wdxk.qq.com:4003/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
  }

  -- 外网压测服地址
  local PublishTestUrl = {
    ['ValidateUrl'] = 'http://81.69.152.191:4001/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'http://81.69.152.191:4001/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'http://81.69.152.191:4001/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'http://81.69.152.191:4001/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'http://81.69.152.191:4001/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'http://81.69.152.191:4001/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
  }

    -- 外网掌门对决专用
  local PublishZMDJServer = {
    ['ValidateUrl'] = 'https://login.wdxk.qq.com:4004/api/v1/json/LoginService.Login',
    ['ValidateUrl1'] = 'https://login.wdxk.qq.com:4004/api/v1/json/LoginService.Login',
    ['SelectUrl'] = 'https://login.wdxk.qq.com:4004/api/v1/json/LoginService.Select',
    ['ServerListUrl'] = 'https://login.wdxk.qq.com:4004/api/v1/json/LoginService.ServerList',
    ['LeaveQueueUrl'] = 'https://login.wdxk.qq.com:4004/api/v1/json/LoginService.LeaveQueue',
    ['QueryUsersUrl'] = 'https://login.wdxk.qq.com:4004/api/v1/json/LoginService.QueryUsers',
    ['NoticeUrl'] = "http://gm.17m3.com/wdxk/%s_%s_%s.json",
    ['QuestionUrl'] = "",
    ['CriditUrl'] = "https://gamecredit.qq.com/static/games/index.htm",
    ['GetFriendList'] = "https://itop.qq.com/v2/friend/friend_list",
    ['DiscussUrl'] = "https://comment-api.wdxk.qq.com/api",
    ['ReportAchievementsUrl'] = "https://hktest.itop.qq.com/v2/acvm/report",
    ['GetRecallFriendList'] = "https://itop.qq.com/v2/friend/recall_friends_list",
  }
  

function HttpHelper:HttpGet(url, callback)
    if not url then
        return
    end

    CS_Coroutine.start(function()
        local webRequest = CS.UnityEngine.Networking.UnityWebRequest.Get(url);
        webRequest.timeout = 10
        coroutine.yield(webRequest:SendWebRequest())
        if webRequest.isHttpError or webRequest.isNetworkError then
            dprint(webRequest.error)
            if callback then
                callback({error = webRequest.error})
            end
        else 
            dprint(webRequest.downloadHandler.text)
            if callback then
                callback({data = webRequest.downloadHandler.text})
            end
        end
    end)	
    
end

function HttpHelper:HttpPost(url, data, callback)
    if not url or not data then
        return
    end

    CS_Coroutine.start(function()
        local webRequest = CS.UnityEngine.Networking.UnityWebRequest(url, "POST")
        webRequest.timeout = 10
        webRequest.uploadHandler = CS.UnityEngine.Networking.UploadHandlerRaw(data)
        webRequest.downloadHandler = CS.UnityEngine.Networking.DownloadHandlerBuffer()
        webRequest:SetRequestHeader("Content-Type", "application/json")
        coroutine.yield(webRequest:SendWebRequest())
        if webRequest.isHttpError or webRequest.isNetworkError then
            dprint(webRequest.error)
            if callback then
                callback({error = webRequest.error})
            end
        else 
            dprint(webRequest.downloadHandler.text)
            if callback then
                callback({data = webRequest.downloadHandler.text})
            end
        end
    end)	
    
end

function HttpHelper:HttpPost2(url, data, callback, header)
    if (not url) or (not data) or (not header) then
        dprint('url or data must be not nil');
        return;
    end

    CS_Coroutine.start(function()
        local webRequest = CS.UnityEngine.Networking.UnityWebRequest(url, "POST");
        webRequest.timeout = 20;
        webRequest.uploadHandler = CS.UnityEngine.Networking.UploadHandlerRaw(dkJson.encode(data));
        webRequest.downloadHandler = CS.UnityEngine.Networking.DownloadHandlerBuffer();
        webRequest.certificateHandler = CS.GameApp.BypassCertificate(); --忽略证书
        for k, v in pairs(header) do
            if k == "" or v == "" or k == nil or v == nil then
                derror('ERROR HttpPost2 : url:' .. url .. ' K :' .. tostring(k).." v :"..tostring(v));
            else
                if DEBUG_MODE then
                    -- dwarning('Quest HttpPost2 : url:' .. url .. ' K :' .. tostring(k).." v :"..tostring(v));
                end
                webRequest:SetRequestHeader(k, v);
            end
        end

        coroutine.yield(webRequest:SendWebRequest());

        if webRequest.isHttpError or webRequest.isNetworkError then
            -- derror('ERROR HttpPost2 : ' .. webRequest.error);
            if callback then
                -- callback({error = webRequest.error});
            end
        else 
            if callback then
                local text = dkJson.decode(webRequest.downloadHandler.text);
                callback(text.data, text.code, text.error);
            end
        end
    end)	
end

function HttpHelper:CheckPublicLoginResult(RetCode, RetInfo)
    local bSuc = false
    local strErrorCode = string.format("(%s)", tostring(RetCode))
    if RetCode == SPLR_OK then
        bSuc = true
    elseif RetCode == SPLR_Unavailable then
        -- SystemUICall:GetInstance():WarningBox("服务不可用")
        SystemUICall:GetInstance():WarningBox("江湖酒馆停服维护中，开服信息敬请查看游戏公告。" .. strErrorCode)
    elseif RetCode == SPLR_NotExists then
        SystemUICall:GetInstance():WarningBox("大侠请确认账号或密码是否正确。" .. strErrorCode)
    elseif RetCode == SPLR_TokenWrong then
        local strMsg = "当前登录发生错误，大侠请尝试点击确定按钮重新登录账号。" .. strErrorCode
        local funcCallback = function()
            local win = GetUIWindow("LoginUI")
            if not win then
                return win
            end
            win:OnClick_ChangeAccountButton()
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, funcCallback, {confirm = true}})
    elseif RetCode == SPLR_QueueRequire then
        -- 处理排队提示
        if RetInfo and RetInfo.queueing then
            self:HandleAccountQueueing(RetInfo.queueing)
        else
            SystemUICall:GetInstance():WarningBox("正在排队进入江湖酒馆，大侠请耐心等待。" .. strErrorCode)
        end
    elseif RetCode == SPLR_Freezing then
        -- 处理账号冻结提示
        if RetInfo and RetInfo.freezing then
            self:HandleAccountFreezing(RetInfo.freezing)
        else
            SystemUICall:GetInstance():WarningBox("当前账号已冻结，大侠请联系官方Q群管理员处理。" .. strErrorCode)
        end
    elseif RetCode == SPLR_WhiteListOnly then
        -- SystemUICall:GetInstance():WarningBox("无登录授权")
        SystemUICall:GetInstance():WarningBox("江湖酒馆尚未正式开业，开服信息请查看游戏公告。" .. strErrorCode)
    elseif RetCode == SPLR_Forbidden then
        SystemUICall:GetInstance():WarningBox("当前登录异常，大侠请联系官方Q群管理员处理。" .. strErrorCode)
    elseif RetCode == SPLR_ShutDown then
        SystemUICall:GetInstance():WarningBox("江湖酒馆停服维护中，开服信息请查看游戏公告。" .. strErrorCode)
    elseif RetCode == SPLR_Blocked then
        -- SystemUICall:GetInstance():WarningBox("无登录权限")
        SystemUICall:GetInstance():WarningBox("江湖酒馆尚未正式开业，开服信息请查看游戏公告。" .. strErrorCode)
    elseif RetCode == SPLR_ZoneLimit then
        SystemUICall:GetInstance():WarningBox("当前大区匹配错误，大侠请选择正确的服务器。" .. strErrorCode)
    elseif RetCode > SPLR_OK and RetCode < 1000 then
        SystemUICall:GetInstance():WarningBox(string.format("登录错误，错误码：%d，大侠请联系官方Q群管理员处理。", RetCode))
    elseif RetCode == SPLR_FirstServerLimit then
        -- 1011 对应 ErrLogin.FirstServerLimit, 先客户端写死热更到外网, 之后服务器那边定义了枚举再替换这个值
        local msg = "当前服务器爆满暂时无法容纳新进大侠，请选择其他服务器。" .. strErrorCode
        -- if JungCurCannelIDForOueExtraInfo() then
        --     msg = msg .. "\n加入官方Q群1061471593, 获取最新放号消息。"
        -- end
        SystemUICall:GetInstance():WarningBox(msg)
    else
        SystemUICall:GetInstance():WarningBox("未知错误" .. strErrorCode)
    end

    RemoveWindowImmediately("ChatBoxUI")

    -- 关闭登录等待
    if bSuc ~= true then
        UPSMgr:ReportLoginfail(3,RetCode)

        local winLogin = GetUIWindow("LoginUI")
        if winLogin then
            winLogin:SetWaitingAnimState(false)
        end
    end

    return bSuc
end

-- 获取时间字符串
function HttpHelper:GetTimeString(lStamp)
    if not lStamp then
        return ""
    end
    local strMsg = ""
    local lMinOffset = 60
    local lHourOffset = lMinOffset * 60
    local lDayOffset = lHourOffset * 24

    if lStamp > lDayOffset then
        local iDay = math.floor(lStamp / lDayOffset)
        strMsg = strMsg .. string.format("%d天", iDay)
        lStamp = lStamp - iDay * lDayOffset
    end

    if lStamp > lHourOffset then
        local iHour = math.floor(lStamp / lHourOffset)
        strMsg = strMsg .. string.format("%d时", iHour)
        lStamp = lStamp - iHour * lHourOffset
    end

    if lStamp > lMinOffset then
        local iMin = math.floor(lStamp / lMinOffset)
        strMsg = strMsg .. string.format("%d分", iMin)
        lStamp = lStamp - iMin * lMinOffset
    end

    if lStamp > 0 then
        strMsg = strMsg .. string.format("%d秒", lStamp)
    end

    return strMsg
end

-- 开启Select信息定时刷新
function HttpHelper:OpenServerSelectAutoUpdate(uiWaitTime)
    if self.iServerSelectAutoUpdateTimer then
        self:CloseServerSelectAutoUpdate()
    end
    -- 一次性计时器, 再次开启留给select再次返回排队/冻结错误码的时候
    self.iServerSelectAutoUpdateTimer = globalTimer:AddTimer(uiWaitTime or 4000, function()
        local zone = tostring(GetConfig("LoginZone"))
	    local strServerKey = string.format("LoginServer_%s", tostring(zone))
        local server = tostring(GetConfig(strServerKey))
        local bIsInLoginScene = IsWindowOpen("LoginUI")
        if (bIsInLoginScene ~= true) 
        or (not zone) or (zone == "")
        or (not server) or (server == "") then
            return
        end
        HttpHelper:SelectPublicLoginServer(zone, server)
	end)
end

-- 关闭Select信息定时刷新
function HttpHelper:CloseServerSelectAutoUpdate()
    if not self.iServerSelectAutoUpdateTimer then
        return
    end
    -- globalTimer:RemoveTimerNextFrame(self.iServerSelectAutoUpdateTimer)
    globalTimer:RemoveTimer(self.iServerSelectAutoUpdateTimer)
    self.iServerSelectAutoUpdateTimer = nil
end

-- 离开排队
function HttpHelper:DoLeaveQueue(token)
    if (not token) or (token == "") then
        return
    end
    local kInfo = {["token"] = token}
    local strInfo = dkJson.encode(kInfo)
    local serverLoginConfig = self:GetLoginUrlConfig()
    self:HttpPost(serverLoginConfig.LeaveQueueUrl, strInfo)
end

-- 处理排队提示
function HttpHelper:HandleAccountQueueing(kQueueingInfo)
    if not kQueueingInfo then
        return
    end
    -- message QueueingInfo {
    --     optional int32 position = 1;    // 等待位置
    --     optional int32 countdown = 2;   // 预估排队时间秒
    -- }
    local iPosition = kQueueingInfo.position or 0
    local lCountDown = kQueueingInfo.countdown or 0
    local content = {
        ['title'] = "排队中，请稍后",
        ['text'] = string.format("您当前排在第%d位\n预计等待时间: %s", iPosition, self:GetTimeString(lCountDown)),
        ['rightBtnText'] = "离开排队",
    }
    local callback = function()
        HttpHelper:CloseServerSelectAutoUpdate()
        HttpHelper:DoLeaveQueue(globalDataPool:getData("LoginValidateToken"))
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback, {confirm = true, cancel = false, close = false}, bRefreshSoon = true})

    -- 开启定时刷新
    -- 刷新时间根据实际排队人数做一个梯度
    local uiWaitTime = nil
    if iPosition > 1000 then
        uiWaitTime = 10000
    elseif iPosition > 500 then
        uiWaitTime = 5000
    else
        uiWaitTime = 3000
    end
    HttpHelper:OpenServerSelectAutoUpdate(uiWaitTime)
end

-- 处理账号冻结提示
function HttpHelper:HandleAccountFreezing(KFreezingInfo)
    if not (KFreezingInfo and KFreezingInfo.expired) then
        return
    end
    -- message FreezeInfo {
    --     optional int64 expired = 1; // 冻结截止时间(-1代表永久冻结)
    --     optional string reason = 2; // 冻结原因
    -- }
    local lStopFreeze = KFreezingInfo.expired
    local strReason = KFreezingInfo.reason

    local strMsg = nil
    if lStopFreeze == -1 then
        strMsg = "您的账号已被永久冻结"
    else
        local lDelta = lStopFreeze - os.time()
        if lDelta < 0 then
            lDelta = 0
        end
        strMsg = string.format("您的账号已被冻结，预计%s后解除", self:GetTimeString(lDelta))
    end
    
    if strReason and (strReason ~= "") then
        strMsg = (strMsg or "") .. "\n冻结原因: " .. strReason
    end

    local callback = function()
        HttpHelper:CloseServerSelectAutoUpdate()
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, callback, {confirm = true, cancel = false, close = false}})

    -- 开启定时刷新
    HttpHelper:OpenServerSelectAutoUpdate()
end

-- http请求错误提示
function HttpHelper:HandleHttpRequestError(strError, callback)
    local strMsg = "网络波动问题，请稍后再尝试登录。"
    -- 分支特殊处理, 2020/11/4 08:50 前, 提示：江湖酒馆尚未正式开业，开服信息请留意官方公告。
    local uiCurTimeStamp = os.time()
    local uiGameOpenTimeStamp = os.time({year = 2020, month = 11, day = 4, hour = 8, min = 50})
    if uiCurTimeStamp <= uiGameOpenTimeStamp then
        strMsg = "江湖酒馆尚未正式开业，开服信息请留意官方公告。"
    end
    -- 分支特殊处理结束
    if strError and (strError ~= "") then
        strMsg = strMsg .. "\n错误信息: " .. tostring(strError)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.HTTP_LOGIN_NET_ERROR, strMsg, callback})
end

function HttpHelper:PublicLoginValidate(PushJsonData)
    local serverLoginConfig = self:GetLoginUrlConfig()
    if (self.isReserve == nil) then
      self.isReserve = false
    else
      self.isReserve = not self.isReserve
    end
    
    local url = serverLoginConfig.ValidateUrl
    if (self.isReserve == true) then
      url = serverLoginConfig.ValidateUrl1
    end
    -- local urlSplit = string.split(url,':')
    -- local domain = string.sub(urlSplit[2],3,-1)
    -- local domainArray = DRCSRef.HttpDns.GetAddrByName(domain)
    -- if  (domainArray ~= nil) and (domainArray ~= "0;0") then
    --     local domaintrans = string.split(domainArray,';')[1]
    --     local urlTrans = urlSplit[1]..'://'..domaintrans..':'..urlSplit[3]
    --     --SystemTipManager:GetInstance():AddPopupTip(url..'\n'..domainArray..'\n'..urlTrans)
    --     url = urlTrans
    -- end
    self:HttpPost(url, PushJsonData, function(ret)
        if ret.data then
            local rettable = dkJson.decode(ret.data)
            if self:CheckPublicLoginResult(rettable.code) then
                local validatetable = rettable.data
                if validatetable and validatetable.id and validatetable.token then
                    globalDataPool:setData("PlayerID", validatetable.id, true)
                    globalDataPool:setData("LoginValidateToken", validatetable.token, true)
                    globalDataPool:setData("ThirdOpenId", validatetable.thirdOpenId, true)
                    SetConfig("ThirdOpenId", validatetable.thirdOpenId)
                    self:GetPublicLoginServerList() 
                    
                    globalTimer:AddTimer(100,function() 
                        local winLogin = GetUIWindow("LoginUI")
                        if winLogin then
                            winLogin:SetWaitingAnimState(false)
                        end
                    end)
                else
                    SystemUICall:GetInstance():WarningBox("验证数据不存在")
                end
            end
        else
            self:HandleHttpRequestError(ret.error, function ()
                self:PublicLoginValidate(pushJsonData)
            end)
        end
    end)
end

--从登陆服获取好友信息 
function HttpHelper:GetPublicLoginFriendInfoList(msdkFriendOpenidList,callback)
    local strToken = globalDataPool:getData("LoginValidateToken")
    if (not strToken) or (strToken == "") then
        return
    end
    local loginUrlConfig = HttpHelper:GetLoginUrlConfig()
    local kJsonData = {
        ["openIdList"] = msdkFriendOpenidList,
        ["osList"] = {1,2},
        ["token"] = strToken,
    }
    local kPushJsonData = dkJson.encode(kJsonData)
    dprint("从登录服请求好友信息")
    HttpHelper:HttpPost(loginUrlConfig.QueryUsersUrl, kPushJsonData, function(ret)
        if (ret == nil or ret.data == nil ) then
            dprint("从登陆服获取好友信息返回nil")
            derror("从登陆服获取好友信息返回nil")
            return 
        end
        dprint("http login friend:"..ret.data)
        local resultData = dkJson.decode(ret.data)
        if (resultData == nil) then
            dprint("从登陆服获取好友信息返回空字符串")
            derror("从登陆服获取好友信息返回空字符串")
            return
        end
        if (resultData.data == nil or (resultData.data).users == nil ) then
            dprint("从登陆服获取好友信息有误")
            derror("从登陆服获取好友信息有误")
            return
        end
        local usersList = (resultData.data).users
        if callback ~= nil then
            callback(usersList)
        end
    end)
    
end

function HttpHelper:GetPublicLoginServerList(funcOnEndGet)
    local LoginValidateToken = globalDataPool:getData("LoginValidateToken")
    if not LoginValidateToken or LoginValidateToken == '' then
        SystemUICall:GetInstance():WarningBox("非法获取登录列表")
        return
    end

    local QueryServer = {token = LoginValidateToken}
    local QueryJson = dkJson.encode(QueryServer)
    local serverLoginConfig = self:GetLoginUrlConfig()
    self:HttpPost(serverLoginConfig.ServerListUrl, QueryJson, function(ret)
        if ret.data then
            local result = dkJson.decode(ret.data)          
            if self:CheckPublicLoginResult(result.code) then
                local serverlist = {}
                for _, zoneinfo in ipairs(result.data.zoneList or {}) do
                    local zone = zoneinfo.zone
                    local servers = zoneinfo.servers
                    table.insert(serverlist, {
                        zone = tostring(zone),
                        zoneName = zoneinfo.zoneName,
                        servers = {}
                    })

                    if servers then                      
                        for index,serverinfo in ipairs(servers) do
                            table.insert(serverlist[#serverlist].servers, serverinfo)
                        end
                    else
                        SystemUICall:GetInstance():WarningBox('大区:'..zone..',服务列表拉取失败')
                    end
                end            

                globalDataPool:setData("LoginServerList", serverlist, true)

                -- 设置服务器分组
                self:SetServerListGroup(serverlist)

                -- 如果本地配置为空，那么先设置一个
                -- 正常情况下, 在上面设置服务器分组时, 会在推荐服务器中随机设置一个服务器
                -- 所以一般一下逻辑[begin-end]是走不到的, 是为了容错
                ---------------------[begin]-------------------------
                local lastChooseZone = GetConfig("LoginZone")
                local lastChooseServer = nil
                local lastChooseServerName = nil
                if lastChooseZone then
                    local strServerKey = string.format("LoginServer_%s", tostring(lastChooseZone))
                    local strServerNameKey = string.format("LoginServerName_%s", tostring(lastChooseZone))
                    lastChooseServer = GetConfig(strServerKey)
                    lastChooseServerName = GetConfig(strServerNameKey)
                end

                if(serverlist and next(serverlist) and (not lastChooseZone or not lastChooseServer or not lastChooseServerName)) then
                    local strTarZone, strTarServer, strTarServerName = nil, nil, nil
                    local bFindMyServer = false
                    for i, zoneData in ipairs(serverlist) do
                        strTarZone = zoneData.zone
                        for j, serverData in ipairs(zoneData.servers or {}) do
                            strTarServer = serverData.server
                            strTarServerName = serverData.serverName
                            for k, kTagsData in pairs(serverData.userTags or {}) do
                                if (kTagsData.name == "PlatName") 
                                and kTagsData.value and (kTagsData.value ~= "") then
                                    bFindMyServer = true
                                    break
                                end
                            end
                            if bFindMyServer then break end
                        end
                        if bFindMyServer then break end
                    end
                    if strTarZone and strTarServer and strTarServerName then
                        SetConfig("LoginZone", strTarZone)
                        local strServerKey = string.format("LoginServer_%s", tostring(strTarZone))
                        local strServerNameKey = string.format("LoginServerName_%s", tostring(strTarZone))
                        SetConfig(strServerKey, strTarServer)
                        SetConfig(strServerNameKey, strTarServerName)
                    end
                end
                ---------------------[end]-------------------------
                
                if funcOnEndGet ~= nil then
                    funcOnEndGet()
                else
                    if IS_RECONNECT  == true then
                        Send_EnterGame()
                    else
                        -- 打开登陆界面
                        local LoginUI = GetUIWindow("LoginUI")
                        if LoginUI then
                            LoginUI:UpdateServerNode()
                            LoginUI:FreshFriendInfo()
                            LoginUI:AutoLoginGameServer()
                        end
                    end
                end
                --self:SelectPublicLoginServer(DEFAULT_SERVERINDEX,DEFAULT_SERVERNAME)
            end
        else
            self:HandleHttpRequestError(ret.error, function ()
                self:GetPublicLoginServerList(funcOnEndGet)
            end)
        end
    end)
end

function HttpHelper:SetServerListGroup(serverlist)
    if not serverlist then
        return
    end
    -- 大区排序函数
	local funcSortZone = function(a,b)
		return a.zone < b.zone
	end

	-- 服务器列表排序函数, 根据server字段, 
	-- 数字排序优先, 其次按字典顺序排序
	local funcSortServer = function(a, b)
		local strIDA = a and a.server or 0
		local strIDB = a and b.server or 0
        local iA = tonumber(strIDA or 0)
        local iB = tonumber(strIDB or 0)
        if iA and iB then
            return iA < iB
        elseif not iA then
            return false
        elseif not iB then
            return true
        end
        return a < b
	end
	
	-- 获取此服务器上的账户名
	local funcGetUserName = function(kServer)
		if (not kServer) or (not kServer.userTags) then
			return
		end
		for index, kTagsData in pairs(kServer.userTags) do
			if kTagsData.name == "PlatName" then
				return (kTagsData.value == "") and STR_ACCOUNT_DEFAULT_NAME or kTagsData.value
			end
		end
	end

	-- 检查是否是新服务器
	local funcGetServerRegTag = function(kServer)
		if (not kServer) or (not kServer.svrTags) then
			return "0"
		end
		for index, kTagsData in pairs(kServer.svrTags) do
			if kTagsData.name == "RegState" then
				return kTagsData.value
			end
		end
		return "0"
	end

    -- 玩家是有有自己选择过服务器
    local strLastChooseZone = GetConfig("LoginZone")
    local strLastChooseServer = nil
    if strLastChooseZone then
        local strServerKey = string.format("LoginServer_%s", tostring(strLastChooseZone))
        strLastChooseServer = GetConfig(strServerKey)
    end
    local bHasSelfChosenServer = (strLastChooseServer ~= nil) and (strLastChooseServer ~= "")

    -- 将要默认设置的服务器
    local kDefaultSetServer = nil

	-- 将服务器范围两部分: 玩家创建过角色的, 玩家没有进入过的, 一行X个为一组
	local akMyServerGroups, akOtherServerGroups = {}, {[1]={}}  -- akOtherServerGroups中, 1留给标题
	local akStateSortNewServerGroups = {}  -- 根据服务器状态分类的新状态服务器列表组
	local akStateSortNormalServerGroups = {}  -- 根据服务器状态分类的正常状态服务器列表组
	local iMySvrRowCount, iOtherSvrRowCount = SERVERLIST_ROW_MAX_COUNT, SERVERLIST_ROW_MAX_COUNT
	local bHasMySvrTitle = false
    local iMyServerCount, iAllServerCount = 0, 0
	table.sort(serverlist, funcSortZone)
	for zoneIndex, kZone in ipairs(serverlist) do
		-- 将大区下的服务器列表按服务器状态排序
		table.sort(kZone.servers, funcSortServer)
		for index, kServer in ipairs(kZone.servers or {}) do
			iAllServerCount = iAllServerCount + 1
			local kServerInfoPack = {
				['zone'] = kZone,
				['server'] = kServer,
			}
			-- 提出带有"新"标签的服务器
			local eSvrRegTag = funcGetServerRegTag(kServer)
			local eCurState = kServer.state or SERVER_STATE.Stopped
			if eSvrRegTag == SERVER_TAG.NewSvr then
				if not akStateSortNewServerGroups[eCurState] then
					akStateSortNewServerGroups[eCurState] = {}
				end
				akStateSortNewServerGroups[eCurState][#akStateSortNewServerGroups[eCurState] + 1] = kServerInfoPack
			-- 状态为 正常 的服务器, 按负载状态分类
			elseif eSvrRegTag == SERVER_TAG.Normal then
				if not akStateSortNormalServerGroups[eCurState] then
					akStateSortNormalServerGroups[eCurState] = {}
				end
				akStateSortNormalServerGroups[eCurState][#akStateSortNormalServerGroups[eCurState] + 1] = kServerInfoPack
			end
			-- 如果这个服务器玩家有进行创角, 加入 "我的服务器"
			kServer.usrName = funcGetUserName(kServer)
			if kServer.usrName then
				iMyServerCount = iMyServerCount + 1
				-- 如果没有标题, 先插入标题
				if not bHasMySvrTitle then
					bHasMySvrTitle = true
					akMyServerGroups[#akMyServerGroups + 1] = {
						['type'] = 'TagMyServer',
					}
				end
				if iMySvrRowCount >= SERVERLIST_ROW_MAX_COUNT then
					iMySvrRowCount = 0
					akMyServerGroups[#akMyServerGroups + 1] = {
						['type'] = 'ServerGroup',
						['list'] = {},
					}
				end
				local akList = akMyServerGroups[#akMyServerGroups]['list']
				akList[#akList + 1] = kServerInfoPack
                iMySvrRowCount = iMySvrRowCount + 1
                -- 当存在自己有账号的服务器时, 如果用户没有选择过任何服务器, 那么默认选中第一个有账号的服务器
                if not bHasSelfChosenServer then
                    kDefaultSetServer = kServerInfoPack
                    bHasSelfChosenServer = true
                end
			else
				if iOtherSvrRowCount >= SERVERLIST_ROW_MAX_COUNT then
					iOtherSvrRowCount = 0
					akOtherServerGroups[#akOtherServerGroups + 1] = {
						['type'] = 'ServerGroup',
						['list'] = {},
					}
				end
				local akList = akOtherServerGroups[#akOtherServerGroups]['list']
				akList[#akList + 1] = kServerInfoPack
				iOtherSvrRowCount = iOtherSvrRowCount + 1
			end
		end
    end
    -- 如果没有 "我的服务器" 这一部分, 那么在显示 "推荐服务器" 和 所有服务器
	-- 否则显示 "我的服务器" 和 其他服务器
	local akServerGroups = nil
	if bHasMySvrTitle then
		akServerGroups = akMyServerGroups
		if iMyServerCount < iAllServerCount then
			akOtherServerGroups[1] = {['type'] = 'TagOtherServer',}
        end
	else
		-- 随机挑选若干个 推荐服务器
		local akRecommendServer = {}
		akRecommendServer[#akRecommendServer + 1] = {['type'] = 'TagRecommendServer',}
		local uiRecommendRemain = SERVERLIST_RECOMMEND_SERVER_NUM  -- 总共要推荐的服务器的个数
		local akRecommendList = {}
		-- 优先从所有 新 服务器中挑选出足够的数量
		-- akStateSortNewServerGroups 只在这里用, 所以允许被破坏
		for eState = SERVER_STATE.LowLoad, SERVER_STATE.CrowdLoad, 1 do
			if uiRecommendRemain <= 0 then
				break
			end
			local akServers = akStateSortNewServerGroups[eState]
			if akServers then
				-- 由于是从最优服务器状态开始查找的
				-- 所以如果当前组的个数小于剩余推荐数, 直接将整个组纳入推荐
				local uiGroupCount = #akServers
				if uiGroupCount <= uiRecommendRemain then
					table.move(akServers, 1, uiGroupCount, #akRecommendList + 1, akRecommendList)
					uiRecommendRemain = uiRecommendRemain - uiGroupCount
				else
				-- 否则, 从当前组中, 随机推荐 uiRecommendRemain 个服务器
					math.randomseed(os.time())
					for index = 1, uiRecommendRemain do
						-- lua 全闭区间
						akRecommendList[#akRecommendList + 1] = table.remove(akServers, math.random(1, #akServers))
					end
					uiRecommendRemain = 0
				end
			end
		end
		-- 如果不够, 在所有 正常 状态服务器中, 从负载 优 到 劣 遍历所有状态, 继续挑选
		if uiRecommendRemain > 0 then
			-- akStateSortNormalServerGroups 只在这里用, 所以允许被破坏
			for eState = SERVER_STATE.LowLoad, SERVER_STATE.CrowdLoad, 1 do
				if uiRecommendRemain <= 0 then
					break
				end
				local akServers = akStateSortNormalServerGroups[eState]
				if akServers then
					-- 由于是从最优服务器状态开始查找的
					-- 所以如果当前组的个数小于剩余推荐数, 直接将整个组纳入推荐
					local uiGroupCount = #akServers
					if uiGroupCount <= uiRecommendRemain then
						table.move(akServers, 1, uiGroupCount, #akRecommendList + 1, akRecommendList)
						uiRecommendRemain = uiRecommendRemain - uiGroupCount
					else
					-- 否则, 从当前组中, 随机推荐 uiRecommendRemain 个服务器
						math.randomseed(os.time())
						for index = 1, uiRecommendRemain do
							-- lua 全闭区间
							akRecommendList[#akRecommendList + 1] = table.remove(akServers, math.random(1, #akServers))
						end
						uiRecommendRemain = 0
					end
				end
			end
        end
        -- 如果需要推荐服务器, 说明当前玩家没有在任何服务器创建账号
		-- 这里就在推荐服里选中第一个, 以分散服务器压力
		local uiSumCount = #akRecommendList
		if uiSumCount > 0 then
			kDefaultSetServer = akRecommendList[1]
		end
		-- 按行个数塞入数据
		for uiIndex = 0, uiSumCount, SERVERLIST_ROW_MAX_COUNT do
			if uiIndex >= uiSumCount then
				break
			end
			local akNewGroup = {}
			table.move(akRecommendList, uiIndex + 1, uiIndex + SERVERLIST_ROW_MAX_COUNT, 1, akNewGroup)
			akRecommendServer[#akRecommendServer + 1] = {
				['type'] = 'ServerGroup',
				['list'] = akNewGroup,
			}
		end
		akServerGroups = akRecommendServer
		akOtherServerGroups[1] = {['type'] = 'TagAllServer',}
    end
    table.move(akOtherServerGroups, 1, #akOtherServerGroups, #akServerGroups + 1, akServerGroups)
    self.akServerGroups = akServerGroups
    
    -- 设置默认服务器
    if kDefaultSetServer and kDefaultSetServer.zone and kDefaultSetServer.server then
        local strTarZone = kDefaultSetServer.zone.zone
        SetConfig("LoginZone", strTarZone)
        local strServerKey = string.format("LoginServer_%s", tostring(strTarZone))
        local strServerNameKey = string.format("LoginServerName_%s", tostring(strTarZone))
        SetConfig(strServerKey, kDefaultSetServer.server.server)
        SetConfig(strServerNameKey, kDefaultSetServer.server.serverName)
    end
end

function HttpHelper:GetServerListGroup()
    return self.akServerGroups
end

function HttpHelper:SelectPublicLoginServer(zone,server)
    if not zone or not server then
        SystemUICall:GetInstance():WarningBox('缺少区服信息')
        UPSMgr:ReportLoginfail(1)
        return false
    end

    local strToken = globalDataPool:getData("LoginValidateToken")
    if (not strToken) or (strToken == "") then
        UPSMgr:ReportLoginfail(2)
        SystemUICall:GetInstance():WarningBox("账户数据错误, 请尝试点击右上角账号按钮重新登录账号")
        return false
    end

    local PushData = {
        token = tostring(strToken),
        zone = tostring(zone),
        server = tostring(server),
    }
    local serverLoginConfig = self:GetLoginUrlConfig()
    local PushJsonData = dkJson.encode(PushData)
    self:HttpPost(serverLoginConfig.SelectUrl, PushJsonData, function(ret)
        if ret.data then
            local rettable = dkJson.decode(ret.data)
            local kLoginInfo = nil
            if rettable and rettable.data then
                kLoginInfo = rettable.data
            end
            if self:CheckPublicLoginResult(rettable.code, kLoginInfo) then
                HttpHelper:CloseServerSelectAutoUpdate()
                if kLoginInfo and kLoginInfo.server then
                    local loginserver = kLoginInfo.server
                    globalDataPool:setData("GameServerHost", loginserver.host, true)
                    globalDataPool:setData("GameServerPort", loginserver.port, true)   
                    globalDataPool:setData("GameServerToken", loginserver.token, true)
                    globalDataPool:setData("SessionID", 0, true)
                    -- 缓存备用节点
                    local bHasEndPoints = HttpHelper:PushGameServerEndPoints(loginserver.endpoints)
                    if (os.time() - lastConnetTime > 2) then
                        lastConnetTime = os.time()
                        if bHasEndPoints then
                            SystemUICall:GetInstance():Toast('正在尝试连接服务器...(1)', false)
                        else
                            SystemUICall:GetInstance():Toast('正在连接服务器...', false)
                        end
                        HttpHelper:SetUseBackupEndPointLoginFlag(false)
                        DRCSRef.NetMgr:Disconnect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER)
                        DRCSRef.NetMgr:Connect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER,loginserver.host,loginserver.port)                 
                    else
                        SystemUICall:GetInstance():Toast('2秒内不能频繁登录！', false)
                    end                            
                else
                    UPSMgr:ReportLoginfail(3,-1)
                    SystemUICall:GetInstance():WarningBox('未发现可登录的区服')
                end
            end
        else
            self:HandleHttpRequestError(ret.error, function ()
                self:SelectPublicLoginServer(zone,server)
            end)
        end

        -- 收到 任何登录结果 关掉本地select server超时的计时器
        HttpHelper:CloseSelectServerTimeOutTimer()

        RemoveWindowImmediately("ChatBoxUI")
    end)

    -- 开始select之后, 客户端本地开启一个10s计时器, 当select长时间没有返回 登录结果 时, 主动再次select
    HttpHelper:OpenSelectServerTimeOutTimer()

    return true
end

-- 缓存登录备用节点
function HttpHelper:PushGameServerEndPoints(akEndPoints)
    self.akBackUpGasEndPoints = {}
    self.uiTryConnectTimes = 1  -- 用一个标记来表示是第几次重连, 默认开始的时候连接算一次
    if not akEndPoints then
        return false
    end
    local uiStartIndex = akEndPoints[0] and 0 or 1
    local uiCount = 0
    for i = uiStartIndex, #akEndPoints do
        if akEndPoints[i] then
            self.akBackUpGasEndPoints[#self.akBackUpGasEndPoints + 1] = akEndPoints[i]
            uiCount = uiCount + 1
        end
    end
    return (uiCount > 0)
end

-- 获取一个登录备用节点
function HttpHelper:PopGameServerEndPoints()
    if (not self.akBackUpGasEndPoints)
    or (#self.akBackUpGasEndPoints == 0) then
        return
    end
    if not self.uiTryConnectTimes then
        self.uiTryConnectTimes = 1
    end
    self.uiTryConnectTimes = self.uiTryConnectTimes + 1
    return table.remove(self.akBackUpGasEndPoints, 1), self.uiTryConnectTimes
end

function HttpHelper:SetUseBackupEndPointLoginFlag(bOn)
    self.bUseBackupEndPointLoginFlag = bOn
end

function HttpHelper:GetUseBackupEndPointLoginFlag()
    return (self.bUseBackupEndPointLoginFlag == true)
end

-- 开启select server超时
function HttpHelper:OpenSelectServerTimeOutTimer()
    if self.uiSelectServerTimeOutTimer then
        self:CloseSelectServerTimeOutTimer()
    end
    -- 一次性计时器
    self.uiSelectServerTimeOutTimer = globalTimer:AddTimer(10000, function()
        local zone = tostring(GetConfig("LoginZone"))
	    local strServerKey = string.format("LoginServer_%s", tostring(zone))
        local server = tostring(GetConfig(strServerKey))
        local bIsInLoginScene = IsWindowOpen("LoginUI")
        if (bIsInLoginScene ~= true) 
        or (not zone) or (zone == "")
        or (not server) or (server == "") then
            return
        end
        HttpHelper:SelectPublicLoginServer(zone, server)
    end)
end

-- 关闭select server超时
function HttpHelper:CloseSelectServerTimeOutTimer()
    if not self.uiSelectServerTimeOutTimer then
        return
    end
    globalTimer:RemoveTimerNextFrame(self.uiSelectServerTimeOutTimer)
    self.uiSelectServerTimeOutTimer = nil
end

-- 请求公告(是否在酒馆)
function HttpHelper:RequestNotice(bInHouse, bUserClick, eType)
    -- avoid nil value
    bInHouse = (bInHouse == true)
    bUserClick = (bUserClick == true)
    --  如果是用户自己点击的公告, 先打开ui并设置为加载状态
    if bUserClick == true then
        OpenWindowImmediately("SystemAnnouncementUI", {['bIsUserClick'] = true ,["eType"] = eType})
    end
    -- 开始请求公告
    local lCurTime = GetCurServerTimeStamp()
    -- local strToken = DRCSRef.GameConfig:GenMD5("dianhun.gm.wdxk" .. tostring(lCurTime) .. "notice-query-list")
    -- strToken = string.lower(string.gsub(strToken, "-", ""))
    -- local KPushData = {
    --     ["time"] = lCurTime,
    --     ["token"] = strToken,
    --     ["area_id"] = 1,
    --     ["plat_flag"] = "",  -- 现在大区和渠道号放到了请求地址中
    -- }
    -- local kPushJsonData = dkJson.encode(KPushData)
    local kLoginUrlConfig = self:GetLoginUrlConfig()
    local strNoticeUrl = "https://static.17m3.com/others/0/new_notice.json"
    -- if (not strNoticeUrl) or (strNoticeUrl == "") then
    --     return
    -- end
    -- local iAreaID = tonumber(GetConfig("LoginZone")) or 1  -- 当前大区id
    -- local strServerKey = string.format("LoginServer_%s", tostring(iAreaID))
    -- local strServerID = GetConfig(strServerKey) or "0"  -- 当前服标记
    -- local iCannelID = GetCurChannelID() or 0  -- 当前渠道id
    -- strNoticeUrl = string.format(strNoticeUrl, tostring(iAreaID), strServerID, tostring(iCannelID))
    -- self:HttpPost(strNoticeUrl, kPushJsonData, function(kRet)
    DRCSRef.Log(strNoticeUrl)

    --后续需要删除

    -- local function readFile(fileName)
    --     local f = assert(io.open(fileName,'r'))
    --     local content = f:read('*all')
    --     f:close()
    --     return content
    -- end

    -- local jsonStr = readFile('C:/Users/Administrator/Desktop/huafei.json')
    --删除


    self:HttpGet(strNoticeUrl, function(kRet)
        -- 获取ui节点
        local winAnnounce = GetUIWindow("SystemAnnouncementUI")
        local DoEmptyEnd = function(strLog)
            if strLog and (strLog ~= "") then
                dprint(strLog)
            end
            if not winAnnounce then
                return
            end
            winAnnounce:SetBoardState(NoticeState.Empty)
        end
        if not (kRet and kRet.data) then
            DoEmptyEnd("HttpHelper:RequestNotice => empty return data, error: " .. tostring(kRet and kRet.error or "None"))
            return
        end
        -- local kRetData = dkJson.decode(kRet.data)
        -- -- [kRetData.result: 0] means ok
        -- if (not kRetData) or (kRetData.result ~= 0) then
        --     DoEmptyEnd("HttpHelper:RequestNotice => bad return data")
        --     return
        -- end
        -- local akJsonNoticeList = kRetData.data or {}
        -- if #akJsonNoticeList == 0 then
        --     DoEmptyEnd("HttpHelper:RequestNotice => zero return data")
        --     return
        -- end


        --settingData = dkJson.decode(kRet.data)
        local settingData = dkJson.decode(kRet.data)
        if not settingData and not settingData.Notice then
            return
        end
        local akLuaNoticeList = settingData.Notice
        table.sort(akLuaNoticeList,function (a,b)
            if a.IsTop == b.IsTop then
                local refreshTimeA = a.RefreshTime
                local refreshTimeB = b.RefreshTime
                local controlSortA = refreshTimeA.Year * 100000000 + refreshTimeA.Month * 1000000 + refreshTimeA.Day * 10000 
                + refreshTimeA.Hour * 100 + refreshTimeA.Minute
                local controlSortB = refreshTimeB.Year * 100000000 + refreshTimeB.Month * 1000000 + refreshTimeB.Day * 10000 
                + refreshTimeB.Hour * 100 + refreshTimeB.Minute
                if controlSortA == controlSortB then
                    return a.ID > b.ID
                else
                    return controlSortA > controlSortB
                end
            else
                return a.IsTop > b.IsTop
            end
        end)
        -- 打开或刷新ui
        if winAnnounce then
            winAnnounce:RefreshUI({['akLuaNoticeList'] = akLuaNoticeList ,["eType"] = eType})
        else
            OpenWindowImmediately("SystemAnnouncementUI", {['akLuaNoticeList'] = akLuaNoticeList ,["eType"] = eType})
        end
    end)
end

function HttpHelper:GetQuestionUrl()
    local url = nil
    local serverLoginConfig = self:GetLoginUrlConfig()
    if (serverLoginConfig) then
        url = serverLoginConfig.QuestionUrl
        if (url == "") then
            return url
        end

        local platid = 1
        if (MSDK_OS == 2) then platid = 0 end
        local lastChooseZone = GetConfig("LoginZone") or "X"
        local strServerKey = string.format("LoginServer_%s", tostring(lastChooseZone))
        local server = GetConfig(strServerKey) or "ZoneX"

        local sArea = 1
        if (MSDKHelper:IsLoginWeChat()) then
            sArea = 1
        elseif (MSDKHelper:IsLoginQQ()) then
            sArea = 2
        end
        
        url = url .. "&sPlatId=" .. tostring(platid) .. "&sArea=" .. tostring(sArea) .. "&sPartition=" .. tostring(server) .. "&sRoleId=" .. tostring(PlayerSetDataManager:GetInstance():GetPlayerID())
    end
    return url
end

function HttpHelper:GetLoginUrlConfig()
    if (MSDK_MODE == 0) then                -- 内网
        return PublishInLineUrl
    elseif (MSDK_MODE == 1) then            -- 外网测试区
        return PublishTestAreaOutLineUrl
    elseif (MSDK_MODE == 2) then            -- 外网正式区
        return PublishOutLineUrl
    elseif (MSDK_MODE == 3) then            -- 外网Taptap测试区
        return PublishTaptapLineUrl
    elseif (MSDK_MODE == 4) then            -- 外网调试登录网址
        return DebugOutLineUrl
    elseif (MSDK_MODE == 5) then            -- 外网审核登录网址    
        return ExamOutLineUrl
    elseif (MSDK_MODE == 6) then            -- 外网A级平台压测网址
        return APlatPresureTestUrl
    elseif (MSDK_MODE == 7) then            -- 灵波的压测地址
        return LingboPresureTestUrl
    elseif (MSDK_MODE == 8) then            -- CJ测试区
        return CJTestUrl
    elseif (MSDK_MODE == 9) then            -- IOS提审服
        return IOSExamUrl
    elseif (MSDK_MODE == 10) then           -- 外网压测服
        return PublishTestUrl
    elseif (MSDK_MODE == 11) then           -- 掌门对决
        return PublishZMDJServer
    else
        return PublishInLineUrl
    end
end

return HttpHelper