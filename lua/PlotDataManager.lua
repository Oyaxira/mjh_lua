PlotDataManager = class("PlotDataManager")
PlotDataManager._instance = nil

local typeMap = {
    [PlotType.PT_DIALOGUE] = DisplayActionType.PLOT_DIALOGUE,
    [PlotType.PT_LINSHI_JUESE_DUIHUA] = DisplayActionType.PLOT_LINSHI_JUESE_DUIHUA,
    [PlotType.PT_CHOOSE] = DisplayActionType.PLOT_CHOOSE,
    [PlotType.PT_SHOW_CHOOSE_TEXT] = DisplayActionType.PLOT_SHOW_CHOOSE_TEXT,
    [PlotType.PT_OBSERVE_ROLE] = DisplayActionType.PLOT_OPEN_OBSERVE_WINDOW,
    [PlotType.PT_ZANGJINGGE] = DisplayActionType.PLOT_OPEN_ZANGJINGGE,
    [PlotType.PT_MAZE_PLAY_CLICK_ROLE_ANIM] = DisplayActionType.PLOT_MAZE_PLAY_CLICK_ROLE_ANIM,
    [PlotType.PT_SHOW_BLACK_BACKGROUND] = DisplayActionType.PLOT_SHOW_BLACK_BACKGROUND,
    [PlotType.PT_HIDE_BLACK_BACKGROUND] = DisplayActionType.PLOT_HIDE_BLACK_BACKGROUND,
    [PlotType.PT_CARTOON] = DisplayActionType.PLOT_CATOON,
    [PlotType.PT_daditu_yidong] = DisplayActionType.PLOT_BIGMAPLINEANIM,
    [PlotType.PT_SHOW_ROLE_INTERACT_UI] = DisplayActionType.PLOT_SHOW_ROLE_INTERACT_UI,
    [PlotType.PT_WAIT] = DisplayActionType.PLOT_WAIT,
    [PlotType.PT_SHOW_IMG] = DisplayActionType.PLOT_SHOW_IMG,
    [PlotType.PT_MOVE_IMG] = DisplayActionType.PLOT_MOVE_IMG,
    [PlotType.PT_REMOVE_IMG] = DisplayActionType.PLOT_REMOVE_IMG,
    [PlotType.PT_WAIT_CLICK] = DisplayActionType.PLOT_WAIT_CLICK,
    [PlotType.PT_CLOSE_STORE] = DisplayActionType.PLOT_CLOSE_STORE,
    [PlotType.PT_OPEN_WINDOW] = DisplayActionType.PLOT_OPEN_WINDOW,
    [PlotType.PT_CUSTOM_PLOT] = DisplayActionType.PLOT_CUSTEM_PLOT,
    [PlotType.PT_OPEN_SELECT_CLAN] = DisplayActionType.PLOT_OPEN_SELECT_CLAN,
    [PlotType.PT_ADD_DANMU] = DisplayActionType.PLOT_SHOW_DANMU,
    [PlotType.PT_SHOW_BUBBLE] = DisplayActionType.PLOT_SHOW_BATTLEBUBBLE,
    [PlotType.PT_SHOW_CLAN_INFO] = DisplayActionType.PLOT_SHOW_CLAN_INFO,
    [PlotType.PT_SHOW_FORGEMAKE] = DisplayActionType.PLOT_SHOW_FORGEMAKE,
    [PlotType.PT_TOAST] = DisplayActionType.PLOT_TOAST,
    -- [PlotType.PT_ROLE_LVUP] = DisplayActionType.PLOT_ROLE_LVUP,      -- 升级现在不走剧情, 从单独的下行走
    -- [PlotType.PT_MARTIAL_LVUP] = DisplayActionType.PLOT_MARTIAL_LVUP,        -- 升级现在不走剧情, 从单独的下行走
    [PlotType.PT_SHOW_FOREGROUND] = DisplayActionType.PLOT_SHOW_PLOTFOREGROUND,
    [PlotType.PT_REMOVE_FOREGROUND] = DisplayActionType.PLOT_REMOVE_PLOTFOREGROUND,
    [PlotType.PT_OPEN_MARRY_CONSULT] = DisplayActionType.PLOT_OPEN_MARRY_CONSULT,
    [PlotType.PT_OPEN_CLANMARTIAL] = DisplayActionType.PLOT_OPEN_CLANMARTIAL,
    [PlotType.PT_BATTLE_INSERT_ROUND_INFO] = DisplayActionType.PLOT_BATTLE_INSERT_ROUND_INFO,
    [PlotType.PT_OPEN_INTERACT_LEARN] = DisplayActionType.PLOT_OPEN_INTERACT_LEARN,
    [PlotType.PT_OPEN_OBSBABY] = DisplayActionType.PLOT_OPEN_OBSBABY,
    [PlotType.PT_OPEN_GETBABY] = DisplayActionType.PLOT_OPEN_GETBABY,  
    [PlotType.PT_OPEN_FINALBATTLE_EMBATTLE] = DisplayActionType.PLOT_OPEN_FINALBATTLE_EMBATTLE,
    [PlotType.PT_zhixing_yindao] = DisplayActionType.PLOT_START_GUIDE,
    [PlotType.PT_PLAY_SOUND] = DisplayActionType.PLOT_PLAY_SOUND,
    [PlotType.PLOT_BIGMAPMOVE_ENTERCITY] = DisplayActionType.PLOT_BIGMAPMOVE_ENTERCITY,
    [PlotType.PT_MAZE_SHOW_BUBBLE] = DisplayActionType.PLOT_MAZE_SHOW_BUBBLE,
    -- [PlotType.PT_HIDE_MENU_LAYER] = DisplayActionType.PLOT_HIDE_MENU_LAYER,            -- 隐藏菜单界面
    -- [PlotType.PT_RECOVER_MENU_LAYER] = DisplayActionType.PLOT_RECOVER_MENU_LAYER,         -- 恢复菜单界面
    [PlotType.PT_CHANGE_SCRIPT] = DisplayActionType.PLOT_CHANGE_SCRIPT,  -- 跳转剧本
    [PlotType.PT_SET_TEMP_BACKGROUND] = DisplayActionType.PLOT_SET_TEMP_BACKGROUND,  
    [PlotType.PT_REMOVE_TEMP_BACKGROUND] = DisplayActionType.PLOT_REMOVE_TEMP_BACKGROUND,  
    [PlotType.PT_PLAY_AUDIO] = DisplayActionType.PLAY_AUDIO,  
    [PlotType.PT_HIGHTOWER_REGIMENT_EMBATTLE] = DisplayActionType.PLOT_HIGHTOWER_REGIMENT_EMBATTLE,  
    [PlotType.PT_HIGHTOWER_STAGE_REWARD] = DisplayActionType.PLOT_HIGHTOWER_STAGE_REWARD,  
    [PlotType.PT_LUNJIAN] = DisplayActionType.PLOT_OPEN_HUASHAN_RANK, 
    [PlotType.PT_PLAY_MAP_ROLE_ANIM] = DisplayActionType.PLOT_PLAY_MAP_ROLE_ANIM, 
    [PlotType.PT_REMOVE_GIVEGIFTUI] = DisplayActionType.PLOT_REMOVE_GIVEGIFTUI, 
    [PlotType.PT_RECOVE_GIVEGIFTUI] = DisplayActionType.PLOT_RECOVE_GIVEGIFTUI, 
    [PlotType.PT_ANIM_OPENEYE] = DisplayActionType.PLOT_ANIM_OPENEYE, 
    [PlotType.PT_OPEN_SCRIPT_ARENA] = DisplayActionType.PLOT_OPEN_SCRIPT_ARENA,
    [PlotType.PT_CLOSE_FORGEMAKE] = DisplayActionType.PLOT_CLOSE_FORGEMAKE,
    [PlotType.PT_OPEN_ROLE_CHALLENGE] = DisplayActionType.PLOT_OPEN_ROLE_CHALLENGE,
    [PlotType.PT_OPEN_COLLECT_ACTIVITY] = DisplayActionType.PLOT_OPEN_COLLECT_ACTIVITY,
    [PlotType.PT_OPEN_MULTDROP_ACTIVITY] = DisplayActionType.PLOT_OPEN_MULTDROP_ACTIVITY,
    [PlotType.PT_PLAY_VOCAL] = DisplayActionType.PLOT_PLAY_VOCAL,
    [PlotType.PT_CAMERA_ANIM] = DisplayActionType.PLOT_CAMERA_ANIM,
}

