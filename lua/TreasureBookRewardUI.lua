TreasureBookRewardUI = class("TreasureBookRewardUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local l_DRCSRef_Type = DRCSRef_Type

function TreasureBookRewardUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function TreasureBookRewardUI:Init(objParent, instParent)
    --初始化, 获取组件的同时将组件设置为空状态
    if not (objParent and instParent) then return end
    self._gameObjectParent = objParent
    self._instParent = instParent
    local obj = self:FindChild(objParent, "TreasureBookRewardUI")
	if obj then
		self:SetGameObject(obj)
    end
    local objPage = self:FindChild(self._gameObject, "Page")
    local objBoard = self:FindChild(objPage, "Board")
    local objMsg = self:FindChild(objBoard, "Msg")
    -- 百宝书时间信息
    self.objTreasureBookDate = self:FindChild(objMsg, "Date")
    self.textTreasureBookDate = self.objTreasureBookDate:GetComponent(l_DRCSRef_Type.Text)
    -- 百宝书等级信息
    local objLevelMsg = self:FindChild(objMsg, "LevelMsg")
    self.objTreasureBookLevel = self:FindChild(objLevelMsg, "Icon/Level")
    self.textTreasureBookLevel = self.objTreasureBookLevel:GetComponent(l_DRCSRef_Type.Text)
    self.objTreasureBookLevel:SetActive(false)
    local objExp = self:FindChild(objLevelMsg, "Exp")
    self.scrollBarExp = self:FindChildComponent(objExp, "Scrollbar", l_DRCSRef_Type.Scrollbar)
    self.scrollBarExp.size = 0
    self.objCurExp = self:FindChild(objExp, "Value")
    self.textCurExp = self.objCurExp:GetComponent(l_DRCSRef_Type.Text)
    self.objCurExp:SetActive(false)
    local btnGetExp = self:FindChildComponent(objLevelMsg, "GetExp", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnGetExp, function()
        self:OnClickGetExp()
    end)
    self.btnBuyExp = self:FindChildComponent(objLevelMsg, "BuyExp", l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnBuyExp, function()
        self:OnClickBuyExp()
    end)
    -- 百宝书奖励信息
    local objRewardMsg = self:FindChild(objMsg, "RewardMsg")
    self.objRewardSV = self:FindChild(objRewardMsg, "Rewards")
    self.svRewards = self.objRewardSV:GetComponent(l_DRCSRef_Type.LoopHorizontalScrollRect)
    self.svRewards:AddListener(function(...) 
        if self:IsOpen() == true then
            self:UpdateTreasureItemUI(...) 
        end
    end)
    self.objBtnGetAll = self:FindChild(objRewardMsg, "GetAll")
    local btnGetAll = self.objBtnGetAll:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnGetAll, function()
        self:OnClickGetAll()
    end)
    self.objBtnGetAll:SetActive(false)
    self.objRewardSV:SetActive(false)
    -- 详情
    local objDetail = self:FindChild(objBoard, "Detail")
    self.objDetailTitle = self:FindChild(objDetail, "Title")
    self.textDetailTitle = self.objDetailTitle:GetComponent(l_DRCSRef_Type.Text)
    self.objDetailTitle:SetActive(false)
    self.objDetailType = self:FindChild(objDetail, "Type")
    self.textDetailType = self.objDetailType:GetComponent(l_DRCSRef_Type.Text)
    self.objDetailType:SetActive(false)
    self.objDetailDesc = self:FindChild(objDetail, "Desc")
    self.textDetailDesc = self:FindChildComponent(self.objDetailDesc, "Viewport/Text", l_DRCSRef_Type.Text)
    self.objDetailDesc:SetActive(false)
    self.objDetailCond = self:FindChild(objDetail, "Cond")
    self.textDetailCond = self.objDetailCond:GetComponent(l_DRCSRef_Type.Text)
    self.objDetailCond:SetActive(false)
    -- 底部栏
    self.objBar = self:FindChild(objPage, "Bar")
    self.objBtnActivation = self:FindChild(self.objBar, "Activation")
    local btnActivation = self.objBtnActivation:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnActivation, function()
        self:OnClickActivetion()
    end)
    self.objBtnActiveSign = self:FindChild(self.objBar, "ActiveSign")
    local btnActiveSign = self.objBtnActiveSign:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnActiveSign, function()
        self:OnClickActiveSign()
    end)
    local objBtnShowAll = self:FindChild(self.objBar, "ShowAll")
    local btnShowAll = objBtnShowAll:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnShowAll, function()
        self:OnClickShowAll()
    end)
    self.textActiveSignMsg = self:FindChildComponent(self.objBtnActiveSign, "ActivaeMsg", l_DRCSRef_Type.Text)
    self.objBar:SetActive(false)
    -- 奖励总览界面
    self.objAllRewards = self._instParent.objAllRewards
    local objAllRewardsPage = self:FindChild(self.objAllRewards, "Page")
    local objBtnCloseAllRewards = self:FindChild(objAllRewardsPage, "Close")
    local btnCloseAllRewards = objBtnCloseAllRewards:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(btnCloseAllRewards, function()
        self:CloseShowAll()
    end)
    self.svAllRewardLoopView = self:FindChildComponent(objAllRewardsPage, "LoopScrollView", l_DRCSRef_Type.LoopVerticalScrollRect)
    self.svAllRewardLoopView:AddListener(function(...) 
        if self:IsOpen() == true then
            self:UpdateAllRewardItemGroupUI(...) 
        end
    end)
    self.objAllRewards:SetActive(false)
    -- 其他数据
    self.bookManager = TreasureBookDataManager:GetInstance()
    self.allRewards = nil
    self.strColorCondTrue = "<color=#10783f>%s</color>"
    self.strColorCondFalse = "<color=#913E2B>%s</color>"
    self.iAllRewardSingRowCount = 9  -- 奖励全览界面一行中包含的图标个数
    self.colorAllRewardHero = DRCSRef.Color(0.5058824, 0.4235294, 0.3568628, 1)
    self.colorAllRewardVIP = DRCSRef.Color(0.9019608, 0.8666667, 0.7764706, 1)
