reloadModule("Data/ClientEnum")
BattleSceneAnimation = class("BattleSceneAnimation")
BattleSceneAnimation._instance = nil
l_animationMgr = AnimationMgr:GetInstance()

function BattleSceneAnimation:ctor()
    self.hejiEffectList = {}
    self.BeginHejiEffect = false
end

function BattleSceneAnimation:GetInstance()
    if BattleSceneAnimation._instance == nil then
        BattleSceneAnimation._instance = BattleSceneAnimation.new()
    end

    return BattleSceneAnimation._instance
end

-- 获取spine攻击动作名称
-- uiModelID:模型id，spineaniminfo：技能动作信息
getAttackAction = function(uiModelID,spineaniminfo)
    if spineaniminfo == nil then return SPINE_ANIMATION.BATTLE_IDEL end
    local string_actionname
    local kTypeData = TableDataManager:GetInstance():GetTableData("SpineAnimaitionTime", uiModelID)
    if spineaniminfo.action then
        string_actionname = spineaniminfo.action
        if spineaniminfo.type and SPINE_ATTACK_TYPE[spineaniminfo.type] then 
            string_actionname = string_actionname .. "_" .. SPINE_ATTACK_TYPE[spineaniminfo.type]
        end

        if spineaniminfo.num then 
            local newName = string.format("%s_%03d",string_actionname,spineaniminfo.num)
            if kTypeData == nil or kTypeData[newName] == nil then
                newName = string.format("%s_%03d",string_actionname,spineaniminfo.num-1)
            end
            string_actionname = newName
        end

    end

    string_actionname = string_actionname or spineaniminfo.oldActionName or SPINE_DEFAULT_ANIMATION
    if kTypeData == nil or kTypeData[string_actionname] == nil then 
        string_actionname = SPINE_DEFAULT_ANIMATION
    end
	return string_actionname
end

-- 通过挂点位置获取世界坐标
-- mount1Name:特殊挂点,mount2Name:spine挂点,spine:需要获取spine挂点的spine,isOnRole:是否挂在角色上,SeBattle_HurtInfo:伤害信息
getXYByMountName = function(mount1Name,mount2Name,spine,isOnRole,SeBattle_HurtInfo)
    local resultX,resultY,resultZ = 0,0,0
    if mount1Name == SKILL_EFFECT_MOUNT_NAME.SKILL_CAST_POS and SeBattle_HurtInfo then
        local worldPos = GetPosByGrid(SeBattle_HurtInfo.iCastPosX+1,SeBattle_HurtInfo.iCastPosY+1)
        resultX = worldPos.x
        resultY = worldPos.y
        resultZ = worldPos.z
    elseif mount1Name == SKILL_EFFECT_MOUNT_NAME.SCREEN_CENTER then
        resultX = 0
        resultY = 0
        resultZ = 0
    else
        if spine then
            if mount1Name == SKILL_EFFECT_MOUNT_NAME.ANQI_CASE_POS then
                mount2Name = SPINE_BONE_NAME_ANQI
            end
            resultX,resultY = GetSpineBoneWorldPos(spine, mount2Name)
            resultZ = spine.transform.position.z
            if not isOnRole then
                local vec3 = spine.transform:TransformPoint(DRCSRef.Vec3(resultX,resultY))
                resultX,resultY,resultZ = vec3.x,vec3.y,vec3.z
            end
        end
    end
    return resultX,resultY,resultZ
end

