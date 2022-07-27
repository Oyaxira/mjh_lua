GiveGiftDialogUI = class("GiveGiftDialogUI", BaseWindow)
local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'

local ItemTypeTags = {
    [1] = nil,
    [2] = ItemTypeDetail.ItemType_Equipment,
    [3] = ItemTypeDetail.ItemType_Consume,
    [4] = ItemTypeDetail.ItemType_Book,
    [5] = ItemTypeDetail.ItemType_Material,
}

function GiveGiftDialogUI:ctor()
    self.ItemInfoUI = ItemInfoUI.new()
end

function GiveGiftDialogUI:Create()
    local obj = LoadPrefabAndInit("Role/GiveGiftDialogUI",UI_UILayer,true)
    if obj then
        self:SetGameObject(obj)
    end
end

function GiveGiftDialogUI:OnDisable()
    self:RemoveEventListener("UPDATE_DISPLAY_ROLEITEMS")
    self:RemoveEventListener("UPDATE_ITEM_LOCK_STATE")
    self:RemoveEventListener("DISPLAY_GIVE_GIFT_RESOULT")
    local winDialogRec = GetUIWindow("DialogControlUI")
	if winDialogRec then
		winDialogRec:ShowBtns()
	end
end

function GiveGiftDialogUI:OnEnable()
    local winDialogRec = GetUIWindow("DialogControlUI")
	if winDialogRec then
		winDialogRec:HideBtns()
	end
    self:AddEventListener("UPDATE_DISPLAY_ROLEITEMS", function() self:UpdateBackpack() end)
    self:AddEventListener("UPDATE_ITEM_LOCK_STATE", function() self:UpdateBackpack() end)
    self:AddEventListener("DISPLAY_GIVE_GIFT_RESOULT", function(kRetStreasm)
        if  self.roleData == nil then
            return
        end
        
        local name = RoleDataHelper.GetName(self.roleData, self.dbRoleData)
        if kRetStreasm.iResoult == 0 then 
           -- xx的好感度已经无法提升了
            local itemTypeData = ItemDataManager:GetInstance():GetItemTypeData(self.lastGiveItemID)
            local itemName = 'error'
            if itemTypeData then
                itemName = itemTypeData.ItemName or ''
            end
            local disData = RoleDataManager:GetInstance():GetDispotionDataToMainRole(self.targetRoleID)
            if disData and disData.iValue >= 99 then
                DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, true, name .. '的好感度已经无法提升了')
            else
                DisplayActionManager:GetInstance():AddAction(DisplayActionType.PLOT_TOAST, true, name .. '似乎并不稀罕你送的' .. itemName)
            end
        else      
            --SystemUICall:GetInstance():Toast(name .. '的好感度增加' .. tostring(kRetStreasm.iResoult))
        end

        self:UpdateBackpack()
    end)
end

function GiveGiftDialogUI:Init()
   
    self:InitListener()
    
    self.auiItemIDList = {}
    self.comLoopScroll.totalCount = 0
end

function GiveGiftDialogUI:RefreshUI(targetRoleID)
    self.targetRoleID = targetRoleID
    self.roleData = RoleDataManager:GetInstance():GetRoleData(self.targetRoleID)
    self.dbRoleData = TB_Role[self.roleData.uiTypeID]
       
    self:UpdateBackpack(1)
    local objMissionToggle = self:FindChild(self._gameObject, 'nav_box/6')
    objMissionToggle:SetActive(false)
end

function GiveGiftDialogUI:OnDestroy()
    self.ItemInfoUI:Close()
end

