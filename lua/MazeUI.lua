MazeUI = class("MazeUI",BaseWindow)
local MazeGridUI = require 'UI/MazeUI/MazeGridUI'
local MazeMiniMapUI = require 'UI/MazeUI/MazeMiniMapUI'
local MazeRoleUI = require 'UI/MapUI/MazeRoleUI'
local advlootRayCheck = require 'UI/MazeUI/AdvlootRayCheck'

local cardNodeCount = 7
local rowCount = 4
local columnCount = 4
local showRowCount = 4
local showColumnCountMap = {
	[0] = 5,
	[1] = 5,
	[2] = 5,
	[3] = 5,
	[4] = 5
}
--配置卡片可交互性
local interactable = {
	[0] = false,
	[1] = false,
	[2] = true,
	[3] = true,
	[4] = true,
	[5] = false,
	[6] = false
}

MazeUI.dropDownType = {
	['nil'] ={
				['interactable'] = false,
				['textColor'] = COLOR_VALUE[COLOR_ENUM.Gray],
				['iConColor'] = COLOR_VALUE[COLOR_ENUM.Gray],
				['numColor'] = COLOR_VALUE[COLOR_ENUM.Gray],
			},
	['onlyOne'] = 
			{
				['interactable'] = false,
				['textColor'] = COLOR_VALUE[COLOR_ENUM.White],
				['iConColor'] = COLOR_VALUE[COLOR_ENUM.White],
				['numColor'] = COLOR_VALUE[COLOR_ENUM.White],
			},
	['other'] =
			{
				['interactable'] = true,
				['textColor'] = COLOR_VALUE[COLOR_ENUM.White],
				['iConColor'] = COLOR_VALUE[COLOR_ENUM.White],
				['numColor'] = COLOR_VALUE[COLOR_ENUM.White],
			}
}

local mazeUiInfo = {}
local mazeDataMgr = nil

function MazeUI:ctor()
	self.iUpdateFlag = 0
end

function MazeUI:Create()
	local obj = LoadPrefabAndInit("Game/MazeUI",Scence_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end
local wins = {
	"CharacterUI",
	"GeneralBoxUI",
	"TaskUI",
	"PlayerSetUI",
	"CollectionUI",
	"StorageUI"
}
function MazeUI:OnPressESCKey()
	if IsAnyWindowOpen(wins) then return end
	if self.comLeaveMazeBtn  then
		self.comLeaveMazeBtn.onClick:Invoke()
	end
end

function MazeUI:Init()
	if not IsWindowOpen("TaskTipsUI") then
		OpenWindowImmediately("TaskTipsUI")
	end
	self:InitUINode()
	self:InitTeammate()
	self:InitDropDown()
	self:InitCardNodeMap()
	self.isMoving = false
	mazeDataMgr = MazeDataManager:GetInstance()
	self.pressNumCallback={
		nil,
		nil,
		nil
	}
end

function MazeUI:InitUINode()
	self.comBGImg = self:FindChildComponent(self._gameObject, "BG", "Image")
	self.comTeamGroundImg = self:FindChildComponent(self._gameObject, "TeamGround", "Image")
	self.objCardPart = self:FindChild(self._gameObject, "Card")
	self.objMiniMap = self:FindChild(self._gameObject, "TransformAdapt_node_right/MiniMap")
	self.mazeMiniMapUI = MazeMiniMapUI.new()
	self.mazeMiniMapUI:InitNode(self.objMiniMap)
	self.advlootRayCheck = AdvlootRayCheck.new()
	self.advlootRayCheck:Create()
	self.advlootRayCheck:Init()

	self.BuffList = self:FindChild(self._gameObject, "TransformAdapt_node_left/BuffList")
	--self.BuffList_hor__ScrollRect = self:FindChildComponent(self.BuffList,"Scroll View","LoopHorizontalScrollRect")
	self.BuffList_hor__ScrollRect = self:FindChildComponent(self.BuffList,"Scroll View",DRCSRef_Type.LoopVerticalScrollRect)
	if self.BuffList_hor__ScrollRect then
		local fun_Adv = function(transform, idx)
			self:OnBuffListScrollChanged(transform, idx)
		end
		self.BuffList_hor__ScrollRect:AddListener(fun_Adv)
	end

	self.comGetAllLootBtn = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/GetAllLootBtn", "Button")
	if self.comGetAllLootBtn then
		local curDiff = RoleDataManager:GetInstance():GetDifficultyValue()
		if curDiff >= QUICK_GET_LOOT_SCRIPT_LEVEL then
			self.comGetAllLootBtn.gameObject:SetActive(true)
			self:AddButtonClickListener(self.comGetAllLootBtn,function() self:OnClickGetAllLoot() end)
		else
			self.comGetAllLootBtn.gameObject:SetActive(false)
		end
	end

	self.comLeaveMazeBtn = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/LeaveMazeBtn", "Button")
	if self.comLeaveMazeBtn then
		local tipStr = '是否退出迷宫？'
		local backButtonCallback = function()
			-- 掉落没有完全爆出来之前不允许点击
			if g_mazeGridAdvLootUpdateTimer and globalTimer:GetTimer(g_mazeGridAdvLootUpdateTimer) then 
				return
			end
			OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, tipStr, function()
				SendClickMaze(CMAT_QUIT)
			end})
		end
		self:AddButtonClickListener(self.comLeaveMazeBtn,backButtonCallback)
	end

	self.objItems = self:FindChild(self._gameObject,"TransformAdapt_node_left/items")
	self.objItemHorizontalList = self:FindChild(self._gameObject,"TransformAdapt_node_left/items/ItemHorizontalList")
	self.comTeamRecoverBtn = self:FindChildComponent(self._gameObject, "TransformAdapt_node_right/TeamRecoverBtn", "Button")
	if self.comTeamRecoverBtn then
		self:AddButtonClickListener(self.comTeamRecoverBtn,function()
			self.objItems:SetActive(true)
		end)
	end

	self.ItemList = self:FindChild(self._gameObject, "TransformAdapt_node_left/ItemList")
	self.objRoleSpinePool = self:FindChild(self._gameObject, "RoleSpinePool")
	self.comRoleSpinePoolTransform = self.objRoleSpinePool.transform
	self.roleSpineTransformPool = {}
	local childCount = self.comRoleSpinePoolTransform.childCount
	for i = 1, childCount do 
		local comChildTransform = self.comRoleSpinePoolTransform:GetChild(i - 1)
		local comChildRectTransform = comChildTransform:GetComponent('RectTransform')
		local objChild = comChildRectTransform.gameObject
		local SpineObj = objChild:FindChild("Spine")
		objChild.name = 'Spine'
		table.insert(self.roleSpineTransformPool, {
			RectTransform = comChildRectTransform,
			GameObject = objChild,
			['SpineObj'] = SpineObj,
			SpineObjTransform = SpineObj:GetComponent("RectTransform"),
		})
		objChild:SetActive(false)
	end

	self.objBackgroundEffect = self:FindChild(self._gameObject,"BackgroundEffectUI")
	MapEffectManager:GetInstance():InitBackgroundEffect(self.objBackgroundEffect)
