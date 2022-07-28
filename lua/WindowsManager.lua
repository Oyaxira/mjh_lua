WindowsManager = class("WindowsManager")
WindowsManager._instance = nil

UI_MainLayer = nil
UI_UILayer = nil
TIPS_Layer = nil
Load_Layer = nil
Scence_Layer = nil
UI_Camera = nil
UI_CanvasScaler = nil

--刘海屏 左右安全距离
UI_LEFT_WIDTH = 0
UI_RIGHT_WIDTH = 0

PIXELS_PER_UNIT = 0

local EffectPath_Touch = "Effect/Ui_eff/ef_touch"
local touchEffect = nil

local TouchPhase =
{
    Began = 0,
    Moved = 1,
    Stationary = 2,
    Ended = 3,
    Canceled = 4,
}


IS_WINDOWS = CS.UnityEngine.Application.platform == CS.UnityEngine.RuntimePlatform.WindowsEditor  or  CS.UnityEngine.Application.platform == CS.UnityEngine.RuntimePlatform.WindowsPlayer
local cheat_fun = nil
local VECTOR2 = CS.UnityEngine.Vector2(0.25,0.75)
ESC_KEY="escape"
SCROLL_SPEED=20
function WindowsManager:BeforeInit()
    UI_MainLayer = DRCSRef.FindGameObj("UILayerRoot/MainLayer")
    UI_UILayer = DRCSRef.FindGameObj("UILayerRoot/UILayer")
	TIPS_Layer = DRCSRef.FindGameObj("UILayerRoot/TipsLayer")
    Scence_Layer = DRCSRef.FindGameObj("UILayerRoot/ScenceLayer")
    Load_Layer = DRCSRef.FindGameObj("UILayerRoot/LoadLayer")
	UI_Camera = DRCSRef.FindGameObj("UICamera"):GetComponent("Camera")
	UI_CanavsScaler = DRCSRef.FindGameObj("UILayerRoot"):GetComponent("CanvasScaler")
    PIXELS_PER_UNIT = UI_CanavsScaler.referencePixelsPerUnit

    --设置安全屏幕 距离
    if CS.UnityEngine.Application.platform == CS.UnityEngine.RuntimePlatform.Android then
        local safeArea = CS.UnityEngine.Screen.safeArea
        UI_LEFT_WIDTH = safeArea.x
        UI_RIGHT_WIDTH = -safeArea.x--CS.UnityEngine.Screen.width - safeArea.width - UI_LEFT_WIDTH
    elseif IS_WINDOWS then

    else
        UI_LEFT_WIDTH = DRCSRef.CommonFunction.GetIosSafeLeftWidth()
        UI_RIGHT_WIDTH = UI_LEFT_WIDTH
    end
end

function WindowsManager:InitEventListener()
    LuaEventDispatcher:addEventListener("NET_DISPLAY_END", function()
        local windowManagerInstance = WindowsManager:GetInstance()
        windowManagerInstance:ResetWaitDisplayMsgState()
	end, nil, true)
end

-- 等待下行后再移除界面
function WindowsManager:AddLoadingDelayRemoveWindow(windowName, needDisplayEnd)
    self.loadingDelayRemoveWindowList = self.loadingDelayRemoveWindowList or {}
    self.loadingDelayDisplayEnd = self.loadingDelayDisplayEnd or needDisplayEnd
    -- 最大等待时间过去后可能是 Bug 导致的, 弹出反馈界面
    self.loadingDelayRemoveWindowList[windowName] = true
    self:WaitDisplayMsg()
end

-- 等待下行消息
function WindowsManager:WaitDisplayMsg(overTimerCallback)
    g_isWaitingDisplayMsg = true
    --self:OpenWindow('MiniLoadingUI')
    if g_waitDisplayMsgTimer == nil then
        if overTimerCallback == nil then
            overTimerCallback = ResetWaitDisplayMsgState
        end
        g_waitDisplayMsgTimer = globalTimer:AddTimer(WAIT_DISPLAY_MSG_MAX_TIME, overTimerCallback)
    end
end

-- 重置等待下行消息状态
function WindowsManager:ResetWaitDisplayMsgState()
    if not g_isWaitingDisplayMsg then
        return
    end
    g_isWaitingDisplayMsg = false
    --self:RemoveWindow('MiniLoadingUI')
    if g_waitDisplayMsgTimer ~= nil then
        globalTimer:RemoveTimer(g_waitDisplayMsgTimer)
        g_waitDisplayMsgTimer = nil
    end
    if self.loadingDelayRemoveWindowList ~= nil then
        for windowName, _ in pairs(self.loadingDelayRemoveWindowList) do
            self:RemoveWindow(windowName)
        end
        self.loadingDelayRemoveWindowList = nil
    end
    if self.loadingDelayDisplayEnd then
        self.loadingDelayDisplayEnd = nil
        DisplayActionEnd()
    end
    if g_hasReconnected then
        g_afterReconnectedOprCount = g_afterReconnectedOprCount or 0
        g_afterReconnectedOprCount = g_afterReconnectedOprCount + 1
        if g_afterReconnectedOprCount > 2 then
            g_afterReconnectedOprCount = 0
            ReturnToLogin()
        end
    end
