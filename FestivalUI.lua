FestivalUI = class("FestivalUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local shopBuyLimitResetTypeRevert = {
    [ShopBuyLimitResetType.SBLRT_NULL] = "兑换次数:",
    [ShopBuyLimitResetType.SBLRT_DAILY] = "每日重置:",
    [ShopBuyLimitResetType.SBLRT_WEEKLY] = "每周重置:",
    [ShopBuyLimitResetType.SBLRT_MONTH] = "每月重置:",
}
local UPDATE_TYPE = 
{
    ["UI_ALL"] = 1,
    ["REQUEST_ALL"] = 2,
    ["REQUEST_SPECIALTASK"] = 3,
}

local INIT_TYPE = 
{
    ["SignIn"] = 1,
    ["DialyTask"] = 2,
    ["Exchange"] = 3,
    ["Mall"] = 4,
}

local TOGNAME_MAP 
function FestivalUI:ctor()
    self.obj_TogList = {}
    self.iUpdateFlag = 0 -- type : UPDATE_TYPE 刷新标记
    self.iInitedFlag = 0 -- type : UPDATE_TYPE 是否初始化过

    self.objs_MallItem = {}
    TOGNAME_MAP = {
        [ActivityType['ACCT_Festival_SignIn']] = '每日签到',
        [ActivityType['ACCT_Festival_DialyTask']] = '每日任务',
        [ActivityType['ACCT_Festival_Exchange']] = '活动兑换',
        [ActivityType['ACCT_Festival_Mall']] = '礼包福利',
    }
end

function FestivalUI:Create()
	local obj = LoadPrefabAndInit("ActivityCommonUI/ActivityCommonUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function FestivalUI:Init()    
    self.ItemIconUI = ItemIconUI.new()
    self.ItemDataManager = ItemDataManager:GetInstance()
    
    self.objActivityToggleContent = self:FindChild(self._gameObject,'ActivityToggle')
    self.comToggleGroup = self.objActivityToggleContent:GetComponent(DRCSRef_Type.ToggleGroup)

    self.objToggleBaseItem = self:FindChild(self.objActivityToggleContent,'Toggle')
    self.objToggleBaseItem:SetActive(false)

    self.objPanalSignIn = self:FindChild(self._gameObject,'ActivityPanel/Activity_type_sign')
    self.objPanalDialyTask = self:FindChild(self._gameObject,'ActivityPanel/Activity_type_task')
    self.objPanalExchange = self:FindChild(self._gameObject,'ActivityPanel/Activity_type_exchange')
    self.objPanalMall = self:FindChild(self._gameObject,'ActivityPanel/Activity_type_mall')

    self.dataFestivalActivities = ActivityHelper:GetInstance():GetFestivalActivities() or {}
    if #self.dataFestivalActivities == 0 then 
        self:CloseUI()
    end 
    table.sort( self.dataFestivalActivities, function(a,b)
        return a.Sort < b.Sort
    end  )

    self:AddEventListener('ONEVENT_REF_SHOPDATA', function(info)
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UI_ALL)
    end)
    self:AddEventListener('UpdateActivityInfo', function(info)
        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UI_ALL)
    end)
    self:AddEventListener('REQUEST_SHOPPINGLIST', function(info)
        SendPlatShopMallQueryItem(RackItemType.RTT_FESTIVAL)
    end)
    self:AddEventListener("ONEVENT_DIFF_DAY", function()
        self:RequestFestivalData(true)
    end)

    self:InitTogBtns()
end

function FestivalUI:RefreshUI()
end

function FestivalUI:GetTogName(akFestival)
    if not akFestival then 
        return ''
    end 
    if  akFestival.Param1 ~= 0 then 
        return GetLanguageByID(akFestival.Param1) or ''
    else
        return TOGNAME_MAP[akFestival.Type] or ''
    end 
end 

function FestivalUI:InitTogBtns()
    -- 初始化选项框
    self._objRedPoints = {}
    for iIndex,akFestival in ipairs(self.dataFestivalActivities or {}) do 
        local objToggle = CloneObj(self.objToggleBaseItem,self.objActivityToggleContent)
        self.obj_TogList[#self.obj_TogList +1]=objToggle
        objToggle:SetActive(true)

        local comTextLabel = self:FindChildComponent(objToggle,'Label',DRCSRef_Type.Text)
        comTextLabel.text = self:GetTogName(akFestival)

        local comBtnTog = objToggle:GetComponent(DRCSRef_Type.Toggle)
        comBtnTog.group = self.comToggleGroup
        comBtnTog.isOn = false

        local objCheckmark = self:FindChild(objToggle,'Background/Checkmark')
        objCheckmark:SetActive(false)

        local objRedPoint = self:FindChild(objToggle,'Image_redPoint')
        objRedPoint:SetActive(false)
        self._objRedPoints[akFestival.Type] = objRedPoint

        self:CommonBind(objToggle, function(gameObject,boolHide)
            -- 点击 标签 
            objCheckmark:SetActive(boolHide)            
            if boolHide then 
                self.akChosenFestival = akFestival
                self.sortIndexMap_PanalExchange = nil
                self.sortIndexMap_Mall = nil 
                self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UI_ALL)
            end
        end)
        
    end 
    if not self.akChosenFestival and self.obj_TogList[1] then 
        self.obj_TogList[1]:GetComponent(DRCSRef_Type.Toggle).isOn = true 
    end 