end

function MazeUI:InitCardNodeMap()	
	self.rowNodeDict = {}
	self.cardNodePosDict = {}
	self.MazeGridUiDict = {}
	self.GridList = {}
	for i = 1, rowCount do 
		local objCardRowPart = self:FindChild(self.objCardPart, tostring(i))
		local comCardRowPartTransform = objCardRowPart.transform
		local comRowNodeCanvasGroup = objCardRowPart:GetComponent("CanvasGroup")
		local position = comCardRowPartTransform.localPosition
		self.rowNodeDict[i] = {
			obj = objCardRowPart,
			canvasGroup = comRowNodeCanvasGroup,
			position = position
		}
		local cardCount = comCardRowPartTransform.childCount
		for j = 0, cardCount - 1 do 
			local objCard = self:FindChild(objCardRowPart, tostring(j))
			local mazeGridUI = MazeGridUI.new()
			mazeGridUI:Init(objCard)
			self.MazeGridUiDict[i] = self.MazeGridUiDict[i] or {}
			self.MazeGridUiDict[i][j] = mazeGridUI
			-- 用于退出迷宫处理数据
			table.insert(self.GridList,mazeGridUI) 
			self.cardNodePosDict[i] = self.cardNodePosDict[i] or {}
			self.cardNodePosDict[i][j] = objCard.transform.localPosition
		end
	end

	-- 初始化卡片节点信息
	self:GetCardDistanceX()
	self:GetCardAlpha()
	self:GetCardFrontBlackAlpha()
	self:GetRowPosY()
	self:GetRowMoveDistance()
	self:GetCardScale()
end

local UPDATE_TYPE = 
{
	UPDATE_ITEM_DATA = 1,
	UPDATE_EMBATTLE = 2,
	UPDATE_DISPLAY_ROLECOMMON = 3,
	UPDATE_MAZE_GRID_DATA = 4,
	QUITE_MAZE = 5,	
	UPDATE_MAZE_GRID_ADV_LOOT = 6,
	UPDATE_MAZE_MINI_MAP = 7,
}
function MazeUI:InitEventListener()
	 -- 监听物品更新事件刷新熔炼界面
	 self:AddEventListener("UPDATE_ITEM_DATA", function()
		self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_ITEM_DATA)
	end)
	
	self:AddEventListener("UPDATE_EMBATTLE", function()
		self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_EMBATTLE)
	end)
	--fixed: 【迷宫】使用迷宫补给后血量没有立即刷新
	self:AddEventListener("UPDATE_DISPLAY_ROLECOMMON", function()
		self.iUpdateFlag = SetFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_DISPLAY_ROLECOMMON)
	end)

	self:AddEventListener("UPDATE_MAZE_GRID_DATA", function(uiGridID)
		if self:IsGridInCurMaze(uiGridID) then 
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.UPDATE_MAZE_GRID_UI, false,uiGridID)
			self.iUpdateFlag = SetFlag(self.iUpdateFlag, UPDATE_TYPE.UPDATE_MAZE_MINI_MAP)
		end
	end)

	self:AddEventListener("UPDATE_CURRENT_MAZE_ADVLOOT", function(advLootInfo)
		if not (advLootInfo and advLootInfo.mazeGridID) then 
			return
		end
		local mazeGridID = advLootInfo.mazeGridID
		self.updateGridDict = self.updateGridDict or {}
		self.updateGridDict[mazeGridID] = true
		self.iUpdateFlag = SetFlag(self.iUpdateFlag, UPDATE_TYPE.UPDATE_MAZE_GRID_ADV_LOOT)
	end)

	self:AddEventListener("QUITE_MAZE", function()
		self.iUpdateFlag = SetFlag(self.iUpdateFlag, UPDATE_TYPE.QUITE_MAZE)
	end)
end

local hasFlag = HasFlag
local l_GetKeyDown = CS.UnityEngine.Input.GetKeyDown
local l_QuoteKey="`"
local funcType={
	FuncType.MazeLeft,
	FuncType.MazeMid,
	FuncType.MazeRight,
	FuncType.MazePick,
	FuncType.MazeLeave,
}
function MazeUI:Update()
	if IsNotInGuide() then 
		for i=1,3 do
			if GetKeyDownByFuncType(funcType[i]) and self.pressNumCallback[i]~=nil then 
				self.pressNumCallback[i]()
			end
		end
		if GetKeyDownByFuncType(funcType[4]) then
			self.comGetAllLootBtn.onClick:Invoke()
		end

	end
	if self.iUpdateFlag ~= 0 then
		if CanUpdateMazeUI() then 
			if hasFlag(self.iUpdateFlag, UPDATE_TYPE.UPDATE_ITEM_DATA) then
				self:UpdateMazeItemList()
			end
			
			if hasFlag(self.iUpdateFlag, UPDATE_TYPE.UPDATE_EMBATTLE) or 
				hasFlag(self.iUpdateFlag,UPDATE_TYPE.UPDATE_DISPLAY_ROLECOMMON) then
				self:UpdateTeammates()
			end
			
			if hasFlag(self.iUpdateFlag, UPDATE_TYPE.QUITE_MAZE) then
				self:ResetAdvloot()
				self.PosMap = {}
			end

			if hasFlag(self.iUpdateFlag, UPDATE_TYPE.UPDATE_MAZE_GRID_ADV_LOOT) then
				for gridID, _ in pairs(self.updateGridDict) do 
					self:UpdateMazeGridAdvLoot(gridID)
				end
				self.updateGridDict = {}
			end

			if hasFlag(self.iUpdateFlag, UPDATE_TYPE.UPDATE_MAZE_MINI_MAP) then
				self:UpdateMiniMap()
			end
			
			self.iUpdateFlag = 0
		end
	end

	self.MazeGridUiDict = self.MazeGridUiDict or {}
	for index, _ in pairs(self.MazeGridUiDict) do
		if self.MazeGridUiDict[index] then
			for _, mazeGridUI in pairs(self.MazeGridUiDict[index] ) do
				mazeGridUI:Update()
			end
		end
	end

	self.advlootRayCheck:Update()

	if not IsBattleOpen() then
		PlayMusicHelper(true)
	end
end

--新迷宫界面_获取每层卡片间距
function MazeUI:GetCardDistanceX()
	if mazeUiInfo ~= nil and mazeUiInfo.cardHorizontalSpaceDict ~= nil then 
		return mazeUiInfo.cardHorizontalSpaceDict
	end

	rowCount = self.objCardPart.transform.childCount
	mazeUiInfo.cardHorizontalSpaceDict = {}
	for i = 1, rowCount do
		local objCard0 =  self.MazeGridUiDict[i][0].objGrid
		local objCard1 = self.MazeGridUiDict[i][1].objGrid
		local horSpace = objCard1.transform.localPosition.x - objCard0.transform.localPosition.x
		horSpace = math.abs(horSpace)
		mazeUiInfo.cardHorizontalSpaceDict[i] = horSpace
	end
	-- FIXME: 第 0 行的卡片间距提到配置文件中
	mazeUiInfo.cardHorizontalSpaceDict[0] = mazeUiInfo.cardHorizontalSpaceDict[1]
	return mazeUiInfo.cardHorizontalSpaceDict
