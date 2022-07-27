-- 七十二峰飞仙剑表现
local BaseAnimation = require ("Animation/EffectType/BaseAnimation")
local QiShiErFengFeiJianAnimation = class("QiShiErFengFeiJianAnimation",BaseAnimation)

function QiShiErFengFeiJianAnimation:AddSword(iGridX,iGridY,feixianjian,delayTime)
    local pos = GetPosByGrid(iGridX,iGridY)
    local prefabPath = feixianjian.prefabPath or "Effect/Eff/ef_zmenpai_all/ef_changsheng/ef_cs_feijian"
    worldX = pos.x --+ math.random(0,100)/100;
    worldY = pos.y + math.random(0,100)/100 + 5;
    worldZ = pos.z;
    sortingLayer = GetDepthByGridPos(iGridX,iGridY);
    local effectObject = AddPrefabToWorldPos(prefabPath,worldX,worldY,worldZ,sortingLayer)
    if effectObject == nil then
        return 
    end
    -- effectObject:Rotate(-90)
    -- effectObject:PlayAnimation("animation",true)
    effectObject.ParticleSystem:Stop()
    local scale = math.random(feixianjian.scaleDown,feixianjian.scaleUp) / 100
    effectObject:ScaleXY(scale,scale,0)
    effectObject:SetActive(false)
    local playTime = feixianjian.playTime / 1000
    AddTrackLambda(delayTime * 1000,function()
        effectObject:SetActive(true)
        effectObject.ParticleSystem:Play()
        effectObject.transform:DOLocalMoveY(pos.y+feixianjian.offsetY,playTime):SetEase(easings[feixianjian.easeType], 3, 0)
        --:SetDelay(delayTime)
    end)
    local time = effectObject:GetPlayTime()
    AddTrackUnitFunc(effectObject,delayTime * 1000 + time,"Destroy")
    return (delayTime+playTime)*1000
end
function QiShiErFengFeiJianAnimation:GenTrackInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.eSkillEventType == BSET_Null then
        return 
    end
    l_unitMgr = UnitMgr:GetInstance()
    local attackerUnit = l_unitMgr:GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end
    local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
    local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
    local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)
    local skillEffectInfo = nil;
    if StaticSkillEffectData and StaticSkillEffectData.skillEffect then 
        skillEffectInfo = StaticSkillEffectData.skillEffect[1]
    end
    self:ProcessAttackAction(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,true,0)
    local startTime = 0--self._attackFrameTrigTime

    if SeBattle_HurtInfo.iMutilTag == MutilAnqiTag.MT_FRIENDADDTIMES then 
        -- 队友放动作
        local role_list = UnitMgr:GetInstance():GetAllUnit()
        for i,role in ipairs(role_list) do 
            if role and not role:IsDeath() and attackerUnit:IsSameCamp(role.iCamp) then 
                self:ProcessAttackAction(role,skillEffectInfo,SeBattle_HurtInfo,true,0)
            end
        end 
    end
    self:ProcessWuYue(Se_targetsNum,Se_targetsInfo,attackerUnit,startTime)
    local feixianjian = StaticSkillEffectData.feixianjian
    -- 需要保证同一个人的先后顺序
    local AllDelayTime = {}
    for i=1,Se_targetsNum do
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        if targetUnit then
            -- 在每个目标上方创建object，并计算好下落时间，加入timeline
            AllDelayTime[Se_targetInfo.iTargetUnitIndex] = AllDelayTime[Se_targetInfo.iTargetUnitIndex] or feixianjian.delayTimeDown
            local delayTime = math.random(AllDelayTime[Se_targetInfo.iTargetUnitIndex],feixianjian.delayTimeUp)
            AllDelayTime[Se_targetInfo.iTargetUnitIndex] = delayTime
            startTime = self:AddSword(targetUnit.iGridX,targetUnit.iGridY,feixianjian,delayTime/1000)
            self:processHurtEffectSub({
                ['attackerUnit'] = attackerUnit,
                ['targetUnit'] = targetUnit,
                ['Se_targetInfo'] = Se_targetInfo,
                ['skillEffectInfo'] = skillEffectInfo,
                ['SeBattle_HurtInfo'] = SeBattle_HurtInfo,
                ['index'] = i,
                ['duoduanNum'] = 0,
                ['startTime'] = startTime,
            })
        end
    end
    -- 随机创建额外的object，随机下落
    -- TODO:不落在友方上
    local num = math.random(10,20)
    for i=1,num do
        local iGridX = math.random(1,8)
        local iGridY = math.random(1,5)
        local delayTime = math.random(feixianjian.delayTimeDown,feixianjian.delayTimeUp)
        self:AddSword(iGridX,iGridY,feixianjian,delayTime/1000)
    end
