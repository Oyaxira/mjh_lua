local l_dkJson = require("Base/Json/dkjson")
local l_gameConfigMgr = CS.GameApp.GameConfig.Instance 
local l_settingRootPath = './AutoTest/Setting/'
local l_settingPath = './AutoTest/AutoTest.json'
local l_settingMap = {}
local l_curRunning = nil
local l_nextCmdIndex = 0 
local l_executeDelay = 400
local l_curExecuteCount = 0
local l_timer

----------------------------- API -----------------------------
-- 模拟点击按钮
local function AutoTest_ClickButton(objectPath)
    local objButton = DRCSRef.FindGameObj(objectPath)
    if objButton then 
        local comButton = objButton:GetComponent(DRCSRef_Type.Button)
        if comButton then 
            comButton.onClick:Invoke()
            AutoTest_CmdExecuteComplete()
        end
    end
end

-- 模拟点击地图 NPC
local function AutoTest_ClickMapNpc(mapName, roleName)
    if IsWindowOpen('CityUI') then
        local mapMgrInst = MapDataManager:GetInstance()
        local roleMgrInst = RoleDataManager:GetInstance()
        local cityUI = GetUIWindow('CityUI')
        if cityUI then 
            for _, cityBuildingUI in ipairs(cityUI.cityBuildingUIList) do 
                if cityBuildingUI._gameObject.activeSelf then 
                    local mapData = cityBuildingUI.mapData
                    if (mapName == '主角家' and mapData.MainRoleHome == TBoolean.BOOL_YES) or (mapMgrInst:GetMapBuildingName(cityBuildingUI.mapData.BaseID) == mapName) then 
                        local roleList = mapMgrInst:GetRoleList(cityBuildingUI.mapID)
                        for _, thisRoleID in ipairs(roleList) do 
                            local thisRoleData = roleMgrInst:GetRoleData(thisRoleID)
                            local thisRoleName = roleMgrInst:GetRoleName(thisRoleID)
                            if thisRoleData and thisRoleName == roleName then 
                                RoleDataManager:GetInstance():TryInteract(thisRoleID, cityBuildingUI.mapID)
                                AutoTest_CmdExecuteComplete()
                                return
                            end
                        end
                    end
                end
            end
        end
    end
end

-- 模拟点击选项
local function AutoTest_ClickChoice(choiceStr)
    if IsWindowOpen('SelectUI') then 
        -- 在 SelectUI 中查找选项
        local selectUI = GetUIWindow('SelectUI')
        local childCount = selectUI.selectionContent.transform.childCount
        for i = 1, childCount do 
            local objChoice = selectUI.selectionContent.transform:GetChild(i - 1).gameObject
            if objChoice.activeSelf then 
                local comText = objChoice:FindChildComponent("Text", DRCSRef_Type.Text)
                local comButton = objChoice:GetComponent(DRCSRef_Type.Button)
                if comText and comButton then
                    if string.find(comText.text, choiceStr) then 
                        comButton.onClick:Invoke()
                        AutoTest_CmdExecuteComplete()
                        return
                    end
                end
            end
        end
    elseif IsWindowOpen('DialogChoiceUI') then
        -- 在 ChoiceUI 中查找选项
        local dialogChoiceUI = GetUIWindow('DialogChoiceUI')
        local choiceUI = dialogChoiceUI.ChoiceUIInstacne
        if choiceUI and choiceUI.objChoiceContent then 
            local childCount = choiceUI.objChoiceContent.transform.childCount
            for i = 1, childCount do 
                local objChoice = choiceUI.objChoiceContent.transform:GetChild(i - 1).gameObject
                if objChoice.activeSelf then 
                    local comButton = objChoice:GetComponent(DRCSRef_Type.Button)
                    local comText = objChoice:FindChildComponent("Text", DRCSRef_Type.Text)
                    if comButton and comText then
                        if string.find(comText.text, choiceStr) then 
                            comButton.onClick:Invoke()
                            AutoTest_CmdExecuteComplete()
                            return
                        end
                    end
                end
            end
        end
    end
end

-- 模拟选择门派
local function AutoTest_ClickClan(clanName)
    if IsWindowOpen('ClanUI') then
        local clanUI = GetUIWindow('ClanUI')
        if clanUI and clanUI.objClan_content then 
            local transform = clanUI.objClan_content.transform
            local childCount = transform.childCount
            for i = 1, childCount do 
                local objBlock = transform:GetChild(i - 1).gameObject
                if objBlock.activeSelf then 
                    local comClanNameText = objBlock:FindChildComponent("Text_name", DRCSRef_Type.Text)
                    if comClanNameText.text == clanName then 
                        local comButton = objBlock:GetComponent("Button")
                        if comButton then 
                            comButton.onClick:Invoke()
                            clanUI:OnClick_JoinClan()
                            AutoTest_CmdExecuteComplete()
                            return
                        end
                    end
                end
            end
        end
    end
