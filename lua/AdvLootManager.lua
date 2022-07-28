AdvLootManager = class("AdvLootManager")
AdvLootManager._instance = nil

local AdvLootUI = require 'UI/MazeUI/AdvLootUI'

local DEFAULT_DISTANCE_X = 30
local DEFAULT_DISTANCE_Y = 20

local DEFAULT_POS = {
        [1] =  DRCSRef.Vec2(-115, -144),
        [2] =  DRCSRef.Vec2(-35, -144), 
        [3] =  DRCSRef.Vec2(50, -144),
        [4] =  DRCSRef.Vec2(135, -144), 
        [5] =  DRCSRef.Vec2(-115, -220),
        [6] =  DRCSRef.Vec2(-35, -220), 
        [7] =  DRCSRef.Vec2(50, -220),
        [8] =  DRCSRef.Vec2(135, -220), 

        [9] =   DRCSRef.Vec2(-115, 0),
        [10] =  DRCSRef.Vec2(-35, 0), 
        [11] =  DRCSRef.Vec2(50, 0),
        [12] =  DRCSRef.Vec2(135, 0), 
        [13] =  DRCSRef.Vec2(-115, 85),
        [14] =  DRCSRef.Vec2(-35, 85), 
        [15] =  DRCSRef.Vec2(50, 85),
        [16] =  DRCSRef.Vec2(135, 85), 
}
local l_sendPickUpCmdInterval = 333

function AdvLootManager:GetInstance()
    if AdvLootManager._instance == nil then
        AdvLootManager._instance = AdvLootManager.new()
        AdvLootManager._instance:Init()
    end

    return AdvLootManager._instance
end

function AdvLootManager:Init()
    self:ResetManager()

    LuaEventDispatcher:addEventListener("QUITE_MAZE", function()
		self:ClearRandomPos()
    end)
    self.sendClickPickUpCmdTimer = l_sendPickUpCmdInterval
    self.dirtyPickUpAdvLootCmd = {}
end

function AdvLootManager:ResetManager()
    self.advlootPos = nil
    self.advlootMapPos = {}
    self.advlootMazePos = {}
    self.DyncMapAdvlootList = {}
    self.MapAdvlootList = nil
    self.MazeAdvlootList = nil
    self.AdvlootList = nil
    self.Pool = nil
    self.mazeMazeDynamicAdvLootPosDict = nil
    self.sendClickPickUpCmdTimer = l_sendPickUpCmdInterval
    self.dirtyPickUpAdvLootCmd = {}
end

function AdvLootManager:Update(deltaTime)
    if #self.dirtyPickUpAdvLootCmd == 0 then 
        return
    end
    self.sendClickPickUpCmdTimer = self.sendClickPickUpCmdTimer - deltaTime
    if self.sendClickPickUpCmdTimer > 0 then 
        return
    end
    self.sendClickPickUpCmdTimer = l_sendPickUpCmdInterval
    self:ImmediatelySend()
end

function AdvLootManager:ImmediatelySend()
    if #self.dirtyPickUpAdvLootCmd == 0 then 
        return
    end
    local advLootCount = 0
    local advLootList = {}
    local customAdvLootCount = 0
    local customAdvLootList = {}
    for index, advLootData in ipairs(self.dirtyPickUpAdvLootCmd) do 
        if advLootData.uiSite == ADVLOOT_SITE.ADV_CUSTOM then 
            customAdvLootList[customAdvLootCount + 1] = advLootData
            customAdvLootCount = customAdvLootCount + 1
        else
            advLootList[advLootCount] = advLootData
            advLootCount = advLootCount + 1
        end
    end
    SendClickCustomAdvLoot(customAdvLootCount, customAdvLootList)
    SendClickPickUpAdvLoot(advLootCount, advLootList)
    self.dirtyPickUpAdvLootCmd = {}
end

function AdvLootManager:GetPos(advlootUID, eType, mapID)
    self.advlootPos = self.advlootPos or {}
    self.advlootPos[advlootUID] = self.advlootPos[advlootUID] or {}

    local Lootpx = self.advlootPos[advlootUID]["Lootpx"]
    local Lootpy = self.advlootPos[advlootUID]["Lootpy"]
    local isFirstUpdate = false
    if Lootpx == nil or Lootpy == nil then
        if eType == ADVLOOT_SITE.ADV_CITY_DYNAC then
            Lootpx,Lootpy,isFirstUpdate = self:GetMapDynamicAdvLootPos(mapID, advlootUID)
        else
            Lootpx,Lootpy = self:RandomPos(0,0)
        end
        self.advlootPos[advlootUID]["Lootpx"] = Lootpx
        self.advlootPos[advlootUID]["Lootpy"] = Lootpy
    end

    return Lootpx,Lootpy,isFirstUpdate
