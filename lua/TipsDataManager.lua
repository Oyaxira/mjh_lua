TipsDataManager = class("TipsDataManager")
TipsDataManager._instance = nil

function TipsDataManager:GetInstance()
    if TipsDataManager._instance == nil then
        TipsDataManager._instance = TipsDataManager.new()
    end

    return TipsDataManager._instance
end

function TipsDataManager:GetItemTipsByData(itemInstData, itemStaticData)
    -- 如果传入了动态数据, 那么用这个动态数据去获取对应的静态数据
    if (not itemStaticData) and itemInstData and itemInstData.uiTypeID then
        itemStaticData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemInstData.uiTypeID)
    end
    -- 要显示tips, 静态数据是必要条件
    if not itemStaticData then
        return {}
    end
    local itemDataManager = ItemDataManager:GetInstance()
    local itemID = nil
    if itemInstData then
        itemID = itemInstData.uiID
    end
    local roleDataManager = RoleDataManager:GetInstance()
    -- 必要数据
    local bInGame = roleDataManager:IsPlayerInGame() --玩家是否在剧本内
    local tips = {}
    -- tips标题
    tips.title = itemDataManager:GetItemName(itemID, itemStaticData.BaseID,nil,itemInstData)
    tips.titlestyle = "outline"
    -- tips标题颜色
    if itemStaticData.Rank then
        tips.titlecolor = getRankColor(itemStaticData.Rank)
    end
    -- 判断物品是否在装备中
    local curSelectRole = roleDataManager:GetCurSelectRole()
    local roleData = roleDataManager:GetRoleData(curSelectRole)
    if bInGame and itemID and roleData then
        local akEquipItem = roleData.akEquipItem or {}
        for index, id in pairs(akEquipItem) do
            if id == itemID then
                tips.iscurrentitem = true
                break
            end
        end
    end
    -- tips材料的类型(暗器/医术材料填充该值)
    local itemType = itemStaticData.ItemType
    if (itemType == ItemTypeDetail.ItemType_HiddenWeapon) or (itemType == ItemTypeDetail.ItemType_Leechcraft) then
        local sItemType = GetEnumText("ItemTypeDetail", itemType) or ""
        tips.type = sItemType
    end
    -- 获取tips正文
    tips.content = self:GetItemTipsContent(itemInstData, itemStaticData)
    -- 获取tips状态
    local strState = self:GetItemTipsState(itemInstData, itemStaticData)
    tips.state = strState
    -- tips样式
    tips.kind = (strState and strState ~= "") and "middle" or "normal"
    -- tips作者
    if itemStaticData.author then
        tips.author = itemStaticData.author
    end

    -- 是否为时限物品
    if itemInstData and itemInstData.uiDueTime and itemInstData.uiDueTime > 0 then
        tips.uiDueTime = itemInstData.uiDueTime;
        tips.dueTimeType = itemStaticData.DueTimeType;
        tips.timeValue = itemStaticData.DueTimeValue;
    end

    return tips
end
-- 形参表说明: tips逻辑需要显示地知道, 当前是在获取实例物品的tips信息还是模板的tips信息
-- 因此, 在使用tips的时候可以选择性地传入物品动态或静态id, 两个都传入时以动态id为准
function TipsDataManager:GetItemTips(itemID, itemTypeID)
    -- 基础数据结构
    -- manager获取
    local itemDataManager = ItemDataManager:GetInstance()
    local roleDataManager = RoleDataManager:GetInstance()

    -- 获取 itemData
    local itemStaticData = nil
    local itemInstData = nil
    if itemID then
        itemStaticData = itemDataManager:GetItemTypeData(itemID)
        itemInstData = itemDataManager:GetItemData(itemID)
    elseif itemTypeID then
        itemStaticData = itemDataManager:GetItemTypeDataByTypeID(itemTypeID)
    end
    return self:GetItemTipsByData(itemInstData, itemStaticData)
end

-- 获取tips状态
function TipsDataManager:GetItemTipsState(itemInstData, itemStaticData)
    if itemInstData then
        itemStaticData =  ItemDataManager:GetInstance():GetItemTypeData(itemInstData.uiID)
    end
    -- 至少需要静态数据
    if not itemStaticData then
        return
    end
    local itemType = itemStaticData.ItemType
    -- 如果物品是秘籍, 那么状态显示当前门派和武学类型
    if itemType == ItemTypeDetail.ItemType_SecretBook then
        local strState = ""
        local martialTypeData = MartialDataManager:GetInstance():GetMartialTypeDataByItemTypeID(itemStaticData.BaseID)
        if martialTypeData then
            local clanTypeData = TB_Clan[martialTypeData.ClanID]
            if clanTypeData then
                strState = strState .. "「" .. GetLanguageByID(clanTypeData.NameID) .. "」"
            end
            strState = strState .. (GetEnumText("DepartEnumType", martialTypeData.DepartEnum) or "")
        end
        return strState
    end
end

