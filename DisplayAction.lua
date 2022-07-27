
function DisplayActionManager:InitFunctionMap()
    self.functionMap = {}
    self.functionMap[DisplayActionType.COMMON_CHANGE_SCENE] = self.ActionChangeScene
    self.functionMap[DisplayActionType.WIN_OPEN] = self.ActionOpenWindow
    self.functionMap[DisplayActionType.WIN_REMOVE] = self.ActionRemoveWindow
    self.functionMap[DisplayActionType.WIN_UNLOAD] = self.ActionUnloadWindow
    self.functionMap[DisplayActionType.PLOT_DIALOGUE] = self.ActionPlotDialogue
    self.functionMap[DisplayActionType.PLOT_LINSHI_JUESE_DUIHUA] = self.ActionTempPlotDialogue
    self.functionMap[DisplayActionType.PLOT_CHOOSE] = self.ActionPlotChoose
    self.functionMap[DisplayActionType.PLOT_SHOW_CHOOSE_TEXT] = self.ActionPlotShowChooseText
    self.functionMap[DisplayActionType.PLOT_OPEN_OBSERVE_WINDOW] = self.ActionPlotOpenObserveWindow
    self.functionMap[DisplayActionType.PLOT_OPEN_ZANGJINGGE] = self.ActionPlotOpenZangJingGeWindow
    self.functionMap[DisplayActionType.PLOT_MAZE_PLAY_CLICK_ROLE_ANIM] = self.ActionPlotMazePlayClickRoleAnim
    self.functionMap[DisplayActionType.PLOT_SHOW_BLACK_BACKGROUND] = self.ActionPlotShowBlackBackground
    self.functionMap[DisplayActionType.PLOT_HIDE_BLACK_BACKGROUND] = self.ActionPlotHideBlackBackground
    self.functionMap[DisplayActionType.PLOT_CATOON] = self.ActionPlotCartoon
    self.functionMap[DisplayActionType.PLOT_BIGMAPLINEANIM] = self.ActionPlotBigMapLineAnim
    self.functionMap[DisplayActionType.PLOT_SHOW_ROLE_INTERACT_UI] = self.ActionPlotShowInteractUI
    self.functionMap[DisplayActionType.PLOT_WAIT] = self.ActionPlotWait
    self.functionMap[DisplayActionType.PLOT_SHOW_IMG] = self.ActionPlotShowIMG
    self.functionMap[DisplayActionType.PLOT_MOVE_IMG] = self.ActionPlotMoveIMG
    self.functionMap[DisplayActionType.PLOT_REMOVE_IMG] = self.ActionPlotRemoveIMG
    self.functionMap[DisplayActionType.PLOT_WAIT_CLICK] = self.ActionPlotWaitClick
    self.functionMap[DisplayActionType.PLOT_CLOSE_STORE] = self.ActionCloseStore
    self.functionMap[DisplayActionType.PLOT_OPEN_WINDOW] = self.ActionPlotOpenWindow
    self.functionMap[DisplayActionType.PLOT_CUSTEM_PLOT] = self.ActionPlotCustomPlot
    self.functionMap[DisplayActionType.PLOT_ENTER_CITY] = self.ActionPlotEnterCity
    self.functionMap[DisplayActionType.PLOT_TASK_COMPLETE] = self.ActionPlotTaskComplete
    self.functionMap[DisplayActionType.PLOT_MONTH_EVOLUTION] = self.ActionPlotMonthEvolution
    self.functionMap[DisplayActionType.PLOT_SHOW_FOREGROUND] = self.ActionPlotShowForground
    self.functionMap[DisplayActionType.PLOT_OB_ROLE] = self.ActionPlotObserveRole
    self.functionMap[DisplayActionType.PLOT_MAZE_MOVE] = self.ActionPlotMazeMove
	self.functionMap[DisplayActionType.PLOT_DIALOGUE_STR] = self.ActionPlotDialogueStr
    self.functionMap[DisplayActionType.PLOT_LEVELUP] = self.ActionPlotLevelUp
    self.functionMap[DisplayActionType.PLOT_OPEN_SELECT_CLAN] = self.ActionPlotOpenSelectClanUI
    self.functionMap[DisplayActionType.PLOT_MAZE_GRID_UNLOCK_ANIM] = self.ActionPlotMazeGridUnlockAnim
    self.functionMap[DisplayActionType.PLOT_SHOW_DANMU] = self.ActionPlotShowDanMu
    self.functionMap[DisplayActionType.PLOT_SHOW_BATTLEBUBBLE] = self.ActionPlotShowBattleBubble
    self.functionMap[DisplayActionType.PLOT_MAZE_TRIGGER_ADV_GIFT] = self.ActionPlotMazeTriggerAdvGift
    self.functionMap[DisplayActionType.PLOT_TOAST] = self.ActionPlotToast
    self.functionMap[DisplayActionType.PLOT_SHOW_CLAN_INFO] = self.ActionPlotShowClanInfo
    self.functionMap[DisplayActionType.PLOT_MAP_MOVE] = self.ActionPlotMapMove
    self.functionMap[DisplayActionType.PLOT_SHOW_FORGEMAKE] = self.ActionShowForgeMake
    self.functionMap[DisplayActionType.PLOT_SHOW_GOLD_ANIM] = self.ActionShowGoldAnim
    self.functionMap[DisplayActionType.PLOT_TASK_BROADCAST_TIPS] = self.ActionTaskBroadcastTips
    -- self.functionMap[DisplayActionType.PLOT_ROLE_LVUP] = self.ActionPlotRoleLvUp  -- 升级现在走不走剧情, 走单独的下行
    -- self.functionMap[DisplayActionType.PLOT_MARTIAL_LVUP] = self.ActionPlotMartialLvUp  -- 升级现在走不走剧情, 走单独的下行
    self.functionMap[DisplayActionType.PLOT_CUSTOM_CHOICE] = self.ActionCustomChoiceWithCallback
    self.functionMap[DisplayActionType.PLOT_ROLE_CHOICE] = self.ActionRoleChoiceWithCallback
    self.functionMap[DisplayActionType.PLOT_SHOW_PLOTFOREGROUND] = self.ActionPlotShowPlotForeground
    self.functionMap[DisplayActionType.PLOT_REMOVE_PLOTFOREGROUND] = self.ActionPlotRemovePlotForeground
    self.functionMap[DisplayActionType.PLOT_OPEN_MARRY_CONSULT] = self.ActionPlotOpenMarryConsult
    self.functionMap[DisplayActionType.PLOT_OPEN_CLANMARTIAL] = self.ActionPlotOpenClanMartial
    self.functionMap[DisplayActionType.PLOT_SHOW_CHOOSE_TEXT_STR] = self.ActionPlotShowChooseTextStr
    self.functionMap[DisplayActionType.PLOT_BATTLE_INSERT_ROUND_INFO] = self.BattleInsertRoundInfo
    self.functionMap[DisplayActionType.PLOT_OPEN_INTERACT_LEARN] = self.ActionOpenInteractLearn
    self.functionMap[DisplayActionType.PLOT_OPEN_OBSBABY] = self.ActionPlotOpenBabyObs
    self.functionMap[DisplayActionType.PLOT_OPEN_GETBABY] = self.ActionPlotOpenGetBaby
    self.functionMap[DisplayActionType.PLOT_OPEN_FINALBATTLE_EMBATTLE] = self.ActionPlotOpenFinalBattleEmbattle
    self.functionMap[DisplayActionType.PLOT_SHOWDATA_END_RECORD_DEQUEUE] = self.ActionPlotShowDataEndRecordDequeue
    self.functionMap[DisplayActionType.PLOT_START_GUIDE] = self.ActionStartGuide
    self.functionMap[DisplayActionType.PLOT_PLAY_SOUND] = self.ActionPlaySound
    self.functionMap[DisplayActionType.PLOT_BIGMAPMOVE_ENTERCITY] = self.BigMapMoveAndEnterCity
    self.functionMap[DisplayActionType.PLOT_MAZE_SHOW_BUBBLE] = self.MazeShowBubble
    self.functionMap[DisplayActionType.PLOT_HIDE_MENU_LAYER] = self.HideMenuLayer
    self.functionMap[DisplayActionType.PLOT_RECOVER_MENU_LAYER] = self.RecoverMenuLayer
    self.functionMap[DisplayActionType.PLOT_SHOW_CHOICE_WINDOW] = self.ShowChoiceWindow
    self.functionMap[DisplayActionType.UPDATE_MAZE_UI] = self.UpdateMazeUI
    self.functionMap[DisplayActionType.UPDATE_MAZE_GRID_UI] = self.UpdateMazeGridUI
    self.functionMap[DisplayActionType.MAZE_ENEMY_ESCAPE] = self.MazeEnemyEscape
    self.functionMap[DisplayActionType.RECOVER_INTERACT_STATE] = self.RecoverInteractState
    self.functionMap[DisplayActionType.PLOT_CHANGE_SCRIPT] = self.ActionChangeScript
    self.functionMap[DisplayActionType.PLOT_NETMSG_TOAST] = self.ActionNetMsgToast
    self.functionMap[DisplayActionType.PLOT_SET_TEMP_BACKGROUND] = self.ActionSetTempBackground
    self.functionMap[DisplayActionType.PLOT_REMOVE_TEMP_BACKGROUND] = self.ActionRemoveTempBackground
    self.functionMap[DisplayActionType.PLAY_AUDIO] = self.ActionPlayAudio
    self.functionMap[DisplayActionType.PLOT_HIGHTOWER_REGIMENT_EMBATTLE] = self.ActionHighTowerEmbattle
    self.functionMap[DisplayActionType.PLOT_HIGHTOWER_STAGE_REWARD] = self.ActionHighTowerStageReward
    self.functionMap[DisplayActionType.PLOT_MAP_ROLE_ESCAPE] = self.MapRoleEnemyEscape
    self.functionMap[DisplayActionType.PLOT_SUBMIT_ITEM] = self.SubmitItem
    self.functionMap[DisplayActionType.PLOT_OPEN_RANDOM_ROLL] = self.OpenRandomRoll
    self.functionMap[DisplayActionType.PLOT_OPEN_HUASHAN_RANK] = self.OpenHuaShanRank
    self.functionMap[DisplayActionType.PLOT_UPDATE_MAP_EFFECT] = self.UpdateMapEffect
    self.functionMap[DisplayActionType.PLOT_PLAY_MAP_ROLE_ANIM] = self.PlayMapRoleAnim

    self.functionMap[DisplayActionType.PLOT_REMOVE_GIVEGIFTUI] = self.Remove_GiveGiftUI
    self.functionMap[DisplayActionType.PLOT_RECOVE_GIVEGIFTUI] = self.Recove_GiveGiftUI
    self.functionMap[DisplayActionType.PLOT_EXECUTE_PLOT] = self.ExecutePlot
    self.functionMap[DisplayActionType.PLOT_ANIM_OPENEYE] = self.Animation_OpenEye
    self.functionMap[DisplayActionType.PLOT_OPEN_SCRIPT_ARENA] = self.ActionOpenScriptArena
    self.functionMap[DisplayActionType.PLOT_CLOSE_FORGEMAKE] = self.ActionCloseForgeMake
    self.functionMap[DisplayActionType.PLOT_OPEN_DISCOUNTUI] = self.ActionOpenClickDiscountUI
    self.functionMap[DisplayActionType.PLOT_OPEN_ROLE_CHALLENGE] = self.ActionOpenRoleChallengeUI

    self.functionMap[DisplayActionType.PLOT_OPEN_COLLECT_ACTIVITY] = self.OpenCollectActivity
    self.functionMap[DisplayActionType.PLOT_OPEN_MULTDROP_ACTIVITY] = self.OpenMultDropActivity
    self.functionMap[DisplayActionType.PLOT_NPC_CITY_MOVE] = self.NpcCityMove
    self.functionMap[DisplayActionType.PLOT_OPENLIMITSHOP] = self.OpenLimitShop
    self.functionMap[DisplayActionType.PLOT_PLAY_VOCAL] = self.PlayVocal
    self.functionMap[DisplayActionType.PLOT_DIALOGUE_LIMITSHOP] = self.DiaologueLimitShop

     self.functionMap[DisplayActionType.PLOT_OPEN_LEVEL_UP] = self.ActionShowLevelUp
     self.functionMap[DisplayActionType.PLOT_CAMERA_ANIM] = self.CameraAnim
