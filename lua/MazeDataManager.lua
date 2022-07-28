MazeDataManager = class("MazeDataManager")
MazeDataManager._instance = nil

function MazeDataManager:GetInstance()
    if MazeDataManager._instance == nil then
        MazeDataManager._instance = MazeDataManager.new()
        MazeDataManager._instance:Init()
    end

    return MazeDataManager._instance
end

function MazeDataManager:Init()
    self:ResetManager()
end

function MazeDataManager:ResetManager()
    self.mazeDataMap = {}
    self.mazeCardDataMap = {}
    self.mazeAreaDataMap = {}
    self.mazeGridDataMap = {}

    self.iCurMazeID = 0
    self.iCurMazeTypeID = 0    
    self.iCurMazeNameID = 0
    self.iCurAreaIndex = nil
    self.iCurMazeAreaID = nil

    self.kCurMazeData = nil
    self.kCurMazeAreaData = nil

    self.oldPos_Row = nil
    self.oldPos_Column = nil

    self.clickMazeID = nil
    self.clickAreaIndex = nil
    self.clickRow = nil
    self.clickColumn = nil

    self.advGiftBubbleCache = nil
    self.advGiftBubbleInfo_queue = nil
end

-- 收到下发迷宫数据后强刷界面
function MazeDataManager:RefreshMazeLayerWhenSyncData()
    if IsWindowOpen('MazeUI') then 
        LuaEventDispatcher:addEventListener('UPDATE_MAZE_DATA', function()
            DisplayActionManager.GetInstance():UpdateMazeUI()
        end, nil, nil, true)
    end
end

function MazeDataManager:UpdateMazeData(mazeID, mazeData)
    self.mazeDataMap[mazeID] = mazeData
    if mazeID == self.iCurMazeID then
        self:_SetCurMazeData(mazeData)
    end
end

local MazeCardIndexFunction = function(cardData, key)
    local cardBaseID = rawget(cardData, 'BaseID')
    local cardBaseData = TableDataManager:GetInstance():GetTableData("MazeCard", cardBaseID)
    if cardBaseData == nil then 
        return nil
    end
    return cardBaseData[key]
end

function MazeDataManager:UpdateMazeCardData(cardID, netCardData)
    local cardData = {}
    cardData.ID = netCardData.uiID
    cardData.BaseID = netCardData.uiTypeID
    if dnull(netCardData.uiNameID) then 
        cardData.NameID = netCardData.uiNameID
    end
    if dnull(netCardData.uiArtSettingID) then 
        cardData.ArtSettingID = netCardData.uiArtSettingID
    end
    if dnull(netCardData.uiNeverAutoMove) then 
        cardData.NeverAutoMove = netCardData.uiNeverAutoMove
    end
    if dnull(netCardData.uiNeverAutoTrigger) then 
        cardData.NeverAutoTrigger = netCardData.uiNeverAutoTrigger
    end
    if dnull(netCardData.uiPlotID) then 
        cardData.PlotID = netCardData.uiPlotID
    end
    if dnull(netCardData.uiRoleID) then 
        cardData.RoleID = netCardData.uiRoleID
    end
    if dnull(netCardData.kCardItem) and dnull(netCardData.kCardItem.uiNameID) and dnull(netCardData.kCardItem.uiModelID) then 
        cardData.CardItem = {}
        cardData.CardItem.NameID = netCardData.kCardItem.uiNameID
        cardData.CardItem.ModelID = netCardData.kCardItem.uiModelID
    end
    if dnull(netCardData.uiUnlockGiftType) then 
        cardData.UnlockGiftType = netCardData.uiUnlockGiftType
    end
    if dnull(netCardData.uiUnlockGiftLevel) then 
        cardData.UnlockGiftLevel = netCardData.uiUnlockGiftLevel
    end
    if dnull(netCardData.uiClickAudio) then 
        cardData.ClickAudio = netCardData.uiClickAudio
    end
    if dnull(netCardData.uiCardType) then 
        cardData.CardType = netCardData.uiCardType
    end
    if dnull(netCardData.uiCardSecondType) then 
        cardData.CardSecondType = netCardData.uiCardSecondType
    end
    if dnull(netCardData.uiNeedResetTreasure) then 
        cardData.NeedResetTreasure = netCardData.uiNeedResetTreasure
    end
    if dnull(netCardData.uiTaskID) then 
        cardData.TaskID = netCardData.uiTaskID
    end
    setmetatable(cardData, {__index = MazeCardIndexFunction})
    self.mazeCardDataMap[cardID] = cardData
