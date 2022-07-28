local dkJson = require("Base/Json/dkjson")
local HttpHelper = require("Net/NetHttpHelper")
local MSDKHelper = {}

local eFlag_Succeed = 0
local eFlag_AccountRefresh = 3004

local eToken_QQ_Access = 1
local eToken_QQ_Pay = 2
local eToken_WX_Access = 3
local eToken_WX_Code = 4
local eToken_WX_Refresh = 5
local eToken_Guest_Access = 6

local eRet_QueryMyInfo = 0 -- 查询个人信息
local eRet_QueryGameFriends = 1 -- 查询同玩好友
local eRet_QueryUnionID = 2 -- 查询unionID

local eMSDK_SCREENDIR_SENSOR = 0 -- /* 横竖屏 */
local eMSDK_SCREENDIR_PORTRAIT = 1 -- /* 竖屏 */
local eMSDK_SCREENDIR_LANDSCAPE = 2 -- /* 横屏 */

MSDKHelper.platform = SLPT_PC

local OPEN_TSSSDK = true

local TSSSDK_GAME_ID = 2269

local loginurlOut = 'http://139.199.76.192:80/api/v1/json/LoginService.Login' -- 外网
local loginurlIn = 'http://127.0.0.1:9901/api/v1/json/LoginService.Login'

local qqAchievementData = {}
local isOpenQQPrivilege = false
local isOpenWXPrivilege = false
local shareCallback = nil
local shareCount = 0

local imagePath = '';
local autoImagePath = '';

local shareText = {
    '与好友一起闯荡江湖！',
    '加入自己喜欢的门派！',
    '与好友一起闯荡江湖！',
    '与好友一起培养高徒！',
    '来书写自己想要的结局！',
    '将天下宝物尽收囊中！',
    '与好友一起闯荡江湖！',
    '与好友一起闯荡江湖！',
    '与好友一起争夺天下第一！',
    '来打造自己最强的队伍！',
}

-- 初始化SDK，不能放到Main的Awake中
function MSDKHelper:InitSDK()
    if not self.instance then
        DRCSRef.CommonFunction.GCloudSDKRequestDynamicPermissions()
        self.instance = DRCSRef.MSDKLogin;
        if MSDK_OS == 1 then
            DRCSRef.MSDKUtils.TGPAInit()
        end
        if (MSDK_MODE == 2) then
            DRCSRef.MSDK.isDebug = false
        else
            DRCSRef.MSDK.isDebug = true
        end
        
        DRCSRef.MSDK:Init()
        CS.CommonMono.Instance:RegisterScreenShot();

        MidasHelper:SetEvent() -- Midas设置
        -- DRCSRef.HttpDns.Init(DRCSRef.MSDK.isDebug) --参数为sdk日志开关
        if (OPEN_TSSSDK) then
            DRCSRef.TssSDKMain.Instance:Init(TSSSDK_GAME_ID) -- TssSDK初始化
        end
        -- 注册登录回调函数
        self.LoginEventCallback = function(result)
            self:OnMSDKLoginEventCallback(result)
        end
        DRCSRef.MSDKLogin.LoginRetEvent('+', self.LoginEventCallback)
        self.LoginBaseEventCallback = function(result)
            self:OnMSDKLoginBaseEventCallback(result)
        end
        DRCSRef.MSDKLogin.LoginBaseRetEvent('+', self.LoginBaseEventCallback)

        -- 公告的注册
        self.MSDKNoticeEventCallback = function(result)
            self:OnMSDKNoticeEventCallback(result)
        end
        DRCSRef.MSDKNotice.NoticeRetEvent('+', self.MSDKNoticeEventCallback)

        self.MSDKFriendCallback = function(result)
            self:OnMSDKFriendRetEvent(result)
        end
        DRCSRef.MSDKFriend.FriendRetEvent('+', self.MSDKFriendCallback)

        self.MSDKFriendQueryEventCallback = function(result)
            self:OnMSDKFriendQueryRetEvent(result)
        end
        DRCSRef.MSDKFriend.QuereyFriendEvent('+', self.MSDKFriendQueryEventCallback)

        -- CS.UnityEngine.PlayerPrefs.SetString('isOpenQQPrivilege', 'false')
        -- CS.UnityEngine.PlayerPrefs.SetString('isOpenWXPrivilege', 'false')

        self.MSDKWebViewRetEvent = function(result)
            self:OnMSDKWebViewRetEvent(result)
        end
        DRCSRef.MSDKWebView.WebViewRetEvent('+', self.MSDKWebViewRetEvent)

        self.OnSystemScreenShotCallBack = function(result)
            if not self:IsSpecialChannel() then
                OpenWindowImmediately("SystemScreenShotShareTipUI", result)
            end
        end
        DRCSRef.MSDKUtils.SystemScreenShotRetEvent('+', self.OnSystemScreenShotCallBack)

        self.shareCount = 0
        self:InitShareImage()    --这里是给ark分享预备了一张备用图片，如果有设计备用图片的话实际上这里不需要这张，把设计的图片的路径在ark分享中传进去即可
    end
end

-- MSDK登录回调
function MSDKHelper:OnMSDKLoginEventCallback(result)
    if (result == nil) then
        dprint("LoginUI:OnMSDKLoginEventCallback result = nil")
        return
    end
    g_openID = result.OpenId

    local retCode = result.RetCode
    local channel = result.Channel
    dprint("LoginUI:OnMSDKLoginEventCallback result retCode is " .. tostring(retCode))

    local loginUI = GetUIWindow('LoginUI')
    if (MSDKHelper:IsLoginRetOK(result) == false) then
        if (loginUI) then
            loginUI:EnterMSDKPublishLogin()
        end
        return
    end

    SystemUICall:GetInstance():Toast('登录成功', false)


    -- 登录成功,更新最新的token相关信息
    MSDKHelper:UpdateLoginInfo(result)
    -- 电魂sdk 登录日志上传
    DRCSRef.DHSDKManager.DHSDKLogin(MSDKHelper:GetOpenID())
    -- 登录成功, 请求MSDK公告
    MSDKHelper:QueryNotice(false)

    local methodid = result.MethodNameId
    if (methodid == 111) then
        -- 这里代表自动登录
    elseif (methodid == 112) then
        -- 这里代表普通登录
    end
    -- 判断是否进行防沉迷，如果需要进行防沉迷的话拉起防沉迷页面	
    local loginRet = DRCSRef.MSDKLogin:GetLoginRet()
    if MSDK_OPENPRAJNA then
        if loginRet.HealthGameExt then
            local serialNumber = DRCSRef.MSDKLogin.getJsonObjString(loginRet.HealthGameExt, "serial_number")
            local PrajnaExt = DRCSRef.MSDKLogin.getJsonObjString(loginRet.HealthGameExt, "prajna_ext")
            if loginRet.RealNameAuth == true then
                -- 需要实名认证
                DRCSRef.MSDKTools.OpenPrajnaWebView(PrajnaExt);
                return
            end
        end
        if g_ReportPrajinaTimer then
            globalTimer:RemoveTimer(g_ReportPrajinaTimer)
            g_ReportPrajinaTimer = nil
        end

        -- 五分钟上报一次防沉迷信息
        local reportPrajinaDelay = 5 * 60 * 1000
        if DEBUG_MODE then
            -- 调试模式 30 秒发一次
            reportPrajinaDelay = 30000
        end

        g_ReportPrajinaTimer = globalTimer:AddTimer(reportPrajinaDelay, function()
            SendPrajnaHeartBeat(g_openID)
        end, -1)
    end

    self.isOpenQQPrivilege = false;
    self.isOpenWXPrivilege = false;

    if (self.isNeedSaveQQPrivilege) then
        self.isNeedSaveQQPrivilege = nil
        CS.UnityEngine.PlayerPrefs.SetString('QQ_GameCenter_LaunchTime' .. tostring(g_openID), os.time())
        CS.UnityEngine.PlayerPrefs.Save()
    end

    if (self.isNeedSaveWXPrivilege) then
        self.isNeedSaveWXPrivilege = nil
        CS.UnityEngine.PlayerPrefs.SetString('WX_GameCenter_LaunchTime' .. tostring(g_openID), os.time())
        CS.UnityEngine.PlayerPrefs.Save()
    end

    local lastLaunchtime = 0
    if channel == 'WeChat' then
        lastLaunchtime = CS.UnityEngine.PlayerPrefs.GetString('WX_GameCenter_LaunchTime' .. tostring(g_openID))
        if lastLaunchtime and lastLaunchtime ~= '' then
            dprint("_WX_GameCenter_LaunchTime" .. lastLaunchtime)
            local kCurTimetable = os.date("*t", os.time())
            local kLastTimetable = os.date("*t", lastLaunchtime)
            if ((kCurTimetable.year == kLastTimetable.year) and (kCurTimetable.month == kLastTimetable.month) and
                (kCurTimetable.day == kLastTimetable.day)) then
                self.isOpenWXPrivilege = true
            else
                self.isOpenWXPrivilege = false
            end
        end
    end
    if channel == 'QQ' then
        lastLaunchtime = CS.UnityEngine.PlayerPrefs.GetString('QQ_GameCenter_LaunchTime' .. tostring(g_openID))
        if lastLaunchtime and lastLaunchtime ~= '' then
            dprint("_QQ_GameCenter_LaunchTime" .. lastLaunchtime)
            local kCurTimetable = os.date("*t", os.time())
            local kLastTimetable = os.date("*t", lastLaunchtime)
            if ((kCurTimetable.year == kLastTimetable.year) and (kCurTimetable.month == kLastTimetable.month) and
                (kCurTimetable.day == kLastTimetable.day)) then
                self.isOpenQQPrivilege = true
            else
                self.isOpenQQPrivilege = false
            end
        end
        self:InitQQAchievementData()--初始化一下成就数据
    end

    self.loginWeChatAutoRun = nil
    self.loginQQAutoRun = nil

    -- 通知登录窗口
    if loginUI ~= nil then
        loginUI:EnterGamePublishLogin()
    end
    
    -- self:SendAchievementsData('login')
end

