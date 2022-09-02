LogicMain = class("Logic")

LogicMain._instance = nil
reloadModule("Logic/LogicMain_init")
require "KeyboardManager"
function IsBattleOpen()
    return LogicMain._instance and LogicMain:GetInstance():IsRun()
end

function IsBattleSceneReady()
    return LogicMain._instance and LogicMain:GetInstance().battleSceneLoadComplete
end

function LogicMain:ctor()
    self.kPathFinder = PathFinder:GetInstance()
    self.kUnitMgr = UnitMgr:GetInstance()
    self.kEffectMgr = EffectMgr:GetInstance()
    self.kBattleTreasureBox = BattleTreasureBoxMgr:GetInstance()
    self.handle = {}
    self.akStatisticalDamageData = {}
    self.iStatisticalRound = 1
    self.count = 0
    SetSpeed(SPEED_TYPE.NORMAL,1)   -- 初始战斗速度
end

function LogicMain:GetInstance()
    if LogicMain._instance == nil then
        LogicMain._instance = LogicMain.new()
        LogicMain._instance:BeforeInit()
    end
    return LogicMain._instance
end

function LogicMain:ResetData()
    self.isUnLockAuto = nil        -- 控制是否可以点击自动按钮
    self.iBattleTypeID = nil       -- 当前战斗typeID
    self.keepBattleCount = nil     -- 战斗锁，防止退出战斗
    self.iBattleType = nil         -- 战斗类型
    self.isOpen = nil              -- 是否正在进行战斗
    self._saveUnitInfo = {}        -- 缓存的待创建角色
    self._canMoveGridPos = nil
    self.bCanShowSkillGrid = nil
    self.bReplayNeedGiveUP = false
    self.battleSceneLoadComplete = false -- 战斗场景是否加载完成
    globalDataPool:setData("BattleTreasureBoxes",nil,true) -- 清理宝箱信息
    SetSpeed(SPEED_TYPE.NORMAL,1)   -- 初始战斗速度
    self._battleData = nil
    -- UI节点 --
    self.objActorNode = nil
    self.objBattleGrid = nil
    self.ObjTreasureBoxNode = nil
    self.zhiShiObject = nil
    ChangeSceneColor_init = {}
    MoveCameraPosition_init = nil
    self.comBatteGridHelper = nil
    self._OpenRecord = true

    self._ccount = 0 -- 客户端上行计数
    self._scount = 0 -- 服务端下行计数
end

function LogicMain:BeforeInit()
    self.handle.BattleUIUnitEndTurn = function(bUseSkill)
        self:BattleUI_UnitEndTurn(bUseSkill)
    end
    self.handle.ChangeAutoBattle = function()
        self:ChangeAutoBattle()
    end
    self._BattleTimer = Timer.new()
    LuaEventDispatcher:addEventListener("BattleUI_UnitEndTurn",self.handle.BattleUIUnitEndTurn)
    LuaEventDispatcher:addEventListener("BATTLE_CLICK_BATTLE_AUTO",self.handle.ChangeAutoBattle)
    self._OpenRecord = true

    self._ccount = 0 -- 客户端上行计数
    self._scount = 0 -- 服务端下行计数
    self.mouseNormalTexture = LoadPrefab("Cursor/64_mouse_normal",DRCSRef_Type.Texture)
    if self.mouseNormalTexture == nil then
        derror("path not found 64_mouse_normal")
    end
    self.mouseClickTexture = LoadPrefab("Cursor/64_mouse_click",DRCSRef_Type.Texture)
    if self.mouseClickTexture == nil then
        derror("path not found 64_mouse_click")
    end
end
local l_GetButtonUp= CS.UnityEngine.Input.GetButtonUp
local l_GetButtonDown = CS.UnityEngine.Input.GetButtonDown
local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
local l_GetKey = CS.UnityEngine.Input.GetKey
local l_GetKeyUp = CS.UnityEngine.Input.GetKeyUp
local l_GetMouseScrollWheel = CS.UnityEngine.Input.GetAxis
local l_AutoKeys = {"left shift", "right shift"}
local l_MouseScrollWheelKey = "Mouse ScrollWheel"
local l_SkillKeys = {"1","2","3","4","5","6","7"}
local l_DialogMgr = DialogRecordDataManager:GetInstance()
local l_NeedESCWindow={"WindowBarUI"}
local l_CollectionUIs={"CollectionComicUI","CollectionCGUI","ClanUI","CollectionMartialUI","CollectionHeirloomUI"}
local l_QuoteKey="`"
local l_ResetPosKey = "w"
local l_SkillPageFuncType = {
    ["pre"]=FuncType.PreSkillPage,
    ["next"]=FuncType.NextSkillPage,
}
local l_SkillSwitchKeys ={
    ["pre"]="q",
    ["next"]="e",
}
local l_SetCursor = CS.GameApp.CursorHelper.SetMouseCursor
local waitTime = 10
function LogicMain:UpdateMouse()
    if l_GetButtonDown("MouseLeftButton") or l_GetButtonDown("MouseRightButton") then
        l_SetCursor(self.mouseClickTexture,DRCSRef.Vec2Zero)
    end
    if l_GetButtonUp("MouseLeftButton") or l_GetButtonUp("MouseRightButton") then
        l_SetCursor(self.mouseNormalTexture,DRCSRef.Vec2Zero)
    end
end

function LogicMain:Update(deltaTime)
    self:UpdateMouse()

    if self._BattleTimer then
        self._BattleTimer:Update(deltaTime)
    end
    
    self:KeyBoardUpdate()
    
end

-- function LogicMain:UpdateMouse()
--     if CS.UnityEngine.Input:GetMouseButtonDown(0) then
--         l_SetCursor(self.mouseClickTexture,DRCSRef.Vec2Zero)
--     end
--     if CS.UnityEngine.Input:GetMouseButtonUp(0) then
--         l_SetCursor(self.mouseNormalTexture,DRCSRef.Vec2Zero)
--     end
-- end

function LogicMain:AddTimer(delay,func,times,infoTable)
    if self._BattleTimer then
        return self._BattleTimer:AddTimer(delay,func,times,infoTable)
    end
end

function LogicMain:ClearTimer()
    if self._BattleTimer then
        self._BattleTimer:RemoveAllTimer()
    end
end

function LogicMain:ClearUI()
    TimeLineHelper:GetInstance():Reset()
    AnimationMgr:GetInstance():ClearAll()
    if self.comBattleClickScence then
        self.comBattleClickScence:ClearLuaFunction()
    end
    ClearSpeed()
    ClearSkillObjectToPool()
    self:ClearTimer()
    DRCSRef.DOTween.Kill("BATTLE_TWEEN_ID")
end

function LogicMain:Clear()
    BattleSceneAnimation:GetInstance():Clear()
    self:SetStatisticalDamageExtra()
    self:ClearUI()
    self.kUnitMgr:Clear()
    self.kPathFinder:Clear()
    self.kEffectMgr:Clear()
    self.kBattleTreasureBox:Clear()
    self:ResetData()
    ClearBattleMsg()
    self:ClearAreanInfo()
    self:ExitBattleMsg()
    DRCSRef.DestroyImmediate(self.battleSceneBG)
    DRCSRef.DestroyImmediate(self.battlefile)
    CallCollectGC()
    self.isBattleProcess = false
end

function LogicMain:IsBoss(iTypeID)
    return self.bossMap and self.bossMap[iTypeID]
end

function LogicMain:_InitBoss()
    self.bossMap = {}
    self.bosslist = {}
    local battleData = self:GetBattleTypeData()
    if battleData and battleData.BossList then
        self.bosslist = battleData.BossList
        for i=1,#self.bosslist do
            self.bossMap[self.bosslist[i]] = true
        end
    end
end

function LogicMain:_InitBattleBG(battleData)
    local layout = battleData and battleData['Layout'] or BATTLESCENE_BG
    if self:IsArenaBattle() then
        layout = "btbg_jiequleitai"
    end
    self.battleSceneBG = LoadEffectAndInit("battlebg/" .. layout .. "/" .. layout)
    if self.battleSceneBG == nil then
        self.battleSceneBG = LoadEffectAndInit(BATTLESCENE_BG_PATH)
    end
    self.battleSceneBG.transform.localPosition = self.battleSceneBG.transform.localPosition + DRCSRef.Vec3(0,0,0.2)
    if self.battleSceneBG then
        self.battleSceneBG:SetActive(true)
    end
    --- 分辨率处理
    local screen_radio = DRCSRef.Screen.width/DRCSRef.Screen.height -- PC上动态计算
    local factor = 1.3
    -- if screen_radio > design_radio then
        local scale = factor--screen_radio/design_radio * factor
        self.battleSceneBG.transform.localScale = DRCSRef.Vec3(scale,scale,scale)
    -- end
end

function LogicMain:_InitObject()
    local battleData = self:GetBattleTypeData()
    self.objActorNode = DRCSRef.FindGameObj("Battle_ActorNode")
    self.objBattleGrid = DRCSRef.FindGameObj("BattleGrid")
    self.ObjTreasureBoxNode = DRCSRef.FindGameObj("Battle_TreasureBoxNode")
    self:_InitBattleBG(battleData)
    self:_InitGrid()
    self.battleSceneLoadComplete = true