end
-- 
function DisplayActionManager:ActionOpenScriptArena(data)
    local arenaScriptDataManager = ArenaScriptDataManager:GetInstance();
    arenaScriptDataManager:FormatScriptArenaData(data);
    local matchTypeData = arenaScriptDataManager:GetMatchTypeData();
    OpenWindowImmediately("ArenaScriptMatchUI", matchTypeData);
    local arenaScriptMatchUI = GetUIWindow('ArenaScriptMatchUI');
    arenaScriptMatchUI:InitData(data);
    arenaScriptMatchUI:OnRefSCLeft1();
    arenaScriptMatchUI:OnRefLeftTop();
    arenaScriptMatchUI:OnRefLeftBot();
    arenaScriptMatchUI:MoveToCurRound();
    arenaScriptMatchUI:BetDanMu();
    DisplayActionEnd()
end

-- 切换场景
function DisplayActionManager:ActionChangeScene(sScenceName, notDestroyWindow, func)
    local finishCallback = function()
        if type(func) == 'function' then 
            func()
        end
        DisplayActionEnd()
    end
    ChangeScenceImmediately(sScenceName, notDestroyWindow, finishCallback)
end

-- 打开界面 OpenWindow
function DisplayActionManager:ActionOpenWindow(...)
    local paramsList = {...}
    OpenWindowImmediately(...)
    if not CUSTOM_ACTIONEND_UI_NAME[paramsList[1]] then
        DisplayActionEnd()
    end
