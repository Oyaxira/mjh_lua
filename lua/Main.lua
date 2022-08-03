require("Base/LuaPanda/LuaPanda")
require "Base/Functions"
require "KeyboardManager"
-- LuaPanda.start("127.0.0.1",8818)
reloadModule("Config")
if DEBUG_MODE then 
    reloadModule("AutoTest")
end



local l_globalTimer = nil
local l_windowsMgr = nil
local l_LogicMain = nil
local l_TimeLineHelp = nil
local l_LuaClassFactory = nil
local l_DisplayActionManager = nil

local function SetSystemSetting()
    local iYinYue=  GetConfig("confg_YinYue")
    if iYinYue == nil  then
        iYinYue = 1
    end
    CS.GameApp.FMODManager.SetMusicVolume(iYinYue)

    local iYinXiao =  GetConfig("confg_YinXiao")
    if iYinXiao == nil  then
        iYinXiao = 1
    end
    CS.GameApp.FMODManager.SetSoundVolume(iYinXiao)

    local iYuYin =  GetConfig("confg_YuYin")
    if iYuYin == nil  then
        iYuYin = 1
    end
    CS.GameApp.FMODManager.SetVocalVolume(iYuYin)

    local particleMode = GetConfig("confg_ParticleMode")
    if particleMode == nil then
        particleMode = 3
    end
    CS.ParticleLevelSetting.SetParticleLevel(particleMode)
    --设置帧率
    local electricMode = GetConfig("confg_ElectricMode")
    if electricMode == 1 then
        CS.UnityEngine.Application.targetFrameRate = 60
    else
        CS.UnityEngine.Application.targetFrameRate = 30
    end
    --[todo]粒子质量 

end
function awake()
    if MSDK_MODE == 0 then 
        start_time = os.clock()
        TestAddRecordInfo("[system] awake start",os.clock() .. "")
    end
    require "RequireLoad"
    if MSDK_MODE == 0 then 
        TestAddRecordInfo("[system] RequireLoad",os.clock())
    end
    reloadGameModules()
    if MSDK_MODE == 0 then 
        TestAddRecordInfo("[system] reloadGameModules",os.clock())
    end
    InitLuaTable()
    if MSDK_MODE == 0 then 
        TestAddRecordInfo("[system] InitLuaTable",os.clock())
    end
    InitLoginMsg()
    if MSDK_MODE == 0 then 
        TestAddRecordInfo("[system] InitLoginMsg",os.clock())
    end
    InitGameMsg()
    if MSDK_MODE == 0 then 
        TestAddRecordInfo("[system] InitGameMsg",os.clock())
    end
    RegisterUIWindows()
    if MSDK_MODE == 0 then 
        TestAddRecordInfo("[system] RegisterUIWindows",os.clock())
    end
    l_globalTimer = globalTimer
    l_windowsMgr = WindowsManager:GetInstance()
    l_LogicMain = LogicMain:GetInstance()
    l_animationMgr = AnimationMgr:GetInstance()
    l_TimeLineHelp = TimeLineHelper:GetInstance()
    l_LuaClassFactory = LuaClassFactory:GetInstance()
    l_BoxPoolManager = BoxPoolManager:GetInstance()
    l_KeyboardManager = KeyboardManager:GetInstance()
    local SCROLLSPEED=io.readfile('SCROLLSPEED.txt')
    if SCROLLSPEED then
        CS.UnityEngine.PlayerPrefs.SetInt("SCROLLSPEED", tonumber(SCROLLSPEED))
    end
    CS.UnityEngine.Debug.developerConsoleVisible = false
    CS.UnityEngine.Screen.sleepTimeout = -1 --手机长亮
    --屏幕旋转
    CS.UnityEngine.Screen.orientation = 5
	  CS.UnityEngine.Screen.autorotateToLandscapeLeft  = true
    CS.UnityEngine.Screen.autorotateToLandscapeRight  = true
    CS.UnityEngine.Screen.autorotateToPortrait  = false
    CS.UnityEngine.Screen.autorotateToPortraitUpsideDown  = false

    if not OUTPUT_LUALOG then
        CS.UnityEngine.Debug.unityLogger.filterLogType = 0
    end
    DRCSRef.Time.timeScale = 1
    
    InitScreen()

    SetSystemSetting()
    SetDefaultButtonSound()
    --DRCSRef.DOTween:SetTweensCapacity(2000,10)
    --电魂sdk 启动日志上传
    DRCSRef.DHSDKManager.DHSDKInit()
    CS.DHTackHelper.init("1484302261")
    if MSDK_MODE == 0 then 
        TestAddRecordInfo("[system] awake end",os.clock() .. "")
    end

    ClientConfigHelper:GetInstance():InitHttpClientConfig()
