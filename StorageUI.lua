StorageUI = class("StorageUI",BaseWindow)

local BackpackUIComNew = require 'UI/Role/BackpackNewUI'
local ItemInfoUI = require 'UI/ItemUI/ItemInfoUI'
local ItemIconUI = require 'UI/ItemUI/ItemIconUI'



StorageUI.classToType = {
    {
        ['text'] = "全部",
        ['types'] = {
            ItemTypeDetail.ItemType_Null,
        }
    },
    {
        ['text'] = "装备",
        ['types'] = {
            ItemTypeDetail.ItemType_Equipment,
        }
    },
    {
        ['text'] = "消耗",
        ['types'] = {
            ItemTypeDetail.ItemType_Consume,
        }
    },
    {
        ['text'] = "武学",
        ['types'] = {
            ItemTypeDetail.ItemType_Book, -- 特定使用23
        }
    },
    {
        ['text'] = "材料",
        ['types'] = {
            ItemTypeDetail.ItemType_Material,
        }
    },
    {
        ['text'] = "任务",
        ['types'] = {
            ItemTypeDetail.ItemType_Task,
        }
    },
    -- {
    --     ['text'] = "资产",
    --     ['paging'] = 'asset'
    -- }
}

-- 背包-消耗和材料
StorageUI.bringNav_XC = {
    {
        ['text'] = "全部",
        ['types'] = {
            ItemTypeDetail.ItemType_Null,
        }
    },
    {
        ['text'] = "装备",
        ['types'] = {
            ItemTypeDetail.ItemType_Equipment,
        }
    },
    {
        ['text'] = "消耗",
        ['types'] = {
            ItemTypeDetail.ItemType_Consume,
        }
    },
    {
        ['text'] = "武学",
        ['types'] = {
            ItemTypeDetail.ItemType_Book,
        }
    },
    {
        ['text'] = "材料",
        ['types'] = {
            ItemTypeDetail.ItemType_Material,
        }
    },
    {
        ['text'] = "任务",
        ['types'] = {
            ItemTypeDetail.ItemType_Task,
        }
    }  
}

local ChooseBringType = {
    Choose_XC = 1, --背包-消耗和材料
    Choose_ZRW = 2, --背包-装备，任务，武学
    Choose_All = 3  --背包全部
}

function StorageUI:Create()
	local obj = LoadPrefabAndInit("TownUI/StorageUI",UI_UILayer,true)
	if obj then
		self:SetGameObject(obj)
	end
end

function StorageUI:ShowImage(index)
    self.comWareHouseImage.color = DRCSRef.Color(1.0, 1.0, 1.0, index==1 and 1.0 or 0)
    self.comRecycleImage.color = DRCSRef.Color(1.0, 1.0, 1.0, index==2 and 1.0 or 0)
    self.comBringImage.color = DRCSRef.Color(1.0, 1.0, 1.0, index==3 and 1.0 or 0)
end