end
function FestivalUI:RefreshRedPoints()
    for iType,objPoints in pairs(self._objRedPoints or {}) do 
        if iType == ActivityType.ACCT_Festival_SignIn then 
            objPoints:SetActive(ActivityHelper:GetInstance():HasFestivalSignUpRedPoint())
        elseif iType == ActivityType.ACCT_Festival_DialyTask then 
            objPoints:SetActive(ActivityHelper:GetInstance():HasFestivalDialyTaskRedPoint())
        elseif iType == ActivityType.ACCT_Festival_Exchange then 
            objPoints:SetActive(ActivityHelper:GetInstance():HasFestivalExchangeRedPoint())
        elseif iType == ActivityType.ACCT_Festival_Mall then 
            objPoints:SetActive(ActivityHelper:GetInstance():HasFestivalMallRedPoint())
        end 
    end 
end
function FestivalUI:RefreshChoosenPanal()
    if not self.akChosenFestival then 
        return 
    end
    
    if self.objPanalSignIn then self.objPanalSignIn:SetActive(false) end 
    if self.objPanalDialyTask then self.objPanalDialyTask:SetActive(false) end 
    if self.objPanalExchange then self.objPanalExchange:SetActive(false) end 
    if self.objPanalMall then self.objPanalMall:SetActive(false) end 
    self.dataInstActivityInfo = ActivityHelper:GetInstance():GetActivityInfo(self.akChosenFestival.BaseID)

    local stampStartTime = os.time(
        {
            year = tonumber(self.akChosenFestival.StartDate.Year) or 0,
            month = tonumber(self.akChosenFestival.StartDate.Month) or 0,
            day = tonumber(self.akChosenFestival.StartDate.Day) or 0,
            hour = tonumber(self.akChosenFestival.StartTime.Hour) or 0,
            min = tonumber(self.akChosenFestival.StartTime.Minute) or 0,
            sec = tonumber(self.akChosenFestival.StartTime.Second) or 0
        }
    )
    local stampCurDate = GetCurServerTimeStamp()
    self.idiffdata = ActivityHelper.GetDiffDayEx(stampStartTime, stampCurDate) 
    if self.idiffdata < 0 then 
        self.idiffdata = 0 
    end 
    self.bFestivalValue1 = false 
    self.bFestivalValue2 = false 
    if self.akChosenFestival.Type == ActivityType.ACCT_Festival_SignIn then 
        self:RefreshPanalSignIn()
    elseif self.akChosenFestival.Type == ActivityType.ACCT_Festival_DialyTask then
        self:RefreshPanalDialyTask()
    elseif self.akChosenFestival.Type == ActivityType.ACCT_Festival_Exchange then
        self:RefreshPanalExchange()
    elseif self.akChosenFestival.Type == ActivityType.ACCT_Festival_Mall then
        self:RefreshPanalMall()
    end
    -- 目前这个判断比较简单
    self:RefreshWindowBarType('bFestivalValue1',self.bFestivalValue1)
    self:RefreshWindowBarType('bFestivalValue2',self.bFestivalValue2)
end

-- 不同页签通用 初始化 替换界面下方时间
-- 传入页签和活动
function FestivalUI:InitTimeStrObj(ObjPar,akFestival)
    if not ObjPar or not akFestival then 
        return 
    end 
    local comText_time = self:FindChildComponent(ObjPar,'Text_time',DRCSRef_Type.Text)
    if comText_time then 
        comText_time.text = self:GetFestivalTimeStr(akFestival)
    end 
end 
-- 不同页签通用 初始化 替换界面左侧立绘
-- 传入页签和活动
function FestivalUI:InitImgLadyObj(ObjPar,akFestival)
    if not ObjPar or not akFestival then 
        return 
    end 
    local comImage_role = self:FindChildComponent(ObjPar,'Image_role',DRCSRef_Type.Image)
    if comImage_role then 
        self:SetSpriteAsync(akFestival.ActPic,comImage_role)
    end 
end 
-- 不同页签通用 刷新 windowbar
-- 传入要显示的类型
function FestivalUI:RefreshWindowBarType(strType,bShow)
    if not strType then 
        return 
    end 
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI and windowBarUI:IsOpen() then
        local windowInfo = windowBarUI:GetCurAssociateWindowInfo()
        windowInfo.topBtnState = windowInfo.topBtnState or {}
        windowInfo.topBtnState[strType] = bShow or false
        windowBarUI:UpdateWindow()
    end 
end 
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- 签到活动 初始化 
function FestivalUI:InitPanalSignIn()
    if HasFlag(self.iInitedFlag,INIT_TYPE.SignIn) then 
        return 
    end 
    self.objSC_panalSignIn = self:FindChild(self.objPanalSignIn,'SC_sign')
    self.comSCloopscrollview_panalSignIn = self.objSC_panalSignIn:GetComponent(DRCSRef_Type.LoopHorizontalScrollRect)
    if self.comSCloopscrollview_panalSignIn then
        self.comSCloopscrollview_panalSignIn:AddListener(function(...) self:OnPanalSignInItemChanged(...) end)
    end
    self:InitImgLadyObj(self.objPanalSignIn,self.akChosenFestival)
    self:InitTimeStrObj(self.objPanalSignIn,self.akChosenFestival)
    self.iInitedFlag = SetFlag(self.iInitedFlag,INIT_TYPE.SignIn)
