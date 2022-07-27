CityBuildingUI = class("CityBuildingUI", BaseWindow)
local CityRoleUI = require 'UI/MapUI/CityRoleUI'

function CityBuildingUI:ctor()
	self.cityRoleUiInstList = {}
end

function CityBuildingUI:Init(objBuilding)
	-- TODO: 初始化节点信息
	self._gameObject = objBuilding
	self.objToptitle = self:FindChild(objBuilding, "toptitle")
	self.comTitleText = self:FindChildComponent(self.objToptitle, "Text","Text")
	self.comTitleIcon = self:FindChildComponent(self.objToptitle, "Icon", "Image")
	self.comDescText = self:FindChildComponent(objBuilding, "Text_reward", "Text")
	local obj = self:FindChild(objBuilding, "Mask/top_back")
	if obj then
		self.objTopBack = obj.gameObject
	end
	self.objBuildingMask = self:FindChild(objBuilding, 'Mask')
	self.comBuildingMaskRectTransform = self.objBuildingMask:GetComponent('RectTransform')
	self.comBuildingBGImg = self:FindChildComponent(self.objBuildingMask, "BG","Image")
	self.comFrameImage = self:FindChildComponent(objBuilding, "Window","Image")
	self.comUIAction = objBuilding:GetComponent('LuaUIAction')
	self.comTransform = objBuilding:GetComponent('RectTransform')
	self.comIconQuestMark = self:FindChildComponent(objBuilding, 'Icon_quest', 'Image')
	self.comBuildingTweenAnimation = objBuilding:GetComponent(typeof(CS.DG.Tweening.DOTweenAnimation))
	self.comWindowRectTransform = self:FindChildComponent(objBuilding, "Window","RectTransform")
	self.comWindowBaseRectTransform = self:FindChildComponent(objBuilding, "Window_base","RectTransform")
	self.objFloorMask = self:FindChild(objBuilding, 'Mask/bottom_back')
	self.comFloorMaskRectTransform = self.objFloorMask:GetComponent('RectTransform')
	self.objEnterMapFrame = self:FindChild(objBuilding, "frames_enter_map")
	self.objRoleParent = self:FindChild(objBuilding, 'Role')
	self.comRoleParentTransform = self.objRoleParent.transform
	self.selectRoleIndex = -1
	self.objAdvLootUIParent = self:FindChild(objBuilding, 'AdvLootUI')
end

