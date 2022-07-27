PKUI = class("PKUI", BaseWindow)

local Util = require("xlua/util")
local PKClanBox = require("UI/PKUI/PKClanBox")
local PKRoleBox = require("UI/PKUI/PKRoleBox")
local PKEquipBox = require("UI/PKUI/PKEquipBox")

local PKUIType = {
    None = 0,
    Prepare = 1,
    Wait = 3,
    SelectClan = 4,
    SelectRole = 5,
    SelectEquip = 6
}

function PKUI:ctor()
    local obj = LoadPrefabAndInit("PKUI/PKUI", Scence_Layer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function PKUI:Create()
    -- 准备界面
    local prepareGroup = self:FindChild(self._gameObject, "PrepareGroup")
    self:AddButtonClickListener(
        self:FindChildComponent(prepareGroup, "BtnNPC", "Button"),
        Util.bind(self.OnClickNPC, self)
    )

    local npcRole = CityRoleUI.new()
    local roleObj = self:FindChild(prepareGroup, "CityRoleUI")
    npcRole:SetGameObject(roleObj)
    npcRole:SetSpine(self:FindChild(roleObj, "Spine"), false)
    npcRole:SetDefaultScale(MAZE_SPINE_SCALE)
    local config = GetTableData("PKConfig", 1) or {}
    npcRole:SetRoleDataByUID(config["NPCID"] or 0)
    npcRole:UpdateCityRole()

    self.mPrepareGroup = {
        Root = prepareGroup
    }

    -- 等待界面
    local waitGroup = self:FindChild(self._gameObject, "WaitGroup")
    local role = self:FindChild(waitGroup, "Role")

    local roleBoxList = {}
    BoxHelper.ForeachNode(
        role,
        "Role%d",
        function(index, root)
            local cityRole = CityRoleUI.new()
            local roleObj = self:FindChild(root, "CityRoleUI")
            cityRole:SetGameObject(roleObj)
            cityRole:SetSpine(self:FindChild(roleObj, "Spine"), false)
            cityRole:SetDefaultScale(MAZE_SPINE_SCALE)

            self:AddButtonClickListener(
                root:GetComponent("Button"),
                function()
                    self:OnClickRole(index)
                end
            )

            roleBoxList[index] = {
                Root = root,
                Role = cityRole
            }
        end
    )

    self.mWaitGroup = {
        Root = waitGroup,
        LabBattleNum = self:FindChildComponent(waitGroup, "BG/LabBattleNum", "Text"),
        RoleBoxList = roleBoxList
    }

    -- 选择门派界面
    local index = 1
    local selctClanGroup = self:FindChild(self._gameObject, "SelectClanGroup")
    local clan = self:FindChild(selctClanGroup, "Clan")
    self.mSelectClanGroup = {
        Root = selctClanGroup,
        ClanBoxList = self:BuildBoxList(PKClanBox, clan, "Clan%d")
    }

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

    -- 掌门币
    local zmGold = self:FindChild(self._gameObject, "ZmGold")
    self.mZmGold = {
        Root = zmGold,
        LabName = self:FindChildComponent(zmGold, "LabName", "Text")
    }
    self:AddButtonClickListener(
        self:FindChildComponent(self.mZmGold.Root, "ImgBG", "Button"),
        Util.bind(self.OnClickZmGold, self)
    )

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
end

function PKUI:Init()
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.Ready, self.OnReady, self)

    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.Start, self.OnStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.End, self.OnEnd, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RoundStart, self.OnRoundStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RoundEnd, self.OnRoundEnd, self)

    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectClanStart, self.OnSelectClanStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectClanRefresh, self.OnSelectClanRefresh, self)

    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectRoleStart, self.OnSelectRoleStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectRoleRefresh, self.OnSelectRoleRefresh, self)

    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectEquipStart, self.OnSelectEquipStart, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectEquipRefresh, self.OnSelectEquipRefresh, self)

    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.SelectEnd, self.OnSelectEnd, self)
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RefreshBattleRole, self.OnRefreshBattleRole, self)

    -- 角色解锁信息异步的，需要监听刷新
    LuaEventDispatcher:addEventListener("UPDATE_CARDSUPGRADE_UI", self.OnRefreshUpgrade, self)
