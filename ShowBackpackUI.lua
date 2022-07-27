-- 任务提交 需要展示背包
ShowBackpackUI = class("ShowBackpackUI",BaseWindow)
local BackpackUICom = require 'UI/Role/BackpackUI'

function ShowBackpackUI:ctor()

end

function ShowBackpackUI:Create()
	local obj = LoadPrefabAndInit("Role/ShowBackpackUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function ShowBackpackUI:Init()
    self.objBase = self:FindChild(self._gameObject,"Pack")
    self.objLoopScrollView = self:FindChild(self.objBase, "LoopScrollView")
    self.comButton_close = self:FindChildComponent(self._gameObject,"newFrame/Btn_exit", "Button")
	if self.comButton_close then
        self:AddButtonClickListener(self.comButton_close, function()
            self:Submit(false)
		end)
    end
    self.comButton_submit = self:FindChildComponent(self.objBase, "Button_submit", 'Button')
    if self.comButton_submit then
        self:AddButtonClickListener(self.comButton_submit, function()
            self:Submit(true)
        end)
    end
    self.comButton_submit_Img =  self:FindChildComponent(self.objBase, "Button_submit", 'Image')
    self.BackpackUICom = BackpackUICom.new(self._gameObject, nil, {
        {
            ['text'] = "全部",
            ['types'] = {ItemTypeDetail.ItemType_Null,}
        },
    }, true)
    self.comText_bottom = self:FindChildComponent(self.objBase, "Text_bottom", 'Text')
    self.comText_bottom.gameObject:SetActive(true)

    self.comText_disable = self:FindChildComponent(self.objBase, "Text_disable", 'Text')
    self.comText_disable.gameObject:SetActive(false)

    self.objNavBox = self:FindChild(self.objBase, 'nav_box')
end

function ShowBackpackUI:RefreshUI(info)
    if not info then return end
    self.taskID = info.taskID
    self.taskEdgeID = info.taskEdgeID       -- 提交物品的当前任务边
    self.conditionID = info.conditionID     -- [1] 提交条件物品
    self.filterBackpack = nil                -- [1] 提交条件筛选后的物品
    self.itemIDs = info.itemIDs             -- [2] 提交特定物品的ID数组 {}
    self.itemNums = info.itemNums           -- [1][2] 提交物品的数量 {}
    self.descID = info.descID               -- [1][2] 提交物品的描述

    self.itemTotalNum = 0                   -- 当前Step选中多少物品
    self.chooseItems = {}                   -- 当前Step选中物品数组
    self.finalNum = 0                       -- 最终提交物品数量
    self.finalSubmit = {}                   -- 最终提交物品数组
    self.step = 0                           -- 当前步

    if self.conditionID then
        self:UpdateShowItem()
    end
    if not self.filterBackpack then 
        local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
        self.filterBackpack = ItemDataManager:GetPackageItems(mainRoleID,mainRoleID)
    end 

    local func_info = function(obj, itemID) 
        self.BackpackUICom:SetClickItem(obj, itemID, PICKITEM_TYPE.PI_INFO) 
    end
    local func_icon = function(obj, itemID)
        self.BackpackUICom:SetClickItem(obj, itemID, PICKITEM_TYPE.PI_ICON)
    end 
    local func_traceback = function(total, items)
        self.itemTotalNum = total        -- total 总共选了多少物品了
        self.chooseItems = items         -- items {} 存 itemID num 的数组
        self:RefreshRequireText()
    end
    self.BackpackUICom:SetClickFunc(func_info, func_icon)
    self.BackpackUICom:SetOnChooseUpdateCallback(func_traceback)

    self:StepShow()

    -- 显示任务提交界面的时候关闭快进对话
    DialogRecordDataManager:GetInstance():SetFastChatState(false)
end

function ShowBackpackUI:UpdateShowItem()
    local taskShowItem = globalDataPool:getData("TaskShowItem") or {}
    if not taskShowItem then return end
    if taskShowItem['uiConditionNum'] then
        self.itemNums =  { taskShowItem.uiConditionNum }
    end
    if taskShowItem['acCondDescID'] then
        self.descID = taskShowItem.acCondDescID
    end
    if taskShowItem['auItems'] then     -- TODO：目前条件提交不考虑连续提交
        self.filterBackpack = table_c2lua(taskShowItem['auItems'])
    end
end

function ShowBackpackUI:RefreshRequireText()
    local string_text = ''
    if self.descID and (self.descID > 0) then
        string_text = GetLanguageByID(self.descID, self.taskID)
    end
    if string_text == '' and self.itemIDs and self.itemIDs[self.step] then
        local itemID = self.itemIDs[self.step]
        local itemTypeData = ItemDataManager:GetInstance():GetItemTypeDataByTypeID(itemID)
        if itemTypeData then
            string_text = itemTypeData.ItemName or ''
        end
    end
    self.comText_bottom.text = string.format( "任务要求:%s(%d/%d)", string_text, self.itemTotalNum, self.itemNeedNum)
    if self.itemTotalNum < self.itemNeedNum then
        self.comText_bottom.color = UI_COLOR.darkgray
        setUIGray(self.comButton_submit_Img,true)
        self.comButton_submit.interactable = false
    else
        self.comText_bottom.color = UI_COLOR.darkgray
        setUIGray(self.comButton_submit_Img,false)
        self.comButton_submit.interactable = true
    end
end

-- 队列：提交下一个物品
function ShowBackpackUI:StepShow()
    self.step = self.step + 1
    self.itemNeedNum = 1        -- 当前Step需要多少物品

    if self.itemNums then
        local cond
        local num = self.itemNums[self.step]
        self.itemNeedNum = num or 1
        if self.itemIDs and self.itemIDs[self.step] then
            cond = self.itemIDs[self.step]
        end

        local bIsTaskItemCond = false
        if cond then
            local kItemData = TableDataManager:GetInstance():GetTableData("Item", cond)
            if kItemData then
                if kItemData.OrigItemID and (kItemData.OrigItemID > 0) then
                    cond = kItemData.OrigItemID
                end
                bIsTaskItemCond = (kItemData.ItemType == ItemTypeDetail.ItemType_Task)
            end
        end

        local kItemMgr = ItemDataManager:GetInstance()
        local funcSort = function(a, b)
            local kBaseItemA = kItemMgr:GetItemTypeData(a or 0)
            local kBaseItemB = kItemMgr:GetItemTypeData(b or 0)
            if (not kBaseItemA) or (not kBaseItemB) then
                return (kBaseItemA ~= nil)
            elseif kBaseItemA.Rank == kBaseItemB.Rank then
                return kBaseItemA.BaseID < kBaseItemB.BaseID
            else
                return kBaseItemA.Rank < kBaseItemB.Rank
            end
        end

        self:RefreshRequireText()
        self.BackpackUICom:SetPackLockState(not bIsTaskItemCond)
        self.BackpackUICom:SetChooseNum(num)
        self.BackpackUICom:ResetBackpackShowModel()
        self.BackpackUICom:ResetChooseItem(false)
        self.BackpackUICom:UpdateBackpack(self.filterBackpack, cond, funcSort, true)
        -- self.BackpackUICom:SetPackLockState((not cond) or (cond == 0) or (self.BackpackUICom:GetFilterCount() > 1))

        if self.BackpackUICom:GetFilterCount() == 0 then
            -- 表示一类物品
            if  cond == nil or cond == 0 or num == 0 then
                self.comText_disable.gameObject:SetActive(true)
                self.objLoopScrollView:SetActive(false)
            else
                -- 确定的物品，如木剑，黑礁牛仔骨，这种就把灰化的图标显示出来就好了
                self.comText_disable.gameObject:SetActive(false)
                self.objLoopScrollView:SetActive(true)
                self.BackpackUICom:ShowTaskItem(cond)
            end
        else
            self.comText_disable.gameObject:SetActive(false)
            self.objLoopScrollView:SetActive(true)
            self.BackpackUICom:SetAutoSelectItemFlag()
        end
    end
end

function ShowBackpackUI:Update()
    self.BackpackUICom:Update()
end

function ShowBackpackUI:OnEnable()
    self.BackpackUICom:OnEnable()
end

function ShowBackpackUI:OnDisable()
    self.BackpackUICom:OnDisable()
end

function ShowBackpackUI:Submit(isSubmit)
    -- 等待下行时不允许点击
    if g_isWaitingDisplayMsg then 
        return
    end
    -- 将当前选中的物品进行组装
    if isSubmit and self.chooseItems then
        for i = 1, #self.chooseItems do
            local auItems = {}
            auItems.uiItemID = self.chooseItems[i].itemID
            auItems.uiItemNum = self.chooseItems[i].num
            table.insert(self.finalSubmit, auItems)
        end
        self.finalNum = self.finalNum + self.itemTotalNum   -- 这个finalNum没用
    end

    -- 如果已经提交完成，或者 isSubmit 为 false，则发送网络协议
    -- 否则继续进行 StepShow
    if isSubmit and self.itemIDs and #self.itemIDs > self.step then
        self.itemTotalNum = 0
        self:StepShow()
    elseif self.finalSubmit ~= nil then
        local iNum = #self.finalSubmit
        self.finalSubmit = table_lua2c(self.finalSubmit)
        SendSelectSubmitItem(self.taskID, self.taskEdgeID, iNum, self.finalSubmit)
        AddLoadingDelayRemoveWindow('ShowBackpackUI', true)
    end
end

function ShowBackpackUI:OnDestroy()
    self.BackpackUICom:Close()  -- 非常重要，否则 netGame - event 会使已经移除的界面还触发监听
end

function ShowBackpackUI:OnPressESCKey()
    if self.comButton_close then
	    self.comButton_close.onClick:Invoke()
    end

end


return ShowBackpackUI