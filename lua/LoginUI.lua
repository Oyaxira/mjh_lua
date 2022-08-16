LoginUI = class("LoginUI", BaseWindow)
ISNET = false;

local HttpHelper = require "Net/NetHttpHelper"
local dkJson = require("Base/Json/dkjson")

-- 构造函数
function LoginUI:ctor()
    self.objUIRoot_Node = nil
    self.objAccount_Node = nil
    self.objServer_Node = nil
    self.objAccount_Button = nil
    self.objStartGame_Button = nil
    self.objStandalone_Button = nil
    self.objQQLogin_Button = nil
    self.objWXLogin_Button = nil
    self.objServerState_Text = nil
    self.objServerName_Text = nil
    self.objServerState_Image = nil
    self.objWaiting = nil
end

-- 登录场景初始化
function LoginUI:Create()
    local obj = LoadPrefabAndInit("Logon/Logon", UI_MainLayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

-- 初始化本地组件信息
function LoginUI:Init()
    self.objWaiting = self:FindChild(self._gameObject, "Waiting")
    self:SetWaitingAnimState(false)
    self.objUIRoot_Node = self:FindChild(self._gameObject, "UIRoot")
    self.objGameTitle = self:FindChild(self.objUIRoot_Node, "Icon_Image")
    self.objFriendNode = self:FindChild(self.objUIRoot_Node, "TransformAdapt_node_left/Friends_Node")
    self.objAccount_Node = self:FindChild(self._gameObject, "Account_Node")
    self.objVersion_Node = self:FindChild(self._gameObject, "Version_Node")
    self.textVersion_Node = self.objVersion_Node:GetComponent("Text")
    self.objServer_Node = self:FindChild(self._gameObject, "Server_Node")
    self.objStandalone = self:FindChild(self._gameObject, "Account_Node/Standalone_Button")
    --self.objTips_Node = self:FindChild(self._gameObject, "Tips_Node")
    self.objRight_Node = self:FindChild(self._gameObject, "TransformAdapt_node_right")
    self.objAgreement_Node = self:FindChild(self._gameObject, "Agreement_Node")
    self.imgAgreement_Flag = self:FindChild(self.objAgreement_Node, "Button_choose/Image")
    self.objAgreement_Node:SetActive(false)
    self.comVideoPlayerUI = self:FindChildComponent(self._gameObject, "video", "VideoPlayer")
    self.comVideoSkipBtn = self:FindChildComponent(self._gameObject, "video/videoSkipBtn", "Button")
    self:AddButtonClickListener(self.comVideoSkipBtn,function()
        local isFirstStart=GetConfig("FirstStart")
        if isFirstStart==nil and isFirstStart ~= 1 then
            return
        end
        self:ShowLogin()
        GetUIWindow("SystemAnnouncementUI"):SetActive(true)
    end)
    self.comAudioSource = self:FindChildComponent(self._gameObject, "video", "AudioSource")
    self.comBackVideo = self:FindChildComponent(self._gameObject, "backvideo", "VideoPlayer")
    self.objAccount_Node:SetActive(false)
    self.objServer_Node:SetActive(false)
    self.objFriendNode:SetActive(false)
    self.objServerState_Text = self:FindChildComponent(self.objServer_Node, "State_Text", "Text")
    self.objServerName_Text = self:FindChildComponent(self.objServer_Node, "Name_Text", "Text")
    self.objServerName_Text.text = ""
    self.objServerState_Image = self:FindChildComponent(self.objServer_Image, "State_Image", "Text")
    self.objPlantform_list = self:FindChild(self._gameObject, "Platform_List")
    self.objAutoLogin = self:FindChild(self._gameObject, "AutoLogin_Notice")
    self.objVisitorLogin = self:FindChild(self.objPlantform_list, "Visitor_Button")
    self.objSimulator_IOSWechat_Login = self:FindChild(self.objPlantform_list, "WechatIOS_Button")
    self.objSimulator_IOSWechat_Login:SetActive(false)
    
    HttpHelper:RequestNotice(false, true, SYSTEM_ANNOUNCEMENT_TYPE.Notice)
    
    self.objSimulator_IOSQQ_Login = self:FindChild(self.objPlantform_list, "QQIOS_Button")
    self.objSimulator_IOSQQ_Login:SetActive(false)
    if (self:IsHideGuestLogin()) then
        self.objVisitorLogin:SetActive(false)
    else
        self.objVisitorLogin:SetActive(true)
    end
    self.btnVisitorLogin = self:FindChildComponent(self.objPlantform_list, "Visitor_Button", "Button")
    self:AddButtonClickListener(self.btnVisitorLogin, function()
        self:OnclickVisitorLogin()
    end)
    self.btnAppleLogin = self:FindChildComponent(self.objPlantform_list, "IOS_Button", "Button")
    self:AddButtonClickListener(self.btnAppleLogin, function()
        self:OnclickAppleLogin()
    end)

    self.objStartGame_Button = self:FindChildComponent(self.objAccount_Node, "StartGame_Button", "Button")
    if self.objStartGame_Button then
        local fun = function()
            self:OnClick_StartGame_Button()
        end
        self:AddButtonClickListener(self.objStartGame_Button, fun)
    end

    self.objServer_Button = self:FindChildComponent(self.objServer_Node, "Server_Button", "Button")
    self.rectTransServerButton = self.objServer_Button:GetComponent("RectTransform")
    if self.objServer_Button then
        local fun = function()
            OpenWindowImmediately("ServerListUI")
            -- self.objUIRoot_Node:SetActive(false)
        end
        self:AddButtonClickListener(self.objServer_Button, fun)
    end
    self.objServerState = self:FindChild(self.objServer_Node, "Server_Button/State")
    self.transServerState = self.objServerState.transform

    self.objFriend_Button = self:FindChildComponent(self.objUIRoot_Node, "TransformAdapt_node_left/Friends_Node",
                                "Button")
    if self.objFriend_Button then
        local fun = function()
            -- dprint("click friend button")
            OpenWindowImmediately("FriendListUI")
        end
        self:AddButtonClickListener(self.objFriend_Button, fun)
    end

    self.objEnterGame_Button = self:FindChildComponent(self.objServer_Node, "EnterGame_Button", "Button")
    if self.objEnterGame_Button then
        local fun = function()
            self:OnClick_EnterGame_Button()
        end
        self:AddButtonClickListener(self.objEnterGame_Button, fun)
    end

    self.objQQLogin_Button = self:FindChildComponent(self.objAccount_Node, "QQLogin_Button", "Button")
    if self.objQQLogin_Button then
        local fun = function()
            MSDKHelper:SDKLogin('qq')
        end
        self:AddButtonClickListener(self.objQQLogin_Button, fun)
    end

    self.objWXLogin_Button = self:FindChildComponent(self.objAccount_Node, "WXLogin_Button", "Button")
    if self.objWXLogin_Button then
        local fun = function()
            MSDKHelper:SDKLogin('wx')
        end
        self:AddButtonClickListener(self.objWXLogin_Button, fun)
    end

    self.comSimulatorWXLogin_Button = self:FindChildComponent(self.objPlantform_list, "WechatIOS_Button", "Button")
    if (self.comSimulatorWXLogin_Button) then
        local func = function()
            MSDK_OS = 2
            self:OnClick_Wechat_Button(true)
        end
        self:AddButtonClickListener(self.comSimulatorWXLogin_Button, func)
    end

    self.comSimulatorQQLogin_Button = self:FindChildComponent(self.objPlantform_list, "QQIOS_Button", "Button")
    if (self.comSimulatorQQLogin_Button) then
        local func = function()
            MSDK_OS = 2
            self:OnClick_QQ_Button(true)
        end
        self:AddButtonClickListener(self.comSimulatorQQLogin_Button, func)
    end

    self.objNotice_Button = self:FindChildComponent(self.objAccount_Node, "Notice_Button", "Button")
    if self.objNotice_Button then
        local fun = function()
            MSDKHelper:GetNotice('1')
        end
        self:AddButtonClickListener(self.objNotice_Button, fun)
    end

    self.objWeb_Button = self:FindChildComponent(self.objAccount_Node, "Web_Button", "Button")
    if self.objWeb_Button then
        local fun = function()
            MSDKHelper:SDKOpenUrl('www.baidu.com')
        end
        self:AddButtonClickListener(self.objWeb_Button, fun)
    end

    self.comupdate_Button = self:FindChildComponent(self.objAccount_Node, "Update_Button", "Button")
    if self.comupdate_Button then
        local fun = function()
            OpenWindowImmediately("UpdateUI")
        end
        self:AddButtonClickListener(self.comupdate_Button, fun)
    end

    self.objAccount_Node:SetActive(false)

    self.objStandalone_Button = self:FindChildComponent(self._gameObject, "Standalone_Button", "Button")
    self.objStandalone_Button.gameObject:SetActive(true)
    if self.objStandalone_Button then
        local fun = function()
            self:OnClick_Standalone_Button()
        end
        self:AddButtonClickListener(self.objStandalone_Button, fun)
    end

    self.objWechatLogin_Button = self:FindChildComponent(self.objPlantform_list, "Wechat_Button", "Button")
    if (self.objWechatLogin_Button) then
        local fun = function()
            self:OnClick_Wechat_Button()
        end

        self:AddButtonClickListener(self.objWechatLogin_Button, fun)
    end
    self.objWechatLogin = self:FindChild(self.objPlantform_list, "Wechat_Button")

    self.objQQLogin_Button = self:FindChildComponent(self.objPlantform_list, "QQ_Button", "Button")
    if (self.objQQLogin_Button) then
        local fun = function()
            self:OnClick_QQ_Button()
        end

        self:AddButtonClickListener(self.objQQLogin_Button, fun)
    end

    self.objQQLogin = self:FindChild(self.objPlantform_list, "QQ_Button")

    self.objLogout_Button = self:FindChildComponent(self.objRight_Node, "ChangeAccount_Button", "Button")
    if (self.objLogout_Button) then
        local fun = function()
            self:OnClick_ChangeAccountButton()
            --OpenWindowImmediately("LoginAggrementUI")
            SetConfig("Login_IsAgreeMent", false)
        end
        self:AddButtonClickListener(self.objLogout_Button, fun)
    end

    self.objGameNotice_Button = self:FindChildComponent(self.objRight_Node, "Announcement_Button", "Button")
    if (self.objGameNotice_Button) then
        local fun = function()
            self:OnClick_GameNoticeButton()
        end
        self:AddButtonClickListener(self.objGameNotice_Button, fun)
    end

    self.comService_Button = self:FindChildComponent(self.objRight_Node, "Button_Tencent_KF", "Button")
    if (self.comService_Button) then
        local fun = function()
            MSDKHelper:OpenServiceUrl("Login")
        end
        self:AddButtonClickListener(self.comService_Button, fun)
    end
    
    self.comAgreement_Button = self:FindChildComponent(self.objAgreement_Node, "Button_choose", "Button")
    if (self.comAgreement_Button) then
        local fun = function()
            self:SetAgreeMent(not self.isAgreement)
        end
        self:AddButtonClickListener(self.comAgreement_Button, fun)
    end

    self.comPrivateLink1 = self:FindChildComponent(self.objAgreement_Node, "Link_1", "Button")
    if (self.comPrivateLink1) then
        local fun = function()
            MSDKHelper:OpenContractUrl()
        end
        self:AddButtonClickListener(self.comPrivateLink1, fun)
    end
    self.comPrivateLink2 = self:FindChildComponent(self.objAgreement_Node, "Link_2", "Button")
    if (self.comPrivateLink2) then
        local fun = function()
            MSDKHelper:OpenPrivacyGuideUrl()
        end
        self:AddButtonClickListener(self.comPrivateLink2, fun)
    end
    self.comPrivateLink3 = self:FindChildComponent(self.objAgreement_Node, "Link_3", "Button")
    if (self.comPrivateLink3) then
        local fun = function()
            MSDKHelper:OpenPrivacyGuideChildrenUrl()
        end
        self:AddButtonClickListener(self.comPrivateLink3, fun)
    end

    
    self.ObjActionList = self:FindChild(self._gameObject,'ActionList')
    self.ObjSubPanel = self:FindChild(self._gameObject,'SubPanel')
    self.ObjSubActionList = self:FindChild(self._gameObject,'SubPanel/SubActionList')
    -- self.ObjRelatedPanel = self:FindChild(self._gameObject,'RelatedPanel')
    -- self.ObjRelatedActionList = self:FindChild(self._gameObject,'RelatedPanel/RelatedActionList')
    self.ObjActionChild = self:FindChild(self._gameObject,'ActionChild')
    self.ObjActionChild:SetActive(false)
    self.objMask = self:FindChild(self._gameObject,'Mask')
    --点击按钮执行函数
    self.onclickFunc = nil
    self.clickTime = 0
    self.isClick = false

    --self:ShowLogin()
    --点击按钮后 重新回到主界面 不会那么快刷新 需要自己将点击背景图片setActive false
    -- self.objClick = nil
end

function LoginUI:CheckVersionCallback()
    if (self:IsAccessState()) then
        -- 判断当前版本号是否在提审版本中
        local isCheckVersion = false
        if (ClientConfigHelper:GetInstance():ShowIOSCheckVersionState()) then
            isCheckVersion = true
        end
        if not isCheckVersion then
            MSDK_MODE = 2
        end
    end
end

function LoginUI:VideoInit()
    self.objUIRoot_Node:SetActive(false)
    GetUIWindow("SystemAnnouncementUI"):SetActive(false)
    -- local kPath = {"Video/login_1","Video/login_2","Video/login"} --暂时去掉cg动画
    -- path1 其实是挂在loginui.prefab上面的 防止闪烁
    -- 这边直接从path2开始
    --local kPath = {"Video/login_2","Video/login_1"}
    local kPath = {"Video/login"}
    local iSpeed = {1, 1.5, 1, 1}
    local iIndex = 1
    local ShowLogin = nil
    local iMaxShow = #kPath
    --local iNextShowTime = GetConfig("FirstStart")
    local bNeedShowVideo = false
    -- 每天只有第一次启动 需要显示电魂腾讯的视频
    -- 单机只有初次进行游戏时播放
    -- if false then
    --     local kNextShowTime = os.date("*t", iNextShowTime)
    --     local kNow = os.date("*t")
    --     if kNow.day ~= kNextShowTime.day or kNow.month ~= kNextShowTime.month or kNow.year ~= kNextShowTime.year then
    --         SetConfig("FirstStart",os.time())
    --     else
    --         bNeedShowVideo = false
    --         self:ShowLogin()
    --     end
    -- else
    --     --SetConfig("FirstStart",os.time())
    -- end
    
    CS.UnityEngine.Application.targetFrameRate = -1

    if true then

        local pointReach = function()
            iIndex = iIndex + 1
            if iIndex > iMaxShow then
                ShowLogin()
                return
            end
            local clip = LoadPrefab(kPath[iIndex], typeof(DRCSRef.VideoClip))
            if clip ~= nil then
                self.comVideoPlayerUI.clip = clip
                self.comVideoPlayerUI.playbackSpeed = iSpeed[iIndex]
                self.comVideoPlayerUI:Play()
            end
        end
    
        ShowLogin = function()
            SetConfig("FirstStart",1)
            GetUIWindow("SystemAnnouncementUI"):SetActive(true)
            self.comVideoPlayerUI:loopPointReached("-", pointReach)
            self:ShowLogin()
        end
        self.comVideoPlayerUI:loopPointReached("+", pointReach)
    end
end

function LoginUI:ShowLogin()
    self.comVideoPlayerUI.gameObject:SetActive(false)
    self.comBackVideo.gameObject:SetActive(true)
    self.objMask:SetActive(false)
    local bCall = false;
    local videoReached = nil
    videoReached = function()
        if not bCall then     
            bCall = true 
            self:VideoReached()
            self.comBackVideo:started("-", videoReached)
        end
    end

    self.comBackVideo:started("+", videoReached)
    self:AddTimer(2000, function()
        xpcall(function()
            videoReached()
        end, function()
            derror("LoginUI VideoReached error")
        end)
    end)
end

function LoginUI:VideoReached()
    -- 获取版本号
    if (MSDK_OS == 2) then
        self:CheckVersionCallback()
    end

    local electricMode = GetConfig("confg_ElectricMode")
    if electricMode == 1 or electricMode == nil then
        CS.UnityEngine.Application.targetFrameRate = 60
    else
        CS.UnityEngine.Application.targetFrameRate = 30
    end
    self.objUIRoot_Node:SetActive(true)

    self.isAgreement = GetConfig("Login_IsAgreeMent")
    self:SetAgreeMent(self.isAgreement)
    if (not self.isAgreement) then
        --OpenWindowImmediately("LoginAggrementUI")
    end

    self.funcRebuildRect = CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate


    self:Init_OffLineLogin()
    -- self:ShowViewInitState()
    -- self:Init_PublishState()

    -- self:ShowAppleLoginButton()
    -- self:CheckWXInstallForIOS()
	-- self:ShowSimulatorIOSButton()

    -- if (self:IsAccessState() or self:IsChinaJoy()) then
    --     self:HideLoginButton(true)
    -- end

    PlayMusic(BGMID_LOGIN)
    self:SetCurVersion()
    PlayerSetDataManager:GetInstance():SetLoginFlag(true)

    -- 部分场景不查询公告
    if (MSDK_MODE == 8) then
        return
    end
    -- 进入登录界面马上请求一次公告数据
    -- HttpHelper:RequestNotice(false, false)
    -- 现在换成接MSDK公告, QQ或微信登录之后再去请求公告
end

function LoginUI:RefreshUI()
    -- 初始化不要在Init里做，放到视频播放完毕后
    --local firstStart = GetConfig("FirstStart")
    --SetConfig("FirstStart",0)
    local SkipVideo = GetConfig("confg_Video") == 2
    if not SkipVideo and g_isStart == nil then
        g_isStart = 1
        xpcall(function()
            self:VideoInit()
        end, function()
            self:VideoReached()
        end)
        if self.bShowLogin then
            self.objUIRoot_Node:SetActive(true)
        end
    else
        self.bShowLogin = true
        self:ShowLogin()
    end
    self:RefreshBGImage()
end

-- 显示初始状态, 除了各个渠道的登陆按钮和游戏标题, 其他都不显示
function LoginUI:ShowViewInitState()
    self.objGameTitle:SetActive(true)
    self.objPlantform_list:SetActive(false)
    self.objAccount_Node:SetActive(false)
    self.objServer_Node:SetActive(false)
    self.objRight_Node:SetActive(false)
    self.objFriendNode:SetActive(false)
end

function LoginUI:DeviceGuestLogin()
    self.objPlantform_list:SetActive(false)
    self.objRight_Node:SetActive(false)
    local systemInfo = DRCSRef.GameConfig:GetSystemInfo()
    local _, deviceUId = systemInfo:TryGetValue('deviceUId')
    -- SystemUICall:GetInstance():Toast('游客登录测试')
    GlobalPublicLoginValidate(0, deviceUId, deviceUId, MSDK_OS, 0)
end

function LoginUI:GuestLogin()
    DRCSRef.MSDKLogin.Login("Guest")
end

function LoginUI:HideLoginButton(active)
    if (active == true) then
        self.objWechatLogin:SetActive(false)
        self.objQQLogin:SetActive(false)
    elseif (active == false) then
        self.objWechatLogin:SetActive(true)
        self.objQQLogin:SetActive(true)
    end
end

-- 点击游客登录
function LoginUI:OnclickVisitorLogin()
    self.objFriendNode:SetActive(false)

    if (MSDK_MODE == 2 and MSDK_OS == 2) then
        SystemUICall:GetInstance():Toast("服务器爆满，请更换登录方式")
        return
    end
    g_IS_AUTOLOGIN = false

    -- MSDK渠道登录状态,应用于 IOS提审服
    if (self:IsDeviceGuestLogin()) then
        self:GuestLogin()
    -- 账号密码登录状态,应用 内网和白马湖漫展服务器
    elseif (self:IsLoginAccountPassword()) then
        self:Init_DevState()
    else
        SystemUICall:GetInstance():Toast("服务器爆满，请更换登录方式")
    end
end

-- 是否是评审状态
function LoginUI:IsAccessState()
    return (MSDK_MODE == 9)
end

-- 是否是漫展状态
function LoginUI:IsChinaJoy()
    return (MSDK_MODE == 8)
end

-- 是否允许游客登录状态
function LoginUI:IsDeviceGuestLogin()
    -- 关闭游客登录的情况
    -- if (g_IS_WINDOWS) then
    --     return false
    -- end
    if (MSDK_MODE == 2) then
        return false
    end

    return (MSDK_MODE == 9 or MSDK_MODE == 6 or MSDK_MODE == 7)
end

-- 是否需要隐藏游客登录
function LoginUI:IsHideGuestLogin()
    if (MSDK_OS == 1) and (MSDK_MODE == 2) and (not DEBUG_MODE) then
        return true
    end

    if (MSDK_OS == 2 and (MSDK_MODE ~= 2 and MSDK_MODE ~= 9 and MSDK_MODE ~= 0)) then
        return true
    end

    if(g_IS_SIMULATORIOS) then
        return true
    end

    return false
end

------- 苹果登录 start --------

function LoginUI:OnclickAppleLogin()
    if (MSDK_OS ~= 2) then
        SystemUICall:GetInstance():Toast('服务器爆满，请更换登录方式')
        return
    end

    if (MSDK_MODE == 2) then
        SystemUICall:GetInstance():Toast('服务器爆满，请更换登录方式')
        return
    end
    DRCSRef.MSDKLogin.Login("Apple")
end

-- 目前ios评审服打开apple登录
function LoginUI:ShowAppleLoginButton()
    self.btnAppleLogin.gameObject:SetActive(false)
    if (MSDK_OS == 2 and (MSDK_MODE == 9 or MSDK_MODE == 2)) then
        self.btnAppleLogin.gameObject:SetActive(true)
    end
end

-- 判定是否是支持IOS的模拟器状态，如果是的话打开IOS登录
function LoginUI:ShowSimulatorIOSButton()
    self.objSimulator_IOSWechat_Login:SetActive(false)
    self.objSimulator_IOSQQ_Login:SetActive(false)
    if (MSDKHelper:IsSimulatorSupportIOS()) then
        self.objSimulator_IOSWechat_Login:SetActive(true)
        self.objSimulator_IOSQQ_Login:SetActive(true)
    end
end

-- ios上如果没有安装微信则屏蔽微信登录渠道按钮
function LoginUI:CheckWXInstallForIOS()
    if (MSDK_OS == 2) then
        local isWeChatInstalled = DRCSRef.MSDKUtils.IsAppInstalled("WeChat")
        if (isWeChatInstalled) then
            self.objWechatLogin_Button.gameObject:SetActive(true)
        else
            self.objWechatLogin_Button.gameObject:SetActive(false)
        end
    end
end

------- 苹果登录 end --------

-- 是否账号密码自动登录状态
function LoginUI:IsAutoAccountPassword()
    return (MSDK_MODE == 8)
end

-- 自动生成5位账号
function LoginUI:GenerateAccount()
    local ret = ""
    for i = 1, 5 do
        ret = ret .. tostring(math.random(9))
    end

    return ret
end

-- 是否是账号密码登录状态
function LoginUI:IsLoginAccountPassword()
    return (MSDK_MODE == 0) or g_IS_WINDOWS or (MSDK_MODE == 8)
end

-- 获取当前版本号
function LoginUI:GetCurVersion()
    local strVersion = CLIENT_VERSION or "1.2.0.0"
    return strVersion
end

-- 设置当前版本号
function LoginUI:SetCurVersion()
    if not self.textVersion_Node then
        return
    end
    local strVersion = self:GetCurVersion()
    if not strVersion then
        return
    end
    self.textVersion_Node.text = ""
end

-- 内网开发状态初始化
function LoginUI:Init_DevState()
    -- 直接显示账号，密码，单机登录等一系列按钮
    self.objPlantform_list:SetActive(false)
    self.objFriendNode:SetActive(false)
    self.objGameTitle:SetActive(true)
    self.objAccount_Node:SetActive(false)
    self.objRight_Node:SetActive(false)
    -- 初始化的时候根据配置文件设置帐号和密码
    local objAccount_InputField = self:FindChildComponent(self.objAccount_Node, "Account_InputField", "InputField")
    local objPassword_InputField = self:FindChildComponent(self.objAccount_Node, "Password_InputField", "InputField")

    -- self.textVersion_Node.text = "Version: " .. CommonTable_SeCheckVersion.byMain .. ".".. CommonTable_SeCheckVersion.bySub1 .. ".".. CommonTable_SeCheckVersion.bySub2 .. "." .. CommonTable_SeCheckVersion.bySub3
    objAccount_InputField.text = GetConfig("AccountID") or ""
    objPassword_InputField.text = GetConfig("Password") or ""

    if (self:IsAutoAccountPassword()) then
        objAccount_InputField.text = self:GenerateAccount()
        objPassword_InputField.text = "123456"

        self:OnClick_StartGame_Button()
    end
end
local tabMapOffLineLogin = {
    {['name'] = '开始游戏',['Action'] = 'OffLineLoginAction_BeginGame',['Arrow'] = false},
    {['name'] = '周目累计',['Action'] = 'OffLineLoginAction_OpenSubBtnPanel',['Arrow'] = true},
    {['name'] = '游戏设置',['Action'] = 'OffLineLoginAction_GameSetting',['Arrow'] = false},
    {['name'] = '查看公告',['Action'] = 'OffLineLoginAction_AnnouncementUI',['Arrow'] = false},
    {['name'] = '致谢名单',['Action'] = 'OffLineLoginAction_ThankAnnouncementUI',['Arrow'] = false},
    --{['name'] = '问卷调查',['Action'] = 'OffLineLoginAction_Questionnaire',['Arrow'] = false},
    --{['name'] = '创意工坊',['Action'] = 'OffLineLoginAction_CreativeWorkshop',['Arrow'] = false},
    {['name'] = '读档/存档',['Action'] = 'OffLineLoginAction_SaveFile',['Arrow'] = false},
    {['name'] = '退出游戏',['Action'] = 'OffLineLoginAction_GuitGame',['Arrow'] = false},
}

local tabMapSubBtn = {
    {['name'] = '奇经八脉',['Action'] = 'OffLineLoginAction_Merdians',['Arrow'] = false},
    {['name'] = '周目仓库',['Action'] = 'OffLineLoginAction_Storage',['Arrow'] = false},
    {['name'] = '成就一览',['Action'] = 'OffLineLoginAction_Achievement',['Arrow'] = false},
    {['name'] = '江湖收藏',['Action'] = 'OffLineLoginAction_Collection',['Arrow'] = false},
}

-- local tabGameRelatedBtn = {
--     {['name'] = '游戏设置',['Action'] = 'OffLineLoginAction_GameSetting',['Arrow'] = false},
--     {['name'] = '查看公告',['Action'] = 'OffLineLoginAction_AnnouncementUI',['Arrow'] = false},
--     {['name'] = '问卷调查',['Action'] = 'OffLineLoginAction_Questionnaire',['Arrow'] = false},
-- }

function LoginUI:OffLineLoginAction_OpenSubBtnPanel()
    if self.ObjSubPanel.activeSelf then
        return
    end
    self:InitBtn(self.ObjSubActionList,tabMapSubBtn)
    self.ObjSubPanel:SetActive(true)
end

-- function LoginUI:OffLineLoginAction_Setting()
--     if self.ObjRelatedPanel.activeSelf then
--         return
--     end
--     self:InitBtn(self.ObjRelatedActionList,tabGameRelatedBtn)
--     self.ObjRelatedPanel:SetActive(true)
-- end

-- 单机登录初始化
function LoginUI:Init_OffLineLogin()
    self:InitBtn(self.ObjActionList,tabMapOffLineLogin)
    -- self:InitBtn(self.ObjSubActionList,tabMapSubBtn)
    -- self:InitBtn(self.ObjRelatedActionList,tabGameRelatedBtn)
end

function LoginUI:InitBtn(objActionList,tabMapBtn)
    RemoveAllChildren(objActionList)
    local txtColorList = 
    {
        [1] = DRCSRef.Color(203/255,212/255,245/255,1),
        [2] = DRCSRef.Color(1,1,1,1),
        [3] = DRCSRef.Color(193/255,1,1,1),
    }
    for i,akData in ipairs(tabMapBtn) do 
        local objChild = CloneObj(self.ObjActionChild,objActionList)
        akData.objChild = objChild
        objChild:SetActive(true)

        local comText = self:FindChildComponent(objChild,"ActionTextChild","Text")
        local objImgList = {}
        objImgList[1] = self:FindChild(objChild,"NormalImg")
        objImgList[2] = self:FindChild(objChild,"PassImage")
        objImgList[3] = self:FindChild(objChild,"ClickImage")

        local imagePass = objImgList[2]:GetComponent("Image")
        local objArrow =  self:FindChild(objChild,"ArrowImg")
        objArrow:SetActive(akData.Arrow)
        --local imageNormal = objImgList[1]:GetComponent("Image")

        --local comImage = objChild:GetComponent("Image")
        comText.text = akData.name
        local comLuaAction = objChild:GetComponent('LuaUIAction')
        if comLuaAction then 
            comLuaAction:SetPointerClickAction(function()
                objImgList[3]:SetActive(true)
                objImgList[2]:SetActive(false)
                comText.color = txtColorList[3]
                if self[akData.Action] then 
                    self.onclickFunc = self[akData.Action]
                    self.isClick = true
                end 
            end )
            comLuaAction:SetPointerEnterAction(function()
                -- objImgList[2]:SetActive(true)
                -- objImgList[1]:SetActive(false)
                comText.color = txtColorList[2]
                imagePass.color = txtColorList[2]
            end )
            comLuaAction:SetPointerExitAction(function()
                objImgList[1]:SetActive(true)
                objImgList[2]:SetActive(false)
                objImgList[3]:SetActive(false)
                comText.color = txtColorList[1]
                imagePass.color = txtColorList[2]
                -- Twn_Fade(nil, comText, 255, 128, 0.1)
                -- if imagePass then
                --     Twn_Fade(nil, imagePass, 255, 128, 0.1, nil,function ()
                --         objImgList[1]:SetActive(true)
                --         objImgList[2]:SetActive(false)
                --         objImgList[3]:SetActive(false)
                --         comText.color = txtColorList[1]
                --         imagePass.color = txtColorList[2]
                --     end)
                -- end
            end )
        end
    end 
end

--延时触发函数 time单位为ms 默认为50ms
function LoginUI:DelayTrigger(gameObject,time)
    if not time then
        time = 50
    end
    if gameObject.activeSelf then
        globalTimer:AddTimer(
            time,
            function()
                gameObject:SetActive(false)
            end,
            1
        )
    end
end

function LoginUI:Update()
    if CS.UnityEngine.Input:GetMouseButtonUp(0) then    --点击事件结束之后如果按钮子面板处于开启状态关闭子按钮面板
        self:DelayTrigger(self.ObjSubPanel)
        -- self:DelayTrigger(self.ObjRelatedPanel)
    end
    if self.isClick then
        self:DelayTrigger(self.ObjSubPanel)             --按钮点击事件开始时关闭子按钮面板
        -- self:DelayTrigger(self.ObjRelatedPanel)
        self.clickTime = self.clickTime + 1 
        if self.clickTime == 3 then
            self.clickTime = 0 
            if self.onclickFunc then
                self.onclickFunc(self)
                --self.objClick:SetActive(false)
            end
            self.isClick = false
        end
    end
    if IsNotInGuide() then
		if not IsAnyWindowOpen(NavigationHotKeyInvalidWindows) then
            if GetKeyDownByFuncType(FuncType.OpenSaveFileUI) then
				OpenWindowImmediately("SaveFileUI")
			end
        end
     end
end

function LoginUI:OffLineLoginAction_BeginGame()
    -- OpenWindowImmediately("LoadingUI")
    -- ChangeScenceImmediately("Town", "LoadingUI", function()
    local kStoryUI = OpenWindowImmediately("StoryUI")
    if kStoryUI then
        kStoryUI:StartAnimaition()
    end
    -- end)
end 
function LoginUI:OffLineLoginAction_GuitGame() 
    TipsQuitGame()
end 

function LoginUI:OffLineLoginAction_Merdians()
    if CLOSE_EXPERIENCE_OPERATION then
        SystemUICall:GetInstance():Toast('体验版暂不开放')
        return
    else
        SendMeridiansOpr(SMOT_REFRESH_ALL, 0)
        OpenWindowImmediately("MeridiansUI")
    end
    
end 
function LoginUI:OffLineLoginAction_Storage()
    if CLOSE_EXPERIENCE_OPERATION then
        SystemUICall:GetInstance():Toast('体验版暂不开放')
        return
    else
        local info = {}
	    info.auiNewItems = StorageDataManager:GetInstance():GetRecordStoryEndItems()
	    OpenWindowImmediately("StorageUI", info)	
    end
	
end 
function LoginUI:OffLineLoginAction_Achievement()
    if CLOSE_EXPERIENCE_OPERATION then
        SystemUICall:GetInstance():Toast('体验版暂不开放')
        return
    else
        OpenWindowImmediately("AchievementAchieveUI")
    end
end 
function LoginUI:OffLineLoginAction_Collection()
    if CLOSE_EXPERIENCE_OPERATION then
        SystemUICall:GetInstance():Toast('体验版暂不开放')
        return
    else
        OpenWindowImmediately("CollectionUI")
        SendUpdateCollectionPoint()
    end
end 

function LoginUI:OffLineLoginAction_GameSetting()
    OpenWindowImmediately("PlayerSetUI",{['bIfInLoginUI']= true})
end 

function LoginUI:OffLineLoginAction_AnnouncementUI()
    HttpHelper:RequestNotice(false, true, SYSTEM_ANNOUNCEMENT_TYPE.Notice)
end 

function LoginUI:OffLineLoginAction_ThankAnnouncementUI()
    HttpHelper:RequestNotice(false, true,SYSTEM_ANNOUNCEMENT_TYPE.Thank)
end 

function LoginUI:OffLineLoginAction_Questionnaire()
    local url = "https://www.wjx.cn/vj/w1KWnJE.aspx"
    CS.UnityEngine.Application.OpenURL(url);
end 

function LoginUI:OffLineLoginAction_CreativeWorkshop()
    local bAgree = GetConfig(G_UID.."CreateWorkAgrre")
    if not bAgree then
        OpenWindowImmediately("CreativeWorkAgreementUI")
    else
        OpenWindowImmediately("CreativeWorkMainUI")
    end
end

function LoginUI:OffLineLoginAction_SaveFile()
    OpenWindowImmediately("SaveFileUI")
end

-- 正式线上状态初始化
function LoginUI:Init_PublishState()
    -- 先进行MSDK的初始化工作
	if self.isAgreement and MSDKHelper then
		MSDKHelper:InitSDK()
    end

    if g_IS_WINDOWS then
        return
    end

    if (self:IsAccessState() == true) then
        return
	end
	
    if self.isAgreement then
        -- TODO 异账号切换等 LoginUI 加载之后再切换账号
        if MSDKHelper.otherAccount then
            DRCSRef.MSDKLogin.SwitchUser(true);
        end

        if (MSDKHelper.loginWeChatAutoRun) then
            MSDKHelper.loginWeChatAutoRun = nil
            DRCSRef.MSDKLogin.Login("WeChat")
        elseif (MSDKHelper.loginQQAutoRun) then
            MSDKHelper.loginQQAutoRun = nil
            DRCSRef.MSDKLogin.Login("QQ")
        else
            DRCSRef.MSDKLogin:AutoLogin()
        end
    end
end

-- 进入MSDK选择登录页面
function LoginUI:EnterMSDKPublishLogin()
    dprint("LoginUI:EnterMSDKPublishLogin ")
    -- 界面更新
    self.objAutoLogin:SetActive(false)
    self.objPlantform_list:SetActive(false)
    --self.objTips_Node:SetActive(true)
    self.objGameTitle:SetActive(true)
    self.objRight_Node:SetActive(false)
    self.objServer_Node:SetActive(false)
    self.objFriendNode:SetActive(false)
    self.objAccount_Node:SetActive(false)
    --self.objAgreement_Node:SetActive(false)
end

-- 进入游戏服务器登录页面
function LoginUI:EnterGamePublishLogin()
    dprint("LoginUI:EnterGamePublishLogin ")
    -- 界面更新
    self.objAutoLogin:SetActive(false)
    self.objPlantform_list:SetActive(false)
    self.objServer_Node:SetActive(false)
    self.objGameTitle:SetActive(false)
    -- self.objTips_Node:SetActive(false)
    self.objRight_Node:SetActive(true)
    --self.objAgreement_Node:SetActive(true)
    -- 去查询服务器列表
    QueryLoginValidate()
end

function LoginUI:FreshFriendInfo()
    if MSDKHelper:GetToken() then
        local callback = function(friendInfoList)
            if (friendInfoList ~= nil) then
                if (#friendInfoList > 0) then
                    local loginUI = GetUIWindow('LoginUI')
                    if (loginUI) then
                        local headNode = loginUI:FindChild(loginUI.objFriendNode, "Head_node")
                        local headSetNum = headNode.transform.childCount - 1
                        local friendListNum = #friendInfoList - 1
                        for index = 0, headSetNum do
                            headNode.transform:GetChild(index).gameObject:SetActive(false)
                            if (index <= friendListNum) then
                                local picSize = "40"
                                if (MSDKHelper:GetChannelId() == 1) then
                                    picSize = "/46"
                                end
                                GetHeadPicByUrl(friendInfoList[index + 1].picture_url .. picSize, function(sprite)
                                    -- dprint("setHeadPic"..friendInfoList[index+1].user_name)
                                    if (GetUIWindow('LoginUI') and headNode) then
                                        transChild = headNode.transform:GetChild(index)
                                        childHead = loginUI:FindChildComponent(transChild.gameObject, "head", "Image")
                                        childHead.sprite = sprite
                                        transChild.gameObject:SetActive(true)
                                    end
                                end)
                            end
                        end
                        -- 有回调才显示
                        loginUI.objFriendNode:SetActive(true)
                    end
                end
            end
        end
        ---获取好友链入口 返回的是serverFriendInfoList
        MSDKHelper:FriendInit(callback)
    end
end

-- 点击切换账号
function LoginUI:OnClick_ChangeAccountButton()
    dprint("OnClick_ChangeAccountButton")
    local channel = MSDKHelper:GetChannel()
    if (channel ~= nil and channel ~= "") then
        DRCSRef.MSDKLogin.Logout("", "", false)
    end
    if (g_IS_SIMULATORIOS) then
        MSDK_OS = 1
        g_IS_SIMULATORIOS = nil
    end
    -- 手动切换账号的不走自动登录
    g_IS_AUTOLOGIN = false

    self:EnterMSDKPublishLogin()
end

-- 点击查询公告
function LoginUI:OnClick_GameNoticeButton()
    dprint("OnClick_GameNoticeButton")

    -- 先走电魂自己的公告
    -- HttpHelper:RequestNotice(false, true)
    -- MSDK 的公告
    MSDKHelper:QueryNotice(true)
end

-- 点击单机模式
function LoginUI:OnClick_Standalone_Button()
    dprint("OnClick_Standalone_Button")
    globalDataPool:setData("GameMode", "ServerMode")
    DRCSRef.LogicMgr:Initialize()
    
    OnGameNetConnected()
    -- ChangeScenceImmediately("House", "LoadingUI", function()
    --     OpenWindowImmediately("HouseUI")
    --     globalDataPool:setData("online", "false")
    -- end)
end

-- 微信登录
function LoginUI:OnClick_Wechat_Button(issimulatorIOS)
    dprint("LoginUI:OnClick_Wechat_Button")
    if (issimulatorIOS) then
        MSDK_OS = 2
        g_IS_SIMULATORIOS = true
    else
        g_IS_SIMULATORIOS = false
    end

    -- 只要是手动点击拉起的，都不走自动登录
    g_IS_AUTOLOGIN = false

    local isWeChatInstalled = DRCSRef.MSDKUtils.IsAppInstalled("WeChat")
    if (isWeChatInstalled) then
        DRCSRef.MSDKLogin.Login("WeChat")
    else
        DRCSRef.MSDKLogin.Login("WeChat", "", "", "{\"QRCode\":true}")
    end
end

-- QQ登录
function LoginUI:OnClick_QQ_Button(issimulatorIOS)
    dprint("LoginUI:OnClick_QQ_Button")
    if (issimulatorIOS) then
        MSDK_OS = 2
        g_IS_SIMULATORIOS = true
    else
        g_IS_SIMULATORIOS = false
    end
    -- 只要是手动点击拉起的，都不走自动登录
    g_IS_AUTOLOGIN = false
    DRCSRef.MSDKLogin.Login("QQ")
end

-- 点击开始游戏，内网的账号密码登录
function LoginUI:OnClick_StartGame_Button()
    dprint("OnClick_StartGame_Button")
    local objAccount_InputField = self:FindChildComponent(self.objAccount_Node, "Account_InputField", "InputField")
    local objPassword_InputField = self:FindChildComponent(self.objAccount_Node, "Password_InputField", "InputField")
    local sAccount = objAccount_InputField.text
    local sPassword = objPassword_InputField.text

    globalDataPool:setData("AccountID", sAccount, true)
    globalDataPool:setData("Password", sPassword, true)

    SetConfig("AccountID", sAccount)
    SetConfig("Password", sPassword)

    -- 这里走内网的账号密码登录
    GlobalPublicLoginValidate(SPLCT_UserPwd, sAccount, sPassword, MSDK_OS, 0)
    self:SetWaitingAnimState(true)
    --
    ISNET = true;
end

-- 点击进入游戏，此时登录已经成功，直接调用连接服务器即可
function LoginUI:OnClick_EnterGame_Button()
    if (not self.isAgreement) then
        SystemUICall:GetInstance():Toast(
            '请勾选同意下方的用户协议和隐私保护指引，即可进入游戏。', false)
        return
    end

    SetConfig("Login_IsAgreeMent", true)
    local bSendSuc = Send_EnterGame()

    -- 显示一个登陆等待框, 防止超时时玩家频繁点击
    if bSendSuc == true then
        self:SetWaitingAnimState(true)
    end
end

-- 设置服务器状态
function LoginUI:SetServerState(strState)
    if not (self.transServerState and strState) then
        return
    end
    local transChild = nil
    for index = 0, self.transServerState.childCount - 1 do
        transChild = self.transServerState:GetChild(index)
        transChild.gameObject:SetActive(strState == transChild.name)
    end
end

-- 更新服务器列表
function LoginUI:UpdateServerNode()
    self.objUIRoot_Node:SetActive(true)
    self.objAccount_Node:SetActive(false)
    self.objPlantform_list:SetActive(false)
    self.objServer_Node:SetActive(false)
    self.objGameTitle:SetActive(false)
    --self.objAgreement_Node:SetActive(true)
    local serverList = globalDataPool:getData("LoginServerList")
    if not serverList then
        return
    end
    self.objServerName_Text.text = ""
    local zone = tostring(GetConfig("LoginZone") or DEFAULT_SERVERINDEX)
    local strServerKey = string.format("LoginServer_%s", zone)
    local server = tostring(GetConfig(strServerKey) or DEFAULT_SERVERNAME)
    -- 为了防止服务器列表顺序发生变化，直接查询zone和server对应的服务器数据
    local kTarZoneData = nil
    local kFirstZoneData = nil
    for _, zoneData in pairs(serverList) do
        if not kFirstZoneData then
            kFirstZoneData = zoneData
        end
        if zone == zoneData.zone then
            kTarZoneData = zoneData
            break
        end
    end
    -- 如果没有在服务区大区数据中找到目标大区, 那么取当前大区数据中第一个大区作为当前大区
    if (not kTarZoneData) and (kFirstZoneData ~= nil) then
        kTarZoneData = kFirstZoneData
        zone = kFirstZoneData.zone
        SetConfig("LoginZone", kFirstZoneData.zone)
    end
    if not kTarZoneData then
        return
    end
    local kTarServerData = nil
    local kFirstServerData = nil
    for _, serverData in pairs(kTarZoneData.servers) do
        if not kFirstServerData then
            kFirstServerData = serverData
        end
        if server == serverData.server then
            kTarServerData = serverData
            break
        end
    end
    -- 如果在当前服务器列表中没有找到目标服务器, 那么去当前服务器列表中第一个服务器作为当前服务器
    if (not kTarServerData) and (kFirstServerData ~= nil) then
        kTarServerData = kFirstServerData
        server = kFirstServerData.server
        local strServerKey = string.format("LoginServer_%s", tostring(kTarZoneData.zone))
        local strServerNameKey = string.format("LoginServerName_%s", tostring(kTarZoneData.zone))
        SetConfig(strServerKey, kFirstServerData.server)
        SetConfig(strServerNameKey, kFirstServerData.serverName)
    end
    if not kTarServerData then
        return
    end
    -- 更新选择节点的信息
    local strUserName = "(本服无角色)"
    if kTarServerData.userTags and next(kTarServerData.userTags) then
        for index, kTag in pairs(kTarServerData.userTags) do
            if kTag.name == "PlatName" then
                strUserName = string.format("(%s)", (kTag.value == "") and STR_ACCOUNT_DEFAULT_NAME or kTag.value)
            end
        end
    end
    local strZoneName = PlayerSetDataManager:GetInstance():GetServerZoneNameByServerID(kTarServerData.server)
    self.objServerName_Text.text = string.format(
                                       "<color=#8697a8><size=24>%s %s</size></color><color=#748392><size=20>%s</size></color>",
                                       (strZoneName or ""), (kTarServerData.serverName or ""), strUserName)
    local kServerState = globalDataPool:getData("ServerState")
    if kServerState and kServerState[kTarZoneData.zone] and kServerState[kTarZoneData.zone][kTarServerData.server] then
        local strState = kServerState[kTarZoneData.zone][kTarServerData.server]
        self:SetServerState(strState)
    else
        ServerListUI.SetServerState(self, self.objServerState, kTarServerData.state)
    end

    self.funcRebuildRect(self.rectTransServerButton)
end

-- 设置登录等待动画的开启状态
function LoginUI:SetWaitingAnimState(bOn)
    if not self.objWaiting then
        return
    end
    if self.iLoginWaitTimer then
        self:RemoveTimer(self.iLoginWaitTimer)
        self.iLoginWaitTimer = nil
    end
    if bOn == true then
        self.objWaiting:SetActive(true)
        -- 开启一个客户端本地的超时处理, 超时时间直接在这里设置
        local iOverTime = 15000 -- 15s
        self.iLoginWaitTimer = self:AddTimer(iOverTime, function()
            self.objWaiting:SetActive(false)
            self.iLoginWaitTimer = nil
        end, 1)
    else
        self.objWaiting:SetActive(false)
    end
end

-- 设置当前是否是同意协议状态
function LoginUI:SetAgreeMent(bIsOn)
    self.isAgreement = bIsOn
    if (self.isAgreement == true) then
        self.imgAgreement_Flag:SetActive(true)
    else
        self.imgAgreement_Flag:SetActive(false)
    end
    SetConfig("Login_IsAgreeMent", self.isAgreement)
end

-- 调用自动登录接口
function LoginUI:AutoLoginGameServer()
    if (not g_IS_AUTOLOGIN) then
        return
    end

    -- 目前只有调试版才开启这个开关
    if (not DEBUG_CHEAT) then
        return
    end

    self:OnClick_EnterGame_Button()
end

function LoginUI:ChangeBgMp4(path)
    self.comBackVideo.clip = LoadPrefab(path,typeof(DRCSRef.VideoClip))
end

function LoginUI:RefreshBGImage(id)
    local baseID = GetConfig("BGImage")
    if not baseID then
        --没有初始化 默认为1
        SetConfig("BGImage",1)
        baseID = 1
    end
    if id then
        baseID= id
        
    end
    local titleScreenData = TableDataManager:GetInstance():GetTableData("TitleScreen", baseID)
    if titleScreenData and titleScreenData.BGPath then
        self:ChangeBgMp4(titleScreenData.BGPath)
    end

end

-- 删除窗口
function LoginUI:OnDestroy()

end

return LoginUI
