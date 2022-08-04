TileBigMap = class("TileBigMap",BaseWindow)
local TDM = require("UI/TileMap/TileDataManager")

function ToTileID(x, y)
	if x < 0 then x = 1000 - x end
	if y < 0 then y = 1000 - y end
	return x * 10000 + y
end

function ToXY(cellID)
	cellID = cellID & 0xfffffff
	x = cellID // 10000
	y = cellID - x * 10000	
	if x > 1000 then x = 1000 - x end
	if y > 1000 then y = 1000 - y end
	return x, y
end

local CloudWidth = {
	[1] = 1200,
	[2] = 1500,
	[3] = 1400,
	[4] = 1000,
	[5] = 1000,
	[6] = 1400
}

local CloudSpeed = {
	[4] = 2,
	[5] = 3,
	[6] = 4
}

local MAX_CLOUD_NUM = 4

local cellSize = 64 * 1.2
function TileBigMap:Create()
	local obj = LoadPrefabAndInit("TileMap/TileBigMap",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

local FRAME_TIME = 40
local FRAME_WHOLE_TIME = FRAME_TIME * 25
local MOVE_TIME = 200

local sx = 129
local sy = 101
local sz = 1.28

local vx = 12
local vy = 8
function TileBigMap:Init()
	self.comFocusChecker =self._gameObject:GetComponent("FocusChecker")
	self.comFocusChecker:SetOnApplicationFocusAction(function(focus)
		-- 窗口失焦时，重置点击相关的状态
		if focus == false then
			self.isClickMap = false
			self.sendClick = false
			WindowsManager:GetInstance().bTouch = false
		end
	end)
	self.iTipsTime = 0
	self.wait = 0
	self.last_key = 0
	self.repeat_time = 0
	self.objMap = self:FindChild(self._gameObject, "bigmap")
	self.comEventTriggerTileBigMap =self._gameObject:GetComponent("EventTrigger")
	self.init_pos = nil
	local entry = DRCSRef.EventTrigger.Entry()
	entry = DRCSRef.EventTrigger.Entry()
	entry.eventID = DRCSRef.EventTriggerType.PointerDown
	entry.callback:AddListener(function(eventData)
		if eventData.button == DRCSRef.EventSystems.PointerEventData.InputButton.Right then return end
		self.isClickMap = true
	end)
	self.comEventTriggerTileBigMap.triggers:Add(entry)
	entry = DRCSRef.EventTrigger.Entry()
	entry.eventID = DRCSRef.EventTriggerType.PointerUp
	entry.callback:AddListener(function(eventData)
		if eventData.button == DRCSRef.EventSystems.PointerEventData.InputButton.Right then return end
		self.isClickMap = false
		self.sendClick = true
	end)
	self.comEventTriggerTileBigMap.triggers:Add(entry)	
	self.pd = 'down/x'


	local comMap = self.objMap:FindChildComponent("Tilemap", "Tilemap")
	local tagMap = self.objMap:FindChildComponent("tag", "Tilemap")
    self.objP = self:FindChild(self._gameObject, "p")
	self.spriteP = self.objP:GetComponent("SpriteRenderer")
    self.eventRoot = self:FindChild(self._gameObject, "event").transform
	self.map = {}
	self.map[1] = self:FindChild(self.objMap, "b1")
	self.map[1]:GetComponent("SpriteRenderer").sprite = GetSprite("Tileview/img000010")
	self.sprite_cache = {}
	
	-- 云彩大小排序263154，分为3层
	-- 初始化时随机生成几个，之后的云必须生成于【屏幕外】,同屏幕4朵
	self.cloud = {}
	self.cloudObj = self:FindChild(self._gameObject, "clouds")
	self.cloud[1] = {}
	self.cloud[1].obj = self:FindChild(self._gameObject, "cloud1")
	self.cloud[1].type = 1
	self.cloud[1].speed = 2
	-- for i=1,2 do
	-- 	local random = math.random(1, 6)
	-- 	local x,y = math.random(-640,640), math.random(-240,240)
	-- 	local layer = math.random(4,6)
	-- 	if not self.cloud[i] then
	-- 		self.cloud[i] = {}
	-- 		self.cloud[i].obj = CloneObj(self.cloud[1].obj, self.cloudObj)
	-- 	end
	-- 	local sr = self.cloud[i].obj:GetComponent("SpriteRenderer")
	-- 	sr.sprite = GetSprite("Cloud/yun_0"..random)
	-- 	self.cloud[i].obj.transform.localPosition = DRCSRef.Vec3(x, y, 0)
	-- 	sr.sortingOrder = layer
	-- 	self.cloud[i].speed = CloudSpeed[layer]
	-- 	self.cloud[i].type = random
	-- end

	self:UpdateCity()
	self.frameTime = 0
	self.vx = 0
	self.vy = 0
	self.x  = 0
	self.y  = 0
	self.mvTime = 0
	self.ofx = 0
	self.ofy = 0
	self.px = 0
	self.py = 0
	--self.__forceUpdate = 1

	self.objAnimation = self._gameObject:GetComponent(DRCSRef_Type.Animation)

	self.objEffect = self:FindChild(self.objMap, "PointEffect")
end

function TileBigMap:RefreshUI(info)
end

function TileBigMap:OnEnable()
					
	OpenWindowImmediately("BigMapCloudAnimUI", true)
	self.objAnimation:DR_Play("map_scale")

	RemoveWindowImmediately("CityUI", true)
	RemoveWindowImmediately("MazeUI")
	--self:ResetRectTransform()
	
	OpenWindowImmediately("TaskTipsUI")
	OpenWindowImmediately("CityRoleListUI")
	OpenWindowImmediately("MiniMapUI")
	DisplayActionManager:GetInstance():ShowToptitle(TOPTITLE_TYPE.TT_BIGMAP)
	DisplayActionManager:GetInstance():ShowNavigation()
	
	TDM:GetInstance().ev_dirty = true	
	self.bg_dirty = true	
	self.wait_event = nil
	self.click_tile = nil
	CityDataManager:GetInstance():UpdateCityWeatherEffect()

	self.comTileMap = self.objMap:FindChildComponent("Tilemap", "Tilemap")

	local comMap = self.objMap:FindChildComponent("Tilemap", "Tilemap")
	local tagMap = self.objMap:FindChildComponent("tag", "Tilemap")
	TDM:GetInstance():LoadFromComponent(comMap, tagMap, GetCurScriptID())
	TileFindPathManager:GetInstance():InitMapData(comMap, GetCurScriptID())
end

function TileBigMap:InitPos()
	local mainRoleInfo = globalDataPool:getData("MainRoleInfo")
    if mainRoleInfo and mainRoleInfo["MainRole"] then 
		local cityID = mainRoleInfo["MainRole"][MRIT_CUR_CITY]
		if true then --cityID & 0x10000000 ~= 0
			self.init_pos = cityID
			self.x, self.y = ToXY(cityID)
			self:SetPos(self.x, self.y, "now", 0, 0)
			return true
		end
	end
end

function TileBigMap:OnDisable()
	RemoveWindowBar('TileBigMap')
	--DisplayActionManager:GetInstance():HideToptitle()
	--DisplayActionManager:GetInstance():HideNavigation()
	RemoveWindowImmediately("TaskTipsUI", true)
	RemoveWindowImmediately("CityRoleListUI")
	RemoveWindowImmediately("MiniMapUI", true)
	TDM:GetInstance().ev_dirty = true
	TDM:GetInstance().need_init = nil
	self.objEffect:SetActive(false)
	self.akNode = {}
	self.bStartMove = false	
end

function TileBigMap:SetPos(px, py, now, t1, t2)
	local tdm = TDM:GetInstance()
	tdm:SetCurCity(px, py)
	if now then
		self.server_pos = ToTileID(px, py)
		if t1 > 0 then
			self.vx = (px - self.x) / t1
			self.vy = (py - self.y) / t1

			self.mvTime = 0
			self.server_mvTime = t1 
			self.server_stayTime = self.server_mvTime + t2
			if t2 > 0 then
				self.objP:SetActive(false)
			end
		else
			self.x = px
			self.y = py
			self.vx = 0
			self.vy = 0
			self.mvTime = MOVE_TIME
			
			self.spriteP.sprite = GetSprite("TilePlayer/down/x_00001")
			self.spriteP.flipX = false
			self:SetPlayerPos(self.x, self.y)
		end
	else
		self.vx = (px - self.x) / MOVE_TIME
		self.vy = (py - self.y) / MOVE_TIME
		self.mvTime = 0
	
		self.pd = 'down/x'
		self.flip = false
		if self.last_key == 'w' then
			self.pd = 'up/s'
		elseif self.last_key == 'a' then
			self.pd = 'left/z'
		elseif self.last_key == 'd' then
			self.pd = 'left/z'
			self.flip = true
		end
	end
	
	--self.x = px
	--self.y = py
	local win = GetUIWindow("CityRoleListUI")
	if win then
		win.bNeedUpdate = true
		win.bNeedRefill = true
	end
	CityDataManager:GetInstance():UpdateCityWeatherEffect()
	--self:SetPlayerPos(px, py)

	local toptitleUI = GetUIWindow('ToptitleUI')
	if toptitleUI ~= nil and toptitleUI:IsOpen() then 
		toptitleUI:RefreshUIImmediately()
	end
	--derror(x, y, tf.localPosition.x, tf.localPosition.y )

	local miniMap = GetUIWindow('MiniMapUI')
	if miniMap then
		miniMap:SetActorPos(px,py)
	end
end

function TileBigMap:UpdateCity()
	local tdm = TDM:GetInstance()
	local TB_City = TableDataManager:GetInstance():GetTable("City")
	for k,v in pairs(TB_City) do
		--self.p2City[ToTileID(v.BigmapPosX, v.BigmapPosY)] = v
		if tdm:InCurScript(v) then		
			local sp = CloneObj(self.eventRoot:GetChild(0).gameObject, self.objMap)
			sp = sp:GetComponent("SpriteRenderer")
			sp.sortingOrder = -3
			sp.gameObject:SetActive(true)
			sp.gameObject.transform.localPosition = DRCSRef.Vec3(v.BigmapPosX * 1.28, v.BigmapPosY * 1.28, 0)	
			local textMesh = sp.gameObject:FindChildComponent("text", "TextMesh")
			local face_bg = sp.gameObject:FindChild("role")
			local face = face_bg:FindChildComponent("face", "SpriteRenderer")
			face_bg:SetActive(false)
			
			sp.sprite = GetSprite("TileEvent/"..v.TileImage)
			textMesh.text = GetLanguageByID(v.NameID)
		end
	end
end

function TileBigMap:SetPlayerPos(px, py)	
	local tf = self.objMap.transform
	tf.localPosition = DRCSRef.Vec3( cellSize * (-px - 0.5), cellSize * (-py - 0.5),  0)
	self.bg_dirty = true
	self.ev_x = self.ev_x or 10000
	self.ev_y = self.ev_y or 10000
	if math.abs(px - self.ev_x) > 1 or math.abs(py - self.ev_y) > 1 then
		TDM:GetInstance().ev_dirty = true
	end
end

local funcType={
	FuncType.MoveUp,
	FuncType.MoveDown,
	FuncType.MoveLeft,
	FuncType.MoveRight
}
local clickAreaConvert = {up=1,down=2,left=3,right=4}
local keys = {'w', 's', 'a', 'd'}
local mv = {0,1, 0,-1, -1,0 ,1,0}

function TileBigMap:GetDirFind(x, y ,x1, y1)
	if x < x1 then
		return keys[4]
	elseif x > x1 then
		return keys[3]
	elseif y < y1 then
		return keys[1]
	elseif y > y1 then
		return keys[2]
	end
end

function TileBigMap:Update(deltaTime)	
	if self.init_pos == nil then
		if not self:InitPos() then
			return
		end
	end
	local tdm = TDM:GetInstance()
	tdm:CheckCache()
	self:UpdatePlayer(deltaTime)
	self:UpdateCloud(deltaTime)
	if tdm.ev_dirty then
		self:UpdateEvents()
		tdm.ev_dirty = nil
	end
	if self.bg_dirty or self.cam_dirty then
		self:UpdateBG()
		self.bg_dirty = nil
	end
	if self.server_mvTime or self.cam_dirty then
		return
	end
	local bStop = false
	if CS.UnityEngine.Input.GetMouseButtonDown(0) then
		local dir = self:CheckClickScreenDir()	
		if dir and GetConfig('confg_Move') == 2 then
			bStop = true
		end
	end
	if KeyboardManager:GetInstance().MoveUpInvalidCondition() then
		self.isClickMap = false
		self.sendClick = false
		self.objEffect:SetActive(false)
		self.akNode = {}
		self.bStartMove = false
		return 
	end
	if (self.wait_event or self.wait > 0 or self.mvTime < MOVE_TIME) and not bStop then		
		self.wait = self.wait - 1
		return
	end
	if IsInDialog() then
		return
	end
	local x = tdm.x
	local y = tdm.y
	local last_tid = ToTileID(x, y)
	local d
	local keyPressed = false
	local bAllowPressed = false
	local info = globalDataPool:getData("GameData") or {}
    local curState = info['eCurState']
    if curState == GS_BIGMAP then     
        bAllowPressed = true
    end
	for k = 1, 4 do
		if GetKeyByFuncType(funcType[k]) and bAllowPressed then
			x = x + mv[2 * k - 1]
			y = y + mv[2 * k]
			d = keys[k]
			keyPressed = true
			break			
		end
	end
	if not keyPressed then
		local dir = self:CheckClickScreenDir()	
		if dir and GetConfig('confg_Move') == 2 then
			self.akNode = {}
			self.akNode = TileFindPathManager:GetInstance():AStarFind(x, y, dir.x, dir.y)
			if not next(self.akNode or {}) and self.sendClick then
				self.sendClick = false
				local evs = tdm:QueryEvents(x, y)
				self:SendEventReq(evs)
			end
		elseif dir then
			if dir == "midle" and self.sendClick then
				self.sendClick = false
				local evs = tdm:QueryEvents(x, y)
				self:SendEventReq(evs)
			elseif dir ~= "midle" then
				local k  = clickAreaConvert[dir]
				x = x + mv[2 * k - 1]
				y = y + mv[2 * k]
				d = keys[k]
			end
		end
	end
	if next(self.akNode or {}) then
		if self.akNode[1] and not self.bStartMove then
			self.bStartMove = true
			d = self:GetDirFind(x, y, self.akNode[1].x, self.akNode[1].y)
			x = self.akNode[1].x
			y = self.akNode[1].y
			table.remove(self.akNode, 1)
		end
	else
		self.objEffect:SetActive(false)
	end
	if d then
		self.last_key = d
		local tid = ToTileID(x, y)
		if  tdm:CanPass(tid) then
			--derror('setpos'..tid.." waiting:"..(self.wait_event or 'nil'))
			self.mvTime = 0
			--self.wait = 1000
			self:SetPos(x, y)
			
			if tdm:QueryNewEvents(last_tid, tid) or (tdm.p2City[last_tid] == nil and tdm.p2City[tid]) then				
				self.wait_event = tid
			end
		elseif self.wait <= 0 then
			self.wait = 6
			self.iTipsTime = self.iTipsTime == 0 and 120 or 0
		end
		--
	else
		self.last_key = 0
		self.repeat_time = 0
	end
	if self.iTipsTime > 0 then
		if self.iTipsTime == 120 then
			SystemUICall:GetInstance():Toast('前有障碍，无法移动', false)
		end
		self.iTipsTime = self.iTipsTime -1 <= 0 and 0 or self.iTipsTime -1
	end
end

function TileBigMap:OpenCityAnimation(func_Complete)
	self.wait_event = 0
	self.akNode = {}
	self.bStartMove = false
	self.objEffect:SetActive(false)
	MyDOTween(self._gameObject.transform,'DOScale',DRCSRef.Vec3(1.3, 1.3, 1),0.4)
	self:AddTimer(350, function()
		if func_Complete then
			func_Complete()
		end
	end)
	OpenWindowImmediately("BigMapCloudAnimUI", false)
end

function TileBigMap:SendEventReq(evs, mv)
	local RM = RoleDataManager:GetInstance()
	local role_ev = 'none'
	local tdm = TDM:GetInstance()
	for _, v in pairs(evs) do
		local pid, pos, role, evType, tag, ex, task = table.unpack(v)
		if role == 0 and evType ~= 15 then
			SendClickMap(CMT_TILE, pid, task)
		else
			if evType == 1 then
				-- local RM = RoleDataManager:GetInstance()
				-- RM:TryInteract(RM:GetRoleID(role), pid, 0, 0, 0, 0, 0 ,0)
				if role_ev == 'none' then
					role_ev = 'wait'
				end
			else
				if role_ev ~= 'send' then
					SendClickNpcCMD(pid, RM:GetRoleID(role), 0, 0, 0, 0)
					role_ev = 'send'
				end
			end
		end
		if ev == 5 then -- maze 5 city -1
			MyDOTween(self._gameObject.transform,'DOScale',DRCSRef.Vec3(1.3, 1.3, 1),0.35)
			OpenWindowImmediately("BigMapCloudAnimUI", true)
		end

		if evType == 15 then
			self:OpenClanBranch(task, tag, pos, pid)
		end
	end

	if role_ev == 'wait' then
		for _, v in pairs(evs) do
			local pid, pos, role, evType, tag, ex, task = table.unpack(v)
			if role ~= 0 and evType == 1 then
				RM:TryInteract(RM:GetRoleID(role), pid & 0x200000ff, 0, 0, 0, 0, 0 ,0)
				break
			end
		end
	end

	local tid = ToTileID(tdm.x, tdm.y)
	if mv then
		SendClickMap(CMT_TILE, tid)
	end

	local city = tdm.p2City[tid]
	if city and (city ~= tdm.p2City[self.server_pos] or mv == nil) then
		return SendClickMap(CMT_CITY, city.BaseID)
	end
end

function TileBigMap:UpdateEvents()
	local count = self.eventRoot.childCount
	for i = 1, count do		
		local ev = self.eventRoot:GetChild(i - 1).gameObject
		ev:SetActive(false)
		self.sprite_cache[i] = ev:GetComponent("SpriteRenderer")
	end
	local tdm = TDM:GetInstance()
	local ex = vx + 4
	local ey = vy + 4

	local pos = self._gameObject.transform.localPosition
	local wx = -math.floor(pos.x / 76.8)
	local wy = -math.floor(pos.y / 76.8)
	
    local evs = tdm:QueryEvents(tdm.x + wx - ex,tdm.y + wy - ey , ex * 2,  ey * 2)	
    for _, v in pairs(evs) do
		local pid, pos, role, evType, tag, ex, task, icon = table.unpack(v)
        local x, y = ToXY(pos)
		if evType then
			local sp = self:GetSprite()
			self:SetEventSprite(sp, pid, role, evType, x, y, tag, ex, task, icon)
		end
	end
end

local function calc_img(px, py)
	
	local imgx = (px + sx) // 16
	local imgy = (-py + sy) // 16
	return imgx, imgy
end
function TileBigMap:UpdateBG()
	for k = 1, #self.map do
		self.map[k]:SetActive(false)
	end
	local pos = self._gameObject.transform.localPosition
	local wx = self.x - math.floor(pos.x / 76.8)
	local wy = self.y - math.floor(pos.y / 76.8)
	local x1,x2, y1 ,y2 = -vx + wx, vx + wx, -vy + wy, vy + wy
	x1, y1 = calc_img(x1, y1)
	x2, y2 = calc_img(x2, y2)
	for y = y2, y1 do
		for x = x1, x2 do
			local map = self:GetMap()
			map:SetActive(true)
			map.transform.localPosition = DRCSRef.Vec3((x * 16 - sx) * sz, (-y * 16 + sy)* sz, 0)
			local name = string.format("Tileview/img%03d%03d",x, y)
			map:GetComponent("SpriteRenderer").sprite = GetSprite(name)
		end
	end
end

function TileBigMap:GetSprite()
	local last = #self.sprite_cache
	local ret
	if last > 0 then
		ret = self.sprite_cache[last]
		self.sprite_cache[last] = nil
	else
		ret = CloneObj(self.eventRoot:GetChild(0).gameObject, self.eventRoot.gameObject)
		ret = ret:GetComponent("SpriteRenderer")
	end
	return ret
end
function TileBigMap:GetMap()
	local last = #self.map
	local ret = self.map[last]
	if ret.activeSelf then
		ret = CloneObj(self.map[1],self.objMap)
		self.map[last + 1] = ret
	else
		for k = 1, last do
			ret = self.map[k]
			if not ret.activeSelf then
				return ret
			end
		end
	end
	return ret
end

function TileBigMap:SetEventSprite(sp, pid, role, evType, x, y, tag, ex, task, icon)
	if role == 0 and evType == 0 then
		sp.gameObject:SetActive(false)
		return
	end
	sp.gameObject:SetActive(true)
	sp.gameObject.transform.localPosition = DRCSRef.Vec3(x * 1.28, y * 1.28, 0)	
	local textMesh = sp.gameObject:FindChildComponent("text", "TextMesh")
	local face_bg = sp.gameObject:FindChild("role")
	local face = face_bg:FindChildComponent("face", "SpriteRenderer")	
	local comMark = face_bg:FindChildComponent("task", "SpriteRenderer")
	face_bg:SetActive(false)
	if role ~= 0 then

		local max_weight_info = TaskDataManager:GetInstance():CheckRoleMark(nil, pid, nil, nil, role)	
		
		face_bg:SetActive(true)
		sp.sprite = nil
		local RM = RoleDataManager:GetInstance()
		local artData = RM:GetRoleArtDataByTypeID(role)
		face.sprite = GetSprite(artData.Head)		
		textMesh.text = RM:GetRoleNameByTypeID(role)
		comMark.gameObject:SetActive(false)
		if max_weight_info and max_weight_info.state then
			-- derror(string.format("p:%d,%d role %d task:%d state:%s",x, y, role, task, max_weight_info.state))
			local markSprite = GetAtlasSprite("CommonAtlas", max_weight_info.state)
			if (markSprite ~= nil) then
				comMark.gameObject:SetActive(true)
				comMark.sprite = markSprite				
			end
		end
		return
	end
	if icon == 0 then
		icon = evType
	end
	sp.sprite = GetSprite("TileEvent/ev"..icon)
	if textMesh then
		textMesh.text = GetLanguageByID(tag, task)
	end
end

function TileBigMap:MapMove(src, dest, p1, p2, p3)	
	local p2 = p2 / 2 
	local commonConfig = TableDataManager:GetInstance():GetTable("CommonConfig")[1]
	local edm = EvolutionDataManager:GetInstance()
	edm.rivakeTime = edm.rivakeTime + (p1 or 0)
	
	dest = dest & 0xfffffff	
	if dest == self.wait_event then
		self.wait_event = nil
		--derror('wait nil')
		self.wait = 13
	end
	if dest == self.click_tile then
		self.click_tile = nil
	else
		if p2 > 0 and (src & 0xfffffff) ~= dest then
			local x, y = ToXY(src)
			self:SetPos(x, y, 'now', 0, 0)
		end
		local x, y = ToXY(dest)
		self:SetPos(x, y, 'now', p2, p3)
		self.wait_event = nil
		self.wait = 13
		self.click_tile = nil
		self:Update(0)
	end
	--derror(dest .. '-----------')
end

function TileBigMap:CameraMove(x, y, time, mode)
	x = tonumber(x)
	y = tonumber(y)
	time = tonumber(time)
	mode = tonumber(mode)
	local srcpos =  DRCSRef.Vec3(-self.ofx * 76.8, -self.ofy * 76.8, 0)
	local tdm = TDM:GetInstance()	
	self.ofx = x
	self.ofy = y
	if mode == 1 then
		self.ofx = x - self.x 
		self.ofy = y - self.y
	end
	--derror("x:"..x .. " y:"..y .. "time:".. time)
	local tarpos =  DRCSRef.Vec3(-self.ofx * 76.8, -self.ofy * 76.8, 0)
	if time <= 0 then
		self._gameObject.transform.localPosition = tarpos
		tdm.ev_dirty = true
		self.bg_dirty = true
	else
		self.cam_dirty = true
		self._gameObject.transform.localPosition = srcpos
		MyDOTween(self._gameObject.transform,'DOLocalMove',tarpos, time / 1000)
		self:AddTimer(time, function()
			self.cam_dirty = false
		end)
	end
	
end

function TileBigMap:GetCanDirty()
	return self.cam_dirty or self.wait > 0
end

function TileBigMap:UpdatePlayer(deltaTime)
	local tdm = TDM:GetInstance()
	self.mvTime = self.mvTime + deltaTime
	if self.server_mvTime then
		if self.mvTime < self.server_mvTime then
			
			self.x = self.x + self.vx * deltaTime
			self.y = self.y + self.vy * deltaTime
			self:SetPlayerPos(self.x, self.y)
		else
			self.x = tdm.x
			self.y = tdm.y
			self:SetPlayerPos(self.x, self.y)
			self.objP:SetActive(true)
		end
		if self.mvTime > self.server_stayTime then
			self.server_stayTime = nil
			self.server_mvTime = nil
			self.mvTime = MOVE_TIME
			DisplayUpdateScene(true)
			
			DisplayActionEnd()
		end
		return
	end
	if self.mvTime > MOVE_TIME then
		--self.wait = 0
		if self.x ~= tdm.x or self.y ~= tdm.y then
			self.x = tdm.x
			self.y = tdm.y
			self:SetPlayerPos(self.x, self.y)
			self.bStartMove = false
		end
		if self.mvTime > (MOVE_TIME * 2) then
			if self.pd == 'left/z' then
				self.spriteP.sprite = GetSprite('TilePlayer/idle')
			end
		end

		local tid = ToTileID(tdm.x, tdm.y)
		--derror(self.server_pos.."   --  ".. tid.. "  ==  ")
		if self.server_pos ~= tid then
			if self.click_tile == nil then
				local evs = {}
				tdm:QueryNewEvents(self.server_pos, tid, evs)
				self.click_tile = tid
				self:SendEventReq(evs, 'move')
				self.server_pos = tid
			end
		end
	else
		self.frameTime = self.frameTime + deltaTime
		self.frameTime = self.frameTime % FRAME_WHOLE_TIME
		local fr = self.frameTime // FRAME_TIME + 1
		if fr > 25 then fr = 25 end

		local name = string.format("TilePlayer/%s_%05d",self.pd, fr)
		self.spriteP.sprite = GetSprite(name)
		self.spriteP.flipX = self.flip
	
		self.x = self.x + self.vx * deltaTime
		self.y = self.y + self.vy * deltaTime
		self:SetPlayerPos(self.x, self.y)
	end
end

-- 随机生成屏幕外云彩的层级，类型，位置等(MaxX=360,Miny=640)
function TileBigMap:GenNewCloud()
	if self.cloud[1] then
		local layer = math.random(4,6)
		local speed = math.random() + math.random(2,5)
		local type = math.random(1,6)
		if type == self.cloud[#self.cloud].type then
			type = math.random(1,6)
		end
		local x,y = 0,0
		local dir = math.random(1,4)
		if dir == 1 then -- 上
			y = math.random(500,600)	
			x = math.random(-640,640)
		elseif dir == 2 then -- 下
			y = math.random(-600,-500)	
			x = math.random(-640,640)
		elseif dir == 3 then -- 左
			y = math.random(-360,360)	
			x = math.random(-CloudWidth[type] - 100,-CloudWidth[type])
		elseif dir == 4 then -- 右
			y = math.random(-360,360)	
			x = math.random(CloudWidth[type],CloudWidth[type] + 100)
		end
		local obj = CloneObj(self.cloud[1].obj, self.cloudObj)
		obj.name = "cloud"..(#self.cloud + 1)
		local sr = obj:GetComponent("SpriteRenderer")
		sr.sprite = GetSprite("Cloud/yun_0"..type)
		obj.transform.localPosition = DRCSRef.Vec3(x, y, 0)
		sr.sortingOrder = layer
		return {obj = obj, speed = speed, type = type}		
	end
	return nil
end

function TileBigMap:UpdateCloud(deltaTime)
	-- 删除
	for i=#self.cloud,1,-1 do
		local pos = self.cloud[i].obj.transform.localPosition
		if (pos.x > (CloudWidth[self.cloud[i].type] + 100) or pos.x < (-CloudWidth[self.cloud[i].type] - 100) or pos.y > 600 or pos.y < -600) then
			DRCSRef.ObjDestroy(self.cloud[i].obj)
			self.cloud[i] = {}
			table.remove(self.cloud, i)
		end
	end

	-- 增加
	if #self.cloud < MAX_CLOUD_NUM then
		for i=1,MAX_CLOUD_NUM - #self.cloud do
			table.insert(self.cloud, self:GenNewCloud())
		end
	end

	-- 更新位置
	local dx, dy = 0,0
	if self.px ~= self.x or self.py ~= self.y then
		local ddx, ddy = self.px - self.x, self.py - self.y
		if ddx > 0 then
			dx = math.ceil(self.px-self.x)
		else
			dx = math.floor(self.px-self.x)
		end
		if ddy > 0 then
			dy = math.ceil(self.py-self.y)
		else
			dy = math.floor(self.py-self.y)
		end
	end
	for i=1,#self.cloud do
		local pos = self.cloud[i].obj.transform.localPosition
		local speed = self.cloud[i].speed
		local staticSpeed = 10
		self.cloud[i].obj.transform.localPosition = DRCSRef.Vec3(pos.x + speed + dx * staticSpeed, pos.y + dy*staticSpeed, 0)
	end
	self.px = self.x
	self.py = self.y
end

function TileBigMap:OpenClanBranch(uiClanTypeID, name, pos, pid)
    local clanBaseData = TableDataManager:GetInstance():GetTableData("ClanBranch", uiClanTypeID)
	local RM = RoleDataManager:GetInstance()
	local mapID = MapDataManager:GetInstance():GetCurMapID()
	local info = ClanDataManager:GetInstance():GetClanBranchData(uiClanTypeID)
	RM:EnterInteractState(RM:GetRoleID(clanBaseData.Master), mapID, 0, 0, 0, 0, 0 ,0, uiClanTypeID)
    if clanBaseData then
		local dialogChoiceUI = GetUIWindow('SelectUI')
		if dialogChoiceUI then
			local trunkClanName = TableDataManager:GetInstance():GetTableData("Clan", clanBaseData.Trunk).ClanName
			local str = "我是"..trunkClanName.."分舵"..GetLanguageByID(name).."的掌门人，找我有什么事情？"
			dialogChoiceUI:GetDialogChoiceUI():UpdateDialogue(str, true, clanBaseData.Master)
		end
    end
end

function TileBigMap:OnDestroy()
	self.map = {}
	self.sprite_cache = {}
	for i=#self.cloud,1,-1 do
		DRCSRef.ObjDestroy(self.cloud[i].obj)
		self.cloud[i] = {}
		table.remove(self.cloud, i)
	end
	self.cloud = {}
end
local l_GetButtonUp= CS.UnityEngine.Input.GetButtonUp
local l_GetButtonDown = CS.UnityEngine.Input.GetButtonDown
local l_GetButton = CS.UnityEngine.Input.GetButton

function TileBigMap:CheckClickScreenDir()
	if self.isClickMap then
		local mousePos = CS.UnityEngine.Input.mousePosition
		local dir = nil
		if GetConfig('confg_Move') == 2 then
			local worldPos = GetTouchWorldUIPos() *5
			dir = self.comTileMap:WorldToCell(worldPos)
			local comTile = self.comTileMap:GetTile(DRCSRef.Vec3Int(dir.x,dir.y,0))
			if comTile and comTile.name == 'notpass' then
				if self.tipTime == nil then
					self.tipTime = self:AddTimer(200, function()
						SystemUICall:GetInstance():Toast('前有障碍，无法移动', false)
						local TileBigMap = GetUIWindow("TileBigMap")
						if TileBigMap then
							TileBigMap:RemoveTimer(TileBigMap.tipTime)
							TileBigMap.tipTime = nil
						end				
					end)
				end
                return nil
			else
				if self.objEffect then
					self.objEffect.transform.position = self.comTileMap:CellToWorld(DRCSRef.Vec3Int(dir.x,dir.y,0)) + DRCSRef.Vec3(2,2,0)
					self.objEffect:SetActive(true)
				end
			end
		else
			dir = self:GetDir(mousePos.x,mousePos.y)
		end
		return dir
	end
	return nil
end

local clickArea = {
	"down",
	"right",
	"left",
	"up",
}
-- 屏幕中间正方形点击区域边长的一半
local sideLen = 50
-- 根据分辨率动态计算
local centerX = DRCSRef.Screen.width / 2
local centerY = DRCSRef.Screen.height / 2
local ratio = DRCSRef.Screen.height/DRCSRef.Screen.width
function TileBigMap:GetDir(x,y)

	-- 屏幕中间区域
	if x < centerX+sideLen and y < centerY+sideLen 
	and x > centerX-sideLen and y < centerY+sideLen 
	and x < centerX+sideLen and y > centerY-sideLen 
	and x > centerX-sideLen and y > centerY-sideLen then
		return "midle"
	end
	-- 屏幕四个方向
	local i = ratio*x < y and 1 or 0
	local j = -ratio*x + DRCSRef.Screen.height < y and 1 or 0
	return clickArea[i*2+j+1]
end

return TileBigMap