end

-- 关闭界面 RemoveWindow
function DisplayActionManager:ActionRemoveWindow(...)
    RemoveWindowImmediately(...)
    DisplayActionEnd()
end

-- 卸载界面 UnloadWindow
function DisplayActionManager:ActionUnloadWindow()
    UnLoadAll(false)
    DisplayUpdateScene()
    DisplayActionEnd()
end

-- 对话
function DisplayActionManager:ActionPlotDialogue(...)
    PlotDataManager:GetInstance():DisplayDialogue(...)
end

-- 对话
function DisplayActionManager:ActionPlotDialogueStr(...)
    PlotDataManager:GetInstance():DisplayCustomStrDialogue(...)
end

-- 对话
function DisplayActionManager:ActionPlotShowChooseTextStr(...)
    PlotDataManager:GetInstance():DisplayCustomStrShowChooseText(...)
    DisplayActionEnd()
end

-- 对话
function DisplayActionManager:ActionTempPlotDialogue(...)
    PlotDataManager:GetInstance():DisplayTempDialogue(...)
end
-- 选择选项
function DisplayActionManager:ActionPlotChoose(...)
    PlotDataManager:GetInstance():AddChoice(...)
end

-- 显示文字
function DisplayActionManager:ActionPlotShowChooseText(...)
    PlotDataManager:GetInstance():ShowChoiceText(...)
end

-- 打开观察界面
function DisplayActionManager:ActionPlotOpenObserveWindow(...)
    PlotDataManager:GetInstance():OpenObserveWindow(...)
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotOpenZangJingGeWindow(...)
    PlotDataManager:GetInstance():OpenZangJingGeWindow(...)
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotMazePlayClickRoleAnim(row, column, animType, isLoop, needRecover)
    if not IsWindowOpen('MazeUI') then 
        DisplayActionEnd()
        return 
    end
    local mazeUI = GetUIWindow('MazeUI')
    local animName = GetAnimNameByEnum(animType)
    if type(isLoop) == 'string' then 
        isLoop = isLoop == 'True'
    end
    if type(needRecover) == 'string' then 
        needRecover = needRecover == 'True'
    end
    local animTime = mazeUI:PlayRoleAnim(row, column, animName, isLoop, needRecover)
    if animTime == 0 or animTime == nil then 
        DisplayActionEnd()
    else
        globalTimer:AddTimer(animTime, DisplayActionEnd, 1)
    end
end

function DisplayActionManager:ActionPlotShowBlackBackground(...)
    local paramsList = {...}
    local duration = DecodeNumber(paramsList[1]) or 1
    local waitAnimEnd = paramsList[2] ~= 'False'
    local actionInfo = {['isShow'] = true, ['duration'] = duration, ['waitAnimEnd'] = waitAnimEnd}
    OpenWindowImmediately('BlackBackgroundUI', actionInfo)
end

function DisplayActionManager:ActionPlotHideBlackBackground(...)
    local paramsList = {...}
    local duration = DecodeNumber(paramsList[1]) or 1
    local waitAnimEnd = paramsList[2] ~= 'False'
    local actionInfo = {['isShow'] = false, ['duration'] = duration, ['waitAnimEnd'] = waitAnimEnd}
    OpenWindowImmediately('BlackBackgroundUI', actionInfo)
end

function DisplayActionManager:ActionPlotCartoon(...)
    dprint("ActionPlotCartoon!!!")
    local paramsList = {...}
    local cartoonId = DecodeNumber(paramsList[1]) or 1
    OpenWindowImmediately("CartoonUI", {CartoonId = cartoonId})
end

-- 主角大地图移动动画
function DisplayActionManager:ActionPlotBigMapLineAnim(srcCityBaseID, dstCityBaseID, p1, p2, p3)
    -- if dstCityBaseID & 0x10000000 ~= 0 then
        -- derror(string.format(" dstCity %x %d %d", srcCityBaseID or 0, p2 or 0, p3 or 0))        
        local tileMap
        if not IsWindowOpen('TileBigMap') then
            tileMap = OpenWindowImmediately("TileBigMap")
        else
            tileMap = GetUIWindow("TileBigMap")
        end
        
        tileMap:MapMove(srcCityBaseID, dstCityBaseID, p1, p2, p3)
        if p2 and p2 > 0 then
            return
        end
        DisplayActionEnd()
end

-- 显示交互界面
function DisplayActionManager:ActionPlotShowInteractUI(...)
    local paramsList = {...}
    local roleTypeID = DecodeNumber(paramsList[1])
    local roleID = RoleDataManager:GetInstance():GetRoleID(roleTypeID)
    local mapID = DecodeNumber(paramsList[2])
    OpenWindowImmediately("SelectUI", {roleID = roleID, mapID = mapID})
    DisplayActionEnd()
end

function DisplayActionManager:ActionCustomChoiceWithCallback(uiRoleID, dialogStr, choicelist)
    OpenWindowImmediately("DialogChoiceUI")
	local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
    if not dialogChoiceUI then
        DisplayActionEnd()
		return
    end
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiRoleID)
    if roleData then
        dialogChoiceUI:UpdateChoiceText(0, roleData.uiTypeID, dialogStr)
        for i = 1, #choicelist do
            dialogChoiceUI:AddChoice(0, choicelist[i].func, false, choicelist[i].str)
        end   
    end
end

function DisplayActionManager:ActionRoleChoiceWithCallback(roleTypeID, dialogStr, choicelist)
    OpenWindowImmediately("DialogChoiceUI")
	local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
    if not dialogChoiceUI then
        DisplayActionEnd()
		return
    end
    
    dialogChoiceUI:UpdateChoiceText(0, roleTypeID, dialogStr)
    for i = 1, #choicelist do
        dialogChoiceUI:AddChoice(0, choicelist[i].func, false, choicelist[i].str)
    end
end

-- 剧情等待
function DisplayActionManager:ActionPlotWait(timeStr)
    local waitTime = DecodeNumber(timeStr)
    if not dnull(waitTime) then 
        DisplayActionEnd()
        return 
    end
    globalTimer:AddTimer(waitTime, DisplayActionEnd, 1)
end

