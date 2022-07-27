Grid = class("Grid")

function Grid:ctor(width, height) 
    self.width = width
    self.height = height
    self.nodes = self:BuildNodes(width, height)
	for i = 1,width do
		for j =1,height do
			self.nodes[i][j].neighbors = self:GetNeighbors(self.nodes[i][j])
		end
	end
end

function  Grid:Node(x,y,walkable)
	local node = {}
	node.closed = false
	node.neighbors = {}
	node.x = x
	node.y = y
	node.aiUnitIndex = {}
	node.step = 0
	node.Walkable = function(iUnitIndex)
		return next(node.aiUnitIndex) == nil or node.aiUnitIndex[iUnitIndex] ~= nil
	end
	-- node.walkable = (walkable == nil and true or walkable)
	return node
end

function Grid:BuildNodes(width, height)
	local nodes = {}
	for i = 1,width do
		nodes[i] = {}
		for j =1,height do
			nodes[i][j] = self:Node(i,j)
		end
	end	
	return nodes
end

function Grid:Reinitialize()
	local nodes = self.nodes
	for i = 1, self.width do
		for j =1,self.height do
			nodes[i][j].closed = false
			-- nodes[i][j].walkable = true
			nodes[i][j].aiUnitIndex = {}
			nodes[i][j].step = 0
		end
	end
end

function Grid:ClearNodeFlag()
	local nodes = self.nodes
	for i = 1, self.width do
		for j =1,self.height do
			nodes[i][j].closed = false
			nodes[i][j].step = 0
		end
	end
end

function Grid:GetNodeAt(x,y)
	if not self:IsInside(x,y) then
		return nil
	end
	return self.nodes[x][y]
end

function Grid:GetNodeUnitIndex(x,y)
	if not self:IsInside(x,y) then
		return nil
	end
	return self.nodes[x][y].aiUnitIndex
end

function Grid:IsWalkableAt(x,y,iUnitIndex)
	return self:IsInside(x,y) and self.nodes[x][y].Walkable(iUnitIndex) --允许自己站在同一个地方
end

function Grid:IsInside(x,y)
	return (x >= 1 and x <= self.width) and (y >=1 and y <= self.height)
end

function Grid:SetWalkableAt(x,y,walkable,iUnitIndex,iCamp)
	if not self:IsInside(x,y) then
		return
	end
	-- self.nodes[x][y].walkable = walkable
	if walkable then
		self.nodes[x][y].aiUnitIndex[iUnitIndex] = nil
	else
		self.nodes[x][y].aiUnitIndex[iUnitIndex] = true
	end
	self.nodes[x][y].iCamp = iCamp
end

--[[
      offsets      
   +---+---+---+    
   |   | 0 |   |   
   +---+---+---+    
   | 3 |   | 1 |    
   +---+---+---+   
   |   | 2 |   |    
   +---+---+---+ 
 */--]]

function Grid:GetNeighbors(node)
	local x = node.x
	local y = node.y
	local neighbors = {}
	local nodes = self.nodes

	-- ↑
    if (self:IsWalkableAt(x, y + 1)) then
		neighbors[#neighbors + 1] = nodes[x][y + 1]
	end	
	-- →
	if (self:IsWalkableAt(x + 1, y )) then
		neighbors[#neighbors + 1] = nodes[x + 1][y]
	end
	-- ↓
	if (self:IsWalkableAt(x , y - 1 )) then
		neighbors[#neighbors + 1] = nodes[x][y -1]
	end	
	-- ←
	if (self:IsWalkableAt(x - 1 , y)) then
		neighbors[#neighbors + 1] = nodes[x-1][y]
	end

    return neighbors
end