end

function AdvLootManager:RandomPos(basepx,basepy)
    local Lootpx = math.random(basepx - 100, basepx + 100)
    local Lootpy = math.random(basepy-186, basepy + 164)
    return math.floor(Lootpx),math.floor(Lootpy)
end

--冒险掉落_初始化
-- iNum 数量
-- akAdvLootInfos 地图垃圾集合
    -- [0] = 
    --{
    --    "uiID":28 -- 唯一ID
    --    "uiSiteType":0    --所处位置 0地图 1迷宫区域 2迷宫格
    --    "uiAdvLootID":48  -- 地图代表 buildAdvlootID , 迷宫代表 advlootID, 动态代表 itemID
    --    "uiNum":1 -- 数量
    --    "uiSiteID":75 -- 地图 mapID ,其他GridID 
    --    "uiAdvLootType":0 -- 垃圾类型
    -- }
function AdvLootManager:UpdateAdvLoot(retStream)
    self.MapAdvlootList = self.MapAdvlootList or {}
    self.MazeAdvlootList = self.MazeAdvlootList or {}

    local mazeManagerInstance = MazeDataManager.GetInstance()
    local isInMaze = mazeManagerInstance:IsInMaze() 
    local akAdvLootInfos = retStream.akAdvLootInfos
    local iNum = retStream.iNum

    self._action = {}
    for index = 0, iNum - 1 do
        local advlootData = akAdvLootInfos[index]
        if advlootData == nil then
            break
        end
        local uiSiteType = advlootData.uiSiteType
        local uiSiteID = advlootData.uiSiteID
        local uiID = advlootData.uiID

        if uiSiteType == ADVLOOT_SITE.ADV_CITY then
            --城镇
            local mapID = uiSiteID
            self.MapAdvlootList[mapID] = self.MapAdvlootList[mapID] or {}
            self.MapAdvlootList[mapID][uiID] = advlootData

            if MapDataManager:GetInstance():IsCurMap(mapID) or MapDataManager:GetInstance():IsCurMapChild(mapID) then 
                LuaEventDispatcher:dispatchEvent("UPDATE_CURRENT_MAP_ADVLOOT",{uiID = uiID,uiNum = advlootData.uiNum, siteType = uiSiteType},false)
            end
        elseif uiSiteType == ADVLOOT_SITE.ADV_MAZE or uiSiteType == ADVLOOT_SITE.ADV_MAZEGRID  then
            -- 迷宫
            -- 迷宫类型的冒险掉落, siteID 的形式为 XXYYZZ, XX 是 区域ID, YY 是 行, ZZ 是 列
            local column = uiSiteID % 100
            uiSiteID = math.floor(uiSiteID / 100)
            local row = uiSiteID % 100
            uiSiteID = math.floor(uiSiteID / 100)
            local areaID = uiSiteID
            local gridData = MazeDataManager:GetInstance():GetAreaMazeGridData(areaID, row, column)
            local mazeGridID = 0
            if gridData then
                mazeGridID = gridData.uiID
            end
            advlootData.row = row
            advlootData.column = column
            self.MazeAdvlootList[areaID] = self.MazeAdvlootList[areaID] or {}
            self.MazeAdvlootList[areaID][row] = self.MazeAdvlootList[areaID][row] or {}
            self.MazeAdvlootList[areaID][row][column] = self.MazeAdvlootList[areaID][row][column] or {}
            self.MazeAdvlootList[areaID][row][column][uiID] = advlootData
            -- self.MazeAdvlootList[mazeGridID] = self.MazeAdvlootList[mazeGridID] or {}
            -- self.MazeAdvlootList[mazeGridID][uiID] = advlootData
            if advlootData.uiNum <= 0 then
                -- LuaEventDispatcher:dispatchEvent("UPDATE_CURRENT_MAZE_ADVLOOT",{uiID = uiID, mazeGridID = mazeGridID, uiNum = advlootData.uiNum},true)
            else
                if isInMaze then
                    if uiSiteType == ADVLOOT_SITE.ADV_MAZE then 
                        -- 其他的直接刷新
                        -- LuaEventDispatcher:dispatchEvent("UPDATE_CURRENT_MAZE_ADVLOOT", mazeGridID, true)
                    elseif uiSiteType == ADVLOOT_SITE.ADV_MAZEGRID then 
                        -- 宝箱的需要用动画队列
                        self._action[mazeGridID] = true
                    end
                end
            end
        elseif uiSiteType == ADVLOOT_SITE.ADV_CITY_DYNAC then
            local mapID = uiSiteID
            self.DyncMapAdvlootList[mapID] = self.DyncMapAdvlootList[mapID] or {}
            self.DyncMapAdvlootList[mapID][uiID] = advlootData
            if MapDataManager:GetInstance():IsCurMap(mapID) or MapDataManager:GetInstance():IsCurMapChild(mapID) then 
                LuaEventDispatcher:dispatchEvent("UPDATE_CURRENT_MAP_ADVLOOT", {uiID = uiID, uiNum = advlootData.uiNum, siteType = uiSiteType},false)
            end
        end
    end

    for mazeGridID, _ in pairs(self._action) do 
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.UPDATE_MAZE_GRID_UI, false, mazeGridID)
    end
    self._action = {}
