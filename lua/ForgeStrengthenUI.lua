ForgeStrengthenUI = class("ForgeStrengthenUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local BackpackNewUICom = require 'UI/Role/BackpackNewUI'

function ForgeStrengthenUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
    self.ItemIconUI:SetCanSaveButton(false)
end

function ForgeStrengthenUI:Init(objParent, instParent)
   --初始化
   if not (objParent and instParent) then return end
    self._gameObject_parent = objParent
    self._inst_parent = instParent
    local obj = self:FindChild(objParent, "strengthen_box")
	if obj then
		self:SetGameObject(obj)
    end

    -- 初始化背包
    self.objBackpack = self:FindChild(obj, "BackpackUI")

    self.BackpackNewUICom = BackpackNewUICom.new({
        ['objBind'] = self.objBackpack,  -- 背包实例绑定的ui节点
        ['navData'] = self._inst_parent.classToType_recast,  -- 导航栏数据
        ['RowCount'] = 2,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 6,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = false,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)
            self:OnClickStrengthenItem(itemID)
        end, 
        ['funcOnClickItemIcon'] = function(obj, itemID)
            local tips = TipsDataManager:GetInstance():GetItemTips(itemID)
            if not tips then
                return
            end
            if self.curSelectItemID ~= itemID then
                tips.buttons = {{
                    ['name'] = "选中",
                    ['func'] = function()
                        self:OnClickStrengthenItem(itemID)
                    end
                }}
            end
            OpenWindowImmediately("TipsPopUI", tips)
        end,
    })

    -- 隐藏熟练度ui
    self.forge_level_top = self:FindChild(self._gameObject_parent, "forge_level_top")

    -- 强化
    self.TextTitle = self:FindChildComponent(obj, "Image_title/TMP_name", l_DRCSRef_Type.Text)
    self.ObjTextDefault = self:FindChild(obj, "Text_default")
    self.objImg_default = self:FindChild(obj, "BG_LuDing") 
    self.ObjItemInfoBox = self:FindChild(obj, "ItemInfo_box")
    self.ObjLevelOld = self:FindChild(self.ObjItemInfoBox, "Level_old")
    self.ObjLevelNew = self:FindChild(self.ObjItemInfoBox, "Level_new")
    self.TextLevelOld = self:FindChildComponent(self.ObjLevelOld, "Text_name", l_DRCSRef_Type.Text)
    self.TextLevelNew = self:FindChildComponent(self.ObjLevelNew, "Text_name", l_DRCSRef_Type.Text)
    self.TextContentOld = self:FindChildComponent(self.ObjItemInfoBox, "SC_equip_attr_1/Viewport/Content/Text_level", l_DRCSRef_Type.Text)
    self.TextContentNew = self:FindChildComponent(self.ObjItemInfoBox, "SC_equip_attr_2/Viewport/Content/Text_level", l_DRCSRef_Type.Text)
    self.ObjBtnDefault = self:FindChild(obj, "Button_default")
    self.BtnDefault = self.ObjBtnDefault:GetComponent(l_DRCSRef_Type.Button)
    self.BtnDefault.interactable = false
    self.TextBtnDefault = self:FindChildComponent(self.ObjBtnDefault, "Text", l_DRCSRef_Type.Text)
    self.TextBtnDefault.text = "待选择"
    self.ObjBtnBuy = self:FindChild(obj, "Button_buy")
    self.BtnBuy = self.ObjBtnBuy:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.BtnBuy, function()
        self:OnClickStrengthenBtn()
    end)
    self.TextBtnBuy = self:FindChildComponent(self.ObjBtnBuy, "Text", l_DRCSRef_Type.Text)
    self.ObjBtnBuyCoinImg = self:FindChild(self.ObjBtnBuy, "Image_tongbi")
    self.ObjBtnBuySilverImg = self:FindChild(self.ObjBtnBuy, "Image_yinding")
    self.ObjBtnBuyTongLingYuImg = self:FindChild(self.ObjBtnBuy, "Image_tonglingyu")
    self.TextBtnBuyCoin = self:FindChildComponent(self.ObjBtnBuy, "Number", l_DRCSRef_Type.Text)
    -- 最大强化等级
    self.MaxStrengthenLevel = TableDataManager:GetInstance():GetTableData("CommonConfig",1).MaxStrengthenLevel or 0