-- MSDK登出和应用唤醒回调
function MSDKHelper:OnMSDKLoginBaseEventCallback(result)
    if (result == nil) then
        dprint("error,LoginUI:OnMSDKLoginBaseEventCallback result = nil")
        return
    end

    local resultMethodid = result.MethodNameId
    local resultRetCode = result.RetCode
    local resultExtraJson = result.ExtraJson

    local LoginRet = DRCSRef.MSDKLogin.GetLoginRet();
    
    local openId = result.OpenId;
    local loginUI = GetUIWindow('LoginUI')

    local InitPlatLoginInfo = function()
        self.loginFromQQ = false;
        self.loginFromWX = false;
        self.otherAccount = false;
        self.isOpenQQPrivilege = false;
        self.isOpenWXPrivilege = false;
    
        -- 游戏中心启动判断 同时记录时间，同一天拉起过一次全天都算是有启动特权
        if (resultExtraJson and resultExtraJson ~= "") then
            dprint('OnMSDKLoginBaseEventCallback:resultExtraJson:' .. resultExtraJson)
            local params = DRCSRef.MSDKLogin.getJsonObjString(resultExtraJson, "params")
            if params then
                local launchfrom = DRCSRef.MSDKLogin.getJsonObjString(params, "launchfrom")
                local _wxobject_message_ext = DRCSRef.MSDKLogin.getJsonObjString(params, "_wxobject_message_ext")
                if MSDK_OS == 2 then
                    _wxobject_message_ext = DRCSRef.MSDKLogin.getJsonObjString(params, "messageExt")
                end
    
                if (launchfrom and launchfrom == "sq_gamecenter") then
                    dprint('OnMSDKLoginBaseEventCallback:launchfrom:sq_gamecenter')
                    self.loginFromQQ = true;
                    self.isOpenQQPrivilege = true
                    self.isNeedSaveQQPrivilege = true;
                elseif (_wxobject_message_ext and _wxobject_message_ext == "WX_GameCenter") then
                    dprint('OnMSDKLoginBaseEventCallback:_wxobject_message_ext:WX_GameCenter')
                    self.loginFromWX = true;
                    self.isOpenWXPrivilege = true
                    self.isNeedSaveWXPrivilege = true;
                end
            end
        end
    end

    -- 特殊情况下先不要调用特权设置
    if (resultMethodid ~= 119 or resultRetCode ~= 1013) then
        InitPlatLoginInfo()
    end

    if (resultMethodid == 119) then
        -- MSDK_LOGIN_WAKEUP，这里应该进行一些异常处理
        if (resultRetCode == 0) then
            -- 这里代表票据正常，游戏无需处理
            if LoginRet and LoginRet.OpenId == '' then
                local msg = "您的登录状态过期，请重新授权登录"
                local boxCallback = function()
                    if self.loginFromQQ then
                        DRCSRef.MSDKLogin.Login("QQ")
                    elseif self.loginFromWX then
                        DRCSRef.MSDKLogin.Login("WeChat")
                    end
                end
                OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback, {cancel = false, close = false, confirm = true}})
            end
        elseif (resultRetCode == 1014) then
            -- 新旧openid相同，票据不同，刷新登录票据，游戏无需处理
        elseif (resultRetCode == 1011) then
            -- 本地无openid，拉起有票据，使用新票据登录，将自动触发切换游戏账号逻辑（SwitchUser），游戏需监控登录的回调结果
        elseif (resultRetCode == 1013) then
            -- 需要弹出登录页  异账号提醒

            local showContent = {
                ['title'] = '提示',
                ['text'] = '您尝试登录的游戏账号与当前游戏账号不一致，确定使用新账号登录吗？',
                ['leftBtnText'] = '取消',
                ['rightBtnText'] = '确定',
                ['leftBtnFunc'] = function()
                    dprint("MSDK 异账号登录取消")
                    DRCSRef.MSDKLogin.SwitchUser(false);
                end
            }

            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, showContent, function()
                -- TODO 此处需返回登录界面重新载入新平台的数据，尝试了几次会出现数据异常提示
                dprint("MSDK 异账号登录确认")
                InitPlatLoginInfo()
                self.otherAccount = true;
                if(IsWindowOpen("LoginUI")) then
                    if (self.loginFromWX) then
                        DRCSRef.MSDKLogin.Login("WeChat")
                    elseif (self.loginFromQQ) then
                        DRCSRef.MSDKLogin.Login("QQ")
                    end
                else
                    if (self.loginFromWX) then
                        self.loginWeChatAutoRun = true
                    end
                    if (self.loginFromQQ) then
                        self.loginQQAutoRun = true
                    end
                    ReturnToLogin(true)
                end
            end})
        elseif (resultRetCode == 1012) then
            -- 异账号：需要进入登陆页
            if LoginRet and LoginRet.OpenId == '' then
                local msg = "您的登录状态过期，请重新授权登录"
                local boxCallback = function()
                    if self.loginFromQQ then
                        DRCSRef.MSDKLogin.Login("QQ")
                    elseif self.loginFromWX then
                        DRCSRef.MSDKLogin.Login("WeChat")
                    else
                        if loginUI ~= nil then
                            loginUI:EnterMSDKPublishLogin()
                        end
                    end
                end
                OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback, {cancel = false, close = false, confirm = true}})
            end
        else
            if loginUI ~= nil then
                loginUI:EnterMSDKPublishLogin()
            end
        end
    elseif (resultMethodid == 117) then
        -- MSDK_LOGIN_LOGOUT, 代表登出
        if loginUI ~= nil then
            loginUI:EnterMSDKPublishLogin()
        end
    end
end

-- MSDK好友和分享回调
function MSDKHelper:OnMSDKFriendRetEvent(result)
    local retCode = result.RetCode;
    if retCode == 15 then
        if self:IsLoginQQ() then
            SystemUICall:GetInstance():Toast('未安装手Q');
        elseif self:IsLoginWeChat() then
            SystemUICall:GetInstance():Toast('未安装微信');
        end
    else
        if (self.shareCallback) then
            self.shareCallback()
            self.shareCallback = nil
        end
    end
end

-- MSDK好友查询回调
function MSDKHelper:OnMSDKFriendQueryRetEvent(result)
    local retCode = result.RetCode;
    -- FriendInfoList成员变量  List<MSDKPersonInfo>  MSDKPersonInfo.PictureUrl  .UserName
end

function MSDKHelper:OnMSDKWebViewRetEvent(result)
    local retCode = result.RetCode;
end

function MSDKHelper:OpenUrl(url)
    DRCSRef.MSDKWebView.OpenUrl(url)
end

function MSDKHelper:OpenWXClubUrl()
    self:OpenUrl("https://w.url.cn/s/Atj70X4")
end

-- 部落链接待更新
function MSDKHelper:OpenQQClubUrl()
    self:OpenUrl("https://buluo.qq.com/p/barindex.html?bid=421415")
end

-- 用户协议
function MSDKHelper:OpenContractUrl()
    self:OpenUrl("http://game.qq.com/contract.shtml")
end

-- 隐私保护
function MSDKHelper:OpenPrivacyGuideUrl()
    self:OpenUrl("http://game.qq.com/privacy_guide.shtml")
end

-- 儿童隐私
function MSDKHelper:OpenPrivacyGuideChildrenUrl()
    self:OpenUrl("https://game.qq.com/privacy_guide_children.shtml")
end

function MSDKHelper:ShareToFriend(openid)
    if self:GetChannel() == "QQ" then
        self:ShareToQQFriendWithArk(openid)
    elseif self:GetChannel() == "WeChat" then
        self:ShareScreenShotToWXFriend(openid)
    end
end

--测试新的截屏分享方法
function MSDKHelper:ShareScreenShotToFriendNewTest(path, openid, baseid, bSpace, action)

    local shareType = STLSTT_NONE;
    if bSpace then
        if self:IsLoginQQ() then
            shareType = STLSTT_QQ_ZONE;
        elseif self:IsLoginWeChat() then
            shareType = STLSTT_WX_PYQ;
        end
    else
        if self:IsLoginQQ() then
            shareType = STLSTT_QQ;
        elseif self:IsLoginWeChat() then
            shareType = STLSTT_WX;
        end
    end
    SendShareInfo(baseid, shareType);
    
    --
    baseid = baseid or 0
    local tbShotDta = TableDataManager:GetInstance():GetTable("ShotData")
    local tbShotAdd = TableDataManager:GetInstance():GetTable("ShotAdd")
    local shotData = tbShotDta and tbShotDta[baseid] or {};
    local shotAdd = tbShotAdd and tbShotAdd[baseid] or {};

    local channel = self:GetChannel()

    local qrcodePath = ''
    local iconPath = ''
    local textPath = 'UI/UISprite/TencentIcon/share_text'
    -- local bgPath = 'UI/UISprite/TencentIcon/clan_share'
    if self:IsLoginQQ() then
        imagePath = string.format('share_qq%d', os.time())
        qrcodePath = 'UI/UISprite/TencentIcon/qrcode_qq'
        iconPath = 'UI/UISprite/TencentIcon/icon'
    elseif self:IsLoginWeChat() then
        imagePath = string.format('share_wx%d', os.time())
        qrcodePath = 'UI/UISprite/TencentIcon/qrcode_wx'
        iconPath = 'UI/UISprite/TencentIcon/icon'
    else
        imagePath = string.format('share_wx%d', os.time())
        qrcodePath = 'UI/UISprite/TencentIcon/qrcode_wx'
        iconPath = 'UI/UISprite/TencentIcon/icon'
        -- return
    end

    -- 底图
    local resultInfo = DRCSRef.ImageInfo()
    resultInfo.path = imagePath
    resultInfo.width = 1280
    resultInfo.height = 720 + 120
    resultInfo.color = DRCSRef.Color(0x2c / 255, 0x2c / 255, 0x2c / 255, 1)

    -- 截图
    local shotinfo = DRCSRef.ImageInfo()
    shotinfo.width = 1280
    shotinfo.height = 720
    shotinfo.posX = 0
    shotinfo.posY = 120

    -- 空间小图
    local miniInfo = DRCSRef.ImageInfo()
    miniInfo.path = imagePath .. '_mini'
    miniInfo.width = 80
    miniInfo.height = 45
    miniInfo.color = DRCSRef.Color(0x2c / 255, 0x2c / 255, 0x2c / 255, 1)
    -- 特殊处理,针对ios 的QQ空间分享图片错误的问题
    if MSDK_OS == 2 and shareType == STLSTT_QQ_ZONE and baseid ~= 11 then
        miniInfo.width = 1024
        miniInfo.height = 576
    end

    local bgInfo = nil
    if shotData.bgPath and shotData.bgPath ~= '' and shotData.bgPath ~= '/' then
        -- 背景
        bgInfo = DRCSRef.ImageInfo()
        bgInfo.path = shotData.bgPath
        bgInfo.width = 1280
        bgInfo.height = 720
        bgInfo.posX = 0
        bgInfo.posY = 120
    end

    --
    local index = 0;
    if shotAdd and shotAdd.picType then
        for i = 1, #(shotAdd.picType) do
            if shotAdd.picType[i] == ShotImageEnum.IMG_SHOT then
                index = i;
                break;
            end
        end
    end
    if index > 0 then
        -- 调整截图
        shotinfo.width = shotAdd.shotWidth[index];
        shotinfo.height = shotAdd.shotHeight[index];
        shotinfo.posX = 0 + shotAdd.shotPosX[index];
        shotinfo.posY = 120 + shotAdd.shotPosY[index];
    end

    local infos = {}

    -- QR
    local qrcodeInfo = DRCSRef.ImageInfo()
    qrcodeInfo.path = qrcodePath
    qrcodeInfo.width = 102
    qrcodeInfo.height = 102
    qrcodeInfo.posX = 9
    qrcodeInfo.posY = 9
    table.insert(infos, qrcodeInfo)
    
    -- ICON
    local iconInfo = DRCSRef.ImageInfo()
    iconInfo.width = 102
    iconInfo.height = 102
    iconInfo.path = iconPath
    iconInfo.posX = resultInfo.width - (102 + 9)
    iconInfo.posY = 9
    table.insert(infos, iconInfo)

    -- TEXT
    local textInfo = DRCSRef.ImageInfo()
    textInfo.path = textPath
    if shotData.textPath and shotData.textPath ~= '' and shotData.textPath ~= '/' then
        textInfo.path = shotData.textPath
    end
    textInfo.posX = 9 + 102 + 16
    textInfo.posY = (120 - 52) / 2
    table.insert(infos, textInfo)

    -- Other
    if shotAdd and shotAdd.picType then
        for i = 1, #(shotAdd.picType) do
            if shotAdd.picType[i] ~= ShotImageEnum.IMG_SHOT then
                local iconInfo = DRCSRef.ImageInfo()
                iconInfo.path = shotAdd.picPath[i]
                iconInfo.posX = 0 + shotAdd.shotPosX[i]
                iconInfo.posY = 120 + shotAdd.shotPosY[i]
                iconInfo.width = shotAdd.shotWidth[i]
                iconInfo.height = shotAdd.shotHeight[i]
                table.insert(infos, iconInfo)
            end
        end
    end

    CS_Coroutine.start(function()
        coroutine.yield(DRCSRef.MSDKUtils.CreateScreenShotShareImage(path, tostring(channel), resultInfo, shotinfo, bgInfo, miniInfo, infos, function()
            if bSpace then
                if channel == "QQ" then
                    if baseid == 11 then
                        self:ShareToQQSpace()
                    else
                        self:ShareToQQSpaceIn800Style(baseid)
                    end
                elseif channel == "WeChat" then
                    self:ShareToWXTimeLine()
                end
            else
                if channel == "QQ" then
                    self:ShareScreenShotToQQFriend(openid)
                elseif channel == "WeChat" then
                    self:ShareScreenShotToWXFriend(openid)
                end
            end
            if action then
                action()
            end
        end))
    end)