end

--新迷宫界面_获取每层卡片最大透明度
function MazeUI:GetCardAlpha(row)
	if mazeUiInfo.cardAlphaDict == nil then 
		local rowCount = self.objCardPart.transform.childCount
		mazeUiInfo.cardAlphaDict = {}
		for i = 1, rowCount do 
			local objCard = self.MazeGridUiDict[i][0].objGrid
			local alpha = objCard:GetComponent("CanvasGroup").alpha
			mazeUiInfo.cardAlphaDict[i] = alpha or 0
		end
		-- FIXME: 第 0 行的卡片透明度提到配置文件中
		mazeUiInfo.cardAlphaDict[0] = 0
	end

    if row == nil then 
		return mazeUiInfo.cardAlphaDict
	else
		return mazeUiInfo.cardAlphaDict[row]
	end
end

-- 获取每一层的前景黑色透明度
function MazeUI:GetCardFrontBlackAlpha()
	if mazeUiInfo ~= nil and mazeUiInfo.cardFrontBlackAlphaDict ~= nil then 
		return mazeUiInfo.cardFrontBlackAlphaDict
	end

	local rowCount = self.objCardPart.transform.childCount
	mazeUiInfo.cardFrontBlackAlphaDict = {}
	for i = 1, rowCount do
		local alpha = self.MazeGridUiDict[i][0]:GetFrontMaskAlpha()
		mazeUiInfo.cardFrontBlackAlphaDict[i] = alpha or 0
	end
	-- FIXME: 第 0 行的前景黑色透明度提到配置文件中
	mazeUiInfo.cardFrontBlackAlphaDict[0] = 0
    return mazeUiInfo.cardFrontBlackAlphaDict
end

-- 获取卡片行 Y 轴本地坐标
function MazeUI:GetRowPosY(rowIndex)
	if mazeUiInfo ~= nil and mazeUiInfo.rowPosYDict ~= nil then 
		return mazeUiInfo.rowPosYDict[rowIndex] or 0
	end

	mazeUiInfo.rowPosYDict = {}
	for i = 1, rowCount  do
		local objRowRoot = self.rowNodeDict[i].obj
		mazeUiInfo.rowPosYDict[i] = objRowRoot.transform.localPosition.y
	end
	-- FIXME: 第 0 行的 y 值提到配置文件中
	mazeUiInfo.rowPosYDict[0] = mazeUiInfo.rowPosYDict[1] - 50
	return mazeUiInfo.rowPosYDict[rowIndex] or 0
end

-- 获取前进时卡片行需要移动的距离
function MazeUI:GetRowMoveDistance()
	if mazeUiInfo ~= nil and mazeUiInfo.rowMoveDistance ~= nil then 
		return mazeUiInfo.rowMoveDistance
	end

	mazeUiInfo.rowMoveDistance = {}
	for rowIndex = 1, rowCount do
		local fromY = self:GetRowPosY(rowIndex)
		local destY = self:GetRowPosY(rowIndex - 1)
		mazeUiInfo.rowMoveDistance[rowIndex] = destY - fromY
	end
	return mazeUiInfo.rowMoveDistance
end

--新迷宫界面_获取每层卡片缩放
function MazeUI:GetCardScale(row)
	if mazeUiInfo.cardScaleDict == nil then 
		mazeUiInfo.cardScaleDict = {}
		self.objCardPart = self:FindChild(self._gameObject, "Card")
		for i = 1, rowCount do 
			local cardScale = self.MazeGridUiDict[i][0].objGrid.transform.localScale.x
			mazeUiInfo.cardScaleDict[i] = cardScale
		end
		-- FIXME: 第 0 行的卡片缩放值提到配置文件中
		mazeUiInfo.cardScaleDict[0] = mazeUiInfo.cardScaleDict[1]
	end
	
	if row == nil then 
		return mazeUiInfo.cardScaleDict
	else
		return mazeUiInfo.cardScaleDict[row]
	end
end

function MazeUI:MazeMoveAnim(posFrom, posDest)
	if self.isMoving then
		DisplayActionEnd()
		return
	end
	
	if not (self:CanPlayMoveAnim(posFrom, posDest)) then 
		-- 直接刷新界面
		self:UpdateMaze()
		DisplayActionEnd()
		return
	end

	if self.totalRow == 1 then
		DisplayActionEnd()
		return
	end

	self.isMoving = true

	LuaEventDispatcher:dispatchEvent("CLEAR_CURRENT_MAZE_ADVLOOT")

	if posFrom.column == posDest.column then
		self:ForwardorBackMoveAnimation(posFrom, posDest)
		return 
	else
		self:LeftorRightMoveAnimation(posFrom, posDest)
	end
end

function MazeUI:CanPlayMoveAnim(posFrom, posDest)
	if posFrom == nil or posFrom.row == nil or posFrom.column == nil or posDest == nil or posDest.row == nil or posDest.column == nil then 
		return false
	end
	local nextRow = mazeDataMgr:FormatRow(nil, nil, posFrom.row + 1)
	-- 检查是不是前后相邻
	-- 这里为了移动判断安全, 暂时写成目标位置是否是下一行
	if nextRow ~= posDest.row then 
		return false
	end
	-- 检查是不是左右相邻
	if math.abs(posFrom.column - posDest.column) > 1 then 
		return false
	end
	return true
end

