--[[
-- Date: 2020-08-03 09:28:14
-- LastEditors: fangzhengtao
-- LastEditTime: 2020-08-06 17:33:04
-- FilePath: \LuaProject\Animation\EffectType\BaoyulihuaAnimation.lua.txt
-- 暴雨梨花针技能动画处理
--]]
local AnqiAnimation = require ("Animation/EffectType/AnqiAnimation")
local BaoyulihuaAnimation = class("BaoyulihuaAnimation",AnqiAnimation)
-- 从屏幕2边，每行创建一个暗器特效，以暗器方式飞过，碰到敌人时，敌人播放受击特效
function BaoyulihuaAnimation:GenTrackInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.eSkillEventType == BSET_Null then
        return 
    end
    l_unitMgr = UnitMgr:GetInstance()
    local attackerUnit = l_unitMgr:GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
    if attackerUnit == nil then return end
    local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)
    if StaticSkillEffectData == nil or StaticSkillEffectData.skillEffect == nil or #StaticSkillEffectData.skillEffect < 1 then return end
    local Se_targetsInfo = SeBattle_HurtInfo.akSkillDamageData
    local skillEffectInfo = StaticSkillEffectData.skillEffect[1]
    self:ProcessAttackAction(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,true,0)

    -- 统计两个方向每行的敌人
    local Se_targetsNum = SeBattle_HurtInfo.iSkillDamageData
    local lineUnits = {}
    local lineRightUnits = {}
    for i=1,Se_targetsNum do
        local Se_targetInfo = Se_targetsInfo[i-1]
        local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
        local x,y = targetUnit:GetPos()
        if Se_targetInfo.eSpecialFlag == 1 then 
            lineUnits[y] = lineUnits[y] or {}
            table.insert(lineUnits[y],i)
        else
            lineRightUnits[y] = lineRightUnits[y] or {}
            table.insert(lineRightUnits[y],i)
        end
    end
    
    for y=1,SSD_BATTLE_GRID_HEIGHT do
        local sortingLayer = GetDepthByGridPos(8,y)
        local position = GetPosByGrid(1,y)
        local info = {
            ['attackerUnit'] = attackerUnit,
            ['StaticSkillEffectData'] = StaticSkillEffectData,
            ['Se_targetsInfo'] = Se_targetsInfo,
            ['skillEffectInfo'] = skillEffectInfo,
            ['endX'] = BATTLE_POS_X_RIGHT,
            ['endY'] = position.y,
            ['startX'] = BATTLE_POS_X_LEFT,
            ['startY'] = position.y,
            ['startZ'] = position.z,
            ['sortingLayer'] = sortingLayer,
            ['face'] = 1,
        }
        local flag = true
        if lineUnits[y] and lineUnits[y][1] then  -- 从左往右
            info['roleLine'] = lineUnits[y]
            local Se_targetInfo = Se_targetsInfo[lineUnits[y][1]-1]
            if Se_targetInfo then 
                local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
                if targetUnit then
                    local worldX,worldY = targetUnit:GetXYByMountName(SKILL_EFFECT_MOUNT_NAME.ANQI_CASE_POS,nil,false)
                    info['startY'] = worldY
                    info['endY'] = worldY
                end
            end
        end
        self:processAnqiOneLineInfo(info)

        info['roleLine'] = nil
        info['startX'] = BATTLE_POS_X_RIGHT
        info['endX'] = BATTLE_POS_X_LEFT
        info['face'] = -1
        if lineRightUnits[y] and lineRightUnits[y][1] then 
            info['roleLine'] = lineRightUnits[y]
            local Se_targetInfo = Se_targetsInfo[lineRightUnits[y][1]-1]
            if Se_targetInfo then 
                local targetUnit = l_unitMgr:GetUnit(Se_targetInfo.iTargetUnitIndex)
                if targetUnit then
                    local worldX,worldY = targetUnit:GetXYByMountName(SKILL_EFFECT_MOUNT_NAME.ANQI_CASE_POS,nil,false)
                    info['startY'] = worldY
                    info['endY'] = worldY
                end
            end
        end
        self:processAnqiOneLineInfo(info)
        

    end
end

return BaoyulihuaAnimation