end

-- 模拟点击建筑
local function AutoTest_ClickMap(mapName)
    if IsWindowOpen('CityUI') then
        local mapMgrInst = MapDataManager:GetInstance()
        local roleMgrInst = RoleDataManager:GetInstance()
        local cityUI = GetUIWindow('CityUI')
        if cityUI then 
            for _, cityBuildingUI in ipairs(cityUI.cityBuildingUIList) do 
                if cityBuildingUI._gameObject.activeSelf then 
                    local mapData = cityBuildingUI.mapData
                    if (mapName == '主角家' and mapData.MainRoleHome == TBoolean.BOOL_YES) or (mapMgrInst:GetMapBuildingName(cityBuildingUI.mapData.BaseID) == mapName) then 
                        local mapID = cityBuildingUI.mapID
                        SendClickMap(CMT_BUILDING, mapID)
                        AutoTest_CmdExecuteComplete()
                        return
                    end
                end
            end
        end
    end
end

-- 模拟点击返回场景
local function AutoTest_ClickReturnMap()
    if IsWindowOpen('CityUI') then
        SendClickMap(CMT_BACKRETURN)
        AutoTest_CmdExecuteComplete()
    end
end

-- 模拟点击城市
local function AutoTest_ClickCity(cityName)
    if IsWindowOpen('BigMapUI') then
        local bigMapUI = GetUIWindow('BigMapUI')
        if bigMapUI then
            local transform = bigMapUI.cityBox.transform
            local childCount = transform.childCount
            for i = 1, childCount do 
                local objCity = transform:GetChild(i - 1).gameObject
                local comCityNameText = objCity:FindChildComponent('city_name_back/city_name', DRCSRef_Type.Text)
                if objCity.activeSelf and comCityNameText.text == cityName then 
                    local comButton = objCity:FindChildComponent("Raycast", DRCSRef_Type.Button)
                    if comButton then 
                        comButton.onClick:Invoke()
                        AutoTest_CmdExecuteComplete()
                        return
                    end
                end
            end
        end
    end
end

-- 模拟点击退出迷宫
local function AutoTest_ClickQuitMaze()
    if IsWindowOpen('MazeUI') then
        SendClickMaze(CMAT_QUIT)
        AutoTest_CmdExecuteComplete()
    end
end

-- 模拟点击迷宫卡片, 会持续在迷宫中点击, 直到点到指定行列的卡片
local function AutoTest_ClickMazeCard(row, column, cardName, roleName, cardType)
    if IsWindowOpen('MazeUI') then
        -- TODO: 先检查指定行列有没有卡片, 没有直接终止测试并报错
        -- TODO: 判断指定行列能不能点到, 点不到就随机点张卡片 或者生成路线?
        -- TODO: 如果面前的卡片有冒险天赋要求, 检查要求, 如果满足要求, 解锁, 否则跳过
        AutoTest_CmdExecuteComplete()
    end
end

-- 模拟拾取所有冒险掉落
local function AutoTest_GetAllAdvLoot()
    if IsWindowOpen('CityUI') then
        -- 拾取城市场景冒险掉落
        local cityUI = GetUIWindow('CityUI')
        if cityUI.AdvlootList ~= nil then 
            for _, advLootUI in pairs(cityUI.AdvlootList) do 
                if advLootUI.comButton then 
                    advLootUI.comButton.onClick:Invoke()
                end
            end
        end
        -- 拾取城市建筑冒险掉落
        for _, cityBuildingUI in ipairs(cityUI.cityBuildingUIList) do 
            if cityBuildingUI._gameObject.activeSelf then 
                if cityBuildingUI.AdvlootList ~= nil then 
                    for _, advLootUI in pairs(cityBuildingUI.AdvlootList) do 
                        if advLootUI.comButton then 
                            advLootUI.comButton.onClick:Invoke()
                        end
                    end
                end
            end
        end
        AutoTest_CmdExecuteComplete()
    elseif IsWindowOpen('MazeUI') then
        -- 拾取迷宫冒险掉落
        local mazeUI = GetUIWindow('MazeUI')
        if mazeUI.MazeGridUiDict then 
            for _, GridList in pairs(mazeUI.MazeGridUiDict) do 
                for _, mazeGridUI in pairs(GridList) do 
                    if mazeGridUI.AdvlootList ~= nil then 
                        for _, advLootUI in pairs(mazeGridUI.AdvlootList) do 
                            if advLootUI.comButton then 
                                advLootUI.comButton.onClick:Invoke()
                            end
                        end
                    end
                end
            end
        end
        AutoTest_CmdExecuteComplete()
    end