end

-- 捕捉系统截屏后的分享
-- function MSDKHelper:ShareSystemScreenShotToFriend(path, openid, action)
--     dprint('ShareSystemScreenShotToFriend:path :' .. tostring(path))
--     local baseid = 11;
--     local shareType = STLSTT_NONE;
--     if self:IsLoginQQ() then
--         shareType = STLSTT_QQ;
--     elseif self:IsLoginWeChat() then
--         shareType = STLSTT_WX;
--     end
--     SendShareInfo(baseid, shareType);
    
--     if self:IsLoginQQ() then
--         imagePath = string.format('share_qq%d.png', os.time());
--     elseif self:IsLoginWeChat() then
--         imagePath = string.format('share_wx%d.png', os.time());
--     end

--     local channel = self:GetChannel()
--     CS_Coroutine.start(function()
--         coroutine.yield(DRCSRef.MSDKUtils.ShareExistScreenShotImage(path, imagePath, tostring(channel), function()
--             if channel == "QQ" then
--                 self:ShareScreenShotToQQFriend(openid)
--             elseif channel == "WeChat" then
--                 self:ShareScreenShotToWXFriend(openid)
--             end
--             if action then
--                 action()
--             end
--         end))
--     end)
-- end

--800新样式分享
function MSDKHelper:ShareToQQSpaceIn800Style(type)
    if imagePath == '' then
        derror('imagePath must not nil');
        return;
    end
    local info = DRCSRef.MSDKFriendReqInfo("{\"type\":10003}")
    local path = DRCSRef.PersistentDataPath .. "/shotImage/" .. imagePath .. '.png'
    local minipath = DRCSRef.PersistentDataPath .. "/shotImage/" .. imagePath .. '_mini.png'
    local link = string.format('https://speed.gamecenter.qq.com/pushgame/v1/10127/%d/detail?_sharetype=1&_shareid=%d&_appid=1108328494&_other=1', type, type)
    info.ImagePath = path
    info.ThumbPath = minipath
    if type and type > 0 then
        info.Link = link
    end
    info.Title = "我的侠客！"
	info.Desc = shareText[type] or "与好友一起闯荡江湖！"
    DRCSRef.MSDKFriend.Share(info, "QQ")
end

-- 捕捉系统截屏后的分享
-- function MSDKHelper:ShareSystemScreenShotToTimeLineOrSpace(path, action)
--     local baseid = 11;
--     local shareType = STLSTT_NONE;
--     if self:IsLoginQQ() then
--         shareType = STLSTT_QQ_ZONE;
--     elseif self:IsLoginWeChat() then
--         shareType = STLSTT_WX_PYQ;
--     end
--     SendShareInfo(baseid, shareType);
    
--     if self:IsLoginQQ() then
--         imagePath = string.format('share_qq%d.png', os.time());
--     elseif self:IsLoginWeChat() then
--         imagePath = string.format('share_wx%d.png', os.time());
--     end

--     local channel = self:GetChannel()
--     CS_Coroutine.start(function()
--         coroutine.yield(DRCSRef.MSDKUtils.ShareExistScreenShotImage(path, imagePath, tostring(channel), function()
--             if channel == "QQ" then
--                 self:ShareToQQSpace()
--             elseif channel == "WeChat" then
--                 self:ShareToWXTimeLine()
--             end
--             if action then
--                 action()
--             end
--         end))
--     end)
-- end

function MSDKHelper:ShareInviteToWX(openid, callback)
    local info = DRCSRef.MSDKFriendReqInfo(
                     "{\"desc\":\"一起来闯荡江湖\",\"link\":\"https://game.weixin.qq.com/cgi-bin/h5/static/gamecenter/detail.html?appid=wx398d0e3e595d8823&ssid=22&autoinstall=1&type=1#wechat_redirect\", \"type\":10003}")
    if openid ~= nil then
        info.User = openid
        info.ExtraJson = "{\"isFriendInGame\":false}"
    end
    if callback then
       self.shareCallback = callback
    end
    DRCSRef.MSDKFriend.SendMessage(info, "WeChat")
end

function MSDKHelper:ShareToWXTimeLine()
    if imagePath == '' then
        derror('imagePath must not nil');
        return;
    end
    local path = DRCSRef.PersistentDataPath .. "/shotImage/" .. imagePath .. '.png'
    local info = DRCSRef.MSDKFriendReqInfo("{\"type\":10002}")
    info.ImagePath = path
    DRCSRef.MSDKFriend.Share(info, "WeChat")
end

-- 邀请QQ好友
function MSDKHelper:ShareInviteToQQ(openid, callback)
    local info = DRCSRef.MSDKFriendReqInfo(
                     "{\"title\":\"一起来闯荡江湖\",\"desc\":\"一起来闯荡江湖\",\"link\":\"https://speed.gamecenter.qq.com/pushgame/v1/detail?appid=1108328494&adtag=91103&from_new_gamecenter=1\", \"type\":10003}")
    if openid ~= nil then
        info.User = openid
        info.ExtraJson = "{\"isFriendInGame\":false}"
    end
    if callback then
        self.shareCallback = callback
     end
    DRCSRef.MSDKFriend.SendMessage(info, "QQ")
end

function MSDKHelper:ShareToQQSpace()
    if imagePath == '' then
        derror('imagePath must not nil');
        return;
    end
    local path = DRCSRef.PersistentDataPath .. "/shotImage/" .. imagePath .. '.png'
    local info = DRCSRef.MSDKFriendReqInfo("{\"type\":10002}")
    info.ImagePath = path
    DRCSRef.MSDKFriend.Share(info, "QQ")
end

function MSDKHelper:ShareScreenShotToQQFriend(openid)
    if imagePath == '' then
        derror('imagePath must not nil');
        return;
    end
    local path = DRCSRef.PersistentDataPath .. "/shotImage/" .. imagePath .. '.png'
    local info = DRCSRef.MSDKFriendReqInfo(
                     "{\"type\":10002,\"link\":\"https://speed.gamecenter.qq.com/pushgame/v1/detail?appid=1108328494&_wv=2164260896&_wwv=448\"}")
    info.ImagePath = path
    info.ExtraJson = "{\"isFriendInGame\":false}"
    if openid ~= nil then
        info.User = openid
        info.ExtraJson = "{\"isFriendInGame\":true}"
    end
    DRCSRef.MSDKFriend.SendMessage(info, "QQ")
end

function MSDKHelper:ShareScreenShotToWXFriend(openid)
    if imagePath == '' then
        derror('imagePath must not nil');
        return;
    end
    local path = DRCSRef.PersistentDataPath .. "/shotImage/" .. imagePath .. '.png'
    local info = DRCSRef.MSDKFriendReqInfo(
                     "{\"desc\":\"一起来闯荡江湖\",\"link\":\"https://game.weixin.qq.com/cgi-bin/h5/static/gamecenter/detail.html?appid=wx398d0e3e595d8823&ssid=22&autoinstall=1&type=1#wechat_redirect\", \"type\":10002}")
    info.ImagePath = path
    if openid ~= nil then
        info.User = openid
    end
    DRCSRef.MSDKFriend.SendMessage(info, "WeChat")
end

function MSDKHelper:InitShareImage()
    DRCSRef.ScreenShot("share.png")       --这里是给ark分享预备了一张备用图片，如果有设计备用图片的话实际上这里不需要这张，把设计的图片的路径在ark分享中传进去即可
    -- CS_Coroutine.start(function()
    --     --coroutine.yield(DRCSRef.MSDKUtils.CopyFromStreamingAssetsToPersistentPath("share/share.png", "share.png"));
    -- end)
end

-- 前端ARK分享
function MSDKHelper:ShareToQQFriendWithArk(openid, baseid)

    local shareType = STLSTT_NONE;
    if self:IsLoginQQ() then
        shareType = STLSTT_QQ;
    elseif self:IsLoginWeChat() then
        shareType = STLSTT_WX;
    end
    SendShareInfo(baseid, shareType);

    local reqInfo = DRCSRef.MSDKFriendReqInfo("{\"type\":10008}")
    reqInfo.Title = "我的侠客游戏分享"
    reqInfo.Desc = "邀请入队"
    reqInfo.Link = "https://speed.gamecenter.qq.com/pushgame/v1/detail?appid=1108328494&_wv=2164260896&_wwv=448"
    reqInfo.ImagePath = DRCSRef.PersistentDataPath  .. "/share.png"

    local jsonShareData = {
        ["appid"] = "1108328494",
        ["openId"] = openid,
        ["scene"] = "406",
        ["url"] = "",
        ["extData"] = {}
    }

    local jsonConfig = {
        ["type"] = "normal",
        ["forward"] = 0
    }
    local jsonMeta = {
        ["shareData"] = jsonShareData
    }
    local kJsonData = {
        ["app"] = "com.tencent.gamecenter.wdxk",
        ["view"] = "commonView",
        ["desc"] = "游戏分享",
        ["promt"] = "我的侠客分享",

        ["ver"] = "1.0.0.1",
        ["config"] = jsonConfig,
        ["meta"] = jsonMeta
    }
    local kPushJsonData = dkJson.encode(kJsonData)
    dprint('ark分享：' .. kPushJsonData)
    reqInfo.ExtraJson = kPushJsonData
    DRCSRef.MSDKFriend.SendMessage(reqInfo, "QQ")
end

function MSDKHelper:OpenGiftCenter()
    if self:GetChannel() == "WeChat" then
        self:OpenUrl("https://game.weixin.qq.com/cgi-bin/comm/openlink?appid=wx62d9035fd4fd2059&url=https%3A%2F%2Fgame.weixin.qq.com%2Fcgi-bin%2Fh5%2Fstatic%2Fgamecenter%2Fdetail.html%3Fappid%3Dwx398d0e3e595d8823%26ssid%3D46%23wechat_redirect#wechat_redirect") --更新了链接
    elseif self:GetChannel() == "QQ" then
        self:OpenUrl("https://speed.gamecenter.qq.com/pushgame/v1/gift/game?ADTAG=youxineizhi&appid=1108328494")
    end
