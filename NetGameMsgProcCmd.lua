battleMsgQueue = {}

g_EnterMazeCount = 0
function DisplayGameData(kRetData)
    local info = globalDataPool:getData("GameData") or {}
    local lastGameState = GetGameState()
    local lastUIState = info['eCurUIState']

    info['eCurState'] = kRetData["eCurState"]
    info['eCurUIState'] = kRetData['eCurUIState']
    info['uiParam1'] = kRetData['uiParam1']
    info['uiParam2'] = kRetData['uiParam2']
    globalDataPool:setData('GameData', info, true)

    -- 判断 UIState 并打开相应界面
    local curUIState = info['eCurUIState']
    if (curUIState == US_WEEKITEM) then
        -- StorageOutUI 已经移除 不再使用
        -- if (IsWindowOpen('StorageOutUI') == false) then
        --     OpenWindowByQueue('StorageOutUI')
        -- end
    elseif (curUIState == US_DIFF) then
        if (IsWindowOpen('DifficultyUI') == false) then
            OpenWindowByQueue('DifficultyUI')
        end
    elseif (curUIState == US_SELECTITEM) then
        -- if (IsWindowOpen('ShowBackpackUI') == false) then
        --     OpenWindowByQueue('ShowBackpackUI')
        -- end
    elseif (curUIState == US_SELECTCLAN) then
        if (IsWindowOpen("ClanUI") == false) then
            -- 动画队列中的UIState
            local queueUIState = ShowDataRecordManager:GetInstance():GetEndRecordValue(SDRT_UISTATE, 0, 1)
            if queueUIState == nil or curUIState == queueUIState then
                OpenWindowImmediately("ClanUI")
            end
        end
    elseif (curUIState == US_CLANELIMINATE) then
        if (IsWindowOpen("ClanEliminateUI") == false) then
            OpenWindowImmediately("ClanEliminateUI",info)
        end
    elseif (curUIState == US_REMOVESELECT) then
        if (IsWindowOpen("Select") == true) then
            RemoveWindow("Select",info)
        end
    elseif (curUIState == US_CLANELIMATE) then
        DisplayBattle_ShowEmbattleUI({
            iRoundNum = 1,
            iAllRoundNum = 3,
            iCantChooseClan = info['uiParam1'],
            bShowRound = true,
            bEvilEliminate = info['uiParam2'] == 1
        })
    elseif (curUIState == US_CHOOSENPCUI) then
        if (IsWindowOpen("ChooseRoleUI") == false) then
            OpenWindowImmediately('ChooseRoleUI',true)
        end
    elseif (curUIState == US_CLANEBRANCHLIMINATE) then
        DisplayBattle_ShowEmbattleUI({
            iRoundNum = 1,
            iAllRoundNum = 2,
            iCantChooseClan = info['uiParam1'],
            bShowRound = true,
            bEvilEliminate = info['uiParam2'] == 1
        })     
    end
    if curUIState ~= lastUIState then 
        if curUIState == US_HIDE_MENU then 
            DisplayActionManager:GetInstance():HideMenuLayer(false)
        else
            DisplayActionManager:GetInstance():RecoverMenuLayer(false)
        end
    end
    
    if lastGameState ~= info['eCurState'] then 
        -- -- FIXME: GameState 下行时序与剧情不一致会导致剧情界面被卸载
        -- -- DisplayActionManager:GetInstance():AddAction(DisplayActionType.WIN_UNLOAD, false)
        if info['eCurState'] == GS_BIGMAP then
            if not IsWindowOpen("TileBigMap") then
                OpenWindowImmediately("TileBigMap")
            end
        end
        if info['eCurState'] == GS_MAZE then
            g_EnterMazeCount = g_EnterMazeCount + 1
        end

        if MOVE_MAZE_MAX_COUNT ~= nil and g_EnterMazeCount > MOVE_MAZE_MAX_COUNT then --每进迷宫10次 切一次场景
            if lastGameState == GS_MAZE then
                local uiCurMapID = MapDataManager:GetInstance():GetCurMapID()
                OpenWindowByQueue("LoadingUI", {
                    ["uiCurMapID"] = uiCurMapID
                })
                ChangeScenceByQueue("Town","LoadingUI",function()
                    -- 切换状态的时候清空交互记录信息
                    LuaEventDispatcher:dispatchEvent("QUITE_MAZE")
                    RoleDataManager:GetInstance():ClearInteractState()
                    DisplayUpdateScene()
                end)
                g_EnterMazeCount = 0
            elseif info['eCurState'] == GS_MAZE then
                local uiCurMazeID = MazeDataManager:GetInstance():GetCurMazeID()
                OpenWindowByQueue("LoadingUI", {
                    ["uiCurMazeID"] = uiCurMazeID
                })
                ChangeScenceByQueue("Maze","LoadingUI",function()
                    OpenWindowImmediately("LoadingUI", {
                        ["dontRemoveWhenLoadSceneFinish"] = true,
                        ["uiCurMazeID"] = uiCurMazeID
                    })
                    -- 切换状态的时候清空交互记录信息
                    RoleDataManager:GetInstance():ClearInteractState()
                    DisplayUpdateScene()
                end)
                g_EnterMazeCount = 0
            else
                -- 切换状态的时候清空交互记录信息
                RoleDataManager:GetInstance():ClearInteractState()
                DisplayUpdateScene()
            end
        else
            if lastGameState == GS_MAZE then
                LuaEventDispatcher:dispatchEvent("QUITE_MAZE")
            elseif lastGameState == GS_CREATEROLE then
                RemoveWindowImmediately("DifficultyUI")
                RemoveWindowImmediately("AchieveRewardUI")
            end
    
            -- 切换状态的时候清空交互记录信息
            RoleDataManager:GetInstance():ClearInteractState()
            DisplayUpdateScene()
        end
    end
end

function DisplayUpdateScene(runImmediately)
    local info = globalDataPool:getData("GameData") or {}
    local curState = info['eCurState']
    local uiName
    local paramsList = {n = 0}
    local lastGameState = GetGameState()

	-- RemoveWindowImmediately("ChatBoxUI")
    
    if (curState == GS_CREATEROLE) then
        DisplayUpdateCreateRole(runImmediately)
    elseif (curState == GS_NORMALMAP) then              -- 普通地图状态
        uiName = "CityUI"
        -- OpenWindowImmediately("ChatBoxUI")
    elseif (curState == GS_BIGMAP) then             -- 大地图状态
        uiName = "TileBigMap"
        -- OpenWindowImmediately("ChatBoxUI")
    elseif (curState == GS_MAZE) then               -- 迷宫状态
        uiName = "MazeUI"
        -- OpenWindowImmediately("ChatBoxUI")
    elseif (curState == GS_WEEK_END) then
        uiName = "ResultUI";
    elseif (curState == GS_FINAL_BATTLE) then       -- 大决战
        uiName = "FinalBattleUI"
        -- OpenWindowImmediately("ChatBoxUI")
    end
    if uiName then 
        if runImmediately == true then 
            OpenWindowImmediately(uiName, table.unpack(paramsList, 1, paramsList.n))
        else
            OpenWindowByQueue(uiName, table.unpack(paramsList, 1, paramsList.n))
        end
    end
end

function DisplayUpdateCreateRole(runImmediately)
    if not StoryDataManager:GetInstance():GetSpecialCreateRole() then
        if runImmediately == true then 
            OpenWindowImmediately("CreateRoleUI", nil, true)
        else
            OpenWindowByQueue("CreateRoleUI", nil, true)
        end
    else
        -- 无选择创角的剧本直接进入选择难度界面
        if runImmediately == true then 
            OpenWindowImmediately("DifficultyUI")
        else
            OpenWindowByQueue("DifficultyUI")
        end
    end
end

function DisplayDialog(KRetData)
    SystemUICall:GetInstance():Toast(string.format("收到逻辑的对话指令消息,内容为\n%s",KRetData["kContent"]))
end

-- 这里是创角时的一些数据
function DisplayCreateMainRole(kRetData)
    local info = globalDataPool:getData("CreateMainRole")
    local startRoleInfo = globalDataPool:getData("StartCreateMainRole")
    if info == nil then
        SetDataToGlobalPool("CreateMainRole",{})
        SetDataToGlobalPool("StartCreateMainRole",{})
        info = globalDataPool:getData("CreateMainRole")
        startRoleInfo = globalDataPool:getData("StartCreateMainRole")
    end
    if kRetData["bIsBabyRole"] == nil then
        startRoleInfo["akRoles"] = kRetData["akRoles"]  
    end
    info["iNum"] = kRetData["iNum"]                 -- 创角可用角色个数
    info["akRoles"] = kRetData["akRoles"]           -- 角色是否解锁/孩子，角色属性等
    info["uiFristLoginScript"] = kRetData["uiFristLoginScript"]
    info["bIsBabyRole"] = kRetData["bIsBabyRole"]
    LuaEventDispatcher:dispatchEvent("UPDATE_CREATE_ROLE", info)
end

function DisplayCreateBabyRole(kRetData)
    local info = {}
    info["iNum"] = kRetData["iNum"]                 -- 创角可用角色个数
    info["akRoles"] = kRetData["akRoles"]           -- 角色是否解锁/孩子，角色属性等
    info["bIsBabyRole"] = true                      -- 创建baby界面

    DisplayCreateMainRole(info)
    OpenWindowByQueue("CreateRoleUI", info)
end

--地图移动
function DisplayMapMove(kRetData)
    local destMapID = kRetData.uiMapID
    dprint(string.format('[NetGameMsg] -> SGC_DISPLAY_MAP_MOVE Map Is: %s', destMapID))
    MapDataManager:GetInstance():SetCurMapID(destMapID)
    -- 移动后清空交互记录信息
    RoleDataManager:GetInstance():ClearInteractState() 
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MAP_MOVE, false, destMapID)
end