end

function TreasureBookRewardUI:RefreshUI(info)
    -- 检查百宝书基础信息
    if self.bookManager:GetTreasureBookBaseInfo() then
        self:UpdateTreasureBookBaseInfo()
    else
        self.bookManager:RequestTreasureBookBaseInfo()
    end
end

-- 设置百宝书基础信息
function TreasureBookRewardUI:UpdateTreasureBookBaseInfo()
    local info = self.bookManager:GetTreasureBookBaseInfo()
    if not info then 
        return 
    end
    self.kBaseInfo = info
    self.iCurBookID = info.iCurBookID
    self.kTreasureBook = TableDataManager:GetInstance():GetTableData("TreasureBook",self.iCurBookID)
    -- 分析百宝书奖励, 一般情况下只走一遍, 只有在百宝书id发生变更的情况下会再走一次
    if (not self.allRewards) or (self.allRewards.iBookID ~= self.iCurBookID) then
        self.allRewards = self.bookManager:GenBookAllRewards(self.kTreasureBook)
        self:InitAllRewardUI()
    end
    -- 更新百宝书日期
    self:UpdateTreasureBookDate()
    -- 更新百宝书等级信息
    self:UpdateTreasureBookLevel()
    -- 更新奖励
    self:UpdateTreasureReward()
    -- 更新底部栏状态
    self:UpdateBar()
end

-- 更新百宝书日期
function TreasureBookRewardUI:UpdateTreasureBookDate()
    if not (self.kTreasureBook and self.objTreasureBookDate and self.textTreasureBookDate) then
        return
    end
    local kBook = self.kTreasureBook
    self.objTreasureBookDate:SetActive(false)
    if kBook.BeginDate and kBook.EndDate then
        self.textTreasureBookDate.text = string.format("（本期百宝书生效时间：%d.%d.%d-%d.%d.%d）"
        , kBook.BeginDate.Year or 0, kBook.BeginDate.Month or 0, kBook.BeginDate.Day or 0
        , kBook.EndDate.Year or 0, kBook.EndDate.Month or 0, kBook.EndDate.Day or 0)
        self.objTreasureBookDate:SetActive(true)
    end
end

