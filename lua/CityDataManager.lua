CityDataManager = class("CityDataManager")
CityDataManager._instance = nil

function CityDataManager:GetInstance()
    if CityDataManager._instance == nil then
        CityDataManager._instance = CityDataManager.new()
        CityDataManager._instance:Init()
    end

    return CityDataManager._instance
end

function CityDataManager:GetCityData(cityID)
    local TB_City = TableDataManager:GetInstance():GetTable("City")
    return self.CityDataMap[cityID] or TB_City[cityID]
end

function CityDataManager:Init()
    self:ResetManager()
    self:InitCityPathDataDict()
    self:InitSpecialCityShowNameData()
end

function CityDataManager:InitCityPathDataDict()
    self.cityPathDataDict = {}
    local TB_CityPath = TableDataManager:GetInstance():GetTable("CityPath")
    for _, cityPath in pairs(TB_CityPath) do 
        local srcCityBaseID = cityPath.SrcCityID
        local dstCityBaseID = cityPath.DstCityID
        local storyID = cityPath.ScriptID
        local pathSearchKey = self:GetCityPathSearchKey(srcCityBaseID, dstCityBaseID)
        self.cityPathDataDict[storyID] = self.cityPathDataDict[storyID] or {}
        self.cityPathDataDict[storyID][pathSearchKey] = cityPath
    end
end

function CityDataManager:ResetManager()
    self.CityDataMap = {}
    self.delegationStartState = nil
end

local CityIndexFunction = function(t, k)
    local cityID = rawget(t, 'uiCityID')
    local TB_City = TableDataManager:GetInstance():GetTable("City")
    local cityData = TB_City[cityID]
    if cityData == nil then 
        return nil
    end
    return cityData[k]
end

function CityDataManager:UpdateCityData(cityID, newData)
    local cityData
    if self.CityDataMap[cityID] == nil then 
        cityData = {}
        setmetatable(cityData, {__index = CityIndexFunction})
        self.CityDataMap[cityID] = cityData
    else
        cityData = self.CityDataMap[cityID]
    end
    for k, v in pairs(newData) do 
        cityData[k] = v
    end
end

function CityDataManager:CheckCityRootMap(mapid)
    local TB_City = TableDataManager:GetInstance():GetTable("City")
    for cityID, cityData in pairs(TB_City) do 
		if cityData.EnterMapID == mapid then 
			return cityID
		end
	end
	return nil
end

function CityDataManager:GetCurCityID()
    local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
	if not (mainRoleInfo ~= nil and mainRoleInfo["MainRole"] ~= nil) then 
		return 0
	end
	local cityID = mainRoleInfo["MainRole"][MRIT_CUR_CITY]
    if true then --cityID & 0x10000000 ~= 0
        local city = TileDataManager:GetInstance():GetCurCity(cityID & 0xfffffff)
        if city then return city.BaseID end
    else
        return cityID
    end
end

function CityDataManager:GetCurClanTypeID()
	local uiMapID = MapDataManager:GetInstance():GetCurMapID()
	local uiClanTypeID = MapDataManager:GetInstance():GetClanTypeIDByMapID(uiMapID)
	return uiClanTypeID
end

function CityDataManager:GetEnterMapID(enterCityID)
    local TB_City = TableDataManager:GetInstance():GetTable("City")
    for cityID, cityData in pairs(TB_City) do 
        if cityID == enterCityID then 
            return cityData.EnterMapID
        end
	end
	return 0
end

function CityDataManager:GetCurCityData()
    local uiCityID = self:GetCurCityID()
    return self:GetCityData(uiCityID)
end

function CityDataManager:GetCurCityWeatherID()
    local cityID = self:GetCurCityID()
    return self:GetCityWeatherID(cityID)
end

function CityDataManager:GetCityWeatherID(cityID)
    local cityData = self:GetCityData(cityID)
    if cityData == nil then 
        return 0
    end
    return cityData.uiWeatherID or 0
