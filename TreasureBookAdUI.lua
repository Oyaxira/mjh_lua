TreasureBookAdUI = class("TreasureBookAdUI",BaseWindow)

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local l_DRCSRef_Type = DRCSRef_Type
function TreasureBookAdUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function TreasureBookAdUI:Create()
	local obj = LoadPrefabAndInit("TownUI/TreasureBookAdUI",Load_Layer,true)
	if obj then
		self:SetGameObject(obj)
    end
end

function TreasureBookAdUI:Init()
    self.objAD = self:FindChild(self._gameObject, "AD")
    self.comTwn = self.objAD:GetComponent(l_DRCSRef_Type.DOTweenAnimation)
    self.objImgAD = self:FindChild(self.objAD, "Image")
    self.imgAD = self.objImgAD:GetComponent(l_DRCSRef_Type.Image)
    self.objImgAD:SetActive(false)
    self.objRewards = self:FindChild(self.objAD, "Rewards")
    self.objRewards:SetActive(false)
    local btnEnter = self:FindChildComponent(self.objAD, "Enter", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnEnter, function()
        self:OnClickEnter()
    end)
    self.textToggleHide = self:FindChildComponent(self.objAD, "Label", l_DRCSRef_Type.Text)
    self.toggleHide = self:FindChildComponent(self.objAD, "Hide", l_DRCSRef_Type.Toggle)
    self.toggleHide.isOn = false
    self.objSwitch = self:FindChild(self.objAD, "Switch")
    local btnLeft = self:FindChildComponent(self.objSwitch, "Left", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnLeft, function()
        self:OnClickLeft()
    end)
    local btnRight = self:FindChildComponent(self.objSwitch, "Right", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnRight, function()
        self:OnClickRight()
    end)
    self.objSwitch:SetActive(false)
    -- 其他数据
    self.bookManager = TreasureBookDataManager:GetInstance()
end

function TreasureBookAdUI:RefreshUI(info)
    -- 显示方式 Normal/ MonthEnd
    self.strStyle = (info and info.style) and info.style or "Normal"
    -- 检查百宝书基础信息
    if self.bookManager:GetTreasureBookBaseInfo() then
        self:InitAd()
    else
        local callBack = function()
            local win = GetUIWindow("TreasureBookAdUI")
            if not win then return end
            win:InitAd()
        end
        self.bookManager:RequestTreasureBookBaseInfo(callBack)
    end
end

