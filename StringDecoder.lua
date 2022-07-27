-- 将字符串解析为 number 数值
function DecodeNumber(str, taskID)
    if type(str) ~= 'string' then 
        return tonumber(str) or 0
    end
    taskID = taskID or TaskDataManager:GetInstance():GetCurTaskID()
    if TaskDynamicType_Revert[str] ~= nil then 
        local dynamicDataTypeKey = TaskDynamicType_Revert[str] or 0
        local value = TaskDataManager:GetInstance():GetTaskCustomDynamicData(taskID, dynamicDataTypeKey)
        if dnull(value) then 
            return tonumber(value)
        end
    end
    if TaskDataManager:GetInstance():GetTaskDynamicDataLogicKey(str) then
        local logicKey = TaskDataManager:GetInstance():GetTaskDynamicDataLogicKey(str)
        local value = TaskDataManager:GetInstance():GetTaskCustomDynamicData(taskID, logicKey)
        if dnull(value) then 
            return tonumber(value) 
        end
    end
    return tonumber(str) or 0
end

local function DecodeTaskDynamicData(code, taskID)
    if code == nil then
        return ''
    end
    taskID = taskID or TaskDataManager:GetInstance():GetCurTaskID()
    if TaskDynamicType_Revert[code] ~= nil then 
        local dynamicDataTypeKey = TaskDynamicType_Revert[code] or 0
        local value = TaskDataManager:GetInstance():GetTaskCustomDynamicData(taskID, dynamicDataTypeKey)
        if dnull(value) then 
            return tostring(value)
        end
    end
    if TaskDataManager:GetInstance():GetTaskDynamicDataLogicKey(code) then
        local logicKey = TaskDataManager:GetInstance():GetTaskDynamicDataLogicKey(code)
        local value = TaskDataManager:GetInstance():GetTaskCustomDynamicData(taskID, logicKey)
        if dnull(value) then
            return tostring(value)
        end
    end
    return tostring(code or '')
end

-- 根据数据类型与属性名称解析
local function DecodeDataFormat(enumCode, dataInfoList, taskID)
    local retStr = ''
    local decodeValue = ''
    -- 解析任务动态数据
    decodeValue = DecodeTaskDynamicData(enumCode, taskID)
    if type(dataInfoList) ~= 'table' then
        return tostring(decodeValue or '')
    end 
    for _, dataInfo in ipairs(dataInfoList) do
        local dataType = dataInfo.dataType
        local attrName = dataInfo.attrName
        if dataType == nil or attrName == nil then
            break
        end
        --特殊处理名字，因为有称号什么的
        if dataType == "Role" and attrName == "NameID" then
            decodeValue = RoleDataManager:GetInstance():GetRoleTitleAndName(tonumber(decodeValue) or 0, true, true)
            return decodeValue, true
        else
            if dataType == 'MazeAreaIndex' then
                local mazeID = MazeDataManager:GetInstance():GetCurMazeID()
                local areaIndex = tonumber(decodeValue) or -1
                local areaBaseData = MazeDataManager:GetInstance():GetAreaTypeDataByAreaIndex(mazeID, areaIndex - 1)
                if areaBaseData ~= nil and areaBaseData[attrName] ~= nil then 
                    decodeValue = areaBaseData[attrName]
                end
            else
                local dataID = tonumber(decodeValue) or 0
                local baseData = TableDataManager:GetInstance():GetTableData(dataType, dataID)
                if baseData ~= nil and baseData[attrName] ~= nil then 
                    decodeValue = baseData[attrName]
                end
            end
        end
    end
    return tostring(decodeValue or '')
end

-- 按照文字数据格式解析字符串
-- 语法规则 {枚举(最终类型)[数据类型.属性名称]} 最终类型支持 Language 和所有枚举类型
-- 语法样例 {int数值1} {当前任务(Language)[Task.NameID]} {9208[Item.BuyPrice]}
local function DecodeStringByDataFormat(codeStr, taskID)
    local dataAttrPattern = '%[(.-)%.(.-)%]'
    local finalTypePattern = '%((.-)%)'
    local enumPattern = '%{(.-)%}'
    
    local dataInfoList = {}
    for dataType, attrName in string.gmatch(codeStr, dataAttrPattern) do
        local dataInfo = {dataType = dataType, attrName = attrName}
        table.insert(dataInfoList, dataInfo) 
    end
    codeStr = string.gsub(codeStr, dataAttrPattern, '')
    local finalType = string.match(codeStr, finalTypePattern)
    codeStr = string.gsub(codeStr, finalTypePattern, '')
    local enumCode = string.match(codeStr, enumPattern)
    codeStr = string.gsub(codeStr, enumPattern, '')

    local finalValue, noMoreDecode = DecodeDataFormat(enumCode, dataInfoList, taskID)
    
    if noMoreDecode then
        return tostring(finalValue or '')
    end
    finalType = finalType or 'Language'
    if finalType ~= nil then 
        if finalType == 'Language' then 
            local languageID = tonumber(finalValue) or 0
            if languageID == 0 then 
                retStr = finalValue or ''
            else
                retStr = GetLanguageByID(languageID) or ''
            end
        elseif finalType == 'Int' then
            local intValue = tonumber(finalValue) or 0
            retStr = tostring(intValue or '')
        elseif finalType == 'PlayerName' then
            local playerID = tonumber(finalValue) or 0
            retStr = RoleDataManager:GetInstance():GetPlayerName(playerID)
        elseif type(_G[finalType .. '_Lang']) == 'table' then
            local enumValue = tonumber(finalValue)
            local languageID = _G[finalType .. '_Lang'][enumValue] or 0
            retStr = GetLanguageByID(languageID) or ''
        end
    else
        retStr = tostring(finalValue or '')
    end
    return retStr
