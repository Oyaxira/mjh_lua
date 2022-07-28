-- auto make by Tool ProtocolMaker don't modify anything!!!
local CmdLSToCLDecodeTable = {}

--------  the cmd type to iCmd code--------------------------
CMD_LC_ENCRYPTKEY = 8233
CMD_LC_PLAYERLOGINRET = 8210
CMD_LC_GATELIST = 8249
--------------------------------------------------------------
function registerLSToCLCommand()
	CmdLSToCLDecodeTable[CMD_LC_ENCRYPTKEY] = Decode_SeLC_EncryptKey
	CmdLSToCLDecodeTable[CMD_LC_PLAYERLOGINRET] = Decode_SeLC_PlayerLoginRet
	CmdLSToCLDecodeTable[CMD_LC_GATELIST] = Decode_SeLC_GateList
end

function GetLSToCLDecodeFuncByCmd(iCmd)
	if CmdLSToCLDecodeTable[iCmd] ~= nil then
		return CmdLSToCLDecodeTable[iCmd]
	else
		return nil
	end
end

function Decode_SeLC_EncryptKey(netStreamValue)
	local result = { ["abyEncryptKey"] = nil,} 
	result["abyEncryptKey"] = netStreamValue:ReadString()
	return result
end

function Decode_SeLC_PlayerLoginRet(netStreamValue)
	local result = { ["defPlayerID"] = 0,["eReason"] = LFR_SUCCESS,["dwSessionID"] = 0,["dwAreaID"] = 0,["acClientIP"] = nil,} 
	result["defPlayerID"] = netStreamValue:ReadDword64()
	result["eReason"] = netStreamValue:ReadInt()
	result["dwSessionID"] = netStreamValue:ReadInt()
	result["dwAreaID"] = netStreamValue:ReadInt()
	result["acClientIP"] = netStreamValue:ReadString()
	return result
end

function Decode_SeLC_GateList(netStreamValue)
	local result = { ["acIP"] = nil,["iPort"] = 0,["acHost"] = nil,} 
	result["acIP"] = netStreamValue:ReadString()
	result["iPort"] = netStreamValue:ReadInt()
	result["acHost"] = netStreamValue:ReadString()
	return result
end