function MazeUI:LeftorRightMoveAnimation(posFrom, posDest)
	local cardHorizontalSpaceDict = self:GetCardDistanceX()
	local cardAlphaDict = self:GetCardAlpha()
	local cardFrontBlackAlphaDict = self:GetCardFrontBlackAlpha()
	if posFrom.column == posDest.column then 
		DisplayActionEnd()
		-- TODO: 增加报错提示, 理论上不会进入这里才对
		return
	end
	local dir = (posDest.column - posFrom.column) / math.abs(posDest.column - posFrom.column)
	local midIndex = math.floor(cardNodeCount / 2)
	for i = 1, #self.MazeGridUiDict do
		-- x 移动距离
		local deltaX = -dir * cardHorizontalSpaceDict[i]
		-- 显示范围
		local showColumnCount = showColumnCountMap[i]
		local showCardRange = math.floor(showColumnCount / 2)
		for j = 0, #self.MazeGridUiDict[i] do 
			local mazeGridUI = self.MazeGridUiDict[i][j]
			local objGrid = mazeGridUI.objGrid
			local comGridTransform = objGrid.transform
			local comFrontMaskCanvasGroup = mazeGridUI.comFrontMaskCanvasGroup
			comGridTransform:DR_DOLocalMoveX(comGridTransform.localPosition.x + deltaX, MazeHorizontalMoveDeltaTime)
			-- 左右两端两张卡片 canvas group 透明度动画
			local curAlpha = mazeGridUI:GetCanvasGroupAlpha()
			local destAlpha = curAlpha
			if j == midIndex + (dir * (1 + showCardRange)) then 
				-- 需要显示的卡片端
				destAlpha = cardAlphaDict[i]
			elseif j == midIndex + (-dir * (showCardRange)) then 
				-- 需要隐藏的卡片端
				destAlpha = 0
			end
			if destAlpha ~= curAlpha then 
				mazeGridUI.comCanvasGroup:DR_DOCanvasGroupFade(curAlpha, destAlpha, MazeHorizontalMoveDeltaTime)
				-- 角色模型透明度
				if i == 1 and mazeGridUI.objRoleSpine ~= nil then 
					if destAlpha == 0 then 
						mazeGridUI:PlaySpineAlphaAnim(1, 0, MazeHorizontalMoveDeltaTime)
					else
						mazeGridUI:PlaySpineAlphaAnim(0, 1, MazeHorizontalMoveDeltaTime)
					end
				end
				local expectFrontMaskAlpha = cardFrontBlackAlphaDict[i]
				if destAlpha == 0 then 
					expectFrontMaskAlpha = 0
				end
				if expectFrontMaskAlpha ~= comFrontMaskCanvasGroup.alpha then 
					comFrontMaskCanvasGroup:DR_DOCanvasGroupFade(comFrontMaskCanvasGroup.alpha, expectFrontMaskAlpha, MazeHorizontalMoveDeltaTime)
				end
			end
		end
	end
	
	-- 留 0.1 缓冲以防万一
	self:AddTimer((MazeHorizontalMoveDeltaTime + 0.1) * 1000, function()
		local mazeUI = GetUIWindow("MazeUI")
		if mazeUI ~= nil then 
			mazeUI:ForwardorBackMoveAnimation(posFrom, posDest)
		end
	end, 1)
end

function MazeUI:OnClickGetAllLoot()
	-- 掉落没有完全爆出来之前不允许点击
	if g_mazeGridAdvLootUpdateTimer and globalTimer:GetTimer(g_mazeGridAdvLootUpdateTimer) then 
		return
	end

	if self.MazeGridUiDict[1] then
		for k ,mazeGridUI in pairs(self.MazeGridUiDict[1]) do
			if mazeGridUI.canInteract then
				for key,advLoot in pairs(mazeGridUI.AdvlootList) do
					advLoot:PickUp()
				end
			end
		end
		AdvLootManager:GetInstance():ImmediatelySend()
	end
end

function MazeUI:ForwardorBackMoveAnimation(posFrom, posDest)
	if posFrom.row == posDest.row then 
		DisplayActionEnd()
		-- TODO: 增加报错提示, 理论上不会进入这里才对
		derror('[MazeUI]->ForwardorBackMoveAnimation  Dest pos error. Row:' .. tostring(posDest.row))
		return
	end
	local columnOffset = posDest.column - posFrom.column
	local cardScaleDict = self:GetCardScale()
	local rowMoveDistanceDict = self:GetRowMoveDistance()
	local cardHorizontalSpaceDict = self:GetCardDistanceX()
	local cardAlphaDict = self:GetCardAlpha()
	local cardFrontBlackAlphaDict = self:GetCardFrontBlackAlpha()
	local lFloor = math.floor
	local midIndex = lFloor(cardNodeCount / 2) + columnOffset
	for i = 1, #self.rowNodeDict do 
		local objRowNode = self.rowNodeDict[i].obj
		local comRowNodeTransform = objRowNode.transform
		-- 行 Y 移动
		comRowNodeTransform:DR_DOLocalMoveY(comRowNodeTransform.localPosition.y + rowMoveDistanceDict[i], MazeVerticalMoveDeltaTime)
		-- 卡片 x 移动
		for j = 0, #self.MazeGridUiDict[i] do
			local mazeGridUI = self.MazeGridUiDict[i][j]
			local objGrid = mazeGridUI.objGrid
			local comGridTransform = objGrid.transform
			local comGridCanvasGroup = mazeGridUI.comCanvasGroup
			local comFrontMaskCanvasGroup = mazeGridUI.comFrontMaskCanvasGroup
			local cardPosX = cardHorizontalSpaceDict[i - 1] * (j - midIndex)
			local cardScale = cardScaleDict[i - 1]
			-- 间隔变化
			comGridTransform:DR_DOLocalMoveX(cardPosX, MazeVerticalMoveDeltaTime)
			-- 缩放变化
			comGridTransform:DR_DOScaleXY(cardScale,cardScale,MazeVerticalMoveDeltaTime)
			local showColumnCount = showColumnCountMap[i - 1]
			local showCardRange = lFloor(showColumnCount / 2)
			local expectCardAlpha = 0
			-- 校正透明度
			if math.abs(j - midIndex) <= showCardRange then 
				expectCardAlpha = cardAlphaDict[i - 1]
			end
			if i == 1 and comGridCanvasGroup.alpha == 1 then 
				mazeGridUI:PlaySpineAlphaAnim(1, 0, MazeVerticalMoveDeltaTime)
			elseif i == 2 and expectCardAlpha == 1 then 
				mazeGridUI:PlaySpineAlphaAnim(0, 1, MazeVerticalMoveDeltaTime)
			end
			comGridCanvasGroup:DR_DOCanvasGroupFade(comGridCanvasGroup.alpha, expectCardAlpha, MazeVerticalMoveDeltaTime)
			local frontMaskAlpha = comFrontMaskCanvasGroup.alpha
			if frontMaskAlpha == 0 and i ~= #self.rowNodeDict then 
			elseif expectCardAlpha ~= 0 or cardFrontBlackAlphaDict[i - 1] == 0 then
				local canGridShow = mazeGridUI:CanGridShow()
				if canGridShow and cardFrontBlackAlphaDict[i - 1] ~= cardFrontBlackAlphaDict[i] then 
					comFrontMaskCanvasGroup.alpha = cardFrontBlackAlphaDict[i]
					comFrontMaskCanvasGroup:DR_DOCanvasGroupFade(comFrontMaskCanvasGroup.alpha, cardFrontBlackAlphaDict[i - 1], MazeVerticalMoveDeltaTime)
				end
			end
		end
	end

	-- 留 0.1 缓冲以防万一
	self:AddTimer((MazeVerticalMoveDeltaTime + 0.1) * 1000, function()
		local mazeUI = GetUIWindow("MazeUI")
		if mazeUI ~= nil then 
			mazeUI:SetUpdateMazeFlag()
			mazeUI.isMoving = false
			DisplayActionEnd()
		end
	end, 1)
end