end

function MazeDataManager:UpdateMazeAreaData(areaID, areaData)
    self.mazeAreaDataMap[areaID] = areaData
    if areaID == self.iCurMazeAreaID then
        self.kCurMazeAreaData = areaData
    end
end

function MazeDataManager:_SetCurMazeData(mazeData)
    self.kCurMazeData = mazeData
    if mazeData and mazeData.auiAreaIDs then
        self.iCurMazeAreaID = mazeData.auiAreaIDs[mazeData.uiCurAreaIndex]
        self.iCurAreaIndex = mazeData.uiCurAreaIndex
        self.kCurMazeAreaData = self.mazeAreaDataMap[self.iCurMazeAreaID] or self.kCurMazeAreaData
        self:_SetCurMazeTypeData(self.iCurMazeID)
    else
        self.iCurMazeAreaID = nil
        self.iCurAreaIndex = -1
    end
end

function MazeDataManager:_SetCurMazeTypeData(iCurMazeID)
    self.iCurMazeTypeID = self:GetMazeTypeID(iCurMazeID)
    local mazeTypeData = self:GetMazeTypeDataByTypeID(self.iCurMazeTypeID)
    if mazeTypeData then
        self.iCurMazeTypeID = mazeTypeData.BaseID
        self.iCurMazeNameID = mazeTypeData.Name
        self.kCurMazeAreaData = self:GetAreaData(self.iCurMazeAreaID)
    else
        self.iCurMazeTypeID = 0
        self.iCurMazeNameID = 0
    end
end

function MazeDataManager:SetCurMazeID(iID)
    if iID == self.iCurMazeID then 
        return 
    end
    self.iCurMazeID = iID
    self:_SetCurMazeTypeData(self.iCurMazeID)
    local mazeData =  self:GetMazeDataByID(self.iCurMazeID)
    self:_SetCurMazeData(mazeData)
end


function MazeDataManager:UpdateMazeGridData(gridID, gridData)
    self.mazeGridDataMap[gridID] = gridData
end

function MazeDataManager:GetCurMazeData()
    return self.kCurMazeData
end

function MazeDataManager:GetCurMazeID()
    return  self.iCurMazeID
end

function MazeDataManager:IsCurMaze(mazeID)
    if GetGameState() ~= GS_MAZE then 
        return false
    end
    return self.iCurMazeTypeID == mazeID
end

function MazeDataManager:IsInMaze(mazeID)
    if GetGameState() ~= GS_MAZE then 
        return false
    end
    return self.iCurMazeID ~= 0
end

function MazeDataManager:GetCurMazeTypeID()
    if GetGameState() ~= GS_MAZE then 
        return 0
    end
    return self.iCurMazeTypeID
end

function MazeDataManager:GetMazeAreaTypeDataByID()
    local areaTypeData = self:GetAreaTypeDataByAreaIndex(self.iCurMazeID,self.iCurAreaIndex)
    if areaTypeData == nil then 
        return 
    end
    return areaTypeData.BaseID
end

function MazeDataManager:GetCurMazeName()
    return GetLanguageByID(self.iCurMazeNameID) or ''
end


function MazeDataManager:GetMazeName(mazeID)
    local typedata = self:GetMazeTypeDataByTypeID(mazeID)
    if (not typedata) then
        return ""
    end

    return  GetLanguageByID(typedata.Name) or ''
end

