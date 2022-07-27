CityUI = class("CityUI",BaseWindow)
local CityBuildingUI = require 'UI/MapUI/CityBuildingUI'
local AdvLootUI = require 'UI/MazeUI/AdvLootUI'
local advlootRayCheck = require 'UI/MazeUI/AdvlootRayCheck'

function CityUI:Create()
	local obj = LoadPrefabAndInit("City/CityUI",Scence_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function CityUI:ctor()
	self._coroutine = {}
	self._tween = {}
end

function CityUI:Init()
	self.mapDataManagerInstace = MapDataManager:GetInstance()

	self.advlootRayCheck = AdvlootRayCheck.new()
	self.advlootRayCheck:Create()
	self.advlootRayCheck:Init()

	self.comSceneBGImage = self:FindChildComponent(self._gameObject, 'BG', 'Image')
	self.comSceneBGImageRectTransform = self.comSceneBGImage:GetComponent('RectTransform')
	self.objBasement = self:FindChild(self._gameObject,"basement")
	self.comBasementRectTransform = self.objBasement:GetComponent('RectTransform')
	self.comBasementImage = self.objBasement:GetComponent('Image')
	self.adv_loot_Root = self:FindChild(self._gameObject,"adv_loot_Root")
	self.objBuildings = self:FindChild(self._gameObject, "Buildings")
	self.comBuildingsLayout = self.objBuildings:GetComponent("HorizontalLayoutGroup")
	self.comBuildingsLayoutRectTransform = self.objBuildings:GetComponent("RectTransform")
	self.objPlayerNodes = self:FindChild(self._gameObject, "PlayerNodes")
	self.akTransPlayerNodes = self:GenTransPlayerNodes(self.objPlayerNodes)

	self.objBuildingList = {}
	self.cityBuildingUIList = {}
	for i = 1, self.objBuildings.transform.childCount do 
		local objBuilding = self.objBuildings.transform:GetChild(i - 1).gameObject
		self.objBuildingList[i] = objBuilding
		local cityBuildingUI = CityBuildingUI.new()
		self.cityBuildingUIList[i] = cityBuildingUI
		cityBuildingUI:Init(objBuilding)
	end

	self.comSceneBGImage_anim = self:FindChildComponent(self._gameObject, 'BG_anim', 'Image')
	self.objBuildings_anim = self:FindChild(self._gameObject, "Buildings_anim")
	self.comBuildingsLayout_anim = self.objBuildings_anim:GetComponent("HorizontalLayoutGroup")

	self.objBackgroundEffect = self:FindChild(self._gameObject,"BackgroundEffectUI")
	MapEffectManager:GetInstance():InitBackgroundEffect(self.objBackgroundEffect)


	self.uiLastMap = nil
	self.uiLastShowMap = nil 
	self.isOpenAnim = nil
	self.skipAnim = false

	self.akPlayerSpineItems = {}

	-- 检查cityui加载出来之前mapdatamanager有没有设置需要请求玩家数据的标记
	local bNeedUpdate, iCurMap = self.mapDataManagerInstace:GetIfNeedRequestStandPlayers()
	if (bNeedUpdate == true) and (iCurMap ~= nil) then
		self:JungAndReqStanPlayersByMapID(iCurMap)
	end
end

function CityUI:InitEventListener()
	self:AddEventListener("MAP_UPDATE", function(mapID) 
		self:OnMapUpdateEvent(mapID) 
	end)
	self:AddEventListener("TASK_BROADCAST",function(uiCurMap) 
		self:UpdateTaskData(uiCurMap)
	end)
end

function CityUI:RemoveCityUiEventListener()
	self:RemoveEventListener("MAP_UPDATE")
	self:RemoveEventListener("TASK_BROADCAST")
end

function CityUI:OnEnable()
	RemoveWindowImmediately("MazeUI")
	RemoveWindowImmediately("FinalBattleUI")
	self.adv_loot_Root:SetActive(true)
	self:RefreshUI()
	if not self.isOpenAnim then
		self:ReOpenWindow()
	end
	self:InitEventListener()

	MapEffectManager:GetInstance():UpdateBackgroundEffect(self.objBackgroundEffect)
	-- 强刷状态栏
	local toptitleUI = GetUIWindow('ToptitleUI')
	if toptitleUI ~= nil and toptitleUI:IsOpen() then 
		toptitleUI:RefreshUIImmediately()
	end
end

function CityUI:IsOpenAnim()
	return self.isOpenAnim
end

function CityUI:ReOpenWindow(windowName)
	-- FIXME: 效率优化点, 避免重复执行
	DisplayActionManager:GetInstance():ShowToptitle(TOPTITLE_TYPE.TT_MAP)
	DisplayActionManager:GetInstance():ShowNavigation()
	OpenWindowImmediately("TaskTipsUI")
end

function CityUI:OnDisable()
	self.adv_loot_Root:SetActive(false)
	for _, cityBuildingUI in ipairs(self.cityBuildingUIList) do 
		cityBuildingUI:ResetRoleAnimPlayState()
	end
	DisplayActionManager:GetInstance():HideToptitle()
	DisplayActionManager:GetInstance():HideNavigation()
	--RemoveWindowImmediately("CityRoleListUI")		--不知道为什么disable的时候要remove，进入迷宫会导致被remove，然后左上角按钮就无效了
	RemoveWindowImmediately("TaskTipsUI", true)
	self:RemoveCityUiEventListener()
	-- 如果是城市界面进入了迷宫界面, 那么不需要关闭天气效果
	if not IsWindowOpen("MazeUI") then
		CityDataManager:GetInstance():CloseLastWeatherEffect()
	else
		OpenWindowImmediately("TaskTipsUI")
	end
end

function CityUI:OnDestroy()
	for _, cityBuildingUI in ipairs(self.cityBuildingUIList) do 
		cityBuildingUI:Close()
	end

	MapEffectManager:GetInstance():DestroyBackgroundEffect(self.objBackgroundEffect)
end

function CityUI:GetGuideInfo(roletypeid)
	local uiCurMap = self.mapDataManagerInstace:GetCurMapID()
	local childMapList = self.mapDataManagerInstace:GetChildMapList(uiCurMap)
	for index, childMapID in ipairs(childMapList) do
		local buildobj = self.objBuildingList[index]
		local roleIdList = self.mapDataManagerInstace:GetRoleList(childMapID)
		roleIdList = self.mapDataManagerInstace:SortMapRoleID(roleIdList)

		for index, value in ipairs(roleIdList) do
			local buildRoleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(value)
			if buildRoleTypeID == roletypeid then
				local cityBuildingUI = self.cityBuildingUIList[index]
				return {buildobj, index, roleIdList, cityBuildingUI}
			end
		end
	end
end

function CityUI:UpdateSceneByMapMove(uiCurMapID)
	local uiCurMapID = uiCurMapID or self.mapDataManagerInstace:GetCurMapID()
	local mapData = self.mapDataManagerInstace:GetMapData(uiCurMapID)
	local lastMapData = self.mapDataManagerInstace:GetMapData(self.uiLastMap)
	-- 播放动画控制
	if mapData ~= nil and lastMapData ~= nil then
		self:UpdateAnimData()
		if self.mapDataManagerInstace:GetParentMapID(uiCurMapID) == self.uiLastMap then
			self:PlayEnterAnim()
		elseif self.mapDataManagerInstace:GetParentMapID(self.uiLastMap) == uiCurMapID then
			self:PlayExitAnim()
		end
	end
	self.uiLastMap = uiCurMapID
	self:UpdateScene(uiCurMapID)
end

function CityUI:PlayEnterAnim()
	local lastMapData = self.mapDataManagerInstace:GetMapData(self.uiLastMap)
	if lastMapData == nil then
		return
	end

	-- 需要播放切换地图动画时，对点击的建筑，播放点击动画。
	for i = 1, #self.objBuildingList_anim do
		if self.objBuildingList_anim[i]:CompareTag("Click") then
			local cityBuildUI = self.cityBuildingUIList[i]
			cityBuildUI:PlayEnterAnim(self.objBuildingList_anim[i], lastMapData)
			break
		end
	end
end

function CityUI:PlayExitAnim()

end

-- 需要播放地图切换动画时，将旧地图的节点 Clone 填充到动画层
function CityUI:UpdateAnimData()

	-- 更新 anim 的 背景
	self.comSceneBGImage_anim.sprite = self.comSceneBGImage.sprite

	-- 复制 Building
	RemoveAllChildren(self.objBuildings_anim)
	for i = 1, #self.objBuildingList do
		CloneObj(self.objBuildingList[i], self.objBuildings_anim)
		-- 取消 tag
		self.objBuildingList[i].tag = 'Untagged'
	end

	-- 复制 间距
	self.objBuildings_anim.transform.localPosition = self.objBuildings.transform.localPosition
	self.comBuildingsLayout_anim.spacing = self.comBuildingsLayout.spacing

	self.objBuildingList_anim = {}
	for i = 1, self.objBuildings_anim.transform.childCount do 
		self.objBuildingList_anim[i] = self.objBuildings_anim.transform:GetChild(i - 1).gameObject
	end
end

function CityUI:UpdateSceneEffect()
	--当五大主城有天气特效时，则五大主城的主城特效隐藏
	if CityDataManager:GetInstance():GetLastWeatherEffectTypeID() > 0 then
		if IsValidObj(self.objSceneEffect) then
			self.objSceneEffect:SetActive(false)
		end
		return
	end

	local kMapData = self.mapDataManagerInstace:GetCurMapData()
	if not kMapData then
		return
	end 
	local kPath  = kMapData.SceneEffect
	if self.SceneEffectPath ~= kPath then
		if IsValidObj(self.objSceneEffect) then
			DRCSRef.ObjDestroy(self.objSceneEffect)
		end
		self.SceneEffectPath  = kPath
		if kPath ~= "" and kPath ~= nil then
			self.objSceneEffect = LoadEffectAndInit(kPath,self.objBackgroundEffect,true)
		end
	else
		if IsValidObj(self.objSceneEffect) then
			self.objSceneEffect:SetActive(true)
		end
	end
end

function CityUI:UpdateScene(uiCurMap, bUpdateAdvLoot)
	uiCurMap = uiCurMap or self.mapDataManagerInstace:GetCurMapID()
	if not uiCurMap then 
		return 
	end
	if G_Last_city_bgmID ~= uiCurMap then 
		G_Last_city_bgmID = uiCurMap
		PlayMusicHelper()
	end
	self:UpdateSceneEffect()

	self:UpdateSceneBG(uiCurMap)
	self:UpdateSceneBuilding(uiCurMap)
	self:UpdateSceneBasement(uiCurMap)
	if bUpdateAdvLoot ~= false then 
		self:UpdateAdvLoot(uiCurMap)
	end
end

function CityUI:UpdateSceneBasement(uiCurMap)
	local mapData = self.mapDataManagerInstace:GetMapData(uiCurMap)
	if mapData == nil then 
		return
	end
	if dnull(mapData.SceneBottomImg) then
		self.comBasementImage.sprite = GetSprite(mapData.SceneBottomImg)
		self.objBasement:SetActive(true)
	else
		self.objBasement:SetActive(false)
	end
end

function CityUI:UpdateSceneBG(uiCurMap)
	local mapData = self.mapDataManagerInstace:GetMapData(uiCurMap)
	if mapData == nil then 
		return 
	end
	local sceneBG = mapData.SceneImg
	local mapAttrChange = MapDataManager:GetInstance():GetMapAttrChange(uiCurMap)
	if (mapAttrChange ~= nil and mapAttrChange.SceneImg ~= nil and mapAttrChange.SceneImg ~= "" and mapAttrChange.SceneImg ~= "-") then
		sceneBG = mapAttrChange.SceneImg
	end
	
	if sceneBG then 
		self.comSceneBGImage.sprite = GetSprite(sceneBG)
	end
end

function CityUI:ResetAdvloot()
	self.AdvlootList = self.AdvlootList or {}
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.AdvlootList)
	self.AdvlootList = {}
