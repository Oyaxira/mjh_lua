-- 近战多段攻击类技能动画处理
local BaseAnimation = require ("Animation/EffectType/BaseAnimation")
local AnqiAnimation = class("AnqiAnimation",BaseAnimation)
function AnqiAnimation:SetStartTime(int_startTime)
    self._StartTime = int_startTime
end

function AnqiAnimation:_processFeidanType(StaticSkillEffectData,effectObject,worldX,worldY,int_time,startTime)
    local feidanType = StaticSkillEffectData.feidanType
    if feidanType == 3 then -- 小乔飞弹 曲线
        local feidanTrackInfo = StaticSkillEffectData.feidanTrackInfo
        local stayTime = 0
        local fadeoutTime = 0
        local high = 2
        local width = 3
        if feidanTrackInfo then 
            stayTime = feidanTrackInfo.stayTime or stayTime
            fadeoutTime = feidanTrackInfo.fadeoutTime or fadeoutTime
            high = feidanTrackInfo.high or high
            width = feidanTrackInfo.width or width
        end
        AddTrackLambda(startTime,function()
            local lineEffect = CreateLineEffect(effectObject.gameObject,int_time,stayTime,fadeoutTime,2,20)
            lineEffect:SetBeginPos(effectObject:GetPositionX(),effectObject:GetPositionY(),effectObject:GetPositionZ())
            lineEffect:SetEndPos(worldX,worldY,effectObject:GetPositionZ())
            lineEffect:SetRadianPos((effectObject:GetPositionX() + worldX) / width, high + 2,effectObject:GetPositionZ())
            lineEffect:StartDraw()
        end)
        return startTime + (int_time + stayTime + fadeoutTime) * 1000
    elseif feidanType == 4 then -- 六脉神剑气 激光
        local feidanTrackInfo = StaticSkillEffectData.feidanTrackInfo
        local stayTime = 0
        local fadeoutTime = 0
        if feidanTrackInfo then 
            stayTime = feidanTrackInfo.stayTime or stayTime
            fadeoutTime = feidanTrackInfo.fadeoutTime or fadeoutTime
        end
        AddTrackLambda(startTime,function()
            local lineEffect = CreateLineEffect(effectObject.gameObject,int_time,stayTime,fadeoutTime,0,0)
            lineEffect:SetBeginPos(effectObject:GetPositionX(),effectObject:GetPositionY(),effectObject:GetPositionZ())
            lineEffect:SetEndPos(worldX,worldY,effectObject:GetPositionZ())
            lineEffect:StartDraw()
        end)
        return startTime + (int_time + stayTime + fadeoutTime) * 1000
    else
        local tweenerX,tweenerY = effectObject:MoveXY(worldX,worldY,int_time)
        AddTrackTweener(tweenerX,startTime,int_time*1000)
        AddTrackTweener(tweenerY,startTime,int_time*1000)
        return startTime + int_time*1000
    end
end

function AnqiAnimation:processAnqiOneLineInfo(info)
    local roleLine = info.roleLine
    local attackerUnit = info.attackerUnit
    local StaticSkillEffectData = info.StaticSkillEffectData
    local Se_targetsInfo = info.Se_targetsInfo
    local skillEffectInfo = info.skillEffectInfo
    local emptyY = info.emptyY
    local sortingLayer = info.sortingLayer
    local startX,startY,startZ = info.startX,info.startY,info.startZ
    local face = info.face
    local endX = info.endX
    local endY = info.endY 

    local prefabPath = StaticSkillEffectData['feidanPrefabPath']
    if prefabPath == nil then
        prefabPath = "Effect/Eff/com/gj_anqi"
    end
    local animName = StaticSkillEffectData['feidanPrefabAnim']
    local erase = StaticSkillEffectData['feidanEase'] or 0

    startTime = (self._StartTime or 0) + (self._attackFrameTrigTime or 0)
    l_unitMgr = UnitMgr:GetInstance()  
    -- 新起一个

    local effectObject = AddPrefabToWorldPos(prefabPath,startX,startY,startZ,sortingLayer)
    if effectObject == nil then return end
    if face == 1 then
        startX = startX + 0.5
    else
        startX = startX - 0.5
    end
    AddObjTrack(effectObject,startTime,nil,animName or "animation",true)
    local oldUnit = attackerUnit
    local appendList = {}
    local oldX = startX
    local oldY = startY
    local oldGridX = attackerUnit.iGridX
    local oldGridY = attackerUnit.iGridY
    local counts = 5
    local speedParam = StaticSkillEffectData["speed"]
    if speedParam == nil or speedParam == 0 then 
        speedParam = 1
    end
    local speedParam = speedParam * 5 
    if roleLine then 
        for j=1,#roleLine do
            local Se_targetInfo = Se_targetsInfo[roleLine[j]-1]
            local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
            if targetUnit == nil then return end
            local worldX,worldY = targetUnit:GetXYByMountName(SKILL_EFFECT_MOUNT_NAME.ANQI_CASE_POS,nil,false)
            local int_time = DRCSRef.Mathf.Sqrt((oldX - worldX) * (oldX - worldX) + (oldY - worldY) * (oldY - worldY)) / speedParam;

            local rotate = 0

            -- 垂直
            if oldGridY == targetUnit.iGridY then 
                if oldGridX > targetUnit.iGridX then 
                    rotate = 180
                else
                    rotate = 0
                end
            elseif oldGridX == targetUnit.iGridX then 
                if oldGridY > targetUnit.iGridY then 
                    rotate = -90
                else
                    rotate = 90
                end
            else
                rotate = DRCSRef.Mathf.Atan2(worldY - oldY,worldX - oldX) / math.pi * 180
            end


            AddTrackLambda(startTime,function()
                       effectObject:SetRotate(rotate)
                   end)
            startTime = self:_processFeidanType(StaticSkillEffectData,effectObject,worldX,worldY,int_time,startTime)
            oldGridX = targetUnit.iGridX 
            oldGridY = targetUnit.iGridY 
            oldX = worldX
            oldY = worldY
            if skillEffectInfo then 
                self:processSceneEffect(skillEffectInfo.sceneEffect,startTime,true)
            end
            self:processHurtEffectSub({
                ['attackerUnit'] = attackerUnit,
                ['targetUnit'] = targetUnit,
                ['Se_targetInfo'] = Se_targetInfo,
                ['skillEffectInfo'] = skillEffectInfo,
                ['index'] = j,
                ['startTime'] = startTime,
                ['rotate'] = rotate,
            })
            oldUnit = roleLine[j]
        end
    end
    if endX then 
        if roleLine == nil then 
            if endX < oldX then 
                AddTrackLambda(startTime,function()
                    effectObject:SetRotate(180)
                end)
            end
        end
        local int_time = math.abs(oldX - endX)  / (speedParam)
        local tweenerX,tweenerY = effectObject:MoveXY(endX,endY or oldY,int_time)
        tweenerX:SetEase(easings[erase])
        AddTrackTweener(tweenerX,startTime,int_time*1000)
        AddTrackTweener(tweenerY,startTime,int_time*1000)
        startTime = startTime + int_time*1000
    end
    
    AddTrackUnitFunc(effectObject,startTime,"SetActive",false)
