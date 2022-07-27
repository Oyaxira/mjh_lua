ItemInfoUI = class("ItemInfoUI", BaseWindow)
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

-- ItemInfoUI设计为只允许传入Item数据来初始化ui, 不再允许使用传入id和类型的表意不明的方法来动态获取数据
local l_DRCSRef_Type = DRCSRef_Type
function ItemInfoUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
end

function ItemInfoUI:OnDestroy()
    self.ItemIconUI:Close()
end

-- FIXME 某些ui不需要将委托保存在这里, 所有有了这个临时方法
function ItemInfoUI:SetCanSaveButton(canSaveBtn)
    self.canSaveBtn = canSaveBtn
    self.ItemIconUI:SetCanSaveButton(canSaveBtn)
end

function ItemInfoUI:SetItemUIActiveState(obj, bActive)
    bActive = bActive == true
    -- icon
    local objItemIcon = self:FindChild(obj, "Button/ItemIconUI")
    self:FindChild(objItemIcon, "Icon"):SetActive(bActive)
    self:FindChild(objItemIcon, "iconex"):SetActive(bActive)
    self:FindChild(objItemIcon, "Num"):SetActive(bActive)
    self:FindChild(objItemIcon, "Lock"):SetActive(false)
    self:FindChild(objItemIcon, "Time"):SetActive(false)
    if not bActive then
        self.ItemIconUI:UpdateIconFrame(objItemIcon, RankType.RT_White, true)
    end
    -- self node
    self:FindChild(obj, "New"):SetActive(bActive)
    self:FindChild(obj, "Price"):SetActive(bActive)
    self:FindChild(obj, "Name"):SetActive(bActive)
    self:FindChild(obj, "Category"):SetActive(bActive)
    self:FindChild(obj, "Replenish"):SetActive(bActive)
    self:FindChild(obj, "Equip"):SetActive(bActive)
    self:FindChild(obj, "Owner"):SetActive(bActive)
    self:FindChild(obj, "Inadequate"):SetActive(bActive)
    self:FindChild(obj, "Producible"):SetActive(bActive)
    self:FindChild(obj, "Button/Toggle_BG"):SetActive(false)
    -- clear listener
    self:RemoveClickFunc(obj)
end

-- 使用物品实例数据来初始化ui
function ItemInfoUI:UpdateUIWithItemInstData(obj, kItemData, showLockState,bAsPresent, categoryName)
    if not (obj and kItemData) then
        return
    end

    if bAsPresent == nil then
        bAsPresent = false
    end

    local itemID = kItemData.uiID
    local uiTypeID = kItemData.uiTypeID
    local kItemTypeData = TableDataManager:GetInstance():GetTableData("Item",uiTypeID)

    self:SetItemUIActiveState(obj, true)
    SetUIntDataInGameObject(obj, 'itemID', kItemData.uiID)
    self:UpdateItemName(obj, kItemData, kItemTypeData)
    self:UpdateItemIcon(obj, kItemData, kItemTypeData, showLockState)
    self:UpdateItemCategory(obj, kItemTypeData,bAsPresent, categoryName)
    self:UpdateItemState(obj, kItemData)
    if showLockState then 
        local isItemLock = ItemDataManager:GetInstance():GetItemLockState(itemID)
        self:UpdateLockState(obj, isItemLock)
    end
end

-- 使用物品静态数据来初始化ui
function ItemInfoUI:UpdateUIWithItemTypeData(obj, kItemTypeData, showLockState,bAsPresent, categoryName)
    if not (obj and kItemTypeData) then
        return
    end

    if bAsPresent == nil then
        bAsPresent = false
    end

    self:SetItemUIActiveState(obj, true)
    SetUIntDataInGameObject(obj, 'itemID', kItemTypeData.BaseID)
    self:UpdateItemName(obj, nil, kItemTypeData)
    self:UpdateItemIcon(obj, nil, kItemTypeData)
    self:UpdateItemCategory(obj, kItemTypeData,bAsPresent, categoryName)
    self:UpdateItemState(obj)
