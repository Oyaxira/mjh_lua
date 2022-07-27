ShowAllChooseGoodsUI = class("ShowAllChooseGoodsUI",BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function ShowAllChooseGoodsUI:ctor()
    self.ItemIconUIInst = ItemIconUI.new()
end

function ShowAllChooseGoodsUI:Create()
	local obj = LoadPrefabAndInit("CommonUI/ShowAllChooseGoodsUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ShowAllChooseGoodsUI:OnPressESCKey()
    if self.closeBtn then
        self.closeBtn.onClick:Invoke()
    end
end

function ShowAllChooseGoodsUI:Init()
    self.objBoard = self:FindChild(self._gameObject, "Board")
    self.loopScrollView = self:FindChildComponent(self.objBoard, "LoopScrollView", DRCSRef_Type.LoopVerticalScrollRect)
    self.loopScrollView:AddListener(function(...) 
        self:UpdateViewAllItemUI(...)
    end)

    self.windowTitle = self:FindChildComponent(self._gameObject, "PopUpWindow_4/Board/Bottom/Top/Title", "Text")
    self.windowTips = self:FindChildComponent(self.objBoard, "Text_tip", "Text")

    self.closeBtn = self:FindChildComponent(self._gameObject, "newFrame/Btn_exit", DRCSRef_Type.Button)
    self:AddButtonClickListener(self.closeBtn, function()
        RemoveWindowImmediately("ShowAllChooseGoodsUI")
    end)
    self.cancleBtn = self:FindChildComponent(self.objBoard, "Button/Cancel", DRCSRef_Type.Button)
    self:AddButtonClickListener(self.cancleBtn, function()
        RemoveWindowImmediately("ShowAllChooseGoodsUI")
    end)
    self.commitBtn = self:FindChildComponent(self.objBoard, "Button/Commit", DRCSRef_Type.Button)
    
    self.platInfo = globalDataPool:getData("ItemPool") or {}
    self.storageInfo = StorageDataManager:GetInstance()
end

function ShowAllChooseGoodsUI:UpdateViewAllItemUI(transform, index)
    if not (transform and index) then
        return
    end
    local goodsData = self.goodsList[index+1]
    self:UpdateItemIcon(transform.gameObject, goodsData)
end

function ShowAllChooseGoodsUI:UpdateItemIcon(objIcon, kItemInstData)
    if not (objIcon and kItemInstData) then
        return
    end
    local icon = self:FindChild(objIcon, "Icon")
    self.ItemIconUIInst:UpdateUIWithItemInstData(icon, kItemInstData)
    self.ItemIconUIInst:ShowExtraName(icon,true)
    local iNum = kItemInstData.igoodsNum
    if (not iNum) or (iNum <= 1) then
        self.ItemIconUIInst:HideItemNum(icon)
    else
        self.ItemIconUIInst:SetItemNum(icon, iNum)
    end
    local objName = self:FindChild(objIcon, "Name")
    objName:SetActive(false)
    local objNewSign = self:FindChild(objIcon, "NewSign")
    objNewSign:SetActive(false)
    self.ItemIconUIInst:AddClickFunc(icon,function()
        local tips = TipsDataManager:GetInstance():GetItemTips(kItemInstData.uiID or 0)
        if not tips then
            return
        end
        local btns = {
            [1] = {
            ['name'] = "取消",
            ['func'] = function()
                -- 取消操作某个item
                if self.removeItemFunc then
                    -- 从打开界面绑定的回调会自动刷新自己的界面和数据
                    self.removeItemFunc(kItemInstData.uiID,iNum)
                    -- 自动刷新自己的数据 物品list和tipstext
                    -- 为了继续能使用index和# 将整体前移
                    local find = false
                    local index = 0
                    for i=1,#self.goodsList do
                        if self.goodsList[i].uiID == kItemInstData.uiID then
                            self.goodsList[i] = nil
                            find = true
                            index = i-i%7
                        end
                        if find and self.goodsList[i+1] then
                            self.goodsList[i] = self.goodsList[i+1]
                        end
                        if i == #self.goodsList then
                            self.goodsList[i] = nil
                        end
                    end
                    self.loopScrollView.totalCount = #self.goodsList
                    self.loopScrollView:RefillCells(index)
                    if self.getNewWindowTips then
                        self.windowTips.text = self.getNewWindowTips()
                    end
                    if #self.goodsList == 0 then
                        RemoveWindowImmediately("ShowAllChooseGoodsUI")
                    end
                end
            end}
        }
        tips.buttons = btns
        OpenWindowImmediately("TipsPopUI", tips)
    end)
end


function ShowAllChooseGoodsUI:RefreshUI(info)
    self.goodsList = {}
    if GetGameState() == -1 then
        for i=1,#info.goodsList do
            self.goodsList[i] = self.storageInfo:GetItemData(info.goodsList[i])
            self.goodsList[i]["igoodsNum"] = info.goodsNumList[i]
        end
    else
        for i=1,#info.goodsList do
            self.goodsList[i] = self.platInfo[info.goodsList[i]]
            self.goodsList[i]["igoodsNum"] = info.goodsNumList[i]
        end
    end
    -- 增加排序
    -- 规则：
    -- 1 银锭(通灵玉)>精铁>完美粉
    -- 2 品质 Rank
    -- 3 类型：装备>秘籍>其他 ItemType
    -- 4 强化等级 
   
    -- uiPerfectPower
    -- uiSpendIron
    -- uiEnhanceGrade
    -- uiTypeID
    local TBItem = TableDataManager:GetInstance():GetTable("Item") 
    local itemDataMgr = ItemDataManager:GetInstance()
    local sort_func = function(a, b)
        -- 银锭消耗 = 通灵玉消耗
        if a.uiSpendTongLingYu > 0 or b.uiSpendTongLingYu > 0 then
            if a.uiSpendTongLingYu ~= b.uiSpendTongLingYu then
                return a.uiSpendTongLingYu > b.uiSpendTongLingYu
            end
        end
        -- 精铁消耗
        if a.uiSpendIron > 0 or b.uiSpendIron > 0 then
            if a.uiSpendIron ~= b.uiSpendIron then
                return a.uiSpendIron > b.uiSpendIron
            end
        end
        -- 完美粉消耗
        if a.uiPerfectPower>0 or b.uiPerfectPower>0 then
            if a.uiPerfectPower ~= b.uiPerfectPower then
                return a.uiPerfectPower > b.uiPerfectPower
            end
        end
        local typeDataA = TBItem[a.uiTypeID]
        local typeDataB = TBItem[b.uiTypeID]
        if typeDataA and typeDataB then
            -- 品质
            if typeDataA.Rank ~= typeDataB.Rank then
                return typeDataA.Rank > typeDataB.Rank
            end
            -- 类型
            if typeDataA.ItemType ~= typeDataB.ItemType then
                local aTypeIndex = 1
                local bTypeIndex = 1
                if itemDataMgr:IsTypeEqual(typeDataA.ItemType,ItemTypeDetail.ItemType_Equipment) then
                    aTypeIndex = 3
                end
                if itemDataMgr:IsTypeEqual(typeDataA.ItemType,ItemTypeDetail.ItemType_Book) then
                    aTypeIndex = 2
                end
                if itemDataMgr:IsTypeEqual(typeDataB.ItemType,ItemTypeDetail.ItemType_Equipment) then
                    bTypeIndex = 3
                end
                if itemDataMgr:IsTypeEqual(typeDataB.ItemType,ItemTypeDetail.ItemType_Book) then
                    bTypeIndex = 2
                end
                if aTypeIndex ~= bTypeIndex then
                    return aTypeIndex > bTypeIndex
                end
            end
            -- 强化等级
            if a.uiEnhanceGrade ~= b.uiEnhanceGrade then
                return a.uiEnhanceGrade > b.uiEnhanceGrade
            end
            -- 默认按id排序
            return typeDataA.BaseID > typeDataB.BaseID
        else
            return false
        end
    end
    table.sort(self.goodsList,sort_func)

    self.loopScrollView.totalCount = #self.goodsList
    self.loopScrollView:RefillCells()
    self.windowTitle.text = "【"..info.windowTitle.."】"
    self.windowTips.text = info.windowTips
    self:RemoveButtonClickListener(self.commitBtn)
    self:AddButtonClickListener(self.commitBtn, function()
        info.commitCallback()
        RemoveWindowImmediately("ShowAllChooseGoodsUI")
    end)
    if info.removeItemCallback then
        self.removeItemFunc = info.removeItemCallback
    end
    if info.getNewWindowTips then
        self.getNewWindowTips = info.getNewWindowTips
    end    
end

function ShowAllChooseGoodsUI:Update()
    
end

function ShowAllChooseGoodsUI:OnDestroy()
    self.ItemIconUIInst:Close()
end

return ShowAllChooseGoodsUI