function CityBuildingUI:OnDestroy()
	self:ResetAdvloot()
	if self.cityRoleUiInstList and next(self.cityRoleUiInstList) then
		for _, ui in pairs(self.cityRoleUiInstList) do 
			ui:Close()
		end
	end
	if self.cityRoles and (#self.cityRoles > 0) then
		for _, ui in pairs(self.cityRoles) do 
			ui:Close()
		end
	end
end

function CityBuildingUI:FixBuildingData(oldMapData)
	if oldMapData then
		local kClan = ClanDataManager:GetInstance():GetClanDataByBuildTypeID(oldMapData.BaseID)
		if kClan and kClan.uiClanState ~= CLAN_CLOSE then
			oldMapData.BuildingNameID = TB_Clan[kClan.uiClanTypeID].NameID or 0
			oldMapData.SceneType = MapSceneType.BT_CLAN
		end
	end
end

function CityBuildingUI:UpdateBuilding(mapID)
	if not (self._gameObject and mapID) then 
		return false
	end

	if self.mapID == nil or self.mapID ~= mapID then
		self:ResetRoleAnimPlayState(self.mapID)
		self.mapID = mapID
		self:ResetAdvloot()
	end

	self:UpdateBuildingData(mapID)
	if not self.mapData then 
		self._gameObject:SetActive(false)
		return false
	end

	self._gameObject:SetActive(true)
	self:UpdateBuildingScale()
	self:UpdateBuildingText()
	self:UpdateBuildingImg()
	self:UpdateBuildingEventTrigger()
	self:UpdateTaskMark()
	self.comBuildingTweenAnimation:DOComplete()
	self:UpdateRole()
	self:SetUpdateAdvlootFlag()
	return true
end

function CityBuildingUI:UpdateTaskData(mapID)
	if not (self._gameObject and mapID) then 
		return 
	end
	if not self.mapData then 
		return 
	end
	self:UpdateRole()
	self:UpdateTaskMark()
end

function CityBuildingUI:UpdateBuildingData(mapID)
	self.mapData = MapDataManager:GetInstance():GetMapData(mapID)
	if self.mapData == nil then 
		return
	end
	self:FixBuildingData(self.mapData)
	self.mapID = self.mapData.BaseID 
	self.roleMaxCount = MapDataManager:GetInstance():GetShowRoleMaxCount(self.mapData.BaseID)
	-- TODO: 更新建筑数据, 记录主要使用到的数据
end

function CityBuildingUI:IsMap(mapID)
	return self.mapID == mapID
end

-- 按地图，动态修改城镇大小 和 缩放大小
function CityBuildingUI:UpdateBuildingScale()
	local curMapData = MapDataManager:GetInstance():GetCurMapData() 
	if self.mapData == nil or curMapData == nil then 
		return 
	end
	local comTween = self.comBuildingTweenAnimation.tween
	local objTween = self.comBuildingTweenAnimation.gameObject
	cast(comTween, typeof(CS.DG.Tweening.Tweener))
	-- 之前设置，如果有行人，就用宽广布局
	if (curMapData.IsUseBroadLayer == TBoolean.BOOL_YES) or (curMapData.PasserCount ~= nil and curMapData.PasserCount > 0) then
		if comTween ~= nil and IsValidObj(objTween) then 
			comTween:ChangeValues(SCALE_CITY_BUILDING['wide_s'], SCALE_CITY_BUILDING['wide'])
		end
		local scale = SCALE_CITY_BUILDING['wide'].x
		self.comTransform:SetTransLocalScale(scale, scale, scale)
	else
		if comTween ~= nil and IsValidObj(objTween) then 
			comTween:ChangeValues(SCALE_CITY_BUILDING['normal_s'], SCALE_CITY_BUILDING['normal'])
		end
		local scale = SCALE_CITY_BUILDING['normal'].x
		self.comTransform:SetTransLocalScale(scale, scale, scale)
	end

	local buildingWidth = 1
	local buildingSize = 1
	if self.mapData.BuildingSize ~= nil and self.mapData.BuildingSize > 1 then 
		buildingSize = self.mapData.BuildingSize
	end
	buildingWidth = SCALE_CITY_BUILDING['width'] * buildingSize
	local axis = DRCSRef.RectTransform.Axis.Horizontal
	self.comTransform:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, buildingWidth)
	self.comBuildingMaskRectTransform:SetTransLocalScale(buildingSize, 1, 1)
	self.comWindowRectTransform:SetSizeWithCurrentAnchors(axis, buildingWidth + 30)
	self.comWindowBaseRectTransform:SetTransLocalScale(buildingSize, 1, 1)
	self.comFloorMaskRectTransform:SetTransLocalScale(buildingSize, 1, 1)
end

function CityBuildingUI:UpdateBuildingText()
	self:UpdateBuildingName()
	self:UpdateBuildingDesc()
end