end


-- 获取每日银锭或精铁最大强化次数
function ForgeStrengthenUI:GetMaxSilverStrengthenTimes()
    local kCommonConfig =  TableDataManager:GetInstance():GetTableData("CommonConfig",1)
    if not kCommonConfig then
        return
    end
   local iBaseValue = kCommonConfig.MaxSilverStrengthenTimes or 0
   -- 如果开通了百宝书壕侠, 那么加上叠加值
   if TreasureBookDataManager:GetInstance():GetTreasureBookVIPState() then
        iBaseValue = iBaseValue + (kCommonConfig.VipExtraStrengthenTimes or 0)
   end
   return iBaseValue
end

function ForgeStrengthenUI:RefreshUI(info)
    -- 隐藏熟练度ui
    self.forge_level_top:SetActive(false)
    -- 最大银锭强化次数
    self.MaxSilverStrengthTimes = self:GetMaxSilverStrengthenTimes()
    -- 刷新物品列表
    self:UpdateStrengthenItemList()
    -- 如果存在选中的物品, 那么刷新到选中的物品信息, 否则, 初始化ui
    if self.curSelectItemID then
        local itemData = ItemDataManager:GetInstance():GetItemData(self.curSelectItemID)
        if itemData and ((itemData.uiEnhanceGrade or 0) < math.min(self:GetCanStrength(), self.MaxStrengthenLevel)) then
            self:OnClickStrengthenItem(self.curSelectItemID)
            return
        end
    end
    -- ui初始化
    self:OnClickStrengthenItem()
    self:SetMsgBoardState(false)
    self.TextTitle.text = "强化"
end

function ForgeStrengthenUI:Update()
    self.BackpackNewUICom:Update()
end

-- 关闭界面时清除物品选中信息
function ForgeStrengthenUI:OnDisable()
    --self.curSelectItemID = nil
end

-- 获取物品管理对象
function ForgeStrengthenUI:GetItemManager()
    if not self.itemDataMgr then
        self.itemDataMgr = ItemDataManager:GetInstance()
    end
    return self.itemDataMgr
end

-- 更新左侧物品列表
function ForgeStrengthenUI:UpdateStrengthenItemList()
    local itemManager = self:GetItemManager()
    -- 检查物品是否可强化
    local checkItemStrengthenable = function(itemID)
        local itemTypeData = itemManager:GetItemTypeData(itemID)
        if not itemTypeData then return false end
        local itemType = itemTypeData.ItemType
        local TB_ItemType = TableDataManager:GetInstance():GetTable("ItemType")
        local data = TB_ItemType[itemType]
        if data.CanIntensify ~= TBoolean.BOOL_YES then
            return false
        end
        -- 强化等级达到最大等级时不允许继续强化
        local itemInstData = itemManager:GetItemData(itemID)
        if (itemInstData.uiEnhanceGrade or 0) >= math.min(self:GetCanStrength(), self.MaxStrengthenLevel) then
            return false
        end
        return true
    end
    -- 筛选出可强化的 背包中 装备中 物品
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    local roleItems = itemManager:GetPackageItems(mainRoleID, mainRoleID, true, checkItemStrengthenable, false)
    -- 丢进 BackpackNewUICom
    if self.BackpackNewUICom:HasItemPicked() then
        self.BackpackNewUICom:ShowRefreshAndResetPackByInstIDArray(roleItems)
    else
        self.BackpackNewUICom:ShowPackByInstIDArray(roleItems, nil, {
            ['funcSort'] = self._inst_parent.instItemSortFunc
        })
    end