function PlotDataManager:GetInstance()
    if PlotDataManager._instance == nil then
        PlotDataManager._instance = PlotDataManager.new()
        PlotDataManager._instance:Init()
    end

    return PlotDataManager._instance
end

function PlotDataManager:Init()
end

function PlotDataManager:AddPlot(plotTaskID, plotID, plotData)
    if g_isLoadStory then 
        g_isLoadStory = false
    end
    if g_processDelStory then 
        -- 删档处理时的进入剧本不做处理
        return
    end
    if plotData == nil and not self:GetPlotData(plotID) then 
        return false
    end
    self:SavePlotLog(plotTaskID, plotID)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_EXECUTE_PLOT, false, plotTaskID, plotID, plotData)
    return true
end

function PlotDataManager:ExecutePlot(plotTaskID, plotID, plotData)
    self:RemovePlotLog(plotTaskID, plotID)
    plotData = plotData or self:GetPlotData(plotID)
    if not plotData then 
        DisplayActionEnd()
        return 
    end
    local plotType = plotData.PlotType == PlotType.PT_BATTLE_WAITTIME and PlotType.PT_WAIT or plotData.PlotType
    local actionType = self:GetActionType(plotType)
    local actionParamsList = {}
    for i = 1, 10 do 
        table.insert(actionParamsList, plotData['Param' .. i])
    end
    TaskDataManager:GetInstance():SetCurTaskID(plotTaskID)
    DisplayActionManager:GetInstance():ExecuteAction(actionType, table.unpack(actionParamsList, 1, 10))