end
-- 签到活动 刷新
function FestivalUI:RefreshPanalSignIn()
    self.objPanalSignIn:SetActive(true)
    self:InitPanalSignIn() 
    self.comSCloopscrollview_panalSignIn.totalCount = #self.akChosenFestival.RewardItems
    
    if self.bviewPanalSignInFirst then 
        self.comSCloopscrollview_panalSignIn:RefreshCells() 
    else
        self.bviewPanalSignInFirst = true 
        self.comSCloopscrollview_panalSignIn:RefillCells()
        local diff = math.max( self.idiffdata -1 ,0 )
        self.comSCloopscrollview_panalSignIn:SrollToCell(diff,150 * diff)
    end 
end
-- 签到活动 滚动栏单例刷新
function FestivalUI:OnPanalSignInItemChanged(transform,index)
    local iCurIndex = index + 1
    local ObjSignIn = transform.gameObject

    local comTextSignInNumber = self:FindChildComponent(ObjSignIn,'Text_number',DRCSRef_Type.Text)
    comTextSignInNumber.text = self:DaySringExchange(iCurIndex)

    local tableShowData = ActivityHelper.GetAddDiffDay(self.akChosenFestival,index)
    local strData = string.format( "%s月%s日",self:DaySringExchange(tableShowData.month),self:DaySringExchange(tableShowData.day))
    local comTextSignInDAay = self:FindChildComponent(ObjSignIn,'Text_day',DRCSRef_Type.Text)
    comTextSignInDAay.text = strData

    local iHaveSignedFlag = self.dataInstActivityInfo.iValue1
    local bHasGotFlag = iHaveSignedFlag & (1 << index) > 0 

    local stampCurDate = GetCurServerTimeStamp()
    local tableCurDate = os.date("*t", stampCurDate)
    local objImage_today = self:FindChild(ObjSignIn,'Image_today')
    objImage_today:SetActive(tableCurDate.day == tableShowData.day and tableCurDate.month == tableShowData.month and not bHasGotFlag )

    local objImage_bottom_2 = self:FindChild(ObjSignIn,'Image_bottom_2')

    local iRewarditemID = self.akChosenFestival.RewardItems[iCurIndex].ItemId
    local iRewarditemNum = self.akChosenFestival.RewardItems[iCurIndex].ItemNum
    local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(iRewarditemID)
    local objItemIconUI =  self:FindChild(ObjSignIn,'ItemIconUI')
    self.ItemIconUI:UpdateUIWithItemTypeData(objItemIconUI, ItemTypeData)
    self.ItemIconUI:SetItemNum(objItemIconUI, iRewarditemNum > 1 and iRewarditemNum or '')

    local objImg_GotReward = self:FindChild(objItemIconUI,'GotReward')
    objImg_GotReward:SetActive(bHasGotFlag)

    local Image_miss = self:FindChild(ObjSignIn,'Image_miss')
    local bShowMiss = not bHasGotFlag
    local bDayAfter = false
    if tableCurDate.year < tableShowData.year then 
        bShowMiss = false 
        bDayAfter = true 
    elseif tableCurDate.year == tableShowData.year then 
        if tableCurDate.month < tableShowData.month  then 
            bShowMiss = false 
            bDayAfter = true
        elseif tableCurDate.month == tableShowData.month then 
            if  tableCurDate.day < tableShowData.day  then 
                bShowMiss = false 
                bDayAfter = true 
            elseif tableCurDate.day == tableShowData.day  then 
                bShowMiss = false 
            end 
        end 
    end
    Image_miss:SetActive(bShowMiss)
    objImage_bottom_2:SetActive(not bDayAfter)

    self:CommonBind(ObjSignIn,function()
        -- 点击 签到
        if not bShowMiss and not bHasGotFlag and not bDayAfter then 
            SendActivityOper(SAOT_EVENT, self.akChosenFestival.BaseID, SATET_FESTIVAL_SIGNIN, 0,0)
        end 
    end )
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- 每日任务 初始化
function FestivalUI:InitPanalDialyTask()
    if HasFlag(self.iInitedFlag,INIT_TYPE.DialyTask) then 
        return 
    end 
    self.objSC_panalDialyTask = self:FindChild(self.objPanalDialyTask,'SC_task')
    self.comSCloopscrollview_panalDialyTask = self.objSC_panalDialyTask:GetComponent(DRCSRef_Type.LoopVerticalScrollRect)
    if self.comSCloopscrollview_panalDialyTask then
        self.comSCloopscrollview_panalDialyTask:AddListener(function(...) self:OnPanalDialyTaskItemChanged(...) end)
    end

    self.objDailyTask_LeftPanal = self:FindChild(self.objPanalDialyTask,'Left_panel')
    self.comTextDailyTask_CurActivePoint = self:FindChildComponent(self.objPanalDialyTask,'Left_panel/Text_1',DRCSRef_Type.Text)
    self.comTextDailyTask_NextActivePoint = self:FindChildComponent(self.objPanalDialyTask,'Left_panel/Text_2',DRCSRef_Type.Text)

    self.objBtnDailyTask_GetTreasure = self:FindChild(self.objPanalDialyTask,'Left_panel/Treasure')
    self.objImageDailyTask_TreasureGet = self:FindChild(self.objPanalDialyTask,'Left_panel/Treasure/Image_get')
    self._objImageDailyTask_TreasureBox = {}
    for iIndex=1,4 do 
        self._objImageDailyTask_TreasureBox[iIndex] = self:FindChild(self.objPanalDialyTask,'Left_panel/Treasure/Image_'.. iIndex)
    end 
    self.comTextDailyTask_TreasureGet = self:FindChildComponent(self.objPanalDialyTask,'Left_panel/Treasure/Text_get',DRCSRef_Type.Text)

    self.objContentDailyTask_RewardNode = self:FindChild(self.objPanalDialyTask,'Left_panel/RewardNode')

    self.objContentDailyTask_BtnAll = self:FindChild(self.objPanalDialyTask,'Left_panel/Button_all')
    self:CommonBind(self.objContentDailyTask_BtnAll,function()
        -- 点击所有奖励
        OpenWindowImmediately('AllRewardWindowUI',{
            iStage = self.iDailyTask_RewardStageGot,
            activity = self.akChosenFestival,
        })
    end )
    self:InitImgLadyObj(self.objPanalDialyTask,self.akChosenFestival)
    self:InitTimeStrObj(self.objPanalDialyTask,self.akChosenFestival)
    self.iInitedFlag = SetFlag(self.iInitedFlag,INIT_TYPE.DialyTask)