local function InitMainRoleInfo()
    SetDataToGlobalPool("MainRoleInfo",{})
    local info = globalDataPool:getData("MainRoleInfo")
    info["MainRole"] = {}
    for dataType = MRIT_NULL, MRIT_NUMS do 
        info["MainRole"][dataType] = 0
    end
    return info
end

-- 主角信息
function DisplayMainRoleInfo(kRetData)
    local info = globalDataPool:getData("MainRoleInfo")
    if info == nil then
        info = InitMainRoleInfo()
    end
    for i = 0, #kRetData.akInfos do 
        local data = kRetData.akInfos[i]
        if data then
            info["MainRole"][data.uiDataType] = data.uiValue
            if data.uiDataType == MRIT_MAINROLEID then 
                info["iMainRoleID"] = data.uiValue
            end
        end
    end
    
    if info["MainRole"] then
        local  mainRole = info["MainRole"]
        MazeDataManager:GetInstance():SetCurMazeID(mainRole[MRIT_CUR_MAZE])
        MapDataManager:GetInstance():SetCurMapID(mainRole[MRIT_CURMAP])

        local  kPlayerSetMgr = PlayerSetDataManager:GetInstance()
        kPlayerSetMgr:SetPlayerSliver(mainRole[MRIT_SILVER])
        kPlayerSetMgr:SetPlayerCoin(mainRole[MRIT_CURCOIN])
        kPlayerSetMgr:SetPlayerPerfectPowder(mainRole[MRIT_PERFECTPOWDER])
        kPlayerSetMgr:SetPlayerRefinedIron(mainRole[MRIT_REFINEDIRON])
        kPlayerSetMgr:SetPlayerHeavenHammer(mainRole[MRIT_HEAVENHAMMER])
        kPlayerSetMgr:SetUnlockHouseState(mainRole[MRIT_UNLOCK_HOUSE], mainRole[MRIT_USER_RENAME_TIMES]) 
        kPlayerSetMgr:SetLowInCompleteTextNum(mainRole[MRIT_MARTIAL_LOW_INCOMPLETETEXT]) 
        kPlayerSetMgr:SetMidInCompleteTextNum(mainRole[MRIT_MARTIAL_MID_INCOMPLETETEXT]) 
        kPlayerSetMgr:SetHighInCompleteTextNum(mainRole[MRIT_MARTIAL_HIGH_INCOMPLETETEXT]) 
        kPlayerSetMgr:SetPlayerWangyoucao(mainRole[MRIT_WANGYOUCAO])
        kPlayerSetMgr:SetPlayerRefreshBall(mainRole[MRIT_REFRESHBALL])
        kPlayerSetMgr:SetCreatRoleID(mainRole[MRIT_CREATR_ROLE_ID])
        kPlayerSetMgr:SetMakeMartialSecretBook(mainRole[MRIT_MAKESCERETBOKK])

        kPlayerSetMgr:SetResDropActivityFuncValue(1, mainRole[MRIT_RESDROPACTIVITY_VALUE1])
        kPlayerSetMgr:SetResDropActivityFuncValue(2, mainRole[MRIT_RESDROPACTIVITY_VALUE2])
        kPlayerSetMgr:SetResDropActivityFuncValue(3, mainRole[MRIT_RESDROPACTIVITY_VALUE3])
        kPlayerSetMgr:SetResDropActivityFuncValue(4, mainRole[MRIT_RESDROPACTIVITY_VALUE4])
        kPlayerSetMgr:SetResDropActivityFuncValue(5, mainRole[MRIT_RESDROPACTIVITY_VALUE5])


        kPlayerSetMgr:SetTreasureExchangeValue(1, mainRole[MRIT_TREASUREEXCHANGE_VALUE1])
        kPlayerSetMgr:SetTreasureExchangeValue(2, mainRole[MRIT_TREASUREEXCHANGE_VALUE2])

        kPlayerSetMgr:SetFestivalValue(1, mainRole[MRIT_FESTIVAL_VALUE1])
        kPlayerSetMgr:SetFestivalValue(2, mainRole[MRIT_FESTIVAL_VALUE2])

        kPlayerSetMgr:SetTongLingYuValue(mainRole[MRIT_TONGLINGYU])

        kPlayerSetMgr:SetOpenTreasureMapTypes(mainRole[MRIT_PLAYEROPENED_TREASUREMAP])
        
        ResDropActivityDataManager:GetInstance():SetCurResDropCollectActivityID(mainRole[MRIT_CUR_RESDROP_COLLECTACTIVITY])

        local iCurScriptDiff = mainRole[MRIT_DIFF] or 1
        globalDataPool:setData("ScriptDiff", iCurScriptDiff, true)
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_MAIN_ROLE_INFO", info)

    if (g_CreateRoleWaitingLoadingFlag) then
        g_CreateRoleWaitingLoadingFlag = nil
        RemoveWindowImmediately("LoadingUI")
    end    
end

-- 更新队伍信息
function DisplayTeamInfo(kRetData)
    local info = globalDataPool:getData("MainRoleInfo")
    if info == nil then
        info = InitMainRoleInfo()
    end
    local auiTeammates = kRetData["auiTeammates"]            -- 队友ID列表
    local iTeammatesNum = kRetData["iTeammatesNum"]       -- 队友数量
    info["TeammatesNums"] = iTeammatesNum
    info["Teammates"] = auiTeammates
    local teammatesCheck = {}
    if auiTeammates and iTeammatesNum and (iTeammatesNum > 0) then
        for index = 0, iTeammatesNum - 1 do
            if auiTeammates[index] then
                teammatesCheck[auiTeammates[index]] = true
            end
        end
    end
    info["TeammatesCheck"] = teammatesCheck
    LuaEventDispatcher:dispatchEvent("UPDATE_TEAM_INFO", info)
end

-- 更新主角名称
function DisplayMainRoleName(kRetData)
    local info = globalDataPool:getData("MainRoleInfo")
    if info == nil then
        info = InitMainRoleInfo()
    end
    info["kName"] = kRetData["kName"]                       -- 主角名
end

-- 更新主角昵称
function DisplayMainRoleNickName(kRetData)
    local info = globalDataPool:getData("MainRoleInfo")
    if info == nil then
        info = InitMainRoleInfo()
    end
    local tbl = kRetData["auiNicks"] 
    local size = kRetData["iNicksNum"]
    if tbl then
        for i=0, size-1 do
            if tbl[i] then
                if not info["NpcNickName"] then
                    info["NpcNickName"] = {}
                end
                info["NpcNickName"][tbl[i].uiNpcID] = tbl[i].acName
            end
        end
    end
end

-- 主角宠物信息
function DisplayMainRolePetInfo(kRetData)
    local info = globalDataPool:getData("MainRoleInfo")
    if info == nil then
        SetDataToGlobalPool("MainRoleInfo",{})
        info = globalDataPool:getData("MainRoleInfo")
    end

    if  info and info["iMainRoleID"] == kRetData["iMainRoleID"]   then
        local totalNum = kRetData["iTotalNum"] 
        if totalNum == 0 then
            return
        end
        local curNum = kRetData["iPetsNum"]   

        if  curNum == totalNum then
            -- 覆盖更新
            info["PetsNum"] = kRetData["iPetsNum"]                  -- 宠物数量
            info["Pets"] = kRetData["auiPets"]                      -- 宠物数据
        else
            local oldNum = getTableSize(info["Pets"])
            for i = 0, kRetData["iPetsNum"] do
                info["Pets"][oldNum + i] =  kRetData["auiPets"][i]
            end
        end
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_MAIN_ROLE_INFO", info)
end
-- 创建角色
function DisplayRoleCreate(kRetData)
    local uiID = kRetData["uiID"]
    local bNewRole = kRetData["bNewRole"]
    local roleData = InstRole.new(uiID,{})
    RoleDataManager:GetInstance():UpdateRoleData(uiID, roleData)
    --RoleDataManager:GetInstance():AutoAddRole2EmbattleData(uiID)
    if (bNewRole > 0) then
        LuaEventDispatcher:dispatchEvent("DISPLAY_ROLE_CREATE", uiID)
    end
end
-- 删除角色
function DisplayRoleDelete(kRetData)
    local uiID = kRetData["uiID"]
    RoleDataManager:GetInstance():DeleteRoleData(uiID)
end
-- 更新角色通用信息
function DisplayRoleCommon(kRetData)
    RoleDataManager:GetInstance():UpdateRoleCommonData(kRetData)
end
-- 更新角色喜好信息
function DisplayRoleFavor(kRetData)
    RoleDataManager:GetInstance():UpdateRoleCommonData(kRetData)
end
-- 更新角色结义信息
function DisplayRoleBro(kRetData)
    RoleDataManager:GetInstance():UpdateRoleCommonData(kRetData)
end
-- 更新角色属性
function DisplayRoleAttrs(kRetData)
    local uiID = kRetData.uiID
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiID)
    if (roleData == nil)then
        dprint("更新角色属性,角色不存在,id=" .. uiID)
        return
    end
    roleData["aiAttrs"] = roleData["aiAttrs"] or {}
    roleData["aiBaseAttrs"] = roleData["aiBaseAttrs"] or {}
    -- for j = 0, SSD_MAX_ROLE_DISPLAYATTR_NUMS do
    --     roleData["aiAttrs"][j] = kRetData["aiAttrs"][j]
    -- end

    for j = 0, kRetData["iAttrsNums"] - 1 do
        local eType = kRetData["akAttrs"][j]["uiType"]
        local value = kRetData["akAttrs"][j]["iValue"]
        local baseValue = kRetData["akAttrs"][j]["iBaseValue"]

        roleData['aiAttrs'][eType] = value
        roleData['aiBaseAttrs'][eType] = baseValue
    end
      
    LuaEventDispatcher:dispatchEvent("UPDATE_GIFT",uiID, true)

    LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_ROLEATTRS",uiID, true)    
    BattleAIDataManager:GetInstance():ClearAIInfo(uiID)
