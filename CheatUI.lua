CheatUI = class("CheatUI",BaseWindow)

local StreamRecord = require ("Base/StreamRecord")

local CheatTypes = {
   "All","人物","物品","任务","战斗","迷宫","调试","擂台","其他"
}

function CheatUI:ctor()

end

function CheatUI:Create()
	local obj = LoadPrefabAndInit("CheatUI/CheatUI",TIPS_Layer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function CheatUI:Init()
    self.comCloseButton = self:FindChildComponent(self._gameObject, 'Button_back', 'Button')
	if self.comCloseButton then
		self:AddButtonClickListener(self.comCloseButton,function()
			RemoveWindowImmediately("CheatUI")
		end)
    end

    self.comLuaPandaButton = self:FindChildComponent(self._gameObject, 'Button_LinkLuaPanda', 'Button')
	if self.comLuaPandaButton then
		self:AddButtonClickListener(self.comLuaPandaButton,function()
			LuaPandaStart()
		end)
    end

    self.comouttimeinfo = self:FindChildComponent(self._gameObject, 'Button_outtimeinfo', 'Button')
	if self.comouttimeinfo then
		self:AddButtonClickListener(self.comouttimeinfo,function()
			TestWriteLoadLanguageInfo()
		end)
    end

    self.comInputCheckText = self:FindChildComponent(self._gameObject, "InputField","InputField")
    self.comInputCheckText.onValueChanged:AddListener(function()
        local text = self.comInputCheckText.text
        if (text == "") then
            self.curCmds = self.cheatCmds[self.curChooseType]
            self:UpdateCheatUI()
        else
            self.curCmds = {}
            for i = 1, #self.cheatCmds["All"] do
                local cmd = self.cheatCmds["All"][i]
                local cmdtext = cmd.CheatEffect
                local _, idx = string.find(cmdtext,text)
                if (idx ~= nil) then
                    table.insert(self.curCmds,cmd)
                end
            end
            self:UpdateCheatUI()
        end
    end)
    
    self.comExecuteText = self:FindChildComponent(self._gameObject, 'Execute_InputField_2', 'InputField')
    self.comButton_execute = self:FindChildComponent(self._gameObject, 'Button_execute', 'Button')
    self:AddButtonClickListener(self.comButton_execute,function() self:OnClick_Execute() end)

    self.comCmdsLoopScroll = self:FindChildComponent(self._gameObject, 'CheatCommand_box/SC_Command', 'LoopVerticalScrollRect')
    self.comCmdsLoopScroll.totalCount = 0
    self.comCmdsLoopScroll:AddListener(function(...) self:UpdateCheatButtonUI(...) end)

    self.comHistoryLoopScroll = self:FindChildComponent(self._gameObject, 'CheatHistory_box/SC_History', 'LoopVerticalScrollRect')
    self.comHistoryLoopScroll.totalCount = 0
    self.comHistoryLoopScroll:AddListener(function(...) self:UpdateHistoryButtonUI(...) end)

    self.curCmds = {}           -- 当前指令
    self.cheatCmds = {}         -- 所有分类好的指令
    for i = 1, #CheatTypes do
        self.cheatCmds[CheatTypes[i]] = {}
    end
    self.curChooseType = CheatTypes[1]

    local TB_Cheat = TableDataManager:GetInstance():GetTable("Cheat")
	for i = 1, #TB_Cheat do
		local cheatCmdTable = TB_Cheat[i]
		if (cheatCmdTable ~= nil) then
			table.insert(self.cheatCmds["All"], cheatCmdTable)
			self.cheatCmds[cheatCmdTable.CheatType] = self.cheatCmds[cheatCmdTable.CheatType] or {}
			table.insert(self.cheatCmds[cheatCmdTable.CheatType], cheatCmdTable)
		end
	end

    for i = 1, #CheatTypes do
        local typeButton = self:FindChild(self._gameObject, "CheatCommand_box/Nav_cheat_box/" .. i)
        local comSkin_Image = self:FindChild(typeButton, "Image")
        local comSkin_Toggle = typeButton:GetComponent('Toggle')
        self:AddToggleClickListener(comSkin_Toggle,function(bool)
            self.curChooseType = CheatTypes[i]
            self.curCmds = self.cheatCmds[self.curChooseType]
            self:UpdateCheatUI()
            comSkin_Image:SetActive(not bool)
        end)
    end

    self.curCmds = self.cheatCmds[self.curChooseType]
    self:UpdateCheatUI()

    self:UpdateHistoryCheatUI()
end

function CheatUI:OnDestroy()
    self.comInputCheckText.onValueChanged:RemoveAllListeners()
end

function CheatUI:UpdateCheatButtonUI(transform, index)
    local cmd = self.curCmds[index + 1]
    -- 设置显示文字
    local ObjText = self:FindChildComponent(transform.gameObject,"Button/Text","Text")
    ObjText.text = cmd.CheatEffect

	local comInputField1 = self:FindChildComponent(transform.gameObject,"InputField_1","InputField")
    comInputField1.text = ""
    local comInputField2 = self:FindChildComponent(transform.gameObject,"InputField_2","InputField")
    comInputField2.text = ""
    local comInputField3 = self:FindChildComponent(transform.gameObject,"InputField_3","InputField")
    comInputField3.text = ""
    
	local comInput1 = self:FindChildComponent(transform.gameObject,"InputField_1/Text","Text")
    comInput1.text = ""
    local comInput2 = self:FindChildComponent(transform.gameObject,"InputField_2/Text","Text")
    comInput2.text = ""
    local comInput3 = self:FindChildComponent(transform.gameObject,"InputField_3/Text","Text")
    comInput3.text = ""
    
    local comPlaceholder1 = self:FindChildComponent(transform.gameObject,"InputField_1/Placeholder","Text")
    comPlaceholder1.text = cmd.CheatCase1 or ""
    local comPlaceholder2 = self:FindChildComponent(transform.gameObject,"InputField_2/Placeholder","Text")
    comPlaceholder2.text = cmd.CheatCase2 or ""
    local comPlaceholder3 = self:FindChildComponent(transform.gameObject,"InputField_3/Placeholder","Text")
    comPlaceholder3.text = cmd.CheatCase3 or ""


    -- 设置点击回调
    local comButton = self:FindChildComponent(transform.gameObject,'Button',"Button")
    if comButton and cmd.CheatOrder then
        self:RemoveButtonClickListener(comButton)
        self:AddButtonClickListener(comButton, function()
            local sendText = ""
            if (comInputField1.text == nil or comInputField1.text == "") then
                sendText = string.format("%d",tonumber(cmd.Default1) or 0)
            else
                sendText = string.format("%s", comInputField1.text or 0)
            end

            if (comInputField2.text == nil or comInputField2.text == "") then
                sendText = string.format("%s@%d", sendText, tonumber(cmd.Default2) or 0)
            else
                sendText = string.format("%s@%s",sendText,comInputField2.text or 0)
            end

            if (comInputField3.text == nil or comInputField3.text == "") then
                sendText = string.format("%s@%d", sendText, tonumber(cmd.Default3) or 0)
            else
                sendText = string.format("%s@%s",sendText,comInputField3.text or 0)
            end

            CheatDataManager:GetInstance():AddHistoryCmd(cmd,sendText)
            self:UpdateHistoryCheatUI()
            self:ExeCheatCommand(cmd,sendText)
            RemoveWindowImmediately("CheatUI")
        end)
    end
end

function CheatUI:UpdateCheatUI()
    self.comCmdsLoopScroll.totalCount = #self.curCmds
    self.comCmdsLoopScroll:RefillCells()
end

function CheatUI:UpdateHistoryCheatUI()
    self.comHistoryLoopScroll.totalCount = #(CheatDataManager:GetInstance():GetHistoryCmd())
    self.comHistoryLoopScroll:RefillCells()
end

function CheatUI:UpdateHistoryButtonUI(transform, index)
    local historyCmd = (CheatDataManager:GetInstance():GetHistoryCmd())[index + 1]
    local cmd = historyCmd.cmd
    local param = historyCmd.param
    -- 设置显示文字
    local ObjText = self:FindChildComponent(transform.gameObject,"Button/Text","Text")
    ObjText.text = string.format("%s@%s",cmd.CheatEffect, param)

	local comText = self:FindChildComponent(transform.gameObject,"Image_num/Text","Text")
    comText.text = ""

    -- 设置点击回调
    local comButton = self:FindChildComponent(transform.gameObject,'Button',"Button")
    if comButton and cmd.CheatOrder then
        self:RemoveButtonClickListener(comButton)
		self:AddButtonClickListener(comButton, function()
			self:ExeCheatCommand(cmd,param)
            RemoveWindowImmediately("CheatUI")
        end)
    end
end

function CheatUI:ExeCheatCommand(tableCmd, text)
    if tableCmd then
        if (tableCmd.Open == TBoolean.BOOL_NO) then
            SystemUICall:GetInstance():Toast("本条指令暂未开放，可能没有实际效果", false)
        end
    
        if (tableCmd.CheatOrder ~= nil and tableCmd.CheatOrder ~= "") then
            local cheatPara = string.format("%s@%s",tableCmd.CheatOrder,text)
            CheatDataManager:GetInstance():SendCheatCmd(cheatPara)
        end

        if (tableCmd.CheatFunc ~= nil and tableCmd.CheatFunc ~= "" ) then
            self[tableCmd.CheatFunc](self,text)
        end
    end
end

function CheatUI:OnClick_JoinClan(text)
	dprint(string.format("OnClick_JoinClan"))
	local strList = string.split(text, '@')
	local clickData = EncodeSendSeGC_Click_Clan_Join(strList[1], strList[2])
	local iSize = clickData:GetCurPos()
	NetGameCmdSend(SGC_CLICK_ROLE_JOIN_CLAN, iSize, clickData)
end

function CheatUI:OnClick_TestBarrage(text)
    -- local dwNum1
    -- local dwNum2 
    -- if text then 
    --     local strList = string.split(text, '@')
    --     dwNum1 = strList[1]
    --     dwNum2 = strList[2]
    --     TOAST_FADE_DELTA_TIME = (dwNum1 or 2) / 10
    --     TOAST_SHOW_DELTA_TIME = (dwNum2 or 5) / 10
    -- end 
    -- local text =  string.rep("烫", math.random( 2,20 ),"不")
    -- -- SystemUICall:GetInstance():BarrageShow(text)
    -- for i=1,math.random( 1,20 ) do 
    --     SystemUICall:GetInstance():Toast(text)
    -- end

    local dwNum1 = 2 -- 字数下限 * 2 -1
    local dwNum2 = 20 -- 字数上限 * 2 -1
    local dwNum3 = 1 -- 循环次数
    if text then 
        local strList = string.split(text, '@')
        dwNum1 = strList[1] and tonumber(strList[1])
        dwNum2 = strList[2] and tonumber(strList[2])
        dwNum3 = strList[3] and tonumber(strList[3])
    end 
    for i=1,dwNum3 do 
        local text =  string.rep("烫", math.random( dwNum1,dwNum2 ),"不")
        SystemUICall:GetInstance():BarrageShow(text)
    end
end

function CheatUI:OnClick_Execute()
    local str = string.split(self.comExecuteText.text,"@") 
    local funStr = table.remove(str,1)
    package.loaded["UI/CheatUI/HotfixLuaCheat"] = nil
    require("UI/CheatUI/HotfixLuaCheat")
    local fun = _G[funStr]
    RemoveWindowImmediately("CheatUI")
    if fun and type(fun) == "function" then
        fun(table.unpack(str))
    else
        local cheatPara = self.comExecuteText.text
        CheatDataManager:GetInstance():SendCheatCmd(cheatPara)
    end 
end

-- 打开窗口
function CheatUI:OnClick_OpenWindow(text, info)
    OpenWindowByQueue(text, info)
end

function CheatUI:OnClick_SkipDialog(text)
    SkipAllUselessAnim()
end

function CheatUI:OnClick_DebugInfo(text)
    OpenWindowImmediately("FPSUI")
end

function CheatUI:OnClick_ShowCartoon(text)
    local strList = string.split(text, '@')
    OpenWindowImmediately("CartoonUI", {CartoonId = tonumber(strList[1])})
end

function CheatUI:OnClick_RunPlot(text)
    RemoveWindowImmediately("CheatUI")
    local strList = string.split(text, '@')
    local uiPlotID = tonumber(strList[1])
    local plotTaskID = 0
    PlotDataManager:GetInstance():AddPlot(plotTaskID, uiPlotID)
end

function CheatUI:OnClick_SkipDialog(text)
    SkipAllUselessAnim()
end

function CheatUI:OnClick_ProfilerStart()
    -- if DEBUG_AUTO_PROFILER then 
    --     SystemUICall:GetInstance():Toast("DEBUG_AUTO_PROFILER true")
    --     return 
    -- end
    ProfilerStart()
	SystemUICall:GetInstance():Toast("性能分析 <color=#6CD458>启动</color>")
end

function CheatUI:OnClick_ProfilerStop()
    -- if DEBUG_AUTO_PROFILER then 
    --     SystemUICall:GetInstance():Toast("DEBUG_AUTO_PROFILER true")
    --     return 
    -- end
    ProfilerStop(true)
    SystemUICall:GetInstance():Toast("性能分析 <color=#6CD458>停止</color>")
    SystemUICall:GetInstance():Toast("报告已输出")
end

function CheatUI:OnClick_ReturnTown()
    if (IsGameServerMode()) then
		SendClickQuitStoryCMD()
	else
		QuitStory()
    end
end

function CheatUI:OnClick_TagDebug()
    OpenWindowImmediately('TagDebugUI')
end

function CheatUI:OnClick_ReturnLogin()
    -- ChangeScenceImmediately("Login", "LoadingUI")
    OpenWindowImmediately("LoadingUI")
    ResetGame()
    ChangeScenceImmediately("Login","LoadingUI", function()
        local LoginUI = OpenWindowImmediately("LoginUI")
    end)
end

function CheatUI:OnClick_ActionDebug()
    CheatDataManager:GetInstance():OpenActionDebugUI()
end

function CheatUI:OnClick_UiLayerDebug()
    CheatDataManager:GetInstance():OpenUiLayerDebugUI()
end

function CheatUI:OnClick_BeginRecord()
    StreamRecord.open_file()
end

function CheatUI:OnClick_EndRecord()
    StreamRecord.close_file()
end

--[[
<protocol Name="PlayerCheat" Stream="true" Comment="作弊指令，用于测试">  
    <member Name="defOprPlayerID" Type="DefPlyID" InitValue="0" Comment="目标玩家ID,自己填0"/>
    <member Name="dwScriptID" Type="DWord" InitValue="0"/>
    <member Name="kPlayerCheat" Type="SePlayerCheat"/>
</protocol>
]]
function CheatUI:OnClick_AddMeridiansEXP(text)
    -- local strList = string.split(text, '@');
    -- local defOprPlayerID = 0;
    -- local dwScriptID = 1;
    -- local kPlayerCheat = {
    --     eType = CHET_ADD_MERIDIANS_EXP,
    --     dwNum1 = tonumber(strList[1]),
    --     dwNum2 = tonumber(strList[2]),
    --     acParam = '',
    -- };
    -- local binData,iCmd = EncodeSendSeCGA_PlayerCheat(defOprPlayerID, dwScriptID, kPlayerCheat);
    -- SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
    
    -- CheatDataManager:GetInstance():SendCheatCmd(text)
end

function CheatUI:OnClick_ShowNpcMoveInfo()
    -- TODO: 显示Npc移动信息
end

function CheatUI:OnClick_AddPlatBots(text)
    -- local strList = string.split(text, '@')
    -- local defOprPlayerID = 0
    -- local dwScriptID = 1
    -- local kPlayerCheat = {
    --     eType = CHET_ADD_PLATBOTS,
    --     dwNum1 = tonumber(strList[1]),
    --     dwNum2 = 0,
    --     acParam = '',
    -- }
    -- local binData,iCmd = EncodeSendSeCGA_PlayerCheat(defOprPlayerID, dwScriptID, kPlayerCheat)
    -- SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
    
    local houseUI = WindowsManager:GetInstance():GetUIWindow('HouseUI')
    if houseUI then
        houseUI:RequestAreaPlayersData()
    end
end

function CheatUI:OnClick_SetLuckyValue(text)
    -- local strList = string.split(text, '@')
    -- local defOprPlayerID = 0
    -- local dwScriptID = 1
    -- local kPlayerCheat = {
    --     eType = CHET_ADD_LUCKYVALUE,
    --     dwNum1 = tonumber(strList[1]) + 200,
    --     dwNum2 = 0,
    --     acParam = '',
    -- }
    if (IsGameServerMode()) then
        -- local binData,iCmd = EncodeSendSeCGA_PlayerCheat(defOprPlayerID, dwScriptID, kPlayerCheat)
        -- SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
    else
        PlayerSetDataManager:GetInstance():SetLucyValue(kPlayerCheat.dwNum1)
    end    
    
end

function CheatUI:OnClick_AddTownItem(text)
    -- local strList = string.split(text, '@');
    -- local defOprPlayerID = 0;
    -- local dwScriptID = 1;
    -- local kPlayerCheat = {
    --     eType = CHET_ADD_FLATITEM,
    --     dwNum1 = tonumber(strList[1]),
    --     dwNum2 = tonumber(strList[2]),
    --     acParam = '',
    -- };
    -- local binData,iCmd = EncodeSendSeCGA_PlayerCheat(defOprPlayerID, dwScriptID, kPlayerCheat);
	-- SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData);