end

function PKUI:OnDestroy()
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.Ready, self.OnReady, self)

    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.Start, self.OnStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.End, self.OnEnd, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RoundStart, self.OnRoundStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RoundEnd, self.OnRoundEnd, self)

    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectClanStart, self.OnSelectClanStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectClanRefresh, self.OnSelectClanRefresh, self)

    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectRoleStart, self.OnSelectRoleStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectRoleRefresh, self.OnSelectRoleRefresh, self)

    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectEquipStart, self.OnSelectEquipStart, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectEquipRefresh, self.OnSelectEquipRefresh, self)

    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.SelectEnd, self.OnSelectEnd, self)
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RefreshBattleRole, self.OnRefreshBattleRole, self)

    LuaEventDispatcher:removeEventListener("UPDATE_CARDSUPGRADE_UI", self.OnRefreshUpgrade, self)
end

function PKUI:RefreshUI()
end

function PKUI:OnEnable()
    if not LogicMain:GetInstance():IsReplaying() then
        PlayMusic(BGMID_ZM)
    end

    OpenWindowImmediately("NavigationUI", {bInZm = true})

    -- 显示奖励弹窗
    PKManager:GetInstance():ShowAward()
    -- 显示Roll弹窗
    PKManager:GetInstance():ShowRoll()

    -- 刷新界面
    self:Reset()

    LuaEventDispatcher:dispatchEvent(PKManager.UI_EVENT.PreSelect, false)
end

function PKUI:OnDisable()
    RemoveWindowImmediately("NavigationUI")
end

function PKUI:Update()
    PKManager:GetInstance():Update()
end

-- 根据PKManager重置界面
function PKUI:Reset()
    -- 比赛结束，如果已经结束，则返回
    if PKManager:GetInstance():ShowEndUI() then
        return
    end

    local playerData = PKManager:GetInstance():GetPlayerData()
    if playerData then
        local round = playerData["RoundID"]
        if round == nil then
            self:OnReady()
            return
        end

        self:ShowWait()

        if round == 0 then
            return
        end

        local eventID = playerData["EventID"]

        if eventID == 1 then
            -- 1：选掌门
            self:OnSelectClanStart(playerData)
        elseif eventID == 2 then
            -- 2：选角色
            self:OnSelectRoleStart(playerData)
        elseif eventID == 3 then
            -- 3：选神器
            self:OnSelectEquipStart(playerData)
        end
    else
        self:OnReady()
    end
end

--region UI监听事件
function PKUI:OnReady()
    self:ShowGroup(PKUIType.Prepare)

    RemoveWindowImmediately("PKTipUI")
end

function PKUI:OnStart()
    self:ShowWait()
end

function PKUI:OnEnd()
end

function PKUI:OnRoundStart()
end

function PKUI:OnRoundEnd()
    self:ShowWait()
end

function PKUI:OnSelectClanStart(data)
    self:OnSelectClanRefresh(data)

    OpenWindowImmediately("PKTipUI")

    -- 引导
    GuideDataManager:GetInstance():StartGuideByID(54)
end
function PKUI:OnSelectClanRefresh(data)
    self:ShowGroup(PKUIType.SelectClan)
    local clanList = data ~= nil and data["SelectClanList"] or {}
    -- 展示掌门
    for index, clanBox in pairs(self.mSelectClanGroup.ClanBoxList) do
        index = index - 1
        local clanID = clanList[index]
        if clanID and clanID > 0 then
            clanBox:SetActive(true)
            clanBox:Refresh(clanID, index)
        else
            clanBox:SetActive(false)
        end
    end
end

function PKUI:OnSelectRoleStart(data)
    self:OnSelectRoleRefresh(data)

    OpenWindowImmediately("PKTipUI")

    -- 引导
    GuideDataManager:GetInstance():StartGuideByID(55)
end
function PKUI:OnSelectRoleRefresh(data)
    self:ShowGroup(PKUIType.SelectRole)
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

function PKUI:OnSelectEquipStart(data)
    self:OnSelectEquipRefresh(data)

    OpenWindowImmediately("PKTipUI")
end

function PKUI:OnSelectEquipRefresh(data)
    self:ShowGroup(PKUIType.SelectEquip)
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

