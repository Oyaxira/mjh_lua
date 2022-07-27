-- 近战多段攻击类技能动画处理
local AnqiAnimation = require ("Animation/EffectType/AnqiAnimation")
local LiuMaiShenJianQiAnimation = class("LiuMaiShenJianQiAnimation",AnqiAnimation)

function LiuMaiShenJianQiAnimation:processOne(attackerUnit,targetUnit,SeBattle_HurtInfo,StaticSkillEffectData,skillEffectInfo,Se_targetInfo)
    if targetUnit == nil then return end
    local prefabs = {}
    local prefabPath = StaticSkillEffectData['feidanPrefabPath']
    if prefabPath == nil then 
        prefabPath = "Effect/Eff/com/gj_anqi"
    end
    local animName = StaticSkillEffectData['feidanPrefabAnim']
    local erase = StaticSkillEffectData['feidanEase'] or 0
    local time_factor = 0.1
    local info = StaticSkillEffectData['liumai']
    if info then 
        if info.timeFactor and info.timeFactor > 0 then 
            time_factor = info.timeFactor
        end
        prefabs = info.prefabs
        if prefabs and #prefabs > 0 then 
            local index = math.random(1,#prefabs)
            prefabPath = prefabs[index]
        end
    end
    startTime = (self._attackFrameTrigTime or 0) + (self.interval or 0)
    l_unitMgr = UnitMgr:GetInstance()  
    local sortingLayer = getOrderLayerByDepth(SKILL_EFFECT_DEPTH.ON_CURROLE_UP,attackerUnit)
    local startX,startY,startZ = attackerUnit:GetXYByMountName(SKILL_EFFECT_MOUNT_NAME.ANQI_CASE_POS,nil,false)
    local effectObject = AddPrefabToWorldPos(prefabPath,startX,startY,startZ,sortingLayer)
    if effectObject == nil then return end

    if attackerUnit.iFace == 1 then
        startX = startX + 0.5
    else
        startX = startX - 0.5
    end
    AddObjTrack(effectObject,startTime,nil,animName or "animation",true)
    local targetX,targetY,targetZ = targetUnit:GetXYByMountName(SKILL_EFFECT_MOUNT_NAME.ANQI_CASE_POS,nil,false)

    local path = {}
    path[1] = DRCSRef.Vec3(startX,startY,startZ)
    local endX = 0
    local endY = 0;
    if targetX == startX then 
        if startY < targetY then 
            endY = 5
        else 
            endY = -5 
        end
    else
        local k = (targetY - startY) / (targetX - startX) 
        local b = startY - k * startX
        if targetX > startX then 
            endX = 8
        else
            endX = -8
        end
        endY = endX * k + b
    end
    path[2] = DRCSRef.Vec3(endX,endY,0)
    local dis = path[2] - path[1]
    local angles = 0
    if dis.x == 0 then 
        if dis.y > 0 then 
            angles = 90
        else
            angles = -90
        end
    else
        angles = math.atan(dis.y/dis.x) / math.pi * 180
    end
    effectObject.transform.localEulerAngles = DRCSRef.Vec3(0,0,effectObject.transform.localEulerAngles.z+angles);

    int_time = DRCSRef.Vec3.Distance(path[1],path[2]) * 0.01
    int_time = int_time * time_factor
    local tweenPath = effectObject.transform:DOLocalPath(path,int_time,DRCSRef.PathType.CatmullRom,CS.DG.Tweening.PathMode.TopDown2D,1)
    tweenPath:SetEase(easings[erase]);
    AddTrackTweener(tweenPath,startTime,int_time*1000)
    startTime = startTime + int_time*1000
    if skillEffectInfo then 
        self:processSceneEffect(skillEffectInfo.sceneEffect,startTime,true)
    end
    if dis.y < 0 and dis.x < 0 then
        angles =  angles + 180
    elseif dis.y > 0 and dis.x < 0 then
        angles =  angles + 180
    end
    self:processHurtEffectSub({
        ['attackerUnit'] = attackerUnit,
        ['targetUnit'] = targetUnit,
        ['Se_targetInfo'] = Se_targetInfo,
        ['skillEffectInfo'] = skillEffectInfo,
        ['startTime'] = startTime,
        ["rotate"] = (angles),
    })
end


function LiuMaiShenJianQiAnimation:processAnqiEffectAndWaitSwitch(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,StaticSkillEffectData)
    l_unitMgr = UnitMgr:GetInstance()  
    -- 筛出主要目标
    local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
    local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
    prefabPath = prefabPath or "Effect/Eff/com/gj_anqi"
    local effectObject = nil
    for i=1,Se_targetsNum do
        self.interval = 100 * (i - 1);
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        self:processOne(attackerUnit,targetUnit,SeBattle_HurtInfo,StaticSkillEffectData,skillEffectInfo,Se_targetInfo)
    end
end



return LiuMaiShenJianQiAnimation