end

function CheatUI:OnClick_OpenMailWindow(text)
    OpenWindowImmediately("SocialUI")
end

function CheatUI:onClick_ShowEvoTag(bshow)
    if tostring(bshow) == "False" then
        RoleDataManager:GetInstance().bShowEvo = false
    else
        RoleDataManager:GetInstance().bShowEvo = true
    end
end

function CheatUI:onClick_StartGuide(guideid)
    local strList = string.split(guideid, '@')
    guideid = tonumber(strList[1])
    GuideDataManager:GetInstance():ClearGuide(guideid)
    GuideDataManager:GetInstance():StartGuideByID(guideid)
end

function CheatUI:OnClick_ClearGuide(guideid)
    local strList = string.split(guideid, '@')
    guideid = tonumber(strList[1])
    GuideDataManager:GetInstance():ClearGuide(guideid)
end

function CheatUI:OnClickRefreshLimitShop(text)
    local onlyshow
    if text then 
        local strList = string.split(text, '@')
        onlyshow = tonumber(strList[1])
    end 
    local data = {};
    for i=4,1,-1 do 
        if LimitShopManager:GetInstance():GetScriptLimit(i) then 
            data[#data +1] = i
        end 
    end 
    local dkJson = require("Base/Json/dkjson")
    local jsondata = dkJson.encode(data)
    if onlyshow and onlyshow > 0 then        
        acJson = LimitShopManager:GetInstance():GetShopCondDatas() 
        SystemUICall:GetInstance():BarrageShow(tostring(acJson))
        return 
    else 
        SystemUICall:GetInstance():BarrageShow(tostring(jsondata))
    end 
    SystemUICall:GetInstance():BarrageShow(jsondata)
    SendLimitShopOpr(EN_LIMIT_SHOP_REFLASH,0,0,0,0,0,jsondata)
    LimitShopManager:GetInstance():SetWaitOpenUI(true)
end

function CheatUI:OnClickShowBabyDetails()
    CheatDataManager:GetInstance():SetShowBabyDetails()
end

function CheatUI:OnClick_BecomeRich()
    -- local defOprPlayerID = 0
    -- local dwScriptID = 1
    -- local kPlayerCheat = {
    --     eType = CHET_BECOME_RICH,
    --     dwNum1 = 0,
    --     dwNum2 = 0,
    --     acParam = '',
    -- }
    -- local binData,iCmd = EncodeSendSeCGA_PlayerCheat(defOprPlayerID, dwScriptID, kPlayerCheat)
    -- SendPackageToNet(CS.GameApp.E_NETTYPE.NET_TOWNSERVER, iCmd, binData)
end

function CheatUI:OnClickSkipBornChoose()
    local iQuestionCount = 5
    local iSumTime = 0
    for index = 1, iQuestionCount do
        local localTime = iSumTime
        globalTimer:AddTimer(localTime, function()
            SendZhuaZhouSelection(1)
        end)
        iSumTime = iSumTime + 100
    end
    globalTimer:AddTimer(iSumTime, function()
        RemoveWindowImmediately("BornChooseUI")
        SendZhuaZhouSelection(2)
    end)
end

function CheatUI:OnClick_ShowMazeSeed()
    local mazeTypeID = MazeDataManager:GetInstance():GetCurMazeTypeID() or 0
    local areaIndex = MazeDataManager:GetInstance():GetCurAreaIndex() or 0
    local templateTerrainID = MazeDataManager:GetInstance():GetCurAreaTemplateTerrainID() or 0
    local content = '迷宫:' .. mazeTypeID .. '\n区域索引:' .. areaIndex .. '\n随机地形ID:' .. templateTerrainID
    SystemTipManager:GetInstance():AddPopupTip(content)
end

function CheatUI:OnClick_AddQQGroup()
    DRCSRef.MSDKGroup.JoinGroup("1","1","1","976841992","")
    
end

function CheatUI:OnClick_OpenSlug()
    local channel = MSDKHelper:GetChannel()
    if (channel ~= "") then
       local areaid = "2"
       if (channel == "WeChat") then
		    areaid = "1"
       elseif (channel == "QQ") then
           areaid = "2"
       end

       local platid = "1"
       if (MSDK_OS == 2) then
           platid = "0"
       elseif  (MSDK_OS == 1) then
           platid = "1"
       end
    ---string areaid:1wx2qq,string partition,string platid:0ios1andriod,string roleid
       DRCSRef.SlugManager.OpenSlug(areaid, "0", platid, "1", MSDKHelper:GetOpenID())
    else
    ---string areaid:1wx2qq,string partition,string platid:0ios1andriod,string roleid
       DRCSRef.SlugManager.OpenSlug("2", "0", "1", "1", MSDKHelper:GetOpenID())
    end

end

function CheatUI:OnClick_SetMSDKMode(text)
    local strList = string.split(text, '@')
    MSDK_MODE = tonumber(strList[1])
    dprint("set msdk_mode "..MSDK_MODE)
end

-- 重置登录等待
function CheatUI:OnClick_ClearLoginWait()
    PlayerSetDataManager:GetInstance():ClearForbidLoginData()
end

function CheatUI:OnClick_MidasBuy()
    -- midas充值测试
    local _callback = function()
        SystemUICall:GetInstance():Toast('midas 充值测试成功!')
    end
    MidasHelper:Deposit(18,_callback)
end

function CheatUI:OnClick_MidasQuery(text)
    SendQueryPlayerGold(true)
end

function CheatUI:OnClick_MidasCost()
    --openlog
    OUTPUT_LUALOG = true
    DEBUG_MODE = true 
    CS.UnityEngine.Debug.unityLogger.filterLogType = 3
end

function CheatUI:OnClick_AntiJammaFinalBattle()
--   local info = FinalBattleDataManager:GetInstance():GetInfo()
--   if (info and info.iAntiJammaCount and info.iAntiJammaCount >= 1) then
--     SystemTipManager:GetInstance():AddPopupTip("您已经使用过防卡死机制了，无法再次使用")
--     return
--   end
--   local strTips = '是否跳过所有任务，直接进入大决战？\n这是解决主线任务卡住的临时功能，本次测试期间仅可使用一次，正式运营时不会保留此功能。\n如有疑问，请加入官方Q群1061471593咨询客服。'
--   OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strTips, function()
--     local data = EncodeSendSeGC_ClickFinalBattleAntiJamma(1)
--     local iSize = data:GetCurPos()
--     NetGameCmdSend(SGC_CLICK_FINALBATTLE_ANTIJAMMA,iSize,data)
--   end})
end

