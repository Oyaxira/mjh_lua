AnimationMgr = class("AnimationMgr")
AnimationMgr._instance = nil


function AnimationMgr:GetInstance()
    if AnimationMgr._instance == nil then
        AnimationMgr._instance = AnimationMgr.new()
    end

    return AnimationMgr._instance
end

function AnimationMgr:ctor()
    self.co_wait_pool = {}
    self.timeScale = 1
    self.plotList = {}
end

function AnimationMgr:Update(deltaTime)
    deltaTime = deltaTime * self.timeScale
    if self.animList and #self.animList > 0 then 
        for i=1,#self.animList do
            local anim = self.animList[i]
            anim.cur = anim.cur + deltaTime
            for j=anim.index,#anim.list do
                if anim.list[j].startTime >= anim.cur then 
                    anim.list[j].func()
                    anim.index = j+1
                else
                    break
                end
            end
        end
    end
    if self.co_wait_pool and #self.co_wait_pool > 0 then 
        local tempPool = {}
        for i=1,#self.co_wait_pool do
            tempPool[i] = self.co_wait_pool[i]
        end
        for i=1,#tempPool do
            local coInfo = tempPool[i]
            coInfo.deltaTime = coInfo.deltaTime - deltaTime
            if coInfo.deltaTime <= 0 then 
                coInfo.dead = true
                if coroutine.status(coInfo.co) ~= "dead" then 
                    --xpcall(coroutine.resume,showError,coInfo.co)
                    assert(coroutine.resume(coInfo.co))
                end
            end
        end 
        for i=#self.co_wait_pool,1,-1 do
            if self.co_wait_pool[i].dead then 
                table.remove(self.co_wait_pool,i)
            end
        end
    end
end

