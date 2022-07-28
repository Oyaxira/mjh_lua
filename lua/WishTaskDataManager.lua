WishTaskDataManager = class("WishTaskDataManager")
WishTaskDataManager._instance = nil

function WishTaskDataManager:GetInstance()
    if WishTaskDataManager._instance == nil then
        WishTaskDataManager._instance = WishTaskDataManager.new()
    end

    return WishTaskDataManager._instance
end

function WishTaskDataManager:ResetManager()
    self.WishTaskPool = nil
end

-- 根据 uiTypeID，返回 uiID（从静态表里找动态数据）
function WishTaskDataManager:FindWishTask(uiTypeID)
    self.WishTaskPool = self.WishTaskPool or {}
    for i,v in pairs(self.WishTaskPool) do
        if v.uiTypeID == uiTypeID then
            return v.uiID
        end
    end
end

-- 根据角色的 roleID，获取角色拥有的天赋列表
function WishTaskDataManager:GetRoleWishTask(roleID)
    if not roleID then
        return
    end
	local roleData = RoleDataManager:GetInstance():GetRoleData(roleID)
    if (roleData == nil) then
        derror("获取角色天赋,角色不存在,id=" .. roleID)
        return
    end
    return roleData["auiRoleWishTasks"]
end

-- 查询 WishTaskID（也就是 uiID）对应的天赋信息
function WishTaskDataManager:GetWishTaskData(WishTaskID)
    if GetGameState() == -1 then
        local info = globalDataPool:getData('PlatTeamInfo');
        if info and info.WishTaskInfo then
            return info.WishTaskInfo[WishTaskID];
        end
    else
        self.WishTaskPool = self.WishTaskPool or {}
        return self.WishTaskPool[WishTaskID]
    end
end

-- 查询 天赋 在 TB_WishTask 表中的静态信息
function WishTaskDataManager:GetWishTaskTypeID(uiID)
    if uiID == nil then return end
    self.WishTaskPool = self.WishTaskPool or {}
    local WishTaskData = self.WishTaskPool[uiID]
    if WishTaskData then 
        return WishTaskData.uiTypeID
    end

    return 0
end

-- 查询 天赋 在 TB_WishTask 表中的静态信息
function WishTaskDataManager:GetWishTaskTypeData(WishTaskID)
    self.WishTaskPool = self.WishTaskPool or {}
    local WishTaskData = self.WishTaskPool[WishTaskID]
    if WishTaskData then 
        local typeID = WishTaskData.uiTypeID
        return TableDataManager:GetInstance():GetTableData("RoleWishQuest",typeID)
    end
    return nil
end

-- 服务器下行：删除天赋信息
function WishTaskDataManager:DeleteWishTaskData(WishTaskID)
    self.WishTaskPool = self.WishTaskPool or {}
    if self.WishTaskPool[WishTaskID] then 
        self.WishTaskPool[WishTaskID] = nil
        self:DispatchUpdateEvent()
    end
end

-- 服务器下行：更新全部天赋信息
function WishTaskDataManager:UpdateWishTaskDataByArray(WishTaskDataArray, arraySize)
    if not (WishTaskDataArray and arraySize) then 
        return
    end
    self.WishTaskPool = self.WishTaskPool or {}
    for i = 1, arraySize do 
        local WishTaskData = WishTaskDataArray[i - 1]
        local uiID = WishTaskData.uiID
        self.WishTaskPool[uiID] = WishTaskData
    end
    self:DispatchUpdateEvent()
end

function WishTaskDataManager:DispatchUpdateEvent()
    --LuaEventDispatcher:dispatchEvent("UPDATE_WISHTASK")
    local CharacterUI = GetUIWindow('CharacterUI')
    if CharacterUI then
        CharacterUI:RefreshWishTask()
    end
end