end

function ItemInfoUI:UpdateItemName(obj, kItemData, kItemTypeData)
    if not kItemTypeData then 
        return
    end
    local comNameText = self:FindChildComponent(obj, 'Name', l_DRCSRef_Type.Text)
    local itemDataManager = ItemDataManager:GetInstance()
    local itemName = itemDataManager:GetItemName(kItemData and kItemData.uiID, kItemTypeData.BaseID)
    if comNameText then 
        local strName = tostring(itemName)
        if DEBUG_MODE then
            strName = strName .. '(' .. kItemTypeData.BaseID .. ')'
        end
        comNameText.text = strName
        comNameText.color = getRankColor(kItemTypeData.Rank)
    end
end

function ItemInfoUI:UpdateItemIcon(obj, kItemData, kItemTypeData, showLockState)
    local objButton = self:FindChild(obj, "Button")
    local objItemIcon = self:FindChild(objButton, "ItemIconUI")
    if not objItemIcon then
        return
    end 
    if kItemData then
        self.ItemIconUI:UpdateUIWithItemInstData(objItemIcon, kItemData, showLockState)
    elseif kItemTypeData then
        self.ItemIconUI:UpdateUIWithItemTypeData(objItemIcon, kItemTypeData)
    end
end

-- 设置物品价格标签
function ItemInfoUI:SetItemPrice(obj, uiNum, strIcon)
    local objPrice = self:FindChild(obj, 'Price')
    local objCategory = self:FindChild(obj, 'Category')
    local objImgYingDing = self:FindChild(objPrice, "ImageYingDing")
    local objImgTongBi = self:FindChild(objPrice, "ImageTongBi")
    local objImageOther = self:FindChild(objPrice, "ImageOther")

    objCategory:SetActive(false)
    objPrice:SetActive(true)
    if strIcon then
        if  strIcon ~= "silver" then
            objImgYingDing:SetActive(false)
            objImgTongBi:SetActive(false)
            objImageOther:SetActive(true)
            local imgOhter =  objImageOther.transform:GetComponent("Image")
            imgOhter.sprite = GetSprite(strIcon)
            --imgOhter:SetNativeSize()
        end
    else
        local bShowSilverIcon = (strIcon == "silver")
        objImgYingDing:SetActive(bShowSilverIcon)
        objImgTongBi:SetActive(not bShowSilverIcon)
        objImageOther:SetActive(false)
    end
  
    local comPriceText = self:FindChildComponent(objPrice, 'Text', l_DRCSRef_Type.Text)
    comPriceText.text = tostring(uiNum)
end

function ItemInfoUI:UpdateItemCategory(obj, kItemTypeData, bAsPresent, categoryName)
    if not (obj and kItemTypeData) then
        return
    end
    local objPrice = self:FindChild(obj, 'Price')
    objPrice:SetActive(false)
    local objCategory = self:FindChild(obj, 'Category')
    local category = nil
    if not categoryName then
        categoryName = ""
        if bAsPresent == true then
            category = kItemTypeData.Present
            -- 垃圾物品在送礼的时候不要显示垃圾!
            if (category == FavorType.FT_Null) 
            or (category == FavorType.FT_Rubbish)
            or (category == FavorType.FT_FavorNull) then
                categoryName = ""
            else
                categoryName = GetEnumText("FavorType", category)
            end
        else
            category = kItemTypeData.ItemType
            categoryName = GetEnumText("ItemTypeDetail", category)
        end
    end
    local comText = objCategory:GetComponent("Text")
    comText.text = categoryName
    objCategory:SetActive(true)
end