end

function DisplayRoleItems(retStream)
    -- 更新角色物品信息
    local uiID = retStream.uiID
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiID)
    if (roleData == nil) then
        dprint("更新角色物品,角色不存在,id=" .. uiID)
        return
    end
    roleData["aiAttrs"] = roleData["aiAttrs"] or {}
    -- 判断是否是主角
    if uiID == RoleDataManager:GetInstance():GetMainRoleID() then 
        roleData["auiRoleItem"] = roleData["auiRoleItem"] or {}
        local itemMap = {}
        local temp_items = roleData["auiRoleItem"]
        for k,v in pairs(temp_items) do
            itemMap[v] = true
        end

        local DelItemNums = retStream["auiDelRoleItem"]
        for k,v in pairs(DelItemNums) do
            itemMap[v] = false
        end

        local ItemNums = retStream["auiRoleItem"]
        for k,v in pairs(ItemNums) do
            itemMap[v] = true
        end
        roleData["auiRoleItem"] = {}
        local temp_items = roleData["auiRoleItem"]
        local iIndex = 0
        for k,v in pairs(itemMap) do
            if v then 
                temp_items[iIndex] = k
                iIndex = iIndex + 1
            end
        end
    else
        -- 背包物品
        roleData["auiRoleItem"] = {}
        local itemNums = retStream["iItemNum"]
        for j = 0, itemNums do
            if retStream["auiRoleItem"][j] ~= 0 then 
                roleData["auiRoleItem"][j] = retStream["auiRoleItem"][j]
            end
        end
    end
    roleData["akEquipItem"] = {}
    -- 装备物品
    local uiItemID = nil
    for j = 0, REI_NUMS - 1 do
        uiItemID = retStream["auiEquipItem"][j]
        if uiItemID and (uiItemID ~= 0) then 
            roleData["akEquipItem"][j] = uiItemID
        end
    end
    ItemDataManager:GetInstance():SetReGenRoleEquipItemFlag()
    LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_ROLEITEMS",uiID, true)
end

function DisplayRoleMartials(retStream)
    -- 更新角色武学信息
    local uiID = retStream.uiID
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiID)
    if (roleData == nil) then
        dprint("更新角色武学,角色不存在,id=" .. uiID)
        return
    end
    roleData["auiRoleMartials"] = {}
    -- 填入信息
    local martialNums = retStream["iMartialNum"]
    for j = 0, martialNums do
        if retStream["auiRoleMartials"][j] ~= 0 then 
            roleData["auiRoleMartials"][j] = retStream["auiRoleMartials"][j]
        end
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_ROLE_MARTIALS",nil, true)
end

-- 物品数据删除
function DisplayItemDelete(retStream)
    ItemDataManager:GetInstance():DeleteItemData(retStream.uiID)
end

-- 物品数据更新        dwarning("更新角色物品,角色不存在,id=" .. uiID)
function DisplayUpdateItem(retStream)
    ItemDataManager:GetInstance():UpdateItemDataByArray(retStream.akRoleItem, retStream.iSize)
end  

--重铸属性更新
function DisplayItemReforge(retStream)
    LuaEventDispatcher:dispatchEvent("ReforgeAttrResult", retStream)
end

-- 任务提交物品更新
function DisplaySubmitItem(retStream)
    TaskDataManager:GetInstance():DisplayShowItem(retStream)
end

-- 武学数据删除
function DisplayMartialDelete(retStream)
    MartialDataManager:GetInstance():DeleteMartialData(retStream.uiID)
end

-- 武学数据更新
function DisplayMartialUpdate(retStream)
    MartialDataManager:GetInstance():UpdateMartialDataByArray(retStream.akRoleMartial, retStream.iSize)
end

function DisplayIncompleteBox(retStream)
    local win = GetUIWindow("IncompleteBoxUI")
    if win then
        win:RefreshUI(retStream)
    else
        OpenWindowByQueue('IncompleteBoxUI', retStream)
    end
end

-- 更新武学配置
function DisplayEmbattleMartialUpdate(retStream)
    MartialDataManager:GetInstance():UpdateEmbattleMartial(retStream)
end

-- 天赋更新
function DisplayRoleGift(retStream)
    -- 更新角色天赋信息
    local uiID = retStream.uiID
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiID)
    dprint(string.format("[NetGameMsg] -> 天赋更新 : roleID: %d",uiID))

    if (roleData == nil) then
        return
    end
        roleData["auiRoleGift"] = {}
        roleData["giftNum"] =  retStream["giftNum"]
        dprint(string.format("[NetGameMsg] -> 天赋更新 : 当前天赋个数: %d",roleData["giftNum"]))
        for i = 0, roleData["giftNum"] do
            if retStream["auiRoleGift"][i] ~= 0 then 
                roleData["auiRoleGift"][i] =  retStream["auiRoleGift"][i]
            end
        end
        --已使用天赋值
        roleData["uiGiftUsedNum"] = retStream["uiGiftUsedNum"]

        --剩余天赋点
        roleData["uiRemainGiftPoint"] = retStream["uiRemainGiftPoint"]

    LuaEventDispatcher:dispatchEvent("UPDATE_GIFT",uiID, true)
end

-- 天赋数据删除
function DisplayGiftDelete(retStream)
    GiftDataManager:GetInstance():DeleteGiftData(retStream.uiID)
end

-- 天赋数据更新
function DisplayGiftUpdate(retStream)
    GiftDataManager:GetInstance():UpdateGiftDataByArray(retStream.akRoleGift, retStream.iSize)
end


--天赋随机
function DisplayGiftRandom(retStream)
    dprint('[NetGameMsg] -> 获取随机天赋池')
    local uigifts = {}
    if  retStream["uiGifts"] then
        LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_RANDOMGIFT",retStream["uiGifts"] )
    end
end

-- 心愿数据删除
function DisplayWishTaskDelete(retStream)
    WishTaskDataManager:GetInstance():DeleteWishTaskData(retStream.uiID)
end

-- 心愿数据更新
function DisplayWishTaskUpdate(retStream)
    WishTaskDataManager:GetInstance():UpdateWishTaskDataByArray(retStream.akRoleWishTask, retStream.iSize)
end
-- 角色心愿数据更新
function DisplayRoleWishTasks(retStream)
    -- 更新角色星愿信息
    local uiID = retStream.uiID
    local roleData = RoleDataManager:GetInstance():GetRoleData(uiID)
    dprint(string.format("[NetGameMsg] -> 角色星愿更新 : roleID: %d",uiID))
    if (roleData == nil)then
        return
    end

    roleData["auiRoleWishTasks"] = {}
    dprint(string.format("[NetGameMsg] -> 星愿更新 : 当前星愿个数: %d",retStream.iWishTasksNum))

    for i = 0, retStream.iWishTasksNum do
        if retStream["auiRoleWishTasks"][i] ~= 0 then 
            local id = retStream["auiRoleWishTasks"][i]
            roleData["auiRoleWishTasks"][i + 1] = id
        end
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_WISHTASK",uiID)
end

--心愿奖励随机
function DisplayWishRewardsRandom(retStream)
    dprint('[NetGameMsg] -> 获取心愿奖励随机池')
    local uiWishRewards= {}
    if retStream["uiWishRewards"] then
        LuaEventDispatcher:dispatchEvent("UPDATE_DISPLAY_RANDOMWISHREWARDS", retStream["uiWishRewards"])
        local pickWishRewardsUI = OpenWindowImmediately("PickWishRewardsUI",{g_characterSelectRole, g_characterSelectWishTask})
        pickWishRewardsUI:RefreshGiftPool(retStream["uiWishRewards"])
    end
end

-- 完成心愿奖励
function DisplayRoleChooseWishReward(retStream)
    -- 关闭心愿奖励界面
    local PickWishRewardsUI = GetUIWindow("PickWishRewardsUI")
    if PickWishRewardsUI then
        RemoveWindowImmediately("PickWishRewardsUI",true)
    end
end

-- 更新成就数据
function OnRec_CMD_GAC_UPDATEACHIEVESAVEDATA(retStream)
    AchieveDataManager:GetInstance():UpdateAchieveDataByArray(retStream)
end

-- 更新成就领取记录数据
function OnRec_CMD_GAC_UPDATEACHIEVERECORDDATA(retStream)
    AchieveDataManager:GetInstance():UpdateAchieveRecordDataByArray(retStream)
end

-- 更新幸运值掉落完成情况
function OnRecv_CMD_GAC_UpdateDiffDropData(retStream)
    AchieveDataManager:GetInstance():UpdateDiffDropData(retStream, true)
end

-- 任务标识删除
function DisplayTaskTagDelete(retStream)
    TaskTagManager:GetInstance():DeleteTaskTagData(retStream.uiID)
end

-- 任务标识更新
function DisplayTaskTagUpdate(retStream)
    TaskTagManager:GetInstance():UpdateTaskTagByArray(retStream.akTag, retStream.iSize)
end

-- 门派挑衅界面
function DisplayClanEliminateShow(retStream)
    OpenWindowImmediately("ClanEliminateUI", retStream)
end

function DisplayAddTask(retStream)
    TaskDataManager:GetInstance():AddTaskData(retStream)
end

function DisplayUpdateTask(retStream)
    dprint("DisplayUpdateTask start")
    TaskDataManager:GetInstance():UpdateTaskData(retStream)
    dprint("DisplayUpdateTask end")
end