function MazeUI:ResetGridNode()
	if self.MazeGridUiDict == nil then return end
	for i = 1, #self.MazeGridUiDict do 
		if self.MazeGridUiDict[i] ~= nil then 
			self.rowNodeDict[i].canvasGroup.alpha = 1
			self.rowNodeDict[i].obj:SetObjLocalPosition(self.rowNodeDict[i].position.x, self.rowNodeDict[i].position.y, self.rowNodeDict[i].position.z)

			local alpha = self:GetCardAlpha(i)
			local scale = self:GetCardScale(i)
			for j = 0, #self.MazeGridUiDict[i] do 
				if self.MazeGridUiDict[i][j] ~= nil and self.MazeGridUiDict[i][j].objGrid ~= nil then 
					self.MazeGridUiDict[i][j].objGrid:SetObjLocalPosition(self.cardNodePosDict[i][j].x, self.cardNodePosDict[i][j].y, self.cardNodePosDict[i][j].z)
					self.MazeGridUiDict[i][j].comCanvasGroup.alpha = alpha
					self.MazeGridUiDict[i][j].objGrid:SetObjLocalScale(scale, scale, scale)
				end
			end
		end
	end
end

function MazeUI:RefreshBuffListScrollChanged()
	if self.mazeData then
		if self.BuffList_hor__ScrollRect.totalCount ~= getTableSize(self.mazeData.auiBuffIDs) then 
			self.BuffList_hor__ScrollRect.totalCount = getTableSize(self.mazeData.auiBuffIDs)
			self.BuffList_hor__ScrollRect:RefillCells()
		else
			self.BuffList_hor__ScrollRect:RefreshCells()
		end
	end
end

function MazeUI:OnBuffListScrollChanged(item, idx)
	local buffInfo = self.mazeData.auiBuffIDs[idx]
	local buffID = buffInfo.iBuffTypeID
	local iLayer = buffInfo.iLayer
	local buff = TableDataManager:GetInstance():GetTableData("Buff", buffID)
	if buff ~= nil then
		local Image_icon = self:FindChildComponent(item.gameObject,"Icon","Image")
		local Text = self:FindChildComponent(item.gameObject,"Text","Text")
		local Btn_bottom = item.gameObject:GetComponent("Button")
		Btn_bottom.onClick:RemoveAllListeners()
		local fun = function(index)
			local buffdata = TableDataManager:GetInstance():GetTableData("Buff", buffID)
			local tips = {
				['title'] = string.format("%s (%d层)", GetLanguageByID(buff.NameID) ,iLayer),
				['content'] = TipsDataManager:GetInstance():GetBuffDescReplace(GetLanguageByID(buff.DescID),iLayer,buffID)
			}
			OpenWindowImmediately("TipsPopUI",tips)
		end
		Btn_bottom.onClick:AddListener(fun)
		
		if buff.Icon ~= nil and buff.ICon ~= "" then
			Image_icon.sprite = GetSprite(buff.Icon)
			Text.text = iLayer
		end
	end
end

function MazeUI:OnEnable()
	RemoveWindowImmediately("CityUI", true)
	RemoveWindowImmediately("BigMapUI")
    RemoveWindowImmediately("TileBigMap")
	RemoveWindowImmediately("FinalBattleUI")
	OpenWindowImmediately("TaskTipsUI")
	self:InitEventListener()
	self:SetUpdateMazeFlag()
	DisplayActionManager:GetInstance():ShowNavigation()
	DisplayActionManager:GetInstance():ShowToptitle(TOPTITLE_TYPE.TT_MAZE, not self.firstRefreshComplete)
	MapEffectManager:GetInstance():UpdateBackgroundEffect(self.objBackgroundEffect)
	-- 一般城市进入迷宫时, 天气效果是不会关闭的, 所以如果有天气效果在播, 迷宫不需要自己刷一遍天气
	-- 如果没有天气在播(一般是读档直接进迷宫的情况), 那么自己刷一遍天气
	local cityMgr = CityDataManager:GetInstance()
	if not cityMgr:IsPlayingWeatherEffect() then
		cityMgr:UpdateCityWeatherEffect()
	end
	self.bSeleOpenWeatherEffect = cityMgr:IsPlayingWeatherEffect()

end

function MazeUI:OnDisable()
	--if self.bSeleOpenWeatherEffect and not IsBattleOpen() then
	if self.bSeleOpenWeatherEffect then
		self.bSeleOpenWeatherEffect = false
		CityDataManager:GetInstance():CloseLastWeatherEffect()
	end
	local comTeamGroundTransform = self.comTeamGroundImg.transform
	local childCount = comTeamGroundTransform.childCount
	for int_i = childCount - 1, 0, -1 do
		comTeamGroundTransform:GetChild(int_i).gameObject:SetActive(false)
	end
	
	self:RemoveMazeUiEventListener()
	DisplayActionManager:GetInstance():HideToptitle()
	DisplayActionManager:GetInstance():HideNavigation()
	if self.enterMazeLoading then 
		RemoveWindowImmediately('LoadingUI')
		self.enterMazeLoading = false
	end
end

function MazeUI:RemoveMazeUiEventListener()
	self:RemoveEventListener("UPDATE_MAZE_GRID_DATA")
	--self:RemoveEventListener("ANIMATION_UPDATE_MAZE_GRID_DATA")
	self:RemoveEventListener("UPDATE_ITEM_DATA")
	self:RemoveEventListener("UPDATE_EMBATTLE")
	self:RemoveEventListener("QUITE_MAZE")
	self:RemoveEventListener("UPDATE_DISPLAY_ROLECOMMON")
	self:RemoveEventListener("UPDATE_CURRENT_MAZE_ADVLOOT")
end

function MazeUI:OnDestroy()
	if self.comDropDown then
		self.comDropDown.onValueChanged:RemoveAllListeners()
		self.comDropDown.onValueChanged:Invoke()
	end
	for _, temp in pairs(self.MazeGridUiDict) do
		for _,mazeGridUI in pairs(temp) do
			mazeGridUI:Close()
		end
	end

	self.rowNodeDict = nil
	self.MazeGridUiDict = nil
	self.cardNodePosDict = nil
	self.mazeMiniMapUI:Close()
    local comTeamGroundTransform = self.comTeamGroundImg.transform
	local childCount = comTeamGroundTransform.childCount
	for int_i = childCount - 1, 0, -1 do
		comTeamGroundTransform:GetChild(int_i).gameObject:SetActive(false)
	end

	MapEffectManager:GetInstance():DestroyBackgroundEffect(self.objBackgroundEffect)
end

function MazeUI:SetUpdateMazeFlag(dispatchEndEvent)
	self.updateFlag = true
	self.updateActionDispatchEndEvent = self.updateActionDispatchEndEvent or dispatchEndEvent
end

function MazeUI:UpdateMaze()
	if self.isMoving then 
		return
	end
	self:UpdateData()
	self:UpdateMazeGrid()
	self:UpdateMiniMap()
	self:UpdateTeammates()
	self:UpdateBuffList()
	self:UpdateMazeItemList()
	self:UpdateMazeBG()
	self:UpdateTeamGround()
end