function StorageUI:Init()
    -- 其它数据
    self.mUpdateStorage = 0
    self.akInstItemList = {}
    self.matGray = LoadPrefab("Materials/UI_Gray", typeof(CS.UnityEngine.Material))
    self.bInGame = RoleDataManager:GetInstance():IsPlayerInGame() --玩家是否在剧本内
    self.storageMgr = StorageDataManager:GetInstance()
    -- 查找组件
    self.comItemIcon = ItemIconUI.new()
    self.objBackpack = self:FindChild(self._gameObject, "BackpackUI")
    self.comBackpackUINew = BackpackUIComNew.new({
        ['UIName'] = "StorageUI",
        ['objBind'] = self.objBackpack,  -- 背包实例绑定的ui节点
        ['navData'] = self.classToType,  -- 导航栏数据
        ['RowCount'] = 4,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 8,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = false,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)  -- 点击ItemInfo组件的回调, 可缺省
            self:OnClickBackItemInfo(obj, itemID)
        end,
        ['funcOnClickItemIcon'] = function(obj, itemID)  -- 点击ItemIcon组件的回调, 可缺省
            self:OnClickBackItemIcon(obj, itemID)
        end,
    })
    self.comBackpackUINew:SetSortButton(true)
    
    self.objBtnRecover = self:FindChild(self._gameObject, "Tab_box/Toggle_recycle/Toggle")
    self.objRecycle = self:FindChild(self._gameObject, "Tab_box/Toggle_recycle")
    self.comRecycleImage = self.objBtnRecover:GetComponent("Image")

    self.objBtnBring_XC = self:FindChild(self._gameObject, "Tab_box/Toggle_bring/Toggle")
    self.objBring = self:FindChild(self._gameObject, "Tab_box/Toggle_bring")
    self.comBringImage = self.objBtnBring_XC:GetComponent("Image")

    self.comBtnWareHouse = self:FindChildComponent(self._gameObject, "Tab_box/Toggle_warehouse/Toggle","Button")
    self.comWareHouseImage = self:FindChildComponent(self._gameObject, "Tab_box/Toggle_warehouse/Toggle","Image")
    self.objRecycle:SetActive(false)
    self:ShowImage(1)
    if self.bInGame == true then
        self.objBring:SetActive(true)
        local btnBring_XC = self.objBtnBring_XC:GetComponent("Button")
        self:AddButtonClickListener(btnBring_XC, function()
            self:OnClickBring()
            self:ShowImage(3)
        end)
        
        self:AddButtonClickListener(self.comBtnWareHouse,function()
            self.objBringToGame_XC:SetActive(false)
            self.objBackpack:SetActive(true)
            self:ShowImage(1)
        end)
        self.objRecycle:SetActive(false)

    else
        self.objBring:SetActive(false)
        self.objRecycle:SetActive(true)
        self.objBtnRecover:SetActive(true)
        local btnRecover = self.objBtnRecover:GetComponent("Button")
        self:AddButtonClickListener(btnRecover, function()
            self:OnClickRecover()
        end)
    end

    -- 带入剧本
    self.objBringToGame_XC = self:FindChild(self._gameObject, "BringToGame_XC")
    self.objBringPackLeft_XC = self:FindChild(self.objBringToGame_XC, "PackLeft")
    self.objBringPackRight_XC = self:FindChild(self.objBringToGame_XC, "PackRight")
    self.comLeftBackpackUINew_XC = BackpackUIComNew.new({
        ['objBind'] = self.objBringPackLeft_XC,  -- 背包实例绑定的ui节点
        ['navData'] = self.bringNav_XC,  -- 导航栏数据
        ['RowCount'] = 2,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 5,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = false,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)  -- 点击ItemInfo组件的回调, 可缺省
            self:SetItemFromLeft2Right(itemID)
        end,
        ['funcOnClickItemIcon'] = function(obj, itemID)
            local tips = TipsDataManager:GetInstance():GetItemTips(itemID)
            if not tips then
                return
            end
            tips['max_num'] = self.kLeftPackAllItemNumsMap[itemID]
            
            tips.buttons = {{
                ['name'] = "选中",
                ['func'] = function(num)
                    self:SetItemFromLeft2Right(itemID,num)
                end
            },
           
        } 
            OpenWindowImmediately("TipsPopUI", tips)
        end,
    })
    self.comLeftBackpackUINew_XC:SetSortButton(true)
    self.comRightBackpackUINew_XC = BackpackUIComNew.new({
        ['objBind'] = self.objBringPackRight_XC,  -- 背包实例绑定的ui节点
        ['navData'] = self.bringNav_XC,  -- 导航栏数据
        ['RowCount'] = 2,  -- 背包中一行包含的物品节点个数
        ['ColumnCount'] = 5,  -- 背包中一列包含的物品节点个数
        ['bCanShowLock'] = false,  -- 是否显示物品的锁定状态
        ['funcOnClickItemInfo'] = function(obj, itemID)  -- 点击ItemInfo组件的回调, 可缺省
            self:SetItemFromRight2Left(itemID)
        end,
        ['funcOnClickItemIcon'] = function(obj, itemID)
            local tips = TipsDataManager:GetInstance():GetItemTips(itemID)
            if not tips then
                return
            end
            tips.buttons = {{
                ['name'] = "取消选中",
                ['func'] = function(num)
                    self:SetItemFromRight2Left(itemID,num)
                end
            }}
            tips['max_num'] = self.kRightPackAllItemNumsMap[itemID]
            OpenWindowImmediately("TipsPopUI", tips)
        end,
    })
    self.objBringPackMsg_XC = self:FindChild(self.objBringToGame_XC, "Msg")
    local btnBringLimitExpand_XC = self:FindChildComponent(self.objBringPackMsg_XC, "Expand", "Button")
    self:AddButtonClickListener(btnBringLimitExpand_XC, function()
        self:OnClickBringLimitExpand()
    end)
    self.objBtnBringOK_XC = self:FindChild(self.objBringToGame_XC, "Button_ok")
    local btnBringOK_XC = self.objBtnBringOK_XC:GetComponent("Button")
    self:AddButtonClickListener(btnBringOK_XC, function()
        self:OnClickBringOK()
    end)
    self.objBtnBringClose_XC = self:FindChild(self.objBringToGame_XC, "Button_close")
    self.btnBringClose_XC = self.objBtnBringClose_XC:GetComponent("Button")
    self:AddButtonClickListener(self.btnBringClose_XC, function()
        self:OnClickBringClose(ChooseBringType.Choose_XC)
    end)
    

    -- 等待界面
    self.objPleaseWait = self:FindChild(self._gameObject, "PleaseWait")
    self.textWaitLoding = self:FindChildComponent(self.objPleaseWait, "LoadingText/Part2", "Text")
    self.objWaitItemList = self:FindChild(self.objPleaseWait, "ItemList")
    self.objWaitItemTemp = self:FindChild(self.objPleaseWait, "ItemIconUI")
    self.objWaitItemTemp:SetActive(false)
    -- 初始化
    self.objBringToGame_XC:SetActive(false)
    self.objPleaseWait:SetActive(false)
    self.objTextCopacity = self:FindChild(self._gameObject, 'Text_Copacity');
    
    local btnTips = self:FindChildComponent(self._gameObject, "Tips", "Button")
    if btnTips then
        self:AddButtonClickListener(btnTips, function()
            self:OnClickStorageTips()
        end)
    end

    self.objAllNavBox = {}
	-- 注册监听
    self:AddEventListener("UPDATE_STORAGE_ITEM",function() 
        self.mUpdateStorage = 2
    end,nil,nil,nil,true)
    -- 首次打开查询仓库数据
    StorageDataManager:GetInstance():RequestStorageData()

    self.btnExit = self:FindChildComponent(self._gameObject, "frame/Btn_exit", "Button")
    if self.btnExit then
        self:AddButtonClickListener(self.btnExit, function()
            RemoveWindowImmediately("StorageUI",false)
        end)
    end
