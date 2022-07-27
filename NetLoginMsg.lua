reloadModule("Net/Auto/LC_Decode")
reloadModule("Net/Auto/CL_Encode")
local dkJson = require("Base/Json/dkjson")
local HttpHelper = require("Net/NetHttpHelper")

-- function pool to process the login msg
local NetLoginMsgProcFuncPool = {}
-- to InitLoginMsg
function InitLoginMsg()
    -- to register the encode and decode cmd function
    registerLSToCLCommand()

    -- to register Login Msg Proc function
    registerLoginCommand(CMD_LC_PLAYERLOGINRET, OnRecv_LC_PlayerLoginRet)
    registerLoginCommand(CMD_LC_GATELIST, OnRecv_LC_GateList)
end

function registerLoginCommand(iCmd, ProcFunc)
    NetLoginMsgProcFuncPool[iCmd] = ProcFunc
end

function removeLoginCommand(iCmd)
    NetLoginMsgProcFuncPool[iCmd] = nil
end

function OnNetLoginMsg(iCmd, netStreamValue)
    dprint("[NetLoginMsg]->OnNetLoginMsg LoginMsg iCmd:" .. iCmd .. "-----")
    local fDecodeFunc = GetLSToCLDecodeFuncByCmd(iCmd)
    if fDecodeFunc ~= nil then
        local kRetData = fDecodeFunc(netStreamValue)
        if NetLoginMsgProcFuncPool[iCmd] ~= nil then
            NetLoginMsgProcFuncPool[iCmd](kRetData)
        end
    end
end

function OnLoginNetConnected()
    local accountid = globalDataPool:getData("AccountID")
    local password = globalDataPool:getData("Password")
    local msangoMagic = SERVER_MAGIC_VALUE
    local kVersion = CommonTable_SeCheckVersion
    local binData, iCmd = EncodeSendSeCL_PlayerLogin(msangoMagic,kVersion,false,accountid,password,"123")
    SendPackageToNet(CS.GameApp.E_NETTYPE.NET_LOGINSERVER, iCmd, binData);
end

function OnLoginNetDisConnected()
    dprint("[NetLoginMsg]->OnLoginNetDisConnected")
end

function OnLoginNetTimeOut()
    dprint("[NetLoginMsg]->OnLoginNetTimeOut")
    SystemUICall:GetInstance():WarningBox("服务器登录连接超时,请稍后再试")
    UPSMgr:ReportConnectSeverfail(1)
end

function OnRecv_LC_PlayerLoginRet(kRetData)
    if kRetData.eReason == 0 then
        globalDataPool:setData("SessionID", kRetData["dwSessionID"], true)
    else
        dprint("eReason ",kRetData.eReason)
    end
end

function OnRecv_LC_GateList(kRetData)
    dprint(string.format("[NetLoginMsg]->OnRecv_LC_GateList,acIP:%s,iPort:%d",kRetData["acIP"],kRetData["iPort"]))
    DRCSRef.NetMgr:Connect(CS.GameApp.E_NETTYPE.NET_TOWNSERVER,kRetData["acIP"],kRetData["iPort"])
end

--------------------------------------------

-----------------公共登录服------------------
function GlobalPublicLoginValidate(channel, uid, token, platformos,chanid)
    local accountid = globalDataPool:getData("AccountID")
    local password = globalDataPool:getData("Password")
    local data = {
        channel = channel,
        uid = tostring(uid),
        token = tostring(token),
        extends = {
            os = tostring(platformos) or "",
            chanId = tostring(chanid) or "",
        }
    }   
    local jsondata = dkJson.encode(data)
    HttpHelper:PublicLoginValidate(jsondata)
end

-- 查询公共服
function QueryLoginValidate()
	local channelID = SPLCT_TENCENT
	local sAccount = MSDKHelper:GetOpenID()
	local sToken = MSDKHelper:GetToken()
	if (sAccount == nil) then
		dprint("error, sAccount == nil")
		return
	end

	if (sToken == nil) then
		dprint("error, sToken == nil")
		return
	end

	local extendsChannelID = 0
	local channel = MSDKHelper:GetChannel()
	if (channel == "WeChat") then
		extendsChannelID = 1
	elseif (channel == "QQ") then
    	extendsChannelID = 2
    elseif (channel == "Guest") then
        extendsChannelID = 3
    elseif (channel == "Apple") then
    	extendsChannelID = 15	
	end	
	GlobalPublicLoginValidate(channelID, sAccount, sToken, MSDK_OS, extendsChannelID )
end

function Send_EnterGame()
    local bAllowLogin, strErrorMsg = PlayerSetDataManager:GetInstance():CheckIfCanLogin()
	if bAllowLogin == false then
        SystemUICall:GetInstance():Toast(strErrorMsg or "")
        RemoveWindowImmediately("ChatBoxUI")
		return false
	end

    local bRes = true
	local serverList = globalDataPool:getData("LoginServerList")
    local zone = tostring(GetConfig("LoginZone") or DEFAULT_SERVERINDEX)
    local strServerKey = string.format("LoginServer_%s", zone)
	local server = tostring(GetConfig(strServerKey) or DEFAULT_SERVERNAME)
    local bSelectRes = HttpHelper:SelectPublicLoginServer(tostring(zone), server)
    if bSelectRes == false then
        bRes = false
    end
    globalDataPool:setData("online", "true")
    
    return bRes
end
