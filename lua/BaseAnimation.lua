-- 基础技能特效处理
local BaseAnimation = class("BaseAnimation")

-- 在单位上显示技能名称
function BaseAnimation:ShowSkillName(attackerUnit,iSkillTypeID,eSkillEventType)
    local skillTypeData = TableDataManager:GetInstance():GetTableData("Skill", iSkillTypeID)
    if attackerUnit and skillTypeData then
        local prefix = ""
        if eSkillEventType and eSkillEventType ~= BSET_ZhuDong then 
            prefix = GetLanguageByID(SKILL_CAST_REASON[eSkillEventType]) .. ":"
        end
        AddTrackUnitFunc(attackerUnit,0,"ShowSkillName",prefix .. GetLanguageByID(skillTypeData.NameID))
        attackerUnit:PlayAttackAudio(skillTypeData)
    end
end

-- 判读是否需要处理公共显示部分
function BaseAnimation:NoProcessCommon(SeBattle_HurtInfo)
    local bIsNotSkill = SeBattle_HurtInfo.iSkillTypeID == 0
    local bNoMartial = SeBattle_HurtInfo.iOwnerMartialIndex == 0
    local bNoCastType = SeBattle_HurtInfo.eSkillEventType == BSET_Null
    -- local bNoCastType_special = SeBattle_HurtInfo.eSkillEventType == BSET_BeiDong_wuyue
    if bIsNotSkill or bNoMartial or bNoCastType then 
        return true
    end
    return false
end

function BaseAnimation:GenTrackInfo_Common_Death(SeBattle_HurtInfo)
    if SeBattle_HurtInfo and SeBattle_HurtInfo.bDeath and SeBattle_HurtInfo.bDeath > 0 then 
        local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
        if attackerUnit and not attackerUnit:IsDeath() then 
            LogicMain:GetInstance():LockQuitBattle()
            attackerUnit:SetDeath(true)
            attackerUnit:PlayDeathAudio()
            if attackerUnit.kUnitLifeBar then 
                --头顶血条
                local twn = attackerUnit.kUnitLifeBar:FadeOut(1.5,true)
                FadeInOutShaps(attackerUnit.gameObject,1.5,true)
            end
            -- 使用定时器，防止卡死
            LogicMain:GetInstance():AddTimer(1600, function()
                attackerUnit:SetActive(false)
                LogicMain:GetInstance():ReleaseQuitBattle()
            end)
        end
    end
end

function BaseAnimation:GenTrackInfo_Common_Summon(SeBattle_HurtInfo)
    if SeBattle_HurtInfo and SeBattle_HurtInfo.iCallDiscipleIndex and SeBattle_HurtInfo.iCallDiscipleIndex > 0 then 
        local kUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iCallDiscipleIndex)
        if kUnit == nil then
            LogicMain:GetInstance():CreateOneUnit(SeBattle_HurtInfo.iCallDiscipleIndex,startTime)
        end
    end     
end

function BaseAnimation:GenTrackInfo_Common_SkillInfo(SeBattle_HurtInfo,attackerUnit)
    if attackerUnit == nil then return end
    if attackerUnit:CanControl() and SeBattle_HurtInfo.eSkillEventType == BSET_ZhuDong then
        AddTrackUnitFunc(attackerUnit,0,"ShowComboUI")
    else 
        AddTrackUnitFunc(attackerUnit,0,"ShowComboUI",{})
    end

    self:ShowSkillName(attackerUnit,SeBattle_HurtInfo.iSkillTypeID,SeBattle_HurtInfo.eSkillEventType)

    attackerUnit:SetMP(attackerUnit:GetMP()-SeBattle_HurtInfo.iSpendMP) 
end

