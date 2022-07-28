PKSelectUI = class("PKSelectUI", BaseWindow)

local Util = require("xlua/util")
local PKRoleBox = require("UI/PKUI/PKRoleBox")
local PKEquipBox = require("UI/PKUI/PKEquipBox")

local PKSelectUIType = {
    None = 0,
    SelectRole = 1,
    SelectEquip = 2
}

function PKSelectUI:ctor()
    local obj = LoadPrefabAndInit("PKUI/PKSelectUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function PKSelectUI:Create()
    -- 选择角色界面
    index = 1
    local selctRoleGroup = self:FindChild(self._gameObject, "SelectRoleGroup")
    local role = self:FindChild(selctRoleGroup, "Role")
    self.mSelectRoleGroup = {
        Root = selctRoleGroup,
        RoleBoxList = self:BuildBoxList(PKRoleBox, role, "Role%d"),
        LabRefreshTip = self:FindChildComponent(selctRoleGroup, "LabRefreshTip", "Text")
    }

    -- 选择神器界面
    index = 1
    local selectEquipGroup = self:FindChild(self._gameObject, "SelectEquipGroup")
    local equip = self:FindChild(selectEquipGroup, "Equip")
    self.mSelectEquipGroup = {
        Root = selectEquipGroup,
        EquipBoxList = self:BuildBoxList(PKEquipBox, equip, "Equip%d"),
        LabRefreshTip = self:FindChildComponent(selectEquipGroup, "LabRefreshTip", "Text")
    }

    -- 技能
    local skill = self:FindChild(self._gameObject, "Skill")
    self.mSkill = {
        Root = skill,
        Effect = self:FindChild(skill, "Effect"),
        SkillType1 = self:FindChild(skill, "SkillType1"),
        SkillType2 = self:FindChild(skill, "SkillType2"),
        ImgIcon = self:FindChildComponent(skill, "ImgIcon", "Image"),
        LabName = self:FindChildComponent(skill, "LabName", "Text"),
        Lock = self:FindChild(skill, "Lock")
    }
    self:AddButtonClickListener(self.mSkill.ImgIcon:GetComponent("Button"), Util.bind(self.OnClickSkill, self))

    -- 刷新次数
    local btnRefresh = self:FindChild(self._gameObject, "BtnRefresh")
    self.mBtnRefresh = {
        Root = btnRefresh,
        Effect = self:FindChild(btnRefresh, "Effect"),
        LabTip = self:FindChildComponent(btnRefresh, "LabTip", "Text")
    }
    self:AddButtonClickListener(btnRefresh:GetComponent("Button"), Util.bind(self.OnClickRefresh, self))

    -- 跳过
    self.mBtnSkip = self:FindChild(self._gameObject, "BtnSkip")
    if self.mBtnSkip then
        self:AddButtonClickListener(self.mBtnSkip:GetComponent("Button"), Util.bind(self.OnClickSkip, self))
        self:HideSkip()
    end

    self:AddButtonClickListener(
        self:FindChildComponent(self._gameObject, "BtnBack", "Button"),
        Util.bind(self.OnClickBack, self)
    )
end

function PKSelectUI:OnEnable()
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RoundEnd, self.OnRoundEnd, self)

    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectRoleStart, self.OnSelectRoleStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectRoleRefresh, self.OnSelectRoleRefresh, self)

    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectEquipStart, self.OnSelectEquipStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectEquipRefresh, self.OnSelectEquipRefresh, self)

    -- 角色解锁信息异步的，需要监听刷新
    LuaEventDispatcher:addEventListener("UPDATE_CARDSUPGRADE_UI", self.OnRefreshUpgrade, self)
end

function PKSelectUI:OnDisable()
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RoundEnd, self.OnRoundEnd, self)

    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectRoleStart, self.OnSelectRoleStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectRoleRefresh, self.OnSelectRoleRefresh, self)

    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectEquipStart, self.OnSelectEquipStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectEquipRefresh, self.OnSelectEquipRefresh, self)

    LuaEventDispatcher:removeEventListener("UPDATE_CARDSUPGRADE_UI", self.OnRefreshUpgrade, self)
end

function PKSelectUI:RefreshUI()
    -- 刷新界面
    self:Reset()
end

-- 根据PKManager重置界面
function PKSelectUI:Reset()
    local playerData = PKManager:GetInstance():GetPlayerData()
    if playerData then
        local round = playerData["RoundID"]
        if (round or 0) == 0 then
            self:OnRoundEnd()
            return
        end

        local eventID = playerData["EventID"]

        if eventID == 2 then
            -- 2：选角色
            self:OnSelectRoleStart(playerData)
        elseif eventID == 3 then
            -- 3：选神器
            self:OnSelectEquipStart(playerData)
        else
            self:OnRoundEnd()
        end
    else
        self:OnRoundEnd()
    end
end

--region UI监听事件
function PKSelectUI:OnRoundEnd()
    self:OnClickBack()
end