function DisplayTaskRemove(retStream)
    local taskID = retStream.uiID
    TaskDataManager:GetInstance():RemoveTaskData(taskID)
end


------------------------battle-------------
function AddBattleMsg(info)
    local logicMainInst =  LogicMain:GetInstance()
    battleMsgQueue[#battleMsgQueue+1] = info
    logicMainInst:ProcessStatisticalData(info)
end

function WaitPlotEnd()
    if #battleMsgQueue > 0 then 
        ShowBattleUIDialogueUI(true)
        ProcessNextBattleMsg()
    end
end

function ProcessNextBattleMsg()
    ProcessBattleMsg()
end

function ProcessBattleMsg()
    local l_LogicMain = LogicMain:GetInstance()
    -- 增加暂停功能
    if l_LogicMain:IsPauseAreanReplay() then 
        l_LogicMain:ProcessPauseReplay()
        return
    end
    l_LogicMain:SetCannotPauseAreanReplay() -- 在处理时不可暂停
    if #battleMsgQueue > 0 then 
        if #TimeLineHelper:GetInstance().traceInfo > 0 then 
            return
        end
        local msg = battleMsgQueue[1]
        table.remove(battleMsgQueue,1)
        if msg then 
            _LastBattleMsg = msg
            dprint('--process battlemsg:',msg[1])
            local ret = l_LogicMain[msg[1]](l_LogicMain,table.unpack(msg,2))
            if ret then 
                return ProcessBattleMsg()
            else
                if msg['auto'] then 
                    ProcessBattleMsg()
                end
            end
        end
    else -- 所有下行消息处理完后，再执行自动消息的上行
        if l_LogicMain:IsAutoBattle() then
            l_LogicMain:AutoBattle()  
        else
            local curUint = UnitMgr:GetInstance():GetCurOptUnit()
            if curUint and curUint:CanControl() and not l_LogicMain:IsGridShow() then 
               curUint:ShowSkillUI()
               curUint:ShowCanMoveGrid()
            end
        end
    end
    PlayQuitBattle()
end
local REMAINING_FUNC = {
    ['ProcessBattleLog'] = true,
    ['UpdateRound'] = true
}
function ProcessRemainingBattleLog()
    local msg = battleMsgQueue[1]
    table.remove(battleMsgQueue,1)
    if msg then 
        local l_LogicMain = LogicMain:GetInstance()
        _LastBattleMsg = msg
        dprint('--process battlemsg:',msg[1])
        if REMAINING_FUNC[msg[1]] then 
            l_LogicMain[msg[1]](l_LogicMain,table.unpack(msg,2))
        end
        ProcessRemainingBattleLog()
    end
end

function AddQuitBattleMsg(retStream)
    quitBattleMsg = retStream
    PlayQuitBattle()
end

function PlayQuitBattle()
    if quitBattleMsg and #battleMsgQueue == 0 then 
        local l_LogicMain = LogicMain:GetInstance()
        if l_LogicMain:CanQuitBattle() then 
            dprint('--process battlemsg:AddQuitBattleMsg')
            l_LogicMain:GameEnd(quitBattleMsg)
            quitBattleMsg = nil
            l_LogicMain:ExitBattleMsg()
        end
    end
end

function ClearBattleMsg()
    battleMsgQueue = {}
    quitBattleMsg = nil
end

function DisplayBattle_ShowEmbattleUI(retStream)
    if not IsWindowOpen('RoleEmbattleUI') then
        local embattleInfo = {}
        embattleInfo.bOpenByWheelWar = true
        embattleInfo.bOpenByFinalBattle = false
        embattleInfo.data = retStream
        OpenWindowByQueue("RoleEmbattleUI",embattleInfo,true)
    end
end

function DisplayBattleStart(retStream)
    dprint('--rev battlemsg:DisplayBattleStart')
    LogicMain:GetInstance():SetRun(true)
    AddBattleMsg({'StartBattle',retStream})
    AddBattleMsg({'ProcessPlot',Event.Event_ZhanDouKaiShi})
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleStart',retStream)
end

function DisplayBattleCreateUnit(retStream)
    dprint('--rev battlemsg:DisplayBattleCreateUnit')
    LogicMain:GetInstance():SaveUnitInfo(retStream)
    AddBattleMsg({'CreateUnit',retStream})
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleCreateUnit',retStream)
end

function DisplayBattleObserveUnit(retStream)
    dprint('--rev battlemsg:DisplayBattleObserveUnit')
    -- TODO:直接打开观察界面
    LogicMain:GetInstance():SetObserveData(retStream)
    OpenWindowImmediately("ObserveUI", {['unitID'] = retStream.akUnit.uiUnitIndex})
end

function DisplayBattleUpdateCombo(retStream)
    dprint('--rev battlemsg:DisplayBattleUpdateCombo')
    LogicMain:GetInstance():SaveComboInfo(retStream)
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleUpdateCombo',retStream)
end

function DisplayBattleUpdateUnit(retStream)
    dprint('--rev battlemsg:DisplayBattleUpdateUnit')
    AddBattleMsg({'UpdateUnit',retStream})
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleUpdateUnit',retStream)
end

function DisplayBattleUpdateBuffDesc(retStream)
    AddBattleMsg({'UpdateBuffDesc',retStream,['auto'] = true})
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleUpdateBuffDesc',retStream)
end
function DisplayBattleUpdateRound(retStream)
    AddBattleMsg({'UpdateRound',retStream,['auto'] = true})
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleUpdateRound',retStream)
end

function DisplayBattleUpdateOptUnit(retStream)
    dprint('--rev battlemsg:DisplayBattleUpdateOptUnit',retStream['uiUnitIndex'],retStream['iRound'],retStream['iFlag'])
    AddBattleMsg({'UpdateOptUnit',retStream})
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleUpdateOptUnit',retStream)
    LogicMain:GetInstance():RecordReciveServerInfo()
end

function DisplayBattleUpdateTreasureBox(retStream)
    dprint('--rev battlemsg:DisplayBattleUpdateTreasureBox')
    AddBattleMsg({'UpdateTreasureBox',retStream,['auto'] = true})
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleUpdateTreasureBox',retStream)
end

function DisplayBattleLog(retStream)
    dprint('--rev battlemsg:DisplayBattleLog')
    -- AddBattleMsg({'TransBattleLog',retStream,['auto'] = true})
end

function DisplayBattleUpdateHurtInfo(retStream)
    dprint('--rev battlemsg:DisplayBattleUpdateHurtInfo')
    _HurtInfoSum = (_HurtInfoSum or 0) + retStream.iNum
    _HurtInfoSumCur = retStream.iNum
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleUpdateHurtInfo',retStream)

    --添加Plot
    local tempPlot = nil
    for i=1,retStream.iNum do
        local SeBattle_HurtInfo = retStream.akBattleLog[i-1]
        --AddBattleMsg({'ProcessStartBattlePlot',SeBattle_HurtInfo})
        
        LogicMain:GetInstance():ProcessStartBattlePlot(SeBattle_HurtInfo)
        local hasPlot = false
        if SeBattle_HurtInfo.iPlotNum and SeBattle_HurtInfo.iPlotNum > 0 then 
            hasPlot = true
        end
        if hasPlot then
            AddBattleMsg({'AnalysisPlot',SeBattle_HurtInfo})
            AddBattleMsg({'ProcessPlot',Event.Event_DanWeiXingDongJieSu})
            AddBattleMsg({'ProcessPlot',Event.Event_DanWeiXingDongKaiShi})
            AddBattleMsg({'ProcessPlot',Event.Event_JiNengShiFangQian})
            --AddBattleMsg({'ProcessPlot',Event.Event_Choose})
            AddBattleMsg({'ProcessPlot',0})
        end
        if SeBattle_HurtInfo and SeBattle_HurtInfo.eSkillEventType == BSET_BeiDong_WUYUE then 
            -- 存储伤害信息
            BattleDataManager:GetInstance():SaveWuYueInfo(SeBattle_HurtInfo)
        else
            AddBattleMsg({'ProcessHurtInfo',SeBattle_HurtInfo})
        end
        -- if SeBattle_HurtInfo.bDeath > 0 then
        if hasPlot then
            AddBattleMsg({'ProcessPlot',Event.Event_DanWeiSiWang})
        end

        if hasPlot then 
            AddBattleMsg({'ProcessPlot',Event.Event_ZhaoChengShangHaiHou})
            AddBattleMsg({'ProcessPlot',Event.Event_FanJiQiDong})
        end
    end

    AddBattleMsg({'ProcessBattleLog',retStream,['auto'] = true})
end


function DisplayBattleGameEnd(retStream)
    dprint('--rev battlemsg:DisplayBattleGameEnd')
    AddBattleMsg({'ProcessPlot',Event.Event_BattleWin})
    AddBattleMsg({'ProcessPlot',Event.Event_BattleLose})
    AddBattleMsg({'ProcessPlot',Event.Event_auto_zhan4dou3jie2shu4})
    LogicMain:GetInstance():EnterBattleMsg()
    AddQuitBattleMsg(retStream)
    LogicMain:GetInstance():AddRecordMsg('DisplayBattleGameEnd',retStream)
end

function DisplayBattleAutoBattle(retStream)
    LogicMain:GetInstance():DisplayeLockAutoBattle(retStream)
end

function DisplayBattleCheck(retStream)
    if retStream.iResult ~= 0 then 
    end
end

function DisplayShopItemUpdate(retStream)
    if retStream.uiFlag == 1 then
        ShopDataManager:GetInstance():ClearShopItem()
    else
        ShopDataManager:GetInstance():UpdateBuyItem(retStream)
    end
end

function DisplayCityMove(retStream)
    -- 移动起点
    local srcCityID = retStream["uiSrcCityID"]
    -- 移动终点
    local dstCityID = retStream["uiDstCityID"]
    local p1 = retStream["uiEventSrcCityID"]
    local p2 = retStream["uiEventDstCityID"]
    local p3 = retStream["uiLastMoveDstCityID"]
    if true then --dstCityID & 0x10000000 ~= 0
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_BIGMAPLINEANIM, false, srcCityID, dstCityID, p1, p2, p3 )
        return 
    end
    -- 存在大地图事件的移动段起点
    -- 存在大地图事件的移动段终点
    -- 上次移动的目标城市
    -- 随机城市移动 NPC 数量
    local randomCityMoveNpcCount = retStream["uiRandomCityMoveNpcCount"]
    local randomCityMoveNpcInfos = retStream["akRandomCityMoveNpcInfos"]