end

function WindowsManager:ctor()
    self.objCheatButton = DRCSRef.FindGameObj('UILayerRoot/TipsLayer/Cheat_Button'):GetComponent("Button")
    self:InitCheatButton()
    self._root = DRCSRef.FindGameObj('UIBase')
	DRCSRef.DontDestroyOnLoad(self._root)
    self._rootObject2D = DRCSRef.FindGameObj("UIBase/UILayerRoot")
    self._NetCheck = self._root:GetComponent("NetCheck")
    self._openWindowInstanceList = {}
    self._windowRegInstance = {}
    self.loadAsynList = {}
    self.bWindowsLayerNeedUpdate = false
    self.touchTimer = 0
    self.bCreate = false
    self.tableEffect = {}
end

function WindowsManager:GetInstance()
    if WindowsManager._instance == nil then
        WindowsManager._instance = WindowsManager.new()
        self:BeforeInit()
        self:InitEventListener()
    end

    return WindowsManager._instance
end

function WindowsManager:RegisterWindowCreate(name, instance)
    self._windowRegInstance[name] = instance
end

function WindowsManager:IsWindowOpen(name, checkOrderHide)
    local isShow = (self:GetWindowState(name) == UIWindowState.SHOW)
    -- 因为界面次序导致被临时隐藏
    local isOrderHide = (checkOrderHide and self.orderHideWindowMap and self.orderHideWindowMap[name]) == true

    return isShow or isOrderHide
end

function WindowsManager:GetWindowState(name)
    if self._openWindowInstanceList[name] == nil then
        return UIWindowState.UNCREATE
    else
        if self._openWindowInstanceList[name]:IsActive() == true then
            return UIWindowState.SHOW
        else
            return UIWindowState.HIDE
        end
    end
end

function WindowsManager:OpenWindow(name, info)
    local winState = self:GetWindowState(name)
    if self.loadingDelayRemoveWindowList then
        self.loadingDelayRemoveWindowList[name] = nil
    end
    if winState == UIWindowState.SHOW then
        local uiInstanceWindow = self:GetUIWindow(name)
        uiInstanceWindow:RefreshUI(info)
        uiInstanceWindow.lastOpenTime = nil
        return uiInstanceWindow
    end
    self.bWindowsLayerNeedUpdate = true
    local uiInstanceWindow = nil
    if winState == UIWindowState.UNCREATE then
        local winRegInstance = self._windowRegInstance[name]
        if winRegInstance then
            uiInstanceWindow = winRegInstance.new(self._rootObject2D)
            uiInstanceWindow.name = name
			self._openWindowInstanceList[name] = uiInstanceWindow

            uiInstanceWindow:OnCreate(info)
            uiInstanceWindow.lastOpenTime = nil
        else
            derror("not regist ui windows: " .. name)
        end
    elseif winState == UIWindowState.HIDE then
        uiInstanceWindow = self._openWindowInstanceList[name]
		uiInstanceWindow.info = info
        uiInstanceWindow:SetActive(true)
        uiInstanceWindow:RefreshUI(info)
        uiInstanceWindow.lastOpenTime = nil
    end
    local bGuidDoRes = GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_OpenUI, name)
    -- 如果ui关注引导执行结果, 那么通知该ui实例
    if uiInstanceWindow and uiInstanceWindow.OnGuidDone then
        uiInstanceWindow:OnGuidDone(bGuidDoRes)
    end

    LuaEventDispatcher:dispatchEvent("OPEN_WINDOW", name)
    return uiInstanceWindow
end

function WindowsManager:GetUIWindow(name)
    return self._openWindowInstanceList[name]
end

--切换场景不销毁UI,添加到此列表
function WindowsManager:setChangeSceneNoClose(name)
    if not self.NoCloseList then
        self.NoCloseList = {}
    end
    self.NoCloseList[name] = true
end

function WindowsManager:clearChangeSceneNoClose()
    self.NoCloseList = {}
end

function WindowsManager:GetWindowName(targetWindowClass)
    for windowName, windowClass in pairs(self._openWindowInstanceList) do
        if windowClass == targetWindowClass then
            return windowName
        end
    end
    return nil
end