function MazeUI:UpdateMazeBG()
	if not (type(self.mazeArtData) == 'table' and self.mazeArtData.BGImg ~= nil) then 
		self.comBGImg.gameObject:SetActive(false)
		return 
	end

	local bgSprite = GetSprite(self.mazeArtData.BGImg)
	-- if self.comBGImg.sprite == bgSprite then 
	-- 	return
	-- end
	if bgSprite ~= nil then 
		self.comBGImg.gameObject:SetActive(true)
		self.comBGImg.sprite = bgSprite
	else
		self.comBGImg.gameObject:SetActive(false)
	end
end

function MazeUI:InitTeammate()
	self.teammaterDict = {}
	for i = 0, 5 do
		local objRoleSpine = self:FindChild(self.comTeamGroundImg.gameObject, tostring(i))
		local comCanvas = objRoleSpine:GetComponent("Canvas")
		objRoleSpine.gameObject:SetActive(false)
		local obj = MazeRoleUI.new()
		obj:SetGameObject(objRoleSpine)
		obj:SetDefaultScale(MAZE_SPINE_SCALE)
		obj:SetSortingOrder(Maze_TeammatesOrderinLayer[i])
		self.teammaterDict[i] = {
			obj = obj,
			canvas = comCanvas
		}
	end
end

function MazeUI:UpdateTeammates()
	local count = 0
	local battleRoles = RoleDataManager:GetInstance():GetBattleRoles()
	local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
	for i = 0, 5 do
		local roleData = battleRoles[i + 1]
		if roleData then 
			local objRoleSpine = self.teammaterDict[i].obj
			objRoleSpine:SetRoleData(roleData)
		else
			self.teammaterDict[i].obj:SetActive(false)
		end
	end
end

function MazeUI:UpdateBuffList()
	self:RefreshBuffListScrollChanged()
end


function MazeUI:UpdateMazeItemList()
	local checkItemType = function(itemID)
        local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
        if not itemTypeData then return false end
        local itemType = itemTypeData.ItemType
        return (itemType == ItemTypeDetail.ItemType_Food)
    end
	--获得粮食列表
	local roleItems = ItemDataManager:GetInstance():GetPackageItems(nil,nil,nil,checkItemType)

	table.sort(roleItems, function(a, b)
        local typeDataA = ItemDataManager:GetInstance():GetItemTypeData(a)
        local typeDataB = ItemDataManager:GetInstance():GetItemTypeData(b)
        if typeDataA.Rank == typeDataB.Rank then
            return typeDataA.BaseID < typeDataB.BaseID
        else
            return typeDataA.Rank < typeDataB.Rank
        end
	end)
	self:FillItemHorizontalList(roleItems)
	--self:DropDown(roleItems)
end
local foodID ={
	70105,
	70205,
	70305,
	70405
}

function MazeUI:FillItemHorizontalList(roleItems)
	local numTable={}
	local typeId2id={}
	if next(roleItems) then
		for i = 1,#roleItems do
			local itemData = ItemDataManager:GetInstance():GetItemTypeData(roleItems[i])
			local num = ItemDataManager:GetInstance():GetItemNum(roleItems[i]) or 0
			numTable[itemData.BaseID]=num
			typeId2id[itemData.BaseID]=roleItems[i]
		end
	end
	for i = 1,#foodID do
		local itemTypeData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID (foodID[i])
		if	itemTypeData ~= nil then
			local item=self.objItemHorizontalList:FindChild(""..i)
			local comItemName=item:FindChildComponent("Tips/name","Text")
			local comItemDesc=item:FindChildComponent("Tips/desc","Text")
			local comItemImage=item:FindChildComponent("iconBg/Icon","Image")
			local comItemNum=item:FindChildComponent("iconBg/num","Text")
			comItemName.text=itemTypeData.ItemName or ''
			comItemDesc.text=self:GetItemsUseEffectDes(itemTypeData)
			comItemImage.sprite=GetSprite(itemTypeData.Icon)
			comItemNum.text=numTable[foodID[i]] or 0
			local comUIAction = item:FindChildComponent("iconBg","LuaUIAction")
			local objTips = item:FindChild("Tips")
			comUIAction:SetPointerEnterAction(function()
				objTips:SetActive(true)
			end)
			comUIAction:SetPointerExitAction(function()
				objTips:SetActive(false)
			end)
			
			local fun_userItem = function()
				local itemID = typeId2id[foodID[i]]
				local itemNum = ItemDataManager:GetInstance():GetItemNum(itemID)
				if itemNum == nil or itemNum <= 0 then 
					return
				end
				--加个判断,如果血量满了 弹框toast
				--所有队员生命值已满
				if RoleDataHelper:TeammateFullHealth() then
					return
				end
				
				local roleID = RoleDataManager:GetInstance():GetMainRoleID()
				SendUseItemCMD(roleID, itemID, 1)
				local itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
				local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
				if itemTypeData then
					local s_des = self:GetItemsUseEffectDes(itemTypeData)
					DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, s_des, false)
				end
			end
			local comItemBtn = item:FindChildComponent("iconBg","DRButton")
			self:RemoveButtonClickListener(comItemBtn)
			self:AddButtonClickListener(comItemBtn,fun_userItem)
		end
	end
end

function MazeUI:InitDropDown()
	self.comDropDown = self.ItemList:FindChildComponent('Dropdown','Dropdown')  
	self.comDropDownButton = self.ItemList:FindChildComponent('Button','Button')  
	self.comText_Num = self.ItemList:FindChildComponent('Num','Text')  
	self.comText_name = self.ItemList:FindChildComponent('name','Text')  
	self.comIcon = self.ItemList:FindChildComponent('Icon','Image')  
end

function MazeUI:DropDown(roleItems)
	if self.comDropDown == nil then
		return
	end
	self.ShowItemID = 0

	self.comDropDown:ClearOptions()
	self.comDropDown:AddOptions(self:GetItemsData(roleItems))
	self.comDropDownButton.onClick:RemoveAllListeners()
	local fun_userItem = function()
		local itemID = roleItems[self.comDropDown.value + 1]
		local itemNum = ItemDataManager:GetInstance():GetItemNum(itemID)
		if itemNum == nil or itemNum <= 0 then 
			return
		end
		--加个判断,如果血量满了 弹框toast
		--所有队员生命值已满
		if RoleDataHelper:TeammateFullHealth() then
			return
		end
		
		local roleID = RoleDataManager:GetInstance():GetMainRoleID()
		SendUseItemCMD(roleID, itemID, 1)
		local itemTypeID = ItemDataManager:GetInstance():GetItemTypeID(itemID)
		local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
		if itemTypeData then
			local s_des = self:GetItemsUseEffectDes(itemTypeData)
			DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, s_des, false)
		end
	end
	if self.comDropDown.value >= #roleItems then 
		self.comDropDown.value = #roleItems - 1
	end
	local itemNum = ItemDataManager:GetInstance():GetItemNum(roleItems[self.comDropDown.value + 1])
	local tempData = {}
	local num = itemNum
	if next(roleItems) == nil then
		tempData = self.dropDownType['nil']
		num = 0
	elseif #roleItems == 1 then
		--若玩家背包中只存在一个迷宫补给，那么无法选择下拉框
		tempData = self.dropDownType['onlyOne']
	else
		tempData = self.dropDownType['other']
	end

	self:RemoveButtonClickListener(self.comDropDownButton)
	self:AddButtonClickListener(self.comDropDownButton, fun_userItem)
	self.comDropDown.interactable = tempData['interactable']
	self.comText_name.color = tempData['textColor'] 
	self.comIcon.color = tempData['iConColor'] 
	self.comText_Num.color =tempData['numColor'] 
	self.comText_Num.text = num

	self.comDropDown.onValueChanged:RemoveAllListeners()
	local fun = function(index)
		self.comText_Num.text = ItemDataManager:GetInstance():GetItemNum(roleItems[self.comDropDown.value + 1])
	end
	self.comDropDown.onValueChanged:AddListener(fun)