end

function MSDKHelper:OnMsdkFriendRetEventCallback(result)
    local retCode = result.RetCode;
    dprint("LoginUI:OnMsdkFriendRetEventCallback result retCode is " .. tostring(retCode))
    -- OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '分享成功' })
end

function MSDKHelper:UpdateLoginInfo(result)
    DRCSRef.Log("UpdateLoginInfo")
    self.loginResult = result
    if (self.loginResult ~= nil) then
        -- DRCSRef.HttpDns.SetOpenId(self.loginResult.OpenId)
        -- MSDK里的 1是微信 2是QQ 但是 TSS里面1 QQ  2是微信 所以这里重新设置一下
        local channelId = self.loginResult.ChannelId
        if channelId == 1 then
            channelId = 2
        elseif channelId == 2 then
            channelId = 1
        end
        if (OPEN_TSSSDK) then
            DRCSRef.TssSDKMain.Instance:SetUserInfo(channelId, self.loginResult.OpenId) -- TssSDK设置登录信息
        end
        DRCSRef.MidasMain.mLoginRet = result
        MidasHelper:InitMidas() -- Midas初始化
        self:UploadHeadPicUrl()
    end
end

function MSDKHelper:SendMessage(msg, channel)
    local jsonStr = '{\"desc\":\"' .. msg ..
                        '\",\"link\":\"https://speed.gamecenter.qq.com/pushgame/v1/detail?appid=1108328494&adtag=91103&from_new_gamecenter=1\", \"type\":10003}'
    local info = CS.GCloud.MSDK.MSDKFriendReqInfo(jsonStr)
    CS.GCloud.MSDK.MSDKFriend.SendMessage(info, channel)
end

function MSDKHelper:GetChannelId()
    if (self.loginResult == nil) then
        return nil
    end

    return self.loginResult.ChannelId
end

function MSDKHelper:GetChannel()
    if (self.loginResult == nil) then
        return ""
    end

    return self.loginResult.Channel
end

function MSDKHelper:GetOpenID()
    if (self.loginResult == nil) then
        return nil
    end

    return self.loginResult.OpenId
end

function MSDKHelper:GetToken()
    if (self.loginResult == nil) then
        return nil
    end

    return self.loginResult.Token
end

function MSDKHelper:GetPictureUrl()
    if (self.loginResult == nil) then
        return nil
    end
    return self.loginResult.PictureUrl
end

function MSDKHelper:GetNickName()
    if (self.loginResult == nil) then
        return nil
    end
    return self.loginResult.UserName
end

function MSDKHelper:GetAccessToken()
    if (self.loginResult == nil or self.loginResult.ChannelInfo == nil) then
        return nil
    end
    local channelInfo = self.loginResult.ChannelInfo

    local data = dkJson.decode(channelInfo)
    if (not data) then
        return nil
    end
    return data['access_token'] or ''
end

function MSDKHelper:GetPayToken()
    if (self.loginResult == nil or self.loginResult.ChannelInfo == nil) then
        return nil
    end
    local channelInfo = self.loginResult.ChannelInfo

    local data = dkJson.decode(channelInfo)
    if (not data) then
        return nil
    end
    return data['pay_token'] or ''
end

function MSDKHelper:GetRegChannel()
    if self.loginResult then
        return self.loginResult.RegChannelDis;
    end
    return nil;
end

function MSDKHelper:IsLoginQQ()
    if self:GetChannel() == "QQ" then
        return true;
    end
    return false;
end

function MSDKHelper:IsLoginWeChat()
    if self:GetChannel() == "WeChat" then
        return true;
    end
    return false;
end

function MSDKHelper:OnLogin(resoult)
    dprint('LoginEvent')
    dprint(resoult)

    if resoult.flag == eFlag_Succeed then
        self.platform = resoult.platform
        self.userid = resoult.user_id
        self.openid = resoult.open_id
        self.accessToken = resoult:GetAccessToken()

        local data = self:GenLoginJsonData(self.platform, self.openid, self.accessToken)
        HttpHelper:PublicLoginValidate(data)
        -- for i=0, resoult.token.Count - 1 do
        --     print(resoult.token[i].type)
        --     print(resoult.token[i].value)
        -- end
    else
        SystemUICall:GetInstance():Toast(resoult:ToString())
    end
end

-- /**
-- * 获取QQ好友信息, 回调在OnRelationNotify中,
-- * 其中RelationRet.persons为一个List, List中的内容即使好友信息, QQ好友信息里面province和city为空
-- * @return void
-- * 此接口的调用结果通过OnRelationNotify(RelationRet relationRet)
-- *   回调返回数据给游戏, RelationRet对象的persons属性是一个List<PersonInfo>,
-- *   其中的每个PersonInfo对象即是好友信息,
-- *   好友信息包含: nickname, openId, gender, pictureSmall, pictureMiddle, pictureLarge
-- */

function MSDKHelper:OnRelation(resoult)
    dprint('Relation')
    dprint(resoult)
    if resoult.flag == eFlag_Succeed then
        if resoult.type == eRet_QueryMyInfo then
            local info = resoult.persons[0]
        elseif resoult.type == eRet_QueryGameFriends then

        end
    end
end
function _encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c)
        return string.format("%%%02X", string.byte(c))
    end)
    return string.gsub(s, " ", "+")
end
function MSDKHelper:OpenCriditUrl()
    local strname = PlayerSetDataManager:GetInstance():GetPlayerName() or ''
    local serverLoginConfig = HttpHelper:GetLoginUrlConfig()
    if not serverLoginConfig then
        return nil
    end

    local strcriditurl = serverLoginConfig.CriditUrl or ''
    strcriditurl = strcriditurl .. '?rolename=' .. _encodeURI(strname)
    DRCSRef.Log("OpenCriditUrl : rolename" .. strcriditurl)
    -- strcriditurl = self:SDKGetEncodeUrl(strcriditurl)
    -- DRCSRef.Log("OpenCriditUrl : SDKGetEncodeUrl".. strcriditurl)
    return self:SDKOpenUrl(strcriditurl)

end

function MSDKHelper:OnWakeup(resoult)
    dprint('WakeupEvent')
    dprint(resoult)
    if resoult.flag == eFlag_Succeed or resoult.flag == eFlag_AccountRefresh then
        self.platform = resoult.platform
        self.userid = resoult.user_id
        self.openid = resoult.open_id
        self.accessToken = resoult:GetAccessToken()

        for i = 0, resoult.token.Count - 1 do
            print(resoult.token[i].type)
            print(resoult.token[i].value)
        end
    else
        SystemUICall:GetInstance():Toast(resoult:ToString())
    end
end

function MSDKHelper:UnInit()
    if self.instance then
        DRCSRef.MSDKLogin.LoginRetEvent('-', self.LoginEventCallback)
        DRCSRef.MSDKLogin.LoginBaseRetEvent('-', self.LoginBaseEventCallback)
        DRCSRef.MSDKNotice.NoticeRetEvent('-', self.MSDKNoticeEventCallback)
        DRCSRef.MSDKFriend.FriendRetEvent('-', self.MSDKFriendCallback)
        DRCSRef.MSDKFriend.QuereyFriendEvent('-', self.MSDKFriendQueryEventCallback)
        DRCSRef.MSDKWebView.WebViewRetEvent('-', self.MSDKWebViewRetEvent)
        DRCSRef.MSDKUtils.SystemScreenShotRetEvent('-', self.OnSystemScreenShotCallBack)
    end
end

function MSDKHelper:SDKLogin(type)
    if self.instance then
        self.instance:Login(type)
    end
end

function MSDKHelper:SDKOpenUrl(url)
    -- if self.instance then
    if url and url ~= '' then
        DRCSRef.Log("MSDKHelper.SDKOpenUrl" .. url)
        url = string.gsub(url, "&amp;", "&")
        -- self.instance:OpenUrl(url, 2)
        DRCSRef.MSDKWebView.OpenUrl(url)
    end
end

function MSDKHelper:SDKGetEncodeUrl(url)
    return DRCSRef.MSDKWebView.GetEncodeUrl(url)
end
function MSDKHelper:GetNotice(scene)
    if self.instance then
        self.instance:GetNotice(scene or '0')
    end
end

-- local url = _G.MicroServer.loginurl..'LoginService.Login'
-- 	local params = {
-- 		channel = 1,
-- 		uid = ac_info.open_id,
-- 		token = ac_info.access_token,
-- 	}
-- 	c.HttpPost(url, js.encode(params), GF.http_login_call_back)
function MSDKHelper:GenLoginJsonData(channel, open_id, access_token)
    local params = {
        channel = channel,
        uid = tostring(open_id),
        token = tostring(access_token)
    }
    -- local form = DRCSRef.WWWForm()
    -- form:AddField("channel", channel)
    -- form:AddField("uid", tostring(open_id))
    -- form:AddField("token", tostring(access_token))
    return dkJson.encode(params)
    -- return form
end

function MSDKHelper:OpenFullScreenWebViewWithJson()
    if self.instance then
        jsonStr =
            '{"url": "https://test.jiazhang.qq.com/wap/com/v1/src/msdk/banned_games.shtml", "show_titlebar": "0", "show_title": "0", "buttons": [] }'
        self.instance:OpenFullScreenWebViewWithJson(jsonStr)
    end

    -- TODO:等待服务端完成后调用
    -- 1. 强制验证
    -- if not is_windows then 
    -- 	SDKHelper:OpenFullScreenWebViewWithJson()
    -- end
    -- 2. 
    -- OpenWindowImmediately('GeneralBoxUI', { GeneralBoxType.COMMON_TIP, '游戏时间。。。。?' })
end

--------------Tss begin-------------
local tssReportHandler = 0
local tssSendCacheHandler = 0
local cacheTssReportData = {}
local function SendTssCacheData()
    for index = #cacheTssReportData, 1, -1 do
        local acData = cacheTssReportData[index]
        local binData, iCmd = EncodeSendSeCGA_TssSDK(acData)
        local bSend = SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData, true)
        if bSend then
            table.remove(cacheTssReportData, index)
        else
            break
        end
    end
    if #cacheTssReportData == 0 then
        globalTimer:RemoveTimer(tssSendCacheHandler)
        tssSendCacheHandler = 0
    end
end

