local setmetatableindex_
local bQuitGame = false
setmetatableindex_ = function(t, index)
    if type(t) == "userdata" then
        -- local peer = tolua.getpeer(t)
        -- if not peer then
        --     peer = {}
        --     tolua.setpeer(t, peer)
        -- end
        -- setmetatableindex_(peer, index)
    else
        local mt = getmetatable(t)
        if not mt then mt = {} end
        if not mt.__index then
            mt.__index = index
            setmetatable(t, mt)
        elseif mt.__index ~= index then
            setmetatableindex_(mt, index)
        end
    end
end
setmetatableindex = setmetatableindex_

function clone(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif type(object["clone"]) == "function" then
            return object:clone()
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local newObject = {}
        lookup_table[object] = newObject
        for key, value in pairs(object) do
            newObject[_copy(key)] = _copy(value)
        end
        return setmetatable(newObject, getmetatable(object))
    end
    return _copy(object)
end

function class(classname, ...)
    local cls = {__cname = classname}

    local supers = {...}
    for _, super in ipairs(supers) do
        local superType = type(super)
        assert(superType == "nil" or superType == "table" or superType == "function",
            string.format("class() - create class \"%s\" with invalid super class type \"%s\"",
                classname, superType))

        if superType == "function" then
            assert(cls.__create == nil,
                string.format("class() - create class \"%s\" with more than one creating function",
                    classname));
            -- if super is function, set it to __create
            cls.__create = super
        elseif superType == "table" then
            if super[".isclass"] then
                -- super is native class
                assert(cls.__create == nil,
                    string.format("class() - create class \"%s\" with more than one creating function or native class",
                        classname));
                cls.__create = function() return super:create() end
            else
                -- super is pure lua class
                cls.__supers = cls.__supers or {}
                cls.__supers[#cls.__supers + 1] = super
                if not cls.super then
                    -- set first super pure lua class as class.super
                    cls.super = super
                end
            end
        else
            error(string.format("class() - create class \"%s\" with invalid super type",
                        classname), 0)
        end
    end

    cls.__index = cls
    if not cls.__supers or #cls.__supers == 1 then
        setmetatable(cls, {__index = cls.super})
    else
        setmetatable(cls, {__index = function(_, key)
            local supers = cls.__supers
            for i = 1, #supers do
                local super = supers[i]
                if super[key] then 
                  return super[key]
                end
            end
        end})
    end

    if not cls.ctor then
        -- add default constructor
        cls.ctor = function() end
    end
    cls.new = function(...)
        local instance
        instance = {}
        setmetatableindex(instance, cls)
        instance.class = cls
        if cls and cls.super then
            local lSuper = cls.super
            while lSuper do
                lSuper.ctor(instance,...)
                lSuper = lSuper.super
            end
        end
        instance:ctor(...)
        return instance
    end

    return cls
end


function io.exists(path)
    local file = io.open(path, "r")
    if file then
        io.close(file)
        return true
    end
    return false
end

function io.readfile(path)
    local file = io.open(path, "r")
    if file then
        local content = file:read("*a")
        io.close(file)
        return content
    end
    return nil
end

function io.writefile(path, content, mode)
    mode = mode or "w+b"
    local file = io.open(path, mode)
    if file then
        if file:write(content) == nil then return false end
        io.close(file)
        return true
    else
        return false
    end
end

function io.pathinfo(path)
    local pos = string.len(path)
    local extpos = pos + 1
    while pos > 0 do
        local b = string.byte(path, pos)
        if b == 46 then -- 46 = char "."
            extpos = pos
        elseif b == 47 then -- 47 = char "/"
            break
        end
        pos = pos - 1
    end

    local dirname = string.sub(path, 1, pos)
    local filename = string.sub(path, pos + 1)
    extpos = extpos - pos
    local basename = string.sub(filename, 1, extpos - 1)
    local extname = string.sub(filename, extpos)
    return {
        dirname = dirname,
        filename = filename,
        basename = basename,
        extname = extname
    }
end

function io.filesize(path)
    local size = false
    local file = io.open(path, "r")
    if file then
        local current = file:seek()
        size = file:seek("end")
        file:seek("set", current)
        io.close(file)
    end
    return size
end

local function getChar_size(ch)
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
	local i = #arr
	while arr[i] do
		if ch >= arr[i] then
			break
		end
		i = i - 1
	end
	return i
end

--等价于 utf8.len
function string.utf8len(input)
    local len  = string.len(input)
    local left = len
    local cnt  = 0
    local arr  = {0, 0xc0, 0xe0, 0xf0, 0xf8, 0xfc}
    while left ~= 0 do
        local tmp = string.byte(input, -left)
        left = left - getChar_size(tmp)
        cnt = cnt + 1
    end
    return cnt
end

function string.utf8sub(str, start, len)
    local startIndex = 1
    while start > 1 do
        local char = string.byte(str, startIndex)
        startIndex = startIndex + getChar_size(char)
        start = start - 1
    end

    local currentIndex = startIndex

    while len > 0 and currentIndex <= #str do
        local char = string.byte(str, currentIndex)
        currentIndex = currentIndex + getChar_size(char)
        len = len - 1
    end
    return str:sub(startIndex, currentIndex - 1)
end

function string.stringWidthWithoutTag(str)
    local result = 0
	local lenInByte = string.len(str)
	local i = 1
    local isTag = false
    -- 统计不包含<>时的长度
	while i<=lenInByte do
		local curByte = string.byte(str, i)
		local byteCount = 1;
		if curByte>0 and curByte<=127 then
			byteCount = 1
		elseif curByte>=192 and curByte<223 then
			byteCount = 2
		elseif curByte>=224 and curByte<239 then
			byteCount = 3
		elseif curByte>=240 and curByte<=247 then
			byteCount = 4
		end
		local char = string.sub(str, i, i+byteCount-1)
        if char == "<" then
            isTag = true
        end
        if not isTag then
            if byteCount == 1 then 
                result = result + 1
            else
                result = result + 2
            end
        end
        if char == ">" then
            isTag = false
        end
		i = i + byteCount
	end
	return result
end

--汉字当2个字符 其他当1个
function string.stringWidth(str)
	local result = 0
	local lenInByte = string.len(str)
	local i = 1
	while i<=lenInByte do
		local curByte = string.byte(str, i)
		local byteCount = 1;
		if curByte>0 and curByte<=127 then
			byteCount = 1
		elseif curByte>=192 and curByte<223 then
			byteCount = 2
		elseif curByte>=224 and curByte<239 then
			byteCount = 3
		elseif curByte>=240 and curByte<=247 then
			byteCount = 4
		end
		local char = string.sub(str, i, i+byteCount-1)
		if byteCount == 1 then 
			result = result + 1
		else
			result = result + 2
		end
		i = i + byteCount
	end
	return result
end

function string.stringLimit(str,iLimitLength)
    local result = 0
    local sFinalStr = ""
	local lenInByte = string.len(str)
	local i = 1
	while i<=lenInByte do
		local curByte = string.byte(str, i)
		local byteCount = 1;
		if curByte>0 and curByte<=127 then
			byteCount = 1
		elseif curByte>=192 and curByte<223 then
			byteCount = 2
		elseif curByte>=224 and curByte<239 then
			byteCount = 3
		elseif curByte>=240 and curByte<=247 then
			byteCount = 4
		end
        local arg = string.sub(str, i, i+byteCount-1)
		if byteCount == 1 then 
			result = result + 1
		else
			result = result + 2
        end
        if result > iLimitLength then
            return sFinalStr
        else
            sFinalStr = sFinalStr..arg
        end
		i = i + byteCount
	end
	return sFinalStr
end

function string.split( str, separator )
    local retStrTable = {}
    string.gsub(str, '[^' .. separator ..']+', function ( word )
        table.insert(retStrTable, word)
    end)
    return retStrTable;
end

function string.trim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

local logPath = nil

function SetErrorLogPath(path)
    logPath = path
    if logPath == "" then
      logPath = "."
    end
end

--local _trace_reset = true

-- function __G__TRACK_ERROR__(error)
--     if logPath ~= nil then
--         local date=os.date("%Y-%m-%d,%H:%M:%S")
--         local dump = debug.traceback()

--         local content = "\n\n\ntime : "..date.."\nerror : "..error.."\n"..dump

--         if _trace_reset then
--             _trace_reset = false
--             io.writefile(logPath.."/lua_error_log.txt", content, "wb")
--         else
--             io.writefile(logPath.."/lua_error_log.txt", content, "a+b")
--         end

--         if TARGET_PLATFORM == PLATFORM_ANDROID then
          
--         end
--     end
-- end

function xpcallTraceback(error)
    derror(debug.traceback("Error :"..error)) 
end

TestAddRecordInfo = function(key,value)
    if type(value) == "number" then 
        value = value - (start_time or 0)
    end
    _TestRequireInfo = _TestRequireInfo or {}
    _TestRequireInfo[key] = (_TestRequireInfo[key] or "") .. "," .. value
    start_time = os.clock()
end
function TestWriteLoadLanguageInfo()
    if _TestRequireInfo then 
        local report = {}
        for k,v in pairs(_TestRequireInfo) do
            table.insert(report,k .. v)
        end
        DRCSRef.GameConfig:SaveLuaProfile(table.concat(report,"\n"))
        SystemUICall:GetInstance():Toast("报告已输出")
    end
end

local loadInfo = {}
function reloadModule(moduleName)
    if MSDK_MODE == 0 then 
        -- collectgarbage("collect")
        -- local count = collectgarbage("count")/ 1024
        local ctime = os.clock()
        package.loaded[moduleName] = nil
        local ans = require(moduleName)
        TestAddRecordInfo(moduleName,(os.clock() - ctime).."")
        -- dprint("reloadModule",moduleName,(collectgarbage("count") / 1024 - count) .. "MB",(os.clock()-ctime) .. "s")
        --loadInfo[moduleName] = {["MB"] = collectgarbage("count") / 1024 - count,["LoadTime"] = os.clock()-ctime}
        return ans
    else
		package.loaded[moduleName] = nil
    	return require(moduleName)
    end
end

function WriteLoadInfo()
	local path = "./LoadInfo.txt"
    local dkJson = require("Base/Json/dkjson")
    local str = dkJson.encode(loadInfo) 
    io.writefile(path, str,"a+b")
end

function loadModel(moduleName)
    require(moduleName)
end

function unloadModel(moduleName)
    package.loaded[moduleName] = nil
end

function getTableSize(t)
    if type(t) ~= 'table' then 
        return 0
    end
    local size = 0
    if t[0] ~= nil then 
        size = 1
    end
    size = size + #t
    return size
end

function getTableSize2(t)
    if type(t) ~= 'table' then 
        return 0
    end

    local index = 0;
    for k, v in pairs(t) do
        index = index + 1;
    end
    return index;
end

function getDisperTableSize(t)
    if type(t) ~= 'table' then 
        return 0
    end
    local size = 0

    for k, v in pairs(t) do
        size = size + 1
    end

    return size
end

function GetTableMaxIndex(t)
    if type(t) ~= 'table' then 
        return 0
    end

    local maxIndex = 0
    for index, _ in pairs(t) do
        if type(index) == 'number' and index > maxIndex then 
            maxIndex = index
        end
    end

    return maxIndex
end

function ReturnReadOnly(t)
    local newT = {};
    local mt = {
        __index = t,
        __len = function (tab) return #t end,
        __pairs = function (tab) return pairs(t) end,
        __newindex = function()
            error("can't change value,readOnly");
        end
    }
    newT = setmetatable(newT, mt);
    return newT;
end

function dprint(...)
    if OUTPUT_LUALOG then
    --默认注释掉 需要的自己打开
        local arg = table.pack(...)
        for i = 1, arg.n do
            if arg[i] == nil then
                arg[i] = 'nil'
            else
                arg[i] = tostring(arg[i])
            end
        end
        table.insert(arg,"[time:" .. os.date() .. "]")
        local string_text = table.concat(arg, '\t')
        DRCSRef.Log(string_text)
    end
end

function derror(...)
    local arg = table.pack(...)
    for i = 1, arg.n do
        if arg[i] == nil then
            arg[i] = 'nil'
        else
            arg[i] = tostring(arg[i])
        end
    end
    table.insert(arg,"[time:" .. os.date() .. "]")
    local string_text = table.concat(arg, '\t')
    DRCSRef.LogError(string_text)
end

function dwarning(...)
    local arg = table.pack(...)
    for i = 1, arg.n do
        if arg[i] == nil then
            arg[i] = 'nil'
        else
            arg[i] = tostring(arg[i])
        end
    end
    table.insert(arg,"[time:" .. os.date() .. "]")
    local string_text = table.concat(arg, '\t')
    DRCSRef.LogWarning(string_text)
end

-- 临时处理，把代码里用的中文字符串都提取出来
function dtext(index)
    local script_text = {
        [970] = '周目累计时长',
        [971] = '门派好感-',
        [972] = '角色好感-',
        [973] = '[通道]',
        [974] = '[迷宫]',
        [975] = '、',
        [976] = '通向',
        [977] = '\n包含\n',
        [978] = '目前无任务追踪',
        [979] = '所有',
        [980] = '等级上限提升至',
        [981] = '等级提升已达上限，转化为',
        [982] = '残文',
        [983] = '已获得残章',
        [984] = '已转化残文',
        [985] = '使用后可增强角色',
        [986] = '的属性',
        [987] = '的角色卡',
        [988] = '∞',
        [989] = '+10',
        [990] = '选择全部',
        [991] = '好感度:',
        [992] = '无名之辈',
        [993] = '武学',
        [994] = '级',
        [995] = '无',
        [996] = '天赋',
        [997] = '门派',
        [998] = '加入',
        [999] = '天赋名',
        [1000] = '初始天赋',
        [1001] = '选中',
        [1002] = '取消选中',
        [1003] = '已出战',
        [1004] = '出战',
        [1005] = '卸下',
        [1006] = '城市好感-',
        [1007] = '丢弃',
    }
    return script_text[index]
end

-- 临时处理，如果 GetLanguageByID 返回的是一个空字符串，则替换成默认字符串
function GetLanguagePreset(langID, default, nodecode)
    local lang = nil
    if langID and langID > 0 then
        lang = GetLanguageByID(langID, nil, nodecode)
    end
    default = default or ""
    if lang == nil or lang == "" then
        if type(default) == "number" then
            return dtext(default)
        elseif type(default) == "string" then
            return default
        -- elseif type(default) == "table" then
        --     for i = 1, default.n do
        --         if default[i] == nil then
        --             default[i] = 'nil'
        --         else
        --             default[i] = tostring(default[i])
        --         end
        --     end
        --     return table.concat(default, '')
        else
            return tostring(default)
        end
    end
    return lang
end

-- 将数字/字符串转换为 向下取整的 整数
function toint(v)
	if v then
		return math.floor(tonumber(v))
	end
	return 0
end

-- 设置宽高
function SetUIAxis(ui, width, height)
    local rt = ui:GetComponent("RectTransform")
    if width then
        rt:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Horizontal, width)
    end
    if height then
        rt:SetSizeWithCurrentAnchors(DRCSRef.RectTransform.Axis.Vertical, height) 
    end
end

function getDreamlandTimeStruct(kDRTime)
    if not kDRTime then 
        return 
    end
    local ret = {}
    ret.Quarter = kDRTime % 100 + 1
    ret.Day = (kDRTime // 100) % 30 + 1
    ret.Month = (kDRTime // 100 // 30) % 12 + 1
    ret.Year = kDRTime // 100 // 30 // 12 + 1
    return ret
end

function getDreamlandTimeString(kDRTime, type)
    if not kDRTime then return '' end
    local m_Quarter = kDRTime % 100 + 1;
    local m_Day = (kDRTime // 100) % 30 + 1;
    local m_Month = (kDRTime // 100 // 30) % 12 + 1;
    local m_Year = kDRTime // 100 // 30 // 12 + 1;
    if type == 4 then
        return string.format('%d年%d月%d日%d刻', m_Year, m_Month, m_Day, m_Quarter)
    else
        return string.format('%d年%d月%d日', m_Year, m_Month, m_Day)
    end
end

function getTimeString(kDRTime, type)
    if not kDRTime then return '' end
    local m_Second = kDRTime % 60;
    local m_Minute = (kDRTime // 60) % 60;
    local m_Hour = (kDRTime // 60 // 60) % 24;
    local m_Hour_total = kDRTime // 60 // 60;
    local m_Day = kDRTime // 60 // 60 // 24;
    if type == 4 then
        return string.format('%d天%d小时%d分%d秒', m_Day, m_Hour, m_Minute, m_Second)
    elseif type == 3 then
        return string.format('%d小时%d分%d秒', m_Hour_total, m_Minute, m_Second)
    else
        if m_Hour_total > 0 then
            return string.format('%d小时 %d分 %d秒', m_Hour_total, m_Minute, m_Second)
        else
            return string.format('%d分 %d秒', m_Minute, m_Second)
        end
    end
end

----------------------------------------------------------
-- 品质色暂时没有考虑五彩的情况
function getRankColor(enum)
    if enum and RANK_COLOR[enum] then
        return RANK_COLOR[enum]
    end
    return DRCSRef.Color(1,1,1,1)
end

function getRankBasedText(enum, text, outline)
	text = text or ''
    local color = '#FFFFFF'
    if enum and RANK_COLOR_STR[enum] then
        color = RANK_COLOR_STR[enum]
    end

    if outline == true then
        return '<outline='..color..'>' .. text .. '</outline>'
    else
        return '<color='..color..'>' .. text .. '</color>'
    end

end

function getSizeText(int_size, text)
	text = text or ''
    return '<size='..int_size..'>' .. text .. '</size>'
end

-- 根据 角色 / 武学 的 Attr 属性表，获取 格式化的 Text
function getAttrBasedText(enum, value, isMainRoleAttr)
    if not (enum and value) then
        derror("格式化属性值错误: ", enum, value)
        return "0"
    end

    local bIsPerMyriad, bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(enum, isMainRoleAttr)
    if bIsPerMyriad then
        value = value / 10000
    end
    
    if bShowAsPercent then
        if value == 0 then return "0%" end
        local fvalue = value * 100
        if isMainRoleAttr or fvalue == math.floor(fvalue) then
            return string.format("%.0f%%", fvalue)
        else
            return string.format("%.1f%%", fvalue)
        end
    else
        if value == 0 then return "0" end
        local fs
        if  bIsPerMyriad and (not isMainRoleAttr) and value ~= math.floor(value) then
            fs = "%.1f" 
        else
            fs = "%.0f"
        end
        return string.format(fs, value)
    end
end

function getUIBasedText(UIflag, text)
    text = text or ''
    local color = '#FFFFFF'
    if UIflag and UI_COLOR_STR[UIflag] then
        color = UI_COLOR_STR[UIflag]
    end
    return '<color='..color..'>' .. text .. '</color>'
end

function getTipsColor(string)
    if string and TIPS_COLOR[string] then
        return TIPS_COLOR[string]
    end
    return DRCSRef.Color(1,1,1,1)
end

function getUIColor(string)
    if string and UI_COLOR[string] then
        return UI_COLOR[string]
    end
    return DRCSRef.Color(1,1,1,1)
end

function stringToColor(str)
    local s = string.sub(str,2,-1)
    -- s = string.format("%06s", s)
    while string.len(s) < 6 do
        s = '0'..s
    end
    ---
    local r = 0
    local g = 0
    local b = 0
    ---
    r = tonumber(string.sub(s,1,2), 16)
    g = tonumber(string.sub(s,3,4), 16)
    b = tonumber(string.sub(s,5,6), 16)
    return DRCSRef.Color(r/255, g/255, b/255, 1)
end

local l_GrayMaterial = nil
function setUIGray(image, value)
    if not image then return end
    if value then
        if l_GrayMaterial == nil then
            l_GrayMaterial = LoadPrefab("Materials/UI_Gray",typeof(CS.UnityEngine.Material))
        end
        image.material = l_GrayMaterial
    else
        image.material = image.defaultMaterial
    end

    -- local boolean_gray = (value ~= false) and 1 or 0
    -- local PropertyBlock
    -- local comRenderer = ui:GetComponent("CanvasRenderer")
    -- if not comRenderer then return end
    -- comRenderer:GetPropertyBlock(PropertyBlock)
    -- PropertyBlock:SetFloat("_Gray", boolean_gray);
    -- comRenderer:SetPropertyBlock(PropertyBlock);
end

function setHeadUIGray(image, value,default)
    if not image then return end
    if value then
        if GrayHeadMaterial == nil then
            GrayHeadMaterial = LoadPrefab("Materials/headMaskBossGray_Martial",typeof(CS.UnityEngine.Material))
        end
        image.material = GrayHeadMaterial
    else
        if BossHeadMaterial == nil then
            BossHeadMaterial = LoadPrefab("Materials/headMaskBoss_Martial",typeof(CS.UnityEngine.Material))
        end
        image.material = BossHeadMaterial
    end
    -- local boolean_gray = (value ~= false) and 1 or 0
    -- local PropertyBlock
    -- local comRenderer = ui:GetComponent("CanvasRenderer")
    -- if not comRenderer then return end
    -- comRenderer:GetPropertyBlock(PropertyBlock)
    -- PropertyBlock:SetFloat("_Gray", boolean_gray);
    -- comRenderer:SetPropertyBlock(PropertyBlock);
end

local l_GlowMaterial = nil
function setUIGlow(image, value)
    if not image then return end
    if value then
        if l_GlowMaterial == nil then
            l_GlowMaterial = LoadPrefab("Materials/UI_Glow",typeof(CS.UnityEngine.Material))
        end
        image.material = l_GlowMaterial
    else
        image.material = image.defaultMaterial
    end
end

--这里flag的实现 跟 c++中的是不一致的 ，注意！
--这里传入的是 左移动的位数
function HasFlag(iBaseFlag,iFlag)
    if iBaseFlag == nil or iFlag == nil then 
        return false
    end
    iFlag = 1 << iFlag
    return ((iBaseFlag & iFlag) == iFlag)
end

--这里flag的实现 跟 c++中的是不一致的 ，注意！
function HasValue(iBaseFlagVale,iFlagValue)
    if iBaseFlagVale == nil or iFlagValue == nil then 
        return false
    end
    return ((iBaseFlagVale & iFlagValue) == iFlagValue)
end

--这里flag的实现 跟 c++中的是不一致的 ，注意！
function SetFlag(iBaseFlag,iFlag)
    return (iBaseFlag | (1 <<iFlag))
end

--这里flag的实现 跟 c++中的是不一致的 ，注意！
function ClrFlag(iBaseFlag,iFlag)
    return iBaseFlag & (~(1<<iFlag))
end

function Clamp(value,min,max)
    if value > max then
        return max
    elseif value < min then
        return min
    end
    return value
end

---判断对象是否为空 不空true
function IsValidObj(gameObject)
    return gameObject and not gameObject:Equals(nil);
end

-- 判断两个 data 是不是相等
-- t_isdiff 为忽略字段
function DataIsEqual(a, b, t_isdiff)
	t_isdiff = t_isdiff or {}
	if type(a) ~= type(b) then
		return false
	end
	if type(a) == "table" then
		local result = true
		for k, v in pairs(a) do
			if t_isdiff[k] == nil and (not DataIsEqual(b[k], v)) then
				return false
			end
        end
        -- 两边元素数量不一定相同， 所以还要反向比较一次
		for k, v in pairs(b) do
			if t_isdiff[k] == nil and (not DataIsEqual(a[k], v)) then
				return false
			end
		end
		return true
	else
		return a == b
	end
end

function Dump(value, desciption, nesting)
    if not DEBUG_MODE then
        return
    end
    if type(nesting) ~= "number" then nesting = 3 end

    local lookupTable = {}
    local result = {}

    local function _v(v)
        if type(v) == "string" then
            v = "\"" .. v .. "\""
        end
        return tostring(v)
    end

    function string:split(sep)
        local sep, fields = sep or "\t", {}
        local pattern = string.format("([^%s]+)", sep)
        self:gsub(pattern, function(c) fields[#fields+1] = c end)
        return fields
    end

    local traceback = string.split(debug.traceback("", 2), "\n")
    for i = 1, #traceback do
        if traceback[i] then
            dprint(traceback[i])
        end
    end
    dprint(debug.getinfo(1))

    local function _dump(value, desciption, indent, nest, keylen)
        desciption = desciption or "<var>"
        local spc = ""
        if type(keylen) == "number" then
            spc = string.rep(" ", keylen - string.len(_v(desciption)))
        end
        if not (type(value) == "table") then
            result[#result +1 ] = string.format("%s%s%s = %s", indent, _v(desciption), spc, _v(value))
        elseif lookupTable[value] then
            result[#result +1 ] = string.format("%s%s%s = *REF*", indent, desciption, spc)
        else
            lookupTable[value] = true
            if nest > nesting then
                result[#result +1 ] = string.format("%s%s = *MAX NESTING*", indent, desciption)
            else
                result[#result +1 ] = string.format("%s%s = {", indent, _v(desciption))
                local indent2 = indent.."    "
                local keys = {}
                local keylen = 0
                local values = {}
                for k, v in pairs(value) do
                    keys[#keys + 1] = k
                    local vk = _v(k)
                    local vkl = string.len(vk)
                    if vkl > keylen then keylen = vkl end
                    values[k] = v
                end
                table.sort(keys, function(a, b)
                    if type(a) == "number" and type(b) == "number" then
                        return a < b
                    else
                        return tostring(a) < tostring(b)
                    end
                end)
                for i, k in ipairs(keys) do
                    _dump(values[k], k, indent2, nest + 1, keylen)
                end
                result[#result +1] = string.format("%s}", indent)
            end
        end
    end
    _dump(value, desciption, "- ", 1)

    for i, line in ipairs(result) do
        dprint(line)
    end
end

----------------table扩展--------------------
function table.nums(t)
    local count = 0
    for k, v in pairs(t) do
        count = count + 1
    end
    return count
end

function table.indexof(array, value, begin)
    for i = begin or 1, #array do
        if array[i] == value then return i end
    end
    return false
end

function table.keyof(hashtable, value)
    for k, v in pairs(hashtable) do
        if v == value then return k end
    end
    return nil
end

function dnull(t)
    return (t and t ~= '' and t ~= 0)
end

function table_c2lua(t)
    if type(t) ~= 'table' then
        return t
    end
    
    local array = {}

    if t[0] then
        table.move(t, 0, #t, 1, array)
        return array
    end
    
    return t
end

-- 其实也是 lua2c，看下和下面的写法哪个好
function FormatTable(array)
    local tempArray = {}
    for i = 1, #(array) do
        tempArray[i - 1] = array[i];
    end
    return tempArray;
end

function table_lua2c(t)
    if type(t) ~= 'table' then
        return t
    end
    local array = {}
    for i = 1, #t do
        array[i] = t[i]
    end
    array[0] = table.remove(array, 1)
    return array
end

-- 将 Arg 字符串 转换为 number table
function table_arg2array(arg, taskID)
    if type(arg) ~= 'string' then
        return arg
    end

    local arr = string.split(arg, "|")
    for k,v in pairs(arr) do
        arr[k] = DecodeNumber(v, taskID)
    end
    return arr
end
function table_hash2array(t)
    if type(t) ~= 'table' then
        return t
    end
    local array = {}
    for k,v in pairs(t) do
        table.insert(array, v)
    end
    return array
end

function ArrayToTable(array)
    local t = {}
    for i = 1, array.Length do
        t[i] = array:GetValue(i-1);
    end
    return t;
end
---------------------DoTween动画---------------------------------------
local twnTime_Move = 0.3
local twnTime_MoveY = 0.3
local twnTime_Scale = 0.3
local twnTime_ShakePosition = 0.3
function Twn_MoveX(twnAnim, twnObj, fRelativeMoveX, fTime, seEase, onComplete)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if twnObj == nil then
        return nil
    end
    local rectTransform = twnObj:GetComponent("RectTransform")
    local fEndValueX =  rectTransform.anchoredPosition.x + fRelativeMoveX
    if fTime == nil then
        fTime = twnTime_Move
    end
    twnAnim = rectTransform:DOAnchorPosX(fEndValueX, fTime)

    if onComplete then
        twnAnim.onComplete = onComplete
    end

    if seEase ~= nil then
        twnAnim:SetEase(seEase)
    end
    twnAnim:SetAutoKill(false)
    return twnAnim
end

function Twn_MoveBy_Y(twnAnim, twnObj, fRelativeMoveY, fTime, seEase, onComplete)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if twnObj == nil then
        return nil
    end
    local rectTransform = twnObj:GetComponent("RectTransform")
    local fEndValueY =  rectTransform.anchoredPosition.y + fRelativeMoveY
    if fTime == nil then
        fTime = twnTime_MoveY
    end
    twnAnim = rectTransform:DOAnchorPosY(fEndValueY, fTime)

    if onComplete then
        twnAnim.onComplete = onComplete
    end

    if seEase ~= nil then
        twnAnim:SetEase(seEase)
    end
    twnAnim:SetAutoKill(false)
    return twnAnim
end

function Twn_MoveY(twnAnim, twnObj, fEndValueY, fRelativeMoveY, fTime, seEase)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if twnObj == nil then
        return nil
    end
    local rectTransform = twnObj:GetComponent("RectTransform")
    local pos = rectTransform.anchoredPosition
    pos.y = fEndValueY - fRelativeMoveY
    rectTransform.anchoredPosition = pos
    if fTime == nil then
        fTime = twnTime_MoveY
    end
    twnAnim = rectTransform:DOAnchorPosY(fEndValueY, fTime)
    twnAnim.onComplete = function()
        pos.y = fEndValueY
        rectTransform.anchoredPosition = pos
    end
    if seEase ~= nil then
        twnAnim:SetEase(seEase)
    end
    twnAnim:SetAutoKill(false)
    return twnAnim
end

function Twn_Scale(twnAnim, twnObj, fBeginValue, fEndValue, fTime, seEase, onComplete)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if twnObj == nil then
        return nil
    end
    local rectTransform = twnObj:GetComponent("RectTransform")
    rectTransform.localScale = fBeginValue
    if fTime == nil then
        fTime = twnTime_Scale
    end
    twnAnim = rectTransform:DOScale(fEndValue, fTime)
    if seEase ~= nil then
        twnAnim:SetEase(seEase)
    end
    if onComplete then
        twnAnim.onComplete = onComplete
    end
    twnAnim:SetAutoKill(false)
    return twnAnim
end

function Twn_Color(twnAnim, target, fEndValue, fTime, startDelay, IsLoop, onComplete)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if target == nil then
        return nil
    end
    fTime = fTime or 1

    twnAnim = target:DOColor(fEndValue, fTime)
    twnAnim:SetAutoKill(false)

    if onComplete then
        twnAnim.onComplete = onComplete
    end

    if startDelay and startDelay > 0 then
        twnAnim:SetDelay(startDelay)
    end
    if IsLoop then
        twnAnim:SetLoops(-1, DRCSRef.LoopType.Yoyo)
    end

    return twnAnim
end

function Twn_Number(twnAnim, numberText, fBeginValue, fEndValue, fTime, fDelayTime)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end

    if not IsValidObj(numberText) then
        return nil
    end
    fTime = fTime or 2
    twnAnim = DRCSRef.DOTween.To(function(iCurValue)
        if IsValidObj(numberText) then
            numberText.text = math.floor(iCurValue)
        end
    end, fBeginValue, fEndValue, fTime)
    if fDelayTime and fDelayTime > 0 then
        twnAnim:SetDelay(fDelayTime)
    end
    return twnAnim
end

function Twn_CanvasGroupFade(twn, canvasGroup, fBeginValue, fEndValue, fDuration, startDelay, onComplete, IsLoop)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if canvasGroup == nil then
        return nil
    end
    canvasGroup.alpha = fBeginValue
    if not twn then
        twn = canvasGroup:DOFade(fEndValue, fDuration)
        if onComplete then
            twn.onComplete = onComplete
        end
        --twn:SetAutoKill(false)
    else
        twn:Restart()
    end
    if startDelay and startDelay > 0 then
        twn:SetDelay(startDelay)
    end
    if IsLoop then
        twn:SetLoops(-1, DRCSRef.LoopType.Yoyo)
    end
    twn:SetUpdate(DRCSRef.UpdateType.Normal,true) -- 不受加速影响
    return twn
end

--Image、Text等组件使用
function Twn_Fade(twn, twnCom, fBeginValue, fEndValue, fDuration, startDelay, onComplete, IsLoop)
    if twn ~= nil then
        twn:Restart()
        return twn
    end
    if twnCom == nil then
        return nil
    end
    twnCom.color = DRCSRef.Color(twnCom.color.r, twnCom.color.g, twnCom.color.b, fBeginValue/255)
    if not twn then
        twn = twnCom:DOFade(fEndValue/255, fDuration)
        if onComplete then
            twn.onComplete = onComplete
        end
        twn:SetAutoKill(false)
    else
        twn:Restart()
    end
    if startDelay and startDelay > 0 then
        twn:SetDelay(startDelay)
    end
    if IsLoop then
        twn:SetLoops(-1, DRCSRef.LoopType.Yoyo)
    end
    return twn
end

function Twn_DoText(twnAnim, textObj, targetText, fSpeed, onComplete)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if textObj == nil then
        return nil
    end
    textObj.text = ""
    fSpeed = fSpeed or 10
    if twnAnim then
        twnAnim:ChangeEndValue(targetText,fSpeed)
    else
        twnAnim = textObj:DOText(targetText, fSpeed, true):SetSpeedBased(true)
    end
    twnAnim:SetEase(DRCSRef.Ease.Linear)
    twnAnim.onComplete = onComplete
    twnAnim:SetAutoKill(false):Pause()
    twnAnim:Restart()
    return twnAnim
end

function Twn_Sequence(twnSequence, appendList, InsertList, fStartDelayTime, bAutoKill)
    bAutoKill = bAutoKill or false
    if not twnSequence then
        twnSequence = DRCSRef.DOTween.Sequence()
        twnSequence:SetAutoKill(bAutoKill)
        if appendList then
            for k, vTwn in ipairs(appendList) do
                twnSequence:Append(vTwn)
            end
        end
        if InsertList then
            for k, vData in pairs(InsertList) do
                twnSequence:Insert(vData.atPosition, vData.tween)
            end
        end
    else
        twnSequence:Restart()
    end
    if fStartDelayTime and fStartDelayTime > 0 then
        twnSequence:SetDelay(fStartDelayTime)
    end
    return twnSequence
end

function Twn_ImageFillAmount(twn, Image, fStartValue, fEndValue, fDuration, onComplete)
    if twn ~= nil then
        twn:Restart()
        return twn
    end
    if Image == nil then
        return nil
    end
    fStartValue = fStartValue or 0
    fEndValue = fEndValue or 1
    Image.fillAmount = fStartValue
    if twn then
        twn:ChangeEndValue(fEndValue, fDuration):Pause()
        twn:Restart()
    else
        twn = Image:DOFillAmount(fEndValue, fDuration)
        twn:SetAutoKill(false)
    end
    twn.onComplete = onComplete
    return twn
end

function Twn_ShakePosition(twnAnim, twnObj, fTime, vstrength,seEase, onComplete)
    if twnAnim ~= nil then
        twnAnim:Restart()
        return twnAnim
    end
    if twnObj == nil then
        return nil
    end
    local rectTransform = twnObj:GetComponent("RectTransform")
    if fTime == nil then
        fTime = twnTime_ShakePosition
    end
    if vstrength == nil then
        vstrength = DRCSRef.Vec3(10,10,10)
    end
    twnAnim = rectTransform:DOShakePosition(fTime, vstrength, 20, 145)
    if seEase ~= nil then
        twnAnim:SetEase(seEase)
    end
    if onComplete then
        twnAnim.onComplete = onComplete
    end
    twnAnim:SetAutoKill(false)
    return twnAnim
end

-- --计算三阶曲线上的点
-- function Bezier(p0, p1, p2, p3, t)
--     local p0p1 = (1 - t) * p0 + t * p1
--     local p1p2 = (1 - t) * p1 + t * p2
--     local p2p3 = (1 - t) * p2 + t * p3
--     local p0p1p2 = (1 - t) * p0p1 + t * p1p2
--     local p1p2p3 = (1 - t) * p1p2 + t * p2p3
--     local result = (1 - t) * p0p1p2 + t * p1p2p3
--     return result
-- end

function CalculateCubicBezierPoint(t, p0, p1, p2)
    local u = 1 - t
    local tt = t * t
    local uu = u * u
    local p = uu * p0
    p = p + 2 * u * t * p1
    p = p + tt * p2
    return p
end

--获取BezierPath上的点
function BezierPath(beginPos,endPos,pointNum,diff)
    local path = {}
    --控制点
    local midX = (beginPos.x + endPos.x)/2
    local midY = (beginPos.y + endPos.y)/2 + diff
    local midPos = DRCSRef.Vec3(midX,midY,0)
    for int_i=1,pointNum do
        local t = int_i / pointNum
        local pixel = CalculateCubicBezierPoint(t,beginPos,midPos,endPos)
        table.insert(path,pixel)
    end

    return path
end

--按bezier曲线路径移动
--com 组件
--beginPos 起始点
--endPos 结束点
--diff 曲线的幅度值
--pointNum 曲线上样点个数
--fDuration 移动总时间
--seEase 速度样式
--onComplete 移动结束回调
function Twn_Bezier(com,beginPos,endPos,diff,onComplete,pointNum,fDuration,seEase,fDelaytimer,v3CtrlPos)
    if not com then
        return nil
    end

    if not endPos then
        return nil
    end
    
    fDuration = fDuration or 0.6  --默认时间0.6
    pointNum = pointNum or 30       --默认样点30
    fDelaytimer = fDelaytimer or 0 -- 延迟调用
    seEase = seEase or DRCSRef.Ease.Linear
    diff = diff or math.random(100,240)
    local twn
    if v3CtrlPos == nil then
        twn = com.transform:DR_DOBezier(beginPos.x,beginPos.y,endPos.x,endPos.y,pointNum,diff,seEase,fDuration,onComplete,fDelaytimer)
    else
        twn = com.transform:DR_DOBezier(beginPos.x,beginPos.y,endPos.x,endPos.y,pointNum,diff,seEase,fDuration,onComplete,fDelaytimer,v3CtrlPos)
    end

    -- local path = BezierPath(beginPos,endPos,pointNum,diff)
    -- local twn = com.transform:DOLocalPath(path,fDuration):SetEase(seEase):SetDelay(fDelaytimer)
    -- if onComplete then
    --     twn.onComplete = onComplete
    -- end

    return twn
end

--创建 直线 激光 曲线飞行特效,
--objLine 必须包含lineRenderer组件
--flyTime  飞行时间
--stayTime 飞行到目标点后保持的时间
--fadeOutTime 渐隐时间 单位 s
--lineType :  0 激光  1 直线  2  曲线
-- SetBeginPos(float x, float y ,float z) --起始点
-- SetEndPos(float x, float y, float z) --结束点
-- SetRadianPos(float x, float y, float z) --曲线最高点， 当为曲线时，需要设置这个点
-- StartDraw 开始绘制
function CreateLineEffect(objLine,flyTime,stayTime,fadeOutTime,lineType,pointNum)
    if not IsValidObj(objLine) then
        return nil
    end
    local lineEffect = objLine:GetComponent(DRCSRef_Type.LineEffect)
    if lineEffect == nil then
        lineEffect = objLine:AddComponent(DRCSRef_Type.LineEffect)
    end
    flyTime = flyTime or 0.5
    stayTime = stayTime or 0.5
    fadeOutTime = fadeOutTime or 0.3
    lineType = lineType or 0

    lineEffect.flyTime = flyTime
    lineEffect.stayTime = stayTime
    lineEffect.fadeOutTime = fadeOutTime
    lineEffect.eType = lineType
    if lineType == 2 then
        pointNum = pointNum or 20
        lineEffect.pointNum = pointNum
    end
    return lineEffect
end

function ProfilerStart()
    profiler:start()
end

function ProfilerStop(writeReport)
    if writeReport ~= false then 
        ProfilerReport()
    end
    profiler:stop()
end

function ProfilerReport(sortBy)
    sortBy = sortBy or 'TOTAL'
    local report = profiler:report(sortBy)
    DRCSRef.GameConfig:SaveLuaProfile(report)
    --io.writefile("luaprofile.txt", report)
end

function showError(e)
    if DEBUG_CHEAT then
        local trace = e .. '\n' .. debug.traceback()
        SystemTipManager:GetInstance():AddPopupTip(trace)
        derror(trace)
    end

    if not IS_WINDOWS then 
        local trace = e .. debug.traceback()
        DRCSRef.MSDKCrash:ReportException(1,"xpcall","LuaException",trace)
    end
end

--模型淡入淡出
-- TODO:c#
function FadeInOutShaps(shapeObj,fadeTime,fadeType,alphaBegin,alphaEnd)
    if fadeType == nil then
        fadeType = false
    end

    if alphaBegin == nil or alphaEnd == nil then 
        --淡出
        if fadeType then
            alphaBegin = 1.0
            alphaEnd = 0.0
        else
            alphaBegin = 0.0
            alphaEnd = 1.0
        end
    end
    
    if not IsValidObj(shapeObj) then
        return
    end

    shapeObj:FadeInOutShaps(fadeTime,fadeType,alphaBegin,alphaEnd)
end

-- 模型改变颜色
function ColorOutShaps(shapeObj, duration, colorBegin, colorEnd)
    if not IsValidObj(shapeObj) then
        return
    end

    shapeObj:ColorOutShaps(duration, colorBegin, colorEnd)
end

--改变模型透明度
--alpha 0~1
function changeShapsAlpha(shapeObj, alpha)
    DRCSRef.CommonFunction.ChangeShapsAlpha(shapeObj,alpha)
end

-- 重置游戏
function ResetGame(bClearCache)
    -- LuaEventDispatcher:ClearListener()
    -- 这里实现globaldata的清空工作
    local _strClearExcept = {'PlayerInfo','GameMode','UnlockPool', 'LoginValidateToken', 'LoginZone', 'LoginServer', 
    'PlayerID',"GameServerToken","LOGIN_SUCCESS","GameServerHost","GameServerPort"}
    globalDataPool:ClearExcept(_strClearExcept)
    LogicMain:GetInstance():Clear()
    LogicMain:GetInstance():ClearStatisticalData()
    ArenaDataManager:GetInstance():Clear()
    MartialDataManager:GetInstance():Clear()
    DialogRecordDataManager:GetInstance():Clear()
    TileDataManager:GetInstance():Init()
    ClearScriptMusicInfo()
    -- BattleAIDataManager:GetInstance():Init()
    PKManager:GetInstance():End(false)
    g_isLoadStory = true
    g_loadPlotFinish = false
    g_noPlayerCmd = true
    if bClearCache == true then
        StorageDataManager:GetInstance():Clear()
        AchieveDataManager:GetInstance():Clear()
        TreasureBookDataManager:GetInstance():Clear()
        Day3SignInDataManager:GetInstance():Clear()
        PlayerSetDataManager:GetInstance():Clear()
        PinballDataManager:GetInstance():Clear()
        ResDropActivityDataManager:GetInstance():Clear()
        CreateFaceManager:GetInstance():Clear()
        
        MeridiansDataManager:GetInstance():Init()
        SocialDataManager:GetInstance():Init()
        RankDataManager:GetInstance():Init()
        ArenaDataManager:GetInstance():Init()
        ChatBoxUIDataManager:GetInstance():Init()
        ShoppingDataManager:GetInstance():Init()
        GuideDataManager:GetInstance():Init()
        local chatBoxUI = GetUIWindow("ChatBoxUI")
        if chatBoxUI then
            if chatBoxUI:GetPrivateOpen() then
                chatBoxUI:OnRefPrivateMsgListUI(nil, nil);
            end

            chatBoxUI:OnClickExtenBtn(nil, false);
            chatBoxUI:OnRefNewMsgUI();
            chatBoxUI:OnRefNormalList();
            chatBoxUI:OnRefSmallChatList();
        end

        if AppsManager then
            AppsManager:Destroy();
            AppsManager = nil;
        end

        if NetCommonData then
            NetCommonData.Config = {};
        end

        globalDataPool:clear();
    end
    g_EnterMazeCount = 0
    g_ShareFriendClickReward = false
    g_skipBattle = false
    reloadManagerModule()
end

function ShowServerAndUID(showUID)
    if showUID == nil then
        showUID =  GetConfig("confg_ShowUID");
    end
	-- if not showUID or showUID == 2 then
	-- 	OpenWindowImmediately('ServerAndUIDUI');
	-- else
	-- 	RemoveWindowImmediately("ServerAndUIDUI");
	-- end
end

function ColorHex2RGB(colorHex)
    local r = (colorHex & 0xff000000)>> 24
    local g =  (colorHex & 0x00ff0000) >> 16
    local b =  (colorHex & 0xff00) >> 8
    return DRCSRef.Color(r/255,g/255,b/255,1)
end

function ColorHex2RGB32(colorHex)
    local r = (colorHex & 0xff000000)>> 24
    local g =  (colorHex & 0x00ff0000) >> 16
    local b =  (colorHex & 0xff00) >> 8
    return DRCSRef.Color32(r,g,b,255)
end

function GetTouchUIPos()
    local gameobject = DRCSRef.FindGameObj("UIBase")
    if gameobject then 
        local comTouchUIPos = gameobject:GetComponent("TouchUIPos")
        if comTouchUIPos then 
            return comTouchUIPos:GetTouchUIPos()
        end
    end
    return DRCSRef.Vec3Zero
end

-- 跳过所有无用动画 包括 对话, 引导, 进入城市动画, 黑屏等
function SkipAllUselessAnim()
    g_skipAllUselessAnim = not g_skipAllUselessAnim
    local text = ""
    if g_skipAllUselessAnim then
        text = "跳过无用动画 <color=#6CD458>开启</color>"
    else
        text = "跳过无用动画 <color=#C26AF5>关闭</color>"
    end
    SystemUICall:GetInstance():Toast(text)
    local curActionType = DisplayActionManager:GetInstance():GetCurActionType()
    if curActionType == DisplayActionType.PLOT_DIALOGUE then 
        RemoveWindowImmediately('DialogChoiceUI', true)
        DisplayActionEnd()
    end
end

function LuaPandaStart(ip)
    require("Base/LuaPanda/LuaPanda")
    if ip == nil then
        ip = "127.0.0.1"
    end
    LuaPanda.start(ip,8818)
end

function ReBuildRect(obj)
    local _func;
    _func = function(gameObject, uiObjArray)
        local csf = gameObject:GetComponent('ContentSizeFitter');
        if csf then
            table.insert(uiObjArray, gameObject);
        end
        
        for k, v in pairs(gameObject.transform) do
            _func(v.gameObject, uiObjArray);
        end
    end

    local uiObjArray = {};
    _func(obj, uiObjArray);
    for i = #(uiObjArray), 1, -1 do
        local rtf = uiObjArray[i]:GetComponent('RectTransform');
        DRCSRef.LayoutRebuilder.ForceRebuildLayoutImmediate(rtf);
    end
end

function CloseLog()
    OUTPUT_LUALOG = false
    CS.UnityEngine.Debug.unityLogger.filterLogType = 0
end

function OpenLog()
    OUTPUT_LUALOG = true
    CS.UnityEngine.Debug.unityLogger.filterLogType = 3
end

function QuitGame()
    DRCSRef.Application.Quit()
end

function PingAddress(callBack)
    local netCheck = WindowsManager:GetInstance()._NetCheck
    if netCheck then
        --GetNetStatus()  :  callBack,  pingAddress = "www.baidu.com",  iTimeout = 5
        netCheck:GetNetStatus(callBack)
    end
end

function ReturnToLogin(callBack)
    if MSDKHelper.loginFromQQ or MSDKHelper.loginFromWX then
        DRCSRef.MSDKLogin.Logout();
    end
    if (g_IS_SIMULATORIOS) then
        MSDK_OS = 1
        g_IS_SIMULATORIOS = nil
    end
    if callBack == nil then
        UPSMgr:ReportDisconnect(3,0)
    end
    MSDKHelper:StopTssReport()
    DRCSRef.NetMgr:Disconnect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER)
    DRCSRef.NetMgr:Disconnect(CS.GameApp.E_NETTYPE.NET_LOGINSERVER)
    g_ShareFriendClickReward = false
    local LOGIN_SUCCESS = globalDataPool:getData("LOGIN_SUCCESS")
    if LOGIN_SUCCESS == 1 or callBack == nil then
        globalDataPool:setData("LOGIN_SUCCESS",0,true)
        OpenWindowImmediately("LoadingUI")
        ResetGame(true)
        ChangeScenceImmediately("Town","LoadingUI", function()
            local LoginUI = OpenWindowImmediately("LoginUI")
            if callBack and type(callBack) == "function" then
                callBack()
            end
        end)
    end
end

-- 版本号比对，参数1服务器版本号，参数2客户端版本号，返回值大于0代表客户端大于服务器，等于0代表相等，小于0代表客户端版本号小于服务器
function VersionCodeCompare(strServerCode, strLocalCode)
  if (strServerCode == nil or strLocalCode == nil) then
    return 1
  end

  local strServerVersionSplit = string.split(tostring(strServerCode), ".")
  local strLocalVersionSplit = string.split(tostring(strLocalCode), ".")

  if (#strServerVersionSplit ~= #strLocalVersionSplit) then
    return 1
  end

  for i = 1, #strServerVersionSplit do
    local numServerCode = tonumber(strServerVersionSplit[i])
    local numLocalCode = tonumber(strLocalVersionSplit[i])
    if (numServerCode > numLocalCode) then
      return 1
    elseif (numServerCode < numLocalCode) then
      return -1
    end
  end

  return 0
end

-- 获取当前渠道号, 如果是IOS, 返回0
function GetCurChannelID()
    if not DRCSRef.MSDKTools.GetConfigChannel then
        return 0
    end
    local strID = DRCSRef.MSDKTools.GetConfigChannel()
    if (not strID) or (strID == "") then
        return 0
    end
    return tonumber(strID) or 0
end

-- 判断当前渠道是否允许显示项目自身信息(如QQ群号)
function JungCurCannelIDForOueExtraInfo()
    if not CAN_SHOW_OUR_EXTRA_INFO_CANNEL then
        return false
    end
    local iCurCannelID = GetCurChannelID()
    if (not iCurCannelID) or (iCurCannelID == 0) then
        return false
    end
    if CAN_SHOW_OUR_EXTRA_INFO_CANNEL[iCurCannelID] then
        return true
    end
    return false
end

function filter_spec_chars(s, contain)
    local ss = {}
    for k=1, #s do
		local c = string.byte(s,k)
		if not c then break end
		local keep = false
        if contain then
            for k1, v1 in pairs(contain) do
                if c == v1[1] then
                    local bTemp = true;
                    for i=2, #(v1) do
                        if string.byte(s,k+i-1) == v1[i] then
                            bTemp = bTemp and true;
                        else
                            bTemp = bTemp and false;
                        end
                    end
                    if bTemp then
                        keep = true;
                        k = k + #(v1) - 1;
                        table.insert(ss, string.char(table.unpack(v1)))
                        break;
                    end
                end
            end
		end
		if not keep then
			if (c>=48 and c<=57) or (c>= 65 and c<=90) or (c>=97 and c<=122) or (c==32) or (c==91) or (c==93) then
				table.insert(ss, string.char(c))
			elseif c>=228 and c<=233 then
				local c1 = string.byte(s,k+1)
				local c2 = string.byte(s,k+2)
				if c1 and c2 then
					local a1,a2,a3,a4 = 128,191,128,191
					if c == 228 then a1 = 184
					elseif c == 233 then a2,a4 = 190,c1 ~= 190 and 191 or 165
					end
					if c1>=a1 and c1<=a2 and c2>=a3 and c2<=a4 then
						k = k + 2
						table.insert(ss, string.char(c,c1,c2))
					end
				end
			end
		end
	end
	return table.concat(ss)
end

function timeLate(timestamp, fromTime, delayTime)
    local timeTable = os.date('*t', fromTime or os.time());
    local time = {
        year = timeTable.year, 
        month = timeTable.month,
        day = timeTable.day, 
        hour = 0, 
        min = 0, 
        sec = 0,
    };
    local secondOfToday = os.time(time);
    if (timestamp >= secondOfToday) and (timestamp < secondOfToday + delayTime) then
        return false;
    end
    return true;
end

function timeDay(timestamp, fromTime)
    local timeTable = os.date('*t', fromTime > 0 and fromTime or os.time());
    local time = {
        year = timeTable.year, 
        month = timeTable.month,
        day = timeTable.day, 
        hour = 0, 
        min = 0, 
        sec = 0,
    };
    local secondOfToday = os.time(time);
    return math.ceil(((g_ServerTime or timestamp) - secondOfToday) / (24 * 60 * 60));
end

function InTime(timestamp, fromTime, toTime)
    if not hours then
        hours = 24;
    end
    
    local today = os.date('*t');
    local time = {
        year = today.year, 
        month = today.month,
        day = today.day, 
        hour = fromTime[1], 
        min = fromTime[2], 
        sec = fromTime[3],
    };
    local secondOfToday = os.time(time);
    if (timestamp >= secondOfToday) and (timestamp < secondOfToday + toTime[1] * 60 * 60 + toTime[2] * 60 + toTime[3]) then
        return true;
    else
        return false;
    end
end

-- 返回日期所在的星期,0-6
function GetDayOfWeek(kTime)
    local today = os.date('*t',kTime)
    if (not today or not today.year or not today.month or not today.day) then
        return nil
    end

    local iCentruy = math.floor(today.year / 100)
    local iYear = today.year - iCentruy * 100
    local iMonth = today.month
    if (iMonth <= 2) then
        iMonth = iMonth + 12
        iYear = iYear - 1
    end

    local iTemp = math.floor(iCentruy / 4) - math.floor(2 * iCentruy) + iYear + math.floor(iYear / 4) + math.floor(13 * (iMonth + 1) / 5) + today.day - 1
    iTemp = math.floor(iTemp)
    while (iTemp < 0) do
        iTemp = iTemp + 7
    end

    return iTemp % 7
end

-- 判断两个日期是否是同一周
function IsDiffWeek(beginTime, endTime)
    endTime = endTime or 0
    beginTime = beginTime or 0
    local beginDay = os.date('*t', beginTime)
    local endDay = os.date('*t', endTime)
    if (not beginDay or not endDay) then
        return false
    end

    local beginWeekDay = GetDayOfWeek(beginTime)
    if (beginWeekDay == 0) then
        beginWeekDay = 7
    end

    local iSubDay = (endTime - beginTime) / (24 * 60 * 60)
    if (beginWeekDay + iSubDay > 7) then
        return true
    end

    return false
end

function IsOveredStory(uiStoryID)
	local playerinfo = globalDataPool:getData("PlayerInfo")
	if not playerinfo then return false end	-- 单机没有 info 数据
	for i = 0, playerinfo.iSize - 1 do
		if (playerinfo.kUnlockScriptInfos[i]["dwScriptID"] == uiStoryID) then
			if(playerinfo.kUnlockScriptInfos[i]["bGotFirstReward"] == 1) then
				return true
			end
		end
	end	
	return false
end

-- 获取当前服务器时间
function GetCurServerTimeStamp()
    local iCurTimeStamp = os.time()
    if not g_ServerTime then
        return iCurTimeStamp
    end
    if not g_ServerTimeRecordTimeStamp then
        return g_ServerTime
    end
    local iCurServerTimeStamp = g_ServerTime + iCurTimeStamp - g_ServerTimeRecordTimeStamp
    if iCurServerTimeStamp <= 0 then
        return g_ServerTime
    end
    return iCurServerTimeStamp
end

function Symbol()
    local symbol = {
        '·', 
        '—', 
        '‘', 
        '’', 
        '“', 
        '”', 
        '…', 
        '、', 
        '。', 
        '《', 
        '》', 
        '『', 
        '』', 
        '【', 
        '】', 
        '！', 
        '（', 
        '）', 
        '，', 
        '：', 
        '；', 
        '？',
        '￥',
    };
    local symbolTable = {};
    for i = 1, #(symbol) do
        local tempTable = {}
        for j = 1, #(symbol[i]) do
            table.insert(tempTable, string.byte(symbol[i], j));
        end
        table.insert(symbolTable, tempTable);
    end
    return symbolTable;
end

function CanOpenArena()
	local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
	local tbSysOpenData = TableDataManager:GetInstance():GetSystemOpenByType(SystemType.SYST_ARENA);
	for i = 1, #(tbSysOpenData) do
		if tbSysOpenData[i].OpenTime <= time and tbSysOpenData[i].Param1 == -1 then
			return true;
		end
	end 
	return false;
end

local EmergencyResetTip = {
    ['title'] = '提示',
    ['text'] = '系统检测到您操作异常，可能流程卡死，请问您是否要以当前游戏进度进入周目结算？进入周目结算界面将结束当前剧本的游戏进度，获得“兵家常事”结局，建议在游戏流程卡死时使用。要继续吗？',
    ['leftBtnText'] = '结束周目',
    ['rightBtnText'] = '再想想',
    ['leftBtnFunc'] = function()
        if GetGameState() ~= GS_WEEK_END then 
            ChangeScenceImmediately("Town", "LoadingUI", function()
                local data = EncodeSendSeGC_Click_Battle_GameEnd(0)
                local iSize = data:GetCurPos()
                NetGameCmdSend(SGC_CLICK_FORCE_WEEK_END, iSize, data)
            end)
        end
    end
}

-- 检查玩家无操作读档次数, 次数大于阈值弹出紧急窗口
function CheckNoPlayerCmdLoad(forceOpen)
    local curStoryID = GetCurScriptID()
    if curStoryID == 0 or curStoryID == nil then 
        return
    end
    local noPlayerCmdLoadCount = GetNoPlayerCmdLoadCount(curStoryID)
    if forceOpen or noPlayerCmdLoadCount >= MAX_NO_PLAYER_CMD_LOAD_COUNT then 
        ResetNoPlayerCmdLoadCount(curStoryID)
        -- 弹出紧急处理窗口
        ShowEmergencyWeekEndWindow()
    end
end

-- 弹出紧急周目结束窗口
function ShowEmergencyWeekEndWindow()
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.EMERGENCY_RESET, EmergencyResetTip, nil})
end

-- 设置玩家无操作读档标记
function SetNoPlayerCmdLoadFlag(storyID, setValue)
    storyID = storyID or GetCurScriptID()
    if not dnull(storyID) then 
        return
    end
    local playerID = globalDataPool:getData("PlayerID")
    if not dnull(playerID) then 
        return
    end
    local loadInfo = GetConfig('NoPlayerCmdLoadCount')
    if type(loadInfo) ~= 'table' then 
        loadInfo = {}
    end
    loadInfo[playerID] = loadInfo[playerID] or {}
    loadInfo[playerID][storyID] = loadInfo[playerID][storyID] or 0
    loadInfo[playerID][storyID] = loadInfo[playerID][storyID] + 1
    if type(setValue) == 'number' then 
        loadInfo[playerID][storyID] = setValue
    end
    SetConfig('NoPlayerCmdLoadCount', loadInfo, true)
end

-- 获取无操作读档次数
function GetNoPlayerCmdLoadCount(storyID)
    local loadInfo = GetConfig('NoPlayerCmdLoadCount')
    if type(loadInfo) ~= 'table' then 
        return 0
    end
    local playerID = globalDataPool:getData("PlayerID")
    if not dnull(playerID) then 
        return 0
    end
    loadInfo[playerID] = loadInfo[playerID] or {}
    return loadInfo[playerID][storyID] or 0
end

-- 重置玩家无操作读档标记
function ResetNoPlayerCmdLoadCount(storyID)
    storyID = storyID or GetCurScriptID()
    SetNoPlayerCmdLoadFlag(storyID, 0)
end

-- 重置所有跨天标记
function ResetAllDiffDayFlag()
    if not DIFF_DAY_FLAG_ENUMS then
        return
    end
    local kNewFlag = {}
    for enumName, enumValue in pairs(DIFF_DAY_FLAG_ENUMS) do
        kNewFlag[enumValue] = true
    end
    globalDataPool:setData("DiffDayFlag", kNewFlag, true)
end

-- 检查一个跨天标记
function CheckDiffDayFlag(enumValue)
    if not enumValue then
        return
    end
    local kFlag = globalDataPool:getData("DiffDayFlag") or {}
    return (kFlag[enumValue] == true)
end

-- 关闭一个跨天标记
function CloseDiffDayFlag(enumValue)
    if not enumValue then
        return
    end
    local kFlag = globalDataPool:getData("DiffDayFlag") or {}
    kFlag[enumValue] = nil
    globalDataPool:setData("DiffDayFlag", kFlag, true)
end

-- 获取当前剧本
function GetCurScriptID()
    -- globalDataPool:getData("CurScriptID") or 0
    return GetConfig('StoryID') or 1
end

-- 设置当前剧本
function SetCurScriptID(scriptID)
    -- globalDataPool:setData("CurScriptID", scriptID, true)
    SetConfig('StoryID', scriptID)
    
    local tileMap = GetUIWindow("TileBigMap")
    if tileMap then
        tileMap.init_pos = nil
    end
end

-- 检查当前场景的正确性
function CheckCurrentScene()
    if g_processDelStory then 
        return
    end
    local curStoryID = GetCurScriptID()
    if g_currentScene ~= 'Town' and g_currentScene ~= 'Maze' then 
        ChangeScenceImmediately('Town', 'LoadingUI')
    end
end

-- 中止进入剧本
local function StopEnterStory()
    -- QuitStory()
    RemoveWindowImmediately('LoadingUI')
    local generalBoxUI = GetUIWindow('GeneralBoxUI')
    if generalBoxUI then 
        generalBoxUI:CheckNextMsgOrExit()
    end
    SendStopEnterStory()
end
-- 进入剧本加载时间段回调
local l_enterStoryTip200msLangID = 569
local l_enterStoryTip5000msLangID = 570
local l_enterStoryTipTitleLangID = 571
local l_enterStoryTipButtonLangID = 572
local l_enterStoryTimerSetting = 
{
    {
        triggerTime = 200,
        callback = function()
            -- 显示排队弹窗
            local tips = GetLanguageByID(l_enterStoryTip200msLangID)
            OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
                text = tips,
                title = GetLanguageByID(l_enterStoryTipTitleLangID)
            }, nil, {cancel = false, close = false, confirm = false}})
        end
    },
    {
        triggerTime = 5000,
        callback = function()
            -- 显示排队弹窗, 允许中断排队
            local tips = GetLanguageByID(l_enterStoryTip5000msLangID)
            local generalBoxUI = OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
                text = tips,
                rightBtnText = GetLanguageByID(l_enterStoryTipButtonLangID),
                title = GetLanguageByID(l_enterStoryTipTitleLangID)
            }, StopEnterStory, {cancel = false, close = false, confirm = true}})
            if generalBoxUI then 
                generalBoxUI:CheckNextMsgOrExit()
            end
        end
    }
}
-- 进入剧本
function EnterStory(storyID, useLucky, directEnter, canStopEnter)
    if directEnter then 
        OpenWindowImmediately("LoadingUI")
    else
        local timerSetting = {}
        if canStopEnter then 
            timerSetting[1] = l_enterStoryTimerSetting[1]
            timerSetting[2] = l_enterStoryTimerSetting[2]
        else
            timerSetting[1] = l_enterStoryTimerSetting[1]
        end
        OpenWindowImmediately("LoadingUI", {
            timerSetting = timerSetting, 
            defaultBgColor = {
                a = 0
            }
        })
    end
    local gameMode = globalDataPool:getData("GameMode")
	-- 这里点击开始，单机模式下发送一条开始协议，不需要服务器进行转发了
	if (gameMode == nil or gameMode == "SingleMode") then
		TableDataManager:GetInstance():LoadInitTable()
		DRCSRef.LogicMgr:ResetLogicModule()
		local startScriptData,iCmd = EncodeSendSeGC_StartScript(storyID, 0, {})
		local iSize = startScriptData:GetCurPos()
        NetGameStartSend(SGC_CREATE_SCRIPT,iSize,startScriptData)
        
        -- local binData, iCmd = EncodeSendSeCGA_ScriptOpr(SEOT_ENTER, storyID, useLucky or 0 )
        -- NetGameStartSend(SGC_CREATE_SCRIPT, binData:GetCurPos(), binData)
	elseif (gameMode == "ServerMode") then
		TableDataManager:GetInstance():LoadInitTable()
		SendClickEnterStoryCMD(storyID, useLucky)
	end
    CardsUpgradeDataManager:GetInstance():RequestAllDatas(true)
end

-- 快速设置/获取Table数据
function GetInnerTable(tableData, ...)
    local data = tableData
    local argNames = {...}
    
    for index, argName in ipairs(argNames) do
        if type(data) ~= 'table' then
            return nil
        end
        if argName == nil then
            return nil
        end

        data = data[argName]
    end

    if type(data) ~= 'table' then
        return nil
    else
        return data
    end
end
function GetOrCreateInnerTable(tableData, ...)
    local data = tableData
    local argNames = {...}
    
    for index, argName in ipairs(argNames) do
        if type(data) ~= 'table' then
            return nil
        end
        if argName == nil then
            return nil
        end

        if data[argName] == nil then
            data[argName] = {}
        end
        data = data[argName]
    end

    if type(data) ~= 'table' then
        return nil
    else
        return data
    end
end
function GetInnerTableData(tableData, ...)
    local argNames = {...}
    if #argNames < 1 then
        return nil
    end

    local lastArgName = argNames[#argNames]
    argNames[#argNames] = nil

    local lastTable = GetInnerTable(tableData, table.unpack(argNames))
    if lastTable then
        return lastTable[lastArgName]
    end

    return nil
end

function SetInnerTableData(tableData, value, ...)
    local argNames = {...}
    if #argNames < 1 then
        return false
    end

    local lastArgName = argNames[#argNames]
    argNames[#argNames] = nil

    local lastTable = GetOrCreateInnerTable(tableData, table.unpack(argNames))
    if lastTable then
        lastTable[lastArgName] = value
        return true
    end

    return false
end

function UpdateSystemModuleEnableState(systemModuleEnableState)
    g_systemModuleEnableState = systemModuleEnableState
end

function IsModuleEnable(moduleType)
    if moduleType == nil or type(g_systemModuleEnableState) ~= 'table' then 
        return false
    end
    return g_systemModuleEnableState[moduleType]
end

function ShowSystemModuleDisableTip(moduleType)
    local text = SYSTEM_MODULE_DISABLE_TIP_TEXT or ''
    if DEBUG_MODE then 
        text = text .. '\n' .. tostring(moduleType)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, {
        text = text,
        rightBtnText = SYSTEM_MODULE_DISABLE_TIP_BTN_TEXT,
        title = SYSTEM_MODULE_DISABLE_TIP_TITLE
    }, nil, {cancel = false, close = false, confirm = true}})
end

function IsInDialog()
    --TODO:整理所有条件 别忘了把这些UI的WINDOW_ORDER_INFO的order调整至大于DialogControlUI的order
    local l_NotNeedDialogControlUIWindow={
        "DialogRecordUI",
        "GiveGiftDialogUI",
        "ClanMartialUI",
        "NpcConsultUI",
        "SpecialRoleIntroduceUI",
        "ObserveUI"
    }
    local flag = true
    for i=1,#l_NotNeedDialogControlUIWindow do
        if IsWindowOpen(l_NotNeedDialogControlUIWindow[i]) then
            flag=false
        end
    end

    return (IsWindowOpen("DialogUI") or IsWindowOpen("DialogChoiceUI") or IsWindowOpen("DialogControlUI")) and flag
end

function IsNotInGuide()
    return not IsWindowOpen("GuideUI")
end

function IsInGuide()
    return IsWindowOpen("GuideUI")
end

function OpenOnlineShop()
    local url
    if WEGAME then
        url = ""
    else
        url = "https://store.steampowered.com/app/1471180"
    end
    if url and url ~= "" then
        CS.UnityEngine.Application.OpenURL(url);
    end
end

function IsAnyWindowOpen(wins)
    for i = 1,#wins do
        if IsWindowOpen(wins[i]) then
            return true
        end
    end
    return false
end

--设置文本高亮
function SetTextHighLight(obj)
	local objText = obj:FindChild("Text")
	local comText = objText:GetComponent("Text")
	local outlineEx = objText:GetComponent("OutlineEx")
	comText.color = COLOR_VALUE[COLOR_ENUM.White]
	outlineEx.OutlineWidth = 2
end

--设置文本默认状态
function SetTextDefault(obj)
	local objText = obj:FindChild("Text")
	local comText = objText:GetComponent("Text")
	local outlineEx = objText:GetComponent("OutlineEx")
	comText.color = COLOR_VALUE[COLOR_ENUM.Black]
	outlineEx.OutlineWidth = 0
end

function SetUIActionHandle(uiAction)
	if uiAction then
		uiAction:SetPointerEnterAction(function()
			SetTextHighLight(uiAction.gameObject)
		end)

		uiAction:SetPointerExitAction(function()
			SetTextDefault(uiAction.gameObject)
		end)
	end
end

-- 强制退出游戏
function ForceQuitGame(delay, title, text)
    local info = {
        ["title"] = title,
        ['leftBtnText'] = '退出游戏',
        ['leftBtnFunc'] = QuitGame,
        ['text'] = text or '',
    }
    g_forceQuit = true
    ResetGame()
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, info, nil, {cancel = true}})
    if delay >= 0 then 
        globalTimer:AddTimer(delay, QuitGame)
    end
end
--用于数量框支持输入，使用可参考StoreUI中的用法
function BindInputFieldAndText(AddButtonClickListener,comNumberBtn,comNumberInputField,comNumberText,getMaxNum,updateUI,canBeZero)
    if comNumberBtn then
        AddButtonClickListener(comNumberBtn,function()
            comNumberText.gameObject:SetActive(false)
            comNumberInputField.text = string.match(comNumberText.text,"%d+")
            comNumberInputField.gameObject:SetActive(true)
            comNumberInputField:ActivateInputField()
            globalTimer:AddTimer(100, function()
                comNumberInputField:Select()
                comNumberInputField:MoveTextEnd()
            end)
            
        end)
    end
    if comNumberInputField then
        comNumberInputField.onEndEdit:AddListener(function()
            local curRemainNum = getMaxNum()
            local curNumber =  tonumber(comNumberInputField.text)
            if curNumber and curNumber > curRemainNum then
                curNumber = curRemainNum
            elseif curNumber and curNumber <= 0 then
                curNumber = canBeZero and 0 or 1
            elseif not curNumber then
                if canBeZero then
                    curNumber = 0
                else
                    curNumber = 1                
                end
            end
            comNumberInputField.text = tostring(curNumber)     
            updateUI(tonumber(comNumberInputField.text),curRemainNum)
        end)
    end
end

--支持修改的按键走KeyboardManager的按键检测
function FuncType2KeyCode(FuncType)
    return KeyboardManager:GetInstance():GetKeyCodeByFuncName(FuncType)
end

function GetKeyByFuncType(funcType)
    local condition = KeyboardManager:GetInstance().ShortcutInvalidTable[funcType]
    if condition and condition() then
        return false
    end
    local keycode = FuncType2KeyCode(funcType)
    return KeyboardManager:GetInstance():GetKey(keycode)
end

function GetKeyDownByFuncType(funcType)
    local condition = KeyboardManager:GetInstance().ShortcutInvalidTable[funcType]
    if condition and condition() then
        return false
    end
    local keycode = FuncType2KeyCode(funcType)
    return KeyboardManager:GetInstance():GetKeyDown(keycode)
end

--- 用于刷新快捷键的tips
-- @Text comText Tips的text组件 
-- @string str 快捷键tips的前缀 
-- @FuncType funcType 按键别名的FuncType索引 
function RefreshTipsText(comText,str,funcType)
    comText.text = str
    local keyCodeName = KeyCodeName[FuncType2KeyCode(funcType)]
    if keyCodeName and keyCodeName ~= "无" then
        comText.text = comText.text .. "(" .. keyCodeName .. ")"
    end
end

local MouseButtonKeyCode={
   "mouse 1",
   "mouse 2",
   "mouse 3",
   "mouse 4",
   "mouse 5",
   "mouse 6",
}

function IsMouseButton(curKeyCode)
    for i = 1,6 do
        if curKeyCode==MouseButtonKeyCode[i] then
            return true
        end
    end
    return false
end

local HUDUIs = {
    "NavigationUI",
    "ToptitleUI",
    "TaskTipsUI",
    "CharacterUI",
    "MiniMapUI"
}
local HUDWindow = {}
local count = 0
function HideAllHUD()
    count = count - 1
    if count <= 0 then
        for i  = 1,#HUDUIs do
            local uiWindow = GetUIWindow(HUDUIs[i])
            if IsWindowOpen(HUDUIs[i]) then      
            if uiWindow then
                HUDWindow[HUDUIs[i]] = uiWindow
                uiWindow._gameObject:GetComponent("CanvasGroup").alpha = 0
            end 
            end
            if HUDUIs[i] == "CharacterUI" and uiWindow then
                uiWindow:HideSpine()
            end
            
        end
    end
end
function ShowAllHUD()
    count = count + 1
    if count >= 0 then
        for i  = 1,#HUDUIs do
            local uiWindow = GetUIWindow(HUDUIs[i])
            if IsWindowOpen(HUDUIs[i]) then   
            if uiWindow then
                uiWindow._gameObject:GetComponent("CanvasGroup").alpha = 1
            end
            end
            if HUDUIs[i] == "CharacterUI" and uiWindow then
                uiWindow:ShowSpine()
            end
        end
    end
end

function GetHelperInfo(roleTypeID)
    local info = {}
    info.roleName = RoleDataManager:GetInstance():GetRoleNameByTypeID(roleTypeID) or ""
    info.showContent = {
        ['title'] = "系统提示",
        ['text'] = "【"..info.roleName.."】正作为下场战斗的帮手助阵，成功号召其他角色后".."【"..info.roleName.."】将被替换为该角色，是否继续？",
        ['leftBtnText'] = '取消',
        ['rightBtnText'] = '确定',
    }
    return info
end


-- Todo 重写成C#做进text组件中
function StringLimitWithTag(str,iLimitLength)
    local result = 0
    local sFinalStr = ""
    local lenInByte = string.len(str)
    local i = 1
    local stat=""
    local tagString=""
    local stack={}
    local bIgnore=false
    while i<=lenInByte do
        local curByte = string.byte(str, i)
        local byteCount = 1;
        if curByte>0 and curByte<=127 then
            byteCount = 1
        elseif curByte>=192 and curByte<223 then
            byteCount = 2
        elseif curByte>=224 and curByte<239 then
            byteCount = 3
        elseif curByte>=240 and curByte<=247 then
            byteCount = 4
        end
        local arg = string.sub(str, i, i+byteCount-1)
        if stat=="" then
            if arg=="<" then
                stat = "<"
                bIgnore=true
            end
        elseif stat=="<" then
            if arg=="/" then
                stat="Tag2"
                tagString=""
            elseif arg~=" " then
                stat="Tag1"
                tagString=arg
            end
        elseif stat=="Tag1" then
            if arg==" " or arg=="=" then
                stack[#stack+1]=tagString
                stat=""
            else
                tagString=tagString..arg
            end
        elseif stat=="Tag2" then
            if arg==" " or arg==">" then
                if stack[#stack]==tagString then
                    table.remove(stack)
                    stat=""
                end
            else
                tagString=tagString..arg
            end
        end
        if not bIgnore then
            if byteCount == 1 then 
                result = result + 1
            else
                result = result + 2
            end
        end
        if result > iLimitLength then
            if #stack > 0 then
                for i = #stack,1,-1 do
                    sFinalStr = sFinalStr.."</"..stack[i]..">"
                end
            end
            return sFinalStr
        else
            sFinalStr = sFinalStr..arg
        end
        i = i + byteCount
        if arg==">" then
            bIgnore=false
        end
    end
    return sFinalStr
end

function CloseCityRoleListUI()
    local win = GetUIWindow("CityRoleListUI")
    if win and win.boolean_expand then
        win:OnClick_Button()
    end
end

function TipsQuitGame()
    if not bQuitGame then
        bQuitGame = true
        local content = {
            ['title'] = "系统提示",
            ['text'] = "是否退出游戏",
            ['leftBtnFunc'] = function()
                bQuitGame = false
            end
        }
        local callback = function()
            bQuitGame = false
            DRCSRef.LuaBehaviour.RemoveQuit()
            SendClickQuitGameCMD()
            globalTimer:AddTimer(2000, function()
                QuitGame()
            end)
        end
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, content, callback})  
    end
end