-- 远程多段暗器类技能动画处理
local AnqiAnimation = require ("Animation/EffectType/AnqiAnimation")
local MutilAnqiAnimation = class("MutilAnqiAnimation",AnqiAnimation)

function MutilAnqiAnimation:NoProcessCommon(SeBattle_HurtInfo)
    if not self.super.NoProcessCommon(self,SeBattle_HurtInfo) then
        if SeBattle_HurtInfo.iMutilTag == MutilAnqiTag.MT_START or SeBattle_HurtInfo.iMutilTag == MutilAnqiTag.MT_CHILD then 
            return true
        end
    end
    return false
end

function MutilAnqiAnimation:GenTrackInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.eSkillEventType == BSET_Null then
        return 
    end
    if self.cacheHurtInfo == nil or SeBattle_HurtInfo.iMutilTag == MutilAnqiTag.MT_START then 
        self.cacheHurtInfo = {}
        table.insert(self.cacheHurtInfo,SeBattle_HurtInfo)
        return
    end
    table.insert(self.cacheHurtInfo,SeBattle_HurtInfo)
    if SeBattle_HurtInfo.iMutilTag == MutilAnqiTag.MT_END then 
        local attackerUnit = UnitMgr:GetInstance():GetUnit(SeBattle_HurtInfo.iOwnerUnitIndex)
        if attackerUnit == nil then return end
        local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)
        if StaticSkillEffectData then
            self:SetStartTime(self.startTime)
            for index,SeBattle_HurtInfo in pairs(self.cacheHurtInfo) do 
                if StaticSkillEffectData.skillEffect then 
                    for i=1,#StaticSkillEffectData.skillEffect do
                        local skillEffectInfo = StaticSkillEffectData.skillEffect[i]
                        if index == 1 then 
                            self:ProcessAttackAction(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,true,0)
                        end
                        if i == 1 then 
                            self:processAnqiEffectAndWaitSwitch(attackerUnit,skillEffectInfo,SeBattle_HurtInfo,StaticSkillEffectData)
                        end
                    end
                else
                    self:processAnqiEffectAndWaitSwitch(attackerUnit,nil,SeBattle_HurtInfo,StaticSkillEffectData)
                end
                self:SetStartTime(self.startTime + index * 300)
            end
        end
    end
end

return MutilAnqiAnimation