end

function CityDataManager:GetRoleListInCurCity()
    local cityID = self:GetCurCityID()
    return self:GetRoleListInCity(cityID)
end

function CityDataManager:GetRoleListInCity(cityID)
    local cityData = self:GetCityData(cityID)
    if not cityData then 
        return 
    end
    local rootMapID = cityData.EnterMapID
    return MapDataManager:GetInstance():GetRoleListInMapTree(rootMapID)
end

function CityDataManager:GetRolePositionDataListInCurCity()
    -- 先判断当前地图是不是异次元地图
    local curMapID = MapDataManager:GetInstance():GetCurMapID()
    if curMapID ~= 0 and MapDataManager:GetInstance():GetParentMapID(curMapID) == 0 then 
        -- 异次元地图, 只返回该地图的角色
        return MapDataManager:GetInstance():GetRolePositionDataListInCity(curMapID)
    else
        local cityID = self:GetCurCityID()
        return self:GetRolePositionDataListInCity(cityID)
    end
end

function CityDataManager:GetRolePositionDataListInCity(cityID)
    local cityData = self:GetCityData(cityID)
    if not cityData then 
        return 
    end
    local rootMapID = cityData.EnterMapID
    return MapDataManager:GetInstance():GetRolePositionDataListInCity(rootMapID)
end

--播放城市开场动画
function CityDataManager:RunCityOpenAnim(mapId)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_ENTER_CITY, false, mapId)
end

function CityDataManager:GetCityPathSearchKey(srcCityBaseID, dstCityBaseID)
    return tostring(srcCityBaseID) .. '-' .. tostring(dstCityBaseID)
end

