MapUnfoldUI = class("MapUnfoldUI",BaseWindow)
local BigMapCityUI = require 'UI/BigMapUI/BigMapCityUI'
local TDM = require("UI/TileMap/TileDataManager")

local vx = 40
local vy = 25
local sx = 130
local sy = 101
local sz = 0.375
local ez = 22.5
local width = 6
local slowSpeed = -0.1
local itemID = 805004 -- 飞飞符ID

local SIZE_STATE = {
    MIN = 1,
    MAX = 2
}

-- 事件对应图标 可增加
-- 地址 Assets\Resources\UI\UISprite\BigmapUI
local IMGRES = {
    [1] = "ui_mainmap_ts_04",
    [2] = "ui_mainmap_ts_04",
    [3] = "ui_mainmap_ts_04",
    [4] = "ui_mainmap_ts_05",
    [5] = "ui_mainmap_ts_01",
    [6] = "ui_mainmap_ts_01",
    [7] = "ui_mainmap_ts_02",
    [8] = "ui_mainmap_ts_02",
    [9] = "ui_mainmap_ts_06",
    [10] = "ui_mainmap_ts_06",
    [11] = "ui_mainmap_ts_06",
    [12] = "ui_mainmap_ts_00",
    [13] = "ui_mainmap_ts_01",
    [14] = "ui_mainmap_ts_00",
    [15] = "ui_mainmap_ts_06",
    [200] = "ui_mainmap_ts_07", -- npc
    [300] = "ui_mainmap_ts_08", --  玩家
}

-- 事件对应大小 可增加
local ITEMSIZE = {
    [1] = {20, 20},
    [2] = {20, 20},
    [3] = {20, 20},
    [4] = {20, 20},
    [5] = {20, 20},
    [6] = {20, 20},
    [7] = {20, 20},
    [8] = {20, 20},
    [9] = {20, 20},
    [10] = {20, 20},
    [11] = {20, 20},
    [12] = {20, 20},
    [13] = {20, 20},
    [14] = {20, 20},
    [15] = {20, 20},
    [100] = {96, 72}, -- city
    [200] = {25, 25}, -- npc
    [300] = {30, 30}, -- 玩家
}