end
-- 每日任务 刷新
function FestivalUI:RefreshPanalDialyTask()
    self.objPanalDialyTask:SetActive(true)
    self:InitPanalDialyTask() 
    self.akPreExperienceData = ActivityHelper:GetInstance():GetPreExperienceData() -- 获取任务
    self:RefreshPanalDialyTask_LeftPanal()

    self.dataList_DialyTask = {}
    for iIndex=1,#self.akChosenFestival.ParamDay do 
        if self.akChosenFestival.ParamDay[iIndex] == self.idiffdata then 
            self.dataList_DialyTask[#self.dataList_DialyTask + 1] = self.akChosenFestival.ParamTask[iIndex]
        end 
    end 


    self.comSCloopscrollview_panalDialyTask.totalCount = #self.dataList_DialyTask
    if self.bviewPanalDialyTaskFirst then 
        self.comSCloopscrollview_panalDialyTask:RefreshCells() 
    else
        self.bviewPanalDialyTaskFirst = true 
        self.comSCloopscrollview_panalDialyTask:RefillCells()
    end 


end
-- 每日任务 左侧宝箱奖励刷新
function FestivalUI:RefreshPanalDialyTask_LeftPanal()
    local iCurActivePoint = self.dataInstActivityInfo.iValue1  --  当前活跃度
    local iCurActivePointGot = self.dataInstActivityInfo.iValue2  -- 领取情况
    local iBoxShowStage = 1 -- 宝箱的阶段
    local iRewardStageGot = 0 -- 已经领到的奖励阶段
    local iRewardStageShow = 0 -- 下一级（展示）奖励阶段
    local _iStagePoint = {}  -- 阶段表
    local map = {}
    while iCurActivePointGot > 0 do 
        iRewardStageGot = iRewardStageGot + 1
        iCurActivePointGot = iCurActivePointGot >> 1
    end 
    for iIndex,iPoint in ipairs(self.akChosenFestival.StageGoal) do 
        if not map[iPoint] then 
            _iStagePoint[#_iStagePoint+1] = iPoint
            map[iPoint] = true
        end 
    end 
    table.sort( _iStagePoint)
    iRewardStageShow  = _iStagePoint[iRewardStageGot+1] and (iRewardStageGot+1) or iRewardStageGot
    -- TODO: 抽个表出来 200 400 600 800 4个阶段
    -- 先这么写 200一个阶段 [0,200] (200,400] (400,600] (600,800]
    iBoxShowStage = math.floor( (_iStagePoint[iRewardStageShow] + 199) / 200 )
    iBoxShowStage = iBoxShowStage == 0 and 1 or iBoxShowStage
    for iIndex,img in ipairs(self._objImageDailyTask_TreasureBox) do 
        img:SetActive(iIndex==iBoxShowStage)
    end 
    -- 能否获取
    local bCanGet = iCurActivePoint >= _iStagePoint[iRewardStageShow] and iRewardStageGot ~= iRewardStageShow
    self.comTextDailyTask_TreasureGet.text = ''
    self.objImageDailyTask_TreasureGet:SetActive(bCanGet)

    if self.objBtnDailyTask_GetTreasure then 
        self:CommonBind(self.objBtnDailyTask_GetTreasure,function()
            if iRewardStageGot == iRewardStageShow and #_iStagePoint == iRewardStageGot then 
                -- SystemUICall:GetInstance():Toast('当前凛寒值不足')
            elseif bCanGet then 
                SendActivityOper(SAOT_EVENT, self.akChosenFestival.BaseID, SATET_FESTIVAL_LIVENESS_ACHIEVE, 
                iRewardStageShow ,0)
            else 
                SystemUICall:GetInstance():Toast('当前凛寒值不足')
            end 
        end )
    end 

    -- TODO 兼容后面活动
    self.comTextDailyTask_CurActivePoint.text = string.format( "当前凛寒值:%d",iCurActivePoint)
    if iRewardStageGot == iRewardStageShow and #_iStagePoint == iRewardStageGot then 
        self.comTextDailyTask_NextActivePoint.text = '已获得所有奖励！' 
    elseif bCanGet then 
        self.comTextDailyTask_NextActivePoint.text = bCanGet and '点击宝箱领取奖励！' 
    else 
        self.comTextDailyTask_NextActivePoint.text = string.format( "凛寒值达到%d可领取奖励",_iStagePoint[iRewardStageShow])
    end 

    local _RewardList = {}
    for iIndex,iPoint in ipairs(self.akChosenFestival.StageGoal) do 
        if iPoint == _iStagePoint[iRewardStageShow] then 
            if self.akChosenFestival.StageGoal[iIndex] then 
                _RewardList[#_RewardList+1] = self.akChosenFestival.RewardItems[iIndex]
            end 
        end 
    end 

    for iIndex=1,self.objContentDailyTask_RewardNode.transform.childCount  do
        local objchild = self.objContentDailyTask_RewardNode.transform:GetChild(iIndex-1).gameObject
        if objchild then 
            if _RewardList[iIndex] then 
                local iRewarditemID = _RewardList[iIndex].ItemId
                local iRewarditemNum = _RewardList[iIndex].ItemNum
                objchild:SetActive(true)
                local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(iRewarditemID)
                self.ItemIconUI:UpdateUIWithItemTypeData(objchild, ItemTypeData)
                self.ItemIconUI:SetItemNum(objchild, iRewarditemNum > 1 and iRewarditemNum or '')    
                local objGotReward  = self:FindChild(objchild, "GotReward")
                objGotReward:SetActive(false)
            else
                objchild:SetActive(false)
            end 
        end 
    end

    self.iDailyTask_RewardStageGot = iRewardStageGot

end
-- 每日任务 任务单例刷新
function FestivalUI:OnPanalDialyTaskItemChanged(transform,index)
    local objDailyTask = transform.gameObject
    local iTaskID = self.dataList_DialyTask[index+1]

    local kTaskData = TableDataManager:GetInstance():GetTableData("TreasureBookTask",iTaskID)
    if not kTaskData then
        return
    end
    if kTaskData.TaskTypeA == TreasureTaskTypeA.TTTA_CumulativeTime then
        self.taskRequestMap = self.taskRequestMap or {}
        if not self.taskRequestMap[iTaskID] then 
            self.taskRequestMap[iTaskID] = true 
            self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.REQUEST_SPECIALTASK)
        end
    end

    local comText_task_desc = self:FindChildComponent(objDailyTask,'Text_task_desc',DRCSRef_Type.Text)
    comText_task_desc.text = GetLanguageByID(kTaskData.NameID)

    local comText_value = self:FindChildComponent(objDailyTask,'Text_value',DRCSRef_Type.Text)
    comText_value.text = kTaskData.ExpHandsel


    local iCompleteTime  = 0
    if self.akPreExperienceData[iTaskID] then
        iCompleteTime = self.akPreExperienceData[iTaskID].dwProgress
    end
    
    local comValueText = self:FindChildComponent(objDailyTask,"Progress/Value",DRCSRef_Type.Text)
    comValueText.text = iCompleteTime .."/".. kTaskData.TargetProgress
    local comProgressBar = self:FindChildComponent(objDailyTask,'Progress',DRCSRef_Type.Scrollbar)
    comProgressBar.size = iCompleteTime / kTaskData.TargetProgress

    local bTaskFinished = iCompleteTime >= kTaskData.TargetProgress
    local objRewardNode = self:FindChild(objDailyTask,'RewardNode')
    for iIndex = 1, objRewardNode.transform.childCount  do
        local objchild = objRewardNode.transform:GetChild(iIndex-1).gameObject
        if objchild then  
            local iRewarditemID = kTaskData.ItemReward[iIndex]
            local iRewarditemNum = kTaskData.ItemRewardSum[iIndex]
            
            if iRewarditemID and iRewarditemNum then 
                objchild:SetActive(true)
                local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(iRewarditemID)
                self.ItemIconUI:UpdateUIWithItemTypeData(objchild, ItemTypeData)
                self.ItemIconUI:SetItemNum(objchild, iRewarditemNum > 1 and iRewarditemNum or '')    
                local objGotReward  = self:FindChild(objchild, "GotReward")
                objGotReward:SetActive(bTaskFinished)
            else
                objchild:SetActive(false)
            end 
        end 
    end
    
    local objImage_done = self:FindChild(objDailyTask,'Image_done')
    objImage_done:SetActive(bTaskFinished)

end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- 活动兑换 初始化
function FestivalUI:InitPanalExchange()
    if HasFlag(self.iInitedFlag,INIT_TYPE.Exchange) then 
        return 
    end 
    self.objSC_panalExchange = self:FindChild(self.objPanalExchange,'SC_exchange')
    self.comSCloopscrollview_panalExchange = self.objSC_panalExchange:GetComponent(DRCSRef_Type.LoopVerticalScrollRect)
    if self.comSCloopscrollview_panalExchange then
        self.comSCloopscrollview_panalExchange:AddListener(function(...) self:OnPanalExchangeItemChanged(...) end)
    end
    self:InitImgLadyObj(self.objPanalExchange,self.akChosenFestival)
    self:InitTimeStrObj(self.objPanalExchange,self.akChosenFestival)
    self.iInitedFlag = SetFlag(self.iInitedFlag,INIT_TYPE.Exchange)
end
-- 活动兑换 刷新
function FestivalUI:RefreshPanalExchange()
    self.objPanalExchange:SetActive(true)
    self:InitPanalExchange() 
    -- 筛选出在本页的商品 map 
    if not self.map_ShopID_2_ItemList_4_Exchange then 
        self.map_ShopID_2_ItemList_4_Exchange = {}
        if self.akChosenFestival and self.akChosenFestival.ParamN then 
            for iIndex,iShopID in ipairs(self.akChosenFestival.ParamN) do 
                self.map_ShopID_2_ItemList_4_Exchange[iShopID] = self.akChosenFestival.RewardItems[iIndex] 
                self.map_ShopID_2_ItemList_4_Exchange[iShopID].iIndex = iIndex
            end 
        end 
    end
    local shopData = ShoppingDataManager:GetInstance():GetShopData(RackItemType.RTT_FESTIVAL);
    self.dataList_PanalExchange = {}
    if shopData then
        for iIndex,dataMallItem in ipairs(shopData) do 
            local rewardItem = self.map_ShopID_2_ItemList_4_Exchange[dataMallItem.uiShopID]
            if rewardItem then 
                self.dataList_PanalExchange[#self.dataList_PanalExchange + 1] = {
                    uiShopID = dataMallItem.uiShopID,
                    instData = dataMallItem,
                    rewardItemID = rewardItem.ItemId or 0,
                    rewardItemNum = rewardItem.ItemNum or 0,
                    iIndex = iIndex or 0,
                }
            end 
        end 
    else 
        SendPlatShopMallQueryItem(RackItemType.RTT_FESTIVAL)
    end 
    table.sort( self.dataList_PanalExchange,function(instData_a,instData_b)
        local a = instData_a.instData or {['iCanBuyCount'] = 0,['iSort'] = 0}
        local b = instData_b.instData or {['iCanBuyCount'] = 0,['iSort'] = 0}
        if self.sortIndexMap_PanalExchange then 
            return  (self.sortIndexMap_PanalExchange[a.uiShopID] or 0) < (self.sortIndexMap_PanalExchange[b.uiShopID] or 0)
        elseif (a.iCanBuyCount > 0 and b.iCanBuyCount > 0) then 
            return (a.iSort or 0) < (b.iSort or 0)
        else 
            return a.iCanBuyCount ~= 0
        end
    end )
    if not self.sortIndexMap_PanalExchange then 
        self.sortIndexMap_PanalExchange = {}
        for iIndex,data in ipairs(self.dataList_PanalExchange) do 
            self.sortIndexMap_PanalExchange[data.uiShopID or 0] = iIndex
        end 
    end 
    self.comSCloopscrollview_panalExchange.totalCount = #self.dataList_PanalExchange
    if self.bviewPanalExchangeFirst then 
        self.comSCloopscrollview_panalExchange:RefreshCells() 
    else
        self.bviewPanalExchangeFirst = #self.dataList_PanalExchange > 0 
        self.comSCloopscrollview_panalExchange:RefillCells()
    end 
end
-- 活动兑换 滚动栏单例刷新
function FestivalUI:OnPanalExchangeItemChanged(transform,index)
    local iCurIndex = index + 1
    local ObjExchange = transform.gameObject
    local childdata = self.dataList_PanalExchange[iCurIndex]
    if not childdata then 
        return 
    end 
    local dataMallItem = childdata.instData
    local Rackdata = TableDataManager:GetInstance():GetTableData("Rack",childdata.uiShopID)
    if not Rackdata then 
        return 
    end 

    local ItemTypeData = self.ItemDataManager:GetItemTypeDataByTypeID(dataMallItem.uiItemID)
    local objItemIconUI =  self:FindChild(ObjExchange,'ItemIconUI')
    -- 此处可以优化效率
    self.ItemIconUI:UpdateUIWithItemTypeData(objItemIconUI, ItemTypeData)

    local MartirialData2 = self.ItemDataManager:GetItemTypeDataByTypeID(childdata.rewardItemID)
    local comImgItem_2icon =  self:FindChildComponent(ObjExchange,'Costs/Item_2/Icon',DRCSRef_Type.Image)
    self:SetSpriteAsync(MartirialData2.Icon,comImgItem_2icon)
    local comTextItem2_Num = self:FindChildComponent(ObjExchange,'Costs/Item_2/Num',DRCSRef_Type.Text)
    comTextItem2_Num.text = childdata.rewardItemNum

    local comTextItem1_Num = self:FindChildComponent(ObjExchange,'Costs/Item_1/Num',DRCSRef_Type.Text)
    comTextItem1_Num.text = dataMallItem.iFinalPrice

    local objIcon_YinDing = self:FindChild(ObjExchange,'Costs/Item_1/Money/Icon_YinDing')
    local objIcon_JinDing = self:FindChild(ObjExchange,'Costs/Item_1/Money/Icon_JinDing')
    objIcon_JinDing:SetActive(dataMallItem.uiMoneyType == RackItemMoneyType.RIMT_GOLD) 
    objIcon_YinDing:SetActive(dataMallItem.uiMoneyType ~= RackItemMoneyType.RIMT_GOLD)

    local objItem_1 = self:FindChild(ObjExchange,'Costs/Item_1')
    objItem_1:SetActive(dataMallItem.iFinalPrice ~= 0)
    local objItem_2_add = self:FindChild(ObjExchange,'Costs/Item_2/add')
    objItem_2_add:SetActive(dataMallItem.iFinalPrice ~= 0)
    
    local comText_name = self:FindChildComponent(ObjExchange,'Text_name',DRCSRef_Type.Text)
    comText_name.text = Rackdata.ItemName
    comText_name.color = getRankColor(ItemTypeData.Rank)

    local objImage_done = self:FindChild(ObjExchange,'Image_done')
    objImage_done:SetActive(false)
    local objImage_none = self:FindChild(ObjExchange,'Image_none')
    objImage_none:SetActive(false)

    local objButton_sure = self:FindChild(ObjExchange,'Button_sure')

    local str_tips = '' 
    if dataMallItem.iFinalPrice > 0 then 
        local string_format1 = dataMallItem.uiMoneyType == RackItemMoneyType.RIMT_GOLD and '金锭' or '银锭'
        str_tips = string.format("是否花费%d%s", dataMallItem.iFinalPrice,string_format1)
        if childdata.rewardItemNum > 0 then 
            str_tips = string.format("%s和", str_tips)
            self.bFestivalValue1 = true 
        end
    else
        str_tips = '是否花费'
    end 
    if MartirialData2 then 
        str_tips = string.format( "%s%d%s兑换道具",str_tips,childdata.rewardItemNum,GetLanguageByID(MartirialData2.NameID) )
    else 
        str_tips = string.format( "%s兑换道具",str_tips)
    end
    local buyFunc = function()
        SendActivityOper(SAOT_EVENT, self.akChosenFestival.BaseID, SATET_FESTIVAL_EXCHANGE, math.max((childdata.iIndex or 0) -1,0) ,0)
    end
    self:CommonBind(
        objButton_sure,
        function()
            -- 点击 兑换奖励
            OpenWindowImmediately(
                "GeneralBoxUI",
                {
                    GeneralBoxType.COMMON_TIP,
                    str_tips,
                    function()
                        if dataMallItem.uiMoneyType == RackItemMoneyType.RIMT_GOLD then 
                            PlayerSetDataManager:GetInstance():RequestSpendGold(
                                dataMallItem.iFinalPrice,
                                buyFunc
                            )
                        elseif dataMallItem.uiMoneyType == RackItemMoneyType.RIMT_SILVER then 
                            PlayerSetDataManager:GetInstance():RequestSpendSilver(
                                dataMallItem.iFinalPrice,
                                buyFunc
                            )
                        else
                            buyFunc()
                        end 
                    end
                }
            )
        end 
    )

    -- 描述这块抽出去 和mallitemui 可以复用
    local strLimitText = string.format( "%s%d/%d",shopBuyLimitResetTypeRevert[dataMallItem.iMaxBuyNumsPeriod],dataMallItem.iCanBuyCount,dataMallItem.iMaxBuyNums )
    local comText_time = self:FindChildComponent(objButton_sure,'Text_time',DRCSRef_Type.Text)
    comText_time.text = strLimitText

    local objImage_none = self:FindChild(ObjExchange,'Image_none')
    local objImage_done = self:FindChild(ObjExchange,'Image_done')
    objImage_none:SetActive(dataMallItem.iCanBuyCount == 0)
    objImage_done:SetActive(dataMallItem.iCanBuyCount == 0)
    objButton_sure:SetActive(dataMallItem.iCanBuyCount ~= 0)
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- 超值礼包 初始化
function FestivalUI:InitPanalMall()
    if HasFlag(self.iInitedFlag,INIT_TYPE.Mall) then 
        return 
    end 
    self.objScrollContent_panalMall = self:FindChild(self.objPanalMall,'SC_mall/Content')
    RemoveAllChildren(self.objScrollContent_panalMall)
    self:InitImgLadyObj(self.objPanalMall,self.akChosenFestival)
    self:InitTimeStrObj(self.objPanalMall,self.akChosenFestival)
    self.iInitedFlag = SetFlag(self.iInitedFlag,INIT_TYPE.Mall)
end
-- 超值礼包 刷新 
function FestivalUI:RefreshPanalMall()
    self.objPanalMall:SetActive(true)
    self:InitPanalMall() 
    -- 筛选出在本页的商品 map 
    if not self.map_ShopID_2_bHas_4_Mall then 
        self.map_ShopID_2_bHas_4_Mall = {}
        if self.akChosenFestival and self.akChosenFestival.ParamN then 
            for iIndex,iShopID in ipairs(self.akChosenFestival.ParamN) do 
                self.map_ShopID_2_bHas_4_Mall[iShopID] = self.akChosenFestival.RewardItems[iIndex] 
                self.map_ShopID_2_bHas_4_Mall[iShopID].iIndex = iIndex
            end 
        end 
    end
    local shopData = ShoppingDataManager:GetInstance():GetShopData(RackItemType.RTT_FESTIVAL);
    if shopData then
        self.dataList_PanalMall = {}
        for i =1,#shopData do 
            local rackdata = shopData[i]
            if self.map_ShopID_2_bHas_4_Mall[rackdata.uiShopID] then 
                self.dataList_PanalMall[#self.dataList_PanalMall+1] = rackdata
            end
        end
        table.sort(self.dataList_PanalMall,function(a,b)
            if self.sortIndexMap_Mall then 
                return (self.sortIndexMap_Mall[a.uiShopID] or 0) < (self.sortIndexMap_Mall[b.uiShopID] or 0 )
            elseif (a.iCanBuyCount > 0 and b.iCanBuyCount > 0) then 
                return (a.iSort or 0) < (b.iSort or 0)
            else 
                return a.iCanBuyCount ~= 0
            end
        end)
        if not self.sortIndexMap_Mall then 
            self.sortIndexMap_Mall = {}
            for iIndex,dataMallItem in ipairs(self.dataList_PanalMall) do 
                self.sortIndexMap_Mall[dataMallItem.uiShopID] = iIndex
            end
        end
        for iIndex,dataMallItem in ipairs(self.dataList_PanalMall) do 
            local rewardItem = self.map_ShopID_2_bHas_4_Mall[dataMallItem.uiShopID]
            if rewardItem then 
                local objMallItem = self.objs_MallItem[iIndex]
                if not objMallItem then 
                    -- MallItemUI可能会复用 拆出去了
                    objMallItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.MallItemUI,self.objScrollContent_panalMall.transform)
                    self.objs_MallItem[iIndex] = objMallItem
                end 
                if objMallItem then 
                    objMallItem._gameObject:SetActive(true)
                    objMallItem:SetMallItem(dataMallItem)
                    if rewardItem.ItemId ~= 0 then 
                        -- objMallIte 设置图片 
                        objMallItem:SetMoneyByItemid(rewardItem.ItemId)
                        objMallItem:SetMoneyNum(rewardItem.ItemNum)
                        if rewardItem.ItemNum > 0 then 
                            self.bFestivalValue2 = true 
                        end 
                    end
                    objMallItem:SetCallBackFunc(function()
                        SendActivityOper(SAOT_EVENT, self.akChosenFestival.BaseID, SATET_FESTIVAL_BUY_MALL, math.max((rewardItem.iIndex or 0) -1,0) ,0)
                    end)
                end 
            end
        end 
    else
        SendPlatShopMallQueryItem(RackItemType.RTT_FESTIVAL)
    end
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
function FestivalUI:LateUpdate()
    if self.iUpdateFlag ~= 0 then
        if HasFlag(self.iUpdateFlag,UPDATE_TYPE.UI_ALL) then
            -- 可能会置 self.iUpdateFlag 的 REQUEST_SPECIALTASK 位
            self:RefreshChoosenPanal()
            self:RefreshRedPoints()
        end
        if HasFlag(self.iUpdateFlag,UPDATE_TYPE.REQUEST_ALL) then
            -- 可能会置 self.iUpdateFlag 的 REQUEST_SPECIALTASK 位
            self:RequestFestivalData()
        end
        if HasFlag(self.iUpdateFlag,UPDATE_TYPE.REQUEST_SPECIALTASK) then
            if self.taskRequestMap then 
                for iTaskID,bUpdate in pairs(self.taskRequestMap) do
                    SendQueryTreasureBookInfo(STBQT_TASK, iTaskID,STBTT_ACTIVITY_FESTIVAL_DIALY)
                end 
            end
        end
        self.iUpdateFlag = 0
    end
end
function FestivalUI:SetCloseFunc(_callback)
    self.CloseFunc = _callback
end
function FestivalUI:CloseUI()
    self:RequestFestivalData()
    RemoveWindowImmediately("FestivalUI")
    if self.CloseFunc then 
        self.CloseFunc()
    end 
end
function FestivalUI:CommonBind(gameObject, callback)
    local btn = gameObject:GetComponent(DRCSRef_Type.Button);
    local tog = gameObject:GetComponent(DRCSRef_Type.Toggle);
    if btn then
        local _callback = function()
            callback(gameObject);
        end
        self:RemoveButtonClickListener(btn)
        self:AddButtonClickListener(btn, _callback);

    elseif tog then
        local _callback = function(boolHide)
            callback(gameObject, boolHide);
        end
        self:RemoveToggleClickListener(tog)
        self:AddToggleClickListener(tog, _callback)
    end
end
local tempClockSAOT_REQUEST
function FestivalUI:RequestFestivalData(bForce)
    if not tempClockSAOT_REQUEST or tempClockSAOT_REQUEST + 10 < os.time() or bForce then 
        for iIndex,akFestival in ipairs(self.dataFestivalActivities or {}) do 
            SendActivityOper(SAOT_REQUEST, akFestival.BaseID)
        end 
        SendQueryTreasureBookInfo(STBQT_TASK,0,STBTT_ACTIVITY_FESTIVAL_DIALY)
        SendPlatShopMallQueryItem(RackItemType.RTT_FESTIVAL)
        tempClockSAOT_REQUEST =  os.time() 

        self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.REQUEST_SPECIALTASK)
    end
end
function FestivalUI:OnEnable()
    self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UI_ALL)
    self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.REQUEST_ALL)
    OpenWindowBar({
        ['windowstr'] = "FestivalUI", 
        ['topBtnState'] = {
            ['bBackBtn'] = true,
            ['bGold'] = true,
            ['bSilver'] = true,
            ['bFestivalValue1'] = true,
            ['bFestivalValue2'] = true,
        },
        ['bSaveToCache'] = true,
        ["callback"] = function()
            self:CloseUI()
        end 
    })