-- 通用技能显示处理，包括：更新boss信息，显示回合回血，更新combo，显示技能名称，设置朝向，死亡动画
function BaseAnimation:GenTrackInfo_Common(SeBattle_HurtInfo)
    if not SeBattle_HurtInfo.iSkillTypeID then 
        return 
    end
    -- 播放死亡动画
    self:GenTrackInfo_Common_Death(SeBattle_HurtInfo)
    -- 召唤弟子
    self:GenTrackInfo_Common_Summon(SeBattle_HurtInfo)

    if self:NoProcessCommon(SeBattle_HurtInfo) then 
        return 
    end

    self.startTime = 0
    local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end
    self:GenTrackInfo_Common_SkillInfo(SeBattle_HurtInfo,attackerUnit)

    if SeBattle_HurtInfo.iMoveX ~= -1 and SeBattle_HurtInfo.iMoveY ~= -1 then 
        attackerUnit:SetPos(SeBattle_HurtInfo.iMoveX+1,SeBattle_HurtInfo.iMoveY+1, nil, nil, SeBattle_HurtInfo.eSkillEventType == BSET_HeJiQiDong,0)
    end

    attackerUnit:FaceToPos(SeBattle_HurtInfo.iCastPosX+1)
end

-- 全屏特效
function BaseAnimation:processSceneEffect(sceneEffect,startTime,isHurt,SeBattle_HurtInfo)

    startTime = startTime or 0
    if sceneEffect then
        for i=1,#sceneEffect do
            if sceneEffect[i] then
                if (isHurt and sceneEffect[i].onHurt) or (isHurt ~= true and sceneEffect[i].onHurt~=true) then 
                    ProcessScene(sceneEffect[i].effect,SeBattle_HurtInfo,startTime)
                end
            end
        end
    end
end



-- unit:施放单位,skillCastInfo:释法信息,SeBattle_HurtInfo:伤害信息
function BaseAnimation:processCastEffectSub(unit,skillCastInfo,SeBattle_HurtInfo,startTime,hurtFilpX,isHurt,rotate)
    if skillCastInfo == nil then return end
    startTime = startTime + (skillCastInfo.delay or 0)

    local prefabPath = skillCastInfo.prefabPath
    if prefabPath == nil then return end
    local animName = skillCastInfo.prefabAnim
    local mount1Name = skillCastInfo.mount1Name 
    if skillCastInfo.fullScreen then 
        mount1Name = SKILL_EFFECT_MOUNT_NAME.SCREEN_CENTER
    end
    local mount2Name = skillCastInfo.mount2Name or SPINE_BONE_NAME_DEFALUT
    local isOnRole = skillCastInfo.noOnRole or false
    local isOnFloor = skillCastInfo.onFloor or false
    local effectObject
    local boolean_flipX = false 
    if not skillCastInfo.noFlipX then 
        if hurtFilpX ~= nil then 
            boolean_flipX = hurtFilpX 
        else
            boolean_flipX = unit.iFace == -1
        end
    end 
    local parent = unit:GetSpineNode()
    
    local sortingLayer = getOrderLayerByDepth(skillCastInfo.depth,unit,skillCastInfo.layerValue)

    if isOnFloor then 
        mount2Name = "root"
    end
    local worldX,worldY,worldZ = unit:GetXYByMountName(mount1Name,mount2Name,isOnRole,SeBattle_HurtInfo)
    local offsetX = skillCastInfo.offsetX or 0
    local offsetY = skillCastInfo.offsetY or 0
    if boolean_flipX then 
        offsetX = -offsetX
        -- offsetY = -offsetY
    end
    worldX = worldX + offsetX
    worldY = worldY + offsetY
    if isOnRole then 
        effectObject = AddPrefabToSpinePos(prefabPath,worldX,worldY,worldZ,mount2Name,sortingLayer,parent)
        if effectObject == nil then return end
        -- 对旧动画的特殊处理，缩小0.5倍
        effectObject:Scale(skillCastInfo.scale)
        
    else
        effectObject = AddPrefabToWorldPos(prefabPath,worldX,worldY,worldZ,sortingLayer)
        -- if isHurt then 
            if effectObject == nil then return end
            effectObject:Scale(skillCastInfo.scale)
        -- end
    end
    if rotate then 
        effectObject:SetRotate(rotate)
    elseif boolean_flipX then 
        effectObject:FlipX()
    end
    local waitTime = effectObject:GetPlayTime(animName)
    AddObjTrack(effectObject,startTime,waitTime,animName)
    if skillCastInfo.audio then 
        AddTrackSound(startTime,skillCastInfo.audio)
    end
end