function CityBuildingUI:UpdateBuildingName()
	if self.mapData == nil then 
		return 
	end

	local mapName = MapDataManager:GetInstance():GetMapBuildingName(self.mapData.BaseID)
	local buildingType = self.mapData.BuildingType or MapBuildingType.BT_BUILDING

	-- 前缀：Map.建筑类型	-- 门——通道	-- 迷宫——迷宫	-- 建筑——不显示前缀	-- 卡片名称：Map.NameID
	local prefix = ''
	if buildingType == MapBuildingType.BT_DOOR then
		prefix = dtext(973)
	elseif buildingType == MapBuildingType.BT_MAZE then
		prefix = dtext(974)
	end
	self.comTitleText.text = prefix .. mapName
	if DEBUG_MODE then
		self.comTitleText.text = self.comTitleText.text .. '(' .. tostring(self.mapID) .. ')'
	end

	local iconImg = MAP_BUILDING_TYPE_ICON[buildingType] or MAP_BUILDING_TYPE_ICON[MapBuildingType.BT_BUILDING]
	self.comTitleIcon.sprite = GetAtlasSprite('CityUIAtlas', iconImg)
end

function CityBuildingUI:UpdateBuildingDesc()

	if self.mapData == nil then 
		return 
	end
	local des = MapDataManager:GetInstance():GetBuildingDescByData(self.mapData)
	if self.objTopBack then
		self.objTopBack:SetActive(not (des == nil or des == ""))
	end
	self.comDescText.text = des
end

function CityBuildingUI:UpdateBuildingImg()
	self:UpdateBuildingBG()
	self:UpdateBuildingFrame()
end

function CityBuildingUI:UpdateBuildingBG()
	if self.mapData == nil then 
		return 
	end

	local buildingBG = self.mapData.BuildingImg
	local mapAttrChange = MapDataManager:GetInstance():GetMapAttrChange(self.mapData.BaseID)
	if (mapAttrChange ~= nil and mapAttrChange.MapPic ~= nil and mapAttrChange.MapPic ~= "" and mapAttrChange.MapPic ~= "-") then
		buildingBG = mapAttrChange.MapPic
	end
	self.comBuildingBGImg.sprite = GetSprite(buildingBG)
end

function CityBuildingUI:UpdateBuildingFrame()
	if self.mapData == nil then 
		return 
	end

	local buildingType = self.mapData.BuildingType or MapBuildingType.BT_BUILDING
	local frameImg = MAP_BUILDING_TYPE_FRAME[buildingType]
	if frameImg == nil then 
		self.comFrameImage.gameObject:SetActive(false)
		return
	end
	self.comFrameImage.gameObject:SetActive(true)
	self.comFrameImage.sprite = GetAtlasSprite('CityUIAtlas', frameImg)
end

function CityBuildingUI:UpdateBuildingEventTrigger()
	if self.mapData == nil then 
		return 
	end

	if self.comUIAction == nil then
		return
	end
	local DragCallback = function(objBuilding, eventData) self:OnDrag(eventData) end
	local PointerDownCallback = function(objBuilding, eventData) self:OnPointerDown(eventData) end
	local PointerUpCallback = function(objBuilding, eventData) self:OnPointerUp(eventData) end
	local PointerExitCallback = function(objBuilding, eventData) self:OnPointerExit(eventData) end
	local PointerClickCallback = function(objBuilding, eventData) self:OnPointerClick(objBuilding, eventData) end

	self.comUIAction:SetDragAction(DragCallback)
	self.comUIAction:SetPointerDownAction(PointerDownCallback)
	self.comUIAction:SetPointerUpAction(PointerUpCallback)
	self.comUIAction:SetPointerExitAction(PointerExitCallback)
	self.comUIAction:SetPointerClickAction(PointerClickCallback)
end

-- 需要播放切换地图动画时，对当前建筑，播放点击动画。
function CityBuildingUI:PlayEnterAnim(objAnim, mapData)
	if mapData == nil then 
		return 
	end

	if mapData.BuildingType == MapBuildingType.BT_DOOR then
		if (mapData.IsUseBroadLayer == TBoolean.BOOL_YES) or (mapData.PasserCount ~= nil and mapData.PasserCount > 0) then
			objAnim.transform:DR_DOScaleXY(SCALE_CITY_BUILDING['wide_c'].x, SCALE_CITY_BUILDING['wide_c'].x, SCALE_CITY_BUILDING['EnterMapAnimDeltaTime'])
		else
			objAnim.transform:DR_DOScaleXY(SCALE_CITY_BUILDING['normal_c'].x, SCALE_CITY_BUILDING['normal_c'].x, SCALE_CITY_BUILDING['EnterMapAnimDeltaTime'])
		end
	end 