end

function PlotDataManager:SavePlotLog(taskID, plotID)
    local curStoryID = GetCurScriptID()
    if not curStoryID then 
        return
    end
    curStoryID = tostring(curStoryID)
    local playerID = globalDataPool:getData("PlayerID")
    local plotLogDict = GetConfig('PlotLog') or {}
    if plotLogDict.playerID ~= playerID then 
        plotLogDict = {
            playerID = playerID
        }
    end
    local plotLog = plotLogDict[curStoryID] or {}
    table.insert(plotLog, {
        PlotID = plotID,
        TaskID = taskID
    })
    plotLogDict[curStoryID] = plotLog
    SetConfig('PlotLog', plotLogDict, true)
end

function PlotDataManager:RemovePlotLog(taskID, plotID)
    local curStoryID = GetCurScriptID()
    if not curStoryID then 
        return
    end
    curStoryID = tostring(curStoryID)
    local plotLogDict = GetConfig('PlotLog') or {}
    if plotLogDict[curStoryID] == nil then 
        return 
    end
    local plotLog = plotLogDict[curStoryID]
    for index, plotInfo in ipairs(plotLog) do 
        if plotInfo ~= nil and plotInfo.PlotID == plotID then 
            table.remove(plotLog, index)
        end
    end
    SetConfig('PlotLog', plotLogDict, true)
end

function PlotDataManager:ClearPlotLog(storyID)
    if storyID == nil then 
        return
    end
    storyID = tostring(storyID)
    local plotLogDict = GetConfig('PlotLog') or {}
    plotLogDict[storyID] = nil
    SetConfig('PlotLog', plotLogDict, true)
end

function PlotDataManager:LoadPlot(storyID)
    g_isLoadStory = false
    if storyID == nil then 
        return
    end
    if g_processDelStory then 
        -- 删档处理时的进入剧本不做处理
        return
    end
    local plotLogDict = GetConfig('PlotLog')
    local playerID = globalDataPool:getData("PlayerID")
    if plotLogDict == nil or plotLogDict.playerID ~= playerID then 
        return 
    end
    storyID = tostring(storyID)
    local plotLog = plotLogDict[storyID] or {}
    self:ClearPlotLog(storyID)
    for _, plotInfo in ipairs(plotLog) do 
        local plotID = plotInfo.PlotID
        local taskID = plotInfo.TaskID
        self:AddPlot(taskID, plotID)
    end
