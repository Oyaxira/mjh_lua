-- 夏济八砍刀法类技能动画处理
local BaseAnimation = require ("Animation/EffectType/BaseAnimation")
local ChongZhuangAnimation = class("ChongZhuangAnimation",BaseAnimation)

function ChongZhuangAnimation:GenTrackInfo_Common(SeBattle_HurtInfo)
    -- 播放死亡动画
    self:GenTrackInfo_Common_Death()
    -- 召唤弟子
    self:GenTrackInfo_Common_Summon()

    if self:NoProcessCommon(SeBattle_HurtInfo) then 
        return 
    end

    self.startTime = 0
    local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    
    self:GenTrackInfo_Common_SkillInfo(SeBattle_HurtInfo,attackerUnit)

    attackerUnit:FaceToPos(SeBattle_HurtInfo.iCastPosX+1)
end


function ChongZhuangAnimation:GenTrackInfo(SeBattle_HurtInfo)
    l_unitMgr = UnitMgr:GetInstance()
    local attackerUnit = l_unitMgr:GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end
    -- 攻击者从当前位置移到到最右边，受击者被推动
    local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
    local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
    local movex = SeBattle_HurtInfo.iMoveX+1
    local movey = SeBattle_HurtInfo.iMoveY+1
    local startX,startY = attackerUnit:GetPos()
    startTime = 0
    local dis = math.abs(movex - startX)
    -- 将所有的目标按x分组
    local targetInfo = {}
    for i=1,Se_targetsNum do
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        if targetUnit then
            local x = targetUnit:GetPos()   
            targetInfo[x] = targetInfo[x] or {}
            table.insert(targetInfo[x],targetUnit)
        end
    end
    for i=1,dis do
        if targetInfo[startX-i] then
            for index,targetUnit in pairs(targetInfo[startX-i] ) do
                local x,y = targetUnit:GetPos()
                targetUnit:SetPosAnim(1,y,false,true,false,startTime,false,0.5)
            end
        end
    end
    attackerUnit:SetPosAnim(1,startY,false,true,false,startTime,false,0.5)

end

return ChongZhuangAnimation