function WindowsManager:RemoveWindow(name, bSaveToCache)
    if self.NoCloseList and self.NoCloseList[name] then
        return
    end

    self.bWindowsLayerNeedUpdate = true
	 -- 清除排序记录
    if self.orderHideWindowMap then
        self.orderHideWindowMap[name] = nil
    end

    if self._openWindowInstanceList[name] then
        self._openWindowInstanceList[name].lastOpenTime = os.clock()
    end

    local winState = self:GetWindowState(name)
    if winState == UIWindowState.UNCREATE or (bSaveToCache and winState == UIWindowState.HIDE) then
        return
    end

    if self._openWindowInstanceList[name] == nil then
        derror('Cannot remove window: ' .. tostring(name) .. '  Window not exist')
        return
    end

    if bSaveToCache ~= false then
        self._openWindowInstanceList[name]:SetActive(false)
    else
		self._openWindowInstanceList[name]:SetActive(false)
        self._openWindowInstanceList[name]:Destroy()
        self._openWindowInstanceList[name] = nil
    end
    -- self:UpdateWindowOrder()
    LuaEventDispatcher:dispatchEvent("REMOVE_WINDOW", name)
    GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_CloseUI, name)
end

local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
local l_GetKeyUp = CS.UnityEngine.Input.GetKeyUp
local l_GetKey = CS.UnityEngine.Input.GetKey
local l_KeyCode = {}
l_KeyCode.Return = CS.UnityEngine.KeyCode.Return
local curTime = 0
local isSpeedUp = false
local windowsList = {}
local KeyCodeNum = {
    CS.UnityEngine.KeyCode.Alpha1,CS.UnityEngine.KeyCode.Keypad1,
    CS.UnityEngine.KeyCode.Alpha2,CS.UnityEngine.KeyCode.Keypad2,
    CS.UnityEngine.KeyCode.Alpha3,CS.UnityEngine.KeyCode.Keypad3,
    CS.UnityEngine.KeyCode.Alpha4,CS.UnityEngine.KeyCode.Keypad4,
    CS.UnityEngine.KeyCode.Alpha5,CS.UnityEngine.KeyCode.Keypad5,
    CS.UnityEngine.KeyCode.Alpha6,CS.UnityEngine.KeyCode.Keypad6,
    CS.UnityEngine.KeyCode.Alpha7,CS.UnityEngine.KeyCode.Keypad7,
    CS.UnityEngine.KeyCode.Alpha8,CS.UnityEngine.KeyCode.Keypad8,
    CS.UnityEngine.KeyCode.Alpha9,CS.UnityEngine.KeyCode.Keypad9,
}
function WindowsManager:Update(deltaTime)
    self:TouchEffect(deltaTime)

    -- 拷贝出来, 避免 update 中修改 _openWindowInstanceList 导致遍历报错
    local int_i =  1
    for k, v in pairs(self._openWindowInstanceList) do
        windowsList[int_i] = v
        int_i = int_i + 1
    end
    for k, v in ipairs(windowsList) do
        if v.toShow then
            v:Update(deltaTime)
        end
    end
    windowsList = {}
    if DEBUG_CHEAT then
        -- 作弊界面
        if l_GetKeyDown(l_KeyCode.Return) or DRCSRef.Input.touchCount >= 4 then
            if not self:IsWindowOpen("CheatUI") then
                OpenWindowImmediately("CheatUI")
            end
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.F6) then
            SendLimitShopOpr(EN_LIMIT_SHOP_REFLASH,nil,LimitShopManager:GetInstance():CheckCanGetShop())
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.F7) then
            -- OpenWindowImmediately('GuessCoinUI')
            SendLimitShopOpr(EN_LIMIT_SHOP_GETYAZHU)
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.F8) then
            DisplayActionEnd()
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.F9) then
            self:UpdateWindowOrder()
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.F10) then
            CheatDataManager:GetInstance():OpenActionDebugUI()
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.F11) then
            self.isSkipBattle = not self.isSkipBattle
            local text = ""
            if self.isSkipBattle then
                text = "跳过所有战斗 <color=#6CD458>开启</color>"
            else
                text = "跳过所有战斗 <color=#C26AF5>关闭</color>"
            end
            SystemUICall:GetInstance():Toast(text)

            local cmd = "CHET_JUMPBATTLE"
            local cheatPara = string.format("%s@%s",cmd,"0@0@0")
		    local clickCheatData = EncodeSendSeGC_ClickCheat(cheatPara)
		    local iSize = clickCheatData:GetCurPos()
		    NetGameCmdSend(SGC_CLICK_CHEAT,iSize,clickCheatData)
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.F12) then
            SkipAllUselessAnim()
        elseif (DEBUG_MODE and AutoTest_IsRunning()) or (l_GetKey(CS.UnityEngine.KeyCode.Space)) then
            -- local curAction = DisplayActionManager:GetInstance():GetCurAction()
            -- if curAction ~= nil then
            --     local curActionType = curAction.actionType
            --     if curActionType == DisplayActionType.PLOT_EXECUTE_PLOT and curAction.params ~= nil and IsInDialog() then
            --         local plotData = curAction.params[3] or PlotDataManager:GetInstance():GetPlotData(curAction.params[2])
            --         if plotData and (plotData.PlotType == PlotType.PT_DIALOGUE or plotData.PlotType == PlotType.PT_LINSHI_JUESE_DUIHUA) then
            --             local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
            --             if dialogChoiceUI ~= nil then
            --                 dialogChoiceUI:OnClickScreen()
            --             end
            --         end
            --     end
            -- end
            if IsWindowOpen('RoleShowUI') then
                local roleShowUI = GetUIWindow('RoleShowUI')
                if roleShowUI then
                    roleShowUI.boolean_showing = false
                    roleShowUI:CheckAndShow()
                end
            end
            if IsWindowOpen('LevelUPUI') then
                local levelUPUI = GetUIWindow('LevelUPUI')
                if levelUPUI then
                    levelUPUI:CloseLevelUpUI()
                end
            end
            if IsWindowOpen('ComicPlotUI') then
                local comicPlotUI = GetUIWindow('ComicPlotUI')
                if comicPlotUI then
                    comicPlotUI:OnClickScreen()
                end
            end
            if IsWindowOpen('TaskCompleteUI') then
                local taskCompleteUI = GetUIWindow('TaskCompleteUI')
                if taskCompleteUI then
                    taskCompleteUI:Onclick_Continue()
                end
            end
            -- if IsWindowOpen('BattleGameEndUI') then
            --     local battleGameEndUI = GetUIWindow('BattleGameEndUI')
            --     if battleGameEndUI then
            --         battleGameEndUI:OnClick_Win()
            --     end
            -- end

        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.BackQuote) then
            local FPSUI = GetUIWindow("FPSUI")
            if FPSUI then
                RemoveWindowImmediately("FPSUI")
            else
                OpenWindowImmediately("FPSUI")
            end
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.Equals)  and l_GetKey(CS.UnityEngine.KeyCode.LeftControl) then
            SetSpeed(SPEED_TYPE.NORMAL,GetSpeed(SPEED_TYPE.NORMAL) + 0.1)
            SystemUICall:GetInstance():Toast(string.format("当前速度：%.2f",DRCSRef.Time.timeScale))
        elseif l_GetKeyDown(CS.UnityEngine.KeyCode.Minus) and l_GetKey(CS.UnityEngine.KeyCode.LeftControl) then
            SetSpeed(SPEED_TYPE.NORMAL,GetSpeed(SPEED_TYPE.NORMAL) - 0.1)
            SystemUICall:GetInstance():Toast(string.format("当前速度：%.2f",DRCSRef.Time.timeScale))
        elseif l_GetKey(CS.UnityEngine.KeyCode.LeftControl) then
            if l_GetKeyDown(CS.UnityEngine.KeyCode.Alpha0) or l_GetKeyDown(CS.UnityEngine.KeyCode.Keypad0 ) then
                ChangeScreenResolution()
            else
                for index = 1,9 do
                    if l_GetKeyDown(KeyCodeNum[index*2 - 1]) or l_GetKeyDown(KeyCodeNum[index*2]) then
                        ChangeScreenResolutionIndex(index)
                        break
                    end
                end
            end
        --shift + F1
        elseif l_GetKey(CS.UnityEngine.KeyCode.LeftShift) then
            if l_GetKey(CS.UnityEngine.KeyCode.F1) then
                DisplayActionManager:GetInstance():BigMapMoveAndEnterCity(27)
            elseif l_GetKey(CS.UnityEngine.KeyCode.F2) then
                local fun1 = function ()
                    reloadModule("UI/ModelPreview/ModelPreviewUI")
                    reloadModule("UI/ModelPreview/ModelPreviewDataManager")
                    modelPreviewUI = ModelPreviewUI.new()
                    local go = DRCSRef.GameObject.FindGameObjectWithTag("Embattle")
                    modelPreviewUI:Init(go)
                    modelPreviewUI:RefreshUI(2)
                end
                ChangeScenceImmediately("ModelPreview","LoadingUI",fun1)
            end
        end
    end

    -- TODO: 迷宫更新需要通用化
    local mazeUI = self:GetUIWindow('MazeUI')
    if mazeUI ~= nil and mazeUI.updateFlag then
        if CanUpdateMazeUI() then
            mazeUI.updateFlag = false
            mazeUI:UpdateMaze()
            if mazeUI.enterMazeLoading or IsWindowOpen('LoadingUI') then
                RemoveWindowImmediately('LoadingUI')
                mazeUI.enterMazeLoading = false
            end
            if mazeUI.updateActionDispatchEndEvent then
                mazeUI.updateActionDispatchEndEvent = false
                DisplayActionEnd()
            end
        end
    end

    local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
    local bSelectState = (dialogChoiceUI and dialogChoiceUI:IsSelectState())
    local bTaskHasChoice = dnull(g_curChoiceTask) and (TaskDataManager:GetInstance():GetChoiceInfo(g_curChoiceTask) ~= nil)
    local bInBattle = IsBattleOpen() or quitBattleMsg
    local bOpenDialogChoice = false
    local bCloseDialogChoice = false

    if IsWindowOpen('DialogChoiceUI') then
        if bInBattle and bSelectState then
            bCloseDialogChoice = true
        end
    else
        if dnull(g_curChoiceTask) and (not bInBattle or not bTaskHasChoice) then
            bOpenDialogChoice = true
        end
    end

    if bOpenDialogChoice then
        DisplayActionManager:GetInstance():ShowChoiceWindow(g_curChoiceTask)
    elseif bCloseDialogChoice then
        RemoveWindowImmediately("DialogChoiceUI", true)
        DisplayActionEnd()
    end

    -- if dnull(g_curChoiceTask) and not IsWindowOpen('DialogChoiceUI') then
    --     DisplayActionManager:GetInstance():ShowChoiceWindow(g_curChoiceTask)
    -- end
