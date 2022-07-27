tInsert = table.insert
tRemove = table.remove
tConcat = table.concat
mfloor = math.floor
mFmod = math.fmod

--注意 这里的ms可能不是ms 取决于精度 例如 现在的其实代表 每33ms代表'1ms'
local table_size = {24,60,60,31}
local function TableInsert(t,value,num)
	for i=1,num do
		if value ==  nil then
			t[i] = {}
		else
			tInsert(t,value)
		end
		
	end
end

function ShowCountDown(sec)
	local iCostHour = mfloor(sec / 3600)
	local iCostMin = mfloor((sec % 3600) / 60)
	local iCostSec = mfloor(sec % 60)
	return string.format("%02u:%02u:%02u",iCostHour,iCostMin,iCostSec)
end

function ShowCountDownByMin(sec)
	local iCostMin = mfloor(sec/ 60)
	local iCostSec = mfloor(sec % 60)
	return string.format("%02u:%02u",iCostMin,iCostSec)
end

--{hour, min, sec, ms} to  ms
local function Time2MS(hour, min, sec, ms)
	return hour * 60 * 60 * 1000 + min * 60 * 1000 + sec * 1000 + ms * 33  ---33 = 1000 / 31
end

-- ms to {hour, min, sec, ms}
local function MS2Time(ms)
	local hour = mfloor(ms / 3600000) % 24 --mfloor(ms / (60 * 60 * 1000))
	local min = mfloor((ms % 3600000) / 60000)
	local sec =  mfloor((ms % 60000) / 1000) 
	local ms = mfloor((ms % 1000) / 33) ---33 = 1000 / 31
	return hour,min,sec,ms
end

--Timer = {_slots = nil, _cycle = nil}
Timer = class("Timer")

function Timer:ctor()
	self._slots = nil
	
	self._slots = {}
	self._slots[1] = {} --小时
	self._slots[2] = {} --分钟
	self._slots[3] = {} --秒
	self._slots[4] = {} --毫秒 
	self._timerIndex = 0
	self._deltaTime = 0
	TableInsert(self._slots[1], nil, table_size[1])
	TableInsert(self._slots[2], nil, table_size[2])
	TableInsert(self._slots[3], nil, table_size[3])
	TableInsert(self._slots[4], nil, table_size[4])
	self.aiDelTimer = {}
	self.iDelTimerCount = 0
	self.h1 = 0
	self.m1 = 0
	self.s1 = 0
	self.ms1 = 0
	self._cycle = 0
end

-- 时间 ms ,回调函数 , 次数,回调参数  返回计时器的索引
-- Tips: 在计时器相关接口的设计上, 有如下潜规则:
-- 	1. globalTimer:AddTimer中, 若传入的时间为0ms, 则callback在InsterTimer时立即执行
-- 	2. globalTimer:AddTimer中, 若传入的时间小于一帧时间(33ms), 经过MS2Time接口floor至0, 则callback在InsterTimer时立即执行
-- 以上规则导致Timer的行为不一致: 
-- 	1.若传入 delatT < deltaUpdate, 则先执行funcCallback再执行funcOther, 表现为同步
-- 	2.若传入 delatT >= deltaUpdate, 则先执行funcOther再执行funcCallback, 表现为异步
-- 该行为差异也许会导致某些顺序严格的逻辑执行错误
function Timer:AddTimer(delay,func,times,infoTable)
	if func == nil then
		if DEBUG_MODE then
			derror("AddTimer func is nil",debug.traceback())
		end
		return
	end

	if delay < 0 then
		delay = 0
	end
	
	if times == nil then
		times = 1
	end
	self._timerIndex = self._timerIndex + 1
	
	self:InsterTimer(delay,func,times,self._timerIndex,infoTable)
	return self._timerIndex
end