end

function LogicMain:_InitMusic()
    local battleData = self:GetBattleTypeData()
    local bgmID = BGMID_BATTLE
    if battleData and battleData.BackgroundMusic and battleData.BackgroundMusic ~= 0 then
        bgmID = battleData.BackgroundMusic
    end
    StopDialogueSound()
    PlayMusic(bgmID)
    G_Last_city_bgmID = nil
end

function LogicMain:InitData()
    self:_InitBoss()
    self:_InitObject()
    self:_InitMusic()
    self:ClearAwardInfo()
    self:SetRun(true)
    self.kEffectMgr:InitEffect()
    self.kBattleTreasureBox:Init(self.ObjTreasureBoxNode)
    BattleDataManager:GetInstance():Init()
    self.bAutoBattle = GetConfig("AutoBattle") or false -- 是否自动战斗
end

--开始游戏
function LogicMain:StartGame(retStream)
    -- 直接播放过场动画
    --self.akStatisticalDamageData = {}
    self:ClearBattleEndInfo() -- 清掉战斗记录
    self.iStatisticalRound = 1
    self.bGenStatisticaDamageName = false;
    BattleDataManager:GetInstance():SetBattleEndFlag(false)

    TimeLineHelper:GetInstance():Reset()
    TimeLineHelper:GetInstance():SetCanUpdate(true)
    local startTime = 0
    AddTrackFunc(startTime,"EnterBattletTansitions")
    TimeLineHelper:GetInstance():AddExMaxTime(300)
    AddTrackLambda(startTime,function()
        self:StartGameInit(retStream)
        AddTrackFunc(0,"OpenWindowImmediately","BattleUI")
    end)
end

function LogicMain:StartGameInit(retStream)
    TimeLineHelper:GetInstance():Reset()
    TimeLineHelper:GetInstance():SetCanUpdate(true)
    self:SetBattleTypeID(retStream.iBattleTypeID)
    self:SetBattleType(retStream.iBattleType)
    self.sFriendName = retStream.sFriendName
    self.sEnemyName = retStream.sEnemyName
    self.battlefile = LoadPrefabAndInit("Battle/BattleField")
    self.objActorNode  = DRCSRef.FindGameObj("Battle_ActorNode")
    self:InitData()
    local startTime = 0
    startTime = startTime + BossEnterScene(self.bosslist) - 500
    AddTrackFunc(0,"LeaveBattletTansitions")
    -- AddTrackFunc(startTime/2,"LeaveBattletTansitions")
        -- AnimationMgr:GetInstance():CreateAndRunAnim(kBattleUI.BossEnterScene,kBattleUI,self.bosslist)
    for i =0,retStream['iNum']-1 do
        local kUnitData = retStream['akUnits'][i]
        local kUnit = self.kUnitMgr:CreatUnit(self.objActorNode,kUnitData,startTime)
        local kOptUnitData = retStream['akUnitsTime'][i]
        if kUnit then
            if kOptUnitData then
                kUnit:SetMoveTime(kOptUnitData['fOptNeedTime'], kOptUnitData['fMoveTime'])
            end
        end
    end
    for i=0,retStream['iAssistNum']-1 do
        local kUnitAssistData = retStream['akAssistUnits'][i]
        self.kUnitMgr:CreateAssistUint(self.objActorNode,kUnitAssistData,i+1)
    end
    AddTrackFunc(startTime,"ShowBattleUI",true)
    AddTrackLambda(startTime,function()
        if GetConfig("BattleSpeed") then
            SetSpeed(SPEED_TYPE.BATTLE,1)
        end
    end)
    -- 增加一点延时
    TimeLineHelper:GetInstance():AddExMaxTime(500)
    self:SendAutoCmd(0)
    self.battlefile.transform.localScale = DRCSRef.Vec3(SCALE_BATTLE_FIELD,SCALE_BATTLE_FIELD,1.0)
    self.battlefile.transform.localPosition = POSITION_BATTLE_FIELD
end

function LogicMain:SendAutoCmd(unitIndex)
    self._ccount = self._ccount + 1
    unitIndex = unitIndex or 0
    local data = EncodeSendSeGC_Click_Battle_Auto(unitIndex)
    local iSize = data:GetCurPos()
    NetGameCmdSend(SGC_CLICK_BATTLE_AUTO,iSize,data)
end
function LogicMain:RecordReciveServerInfo()
    self._scount = self._scount + 1
end
function LogicMain:GameEnd(retStream)
    if IsWindowOpen("ArenaBattleEndUI") then
        return
    end
    if retStream then
        self.retStream = retStream
    else
        retStream = self.retStream
    end
    BattleDataManager:GetInstance():SetBattleEndFlag(true)


    -- 统计获胜方
    self.statisticalDataVictoryCamp = 1
    local eFlag_statisticalData = retStream and retStream.akEndData.eFlag;
    if retStream and HasValue(eFlag_statisticalData, SE_DEFEAT) then
        self.statisticalDataVictoryCamp = 2
    end
    -- 存储战斗信息
    local kBattleUI = GetUIWindow("BattleUI")
    if kBattleUI and not self._Replaying then
        -- ProcessRemainingBattleLog()
        self:SetBattleLog(kBattleUI.battleLog)
    end
    self._Replaying = false

    if self:IsArenaBattle() then
        if ARENA_PLAYBACK_DATA and ARENA_PLAYBACK_DATA.defPlyWinner == ARENA_PLAYBACK_DATA.kPly1Data.defPlayerID then
            self.statisticalDataVictoryCamp = 1
        else
            self.statisticalDataVictoryCamp = 2
        end
        OpenWindowImmediately("ArenaBattleEndUI")
    elseif self:IsScriptArenaBattle() then
        OpenWindowImmediately("ArenaBattleEndUI", retStream)
    else
        local eFlag = retStream and retStream.akEndData.eFlag;
        if retStream and HasValue(eFlag, SE_HIDEGAMEENDUI) then
            local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
            local iSize = data:GetCurPos()
            NetGameCmdSend(SGC_CLICK_BATTLE_GIVEUP,iSize,data)
            self:ReturnToTown(true)
        else
            OpenWindowImmediately("BattleGameEndUI", retStream)
        end
    end

    RemoveWindowImmediately("BattleUI")
    self:Clear()
end

function LogicMain:DisplayeLockAutoBattle(retStream)
    local Lockauto = retStream.bCloseAuto
    if Lockauto == 0 then
        self:SetUnLockAuto(false)
        self:SetAutoBattle(false)
    else
        self:SetUnLockAuto(true)
    end
    local kBattleUI = GetUIWindow("BattleUI")
    if kBattleUI then
        kBattleUI:setAutoButtonShow(Lockauto ~= 0)
    end
end

function LogicMain:SetObserveData(retStream)
    local unit = self.kUnitMgr:GetUnit(retStream.akUnit.uiUnitIndex)
    unit:SetObserveData(retStream.akUnit)
end

function LogicMain:BattleUI_UnitEndTurn(bUseSkill)
    local kCurOptUnit = self.kUnitMgr:GetCurOptUnit()
    if kCurOptUnit then
        TimeLineHelper:GetInstance():Reset()
        kCurOptUnit:HideChooseEffect()
        local iGridX,iGridY = kCurOptUnit:GetPos()
        local iUnitIndex = kCurOptUnit:GetUnitIndex()
        local iSkillIndex = bUseSkill and kCurOptUnit:GetCurChooseSkillIndex() or 0
        local iSkillPosX,iSkillPosY = kCurOptUnit:GetSkillCastPos()
        local iSelectX,iSelectY = kCurOptUnit:GetUnitSelectGrid()
        if not iSelectX or not iSelectY then
            iSelectX = iSkillPosX
            iSelectY = iSkillPosY
        end
        -- local str = string.format("move to: %d %d use skill: %d castPose %d %d  selectPos %d %d",iGridX,iGridY,iSkillIndex,iSkillPosX,iSkillPosY,iSelectX,iSelectY)
        -- dprint(str)
        --发送操作单位协议 注意 c++格子是从0开始 lua是从1
        local clickCityData = EncodeSendSeGC_Click_Battle_OperateUnit(iUnitIndex,iGridX -1,iGridY -1,iSkillIndex,iSkillPosX -1,iSkillPosY -1,iSelectX-1,iSelectY-1)
        local iSize = clickCityData:GetCurPos()
        NetGameCmdSend(SGC_CLICK_BATTLE_OPERATE_UNIT,iSize,clickCityData)
    else
        dprint("CurOptUnit is nil")
    end
    self.kUnitMgr:OptOver()
end

