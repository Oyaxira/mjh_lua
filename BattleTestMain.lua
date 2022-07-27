require("Base/LuaPanda/LuaPanda")
require "Base/Functions"
require "RequireLoad"

LuaPanda.start("127.0.0.1",8818)

local l_globalTimer = nil
local l_windowsMgr = nil
local l_LogicMain = nil
local l_TimeLineHelp = nil
local LOCAL_TB_SkillPerformance = nil
PlayMode = 0
function awake()
    reloadGameModules()
    InitLuaTable()
    InitRoleTable()
    InitLoginMsg()
    InitGameMsg()
    RegisterUIWindows()

    dprint("[Main]->Game  Awake")
    
    l_globalTimer = globalTimer
    l_windowsMgr = WindowsManager:GetInstance()
    l_LogicMain = LogicMain:GetInstance()
    l_animationMgr = AnimationMgr:GetInstance()
    l_TimeLineHelp = TimeLineHelper:GetInstance()
    --设置帧率
    CS.UnityEngine.Application.targetFrameRate=30
    CS.UnityEngine.Debug.developerConsoleVisible  =false
end

BattleTestSetData = {}
function BattleTestGenNewData()
    local UIBase_BattleTestSet = DRCSRef.FindGameObj("UIBase"):GetComponent("BattleTestSet")

    local retStream = {}
    retStream.iBattleTypeID = 1
    retStream.iNum = 0
    retStream.iAssistNum = 0
    retStream['akUnits'] = {}
    retStream['akUnitsTime'] = {}

    local friendsInfo = UIBase_BattleTestSet.battleData.friendsInfo
    local enemysInfo = UIBase_BattleTestSet.battleData.enemysInfo

    local unitIndex = 0
    

    for index = 0, friendsInfo.Length - 1 do
        unitInfo = friendsInfo[index]

        local typeID = unitInfo.roleTypeID
        if not typeID or not TB_Role[typeID] then
            typeID = 1000001260
        end

        local unitData = {
            uiTypeID = typeID,
            uiModleID = TB_Role[typeID].ArtID,
            uiUnitIndex = unitIndex + 1,
            iGridX = unitInfo.x,
            iGridY = unitInfo.y,
            iFace = unitInfo.face,
            eCamp = 1,
            iBuffNum = 0,
            iHP = 1000000,
            iMP = 1000000,
            iMAXHP = 1000000,
            iMAXMP = 1000000,
            iSkillNum = 0,
            iComboNum = 0,
        }

        retStream['akUnits'][unitIndex] = unitData
        retStream['akUnitsTime'][unitIndex] = {
            ['fOptNeedTime'] = 0,
            ['fMoveTime'] = 2,
        }
        retStream['akUnitsMartial'] = {
        }
        unitIndex = unitIndex + 1
        retStream.iNum = retStream.iNum + 1

        if index == 0 then
            BattleTestSetData.palyRoleData = { unitIndex = unitData.uiUnitIndex, x = unitData.iGridX, y = unitData.iGridY }
        end
    end

    BattleTestSetData.hitRoleDataList = {}
    for index = 0, enemysInfo.Length - 1 do
        unitInfo = enemysInfo[index]

        local typeID = unitInfo.roleTypeID
        if not typeID or not TB_Role[typeID] then
            typeID = 1000001260
        end

        local unitData = {
            uiTypeID = typeID,
            uiModleID = TB_Role[typeID].ArtID,
            uiUnitIndex = unitIndex + 1,
            iGridX = unitInfo.x,
            iGridY = unitInfo.y,
            iFace = unitInfo.face,
            eCamp = 2,
            iBuffNum = 0,
            iHP = 1000000,
            iMP = 1000000,
            iMAXHP = 1000000,
            iMAXMP = 1000000,
            iSkillNum = 0,
            iComboNum = 0,
        }

        retStream['akUnits'][unitIndex] = unitData
        retStream['akUnitsTime'][unitIndex] = {
            ['fOptNeedTime'] = 0,
            ['fMoveTime'] = 2,
        }
        unitIndex = unitIndex + 1
        retStream.iNum = retStream.iNum + 1

        table.insert(BattleTestSetData.hitRoleDataList, 
        { unitIndex = unitData.uiUnitIndex, x = unitData.iGridX, y = unitData.iGridY })
    end

    return retStream
end

