EvolutionDataManager = class("EvolutionDataManager")
EvolutionDataManager._instance = nil

function EvolutionDataManager:ctor()
end

function EvolutionDataManager:GetInstance()
    if EvolutionDataManager._instance == nil then
        EvolutionDataManager._instance = EvolutionDataManager.new()
        EvolutionDataManager._instance:ResetManager()
    end

    return EvolutionDataManager._instance
end

function EvolutionDataManager:ResetManager()
    self.akEvolutionDatas = {}
    self.rivakeTime = 0
end

function EvolutionDataManager:UpdateNpcEvolutionData(kRetData)
    -- TODO 改变已经存在的演化参数
    self.akEvolutionDatas = self.akEvolutionDatas or {}
    local MemberList = {}
    for i=0, kRetData.iSize - 1 do
        local kNpcEvolutionData = kRetData.akEvolutionData[i]
        if kNpcEvolutionData then
            local uiNpcID = kNpcEvolutionData.uiNpcID
            local uiID = kNpcEvolutionData.uiID
            if not self.akEvolutionDatas[uiNpcID] then 
                self.akEvolutionDatas[uiNpcID] = {}
            end

            self.akEvolutionDatas[uiNpcID][uiID] = kNpcEvolutionData
            if kNpcEvolutionData and kNpcEvolutionData.uiType == NET_NAME_ID then 
                if kNpcEvolutionData.iParam2 == -1 then 
                    table.insert( MemberList, string.format('%d', kNpcEvolutionData.iParam1 ))
                end 
            end 
        end
    end
    if #MemberList > 0 then 
        NetCommonRank:QueryWithMember('1', MemberList);
    end 

    self:UpdateRivakeTime(kRetData.uiTime)

end

function EvolutionDataManager:UpdateRivakeTime(newRivakeTime)
    if newRivakeTime < 0 then
        newRivakeTime = 0
    end
    self.rivakeTime = newRivakeTime
    LuaEventDispatcher:dispatchEvent("UPDATE_RIVAKE_TIME")
end

function EvolutionDataManager:RemoveNpcEvolutionData(kRetData)
    for i=0, kRetData.iSize - 1 do
        local kNpcEvolutionData = kRetData.akEvolutionData[i]
        if kNpcEvolutionData then
            local uiNpcID = kNpcEvolutionData.uiNpcID
            local uiID = kNpcEvolutionData.uiID
            if self.akEvolutionDatas[uiNpcID] then 
                self.akEvolutionDatas[uiNpcID][uiID] = nil
            end
        end
    end
end

function EvolutionDataManager:GetEvolutionsByType(uiRoleID, eType)
    local akEvolutions = self.akEvolutionDatas[uiRoleID] or {}
    local akEvolutionsOut = {}
    local idx = 0
    for k,v in pairs(akEvolutions) do
        if (v.uiType == eType and v.uiNpcID == uiRoleID) then
            akEvolutionsOut[idx] = v
            idx = idx + 1
        end
    end
    return akEvolutionsOut
end

function EvolutionDataManager:GetOneEvolutionByType(uiRoleID, eType)
    local akEvolutions = self.akEvolutionDatas[uiRoleID] or {}
    local idx = 0
    for k,v in pairs(akEvolutions) do
        if (v.uiType == eType and v.uiNpcID == uiRoleID) then
            return v
        end
    end
    return nil
end

-- return map[uiRoleTypeID] = desid
function EvolutionDataManager:GetDispositionDesEvo(uiRoleID)
    local akEvolutions = self.akEvolutionDatas[uiRoleID] or {}
    local akEvolutionsOut = {}
    for k,v in pairs(akEvolutions) do
        if (v.uiType == NET_DISPOSITION_DES and v.uiNpcID == uiRoleID) then
            akEvolutionsOut[v.iParam1] = v.iParam2   
        end
    end
    return akEvolutionsOut
end