end

function QiShiErFengFeiJianAnimation:ProcessWuYue(Se_targetsNum,Se_targetsInfo,attackerUnit,startTime)
    local wuyueInfo = BattleDataManager:GetInstance():GetWuYueInfo()
    if #wuyueInfo>0 and Se_targetsNum > 0 then 
        l_unitMgr = UnitMgr:GetInstance()
        local Se_targetInfo = Se_targetsInfo[0]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        if targetUnit == nil then return end
        local mrandom = math.random
        -- 角色拥有的五岳剑法数量
        local s_name = {"attack_s_001","attack_s_002","attack_s_101"}
        local randomTime = 0
        for i = 1,#wuyueInfo do
            -- 创建分身
            local spineRoleUINew
            -- if self.cacheSpine and #self.cacheSpine > 0 then 
            --     spineRoleUINew = table.remove(self.cacheSpine)
            --     spineRoleUINew:SetRoleData(attackerUnit.battleRole)
            --     spineRoleUINew:SetActive(true)
            -- else
                spineRoleUINew = attackerUnit:Clone()
            -- end
            spineRoleUINew:SetAlpha(0)
            local targetPos = GetPosByGrid(targetUnit.iGridX,targetUnit.iGridY)
            local nx = targetPos.x + mrandom(5,20)/10 - 1
            local ny = targetPos.y + mrandom(5,20)/10 - 1
            spineRoleUINew:SetPosition(attackerUnit.transform.localPosition)
            spineRoleUINew:SetFace(nx > targetPos.x and -1 or 1)
            local baseDepth = GetDepthByGridPos(targetUnit.iGridX,targetUnit.iGridY)
            spineRoleUINew:SetSortingOrder(baseDepth)
            local t = randomTime + startTime
            AddTrackLambda(t,function()
                spineRoleUINew:SetAlpha(1)
                spineRoleUINew:MoveTo(0.1,nx,ny,targetPos.z)
            end)
            -- 播放攻击动作
            AddTrackLambda(t+200,function()
                spineRoleUINew:SetAction(s_name[i%(#s_name)+1])
            end)
            -- 飘字
            local SeBattle_HurtInfo_WuYue = wuyueInfo[i]
            local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo_WuYue.iSkillTypeID)
            local skillEffectInfo = nil;
            if StaticSkillEffectData and StaticSkillEffectData.skillEffect then 
                skillEffectInfo = StaticSkillEffectData.skillEffect[1]
            end
            self:processHurtEffect(attackerUnit,skillEffectInfo,SeBattle_HurtInfo_WuYue,1,t+300)
            -- 消失
            AddTrackLambda(t+2000,function()
                local pos = attackerUnit.transform.localPosition
                spineRoleUINew:MoveTo(0.3,pos.x,pos.y,pos.z)
                FadeInOutShaps(spineRoleUINew.objSpine,0.3,true)
            end)

            AddTrackLambda(t+2500,function()
		        DRCSRef.ObjDestroy(spineRoleUINew.gameObject)
                -- self.cacheSpine = self.cacheSpine or {}
                -- table.insert(self.cacheSpine,spineRoleUINew)
            end)
            randomTime = randomTime + mrandom(50,100)
        end
    end
    BattleDataManager:GetInstance():ClearWuYueInfo()
end
return QiShiErFengFeiJianAnimation