end

function CityUI:Update(deltaTime)
	if IsWindowOpen('TileBigMap') and (not IsWindowOpen('BigMapCloudAnimUI')) then
		RemoveWindowImmediately("TileBigMap")
	end
	self.cityBuildingUIList = self.cityBuildingUIList or {}
	for _, cityBuildingUI in ipairs(self.cityBuildingUIList) do
		cityBuildingUI:Update(deltaTime)
	end

	self.advlootRayCheck:Update()
end

function CityUI:UpdateAdvLoot(uiCurMap)
	self:ResetAdvloot()
	uiCurMap = self.mapDataManagerInstace:GetCurMapID()

	local mapData = self.mapDataManagerInstace:GetMapData(uiCurMap)
	if mapData == nil then 
		return
	end
	local auiAdvLoots = AdvLootManager:GetInstance():GetMapAdvlootDataList(uiCurMap)
    if auiAdvLoots == nil then
		return
	end

	for uiID, tempData in pairs(auiAdvLoots) do
		if tempData ~= nil and tempData.uiNum > 0 then
			local adv_loot = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.AdvlootUI,self.adv_loot_Root.transform)
			table.insert(self.AdvlootList,adv_loot)
			local deleteFunc = function()
				self.AdvlootList = self.AdvlootList or {}
				for index, value in pairs(self.AdvlootList) do
					if adv_loot and value and value == adv_loot then
						table.remove(self.AdvlootList, index)
					end
				end
				LuaClassFactory:GetInstance():ReturnUIClass(adv_loot)
			end

			if tempData.uiSiteType == ADVLOOT_SITE.ADV_CITY then
				local buildAdvLootBaseID = tempData.uiAdvLootID
				adv_loot:UpdateMapAdvLoot(uiID, buildAdvLootBaseID, uiCurMap, deleteFunc) 
			end
		end
	end