function GiveGiftDialogUI:InitListener()    
    self.comLoopScroll = self:FindChildComponent(self._gameObject, 'LoopScrollView', 'LoopVerticalScrollRect')
    self.objLoopScrollContentTrans = self:FindChild(self._gameObject, 'LoopScrollView/Content').transform
    self.comLoopScroll:AddListener(function(...) self:UpdateItemUI(...) end)

    self.comCloseButton = self:FindChildComponent(self._gameObject, 'newFrame/Btn_exit', 'Button')
    if self.comCloseButton then
        self:RemoveButtonClickListener(self.comCloseButton)
		self:AddButtonClickListener(self.comCloseButton,function()
			RemoveWindowImmediately("GiveGiftDialogUI", false)
		end)
    end
    
    for i=1,5 do
        local comToggle = self:FindChildComponent(self._gameObject, 'nav_box/' .. i, 'Toggle')
        local textClone = self:FindChildComponent(comToggle.gameObject, "Text", "Text")
        self:RemoveToggleClickListener(comToggle)
        self:AddToggleClickListener(comToggle, function(ison)
            if ison then
                textClone.color = DRCSRef.Color.white
                self:UpdateBackpack(i)
            else
                textClone.color = DRCSRef.Color(0.2,0.2,0.2,1)
            end
        end)

        if i == 1 then
            comToggle.isOn = true
        end
    end
end

function GiveGiftDialogUI:OnPressESCKey()
    if self.comCloseButton then
	    self.comCloseButton.onClick:Invoke()
    end
end
function GiveGiftDialogUI:UpdateItemUI(transform, index)
    local itemID = self.auiItemIDList[index + 1] or 0
    local itemData = ItemDataManager:GetInstance():GetItemData(itemID)
    if itemData then
        local itemTypeData = TableDataManager:GetInstance():GetTableData("Item",itemData.uiTypeID)
        self.ItemInfoUI:UpdateUIWithItemInstData(transform.gameObject, itemData, true, true)

        local comButton = self:FindChildComponent(transform.gameObject, 'Button', 'Button')

        local callback = function()
            local tips = TipsDataManager:GetInstance():GetItemTips(itemID)
            if not tips then
                return
            end
            tips.buttons = {}
            local itemMgr = ItemDataManager:GetInstance()
            local bIsItemLock = (itemMgr:GetItemLockState(itemID) == true)
            if not itemMgr:ItemHasLockFeature(itemID) then
                local btnName = nil
                local btnFunc = nil
                if bIsItemLock then
                    btnName = "解锁"
                    btnFunc = function()
                        itemMgr:SetItemLockState(itemID, false)
                    end
                else
                    btnName = "锁定"
                    btnFunc = function()
                        itemMgr:SetItemLockState(itemID, true)
                    end
                end
                local lockButtonInfo = {
                    ['name'] = btnName,
                    ['func'] = btnFunc
                }
                table.insert(tips.buttons, lockButtonInfo)
            end
            if bIsItemLock ~= true then
                local iItemNum = ItemDataManager:GetInstance():GetItemNum(itemID) or 0
                local giveGiftButtonInfo = {
                    ["name"] = "赠送",
                    ['func'] = function(iNum)
                        if self.targetRoleID then
                            self.lastGiveItemID = itemID
                            SendNPCInteractOperCMD(NPCIT_GIFT, self.targetRoleID, itemID)
                        end
                    end,
                     -- 物品数量
                    ['iNum'] = iItemNum,
                }
                table.insert(tips.buttons, giveGiftButtonInfo)
            end
            OpenWindowImmediately("TipsPopUI", tips)
        end
        self.ItemInfoUI:AddClickFunc(transform.gameObject, callback, callback)
    else
        self.ItemInfoUI:SetItemUIActiveState(transform.gameObject, false)
    end
end

-- 获取当前滚动栏能显示的最大节点个数
function GiveGiftDialogUI:GetSCVMaxNodeNum()
    if not self.SCVMaxNodeNum then
        local objSCNode = self:FindChild(self._gameObject, "Pack/LoopScrollView")
        local iSCHeight = objSCNode:GetComponent("RectTransform").rect.height or 0
        local comContentLayout = self:FindChildComponent(objSCNode, "Content", "GridLayoutGroup")
        local iCellHeight = comContentLayout.cellSize.y + comContentLayout.spacing.y
        local maxNum = math.floor(iSCHeight / iCellHeight)
        self.SCVConstraintCount = comContentLayout.constraintCount
        self.SCVMaxNodeNum = maxNum * self.SCVConstraintCount
    end
    return (self.SCVMaxNodeNum or 0), (self.SCVConstraintCount or 0)
