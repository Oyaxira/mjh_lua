ActivitySignUI = class("ActivitySignUI", BaseWindow)

local ActivityHelper = require("UI/Activity/ActivityHelper")
local ItemPool = require("UI/ItemUI/ItemPool")
local Util = require("xlua/util")

function ActivitySignUI:ctor()
end

function ActivitySignUI:Create()
    local obj = LoadPrefabAndInit("TownUI/ActivitySignUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end

    -- 建立物品的专属对象池
    self.mItemPool = ItemPool.new()
end

function ActivitySignUI:Init()
    self.mObjDayList = self:FindChild(self._gameObject, "DayList")
    self.mDayBoxList = {}
    for dayIndex = 1, 7 do
        local objDayBox = self:FindChild(self.mObjDayList, "DayBox" .. dayIndex)

        -- 获取每天奖励的组件
        self.mDayBoxList[dayIndex] = {
            Root = objDayBox,
            Rect = objDayBox:GetComponent("RectTransform"),
            ImgBG = self:FindChildComponent(objDayBox, "ImgBG", "Image"),
            RectImg = self:FindChildComponent(objDayBox, "ImgBG", "RectTransform"),
            LabDay = self:FindChildComponent(objDayBox, "LabDay", "Text"),
            PreGroup = {
                Root = self:FindChild(objDayBox, "PreGroup"),
                UnlockClan = self:FindChild(objDayBox, "PreGroup/Info/UnlockClan"),
                ImgIcon = self:FindChildComponent(objDayBox, "PreGroup/Info/Icon/ImgIcon", "Image"),
                LabDes = self:FindChildComponent(objDayBox, "PreGroup/Info/Des/LabDes", "Text")
            },
            ShowGroup = {
                Root = self:FindChild(objDayBox, "ShowGroup")
            },
            RewardGroup = {
                Root = self:FindChild(objDayBox, "RewardGroup"),
                ItemNode = self:FindChild(objDayBox, "RewardGroup/ItemNode"),
                Received = self:FindChild(objDayBox, "RewardGroup/Received")
            },
            BtnRecevie = self:FindChild(objDayBox, "BtnRecevie")
        }

        local dayBox = self.mDayBoxList[dayIndex]
        local itemListNode = self:FindChild(dayBox.ShowGroup.Root, "ItemList")
        dayBox.ShowGroup.ItemBoxList = {}
        for i = 1, 2 do
            dayBox.ShowGroup.ItemBoxList[i] = {
                Root = self:FindChild(itemListNode, string.format("Item%d", i)),
                LabDes = self:FindChildComponent(itemListNode, string.format("Item%d/Des/LabDes", i), "Text"),
                ItemNode = self:FindChild(itemListNode, string.format("Item%d/Icon/ItemNode", i)),
                Role = self:FindChild(itemListNode, string.format("Item%d/Icon/Role", i)),
                ImgHead = self:FindChildComponent(itemListNode, string.format("Item%d/Icon/Role/head", i), "Image"),
                ImgIcon = self:FindChildComponent(itemListNode, string.format("Item%d/Icon/ImgIcon", i), "Image")
            }
        end

        -- 注册点击事件
        -- TODO: 等ItemBox重构再改吧
        local itemBox = dayBox.ShowGroup.ItemBoxList[1]
        self:AddButtonClickListener(
            itemBox.Role:GetComponent("Button"),
            function()
                self:OnClickRole(dayIndex)
            end
        )
        self:AddButtonClickListener(
            itemBox.ImgIcon:GetComponent("Button"),
            function()
                self:OnClickIcon(dayIndex)
            end
        )

        -- 注册每天揭晓事件
        self:AddButtonClickListener(
            dayBox.BtnRecevie:GetComponent("Button"),
            function()
                self:OnClickRecevie(dayIndex)
            end
        )
    end

    -- 标题名称
    self.mLabTitle = self:FindChildComponent(self._gameObject, "PopUpWindow_4/Board/Bottom/Top/LabTitle", "Text")

    -- 礼包栏
    self.mMallTip = self:FindChild(self._gameObject, "MallTip")
    self.mLabMallTip = self:FindChildComponent(self.mMallTip, "LabTip", "Text")
    self:AddButtonClickListener(
        self:FindChildComponent(self.mMallTip, "BtnMall", "Button"),
        Util.bind(self.OnClickMall, self)
    )
    self.mLabMallName = self:FindChildComponent(self.mMallTip, "BtnMall/LabName", "Text")

    -- 揭晓提示
    self.mRecevieTip = self:FindChild(self._gameObject, "RecevieTip")

    -- 注册关闭事件
    self:AddButtonClickListener(
        self:FindChildComponent(self._gameObject, "BtnClose", "Button"),
        Util.bind(self.OnClickClose, self)
    )
end

function ActivitySignUI:OnEnable()
    if self.mRefreshTimer ~= nil then
        globalTimer:RemoveTimer(self.mRefreshTimer)
        self.mRefreshTimer = nil
    end

    -- 设立隔天计时器
    local nextDayDiffTime = ActivityHelper.GetNextDayDiffTime()
    dprint("[ActivitySignUI] => NextDayDiffTime: " .. nextDayDiffTime)
    self.mRefreshTimer = globalTimer:AddTimer(nextDayDiffTime * 1000, Util.bind(self.RefreshUI, self))
end

function ActivitySignUI:OnDisable()
    if self.mRefreshTimer ~= nil then
        globalTimer:RemoveTimer(self.mRefreshTimer)
        self.mRefreshTimer = nil
    end
end

function ActivitySignUI:RefreshUI()
    if not self.mDayBoxList then
        return
    end

    local signInfo = ActivityHelper.GetSignInfo()
    -- 轮次
    self.mSignID = signInfo.ID
    local tableActivitySign = TableDataManager:GetInstance():GetTableData("ActivitySign", self.mSignID) or {}

    -- 签到情况
    self.mSignReceive = signInfo.Receive
    -- 单天签到天数
    self.mSignDay = signInfo.Day

    self.mItemPool:Clear()
    -- 签到奖励对应的ID列表
    local rewardList = tableActivitySign.RewardList or {}
    self.mRewardList = rewardList
    local weekday = {"一", "二", "三", "四", "五", "六", "七"}
    for dayIndex, dayBox in pairs(self.mDayBoxList) do
        self:RefreshDay(dayIndex, dayBox, rewardList, weekday)
    end

    -- 显示礼包提示（（最后一天 and 已领取） or （大于最后一天））
    local lastSignDay = #rewardList
    self.mMallTip:SetActive((self.mSignDay == lastSignDay and self.mSignReceive[self.mSignDay]) or self.mSignDay == 0)
    if tableActivitySign.TipText and tableActivitySign.TipText ~= '' then
        self.mLabMallTip.text = tableActivitySign.TipText
        -- 只有当最后一天会显示提示
        self.mLabMallTip.gameObject:SetActive(signInfo.LastDay)
    end
    self.mMallList = tableActivitySign.MallList
    -- 显示揭晓提示
    self.mRecevieTip:SetActive(self.mMallTip.activeSelf == false and self.mSignReceive[self.mSignDay] == true)

    -- 标题自定义
    self.mLabTitle.text = "【" .. (tableActivitySign.TitleText or '') .. "】"

    -- 空礼包不显示礼包
    if self.mMallList == nil or #self.mMallList == 0 then
        self.mMallTip:SetActive(false)
    end

    -- 刷新按钮名称
    self.mLabMallName.text = tableActivitySign.GiftText or ''
end

-- 点击揭晓
function ActivitySignUI:OnClickRecevie(day)
    SendActivitySignCmd()
end

-- 点击关闭
function ActivitySignUI:OnClickClose()
    self.mItemPool:Clear()
    RemoveWindowImmediately("ActivitySignUI")
end

-- 点击礼包
function ActivitySignUI:OnClickMall()
    -- self:OnClickClose()
    OpenWindowImmediately(
        "ActivitySignMallUI",
        {
            Title = "【" .. self.mLabMallName.text .. "】",
            MallList = self.mMallList
        }
    )
end

-- 按天刷新
function ActivitySignUI:RefreshDay(dayIndex, dayBox, rewardList, weekday)
    local tableReward =
        TableDataManager:GetInstance():GetTableData("ActivitySignReward", tonumber(rewardList[dayIndex]))

    -- 是否领取
    local bRecevie = self.mSignReceive[dayIndex]
    -- 是否揭晓（到活动天数或者活动结束）
    local bShow = dayIndex < self.mSignDay or self.mSignDay == 0 or (dayIndex == self.mSignDay and bRecevie)

    if not tableReward then
        dayBox.Root:SetActive(false)
        return
    end

    dayBox.Root:SetActive(true)

    dayBox.PreGroup.Root:SetActive(not bShow)
    dayBox.ShowGroup.Root:SetActive(bShow)

    dayBox.BtnRecevie:SetActive(dayIndex == self.mSignDay and (not bRecevie))

    -- 天数序号
    dayBox.LabDay.text = string.format("第%s天", weekday[dayIndex])

    -- 预告背景图
    self:SetSpriteAsync(
        tableReward.ShowBG,
        dayBox.ImgBG,
        function()
            dayBox.ImgBG:SetNativeSize()
            dayBox.Rect.sizeDelta = dayBox.RectImg.sizeDelta
            -- 测试的时候发现window平台好像无法自适应，得强制刷新
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mObjDayList.transform)
        end
    )

    if bShow then
        local itemBoxList = dayBox.ShowGroup.ItemBoxList
        if tableReward.ShowRoleID > 0 then
            -- 展示角色
            itemBoxList[2].Root:SetActive(false)

            local roleID = tableReward.ShowRoleID
            local roleData = RoleDataManager:GetInstance():GetRoleTypeDataByTypeID(roleID)
            local roleArtData = RoleDataManager:GetInstance():GetRoleArtDataByTypeID(roleID, true)

            local itemBox = itemBoxList[1]
            itemBox.Root:SetActive(true)
            self:HideAllItemBox(itemBox)
            if roleData and roleArtData then
                itemBox.Role:SetActive(true)
                itemBox.LabDes.text = GetLanguageByID(roleData.NameID)
                self:SetSpriteAsync(roleArtData.Head, itemBox.ImgHead)
            end
        elseif tableReward.ShowItemList then
            -- 显示物品
            local itemList = tableReward.ShowItemList or {}

            for i = 1, 2 do
                local itemID = tonumber(itemList[i]) or 0
                local itemBox = itemBoxList[i]
                itemBox.Root:SetActive(itemID > 0)
                self:HideAllItemBox(itemBox)
                if itemID then
                    local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemID)
                    if itemData then
                        itemBox.ItemNode:SetActive(true)
                        self.mItemPool:Push(itemData, 1, itemBox.ItemNode)
                        itemBox.LabDes.text = itemData.ItemName or ''
                    end
                end
            end
        elseif tableReward.ShowIcon then
            -- 展示图标/描述
            itemBoxList[2].Root:SetActive(false)

            local itemBox = itemBoxList[1]
            itemBox.Root:SetActive(true)
            self:HideAllItemBox(itemBox)
            itemBox.ImgIcon.gameObject:SetActive(true)
            itemBox.LabDes.text = tableReward.ShowName or ""
            self:SetSpriteAsync(tableReward.ShowIcon, itemBox.ImgIcon)
        end

        -- 背景原色
        dayBox.ImgBG.material = nil
    else
        -- 是否解锁门派
        dayBox.PreGroup.UnlockClan:SetActive(tableReward.ClanID > 0)

        -- 预告图标/描述
        if dayBox.PreGroup.ImgIcon and dayBox.PreGroup.ImgIcon ~= "" then
            self:SetSpriteAsync(tableReward.PreIcon, dayBox.PreGroup.ImgIcon)
        end
        dayBox.PreGroup.LabDes.text = tableReward.PreDesText or ''

        -- 背景灰色
        dayBox.ImgBG.material = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
    end

    -- RewardGroup
    local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(tableReward.ItemID)
    if itemData then
        self.mItemPool:Push(itemData, tableReward.ItemNum, dayBox.RewardGroup.ItemNode)
    end
    -- 是否领取
    dayBox.RewardGroup.Received:SetActive(bRecevie)
end

function ActivitySignUI:OnClickRole(dayIndex)
    local tableReward =
        TableDataManager:GetInstance():GetTableData("ActivitySignReward", tonumber(self.mRewardList[dayIndex]))

    if tableReward and tableReward.ShowRoleID > 0 then
        CardsUpgradeDataManager:GetInstance():DisplayRoleCardInfoObserve(tableReward.ShowRoleID)
    end
end

function ActivitySignUI:OnClickIcon(dayIndex)
    local tableReward =
        TableDataManager:GetInstance():GetTableData("ActivitySignReward", tonumber(self.mRewardList[dayIndex]))

    if tableReward and tableReward.ShowIcon then
        OpenWindowImmediately(
            "TipsPopUI",
            {
                ["kind"] = "normal",
                ["title"] = tableReward.ShowName or '',
                ["titlecolor"] = DRCSRef.Color.white,
                ["content"] = tableReward.ShowDesText or ''
            }
        )
    end
end

function ActivitySignUI:HideAllItemBox(itemBox)
    itemBox.ItemNode:SetActive(false)
    itemBox.Role:SetActive(false)
    itemBox.ImgIcon.gameObject:SetActive(false)
end

return ActivitySignUI