function MazeDataManager:GetCurMazeExplorePercent()
    local curAreaData = self:GetCurMazeAreaData()
    if not curAreaData or not curAreaData.auiMazeGridIDs then 
        return 0
    end
    -- 空白地形格数量
    local emptyGridCount = 0
    -- 已探索地形格数量
    local exploreGridCount = 0
    for i = 0, curAreaData.iMazeGridCount - 1 do 
        local gridID = curAreaData.auiMazeGridIDs[i]
        local gridData = self:GetGridData(gridID)
        if gridData == nil or self:IsEmptyGrid(gridData) then 
            emptyGridCount = emptyGridCount + 1
        elseif gridData.bHasExplored == 1 then 
            exploreGridCount = exploreGridCount + 1
        end
    end
    if emptyGridCount == curAreaData.iMazeGridCount then 
        return 0
    end
    return exploreGridCount / (curAreaData.iMazeGridCount - emptyGridCount)
end

function MazeDataManager:GetCurAreaName()
    local areaNameID = self:GetCurAreaNameID()
    return GetLanguageByID(areaNameID) or ''
end

function MazeDataManager:GetCurAreaNameID()
    local areaTypeData = self:GetAreaTypeDataByAreaIndex(self.iCurMazeID, self.iCurAreaIndex)
    if areaTypeData == nil then
        return 0
    end
    return areaTypeData.Name or 0
end

function MazeDataManager:GetCurAreaTemplateTerrainID()
    if self.kCurMazeAreaData == nil then
        return 0
    end
    return self.kCurMazeAreaData.uiTemplateTerrainID or 0
end

function MazeDataManager:GetOldPos()
    self.oldPos_Row = self.oldPos_Row or -1
    self.oldPos_Column = self.oldPos_Column or -1
    return self.oldPos_Row,self.oldPos_Column
end

function MazeDataManager:RecordOldPos(uiCurPosRow,uiCurPosColumn)
    --local uiCurPosRow,uiCurPosColumn = self:GetCurPos()
    self.oldPos_Row = uiCurPosRow
    self.oldPos_Column = uiCurPosColumn
end

function MazeDataManager:GetCurPos()
    if self.kCurMazeData == nil then 
        return 0, 0
    end
    return self.kCurMazeData.uiCurPosRow, self.kCurMazeData.uiCurPosColumn
end

function MazeDataManager:GetCurAreaIndex()
    return self.iCurAreaIndex
end

function MazeDataManager:GetMazeDataByID(mazeID)
    return self.mazeDataMap[mazeID]
end

function MazeDataManager:GetMazeTypeDataByTypeID(mazeTypeID)
    return TableDataManager:GetInstance():GetTableData("Maze",mazeTypeID)
end

function MazeDataManager:GetMazeArtDataByID(mazeID)
    local mazeTypeID = self:GetMazeTypeID(mazeID)
    return self:GetMazeArtDataByTypeID(mazeTypeID)
end

function MazeDataManager:GetMazeArtDataByTypeID(mazeTypeID)
    local mazeTypeData = self:GetMazeTypeDataByTypeID(mazeTypeID)
    if mazeTypeData == nil or mazeTypeData.ArtSettingID == nil then 
        return nil
    end
    return TableDataManager:GetInstance():GetTableData("MazeArtSetting",mazeTypeData.ArtSettingID)
end

function MazeDataManager:GetMazeTypeID(mazeID)
    local mazeData = self:GetMazeDataByID(mazeID)
    if mazeData == nil then 
        return 0
    end
    return mazeData.uiTypeID or 0
end


function MazeDataManager:GetAreaTypeDataByTypeID(areaTypeID) 
    return GetTableData("MazeArea",areaTypeID)
end

function MazeDataManager:GetAreaTypeDataByID(areaID) 
    local areaTypeID = self:GetAreaTypeIDByID(areaID)
    return self:GetAreaTypeDataByTypeID(areaTypeID)
end

function MazeDataManager:GetAreaTypeIDByID(areaID) 
    local areaData = self:GetAreaData(areaID)
    if areaData == nil then 
        return 0
    end
    return areaData.uiTypeID
end

