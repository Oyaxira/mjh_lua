MiniMapUI = class("MiniMapUI",BaseWindow)
local TDM = require("UI/TileMap/TileDataManager")

local vx = 10
local vy = 10
local sx = 130
local sy = 101
local sz = 9
local ez = 9
local width = 144
function MiniMapUI:Create()
    local obj = LoadPrefabAndInit("MiniMap/MiniMapUI",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function MiniMapUI:Init()
    self.pos_Text = self:FindChildComponent(self._gameObject, "PosText", "Text")
    self.bigMap = GetUIWindow('TileBigMap')
    self.unfold_btn = self:FindChildComponent(self._gameObject, "map", DRCSRef_Type.Button)
    self.objMap = self:FindChild(self._gameObject, "maps").transform
    self.objEvent = self:FindChild(self._gameObject, "events").transform
    self.objCity = self:FindChild(self._gameObject, "citys").transform

    self.map = {}
    self.map[1] = {}
	self.map[1].obj = self.objMap:GetChild(0).gameObject
	self.map[1].img = self.map[1].obj:GetComponent("Image")
    self.map[1].img.sprite = GetSprite("Tileview/img000010")
    self.event = {}
    self.city = {}

    self.midX = 0   -- 真实中心点坐标
    self.midY = 0
    self.midXX = 0  -- 虚假的中心点坐标
    self.midYY = 0

    if self.map then
        self.mapTrans = DRCSRef.FindGameObj("TileBigMap"):GetComponent("RectTransform")
    end

    if self.unfold_btn then
        self:AddButtonClickListener(self.unfold_btn,function()
            local tileMap = GetUIWindow("TileBigMap")
            if tileMap and tileMap:IsOpen() and tileMap:GetCanDirty() == true then
                return 
            end
            OpenWindowImmediately("MapUnfoldUI")
		end)
    end
    self:InitCity()
end

function MiniMapUI:SetActorPos(x,y)
    self.pos_Text.text = x..","..y
end

function MiniMapUI:RefreshUI()

end

function MiniMapUI:OnEnable()
    -- 初始化时设置一次
    if self.bigMap then
        self:SetActorPos(self.bigMap.x,self.bigMap.y)
        self.midX = self.bigMap.x
        self.midY = self.bigMap.y
        self:UpdateMap()
        self:UpdateEvent()
    end
end

function MiniMapUI:Update()
    local x,y = self.bigMap.x,self.bigMap.y  
    if x ~= self.midX or y ~= self.midY then
        self.midX = self.bigMap.x
        self.midY = self.bigMap.y        
        self:UpdateMap()
        self:UpdateEvent()
        self:UpdateCity()
    end
end

function MiniMapUI:CalImg(px,py)
    local imgx = (px + sx) // 16
	local imgy = (-py + sy) // 16
	return imgx, imgy
end

function MiniMapUI:GetMidPos(px,py)
    local x = px*16 - sx + 24
    local y = sy - py*16 - 24
    return x,y
end

function MiniMapUI:InitCity()
	local tdm = TDM:GetInstance()
	local TB_City = TableDataManager:GetInstance():GetTable("City")
	for k,v in pairs(TB_City) do
		if tdm:InCurScript(v) then
            local city = {}
            city.obj = CloneObj(self.objEvent:GetChild(0).gameObject, self.objCity)
            city.obj.name = v.NameID
            city.obj.transform.localPosition = DRCSRef.Vec3(v.BigmapPosX * ez, v.BigmapPosY * ez, 0)
            city.obj:SetActive(true)
            self.city[k] = city
		end
	end
end

function MiniMapUI:UpdateCity()
    local dx, dy = -self.midX*sz, -self.midY*sz
    local pos = self.objCity.transform.localPosition
    self.objCity.transform.localPosition = DRCSRef.Vec3(dx, dy, pos.z)
end

function MiniMapUI:GenNewMap()
    local last = #self.map
    local ret
	if last < 9 then
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

function MiniMapUI:UpdateMap()
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
    self.firstXX, self.firstYY = self.midXX - 24, self.midYY + 24
    local dx,dy = (self.midXX - self.midX)*sz, (self.midYY - self.midY) * sz
    for  y=y2,y2+2 do
        for x=x1,x1+2 do
            local map = self:GenNewMap()
            map.obj.transform.localPosition = DRCSRef.Vec3(((x-x1-1) * 16) * sz + dx, (-(y-y2-1) * 16)* sz + dy, 0)
            local name = string.format("Tileview/img%03d%03d",x, y)
            map.img.sprite = GetSprite(name) or GetSprite("Tileview/img000010")
            map.obj:SetActive(true)
        end
    end
end

function MiniMapUI:UpdateEvent()
    local count = self.objEvent.childCount
    for i=1,count do
        local ev = self.objEvent:GetChild(i - 1).gameObject
		ev:SetActive(false)
		self.event[i] = ev:GetComponent("Image")
    end
    local tdm = TDM:GetInstance()
    local dx, dy = -self.midX*sz, -self.midY*sz
    local evs = tdm:QueryEvents(self.firstXX, self.firstYY - 47, 47, 47)
    for _, v in pairs(evs) do
		local _, pos, role, evType, tag, ex, task = table.unpack(v)
        local x, y = ToXY(pos)
        if evType then
            local last = #self.event
            local ev = nil
            if last > 0 then
                ev = self.event[last]
                self.event[last] = nil
            else
                ev = CloneObj(self.objEvent:GetChild(0).gameObject, self.objEvent.gameObject)
                ev = ev:GetComponent("Image")
            end
            ev.gameObject.transform.localPosition = DRCSRef.Vec3(x*ez, y*ez, 0)
            ev.gameObject:SetActive(true)
        end
    end
    self.objEvent.transform.localPosition = DRCSRef.Vec3(dx, dy, 0)
end

function MiniMapUI:OnDisable()
end

function MiniMapUI:OnDestroy()
end

return MiniMapUI