function ItemInfoUI:UpdateItemState(obj, kItemData)
    if not obj then
        return
    end
    local itemDataManager = ItemDataManager:GetInstance()

    -- 是否装备中
    local objTemp = self:FindChild(obj, "Equip")
    if objTemp then
        objTemp:SetActive(false)
    end
    local comNameText = self:FindChildComponent(obj, "Owner","Text")
    local bEquiped = false
    local strName = ""
    local uiRoleID = 0
    if kItemData then
        bEquiped,uiRoleID = itemDataManager:IsItemEquipedByRole(kItemData.uiID)
        if bEquiped then
            strName = RoleDataManager:GetInstance():GetRoleName(uiRoleID)
        end
    end 
    if comNameText then
        comNameText.text = strName
    end
    -- 是否是新装备
    local objNew = self:FindChild(obj, "New")
    if kItemData and itemDataManager:IsItemNew(kItemData.uiID) then
        objNew:SetActive(true)
    else
        objNew:SetActive(false)
    end
    self:FindChild(obj, "Replenish"):SetActive(false)
    self:FindChild(obj, "Inadequate"):SetActive(false)
    self:FindChild(obj, "Producible"):SetActive(false)
end

-- 为 Info 和 Icon 添加不同的监听
function ItemInfoUI:AddClickFunc(obj, func_info, func_icon, showLockState, itemID)
    if not (obj and (func_info or func_icon)) then return end
    local objButton = self:FindChild(obj, 'Button')
    local comButton = objButton:GetComponent('Button')
    if not comButton then return end
    self:RemoveButtonClickListener(comButton)
    itemID = itemID or GetUIntDataInGameObject(obj, 'itemID')
    if func_info then
        self:AddButtonClickListener(comButton, function() 
            func_info(obj, itemID)
        end, self.canSaveBtn)
    end

    local objItemIcon = self:FindChild(objButton, "ItemIconUI")
    if func_icon and objItemIcon then 
        self.ItemIconUI:AddClickFunc(objItemIcon, func_icon, itemID)
    end
end

-- 移除icon监听
function ItemInfoUI:RemoveClickFunc(obj)
    if not obj then return end
    local objButton = self:FindChild(obj, 'Button')
    local comButton = objButton:GetComponent('Button')
    if not comButton then return end
    self:RemoveButtonClickListener(comButton)

    local objItemIcon = self:FindChild(objButton, "ItemIconUI")
    if objItemIcon then 
        self.ItemIconUI:RemoveClickFunc(objItemIcon)
    end
end

function ItemInfoUI:GetCurSelectRoleID()
    local characterUI = WindowsManager:GetInstance():GetUIWindow("CharacterUI")
    return characterUI:GetSelectRole()
end

-- 设置物品图标状态
function ItemInfoUI:SetIconState(obj, strState)
    local iconNode = self:FindChild(obj, "ItemIconUI")
    self.ItemIconUI:SetIconState(iconNode, strState)
end

-- 设置物品图标锁状态
function ItemInfoUI:UpdateLockState(obj, bActive)
    local iconNode = self:FindChild(obj, "ItemIconUI")
    self.ItemIconUI:UpdateLockState(iconNode, bActive)
end

-- 设置数量
function ItemInfoUI:SetItemNum(obj, uiNum)
    self.ItemIconUI:SetItemNum(obj, uiNum)
end

-- 设置选中状态
function ItemInfoUI:SetSelectState(obj, bSelected)
    bSelected = (bSelected == true)
    self:FindChild(obj, "Button/Toggle_BG"):SetActive(bSelected)
    self:FindChildComponent(obj, 'Price/Text', l_DRCSRef_Type.Text).color = bSelected and ITEM_INFO_SELECT_COLOR.on or ITEM_INFO_SELECT_COLOR.off
    self:FindChildComponent(obj, 'Category', l_DRCSRef_Type.Text).color = bSelected and ITEM_INFO_SELECT_COLOR.on or ITEM_INFO_SELECT_COLOR.off
end

return ItemInfoUI