end
function FestivalUI:OnDisable()
    RemoveWindowBar('FestivalUI')
end
function FestivalUI:OnDestroy()
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.objs_MallItem or {})
    self.ItemIconUI:Close()
    self:RemoveEventListener('ONEVENT_REF_SHOPDATA')
    self:RemoveEventListener('UpdateActivityInfo')
    self:RemoveEventListener('REQUEST_SHOPPINGLIST')
    self:RemoveEventListener('ONEVENT_DIFF_DAY')
end
local DaySringMap = {'一', '二', '三', '四', '五', '六', '七', '八', '九'}
function FestivalUI:DaySringExchange(iNum)
    iNum = iNum or 0 
    local str
    local iShiwei = math.floor(iNum/10)
    local iGewei = math.floor(iNum%10)
    str =  string.format('%s%s%s',(iShiwei > 1 and DaySringMap[iShiwei] or '')  , iShiwei > 0 and '十' or '' , (DaySringMap[iGewei] or ''))
    return str
end

function FestivalUI:GetFestivalTimeStr(activityData)
    str = string.format("活动时间：%d月%d日%02d:%02d - %d月%d日%02d:%02d",
    activityData.StartDate.Month,activityData.StartDate.Day,activityData.StartTime.Hour,activityData.StartTime.Minute,
    activityData.StopDate.Month,activityData.StopDate.Day,activityData.StopTime.Hour,activityData.StopTime.Minute)
    return str
end

return FestivalUI