function MapUnfoldUI:Create()
    local obj = LoadPrefabAndInit("MiniMap/MapUnfoldUI",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function MapUnfoldUI:ClearCityObj()
	local childCount = self.cityBox.transform.childCount
	for i = 1, childCount do 
		local objCity = self.cityBox.transform:GetChild(i - 1)
		objCity.gameObject:SetActive(false)
	end
end

--获取城市obj
function MapUnfoldUI:GetAvailableCityObj()
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

function MapUnfoldUI:Init()
    self.BigMapCityUI = BigMapCityUI.new()
    self.close_btn = self:FindChildComponent(self._gameObject, "Btn_exit", DRCSRef_Type.Button)
    self.bigMap = GetUIWindow('TileBigMap')
    self.rootMap = self:FindChild(self._gameObject, "bigmap")
    self.objEvent = self:FindChild(self._gameObject, "events").transform
    self.objCity = self:FindChild(self._gameObject, "citys").transform
    self.objMap = self:FindChild(self._gameObject, "maps").transform
    self.flyBg = self:FindChildComponent(self._gameObject, "fly", DRCSRef_Type.Button)
    self.flyIcon = self:FindChildComponent(self._gameObject, "fly/icon", DRCSRef_Type.Button)
    self.flyNum = self:FindChildComponent(self._gameObject, "fly/num", "Text")
    self.objMaxPack = self:FindChild(self._gameObject, "Pack")
    self.objMinPack = self:FindChild(self._gameObject, "MinPack")
    self.cityBox = self:FindChild(self.objMinPack, "map/citys")
    self.comSizeButton = self:FindChildComponent(self._gameObject, "newFrame/SizeButton", DRCSRef_Type.Button)
    self.comSizeText = self:FindChildComponent(self.comSizeButton.gameObject, "Text", DRCSRef_Type.Text)
    self.objRoleIcon = self:FindChild(self.objMinPack, "map/Role/ev")
    if self.comSizeButton then
        self:RemoveButtonClickListener(self.comSizeButton)
        self:AddButtonClickListener(self.comSizeButton, function()
            self:OnClickChangeSize()
        end)
    end

	self.map = {}
    
    self.map[1] = {}
	self.map[1].obj = self.objMap:GetChild(0).gameObject
	self.map[1].img = self.map[1].obj:GetComponent("Image")
    self.map[1].img.sprite = GetSprite("Tileview/img000010")
    self.city = {}
    self.event = {}

    self.midX = 0   -- 真实中心点坐标
    self.midY = 0
    self.midXX = 0  -- 虚假的中心点坐标
    self.midYY = 0
    self.onDrag = false
    self.onPress = false
    self.prePos = nil
    self.transfer = false -- 传送
    self.slow = false
    self.slowTimeX = 0
    self.slowTimeY = 0

    if self.close_btn then
        self:AddButtonClickListener(self.close_btn,function()
            RemoveWindowImmediately("MapUnfoldUI",false)
		end)        
    end
    local fun = function()
        local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemID)
		if kItemTypeData then
			local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, kItemTypeData)
			OpenWindowImmediately("TipsPopUI", tips)
		end
    end
    if self.flyBg then
        self:AddButtonClickListener(self.flyBg,function()
            fun()
		end)  
    end
    if self.flyIcon then
        self:AddButtonClickListener(self.flyIcon,function()
            fun()
		end)  
    end

    -- 初始化
    if self.bigMap then
        self.midX = self.bigMap.x
        self.midY = self.bigMap.y
        local tag = TaskTagManager:GetInstance():GetTaskTagValueByTypeID(120016) or 0
        self.transfer = tag == 1
        self.gameStart = (TaskTagManager:GetInstance():GetTaskTagValueByTypeID(120017) or 0) == 1
        local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
        self.cost = math.ceil((commonConfig.CityTransferCost or 200) / 100)
    end
    self:RefreshItem()
    self.ObjWeather = self:FindChild(self.objMinPack, "map/Weather")
    self.objWeatherMap = {}
end

function MapUnfoldUI:OnPressESCKey()
    if self.close_btn then
        self.close_btn.onClick:Invoke()
    end
end

function MapUnfoldUI:OnEnable()
    HideAllHUD()
    if self.bigMap then
        self.bigMap.wait_event = 1
    end
    self.bg_dirty = true
    self:InitCity()

    -- 动态计算拖动的检测范围
    local width,height = DRCSRef.Screen.width*0.04,DRCSRef.Screen.height*0.09
    self.minX = width
    self.maxX = DRCSRef.Screen.width - width
    self.minY = height
    self.maxY = DRCSRef.Screen.height - height
    self.moveS = width * 0.16
    self.speedX = 0
    self.speedY = 0
end

function MapUnfoldUI:RefreshUI(info)
    local iCurSizeState = GetConfig("MapUnfoldState")
    iCurSizeState = tonumber(iCurSizeState)
    if iCurSizeState == SIZE_STATE.MAX then
        self.iCurSizeState = SIZE_STATE.MAX
        self.comSizeText.text = "缩小"
    else
        self.iCurSizeState = SIZE_STATE.MIN
        self.comSizeText.text = "放大"
        self:UpdateMinCity()
    end
    self.objMaxPack:SetActive(self.iCurSizeState == SIZE_STATE.MAX)
    self.objMinPack:SetActive(self.iCurSizeState == SIZE_STATE.MIN)
end