local function SendTssReport()
    if not g_IS_WINDOWS then
        if (OPEN_TSSSDK) then
            local acData = DRCSRef.TssSDKMain.Instance:GetReportData() -- TssSDK获取监控数据
            if acData ~= nil then
                local binData, iCmd = EncodeSendSeCGA_TssSDK(acData)
                local bSend = SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData, true)
                if not bSend then
                    cacheTssReportData[#cacheTssReportData + 1] = acData
                    tssSendCacheHandler = globalTimer:AddTimer(33, function()
                        SendTssCacheData()
                    end, -1)
                end
            end
        end
    end
end

function MSDKHelper:StartTssReport()
    -- local iReportTime = 5 * 1000 --上报间隔 5s
    -- if tssReportHandler == 0 then
    --     tssReportHandler = globalTimer:AddTimer(iReportTime, function() SendTssReport() end, -1)
    -- end
end

function MSDKHelper:StopTssReport()
    if tssReportHandler ~= 0 then
        globalTimer:RemoveTimer(tssReportHandler)
        tssReportHandler = 0
    end
    if tssSendCacheHandler ~= 0 then
        globalTimer:RemoveTimer(tssSendCacheHandler)
        tssSendCacheHandler = 0
    end
    cacheTssReportData = {}
end

-- 接收服务端处理之后的数据
function RecvTssData(byteArray)
    if (OPEN_TSSSDK) then
        DRCSRef.TssSDKMain.Instance:OnRecvData(byteArray)
    end
end

--------------Tss end-------------

---------- 平台头像设置 -------------
CAN_USE_PLATHEAD = true

function MSDKHelper:SetHeadPic(callback)
    -- 根据设置选择显示哪个头像 回调参数为sprite
    local playerID = tostring(globalDataPool:getData("PlayerID"));
    local channel = self:GetChannel()
    local headConfig = GetConfig(playerID .. "#confg_QQHead");
    if CAN_USE_PLATHEAD and (channel == "WeChat" or channel == "QQ") then
        -- qq微信渠道读配置
        if headConfig == nil then
            headConfig = 2
            SetConfig(playerID .. "#confg_QQHead", 2)
            self:UploadHeadPicUrl()
        end
    else
        -- 游客等渠道直接置值
        if headConfig ~= 1 then
            headConfig = 1
            SetConfig(playerID .. "#confg_QQHead", 1)
            self:UploadHeadPicUrl()
        end
    end
    if (callback) then
        if ((not headConfig or headConfig == 2) and self:GetPictureUrl() ~= nil) then
            -- 获取msdk里的头像url
            GetHeadPicByUrl(self:GetPictureUrl(), callback)
        else
            local modelID = PlayerSetDataManager:GetInstance():GetModelID();
            GetHeadPicByModelId(modelID, callback)
        end
    end
end

function MSDKHelper:UploadHeadPicUrl()
    -- 更新服务器玩家头像url 
    -- 根据设置 上传qq微信头像url 或者 上传""
    local playerID = tostring(globalDataPool:getData("PlayerID"));
    local headConfig = GetConfig(playerID .. "#confg_QQHead");
    local url = self:GetPictureUrl();
    if (headConfig == 2 and url ~= nil and url ~= "") then
        SendSetCharPictureUrl(url);
    else
        SendSetCharPictureUrl("");
    end
end

--- 好友关系链

-- 从msdk后台拉取的好友list
local msdkFriendInfoList = {}
-- 通过msdk-openid-list在登录服拉取的好友list
local serverFriendInfoList = {}
-- 按照服务器 筛选出的同服好友list
local sameServerFriendInfoList = {}

--- 2 从msdk下载同玩好友列表
function MSDKHelper:DownloadMSDKFriendInfoList(callback)
    -- 获取好友关系链无法使用msdk接口 直接使用后台接口 拼接字段post
    -- SystemUICall:GetInstance():Toast('GetFriendInfoList in function')
    local loginUrlConfig = HttpHelper:GetLoginUrlConfig()
    local kJsonData = {
        ["openid"] = self:GetOpenID(),
        ["token"] = self:GetAccessToken()
    }
    local kPushJsonData = dkJson.encode(kJsonData)
    local paramsUrl =
        "?channelid=" .. self.loginResult.ChannelId .. "&gameid=10127" .. "&os=" .. MSDK_OS .. "&source=0" .. "&ts=" ..
            os.time() .. "&version=5.7.001.1031"
    -- 格式要求md5(path + "?" + params + body + sigkey)，
    local sigUrl = "/v2/friend/friend_list" .. paramsUrl .. kPushJsonData .. "206e8c51becf7c9962af42ea6ddfdeea"
    local md5Sig = string.lower(string.gsub(DRCSRef.GameConfig:GenMD5(sigUrl), "-", ""))
    local postUrl = loginUrlConfig.GetFriendList .. paramsUrl .. "&sig=" .. md5Sig
    dprint("#####" .. postUrl)
    HttpHelper:HttpPost(postUrl, kPushJsonData, function(result)
        -- pfriendInfo.openid  pfriendInfo.picture_url pfriendInfo.user_name
        if (result == nil or result.data == nil) then
            derror("查询msdk好友返回nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            derror("查询msdk好友返回空字符串")
            return
        end
        if resultData.ret == nil or resultData.ret ~= 0 then
            if (resultData.ret) then
                derror("查询msdk好友返回错误，错误码" .. resultData.ret)
            end
            return
        end
        if resultData.lists == nil then
            return
        else
            local friendsInfoList = resultData.lists
            if callback then
                callback(friendsInfoList)
            end
        end
    end)
end

--- 3 使用openid列表去http请求游戏好友详细信息列表
function MSDKHelper:GetServerFriendInfoList(callback)
    -- msdkFriendList已知 用openid去请求serverFriendInfoList
    local newList = {}
    local msdkFriendOpenIdList = {}
    for i, v in pairs(msdkFriendInfoList) do
        table.insert(msdkFriendOpenIdList, v.openid)
    end
    local subList = {}
    local callbackCount = math.ceil((#msdkFriendOpenIdList) / 40)
    dprint("msdk获取到好友数量:" .. #msdkFriendOpenIdList)
    -- 每次请求不能超过49个 每次请求40个
    for p = 1, #msdkFriendOpenIdList do
        table.insert(subList, msdkFriendOpenIdList[p])
        if (p % 40 == 0 or p == #msdkFriendOpenIdList) then
            HttpHelper:GetPublicLoginFriendInfoList(subList, function(serverFriendInfoList)
                for i, v in pairs(serverFriendInfoList) do
                    -- 结构 v.os v.openid v.uid v.lastZone v.lastServer v.lastLoginTime
                    if not (tonumber(v.lastZone) == nil or v.lastServer == nil or v.lastServer == "" or
                        string.sub(v.lastLoginTime, 1, 1) == "-") then
                        if (newList[v.openId] ~= nil) then
                            if v.lastLoginTime > newList[v.openId].lastLoginTime then
                                newList[v.openId] = v
                            end
                        else
                            newList[v.openId] = v
                        end
                    end
                end
                callbackCount = callbackCount - 1
                if (callbackCount == 0 and callback ~= nil and newList ~= nil) then
                    callback(newList)
                end
            end)
            subList = {}
        end
    end
end

--- 1 获取好友链入口
function MSDKHelper:FriendInit(callback)
    -- 清空
    msdkFriendInfoList = {}
    serverFriendInfoList = {}
    sameServerFriendInfoList = {}
    -- step 2
    self:DownloadMSDKFriendInfoList(function(list)
        msdkFriendInfoList = list
        -- step 3
        self:GetServerFriendInfoList(function(list)
            if (msdkFriendInfoList) then
                local newmsdkFriendList = {}
                for i, v in pairs(msdkFriendInfoList) do
                    newmsdkFriendList[v.openid] = v
                end
                serverFriendInfoList = {}
                for k, v in pairs(list) do
                    dprint("###" .. k .. " " .. v.uid)
                    serverFriendInfoList[#serverFriendInfoList + 1] =
                        {
                            ['openid'] = k,
                            ['os'] = v.os,
                            ['uid'] = v.uid,
                            ['lastZone'] = v.lastZone,
                            ['lastServer'] = v.lastServer,
                            ['lastLoginTime'] = v.lastLoginTime,
                            ['picture_url'] = newmsdkFriendList[k].picture_url,
                            ['user_name'] = newmsdkFriendList[k].user_name,
                            ['userTags'] = v.userTags
                        }
                end
                -- 按登录时间从大到小排序
                table.sort(serverFriendInfoList, function(a, b)
                    if (a.lastLoginTime > b.lastLoginTime) then
                        return true
                    end
                    return false
                end)
                if callback and #serverFriendInfoList > 0 then
                    callback(serverFriendInfoList)
                end
            end
        end)
    end)

    self:DownloadMSDKRecallFriendInfoList()
end

--非同玩好友
local msdkRecallFriendInfoList = {}
--msdk查询非同玩好友
function MSDKHelper:DownloadMSDKRecallFriendInfoList()
    msdkRecallFriendInfoList = {}
    -- 获取好友关系链无法使用msdk接口 直接使用后台接口 拼接字段post
    local appid = 16073
    if ((MSDK_MODE == 0 or MSDK_MODE == 1)) then
        appid = 0
    end
    local loginUrlConfig = HttpHelper:GetLoginUrlConfig()
    local kJsonData = {
        ["openid"] = self:GetOpenID(),
        ["token"] = self:GetAccessToken(),
        ["task_id"] = appid,
        ["appname"] = 'wx_msdkv5_relation',
        ['count'] = 20
    }

    local kPushJsonData = dkJson.encode(kJsonData)
    local paramsUrl =
        "?channelid=" .. self.loginResult.ChannelId .. "&gameid=10127" .. "&os=" .. MSDK_OS .. "&source=0" .. "&ts=" ..
            os.time() .. "&version=5.7.001.1031"
    -- 格式要求md5(path + "?" + params + body + sigkey)，
    local sigUrl = "/v2/friend/recall_friends_list" .. paramsUrl .. kPushJsonData .. "206e8c51becf7c9962af42ea6ddfdeea"
    local md5Sig = string.lower(string.gsub(DRCSRef.GameConfig:GenMD5(sigUrl), "-", ""))
    local postUrl = loginUrlConfig.GetRecallFriendList .. paramsUrl .. "&sig=" .. md5Sig
    dprint("#####" .. postUrl)
    HttpHelper:HttpPost(postUrl, kPushJsonData, function(result)
        -- pfriendInfo.openid  pfriendInfo.picture_url pfriendInfo.user_name
        if (result == nil or result.data == nil) then
            SystemUICall:GetInstance():Toast("查询msdk好友返回nil")
            return
        end
        local resultData = dkJson.decode(result.data)
        if resultData == nil then
            SystemUICall:GetInstance():Toast("查询msdk好友返回空字符串")
            return
        end
        if resultData.ret == nil or resultData.ret ~= 0 then
            if (resultData.ret and MSDK_MODE~=9) then
                SystemUICall:GetInstance():Toast("查询msdk好友返回错误，错误码" .. resultData.ret)
            end
            return
        end
        if resultData.result == nil or resultData.result.friend_list == nil then
            return
        else
            msdkRecallFriendInfoList = resultData.result.friend_list
        end
    end)
end

function MSDKHelper:GetRecallFriendList(callback)
    if callback and msdkRecallFriendInfoList then
        callback(msdkRecallFriendInfoList)
    end
end

function MSDKHelper:GetFriendList(callback)
    if callback and serverFriendInfoList then
        callback(serverFriendInfoList)
    end
end

-- 酒馆中会将平台好友同步到游戏好友中
function MSDKHelper:GetSameServerFriendListAddToGameFriendsList()
    sameServerFriendInfoList = {}
    if (serverFriendInfoList ~= nil and #serverFriendInfoList > 0) then
        -- sameServerFriendInfoList里只有playerid
        for i, v in pairs(serverFriendInfoList) do
            local zone = tostring(GetConfig("LoginZone"))
            local strServerKey = string.format("LoginServer_%s", zone)
            local server = tostring(GetConfig(strServerKey))
            dprint("$$$$" .. v.lastZone .. " " .. zone .. " " .. v.lastServer .. " " .. server)
            if v.lastZone == zone and v.lastServer == server then
                table.insert(sameServerFriendInfoList, tonumber(v.uid))
            end
        end
        -- 将查询到的平台好友 添加入游戏好友列表
        -- local instance = SocialDataManager:GetInstance();
        -- instance:QueryFriendInfo(sameServerFriendInfoList, function()
        --     for i = 1,#(sameServerFriendInfoList) do
        --         instance:AddFriendData({friendid = tostring(sameServerFriendInfoList[i])})
        --     end

        -- end)
    end
    return sameServerFriendInfoList;
end

function MSDKHelper:GetNickNameByFriendPlayerID(uid)
    if (serverFriendInfoList ~= nil and #serverFriendInfoList > 0) then
        -- dprint("$$$$$ GetNickNameByFriendPlayerID uid"..uid)
        for i, v in pairs(serverFriendInfoList) do
            local zone = tostring(GetConfig("LoginZone"))
            local strServerKey = string.format("LoginServer_%s", zone)
            local server = tostring(GetConfig(strServerKey))
            if v.lastZone == zone and v.lastServer == server and v.uid == tostring(uid) then
                return v.user_name
            end
        end
    end
    return nil
end

-- 判断本次登录是否成功
function MSDKHelper:IsLoginRetOK(loginRet)
    local errorStr = '登录失败'
    if (not loginRet) then
        errorStr = '登录失败，loginRet = nil';
        SystemUICall:GetInstance():Toast(errorStr);
        return false
    end

    local retCode = loginRet.RetCode
    local bError = self:ProcessCodeError(retCode);
    if bError then
        return false;
    end

    if (not retCode or retCode ~= 0) then
        errorStr = '登录失败，retCode:' .. tostring(retCode or 0) .. '  ThirdCode:' .. tostring(ThirdCode or 0)
        SystemUICall:GetInstance():Toast(errorStr);
        return false
    end

    local pf = loginRet.Pf
    if (not pf or pf == '') then
        errorStr = '登录失败，MSDK的PF值为空，请联系官方人员';
        SystemUICall:GetInstance():Toast(errorStr);
        return false
    end

    local pfkey = loginRet.PfKey
    if (not pfkey or pfkey == '') then
        errorStr = '登录失败，MSDK的PFKey值为空，请联系官方人员';
        SystemUICall:GetInstance():Toast(errorStr);
        return false
    end

    return true
end

function MSDKHelper:ProcessCodeError(retCode)
    if retCode == 1001 then
        return true;
    end

    return false;
end

-- 心悦会员
function MSDKHelper:SVipUrl()
    local zone = tostring(GetConfig("LoginZone"));
    local strServerKey = string.format("LoginServer_%s", zone)

    local tempTable = {};
    tempTable.pid = '105';
    tempTable.gid = '1398';
    if MSDK_MODE == 2 then
        tempTable.reg = '1';
    else
        tempTable.reg = '3';
    end
    if MSDK_OS == 1 then -- android
        tempTable.plat = '1';
    elseif MSDK_OS == 2 then -- ios
        tempTable.plat = '0';
    end
    tempTable.area = zone;
    tempTable.part = tostring(GetConfig(strServerKey));
    tempTable.openid = self:GetOpenID();
    if self:GetChannel() == 'QQ' then
        tempTable.ch = '1';
        tempTable.appid = CommonTable_SeGameAppParam.acGameAppID_QQ;
    elseif self:GetChannel() == 'WeChat' then
        tempTable.ch = '2';
        tempTable.appid = CommonTable_SeGameAppParam.acGameAppID_WX;
    end
    tempTable.role = tostring(globalDataPool:getData("PlayerID"));
    tempTable.msdkt = self:GetAccessToken();
    tempTable.t = tostring(os.time());
    tempTable.r = tostring(math.random(1, 10000));
    tempTable.ava = self:GetPictureUrl();
    tempTable.nick = PlayerSetDataManager:GetInstance():GetPlayerName();
    tempTable.channelid = tostring(GetCurChannelID());
    local code = DRCSRef.GameConfig:GenAuthUrl(dkJson.encode(tempTable), 'Bui1tin#t@Clu8')
    local utl = 'https://api.xinyue.qq.com/builtin/dispatch?code=' .. code .. '&gid=1398&pid=105';
    self:OpenUrl(utl);
end

-- MSDK的公告
function MSDKHelper:OnMSDKNoticeEventCallback(kResult)
    dprint('OnMSDKNoticeEventCallback')
    -- 获取ui节点
    local winAnnounce = GetUIWindow("SystemAnnouncementUI")
    -- 是否是用户自己点开的公告
    local bIsUserClick = false
    if winAnnounce and winAnnounce:IsUserClick() then
        bIsUserClick = true
    end
    -- 获取公告列表额外信息, 公告组, 语言, 地区, 大区
    local strExtraJson = kResult.ExtraJson or ""
    -- 结束公告等待
    local DoEmptyEnd = function(strLog)
        if strLog and (strLog ~= "") then
            dprint(strLog .. ", extra info: " .. strExtraJson)
        end
        if not winAnnounce then
            return
        end
        winAnnounce:SetBoardState(NoticeState.Empty)
    end
    -- 检查返回值
    local iRetCode = kResult.RetCode
    if (iRetCode ~= 0) then
        DoEmptyEnd('OnMSDKNoticeEventCallback retCode == ' .. iRetCode)
        return
    end
    -- 检查公告列表
    local akNoticeList = kResult.NoticeInfoList
    if not akNoticeList then
        DoEmptyEnd('OnMSDKNoticeEventCallback noticeList is empty')
        return
    end
    -- 检查公告数量
    local uiNoticeCount = akNoticeList.Count
    if (uiNoticeCount == nil) or (uiNoticeCount == 0) then
        DoEmptyEnd('OnMSDKNoticeEventCallback noticeList has invalid size: ' .. tostring(uiNoticeCount))
        return
    end
    -- 当前时间戳
    local lCurTime = GetCurServerTimeStamp()
    -- 获取上一次请求公告的年月日
    local kTimetable = os.date("*t", lCurTime)
    local strValue = string.format("%d-%d-%d", kTimetable.year, kTimetable.month, kTimetable.day)
    local strNoticeTimeKey = "NoticeTime"
    local strNoticeShownKey = "NoticeShownRec"
    local strOldNoticeTime = GetConfig(strNoticeTimeKey)
    -- 如果据上次公告已经隔了超过一天, 那么清空已显示公告的列表
    if strOldNoticeTime ~= strValue then
        SetConfig(strNoticeTimeKey, strValue)
        SetConfig(strNoticeShownKey, "")
    end
    -- 获取今日已显示公告列表
    local strNoticeRec = GetConfig(strNoticeShownKey) or ""
    local kHadShownToday = string.split(strNoticeRec, "|") or {}
    local bCheckShown = {}
    for index, strNoticeID in ipairs(kHadShownToday) do
        bCheckShown[strNoticeID] = true
    end
    -- 简单使用数字 1 表示登录前公告, 2表示登录后公告
    -- 当前允许筛选出的公告类型
    local uiLegalNoticeType = IsWindowOpen("LoginUI") and 1 or 2
    -- MSDK文档定义, 公告类型 noticeType, 1000-1999表示登录前公告 2000-2999表示登录后公告
    local uiLogInNoticeMin, uiLoginNoticeMax = 1000, 1999
    local uiGameNoticeMin, uiGameNoticeMax = 2000, 2999
    local bIsLegalNotice = function(kNotice)
        if not kNotice then
            return false
        end
        local uiNoticeType = kNotice.NoticeType
        if (not uiNoticeType) or (uiNoticeType < uiLogInNoticeMin) or (uiNoticeType > uiGameNoticeMax) then
            return false
        end
        -- 检查登录前登录后
        local uiCurType = (uiNoticeType <= uiLoginNoticeMax) and 1 or 2
        if uiCurType ~= uiLegalNoticeType then
            return false
        end
        -- 检查过期
        if (kNotice.EndTime or 0) <= lCurTime then
            return false
        end
        -- 检查公告id
        if (not kNotice.NoticeId) or (kNotice.NoticeId <= 0) then
            return false
        end
        -- 检查信息包含
        if (not kNotice.TextInfo) or (not kNotice.PicUrlList) or (not kNotice.WebUrl) then
            return false
        end
        return true
    end
    -- 筛选并整理公告
    local akLuaNoticeList = {}
    local kNotice = nil
    for index = 0, uiNoticeCount - 1 do
        kNotice = akNoticeList[index]
        local bIsLegalNotice = bIsLegalNotice(kNotice)
        if bIsLegalNotice then
            -- 如果是系统自动拉取的公告, 那么, 今天公告是否已经展示过?
            local bHadShownBefore = bCheckShown[tostring(kNotice.NoticeId)]
            if (bIsUserClick == true) or (bHadShownBefore ~= true) then
                -- 将这条公告记录为已显示
                if not bHadShownBefore then
                    kHadShownToday[#kHadShownToday + 1] = kNotice.NoticeId
                end
                akLuaNoticeList[#akLuaNoticeList + 1] = kNotice
            end
        end
    end
    -- 经过筛选过后, 没有可显示的公告
    if (#akLuaNoticeList == 0) then
        -- 如果是系统自动请求的公告, 那么直接return不做任何事
        -- 如果是用户自己点击的公告, 提示没有新公告
        if bIsUserClick then
            SystemUICall:GetInstance():Toast("没有新的公告~", false)
        else
            return
        end
    end
    -- 重新组织已显示的公告列表
    strNoticeRec = table.concat(kHadShownToday, "|")
    SetConfig(strNoticeShownKey, strNoticeRec)
    -- 对公告数据进行排序
    table.sort(akLuaNoticeList, function(a, b)
        return (a.Order or 999) < (b.Order or 999)
    end)
    -- 打开或刷新ui
    if winAnnounce then
        winAnnounce:RefreshUI({
            ['akLuaNoticeList'] = akLuaNoticeList
        })
    else
        OpenWindowImmediately("SystemAnnouncementUI", {
            ['akLuaNoticeList'] = akLuaNoticeList
        })
    end
end

-- 查询公告接口
function MSDKHelper:QueryNotice(bUserClick, strGroup, strLan, iReg)
    -- pc端屏蔽msdk公告
    if g_IS_WINDOWS then
        SystemUICall:GetInstance():Toast("请使用移动端查看公告")
        return
    end
    dprint("QueryNotice")
    --  如果是用户自己点击的公告, 先打开ui并设置为加载状态
    if bUserClick == true then
        OpenWindowImmediately("SystemAnnouncementUI", {
            ['bIsUserClick'] = true
        })
    end
    -- noticeGroup string 公告分组（必填）参数为 0 可以拉取到所有分组的公告
    -- language string 公告的语种
    -- region int 地区
    -- partition  string 大区
    -- extra string 扩展字段，json格式。公告管理端中配置的过滤字段必须在 extra 中传入说明，否则无法拉取对应公告
    local argGroup = strGroup or '0'
    local argLan = strLan or "zh-CN"
    local argReg = iReg or 156 -- 地区 156 中国
    local argZone = tostring(GetConfig("LoginZone"))
    local kExtra = {}
    local argExtra = ""
    if kExtra and next(kExtra) then
        argExtra = dkJson.encode(kExtra)
    end
    DRCSRef.MSDKNotice.LoadNoticeData(argGroup, argLan, argReg, argZone, argExtra)
end

-- 上报成就数据
function MSDKHelper:SendAchievementsData(type)
    if not self:IsPlayerTestNet() then
        if self:GetChannel() == "QQ" then
            self:SendAchievementsDataToQQ(type)
        elseif self:GetChannel()=="WeChat" then
            --微信目前不需要上报数据
        end
    end
end

function MSDKHelper:InitQQAchievementData()
    if self:IsLoginQQ() ~= true then
        return
    end
    local platform = 0
    if MSDK_OS == 1 then
        platform = 1
    elseif MSDK_OS == 2 then
        platform = 0
    end

    local area = tonumber(GetConfig("LoginZone")) or 1

    local server = GetConfig(string.format("LoginServer_%s", tostring(area))) or "0"
    
    self.qqAchievementData = {
        ['platform'] = tostring(platform),-- 平台类型 ios-0 android-1
        ['area'] = tostring(area),--大区信息 大区ID
        ['server'] =  tostring(server),--服务器ID
        ['playerid'] = tostring(globalDataPool:getData("PlayerID")),--角色ID 
        ['lastlogintime'] = GetCurServerTimeStamp(),-- 最近登录时间  Unix时间戳
        ['onlinetime'] = 0,--单次游戏时长
        ['qqregistertime'] = PlayerSetDataManager:GetInstance():GetCreateTime() or 0,--首次QQ登陆时间
        ['playername'] = PlayerSetDataManager:GetInstance():GetPlayerName(),--角色名
        ['totalrechargecount'] = 0,--总充值金额
        ['rechargecount'] = 0,--单次充值金额
        ['rechargetime'] = 0,--充值时间
        ['nickname'] = PlayerSetDataManager:GetInstance():GetPlayerName(),--昵称
        ['loginchannel'] = tostring(GetCurChannelID()) or '',--登陆渠道号
        ['registerchannel'] = tostring(self:GetRegChannel()) or '',--注册渠道号
        ['totalonlinetime'] = 0,  --当天累计游戏时长
        ['meridianslevel'] = 0,  --经脉等级
        ['scriptdiff'] = 0,  --当前剧本难度
        ['scriptend'] = 0,  --剧本结束
        ['removescript'] = 0,  --手动删档
        ['clickpinball'] = 0,  --点击小侠客
        ['battlewin'] = 0,  --战斗胜利
        ['selectrole'] = 0,  --角色交互
        ['arenasignup'] = 0,  --擂台报名
        ['arenabet'] = 0,  --擂台押注
        ['achievementpoint'] = 0,  --成就点数
        ['opentreasure'] = 0,  --开启藏宝图
    }

    -- self:InitOnlineTime()
    -- if globalTimer then
    --     dprint("globalTimer:AddTimer(300000")
    --     globalTimer:AddTimer(300000,function()
    --         self:UpdateOnlineData()
    --     end)
    -- end
end

function MSDKHelper:SetQQAchievementData(key, data)
    if self.qqAchievementData then
        self.qqAchievementData[key] = data
    end
end

function MSDKHelper:SendAchievementsDataToQQ(type)
    if self:IsLoginQQ() ~= true then
        return
    end
    local loginUrlConfig = HttpHelper:GetLoginUrlConfig()
    local json1 =  {["type"]= 12,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['platform']),["expires"]="1999999999"}--平台类型 ios-0 android-1
    local json2 =  {["type"]= 26,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['area']),["expires"]="1999999999"} --大区信息 大区ID
    local json3 =  {["type"]= 27,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['server']),["expires"]="1999999999"} --服务器ID
    local json4 =  {["type"]= 28,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['playerid']),["expires"]="1999999999"} --角色ID
    local json5 =  {["type"]= 8,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['lastlogintime']),["expires"]="1999999999"} --最近登录时间  Unix时间戳
    local json6 =  {["type"]= 14,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['onlinetime']),["expires"]="1999999999"} --单次游戏时长  秒
    local json7 =  {["type"]= 25,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['qqregistertime']),["expires"]="1999999999"} --用户注册时间  
    local json8 =  {["type"]= 29,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['playername']),["expires"]="1999999999"} --角色名称 
    local json9 =  {["type"]= 43,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['totalrechargecount']),["expires"]="1999999999"} --累计充值金额 元
    local json10 =  {["type"]= 44,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['rechargecount']),["expires"]="1999999999"} --单笔充值金额 元
    local json11 =  {["type"]= 46,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['rechargetime']),["expires"]="1999999999"} --充值时间
    local json12 =  {["type"]= 47,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['nickname']),["expires"]="1999999999"} --游戏昵称
    local json13 =  {["type"]= 201,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['loginchannel']),["expires"]="1999999999"} --登录渠道号
    local json14 =  {["type"]= 202,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['registerchannel']),["expires"]="1999999999"} --注册渠道号
    local json15 =  {["type"]= 6000,["bcover"]= 2,["data"]= tostring(self.qqAchievementData['totalonlinetime']),["expires"]="1999999999"} --当天累计游戏时长
    local json16 =  {["type"]= 1,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['meridianslevel']),["expires"]="1999999999"} --经脉等级
    local json17 =  {["type"]= 2,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['scriptdiff']),["expires"]="1999999999"} --剧本难度
    local json18 =  {["type"]= 5,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['scriptend']),["expires"]="1999999999"} --剧本结束
    local json19 =  {["type"]= 6,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['removescript']),["expires"]="1999999999"} --删除剧本
    local json20 =  {["type"]= 7,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['clickpinball']),["expires"]="1999999999"} --点击小侠客
    local json21 =  {["type"]= 103,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['battlewin']),["expires"]="1999999999"} --战斗胜利
    local json22 =  {["type"]= 104,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['selectrole']),["expires"]="1999999999"} --角色交互
    local json23 =  {["type"]= 10,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['arenasignup']),["expires"]="1999999999"} --擂台报名
    local json24 =  {["type"]= 11,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['arenabet']),["expires"]="1999999999"} --擂台押注
    local json25 =  {["type"]= 3,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['achievementpoint']),["expires"]="1999999999"} --成就点数
    local json26 =  {["type"]= 105,["bcover"]= 1,["data"]= tostring(self.qqAchievementData['opentreasure']),["expires"]="1999999999"} --开启藏宝图
    
    local achievementsJsonData = {
        json1,  json2,  json3,  json4,  json5,  json6,  json7,  json8,  json9,  json10,  json11,  json12,  json13,  json14,  json15
    }
    if type then
        dprint('SendAchievementsDataToQQ:type:'..type)
        if type == "all" then --全部数据
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json5,  json6,  json7,  json8,  json9,  json10,  json11,  json12,  json13,  json14,  json15
            }
        elseif type == "time" then --在线时长相关数据
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json5,  json6,  json7,  json8, json13,  json14, json15
            }
        elseif type == "recharge" then --充值相关数据
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json8,  json9,  json10,  json11, json13,  json14
            }
        elseif type == "login" then --登录时相关数据
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json5,  json7,  json13,  json14
            }
        elseif type == "create" then --创建角色时相关数据
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json5,  json7,  json8,  json12,  json13,  json14
            }
        elseif type == "meridianslevel" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json16,  
            }
        elseif type == "scriptdiff" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json17,  
            }
        elseif type == "scriptend" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json18,  
            }
        elseif type == "removescript" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json19,  
            }
        elseif type == "clickpinball" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json20,  
            }
        elseif type == "battlewin" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json21,  
            }
        elseif type == "selectrole" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json22,  
            }
        elseif type == "arenasignup" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json23,  
            }
        elseif type == "arenabet" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json24,  
            }
        elseif type == "achievementpoint" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json25,  
            }
        elseif type == "opentreasure" then
            achievementsJsonData = {
                json1,  json2,  json3,  json4,  json26,  
            }
        end
    end

    local kJsonData = {
        ["openid"] = self:GetOpenID(),
        ["token"] = self:GetAccessToken(),
        ["achievements"] = achievementsJsonData
    }
    local kPushJsonData = dkJson.encode(kJsonData)
    --kPushJsonData = '{"openid":"9067180542967621197","token":"4B0FC79956CEC1F26385D905328A17C7","achievements":[{\"type\": 12,\"bcover\": 1,\"data\": \"1\",\"expires\":\"1999999999\"}]}'
    local paramsUrl = "?channelid="..self.loginResult.ChannelId.."&gameid=10127".."&os="..MSDK_OS.."&source=0".."&ts="..os.time().."&version=5.11.000.2960"
    --格式要求md5(path + "?" + params + body + sigkey)，
    local sigUrl = "/v2/acvm/report"..paramsUrl..kPushJsonData.."206e8c51becf7c9962af42ea6ddfdeea"
    local md5Sig = string.lower(string.gsub(DRCSRef.GameConfig:GenMD5(sigUrl),"-",""))
    local postUrl = loginUrlConfig.ReportAchievementsUrl..paramsUrl.."&sig="..md5Sig    
    dprint("SendAchievementsDataToQQ postUrl:"..postUrl)
    dprint("SendAchievementsDataToQQ kPushJsonData:"..kPushJsonData)
    HttpHelper:HttpPost(postUrl, kPushJsonData, function(result)
        if (result == nil or result.data == nil) then
            -- derror("QQ成就上传失败")
            return
        end
        dprint("QQ成就上传返回:" .. result.data)
        local resultData = dkJson.decode(result.data)
    end)