function EvolutionDataManager:GetEvolutionsByTypeOnlyLast(uiRoleID, eType)
    local akEvolutionsOut = self:GetEvolutionsByType(uiRoleID, eType)
    akEvolutionsOut = table_c2lua(akEvolutionsOut)
    if akEvolutionsOut and #akEvolutionsOut > 0 then
        return akEvolutionsOut[#akEvolutionsOut]
    end
    return nil
end

function EvolutionDataManager:GetRoleShopID(uiRoleID)
    local akRoleInfos = self.akEvolutionDatas[uiRoleID]
    if (akRoleInfos == nil) then
        return nil
    end
    local akEvolutions = self.akEvolutionDatas[uiRoleID]
    for k,v in pairs(akEvolutions) do
        if (v.uiType == NET_SHOP and v.uiNpcID == uiRoleID) then
            return v.iParam1
        end
    end
    return nil
end

-- 好感突破状态 0 未开始 1进行中 2已完成
function EvolutionDataManager:GetBreakLimitTaskFlag(uiRoleID)
    local akRoleInfos = self.akEvolutionDatas[uiRoleID]
    if (akRoleInfos == nil) then
        return 0
    end
    local akEvolutions = self.akEvolutionDatas[uiRoleID]
    for k,v in pairs(akEvolutions) do
        if (v.uiType == NET_BREAK_LIMIT and v.uiNpcID == uiRoleID) then
            return v.iParam1
        end
    end
    return 0
end

function EvolutionDataManager:GetRivakeTime()
    return self.rivakeTime
end
function EvolutionDataManager:GetLastMonthRivakeTimeYMD()
    local lastMonthTime = self:GetRivakeTime() - 3000
    if lastMonthTime < 0 then
        lastMonthTime = self:GetRivakeTime()
    end
    return EvolutionDataManager:GetRivakeTimeYMD(lastMonthTime)
end

function EvolutionDataManager:GetRivakeTimeYMD(rivakeTime, bKeepOri)
    rivakeTime = rivakeTime or self.rivakeTime
    local iYear = 0
    local iMonth = 0
    local iDay = 0
    local iHour = 0
    iHour = rivakeTime
    if (rivakeTime >= 36000) then
        iYear = math.floor(rivakeTime / 36000)
        iHour = iHour % 36000
    end

    if (iHour >= 3000) then
        iMonth = math.floor(iHour / 3000)
        iHour = iHour % 3000
    end

    if (iHour >= 100) then
        iDay = math.floor(iHour / 100)
        iHour = iHour % 100
    end
    bKeepOri = (bKeepOri == true)
    if bKeepOri == false then
        iYear = iYear + 1
        iMonth = iMonth + 1
        iDay = iDay + 1
        iHour = iHour + 1
    end
    return iYear, iMonth, iDay, iHour
end


function EvolutionDataManager:GetRemainDay()
    local _, _, curDay, _ = EvolutionDataManager:GetInstance():GetRivakeTimeYMD()
    if curDay == nil then
        return tostring(0)
    end
    local resDayStr 
    if math.fmod(curDay, 30) == 0 then
         resDayStr = tostring(1)
    else
         resDayStr = tostring(30 - math.fmod(curDay, 30) + 1)
    end
    return resDayStr or '0'
end

function EvolutionDataManager:GetRivakeTimeYMDText(rivakeTime, bKeepOri)
    local iYear, iMonth, iDay = self:GetRivakeTimeYMD(rivakeTime, bKeepOri)

    if iYear == 0 and iMonth == 0 and iDay == 0 then
        return '0日'
    end

    local text = ""
    if iYear > 0 then
        text = text..string.format("%.0f年", iYear)
    end
    if iMonth > 0 then
        text = text..string.format("%.0f月", iMonth)
    end
    if iDay > 0 then
        text = text..string.format("%.0f日", iDay)
    end

    return text
end

function EvolutionDataManager:GetLunarDate(iYear,iMonth,iDay)
	if not self.kNum2Ch then
		self.kNum2Ch = {['0'] = '零', ['1'] = '一', ['2'] = '二', ['3'] = '三', ['4'] = '四', ['5'] = '五', ['6'] = '六', ['7'] = '七', ['8'] = '八', ['9'] = '九'}
	end

    local strNum2Ch = function(strNum, bIsYear, bIsDay)
        if (not strNum) or (strNum == "") then
            return ""
        end
        bIsDay = (bIsDay == true)
        bIsYear = (bIsYear == true)

        if not self.kLunarStrCache then
            self.kLunarStrCache = {['year'] = {}, ['month'] = {}, ['day'] = {}}
        end
        local key = 'month'
        if bIsYear then
            key = 'year'
        elseif bIsDay then
            key = 'day'
        end
        if self.kLunarStrCache[key][strNum] then
            return self.kLunarStrCache[key][strNum]
        end

        local res = ""
		-- 10 在日期中直接译作 "初十"
        if (strNum == "10") and bIsDay then
            res = "初十"
            self.kLunarStrCache[key][strNum] = res
			return res
		end
        local iLen = string.len(strNum)
        local iLoopCount = 0
        local bFirstTen = false  -- 第一位就是十位
        for charNum in string.gmatch(strNum, "%d") do
			iLoopCount = iLoopCount + 1
            -- 几种特殊情况:
            -- 如果是翻译年, 那么直接逐位读取
			-- 十位上的1, 如果是两位数并且出现在首位, 那么叫做 "十", 否则叫做 "一"
            if (not bIsYear) and (charNum == '1') and (iLen == 2) and (iLoopCount == 1) then
                res = res .. "十"
				bFirstTen = true
			-- 十位上的2, 如果是两位数并且出现在首位, 并且不是20, 那么叫做 "廿", 否则叫做 "二"
			elseif (not bIsYear) and (charNum == '2') and (iLen == 2) and (strNum ~= "20") and (iLoopCount == 1) then
				res = res .. "廿"
			-- 个位上的0, 如果是两位数并且出现在末位, 那么叫做 "十", 否则叫做 "零", 如果第一位是1, 那么第二位的0不显示
			elseif (not bIsYear) and (charNum == '0') and (iLen == 2) and (iLoopCount == iLen) then
				res = res .. (bFirstTen and "" or "十")
            -- 其他的情况直接从数字对应到中文
            else
                local ch =  self.kNum2Ch[charNum] or ''
                -- 如果是个位数并且显示的是 日, 那么加上 初 字
                if (iLen == 1) and (bIsDay == true) then
                    ch = '初' .. ch
                end
                res = res .. ch
            end
        end
        self.kLunarStrCache[key][strNum] = res
        return res
    end
    
    local strRet = ""
    if iYear and (iYear > 0) then
        strRet = strRet .. strNum2Ch(tostring(math.floor(iYear)), true, false) .. "年"
    end
    if iMonth and (iMonth > 0) then
        strRet = strRet .. strNum2Ch(tostring(math.floor(iMonth))) .. "月"
    end
    if iDay and (iDay > 0) then
        strRet = strRet .. strNum2Ch(tostring(math.floor(iDay)), false, true)
    end

	return strRet
end