-- 更新百宝书等级信息
function TreasureBookRewardUI:UpdateTreasureBookLevel()
    if not (self.kTreasureBook and self.kBaseInfo) then
        return
    end
    -- 等级
    local iLevel = self.kBaseInfo.iLevel
    self.textTreasureBookLevel.text = tostring(iLevel)
    self.objTreasureBookLevel:SetActive(true)
    -- 经验
    local iExp = self.kBaseInfo.iExp
    local iNextLevel = iLevel + 1
    local TB_TreasureBookLV = TableDataManager:GetInstance():GetTable("TreasureBookLV")
    local iMaxLevel = #TB_TreasureBookLV
    local bIsOverLoadLevel = iNextLevel > iMaxLevel

    local iExpLeftLimit, iExpRightLimit = 0, 0
    if bIsOverLoadLevel and TB_TreasureBookLV[iMaxLevel] then
        local uiExpSingleLevel = self.kTreasureBook.HundredLaterExp or 0
        local kMaxLevelExp = TB_TreasureBookLV[iMaxLevel]
        iExpLeftLimit = kMaxLevelExp.EXP + uiExpSingleLevel * (iLevel - iMaxLevel)
        iExpRightLimit = kMaxLevelExp.EXP + uiExpSingleLevel * (iNextLevel - iMaxLevel)
    elseif TB_TreasureBookLV[iLevel] and TB_TreasureBookLV[iNextLevel] then
        iExpLeftLimit = TB_TreasureBookLV[iLevel].EXP
        iExpRightLimit = TB_TreasureBookLV[iNextLevel].EXP
    end

    if iExpLeftLimit < iExpRightLimit then
        self.textCurExp.text = string.format("%d/%d", iExp - iExpLeftLimit, iExpRightLimit - iExpLeftLimit)
        self.scrollBarExp.size = (iExp - iExpLeftLimit) / (iExpRightLimit - iExpLeftLimit)
    else
        self.textCurExp.text = "???"
        self.scrollBarExp.size = 0
    end

    self.objCurExp:SetActive(true)
end

-- 更新底部栏状态
function TreasureBookRewardUI:UpdateBar()
    if not self.kBaseInfo then
        return
    end
    local bIsVip = self.kBaseInfo.bRMBPlayer
    self.objBtnActivation:SetActive(not bIsVip)
    self.objBtnActiveSign:SetActive(bIsVip)
    local strMsg = "已激活壕侠版，继续升级可得更多奖励"
    -- 如果玩家已经预购, 那么在底部栏添加预购信息
    -- if self.kBaseInfo.bAdvancePurchase == true then
    --     self.textActiveSignMsg.text = self.strOriActiveSighMsg .. " <color=#913E2B>(已预购)</color>"
    -- else
    --     self.textActiveSignMsg.text = self.strOriActiveSighMsg
    -- end
    -- 添加壕侠到期时间
    local uiOutOfDateTimeStamp = self.kBaseInfo.iPurchaseBookEndTime or 0
    local kDate = os.date("*t", uiOutOfDateTimeStamp)
    strMsg = strMsg .. string.format("\n壕侠到期时间 %04d年%02d月%02d日", kDate.year or 0, kDate.month or 0, kDate.day or 0)
    self.textActiveSignMsg.text = strMsg
    self.objBar:SetActive(true)
end

-- 获取所有百宝书奖励是否已领取
function TreasureBookRewardUI:IsRewardGot(iLevel, bIsRmbReward)
    if not self.kTreasureBook then
        return false
    end
    return self.bookManager:IsBookRewardGot(self.kTreasureBook, iLevel, bIsRmbReward)
end

-- 更新百宝书奖励领取情况
function TreasureBookRewardUI:UpdateTreasureReward()
    if not (self.allRewards and self.kBaseInfo) then
        return
    end
    -- 分析初始状态数据
    self:GenRewardsInitStateMsg()
    -- 更新奖励列表
    -- 由于百宝书在升级到最大等级之后, 最后还允许突破最大等级来获取百宝书残页
    -- 所以在显示 1~iMaxLevel 等级的奖励后, 还需要显示一个 "等级 iMaxLevel+" 的奖励项
    self.svRewards.totalCount = self.allRewards.iMaxlLevel + 1
    if self.bFirstRefresh ~= true then
        self.svRewards:RefillCells()
        self.bFirstRefresh = true
    else
        self.svRewards:RefreshCells()
    end
    -- self.svRewards:RefreshNearestCells()
    self.objRewardSV:SetActive(true)
    -- 设置滚动栏初始状态
    self:SetRewardsInitState()
end

