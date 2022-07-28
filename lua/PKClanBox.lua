PKClanBox = class("PKClanBox", BaseBox)

function PKClanBox:ctor(root)
    self:Super(root)

    self.mRole = CityRoleUI.new()
    local roleObj = self:FindChild(root, "CityRoleUI")
    self.mRole:SetGameObject(roleObj)
    self.mRole:SetSpine(self:FindChild(roleObj, "Spine"), false)
    self.mRole:SetDefaultScale(MAZE_SPINE_SCALE)

    self:RegisterClick(self.Root:GetComponent("Button"), self.OnClickBox)
end

function PKClanBox:Refresh(clanID, index)
    self.mID = clanID
    self.mIndex = index

    local pkClanData = clanID ~= nil and TableDataManager:GetInstance():GetTableData("PKClan", clanID) or nil

    if pkClanData then
        local clanData = TableDataManager.GetInstance():GetTableData("Clan", clanID)

        local roleTypeID = pkClanData.ClanMasterID

        self.mRole:SetRoleDataByUID(roleTypeID)
        self.mRole:UpdateCityRole()
        -- TODO: 这里掌门名称要获取下
        self.mRole:UpdateRoleNameByCustomData({NameID = clanData.NameID})
    end
end

function PKClanBox:OnClickBox()
    self:ShowDialog()
end

function PKClanBox:ShowDialog()
    local clanID = self.mID
    local index = self.mIndex

    local pkClanData = clanID ~= nil and TableDataManager:GetInstance():GetTableData("PKClan", clanID) or nil
    if not pkClanData then
        return
    end

    -- local clanData = TableDataManager.GetInstance():GetTableData("Clan", clanID)
    -- local clanName = clanData and GetLanguageByID(clanData.NameID) or ""

    -- local giveBaseID = pkClanData.RoleID
    -- local giveRoleID = (GetTableData("PKRole", giveBaseID) or {}).RoleID
    -- local giveRoleData = giveRoleID ~= nil and RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(giveRoleID) or nil

    -- local weightProList = pkClanData.WeightProList

    -- local des =
    --     string.format(
    --     "选择%s掌门，立即获得%s（%s色%d级）\n所有%s角色出现几率+%s",
    --     clanName,
    --     RoleDataManager:GetInstance():GetRoleName(giveRoleID, true),
    --     PKManager:GetInstance():GetRankName(giveRoleData.Rank),
    --     giveRoleData.Level,
    --     clanName,
    --     tostring(weightProList[1] or 0) .. "%"
    -- )

    -- local choicelist = {}
    -- choicelist[1] = {
    --     func = function()
    --         PKManager:GetInstance():RequestSelectClan(index)
    --         AddLoadingDelayRemoveWindow("DialogChoiceUI", true)
    --     end,
    --     str = "选为本局掌门"
    -- }
    -- choicelist[2] = {
    --     func = function()
    --         ResetWaitDisplayMsgState()
    --         DisplayActionEnd()
    --     end,
    --     str = "离开"
    -- }

    -- local roleTypeID = pkClanData.ClanMasterID
    -- PKManager:GetInstance():ShowDialog(roleTypeID, des, choicelist)

    local roleTypeID = pkClanData.ClanMasterID
    local dialogList = pkClanData["DialogList"] or {}
    local len = #dialogList
    if len > 1 then
        for i = 1, len - 1 do
            DisplayActionManager:GetInstance():AddAction(
                DisplayActionType.PLOT_DIALOGUE_STR,
                false,
                roleTypeID,
                GetLanguageByID(dialogList[i])
            )
        end
    end

    local choicelist = {}
    choicelist[1] = {
        func = function()
            PKManager:GetInstance():RequestSelectClan(index)
            AddLoadingDelayRemoveWindow("DialogChoiceUI", true)
        end,
        str = "选为本局掌门"
    }
    choicelist[2] = {
        func = function()
            ResetWaitDisplayMsgState()
            DisplayActionEnd()
            RemoveWindowImmediately("SelectUI")
        end,
        str = "离开"
    }

    PKManager:GetInstance():ShowDialog(roleTypeID, GetLanguageByID(dialogList[len]), choicelist)
end

return PKClanBox
