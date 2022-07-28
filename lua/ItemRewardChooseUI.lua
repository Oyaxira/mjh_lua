ItemRewardChooseUI = class("ItemRewardChooseUI",BaseWindow)
-- local ItemIconUI = require 'UI/ItemUI/ItemIconUI'

function ItemRewardChooseUI:ctor()
    -- self.ItemIconUI = ItemIconUI.new()
end

function ItemRewardChooseUI:Init()
    --初始化
    local obj = LoadPrefabAndInit("Game/ItemRewardChooseUI",TIPS_Layer,true)
    if obj then
        self:SetGameObject(obj)
    end

    self.comReturn_Button = self:FindChildComponent(self._gameObject,"btn_close","Button")
	if self.comReturn_Button then
		local fun = function()
			RemoveWindowImmediately("ItemRewardChooseUI",true)
		end
		self:AddButtonClickListener(self.comReturn_Button,fun)
    end

    self.comSure_Button = self:FindChildComponent(self._gameObject, "Button_sure", "Button")
    if (self.comSure_Button) then
        local fun = function()
            self:OnClick_SendUseItem()
        end
        self:AddButtonClickListener(self.comSure_Button, fun)
    end

    self.textSure_Image = self:FindChildComponent(self._gameObject, "Button_sure", "Image")
    setUIGray(self.textSure_Image, true)

    self.comAsk_Button = self:FindChildComponent(self._gameObject, "btn_introduction", "Button")
    if (self.comAsk_Button) then
        local fun = function()
            self:OnClick_AskButton()
        end
        self:AddButtonClickListener(self.comAsk_Button, fun)
    end

    self.textDescComponent = self:FindChildComponent(self._gameObject, "Text_desc", "Text")


    self.objItemContent = self:FindChild(self._gameObject, "Scroll View/Viewport/Content")
    -- self.objItemInstance = self:FindChild(self._gameObject, "ItemReward")
    -- self.objItemInstance:SetActive(false)

    self.chooseGiftItem = {}

    self.objRewardItems = {}

end

function ItemRewardChooseUI:RefreshUI(info)
    if not info then return end
    
    self:UpdateUI(info)
end

