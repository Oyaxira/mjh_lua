MazeMiniMapUI = class("MazeMiniMapUI",BaseWindow)

local MINIMAP_GRID_MAX_SIZE = 20
local MINIMAP_MAZE_DEFAULT_SIZE = 15

function MazeMiniMapUI:InitNode(objMiniMap)
    self.objMiniMap = objMiniMap
    self.comRectTransform = objMiniMap:GetComponent("RectTransform")

    self.objGridMap = self:FindChild(objMiniMap, 'GridMap')
    self.comGridMapRectTransform = self.objGridMap:GetComponent("RectTransform")
    self.comGridMapLayoutGroup = self.objGridMap:GetComponent("GridLayoutGroup")

    self.objRowBase = self:FindChild(objMiniMap, 'RowBase')
    self.comRowBaseRectTransform = self.objRowBase:GetComponent("RectTransform")
    self.comRowBaseHorLayoutGroup = self.objRowBase:GetComponent("HorizontalLayoutGroup")
    -- 面前迷宫格指示框
    self.objPosSelect = self:FindChild(objMiniMap, 'posSelect')
    self.comPosSelectRect = self.objPosSelect:GetComponent("RectTransform")
    -- 主角位置指示框
    self.objPosSelectRole = self:FindChild(objMiniMap, 'posSelectRole')
    self.comPosSelectRoleRect = self.objPosSelectRole:GetComponent("RectTransform")

    self.gridPool = {}
    self.objGridBase = LoadPrefab("UI/UIPrefabs/Game/GridBase", typeof(CS.UnityEngine.GameObject))
end

function MazeMiniMapUI:UpdateMiniMap()
    local mazeID = MazeDataManager:GetInstance():GetCurMazeID()
    local areaIndex = MazeDataManager:GetInstance():GetCurAreaIndex()
    local needRebuildImmediately = false
    if self.mazeID ~= mazeID or self.areaIndex ~= areaIndex then 
        self:UpdateMazeData(mazeID, areaIndex)
        self:InitMiniMap()
        needRebuildImmediately = true
    end
    self:RefreshMiniMap(needRebuildImmediately)
    self:UpdateExploreInfo()
end

function MazeMiniMapUI:UpdateMazeData(mazeID, areaIndex)
    self.mazeID = mazeID
    self.areaIndex = areaIndex
    self.totalRow = MazeDataManager:GetInstance():GetAreaTotalRow(mazeID, areaIndex)
    self.totalColumn = MazeDataManager:GetInstance():GetAreaTotalColumn(mazeID, areaIndex)
end

function MazeMiniMapUI:InitMiniMap()
    self:ClearMiniMap()
    if self.totalRow == 0 or self.totalColumn == 0 then 
        return 
    end
    -- 需要留一行显示主角位置
    local showRowCount = self.totalRow + 1
    -- 根据最大纵数,行数 进行自适应
    local miniMapWidth = self.comRectTransform.sizeDelta.x
    local miniMapHeight = self.comRectTransform.sizeDelta.y
    -- 横向间隔系数
    local horSpacing = 0.5
    -- 纵向间隔系数
    local verSpacing = 0.25
    local width = miniMapWidth / (self.totalColumn * (1 + horSpacing))
    local height = miniMapHeight / (showRowCount * (1 + verSpacing))
    self.size = math.min(width, height)
    if self.size > MINIMAP_GRID_MAX_SIZE then
        self.size = MINIMAP_GRID_MAX_SIZE
    elseif self.size <= 0 then
        self.size = MINIMAP_MAZE_DEFAULT_SIZE
    end
    self.comGridMapLayoutGroup.constraintCount = self.totalColumn
    self.comGridMapLayoutGroup:SetCellSize(self.size, self.size)
    self.comGridMapLayoutGroup:SetSpacing(self.size * horSpacing, self.size * verSpacing)
    self.comPosSelectRoleRect:SetSizeDelta(self.size, self.size)
    self.comPosSelectRect:SetSizeDelta(self.size * 3 + self.comGridMapLayoutGroup.spacing.x * 2 + 4,  self.size + 6)
    
    for row = self.totalRow, 1, -1 do 
        for column = 1, self.totalColumn do 
            local objGrid = self:GetAvailableGridObj()
            if (objGrid ~= nil) then
                objGrid:SetActive(true)
                objGrid.name = row .. '-' .. column
                local comRectTransform = objGrid:GetComponent('RectTransform')
                self.gridNodeDict[row] = self.gridNodeDict[row] or {}
                self.gridNodeDict[row][column] = {
                    obj = objGrid,
                    rectTransform = comRectTransform
                }
            end
        end
    end
end

