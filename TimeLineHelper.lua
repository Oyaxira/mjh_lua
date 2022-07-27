TimeLineHelper = class("TimeLineHelper")
TimeLineHelper._instance = nil

BaseAnimation = require ("Animation/EffectType/BaseAnimation")
MutilAttackAniamtion = require ("Animation/EffectType/MutilAttackAniamtion")
AnqiAnimation = require ("Animation/EffectType/AnqiAnimation")
XiaJiBaKanDaoAnimation = require ("Animation/EffectType/XiaJiBaKanDaoAnimation")
MutilAnqiAnimation = require ("Animation/EffectType/MutilAnqiAnimation")
QiShiErFengFeiJianAnimation = require ("Animation/EffectType/QiShiErFengFeiJianAnimation")
LiuMaiShenJianQiAnimation = require ("Animation/EffectType/LiuMaiShenJianQiAnimation")
BaoyulihuaAnimation = require ("Animation/EffectType/BaoyulihuaAnimation")
ChongZhuangAnimation = require ("Animation/EffectType/ChongZhuangAnimation")

function TimeLineHelper:GetInstance()
    if TimeLineHelper._instance == nil then
        TimeLineHelper._instance = TimeLineHelper.new()
        TimeLineHelper._instance:init()
    end

    return TimeLineHelper._instance
end

-- local xgEnumDic = {
--     ['指定技能逻辑_夏济八砍刀法'] = 1,
--     ['技能逻辑_多段攻击技能'] = 2,
--     ['指定技能逻辑_六脉神剑气'] = 3,
--     ['技能逻辑_远程多段暗器技能'] = 4,
--     ['技能逻辑_远程暗器技能'] = 5,
-- }
function TimeLineHelper:init()
    self._BaseAnimation = BaseAnimation.new()
    self._AnqiAnimation = AnqiAnimation.new()
    self._MutilAttackAniamtion = MutilAttackAniamtion.new()
    self._XiaJiBaKanDaoAnimation = XiaJiBaKanDaoAnimation.new()
    self._MutilAnqiAnimation = MutilAnqiAnimation.new()
    self._QiShiErFengFeiJianAnimation = QiShiErFengFeiJianAnimation.new()
    self._LiuMaiShenJianQiAnimation = LiuMaiShenJianQiAnimation.new()
    self._BaoyulihuaAnimation = BaoyulihuaAnimation.new()
    self._ChongZhuangAnimation = ChongZhuangAnimation.new()
    self._canUpdate = true
    self.SkillEffectTypeMap = {
        [1] = self._XiaJiBaKanDaoAnimation,
        [2] = self._MutilAttackAniamtion,
        [3] = self._BaseAnimation,-- 六脉神剑气 ，暂时空缺
        [4] = self._MutilAnqiAnimation,
        [5] = self._AnqiAnimation,
        [6] = self._QiShiErFengFeiJianAnimation,
        [7] = self._LiuMaiShenJianQiAnimation,
        [8] = self._BaoyulihuaAnimation,
        [9] = self._ChongZhuangAnimation,
    }
    self:Reset()
end

function TimeLineHelper:AddTrack(track)
    table.insert(self.traceInfo,track)
end

function TimeLineHelper:Reset()
    if self.traceInfo then 
        for i=1,#self.traceInfo do
            self.traceInfo[i]:Destroy()
        end
    end
    self.overTime = 0
    self.traceInfo = {}
    self.maxTime = nil
    self._canUpdate = false
end

function TimeLineHelper:getAnimation(StaticSkillEffectData)
    local animation
    if StaticSkillEffectData and StaticSkillEffectData.id == 822 then 
        return self._ChongZhuangAnimation
    end
    if StaticSkillEffectData and StaticSkillEffectData.effectType ~= nil then 
        animation = self.SkillEffectTypeMap[StaticSkillEffectData['effectType']]
    end
    return animation or self._BaseAnimation
end

