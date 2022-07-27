function AddDisplayNetMsgToast(retStream)
    local baseID = retStream.uiBaseID
    local cfg_data = TableDataManager:GetInstance():GetTableData("Toast",baseID)
    if cfg_data == nil then return end
    local function CheckToastType(eType)
        return cfg_data.ToastType == eType
    end
    if CheckToastType(ToastType.TTAP_auto_jia1ru4dui4wu3jie4mian4) then
        local uiID = retStream.uiParam1 -- ItemTypetoast
        OpenWindowByQueue("RoleShowUI", {uiID, true})
        return
    elseif CheckToastType(ToastType.TTAP_auto_jia1ru4le0ni3de0dui4wu3) then
        local uiID = retStream.uiParam1 -- ItemType
        OpenWindowByQueue("RoleShowUI", {uiID, false})
        return
    else
        DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_NETMSG_TOAST, false, retStream)
    end
end

function DisplayNetMsgToast(retStream)
    local baseID = retStream.uiBaseID
    local bShowInChatOnly = (retStream.bShowInChatOnly == 1)
    local cfg_data = TableDataManager:GetInstance():GetTableData("Toast",baseID)
    local str_t = {}
    local index2param = {
        [1] = 'uiParam1',
        [2] = 'uiParam2',
        [3] = 'uiParam3',
    }

    local function DoToast(text, bShowChat)
        if bShowInChatOnly then
            SystemUICall:GetInstance():AddChat2BCT(text)
            return
        end
        SystemUICall:GetInstance():Toast(text, bShowChat)
    end

    local function CheckToastType(eType)
        return cfg_data.ToastType == eType
    end

    if CheckToastType(ToastType.TTAP_TEXT) then
        local content = GetLanguageByID(retStream.uiParam1)
        if content ~= "" then
            DoToast(content, cfg_data.IsShowChatBox == 1)
        end
        return
    end

    if CheckToastType(ToastType.TTAP_TREASURE_EXCHANGE_NEW_START) then
        if retStream.uiParam1 and retStream.uiParam1 > 0 then 
            local strMsg = string.format("秘宝大会已经结束, 上一期秘宝大会的过期资源将转化为%d经脉经验, 发放至您的账户", retStream.uiParam1 or 0)
            SystemUICall:GetInstance():WarningBox(strMsg)
        end 
        return
    end
    
    if CheckToastType(ToastType.TTAP_auto_shi3yong4dan1yao4) then
        -- 属性丹使用上限
        local uiRoleID = retStream.uiParam1 
        local uiUsedNum = retStream.uiParam2 
        local uiItemID = retStream.uiParam3
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",uiItemID)
        local sRoleName = RoleDataManager:GetInstance():GetRoleName(uiRoleID)
        if  itemTypeData and itemTypeData.Value2 then
            local content = GetLanguageByID(cfg_data.LanguageID)
            content = string.format(content, sRoleName,uiUsedNum, itemTypeData.ItemName)
            DoToast(content, cfg_data.IsShowChatBox == 1)
        end
        return
    end
    
    if CheckToastType(ToastType.TTAP_auto_shi3yong4dan1yao4ji4lu4) then
        local uiRoleID = retStream.uiParam1 
        local uiItemID = retStream.uiParam2
        local uiUsedNum = retStream.uiParam3
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",uiItemID)
        local sRoleName = RoleDataManager:GetInstance():GetRoleName(uiRoleID)
        if  itemTypeData and itemTypeData.Value2 then
            local uiLimitNum = itemTypeData.Value2
            local content = GetLanguageByID(cfg_data.LanguageID)
            content = string.format(content,sRoleName, itemTypeData.ItemName or '',uiUsedNum,itemTypeData.Value2)
            DoToast(content, cfg_data.IsShowChatBox == 1)
        end
        return
    end

    if CheckToastType(ToastType.TTAP_auto_jia1ru4le0ni3de0dui4wu3) then
        local uiID = retStream.uiParam1 -- ItemType
        local sRoleName = RoleDataManager:GetInstance():GetRoleName(uiID)
        local content = GetLanguageByID(cfg_data.LanguageID)
            content = string.format(content,sRoleName)
            DoToast(content, cfg_data.IsShowChatBox == 1)
        return
    end

    if  CheckToastType(ToastType.TTAP_auto_jiao3se4hao3gan3du4zeng1jia1) then 
        PlayButtonSound("EventFavorUp")
    end 

    if  CheckToastType(ToastType.TTAP_auto_jiao3se4shu3xing4zeng1jia1) then 
        PlayButtonSound("EventAttrUp")
    end 

    -- 特殊处理绿矾油获得不显示
    if  CheckToastType(ToastType.TTAP_auto_huo4de2dao4ju4) and retStream.uiParam1 == 9652 then 
        return
    end 

    if  CheckToastType(ToastType.TTAP_auto_huo4de2dao4ju4) and retStream.uiParam1 == 9609 then 
        -- 如果是经验 客户端做显示区分 
        baseID = 36 
        cfg_data = TableDataManager:GetInstance():GetTableData("Toast",baseID)
    end 
    if cfg_data == nil then
        derror('Cannot find toast data! BaseID:' .. tostring(baseID))
    end


    if CheckToastType(ToastType.TTAP_auto_huo4de2dao4ju4) then       
        -- 获得道具 判断是残章 且暗金以上 客户端做次数记录  
        local id = retStream.uiParam1
        local TB_Item = TableDataManager:GetInstance():GetTable("Item")
        local itemTypeData = TB_Item[id]
        if itemTypeData and itemTypeData.ItemType == ItemTypeDetail.ItemType_IncompleteBook and itemTypeData.MartialID ~= 0 then 
            local data = GetTableData("Martial",itemTypeData.MartialID)
            if data and data.Rank and data.Rank >= RankType.RT_DarkGolden then
                local iinum = retStream[index2param[cfg_data.ValueIndex]]
                LimitShopManager:AddCheckData(LimitShopType.eMartialPiece,iinum)
            end  
        end
    end 
    if  CheckToastType(ToastType.TTAP_auto_huo4de2) or CheckToastType(ToastType.TTAP_auto_shi1qu4) then
        --获得铜币,元宝,银锭
        local type = retStream.uiParam1 -- ItemType
        local value = retStream.uiParam2 -- value

        local str_type = TOAST_MONEY_TYPE[type]
        str_t[cfg_data.ItemIndex] = tostring(str_type)
        str_t[cfg_data.ValueIndex] = tostring(value)

        local content = GetLanguageByID(cfg_data.LanguageID)
        content = string.format(content,table.unpack(str_t))
        DoToast(content, cfg_data.IsShowChatBox == 1)
        return
    end

    if CheckToastType(ToastType.TTAP_START_TASK) then
        local taskID = retStream.uiParam1
        local taskTypeData = TaskDataManager:GetInstance():GetTaskTypeDataByID(taskID)
        if taskTypeData then 
            local content = GetLanguageByID(cfg_data.LanguageID)
            local nameID = taskTypeData['NameID']
            if nameID and nameID ~= 0 then 
                local text = string.format(content, GetLanguageByID(nameID, taskID))
                SystemUICall:GetInstance():TaskBeginToast(text)
            end
        end
        return
    end
    
    if CheckToastType(ToastType.TTAP_auto_cheng2wei2zhan4dou3ti4bu3) then
        local roleTypeIDA = retStream.uiParam1
        local roleTypeIDB = retStream.uiParam2

        local nameA = RoleDataManager:GetInstance():GetRoleTitleAndName(roleTypeIDA, true)
        local nameB = RoleDataManager:GetInstance():GetRoleTitleAndName(roleTypeIDB, true)

        local content = GetLanguageByID(cfg_data.LanguageID)
        content = string.format(content, nameB, nameA)
        DoToast(content, cfg_data.IsShowChatBox == 1)
        return
    end


    if CheckToastType(ToastType.TTAP_auto_cheng2wei2shen2xian1ban4lv3) then
        local roleTypeIDA = retStream.uiParam1
        local roleTypeIDB = retStream.uiParam2

        local nameA = RoleDataManager:GetInstance():GetRoleTitleAndName(roleTypeIDA, true, true)
        local nameB = RoleDataManager:GetInstance():GetRoleTitleAndName(roleTypeIDB, true, true)

        local content = GetLanguageByID(cfg_data.LanguageID)
        content = string.format(content, nameB, nameA)
        DoToast(content, cfg_data.IsShowChatBox == 1)
        return
    end

    if CheckToastType(ToastType.TTAP_auto_fa1xian4bao3cang2) then
        -- local mazeTypeID = retStream.uiParam1
        -- local mazeLevelIndex = retStream.uiParam2
        -- local nameA = MazeDataManager:GetInstance():GetMazeName(mazeTypeID)
        local cityID = retStream.uiParam1
        local nameA = CityDataManager:GetInstance():GetCityShowName(cityID)
        local content = GetLanguageByID(cfg_data.LanguageID)
        content = string.format(content, nameA, 0)
        DoToast(content, cfg_data.IsShowChatBox == 1)
        return
    end

    if CheckToastType(ToastType.TTAP_GET_HOODLE) then
        local uiHoodleAddNum = retStream.uiParam1 or 0
        local strContent = GetLanguageByID(cfg_data.LanguageID) or "%d"
        strContent = string.format(strContent, uiHoodleAddNum)
        DoToast(strContent, cfg_data.IsShowChatBox == 1)
        return
    end

    if cfg_data.RoleIndex > 0 then
        local id = retStream[index2param[cfg_data.RoleIndex]]
        local name
        local typeid
        if (id > 0) then
            name = RoleDataManager:GetInstance():GetRoleName(id)
        else
            name = RoleDataManager:GetInstance():GetMainRoleName()
        end
        if name == "" then
            name = GetLanguageByTableData(TB_Role,id)
        end
        str_t[cfg_data.RoleIndex] = name
    end
    if cfg_data.ClanIndex > 0 then
        local id = retStream[index2param[cfg_data.ClanIndex]]
        local name = GetLanguageByTableData(TB_Clan,id)
        str_t[cfg_data.ClanIndex] = name
    end
    if cfg_data.CityIndex > 0 then
        local id = retStream[index2param[cfg_data.CityIndex]]
        local TB_City = TableDataManager:GetInstance():GetTable("City")
        local name = GetLanguageByTableData(TB_City,id)
        str_t[cfg_data.CityIndex] = name
    end
    if cfg_data.MartialIndex > 0 then
        local id = retStream[index2param[cfg_data.MartialIndex]]
        local data = GetTableData("Martial",id)
        local sName = ""
        if data then
            sName = GetLanguageByID(data.NameID)
        end
        str_t[cfg_data.MartialIndex] = sName
    end
    if cfg_data.ItemIndex > 0 then
        local itemBaseID = retStream[index2param[cfg_data.ItemIndex]]
        local itemBaseData = TableDataManager:GetInstance():GetTableData('Item', itemBaseID)
        local itemName = ''
        if itemBaseData then 
            itemName = itemBaseData.ItemName or ''
        end
        str_t[cfg_data.ItemIndex] = itemName
    end
    if cfg_data.BuffIndex > 0 then
        local id = retStream[index2param[cfg_data.BuffIndex]]
        local data = TableDataManager:GetInstance():GetTableData("Buff", id)
        str_t[cfg_data.BuffIndex] = GetLanguageByTableData(data)
    end
    if cfg_data.GiftIndex > 0 then
        local id = retStream[index2param[cfg_data.GiftIndex]]
        local tableData = TableDataManager:GetInstance():GetTableData("Gift",id)
        local sName = ""
        if tableData then
            sName = GetLanguageByID(tableData.NameID)
        end
        str_t[cfg_data.GiftIndex] = sName
        if CheckToastType(ToastType.TTAP_auto_huo4de2le0tian1fu4) then
            PlayButtonSound("EventTalentGet")
        end
    end
    if cfg_data.UnitIndex > 0 then
        local unitId = retStream.uiParam1
        local errorId = retStream.uiParam2
        if errorId == 0 then 
            errorId = 270116
        end
        local attackerUnit = UnitMgr:GetInstance():GetUnit(unitId)
        if attackerUnit then 
            str_t[1] = attackerUnit:GetName();
            str_t[2] = GetLanguageByID(errorId)
        else
            return
        end
    end
    if cfg_data.ValueIndex > 0 then
        local id = retStream[index2param[cfg_data.ValueIndex]]
        str_t[cfg_data.ValueIndex] = tostring(id)
        --暂时简单处理
        if baseID == 25 or baseID == 26 then
            str_t[3] = tostring(id)
        end
    end
    if cfg_data.AttrIndex > 0 then
        local id = retStream[index2param[cfg_data.AttrIndex]]
        local lang_id = AttrType_Lang[id]
        local name
        if lang_id then
            name = GetLanguageByID(lang_id)
        end
        if not name or name == "" then
            derror('[DisplayNewToast]->Cannot find attrtype ! typeid:' .. tostring(id))
        end
        str_t[cfg_data.AttrIndex] = name
    end

    if cfg_data.TextIndex > 0 then
        local langid = retStream.uiParam1
        local name
        if langid and langid > 0 then
            name = GetLanguageByID(langid)
        end
        if not name or name == "" then
            derror('[DisplayNewToast]->Cannot find attrtype ! typeid:' .. tostring(langid))
        end
        str_t[cfg_data.TextIndex] = name
    end


    -- 特殊处理阴性 阳性属性加成  除以1万
    if  str_t[cfg_data.AttrIndex] == "内力阴性" or  str_t[cfg_data.AttrIndex] == "内力阳性" then
        str_t[cfg_data.ValueIndex] = str_t[cfg_data.ValueIndex] 
    end
    local content = GetLanguageByID(cfg_data.LanguageID)
    content = string.format(content,table.unpack(str_t))
    
    if str_t[cfg_data.AttrIndex] == "内力阴性" then
        local uiID = retStream[index2param[cfg_data.RoleIndex]]
        local roleData = RoleDataManager:GetInstance():GetRoleData(uiID)
        local iNum = roleData.aiAttrs[AttrType.ATTR_NEILIYINXING]
        content = content.."当前的阴性内力为"..iNum
    elseif str_t[cfg_data.AttrIndex] == "内力阳性" then
        local uiID = retStream[index2param[cfg_data.RoleIndex]]
        local roleData = RoleDataManager:GetInstance():GetRoleData(uiID)
        local iNum = roleData.aiAttrs[AttrType.ATTR_NEILIYANGXING]
        content = content.."当前的阳性内力为"..iNum
    end

    if CheckToastType(ToastType.TTAP_TREASURE_INTO_ROLE_PACK) then
        SystemUICall:GetInstance():WarningBox(content)
        return
    end 
    
    DoToast(content, cfg_data.IsShowChatBox == 1)
end