end

function MSDKHelper:SaveLocalOnlineTime()
    if self:IsLoginQQ() ~= true then
        return
    end
    local jsonOnline = CS.UnityEngine.PlayerPrefs.GetString('QQ_ONLINE_DATA')
    
    local curTime = GetCurServerTimeStamp()
    if jsonOnline and jsonOnline ~= '' then --本地已有数据
        local data = dkJson.decode(jsonOnline)
        if self:IsSameDay(data.save_time, curTime) then --已有数据和当前时间是同一天的

        else                                            --已有数据和当前数据跨天了
            self:SetQQAchievementData('onlinetime', 0)
            self:SetQQAchievementData('totalonlinetime', 0)
        end
    end
    local jsonStr = {
        ["save_time"] = GetCurServerTimeStamp(),
        ["online_time"] = self.qqAchievementData['onlinetime'] ,
        ["total_online_time"] = self.qqAchievementData['totalonlinetime']
    }
    self:SendAchievementsData('time') --上报
    dprint('SaveLocalOnlineTime:'..dkJson.encode(jsonStr))
    CS.UnityEngine.PlayerPrefs.SetString('QQ_ONLINE_DATA', dkJson.encode(jsonStr))--本地保存一下
    CS.UnityEngine.PlayerPrefs.Save()