function MazeMiniMapUI:RefreshMiniMap(needRebuildImmediately)
    if self.totalRow == 0 or self.totalColumn == 0 then 
        return 
    end
    local curRow, curColumn = MazeDataManager:GetInstance():GetCurPos()
    if curRow == 0 then
        self.objPosSelectRole:SetActive(true)
    else
        self.objPosSelectRole:SetActive(false)
    end

    for row = self.totalRow, 1, -1 do 
        for column = 1, self.totalColumn do 
            if self.gridNodeDict ~= nil and self.gridNodeDict[row] ~= nil and self.gridNodeDict[row][column] ~= nil then 
                self:UpdateGrid(self.gridNodeDict[row][column].obj, row, column)
            end
        end
    end
    for row = self.totalRow, 1, -1 do 
        for column = 1, self.totalColumn do 
            if self.gridNodeDict ~= nil and self.gridNodeDict[row] ~= nil and self.gridNodeDict[row][column] ~= nil then 
            end
        end
    end
    if needRebuildImmediately then 
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(self.comGridMapRectTransform)
    end
    for row = self.totalRow, 1, -1 do 
        for column = 1, self.totalColumn do 
            if self.gridNodeDict ~= nil and self.gridNodeDict[row] ~= nil and self.gridNodeDict[row][column] ~= nil then 
            end
        end
    end
    -- 标注面前的迷宫格
    local frontRow = curRow + 1
    if frontRow > self.totalRow then 
        frontRow = 1
    end
    local posX, posY = self:GetGridNodeSetPosition(frontRow, curColumn)
    self.comPosSelectRect:SetAnchoredPosition(posX, posY)
    -- 标注当前位置
    posX, posY = self:GetGridNodeSetPosition(curRow, curColumn)
    self.comPosSelectRoleRect:SetAnchoredPosition(posX, posY)
end

-- 获取迷宫格设置位置
function MazeMiniMapUI:GetGridNodeSetPosition(row, column)
    local gridRow = row
    local gridColumn = column
    if gridRow == 0 then 
        gridRow = 1
    end
    if self.gridNodeDict == nil or self.gridNodeDict[gridRow] == nil or self.gridNodeDict[gridRow][gridColumn] == nil then 
        return 0, 0
    end
    local comRectTransform = self.gridNodeDict[gridRow][gridColumn].rectTransform
    local position = comRectTransform.anchoredPosition
    if row == 0 then 
        position.y = position.y - self.size - self.comGridMapLayoutGroup.spacing.y
    end
    return position.x, position.y
end

function MazeMiniMapUI:ClearMiniMap()
    if not (self.objMiniMap) then 
        return 
    end
    for _, objGrid in ipairs(self.gridPool) do 
        objGrid:SetActive(false)
    end
    self.gridNodeDict = {}
end

function MazeMiniMapUI:GetAvailableGridObj()
    for _, objGrid in ipairs(self.gridPool) do 
        if not objGrid.activeSelf then
			return objGrid
		end
    end
    local objGrid = CloneObj(self.objGridBase, self.objGridMap)
    table.insert(self.gridPool, objGrid)
	return objGrid
end

function MazeMiniMapUI:CalculateGridSize(parentWidth, rowCount, columnCount)
    local columnSpaceCount = columnCount - 1
    if columnSpaceCount == 0 then
        columnSpaceCount = 1
    end
    local spaceSizeFactor = 0.5
    local gridWidth = parentWidth / (columnCount + (columnSpaceCount * spaceSizeFactor))
    return gridWidth
end

function MazeMiniMapUI:UpdateGrid(objGrid, row, column)
    local comGridImage = objGrid:GetComponent("Image")
    local gridData = MazeDataManager:GetInstance():GetCurAreaMazeGridData(row, column)
    local imageName = nil
    local curRow, curColumn = MazeDataManager:GetInstance():GetCurPos()
    local comGridImageTransform = comGridImage.transform
    comGridImageTransform:SetTransLocalScale(1, 1, 1)
    if gridData == nil or gridData.eFirstType == MazeCardFirstType.MCFT_EMPTY then
        -- 空白格和通路格图片一样, 但是缩放和透明度是一半
        imageName = MazeMiniMapGridImageDict[MazeCardFirstType.MCFT_ROAD]
        comGridImage:SetColor(1, 1, 1, 0.5)
        comGridImageTransform:SetTransLocalScale(0.5, 0.5, 0.5)
    else
        if gridData.bHasExplored == 0 then 
            comGridImage:SetColor(0, 0, 0, 1)
        else
            comGridImage:SetColor(1, 1, 1, 1)
        end
        local firstType = gridData.eFirstType
        local hasTriggered = gridData.bHasTriggered ~= 0
        if curRow and curColumn and row == curRow and column == curColumn then
            -- 当前位置
            imageName = MazeCurrentGridImage
        elseif MazeDataManager:GetInstance():GetCurAreaEventRole(row, column) ~= 0 then
            imageName = MazeMiniMapGridImageDict[MazeCardFirstType.MCFT_TASK]
        elseif firstType == MazeCardFirstType.MCFT_TREASURE and hasTriggered then 
            -- 已经打开过的宝箱
            imageName = MazeOpenedTreasureGridImage
        else
            imageName = MazeMiniMapGridImageDict[firstType]
        end
    end

    if imageName ~= nil then 
        comGridImage.sprite = GetAtlasSprite("CommonAtlas", imageName)
    end
end

function MazeMiniMapUI:UpdateExploreInfo()
    local explorePercent = MazeDataManager:GetInstance():GetCurMazeExplorePercent()
    local comExplorePerText = self:FindChildComponent(self.objMiniMap, 'ExploreInfo/Value', 'Text')
    comExplorePerText.text = math.floor(explorePercent * 100) .. '%'
end

return MazeMiniMapUI