end

function PlotDataManager:AddCustomPlot(plotTaskID, plotType, ...)
    local actionParamsList = {...}
    local actionType = self:GetActionType(plotType)
    local canMergeRun = self:CanActionMergeRun(plotType)
    TaskDataManager:GetInstance():SetCurTaskID(plotTaskID)
    DisplayActionManager:GetInstance():AddAction(actionType, canMergeRun, table.unpack(actionParamsList, 1, 10))
end

function PlotDataManager:GetActionType(plotType)
    return typeMap[plotType]
end

function PlotDataManager:CanActionMergeRun(plotType)
    local canMergeRun = false
    if plotType == PlotType.PT_CHOOSE or plotType == PlotType.PT_SHOW_CHOOSE_TEXT then 
        canMergeRun = true
    end
    return canMergeRun
end

function PlotDataManager:GetPlotData(plotID)
    return TableDataManager:GetInstance():GetTableData("Plot",plotID)
end

--==------------------------ 具体剧情功能函数实现 ------------------------
function PlotDataManager:DisplayDialogue(param1, param2,param3,param4,param5,param6,param7,param8,param9,param10)
    if g_skipAllUselessAnim then
        DisplayActionEnd()
        return
    end
    local roleTypeID = 0
    if param1 == 'MAINROLE' or param1 == '1' then      -- ID为1指代主角
        roleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
    else
        roleTypeID = DecodeNumber(param1)
    end
    local dialogueID = DecodeNumber(param2)
    local StoryAction = param3
    local StoryEffect = param4
    local StoryMood = param5
    local resourceBgmID = DecodeNumber(param6) -- 音效
    local playerID = DecodeNumber(param8) -- 玩家ID

    local dialogueInfo = {}
    dialogueInfo.dialogueID = dialogueID
    dialogueInfo.roleTypeID = roleTypeID
    dialogueInfo.StoryAction = StoryAction
    dialogueInfo.StoryEffect = StoryEffect
    dialogueInfo.StoryMood = StoryMood
    dialogueInfo.resourceBgmID = resourceBgmID
    dialogueInfo.taskID = TaskDataManager:GetInstance():GetCurTaskID()
    dialogueInfo.playerID = playerID
    OpenWindowImmediately("DialogChoiceUI", {dialogui = dialogueInfo})
end

-- 给客户端用的展示自定义字符串的对话,不走语言表
function PlotDataManager:DisplayCustomStrDialogue(roleTypeID, customStr,param3,param4,param5,param6,param7,param8,param9,param10)
    if g_skipAllUselessAnim then
        DisplayActionEnd()
        return
    end

    local StoryAction = param3
    local StoryEffect = param4
    local StoryMood = param5
    local resourceBgmID = DecodeNumber(param6) -- 音效

    local dialogueInfo = {}
    dialogueInfo.dialogueStr = customStr
    dialogueInfo.roleTypeID = roleTypeID
    dialogueInfo.StoryAction = StoryAction
    dialogueInfo.StoryEffect = StoryEffect
    dialogueInfo.StoryMood = StoryMood
    dialogueInfo.resourceBgmID = resourceBgmID
    dialogueInfo.taskID = TaskDataManager:GetInstance():GetCurTaskID()
    OpenWindowImmediately("DialogChoiceUI", {dialogui = dialogueInfo})
end

-- 给客户端用的展示自定义字符串的显示文字,不走语言表
function PlotDataManager:DisplayCustomStrShowChooseText(roleTypeID, customStr,param3,param4,param5,param6,param7,param8,param9,param10)
    local tipText = param3
    local boolean_outline = false
    if param4 == "1" then 
        boolean_outline = true
    end
    OpenWindowImmediately("DialogChoiceUI")
    local choiceUI = GetUIWindow('DialogChoiceUI')
    if choiceUI then 
        choiceUI:UpdateChoiceTextStr(customStr, roleTypeID, tipText,boolean_outline)
    end
end

