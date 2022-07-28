MeridiansDataManager = class("MeridiansDataManager")
MeridiansDataManager._instance = nil

function MeridiansDataManager:GetInstance()
    if MeridiansDataManager._instance == nil then
        MeridiansDataManager._instance = MeridiansDataManager.new();
        MeridiansDataManager._instance:Init();
    end

    return MeridiansDataManager._instance;
end

function MeridiansDataManager:Init()
    self.data = {};
    self.unlockStage = 1;
    self.weekExp = 0;
    self.weekLimitNum = 0;
    self.weekLimitLevel = 0;
    self.curTotalExp = 0;
    self.curTotalBreak = -1;    -- TODO
    self.breakData = {};
    self.meridiansData = {};
end

function MeridiansDataManager:GetMeridiansData()
    return TableDataManager:GetInstance():GetTable("Meridians")
end

function MeridiansDataManager:GetMeridiansExpData()
    return TableDataManager:GetInstance():GetTable("MeridiansExp")
end

function MeridiansDataManager:GetAcupointData()
    return TableDataManager:GetInstance():GetTable("Acupoint");
end

function MeridiansDataManager:GetAcupointEffectData()
    return TableDataManager:GetInstance():GetTable("AcupointEffect");
end

function MeridiansDataManager:GetQbExpData()
    return TableDataManager:GetInstance():GetTable("QbExp");
end

function MeridiansDataManager:SetWeekRecycleExp(exp)
    self.weekExp = exp;
end

function MeridiansDataManager:GetWeekRecycleExp()
    return self.weekExp;
end

function MeridiansDataManager:SetWeekLimitNum(num)
    self.weekLimitNum = num;
end

function MeridiansDataManager:GetWeekLimitNum()
    return self.weekLimitNum;
end

function MeridiansDataManager:SetWeekLimitLevel(num)
    self.weekLimitLevel = num;
end

function MeridiansDataManager:GetWeekLimitLevel()
    return self.weekLimitLevel;
end

function MeridiansDataManager:SetCurTotalExp(exp)
    self.curTotalExp = exp;
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then 
        windowBarUI:UpdateWindow()
    end

    local MeridiansUI = GetUIWindow("MeridiansUI")
    if MeridiansUI then 
        MeridiansUI:RefreshMeridians()
    end

    -- 刷新包裹
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function MeridiansDataManager:SetCurTotalBreak(count)
    self.curTotalBreak = count;
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then 
        windowBarUI:UpdateWindow()
    end

    -- 刷新包裹
    StorageDataManager:GetInstance():DispatchUpdateEvent()
end

function MeridiansDataManager:GetCurTotalExp()
    return self.curTotalExp;
end

function MeridiansDataManager:GetCurTotalBreak()
    return self.curTotalBreak;
end

-- 服务器数据更新回调
function MeridiansDataManager:AddData(data)
    for k, v in pairs(data.akMeridiansInfo) do
        if v.dwAcupointID % 1000 == 0 then
            self.breakData[v.dwAcupointID] = v;
        else
            self.meridiansData[v.dwAcupointID] = v;
        end
    end

    self.weekExp = data.dwWeekExp; --本周回收已获得经脉经验
    self.weekLimitNum = data.dwWeekLimitNum; --本周回收已升级次数
    self.curTotalExp = data.dwlCurTotalExp; 

    if data.bOver == 1 then -- 下发完毕
        LuaEventDispatcher:dispatchEvent('ONEVENT_REFMERIDIANSUI', data);
    end
end

function MeridiansDataManager:GetBreakData(meridiansID,checkBreakData)
    local tempData = {
        dwMeridianID = 1,
        dwAcupointID = 1000,
        dwLevel = 0,
    }

    if not meridiansID then
        return tempData;
    end
    if checkBreakData == nil then
        checkBreakData = self.breakData
    end 

    for k, v in pairs(checkBreakData) do
        if v.dwMeridianID == meridiansID then
            return v;
        end
    end

    return tempData;
end


function MeridiansDataManager:GetUnlockStage()
    local unlockStage = 1;
    local level = self:GetSumLevel();
    local TB_QbExp = self:GetQbExpData();
    if TB_QbExp then
        for i = 1, #(TB_QbExp) do
            if (level >= TB_QbExp[i].RangeA - 1) then
                unlockStage = TB_QbExp[i].BaseID;
            end
        end
    end

    return unlockStage;
end

function MeridiansDataManager:GetLevel(meridians, limit)
    if not meridians then
        return 0;
    end

    local acupointID = meridians.AcupointID;
    local serverMeridiansData = self:GetServerMeridiansData(meridians.BaseID);
    local level = 0;

    if limit then
        for i = 1, #(acupointID) do
            level = level + self:GetAcupointLevel(acupointID[i]);
        end
    else
        for k, v in pairs(serverMeridiansData) do
            level = level + v.dwLevel;
        end
    end
    
    return level;
end

