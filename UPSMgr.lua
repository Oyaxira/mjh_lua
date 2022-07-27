UPSMgr = {}

local getNet = function()
    local iNetState = CS.UnityEngine.Application.internetReachability
    if iNetState == CS.UnityEngine.NetworkReachability.NotReachable then
        return 0
    elseif iNetState == CS.UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
        return 1
    elseif iNetState == CS.UnityEngine.NetworkReachability.ReachableViaLocalAreaNetwork then
        return 2
    end
end

--iDisconnectType 0 重连 1 服务器主动断开连接 2 scoket 超时  3主动断开
--iReasonType 0 主动调用的断开	1 系统底层返回该连接失败 1000 服务器T人 --10000不详		
function UPSMgr:ReportDisconnect(iDisconnectType,iReasonType)
    local url = "upsapi.17m3.com/reconnect?appid=1464096843&data="
    
    local zone = tostring(GetConfig("LoginZone")) --大区
    local strServerKey = string.format("LoginServer_%s", zone)
    local server = tostring(GetConfig(strServerKey))  --服务器
    local playerid = tostring(globalDataPool:getData("PlayerID")) -- playerid
    local iGameState  = tostring(GetGameState()) --当前场景
    local bIsBattle = tostring(IsBattleOpen() == true and 1 or 0) --是否战斗中 
    local disconnectType = tostring(iDisconnectType)
    local disconnectReason = tostring(iReasonType or 10000)
    local host = tostring(globalDataPool:getData("GameServerHost"))
    local port = tostring(globalDataPool:getData("GameServerPort"))
    local iNet = tostring(getNet())

    url = url..zone..","..server..","..playerid..","..iGameState..","..bIsBattle..","..disconnectType..","..disconnectReason..","..host..","..port..","..iNet
    HttpHelper:HttpGet(url)  
end

--iConnectType 1 登陆服 2游戏服
function UPSMgr:ReportConnectSeverfail(iConnectType)
    local url = "upsapi.17m3.com/connectSeverfail?appid=1464096843&data="

    local playerid = tostring(globalDataPool:getData("PlayerID")) -- playerid
    local host = ""
    local port = ""
    if iConnectType == 1 then
        host = DEFAULT_IP
        port = DEFAULT_PORT
    else
        host = tostring(globalDataPool:getData("GameServerHost"))
        port = tostring(globalDataPool:getData("GameServerPort"))
    end
    local iNet = tostring(getNet())

    url = url..playerid..","..host..","..port..","..tostring(iConnectType)..","..iNet
    HttpHelper:HttpGet(url)  
end

-- iType:
-- 1缺少区服信息 
-- 2账号信息错误 
-- 3区服登陆失败 
function UPSMgr:ReportLoginfail(iType,iParam)
    local url = "upsapi.17m3.com/loginfail?appid=1464096843&data="
    local playerid = tostring(globalDataPool:getData("PlayerID") or -1) 
    local zone = tostring(GetConfig("LoginZone") or -1)  --大区
    iParam = iParam or -1
    local systemInfo = DRCSRef.GameConfig:GetSystemInfo()
    local _,deviceID = systemInfo:TryGetValue('deviceUId')
    deviceID = tostring((deviceID or 'Error Device'))
    url = url..playerid..","..deviceID..","..zone..","..iType..","..iParam
    HttpHelper:HttpGet(url)  
end