end

function AdvLootManager:ParseCustomAdvLootDataFromTaskEvent(taskEventID)
    taskEventID = taskEventID or 0
    local taskEvent = TableDataManager:GetInstance():GetTableData('TaskEvent', taskEventID)
    if not taskEvent then 
        return nil
    end
    local customAdvLoot = {}
    customAdvLoot.taskEventID = taskEventID
    customAdvLoot.mapID = tonumber(taskEvent.EventArg1 or 0) or 0
    customAdvLoot.name = taskEvent.EventArg2 or ''
    customAdvLoot.x = tonumber(taskEvent.EventArg3 or 0) or 0
    customAdvLoot.y = tonumber(taskEvent.EventArg4 or 0) or 0
    customAdvLoot.icon = taskEvent.EventArg5 or ''
    return customAdvLoot
end

function AdvLootManager:UpdateCustomAdvLoot(taskEventID, isEnable)
    self.customAdvLoots = self.customAdvLoots or {}
    local customAdvLoot = self:ParseCustomAdvLootDataFromTaskEvent(taskEventID)
    if customAdvLoot then
        local mapID = customAdvLoot.mapID or 0        
        local mapCustomAdvLoots = self.customAdvLoots[mapID] or {}
        if isEnable then 
            mapCustomAdvLoots[taskEventID] = mapCustomAdvLoots[taskEventID] or {}
            mapCustomAdvLoots[taskEventID] = customAdvLoot
        else
            mapCustomAdvLoots[taskEventID] = nil
        end
        self.customAdvLoots[mapID] = mapCustomAdvLoots
    end
end

function AdvLootManager:GetCustomAdvLoots(mapID)
    if not self.customAdvLoots then 
        return nil
    end
    return self.customAdvLoots[mapID]
end

function AdvLootManager:GetMapAdvlootDataByID(uiMapID,uiID)
    self.MapAdvlootList = self.MapAdvlootList or {}
    if self.MapAdvlootList[uiMapID] == nil then
        dwarning("当前地图没有垃圾" .. uiMapID)
        return nil
    end
    if self.MapAdvlootList[uiMapID][uiID] == nil then
        dwarning("当前地图:" .. uiMapID .. "没有垃圾 :" .. uiID)
        return nil
    end

    return  self.MapAdvlootList[uiMapID][uiID]
end

function AdvLootManager:GetMazeAdvlootDataByID(uiMazeGridID, uiID)
    local curAreaID = MazeDataManager:GetInstance():GetCurMazeAreaID()
    if self.MazeAdvlootList == nil or self.MazeAdvlootList[curAreaID] == nil then
        return nil
    end
    local gridData = MazeDataManager:GetInstance():GetGridData(uiMazeGridID)
    local row = gridData.uiRow
    local column = gridData.uiColumn
    if self.MazeAdvlootList[curAreaID][row] == nil or self.MazeAdvlootList[curAreaID][row][column] == nil then
        return nil
    end
    return self.MazeAdvlootList[curAreaID][row][column][uiID]
end

function AdvLootManager:GetMapAdvlootDataList(uiMapID)
    self.MapAdvlootList = self.MapAdvlootList or {}
    if self.MapAdvlootList[uiMapID] then
        return self.MapAdvlootList[uiMapID]
    end
    return nil
end

function AdvLootManager:GetDyncMapAdvlootDataList(uiMapID)
    self.DyncMapAdvlootList = self.DyncMapAdvlootList or {}
    if self.DyncMapAdvlootList[uiMapID] then
        return self.DyncMapAdvlootList[uiMapID]
    end
    return nil
end

