-- auto make by Tool ProtocolMaker don't modify anything!!!
function EncodeSendSeLC_EncryptKey(abyEncryptKey)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeLC_EncryptKey'
		g_encodeCache['abyEncryptKey'] = abyEncryptKey
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(abyEncryptKey)
	return kNetStream,8233
end

function EncodeSendSeLC_PlayerLoginRet(defPlayerID,eReason,dwSessionID,dwAreaID,acClientIP)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeLC_PlayerLoginRet'
		g_encodeCache['defPlayerID'] = defPlayerID
		g_encodeCache['eReason'] = eReason
		g_encodeCache['dwSessionID'] = dwSessionID
		g_encodeCache['dwAreaID'] = dwAreaID
		g_encodeCache['acClientIP'] = acClientIP
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteDword64(defPlayerID)
	kNetStream:WriteInt(eReason)
	kNetStream:WriteInt(dwSessionID)
	kNetStream:WriteInt(dwAreaID)
	kNetStream:WriteString(acClientIP)
	return kNetStream,8210
end

function EncodeSendSeLC_GateList(acIP,iPort,acHost)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeLC_GateList'
		g_encodeCache['acIP'] = acIP
		g_encodeCache['iPort'] = iPort
		g_encodeCache['acHost'] = acHost
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteString(acIP)
	kNetStream:WriteInt(iPort)
	kNetStream:WriteString(acHost)
	return kNetStream,8249
end