-- 播放施法特效上层接口
function BaseAnimation:processCastEffect(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,isHurt,startTime)
    startTime = startTime or 0
    if skillEffectInfo and skillEffectInfo.castEffect then 
        for j=1,#skillEffectInfo.castEffect do
            local skillCastInfo = skillEffectInfo.castEffect[j]
            if (isHurt and skillCastInfo.onHurt) or (isHurt ~= true and skillCastInfo.onHurt~=true) then 
                self:processCastEffectSub(attackerUnit,skillCastInfo,SeBattle_HurtInfo,startTime)
            end
        end
    end
end

-- 播放miss闪避动作
-- attackerUnit：攻击者，targetUnit：受击者
function BaseAnimation:processMissEffect(attackerUnit,targetUnit,startTime)
    local attackX = GetPosByGrid(attackerUnit.iGridX,attackerUnit.iGridY).x
    local originX = GetPosByGrid(targetUnit.iGridX,targetUnit.iGridY).x
    local offsetX = 0.3
    local moveTime = 0.2
    if attackX > originX or (attackX == originX and targetUnit.iFace == -1) then 
        offsetX = -offsetX      
    end
    local disX = originX + offsetX
    AddTrackUnitFunc(targetUnit,startTime,"ShowSpecialFont",nil,'sb')
    AddTrackTweener(targetUnit.transform:DOLocalMoveX(disX,moveTime),startTime,moveTime)
    AddTrackTweener(targetUnit.transform:DOLocalMoveX(originX,moveTime),startTime + moveTime*1000 + 200,moveTime)
end