-- 获取物品tips正文
function TipsDataManager:GetItemTipsContent(itemInstData, itemStaticData)
    -- 基础数据结构
    local content = {}
    -- manager获取
    local martialDataManager = MartialDataManager:GetInstance()
    ------------------------tips描述内容------------------------------
    local res, msg
    -- 调试信息
    if DEBUG_MODE then
        msg = "<color=yellow>[调试信息]</color>\n"
        if itemStaticData then
            msg = msg .. string.format("静态ID %s\n", itemStaticData.BaseID)
        end
        if itemInstData then
            msg = msg .. string.format("动态ID %s\n", itemInstData.uiID)
            if itemInstData.uiSpendIron and itemInstData.uiSpendIron ~= 0 then
                msg = msg .. string.format("精铁 %.0f\n", itemInstData.uiSpendIron)
            end
            if itemInstData.uiPerfectPower and itemInstData.uiPerfectPower ~= 0 then
                msg = msg .. string.format("完美粉 %.0f\n", itemInstData.uiPerfectPower)
            end
            if itemInstData.uiSpendTongLingYu and itemInstData.uiSpendTongLingYu ~= 0 then
                msg = msg .. string.format("金刚玉 %.0f\n", itemInstData.uiSpendTongLingYu)
            end
        end
        content[#content + 1] = "<color=white>" .. msg .. "</color>\n"
    end
    --tips物品是否可交易
    res, msg = self:GetItemTipsContent_TradableMsg(itemInstData)
    if res then content[#content + 1] = msg end
    --tips物品类型
    res, msg = self:GetItemTipsContent_TypeMsg(itemStaticData)
    if res then content[#content + 1] = msg end
    --tips物品数量 暗器 与 医药
    res, msg = self:GetItemTipsContent_AnqiYiyaoMsg(itemInstData, itemStaticData)
    if res then content[#content + 1] = msg end
    -- 把残章秘籍和天书中的武学和天赋数据提取出来
    local itemType = nil
    if (itemStaticData) then
        itemType = itemStaticData.ItemType
    end
    local martialTypeData = nil -- 从物品中获取到的武学静态数据
    local giftTypeData = nil --从物品中获取到的天赋静态数据
    if itemType then
        if (itemType == ItemTypeDetail.ItemType_SecretBook)
        or (itemType == ItemTypeDetail.ItemType_IncompleteBook) then
            martialTypeData = martialDataManager:GetMartialTypeDataByItemTypeID(itemStaticData.BaseID)
        elseif itemType == ItemTypeDetail.ItemType_HeavenBook then
            giftTypeData = martialDataManager:GetGiftTypeDataByItemTypeID(itemStaticData.BaseID)
        end
    end
    -- 存在武学数据 或 天赋数据 证明当前物品类型是武学书
    local isMatBook = (martialTypeData ~= nil) or (giftTypeData ~= nil)
    --tips武学标签
    -- res, msg = self:GetItemTipsContent_MatTagMsg(martialTypeData)
    -- if res then content[#content + 1] = msg end
    --tips物品使用条件
    res, msg = self:GetItemTipsContent_UseCondMsg(itemInstData, itemStaticData)
    if res then content[#content + 1] = msg end
    -- tips物品属性_白字
    res, msg = self:GetItemTipsContent_ItemAttrMsgWhite(itemInstData, itemStaticData)
    local bHasFixedAttrs = res
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    -- tips物品属性_绿字
    res, msg, kExtraInfo = self:GetItemTipsContent_ItemAttrMsgGreen(itemInstData, itemStaticData, isMatBook)
    -- !NOTICE 由于剧本内带出的装备在酒馆仓库有的时候会有绿字条目的丢失, 需要重新带回剧本内才会产生绿字
    -- !这里做一个特殊处理(也许是临时的): 如果 [当前在仓库界面内] 获取到的白字信息为空 并且 绿字信息为 全是裂痕 ,
    -- !那么使用静态数据去重新获取静态描述, 并在结尾处告知玩家需要将装备带入剧本才能生效
    local bGreenAttrIsAllCrack = (kExtraInfo ~= nil) and (kExtraInfo.bIsAllCrack == true)
    local bIsInStorage = IsWindowOpen("StorageUI")
    if (bIsInStorage == true) and (bHasFixedAttrs == false) and (bGreenAttrIsAllCrack == true) then
        -- tips物品属性_白字 静态数据信息
        res, msg = self:GetItemTipsContent_ItemAttrMsgWhite(nil, itemStaticData)
        if res then
            -- 间隔一行
            content[#content + 1] = "\n"
            content[#content + 1] = msg
        end
        -- tips物品属性_绿字 静态数据信息
        res, msg = self:GetItemTipsContent_ItemAttrMsgGreen(nil, itemStaticData, isMatBook)
        if res then
            -- 间隔一行
            content[#content + 1] = "\n"
            content[#content + 1] = msg
        end
        -- 添加一句用户提示
        content[#content + 1] = "\n<color=#C53926>装备属性将在带入剧本后生成</color>"
    else -- 这里是正常获取tips绿字信息的分支
        if res then
            -- 间隔一行
            content[#content + 1] = "\n"
            content[#content + 1] = msg
        end
    end
    -- tips物品属性_蓝字
    res, msg = self:GetItemTipsContent_ItemAttrMsgBlue(itemInstData, itemStaticData, isMatBook)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    --tips赤刀淬炼度
    res, msg = self:GetItemTipsContent_CuiLianMsg(itemInstData,itemStaticData)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    --tips秘籍武学信息
    res, msg = self:GetItemTipsContent_SecretBookMatMsg(itemStaticData, martialTypeData)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    --tips物品描述
    res, msg = self:GetItemTipsContent_ItemDescMsg(itemStaticData, martialTypeData, giftTypeData)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    -- tips物品属性_解锁信息
    res, msg = self:GetItemTipsContent_UnlockMsg(itemStaticData)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    --tips道具穿戴者
    res, msg = self:GetItemTipsContent_WhoseItemMsg(itemInstData)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    --tips传家宝信息 角色传家宝 门派传家宝
    res, msg = self:GetItemTipsContent_TreasureMsg(itemStaticData)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    -- tips迷宫宝藏信息
    res, msg = self:GetItemTipsContent_TreasureMapMsg(itemStaticData, itemInstData)
    if res then
        -- 间隔一行
        content[#content + 1] = "\n"
        content[#content + 1] = msg
    end
    --tips正文字符串连接
    return table.concat(content, "")
end

-- 获取物品tips正文-是否可交易信息
function TipsDataManager:GetItemTipsContent_TradableMsg(itemInstData)
    -- 动态物品才可以查询是否可交易
    if not itemInstData then return false end
    -- 获取manager
    local itemDataManager = ItemDataManager:GetInstance()
    local ret = nil
    local itemID = itemInstData.uiID
    local tradeCheck = itemDataManager:CanItemBeTraded(itemID)
    if tradeCheck > 2 then
        ret = "<color=#FD971F>可交易</color>"
    elseif tradeCheck > 1 then
        ret = "<color=#FD971F>完美后可交易</color>"
    end
    return true, ret
end

-- 获取物品tips正文-物品类型信息
function TipsDataManager:GetItemTipsContent_TypeMsg(itemStaticData)
    -- 需要物品静态数据来获取物品类型信息
    if not itemStaticData then return false end
    -- manager获取
    local itemDataManager = ItemDataManager:GetInstance()
    local martialDataManager = MartialDataManager:GetInstance()
    -- 必要数据获取
    local itemType = itemStaticData.ItemType
    local itemTypeID = itemStaticData.BaseID
    -- 必须具有物品类型
    if not itemType then return false end
    local sItemType = GetEnumText("ItemTypeDetail", itemType) or "物品"
    local strItemTypeDesc = ""
    -- 装备大类前缀
    if itemDataManager:IsEquip(itemTypeID) then
        strItemTypeDesc = "装备/"
    end
    -- 暗器和医药为材料类
    if (itemType == ItemTypeDetail.ItemType_HiddenWeapon) or (itemType == ItemTypeDetail.ItemType_Leechcraft) then
        strItemTypeDesc = "装备/" .. sItemType .. "材料"
    -- 秘籍类
    elseif itemType == ItemTypeDetail.ItemType_SecretBook then
        local martialTypeData = martialDataManager:GetMartialTypeDataByItemTypeID(itemStaticData.BaseID)
        strItemTypeDesc = "秘籍/"
        if martialTypeData then
            local martialName = GetLanguageByID(martialTypeData.NameID)
            local sDepartID = GetEnumValueLanguageID("DepartEnumType", martialTypeData.DepartEnum)
            local sDepart = GetLanguageByID(sDepartID)
            strItemTypeDesc = strItemTypeDesc .. sDepart .. "秘籍"
        else
            strItemTypeDesc = strItemTypeDesc .. "秘籍"
        end
    -- 其它的直接接类型字符串
    else
        strItemTypeDesc = strItemTypeDesc .. sItemType
    end
    local ret = "<color=#FFFFFF>" .. strItemTypeDesc .. "</color>"
    return true, ret
end

-- 获取物品tips正文-暗器与医药的数量信息
function TipsDataManager:GetItemTipsContent_AnqiYiyaoMsg(itemInstData, itemStaticData)
    -- 需要物品静态与动态数据
    if not (itemInstData and itemStaticData) then return false end
    local itemType = itemStaticData.ItemType
    -- 需要用到类型数据, 并且类型符合
    if (not itemType) or ((itemType ~= ItemTypeDetail.ItemType_HiddenWeapon) and (itemType ~= ItemTypeDetail.ItemType_Leechcraft)) then
        return false
    end
    -- 获取manager
    local itemDataManager = ItemDataManager:GetInstance()
    local itemID = itemInstData.uiID
    -- 获取数量
    local num = itemDataManager:GetItemNum(itemID) or 1
    local ret = "\n" .. "剩余数量:　" .. num
    return true, ret
end

-- 获取物品tips正文-物品标签信息
function TipsDataManager:GetItemTipsContent_MatTagMsg(martialTypeData)
    -- 需要武学静态数据
    if not martialTypeData then return false end
    local sMartialTag = ""
    local genTab = {} -- 用于存放标签数据
    local check = {} -- 用于检查标签重复
    local MatItemIDList = martialTypeData.UnlockClauses or {}
    local staticMartialItemData = nil
    local tags = nil
    for index, id in ipairs(MatItemIDList) do
        local martialitem = TableDataManager:GetInstance():GetTableData("MartialItem", id)
        if martialitem then
            staticMartialItemData = martialitem
            tags = staticMartialItemData["Flags"]
            if tags then
                for index, tag in ipairs(tags) do
                    if (check[tag] == nil) then
                        check[tag] = true
                        table.insert(genTab, tag)
                        sMartialTag = sMartialTag .. string.format("[%s]", tag)
                    end
                end
            end
        end
    end
    if (sMartialTag ~= "") then
        local ret =  string.format("\n<color=#C53926>%s</color>", sMartialTag)
        return true, ret
    end
    return false
end

-- 获取物品tips正文-物品使用条件信息
function TipsDataManager:GetItemTipsContent_UseCondMsg(itemInstData, itemStaticData)
    -- 需要物品静态数据
    if not itemStaticData then return false end
    local itemID = nil
    if itemInstData then
        itemID = itemInstData.uiID
    end
    -- 获取manager
    local itemDataManager = ItemDataManager:GetInstance()
    local roleDataManager = RoleDataManager:GetInstance()
    local itemTypeID = itemStaticData.BaseID
    local bInGame = roleDataManager:IsPlayerInGame()
    local bCanUse, sCondDesc = itemDataManager:ItemUseCondition(itemID, itemTypeID, false, true, bInGame)
    local itemType = itemStaticData.ItemType
    if sCondDesc and (sCondDesc ~= "") then
        bCanUse = bCanUse == true
        local prefix = bCanUse and "<color=#FFFFFF>" or "<color=#C53926>"
        local postfix = '</color>'
        if itemType == ItemTypeDetail.ItemType_SecretBook then
            prefix = ''
            postfix = ''
        end
        local ret = string.format("\n<color=#C1AE0F>[使用条件]</color>\n%s%s%s", prefix, sCondDesc, postfix)
        return true, ret
    end
    return false
end

-- 获取物品tips正文-物品属性信息_白字
function TipsDataManager:GetItemTipsContent_ItemAttrMsgWhite(itemInstData, itemStaticData)
    local ret = {}
    -- 获取manager
    local itemDataManager = ItemDataManager:GetInstance()
    if itemInstData then
        local itemID = itemInstData.uiID
        -- 先筛选出物品的 固定属性
        local auiAttrData = itemInstData.auiAttrData or {} -- 所有属性
        local uiFixedAttrs = {} -- 所有固定属性
        for index, data in pairs(auiAttrData) do
            -- 藏宝图把地图位置写在了 基础属性ATTR_TREASUREMAP_ID 上, 所以要排除这个属性
            if (data.uiType ~= AttrType.ATTR_TREASUREMAP_ID) and itemDataManager:JudgeAttrRankType(data, "white") then
                uiFixedAttrs[#uiFixedAttrs + 1] = data
            end
        end
        if #uiFixedAttrs == 0 then return false end
        -- 随便找个id排序, 主要是为了防止重登上线之后重铸条目的顺序发生变化
        table.sort(uiFixedAttrs, function(a, b)
            if a.uiType == b.uiType then
                return (a.iBaseValue or 0) < (b.iBaseValue or 0)
            else
                return (a.uiType or 0) < (b.uiType or 0)
            end
        end)
        -- 翻译固定属性内容
        ret[#ret + 1] = "\n<color=#E6DB74>[基础属性]</color>"
        for index, attrData in ipairs(uiFixedAttrs) do
            ret[#ret + 1] = itemDataManager:GetItemAttrDesc(attrData, itemInstData)
        end
        local sRet = table.concat(ret, "\n")
        return true, sRet
    elseif itemStaticData then
        -- 读取静态数据 固定属性列表
        local attrList = itemStaticData.StaticAttrTypeList
        if (not attrList) or (#attrList == 0) then return false end
        local itemTypeID = itemStaticData.BaseID
        ret[#ret + 1] = "\n<color=#E6DB74>[基础属性]</color>"
        local attrType = nil
        local attrName = nil
        local minValue = 0
        local maxValue = 0
        local fs = nil
        local bIsPerMyriad, bShowAsPercent = false, false
        local matDataManager = MartialDataManager:GetInstance()
        for index, data in ipairs(attrList) do
            attrType = data.Attr
            attrName = GetEnumText("AttrType", attrType)
            minValue = itemDataManager:GetItemStableAttrMinValue(nil, itemTypeID, attrType)
            maxValue = itemDataManager:GetItemStableAttrMaxValue(nil, itemTypeID, attrType)
            bIsPerMyriad, bShowAsPercent = matDataManager:AttrValueIsPermyriad(attrType)
            if bIsPerMyriad then
                minValue = minValue / 10000
                maxValue = maxValue / 10000
            end
            if bShowAsPercent then
                ret[#ret + 1] =string.format("%s+%.1f%%~%.1f%%", attrName, minValue * 100, maxValue * 100)
            else
                fs = bIsPerMyriad and "%s+%.1f~%.1f" or "%s+%.0f~%.0f"
                ret[#ret + 1] =string.format(fs, attrName, minValue, maxValue)
            end
        end
        local sRet = table.concat(ret, "\n")
        return true, sRet
    end
    return false
end

-- 获取物品tips正文-物品属性信息_绿字
function TipsDataManager:GetItemTipsContent_ItemAttrMsgGreen(itemInstData, itemStaticData, isMatBook)
    -- 获取manager
    local itemDataManager = ItemDataManager:GetInstance()
    local itemID = nil
    local itemTypeID = nil
    if itemInstData then
        itemID = itemInstData.uiID
    end
    if itemStaticData then
        itemTypeID = itemStaticData.BaseID
    end
    -- 不可重铸物品不显示可重铸属性
    if not itemDataManager:CanItemBeRecasted(itemID, itemTypeID) then
        return false
    end
    local ret = {}
    if itemInstData and itemStaticData then
        -- 先筛选出物品的可重铸属性
        local auiAttrData = itemInstData.auiAttrData or {} -- 所有属性
        local uiRecastableAttrs = {} -- 所有可重铸属性
        for index, data in pairs(auiAttrData) do
            if itemDataManager:JudgeAttrRankType(data, "green") then
                uiRecastableAttrs[#uiRecastableAttrs + 1] = data
            end
        end
        -- 全是裂痕的情况, 给一个标记, 在return的时候一起给出去
        bIsAllCrack = false
        if #uiRecastableAttrs == 0 then
            bIsAllCrack = true
            -- return false
        end
        -- 随便找个id排序, 主要是为了防止重登上线之后重铸条目的顺序发生变化
        table.sort(uiRecastableAttrs, function(a, b)
            if a.uiType == b.uiType then
                return (a.iBaseValue or 0) < (b.iBaseValue or 0)
            else
                return (a.uiType or 0) < (b.uiType or 0)
            end
        end)
        -- 计算裂痕的数量
        local attrCount = #uiRecastableAttrs -- 可重铸属性的条数
        local countMax = ItemDataManager:GetInstance():CanItemRank2MaxAttrCount(itemStaticData.Rank)
        local crackNum = countMax - attrCount
        -- 翻译可重铸属性内容
        -- 重铸属性显示为一块, 要与上方多隔开一行
        local sRecastTitle = "\n<color=#E6DB74>[铸造属性]</color>"
        -- 存在武学数据 或 天赋数据 证明当前物品类型是武学书
        if isMatBook then
            ret[#ret + 1] = sRecastTitle
        else
            local coinRecastTimes = itemInstData.uiCoinRemainRecastTimes or 0
            if false then
                sRecastTitle = "\n<color=#E6DB74>[铸造属性]</color>"
            end
            ret[#ret + 1] = sRecastTitle
            local isItemPerfect = itemDataManager:IsItemPerfect(itemID)
            for index, attrData in ipairs(uiRecastableAttrs) do
                ret[#ret + 1] = itemDataManager:GetItemAttrDesc(attrData, itemInstData, isItemPerfect, nil, true, "<color=#049947>", nil, "<color=#FD971F>")
            end
            if crackNum > 0 then
                for iv = 1, crackNum do
                    ret[#ret + 1] = "<color=#7F7F7F>裂痕</color>"
                end
            end
        end
        local sRet = table.concat(ret, "\n")
        local kExtraInfo = nil
        if bIsAllCrack then
            kExtraInfo = {['bIsAllCrack'] = true}
        end
        return true, sRet, kExtraInfo
    elseif itemStaticData then
        -- 读取静态数据
        local rank = itemStaticData.Rank
        local recastData = TableDataManager:GetInstance():GetTableData("ItemRecastAttrGen",1)
        local recastCountMin = 0
        local recastCountMax = 0
        if recastData.RecastCountMin and recastData.RecastCountMin[rank] then
            recastCountMin = recastData.RecastCountMin[rank].Value or 0
        end
        if recastData.RecastCountMax and recastData.RecastCountMax[rank] then
            recastCountMax = recastData.RecastCountMax[rank].Value or 0
        end
        ret[#ret + 1] = "\n<color=#E6DB74>[铸造属性]</color>"
        local attrCountMin = 0
        local attrCountMax = ItemDataManager:GetInstance():CanItemRank2MaxAttrCount(rank)
        if recastData.EquipAttrCountMin and recastData.EquipAttrCountMin[rank] then
            attrCountMin = recastData.EquipAttrCountMin[rank].Value or 0
        end
        if attrCountMin == attrCountMax then
            ret[#ret + 1] = string.format("随机属性%d条", attrCountMin)
        else
            ret[#ret + 1] = string.format("随机属性%d~%d条", attrCountMin, attrCountMax)
        end
        local sRet = table.concat(ret, "\n")
        return true, sRet
    end
    return false
end

-- 获取物品tips正文-物品属性信息_蓝字
function TipsDataManager:GetItemTipsContent_ItemAttrMsgBlue(itemInstData, itemStaticData, isMatBook)
    -- 武学书不显示蓝字
    if isMatBook then return false end
    -- 至少得有静态数据
    if not itemStaticData then return false end
    local ret = {}
    -- 获取manager
    local itemDataManager = ItemDataManager:GetInstance()
    -- 排序权重
    local iSortWeight = {}
    -- 全完美蓝字条目
    if itemInstData and itemDataManager:IsItemPerfect(itemInstData.uiID) then
        local desc = "<color=#0081c2>全完美：所有铸造属性数值+10%</color>"
        ret[#ret + 1] = desc
        iSortWeight[desc] = -1  -- 这条排在最上面
    end
    -- 获取物品强化等级
    local itemStrengthenLevel = itemInstData and (itemInstData.uiEnhanceGrade or 0) or 0
    -- 先翻译物品静态数据的固定蓝字属性
    -- 获取最终描述
    local getFinalDesc = function(lv, desc)
        if not (lv and desc) then return desc end
        local prefix = ""
        if itemStrengthenLevel >= lv then
            prefix = "<color=#0081c2>"
        else
            prefix = "<color=#53667F>"
        end
        if lv > 0 then
            prefix = string.format("%s(+%d)", prefix, lv)
        end
        local finalDesc = string.format("%s%s%s", prefix, desc, "</color>")
        iSortWeight[finalDesc] = lv
        return finalDesc
    end
    -- 静态蓝字属性 第一种情况 天赋 + 解锁等级
    if itemStaticData.BlueGift and itemStaticData.BlueGiftUnlockLv then
        local blueGift = itemStaticData.BlueGift
        local unlockLv = itemStaticData.BlueGiftUnlockLv
        local giftTypeData = nil
        local desc = nil
        local Local_TB_Gift = TableDataManager:GetInstance():GetTable("Gift")
        for index, giftTypeID in ipairs(blueGift) do
            giftTypeData = Local_TB_Gift[giftTypeID]
            if giftTypeData then
                desc = GetLanguageByID(giftTypeData.DescID)
                ret[#ret + 1] = getFinalDesc(unlockLv[index] or 0, desc)
            end
        end
    end
    -- 静态蓝字属性 第二种情况 武学属性 + 属性值 + 武学 + 解锁等级
    -- 静态蓝字属性 第三种情况 非武学属性 + 属性值 + 解锁等级
    if itemStaticData.BlueAttr and itemStaticData.BlueAttrValue and itemStaticData.BlueAttrUnlockLv then
        local blueAttr = itemStaticData.BlueAttr
        local blueValue = itemStaticData.BlueAttrValue
        local unlockLv = itemStaticData.BlueAttrUnlockLv
        local value = 0
        local desc = nil
        local sAttrName = nil
        local martialTypeID = nil
        local martialTypeData = nil
        local sMartialName = nil
        local bIsPerMyriad, bShowAsPercent = false, false
        local matDataManager = MartialDataManager:GetInstance()
        for index, attrEnum in ipairs(blueAttr) do
            value = blueValue[index] or 0
            sAttrName = GetEnumText("AttrType", attrEnum)
            bIsPerMyriad, bShowAsPercent = matDataManager:AttrValueIsPermyriad(attrEnum)
            if bIsPerMyriad then
                value = value / 10000
            end
            if bShowAsPercent then
                desc = string.format("%s+%.1f%%", sAttrName, value * 100)
            else
                desc = string.format("%s+%.1f", sAttrName, value)
            end
            if itemStaticData.BlueMartial and itemStaticData.BlueMartial[index] and (itemStaticData.BlueMartial[index] > 0) then
                martialTypeID = itemStaticData.BlueMartial[index]
                martialTypeData = GetTableData("Martial",martialTypeID)
                sMartialName = ""
                if martialTypeData then
                    sMartialName = GetLanguageByID(martialTypeData.NameID)
                end
                desc = sMartialName .. desc
            end
            ret[#ret + 1] = getFinalDesc(unlockLv[index] or 0, desc)
        end
    end
    -- 再翻译物品动态数据中蓝字对的绿字属性加成
    if itemInstData then
        local itemID = itemInstData.uiID
        -- 先筛选出物品的 蓝字属性
        local auiAttrData = itemInstData.auiAttrData or {} -- 所有属性
        local uiBlueAttrs = {} -- 所有蓝字属性
        for index, data in pairs(auiAttrData) do
            if itemDataManager:JudgeAttrRankType(data, "blue") then
                uiBlueAttrs[#uiBlueAttrs + 1] = data
            end
        end
        -- 翻译蓝字属性内容
        local attrName = nil
        local strDesc = nil
        for index, attrData in ipairs(uiBlueAttrs) do
            attrName = GetEnumText("AttrType", attrData.uiType)
            strDesc = string.format("<color=#0081c2>本装备上铸造属性\"%s\"效果提升%d%%</color>", attrName, attrData.iBaseValue or 0)
            iSortWeight[strDesc] = 999  -- 这些描述放最后
            ret[#ret + 1] = strDesc
        end
    end
    if #ret > 0 then
        -- 排序
        table.sort(ret, function(a, b)
            return (iSortWeight[a] or 0) < (iSortWeight[b] or 0)
        end)
        local sRet = "\n" .. table.concat(ret, "\n")
        return true, sRet
    end
    return false
end

-- 获取物品tips正文-秘籍武学信息
function TipsDataManager:GetItemTipsContent_SecretBookMatMsg(itemStaticData, martialTypeData)
    -- 需要物品静态数据 与 武学静态数据
    if not (itemStaticData and martialTypeData) then return false end
    local itemType = itemStaticData.ItemType
    -- 物品需要为秘籍类型
    if itemType ~= ItemTypeDetail.ItemType_SecretBook then return false end
    local retStr = ''
    -- 获取manager
    local martialDataManager = MartialDataManager:GetInstance()
    local coldTime = MartialDataManager:GetInstance():GetMartialMaxColdTime(martialTypeData.BaseID)
    if coldTime > 0 then
        retStr = retStr .. '<color=#C1AE0F>[冷却时间]</color>\n' .. coldTime .. '回合'
    else
        retStr = retStr .. '<color=#C1AE0F>[冷却时间]</color>\n无'
    end
    retStr = retStr .. "\n<color=#C1AE0F>[武学效果]</color>"
    -- 武学条目
    retStr = retStr .. "\n<color=#CBCBCC>"
    -- 静态数据的显示 武学默认最大等级 ~ (武学默认最大等级 + 5)
    local iMartialCurLevel = martialDataManager:GetMartialMaxLevel()
    local iMartialMaxLevel = martialDataManager:GetMartialFinalMaxLevel()
    local martialItemDescs = martialDataManager:GetMartialItemsDesc(martialTypeData, nil, iMartialCurLevel, iMartialMaxLevel, true)
    if next(martialItemDescs) then
        local descPrefix = ""
        local postfix = ""
        local length = #martialItemDescs
        for index, data in ipairs(martialItemDescs) do
            if data.prefix and (data.prefix ~= "") then
                descPrefix = data.prefix .. ":　"
            end
            postfix = ""
            if index < length then
                postfix = "\n"
            end
            retStr = retStr .. data.colorTag .. descPrefix .. data.desc .. "</color>" .. postfix
        end
    end
    retStr = retStr .. "</color>"
    return true, retStr
end

-- 获取物品tips正文-解锁信息
function TipsDataManager:GetItemTipsContent_UnlockMsg(itemStaticData)
    -- 需要物品静态数据 与 武学静态数据
    if not (itemStaticData) then return false end
    local bIfUnlock = ItemDataManager:GetInstance():GetIfUnlockItemUnlocked(itemStaticData)
    if bIfUnlock then
        local retStr = ''
        local itemType = itemStaticData.ItemType
        local stritemType = GetEnumText("ItemTypeDetail", itemType)
        if itemStaticData.EffectType == EffectType.ETT_UseItem_AddTitle then
            stritemType = '称号'
        end
        retStr = string.format( "%s\n<color=#0081c2>此%s已解锁</color>",retStr,stritemType )
        return true,retStr
    end
    return false
end
function TipsDataManager:GetItemTipsContent_CuiLianMsg(itemInstData, itemStaticData)
    if (not itemInstData) then
        return false
    end
    local uiItemID = itemInstData.uiID
    local uiCuilianValue = RoleDataManager:GetInstance():GetRedKnifeCuiLian(uiItemID) or 0
    local configRedKnife = TableDataManager:GetInstance():GetTableData("RedKnifeUpgrade",itemStaticData.BaseID)
    if configRedKnife and configRedKnife.NextItemID > 0 then
        local nextRedKnife = TableDataManager:GetInstance():GetTableData("RedKnifeUpgrade",configRedKnife.NextItemID) or {}
        local outStr = string.format("<color=#0081c2>淬炼度：%s/%s</color>", tostring(uiCuilianValue), tostring(nextRedKnife.Cuilian))
        return true, outStr
    else
        return false
    end
end

-- 获取物品tips正文-物品描述信息
function TipsDataManager:GetItemTipsContent_ItemDescMsg(itemStaticData, martialTypeData, giftTypeData)
    -- 需要物品静态数据与武学静态数据与天赋静态数据
    if not itemStaticData then return false end
    local itemType = itemStaticData.ItemType
    -- 需要物品类型数据
    if not itemType then return false end
    local ret = ""
    -- 秘籍/ 残章/ 天书 采用规则自动生成, 不读表
    if (itemType == ItemTypeDetail.ItemType_SecretBook) and martialTypeData then
        local martialName = GetLanguageByID(martialTypeData.NameID)
        ret = string.format("\n装备：战斗后学会《%s》，并加快此武学的升级速度", martialName)
        local descID = martialTypeData.DesID
        if descID then
            ret = ret .. "\n" .. GetLanguageByID(descID)
        end
    elseif (itemType == ItemTypeDetail.ItemType_IncompleteBook) and martialTypeData then
        local martialName = GetLanguageByID(martialTypeData.NameID)
        if GetCurScriptID() == PO_TIAN_NI_MING_SCRIPT_ID then
            ret = string.format("\n本局游戏《%s》等级上限提升1级，剧本结束后复原\n", martialName)
        else
            ret = string.format("\n永久提升《%s》等级上限1级，此途径最高提升到20级\n\n可在残章匣中查看", martialName)
        end
    elseif (itemType == ItemTypeDetail.ItemType_HeavenBook) and giftTypeData then
        local giftName = GetLanguageByID(giftTypeData.NameID)
        local sDesc = GetLanguageByID(giftTypeData.DescID)
        ret = string.format("\n使角色获得《%s》天赋:　%s", giftName, sDesc)
    elseif itemStaticData.ItemDesc and itemStaticData.ItemDesc ~= '' then
        --其它的, 直接读取物品表里的描述
        ret = "\n" .. string.gsub(itemStaticData.ItemDesc, "\\n", "\n")
    end
    -- 来源（产出地）
    if itemStaticData.ItemSource and itemStaticData.ItemSource ~= '' then
        local sSource = itemStaticData.ItemSource
        if (sSource ~= "") and (sSource ~= "0") then
            ret = ret .. "\n产出地:　" .. sSource
        end
    end

    if ret == "" then
        return false, ret
    end

    --暗器 和 医药 的描述信息显示为白色, 其它显示为灰色
    if (itemType == ItemTypeDetail.ItemType_HiddenWeapon) or (itemType == ItemTypeDetail.ItemType_Leechcraft) then
        ret = "<color=#FFFFFF>" .. ret .. "</color>"
    elseif ret then
        ret = "<color=#A0A09E>" .. ret .. "</color>"
    end
    return true, ret
end

-- 获取物品tips正文-道具穿戴着信息
function TipsDataManager:GetItemTipsContent_WhoseItemMsg(itemInstData)
    -- 需要物品动态数据
    if not itemInstData then return end
    local kRoleMgr = RoleDataManager:GetInstance()
    local ret = ""

    -- 如果该物品是动态商店中的在售物品, 那么不需要显示拥有者
    if ShopDataManager:GetInstance():CheckDyShopBelongItem(itemInstData.uiID) then
        return false, ret
    end

    -- 由于之前定义的旧字段不方便修改
    -- 所以 uiOwnerID 其实是穿戴者
    -- bBelongToMainRole 是装备归属

    local uiEquipRole = itemInstData.uiOwnerID or 0
    local strEquipRoleName = kRoleMgr:GetRoleName(uiEquipRole)
    -- if strEquipRoleName and (strEquipRoleName ~= "") then
    --     ret = "\n<color=#BCBCBC>穿戴者:" .. strEquipRoleName .. "</color>"
    -- end

    local bBelongToMainRole = (itemInstData.bBelongToMainRole == 1)
    local strOwnerName = nil
    if bBelongToMainRole then
        strOwnerName = kRoleMgr:GetMainRoleName()
    else
        strOwnerName = strEquipRoleName
    end
    if strOwnerName and (strOwnerName ~= "") then
        ret = ret .. "\n<color=#BCBCBC>拥有者:" .. strOwnerName .. "</color>"
    end

    return ((ret ~= nil) and (ret ~= "")), ret
end

-- 获取物品tips正文-传家宝信息
function TipsDataManager:GetItemTipsContent_TreasureMsg(itemStaticData)
    -- 需要物品静态数据
    if not itemStaticData then return false end
    local ret = nil
    local roleDataManager  = RoleDataManager:GetInstance()
    if itemStaticData.PersonalTreasure ~= 0 then
        -- 首先, 物品填了传家宝角色并且该角色能查找到静态数据, 则认定为拥有传家宝绑定角色
        local roleTypeID = itemStaticData.PersonalTreasure
        local roleTypeData = roleDataManager:GetRoleTypeDataByTypeID(roleTypeID)
        if not roleTypeData then
            return false
        end
        local roleName = nil
        if roleTypeData.NameID and (roleTypeData.NameID > 0) then
            roleName = roleDataManager:GetRoleNameByTypeID(roleTypeID)
        end
        -- 如果获取不到角色静态名称, 说明该角色是供玩家抢称号的, 尝试去动态的数据里获取该角色的名称
        if (not roleName) or (roleName == "") then
            local roleID = roleDataManager:GetRoleID(roleTypeID)
            if (not roleID) or (roleID <= 0) then
                -- 没有动态角色被创建, 就显示自己的名字
                -- roleName = roleDataManager:GetMainRoleName()
                return false
            else
                roleName = roleDataManager:GetRoleName(roleID) or ""
            end
        end
        if roleName and (roleName ~= "") then
            ret = string.format("%s的宝物", roleName)
        else
            return false
        end
    elseif itemStaticData.ClanTreasure ~= 0 then
        local clanID = itemStaticData.ClanTreasure
        local clanTypeData = TB_Clan[clanID]
        if clanTypeData then
            local clanName = GetLanguageByID(clanTypeData.NameID)
            ret = string.format("%s的宝物", clanName)
        end
    elseif itemStaticData.NoneTreasure == TBoolean.BOOL_YES then
        ret = "无主的宝物"
    end
    if ret then
        ret = "\n<color=#F8DF60>" .. ret .. "</color>"
        return true, ret
    end
    return false
end

-- 获取物品Tips正文---藏宝图信息
function TipsDataManager:GetItemTipsContent_TreasureMapMsg(itemStaticData, itemInstData)
    if not itemStaticData then return false end
    local ret = nil
    local msg = nil
    local roleDataManager  = RoleDataManager:GetInstance()
    if (itemStaticData.ItemType == ItemTypeDetail.ItemType_TreasureMap) then
        if (itemInstData ~= nil) then
            local auiAttrData = itemInstData.auiAttrData or {} -- 所有属性
            local content = ItemDataManager:GetInstance():GetItemTreasureMapDesc(auiAttrData)
            if (content ~= nil) then
                return true, content
            end
        end
    end

    return ret,msg
end

function TipsDataManager:GetSkillTips(martialData,skillid,martialTypeID)
    -- 若 martialData 为空,martialTypeID 不为空则意味着需要展示静态信息
    -- local martialData = martialDataList[index]
    if not martialData and not martialTypeID then
        return
    end

    local isShowStatic = not martialData

    local martialBaseID = nil

    if isShowStatic then
        martialBaseID = martialTypeID
    else
        martialBaseID = martialData.uiTypeID
    end

    local roleData = nil
    if not isShowStatic then
        roleData = RoleDataManager:GetInstance():GetRoleData(martialData.uiRoleUID)
    end
    local martialDataList = nil
    if not isShowStatic then
        martialDataList = MartialDataManager:GetInstance():GetRoleMartial(martialData.uiRoleUID)
    else
        martialDataList = {}
    end

    local martialLevel = 1
    if not isShowStatic then
        martialLevel = martialData.uiLevel or 1
    end

    --本武学
    local martialBaseData = GetTableData("Martial",martialBaseID)
    if not martialBaseData then
        return
    end

    --装配武学条目
    local martialItemBaseData = TableDataManager:GetInstance():GetTableData("MartialItem", martialBaseData.MartMovIDs[1])
    if not martialItemBaseData then
        return
    end

    --默认选择skill1，后期策划若想同时展示多条技能信息，商量展示布局后再定
    local tbl_skill1 = TableDataManager:GetInstance():GetTableData("Skill", skillid or martialItemBaseData.SkillID1)

    local tips = {}
    local content = {}

    --标题
    tips.title =
        getRankBasedText(
        tbl_skill1.Rank,
        -- string.format("%s   %d级", GetLanguageByID(tbl_skill1.NameID), martialData.uiLevel or 0)
        string.format("%s", GetLanguageByID(tbl_skill1.NameID))
    )

    local string_state = ""
    --门派
    local tbl_Clan = TB_Clan[martialBaseData.ClanID]
    if tbl_Clan then
        string_state = string_state .. "「" .. GetLanguageByID(tbl_Clan.NameID) .. "」"
    end
    --系别
    local departEnum = DepartEnumType_Lang[martialBaseData.DepartEnum]
    if departEnum then
        string_state = string_state .. GetLanguageByID(departEnum)
    end
    tips.state = string_state

    --消耗真气由客户端自己计算
    if martialBaseData.EffectEnum1 ~= MartialItemEffect.MTT_BEIDONGJINENG then
        local costMpPercent, costMpValue = MartialDataManager:GetInstance():GetSkillMPCost(tbl_skill1, martialLevel, roleData)
        local str_con --= getUIBasedText('blue', string.format("消耗真气：%.2f%%最大真气（%d）", costMpPercent, costMpValue))
        if costMpValue == 0 then
            if not roleData then
                str_con = getUIBasedText('blue', string.format("消耗真气：%.2f%%最大真气", costMpPercent))
            else
                str_con = getUIBasedText('blue', "消耗真气：无")--string.format("消耗真气：%.2f%%最大真气", costMpPercent))
            end
            
        else
            str_con = getUIBasedText('blue', string.format("消耗真气：%.2f%%最大真气（%d）", costMpPercent, costMpValue))
        end
        content[#content + 1] = str_con .. "\n"
    end

    --消耗物品todo目前没有技能消耗物品数据

    --技能范围
    local iMartialRangeLevel

    if isShowStatic then
        iMartialRangeLevel = 1
    else
        iMartialRangeLevel = martialData['uiRangeLevel'] or 1
    end

    local rangeID = MartialDataManager:GetInstance():GetSkillAttackRange(tbl_skill1.SkillRange, iMartialRangeLevel)
    if dnull(rangeID) then
        local tbl_Range = TableDataManager:GetInstance():GetTableData("Range",rangeID)
        if tbl_Range then
            content[#content + 1] = string.format("攻击范围：%s", GetLanguageByID(tbl_Range.NameID)) .. "\n"
        end
    end

    local intBaseWeiLiXiShu = MartialDataManager:GetInstance():GetStaticMartialWeiLiXiShuBase(martialBaseID,martialLevel)

    local intWeiLiBaiFenBi = MartialDataManager:GetMartialWeiLiBaiFenBi(martialData,skillid)
    intWeiLiBaiFenBi = intWeiLiBaiFenBi / 10000

    local intFinalWeiLiXiShu = MartialDataManager:GetInstance():GetStaticMartialWeiLiXiShu(martialBaseID,skillid,martialLevel,intWeiLiBaiFenBi,martialData)

    intBaseWeiLiXiShu = intBaseWeiLiXiShu and intBaseWeiLiXiShu / 10000
    intBaseWeiLiXiShu = intBaseWeiLiXiShu * SKILL_SHOW_NUM_RATE
    intFinalWeiLiXiShu = intFinalWeiLiXiShu and intFinalWeiLiXiShu / 10000
    intFinalWeiLiXiShu = intFinalWeiLiXiShu * SKILL_SHOW_NUM_RATE
    content[#content + 1] = string.format("武学威力：%.1f", intBaseWeiLiXiShu  ) .. "\n"

    if intWeiLiBaiFenBi and intWeiLiBaiFenBi > 0 then
        content[#content + 1] = string.format("武学威力百分比：%.0f", intWeiLiBaiFenBi * 100) .. "%\n"
    end
    content[#content + 1] = string.format("武学威力最终系数：%.1f", intFinalWeiLiXiShu or 0) .. "\n"


    --阴性属性加成
    if tbl_skill1.MascCoef > 0 then
        content[#content + 1] =
            string.format("<color=#EE6230>受内力阳性加成：%.1f</color>", tbl_skill1.MascCoef * 1.0 / 10000) .. "\n"
    end
    if tbl_skill1.FemiCoef > 0 then
        content[#content + 1] =
            string.format("<color=#669ABA>受内力阴性加成：%.1f</color>", tbl_skill1.FemiCoef * 1.0 / 10000) .. "\n"
    end

    --martialData.iDamageValue
    --技能描述
    local skilldamagevalue = 0

    local skillTriggers = tbl_skill1.SkillTriggers
    local mulitStageCount = 1
    local attackTimes = 1
    local CatapultTimes = 2

    if isShowStatic then
        skilldamagevalue = MartialDataManager:GetInstance():GetStaticSkillDamageValue(martialBaseID,skillid,martialLevel)
        if skillTriggers and skillTriggers[1] and skillTriggers[1].EffectID and (skillTriggers[1].EffectID > 0) then
            attackTimes = MartialDataManager:GetInstance():GetSkillMultiStepCount(skillTriggers[1].EffectID)
        end
        CatapultTimes = MartialDataManager:GetInstance():GetMartialCatapult(martialBaseID,nil,skillid)

    else
        skilldamagevalue = MartialDataManager:GetInstance():GetSkillDamageValue(roleData,martialData,departEnum,martialBaseData.DepartEnum,martialBaseData.Rank)
        attackTimes = MartialDataManager:GetInstance():GetMartialAttackTimes(martialBaseID,martialData.uiRoleUID,skillid)
        CatapultTimes = MartialDataManager:GetInstance():GetMartialCatapult(martialBaseID,martialData.uiRoleUID,skillid)
    end


    local skillDescribe = MartialDataManager:GetInstance():FillPlaceholder(GetLanguageByID(tbl_skill1.DescID or 0), attackTimes, skilldamagevalue,skilldamagevalue,CatapultTimes)
    content[#content + 1] = "\n" .. skillDescribe .. "\n"

    --累计武学威力
    local string_MartialPower = ""
    if martialBaseData.GrowProIDs then
        local growProData = nil
        local hide = false
        for index, growpProID in ipairs(martialBaseData.GrowProIDs) do
            growProData = TableDataManager:GetInstance():GetTableData("MartialItem", growpProID)
            local matAttr = growProData["MAttrEnum" .. index]
            if matAttr == AttrType.MP_WEILI then
                local value = MartialDataManager:GetInstance():AssistGetMartialPowerSelf(martialBaseData)
                string_MartialPower = "\n(累计威力+" .. value * 100 * martialLevel .. "%)"
                content[#content + 1] = string_MartialPower
            end
        end
    end

    -- --武学加成todo
    local string_otherMartialEffect = ""

    local map_martial_type_data = {}
    for _, data in pairs(martialDataList) do
        -- tbl_kungfu 代表循环中的武学模板
        local tbl_kungfu =  GetTableData("Martial",data.uiTypeID)
        local ret = ""
        if tbl_kungfu.UnlockClauses and tbl_kungfu.UnlockLvls then
            for i = 1, #tbl_kungfu.UnlockClauses do
                if martialLevel >= tbl_kungfu.UnlockLvls[i] then
                    local martialItemBaseData = TableDataManager:GetInstance():GetTableData("MartialItem", tbl_kungfu.UnlockClauses[i])
                    if martialItemBaseData and martialItemBaseData.ItemFeature ~= MartialItemFeature.IFF_Hide then
                        if martialItemBaseData.CondID == 0 or RoleDataHelper.ConditionComp(martialItemBaseData.CondID,martialData,martialBaseData) then
                            local string_Des = martialItemBaseData.DesID
                            for i = 1, 2 do
                                local trigger = martialItemBaseData["EffectEnum" .. i]
                                if trigger then
                                    local args = martialItemBaseData["Effect" .. i .. "Value"]
                                    if trigger == MartialItemEffect.MTT_BEIDONGJINENG and tbl_kungfu.BaseID == martialBaseData.BaseID then
                                        local skillID = martialItemBaseData["SkillID" .. i]
                                        local skillData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
                                        if skillData and skillData.DescID then
                                            local strret = MartialDataManager:GetInstance():GetSkillDesc(skillData, tbl_kungfu)
                                            map_martial_type_data[data.uiTypeID] = map_martial_type_data[data.uiTypeID] or {}
                                            map_martial_type_data[data.uiTypeID]['被动技能'] = map_martial_type_data[data.uiTypeID]['被动技能']  or {}
                                            table.insert( map_martial_type_data[data.uiTypeID]['被动技能'] , strret )
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            -- if ret ~= '' then
            --     string_otherMartialEffect = string_otherMartialEffect .. '\n' .. getRankBasedText(tbl_kungfu.Rank, GetLanguageByID(tbl_kungfu.NameID) ..":") ..ret
            -- end
        end
    end

    if not isShowStatic then
        if martialData.akMartialInfluences then
            for _,data in pairs(martialData.akMartialInfluences) do
                local ret = ''
    
                local int_martialid = data.uiMartialTypeID
    
                local int_attrid = data.uiAttrType
                -- local attr_name = GetLanguageByID(AttrType_Lang[data.uiAttrType])
                local boolean_init = data.uiMartialInit and true or false
                local int_value = data.uiMartialValue or 0
                -- local source_marital = getRankBasedText(1, GetLanguageByID(data.uiMartialTypeID))
    
                map_martial_type_data[int_martialid] = map_martial_type_data[int_martialid] or {}
                map_martial_type_data[int_martialid][int_attrid] = map_martial_type_data[int_martialid][int_attrid] or 0
                map_martial_type_data[int_martialid][int_attrid] = map_martial_type_data[int_martialid][int_attrid] + int_value
    
    
                -- string_otherMartialEffect = string_otherMartialEffect .. '\n' .. source_marital .. attr_name .. '+' .. int_value
    
            end
        end
    end

    if map_martial_type_data and next(map_martial_type_data) then
        for iCurShowRank = 8,1,-1 do
            for marid ,mmad in pairs(map_martial_type_data) do
                local martialData = GetTableData("Martial",marid)
                local iMarRank = martialData.Rank
                if iMarRank == iCurShowRank then
                    local ret = ''
                    for iattrid,ivdata in pairs(mmad) do
                        if iattrid == '被动技能' then
                            for intid,str in ipairs(ivdata) do
                                ret = ret .. '\n·' .. str
                            end
                        elseif iattrid ~= AttrType.MP_WEILIXISHU and iattrid ~= AttrType.MP_WEILIJIXIAN then
                            local attr_name = GetLanguageByID(AttrType_Lang[iattrid])
                            attr_name = attr_name ~= '' and attr_name or iattrid
                            local int_value = ivdata or 0

                            local bIsPerMyriad,bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(iattrid)
                            if bIsPerMyriad then
                                int_value = int_value / 10000
                            end
                            if bShowAsPercent then
                                ret = string.format("%s\n·%s+%.1f%%",ret,attr_name,int_value * 100)
                            else
                                ret = string.format("%s\n·%s+%.0f",ret,attr_name,int_value )
                            end
                        end
                        -- ret = ret .. attr_name .. '+' ..  int_value .. '\n'
                    end
                    if ret ~= '' then
                        local source_marital = getRankBasedText(iMarRank, GetLanguageByID(martialData.NameID))
                        string_otherMartialEffect = string_otherMartialEffect .. '\n' ..source_marital  .. ret
                    end
                end
            end
        end
    end

    local coldTime = MartialDataManager:GetInstance():GetMartialMaxColdTime(martialBaseID)
    if coldTime > 0 then
        if martialData and martialData.uiColdTime > 0 then
            content[#content + 1] = "\n" .. '冷却时间:' .. coldTime .. '回合 (剩余' .. martialData.uiColdTime .. '回合)'
        else
            content[#content + 1] = "\n" .. '冷却时间:' .. coldTime .. '回合'
        end
    else
        content[#content + 1] = "\n" .. '冷却时间:无'
    end
    if string_otherMartialEffect ~= '' then
        content[#content + 1] = "\n" .. "[武学加成]" .. string_otherMartialEffect
    end

    tips.content = table.concat(content, "")

    return tips
end

--获取角色基础属性
function TipsDataManager:GetCharacterCommonTips(roleID)
    local tips = {}
    local content = {}
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if not roleData then
        return
    end
    local fun = function(enum)
        return toint(roleData.aiAttrs[enum])
    end
    tips.title = "其他属性"
    tips.titlecolor = DRCSRef.Color.white
    tips.titlestyle = "outline"
    tips.kind = "normal"

    -- content[#content + 1] = string.format("剑法精通：%d\t奇门精通：%d", fun(AttrType.ATTR_JIANFAJINGTONG), fun(AttrType.ATTR_QIMENJINGTONG))
    -- content[#content + 1] = string.format("刀法精通：%d\t暗器精通：%d", fun(AttrType.ATTR_DAOFAJINGTONG), fun(AttrType.ATTR_ANQIJINGTONG))
    -- content[#content + 1] = string.format("拳掌精通：%d\t医术精通：%d", fun(AttrType.ATTR_QUANZHANGJINGTONG), fun(AttrType.ATTR_YISHUJINGTONG))
    -- content[#content + 1] = string.format("腿法精通：%d\t内功精通：%d", fun(AttrType.ATTR_TUIFAJINGTONG), fun(AttrType.ATTR_NEIGONGJINGTONG))

    content[#content + 1] = string.format("剑法精通：%d", fun(AttrType.ATTR_JIANFAJINGTONG))
    content[#content + 1] = string.format("奇门精通：%d", fun(AttrType.ATTR_QIMENJINGTONG))
    content[#content + 1] = string.format("刀法精通：%d", fun(AttrType.ATTR_DAOFAJINGTONG))
    content[#content + 1] = string.format("暗器精通：%d", fun(AttrType.ATTR_ANQIJINGTONG))
    content[#content + 1] = string.format("拳掌精通：%d", fun(AttrType.ATTR_QUANZHANGJINGTONG))
    content[#content + 1] = string.format("医术精通：%d", fun(AttrType.ATTR_YISHUJINGTONG))
    content[#content + 1] = string.format("腿法精通：%d", fun(AttrType.ATTR_TUIFAJINGTONG))
    content[#content + 1] = string.format("内功精通：%d", fun(AttrType.ATTR_NEIGONGJINGTONG))

    local init_act_time = RoleDataManager:GetInstance():GetInitialActionTime(roleID)
    content[#content + 1] = string.format("速度值：%s (行动间隔：%.2f秒)", fun(AttrType.ATTR_SUDUZHI), init_act_time)
    local sContent_1 = table.concat(content, "\n")
    tips.content = "<color=#FFFFFF>" .. sContent_1 .. "\n" .. "</color>"
    return tips
end

--获取角色各种概率
function TipsDataManager:GetCharacterDetailTips(roleID)
    local tips = {}
    local content = {}
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if not roleData then
        return
    end
    local fun = function(enum)
        return toint(roleData.aiAttrs[enum] or 0)
    end
    tips.title = "属性影响"
    tips.titlecolor = DRCSRef.Color.white
    tips.titlestyle = "outline"
    tips.kind = "wide"

    local temp_battle_factor = TableDataManager:GetInstance():GetTableData("BattleFactor",1)

    local number_shanbi = fun(AttrType.ATTR_SHANBI)
    local number_critatk = fun(AttrType.ATTR_CRITATK)
    local number_continuatk = fun(AttrType.ATTR_CONTINUATK)
    local number_fanji = fun(AttrType.ATTR_FANJIZHI)
    local number_seethrough = fun(AttrType.ATTR_POZHAOVALUE)
    local number_baojibeishu = fun(AttrType.ATTR_BAOSHANGZHI)
    local number_rebound = fun(AttrType.ATTR_FANTANVALUE)

    local number_shanbi_percent = fun(AttrType.ATTR_SHANBILV) / 10000
    local number_critatk_percent = fun(AttrType.ATTR_CRITATKPER) / 10000
    local number_continuatk_percent = fun(AttrType.ATTR_CONTINUATKPER) / 10000
    local number_fanji_percent = fun(AttrType.ATTR_FANJILV) / 10000
    local number_seethrough_percent = fun(AttrType.ATTR_POZHAOLV) / 10000
    local number_baojibeishu_percent = fun(AttrType.ATTR_CRITATKTIME) / 10000
    local number_rebound_percent = fun(AttrType.ATTR_FANTANLV) / 10000
    local number_hitatc_percent = fun(AttrType.ATTR_HITATKPER) / 10000

    local BattleFactorRelateList = TableDataManager:GetInstance():GetTable("BattleFactorRelate")
    local func_getmaxrate = function(eType)
        if not eType then return 1 end
        local BattleFactorRelate = BattleFactorRelateList[eType]
        if not BattleFactorRelate or not BattleFactorRelate.Value then return 1 end
        return BattleFactorRelate.Value
    end

    local number_shanbi_gen = (number_shanbi + temp_battle_factor["dodge_m"]) / (number_shanbi + temp_battle_factor["dodge_n"]) * func_getmaxrate(BattleFactorType.BFACT_DodgeMax)
    local number_critatk_gen = (number_critatk + temp_battle_factor["crit_m"]) / (number_critatk + temp_battle_factor["crit_n"]) * func_getmaxrate(BattleFactorType.BFACT_CritMax)
    local number_continuatk_gen = (number_continuatk + temp_battle_factor["Combo_m"]) / (number_continuatk + temp_battle_factor["Combo_n"]) * func_getmaxrate(BattleFactorType.BFACT_ComboMax)
    local number_fanji_gen = (number_fanji + temp_battle_factor["counter_m"]) / (number_fanji + temp_battle_factor["counter_n"]) * func_getmaxrate(BattleFactorType.BFACT_counterMax)
    local number_seethrough_gen = (number_seethrough + temp_battle_factor["seeThrough_m"]) / (number_seethrough + temp_battle_factor["seeThrough_n"]) * func_getmaxrate(BattleFactorType.BFACT_seeThroughMax)
    local number_baojibeishu_gen = (number_baojibeishu + temp_battle_factor["critDge_m"]) / (number_baojibeishu + temp_battle_factor["critDge_n"]) * func_getmaxrate(BattleFactorType.BFACT_CritDgeMax)
    local number_rebound_gen = (number_rebound + temp_battle_factor["rebound_m"]) / (number_rebound + temp_battle_factor["rebound_n"]) * func_getmaxrate(BattleFactorType.BFACT_reboundMax)

    number_shanbi_gen = number_shanbi_gen >= 0 and number_shanbi_gen or 0
    number_critatk_gen = number_critatk_gen >= 0 and number_critatk_gen or 0
    number_continuatk_gen = number_continuatk_gen >= 0 and number_continuatk_gen or 0
    number_fanji_gen = number_fanji_gen >= 0 and number_fanji_gen or 0
    number_seethrough_gen = number_seethrough_gen >= 0 and number_seethrough_gen or 0
    number_baojibeishu_gen = number_baojibeishu_gen >= 0 and number_baojibeishu_gen or 0
    number_rebound_gen = number_rebound_gen >= 0 and number_rebound_gen or 0

    local number_shanbi_final = number_shanbi_gen + number_shanbi_percent
    local number_critatc_final = number_critatk_gen + number_critatk_percent
    local number_continuatk_final = number_continuatk_gen + number_continuatk_percent
    local number_fanji_final = number_fanji_gen + number_fanji_percent
    local number_seethrough_final = number_seethrough_gen + number_seethrough_percent
    local number_baojibeishu_final = number_baojibeishu_gen + number_baojibeishu_percent + 1
    local number_rebound_final = number_rebound_gen + number_rebound_percent

    content[#content + 1] = string.format("命中概率:　即命中率%.0f%%", number_hitatc_percent * 100)
    content[#content + 1] = string.format("闪避概率:　被命中值为0的人攻击时的闪避概率%.0f%%", number_shanbi_final * 100)
    content[#content + 1] = string.format("                  (闪避值 %0.f%%+闪避率 %0.f%%)", number_shanbi_gen * 100, number_shanbi_percent * 100)
    content[#content + 1] = string.format("暴击概率:　攻击暴击抵抗值/率为0的人暴击概率%.0f%%", number_critatc_final * 100)
    content[#content + 1] = string.format("                  (暴击值 %.0f%%+暴击率 %.0f%%)", number_critatk_gen * 100, number_critatk_percent * 100)
    content[#content + 1] = string.format("连击概率:　攻击抗连击值/率为0的人连击概率%.0f%%", number_continuatk_final * 100)
    content[#content + 1] = string.format("                  (连击值 %.0f%%+连击率 %.0f%%)", number_continuatk_gen * 100, number_continuatk_percent * 100)

    content[#content + 1] = string.format('反击概率：被等级为1的人攻击时的反击概率%.0f%%',number_fanji_final*100)
    content[#content + 1] = string.format('                  (反击值 %.0f%%+反击率 %.0f%%)',number_fanji_gen*100,number_fanji_percent*100)
    content[#content + 1] = string.format('破招概率：被等级为1的人攻击时的破招概率%.0f%%',number_seethrough_final*100)
    content[#content + 1] = string.format('                  (破招值 %.0f%%+破招率 %.0f%%)',number_seethrough_gen*100,number_seethrough_percent*100)
    content[#content + 1] = string.format('暴伤最终倍数：攻击等级1的人数值为%.0f%%',number_baojibeishu_final*100)
    content[#content + 1] = string.format('            (暴伤值 %.0f%%+暴击伤害倍数 %.0f%%+1)',number_baojibeishu_gen*100,number_baojibeishu_percent*100)
    content[#content + 1] = string.format('反弹概率：被等级为1的人攻击时的反弹概率%.0f%%',number_rebound_final*100)
    content[#content + 1] = string.format('                  (反弹值 %.0f%%+反弹率 %.0f%%)',number_rebound_gen*100,number_rebound_percent*100)


    content[#content + 1] = '\n'
    local iDiffValue = RoleDataManager:GetInstance():GetDifficultyValue()
    local table_AttrMaxDiff = TableDataManager:GetInstance():GetTable("AttrmaxDifficuty")
    if iDiffValue > #table_AttrMaxDiff then
        iDiffValue = #table_AttrMaxDiff
    end
    local attrMaxData = table_AttrMaxDiff[iDiffValue]
    content[#content + 1] = string.format('属性最大值')
    content[#content + 1] = string.format('命中率：%.0f%%        闪避率：%.0f%%',(attrMaxData.HitRate or 0) / 100,(attrMaxData.MissRate or 0) / 100)
    content[#content + 1] = string.format('暴击率：%.0f%%        暴击抵抗率：%.0f%%',(attrMaxData.CritRate or 0) / 100,(attrMaxData.CritDefenseRate or 0) / 100)
    content[#content + 1] = string.format('连击率：%.0f%%        暴击伤害倍数：%.0f%%',(attrMaxData.RepeatRate or 0) / 100,(attrMaxData.CritTimes or 0) / 100)
    content[#content + 1] = string.format('连招率：%.0f%%        忽视防御率：%.0f%%',(attrMaxData.LianZhaoRate or 0) / 100,(attrMaxData.PenetrateDefenseRate or 0) / 100)
    content[#content + 1] = string.format('合击率：%.0f%%        抗连击率：%.0f%%',(attrMaxData.JointAttackRate or 0) / 100,(attrMaxData.AntiHitRate or 0) / 100)
    content[#content + 1] = string.format('破招率：%.0f%%        反击率：%.0f%%',(attrMaxData.PoZhaoRate or 0) / 100,(attrMaxData.CounterAttackRate or 0) / 100)
    content[#content + 1] = string.format('吸血率：%.0f%%        反弹率：%.0f%%',(attrMaxData.BloodSuckRate or 0) / 100,(attrMaxData.ReboundRate or 0) / 100)
    content[#content + 1] = string.format('援护率：%.0f%%        反弹倍数：%.0f%%',(attrMaxData.AidRate or 0) / 100,(attrMaxData.Rebound or 0) / 100)
    content[#content + 1] = string.format('绝招率：%.0f%%        ',(attrMaxData.UniqueSkillRate or 0) / 100)
    tips.content = "<color=#FFFFFF>" .. table.concat(content, "\n") .. "</color>"
    return tips
end

-- 获取 角色属性增幅 tips
function TipsDataManager:GetRoleAttrAddTips(roleID)
    local tips = {}
    local content = {}
    local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    local uiOverlayLevel = roleData.uiOverlayLevel or 0
    local uiMaxOverlayLevel = 10 --# TODO 钱程 后期将这个值配置到Config里面去 最大叠加等级
    local upMgr = CardsUpgradeDataManager:GetInstance();
    local sCurPercent = string.format("%.0f%%", (upMgr:GetGradeAddAttrPer(uiOverlayLevel) or 0) * 100)
    local sNextPercent = '';
    local uiOverlayLevelNext = 0;
    if uiOverlayLevel < uiMaxOverlayLevel then
        uiOverlayLevelNext = uiOverlayLevel + 1
        sNextPercent = string.format("%.0f%%", (upMgr:GetGradeAddAttrPer(uiOverlayLevelNext) or 0) * 100)
    end
    sCurPercent = string.len(sCurPercent) < string.len(sNextPercent) and sCurPercent .. ' ' or sCurPercent;
    content[#content + 1] = string.format("当前属性提升+%s (<color=#FFA126>+%d</color>)", sCurPercent, uiOverlayLevel)
    if uiOverlayLevel < uiMaxOverlayLevel then
        content[#content + 1] = string.format("下级属性提升+%s (<color=#FFA126>+%d</color>)", sNextPercent, uiOverlayLevelNext)
    end

    content[#content + 1] = "属性提升仅对人物初始、升级、加点这三部分的属性生效"
    content[#content + 1] = "当前因角色卡而提升的属性值为："

    local percent = (upMgr:GetGradeAddAttrPer(uiOverlayLevel) or 0);
    local lidao = math.floor(roleData.aiBaseAttrs[AttrType.ATTR_LIDAO] * percent + 0.5);
    local tizhi = math.floor(roleData.aiBaseAttrs[AttrType.ATTR_TIZHI] * percent + 0.5);
    local jingli = math.floor(roleData.aiBaseAttrs[AttrType.ATTR_JINGLI] * percent + 0.5);
    local neijin = math.floor(roleData.aiBaseAttrs[AttrType.ATTR_NEIJIN] * percent + 0.5);
    local lingqiao = math.floor(roleData.aiBaseAttrs[AttrType.ATTR_LINGQIAO] * percent + 0.5);
    local wuxing = math.floor(roleData.aiBaseAttrs[AttrType.ATTR_WUXING] * percent + 0.5);

    content[#content + 1] = string.format('力道：	%d	体质：	%d', lidao, tizhi);
    content[#content + 1] = string.format('灵巧：	%d	精力：	%d', lingqiao, jingli);
    content[#content + 1] = string.format('内劲：	%d	悟性：	%d', neijin, wuxing);
    content[#content + 1] = "所有角色在挑战心魔成功后, 将会获得一张角色卡"
    tips.content = table.concat(content, "\n")
    return tips
end

-- 获取 角色入队界面 - 关系链 tips
function TipsDataManager:GetRoleShowChainTips(roleData, value)
    local tips = {}
    local typeID = roleData.uiTypeID
    local roleTypeData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(typeID)
    local roleName = RoleDataHelper.GetName(roleData, roleTypeData)
    tips.titlecolor = getRankColor(roleTypeData.Rank or RankType.RT_White)
    tips.title = string.format("%s(%s %d)", roleName or dtext(992), dtext(991), value)
    tips.content = RoleDataHelper.GetDispositionDesByValue(typeID) -- 关系链介绍
    return tips
end

-- 展示tips 角色的个周目心魔挑战细节
function TipsDataManager:GetRoleWishTaskRoleCardDetailsTips(roleid)
    local tips = {}
    tips.title = string.format("剧本内角色卡获得情况")
    local rolecarddata = CardsUpgradeDataManager:GetInstance():GetRoleCardDataByRoleBaseID(roleid)
    local content = ''
    local uiWishFlag = rolecarddata.uiWishFlag or 0
    for i=1,PlayerSetDataManager:GetInstance():GetDifficultOpenMax() do
        local iflag = (1<<i) & uiWishFlag
        if iflag > 0 then
            content = string.format( "%s难度%d：<color=#9FDA57>已获得</color>\n",content,i)
        else
            content = string.format( "%s难度%d：未获得\n",content,i)
        end
    end
    tips.content = content
    tips.kind = 'rolecardui'
    return tips
end

function TipsDataManager:GetChooseItemGiftTips()
    local tips = {}
    tips.title = string.format("温馨提示")
    tips.content = string.format("此处为礼包的奖励选择，您可以根据一下自己的需要来选择对应的奖励。若您一时间还无法抉择，可以点击右边的取消按钮，取消这次奖励选择")

    return tips
end

function TipsDataManager:GetBattleAITips(id)
    local tips = {}
    tips.title = string.format("提示")
    tips.content = GetLanguageByID(id)

    return tips
end

function TipsDataManager:GetRoleShowGiftTips(giftlist, dynRoleData)
    local tips = {}
    local content = {}
    tips.title = dtext(996)
    tips.content = dtext(995)
    if not (giftlist and next(giftlist)) then
        return tips
    end
    for i = 1, #giftlist do
        local giftTypeData = GiftDataManager:GetInstance():GetGiftTypeData(giftlist[i])
        if giftTypeData and giftTypeData.BaseID ~= 794 then
            content[#content + 1] = getRankBasedText(giftTypeData.Rank, GetLanguageByID(giftTypeData.NameID))
            if giftTypeData.BaseID == 616 then
                if dynRoleData then
                    local yinValue = dynRoleData:GetAttr(AttrType.ATTR_NEILIYINXING) / 10;
                    local yangValue = dynRoleData:GetAttr(AttrType.ATTR_NEILIYANGXING) / 10;
                    content[#content + 1] = string.format(GetLanguageByID(giftTypeData.DescID), tostring(yinValue), tostring(yangValue));
                end
            else
                content[#content + 1] = GetLanguageByID(giftTypeData.DescID) or ""
            end
        end
    end
    tips.content = table.concat(content, "\n")
    return tips
end

function TipsDataManager:GetRoleGiftTips(giftIDArray)
    local tips = {}
    local content = {}
    tips.title = dtext(1000)
    tips.content = dtext(995)
    if not (giftIDArray and next(giftIDArray)) then
        return tips
    end
    local GiftDataMgr = GiftDataManager:GetInstance()
    for i = 1, #giftIDArray do

        local giftID = giftIDArray[i]
        local giftData = GiftDataMgr:GetGiftDataByID(giftID)
        if giftData and giftID ~= 794 and giftID ~= 616 and giftID ~= 77 then
            content[#content + 1] = getRankBasedText(giftData.Rank, GetLanguageByID(giftData.NameID))
            content[#content + 1] = GetLanguageByID(giftData.DescID) or ""
        end
    end
    tips.content = table.concat(content, "\n");
    return tips;
end

-- 获取 角色入队界面 - 武学 tips
function TipsDataManager:GetRoleShowMartialTips(ids, lvs)
    local tips = {}
    local content = {}
    tips.title = dtext(993)
    tips.content = dtext(995)
    if not (ids and next(ids)) then
        return tips
    end
    for i = 0, #ids do
        local martialID = ids[i]
        local martialTypeData =  GetTableData("Martial",martialID)
        if not martialTypeData then
            return tips
        end
        local string_name = getRankBasedText(martialTypeData.Rank, GetLanguageByID(martialTypeData.NameID))
        content[#content + 1] =
            string.format(string_name .. "<color=#FFFFFF>   %d%s</color>", lvs[i], dtext(994))

        -- TODO : 武学的附加能力 的标签数组 要附在后面
        -- if kungfu.附加能力 ~= nil then
        --     local _string_标签 = {}
        --     for _, ability in ipairs(kungfu.附加能力) do
        --         if (ability.标签 ~= nil) then
        --             for _, tag in ipairs(ability.标签) do
        --                 if not G.ContainData(_string_标签,tag.标签) then
        --                     table.insert(_string_标签,tag.标签)
        --                     string_name = string.format('%s[%s]',string_name,tag.标签)
        --                 end
        --             end
        --         end
        --     end
        -- end

        -- 武学描述
        content[#content + 1] = GetLanguageByID(martialTypeData.DesID) or ""
    end
    tips.content = table.concat(content, "\n")
    return tips
end

function TipsDataManager:GetBattleSkillTips(martialDataList, index)
    if not martialDataList then
        return
    end

    local martialData = martialDataList[index]
    if not martialData then
        return
    end

    --本武学
    local martialBaseData = GetTableData("Martial",martialData.iMartialID)
    if not martialBaseData then
        return
    end

    --装配武学条目
    local martialItemBaseData = TableDataManager:GetInstance():GetTableData("MartialItem", martialData.iMartialItemTypeID)
    if not martialItemBaseData then
        return
    end

    --默认选择skill1，后期策划若想同时展示多条技能信息，商量展示布局后再定
    local tbl_skill1 = TableDataManager:GetInstance():GetTableData("Skill", martialData.skillID)

    local tips = {}
    local content = {}

    --标题
    tips.title =
        getRankBasedText(
        tbl_skill1.Rank,
        string.format("%s   %d级", GetLanguageByID(tbl_skill1.NameID), martialData.iMartialLevel)
    )

    local string_state = ""
    --门派
    local tbl_Clan = TB_Clan[martialBaseData.ClanID]
    if tbl_Clan then
        string_state = string_state .. "「" .. GetLanguageByID(tbl_Clan.NameID) .. "」"
    end
    --系别
    local departEnum = DepartEnumType_Lang[martialBaseData.DepartEnum]
    if departEnum then
        string_state = string_state .. GetLanguageByID(departEnum)
    end
    tips.state = string_state

    --消耗真气具体数值由服务端下发
    if martialBaseData.EffectEnum1 ~= MartialItemEffect.MTT_BEIDONGJINENG then
        local costMpPercent, _ = MartialDataManager:GetInstance():GetSkillMPCost(tbl_skill1, martialData.iMartialLevel)
        local str_con
        if costMpPercent == 0 then
            str_con = getUIBasedText('blue', "消耗真气：无")
        else
            str_con = getUIBasedText('blue', string.format("消耗真气：%.2f%%最大真气（%d）", costMpPercent, martialData.iCostMP or 0))
        end
        content[#content + 1] = str_con .. "\n"
    end

    --消耗物品todo目前没有技能消耗物品数据

    --技能范围
    local martialDataManagerInst = MartialDataManager:GetInstance()
    local iMartialRangeLevel = martialData['uiRangeLevel'] or 1
    local rangeID = martialDataManagerInst:GetSkillAttackRange(tbl_skill1.SkillRange, iMartialRangeLevel)
    if dnull(rangeID) then
        local tbl_Range = TableDataManager:GetInstance():GetTableData("Range",rangeID)
        if tbl_Range then
            content[#content + 1] = string.format("攻击范围：%s", GetLanguageByID(tbl_Range.NameID)) .. "\n"
        end
    end

    --武学威力由服务端发 显示百分比 服务器下发的为万分比
    if martialData.iPowerBase and martialData.iPowerBase ~= 0 then
        content[#content + 1] = string.format("威力系数：%d",math.floor(martialData.iPowerBase / 100)) .. "\n"
    end
    if martialData.iPowerPercent and martialData.iPowerPercent ~= 0 then
        content[#content + 1] = string.format("威力百分比：%d",math.floor(martialData.iPowerPercent / 100)) .. "%\n"
    end
    -- content[#content + 1] = string.format("武学威力最终系数：%d",math.floor(martialData.iPower / 100)) .. "\n"

    --阴性属性加成
    if martialBaseData.MascCoef > 0 then
        content[#content + 1] =
            string.format("<color=#EE6230>受内力阳性加成：%.1f</color>", martialBaseData.MascCoef * 1.0 / 10000) .. "\n"
    end
    if martialBaseData.FemiCoef > 0 then
        content[#content + 1] =
            string.format("<color=#669ABA>受内力阴性加成：%.1f</color>", martialBaseData.FemiCoef * 1.0 / 10000) .. "\n"
    end

    --martialData.iDamageValue
    --技能描述
    local skilldamagevalue =  martialData.iDamageValue
    local skillDefaultDamageValue =  martialData.iDefaultDamageValue

    local skillTriggers = tbl_skill1.SkillTriggers
    local mulitStageCount = 1
    if skillTriggers and skillTriggers[1] and skillTriggers[1].EffectID and (skillTriggers[1].EffectID > 0) then
        mulitStageCount = martialDataManagerInst:GetSkillMultiStepCount(skillTriggers[1].EffectID)
    end
    local CatapultTimes = martialDataManagerInst:GetMartialCatapult(martialData.iMartialID)



    local skillDescribe = martialDataManagerInst:FillPlaceholder(GetLanguageByID(tbl_skill1.DescID or 0), mulitStageCount, skillDefaultDamageValue,skilldamagevalue,CatapultTimes)
    content[#content + 1] = "\n" .. skillDescribe .. "\n"

    --累计武学威力
    local string_MartialPower = ""
    if martialBaseData.GrowProIDs then
        local growProData = nil
        local hide = false
        for index, growpProID in ipairs(martialBaseData.GrowProIDs) do
            growProData = TableDataManager:GetInstance():GetTableData("MartialItem", growpProID)
            local matAttr = growProData["MAttrEnum" .. index]
            if matAttr == AttrType.MP_WEILI then
                local value = martialDataManagerInst:AssistGetMartialPowerSelf(martialBaseData)
                string_MartialPower = "\n(累计威力+" .. value * 100 * martialData.iMartialLevel .. "%)"
                content[#content + 1] = string_MartialPower
            end
        end
    end

    --武学加成todo
    local string_otherMartialEffect = ""
    for _, data in pairs(martialDataList) do
        local tbl_kungfu = GetTableData("Martial",data.iMartialID)
        local ret = ""
        if tbl_kungfu.UnlockClauses and tbl_kungfu.UnlockLvls then
            for i = 1, #tbl_kungfu.UnlockClauses do
                if martialData.iMartialLevel >= tbl_kungfu.UnlockLvls[i] then
                    local martialItemBaseData = TableDataManager:GetInstance():GetTableData("MartialItem", tbl_kungfu.UnlockClauses[i])
                    if martialItemBaseData and martialItemBaseData.ItemFeature ~= MartialItemFeature.IFF_Hide then
                        if martialItemBaseData.CondID == 0 or RoleDataHelper.ConditionComp(martialItemBaseData.CondID,martialData,martialBaseData) then
                            local string_Des = martialItemBaseData.DesID
                            for i = 1, 2 do
                                local trigger = martialItemBaseData["EffectEnum" .. i]
                                if trigger then
                                    local args = martialItemBaseData["Effect" .. i .. "Value"]
                                    if trigger == MartialItemEffect.MTT_BEIDONGJINENG and tbl_kungfu.BaseID == martialBaseData.BaseID then
                                        local skillID = martialItemBaseData["SkillID" .. i]
                                        local skillData = TableDataManager:GetInstance():GetTableData("Skill", skillID)
                                        if skillData and skillData.DescID then
                                            ret = ret .. '\n' .. martialDataManagerInst:GetSkillDesc(skillData, tbl_kungfu)
                                        end
                                    elseif trigger == MartialItemEffect.MTT_XIBIEWUXUESHUXING then
                                        local matAttr = martialItemBaseData["MAttrEnum" .. index]
                                        if matAttr then
                                            local clan = args[2]
                                            local depart = args[3]
                                            local poison = args[4]
                                            local multistage = args[5]
                                            local rank = args[6]
                                            local num = args[1]
                                            if args[7] then
                                                clan = nil
                                                depart = tbl_kungfu.departEnum
                                                poison = nil
                                                multistage = nil
                                                rank = nil
                                                num = martialDataManagerInst:AssistGetMartialPowerByDepart(tbl_kungfu)
                                            end
                                            if martialDataManagerInst:MartialAdditionMeetDepart(nil,martialBaseData,clan,depart,poison,multistage,rank) then
                                                ret = ret .. string.format("\n%s加%s",GetLanguageByID(MartialProperty_Lang[matAttr]),num < 1 and tostring(num * 100)..'%' or num)
                                            end
                                        end
                                    elseif effectEnum == MartialItemEffect.MTT_WUXUESHUXING then
                                        local mAttrEnumKey = "MAttrEnum" .. index
                                        if args[3] == martialBaseData.BaseID then--指定武学
                                            --附加值
                                            local num = (args[1] or 0) / 10000
                                            if mAttrEnumKey == AttrType.MP_WEILI then
                                                num = martialDataManagerInst:AssistGetMartialPowerAppointed(tbl_kungfu)
                                            end
                                            ret = ret .. string.format("\n%s加%s",GetLanguageByID(MartialProperty_Lang[mAttrEnumKey]),num < 1 and tostring(num * 100)..'%' or num)
                                        else--本武学
                                            if tbl_kungfu.BaseID == martialBaseData.BaseID then
                                                --附加值
                                                local num = (args[1] or 0) / 10000
                                                if mAttrEnumKey == AttrType.MP_WEILI then
                                                    num = martialDataManagerInst:AssistGetMartialPowerSelf(tbl_kungfu)
                                                end
                                                if num == 0 and args[2] then
                                                    num = args[2]
                                                end
                                                ret = ret .. string.format("\n%s加%s",GetLanguageByID(MartialProperty_Lang[mAttrEnumKey]),num < 1 and tostring(num * 100)..'%' or num)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if ret ~= '' then
                string_otherMartialEffect = string_otherMartialEffect .. '\n' .. getRankBasedText(tbl_kungfu.Rank, GetLanguageByID(tbl_kungfu.NameID) ..":") ..ret
            end
        end
    end

    local coldTime = MartialDataManager:GetInstance():GetMartialMaxColdTime(martialData.iMartialID)
    local remainColdTime = 0
    if martialData then
        remainColdTime = martialData.coldTime or 0
    end
    if coldTime and coldTime > 0 then
        if remainColdTime > 0 then
            content[#content + 1] = "\n" .. '冷却时间:' .. coldTime .. '回合 (剩余' .. remainColdTime .. '回合)'
        else
            content[#content + 1] = "\n" .. '冷却时间:' .. coldTime .. '回合'
        end
    else
        content[#content + 1] = "\n" .. '冷却时间:无'
    end
    if string_otherMartialEffect ~= '' then
        content[#content + 1] ="\n" .. "[武学加成]" .. string_otherMartialEffect
    end
    tips.content = table.concat(content, "")

    return tips
end

function TipsDataManager:GetBattleRoleTips(uiUnitIndex)
    local tips = {}
    local content = {}
    local kUnit = LogicMain:GetInstance().kUnitMgr:GetUnit(uiUnitIndex)
    if kUnit then
         --标题
        tips.title = kUnit:GetName()
        --生命值
        content[#content + 1] = string.format("<color=white>生命值：%d / %d</color>",kUnit:GetHP(),kUnit:GetMAXHP()) .. "\n"
        --真气
        content[#content + 1] = string.format("<color=white>真气：%d / %d</color>",kUnit:GetMP(),kUnit:GetMAXMP()) .. "\n"
        --奇门攻击

        content[#content + 1] = string.format("<color=white>武学攻击：%d </color>", kUnit.iMaxAttack or 0) .. "\n"
        --防御
        content[#content + 1] = string.format("<color=white>防御：%d </color>",kUnit.iDefend or 0) .. "\n"
        --速度
        content[#content + 1] = string.format("<color=white>速度：%d </color>",kUnit.iMoveValue or 0) .. "\n"
        --护盾值
        content[#content + 1] = string.format("<color=white>护盾值：%d </color>",kUnit.iShield or 0) .. "\n"

        content[#content + 1] = "\n"
        -- 预处理，回合数一样的buff合并
        local allBuff = {}
        kUnit.iBuffNum = kUnit.iBuffNum or 0
        for index = 0,kUnit.iBuffNum - 1 do
            local buff = kUnit.akBuffData[index]
            if buff ~= nil then
                local id = tostring(buff.iBuffTypeID) .. "_" .. tostring(buff.iRoundNum)
                if allBuff[id] then
                    allBuff[id].iLayerNum = allBuff[id].iLayerNum + buff.iLayerNum
                else
                    allBuff[id] = buff
                end
            end
        end
        kUnit.iBuffNum = 0
        kUnit.akBuffData = {}
        for k,buff in pairs(allBuff) do
            kUnit.akBuffData[kUnit.iBuffNum] = buff
            kUnit.iBuffNum = kUnit.iBuffNum + 1
        end
        --buff
        local Local_TB_Buff = TableDataManager:GetInstance():GetTable("Buff")
        for index = 0,kUnit.iBuffNum - 1 do
            local buff = kUnit.akBuffData[index]
            if  buff ~= nil then
                local iBuffIndex = buff.iBuffIndex
                local iBuffTypeID = buff.iBuffTypeID
                local iRoundNum = buff.iRoundNum
                local iLayerNum = buff.iLayerNum
                local tbBuffData = Local_TB_Buff[iBuffTypeID]
                if  iRoundNum ~= 0 and tbBuffData ~= nil then
                    local texnum = GiftDataManager:GetInstance():GetUpgradeGiftInfluenceNum(uiUnitIndex,iBuffTypeID,iLayerNum)
                    local color = "white"
                    for k,bufFea in pairs(tbBuffData.BuffFeature) do
                        if bufFea == BuffFeatureType.BuffFeatureType_PositiveBuff then
                            color = "green"
                            break
                        elseif bufFea == BuffFeatureType.BuffFeatureType_NegativeBuff then
                            color = "red"
                            break
                        end
                    end
                    local string_level = ""
                    local string_layer = ""
                    string_level = string.format("%d 层",iLayerNum)
                    if iRoundNum >= 99 then
                        string_layer = "不衰减"
                    else
                        string_layer = string.format("%d 回合",iRoundNum)
                    end
                    content[#content + 1] = string.format("<color=%s>%s(%s)---%s </color>",color,GetLanguageByID(tbBuffData.NameID),string_level,string_layer) .. "\n"
                    local strDesc =  self:GetBuffDescReplace(LogicMain:GetInstance():GetBuffDesc(iBuffIndex,tbBuffData), texnum,iBuffTypeID)
                    content[#content + 1] = string.format("<color=white>%s </color>",strDesc) .. "\n"
                end
            end
        end
        tips.content = table.concat(content, "")
    end
    return tips
end

function TipsDataManager:GetBuffDescReplace(str,iDamageValue,iBuffTypeID)
    if not str or type(str) ~= 'string' then
        return ''
    end
    local str_ret = ''
    if not iDamageValue then
        iDamageValue = 0
    end
    if iBuffTypeID == 138 then
        -- 中毒特殊处理
        local istart,iend =  string.find(str,"%[DamageValue%]")
        str_ret = string.sub( str, 1,istart-1 ) .. math.floor(iDamageValue) * 3
        str = string.sub( str,iend +1 )
        istart,iend =  string.find(str,"%[DamageValue%]")
        str_ret = str_ret .. string.sub( str, 1,istart-1 ) .. math.floor(iDamageValue)  .. string.sub( str, iend + 1)
    elseif iBuffTypeID == 4092 then
        -- 迷宫疲劳特殊处理
        str_ret =  string.format("迷宫中每前进一步，全队所有成员将会损失%d点生命值", math.floor(iDamageValue))
    else
        str_ret =  string.gsub(str,"%[DamageValue%]", math.floor(iDamageValue))
    end
    return str_ret
end
function TipsDataManager:GetBattleScoreEvaluate()
    local tips = {}
    tips.title = "<size=18>战斗评价</size>"
    tips.content = "<size=16>战斗结束后，将根据战斗表现计算得分并得出战斗战斗评价\n100：完胜\n75-99：大胜\n30-75：胜利\n0-30：险胜</size>"
    return tips
end

function TipsDataManager:GetBattleAwardAdditionTips()
    local tips = {}
    tips.title = "<size=28>奖励加成</size>"
    local achieveReward = globalDataPool:getData("AchieveReward")
    local count = 1
    local content = {}
    content[count] = "<size=22>"
    local tbl_AchieveReward, tbl_Language
    if achieveReward then
        for _, value in pairs(achieveReward) do
            tbl_AchieveReward = TableDataManager:GetInstance():GetTableData("AchieveReward",value)
            if tbl_AchieveReward then
                tbl_Language = GetLanguageByID(tbl_AchieveReward.DescID)
                count = count + 1
                content[count] = tbl_Language .. "\n"
            end
        end
    end
    --
    local info = globalDataPool:getData("MainRoleInfo");
    if info and info.MainRole then
        local roleexp = info.MainRole[MainRoleData.MRD_EXTRA_ROLEEXP]
        if roleexp and roleexp ~= 0 then
            count = count + 1
            content[count] = string.format("开局奖励-队伍经验加成    +%.0f%%\n" , info.MainRole[MainRoleData.MRD_EXTRA_ROLEEXP] / 100)
        end
        local martialexp = info.MainRole[MainRoleData.MRD_EXTRA_MARITAL]
        if martialexp and martialexp ~= 0 then
            count = count + 1
            content[count] = string.format("开局奖励-武学经验加成    +%.0f%%\n" , info.MainRole[MainRoleData.MRD_EXTRA_MARITAL] / 100)
        end
    end
    local coins = LogicMain:GetInstance():GetAwardCoin()
    if coins > 0 then
        count = count + 1
        content[count] = string.format("金钱搜刮    金钱+%.0f\n" , coins)
    end

    if LogicMain:GetInstance():GetAwardInfoNum() > 0 then
        count = count + 1
        content[count] = LogicMain:GetInstance():GetAwardInfo()
    end


    content[#content + 1] = (achieveReward or count == 0) and "无</size>" or "</size>"
    tips.content = table.concat(content, "")
    return tips
end

function TipsDataManager:GetDiffDropTips(TB_DiffDropData)
    local tips = {}
    tips.title = "<size=28>幸运值掉落</size>"
    tips.content = ""
    if (TB_DiffDropData ~= nil) then
        tips.content = TB_DiffDropData.Desc
    end

    return tips
end
function TipsDataManager:GetBackpackExtendTips()
    local tips = {}
    tips.title = "<size=28>当前背包容量</size>"
    local str_Content = ''
    local commonConfig = TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    -- 基础容量
    local baseSize = commonConfig.BackpackBaseSize or 0
    str_Content = string.format('%s\n基础容量：%d',str_Content,baseSize)
    -- 难度提升容量
    local sizePerDiff = commonConfig.BackpackSizePerDiff or 0
    local diffValue = RoleDataManager:GetInstance():GetDifficultyValue() or 1
    local diffSize = (diffValue - 1) * sizePerDiff
    str_Content = string.format('%s\n难度提升容量：%d',str_Content,diffSize)
    -- 成就奖励提升容量
    local iRewardID = 16  -- 包治百病 成就点数奖励
    local kRewardTypeData = TableDataManager:GetInstance():GetTableData("AchieveReward", iRewardID) or {}
    local iRewardSize = kRewardTypeData.RewardValueB or 0
    local bRewardHasChosen = AchieveDataManager:GetInstance():IfAchieveRewardBeenChosen(iRewardID)
    if not bRewardHasChosen then
        iRewardSize = 0
    end
    str_Content = string.format('%s\n成就奖励提升容量：%d',str_Content,iRewardSize)
    -- 当前总容量
    local roleInfo = globalDataPool:getData("MainRoleInfo") or {}
    local mainRoleInfo = roleInfo["MainRole"]
    local backpackSizeLimit = mainRoleInfo and mainRoleInfo[MRIT_BAG_ITEMNUM] or 0
    str_Content = string.format('%s\n\n当前总容量：%d',str_Content,backpackSizeLimit)

    tips.content = str_Content
    return tips
end

return TipsDataManager