function PKUI:OnSelectEnd()
    self:ShowWait()
end

function PKUI:OnRefreshBattleRole()
    if self.mPrepareGroup.Root.activeSelf then
        self:Reset()
    elseif self.mWaitGroup.Root.activeSelf then
        self:RefreshRoleEx()
    end
end

function PKUI:OnRefreshUpgrade()
    if self.mSelectRoleGroup.Root.activeSelf then
        local playerData = PKManager:GetInstance():GetPlayerData() or {}
        self:OnSelectRoleRefresh(playerData)
    end
end
--endregion

--region 按钮事件
-- 点击NPC
function PKUI:OnClickNPC()
    self:ShowNPCDialog()
end

-- 刷新
function PKUI:OnClickRefresh()
    if self.mSelectClanGroup.Root.activeSelf then
        -- 刷新掌门
        PKManager:GetInstance():RequestRefreshClan()
    elseif self.mSelectRoleGroup.Root.activeSelf then
        -- 刷新角色
        PKManager:GetInstance():RequestRefreshRole()
    elseif self.mSelectEquipGroup.Root.activeSelf then
        -- 刷新神器
        PKManager:GetInstance():RequestRefreshEquip()
    end
end

function PKUI:OnClickZmGold()
    OpenWindowImmediately(
        "TipsPopUI",
        {
            ["kind"] = "normal",
            ["title"] = "掌门币",
            ["titlecolor"] = DRCSRef.Color.white,
            ["content"] = "参加掌门对决活动，名次越高获得掌门币越多，可用于兑换角色卡"
        }
    )
end

function PKUI:OnClickSkill()
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

function PKUI:OnClickRole(index)
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

function PKUI:OnClickSkip()
    PKManager:GetInstance():RequestSkip()
end
--endregion

--region 界面通用接口
function PKUI:ShowGroup(pkUIType)
    self.mPrepareGroup.Root:SetActive(pkUIType == PKUIType.Prepare)
    self.mWaitGroup.Root:SetActive(pkUIType == PKUIType.Wait)
    self.mSelectClanGroup.Root:SetActive(pkUIType == PKUIType.SelectClan)
    self.mSelectRoleGroup.Root:SetActive(pkUIType == PKUIType.SelectRole)
    self.mSelectEquipGroup.Root:SetActive(pkUIType == PKUIType.SelectEquip)

    if pkUIType == PKUIType.Prepare then
        self:HideRefresh()
        self:HideSkill()
        self:HideZmGold()
    else
        self:RefreshSkill()
        self:RefreshTimes()
        self:RefreshZmGold()
    end

    if pkUIType == PKUIType.SelectRole then
        self:ShowSkip()
    else
        self:HideSkip()
    end

    self:RefreshNaviUI()
end

function PKUI:ShowWait()
    self:ShowGroup(PKUIType.Wait)

    self:OnRefreshBattleRole()

    OpenWindowImmediately("PKTipUI")
end

function PKUI:RefreshRoleEx()
    local roleList = PKManager:GetInstance():GetRoleList() or {}
    local playerData = PKManager:GetInstance():GetPlayerData()
    local idToCard = playerData["IDToCard"] or {}

    -- 展示角色
    local battleNum = 0
    for index, roleBox in pairs(self.mWaitGroup.RoleBoxList) do
        index = index - 1
        local roleData = idToCard[roleList[index]] or {}
        local uiID = roleData["dwId"]

        local baseID = roleData["dwBaseId"] or 0
        local mixLevel = roleData["dwLv"] or 0
        local pkRoleMain = GetTableData("PKRoleMain", (baseID << 0 | mixLevel << 16)) or {}
        local grade = pkRoleMain["Grade"] or 0

        roleBox.Root:SetActive(false)

        if uiID then
            battleNum = battleNum + 1

            roleBox.Role:SetRoleDataByUID(uiID)
            roleBox.Role:UpdateCityRole()
            roleBox.Role:UpdateRoleGrade(grade)
            roleBox.Role:HideTeamMark()

            PKManager:GetInstance():SetIdleAction(roleBox.Role, baseID, mixLevel)

            roleBox.Root:SetActive(true)
        end
    end

    local maxBattleNum = playerData["LimitRoleNum"] or 0
    self.mWaitGroup.LabBattleNum.text = "上阵角色(" .. tostring(battleNum) .. "/" .. tostring(maxBattleNum) .. ")"
