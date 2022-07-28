MapDataManager = class("MapDataManager")
MapDataManager._instance = nil

SHOW_MAINROLE_HOME_STORYS = {
	[2] = true,
	[6] = true,
	[7] = true,
}

function MapDataManager:GetInstance()
    if MapDataManager._instance == nil then
		MapDataManager._instance = MapDataManager.new()
		MapDataManager._instance:Init()
    end

    return MapDataManager._instance
end

function MapDataManager:Init()
	self.lTB_Map = TableDataManager:GetInstance():GetTable("Map")
	self:ResetManager()
	-- 建立父地图查询表
	self.parentMapDict = {}
	for mapID, map in pairs(self.lTB_Map) do 
		if map.ChildIDList then 
			for _, childMapID in ipairs(map.ChildIDList) do 
				if self.lTB_Map[childMapID] then 
					self.parentMapDict[childMapID] = mapID
				end
			end
		end
	end
end

local MapIndexFunction = function(t, k)
	local lTB_Map = TableDataManager:GetInstance():GetTable("Map")
    local mapID = rawget(t, 'BaseID')
    local mapData = lTB_Map[mapID]
    if mapData == nil then 
        return nil
    end
    return mapData[k]
end

function MapDataManager:ResetManager()
	self.mapDataMap = {}
	self.mapToClan = {}
	self.iCurMapID = 0
end

function MapDataManager:UpdateMapData(mapID, newMapData)
	local mapData
    if self.mapDataMap[mapID] == nil then 
        mapData = {BaseID = mapID}
        setmetatable(mapData, {__index = MapIndexFunction})
        self.mapDataMap[mapID] = mapData
    else
        mapData = self.mapDataMap[mapID]
	end
	mapData.roleList = {}
	for i = 0, #newMapData.auiRoleIDs do 
		table.insert(mapData.roleList, newMapData.auiRoleIDs[i])
	end
	if newMapData.uiNameID ~= nil and newMapData.uiNameID ~= 0 then 
		rawset(mapData, 'NameID', newMapData.uiNameID)
	else
		rawset(mapData, 'NameID', nil)
	end
	if newMapData.sBuildingImg ~= nil and newMapData.sBuildingImg ~= '' then 
		rawset(mapData, 'BuildingImg', newMapData.sBuildingImg)
	else
		rawset(mapData, 'BuildingImg', nil)
	end
	if newMapData.uiBuildingType ~= nil and newMapData.uiBuildingType ~= 0 then 
		rawset(mapData, 'BuildingType', newMapData.uiBuildingType)
	else
		rawset(mapData, 'BuildingType', nil)
	end
	if newMapData.bCanShow ~= nil then 
		rawset(mapData, 'CanShow', newMapData.bCanShow)
	else
		rawset(mapData, 'CanShow', nil)
	end
	if newMapData.bCanReturn ~= nil then 
		rawset(mapData, 'CanReturn', newMapData.bCanReturn)
	else
		rawset(mapData, 'CanReturn', nil)
	end
	
	LuaEventDispatcher:dispatchEvent("MAP_UPDATE", mapID)
end

function MapDataManager:GetCurMapData()
	local curMapID = self:GetCurMapID()
	return self:GetMapData(self.iCurMapID)
end

function MapDataManager:GetCurMapID()
	return self.iCurMapID
end

function MapDataManager:SetCurMapID(mapID)
	local oldMapID = self.iCurMapID
	self.iCurMapID = mapID
	if oldMapID ~= mapID then 
		LuaEventDispatcher:dispatchEvent("UPDATE_CURRENT_MAP")
		-- 地图刷新的时候需要请求玩家站立的数据
		local win = GetUIWindow("CityUI")
		if not win then
			self:SetNeedRequestStandPlayersFlag(true)
		else
			win:JungAndReqStanPlayersByMapID(mapID)
		end
		
	end
end

function MapDataManager:IsCurMap(mapID)
	local curMapID = self:GetCurMapID()
	return curMapID == mapID
end

function MapDataManager:IsCurMapChild(mapID)
	local curMapID = self:GetCurMapID()
	local childMapList = self:GetChildMapList(curMapID)
	for _, childMapID in ipairs(childMapList) do 
		if childMapID == mapID then 
			return true
		end
	end
	return false
end