-- 获取城市路径
function CityDataManager:GetCityPath(srcCityBaseID, dstCityBaseID)
    local curStoryID = GetCurScriptID()
    local searchKey = self:GetCityPathSearchKey(srcCityBaseID, dstCityBaseID)
    if self.cityPathDataDict == nil or self.cityPathDataDict[curStoryID] == nil or self.cityPathDataDict[curStoryID][searchKey] == nil then 
        derror('找不到城市路径, 如果没有转表错误, 请联系策划检查配置 剧本:' .. tostring(curStoryID) .. '  起点城市:' .. tostring(srcCityBaseID) .. '  终点城市:' .. tostring(dstCityBaseID))
        return {}
    end
    local cityPathData = self.cityPathDataDict[curStoryID][searchKey]
    local passCityList = cityPathData.PassCityIDs or {}
    local cityPath = {}
    table.move(passCityList, 1, #passCityList, 1, cityPath)
    table.insert(cityPath, cityPathData.DstCityID)
    return cityPath
end

-- 获取城市距离
function CityDataManager:GetCityMoveCostTime(srcCityBaseID, dstCityBaseID)
    local itemDataManagerInstance = ItemDataManager:GetInstance()
    local distance = self:GetCityMinDistance(srcCityBaseID, dstCityBaseID)
    local cityMoveTimeFactor = 10000
    local bagItems = itemDataManagerInstance:GetPackageItems(nil, nil, nil, nil, false)
    if bagItems ~= nil then
        for _, itemID in ipairs(bagItems) do 
            local horseCityMoveTimeFactor = itemDataManagerInstance:GetHorseCityMoveTimeFactor(itemID)
            if horseCityMoveTimeFactor ~= 0 and horseCityMoveTimeFactor < cityMoveTimeFactor then 
                cityMoveTimeFactor = horseCityMoveTimeFactor
            end
        end
    end
    cityMoveTimeFactor = cityMoveTimeFactor / 10000
    local costTime = distance * cityMoveTimeFactor
    -- 保留一位小数
    costTime = math.floor(costTime * 10) / 10
    if costTime / math.floor(costTime) == 1 then 
        costTime = math.floor(costTime)
    end
    return costTime
end

-- 获取城市距离
function CityDataManager:GetCityMinDistance(srcCityBaseID, dstCityBaseID)
    local cityPath = self:GetCityPath(srcCityBaseID, dstCityBaseID)
    return #cityPath
end

-- 获取城市相关所有路径节点名称
function CityDataManager:GetCityAllPathNodeName(cityBaseID)
    local pathNodeNameList = {}
    for _, pathNodeData in pairs(CityPathNodeDataDict) do 
        if cityBaseID == nil or pathNodeData.SrcCityBaseID == cityBaseID or pathNodeData.DstCityBaseID == cityBaseID then
            table.insert(pathNodeNameList, pathNodeData.PathNodeName)
        end
    end
    return pathNodeNameList
end

-- 获取城市路径节点名称
function CityDataManager:GetCityPathNodeName(srcCityBaseID, dstCityBaseID)
    if srcCityBaseID == nil or dstCityBaseID == nil then 
        return nil
    end
    
    local searchKey = self:GetCityPathSearchKey(srcCityBaseID, dstCityBaseID)
    local pathNodeData = CityPathNodeDataDict[searchKey]
    if pathNodeData == nil then 
        return nil
    end
    return pathNodeData.PathNodeName, pathNodeData.IsReverse
end

-- 是否是海上城市
function CityDataManager:IsSeaCity(iCityTypeID)
    -- 参数校验
    if not iCityTypeID then
        return false
    end
    return SeaCityDict[iCityTypeID] == true
end

-- 设置委托任务的接取状态
function CityDataManager:SetDelegationTaskState(cityBaseID, hasStartTask)
    self.delegationStartState = self.delegationStartState or {}
    self.delegationStartState[cityBaseID] = hasStartTask
end

-- 门派是否已经开始委托任务
function CityDataManager:IsCityDelegationTaskStart(cityBaseID)
    if self.delegationStartState == nil then
        return false
    end
    return (self.delegationStartState[cityBaseID] == true)
end

-- 城市是否出现在当前剧本
function CityDataManager:IsCityInCurScript(cityBaseID)
    local cityData = TableDataManager:GetInstance():GetTableData("City", cityBaseID)
    if cityData == nil then 
        return false
    end
    if cityData.ScriptID == nil or #cityData.ScriptID == 0 then 
        return true
    end
    local curStoryID = GetCurScriptID()
    for _, scriptID in ipairs(cityData.ScriptID) do 
        if curStoryID == scriptID then 
            return true
        end
    end
    return false
end

-- 记录城市已经打开的天气特效
function CityDataManager:SetLastWeatherEffectTypeID(iCurWeatherEffectTypeID)
    self.iCurWeatherEffectTypeID = iCurWeatherEffectTypeID
end

-- 获取城市已经打开的天气特效
function CityDataManager:GetLastWeatherEffectTypeID()
    return self.iCurWeatherEffectTypeID or 0
end

-- 关闭上一个城市的天气效果
function CityDataManager:CloseLastWeatherEffect()
	local iLastWeatherEffectTypeID = self:GetLastWeatherEffectTypeID()
    if iLastWeatherEffectTypeID and (iLastWeatherEffectTypeID > 0) then
		MapEffectManager:GetInstance():RemoveMapEffect(iLastWeatherEffectTypeID)
        self:SetLastWeatherEffectTypeID(nil)
        self.bIsPlayingWeatherEffect = false
    end
    self.lastWeather = nil
end

-- 更新城市天气效果
function CityDataManager:UpdateCityWeatherEffect()
	local mapMgr = MapDataManager:GetInstance()
    local iWeatherTypeID = 0
    -- 获取上一次打开的天气特效id, 关闭
    -- 如果是在室内, 那么不继续添加天气特效
    local uiCurMapID = mapMgr:GetCurMapID()
    local kMapData = mapMgr:GetMapData(uiCurMapID)
    if kMapData and (kMapData.SceneType == MapSceneType.ST_ROOM) then
    else
        iWeatherTypeID = self:GetCurCityWeatherID()
    end
    -- 获取当前城市的天气特效id, 如果存在, 那么显示特效
    if iWeatherTypeID == self.lastWeather then
        return
    end
    
    self:CloseLastWeatherEffect()    
    self.lastWeather = iWeatherTypeID
    if iWeatherTypeID and (iWeatherTypeID > 0) then 
        local kWeatherData = TableDataManager:GetInstance():GetTableData("Weather", iWeatherTypeID)
        if kWeatherData and kWeatherData['Background'] and (kWeatherData['Background'] > 0) then
            local iCurWeatherEffectTypeID = kWeatherData['Background']
            MapEffectManager:GetInstance():AddMapEffect(iCurWeatherEffectTypeID)
            self:SetLastWeatherEffectTypeID(iCurWeatherEffectTypeID)
            self.bIsPlayingWeatherEffect = true
        end
    end
end

-- 当前是否在播放天气特效
function CityDataManager:IsPlayingWeatherEffect()
    return (self.bIsPlayingWeatherEffect == true)
end

-- 获取城市好感度
function CityDataManager:GetDisposition(cityID)
    local cityData = self:GetCityData(cityID)
    if not cityData then 
        return 0
    end
    return cityData.iCityDispo or 0
end

function CityDataManager:InitSpecialCityShowNameData()
    self.specialCityShowNameData = {}

    local datas = TableDataManager:GetInstance():GetTable("SpecialCityShowName")
    if not datas then
        return
    end

    for index, dataItem in pairs(datas) do
        if dataItem.City ~= 0 and dataItem.ShowNameID ~= 0 and dataItem.Tag ~= 0 then
            self.specialCityShowNameData[dataItem.City] = self.specialCityShowNameData[dataItem.City] or {}
            self.specialCityShowNameData[dataItem.City][dataItem.Tag] = dataItem.ShowNameID
        end
    end
end

function CityDataManager:GetCityShowNameID(cityID)
    if cityID == nil or cityID == 0 then
        return 0
    end

    if self.specialCityShowNameData then
        local cityNameData = self.specialCityShowNameData[cityID]

        if cityNameData then
            for tagID, nameID in pairs(cityNameData) do
                if TaskTagManager:GetInstance():TagIsValue(tagID,1) then
                    return nameID
                end
            end
        end
    end

    local cityData = TableDataManager:GetInstance():GetTableData("City", cityID)
    if cityData then
        return cityData.NameID
    end

    return 0
end

function CityDataManager:GetCityShowName(cityID)
    local nameID = self:GetCityShowNameID(cityID)

    if not nameID or nameID == 0 then
        return ''
    end

    return GetLanguageByID(nameID)
end


function CityDataManager:GetCityEventExsist(iCityID1,iCityID2)
    if iCityID1 == nil or iCityID2 == nil or iCityID2 == 0 or iCityID1 == 0 then 
        return 
    end 
    local func_GetEventByCityID = function(icity1,icity2)
        local cityData = self:GetCityData(icity1)
        if (cityData and cityData.iNum) and (self:IsCityInCurScript(iCityID1)) then
            local cityEventDatas = cityData["akCityEvents"]
            if cityEventDatas then 
                for i = cityData.iNum - 1, 0, -1 do 
                    if cityEventDatas[i] then 
                        local toCityid = cityEventDatas[i]["uiToCityID"]
                        local taskid = cityEventDatas[i]["uiTaskID"]
                        if toCityid == icity2 and taskid then 
                            -- 缓存大地图事件数量
                            return true
                        end
                    end
                end
            end
        end
    end
    if func_GetEventByCityID(iCityID1,iCityID2) then 
        return true 
    end 
    if func_GetEventByCityID(iCityID2,iCityID1) then 
        return true 
    end 
    return false
end