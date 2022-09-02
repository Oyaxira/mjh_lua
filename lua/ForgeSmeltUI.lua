ForgeSmeltUI = class("ForgeSmeltUI",BaseWindow)

local l_DRCSRef_Type = DRCSRef_Type

local ItemIconUI = require 'UI/ItemUI/ItemIconUI'
local BackpackNewUICom = require 'UI/Role/BackpackNewUI'

function ForgeSmeltUI:ctor()
    self.ItemIconUI = ItemIconUI.new()
    self.ItemIconUI:SetCanSaveButton(false)
end

function ForgeSmeltUI:Init(objParent, instParent)
   --初始化
   if not (objParent and instParent) then return end
    self._gameObject_parent = objParent
    self._inst_parent = instParent
    local obj = self:FindChild(objParent, "smelt_box")
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
        ['bCanShowLock'] = true,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)
            self:OnClickSmeltItem(itemID)
        end, 
        ['funcOnClickItemIcon'] = function(obj, itemID)
            local tips = TipsDataManager:GetInstance():GetItemTips(itemID or 0)
            if not tips then
                return
            end
            local btns = {}
            if not ItemDataManager:GetInstance():ItemHasLockFeature(itemID) then
                local btnName = nil
                local btnFunc = nil
                if ItemDataManager:GetInstance():GetItemLockState(itemID) then
                    btnName = "解锁"
                    btnFunc = function()
                        ItemDataManager:GetInstance():SetItemLockState(itemID, false)
                    end
                else
                    btnName = "锁定"
                    btnFunc = function()
                        ItemDataManager:GetInstance():SetItemLockState(itemID, true)
                    end
                    local strChooseBtn = "选中"
                    if self.BackpackNewUICom:IsItemPicked(itemID) then
                        strChooseBtn = "取消"
                    end
                    btns[#btns + 1] = {
                        ['name'] = strChooseBtn,
                        ['func'] = function()
                            self:OnClickSmeltItem(itemID)
                        end
                    }
                end
                btns[#btns + 1] = {
                    ['name'] = btnName,
                    ['func'] = btnFunc
                }
            end
            tips.buttons = btns
            OpenWindowImmediately("TipsPopUI", tips)
        end,
        ['careEvent'] = {  -- 背包关心的事件列表
            [1] = {
                ['eventName'] = "UPDATE_ITEM_LOCK_STATE",  -- 事件名称
                ['responseCond'] = function()  -- 响应条件
                    return self._inst_parent:IsSubViewOpen("smelt_box")
                end,
                ['callback'] = function(kBackPack, info)  -- 事件回调
                    if not (kBackPack and info) then
                        return
                    end
                    kBackPack:UnPickItemByID(info[1])
                    self:UpdateSmeltItemList()
                    self:UpdateMsgBoard()
                end,
            },
        }
    })
    self.BackpackNewUICom:SetSortButton(true)
    -- 熟练度ui
    self.forge_level_top = self:FindChild(self._gameObject_parent, "forge_level_top")

    -- 熔炼
    self.objTextDefault = self:FindChild(obj, "Text_default")
    self.objSmeltBtn = self:FindChild(obj, "Button_green_1")
    self.btnSmeltBtn = self.objSmeltBtn:GetComponent(l_DRCSRef_Type.Button)
    self:AddButtonClickListener(self.btnSmeltBtn, function()
        self:SendCmdDoSmelt()
    end)
    self.textSmeltBtn = self:FindChildComponent(self.objSmeltBtn, "Text", l_DRCSRef_Type.Text)
    self.ImageSmeltBtn =  self.objSmeltBtn:GetComponent(l_DRCSRef_Type.Image)
    self.objItemInfoBox = self:FindChild(obj, "ItemInfo_box")
    self.objWMFBox = self:FindChild(self.objItemInfoBox, "MaterialInfo_box")

    self.objJingTieBoxIcon = self:FindChild(self.objWMFBox, "JingTie")
    self.objJingTieBoxNum = self:FindChild(self.objJingTieBoxIcon, "Text_num")
    self.textJingTieBoxNum = self.objJingTieBoxNum:GetComponent(l_DRCSRef_Type.Text)

    -- 材料数量
    self.objMatNumBox = self:FindChild(self._gameObject, "MatNumBox")
    self.objJingTieNum = self:FindChild(self.objMatNumBox, "JingTie")
    self.comJingTieNum = self:FindChildComponent(self.objJingTieNum, "Num", l_DRCSRef_Type.Text)
    self.kItemMgr = ItemDataManager:GetInstance()
end

function ForgeSmeltUI:UpdateSmeltSpecialSwitch()
    local bOpen = QuerySystemIsOpen(SGLST_SMELT_SPECIAL)
    self.objJingTieNum:SetActive(bOpen)
    self.objJingTieBoxIcon:SetActive(bOpen)