--[[
{
    attackerUnit = attackerUnit
    targetUnit = targetUnit
    Se_targetInfo = Se_targetInfo
    skillEffectInfo = skillEffectInfo
    SeBattle_HurtInfo = SeBattle_HurtInfo
    index = index
    duoduanNum = duoduanNum
    startTime = startTime
}
]]
function BaseAnimation:processHurtEffectSub(info)
    local attackerUnit = info.attackerUnit
    local targetUnit = info.targetUnit
    local Se_targetInfo = info.Se_targetInfo
    local skillEffectInfo = info.skillEffectInfo
    local SeBattle_HurtInfo = info.SeBattle_HurtInfo
    local index = info.index
    local duoduanNum = info.duoduanNum or 0
    local startTime = info.startTime
    local rotate = info.rotate

    if targetUnit == nil then return end
    local boolean_miss = HasFlag(Se_targetInfo.eExtraFlag,BDEF_MISS)
    if Se_targetInfo.iYuanhuX ~= -1 and Se_targetInfo.iYuanhuY ~= -1 then 
        targetUnit:MoveInter(Se_targetInfo.iYuanhuX+1,Se_targetInfo.iYuanhuY+1,startTime)
    end
    if boolean_miss then 
        self:processMissEffect(attackerUnit,targetUnit,startTime)
    else
        local iFinalDamageValue = -1
        if duoduanNum and duoduanNum > 0 then 
            iFinalDamageValue = Se_targetInfo.aiFinalNumberAddValue[duoduanNum-1]
        else
            iFinalDamageValue = Se_targetInfo.iFinalDamageValue
        end
        if iFinalDamageValue and iFinalDamageValue >= 0 then 
            if iFinalDamageValue and iFinalDamageValue > 0 then 
                -- 播放受击音效
                targetUnit:PlayHurtAudio(startTime)
            end

            AddTrackUnitFunc(targetUnit,startTime,"ShowNumber",iFinalDamageValue,nil,nil,Se_targetInfo.eExtraFlag)
            AddTrackUnitFunc(targetUnit,startTime,"MakeDemage",iFinalDamageValue)
        end
        local iFinalMPDamageValue = Se_targetInfo.iFinalMPDamageValue
        if duoduanNum < 2 and iFinalMPDamageValue then
            AddTrackUnitFunc(targetUnit,startTime,"AddMP",-iFinalMPDamageValue)
            AddTrackUnitFunc(targetUnit,startTime,"ShowNumber",-iFinalMPDamageValue,COLOR_BATTLE_ZHENQI,false)
        end

        if Se_targetInfo.iFinalHPAddValue > 0 then 
            AddTrackUnitFunc(targetUnit,startTime,"ShowNumber",Se_targetInfo.iFinalHPAddValue,COLOR_BATTLE_LIFE,true,Se_targetInfo.eExtraFlag)
            AddTrackUnitFunc(targetUnit,startTime,"AddHP",Se_targetInfo.iFinalHPAddValue)
        end

        if Se_targetInfo.iLeechValue > 0 then 
            AddTrackUnitFunc(attackerUnit,startTime,"ShowNumber",Se_targetInfo.iLeechValue,COLOR_BATTLE_LIFE,true,Se_targetInfo.eExtraFlag)
            AddTrackUnitFunc(attackerUnit,startTime,"AddHP",Se_targetInfo.iLeechValue)
            AddTrackUnitFunc(attackerUnit,startTime,"ShowSpecialFont",nil,'xx')
        end

        if (duoduanNum == nil or duoduanNum == 1 ) and Se_targetInfo.iReboundDamageValue > 0 then 
            AddTrackUnitFunc(attackerUnit,startTime,"ShowNumber",Se_targetInfo.iReboundDamageValue,nil,nil,Se_targetInfo.eExtraFlag)
            AddTrackUnitFunc(attackerUnit,startTime,"MakeDemage",Se_targetInfo.iReboundDamageValue)
            AddTrackUnitFunc(attackerUnit,startTime,"ShowSpecialFont",SetFlag(1 , BDEF_REBOUND))
        end

        if skillEffectInfo and attackerUnit ~= targetUnit then 
            local string_actionName = skillEffectInfo.hurtAnimation or "injured"
            local actionTime = getActionFrameTime(targetUnit.uiModleID,string_actionName)
            if string_actionName == "prepare" then actionTime = 0 end
            AddTrackUnitFunc(targetUnit,startTime,'DirPlayAnim',string_actionName,false)
            AddTrackUnitFunc(targetUnit,startTime+actionTime,'SetUnitIdleAction')
            AddTrackUnitFunc(targetUnit,startTime,"ShowSpecialFont",ClrFlag(Se_targetInfo.eExtraFlag,BDEF_REBOUND))
        end

       

        if skillEffectInfo and skillEffectInfo.hurtEffect then
            
            for i=1,#skillEffectInfo.hurtEffect do
                local hurtEffectInfo = skillEffectInfo.hurtEffect[i]
                if (hurtEffectInfo.onlyOnce and index == 1) or (not hurtEffectInfo.onlyOnce) then 
                    self:processCastEffectSub(targetUnit,hurtEffectInfo,SeBattle_HurtInfo,startTime,attackerUnit.iGridX > targetUnit.iGridX,true,rotate)
                end
            end
        end
        if Se_targetInfo.iJituiX ~= NO_VAILD_GRID_XY and Se_targetInfo.iJituiY ~= NO_VAILD_GRID_XY then 
            targetUnit:SetPos(Se_targetInfo.iJituiX+1,Se_targetInfo.iJituiY+1,nil,true,false,startTime)
        end
    end
    if Se_targetInfo.iYuanhuX ~= -1 and Se_targetInfo.iYuanhuY ~= -1 then 
        targetUnit:MoveInter(targetUnit.iGridX,targetUnit.iGridY,startTime+1000)
    end

    if Se_targetInfo.iAddPassTime and Se_targetInfo.iAddPassTime ~= 0 then 
        AddTrackLambda(startTime, function()
            local node = GetUIWindow("BattleUI")
            if node then 
                node:UpdateRepelMoveIcon(targetUnit:GetUnitIndex(),Se_targetInfo.iAddPassTime/100)
            end
        end)
    end

end

function MoveObject(startTime,prefabPath,startX,startY,endX,endY,speedParam)
    speedParam = speedParam or 10
    prefabPath = prefabPath or "Effect/Eff/com/gj_anqi"
    local effectObject = AddPrefabToWorldPos(prefabPath,startX,startY,startZ,10000)
    local int_time = math.sqrt((endX - startX) * (endX - startX) + (endY - startY) * (endY - startY)) / speedParam
    local tweenerX,tweenerY = effectObject:MoveXY(endX,endY,int_time)
    AddTrackTweener(tweenerX,startTime,int_time*1000)
    AddTrackTweener(tweenerY,startTime,int_time*1000)
