PKRoleBox = class("PKRoleBox", BaseBox)

function PKRoleBox:ctor(root)
    self:Super(root)

    self.mRole = CityRoleUI.new()
    local roleObj = self:FindChild(root, "CityRoleUI")
    self.mRole:SetGameObject(roleObj)
    self.mRole:SetSpine(self:FindChild(roleObj, "Spine"), false)
    self.mRole:SetDefaultScale(MAZE_SPINE_SCALE)

    self.mLabClan = self:FindChildComponent(roleObj, "Clan/Name", "Text")

    self.mLock = self:FindChild(roleObj, "Lock")

    self:RegisterClick(self.Root:GetComponent("Button"), self.OnClickBox)
    self:RegisterClick(self:FindChildComponent(root, "BtnWatch", "Button"), self.OnClickWatch)
end

function PKRoleBox:Refresh(baseID, mixLevel, index, dialogID)
    self.mIndex = index
    self.mBaseID = baseID
    self.mMixLevel = mixLevel

    local pkRoleMain = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16)) or {}
    local roleID = pkRoleMain["RoleID"]
    local grade = pkRoleMain["Grade"] or 0

    self.mLock:SetActive(false)
    self.mLabClan.text = ""

    if roleID then
        self.mRole:SetRoleDataByBaseID(roleID)
        self.mRole:UpdateCityRole()
        self.mRole:UpdateRoleGrade(grade)

        -- 门派名称
        local roleBaseData = RoleDataManager:GetInstance():GetRoleTypeDataByID(roleID) or {}
        local clanID = roleBaseData.Clan or 0
        local strClanName = ClanDataManager:GetInstance():GetClanNameByBaseID(clanID)
        self.mLabClan.text = strClanName ~= "" and strClanName or "无门派"

        PKManager:GetInstance():SetIdleAction(self.mRole, baseID, mixLevel)

        -- 队伍标识
        local inTeam = PKManager:GetInstance():InTeam(baseID)
        if inTeam then
            self.mRole:ShowTeamMark()
        else
            self.mRole:HideTeamMark()
        end

        -- 冒泡
        if dialogID then
            self.mRole:ShowBubble(GetLanguageByID(dialogID) or "", 2)
        else
            self.mRole:HideBubble()
        end

        -- 锁定状态
        local config = GetTableData("PKConfig", 1) or {}
        local forbidSelectLock = config["ForbidSelectLock"] == 1
        if forbidSelectLock then
            local pkRole = GetTableData("PKRole", self.mBaseID)
            if not CardsUpgradeDataManager:GetInstance():IsRoleCardUnlock(pkRole["RoleID"] or 0) then
                self.mLock:SetActive(true)
            end
        end
    end
end

function PKRoleBox:OnClickWatch()
    if self.mBaseID then
        local pkRole = GetTableData("PKRole", self.mBaseID)
        if pkRole then
            local roleID = pkRole["RoleID"] or 0
            CardsUpgradeDataManager:GetInstance():DisplayRoleCardInfoObserve(roleID)
        end
    end
end

function PKRoleBox:OnClickBox()
    if self.mBaseID then
        local pkRole = GetTableData("PKRole", self.mBaseID)
        if pkRole then
            local roleID = pkRole["RoleID"] or 0

            local config = GetTableData("PKConfig", 1) or {}
            local forbidSelectLock = config["ForbidSelectLock"] == 1
            if forbidSelectLock then
                if not CardsUpgradeDataManager:GetInstance():IsRoleCardUnlock(roleID) then
                    SystemUICall:GetInstance():Toast("你还没有解锁该角色，请在收藏-角色界面查看已解锁的角色", false)
                    return
                end
            end

            local grade = CardsUpgradeDataManager:GetInstance():GetRoleCardLevelByRoleBaseID(roleID) or 0
            local pkUnlock = GetTableData("PKUnlock", grade)
            local maxTrueMixLevel = pkUnlock["TrueMixLevel"] or 0

            local pkRoleMain = GetTableData("PKRoleMain", (self.mBaseID << 0 | self.mMixLevel << 16)) or {}
            local trueMixLevel = pkRoleMain["TrueMixLevel"] or 0

            local inTeam = PKManager:GetInstance():InTeam(self.mBaseID)

            local lock = false

            if inTeam then
                lock = trueMixLevel >= maxTrueMixLevel
            else
                lock = trueMixLevel > maxTrueMixLevel
            end

            if lock then
                local pkRoleUpgrade = GetTableData("PKRoleUpgrade", maxTrueMixLevel)
                if pkRoleUpgrade then
                    local roleName = RoleDataManager:GetInstance():GetRoleName(roleID, true)
                    local rankName = GetLanguageByID(pkUnlock["RankNameID"] or 0)
                    OpenWindowImmediately(
                        "GeneralBoxUI",
                        {
                            GeneralBoxType.COMMON_TIP,
                            string.format(
                                "%s最高只能升到%s，%d级，继续选择该角色，将分解为%d次刷新次数。\n在收藏-角色系统中，提升角色的修行等级，可提高掌门对决中的等级上限。\n是否选择%s并分解为%d次刷新次数？",
                                roleName,
                                rankName,
                                pkRoleUpgrade["Level"],
                                pkRoleUpgrade["RefreshTime"],
                                roleName,
                                pkRoleUpgrade["RefreshTime"]
                            ),
                            function()
                                PKManager:GetInstance():RequestSelectRole(self.mIndex)
                            end
                        }
                    )
                    return
                end
            end
        end
    end

    PKManager:GetInstance():RequestSelectRole(self.mIndex)
end

return PKRoleBox
