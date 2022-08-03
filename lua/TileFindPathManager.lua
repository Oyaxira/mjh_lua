TileFindPathManager = class('TileFindPathManager')
TileFindPathManager._instance = nil
local MAX_FIND_NUME = 70

function TileFindPathManager:GetInstance()
    if TileFindPathManager._instance == nil then
        TileFindPathManager._instance = TileFindPathManager.new()
        TileFindPathManager._instance:Init()
    end
    return TileFindPathManager._instance
end

function TileFindPathManager:Init()
    self.iCurScriptID = nil
    self.AMap = {}

    self.starPos = {x = -1, y = -1}
    self.endPos = {x = -1, y = -1}
    self.toolCom = {
		{x=0,y=1},{x=1,y=0},{x=-1,y=0},{x=0,y=-1},
	}
end

local minX, maxX, minY, maxY = -120, 75, -72, 80
function TileFindPathManager:InitMapData(comMap, iCurScriptID)
    if self.iCurScriptID == iCurScriptID then
        return
    end
    for x = minX, maxX do
        for y = minY, maxY do
            t = comMap:GetTile(DRCSRef.Vec3Int(x,y,0))
            tileID = ToTileID(x,y)
            self.AMap[x] = self.AMap[x] or {}
            local bObstacle = 0
            if t and t.name == 'notpass' then
                bObstacle = 1
            end
            local map = {}
			map.x = x
			map.y = y
			map.g = 999
			map.h = 0
			map.f = 0
			map.node = {x=0,y=0}
			map.info = bObstacle
            self.AMap[x][y] = map
        end
    end
    self.iCurScriptID = iCurScriptID
end

function TileFindPathManager:AStarFind(iX, iY, iEndX, iEndY)
	if iX == iEndX and iY == iEndY then
		return {}
	end
	self.starPos = {x = iX, y = iY}
	self.endPos =  {x = iEndX, y = iEndY}
	self.mapOpenList = {}
	self.mapCloseList = {}
	local node = {}
	local mapNode = self.AMap[self.starPos.x][self.starPos.y]
	mapNode.g = 0
	mapNode.h = math.abs(self.endPos.x - self.starPos.x) +  math.abs(self.endPos.y - self.starPos.y)
	mapNode.f = mapNode.g + mapNode.h
	mapNode.node = {x=999,y=999}
	table.insert(self.mapOpenList,mapNode)
	self:RefreshMap(mapNode)
	local wayNodeList = {}
	local wayNode = self.AMap[self.endPos.x][self.endPos.y]
	table.insert(wayNodeList,wayNode)
	local circulateIndex = 0
	while wayNode.x~=self.starPos.x or wayNode.y~=self.starPos.y do
		local x,y = wayNode.node.x,wayNode.node.y
		wayNode = self.AMap[x][y]
		table.insert(wayNodeList,wayNode)
		circulateIndex = circulateIndex + 1
		if circulateIndex >= MAX_FIND_NUME then
			wayNodeList = {}
			break
		end
	end
	local index = 0
	for i = 0,#wayNodeList-1 do
		index = #wayNodeList - i
		node[i + 1] = {x = wayNodeList[index].x, y = wayNodeList[index].y}
	end
	table.remove(node, 1)
	return node
	
end
function TileFindPathManager:RefreshMap(node)
	for i,pos in ipairs(self.toolCom) do
		local nodePos = {x=node.x-pos.x, y=node.y-pos.y}
		if nodePos.x>minX and nodePos.x<=maxX and nodePos.y>minY and nodePos.y<=maxY and
			self.AMap[nodePos.x][nodePos.y].info ~= 1 then
			local mapNode = self.AMap[nodePos.x][nodePos.y]
			local value = 1
			if math.abs(mapNode.x - node.x) > 0 and math.abs(mapNode.y - node.y)>0 then
				value = 1.41
			end
			local flog = 0
			for i,map in ipairs(self.mapOpenList) do
				if map.x == mapNode.x and map.y == mapNode.y then
					if node.g + value < map.g then
						map.g = node.g + value
						map.f = map.g + map.h
						map.node.x = node.x
						map.node.y = node.y
					end
					flog = 1
				end
			end
			for i,map in ipairs(self.mapCloseList) do
				if map.x == mapNode.x and map.y == mapNode.y then
					flog = 1
				end
			end
			if flog == 0 then
				mapNode.g = node.g + value
				mapNode.h = math.abs(self.endPos.x - mapNode.x) +  math.abs(self.endPos.y - mapNode.y)
				mapNode.f = mapNode.g + mapNode.h
				mapNode.node.x = node.x
				mapNode.node.y = node.y
				table.insert(self.mapOpenList,mapNode)
			end
		end
		if nodePos.x==self.endPos.x and nodePos.y==self.endPos.y then
			return
		end
	end
	for i,map in ipairs(self.mapOpenList) do
		if map.x == node.x and map.y == node.y then
			table.remove(self.mapOpenList,i)
			table.insert(self.mapCloseList,map)
			break
		end
	end
	local mapF = 999
	local chooseNode = nil
	for i,map in ipairs(self.mapOpenList) do
		if mapF > map.f then
			chooseNode = map
			mapF = map.f
		end
	end
	if chooseNode then
		self:RefreshMap(chooseNode)
	end
end

return TileFindPathManager