end

function MSDKHelper:InitOnlineTime()
    if self:IsLoginQQ() ~= true then
        return
    end
    local jsonOnline = CS.UnityEngine.PlayerPrefs.GetString('QQ_ONLINE_DATA')
    if jsonOnline and jsonOnline ~= '' then --本地已有数据
        dprint('InitOnlineTime:本地已有数据')
        local data = dkJson.decode(jsonOnline)
        local curTime = GetCurServerTimeStamp()
        if self:IsSameDay(data.save_time, curTime) then --已有数据和当前时间是同一天的
            dprint('InitOnlineTime:已有数据和当前时间是同一天的')
            self:SetQQAchievementData('onlinetime', 0)
            self:SetQQAchievementData('totalonlinetime', data.total_online_time)
        else
            local jsonStr = {
                ["save_time"] = GetCurServerTimeStamp(),
                ["online_time"] = 0,
                ["total_online_time"] = 0
            }
            CS.UnityEngine.PlayerPrefs.SetString('QQ_ONLINE_DATA', dkJson.encode(jsonStr))--本地保存一下
            CS.UnityEngine.PlayerPrefs.Save()
        end
    end
end

function MSDKHelper:UpdateOnlineData()
    if self:IsLoginQQ() ~= true then
        return
    end
    self:SetQQAchievementData('onlinetime', self.qqAchievementData['onlinetime'] + 300)
    self:SetQQAchievementData('totalonlinetime', self.qqAchievementData['totalonlinetime'] + 300)
    self:SaveLocalOnlineTime()
    globalTimer:AddTimer(1000 * 60 * 5,function()
        self:UpdateOnlineData()
    end)