end

-- 重置导航栏
function ForgeStrengthenUI:ResetNavBar()
    self.BackpackNewUICom:Reset2FirstTap()
end

-- 设置信息面板显示状态
function ForgeStrengthenUI:SetMsgBoardState(bIsActive, iTargetLevel, itemRank)
    bIsActive = bIsActive == true
    self.ObjTextDefault:SetActive(not bIsActive)
    self.objImg_default:SetActive(not bIsActive)
    self.ObjItemInfoBox:SetActive(bIsActive)
    self.ObjBtnDefault:SetActive(not bIsActive)
    self.ObjBtnBuy:SetActive(bIsActive)
    -- 不是激活状态不同继续往下初始化了
    if not (bIsActive and iTargetLevel) then return end
    -- 获取铜币能够强化的最大等级, 以及价格查询表
    -- if not self.PriceLookUp then
    --     local coinUseMaxLimit = 0
    --     local priceLookUp = {}
    --     local TB_ForgeLvupCost = TableDataManager:GetInstance():GetTable("ForgeLvupCost")
    --     for index, data in ipairs(TB_ForgeLvupCost) do
    --         if data.Coin ~= 0 then
    --             priceLookUp[index] = data.Coin
    --         elseif data.Silve ~= 0 then
    --             if coinUseMaxLimit <= 0 then
    --                 coinUseMaxLimit = index
    --             end
    --             priceLookUp[index] = data.Silve
    --         end
    --     end
    --     self.coinUseMaxLimit = coinUseMaxLimit
    --     self.PriceLookUp = priceLookUp
    -- end

    local price = nil
    self.bUseTongLingYu = false
    local TB_ForgeLvupCost = TableDataManager:GetInstance():GetTable("ForgeLvupCost")
    for index, data in pairs(TB_ForgeLvupCost) do
      if (data.StrengthLv == iTargetLevel and data.Rank == itemRank) then
        if (data.Coin ~= 0) then
          self.bUseTongLingYu = false
          price = data.Coin
        else
          self.bUseTongLingYu = true
          price = data.Jade
        end
        break
      end
    end

    if (price == nil) then return end

    self.ObjBtnBuyCoinImg:SetActive(not self.bUseTongLingYu)
    self.ObjBtnBuySilverImg:SetActive(false)  -- 银锭先不显示, 显示使用金刚玉强化
    self.ObjBtnBuyTongLingYuImg:SetActive(self.bUseTongLingYu)
    
    self.TextBtnBuyCoin.text = price
    self.TextBtnBuy.text = "强化"
    self.BtnBuy.interactable = true
    -- 判断账户余额
    local roleInfo = globalDataPool:getData("MainRoleInfo")
    if not (roleInfo and roleInfo["MainRole"]) then return end
    local mainRoleInfo = roleInfo["MainRole"]
    if self.bUseTongLingYu then
        -- 强化时优先使用金刚玉, 
        -- 金刚玉不足时, 依然可以点击, 提示使用银锭与金刚玉的兑换比例补足
        local curTongLingYu = mainRoleInfo[MRIT_TONGLINGYU] or 0
        if price > curTongLingYu then
            self.TextBtnBuy.text = "金刚玉不足"
        end
        self.curTongLingYuPrice = price
    else
        local curCoin = mainRoleInfo[MRIT_CURCOIN] or 0
        self.curCoinPrice = 0
        if price > curCoin then
            self.TextBtnBuy.text = "铜币不足"
            -- 铜币不足依然可以点击, 会提示用银锭转换
            self.curCoinPrice = price
            -- self.BtnBuy.interactable = false
        end
    end
end

-- 点击一个强化物品
function ForgeStrengthenUI:OnClickStrengthenItem(itemID)
    -- 选中物品
    self.BackpackNewUICom:PickItemByID(itemID, 1, true)
    -- 更新信息
    self:UpdateStrengthenMsg(itemID)
end