function DisplayActionManager:ActionPlotShowIMG(imgtag, imgpath, x, y, alpha, fittype)
    local dialogueUIInstacne = GetUIWindow("DialogChoiceUI")
    local pathID = DecodeNumber(imgpath)
    local cgType = CGType.CGT_CG;
    if dnull(pathID) then 
        local data = TableDataManager:GetInstance():GetTableData("ResourceCG",pathID)
        if (data) then
            imgpath = data.CGPath
            cgType = data.CGType
        end
    end
    OpenWindowImmediately('ComicPlotUI', {imgtag = imgtag, imgpath = imgpath, x = x, y = y, alpha = alpha, fittype = fittype, cgType = cgType})
end

function DisplayActionManager:ActionPlotMoveIMG(imgtag, x, y, alpha, dur, wait)
    OpenWindowImmediately('ComicPlotUI')
    x = DecodeNumber(x)
    y = DecodeNumber(y)
    alpha = DecodeNumber(alpha)
    dur = DecodeNumber(dur)
    wait = wait == 'True'
    local comicPlotUI = GetUIWindow("ComicPlotUI")
    if comicPlotUI then
        comicPlotUI:MoveIMG(imgtag, x, y, alpha, dur, wait)
    end
end

function DisplayActionManager:ActionPlotRemoveIMG(imgtag)
    OpenWindowImmediately('ComicPlotUI')
    local comicPlotUI = GetUIWindow("ComicPlotUI")
    if comicPlotUI then
        comicPlotUI:RemoveIMG(imgtag)
    end
end

function DisplayActionManager:ActionPlotWaitClick()
    OpenWindowImmediately('ComicPlotUI')
    local comicPlotUI = GetUIWindow("ComicPlotUI")
    if comicPlotUI then
        comicPlotUI:WaitClick()
    else
        OpenWindowImmediately('ComicPlotUI', {waitclick = true})
    end
end

function DisplayActionManager:ActionCloseStore()
    local storeUI = GetUIWindow("StoreUI");
    if storeUI then
        RemoveWindowImmediately("StoreUI", true);
    end
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotOpenWindow(uiname,shopid,roleid)
    OpenWindowImmediately(uiname,DecodeNumber(shopid))
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotCustomPlot_CPT_Custom_Zhuazhou(answers)
    if answers then 
        local AttrLangID = 140019
        local AttrLangID_percent = 140022
        local ItemLangID = 140021
        local RenyiLangID = 140019
        local TB_StoryZhuazhou = TableDataManager:GetInstance():GetTable("StoryZhuazhou")
        local state = #TB_StoryZhuazhou
        local rewardAttr = {}
        local rewardItem = {}
        local rewardRenyi = 0
        while answers > 0 do
            local answer = answers % 10
            answers = answers // 10
            local answerInfo = TB_StoryZhuazhou[state].Answer[answer]
            if answerInfo.RewardAttrs then
                for i=1,#answerInfo.RewardAttrs do
                    local enumID = answerInfo.RewardAttrs[i]
                    rewardAttr[enumID] = (rewardAttr[enumID] or 0) + (answerInfo.RewardAttrValues[i] or 0)
                end
            end
            if answerInfo.RewardItems then
                for i=1,#answerInfo.RewardItems do
                    local enumID = answerInfo.RewardItems[i]
                    rewardItem[enumID] = (rewardItem[enumID] or 0) + (answerInfo.RewardItemValues[i] or 0)
                end
            end
            rewardRenyi = rewardRenyi + answerInfo.RewardRenyi   
            state = state - 1             
        end
        -- 组装
        local ans = {}
        for k,v in pairs(rewardAttr) do
            local ret_string = getAttrBasedText(k, v)
            table.insert(ans,string.format(GetLanguageByID(AttrLangID), GetLanguageByEnum(k), ret_string))
        end
        
        for k,v in pairs(rewardItem) do
            table.insert(ans,string.format(GetLanguageByID(ItemLangID),ItemDataManager:GetInstance():GetItemName(nil,k,true), v))
        end
        if rewardRenyi ~= 0 then 
            table.insert(ans,string.format(GetLanguageByID(RenyiLangID),GetLanguageByID(157),rewardRenyi))
        end
        PlotDataManager:GetInstance():ShowChoiceText(nil,nil,GetLanguageByID(140020) .. table.concat(ans,'，'),"1")
    end
end

function DisplayActionManager:ActionPlotCustomPlot_CPT_Custom_ZhuazhouStart()
    OpenWindowImmediately("BornChooseUI")
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotCustomPlot_CPT_Custom_FiveBoss(langID,deadBoss,sayBoss)
    local sLang = GetLanguageByID(langID)
    local sName = RoleDataManager:GetInstance():GetRoleNameByTypeID(deadBoss)
    local sContent = string.format(sLang,sName)
    PlotDataManager:GetInstance():DisplayCustomStrDialogue(sayBoss,sContent,"显形",StoryEffect.SE_Mask)
end

function DisplayActionManager:ActionPlotCustomPlot(customPlotType,...)
    local iCustomPlotType = DecodeNumber(customPlotType)
    local param = {...}
    if iCustomPlotType == CustomPlotType.CPT_Custom_Zhuazhou then 
        self:ActionPlotCustomPlot_CPT_Custom_Zhuazhou(DecodeNumber(param[1]))
        DisplayActionEnd()
    elseif iCustomPlotType == CustomPlotType.CPT_Custom_FiveBoss then
        self:ActionPlotCustomPlot_CPT_Custom_FiveBoss(DecodeNumber(param[1]),DecodeNumber(param[2]),DecodeNumber(param[3]))
    elseif iCustomPlotType == CustomPlotType.CPT_Custom_ZhuazhouStart then
        self:ActionPlotCustomPlot_CPT_Custom_ZhuazhouStart()
    end
end

--播放城镇动画
function DisplayActionManager:ActionPlotEnterCity(mapId)
    OpenWindowImmediately("CityUI",mapId); 
end

function DisplayActionManager:ActionPlotTaskComplete(data)
    OpenWindowImmediately("TaskCompleteUI", data)
    TaskDataManager:GetInstance():RemoveTaskFromRunningList(data)
end

function DisplayActionManager:ActionPlotMonthEvolution(info)
    if type(info) ~= "table" then
        info = {}
        info.bHistory = true
    end
    OpenWindowImmediately("EvolutionUI", info)    
    TileDataManager:GetInstance().ev_dirty = true
end

function DisplayActionManager:ActionPlotShowForground()
    MapEffectManager:GetInstance():ShowMapEffectImmediately()
    
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotObserveRole(roleID)
    OpenWindowImmediately("ObserveUI", {['roleID'] = roleID})
end

function DisplayActionManager:ActionPlotMazeMove(curRow, curColumn, destRow, destColumn)
    local mazeUI = GetUIWindow("MazeUI")
    if mazeUI then
        local posFrom = {
            row = curRow, 
            column = curColumn
        }
        local posDest = {
            row = destRow, 
            column = destColumn
        }
        mazeUI:MazeMoveAnim(posFrom, posDest)
    else
        DisplayActionEnd()
    end
end

