local dkJson = require("Base/Json/dkjson")
local _stream_record = {}

-- package.path = "E:/DreamRivakes/trunk/ClientPublish/Bin/Assets/Resources/LuaProject/Base/LuaPanda/LuaPanda.lua.txt;"..package.path
-- dprint(package.path)
-- local lp = require "LuaPanda"

-- lbase64加密和解密算法
local function encodeBase64(source_str)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local s64 = ''
    local str = source_str

    while #str > 0 do
        local bytes_num = 0
        local buf = 0

        for byte_cnt=1,3 do
            buf = (buf * 256)
            if #str > 0 then
                buf = buf + string.byte(str, 1, 1)
                str = string.sub(str, 2)
                bytes_num = bytes_num + 1
            end
        end

        for group_cnt=1,(bytes_num+1) do
            local b64char = math.fmod(math.floor(buf/262144), 64) + 1
            s64 = s64 .. string.sub(b64chars, b64char, b64char)
            buf = buf * 64
        end

        for fill_cnt=1,(3-bytes_num) do
            s64 = s64 .. '='
        end
    end

    return s64
end

local function decodeBase64(str64)
    local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local temp={}
    for i=1,64 do
        temp[string.sub(b64chars,i,i)] = i
    end
    temp['=']=0
    local str=""
    for i=1,#str64,4 do
        if i>#str64 then
            break
        end
        local data = 0
        local str_count=0
        for j=0,3 do
            local str1=string.sub(str64,i+j,i+j)
            if not temp[str1] then
                return
            end
            if temp[str1] < 1 then
                data = data * 64
            else
                data = data * 64 + temp[str1]-1
                str_count = str_count + 1
            end
        end
        for j=16,0,-8 do
            if str_count > 0 then
                str=str..string.char(math.floor(data/math.pow(2,j)))
                data=math.mod(data,math.pow(2,j))
                str_count = str_count - 1
            end
        end
    end

    local last = tonumber(string.byte(str, string.len(str), string.len(str)))
    if last == 0 then
        str = string.sub(str, 1, string.len(str) - 1)
    end
    return str
end

function _stream_record.open_file()
    -- _stream_record.file = io.open("./user_action_record", "w+b")
    _stream_record.file = io.open("./user_action_record.json", "w+")
    _stream_record.file:write('{"list":[')
    g_isFirstLine = true
end

function _stream_record.close_file()
    if _stream_record.file then
        _stream_record.file:write(']}')
        io.close(_stream_record.file)
    end
end

function _stream_record.write_file(streamData)
    if _stream_record.file and streamData:GetCurPos() > 0 then
        local binData = string.sub(streamData:GetData(),1,streamData:GetCurPos())
        _stream_record.file:write(binData)
        _stream_record.file:flush()
        -- dwarning(string.format("[StreamRecord]->%d,%d,EnCode64Data:%s",#binData, streamData:GetCurPos(), lp.tools.base64encode(string.sub(binData,5,-1))))
    end
end

local function _get_cmd_name(cmdID)
    for k, v in pairs(_G) do 
        if type(k) == 'string' and type(v) == 'number' then 
            if string.find(k, 'SGC_CLICK_') then 
                if v == cmdID then 
                    return k
                end
            end
        end
    end
    return ''
end

local l_skipWaitMsg = {
    [SGC_CLICK_SELECT_ZHUAZHOU] = true,
    [SGC_CLICK_TRY_INTERACT_WITH_NPC] = true,
    [SGC_CLICK_CLEAR_INTERACT_INFO] = true,
    [SGC_CLICK_MAP] = true,
    [SGC_CLICK_CHEAT] = true,
    [SGC_CLICK_NPC] = true,
    [SGC_CLICK_PICKUP_ADVLOOT] = true,
    [SGC_CLICK_BATTLE_WIN] = true,
}
function _stream_record.write_json_file(encodeCache, streamData, msgType)
    if _stream_record.file and type(encodeCache) == 'table' then
        local data = streamData:GetData()
        local binData = string.sub(streamData:GetData(),1,streamData:GetCurPos())
        local data = {
            pid = msgType,
            gameCmdPid = g_cmdTypeCache,
            gameCmdName = _get_cmd_name(g_cmdTypeCache),
            payload = encodeBase64(binData),
            skipWaitMsg = l_skipWaitMsg[g_cmdTypeCache]
        }
        local str = dkJson.encode(data)
        if not g_isFirstLine then 
            str = ',' .. str
        else
            g_isFirstLine = false
        end
        _stream_record.file:write(str)
        _stream_record.file:flush()
    end
end

-- _stream_record.open_file()

return _stream_record;