end

function WindowsManager:LateUpdate()
    for k, v in pairs(self._openWindowInstanceList) do
        if v.toShow then
            v:LateUpdate()
        end
    end
end

function WindowsManager:DestroyAll(name, isEnd)
    for k, v in pairs(self._openWindowInstanceList) do
        if (not v.DontDestroy or isEnd) and k~= name then
            self:RemoveWindow(k, false)
        end
    end
end

function WindowsManager:CloseAll(name, isEnd)
    for k, v in pairs(self._openWindowInstanceList) do
        if (not v.DontDestroy or isEnd) and k~= name then
            self:RemoveWindow(k, true)
        end
    end
end

function WindowsManager:HideAll()
    for k, v in pairs(self._openWindowInstanceList) do
        self:HideOrWindow(k, true)
    end
end

function WindowsManager:SetTop(name)
    if self._openWindowInstanceList[name] then
        self._openWindowInstanceList[name]:SetTop()
    end
end

-- bHideOrShow == ture--->Hide Window
-- bHideOrShow == false--->Show Window
function WindowsManager:HideOrWindow(name, bHideOrShow)
    local uiWindowState = self:GetWindowState(name)
    if uiWindowState == UIWindowState.SHOW and bHideOrShow == true then
        self._openWindowInstanceList[name]:SetActive(false)
        if self.orderHideWindowMap then
            self.orderHideWindowMap[name] = nil
        end
    elseif uiWindowState == UIWindowState.HIDE and bHideOrShow == false then
        self._openWindowInstanceList[name]:SetActive(true)
        if self._openWindowInstanceList[name].RefreshInfo then
            self._openWindowInstanceList[name]:RefreshInfo("ShowWindow:"..name)
        end
    end