function AdvLootManager:GetMazeAdvlootList(uiMazeGridID)
    local curAreaID = MazeDataManager:GetInstance():GetCurMazeAreaID()
    if self.MazeAdvlootList == nil or self.MazeAdvlootList[curAreaID] == nil then
        return nil
    end
    local gridData = MazeDataManager:GetInstance():GetGridData(uiMazeGridID)
    local row = gridData.uiRow
    local column = gridData.uiColumn
    if self.MazeAdvlootList[curAreaID][row] == nil or self.MazeAdvlootList[curAreaID][row][column] == nil then
        return nil
    end
    return self.MazeAdvlootList[curAreaID][row][column]
end

function AdvLootManager:PickUpAdvLoot(uiSite,uiMID,uiAreaID,uiAdvLootID,uiDynamicAdvLootID)
    local advLootData = {
        uiSite = uiSite,
        uiMID = uiMID,
        uiAreaID = uiAreaID,
        uiAdvLootID = uiAdvLootID,
        uiDynamicAdvLootID = uiDynamicAdvLootID
    }
    table.insert(self.dirtyPickUpAdvLootCmd, advLootData)
end

function AdvLootManager:PickUpDynamicAdvLoot(bMap,uiID,uiAreaID,uiDynamicAdvLootID)
    local advLootData = {
        uiSite = bMap,
        uiMID = uiID,
        uiAreaID = uiAreaID,
        uiAdvLootID = 0,
        uiDynamicAdvLootID = uiDynamicAdvLootID
    }
    table.insert(self.dirtyPickUpAdvLootCmd, advLootData)
end

function AdvLootManager:GetAdvLoot(uiAdvLoot)
    if not uiAdvLoot then 
        return nil
    end
    return TableDataManager:GetInstance():GetTableData("AdvLoot",uiAdvLoot)
end

function AdvLootManager:InitMazeAdvloot()
    self.AdvlootList = {}
    self.Pool = DRCSRef.FindGameObj("ResourceManager")
    
    for index = 1, 10 do
        local advloot = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.AdvlootUI,self.Pool.transform)
    end
end

-- FIXME: 比起在这里写死, 是不是在什么地方初始化的时候设置比较合适
-- 迷宫卡片UI宽高
local mazeCardWidth = 260
local mazeCardHeight = 470
-- 记录每个动态掉落的位置
local mazeMazeDynamicAdvLootPosDict = {}
-- 获取迷宫动态冒险掉落位置
function AdvLootManager:GetMazeDynamicAdvLootPos(mazeGridID, uiID)
    self.mazeMazeDynamicAdvLootPosDict = self.mazeMazeDynamicAdvLootPosDict or {}
    if self.mazeMazeDynamicAdvLootPosDict[uiID] ~= nil then
        local pos = self.mazeMazeDynamicAdvLootPosDict[uiID]
        return pos.x, pos.y, false
    end
    return self:New_RandomPos(mazeGridID, uiID)
end

function AdvLootManager:IsMazeDynamicAdvLootFirstUpdate(uiID)
    self.mazeMazeDynamicAdvLootPosDict = self.mazeMazeDynamicAdvLootPosDict or {}
    if self.mazeMazeDynamicAdvLootPosDict[uiID] ~= nil then
        return false
    end
    return true
end

function AdvLootManager:IsMapDynamicAdvLootFirstUpdate(uiID)
    self._mapDynamicAdvLootPosDict = self._mapDynamicAdvLootPosDict or {}
    if self._mapDynamicAdvLootPosDict[uiID] ~= nil then
        return false
    end
    return true
end

function AdvLootManager:GetMapDynamicAdvLootPos(mapID, uiID)
    self._mapDynamicAdvLootPosDict = self._mapDynamicAdvLootPosDict or {}
    if self._mapDynamicAdvLootPosDict[uiID] ~= nil then
        local pos = self._mapDynamicAdvLootPosDict[uiID]
        return pos.x, pos.y, false
    end
    return self:New_RandomPos(mapID, uiID, ADVLOOT_SITE.ADV_CITY_DYNAC)
end

function AdvLootManager:ClearRandomPos()
    self._GridAdvlootCount = {}
    self._MazeGridRand = {}
    self.mazeMazeDynamicAdvLootPosDict = {}
end