end



function MazeUI:GetItemsData(roleItems)
	local OptionData = {}
	if next(roleItems) == nil then
		local itemData = TableDataManager:GetInstance():GetTableData("Item",70105)
		local string_des = string.format(
			"<size=24><color=%s>%s</color></size>\n<size=18>%s</size>",UI_COLOR_STR.darkgray, itemData.ItemName or '', itemData.ItemDesc or '')
		table.insert(OptionData,CS.UnityEngine.UI.Dropdown.OptionData(string_des, GetSprite(itemData.Icon)))
	else
		for k,v in ipairs(roleItems) do
			if v ~= self.ShowItemID then
				local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(v)
				if	itemTypeData ~= nil then
					local color = RANK_COLOR_STR[itemTypeData.Rank]
					local string_des = string.format(
					"<size=24><color=%s>%s</color></size>\n<size=18>%s</size>",color, itemTypeData.ItemName or '',self:GetItemsUseEffectDes(itemTypeData))
	
					table.insert(OptionData,CS.UnityEngine.UI.Dropdown.OptionData(string_des, GetSprite(itemTypeData.Icon)))
				end
			end
		end
	end
	return OptionData
end

function MazeUI:GetItemsUseEffectDes(itemTypeData)
	local s_des = ""
	if itemTypeData then
		if itemTypeData.EffectType == EffectType.ETT_UseItem_MazeRestorePercent then
			s_des = string.format("恢复全体%.0f%%生命值",itemTypeData.Value1)
		else
			s_des = string.format("恢复全体%.0f生命值",itemTypeData.Value1)
		end
	end
	return s_des
end

function MazeUI:UpdateTeamGround()
	if not (type(self.mazeArtData) == 'table' and self.mazeArtData.TeamGroundImg ~= nil) then 
		self.comTeamGroundImg.gameObject:SetActive(false)
		return 
	end
	local bgSprite = GetSprite(self.mazeArtData.TeamGroundImg)
	if self.comTeamGroundImg.sprite == bgSprite then 
		return
	end
	if bgSprite then 
		self.comTeamGroundImg.gameObject:SetActive(true)
		self.comTeamGroundImg.sprite = bgSprite
	else
		self.comTeamGroundImg.gameObject:SetActive(false)
	end
end

-- 检查迷宫格刷新是否正确, 当前只检查面前三个迷宫格
function MazeUI:CheckMazeGridCorrect()
	local needForceUpdate = false
	local curRow, curColumn	= mazeDataMgr:GetCurPos()
	local nextRow = mazeDataMgr:FormatRow(self.mazeID, self.areaIndex, curRow + 1)
	local rowGridUIList = self.MazeGridUiDict[1]
	if rowGridUIList then 
		for column = 2, 4 do 
			local mazeGridUI = rowGridUIList[column]
			if mazeGridUI and not mazeGridUI:IsSamePosition(nextRow, curColumn + column - 3) then 
				needForceUpdate = true
				break
			end
		end
	end
	if needForceUpdate then 
		self:UpdateMaze()
	end
end

function MazeUI:IsGridInCurMaze(mazeGridID)
	if type(mazeGridID) ~= 'number' then 
		return false
	end
	for i = 1, #self.MazeGridUiDict do 
		if self.MazeGridUiDict[i] ~= nil then 
			for j = 0, #self.MazeGridUiDict[i] do
				local mazeGridUI = self.MazeGridUiDict[i][j]
				if mazeGridUI:IsSameGridID(mazeGridID) then
					return true
				end
			end
		end
	end
	return false
end

function MazeUI:UpdateMazeGrid(mazeGridID)
	if mazeGridID == nil then
		self:ResetGridNode()
	end
	
	if self.PosMap == nil then
		self.PosMap = {}
	end
	local curRow, curColumn	= mazeDataMgr:GetCurPos()
	for i = 1, #self.MazeGridUiDict do 
		if self.MazeGridUiDict[i] ~= nil then 
			local relativeRow = i
			local showColumnCount = showColumnCountMap[relativeRow]
			local midIndex = math.floor(cardNodeCount / 2)
			local showCardRange = math.floor(showColumnCount / 2)
			for j = 0, #self.MazeGridUiDict[i] do
				local mazeGridUI = self.MazeGridUiDict[i][j]
				if mazeGridID == nil or (mazeGridID ~= nil and mazeGridUI:IsSameGridID(mazeGridID)) then
					local relativeColumn = j - midIndex
					local row = curRow + relativeRow
					local column = curColumn + relativeColumn

					mazeGridUI:UpdateGridData(row, column)
					local canShow = math.abs(relativeColumn) <= showCardRange and i < #self.MazeGridUiDict
					local canInteract = relativeRow == 1 and canShow and interactable[j]
					mazeGridUI:UpdateGridUI(canInteract)
					if not canShow then 
						mazeGridUI.comCanvasGroup.alpha = 0
						mazeGridUI.comFrontMaskCanvasGroup.alpha = 0
					end
					self.PosMap[row] = self.PosMap[row] or {}
					self.PosMap[row][column] = mazeGridUI
				end
			end
		end
	end
end

function MazeUI:UpdateMazeGridAdvLoot(mazeGridID)
	for i = 0, #self.MazeGridUiDict do 
		if self.MazeGridUiDict[i] ~= nil then 
			for j = 0, #self.MazeGridUiDict[i] do
				local mazeGridUI = self.MazeGridUiDict[i][j]
				if mazeGridUI:IsSameGridID(mazeGridID) then 
					mazeGridUI.iUpdateAdvlootFlag = true
				end
			end
		end
	end
end

function MazeUI:UpdateMiniMap()
	self.mazeMiniMapUI:UpdateMiniMap(self.objMiniMap) 
end

function MazeUI:PlayRoleAnim(row, column, animName, isLoop, needRecover)
	local objGrid = self:GetGrid(row, column)
	if objGrid == nil then 
		return 0
	end

	local mazeGridUI = self.PosMap[row][column]
	if mazeGridUI == nil then 
		DisplayActionEnd()
		return 0
	end
	return mazeGridUI:PlayRoleAnim(objGrid, animName, isLoop, needRecover)