end

function DisplayCityData(retStream)
    dprint("[NetGameMSg]->DisplayCityData")

    for i = 0, retStream.iNum do
        if i >= retStream.iNum then
			break
		end
        local cityData = retStream.akCitys[i]
        local cityID = cityData.uiCityID
        CityDataManager:GetInstance():UpdateCityData(cityID, cityData)
    end
end

function DisplayLogicDebugInfo(retStream)
    local LogicDebugInfo = retStream
    globalDataPool:setData("LogicDebugInfo",LogicDebugInfo,true)

    -- 输出函数消耗
    local kDesc = ""
    if (LogicDebugInfo["iFuncCallNums"] ~= nil) then
		for i = 0, LogicDebugInfo["iFuncCallNums"] - 1 do
			kDesc = kDesc .. string.format("%s \t Call Time:%s, Cost Time:%s ms\n", LogicDebugInfo["akFuncCallInfos"][i].acFuncName,LogicDebugInfo["akFuncCallInfos"][i].uiCallTimes,LogicDebugInfo["akFuncCallInfos"][i].uiCallCostTime)
		end
    end
    
    io.writefile("logicdebug.txt",kDesc)
end

function DisplayNPCInteractRandomItems(retStream)
    PlayerSetDataManager:GetInstance():DisableCoinAnim()
    RoleDataManager:GetInstance():RecoverInteractState()

    local npcConsultUI = WindowsManager:GetInstance():GetUIWindow('NpcConsultUI')
    if npcConsultUI and npcConsultUI.isFromMarry then
        OpenWindowImmediately("RandomRollUI", retStream)
    else
        -- OpenWindowByQueue("RandomRollUI", retStream)
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_OPEN_RANDOM_ROLL, false, retStream)
    end
end

function DisplayExecutePlot(retStream)
    local plotTaskID = retStream.uiTaskID
    local plotCount = retStream.uiPlotCount
    if (plotCount <= 0) then 
        return 
    end
    for i = 0, plotCount - 1 do 
        local plotID = retStream.auiPlotID[i]
        PlotDataManager:GetInstance():AddPlot(plotTaskID, plotID)
    end
end

function DisplayExecuteCustomPlot(retStream)
    local plotTaskID = retStream.uiTaskID
    dprint("[NetGameMSg]->DisplayExecuteCustomPlot")
    local paramsList = {}
    for i = 1, 10 do 
        table.insert(paramsList, retStream['sPlotParam' .. i])
    end
    PlotDataManager:GetInstance():AddCustomPlot(plotTaskID, retStream.uiPlotType, table.unpack(paramsList, 1, 10))
end

function DisplayInitBattleRole(retStream)
    RoleDataManager:GetInstance():InitRoleEmbattleData(retStream)
end

function DisplayUpdateEmbattleRolesRet(retStream)
    RoleDataManager:GetInstance():SaveRoleEmbattleData(retStream["iID"],retStream["iRound"], retStream["bSuccess"])
end

function DisplaySystemInfo(retStream)
    local infoType = retStream.eSysInfoType
    local infoContent = retStream.kContent
    if infoType == SIT_COMMON then 
        if DEBUG_MODE then
            -- 聊天框显示
            local ui = WindowsManager:GetInstance():GetUIWindow("ChatBoxUI")
            if ui then
                ui:AddNotice({channel = BroadcastChannelType.BCT_System, content = infoContent})
            end
        end
    elseif infoType == SIT_DIALOG then 
        if DEBUG_MODE then
            SystemTipManager:GetInstance():AddPopupTip(infoContent)
        end
    elseif infoType == SIT_TV then 
        SystemTipManager:GetInstance():AddRollTip(infoContent)
    elseif infoType == SIT_BUBBLE then
        SystemUICall:GetInstance():Toast(infoContent)
    end
end

--Toast消息   为求快速实现功能 这个函数实现的比较烂  之后重构下     by judith
function DisplayNewToast(retStream)
    AddDisplayNetMsgToast(retStream)
end

function DisplayMapUpdate(retStream)
    dprint("[NetGameMSg]->DisplayMapUpdate")
    local mapID = retStream.uiMapID
    MapDataManager:GetInstance():UpdateMapData(mapID, retStream.kMapData)
end

function DisplaAdvLootUpdate(retStream)
    dprint("[NetGameMSg]->DisplaAdvLootUpdate")
    AdvLootManager:GetInstance():UpdateAdvLoot(retStream)
end

function DisplayNpcUpdate(retStream)
    local roleID = retStream.uiID
    local npcData = retStream.kNpcData

    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if not roleData then
        roleData = NPCRole.new(roleID,npcData)
    elseif type(roleData.UpdateNPCRoleInfo) == 'function' then
        roleData:UpdateNPCRoleInfo(npcData)
    end

    RoleDataManager:GetInstance():UpdateRoleData(roleID, roleData)    
end

function DisplayNpcDelete(retStream)
    local roleID = retStream.uiID
    RoleDataManager:GetInstance():DeleteRoleData(roleID) 
end

function DisplayEvolutionUpdate(retStream)
    EvolutionDataManager:GetInstance():UpdateNpcEvolutionData(retStream)
end

function DisplayEvolutionDelete(retStream)
    EvolutionDataManager:GetInstance():RemoveNpcEvolutionData(retStream)
end

function DisplayEvolutionRecordUpdate(retStream)
    EvolutionShowManager:GetInstance():RecordUpdate(retStream)
end

function DisplayMonthEvolution(retStream)
    -- 演化 重制迷宫垃圾
    LuaEventDispatcher:dispatchEvent("DISPLAY_RESET_MAZEADVLOOT", retStream)
    EvolutionShowManager:GetInstance():MonthEvolutionShow(retStream.uiYear, retStream.uiMonth)
end

function DisplayNPCInteractGiveGift(retStream)
    LuaEventDispatcher:dispatchEvent("DISPLAY_GIVE_GIFT_RESOULT", retStream)
end

function DisplayDisposition(retStream)
    RoleDataManager:GetInstance():UpdateDisposition(retStream)
end

function DisplayWeekRoundItemOut(retStream)
    dprint('DisplayWeekRoundItemOut')

    OpenWindowByQueue("StorageInUI",retStream)
end

function DisplayMazeUpdate(retStream)
    local count = retStream.iNum
    for i = 0, count - 1 do 
        local mazeData = retStream.akMazeDatas[i]
        local mazeID = mazeData.uiID
        MazeDataManager:GetInstance():UpdateMazeData(mazeID, mazeData)
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_MAZE_DATA")
end

function DisplayMazeCardUpdate(retStream)
    local count = retStream.iNum
    for i = 0, count - 1 do 
        local cardData = retStream.akMazeCardDatas[i]
        local cardID = cardData.uiID
        MazeDataManager:GetInstance():UpdateMazeCardData(cardID, cardData)
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_MAZE_CARD_DATA")
end

function DisplayMazeAreaUpdate(retStream)
    local count = retStream.iNum
    for i = 0, count - 1 do 
        local areaData = retStream.akMazeAreaDatas[i]
        local areaID = areaData.uiID
        MazeDataManager:GetInstance():UpdateMazeAreaData(areaID, areaData)
    end
    LuaEventDispatcher:dispatchEvent("UPDATE_MAZE_AREA_DATA")
end

function DisplayMazeGridUpdate(retStream)
    local count = retStream.iNum
    for i = 0, count - 1 do 
        local gridData = retStream.akMazeGridDatas[i]
        local gridID = gridData.uiID
        MazeDataManager:GetInstance():UpdateMazeGridData(gridID, gridData)
        LuaEventDispatcher:dispatchEvent("UPDATE_MAZE_GRID_DATA",gridID)
    end
end

function DisplayMazeMove(retStream)
    local mazeID = retStream.uiMazeID
	local areaIndex = retStream.uiAreaIndex
	local curRow = retStream.uiCurRow
	local curColumn = retStream.uiCurColumn
	local destRow = retStream.uiDestRow
    local destColumn = retStream.uiDestColumn
    -- 迷宫移动后清空交互记录信息
    RoleDataManager:GetInstance():ClearInteractState()
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MAZE_MOVE, false, curRow, curColumn, destRow, destColumn)
end

function DisplayMazeMoveToNewArea(retStream)
    local mazeID = retStream.uiMazeID
    local areaIndex = retStream.uiAreaIndex
    -- 迷宫移动后清空交互记录信息
    RoleDataManager:GetInstance():ClearInteractState()
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.UPDATE_MAZE_UI, false)
end

function DisplayDynamicAdvLootUpdate(retStream)
    AdvLootManager:GetInstance():UpdateDynamicAdvLootData(retStream)
end

function DisplayClanInfoUpdate(retStream)
    local typeid = retStream.kClanEliminate.uiClanTypeID
    ClanDataManager:GetInstance():UpdateClanData(typeid, retStream.kClanEliminate)
end

function DisplayClanBranchResult(retStream)
    local bWin = retStream.iResult
    ClanDataManager:GetInstance():BattleResult(bWin)