end

-- 模拟点击邀请角色
local function AutoTest_ClickInviteNpc()
    if IsWindowOpen('SelectUI') then
        local selectUI = GetUIWindow('SelectUI')
        if selectUI:IsCanInvite() then 
            selectUI.comInviteButton.onClick:Invoke()
            AutoTest_CmdExecuteComplete()
        end
    end
end

-- 模拟点击决斗角色
local function AutoTest_ClickDuelNpc(ignoreLock)
    if IsWindowOpen('SelectUI') then
        local selectUI = GetUIWindow('SelectUI')
        if not selectUI:IsCanDuel() then 
            SystemTipManager:GetInstance():AddPopupTip("不满足决斗条件 请检查流程配置")
            AutoTest_StopAutoTest()
            return
        elseif ignoreLock ~= false and not selectUI:IsDuelUnlock() then
            SystemTipManager:GetInstance():AddPopupTip("决斗功能未解锁 请检查流程配置")
            AutoTest_StopAutoTest()
            return
        else
            SendNPCInteractOperCMD(NPCIT_FIGHT, selectUI.selectInfo.roleID)
            RemoveWindowImmediately('SelectUI')
            AutoTest_CmdExecuteComplete()
        end
    end
end

-- 模拟点击乞讨角色
local function AutoTest_ClickBegNpc(ignoreLock)
    if IsWindowOpen('SelectUI') then
        local selectUI = GetUIWindow('SelectUI')
        if not selectUI:IsCanBeg() then 
            SystemTipManager:GetInstance():AddPopupTip("不满足乞讨条件 请检查流程配置")
            AutoTest_StopAutoTest()
            return
        elseif ignoreLock ~= false and not selectUI:IsBegUnlock() then
            SystemTipManager:GetInstance():AddPopupTip("乞讨功能未解锁 请检查流程配置")
            AutoTest_StopAutoTest()
            return
        else
            selectUI.comBegButton.onClick:Invoke()
            AutoTest_CmdExecuteComplete()
        end
    end
end

-- 模拟提交物品
local function AutoTest_CommitItem(item1Name, item1Count)
    if item1Name == nil then 
        AutoTest_CmdExecuteComplete()
    end
    if IsWindowOpen('ShowBackpackUI') then
        local itemDataMgr = ItemDataManager:GetInstance()
        local showBackpackUI = GetUIWindow('ShowBackpackUI')
        if showBackpackUI and showBackpackUI.BackpackUICom and showBackpackUI.BackpackUICom.auiItemIDList then 
            item1Count = item1Count or 1
            for _, itemID in ipairs(showBackpackUI.BackpackUICom.auiItemIDList) do 
                local itemName = itemDataMgr:GetItemName(itemID)
                local itemNum = itemDataMgr:GetItemNum(itemID) or 1
                if string.find(itemName, item1Name) and itemNum >= (item1Count or 1) then 
                    showBackpackUI.chooseItems = {
                        itemID = itemID,
                        num = item1Count,
                    }
                    showBackpackUI:Submit(true)
                    AutoTest_CmdExecuteComplete()
                    break
                end
            end
        end
    end
end

----------------------------- Base -----------------------------
function AutoTest_ReloadAutoTestSetting()
    if not DEBUG_MODE then 
        return
    end
    l_settingMap = {}
    local configDict = l_gameConfigMgr:GetAllConfig(l_settingRootPath, false)
    for fileName, jsonStr in pairs(configDict) do 
        local settingData = l_dkJson.decode(jsonStr)
        if settingData and settingData.ID then 
            l_settingMap[settingData.ID] = settingData
        end
    end
end

function AutoTest_GetTestSetting(id)
    if l_settingMap == nil then 
        return
    end
    return l_settingMap[id]
end

