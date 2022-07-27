--[[
-- Date: 2020-08-01 15:20:57
-- LastEditors: fangzhengtao
-- LastEditTime: 2020-09-15 14:49:49
-- FilePath: \LuaProject\Logic\LogicMain_init.lua.txt
-- 存放各种变量初始化、获取、设置接口
--]]
local t = LogicMain
function t:SetUnLockAuto(bUnLock) -- 解锁自动
    self.isUnLockAuto = bUnLock
end

function t:IsUnLockAuto(bUnLock) -- 自动是否解锁
    if self.isUnLockAuto == nil then 
        return true
    end
    return self.isUnLockAuto
end

function t:GetBattleTypeID()
    return self.iBattleTypeID
end

function t:SetBattleTypeID(iID)
    self.iBattleTypeID = iID
end

function t:SetBattleType(iType)
    self.iBattleType = iType
end

function LogicMain:IsArenaBattle()
    return self.iBattleType and self.iBattleType == BattleType.EBattleType_Arena
end

function LogicMain:IsScriptArenaBattle()
    return self.iBattleType and self.iBattleType == BattleType.EBattleType_ScriptArena
end

function LogicMain:IsReplayNeedGiveUp()
    return self.bReplayNeedGiveUP == true
end

function LogicMain:SetReplayNeedGiveUp(bNeed)
    self.bReplayNeedGiveUP = bNeed
end

function t:GetBattleTypeData()
    if self.iBattleTypeID == nil then 
        derror("battle init error,battle type id is nil")
        return nil
    end
    if self._battleData == nil then 
        self._battleData = TableDataManager:GetInstance():GetTableData("Battle", self.iBattleTypeID)
    end
    return self._battleData
end

-- 等待播放完成再结束
function LogicMain:LockQuitBattle()
    self.keepBattleCount = (self.keepBattleCount or 0) + 1
end

function LogicMain:ReleaseQuitBattle()
    self.keepBattleCount = self.keepBattleCount - 1
    PlayQuitBattle()
end

function LogicMain:CanQuitBattle()
    return (self.keepBattleCount or 0) <= 0
end

function LogicMain:SetAutoBattle(bValue)
    self.bAutoBattle = bValue
    SetConfig("AutoBattle", self.bAutoBattle)
    if self.bAutoBattle then
        self:AutoBattle()
    end
end

function LogicMain:IsAutoBattle()
    return self.bAutoBattle
end

function LogicMain:IsRun()
    return self.isOpen or false
end

function LogicMain:SetRun(bValue)
    self.isOpen = bValue
end

function LogicMain:ClearAreanInfo()
    self._arean_IsPauseReplay = nil
    self._arean_NeedProcessMsg = nil
    self._arean_CouldPauseReplay = nil
end

function LogicMain:ProcessPauseReplay()
    self._arean_NeedProcessMsg = true
    self:ShowAllGrid(true)
end

function LogicMain:PauseAreanReplay()
    self._arean_IsPauseReplay = true
    self._arean_NeedProcessMsg = false
end

function LogicMain:IsPauseAreanReplay()
    return self._arean_IsPauseReplay and self._arean_CouldPauseReplay 
end

function LogicMain:SetCannotPauseAreanReplay()
    self._arean_CouldPauseReplay = false
end

function LogicMain:SetCanPauseAreanReplay()
    self._arean_CouldPauseReplay = true
end

function LogicMain:PlayAreanReplay()
    self._arean_IsPauseReplay = false
    if self._arean_NeedProcessMsg then 
        LogicMain:GetInstance():ShowAllGrid()
        ProcessBattleMsg()
    end
end

function LogicMain:GetFriendName()
    return self.sFriendName or ""
end

function LogicMain:GetEnemyName()
    return self.sEnemyName or ""
end

function LogicMain:GetCurOptUnit()
    return self.kUnitMgr:GetCurOptUnit()
end

function LogicMain:EnterBattleMsg()
    self.isBattleProcess = true
end

function LogicMain:HasBattleMsg()
    return self.isBattleProcess
end

------- 战斗奖励数据
-- 记录金钱搜刮奖励
function LogicMain:RecordAwardCoin(coins)
    self.awardCoinRecord = coins + (self.awardCoinRecord or 0)
end

function LogicMain:GetAwardCoin()
    return self.awardCoinRecord or 0
end

function LogicMain:RecordAwardInfo(info)
    self.awardInfo = self.awardInfo or {}
    table.insert(self.awardInfo,info)
end

function LogicMain:GetAwardInfo()
    if self.awardInfo then 
        return table.concat(self.awardInfo,'\n')
    end
    return ""
end

function LogicMain:GetAwardInfoNum()
    if self.awardInfo then 
        return #self.awardInfo
    end
    return 0
end

function LogicMain:ClearAwardInfo()
    self.awardInfo = {}
    self.awardCoinRecord = 0
end

function LogicMain:CanShowSkillGrid()
    return self.bCanShowSkillGrid or false
end

function LogicMain:SetCanShowSkillGrid(bValue)
    self.bCanShowSkillGrid = bValue
end


function LogicMain:IsReplaying()
    if self._Replaying or self:IsArenaBattle() then 
        return true
    end
    return false
end

function LogicMain:IsOpenRecord()
    return self._OpenRecord or false
end

function LogicMain:AddRecordMsg(msg,info)
    if self:IsOpenRecord() then 
        if not self._Replaying then 
            self._RecordMsg = self._RecordMsg or {}
            table.insert(self._RecordMsg,{msg,info})
        end
    end
end

function LogicMain:ClearReplayInfo()
    self._RecordMsg = nil
    self._Replaying = nil
end