function DisplayActionManager:ActionPlotLevelUp(info)
    OpenWindowImmediately("LevelUPUI", info)
end

function DisplayActionManager:ActionPlotOpenSelectClanUI(isShowOnlyStr)
    local isShowOnly = isShowOnlyStr == 'True'
    OpenWindowImmediately("ClanUI", {isShowOnly = isShowOnly, closeActionEnd = true})
end

function DisplayActionManager:ActionPlotOpenClanEliminateUI(isShowOnlyStr)
    local isShowOnly = isShowOnlyStr == 'True'
    OpenWindowImmediately("ClanEliminateUI", isShowOnly)
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotMazeGridUnlockAnim(row, column)
    local mazeUI = GetUIWindow("MazeUI")
    if mazeUI then
        mazeUI:PlayUnlockGridAnim(row, column)
    else
        DisplayActionEnd()
    end
end

function DisplayActionManager:ActionPlotShowDanMu(text)
    -- local languageID = DecodeNumber(text)
    -- if dnull(languageID) then
    --     text = GetLanguageByID(languageID)
    -- end

    -- SystemUICall:GetInstance():BarrageShow(text, true)
    DisplayActionEnd()

end

function DisplayActionManager:ActionPlotShowBattleBubble(...)
    AnimationMgr:GetInstance():showBattleBubble(...)
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotMazeTriggerAdvGift(giftType, itemTypeID, coinCount)
    -- local mazeUI = GetUIWindow("MazeUI")
    -- if mazeUI then
        -- FIXME: 这个实现非常不好, 首先格式化内容应该放进语言表, 然后应该支持分气泡弹出, 但是为了赶进度临时先这么处理一下
        MazeDataManager:GetInstance():EnqueueBubble(giftType, itemTypeID, coinCount)
        MazeDataManager:GetInstance():DequeueBubble()
    -- else
    --     MazeDataManager:GetInstance():AddAdvGiftBubbleCache(giftType, itemTypeID, coinCount)
    -- end
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotToast(...)
    local param = {...}
    local textID = DecodeNumber(param[1])
    local str = null
    if not dnull(textID) then
        str = param[1]
    else
        local taskID = TaskDataManager:GetInstance():GetCurTaskID()
        str = GetLanguageByID(textID, taskID)
    end
    local isChat = false;
    if type(param[2]) == 'string' then
        isChat = param[2] == "True";
    else
        isChat = param[2] == true;
    end

    str = StringHelper:GetInstance():NameConversion(str)

    SystemUICall:GetInstance():Toast(str, isChat)
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotShowClanInfo(clanID)
    clanID = DecodeNumber(clanID)
    if not dnull(clanID) then 
        DisplayActionEnd()
        return
    end
    local clanData = ClanDataManager:GetInstance():GetClanData(clanID)
    OpenWindowImmediately('ClanCardUI', clanData)
end

function DisplayActionManager:ActionPlotMapMove(mapID)
    local gameState = GetGameState()
    --derror(string.format("ActionPlotMapMove %d %d", mapID, gameState))
    if gameState == GS_NORMALMAP then 
        DisplayUpdateScene()
        -- 如果没有播放该主城的动画, 那么播放进入主城动画
        local cityUI
        if not IsWindowOpen("CityUI") then
            cityUI = OpenWindowImmediately("CityUI")
        else
            cityUI = GetUIWindow("CityUI")
        end
        if cityUI:IsFirstEnterCity(mapID) then
            cityUI:DoCityOpenAnimation(mapID)
            return
        end
    end
    DisplayActionEnd()
end

function DisplayActionManager:ActionShowForgeMake(forgeNpcID)
    forgeNpcID = DecodeNumber(forgeNpcID)
    if dnull(forgeNpcID) then 
        -- 打开制造界面
        local info = {
            ['subView'] = "make_box",
            ['bMono'] = true,
            ['forgeNPCID'] = forgeNpcID,
            ['bOpenImmediately'] = true,
        }
        OpenWindowImmediately("ForgeUI", info)
    else
        OpenWindowImmediately("ForgeUI")
    end
    DisplayActionEnd()
end

function DisplayActionManager:ActionShowGoldAnim(before, after, type)
    if IsWindowOpen("GoldAnimUI") then
        local ui = GetUIWindow("GoldAnimUI")
        ui:PlayGoldAnim(before, after, type)
    else
        OpenWindowImmediately("GoldAnimUI", {
            before = before, 
            after = after, 
            type = type
        })
    end
    local win = GetUIWindow("ToptitleUI")	--通知toptitleUI更新
    if win then
        --tyoe == 3的时候 代表获得铜币
        if type == 3 then
            win:PlayTongbiAnim(before, after)
        end
        --win.bNeedUpdate = true
    end
    DisplayActionEnd()
end

function DisplayActionManager:ActionTaskBroadcastTips(taskUpdateInfo)
    local taskTipsUI = GetUIWindow('TaskTipsUI')
    if taskTipsUI then 
        taskTipsUI:AddNeedUpdateTaskInfo(taskUpdateInfo)
    end
    DisplayActionEnd()
end

-- function DisplayActionManager:ActionPlotRoleLvUp(roleID, oldLv, newLv)
--     roleID = DecodeNumber(roleID)
--     oldLv = DecodeNumber(oldLv)
--     newLv = DecodeNumber(newLv)
--     if dnull(oldLv) and dnull(newLv) and oldLv < newLv then 
--         local bCacheRes = RoleDataManager:GetInstance():CacheRoleLevelUpMsg(roleID, oldLv, newLv)
--         if bCacheRes then
--             RoleDataManager:GetInstance():ShowLevelUpMsg()
--             return
--         end
--     end
--     DisplayActionEnd()
-- end

-- function DisplayActionManager:ActionPlotMartialLvUp(roleID, martialBaseID, oldLv, newLv, hasNewAttr)
--     roleID = DecodeNumber(roleID)
--     martialBaseID = DecodeNumber(martialBaseID)
--     oldLv = DecodeNumber(oldLv)
--     newLv = DecodeNumber(newLv)
--     if dnull(oldLv) and dnull(newLv) and oldLv < newLv then 
--         local bCacheRes = MartialDataManager:GetInstance():CacheMartialLevelUpMsg(roleID, martialBaseID, oldLv, newLv, hasNewAttr == 'True')
--         if bCacheRes then
--             RoleDataManager:GetInstance():ShowLevelUpMsg()
--             return
--         end
--     end
--     DisplayActionEnd()
-- end

function DisplayActionManager:ActionShowLevelUp()
    local bShowRes = RoleDataManager:GetInstance():ShowLevelUpMsg()
    -- 如果升级界面打开失败, 那么直接End
    if bShowRes ~= true then
        DisplayActionEnd()
    end
end