end

function StorageUI:OnPressESCKey()
    if self.btnExit and self.btnBringClose and self.btnBringClose_XC then   --剧本内
        if self.objBringToGame_XC.activeSelf then
            self.btnBringClose_XC.onClick:Invoke()
        else
            self.btnExit.onClick:Invoke()
        end
    elseif  self.btnExit then  --剧本外
        self.btnExit.onClick:Invoke()
    end
end
function StorageUI:Update()
    if self.mUpdateStorage > 0 then 
        self.mUpdateStorage = self.mUpdateStorage - 1
    end
    if self.mUpdateStorage == 0 then
        self:RefreshUI()
    end

    self.comBackpackUINew:Update()
    if self.objBringToGame_XC.activeSelf then
        self.comLeftBackpackUINew_XC:Update()
        self.comRightBackpackUINew_XC:Update()
        --self:UpdateBringPackMsg()
    end
end

function StorageUI:GetBackPackSortFunc()
    if not self.funcBackPackSort then
        local TBItem = TableDataManager:GetInstance():GetTable("Item")
        self.funcBackPackSort = function(a, b)
            if self.auiNewItems then
                local bNewA = self.auiNewItems[a.uiID]
                local bNewB = self.auiNewItems[b.uiID]
                if bNewA and not bNewB then
                    return true
                elseif bNewB and not bNewA then
                    return false
                end
            end

            local typeDataA = TBItem[a.uiTypeID]
            local typeDataB = TBItem[b.uiTypeID]
            if typeDataA and typeDataB then
                if typeDataA.Rank == typeDataB.Rank then
                    return typeDataA.BaseID > typeDataB.BaseID
                else
                    return typeDataA.Rank > typeDataB.Rank
                end
            else
                return false;
            end
        end
    end
    return self.funcBackPackSort
end