-- 初始化广告
function TreasureBookAdUI:InitAd()
    self.kBaseInfo = self.bookManager:GetTreasureBookBaseInfo()
    if not self.kBaseInfo then
        return
    end
    self.iCurBookID = self.kBaseInfo.iCurBookID
    self.kTreasureBook = TableDataManager:GetInstance():GetTableData("TreasureBook",self.iCurBookID)
    if not self.kTreasureBook then
        return
    end
    local bNormalStyle = (self.strStyle == "Normal")

    -- 宣传图
    local asImgGroup = nil
    if bNormalStyle then
        asImgGroup = self.kTreasureBook.AdvertiseImages or {}
    elseif self.kTreasureBook.MonthEndAttractMoneyImage then
        asImgGroup = {[1] = self.kTreasureBook.MonthEndAttractMoneyImage}
    end
    self.curImgGroup = asImgGroup
    self.iCurImgIndex = 1
    self:SetImg()
    self.objSwitch:SetActive(#asImgGroup > 1)

    -- 奖励表
    if not bNormalStyle then
        self:InitRewards()
    end
    self.objRewards:SetActive(not bNormalStyle)

    -- Toggle
    -- self.textToggleHide.text = "本" .. (bNormalStyle and "日" or "月") .. "不再提醒"
    self.textToggleHide.text = "本日不再提醒"
    self:RemoveToggleClickListener(self.toggleHide)
    self:AddToggleClickListener(self.toggleHide, function(bOn)
        self:OnClickToggleHide(bOn)
    end)

    -- 动画
    self.comTwn:DOPlay()
end

-- 设置宣传图
function TreasureBookAdUI:SetImg()
    if not self.curImgGroup then
        return
    end
    self.iCurImgIndex = self.iCurImgIndex or 1
    local sImgPath = self.curImgGroup[self.iCurImgIndex]
    if not sImgPath then
        return
    end
    self.imgAD.sprite = GetSprite(sImgPath)
    self.objImgAD:SetActive(true)
end

-- 初始化奖励表
function TreasureBookAdUI:InitRewards()
    if not (self.kBaseInfo and self.kTreasureBook) then
        return
    end
    local iCurExp = self.kBaseInfo.iExp or 0
    local iRewardExp = iCurExp + (self.kTreasureBook.MonthEndAttractMoneyExtraExp or 0)
    local iRewardLevel = self.bookManager:Exp2Level(iRewardExp)
    local allRewards = self.bookManager:GenBookAllRewards(self.kTreasureBook)
    -- 收集所有能获得的壕侠奖励
    local itemsCanGet = {}
    local itemTypeID2Num = {}
    local iMaxLevel = math.min(allRewards.iMaxlLevel or 0, iRewardLevel)
    local kData = nil
    local itemTypeID = nil
    for index = 1, iMaxLevel do
        kData = allRewards['VIP'][index]
        if kData and (#kData > 0) then
            for _, itemInfo in ipairs(kData) do
                itemTypeID = itemInfo.itemTypeID
                if itemTypeID2Num[itemTypeID] then
                    itemTypeID2Num[itemTypeID] = itemTypeID2Num[itemTypeID] + (itemInfo.itemNum or 0)
                else
                    itemsCanGet[#itemsCanGet + 1] = TableDataManager:GetInstance():GetTableData("Item",itemInfo.itemTypeID)
                    itemTypeID2Num[itemTypeID] = itemInfo.itemNum or 0
                end
            end
        end
    end
    -- 按品质排序
    table.sort(itemsCanGet, function(a, b)
        local rankA = (a and a.Rank) and a.Rank or 0
        local rankB = (b and b.Rank) and b.Rank or 0
        return rankA > rankB
    end)
    -- 填满ui
    local transReward = self.objRewards.transform
    local objIcon = nil
    for index = 0, transReward.childCount - 1 do
        objIcon = transReward:GetChild(index).gameObject
        kData = itemsCanGet[index + 1]
        if kData then
            self.ItemIconUI:UpdateUIWithItemTypeData(objIcon, kData)
            self.ItemIconUI:SetItemNum(objIcon, itemTypeID2Num[kData.BaseID] or 0)
            objIcon:SetActive(true)
        else
            objIcon:SetActive(false)
        end
    end
end

-- 点击不再提醒
function TreasureBookAdUI:OnClickToggleHide(bOn)
    local timetable = os.date("*t", os.time())
    local key = "TreasureBookDialyAD"
    local value = nil
    if bOn == true then
        value = string.format("%d-%d-%d", timetable.year, timetable.month, timetable.day)
    end
    SetConfig(key, value)
end

-- 点击进入百宝书
function TreasureBookAdUI:OnClickEnter()
    self.bookManager:CheckTreasureBookEarlyBuy()
    RemoveWindowImmediately("TreasureBookAdUI", false)
end

-- 点击上一张宣传图
function TreasureBookAdUI:OnClickLeft()
    self.iCurImgIndex = self.iCurImgIndex or 1
    if self.iCurImgIndex <= 1 then
        return
    end
    self.iCurImgIndex = self.iCurImgIndex - 1
    self:SetImg()
end

-- 点击下一张宣传图
function TreasureBookAdUI:OnClickRight()
    if not self.curImgGroup then
        return
    end
    self.iCurImgIndex = self.iCurImgIndex or 1
    if self.iCurImgIndex >= (#self.curImgGroup) then
        return
    end
    self.iCurImgIndex = self.iCurImgIndex + 1
    self:SetImg()
end

function TreasureBookAdUI:OnDestroy()
    self.ItemIconUI:Close()
end

return TreasureBookAdUI