-- 分析滚动栏初始状态信息
function TreasureBookRewardUI:GenRewardsInitStateMsg()
    if not (self.kBaseInfo and self.allRewards) then
        return
    end
    local bIsVip = (self.kBaseInfo.bRMBPlayer == true)
    local iCurLevel = self.kBaseInfo.iLevel or 1
    local iLevelLimit = math.min(iCurLevel, self.allRewards.iMaxlLevel)
    local mapCanGetRewardLevel = {} -- 所有可领取奖励的等级 
    local bAllHeroRewardGot, bAllVIPRewardGot = false, false
    self.iFirstCanGetItemTypeID = nil
    self.iFirstCanGetLevel = nil
    local bFirstCanGetItemIsRmb = false
    local bFinalGotItemIsRmb = false
    for index = 1, iLevelLimit do
        bAllHeroRewardGot = self:IsRewardGot(index, false)
        bAllVIPRewardGot = self:IsRewardGot(index, true)
        if bAllHeroRewardGot ~= true then
            -- 记录第一个没有领取的奖励
            if self.iFirstCanGetItemTypeID == nil then
                self.iFirstCanGetItemTypeID = self.allRewards["Hero"][index][1]['itemTypeID']
                self.iFirstCanGetLevel = index
            end
            mapCanGetRewardLevel[index] = true
        end
        if bIsVip and (bAllVIPRewardGot ~= true) then
            -- 记录第一个没有领取的奖励
            if self.iFirstCanGetItemTypeID == nil then
                self.iFirstCanGetItemTypeID = self.allRewards["VIP"][index][1]['itemTypeID']
                self.iFirstCanGetLevel = index
                bFirstCanGetItemIsRmb = true
            end
            mapCanGetRewardLevel[index] = true
        end
        if (self.iFirstCanGetItemTypeID == nil) and (self.iFirstCanGetLevel == nil) then
            -- 记录最后一个被领取的奖励
            if #self.allRewards["Hero"][index] > 0 then
                self.iFinalGotItemTypeID = self.allRewards["Hero"][index][1]['itemTypeID']
                bFinalGotItemIsRmb = false
            else
                self.iFinalGotItemTypeID = self.allRewards["VIP"][index][1]['itemTypeID']
                bFinalGotItemIsRmb = true
            end
            self.iFinalGotLevel = index
        end
    end
    -- 初始化当前选择的物品
    if self.iFirstCanGetItemTypeID then
        self.kCurChooseItemInfo = {
            ['itemTypeID'] = self.iFirstCanGetItemTypeID,
            ['iLevel'] = self.iFirstCanGetLevel,
            ['bIsRmbReward'] = bFirstCanGetItemIsRmb,
        }
    elseif self.iFinalGotItemTypeID then
        self.kCurChooseItemInfo = {
            ['itemTypeID'] = self.iFinalGotItemTypeID,
            ['iLevel'] = self.iFinalGotLevel,
            ['bIsRmbReward'] = bFinalGotItemIsRmb,
        }
    end
    -- 分析一下有多少个等级可以领取奖励, 如果可领等级数量在两个以上, 那么显示一键领取
    local aiCanGetRewardLevel = {}
    for iLevel, bCanGet in pairs(mapCanGetRewardLevel) do
        if bCanGet then
            aiCanGetRewardLevel[#aiCanGetRewardLevel + 1] = iLevel
        end
    end
    self.objBtnGetAll:SetActive(#aiCanGetRewardLevel >= 2)
    self.aiCanGetRewardLevel = aiCanGetRewardLevel
end

-- 设置滚动栏的初始状态
function TreasureBookRewardUI:SetRewardsInitState()
    if not (self.kTreasureBook and self.allRewards) then
        return
    end
    -- 如果存在没有被领取的奖励与等级, 那么初始状态显示该奖励的信息, 滚动栏滚动到该等级
    if self.iFirstCanGetItemTypeID and self.iFirstCanGetLevel then
        self:OnClickItemIcon(nil, self.iFirstCanGetItemTypeID, self.iFirstCanGetLevel)
        local iMoveToIndex = self.iFirstCanGetLevel - 1
        -- self.svRewards:SrollToCell(iMoveToIndex, iMoveToIndex * 100)
        self.svRewards:RefillCells(iMoveToIndex)
        return
    end
    -- 否则, 初始状态显示最后一个被领取的奖励的信息, 滚动栏滚动到该等级
    if self.iFinalGotItemTypeID and self.iFinalGotLevel then
        -- 如果最后一个被领取的奖励是最大等级, 那么滚动栏停留在最大等级后一位: [百宝书突破等级] 上
        if self.iFinalGotLevel == self.allRewards.iMaxlLevel then
            self:OnClickItemIcon(nil, self.kTreasureBook.HundredLaterReward, self.iFinalGotLevel + 1, true)
            local iMoveToIndex = self.iFinalGotLevel
            self.svRewards:RefillCells(iMoveToIndex)
        else
            self:OnClickItemIcon(nil, self.iFinalGotItemTypeID, self.iFinalGotLevel)
            local iMoveToIndex = self.iFinalGotLevel - 1
            -- self.svRewards:SrollToCell(iMoveToIndex, iMoveToIndex * 100)
            self.svRewards:RefillCells(iMoveToIndex)
        end
    end
end

-- 更新百宝书奖励ui
function TreasureBookRewardUI:UpdateTreasureItemUI(transform, index)
    if not (transform and index 
    and self.kBaseInfo and self.allRewards and self.kTreasureBook) then
        return
    end
    local obj = transform.gameObject
    local iLevel = index + 1
    -- 标题栏
    local uiUserLevel = self.kBaseInfo.iLevel or 0  -- 用户的百宝书等级
    local uiExtraGetRewardLvl = self.kBaseInfo.iExtraGetRewardLvl or 0  -- 用户领取过的超过100级的等级数
    local uiCustomMaxLevel = self.allRewards.iMaxlLevel or 0  -- 实际的最大等级
    local uiCanGetExtraRewardLevels = uiUserLevel - uiCustomMaxLevel - uiExtraGetRewardLvl  -- 用户可以领取突破等级奖励的等级数
    local bIsOverLoadLevel = (iLevel > uiCustomMaxLevel)  -- 当前等级是否是实际最大等级之后的突破等级
    local bLevelAchieve = (uiUserLevel >= iLevel)
    local bIsVIP = self.kBaseInfo.bRMBPlayer == true
    -- 如果是百宝书突破等级, 那么没有是否领取的状态
    -- 否则, 判断这个等级的奖励是否已经领取过
    local bAllHeroRewardGot = false
    local bAllVIPRewardGot = false
    if not bIsOverLoadLevel then
        bAllHeroRewardGot = self:IsRewardGot(iLevel, false)
        bAllVIPRewardGot = (not bIsVIP) or self:IsRewardGot(iLevel, true)
    end
    -- 该等级的英雄与壕侠奖励是否都已经领取
    local bAllRewardGot = bAllHeroRewardGot and bAllVIPRewardGot
    local objTitle = self:FindChild(obj, "Title/Text")
    objTitle:SetActive(false)
    local textTitle = objTitle:GetComponent(l_DRCSRef_Type.Text)
    local objBtnTitle = self:FindChild(obj, "Title/Get")
    objBtnTitle:SetActive(false)
    local btnTitle = objBtnTitle:GetComponent(l_DRCSRef_Type.Button)
    -- 等级突破的情况
    if bIsOverLoadLevel then
        if bIsVIP and (uiCanGetExtraRewardLevels > 0) then
            self:RemoveButtonClickListener(btnTitle)
            self:AddButtonClickListener(btnTitle, function()
                self:OnClickGetReward(iLevel)
            end)
            objBtnTitle:SetActive(true)
        else
            textTitle.text = string.format("等级%d+", uiCustomMaxLevel)
            objTitle:SetActive(true)
        end
    -- 正常达到等级奖励的情况
    elseif bLevelAchieve then
        if bAllRewardGot then
            textTitle.text = "已领取"
            objTitle:SetActive(true)
        else
            self:RemoveButtonClickListener(btnTitle)
            self:AddButtonClickListener(btnTitle, function()
                self:OnClickGetReward(iLevel)
            end)
            objBtnTitle:SetActive(true)
        end
    -- 正常未达到等级奖励的情况
    else
        textTitle.text = string.format("等级%d", iLevel)
        objTitle:SetActive(true)
    end
    -- 奖励设置辅助函数
    local setRewardHelper = function(objParent, akRewards, bLock, bIsRmbReward)
        bIsRmbReward = (bIsRmbReward == true)
        bLock = (bLock == true)
        local iNodeIndex = 1
        local objIconDecorator = self:FindChild(objParent, "Icon1")
        local objIcon = self:FindChild(objIconDecorator, "Icon")
        local kReward = nil
        local itemTypeData, itemNum = nil, nil
        local objTick = nil
        local strIconState = nil
        local bChooseState = false
        while objIconDecorator and objIcon do
            kReward = akRewards[iNodeIndex]
            if kReward then
                itemTypeData = TableDataManager:GetInstance():GetTableData("Item",kReward.itemTypeID)
                itemNum = kReward.itemNum or 0
                self.ItemIconUI:UpdateUIWithItemTypeData(objIcon,itemTypeData)
                self.ItemIconUI:SetItemNum(objIcon, itemNum, itemNum <= 1)
                strIconState = nil
                if bLock then
                    strIconState = "dark"
                end
                self.ItemIconUI:SetIconState(objIcon, strIconState)
                local tempObjIconDecorator = objIconDecorator
                self.ItemIconUI:AddClickFunc(objIcon, function(obj, itemTypeID)
                    self:OnClickItemIcon(tempObjIconDecorator, itemTypeID, iLevel, bIsRmbReward)
                end, kReward.itemTypeID)
                -- 已领取的, 图标打勾
                objTick = self:FindChild(objIconDecorator, "Tick")
                if ((bIsRmbReward == false) and (bAllHeroRewardGot == true))
                or (bIsVIP and (bIsRmbReward == true) and (bAllVIPRewardGot == true)) then
                    objTick:SetActive(true)
                else
                    objTick:SetActive(false)
                end
                -- 检查选中框
                bChooseState = false
                if self.kCurChooseItemInfo and (self.kCurChooseItemInfo.itemTypeID == kReward.itemTypeID)
                and (self.kCurChooseItemInfo.iLevel == iLevel) and (self.kCurChooseItemInfo.bIsRmbReward == bIsRmbReward) then
                    bChooseState = true
                    self.curChooseItemIcon = objIconDecorator
                end
                self:FindChild(objIconDecorator, "Choose"):SetActive(bChooseState)
                objIconDecorator:SetActive(true)
            else
                objIconDecorator:SetActive(false)
            end
            iNodeIndex = iNodeIndex + 1
            objIconDecorator = self:FindChild(objParent, "Icon" .. iNodeIndex)
            objIcon = self:FindChild(objIconDecorator, "Icon")
        end
    end
    -- 英雄奖励
    local objHero = self:FindChild(obj, "HeroReward")
    local heroRewards = self.allRewards["Hero"][iLevel] or {}
    local bLock = (bLevelAchieve ~= true)
    setRewardHelper(objHero, heroRewards, bLock, false)
    -- 壕侠奖励
    local objVIP = self:FindChild(obj, "RmbReward")
    -- 如果是突破奖励, 显示突破奖励描述的tips
    local objTips = self:FindChild(objVIP, "Tips")
    objTips:SetActive(bIsOverLoadLevel)
    local vipRewards = {}
    -- 百宝书突破等级时, 根据超过实际最大等级的值来计算应该获得的奖励数量
    -- 否则, 取所在等级对应的奖励数据
    if bIsOverLoadLevel then
        local kReward = {}
        -- 等级突破奖励物品
        kReward = {['itemTypeID'] = self.kTreasureBook.HundredLaterReward or 0}
        -- 等级突破奖励数量
        local uiSingleLevelNum = self.kTreasureBook.HundredLaterRewardNum or 0
        kReward['itemNum'] = 0
        if uiCanGetExtraRewardLevels > 0 then
            kReward['itemNum'] = uiSingleLevelNum * uiCanGetExtraRewardLevels
        end
        vipRewards[1] = kReward
        -- 注册tips按钮的监听
        if bIsOverLoadLevel then
            local btnTips = objTips:GetComponent(l_DRCSRef_Type.Button)
            if not self.kBtnRegisterRec then
                self.kBtnRegisterRec = {}
            end
            if not self.kBtnRegisterRec[btnTips] then
                self:RemoveButtonClickListener(btnTips)
                self:AddButtonClickListener(btnTips, function()
                    self:OnClickOverLoadLevelRewardTips()
                end)
            end
        end
        bLock = (uiCanGetExtraRewardLevels <= 0) or (not bIsVIP)
    else
        vipRewards = self.allRewards["VIP"][iLevel] or {}
        bLock = (bLevelAchieve ~= true) or (not bIsVIP)
    end
    setRewardHelper(objVIP, vipRewards, bLock, true)
end

-- 点击物品图标
function TreasureBookRewardUI:OnClickItemIcon(obj, itemTypeID, iLevel, bIsRmbReward)
    if not (itemTypeID and self.kBaseInfo and self.allRewards) then
        return
    end
    local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemTypeID)
    if not itemTypeData then
        return
    end
    bIsRmbReward = (bIsRmbReward == true)

    -- 选中状态
    if obj then
        if self.curChooseItemIcon then
            self:FindChild(self.curChooseItemIcon, "Choose"):SetActive(false)
        end
        self:FindChild(obj, "Choose"):SetActive(true)
        self.curChooseItemIcon = obj
    end
    self.kCurChooseItemInfo = {
        ['itemTypeID'] = itemTypeID,
        ['iLevel'] = iLevel,
        ['bIsRmbReward'] = bIsRmbReward,
    }

    local strName = itemTypeData.ItemName or ''
    self.textDetailTitle.text = getRankBasedText(itemTypeData.Rank, strName)
    self.objDetailTitle:SetActive(true)
    self.textDetailType.text = GetEnumText("ItemTypeDetail", itemTypeData.ItemType)
    self.objDetailType:SetActive(true)
    self.textDetailDesc.text = itemTypeData.ItemDesc or ''
    self.objDetailDesc:SetActive(true)
    local uiCustomMaxLevel = self.allRewards.iMaxlLevel or 0  -- 实际的最大等级
    local bIsOverLoadLevel = (iLevel > uiCustomMaxLevel)
    local uiUserLevel = self.kBaseInfo.iLevel or 1
    local strColor = (uiUserLevel < iLevel) and self.strColorCondFalse or self.strColorCondTrue
    local strCond = ""
    if bIsOverLoadLevel then
        strCond = string.format(strColor, string.format("百宝书等级达到%d以上", uiCustomMaxLevel))
    else
        strCond = string.format(strColor, string.format("百宝书等级达到%d", iLevel))
    end
    if (self.kBaseInfo.bRMBPlayer ~= true) and bIsRmbReward then
        strCond = strCond .. string.format(self.strColorCondFalse, "\n开通壕侠版百宝书")
    end
    self.textDetailCond.text = strCond
    self.objDetailCond:SetActive(true)
end

-- 点击百宝书突破奖励tips
function TreasureBookRewardUI:OnClickOverLoadLevelRewardTips()
    OpenWindowImmediately("TipsPopUI", {
        ['title'] = "奖励描述",
        ['titlecolor'] = DRCSRef.Color.white,
        ['content'] = GetLanguageByID(543),
    })
end

-- 点击领取等级奖励
function TreasureBookRewardUI:OnClickGetReward(iLevel)
    if not iLevel then
        return
    end
    SendQueryTreasureBookInfo(STBQT_LVL_REWARD, iLevel)
end

-- 点击一键领取所有奖励
function TreasureBookRewardUI:OnClickGetAll()
    if not self.aiCanGetRewardLevel then
        return
    end
    SendQueryTreasureBookInfo(STBQT_LVL_CAN_REWARD)
    self.objBtnGetAll:SetActive(false)
end

-- 点击获取经验
function TreasureBookRewardUI:OnClickGetExp()
    if not (self._instParent and self._instParent.tableSubViews) then
        return
    end
    local ePage = self._instParent.PageType.Task
    local data = self._instParent.tableSubViews[ePage]
    if not (data and data.toggleInst ) then
        return
    end
    data.toggleInst.isOn = true
    data.toggleInst:Select()
end

-- 点击购买经验
function TreasureBookRewardUI:OnClickBuyExp()
    if not self.kTreasureBook then
        return
    end
    local buyExpCallback = function()
        SendQueryTreasureBookInfo(STBQT_BUY_EXP)
    end
    local iGoldNum = self.kTreasureBook.BuyExpGoldCost or 0
    local iExpValue = self.kTreasureBook.BuyExpDeltaValue or 0
    local msg = string.format("是否花费%d金锭购买%d点壕侠经验?\n（在壕侠版5、25、35、55级时，购买百宝书经验礼包更划算）", iGoldNum, iExpValue)
    local boxCallback = function()
        PlayerSetDataManager:GetInstance():RequestSpendGold(iGoldNum, buyExpCallback)
    end
    OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, msg, boxCallback})
