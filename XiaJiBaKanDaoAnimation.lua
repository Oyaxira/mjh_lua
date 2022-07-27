-- 夏济八砍刀法类技能动画处理
local BaseAnimation = require ("Animation/EffectType/BaseAnimation")
local XiaJiBaKanDaoAnimation = class("XiaJiBaKanDaoAnimation",BaseAnimation)


function XiaJiBaKanDaoAnimation:ProcessAttackAnim(attackerUnit,skillEffectInfo,startTime)
    local attackerModleID = attackerUnit.uiModleID
    local actionInfo = nil
    if skillEffectInfo.actionInfo then 
        actionInfo = skillEffectInfo.actionInfo
        startTime = startTime + (actionInfo.delay or 0)
    end
    self.actionDelay = startTime
    local animationName = getAttackAction(attackerModleID,actionInfo)
    local actionTime = getActionFrameTime(attackerModleID,animationName)
    local switchFrameTime = getActionFrameTime(attackerModleID,animationName,'switch')
    local attackFrameTime = getActionFrameTime(attackerModleID,animationName,'attack')
    if actionTime > 0 then 
        AddTrackUnitFunc(attackerUnit,startTime,'SetUnitAction',animationName,false,actionInfo)
        AddTrackUnitFunc(attackerUnit,startTime+attackFrameTime,'SetPose',animationName,attackFrameTime)
    end
    return startTime + attackFrameTime
end


function XiaJiBaKanDaoAnimation:GenTrackInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.eSkillEventType == BSET_Null then
        return 
    end
    l_unitMgr = UnitMgr:GetInstance()
    local attackerUnit = l_unitMgr:GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end
    local movex = SeBattle_HurtInfo.iMoveX+1
    local movey = SeBattle_HurtInfo.iMoveY+1
    local pos = GetPosByGrid(movex,movey)
    local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
    local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
    startTime = 0
    local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)
    local skillEffectInfo
    if StaticSkillEffectData and StaticSkillEffectData.skillEffect then 
        skillEffectInfo = StaticSkillEffectData.skillEffect[1]
        self:ProcessAttackAction(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,true,0)
    end
    attackerUnit:SetCanyinSkill(SeBattle_HurtInfo.iSkillTypeID)
    startTime = startTime + (self.actionDelay or 0)
    local last_time = startTime
    local delay_time = 300

    local sameTargetTimes = 0
    local lastTargetPos = nil
    for i=1,Se_targetsNum do
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        local l_startTime = 0
        if targetUnit then
            local flag = Se_targetInfo.eSpecialFlag or (i-1)
            if flag < 100 then 
                l_startTime = startTime + flag * delay_time
            else
                l_startTime = startTime + (flag-100) * delay_time
            end
            if flag < 100 then 
                ---- 计算残影位置（多次攻击同目标）开始 ----
                local endPos = nil
                local lastTarget = nil
                local nextTarget = nil
                if Se_targetsInfo[i-2] then
                    lastTarget = l_unitMgr:GetUnit(Se_targetsInfo[i-2].iTargetUnitIndex)
                end
                if Se_targetsInfo[i] then
                    nextTarget = l_unitMgr:GetUnit(Se_targetsInfo[i].iTargetUnitIndex)
                end
                if (lastTarget and lastTarget:GetUnitIndex() == targetUnit:GetUnitIndex()) or
                (nextTarget and nextTarget:GetUnitIndex() == targetUnit:GetUnitIndex()) then
                    endPos = targetUnit.transform.localPosition
                    lastPos = lastTargetPos or attackerUnit.transform.localPosition

                    -- 移动距离（1格距离为130）
                    local length = 130 * 0.01
                    -- 经过目标点的高度差（等同于夹角），此参数很重要，当移动距离很远都能做到经过目标点
                    local height = 100 * 0.01

                    local diffVec = (lastPos - endPos)
                    local minVec = nil
                    local maxVec = nil
                    local minY = nil
                    local maxY = nil
                    if math.abs(diffVec.x) > math.abs(diffVec.y) then
                        if diffVec.y == 0 then
                            minY = -height
                            maxY = height
                        elseif diffVec.y > 0 then
                            minY = -height
                            maxY = 0
                        else
                            minY = 0
                            maxY = height
                        end
                        minVec = (DRCSRef.Vec3(endPos.x, endPos.y + minY, endPos.z) - lastPos).normalized * length
                        maxVec = (DRCSRef.Vec3(endPos.x, endPos.y + maxY, endPos.z) - lastPos).normalized * length
                    else
                        if diffVec.x == 0 then
                            minX = -height
                            maxX = height
                        elseif diffVec.x > 0 then
                            minX = -height
                            maxX = 0
                        else
                            minX = 0
                            maxX = height
                        end

                        minVec = (DRCSRef.Vec3(endPos.y + minX, endPos.x, endPos.y) - lastPos).normalized * length
                        maxVec = (DRCSRef.Vec3(endPos.y + maxX, endPos.x, endPos.y) - lastPos).normalized * length
                    end

                    endPos.x = endPos.x + (minVec.x + math.random() * (maxVec.x - minVec.x))
                    endPos.y = endPos.y + (minVec.y + math.random() * (maxVec.y - minVec.y))
                    lastTargetPos = endPos
                else
                    lastTargetPos = nil
                    sameTargetTimes = 0
                end
                ---- 计算残影位置（多次攻击同目标）结束 ----

                AddTrackLambda(l_startTime,function()
                    local index = targetUnit:GetUnitIndex()
                    attackerUnit.kEffectMgr:addCanYing(attackerUnit,targetUnit,endPos,StaticSkillEffectData.canying,false)
                    -- AddTrackTweener(twn,startTime)
                end)
            end
            self:processHurtEffectSub({
                ['attackerUnit'] = attackerUnit,
                ['targetUnit'] = targetUnit,
                ['Se_targetInfo'] = Se_targetInfo,
                ['skillEffectInfo'] = skillEffectInfo,
                ['SeBattle_HurtInfo'] = SeBattle_HurtInfo,
                ['index'] = i,
                ['duoduanNum'] = 0,
                ['startTime'] = l_startTime,
            })
            last_time = math.max(l_startTime,last_time)
        end
    end
    startTime = last_time + delay_time
    if attackerUnit then
        -- AddTrackTweener(twn,startTime)
        AddTrackLambda(startTime,function()
            attackerUnit.kEffectMgr:addCanYing(attackerUnit,nil,pos,StaticSkillEffectData.canying,true)
        end)
    end
    AddTrackUnitFunc(attackerUnit,startTime+100,'SetTimeScale',1)
    AddTrackUnitFunc(attackerUnit,startTime+100+SPEND_TIME_CANYING,'SetUnitIdleAction')


end

return XiaJiBaKanDaoAnimation