function MazeDataManager:FormatRow(mazeID, areaIndex, row) 
    mazeID = mazeID or self.iCurMazeID
    areaIndex = areaIndex or self.iCurAreaIndex
    local totalRow = self:GetAreaTotalRow(mazeID, areaIndex)
    if totalRow <= 0 then 
        return row
    end
    if row > totalRow then 
        row = row % totalRow
    end
    while row <= 0 do 
        row = row + totalRow
    end
    return row
end

function MazeDataManager:SetCurClickInfo(mazeID, areaIndex, row, column)
    self.clickMazeID = mazeID
    self.clickAreaIndex = areaIndex
    self.clickRow = row
    self.clickColumn = column
end

--==--------------------------------------- 迷宫区域部分 -------------------------------------------
function MazeDataManager:GetAreaData(areaID) 
    return self.mazeAreaDataMap[areaID]
end

function MazeDataManager:GetAreaTotalRow(mazeID, areaIndex) 
    local terrainTypeData = self:GetAreaTerrainTypeData(mazeID, areaIndex)
    if terrainTypeData == nil then 
        return 0
    end
    return terrainTypeData.RowCount
end

function MazeDataManager:GetAreaTotalColumn(mazeID, areaIndex) 
    local terrainTypeData = self:GetAreaTerrainTypeData(mazeID, areaIndex)
    if terrainTypeData == nil then 
        return 0
    end
    return terrainTypeData.ColumnCount or 0
end

function MazeDataManager:GetAreaTerrainTypeData(mazeID, areaIndex) 
    local areaTypeData = self:GetAreaTypeDataByAreaIndex(mazeID, areaIndex)

    if areaTypeData == nil then 
        return 
    end
    local terrainTypeID = areaTypeData.TerrainID
    return self:GetTerrainTypeDataByTypeID(terrainTypeID)
end

function MazeDataManager:GetAreaTypeDataByAreaIndex(mazeID, areaIndex) 
    local areaData = self:GetAreaDataByAreaIndex(mazeID, areaIndex)
    if areaData == nil then 
        return nil
    end
    local areaTypeID = areaData.uiTypeID
    return self:GetAreaTypeDataByTypeID(areaTypeID)
end

function MazeDataManager:GetAreaDataByAreaIndex(mazeID, areaIndex) 
    local mazeData = self:GetMazeDataByID(mazeID)
    if not (type(mazeData) == 'table' and type(mazeData.auiAreaIDs) == 'table') then
        return nil
    end
    local areaID = mazeData.auiAreaIDs[areaIndex]
    return self:GetAreaData(areaID)
end

function MazeDataManager:GetTerrainTypeDataByTypeID(terrainTypeID) 
    if type(terrainTypeID) ~= 'number' then 
        return nil
    end

    return TableDataManager:GetInstance():GetTableData("MazeTerrain", terrainTypeID)
end


function MazeDataManager:GetCurMazeAreaTypeID()
    if self.kCurMazeAreaData == nil then 
        return nil
    end
    return self.kCurMazeAreaData.uiTypeID
end

function MazeDataManager:GetCurMazeAreaID()
    return self.iCurMazeAreaID
end

function MazeDataManager:GetCurMazeAreaData()
    return self.kCurMazeAreaData
end
--==-----------------------------------------------------------------------------------------------

--==--------------------------------------- 迷宫地形格部分 -------------------------------------------
function MazeDataManager:GetCurAreaMazeGridData(row, column)
    local mazeID = self.iCurMazeID
    local areaIndex = self.iCurAreaIndex
    local areaData = self.kCurMazeAreaData
    if areaData == nil then
        return nil
    end
    local totalColumn = self:GetAreaTotalColumn(mazeID, areaIndex)
    if column <= 0 or column > totalColumn then 
        return nil
    end
    row = self:FormatRow(mazeID, areaIndex, row)
    for i = 0, areaData.iMazeGridCount - 1 do 
        local gridID = areaData.auiMazeGridIDs[i]
        local gridData = self:GetGridData(gridID)
        if gridData and gridData.uiRow == row and gridData.uiColumn == column then
            return gridData
        end
    end

    return nil 
