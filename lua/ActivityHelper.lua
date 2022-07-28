ActivityHelper = class("ActivityHelper")


function ActivityHelper:GetInstance()
    if ActivityHelper._instance == nil then
        ActivityHelper._instance = ActivityHelper.new()
        ActivityHelper._instance:Init()
    end

    return ActivityHelper._instance
end

function ActivityHelper:Init()
    local activityBase = TableDataManager:GetInstance():GetTable("ActivityBase") 

    self.akActivityTable = {} --本地表数据
    self.akActivityInfo = {} --服务器数据
    self.akPreExperienceData = {}
    self.aiPlayerReturnTask = {} -- 0 没弹过奖励tips 1 已经弹过奖励tips
    self.iCurPlayerReturnActivityID = 0
    self.iCurPlayerReturnACtivityEndTime = 0
    self.fundDataList = {}
    self.akActivityTBMap = {} -- 键 类型 值 活动列表 

    --月牙村 不显示所有活动
    if not MSDKHelper:IsPlayerTestNet() or DEBUG_MODE then
        for k ,v in pairs(activityBase) do
            if v.Sort == 0 or v.Sort == nil then --陈辉 如果没填 默认显示到最后一个
                v.Sort = 999999
            end
            if v.IsActShow == 1  and v.bEnabled ~= 0 then
                self.akActivityTable [#self.akActivityTable  + 1] = v
            end
            if v.Type then 
                if self.akActivityTBMap[v.Type] == nil then 
                    self.akActivityTBMap[v.Type] = {}
                end 

                self.akActivityTBMap[v.Type][#self.akActivityTBMap[v.Type] + 1] = v
            end 
        end
    
        table.sort(self.akActivityTable, function(a,b)
            if a.Sort == b.Sort then
                return a.BaseID < b.BaseID 
            else
                return a.Sort < b.Sort
            end
        end)
    end 
end


function ActivityHelper:GetShowActivity(kIndexCache,iActicityType)
    local iChannelID = GetCurChannelID() or ChannelType.ACB_Cl_Null -- 当前渠道id
    local channel = MSDKHelper:GetChannel() --QQ登陆 微信登陆 or 游客登录
    local iLoginID = 0 -- 0 都显示 1QQ 2微信 3游客
    if channel == "QQ" then
        iLoginID = 1
    elseif channel == "WeChat" then
        iLoginID = 2
    else 
        iLoginID = 3
    end

    local akActivity = {}
    local bActivityChanged = (kIndexCache == nil)  -- 活动列表是否有变动
    local kNewIndexCache = {}
    local iDefalutShow = ChannelType.ACB_Cl_Null
    local function IsInChannelID(activityBaseData)
        if activityBaseData.ChannelShow then
            for k, v in ipairs(activityBaseData.ChannelShow) do
                if v == iDefalutShow or iChannelID == v then
                    return true
                end
            end
            return false
        else
            return true
        end
    end

    local function IsInLoginShow(activityBaseData)
        if activityBaseData.LoginShow then
            for k ,v in ipairs(activityBaseData.LoginShow) do
                if v== 0 or iLoginID == v then
                    return true
                end
            end
            return false
        else
            return true
        end
    end

    

    for k ,v in pairs(self.akActivityTable) do
        -- 默认活动UI里 不显示回流活动 回流活动单独显示
        if ((iActicityType == nil and v.Type ~= ActivityType.ACCT_BackFlow) or iActicityType == v.Type) 
            and (v.bEnabled ~= 0) and IsInChannelID(v) and IsInLoginShow(v)  then
            --回流活动有可能超过结束时间
            if v.Type == ActivityType.ACCT_BackFlow or ActivityHelper.IsInActivityTime(v) then 
                if v.Type ~= ActivityType.ACCT_Fund or (v.Type == ActivityType.ACCT_Fund and v.FundStage == 1) then
                    local uiNewIndex = #akActivity + 1
                    akActivity[uiNewIndex] = v
                    if kIndexCache and (kIndexCache[v.BaseID] ~= uiNewIndex) then
                        bActivityChanged = true
                    end
                    kNewIndexCache[v.BaseID] = uiNewIndex
                end
            end
        end
    end

    -- 有活动 -> 没活动
    if kIndexCache and next(kIndexCache) and (not next(kNewIndexCache)) then
        bActivityChanged = true
    end

    return akActivity, kNewIndexCache, bActivityChanged
end

function ActivityHelper:GetFundData()
    return self.fundDataList
end

--服务器下行 每个活动的具体信息
function ActivityHelper:UpdateActivityInfo(kRetData)
    if kRetData.iNum > 0 then
        for i = 0,kRetData.iNum-1 do
            local kActivityData = kRetData.akActivityInfo[i]
            self.akActivityInfo[kActivityData.dwActivityID] = kActivityData


            self:UpdateActivityData(kActivityData)
            for k,v in ipairs(self.akActivityTable) do
                if v.BaseID == kActivityData.dwActivityID then
                    v.bEnabled = kActivityData.bEnabled
                end
            end
            LuaEventDispatcher:dispatchEvent("QueryActivityRet",kActivityData)
        end
    end

    LuaEventDispatcher:dispatchEvent("UpdateActivityInfo")
end

-- 处理下行数据
function ActivityHelper:UpdateActivityData(kActivityData)
    if kActivityData and  kActivityData.dwActivityID then 
        local ActivityBaseData =  GetTableData('ActivityBase',kActivityData.dwActivityID)
        if not ActivityBaseData then 
            return 
        end 
        -- 秘宝活动处理
        if ActivityBaseData.Type == ActivityType.ACCT_TreasureExchange then 
            self.akActiveTreasureExchange = self.akActiveTreasureExchange or {}
            if kActivityData.bEnabled and ActivityHelper.IsInActivityTime(ActivityBaseData) then 
                self.akActiveTreasureExchange[kActivityData.dwActivityID] = kActivityData
                self.akActiveTreasureExchange[kActivityData.dwActivityID].tabledata = ActivityBaseData
                if kActivityData and kActivityData.iValue1 then 
                    local iValue1 = kActivityData.iValue1
                    local iState = kActivityData.iValue2
                    kActivityData.iList = {}
                    for i=1,64 do 
                        local iCurValue = iValue1 >> (i-1) & 1
                        local iCuriState = iState >> (i-1) & 1
                        if iCurValue == 1 then 
                            kActivityData.iList[i] = iCuriState
                        end 
                    end 
                end 
            elseif self.akActiveTreasureExchange[kActivityData.dwActivityID] then 
                self.akActiveTreasureExchange[kActivityData.dwActivityID] = nil
            end 
            LuaEventDispatcher:dispatchEvent("UpdataTreasureExchange",self.akActiveTreasureExchange[kActivityData.dwActivityID])
        elseif self:IfIsFestivalActivity(kActivityData.dwActivityID) then 
            LuaEventDispatcher:dispatchEvent("UPDATE_LANDLADY")
        end
        -- 基金活动
        if ActivityBaseData.Type == ActivityType.ACCT_Fund and ActivityHelper.IsInActivityTime(ActivityBaseData) then
            self.fundDataList[ActivityBaseData.BaseID] = ActivityBaseData
        end
    end
end
--
function ActivityHelper:GetTreasureExchangeItemID(iIndex)
    local TB_ActivityBase = TableDataManager:GetInstance():GetTable("ActivityBase") 
    local iActicityID
    local tb_activityBase
    if TB_ActivityBase then 
        for i,activityBase in pairs(TB_ActivityBase) do 
            if ActivityType.ACCT_TreasureExchange == activityBase.Type then 
                if ActivityHelper.IsInActivityTime(activityBase) then 
                    -- iActicityID = activityBase.BaseID
                    tb_activityBase = activityBase
                    break
                end
            end 
        end 
    end
    if tb_activityBase then 
        if iIndex == 1 then 
            return tb_activityBase.ParamN[1]
        elseif iIndex == 2 then 
            return tb_activityBase.ParamN[3]
        end 
    end 
    return nil
end
function ActivityHelper:GetActiveTreasureExchange()
    if self.akActiveTreasureExchange then 
        -- 理论当前仅一个在活动中 
        for iBaseid,activityData in pairs(self.akActiveTreasureExchange) do 
            if ActivityHelper.IsInActivityTime(activityData.tabledata) and activityData.bEnabled ~= 0 then 
                return activityData
            end
        end 
    end
    return nil
end
function ActivityHelper:GetTreasureExchangeBought(iActicityID,iIndex)
    if iActicityID and iIndex then 
        if self.akActiveTreasureExchange and self.akActiveTreasureExchange[iActicityID] then 
            -- 理论当前仅一个在活动中 
            local activityData = self.akActiveTreasureExchange[iActicityID]
            if activityData and activityData.iList then 
                return  activityData.iList[iIndex] == 1 
            end 
            
        end

    end 
    return false
end
function ActivityHelper:GetTBActivitiesByType(eActivityType,bIsRuning)
    local activityBase = TableDataManager:GetInstance():GetTable("ActivityBase") 
    if not eActivityType then 
        return {}
    end
    local _akActivityTB = {}
    for iIndex,akActivity in pairs(self.akActivityTBMap[eActivityType] or {}) do 
        local iBaseID = akActivity.BaseID
        if not bIsRuning or (self.akActivityInfo[iBaseID] and self.akActivityInfo[iBaseID].bEnabled == TBoolean.BOOL_YES and ActivityHelper.IsInActivityTime(akActivity)) then 
            _akActivityTB[#_akActivityTB +1 ] = akActivity
        end 
    end 
    return _akActivityTB
end 
-----------------start---------- 节日活动 --------
function ActivityHelper:GetFestivalActivityMap()
    if not self.FestivalActivityMap then 
        self.FestivalActivityMap = {
            [ActivityType['ACCT_Festival_SignIn']] = true,
            [ActivityType['ACCT_Festival_DialyTask']] = true,
            [ActivityType['ACCT_Festival_Exchange']] = true,
            [ActivityType['ACCT_Festival_Mall']] = true,
        }
    end 
    return self.FestivalActivityMap 
end  
function ActivityHelper:IfIsFestivalActivity(iActicityID)
    if iActicityID then 
        local akActivity = self.akActivityInfo and self.akActivityInfo[iActicityID]
        if akActivity then 
            local FestivalActivityMap = self:GetFestivalActivityMap()
            if FestivalActivityMap[akActivity.Type] then 
                return true 
            end 
        end 
    end 
    return false 
end
function ActivityHelper:AddFestivalCleanResBox(iParam)
    if iParam and iParam > 0 then 
        self.iFestivalCleanResParam = self.iFestivalCleanResParam or 0 
        self.iFestivalCleanResParam = self.iFestivalCleanResParam + iParam 
        if not self.timerShowBox then 
            self.timerShowBox =  globalTimer:AddTimer(200, function()
                if self.iFestivalCleanResParam and self.iFestivalCleanResParam > 0 then  
                    local strMsg = string.format("冬雪庆典已结束，相关活动资源已转化为%d经脉经验", self.iFestivalCleanResParam)
                    SystemUICall:GetInstance():WarningBox(strMsg)
                end 
                self.timerShowBox = nil
                self.iFestivalCleanResParam = 0
            end)
        end 
    end 
        
end
function ActivityHelper:GetFestivalActivities()
    local ret = {}
    for eActivityType,bdefalut in pairs(self:GetFestivalActivityMap()) do 
        local akActivityData = self:GetTBActivitiesByType(eActivityType,true)
        if akActivityData and akActivityData ~= {} then 
            table.move(akActivityData,1,#akActivityData,#ret + 1,ret)
        end 
    end 
    return ret 
end
--获取当前老板娘的模型
function ActivityHelper:GetCurActiveLandLadyModelPath()
    local iLandLadyID = self:GetCurActiveLandLady()
    local aklistLandLady = TB_PlayerInfoData and TB_PlayerInfoData[PlayerInfoType.PIT_LANDLADY]
    if aklistLandLady then 
        for iBaseid,akPlayerInfo in pairs(aklistLandLady) do 
            if akPlayerInfo.BaseID == iLandLadyID then 
                return akPlayerInfo.ModelPath 
            end 
        end 
    end
    return nil 
end
-- 获取当前活动免费使用的老板娘
function ActivityHelper:GetCurFestivalLandLady()
    local akActivityData = self:GetFestivalActivities()
    local iRetLandLadyID = 0
    for k,activityInfo in ipairs(akActivityData) do
        if activityInfo and activityInfo.Param3 and activityInfo.Param3 ~= 0 then 
            iRetLandLadyID = activityInfo.Param3 
            break 
        end
    end
    return iRetLandLadyID
end 
-- 获取当前显示的老板娘
function ActivityHelper:GetCurActiveLandLady()
    local iRetLandLadyID = self:GetCurFestivalLandLady()
    if iRetLandLadyID == 0 then 
        iRetLandLadyID = PlayerSetDataManager:GetInstance():GetLandLadyID()
    end 
    if iRetLandLadyID == 0 then 
        iRetLandLadyID = 1 
    end
    return iRetLandLadyID 
end
function ActivityHelper:HasFestivalRedPoint()
    if self:HasFestivalSignUpRedPoint() then
        return true 
    end 
    if self:HasFestivalDialyTaskRedPoint() then 
        return true 
    end 
    if self:HasFestivalExchangeRedPoint() then 
        return true 
    end 
    if self:HasFestivalMallRedPoint() then 
        return true 
    end 
    return false 
end 
function ActivityHelper:HasFestivalSignUpRedPoint()
    if not self.akActivityTBMap then 
        return false 
    end 
    local stampCurDate = GetCurServerTimeStamp()
    for i,tbActivity in ipairs(self:GetTBActivitiesByType(ActivityType.ACCT_Festival_SignIn,true) or {}) do 
        local iBaseID = tbActivity.BaseID
        local stampStartTime = os.time(
            {
                year = tonumber(tbActivity.StartDate.Year) or 0,
                month = tonumber(tbActivity.StartDate.Month) or 0,
                day = tonumber(tbActivity.StartDate.Day) or 0,
                hour = tonumber(tbActivity.StartTime.Hour) or 0,
                min = tonumber(tbActivity.StartTime.Minute) or 0,
                sec = tonumber(tbActivity.StartTime.Second) or 0
            }
        )
        local idiffdata = self.GetDiffDayEx(stampStartTime, stampCurDate) - 1
        if idiffdata < 0 then 
            idiffdata = 0 
        end 
        if self.akActivityInfo[iBaseID].iValue1 & (1 << idiffdata) == 0 then 
            return true 
        end 

    end 
    return false 
end 
function ActivityHelper:HasFestivalDialyTaskRedPoint()
    for i,tbActivity in ipairs(self:GetTBActivitiesByType(ActivityType.ACCT_Festival_DialyTask,true) or {}) do 
        local akActivity =  self.akActivityInfo[tbActivity.BaseID]
        local iCurActivePoint = akActivity.iValue1  --  当前活跃度
        local iCurActivePointGot = akActivity.iValue2  -- 领取情况
        local iBoxShowStage = 1 -- 宝箱的阶段
        local iRewardStageGot = 0 -- 已经领到的奖励阶段
        local iRewardStageShow = 0 -- 下一级（展示）奖励阶段
        local _iStagePoint = {}  -- 阶段表
        local map = {}
        while iCurActivePointGot > 0 do 
            iRewardStageGot = iRewardStageGot + 1
            iCurActivePointGot = iCurActivePointGot >> 1
        end 
        for iIndex,iPoint in ipairs(tbActivity.StageGoal) do 
            if not map[iPoint] then 
                _iStagePoint[#_iStagePoint+1] = iPoint
                map[iPoint] = true
            end 
        end 
        table.sort( _iStagePoint)
        iRewardStageShow  = _iStagePoint[iRewardStageGot+1] and (iRewardStageGot+1) or iRewardStageGot
        -- 能否获取
        if  iCurActivePoint >= _iStagePoint[iRewardStageShow] and iRewardStageGot ~= iRewardStageShow then 
            return true 
        end 
    end 
    return false 
end 
function ActivityHelper:HasFestivalExchangeRedPoint()
    return false 
end 
function ActivityHelper:HasFestivalMallRedPoint()
    local TBActivity = self:GetTBActivitiesByType(ActivityType.ACCT_Festival_Mall,true)
    if TBActivity and #TBActivity > 0 then 
        -- 先筛选出 节日表中允许的商品列表 且是只用银锭兑换的
        -- 然后获取商店列表 第一次则请求 （第一次请求这个也可以提出来，可复用）
        local mapShopid = {}
        for iActIndex =1,#TBActivity do 
            local tbActivity = TBActivity[iActIndex]
            for iParam,iShopID in ipairs(tbActivity.ParamN or {}) do 
                local rewardItems = tbActivity.RewardItems[iParam] or {}
                if not rewardItems.ItemId or rewardItems.ItemId == 0 then  
                    mapShopid[iShopID] = true 
                end 
            end 
        end 
        local rackList = ShoppingDataManager:GetInstance():GetShopData(RackItemType.RTT_FESTIVAL)
        if rackList then  
            for iIndex,dataMallItem in ipairs(rackList) do 
                -- 价格为0 且购买数量大于0
                if mapShopid[dataMallItem.uiShopID or 0] and dataMallItem.iFinalPrice == 0 and dataMallItem.iCanBuyCount > 0 then 
                    return true 
                end 
            end 
        else
            SendPlatShopMallQueryItem(RackItemType.RTT_FESTIVAL)
        end 
    end 
    return false 
end 
-----------------end  ---------- 节日活动 -----------
function ActivityHelper:GetPlayerReturnInfo()
    local akActivityData = self:GetShowActivity(nil,ActivityType.ACCT_BackFlow)
    -- 这里可能会有问题 当回流活动时间重叠的时候
    for k,v in ipairs(akActivityData) do
        local activityInfo = self.akActivityInfo[v.BaseID]
        if activityInfo and activityInfo.iValue3 ~= 0 then --用户未登陆天数
            self.iCurPlayerReturnActivityID = v.BaseID
            local iTime = activityInfo.iValue3
            local kStartDate = os.date("*t", iTime)
            self.iCurPlayerReturnACtivityEndTime = os.time({year = kStartDate.year, month = kStartDate.month, day = (kStartDate.day + v.Param1 - 1), hour = 23, min = 59, sec = 59})
            return activityInfo,self.iCurPlayerReturnACtivityEndTime
        end
    end
    return nil
end

function ActivityHelper:CheckIsPlayerReturnTask(iTaskID)
    local kActivityInfo = self.akActivityInfo[self.iCurPlayerReturnActivityID]
    if kActivityInfo == nil then
        return false
    end

    if kActivityInfo.dwActivityID ~= 0 then
        local activityBase = GetTableData('ActivityBase',kActivityInfo.dwActivityID)
        if activityBase then
            for k,iPlayerReturnTaskID in ipairs(activityBase.ParamTask) do 
                if iTaskID == iPlayerReturnTaskID then
                    return true
                end
            end
        end
    end

    return false
end

function ActivityHelper:GetPlayerReturnTimeLeft()
    local iTimeLeft = self.iCurPlayerReturnACtivityEndTime - GetCurServerTimeStamp()
    local iDay = math.floor(iTimeLeft / (86400)) 
    local iHour =  math.floor((iTimeLeft - (86400 * iDay) ) / 3600) 
    local iMin = math.floor((iTimeLeft - (86400 * iDay + iHour * 3600)) / 60)
    return iDay,iHour,iMin
end

function ActivityHelper:HasPlayerReturnRedPoint()
    local kActivityInfo = self.akActivityInfo[self.iCurPlayerReturnActivityID]
    if kActivityInfo == nil then
        return false
    end

    local iPrograss = kActivityInfo.iValue1
    local iGotState = kActivityInfo.iValue2 or 0
    local activityBase = GetTableData('ActivityBase',kActivityInfo.dwActivityID)
    for k,rewardItem in ipairs(activityBase.RewardItems) do 
        local tempItemData = TableDataManager:GetInstance():GetTableData("Item",rewardItem.ItemId)
        if tempItemData then
            local bGotReward = HasFlag(iGotState , k)
            if not bGotReward and iPrograss >= activityBase.RewardParams[k] then
                return true
            end
        end
    end

    return false
end

function ActivityHelper:GetActivityInfo(iActicityID)
    return self.akActivityInfo[iActicityID] or {}
end

-- 体验活动 回流活动 的任务数据 存储在百宝书任务里
function ActivityHelper:UpdatePreExperienceData(kRetData)
    local iNum = kRetData["iNum"]
    local kTableDataManager = TableDataManager:GetInstance()
    local bIsBackFlow = kRetData.eTaskType == STBTT_ACTIVITY_BACKFLOW
    local backFlowData = {}
	for i = 0,iNum or -1 do
		if i >= iNum then
			break
        end
        local kNewTask = kRetData["akTask"][i]
        local taskTypeID = kNewTask["dwTaskTypeID"]
        if bIsBackFlow and self.aiPlayerReturnTask[taskTypeID] ~= 1 and self:CheckIsPlayerReturnTask(taskTypeID) then --如果没有弹过提示
            local oldTask = self.akPreExperienceData[taskTypeID]
            local kTaskData = kTableDataManager:GetTableData("TreasureBookTask",taskTypeID)
            if oldTask then
                if kTaskData and oldTask.dwProgress < kTaskData.TargetProgress and kNewTask.dwProgress >= kTaskData.TargetProgress then
                    backFlowData[#backFlowData + 1] = kTaskData
                    self.aiPlayerReturnTask[taskTypeID] = 1
                else
                    self.aiPlayerReturnTask[taskTypeID] = 0
                end
            else
                if kNewTask.dwProgress >= kTaskData.TargetProgress then
                    self.aiPlayerReturnTask[taskTypeID] = 1
                else
                    self.aiPlayerReturnTask[taskTypeID] = 0
                end
            end
        end
        self.akPreExperienceData[taskTypeID] = kNewTask
    end
    
    if kRetData.eTaskType == STBTT_ACTIVITY then
        LuaEventDispatcher:dispatchEvent("UpdatePreExperienceData")
    elseif kRetData.eTaskType == STBTT_ACTIVITY_BACKFLOW then
        LuaEventDispatcher:dispatchEvent("UpdatePlayerReturnData")   
        if #backFlowData > 0 then
            OpenWindowImmediately("PlayerReturnTipUI", backFlowData)
        end
    elseif kRetData.eTaskType == STBTT_ACTIVITY_FESTIVAL_DIALY then
        LuaEventDispatcher:dispatchEvent("UpdateActivityInfo")   
    end

end

function ActivityHelper:UpdateTaskProgressData(iTaskID,iPrograss)
    --不是回流任务 或者已经弹过tips了 
    if  self.aiPlayerReturnTask[iTaskID] == nil or self.aiPlayerReturnTask[iTaskID] == 1 then
        return
    end

    local kTaskData = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
    if kTaskData then
        if self.aiPlayerReturnTask[iTaskID] ~= 1 and self:CheckIsPlayerReturnTask(iTaskID) then
            local oldTask = self.akPreExperienceData[iTaskID]
            if oldTask then
                if kTaskData and oldTask.dwProgress < kTaskData.TargetProgress and iPrograss >= kTaskData.TargetProgress then
                    self.aiPlayerReturnTask[iTaskID] = 1
                    OpenWindowImmediately("PlayerReturnTipUI", {kTaskData})
                end
            elseif iPrograss >= kTaskData.TargetProgress then
                self.aiPlayerReturnTask[iTaskID] = 1
                OpenWindowImmediately("PlayerReturnTipUI", {kTaskData})
            end
        end
    end
end

function ActivityHelper:GetPreExperienceData()
    return self.akPreExperienceData
end


function ActivityHelper:HasActivityRedPoint()
    if not self.akActivityInfo then
        return false
    end

    for activityID, _ in pairs(self.akActivityInfo) do
        if self:CheckActivityRedPoint(activityID) then
            return true
        end
    end

    return false
end

function ActivityHelper:CheckActivityRedPoint(activityID)
    if not activityID or not self.akActivityInfo then
        return false
    end

    local activityInfo = self.akActivityInfo[activityID]
    if not activityInfo or not activityInfo.dwActivityID then
        return false
    end

    if activityInfo.bEnabled ~= TBoolean.BOOL_YES then
        return false
    end

    local activityData = GetTableData('ActivityBase',activityID)
    if not activityData then
        return false
    end

    if not ActivityHelper.IsInActivityTime(activityData) then
        return false
    end

    local ret = false
    if activityData.Type == ActivityType.ACCT_PreExperience then
        ret = self:CheckPreExperienceRedPoint(activityInfo, activityData)
    elseif  activityData.Type == ActivityType.ACCT_Fund then
        ret = self:CheckFundRedPoint(activityInfo, activityData)
    end

    return ret
end

-- 检查基金内已解锁的各阶段是否有未领取的奖励
function ActivityHelper:CheckFundStageRedPoint(activityInfo,activityData,typeNum)
    -- 判断当前英雄版是否解锁
    local heroLevel = false
    -- 判断当前免费英雄版是否解锁
    local heroLevelByComplete = false
    local lockState = activityInfo.iValue1
    if (lockState == 1) then
        heroLevelByComplete = true
    elseif (lockState == 2) then
        heroLevel = true
    elseif (lockState == 3) then
        heroLevelByComplete = true
        heroLevel = true
    end
    -- 刷新 奖励获取状态
    local freeRewardGetState = activityInfo.iValue2
    local paidRewardGetState = activityInfo.iValue3
    local freeRewardGetStateList = {}
    local paidRewardGetStateList = {}
    local paidRewardMoreGetStateList = {}
    local getAllList = {}
    local getAllCount = 0
    for i=1,64 do
        local iCurValue1 = freeRewardGetState >> (i-1) & 1
        local iCurValue2 = paidRewardGetState >> (i-1) & 1
        freeRewardGetStateList[i] = iCurValue1
        if (i<=32) then
            paidRewardMoreGetStateList[i] = iCurValue2
        else
            paidRewardGetStateList[i-32] = iCurValue2
        end
    end
    local CanGotReward = function(index,freeItemGot)
        if typeNum >= activityData.StageGoal[index] then
            if freeItemGot == 0 then
                return true
            end
            if heroLevel and paidRewardGetStateList[index]==0 then
                return true
            end
            if heroLevelByComplete and paidRewardMoreGetStateList[index]==0 then
                return true
            end
        end
        return false
    end
    for i=1,10 do 
        if CanGotReward(i,freeRewardGetStateList[i]) then
            getAllList[getAllCount+1] = i
            getAllCount = getAllCount + 1
        end
    end
    if (getAllCount > 0) then 
        return true
    else
        return false
    end
end

-- 检查基金页签是否显示红点
function ActivityHelper:CheckFundRedPoint(activityInfo, activityData)
    if not activityInfo or not activityData then
        return false
    end

    local typeNum
    -- 再根据类型 获取阶段解锁需要的属性 eg 经脉、成就
    if (activityData.FundType == ActFundType.AFT_Achievement) then
        typeNum = AchieveDataManager:GetInstance():GetAllAchievePoint() or 0
    elseif (activityData.FundType == ActFundType.AFT_Meridian) then
        typeNum = MeridiansDataManager:GetInstance():GetSumLevel() or 0
    end

    -- 根据属性范围解锁不同阶段
    local activityBaseList = self:GetFundData()
    local activityBaseNowList = {}
    
    local nowStageCount = 0
    for k ,v in pairs(activityBaseList) do
        if v.FundType == activityData.FundType and typeNum >= v.StageAreaA then
            activityBaseNowList[nowStageCount+1] = v
            nowStageCount = nowStageCount + 1
        end  
    end

    -- 各阶段都检索刷新一遍
    for i=1,nowStageCount do
        local nowStageActivityBase = activityBaseNowList[i]
        local nowStageActivityInfo = self:GetActivityInfo(nowStageActivityBase.BaseID)
        if self:CheckFundStageRedPoint(nowStageActivityInfo,nowStageActivityBase,typeNum) then
            return true
        end
    end

    return false 
end


function ActivityHelper:CheckPreExperienceRedPoint(activityInfo, activityData)
    if not activityInfo or not activityData then
        return false
    end

    local ret = false
    local iCurValue = activityInfo.iValue1 or 0
    local iGotState = activityInfo.iValue2 or 0
    local iCount = (activityData.RewardParams and #activityData.RewardParams or 0)
    for i = 1 ,iCount do
        local bValueEnough = iCurValue >= activityData.RewardParams[i]
        local bGotReward = HasFlag(iGotState ,(i - 1))

        if not bGotReward and bValueEnough then
            ret = true
            break
        elseif not bValueEnough then
            break
        end
    end

    return ret
end

function ActivityHelper:RequestRedPointActivitys()
    local sendTypes = { [ActivityType.ACCT_PreExperience] = true ,[ActivityType.ACCT_Fund] = true,[ActivityType.ACCT_Festival_SignIn] = true,[ActivityType.ACCT_Festival_DialyTask] = true,[ActivityType.ACCT_Festival_Exchange] = true,[ActivityType.ACCT_Festival_Mall] = true }
    local sendActivityIDs = {} 

    local TB_ActivityBase = TableDataManager:GetInstance():GetTable("ActivityBase") 
    if TB_ActivityBase then 
        for baseID, activityBase in pairs(TB_ActivityBase) do 
            if sendTypes[activityBase.Type] and ActivityHelper.IsInActivityTime(activityBase) then
                table.insert(sendActivityIDs, baseID)
            end
        end
    end
    SendActivityOper(SAOT_REQUEST, 0, 0, 0, sendActivityIDs)
end

-------------------------------------
-- 活动Helper，静态类所以用.的形式调用
function ActivityHelper.GetDiffDayByDate(activityData)
    if activityData == nil then
        return 0
    end

    local startTime = os.time(
        {
            year = tonumber(activityData.StartDate.Year) or 0,
            month = tonumber(activityData.StartDate.Month) or 0,
            day = tonumber(activityData.StartDate.Day) or 0,
            hour = tonumber(activityData.StartTime.Hour) or 0,
            min = tonumber(activityData.StartTime.Minute) or 0,
            sec = tonumber(activityData.StartTime.Second) or 0
        }
    )
    local endTime = os.time(
        {
            year = tonumber(activityData.StopDate.Year) or 0,
            month = tonumber(activityData.StopDate.Month) or 0,
            day = tonumber(activityData.StopDate.Day) or 0,
            hour = tonumber(activityData.StopTime.Hour) or 0,
            min = tonumber(activityData.StopTime.Minute) or 0,
            sec = tonumber(activityData.StopTime.Second) or 0
        }
    )

    return math.floor((endTime - startTime) / 86400)
end
-- 获取加iAddDay后的日期
-- 返回data table
function ActivityHelper.GetAddDiffDay(activityData,iAddDay)
    if activityData == nil then
        return nil
    end
    local startTime = os.time(
        {
            year = tonumber(activityData.StartDate.Year) or 0,
            month = tonumber(activityData.StartDate.Month) or 0,
            day = tonumber(activityData.StartDate.Day) or 0,
            hour = tonumber(activityData.StartTime.Hour) or 0,
            min = tonumber(activityData.StartTime.Minute) or 0,
            sec = tonumber(activityData.StartTime.Second) or 0
        }
    )
    local endtime = startTime + (86400 * (iAddDay or 0)) 
    local retdata = os.date("*t",endtime)

    return retdata
end 
function ActivityHelper.IsInActivityTime(activityData)
    local tiem = GetCurServerTimeStamp()
    local wday = os.date("*t", tiem).wday
    if wday == 0 then
        wday = 7
    end
    --活动 可能一周内只有固定某几天开
    local bIsInWeek = false
    if activityData.WeekDays then
        for k,v in ipairs(activityData.WeekDays) do 
            if wday == v then
                bIsInWeek = true
                break
            end
        end
    else
        bIsInWeek =true
    end

    if not bIsInWeek then
        return
    end

    if not (activityData.StartDate and activityData.StartTime and activityData.StopDate and activityData.StopTime) then 
        return 
    end 

    local startTime = os.time(
        {
            year = tonumber(activityData.StartDate.Year) or 0,
            month = tonumber(activityData.StartDate.Month) or 0,
            day = tonumber(activityData.StartDate.Day) or 0,
            hour = tonumber(activityData.StartTime.Hour) or 0,
            min = tonumber(activityData.StartTime.Minute) or 0,
            sec = tonumber(activityData.StartTime.Second) or 0
        }
    )
    --任务生效时间于配置表内配置；活动时间比任务时间长，时间为1天
    local iDealyDay = 0
    if activityData.Type == ActivityType.ACCT_PreExperience then 
        iDealyDay = 0 -- 1天换算成s,暂时不加
    end
    local endTime = os.time(
        {
            year = tonumber(activityData.StopDate.Year) or 0,
            month = tonumber(activityData.StopDate.Month) or 0,
            day = tonumber(activityData.StopDate.Day) or 0,
            hour = tonumber(activityData.StopTime.Hour) or 0,
            min = tonumber(activityData.StopTime.Minute) or 0,
            sec = tonumber(activityData.StopTime.Second) or 0
        }
    )
    endTime = endTime + iDealyDay
    if tiem >= startTime and tiem < endTime then
        return true
    else
        return false
    end
end


-- 获取新门派签到活动的下次刷新时间
-- 刷新时间（隔天、活动即将开始、活动关闭）
function ActivityHelper.GetSignRefreshTime()
    local diffTime = nil
    local now = GetCurServerTimeStamp()
    local tableActivitySignList = TableDataManager:GetInstance():GetTable("ActivitySign") or {}
    for tempSignID, tempTableActivitySign in pairs(tableActivitySignList) do
        local state =
            ActivityHelper.GetState2(
            now,
            tempTableActivitySign.StartTime,
            tempTableActivitySign.EndTime,
            tempTableActivitySign.HideTime
        )

        if state >= 0 then
            diffTime = ActivityHelper.GetDiffTime(now, tempTableActivitySign.HideTime)
            local nextDayTime = ActivityHelper.GetNextDayDiffTime(now)
            -- 活动中
            diffTime = math.min(diffTime, ActivityHelper.GetNextDayDiffTime(now))
            break
        elseif state == -1 then
            -- 活动未开始
            diffTime = ActivityHelper.GetDiffTime(now, tempTableActivitySign.StartTime)
            break
        end
    end
    return diffTime
end

-- 获取新门派活动签到信息
-- ID: 轮次
-- Receive: 签到状态列表
-- Day: 签到天数
function ActivityHelper.GetSignInfo()
    -- 服务器轮次
    local flag = PlayerSetDataManager:GetInstance():GetSignInFlag() or 0
    local signID = flag & 63

    -- 客户端轮次
    local now = GetCurServerTimeStamp()
    local tableActivitySignList = TableDataManager:GetInstance():GetTable("ActivitySign") or {}
    local clientSignID = 0
    for tempSignID, tempTableActivitySign in pairs(tableActivitySignList) do
        local state = ActivityHelper.GetState(now, tempTableActivitySign.StartTime, tempTableActivitySign.HideTime)
        if state > 0 then
            -- 时间段内
            clientSignID = tempSignID
            break
        end
    end

    -- 比对轮次，不一样的话使用客户端轮次
    if (signID ~= clientSignID) then
        flag = 0
        signID = clientSignID

        dprint("[ActivitySignUI] => ServerSignID: " .. signID .. ", ClientSignID: " .. clientSignID)
    end

    local tableActivitySign = tableActivitySignList[signID] or {}
    -- 签到情况
    local diffDay = ActivityHelper.GetDiffDay(tableActivitySign.StartTime, tableActivitySign.EndTime)
    local signReceive = {}
    for i = 1, diffDay do
        signReceive[i] = ((flag >> (5 + i)) & 1) == 1
    end
    -- 签到天数
    local signDay =
        ActivityHelper.GetState2(
        now,
        tableActivitySign.StartTime,
        tableActivitySign.EndTime,
        tableActivitySign.HideTime
    )

    return {
        ID = signID,
        Receive = signReceive,
        Day = signDay,
        LastDay = signDay == diffDay
    }
end

-- 判断指定时间戳是否在时间段（A，B，C）的情况
-- 还未到A: -1
-- 超过C: -2
-- B-C: 0
-- A-B: 相对于A的天数（从1开始）
function ActivityHelper.GetState2(time, startTimeStr, endTimeStr, hideTimeStr)
    local state = ActivityHelper.GetState(time, startTimeStr, endTimeStr)

    -- 超过B的再处理下
    if state == -2 then
        if (not hideTimeStr) or hideTimeStr == "" then
            return -1
        end

        local hideTime = ActivityHelper.GetFormatTime(hideTimeStr)

        -- B-C
        if time < hideTime then
            return 0
        end
    end

    return state
end

-- 判断指定时间戳是否在时间段（A，B）的情况
-- 还未到A: -1
-- 超过B: -2
-- A-B: 相对于A的天数（从1开始）
function ActivityHelper.GetState(time, startTimeStr, endTimeStr)
    if (not startTimeStr) or startTimeStr == "" or (not endTimeStr) or endTimeStr == "" then
        return -1
    end
    local startTime = ActivityHelper.GetFormatTime(startTimeStr)
    local endTime = ActivityHelper.GetFormatTime(endTimeStr) - 1

    if time < startTime then
        return -1
    elseif time >= endTime then
        return -2
    else
        return ActivityHelper.GetDiffDayEx(startTime, time)
    end
end

-- 获取指定时间相对起始时间的天数，从1开始，即当天为1
-- 还未开始: 0
function ActivityHelper.GetDiffDay(startTimeStr, endTimeStr)
    if (not startTimeStr) or startTimeStr == "" or (not endTimeStr) or endTimeStr == "" then
        return -1
    end

    local startTime = ActivityHelper.GetFormatDay(startTimeStr)
    local endTime = ActivityHelper.GetFormatDay(endTimeStr)

    local diffTime = os.difftime(endTime, startTime)

    if diffTime < 0 then
        return 0
    end

    return math.max(math.floor(diffTime / 86400), 0) + 1
end

function ActivityHelper.GetDiffDayEx(startTime, endTime)
    if (not startTime) or (not endTime) then
        return -1
    end

    local diffTime = os.difftime(endTime, startTime)

    if diffTime < 0 then
        return 0
    end

    return math.max(math.floor(diffTime / 86400), 0) + 1
end

-- 获取2020-7-31 14:21:00形式的时间戳
function ActivityHelper.GetFormatTime(timeStr)
    local dateTime = string.split(timeStr or "", " ")
    local date = string.split(dateTime[1] or "", "-")

    -- 自动处理24点情况
    if dateTime[2] == "24:00:00" then
        dateTime[2] = "23:59:59"
    end
    local time = string.split(dateTime[2] or "", ":")

    return os.time(
        {
            year = tonumber(date[1]) or 0,
            month = tonumber(date[2]) or 0,
            day = tonumber(date[3]) or 0,
            hour = tonumber(time[1]) or 0,
            min = tonumber(time[2]) or 0,
            sec = tonumber(time[3]) or 0
        }
    )
end

-- 获取2020-7-31 14:21:00形式的凌晨0点时间戳
function ActivityHelper.GetFormatDay(timeStr)
    local dateTime = string.split(timeStr or "", " ")
    local date = string.split(dateTime[1] or "", "-")
    return os.time(
        {
            year = tonumber(date[1]) or 0,
            month = tonumber(date[2]) or 0,
            day = tonumber(date[3]) or 0,
            hour = 0,
            min = 0,
            sec = 0
        }
    )
end

-- 获取指定时间到下一天的时间间隔
function ActivityHelper.GetNextDayDiffTime(time)
    time = time or GetCurServerTimeStamp()

    local tab = os.date("*t", time)
    local nextDayTime =
        os.time(
        {
            day = tab.day,
            month = tab.month,
            year = tab.year,
            hour = 23,
            min = 59,
            sec = 59
        }
    ) + 1

    return math.max(os.difftime(nextDayTime, time), 0)
end

function ActivityHelper.GetDiffTime(time, endTimerStr)
    if (not endTimerStr) or endTimerStr == "" then
        return 0
    end

    local endTimer = ActivityHelper.GetFormatTime(endTimerStr)

    time = time or GetCurServerTimeStamp()
    return math.max(os.difftime(endTimer, time), 0)
end

return ActivityHelper
