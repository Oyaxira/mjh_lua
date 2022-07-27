PKRoleUI = class("PKRoleUI", BaseWindow)

local Util = require("xlua/util")

local InTeamWeightPro = 10

-- 掌门对决可出战角色列表
function PKRoleUI:ctor()
    local obj = LoadPrefabAndInit("PKUI/PKRoleUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function PKRoleUI:Create()
    self.mRoleBoxList = {}

    self.mRoleRoot = self:FindChild(self._gameObject, "ScrollRole/Viewport/Content")
    self.mScrollRole = self:FindChildComponent(self._gameObject, "ScrollRole", "ScrollRect")
    for index = 1, 32 do
        local root = self:FindChild(self.mRoleRoot, "RoleBox" .. index)
        self.mRoleBoxList[index] = {
            Root = root,
            LabName = self:FindChildComponent(root, "LabName", "Text"),
            ImgHead = self:FindChildComponent(root, "ImgHead", "Image"),
            ImgRank = self:FindChildComponent(root, "ImgRank", "Image"),
            WeightPro = self:FindChild(root, "WeightPro"),
            LabWeightPro = self:FindChildComponent(root, "WeightPro/LabWeightPro", "Text"),
            LabNum = self:FindChildComponent(root, "LabNum", "Text")
        }

        self:AddButtonClickListener(
            root:GetComponent("Button"),
            function()
                self:OnClickRole(index)
            end
        )
    end

    self.mLabTip = self:FindChildComponent(self._gameObject, "LabTip", "Text")

    self:AddButtonClickListener(
        self:FindChildComponent(self._gameObject, "BtnClose", "Button"),
        function()
            self:OnClickClose()
        end
    )

    -- 概率描述
    local rateDesc = self:FindChild(self._gameObject, "RateDesc")
    self.mRateDesc = {
        Root = rateDesc,
        Show = {
            Root = self:FindChild(rateDesc, "Show"),
            LabDesc = self:FindChildComponent(rateDesc, "Show/LabDesc", "Text"),
            BtnHide = self:FindChild(rateDesc, "Show/BtnHide")
        },
        BtnShow = self:FindChild(rateDesc, "BtnShow")
    }
    self:AddButtonClickListener(
        self.mRateDesc.Show.BtnHide:GetComponent("Button"),
        Util.bind(self.OnClickHideRateDesc, self)
    )
    self:AddButtonClickListener(
        self.mRateDesc.BtnShow:GetComponent("Button"),
        Util.bind(self.OnClickShowRateDesc, self)
    )

    -- 默认显示
    self:OnClickShowRateDesc()
end

function PKRoleUI:Init()
    LuaEventDispatcher:addEventListener(PKManager.UI_EVENT.RefreshRoleNum, self.OnRefreshRoleNum, self)
end

function PKRoleUI:OnDestroy()
    LuaEventDispatcher:removeEventListener(PKManager.UI_EVENT.RefreshRoleNum, self.OnRefreshRoleNum, self)
end

function PKRoleUI:RefreshUI(info)
    info = info or {}
    self.mOnClickRole = info.OnClickRole

    for index, roleBox in pairs(self.mRoleBoxList) do
        roleBox.LabName.text = ""
        roleBox.ImgHead.sprite = nil
    end

    local roomData = PKManager:GetInstance():GetRoomData() or {}
    local roleList = roomData["AllRoleList"] or {}
    local idToNum = roomData["IDToNum"] or {}

    local playerData = PKManager:GetInstance():GetPlayerData()

    -- 掌门权重加成
    local idToClanPro = {}
    local clanID = playerData["ClanID"]
    local tableClan = GetTableData("PKClan", clanID) or {}
    local effectRoleList = tableClan["EffectRoleList"] or {}
    local weightProList = tableClan["WeightProList"] or {}
    for index, effectRole in pairs(effectRoleList) do
        idToClanPro[effectRole] = (idToClanPro[effectRole] or 0) + (weightProList[index] or 0)
    end

    -- 队伍权重加成（硬编码）
    local idToTeamPro = {}
    local idToCard = playerData["IDToCard"] or {}
    for id, card in pairs(idToCard) do
        local baseID = card["dwBaseId"]
        if idToTeamPro[baseID] == nil then
            idToTeamPro[baseID] = InTeamWeightPro
        end
    end

    for index, roleBox in pairs(self.mRoleBoxList) do
        local baseID = roleList[index] or 0
        local num = idToNum[baseID] or 0

        local pkRole = GetTableData("PKRole", baseID) or {}
        local roleID = pkRole.RoleID
        local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleID)
        local roleArtData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleID, true)

        if roleData and roleArtData then
            roleBox.LabName.text =
                getRankBasedText(roleData.Rank, RoleDataManager:GetInstance():GetRoleName(roleID, true))
            self:SetSpriteAsync(roleArtData.Head, roleBox.ImgHead)
        end

        local pro = (idToClanPro[baseID] or 0) + (idToTeamPro[baseID] or 0)
        roleBox.WeightPro:SetActive(pro > 0)
        roleBox.LabWeightPro.text = "出现率+" .. pro .. "%"

        roleBox.LabNum.text = num .. "/" .. (pkRole["RoleNum32"] or 0)
    end

    -- 滚动置顶
    self.mRoleRoot.transform.localPosition = DRCSRef.Vec3Zero

    self.mLabTip.text = info.Tip or "本局游戏中的角色，将会从以上32名角色中随机选出"

    self:RefreshRateDesc()