-- iCurRound 服务器上以0开始，显示上以１开始　所以默认＋１
function LogicMain:UpdateOptUnit(retStream)
    TimeLineHelper:GetInstance():Reset()
    TimeLineHelper:GetInstance():SetCanUpdate(true)
    local uiUnitIndex = retStream['uiUnitIndex']
    local iCurRound = retStream['iRound']
    local iFlag = retStream['iFlag']
    local kCurUnit = self.kUnitMgr:GetUnit(uiUnitIndex)
    if not kCurUnit then
        kCurUnit = LogicMain:GetInstance():CreateOneUnit(uiUnitIndex,0)
        if kCurUnit == nil then
            self:SendAutoCmd(uiUnitIndex)
            return true
        end
    end
    for i =0,retStream['iNum']-1 do
        local kOptUnitData = retStream['akUnitsTime'][i]
        local kUnit = self.kUnitMgr:GetUnit(kOptUnitData['uiUnitIndex'])
        if kUnit then
            if kOptUnitData then
                kUnit:SetMoveTime(kOptUnitData['fOptNeedTime'], kOptUnitData['fMoveTime'])
            end
        end
    end
    local kUnitMartial = retStream['akUnitsMartial']
    if kUnitMartial then
        kCurUnit:SetMartial(kUnitMartial)
    end
    self.kUnitMgr:SetCurOperationalUnit(uiUnitIndex)
    self.kUnitMgr:ShowActionNode(uiUnitIndex,iFlag)
end

function LogicMain:ChangeAutoBattle()
    self:SetAutoBattle(not self:IsAutoBattle())
end

function LogicMain:AutoBattle()
    local curUnit = self.kUnitMgr:GetCurOptUnit()
    if curUnit then
        curUnit:HideAllGridEffect()
    end
    self.kUnitMgr:AutoBattle()
end
function LogicMain:ProcessBattleLog(retStream)
    for i = 0,retStream["iNum"] - 1 do
        local kBattleLogData = retStream['akBattleLog'][i]
        self:TransBattleLog(kBattleLogData)
        self:AddBattleBuffLog(kBattleLogData)
    end
end

local GetUnitLogName = function(kUnit)
    if kUnit then
        local kUnitName = "error"
        if kUnit:IsEnemy() then
            kUnitName = string.format( "<color=#C53926>%s</color>",kUnit:GetName())
        else
            kUnitName = string.format( "<color=#6CD458>%s</color>",kUnit:GetName())
        end
        if DEBUG_MODE then
            kUnitName = kUnitName .. ":" .. kUnit:GetUnitIndex()
        end
        return kUnitName
    end
    return "error"