end

function MazeDataManager:GetAreaMazeGridData(areaID, row, column)
    local areaData = self.mazeAreaDataMap[areaID]
    if not areaData then 
        return nil
    end
    for i = 0, areaData.iMazeGridCount - 1 do 
        local gridID = areaData.auiMazeGridIDs[i]
        local gridData = self:GetGridData(gridID)
        if gridData and gridData.uiRow == row and gridData.uiColumn == column then
            return gridData
        end
    end
    return nil
end

function MazeDataManager:GetGridDataInMaze(mazeID, areaIndex, row, column)
    local areaData = self:GetAreaDataByAreaIndex(mazeID, areaIndex)
    if not (type(areaData) == 'table' and type(areaData.auiMazeGridIDs) == 'table') then 
        return nil
    end
    local totalColumn = self:GetAreaTotalColumn(mazeID, areaIndex)
    if column <= 0 or column > totalColumn then 
        return nil
    end
    row = self:FormatRow(mazeID, areaIndex, row)
    for i = 0, areaData.iMazeGridCount - 1 do 
        local gridID = areaData.auiMazeGridIDs[i]
        local gridData = self:GetGridData(gridID)
        if gridData and gridData.uiRow == row and gridData.uiColumn == column then
            return gridData
        end
    end
    return nil 
end

function MazeDataManager:GetCurAreaEventRole(row, column)
    local gridData = self:GetCurAreaMazeGridData(row, column)
    if gridData == nil then 
        return 0
    end
    return gridData.uiEventRoleID or 0
end

function MazeDataManager:IsCurAreaGridUnlock(row, column)
    local gridData = self:GetCurAreaMazeGridData(row, column)
    return self:IsGridUnlock(gridData)
end

function MazeDataManager:IsGridInCurArea(searchGridID)
    local curAreaData = self:GetCurMazeAreaData()
    if not (curAreaData and curAreaData.auiMazeGridIDs) then 
        return false
    end
    for i = 0, curAreaData.iMazeGridCount - 1 do 
        local gridID = curAreaData.auiMazeGridIDs[i]
        if gridID == searchGridID then 
            return true
        end
    end
    return false
end

function MazeDataManager:GetGridData(gridID)
    return self.mazeGridDataMap[gridID]
end

function MazeDataManager:IsTriggerHideGrid(gridData)
    for _, gridType in ipairs(TriggerHideMazeGridTypeList) do 
        if gridType == gridData.eFirstType then 
            return true
        end
    end
    return false
end

function MazeDataManager:IsGridUnlock(gridData)
    if gridData == nil then 
        return false
    end
    return gridData.bIsUnlock == 1
end

function MazeDataManager:IsEmptyGrid(gridData)
    if type(gridData) ~= 'table' then 
        return false
    end
    return gridData.eFirstType == MazeCardFirstType.MCFT_NULL or gridData.eFirstType == MazeCardFirstType.MCFT_EMPTY or gridData.eFirstType == MazeCardFirstType.MCFT_END
end

--==-------------------------------------------------------------------------------------------------

--==--------------------------------------- 迷宫卡片部分 -------------------------------------------
function MazeDataManager:GetCurAreaMazeCardData(row, column, returnRealCard)    
    local gridData = self:GetCurAreaMazeGridData(row, column)
    if gridData == nil then 
        return nil
    end
    local cardID = 0
    local cardData = nil
    if (not returnRealCard) and ((gridData.bHasTriggered ~= 0 and self:IsTriggerHideGrid(gridData)) or (gridData.uiCardID == 0 and gridData.uiBaseCardTypeID == 0)) then 
        local areaID = self.iCurMazeAreaID
        cardTypeID = self:GetCardTypeIdFromAreaCardSetting(areaID, MazeCardFirstType.MCFT_ROAD)
        cardData = self:GetCardTypeData(cardTypeID)
        if cardData ~= nil then 
            return cardData
        end
    end
    if gridData.uiCardID and gridData.uiCardID ~= 0 then 
        cardID = gridData.uiCardID
        cardData = self:GetCardData(cardID)
    elseif gridData.uiBaseCardTypeID and gridData.uiBaseCardTypeID ~= 0 then 
        cardID = gridData.uiBaseCardTypeID
        cardData = self:GetCardTypeData(cardID)
    end
    return cardData