end

function CityUI:OnDestroy()
	self:ReturnAllStandPlayers()
	self:ResetAdvloot()
	for _, ui in pairs(self.cityBuildingUIList) do 
		ui:Close()
	end
end

function CityUI:UpdateTaskData(uiCurMap)
	uiCurMap = uiCurMap or self.mapDataManagerInstace:GetCurMapID()
	local childMapList = self.mapDataManagerInstace:GetChildMapList(uiCurMap)
	for index, childMapID in ipairs(childMapList) do 
		local cityBuildUI = self.cityBuildingUIList[index]
		cityBuildUI:UpdateTaskData(childMapID)
	end
end

function CityUI:HideAllBuilding()
	for index, objBuildingUI in ipairs(self.objBuildingList) do 
		objBuildingUI:SetActive(false)
	end
end

function CityUI:UpdateSceneBuilding(uiCurMap)
	self:HideAllBuilding()
	uiCurMap = uiCurMap or self.mapDataManagerInstace:GetCurMapID()
	local childMapList = self.mapDataManagerInstace:GetChildMapList(uiCurMap)
	if #childMapList == 0 then 
		derror("[CityUI]->UpdateSceneBuilding  No child map. CurMapID:" .. tostring(uiCurMap))
	end
	local uiIndex = 1
	for _, childMapID in ipairs(childMapList) do 
		local cityBuildUI = self.cityBuildingUIList[uiIndex]
		if cityBuildUI == nil then 
			-- derror('[CityUI]->UpdateSceneBuilding  Update Building out of range. uiIndex:' .. uiIndex .. ' curMapID:' .. uiCurMap .. '  childMapID:' .. tostring(childMapID) .. '  childCount:' .. #childMapList)
			break
		end
		if cityBuildUI:UpdateBuilding(childMapID) then 
			if uiCurMap ~= self.uiLastShowMap then
				cityBuildUI:BuildingShowAnimation(self.objBuildingList[uiIndex])
			end
			uiIndex = uiIndex + 1
		end
	end

	-- 按地图，修改建筑的位置/间距
	self:UpdateBuildingLayout(uiCurMap)
	self.uiLastShowMap = uiCurMap
end

function CityUI:UpdateBuildingLayout(mapID)
	local mapData = self.mapDataManagerInstace:GetMapData(mapID)
	if mapData == nil then 
		return
	end
	if (mapData.IsUseBroadLayer == true) or (mapData.PasserCount ~= nil and mapData.PasserCount > 0) then
		self.objBuildings:SetObjLocalPosition(0, -12, 0)
		--第一次进主城的动画里建筑卡片下来之后，layout被开启，间距会有细微的变化，因此这里先注释掉，间距用UI默认的20  ——王伦
		--self.comBuildingsLayout.spacing = 15
	else
		self.objBuildings:SetObjLocalPosition(0, -36, 0)
		self.comBuildingsLayout.spacing = 20
	end
	DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(self.comBuildingsLayoutRectTransform)
end

function CityUI:OnMapUpdateEvent(mapID)
	if self.mapDataManagerInstace:IsCurMap(mapID) or self.mapDataManagerInstace:IsCurMapChild(mapID) then 
		self:UpdateScene(nil, false)
	end
end

local init = false
function CityUI:RefreshUI(mapID)
	if IsBattleOpen() then
		RemoveWindowImmediately('CityUI')
		if mapID then
			DisplayActionEnd()
		end
		return 
	end
	self:ResetMenuUI()
	self:UpdateScene()
	self:UpdateRoleListUI()
	if mapID then
		self:StartCityOpenAnimation(mapID)
	else
		local curMapID = self.mapDataManagerInstace:GetCurMapID()
		if not self:IsFirstEnterCity(curMapID) then
			CityDataManager:GetInstance():UpdateCityWeatherEffect()
		end
	end
end

function CityUI:ResetMenuUI()
	local navigationUI = DisplayActionManager:GetInstance():ShowNavigation()
	if navigationUI then 
		navigationUI._gameObject:SetObjLocalPosition(0, 0, 0)
	end
	local topTitleUI = DisplayActionManager:GetInstance():ShowToptitle()
	if topTitleUI then 
		topTitleUI._gameObject:SetObjLocalPosition(0, 0, 0)
	end
end

function CityUI:UpdateRoleListUI()
	if self:CanCurStoryShowRoleList() and self.mapDataManagerInstace:CanMapShowRoleList() then 
		if not IsWindowOpen("CityRoleListUI") then 
			OpenWindowImmediately("CityRoleListUI")
		end
	else
		RemoveWindowImmediately("CityRoleListUI")
	end
end

-- 当前剧本能否显示角色列表
function CityUI:CanCurStoryShowRoleList()
	local curStoryID = GetCurScriptID()
	local TB_Story = TableDataManager:GetInstance():GetTable("Story")
	local storyData = TB_Story[curStoryID]
	if storyData ~= nil and storyData.IsForbidShowCityRoleList ~= TBoolean.BOOL_YES then 
		return true
	end
	return false
end

function CityUI:StartCityOpenAnimation(mapID)
	PlayButtonSound("EventCity")
	local eState = WindowsManager:GetInstance():GetWindowState("TileBigMap")
	if eState == UIWindowState.UNCREATE then
		self:DoCityOpenAnimation(mapID)
		return
	end

	self._gameObject:SetActive(false)
	local bigMapUI = GetUIWindow("TileBigMap")

	if bigMapUI then
		bigMapUI:OpenCityAnimation(function()
			self._gameObject:SetActive(true)
			self:DoCityOpenAnimation(mapID)
			RemoveWindowImmediately("TileBigMap")
		end)
	end
end

function CityUI:IsFirstEnterCity(mapID)
	local mapData = self.mapDataManagerInstace:GetMapData(mapID)
	if not mapData then 
		return false
	end
	local curMapID = mapData.BaseID
	local storyId = GetCurScriptID()
	local checkKey = string.format("CityAnim_%s_%s", storyId, curMapID)
	local count = GetConfig(checkKey)
	local hasPlayed = count == 1 or g_skipAllUselessAnim
	local poemdata = TableDataManager:GetInstance():GetTableData("MapPoem",curMapID)
	return mapData and poemdata and not hasPlayed
end

function CityUI:DoCityOpenAnimation(mapID, func)
	local mapData = self.mapDataManagerInstace:GetMapData(mapID)
	if mapData and self:IsFirstEnterCity(mapID) then
		local curMapID = mapData.BaseID
		local storyId = GetCurScriptID()
		local checkKey = string.format("CityAnim_%s_%s", storyId, curMapID)

		self.isOpenAnim = true
		self:SetActive(true)
		self:UpdateScene()
		if IsValidObj(self.objSceneEffect) then
			self.objSceneEffect:SetActive(false)
		end
		self.objBuildings:SetActive(false)
		self.adv_loot_Root:SetActive(false)
		--这部分有消耗，后期找有时间优化
		self:ReOpenWindow()

		--=========================
		DisplayActionManager:GetInstance():HideToptitle()
		DisplayActionManager:GetInstance():HideNavigation()
		RemoveWindowImmediately("CityRoleListUI")
		RemoveWindowImmediately("TaskTipsUI")
		RemoveWindowImmediately("MiniMapUI")
		--=========================

		local function func_Complete(skip)
			if skip then
				self.isOpenAnim = false
				if self._coroutine.BGScale then
					CS_Coroutine.stop(self._coroutine.BGScale)
					self._coroutine.BGScale = nil
				end
				if self._coroutine.BasementMove then
					CS_Coroutine.stop(self._coroutine.BasementMove)
					self._coroutine.BasementMove = nil
				end
				self.bgMoveTween:Pause()
				self.comSceneBGImageRectTransform:SetTransAnchoredPosition(0, 0)
				self.comBasementRectTransform:SetTransAnchoredPosition(0, 0)
				self.comSceneBGImageRectTransform.localScale = DRCSRef.Vec3One
				self.objBuildings:SetActive(true)
				self.adv_loot_Root:SetActive(true)
				self.comBuildingsLayout.enabled = true
				DisplayActionManager:GetInstance():ShowNavigation()
				DisplayActionManager:GetInstance():ShowToptitle()
				OpenWindowImmediately("CityRoleListUI")
				OpenWindowImmediately("TaskTipsUI")
				RemoveWindowImmediately("TileBigMap")
				if IsValidObj(self.objPlayerNodes) then
					self.objPlayerNodes:SetActive(true)
				end
				if IsValidObj(self.objSceneEffect) then
					self.objSceneEffect:SetActive(true)
				end
				SetConfig(checkKey,1)
				DisplayActionEnd()
			else
				if IsValidObj(self.objSceneEffect) then
					self.objSceneEffect:SetActive(true)
				end
				self:BuildingOpeningAnimation()
				self:OtherPanelOpeningAnimation()
				-- OpenWindowImmediately("ChatBoxUI")				
			end
			SetConfig(checkKey,1)
			if func ~= nil then
				func()
			end
		end
		self:BGOpeningAnimation()
		self:BasementOpeningAnimation()

		-- RemoveWindowImmediately("ChatBoxUI")
		self.objPlayerNodes:SetActive(false)
		OpenWindowImmediately("CityAnimUI", {mapId = curMapID, OnComplete = func_Complete})

		RemoveWindowImmediately("BigMapCloudAnimUI")
	else
		if func ~= nil then
			func()
		end
		self:NormalOpenCityAnimation()
		DisplayActionEnd()
	end
end

function CityUI:BGOpeningAnimation()
	local oldScale = self.comSceneBGImageRectTransform.localScale
	local newScale = oldScale * 1.5
	self.comSceneBGImageRectTransform.localScale = newScale

	self.comSceneBGImageRectTransform:SetTransAnchoredPosition(300, 0)
	self.bgMoveTween = Twn_MoveX(self.bgMoveTween, self.comSceneBGImage, -300, 5, DRCSRef.Ease.InOutQuad)
	if self._coroutine.BGScale then
		CS_Coroutine.stop(self._coroutine.BGScale)
		self._coroutine.BGScale = nil
	end
	self._coroutine.BGScale = CS_Coroutine.start(function()
		coroutine.yield(CS.UnityEngine.WaitForSeconds(4.5))
		Twn_Scale(nil, self.comSceneBGImage, newScale, oldScale, 1, DRCSRef.Ease.InOutQuad)		
	end)
end

function CityUI:BasementOpeningAnimation()
	self.comBasementRectTransform:SetTransAnchoredPosition(0, -400)
	if self._coroutine.BasementMove then
		CS_Coroutine.stop(self._coroutine.BasementMove)
		self._coroutine.BasementMove = nil
	end
	self._coroutine.BasementMove = CS_Coroutine.start(function()
		coroutine.yield(CS.UnityEngine.WaitForSeconds(4.5))
		Twn_MoveY(nil, self.objBasement, 0, 340, 1, DRCSRef.Ease.OutQuad)		
	end)
end

function CityUI:BuildingOpeningAnimation()
	local wait = CS.UnityEngine.WaitForSeconds(0.2)
	--init
	self.objBuildings:SetActive(true)
	self.adv_loot_Root:SetActive(false)
	for i = 1, #self.objBuildingList do 
		self.objBuildingList[i]:SetActive(false)
	end
	if self._coroutine.MoveBuildings then
		CS_Coroutine.stop(self._coroutine.MoveBuildings)
		self._coroutine.MoveBuildings = nil
	end
	self._coroutine.MoveBuildings = CS_Coroutine.start(function()
		if self.mapDataManagerInstace == nil then 
			return
		end
		local curMapID = self.mapDataManagerInstace:GetCurMapID()
		local childMapList = self.mapDataManagerInstace:GetChildMapList(curMapID)
		for i = 1, #childMapList do 
			self.objBuildingList[i]:SetActive(true)
		end
		DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(self.comBuildingsLayoutRectTransform)
		self.comBuildingsLayout.enabled = false
		for i = 1, #self.objBuildingList do 
			self.objBuildingList[i]:SetActive(false)
		end
		for i = 1, #self.objBuildingList do 
			coroutine.yield(wait)
			if i <= #childMapList then 
				self.objBuildingList[i]:SetActive(true)
				Twn_MoveY(nil,self.objBuildingList[i],-235,-550,1)
			end
		end
		coroutine.yield(CS.UnityEngine.WaitForSeconds(2))
		self.comBuildingsLayout.enabled = true
		self.isOpenAnim = false
		self.adv_loot_Root:SetActive(true)
		DisplayActionEnd()
	end)
end

function CityUI:OtherPanelOpeningAnimation(navigationUI,topTitleUI,cityRoleListUI)
	self:ReOpenWindow()
	local navigationUI = DisplayActionManager:GetInstance():ShowNavigation()
	if navigationUI then 
		Twn_MoveY(nil, navigationUI._gameObject.transform, 0, 120, 1)
	end
	local topTitleUI = DisplayActionManager:GetInstance():ShowToptitle()
	if topTitleUI then 
		Twn_MoveY(nil, topTitleUI._gameObject.transform, 0, -80, 1)
	end
	OpenWindowImmediately("CityRoleListUI")
	OpenWindowImmediately("TaskTipsUI")
end

function CityUI:NormalOpenCityAnimation()
	local twnSequence = DRCSRef.DOTween.Sequence()

	--OpenWindowImmediately("BigMapCloudAnimUI", true)
	twnSequence:AppendCallback(function()
		for i = 1, #self.objBuildingList do 
			local cityBuildUI = self.cityBuildingUIList[i]
			cityBuildUI:BuildingShowAnimation(self.objBuildingList[i])
		end
	end)
end

function CityUI:PlayRoleEscapeAnim(mapID, roleID, animName, isLoop, needRecover)
	DisplayActionEnd()
end

-- 分析所有底部站人插槽
function CityUI:GenTransPlayerNodes(objRoot)
	if not objRoot then
		return
	end
	local ret = {}
	local transRoot = objRoot:GetComponent("Transform")
	local iCount = transRoot.childCount
	local transChild = nil
	local comSlot = nil
	for index = 0, iCount - 1 do
		transChild = transRoot:GetChild(index)
		comSlot = transChild:GetComponent("PlayerSpineItemSlot")
		if comSlot then 
			ret[#ret + 1] = {
				['transObj'] = transChild,
				['obj'] = transChild.gameObject,
				['bSpotOn'] = (comSlot.bSpotOn == true),
				['bIsFlip'] = (comSlot.bIsFlip == true),
				['v3ParentScale'] = transChild.localScale,
			}
		end
	end
	return ret
end

-- 将底部站人全部归还给对象池
function CityUI:ReturnAllStandPlayers()
	if (not self.akPlayerSpineItems) or (#self.akPlayerSpineItems <= 0) then
		return
	end
	LuaClassFactory:GetInstance():ReturnAllUIClass(self.akPlayerSpineItems)
    self.akPlayerSpineItems = {}
end

-- 创建一个底部站人
function CityUI:CreateStandPlayer(kData)
	if not kData then
		return
	end
	local kBindData = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.PlayerSpineItemUI, kData.transObj, kData)
	kBindData:RefreshUI(kData)
	self.akPlayerSpineItems[#self.akPlayerSpineItems + 1] = kBindData
	return kBindData
end

-- 显示城市底部站人
function CityUI:DisplayStandPlayers(akDatas)
	self:ReturnAllStandPlayers()
	if (not akDatas) or (not self.akTransPlayerNodes) 
	or (not self.iMaxStandPlayerNum) or (self.iMaxStandPlayerNum <= 0) then
		return
	end
	local TBPetData = TableDataManager:GetInstance():GetTable("Pet")
	local kDBRoleModel = TableDataManager:GetInstance():GetTable("RoleModel")
	for index, kSlotData in ipairs(self.akTransPlayerNodes) do
		if akDatas[index] and (index <= self.iMaxStandPlayerNum) then
			kSlotData.obj:SetActive(true)

			local tempPetData = TBPetData[akDatas[index].dwPetID];
			local artID = tempPetData and tempPetData.ArtID or 0;

			kSlotData.kPetModelData = kDBRoleModel[artID]
			kSlotData.kTarModelData = kDBRoleModel[akDatas[index].dwModelID]
			local strName = akDatas[index].acPlayerName
			if akDatas[index].bUnlockHouse == 0 then
				strName = STR_ACCOUNT_DEFAULT_PREFIX .. tostring(akDatas[index].dwPlayerID or 0)
			end
			if (not strName) or (strName == "") then
				strName = STR_ACCOUNT_DEFAULT_NAME
			end
			kSlotData.acPlayerName = strName
			kSlotData.defPlyID = akDatas[index].dwPlayerID
			kSlotData.IsME = (kSlotData.defPlyID == RoleDataManager:GetInstance():GetMainRoleID())
			self:CreateStandPlayer(kSlotData)
		else
			kSlotData.obj:SetActive(false)
		end
	end
end

-- 设置自动请求剧本站立玩家数据标记
function CityUI:SetAutoRequestStandPlayersFlag(bOn)
	self.bAutoRequestStandPlayers = (bOn == true)
end

-- 获取自动请求剧本站立玩家数据标记
function CityUI:GetAutoRequestStandPlayersFlag()
	return (self.bAutoRequestStandPlayers == true)
end

-- 请求当前剧本的站立玩家数据
function CityUI:RequestStandPlayers()
	-- 为了避免频繁请求, 给一个五秒的CD
	if self.mapDataManagerInstace:IsRequestStandPlayersInCD() == true then
		-- 如果想要发起请求时处于cd时间, 那么设置一个标记, 等到cd结束后自动刷新一次
		self:SetAutoRequestStandPlayersFlag(true)
		return
	end
	-- 开启冷却
	self.mapDataManagerInstace:SetRequestStandPlayersCD(true)
	-- 添加计时器
	globalTimer:AddTimer(5000, function()
		if self.mapDataManagerInstace == nil then 
			return
		end
		self.mapDataManagerInstace:SetRequestStandPlayersCD(false)
		local win = GetUIWindow("CityUI")
		if not win then
			return
		end
		if not IsWindowOpen("CityUI") then
			win:SetAutoRequestStandPlayersFlag(false)
			return
		end
		if win:GetAutoRequestStandPlayersFlag() == true then
			win:SetAutoRequestStandPlayersFlag(false)
			win:RequestStandPlayers()
		end
	end)
	-- 发起请求
	SendRequestPlayerInSameScript()
end

-- 判断并请求当前剧本的站立玩家
function CityUI:JungAndReqStanPlayersByMapID(iMapTypeID)
	if not iMapTypeID then
		return
	end
	-- 剧本判断
	-- 暂时只有宇文庄剧本不需要显示站人, 如果之后有特别的需求, 可以把这里抽成剧本配置
	local iCurScriptID = GetCurScriptID()
	if iCurScriptID and (iCurScriptID == 1) then
		return
	end
	-- 地图判断
	local kMapTypeData = self.mapDataManagerInstace:GetMapData(iMapTypeID)
	self.iMaxStandPlayerNum = 0
	if kMapTypeData then
		self.iMaxStandPlayerNum = kMapTypeData.PasserCount or 0
	end
	if self.iMaxStandPlayerNum > 0 then
		self:RequestStandPlayers()
	else
		-- 传空以隐藏所有站立玩家
		self:DisplayStandPlayers()
	end
end

function CityUI:PlayBuildingRoleAnim(mapID, roleBaseID, animName)
	for _, cityBuildingUI in ipairs(self.cityBuildingUIList) do 
		if cityBuildingUI:IsMap(mapID) then 
			return cityBuildingUI:PlayRoleAnim(roleBaseID, animName)
		end
	end
	return 0
end

return CityUI