function StorageUI:RefreshUI(info)
    -- 周末结束后打开,需要优先显示周目结算的物品
    self.auiNewItems = nil
    if info then
        self.auiNewItems = clone(info.auiNewItems)
    end

    self:RefreshNewItemsInfo()

    -- 刷新人物属性物品（资产）
    self.storageMgr:RefreshPlayerAsset()
    -- 刷新背包
    self.akInstItemList = self.storageMgr:GetAllInstItems() or {}
    if self.comBackpackUINew:GetPackSize() == 0 then
        self.comBackpackUINew:ShowPackByInstDataArray(self.akInstItemList, nil, {
            ['funcSort'] = self:GetBackPackSortFunc(),
        })
    else
        self.comBackpackUINew:ShowRefreshAndResetPackByInstItems(self.akInstItemList)
    end

    self:OnRefTextCopacity();
    StorageDataManager:GetInstance():ClearRecordStoryEndItems()
    self.mUpdateStorage = -1
end

function StorageUI:RefreshNewItemsInfo()
    ItemDataManager:GetInstance():ClearNewItemFlag()

    if self.auiNewItems then
        for itemid, flag in pairs(self.auiNewItems) do
            if flag == true then
                ItemDataManager:GetInstance():SetNewItemFlag(itemid)
            end
        end
    end

end

function StorageUI:OnEnable() 
    if self.bInGame == true then
        local winMgr = WindowsManager:GetInstance()
        local characerUI = winMgr:GetUIWindow("CharacterUI")
        if characerUI then
            characerUI:SetRoleSpineShow(false)
        end
    end

    self:AddEventListener("UPDATE_ITEM_DATA",function(info) 
        self:OnRefTextCopacity();
    end)
    self:ShowImage(1)
    self:OnRefTextCopacity()
end

function StorageUI:OnDisable()
    RemoveWindowBar('StorageUI')
    self.kWinBar = nil
    if self.bInGame == true then
        local winMgr = WindowsManager:GetInstance()
        local characerUI = winMgr:GetUIWindow("CharacterUI")
        if characerUI then
            characerUI:SetRoleSpineShow(true) 
            characerUI:SetWindowBar()
        end
    end

    self:RemoveEventListener("UPDATE_ITEM_DATA")
end

-- 获取仓库物品的数量
function StorageUI:GetItemNum(itemID)
    return self.storageMgr:GetItemNum(itemID) or 0
end

-- 设置按钮状态
function StorageUI:SetBtnState(objBtn, bActive)
    if not objBtn then return end
    bActive = (bActive ~= false)
    local imgBtn = objBtn:GetComponent("Image")
    local comBtn = objBtn:GetComponent("Button")
    if bActive then
        imgBtn.material = nil
    else
        imgBtn.material = self.matGray
    end
    comBtn.interactable = bActive
end

-- 点击背包物品信息组件
function StorageUI:OnClickBackItemInfo(obj, itemID)
    self:OnClickBackItemIcon(obj, itemID)
end

