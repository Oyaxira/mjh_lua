BuffObjectManager = class("BuffObjectManager")

function BuffObjectManager:GetInstance()
    if BuffObjectManager._instance == nil then
        BuffObjectManager._instance = BuffObjectManager.new()
    end

    return BuffObjectManager._instance
end

function BuffObjectManager:ctor()
    self.unitBuff = {}
    self.sceneBuff = {}
end

function BuffObjectManager:ProcessHurtInfo(SeBattle_HurtInfo)
    if SeBattle_HurtInfo.iBuffNum == nil then return end
    local TB_BuffPerformance = TableDataManager:GetInstance():GetTable("BuffPerformance")
    for index = 0,SeBattle_HurtInfo.iBuffNum - 1 do
        local buff = SeBattle_HurtInfo.akBuffData[index]
        if  buff ~= nil then
            local iOwnUnitIndex = buff.iOwnUnitIndex
            local iBuffTypeID = buff.iBuffTypeID
            if iRoundNum ~= 0 then
                local buffPerformance = TB_BuffPerformance[iBuffTypeID]
                if buffPerformance then 
                    if buffPerformance.skillEffect and buffPerformance.playOnAdd then 
                        TimeLineHelper:GetInstance():getAnimation():GenTrackInfo({
                            ["iOwnerUnitIndex"] = iOwnUnitIndex,
                            ['iBuffTypeID'] = iBuffTypeID
                        })
                    elseif iOwnUnitIndex then 
                        self:CreateAtUnit(iOwnUnitIndex,buffPerformance)
                    else
                        self:CreateAtScene(buffPerformance,1,1)
                    end
                end
            end
        end
    end
end
--[[
    buffEffectInfo:
    {
        {
            ['type'] = 1;// 1 buff持续特效_添加spine ; 2 光环持续特效_添加spine
            ['prefabPath'] = 预制体路径；// 同技能的prefabPath
            ['prefabAnim'] = 动画名称；// 同技能的prefabAnim
            ['mountName'] = estr_spine_node_挂点;// 同技能的 mount2Name
            ['scale'] = 缩放倍数； // float
        }
    }
]]
function BuffObjectManager:CreateAtUnit(iOwnUnitIndex,buffPerformance)
    local unit = UnitMgr:GetInstance():GetUnit(iOwnUnitIndex)
    if unit and self:UnitHasBuffObject(unit,buffPerformance) == false then 
        local depth = 0
        local effect = buffPerformance.effect
        if buffPerformance.effect then 
            local objs = {}
            for i=1,#buffPerformance.effect do
                local effectInfo = buffPerformance.effect[i]
                if effectInfo.prefabPath then 
                    local buffObject = AddPrefabToSpinePos(effectInfo.prefabPath,0,0,0,effectInfo.mountName or SPINE_BONE_NAME_DEFALUT_BUFF,depth+((effectInfo.layer or 0) + 1) * 5,unit.gameObject,unit:GetSkeletonRenderer())
                    if buffObject then 
                        if effectInfo.scale and effectInfo.scale ~= 1 then 
                            buffObject:SetScale(effectInfo.scale)
                        end 
                        if effectInfo.noFlipX then 
                            buffObject:SetFollowerBoneNotFilp(effectInfo.mountName or SPINE_BONE_NAME_DEFALUT_BUFF,unit:GetSkeletonRenderer())
                        end
                        buffObject:PlayAnimation(effectInfo.prefabAnim,true)
                        table.insert(objs,buffObject)
                    end
                end
            end
            self.unitBuff[unit] = self.unitBuff[unit] or {}
            self.unitBuff[unit][buffPerformance.id] = objs
        end
    end
end

function BuffObjectManager:CreateAtScene(buffPerformance,iGridX,iGridY)
    local worldPos = GetPosByGrid(iGridX,iGridY)
    local depth = GetDepthByGridPos(iGridX,iGridY)
    local objs = {}
    for i=1,#buffPerformance.effect do
        local effectInfo = buffPerformance.effect[i]
        local buffObject = AddPrefabToWorldPos(buffPerformance.prefabPath,worldPos.x,worldPos.y,worldPos.z,depth)
        if buffObject then 
            buffObject:PlayAnimation(effectInfo.prefabAnim,true)
            table.insert(objs,buffObject)
        end
    end
    table.insert(self.sceneBuff,objs)
end

function BuffObjectManager:UnitHasBuffObject(unit,buffPerformance)
    return self.unitBuff[unit] ~= nil and self.unitBuff[unit][buffPerformance.id] ~= nil 
end

-- 更新unit身上删除的buff
function BuffObjectManager:UpdateUnitBuff(unit)
    local buffHash = unit:GetBuff_Hash()
    if self.unitBuff[unit] ~= nil then 
        for typeID , objs in pairs(self.unitBuff[unit]) do
            if buffHash[typeID] == nil then 
                for k,buffObject in pairs(objs) do
                    buffObject:Destroy()
                end
                self.unitBuff[unit][typeID] = nil
            end
        end
    end
    -- 
    local TB_BuffPerformance = TableDataManager:GetInstance():GetTable("BuffPerformance")
    for id,buff in pairs(buffHash) do
        if self.unitBuff[unit] == nil or self.unitBuff[unit][id] == nil then 
            local buffPerformance = TB_BuffPerformance[id]
            if buffPerformance then 
                self:CreateAtUnit(unit.iUnitIndex,buffPerformance)
            end
        end
    end
end

function BuffObjectManager:DeleteUnit(unit)
    if self.unitBuff[unit] then
        for k,objs in pairs(self.unitBuff[unit]) do
            for k,buffObject in pairs(objs) do
                buffObject:Destroy()
            end
        end
        self.unitBuff[unit] = nil
    end
end

function BuffObjectManager:Clear()
    for unit,info in pairs(self.unitBuff) do
        self:DeleteUnit(unit)
    end
    self.unitBuff = {}
end