function MapDataManager:GetParentMapID(uiMapID)
	if uiMapID ~= nil and self.parentMapDict ~= nil then 
		return self.parentMapDict[uiMapID] or 0
	end
	return 0
end

function MapDataManager:GetRootMapID(uiMapID)
	local lTB_Map = TableDataManager:GetInstance():GetTable("Map")
	if not lTB_Map[uiMapID] then 
		return nil
	end

	local uiParentMapID = uiMapID
	while self:GetParentMapID(uiParentMapID) ~= 0 do
		uiParentMapID = self:GetParentMapID(uiParentMapID)
	end
	
	return uiParentMapID
end

function MapDataManager:GetClanTypeIDByMapID(uiMapID)
	local lTB_Map = TableDataManager:GetInstance():GetTable("Map")
	local mapData = lTB_Map[uiMapID]
	if not mapData then 
		return nil
	end
	if mapData.ClanID then
		return mapData.ClanID
	end
	
	local rootScene = self:GetRootMapID(uiMapID)
	local TB_ClanEliminate = TableDataManager:GetInstance():GetTable("ClanEliminate")
	for k, v in pairs(TB_ClanEliminate) do
		local clanscene = v.ClanScene
		if clanscene == rootScene then
			return v.ClanID
		end
	end
end

function MapDataManager:GetMapData(uiMapID)
	if not uiMapID then 
		return nil
	end

	if self.mapDataMap[uiMapID] then
		return self.mapDataMap[uiMapID] 
	end

	if self.lTB_Map == nil then
		self.lTB_Map = TableDataManager:GetInstance():GetTable("Map")
	end

	return self.lTB_Map[uiMapID]
end

function MapDataManager:ClearRoleList(uiMapID)
	local mapData = self:GetMapData(uiMapID)
	if not mapData then 
		return 
	end
	mapData.roleList = {}
end

function MapDataManager:IsRoleInMap(searchRoleID, mapID)
	local roleList = self:GetRoleList(mapID)
	if roleList == nil or #roleList == 0 then 
		return false
	end
	if not dnull(searchRoleID) then 
		return true
	end
	for _, roleID in ipairs(roleList) do
		if roleID == searchRoleID then 
			return true
		end
	end
	return false
end

function MapDataManager:GetRoleList(uiMapID)
	local mapData = self:GetMapData(uiMapID)
	if not mapData then 
		return {}
	end
	return mapData.roleList or {}
end

function MapDataManager:GetRoleCount(uiMapID)
	local roleList = self:GetRoleList(uiMapID)
	if type(roleList) ~= 'table' then 
		return 0
	end
	return #roleList
end

function MapDataManager:GetShowRoleMaxCount(uiMapID)
	local maxCount = 2

	local lTB_Map = TableDataManager:GetInstance():GetTable("Map")
	if uiMapID and lTB_Map[uiMapID] then
		if lTB_Map[uiMapID].BuildingSize > 1 then
			maxCount = 4
		end
	end

	return maxCount
end

function MapDataManager:HasChildMap(uiParentID, searchChildID)
	local childMapList = self:GetChildMapList(uiParentID)
	for _, childMapID in ipairs(childMapList) do 
		if searchChildID == childMapID then 
			return true
		end
	end
	return false
end

function MapDataManager:GetChildMapList(uiMapID)
	local mapData = self:GetMapData(uiMapID)
	if mapData == nil or mapData.ChildIDList == nil then 
		return {}
	end
	local childMapList = {}
	local index = 1
	for _, childMapID in ipairs(mapData.ChildIDList) do
		local childMapData = MapDataManager:GetInstance():GetMapData(childMapID)
		if childMapData ~= nil and childMapData.CanShow ~= 0 and childMapData.CanShow ~= false then 
			childMapList[index] = childMapID
			index = index + 1
		end
	end
	return childMapList
end