function PKSelectUI:OnSelectRoleStart(data)
    self:OnSelectRoleRefresh(data)
end
function PKSelectUI:OnSelectRoleRefresh(data)
    self:ShowGroup(PKSelectUIType.SelectRole)
    local roleList = data ~= nil and data["SelectRoleList"] or nil
    if roleList then
        local playerData = PKManager:GetInstance():GetPlayerData()
        local idToCard = playerData["IDToCard"] or {}

        -- 冒泡数据
        local config = GetTableData("PKConfig", 1) or {}
        local dialogMaxNum = config["DialogMaxNum"] or 0
        local dialogRate = config["DialogRate"] or 0

        local dialogList = {}
        for index, role in pairs(roleList) do
            if role and role["dwBaseId"] > 0 then
                local baseID = role["dwBaseId"]
                local pkRole = GetTableData("PKRole", baseID) or {}
                if (pkRole["DialogID"] or 0) > 0 then
                    table.insert(dialogList, baseID)
                end
            end
        end

        local showDialogList = {}
        local dialogNum = #dialogList
        for i = 1, dialogNum do
            if #showDialogList >= dialogMaxNum then
                break
            end

            local randIdx = math.random(1, #dialogList)
            local dialog = dialogList[randIdx]
            table.remove(dialogList, randIdx)

            if math.random(1, 100) <= dialogRate then
                table.insert(showDialogList, dialog)
            end
        end

        -- 展示角色
        for index, roleBox in pairs(self.mSelectRoleGroup.RoleBoxList) do
            index = index - 1
            local role = roleList[index]
            if role and role["dwBaseId"] > 0 then
                local baseID = role["dwBaseId"]

                local dialogID = nil
                if table.indexof(showDialogList, baseID) ~= false then
                    local pkRole = GetTableData("PKRole", baseID) or {}
                    dialogID = pkRole["DialogID"] or nil
                end

                roleBox:SetActive(true)
                roleBox:Refresh(baseID, math.max(role["dwLv"], 1), index, dialogID)
            else
                roleBox:SetActive(false)
            end
        end
    end

    -- 选择角色（硬编码）
    -- 服务器或者TableTool最好能加枚举
    local lastTimes = PKManager:GetInstance():GetLastSelectTimes(2)
    self.mSelectRoleGroup.LabRefreshTip.text = string.format("选择角色次数：%d", lastTimes)
end

function PKSelectUI:OnSelectEquipStart(data)
    self:OnSelectEquipRefresh(data)
end

function PKSelectUI:OnSelectEquipRefresh(data)
    self:ShowGroup(PKSelectUIType.SelectEquip)
    local equipList = data ~= nil and data["SelectEquipList"] or nil
    if equipList then
        -- 展示装备
        for index, equipBox in pairs(self.mSelectEquipGroup.EquipBoxList) do
            index = index - 1
            local equipID = equipList[index]
            if equipID and equipID > 0 then
                equipBox:SetActive(true)
                equipBox:Refresh(equipID, index)
            else
                equipBox:SetActive(false)
            end
        end
    end

    -- 选择角色（硬编码）
    -- 服务器或者TableTool最好能加枚举
    local lastTimes = PKManager:GetInstance():GetLastSelectTimes(3)
    self.mSelectEquipGroup.LabRefreshTip.text = string.format("选择神器次数：%d", lastTimes)
end

function PKSelectUI:OnRefreshUpgrade()
    if self.mSelectRoleGroup.Root.activeSelf then
        local playerData = PKManager:GetInstance():GetPlayerData() or {}
        self:OnSelectRoleRefresh(playerData)
    end
end
--endregion

--region 按钮事件
function PKSelectUI:OnClickBack()
    RemoveWindowImmediately("PKSelectUI")
end

-- 刷新
function PKSelectUI:OnClickRefresh()
    if self.mSelectRoleGroup.Root.activeSelf then
        -- 刷新角色
        PKManager:GetInstance():RequestRefreshRole()
    elseif self.mSelectEquipGroup.Root.activeSelf then
        -- 刷新神器
        PKManager:GetInstance():RequestRefreshEquip()
    end
end

function PKSelectUI:OnClickSkill()
    local playerData = PKManager:GetInstance():GetPlayerData() or {}
    local clanID = playerData["ClanID"] or 0
    if clanID > 0 then
        local pkClan = GetTableData("PKClan", clanID) or {}
        local desc = GetLanguageByID(pkClan["SkillDesID"]) or ""
        desc = desc == "" and "技能描述" or desc
        local name = GetLanguageByID(pkClan["SkillNameID"]) or ""
        name = name == "" and "技能名称" or name

        local param = {
            ["kind"] = "normal",
            ["title"] = name,
            ["titlecolor"] = DRCSRef.Color.white,
            ["content"] = desc
        }

        local canUse = false

        local skillProcess = pkClan["SkillProcess"] or {}
        -- 被动技能显示奥义
        if #skillProcess == 1 and skillProcess[1] == 0 then
            -- 非被动技能，可使用阶段显示奥义
            canUse = false
        else
            canUse = self.mSkill.Effect.activeSelf
        end

        if canUse then
            param["buttons"] = {
                {
                    ["name"] = "使用",
                    ["func"] = function()
                        -- 六扇门盘查特殊处理
                        if clanID == 63 then
                            OpenWindowImmediately(
                                "PKRoleUI",
                                {
                                    Tip = "请选择盘查的角色，该角色下一轮战斗中无法上场",
                                    OnClickRole = function(baseID, roleID)
                                        local name = RoleDataManager:GetInstance():GetRoleName(roleID, true)

                                        OpenWindowImmediately(
                                            "GeneralBoxUI",
                                            {
                                                GeneralBoxType.COMMON_TIP,
                                                string.format("确定选择%s，所有玩家的%s下一轮战斗无法上场？", name, name),
                                                function()
                                                    RemoveWindowImmediately("PKRoleUI")
                                                    PKManager:GetInstance():RequestUseSkill(baseID)
                                                end
                                            }
                                        )
                                    end
                                }
                            )
                        else
                            PKManager:GetInstance():RequestUseSkill()
                        end
                    end
                }
            }
        end

        OpenWindowImmediately("TipsPopUI", param)
    end
end

function PKSelectUI:OnClickRole(index)
    local roleList = PKManager:GetInstance():GetRoleList() or {}
    local playerData = PKManager:GetInstance():GetPlayerData() or {}
    local idToCard = playerData["IDToCard"] or {}

    local uiID = (idToCard[roleList[index - 1]] or {})["dwId"]
    if uiID then
        OpenWindowImmediately("CharacterUI", nil, true)
        local wnd = GetUIWindow("CharacterUI")
        if wnd then
            wnd:SetIndex(1)

            wnd.TeamListUICom:SetSelectRoleID(uiID)
            wnd.TeamListUICom:RefreshUI()
        end
    end
end

function PKSelectUI:OnClickSkip()
    PKManager:GetInstance():RequestSkip()
end
--endregion

--region 界面通用接口
function PKSelectUI:ShowGroup(type)
    self.mSelectRoleGroup.Root:SetActive(type == PKSelectUIType.SelectRole)
    self.mSelectEquipGroup.Root:SetActive(type == PKSelectUIType.SelectEquip)

    self:RefreshSkill()
    self:RefreshTimes()

    if type == PKSelectUIType.SelectRole then
        self:ShowSkip()
    else
        self:HideSkip()
    end
end

function PKSelectUI:RefreshSkill()
    local playerData = PKManager:GetInstance():GetPlayerData() or {}
    local clanID = playerData["ClanID"] or 0

    if self.mClanID ~= clanID then
        if clanID > 0 then
            local pkClan = GetTableData("PKClan", clanID) or {}
            self:SetSpriteAsync(pkClan["SkillIcon"], self.mSkill.ImgIcon)
            self.mSkill.LabName.text = GetLanguageByID(pkClan["SkillNameID"]) or ""
            self.mSkill.Root:SetActive(true)
        else
            self.mSkill.Root:SetActive(false)
        end
    end

    local effect = false
    local canUse = false

    if clanID > 0 then
        local pkClan = GetTableData("PKClan", clanID) or {}

        local skillProcess = pkClan["SkillProcess"] or {}
        local notActive = #skillProcess == 1 and skillProcess[1] == 0
        -- 被动技能不显示奥义
        if notActive then
            effect = false
            canUse = true
        else
            canUse = (playerData["SkillUseTimes"] or 0) < (pkClan["SkillTimes"] or 0)

            local eventID = playerData["EventID"] or 0
            if eventID == 2 then
                -- 选卡
                effect = skillProcess[2] == 1 and canUse
            elseif eventID == 3 then
                -- 选装备
                effect = skillProcess[3] == 1 and canUse
            else
                -- 等待
                effect = skillProcess[1] == 1 and canUse
            end
        end

        self.mSkill.SkillType1:SetActive(not notActive)
        self.mSkill.SkillType2:SetActive(notActive)
    end

    self.mSkill.Effect:SetActive(effect)
    self.mSkill.Lock:SetActive(not canUse)
end

function PKSelectUI:RefreshTimes()
    self.mBtnRefresh.Root:SetActive(true)

    local playerData = PKManager:GetInstance():GetPlayerData() or {}
    local refrehsTimes = (playerData["RefreshTimes"] or 0)
    self.mBtnRefresh.LabTip.text = string.format("刷新次数:%d", (playerData["RefreshTimes"] or 0))
    self.mBtnRefresh.Effect:SetActive(true)
end

function PKSelectUI:ShowSkip()
    if self.mBtnSkip then
        self.mBtnSkip:SetActive(PKManager:GetInstance():CanShowSkip())
    end
end

function PKSelectUI:HideSkip()
    if self.mBtnSkip then
        self.mBtnSkip:SetActive(false)
    end
end
--endregion

return PKSelectUI