end

-- 按照条件格式解析字符串
-- 语法规则 <IF-动态数据枚举-SHOW-显示内容>
-- 语法样例 <IF-int数值1-SHOW-你居然得到了倚天剑> <IF-ID数值1-SHOW-{ID数值1[Clan.NameID]}门派的>
local function DecodeStringByCondFormat(str, taskID)
    local pattern = '%<IF%-(.-)%-SHOW%-(.-)%>'
    local condEnumPattern = '%<IF%-(.-)%-'
    local condTrueContentPattern = '%-SHOW%-(.-)[%>%-]'
    local condFalseContentPattern = '%-ELSESHOW%-(.-)[%>%-]'

    local retStr = ''
    while string.find(str, pattern) and (string.find(str, condTrueContentPattern) or string.find(str, condFalseContentPattern)) do
        -- 提取格式关键字 
        local beginPos, condEndPos = string.find(str, condEnumPattern)
        local endPos = beginPos
        -- 检查最后的是 SHOW 还是 ELSESHOW
        local condTrueContentBeginPos, condTrueContentEndPos = string.find(str, condTrueContentPattern)
        local condFalseContentBeginPos, condFalseContentEndPos = string.find(str, condFalseContentPattern)
        condTrueContentBeginPos = condTrueContentBeginPos or 0
        condTrueContentEndPos = condTrueContentEndPos or 0
        condFalseContentBeginPos = condFalseContentBeginPos or 0
        condFalseContentEndPos = condFalseContentEndPos or 0
        -- 排除不相连的关键字
        if condTrueContentBeginPos ~= condFalseContentEndPos and condTrueContentBeginPos ~= condEndPos then 
            condTrueContentBeginPos = nil
            condTrueContentEndPos = nil
        end
        -- 排除不相连的关键字
        if condFalseContentBeginPos ~= condTrueContentEndPos and condFalseContentBeginPos ~= condEndPos then 
            condFalseContentBeginPos = nil
            condFalseContentEndPos = nil
        end
        if (condTrueContentEndPos or 0) > (condFalseContentEndPos or 0) then
            endPos = condTrueContentEndPos
        else 
            endPos = condFalseContentEndPos
        end
        local condEnumCode = string.match(str, condEnumPattern)
        local condTrueContent = string.match(str, condTrueContentPattern)
        local condFalseContent = string.match(str, condFalseContentPattern)
        retStr = retStr .. string.sub(str, 1, beginPos - 1)
        -- 获取动态数据
        local enumValue = tonumber(DecodeTaskDynamicData(condEnumCode, taskID))
        -- 如果数据存在, 显示内容
        if enumValue ~= nil and enumValue ~= 0 then 
            retStr = retStr .. DecodeString(condTrueContent, taskID)
        else
            retStr = retStr .. DecodeString(condFalseContent, taskID)
        end
        str = string.sub(str, endPos + 1) or ''
    end
    retStr = retStr .. str
    return retStr
end

-- 解析字符串
function DecodeString(str, taskID, npcTypeID)
    if type(str) ~= 'string' then 
        return tostring(str or '')
    end
    local retStr = ''
    local mainRoleName = RoleDataManager:GetInstance():GetMainRoleName()
    local nickName = ''
    if npcTypeID then
        local info = globalDataPool:getData("MainRoleInfo")
        if info and info["NpcNickName"] and info["NpcNickName"][npcTypeID] then
            mainRoleName = info["NpcNickName"][npcTypeID]
            nickName = mainRoleName
        end
    end

    if nickName ~= '' then
        -- 当主角拥有昵称时，将 [主角][少侠] 形式的转义符合并为单独的 [主角]，以免出现“老公少侠”的情况
        local NameRule = StringHelper:GetInstance():GetNameRule()
        for k,v in pairs(NameRule) do
            if string.find(str, v) then
                str = string.gsub(str, "MAINROLE".."%["..v.."%]", mainRoleName)
            end
        end
    end

    str = string.gsub(str, 'MAINROLE', mainRoleName)
    str = string.gsub(str, 'MAINNICK', nickName)
    while string.find(str, '%{.-%}') do 
        local beginPos, endPos = string.find(str, '%{.-%}')
        local code = string.sub(str, beginPos, endPos)
        retStr = retStr .. string.sub(str, 1, beginPos - 1)
        retStr = retStr .. tostring(DecodeStringByDataFormat(code, taskID))
        str = string.sub(str, endPos + 1) or ''
    end
    retStr = retStr .. str
    retStr = DecodeStringByCondFormat(retStr, taskID)
    return retStr
end


--根据ID获取对应 语言  LANGUAGE_TYPE c#中设置过来的
function GetLanguageByID(iID, taskID, nodecode, npcTypeID)
    local content = TableDataManager:GetInstance():GetTableData("Language", iID)
    if content then
        if nodecode then
            return content
        end
        if taskID then
            return DecodeString(content, taskID, npcTypeID)
        else
            return content
        end
    else
        if DEBUG_MODE then
            DRCSRef.LogWarning("Language表中 ID： " .. tostring(iID) .." 不存在;" .. debug.traceback())
        end
		return ""
	end
end
