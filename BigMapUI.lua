BigMapUI = class("BigMapUI",BaseWindow)
local BigMapCityUI = require 'UI/BigMapUI/BigMapCityUI'
local BIGMAP_EVENT_OFFSET_X = -10
local BIGMAP_EVENT_OFFSET_Y = 0

function BigMapUI:ctor()

end

function BigMapUI:Create()
	local obj = LoadPrefabAndInit("Game/BigMapUI",Scence_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function BigMapUI:Init()
	self.BigMapCityUI = BigMapCityUI.new()
	
	self.cityBox = self:FindChild(self._gameObject, "city_box")
	self.cloudLoop = self:FindChild(self._gameObject, "cloud_loop")
	self.cloud_tween = self.cloudLoop.transform:DOLocalMoveX(92.5, 5):From()
	self.cloud_tween.onComplete = function()
		self.cloudLoop.transform:DOLocalMoveX(1300, 11):From():SetLoops(-1)
	end

	self.objRoleHead = self:FindChild(self._gameObject, "extra_box/Head")
	self.roleHeadPool = {}

	self.eventbox = self:FindChild(self._gameObject, "event_box")

	self.iconQuest = self:FindChild(self._gameObject, "Icon_quest")
	self.iconQuest:SetActive(false)
	self.iconBusiness = self:FindChild(self._gameObject, "Icon_business")
	self.iconBusiness:SetActive(false)
	self.iconBoomerang = self:FindChild(self._gameObject, "Icon_boomerang")
	self.iconBoomerang:SetActive(false)
	self.iconLimitShop = self:FindChild(self._gameObject, "Icon_LimitShop")
	self.iconLimitShop:SetActive(false)

	self.objTimeCost = self:FindChild(self._gameObject, "extra_box/time_cost")
	self.comTimeCostText = self:FindChildComponent(self.objTimeCost, "Text", DRCSRef_Type.Text)

	self.extrabox = self:FindChild(self._gameObject, "extra_box")
	self.animbox = self:FindChild(self._gameObject, "anim_box")
	self.route_highlight = self:FindChild(self._gameObject, "route_highlight")
	self.route_normal = self:FindChild(self._gameObject, "route_normal")
	self.dotween_paths = self:FindChild(self._gameObject, "dotween_paths")

	self.ObjWeather = self:FindChild(self._gameObject,"Weather")
	self.cityBox:SetActive(true)
	self.eventbox:SetActive(true)
	self.extrabox:SetActive(true)
	self.animbox:SetActive(true)
	self.scriptID = GetCurScriptID()
	self.objAnimation = self._gameObject:GetComponent(DRCSRef_Type.Animation)

	self.comRectTransform = self._gameObject:GetComponent(DRCSRef_Type.RectTransform)

	self.artPath = {}				-- 城市之间的路线
	self.hidePaths = {}		
	self.objWeatherMap = {}
end

function BigMapUI:Update()	
    if  CS.UnityEngine.Input.GetKeyDown('f5') then
        RemoveWindowImmediately("BigMapUI")
		OpenWindowImmediately("TileBigMap")
	end
end

function BigMapUI:RefreshUI(bDontPlayAnimation)
	if bDontPlayAnimation ~= true then
		self.playing = true
		self.objAnimation:DR_Play("map_scale")
		OpenWindowImmediately("BigMapCloudAnimUI", true)
		self:AddTimer(700, function()
			local bigMapUI = GetUIWindow('BigMapUI')
			if bigMapUI then 
				bigMapUI.playing = false
			end
		end)
		self:AddTimer(500,function()
			GuideDataManager:GetInstance():TriggerGuideEvent(GuideEvent.GE_AnimEnd,'BigMapUI')
		end)
	else
		self.playing = false
	end
	self:ClearAnimBoxChildren()
	self:SetUIGlow(self.cityObjToGo, false)
	self:SetUIGlow(self.objCityNow, false)
	self.cityTypeDataToGo = nil		-- 每次打开界面的时候重置
	self.cityObjToGo = nil
	self.cityObjMap = {}			-- 城市 UI

	self.cityEvent = {}				-- 城市之间的事件
	self.artCityEvent = {}			-- 城市旅行时高亮的事件

	-- 获取当前城市数据
	local curCityData = CityDataManager:GetInstance():GetCurCityData()
	if curCityData == nil then 
		derror('当前城市数据丢了, 疑似读档问题或之前有其他报错')
		return
	end
	self:UpdateCity()
	self:ResetPaths()				-- 清空城市之间的路线
	PlayButtonSound("EventBigMap")

	--是否点击城市
	self.isClickCity =  false
end

-- 每次还原的时候刷新附属界面
function BigMapUI:OnEnable()
	RemoveWindowImmediately("CityUI", true)
	RemoveWindowImmediately("MazeUI")
	self:ResetRectTransform()
	self:OpenTaskTipsUI()
	DisplayActionManager:GetInstance():ShowToptitle(TOPTITLE_TYPE.TT_BIGMAP)
	DisplayActionManager:GetInstance():ShowNavigation()
	self:SetRoleVehicles(self.objRoleHead)
end

function BigMapUI:PointerEnterCity(objCity, cityTypeData)
	if not self.isClickCity then
			--锁定城市，不需要高亮
		local dyCityData = CityDataManager:GetInstance():GetCityData(cityTypeData.BaseID)
		if dyCityData and dyCityData.uiState == 1 then
			return
		end
		local curCityTypeData = CityDataManager:GetInstance():GetCurCityData()
		if curCityTypeData == nil then 
			derror('当前城市数据丢了, 疑似读档问题或之前有其他报错')
			return
		end
		if curCityTypeData.BaseID ~= cityTypeData.BaseID then
			self:SetUIGlow(self.objCityNow, true)
			self:SetUIGlow(objCity, true)
			local costTime = CityDataManager:GetInstance():GetCityMoveCostTime(curCityTypeData.BaseID, cityTypeData.BaseID)
			self.objTimeCost:SetActive(true)
			self.comTimeCostText.text = costTime
			--self:RemoveTimer(self.animCostTime)
			self.iCurCostTime = costTime
			self.objTimeCost.transform.localPosition = DRCSRef.Vec3(cityTypeData.BigmapPosX, cityTypeData.BigmapPosY + 50, 0)
			self:ShowArtPath(curCityTypeData.BaseID, cityTypeData.BaseID)
		end
	end
end

function BigMapUI:PointerExitCity(objCity, cityTypeData)
	if not self.isClickCity then
		self:SetUIGlow(self.objCityNow, false)
		self:SetUIGlow(objCity, false)
		self.objTimeCost:SetActive(false)
		self:ResetPaths()
	end

end

-- 点击一个城市 @UI节点 @城市静态数据
function BigMapUI:ClickCity(objCity, cityTypeData)
	-- 等待下行时不允许点击
    if g_isWaitingDisplayMsg then 
        return
    end
    -- 当前显示队列没结束不允许点击
    if DisplayActionManager._instance:GetActionListSize() > 0 then 
        return
    end
	if not (objCity and cityTypeData) then 
		return 
	end
	if self.playing then 
		return 
	end

	local curCityTypeData = CityDataManager:GetInstance():GetCurCityData()
	if curCityTypeData == nil then 
		derror('当前城市数据丢了, 疑似读档问题或之前有其他报错')
		return
	end

	--锁定城市，不需要高亮
    local dyCityData = CityDataManager:GetInstance():GetCityData(cityTypeData.BaseID)
    if dyCityData and dyCityData.uiState == 1 then
		SendClickMap(CMT_CITY, cityTypeData.BaseID)
		return
    end

	-- -- 返回当前城市，不需要高亮
	-- if curCityTypeData.BaseID == cityTypeData.BaseID then
	-- 	SendClickMap(CMT_CITY, cityTypeData.BaseID)
	-- 	return
	-- end
	self.isClickCity = true
	SendClickMap(CMT_CITY, cityTypeData.BaseID)
	--local bNeedDoubleClick = GetConfig("confg_MapMove")
	-- if bNeedDoubleClick == 2 and self.cityTypeDataToGo and self.cityTypeDataToGo.BaseID == cityTypeData.BaseID then
	-- -- 	-- 确定进入高亮城市
	-- 	SendClickMap(CMT_CITY, cityTypeData.BaseID)
	-- else
	-- 	self:SetUIGlow(self.cityObjToGo, false)
	-- 	self:SetUIGlow(self.objCityNow, true)
	-- 	self:SetUIGlow(objCity, true)
	-- 	self.cityObjToGo = objCity
	-- 	self.cityTypeDataToGo = cityTypeData
	-- 	local costTime = CityDataManager:GetInstance():GetCityMoveCostTime(curCityTypeData.BaseID, cityTypeData.BaseID)
	-- 	self.objTimeCost:SetActive(true)
	-- 	self.comTimeCostText.text = costTime
	-- 	self.iCurCostTime = costTime
	-- 	self.objTimeCost.transform.localPosition = DRCSRef.Vec3(cityTypeData.BigmapPosX, cityTypeData.BigmapPosY + 50, 0)
	-- 	self:ShowArtPath(curCityTypeData.BaseID, cityTypeData.BaseID)

	-- 	if bNeedDoubleClick ~= 2 then
	-- 		-- 现在做成点击就走, 不需要先高亮再点击走
	-- 		SendClickMap(CMT_CITY, cityTypeData.BaseID)
	-- 	end
	-- end
end

function BigMapUI:SetUIGlow(obj, value)
	if not obj then return end
	local comImage = self:FindChildComponent(obj, "city_icon", DRCSRef_Type.Image)
	local comBack = self:FindChildComponent(obj, "city_name_back", DRCSRef_Type.Image)
	setUIGlow(comImage, value)
	setUIGlow(comBack, value)
end

-- 寻找并高亮 所有需要高亮的路径
function BigMapUI:ShowArtPath(srcCityBaseID, dstCityBaseID)
	-- 恢复之前高亮的事件
	for k,v in pairs(self.artCityEvent) do
		self.artCityEvent[k]:GetComponent(DRCSRef_Type.Image).color = DRCSRef.Color.white
	end
	self.artCityEvent = {}

	local pathNodeNameList = {}
	local path = CityDataManager:GetInstance():GetCityPath(srcCityBaseID, dstCityBaseID)
	for i = 1, #path do
		local pathNodeName = CityDataManager:GetInstance():GetCityPathNodeName(srcCityBaseID, path[i])
		if pathNodeName then
			table.insert(pathNodeNameList, pathNodeName)
		end

		-- 高亮事件
		for k,v in pairs(self.cityEvent) do
			if (srcCityBaseID == v.city1 and path[i] == v.city2) or (path[i] == v.city1 and srcCityBaseID == v.city2) then
				local obj = v.obj
				obj:GetComponent(DRCSRef_Type.Image).color = DRCSRef.Color(0,1,1,1)
				table.insert( self.artCityEvent, obj )
				break
			end
		end

		srcCityBaseID = path[i]
	end
	self:HighlightPaths(pathNodeNameList)
end

-- 传入Table，高亮路径
function BigMapUI:HighlightPaths(pathNodeNameList)
	self:ResetPaths()
	for _, pathNodeName in ipairs(pathNodeNameList) do
		local objPathNode = self:FindChild(self.route_highlight, pathNodeName)
		if objPathNode then
			objPathNode:SetActive(true)
			table.insert(self.artPath, objPathNode)
		end
	end
end

function BigMapUI:HideNormalPaths(pathNodeNameList)
	for _, pathNodeName in ipairs(pathNodeNameList) do
		local objPathNode = self:FindChild(self.route_normal, pathNodeName)
		if objPathNode then
			objPathNode:SetActive(false)
			table.insert(self.hidePaths, objPathNode)
		end
	end
end

function BigMapUI:ResetPaths()
	for k,v in pairs(self.artPath) do
		self.artPath[k]:SetActive(false)
	end
	self.artPath = {}
end

function BigMapUI:ResetNormalPaths()
	for k,v in pairs(self.hidePaths) do
		self.hidePaths[k]:SetActive(true)
	end
	self.hidePaths = {}
end

function BigMapUI:SetRoleVehicles(objRoleHead, iPathID, bIsReverse)
	local objRoleVehicles = self:FindChild(objRoleHead, "Vehicles")
	if not iPathID then
		objRoleVehicles:SetActive(false)
		return
	end
	if not self.vehiclesKV then
		self.vehiclesKV = {}
		local objChild = nil
		local transVehicles = objRoleVehicles.transform
		for i = 0, transVehicles.childCount - 1 do
			objChild = transVehicles:GetChild(i).gameObject
			self.vehiclesKV[objChild.name] = {
				['obj'] = objChild,
				['oriScale'] = objChild.transform.localScale,
			}
		end
	end
	if self.curShowVehicle then
		self.curShowVehicle:SetActive(false)
	end
	iPathID = tostring(iPathID)
	local data = self.vehiclesKV[iPathID]
	if data then
		data.obj:SetActive(true)
		self.curShowVehicle = data.obj
		-- 这段本来是以为一段路返回的时候只要把图片翻转就可以了, 但是效果不理想, 先注释掉
		-- local v3OriScale = data.oriScale
		-- if bIsReverse == true then
		-- 	self.curShowVehicle.transform.localScale = DRCSRef.Vec3(-v3OriScale.x, v3OriScale.y, v3OriScale.z)
		-- else
		-- 	self.curShowVehicle.transform.localScale = v3OriScale
		-- end
	end
	objRoleVehicles:SetActive(true)
end

-- 判断能否显示城市移动动画
function BigMapUI:CanShowCityTravelAnim(moveRoleID, srcCityBaseID, dstCityBaseID)
	if g_skipAllUselessAnim then
		return false
	end
	if not RoleDataManager:GetInstance():GetRoleData(moveRoleID) then 
		return false
	end
	if srcCityBaseID == dstCityBaseID then 
		return false
	end
	return true
end

-- 获取大地图移动路径, 建立当前城市到目标城市的完整 dotween 路径表
function BigMapUI:GetCityMoveTweenPath(srcCityBaseID, dstCityBaseID)
	local tableDataMgr = TableDataManager:GetInstance()
	local cityDataMgr = CityDataManager:GetInstance()
	local srcCityBaseData = tableDataMgr:GetTableData("City", srcCityBaseID)
	local dstCityBaseData = tableDataMgr:GetTableData("City", dstCityBaseID)
	if not (srcCityBaseData and dstCityBaseData) then 
		derror('[BigMapUI]->GetCityMoveTweenPath  cityBaseData is nil. srcCityBaseID:' .. tostring(srcCityBaseID) .. '  dstCityBaseID:' .. tostring(dstCityBaseID))
		return {}
	end
	local tweenPath = {}
	local reversePathMap = {}
	local path = cityDataMgr:GetCityPath(srcCityBaseID, dstCityBaseID)
	table.insert(path, 1, srcCityBaseID)
	-- 插入起点城市的点
	table.insert(tweenPath, DRCSRef.Vec3(srcCityBaseData.BigmapPosX, srcCityBaseData.BigmapPosY, 0))
	for i = 2, #path do
		local preCity = cityDataMgr:GetCityData(path[i-1])
		local curCity = cityDataMgr:GetCityData(path[i])
		local iBigMapPosZ = 0
		local nodeName, isReverse = cityDataMgr:GetCityPathNodeName(preCity.BaseID, curCity.BaseID)
		reversePathMap[tostring(nodeName)] = isReverse
		if nodeName then
			local dtPaths = self:GetDOTweenPath(nodeName, isReverse)
			if next(dtPaths) then
				-- 把 dtPaths 加到 tweenPath 的末尾
				table.move(dtPaths, 1, #dtPaths, #tweenPath + 1, tweenPath)
			end
		else
			derror("找不到UI移动路径, 请联系增加路径的策划配置  城市1:" .. tostring(preCity.BaseID) .. '  城市2:' .. tostring(curCity.BaseID))
		end
	end

	-- 插入终点城市的点
	table.insert(tweenPath, DRCSRef.Vec3(dstCityBaseData.BigmapPosX, dstCityBaseData.BigmapPosY, 0))
	return tweenPath, reversePathMap
end

-- 分割大地图移动 tween 路线
function BigMapUI:SplitCityMoveTweenPath(tweenPath, splitPos, perserveFront)
	for i = 1, #tweenPath do
		if tweenPath[i] == splitPos then
			local newPath = {}
			if perserveFront then	-- 截取前面的部分
				table.move(tweenPath, 1, i, 1, newPath)
			else	-- 截取后面的部分
				table.move(tweenPath, i, #tweenPath, 1, newPath)
			end
			tweenPath = newPath
			break
		end
	end
	return tweenPath
end

-- 获取大地图移动事件点
function BigMapUI:GetEventPosition(srcCityBaseID, dstCityBaseID)
	local cityDataMgr = CityDataManager:GetInstance()
	local isReverse = false
	local artPath, isReverse = cityDataMgr:GetCityPathNodeName(srcCityBaseID, dstCityBaseID)
	if artPath then
		-- 大地图事件的点永远获取正向
		local dtPaths = self:GetDOTweenPath(artPath, false)
		local mid = math.ceil(#dtPaths / 2)
		local tempPos = clone(dtPaths[mid])
		tempPos.z = 0
		return tempPos
	end
	return nil
end

-- 大地图移动添加事件点动画
function BigMapUI:AddCityMoveEventPoint(targetPos, isPlay)
	local objEvent = self:GetAvailableQuestIcon()
	objEvent:SetActive(true)
	objEvent:GetComponent(DRCSRef_Type.Image).color = DRCSRef.Color(0,1,1,1)
	objEvent.gameObject:SetObjLocalScale(1, 1, 1)
	objEvent.transform.localPosition = targetPos
	if isPlay then
		self.event_anim = Twn_Fade(nil, objEvent:GetComponent(DRCSRef_Type.Image), 255, 0, 0.5, 0, function()
			objEvent.gameObject:SetObjLocalScale(1, 1, 1)
			objEvent.gameObject:SetActive(false)
			DisplayActionEnd()
		end)
		Twn_Scale(nil, objEvent, DRCSRef.Vec3(1,1,1), DRCSRef.Vec3(5,5,5), 0.4, DRCSRef.Ease.Linear)
	end
end

-- 服务器下行：播放城市旅行动画
function BigMapUI:CityTravelAnim(moveRoleID, srcCityBaseID, dstCityBaseID, moveType, callActionEndWhenAnimEnd)
	g_canClickBtn = false
	if not self:CanShowCityTravelAnim(moveRoleID, srcCityBaseID, dstCityBaseID) then 
		if callActionEndWhenAnimEnd then 
			DisplayActionEnd()
		end
		return 
	end
	local cityDataMgr = CityDataManager:GetInstance()
	local roleDataMgr = RoleDataManager:GetInstance()
	local fromPos = nil
	local destPos = nil
	if moveType == BigmapMoveType.Bigmap_Move_Form then
		destPos = srcCityBaseID
	elseif moveType == BigmapMoveType.Bigmap_Move_To then
		fromPos = srcCityBaseID
	end

	-- 计算 path
	local path = cityDataMgr:GetCityPath(srcCityBaseID, dstCityBaseID)
	table.insert(path, 1, srcCityBaseID)	-- 加入起点
	-- 建立当前城市到目标城市的完整 dotween 路径表
	local tweenPath, reversePathMap = self:GetCityMoveTweenPath(srcCityBaseID, dstCityBaseID)

	-- 生成角色头像
	local objRoleHead = nil
	if moveRoleID == roleDataMgr:GetMainRoleID() then 
		objRoleHead = self.objRoleHead
		self.playing = true
	else
		objRoleHead = self:GetAvaliableRoleHeadObj()
		objRoleHead:SetActive(true)
	end
	self:UpdateHead(nil, moveRoleID, objRoleHead)

	-- 如果没有 from 事件前驱，就从 fromcity 开始
	-- 如果没有 to 事件前驱，就移动到 tocity
	-- 如果有事件前驱，则查询一下事件的终点位置
	if fromPos or destPos then
		local evPos
		for i = 1, #path - 1 do
			if path[i] == fromPos then
				evPos = self:GetEventPosition(path[i], path[i+1])
				tweenPath = self:SplitCityMoveTweenPath(tweenPath, evPos, true)
			elseif path[i] == destPos then
				evPos = self:GetEventPosition(path[i], path[i+1])
				self:AddCityMoveEventPoint(evPos)
				tweenPath = self:SplitCityMoveTweenPath(tweenPath, evPos, false)
			end
		end
	end

	-- 最终获得需要 DOTweenPath 运行的路径，开始播放动画，播放期间不允许点击城市
	if type(tweenPath) == 'table' and #tweenPath > 1 then
		local pos = tweenPath[1]
		objRoleHead:SetObjLocalPosition(pos.x, pos.y, pos.z)
	end
	local fMoveTime = #path * BIGMAP_MOVE_SPEED
	self.tripTween = objRoleHead.transform:DOLocalPath(tweenPath, fMoveTime, DRCSRef.PathType.CatmullRom )
	self.tripTween:SetEase(DRCSRef.Ease.Linear)

	-- 目标城市头顶的时间在移动过程中渐降为0
	if self.iCurCostTime and (self.iCurCostTime > 0) then
		-- 这次位移花费的江湖天数
		local iCostDay = self.iCurCostTime
		if math.floor(iCostDay) < iCostDay then
			iCostDay = math.floor(iCostDay) + 1
		end
		-- 位移一天平均时间的提前量 (为的是提前更新ui, 让玩家能看到 1 -> 0 的过程, 单位ms)
		local iStepTimePre = 50
		-- 位移一天的平均时间 (总位移时间 / 位移天数 - 提前量), x1000转化为ms
		local fStepTime = (fMoveTime / iCostDay) * 1000 - iStepTimePre
		if self.animCostTime then
			self:RemoveTimer(self.animCostTime)
			self.animCostTime = nil
		end
		self.animCostTime = self:AddTimer(fStepTime, function()
			self.iCurCostTime = self.iCurCostTime - 1
			if self.iCurCostTime <= 0 then
				self.iCurCostTime = 0
			end
			self.comTimeCostText.text = self.iCurCostTime
			-- if self.iCurCostTime == 0 then
			-- 	self:RemoveTimer(self.animCostTime)
			-- 	self.animCostTime = nil
			-- end
		end, iCostDay)
	end

	-- 动态设置载具
	local transHead = objRoleHead.transform
	local iFloorZ, iFloorZPre = 0, 0
	local bIsReserve = false
	local oriPos = nil
	self.tripTween:OnUpdate(function()
		if transHead.localPosition.z < 0 then
			iFloorZ = tostring(-math.floor(transHead.localPosition.z))
			oriPos = transHead.localPosition
			transHead.localPosition = DRCSRef.Vec3(oriPos.x, oriPos.y, 0)
			-- dprint("~~", iFloorZ)
			-- 等到稳定了再显示船
			if iFloorZ == iFloorZPre then
				-- 估计之前别人写的时候高反Reserve的值了, 这里手动翻转一下
				bIsReserve = reversePathMap[iFloorZ] ~= true
				self:SetRoleVehicles(objRoleHead, iFloorZ, bIsReserve)
			else
				iFloorZPre = iFloorZ
			end
		else
			self:SetRoleVehicles(objRoleHead)
		end
	end)

	self.tripTween.onComplete = function()
		self.playing = false
		-- 动画播放完毕后，如果有 to 事件前驱，还需要在终点播放一个事件动画
		if fromPos then
			self:AddCityMoveEventPoint(tweenPath[#tweenPath], true)
		elseif callActionEndWhenAnimEnd then
			DisplayActionEnd()
			g_canClickBtn = true;
		end
	end
end

function BigMapUI:GetAvaliableRoleHeadObj()
	for i = 1, #self.roleHeadPool do 
		local objRoleHead = self.roleHeadPool[i]
		if not objRoleHead.activeSelf then 
			return objRoleHead
		end
	end
	local objRoleHead = CloneObj(self.objRoleHead, self.objRoleHead.transform.parent.gameObject)
	table.insert(self.roleHeadPool, objRoleHead)
	return objRoleHead
end

function BigMapUI:GetAvailableQuestIcon()
	local childCount = self.animbox.transform.childCount
	for i = 1, childCount do 
		local objIconQuest = self.animbox.transform:GetChild(i - 1)
		if not objIconQuest.gameObject.activeSelf then 
			return objIconQuest.gameObject
		end
	end
	local objIconQuest = CloneObj(self.iconQuest, self.animbox)
	if (objIconQuest ~= nil) then
		objIconQuest.gameObject:SetActive(true)
	end
	return objIconQuest
end

function BigMapUI:ClearAnimBoxChildren()
	local childCount = self.animbox.transform.childCount
	for i = childCount - 1, 0, -1 do 
		local child = self.animbox.transform:GetChild(i)
		child.gameObject:SetActive(false)
	end
end

function BigMapUI:GetDOTweenPath(pathNodeName, isReverse)
	local dtPath = self:FindChild(self.dotween_paths, pathNodeName)
	local luapoints = {}
	if dtPath then
		local comPath = dtPath:GetComponent(DRCSRef_Type.DOTweenPath)
		if comPath then 
			local points = comPath.wps		-- <List>
			if isReverse then
				for i = 0, points.Count - 1 do
					if points[i] then	-- 因为DOTweenPath 给的 waypoints 是左下角坐标，所以要转换成中间坐标
						table.insert( luapoints, DRCSRef.Vec3(points[i].x - design_ui_w/2, points[i].y - design_ui_h/2, points[i].z) )
					end
				end
			else
				for i = points.Count - 1, 0, -1 do
					if points[i] then
						table.insert( luapoints, DRCSRef.Vec3(points[i].x - design_ui_w/2, points[i].y - design_ui_h/2, points[i].z) )
					end
				end
			end
		end
	end
	return luapoints
end

-- 更新头像位置 大小 图案
function BigMapUI:UpdateHead(cityData, roleID, objRoleHead)
	local roleDataMgr = RoleDataManager:GetInstance()
	objRoleHead.name = tostring(roleID)
	objRoleHead:SetActive(true)
	if cityData then 
		objRoleHead:SetObjLocalPosition(cityData.BigmapPosX, cityData.BigmapPosY, 0)
	end
	objRoleHead:SetObjLocalScale(0.55, 0.55, 1)
	-- 显示不同的边框
	local objMainRoleFrame = self:FindChild(objRoleHead, "Image_mine")
	if roleDataMgr:GetMainRoleID() == roleID then
		objMainRoleFrame:SetActive(true)
		--derror('roleID:' .. roleID .. '  is main role')
	else
		objMainRoleFrame:SetActive(false)
		--derror('roleID:' .. roleID .. '  is not main role')
	end
	local modelData = roleDataMgr:GetRoleArtDataByID(roleID)
	if modelData then
		local comHeadImage = self:FindChildComponent(objRoleHead, "Role_Head/head", DRCSRef_Type.Image)
		comHeadImage.sprite = GetSprite(modelData.Head)
		-- comHeadImage:SetNativeSize()
	end
end

-- 更新城市天气信息
function BigMapUI:UpdateCityWeather(objCity, cityData,cityID)
    local weatherID = CityDataManager:GetInstance():GetCityWeatherID(cityData.BaseID)
	local weatherData = TableDataManager:GetInstance():GetTableData("Weather",weatherID)

	if not IsValidObj(self.objWeatherMap[cityID]) then 
		if weatherData and dnull(weatherData['IconAnim']) then 
			self.objWeatherMap[cityID] = LoadPrefabFromPool("weather",self.ObjWeather)
			local objWeather = self.objWeatherMap[cityID]
			local comWeather = objWeather:GetComponent(DRCSRef_Type.Image)
			objWeather:SetActive(true)
			local v3 = objCity.transform.localPosition
			objWeather.transform.localPosition = DRCSRef.Vec3(v3.x,v3.y+30,v3.z)
			comWeather.sprite = GetSprite("Weather/weatherofword_" .. weatherData['IconAnim'])
		end
	else
		if weatherData and dnull(weatherData['IconAnim']) then 
			local objWeather = self.objWeatherMap[cityID]
			if IsValidObj(objWeather) then
				local comWeather = objWeather:GetComponent(DRCSRef_Type.Image)
				comWeather.sprite = GetSprite("Weather/weatherofword_" .. weatherData['IconAnim'])
				objWeather:SetActive(true)
			end
		else
			self.objWeatherMap[cityID]:SetActive(false)
			-- ReturnObjectToPool(self.objWeatherMap[cityID] )
		end
	end
end

function BigMapUI:HideAllRoleHead()
	self.objRoleHead:SetActive(false)
	for _, objRoleHead in ipairs(self.roleHeadPool) do 
		objRoleHead:SetActive(false)
	end
end

function BigMapUI:UpdateCity()
	self:ResetNormalPaths()
	self:ClearCityObj()
	self:HideAllRoleHead()
	self.objTimeCost:SetActive(false)
	self.cityObjMap = {}
	local TB_City = TableDataManager:GetInstance():GetTable("City")
	local cityDataMgr = CityDataManager:GetInstance()
	for cityID, _ in pairs(TB_City) do 
		if cityDataMgr:IsCityInCurScript(cityID) then 
			cityData = cityDataMgr:GetCityData(cityID)
			local objCity = self:GetAvailableCityObj()
			objCity.name = 'city' .. tostring(cityID)
			self.cityObjMap[cityID] = objCity
			objCity:SetActive(true)
			self.BigMapCityUI:UpdateCity(objCity, cityData)

			-- 初始化头像位置。只需要初始化一次。
			local curCityTypeData = cityDataMgr:GetCurCityData()
			if curCityTypeData and curCityTypeData.BaseID == cityID then 
				self.objCityNow = objCity
				local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
				self:UpdateHead(cityData, mainRoleID, self.objRoleHead)
			end
			self:UpdateCityWeather(objCity, cityData,cityID)
			-- 锁定城市不显示路径
			local dyCityData = cityDataMgr:GetCityData(cityData.BaseID)
			if dyCityData and dyCityData.uiState == 1 then
				local pathNodeNameList = cityDataMgr:GetCityAllPathNodeName(cityData.BaseID)
				self:HideNormalPaths(pathNodeNameList)
			end
		else
			local pathNodeNameList = cityDataMgr:GetCityAllPathNodeName(cityID)
			self:HideNormalPaths(pathNodeNameList)
		end 
	end

	self:ClearEventObj()


	local iLimitShopTimes = 0
	-- 遍历城市表，更新当前城市事件
	local funcAddEvent = function(cityID, toCityid, taskid, eventCount, eventIndex)
		local iTypeEvent = 1
		if -1 == taskid or 5674 == taskid then 
			iTypeEvent = 4
			if iLimitShopTimes > 0 then 
				return 
			end 
			iLimitShopTimes = iLimitShopTimes + 1
		end 

		local objEvent = self:GetAvailableEventObj(iTypeEvent)
		if not objEvent then 
			return 
		end
		objEvent:SetActive(true)

		local isReverse = false
		local artPath, isReverse = cityDataMgr:GetCityPathNodeName(cityID, toCityid)
		if artPath then
			-- 大地图事件永远获取正向的中点
			local dtPaths = self:GetDOTweenPath(artPath, false)
			local mid = math.ceil(#dtPaths / 2)
			if dtPaths[mid] and objEvent then
				local tempPos = clone(dtPaths[mid])
				tempPos.z = 0
				-- 如果有多个大地图事件的话, 位置偏移一些
				tempPos.x = tempPos.x + (BIGMAP_EVENT_OFFSET_X * eventIndex)
				tempPos.y = tempPos.y + (BIGMAP_EVENT_OFFSET_Y * eventIndex)
				objEvent.transform.localPosition = tempPos
			end
		end
		local eventData = {
			['city1'] = cityID,
			['city2'] = toCityid,
			['pos'] = objEvent.transform.localPosition,
			['obj'] = objEvent,
		}
		table.insert(self.cityEvent, eventData)
	end
	for cityID, cityTypeData in pairs(TB_City) do 
		local cityData = cityDataMgr:GetCityData(cityID)
		if (cityData and cityData.iNum) and (cityDataMgr:IsCityInCurScript(cityID)) then
			local cityEventDatas = cityData["akCityEvents"]
			if cityEventDatas then 
				for i = cityData.iNum - 1, 0, -1 do 
					if cityEventDatas[i] then 
						local toCityid = cityEventDatas[i]["uiToCityID"]
						local taskid = cityEventDatas[i]["uiTaskID"]
						if toCityid and taskid then 
							-- 缓存大地图事件数量
							funcAddEvent(cityID, toCityid, taskid, cityData.iNum, i)
						end
					end
				end
			end
		end
	end
end

function BigMapUI:ClearCityObj()
	local childCount = self.cityBox.transform.childCount
	for i = 1, childCount do 
		local objCity = self.cityBox.transform:GetChild(i - 1)
		objCity.gameObject:SetActive(false)
	end
end

function BigMapUI:GetAvailableCityObj()
	local childCount = self.cityBox.transform.childCount
	for i = 1, childCount do 
		local objCity = self.cityBox.transform:GetChild(i - 1)
		if not objCity.gameObject.activeSelf then 
			return objCity.gameObject
		end
	end
	local objCity = LoadPrefabAndInit("Game/BigMapCityUI", self.cityBox, true)
	if (objCity ~= nil) then
		objCity.gameObject:SetActive(true)
	end
	return objCity
end

function BigMapUI:ClearEventObj()
	local childCount = self.eventbox.transform.childCount
	for i = 1, childCount do 
		local objEvent = self.eventbox.transform:GetChild(i - 1)
		DRCSRef.ObjDestroy(objEvent.gameObject)
	end
end

function BigMapUI:GetAvailableEventObj(type)
	local objIcon = nil
	if (type == 1) then
		objIcon = CloneObj(self.iconQuest, self.eventbox)
	elseif (type == 2) then
		objIcon = CloneObj(self.iconBusiness, self.eventbox)
	elseif (type == 3) then
		objIcon = CloneObj(self.iconBoomerang, self.eventbox)
	elseif (type == 4) then
		objIcon = CloneObj(self.iconLimitShop, self.eventbox)
	end
	if objIcon then 
		objIcon.gameObject:SetActive(true)
	end
	return objIcon
end

function BigMapUI:OnDisable()
	DisplayActionManager:GetInstance():HideToptitle()
	DisplayActionManager:GetInstance():HideNavigation()
	RemoveWindowImmediately("TaskTipsUI", true)
end

function BigMapUI:OpenTaskTipsUI()
	OpenWindowImmediately("TaskTipsUI")
end

function BigMapUI:OnDestroy()
	self.BigMapCityUI:Close()
	if self.cloud_tween then
		self.cloud_tween.onComplete = nil
		self.cloud_tween = nil
	end
	if self.event_anim then
		self.event_anim.onComplete = nil
		self.event_anim = nil
	end
end

function BigMapUI:OpenCityAnimation(func_Complete)
	local posHead = self.objRoleHead.transform.localPosition
	local tweenTime = 0.35
	local tween
	local scale = 1.5
	
	if self.openCitySequence then
		self.openCitySequence:Kill(false)
	end
	
	if self.comRectTransform == nil then 
		return
	end

	self.openCitySequence = DRCSRef.DOTween:Sequence()
	self.playing = true
	tween = self.comRectTransform:DOAnchorPos(DRCSRef.Vec2(-posHead.x * scale * 0.4, -posHead.y * scale * 0.4), tweenTime)
	tween:SetEase(DRCSRef.Ease.InQuad)
	self.openCitySequence:Append(tween)
	tween = self.comRectTransform:DOScale(DRCSRef.Vec3(scale,scale,scale), tweenTime)
	tween:SetEase(DRCSRef.Ease.InQuad)
	self.openCitySequence:Join(tween)
	self.openCitySequence:AppendCallback(function()
		local bigMapUI = GetUIWindow('BigMapUI')
		if bigMapUI then 
			bigMapUI:ResetRectTransform()
			bigMapUI.playing = false
		end
		if func_Complete then
			func_Complete()
		end
	end)
	self.openCitySequence:SetAutoKill(true)

	OpenWindowImmediately("BigMapCloudAnimUI", false)
end

function BigMapUI:ResetRectTransform()
	if not self.comRectTransform then 
		return
	end
	self.comRectTransform:SetTransLocalPosition(0, 0, 0)
	self.comRectTransform:SetTransAnchoredPosition(0, 0)
	self.comRectTransform.localScale = DRCSRef.Vec3(1, 1, 1)
end

function BigMapUI:IsMoving(func_Complete)
	return IsWindowOpen('BigMapUI') and self.playing
end

function BigMapUI:SetClickCity(bools)
	self.isClickCity = bools
end

return BigMapUI