end

function CityBuildingUI:UpdateTaskMark()
	local max_weight_info = TaskDataManager:GetInstance():CheckMapMark(self.mapData)
	if max_weight_info and max_weight_info.state then
		self.comIconQuestMark.gameObject:SetActive(true)
		local markSprite = GetAtlasSprite("CommonAtlas", max_weight_info.state)
		if (markSprite ~= nil) then
			self.comIconQuestMark.sprite = markSprite
		end
	else
		self.comIconQuestMark.gameObject:SetActive(false)
	end
end

function CityBuildingUI:UpdateRole()
	-- 播动画的时候先不更新
	if self.isPlayingRoleAnim then 
		return
	end
	self:HideAllRole()

	local buildingType = MapBuildingType.BT_BUILDING
	if self.mapData and self.mapData.BuildingType then
		buildingType = self.mapData.BuildingType
	end
	local bShowEnterFrame = (buildingType == MapBuildingType.BT_DOOR) 
		or (buildingType == MapBuildingType.BT_MAZE)
		or (buildingType == MapBuildingType.BT_CLAN)
		or (buildingType == MapBuildingType.BT_HIGHCLAN)
	self.objEnterMapFrame:SetActive(bShowEnterFrame)

	local roleIdList = MapDataManager:GetInstance():GetRoleList(self.mapData.BaseID)
	if not (type(roleIdList) == 'table' and #roleIdList > 0) then 
		self.objFloorMask:SetActive(false)
		return
	end
	self.objFloorMask:SetActive(true)
	roleIdList = MapDataManager:GetInstance():SortMapRoleID(roleIdList, self.mapData.BaseID)
	if #roleIdList > 0 then
		self.objEnterMapFrame:SetActive(false)
	end

	-- 建筑显示角色最大数量
	for index, roleID in ipairs(roleIdList) do 
		if index > self.roleMaxCount then
			break
		end
		local objCityRole = self:GetAvailableRoleObj(roleID)
		if objCityRole then 
			objCityRole:SetActive(true)
			self:UpdateCityRoleEx(objCityRole, roleID)
			objCityRole:PlayRoleRecoverAnim()
		end
	end
end

function CityBuildingUI:GetSpecialMapRoleAnim(roleID, mapID)
	if not self.specialMapRoleAnimCache then
		local datas = TableDataManager:GetInstance():GetTable("SpecialMapRoleAnimation")
	
		if not datas then
			return nil
		end
	
		self.specialMapRoleAnimCache = {}
		for id, data in pairs(datas) do
			self.specialMapRoleAnimCache[data.Role] = self.specialMapRoleAnimCache[data.Role] or {}
			self.specialMapRoleAnimCache[data.Role][data.Map] = {tagID = data.Tag, animationName = data.AnimationName}
		end
	end

	local roleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
	local data = nil

	if not roleTypeID then
		return nil
	end

	if self.specialMapRoleAnimCache and self.specialMapRoleAnimCache[roleTypeID] then
		local roleCache = self.specialMapRoleAnimCache[roleTypeID]

		if mapID then
			data = roleCache[mapID]
		end

		if not data then
			data = roleCache[0]
		end
	end

	if data and data.tagID then
		if TaskTagManager:GetInstance():TagIsValue(data.tagID, 1) then
			return data.animationName
		end
	end

	return nil
end

function CityBuildingUI:UpdateCityRoleEx(objCityRole, roleID)
	local specificAnimationName = self:GetSpecialMapRoleAnim(roleID, self.mapID)

	objCityRole:UpdateCityRole(self.mapID)
	if specificAnimationName then 
		objCityRole:SetAction(specificAnimationName)
	else
		objCityRole:SetAction(ROLE_SPINE_DEFAULT_ANIM, true)
	end
end

function CityBuildingUI:GetCityRoleUiInst(index, createIfNotExist)
	if type(self.cityRoleUiInstList) ~= 'table' then 
		self.cityRoleUiInstList = {}
	end
	if self.cityRoleUiInstList[index] == nil and createIfNotExist then 
		self.cityRoleUiInstList[index] = CityRoleUI.new()
	end
	return self.cityRoleUiInstList[index]
end

function CityBuildingUI:HideAllRole()
	if self.cityRoles == nil then 
		return
	end
	for i = 1, #self.cityRoles do 
		local objRole = self.cityRoles[i]
		objRole:SetActive(false)
	end
end

function CityBuildingUI:GetAvailableRoleObj(roleID)
	if not self.comRoleParentTransform then 
		return nil
	end
	self.cityRoles = self.cityRoles or {}
	local childCount = #self.cityRoles
	local cityRole = nil
	local index = 0
	for i = 1, childCount do 
		cityRole = self.cityRoles[i]
		if not cityRole:IsActive() then 
			index = i
			break
		end
		cityRole = nil
	end
	if cityRole == nil then 
		local objRole = LoadPrefabAndInit("City/CityRoleUI", self.comRoleParentTransform, true)
		cityRole = CityRoleUI.new(false)
		cityRole:SetGameObject(objRole)
		cityRole:SetDefaultScale(MAZE_SPINE_SCALE)
		table.insert(self.cityRoles,cityRole)
		index = childCount + 1
	end
	local roleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(roleID)
	local order = (150 - index) < 141 and (150 - index)  or 141
	cityRole:SetSortingOrder(order)
	cityRole:SetRoleDataByUID(roleID)

	
    cityRole.gameObject.name = 'role' .. tostring(roleBaseID)
	return cityRole
end

function CityBuildingUI:OnDrag(obj,eventData)
	local roleCount = MapDataManager:GetInstance():GetRoleCount(self.mapID)
	if roleCount == 0 then 
		return 
	end
	local selectRoleIndex = self:GetPointerSelectRoleIndex(obj)
	self:UpdateSelectRole(selectRoleIndex)
end

function CityBuildingUI:OnPointerDown(obj,eventData)
	local roleCount = MapDataManager:GetInstance():GetRoleCount(self.mapID)
	if roleCount == 0 then 
		if self.comBuildingTweenAnimation then 
			self.comBuildingTweenAnimation:DOPlayBackwards()
		end
	else
		local selectRoleIndex = self:GetPointerSelectRoleIndex(obj)
		self:UpdateSelectRole(selectRoleIndex, true)
	end
end

function CityBuildingUI:OnPointerUp(obj,eventData)
	local roleCount = MapDataManager:GetInstance():GetRoleCount(self.mapID)
	if roleCount == 0 then 
		if self.comBuildingTweenAnimation then 
			self.comBuildingTweenAnimation:DOPlayForward()
		end
	else
		local objRole = self:GetSelectRoleObj()
		if objRole then 
			objRole:PlayRoleRecoverAnim()
		end
	end
end

function CityBuildingUI:OnPointerExit(obj,eventData)
	local roleCount = MapDataManager:GetInstance():GetRoleCount(self.mapID)

	if roleCount == 0 then 
		if self.comBuildingTweenAnimation then 
			self.comBuildingTweenAnimation:DOPlayForward()
		end
	else
		self:UpdateSelectRole(0)
	end
end
--luaUIAction中所有回调第一个参数是obj,第二个参数才是eventData
function CityBuildingUI:OnPointerClick(obj,eventData)
	if not self:CanInteract() or eventData.button == DRCSRef.EventSystems.PointerEventData.InputButton.Right then 
		return 
	end
	local roleList = MapDataManager:GetInstance():GetRoleList(self.mapID)
	if roleList and #roleList > 0 then
		if self.selectRoleIndex > 0 and self.selectRoleIndex <= #roleList then
			local roleID = roleList[self.selectRoleIndex]
			RoleDataManager:GetInstance():TryInteract(roleID, self.mapID)
			return 
		end
	else
		SendClickMap(CMT_BUILDING, self.mapID)
		self._gameObject.tag = 'Click'
	end
end

function CityBuildingUI:GetSelectRoleObj()
	if self.cityRoles == nil or self.selectRoleIndex > #self.cityRoles then 
		return nil
	end
	local objRole = self.cityRoles[self.selectRoleIndex]
	return objRole
end

function CityBuildingUI:GetPointerSelectRoleIndex(eventData)
	local roleCount = MapDataManager:GetInstance():GetRoleCount(self.mapID)
	if roleCount <= 0 then 
		return 0
	end

	-- 建筑显示角色最大数量
	local maxCount = MapDataManager:GetInstance():GetShowRoleMaxCount(self.mapID)
	if roleCount > maxCount then
		roleCount = maxCount
	end

	local pointerPosX = eventData.position.x
	local buildingWidth = self.comTransform.rect.width
	local _, localPointPos = CS.UnityEngine.RectTransformUtility.ScreenPointToLocalPointInRectangle(self.comTransform, eventData.position, UI_Camera)
	pointerPosX = localPointPos.x
	local deltaWidth = buildingWidth / roleCount
	local leftPosX =  -(buildingWidth / 2)
	for i = 1, roleCount do 
		if pointerPosX > leftPosX + ((i - 1) * deltaWidth) and pointerPosX <= leftPosX + (i * deltaWidth) then 
			return i
		end
	end
	return 0
end

function CityBuildingUI:UpdateSelectRole(newSelectRoleIndex, forceUpdate)
	newSelectRoleIndex = newSelectRoleIndex or 0
	if not forceUpdate and newSelectRoleIndex == self.selectRoleIndex then 
		return 
	end
	local curSelectRoleIndex = self.selectRoleIndex
	local objRole = self:GetSelectRoleObj()
	if objRole then 
		objRole:PlayRoleRecoverAnim()
	end
	self.selectRoleIndex = newSelectRoleIndex
	objRole = self:GetSelectRoleObj()
	if objRole then 
		objRole:PlayRoleSelectAnim()
	end
end

function CityBuildingUI:BuildingShowAnimation(obj)
	if not obj then 
		return 
	end

	local scale = SCALE_CITY_BUILDING['normal']
	local curMapData = MapDataManager:GetInstance():GetCurMapData()  
	if curMapData and ((curMapData.IsUseBroadLayer == TBoolean.BOOL_YES) or (curMapData.PasserCount ~= nil and curMapData.PasserCount > 0)) then
		scale = SCALE_CITY_BUILDING['wide']
	end

	Twn_Scale(nil, obj, DRCSRef.Vec3(0.6,0.6,0.6), scale, 0.35, DRCSRef.Ease.Linear)
end

function CityBuildingUI:CanInteract()
	local cityUI = GetUIWindow("CityUI")
	if cityUI:IsOpenAnim() then 
		return false
	end
	-- 等待下行时不允许点击
    if g_isWaitingDisplayMsg then 
        return false
    end
    -- 当前显示队列没结束不允许点击
    if DisplayActionManager._instance:GetActionListSize() > 0 then 
        return false
    end
	return true
end

function CityBuildingUI:ResetAdvloot()
	self.AdvlootList = self.AdvlootList or {}
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.AdvlootList)
	self.AdvlootList = {}

	self.customAdvLoots = self.customAdvLoots or {}
	LuaClassFactory:GetInstance():ReturnAllUIClass(self.customAdvLoots)
	self.customAdvLoots = {}