end
function LogicMain:TransBattleLog_TriggerBuff(kBattleLogData,sLogs,sAttackUnitName)
    if kBattleLogData.iSkillTypeID == 0 and kBattleLogData.iBuffTypeID ~= 0 and kBattleLogData.iOwnerUnitIndex ~= 0 then
        if kBattleLogData.iBuffDamage ~= 0 then 
            local tbBuffData = TableDataManager:GetInstance():GetTableData("Buff", kBattleLogData.iBuffTypeID)
            if tbBuffData then 
                sLogs[#sLogs+1] = {string.format("%s的%s触发，受到%.0f点伤害",sAttackUnitName,GetLanguageByID(tbBuffData.NameID),kBattleLogData.iBuffDamage),TBoolean.BOOL_YES}
            end
        elseif kBattleLogData.iMutilTag == MutilAnqiTag.MT_SHOWINLOG then
            local tbBuffData = TableDataManager:GetInstance():GetTableData("Buff", kBattleLogData.iBuffTypeID) or TableDataManager:GetInstance():GetTableData("Gift", kBattleLogData.iBuffTypeID)
            sLogs[#sLogs+1] = {string.format("%s的%s触发了",sAttackUnitName,GetLanguageByID(tbBuffData.NameID)),TBoolean.BOOL_YES}
        end
    end
end

function LogicMain:TransBattleLog_UnitDeathLog(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.bDeath and SeBattle_HurtInfo.bDeath > 0 then
        local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
        if attackerUnit then
            attackerUnit:AddDeathLog()
        end
    end
end

function LogicMain:processMutilAnqiLog(kBattleLogData)
    if kBattleLogData.iMutilTag == MutilAnqiTag.MT_NULL or kBattleLogData.iMutilTag == MutilAnqiTag.MT_END or kBattleLogData.iMutilTag == MutilAnqiTag.MT_CHILD then 
        if kBattleLogData.iMutilTag == MutilAnqiTag.MT_START then 
            self.cacheHurtInfo = {}
            return true,kBattleLogData
        end
        if self.cacheHurtInfo == nil then 
            return false,kBattleLogData
        end
        table.insert(self.cacheHurtInfo,kBattleLogData)
        if kBattleLogData.iMutilTag == MutilAnqiTag.MT_END then
            local newkBattleLogData = clone(kBattleLogData)
            -- 合并hurtinfo
            local demageInfoMap = {}
            local constMapName = {'iFinalMPDamageValue','iReboundDamageValue','iFinalDamageValue'}
            local sortIndex = 0
            for index,SeBattle_HurtInfo in ipairs(self.cacheHurtInfo) do
                for i = 0,SeBattle_HurtInfo["iSkillDamageData"] - 1 do
                    local kData = SeBattle_HurtInfo["akSkillDamageData"][i]
                    local iTargetUnitIndex = kData['iTargetUnitIndex']
                    if demageInfoMap[iTargetUnitIndex] == nil then
                        sortIndex = sortIndex + 1
                        demageInfoMap[iTargetUnitIndex] = clone(kData)
                        demageInfoMap[iTargetUnitIndex]._sortIndex = sortIndex
                    else
                        for k,v in pairs(constMapName) do
                            demageInfoMap[iTargetUnitIndex][v] = demageInfoMap[iTargetUnitIndex][v] + kData[v]
                        end
                        demageInfoMap[iTargetUnitIndex]['eExtraFlag'] = demageInfoMap[iTargetUnitIndex]['eExtraFlag'] | kData['eExtraFlag']
                    end
                end
            end
            local demageVector = {}
            local iCount = 0
            for k,v in pairs(demageInfoMap) do
                demageVector[iCount + 1] = v
                iCount = iCount + 1
            end
            table.sort(demageVector,function(a,b)
                return a._sortIndex<b._sortIndex
            end)
            for k,v in ipairs(demageVector) do
                demageVector[k-1] = v
            end
            demageVector[iCount] = nil
            newkBattleLogData["iSkillDamageData"] = iCount
            newkBattleLogData["akSkillDamageData"] = demageVector
            return false,newkBattleLogData
        else
            return true,kBattleLogData
        end
    end
    return false,kBattleLogData
end

function LogicMain:NotRecordLog(kBattleLogData)
    if kBattleLogData == nil then return true end
    if SWITCH_LOG_OTHER then
        if kBattleLogData.iMutilTag == MutilAnqiTag.MT_SHOWINLOG then
            return false
        end
    end
    if kBattleLogData.eSkillEventType == BSET_Null then 
        if kBattleLogData.eEvent == Event_JiTuiPengZhuang then 
            return false
        end
        return true
    end
    return false
end

function LogicMain:TransBattleLog_TriggerSkill(kBattleLogData,sLogs,sAttackUnitName,kAttackUnit)
    local bSkip, kBattleLogData = self:processMutilAnqiLog(kBattleLogData)
    if bSkip then
        return
    end
    local bIsBuff = false
    local skillData = TableDataManager:GetInstance():GetTableData("Skill", kBattleLogData['iSkillTypeID'])
    if skillData == null then
        if kBattleLogData.iBuffDamage and kBattleLogData["iSkillDamageData"] == 0 then
            return
        end
        bIsBuff = true
        skillData = TableDataManager:GetInstance():GetTableData("Buff", kBattleLogData['iBuffTypeID']) or TableDataManager:GetInstance():GetTableData("Gift", kBattleLogData['iBuffTypeID'])
    else
        if kBattleLogData.eSkillEventType == BSET_Null and kBattleLogData["iSkillDamageData"] == 0 then
            return
        end
    end
    if skillData == null or self:NotRecordLog(kBattleLogData) then return end
    local skillName = GetLanguageByID(skillData.NameID)
    -- local hasProssBuffFlag = {}
    if not bIsBuff and kBattleLogData["iSkillDamageData"] == 0 then
        sLogs[#sLogs + 1] = {string.format( "%s施放了%s", sAttackUnitName, skillName),TBoolean.BOOL_YES}
    end
    for i = 0,kBattleLogData["iSkillDamageData"] - 1 do
        local kLogDatas = {}
        local kData = kBattleLogData["akSkillDamageData"][i]
        local iTargetUnitIndex = kData['iTargetUnitIndex']
        local kTargetUnit = self.kUnitMgr:GetUnit(iTargetUnitIndex)
        local kTargetName = GetUnitLogName(kTargetUnit)
        local hurtFlag = kData["eExtraFlag"]
        kLogDatas[#kLogDatas + 1] = sAttackUnitName
        if kTargetUnit == nil then
            kLogDatas[#kLogDatas + 1] = GetLanguageByID(200002) .. skillName--"释放了"..GetLanguageByID(skillData.NameID)
        else
            if kTargetUnit == kAttackUnit then
                kLogDatas[#kLogDatas + 1] = string.format("%s%s%s%s",GetLanguageByID(200001),GetLanguageByID(200012),GetLanguageByID(200002),GetLanguageByID(skillData.NameID))
            else
                kLogDatas[#kLogDatas + 1] = string.format("%s%s%s%s",GetLanguageByID(200001),kTargetName,GetLanguageByID(200002),GetLanguageByID(skillData.NameID))
            end
        end
        if kData['iFinalHPAddValue'] > 0 then
            kLogDatas[#kLogDatas + 1] = string.format(GetLanguageByID(200004),kData['iFinalHPAddValue'])
        end


    
        if HasFlag(hurtFlag,BDEF_CEJI) then
            kLogDatas[#kLogDatas + 1] = GetLanguageByID(200006)--"(侧击)"
        elseif HasFlag(hurtFlag,BDEF_BEIJI) then
            kLogDatas[#kLogDatas + 1] = GetLanguageByID(200005)--"(背击)"
        end
        if HasFlag(hurtFlag,BDEF_CRIT) then
            kLogDatas[#kLogDatas + 1] = "(暴击)"
        end
        if HasFlag(hurtFlag,BDEF_MISS) then
            kLogDatas[#kLogDatas + 1] = string.format(GetLanguageByID(200009),kTargetName)
        end
        if kData['iDuoDuanNum'] > 1 then 
            local hasDouhao = true
            if HasFlag(hurtFlag,BDEF_MISS) then
                -- kLogDatas[#kLogDatas + 1] = "部分伤害，最终"
                hasDouhao = false
            else
                if HasFlag(hurtFlag,BDEF_POZHAO) then
                    kLogDatas[#kLogDatas + 1] = "，却被对方看破招式，仅"
                    hasDouhao = false
                end
                if hasDouhao then 
                    kLogDatas[#kLogDatas + 1] = "，"
                end
                local strDamage = "造成%.0f点伤害"
                for j=0,kData['iDuoDuanNum']-1 do
                    kLogDatas[#kLogDatas + 1] = string.format(strDamage,kData['aiFinalNumberAddValue'][j])
                    if j ~= kData['iDuoDuanNum']-1 then
                        kLogDatas[#kLogDatas + 1] = ","
                    end
                end
            end
        elseif kData['iFinalDamageValue'] > 0 then
            local strDamage = GetLanguageByID(200003) --"，造成%.0f点伤害"
            if HasFlag(hurtFlag,BDEF_POZHAO) then
                strDamage = strDamage..GetLanguageByID(200007)
            end
            kLogDatas[#kLogDatas + 1] = string.format(strDamage,kData['iFinalDamageValue'])
        end

        if kData['iFinalMPDamageValue'] > 0 then
            kLogDatas[#kLogDatas + 1] = string.format('，造成%.0f点真气燃烧',kData['iFinalMPDamageValue'])
        end
        if kData['iReboundDamageValue'] > 0 then
            kLogDatas[#kLogDatas + 1] = string.format("\n%s%s%s%s",kTargetName,GetLanguageByID(200001),sAttackUnitName,string.format(GetLanguageByID(200014),kData['iReboundDamageValue']))
        end
        sLogs[#sLogs + 1] = {table.concat(kLogDatas, ""),TBoolean.BOOL_YES}

        -- if kTargetUnit and not hasProssBuffFlag[iTargetUnitIndex] then
        --     hasProssBuffFlag[iTargetUnitIndex] = true
        --     self:AddBattleBuffLog(kBattleLogData,iTargetUnitIndex,sLogs)
        -- end
    end
end

function LogicMain:TransBattleLog(kBattleLogData)
    local sLogs = {}
    local iOwnUnitIndex = kBattleLogData['iOwnerUnitIndex']
    local kAttackUnit = self.kUnitMgr:GetUnit(iOwnUnitIndex)
    local sAttackUnitName = GetUnitLogName(kAttackUnit)
    if kAttackUnit == nil then
        return
    end
    self:TransBattleLog_TriggerSkill(kBattleLogData,sLogs,sAttackUnitName,kAttackUnit)
    self:TransBattleLog_TriggerBuff(kBattleLogData,sLogs,sAttackUnitName)
    LuaEventDispatcher:dispatchEvent("BATTLE_ADD_LOG",sLogs)
    self:TransBattleLog_UnitDeathLog(kBattleLogData)
end

local l_processBuffLog = function(buffInfo,iTargetUnitIndex,sLogs)
    local kTargetUnit = UnitMgr:GetInstance():GetUnit(iTargetUnitIndex)
    local sTargetName = GetUnitLogName(kTargetUnit)
    local Local_TB_Buff = TableDataManager:GetInstance():GetTable("Buff")
    for iBuffTypeID,infos in pairs(buffInfo[iTargetUnitIndex]) do
        for index,info in ipairs(infos) do 
            -- if not info[3].hasLog then 
                local iLayerNum = info[2]
                -- info[3].hasLog = true
                local tbBuffData = Local_TB_Buff[iBuffTypeID]
                if  tbBuffData ~= nil and iLayerNum ~= 0 then       -- 0层不显示
                    local bool_hide = false
                    local string_pre = '受到'
                    if DEBUG_MODE then
                        if type(tbBuffData.BuffFeature) ~= 'table' then 
                            SystemTipManager:GetInstance():AddPopupTip('Buff-BuffFeature 配置不正确 ID:' .. tostring(iBuffTypeID))
                        end
                    end
                    if tbBuffData.BuffFeature then 
                        for _, value in pairs(tbBuffData.BuffFeature) do
                            if  value == BuffFeatureType.BuffFeatureType_Hide then
                                bool_hide = true
                            end
                            if value == BuffFeatureType.BuffFeatureType_PositiveBuff then
                                string_pre = '获得'
                            end
                        end
                    end
                    if not bool_hide then
                        sLogs[#sLogs + 1] = {string.format("%s%s%s(%d层)",sTargetName,string_pre,GetLanguageByID(tbBuffData.NameID),iLayerNum),tbBuffData.SimpleLog}
                    end            
                end
            -- end
        end
    end
end
function LogicMain:AddBattleBuffLog(kBattleLogData,iTargetUnitIndex,kLogDatas)
    local sLogs = {}
    local buffInfo = {}
    -- 合并同对象buff
    for index = 0,kBattleLogData.iBuffNum - 1 do
        local buff = kBattleLogData.akBuffData[index]
        if  buff ~= nil then
            local iBuffTypeID = buff.iBuffTypeID
            local iRoundNum = buff.iRoundNum
            local iLayerNum = buff.iLayerNum
            local iOwnUnitIndex = buff.iOwnUnitIndex
            if buffInfo[iOwnUnitIndex] then
                if buffInfo[iOwnUnitIndex][iBuffTypeID] then
                    local flag = true
                    for k,v in pairs(buffInfo[iOwnUnitIndex][iBuffTypeID]) do
                        if v[1] == iRoundNum then
                            flag = false
                            v[2] = v[2] + iLayerNum
                            break
                        end
                    end
                    if flag then
                        table.insert(buffInfo[iOwnUnitIndex][iBuffTypeID],{iRoundNum,iLayerNum,buff})
                    end
                else
                    buffInfo[iOwnUnitIndex][iBuffTypeID] = {{iRoundNum,iLayerNum,buff}}
                end
            else
                buffInfo[iOwnUnitIndex] = {}
                buffInfo[iOwnUnitIndex][iBuffTypeID] = {{iRoundNum,iLayerNum,buff}}
            end
        end
    end
    if iTargetUnitIndex and buffInfo[iTargetUnitIndex] then
        l_processBuffLog(buffInfo,iTargetUnitIndex,sLogs)
    else
        for iOwnUnitIndex,info in pairs(buffInfo) do
            l_processBuffLog(buffInfo,iOwnUnitIndex,sLogs)
        end
    end
    if #sLogs > 0 then
        if kLogDatas then
            for k,v in ipairs(sLogs) do
                kLogDatas[#kLogDatas+1] = v
            end
        else
            LuaEventDispatcher:dispatchEvent("BATTLE_ADD_LOG",sLogs)
        end
    end
end

function LogicMain:GetBuffDesc(iBuffIndex,tbBuffData)
    if self.buffDescInfo and self.buffDescInfo[iBuffIndex] then
        local info = self.buffDescInfo[iBuffIndex]
        local iDescLangID = info.iDescLangID
        local iParam1 = info.iParam1
        local iParam2 = info.iParam2
        if iParam2 ~= 0 then
            return string.format(iDescLangID,iParam1,iParam2)
        end
        if iParam1 ~= 0 then
            return string.format(iDescLangID,iParam1)
        end
        return iDescLangID
    else
        return GetLanguageByID(tbBuffData.DescID)
    end
end

function LogicMain:UpdateBuffDesc(retStream)
    self.buffDescInfo = {}
    for i=0,retStream.iNum-1 do
        self.buffDescInfo[retStream.akUnits[i].iBuffIndex] = retStream.akUnits[i]
    end
end

function LogicMain:UpdateRound(retStream)
    LuaEventDispatcher:dispatchEvent("BATTLE_UPDATE_ROUND",retStream.iRound+1)
end

function LogicMain:SaveUnitInfo(retStream)
    self._saveUnitInfo = self._saveUnitInfo or {}
    for i =0,retStream['iNum']-1 do
        local kUnitData = retStream['akUnits'][i]
        local kUnit = self.kUnitMgr:GetUnit(kUnitData['uiUnitIndex'])
        --如果是新增的
        if kUnit == nil then
            self._saveUnitInfo[kUnitData['uiUnitIndex']] = kUnitData
        end
    end
end

function LogicMain:CreateUnit(retStream)
    do return true end
    -- if not self:IsRun() then
    --     return
    -- end
    -- TimeLineHelper:GetInstance():Reset()
    -- TimeLineHelper:GetInstance():SetCanUpdate(true)
    -- local startTime = 0
    -- for i =0,retStream['iNum']-1 do
    --     local kUnitData = retStream['akUnits'][i]
    --     local kUnit = self.kUnitMgr:GetUnit(kUnitData['uiUnitIndex'])
    --     if kUnit == nil then
    --         kUnit = self.kUnitMgr:CreatUnit(self.objActorNode,kUnitData,startTime)
    --     end
    -- end
end

function LogicMain:UpdateUnit(retStream)
    if not self:IsRun() then
        return
    end
    TimeLineHelper:GetInstance():Reset()
    TimeLineHelper:GetInstance():SetCanUpdate(true)
    local startTime = 0
    for i =0,retStream['iNum']-1 do
        local kUnitData = retStream['akUnits'][i]
        local kUnit = self.kUnitMgr:GetUnit(kUnitData['uiUnitIndex'])
        --如果是新增的
        if kUnit == nil then
            kUnit = LogicMain:GetInstance():CreateOneUnit(kUnitData['uiUnitIndex'],startTime)
        end
        if kUnit then
            kUnit:SetData(kUnitData)
        end
    end
    self:SetCanPauseAreanReplay()
end

function LogicMain:CreateOneUnit(unitIndex,startTime)
    if self._saveUnitInfo then
        local kUnitData = self._saveUnitInfo[unitIndex]
        if kUnitData then
            startTime = startTime or 0
            return self.kUnitMgr:CreatUnit(self.objActorNode,kUnitData,startTime,true)
        end
    end
end

function LogicMain:ReturnToTown(runImmediately)
    --self:ClearStatisticalData()
    self:ClearReplayInfo()
    self:Clear()
    if runImmediately == true then
        RemoveWindowImmediately("BattleUI")
    else
        RemoveWindowImmediately("BattleUI")
    end
    DisplayUpdateScene(runImmediately)
    self:ClearStatisticalData()
end

function LogicMain:ReturnToGame()
    OpenWindowImmediately("LoadingUI")
    self:Clear()
end

function LogicMain:CallHelpResultCallBack(data)
    if data.isSuccess >= 1 then
        local kBattleGameEndUI = GetUIWindow("BattleGameEndUI")
        if kBattleGameEndUI then
            kBattleGameEndUI:SetActive(false)
        end
        RemoveWindowImmediately("BattleGameEndUI")
        DisplayActionEnd()
    else
        if data.reason == 1 then
            DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, "银锭不足")
        end
    end
end

function LogicMain:OnDestroy()
    LuaEventDispatcher:removeEventListener("BattleUI_UnitEndTurn",self.handle.BattleUIUnitEndTurn)
    LuaEventDispatcher:removeEventListener("BATTLE_CLICK_BATTLE_AUTO",self.handle.ChangeAutoBattle)
    self.handle = nil
    self:Clear()
    self.kUnitMgr:OnDestroy()
    self.kPathFinder:OnDestroy()
    self.kEffectMgr:OnDestroy()
    self.kBattleTreasureBox:OnDestroy()
    self.kUnitMgr = nil
    self.kPathFinder = nil
    self.kEffectMgr = nil
    self.kBattleTreasureBox = nil
end

function LogicMain:ProcessStartBattlePlot(SeBattle_HurtInfo)
    local flag = true
    if SeBattle_HurtInfo.iPlotNum and SeBattle_HurtInfo.iPlotNum > 0 then
        for int_i=1,SeBattle_HurtInfo.iPlotNum do
            local plotInfo = SeBattle_HurtInfo.akPlotData[int_i-1]
            if plotInfo.eEventType == Event.Event_ZhanDouKaiShi then
                AnimationMgr:GetInstance():AddPlot(plotInfo)
                flag = false
            end
        end
    end
    return flag
end

function LogicMain:AnalysisPlot(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.iPlotNum and SeBattle_HurtInfo.iPlotNum > 0 then
        for int_i=1,SeBattle_HurtInfo.iPlotNum do
            local plotInfo = SeBattle_HurtInfo.akPlotData[int_i-1]
            AnimationMgr:GetInstance():AddPlot(plotInfo)
        end
    end
    return true
end

function LogicMain:ProcessHurtInfo(SeBattle_HurtInfo)
    BattleSceneAnimation:GetInstance():processHurtInfo(SeBattle_HurtInfo)
end

function LogicMain:ProcessPlot(eventType)
    local lAnimationMgr = AnimationMgr:GetInstance()

    local plotList = lAnimationMgr:GetPlotList(eventType)
    if plotList == nil or #plotList == 0 then
        return true
    end
    for int_i=1,#plotList do
        lAnimationMgr:ProcessPlot(plotList[int_i])
    end
    lAnimationMgr:ClearPlotList(eventType)
end

function LogicMain:StartBattle(retStream)
    self:LockQuitBattle()
    LogicMain:GetInstance():StartGame(retStream)
end


function LogicMain:UpdateTreasureBox(info)
    if not info then
        return
    end
    
    local num = info["iNum"]

    if not num then
        return
    end

    local TreasureBoxes = globalDataPool:getData("BattleTreasureBoxes") or {}
    if num <= 0 then
        TreasureBoxes['boxes'] = nil
    else
        if not TreasureBoxes['boxes'] then
            TreasureBoxes['boxes'] = {}
        end
    end

    local key,x,y
    for i = 0, num - 1 do
        x = info['akBattleLog'][i]['iGridX']
        y = info['akBattleLog'][i]['iGridY']
        if x and y then
            key = x << 16 | y
            TreasureBoxes['boxes'][key] = info['akBattleLog'][i]
        end
    end

    globalDataPool:setData("BattleTreasureBoxes",TreasureBoxes,true)

    LuaEventDispatcher:dispatchEvent("Battle_Update_TreasureBox")
end



function LogicMain:SaveOtherMsg(iCmdType,kRetData,iSize)
    self.otherMsg = self.otherMsg or {}
    table.insert(self.otherMsg,{iCmdType,kRetData,iSize})
end

function LogicMain:ExitBattleMsg()
    self.isBattleProcess = false
    if self.otherMsg then
        DisplayActionManager:GetInstance():CacheAllAction()
        for i=1,#self.otherMsg do
            ProcessLogicShowCmd(self.otherMsg[i][1],self.otherMsg[i][2],self.otherMsg[i][3])
        end
        DisplayActionManager:GetInstance():ProcActionCache()
        self.otherMsg = nil
    end
end

local SpineRoleUI = require 'UI/Role/SpineRoleUI'
function LogicMain:ShowMoveSkillDamageRangeGrid(info)
    local curGrid = info[1]
    local attackGrid = info[2]
    local grid = info[3]
    local uiModleID = info[4]
    local uiRoleID = info[5]
    local face = info[6]
    self:ClearGridColor("Red")
    if #curGrid > 0 then
        for i = 1, #curGrid do
            if curGrid[i][3] then
                self:SetGridColor(curGrid[i][1], curGrid[i][2], "Red")
            end
        end

        --设置虚影
        if grid and uiModleID then
            if self.zhiShiObject then
                self:ChangeZhiCharacter(uiModleID,grid,face)
            else
                self:LoadZhiShiSpineCharacter(uiModleID,grid,face,uiRoleID)
            end
        end
    end
end

function LogicMain:HideZhiShiObject()
    if self.zhiShiObject then
        self.zhiShiObject:SetActive(false)
    end
end

function LogicMain:LoadZhiShiSpineCharacter(uiModleID,grid,face,uiRoleID)
    local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", uiModleID)
    local strPath = typeData and typeData.Model or "role_xiaobangzhu"
    if not IsValidObj(self.objActorNode) then
        dprint("kParent is nil")
        return
    end

    self.objActorNode:SetActive(true)
    self.zhiShiObject = LoadSpineCharacter(strPath,self.objActorNode)
    if self.zhiShiObject == nil then
        self.zhiShiObject = LoadSpineCharacter("role_nan",self.objActorNode)
    end

    local transform = self.zhiShiObject.transform
    self.zhiShiSkeletonAnimation = self.zhiShiObject:GetComponent("SkeletonAnimation")
    local SkeletonRenderSeparator = self.zhiShiObject:GetComponent("SkeletonRenderSeparator");
    self.SortingGroup = self.zhiShiObject:GetComponent("SortingGroup");
    if self.SortingGroup == nil then
        self.SortingGroup = self.zhiShiObject:AddComponent(typeof(DRCSRef.SortingGroup))
    end

    self.zhiShiObject.layer = 9
    local iNum = transform.childCount
	for i = 0, iNum -1  do
		local kChild = transform:GetChild(i)
		kChild.gameObject.layer = 9
    end
    self:ChangeZhiCharacter(uiModleID,grid,face)
    self.SpineRoleUI:UpdateRoleSpine(self.zhiShiObject, uiRoleID)
    self.zhiShiObject.transform.localScale = self.zhiShiObject.transform.localScale * SCALE_BATTLE_UNIT
end

function LogicMain:ChangeZhiCharacter(uiModleID,grid,face)
    if self.zhiShiObject == nil then return end
    if self.uiZhiShiModleID ~= uiModleID then
        local typeData = TableDataManager:GetInstance():GetTableData("RoleModel", uiModleID)
        local spineTexture = typeData and typeData.Texture
        local strPath = typeData and typeData.Model or "role_xiaobangzhu"
        DynamicChangeSpine(self.zhiShiObject,strPath)
        if spineTexture then
            self.zhiShiObject_Texture = ChnageSpineSkin(self.zhiShiObject, spineTexture)
        end
    end

    self.zhiShiObject:SetActive(true)
    self:SetZhiShiShowParameter(grid,face)
    self.uiZhiShiModleID = uiModleID
end

function LogicMain:SetZhiShiShowParameter(grid,face)
    if self.zhiShiObject == nil then return end
    local baseDepth = GetDepthByGridPos(grid.x,grid.y)
    self.SortingGroup.sortingOrder = baseDepth
    self.zhiShiSkeletonAnimation.skeleton.ScaleX = face >= 0 and 1 or -1
    self.zhiShiObject.transform.localPosition = GetPosByGrid(grid.x,grid.y)
    changeShapsAlpha(self.zhiShiObject,0.6)
end


function LogicMain:_InitGrid()
    self.SpineRoleUI = SpineRoleUI.new()
    self.objBattleGrid = DRCSRef.FindGameObj("BattleGrid") --直接在场景中的物体
    self.comBatteGridHelper = self.objBattleGrid:GetComponent('BattleGridHelper')
    self.objBattleGridBG = DRCSRef.FindGameObj("Grid_BG")
    local height = SSD_BATTLE_GRID_HEIGHT
    local x = 0
    local y = 0
    local bInit = true
    if GRID_POS == nil then
        GRID_POS = {}
        bInit = false
    end
    for i = 1, 40 do
        x = math.floor((i - 1) / height) + 1
        y = ((i - 1) % height) + 1
        if GRID_POS[x] == nil then
            GRID_POS[x] = {}
        end
        local obj = self.objBattleGrid:FindChild("Grid_Node/" .. i)
        obj:SetActive(true)
        if bInit == false then
            GRID_POS[x][y] = obj.transform.position
        end
    end

    if bInit == false then
        local xOffSet = 0.7
        local yDefault = 0.58
        local yOffSet = 0.40
        local startIndex = SSD_BATTLE_GRID_HEIGHT+1
        for i=1, SSD_BATTLE_GRID_WIDTH do
            for j=startIndex, startIndex+1 do
                local pos = GRID_POS[i][j-1];
                GRID_POS[i][j] = DRCSRef.Vec3(pos.x + xOffSet * (j - startIndex),pos.y + yDefault - yOffSet * (j - startIndex) ,pos.z);
            end
        end
    end

    self:ClearGridColor()
    self.comBattleClickScence = DRCSRef.FindGameObj("BattleGrid"):GetComponent("BattleClickScence")
    self.comBattleClickScence:SetPointUpAction(
        function(obj)
            self:OnClick_Grid(obj)
        end
    )
    self.comBattleClickScence:SetMoveAction(
        function(obj)
            self:OnMove_Grid(obj)
        end
    )
    self.comBattleClickScence:SetPointDownAction(
        function(obj)
            self:OnMove_Grid(obj)
        end
    )

    self.comBattleClickScence:SetPointLongPressAction(
        function(obj)
            self:ShowGridTip(obj)
        end
    )

    self.comBattleClickScence:SetPointRightClickAction(function(obj)
        self:ShowGridTip(obj)
    end)
    self:ShowAllGrid(false)
end

function LogicMain:ShowGridTip(obj)
    local l_logicMain = LogicMain:GetInstance()
    local iIndex = tonumber(obj.name)
    if iIndex == nil then return end
    local x = math.floor((iIndex - 1) / SSD_BATTLE_GRID_HEIGHT) + 1
    local y = (iIndex - 1) % SSD_BATTLE_GRID_HEIGHT + 1
    local aiUnitIndex = l_logicMain.kPathFinder.grid:GetNodeUnitIndex(x,y)
    if aiUnitIndex then
        for key, value in pairs(aiUnitIndex) do
            l_logicMain:OnClick_ShowGridTip(key)
            break
        end
    end
end

function LogicMain:ShowAllGrid(boolean_show)
    if self.objBattleGrid then
        self.objBattleGrid:SetActive(boolean_show)
        self:HideZhiShiObject()
    end
end

function LogicMain:IsGridShow()
    if self.objBattleGrid then
        return self.objBattleGrid.activeSelf
    end
    return false
end

function LogicMain:OnClick_ShowGridTip(iIndex)
    local tips = TipsDataManager:GetInstance():GetBattleRoleTips(iIndex)
    if tips == nil then return end
    local buttons = {
        {
            ['name'] = "详细信息",
            ['func'] = function()
                local data = EncodeSendSeGC_Click_Battle_OBSERVE(iIndex)
                local iSize = data:GetCurPos()
                NetGameCmdSend(SGC_CLICK_BATTLE_OBSERVE,iSize,data)
            end
        }
    }
    if self:IsReplaying() then
        buttons = nil
    end
    SystemUICall:GetInstance():TipsPop(tips, buttons)
end

function LogicMain:OnMove_Grid(obj)
    local iIndex = tonumber(obj.name)
    if iIndex == nil then return end
    local x = math.floor((iIndex - 1) / SSD_BATTLE_GRID_HEIGHT) + 1
    local y = (iIndex - 1) % SSD_BATTLE_GRID_HEIGHT + 1

    if self._oldMoveX == x and self._oldMoveY == y then
        --return    pc鼠标滚轮切换技能后要根据当前鼠标位置更新,所以注释掉该return
    end
    self._oldMoveX = x
    self._oldMoveY = y
    LuaEventDispatcher:dispatchEvent("UI_MOVE_GRID", {x, y})
    GuideDataManager:GetInstance():BattleMoveRoleClick(x, y)
end

function LogicMain:OnClick_Grid(obj)
    local name = obj.name
    if name == "left" then
        local tips = self.kUnitMgr:GetPetTipsInfo(SE_CAMPA)
        if tips then
            OpenWindowImmediately("TipsPopUI", tips)
        end
    elseif name == "right" then
        local tips = self.kUnitMgr:GetPetTipsInfo(SE_CAMPB)
        if tips then
            OpenWindowImmediately("TipsPopUI", tips)
        end
    else
        local iIndex = tonumber(name)
        local x = math.floor((iIndex - 1) / SSD_BATTLE_GRID_HEIGHT) + 1
        local y = (iIndex - 1) % SSD_BATTLE_GRID_HEIGHT + 1
        self.kUnitMgr:UI_Click_Grid(x,y)
        self._oldMoveX = x
        self._oldMoveY = y
    end
end

function LogicMain:ClearGridColor(ColorName)
    if ColorName == nil then
        self.comBatteGridHelper:ClearAllColor()
    else
        self.comBatteGridHelper:ClearColor(GRID_COLOR_INDEX[ColorName])
    end
end

function LogicMain:SetGridColor(gridPosX, gridPosY, ColorName)
    if IsInBattleGrid(gridPosX,gridPosY) then
        self.comBatteGridHelper:SetGridColor(gridPosX-1,gridPosY-1,GRID_COLOR_INDEX[ColorName])
    end
end

function LogicMain:ShowCanMoveGrid(grid)
    self:ClearGridColor()
    self:SetCanShowSkillGrid(true)
    if grid ~= nil then
        self._canMoveGridPos = grid
    end
    if self._canMoveGridPos then
        for i = 1, #self._canMoveGridPos do
            self:SetGridColor(self._canMoveGridPos[i][1], self._canMoveGridPos[i][2], "Blue")
        end
    end
end

function LogicMain:ShowCanAttackGrid(grid)
    if self:CanShowSkillGrid() then
        self:ClearGridColor("Skill")
    end
    self:ClearGridColor("Yellow")
    self:ClearGridColor("Gray")
    local bHasTarget = false
    if grid then
        for i = 1, #grid do
            bHasTarget = grid[i][3]
            if self:CanShowSkillGrid() then
                self:SetGridColor(grid[i][1], grid[i][2], "Skill")
            end
            if bHasTarget then
                self:SetGridColor(grid[i][1], grid[i][2], "Yellow")
            else
                self:SetGridColor(grid[i][1], grid[i][2], "Gray")
            end
        end
    end
end

function LogicMain:ShowSkillDamageRangeGrid(gird)
    self:ClearGridColor("Green")
    for i = 1, #gird do
        if gird[i][3] then
            self:SetGridColor(gird[i][1], gird[i][2], "Green")
        end
    end
end

function LogicMain:CanMove(x,y)
    if self._canMoveGridPos then
        for i = 1, #self._canMoveGridPos do
            if x == self._canMoveGridPos[i][1] and y == self._canMoveGridPos[i][2] then
                return true
            end
        end
    end
    return false
end

function LogicMain:ShowSkillRangeGrid(gird)
    self:SetCanShowSkillGrid(false)
    LogicMain:GetInstance():ClearGridColor()
    for i = 1, #gird do
        LogicMain:GetInstance():SetGridColor(gird[i][1], gird[i][2], "Gray")
    end
end

function LogicMain:SaveComboInfo(retStream)
    local comboInfo = retStream.aComboInfo
    if comboInfo then
        local unit = self.kUnitMgr:GetUnit(comboInfo['uiUnitIndex'])
        if unit then
            unit:SetComboData(comboInfo.iComboNum,comboInfo.aiComboBaseID)
        end
    end
end

function LogicMain:Replay()
    if self._Replaying then return end
    self._Replaying = true
    for i=1,#self._RecordMsg do
        local info = self._RecordMsg[i]
        if _G[info[1]] then
            _G[info[1]](info[2])
        end
    end
    ProcessBattleMsg()
end

function LogicMain:ContinueBattle()
    if IsBattleOpen() then
        -- 和服务器同步下状态信息
        -- 同步下当前行动对象是否一致
    end
end

--------伤害统计 开始--------
function LogicMain:ProcessStatisticalData(info)
    if self._Replaying then return end -- 回放时不统计
    if info[1] == "ProcessHurtInfo" then
        self:StatisticalDamage(info[2]) ---统计伤害信息
    elseif info[1] == "UpdateRound" then
        self:StatisticalRound(info[2]) --统计回合信息
    elseif info[1] == "CreateUnit" then
        self:StatisticalPeople(info[2]) --统计人员信息
    elseif info[1] == "StartBattle" then
        self:StatisticalPeople(info[2]) --统计人员信息
    end
end


--统计所有双方人员
function LogicMain:StatisticalPeople(peopleData)
    if peopleData then
        if peopleData.akUnits and #peopleData.akUnits > 0 then
            for k,v in pairs(peopleData.akUnits) do
                if (not self.akStatisticalDamageData[v.uiUnitIndex]) then
                    local data = {["iDamage"] = 0,["iHurt"] = 0,["sName"] = "",["sHeadPath"] = "",["iSurviveRound"] = 0,["iUnitIndex"] = v.uiUnitIndex}
                    self.akStatisticalDamageData[v.uiUnitIndex] = data
                end
            end
        end
    end
end

function LogicMain:StatisticalRound(roundData)
    self.iStatisticalRound = roundData.iRound+1
end

function LogicMain:SetUnitSurviveRound(iUnitIndex)
    local data = self.akStatisticalDamageData[iUnitIndex]
    if data then
        data.iSurviveRound = self.iStatisticalRound
    end
end

--添加受到伤害信息
function LogicMain:AddHurtNum(iUnitIndex,iHurtNum)
    if iUnitIndex == 0 or iUnitIndex == nil then
        return
    end
    local data = self.akStatisticalDamageData[iUnitIndex]
    if data == nil then
        data = {["iDamage"] = 0,["iHurt"] = 0,["sName"] = "",["sHeadPath"] = "",["iSurviveRound"] = 0,["iUnitIndex"] = iUnitIndex}
        self.akStatisticalDamageData[iUnitIndex] = data
    end
    data['iHurt'] = data['iHurt'] + iHurtNum
end

--添加伤害信息
function LogicMain:AddDamageNum(iUnitIndex,iDamage)
    if iUnitIndex == 0 or iUnitIndex == nil then
        return
    end
    local data = self.akStatisticalDamageData[iUnitIndex]
    if data == nil then
        data = {["iDamage"] = 0,["iHurt"] = 0,["sName"] = "",["sHeadPath"] = "", ["iSurviveRound"] = 0,["iUnitIndex"] = iUnitIndex}
        self.akStatisticalDamageData[iUnitIndex] = data
    end
    data['iDamage'] = data['iDamage'] + iDamage
end



--统计伤害信息
function LogicMain:StatisticalDamage(hurtInfo)
    if hurtInfo then
        if hurtInfo.iMutilTag == MutilAnqiTag.MT_START then return end
        local iOwnerUnitIndex = hurtInfo['iOwnerUnitIndex']
        local eSkillEventType = hurtInfo['eSkillEventType']
        if not self:NotRecordLog(hurtInfo) then
            for i = 0,hurtInfo.iSkillDamageData -1 do
                local data = hurtInfo["akSkillDamageData"][i]
                if data['iDuoDuanNum'] > 1 then --多段伤害
                    local iTotalNumberDamage = 0
                    for j=0,data['iDuoDuanNum']-1 do
                        iTotalNumberDamage = iTotalNumberDamage + data['aiFinalNumberAddValue'][j]
                    end
                    if iTotalNumberDamage > 0 then
                        self:AddDamageNum(iOwnerUnitIndex,iTotalNumberDamage)
                        self:AddHurtNum(data['iTargetUnitIndex'],iTotalNumberDamage)
                    end
                elseif data['iFinalDamageValue'] > 0  then
                    self:AddDamageNum(iOwnerUnitIndex,data['iFinalDamageValue'])
                    self:AddHurtNum(data['iTargetUnitIndex'],data['iFinalDamageValue'])
                end
                if data['iFinalMPDamageValue'] > 0 then
                    self:AddDamageNum(iOwnerUnitIndex,data['iFinalMPDamageValue'])
                    self:AddHurtNum(data['iTargetUnitIndex'],data['iFinalMPDamageValue'])
                end
                if data['iReboundDamageValue'] > 0 then
                    self:AddHurtNum(iOwnerUnitIndex,data['iReboundDamageValue'])
                    self:AddDamageNum(data['iTargetUnitIndex'],data['iReboundDamageValue'])
                end
            end
        end
        --buff的伤害，只有伤害值 没有来源信息
        if hurtInfo.iBuffDamage > 0 then
            self:AddHurtNum(iOwnerUnitIndex,hurtInfo.iBuffDamage)
        end

        if hurtInfo.bDeath > 0 then
            self:SetUnitSurviveRound(iOwnerUnitIndex)
        end
    end
end

--设置 参战玩家姓名 头像
--必须在Clear前调用且单位创建后才有
function LogicMain:SetStatisticalDamageExtra()
    if self.bGenStatisticaDamageName == false then
        self.bGenStatisticaDamageName = true
        for k,v in pairs(self.akStatisticalDamageData) do
            local kUnit = UnitMgr:GetInstance():GetUnit(k)
            if kUnit then
                v['sName'] = kUnit:GetName()
                v['sHeadPath'] = kUnit:GetHead()
                v['sCamp'] = kUnit:GetCamp()
                v['kRoleFaceData'] = kUnit.kRoleFaceData
            end
            --等于0说明没死，没死的话 按当前回合数算
            if v.iSurviveRound == 0 then
                v.iSurviveRound = self.iStatisticalRound
            end
        end
    end
end

--获取统计的伤害信息
--key:UnitIndex Value: {["iDamage"] = 0,["iHurt"] = 0,["sName"] = "",["sHeadPath"] = "",["iUnitIndex"] = iUnitIndex}
function LogicMain:GetStatisticalDamage()
    if self.bGenStatisticaDamageName == false then
        self:SetStatisticalDamageExtra()
    end
    return self.akStatisticalDamageData
end

function LogicMain:ClearStatisticalData()
    self.akStatisticalDamageData = {} --战斗伤害信息数据
end

function LogicMain:GetBattleVictoryCamp()
   return self.statisticalDataVictoryCamp
end


function LogicMain:SetBattleLog(data)
    self.battleLogAll = {}
    self.battleLogAll = data
end

function LogicMain:GetBattleLog()
    return self.battleLogAll
end


--------伤害统计 结束--------

function LogicMain:ProcessReconnect()
    if self:IsRun() then
        local data = EncodeSendSeGC_Click_Battle_Check(self._ccount,self._scount)
        local iSize = data:GetCurPos()
        NetGameCmdSend(SGC_CLICK_BATTLE_CHECK,iSize,data)
    end
end


function LogicMain:SaveBattleEndInfo(retStream)
    SetConfig("BettleEndMsg" .. GetCurScriptID(),{
        ['script'] = GetCurScriptID(),
        ['player'] = PlayerSetDataManager:GetInstance():GetPlayerID(),
        ['data'] = retStream
    },true)
end

function LogicMain:ClearBattleEndInfo()
    SetConfig("BettleEndMsg",nil,true)
end

function LogicMain:KeyBoardUpdate()
    if IsInGuide() then --有引导时,所有快捷键都不响应
        return
    end
    if DEBUG_MODE and l_GetKeyDown("f1") then
        KeyboardManager:GetInstance():ResetKeyboardSettings()
    end
    self:CheckKeyboardInBattleUI()

    self:CheckKeyboardInDialog()

    self:CheckESCKey()
     
end
local funcType = {
    FuncType.ChooseSkill1,
    FuncType.ChooseSkill2,
    FuncType.ChooseSkill3,
    FuncType.ChooseSkill4,
    FuncType.ChooseSkill5,
    FuncType.ChooseSkill6,
    FuncType.ChooseSkill7,
}
function LogicMain:CheckKeyboardInBattleUI()
    if IsWindowOpen("BattleUI") and IsNotInGuide() then
        --按住左右任意shift键切换自动战斗功能
        if self:IsUnLockAuto() and GetKeyDownByFuncType(FuncType.SwitchAutoBattle) then
            self:ChangeAutoBattle()
            self.BattleUI:RefreshAutoBattleUI()
        end
        --按数字键选择技能
        for i = 1,7 do  --1到7支持改键
            if GetKeyDownByFuncType(funcType[i]) then
                self.BattleUI:OnClick_Skill(i)
            end
        end

        if GetKeyDownByFuncType(FuncType.EndTurn) then
            local curUnit =self.kUnitMgr:GetCurOptUnit()
            if curUnit and curUnit.iCamp==1 then
                self.BattleUI:OnClick_EndTurnButton()
            end
        end

        if GetKeyDownByFuncType(FuncType.ReselectPos) then
            self.BattleUI:OnClick_ResetPosButton()
        end

        if GetKeyDownByFuncType(l_SkillPageFuncType["next"]) then
            self.BattleUI:OnClick_PageButton(1)
        end

        if GetKeyDownByFuncType(l_SkillPageFuncType["pre"]) then
            self.BattleUI:OnClick_PageButton(-1);
        end
        
        if GetKeyDownByFuncType(FuncType.ChooseNextSkill) or (g_CanSwitchSkill and l_GetMouseScrollWheel(l_MouseScrollWheelKey) < 0)  then --按Q或者鼠标滚轮上滚前一个技能
            self.BattleUI:ChooseNextSkill()
        elseif GetKeyDownByFuncType(FuncType.ChoosePreSkill) or (g_CanSwitchSkill and l_GetMouseScrollWheel(l_MouseScrollWheelKey) > 0) then --按E或者鼠标滚轮下滚后一个技能
            self.BattleUI:ChoosePreSkill()
        end
    end
end

function LogicMain:CheckKeyboardInDialog()
    if IsInDialog() then
        -- 刷新界面打开时快捷键无效
        if IsWindowOpen("GeneralRefreshBoxUI") then return end
        --按住左shift键切换自动对话功能
        if GetKeyDownByFuncType(FuncType.SwitchAutoDialog) then
            if self.DialogControlUI ~= nil then
                self.DialogControlUI:OnClickOpenAuto()
            end
        end
        --上滚>0，下滚<0
        --鼠标滚轮上滚打开对话记录窗口
        if l_GetMouseScrollWheel(l_MouseScrollWheelKey) > 0 then
            if not g_isInScrollRect then
                OpenWindowImmediately("DialogRecordUI")
            end
        end
        --鼠标滚轮下滚点击屏幕
        if l_GetMouseScrollWheel(l_MouseScrollWheelKey) < 0 then
            local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
            if dialogChoiceUI ~= nil then
                dialogChoiceUI:OnClickScreen()
            end
        end
        --非Debug模式下按住空格推进对话
        if not DEBUG_MODE  then
            if GetKeyDownByFuncType(FuncType.NextDialog) then
                self.count = 0
                self:BoostDialog()
            end
            -- if l_GetKeyUp(CS.UnityEngine.KeyCode.Space) then
            --     self.count = 0
            -- end
            if l_GetKey(CS.UnityEngine.KeyCode.Space) then
                self.count = self.count + 1
                if self.count > waitTime then
                    self:BoostDialog()
                end
                --1000000 作为极限值使用   防止玩家 长按出错
                if self.count > 1000000 then
                    self.count = waitTime + 1
                end
                if IsWindowOpen('ComicPlotUI') then
                    local comicPlotUI = GetUIWindow('ComicPlotUI')
                    if comicPlotUI then
                        comicPlotUI:OnClickScreen()
                    end
                end
            end
        elseif DEBUG_MODE  then
            if GetKeyDownByFuncType(FuncType.NextDialog) then 
                self.count = 0
                self:BoostDialog()
            end
            if l_GetKey(CS.UnityEngine.KeyCode.Space) then
                self.count = self.count + 1
                if self.count > waitTime then
                    self:BoostDialog()
                end
                --1000000 作为极限值使用   防止玩家 长按出错
                if self.count > 1000000 then
                    self.count = waitTime + 1
                end
            end
        end
    end
end

function LogicMain:BoostDialog()
    local curAction = DisplayActionManager:GetInstance():GetCurAction()
    if curAction ~= nil then
        local curActionType = curAction.actionType
        if (curActionType == DisplayActionType.PLOT_EXECUTE_PLOT or curActionType == DisplayActionType.PLOT_DIALOGUE) and curAction.params ~= nil then
                local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
                if dialogChoiceUI ~= nil then 
                    dialogChoiceUI:OnClickScreen()
                end
        end
    end


        
end

-- 所有需要ESC功能的界面,实现OnPressESCKey接口后添加入此列表并使子界面在此列表中放于父界面之后
-- 自底向上关闭，每次只关闭一个
local l_NeedESCWindowX={
    "ToptitleUI",
    "WindowBarUI",
    "MazeUI",
    "StoryUI",
    "PlayerSetUI",
    "CharacterUI",
    "SelectUI",
    "NpcConsultUI",
    "DialogChoiceUI",
    "GiveGiftDialogUI",
    "ObsBabyUI",
    "DialogRecordUI",
    "PickGiftUI",
    "StorageUI",
    "ItemRecycleUI",
    "CollectionUI",
    "ClanUI",
    "CollectionMartialUI",
    "CollectionHeirloomUI",
    "ClanEliminateUI",
    "ClanBranchEliminateUI",
    "RoleEmbattleUI",
    "AchieveDiffDropUI",
    "TaskUI",
    "TaskCompleteUI",
    "EvolutionUI",
    "DifficultyUI",
    "AchieveRewardUI",
    "SystemAnnouncementUI",
    "StoreUI",
    "ShowAllChooseGoodsUI",
    "BatchChooseUI",
    "AchievementAchieveUI",
    "MeridiansUI",
    "ForgeUI",
    "ClanMartialUI",
    "SpecialRoleIntroduceUI",
    "LevelUPUI",
    "ForgetMartialGiftUI",
    "ShowBackpackUI",
    "PickWishRewardsUI",
    "ClanCardUI",
    "GeneralBoxUI",
    "GeneralRefreshBoxUI",
    "MarryUI",
    "SwornUI",
    "SetNicknameUI",
    "SetNicknameTip",
    "MapUnfoldUI",
    "MazeEntryUI",
    "TitleSelectUI",
    "MartialSelectUI",
    "ObserveUI",
    "CreateFaceUI",
    "DisguiseUI",
    "IncompleteBoxUI",
    "SaveFileUI",
    "RoleSelectUI",
}
function LogicMain:CheckESCKey()
    self.isGeneralBoxUICurFrameOpen = false
    for i=#l_NeedESCWindowX,1,-1 do
        if IsNotInGuide() and IsWindowOpen(l_NeedESCWindowX[i]) and (l_GetKeyDown(ESC_KEY) or l_GetButtonDown("MouseRightButton")) then
            --在当前帧如果ESC键先触发了打开GeneralBoxUI，那这一帧就不应该立即执行GeneralBoxUI的OnPressESCKey
            if l_NeedESCWindowX[i] == "GeneralBoxUI" and self.isGeneralBoxUICurFrameOpen then
                return 
            end
            if IsWindowOpen("GeneralBoxUI") then
                GetUIWindow("GeneralBoxUI"):OnPressESCKey()
                self.isGeneralBoxUICurFrameOpen = false
                return
            end
            local l_window = GetUIWindow(l_NeedESCWindowX[i])
            l_window:OnPressESCKey()
            if IsWindowOpen("TipsPopUI") then
                RemoveWindowImmediately("TipsPopUI")
            end
            if IsWindowOpen("GeneralBoxUI") then    --检查这一帧OnPressESCKey执行后是否打开了GeneralBoxUI
                self.isGeneralBoxUICurFrameOpen = true
            end
            return
        end
    end
end

function LogicMain:IsChangingSkill()
    if self.comBattleClickScence ~= nil then
        self.comBattleClickScence:IsChangingSkill()
    end
end

--用于保证子界面快捷键的响应不会影响到父界面快捷键的响应
function LogicMain:GetOpenWindowsNO()
    if not self.OpenWindowsNO then
        self.OpenWindowsNO = 1
    end
    return self.OpenWindowsNO
end

--这里使用int类型而不使用bool类型是为了防止出现3层界面的情况
function LogicMain:SetOpenWindowsNO(WindowsNO)
    self.OpenWindowsNO = WindowsNO
end