end

-- 请求激活壕侠百宝书
function TreasureBookRewardUI:OnClickActivetion()
    if not self.bookManager then
        return
    end
    self.bookManager:TryToBuyVIPForSelf(function()
        TreasureBookDataManager:GetInstance():RequestActiveBookVIP()
    end)
end

-- 请求 续费/赠送 壕侠百宝书
function TreasureBookRewardUI:OnClickActiveSign()
    OpenWindowImmediately("TreasureBookEarlyBuyUI")
end

-- 设置奖励全览ui
function TreasureBookRewardUI:InitAllRewardUI()
    if not self.allRewards then
        return
    end
    -- 包装数据
    local packedData = {}
    -- 拿到一行显示物品的数量
    local iCountInRow = self.iAllRewardSingRowCount
    -- 插入英雄标题
    packedData[#packedData + 1] = {
        ['type'] = "HeroTitle"
    }
    -- 插入英雄物品
    local rewardsData = self.allRewards["Hero"] or {}
    local itemList = {}
    local iRowCount = 1
    for index, rewardGroup in ipairs(rewardsData) do
        for _, rewardData in ipairs(rewardGroup) do
            if iRowCount > iCountInRow then
                iRowCount = 1
                packedData[#packedData + 1] = {
                    ['type'] = "Items",
                    ['bIsRmb'] = false,
                    ['items'] = itemList,
                }
                itemList = {}
            end
            itemList[#itemList + 1] = {
                ['iLevel'] = index,
                ['kTypeData'] = TableDataManager:GetInstance():GetTableData("Item",rewardData.itemTypeID),
                ['iNum'] = rewardData.itemNum or 0,
            }
            iRowCount = iRowCount + 1
        end
    end
    packedData[#packedData + 1] = {
        ['type'] = "Items",
        ['bIsRmb'] = false,
        ['items'] = itemList,
    }
    -- 插入壕侠标题
    packedData[#packedData + 1] = {
        ['type'] = "VIPTitle"
    }
    -- 插入壕侠物品
    rewardsData = self.allRewards["VIP"] or {}
    itemList = {}
    iRowCount = 1
    for index, rewardGroup in ipairs(rewardsData) do
        for _, rewardData in ipairs(rewardGroup) do
            if iRowCount > iCountInRow then
                iRowCount = 1
                packedData[#packedData + 1] = {
                    ['type'] = "Items",
                    ['bIsRmb'] = true,
                    ['items'] = itemList,
                }
                itemList = {}
            end
            itemList[#itemList + 1] = {
                ['iLevel'] = index,
                ['kTypeData'] = TableDataManager:GetInstance():GetTableData("Item",rewardData.itemTypeID),
                ['iNum'] = rewardData.itemNum or 0,
            }
            iRowCount = iRowCount + 1
        end
    end
    packedData[#packedData + 1] = {
        ['type'] = "Items",
        ['bIsRmb'] = true,
        ['items'] = itemList,
    }
    self.akAllRewardPackedData = packedData
    -- 设置滚动栏数据
    self.svAllRewardLoopView.totalCount = #packedData
    if self.bAllRewardFirstUpdate ~= true then
        self.svAllRewardLoopView:RefillCells()
        self.bAllRewardFirstUpdate = true
    else
        self.svAllRewardLoopView:RefreshCells()
    end