function DisplayActionManager:CameraAnim(x, y, time, mode)
    local DialogControlUI = GetUIWindow("DialogControlUI")
    local bAutoChatOpen = false
    if DialogControlUI then
	    bAutoChatOpen = DialogRecordDataManager:GetInstance():IsAutoChatOpen() == true
        if bAutoChatOpen then
            DialogControlUI:OnClickOpenAuto()
        end
    end
    local tileMap = GetUIWindow("TileBigMap")
    if tileMap == nil then
        tileMap = OpenWindowImmediately("TileBigMap")
    end
    tileMap:CameraMove(x, y, time, mode)
    globalTimer:AddTimer(time + 500,function()
        --derror("timer end")
        DisplayActionEnd()
        if DialogControlUI and bAutoChatOpen then
            DialogControlUI:OnClickOpenAuto()
        end
    end)
end

function DisplayActionManager:ActionPlotShowPlotForeground(foregroundTypeID)
    foregroundTypeID = DecodeNumber(foregroundTypeID)
    if dnull(foregroundTypeID) then
        MapEffectManager:GetInstance():ShowTempMapEffect(foregroundTypeID)
    end
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotRemovePlotForeground()
    MapEffectManager:GetInstance():RemoveTempMapEffect()
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotOpenBabyObs(uiBabyRoleID)
    OpenWindowImmediately("ObsBabyUI",uiBabyRoleID)
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotOpenGetBaby(uiBabyRoleID)
    uiBabyRoleID = DecodeNumber(uiBabyRoleID)
    OpenWindowImmediately("GetBabyUI",uiBabyRoleID)
    --DisplayActionEnd()
end

function DisplayActionManager:ActionPlotOpenMarryConsult(uiRoleIDStr)
    local uiRoleID = DecodeNumber(uiRoleIDStr)
    if dnull(uiRoleID) then
        OpenWindowImmediately("NpcConsultUI", {uiRoleID, true})
    else
        DisplayActionEnd()
    end
    
end

function DisplayActionManager:ActionPlotOpenClanMartial(clanTypeID)
    if type(clanTypeID) == 'string' then
        clanTypeID = DecodeNumber(clanTypeID)
    end

    if dnull(clanTypeID) then
        OpenWindowImmediately("ClanMartialUI", {true, clanTypeID})
    end

    DisplayActionEnd()
end

function DisplayActionManager:ActionOpenInteractLearn(playerBehaviorType)
    playerBehaviorType = DecodeNumber(playerBehaviorType)
    OpenWindowImmediately("InteractUnlockUI", playerBehaviorType)
    DisplayActionEnd()
end

function DisplayActionManager:BattleInsertRoundInfo(langID,type)
    local Type = {
        "win",
        "fail",
        "other",
        "extra"
    }
    local mapType = {
        ['胜利条件'] = 'win',
        ['失败条件'] = 'fail',
        ['其他'] = 'other',
        ['额外'] = 'extra',
    }
    local stype = mapType[type] or Type[type] or 'other'
    BattleDataManager:GetInstance():AddRoundDescTipsInfo({GetLanguageByID(DecodeNumber(langID))},stype)
    DisplayActionEnd()
end

function DisplayActionManager:ActionStartGuide(uiGuideID,bIfRestart)
    if g_skipAllUselessAnim or (DEBUG_MODE and AutoTest_IsRunning()) then 
    else
        if bIfRestart and bIfRestart == "True" then 
            GuideDataManager:GetInstance():ClearGuide(uiGuideID)
        end 
        GuideDataManager:GetInstance():StartGuideByID(uiGuideID)
    end
    -- 加timer可以让空格连点快速点击弹出引导正确，但是有些之前的流程得调整了，比如月牙村北的建筑引导
    -- globalTimer:AddTimer(1000, DisplayActionEnd, 1)
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlaySound(resourceBgmID)
    PlaySound(toint(resourceBgmID))
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotOpenFinalBattleEmbattle(bIsInCity, uiFinalBattleCityID, bIsBoss)
    if type(bIsInCity) == "string" then
        bIsInCity = (bIsInCity == "True")
    end
    if type(uiFinalBattleCityID) == "string" then
        uiFinalBattleCityID = DecodeNumber(uiFinalBattleCityID)
    end
    if type(bIsBoss) == "string" then
        bIsBoss = (bIsBoss == "True")
    end

    if bIsBoss then
        OpenWindowImmediately("RoleEmbattleUI")
    else
        FinalBattleDataManager:GetInstance():EnterCityEmbattle(uiFinalBattleCityID, bIsInCity)
    end
    
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlotShowDataEndRecordDequeue(eType, uiID)
    ShowDataRecordManager:GetInstance():EndRecordDequeue(eType, uiID)

    DisplayActionEnd()
end

function DisplayActionManager:BigMapMoveAndEnterCity(fromCityStr, toCityStr)
    --OpenWindowImmediately('BigMapUI')
    --self:ActionPlotBigMapLineAnim(tonumber(fromCityStr), tonumber(toCityStr), BigmapMoveType.Bigmap_Move_Normal)
end

function DisplayActionManager:MazeShowBubble(contentLanguageID, roleID, contentStr)
    local mazeUI = GetUIWindow("MazeUI")
    if mazeUI then
        if type(contentLanguageID) == "string" then
            contentLanguageID = DecodeNumber(contentLanguageID)
        end
        if type(roleID) == "string" then
            roleID = DecodeNumber(roleID)
        end
    
        if not roleID then
            roleID = 0
        end

        if contentStr == "" then 
            contentStr = nil
        end
        contentStr = contentStr or GetLanguageByID(contentLanguageID)

        if not dnull(contentStr) then
            DisplayActionEnd()
            return
        end
        mazeUI:ShowBubble(roleID, contentStr, 1)
    end

    DisplayActionEnd()
end

-- 隐藏菜单界面
function DisplayActionManager:HideMenuLayer(needRunNextAction)
    self.forceHideMenuLayer = true
    self:HideToptitle()
    self:HideNavigation()
    if needRunNextAction ~= false then 
        DisplayActionEnd()
    end
end

-- 恢复菜单界面
function DisplayActionManager:RecoverMenuLayer(needRunNextAction)
    self.forceHideMenuLayer = false
    if self.isShowToptitle then 
        self:ShowToptitle(self.toptitleType)
    end
    if self.isShowNavigation then 
        self:ShowNavigation()
    end
    if needRunNextAction ~= false then 
        DisplayActionEnd()
    end
end

function DisplayActionManager:ShowToptitle(toptitleType, refreshImmediately)
    self.isShowToptitle = true
    self.toptitleType = toptitleType
    if self.forceHideMenuLayer then 
        return nil
    end
    local toptitleUI = OpenWindowImmediately('ToptitleUI', self.toptitleType)
    if refreshImmediately and toptitleUI then 
        toptitleUI:RefreshUIImmediately()
    end
    return toptitleUI