function MeridiansDataManager:GetAcupointLevel(acupointID)
    local level = 10;
    if not acupointID then
        return level;
    end
    local unlockStage = self:GetUnlockStage();
    local TB_Acupoint = self:GetAcupointData()
    local acupoint = TB_Acupoint[tonumber(acupointID)];
    return acupoint and acupoint.levelLimit[unlockStage] or level;
end

---计算当前经脉等级
function MeridiansDataManager:GetSumLevel()
    local level = 0;
    if not (self.meridiansData) then
        return level;
    end

    for k, v in pairs(self.meridiansData) do
        level = level + v.dwLevel;
    end

    return level;
end

function MeridiansDataManager:GetAcupointUpExp(level)
    if not level then
        return 0
    end
    local typeData = TableDataManager:GetInstance():GetTableData("MeridiansExp", level)
    if typeData then
        return typeData.ExpCost
    end
    return 0
end

function MeridiansDataManager:GetServerMeridiansData(meridiansID, data)
    local tempData = data or self.meridiansData;
    local tempTable = {};
    if not next(tempData) then
        return tempTable;
    end
    for k, v in pairs(tempData) do
        if v.dwMeridianID == meridiansID then
            table.insert(tempTable, v);
        end
    end

    return tempTable; 
end

function MeridiansDataManager:GetServerAcupointData(acupoint, data)
    local serverMeridiansData = self:GetServerMeridiansData(acupoint.OwnerMeridian, data);
    
    for i = 1, #(serverMeridiansData) do
        if serverMeridiansData[i].dwAcupointID == acupoint.BaseID then
            return serverMeridiansData[i];
        end
    end

    local tempAcupointData = {
        dwLevel = 0,
    }

    return tempAcupointData;
end

function MeridiansDataManager:GetMeridiansFull(meridians, levelLimit)
    local full = true;
    if not meridians or not meridians.AcupointID then
        return not full;
    end

    local acupointArray = meridians.AcupointID;

    for i = 1, #acupointArray do
        local acupoint = acupointArray[i];
        local serverAcupointData = self:GetServerAcupointData(acupoint);
        if serverAcupointData.dwLevel < (levelLimit or 10) then
            full = false;
        end
    end
    
    return full;
end

function MeridiansDataManager:GetWeekLimitGrade()
    local qbExp = self:GetQbExpData();
    --本周一的经脉等级
    if qbExp then
        local sumLevel = self:GetWeekLimitLevel();
        for i = 1, #(qbExp) do
            if (sumLevel >= qbExp[i].RangeA) and (sumLevel <= qbExp[i].RangeB) then
                return qbExp[i];
            end
        end
    end
    return nil;
end


function MeridiansDataManager:GetCurGrade()
    local qbExp = self:GetQbExpData();
    if qbExp then
        local sumLevel = self:GetSumLevel();
        for i = 1, #(qbExp) do
            if (sumLevel >= qbExp[i].RangeA) and (sumLevel <= qbExp[i].RangeB) then
                return qbExp[i];
            end
        end
    end

    return nil;
end

function MeridiansDataManager:GetDepartEnumAddPercent(departEnum)
    local TB_Acupoint = self:GetAcupointData()
    local TB_AcupointEffect = self:GetAcupointEffectData()
    if TB_Acupoint and TB_AcupointEffect then
        for k, v in pairs(self.meridiansData) do
            local acupoint = TB_Acupoint[v.dwAcupointID]
            local acupointEffect = TB_AcupointEffect[acupoint.AcupointSkill];
            if acupointEffect.EffectEnum == SkillEffectDescription.SED_Zhi1Ding2Xi3Bei4Wu1Xue2Shu3Xing4Zen1Qiang then
                if acupointEffect.EffectArg1 == departEnum then
                    return acupointEffect.EffectValueB / 10000 * v.dwLevel;
                end
            end
        end
    end
    return 0;
end

function MeridiansDataManager:GetMeridiansInfo(breakData,akMeridians)
    local tempTable = {};

    if not (self.meridiansData) and not akMeridians then
        return tempTable;
    end

    local checkMeridians = akMeridians and akMeridians or self.meridiansData
    local checkBreakData = breakData and breakData or self.breakData

    local TB_Acupoint = self:GetAcupointData()
    local TB_AcupointEffect = self:GetAcupointEffectData()
    for k, v in pairs(checkMeridians) do
        local acupoint = TB_Acupoint[v.dwAcupointID];
        local acupointEffect = TB_AcupointEffect[acupoint.AcupointSkill];
        if acupointEffect.EffectEnum == SkillEffectDescription.SED_Jue1Se2Shu3Xing4Zen1Qiang then

            local value = acupointEffect.EffectValueA * v.dwLevel;
            local breakData = self:GetBreakData(v.dwMeridianID,checkBreakData);
            if breakData.dwLevel > 0 then
                local meridiansData = self:GetMeridiansData();
                if meridiansData then
                    local meridians = meridiansData[v.dwMeridianID];
                    value = math.floor(value * (meridians.BreakValue[breakData.dwLevel] / 10000 + 1));
                end
            end
            tempTable[acupointEffect.EffectArg1] = value;
        end
    end

    return tempTable;
end

return MeridiansDataManager