function CheatUI:OnClick_TencentGMOrder()

end

function CheatUI:OnClick_StartAutoTest(text)
    local strList = string.split(text, '@')
    settingID = tonumber(strList[1])
    AutoTest_RunAutoTest(settingID)
end

function CheatUI:OnClick_StopAutoTest(text)
    AutoTest_StopAutoTest()
end

function CheatUI:OnClick_ReloadAutoTestSetting()
    AutoTest_ReloadAutoTestSetting()
end

function CheatUI:OnClickChangeSystemDate(text)
    local strList = string.split(text, '@')
    SYSTEM_OPEN_DATE = tonumber(strList[1]);
end

function CheatUI:OnClickOpenPinballEntry()
    SendSetNoviceGuideFlag(NoviceGuideFinishFlag.NGFF_PINBALL_OPEN)
end


function CheatUI:OnClickOpenDiscussByArticleID(text)
    local strList = string.split(text, '@')
    articleId = tonumber(strList[1])
    OpenWindowImmediately("DiscussUI",articleId)   
end

function CheatUI:OnClickUnlockAllComic()
    CollectionDataManager:GetInstance().CGTestMode = true
end

function CheatUI:OnClickTestSendFriendShare()
    SendActivityOper(SAOT_EVENT, 0, SATET_SHAREFRIEND, 3)
    SendActivityOper(SAOT_RECEIVE, 1003)