-- 通过depth获取orderlayer
-- depth:定义好的层级枚举，unit：依赖的单位
getOrderLayerByDepth = function(depth,unit,extraValue)
    local result = 0
    local baseOrder = unit:GetBaseOrder()
    depth = depth or SKILL_EFFECT_DEPTH.ON_CURROLE_UP
    if depth == SKILL_EFFECT_DEPTH.ON_CURROLE_UP then
        result = baseOrder + 10
    elseif depth == SKILL_EFFECT_DEPTH.ON_CURROLE_DOWN then
        result = baseOrder
    elseif depth == SKILL_EFFECT_DEPTH.ON_ALLROLE_UP then
        local maxLayer = GetDepthByGridPos(0,0)
        result = maxLayer + 10
    elseif depth == SKILL_EFFECT_DEPTH.ON_ALLROLE_DOWN then
        result = 10
    elseif depth == SKILL_EFFECT_DEPTH.ON_CURROLE_LINE then
        result = GetDepthByGridPos(SSD_BATTLE_GRID_WIDTH,unit.iGridY)
    end
    if extraValue then 
        result = result + extraValue
    end
    -- TODO: 等技能编辑器加入枚举后，加下就行了
    -- TODO: 同行特效（人物上层）
    -- result = GetDepthByGridPos(SSD_BATTLE_GRID_WIDTH,unit.iGridY) + 10
    -- TODO: 同行特效（人物下层）
    -- result = GetDepthByGridPos(0,unit.iGridY)
    return result
end

--合击的逻辑
function BattleSceneAnimation:setHejiEnd()
    TimeLineHelper:GetInstance():Reset()
    -- for i=1,#self.hejiEffectList do
    --     local SeBattle_HurtInfo = self.hejiEffectList[i]
    --     TimeLineHelper:GetInstance():GenTrackInfo(SeBattle_HurtInfo)
    -- end
    TimeLineHelper:GetInstance():GenTrackInfo(self.hejiEffectList[#self.hejiEffectList])
    local delayTime = 500   --不能太小
    local maxTime = TimeLineHelper:GetInstance():GetAllTime() + delayTime
    --local maxTime = TimeLineHelper:GetInstance():GetMaxTime()
    AddTrackLambda(maxTime,function()
        for i=1,#self.hejiEffectList do
            local SeBattle_HurtInfo = self.hejiEffectList[i]
            local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
            if attackerUnit then
                attackerUnit:SetPos(attackerUnit.iOldGridX,attackerUnit.iOldGridY,nil,false,true,maxTime,false)
            end
        end
        self.hejiEffectList = nil
    end)
    
end
function BattleSceneAnimation:processHurtInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo and SeBattle_HurtInfo.iSkillTypeID ~= 0 and SeBattle_HurtInfo.iOwnerMartialIndex ~= 0 then 
        if SeBattle_HurtInfo.eSkillEventType == BSET_HeJiQiDong then
            self.hejiEffectList = self.hejiEffectList or {}
            table.insert(self.hejiEffectList,SeBattle_HurtInfo)
            if #self.hejiEffectList == self.iHeJiTargetNum then 
                self:setHejiEnd()
            else
                TimeLineHelper:GetInstance():Reset()
                TimeLineHelper:GetInstance():GenTrackInfo(SeBattle_HurtInfo)
            end
            return 
        else
            if SeBattle_HurtInfo.iHeJiTargetNum ~= 0 then 
                self.hejiEffectList = nil
                self.iHeJiTargetNum = SeBattle_HurtInfo.iHeJiTargetNum 
            end
        end
    end

    TimeLineHelper:GetInstance():Reset()
    TimeLineHelper:GetInstance():GenTrackInfo(SeBattle_HurtInfo)
end

function BattleSceneAnimation:Clear()
    self.BeginHejiEffect = false
    self.hejiEffectList = nil
    self.iHeJiTargetNum = nil
end
function PauseGame()
    oldTimeScale = DRCSRef.Time.timeScale
    DRCSRef.Time.timeScale = 0
end

function ResumeGame()
    DRCSRef.Time.timeScale = oldTimeScale
end
function SetSpeed(type,value)
    GlobalSpeed = GlobalSpeed or {}
    GlobalSpeed[type] = value
    local count = 0
    for k,v in pairs(GlobalSpeed) do
        count = count + v
    end 
    
    DRCSRef.Time.timeScale = count
end

function GetSpeed(type)
    if GlobalSpeed == nil then
        GlobalSpeed = {}
    end
    return GlobalSpeed[type] or 0
end

function ClearSpeed()
    SetSpeed(SPEED_TYPE.BATTLE,0)
    SetSpeed(SPEED_TYPE.SKILL,0)
    SetSpeed(SPEED_TYPE.ROUND,0)
end

return BattleSceneAnimation