function ItemRewardChooseUI:UpdateUI(info)
    self.itemid = info["itemid"]
    self.chooseGiftItem = {}
    self.type = info["type"] or EffectSubType.EST_ScriptChooseGift
    if (self.type == EffectSubType.EST_ScriptChooseGift) then
        self.typedata = ItemDataManager:GetInstance():GetItemTypeData(self.itemid)
    elseif (self.type == EffectSubType.EST_HouseChooseGift) then
        self.typedata = StorageDataManager:GetInstance():GetItemTypeData(self.itemid)
    end
    -- 礼包ID获取

    if ( self.typedata == nil) then
        return
    end

    -- 组装所有的物品
    local itemChooseData = string.split(self.typedata.Value2,"|")
    self.itemChooseData = {}
    for index = 1, #itemChooseData do
        table.insert(self.itemChooseData, tonumber(itemChooseData[index]))
    end

    local itemChooseNums = string.split(self.typedata.Value3,"|")
    self.itemChooseNums = {}
    for index = 1, #itemChooseNums do
      table.insert(self.itemChooseNums, tonumber(itemChooseNums[index]))
  end

    setUIGray(self.textSure_Image, true)

    -- 更新界面
    if (#self.itemChooseData <= 0) then
        self.objItemContent:SetActive(false)
        return
    end

    local iMaxChooseItem = tonumber(self.typedata.Value1)

    -- 设置文字名称
    self.textDescComponent.text = string.format("大侠:\n奴家已经帮你准备好以下%d件物品，你可以任意挑选%d件带走哦 ^_^ ~~", #itemChooseData, iMaxChooseItem)

    self.itemChooseUIData = {}
    self.objItemContent:SetActive(true)
    RemoveAllChildren(self.objItemContent)

    for index = 1, #self.itemChooseData do
        local itemTypeID = self.itemChooseData[index]

        local kItem = LuaClassFactory:GetInstance():GetUIClass(LUA_CLASS_TYPE.ItemReward,self.objItemContent.transform)
        self.objRewardItems[#self.objRewardItems + 1] = kItem
        
        local objkItem = kItem and kItem._gameObject

        local objChooseImg = self:FindChild(objkItem , "Image_choosen")
        if (objChooseImg ~= nil) then
            objChooseImg:SetActive(false)
        end

        -- 设置礼包图标
        local itemTypeData =TableDataManager:GetInstance():GetTableData("Item", itemTypeID)
        kItem:UpdateUIWithItemTypeData(itemTypeData)

        -- 设置礼包数量
        local num = self.itemChooseNums[index] or 1
        kItem:SetItemNum( num)

        -- 设置礼包名字
        local comItemText = self:FindChildComponent(objkItem, "Text", "Text")
        if (comItemText ~= nil and itemTypeData ~= nil) then
            comItemText.gameObject:SetActive(true)
            comItemText.text = itemTypeData.ItemName or ''
        end
        self.itemChooseUIData[itemTypeID] = {["ChooseImg"] = objChooseImg, ["ChooseText"] = comItemText}

        local FuncTips = function()
            local tips = TipsDataManager:GetInstance():GetItemTipsByData(nil, itemTypeData)
            local str = '选择'
            if self.chooseGiftItem[itemTypeID] then 
                str = '取消选择'
            end
            tips.buttons = {{
                ['name'] = str,
                ['func'] = function()
                    self:OnClick_ItemChooseButton(objChooseImg, comItemText, itemTypeID)
                end
            }}
            OpenWindowImmediately("TipsPopUI", tips)
        end 
        -- if (objkItem ~= nil) then
        --     local comItemButton = objkItem:GetComponent("Button")
        --     self:AddButtonClickListener(comItemButton, function()
        --         self:OnClick_ItemChooseButton(objChooseImg, comItemText, itemTypeID)
        --     end)
        -- end
        kItem:SetClickFunc(FuncTips)
    end
end

function ItemRewardChooseUI:OnClick_ItemChooseButton(objChooseImg,comItemText,typeid)
    if (self.chooseGiftItem[typeid]) then
        objChooseImg:SetActive(false)
        self.chooseGiftItem[typeid] = nil
        comItemText.color = DRCSRef.Color(0.172549, 0.172549, 0.172549, 1)
    else
        objChooseImg:SetActive(true)
        self.chooseGiftItem[typeid] = true
        comItemText.color = DRCSRef.Color(0.91, 0.91, 0.91, 1)
    end

    local iChooseItemNums = 0
    for key, value in pairs(self.chooseGiftItem) do
        if (value) then
            iChooseItemNums = iChooseItemNums + 1
        end
    end

    -- 如果超过了,那么取其中一个取消状态
    local iMaxChooseItem = tonumber(self.typedata.Value1)
    if (iChooseItemNums > iMaxChooseItem) then
        for key, value in pairs(self.chooseGiftItem) do
            if (value and key ~= typeid and value == true and self.itemChooseUIData[key]) then
                self.itemChooseUIData[key]["ChooseImg"]:SetActive(false)
                self.itemChooseUIData[key]["ChooseText"].color = DRCSRef.Color(0.172549, 0.172549, 0.172549, 1)
                self.chooseGiftItem[key] = nil
                break
            end
        end
    end
    if (iChooseItemNums >= iMaxChooseItem) then
        setUIGray(self.textSure_Image, false)
    else
        setUIGray(self.textSure_Image, true)
    end
end
function ItemRewardChooseUI:OnDestroy()
    -- self.ItemIconUI:Close()
    LuaClassFactory:GetInstance():ReturnAllUIClass(self.objRewardItems)

end

function ItemRewardChooseUI:OnClick_AskButton()
    local tips = TipsDataManager:GetInstance():GetChooseItemGiftTips()
    OpenWindowImmediately("TipsPopUI", tips)
end

function ItemRewardChooseUI:OnClick_SendUseItem()
   if (not self.chooseGiftItem) then
        return
   end 

   local itemID = self.itemid
   if (not itemID) then
        return
   end

   local chooseitems = {}
   for key, value in pairs(self.chooseGiftItem) do
        if (value) then
            table.insert(chooseitems, key)
        end
   end

   if (next(chooseitems) == nil) then
        return
   end

   local iNeedChooseItem = tonumber(self.typedata.Value1)

   if (#chooseitems ~= iNeedChooseItem)then
        SystemUICall:GetInstance():Toast(string.format("请您选择%d个礼包物品",iNeedChooseItem))
        return
   end

   local str_content = '确定选择'
   for i,itemid in ipairs(chooseitems) do 
        if i ~= 1 then 
            str_content = str_content .. '、'
        end 
        local itemTypeData =TableDataManager:GetInstance():GetTableData("Item", itemid)
        str_content  = str_content .. getRankBasedText(itemTypeData.Rank, itemTypeData.ItemName or '',true)
   end 
   str_content = str_content .. '吗？'
   local type = GeneralBoxType.COMMON_TIP
   local showContent = {
       ['title'] = "选择礼包",
       ['text'] = str_content,
   }
   local callBack = function()
        if (self.typedata.EffectSubType == EffectSubType.EST_ScriptChooseGift) then              -- 剧本礼包
            local roleID = RoleDataManager:GetInstance():GetMainRoleID()
            SendUseItemCMD(roleID, itemID, 1, getTableSize(chooseitems), FormatTable(chooseitems))
        elseif ( self.typedata.EffectSubType == EffectSubType.EST_HouseChooseGift) then          -- 酒馆礼包
            local list = { [0] = {["uiItemID"] = itemID,["uiItemNum"] = 1} }
            SendUseStorageItem( 1,list , getTableSize(chooseitems), FormatTable(chooseitems))
        end
        RemoveWindowImmediately("ItemRewardChooseUI",true)
   end

   OpenWindowImmediately('GeneralBoxUI', {type, showContent, callBack})
end

return ItemRewardChooseUI