function AutoTest_RunAutoTest(id)
    if AutoTest_IsRunning() then 
        SystemTipManager:GetInstance():AddPopupTip("正在执行自动化测试 ID:" .. tostring(l_curRunning.ID))
        return 
    end
    if l_nextCmdIndex > 0 then 
        return
    end 
    local testSetting = AutoTest_GetTestSetting(id)
    if testSetting == nil or testSetting.CmdList == nil or #testSetting.CmdList == 0 then 
        return
    end
    l_curRunning = testSetting
    local count = #testSetting.CmdList
    l_nextCmdIndex = 1
    if l_timer == nil or globalTimer:GetTimer(l_timer) == nil then 
        l_timer = globalTimer:AddTimer(l_executeDelay, AutoTest_ExecuteAutoTestCmd, -1)
    end
end

function AutoTest_ExecuteAutoTestCmd()
    if not AutoTest_IsRunning() then 
        return 
    elseif DisplayActionManager.GetInstance():GetActionListSize() > 0 then 
        -- Action 队列结束之前不执行下个指令
        local curActionType = DisplayActionManager.GetInstance():GetCurActionType() 
        if curActionType == DisplayActionType.PLOT_SHOW_CHOICE_WINDOW or curActionType == DisplayActionType.PLOT_CUSTOM_CHOICE or curActionType == DisplayActionType.PLOT_OPEN_SELECT_CLAN or curActionType == DisplayActionType.PLOT_SUBMIT_ITEM then 
        else
            return
        end
    elseif IsBattleOpen() then 
        -- 检查是否在战斗中, 如果是, 上行战斗胜利
        CheatDataManager:GetInstance():SendCheatCmd('CHET_BATTLEWIN')
    end
    local testCmd = l_curRunning.CmdList[l_nextCmdIndex]
    local cmdType = testCmd.CmdType
    local params = AutoTest_GetTestCmdParams(testCmd)
    if cmdType == 'ClickButton' then 
        AutoTest_ClickButton(table.unpack(params))
    elseif cmdType == 'ClickMapNpc' then
        AutoTest_ClickMapNpc(table.unpack(params))
    elseif cmdType == 'ClickChoice' then
        AutoTest_ClickChoice(table.unpack(params))
    elseif cmdType == 'ClickClan' then
        AutoTest_ClickClan(table.unpack(params))
    elseif cmdType == 'ClickMap' then
        AutoTest_ClickMap(table.unpack(params))
    elseif cmdType == 'ClickReturnMap' then
        AutoTest_ClickReturnMap(table.unpack(params))
    elseif cmdType == 'ClickCity' then
        AutoTest_ClickCity(table.unpack(params))
    elseif cmdType == 'ClickQuitMaze' then
        AutoTest_ClickQuitMaze(table.unpack(params)) 
    elseif cmdType == 'ClickMazeCard' then
        AutoTest_ClickMazeCard(table.unpack(params)) 
    elseif cmdType == 'ClickInviteNpc' then
        AutoTest_ClickInviteNpc(table.unpack(params)) 
    elseif cmdType == 'GetAllAdvLoot' then
        AutoTest_GetAllAdvLoot(table.unpack(params)) 
    elseif cmdType == 'ClickDuelNpc' then
        AutoTest_ClickDuelNpc(table.unpack(params)) 
    elseif cmdType == 'ClickBegNpc' then
        AutoTest_ClickBegNpc(table.unpack(params)) 
    elseif cmdType == 'CommitItem' then
        AutoTest_CommitItem(table.unpack(params)) 
    else
        AutoTest_CmdExecuteComplete()
    end
end

function AutoTest_GetTestCmdParams(testCmd)
    local params = {}
    if testCmd.Params ~= nil then 
        for _, value in ipairs(testCmd.Params) do 
            table.insert(params, value)
        end
    end
    return params
end

function AutoTest_CmdExecuteComplete()
    if l_curRunning == nil or l_curRunning.CmdList == nil or l_curRunning.CmdList[l_nextCmdIndex] == nil then 
        return
    end
    l_curExecuteCount = l_curExecuteCount + 1
    if l_curExecuteCount < (l_curRunning.CmdList[l_nextCmdIndex].LoopCount or 0) then 
        return
    end
    l_nextCmdIndex = l_nextCmdIndex + 1
    if l_nextCmdIndex > #l_curRunning.CmdList then 
        l_nextCmdIndex = 0
        l_curRunning = nil
        l_curExecuteCount = 0
    end
end

function AutoTest_IsRunning()
    return l_nextCmdIndex > 0 and l_curRunning ~= nil
end

function AutoTest_StopAutoTest()
    l_nextCmdIndex = 0
    l_curRunning = nil
    l_curExecuteCount = 0;
end

AutoTest_ReloadAutoTestSetting()
