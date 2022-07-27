ActivitySignMallUI = class("ActivitySignMallUI", BaseWindow)

local ItemPool = require("UI/ItemUI/ItemPool")
local Util = require("xlua/util")

function ActivitySignMallUI:ctor()
    self.mMallList = {}
end

function ActivitySignMallUI:Create()
    local obj = LoadPrefabAndInit("TownUI/ActivitySignMallUI", UI_UILayer, true)
    if obj then
        self:SetGameObject(obj)
    end

    -- 建立物品的专属对象池
    self.mItemPool = ItemPool.new()

    self.mLabTitle = self:FindChildComponent(self._gameObject, "PopUpWindow_4/Board/Bottom/Top/Title", "Text")
end

function ActivitySignMallUI:Init()
    local objMallList = self:FindChild(self._gameObject, "MallList")
    self.mMallBoxList = {}
    for i = 1, 3 do
        local objMallBox = self:FindChild(objMallList, "MallBox" .. i)

        -- 获取每天奖励的组件
        self.mMallBoxList[i] = {
            Root = objMallBox,
            Item = self:FindChild(objMallBox, "Item"),
            LabDes = self:FindChildComponent(objMallBox, "LabDes", "Text"),
            LabOriginGold = self:FindChildComponent(objMallBox, "LabOriginGold", "Text"),
            LabGold = self:FindChildComponent(objMallBox, "BtnBuy/LabGold", "Text"),
            LabTip = self:FindChildComponent(objMallBox, "LabTip", "Text"),
            BtnBuy = self:FindChildComponent(objMallBox, "BtnBuy", "Button"),
            ImgBtnBuy = self:FindChildComponent(objMallBox, "BtnBuy", "Image"),
            RedPoint = self:FindChild(objMallBox, "BtnBuy/RedPoint"),
            Effect = self:FindChild(objMallBox, "BtnBuy/Effect"),
            LineList = {}
        }

        local mallBox = self.mMallBoxList[i]
        local lines = self:FindChild(mallBox.LabDes.gameObject, "Lines")
        for i = 1, 5 do
            mallBox.LineList[i] = self:FindChild(lines, "Line" .. i)
        end

        -- 注册每天购买事件
        self:AddButtonClickListener(
            mallBox.BtnBuy,
            function()
                self:OnClickBuy(i)
            end
        )
    end
    -- 注册关闭事件
    self:AddButtonClickListener(
        self:FindChildComponent(self._gameObject, "BtnClose", "Button"),
        Util.bind(self.OnClickClose, self)
    )
end

function ActivitySignMallUI:RefreshUI(info)
    self.mLabTitle.text = info.Title or "【礼包】"
    local mallList = info.MallList or {}

    self.mItemPool:Clear()
    local gold = PlayerSetDataManager:GetInstance():GetPlayerGold()
    for i, mallBox in pairs(self.mMallBoxList) do
        local mallID = tonumber(mallList[i])
        local mallData = TableDataManager:GetInstance():GetTableData("Rack", mallID)
        local itemID = (mallData or {}).ItemID
        local itemData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemID)

        if itemData then
            self.mMallList[i] = mallID

            -- 现价
            mallBox.Root:SetActive(true)

            -- 物品栏
            self.mItemPool:Push(itemData, 1, mallBox.Item)

            -- 物品信息
            mallBox.LabDes.text = itemData.ItemDesc or ''

            -- 原价
            mallBox.LabOriginGold.text =
                mallData.OriginValue == 0 and "免费" or ("参考价<color=#913e2b>" .. mallData.OriginValue .. "</color>金锭")

            -- 现价
            local value = math.floor(mallData.OriginValue * mallData.Discount * 0.01)
            mallBox.LabGold.text = value == 0 and "免费" or value

            if gold < value then
                mallBox.LabGold.text = "<color=#d70000>" .. mallBox.LabGold.text .. "</color>"
            end

            -- 购买次数
            mallBox.LabTip.text = ""
            mallBox.RedPoint:SetActive(false)

            -- 显示介绍下划线
            local lineNum = #string.split(mallBox.LabDes.text, "\n")
            for i = 1, 5 do
                mallBox.LineList[i]:SetActive(i <= lineNum)
            end
        else
            mallBox.Root:SetActive(false)
        end
    end

    -- 请求服务器刷新签到物品数据
    SendPlatShopMallQueryItem(RackItemType.RTT_SIGN)
end

function ActivitySignMallUI:OnEnable()
    self:AddEventListener("ONEVENT_REF_SHOPDATA", Util.bind(self.OnRefreshMall, self))
end

function ActivitySignMallUI:OnDisable()
    self:RemoveEventListener("ONEVENT_REF_SHOPDATA")
end

-- 刷新购买次数
function ActivitySignMallUI:OnRefreshMall()
    for i, mallBox in pairs(self.mMallBoxList) do
        local mallID = self.mMallList[i]

        if mallID then
            local shopData = ShoppingDataManager:GetInstance():GetShopDataBy(mallID)
            if shopData then
                local canBuyCount = shopData.iCanBuyCount
                local maxBuyCount = shopData.iMaxBuyNums
                if canBuyCount == 0 then
                    -- 无购买次数
                    setUIGray(mallBox.ImgBtnBuy, true)
                    mallBox.LabTip.text = ""
                elseif maxBuyCount > 1 and maxBuyCount - canBuyCount > 0 then
                    -- 可以购买多次且购买过一次
                    mallBox.LabTip.text = string.format("还可购买%d次", canBuyCount)
                end

                -- 显示按钮特效
                mallBox.Effect:SetActive(canBuyCount > 0)

                -- 显示小红点
                mallBox.RedPoint:SetActive(false)
                local mallData = TableDataManager:GetInstance():GetTableData("Rack", mallID)
                if mallData then
                    local value = math.floor(mallData.OriginValue * mallData.Discount * 0.01)
                    if value == 0 then
                        mallBox.RedPoint:SetActive(mallBox.BtnBuy.enabled and canBuyCount > 0)
                    end
                end
            end
        end
    end
end

function ActivitySignMallUI:OnClickBuy(index)
    local mallID = self.mMallList[index]

    dprint("[ActivitySignMallUI]=> OnClickBuy: " .. mallID)

    local shopData = ShoppingDataManager:GetInstance():GetShopDataBy(mallID)
    if shopData == nil or shopData.iCanBuyCount == 0 then
        return
    end

    local mallData = TableDataManager:GetInstance():GetTableData("Rack", mallID)
    local value = math.floor(mallData.OriginValue * mallData.Discount * 0.01)

    -- 免费的直接购买
    if value == 0 then
        SendPlatShopMallBuyItem(mallID, 1)
        return
    end

    OpenWindowImmediately(
        "GeneralBoxUI",
        {
            GeneralBoxType.COMMON_TIP,
            string.format("是否花费%d金锭购买礼包?", value),
            function()
                PlayerSetDataManager:GetInstance():RequestSpendGold(
                    value,
                    function()
                        SendPlatShopMallBuyItem(mallID, 1)
                    end
                )
            end
        }
    )
end

function ActivitySignMallUI:OnClickClose()
    self.mMallList = {}
    self.mItemPool:Clear()
    RemoveWindowImmediately("ActivitySignMallUI")
end

function ActivitySignMallUI:OnBuySuccess()
    -- 请求服务器刷新签到物品数据
    SendPlatShopMallQueryItem(RackItemType.RTT_SIGN)
end

return ActivitySignMallUI