end

-- 更新奖励全览奖励组
function TreasureBookRewardUI:UpdateAllRewardItemGroupUI(transform, index)
    if not (transform and index and self.akAllRewardPackedData[index + 1]) then
        return
    end
    local obj = transform.gameObject
    local objHeroTitle = self:FindChild(obj, "HeroTitle")
    local objVIPTitle = self:FindChild(obj, "VIPTitle")
    local objGroup = self:FindChild(obj, "ItemGroup")
    local transGroup = objGroup.transform
    local iGroupCount = transGroup.childCount
    local kData = self.akAllRewardPackedData[index + 1]
    local type = kData.type

    objHeroTitle:SetActive(false)
    objVIPTitle:SetActive(false)
    objGroup:SetActive(false)

    if type == "HeroTitle" then
        objHeroTitle:SetActive(true)
        return
    end

    if type == "VIPTitle" then
        objVIPTitle:SetActive(true)
        return
    end

    if type == "Items" then
        local itemList = kData.items or {}
        local bIsRmb = kData.bIsRmb == true
        local kItemInfo = nil
        local transItemNode = nil
        local objItemNode = nil
        local textItemNode = nil
        local objIcon = nil
        for i = 1, self.iAllRewardSingRowCount do
            if i <= iGroupCount then
                objItemNode = transGroup:GetChild(i - 1).gameObject
                kItemInfo = itemList[i]
                if kItemInfo and kItemInfo.kTypeData then
                    objIcon = self:FindChild(objItemNode, "Icon")
                    self.ItemIconUI:UpdateUIWithItemTypeData(objIcon, kItemInfo.kTypeData)
                    self.ItemIconUI:SetItemNum(objIcon, kItemInfo.iNum or 0)
                    self:FindChild(objItemNode, "BackHero"):SetActive(not bIsRmb)
                    self:FindChild(objItemNode, "BackVIP"):SetActive(bIsRmb)
                    textItemNode = self:FindChildComponent(objItemNode, "Level", l_DRCSRef_Type.Text)
                    textItemNode.text = string.format("%s级", kItemInfo.iLevel or "?")
                    textItemNode.color = bIsRmb and self.colorAllRewardVIP or self.colorAllRewardHero
                    objItemNode:SetActive(true)
                else
                    objItemNode:SetActive(false)
                end
            end
        end
        objGroup:SetActive(true)
        return
    end
end

-- 打开奖励全览
function TreasureBookRewardUI:OnClickShowAll()
    self.objAllRewards:SetActive(true)
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:SetBackBtnState(false)
    end
end

-- 关闭奖励全览
function TreasureBookRewardUI:CloseShowAll()
    self.objAllRewards:SetActive(false)
    local windowBarUI = GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:SetBackBtnState(true)
    end
end

function TreasureBookRewardUI:OnDestroy()
    self.ItemIconUI:Close()
end

return TreasureBookRewardUI