-- 获取物品属性信息
function ForgeStrengthenUI:GetItemMsg(itemInstData, iTargetLevel)
    if not itemInstData then return "" end
    local ret = {}
    -- 获取manager
    local itemDataMgr = self:GetItemManager()
    local itemID = itemInstData.uiID
    -- 先筛选出物品的 固定属性 和 可重铸属性
    local auiAttrData = itemInstData.auiAttrData or {} -- 所有属性
    local uiRecastableAttrs = {} -- 所有可重铸属性
    local uiFixedAttrs = {} -- 所有固定属性
    local iType = 0 -- 属性类型
    for index, data in pairs(auiAttrData) do
        if itemDataMgr:JudgeAttrRankType(data, "white") then
            uiFixedAttrs[#uiFixedAttrs + 1] = data
        elseif itemDataMgr:JudgeAttrRankType(data, "green") then
            uiRecastableAttrs[#uiRecastableAttrs + 1] = data
        end
    end
    -- 翻译固定属性内容
    if next(uiFixedAttrs) then
        for index, attrData in ipairs(uiFixedAttrs) do
            ret[#ret + 1] = itemDataMgr:GetItemAttrDesc(attrData, itemInstData, nil, iTargetLevel)
        end
    end
    -- 翻译可重铸属性内容
    if next(uiRecastableAttrs) then
        local isItemPerfect = itemDataMgr:IsItemPerfect(itemID)
        for index, attrData in ipairs(uiRecastableAttrs) do
            ret[#ret + 1] = itemDataMgr:GetItemAttrDesc(attrData, itemInstData, isItemPerfect, iTargetLevel, true, "<color=#049947>", nil, "<color=#049947>")
        end
    end
    -- 翻译蓝字属性内容
    -- 获取物品强化等级
    local itemStrengthenLevel = 0
    if iTargetLevel then
        itemStrengthenLevel = iTargetLevel
    else
        itemStrengthenLevel = itemInstData.uiEnhanceGrade or 0
    end
    local itemStaticData = itemDataMgr:GetItemTypeData(itemID)
    -- 先翻译物品静态数据的固定蓝字属性
    -- 获取最终描述
    local getFinalDesc = function(lv, desc)
        if not (lv and desc) then return desc end
        local prefix = ""
        if itemStrengthenLevel >= lv then
            prefix = "<color=#0081c2>"
        else
            prefix = "<color=#53667F>"
        end
        if lv > 0 then
            prefix = string.format("%s(+%d)", prefix, lv)
        end
        return string.format("%s%s%s", prefix, desc, "</color>")
    end
    -- 静态蓝字属性 第一种情况 天赋 + 解锁等级
    if itemStaticData.BlueGift and itemStaticData.BlueGiftUnlockLv then
        local blueGift = itemStaticData.BlueGift
        local unlockLv = itemStaticData.BlueGiftUnlockLv
        local giftTypeData = nil
        local desc = nil
        local Local_TB_Gift = TableDataManager:GetInstance():GetTable("Gift")
        for index, giftTypeID in ipairs(blueGift) do
            giftTypeData = Local_TB_Gift[giftTypeID]
            if giftTypeData then
                desc = GetLanguageByID(giftTypeData.DescID)
                ret[#ret + 1] = getFinalDesc(unlockLv[index] or 0, desc)
            end
        end
    -- 静态蓝字属性 第二种情况 武学属性 + 属性值 + 武学 + 解锁等级
    -- 静态蓝字属性 第三种情况 非武学属性 + 属性值 + 解锁等级
    elseif itemStaticData.BlueAttr and itemStaticData.BlueAttrValue and itemStaticData.BlueAttrUnlockLv then
        local blueAttr = itemStaticData.BlueAttr
        local blueValue = itemStaticData.BlueAttrValue
        local unlockLv = itemStaticData.BlueAttrUnlockLv
        local value = 0
        local desc = nil
        local sAttrName = nil
        local martialTypeID = nil
        local martialTypeData = nil
        local sMartialName = nil
        local bIsPerMyriad, bShowAsPercent = false, false
        local matDataManager = MartialDataManager:GetInstance()
        for index, attrEnum in ipairs(blueAttr) do
            value = blueValue[index] or 0
            sAttrName = GetEnumText("AttrType", attrEnum)
            bIsPerMyriad, bShowAsPercent = matDataManager:AttrValueIsPermyriad(attrEnum)
            if bIsPerMyriad then
                value = value / 10000
            end
            if bShowAsPercent then
                desc = string.format("%s+%.1f%%", sAttrName, value * 100)
            else
                desc = string.format("%s+%.1f", sAttrName, value)
            end
            if itemStaticData.BlueMartial then
                martialTypeID = itemStaticData.BlueMartial[index]
                martialTypeData = GetTableData("Martial",martialTypeID)
                sMartialName = ""
                if martialTypeData then
                    sMartialName = GetLanguageByID(martialTypeData.NameID)
                end
                desc = sMartialName .. desc
            end
            ret[#ret + 1] = getFinalDesc(unlockLv[index] or 0, desc)
        end
    end
    -- 再翻译物品动态数据的蓝字属性加成
    if itemInstData then
        local itemID = itemInstData.uiID
        -- 先筛选出物品的 蓝字属性
        local auiAttrData = itemInstData.auiAttrData or {} -- 所有属性
        local uiBlueAttrs = {} -- 所有蓝字属性
        for index, data in pairs(auiAttrData) do
            if itemDataMgr:JudgeAttrRankType(data, "blue") then
                uiBlueAttrs[#uiBlueAttrs + 1] = data
            end
        end
        -- 翻译蓝字属性内容
        local attrName = nil
        for index, attrData in ipairs(uiBlueAttrs) do
            attrName = GetEnumText("AttrType", attrData.uiType)
            ret[#ret + 1] = string.format("本装备上铸造属性\"%s\"效果提升%d%%", attrName, attrData.iBaseValue or 0)
        end
    end
    return table.concat(ret, "\n")
end

-- 更新右侧强化信息
function ForgeStrengthenUI:UpdateStrengthenMsg(itemID)
    local itemDataMgr = self:GetItemManager()
    local itemInstData = itemDataMgr:GetItemData(itemID)
    local itemTypeData = itemDataMgr:GetItemTypeData(itemID)
    if not (itemInstData and itemTypeData) then 
        self:SetMsgBoardState(false)
        return 
    end
    local oldLevel = itemInstData.uiEnhanceGrade or 0
    local newLevel = oldLevel + 1
    self:SetMsgBoardState(true, newLevel, itemTypeData.Rank)
    -- 标题
    self.TextTitle.text = itemDataMgr:GetItemName(itemID)
    local oldContent = ""
    local newContent = ""
    local bEquiped, iEquipRole = ItemDataManager:GetInstance():IsItemEquipedByRole(itemID)
    local kEquipRoleData = RoleDataManager:GetInstance():GetRoleData(iEquipRole)
    local iRoleLevel = kEquipRoleData and kEquipRoleData.uiLevel or 0
    local genLevelCondStr = function(iLevel)
        if not iLevel then
            return ""
        end
        -- 如果这件装备是被一个角色装备着的, 那么如果新的使用等级大于该角色的等级, 那么变红
        local strColorBeg, strColorEnd = "", ""
        if bEquiped and (iRoleLevel < iLevel ) then
            strColorBeg = "<color=#913E2B>"
            strColorEnd = "</color>"
        end
        return string.format("%s等级达到%d%s\n\n", strColorBeg, iLevel, strColorEnd)
    end
    -- 读取装备的使用条件: 使用等级
    local oldLevelCond = itemDataMgr:GetItemLevelCondByID(nil, itemID)
    if oldLevelCond ~= 0 then 
        oldContent = genLevelCondStr(oldLevelCond)
    end
    local newLevelCond = itemDataMgr:GetItemLevelCondByID(nil, itemID, 1)
    if newLevelCond ~= 0 then 
        newContent = genLevelCondStr(newLevelCond)
    end
    -- 更新旧属性数据
    self.TextLevelOld.text = string.format("强化 +%d", oldLevel)
    oldContent = oldContent .. self:GetItemMsg(itemInstData) or ""
    self.TextContentOld.text = oldContent
    -- 更新新属性数据
    self.TextLevelNew.text = string.format("强化 +%d", newLevel)
    newContent = newContent .. self:GetItemMsg(itemInstData, newLevel) or ""
    self.TextContentNew.text = newContent
    -- 记录当前选中物品
    self.curSelectItemID = itemID
end

-- 获取今日银锭升级次数
function ForgeStrengthenUI:GetSilverUpdateTimes()
    local usedTimes  = 0
    local role_info = globalDataPool:getData("MainRoleInfo")
    if role_info and role_info["MainRole"] then
        usedTimes = role_info["MainRole"][MRIT_ENHANCEGRADE_DAYCOUNT] or 0
    end
    return usedTimes
end

function ForgeStrengthenUI:GetCanStrength()
    local time = timeDay(os.time(), PlayerSetDataManager:GetInstance():GetServerOpenTime());
    local tbSysOpenData = TableDataManager:GetInstance():GetSystemOpenByType(SystemType.SYST_EquipEnhance);

    local tempTable = {};
    for i = 1, #(tbSysOpenData) do
        if tbSysOpenData[i].OpenTime <= time then
            table.insert(tempTable, tbSysOpenData[i]);
        end
    end

    if #(tempTable) == 0 then
        return 20;    
    end

    local tempLevel = 5;
    for i = 1, #(tempTable) do
        tempLevel = tempTable[i].Param1;
    end

    return tempLevel;
end

-- 点击强化按钮
function ForgeStrengthenUI:OnClickStrengthenBtn()
    if not self.curSelectItemID then return end
    local itemID = self.curSelectItemID
    local itemMgr = self:GetItemManager()
    local itemInstData = itemMgr:GetItemData(itemID)

    if itemInstData.uiEnhanceGrade >= self:GetCanStrength() then
        SystemUICall:GetInstance():Toast("已达强化上限")
        return
    end

    -- 获取物品使用条件发生变化的强化等级
    if not self.uiItemUseLevelWillRaiseLevel then
        self.uiItemUseLevelWillRaiseLevel = itemMgr:GetItemStrengthenCondLevelWillRaiseLevel() or 0
    end

    -- 用户确认流程
    local bEquiped, iRoleID = itemMgr:IsItemEquipedByRole(itemID)
    if bEquiped == false then
        -- 如果没有被装备, 和主角的等级进行比较
        iRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    end
    local roleInstData = RoleDataManager:GetInstance():GetRoleData(iRoleID)
    local uiRoleLevel = 0
    if roleInstData then
        uiRoleLevel = roleInstData:GetLevel() or 0
    end
    local itemNextLevelCond = itemMgr:GetItemLevelCondByID(nil, itemID, 1)
    local warningContent = nil
    -- 比较使用等级条件与当前等级, 如果大于当前等级弹出提示
    -- 由于只需要提醒一次, 所以只要在刚好超过的那一级提醒就好了
    local bWillRaiseLevel = (itemInstData.uiEnhanceGrade >= self.uiItemUseLevelWillRaiseLevel)  -- 这次强化会不会提升使用等级
    if bEquiped and bWillRaiseLevel and (itemNextLevelCond == uiRoleLevel + 1) then
        warningContent = "该物品正在装备中，强化后装备使用等级将会大于角色等级， 是否继续？"
    elseif itemInstData.uiEnhanceGrade == self.uiItemUseLevelWillRaiseLevel then
        warningContent = string.format("强化+%d以后的每次强化都会导致物品使用等级要求上升， 是否继续？", self.uiItemUseLevelWillRaiseLevel or 0)
    end
    if warningContent and (warningContent ~= "") then
        OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, warningContent, function()
            self:DoEnhance(itemID, itemInstData)
        end})
        return
    end
    self:DoEnhance(itemID, itemInstData)
end

-- 使用不同货币执行升级流程
function ForgeStrengthenUI:DoEnhance(itemID, itemInstData)
    if (not itemID) or (not itemInstData) then
        return
    end

    local doStrengthenUp = function()
        -- 装备从+4开始强化时, 将会消耗 通灵玉/银锭, 需要锁定该装备以保护
        if itemInstData.uiEnhanceGrade >= (SSD_ITEM_PROTECT_ENHANCE_GRADE - 1) then
            ItemDataManager:GetInstance():SetItemLockState(itemID, true)
        end
        SendClickItemUpGrade(itemID)
    end

    if self.bUseTongLingYu then
        -- local usedTimes  = self:GetSilverUpdateTimes()
        -- local maxTimes = self.MaxSilverStrengthTimes
        -- if usedTimes >= maxTimes then
        --     SystemUICall:GetInstance():Toast("银锭或金刚玉强化次数达到每日上限!")
        --     return
        -- end
        -- -- 优先使用金刚玉进行强化, 如果金刚玉不足, 提示使用银锭进行转化
        -- local uiTongLingYuNum = PlayerSetDataManager:GetInstance():GetTongLingYuValue() or 0
        -- if uiTongLingYuNum >= self.curTongLingYuPrice then
        --     doStrengthenUp()
        --     return
        -- end
        -- local uiLess = self.curTongLingYuPrice - uiTongLingYuNum
        -- local uiTongLingYuPrice = PlayerSetDataManager:GetInstance():GetSingleFieldConfig(ConfigType.CFG_TONGLINGYU_SILVER_PRICE) or 0
        -- local uiNeedSpendSilver = uiLess * uiTongLingYuPrice
        -- if self.bTongLingYuNotEnoughWarning ~= false then
        --     local strWarning = string.format("本次强化需要消耗%d金刚玉, 金刚玉数量不足, 是否要以每个金刚玉%d银锭的价格, 使用%d银锭补足金刚玉进行强化? (本次强化不再提示)", self.curTongLingYuPrice, uiTongLingYuPrice, uiNeedSpendSilver)
        --     local boxCallback = function()
        --         PlayerSetDataManager:GetInstance():RequestSpendSilver(uiNeedSpendSilver, doStrengthenUp)
        --         self.bTongLingYuNotEnoughWarning = false
        --     end
        --     OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strWarning, boxCallback})
        -- else
        --     PlayerSetDataManager:GetInstance():RequestSpendSilver(uiNeedSpendSilver, doStrengthenUp)
        -- end
    elseif self.curCoinPrice and (self.curCoinPrice > 0) then
        -- local iNeedSilver = math.ceil(self.curCoinPrice / 100) -- 铜币与银锭是 100 : 1 的比率
        -- if self.bCoinNotEnoughWarning ~= false then
        --     local strWarning = string.format("本次强化需要消耗%d铜币, 铜币数量不足, 是否使用%d银锭代替铜币进行强化? (本次强化不再提示)", self.curCoinPrice, iNeedSilver)
        --     local boxCallback = function()
        --         PlayerSetDataManager:GetInstance():RequestSpendSilver(iNeedSilver, doStrengthenUp)
        --         self.bCoinNotEnoughWarning = false
        --     end
        --     OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strWarning, boxCallback})
        -- else
        --     PlayerSetDataManager:GetInstance():RequestSpendSilver(iNeedSilver, doStrengthenUp)
        -- end
    else
        -- 铜币强化并且铜币充足的情况
        doStrengthenUp()
    end
end

function ForgeStrengthenUI:OnDestroy()
    self.ItemIconUI:Close()
    self.BackpackNewUICom:Close()
end


return ForgeStrengthenUI