end

function start()
    dprint("[Main]->Game  start")
    -- 根据AUTOUPDATE_MODE 决定是否启用热更新
    globalDataPool:setData("GameMode", "ServerMode")
    DRCSRef.LogicMgr:Initialize()    
    local str = io.readfile('platform.txt')
    if str == "wegame" then
        WEGAME=true
    else
        WEGAME=false
    end
    local str = io.readfile('lang.txt')
    CS.UnityEngine.PlayerPrefs.SetInt("lang", 0)
    if str == 'tchinese' then
        CS.UnityEngine.PlayerPrefs.SetInt("lang", 1)
    end
    SetConfig("index", 2, true)
    local window = OpenWindowImmediately("LoginUI")
    window:OnclickVisitorLogin()

    OnGameNetConnected()
end
local i_SerializeScreenSize_end = 0
function update(deltaTime)
    if i_SerializeScreenSize_end < 1 then 
        SerializeScreenSize()
        i_SerializeScreenSize_end = i_SerializeScreenSize_end + 1
    end 
    deltaTime = deltaTime * 1000

    l_globalTimer:Update(deltaTime)
    l_windowsMgr:Update(deltaTime)
    l_LogicMain:Update(deltaTime)
    AdvLootManager:GetInstance():Update(deltaTime)
    l_TimeLineHelp:Update(deltaTime)
    KeyboardManager:GetInstance():Update(deltaTime)
    l_animationMgr:Update(deltaTime) -- 放在最后,所有逻辑跑完后再进行动画
    if NetCommonService then
        NetCommonService:Update(deltaTime);
    end
    DisplayActionManager:GetInstance():Update(deltaTime)
end

function lateUpdate()
    l_windowsMgr:LateUpdate()
    l_windowsMgr:UpdateWindowOrder()
    l_windowsMgr:UnloadWindows()
    l_LuaClassFactory:UpdateUnload()
    l_BoxPoolManager:Update()
    UpdateUnloadPerfabAsset()
end

function SendMessage(eventName,info)
    if eventName ~= nil then
        LuaEventDispatcher:dispatchEvent(eventName,info)
    end
end

function ReStartGameTips()
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.SYSTEM_RESTART})
end

function onResume()
    GVoiceHelper:Resume()
end

function onPause()
    GVoiceHelper:Pause()
end

function ondestroy()
    -- 关闭推送服务
    if AppsManager then
        AppsManager:Destroy();
        AppsManager = nil;
    end

    if DEBUG_MODE then
        WriteTableInfo()
    end
    MSDKHelper:UnInit()

    -- WARNING: 对象池最好优先于Window卸载，因为Window会带有对象池的对象
    BoxPoolManager:GetInstance():Dispose()

    WindowsManager:GetInstance():DestroyAll(nil,true)
    WindowsManager:GetInstance():ClearCheatButton()
    LuaClassFactory:GetInstance():Clear()

    l_LogicMain:OnDestroy()
    l_LogicMain = nil
    UnLoadAll(true)
    dprint("[Main]->Game Ondestroy")
end

function SendQuestSave()
    TipsQuitGame()
end