end

function DisplayActionManager:HideToptitle()
    self.isShowToptitle = false
    local toptitleUI = GetUIWindow('ToptitleUI')
    if toptitleUI ~= nil and toptitleUI:IsOpen() then 
        toptitleUI._gameObject.transform.localPosition = DRCSRef.Vec3Zero
    end
    return RemoveWindowImmediately('ToptitleUI')
end

function DisplayActionManager:ShowNavigation()
    self.isShowNavigation = true
    if self.forceHideMenuLayer then
        return nil
    end

    -- 有的时候开着但是状态不对, 还是每次都刷一下吧
    -- if IsWindowOpen("NavigationUI") then
    --     return
    -- end

    return OpenWindowImmediately('NavigationUI')
end

function DisplayActionManager:HideNavigation()
    self.isShowNavigation = false
    return RemoveWindowImmediately('NavigationUI')
end

function DisplayActionManager:ShowChoiceWindow(taskID)
    if TaskDataManager:GetInstance():GetChoiceInfo(taskID) == nil then 
        DisplayActionEnd()
    else
        g_curChoiceTask = taskID
        OpenWindowImmediately("DialogChoiceUI")
        local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
        dialogChoiceUI:UpdateChoice(taskID)
    end
end

function DisplayActionManager:UpdateMazeUI()
    local mazeUI = GetUIWindow('MazeUI')
    if mazeUI ~= nil then 
        mazeUI:SetUpdateMazeFlag(true)
    else
        DisplayActionEnd()
    end
end

function DisplayActionManager:UpdateMazeGridUI(gridID)
    local mazeUI = GetUIWindow('MazeUI')
    if mazeUI ~= nil and gridID then 
        mazeUI:UpdateMazeGrid(gridID)
    end
    DisplayActionEnd()
end

function DisplayActionManager:MazeEnemyEscape(gridID, roleExp, martialExp)
    local gridData = MazeDataManager:GetInstance():GetGridData(gridID)
    local enemyName = '敌人'
    -- 获取敌人名称
    local cardData = MazeDataManager:GetInstance():GetCurAreaMazeCardData(gridData.uiRow, gridData.uiColumn, true)
    if cardData == nil then 
        DisplayActionEnd()
        return
    end
    local hasRoleModel = false
    if cardData.CardItem ~= nil and cardData.CardItem.NameID ~= nil then 
        hasRoleModel = true
        enemyName = GetLanguageByID(cardData.CardItem.NameID)
    elseif dnull(cardData.RoleID) then
        hasRoleModel = true
        enemyName = RoleDataManager:GetInstance():GetRoleNameByTypeID(cardData.RoleID)
    end
    local toastContent = enemyName .. '逃走了!' .. '获得<color=red>' .. (roleExp or 0) .. '</color>角色经验和<color=red>' .. (martialExp or 0) .. '</color>武学经验'
    SystemUICall:GetInstance():Toast(toastContent)

    -- 播放逃跑动画
    local mazeUI = GetUIWindow('MazeUI')
    if hasRoleModel and mazeUI ~= nil and IsWindowOpen('MazeUI') then 
        mazeUI:PlayRoleEscapeAnim(gridData.uiRow, gridData.uiColumn, true)
    else
        DisplayActionEnd()
    end
end

function DisplayActionManager:HasActionExceptRecoverInteractState()
    local actionList = self:GetActionList() or {}
    for _, action in ipairs(actionList) do 
        if action.actionType ~= DisplayActionType.RECOVER_INTERACT_STATE then 
            return true
        end
    end
    return false
end

function DisplayActionManager:RecoverInteractState()
    local actionList = self:GetActionList()
    -- 判断当前队列是不是有其他 action, 没有的时候才能恢复交互界面
    if self:HasActionExceptRecoverInteractState() then 
        -- 有其他 action, 需要等其他 action 执行完毕之后再恢复交互界面
        self:AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
    else
        RoleDataManager:GetInstance():RecoverInteractState()
    end
    DisplayActionEnd()
end

function DisplayActionManager:ActionChangeScript(iTargetScriptID)
    if not iTargetScriptID then
        DisplayActionEnd()
        return
    end
    PlotDataManager:GetInstance():ChangeCueScript_Out(tonumber(iTargetScriptID))
    DisplayActionEnd()
end

function DisplayActionManager:ActionNetMsgToast(retStream)
    DisplayNetMsgToast(retStream)
    DisplayActionEnd()
end

function DisplayActionManager:ActionSetTempBackground(bIsBigMap, uiMapTypeID, uiMazeTypeID)
    if type(bIsBigMap) == "string" then
        bIsBigMap = (bIsBigMap == "True")
    end
    if type(uiMapTypeID) == "string" then
        uiMapTypeID = tonumber(uiMapTypeID)
    end
    if type(uiMazeTypeID) == "string" then
        uiMazeTypeID = tonumber(uiMazeTypeID)
    end

    BlurBackgroundManager:GetInstance():AddTempBackground(bIsBigMap, uiMapTypeID, uiMazeTypeID)
    DisplayActionEnd()
end

function DisplayActionManager:ActionRemoveTempBackground()
    BlurBackgroundManager:GetInstance():RemoveTempBackground()
    DisplayActionEnd()
end

function DisplayActionManager:ActionPlayAudio(audioID, audioTypeStr)
    audioID = tonumber(audioID)
    audioType = AudioType_Revert[audioTypeStr]
    if audioID == nil or audioType == nil then 
        DisplayActionEnd()
        return
    end
    PlayAudioByType(audioID, audioType)
    DisplayActionEnd()
end

function DisplayActionManager:ActionHighTowerEmbattle()
    HighTowerDataManager:GetInstance():EnterRegimentEmbattle()
    DisplayActionEnd()
end

function DisplayActionManager:ActionHighTowerStageReward(eType, iStage)
    if type(eType) == "string" then
        eType = tonumber(eType)
    end
    if type(iStage) == "string" then
        iStage = tonumber(iStage)
    end

    local info = {}
    info.eType = eType
    info.iStage = iStage

    OpenWindowImmediately("HighTowerRewardUI", info)
end


function DisplayActionManager:MapRoleEnemyEscape(mapID, roleID)
    -- 播放逃跑动画
    local CityUI = GetUIWindow('CityUI')
    if CityUI ~= nil and IsWindowOpen('CityUI') then 
        CityUI:PlayRoleEscapeAnim(mapID, roleID)
    else
        DisplayActionEnd()
    end
end

function DisplayActionManager:SubmitItem(info)
    OpenWindowImmediately("ShowBackpackUI", info)
end

function DisplayActionManager:OpenRandomRoll(retStream)
    if not retStream then 
        DisplayActionEnd()
    else
        retStream['bNeedDisplayEnd'] = true
        OpenWindowImmediately("RandomRollUI", retStream)
    end
