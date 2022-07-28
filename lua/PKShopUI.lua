PKShopUI = class("PKShopUI", BaseWindow)

local Util = require("xlua/util")
local BackpackUIComNew = require "UI/Role/BackpackNewUI"

function PKShopUI:Create()
    local obj = LoadPrefabAndInit("PKUI/PKShopUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end
end

function PKShopUI:Init()
    local backpack = self:FindChild(self._gameObject, "Backpack")
    self.mBackpackUI =
        BackpackUIComNew.new(
        {
            ["objBind"] = backpack, -- 背包实例绑定的ui节点
            ["RowCount"] = 3, -- 背包中一行包含的物品节点个数
            ["ColumnCount"] = 6, -- 背包中一列包含的物品节点个数
            ["bCanShowLock"] = true, -- 是否显示物品的锁定状态
            ["funcOnClickItemInfo"] = function(obj, itemID) -- 点击ItemInfo组件的回调
                self:OnClickItem(obj, itemID)
            end,
            ["funcOnClickItemIcon"] = function(obj, itemID) -- 点击ItemIcon组件的回调
                self:OnClickItem(obj, itemID)
            end,
            ["funcOnRefreshItem"] = function(itemInfoUI, itemNode, itemData)
                local cost = 0
                if itemData then
                    cost = self:GetCost(itemData.BaseID)
                end
                itemInfoUI:SetItemPrice(itemNode, cost, "ItemIcon/shangpin/icon_eauip_shangpin_zhangmenbi")
            end
        }
    )

    local detail = self:FindChild(self._gameObject, "Detail/Info")
    self.mDetail = {
        Root = detail,
        LabTitle = self:FindChildComponent(detail, "LabTitle", "Text"),
        LabTip = self:FindChildComponent(detail, "Tips/Viewport/Content/Content", "Text"),
        BtnMin = self:FindChildComponent(detail, "Btns/Number/BtnMin", "Button"),
        BtnAdd = self:FindChildComponent(detail, "Btns/Number/BtnAdd", "Button"),
        LabNum = self:FindChildComponent(detail, "Btns/Number/Image/LabNum", "Text"),
        BtnAll = self:FindChildComponent(detail, "Btns/Number/BtnAll", "Button"),
        ImgBuy = self:FindChildComponent(detail, "Btns/BtnBuy", "Image"),
        BtnBuy = self:FindChildComponent(detail, "Btns/BtnBuy", "Button"),
        LabCost = self:FindChildComponent(detail, "Btns/BtnBuy/LabCost", "Text")
    }

    self:AddButtonClickListener(self.mDetail.BtnMin, Util.bind(self.OnClickSub, self))
    self:AddButtonClickListener(self.mDetail.BtnAdd, Util.bind(self.OnClickAdd, self))
    self:AddButtonClickListener(self.mDetail.BtnAll, Util.bind(self.OnClickAll, self))
    self:AddButtonClickListener(self.mDetail.BtnBuy, Util.bind(self.OnClickBuy, self))

    self.mLabTime = self:FindChildComponent(self._gameObject, "LabTime", "Text")
end

function PKShopUI:RefreshUI()
    self.mShowTip = true

    local info = PKManager:GetInstance():GetShopData()

    self.mItemToNum = info.ItemIDToNum or {}

    local pkConfig = GetTableData("PKConfig", 1) or {}
    local jibanID = pkConfig["JibanID"] or 0
    self.mBackpackUI:ShowPackByBaseIDArray(
        info.ItemIDList or {},
        self.mItemToNum,
        {
            ["funcSort"] = function(item1, item2)
                if item1 and item2 then
                    if item1.BaseID == jibanID then
                        return false
                    elseif item2.BaseID == jibanID then
                        return true
                    elseif item1.Rank == item2.Rank then
                        return item1.BaseID > item2.BaseID
                    else
                        return item1.Rank > item2.Rank
                    end
                else
                    return false
                end
            end
        }
    )

    self.mBackpackUI:UnPickAllItems()
    self.mCurItemNum = 0
    self.mCurItemID = nil

    self.mLabTime.text = ShowCountDownByMin(0)

    self:RefreshDetail()
    self:RefreshTime()

    local zmGold = PKManager:GetInstance():GetZmGold()

    LuaEventDispatcher:dispatchEvent(
        "ONEVENT_REF_MONEY",
        {
            eMoneyType = STLMT_ZMGOLD,
            dwCurNum = zmGold
        }
    )

    if zmGold == 0 then
        OpenWindowImmediately(
            "GeneralBoxUI",
            {
                GeneralBoxType.COMMON_TIP,
                "已经选完奖励，即将结束本局掌门对决，回到酒馆",
                function()
                    PKManager:GetInstance():End()
                end,
                {
                    confirm = true,
                    close = false
                }
            }
        )
        self.mShowTip = false
    end

    -- 引导
    GuideDataManager:GetInstance():StartGuideByID(56)
end

function PKShopUI:RefreshDetail()
    if self.mCurItemID == nil then
        self.mDetail.Root:SetActive(false)
        return
    end

    self.mDetail.Root:SetActive(true)

    local itemTypeData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(self.mCurItemID)
    local tips = TipsDataManager:GetInstance():GetItemTips(nil, self.mCurItemID)
    self.mDetail.LabTitle.text = tostring(tips.title)
    self.mDetail.LabTitle.color = getRankColor(itemTypeData.Rank)
    self.mDetail.LabTip.text = tips.content

    self:RefreshNum()
end

function PKShopUI:RefreshNum()
    if self.mCurItemID == nil then
        return
    end

    local totalNum = self.mItemToNum[self.mCurItemID] or 0
    local curNum = math.min(math.max(self.mCurItemNum, 0), totalNum)
    self.mDetail.LabNum.text = string.format("%d/%d", curNum, totalNum)

    local cost = self:GetCost(self.mCurItemID) * curNum
    self.mDetail.LabCost.text = tostring(cost)
    self.mDetail.LabCost.color =
        (PKManager:GetInstance():GetZmGold() >= cost and cost > 0) and DRCSRef.Color.white or DRCSRef.Color.red

    -- self.mDetail.BtnBuy.interactable = curNum > 0 and PKManager:GetInstance():GetZmGold() >= cost
    -- if self.mDetail.BtnBuy.interactable then
    --     self.mDetail.ImgBuy.material = nil
    -- else
    --     self.mDetail.ImgBuy.material = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
    -- end
end

function PKShopUI:OnEnable()
    if not LogicMain:GetInstance():IsReplaying() then
        PlayMusic(BGMID_ZM)
    end

    local info = PKManager:GetInstance():GetShopData()

    local zmGold = PKManager:GetInstance():GetZmGold()
    OpenWindowBar(
        {
            ["windowstr"] = "PKShopUI",
            ["topBtnState"] = {
                ["bBackBtn"] = true,
                ["bZmGold"] = true
            },
            ["bSaveToCache"] = false,
            ["skipDefaultBackCallback"] = true,
            ["strSecondConfirm"] = zmGold > 0 and "尚未使用完掌门币，退出商城后不可再进入，未使用完的掌门币将折算为低价值补偿，通过邮件发送。是否退出商城？" or nil,
            ["callback"] = function()
                -- TODO: 这里应该加个延迟，因为Windowbar的callback不支持场景切换，但是这个是异步请求刚好代替延迟
                PKManager:GetInstance():RequestLeave()
            end
        }
    )
end

function PKShopUI:OnDisable()
    RemoveWindowBar("PKShopUI")

    if self.mShowTip == false then
        RemoveWindowImmediately("GeneralBoxUI", false)
    end
end

function PKShopUI:Update()
    self.mBackpackUI:Update()

    self:RefreshTime()
end

function PKShopUI:OnDestroy()
    self.mBackpackUI:Close()
end

function PKShopUI:OnClickItem(obj, itemID)
    if itemID then
        if self.mBackpackUI:IsItemPicked(itemID) then
            return
        end

        self.mBackpackUI:UnPickAllItems()

        self.mBackpackUI:PickItemByID(itemID, 1)
        self.mCurItemID = itemID
        self.mCurItemNum = math.min(1, self.mItemToNum[self.mCurItemID])

        self:RefreshDetail()
    end
end

function PKShopUI:OnClickSub()
    if self.mCurItemID == nil then
        return
    end

    self.mCurItemNum = self.mCurItemNum - 1
    self:RefreshNum()
end

function PKShopUI:OnClickAdd()
    if self.mCurItemID == nil then
        return
    end

    self.mCurItemNum = self.mCurItemNum + 1
    self:RefreshNum()
end

function PKShopUI:OnClickAll()
    if self.mCurItemID == nil then
        return
    end

    self.mCurItemNum = self.mItemToNum[self.mCurItemID] or 0
    self:RefreshNum()
end

function PKShopUI:OnClickBuy()
    if self.mCurItemNum <= 0 then
        return
    end

    local cost = self:GetCost(self.mCurItemID) * self.mCurItemNum

    if PKManager:GetInstance():GetZmGold() < cost then
        SystemUICall:GetInstance():Toast("掌门币不够")
        return
    end

    local pkConfig = GetTableData("PKConfig", 1) or {}
    local jibanID = pkConfig["JibanID"] or 0

    if self.mCurItemID == jibanID then
        PKManager:GetInstance():RequestBuy(self.mCurItemID, self.mCurItemNum)
        return
    end

    local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(self.mCurItemID)
    if itemData then
        PKManager:GetInstance():RequestBuy(itemData.FragmentRole)
    end
end

function PKShopUI:RefreshTime()
    if not self.mShowTip then
        return
    end

    if not PKManager:GetInstance():IsRunning() then
        self.mShowTip = false
        return
    end

    local info = PKManager:GetInstance():GetShopData()
    local endTime = info["EndTime"]
    -- WARNING: 这个是为了处理重新匹配会偶发出现超时提示的BUG，原因未知，先加个保底吧
    -- 触发条件：1.重进还在商城，2.游戏PVP死亡，3.游戏结束…… 目前是哪个导致的
    if not endTime then
        self.mShowTip = false
        return
    end

    local diffTime = endTime - os.time()
    diffTime = math.max(0, math.ceil(diffTime))
    self.mLabTime.text = ShowCountDownByMin(diffTime)

    if diffTime == 0 then
        OpenWindowImmediately(
            "GeneralBoxUI",
            {
                GeneralBoxType.COMMON_TIP,
                "超时未选择奖励，未使用完的掌门币将折算为低价值补偿，通过邮件发送。点击确定返回酒馆",
                function()
                    PKManager:GetInstance():End()
                end,
                {
                    confirm = true,
                    close = false
                }
            }
        )
        self.mShowTip = false
    end
end

function PKShopUI:GetCost(itemID)
    local cost = 0

    local pkConfig = GetTableData("PKConfig", 1) or {}
    local jibanID = pkConfig["JibanID"] or 0

    -- 羁绊丹特殊处理
    if itemID == jibanID then
        cost = pkConfig["JibanPrice"] or 0
    else
        local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemID)
        if itemData then
            local rank = itemData.Rank
            local buyPriceList = pkConfig["BuyPrice"] or {}
            cost = buyPriceList[rank] or 0
        end
    end

    return cost
end

return PKShopUI
