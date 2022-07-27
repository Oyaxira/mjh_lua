-- auto make by Tool ProtocolMaker don't modify anything!!!
local CmdCLToLSDecodeTable = {}

--------  the cmd type to iCmd code--------------------------
CMD_CL_PLAYERLOGIN = 553
CMD_CL_PLAYERLOGIN_NEW = 530
--------------------------------------------------------------
function registerCLToLSCommand()
	CmdCLToLSDecodeTable[CMD_CL_PLAYERLOGIN] = Decode_SeCL_PlayerLogin
	CmdCLToLSDecodeTable[CMD_CL_PLAYERLOGIN_NEW] = Decode_SeCL_PlayerLogin_NEW
end

function GetCLToLSDecodeFuncByCmd(iCmd)
	if CmdCLToLSDecodeTable[iCmd] ~= nil then
		return CmdCLToLSDecodeTable[iCmd]
	else
		return nil
	end
end

function Decode_SeCL_PlayerLogin(netStreamValue)
	local result = { ["dwMSangoMagic"] = SSD_MSANGO_MAGIC,["kVersion"] = nil,["bForceKick"] = true,["acAccount"] = nil,["acPassword"] = nil,["acDeviceIdentify"] = nil,} 
	result["dwMSangoMagic"] = netStreamValue:ReadInt()
	result["kVersion"] = {["byMain"] = 1,["bySub1"] = 0,["bySub2"] = 0,["bySub3"] = 23,}
		result["kVersion"]["byMain"] = netStreamValue:ReadByte()
		result["kVersion"]["bySub1"] = netStreamValue:ReadByte()
		result["kVersion"]["bySub2"] = netStreamValue:ReadByte()
		result["kVersion"]["bySub3"] = netStreamValue:ReadByte()
	result["bForceKick"] = netStreamValue:ReadByte()
	result["acAccount"] = netStreamValue:ReadString()
	result["acPassword"] = netStreamValue:ReadString()
	result["acDeviceIdentify"] = netStreamValue:ReadString()
	return result
end

function Decode_SeCL_PlayerLogin_NEW(netStreamValue)
	local result = { ["iPlatFlag"] = 0,["dwVersion"] = 0,["bForceKick"] = true,["acAccount"] = nil,["acAccountID"] = nil,["acLoginType"] = nil,["acToken"] = nil,["acMobileInfo"] = nil,["iRegionID"] = 0,["dwWorldConfigID"] = 0,} 
	result["iPlatFlag"] = netStreamValue:ReadInt()
	result["dwVersion"] = netStreamValue:ReadInt()
	result["bForceKick"] = netStreamValue:ReadByte()
	result["acAccount"] = netStreamValue:ReadString()
	result["acAccountID"] = netStreamValue:ReadString()
	result["acLoginType"] = netStreamValue:ReadString()
	result["acToken"] = netStreamValue:ReadString()
	result["acMobileInfo"] = netStreamValue:ReadString()
	result["iRegionID"] = netStreamValue:ReadInt()
	result["dwWorldConfigID"] = netStreamValue:ReadInt()
	return result
end

