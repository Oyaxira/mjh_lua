FPSUI = class("FPSUI",BaseWindow)

function FPSUI:ctor()
	self.objSpine_Button = nil
end

function FPSUI:Create()
	local obj = LoadPrefabAndInit("TownUI/FPS_UI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
	self.iFrameCount = 0
end

local Logic_Instance = CS.GameApp.Logic.Instance
function FPSUI:Init()
	self.objCloseButton = self:FindChildComponent(self._gameObject,"Close_Button","Button")
	if self.objCloseButton then
		local fun = function()
			self.objText.gameObject:SetActive(not self.objText.gameObject.activeSelf)
		end
		self:AddButtonClickListener(self.objCloseButton,fun)
	end
	self.objText = self:FindChildComponent(self._gameObject,"Text","Text")

	self.objActionText = self:FindChildComponent(self._gameObject, "ActionText", "Text")

	self.objNetMsgText = self:FindChildComponent(self._gameObject, "NetMsgText", "Text")
	
	self.objNetMsgExText = self:FindChildComponent(self._gameObject, "NetMsgExText", "Text")

	local fun = function()
		local logicdebuginfo = globalDataPool:getData("LogicDebugInfo") or {}
		local iSpineCount = globalDataPool:getData("TestSpineCount") or 0
		local kNetMsgStatDesc = self:GetNetMsgStatStr()
		local iFPS = math.floor(1/ DRCSRef.Time.unscaledDeltaTime) 
		local str = string.format("Memory:  %d\nFPS:  %d  %d\nSpineCount:  %d\nTweenCount:	%d\n", logicdebuginfo["uiMemorySize"] or 0, iFPS, self.iFrameCount, iSpineCount,DRCSRef.DOTween.TotalPlayingTweens())
		str = str .. '\n' .. kNetMsgStatDesc
		str = str .. '\n\n' .. self:GetManagerNumsStr()
		self.objText.text = str
		self.iFrameCount = 0

		self.objActionText.text = self:GetActionDebugStr() .. self:GetBattleMsgStr()
		self.objNetMsgText.text = self:GetNetMsgDebugStr()
		self.objNetMsgExText.text = self:GetNetMsgExDebugStr()
  end
  if (self.FPSTimer == nil) then
    self.FPSTimer = self:AddTimer(1000,fun,-1)
  end
	
	DontDestroyWindow('FPSUI')
end

function FPSUI:Update()
	if (self.objText == nil) then
		return
	end
	self.iFrameCount = self.iFrameCount + 1
	local logicdebuginfo = globalDataPool:getData("LogicDebugInfo") or {}
	local iSpineCount = globalDataPool:getData("TestSpineCount") or 0
	local kNetMsgStatDesc = self:GetNetMsgStatStr()
	local iFPS = math.floor(1/ DRCSRef.Time.unscaledDeltaTime) 
	local str = string.format("Memory:  %d\nFPS:  %d  %d\nSpineCount:  %d\nTweenCount:	%d\n", logicdebuginfo["uiMemorySize"] or 0, iFPS, self.iFrameCount, iSpineCount,DRCSRef.DOTween.TotalPlayingTweens())
	str = str .. '\n' .. kNetMsgStatDesc
	str = str .. '\n\n' .. self:GetManagerNumsStr()
	self.objText.text = str
	self.iFrameCount = 0

	self.objActionText.text = self:GetActionDebugStr() .. self:GetBattleMsgStr()
	self.objNetMsgText.text = self:GetNetMsgDebugStr()
	self.objNetMsgExText.text = self:GetNetMsgExDebugStr()
end

function FPSUI:GetNetMsgStatStr()
	self.iTotalDownloadMsgSize = globalDataPool:getData("TotalDownloadMsgSize") or 0
	local kTotalDownloadMsgSizeStr = self:GetFormatSizeStr(self.iTotalDownloadMsgSize)

	self.iTotalUploadMsgSize = globalDataPool:getData("TotalUploadMsgSize") or 0
	local kTotalUploadMsgSizeStr = self:GetFormatSizeStr(self.iTotalUploadMsgSize)

	self.iLastDownloadMsgSize = globalDataPool:getData("TotalLastDownloadMsgSize") or 0
	local kLastDownloadMsgSizeStr = self:GetFormatSizeStr(self.iLastDownloadMsgSize)

	self.iLastUploadMsgSize = globalDataPool:getData("LastUploadMsgSize") or 0
	local kLastUploadMsgSizeStr = self:GetFormatSizeStr(self.iLastUploadMsgSize)

	self.itotalMsgSize = self.iTotalDownloadMsgSize + self.iTotalUploadMsgSize
	local ktotalMsgSizeStr = self:GetFormatSizeStr(self.itotalMsgSize)

    local kDesc = string.format("TotalNetSize:	%s\nTotalDownSize:	%s\nLastDownSize:	%s\nTotalUpSize:	%s\nLastUpSize:	%s", ktotalMsgSizeStr, kTotalDownloadMsgSizeStr, kLastDownloadMsgSizeStr, kTotalUploadMsgSizeStr, kLastUploadMsgSizeStr)

	return kDesc
end

function FPSUI:GetManagerNumsStr()
	local logicdebuginfo = globalDataPool:getData("LogicDebugInfo") or {}

	local iTotalInstRoleNums = logicdebuginfo["uiInstRoleNums"]
	local iTotalNpcRoleNums = logicdebuginfo["uiNpcRoleNums"]
	local iTotalItemNums = logicdebuginfo["uiNpcItemNums"]
	local iTotalMartialNums = logicdebuginfo["uiMartialNums"]
	local iTotalShopNums = logicdebuginfo["uiShopNums"]
	local iTotalTaskNums = logicdebuginfo["uiTaskNums"]
	local iTotalGiftNums = logicdebuginfo["uiGiftNums"]
	local iTotalCityNums = logicdebuginfo["uiCityNums"]
	local iTotalMapNums = logicdebuginfo["uiMapNums"]
	local iTotalAttrsNums = logicdebuginfo["uiAttrsNums"]
	local iTotalAchieveNums = logicdebuginfo["uiAchieveNums"]
	local iTotalEvolutionNums = logicdebuginfo["uiEvolutionNums"]
	local iTotalMazeAreaNums = logicdebuginfo["uiMazeAreaNums"]
	local iTotalMazeCardNums = logicdebuginfo["uiMazeCardNums"]
	local iTotalMazeGridNums = logicdebuginfo["uiMazeGridNums"]

	local iTotalInstRoleMemSize = logicdebuginfo["uiInstRoleMemSize"]
	local iTotalNpcRoleMemSize = logicdebuginfo["uiNpcRoleMemSize"]
	local iTotalItemMemSize = logicdebuginfo["uiNpcItemMemSize"]
	local iTotalMartialMemSize = logicdebuginfo["uiMartialMemSize"]
	local iTotalShopMemSize = logicdebuginfo["uiShopMemSize"]
	local iTotalTaskMemSize = logicdebuginfo["uiTaskMemSize"]
	local iTotalGiftMemSize = logicdebuginfo["uiGiftMemSize"]
	local iTotalCityMemSize = logicdebuginfo["uiCityMemSize"]
	local iTotalMapMemSize = logicdebuginfo["uiMapMemSize"]
	local iTotalAttrsMemSize = logicdebuginfo["uiAttrsMemSize"]
	local iTotalAchieveMemSize = logicdebuginfo["uiAchieveMemSize"]
	local iTotalEvolutionMemSize = logicdebuginfo["uiEvolutionMemSize"]
	local iTotalMazeAreaMemSize = logicdebuginfo["uiMazeAreaMemSize"]
	local iTotalMazeCardMemSize = logicdebuginfo["uiMazeCardMemSize"]
	local iTotalMazeGridMemSize = logicdebuginfo["uiMazeGridMemSize"]

	local iTotalBattleMemSize = logicdebuginfo['uiBattleMemSize']

	local iTotalUpdateInstRoleMemSize = logicdebuginfo["uiInstRoleUpdateMemSize"]
	local iTotalUpdateNpcRoleMemSize = logicdebuginfo["uiNpcRoleUpdateMemSize"]
	local iTotalUpdateItemMemSize = logicdebuginfo["uiNpcItemUpdateMemSize"]
	local iTotalUpdateMartialMemSize = logicdebuginfo["uiMartialUpdateMemSize"]
	local iTotalUpdateShopMemSize = logicdebuginfo["uiShopUpdateMemSize"]
	local iTotalUpdateTaskMemSize = logicdebuginfo["uiTaskUpdateMemSize"]
	local iTotalUpdateGiftMemSize = logicdebuginfo["uiGiftUpdateMemSize"]
	local iTotalUpdateCityMemSize = logicdebuginfo["uiCityUpdateMemSize"]
	local iTotalUpdateMapMemSize = logicdebuginfo["uiMapUpdateMemSize"]
	local iTotalUpdateAttrsMemSize = logicdebuginfo["uiAttrsUpdateMemSize"]
	local iTotalUpdateAchieveMemSize = logicdebuginfo["uiAchieveUpdateMemSize"]
	local iTotalUpdateEvolutionMemSize = logicdebuginfo["uiEvolutionUpdateMemSize"]
	local iTotalUpdateMazeAreaMemSize = logicdebuginfo["uiMazeAreaUpdateMemSize"]
	local iTotalUpdateMazeCardMemSize = logicdebuginfo["uiMazeCardUpdateMemSize"]
	local iTotalUpdateMazeGridMemSize = logicdebuginfo["uiMazeGridUpdateMemSize"]

	local iTotalInsertInstRoleMemSize = logicdebuginfo["uiInstRoleInsertMemSize"]
	local iTotalInsertNpcRoleMemSize = logicdebuginfo["uiNpcRoleInsertMemSize"]
	local iTotalInsertItemMemSize = logicdebuginfo["uiNpcItemInsertMemSize"]
	local iTotalInsertMartialMemSize = logicdebuginfo["uiMartialInsertMemSize"]
	local iTotalInsertShopMemSize = logicdebuginfo["uiShopInsertMemSize"]
	local iTotalInsertTaskMemSize = logicdebuginfo["uiTaskInsertMemSize"]
	local iTotalInsertGiftMemSize = logicdebuginfo["uiGiftInsertMemSize"]
	local iTotalInsertCityMemSize = logicdebuginfo["uiCityInsertMemSize"]
	local iTotalInsertMapMemSize = logicdebuginfo["uiMapInsertMemSize"]
	local iTotalInsertAttrsMemSize = logicdebuginfo["uiAttrsInsertMemSize"]
	local iTotalInsertAchieveMemSize = logicdebuginfo["uiAchieveInsertMemSize"]
	local iTotalInsertEvolutionMemSize = logicdebuginfo["uiEvolutionInsertMemSize"]
	local iTotalInsertMazeAreaMemSize = logicdebuginfo["uiMazeAreaInsertMemSize"]
	local iTotalInsertMazeCardMemSize = logicdebuginfo["uiMazeCardInsertMemSize"]
	local iTotalInsertMazeGridMemSize = logicdebuginfo["uiMazeGridInsertMemSize"]
	

	local iSerializeSize = logicdebuginfo["uiSerializeSize"]
	local iShowSize = logicdebuginfo["uiGenerateShowSize"]

	local iCostTime = logicdebuginfo["uiCostTime"]

	local kDesc = ""
	kDesc = kDesc .. string.format("Account:\t%s\n",GetConfig("AccountID") or "")
	kDesc = kDesc .. string.format("InstRole:\t%s, Create:%s, Update:%s, Mem:%s\n",iTotalInstRoleNums,iTotalInsertInstRoleMemSize,iTotalUpdateInstRoleMemSize,iTotalInstRoleMemSize)
	kDesc = kDesc .. string.format("NpcRole:\t%s,Create:%s, Update:%s, Mem:%s\n",iTotalNpcRoleNums,iTotalInsertNpcRoleMemSize,iTotalUpdateNpcRoleMemSize,iTotalNpcRoleMemSize)
	kDesc = kDesc .. string.format("Item:\t%s, Create:%s, Update:%s, Mem:%s\n",iTotalItemNums,iTotalInsertItemMemSize, iTotalUpdateItemMemSize,iTotalItemMemSize)
	kDesc = kDesc .. string.format("Martial:\t%s,Create:%s, Update:%s, Mem:%s\n",iTotalMartialNums,iTotalInsertMartialMemSize,iTotalUpdateMartialMemSize,iTotalMartialMemSize)
	kDesc = kDesc .. string.format("Task:\t%s, Create:%s, Update:%s,Mem:%s\n",iTotalTaskNums,iTotalInsertTaskMemSize,iTotalUpdateTaskMemSize,iTotalTaskMemSize)
	kDesc = kDesc .. string.format("Attrs:\t%s, Create:%s, Update:%s, Mem:%s\n",iTotalAttrsNums,iTotalInsertAttrsMemSize,iTotalUpdateAttrsMemSize,iTotalAttrsMemSize)
	kDesc = kDesc .. string.format("Achieve:\t%s,Create:%s, Update:%s, Mem:%s\n",iTotalAchieveNums,iTotalInsertAchieveMemSize,iTotalUpdateAchieveMemSize,iTotalAchieveMemSize)
	kDesc = kDesc .. string.format("Evolution:\t%s, Create:%s, Update:%s, Mem:%s\n",iTotalEvolutionNums,iTotalInsertEvolutionMemSize,iTotalUpdateEvolutionMemSize,iTotalEvolutionMemSize)
	kDesc = kDesc .. string.format("MazeArea:\t%s, Create:%s, Update:%s, Mem:%s\n",iTotalMazeAreaNums,iTotalInsertMazeAreaMemSize,iTotalUpdateMazeAreaMemSize,iTotalMazeAreaMemSize)
	kDesc = kDesc .. string.format("MazeCard:\t%s, Create:%s, Update:%s, Mem:%s\n",iTotalMazeCardNums,iTotalInsertMazeCardMemSize,iTotalUpdateMazeCardMemSize,iTotalMazeCardMemSize)
	kDesc = kDesc .. string.format("MazeGrid:\t%s, Create:%s, Update:%s, Mem:%s\n",iTotalMazeGridNums,iTotalInsertMazeGridMemSize,iTotalUpdateMazeGridMemSize,iTotalMazeGridMemSize)

	kDesc = kDesc .. string.format("Battle Mem:%s\n",iTotalBattleMemSize)
	
	kDesc = kDesc .. string.format("SerializeSize:\t%s\nShowSize:\t%s\n",iSerializeSize,iShowSize)
	kDesc = kDesc .. string.format("ProcessCostTime:\t%s ms\n",iCostTime)

	kDesc = kDesc .. "\n"

	if (logicdebuginfo["iFuncCallNums"] ~= nil) then
		for i = 0, logicdebuginfo["iFuncCallNums"] - 1 do
			kDesc = kDesc .. string.format("%s \t Call Time:%s, Cost Time:%s ms\n", logicdebuginfo["akFuncCallInfos"][i].acFuncName,logicdebuginfo["akFuncCallInfos"][i].uiCallTimes,logicdebuginfo["akFuncCallInfos"][i].uiCallCostTime)
		end
	end


	return kDesc
end

function FPSUI:GetActionDebugStr()
	local strRet = "\n"
	local actionList = DisplayActionManager:GetInstance():GetActionList()
	if (actionList == nil or #actionList == 0) then
		strRet = "\n当前action列表为空\n"
	end

	if (actionList ~= nil) then
		local curAction = DisplayActionManager:GetInstance():GetCurAction()
		for i = 1,#actionList do
			local action = actionList[i]
			
			local actionName = self:GetActionNameByActionType(action.actionType)
			if (action == curAction) then
				strRet = strRet .. string.format("当前Action!->Index:%d => ActionType:%s\n", i, actionName)
			else
				strRet = strRet .. string.format("Index:%d => ActionType:%s\n", i, actionName)
			end
		end
	end

	return strRet
end

function FPSUI:GetBattleMsgStr()
	local strRet = string.format("总hurtinfo数：%.0f\n当前hurtinfo数：%.0f\n当前信息队列size：%s\n",_HurtInfoSum or 0,_HurtInfoSumCur or 0,#battleMsgQueue)
	strRet = strRet .. (table.unpack(_LastBattleMsg or {},1) or "")
	return strRet
end

function FPSUI:GetNetMsgDebugStr()
	local strRet = "\n"

	local messageRecordList = GetNetMessageRecord()

	if (messageRecordList == nil or #messageRecordList == 0) then
		strRet = "当前下行消息为空"
	end
	for i = 1,#messageRecordList do
		local curMessage = messageRecordList[i]
		strRet = strRet .. string.format("下行消息 : %d, 大小 ：%d\n",curMessage.cmdType, curMessage.dataSize)
	end

	return strRet
end


function FPSUI:GetNetMsgExDebugStr()
	local strRet = "\n"

	local messageRecordList = GetNetMessageRecord()

	if (messageRecordList == nil or #messageRecordList == 0) then
		strRet = ""
	end
	local messageSizeDict = {}
	local messageCountDict = {}
	for i = 1,#messageRecordList do
		local curMessage = messageRecordList[i]
		messageSizeDict[curMessage.cmdType] = (messageSizeDict[curMessage.cmdType] or 0) + curMessage.dataSize
		messageCountDict[curMessage.cmdType] = (messageCountDict[curMessage.cmdType] or 0) + 1
	end

	for cmpType, size in pairs(messageSizeDict) do
		strRet = strRet .. string.format("消息: %d, 总大小(次数)：%d(%d)\n", cmpType, size, messageCountDict[cmpType])
	end

	return strRet
end



function FPSUI:GetFormatSizeStr(iSize)
	local kSizeStr = ''
	local iKBSize = 1024
	local iMBSize = iKBSize * 1024
	local iGBSize = iMBSize * 1024

	if iSize < iKBSize then 
		kSizeStr = iSize .. ' b'
	elseif iSize < iMBSize then
		kSizeStr = string.format('%.2f kb', iSize / iKBSize)
	elseif iSize < iGBSize then
		kSizeStr = string.format('%.2f mb', iSize / iMBSize)
	else
		kSizeStr = string.format('%.2f gb', iSize / iGBSize)
	end
	return kSizeStr
end

function FPSUI:OnDestroy()

end

function FPSUI:GetActionNameByActionType(type)
	-- 首先查找索引
	local actionName = DisplayActionType_Revert[type]
	if (actionName ~= nil) then
		return actionName
	end

	return tostring(type)
end

return FPSUI