end

--两个时间戳是否跨天
function MSDKHelper:IsSameDay(time1, time2)
    local kCurTimetable = os.date("*t",time1)
    local kLastTimetable = os.date("*t", time2)
    if((kCurTimetable.year == kLastTimetable.year) and (kCurTimetable.month == kLastTimetable.month) and (kCurTimetable.day == kLastTimetable.day)) then
       return true          
    end
    return false
end

function MSDKHelper:IsOpenQQPrivilege()
    return self.isOpenQQPrivilege
end

function MSDKHelper:IsOpenWXPrivilege()
    return self.isOpenWXPrivilege
end

function MSDKHelper:GetShareCount()
    return self.shareCount or 0
end

function MSDKHelper:SetShareCount(count)
    self.shareCount = count
end

-- 是否是月牙村测试区
function MSDKHelper:IsPlayerTestNet()
    return MSDK_MODE == 1
end

-- 访问客服中心
function MSDKHelper:OpenServiceUrl(type)
    local urlTable = {
        ['Setting'] = "https://kf.qq.com/touch/scene_product.html?scene_id=kf7584",
        ['Login'] = 'https://kf.qq.com/touch/scene_product.html?scene_id=kf7583',
        ['Money'] = 'https://kf.qq.com/touch/scene_product.html?scene_id=kf7586',
        ['Activity'] = 'https://kf.qq.com/touch/scene_product.html?scene_id=kf7587',
        ['Main'] = 'https://kf.qq.com/touch/scene_product.html?scene_id=kf7584',
    }

    local url = urlTable[type]
    if (not url) then
        return
    end

    -- 是否安装相应app
    local isWeChatInstalled = DRCSRef.MSDKUtils.IsAppInstalled("WeChat")
    local isQQInstalled = DRCSRef.MSDKUtils.IsAppInstalled("QQ")

    local wi = 0
    local qi = 0
    if (isWeChatInstalled) then
        wi = 1
    end
    if (isQQInstalled) then
        qi = 1
    end
    -- 操作平台
    local platid = 0
    if (MSDK_OS == 1) then platid = 1 end
    if (MSDK_OS == 2) then platid = 0 end

    -- 小区id
    local areaid = 0

    -- 小区zn名
    local strZoneID = GetConfig("LoginZone") or 0
	local strServerNameKey = string.format("LoginServerName_%s", tostring(strZoneID)) or ""
    local areaname = GetConfig(strServerNameKey) or "NullZn"
    areaname = _encodeURI(areaname)

    -- 角色昵称
    local strname = PlayerSetDataManager:GetInstance():GetPlayerName() or ''
    strname = _encodeURI(strname)

    local playerid = PlayerSetDataManager:GetInstance():GetPlayerID() or 0

    local serviceurl = url .. '&qi=' .. tostring(qi) .. "&wi=" .. tostring(wi)
    serviceurl = serviceurl .."&platid=" .. tostring(platid) .. "&z=" .. tostring(areaid) .. "&zn=" .. areaname
    serviceurl = serviceurl .. "&role=" .. strname .. "&roleid=" .. tostring(playerid)

    self:OpenUrl(serviceurl)
end

function MSDKHelper:IsSpecialChannel()
    local regChannel = tostring(GetCurChannelID());
    local channelTable = {
        [CHANNEL.TAPTAP] 	= true,
        [CHANNEL.HW] 		= true,
        [CHANNEL.XM] 		= true,
        [CHANNEL.G4399] 	= true,
        [CHANNEL.HYKB] 		= true,
        [CHANNEL.BWEB] 		= true,
        [CHANNEL.OPPO] 		= true,
        [CHANNEL.VIVO] 		= true,
    }

    if channelTable[regChannel] then
       return true; 
    end
    return false;
end

function MSDKHelper:OpenCommunity()
    local channel = self:GetChannel()
    if (channel ~= "") then
        local areaid = "2"
        if (channel == "WeChat") then
            areaid = "1"
        elseif (channel == "QQ") then
            areaid = "2"
        end

        local platid = "1"
        if (MSDK_OS == 2) then
            platid = "0"
        elseif  (MSDK_OS == 1) then
            platid = "1"
        end
        --string areaid:1wx2qq,string partition,string platid:0ios1andriod,string roleid, openid
        DRCSRef.SlugManager.OpenSlug(areaid, "0", platid, "1", self:GetOpenID()) 
    else
        --string areaid:1wx2qq,string partition,string platid:0ios1andriod,string roleid, openid
        DRCSRef.SlugManager.OpenSlug("2", "0", "1", "1", self:GetOpenID()) 
    end
end

function MSDKHelper:OpenMiniApp()
    local zone = tostring(GetConfig("LoginZone"));
    local zoneName = tostring(GetConfig("LoginZoneName"));
    local strServerKey = string.format("LoginServer_%s", zone);
    local loginServerNameKey = string.format("LoginServerName_%s", zone);
    local plat = MSDK_OS == 1 and '1' or '0';
    local curScriptID = tostring(GetCurScriptID());
    local info = globalDataPool:getData("WeekRoundEnd");
    local commonInfo = PlayerSetDataManager:GetInstance():GetCommonInfo();
    local weekRoundTotalNum = commonInfo and tostring(commonInfo.weekRoundTotalNum) or '0';
    local mainRoleName = RoleDataManager:GetInstance():GetMainRoleName();
    local playerID = tostring(globalDataPool:getData("PlayerID"));
    local endType = (info and info.uiEndType and tostring(info.uiEndType)) or '0';
    local iYear, iMonth, iDay, iHour = EvolutionDataManager:GetInstance():GetRivakeTimeYMD();
    local rivakeTime = tostring(EvolutionDataManager:GetInstance():GetRivakeTime()) or '0';
    local picpath = tostring(endType) .. ".png"
    if (endType == nil or endType == "" or endType == "0" or picpath == nil or picpath == "nil") then
        picpath = "default.png"
    end
    local url = 'pages/career/career?';
    local fromUserId = string.format('fromUserId=%s', tostring(MSDKHelper:GetOpenID()));
    local partition = string.format('partition=%s', _encodeURI(tostring(GetConfig(strServerKey))))
    local partitionName = string.format('partitionName=%s', tostring(_encodeURI(GetConfig(loginServerNameKey))));
    local area = string.format('area=%s', zone);
    local areaName = string.format('areaName=%s', _encodeURI(zoneName))
    local platId = string.format('platId=%s', plat);
    local roleId = string.format('roleId=%s', playerID);
    local weeknum = string.format('weeknum=%s', weekRoundTotalNum);
    local iscriptid = string.format('iscriptid=%s', curScriptID);
    local roleName = string.format('roleName=%s', _encodeURI(mainRoleName));
    local avatarUrl = string.format('avatarUrl=%s', MSDKHelper:GetPictureUrl());
    local endingid = string.format('endingid=%s', endType);
    local endTime = string.format('endTime=%s', rivakeTime);
    url = url .. fromUserId .. "&".. partition.. "&" .. partitionName .. "&" .. area .. "&" .. areaName .. "&" .. platId .. "&" .. roleId .. "&" .. weeknum .. "&" .. iscriptid .. "&" .. roleName .. "&" .. avatarUrl .. "&" .. endingid .. "&".. endTime
    url = string.gsub(url, "&amp;", "&")
    derror(url)

    local ShareMiniApp = function(strUrl)    
        local reqInfo = DRCSRef.MSDKFriendReqInfo("{\"type\":10006}");
        if (MSDKHelper:IsLoginQQ()) then
            reqInfo.Title = "我的侠客"
            reqInfo.Desc = "查看我的侠客生涯！"
            reqInfo.ThumbPath = DRCSRef.PersistentDataPath .. "/weekend.png"
            reqInfo.Link = strUrl
            reqInfo.ExtraJson = "{\"mini_appid\":\"1110994545\",\"mini_program_type\":3,\"mini_path\":\""
            reqInfo.ExtraJson = reqInfo.ExtraJson .. strUrl
            reqInfo.ExtraJson = reqInfo.ExtraJson .. "\"}}"
            DRCSRef.MSDKFriend.SendMessage(reqInfo, "QQ");
        elseif (MSDKHelper:IsLoginWeChat()) then
            reqInfo.Title = "查看我的侠客生涯"
            reqInfo.Desc = "查看我的侠客生涯！"
            reqInfo.Link = strUrl
            reqInfo.ThumbPath = DRCSRef.PersistentDataPath .. "/weekend.png"
            reqInfo.ExtraJson = "{\"weapp_id\":\"gh_3ff96b3b7d27\",\"with_share_ticket\":\"1\",\"mini_program_type\":\"0\"}}";

            DRCSRef.MSDKFriend.SendMessage(reqInfo, "WeChat");
        end 
    end

    CS_Coroutine.start(function()
        coroutine.yield(DRCSRef.MSDKUtils.CopyFromStreamingAssetsToPersistentPath("share/weekend/" .. picpath, "weekend.png"))
        ShareMiniApp(url)
    end)
end

-- 检查是否
function MSDKHelper:IsSimulatorSupportIOS()
    if (g_IS_WINDOWS) then
        return false
    end

    if (not DEBUG_CHEAT) then
        return false
    end

    if (CS.UnityEngine.Application.platform == CS.UnityEngine.RuntimePlatform.IPhonePlayer) then
        return false
    end
        
    if (self.issimulatorSupportIOS == nil) then
        self:CheckIsSimulator()
    end

    return self.issimulatorSupportIOS
end

function MSDKHelper:CheckIsSimulator()
    self.issimulatorSupportIOS = false
    local stringRet = DRCSRef.TssSDK.Ioctl(10, "files_dir=/data/data/com.tencent.dianhun.wdxk/files|wait=1")
    if (stringRet == nil or stringRet == "") then
        return
    end

    local supportList = {"Tencent","Nox", "Netease", "LeiDian", "NOX"}

    for i = 1,#supportList do
        if (string.find(stringRet, supportList[i])) then
            self.issimulatorSupportIOS = true
            return
        end
    end 
end

return MSDKHelper

