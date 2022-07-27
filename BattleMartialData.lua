BattleMartialData = class("BattleMartialData")

local l_BATTLE_GRID_WIDTH = SSD_BATTLE_GRID_WIDTH
local l_BATTLE_GRID_HEIGHT = SSD_BATTLE_GRID_HEIGHT
local l_math_abs = math.abs
local l_TB_Range = TableDataManager:GetInstance():GetTable("Range")

--获取技能施法范围
local function GetCastRange(iMartialRangeID,iMartialLevel,eDepartEnum)
    if iMartialRangeID == 0 then
        iMartialRangeID = 100
    end
    local l_TB_MartialRange = TableDataManager:GetInstance():GetTable("MartialRange")
    
    local srcLevel = iMartialLevel
    local martialRangeData = l_TB_MartialRange[iMartialRangeID]
    if martialRangeData  == nil then
        derror("TB_MartialRange: iMartialRangeID is nil "..iMartialRangeID)
        return {}
    end
    local iRangeID = 0
    iMartialLevel = Clamp(srcLevel,1,#martialRangeData.CasterRangeIDs)
    iRangeID = martialRangeData.CasterRangeIDs[iMartialLevel]
    local pos = {}
    local rangeData = l_TB_Range[iRangeID]
    for i = 1, #rangeData.PosXs do
        pos[i] = {rangeData.PosXs[i],rangeData.PosYs[i]}
    end

    local posY = {}
    if martialRangeData.CasterRangeIDs2 and #martialRangeData.CasterRangeIDs2 > 0 then
        iMartialLevel = Clamp(srcLevel,1,#martialRangeData.CasterRangeIDs2)
        iRangeID = martialRangeData.CasterRangeIDs2[iMartialLevel]
        local rangeData = l_TB_Range[iRangeID]
        for i = 1, #rangeData.PosXs do
            posY[i] = {rangeData.PosXs[i],rangeData.PosYs[i]}
        end
    end

    return  pos, posY
end
--获取技能伤害范围
local function GetDamageRange(iMartialRangeID,iMartialLevel,eDepartEnum)
    if iMartialRangeID == 0 then
        iMartialRangeID = 100
    end
    local srcLevel = iMartialLevel
    local l_TB_MartialRange = TableDataManager:GetInstance():GetTable("MartialRange")
    local martialRangeData = l_TB_MartialRange[iMartialRangeID]
    if martialRangeData  == nil then
        derror("TB_MartialRange: iMartialRangeID is nil "..iMartialRangeID)
        return {},{}
    end
    local iRangeID = 0
    local pos = {}
    if martialRangeData.AttackRangeIDs then
        iMartialLevel = Clamp(srcLevel,1,#martialRangeData.AttackRangeIDs)
        iRangeID = martialRangeData.AttackRangeIDs[iMartialLevel]
        local rangeData = l_TB_Range[iRangeID]
        for i = 1, #rangeData.PosXs do
            pos[i] = {rangeData.PosXs[i],rangeData.PosYs[i]}
        end
    else
        derror("TB_MartialRange AttackRangeIDs is nil  "..iMartialRangeID)
    end

    local posY = {}
    if martialRangeData.AttackRangeIDs2 and #martialRangeData.AttackRangeIDs2 > 0 then
        iMartialLevel = Clamp(srcLevel,1,#martialRangeData.AttackRangeIDs2)
        iRangeID = martialRangeData.AttackRangeIDs2[iMartialLevel]
        local rangeData = l_TB_Range[iRangeID]
        for i = 1, #rangeData.PosXs do
            posY[i] = {rangeData.PosXs[i],rangeData.PosYs[i]}
        end
    end

    return  pos, posY
end

function BattleMartialData:ctor()
    self.iMartialItemTypeID = 0
    self.iMartialID = 0
    self.iMartialIndex = 0
    self.iMartialLevel = 1
    self.iDamageValue = 0
    self.iDefaultDamageValue = 0
    self.iPower = 0
    self.iPowerPercent = 0
    self.iPowerBase = 0
    self.iCostMP = 0
    self.aiCastRangePos = {}
    self.aiDamagePos = {}
    self.aiCastRangePosY = {}
    self.aiDamagePosY = {}
    self.eTargetType = SkillTargetType.SkillTargetType_NULL
    self.IsOnlyShowCasterRange = false
    self.eStateFlag = BSSF_USEABLE
    self.iMartialRangeLevel = 1
end

function BattleMartialData:Init(kMartialData)
    local l_TB_MartialRange = TableDataManager:GetInstance():GetTable("MartialRange")
    self.iMartialItemTypeID = kMartialData['uiMartialItemID']
    self.iMartialLevel = kMartialData['uiMartialLevel']
    self.iMartialID = kMartialData['uiMartialID']
    self.iMartialIndex = kMartialData['uiMartialIndex']
    self.iDamageValue = kMartialData['uiDamageValue']
    self.coldTime = kMartialData['uiColdTime']
    if self.iDefaultDamageValue == 0 then
        self.iDefaultDamageValue = self.iDamageValue
    end
    self.iPower = kMartialData['uiPower']
    self.iPowerPercent = kMartialData['uiPowerPercent']/ 10000
    self.iPowerBase = kMartialData['uiPowerBase'] and kMartialData['uiPowerBase'] / 10000
    self.iCostMP = kMartialData['uiCostMP']
    self.iMartialRangeLevel = kMartialData['uiRangeLevel']
    self.eStateFalg = kMartialData['eStateFalg']
    self.eParamInfo = kMartialData['eParamInfo']
    local martialItemData = TableDataManager:GetInstance():GetTableData("MartialItem", self.iMartialItemTypeID)
    local martialData = GetTableData("Martial",self.iMartialID)
    --能待到战斗力的  一定是有招式的 否则就报错
    if martialItemData == nil or martialData == nil  then
        dprint("amrtialItem is nil :"..self.iMartialItemTypeID)
        return
    end
    self.eDepartEnum = martialData.DepartEnum
    if  self.eDepartEnum ~= DepartEnumType.DET_Fly and martialItemData == nil then
        dprint("amrtialItem is nil :"..self.iMartialItemTypeID)
        return
    end
    local iMartialRangeID = -1
    local skillID = martialItemData['SkillID1']
    if kMartialData.uiSkillEvolution ~= 0 then
        skillID = kMartialData.uiSkillEvolution
    end 
    self.skillID = skillID
    local skillData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
    if skillData  == nil then return end 
    if skillData.SkillRange == 0 then 
        derror("skillData.SkillRange is 0:",skillID)
    end
    iMartialRangeID = skillData.SkillRange ~= 0 and skillData.SkillRange or 1
    self.eTargetType = skillData.TargetType
    self.Type = skillData.Type 
    if l_TB_MartialRange[iMartialRangeID] then
        self.IsOnlyShowCasterRange = l_TB_MartialRange[iMartialRangeID].IsOnlyShowCasterRange
    end
    
    self.aiCastRangePos, self.aiCastRangePosY = GetCastRange(iMartialRangeID,self.iMartialRangeLevel)
    self.aiDamagePos,self.aiDamagePosY = GetDamageRange(iMartialRangeID,self.iMartialRangeLevel)

    self.name = GetLanguageByID(skillData.NameID)
    self.Icon = skillData.Icon
    self.Rank = skillData.Rank
    self.uiRoleUID = kMartialData.uiRoleUID
end

function BattleMartialData:IsAoYi()
    return  self.Type == SkillType.SkillType_aoyi
end

function BattleMartialData:IsJueZhao()
    return  self.Type == SkillType.SkillType_juezhao
end

function BattleMartialData:SetData(kMartialData)
    if self.iMartialItemTypeID ~= iMartialItemTypeID then
        self:Init(kMartialData)
    end
    self.eStateFalg = kMartialData['eStateFalg']
    self.coldTime = kMartialData['uiColdTime']
end

function BattleMartialData:GetStateFlag()
    return self.eStateFalg
end

function BattleMartialData:IsEmbattle()
    return HasFlag(self.eStateFalg, BMSF_EMBATTLE)
end

function BattleMartialData:isFengYin()
    if HasFlag(self.eStateFalg, BMSF_FENG_YIN) then
        return true
    end

    return false
end

function BattleMartialData:isInColdTime()
    return (self.coldTime or 0) > 0
end

function BattleMartialData:getColdTime()
    return (self.coldTime or 0)
end

function BattleMartialData:isDizzy()
    if HasFlag(self.eStateFalg, BMSF_DIZZY) then
        return true
    end

    return false
end

function BattleMartialData:CureIsDemage()
    if self.iMartialLevel >= 30 and self.iMartialID == 10315 then 
        return true
    end
end

function BattleMartialData:SetCureIsDemage()
    self.eTargetType = SkillTargetType.SkillTargetType_renyi
end

function BattleMartialData:GetTargetType()
    if self.eParamInfo & 0x01 == 1 then 
        return SkillTargetType.SkillTargetType_renyi
    end 
    if self.eDepartEnum == DepartEnumType.DET_MedicalSkill and self.unit and self.unit:HasCureIsDemage() then 
        return SkillTargetType.SkillTargetType_renyi
    end
    return self.eTargetType
end

function BattleMartialData:SetUnit(unit)
    self.unit = unit
end