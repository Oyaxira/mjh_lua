GuideDataManager = class("GuideDataManager")

GuideDataManager._instance = nil

local PushBackList = function(list, item)
    list[#list + 1] = item
end

function GuideDataManager:GetInstance()
    if GuideDataManager._instance == nil then
        GuideDataManager._instance = GuideDataManager.new()
        GuideDataManager._instance:Init()
    end
    return GuideDataManager._instance
end

function GuideDataManager:Init()
    self.allGuideList= {}
    self.curGuideList = nil
    self.debugrun = false
    self.inGuide = false
    self._GuideListData = reloadModule("Data/GuideList")
    self._GuideData = reloadModule("Data/Guide")
    local TB_GuideList = self._GuideListData --TableDataManager:GetInstance():GetTable("GuideList")
    for _, value in pairs(TB_GuideList) do
        local itemArray = value.GuideArray
        if value.AutoStart == TBoolean.BOOL_YES and #itemArray > 0 then
            value.curIdx = 1
            PushBackList(self.allGuideList, value)
        end
    end
end

--如果uiBaseID == 52或者3 时 则做一次延时处理
function GuideDataManager:StartGuideByID(uiBaseID)
    if tonumber(uiBaseID) == 52 then
        globalTimer:AddTimer(50, function()
            self:StartGuideByIDFunc(uiBaseID)
        end, 1)
    else
        self:StartGuideByIDFunc(uiBaseID)
    end
end

function GuideDataManager:StartGuideByIDFunc(uiBaseID)
    uiBaseID = tonumber(uiBaseID)
        local TB_GuideList = self._GuideListData --TableDataManager:GetInstance():GetTable("GuideList")
        local guidedata = TB_GuideList[uiBaseID]
        if guidedata then
            
            local bHas = false 
            for i,v in ipairs(self.allGuideList) do 
                if v.BaseID == uiBaseID then 
                    bHas = true 
                    break
                end 
            end 
            if not bHas then 
                PushBackList(self.allGuideList, guidedata)
            end 
            if guidedata.curIdx and guidedata.curIdx > 1 then 
                if DEBUG_MODE then
                    SystemTipManager:GetInstance():AddPopupTip('引导进行中，再次开启了该引导：'.. uiBaseID .. debug.traceback())
                end
            else
                guidedata.curIdx = 1
            end
            
            -- globalTimer:AddTimer(1000, function()
                self:TriggerGuideEvent(GuideEvent.GE_Null)
            -- end, 1)    
        end
end


function GuideDataManager:BattleMoveRoleClick(x,y)
    
end

function GuideDataManager:CheckGuideEvent(guideitemid, event, param1, param2)
    local config = self._GuideData[guideitemid]--TableDataManager:GetInstance():GetTableData("Guide",guideitemid)
    if config and config.GuideEvent == event then
        if config.Param1 == "" or config.Param1 == param1 then
            if config.Param2 == "" or config.Param2 == param2 then                        
                return true
            end
        end
    elseif config and config.GuideEvent == GuideEvent.GE_Null then
        return true
    end 
end

function GuideDataManager:ClearGuide(guideid)
    guideid = tonumber(guideid) or 0
    local playerid = tostring(globalDataPool:getData("PlayerID"))
    local TB_GuideList = self._GuideListData
    for _, value in pairs(TB_GuideList) do       
        if guideid == 0 or guideid == value.BaseID then
            local GuideKey = value.GuideKey
            if self:GetHaveDone(GuideKey) then 
                self:SetGuideConfig(GuideKey,true)
                value.curIdx = 1
            end 
        end
    end
end

function GuideDataManager:SetGuideConfig(GuideKey,bIfClear)
    if not GuideKey then return end 
    GuideKey = tonumber(GuideKey)
    local bHaveDone = self:GetHaveDone(GuideKey)
    if bIfClear then 
        if bHaveDone then 
            SendNewBirdGuideState(GuideKey,false)
        else 
            return 
        end 
    else
        if bHaveDone then 
            return 
        end 
        SendNewBirdGuideState(GuideKey,true)
    end 
    local playerinfo = globalDataPool:getData("PlayerInfo")
    if not playerinfo then return false end	-- 单机没有 info 数据
    local GuideConfig = playerinfo.auiGuideInfo -- c table 

    local iKey = math.floor((GuideKey - 1 ) / 31)  -- GuideConfig 的key 
    local iIndex = math.floor((GuideKey - 1 ) % 31) 
    GuideConfig[iKey] = GuideConfig[iKey] or 0
    if bIfClear then 
        GuideConfig[iKey] = GuideConfig[iKey] & ~(1 << iIndex) 
    else 
        GuideConfig[iKey] = GuideConfig[iKey] | (1 << iIndex) 
    end 
end

function GuideDataManager:GetHaveDone(GuideKey)
    if not GuideKey then return false end 
    GuideKey = tonumber(GuideKey)
    local playerinfo = globalDataPool:getData("PlayerInfo")
    if not playerinfo then return false end	-- 单机没有 info 数据
    local GuideConfig = playerinfo.auiGuideInfo -- c table 

    local iKey = math.floor((GuideKey - 1 ) / 31)  -- GuideConfig 的key 
    local iIndex = math.floor((GuideKey - 1 ) % 31) 
    if GuideConfig[iKey] and GuideConfig[iKey] > 0 then 
        if (GuideConfig[iKey] & (1 << iIndex)) > 0 then 
            return true  
        end 
    end 
    return false

end

function GuideDataManager:TriggerGuideEvent(event, param1, param2)
    if self.inGuide then
        return false
    end

    for i=#self.allGuideList, 1, -1 do
        local guidearray = self.allGuideList[i]
        local stepNum = #guidearray.GuideArray
    
        local haveDone = self:GetHaveDone(guidearray.GuideKey)
        if (self.debugrun or not haveDone ) and guidearray.curIdx <= stepNum then
            local guidestep = guidearray.GuideArray[guidearray.curIdx]
            local config = self._GuideData[guidestep]--TableDataManager:GetInstance():GetTableData("Guide",guidestep)
            if self:CheckGuideEvent(guidestep, event, param1, param2) then
                local bool_guide = false 
                local strUINAME = config and config.UIName
                if strUINAME and strUINAME ~= "" then
                    if 'BattleField' == strUINAME then 
                        strUINAME = 'BattleUI'
                    end 
                    local window = GetUIWindow(strUINAME)
                    if window and window:IsOpen()then
                        bool_guide = true 
                    end 
                elseif strUINAME == "" then
                    bool_guide = true 
                end
                if bool_guide then 
                    if self.curGuideList ~= nil and self.curGuideList.BaseID ~= guidearray.BaseID then 
                        self.NextGuideList = self.NextGuideList or {}
                        table.insert( self.NextGuideList, { guidearray,guidestep} )
                    else 
                        -- 同样的引导再次触发 是否需要替换
                        self.curGuideList = guidearray
                        self:DoGuide(guidestep)
                    end 
                end 
               
                return true
            end
        end
    end

    return false
end

function GuideDataManager:RunNext()
    self.inGuide = false
    if self.curGuideList then
        -- 执行引导操作
        self:RunGuideAction(self.curGuideList.GuideArray[self.curGuideList.curIdx])
        SendGuideLog(self.curGuideList.BaseID,self.curGuideList.curIdx)
        self.curGuideList.curIdx = self.curGuideList.curIdx + 1
        if self.curGuideList.curIdx > #self.curGuideList.GuideArray then
            self:GuideEnd()
            return
        end
    end
    if self.curGuideList == nil then 
        return 
    end 

    local nextid = self.curGuideList.GuideArray[self.curGuideList.curIdx]
    local config = self._GuideData[nextid]--TableDataManager:GetInstance():GetTableData("Guide",nextid)
    if nextid and nextid > 0 and config then
        
        if config.GuideEvent ~= GuideEvent.GE_Null then
            RemoveWindowImmediately("GuideUI")
        else
            self:DoGuide(nextid)  
        end
    else
        self:GuideEnd()
    end
end

function GuideDataManager:StopGuide()
    if self.inGuide then
        RemoveWindowImmediately("GuideUI",true)
    end
end


function GuideDataManager:ContinueGuide()
    if self.inGuide then
        OpenWindowImmediately("GuideUI", self.curConfig)
    end
end

function GuideDataManager:GuideEnd()
    local playerid = tostring(globalDataPool:getData("PlayerID"))
    -- SetConfig(playerid .. self.curGuideList.GuideKey, 1)
    self:SetGuideConfig(self.curGuideList.GuideKey)
    self.curGuideList.curIdx = 1
    self.curGuideList = nil
    self.inGuide = false
    RemoveWindowImmediately("GuideUI")
    if self.NextGuideList and #self.NextGuideList > 0 then 
        self.curGuideList = self.NextGuideList[1][1]
        self:DoGuide(self.NextGuideList[1][2])
        table.remove( self.NextGuideList, 1 )
    end
end

function GuideDataManager:DoGuide(guideitemid)
    local playerid = tostring(globalDataPool:getData("PlayerID"))
    if playerid and self.curGuideList and self.curGuideList.GuideKey then
        self:SetGuideConfig(self.curGuideList.GuideKey)
        -- SetConfig(playerid .. self.curGuideList.GuideKey, 1)
    end

    local config = self._GuideData[guideitemid]--TableDataManager:GetInstance():GetTableData("Guide",guideitemid)
    
    if config then
        if config.UIName ==  'BattleField' and BattleDataManager:GetInstance():GetBattleEndFlag() then 
            self:GuideEnd()
        else
            self.inGuide = true
            self.curConfig = config
            OpenWindowImmediately("GuideUI", config)
            if config and config.GuideRefreshUI then 
                local window = WindowsManager:GetInstance():GetUIWindow(config.GuideRefreshUI)
                if window and window.RefreshUIOnGuide then 
                    window:RefreshUIOnGuide()
                end
            end 
            local nextid = self.curGuideList.GuideArray[self.curGuideList.curIdx + 1]
            if not nextid or nextid == 0 then
                self.inGuide = false
            end
        end 
    end
end

function GuideDataManager:IsGuideRunning(guideListTypeID)
    if not self.curGuideList then
        return false
    end
    if guideListTypeID == nil then
        return self.inGuide 
    end 

    return self.curGuideList.BaseID == guideListTypeID
end

function GuideDataManager:RunGuideAction(guideTypeID)
    local TB_Guide = self._GuideData
    local guidedata = TB_Guide[guideTypeID]

    if not guidedata then
        return
    end

    local actionType = guidedata.GuideAction
    local actionArgs = guidedata.GuideActionArgs or {}

    if actionType == GuideActionType.GACT_SET_FINISH_FLAG then
        local finishFlag = actionArgs[1]
        local finishFlagValue = NoviceGuideFinishFlag_Revert[finishFlag]

        if finishFlagValue then
            SendSetNoviceGuideFlag(finishFlagValue)
        end
    end
end

function GuideDataManager:SetGuideFinishFlag(uiFlag)
    self.uiGuideFinishFlag = (uiFlag or 0)
end

function GuideDataManager:CheckGuideFinishFlag(eNGFFValue)
    if (not eNGFFValue) or (eNGFFValue <= 0) 
    or (not self.uiGuideFinishFlag) or (self.uiGuideFinishFlag == 0) then
        return false
    end
    return (self.uiGuideFinishFlag & (1 << eNGFFValue) ~= 0)
end

function GuideDataManager:Clear()

end

function GuideDataManager:OnDestroy()

end