function TimeLineHelper:GenTrackInfo(SeBattle_HurtInfo)
    self.overTime = 0
    self._canUpdate = true
    local StaticSkillEffectData = TableDataManager:GetInstance():GetTableData("SkillPerformance",SeBattle_HurtInfo.iSkillTypeID)
    local animation = self:getAnimation(StaticSkillEffectData)
    animation:GenTrackInfo_Common(SeBattle_HurtInfo)
    -- next
    self:PushQueue(function()
        self:SetCanUpdate(true)
        animation:GenTrackInfo(SeBattle_HurtInfo)
    end)
end

function TimeLineHelper:SetTime(t)
    local bt = t * 1000
    self.overTime = t
    for i=1,#self.traceInfo do
        local traceInfo = self.traceInfo[i]
        if traceInfo:CanRun(bt) then
            traceInfo:SetTime(t)
        end
    end
end

function TimeLineHelper:WriteAllTrack()
    
    local fw = io.open("TimeLineAllTrackInfo" .. os.clock() .. ".csv",'w')
    for i=1,#self.traceInfo do
        local traceInfo = self.traceInfo[i]
        fw:write(traceInfo:GetStr() .. '\n')
    end
    fw:close()
end

local sortFuns = function(trackA,trackB)
    return trackA.startTime < trackB.startTime
end

function TimeLineHelper:SortTracks()
    if self.traceInfo then 
        table.sort(self.traceInfo,sortFuns)
    end
end

function TimeLineHelper:GetMaxTime()
    local result = 0
    if self.traceInfo then 
        for i=1,#self.traceInfo do
            local traceInfo = self.traceInfo[i]
            result = math.max(result,traceInfo:GetMaxTime())
        end
    end
    self.maxTime = result + (self._exMaxTime or 0)
    self._exMaxTime = 0
    return result
end

function TimeLineHelper:GetAllTime()
    local result = 0
    if self.traceInfo then 
        for i=1,#self.traceInfo do
            local traceInfo = self.traceInfo[i]
            result = result + traceInfo:GetMaxTime()
        end
    end
    self.maxTime = result + (self._exMaxTime or 0)
    self._exMaxTime = 0
    return result
end

function TimeLineHelper:AddExMaxTime(value)
    self._exMaxTime = value
end
function TimeLineHelper:SetCanUpdate(boolean_can)
    self._canUpdate = boolean_can
end

function TimeLineHelper:CanUpdate()
    if self._canUpdate then 
        return true
    end
    return false
end

function TimeLineHelper:Update(t)
    if self:CanUpdate() then 
        -- 检测
        if self.maxTime == nil then 
            self:SortTracks()
            self:GetMaxTime()
        end
        self.overTime = self.overTime + t
        for i=1,#self.traceInfo do
            local traceInfo = self.traceInfo[i]
            local canType = traceInfo:CanRun_Update(self.overTime)
            if canType == 0 then
                traceInfo:Run()
            end
            if canType == 2 then
                break
            end
        end
        
        if self.maxTime == nil then 
            self:SortTracks()
            self:GetMaxTime()
        end
        if self.overTime > self.maxTime then 
            self:Reset()
            if self._Queue then 
                local iCount = 0
                while self._Queue do
                    iCount = iCount + 1
                    if iCount > 10 then
                        derror("timeline queue too long")
                        return
                    end
                    local l_queue = self._Queue
                    self._Queue = nil
                    l_queue()
                end
            else
                ProcessNextBattleMsg()
                if self._overCallback then 
                    self._overCallback()
                    self._overCallback = nil
                end
            end
            
        end
    end
end

function TimeLineHelper:SetStartTime(t)
    self._startTime = t
end

function TimeLineHelper:GetStartTime(t)
    return self._startTime
end

function TimeLineHelper:AddStartTime(t)
    self._startTime = (self._startTime or 0) + t
end

function TimeLineHelper:SetOverCallback(func)
    self._overCallback = func
end

function TimeLineHelper:PushQueue(func)
    self._Queue = func
end