end

function CheatUI:OnClickOpenDiscussTestMode(text)
    local strList = string.split(text, '@')
    text = tonumber(strList[1])
    if (text == 1) then
        DiscussDataManager:GetInstance():SetTestMode(1)
    elseif (text == 0) then
        DiscussDataManager:GetInstance():SetTestMode(0)
    elseif (text == 2) then
        DiscussDataManager:GetInstance():SetReplyOpen(0)
    elseif (text == 3) then
        DiscussDataManager:GetInstance():SetReplyOpen(1)
    end
end

function CheatUI:OnClickEnterHideServer(text)
    local strList = string.split(text, '@')
    zone = strList[1]
    server = strList[2]
    if zone == '0' then 
        zone = '2'
    end
    if server == '0' then 
        server = '400002'
    end
    HttpHelper:SelectPublicLoginServer(zone, server)
    globalDataPool:setData("online", "true")
end

function CheatUI:OnClickClearFriendShareNums(text)
    local strList = string.split(text, '@')
    local num = tonumber(strList[1]) or 0
    local json = {
        ['ts'] = GetCurServerTimeStamp(),
        ['count'] = num,
    }
    MSDKHelper:SetShareCount(num)
    local jsonStr = dkJson.encode(json)
    CS.UnityEngine.PlayerPrefs.SetString('SHARE_COUNT_'..tostring(MSDKHelper:GetOpenID()), jsonStr)