end

function PKUI:HideSkill()
    self.mSkill.Root:SetActive(false)
end

function PKUI:RefreshSkill()
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

function PKUI:RefreshZmGold()
    self.mZmGold.Root:SetActive(true)

    local playerData = PKManager:GetInstance():GetPlayerData() or {}
    self.mZmGold.LabName.text = string.format("掌门币:%d", (playerData["ZmGold"] or 0))
end

function PKUI:HideZmGold()
    self.mZmGold.Root:SetActive(false)
end

function PKUI:RefreshTimes()
    self.mBtnRefresh.Root:SetActive(true)

    local playerData = PKManager:GetInstance():GetPlayerData() or {}
    local refrehsTimes = (playerData["RefreshTimes"] or 0)
    self.mBtnRefresh.LabTip.text = string.format("刷新次数:%d", (playerData["RefreshTimes"] or 0))

    local effect = true
    if self.mWaitGroup.Root.activeSelf then
        effect = false
    elseif refrehsTimes == 0 then
        effect = false
    end

    self.mBtnRefresh.Effect:SetActive(effect)
end

function PKUI:HideRefresh()
    self.mBtnRefresh.Root:SetActive(false)
end

function PKUI:ShowSkip()
    if self.mBtnSkip then
        self.mBtnSkip:SetActive(PKManager:GetInstance():CanShowSkip())
    end
end

function PKUI:HideSkip()
    if self.mBtnSkip then
        self.mBtnSkip:SetActive(false)
    end
end
--endregion

function PKUI:RefreshNaviUI()
    local wnd = GetUIWindow("NavigationUI")
    if wnd and wnd:IsOpen() then
        local playerData = PKManager:GetInstance():GetPlayerData() or {}
        local round = playerData["RoundID"]

        if PKManager:GetInstance():IsEnd() then
            round = nil
        end

        wnd:RefreshButtonZm(round)
    end
end

-- 目前就PKUI用到这个接口，如果有其他接口用到，则放到PKManager
function PKUI:ShowStartMatch()
    local config = GetTableData("PKConfig", 1) or {}
    local openTime = config["OpenTime"] or {}
    local startTime = openTime[1] or 0
    local endTime = openTime[2] or 0

    local hour = tonumber(os.date("%H")) or 0

    if
        (startTime ~= endTime) and
            ((startTime > endTime and (not (hour >= startTime or hour < endTime))) or
                (startTime < endTime and (not (hour >= startTime and hour < endTime))))
     then
        SystemUICall:GetInstance():Toast("当前不在匹配时间内", false)
        return
    end

    local forbidTicket = config["ForbidTicket"] == 1

    local freeTicket = PlayerSetDataManager:GetInstance():GetZmFreeTicket()
    local ticket = PlayerSetDataManager:GetInstance():GetZmTicket()

    if freeTicket + ticket <= 0 then
        if forbidTicket then
            SystemUICall:GetInstance():Toast("没有门票", false)
            return
        end
        local cost = config["TicketCost"] or 0
        OpenWindowImmediately(
            "GeneralBoxUI",
            {
                GeneralBoxType.COMMON_TIP,
                string.format("是否花费%d银锭购买门票?", cost),
                function()
                    PlayerSetDataManager:GetInstance():RequestSpendSilver(
                        cost,
                        function()
                            PKManager:GetInstance():RequestStartMatch()
                        end
                    )
                end
            }
        )
        return
    end

    PKManager:GetInstance():RequestStartMatch()
end

