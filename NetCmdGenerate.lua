local _netStreamPool = {}

local l_table_remove = table.remove
local l_table_insert = table.insert

local sr = require "Base/StreamRecord"

BIT_MASK_1 = 1
BIT_MASK_2 = BIT_MASK_1 << 1 + 1 
BIT_MASK_3 = BIT_MASK_2 << 1 + 1 
BIT_MASK_4 = BIT_MASK_3 << 1 + 1 
BIT_MASK_5 = BIT_MASK_4 << 1 + 1 
BIT_MASK_6 = BIT_MASK_5 << 1 + 1 
BIT_MASK_7 = BIT_MASK_6 << 1 + 1 
BIT_MASK_8 = BIT_MASK_7 << 1 + 1 
BIT_MASK_9 = BIT_MASK_8 << 1 + 1 
BIT_MASK_10 = BIT_MASK_9 << 1 + 1 
BIT_MASK_11 = BIT_MASK_10 << 1 + 1 
BIT_MASK_12 = BIT_MASK_11 << 1 + 1 
BIT_MASK_13 = BIT_MASK_12 << 1 + 1 
BIT_MASK_14 = BIT_MASK_13 << 1 + 1 
BIT_MASK_15 = BIT_MASK_14 << 1 + 1 
BIT_MASK_16 = BIT_MASK_15 << 1 + 1 
BIT_MASK_17 = BIT_MASK_16 << 1 + 1 
BIT_MASK_18 = BIT_MASK_17 << 1 + 1 
BIT_MASK_19 = BIT_MASK_18 << 1 + 1 
BIT_MASK_20 = BIT_MASK_19 << 1 + 1 
BIT_MASK_21 = BIT_MASK_20 << 1 + 1 
BIT_MASK_22 = BIT_MASK_21 << 1 + 1 
BIT_MASK_23 = BIT_MASK_22 << 1 + 1 
BIT_MASK_24 = BIT_MASK_23 << 1 + 1 
BIT_MASK_25 = BIT_MASK_24 << 1 + 1 
BIT_MASK_26 = BIT_MASK_25 << 1 + 1 
BIT_MASK_27 = BIT_MASK_26 << 1 + 1 
BIT_MASK_28 = BIT_MASK_27 << 1 + 1 
BIT_MASK_29 = BIT_MASK_28 << 1 + 1 
BIT_MASK_30 = BIT_MASK_29 << 1 + 1 
BIT_MASK_31 = BIT_MASK_30 << 1 + 1 
BIT_MASK_32 = -1

BIT_MASK_ARRAY = {
      BIT_MASK_1,BIT_MASK_2,BIT_MASK_3,BIT_MASK_4,BIT_MASK_5,BIT_MASK_6,BIT_MASK_7,BIT_MASK_8,
      BIT_MASK_9,BIT_MASK_10,BIT_MASK_11,BIT_MASK_12,BIT_MASK_13,BIT_MASK_14,BIT_MASK_15,BIT_MASK_16,
      BIT_MASK_17,BIT_MASK_18,BIT_MASK_19,BIT_MASK_20,BIT_MASK_21,BIT_MASK_22,BIT_MASK_23,BIT_MASK_24,
      BIT_MASK_25,BIT_MASK_26,BIT_MASK_27,BIT_MASK_28,BIT_MASK_29,BIT_MASK_30,BIT_MASK_31,BIT_MASK_32
}

local function fromPool()
	local kNetStream = nil
	if #_netStreamPool > 0 then
		kNetStream = l_table_remove(_netStreamPool)
	else
		kNetStream = CS.GameApp.SeNetStream()
	end

	if #_netStreamPool > 10 then
		showError("Top Warning!\nSend cmd too frequently.\nNetStreamPool is too big.")
	end
	kNetStream:InitData()
	return kNetStream
end

local function toPool(netStream)
	l_table_insert(_netStreamPool, netStream)
end