-- 临时角色名称和立绘的剧情对话
-- param1:角色名称语言表ID param2:角色模型ID
function PlotDataManager:DisplayTempDialogue(param1, param2,param3,param4,param5,param6,param7,param8,param9,param10)
    if g_skipAllUselessAnim then
        DisplayActionEnd()
        return
    end
    local roleArtID = DecodeNumber(param1)
    local roleNameLangID = DecodeNumber(param2)
    local dialogueID = DecodeNumber(param10)
    local StoryAction = param3
    local StoryEffect = param4
    local StoryMood = param5
    local resourceBgmID = DecodeNumber(param6) -- 音效
    
    local dialogueInfo = {}
    dialogueInfo.dialogueID = dialogueID
    dialogueInfo.roleNameID = roleNameLangID
    dialogueInfo.roleArtID = roleArtID
    dialogueInfo.StoryAction = StoryAction
    dialogueInfo.StoryEffect = StoryEffect
    dialogueInfo.StoryMood = StoryMood
    dialogueInfo.resourceBgmID = resourceBgmID
    dialogueInfo.taskID = TaskDataManager:GetInstance():GetCurTaskID()
    OpenWindowImmediately("DialogChoiceUI", {dialogui = dialogueInfo})
end

function PlotDataManager:AddChoice(param1, param2, param3, param4, param5)
    local choiceLangID = DecodeNumber(param1)
    local isLocked = DecodeNumber(param2) == -1 or param2 == false
    local customCallback = param3
    local choiceText = param4
    local isKeyChoice = param5 == 'True'
    OpenWindowImmediately("DialogChoiceUI")
    local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
    if dialogChoiceUI then 
        dialogChoiceUI:AddChoice(choiceLangID, customCallback, isLocked, choiceText, isKeyChoice)
    end
end

-- param1:无用；param2：角色ID（string或int）；param3：内容；param4: 是否描边（'1'）
function PlotDataManager:ShowChoiceText(param1, param2, param3,param4)
    local textLangID = DecodeNumber(param1)
    local roleTypeID = 0
    if param2 == 'MAINROLE' or param2 == '1' then 
        roleTypeID = RoleDataManager:GetInstance():GetMainRoleTypeID()
    else
        roleTypeID = DecodeNumber(param2)
    end
    local tipText = param3
    local boolean_outline = false
    if param4 == "1" then 
        boolean_outline = true
    end
    OpenWindowImmediately("DialogChoiceUI")
    local choiceUI = GetUIWindow('DialogChoiceUI')
    if choiceUI then 
        choiceUI:UpdateChoiceText(textLangID, roleTypeID, tipText,boolean_outline)
    end
end

function PlotDataManager:OpenObserveWindow(param1)
    local roleID = DecodeNumber(param1)
    OpenWindowImmediately("ObserveUI", {['roleID'] = roleID})
end

function PlotDataManager:OpenZangJingGeWindow(...)
    local params = {...}
    local out = {}
    for i,v in ipairs(params) do
        if v ~= '' then
            out[#out + 1] = DecodeNumber(v)
        end
    end
    OpenWindowImmediately("ClanMartialUI", {false, 10, out}) --少林 测试
end

function GetAnimNameByEnum(animEnum)
    return AnimEnumNameMap[animEnum] or ''
end

function PlotDataManager:ChangeCueScript_Out(iTarScriptID)
    -- OpenWindowImmediately("LoadingUI")
    PlayerSetDataManager:GetInstance():SetChangingScript(iTarScriptID)
    -- 退出剧本
    if (IsGameServerMode()) then
		SendClickQuitStoryCMD()
	else
		QuitStory()
    end
end

function PlotDataManager:IsChangingScript()
    local bIsChanging = PlayerSetDataManager:GetInstance():GetChangingScript()
    return (bIsChanging == true)
end

function PlotDataManager:ChangeCueScript_In()
    local bIsChanging, iTarScriptID = PlayerSetDataManager:GetInstance():GetChangingScript()
    if not iTarScriptID then
        return
    end
    -- 清空数据
    PlayerSetDataManager:GetInstance():SetChangingScript(nil)
    EnterStory(iTarScriptID, false, false, false)
end