local GetRoleListInMapTreeStack = {}
function MapDataManager:GetRoleListInMapTree(mapID)
	if GetRoleListInMapTreeStack[mapID] and GetRoleListInMapTreeStack[mapID] > 0 then 
		return {}
	end
	GetRoleListInMapTreeStack[mapID] = GetRoleListInMapTreeStack[mapID] or 0
	GetRoleListInMapTreeStack[mapID] = GetRoleListInMapTreeStack[mapID] + 1
	local cityRoleList = {}
	local mapRoleList = self:GetRoleList(mapID)
	for _, roleID in ipairs(mapRoleList) do 
		table.insert(cityRoleList, roleID)
	end
	local childMapList = self:GetChildMapList(mapID)
	for index, childMapID in ipairs(childMapList) do 
		local childRoleList = self:GetRoleListInMapTree(childMapID)
		for _, roleID in ipairs(childRoleList) do 
			table.insert(cityRoleList, roleID)
		end
	end
	GetRoleListInMapTreeStack[mapID] = GetRoleListInMapTreeStack[mapID] - 1
	return cityRoleList
end

function MapDataManager:GetRolePositionDataListInCity(rootMapID)
	local hasChecked = {}
	local hasAdd = {}
	local needChecked = {}
	local roleDataList = {}
	local roleLocation = {}

	table.insert(needChecked, rootMapID)
	hasAdd[rootMapID] = true
	-- 广度优先遍历
	while #needChecked > 0 do
		local checkMapID = needChecked[#needChecked]
		table.remove(needChecked, #needChecked)
		local childMapList = self:GetChildMapList(checkMapID)
		for _, childMapID in ipairs(childMapList) do
			if not hasAdd[childMapID] then
				table.insert(needChecked, childMapID)
				hasAdd[childMapID] = true
			end
		end
		if not hasChecked[checkMapID] then
			local mapRoleList = self:GetRoleList(checkMapID)
			for _, roleID in ipairs(mapRoleList) do
				local roleMapID = checkMapID
				if roleMapID == rootMapID then 
					roleMapID = nil
				end
				if roleLocation[roleID] ~= nil and roleMapID ~= nil then
					roleLocation[roleID].mapID = roleMapID
				else
					local data = {
						roleID = roleID, 
						mapID = roleMapID
					}
					local roleStatus = RoleDataManager:GetInstance():GetRoleStatus(roleID, false)
					if roleStatus ~= StatusType.STT_WuJian then
						table.insert(roleDataList, data)
					end
					roleLocation[roleID] = data
				end	
			end
		end
		hasChecked[checkMapID] = true
	end

	return roleDataList
end

function MapDataManager:GetMapBuildingName(mapBaseID)
	local mapData = self:GetMapData(mapBaseID)
	if mapData == nil then 
		return ''
	end
	local buildingName = ''
	local curStoryID = GetCurScriptID() or 0
	if (mapData.MainRoleHome == TBoolean.BOOL_YES) and SHOW_MAINROLE_HOME_STORYS[curStoryID] then
		local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
		local roleName = RoleDataManager:GetInstance():GetRoleName(mainRoleID)

		-- FIXME: 中文应该加入语言表
		buildingName = roleName .. '家'
	else
		buildingName = GetLanguageByID(mapData.BuildingNameID) or ''
	end

	local mapAttrChange = self:GetMapAttrChange(mapBaseID)
	if (mapAttrChange ~= nil and mapAttrChange.MapName ~= nil and mapAttrChange.MapName ~= "" and mapAttrChange.MapName ~= "-") then
		buildingName = mapAttrChange.MapName
	end

	return buildingName
end

function MapDataManager:GetMapSceneName(mapBaseID)
	local mapData = self:GetMapData(mapBaseID)
	if mapData == nil then 
		return ''
	end
	local sceneName = ''

	local curStoryID = GetCurScriptID() or 0
	if (mapData.MainRoleHome == TBoolean.BOOL_YES) and SHOW_MAINROLE_HOME_STORYS[curStoryID] then
		local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
		local roleName = RoleDataManager:GetInstance():GetRoleName(mainRoleID)

		-- FIXME: 中文应该加入语言表
		sceneName = roleName .. '家'
	else
		sceneName = GetLanguageByID(mapData.NameID) or ''
	end

	local mapAttrChange = self:GetMapAttrChange(mapBaseID)
	if (mapAttrChange ~= nil and mapAttrChange.MapName ~= nil and mapAttrChange.MapName ~= "" and mapAttrChange.MapName ~= "-") then
		buildingName = mapAttrChange.MapName
	end

	return sceneName
end

function MapDataManager:GetMapAttrChange(mapID)
	local lTB_MapAttrChange = TableDataManager:GetInstance():GetTable("MapAttrChange")
	for k,v in ipairs(lTB_MapAttrChange) do
		if (v.MapID == mapID) then
			local value = TaskTagManager:GetInstance():GetTag(v.TagID)
			if (value ~= nil and value > 0) then
				return v
			end
		end
	end

	return nil
end

function MapDataManager:CanMapShowRoleList()
	local mapData = self:GetCurMapData()
	if mapData and mapData.IsForbidShowCityRoleList	== TBoolean.BOOL_YES then
		return false
	end
	return true
end

-- 对地图角色将进行排序
function MapDataManager:SortMapRoleID(roleIdList, mapID)
	if type(roleIdList) ~= 'table' then 
		return roleIdList
	end
	local RoleNameSortFunc = function(roleIdA, roleIdB)
		local roleManagerInstance = RoleDataManager:GetInstance()
		local roleAChoiceCount = 0
		local roleBChoiceCount = 0
		if roleManagerInstance:HasSelectRoleListener(roleIdA, mapID) then 
			roleAChoiceCount = 999
		else
			roleAChoiceCount = roleManagerInstance:GetTaskChoiceCount({roleID = roleIdA, mapID = mapID})
		end
		if roleManagerInstance:HasSelectRoleListener(roleIdB, mapID) then 
			roleBChoiceCount = 999
		else
			roleBChoiceCount = roleManagerInstance:GetTaskChoiceCount({roleID = roleIdB, mapID = mapID})
		end
		if roleAChoiceCount == roleBChoiceCount then 
			local roleNameA = RoleDataManager:GetInstance():GetRoleName(roleIdA)
			local roleNameB = RoleDataManager:GetInstance():GetRoleName(roleIdB)
			return roleNameA > roleNameB
		end
		return roleAChoiceCount > roleBChoiceCount
	end
	table.sort(roleIdList, RoleNameSortFunc)
	return roleIdList
end

-- 获取建筑描述
function MapDataManager:GetBuildingDescByData(mapData)
	if mapData == nil then 
		return ""
	end

	local desc = ""
	desc = HighTowerDataManager:GetInstance():GetHighTowerBuildingDesc(mapData.BaseID)
	if desc ~= nil then
		return desc
	end
	desc = ""
	if (mapData.BuildingType == MapBuildingType.BT_DOOR)
	or (mapData.BuildingType == MapBuildingType.BT_CLAN)
	or (mapData.BuildingType == MapBuildingType.BT_HIGHCLAN) then 
		desc = getUIBasedText('blue', dtext(976) .. ' ')
		local destSceneName = MapDataManager:GetInstance():GetMapSceneName(mapData.BaseID)
		desc = desc .. destSceneName
		desc = desc .. getUIBasedText('blue', dtext(977))
		local childCount = 0
		local childMapList = self:GetChildMapList(mapData.BaseID)
		for _, childMapID in ipairs(childMapList) do
			local childMapName = MapDataManager:GetInstance():GetMapBuildingName(childMapID)
			if childCount ~= 0 then 
				desc = desc .. dtext(975)
			end
			desc = desc .. childMapName
			childCount = childCount + 1
		end
	elseif mapData.BuildingType == MapBuildingType.BT_MAZE then 
		local mazeBaseID = mapData.MazeID
		local mazeData = MazeDataManager:GetInstance():GetMazeTypeDataByTypeID(mazeBaseID)
		if mazeData ~= nil and mazeData.MazeDescID ~= nil then 
			desc = GetLanguageByID(mazeData.MazeDescID) or ''
		end
	end

	return desc
end

-- 设置当前是否允许刷新城市站立玩家
function MapDataManager:SetNeedRequestStandPlayersFlag(bOn)
    self.bNeedRequestStandPlayers = (bOn == true)
end

-- 获取当前是否允许刷新城市站立玩家
function MapDataManager:GetIfNeedRequestStandPlayers()
	local bNeedUpdate = (self.bNeedRequestStandPlayers == true)
	local iCurMap = self:GetCurMapID()
    return bNeedUpdate, iCurMap
end

-- 设置刷新城市站立玩家CD
function MapDataManager:SetRequestStandPlayersCD(bOn)
    self.bRequestStandPlayersCD = (bOn == true)
end

-- 获取当前是否允许刷新城市站立玩家
function MapDataManager:IsRequestStandPlayersInCD()
	return (self.bRequestStandPlayersCD == true)
end