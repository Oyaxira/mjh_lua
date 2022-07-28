CheatDataManager = class("CheatDataManager")
CheatDataManager._instance = nil

function CheatDataManager:GetInstance()
    if CheatDataManager._instance == nil then
		CheatDataManager._instance = CheatDataManager.new()
    end

    return CheatDataManager._instance
end

function CheatDataManager:AddHistoryCmd(cmd,sendText)
    local historyCmds = globalDataPool:getData("CheatHistoryCmd")
	if (historyCmds == nil) then 
        globalDataPool:setData("CheatHistoryCmd",{})
        historyCmds = globalDataPool:getData("CheatHistoryCmd")
	end
    
    table.insert(historyCmds,{["cmd"] = cmd, ["param"] = sendText})
end

function CheatDataManager:GetHistoryCmd()
    local historyCmds = globalDataPool:getData("CheatHistoryCmd")
	if (historyCmds == nil) then 
        globalDataPool:setData("CheatHistoryCmd",{})
        historyCmds = globalDataPool:getData("CheatHistoryCmd")
    end
    
    return historyCmds
end

function CheatDataManager:GetHistoryActionList()
    return self.historyActionList or {}
end

function CheatDataManager:GetAllActionList()
    local historyActionList = self:GetHistoryActionList() or {}
    local curActionList = DisplayActionManager:GetInstance():GetActionList() or {}
    local allActionList = {}
    for _, action in ipairs(historyActionList) do 
        table.insert(allActionList, action)
    end
    for _, action in ipairs(curActionList) do 
        table.insert(allActionList, action)
    end
    return allActionList
end

function CheatDataManager:AddHistoryAction(action)
    if not DEBUG_ACTION_ENABLE then 
        return
    end
    if self.historyActionList == nil then 
        self.historyActionList = {}
    end
    table.insert(self.historyActionList, action)
end

function CheatDataManager:ClearHistoryActionList()
    self.historyActionList = {}
end

function CheatDataManager:OpenActionDebugUI()
    OpenWindowImmediately("ActionDebugUI")
end

function CheatDataManager:SetShowBabyDetails()
    if self.bShowBabyDetails then 
        self.bShowBabyDetails = false 
    else 
        self.bShowBabyDetails = true 
    end 
end

function CheatDataManager:GetShowBabyDetails()
    return self.bShowBabyDetails 
end

function CheatDataManager:OpenUiLayerDebugUI()
    OpenWindowImmediately("UiLayerDebugUI")
end

function CheatDataManager:SendCheatCmd(cheatPara)
    -- 发送给logic的
    local clickCheatData = EncodeSendSeGC_ClickCheat(cheatPara)
    local iSize = clickCheatData:GetCurPos()
    NetGameCmdSend(SGC_CLICK_CHEAT, iSize, clickCheatData)

    -- 发送给gameserver的
    local defOprPlayerID = 0;
    local dwScriptID = 1;
    local kPlayerCheat = {
        acParam = cheatPara,
    };
    local binData,iCmd = EncodeSendSeCGA_PlayerCheat(defOprPlayerID, dwScriptID, kPlayerCheat);
	SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function CheatTestBattle(intID, num)
    intID = intID or 1
    num = num or 100
    local cheatPara = string.format("CHET_BATTLE_TEST@%s",intID)
    local clickCheatData = EncodeSendSeGC_ClickCheat(cheatPara)
    local iSize = clickCheatData:GetCurPos()
    for i=1,num do
        NetGameCmdSend(SGC_CLICK_CHEAT,iSize,clickCheatData)
    end
end

function ChangeScreenResolution()
    _cheat_cur_resolution_index = (_cheat_cur_resolution_index or 0) + 1
    local Resolution = require ("Resolution")
    if _cheat_cur_resolution_index > #Resolution then 
        _cheat_cur_resolution_index = 1
    end
    ChangeScreenResolutionIndex(_cheat_cur_resolution_index)
end

function ChangeScreenResolutionIndex(index)
    local Resolution = require ("Resolution")
    index = tonumber(index)
    local info = Resolution[index]
    if info then 
        DRCSRef.Screen.SetResolution(info[1], info[2], false)
    end
end