end

local OnClick_Cheat = nil
function WindowsManager:InitCheatButton()
    if self.objCheatButton then
        if DEBUG_CHEAT then
            self.objCheatButton.gameObject:SetActive(true)
        else
            self.objCheatButton.gameObject:SetActive(false)
        end
    end

    OnClick_Cheat = function ()
        local time = os.clock()
        local iCheatClickCount = globalDataPool:getData("CheatClickCount") or 0
        local iCheatClickStartTime = globalDataPool:getData("CheatClickTime") or 0
        local iCheckNoPlayerCmdLoadClickCount = globalDataPool:getData("CheckNoPlayerCmdLoadClickCount") or 0
        local iCheckNoPlayerCmdLoadClickTime = globalDataPool:getData("CheckNoPlayerCmdLoadClickTime") or 0

        if time - iCheatClickStartTime >= 1 then
            iCheatClickStartTime = time
            iCheatClickCount = 0
        end
        if time - iCheckNoPlayerCmdLoadClickTime >= 10 then
            iCheckNoPlayerCmdLoadClickTime = time
            iCheckNoPlayerCmdLoadClickCount = 0
        end
        iCheatClickCount = iCheatClickCount + 1
        iCheckNoPlayerCmdLoadClickCount = iCheckNoPlayerCmdLoadClickCount + 1

        if iCheatClickCount >= 3  then
            if (DEBUG_CHEAT) then
                if (not g_IS_WINDOWS) then
                    OpenWindowImmediately("CheatUI")
                    iCheatClickStartTime = 0
                    iCheatClickCount = 0
                end
            end
        end
        if iCheckNoPlayerCmdLoadClickCount >= 20 then
            CheckNoPlayerCmdLoad(true)
            iCheckNoPlayerCmdLoadClickTime = 0
            iCheckNoPlayerCmdLoadClickCount = 0
        end

        globalDataPool:setData("CheatClickTime",iCheatClickStartTime,true)
        globalDataPool:setData("CheatClickCount",iCheatClickCount,true)
        globalDataPool:setData("CheckNoPlayerCmdLoadClickTime",iCheckNoPlayerCmdLoadClickTime,true)
        globalDataPool:setData("CheckNoPlayerCmdLoadClickCount",iCheckNoPlayerCmdLoadClickCount,true)
    end
    self.objCheatButton.onClick:RemoveAllListeners()
    self.objCheatButton.onClick:AddListener(OnClick_Cheat)