end

function BaseAnimation:processHurtEffect(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,duoduanNum,startTime)
    startTime = startTime or 0
    l_unitMgr = UnitMgr:GetInstance()  
    local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData or 0
    local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
    startTime = startTime + (skillEffectInfo and skillEffectInfo.hurtAnimationDelayTime or 0)
    self:processCastEffect(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,true,startTime)
    if skillEffectInfo then 
        self:processSceneEffect(skillEffectInfo.sceneEffect,startTime,true,SeBattle_HurtInfo)
    end

    local left = 0
    local right = 0
    for i=1,Se_targetsNum do
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        local isSameCamp = targetUnit and targetUnit:IsSameCamp(attackerUnit.iCamp)
        if not isSameCamp then 
            if targetUnit and targetUnit.iGridX > attackerUnit.iGridX then 
                right = right + 1
            elseif targetUnit and targetUnit.iGridX < attackerUnit.iGridX then 
                left = left + 1
            end
        end
    end
    if left > right then 
        attackerUnit:FaceToPos(attackerUnit.iGridX - 1)
    elseif left < right then 
        attackerUnit:FaceToPos(attackerUnit.iGridX + 1)
    end

    -- 处理宠物技能动画
    if SeBattle_HurtInfo.iPetNum and SeBattle_HurtInfo.iPetNum > 0 then 
        for i=0,SeBattle_HurtInfo.iPetNum-1,1 do
            -- 获取宠物
            local targetPet = UnitMgr:GetInstance():GetUnitAssist(SeBattle_HurtInfo.aiPetID[i],attackerUnit:GetCamp())
            -- 播放动作
            if targetPet then 
                targetPet:SetUnitAction("attack")
                local startX,startY = getXYByMountName(nil,"root",targetPet.gameObject,false)
                for i=1,Se_targetsNum do
                    local Se_targetInfo = Se_targetsInfo[i-1]
                    local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
                    local worldX,worldY = targetUnit:GetXYByMountName(nil,"root",false)
                    MoveObject(startTime,nil,startX,startY,worldX,worldY)
                end            
            end
            -- 播放动画
            -- 获取宠物位置
            -- 获取目标位置
            -- 创建object
            -- 移动过去
        end
    end


    for i=1,Se_targetsNum do
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        
        self:processHurtEffectSub({
            ['attackerUnit'] = attackerUnit,
            ['targetUnit'] = targetUnit,
            ['Se_targetInfo'] = Se_targetInfo,
            ['skillEffectInfo'] = skillEffectInfo,
            ['SeBattle_HurtInfo'] = SeBattle_HurtInfo,
            ['index'] = i,
            ['duoduanNum'] = duoduanNum,
            ['startTime'] = startTime,
        })
    end
    
end

function BaseAnimation:ProcessAttackAnim(attackerUnit,skillEffectInfo,startTime)
    local attackerModleID = attackerUnit.uiModleID
    local actionInfo = nil
    if skillEffectInfo.actionInfo then 
        actionInfo = skillEffectInfo.actionInfo
        startTime = startTime + (actionInfo.delay or 0)
    else
        return startTime
    end
    self.actionDelay = startTime
    local attackName = getAttackAction(attackerModleID,actionInfo)
    local actionTime = getActionFrameTime(attackerModleID,attackName) / attackerUnit:GetTimeScale()
    local switchFrameTime = getActionFrameTime(attackerModleID,attackName,'switch')
    if actionTime > 0 then 
        AddTrackUnitFunc(attackerUnit,startTime,'SetUnitAction',attackName,false,actionInfo)
        AddTrackUnitFunc(attackerUnit,startTime+actionTime,'SetUnitIdleAction')
    end
    return startTime + getActionFrameTime(attackerModleID,attackName,'attack') / attackerUnit:GetTimeScale()
end