function PKUI:ShowNPCDialog()
    local config = GetTableData("PKConfig", 1) or {}
    local forbidTicket = config["ForbidTicket"] == 1

    local freeTicket = PlayerSetDataManager:GetInstance():GetZmFreeTicket()
    local ticket = PlayerSetDataManager:GetInstance():GetZmTicket()
    -- TODO: 对话待定义
    -- local des = GetLanguageByID(config["NPCDesID"] or 0)
    local des = string.format("拥有免费门票：%d张, 普通门票：%d张。", freeTicket, ticket)

    if forbidTicket then
        des = des .. string.format("\n每日免费补足到%d张门票，限量测试期间，不额外售卖门票。", config["FreeTickets"] or 0)
    else
        des =
            des ..
            string.format(
                "\n每日免费补足到%d张门票，普通门票售价%d银锭。\n商城擂台分页可以1350擂台币兑换普通门票。",
                config["FreeTickets"] or 0,
                config["TicketCost"] or 0
            )
    end
    local npcID = config["NPCID"] or 0

    local choicelist = {}
    choicelist[#choicelist + 1] = {
        func = function()
            local forbidSelectLock = config["ForbidSelectLock"] == 1

            if forbidSelectLock then
                local unlockNum = CardsUpgradeDataManager:GetInstance():GetRoleCardUnLockNum()
                local minUnlockNum = config["MinUnlockNum"] or 30
                local forbidMinUnlockNum = config["ForbidMinUnlockNum"] or 10
                if unlockNum < forbidMinUnlockNum then
                    OpenWindowImmediately(
                        "GeneralBoxUI",
                        {
                            GeneralBoxType.COMMON_TIP,
                            string.format("你在收藏-角色系统中已解锁的角色少于%d个，会大幅影响本玩法的游戏体验，请至少解锁10个角色。", forbidMinUnlockNum),
                            nil,
                            {
                                ["confirm"] = true,
                                ["cancel"] = false
                            }
                        }
                    )
                    return
                end

                if unlockNum < minUnlockNum then
                    OpenWindowImmediately(
                        "GeneralBoxUI",
                        {
                            GeneralBoxType.COMMON_TIP,
                            string.format("你在收藏-角色系统中已解锁的角色少于%d个，本玩法中无法邀请未解锁的角色入队，是否继续匹配？", minUnlockNum),
                            function()
                                self:ShowStartMatch()
                            end
                        }
                    )
                    return
                end
            end

            self:ShowStartMatch()

            ResetWaitDisplayMsgState()
            DisplayActionEnd()
        end,
        str = "开始匹配"
    }

    local ruleDesIDList = config["RuleDesID"]
    if ruleDesIDList and #ruleDesIDList > 0 then
        choicelist[#choicelist + 1] = {
            func = function()
                for _, ruleDesID in pairs(ruleDesIDList) do
                    DisplayActionManager:GetInstance():AddAction(
                        DisplayActionType.PLOT_DIALOGUE_STR,
                        false,
                        npcID,
                        GetLanguageByID(ruleDesID)
                    )
                end
                DisplayActionManager:GetInstance():AddAction(
                    DisplayActionType.PLOT_ROLE_CHOICE,
                    false,
                    npcID,
                    des,
                    choicelist
                )
                DisplayActionManager:GetInstance():RunNextAction()
            end,
            str = GetLanguageByID(config["RuleTitleID"] or 0)
        }
    end

    local updateDesIDList = config["UpdateDesID"]
    if updateDesIDList and #updateDesIDList > 0 then
        choicelist[#choicelist + 1] = {
            func = function()
                for _, updateDesID in pairs(updateDesIDList) do
                    DisplayActionManager:GetInstance():AddAction(
                        DisplayActionType.PLOT_DIALOGUE_STR,
                        false,
                        npcID,
                        GetLanguageByID(updateDesID)
                    )
                end
                DisplayActionManager:GetInstance():AddAction(
                    DisplayActionType.PLOT_ROLE_CHOICE,
                    false,
                    npcID,
                    des,
                    choicelist
                )
                DisplayActionManager:GetInstance():RunNextAction()
            end,
            str = GetLanguageByID(config["UpdateTitleID"] or 0)
        }
    end

    -- TODO: 这版屏蔽新手引导
    -- if not PlayerSetDataManager:GetInstance():GetZmNewFlag() then
    --     choicelist[#choicelist + 1] = {
    --         func = function()
    --             PKManager:GetInstance():RequestStartGuide()
    --         end,
    --         str = "新手引导"
    --     }
    -- end

    choicelist[#choicelist + 1] = {
        func = function()
            ResetWaitDisplayMsgState()
            DisplayActionEnd()
            RemoveWindowImmediately("SelectUI")
        end,
        str = "离开"
    }

    PKManager:GetInstance():ShowDialog(npcID, des, choicelist)
end

return PKUI