-- 点击背包物品图标组件
function StorageUI:OnClickBackItemIcon(obj, itemID)
    if not (obj and itemID) then
        return
    end
    local typeData = self.storageMgr:GetItemTypeData(itemID)
    if not typeData then
        derror("[StorageUI:OnClickBackItemIcon] can't get item excel data by dynamic id: " .. tostring(itemID))
        return
    end
    local typeID = typeData.BaseID
    local itemManager = ItemDataManager:GetInstance()
    local tips = TipsDataManager:GetInstance():GetItemTips(itemID, typeID)
    local btns = tips.buttons or {}
    -- 检查物品是有有 局外使用 特性
    local itemFeature = typeData.Feature
    local bCanUse = false

    -- 非伪造的物品都才能使用
    if itemID > 0 then
        if itemFeature and #itemFeature > 0 then
            for index, feature in ipairs(itemFeature) do
                if feature == ItemFeature.IF_Outside then
                    bCanUse = true
                    break
                end
            end
        end
    elseif itemID < 0 then
        -- 伪造物品根据配表加入跳转
        -- TODO: 没有判定窗口存不存在的接口 
        local itemData = self.storageMgr:GetItemData(itemID)
        if itemData and itemData.window then
            btns[#btns + 1] = {
                ["name"] = " 跳转",
                ['func'] = function(iNum)
                    OpenWindowImmediately(itemData.window, {ePageType = itemData.windowPage})
                end
            }
        end
    end
    
    if typeData.ItemType == ItemTypeDetail.ItemType_Formula and ItemDataManager:GetInstance():GetIfUnlockItemUnlocked(typeData) then 
        bCanUse = false 
    end 

    if bCanUse then
        if (not tips.uiDueTime) or (tips.uiDueTime and os.time() - tips.uiDueTime > 0) then
            btns[#btns + 1] = {
                ["name"] = "使用",
                ['func'] = function(iNum)
                    -- 检查物品合法性, 这里原本用接口返回值true时return, 但是用户在使用非法物品时服务器也需要知道并LogWarning
                    -- 所以这里调用这个接口只用作出一个警告框, 但是允许继续上行, 交给服务器二次判断并警告
                    StorageDataManager:GetInstance():IllegalItemCheckWithUID({[1] = itemID}, false)

                    -- 暂时针对可选礼包来做
                    if (typeData.EffectSubType == EffectSubType.EST_HouseChooseGift) then
                        OpenWindowImmediately("ItemRewardChooseUI",{["itemid"] = itemID, ["type"] = EffectSubType.EST_HouseChooseGift})
                    elseif (typeData.EffectType == EffectType.ETT_Item_UseItem_Coupon) then
                        OpenWindowImmediately("CouponUI", itemID)
                    elseif (typeData.EffectType == EffectType.ETT_Item_UseItem_SendRedEnvelope) then
                        local tempT = {};
                        tempT.showType = 1;
                        if typeData.EffectSubType == EffectSubType.EST_UseRedPacket then
                            tempT.redPacketType = RedPacketType.RPT_Money;
                        elseif typeData.EffectSubType == EffectSubType.EST_UseItemPacket then
                            tempT.redPacketType = RedPacketType.RPT_Item;
                        end
                        OpenWindowImmediately("MoneyPacketUI", tempT);

                    else
                        local list = { [0] = {["uiItemID"] = itemID,["uiItemNum"] = 1} }
                        SendUseStorageItem( 1,list)
                    end
                end
            }
            if itemManager:CanItemUsedInBatches(itemID,true) then
                local itemNum = itemManager:GetItemNum(itemID) or 0
                local strName = "全部使用"
                if itemNum > SSD_MAX_PLAT_ITEM_USEMAX_NUM then
                    strName = string.format("批量使用%d个", SSD_MAX_PLAT_ITEM_USEMAX_NUM)
                end
                btns[#btns + 1] = {
                    ["name"] = strName,
                    ['func'] = function(iNum)
                        -- 检查物品合法性, 这里原本用接口返回值true时return, 但是用户在使用非法物品时服务器也需要知道并LogWarning
                        -- 所以这里调用这个接口只用作出一个警告框, 但是允许继续上行, 交给服务器二次判断并警告
                        StorageDataManager:GetInstance():IllegalItemCheckWithUID({[1] = itemID}, false)
                        local list = { [0] = {["uiItemID"] = itemID,["uiItemNum"] = itemNum} }
                        SendUseStorageItem( 1,list)
                    end
                }
            end
        else
            btns[#btns + 1] = {
                ["name"] = dtext(1007),
                ['func'] = function(iNum)

                end,
            }
        end
    elseif itemType == ItemTypeDetail.ItemType_SecretBook then
            -- 如果角色没有学会这门武学, 那么显示一个学习按钮, 点击可以直接学习得到一级该武学
        local uiMartialBaseID = typeData.MartialID
        if uiMartialBaseID and (uiMartialBaseID > 0) then
            btns[#btns + 1] = {
                ["name"] = "研读",
                ['func'] = function()
                    UIHelper_OpenMartialStrongUI(uiMartialBaseID)
                end
            }
        end
    end
    tips.buttons = btns
    tips.pierce = true
    OpenWindowImmediately("TipsPopUI", tips)
end

-- 点击回收
function StorageUI:OnClickRecover()
    OpenWindowImmediately('ItemRecycleUI')
    RemoveWindowImmediately("StorageUI")
end

-- 点击带入剧本
function StorageUI:OnClickBring()
    self.objBringToGame_XC:SetActive(true)
    local windowBarUI = WindowsManager:GetInstance():GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:SetActive(false)
    end
    self.objBackpack:SetActive(false)
    self.aiRightPackAllItemIDs = nil
    self.kRightPackAllItemNumsMap = nil
    self.aiLeftPackAllItemIDs = nil
    self.kLeftPackAllItemNumsMap = nil
    self:UpdateBringBack()
end