-- count bit from left to right, begin value is 1, end value is 32
local function GetValueByBit(value, from, to)
      local highMask = BIT_MASK_ARRAY[32 - from + 1]
      value =  value & highMask
      
      local leftBit = 32 - to
      local bitLength = to - from + 1
      local shiftedValue = value >>  leftBit
      return  shiftedValue & BIT_MASK_ARRAY[bitLength]
end

function FormValueByBit(...)
      local value = 0
      local argLength = #arg
      for i = 1, argLength, 3 do
            local LowestBit = 32 - arg[i + 2]
            local formFrom = 32 + arg[i + 1] - arg[i + 2]
            local formValue = GetValueByBit(arg[i], formFrom, 32)
            value = value | (formValue << LowestBit) 
      end
      return value
end

function GenerateNetStream()
	local netStream = fromPool()
	return netStream
end

function EncodeCGameCmd(eCmdType,iSize,acData)
	local kNetStream = GenerateNetStream()
	kNetStream:InitData()
	kNetStream:WriteInt(eCmdType)
	kNetStream:WriteInt(iSize)
	kNetStream:AddStreamData(acData)
	return kNetStream,2105
end

function DecodeCGameCmd(acData,iSize)
	local _data = {}
	local kNetStream = GenerateNetStream()
	kNetStream:Attach(acData,iSize)
	local iSize = kNetStream:ReadInt()
	while kNetStream:GetCurPos() < iSize  do
		local iCmd = kNetStream:ReadInt()
		local func = GetGCSToGCSDecodeFuncByCmd(iCmd)
		if func ~= nil then
			local data = func(kNetStream)
			_data[#_data + 1] ={}
			_data[#_data]["iCmd"] = iCmd
			_data[#_data]["data"] = data
		else

			derror("icmd "..iCmd.."no decode function")
		end	
	end
	return _data
end

function EncodeRecordStream(eCmdType, binStream)
	local kRecordStream = GenerateNetStream()
  kRecordStream:InitData()
  kRecordStream:WriteInt(eCmdType)

	kRecordStream:WriteInt(binStream:GetCurPos())
	kRecordStream:AddStreamData(binStream)
	return kRecordStream
end

function GenerateCSeCmd(...)
	local kNetStream = fromPool()
	return kNetStream
end
------------------上行间隔检查-------------
local CheckFarmeTime = 33 -- 间隔多少帧检测
local FarmeMaxSendCount = 10 -- 间隔CheckFarmeTime 允许发送的数量
local akCacheSendData = {}
local iCurFarmeSendCount = 0

local UpdateCheckSend = function ()
	iCurFarmeSendCount = 0
	if #akCacheSendData > 0 then
		while(iCurFarmeSendCount < FarmeMaxSendCount) do
			local v = akCacheSendData[1]
			if v then
				SendPackageToNet(v[1],v[2],v[3])
				table.remove(akCacheSendData,1)
			else
				break
			end
		end
	end
end

-- globalTimer:AddTimer(CheckFarmeTime, UpdateCheckSend,-1)

local aiLastSendCMD = {}
local UpdateCheckCount = function()
	if #aiLastSendCMD >= 30 then  --检查一下 每s 上行数量
		local str = table.concat(aiLastSendCMD,",")
		derror("net send frequency is too high "..#aiLastSendCMD.." : " ..str)
	end
	aiLastSendCMD = {}
end
globalTimer:AddTimer(1000, UpdateCheckCount,-1)
---------------------上行间隔检查end-------------
function SendPackageToNet(iNetType, iCmd, binData,ingoreTime)
	if DEBUG_MODE then
		local recordStreamData = EncodeRecordStream(iCmd, binData)
		if g_encodeCache ~= nil then 
			-- cache 写入 文件
			sr.write_json_file(g_encodeCache, recordStreamData, iCmd)
		end
		-- sr.write_file(recordStreamData)
		toPool(recordStreamData)
	end

	local bSend = nil
	-- if ingoreTime then
		bSend = DRCSRef.NetMgr:SendDataFromLua(iNetType, iCmd, binData);
	-- else
	-- 	if iCurFarmeSendCount > FarmeMaxSendCount then
	-- 		table.insert(akCacheSendData,{iNetType,iCmd,binData})
	-- 		-- dwarning("net send frequency is too high")
	-- 		return
	-- 	end
	-- 	iCurFarmeSendCount = iCurFarmeSendCount + 1
	-- 	bSend = DRCSRef.NetMgr:SendDataFromLua(iNetType, iCmd, binData);
	-- end
	aiLastSendCMD[#aiLastSendCMD+ 1] = iCmd
	toPool(binData)
	if(not bSend) then
		dwarning("icmd "..iCmd.."Net Send Error")
	end
	return bSend
end

function NetGameStartSend(eCmdType, iSize, acData)
	local gameMode = globalDataPool:getData("GameMode")
	if (gameMode == nil) then
		gameMode = "SingleMode"
	end

	local binData,iCmd = EncodeCGameCmd(eCmdType,iSize,acData)
	if (gameMode == 'ServerMode') then
	elseif (gameMode == 'SingleMode') then
		dprint(string.format("[NetCmdSend]->NetGameStartSend,SingleMode,iCmdType: %d,iSize: %d",eCmdType,iSize))
		DRCSRef.LogicMgr:PlayerLoadCmd(eCmdType, binData);
		local logicSize = DRCSRef.LogicMgr:GetMemSize()
		dprint(string.format("[NetCmdSend]->GameCmdSend,LogicSize:%d",logicSize))
	end
	toPool(acData)
end

function NetGameCmdSend(eCmdType,iSize,acData)
	local gameMode = globalDataPool:getData("GameMode")
	if (gameMode == nil) then
		gameMode = "SingleMode"
	end

	local binData,iCmd = EncodeCGameCmd(eCmdType,iSize,acData)
	if DEBUG_CHEAT then 
		g_cmdTypeCache = eCmdType
	end
  
	if (gameMode == 'ServerMode') then
		dprint(string.format("[NetCmdSend]->GameCmdSend,ServerMode,iCmdType: %d,iSize: %d",eCmdType,iSize))
		-- local sendData = string.sub(binData:GetData(),1,binData:GetCurPos())
		-- dwarning(string.format("[NetCmdSend]->GameCmdSend,ServerMode,iCmdType: %d,iSize: %d,Data: %s",eCmdType,binData:GetCurPos(),lp.tools.base64encode(sendData)))
		SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
	elseif (gameMode == 'SingleMode') then
		dprint(string.format("[NetCmdSend]->GameCmdSend,SingleMode,iCmdType: %d,iSize: %d",eCmdType,iSize))
		DRCSRef.LogicMgr:PlayerOprCmd(eCmdType, binData);
		toPool(binData)
		local logicSize = DRCSRef.LogicMgr:GetMemSize()
		dprint(string.format("[NetCmdSend]->GameCmdSend,LogicSize:%d",logicSize))
	end
	toPool(acData)

	-- 进入剧本后玩家上行清除玩家操作标记
	if (not g_noPlayerCmd) and GetNoPlayerCmdLoadCount(GetCurScriptID()) ~= 0 and g_checkNoPlayerCmdFrame ~= DRCSRef.Time.frameCount then 
		ResetNoPlayerCmdLoadCount()
	end
	
	if DEBUG_CHEAT then 
        UpdateUploadNetMsgStat(iSize)
    end
end

function UpdateUploadNetMsgStat(iSize)
	local iTotalUploadMsgSize = globalDataPool:getData("TotalUploadMsgSize") or 0
    local iLastUploadMsgSize = iSize

    iTotalUploadMsgSize = iTotalUploadMsgSize + iLastUploadMsgSize
    globalDataPool:setData("TotalUploadMsgSize", iTotalUploadMsgSize, true)    
    globalDataPool:setData("LastUploadMsgSize", iLastUploadMsgSize, true)    
end

function IsGameServerMode()
	local gameMode = globalDataPool:getData("GameMode")
	if (gameMode == nil) then
		return false
	end

	if (gameMode == "ServerMode") then
		return true
	end

	return false
end