end

function DisplayClanBranchInfo(retStream)
    local typeid = retStream.kClanBranch.uiClanTypeID
    ClanDataManager:GetInstance():UpdateClanBranchData(typeid, retStream.kClanBranch)    
end

function DisplayInteractDateUpdate(retStream)
    -- local uiRoleID = retStream.uiRoleID
    -- local eInteractType = retStream.eInteractType
    -- local uiTime = retStream.uiTimes
    RoleDataManager:GetInstance():UpdateInteractDate(retStream)
    LuaEventDispatcher:dispatchEvent("DISPLAY_INTERACT_DATE_UPDATE", retStream)    
end

-- 新增交互选项
function DisplayAddInteractChoice(retStream)
    local interactOption = retStream.kInteractOption
    local option = {}
    option.choiceLangID = interactOption.uiChoiceLangID
    option.lockLangID = interactOption.uiLockLangID
    option.isLock = interactOption.bIsLock
    option.roleTypeID = interactOption.uiRoleTypeID
    option.mapID = interactOption.uiMapID
    option.mazeTypeID = interactOption.uiMazeTypeID
    option.areaIndex = interactOption.uiAreaIndex
    option.cardID = interactOption.uiCardID
    option.row = interactOption.uiRow
    option.column = interactOption.uiColumn
    option.eInteractType = interactOption.eInteractType
    option.taskID = interactOption.uiTaskID
    option.refCount = 1
    RoleDataManager:GetInstance():AddInteractChoice(option)
end

-- 移除交互选项
function DisplayRemoveInteractChoice(retStream)
    local interactOption = retStream.kInteractOption
    local option = {}
    option.choiceLangID = interactOption.uiChoiceLangID
    option.lockLangID = interactOption.uiLockLangID
    option.isLock = interactOption.bIsLock
    option.roleTypeID = interactOption.uiRoleTypeID
    option.mapID = interactOption.uiMapID
    option.mazeTypeID = interactOption.uiMazeTypeID
    option.areaIndex = interactOption.uiAreaIndex
    option.cardID = interactOption.uiCardID
    option.row = interactOption.uiRow
    option.column = interactOption.uiColumn
    option.eInteractType = interactOption.eInteractType
    option.taskID = interactOption.uiTaskID
    option.refCount = 1
    RoleDataManager:GetInstance():RemoveInteractChoice(option)
end
local TDM = require("UI/TileMap/TileDataManager")
-- 新增 选择角色 事件
function DisplayAddRoleSelectEvent(retStream)
    if (retStream.uiMapTypeID & 0x70000000) ~= 0 then
        local p3 = retStream.uiMazeTypeID
        if retStream.uiRoleTypeID ~= 0 then
            p3 = 0
        end
        -- local str = string.format("%x", retStream.uiMapTypeID)
        -- derror(str .. "")
        return TDM:GetInstance():AddTileEvent(retStream.uiRoleTypeID, retStream.uiMapTypeID,p3,retStream.uiAreaIndex, retStream.uiCardTypeID, retStream.uiRow, retStream.uiColumn)
    end
    local roleEvent = {}
    roleEvent.roleTypeID = retStream.uiRoleTypeID
    roleEvent.mapTypeID = retStream.uiMapTypeID
    roleEvent.mazeTypeID = retStream.uiMazeTypeID
    roleEvent.areaIndex = retStream.uiAreaIndex
    roleEvent.cardTypeID = retStream.uiCardTypeID
    roleEvent.row = retStream.uiRow
    roleEvent.column = retStream.uiColumn
    roleEvent.refCount = 1
    RoleDataManager:GetInstance():AddRoleSelectEvent(roleEvent)
end

-- 移除 选择角色 事件
function DisplayRemoveRoleSelectEvent(retStream)
    if (retStream.uiMapTypeID & 0x70000000) ~= 0 then
        local p3 = retStream.uiMazeTypeID
        if retStream.uiRoleTypeID ~= 0 then
            p3 = 0
        end
        return TDM:GetInstance():RemoveTileEvent(retStream.uiMapTypeID, retStream.uiRoleTypeID, p3,retStream.uiAreaIndex, retStream.uiCardTypeID, retStream.uiRow, retStream.uiColumn)
    end
    local roleEvent = {}
    roleEvent.roleTypeID = retStream.uiRoleTypeID
    roleEvent.mapTypeID = retStream.uiMapTypeID
    roleEvent.mazeTypeID = retStream.uiMazeTypeID
    roleEvent.areaIndex = retStream.uiAreaIndex
    roleEvent.cardTypeID = retStream.uiCardTypeID
    roleEvent.row = retStream.uiRow
    roleEvent.column = retStream.uiColumn
    roleEvent.refCount = 1
    RoleDataManager:GetInstance():RemoveRoleSelectEvent(roleEvent)
end

function DisplayBegin(retStream)
    dprint('Display Begin')
    -- 检查当前场景是否正确
    CheckCurrentScene()
    -- 每次收到开始指令的时候清空记录
    OnNetMessageRecordClear()
    ResetDownloadNetMsgStat()
    LuaEventDispatcher.CanDispatchEventImmediately = false
    DisplayActionManager:GetInstance():CacheAllAction()
    if DEBUG_AUTO_PROFILER then 
        ProfilerStart()
    end
end

function DisplayEnd(retStream)
    dprint('Display End')
    LuaEventDispatcher.CanDispatchEventImmediately = true
    LuaEventDispatcher:dispatchEvent("NET_DISPLAY_END")
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.RECOVER_INTERACT_STATE, false)
    local curStoryID = GetCurScriptID()
    if g_isLoadStory and curStoryID then 
        PlotDataManager:GetInstance():LoadPlot(curStoryID)
        g_isLoadStory = false
    end
    DisplayActionManager:GetInstance():ProcActionCache()
    LuaEventDispatcher:ProcPendingEvent()
    if g_noPlayerCmd then 
        -- 检查是否无操作多次重复读档, 这种情况可能是游戏出现了卡死, 需要紧急处理
        g_noPlayerCmd = false
        g_checkNoPlayerCmdFrame = DRCSRef.Time.frameCount
        SetNoPlayerCmdLoadFlag()
        CheckNoPlayerCmdLoad()
    end
    g_hasReconnected = false
    g_afterReconnectedOprCount = 0
    if DEBUG_AUTO_PROFILER then 
        ProfilerStop(true)
    end
    -- 检查主角信息
    local mainRoleData = RoleDataManager:GetInstance():GetMainRoleData()
    if mainRoleData == nil and GetGameState() ~= GS_WEEK_END and GetGameState() ~= GS_WENDA and GetGameState() ~= GS_CREATEROLE and GetGameState() > GS_NULL then 
        -- 弹出紧急处理窗口
        ShowEmergencyWeekEndWindow()
    end
end

function DisplayTaskComplete(retStream)
    if not retStream then
        return
    end
    -- 任务完成的时候会下发任务的状态, 把这个状态更新到任务的缓存数据里去
    local iTaskID = retStream.uiID
    local eTaskProgress = retStream.uiTaskProgressType
    if (iTaskID and eTaskProgress) then
        local kTaskData = TaskDataManager:GetInstance():GetTaskData(iTaskID)
        if kTaskData then
            kTaskData.uiTaskProgressType = eTaskProgress
            TaskDataManager:GetInstance():SetTaskDynData(iTaskID, kTaskData)
            kTaskData.roleFinalDispositionDelta = {}
            for i = 1, retStream.uiFinalDispositionDeltaNums do 
                local index = i - 1
                local roleBaseID = retStream.auiFinalDispositionDeltaRole[index]
                local deltaValue = retStream.aiFinalDispositionDeltaValue[index]
                kTaskData.roleFinalDispositionDelta[roleBaseID] = deltaValue
            end
        end
    end
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TASK_COMPLETE, false, retStream)
end

function DisplayEnterCity(retStream)
    local uiCityID = retStream.uiCityID
    local mapID = CityDataManager:GetInstance():GetEnterMapID(uiCityID)
    if mapID ~= 0 then 
        CityDataManager:GetInstance():RunCityOpenAnim(mapID)
    end
end

function DisplayMazeUnlockGridChoice(retStream)
    local giftType = retStream.uiGiftType
    local giftLevel = retStream.uiGiftLevel
    local curGiftLevel = retStream.uiCurGiftLevel
    MazeDataManager:GetInstance():DisplayUnlockChoice(giftType, giftLevel, curGiftLevel)
end

function DisplayMazeUnlockGridSuccess(retStream)
    local giftType = retStream.uiGiftType
    local row = retStream.uiRow
    local column = retStream.uiColumn
    local roleID = retStream.uiRoleID
    MazeDataManager:GetInstance():DisplayUnlockGridSuccess(giftType, row, column, roleID)
end

function DisplayShowForeground(retStream)
    local globalEffectList = {}

    for index = 0, getTableSize(retStream.auiMapEffectID) - 1 do
        globalEffectList[index + 1] = retStream.auiMapEffectID[index]
    end

    MapEffectManager:GetInstance():UpdateMapEffectByQueue(globalEffectList)
end

function DisplayRefreshTimes(retStream)
    local ePBType = retStream.uiPlayerBehaviorType
    local uiTiems = retStream.uiRefreshTimes
    RoleDataManager:GetInstance():UpdateRefreshTimes(ePBType, uiTiems)
end

function DisplayTempBag(retStream)
    ItemDataManager:GetInstance():UpdateTempBagItems(retStream)
end

function DisplayUnlockRole(retStream)
    dprint('DisplayUnlockRole')
    LuaEventDispatcher:dispatchEvent("UPDATE_UNLOCK_ROLE", retStream)
end