function Timer:RemoveTimer(index)
	if index == nil or index <= 0 then
		return
	end

	for i = 1, 4 do
		for j = 1,table_size[i] do
			for k = 1,#self._slots[i][j] do
				if self._slots[i][j][k].index == index then		
					local value = self._slots[i][j][k]
					value.del = true
					-- value = nil
					return
				end
			end
		end
	end
end

function Timer:RemoveTimerNextFrame(index)
	if index == nil or index <= 0 then
		return
	end
	self.iDelTimerCount = self.iDelTimerCount + 1
	self.aiDelTimer[self.iDelTimerCount] = index	
end

function Timer:RemoveAllTimer()

	for i = 1,4 do
		for j = 1,table_size[i] do
			for k = 1,#self._slots[i][j] do	
				self._slots[i][j][k].del = true
				self._slots[i][j][k] = nil
			end
		end
	end

end

function Timer:ChangeTimerDelay(index,changedelay)
	if index == nil or index <= 0 then
		return
	end

	for i = 1,4 do
		for j = 1,table_size[i] do
			for k = 1,#self._slots[i][j] do
				if self._slots[i][j][k].index == index then		
					local t = clone(self._slots[i][j][k])
					self._slots[i][j][k] = nil 
					t.delay = t.delay  + changedelay
					self:AddTimer(t.delay,t.func,t.times,t.infoTable)
					break
				end
			end
		end
	end

end

function Timer:GetTimer(index)
	for i = 1,4 do
		for j = 1,table_size[i] do
			for k = 1,#self._slots[i][j] do
				if self._slots[i][j][k].index == index then		
					return self._slots[i][j][k]
				end
			end
		end
	end
	return nil
end

function Timer:InsterTimer(delay,func,times,index,infoTable)
    if 0 == delay then
		for i = 1,times do
			func(infoTable)
		end  
    else
		local fireTime = delay + self._cycle
        local h1, m1, s1, ms1 = MS2Time(delay)
		local h2, m2, s2, ms2 = MS2Time(fireTime)
		
		if h1 == 0 and m1 == 0 and s1 == 0 and ms1 == 0 then
			for i = 1,times do
				func(infoTable)
			end 
			return
		else
			local tick = {
				func = func, 
				delay = delay, 
				time = { h = h2, m = m2, s = s2, ms = ms2 } ,
				times = times,
				index = index,
				info = infoTable,
				fireTime = fireTime,
				del = false
			}
			if h1 ~= 0 then
				tInsert(self._slots[1][h2 == 0 and 24 or h2],tick) -- 24 == table_size[1]
			elseif m1 ~= 0 then
				tInsert(self._slots[2][m2 == 0 and 60 or m2],tick) -- 60 == table_size[2]
			elseif s1 ~= 0 then
				tInsert(self._slots[3][s2 == 0 and 60 or s2],tick) -- 60 == table_size[3]
			elseif ms1 ~= 0 then
				tInsert(self._slots[4][ms2 == 0 and 31 or ms2],tick)-- 31 == table_size[4]
			end
		end
    end
end

function Timer:_InsterTimer(h,m,s,ms,slotIndex,i,j)
	local value = nil
	if j == 0 then
		value = self._slots[slotIndex][i][j]
		self._slots[slotIndex][i][j] = nil
	else
		value = self._slots[slotIndex][i][j]
		if value then
			tRemove(self._slots[slotIndex][i],j)	
		end
	end
	if value == nil or value.del == true then
		value = nil
		return
	end
	local h2 = h
	local m2 = m
	local s2 = s
	local ms2 = ms
	if h==0 and m==0 and s==0 and ms == 0 then
		if value.del == true then
			value = nil
			return
		end
		
		if value.times ~= -1 then
			value.times = value.times -1 
		end
		
			value.func(value.info) 
		if value.times ~= -1 and value.times <= 0 then
			value = nil
			return
		end
		value.fireTime = value.delay + value.fireTime
		value.times  = value.times
		
		h, m, s, ms = MS2Time(value.delay)
		h2, m2, s2, ms2 = MS2Time(value.fireTime)
		value.time.h = h2
		value.time.m = m2
		value.time.s = s2
		value.time.ms = ms2
	end	
	

	if h ~= 0 then
		tInsert(self._slots[1][h2 == 0 and 24 or h2],value) -- 24 == table_size[1]
	elseif m ~= 0 then
		tInsert(self._slots[2][m2 == 0 and 60 or m2],value)
	elseif s ~= 0 then
		tInsert(self._slots[3][s2 == 0 and 60 or s2],value)
	elseif ms ~= 0 then
		--为了防止delay  又添加到了原来的地方
		if ms2 == j then
			ms2 = ms2 - 1
		end
		tInsert(self._slots[4][ms2 == 0 and 31 or ms2],value)
	end