end

function WindowsManager:ClearCheatButton()
    self.objCheatButton.onClick:RemoveListener(OnClick_Cheat)
    self.objCheatButton.onClick:Invoke()
    self.objCheatButton = nil
end

function WindowsManager:DontDestroyWindow(kName)
    for k, v in pairs(self._openWindowInstanceList) do
        if k == kName then
            v.DontDestroy = true
        end
    end
end

function WindowsManager:SetWindowIsFullScreen(kName, flag)
    local data = WINDOW_ORDER_INFO[kName]

    if data then
        data.fullscreen = flag
    end
end

local function SortWindowInfos(windowInfos)
    table.sort(windowInfos, function(info1, info2)
        local order1 = info1.orderInfo.order
        local order2 = info2.orderInfo.order
        local index1 = info1.oldIndex
        local index2 = info2.oldIndex

        return ((order1 - order2) * 1000 + (index1 - index2)) < 0
    end)
end

function WindowsManager:UpdateLayerWindowOrder(windowInfos)
    local oldIndexList = {}

    for index, windowInfo in ipairs(windowInfos) do
        oldIndexList[index] = windowInfo.oldIndex
    end
    table.sort(oldIndexList)

    SortWindowInfos(windowInfos)

    -- 调整次序改变了的window
    for index = 1, #windowInfos do
        if oldIndexList[index] ~= windowInfos[index].oldIndex then
            windowInfos[index].objTransform:SetSiblingIndex(oldIndexList[index])
        end
    end
end

function WindowsManager:UpdateWindowOrder()
    if not self.bWindowsLayerNeedUpdate then
        return
    end
    self.bWindowsLayerNeedUpdate = false
    local layersWindows = {}
    local windowInfos = {}
    self.orderHideWindowMap = self.orderHideWindowMap or {}
    -- 记录改变前的window激活状态
    for windowName, window in pairs(self._openWindowInstanceList) do
        local orderInfo = nil
        local objWindow = nil
        local active = nil
        local objParent_Tranform = nil
        local orderHide = nil

        if window then
            orderInfo = WINDOW_ORDER_INFO[windowName]
            active = window:IsActive()
        end
        if orderInfo then
            objWindow = window:GetGameObject()
        end
        if objWindow then
            orderHide = (self.orderHideWindowMap[windowName] ~= nil)
            if (active or orderHide)  then
                objParent_Tranform = objWindow:GetComponent('RectTransform').parent
            end

             -- 寻找父对象,同一个父对象下的window会排序
            if objParent_Tranform then
                local objWindow_Transform = objWindow:GetComponent('RectTransform')
                local windowInfo = {}
                windowInfo.name = windowName
                windowInfo.objTransform = objWindow_Transform
                windowInfo.object = objWindow
                windowInfo.orderInfo = orderInfo
                windowInfo.oldIndex = objWindow_Transform:GetSiblingIndex()
                windowInfo.orderHide = orderHide
                windowInfo.windowName = windowName

                layersWindows[objParent_Tranform] = layersWindows[objParent_Tranform] or {}
                table.insert(layersWindows[objParent_Tranform], windowInfo)
                table.insert(windowInfos, windowInfo)
            end
        end
    end

    self.orderHideWindowMap = {}
    -- 处理各个Layer下的Window
    for parent, layerWindowInfos in pairs(layersWindows) do
        self:UpdateLayerWindowOrder(layerWindowInfos)
    end

    -- 隐藏已激活全屏界面下的其他界面
    SortWindowInfos(windowInfos)
    local hasUpdate = false
    local inactive = false
    local inTopShow = false
    for index = #windowInfos, 1, -1 do
        local windowInfo = windowInfos[index]
        local isWindowActive = self:IsWindowOpen(windowInfo.windowName)
        if inTopShow then
            if isWindowActive then
                if windowInfo.orderInfo.reopen then
                    self:RemoveWindow(windowInfo.windowName)
                elseif not windowInfo.orderInfo.baseshow then
                    self._openWindowInstanceList[windowInfo.name]:SetActive(false)
                end

                self.orderHideWindowMap[windowInfo.name] = true
                hasUpdate = true
            elseif windowInfo.orderHide then
                self.orderHideWindowMap[windowInfo.name] = true
            end
        elseif inactive then
            if isWindowActive then
                if windowInfo.orderInfo.reopen then
                    self:RemoveWindow(windowInfo.windowName)
                elseif not windowInfo.orderInfo.allshow then
                    self._openWindowInstanceList[windowInfo.name]:SetActive(false)
                end

                self.orderHideWindowMap[windowInfo.name] = true
                hasUpdate = true
            elseif windowInfo.orderHide then
                self.orderHideWindowMap[windowInfo.name] = true
            end
        else
            if isWindowActive or windowInfo.orderHide then
                if not isWindowActive then

                    if windowInfo.orderInfo.reopen then
                        self:OpenWindow(windowInfo.windowName)
                    else
                        self._openWindowInstanceList[windowInfo.name]:SetActive(true)
                    end

                    hasUpdate = true
                end
                local info = globalDataPool:getData("GameData") or {}
                local curState = info['eCurState']
                if curState == GS_BIGMAP and  windowInfo.orderInfo.topshow then     
                    inTopShow = true
                end

                if windowInfo.orderInfo.fullscreen then
                    inactive = true
                end
            end
        end
    end

    if hasUpdate then
        LuaEventDispatcher:dispatchEvent("WINDOW_ORDER_UPDATE")
    end