end

function MazeDataManager:GetCardTypeIdFromAreaCardSetting(areaID, firstType, secondType)
    local areaTypeData = self:GetAreaTypeDataByID(areaID)
    if areaTypeData == nil or areaTypeData.CardSettingList == nil then 
        return 0
    end
    for _, cardSetting in ipairs(areaTypeData.CardSettingList) do 
        if cardSetting.FirstType == firstType and (secondType == nil or cardSetting.SecondType == nil or secondType == MazeCardFirstType.MCFT_NULL or cardSetting.SecondType == MazeCardFirstType.MCFT_NULL or cardSetting.SecondType == secondType) then 
            return cardSetting.CardID
        end
    end
    return 0
end

function MazeDataManager:GetCurAreaMazeCardLockGiftType(row, column)
    local cardData = self:GetCurAreaMazeCardData(row, column)
    if cardData == nil then 
        return nil
    end
    return cardData.UnlockGiftType
end

function MazeDataManager:GetCardData(cardID) 
    return self.mazeCardDataMap[cardID]
end

function MazeDataManager:GetCardTypeID(cardID) 
    local cardData = self:GetCardData(cardID)
    if cardData == nil then 
        return 0
    end
    return cardData.BaseID
end

function MazeDataManager:GetCardTypeData(cardID) 
    return TableDataManager:GetInstance():GetTableData("MazeCard", cardID)
end

function MazeDataManager:GetCardArtData(cardTypeID) 
    local cardTypeData = self:GetCardTypeData(cardTypeID)
    if cardTypeData == nil then 
        return 
    end
    local cardArtID = cardTypeData.ArtSettingID or 0
    return GetTableData("MazeCardArtSetting",cardArtID)
end

--==-----------------------------------------------------------------------------------------------

--==--------------------------------------- 迷宫剧情部分 -------------------------------------------
function MazeDataManager:DisplayUnlockChoice(giftType, giftLevel, curGiftLevel) 
    local configData = self:GetMazeUnlockGiftConfig(giftType)
    if configData == nil then 
        return
    end
    -- 获取 显示文字 文本格式
    local tipTextID = configData.TipText
    local tipTextFormat = GetLanguageByID(tipTextID)
    local tipText = ''
    if tipTextFormat ~= nil then 
        tipText = string.format(tipTextFormat, giftLevel, curGiftLevel)
    end
    local plotTaskID = 0
    PlotDataManager:GetInstance():AddCustomPlot(plotTaskID, PlotType.PT_SHOW_CHOOSE_TEXT, 0, 0, tipText)

    -- 选择
    local unlockChoiceID = 0
    local unlockChoiceText = ''
    local canUnlock = curGiftLevel >= giftLevel
    if canUnlock then 
        unlockChoiceID = configData.UnlockChoiceText
    else
        local giftLangID = AdventureType_Lang[giftType]
        local giftName = GetLanguageByID(giftLangID)
        if giftName ~= nil then 
            unlockChoiceText = string.format('%s > %s', giftName, giftLevel)
        end
    end
    local unlockCallback = function()
        SendClickMaze(CMAT_UNLOCKGRID, self.clickRow, self.clickColumn)
        AddLoadingDelayRemoveWindow('DialogChoiceUI', true)
    end
    local goAwayCallback = function()
        SendClickMaze(CMAT_GOAWAY)
        AddLoadingDelayRemoveWindow('DialogChoiceUI', true)
    end
    local leaveCallback = function()
        ResetWaitDisplayMsgState()
        DisplayActionEnd()
    end
    PlotDataManager:GetInstance():AddCustomPlot(plotTaskID, PlotType.PT_CHOOSE, unlockChoiceID, canUnlock, unlockCallback, unlockChoiceText)
    PlotDataManager:GetInstance():AddCustomPlot(plotTaskID, PlotType.PT_CHOOSE, MAZE_GO_AWAY_CHOICE_LANG_ID, nil, goAwayCallback)
    PlotDataManager:GetInstance():AddCustomPlot(plotTaskID, PlotType.PT_CHOOSE, LEAVE_CHOICE_LANG_ID, nil, leaveCallback)