function start()
    dprint("[Main]->BattleTest start")
    LOCAL_TB_SkillPerformance = TableDataManager:GetInstance():GetTable("SkillPerformance")
    LOCAL_TB_BuffPerformance = TableDataManager:GetInstance():GetTable("BuffPerformance")
    --OpenWindowImmediately("LoginUI")
    --OpenWindowImmediately("RoleEmbattleUI")

    local retStream = BattleTestGenNewData()
    LogicMain:GetInstance():StartBattle(retStream)
    -- DisplayBattleStart(retStream)
    -- WindowsManager:GetInstance()._rootObject2D:SetActive(false)
end

function update(deltaTime)
    deltaTime = deltaTime * 1000
    l_globalTimer:Update(deltaTime)
    l_windowsMgr:Update(deltaTime)

    l_TimeLineHelp:Update(deltaTime) -- 放在最后,所有逻辑跑完后再进行动画
    l_animationMgr:Update(deltaTime) -- 放在最后,所有逻辑跑完后再进行动画
end

function lateUpdate()
    l_windowsMgr:LateUpdate()
end

function ondestroy()
    WindowsManager:GetInstance():DestroyAll(nil,true)
    WindowsManager:GetInstance():ClearCheatButton()
    l_LogicMain:OnDestroy()
    l_LogicMain = nil
    UnLoadAll(true)
    dprint("[Main]->Game Ondestroy")
end

function BattleTestPlaySkill(palySkillData)
    if BattleTestSetData.palyRoleData and BattleTestSetData.hitRoleDataList then
        if palySkillData.sendFile ~= "" then
            local loadEffect = loadfile(palySkillData.sendFile)
            if loadEffect then
                local data = loadEffect()
                local dataID = data.id or 1
                LOCAL_TB_SkillPerformance[dataID] = data
            end
        end

        if palySkillData.isReplay then
            BattleTestHurtInfo(palySkillData,0)
        else
            BattleTestHurtInfo(palySkillData,palySkillData.trackTime)
        end
    end
end

function BattleTestPlayBuff(palySkillData)
    if BattleTestSetData.palyRoleData and BattleTestSetData.hitRoleDataList then
        if palySkillData.sendFile ~= "" then
            local loadEffect = loadfile(palySkillData.sendFile)
            if loadEffect then
                local data = loadEffect()
                local dataID = data.id or 1
                LOCAL_TB_BuffPerformance[dataID] = data
                -- BattleTestHurtInfo(palySkillData,0)
                local SeBattle_HurtInfo = {
                    ['iBuffNum'] = 1,
                    ['akBuffData'] = {
                        [0] = {
                            ['iOwnUnitIndex'] = 1,
                            ['iBuffTypeID'] = dataID,
                        }
                    }
                }
                BuffObjectManager:GetInstance():Clear()
                BuffObjectManager:GetInstance():ProcessHurtInfo(SeBattle_HurtInfo)
            end
        end

        -- if palySkillData.isReplay then
        --     BattleTestHurtInfo(palySkillData,0)
        -- else
        --     BattleTestHurtInfo(palySkillData,palySkillData.trackTime)
        -- end
    end