--[[
{
    attackerUnit = attackerUnit
    skillEffectInfo = skillEffectInfo
    SeBattle_HurtInfo = SeBattle_HurtInfo
    boolean_nohurt = boolean_nohurt
    duoduanNum = duoduanNum
    startTime = startTime
}
]]
function BaseAnimation:processAttackEffectAndWaitSwitch(info)

    local attackerUnit = info.attackerUnit
    if attackerUnit == nil then 
        return 
    end
    local skillEffectInfo = info.skillEffectInfo
    local SeBattle_HurtInfo = info.SeBattle_HurtInfo
    local boolean_nohurt = info.boolean_nohurt
    local duoduanNum = info.duoduanNum
    local startTime = info.startTime or 0
    local attackerModleID = attackerUnit.uiModleID
    local attackFrameTime = 0

    if skillEffectInfo then
        attackFrameTime = self:ProcessAttackAnim(attackerUnit,skillEffectInfo,startTime)
    end
    startTime = attackFrameTime
    self._attackFrameTrigTime = startTime
    if not boolean_nohurt then
        self:processHurtEffect(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,duoduanNum,startTime)
    end
    
    if SeBattle_HurtInfo.iAddMP and SeBattle_HurtInfo.iAddMP ~= 0 then 
        AddTrackUnitFunc(attackerUnit,startTime,"AddMP",SeBattle_HurtInfo.iAddMP)
        AddTrackUnitFunc(attackerUnit,startTime,"ShowNumber",SeBattle_HurtInfo.iAddMP,COLOR_BATTLE_ZHENQI,false)
    end
    if SeBattle_HurtInfo.iAddHP and SeBattle_HurtInfo.iAddHP ~= 0 then 
        AddTrackUnitFunc(attackerUnit,startTime,"AddHP",SeBattle_HurtInfo.iAddHP)
        AddTrackUnitFunc(attackerUnit,startTime,"ShowNumber",SeBattle_HurtInfo.iAddHP,COLOR_BATTLE_LIFE,true)
    end
    self.startTime = startTime
    BuffObjectManager:GetInstance():ProcessHurtInfo(SeBattle_HurtInfo)

end

function BaseAnimation:ProcessAttackAction(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,boolean_nohurt,startTime)
    self:processCastEffect(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,nil,startTime)
    self:processSceneEffect(skillEffectInfo.sceneEffect,startTime,false,SeBattle_HurtInfo)
    self:processAttackEffectAndWaitSwitch{
        ['attackerUnit'] = attackerUnit,
        ['skillEffectInfo'] = skillEffectInfo,
        ['SeBattle_HurtInfo'] = SeBattle_HurtInfo,
        ['boolean_nohurt'] = boolean_nohurt,
        ['startTime'] = startTime,
    }
end

-- 通用近战技能
function BaseAnimation:GenTrackInfo(SeBattle_HurtInfo,boolean_nohurt)
    local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end
    local StaticSkillEffectData 
    local SkillData = TableDataManager:GetInstance():GetTableData("Skill",SeBattle_HurtInfo.iSkillTypeID)
    if SeBattle_HurtInfo.iSkillTypeID and SeBattle_HurtInfo.iSkillTypeID ~= 0 then
        StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)
    elseif SeBattle_HurtInfo.iBuffTypeID and SeBattle_HurtInfo.iBuffTypeID ~= 0 then
        StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("BuffPerformance",SeBattle_HurtInfo.iBuffTypeID)
        SkillData = {['ShowPerformance'] =  TBoolean.BOOL_YES}
    end
    if StaticSkillEffectData and SkillData and StaticSkillEffectData.skillEffect and (SeBattle_HurtInfo.eSkillEventType ~= BSET_Null or SkillData.ShowPerformance == TBoolean.BOOL_YES) then -- 所有的技能，只要配了技能特效都显示了
        for i=1,#StaticSkillEffectData.skillEffect do
            local skillEffectInfo = StaticSkillEffectData.skillEffect[i]
            self:ProcessAttackAction(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,boolean_nohurt,self.startTime or 0)
        end
    else
        self:processAttackEffectAndWaitSwitch{
            ['attackerUnit'] = attackerUnit,
            ['skillEffectInfo'] = nil,
            ['SeBattle_HurtInfo'] = SeBattle_HurtInfo,
            ['boolean_nohurt'] = nil,
            ['duoduanNum'] = nil,
            ['startTime'] = self.startTime or 0,
        }
    end
end

return BaseAnimation