function MapUnfoldUI:Update(deltaTime)
    local tdm = TDM:GetInstance()
    if self.bg_dirty then
        self:UpdateMap()
        self:UpdateCity()
        self:UpdateEvent()
        self.bg_dirty = nil
    end

    -- 检测鼠标行为
    if CS.UnityEngine.Input:GetMouseButtonDown(0) and not self.onPress then
        local pos = CS.UnityEngine.Input.mousePosition
        self.prePos = CS.UnityEngine.Input.mousePosition
        if pos.x > self.minX and pos.x < self.maxX and pos.y > self.minY and pos.y < self.maxY then
            self.onPress = true
            self.onDrag = false
            return
        end
    end
    if self.onPress and CS.UnityEngine.Input:GetMouseButton(0) then
        local pos = CS.UnityEngine.Input.mousePosition
        local vec = {x = self.prePos.x-pos.x, y = self.prePos.y-pos.y}
        local dis = math.sqrt(vec.x*vec.x + vec.y*vec.y)
        self.speedX = 0
        self.speedY = 0
        if dis > 5 and self.prePos ~= pos then
            self.onDrag = true
            local dx, dy = self.prePos.x - pos.x, self.prePos.y - pos.y
            self.speedX = dx*sz/self.moveS
            self.speedY = dy*sz/self.moveS
            self.midX = self.midX + self.speedX
            self.midY = self.midY + self.speedY
            if self.midX > 55 then self.midX = 55 end
            if self.midX < -90 then self.midX = -90 end
            if self.midY > 88 then self.midY = 88 end
            if self.midY < -70 then self.midY = -70 end
            self.prePos = pos
            self.bg_dirty = true
        end
    end
    if CS.UnityEngine.Input:GetMouseButtonUp(0) and self.onPress then
        self.onDrag = false
        self.onPress = false
        --self.slow = true
        self.slowTimeX = (math.abs(self.speedX) / -slowSpeed)*deltaTime
        self.slowTimeY = (math.abs(self.speedY) / -slowSpeed)*deltaTime
        if self.slowTimeX > 500 then self.slowTimeX = 500 end
        if self.slowTimeY > 500 then self.slowTimeY = 500 end
    end
    -- 缓动
    if self.slow and self.speedX ~= 0 and self.speedY ~= 0 then
        self.slowTimeX = self.slowTimeX - deltaTime
        self.slowTimeY = self.slowTimeY - deltaTime
        if self.slowTimeX < 300 and self.slowTimeY < 300 then
            self.slow = false
            return
        end
        if self.slowTimeX > 0 then
            self.speedX = self.speedX + slowSpeed
            self.midX = self.midX + self.speedX
        end
        if self.slowTimeY > 0 then
            self.speedY = self.speedY + slowSpeed
            self.midY = self.midY + self.speedY               
        end
        if self.midX > 55 then self.midX = 55 end
        if self.midX < -90 then self.midX = -90 end
        if self.midY > 88 then self.midY = 88 end
        if self.midY < -70 then self.midY = -70 end
        self.bg_dirty = true
    end

    if CS.UnityEngine.Input.GetAxis("Mouse ScrollWheel") > 0 then
        self:OnClickChangeSize(SIZE_STATE.MIN)
    elseif CS.UnityEngine.Input.GetAxis("Mouse ScrollWheel") < 0 then
        self:OnClickChangeSize(SIZE_STATE.MAX)
    end
end

-- 背景地图相关
function MapUnfoldUI:UpdateMap()
    for i=1,#self.map do
        self.map[i].obj:SetActive(false)
    end
    local pos = self._gameObject.transform.localPosition
    local wx = self.midX - math.floor(pos.x / 76.8)
    local wy = self.midY - math.floor(pos.y / 76.8)
    local x1,x2, y1 ,y2 = -vx + wx, vx + wx, -vy + wy, vy + wy
	x1, y1 = self:CalImg(x1, y1)
	x2, y2 = self:CalImg(x2, y2)
    self.midXX, self.midYY = self:GetMidPos(x1, y2)
    self.firstXX, self.firstYY = self.midXX - 48, self.midYY + 32
    local dx,dy = (self.midXX - self.midX)*sz, (self.midYY - self.midY) * sz
    for  y=y2,y2+3 do
        for x=x1,x1+5 do
            local map = self:GenNewMap()
            map.obj.transform.localPosition = DRCSRef.Vec3(((x-x1-2) * 16) * sz - width/2 + dx, (-(y-y2-1) * 16)* sz + width/2 + dy, 0)
			local name = string.format("Tileview/img%03d%03d",x, y)
			map.img.sprite = GetSprite(name) or GetSprite("Tileview/img000010")
            map.obj.name = name
            map.obj:SetActive(true)
        end
    end
