-- auto make by Tool ProtocolMaker don't modify anything!!!
function EncodeSendSeCL_PlayerLogin(dwMSangoMagic,kVersion,bForceKick,acAccount,acPassword,acDeviceIdentify)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCL_PlayerLogin'
		g_encodeCache['dwMSangoMagic'] = dwMSangoMagic
		g_encodeCache['kVersion'] = kVersion
		g_encodeCache['bForceKick'] = bForceKick
		g_encodeCache['acAccount'] = acAccount
		g_encodeCache['acPassword'] = acPassword
		g_encodeCache['acDeviceIdentify'] = acDeviceIdentify
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(dwMSangoMagic)
	kNetStream:WriteByte(kVersion["byMain"])
	kNetStream:WriteByte(kVersion["bySub1"])
	kNetStream:WriteByte(kVersion["bySub2"])
	kNetStream:WriteByte(kVersion["bySub3"])
	kNetStream:WriteByte(bForceKick)
	kNetStream:WriteString(acAccount)
	kNetStream:WriteString(acPassword)
	kNetStream:WriteString(acDeviceIdentify)
	return kNetStream,553
end

function EncodeSendSeCL_PlayerLogin_NEW(iPlatFlag,dwVersion,bForceKick,acAccount,acAccountID,acLoginType,acToken,acMobileInfo,iRegionID,dwWorldConfigID)
	if DEBUG_MODE then
		g_encodeCache = {}
		g_encodeCache['$Name'] = 'SeCL_PlayerLogin_NEW'
		g_encodeCache['iPlatFlag'] = iPlatFlag
		g_encodeCache['dwVersion'] = dwVersion
		g_encodeCache['bForceKick'] = bForceKick
		g_encodeCache['acAccount'] = acAccount
		g_encodeCache['acAccountID'] = acAccountID
		g_encodeCache['acLoginType'] = acLoginType
		g_encodeCache['acToken'] = acToken
		g_encodeCache['acMobileInfo'] = acMobileInfo
		g_encodeCache['iRegionID'] = iRegionID
		g_encodeCache['dwWorldConfigID'] = dwWorldConfigID
	end
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(iPlatFlag)
	kNetStream:WriteInt(dwVersion)
	kNetStream:WriteByte(bForceKick)
	kNetStream:WriteString(acAccount)
	kNetStream:WriteString(acAccountID)
	kNetStream:WriteString(acLoginType)
	kNetStream:WriteString(acToken)
	kNetStream:WriteString(acMobileInfo)
	kNetStream:WriteInt(iRegionID)
	kNetStream:WriteInt(dwWorldConfigID)
	return kNetStream,530
end