end

function CityBuildingUI:Update(deltaTime)
	if self.iUpdateAdvloot then
		-- 播动画的时候先不更新
		if not self.isPlayingRoleAnim then 
			self.iUpdateAdvloot = false
			self:UpdateDynacMapLoot()
			self:UpdateCustomAdvLoot()
		end
	end
end

function CityBuildingUI:SetUpdateAdvlootFlag()
	self.iUpdateAdvloot = true
end

function CityBuildingUI:UpdateDynacMapLoot()
	if self.mapData == nil then 
		return 
	end

	local auiAdvLoots =  AdvLootManager:GetInstance():GetDyncMapAdvlootDataList(self.mapID)
    if auiAdvLoots == nil then
		return
	end
	self.AdvlootList = self.AdvlootList or {}

	local delayTimer = 0
	for uiID, tempData in pairs(auiAdvLoots) do
		if tempData ~= nil then
			if tempData.uiNum > 0 then
				local func_update = function()
					if self.AdvlootList[uiID] == nil then
						self.AdvlootList[uiID] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.AdvlootUI, self.objAdvLootUIParent.transform)
					end
					local adv_loot = self.AdvlootList[uiID]

					local deleteFunc = function()
						self.AdvlootList = self.AdvlootList or {}
						self.AdvlootList[uiID] = nil
						LuaClassFactory:GetInstance():ReturnUIClass(adv_loot)
					end

					if tempData.uiSiteType == ADVLOOT_SITE.ADV_CITY_DYNAC then
						local itemID = tempData.uiAdvLootID
						adv_loot:UpdateDynacMapLoot(self.mapID, uiID, itemID, deleteFunc) 
					end
				end
				if not AdvLootManager:GetInstance():IsMapDynamicAdvLootFirstUpdate(uiID) then 
					func_update()
				else
					g_mazeGridAdvLootUpdateTimer = globalTimer:AddTimer(delayTimer, func_update)
					delayTimer = delayTimer + math.random(50, 100)
				end
			end
		end
	end