function WishTaskDataManager:GetWishTaskDesc(selectRoleID, rewardId)
    local _Reward = TableDataManager:GetInstance():GetTableData("RoleWishReward", rewardId)
    if _Reward == nil then
        return ""
    end
    if _Reward.DescID ~= 0 then
        return GetLanguageByID(_Reward.DescID)
    end
    local string_Des = ''
    local string_Cost = 0
    if _Reward.MartialIDs and next(_Reward.MartialIDs) ~= nil then
        for _, martialID in pairs(_Reward.MartialIDs) do
            local martialData = GetTableData("Martial",martialID)
            if martialData ~= nil then
                local martialName = getRankBasedText(martialData.Rank,string.format("武学《%s》：",GetLanguageByID(martialData.NameID)),true) or ""
                string_Des = string_Des..string.format("%s\n",getSizeText(20,martialName))
                string_Des = string_Des..getSizeText(18,GetLanguageByID(martialData.DesID)).."\n"
            else
                string_Des = '武学错误'..martialID
            end
        end
    end

    if dnull(_Reward.WishTreeID) and selectRoleID then
        -- 只取对应等级最高解锁的天赋 by 陈相相
        local selectRoleBaseID = RoleDataManager:GetInstance():GetRoleTypeID(selectRoleID)
        local cardLevel = RoleDataManager:GetInstance():GetRoleOverlayLevel(selectRoleID)
        local giftID = CardsUpgradeDataManager:GetInstance():GetTreeGift(selectRoleBaseID, cardLevel, _Reward.WishTreeID)
        local giftData = GetTableData("Gift", giftID)
        if giftData then
            local giftName = getRankBasedText(giftData.Rank,string.format("天赋《%s》：",GetLanguageByID(giftData.NameID)),true) or ""
            string_Des = string_Des..string.format("%s\n",getSizeText(20,giftName))
            string_Des = string_Des..getSizeText(18, GetLanguageByID(giftData.DescID)).."\n"
            string_Cost = giftData.Cost
        else
            string_Des = '天赋错误' .. giftID
        end
    elseif _Reward.GiftIDs and next(_Reward.GiftIDs) ~= nil then
        for _, giftID in pairs(_Reward.GiftIDs) do
            local giftData = GetTableData("Gift",giftID)
            if giftData then
                local giftName = getRankBasedText(giftData.Rank,string.format("天赋《%s》：",GetLanguageByID(giftData.NameID)),true) or ""
                string_Des = string_Des..string.format("%s\n",getSizeText(20,giftName))
                string_Des = string_Des..getSizeText(18, GetLanguageByID(giftData.DescID)).."\n"
                string_Cost = giftData.Cost
            else
                string_Des = '天赋错误'..giftID
            end
        end
    end

    if _Reward.RoleAttrs and next(_Reward.RoleAttrs) ~= nil then
        for index, iattrid in pairs(_Reward.RoleAttrs) do
            string_Des = string_Des..getSizeText(24,"<color=#CB4424>属性奖励：</color>\n".."")
            local ret = ''
            local attr_name = GetLanguageByID(AttrType_Lang[iattrid]) or "error"
            --string_Des = string_Des..attr_name
            local int_value = _Reward.Values[index] or 0

            local bIsPerMyriad,bShowAsPercent = MartialDataManager:GetInstance():AttrValueIsPermyriad(iattrid)

            int_value = int_value / 10000
            if bShowAsPercent then
                if int_value == 0 then return "0%" end
                local fvalue = int_value * 100
                if fvalue == math.floor(fvalue) then
                    int_value = string.format("%.0f%%", fvalue)
                else
                    int_value = string.format("%.1f%%", fvalue)
                end
            else
                if int_value == 0 then return "0" end
                local fs
                if  bIsPerMyriad and int_value ~= math.floor(int_value) then
                    fs = "%.1f" 
                else
                    fs = "%.0f"
                end
                int_value = string.format(fs, int_value)
            end

            ret = string.format("%s%s+%s",ret, attr_name, int_value)
            string_Des = string_Des..ret
        end
    end
    return string_Des,string_Cost
end

function WishTaskDataManager:Sort(auiRoleWishTasks)
    auiRoleWishTasks = table_c2lua(auiRoleWishTasks)
    if auiRoleWishTasks and #auiRoleWishTasks > 1 then
        table.sort(auiRoleWishTasks,function(baseID1,baseID2)  
            local typeID1 = self:GetWishTaskTypeID(baseID1)
            local typeID2 = self:GetWishTaskTypeID(baseID2)


            local tbData1 = self:GetWishTaskTypeData(baseID1)
            local tbData2 = self:GetWishTaskTypeData(baseID2)

            if tbData1 == nil or tbData2 == nil then
                return false
            end

            if tbData1.sortOrder == nil or tbData2.sortOrder == nil then
                return false
            end
            -- 心魔永远滞后
            if typeID1 == 8 then
                return false
            end
            if typeID2 == 8 then
                return true
            end

            return tbData1.sortOrder < tbData2.sortOrder
        end)
    end

    return auiRoleWishTasks
end

function WishTaskDataManager:InitTable_InnerDemoLevel()
    local _InnerDemonLevel = TableDataManager:GetInstance():GetTable("InnerDemonLevel")
    if _InnerDemonLevel and next(_InnerDemonLevel) ~= nil then
        if self.m_akInnerDemonLevel == nil then
            self.m_akInnerDemonLevel = {}
        end

        for key, value in pairs(_InnerDemonLevel) do
            local uiCardLevel = value.BaseID
            if self.m_akInnerDemonLevel[uiCardLevel] == nil then
                self.m_akInnerDemonLevel[uiCardLevel] = {}
            end
            self.m_akInnerDemonLevel[uiCardLevel][RankType.RT_White] = value.White
            self.m_akInnerDemonLevel[uiCardLevel][RankType.RT_Green] = value.Green
            self.m_akInnerDemonLevel[uiCardLevel][RankType.RT_Blue] = value.Blue
            self.m_akInnerDemonLevel[uiCardLevel][RankType.RT_Purple] = value.Purple
            self.m_akInnerDemonLevel[uiCardLevel][RankType.RT_Orange] = value.Orange
            self.m_akInnerDemonLevel[uiCardLevel][RankType.RT_Golden] = value.Golden
            self.m_akInnerDemonLevel[uiCardLevel][RankType.RT_DarkGolden] = value.DarkGolden
        end
    end
end

function WishTaskDataManager:GetInnerDemoLevel(uiCardLevel, uiRank, roleTypeID)
    if self.m_akInnerDemonLevel == nil then
        self:InitTable_InnerDemoLevel()
    end

    if roleTypeID then
        local specialLevelData = TableDataManager:GetInstance():GetTableData("SpecialRoleInnerDemon", roleTypeID)
        if specialLevelData then
            return specialLevelData.OpenLevel
        end
    end

    if uiRank == RankType.RT_MultiColor or uiRank == RankType.RT_ThirdGearDarkGolden then
        uiRank = RankType.RT_DarkGolden
    end

    if  self.m_akInnerDemonLevel == nil then
        return 0
    end

    if  self.m_akInnerDemonLevel[uiCardLevel] == nil then
        return 0
    end

    return self.m_akInnerDemonLevel[uiCardLevel][uiRank] or 0
end