end

function ForgeSmeltUI:Update()
    self.BackpackNewUICom:Update()
end

function ForgeSmeltUI:RefreshUI(info)
    -- 隐藏熟练度ui
    self.forge_level_top:SetActive(false)
    -- 物品初始化
    self:UpdateSmeltItemList()
    -- 其它
    self:UpdateMatsNum()
end

-- 获取物品管理对象
function ForgeSmeltUI:GetItemManager()
    if not self.itemDataMgr then
        self.itemDataMgr = ItemDataManager:GetInstance()
    end
    return self.itemDataMgr
end

-- 更新左侧物品列表
function ForgeSmeltUI:UpdateSmeltItemList()
    local itemManager = self:GetItemManager()
    -- 检查物品是否可熔炼
    local checkItemSmeltable = function(itemID)
        return itemManager:CanItemBeSmelted(itemID)
    end
    -- 筛选出可重铸的 背包中 装备中 物品
    local mainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
    local roleItems = itemManager:GetPackageItems(mainRoleID, mainRoleID, true, checkItemSmeltable)
    -- 丢进 BackpackNewUICom
    if self.BackpackNewUICom:GetPackSize() == 0 then
        self.BackpackNewUICom:ShowPackByInstIDArray(roleItems, nil, {
            ['funcSort'] = self._inst_parent.instItemSortFunc
        })
    else
        self.BackpackNewUICom:ShowRefreshAndResetPackByInstIDArray(roleItems)
    end
    -- 额外处理, 对于熔炼中选择的装备, 如果该装备现在因为其他原因(重铸/强化)而加上了锁定状态, 那么解除该物品的选中
    local aiPickedItemIDs = self.BackpackNewUICom:GetPickedItemIDArray() or {}
    for index, uiID in ipairs(aiPickedItemIDs) do
        if itemManager:GetItemLockState(uiID) == true then
            self.BackpackNewUICom:UnPickItemByID(uiID)
        end
    end
    -- 更新左下角完美粉数量
    self:UpdateMatsNum()
     -- 更新熔炼信息
    local aiList, aiCount = self.BackpackNewUICom:GetPickedItemIDArray()
    if (not aiList) or (not aiCount)
    or (#aiList == 0) or (#aiCount == 0) then
        self:SetMsgBoardState(false)
        return
    end
end

-- 重置导航栏
function ForgeSmeltUI:ResetNavBar()
    self.BackpackNewUICom:Reset2FirstTap()
end

-- 点击一个熔炼物品
function ForgeSmeltUI:OnClickSmeltItem(itemID)
    -- 如果物品已经锁定, 则不接受点击
    if ItemDataManager:GetInstance():GetItemLockState(itemID) == true then
        return
    end
    -- 取消选中已经选中的物品
    if self.BackpackNewUICom:IsItemPicked(itemID) then
        self.BackpackNewUICom:UnPickItemByID(itemID)
    else
        -- 检查熔炼队友装备的好感度需求
        local uiMainRoleID = RoleDataManager:GetInstance():GetMainRoleID()
        
        local bEuiped, uiTarRole = self.kItemMgr:IsItemEquipedByRole(itemID)
        local kInstItem = self.kItemMgr:GetItemDataInItemPool(itemID)
        if (bEuiped == true)
        and (uiMainRoleID ~= uiTarRole)
        and (kInstItem.bBelongToMainRole ~= 1) then
            -- 分析卸下队友装备的前提条件
            local kPreCond = self.kItemMgr:GenUnloadRoleEquipPrecondition(kInstItem.uiTypeID or 0, uiTarRole)
            if kPreCond and (kPreCond.bCondTrue ~= true) then
                local strMsg = string.format("您不是该装备的拥有者，熔炼%s的%s，需要与其好感度达到<color=#913E2B>%d</color>，否则好感度会下降<color=#913E2B>%d</color>。继续选择熔炼该装备吗？"
                    , kPreCond.strRoleName or ""
                    , kPreCond.strItemDesc or ""
                    , kPreCond.uiFavorNeed or 0
                    , kPreCond.uiFavorSub or 0
                )
                if kPreCond.bWillLeave == true then
                    strMsg = strMsg .. string.format("\n熔炼该装备后，%s的<color=#913E2B>好感度将降至0及以下</color>，%s将会<color=#913E2B>离开队伍</color>", kPreCond.strRoleName or "", kPreCond.strRoleName or "")
                end
                OpenWindowImmediately('GeneralBoxUI', {GeneralBoxType.COMMON_TIP, strMsg, function()
                    self.BackpackNewUICom:PickItemByID(itemID, 1, false) 
                    self:UpdateMsgBoard()
                end})
                return
            end
        end
        self.BackpackNewUICom:PickItemByID(itemID, 1, false)
    end
    -- 更新熔炼信息
    self:UpdateMsgBoard()
end

-- 设置信息面板显示状态
function ForgeSmeltUI:SetMsgBoardState(bIsActive)
    bIsActive = bIsActive == true
    self.objTextDefault:SetActive(not bIsActive)
    self.objWMFBox:SetActive(bIsActive)
    self.btnSmeltBtn.interactable = bIsActive
    self.textSmeltBtn.text = bIsActive and "熔炼" or "待选择"
    setUIGray(self.ImageSmeltBtn, not bIsActive)
end

-- 刷新右边详细信息面板
function ForgeSmeltUI:UpdateMsgBoard()
    -- 获取到所有选中的物品
    local aiList, aiCount = self.BackpackNewUICom:GetPickedItemIDArray()
    if (not aiList) or (not aiCount)
    or (#aiList == 0) or (#aiCount == 0) then
        self:SetMsgBoardState(false)
        return
    end
    self:SetMsgBoardState(true)
    local itemManager = self:GetItemManager()
    local powderCount = 0
    local powderCountMin = 0
    local ironCount = 0
    local tongLingYuCount = 0
    -- 同时更新熔炼物品数组
    local itemsToSmelt = {}
    for index, itemID in ipairs(aiList) do
        itemsToSmelt[index - 1] = itemID
        local instItem = itemManager:GetItemData(itemID)
        local iRank = itemManager:GetItemRankByItemInstID(itemID)
        local ForgeSmeltData = TableDataManager:GetInstance():GetTableData("ForgeSmelt", iRank)
        if ForgeSmeltData then
            ironCount = ironCount + ForgeSmeltData.JingTieNum
        end
    end
    self.itemsToSmelt = itemsToSmelt
    self.textJingTieBoxNum.text = string.format("X %s", ironCount)
end

-- 向服务器发送熔炼消息
function ForgeSmeltUI:SendCmdDoSmelt()
    if not (self.itemsToSmelt and self.itemsToSmelt[0]) then
        return
    end
    local iCount = #self.itemsToSmelt + 1
    if iCount > SSD_MAX_SCRIPT_PLAT_NUM then
        if not self.strOverSendWarning then
            self.strOverSendWarning = string.format("选择物品数量超过单次熔炼上限 %d", SSD_MAX_SCRIPT_PLAT_NUM)
        end
        SystemUICall:GetInstance():Toast(self.strOverSendWarning)
        return
    end

    boxCallback = function()
        SendClickItemSmeltCMD(iCount, self.itemsToSmelt)
        -- 更新ui
        self.BackpackNewUICom:UnPickAllItems()
        self:UpdateMsgBoard()
        self:UpdateMatsNum()
    end

    local removeItemCallback = function(itemID,num)
        self.BackpackNewUICom:UnPickItemByID(itemID)
        self:UpdateMsgBoard()
	end

    if (iCount > 1 or (iCount == 1 and self.kItemMgr:ItemUseNeedCheck(self.itemsToSmelt[0]))) then
        -- 此处itemsToSmelt的list下标从0开始转化为从1开始
        local itemList = {}
        local itemNumList = {}
        for i=1,iCount do
            itemList[i] = self.itemsToSmelt[i-1]
            itemNumList[i] = 1
        end
		data = {
			['goodsList'] = itemList,
			['goodsNumList'] = itemNumList,
			['windowTitle'] = "装备熔炼",
			['windowTips'] = "以下物品将被熔炼，此操作无法反悔，是否确定？",
            ['commitCallback'] = boxCallback,
			['removeItemCallback'] = removeItemCallback
		}
        OpenWindowImmediately("ShowAllChooseGoodsUI",data)
    else
        boxCallback()
    end
    
end

-- 刷新材料数量
function ForgeSmeltUI:UpdateMatsNum()
    -- 初始化图标
    if not self.matIconUpdated then
        local kTableMgr = TableDataManager:GetInstance()
        local kItemMgr = ItemDataManager:GetInstance()

        -- 同时初始化信息栏中的按钮
        local itemTypeData_iron = kTableMgr:GetTableData("Item",30951)  -- 精铁
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objJingTieBoxIcon, itemTypeData_iron)
        self.ItemIconUI:UpdateUIWithItemTypeData(self.objJingTieNum, itemTypeData_iron)
       
        -- 标记图标初始化完成
        self.matIconUpdated = true
    end
    local playerData = PlayerSetDataManager:GetInstance()
    local IronCount = playerData:GetPlayerRefinedIron() or 0
    self.comJingTieNum.text = IronCount
end

function ForgeSmeltUI:OnDestroy()
    -- 关闭组件
    self.ItemIconUI:Close()
    self.BackpackNewUICom:Close()
end


return ForgeSmeltUI