end

function CheatUI:CheatCheck_IsSimulator()
    local stringRet = DRCSRef.TssSDK.Ioctl(10, "files_dir=/data/data/com.tencent.dianhun.wdxk/files|wait=1")
    SystemUICall:GetInstance():Toast("检测是否是模拟器:" .. tostring(stringRet or "Error"))

    MSDKHelper.issimulatorSupportIOS = not MSDKHelper.issimulatorSupportIOS
    if (MSDKHelper.issimulatorSupportIOS) then
        SystemUICall:GetInstance():Toast("开启模拟器支持IOS功能", false)
    else
        SystemUICall:GetInstance():Toast("关闭模拟器支持IOS功能", false)
    end
end

function CheatUI:CheatCheck_OpenMiniApp()
    MSDKHelper:OpenMiniApp()
end

local MerdianssTimer
function CheatUI:CheatMeridiansUp(text)
    local bIfClose = false
    local iAddNum = 12  -- 本次加的数量 
    local iStartNum = 1  -- 从第几个经脉开始
    local GetAcupointData = TableDataManager:GetInstance():GetTable("Acupoint")
    local ibaseid = 1
    local imaze = 1

    if text then 
        local strList = string.split(text, '@')
        bIfClose = (tonumber(strList[1]) or 0) == 1
        if strList[2] and tonumber(strList[2]) ~= 0 then 
            iAddNum = strList[2] and tonumber(strList[2]) or 10
        end 
        if strList[3] and tonumber(strList[3]) ~= 0 then 
            iStartNum = strList[3] and tonumber(strList[3]) or 1
        end 
    end 
    
    if MeridiansDataManager:GetInstance():GetCurTotalExp() < 11418650 then  
        CheatDataManager:GetInstance():SendCheatCmd("CHET_ADD_MERIDIANS_EXP@999999999@0@0")
    end 
    if (MerdianssTimer) then
        globalTimer:RemoveTimer(MerdianssTimer)
        MerdianssTimer = nil
    end
    if bIfClose then 
        return 
    end 
    MerdianssTimer = globalTimer:AddTimer(100 ,function()
        local AcupointData = GetAcupointData[ibaseid]
        if not AcupointData then
            if ibaseid < 100 then  
                imaze = 1 
                ibaseid = ibaseid + 1 
            end
            return 
        elseif AcupointData.NextAcupointID ~= 0 and  AcupointData.OwnerMeridian < iStartNum then 
            imaze = 1 
            ibaseid = ibaseid + 1 
            return 
        end
        local seMeridiansInfo = {
            [0] = {
                dwMeridianID = AcupointData.OwnerMeridian,
                dwAcupointID = ibaseid,
            }
        }
        imaze = imaze + 1
        if imaze == iAddNum then 
            imaze = 1 
            ibaseid = ibaseid + 1 
            SystemUICall:GetInstance():Toast('OwnerMeridian : '.. AcupointData.OwnerMeridian .. ' ibaseid : '.. ibaseid)
        end
        SendMeridiansOpr(SMOT_LEVEL_UP, getTableSize2(seMeridiansInfo), seMeridiansInfo)

        if MeridiansDataManager:GetInstance():GetCurTotalExp() < 11418650 then  
            CheatDataManager:GetInstance():SendCheatCmd("CHET_ADD_MERIDIANS_EXP@999999999@0@0")
        end 
    end,-1)
end
function CheatUI:CheatPlayerData(text)
    local playerSetDataMgr = PlayerSetDataManager:GetInstance()
    ARENA_PLAYBACK_DATA = {
        dwBattleID = 0,
        dwRoundID = 0,
        dwPly1BetRate = 0,
        dwPly2BetRate = 0,
        defPlyWinner = 0,
        defBetPlyID = 0,
        dwBetMoney = 0,
        kPly1Data = {
            defPlayerID = playerSetDataMgr:GetPlayerID(),
            dwModelID = playerSetDataMgr:GetModelID(),
            acPlayerName = playerSetDataMgr:GetPlayerName(),
        },
        kPly2Data = {
            defPlayerID = 0,
            dwModelID = 0,
            acPlayerName = "0",
        }
    }
    local strList = string.split(text, '@')
    local battleID = tonumber(strList[1]) or 0
    local matchType = tonumber(strList[2]) or 5001
    SendChallengePlatRole(battleID,matchType)
end

function CheatUI:WaitAutoBattleTestHandle()
    WAIT_DISPLAY_MSG_MAX_TIME = 86400
    OpenWindowImmediately("LoadingUI")
    AddLoadingDelayRemoveWindow('LoadingUI', true)
end

return CheatUI