end

function GiveGiftDialogUI:UpdateBackpack(tagidx, bsort)
    if  self.dbRoleData == nil then
        return
    end

    local reFill = true
    bsort = true

    if tagidx then
        self.lastTagIdx = tagidx
    else
        tagidx = self.lastTagIdx or 1
        self.lastTagIdx = tagidx
        reFill = false
    end

    self.auiItemIDList = RoleDataHelper.GetMainRoleItemsByType(ItemTypeTags[tagidx], true)

    if bsort then
        self.FavorItem = {}
        self.OtherItem = {}
        self.RubbishItem = {}
        -- 先按品质排序  然后再喜好排序 ( 优先喜好 ,剩下各区间按品质排序)

        --1..物品按照喜好类型排序
        for index, itemID in pairs(self.auiItemIDList) do
            local itemData = ItemDataManager:GetInstance():GetItemTypeData(itemID)
            local bFavor = false
            local bRubbish = false
            local category = itemData.Present
            local favors = self.dbRoleData.Favor or {}
            for index, favar in ipairs(favors) do
                if category == favar then
                    bFavor = true
                end
                if (category == FavorType.FT_Null) 
                or (category == FavorType.FT_Rubbish)
                or (category == FavorType.FT_FavorNull) then
                    bRubbish = true
                end
            end
            
            if bFavor then
                table.insert(self.FavorItem,itemID)
            elseif bRubbish then
                table.insert(self.RubbishItem,itemID)
            else
                table.insert(self.OtherItem,itemID)
            end
        end

        local sortFunc = function(itemID1,itemID2)
            if itemID1 == nil or itemID2 == nil then
                return true
            end
           
            --2..品质从高到低排序
            local itemData1 = ItemDataManager:GetInstance():GetItemTypeData(itemID1)
            local itemData2 = ItemDataManager:GetInstance():GetItemTypeData(itemID2)
            if itemData1 == nil or itemData2 == nil then
                return true
            end

            local tempPresent1= itemData1.Present
            local tempPresent2= itemData2.Present

            if (tempPresent1 == FavorType.FT_Null) 
            or (tempPresent1 == FavorType.FT_FavorNull) then
                tempPresent1 = FavorType.FT_Rubbish
            end

            if (tempPresent2 == FavorType.FT_Null) 
            or (tempPresent2 == FavorType.FT_FavorNull) then
                tempPresent2 = FavorType.FT_Rubbish
            end
            
            if tempPresent1 == nil or tempPresent2 == nil then
                return true
            end
            if tempPresent1 ==  tempPresent2 then
                if itemData1.Rank == itemData2.Rank then
                    return itemData1.BaseID > itemData2.BaseID
                else
                    return itemData1.Rank > itemData2.Rank
                end
            else
                return tempPresent1 > tempPresent2
            end
          
        end

        table.sort(self.FavorItem, sortFunc)
        table.sort(self.OtherItem, sortFunc)
        table.sort(self.RubbishItem, sortFunc)

        self.auiItemIDList = {}
        for index = 1, #self.FavorItem do
            table.insert(self.auiItemIDList,self.FavorItem[index])
        end
        for index = 1, #self.OtherItem do
            table.insert(self.auiItemIDList,self.OtherItem[index])
        end
        for index = 1, #self.RubbishItem do
            table.insert(self.auiItemIDList,self.RubbishItem[index])
        end
    end
    
    if reFill then
        local dataCount = getTableSize(self.auiItemIDList) 
        local maxCountOnePage, constraintCount = self:GetSCVMaxNodeNum()
        
        local showCount = 0
        if dataCount < maxCountOnePage then
            showCount = maxCountOnePage
        else
            showCount = math.ceil(dataCount/constraintCount) * constraintCount
        end
        
        self.comLoopScroll.totalCount = showCount
    end

    if reFill then
        self.comLoopScroll:RefillCells()
    else
        self.comLoopScroll:RefreshCells()
    end
    
end

return GiveGiftDialogUI