end

function MapUnfoldUI:CalImg(px,py)
    local imgx = (px + sx) // 16
	local imgy = (-py + sy) // 16
	return imgx, imgy
end

function MapUnfoldUI:GetMidPos(px,py)
    local x = px*16 - sx + 48
    local y = sy - py*16 - 32
    return x,y
end

function MapUnfoldUI:GenNewMap()
    local last = #self.map
    local ret
	if last < 24 then
        ret = {}
		ret.obj = CloneObj(self.map[1].obj,self.objMap)
        ret.img = ret.obj:GetComponent("Image")
		self.map[last + 1] = ret
	else
		for k = 1, last do
			ret = self.map[k]
			if not ret.obj.activeSelf then
				return ret
			end
		end
	end
	return ret
end

-- 城市相关和玩家
function MapUnfoldUI:InitCity()
	local tdm = TDM:GetInstance()
	local TB_City = TableDataManager:GetInstance():GetTable("City")
	for k,v in pairs(TB_City) do
		if tdm:InCurScript(v) then
            local city = {}
            city.obj = CloneObj(self.objCity:GetChild(0).gameObject, self.objCity)
            city.img = city.obj:GetComponent("Image")
            city.enter = self:FindChild(city.obj, "enter")
            city.enter_text = city.enter:FindChildComponent("Text", "Text")
            city.name = city.obj:FindChildComponent("titleText", "Text")                 	
            city.enter:SetActive(false)
            city.img.sprite = GetSprite("TileEvent/"..v.TileImage)
            city.name.text = GetLanguageByID(v.NameID)
            city.obj.name = v.NameID
            city.obj.transform.localPosition = DRCSRef.Vec3(v.BigmapPosX * ez, v.BigmapPosY * ez, 0)
            local rect = city.obj:GetComponent("RectTransform")
            rect.sizeDelta = DRCSRef.Vec2(ITEMSIZE[100][1], ITEMSIZE[100][2])
            city.obj:SetActive(true)
            city.enter_text.text = self.cost
            self.city[k] = city

            local uiaction = city.obj:GetComponent("LuaUIAction")
            if uiaction then
				uiaction:SetPointerEnterAction(function()
                    city.enter:SetActive(true)
				end)
				uiaction:SetPointerExitAction(function()
					city.enter:SetActive(false)
				end)
			end

            city.btn = city.obj:GetComponent(DRCSRef_Type.Button)
            if city.btn then
                self:AddButtonClickListener(city.btn,function()
                    if self.onDrag then
                        return
                    end
                    if self.gameStart then
                        SystemUICall:GetInstance():Toast("新手村结束后解锁据点快速移动功能", false)
                    elseif self.transfer then
                        local tdm = TDM:GetInstance()
                        local tid = ToTileID(v.BigmapPosX, v.BigmapPosY)
                        SendClickMap(CMT_QUICKCITY, tid)
                        local city = tdm.p2City[tid]
                        if city then
                            SendClickMap(CMT_CITY, city.BaseID)
                        end
                        RemoveWindowImmediately("MapUnfoldUI",false)
                    else
                        local itemData = nil
                        local total = 0
                        local itemPool = globalDataPool:getData("ItemPool") or {}
                        for k,v in pairs(itemPool) do
                            if v.uiTypeID == itemID and RoleDataManager:GetInstance():GetMainRoleID() == v.uiOwnerID then
                                itemData = v
                                total = total + (v.uiItemNum or 0)
                            end
                        end
                        if itemData and total > 0 then
                            -- 不确定这样做对不对哈，也许要调整
                            SendUseItemCMD(RoleDataManager:GetInstance():GetMainRoleID(), itemData.uiID, 1)
                            local tdm = TDM:GetInstance()
                            local tid = ToTileID(v.BigmapPosX, v.BigmapPosY)
                            SendClickMap(CMT_QUICKCITY, tid)
                            local city = tdm.p2City[tid]
                            if city then
                                SendClickMap(CMT_CITY, city.BaseID)
                            end
                            RemoveWindowImmediately("MapUnfoldUI",false)
                        else
                            SystemUICall:GetInstance():Toast("消耗飞马令或加入六扇门后可在据点间快速移动", false)
                        end
                    end
                end)        
            end
		end
	end

    -- 玩家
    local ev = nil
    ev = CloneObj(self.objEvent:GetChild(0).gameObject, self.objCity.gameObject)
    ev = ev:GetComponent("Image")
    ev.sprite = GetSprite("BigmapUI/"..IMGRES[300])
    local rect = ev.gameObject:GetComponent("RectTransform")
    rect.sizeDelta = DRCSRef.Vec2(ITEMSIZE[300][1], ITEMSIZE[300][2])
    ev.gameObject.transform.localPosition = DRCSRef.Vec3(self.midX*ez, self.midY*ez, 0)
    ev.gameObject.name = "player"
    ev.gameObject:SetActive(true)