----------------------- 使用轮询实现
function AnimationMgr:CreateAnimList()
    self.animList[#self.animList+1] = {['cur']=0,['sumTime']=0}
end

function AnimationMgr:AddAnimToCurList(anim)
    self:AddAnimToList(anim,self.animList[#self.animList])
end

function AnimationMgr:AddAnimToList(anim,list)
    anim.startTime = list.sumTime
    list.sumTime = list.sumTime + (anim.sumTime or 0)
    if anim.func then 
        list[#list+1] = anim
    end
end

-- func:动画函数，deltaTime:动画需要独占时间
function AnimationMgr:CreateAnim(func,deltaTime)
    return {['sumTime'] = deltaTime,['func'] = func}
end

function AnimationMgr:CreateAndAddAnim(func,deltaTime)
    return self:AddAnimToCurList(self:CreateAnim(func,deltaTime))
end

function AnimationMgr:WaitTime(deltaTime)
    self:AddAnimToCurList(self:CreateAnim(nil,deltaTime))
end

-----------------------END---------------------------------------------------------------
----------------------使用协程实现
function AnimationMgr:CreateAndRunAnim(func,...)
    -- func(...)
    -- do return end
    local co = coroutine.create(func)
    --assert(coroutine.resume,showError,co,...)
    assert(coroutine.resume(co,...))
end

function AnimationMgr:wait_time(deltaTime)
    -- do return end
    if deltaTime and deltaTime > 0 then 
        local co = coroutine.running()
        table.insert(self.co_wait_pool,{['co'] = co,['deltaTime'] = deltaTime})
        coroutine.yield()
    end
end

function AnimationMgr:clear()
    self.co_wait_pool = {}
end
--------------------END-----------------------------------------------------------------


--战斗开始plot
function AnimationMgr:ShowZhanDouKaiShiPlot()
    local plotList = self:GetPlotList(Event.Event_ZhanDouKaiShi)
    if plotList == nil or #plotList == 0 then 
        ProcessNextBattleMsg()
        return
    end
    for int_i=1,#plotList do
        self:ProcessPlot(plotList[int_i])
    end
    self:ClearPlotList(Event.Event_ZhanDouKaiShi)
end

function AnimationMgr:GetPlotList(eEventType)
    local key = tostring(eEventType)
    return self.plotList[key]
end

function AnimationMgr:ClearPlotList(eEventType)
    local key = tostring(eEventType)
    self.plotList[key] = {}
end

function AnimationMgr:ClearAll()
    -- print warning
    for k,v in pairs(self.plotList) do
        if #v > 0 then 
            dprint("-=-= has not play plot:",k,#v)
        end
    end
    self.plotList = {}
end
function AnimationMgr:AddPlot(plotInfo)
    local key = tostring(plotInfo.eEventType)
    if not self.plotList[key] then
        self.plotList[key] = {}
    end
    self.plotList[key][#self.plotList[key]+1] = plotInfo
end

function AnimationMgr:ProcessPlot(plotInfo)
    if not plotInfo then
        return
    end
    local plotData = PlotDataManager:GetInstance():GetPlotData(plotInfo.iPlotID)
    if not plotData and plotInfo.PlotType == 0 then
        WaitPlotEnd()
        return 
    end
    if not self:showBattlePlot(plotInfo.iPlotID,plotInfo,plotInfo.iPlotTaskID) then 
        WaitPlotEnd()
    end
end

function AnimationMgr:getAllPlot(plotId,list)
    local plotData = PlotDataManager:GetInstance():GetPlotData(plotId)
    if not plotData then 
        return 
    end
    if plotData.NextPlotIDList and #plotData.NextPlotIDList > 0 then
        list[#list+1] = plotData.NextPlotIDList[1]
        self:getAllPlot(plotData.NextPlotIDList[1],list)
    end
end

--显示对话
function AnimationMgr:showBattlePlot(plotId,plotData,plotTaskID)
    if plotId ~= 0 then 
        plotData = PlotDataManager:GetInstance():GetPlotData(plotId)
    end
    if not plotData then 
        return false
    end
    local list = {}
    self:getAllPlot(plotId,list)
    -- FIXME: 需要传递当前任务 ID 才能正确处理部分参数
    plotTaskID = plotTaskID or 0
    local ans = PlotDataManager:GetInstance():AddPlot(plotTaskID, plotId,plotData)
    for int_i = 1, #list do
        local res = PlotDataManager:GetInstance():AddPlot(plotTaskID, list[int_i])
        if not res then 
            ans = res
        end
    end
    return ans
end

function AnimationMgr:showBattleBubble(id, bubbleStr, iShowTime, unitIndex,toUnitIndex)
    iShowTime = 3--tonumber(iShowTime)  or 3 --处理气泡统一显示3秒
    if iShowTime < 1 then 
        iShowTime = 3
    end
    id = tonumber(id)
    unitIndex = tonumber(unitIndex)
    if id == 1 then
        id = MAINROLE_TYPE_ID --主角
    end
    bubbleStr = bubbleStr or ""
    if tonumber(bubbleStr) then 
        bubbleStr = GetLanguageByID(bubbleStr)
    end
    if bubbleStr ~= "" then
        local curTaskID = TaskDataManager:GetInstance():GetCurTaskID()
        bubbleStr = DecodeString(bubbleStr, curTaskID)

        if toUnitIndex ~= 0 then
            local p_unit = UnitMgr:GetInstance():GetUnit(toUnitIndex)
            if p_unit then
                bubbleStr = string.format(bubbleStr,p_unit:GetName())
            end
        end

        local tbl_role = TB_Role[id]
        if unitIndex and unitIndex ~= 0 then
            self:battle_show_bubble_special(unitIndex,bubbleStr,iShowTime)
        elseif tbl_role then 
            self:battle_show_bubble(id,bubbleStr,iShowTime)
        end
    end
end

--战斗_显示对话气泡_特定角色
function AnimationMgr:battle_show_bubble_special(unitIdx,bubbleStr,showtime)
    local p_unit = UnitMgr:GetInstance():GetUnit(unitIdx)
    if p_unit then
        p_unit:ShowBubble(bubbleStr,showtime)
    end
end

--战斗_显示对话气泡
function AnimationMgr:battle_show_bubble(roleTypeid,bubbleStr,showtime)
    local unitList = UnitMgr:GetInstance():GetAllUnit()
    if unitList then 
        for k,unitInfo in pairs(unitList) do
            if unitInfo and unitInfo:GetRoleTypeID() == roleTypeid then
                unitInfo:ShowBubble(bubbleStr,showtime)
                break
            end
        end
    end
end
-------------

--震动
function AnimationMgr:ShakeAction(twnAnim, twnObj, fTime, vstrength, seEase, onComplete)
    return Twn_ShakePosition(twnAnim, twnObj, fTime, vstrength, seEase, onComplete)
end

--移入
--face = 1向右移动 face = -1向左移动
function AnimationMgr:MoveInAction(twnAnim, twnObj, face, fRelativeMoveX, fEndValueX, fTime, seEase, onComplete)
    local rectTransform = twnObj:GetComponent("RectTransform")
    local pos = rectTransform.anchoredPosition
    face = face >= 0 and 1 or -1
    fRelativeMoveX = face > 0 and -fRelativeMoveX or fRelativeMoveX
    pos.x = fEndValueX - fRelativeMoveX
    rectTransform.anchoredPosition = pos
    return Twn_MoveX(twnAnim, twnObj,fRelativeMoveX , fTime, seEase, onComplete)
end

--移出
function AnimationMgr:MoveOutAction(twnAnim, twnObj, face, fRelativeMoveX, fTime, seEase, onComplete)
    face = face >= 0 and 1 or -1
    fRelativeMoveX = face > 0 and fRelativeMoveX or -fRelativeMoveX
    return Twn_MoveX(twnAnim, twnObj,fRelativeMoveX , fTime, seEase, onComplete)
end

--淡入淡出
function AnimationMgr:FadeAction(twnAnim, twnCom, fBeginValue, fEndValue, fTime, fDelay, seEase, onComplete)
    return Twn_Fade(twnAnim, twnCom, fBeginValue, fEndValue, fTime, fDelay, onComplete)
end

--变大
function AnimationMgr:ZoomAction(twnAnim, twnObj, fBeginValue, fEndValue, fTime, seEase, onComplete)
    return Twn_Scale(twnAnim, twnObj, fBeginValue, fEndValue, fTime, seEase, onComplete)
end


return AnimationMgr