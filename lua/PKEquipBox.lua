PKEquipBox = class("PKEquipBox", BaseBox)

local ItemIconUI = require "UI/ItemUI/ItemIconUI"

function PKEquipBox:ctor(root)
    self:Super(root)

    self.mLabName = self:FindChildComponent(self.Root, "LabName", "Text")
    self.mLabTip = self:FindChildComponent(self.Root, "ScrollTip/Viewport/LabTip", "Text")
    self.mItemIconUI = self:FindChild(self.Root, "ItemIconUI")

    self.mObjItemIconUI = ItemIconUI.new()

    self:RegisterClick(self.Root:GetComponent("Button"), self.OnClickBox)
end

function PKEquipBox:Refresh(weaponID, index)
    self.mIndex = index

    local itemData = weaponID ~= nil and ItemDataManager:GetInstance():GetItemTypeDataByTypeID(weaponID) or nil

    if itemData then
        -- 名字
        self.mLabName.text = itemData.ItemName or ''

        local itemManager = ItemDataManager:GetInstance()

        -- local itemBattleInfo = TableDataManager:GetInstance():GetTableData("ItemBattle", weaponID | (0 << 28))
        -- local instData = ItemDataManager:GetInstance():genInstItemByItemBattle(itemBattleInfo) or {}

        local res, tips = TipsDataManager:GetInstance():GetItemTipsContent_ItemAttrMsgBlue(nil, itemData, false)

        -- 特殊处理，替换蓝字颜色
        if tips then
            tips = string.gsub(tips, "<color=#53667F>", "<color=#0081c2>")
        end

        self.mLabTip.text = res and tips or ""

        self.mObjItemIconUI:UpdateUIWithItemTypeData(self.mItemIconUI, itemData)
    end

    self.mLabTip.transform.localPosition = DRCSRef.Vec3Zero
end

function PKEquipBox:OnClickBox()
    PKManager:GetInstance():RequestSelectEquip(self.mIndex)
end

return PKEquipBox