end

function MapUnfoldUI:UpdateCity()
    local dx, dy = -self.midX*sz, -self.midY*sz
    local pos = self.objCity.transform.localPosition
    self.objCity.transform.localPosition = DRCSRef.Vec3(dx, dy, pos.z)
end

-- 事件相关
function MapUnfoldUI:UpdateEvent()
    local count = self.objEvent.childCount
    for i=1,count do
        local ev = self.objEvent:GetChild(i - 1).gameObject
		ev:SetActive(false)
		self.event[i] = ev:GetComponent("Image")
    end
    local tdm = TDM:GetInstance()
    local dx, dy = -self.midX*sz, -self.midY*sz
    local evs = tdm:QueryEvents(self.firstXX, self.firstYY - 47, 95, 63)
    for _, v in pairs(evs) do
		local _, pos, role, evType, tag, ex, task = table.unpack(v)
        local x, y = ToXY(pos)
        if IMGRES[evType] then
            local last = #self.event
            local ev = nil
            if last > 0 then
                ev = self.event[last]
                self.event[last] = nil
            else
                ev = CloneObj(self.objEvent:GetChild(0).gameObject, self.objEvent.gameObject)
                ev = ev:GetComponent("Image")
            end
            if role ~= 0 then
                evType = 200
            end
            ev.sprite = GetSprite("BigmapUI/"..IMGRES[evType])
            local rect = ev.gameObject:GetComponent("RectTransform")
            rect.sizeDelta = DRCSRef.Vec2(ITEMSIZE[evType][1], ITEMSIZE[evType][2])
            ev.gameObject.transform.localPosition = DRCSRef.Vec3(x*ez, y*ez, 0)
            ev.gameObject:SetActive(true)
        end
    end
    self.objEvent.transform.localPosition = DRCSRef.Vec3(dx, dy, 0)
end

function MapUnfoldUI:RefreshItem()
    local total = 0
    local itemPool = globalDataPool:getData("ItemPool") or {}
    for k,v in pairs(itemPool) do
        if v.uiTypeID == itemID and RoleDataManager:GetInstance():GetMainRoleID() == v.uiOwnerID then
            total = total + (v.uiItemNum or 0)
        end
    end
    self.flyNum.text =  total
end

function MapUnfoldUI:OnDisable()
    ShowAllHUD()
    if self.bigMap then
        self.bigMap.wait_event = nil
    end
end

