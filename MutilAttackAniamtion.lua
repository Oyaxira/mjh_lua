-- 近战多段攻击类技能动画处理
local BaseAnimation = require ("Animation/EffectType/BaseAnimation")
local MutilAttackAniamtion = class("MutilAttackAniamtion",BaseAnimation)

function MutilAttackAniamtion:ProcessAttackAnim(attackerUnit,skillEffectInfo,startTime)
    local attackerModleID = attackerUnit.uiModleID
    local actionInfo = nil
    if skillEffectInfo.actionInfo then 
        actionInfo = skillEffectInfo.actionInfo
        startTime = startTime + (actionInfo.delay or 0)
    end
    self.actionDelay = startTime
    local attackName = getAttackAction(attackerModleID,actionInfo)
    local actionTime = getActionFrameTime(attackerModleID,attackName)
    local switchFrameTime = getActionFrameTime(attackerModleID,attackName,'switch')
    if actionTime > 0 then 
        AddTrackUnitFunc(attackerUnit,startTime,'SetUnitAction',attackName,false,actionInfo)
    end
    self._lastActionTime = actionTime
    self._nextActionTime = startTime + switchFrameTime
    return startTime + getActionFrameTime(attackerModleID,attackName,'attack')
end

function MutilAttackAniamtion:processMutilAttack(SeBattle_HurtInfo)
    local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)

    local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end

    local iDuoduanNum = 0
    if SeBattle_HurtInfo.iSkillDamageData > 0 then 
        iDuoduanNum = SeBattle_HurtInfo.akSkillDamageData[0].iDuoDuanNum
    end
    local startTime = 0
    for i=1,iDuoduanNum do
        local index = i
        if index > #StaticSkillEffectData.skillEffect then 
            index = #StaticSkillEffectData.skillEffect
        end
        local skillEffectInfo = StaticSkillEffectData.skillEffect[index]
        self:processCastEffect(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,false,startTime)
        self:processSceneEffect(skillEffectInfo.sceneEffect,startTime)
        self:processAttackEffectAndWaitSwitch{
            ['attackerUnit'] = attackerUnit,
            ['skillEffectInfo'] = skillEffectInfo,
            ['SeBattle_HurtInfo'] = SeBattle_HurtInfo,
            ['boolean_nohurt'] = false,
            ['duoduanNum'] = i,
            ['startTime'] = startTime,
        }
        if i == iDuoduanNum then 
            AddTrackUnitFunc(attackerUnit,startTime+(self._lastActionTime or 0),'SetUnitIdleAction')
        else
            startTime = (self._nextActionTime or 0)
        end
    end
end

function MutilAttackAniamtion:GenTrackInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.eSkillEventType == BSET_Null then
        return 
    end
    self:processMutilAttack(SeBattle_HurtInfo)
end

return MutilAttackAniamtion