end

function CityBuildingUI:UpdateCustomAdvLoot()
	local customAdvLoots = AdvLootManager:GetInstance():GetCustomAdvLoots(self.mapID)
	if customAdvLoots == nil then 
		return
	end
	for taskEventID, customAdvLoot in pairs(customAdvLoots) do 
		if self.customAdvLoots[taskEventID] == nil then
			self.customAdvLoots[taskEventID] = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.AdvlootUI, self.objAdvLootUIParent.transform)
		end
		local advLootNode = self.customAdvLoots[taskEventID]
		local deleteFunc = function()
			if self and self.customAdvLoots then 
				LuaClassFactory:GetInstance():ReturnUIClass(self.customAdvLoots[taskEventID])
				self.customAdvLoots[taskEventID] = nil
			end
		end
		advLootNode:UpdateCustomAdvLoot(customAdvLoot, deleteFunc)
	end
end

function CityBuildingUI:PlayRoleAnim(roleBaseID, animName)
	for _, cityRole in ipairs(self.cityRoles) do 
		if cityRole.iCurRoleTypeID == roleBaseID and cityRole:IsActive() then
			g_treasureBoxMapID = self.mapID
			g_objTreasureBoxRole = cityRole.gameObject
			self.isPlayingRoleAnim = true
			local deltaTime = cityRole:SetAction(animName, false)
			globalTimer:AddTimer(deltaTime, function()
				if self then 
					self:ResetRoleAnimPlayState()
				end
			end, 1)
			return deltaTime
		end
	end
    return 0
end

function CityBuildingUI:ResetRoleAnimPlayState(mapID)
	self.isPlayingRoleAnim = false
	if mapID == g_treasureBoxMapID then 
		g_objTreasureBoxRole = nil
	end
end

return CityBuildingUI