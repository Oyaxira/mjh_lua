PathFinder = class("PathFinder")

PathFinder._instance = nil
function PathFinder:ctor() 
	self.grid = Grid.new(SSD_BATTLE_GRID_WIDTH,SSD_BATTLE_GRID_HEIGHT)
end


function PathFinder:GetInstance()
    if PathFinder._instance == nil then
        PathFinder._instance = PathFinder.new()
        PathFinder._instance:BeforeInit()
    end

    return PathFinder._instance
end

function PathFinder:BeforeInit()

end

function PathFinder:Clear()
	self.grid:Reinitialize()
end
local kUnitMgr = UnitMgr:GetInstance()
local math_abs = math.abs
function PathFinder:GetCanMoveGrid(startX,startY,iMoveDistance,iUnitIndex)
	local _canMoveGrid = {}
	local node, neighbors, neighbor
	local iOffSet = iMoveDistance -1
	--[todo] 后面可以考虑 把单位可移动的位置 提前算出来，然后只判断点是否在格子内就可以了。
	local openList = {}
	openList[1] = self.grid:GetNodeAt(startX,startY)
	_canMoveGrid[#_canMoveGrid + 1] = {startX,startY}
	local kUnit = kUnitMgr:GetUnit(iUnitIndex)
	local iSelfCamp = kUnit and kUnit:GetCamp() or 1
	local step = 0
	while #openList > 0 do
		node = table.remove(openList,1)
		step = node.step + 1
		if step > iMoveDistance then
			break
		end
		neighbors = node.neighbors
		for k = 1,#neighbors do
			neighbor = neighbors[k]
			if neighbor.closed == false then
				neighbor.step = step
				if neighbor.Walkable(iUnitIndex) then
					_canMoveGrid[#_canMoveGrid + 1] = {neighbor.x,neighbor.y}
					table.insert(openList,neighbor)
				else
					if neighbor.aiUnitIndex then 
						local flag = true
						for k,v in pairs(neighbor.aiUnitIndex) do
							if UnitMgr:GetInstance():IsSameCamp(k,iUnitIndex) == false then 
								flag = false
								break
							end
						end
						if flag then 
							table.insert(openList,neighbor)
						end
					end
				end
				
			end
			neighbor.closed = true
		end
	end
	self.grid:ClearNodeFlag()
	return _canMoveGrid
end

function PathFinder:SetWalkableAt(x,y,walkable,iUnitIndex,iCamp)
	self.grid:SetWalkableAt(x,y,walkable,iUnitIndex,iCamp)
	local kGridNode = self.grid:GetNodeAt(x,y)
	if kGridNode then
		for iUnitIndex,v in pairs(kGridNode.aiUnitIndex) do
			local kUnit = kUnitMgr:GetUnit(iUnitIndex)
			if kUnit and kUnit:GetCamp() ~= iCamp then
				kGridNode.iCamp = SE_INVALID
				break
			end
		end
	end
end

function PathFinder:IsWalkableAt(x,y,iUnitIndex)
	return self.grid:IsWalkableAt(x,y,iUnitIndex)
end

function PathFinder:IsInside(x,y)
	return  self.grid:IsInside(x,y)
end

local l_SkillTargetType = SkillTargetType
function PathFinder:IsTargetGrid(x,y,iTargetType,iSelfIndex,iSelfCamp,martialInfo)
	local boolHasTarget = false
	local aiUnitIndex = self.grid:GetNodeUnitIndex(x,y)
	if aiUnitIndex ~= nil then
		if iTargetType == l_SkillTargetType.SkillTargetType_NULL then --不填 所有空地包括自己
			if getDisperTableSize(aiUnitIndex) == 0 or aiUnitIndex[iSelfIndex] == true then
				boolHasTarget = true
			end
		elseif iTargetType == l_SkillTargetType.SkillTargetType_difang or iTargetType == l_SkillTargetType.SkillTargetType_biaoxingdifang then --敌方  阵营不等于目标阵营
			for iUnitIndex,v in pairs(aiUnitIndex) do
				local kUnit = kUnitMgr:GetUnit(iUnitIndex)
				if kUnit and not kUnit:IsSameCamp(iSelfCamp) and not kUnit:IsDeath() then
					boolHasTarget = true
					break
				end
			end
		elseif iTargetType == l_SkillTargetType.SkillTargetType_youfang then --友方  阵营等于目标阵营或是自己
			for iUnitIndex,v in pairs(aiUnitIndex) do
				local kUnit = kUnitMgr:GetUnit(iUnitIndex)
				if not kUnit:IsDeath() and (iUnitIndex == iSelfIndex or  kUnit and kUnit:IsSameCamp(iSelfCamp)) then
					boolHasTarget = true
					break
				end
			end
		elseif iTargetType == l_SkillTargetType.SkillTargetType_wofang then --我方  自己 
			boolHasTarget = aiUnitIndex[iSelfIndex]
		elseif iTargetType == l_SkillTargetType.SkillTargetType_renyi then --任意单位
			boolHasTarget = getDisperTableSize(aiUnitIndex) ~= 0
			-- 根据是否是内功转医术,内功转移术不能对释放该技能的单位释放
			if martialInfo and martialInfo.eParamInfo & 0x01 == 1 then
				for iUnitIndex,v in pairs(aiUnitIndex) do
					if iUnitIndex == iSelfIndex then
						boolHasTarget = false
						break
					end
				end
			end
		elseif iTargetType == l_SkillTargetType.SkillTargetType_kongdi then --空地
			boolHasTarget = getDisperTableSize(aiUnitIndex) == 0
		end
	end
	
	return  boolHasTarget,aiUnitIndex
end

function PathFinder:ClearNodeFlag(x,y,walkable)
	self.grid:ClearNodeFlag(x,y,walkable)
end

function PathFinder:OnDestroy()
	self:Clear()
end