end

function WindowsManager:GetWindowObjectUiName(objWindow)
    if self._openWindowInstanceList == nil then
        return nil
    end
    for windowName, windowInstance in pairs(self._openWindowInstanceList) do
        if windowInstance._gameObject == objWindow then
            return windowName
        end
    end
    return nil
end


function WindowsManager:UnloadWindows()
    if self._openWindowInstanceList then
        local curTime = os.clock()
        local delTime = UPDATE_UNLOAD_WINDOWS
        for key, value in pairs(self._openWindowInstanceList) do
            if not value.DontDestroy and value.lastOpenTime ~= nil and curTime - value.lastOpenTime > delTime then
                self:RemoveWindow(key,false)
                break
            end
        end
    end
end

function WindowsManager:TouchEffect(deltaTime)
    if (g_IS_WINDOWS and CS.UnityEngine.Input:GetMouseButtonDown(0))
    or ((not g_IS_WINDOWS) and (DRCSRef.Input.touchCount == 1 and DRCSRef.Input.touches[0].phase == DRCSRef_TouchPhase_Began)) then
        self.bTouch = true
        self.touchTimer = 0
    elseif DRCSRef.Input.touchCount == 1 and DRCSRef.Input.touches[0].phase == DRCSRef_TouchPhase_Ended then
        self.bTouch = false
    end

    if self.bTouch then
        if  self.touchTimer == 0 then
            self.bCreate = true
        end

        self.touchTimer = self.touchTimer + deltaTime
        if self.touchTimer >= 300 then
            self.touchTimer = 0
        end
    end

    if self.bTouch then
        local mousePos = GetTouchUIPos()
        if self.bCreate then
            self.index = (self.index or 0) + 1
            self.bCreate = false
            self.touchEffect = self:CreateEffect()

            --LoadPrefabFromPool(EffectPath_Touch, UI_UILayer.transform,true)

            self.touchEffect.gameObject.name = self.index
            self.touchEffect.gameObject:SetActive(true)
            self.touchEffect.transform.localScale = DRCSRef.Vec3(50,50,1)
            self.touchEffect.transform:GetComponent("ParticleSystem"):Play()

        end
        if self.touchEffect and mousePos then
            self.touchEffect.transform.localPosition = mousePos
        end
    end

    if  (g_IS_WINDOWS and CS.UnityEngine.Input:GetMouseButtonUp(0)) or
    ((not g_IS_WINDOWS) and DRCSRef.Input.touchCount == 0)
    then
        self.bTouch = false
        self.touchTimer = 0
        self.touchEffect = nil
    end
end

function WindowsManager:CreateEffect()
    local effect = LoadPrefabFromPool(EffectPath_Touch, UI_UILayer.transform,true)
    globalTimer:AddTimer(3000,function()
        if IsValidObj(effect) then
            effect.transform:GetComponent("ParticleSystem"):Stop()
            effect.gameObject:SetActive(false)
            ReturnObjectToPool(effect.gameObject)
        end
    end)
    return effect