end

function MazeUI:PlayRoleEscapeAnim(row, column, dispatchEndEvent)
	local objGrid = self:GetGrid(row, column)
	if objGrid == nil then 
		if dispatchEndEvent then 
			DisplayActionEnd()
		end
		return nil
	end

	local mazeGridUI = self.PosMap[row][column]
	if mazeGridUI == nil then 
		DisplayActionEnd()
		return nil
	end
	return mazeGridUI:PlayRoleEscapeAnim(objGrid, dispatchEndEvent)
end

function MazeUI:GetGrid(row, column)
	if type(self.MazeGridUiDict) ~= 'table' then 
		return nil
	end
	if self.PosMap == nil or self.PosMap[row] == nil then 
		return nil
	end
	local mazeGridUI = self.PosMap[row][column]	
	if mazeGridUI == nil then 
		return nil
	end	
	if mazeGridUI:IsSamePosition(row, column) then
		return mazeGridUI.objGrid
	end
	return nil
end

function MazeUI:PlayUnlockGridAnim(row, column)
	local gridNode = self:GetGrid(row, column)
	if gridNode == nil then 
		DisplayActionEnd()
		return
	end
	local mazeGridUI = self.PosMap[row][column]
	if mazeGridUI == nil then 
		DisplayActionEnd()
		return
	end
	mazeGridUI:PlayUnlockGridAnim(gridNode)
end

function MazeUI:RefreshUI()
	for i = 1,3 do
        self.pressNumCallback[i]=nil
    end
	if not self.firstRefreshComplete then 
		self:UpdateMaze()
		self.firstRefreshComplete = true
	else
		self.enterMazeLoading = true
		self:SetUpdateMazeFlag()
		mazeDataMgr:DequeueBubble()
	end
end

function MazeUI:UpdateData()
	self.mazeID =  mazeDataMgr:GetCurMazeID()
	self.mazeData = mazeDataMgr:GetMazeDataByID(self.mazeID)
	self.areaIndex = mazeDataMgr:GetCurAreaIndex()
	self.totalRow =  mazeDataMgr:GetAreaTotalRow(self.mazeID, self.areaIndex)
	self.mazeArtData = mazeDataMgr:GetMazeArtDataByID(self.mazeID)
end

function MazeUI:ResetAdvloot()
	for key, value in pairs(self.GridList) do
		local mazeGridUI = value
		if mazeGridUI then
			mazeGridUI:ResetAdvloot()
		end
	end
end

function MazeUI:UpdateAdvGiftBubble(advGiftBubbleInfo)
	if advGiftBubbleInfo == nil then 
		return
	end
	local bubbleStr = ''
	local chatStr = ''

	for giftType, bubbleInfo in pairs(advGiftBubbleInfo) do 
		local itemBaseIdDict = bubbleInfo.itemBaseIdDict
		local itemBaseID = 0
		for baseID, _ in pairs(itemBaseIdDict) do 
			-- TODO: 临时处理, 只显示一个 ID
			itemBaseID = baseID
			break
		end
		local coinCount = bubbleInfo.coinCount or 0
		local giftTypeLangID = AdventureType_Lang[giftType] or 0
		local giftTypeStr = GetLanguageByID(giftTypeLangID)
		if giftType == AdventureType.AT_JinQianSouGua and coinCount > 0 then
			bubbleStr = bubbleStr .. string.format(MAZE_ADV_GIFT_TRIGGER_FORMAT_STR_COIN, giftTypeStr, coinCount)
			chatStr = chatStr .. string.format(MAZE_ADV_GIFT_TRIGGER_FORMAT_STR_COIN, giftTypeStr, coinCount)
		elseif itemBaseID ~= 0 then
			local typeItemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemBaseID)
			local itemNameChatStr = typeItemData.ItemName or ''
			local itemNameStr = ItemDataManager:GetInstance():GetItemName(nil, itemBaseID)

			bubbleStr = bubbleStr .. string.format(MAZE_ADV_GIFT_TRIGGER_FORMAT_STR_ITEM, giftTypeStr, itemNameStr)
			chatStr = chatStr .. string.format(MAZE_ADV_GIFT_TRIGGER_FORMAT_STR_ITEM, giftTypeStr, itemNameChatStr)
		end
	end

	if bubbleStr and bubbleStr ~= '' then
		local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
		--chatBox 显示黑色
		SystemUICall:GetInstance():AddChat({channel = BroadcastChannelType.BCT_System, content = chatStr})

		self:ShowBubble(mainRoleID, bubbleStr, MAZE_ADV_GIFT_TRIGGER_BUBBLE_DELTA_TIME)
	end
end

function MazeUI:ShowBubble(roleID, bubbleStr, deltaTime)
	-- TODO: 找到对应的角色, 如果 ID 为 0, 则随机找一个
	local mazeRoleUI = nil
	if self.mainRoleTeammateSpine ~= nil then 
		mazeRoleUI = self.mainRoleTeammateSpine
	elseif self.teammaterDict[0] ~= nil then
		mazeRoleUI = self.teammaterDict[0].obj
	end
	if mazeRoleUI == nil then 
		return
	end
	mazeRoleUI:ShowBubble(bubbleStr, deltaTime)
end

function MazeUI:IsMoving()
	return self.isMoving
end

function MazeUI:GetRoleSpineFromPool(parent)
	if parent == nil then 
		return nil
	end
	local objRoleSpine = nil
	local objChild = nil
	local comRectTransform = nil
	-- for _, objInfo in ipairs(self.roleSpineTransformPool) do 
	-- 	if not objInfo.GameObject.activeSelf then 
	-- 		objChild = objInfo.GameObject
	-- 		objRoleSpine = objInfo.SpineObj
	-- 		comRectTransform = objInfo.RectTransform
	-- 		break
	-- 	end
	-- end
	if objRoleSpine == nil then 
		objChild = CloneObj(self.roleSpineTransformPool[1].GameObject, parent)
		if (not objChild) then
			return nil
		end
		comRectTransform = objChild:GetComponent('RectTransform')
		objRoleSpine = objChild:FindChild("Spine")
		table.insert(self.roleSpineTransformPool, {
			RectTransform = comRectTransform,
			GameObject = objChild,
			SpineObj = objRoleSpine,
			SpineObjTransform = objRoleSpine:GetComponent("RectTransform"),
		})
		objChild.name = 'Spine'
	end
	if (objRoleSpine ~= nil) then
		local weaponNode = self:FindChild(objRoleSpine, 'weapon_Node')
		if weaponNode then
			weaponNode.gameObject:SetActive(false)
		end
		
		objChild:SetActive(true)
		if comRectTransform then
			comRectTransform:SetParent(parent)
			-- comRectTransform:SetTransLocalScale(MAZE_SPINE_SCALE, MAZE_SPINE_SCALE, MAZE_SPINE_SCALE)
			comRectTransform:SetTransAnchoredPosition(0, 0)
		end
	end

	return objChild,objRoleSpine
end

return MazeUI