end

function Timer:Update(deltaTime)
	self._deltaTime = deltaTime
    self._cycle = self._cycle + deltaTime

    local h2, m2, s2, ms2 = MS2Time(self._cycle)
	
	local _UpdateH = function (slotIndex,i,j)
		local value = self._slots[slotIndex][i][j]
		if value then
			self:_InsterTimer(0,value.time.m,value.time.s,value.time.ms,slotIndex,i,j)
		else
			--derror(string.format("_UpdateH slotIndex:%s, i:%s,j: %s is nil",tostring(slotIndex),tostring(i),tostring(j)))
		end
	end
	
	local _UpdateM = function (slotIndex,i,j)
		local value = self._slots[slotIndex][i][j]
		if value then
			self:_InsterTimer(0,0,value.time.s,value.time.ms,slotIndex,i,j)
		else
			--derror(string.format("_UpdateM slotIndex:%s, i:%s,j: %s is nil",tostring(slotIndex),tostring(i),tostring(j)))
		end
	end

	local _UpdateS = function (slotIndex,i,j)
		local value = self._slots[slotIndex][i][j]
		if value then
			self:_InsterTimer(0,0,0,value.time.ms,slotIndex,i,j)	
		else
			--derror(string.format("_UpdateS slotIndex:%s, i:%s,j: %s is nil",tostring(slotIndex),tostring(i),tostring(j)))
		end
	end

	local _UpdateMS = function (slotIndex,i,j)
		self:_InsterTimer(0,0,0,0,slotIndex,i,j)	
	end	
	
	if self.h1 ~= h2 then
		self:_UpdateT(24, 1, self.h1, h2,_UpdateH) -- 24 == table_size[1]
	end
	
	if self.m1 ~= m2 then
		self:_UpdateT(60, 2, self.m1, m2,_UpdateM) -- 60 == table_size[2]
	end
	
	if self.s1 ~= s2 then
		if self.bNeedSaveConfig then
			globalTimer.bNeedSaveConfig = false
			SaveConfig()
		end
		if self.bNeedSavePinballLocalRec then
			globalTimer.bNeedSavePinballLocalRec = false
			PinballDataManager:GetInstance():SaveLocalRec()
		end
		self:_UpdateT(60, 3, self.s1, s2, _UpdateS)
	end
	self:_UpdateT(31, 4, self.ms1, ms2, _UpdateMS)

	self.h1 = h2
	self.m1 = m2
	self.s1 = s2
	self.ms1 = ms2

	if self.iDelTimerCount  > 0 then
		for k,v in ipairs(self.aiDelTimer) do
			self:RemoveTimer(v)
		end
		self.iDelTimerCount = 0
		self.aiDelTimer = {}
	end

end

function Timer:_UpdateT(cycle, index, first, last, func)
	local slots = self._slots[index]
	local iListCount = 0
	if cycle == last then
		last = 1
	end
	local iOldFirst = first
    while first ~= last do
		first = first + 1
		for i = #slots[first],1,-1 do
			func(index,first,i)   
		end
        slots[first] = {}
		first = first % cycle
		
		iListCount = iListCount + 1
		if iListCount > 3000 then
			derror("_UpdateT count > 2000")
			--LuaPanda.BP()
			break
		end
    end
end

globalTimer = Timer.new()