function MapUnfoldUI:OnClickChangeSize(iSize)
    if iSize and iSize ==self.iCurSizeState then
        return 
    end
    self.iCurSizeState = self.iCurSizeState == SIZE_STATE.MAX and SIZE_STATE.MIN or SIZE_STATE.MAX
    if self.iCurSizeState == SIZE_STATE.MAX then
        self.comSizeText.text = "缩小"
    else
        self.comSizeText.text = "放大"
        self:UpdateMinCity()
    end
    self.objMaxPack:SetActive(self.iCurSizeState == SIZE_STATE.MAX)
    self.objMinPack:SetActive(self.iCurSizeState == SIZE_STATE.MIN)
    SetConfig("MapUnfoldState", self.iCurSizeState, true)
end

function MapUnfoldUI:UpdateMinCity()
    self:ClearCityObj()
	self.cityObjMap = {}
    local TB_City = TableDataManager:GetInstance():GetTable("City")
	local cityDataMgr = CityDataManager:GetInstance()
   
	for cityID, cityTypeData in pairs(TB_City) do 
		if cityDataMgr:IsCityInCurScript(cityID) then 
            local cityData = cityDataMgr:GetCityData(cityID)
			local objCity = self:GetAvailableCityObj()
			objCity.name = 'city' .. tostring(cityID)
			self.cityObjMap[cityID] = objCity
			objCity:SetActive(true)
            local fun = function()
                if self.gameStart then
                    SystemUICall:GetInstance():Toast("新手村结束后解锁据点快速移动功能", false)
                elseif self.transfer then
                    local tdm = TDM:GetInstance()
                    local tid = ToTileID(cityData.BigmapPosX, cityData.BigmapPosY)
                    SendClickMap(CMT_QUICKCITY, tid)
                    local city = tdm.p2City[tid]
                    if city then
                        SendClickMap(CMT_CITY, city.BaseID)
                    end
                    RemoveWindowImmediately("MapUnfoldUI",false)
                else
                    local itemData = nil
                    local total = 0
                    local itemPool = globalDataPool:getData("ItemPool") or {}
                    for k,v in pairs(itemPool) do
                        if v.uiTypeID == itemID and RoleDataManager:GetInstance():GetMainRoleID() == v.uiOwnerID then
                            itemData = v
                            total = total + (v.uiItemNum or 0)
                        end
                    end
                    if itemData and total > 0 then
                        -- 不确定这样做对不对哈，也许要调整
                        SendUseItemCMD(RoleDataManager:GetInstance():GetMainRoleID(), itemData.uiID, 1)
                        local tdm = TDM:GetInstance()
                        local tid = ToTileID(cityData.BigmapPosX, cityData.BigmapPosY)
                        SendClickMap(CMT_QUICKCITY, tid)
                        local city = tdm.p2City[tid]
                        if city then
                            SendClickMap(CMT_CITY, city.BaseID)
                        end
                        RemoveWindowImmediately("MapUnfoldUI",false)
                    else
                        SystemUICall:GetInstance():Toast("消耗飞马令或加入六扇门后可在据点间快速移动", false)
                    end
                end
            end
            local cityTypeData = clone(cityTypeData)
            cityTypeData.BigmapPosX = 115 +  cityTypeData.BigmapPosX*9
            cityTypeData.BigmapPosY = -2 +  cityTypeData.BigmapPosY*3
			self.BigMapCityUI:UpdateCity(objCity, cityTypeData, fun)
            self:UpdateCityWeather(objCity, cityData,cityID)
		end 
	end
    local bigMap = GetUIWindow('TileBigMap')
    local iMapX = bigMap.x 
    local iMapY = bigMap.y
    iMapX = 115 + iMapX*9
    iMapY = -2 + iMapY*3
    self.objRoleIcon.transform.localPosition = DRCSRef.Vec3(iMapX, iMapY, 0)
end

-- 更新城市天气信息
function MapUnfoldUI:UpdateCityWeather(objCity, cityData,cityID)
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
            objWeather.transform.localScale = DRCSRef.Vec3(1,0.6,1)
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

function MapUnfoldUI:OnDestroy()
    self.BigMapCityUI:Close()
    self.map = {}
    self.city = {}
    self.event = {}
    self.prePos = nil
end

return MapUnfoldUI