--跟新带入物体
function StorageUI:UpdateBringBack()
    -- 分析数据
    if not self.aiLeftPackAllItemIDs then
        self.aiLeftPackAllItemIDs = {}
        self.kLeftPackAllItemNumsMap = {}
        local itemTypeData = nil
        local bIsPubItem = false
        local itemMgr = ItemDataManager:GetInstance()
        local itemID = nil
        for index, kInstItem in ipairs(self.akInstItemList) do
            itemID = kInstItem.uiID
            -- 排除伪造物品
            if not kInstItem.paging then
                itemTypeData = self.storageMgr:GetItemTypeData(itemID)
                self.aiLeftPackAllItemIDs[#self.aiLeftPackAllItemIDs + 1] = itemID
                self.kLeftPackAllItemNumsMap[itemID] = self.storageMgr:GetItemNum(itemID)
            end                                            
        end
        self.aiRightPackAllItemIDs = {}
        self.kRightPackAllItemNumsMap = {}
    end

    local sortFunc = self:GetBackPackSortFunc()
    local kFuncSet = {['funcSort'] = sortFunc}
    
    self:UpdateBring(self.comLeftBackpackUINew_XC, self.comRightBackpackUINew_XC, kFuncSet)
    -- 按钮初始状态
    self:SetBtnState(self.objBtnBringOK_XC, true)
    -- 更新信息栏
    self:UpdateBringPackMsg()

end

function StorageUI:UpdateBring(comLeft,comRight,kFuncSet)
    if comLeft:GetPackSize() == 0 then
        comLeft:ShowPackByInstIDArray(self.aiLeftPackAllItemIDs, self.kLeftPackAllItemNumsMap, kFuncSet)
    else
        comLeft:ShowRefreshAndResetPackByInstIDArray(self.aiLeftPackAllItemIDs, self.kLeftPackAllItemNumsMap)
    end

    if comRight:GetPackSize() == 0 then
        comRight:ShowPackByInstIDArray(self.aiRightPackAllItemIDs, self.kRightPackAllItemNumsMap, kFuncSet)
    else
        comRight:ShowRefreshAndResetPackByInstIDArray(self.aiRightPackAllItemIDs, self.kRightPackAllItemNumsMap)
    end
end

-- 点击关闭带入剧本
function StorageUI:OnClickBringClose()
    self.objBringToGame_XC:SetActive(false)
    local windowBarUI = WindowsManager:GetInstance():GetUIWindow("WindowBarUI")
    if windowBarUI then
        windowBarUI:SetActive(true)
    end
    self.objBackpack:SetActive(true)
end


-- 点击确认带入剧本
function StorageUI:OnClickBringOK()
    -- 向服务器发送 self.aiRightPackAllItemIDs
    if not (self.aiRightPackAllItemIDs and #self.aiRightPackAllItemIDs > 0) then
        return
    end
    local kBringInfoList = {}
    local aiBringBaseIDList = {}
    local uiSumCount = 0
    local kNumMap = self.kRightPackAllItemNumsMap or {}
    local kStorageMgr = StorageDataManager:GetInstance()
    local kItemMgr = ItemDataManager:GetInstance()
    for _, uID in ipairs(self.aiRightPackAllItemIDs) do
        kBringInfoList[uiSumCount] = {
            ["uiItemID"] = uID,
            ["uiItemNum"] = kNumMap[uID] or 1,
        }

        -- 解除将要带入物品的锁定状态(带入物品后, uid会发生变化, 旧的锁定状态将不再适用)
        kItemMgr:SetItemLockState(uID, false)
        -- 将物品baseid记录下来, 如果物品符合条件, 将在带入后重新锁定
        local kInstItem = kStorageMgr:GetItemData(uID)
        if kInstItem and kInstItem.uiTypeID then
            aiBringBaseIDList[#aiBringBaseIDList + 1] = kInstItem.uiTypeID
        end
        uiSumCount = uiSumCount + 1
      
 
     end
    -- 设置自动锁定列表
      SendStorageInScript(uiSumCount, kBringInfoList)
    kItemMgr:SetAutoLockCheckBaseIDList(aiBringBaseIDList)
    -- 展示镖车动画
    self:ShowWaitAnim()
    
end

-- 展示镖车动画
function StorageUI:ShowWaitAnim()
    if not (self.aiRightPackAllItemIDs and #self.aiRightPackAllItemIDs > 0) then
        return
    end
    self.objPleaseWait:SetActive(true)
    RemoveAllChildren(self.objWaitItemList)
    local objClone = nil
    local itemData = nil
    local itemMgr = ItemDataManager:GetInstance()
    local kNumMap = self.kRightPackAllItemNumsMap or {}
    for index, uID in ipairs(self.aiRightPackAllItemIDs) do
        objClone = CloneObj(self.objWaitItemTemp, self.objWaitItemList)
        if (objClone ~= nil) and (index <= 13) then
            itemData = itemMgr:GetItemData(uID)
            if itemData then
                self.comItemIcon:UpdateUIWithItemInstData(objClone, itemData)
                -- 设置物品为选中的数量
                self.comItemIcon:SetItemNum(objClone, kNumMap[uID] or 1)
                self.comItemIcon:RemoveClickFunc(objClone)
                objClone:SetActive(true)
            end
        end
    end
    local loadOverCall = function()
        self.objPleaseWait:SetActive(false)
        self:OnClickBringClose(ChooseBringType.Choose_All)
        RemoveWindowImmediately("StorageUI")
        SystemUICall:GetInstance():Toast("物品成功送达")
    end
    local animLoopTime = 4  -- 动画循环次数
    local textTwn = Twn_DoText(nil, self.textWaitLoding, "...", animLoopTime, loadOverCall)
    if (textTwn ~= nil) then
        textTwn:SetLoops(4, DRCSRef.LoopType.Restart)
        textTwn:SetAutoKill(true)
    end
end

-- 移除数组数据
function StorageUI:MoveItem(bToScript, itemID,num)
    local srcIDsArr, destIDsArr = nil, nil
    local srcNumsMap, destNumsMap = nil, nil
    if bToScript then
        srcIDsArr = self.aiLeftPackAllItemIDs
        destIDsArr = self.aiRightPackAllItemIDs
        srcNumsMap = self.kLeftPackAllItemNumsMap
        destNumsMap = self.kRightPackAllItemNumsMap
    else
        srcIDsArr = self.aiRightPackAllItemIDs
        destIDsArr = self.aiLeftPackAllItemIDs
        srcNumsMap = self.kRightPackAllItemNumsMap
        destNumsMap = self.kLeftPackAllItemNumsMap
    end
    if not (itemID and srcIDsArr and destIDsArr 
    and srcNumsMap and destNumsMap) then
        return
    end
    local iPosA, iPosB = nil, nil
    for i, uID in ipairs(srcIDsArr) do
        if uID == itemID then
            iPosA = i
            break
        end
    end
    if not iPosA then
        return
    end
   
    if num == nil then
        if destNumsMap[itemID] and (destNumsMap[itemID] > 0) then
            destNumsMap[itemID] = destNumsMap[itemID] +  srcNumsMap[itemID]
            srcNumsMap[itemID] = 0
        else
            destIDsArr[#destIDsArr + 1] = itemID
            destNumsMap[itemID] =srcNumsMap[itemID]
            srcNumsMap[itemID] = 0
        end          
    else
        srcNumsMap[itemID] = (srcNumsMap[itemID] or 1) - num
        if destNumsMap[itemID] and (destNumsMap[itemID] > 0) then
            destNumsMap[itemID] = destNumsMap[itemID] + num
        else
            destIDsArr[#destIDsArr + 1] = itemID
            destNumsMap[itemID] = num
        end
    end

    if srcNumsMap[itemID] <= 0 then
        table.remove(srcIDsArr, iPosA)
        srcNumsMap[itemID] = nil
    end

    if bToScript then
        self.aiLeftPackAllItemIDs = srcIDsArr
        self.aiRightPackAllItemIDs = destIDsArr
        self.aiLeftPackAllItemNums = srcNumsMap
        self.aiRightPackAllItemNums = destNumsMap
    else
        self.aiRightPackAllItemIDs = srcIDsArr
        self.aiLeftPackAllItemIDs = destIDsArr
        self.aiRightPackAllItemNums = srcNumsMap
        self.aiLeftPackAllItemNums = destNumsMap
    end

end

-- 将物品从左背包带入到右背包
function StorageUI:SetItemFromLeft2Right(itemID,num)
    -- 右背包满时不允许操作
    local iRightCount

    -- 检查物品合法性, 这里原本用接口返回值true时return, 但是用户在使用非法物品时服务器也需要知道并LogWarning
    -- 所以这里调用这个接口只用作出一个警告框, 但是允许继续上行, 交给服务器二次判断并警告
    StorageDataManager:GetInstance():IllegalItemCheckWithUID({[1] = itemID}, false)

    -- 将这个id从左背包移除 加入到右背包
    if self.objBringToGame_XC.activeSelf then
        self:MoveItem(true, itemID,num)
        iRightCount = self:GetBringPackItemCount(true, ChooseBringType.Choose_XC) or 0
        if iRightCount > self.bagSurplus then
            SystemUICall:GetInstance():Toast("请检查剧本背包剩余容量后带入")
            self:MoveItem(false, itemID,num)
            return
        end
        if iRightCount > self.iBringLimti_XC then
            SystemUICall:GetInstance():Toast("当前带入物品数量已达上限，请分多次带入")
            self:MoveItem(false, itemID,num)
            return
        end
        self:UpdateBringBack(ChooseBringType.Choose_XC)
        self:SetBtnState(self.objBtnBringOK_XC, true)
    end
end

-- 将物品从右背包带回到左背包
function StorageUI:SetItemFromRight2Left(itemID, num)
    local iRightCount 
    if self.objBringToGame_XC.activeSelf then
        iRightCount = self:GetBringPackItemCount(true)
        self:MoveItem(false, itemID, num)
        self:UpdateBringBack(ChooseBringType.Choose_XC)
        self:SetBtnState(self.objBtnBringOK_XC, iRightCount > 0)
    end  
end

-- 带入剧本 获取背包内物品数量
function StorageUI:GetBringPackItemCount(bRight)
    local kNumsMap = (bRight == true) and self.kRightPackAllItemNumsMap or self.kLeftPackAllItemNumsMap
    if not (kNumsMap and next(kNumsMap)) then
        return 0
    end
    local iCount = 0
    for iID, iNum in pairs(kNumsMap) do
        iCount = iCount + 1
    end
    return iCount
end

-- 带入剧本 信息栏 更新
function StorageUI:UpdateBringPackMsg()
 
    -- 数值
    local carryLimitNow, carryLimitMax, strReason = StorageDataManager:GetInstance():GetStorageCarryLimit()
    self.iBringLimit = carryLimitNow
    -- 背包上限
    local roleInfo = globalDataPool:getData("MainRoleInfo") or {}
    local mainRoleInfo = roleInfo["MainRole"]
    self.backpackSizeLimit = 0
    if mainRoleInfo then
        self.backpackSizeLimit = mainRoleInfo[MRIT_BAG_ITEMNUM] or 0
    end
    --剧情背包数量
    self.bagSurplus =self.backpackSizeLimit - RoleDataHelper.GetMainRoleBackpackSize()
    local textLable = self:FindChildComponent(self.objBringPackMsg_XC, 'Lable2', 'Text')
    local textLimitXC = self:FindChildComponent(self.objBringPackMsg_XC, "Remain", "Text")
    local iCurCountXC = self:GetBringPackItemCount(true, ChooseBringType.Choose_XC)
    -- 当前背包物品数量
    self.iBringLimti_XC = self.bagSurplus
    if self.iBringLimti_XC > 99 then
        self.iBringLimti_XC = 99
        textLable.text = "单次可带入"
    else
        textLable.text = "背包容量"
    end
    if self.iBringLimti_XC <= 0 then 
        self.iBringLimti_XC = 0
    end
    textLimitXC.text = string.format("%d/%d", iCurCountXC, self.iBringLimti_XC)
end

-- 点击仓库带入上限扩容
function StorageUI:OnClickBringLimitExpand()
    -- SystemUICall:GetInstance():Toast("开发中~")
    OpenWindowImmediately('TakeExtraUI');
end

function StorageUI:OnDestroy()
    self.comBackpackUINew:Close()
    self.comLeftBackpackUINew_XC:Close()
    self.comRightBackpackUINew_XC:Close()
    self.comItemIcon:Close()
end

function StorageUI:OnRefTextCopacity()
    local totalNum = StorageDataManager:GetInstance():GetAllItemNum();

    local strDesc = '';
    if totalNum > StorageCopacity then
        strDesc = '仓库容量：<color=#FF0000>%d</color>/%d';
    else
        strDesc = '仓库容量：<color=#323232>%d</color>/%d';
    end
    strDesc = string.format(strDesc, totalNum, StorageCopacity);
    self.objTextCopacity:GetComponent('Text').text = strDesc;
end

function StorageUI:OnClickStorageTips()
    OpenWindowImmediately("TipsPopUI", {
        title = '仓库规则',
        content = GetLanguageByID(560),
    })
end

return StorageUI