function AdvLootManager:New_RandomPos(mazeGridOrMapID, uiID, eType)
    local _AllPos = {}
    local _RandomPos = {}
    local _TempRand = {}
    if eType == ADVLOOT_SITE.ADV_CITY_DYNAC then
        _RandomPos = self._DynacMapAdvlootCount
        _TempRand = self._MapGridRand
        _AllPos = self._mapDynamicAdvLootPosDict
    else
        _RandomPos = self._GridAdvlootCount
        _TempRand = self._MazeGridRand
        _AllPos = self.mazeMazeDynamicAdvLootPosDict
    end

    if _AllPos == nil then
        _AllPos = {}
    end

    if _RandomPos == nil then
        _RandomPos = {}
    end

    if _RandomPos[mazeGridOrMapID] == nil then
        local _randtemp = self:Randomx(1,8,8)
        if _TempRand == nil then
            _TempRand = {}
        end

        if _TempRand[mazeGridOrMapID]  == nil then
            _TempRand[mazeGridOrMapID] = {}
        end
        _TempRand[mazeGridOrMapID] = _randtemp
        local _newRandtemp = self:Randomx(9,16,8)
        for i = 1,#_newRandtemp do
            _TempRand[mazeGridOrMapID][#_TempRand[mazeGridOrMapID] + i] = _newRandtemp[i]
        end

        _RandomPos[mazeGridOrMapID] = 1
    else
        _RandomPos[mazeGridOrMapID] = _RandomPos[mazeGridOrMapID] + 1
    end

    local iIndex = _RandomPos[mazeGridOrMapID]
    iIndex = iIndex or 1
    local vec2Pos
    if iIndex > 16 then
        local iRandom = math.random(1,16)
        vec2Pos = DEFAULT_POS[iRandom]
    else
        local iRandom = _TempRand[mazeGridOrMapID][iIndex]
        vec2Pos = DEFAULT_POS[iRandom]
    end

    local fposX,fposY = 0, 0
    if vec2Pos then
        fposX = math.random(vec2Pos.x - DEFAULT_DISTANCE_X, vec2Pos.x + DEFAULT_DISTANCE_X)
        fposY = math.random(vec2Pos.y - DEFAULT_DISTANCE_Y, vec2Pos.y + DEFAULT_DISTANCE_Y)
    end

    _AllPos[uiID] = {x = fposX, y = fposY}

    if eType == ADVLOOT_SITE.ADV_CITY_DYNAC then
        self._DynacMapAdvlootCount =  _RandomPos
        self._MapGridRand = _TempRand
        self._mapDynamicAdvLootPosDict = _AllPos
    else
        self._GridAdvlootCount = _RandomPos
        self._MazeGridRand = _TempRand
        self.mazeMazeDynamicAdvLootPosDict = _AllPos
    end
    return fposX, fposY, true
end

--抽取随机 cnt <= n - m + 1
function AdvLootManager:Randomx( m,n,cnt )
    if cnt>n-m+1 then
        return {}
    end
    local t = {}
    local tmp = {}
    while cnt>0 do
        local x =math.random(m,n)
        if not tmp[x] then
            t[#t+1]=x
            tmp[x]=1
            cnt=cnt-1
        end
    end
    return t
end

function AdvLootManager:GetBackpagPosition(ContentObj)
    local navUI = WindowsManager:GetInstance():GetUIWindow('NavigationUI');
    if navUI then
        local wp = navUI.Button_backpack.transform:TransformPoint(DRCSRef.Vec3Zero);
        local targetPos = ContentObj.transform:InverseTransformPoint(wp)
        return targetPos
    end
    return nil
end

-- 特殊物品显示
local ABSORB_DROP_ITEM_ID = 901915 -- 吸能掉落物品

function AdvLootManager:GetSpecialShowItemAdvType(itemBaseID)
    if itemBaseID == ABSORB_DROP_ITEM_ID then
        return AdvLootType.ALT_ABSORBDROP
    end

    return nil
end
function AdvLootManager:GetSpecialShowItemName(itemBaseID)
    if itemBaseID == ABSORB_DROP_ITEM_ID then
        local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
        local evolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(mainRoleID, NET_ABSORBATTR_ITEM)

        if evolution and evolution.iParam2 ~= AttrType.ATTR_NULL and evolution.iParam3 ~= 0 then
            local attrName = GetEnumText("AttrType", evolution.iParam2)
            local value = evolution.iParam3
            if attrName then
                local rank = RoleDataManager:GetInstance():GetRoleRankByTypeID(evolution.iParam1)
                local itemName = string.format("%d%s", value, attrName)
                if rank then
                    itemName = getRankBasedText(rank, itemName)
                end
                return itemName
            end
        end
    end

    return nil
end
function AdvLootManager:GetSpecialShowItemRank(itemBaseID)
    if itemBaseID == ABSORB_DROP_ITEM_ID then
        local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
        local evolution = EvolutionDataManager:GetInstance():GetEvolutionsByTypeOnlyLast(mainRoleID, NET_ABSORBATTR_ITEM)

        if evolution and evolution.iParam1 ~= 0 then
            local rank = RoleDataManager:GetInstance():GetRoleRankByTypeID(evolution.iParam1)
            return rank
        end
    end

    return nil
end