end

function AnqiAnimation:processAnqiOneLine(roleLine,attackerUnit,StaticSkillEffectData,Se_targetsInfo,skillEffectInfo,emptyY)
    if attackerUnit == nil then return end
    local startX,startY,startZ = attackerUnit:GetXYByMountName(SKILL_EFFECT_MOUNT_NAME.ANQI_CASE_POS,nil,false)
    local sortingLayer = getOrderLayerByDepth(SKILL_EFFECT_DEPTH.ON_CURROLE_UP,attackerUnit)
    local face = attackerUnit.iFace
    self:processAnqiOneLineInfo({
        ['roleLine'] = roleLine,
        ['attackerUnit'] = attackerUnit,
        ['StaticSkillEffectData'] = StaticSkillEffectData,
        ['Se_targetsInfo'] = Se_targetsInfo,
        ['skillEffectInfo'] = skillEffectInfo,
        ['startX'] = startX,
        ['startY'] = startY,
        ['startZ'] = startZ,
        ['sortingLayer'] = sortingLayer,
        ['face'] = face,
        ['normal'] = true,
    })
end


function AnqiAnimation:processAnqiEffectAndWaitSwitch(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,StaticSkillEffectData)
    l_unitMgr = UnitMgr:GetInstance()  
    -- 筛出主要目标
    local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
    local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData

    local aiDamagePos = attackerUnit:GetMartialDamagePos(SeBattle_HurtInfo.iOwnerMartialIndex)
    local emptyLine = {}
    for i=1,#aiDamagePos do
        local x = aiDamagePos[i][1] + SeBattle_HurtInfo.iCastPosX+1
        local y = aiDamagePos[i][2] + SeBattle_HurtInfo.iCastPosY+1
        table.insert(emptyLine,{x,y})
    end
    
    local firstUnit
    local bFantan = false
    prefabPath = prefabPath or "SkillEffect/ef_anqi_fei1dao1"
    local effectObject = nil
    local roleList = {}
    local roleLine
    for i=1,Se_targetsNum do
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        if targetUnit then
            local boolean_fantan = HasFlag(Se_targetInfo.eExtraFlag,BDEF_TANSHE)
            if boolean_fantan then 
                -- 反弹
                if roleLine then 
                    roleLine[#roleLine+1] = i
                end
            elseif firstUnit and targetUnit.iGridY == firstUnit.iGridY then 
                -- 穿透
                if roleLine then 
                    roleLine[#roleLine+1] = i
                end
            else
                -- 另一行
                firstUnit = targetUnit
                if roleLine then 
                    roleList[#roleList+1] = roleLine
                end
                roleLine = {i}
                for i=1,#emptyLine do
                    if emptyLine[i][2] == targetUnit.iGridY then
                        table.remove(emptyLine,i)
                        break
                    end
                end
            end
        end
    end
    roleList[#roleList+1] = roleLine
    for i=1,#roleList do
        self:processAnqiOneLine(roleList[i],attackerUnit,StaticSkillEffectData,Se_targetsInfo,skillEffectInfo)
    end
    for i=1,#emptyLine do
        if IsInBattleGrid(emptyLine[i][1],emptyLine[i][2]) then
            self:processAnqiOneLine(nil,attackerUnit,StaticSkillEffectData,Se_targetsInfo,skillEffectInfo,GetPosByGrid(emptyLine[i][1],emptyLine[i][2]).y)
        end
    end
end

function AnqiAnimation:GenTrackInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.eSkillEventType == BSET_Null then
        return 
    end
    local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end
    local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)
    if StaticSkillEffectData then
        if StaticSkillEffectData.skillEffect then 
            for i=1,#StaticSkillEffectData.skillEffect do
                local skillEffectInfo = StaticSkillEffectData.skillEffect[i]
                self:ProcessAttackAction(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,true,0)
                if i == 1 then 
                    self:processAnqiEffectAndWaitSwitch(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,StaticSkillEffectData)
                end
            end
        else
            self:processAnqiEffectAndWaitSwitch(attackerUnit,nil,SeBattle_HurtInfo,StaticSkillEffectData)
        end
    end
end

return AnqiAnimation