end

function PKRoleUI:OnRefreshRoleNum()
    local roomData = PKManager:GetInstance():GetRoomData() or {}
    local roleList = roomData["AllRoleList"] or {}
    local idToNum = roomData["IDToNum"] or {}

    for index, roleBox in pairs(self.mRoleBoxList) do
        local baseID = roleList[index] or 0
        local num = idToNum[baseID] or 0
        local pkRole = GetTableData("PKRole", baseID) or {}
        roleBox.LabNum.text = num .. "/" .. (pkRole["RoleNum32"] or 0)
    end
end

function PKRoleUI:OnEnable()
end

function PKRoleUI:OnDisable()
end

function PKRoleUI:OnClickClose()
    RemoveWindowImmediately("PKRoleUI")
end

function PKRoleUI:OnClickRole(index)
    local roomData = PKManager:GetInstance():GetRoomData() or {}
    local roleList = roomData["AllRoleList"] or {}
    local baseID = roleList[index] or 0
    local roleID = (GetTableData("PKRole", baseID) or {}).RoleID
    if roleID then
        if self.mOnClickRole then
            self.mOnClickRole(baseID, roleID)
        else
            CardsUpgradeDataManager:GetInstance():DisplayRoleCardInfoObserve(roleID)
        end
    end
end

function PKRoleUI:OnClickHideRateDesc()
    self.mRateDesc.Show.Root:SetActive(false)
    self.mRateDesc.BtnShow:SetActive(true)
end

function PKRoleUI:OnClickShowRateDesc()
    self.mRateDesc.Show.Root:SetActive(true)
    self.mRateDesc.BtnShow:SetActive(false)
end

function PKRoleUI:HideRateDesc()
    if self.mRateDesc then
        self.mRateDesc.Root:SetActive(false)
    end
end

function PKRoleUI:RefreshRateDesc()
    if self.mRateDesc then
        self.mRateDesc.Root:SetActive(true)
        local roomData = PKManager:GetInstance():GetRoomData() or {}
        local round = math.max(roomData["RoundID"] or 0, 1)
        local pkProcess = GetTableData("PKProcess", round) or {}
        self.mRateDesc.Show.LabDesc.text = GetLanguageByID(pkProcess["RateDescID"] or 0) or ""
    end
end

return PKRoleUI