end

function MazeDataManager:DisplayUnlockGridSuccess(giftType, row, column, roleID)
    local configData = self:GetMazeUnlockGiftConfig(giftType)
    if configData == nil then 
        return
    end
    local plotTaskID = 0
    -- 角色解锁对话
    local count = #configData.UnlockDialogueList
    local roleDialogueID = configData.UnlockDialogueList[math.random(1, count)]
    local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
    -- TODO: 获取随机满足条件的队友
    PlotDataManager:GetInstance():AddCustomPlot(plotTaskID, PlotType.PT_DIALOGUE, roleTypeID, roleDialogueID)

    -- 解锁动画
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MAZE_GRID_UNLOCK_ANIM, false, row, column)

    -- 解锁结果对话
    local resultDialogueID = configData.UnlockResultText
    PlotDataManager:GetInstance():AddCustomPlot(plotTaskID, PlotType.PT_DIALOGUE, 0, resultDialogueID)
end

function MazeDataManager:GetMazeUnlockGiftConfig(giftType)
    local TB_MazeUnlockGiftConfig = TableDataManager:GetInstance():GetTable("MazeUnlockGiftConfig")
    if TB_MazeUnlockGiftConfig == nil then 
        return nil
    end
    for _, configData in pairs(TB_MazeUnlockGiftConfig) do 
        if configData.UnlockGiftType == giftType then 
            return configData
        end
    end
    return nil
end
--==-----------------------------------------------------------------------------------------------

--==--------------------------------------- 迷宫界面部分 -------------------------------------------
function MazeDataManager:AddAdvGiftBubbleCache(giftType, itemTypeID, coinCount)
    if self.advGiftBubbleCache == nil then 
        self.advGiftBubbleCache = {}
    end
    local bubbleParams = {giftType, itemTypeID, coinCount}
    table.insert(self.advGiftBubbleCache, bubbleParams)
end

function MazeDataManager:GetAdvGiftBubbleCache()
    return self.advGiftBubbleCache
end

function MazeDataManager:ClearAdvGiftBubbleCache()
    self.advGiftBubbleCache = nil
end



-- 服务器下行：加入队列
function MazeDataManager:EnqueueBubble(giftType, itemBaseID, coinCount)
	if self.advGiftBubbleInfo_queue == nil then 
		self.advGiftBubbleInfo_queue = {}
	end
    local advGiftBubbleInfo = {}
	local itemBaseIdDict = {}
	if advGiftBubbleInfo[giftType] == nil then 
		advGiftBubbleInfo[giftType] = {}
		advGiftBubbleInfo[giftType].itemBaseIdDict = {}
	end
	local itemBaseIdDict = advGiftBubbleInfo[giftType].itemBaseIdDict
	itemBaseIdDict[itemBaseID] = true
	advGiftBubbleInfo[giftType].coinCount = coinCount

	self.advGiftBubbleInfo_queue[#self.advGiftBubbleInfo_queue + 1] =  advGiftBubbleInfo
end

function MazeDataManager:DequeueBubble()
    -- 出队
    local mazeUI = GetUIWindow("MazeUI")
    if mazeUI and self.advGiftBubbleInfo_queue ~= nil then
        while(#self.advGiftBubbleInfo_queue > 0) do
            local advGiftBubbleInfo = self.advGiftBubbleInfo_queue[1]
            table.remove(self.advGiftBubbleInfo_queue, 1)
            mazeUI:UpdateAdvGiftBubble(advGiftBubbleInfo)
        end
    end	

end
--==-----------------------------------------------------------------------------------------------