end

function DisplayActionManager:OpenHuaShanRank()
    OpenWindowImmediately("HuaShanRankUI")
    DisplayActionEnd()
end

function DisplayActionManager:UpdateMapEffect(info)
    if info.globalEffectList then
        MapEffectManager:GetInstance():UpdateGlobalMapEffect(info.globalEffectList)
    elseif info.addMapEffect then
        MapEffectManager:GetInstance():AddMapEffect(info.addMapEffect)
    elseif info.removeMapEffect then
        MapEffectManager:GetInstance():RemoveMapEffect(info.removeMapEffect)
    end

    DisplayActionEnd()
end

function DisplayActionManager:PlayMapRoleAnim(mapID, roleBaseID, animType)
    mapID = DecodeNumber(mapID)
    roleBaseID = DecodeNumber(roleBaseID)
    animType = SpineAnimType_Revert[animType]
    local animName = GetAnimNameByEnum(animType)
    local cityUI = GetUIWindow('CityUI')
    if cityUI ~= nil and IsWindowOpen('CityUI') then 
        local animTime = cityUI:PlayBuildingRoleAnim(mapID, roleBaseID, animName)
        if animTime == 0 then 
            DisplayActionEnd()
        else
            globalTimer:AddTimer(animTime, DisplayActionEnd, 1)
        end
    else
        DisplayActionEnd()
    end 
end

function DisplayActionManager:Remove_GiveGiftUI()
    local giveGiftDialogUI = WindowsManager:GetInstance():GetUIWindow('GiveGiftDialogUI')
    if giveGiftDialogUI ~= nil then 
		giveGiftDialogUI._gameObject:SetActive(false)
    end
    
    local selectUI = WindowsManager:GetInstance():GetUIWindow('SelectUI')
    if selectUI ~= nil then 
		selectUI._gameObject:SetActive(false)
    end

    local tipsPopUI = WindowsManager:GetInstance():GetUIWindow('TipsPopUI')
    if tipsPopUI ~= nil then 
		tipsPopUI._gameObject:SetActive(false)
    end

    DisplayActionEnd()
end

function DisplayActionManager:Recove_GiveGiftUI()
    local giveGiftDialogUI = WindowsManager:GetInstance():GetUIWindow('GiveGiftDialogUI')
    if giveGiftDialogUI ~= nil then 
		giveGiftDialogUI._gameObject:SetActive(true)
        giveGiftDialogUI:UpdateBackpack()
    end
    
    local selectUI = WindowsManager:GetInstance():GetUIWindow('SelectUI')
    if selectUI ~= nil then 
		selectUI._gameObject:SetActive(true)
    end

    local tipsPopUI = WindowsManager:GetInstance():GetUIWindow('TipsPopUI')
    if tipsPopUI ~= nil then 
		tipsPopUI._gameObject:SetActive(true)
    end

   DisplayActionEnd()
end

function DisplayActionManager:ExecutePlot(taskID, plotID, plotData)
    PlotDataManager:GetInstance():ExecutePlot(taskID, plotID, plotData)
end


function DisplayActionManager:Animation_OpenEye()
    self.objOpenEye = LoadPrefabFromPool("Effect/UI_eff/ef_open the eyes/Anim_OpenEye",UI_UILayer,true)
    self.objOpenEye.transform.localScale = DRCSRef.Vec3(80,80,1)
    local endFunc = function()
        ReturnObjectToPool(self.objOpenEye)
        DisplayActionEnd()
    end
    globalTimer:AddTimer(3000, endFunc, 1)
end

function DisplayActionManager:ActionCloseForgeMake()
    RemoveWindowImmediately("ForgeUI")
    DisplayActionEnd()
end


function DisplayActionManager:ActionOpenRoleChallengeUI()
    OpenWindowImmediately("ChooseRoleUI", {type = ShooseRoleUIType.SRUIT_ChooseRoleChallenge})
    DisplayActionEnd()
end

-- 打开收集活动
function DisplayActionManager:OpenCollectActivity()
    OpenWindowImmediately("CollectActivityUI")
    DisplayActionEnd()
end

-- 打开多倍奖励
function DisplayActionManager:OpenMultDropActivity()
    OpenWindowImmediately("MultDropActivityUI")
    DisplayActionEnd()
end

-- NPC 大地图城市移动
function DisplayActionManager:NpcCityMove(roleID, srcCityID, dstCityID, dstMapID)
    DisplayActionEnd()
end
-- 废弃
function DisplayActionManager:ActionOpenClickDiscountUI()
end

-- 打开限时商店
-- 废弃
function DisplayActionManager:DiaologueLimitShop()
    -- local str = LimitShopManager:GetInstance():GetDialogue()
    -- if str ~= nil  then  
    --     PlotDataManager:GetInstance():DisplayCustomStrDialogue(1000114002, str)
    --     LimitShopManager:GetInstance():SetDialogueState(true)
    --     return 
    -- else 
    --     DisplayActionEnd()
    -- end
end
-- 打开限时商店
function DisplayActionManager:OpenLimitShop()
    -- 没有获得旺旺币的时候要弹出一条toast 
    if LimitShopManager:GetInstance():GetLeftTimeStr_Shop(true) then 
        if not LimitShopManager:GetInstance():GetIfShareFinished() then 
            SystemUICall:GetInstance():Toast("成功获得旺旺币1个")
            SendLimitShopOpr(EN_LIMIT_SHOP_RECHARGE,0,1,1)
        end
    end 


    -- 在状态中就打开商店且对话 没有就提示活动时间到期
    if LimitShopManager:GetInstance():GetLeftTimeStr_Shop() then 

        -- 获取对话并显示，且限制只在本次刷新的时候显示一次对话 
        -- 对话依照是否猜完色子区分
        local str = LimitShopManager:GetInstance():GetDialogue()
        if str ~= nil  then  
            PlotDataManager:GetInstance():DisplayCustomStrDialogue(1000114002, str)
            LimitShopManager:GetInstance():SetDialogueState(true)
        end
        LimitShopManager:GetInstance():SetLimitActionEnd(false)
        local window  = OpenWindowImmediately('LimitShopUI')
        SendOpenLimitShopUI()
        if window then 
            if LimitShopManager:GetInstance():GetNowGuessCoinGameLevel() <= 3 then 
                OpenWindowImmediately('GuessCoinUI')
            end
        end
    else         
        LimitShopManager:GetInstance():SetLimitActionEnd(true)
        PlotDataManager:GetInstance():DisplayCustomStrDialogue(1000114002, '大侠，本次的限时礼包活动时间已经过期，望大侠下次看到奇遇时第一时间与我相遇')
    end
end

-- 播放语音
function DisplayActionManager:PlayVocal(resourceBgmID)
    PlayVocal(toint(resourceBgmID))
    DisplayActionEnd()
end