end
function BattleTestHurtInfo(palySkillData,trackTime)
    local skillTypeID = palySkillData.skillTypeID
    if not skillTypeID or not LOCAL_TB_SkillPerformance[skillTypeID] then
        return
    end
    
    dprint('BattleTestHurtInfo', skillTypeID,trackTime)

    local retStream = {
        ['iNum'] = 1,
        ['akBattleLog'] = {
            [0]={
            ['eEvent'] = 0,
            ['iOwnerUnitIndex'] = BattleTestSetData.palyRoleData.unitIndex,
            ['iSkillTypeID'] = skillTypeID,
            ['iOwnerMartialIndex'] = 10101,
            ['iMoveX'] = BattleTestSetData.palyRoleData.x,
            ['iMoveY'] = BattleTestSetData.palyRoleData.y,
            ['iCastPosX']= palySkillData.castX,
            ['iCastPosY'] = palySkillData.castY,
            ['iSpendMP'] = 100,
            ['iBuffNum'] = 0,
            ['akBuffData'] = {},
            ['iPlotNum'] = 0,
            ['akPlotData'] = {},
            ['eSkillEventType'] = 1,
            ['iHeJiTargetNum'] = 0,
            ['aiHeJiTargetUnit'] = {},
            ['iYuanHuNum'] = 0,
            ['aiYuanHuUnit'] = {},

            ['iSkillDamageData'] = 0,
            ['akSkillDamageData'] = { }
        }
    }}

    retStream.akBattleLog[0].iSkillDamageData = #BattleTestSetData.hitRoleDataList
    for index, hitRoleData in ipairs(BattleTestSetData.hitRoleDataList) do
        local itemDamageData = {
            ['iTargetUnitIndex'] = hitRoleData.unitIndex,
            ['iFinalDamageValue'] = 100,
            ['iFinalMPDamageValue'] = 0,
            ['iFinalHPAddValue'] = 0,
            ['iDuoDuanNum'] = palySkillData.iDuoDuanNum,
            ['aiFinalNumberAddValue'] = {100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100,100},
            ['iLeechValue'] = 0,
            ['iShieldValue'] = 0,
            ['iReboundDamageValue'] = 0,
            ['eSkillDataType'] = 1,
            ['eExtraFlag'] = 0,--SetFlag(0,BDEF_CRIT)  
            ['iJituiX'] = NO_VAILD_GRID_XY,
            ['iJituiY'] = NO_VAILD_GRID_XY,
            ['iYuanhuX'] = -1,
            ['iYuanhuY'] = -1,
            ['eSpecialFlag'] = 1,
        }
        retStream.akBattleLog[0].akSkillDamageData[index - 1] = itemDamageData
    end
    TimeLineHelper:GetInstance():Reset()
    if trackTime > 0 then 
        TimeLineHelper:GetInstance():SetCanUpdate(false)
        DRCSRef.Time.timeScale = 0
        TimeLineHelper:GetInstance():Reset()
        local dataSkill = LOCAL_TB_SkillPerformance[skillTypeID]
        if dataSkill.effectType and dataSkill.effectType == 4 then 
            for i=1,3 do
                if i == 1 then 
                    retStream.akBattleLog[i-1].iMutilTag = MutilAnqiTag.MT_START
                elseif i == 3 then
                    retStream.akBattleLog[i-1].iMutilTag = MutilAnqiTag.MT_END
                else
                    retStream.akBattleLog[i-1].iMutilTag = MutilAnqiTag.MT_CHILD
                end
                TimeLineHelper:GetInstance():GenTrackInfo(retStream.akBattleLog[0])
            end
        else
            TimeLineHelper:GetInstance():GenTrackInfo(retStream.akBattleLog[0])
        end
        TimeLineHelper:GetInstance():SetTime(trackTime)
    else
        TimeLineHelper:GetInstance():SetCanUpdate(true)
        PlayMode = 0
        DRCSRef.Time.timeScale = 1
        local dataSkill = LOCAL_TB_SkillPerformance[skillTypeID]
        if dataSkill.effectType and dataSkill.effectType == 4 then 
            for i=1,3 do
                if i == 1 then 
                    retStream.akBattleLog[0].iMutilTag = MutilAnqiTag.MT_START
                elseif i == 3 then
                    retStream.akBattleLog[0].iMutilTag = MutilAnqiTag.MT_END
                else
                    retStream.akBattleLog[0].iMutilTag = MutilAnqiTag.MT_CHILD
                end
                TimeLineHelper:GetInstance():GenTrackInfo(retStream.akBattleLog[0])
            end
        else
            TimeLineHelper:GetInstance():GenTrackInfo(retStream.akBattleLog[0])
        end
    end
end

function BattleTestPlaySkillByFile(file)
    DRCSRef.Log("BattleTestPlaySkillByFile",file)
    local loadEffect = loadfile(file)
    if loadEffect then
        local data = loadEffect()
        local dataID = data.id or 1
        LOCAL_TB_SkillPerformance[dataID] = data

        local palySkillData = {}
        palySkillData.skillTypeID = dataID
        BattleTestPlaySkill(palySkillData)
    end
end

function BattleTestResetUnits()
    local retStream = BattleTestGenNewData()

    UnitMgr:GetInstance():Clear()
    LogicMain:GetInstance():UpdateUnit(retStream)
end

function BattleTestHideUI()
    local root = DRCSRef.FindGameObj("UIBase")
    local obj = root.transform:Find("UILayerRoot").gameObject; 
    if obj == nil then return end
    if obj.activeSelf then 
        obj:SetActive(false)
    else
        obj:SetActive(true)
    end
end

function BattleTestShowGrid()
    local root = DRCSRef.FindGameObj("BattleField(Clone)")
    local obj = root.transform:Find("BattleGrid").gameObject; 
    if obj == nil then return end
    if obj.activeSelf then 
        obj:SetActive(false)
    else
        obj:SetActive(true)
    end
end