end

-- 窗口名称 传递参数 是否为互斥界面
function OpenWindowByQueue(sUIName, info)
	DisplayActionManager:GetInstance():AddAction(DisplayActionType.WIN_OPEN, false, sUIName, info)
end

-- 立即打开界面而不使用队列 窗口名称 传递参数 是否为互斥界面
function OpenWindowImmediately(sUIName, info)
    local wmInstance = WindowsManager:GetInstance()
    local func = wmInstance.OpenWindow
    local ok,window = xpcall(func, showError, wmInstance, sUIName, info)
    return window
end

-- 窗口名称 是否缓存
function RemoveWindowByQueue(sUIName,bSaveToCache)
	DisplayActionManager:GetInstance():AddAction(DisplayActionType.WIN_REMOVE, false, sUIName, bSaveToCache)
end

-- 立即关闭界面而不使用队列 窗口名称 是否缓存
function RemoveWindowImmediately(sUIName,bSaveToCache)
    local wmInstance = WindowsManager:GetInstance()
    local func = wmInstance.RemoveWindow
    xpcall(func, showError, wmInstance, sUIName, bSaveToCache)
end

function DontDestroyWindow(kName)
	WindowsManager:GetInstance():DontDestroyWindow(kName)
end

function IsWindowOpen(sName, bCheckOrderHide)
    return WindowsManager:GetInstance():IsWindowOpen(sName, bCheckOrderHide)
end

function GetUIWindow(sName)
    return WindowsManager:GetInstance():GetUIWindow(sName)
end

function AddLoadingDelayRemoveWindow(windowName, needDisplayEnd)
    return WindowsManager:GetInstance():AddLoadingDelayRemoveWindow(windowName, needDisplayEnd)
end

function WaitDisplayMsg()
    return WindowsManager:GetInstance():WaitDisplayMsg()
end

function ResetWaitDisplayMsgState()
    return WindowsManager:GetInstance():ResetWaitDisplayMsgState()
end

function OpenWindowBar(windowInfo)
    if not windowInfo then
        return
    end
    local windowName = windowInfo.windowstr
    if windowName ~= nil and not IsWindowOpen(windowName) then
        return
    end
    local windowBarUI = OpenWindowImmediately("WindowBarUI")
    if windowBarUI then
        windowBarUI:AddWindowInfo(windowInfo)
    end
    return windowBarUI
end

function RemoveWindowBar(windowName)
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:RemoveWindowInfo(windowName)
    end
end

function CanUpdateMazeUI()
    if DisplayActionManager:GetInstance():GetActionListSize() == 0 or DisplayActionManager:GetInstance():GetCurActionType() == DisplayActionType.UPDATE_MAZE_UI then
        return true
    end
    return false
end

function CommonSpendSliverWindow(needSliver,callback)
    needSliver = needSliver or 999999
    local roleHasSliver = PlayerSetDataManager:GetInstance():GetPlayerSliver()
    if roleHasSliver < needSliver then
        local s_tips = string.format("\n\n账户余额不足,还差%d,点击确定前往充值界面",needSliver - roleHasSliver)
        local content = {
            ["title"] = "提示",
            ["text"] = s_tips
        }
        local Pay = function()
            OpenWindowImmediately("ShoppingMallUI")
            local win = GetUIWindow("ShoppingMallUI")
            if win then
                win:SetPayTag()
            end
        end
        OpenWindowImmediately('GeneralBoxUI', {
            GeneralBoxType.COMMON_TIP,
            content,
            Pay
        })
    else
        callback()
    end
end


local resolution = {
    1920, 1080,
    1600, 900,
    1366, 768,
    1280, 720
}

local SCREEN = {}
function getScreen()
    return SCREEN
end
function InitScreen()
    SCREEN.resolution = CS.UnityEngine.PlayerPrefs.GetInt("resolution")
    if SCREEN.resolution == 0 then
        SCREEN.resolution = 1
    end
    SCREEN.fullScreen = CS.UnityEngine.PlayerPrefs.GetInt("fullscreen")
    ResetScreen()
end

function ResetScreen()
    local idx = SCREEN.resolution
    -- derror(resolution[idx * 2 - 1], resolution[idx * 2])
    CS.UnityEngine.Screen.SetResolution(resolution[idx * 2 - 1], resolution[idx * 2], SCREEN.fullScreen == 1)
    
    CS.UnityEngine.PlayerPrefs.SetInt("resolution", idx)
    CS.UnityEngine.PlayerPrefs.SetInt("fullscreen", SCREEN.fullScreen)
end