function DisplayUnlockSkin(retStream)
    dprint('DisplayUnlockSkin')
    LuaEventDispatcher:dispatchEvent("UPDATE_UNLOCK_SKIN", retStream)
end

function DisplayClearInteractState(retStream)
    RoleDataManager:GetInstance():ClearInteractState()
end

function DisplayInviteUpdate(retStream)
    RoleDataManager:GetInstance():UpdateInviteable(retStream.uiRoleTypeID, retStream.uiInviteable)
end

function DisplayTriggerAdvGift(retStream)
    local giftType = retStream.uiAdvGiftType
    local itemTypeID = retStream.uiItemTypeID
    local coinCount = retStream.uiCoinCount
    --金钱搜刮
    if coinCount > 0 then 
        LogicMain:GetInstance():RecordAwardCoin(coinCount)
    end
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MAZE_TRIGGER_ADV_GIFT, false, giftType, itemTypeID, coinCount)
end

local CustomStrDecodeMap = {}
CustomStrDecodeMap['{RoleTitle}'] = function(uid)
    if not uid then
        return 'CustomStrDecodeMap error'
    end
    local TB_RoleTitle = TableDataManager:GetInstance():GetTable("RoleTitle")
    local kRoleTitle = TB_RoleTitle[uid]
    if kRoleTitle then
        return GetLanguagePreset(kRoleTitle.TitleID, "TB_RoleTitle not find")
    end

    return "TB_RoleTitle not find"
end

CustomStrDecodeMap['{RoleName}'] = function(uid)
    if not uid then
        return 'CustomStrDecodeMap error'
    end
    return RoleDataManager:GetInstance():GetRoleTitleAndName(uid, true, true)
end


CustomStrDecodeMap['{ClanName}'] = function(uid)
    if not uid then
        return 'CustomStrDecodeMap error'
    end

    local dbClanData = TB_Clan[uid]
            
    if dbClanData then
        return GetLanguagePreset(dbClanData.NameID, tostring(dbClanData.NameID) )
    end
    return 'clanid error'
end

CustomStrDecodeMap['{Num}'] = function(num)
    if not num then
        return 'CustomStrDecodeMap error'
    end

    return tonumber(num) or 0
end

CustomStrDecodeMap['{MarryCountMax}'] = function(num)
    if not num then
        return 'MarryCountMax error'
    end
    return tonumber(num) or 0
end

function DisplayDynamicToast(retStream)
    local uiLanguage = retStream.uiLanguage
    local auiCustomIDs = retStream.auiCustomIDs

    local matchCount = 0    
    local des = GetLanguagePreset(uiLanguage, "", true)
    if (des == nil) then
        return
    end
    local customStr = string.gsub(des, '{.-}', function(strtype)
        local newstr = "not handle"
        local funcHandler = CustomStrDecodeMap[strtype]
        if funcHandler then
            newstr = funcHandler(auiCustomIDs[matchCount])
        end
        matchCount = matchCount + 1 
        return newstr
    end)
    -- todo : 临时处理成 action
    if uiLanguage == 480071 or uiLanguage == 480072 then
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, false, customStr)
        return
    end
    SystemUICall:GetInstance():Toast(customStr, true)
end

function DisplayCustomPlotDialog(retStream)
    local uiPlotType = retStream.uiPlotType
    local uiRoleID = retStream.uiRoleID
    local uiLanguage = retStream.uiLanguage
    local auiCustomIDs = retStream.auiCustomIDs
    local uiRoleTypeID = RoleDataManager:GetInstance():GetRoleTypeID(uiRoleID) or 0

    if PlotType.PT_DIALOGUE == uiPlotType then
        uiPlotType = DisplayActionType.PLOT_DIALOGUE_STR
    elseif PlotType.PT_SHOW_CHOOSE_TEXT == uiPlotType then
        uiPlotType = DisplayActionType.PLOT_SHOW_CHOOSE_TEXT_STR
    else
        return
    end

    local matchCount = 0
    
    local des = GetLanguagePreset(uiLanguage, "", true)
    if (des == nil) then
        return
    end
    local customStr = string.gsub(des, '{.-}', function(strtype)
        local newstr = "not handle"
        local funcHandler = CustomStrDecodeMap[strtype]
        if funcHandler then
            newstr = funcHandler(auiCustomIDs[matchCount])
        end
        matchCount = matchCount + 1 
        return newstr
    end)

    DisplayActionManager:GetInstance():AddAction(uiPlotType, false, uiRoleTypeID, customStr)
end

function DisplayScriptRoleTitle(retStream)
    local uiTitleID = retStream.uiTitleID
    local uiUsed = retStream.uiUsed
    RoleDataManager:GetInstance():AddScriptRoleTitle(uiTitleID)
end

-- 更新计时器数据
function DisplayTimerUpdate(retStream)
    TaskDataManager:GetInstance():CacheTaskTimerData(retStream)
end

-- 更新周目统计数据
local function UpdateWeekRoundData(weekDataList, listSize)
    local weekRoundDataMap = globalDataPool:getData('WeekRoundDataMap') or {}
    for i = 0, listSize - 1 do 
        local weekData = weekDataList[i]
        if weekData then 
            weekRoundDataMap[weekData.uiEnumType] = weekData.uiCompleteNum
        end
    end
    SetDataToGlobalPool("WeekRoundDataMap", weekRoundDataMap)
end
function DisplayWeekRoundEnd(retStream)
    UpdateWeekRoundData(retStream.kStoryItem, retStream.iStoryItemCount)
    SetDataToGlobalPool("WeekRoundEnd", retStream)
    LuaEventDispatcher:dispatchEvent("ONEVENT_REF_RESULTUI")
end

function DisplayUpdateWeekRoundData(retStream)
    UpdateWeekRoundData(retStream.kStoryItem, retStream.iStoryItemCount)
end

function DisplayStartScriptArena(retStream)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_OPEN_SCRIPT_ARENA, false, retStream);
end

function DisplayScriptArenaBattleEnd(retStream)

    local arenaScriptDataManager = ArenaScriptDataManager:GetInstance();
    arenaScriptDataManager:ScriptArenaMatchData(retStream.uiTagValue);
    
    local arenaScriptMatchUI = GetUIWindow('ArenaScriptMatchUI');
    if not arenaScriptMatchUI or not arenaScriptMatchUI:IsOpen() then
        local matchTypeData = arenaScriptDataManager:GetMatchTypeData();
        OpenWindowImmediately('ArenaScriptMatchUI', matchTypeData);
        arenaScriptMatchUI = GetUIWindow('ArenaScriptMatchUI');
    end

    arenaScriptDataManager:CaculateMatch();
    arenaScriptMatchUI:DanMu();
    arenaScriptDataManager:GotoNextStage();
    arenaScriptDataManager:ScriptArenaDefCaculate();
    arenaScriptMatchUI:OnRefSCLeft1();
    arenaScriptMatchUI:OnRefLeftTop();
    arenaScriptMatchUI:OnRefLeftBot();
    arenaScriptMatchUI:MoveToCurRound();
end

function DisplayRedKnifeUpdate(retStream)
    local uiItemID = retStream.uiItemID
    local uiCuiLian = retStream.uiCuiLian
    RoleDataManager:GetInstance():UpdateRedKnife(uiItemID, uiCuiLian)
end

function DisplayBabyUpdate(retStream)
    local uiBabyRoleID = retStream.uiBabyRoleID
    local kBabyInfo = retStream.kBabyInfo
    RoleDataManager:GetInstance():UpdateBabyState(uiBabyRoleID, kBabyInfo)
end

function DisplayRedKnifeDelete(retStream)
    local uiItemID = retStream.uiItemID
    RoleDataManager:GetInstance():DeleteRedKnife(uiItemID)
end

function DisplayUpdateUnlockDisguise(retStream)
    local itemIDsMap = {}

    for index = 0, getTableSize(retStream.auiDisguiseItemIDs) - 1 do
        itemIDsMap[retStream.auiDisguiseItemIDs[index]] = true
    end

    globalDataPool:setData("UnlockDisguiseIDMap", itemIDsMap, true)
    local DisguiseUI = GetUIWindow("DisguiseUI")
    if DisguiseUI and DisguiseUI:IsOpen() then
         DisguiseUI:RefreshUI(DisguiseUI.roleID)
    end
end

function DisplayFinalBattleUpdateInfo(retStream)
    FinalBattleDataManager:GetInstance():UpdateInfo(retStream)
end

function DisplayFinalBattleUpdateCity(retStream)
    FinalBattleDataManager:GetInstance():UpdateCityInfo(retStream)
end

function DisplayUpdateDelegationTaskState(retStream)
    -- 更新门派委托任务状态
    local count = retStream.uiClanTaskCount
    for i = 0, count - 1 do
        local clanBaseID = retStream.auiClanIDList[i]
        local hasStartTask = false
        if retStream.auiHasStartClanDelegation[i] == 1 then 
            hasStartTask = true
        end
        ClanDataManager:GetInstance():SetDelegationTaskState(clanBaseID, hasStartTask)
    end

    -- 更新城市委托任务状态
    count = retStream.uiCityTaskCount
    for i = 0, count - 1 do
        local cityBaseID = retStream.auiCityIDList[i]
        local hasStartTask = false
        if retStream.auiHasStartCityDelegation[i] == 1 then 
            hasStartTask = true
        end
        CityDataManager:GetInstance():SetDelegationTaskState(cityBaseID, hasStartTask)
    end

    LuaEventDispatcher:dispatchEvent("UPDATE_DELEGATION_TASK_STATE")    
end

function DisplayShowDataEndRecord(retStream)
    ShowDataRecordManager:GetInstance():UpdateEndRecord(retStream)
end

function DisplayUnLeaveableUpdate(retStream)
    RoleDataManager:GetInstance():UpdateUnLeaveableRoleID(retStream.auiRoleID)
