TileDataManager = class('TileDataManager')
TileDataManager._instance = nil

local CITY_W = 2
local CITY_H = 1

local CELL_BIT2 = 0x20000000
function TileDataManager:GetInstance()
    if TileDataManager._instance == nil then
        TileDataManager._instance = TileDataManager.new()
        TileDataManager._instance:Init()
    end

    return TileDataManager._instance
end

function TileDataManager:Init()
    self.events = {}
	self.cityCache = {}
    self.x = 0
    self.y = 0
end

local RW, RH = 10, 10
local function ToIndex(x, y)
    return (y + 100) * 100 + (x + 100)
end
function TileDataManager:getEventTab(x, y, create)
    local idx =  ToIndex((x // RW), (y // RH))
    local tab = self.events[idx]
    if tab == nil and create then
        tab = {}
        self.events[idx] = tab
    end
    return tab
end

function TileDataManager:InCurScript(city)
	local t = city.ScriptID
	local c = GetCurScriptID()
	if t then
		for i = 1,#t do
			if t[i] == c then
				return true
			end
		end
		return false
	end
	return true
end

local minX, maxX, minY, maxY = -120, 75, -72, 80
function TileDataManager:LoadFromComponent(base, tag, scriptID)
    if self.scriptID == scriptID then
        return
    else
        self.city = {}
        self.cityCell = {}
        self.p2City = {}
        self.aiPid = {}
        self.tileCity = nil
    end
    self.scriptID = scriptID
    local tileCity = self.tileCity
	if tileCity == nil then
		tileCity = {}
        self.tileCity = tileCity
		local TB_City = TableDataManager:GetInstance():GetTable("City")
		for k,v in pairs(TB_City) do
            if self:InCurScript(v) then
                tileCity[v.TileID] = v
                self.cityCell[v.BaseID] = {}
                for x = 0, CITY_W do
                    for y = 0, CITY_H do
                        self.p2City[ToTileID(v.BigmapPosX + x, v.BigmapPosY + y)] = v
                    end
                end
            end
		end
	end

    local tildID, t
    self.pass = {}
    for x = minX, maxX do
        for y = minY, maxY do
            t = base:GetTile(DRCSRef.Vec3Int(x,y,0))
            tileID = ToTileID(x,y)
            if t and t.name ~= 'notpass' then
                self.pass[tileID] = 1
                
                t = tag:GetTile(DRCSRef.Vec3Int(x,y,0))
                if t then
                    local ct = tileCity[tonumber(string.sub(t.name, 2))]
                    self.city[tileID] = ct
                    if not self.p2City[tileID] then
                        table.insert(self.cityCell[ct.BaseID], tileID)
                    end
                end
            end

        end
    end
end

function TileDataManager:CheckCache()    
    if self.cityCache then
        if RoleDataManager:GetInstance():GetScriptCreateTime() == 0 then
            return
        end
        for k= 1,#self.cityCache do
            local v = self.cityCache[k]
            self:AddTileEvent(table.unpack(v))
        end
        self.cityCache = nil
    end
end
function TileDataManager:CanPass(id)
    return self.pass[id] == 1
end

function TileDataManager:SetCurCity(x, y)
    self.x = x
    self.y = y
end

function TileDataManager:GetCurCity(id)
    if self.city then
        id = id or ToTileID(self.x, self.y)
        return self.city[id]
    end
end

function TileDataManager:GetCurClan()
    local ev = self:getEventTab(self.x, self.y)
    if ev then
        for k,v in pairs(ev) do
            if v[4] == 15 then -- type
                return v[7]    -- task
            end
        end
    end
    return 0
end

function TileDataManager:CalcPos(pos, role)
    if self.cityCell == nil then
        return
    end
    local cityData = TableDataManager:GetInstance():GetTableData("City", pos & 0xff)
    if cityData == nil then
        derror("failed find city ".. (pos & 0xff))
        return
    end
    
    local cityID = cityData.TileID
    local t = self.cityCell[cityID]
    if t == nil or #t == 0 then
        derror("failed find city cell ".. cityID)
        return 
    end

    local num = pos
    if role ~= 0 then
        local tm = RoleDataManager:GetInstance():GetScriptCreateTime()
        -- derror(tostring(tm) .. 'xxxxx-' .. tostring(role))
        num = role * tm
    end
    -- local idx = num % (#t)
    -- return t[idx + 1]
    local newpos
    for i = 0, #t - 1 do
        local idx = (num  + i) % (#t)
        newpos = t[idx + 1]
        local nx, ny = ToXY(newpos)
        local et = self:QueryEvents(nx, ny, 0, 0)
        if next(et) then
            for k, v in pairs(et) do
                if role > 0 and v[3] == role then
                    return newpos
                end
            end
        else
            if self:QueryScreenEvents(nx, ny, 0, 0, pos& 0xff) then
                return newpos
            end
        end
    end

end

function TileDataManager:findEmptyTile()

end

function TileDataManager:eventKey(pid, role, type, task)
    if (pid & 0x20000000) ~= 0 then
        if role == 0 then
            return pid | ((type | 0x80000000 )<< 32)
        else
            return pid | (role << 32)
        end
    else
        if task then
            return pid | (task << 32)
        else
            if role > 0 then
                pid = pid & 0xfffffff
                local role = RoleDataManager:GetInstance():GetRoleTypeID(role)
                if self.aiPid[pid] and self.aiPid[pid][role] then
                    return  self.aiPid[pid][role] | (role << 32)
                end
            end
        end
    end
end
-- 根据随机种子计算神秘商人位置 待设计算法
function TileDataManager:CalcMysteryShopPos(cityID,seed, pos)
    if self.cityCell == nil then
        return
    end
    local t = self.cityCell[cityID]
    if t == nil or #t == 0 then
        derror("failed find city cell ".. cityID)
        return 
    end

    local num = seed

    local tm = RoleDataManager:GetInstance():GetScriptCreateTime()
    num = num + tm

    local idx = num % (#t)
    local newpos
    for i = 0, #t - 1 do
        local idx = (num  + i) % (#t)
        newpos = t[idx + 1]
        local nx, ny = ToXY(newpos)
        local et = self:QueryEvents(nx, ny, 0, 0)
        if next(et) then
            for k, v in pairs(et) do
                if v[2] == pos  then
                    return newpos
                end
            end
        else
            if self:QueryScreenEvents(nx, ny, 0, 0,cityID) then
                return newpos
            end
        end
    end 
end

function TileDataManager:AddTileEvent(role, pos, type, tag, ex, task, icon)
    local bAllowOverlap = false
    if self.event_script ~= GetCurScriptID() then
        self:ClearEvents()
        self.cityCache = {}
        self.event_script = GetCurScriptID()
    end
    local pid = pos
    if (pos & 0x40000000) ~= 0 then
        local cityID,seed = self:DecodeData2CityIdSeed(pos)
        local newpos = self:CalcMysteryShopPos(cityID,seed, pos)
        if newpos == nil then
            if role == 1000114001 or role == 1000114002 then
                self.cityCache = self.cityCache or {}
                table.insert(self.cityCache, {role, pos, type, tag, ex, task, icon})
            end
            return nil
        end
        pos = newpos
        type = type == 15 and 15 or 1
    elseif (pos & 0x20000000) ~= 0 then
        local tm = RoleDataManager:GetInstance():GetScriptCreateTime()
        if self.scriptID == GetCurScriptID() and tm ~= 0 then
            local newpos = self:CalcPos(pos, role)
            if newpos == nil then
                return
            end
            -- derror("pos ----- ".. string.format("%x", pos).. "::" .. tostring(role) .. "====".. newpos)
            -- self.cityEvent[newpos] = pos
            pos = newpos
        else            
            self.cityCache = self.cityCache or {}
            table.insert(self.cityCache, {role, pos, type, tag, ex, task, icon})
            return
        end
        -- derror( (pos & 0xfffffff) .. '--'.. role .. ':'.. task)
    else
        bAllowOverlap = true
    end
    pos = pos & 0xfffffff
    local x1, y1 = ToXY(pos)
    local w = (ex // 10)
    local x2 = x1 + w
    local y2 = y1 + (ex - w * 10)
    local ev_info = {pid, pos, role, type, tag, ex, task, icon, bAllowOverlap}
    local evkey = self:eventKey(pid, role, type, task)
    local x1 = x1 // RW
    local x2 = x2 // RW
    local y1 = y1 // RH
    local y2 = y2 // RH
    --derror(string.format('evkey:%x pos:%x role:%d type:%d task:%d x:%d,%d y:%d,%d',evkey, pos, role, type, task, x1, x2, y1, y2))
    for x = x1 ,x2 do
        for y = y1 , y2 do
            local idx =  ToIndex(x, y)
            local et = self.events[idx] or {}
            self.events[idx] = et
            if et[evkey]  then
                --et[evkey].ref = et[evkey].ref + 1
                if bAllowOverlap then
                    et[evkey] = ev_info
                end
            else
                --derror(string.format('find duplicate event reg! key:%x  idx:%x val:%x', evkey, idx, et[evkey][2]))
                et[evkey] = ev_info
            end
            if role > 0 then
                self.aiPid[pos] = self.aiPid[pos] or {}
                self.aiPid[pos][role] = evkey
            end
        end
    end
    self.ev_dirty = true
    return true
end
function TileDataManager:RemoveTileEvent(pos, role, type, tag, ex, task)
    local pid = pos
    ex = ex or 0
    local evKey = self:eventKey(pid, role, type, task)
    for k,et in pairs(self.events) do
        et[evKey] = nil
    end
    if self.cityCache then
        for i = #self.cityCache, 1,-1 do
            local value = self.cityCache[i]
            if value[1] == role and value[2] == pos and value[6] == task then
               table.remove(self.cityCache, i)
            end
        end
    end
    self.ev_dirty = true
end
function TileDataManager:ClearEvents()
    self.events = {}
    self.cityCell = {}
    self.aiPid = {}
    self.scriptID = 0
    self.ev_dirty = true
end

function TileDataManager:ContainPos(ev, x, y, _x, _y)
    local pid, pos, role, type, tag, ex = table.unpack(ev)    
    local x1, y1 = ToXY(pos)
    if _x < x1 then return false end
    if _y < y1 then return false end
    local w = (ex // 10)
    local x2 = x1 + w
    if x > x2 then return false end
    local y2 = y1 + (ex - w * 10)
    if y > y2 then return false end
    return true
end

function TileDataManager:QueryScreenEvents(x, y, w, h, cityID)
    local ret = {}
    w = w or 0
    h = h or 0
    local x1 = (x) // RW
    local x2 = (x + w) // RW
    local y1 = (y) // RH
    local y2 = (y + h) // RH
    local cityData = TableDataManager:GetInstance():GetTableData("City", cityID)
    local cityX = cityData.BigmapPosX
    local cityY = cityData.BigmapPosY
    for _x = x1, x2 do
        for _y = y1, y2 do
            local idx =  ToIndex(_x, _y)
            local tab = self.events[idx]
            if tab then
                for k, v in pairs(tab) do
                    if self:ContainNewPos(v, x, y, x + w, y + h) or self:ContainCityPos(x, y, cityX, cityY) then
                        return false
                    end
                end
            end
        end
    end
    return true
end

function TileDataManager:ContainNewPos(ev, x, y, _x, _y)
    local pid, pos, role, type, tag, ex = table.unpack(ev)    
    local x1, y1 = ToXY(pos)
    local w = (ex // 10)
    if math.abs(x1 - _x) <= w then
        return true
    end
    if math.abs(y1 - _y) <= ex - w * 10 then
        return true
    end
    return false
end

function TileDataManager:ContainCityPos(x, y, _x, _y)
    if math.abs(x - _x) <= 1 then
        return true
    end
    if math.abs(y - _y) <= 1 then
        return true
    end
    return false
end

function TileDataManager:QueryEvents(x, y, w, h, check_exist)
    local ret
    if check_exist == nil then
        ret = {}
    end
    w = w or 0
    h = h or 0
    local x1 = (x) // RW
    local x2 = (x + w) // RW
    local y1 = (y) // RH
    local y2 = (y + h) // RH
    for _x = x1, x2 do
        for _y = y1, y2 do
            local idx =  ToIndex(_x, _y)
            local tab = self.events[idx]
            if tab then
                for k, v in pairs(tab) do
                    if self:ContainPos(v, x, y, x + w, y + h) then
                        if check_exist then return true end
                        ret[v] = v
                    end
                end
            end
        end
    end
    return ret
end

function TileDataManager:QueryNewEvents(opos, npos, evs)
    local ox, oy = ToXY(opos)
    local nt = self:QueryEvents(ToXY(npos))
    for _,v in pairs(nt) do
        if not self:ContainPos(v, ox, oy, ox, oy) then            
            if evs then
                evs[v] = v
            else
                return true
            end
        end
    end
end

function TileDataManager:HasRole(role)
    local roleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(role)
    local evs = self:QueryEvents(self.x, self.y)
    for key, value in pairs(evs) do
        local _, pos, role, evType, tag, ex, task = table.unpack(value)
        if roleBaseID == role then
            return true
        end
    end
end

function TileDataManager:DecodeData2CityIdSeed(data)
    local uiCityID = data & 0xff
    local iSeed = (data & 0xff00) >> 8
    return uiCityID,iSeed
end


return TileDataManager