end

function DisplayCallHelpResult(retStream)
    LogicMain:GetInstance():CallHelpResultCallBack(retStream)
end

function DisplayStartGuide(retStream)
    local uiGuideID = retStream.uiGuideID
end

function DisplayUpdateChoiceInfo(retStream)
    TaskDataManager:GetInstance():LogChoiceInfo(retStream)
end

function DisplayClearChoiceInfo(retStream)
    local taskID = retStream.uiTaskID
    TaskDataManager.GetInstance():ClearChoiceInfo(taskID)
    if taskID == g_curChoiceTask or taskID == 0 then 
        g_curChoiceTask = nil
        RemoveWindowImmediately('DialogChoiceUI')
        DisplayActionEnd()
    end
end

function DisplayPlayMazeRoleAnim(retStream)
    local row = retStream.uiRow
    local column = retStream.uiColumn
    local animType = retStream.uiAnimType
    local isLoop = retStream.bIsLoop == 1
    local needRecover = retStream.bNeedRecover == 1

    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MAZE_PLAY_CLICK_ROLE_ANIM, false, row, column, animType, isLoop, needRecover)    
end

function DisplayShowMazeRoleBubble(retStream)
    local contentLangID = retStream.uiContentLangID
    local roleID = retStream.uiRoleID
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MAZE_SHOW_BUBBLE, false, contentLangID, roleID)
end

function DisplayMazeEnemyEscape(retStream)
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.MAZE_ENEMY_ESCAPE, false, retStream.uiGridID, retStream.uiRoleExp, retStream.uiMartialExp)
end

function DisplayHighTowerBaseInfo(retStream)
    HighTowerDataManager:GetInstance():UpdateBaseInfo(retStream)
end

function DisplayHighTowerRestRoles(retStream)
    HighTowerDataManager:GetInstance():UpdateRestRoles(retStream)
end


function DisplayCloseGiveGift()
    RemoveWindowImmediately("GiveGiftDialogUI")
end

-- 决斗
function DisplayDuelRole(retStream)
    -- 切换状态的时候清空交互记录信息
    RoleDataManager:GetInstance():ClearInteractState()
    
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_MAP_ROLE_ESCAPE, false, retStream.uiRoleID)
    if (retStream.uiMapID & 0x70000000) ~= 0 then
        TileDataManager:GetInstance():RemoveTileEvent(retStream.uiMapID, retStream.uiRoleID)
    end
end

function DisplayShowChoiceWindow(retStream)
    local taskID = retStream.uiTaskID
    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_SHOW_CHOICE_WINDOW, false, taskID)
end
function DisplayShowChooseRole(retStream)
    OpenWindowImmediately('ChooseRoleUI',true)
end

function DisplayStartShareLimitShop(retStream)
    local typeid = retStream.uiParam1
    local iEndTime = retStream.uiParam2
    if iEndTime and iEndTime ~= 0 then 
        -- shareend 时间改成overtime
        LimitShopManager:GetInstance():SetShareEndTime(iEndTime)
    end 


    DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_OPENLIMITSHOP, false)

end

function DisplayAIInfo(retStream)
    BattleAIDataManager:GetInstance():ReviceServerAI(retStream)
end

function DisplayDiffDropInfo(retStream)
    AchieveDataManager:GetInstance():UpdateDiffDropData(retStream, false)
end

function DisplayMartialStrongResult(retStream)
    if retStream.iResult == ENUM_MSEC_ERROR then 
        SystemUICall:GetInstance():Toast('[武学研读] 数据错误，未进行研读')
        return
    end

    local bRefreshUI = false
    if retStream.iResult == ENUM_MSEC_FAILED then
        SystemUICall:GetInstance():Toast(GetLanguageByID(730003))
    elseif retStream.iResult == ENUM_MSEC_SUCCESS then
        SystemUICall:GetInstance():Toast(GetLanguageByID(730004))
    end
    LuaEventDispatcher:dispatchEvent("UpdateMartialStrongUI", retStream)
    MartialDataManager:GetInstance():DispatchUpdateEvent()
end

function DisplayMakeMartialSecret(retStream)
    if retStream.iResult == 0 then 
        SystemUICall:GetInstance():Toast('秘籍生成失败')
        return
    end
end

-- 捏脸
function OnRecv_CMD_GC_DISPLAY_ROLEFACERESULT(kRetData)
    -- 解锁上传回调
    LuaEventDispatcher:dispatchEvent(CreateFaceManager.NET_EVENT.RoleFaceOprRet, kRetData)
end

function OnRecv_CMD_GC_DISPLAY_ROLEFACEQUERY(kRetData)
    -- 查询回调
    LuaEventDispatcher:dispatchEvent(CreateFaceManager.NET_EVENT.AllRoleFaceRet, kRetData)
end


-- 显示资源掉落活动
function DisplayResDropActivity(retStream)
    if not retStream then
        return
    end

    -- 活动结束, 经脉经验转换提醒
    if retStream.iAddMeridianExp and retStream.iAddMeridianExp > 0 then
        local strTitle = (retStream.bIsNew == 1) and "新的收集活动已经开启" or "上期收集活动已经结束"
        local strMsg = string.format("%s，上期收集活动中尚未兑换使用的资源已为您转化为%d经脉经验，发放至您的账户。", strTitle, retStream.iAddMeridianExp)
        SystemUICall:GetInstance():WarningBox(strMsg)
    end

    local win = GetUIWindow("CollectActivityUI")
    if not win then
        return
    end
    win:OnRecvActivityInfo(retStream)
end

-- 显示收集活动兑换结果
function DisplayCollectActivityExchangeRes(retStream)
    if not retStream then
        return
    end
    local win = GetUIWindow("CollectActivityUI")
    if not win then
        return
    end
    if retStream.bRes == 0 then
        SystemUICall:GetInstance():Toast("兑换失败")
        return
    end
    SystemUICall:GetInstance():Toast("兑换成功")
    win:UpdateBoard(retStream.uiCollectActivityID, retStream.uiExchangeNum)
end

-- 更新同剧本玩家数据
function DisplayUpdateSameThreadPlayer(retStream)
    local playerID = retStream.uiPlayerID
    RoleDataManager:GetInstance():UpdatePlayerInfo(playerID, retStream)
end

-- 通知客户端切磋其他玩家
function DisplayNoticeClientFightPlayer(retStream)
    ArenaDataManager:GetInstance():ChallengePlatRoleRePlay(retStream.uiPlayerID, retStream.uiModelID, retStream.acPlayerName)
end

-- 通知客户端添加其他玩家为好友
function DisplayNoticeClientAddPlayerFriend(retStream)
    SocialDataManager:GetInstance():AddFriend(retStream.uiFriendPlayerID, retStream.acOpenID, retStream.acVOpenID)
end

-- 通知客户端角色升级信息
function DisplayLevelUP(retStream)
    if (not retStream) 
    or (not retStream.uiRoleID)
    or (retStream.uiRoleID == 0) then
        return
    end
    local uiRoleID = retStream.uiRoleID
    local uiOldLevel = retStream.uiOldLevel or 0
    local uiNewLevel = retStream.uiNewLevel or 0
    -- 从 0 升上来的一般都是在初始化, 不做显示
    -- 等级没变化的, 也不做显示
    if (uiOldLevel == 0)
    or (uiOldLevel == uiNewLevel) then
        return
    end
    -- 要求升级界面阻塞, 但是后面过来的升级信息也要更新进ui
    -- 所以在升级信息来的时候, 直接往本地缓存里塞升级信息
    -- 如果某次塞缓存信息之前, 本地升级信息缓存是空的,
    -- 那么添加一个Action用来在队列里打开升级界面
    -- 如果不是空的, 并且此时升级界面已经是打开了的, 那么缓存数据后刷新当前升级界面
    local bHasCacheBefore = RoleDataManager:GetInstance():HasLevelUpMsgCached()
    local bCacheRes = false
    -- 武学升级
    if retStream.uiMartialID and retStream.uiMartialID > 0 then
        bCacheRes = MartialDataManager:GetInstance():CacheMartialLevelUpMsg(uiRoleID, retStream.uiMartialID, uiOldLevel, uiNewLevel, retStream.bHasNewAttr == 1)
    else
    -- 角色升级
        bCacheRes = RoleDataManager:GetInstance():CacheRoleLevelUpMsg(uiRoleID, uiOldLevel, uiNewLevel)
    end
    if not bCacheRes then
        return
    end
    if bHasCacheBefore ~= true then
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_OPEN_LEVEL_UP, false)
    elseif IsWindowOpen("LevelUPUI") == true then
        RoleDataManager:GetInstance():ShowLevelUpMsg()
    end
end

-- 清空所有角色交互选项和任务选项信息
function DisplayClearAllChoiceInfo(retStream)
    RoleDataManager:GetInstance():ClearInteractChoice()
    TaskDataManager.GetInstance():ClearAllChoiceInfo() 
end

function DisplayShowCommonEmbattle(retStream)
    local eType = retStream.uiType
    local info = { eCommomEmbattleType = eType }

    OpenWindowByQueue("RoleEmbattleUI", info)
end

-- 更新自定义冒险掉落
function DisplayUpdateCustomAdvLoot(kRetData)
    AdvLootManager:GetInstance():UpdateCustomAdvLoot(kRetData.uiTaskEventID, dnull(kRetData.bEnable))
end

--更新易容界面
function OnRecv_CMD_GC_DISPLAY_DISGUISE(kRetData)
   if kRetData.bRefresh then
        local DisguiseUI = GetUIWindow("DisguiseUI")
        if DisguiseUI and DisguiseUI:IsOpen() then
            DisguiseUI:RefreshUI(DisguiseUI.roleID)
        end
   end
end